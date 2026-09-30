// Utkastet i Claude-feltet: teksten, @-vedleggene, fila som er tatt ut med ✕, og skillvalget før første samtale.
// Det lagres i localStorage, så det overlever «Hent siste» (som laster vieweren på nytt) og at panelet lukkes.
// Rene funksjoner, så de kan testes med node --test. Lagringen står nederst.

export interface ClaudeDraft {
  text: string;
  mentions: string[];
  /** Fila brukeren har tatt ut av konteksten med ✕ */
  excluded: string | null;
  /** Skillen som er valgt før den første samtalen finnes */
  pending: string | null;
}

export const EMPTY_DRAFT: ClaudeDraft = { text: '', mentions: [], excluded: null, pending: null };

const str = (v: unknown) => (typeof v === 'string' ? v : null);

/** Et lagret utkast; ukjent eller ødelagt innhold gir tomt utkast */
export function parseDraft(raw: unknown): ClaudeDraft {
  if (!raw || typeof raw !== 'object') return EMPTY_DRAFT;
  const d = raw as Record<string, unknown>;
  return {
    text: str(d.text) ?? '',
    mentions: Array.isArray(d.mentions) ? d.mentions.filter((p): p is string => typeof p === 'string') : [],
    excluded: str(d.excluded),
    pending: str(d.pending),
  };
}

export const isEmptyDraft = (d: ClaudeDraft) => !d.text && !d.mentions.length && d.excluded === null && d.pending === null;

const KEY = 'kravforvaltning:claudeDraft';
export function readDraft(): ClaudeDraft {
  try {
    return parseDraft(JSON.parse(localStorage.getItem(KEY) ?? 'null'));
  } catch {
    return EMPTY_DRAFT;
  }
}
export function saveDraft(d: ClaudeDraft) {
  try {
    if (isEmptyDraft(d)) localStorage.removeItem(KEY);
    else localStorage.setItem(KEY, JSON.stringify(d));
  } catch {
    /* utilgjengelig lagring: utkastet lever bare i minnet */
  }
}
