// @-omtale i Claude-feltet: filer og mapper fra krav/-treet som legges ved meldingen.
// Rene funksjoner, så de kan testes med node --test. Visningen står i MentionPicker.tsx.
import type { MentionHit, MentionItem } from './search.ts';

export type MentionFilter = 'all' | 'dir' | 'file';

/** Søketeksten etter en `@` på slutten av teksten (også tom), eller `null` når det ikke skrives en omtale */
export function parseMention(text: string): string | null {
  const m = text.match(/(^|\s)@([^@\n]*)$/);
  return m ? m[2] : null;
}

/** Teksten uten `@søk` på slutten */
export const stripMention = (text: string) => text.replace(/(^|\s)@[^@\n]*$/, '$1');

const under = (p: string, dir: string) => p.startsWith(dir + '/');

/** Er `path` allerede med, selv eller via en mappe over? */
export const covered = (mentions: string[], path: string) => mentions.some(m => m === path || under(path, m));

/** Legger til `paths`. En mappe dekker alt under seg: det som ligger under en valgt mappe legges ikke til, og en ny mappe tar over for det under den. */
export function addMentions(mentions: string[], paths: string[]): string[] {
  let out = [...mentions];
  for (const p of paths) {
    if (covered(out, p)) continue;
    out = out.filter(m => !under(m, p));
    out.push(p);
  }
  return out;
}

/** Stien til foreldremappa uten `krav/`, avkortet forfra */
export function shortPath(p: string, max = 38): string {
  const s = p.replace(/^krav\/?/, '') || 'krav';
  return s.length > max ? '…' + s.slice(-max) : s;
}

export type MentionRow = MentionHit;

export interface MentionList {
  dirs: MentionRow[];
  files: MentionRow[];
  moreDirs: number;
  moreFiles: number;
  /** Radene i visningsrekkefølge, for piltastene */
  flat: MentionRow[];
}

/** Treffene delt i mapper og filer. Med «Alle» vises 5 mapper og 7 filer, med ett av filtrene 14. */
export function mentionList(hits: MentionRow[], filter: MentionFilter): MentionList {
  const all = filter === 'all';
  const d = filter === 'file' ? [] : hits.filter(h => h.item.dir);
  const f = filter === 'dir' ? [] : hits.filter(h => !h.item.dir);
  const dirs = d.slice(0, all ? 5 : 14);
  const files = f.slice(0, all ? 7 : 14);
  return { dirs, files, moreDirs: d.length - dirs.length, moreFiles: f.length - files.length, flat: [...dirs, ...files] };
}

/**
 * Det som vises før brukeren har skrevet noe: de sist brukte omtalene som fortsatt finnes,
 * ellers fila brukeren ser på og mappa den ligger i.
 */
export function recentMentions(recent: string[], current: string | null, items: Map<string, MentionItem>): MentionHit[] {
  const paths = recent.length ? recent : current ? [current.slice(0, current.lastIndexOf('/')), current] : [];
  return paths.map(p => items.get(p)).filter((i): i is MentionItem => !!i).map(item => ({ item, ranges: [] }));
}

/** De sist brukte først, uten duplikater, høyst `max` */
export const pushRecent = (recent: string[], paths: string[], max = 6) => [...new Set([...[...paths].reverse(), ...recent])].slice(0, max);
