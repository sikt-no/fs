// Spesifikasjonene fra fs-specify og fs-specify-delta (`tasks/<d>/<s>/spec/spec-*.md`), tolket for
// Spesifikasjoner-visningen, og skrevet tilbake når de redigeres der. Bare seksjonene som er endret, skrives om;
// resten av dokumentet (Kilde, Retagging, felt som «Lagrede artefakter») blir stående. Rene funksjoner, testet i spec.test.ts.

export type SketchKind = 'OK' | 'Avvik' | 'Uavklart';

/** Ett `- **Felt:** verdi`-punkt i en skisse, med linjene som hører til (også innrykkede underpunkter) */
export interface SketchField {
  key: string;
  lines: string[];
}

export interface Sketch {
  name: string;
  url: string;
  kind: SketchKind;
  /** Det som står etter statusen i «Valideringsstatus» (hva som avviker, merknader) */
  note: string;
  /** «Dekker krav», som tekst */
  dekker: string;
  /** Alle feltene slik de står, så felt vieweren ikke kjenner (Type, Lagrede artefakter), skrives tilbake uendret */
  fields: SketchField[];
}

export interface KravRef {
  /** Filnavnet: `opprett_opptak.feature` */
  file: string;
  /** Feature-ID: `@OPT-OVO-GRU-001` (tom når punktet mangler den) */
  id: string;
  /** Stien under krav/ når den kan leses ut av lenken, ellers null */
  path: string | null;
  /** Står under «Skal fjernes» (`@deprecated`): koden skal bort */
  remove: boolean;
}

export interface Question {
  t: string;
  done: boolean;
}

export interface SpecDoc {
  title: string;
  delta: boolean;
  omfang: string;
  krav: KravRef[];
  skisser: Sketch[];
  /** «Ingen skisse: <grunn>» under Skisser */
  ingenSkisse: string | null;
  sporsmal: Question[];
  /** Forslag til rute fra fs-specify (`## Rute`), i rekkefølge */
  rute: string[];
}

const ID = /@[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-[A-ZÆØÅ]{3}-\d{3}/;
/** Underseksjoner av Krav som ikke er med i spesifikasjonen */
const OUT_OF_SCOPE = /utenfor scope|ikke med|relaterte krav/i;

interface Section {
  /** Linja med `## Navn` */
  head: number;
  /** Første linje etter seksjonen (neste `## ` eller slutten) */
  end: number;
}

const lines = (text: string) => text.replace(/\r\n/g, '\n').split('\n');

function sections(ls: string[]): Map<string, Section> {
  const out = new Map<string, Section>();
  let cur: { name: string; head: number } | null = null;
  let fence = false;
  ls.forEach((l, i) => {
    if (/^\s*```/.test(l)) fence = !fence;
    if (fence || !/^## \S/.test(l)) return;
    if (cur) out.set(cur.name, { head: cur.head, end: i });
    cur = { name: l.slice(3).trim(), head: i };
  });
  if (cur) out.set((cur as { name: string }).name, { head: (cur as { head: number }).head, end: ls.length });
  return out;
}

const find = (secs: Map<string, Section>, name: string) => {
  const key = [...secs.keys()].find(k => k.toLowerCase() === name.toLowerCase());
  return key === undefined ? null : secs.get(key)!;
};

const body = (ls: string[], s: Section | null) => (s ? ls.slice(s.head + 1, s.end) : []);
const trimBlank = (ls: string[]) => {
  let a = 0;
  let b = ls.length;
  while (a < b && !ls[a].trim()) a++;
  while (b > a && !ls[b - 1].trim()) b--;
  return ls.slice(a, b);
};

/** `krav-input/local/krav/…` eller en relativ lenke til krav/ → stien under krav/ */
function kravPathOf(link: string): string | null {
  let p: string;
  try {
    p = decodeURI(link);
  } catch {
    p = link;
  }
  const i = p.indexOf('krav/');
  if (i < 0 || !p.endsWith('.feature')) return null;
  const rest = p.slice(i);
  // krav-input/local/krav/… er en kopi med samme sti som i repoet
  return rest;
}

function parseKrav(ls: string[]): KravRef[] {
  const out: KravRef[] = [];
  let sub = '';
  for (const l of ls) {
    if (/^### /.test(l)) {
      sub = l.slice(4);
      continue;
    }
    if (OUT_OF_SCOPE.test(sub)) continue;
    const m = l.match(/^\s*-\s+\*\*`([^`]+\.feature)`/);
    if (!m) continue;
    const id = l.match(ID)?.[0] ?? '';
    const links = [...l.matchAll(/\]\(([^)]+)\)/g)].map(x => x[1]);
    const path = links.length ? kravPathOf(links[links.length - 1]) : null;
    const remove = /skal fjernes/i.test(sub);
    if (out.some(k => k.file === m[1] && k.id === id)) continue; // samme fil under både Før og Etter i en delta
    out.push({ file: m[1], id, path, remove });
  }
  return out;
}

const cleanValue = (s: string) => s.replace(/`/g, '').trim();

function parseSketch(name: string, ls: string[]): Sketch {
  const fields: SketchField[] = [];
  for (const l of ls) {
    const m = l.match(/^-\s+\*\*([^*]+?):?\*\*:?\s?(.*)$/);
    if (m) fields.push({ key: m[1].replace(/:$/, '').trim(), lines: [l] });
    else if (fields.length && (l.startsWith(' ') || l.startsWith('\t')) && l.trim()) fields[fields.length - 1].lines.push(l);
  }
  const value = (key: string) => {
    const f = fields.find(x => x.key.toLowerCase() === key.toLowerCase());
    return f ? f.lines[0].replace(/^-\s+\*\*[^*]+\*\*:?\s?/, '') : '';
  };
  const url = value('Referanse').match(/https?:\/\/[^\s>)]+/)?.[0] ?? '';
  const st = cleanValue(value('Valideringsstatus'));
  const kind = (st.match(/^(OK|Avvik|Uavklart)/)?.[1] ?? 'Uavklart') as SketchKind;
  const note = st
    .replace(/^(OK|Avvik|Uavklart)/, '')
    .replace(/^\s*(:|—|-|med merknader:?)\s*/i, '')
    .trim();
  return { name, url, kind, note, dekker: cleanValue(value('Dekker krav')), fields };
}

function parseSketches(ls: string[]): { skisser: Sketch[]; ingen: string | null } {
  const skisser: Sketch[] = [];
  let ingen: string | null = null;
  let cur: { name: string; ls: string[] } | null = null;
  const flush = () => cur && skisser.push(parseSketch(cur.name, cur.ls));
  for (const l of ls) {
    const h = l.match(/^###\s+(?:Skisse:\s*)?(.+)$/);
    if (h) {
      flush();
      cur = { name: h[1].replace(/`/g, '').trim(), ls: [] };
      continue;
    }
    const n = l.match(/^Ingen skisse:\s*(.*)$/i);
    if (n && !cur) ingen = n[1].trim();
    else if (cur) cur.ls.push(l);
  }
  flush();
  return { skisser, ingen };
}

