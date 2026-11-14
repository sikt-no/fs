// Verify-rapportene fra fs-verify og fs-verify-agent-teams: `verify-*.md`, og rapportvisningen (`verify-*.html`)
// når den finnes ved siden av. De ligger i krav/, tasks/<d>/<s>/spec/ og akseptansetest/<slug>/, og vises i
// visningen Verifisering, ikke i Krav. Felles for core/, server/ og rendereren.

/** Mappene i repoet verify-rapportene ligger i */
export const VERIFY_ROOTS = ['krav', 'tasks', 'akseptansetest'] as const;

const NAME = /^verify-[^/]*\.(md|html)$/;
const base = (p: string) => p.slice(p.lastIndexOf('/') + 1);
const clean = (p: string) => typeof p === 'string' && !p.includes('\\') && !p.split('/').some(s => s === '..' || s === '.' || s === '');

/** Filnavnet er en verify-rapport (`verify-*.md`) eller rapportvisningen (`verify-*.html`), uansett mappe */
export const isVerifyName = (p: string) => NAME.test(base(p.split('\\').join('/')));

/** En verify-fil (`.md` eller `.html`) i en av `VERIFY_ROOTS`, relativt til repo-roten */
export const isVerifyFile = (p: string) => clean(p) && (VERIFY_ROOTS as readonly string[]).includes(p.split('/')[0]) && isVerifyName(p);

/** Verify-rapporten (`verify-*.md`) */
export const isVerifyReport = (p: string) => isVerifyFile(p) && p.endsWith('.md');

/** Rapportvisningen (`verify-*.html`) */
export const isVerifyHtml = (p: string) => isVerifyFile(p) && p.endsWith('.html');

/** Rapportvisningen som hører til rapporten: samme navn, `.html` i stedet for `.md` */
export const htmlOf = (p: string) => p.replace(/\.md$/, '.html');

export interface VerifyReport {
  /** Rapporten, relativt til repo-roten */
  path: string;
  /** Teksten i rapporten */
  source: string;
  /** Rapportvisningen ved siden av (`htmlOf(path)`), eller `null` når den ikke finnes */
  html: string | null;
  savedAt: number;
  /** Når rapportvisningen sist ble endret, så den hentes på nytt; `null` uten rapportvisning */
  htmlAt: number | null;
}

/** Rapportene, med stien som nøkkel */
export type VerifySnapshot = Record<string, VerifyReport>;

const DATE = /-?(\d{4}-\d{2}-\d{2})(?:-(\d{2})(\d{2}))?(-\d+)?$/;

/**
 * Navnet og datoen i treet: `verify-automatisk_kvalifisering-2026-11-03-1519.md` gir `automatisk_kvalifisering` og
 * `2026-11-03 15:19`. Uten noe mellom `verify-` og datoen er navnet `verify`. Uten dato er datoen `null`.
 */
export function reportName(path: string): { name: string; date: string | null } {
  const stem = base(path).replace(/^verify-?/, '').replace(/\.md$/, '');
  const m = DATE.exec(stem);
  const name = (m ? stem.slice(0, m.index) : stem) || 'verify';
  const date = m ? m[1] + (m[2] ? ` ${m[2]}:${m[3]}` : '') + (m[4] ?? '') : null;
  return { name, date };
}
