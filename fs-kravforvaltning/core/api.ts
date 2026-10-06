import { readFile } from 'node:fs/promises';
import type { Api, ApiMethod, Boot } from '../shared/api.ts';
import { API_METHODS } from '../shared/api.ts';
import type { Auth } from './auth.ts';
import type { ClaudeRunner } from './claude.ts';
import { deleteFile, kravPath, saveFile } from './save.ts';
import type { Workspace } from './workspace.ts';

/**
 * Kallene rendereren kan gjøre, felles for dev-serveren (`POST /__krav/api/<navn>`) og Electron (IPC).
 * Transporten pakker bare inn og ut; all logikk står her og i modulene under.
 */
export function createApi(ws: Workspace, auth: Auth, claude: ClaudeRunner): Api & { boot(): Boot } {
  const vcs = () => {
    if (!ws.vcs) throw new Error('Git er ikke tilgjengelig');
    return ws.vcs;
  };
  return {
    boot: () => ({ entries: ws.entries, git: ws.git, tasks: ws.tasks, editable: true, repoRoot: ws.repoRoot }),
    read: path => readFile(kravPath(ws.repoRoot, path), 'utf8'),
    save: req => saveFile(ws.repoRoot, req.path, req.text),
    remove: path => deleteFile(ws.repoRoot, path),
    async publish(req) {
      const res = await vcs().publish(req, await auth.token());
      ws.refreshGit();
      return res;
    },
    authStatus: () => auth.status(),
    authStart: () => auth.start(),
    authPoll: () => auth.poll(),
    authLogout: () => auth.logout(),
    async pull() {
      const v = vcs();
      if (!v.pull) throw new Error('Henting gjøres med git i dev-serveren');
      await v.pull(await auth.token());
      await ws.readAll();
      return { entries: ws.entries, git: ws.git, tasks: ws.tasks };
    },
    async mainStatus() {
      const v = ws.vcs;
      if (!v?.mainStatus) return null;
      try {
        return await v.mainStatus(await auth.token());
      } catch {
        return null; // uten nett eller tilgang: ikke noe å melde
      }
    },
    claudeStatus: () => claude.status(),
    claudeRun: req => claude.run(req),
    claudeCancel: runId => claude.cancel(runId),
    claudeActive: async () => claude.active(),
    claudeApprove: req => claude.approve(req),
    claudePending: async () => claude.pending(),
    claudeSkills: async () => claude.skills(),
    claudeDirs: async paths => claude.dirs(paths),
    pickDir: async () => {
      throw new Error('Mappevelgeren finnes bare i desktop-appen');
    },
  };
}

/** Kaller en metode med argument fra transporten, med sjekk av navnet */
export function dispatch(api: Api, method: string, arg: unknown): Promise<unknown> {
  if (!(API_METHODS as string[]).includes(method)) return Promise.reject(new Error(`Ukjent kall: ${method}`));
  return (api[method as ApiMethod] as (a: unknown) => Promise<unknown>)(arg);
}
