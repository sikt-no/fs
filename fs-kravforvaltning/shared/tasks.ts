// Oppgavemappene i tasks/<domene>/<slug>/ (se tasks/README.md). Serveren leser rådata (server/tasks.ts),
// og her tolkes de til en modell og sjekkes mot reglene i README-en. Rene funksjoner, testet i tasks.test.ts.

/** Rådata for én oppgavemappe, slik serveren leser den */
export interface RawTask {
  dom: string;
  slug: string;
  /** Alle filer i mappa, relativt til mappa (`frontend/plan-x.md`) */
  files: string[];
  /** Innholdet i `oppgave.md` og `reviews/*.md`, og boks-linjene i `<lag>/plan-*.md`, nøklet på relativ sti */
  sources: Record<string, string>;
}

export interface TasksSnapshot {
  /** Domenemappene under tasks/, med innholdet i roadmap.md (null hvis den mangler) */
  domains: Record<string, string | null>;
  tasks: RawTask[];
}

export const PHASES = ['prioritert', 'utforskning', 'utvikling', 'innføring', 'levert'] as const;
export type Phase = (typeof PHASES)[number];

/** Domenetabellen i tasks/README.md: slug → toppnivå i krav/ */
export const DOMAINS: Record<string, string> = {
  utdanning: '01 Utdanning',
  opptak: '02 Opptak',
  'gjennomfore-studier': '03 Gjennomføre studier',
  kompetanse: '04 Kompetanse',
  'opplysninger-om-person': '05 Opplysninger om person',
  'brukeradministrasjon-og-tilgangsstyring': '07 Brukeradministrasjon og tilgangsstyring',
  teknisk: '08 Teknisk',
  organisasjon: '09 Organisasjon',
  felleskrav: '10 Felleskrav',
};

/** Typiske lag fra regel 2 i tasks/README.md */
export const KNOWN_LAG = ['spec', 'frontend', 'backend', 'subgraph', 'tester', 'db', 'dokumentasjon'];

/** Filene BAT globber etter (regel 1) */
const BAT_GLOB = /^(spec|analysis|plan|verification)-.+\.md$/;
const COMPLETION = /^task-\d+-completion\.md$/;
/** Mapper i oppgave-rota som ikke er lag */
const NOT_LAG = new Set(['spec', 'reviews']);

export type TaskRule = 'r1' | 'r2' | 'r3' | 'r4' | 'fase' | 'slug' | 'domene' | 'roadmap';

export const TASK_RULE: Record<TaskRule, string> = {
  r1: 'Regel 1',
  r2: 'Regel 2',
  r3: 'Regel 3',
  r4: 'Regel 4',
  fase: 'Metadata',
  slug: 'Metadata',
  domene: 'Metadata',
  roadmap: 'Roadmap',
};

export interface TaskLint {
  rule: TaskRule;
  title: string;
  hint: string;
  /** Fila avviket gjelder, relativt til oppgavemappa */
  file: string | null;
}

export interface Lag {
  k: string;
  analysis: boolean;
  /** Planbokser [avkrysset, totalt], eller null når det ikke finnes noen plan-*.md */
  plan: [number, number] | null;
  completions: number;
  verification: boolean;
}

export interface Review {
  n: number;
  file: string;
  from: string;
  to: string;
  who: string | null;
  /** true: ingen verdifulle forbedringer, false: forbedringer foreslått, null: ikke avkrysset */
  ok: boolean | null;
}

export interface LogRow {
  d: string;
  t: string;
  who: string;
}

export interface Task {
  dom: string;
  slug: string;
  /** tasks/<dom>/<slug> */
  dir: string;
  files: string[];
  hasOppgave: boolean;
  title: string;
  issue: number | null;
  initiativ: string | null;
  /** Fase slik den står i oppgave.md, eller null hvis den mangler/er ugyldig */
  phase: Phase | null;
  /** Indeks i PHASES; ugyldig fase plasseres som prioritert */
  p: number;
  prio: string | null;
  owner: string | null;
  metaDom: string | null;
  metaSlug: string | null;
  /** Sti under krav/ fra «Krav (Gherkin)», uten skråstrek til slutt */
  kravLink: string | null;
  prs: number;
  design: boolean;
  spec: boolean;
  flow: boolean;
  memory: boolean;
  lag: Lag[];
  reviews: Review[];
  log: LogRow[];
  /** Nyeste dato i statusloggen */
  updated: string | null;
  lint: TaskLint[];
}

