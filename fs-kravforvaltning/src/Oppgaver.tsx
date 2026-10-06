// Oppgaver-modusen: designet «Oppgaver» (runde 2, 2a). Mappe og tavle i samme visning, og valgt oppgave følger med.
import { useMemo, useState } from 'preact/hooks';
import type { Snapshot, Status } from '../shared/model';
import { PHASES, TASK_RULE, type Task } from '../shared/tasks';
import { GITHUB } from './markdown';
import { agentPrompt, currentReview, domShort, gate, kravFor, nextOf, nextPhase, PH_ISSUE, PH_TAG, reviewNote, treeRows } from './oppgaveflyt';
import { StatusIcon } from './Sidebar';
import { AgentButton } from './AgentButton';

export type OView = 'mappe' | 'tavle';
export const taskKey = (t: Task) => `${t.dom}/${t.slug}`;

interface Props {
  tasks: Task[];
  entries: Snapshot;
  view: OView;
  /** Valgt oppgave (`<domene>/<slug>`) */
  sel: string | null;
  /** Sidepanelet i tavla er åpent */
  panel: boolean;
  onSel: (key: string, view: OView, panel: boolean) => void;
  onClosePanel: () => void;
  /** Åpner en kravfil i Krav-modus */
  onOpenKrav: (path: string) => void;
}

const ISSUE_URL = 'https://github.com/sikt-no/fs/issues/';
const fileUrl = (t: Task, f: string) => GITHUB + encodeURI(`${t.dir}/${f}`);
const idLabel = (t: Task) => (t.issue ? '#' + t.issue : '–');
const pct = (n: number, of: number) => (of ? Math.round((100 * n) / of) : 0) + '%';

/** Markør for sjekklister: fylt sirkel = på plass, rute = mangler, strek = ikke aktuelt ennå */
const Mk = ({ k }: { k: 'ok' | 'no' | 'na' }) => <span class={'omk omk--' + k} aria-label={k === 'ok' ? 'på plass' : k === 'no' ? 'mangler' : 'ikke aktuelt'} />;
const Diamond = ({ title }: { title?: string }) => <span class="odia" title={title} />;

/** Faseprikk i sporet: ferdig, nåværende (halvfylt) eller gjenstår */
const phaseState = (i: number, p: number) => (i < p ? 'done' : i === p ? 'cur' : 'todo');

function MiniTrack({ p }: { p: number }) {
  return (
    <span class="omini" aria-label={`fase ${PHASES[p]}`}>
      {PHASES.map((_, i) => (
        <span key={i} class={'omini-' + phaseState(i, p)} />
      ))}
    </span>
  );
}

function AgentBtn({ t }: { t: Task }) {
  return (
    <AgentButton
      prompt={() => agentPrompt(t)}
      copyLabel="Kopier prompt til agent"
      copyTitle="Kopierer en prompt med oppgave, fase og det som mangler"
    />
  );
}

function KravList({ t, entries, onOpenKrav }: { t: Task; entries: Snapshot; onOpenKrav: (p: string) => void }) {
  const k = useMemo(() => kravFor(t, entries), [t, entries]);
  const missing = k.missing.length > 0 && (
    <span class="okrav-miss" title={k.missing.join('\n')}>
      <Diamond />
      {k.missing.length === 1 ? `${k.missing[0]} i spesifikasjonen finnes ikke i krav/ lenger` : `${k.missing.length} filer i spesifikasjonene finnes ikke i krav/ lenger`}
    </span>
  );
  if (!k.items.length)
    return (
      <>
        <span class="omuted">{t.kravLink ? `Ingen .feature-filer under ${t.kravLink}.` : 'Ingen krav koblet til oppgaven ennå.'}</span>
        {missing}
      </>
    );
  return (
    <>
      {k.items.map(i => (
        <a
          key={i.path}
          class="okrav"
          href={'#/' + encodeURI(i.path)}
          title={i.path}
          onClick={e => {
            e.preventDefault();
            onOpenKrav(i.path);
          }}
        >
          <StatusIcon s={i.status} />
          <span class="mono okrav-f">{i.file}</span>
          <span class="mono okrav-s">{i.sub}</span>
        </a>
      ))}
      {k.more > 0 && <span class="omuted mono">+ {k.more} flere under {t.kravLink}</span>}
      {missing}
      <span class="omuted okrav-from">{k.from === 'spec' ? 'Fra spesifikasjonen' : 'Fra «Krav (Gherkin)» i oppgave.md'}</span>
    </>
  );
}

