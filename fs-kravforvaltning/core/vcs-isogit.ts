import fs from 'node:fs';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import git, { TREE, type TreeEntry } from 'isomorphic-git';
import http from 'isomorphic-git/http/node';
import type { PublishRequest, PublishResult } from '../shared/api.ts';
import type { GitChange, GitCode, GitInfo } from '../shared/model.ts';
import { branchName, checkPaths, githubPr, type OpenPr, type Vcs } from './vcs.ts';

const isKravFile = (p: string) => p.startsWith('krav/') && (p.endsWith('.feature') || p.endsWith('.md'));
const byPath = (a: GitChange, b: GitChange) => a.path.localeCompare(b.path, 'nb');
const auth = (token: string | null) => (token ? () => ({ username: 'x-access-token', password: token }) : undefined);

/** Omtrentlig antall linjer lagt til og fjernet: linjer som bare finnes på den ene siden (som multimengde) */
export function lineStats(before: string, after: string): [number, number] {
  const count = (s: string) => {
    const m = new Map<string, number>();
    if (s) for (const l of s.replace(/\n$/, '').split('\n')) m.set(l, (m.get(l) ?? 0) + 1);
    return m;
  };
  const a = count(before);
  const b = count(after);
  let plus = 0;
  let minus = 0;
  for (const [l, n] of b) plus += Math.max(0, n - (a.get(l) ?? 0));
  for (const [l, n] of a) minus += Math.max(0, n - (b.get(l) ?? 0));
  return [plus, minus];
}

/**
 * isomorphic-git: git i ren JS, uten git-installasjon. Brukes av desktop-appen (som eier sin egen klone),
 * og kan prøves i dev-serveren med `VCS=isogit`.
 *
 * `publish` bygger committen direkte i objektdatabasen, på toppen av origin/main, og pusher den som en ny branch.
 * Arbeidskatalogen, index og HEAD røres ikke, så brukerens lokale endringer står som før.
 */
