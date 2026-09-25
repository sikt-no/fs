import { readdirSync, readFileSync, statSync, watch } from 'node:fs';
import { join, relative, sep } from 'node:path';
import type { Plugin } from 'vite';
import type { FocusEvent, GitInfo, Snapshot, UpdateEvent } from '../shared/model.ts';
import { gitDir, readGit } from './git.ts';
import { buildEntry } from './parse.ts';

const VIRTUAL = 'virtual:krav';
const RESOLVED = '\0' + VIRTUAL;
const VIRTUAL_GIT = 'virtual:krav-git';
const RESOLVED_GIT = '\0' + VIRTUAL_GIT;
const isKravFile = (p: string) => p.endsWith('.feature') || p.endsWith('.md');

/**
 * Leser alle .feature- og .md-filer under krav/ (krav/README.md er forsiden), parser dem
 * og eksponerer dem som `virtual:krav`. I dev-server pushes endringer som `krav:update`-hendelser over websocket.
 * Git-endringer under krav/ eksponeres som `virtual:krav-git` og pushes som `krav:git`.
 */
export function kravPlugin(repoRoot: string): Plugin {
  const kravDir = join(repoRoot, 'krav');
  const entries: Snapshot = {};
  let git: GitInfo | null = null;
  let serve = false;
  const rel = (abs: string) => relative(repoRoot, abs).split(sep).join('/');

  const load = (abs: string) => {
    const path = rel(abs);
    entries[path] = buildEntry(path, readFileSync(abs, 'utf8'), statSync(abs).mtimeMs, entries[path]);
    return entries[path];
  };

  return {
    name: 'krav',

    configResolved(config) {
      serve = config.command === 'serve';
    },

    async buildStart() {
      // Git-endringer gir bare mening lokalt; i et statisk bygg (CI, grunn klone av main) utelates de
      git = serve ? await readGit(repoRoot) : null;
      for (const f of readdirSync(kravDir, { recursive: true, encoding: 'utf8' })) {
        if (isKravFile(f)) load(join(kravDir, f));
      }
    },

    resolveId(id) {
      if (id === VIRTUAL) return RESOLVED;
      if (id === VIRTUAL_GIT) return RESOLVED_GIT;
    },

    load(id) {
      if (id === RESOLVED) return `export default ${JSON.stringify(entries)};`;
      if (id === RESOLVED_GIT) return `export default ${JSON.stringify(git)};`;
    },

    configureServer(server) {
      server.watcher.add(kravDir);

      // Les git-status på nytt når krav-filer eller git (commit, stage, checkout) endres
      let gitTimer: ReturnType<typeof setTimeout> | undefined;
      const refreshGit = () => {
        clearTimeout(gitTimer);
        gitTimer = setTimeout(async () => {
          const next = await readGit(repoRoot);
          if (JSON.stringify(next) === JSON.stringify(git)) return;
          git = next;
          const mod = server.moduleGraph.getModuleById(RESOLVED_GIT);
          if (mod) server.moduleGraph.invalidateModule(mod);
          server.ws.send({ type: 'custom', event: 'krav:git', data: git });
        }, 300);
      };
      // Vite overvåker ikke .git/, så følg HEAD, index og reflog direkte. Git bytter filene ut
      // atomisk (via .lock + rename), derfor overvåkes mappene og ikke filene.
      gitDir(repoRoot).then(dir => {
        if (!dir) return;
        const targets: [string, string[]][] = [
          [dir, ['HEAD', 'index']],
          [join(dir, 'logs'), ['HEAD']],
        ];
        const watchers = targets.flatMap(([d, names]) => {
          try {
            return [watch(d, (_e, f) => f && names.includes(f) && refreshGit())];
          } catch {
            return [];
          }
        });
        server.httpServer?.on('close', () => watchers.forEach(w => w.close()));
      });

      const onFs = (event: 'add' | 'change' | 'unlink') => (abs: string) => {
        if (!abs.startsWith(kravDir) || !isKravFile(abs)) return;
        let data: UpdateEvent;
        if (event === 'unlink') {
          delete entries[rel(abs)];
          data = { path: rel(abs), entry: null };
        } else {
          try {
            data = { path: rel(abs), entry: load(abs) };
          } catch {
            return; // filen forsvant mellom hendelse og lesing
          }
        }
        // Sørg for at en manuell reload får ferskt innhold
        const mod = server.moduleGraph.getModuleById(RESOLVED);
        if (mod) server.moduleGraph.invalidateModule(mod);
        server.ws.send({ type: 'custom', event: 'krav:update', data });
        refreshGit();
      };
      server.watcher.on('add', onFs('add'));
      server.watcher.on('change', onFs('change'));
      server.watcher.on('unlink', onFs('unlink'));

      // VS Code-utvidelsen (viewer/vscode/) melder hvilken fil og linje som er aktiv i editoren
      server.middlewares.use('/__krav/focus', (req, res) => {
        if (req.method !== 'POST') {
          res.statusCode = 405;
          return res.end();
        }
        let body = '';
        req.on('data', chunk => (body += chunk));
        req.on('end', () => {
          let data: FocusEvent;
          try {
            const { path, line, to } = JSON.parse(body);
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
          if (!entries[data.path]) {
            res.statusCode = 404;
            return res.end();
          }
          server.ws.send({ type: 'custom', event: 'krav:focus', data });
          res.statusCode = 204;
          res.end();
        });
      });
    },
  };
}
