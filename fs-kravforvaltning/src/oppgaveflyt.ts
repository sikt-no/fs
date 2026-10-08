// Avledninger for Oppgaver-modusen (designet «Oppgaver», runde 2): gate før neste fase, neste steg,
// krav-kobling, filtre og agent-prompt. Rene funksjoner uten Preact, testet i oppgaveflyt.test.ts.
import { displayStatus, type DisplayStatus, type Snapshot } from '../shared/model.ts';
import { PHASES, type Task } from '../shared/tasks.ts';
import { idIndex } from './specboard.ts';

/** Status på issuet i project-boardet per fase (tabellen i tasks/README.md) */
export const PH_ISSUE = ['Prioritert', 'Behovsanalyse → Løsningsalternativ', 'Utvikling', 'Innføring', 'Levert'];
/** Hvor `Egenskap:`-taggen i kravet skal stå i hver fase */
export const PH_TAG = ['planned', 'in-progress', 'in-progress', 'implemented', 'implemented'] as const;

export interface GateItem {
  t: string;
  ok: boolean;
  sub: string;
}

export const nextPhase = (t: Task) => PHASES[t.p + 1] ?? '';
const short = (n: string) => n.replace(/^@/, '');
/** Siste review i nåværende fase */
export const currentReview = (t: Task) => t.reviews.filter(r => r.from === PHASES[t.p]).slice(-1)[0];

/** Det som må være på plass før oppgaven kan gå til neste fase («Hva som produseres per faseovergang») */
export function gateOf(t: Task): GateItem[] {
  const g: GateItem[] = [];
  const p = t.p;
  if (p === 0) g.push({ t: 'design.md opprettet', ok: t.design, sub: 'design.md' });
  if (p === 1) {
    g.push({ t: 'Krav skrevet i spec/', ok: t.spec, sub: 'spec/spec-*.md' });
    if (!t.lag.length) g.push({ t: 'Plan for minst ett lag', ok: false, sub: '<lag>/plan-*.md' });
    t.lag.forEach(l => g.push({ t: `Plan for ${l.k}`, ok: !!l.plan, sub: `${l.k}/plan-*.md` }));
  }
  if (p === 2)
    t.lag.forEach(l =>
      g.push(
        l.plan
          ? { t: `${l.k}: alle planbokser avkrysset`, ok: l.plan[0] === l.plan[1], sub: `${l.plan[0]}/${l.plan[1]}` }
          : { t: `Plan for ${l.k}`, ok: false, sub: `${l.k}/plan-*.md` },
      ),
    );
  if (p === 3) {
    t.lag.forEach(l => g.push({ t: `Verifisering for ${l.k}`, ok: l.verification, sub: `${l.k}/verification-*.md` }));
    g.push({ t: 'PR-lenker i oppgave.md', ok: t.prs > 0, sub: `${t.prs} PR` });
  }
  if (p < 4) {
    if (t.lint.length) g.push({ t: 'Ingen regelbrudd i mappa', ok: false, sub: `${t.lint.length} avvik` });
    const r = currentReview(t);
    g.push({
      t: 'Review for improvement',
      ok: r?.ok === true,
      sub: !r ? 'ikke startet' : `${r.who ? short(r.who) : 'ukjent'} · ${r.ok === true ? 'merget' : r.ok === false ? 'forbedringer' : 'pågår'}`,
    });
  }
  return g;
}

/** Skillen eller handlingen som tar oppgaven videre */
export function nextOf(t: Task): string {
  const p = t.p;
  const pr = `fs-oppgave · ${PHASES[p]} → ${nextPhase(t)}`;
  if (p === 0) return t.design ? pr : 'fs-oppgave · opprett design.md';
  if (p === 1) {
    if (!t.spec) return 'fs-specify';
    if (!t.lag.length) return 'bat-analyze';
    const an = t.lag.find(l => !l.analysis);
    if (an) return `bat-analyze ${an.k}`;
    const pl = t.lag.find(l => !l.plan);
    return pl ? `bat-plan ${pl.k}` : pr;
  }
  if (p === 2) {
    const pl = t.lag.find(l => !l.plan);
    if (pl) return `bat-plan ${pl.k}`;
    const l = t.lag.find(l => l.plan && l.plan[0] < l.plan[1]);
    return l ? `bat-execute ${l.k} · task-${l.completions + 1}` : pr;
  }
  if (p === 3) {
    const l = t.lag.find(l => !l.verification);
    return l ? `bat-verify ${l.k}` : pr;
  }
  return 'ingen · levert';
}

