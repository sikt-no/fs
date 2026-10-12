// Hashen til tavla «Oppgaver»: `#/oppgaver`, `#/oppgaver/<dom>/<slug>` (oppgaven), `#/oppgaver/<dom>/<slug>/<spec-fil>`
// (spesifikasjonen i oppgaven), `#/oppgaver/<dom>/<slug>/ny` (ny spesifikasjon) og `#/oppgaver/ny-oppgave`.
// De gamle formene fra Spesifikasjoner og Oppgaver (`#/spesifikasjoner/…`, `#/oppgaver/tavle/…`, `#/oppgaver/mappe`)
// gjøres om til de nye, også i `kravforvaltning:hash`. Rene funksjoner, testet i tavleHash.test.ts.

/** Valget på tavla: null (ingenting), `ny-oppgave`, `<dom>/<slug>`, `<dom>/<slug>/<fil>` eller `<dom>/<slug>/ny` */
export type TavleSel = string | null;

export const NEW_TASK = 'ny-oppgave';

/** Hashen uten `#/`, avkodet → valget på tavla, eller `undefined` når hashen ikke er tavla */
export function parseTavleHash(h: string): { sel: TavleSel } | undefined {
  const parts = h.split('/').filter(Boolean);
  const [head, ...rest] = parts;
  if (head === 'spesifikasjoner') {
    // `#/spesifikasjoner/ny` var en ny spesifikasjon uten oppgave; den finnes ikke lenger
    return { sel: rest.length >= 3 ? rest.slice(0, 3).join('/') : rest.length === 2 ? rest.join('/') : null };
  }
  if (head !== 'oppgaver') return undefined;
  if (rest[0] === 'tavle') return { sel: rest.length >= 3 ? rest.slice(1, 3).join('/') : null };
  if (rest[0] === 'mappe') return { sel: rest.length >= 3 ? rest.slice(1, 3).join('/') : null };
  if (rest[0] === NEW_TASK) return { sel: NEW_TASK };
  if (rest.length >= 2) return { sel: rest.slice(0, 3).join('/') };
  return { sel: null };
}

export const tavleHash = (sel: TavleSel) => '#/oppgaver' + (sel ? '/' + encodeURI(sel) : '');

/** En lagret hash i en gammel form (`#/spesifikasjoner/…`, `#/oppgaver/tavle/…`) → den nye; andre hasher som de er */
export function normalizeHash(hash: string): string {
  let h = hash.replace(/^#\/?/, '');
  try {
    h = decodeURIComponent(h);
  } catch {
    return hash;
  }
  if (!/^(spesifikasjoner|oppgaver)(\/|$)/.test(h)) return hash;
  return tavleHash(parseTavleHash(h)?.sel ?? null);
}

/** `<dom>/<slug>/<fil>` → oppgaven (`<dom>/<slug>`) og spesifikasjonen (fila, `ny`, eller null) */
export function splitSel(sel: TavleSel): { task: string | null; spec: string | null; newTask: boolean } {
  if (!sel) return { task: null, spec: null, newTask: false };
  if (sel === NEW_TASK) return { task: null, spec: null, newTask: true };
  const [dom, slug, spec] = sel.split('/');
  return { task: dom && slug ? `${dom}/${slug}` : null, spec: spec ?? null, newTask: false };
}
