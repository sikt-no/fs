// Scope-mappene i tasks/<domene>/<slug>/ med scope.md (se tasks/README.md). Serveren leser rådata (server/tasks.ts),
// og her tolkes de til en modell og sjekkes mot reglene i README-en. Typenavnene `Task` (mappa) og `Scope` (scope.md)
// er beholdt fra da oppgave og scope var to begreper. Rene funksjoner, testet i tasks.test.ts.
import { parseSpec, type KravRef } from './spec.ts';

/** Rådata for én scope-mappe, slik serveren leser den */
export interface RawTask {
  dom: string;
  slug: string;
  /** Alle filer i mappa, relativt til mappa (`frontend/plan-x.md`) */
  files: string[];
  /**
   * Innholdet i `scope.md`, `utforing.md` og `spec/spec-*.md` / `spec/verify-*.md`,
   * og boks-linjene i `<lag>/plan-*.md`, nøklet på relativ sti
   */
  sources: Record<string, string>;
  /** Endringstidspunkt (ms) for spesifikasjonene og scope.md, til «spec endret etter at den ble sendt» og «scope endret» */
  mtimes?: Record<string, number>;
}

export interface TasksSnapshot {
  /** Domenemappene under tasks/, med innholdet i roadmap.md (null hvis den mangler). Appen leser ikke roadmap.md lenger. */
  domains: Record<string, string | null>;
  tasks: RawTask[];
}

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
/** Mapper i scope-rota som ikke er lag */
const NOT_LAG = new Set(['spec', 'reviews']);

export type TaskRule = 'r1' | 'r2' | 'r3' | 'r4' | 'scopefil' | 'slug' | 'domene' | 'scope';

export const TASK_RULE: Record<TaskRule, string> = {
  r1: 'Regel 1',
  r2: 'Regel 2',
  r3: 'Regel 3',
  r4: 'Regel 4',
  scopefil: 'Metadata',
  slug: 'Metadata',
  domene: 'Metadata',
  scope: 'Scope',
};

