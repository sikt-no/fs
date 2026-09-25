import { execFile } from 'node:child_process';
import { readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { promisify } from 'node:util';
import type { GitChange, GitCode, GitInfo } from '../shared/model.ts';

const exec = promisify(execFile);
const isKravFile = (p: string) => p.endsWith('.feature') || p.endsWith('.md');

/**
 * Leser endringer under krav/ med git: ucommitted (staget, ustaget og nye filer) mot HEAD,
 * og committet siden merge-base med main. Gir `null` utenfor et git-repo.
 */
export async function readGit(repoRoot: string): Promise<GitInfo | null> {
  const git = async (...args: string[]) => (await exec('git', ['-C', repoRoot, ...args], { maxBuffer: 32 << 20 })).stdout;
  const tryGit = (...args: string[]) => git(...args).then(s => s.trim(), () => null);

  const branch = await tryGit('rev-parse', '--abbrev-ref', 'HEAD');
  if (branch === null) return null;
  const base = (await tryGit('merge-base', 'HEAD', 'main')) ?? (await tryGit('merge-base', 'HEAD', 'origin/main'));

  const diff = async (...range: string[]): Promise<GitChange[]> => {
    const args = ['diff', '--no-renames', '-z', ...range];
    const [names, nums] = await Promise.all([git(...args, '--name-status', '--', 'krav'), git(...args, '--numstat', '--', 'krav')]);
    const stats = new Map<string, [number, number]>();
    // numstat -z: «pluss\tminus\tsti\0»; binærfiler har «-»
    for (const rec of nums.split('\0')) {
      const [p, m, path] = rec.split('\t');
      if (path) stats.set(path, [Number(p) || 0, Number(m) || 0]);
    }
    // name-status -z: «M\0sti\0»
    const parts = names.split('\0');
    const out: GitChange[] = [];
    for (let i = 0; i + 1 < parts.length; i += 2) {
      const path = parts[i + 1];
      if (!isKravFile(path)) continue;
      const code = (parts[i][0] === 'A' || parts[i][0] === 'D' ? parts[i][0] : 'M') as GitCode;
      const [plus, minus] = stats.get(path) ?? [0, 0];
      out.push({ path, code, plus, minus });
    }
    return out;
  };

  const untracked = async (): Promise<GitChange[]> => {
    const paths = (await git('ls-files', '-z', '--others', '--exclude-standard', '--', 'krav')).split('\0').filter(isKravFile);
    return Promise.all(
      paths.map(async path => {
        const text = await readFile(join(repoRoot, path), 'utf8').catch(() => '');
        const plus = text ? text.split('\n').length - (text.endsWith('\n') ? 1 : 0) : 0;
        return { path, code: 'U' as const, plus, minus: 0 };
      }),
    );
  };

  try {
    const [tracked, fresh, committed, commits] = await Promise.all([
      diff('HEAD'),
      untracked(),
      base ? diff(base, 'HEAD') : Promise.resolve([]),
      base ? tryGit('rev-list', '--count', `${base}..HEAD`) : Promise.resolve('0'),
    ]);
    const byPath = (a: GitChange, b: GitChange) => a.path.localeCompare(b.path, 'nb');
    return { branch, commits: Number(commits) || 0, uncommitted: [...tracked, ...fresh].sort(byPath), committed: committed.sort(byPath) };
  } catch {
    return null;
  }
}

/** Mappen der git holder HEAD og index (håndterer også worktrees). */
export async function gitDir(repoRoot: string): Promise<string | null> {
  try {
    return (await exec('git', ['-C', repoRoot, 'rev-parse', '--absolute-git-dir'])).stdout.trim();
  } catch {
    return null;
  }
}