export function isoVcs(dir: string, opts: { openPr?: OpenPr } = {}): Vcs {
  const cache = {};
  const blobText = async (oid: string) => new TextDecoder().decode((await git.readBlob({ fs, dir, oid, cache })).blob);

  /** Endringer mellom to trær under krav/ (commit-oider) */
  const diffTrees = async (from: string, to: string): Promise<GitChange[]> => {
    const out: GitChange[] = [];
    await git.walk({
      fs,
      dir,
      cache,
      trees: [TREE({ ref: from }), TREE({ ref: to })],
      map: async (path, [a, b]) => {
        if (path === '.') return true;
        if (!(path === 'krav' || path.startsWith('krav/'))) return null; // hopp over alt utenfor krav/
        const [ta, tb] = [await a?.type(), await b?.type()];
        if (ta === 'tree' || tb === 'tree') return true;
        if (!isKravFile(path)) return null;
        const [oa, ob] = [await a?.oid(), await b?.oid()];
        if (oa === ob) return null;
        const code: GitCode = !oa ? 'A' : !ob ? 'D' : 'M';
        const [plus, minus] = lineStats(oa ? await blobText(oa) : '', ob ? await blobText(ob) : '');
        out.push({ path, code, plus, minus });
        return null;
      },
    });
    return out;
  };

  /** Ucommittede endringer under krav/ mot HEAD (staget, ustaget og nye filer) */
  const uncommitted = async (): Promise<GitChange[]> => {
    const rows = await git.statusMatrix({ fs, dir, cache, filepaths: ['krav'], filter: isKravFile });
    const head = await git.resolveRef({ fs, dir, ref: 'HEAD' });
    const out: GitChange[] = [];
    for (const [path, h, w, s] of rows) {
      if (h === 1 && w === 1 && s === 1) continue; // uendret
      const code: GitCode = h === 0 ? (s === 0 ? 'U' : 'A') : w === 0 ? 'D' : 'M';
      const before = h ? await git.readBlob({ fs, dir, oid: head, filepath: path, cache }).then(r => new TextDecoder().decode(r.blob)) : '';
      const after = w ? await readFile(join(dir, path), 'utf8').catch(() => '') : '';
      const [plus, minus] = lineStats(before, after);
      if (code === 'M' && !plus && !minus) continue; // bare filmodus eller linjeslutt
      out.push({ path, code, plus, minus });
    }
    return out;
  };

  /**
   * Nytt tre der `path` er satt til `blob` (eller fjernet med `null`), bygget ut fra `tree`.
   * Skriver de nye trærne til objektdatabasen og returnerer oid-en til rota.
   */
  const setInTree = async (tree: string | null, parts: string[], blob: string | null): Promise<string | null> => {
    const entries: TreeEntry[] = tree ? (await git.readTree({ fs, dir, oid: tree, cache })).tree : [];
    const [name, ...rest] = parts;
    const i = entries.findIndex(e => e.path === name);
    const next = rest.length
      ? await setInTree(i >= 0 && entries[i].type === 'tree' ? entries[i].oid : null, rest, blob)
      : blob;
    if (i >= 0) entries.splice(i, 1);
    if (next) entries.push({ mode: rest.length ? '040000' : '100644', path: name, oid: next, type: rest.length ? 'tree' : 'blob' });
    if (!entries.length) return null; // tom mappe finnes ikke i git
    return git.writeTree({ fs, dir, tree: entries });
  };

  const originUrl = async () => {
    const url = (await git.getConfig({ fs, dir, path: 'remote.origin.url' })) as string | undefined;
    if (!url) throw new Error('Klonen mangler origin');
    return url;
  };
  const openPr = opts.openPr ?? githubPr;

  /** Forfatter fra git-konfigurasjonen, ellers GitHub-brukeren med noreply-adresse */
  const author = async (token: string) => {
    const name = (await git.getConfig({ fs, dir, path: 'user.name' })) as string | undefined;
    const email = (await git.getConfig({ fs, dir, path: 'user.email' })) as string | undefined;
    if (name && email) return { name, email };
    const res = await fetch('https://api.github.com/user', { headers: { authorization: `Bearer ${token}`, accept: 'application/vnd.github+json' } });
    if (!res.ok) throw new Error(`Fant ikke GitHub-brukeren (${res.status})`);
    const u = (await res.json()) as { id: number; login: string; name?: string | null };
    return { name: u.name || u.login, email: `${u.id}+${u.login}@users.noreply.github.com` };
  };

  const fetchMain = (token: string | null, shallow: boolean) =>
    git.fetch({ fs, http, dir, cache, remote: 'origin', ref: 'main', singleBranch: true, tags: false, ...(shallow ? { depth: 1 } : {}), onAuth: auth(token) });

  const isShallow = () => fs.promises.access(join(dir, '.git', 'shallow')).then(() => true, () => false);

  return {
    kind: 'isogit',

    async info(): Promise<GitInfo | null> {
      try {
        const branch = (await git.currentBranch({ fs, dir })) ?? 'HEAD';
        const head = await git.resolveRef({ fs, dir, ref: 'HEAD' });
        const main = await git.resolveRef({ fs, dir, ref: 'main' }).catch(() => git.resolveRef({ fs, dir, ref: 'refs/remotes/origin/main' }).catch(() => null));
        let committed: GitChange[] = [];
        let commits = 0;
        if (main && main !== head) {
          const [base] = await git.findMergeBase({ fs, dir, cache, oids: [head, main] }).catch(() => [] as string[]);
          if (base) {
            committed = await diffTrees(base, head);
            const log = await git.log({ fs, dir, cache, ref: head }).catch(() => []);
            const at = log.findIndex(c => c.oid === base);
            commits = at >= 0 ? at : 0;
          }
        }
        return { branch, commits, uncommitted: (await uncommitted()).sort(byPath), committed: committed.sort(byPath) };
      } catch {
        return null;
      }
    },

    async gitDir() {
      return fs.promises.access(join(dir, '.git')).then(() => join(dir, '.git'), () => null);
    },

    async publish(req: PublishRequest, token: string | null): Promise<PublishResult> {
      checkPaths(req.paths);
      if (!token) throw new Error('Ikke innlogget mot GitHub');
      const branch = branchName(req.branch);
      const url = await originUrl();
      const remoteRefs = await git.listServerRefs({ http, url, prefix: `refs/heads/${branch}`, onAuth: auth(token) });
      if (remoteRefs.some(r => r.ref === `refs/heads/${branch}`)) throw new Error(`Branchen ${branch} finnes allerede på GitHub`);

      await fetchMain(token, await isShallow());
      const parent = await git.resolveRef({ fs, dir, ref: 'refs/remotes/origin/main' });
      let tree: string | null = (await git.readCommit({ fs, dir, oid: parent, cache })).commit.tree;
      const baseTree = tree;
      for (const p of req.paths) {
        const text = await readFile(join(dir, p)).catch(() => null);
        const blob = text ? await git.writeBlob({ fs, dir, blob: new Uint8Array(text) }) : null;
        tree = await setInTree(tree, p.split('/'), blob);
      }
      if (!tree || tree === baseTree) throw new Error('Filene er like som på main, så det er ingenting å lage PR av');

      const who = await author(token);
      const now = { timestamp: Math.floor(Date.now() / 1000), timezoneOffset: new Date().getTimezoneOffset() };
      const oid = await git.writeCommit({
        fs,
        dir,
        commit: {
          tree,
          parent: [parent],
          author: { ...who, ...now },
          committer: { ...who, ...now },
          message: req.body ? `${req.title}\n\n${req.body}\n` : `${req.title}\n`,
        },
      });
      const ref = `refs/heads/${branch}`;
      await git.writeRef({ fs, dir, ref, value: oid, force: true });
      try {
        const res = await git.push({ fs, http, dir, cache, remote: 'origin', ref, remoteRef: ref, onAuth: auth(token) });
        if (!res.ok) throw new Error(`Push feilet: ${res.error ?? 'ukjent feil'}`);
      } finally {
        // Den lokale branchen trengs ikke; er den pushet, ligger den på GitHub
        await git.deleteRef({ fs, dir, ref }).catch(() => {});
      }
      return { url: await openPr(url, token, { head: branch, base: 'main', title: req.title, body: req.body }), branch };
    },

    async behind(token: string | null) {
      const refs = await git.listServerRefs({ http, url: await originUrl(), prefix: 'refs/heads/main', onAuth: auth(token) });
      const remote = refs.find(r => r.ref === 'refs/heads/main')?.oid;
      return !!remote && remote !== (await git.resolveRef({ fs, dir, ref: 'refs/heads/main' }));
    },

    /**
     * Henter siste main og oppdaterer filene som ikke er endret lokalt. Lokale endringer (f.eks. i en PR som
     * ikke er merget ennå) blir stående; blir de like som på main, er de ikke lenger en endring.
     */
    async pull(token: string | null) {
      if ((await git.currentBranch({ fs, dir })) !== 'main') throw new Error('Klonen står ikke på main');
      const before = await git.resolveRef({ fs, dir, ref: 'HEAD' });
      await fetchMain(token, await isShallow());
      const after = await git.resolveRef({ fs, dir, ref: 'refs/remotes/origin/main' });
      if (before === after) return;
      const local = new Set((await git.statusMatrix({ fs, dir, cache })).filter(([, h, w, s]) => !(h === 1 && w === 1 && s === 1)).map(([p]) => p));
      const changed: string[] = [];
      await git.walk({
        fs,
        dir,
        cache,
        trees: [TREE({ ref: before }), TREE({ ref: after })],
        map: async (path, [a, b]) => {
          if (path === '.') return true;
          const [ta, tb] = [await a?.type(), await b?.type()];
          if (ta === 'tree' || tb === 'tree') return true;
          if ((await a?.oid()) !== (await b?.oid())) changed.push(path);
          return null;
        },
      });
      await git.writeRef({ fs, dir, ref: 'refs/heads/main', value: after, force: true });
      const update: string[] = [];
      for (const p of changed.filter(p => !local.has(p))) {
        const onMain = await git.readBlob({ fs, dir, oid: after, filepath: p, cache }).then(() => true, () => false);
        if (onMain) update.push(p);
        else {
          // Slettet på main og ikke endret lokalt
          await fs.promises.rm(join(dir, p), { force: true });
          await git.remove({ fs, dir, cache, filepath: p });
        }
      }
      if (update.length) await git.checkout({ fs, dir, cache, ref: 'main', filepaths: update, force: true });
      // Lokale endringer som nå er like som på main (en merget PR): oppdater index, så de ikke vises som endret
      for (const p of changed.filter(p => local.has(p))) {
        const onMain = await git.readBlob({ fs, dir, oid: after, filepath: p, cache }).then(r => Buffer.from(r.blob), () => null);
        const mine = await readFile(join(dir, p)).catch(() => null);
        if (onMain && mine && onMain.equals(mine)) await git.add({ fs, dir, cache, filepath: p });
      }
    },
  };
}

/** Kloner repoet til `dir` hvis det ikke finnes der (desktop-appen, første oppstart) */
export async function ensureClone(dir: string, url: string, token: string | null, onProgress?: (msg: string) => void) {
  if (await fs.promises.access(join(dir, '.git')).then(() => true, () => false)) return false;
  await fs.promises.mkdir(dir, { recursive: true });
  await git.clone({
    fs,
    http,
    dir,
    url,
    ref: 'main',
    singleBranch: true,
    depth: 1,
    onAuth: auth(token),
    onProgress: onProgress && (e => onProgress(`${e.phase}${e.total ? ` ${Math.round((e.loaded / e.total) * 100)} %` : ''}`)),
  });
  return true;
}
