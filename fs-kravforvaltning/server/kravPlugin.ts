import type { Plugin } from 'vite';
import type { FocusEvent } from '../shared/model.ts';
import { createApi, dispatch } from '../core/api.ts';
import { createAuth, memoryStore } from '../core/auth.ts';
import { ClaudeRunner } from '../core/claude.ts';
import { PtyRunner } from '../core/pty.ts';
import { cliVcs } from '../core/vcs-cli.ts';
import { isoVcs } from '../core/vcs-isogit.ts';
import { Workspace, type WorkspaceOpts } from '../core/workspace.ts';

const VIRTUAL = 'virtual:krav';
const RESOLVED = '\0' + VIRTUAL;
const VIRTUAL_GIT = 'virtual:krav-git';
const RESOLVED_GIT = '\0' + VIRTUAL_GIT;
const VIRTUAL_TASKS = 'virtual:krav-tasks';
const RESOLVED_TASKS = '\0' + VIRTUAL_TASKS;
const VIRTUAL_ROOT = 'virtual:krav-root';
const RESOLVED_ROOT = '\0' + VIRTUAL_ROOT;

/**
 * Leser alle .feature- og .md-filer under krav/ (krav/README.md er forsiden), parser dem
 * og eksponerer dem som `virtual:krav`. I dev-server pushes endringer som `krav:update`-hendelser over websocket.
 * Git-endringer under krav/ eksponeres som `virtual:krav-git` og pushes som `krav:git`.
 * Oppgavemappene i tasks/ eksponeres som `virtual:krav-tasks` og pushes som `krav:tasks`, men bare med `oppgaver` eller
 * `spesifikasjoner`; ellers er modulen `null`. Flaggene i snapshotet sier hvilke av visningene vieweren viser.
 * `virtual:krav-root` er den absolutte stien til repoet («Åpne i VS Code»), bare i dev-serveren; i et statisk bygg er den `null`.
 *
 * Logikken står i core/ (felles med desktop-appen); pluginen kobler den til Vites watcher, websocket og
 * middlewares. I dev-serveren kan krav redigeres (`POST /__krav/save`) og sendes som PR (`POST /__krav/publish`).
 * Git-backenden er git og gh på maskinen, eller isomorphic-git med `VCS=isogit`.
 */
