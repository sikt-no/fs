// Hashen til tavla «Scopes»: `#/scopes`, `#/scopes/<dom>/<slug>` (scopet), `#/scopes/<dom>/<slug>/<spec-fil>`
// (spesifikasjonen i scopet), `#/scopes/<dom>/<slug>/ny` (ny spesifikasjon) og `#/scopes/nytt-scope`.
// De gamle formene fra Spesifikasjoner og Oppgaver (`#/spesifikasjoner/…`, `#/oppgaver/…`, `#/oppgaver/tavle/…`,
// `#/oppgaver/mappe`) gjøres om til de nye, også i `kravforvaltning:hash`, og oppgavene som ble slått sammen til
// scopes, får slugen til scopet. Rene funksjoner, testet i tavleHash.test.ts.

/** Valget på tavla: null (ingenting), `nytt-scope`, `<dom>/<slug>`, `<dom>/<slug>/<fil>` eller `<dom>/<slug>/ny` */
export type TavleSel = string | null;

export const NEW_TASK = 'nytt-scope';

/** Oppgavene som fikk navnet til scopet da oppgave og scope ble slått sammen: `<dom>/<oppgave>` → scope-slugen */
const OLD_TASKS: Record<string, string> = {
  'brukeradministrasjon-og-tilgangsstyring/appadmin-etter-design-review': 'applikasjoner-etter-design-review',
  'brukeradministrasjon-og-tilgangsstyring/organisasjonsfiltre-med-akronym': 'restanser-etter-onboarding',
  'brukeradministrasjon-og-tilgangsstyring/tildele-roller-forretningsroller': 'restanser-etter-onboarding',
  'brukeradministrasjon-og-tilgangsstyring/roller-gjelder-for': 'synlighet-og-gjelder-for',
  'brukeradministrasjon-og-tilgangsstyring/synlighet-via-aktiv-rolle': 'synlighet-og-gjelder-for',
  'opptak/kvoter-i-opptaket': 'kvoter-i-opptaket-2027',
  'opptak/opprette-og-vedlikeholde-opptak': 'opprette-opptak-2027',
  'opptak/plasstildeling': 'plasstildeling-2027',
  'opptak/gjennomfore-plasstildeling': 'plasstildeling-2027',
  'opptak/plasstildeling-rundetyper-og-runder': 'plasstildeling-2027',
  'opptak/publisere-og-svare-pa-tilbud': 'plasstildeling-2027',
  'opptak/regelverk': 'regelverk-2027',
  'opptak/tilbudsgaranti': 'tilbudsgaranti-2027',
  'opptak/utdanningstilbud': 'utdanningstilbud-2027',
  'opptak/behandle-utdanningstilbud': 'utdanningstilbud-2027',
  'opptak/opptaksinnstillinger': 'utdanningstilbud-2027',
  'opptak/hente-fra-utdanningsregisteret': 'utdanningstilbud-i-opptak-2027',
  'opptak/utdanningstilbud-i-opptak': 'utdanningstilbud-i-opptak-2027',
};

/** `<dom>/<slug>[/…]` fra en gammel oppgave → det samme i scopet den ble slått inn i */
const renamed = (parts: string[]) => {
  const to = OLD_TASKS[`${parts[0]}/${parts[1]}`];
  return to ? [parts[0], to, ...parts.slice(2)] : parts;
};

/** Hashen uten `#/`, avkodet → valget på tavla, eller `undefined` når hashen ikke er tavla */
export function parseTavleHash(h: string): { sel: TavleSel } | undefined {
  const parts = h.split('/').filter(Boolean);
  const [head, ...rest] = parts;
  if (head === 'spesifikasjoner') {
    // `#/spesifikasjoner/ny` var en ny spesifikasjon uten oppgave; den finnes ikke lenger
    return { sel: rest.length >= 3 ? renamed(rest).slice(0, 3).join('/') : rest.length === 2 ? renamed(rest).join('/') : null };
  }
  if (head === 'oppgaver') {
    if (rest[0] === 'tavle') return { sel: rest.length >= 3 ? renamed(rest.slice(1, 3)).join('/') : null };
    if (rest[0] === 'mappe') return { sel: rest.length >= 3 ? renamed(rest.slice(1, 3)).join('/') : null };
    if (rest[0] === 'ny-oppgave') return { sel: NEW_TASK };
    if (rest.length >= 2) return { sel: renamed(rest).slice(0, 3).join('/') };
    return { sel: null };
  }
  if (head !== 'scopes') return undefined;
  if (rest[0] === NEW_TASK) return { sel: NEW_TASK };
  if (rest.length >= 2) return { sel: rest.slice(0, 3).join('/') };
  return { sel: null };
}

export const tavleHash = (sel: TavleSel) => '#/scopes' + (sel ? '/' + encodeURI(sel) : '');

/** En lagret hash i en gammel form (`#/spesifikasjoner/…`, `#/oppgaver/…`) → den nye; andre hasher som de er */
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

/** `<dom>/<slug>/<fil>` → scopet (`<dom>/<slug>`) og spesifikasjonen (fila, `ny`, eller null) */
export function splitSel(sel: TavleSel): { task: string | null; spec: string | null; newTask: boolean } {
  if (!sel) return { task: null, spec: null, newTask: false };
  if (sel === NEW_TASK) return { task: null, spec: null, newTask: true };
  const [dom, slug, spec] = sel.split('/');
  return { task: dom && slug ? `${dom}/${slug}` : null, spec: spec ?? null, newTask: false };
}
