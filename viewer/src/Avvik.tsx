// Avviksdashbordet: Avvik-modusen fra designet «Gherkin Viewer v2».
import type { JSX } from 'preact';
import { useEffect, useMemo, useRef, useState } from 'preact/hooks';
import { STATUS_LABEL, type Snapshot } from '../shared/model';
import { RULE, type Severity } from '../shared/rules';
import { agentPrompt, dirStat, files, health, NO_FILTER, tree, type Filter, type Node, type PrioKey, type StatusKey } from './health';
import { StatusIcon } from './Sidebar';

interface Props {
  entries: Snapshot;
  filter: Filter;
  onFilter: (f: Filter) => void;
  /** Åpner fila i Krav-modus, eventuelt på en linje */
  onOpen: (path: string, line?: number) => void;
  /** Åpner krav/README.md på overskriften */
  onReadRule: (section: string) => void;
}

const PR_COLOR: Record<PrioKey, string> = {
  must: 'var(--acc)',
  should: 'color-mix(in oklch, var(--acc) 60%, var(--surface))',
  could: 'color-mix(in oklch, var(--acc) 35%, var(--surface))',
  wont: 'color-mix(in oklch, var(--acc) 18%, var(--surface))',
  none: 'var(--line2)',
};
const stLabel = (s: StatusKey) => (s === 'none' ? 'ingen status' : s);
const time = (ms: number) => new Date(ms).toTimeString().slice(0, 8);
const pct = (n: number, of: number) => (of ? (n / of) * 100 : 0) + '%';

/** Rute for alvorlighetsgrad: fylt for feil, kontur for advarsel */
export const SevMark = ({ sev, z = 8 }: { sev: Severity; z?: number }) => (
  <span class={'sev sev--' + sev} style={{ width: z + 'px', height: z + 'px' }} aria-label={sev === 'error' ? 'feil' : 'advarsel'} />
);