export function parseSpec(text: string, file = ''): SpecDoc {
  const ls = lines(text);
  const secs = sections(ls);
  const h1 = ls.find(l => /^# \S/.test(l)) ?? '';
  const delta = /^# Delta-spec:/i.test(h1) || file.startsWith('spec-changes-');
  const title = h1.replace(/^#\s+/, '').replace(/^(Delta-spec|Spec):\s*/i, '').trim();
  const { skisser, ingen } = parseSketches(body(ls, find(secs, 'Skisser')));
  const sporsmal = body(ls, find(secs, 'Åpne spørsmål'))
    .map(l => l.match(/^- \[( |x|X)\]\s+(.*)$/))
    .filter((m): m is RegExpMatchArray => !!m)
    .map(m => ({ t: m[2].trim(), done: m[1] !== ' ' }));
  const rute = trimBlank(body(ls, find(secs, 'Rute')))
    .join(' ')
    .split(/→|,|->/)
    .map(s => s.replace(/`/g, '').trim())
    .filter(s => s && !/^[–—-]$/.test(s));
  return {
    title,
    delta,
    omfang: trimBlank(body(ls, find(secs, 'Omfang'))).join('\n'),
    krav: parseKrav(body(ls, find(secs, 'Krav'))),
    skisser,
    ingenSkisse: ingen,
    sporsmal,
    rute,
  };
}

// —— Skriving ——

/** Rekkefølgen seksjonene får når de legges til i et dokument som mangler dem */
const ORDER = ['Kilde', 'Omfang', 'Krav', 'Skisser', 'Retagging', 'Åpne spørsmål', 'Rute'];

/** Fjerner seksjonen `name` (overskriften og innholdet) */
export function removeSection(text: string, name: string): string {
  const ls = lines(text);
  const s = find(sections(ls), name);
  if (!s) return text;
  const out = [...ls.slice(0, s.head), ...ls.slice(s.end)].join('\n').replace(/\n{3,}/g, '\n\n');
  return out.replace(/\n*$/, '\n');
}

/** Bytter innholdet i seksjonen `name`, eller legger den til på riktig plass */
export function setSection(text: string, name: string, content: string[]): string {
  const ls = lines(text);
  const secs = sections(ls);
  const block = ['', ...trimBlank(content), ''];
  const s = find(secs, name);
  if (s) {
    const out = [...ls.slice(0, s.head + 1), ...block, ...ls.slice(s.end)];
    return out.join('\n').replace(/\n{3,}/g, '\n\n');
  }
  // Etter nærmeste seksjon som skal stå foran, ellers før nærmeste som skal stå etter, ellers til slutt
  const idx = ORDER.indexOf(name);
  const before = ORDER.slice(0, Math.max(idx, 0)).reverse().map(n => find(secs, n)).find(Boolean);
  const after = ORDER.slice(idx + 1).map(n => find(secs, n)).find(Boolean);
  const at = before ? before.end : after ? after.head : ls.length;
  const out = [...ls.slice(0, at), `## ${name}`, ...block, ...ls.slice(at)];
  const joined = out.join('\n').replace(/\n{3,}/g, '\n\n');
  return joined.endsWith('\n') ? joined : joined + '\n';
}

export function setTitle(text: string, title: string, delta: boolean): string {
  const ls = lines(text);
  const i = ls.findIndex(l => /^# \S/.test(l));
  const prefix = delta ? (ls[i]?.match(/^# (Delta-spec):/i)?.[1] ?? 'Spec') : 'Spec';
  const line = `# ${prefix}: ${title}`;
  if (i >= 0) ls[i] = line;
  else ls.unshift(line, '');
  return ls.join('\n');
}

/** Punktet et krav får når det legges til i vieweren. fs-specify lager råkopien i krav-input/ når den kjøres. */
export function kravLine(k: KravRef, title: string, specDir: string): string {
  const rel = k.path ? relativeTo(specDir, k.path) : '';
  const link = k.path ? ` ([${k.path}](${encodeURI(rel)}))` : '';
  return `- **\`${k.file}\`** (\`${k.id}\`)${title ? ` — ${title}` : ''}.${link}`;
}

/** Relativ sti fra en mappe til en fil, begge relativt til repo-roten */
export function relativeTo(fromDir: string, to: string): string {
  const a = fromDir.split('/').filter(Boolean);
  const b = to.split('/').filter(Boolean);
  let i = 0;
  while (i < a.length && i < b.length && a[i] === b[i]) i++;
  return [...a.slice(i).map(() => '..'), ...b.slice(i)].join('/');
}

/**
 * Krav-seksjonen med `next`: punkter for krav som er fjernet, slettes (uansett underseksjon), og nye krav legges
 * til på slutten av hovedlista (før første underseksjon). Punktene som står, røres ikke.
 */
export function setKrav(text: string, next: KravRef[], titles: Record<string, string>, specDir: string): string {
  const ls = lines(text);
  const s = find(sections(ls), 'Krav');
  const cur = s ? body(ls, s) : [];
  const keep = new Set(next.map(k => k.id || k.file));
  const have = new Set<string>();
  const kept: string[] = [];
  let sub = '';
  for (let i = 0; i < cur.length; i++) {
    const l = cur[i];
    if (/^### /.test(l)) sub = l;
    const m = !OUT_OF_SCOPE.test(sub) && l.match(/^\s*-\s+\*\*`([^`]+\.feature)`/);
    if (m) {
      const key = l.match(ID)?.[0] || m[1];
      if (!keep.has(key)) {
        if (!cur[i + 1]?.trim()) i++; // tom linje etter punktet
        continue;
      }
      have.add(key);
    }
    kept.push(l);
  }
  const added = next.filter(k => !have.has(k.id || k.file)).map(k => kravLine(k, titles[k.id] ?? '', specDir));
  if (!added.length) return s ? setSection(text, 'Krav', kept) : text;
  const firstSub = kept.findIndex(l => /^### /.test(l));
  const main = trimBlank(firstSub < 0 ? kept : kept.slice(0, firstSub));
  const rest = firstSub < 0 ? [] : kept.slice(firstSub);
  // Punktene i hovedlista har blank linje mellom seg (slik fs-specify skriver dem)
  const spaced = main.length && main.some(l => !l.trim()) ? added.flatMap(a => ['', a]) : added;
  return setSection(text, 'Krav', [...main, ...spaced, ...(rest.length ? ['', ...rest] : [])]);
}

const fieldLine = (key: string, value: string) => `- **${key}:** ${value}`;

/** En skisse som tekst. Felt som finnes fra før, beholdes; Referanse, Valideringsstatus og Dekker krav skrives fra verdiene. */
export function sketchLines(k: Sketch, prev?: Sketch): string[] {
  const status = k.note ? `\`${k.kind}\`: ${k.note}` : `\`${k.kind}\``;
  const repl: Record<string, string | null> = {
    referanse: !prev || prev.url !== k.url ? (k.url ? `<${k.url}>` : '–') : null,
    valideringsstatus: !prev || prev.kind !== k.kind || prev.note !== k.note ? status : null,
    'dekker krav': !prev || prev.dekker !== k.dekker ? k.dekker || '–' : null,
  };
  const fields = prev ? k.fields : [{ key: 'Type', lines: [fieldLine('Type', `\`${/figma\.com/.test(k.url) ? 'figma' : 'annet'}\``)] }];
  const out = [`### Skisse: ${k.name}`, ''];
  const seen = new Set<string>();
  for (const f of fields) {
    const key = f.key.toLowerCase();
    seen.add(key);
    const r = repl[key];
    out.push(...(r !== null && r !== undefined ? [fieldLine(f.key, r)] : f.lines));
  }
  for (const [key, label] of [['referanse', 'Referanse'], ['dekker krav', 'Dekker krav'], ['valideringsstatus', 'Valideringsstatus']] as const) {
    if (!seen.has(key)) out.push(fieldLine(label, repl[key] ?? (key === 'referanse' ? (k.url ? `<${k.url}>` : '–') : key === 'valideringsstatus' ? status : k.dekker || '–')));
  }
  return out;
}

/** Skisser-seksjonen: skissene i `next` (med feltene fra `prev` for dem som fantes), eller «Ingen skisse: <grunn>» */
export function setSketches(text: string, next: Sketch[], ingen: string | null, prev: Sketch[]): string {
  const blocks = next.flatMap((k, i) => [...(i ? [''] : []), ...sketchLines(k, k.fields.length ? prev.find(p => JSON.stringify(p.fields) === JSON.stringify(k.fields)) : undefined)]);
  const content = next.length ? blocks : ingen !== null ? [`Ingen skisse: ${ingen}`] : [];
  return setSection(text, 'Skisser', content);
}

export function setQuestions(text: string, qs: Question[]): string {
  return setSection(text, 'Åpne spørsmål', qs.length ? qs.map(q => `- [${q.done ? 'x' : ' '}] ${q.t}`) : ['Ingen åpne spørsmål.']);
}

export const setOmfang = (text: string, omfang: string) => setSection(text, 'Omfang', omfang.trim() ? lines(omfang.trim()) : []);

/**
 * Skriver endringene fra `prev` til `next` inn i teksten. Bare seksjonene som er endret, skrives om.
 * `titles`: Egenskap-tittelen per Feature-ID, til punktene for nye krav. `specDir`: mappa spesifikasjonen ligger i.
 */
export function applySpec(text: string, prev: SpecDoc, next: SpecDoc, titles: Record<string, string>, specDir: string): string {
  let out = text;
  if (prev.title !== next.title) out = setTitle(out, next.title, next.delta);
  if (prev.omfang !== next.omfang) out = setOmfang(out, next.omfang);
  if (JSON.stringify(prev.krav.map(k => k.id || k.file)) !== JSON.stringify(next.krav.map(k => k.id || k.file))) out = setKrav(out, next.krav, titles, specDir);
  const sk = (d: SpecDoc) => JSON.stringify([d.skisser.map(k => [k.name, k.url, k.kind, k.note, k.dekker]), d.ingenSkisse]);
  if (sk(prev) !== sk(next)) out = setSketches(out, next.skisser, next.ingenSkisse, prev.skisser);
  if (JSON.stringify(prev.sporsmal) !== JSON.stringify(next.sporsmal)) out = setQuestions(out, next.sporsmal);
  if (prev.rute.join() !== next.rute.join()) out = next.rute.length ? setSection(out, 'Rute', [next.rute.join(' → ')]) : removeSection(out, 'Rute');
  return out;
}

/** Skjelettet for en ny spesifikasjon som lages i vieweren */
export function newSpecText(title: string, dir: string, date: string): string {
  return [
    `# Spec: ${title}`,
    '',
    '## Kilde',
    '',
    `- **Oppgave:** \`${dir}/\``,
    `- **Opprettet:** ${date} i FS Kravforvaltning`,
    '',
    '## Omfang',
    '',
    '## Krav',
    '',
    '## Skisser',
    '',
    '## Åpne spørsmål',
    '',
    'Ingen åpne spørsmål.',
    '',
  ].join('\n');
}

/** `Opprette og vedlikeholde opptak` → `opprette-og-vedlikeholde-opptak` */
export const slugify = (t: string) =>
  t
    .toLowerCase()
    .replace(/æ/g, 'ae')
    .replace(/ø/g, 'o')
    .replace(/å/g, 'a')
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');
