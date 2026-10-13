// Oppgavemappene i tasks/<domene>/<slug>/ (se tasks/README.md). Serveren leser rådata (server/tasks.ts),
// og her tolkes de til en modell og sjekkes mot reglene i README-en. Rene funksjoner, testet i tasks.test.ts.
import { parseSpec, type KravRef } from './spec.ts';

/** Rådata for én oppgavemappe, slik serveren leser den */
export interface RawTask {
  dom: string;
  slug: string;
  /** Alle filer i mappa, relativt til mappa (`frontend/plan-x.md`) */
  files: string[];
  /**
   * Innholdet i `oppgave.md`, `utforing.md` og `spec/spec-*.md` / `spec/verify-*.md`,
   * og boks-linjene i `<lag>/plan-*.md`, nøklet på relativ sti
   */
  sources: Record<string, string>;
  /** Endringstidspunkt (ms) for spesifikasjonene, til «spec endret etter at den ble sendt» */
  mtimes?: Record<string, number>;
}

export interface TasksSnapshot {
  /** Domenemappene under tasks/, med innholdet i roadmap.md (null hvis den mangler). Appen leser ikke roadmap.md lenger. */
  domains: Record<string, string | null>;
  tasks: RawTask[];
  /** Scope-filene på domenenivå, `tasks/<domene>/scope-<slug>.md` → innholdet */
  scopes?: Record<string, string>;
  /** Endringstidspunkt (ms) for scope-filene, til «scope endret» */
  scopeMtimes?: Record<string, number>;
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
/** Mapper i oppgave-rota som ikke er lag */
const NOT_LAG = new Set(['spec', 'reviews']);

export type TaskRule = 'r1' | 'r2' | 'r3' | 'r4' | 'oppgave' | 'slug' | 'domene' | 'scope';

export const TASK_RULE: Record<TaskRule, string> = {
  r1: 'Regel 1',
  r2: 'Regel 2',
  r3: 'Regel 3',
  r4: 'Regel 4',
  oppgave: 'Metadata',
  slug: 'Metadata',
  domene: 'Metadata',
  scope: 'Scope',
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
  /** Slugen i `Scope:` i oppgave.md (`[scope-<slug>](../scope-<slug>.md)`), eller null */
  scope: string | null;
  prio: string | null;
  owner: string | null;
  metaDom: string | null;
  metaSlug: string | null;
  /** Sti under krav/ fra «Krav (Gherkin)», uten skråstrek til slutt */
  kravLink: string | null;
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

/** `[scope-x](../scope-x.md)`, `scope-x` eller `x` → `x` */
const scopeSlug = (v: string | undefined) => {
  if (!v || !none(v)) return null;
  const m = /scope-([a-z0-9][a-z0-9-]*?)(?:\.md)?(?=[\])`\s]|$)/.exec(v) ?? /^`?([a-z0-9][a-z0-9-]*)`?$/.exec(clean(v));
  return m?.[1] ?? null;
};

/** Tolker rådataene for én oppgavemappe (uten regelsjekk) */
export function parseTask(raw: RawTask): Task {
  const dir = `tasks/${raw.dom}/${raw.slug}`;
  const src = raw.sources['oppgave.md'];
  const meta = metadata(src ?? '');
  const title = /^#\s+(.+)$/m.exec(src ?? '')?.[1].trim() ?? raw.slug;
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
    hasOppgave: src !== undefined,
    title,
    issue: Number(/#(\d+)/.exec(meta['Issue'] ?? '')?.[1]) || null,
    initiativ: none(meta['Initiativ']),
    scope: scopeSlug(meta['Scope']),
    prio: firstWord('Prioritet'),
    owner: none(meta['Eier']),
    metaDom: firstWord('Domene'),
    metaSlug: firstWord('Slug'),
    kravLink: kravPath(meta['Krav (Gherkin)'], dir),
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

/** Sjekker oppgavemappa mot de fire reglene i tasks/README.md, mot metadata, og mot scopet den peker på */
export function taskLint(t: Task, scopes: Scope[] = []): TaskLint[] {
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
    out.push({ rule: 'oppgave', title: 'oppgave.md mangler', hint: 'Hver oppgavemappe skal ha en oppgave.md. Opprett oppgaven med fs-scope, eller med «+ Ny oppgave» på tavla.', file: null });
    return out;
  }
  if (t.metaSlug && t.metaSlug !== t.slug)
    out.push({ rule: 'slug', title: `Slug er ${t.metaSlug}, men mappa heter ${t.slug}`, hint: 'Slug i oppgave.md skal være navnet på mappa.', file: 'oppgave.md' });
  if (t.metaDom && t.metaDom !== t.dom)
    out.push({ rule: 'domene', title: `Domene er ${t.metaDom}, men mappa ligger i ${t.dom}`, hint: 'Domene i oppgave.md skal være domenemappa.', file: 'oppgave.md' });
  if (t.scope) {
    const sc = scopes.find(s => s.slug === t.scope);
    if (!sc)
      out.push({ rule: 'scope', title: `scope-${t.scope} finnes ikke`, hint: `Scope i oppgave.md peker på tasks/${t.dom}/scope-${t.scope}.md, som ikke finnes. Opprett scopet med fs-scope, eller fjern feltet.`, file: 'oppgave.md' });
    else if (sc.dom !== t.dom)
      out.push({ rule: 'scope', title: `scope-${t.scope} ligger i ${sc.dom}`, hint: 'Oppgavene i et scope ligger i samme domene som scope-fila.', file: 'oppgave.md' });
    else if (!sc.rows.some(r => r.task === t.slug))
      out.push({ rule: 'scope', title: `Står ikke i scope-${t.scope}`, hint: `Oppgaven har Scope: scope-${t.scope}, men står ikke i tabellen «Oppgaver» i scopet. Legg den til med fs-scope, eller fjern feltet.`, file: 'oppgave.md' });
  }
  return out;
}

/** Hele oppgavelista med regelsjekk, sortert på domene og tittel */
export function buildTasks(snap: TasksSnapshot, scopes: Scope[] = buildScopes(snap)): Task[] {
  return snap.tasks
    .map(raw => {
      const t = parseTask(raw);
      t.lint = taskLint(t, scopes);
      return t;
    })
    .sort((a, b) => a.dom.localeCompare(b.dom) || a.title.localeCompare(b.title, 'nb'));
}

// —— Scope (tasks/<domene>/scope-<slug>.md) ——

/** Én rad i tabellen «Oppgaver» i scopet: oppgaven (null for «ikke tildelt») og kravene den har */
export interface ScopeRow {
  task: string | null;
  /** Feature-ID-ene i Krav-kolonnen, med @ (`@OPT-PLA-RUN-001`) */
  ids: string[];
  /** Stiene under krav/ fra lenkene i Krav-kolonnen */
  paths: string[];
  moscow: string | null;
  sketches: { name: string; url: string }[];
  issue: number | null;
  comment: string;
}

export interface Scope {
  dom: string;
  /** Slugen i filnavnet (`scope-<slug>.md`) */
  slug: string;
  /** `tasks/<dom>/scope-<slug>.md` */
  path: string;
  title: string;
  /** Slug-feltet i fila, når det står */
  metaSlug: string | null;
  initiativ: string | null;
  owner: string | null;
  updated: string | null;
  rows: ScopeRow[];
  mtime: number | null;
  lint: TaskLint[];
}

const SCOPE_FILE = /^tasks\/([^/]+)\/scope-([^/]+)\.md$/;
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

/** Relativ lenke fra `tasks/<dom>/` til krav/ → stien under krav/ */
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

/** Tolker én scope-fil (uten sjekkene på tvers av scopene) */
export function parseScope(path: string, src: string, mtime: number | null = null): Scope | null {
  const m = SCOPE_FILE.exec(path);
  if (!m) return null;
  const [, dom, slug] = m;
  const meta = inlineMeta(src);
  const title = (/^#\s+(.+)$/m.exec(src)?.[1].trim() ?? slug).replace(/^Scope:\s*/i, '');
  const domDir = `tasks/${dom}`;
  const rows: ScopeRow[] = namedTable(src, /^#{1,6}\s+Oppgaver\b/).map(r => {
    const oppg = r['oppgave'] ?? '';
    const ol = links(oppg)[0];
    const taskVal = ol ? (ol.href.replace(/\/+$/, '').split('/').pop() || ol.text) : clean(oppg);
    const task = /^[a-z0-9][a-z0-9-]*$/.test(taskVal) ? taskVal : null;
    const krav = r['krav'] ?? '';
    const ids = [...new Set([...krav.matchAll(FEATURE_ID)].map(x => '@' + x[1]))];
    const paths = links(krav)
      .map(l => linkTarget(l.href, domDir))
      .filter((p): p is string => !!p && p.startsWith('krav/'));
    const sk = r['skisse'] ?? '';
    return {
      task,
      ids,
      paths,
      moscow: none(r['moscow'])?.split(/\s/)[0] ?? null,
      sketches: links(sk).map(l => ({ name: l.text || l.href, url: l.href })),
      issue: Number(/#(\d+)/.exec(r['issue'] ?? '')?.[1]) || null,
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
    owner: none(meta['Eier']),
    updated: none(meta['Siste oppdatering']),
    rows,
    mtime,
    lint: [],
  };
  return scope;
}

/** Sjekker scopet mot reglene i tasks/README.md: slugen, unik på tvers av domener, og at oppgavene finnes */
export function scopeLint(sc: Scope, all: Scope[], snap: TasksSnapshot): TaskLint[] {
  const out: TaskLint[] = [];
  const file = sc.path.split('/').pop()!;
  if (!/^[a-z0-9][a-z0-9-]*$/.test(sc.slug))
    out.push({ rule: 'scope', title: `${file}: ugyldig slug`, hint: 'Slugen i scope-<slug>.md skrives i kebab-case: små bokstaver (a–z), tall og bindestrek.', file });
  if (sc.metaSlug && sc.metaSlug !== sc.slug)
    out.push({ rule: 'scope', title: `Slug er ${sc.metaSlug}, men fila heter scope-${sc.slug}.md`, hint: 'Slug i scope-fila skal være lik slugen i filnavnet.', file });
  const twins = all.filter(o => o !== sc && o.slug === sc.slug);
  if (twins.length)
    out.push({ rule: 'scope', title: `scope-${sc.slug} finnes også i ${twins.map(o => o.dom).join(', ')}`, hint: 'Scope-slugen er unik på tvers av domener, fordi @scope-<slug> ikke har domene.', file });
  if (!DOMAINS[sc.dom])
    out.push({ rule: 'r4', title: `${sc.dom} er ikke et domene`, hint: 'Domenet finnes ikke i domenetabellen i tasks/README.md.', file });
  for (const r of sc.rows) {
    if (r.task && !snap.tasks.some(t => t.dom === sc.dom && t.slug === r.task))
      out.push({ rule: 'scope', title: `Oppgaven ${r.task} finnes ikke i ${sc.dom}`, hint: `Tabellen «Oppgaver» i scopet viser til tasks/${sc.dom}/${r.task}/, som ikke finnes. Oppgavene i et scope ligger i samme domene som scope-fila.`, file });
  }
  return out;
}

/** Alle scopene med regelsjekk, sortert på domene og tittel */
export function buildScopes(snap: TasksSnapshot): Scope[] {
  const all = Object.entries(snap.scopes ?? {})
    .map(([p, src]) => parseScope(p, src, snap.scopeMtimes?.[p] ?? null))
    .filter((s): s is Scope => !!s);
  for (const sc of all) sc.lint = scopeLint(sc, all, snap);
  return all.sort((a, b) => a.dom.localeCompare(b.dom) || a.title.localeCompare(b.title, 'nb'));
}

/**
 * En minimal oppgave.md fra malen (tasks/mal/oppgave.md), til «+ Ny oppgave» på tavla: tittel, issue, domene, slug,
 * scope og eier, uten malkommentar og plassholdere, og én linje i statusloggen.
 */
export function newOppgaveText(o: { title: string; dom: string; slug: string; issue?: number | null; owner?: string | null; scope?: string | null; date: string; via: string }): string {
  const issue = o.issue ? `[sikt-no/fs#${o.issue}](https://github.com/sikt-no/fs/issues/${o.issue})` : '–';
  return [
    `# ${o.title}`,
    '',
    '## Metadata',
    '',
    `- **Issue**: ${issue}`,
    `- **Domene**: ${o.dom} (se [\`../../README.md\`](../../README.md#domener))`,
    `- **Slug**: ${o.slug}`,
    `- **Scope**: ${o.scope ? `[scope-${o.scope}](../scope-${o.scope}.md)` : '–'}`,
    `- **Eier**: ${o.owner || '–'}`,
    '',
    ...(o.issue ? [] : ['## Åpne punkter', '', '- Oppgaven har ikke et issue ennå.', '']),
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
