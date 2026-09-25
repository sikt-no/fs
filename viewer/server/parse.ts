import { AstBuilder, GherkinClassicTokenMatcher, Parser } from '@cucumber/gherkin';
import { IdGenerator } from '@cucumber/messages';
import type { Background, Scenario, Step as GStep, Tag } from '@cucumber/messages';
import { STATUSES, statusOf, type Entry, type FeatureModel, type Lint, type Note, type Question, type Rule, type Scen, type Step } from '../shared/model.ts';

const isStatus = (t: string) => (STATUSES as readonly string[]).includes(t.slice(1));
const PRIORITIES = ['@must', '@should', '@could', '@wont'];
// Tre bokstaver per ledd, men README tillater unntak for lesbarhet (f.eks. @TEK-BRU-UI-001)
const FEATURE_ID = /^@[A-ZÆØÅ]{2,4}-[A-ZÆØÅ]{2,4}-[A-ZÆØÅ]{2,4}-\d{3}$/;
const SNAKE_CASE = /^[a-zæøå0-9]+(_[a-zæøå0-9]+)*\.feature$/;
const STEP_RANK: Record<string, number> = { Context: 0, Action: 1, Outcome: 2 };

const desc = (d: string | undefined) =>
  (d ?? '')
    .split('\n')
    .map(l => l.trim())
    .join('\n')
    .trim();

function step(s: GStep): Step {
  return {
    kw: s.keyword.trim(),
    text: s.text,
    ln: s.location.line,
    table: s.dataTable?.rows.map(r => r.cells.map(c => c.value)),
    doc: s.docString?.content,
  };
}

function background(b: Background): Scen {
  return { kind: 'Bakgrunn', name: b.name, ln: b.location.line, tags: [], desc: desc(b.description), notes: [], steps: b.steps.map(step), examples: [] };
}

function scenario(s: Scenario): Scen {
  const outline = s.examples.length > 0 || /^(Scenariomal|Abstrakt Scenario)$/.test(s.keyword.trim());
  return {
    kind: outline ? 'Scenariomal' : 'Scenario',
    name: s.name,
    ln: s.location.line,
    tags: s.tags.map(t => t.name),
    desc: desc(s.description),
    notes: [],
    steps: s.steps.map(step),
    examples: s.examples
      .filter(e => e.tableHeader)
      .map(e => ({
        name: e.name,
        tags: e.tags.map(t => t.name),
        desc: desc(e.description),
        rows: [e.tableHeader!, ...e.tableBody].map(r => r.cells.map(c => c.value)),
      })),
  };
}

interface Block {
  note: Note;
  from: number;
  to: number;
  col: number;
}

const QHEAD = /^(?:ÅPNE|ÅPENT|ÅPENE) SPØRSMÅL\s*[:—–-]?\s*(.*)$/i;
const NHEAD = /^([A-ZÆØÅ][A-Za-zÆØÅæøå0-9. ]{0,24}):\s*(.*)$/;

/**
 * Deler kommentarene i sammenhengende blokker. En «# ÅPNE SPØRSMÅL:»-blokk blir et spørsmål
 * med ett punkt per «- »-linje; den tåler tomme linjer så lenge neste kommentar er et punkt
 * eller en fortsettelse. Alt annet blir en vanlig kommentar.
 */