export function reviewNote(t: Task): string {
  if (t.p === 4) return 'Ligger i roadmap-arkivet.';
  const cur = t.reviews.filter(r => r.from === PHASES[t.p]);
  const last = cur[cur.length - 1];
  if (last && last.ok === false) {
    const who = cur.map(r => r.who).filter((w): w is string => !!w).map(short);
    return `${last.who ? short(last.who) : 'Revieweren'} foreslo forbedringer. Neste review må gjøres av en annen${who.length ? ' enn ' + who.join(', ') : ''}.`;
  }
  return t.owner ? `Reviewer må være en annen enn eier (${short(t.owner)}).` : 'Ingen eier satt. Reviewer må være en tredjepart.';
}

export interface Gate {
  items: GateItem[];
  miss: number;
  ok: boolean;
  /** «klar» eller «2 av 4 mangler» */
  sum: string;
}
export function gate(t: Task): Gate {
  const items = gateOf(t);
  const miss = items.filter(g => !g.ok).length;
  return { items, miss, ok: miss === 0, sum: miss === 0 ? 'klar' : `${miss} av ${items.length} mangler` };
}

export function agentPrompt(t: Task): string {
  const g = gate(t);
  const lines = [
    `Oppgave ${t.issue ? '#' + t.issue : t.slug} (${t.dir}/): ${t.title}`,
    `Fase: ${t.phase ?? 'ukjent'}. Neste steg: ${nextOf(t)}.`,
    `Mangler før ${nextPhase(t) || 'arkiv'}: ${
      g.items
        .filter(i => !i.ok)
        .map(i => i.t)
        .join('; ') || 'ingenting'
    }.`,
  ];
  if (t.lint.length) {
    lines.push('', 'Mappa følger ikke reglene i tasks/README.md:');
    t.lint.forEach(l => lines.push(`- ${l.title}. ${l.hint}`));
  }
  lines.push('', 'Se tasks/README.md for faser og regler.');
  return lines.join('\n');
}

export interface KravItem {
  path: string;
  file: string;
  status: DisplayStatus;
  sub: string;
}
export interface KravLinks {
  items: KravItem[];
  more: number;
  /** Krav i spesifikasjonene som ikke finnes i krav/ lenger (omdøpt eller slettet) */
  missing: string[];
  /** Hvor koblingen kom fra: `## Krav` i spesifikasjonene, eller mappa i «Krav (Gherkin)» */
  from: 'spec' | 'lenke' | null;
}

const MAX_KRAV = 8;
const base = (p: string) => p.slice(p.lastIndexOf('/') + 1);

/** Kravfilene oppgaven gjelder, slått opp i krav-snapshotet */
export function kravFor(t: Task, entries: Snapshot): KravLinks {
  const feats = Object.values(entries).filter(e => e.kind === 'feature' && e.path.startsWith('krav/'));
  const item = (path: string): KravItem => {
    const e = entries[path];
    return { path, file: base(path), status: displayStatus(e), sub: e.model ? `${e.model.nRules ? e.model.nRules + ' regler · ' : ''}${e.model.nScen} scen.` : '' };
  };
  const inLink = (p: string) => !!t.kravLink && (p === t.kravLink || p.startsWith(t.kravLink + '/'));

  // 1. Kravene under «## Krav» i spesifikasjonene, slått opp på Feature-ID, så stien i lenken, så filnavnet
  const ids = idIndex(entries);
  const found = new Set<string>();
  const missing = new Set<string>();
  for (const k of t.specKrav) {
    const full = (k.id && ids.get(k.id)?.path) || (k.path && entries[k.path] ? k.path : null);
    if (full) {
      found.add(full);
      continue;
    }
    const hits = feats.filter(e => base(e.path) === k.file).map(e => e.path);
    if (!hits.length) missing.add(k.file);
    const narrowed = hits.filter(inLink);
    (narrowed.length ? narrowed : hits).forEach(h => found.add(h));
  }
  let paths = [...found];
  let from: KravLinks['from'] = paths.length ? 'spec' : null;
  // 2. Ellers: feature-filene under mappa oppgave.md lenker til
  if (!paths.length && t.kravLink) {
    paths = feats.map(e => e.path).filter(inLink);
    if (paths.length) from = 'lenke';
  }
  paths.sort();
  return { items: paths.slice(0, MAX_KRAV).map(item), more: Math.max(0, paths.length - MAX_KRAV), missing: [...missing].sort(), from };
}