export interface TaskLint {
  rule: TaskRule;
  title: string;
  hint: string;
  /** Fila avviket gjelder, relativt til scope-mappa */
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

export interface LogRow {
  d: string;
  t: string;
  who: string;
}

/** En sak scopet løses i: en Jira-sak (`BAT-268`), eller et GitHub issue (`#143`) i scopes fra før */
export interface IssueRef {
  /** `BAT-268` eller `#143` */
  key: string;
  url: string;
}

export const JIRA_BROWSE = 'https://sikt.atlassian.net/browse/';
const GITHUB_ISSUES = 'https://github.com/sikt-no/fs/issues/';

/** Saken i en krav-rad i scope.md, eller det brukeren skriver i «+ Nytt scope»: en Jira-nøkkel eller -lenke, ellers `#<nr>` for GitHub */
export function parseIssue(v: string | undefined): IssueRef | null {
  if (!v) return null;
  const jira = /(?:^|[^A-Za-z0-9])([A-Z][A-Z0-9]+-\d+)\b/.exec(v);
  if (jira) return { key: jira[1], url: JIRA_BROWSE + jira[1] };
  const gh = /#(\d+)/.exec(v) ?? /github\.com\/sikt-no\/fs\/issues\/(\d+)/.exec(v);
  return gh ? { key: '#' + gh[1], url: GITHUB_ISSUES + gh[1] } : null;
}

/** Alle sakene i `Jira` i scope.md (`[BAT-1](…), [#143](…)`) eller i «+ Nytt scope» (`BAT-1, BAT-2`), i rekkefølge */
export function parseIssues(v: string | undefined): IssueRef[] {
  if (!v) return [];
  const out: IssueRef[] = [];
  for (const part of v.split(/,|\s+og\s+/)) {
    const r = parseIssue(part);
    if (r && !out.some(o => o.key === r.key)) out.push(r);
  }
  return out;
}

export interface Task {
  dom: string;
  slug: string;
  /** tasks/<dom>/<slug> */
  dir: string;
  files: string[];
  /** Mappa har scope.md */
  hasScope: boolean;
  title: string;
  /** Sakene i `Jira`, i rekkefølge */
  issues: IssueRef[];
  /** Den første saken, eller null */
  issue: IssueRef | null;
  initiativ: string | null;
  /** Slugen til scopet (= mappa) når mappa har scope.md, ellers null */
  scope: string | null;
  prio: string | null;
  owner: string | null;
  metaDom: string | null;
  metaSlug: string | null;
  /** Kravene under `## Krav` i spesifikasjonene (`spec/spec-*.md`), uten det som er utenfor scope */
  specKrav: KravRef[];
  prs: number;
  design: boolean;
  spec: boolean;
  flow: boolean;
  memory: boolean;
  lag: Lag[];
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

const countBoxes = (src: string): [number, number] => {
  let done = 0;
  let all = 0;
  for (const m of src.matchAll(/^\s*[-*+]\s+\[([ xX])\]/gm)) {
    all++;
    if (m[1] !== ' ') done++;
  }
  return [done, all];
};

/** Tolker rådataene for én scope-mappe (uten regelsjekk) */
export function parseTask(raw: RawTask): Task {
  const dir = `tasks/${raw.dom}/${raw.slug}`;
  const src = raw.sources['scope.md'];
  const meta = metadata(src ?? '');
  const title = (/^#\s+(.+)$/m.exec(src ?? '')?.[1].trim() ?? raw.slug).replace(/^Scope:\s*/i, '');
  const issues = parseIssues(meta['Jira']);
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

  const log = tableAfter(src ?? '', /Statuslogg/).map(r => ({ d: clean(r[0] ?? ''), t: clean(r[1] ?? ''), who: none(r[2]) ?? '' }));
  const dates = log.map(r => r.d).filter(d => /^\d{4}-\d{2}-\d{2}$/.test(d)).sort();

  const specKrav: KravRef[] = [];
  for (const f of raw.files.filter(f => /^spec\/spec-[^/]+\.md$/.test(f) && raw.sources[f] !== undefined))
    for (const k of parseSpec(raw.sources[f], f.slice(5)).krav)
      if (!specKrav.some(o => (k.id ? o.id === k.id : o.file === k.file))) specKrav.push(k);

  return {
    dom: raw.dom,
    slug: raw.slug,
    dir,
    files: raw.files,
    hasScope: src !== undefined,
    title,
    issues,
    issue: issues[0] ?? null,
    initiativ: none(meta['Initiativ']),
    scope: src !== undefined ? raw.slug : null,
    prio: firstWord('Prioritet'),
    owner: none(meta['Eier']),
    metaDom: firstWord('Domene'),
    metaSlug: firstWord('Slug'),
    specKrav,
    prs,
    design: raw.files.includes('design.md'),
    spec: raw.files.some(f => /^spec\/spec-.+\.md$/.test(f)),
    flow: raw.files.includes('flow.md'),
    memory: raw.files.includes('memory.md'),
    lag,
    log,
    updated: dates[dates.length - 1] ?? null,
    lint: [],
  };
}

/** Sjekker scope-mappa mot de fire reglene i tasks/README.md og mot metadata i scope.md */
export function taskLint(t: Task): TaskLint[] {
  const out: TaskLint[] = [];
  const root = t.files.filter(f => !f.includes('/'));

  for (const f of root.filter(f => BAT_GLOB.test(f))) {
    const lag = /^plan-(.+)\.md$/.exec(f)?.[1];
    if (lag && KNOWN_LAG.includes(lag))
      out.push({
        rule: 'r2',
        title: `${f} ligger i scope-rota`,
        hint: `En plan for et lag hører hjemme i lagets egen undermappe. Flytt den til ${lag}/plan-${t.slug}.md.`,
        file: f,
      });
    else
      out.push({
        rule: 'r1',
        title: `${f} ligger i scope-rota`,
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
    out.push({ rule: 'r4', title: 'Scope-mappe under mal/', hint: 'mal/ er reservert for malene og er ikke et domene. Flytt scopet til riktig domene.', file: null });
  else if (!DOMAINS[t.dom])
    out.push({
      rule: 'r4',
      title: `${t.dom} er ikke et domene`,
      hint: 'Domenet finnes ikke i domenetabellen i tasks/README.md. Legg det til der først, eller flytt scopet.',
      file: null,
    });

  if (!t.hasScope) {
    out.push({ rule: 'scopefil', title: 'scope.md mangler', hint: 'Hver scope-mappe skal ha en scope.md. Lag scopet med fs-scope, eller med «+ Nytt scope» på tavla.', file: null });
    return out;
  }
  if (t.metaSlug && t.metaSlug !== t.slug)
    out.push({ rule: 'slug', title: `Slug er ${t.metaSlug}, men mappa heter ${t.slug}`, hint: 'Slug i scope.md skal være navnet på mappa, og det samme som i taggen @scope-<slug>.', file: 'scope.md' });
  if (t.metaDom && t.metaDom !== t.dom)
    out.push({ rule: 'domene', title: `Domene er ${t.metaDom}, men mappa ligger i ${t.dom}`, hint: 'Domene i scope.md skal være domenemappa.', file: 'scope.md' });
  return out;
}

/** Hele lista over scope-mappene med regelsjekk, sortert på domene og tittel */
export function buildTasks(snap: TasksSnapshot): Task[] {
  return snap.tasks
    .map(raw => {
      const t = parseTask(raw);
      t.lint = taskLint(t);
      return t;
    })
    .sort((a, b) => a.dom.localeCompare(b.dom) || a.title.localeCompare(b.title, 'nb'));
}

// —— Scope (tasks/<domene>/<slug>/scope.md) ——

/** Én rad i tabellen «Krav» i scope.md */
export interface ScopeRow {
  /** Scope-mappa raden hører til (alle radene i en scope.md hører til mappa) */
  task: string | null;
  /** Feature-ID-ene i Krav-kolonnen, med @ (`@OPT-PLA-RUN-001`) */
  ids: string[];
  /** Stiene under krav/ fra lenkene i Krav-kolonnen */
  paths: string[];
  moscow: string | null;
  sketches: { name: string; url: string }[];
  /** Saken kravet hører til (kolonnen «Jira») */
  issue: IssueRef | null;
  comment: string;
}

export interface Scope {
  dom: string;
  /** Navnet på mappa, og slugen i `@scope-<slug>` */
  slug: string;
  /** `tasks/<dom>/<slug>/scope.md` */
  path: string;
  title: string;
  /** Slug-feltet i fila, når det står */
  metaSlug: string | null;
  initiativ: string | null;
  /** Sakene i `Jira`, i rekkefølge */
  issues: IssueRef[];
  owner: string | null;
  updated: string | null;
  rows: ScopeRow[];
  mtime: number | null;
  lint: TaskLint[];
}

const SCOPE_FILE = /^tasks\/([^/]+)\/([^/]+)\/scope\.md$/;
const FEATURE_ID = /@?([A-ZÆØÅ]{2,4}-[A-ZÆØÅ]{2,4}-[A-ZÆØÅ]{2,4}-\d{3})/g;

/** `**Nøkkel**: verdi`-parene i metadatalinjene, også flere på samme linje */
function inlineMeta(src: string): Record<string, string> {
  const out: Record<string, string> = {};
  for (const line of src.split('\n')) {
    if (!/^\s*-\s+\*\*/.test(line)) continue;
    for (const m of line.matchAll(/\*\*([^*]+?):?\*\*:?\s*(.*?)(?=\s*\*\*[^*]+?:?\*\*:?|\s*$)/g)) out[m[1].trim()] ??= m[2].trim();
  }
  return out;
}

/** Tabellen etter overskriften, med kolonneoverskriftene (små bokstaver) som nøkler */
function namedTable(src: string, heading: RegExp): Record<string, string>[] {
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
  const [head, ...body] = rows;
  if (!head) return [];
  const keys = head.map(h => clean(h).toLowerCase());
  return body.filter(r => !r.every(c => /^:?-+:?$/.test(c))).map(r => Object.fromEntries(keys.map((k, i) => [k, r[i] ?? ''])));
}

/** Relativ lenke fra `tasks/<dom>/<slug>/` til krav/ → stien under krav/ */
function linkTarget(href: string, from: string): string | null {
  if (/^[a-z]+:/i.test(href)) return null;
  let h = href;
  try {
    h = decodeURIComponent(h);
  } catch {
    /* behold som den er */
  }
  const parts = from.split('/');
  for (const p of h.split('#')[0].split('/')) {
    if (p === '..') parts.pop();
    else if (p && p !== '.') parts.push(p);
  }
  return parts.join('/');
}

const links = (cell: string) => [...cell.matchAll(/\[([^\]]*)\]\(([^)\s]+)\)/g)].map(m => ({ text: m[1].trim(), href: m[2] }));

/** Tolker én scope.md (uten sjekkene på tvers av scopene) */
export function parseScope(path: string, src: string, mtime: number | null = null): Scope | null {
  const m = SCOPE_FILE.exec(path);
  if (!m) return null;
  const [, dom, slug] = m;
  const meta = inlineMeta(src);
  const title = (/^#\s+(.+)$/m.exec(src)?.[1].trim() ?? slug).replace(/^Scope:\s*/i, '');
  const dir = `tasks/${dom}/${slug}`;
  const rows: ScopeRow[] = namedTable(src, /^#{1,6}\s+Krav\b/).map(r => {
    const krav = r['krav'] ?? '';
    const ids = [...new Set([...krav.matchAll(FEATURE_ID)].map(x => '@' + x[1]))];
    const paths = links(krav)
      .map(l => linkTarget(l.href, dir))
      .filter((p): p is string => !!p && p.startsWith('krav/'));
    const sk = r['skisse'] ?? '';
    return {
      task: slug,
      ids,
      paths,
      moscow: none(r['moscow'])?.split(/\s/)[0] ?? null,
      sketches: links(sk).map(l => ({ name: l.text || l.href, url: l.href })),
      issue: parseIssue(r['jira']),
      comment: clean(r['kommentar'] ?? ''),
    };
  });
  const scope: Scope = {
    dom,
    slug,
    path,
    title,
    metaSlug: none(meta['Slug'])?.split(/\s/)[0] ?? null,
    initiativ: none(meta['Initiativ']),
    issues: parseIssues(meta['Jira']),
    owner: none(meta['Eier']),
    updated: none(meta['Siste oppdatering']),
    rows,
    mtime,
    lint: [],
  };
  return scope;
}

/** Sjekker scopet mot reglene i tasks/README.md: slugen, og at den er unik på tvers av domener (slug og domene i scope.md sjekkes i `taskLint`) */
export function scopeLint(sc: Scope, all: Scope[]): TaskLint[] {
  const out: TaskLint[] = [];
  if (!/^[a-z0-9][a-z0-9-]*$/.test(sc.slug))
    out.push({ rule: 'scope', title: `${sc.slug}: ugyldig slug`, hint: 'Slugen (navnet på mappa) skrives i kebab-case: små bokstaver (a–z), tall og bindestrek.', file: 'scope.md' });
  const twins = all.filter(o => o !== sc && o.slug === sc.slug);
  if (twins.length)
    out.push({ rule: 'scope', title: `Scopet ${sc.slug} finnes også i ${twins.map(o => o.dom).join(', ')}`, hint: 'Slugen er unik på tvers av domener, fordi @scope-<slug> ikke har domene.', file: 'scope.md' });
  return out;
}

/** Alle scopene (scope.md i scope-mappene) med regelsjekk, sortert på domene og tittel */
export function buildScopes(snap: TasksSnapshot): Scope[] {
  const all = snap.tasks
    .filter(t => t.dom !== 'mal' && t.sources['scope.md'] !== undefined)
    .map(t => parseScope(`tasks/${t.dom}/${t.slug}/scope.md`, t.sources['scope.md'], t.mtimes?.['scope.md'] ?? null))
    .filter((s): s is Scope => !!s);
  for (const sc of all) sc.lint = scopeLint(sc, all);
  return all.sort((a, b) => a.dom.localeCompare(b.dom) || a.title.localeCompare(b.title, 'nb'));
}

/**
 * En minimal scope.md fra malen (tasks/mal/scope.md), til «+ Nytt scope» på tavla: tittel, domene, slug, Jira-saker, eier
 * og mål, uten malkommentar og plassholdere, en tom krav-tabell, og én linje i statusloggen.
 */
export function newScopeText(o: { title: string; dom: string; slug: string; jira?: IssueRef[]; owner?: string | null; mal?: string; date: string; via: string }): string {
  const jira = o.jira?.length ? o.jira.map(i => `[${i.key}](${i.url})`).join(', ') : '–';
  return [
    `# Scope: ${o.title}`,
    '',
    `- **Slug**: ${o.slug}`,
    `- **Domene**: ${o.dom} (se [\`../../README.md\`](../../README.md#domener))`,
    '- **Initiativ**: –',
    `- **Jira**: ${jira}`,
    `- **Eier**: ${o.owner || '–'}`,
    `- **Siste oppdatering**: ${o.date}`,
    '',
    '## Mål',
    '',
    o.mal?.trim() || '–',
    '',
    '## Ikke-mål',
    '',
    '–',
    '',
    '## Kilder',
    '',
    '–',
    '',
    '## Krav',
    '',
    '| Krav | MoSCoW | Skisse | Jira | Kommentar |',
    '|---|---|---|---|---|',
    '',
    '## Åpne spørsmål',
    '',
    ...(o.jira?.length ? ['–'] : ['- [ ] Scopet har ikke en Jira-sak ennå.']),
    '',
    '## Statuslogg',
    '',
    'Append-only. Ny linje på toppen ved hver hendelse.',
    '',
    '| Dato       | Hendelse | Av | Lenke til review |',
    '|------------|----------|----|------------------|',
    `| ${o.date} | ${o.via} | ${o.owner || '–'} | – |`,
    '',
  ].join('\n');
}
