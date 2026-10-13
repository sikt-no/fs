/**
 * Oppdatering av desktop-appen fra GitHub-releasene (electron/updater.ts). Repoet har releaser for andre ting
 * også, så «Latest» kan ikke brukes: releasen finnes ved å filtrere på tagg-prefikset.
 */

export const RELEASE_TAG_PREFIX = 'fs-kravforvaltning-v';

/** Det vi bruker fra `GET /repos/{owner}/{repo}/releases` */
export interface Release {
  tag_name: string;
  draft: boolean;
  prerelease: boolean;
}

/** `1.2.0` → `[1, 2, 0]`, eller `null` for en versjon som ikke er `x.y.z` */
function parse(version: string): number[] | null {
  const m = /^(\d+)\.(\d+)\.(\d+)$/.exec(version);
  return m ? m.slice(1).map(Number) : null;
}

/** Negativ når `a` er eldre enn `b`, positiv når den er nyere */
export function compareVersions(a: string, b: string): number {
  const x = parse(a) ?? [0, 0, 0];
  const y = parse(b) ?? [0, 0, 0];
  for (let i = 0; i < 3; i++) if (x[i] !== y[i]) return x[i] - y[i];
  return 0;
}

/** Taggen til den nyeste publiserte releasen av appen, eller `null` når det ikke finnes noen */
export function latestReleaseTag(releases: Release[]): string | null {
  let best: string | null = null;
  for (const r of releases) {
    if (r.draft || r.prerelease || !r.tag_name.startsWith(RELEASE_TAG_PREFIX)) continue;
    const version = r.tag_name.slice(RELEASE_TAG_PREFIX.length);
    if (!parse(version)) continue;
    if (!best || compareVersions(version, best.slice(RELEASE_TAG_PREFIX.length)) > 0) best = r.tag_name;
  }
  return best;
}

/**
 * Kortet vises når en ny versjon er lastet ned, med mindre brukeren har valgt «Senere» for akkurat den versjonen.
 * Da står knappen «<versjon> Start på nytt» i toppfeltet i stedet
 */
export function updateToastShown(downloaded: string | null, laterVersion: string | null): boolean {
  return !!downloaded && downloaded !== laterVersion;
}