export function Avvik({ entries, filter: flt, onFilter, onOpen, onReadRule }: Props) {
  const all = useMemo(() => files(entries), [entries]);
  const root = useMemo(() => tree(all), [all]);
  const h = useMemo(() => health(all, root, flt), [all, root, flt]);
  const [open, setOpen] = useState<Record<string, boolean>>({});
  const [more, setMore] = useState(false);
  const [dashManual, setDashManual] = useState<boolean | null>(null);
  const [copied, setCopied] = useState(false);
  const timer = useRef<ReturnType<typeof setTimeout>>();
  useEffect(() => () => clearTimeout(timer.current), []);

  const set = (patch: Partial<Filter>) => {
    setMore(false);
    if ('rule' in patch || 'file' in patch) setDashManual(null);
    onFilter({ ...flt, ...patch });
  };
  const tog = <K extends 'rule' | 'status' | 'prio'>(k: K, v: Filter[K]) => () => set({ [k]: flt[k] === v ? null : v } as Partial<Filter>);
  const goDir = (segs: string[], extra?: Partial<Filter>) => {
    set({ path: segs.length ? segs : null, file: null, ...extra });
    setOpen(o => ({ ...o, ...Object.fromEntries(segs.map((_, i) => [segs.slice(0, i + 1).join('/'), true])) }));
  };

  const k = h.kpi;
  const savedAt = Math.max(0, ...Object.values(entries).map(e => e.savedAt));
  const nBadAll = all.filter(f => f.lints.length).length;
  const maxRule = Math.max(1, ...h.ruleCounts.map(r => r.n));
  const dashOpen = dashManual ?? !(flt.rule || flt.file);
  const R = flt.rule ? RULE[flt.rule] : null;
  const F = flt.file && !flt.rule ? all.find(f => f.path === flt.file) : null;

  const copy = () => {
    const text = agentPrompt(h, flt);
    const done = () => {
      setCopied(true);
      clearTimeout(timer.current);
      timer.current = setTimeout(() => setCopied(false), 1800);
    };
    const fallback = () => {
      const t = document.createElement('textarea');
      t.value = text;
      t.style.position = 'fixed';
      t.style.opacity = '0';
      document.body.appendChild(t);
      t.select();
      try {
        document.execCommand('copy');
      } catch {
        /* utilgjengelig utklippstavle */
      }
      t.remove();
      done();
    };
    try {
      navigator.clipboard.writeText(text).then(done, fallback);
    } catch {
      fallback();
    }
  };
  const agentBtn = (
    <button class={'agentbtn' + (copied ? ' on' : '')} onClick={copy} title="Kopierer en prompt med filer, linjer og regel som kan limes inn til en kodeagent">
      <span class="agentmark" />
      {copied ? 'Kopiert' : 'Kopier agent-prompt'}
    </button>
  );

  // Venstrepanelet: mapper med avvik / filer
  const selKey = flt.file ? null : (flt.path ?? []).join('/');
  const dirRows: JSX.Element[] = [];
  const dirRow = (n: Node, depth: number, label?: string) => {
    const s = dirStat(n, flt);
    const isOpen = label ? true : !!open[n.key];
    dirRows.push(
      <div key={'d:' + n.key} class={'adir' + (selKey === n.key ? ' sel' : '')} style={{ paddingLeft: 8 + depth * 14 + 'px' }} onClick={() => goDir(n.segs)}>
        <div class="adir-top">
          <span
            class="chev"
            onClick={e => {
              if (label) return;
              e.stopPropagation();
              setOpen(o => ({ ...o, [n.key]: !isOpen }));
            }}
          >
            {label ? '' : isOpen ? '▼' : '▶'}
          </span>
          <span class={'name' + (label || selKey === n.key ? ' b' : '')}>{label ?? n.name}</span>
          <span class="ratio">
            {s.bad} / {s.total}
          </span>
        </div>
        <div class="abar">
          <span style={{ width: pct(s.bad, s.total), background: 'var(--err)' }} />
          <span style={{ width: pct(s.total - s.bad, s.total), background: 'var(--st-implemented)' }} />
        </div>
      </div>,
    );
    if (label) return n.kids.forEach(c => dirRow(c, 0));
    if (!isOpen) return;
    n.kids.forEach(c => dirRow(c, depth + 1));
    n.files
      .filter(f => (!flt.status || f.st === flt.status) && (!flt.prio || f.prio === flt.prio) && f.lints.length)
      .forEach(f =>
        dirRows.push(
          <div key={'f:' + f.path} class={'afile' + (flt.file === f.path ? ' sel' : '')} style={{ paddingLeft: 8 + (depth + 1) * 14 + 'px' }} onClick={() => set({ path: n.segs, file: f.path })}>
            <span class="chev" />
            <StatusIcon s={f.icon} />
            <span class="name">{f.name}</span>
            <span class="n">{f.lints.length}</span>
          </div>,
        ),
      );
  };
  dirRow(root, 0, 'Alle mapper');

  const pills: { k: string; v: string; clear: () => void }[] = [];
  if (flt.path) pills.push({ k: 'Mappe', v: flt.path.join(' / '), clear: () => set({ path: null, file: null }) });
  if (flt.file) pills.push({ k: 'Fil', v: flt.file.slice(flt.file.lastIndexOf('/') + 1), clear: () => set({ file: null }) });
  if (flt.rule) pills.push({ k: 'Regel', v: RULE[flt.rule].label, clear: () => set({ rule: null }) });
  if (flt.status) pills.push({ k: 'Status', v: stLabel(flt.status), clear: () => set({ status: null }) });
  if (flt.prio) pills.push({ k: 'Prioritet', v: flt.prio, clear: () => set({ prio: null }) });

  const node = h.heat;
  const crumbs = [[], ...(flt.path ?? []).map((_, i) => flt.path!.slice(0, i + 1))];
  const shown = more ? h.bad : h.bad.slice(0, 8);
  const stTot = Math.max(1, h.stDist.reduce((a, s) => a + s.n, 0));
  const prTot = Math.max(1, h.prDist.reduce((a, s) => a + s.n, 0));

  return (
    <div class="agrid">
      <aside class="apanel">
        <div class="apanel-head">
          <span>MAPPER</span>
          <span>med avvik / filer</span>
        </div>
        <div class="apanel-tree">{dirRows}</div>
        <div class="apanel-legend">
          <div>
            <span style={{ background: 'var(--err)' }} />
            filer med avvik
          </div>
          <div>
            <span style={{ background: 'var(--st-implemented)' }} />
            filer uten avvik
          </div>
        </div>
      </aside>

      <main class="main">
        <div class="avvik">
          <div class="ahead">
            <div>
              <h1>Avvik</h1>
              <div class="mono ameta">
                {k.nF} feature-filer · {k.nScen} scenarioer{savedAt ? ` · parset ${time(savedAt)}` : ''}
              </div>
            </div>
            <div class="seg" role="group" aria-label="Alvorlighetsgrad">
              {(['all', 'error', 'warning'] as const).map(s => (
                <button key={s} aria-pressed={flt.sev === s} onClick={() => set({ sev: s })}>
                  {s !== 'all' && <SevMark sev={s} z={7} />}
                  {s === 'all' ? 'Alle' : s === 'error' ? 'Feil' : 'Advarsler'}
                </button>
              ))}
            </div>
          </div>

          {pills.length > 0 && (
            <div class="pills">
              {pills.map(p => (
                <button key={p.k} class="pill" onClick={p.clear}>
                  <span class="k">{p.k}</span>
                  <span class="v">{p.v}</span>
                  <span class="x">×</span>
                </button>
              ))}
              <button class="linkbtn" onClick={() => onFilter(NO_FILTER)}>
                Nullstill
              </button>
            </div>
          )}

          <button class="acard dashtoggle" onClick={() => setDashManual(!dashOpen)} aria-expanded={dashOpen}>
            <span class="chev">{dashOpen ? '▼' : '▶'}</span>
            <span class="t">Oversikt</span>
            {!dashOpen && (
              <span class="mono sum">
                <span>
                  {k.clean} av {k.nF} uten avvik
                </span>
                <span class="sep">·</span>
                <span>{k.nL} avvik</span>
                <span class="sep">·</span>
                <span>{k.nBad} filer med avvik</span>
              </span>
            )}
            <span class="lbl">{dashOpen ? 'Skjul' : 'Vis'}</span>
          </button>

          {dashOpen && (
            <div class="dash">
              <div class="acard kpis">
                <div class="kpi">
                  <span class="kl">Filer uten avvik</span>
                  <div class="kv">
                    <span class="big">{k.clean}</span>
                    <span class="mono of">av {k.nF}</span>
                  </div>
                  <div class="kbar">
                    <span style={{ width: pct(k.clean, k.nF) }} />
                  </div>
                </div>
                <div class="kpi">
                  <span class="kl">Avvik</span>
                  <span class="big">{k.nL}</span>
                  <div class="ksub">
                    <span>
                      <SevMark sev="error" z={7} />
                      {k.nErr} feil
                    </span>
                    <span>
                      <SevMark sev="warning" z={7} />
                      {k.nWarn} advarsler
                    </span>
                  </div>
                </div>
                <div class="kpi">
                  <span class="kl">Filer med avvik</span>
                  <span class="big">{k.nBad}</span>
                  <span class="kmut">{k.nF ? Math.round((k.nBad / k.nF) * 100) + ' % av filene' : ''}</span>
                </div>
                <div class="kpi">
                  <span class="kl">Åpne spørsmål</span>
                  <span class="big">{k.nQ}</span>
                  <span class="kmut">i {k.nQFiles} filer</span>
                </div>
                <div class="kpi">
                  <span class="kl">Parse-feil</span>
                  <span class={'big' + (k.nErrors ? ' errc' : '')}>{k.nErrors}</span>
                  <span class="kmut">{k.nPartial} delvis utkast</span>
                </div>
              </div>

              <div class="dash2">
                <div class="acard pad">
                  <div class="ctitle">
                    <span class="t">Avvik per regel</span>
                    <span class="mono hint">klikk for å filtrere</span>
                  </div>
                  <div class="rulebars">
                    {h.ruleCounts
                      .filter(r => r.n || flt.rule === r.rule.id)
                      .sort((a, b) => b.n - a.n)
                      .map(({ rule, n }) => (
                        <button
                          key={rule.id}
                          class={'rulebar' + (flt.rule === rule.id ? ' sel' : '')}
                          title={rule.id}
                          style={{ opacity: (flt.sev !== 'all' && rule.sev !== flt.sev) || (flt.rule && flt.rule !== rule.id) ? 0.4 : 1 }}
                          onClick={tog('rule', rule.id)}
                        >
                          <SevMark sev={rule.sev} />
                          <span class="lbl">{rule.label}</span>
                          <span class="track">
                            <span style={{ width: pct(n, maxRule), background: rule.sev === 'error' ? 'var(--err)' : 'var(--warn)' }} />
                          </span>
                          <span class="mono n">{n}</span>
                        </button>
                      ))}
                    {h.ruleCounts.every(r => !r.n) && <div class="none">Ingen avvik med dette filteret.</div>}
                  </div>
                </div>

                <div class="dashcol">
                  <div class="acard pad">
                    <div class="ctitle">
                      <span class="t">Status</span>
                      <span class="mono hint">per fil</span>
                    </div>
                    <div class="stack">
                      {h.stDist.map(s => (
                        <span key={s.key} style={{ width: pct(s.n, stTot), background: `var(--st-${s.key})`, opacity: flt.status && flt.status !== s.key ? 0.3 : 1 }} />
                      ))}
                    </div>
                    <div class="distrows">
                      {h.stDist.map(s => (
                        <button key={s.key} class={'distrow' + (flt.status === s.key ? ' sel' : '')} onClick={tog('status', s.key)}>
                          <StatusIcon s={s.key} />
                          <span class="mono">{s.key === 'none' ? STATUS_LABEL.none : s.key}</span>
                          <span class="mono n">{s.n}</span>
                        </button>
                      ))}
                    </div>
                  </div>
                  <div class="acard pad">
                    <div class="ctitle">
                      <span class="t">Prioritet</span>
                      <span class="mono hint">per fil</span>
                    </div>
                    <div class="stack">
                      {h.prDist.map(s => (
                        <span key={s.key} style={{ width: pct(s.n, prTot), background: PR_COLOR[s.key], opacity: flt.prio && flt.prio !== s.key ? 0.3 : 1 }} />
                      ))}
                    </div>
                    <div class="distrows">
                      {h.prDist.map(s => (
                        <button key={s.key} class={'distrow' + (flt.prio === s.key ? ' sel' : '')} onClick={tog('prio', s.key)}>
                          <span class="sw" style={{ background: PR_COLOR[s.key] }} />
                          <span class="mono up">{s.key === 'none' ? 'INGEN' : s.key.toUpperCase()}</span>
                          <span class="mono n">{s.n}</span>
                        </button>
                      ))}
                    </div>
                  </div>
                </div>
              </div>

              <div class="acard pad">
                <div class="ctitle wrap">
                  <span class="t">Regel × mappe</span>
                  <span class="mono hmcrumbs">
                    {crumbs.map((segs, i) => (
                      <span key={i}>
                        {i > 0 && <span class="sep">/</span>}
                        <button class={i === crumbs.length - 1 ? 'cur' : ''} onClick={() => goDir(segs)}>
                          {i ? segs[segs.length - 1] : 'krav'}
                        </button>
                      </span>
                    ))}
                  </span>
                  <span class="mono hint">klikk en mappe for å gå ned, en celle for å filtrere</span>
                </div>
                <div class="hmwrap">
                  <div class="hm" style={{ gridTemplateColumns: `minmax(160px, 1fr) repeat(${node.cols.length}, minmax(46px, 70px)) 44px` }}>
                    <span class="hmcorner">{node.rows.some(r => r.dir) ? 'Mappe' : 'Fil'}</span>
                    {node.cols.map(r => (
                      <button key={r.id} class={'hmhead' + (flt.rule === r.id ? ' sel' : '')} title={r.label} onClick={tog('rule', r.id)}>
                        {r.short}
                      </button>
                    ))}
                    <span class="hmsumh">sum</span>
                    {node.rows.map(row => {
                      const selRow = !!row.file && flt.file === row.file.path;
                      const go = (extra?: Partial<Filter>) =>
                        row.dir ? goDir(row.dir.segs, extra) : set({ file: selRow && !extra ? null : row.file!.path, ...extra });
                      return (
                        <div key={row.label} style={{ display: 'contents' }}>
                          <button class={'hmrow' + (selRow ? ' sel' : '')} onClick={() => go()}>
                            {row.dir ? <span class="tri">▶</span> : <StatusIcon s={row.file!.icon} />}
                            <span class="name">{row.label}</span>
                          </button>
                          {row.cells.map((n, ci) => {
                            const r = node.cols[ci];
                            const p = n ? Math.round(14 + (78 * n) / node.max) : 0;
                            const on = (!flt.rule || flt.rule === r.id) && (!flt.file || selRow);
                            return (
                              <button
                                key={r.id}
                                class="hmcell"
                                title={`${r.label} · ${row.label}: ${n}`}
                                style={{
                                  background: n ? `color-mix(in oklch, var(--acc) ${p}%, var(--surface))` : 'var(--sunken)',
                                  color: p > 50 ? '#fff' : n ? 'var(--ink)' : 'var(--line2)',
                                  opacity: (flt.rule || flt.file) && !on ? 0.3 : 1,
                                  boxShadow: flt.rule === r.id && selRow ? '0 0 0 2px var(--ink)' : 'none',
                                }}
                                onClick={() => go({ rule: r.id })}
                              >
                                {n || '·'}
                              </button>
                            );
                          })}
                          <span class="hmsum">{row.sum}</span>
                        </div>
                      );
                    })}
                    <span class="hmfoot l">sum</span>
                    {node.foot.map((n, i) => (
                      <span key={i} class="hmfoot">
                        {n}
                      </span>
                    ))}
                    <span class="hmfoot r">{node.total}</span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {F && (
            <div class="acard detail">
              <div class="dhead">
                <StatusIcon s={F.icon} lg />
                <span class="mono dst">{F.icon === 'partial' ? `${F.st} · delvis utkast` : stLabel(F.st)}</span>
                {agentBtn}
                <button class="smallbtn" onClick={() => set({ file: null })}>
                  Fjern filter ×
                </button>
              </div>
              <h2 class="mono">{F.name}</h2>
              <div class="mono dpath">{F.path.slice(0, F.path.lastIndexOf('/'))}</div>
              <div class="dfoot">
                <span class="mono">{h.kpi.nL} avvik</span>
                <a
                  href={'#/' + encodeURI(F.path)}
                  onClick={e => {
                    e.preventDefault();
                    onOpen(F.path);
                  }}
                >
                  Åpne fila →
                </a>
              </div>
            </div>
          )}
          {R && (
            <div class="acard detail">
              <div class="dhead">
                <SevMark sev={R.sev} z={10} />
                <span class={'dsev ' + R.sev}>{R.sev === 'error' ? 'Feil' : 'Advarsel'}</span>
                <span class="mono rid">{R.id}</span>
                {agentBtn}
                <button class="smallbtn" onClick={() => set({ rule: null })}>
                  Fjern filter ×
                </button>
              </div>
              <h2 class="rtitle">{R.label}</h2>
              <p class="rdesc">{R.desc}</p>
              <div class="dfoot">
                <span class="mono">
                  {h.kpi.nL} avvik i {h.bad.length} filer
                </span>
                <a
                  href="#/krav/README.md"
                  onClick={e => {
                    e.preventDefault();
                    onReadRule(R.section);
                  }}
                >
                  Les regelen i krav/README.md: {R.section} →
                </a>
              </div>
            </div>
          )}

          <div class="acard filelist">
            <div class="ctitle">
              <span class="t">Filer med avvik</span>
              <span class="mono hint">{h.bad.length} filer · sortert etter antall avvik</span>
            </div>
            {shown.map(({ f, lints }) => (
              <div key={f.path} class="afl">
                <div class="aflhead">
                  <StatusIcon s={f.icon} />
                  <span class="mono fn">{f.name}</span>
                  <span class="fp">{f.segs.join(' / ')}</span>
                  <span class="mono cnt">{lints.length} avvik</span>
                </div>
                {lints.map((l, i) => (
                  <div key={i} class="lintline" onClick={() => onOpen(f.path, l.ln)} title="Åpne fila på linja">
                    <SevMark sev={l.sev} z={7} />
                    <span class="mono ln">L{l.ln}</span>
                    <span class="msg">{l.msg}</span>
                    <a
                      href="#/krav/README.md"
                      onClick={e => {
                        e.preventDefault();
                        e.stopPropagation();
                        onReadRule(RULE[l.rule].section);
                      }}
                    >
                      Les regelen
                    </a>
                  </div>
                ))}
              </div>
            ))}
            {h.bad.length > 8 && (
              <button class="smallbtn morebtn" onClick={() => setMore(m => !m)}>
                {more ? 'Vis færre' : `Vis alle ${h.bad.length} filer`}
              </button>
            )}
            {h.bad.length === 0 && <div class="none">Ingen avvik med dette filteret.</div>}
          </div>
          {nBadAll === 0 && <div class="none">Ingen avvik i krav/. Alle filene følger konvensjonene.</div>}
        </div>
      </main>
    </div>
  );
}