const clean = (s: string) =>
  s
    .replace(/\[([^\]]*)\]\([^)]*\)/g, '$1')
    .replace(/`/g, '')
    .replace(/\*\*/g, '')
    .trim();
const none = (s: string | undefined) => {
  if (s === undefined) return null;
  const v = clean(s);
  return !v || /^[–—-]$/.test(v) || v.startsWith('(') || v === '@brukernavn' ? null : v;
};

/** `- **Nøkkel**: verdi`-linjene i Metadata-seksjonen */
export function metadata(src: string): Record<string, string> {
  const out: Record<string, string> = {};
  for (const m of src.matchAll(/^\s*-\s+\*\*([^*]+)\*\*:\s*(.*)$/gm)) out[m[1].trim()] = m[2].trim();
  // Underpunktene i «Lenker» er på formen `  - navn: verdi`
  for (const m of src.matchAll(/^\s+-\s+([A-Za-zÆØÅæøå ]+):\s*(.*)$/gm)) out['lenke:' + m[1].trim()] ??= m[2].trim();
  return out;
}

/** Radene i den første tabellen etter overskriften, som lister av celler */
export function tableAfter(src: string, heading: RegExp): string[][] {
  const lines = src.split('\n');
  const start = lines.findIndex(l => /^#{1,6}\s/.test(l) && heading.test(l));
  if (start < 0) return [];
  const rows: string[][] = [];
  for (let i = start + 1; i < lines.length; i++) {
    const l = lines[i].trim();
    if (/^#{1,6}\s/.test(l)) break;
    if (!l.startsWith('|')) {
      if (rows.length) break;
      continue;
    }
    rows.push(l.replace(/^\||\|$/g, '').split('|').map(c => c.trim()));
  }
  // Første rad er overskriften, andre er skillelinja
  return rows.filter((r, i) => i > 0 && !r.every(c => /^:?-+:?$/.test(c)));
}

function kravPath(value: string | undefined, dir: string): string | null {
  if (!value) return null;
  const link = /\]\(([^)]+)\)/.exec(value);
  let path: string | null = null;
  if (link && !/^[a-z]+:/i.test(link[1])) {
    let href = link[1];
    try {
      href = decodeURIComponent(href);
    } catch {
      /* behold som den er */
    }
    const parts = (dir + '/oppgave.md').split('/').slice(0, -1);
    for (const p of href.split('/')) {
      if (p === '..') parts.pop();
      else if (p && p !== '.') parts.push(p);
    }
    path = parts.join('/');
  } else {
    const code = /`([^`]+)`/.exec(value);
    if (code) path = code[1];
  }
  if (!path) return null;
  path = path.replace(/\/+$/, '');
  return path === 'krav' || path.startsWith('krav/') ? path : null;
}

const countBoxes = (src: string): [number, number] => {
  let done = 0;
  let all = 0;
  for (const m of src.matchAll(/^\s*[-*+]\s+\[([ xX])\]/gm)) {
    all++;
    if (m[1] !== ' ') done++;
  }
  return [done, all];
};

function review(file: string, src: string | undefined): Review | null {
  const m = /^reviews\/r(\d+)-(.+)-til-(.+)\.md$/.exec(file);
  if (!m) return null;
  const meta = metadata(src ?? '');
  let ok: boolean | null = null;
  if (src && /^\s*-\s+\[[xX]\]\s+\*\*Ingen verdifulle/m.test(src)) ok = true;
  else if (src && /^\s*-\s+\[[xX]\]\s+\*\*Forbedringer foreslått/m.test(src)) ok = false;
  return { n: Number(m[1]), file, from: m[2], to: m[3], who: none(meta['Reviewer']), ok };
}

/** Tolker rådataene for én oppgavemappe (uten regelsjekk) */
export function parseTask(raw: RawTask): Task {
  const dir = `tasks/${raw.dom}/${raw.slug}`;
  const src = raw.sources['oppgave.md'];
  const meta = metadata(src ?? '');
  const title = /^#\s+(.+)$/m.exec(src ?? '')?.[1].trim() ?? raw.slug;
  // «prioritert | utforskning | …» er malteksten, ikke en fase
  const faseVal = none(meta['Fase']);
  const faseRaw = faseVal && !faseVal.includes('|') ? faseVal.split(/\s/)[0].toLowerCase() : null;
  const phase = PHASES.includes(faseRaw as Phase) ? (faseRaw as Phase) : null;
  const firstWord = (k: string) => none(meta[k])?.split(/\s/)[0] ?? null;
  const prsVal = meta['lenke:PRs'] ?? meta['PRs'];
  const prs = prsVal && none(prsVal) ? Math.max(1, new Set([...prsVal.matchAll(/(?:#|\/pull\/)(\d+)/g)].map(m => m[1])).size) : 0;

  const top = (f: string) => f.split('/')[0];
  const dirs = [...new Set(raw.files.filter(f => f.includes('/')).map(top))].sort();
  const lag: Lag[] = dirs
    .filter(d => !NOT_LAG.has(d))
    .map(k => {
      const own = raw.files.filter(f => f.startsWith(k + '/') && f.split('/').length === 2).map(f => f.slice(k.length + 1));
      const plans = own.filter(f => /^plan-.+\.md$/.test(f));
      const plan = plans.length
        ? plans.map(f => countBoxes(raw.sources[`${k}/${f}`] ?? '')).reduce<[number, number]>((a, b) => [a[0] + b[0], a[1] + b[1]], [0, 0])
        : null;
      return {
        k,
        analysis: own.some(f => /^analysis-.+\.md$/.test(f)),
        plan,
        completions: own.filter(f => COMPLETION.test(f)).length,
        verification: own.some(f => /^verification-.+\.md$/.test(f)),
      };
    });

  const reviews = raw.files
    .filter(f => f.startsWith('reviews/'))
    .map(f => review(f, raw.sources[f]))
    .filter((r): r is Review => !!r)
    .sort((a, b) => a.n - b.n);

  const log = tableAfter(src ?? '', /Statuslogg/).map(r => ({ d: clean(r[0] ?? ''), t: clean(r[1] ?? ''), who: none(r[2]) ?? '' }));
  const dates = log.map(r => r.d).filter(d => /^\d{4}-\d{2}-\d{2}$/.test(d)).sort();

  return {
    dom: raw.dom,
    slug: raw.slug,
    dir,
    files: raw.files,
    hasOppgave: src !== undefined,
    title,
    issue: Number(/#(\d+)/.exec(meta['Issue'] ?? '')?.[1]) || null,
    initiativ: none(meta['Initiativ']),
    phase,
    p: phase ? PHASES.indexOf(phase) : 0,
    prio: firstWord('Prioritet'),
    owner: none(meta['Eier']),
    metaDom: firstWord('Domene'),
    metaSlug: firstWord('Slug'),
    kravLink: kravPath(meta['Krav (Gherkin)'], dir),
    prs,
    design: raw.files.includes('design.md'),
    spec: raw.files.some(f => /^spec\/spec-.+\.md$/.test(f)),
    flow: raw.files.includes('flow.md'),
    memory: raw.files.includes('memory.md'),
    lag,
    reviews,
    log,
    updated: dates[dates.length - 1] ?? null,
    lint: [],
  };
}

/** Fase per slug fra roadmap.md: «Fase»-kolonnen i aktive oppgaver, og «levert» for tabellen «Ferdig» */
export function roadmapPhases(src: string | null): Record<string, string> {
  const out: Record<string, string> = {};
  if (!src) return out;
  const lines = src.split('\n');
  let heading = '';
  let header: string[] | null = null;
  for (const line of lines) {
    const l = line.trim();
    if (/^#{1,6}\s/.test(l)) {
      heading = l;
      header = null;
      continue;
    }
    if (!l.startsWith('|')) {
      header = null;
      continue;
    }
    const cells = l.replace(/^\||\|$/g, '').split('|').map(c => c.trim());
    if (!header) {
      header = cells.map(c => c.toLowerCase());
      continue;
    }
    if (cells.every(c => /^:?-+:?$/.test(c))) continue;
    const iMappe = header.indexOf('mappe');
    if (iMappe < 0) continue;
    const slug = /\[([^\]]+)\]|([^\s/]+)/.exec(cells[iMappe] ?? '');
    const s = (slug?.[1] ?? slug?.[2] ?? '').replace(/\/$/, '');
    if (!s) continue;
    const iFase = header.indexOf('fase');
    if (iFase >= 0) out[s] = clean(cells[iFase] ?? '').toLowerCase();
    else if (/ferdig|levert/i.test(heading)) out[s] = 'levert';
  }
  return out;
}

/** Sjekker oppgavemappa mot de fire reglene i tasks/README.md, og mot metadata og roadmap */
export function taskLint(t: Task, roadmap: Record<string, string> | null): TaskLint[] {
  const out: TaskLint[] = [];
  const root = t.files.filter(f => !f.includes('/'));

  for (const f of root.filter(f => BAT_GLOB.test(f))) {
    const lag = /^plan-(.+)\.md$/.exec(f)?.[1];
    if (lag && KNOWN_LAG.includes(lag))
      out.push({
        rule: 'r2',
        title: `${f} ligger i oppgave-rota`,
        hint: `En plan for et lag hører hjemme i lagets egen undermappe. Flytt den til ${lag}/plan-${t.slug}.md.`,
        file: f,
      });
    else
      out.push({
        rule: 'r1',
        title: `${f} ligger i oppgave-rota`,
        hint: `BAT leser den som et fullført steg og hopper over resten av flyten. Flytt den til <lag>/${f.split('-')[0]}-${t.slug}.md.`,
        file: f,
      });
  }

  for (const f of t.files.filter(f => f.includes('/') && !f.startsWith('spec/'))) {
    const parts = f.split('/');
    if (parts.length === 2 && /^spec-.+\.md$/.test(parts[1]))
      out.push({ rule: 'r3', title: `${f} ligger utenfor spec/`, hint: 'spec/ er reservert for kravene. Flytt fila til spec/.', file: f });
    else if (parts[1] === 'krav-input' && parts.length > 2 && !out.some(o => o.file === `${parts[0]}/krav-input/`))
      out.push({
        rule: 'r3',
        title: `${parts[0]}/krav-input/ ligger utenfor spec/`,
        hint: 'Krav-input hører til kravene. Flytt mappa til spec/krav-input/.',
        file: `${parts[0]}/krav-input/`,
      });
  }

  if (t.dom === 'mal')
    out.push({ rule: 'r4', title: 'Oppgavemappe under mal/', hint: 'mal/ er reservert for malene og er ikke et domene. Flytt oppgaven til riktig domene.', file: null });
  else if (!DOMAINS[t.dom])
    out.push({
      rule: 'r4',
      title: `${t.dom} er ikke et domene`,
      hint: 'Domenet finnes ikke i domenetabellen i tasks/README.md. Legg det til der først, eller flytt oppgaven.',
      file: null,
    });

  if (!t.hasOppgave) {
    out.push({ rule: 'fase', title: 'oppgave.md mangler', hint: 'Hver oppgavemappe skal ha en oppgave.md. Opprett den med fs-oppgave.', file: null });
    return out;
  }
  if (!t.phase)
    out.push({
      rule: 'fase',
      title: 'Fase mangler eller er ugyldig',
      hint: `Fase i oppgave.md skal være én av ${PHASES.join(', ')}.`,
      file: 'oppgave.md',
    });
  if (t.metaSlug && t.metaSlug !== t.slug)
    out.push({ rule: 'slug', title: `Slug er ${t.metaSlug}, men mappa heter ${t.slug}`, hint: 'Slug i oppgave.md skal være navnet på mappa.', file: 'oppgave.md' });
  if (t.metaDom && t.metaDom !== t.dom)
    out.push({ rule: 'domene', title: `Domene er ${t.metaDom}, men mappa ligger i ${t.dom}`, hint: 'Domene i oppgave.md skal være domenemappa.', file: 'oppgave.md' });
  if (roadmap) {
    const rp = roadmap[t.slug];
    if (rp === undefined)
      out.push({ rule: 'roadmap', title: 'Mangler i roadmap.md', hint: `Oppgaven har ingen rad i tasks/${t.dom}/roadmap.md.`, file: null });
    else if (t.phase && rp !== t.phase)
      out.push({
        rule: 'roadmap',
        title: `roadmap.md sier ${rp}, oppgave.md sier ${t.phase}`,
        hint: `Fasen i tasks/${t.dom}/roadmap.md og oppgave.md skal være den samme.`,
        file: 'oppgave.md',
      });
  }
  return out;
}

/** Hele oppgavelista med regelsjekk, sortert på domene og fase */
export function buildTasks(snap: TasksSnapshot): Task[] {
  const phases: Record<string, Record<string, string> | null> = {};
  for (const [dom, src] of Object.entries(snap.domains)) phases[dom] = src === null ? null : roadmapPhases(src);
  return snap.tasks
    .map(raw => {
      const t = parseTask(raw);
      t.lint = taskLint(t, phases[raw.dom] ?? null);
      return t;
    })
    .sort((a, b) => a.dom.localeCompare(b.dom) || a.p - b.p || a.title.localeCompare(b.title, 'nb'));
}
