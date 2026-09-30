/** En PR Claude foreslår i svaret, som en `krav-pr`-blokk med JSON. Brukeren sender den selv med «Lag PR». */
export interface PrProposal {
  title: string;
  paths: string[];
  /** Filer Claude tok med som ikke kan sendes med «Lag PR» (utenfor krav/, eller ikke .feature/.md) */
  skipped: string[];
  branch: string | null;
  body: string;
}

/** Språket på kodeblokken Claude skriver forslaget i */
export const PR_LANG = 'krav-pr';

const str = (v: unknown) => (typeof v === 'string' ? v.trim() : '');

/** Samme krav til stiene som `publish` (`checkPaths` i `core/vcs.ts`): .feature eller .md under krav/, uten `..` */
const sendable = (p: string) => p.startsWith('krav/') && !p.split('/').some(s => s === '..' || s === '') && (p.endsWith('.feature') || p.endsWith('.md'));

/**
 * Tolker innholdet i en `krav-pr`-blokk. Filer som ikke kan sendes, legges i `skipped`.
 * Mangler tittel, eller er det ingen filer som kan sendes, gir den `null`, og blokken vises som kode.
 */
export function parsePrProposal(text: string): PrProposal | null {
  let v: unknown;
  try {
    v = JSON.parse(text);
  } catch {
    return null;
  }
  if (!v || typeof v !== 'object' || Array.isArray(v)) return null;
  const o = v as Record<string, unknown>;
  const title = str(o.title);
  if (!title || !Array.isArray(o.paths) || !o.paths.length) return null;
  const all = [...new Set(o.paths.map(p => str(p).replace(/^\.?\//, '')).filter(Boolean))];
  const paths = all.filter(sendable);
  if (!paths.length) return null;
  return { title, paths, skipped: all.filter(p => !sendable(p)), branch: str(o.branch) || null, body: str(o.body) };
}

/** «🤖 Generated with [Claude Code](…)» (eller «Generert med …») i beskrivelsen */
const GENERATED = /^\s*(?:🤖\s*)?(?:Generated with|Generert med)\s+\[?Claude Code\]?(?:\([^)]*\))?\s*$/gim;

/**
 * Beskrivelsen slik kortet viser den: uten «Generated with Claude Code»-linja, som vises som metadata i stedet.
 * PR-en får hele beskrivelsen, med linja.
 */
export function splitGenerated(body: string): { text: string; generated: boolean } {
  const text = body.replace(GENERATED, '');
  return { text: text.replace(/\n{3,}/g, '\n\n').trim(), generated: text !== body };
}
