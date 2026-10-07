import { AstBuilder, dialects, GherkinClassicTokenMatcher, Parser } from '@cucumber/gherkin';
import { IdGenerator } from '@cucumber/messages';
import type { Background, Scenario, Step as GStep, Tag } from '@cucumber/messages';
import { RULE } from '../shared/rules.ts';
import { STATUSES, statusOf, type Entry, type FeatureModel, type Lint, type Note, type Question, type Rule, type Scen, type Step } from '../shared/model.ts';

const isStatus = (t: string) => (STATUSES as readonly string[]).includes(t.slice(1));
const PRIORITIES = ['@must', '@should', '@could', '@wont'];
// Tre bokstaver per ledd, men README tillater unntak for lesbarhet (f.eks. @TEK-BRU-UI-001)
const FEATURE_ID = /^@[A-ZÆØÅ]{2,4}-[A-ZÆØÅ]{2,4}-[A-ZÆØÅ]{2,4}-\d{3}$/;
const SNAKE_CASE = /^[a-zæøå0-9]+(_[a-zæøå0-9]+)*\.feature$/;
const STEP_RANK: Record<string, number> = { Context: 0, Action: 1, Outcome: 2 };

// Nøkkelordene som innleder en blokk, og det norske nøkkelordet vi foreslår for hver type
const BLOCK_KW = { feature: 'Egenskap', rule: 'Regel', background: 'Bakgrunn', scenario: 'Scenario', scenarioOutline: 'Scenariomal', examples: 'Eksempler' } as const;
const BLOCK_TYPES = Object.keys(BLOCK_KW) as (keyof typeof BLOCK_KW)[];
const KW_NO = BLOCK_TYPES.flatMap(k => dialects.no[k]);
const KW_EN = BLOCK_TYPES.flatMap(k => dialects.en[k].map(w => [w.toLowerCase(), BLOCK_KW[k]] as const));
const STEP_KW = [...new Set([...dialects.no.given, ...dialects.no.when, ...dialects.no.then, ...dialects.no.and, ...dialects.no.but])];
const KW_CANDIDATE = /^([A-Za-zÆØÅæøå]+(?: [A-Za-zÆØÅæøå]+)?)\s*:/;