function Avviksliste({ t, big }: { t: Task; big?: boolean }) {
  return (
    <>
      {t.lint.map((l, i) => (
        <div key={i} class="oavrow">
          <Diamond />
          <div class="oavtxt">
            <span class="oavt">{l.title}</span>
            <span class="oavh">{l.hint}</span>
          </div>
          {big && (
            <a class="mono" href={GITHUB + 'tasks/README.md'} target="_blank" rel="noreferrer">
              {TASK_RULE[l.rule]}
            </a>
          )}
        </div>
      ))}
    </>
  );
}

const outcome = (ok: boolean | null) =>
  ok === true ? { t: 'merget', c: 'var(--st-implemented)' } : ok === false ? { t: 'forbedringer', c: 'var(--st-in-progress)' } : { t: 'pågår', c: 'var(--muted)' };

/* ---------- Mappe ---------- */

function Mappe({ tasks, entries, sel, onSel, onOpenKrav }: { tasks: Task[]; entries: Snapshot; sel: Task; onSel: (k: string) => void; onOpenKrav: (p: string) => void }) {
  const t = sel;
  const g = gate(t);
  const doms = [...new Set(tasks.map(x => x.dom))];
  const tag = PH_TAG[t.p];
  const rows = treeRows(t);
  const cell = (ok: boolean, txt: string, na = false) => (
    <span class={'ocell' + (na ? ' na' : ok ? '' : ' no')}>
      <Mk k={na ? 'na' : ok ? 'ok' : 'no'} />
      {na ? '' : ok ? txt : 'mangler'}
    </span>
  );
  return (
    <div class="ogrid">
      <aside class="opanel">
        <div class="opanel-head">
          <span>DOMENER</span>
          <span>fase</span>
        </div>
        <div class="opanel-list">
          {doms.map(dom => {
            const items = tasks.filter(x => x.dom === dom);
            return (
              <div key={dom} class="odom">
                <div class="odom-h">
                  <span class="odom-n" title={dom}>
                    {dom}
                  </span>
                  <span class="mono">{items.length}</span>
                </div>
                {items.map(x => (
                  <div key={x.slug} class={'oitem' + (x === t ? ' sel' : '')} onClick={() => onSel(taskKey(x))}>
                    <MiniTrack p={x.p} />
                    <span class="oitem-t">
                      <span class="oitem-title">{x.title}</span>
                      <span class="oitem-slug mono">{x.slug}</span>
                    </span>
                    <span class="oitem-id mono">
                      {x.lint.length > 0 && <Diamond title="Mappa følger ikke reglene" />}
                      {idLabel(x)}
                    </span>
                  </div>
                ))}
              </div>
            );
          })}
        </div>
        <div class="opanel-legend">
          <div>
            <MiniTrack p={1} />
            ferdig · nåværende · gjenstår
          </div>
          <div class="mono">{PHASES.join(' → ')}</div>
        </div>
      </aside>

      <main class="main" key={taskKey(t)}>
        <div class="odoc">
          <div class="ochips">
            <span class="ochip acc mono">fase: {t.phase ?? 'ukjent'}</span>
            <span class="ochip mono" title="Taggen kravene skal ha i denne fasen">
              <StatusIcon s={tag as Status} lg />
              krav @{tag}
            </span>
            {t.prio && <span class="ochip mono">{t.prio}</span>}
          </div>
          <div class="ohero">
            <span class="ohero-k mono">OPPGAVE {idLabel(t)}</span>
            <h1>{t.title}</h1>
          </div>
          <div class="ometa mono">
            {t.issue ? (
              <a href={ISSUE_URL + t.issue} target="_blank" rel="noreferrer">
                GitHub #{t.issue} ↗
              </a>
            ) : (
              <span>ingen issue</span>
            )}
            <span>eier: {t.owner ?? 'ingen'}</span>
            <span>issue: {PH_ISSUE[t.p]}</span>
            {t.initiativ && <span>initiativ: {t.initiativ.split(' ')[0]}</span>}
            {t.updated && <span>oppdatert {t.updated}</span>}
          </div>

          {t.lint.length > 0 && (
            <div class="oavvik">
              <div class="oavvik-h">
                <span>Mappa følger ikke reglene i tasks/README.md</span>
                <span class="mono">{t.lint.length} feil</span>
              </div>
              <Avviksliste t={t} big />
            </div>
          )}

          <div class="ocard otrack">
            {PHASES.map((n, i) => (
              <div key={n} class={'ophase ' + phaseState(i, t.p)}>
                <div class="ophase-line">
                  <span class="ophase-dot" />
                  {i < 4 && <span class="ophase-bar" />}
                </div>
                <div class="ophase-txt">
                  <span class="ophase-n">{n}</span>
                  <span class="ophase-i">{PH_ISSUE[i]}</span>
                  <span class="mono ophase-tag">@{PH_TAG[i]}</span>
                </div>
              </div>
            ))}
          </div>

          {g.items.length > 0 && (
            <div class="ocard ogate">
              <div class="ogate-h">
                <span class="ot">
                  Før {t.phase ?? PHASES[t.p]} → {nextPhase(t)}
                </span>
                <span class={'mono ' + (g.ok ? 'okc' : 'errc')}>{g.sum}</span>
                <AgentBtn t={t} />
              </div>
              {g.items.map((i, n) => (
                <div key={n} class="ogate-row">
                  <Mk k={i.ok ? 'ok' : 'no'} />
                  <span class={i.ok ? 'dim' : ''}>{i.t}</span>
                  <span class="mono omuted">{i.sub}</span>
                </div>
              ))}
              <div class="onext">
                <span>Neste steg</span>
                <code>{nextOf(t)}</code>
                <span class="omuted">{reviewNote(t)}</span>
              </div>
            </div>
          )}

          {t.lag.length > 0 && (
            <div class="ocard olag">
              <div class="olag-h">
                <span class="ot">Lag</span>
                <span class="mono omuted">&lt;lag&gt;/…-{t.slug}.md</span>
              </div>
              <div class="olag-grid">
                <span class="oth">lag</span>
                <span class="oth">analysis</span>
                <span class="oth">plan</span>
                <span class="oth">utført · planbokser</span>
                <span class="oth">verification</span>
                {t.lag.map(l => (
                  <div key={l.k} class="olag-row">
                    <span class="mono b">{l.k}/</span>
                    {cell(l.analysis, 'analysis')}
                    {cell(!!l.plan, 'plan')}
                    <span class="obox">
                      <span class="obar">
                        <span style={{ width: l.plan ? pct(l.plan[0], l.plan[1]) : '0%', background: l.plan && l.plan[0] === l.plan[1] ? 'var(--st-implemented)' : 'var(--acc)' }} />
                      </span>
                      <span class="mono" title={`${l.completions} task-*-completion.md`}>
                        {l.plan ? `${l.plan[0]}/${l.plan[1]}` : '—'}
                        {l.completions > 0 && ` · ${l.completions} tasks`}
                      </span>
                    </span>
                    {t.p < 3 ? cell(false, '', true) : cell(l.verification, 'verification')}
                  </div>
                ))}
              </div>
            </div>
          )}

          <div class="otwo">
            <div class="ocard olist">
              <span class="ot">Krav</span>
              <KravList t={t} entries={entries} onOpenKrav={onOpenKrav} />
            </div>
            <div class="ocard olist">
              <div class="olist-h">
                <span class="ot">Reviews</span>
                <span class="mono omuted">reviews/</span>
              </div>
              {t.reviews.map(r => {
                const o = outcome(r.ok);
                return (
                  <div key={r.file} class="orev">
                    <a class="mono" href={fileUrl(t, r.file)} target="_blank" rel="noreferrer">
                      {r.file.slice(8)}
                    </a>
                    <span style={{ color: o.c }}>{o.t}</span>
                    <span class="omuted">{r.who ?? 'ukjent reviewer'}</span>
                  </div>
                );
              })}
              {!t.reviews.length && <span class="omuted">Ingen reviews ennå.</span>}
            </div>
          </div>

          <div class="olog">
            <div class="olist-h">
              <span class="ot">Statuslogg</span>
              <span class="mono omuted">oppgave.md · append-only</span>
            </div>
            <div class="olog-box mono">
              {t.log.map((e, i) => (
                <div key={i} class="olog-row">
                  <span class="omuted">{e.d}</span>
                  <span>{e.t}</span>
                  <span class="omuted">{e.who}</span>
                </div>
              ))}
              {!t.log.length && <div class="olog-row omuted">Ingen statuslogg i oppgave.md.</div>}
            </div>
          </div>
        </div>
      </main>

      <aside class="otree">
        <div class="opanel-head">MAPPE</div>
        <div class="otree-list">
          {rows.map((f, i) => {
            const cls = 'otf' + (f.dir ? ' dir' : '') + (f.bad ? ' bad' : '');
            const inner = (
              <>
                <span class="chev">{f.dir && !f.note ? '▾' : ''}</span>
                {f.bad && <Diamond />}
                <span class="otf-n">{f.name}</span>
                {f.note && <span class="otf-note">{f.note}</span>}
              </>
            );
            const style = { paddingLeft: 8 + f.depth * 14 + 'px' };
            return f.path ? (
              <a key={i} class={cls} style={style} href={fileUrl(t, f.path)} target="_blank" rel="noreferrer" title="Åpne på GitHub">
                {inner}
              </a>
            ) : (
              <div key={i} class={cls} style={style}>
                {inner}
              </div>
            );
          })}
        </div>
        <div class="otree-foot">
          Filene BAT globber (<span class="mono">spec-</span>, <span class="mono">analysis-</span>, <span class="mono">plan-</span>,{' '}
          <span class="mono">verification-</span>) avgjør hvilke steg som vises som ferdige.
        </div>
      </aside>
    </div>
  );
}