function commentBlocks(comments: { line: number; text: string }[], lines: string[]): Block[] {
  const out: Block[] = [];
  let cur: Block | null = null;
  for (const c of comments) {
    const raw = c.text.trim().replace(/^#\s?/, '');
    const text = raw.trim();
    if (/^language:/.test(text) || /^GitHub:\s*#\d+/.test(text)) {
      cur = null;
      continue;
    }
    const gap = cur ? lines.slice(cur.to, c.line - 1) : [];
    const blankOnly = gap.every(l => l.trim() === '');
    const q = QHEAD.exec(text);
    const continues =
      cur !== null &&
      !q &&
      blankOnly &&
      (gap.length === 0 || (cur.note.kind === 'question' && (text.startsWith('- ') || /^\s{2,}\S/.test(raw))));
    if (!continues) {
      cur = { note: { kind: q ? 'question' : 'note', ln: c.line, items: [] }, from: c.line, to: c.line, col: lines[c.line - 1].indexOf('#') + 1 };
      out.push(cur);
      if (q) {
        if (q[1]) cur.note.items.push({ text: q[1].replace(/^-\s*/, ''), ln: c.line });
        continue;
      }
      const h = NHEAD.exec(text);
      if (h) {
        cur.note.head = h[1];
        if (h[2]) cur.note.items.push({ text: h[2], ln: c.line });
        continue;
      }
    }
    cur = cur!;
    cur.to = c.line;
    if (cur.note.kind === 'question') {
      if (text.startsWith('- ')) cur.note.items.push({ text: text.slice(2), ln: c.line });
      else if (text && cur.note.items.length) cur.note.items[cur.note.items.length - 1].text += ' ' + text;
      else if (text) cur.note.items.push({ text, ln: c.line });
    } else if (text && !/^[=\-_*#]{3,}$/.test(text)) {
      cur.note.items.push({ text: raw.replace(/\s+$/, ''), ln: c.line });
    }
  }
  return out.filter(b => b.note.items.length > 0 || b.note.head);
}

/** Et element kommentarer kan høre til: egenskapen, en regel, en bakgrunn eller et scenario. */
interface El {
  start: number; // første tag-linje, ellers nøkkelord-linjen
  kw: number;
  col: number;
  end: number;
  notes: Note[];
  scen?: Scen;
  depth: number; // 0 egenskap, 1 regel / løst scenario, 2 scenario i regel
  prev?: El; // forrige søsken
}

const headerStart = (kw: number, tags: readonly Tag[]) => Math.min(kw, ...tags.map(t => t.location.line));

/**
 * Knytter hver kommentarblokk til elementet den hører til:
 * 1. blokken står mellom elementets tagger og nøkkelord,
 * 2. blokken står rett over elementet (uten tom linje imellom),
 *    eller mellom to søsken med samme innrykk som det neste, eller
 * 3. det innerste elementet som omslutter blokken og har mindre innrykk.
 * Vanlige kommentarer mellom steg festes til steget etter.
 */
function attach(blocks: Block[], els: El[], lines: string[]) {
  const byStart = new Map(els.map(e => [e.start, e]));
  for (const b of blocks) {
    let el = els.find(e => e.start <= b.from && b.to < e.kw) ?? byStart.get(b.to + 1);
    if (!el) {
      let nxt = b.to + 1;
      while (nxt <= lines.length && lines[nxt - 1].trim() === '') nxt++;
      const cand = byStart.get(nxt);
      if (cand?.prev && cand.prev.kw < b.from && cand.col === b.col) el = cand;
    }
    if (!el) {
      el = els
        .filter(e => e.kw < b.from && b.from <= e.end && e.col < b.col)
        .sort((x, y) => y.depth - x.depth)[0];
      const next = el?.scen?.steps.find(st => st.ln > b.to);
      if (el?.scen && next && b.note.kind === 'note' && b.from > el.scen.steps[0]?.ln - 1) {
        (next.notes ??= []).push(b.note);
        continue;
      }
    }
    (el ?? els[0]).notes.push(b.note);
  }
}

/** `path` er relativ til repo-roten (f.eks. «krav/02 Opptak/…»), og brukes til sjekkene av filnavn og mappenivå. */
export function parseFeature(source: string, path?: string): FeatureModel {
  // Norsk som standard, som i playwright-bdd: en fil uten «# language: no» parses likevel, og får et avvik
  const parser = new Parser(new AstBuilder(IdGenerator.incrementing()), new GherkinClassicTokenMatcher('no'));
  const doc = parser.parse(source);
  const f = doc.feature;
  if (!f) throw new Error('Filen mangler Egenskap:');
  const lines = source.replace(/\n$/, '').split('\n');
  const comments = doc.comments.map(c => ({ line: c.location.line, text: c.text }));
  const nLines = lines.length;

  const fnotes: Note[] = [];
  const els: El[] = [{ start: headerStart(f.location.line, f.tags), kw: f.location.line, col: f.location.column ?? 1, end: nLines, notes: fnotes, depth: 0 }];
  const lint: Lint[] = [];
  const rawKw = new Map<Scen, { keyword: string; ln: number }>();
  const rawSteps = new Map<Scen, readonly GStep[]>();

  const rules: Rule[] = [];
  let loose: Rule | null = null;
  const looseBlock = (ln: number) => {
    if (!loose) {
      loose = { name: null, tags: [], desc: '', notes: [], ln, scenarios: [] };
      rules.push(loose);
    }
    return loose;
  };
  // Ender settes etterpå: linjen før neste søskens første linje
  const siblings: El[][] = [[]];
  const addScen = (sc: Scen, node: Scenario | Background, tags: readonly Tag[], depth: number) => {
    const el: El = { start: headerStart(node.location.line, tags), kw: node.location.line, col: node.location.column ?? 1, end: nLines, notes: sc.notes, scen: sc, depth };
    els.push(el);
    siblings[siblings.length - 1].push(el);
    if ('examples' in node) {
      rawKw.set(sc, { keyword: node.keyword.trim(), ln: node.location.line });
      rawSteps.set(sc, node.steps);
    }
  };

  for (const child of f.children) {
    if (child.background) {
      const sc = background(child.background);
      rules.push({ name: null, tags: [], desc: '', notes: [], ln: child.background.location.line, scenarios: [sc] });
      addScen(sc, child.background, [], 1);
      loose = null;
    } else if (child.scenario) {
      const sc = scenario(child.scenario);
      looseBlock(child.scenario.location.line).scenarios.push(sc);
      addScen(sc, child.scenario, child.scenario.tags, 1);
    } else if (child.rule) {
      const r = child.rule;
      const rule: Rule = { name: r.name, tags: r.tags.map(t => t.name), desc: desc(r.description), notes: [], ln: r.location.line, scenarios: [] };
      const rel: El = { start: headerStart(r.location.line, r.tags), kw: r.location.line, col: r.location.column ?? 1, end: nLines, notes: rule.notes, depth: 1 };
      els.push(rel);
      siblings[0].push(rel);
      siblings.push([]);
      for (const rc of r.children) {
        if (rc.background) {
          const sc = background(rc.background);
          rule.scenarios.push(sc);
          addScen(sc, rc.background, [], 2);
        } else if (rc.scenario) {
          const sc = scenario(rc.scenario);
          rule.scenarios.push(sc);
          addScen(sc, rc.scenario, rc.scenario.tags, 2);
        }
      }
      // Scenarioene i regelen er søsken av hverandre, men slutter senest der regelen slutter
      const inner = siblings.pop()!;
      inner.forEach(e => (e.end = -1));
      (rel as El & { inner?: El[] }).inner = inner;
      rules.push(rule);
      loose = null;
    }
  }
  // Toppnivå: regler og løse scenarioer/bakgrunner slutter der neste begynner
  const top = siblings[0];
  top.forEach((e, i) => (e.end = i + 1 < top.length ? top[i + 1].start - 1 : nLines));
  for (const e of top) {
    const inner = (e as El & { inner?: El[] }).inner;
    inner?.forEach((x, i) => (x.end = i + 1 < inner.length ? inner[i + 1].start - 1 : e.end));
  }

  top.forEach((e, i) => (e.prev = top[i - 1]));
  for (const e of top) {
    const inner = (e as El & { inner?: El[] }).inner;
    inner?.forEach((x, i) => (x.prev = inner[i - 1]));
  }
  attach(commentBlocks(comments, lines), els, lines);

  // Konvensjonsavvik: holdes i synk med krav/README.md (importert i .claude/rules/gherkin-conventions.md).
  // Reglene som sjekkes er merket «(sjekkes i vieweren)» der, og testet i parse.test.ts.
  const firstLine = lines.find(l => l.trim() !== '') ?? '';
  if (!/^\s*#\s*language:\s*no\s*$/.test(firstLine)) lint.push({ msg: 'Fila starter ikke med «# language: no»', ln: 1 });
  if (path?.startsWith('krav/')) {
    const seg = path.split('/');
    if (seg.length !== 5) lint.push({ msg: 'Fila ligger ikke på kapabilitetsnivå (krav/Domene/Sub-domene/Kapabilitet/)', ln: 1 });
    if (!SNAKE_CASE.test(seg[seg.length - 1])) lint.push({ msg: `Filnavnet «${seg[seg.length - 1]}» er ikke i snake_case`, ln: 1 });
  }
  const ftags = f.tags.map(t => t.name);
  const ids = ftags.filter(t => FEATURE_ID.test(t));
  if (ids.length === 0) lint.push({ msg: 'Egenskap mangler feature-ID (@DOM-SUB-KAP-NNN)', ln: f.location.line });
  if (ids.length > 1) lint.push({ msg: `Egenskap har flere feature-IDer: ${ids.join(' ')}`, ln: f.location.line });
  const prio = ftags.filter(t => PRIORITIES.includes(t));
  if (prio.length > 1) lint.push({ msg: `Egenskap har flere prioritetstagger: ${prio.join(' ')}`, ln: f.location.line });
  const fstat = ftags.filter(t => isStatus(t));
  if (fstat.length === 0) lint.push({ msg: 'Egenskap mangler statustag (@draft, @planned, @in-progress eller @implemented)', ln: f.location.line });
  if (fstat.length > 1) lint.push({ msg: `Egenskap har flere statustagger: ${fstat.join(' ')}`, ln: f.location.line });
  if (ftags.includes('@openquestion')) lint.push({ msg: '@openquestion hører hjemme på Regel/Scenario, ikke på Egenskap', ln: f.location.line });
  const fdraft = statusOf(ftags) === 'draft';
  let partialDraft = false;
  const hasQ = (notes: Note[]) => notes.some(n => n.kind === 'question');
  const checkPart = (what: string, tags: string[], ln: number, questions: boolean) => {
    for (const t of tags.filter(t => isStatus(t) && t !== '@draft')) lint.push({ msg: `${t} på ${what} — bare @draft er lov under Egenskap`, ln });
    if (tags.includes('@draft')) {
      if (fdraft) lint.push({ msg: `@draft på ${what} er overflødig når hele egenskapen er @draft`, ln });
      else partialDraft = true;
    }
    if (tags.includes('@openquestion') && !questions) lint.push({ msg: `@openquestion på ${what} uten «# ÅPNE SPØRSMÅL:»-kommentar`, ln });
  };
  const scenQ = (sc: Scen) => hasQ(sc.notes) || sc.steps.some(st => hasQ(st.notes ?? []));
  for (const r of rules) {
    if (r.name !== null) checkPart('Regel', r.tags, r.ln, hasQ(r.notes) || r.scenarios.some(scenQ));
    for (const sc of r.scenarios) {
      if (sc.kind === 'Bakgrunn') continue;
      checkPart(sc.kind, sc.tags, sc.ln, scenQ(sc));
      // Og/Men arver typen til steget før, og teller ikke
      let rank = -1;
      for (const st of rawSteps.get(sc) ?? []) {
        const r = STEP_RANK[st.keywordType ?? ''];
        if (r === undefined) continue;
        if (r < rank) {
          lint.push({ msg: `«${st.keyword.trim()}» etter ${rank === 2 ? '«Så»' : '«Når»'} — stegene skal gå Gitt → Når → Så`, ln: st.location.line });
          break;
        }
        rank = r;
      }
      const raw = rawKw.get(sc);
      if (raw && sc.examples.length && !/^(Scenariomal|Abstrakt Scenario)$/.test(raw.keyword))
        lint.push({ msg: `«${raw.keyword}:» med Eksempler — bruk Scenariomal:`, ln: raw.ln });
    }
  }
  lint.sort((a, b) => a.ln - b.ln);

  const allNotes = [
    ...fnotes,
    ...rules.flatMap(r => [...r.notes, ...r.scenarios.flatMap(sc => [...sc.notes, ...sc.steps.flatMap(st => st.notes ?? [])])]),
  ];
  const questions: Question[] = allNotes
    .filter(n => n.kind === 'question')
    .flatMap(n => n.items)
    .sort((a, b) => a.ln - b.ln);

  const issue = comments.map(c => c.text.match(/^\s*#\s*GitHub:\s*#(\d+)/)).find(Boolean)?.[1] ?? null;

  return {
    tags: ftags,
    title: f.name,
    desc: f.description
      .split('\n')
      .map(l => l.trim())
      .filter(Boolean)
      .map(l => {
        const m = l.match(/^(Som|ønsker jeg|slik at)\s+(.*)$/i);
        return m ? { lead: m[1], rest: m[2] } : { lead: '', rest: l };
      }),
    issue,
    lang: f.language,
    rules,
    notes: fnotes,
    questions,
    lint,
    partialDraft,
    nLines,
    nRules: rules.filter(r => r.name !== null).length,
    nScen: rules.reduce((n, r) => n + r.scenarios.filter(s => s.kind !== 'Bakgrunn').length, 0),
  };
}

/** Parser på nytt, men beholder sist gyldige modell ved parse-feil. */
export function buildEntry(path: string, source: string, savedAt: number, prev?: Entry): Entry {
  if (path.endsWith('.md')) return { path, kind: 'md', status: null, source, savedAt };
  try {
    const model = parseFeature(source, path);
    return { path, kind: 'feature', status: statusOf(model.tags), partialDraft: model.partialDraft, lint: model.lint.length, model, savedAt };
  } catch (e) {
    const error = e instanceof Error ? e.message : String(e);
    return { path, kind: 'feature', status: prev?.status ?? null, partialDraft: prev?.partialDraft, lint: prev?.lint, model: prev?.model, error, savedAt };
  }
}
