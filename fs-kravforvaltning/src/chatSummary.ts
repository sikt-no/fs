// Oppsummeringen av en samtale, som en `krav-oppsummering`-blokk med JSON. Brukes når en skill er oppdatert,
// og samtalen må fortsette i en ny samtale med den nye versjonen.

export interface ChatSummary {
  mal: string;
  gjort: string;
  beslutninger: string;
  apneSporsmal: string;
  nesteSteg: string;
  /** Filene som er viktige for å fortsette, relative til repoet */
  paths: string[];
}

/** Språket på kodeblokken Claude skriver oppsummeringen i */
export const SUMMARY_LANG = 'krav-oppsummering';

/** Seksjonene på kortet og i utkastet, i fast rekkefølge */
export const SUMMARY_SECTIONS: [keyof Omit<ChatSummary, 'paths'>, string][] = [
  ['mal', 'Mål'],
  ['gjort', 'Gjort'],
  ['beslutninger', 'Beslutninger'],
  ['apneSporsmal', 'Åpne spørsmål'],
  ['nesteSteg', 'Neste steg'],
];

/** Den faste meldingen bak «Oppsummer samtalen» */
export const SUMMARY_PROMPT =
  'Oppsummer samtalen så den kan brukes som start på en ny samtale: mål, hva som er gjort, beslutninger, åpne spørsmål og neste steg, ' +
  'og filene som er viktige for å fortsette. Svar bare med oppsummeringen, i en kodeblokk med språket krav-oppsummering og JSON ' +
  '(feltene mal, gjort, beslutninger, apneSporsmal, nesteSteg og paths).';

/** Det brukeren ser i stedet for `SUMMARY_PROMPT` i samtalen */
export const SUMMARY_PROMPT_SHORT = 'Mål, hva som er gjort, beslutninger, åpne spørsmål og neste steg.';

const str = (v: unknown) => (typeof v === 'string' ? v.trim() : Array.isArray(v) ? v.filter(x => typeof x === 'string').join('\n').trim() : '');

/** Tolker innholdet i en `krav-oppsummering`-blokk. Er den ikke gyldig JSON, eller helt tom, gir den `null`, og blokken vises som kode. */
export function parseSummary(text: string): ChatSummary | null {
  let v: unknown;
  try {
    v = JSON.parse(text);
  } catch {
    return null;
  }
  if (!v || typeof v !== 'object' || Array.isArray(v)) return null;
  const o = v as Record<string, unknown>;
  const paths = Array.isArray(o.paths)
    ? [...new Set(o.paths.map(p => (typeof p === 'string' ? p.trim().replace(/^.*?\/(krav\/|tasks\/)/, '$1').replace(/^\.?\//, '') : '')).filter(Boolean))]
    : [];
  const s: ChatSummary = { mal: str(o.mal), gjort: str(o.gjort), beslutninger: str(o.beslutninger), apneSporsmal: str(o.apneSporsmal), nesteSteg: str(o.nesteSteg), paths };
  return SUMMARY_SECTIONS.some(([k]) => s[k]) ? s : null;
}

/** Teksten som legges i inputfeltet i den nye samtalen */
export function summaryDraft(s: ChatSummary): string {
  const parts = SUMMARY_SECTIONS.filter(([k]) => s[k]).map(([k, label]) => `${label}: ${s[k]}`);
  return ['Fortsetter fra en tidligere samtale:', ...parts].join('\n\n');
}

/** Filene som kan legges ved med @ i den nye samtalen (bare under krav/, som `mentionPaths` i core/claude.ts) */
export const summaryMentions = (s: ChatSummary) => s.paths.filter(p => p.startsWith('krav/') && !p.split('/').includes('..'));

const BLOCK = new RegExp('^```' + SUMMARY_LANG + '[ \\t]*\\r?\\n([\\s\\S]*?)^```', 'm');

/** Oppsummeringen i et svar fra Claude, når svaret har en gyldig `krav-oppsummering`-blokk */
export function summaryIn(text: string): ChatSummary | null {
  const m = BLOCK.exec(text);
  return m ? parseSummary(m[1]) : null;
}