export function kravPlugin(repoRoot: string, opts: WorkspaceOpts = {}): Plugin {
  const vcs = process.env.VCS === 'isogit' ? isoVcs(repoRoot) : cliVcs(repoRoot);
  const ws = new Workspace(repoRoot, vcs, opts);
  let serve = false;

  return {
    name: 'krav',

    configResolved(config) {
      serve = config.command === 'serve';
    },

    async buildStart() {
      // Git-endringer gir bare mening lokalt; i et statisk bygg (CI, grunn klone av main) utelates de
      await ws.readAll({ withGit: serve });
    },

    resolveId(id) {
      if (id === VIRTUAL) return RESOLVED;
      if (id === VIRTUAL_GIT) return RESOLVED_GIT;
      if (id === VIRTUAL_TASKS) return RESOLVED_TASKS;
      if (id === VIRTUAL_ROOT) return RESOLVED_ROOT;
    },

    load(id) {
      if (id === RESOLVED) return `export default ${JSON.stringify(ws.entries)};`;
      if (id === RESOLVED_GIT) return `export default ${JSON.stringify(ws.git)};`;
      if (id === RESOLVED_TASKS) return `export default ${JSON.stringify(ws.tasks)};`;
      if (id === RESOLVED_ROOT) return `export default ${JSON.stringify(serve ? ws.repoRoot : null)};`;
    },

    configureServer(server) {
      // Filene Claude skriver under tasks/ (spec/, skisser) skal vises i «Endringer» også uten Oppgaver og Spesifikasjoner
      const claude = new ClaudeRunner(repoRoot, { onSaved: () => ws.refreshGit(), onDone: () => ws.refreshGit() });
      const pty = new PtyRunner(repoRoot, { bin: () => claude.binary() });
      const api = createApi(ws, createAuth({ clientId: process.env.KRAV_GITHUB_CLIENT_ID, store: memoryStore(), useGh: true }), claude, pty);
      claude.on(data => server.ws.send({ type: 'custom', event: 'krav:claude', data }));
      pty.on(data => server.ws.send({ type: 'custom', event: 'krav:pty', data }));
      server.watcher.add(ws.kravDir);
      if (ws.withTasks) server.watcher.add(ws.tasksDir);

      // Hendelsene fra arbeidsflaten går ut over websocket; en manuell reload skal få ferskt innhold
      const invalidate = (id: string) => {
        const mod = server.moduleGraph.getModuleById(id);
        if (mod) server.moduleGraph.invalidateModule(mod);
      };
      ws.on('krav:update', data => {
        invalidate(RESOLVED);
        server.ws.send({ type: 'custom', event: 'krav:update', data });
      });
      ws.on('krav:git', data => {
        invalidate(RESOLVED_GIT);
        server.ws.send({ type: 'custom', event: 'krav:git', data });
      });
      ws.on('krav:tasks', data => {
        invalidate(RESOLVED_TASKS);
        server.ws.send({ type: 'custom', event: 'krav:tasks', data });
      });
      void ws.watchGit();
      server.httpServer?.on('close', () => {
        ws.close();
        claude.close();
        pty.close();
      });

      server.watcher.on('add', abs => ws.onFs('add', abs));
      server.watcher.on('change', abs => ws.onFs('change', abs));
      server.watcher.on('unlink', abs => ws.onFs('unlink', abs));
      server.watcher.on('addDir', abs => ws.onDir(abs));
      server.watcher.on('unlinkDir', abs => ws.onDir(abs));

      const readBody = (req: import('node:http').IncomingMessage) =>
        new Promise<string>((ok, fail) => {
          let body = '';
          req.on('data', chunk => (body += chunk));
          req.on('end', () => ok(body));
          req.on('error', fail);
        });

      // VS Code-utvidelsen (fs-kravforvaltning/vscode/) melder hvilken fil og linje som er aktiv i editoren
      server.middlewares.use('/__krav/focus', async (req, res) => {
        if (req.method !== 'POST') {
          res.statusCode = 405;
          return res.end();
        }
        let data: FocusEvent;
        try {
          const { path, line, to } = JSON.parse(await readBody(req));
          // `path: null`: en annen fil enn et krav er i fokus i editoren
          if (path === null) {
            server.ws.send({ type: 'custom', event: 'krav:blur' });
            res.statusCode = 204;
            return res.end();
          }
          if (typeof path !== 'string') throw new Error();
          const num = (n: unknown) => (typeof n === 'number' ? n : null);
          data = { path, line: num(line), to: num(to) ?? num(line) };
        } catch {
          res.statusCode = 400;
          return res.end();
        }
        if (!ws.entries[data.path]) {
          res.statusCode = 404;
          return res.end();
        }
        server.ws.send({ type: 'custom', event: 'krav:focus', data });
        res.statusCode = 204;
        res.end();
      });

      // Redigering og PR: `POST /__krav/<kall>` med JSON-argument, svar `{ ok, value }` eller `{ ok: false, error }`
      server.middlewares.use('/__krav/api', async (req, res) => {
        const method = (req.url ?? '').replace(/^\//, '').split('?')[0];
        res.setHeader('content-type', 'application/json');
        // Bare kall fra vieweren selv; en annen side i nettleseren skal ikke kunne skrive filer eller lage PR
        const origin = req.headers.origin;
        if (req.method !== 'POST' || (origin && new URL(origin).host !== req.headers.host)) {
          res.statusCode = 403;
          return res.end(JSON.stringify({ ok: false, error: 'Ikke tillatt' }));
        }
        try {
          const body = await readBody(req);
          const value = await dispatch(api, method, body ? JSON.parse(body) : undefined);
          res.end(JSON.stringify({ ok: true, value: value ?? null }));
        } catch (e) {
          res.statusCode = 400;
          res.end(JSON.stringify({ ok: false, error: e instanceof Error ? e.message : String(e) }));
        }
      });
    },
  };
}
