import type { GitInfo } from '../shared/model.ts';
import type { PublishRequest, PublishResult } from '../shared/api.ts';

/**
 * Git-operasjonene vieweren trenger. `vcs-cli.ts` bruker git og gh på maskinen (utviklere),
 * `vcs-isogit.ts` er ren JS og trenger ingen git-installasjon (desktop-appen).
 */
export interface Vcs {
  readonly kind: 'cli' | 'isogit';
  /** Endringer under krav/ (for «Endringer»-modusen). `null` utenfor et git-repo. */
  info(): Promise<GitInfo | null>;
  /** Mappen der git holder HEAD og index, for overvåking */
  gitDir(): Promise<string | null>;
  /** Lag branch fra origin/main med filene slik de er på disk, push, og opprett PR */
  publish(req: PublishRequest, token: string | null): Promise<PublishResult>;
  /** Hent siste main fra origin (bare desktop-appen, som eier klonen) */
  pull?(token: string | null): Promise<void>;
}

/** `krav/<slug>`: små bokstaver, a–z, 0–9 og bindestrek; æøå skrives som ae/o/a */
export function branchName(input: string): string {
  const slug = input
    .toLowerCase()
    .replace(/æ/g, 'ae')
    .replace(/ø/g, 'o')
    .replace(/å/g, 'a')
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9/-]+/g, '-')
    .replace(/\/+/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '')
    .slice(0, 60)
    .replace(/-$/, '');
  if (!slug) throw new Error('Branchnavnet kan ikke være tomt');
  return 'krav/' + slug;
}

/** `https://github.com/eier/repo(.git)` eller `git@github.com:eier/repo(.git)` → eier og repo */
export function githubRepo(url: string): { owner: string; repo: string } | null {
  const m = url.trim().match(/github\.com[/:]([^/]+)\/([^/]+?)(?:\.git)?\/?$/);
  return m ? { owner: m[1], repo: m[2] } : null;
}

/** Oppretter PR-en ut fra origin-URL-en; byttes ut i tester */
export type OpenPr = (originUrl: string, token: string, pr: { head: string; base: string; title: string; body: string }) => Promise<string>;

/** Oppretter en PR via GitHub REST. Brukes av begge backendene når det finnes et token. */
export async function createPullRequest(
  token: string,
  repo: { owner: string; repo: string },
  pr: { head: string; base: string; title: string; body: string },
): Promise<string> {
  const res = await fetch(`https://api.github.com/repos/${repo.owner}/${repo.repo}/pulls`, {
    method: 'POST',
    headers: {
      authorization: `Bearer ${token}`,
      accept: 'application/vnd.github+json',
      'x-github-api-version': '2022-11-28',
      'content-type': 'application/json',
    },
    body: JSON.stringify(pr),
  });
  const data = (await res.json().catch(() => ({}))) as { html_url?: string; message?: string; errors?: { message?: string }[] };
  if (!res.ok || !data.html_url) {
    const detail = data.errors?.map(e => e.message).filter(Boolean).join('; ');
    throw new Error(`GitHub svarte ${res.status}: ${data.message ?? 'ukjent feil'}${detail ? ` (${detail})` : ''}`);
  }
  return data.html_url;
}

/** PR på GitHub-repoet origin peker på */
export const githubPr: OpenPr = async (url, token, pr) => {
  const repo = githubRepo(url);
  if (!repo) throw new Error('origin peker ikke på et GitHub-repo');
  return createPullRequest(token, repo, pr);
};

/** Stiene i en PR må være krav-filer under krav/, uten `..` */
export function checkPaths(paths: string[]) {
  if (!paths.length) throw new Error('Velg minst én fil');
  for (const p of paths) {
    if (!p.startsWith('krav/') || p.split('/').some(s => s === '..' || s === '') || !(p.endsWith('.feature') || p.endsWith('.md'))) {
      throw new Error(`Ugyldig sti: ${p}`);
    }
  }
}
