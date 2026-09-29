import { execFile } from 'node:child_process';
import { copyFile, mkdir, mkdtemp, rm, stat } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { promisify } from 'node:util';
import type { PublishRequest, PublishResult } from '../shared/api.ts';
import { gitDir, readGit } from '../server/git.ts';
import { branchName, checkPaths, githubPr, type OpenPr, type Vcs } from './vcs.ts';

const exec = promisify(execFile);

/**
 * Git og gh på maskinen, for utviklere som kjører dev-serveren. `publish` lager branchen i en
 * midlertidig worktree fra origin/main, så arbeidskatalogen, branchen og ucommittede filer står urørt.
 * Push bruker git sine egne innloggingsdata; PR-en opprettes via GitHub REST med tokenet fra `auth.ts`.
 */
export function cliVcs(repoRoot: string, opts: { openPr?: OpenPr } = {}): Vcs {
  const openPr = opts.openPr ?? githubPr;
  const git = async (cwd: string, ...args: string[]) => (await exec('git', ['-C', cwd, ...args], { maxBuffer: 32 << 20 })).stdout.trim();

  return {
    kind: 'cli',
    info: () => readGit(repoRoot),
    gitDir: () => gitDir(repoRoot),

    async publish(req: PublishRequest, token: string | null): Promise<PublishResult> {
      checkPaths(req.paths);
      if (!token) throw new Error('Ikke innlogget mot GitHub');
      const branch = branchName(req.branch);
      const origin = await git(repoRoot, 'remote', 'get-url', 'origin');
      if (await git(repoRoot, 'ls-remote', '--heads', 'origin', branch)) throw new Error(`Branchen ${branch} finnes allerede på GitHub`);

      await git(repoRoot, 'fetch', 'origin', 'main');
      const tmp = await mkdtemp(join(tmpdir(), 'krav-pr-'));
      const wt = join(tmp, 'wt');
      try {
        await git(repoRoot, 'worktree', 'add', '--no-track', '-b', branch, wt, 'origin/main');
        for (const p of req.paths) {
          const exists = await stat(join(repoRoot, p)).then(s => s.isFile(), () => false);
          if (exists) {
            await mkdir(dirname(join(wt, p)), { recursive: true });
            await copyFile(join(repoRoot, p), join(wt, p));
            await git(wt, 'add', '--', p);
          } else {
            // Slettet lokalt: fjern den også i branchen (om den finnes på main)
            await git(wt, 'rm', '--quiet', '--ignore-unmatch', '--', p);
          }
        }
        if (!(await git(wt, 'status', '--porcelain'))) throw new Error('Filene er like som på main, så det er ingenting å lage PR av');
        await git(wt, 'commit', '--quiet', '-m', req.title, ...(req.body ? ['-m', req.body] : []));
        await git(wt, 'push', '--quiet', '-u', 'origin', branch);
        return { url: await openPr(origin, token, { head: branch, base: 'main', title: req.title, body: req.body }), branch };
      } finally {
        await git(repoRoot, 'worktree', 'remove', '--force', wt).catch(() => {});
        await rm(tmp, { recursive: true, force: true });
        // Den lokale branchen trengs ikke; er den pushet, ligger den på GitHub
        await git(repoRoot, 'branch', '-D', branch).catch(() => {});
      }
    },
  };
}