export interface TreeRow {
  name: string;
  depth: number;
  dir: boolean;
  /** Sti relativt til oppgavemappa, for lenke; null for sammenslåtte rader */
  path: string | null;
  note: string;
  bad: boolean;
}

/**
 * Filtreet i mappa, kompakt: rota og ett nivå under, `task-N-completion.md` slått sammen,
 * og dypere mapper (krav-input/ osv.) vist som én rad med antall filer.
 */
export function treeRows(t: Task): TreeRow[] {
  const bad = new Set(t.lint.map(l => l.file).filter((f): f is string => !!f));
  const out: TreeRow[] = [{ name: t.slug + '/', depth: 0, dir: true, path: null, note: '', bad: false }];
  const root = t.files.filter(f => !f.includes('/'));
  const order = (f: string) => ['oppgave.md', 'design.md', 'flow.md', 'memory.md'].indexOf(f);
  root
    .sort((a, b) => (order(a) < 0 ? 99 : order(a)) - (order(b) < 0 ? 99 : order(b)) || a.localeCompare(b))
    .forEach(f => out.push({ name: f, depth: 1, dir: false, path: f, note: f === 'flow.md' ? 'alfred' : '', bad: bad.has(f) }));
  const dirs = [...new Set(t.files.filter(f => f.includes('/')).map(f => f.split('/')[0]))];
  const rank = (d: string) => (d === 'reviews' ? 0 : d === 'spec' ? 1 : 2);
  dirs.sort((a, b) => rank(a) - rank(b) || a.localeCompare(b));
  for (const d of dirs) {
    out.push({ name: d + '/', depth: 1, dir: true, path: null, note: '', bad: false });
    const inside = t.files.filter(f => f.startsWith(d + '/')).map(f => f.slice(d.length + 1));
    const lag = t.lag.find(l => l.k === d);
    const files = inside.filter(f => !f.includes('/') && !/^task-\d+-completion\.md$/.test(f)).sort();
    const done = inside.filter(f => /^task-\d+-completion\.md$/.test(f));
    for (const f of files)
      out.push({
        name: f,
        depth: 2,
        dir: false,
        path: `${d}/${f}`,
        note: lag?.plan && /^plan-.+\.md$/.test(f) ? `${lag.plan[0]}/${lag.plan[1]}` : '',
        bad: bad.has(`${d}/${f}`),
      });
    if (done.length) out.push({ name: done.length > 1 ? 'task-*-completion.md' : done[0], depth: 2, dir: false, path: done.length > 1 ? null : `${d}/${done[0]}`, note: done.length > 1 ? String(done.length) : '', bad: false });
    const sub = [...new Set(inside.filter(f => f.includes('/')).map(f => f.split('/')[0]))].sort();
    for (const s of sub) {
      const n = inside.filter(f => f.startsWith(s + '/')).length;
      out.push({ name: s + '/', depth: 2, dir: true, path: null, note: `${n} ${n === 1 ? 'fil' : 'filer'}`, bad: bad.has(`${d}/${s}/`) });
    }
  }
  return out;
}

/** Kort domenenavn til chips og kort: hele navnet når det er kort, ellers første ord, forkortet hvis det er langt */
export function domShort(dom: string) {
  const w = dom.length <= 14 ? dom : dom.split('-')[0];
  return w.length > 12 ? w.slice(0, 9) + '.' : w;
}