/* ---------- Tavle ---------- */

function Tavle({ tasks, entries, sel, onSel, onClose, onOpenMappe, onOpenKrav }: {
  tasks: Task[];
  entries: Snapshot;
  sel: Task | null;
  onSel: (k: string) => void;
  onClose: () => void;
  onOpenMappe: (k: string) => void;
  onOpenKrav: (p: string) => void;
}) {
  const [dom, setDom] = useState<string | null>(null);
  const doms = [...new Set(tasks.map(t => t.dom))];
  const shown = tasks.filter(t => !dom || t.dom === dom);
  const chip = (label: string, n: number, on: boolean, fn: () => void, full?: string) => (
    <button key={label} class={'ofchip' + (on ? ' on' : '')} onClick={fn} title={full ?? label}>
      {label}
      <span class="mono">{n}</span>
    </button>
  );
  const d = sel;
  const g = d ? gate(d) : null;
  return (
    <div class={'oboard-wrap' + (d ? ' open' : '')}>
      <div class="oboard-main">
        <div class="oboard-head">
          <h1>Oppgaver</h1>
          <div class="ofchips">
            {chip('Alle', tasks.length, !dom, () => setDom(null))}
            {doms.map(x => chip(domShort(x), tasks.filter(t => t.dom === x).length, dom === x, () => setDom(dom === x ? null : x), x))}
          </div>
        </div>
        <div class="oboard">
          {PHASES.map((name, i) => {
            const cards = shown.filter(t => t.p === i);
            return (
              <div key={name} class="ocol">
                <div class="ocol-h">
                  <div class="ocol-t">
                    <StatusIcon s={PH_TAG[i] as Status} />
                    <span>{name}</span>
                    <span class="mono omuted">{cards.length}</span>
                  </div>
                  <span class="ocol-i">{PH_ISSUE[i]}</span>
                </div>
                <div class="ocol-cards">
                  {cards.map(t => {
                    const tg = gate(t);
                    const cur = currentReview(t);
                    const isSel = d === t;
                    const showLag = t.lag.length > 0 && i > 0 && i < 4;
                    const ok = i === 4 || tg.ok;
                    return (
                      <div key={taskKey(t)} class={'ocardk' + (isSel ? ' sel' : '')} onClick={() => (isSel ? onClose() : onSel(taskKey(t)))}>
                        <div class="ocardk-top mono">
                          <span>{idLabel(t)}</span>
                          <span class="ocardk-dom">{domShort(t.dom)}</span>
                          {t.lint.length > 0 && <Diamond title="Regelbrudd i mappa" />}
                        </div>
                        <span class="ocardk-title">{t.title}</span>
                        {showLag && (
                          <div class="ocardk-lag">
                            {t.lag.map(l => {
                              const w = i === 3 ? (l.verification ? '100%' : '0%') : l.plan ? pct(l.plan[0], l.plan[1]) : '0%';
                              const full = i === 3 ? l.verification : !!l.plan && l.plan[0] === l.plan[1];
                              return (
                                <div key={l.k} class="ocardk-lrow mono">
                                  <span>{l.k}</span>
                                  <span class="obar">
                                    <span style={{ width: w, background: full ? 'var(--st-implemented)' : 'var(--acc)' }} />
                                  </span>
                                  <span class="omuted">{i === 3 ? (l.verification ? 'ver' : '—') : l.plan ? `${l.plan[0]}/${l.plan[1]}` : '—'}</span>
                                </div>
                              );
                            })}
                          </div>
                        )}
                        <div class="ocardk-gate">
                          <Mk k={ok ? 'ok' : 'no'} />
                          <span class={ok ? 'dim' : ''}>
                            {i === 4 ? 'arkivert' : tg.ok ? `klar for ${nextPhase(t)}` : cur?.ok === false ? `${tg.miss} mangler` : `${tg.miss} mangler til ${nextPhase(t)}`}
                          </span>
                          {cur?.ok === false && <span class="orevtag mono">forbedringer</span>}
                        </div>
                      </div>
                    );
                  })}
                  {!cards.length && <span class="oempty">Ingen oppgaver</span>}
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {d && g && (
        <aside class="oside">
          <div class="oside-top mono">
            {d.issue ? (
              <a href={ISSUE_URL + d.issue} target="_blank" rel="noreferrer">
                #{d.issue} ↗
              </a>
            ) : (
              <span>ingen issue</span>
            )}
            <span class="oside-dom">{d.dom}</span>
            <button class="smallbtn" onClick={onClose}>
              Lukk ×
            </button>
          </div>
          <div class="oside-title">
            <h2>{d.title}</h2>
            <span class="mono omuted">
              {d.slug}/ · eier {d.owner ?? 'ingen'}
            </span>
          </div>
          <div class="oside-track">
            {PHASES.map((n, i) => (
              <div key={n} class={phaseState(i, d.p)}>
                <span />
                <span>{n}</span>
              </div>
            ))}
          </div>
          {d.lint.length > 0 && (
            <div class="oavvik small">
              <Avviksliste t={d} />
            </div>
          )}
          {d.p < 4 && (
            <div class="oside-sec">
              <div class="oside-h">
                <span class="ot">Til {nextPhase(d)}</span>
                <span class={'mono ' + (g.ok ? 'okc' : 'errc')}>{g.sum}</span>
              </div>
              <div class="oside-gate">
                {g.items.map((i, n) => (
                  <div key={n} class="ogate-row small">
                    <Mk k={i.ok ? 'ok' : 'no'} />
                    <span class="oside-gt">
                      <span class={i.ok ? 'dim' : ''}>{i.t}</span>
                      {i.sub && <span class="mono omuted">{i.sub}</span>}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          )}
          <div class="oside-next">
            <span class="omuted">Neste steg</span>
            <code>{nextOf(d)}</code>
            <span>{reviewNote(d)}</span>
            <AgentBtn t={d} />
          </div>
          <div class="oside-sec">
            <span class="ot">Reviewere</span>
            {d.reviews.map(r => {
              const o = outcome(r.ok);
              return (
                <div key={r.file} class="oside-rev">
                  <span class="mono omuted">r{String(r.n).padStart(2, '0')}</span>
                  <span>{r.who ?? 'ukjent'}</span>
                  <span style={{ color: o.c }}>{o.t}</span>
                </div>
              );
            })}
            {!d.reviews.length && <span class="omuted">Ingen reviews ennå.</span>}
          </div>
          <div class="oside-sec">
            <span class="ot">Krav</span>
            <KravList t={d} entries={entries} onOpenKrav={onOpenKrav} />
          </div>
          <button class="olinkbtn" onClick={() => onOpenMappe(taskKey(d))}>
            Åpne oppgavemappa →
          </button>
        </aside>
      )}
    </div>
  );
}

export function Oppgaver({ tasks, entries, view, sel, panel, onSel, onClosePanel, onOpenKrav }: Props) {
  if (!tasks.length)
    return (
      <div class="empty">
        <div class="mono" style={{ color: 'var(--ink)' }}>tasks/</div>
        <div>Ingen oppgaver ennå. Opprett en med skillen fs-oppgave.</div>
      </div>
    );
  const found = tasks.find(t => taskKey(t) === sel) ?? null;
  if (view === 'mappe') {
    const t = found ?? tasks.find(x => x.p < 4) ?? tasks[0];
    return <Mappe tasks={tasks} entries={entries} sel={t} onSel={k => onSel(k, 'mappe', false)} onOpenKrav={onOpenKrav} />;
  }
  return (
    <Tavle
      tasks={tasks}
      entries={entries}
      sel={panel ? found : null}
      onSel={k => onSel(k, 'tavle', true)}
      onClose={onClosePanel}
      onOpenMappe={k => onSel(k, 'mappe', false)}
      onOpenKrav={onOpenKrav}
    />
  );
}