function distance(a: string, b: string): number {
  let row = Array.from({ length: b.length + 1 }, (_, j) => j);
  for (let i = 1; i <= a.length; i++) {
    const next = [i];
    for (let j = 1; j <= b.length; j++) next[j] = Math.min(row[j] + 1, next[j - 1] + 1, row[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
    row = next;
  }
  return row[b.length];
}

/** Det norske nøkkelordet `word` ligner på (feil stor/liten bokstav, skrivefeil eller engelsk), ellers null */
function lookalike(word: string): string | null {
  if (KW_NO.includes(word)) return null;
  const w = word.toLowerCase();
  let best: string | null = null;
  let bestD = Infinity;
  for (const k of KW_NO) {
    const d = distance(w, k.toLowerCase());
    if (d <= (k.length > 6 ? 2 : 1) && d < bestD) [best, bestD] = [k, d];
  }
  return best ?? KW_EN.find(([e]) => e === w)?.[1] ?? null;
}

/**
 * Parse-feilen fra @cucumber/gherkin som avvik, med linjenummer og forslag når linja ligner et nøkkelord.
 * Bare den første feilen tas med: resten er som regel følgefeil av den.
 */
export function parseErrorLints(error: string): Lint[] {
  const out: Lint[] = [];
  for (const l of error.split('\n')) {
    if (out.length) break;
    const m = /^\((\d+):\d+\): (.*)$/.exec(l.trim());
    if (!m) continue;
    const got = /got '(.*)'$/.exec(m[2])?.[1].trim();
    const kw = got && KW_CANDIDATE.exec(got);
    const hint = kw && lookalike(kw[1]);
    const msg = got
      ? `«${got}» kan ikke stå her${hint ? ` — «${kw[1]}:» er ikke et nøkkelord, mente du «${hint}:»?` : ''}`
      : m[2];
    out.push({ rule: 'parse-error', sev: RULE['parse-error'].sev, msg: 'Kan ikke parses: ' + msg, ln: +m[1] });
  }
  if (!out.length) out.push({ rule: 'parse-error', sev: RULE['parse-error'].sev, msg: 'Kan ikke parses: ' + error.replace(/^Parser errors:?\s*/, ''), ln: 1 });
  return out;
}

const desc = (d: string | undefined) =>
  (d ?? '')
    .split('\n')
    .map(l => l.trim())
    .join('\n')
    .trim();

/** De ikke-tomme linjene i en beskrivelse, med linja hver står på i fila (beskrivelsen står etter nøkkelordlinja `after`) */
function descLines(d: string | undefined, lines: string[], after: number) {
  const out: { text: string; ln: number }[] = [];
  let i = after; // indeks i `lines` for linja etter nøkkelordet
  for (const text of (d ?? '').split('\n').map(l => l.trim()).filter(Boolean)) {
    while (i < lines.length && lines[i].trim() !== text) i++;
    out.push({ text, ln: i < lines.length ? i + 1 : after });
    if (i < lines.length) i++;
  }
  return out;
}

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
        lns: [e.tableHeader!, ...e.tableBody].map(r => r.location.line),
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
  // Reglene som sjekkes er merket «(sjekkes automatisk)» der, beskrevet i shared/rules.ts, og testet i parse.test.ts.
  const push = (rule: string, msg: string, ln: number) => lint.push({ rule, sev: RULE[rule].sev, msg, ln });
  const firstLine = lines.find(l => l.trim() !== '') ?? '';
  if (!/^\s*#\s*language:\s*no\s*$/.test(firstLine)) push('missing-language', 'Fila starter ikke med «# language: no»', 1);
  if (path?.startsWith('krav/')) {
    const seg = path.split('/');
    if (seg.length !== 5) push('wrong-level', 'Fila ligger ikke på kapabilitetsnivå (krav/Domene/Sub-domene/Kapabilitet/)', 1);
    if (!SNAKE_CASE.test(seg[seg.length - 1])) push('not-snake-case', `Filnavnet «${seg[seg.length - 1]}» er ikke i snake_case`, 1);
    // _Interne prosesser og 99 Demo følger ikke nummereringen
    if (seg.length === 5 && !/^(_|99 )/.test(seg[1])) {
      const [sub, kap] = [seg[2], seg[3]];
      const n = sub.match(/^(\d+) /);
      if (!n) push('folder-numbering', `Sub-domenet «${sub}» mangler nummer (fra 10)`, 1);
      else if (+n[1] < 10) push('folder-numbering', `Sub-domenet «${sub}» er nummerert under 10`, 1);
      if (!/^\d+ /.test(kap)) push('folder-numbering', `Kapabiliteten «${kap}» mangler nummer (fra 01)`, 1);
      const bare = (s: string) => s.replace(/^\d+ /, '').trim().toLowerCase();
      if (bare(sub) === bare(kap)) push('same-name', `Sub-domene og kapabilitet heter begge «${kap.replace(/^\d+ /, '')}»`, 1);
    }
  }
  const ftags = f.tags.map(t => t.name);
  const ids = ftags.filter(t => FEATURE_ID.test(t));
  if (ids.length === 0) push('missing-id', 'Egenskap mangler feature-ID (@DOM-SUB-KAP-NNN)', f.location.line);
  if (ids.length > 1) push('multiple-ids', `Egenskap har flere feature-IDer: ${ids.join(' ')}`, f.location.line);
  const prio = ftags.filter(t => PRIORITIES.includes(t));
  if (prio.length > 1) push('multiple-priorities', `Egenskap har flere prioritetstagger: ${prio.join(' ')}`, f.location.line);
  const fstat = ftags.filter(t => isStatus(t));
  if (fstat.length === 0) push('missing-status', 'Egenskap mangler statustag (@draft, @planned, @in-progress, @implemented eller @deprecated)', f.location.line);
  if (fstat.length > 1) push('multiple-statuses', `Egenskap har flere statustagger: ${fstat.join(' ')}`, f.location.line);
  if (ftags.includes('@openquestion')) push('openquestion-on-feature', '@openquestion hører hjemme på Regel/Scenario, ikke på Egenskap', f.location.line);
  if (!desc(f.description)) push('missing-description', 'Egenskap mangler beskrivelse (Som … ønsker jeg … slik at …)', f.location.line);
  // Tagger som ikke skal stå noe sted i fila
  lines.forEach((l, i) => {
    if (!l.trim().startsWith('@')) return;
    const tags = l.trim().split(/\s+/);
    if (tags.includes('@levert')) push('retired-levert', '@levert er erstattet av @implemented', i + 1);
    if (tags.includes('@only')) push('focus-tag', '@only gjør scenarioet om til test.only — resten av testene hoppes over', i + 1);
    if (tags.includes('@focus')) push('focus-tag', '@focus har ingen virkning i playwright-bdd og skal ikke stå i en kravfil', i + 1);
  });
  // En linje som ligner et nøkkelord uten å være det, leser Gherkin som beskrivelse
  let fence: string | null = null;
  lines.forEach((l, i) => {
    const t = l.trim();
    if (fence) {
      if (t.startsWith(fence)) fence = null;
      return;
    }
    if (t.startsWith('"""') || t.startsWith('```')) fence = t.slice(0, 3);
    if (fence || /^[#@|]/.test(t) || STEP_KW.some(k => t.startsWith(k))) return;
    const m = KW_CANDIDATE.exec(t);
    const kw = m && lookalike(m[1]);
    if (kw) push('unknown-keyword', `«${m[1]}:» er ikke et nøkkelord, og linja leses som beskrivelse — mente du «${kw}:»?`, i + 1);
  });
  for (const c of comments) if (/^\s*#\s*TODO\b/i.test(c.text)) push('todo-comment', '«# TODO:» brukt for åpent spørsmål — bruk «# ÅPNE SPØRSMÅL:» og @openquestion', c.line);
  const fstatus = statusOf(ftags);
  const fdraft = fstatus === 'draft';
  let partialDraft = false;
  let partialChange = false;
  const hasQ = (notes: Note[]) => notes.some(n => n.kind === 'question');
  const checkPart = (what: string, tags: string[], ln: number, questions: boolean) => {
    for (const t of tags.filter(t => isStatus(t) && t !== '@draft' && t !== '@deprecated')) {
      if (t === '@implemented') push('status-on-part', `@implemented på ${what} — en levert del har ingen egen status, den arver @implemented fra Egenskap`, ln);
      else if (fstatus !== 'implemented') push('status-on-part', `${t} på ${what} — @planned og @in-progress er bare lov på deler under en @implemented egenskap`, ln);
      else partialChange = true;
    }
    const pst = tags.filter(t => isStatus(t) && t !== '@implemented');
    if (pst.length > 1 && !(pst.length === 2 && pst.includes('@draft') && pst.includes('@deprecated')))
      push('part-multiple-statuses', `${what} har flere statustagger: ${pst.join(' ')}`, ln);
    if (tags.includes('@deprecated')) {
      if (tags.includes('@draft')) push('deprecated-and-draft', `@deprecated og @draft på ${what} — en del kan ikke være både utkast og avviklet`, ln);
      if (fstatus === 'deprecated') push('redundant-deprecated', `@deprecated på ${what} er overflødig når hele egenskapen er @deprecated`, ln);
      else if (fstatus === 'draft' || fstatus === 'planned') push('deprecated-not-delivered', `@deprecated på ${what} under en @${fstatus} egenskap — ingenting er levert, så slett delen`, ln);
    }
    if (tags.includes('@draft')) {
      if (fdraft) push('redundant-draft', `@draft på ${what} er overflødig når hele egenskapen er @draft`, ln);
      else {
        partialDraft = true;
        if (!tags.includes('@openquestion')) push('draft-without-openquestion', `@draft på ${what} uten @openquestion — delen er ikke gjennomgått`, ln);
      }
    }
    if (tags.includes('@openquestion') && !questions) push('openquestion-without-comment', `@openquestion på ${what} uten «# ÅPNE SPØRSMÅL:»-kommentar`, ln);
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
          push('step-order', `«${st.keyword.trim()}» etter ${rank === 2 ? '«Så»' : '«Når»'} — stegene skal gå Gitt → Når → Så`, st.location.line);
          break;
        }
        rank = r;
      }
      const raw = rawKw.get(sc);
      if (raw && sc.examples.length && !/^(Scenariomal|Abstrakt Scenario)$/.test(raw.keyword))
        push('examples-without-outline', `«${raw.keyword}:» med Eksempler — bruk Scenariomal:`, raw.ln);
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

  const issueC = comments.find(c => /^\s*#\s*GitHub:\s*#\d+/.test(c.text));
  const issue = issueC?.text.match(/#(\d+)/)?.[1] ?? null;
  // «# language:» er ikke en kommentar for parseren, så den finnes i teksten
  const langIdx = lines.findIndex(l => /^\s*#\s*language:/.test(l));

  return {
    tags: ftags,
    title: f.name,
    ln: f.location.line,
    tagLn: f.tags[0]?.location.line ?? null,
    issueLn: issueC?.line ?? null,
    langLn: langIdx >= 0 ? langIdx + 1 : null,
    desc: descLines(f.description, lines, f.location.line).map(({ text: l, ln }) => {
      const m = l.match(/^(Som|ønsker jeg|slik at)\s+(.*)$/i);
      return m ? { lead: m[1], rest: m[2], ln } : { lead: '', rest: l, ln };
    }),
    issue,
    lang: f.language,
    rules,
    notes: fnotes,
    questions,
    lint,
    partialDraft,
    partialChange,
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
    return { path, kind: 'feature', status: statusOf(model.tags), partialDraft: model.partialDraft, partialChange: model.partialChange, lint: model.lint.length, model, savedAt };
  } catch (e) {
    const error = e instanceof Error ? e.message : String(e);
    const parseLint = parseErrorLints(error);
    return { path, kind: 'feature', status: prev?.status ?? null, partialDraft: prev?.partialDraft, partialChange: prev?.partialChange, lint: (prev?.lint ?? 0) + parseLint.length, model: prev?.model, error, parseLint, savedAt };
  }
}
