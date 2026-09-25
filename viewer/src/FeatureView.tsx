import { useEffect, useRef, useState } from 'preact/hooks';
import { Fragment, type RefObject } from 'preact';
import { STATUSES, type Entry, type Lint, type Status, type Note, type Step } from '../shared/model';
import { RULE } from '../shared/rules';
import { StatusIcon, statusColor } from './Sidebar';

export const scenKey = (ri: number, si: number) => `${ri}-${si}`;
export const stepKey = (ri: number, si: number, ti: number) => `${ri}-${si}-${ti}`;

const GITHUB = 'https://github.com/sikt-no/fs/issues/';
const isStatus = (t: string) => (STATUSES as readonly string[]).includes(t.slice(1));
const MOSCOW = ['@must', '@should', '@could', '@wont'];
/** Scrollgrensene for når egenskapshodet slås sammen og foldes ut igjen (hysterese) */
const COMPACT_AT = 60;
const EXPAND_AT = 12;

/** Deler tekst i vanlige biter og treff på `re` (må ha én fangegruppe). */
const split = (text: string, re: RegExp) =>
  text.split(re).filter(Boolean).map((t, i) => ({ t, hit: re.test(t), i }));
const PARAM = /(<[^>]+>)/;
const REF = /([A-ZÆØÅ]{2,4}(?:-[A-ZÆØÅ]{2,4}){2}-\d{3}|#\d+|"[^"]+\.feature")/;

const Params = ({ text }: { text: string }) => (
  <>{split(text, PARAM).map(g => (g.hit ? <span key={g.i} class="param">{g.t}</span> : <span key={g.i}>{g.t}</span>))}</>
);
const Refs = ({ text }: { text: string }) => (
  <>{split(text, REF).map(g => (g.hit ? <span key={g.i} class="ref">{g.t}</span> : <span key={g.i}>{g.t}</span>))}</>
);

const tagColor = (t: string) =>
  isStatus(t) ? statusColor(t.slice(1)) : t === '@openquestion' ? 'var(--st-in-progress)' : undefined;

function Tags({ tags }: { tags: string[] }) {
  return (
    <>
      {tags.map(t => {
        const c = tagColor(t);
        return <span key={t} class="minitag" style={c ? { borderColor: c, color: c } : undefined}>{t}</span>;
      })}
    </>
  );
}

/** Åpne spørsmål og vanlige kommentarer, vist rett under elementet de hører til. */
function NoteBlock({ note, hit, lineNumbers }: { note: Note; hit: (from: number, to?: number) => string; lineNumbers: boolean }) {
  const last = note.items[note.items.length - 1]?.ln ?? note.ln;
  if (note.kind === 'question') {
    return (
      <div class={'qblock' + hit(note.ln, last)} data-q>
        <div class="qhead">
          <span class="diamond" style={{ background: 'var(--st-in-progress)' }} />
          Åpne spørsmål <span class="mono">{note.items.length}</span>
        </div>
        <ol>
          {note.items.map((q, i) => (
            <li key={i} class={hit(q.ln) || undefined}>
              <Refs text={q.text} />
              {lineNumbers && <span class="qln">L{q.ln}</span>}
            </li>
          ))}
        </ol>
      </div>
    );
  }
  return (
    <div class={'note' + hit(note.ln, last)}>
      {note.head && <span class="nhead">{note.head}</span>}
      {note.items.length > 0 && <div class="ntext"><Refs text={note.items.map(i => i.text).join('\n')} /></div>}
      {lineNumbers && <span class="qln">L{note.ln}</span>}
    </div>
  );
}

function Table({ rows, ex, params }: { rows: string[][]; ex?: boolean; params?: boolean }) {
  return (
    <div>
      <div class={'table' + (ex ? ' ex' : '')} style={{ gridTemplateColumns: `repeat(${rows[0]?.length ?? 1}, auto)` }}>
        {rows.flatMap((r, ri) => r.map((c, ci) => <span key={`${ri}-${ci}`} class={ri === 0 ? 'th' : ''}>{params ? <Params text={c} /> : c}</span>))}
      </div>
    </div>
  );
}

/** Siste linje steget dekker i filen, inkludert tabell eller docstring. */
const stepEnd = (st: Step) => st.ln + (st.table?.length ?? 0) + (st.doc !== undefined ? st.doc.split('\n').length + 1 : 0);

function StepNotes({ step, hit, lineNumbers }: { step: Step; hit: (from: number, to?: number) => string; lineNumbers: boolean }) {
  return (
    <>
      {step.notes?.map((n, i) => (
        <div key={i} class="step stepnote">
          <span class="ln">{lineNumbers ? n.ln : ''}</span>
          <NoteBlock note={n} hit={hit} lineNumbers={false} />
        </div>
      ))}
    </>
  );
}

const isAnd = (kw: string) => kw === 'Og' || kw === 'Men' || kw === '*';
const KW_COLOR: Record<string, string> = { Gitt: 'var(--k-gitt)', 'Når': 'var(--k-naar)', 'Så': 'var(--k-saa)' };
const KIND_CLASS: Record<string, string> = { Bakgrunn: ' k-bg', Scenario: '' };

/** Fargen til hvert nøkkelord; Og/Men/* arver fargen fra steget før. */
function kwColors(steps: Step[]) {
  let last = KW_COLOR.Gitt;
  return steps.map(st => (last = KW_COLOR[st.kw] ?? last));
}

function StepRow({ step, color, flash, marked, lineNumbers }: { step: Step; color: string; flash: boolean; marked: boolean; lineNumbers: boolean }) {
  return (
    <div class={'step' + (flash ? ' flash' : '') + (marked ? ' cursor' : '')}>
      <span class="ln">{lineNumbers ? step.ln : ''}</span>
      <span class={'kw' + (isAnd(step.kw) ? ' and' : '')} style={{ color }}>{step.kw}</span>
      <div class="steptext">
        <Params text={step.text} />
        {step.table && <Table rows={step.table} params />}
        {step.doc !== undefined && <pre class="docstring">{step.doc}</pre>}
      </div>
    </div>
  );
}

/** Statusbånd over avvik fra konvensjonene: feil før advarsler, deretter etter linje. */
function LintBand({ lint, hit, onLine }: { lint: Lint[]; hit: (from: number) => string; onLine: (ln: number) => void }) {
  if (!lint.length) return null;
  const sorted = [...lint].sort((a, b) => (a.sev === b.sev ? a.ln - b.ln : a.sev === 'error' ? -1 : 1));
  const ne = lint.filter(l => l.sev === 'error').length;
  const nw = lint.length - ne;
  const count = [ne && `${ne} feil`, nw && `${nw} ${nw === 1 ? 'advarsel' : 'advarsler'}`].filter(Boolean).join(' · ');
  return (
    <div class="lintband" role="status">
      <div class="top"><b>Fila følger ikke konvensjonene</b><span class="mono">{count}</span></div>
      {sorted.map((l, i) => (
        <div key={i} class={'lrow' + hit(l.ln)}>
          <span class={'mk ' + l.sev} title={l.sev === 'error' ? 'Feil' : 'Advarsel'} />
          <div>
            <span class="t">{l.msg}</span>
            {RULE[l.rule] && <span class="h">{RULE[l.rule].desc}</span>}
          </div>
          <button
            class="ln mono"
            title="Gå til linja"
            onClick={e => {
              // <main> fjerner fokus ved klikk utenfor et kort
              e.stopPropagation();
              onLine(l.ln);
            }}
          >
            L{l.ln}
          </button>
        </div>
      ))}
    </div>
  );
}

interface Props {
  entry: Entry;
  collapsed: Record<string, boolean>;
  flash: Set<string>;
  lineNumbers: boolean;
  /** Linjeområdet som er markert i VS Code */
  mark: { from: number; to: number } | null;
  mainRef: RefObject<HTMLElement>;
  onToggle: (key: string) => void;
  /** Gå til en linje i fila (fra statusbåndet) */
  onLine: (ln: number) => void;
}

export function FeatureView({ entry, collapsed, flash, lineNumbers, mark, mainRef, onToggle, onLine }: Props) {
  const f = entry.model;
  const hit = (from: number, to = from) => (mark && from <= mark.to && to >= mark.from ? ' cursor' : '');
  const fileName = entry.path.slice(entry.path.lastIndexOf('/') + 1);

  // Egenskapshodet slås sammen til ett kompakt kort når dokumentet scrolles
  const [compact, setCompact] = useState(false);
  useEffect(() => {
    const main = mainRef.current;
    if (!main) return;
    const onScroll = () => setCompact(c => (c ? main.scrollTop >= EXPAND_AT : main.scrollTop > COMPACT_AT));
    onScroll();
    main.addEventListener('scroll', onScroll, { passive: true });
    return () => main.removeEventListener('scroll', onScroll);
  }, []);

  // Hodet legger seg under feilbanneret, som også er sticky
  const bannerRef = useRef<HTMLDivElement>(null);
  const [bannerH, setBannerH] = useState(0);
  useEffect(() => {
    const el = bannerRef.current;
    if (!el) return setBannerH(0);
    const ro = new ResizeObserver(() => setBannerH(el.offsetHeight));
    ro.observe(el);
    return () => ro.disconnect();
  }, [!!entry.error]);

  // Scroll til første endrede steg etter en lagring
  useEffect(() => {
    if (!flash.size) return;
    mainRef.current?.querySelector('.step.flash')?.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
  }, [flash]);

  // Parseren rapporterer ofte én feil per etterfølgende linje; vis de første
  const errLines = (entry.error ?? '').split('\n').filter(l => l && !/^Parser errors:?$/.test(l));
  const banner = entry.error && (
    <div class="errbanner" role="alert" ref={bannerRef}>
      <div class="head"><span class="diamond" style={{ background: 'var(--err)' }} />Parse-feil i {fileName}</div>
      <div class="msg">
        {errLines.slice(0, 3).join('\n')}
        {errLines.length > 3 && `\n… og ${errLines.length - 3} flere`}
      </div>
      <div class="hint">
        {f ? 'Viser sist gyldige versjon. Visningen oppdateres når filen parses igjen.' : 'Ingen gyldig versjon å vise ennå.'}
      </div>
    </div>
  );

  if (!f) return <>{banner}<div class="empty"><div class="mono" style={{ color: 'var(--ink)' }}>{fileName}</div></div></>;

  let num = 0;
  return (
    <>
      {banner}
      <div class={'doc' + (entry.error ? ' stale' : '')}>
        <div class={'fhead' + (compact ? ' compact' : '')} style={{ top: bannerH }}>
          <div class="fcard">
            {f.tags.length > 0 && (
              <div class="tags">
                {f.tags.map(t =>
                  isStatus(t) ? (
                    <span key={t} class="tag status" style={{ '--tc': statusColor(t.slice(1)) }}>
                      <StatusIcon s={t.slice(1) as Status} lg />{t}
                    </span>
                  ) : (
                    <span key={t} class={'tag' + (MOSCOW.includes(t) ? ' moscow' : '')}>{t}</span>
                  ),
                )}
              </div>
            )}
            <div class="fbanner"><span class="kbadge inv">Egenskap</span><h1>{f.title}</h1></div>
          </div>
        </div>
        <div class="meta">
          {f.issue && <a href={GITHUB + f.issue} target="_blank" rel="noreferrer">GitHub #{f.issue} ↗</a>}
          <span>språk: {f.lang}</span>
          <span>{f.nRules} regler · {f.nScen} scenarioer</span>
          <span>{f.nLines} linjer</span>
        </div>

        <LintBand lint={f.lint} hit={hit} onLine={onLine} />

        {f.desc.length > 0 && (
          <div class="story">
            {f.desc.map((d, i) => <div key={i}>{d.lead && <b>{d.lead}</b>} {d.rest}</div>)}
          </div>
        )}

        {f.notes.map((n, i) => <NoteBlock key={i} note={n} hit={hit} lineNumbers={lineNumbers} />)}

        {f.rules.map((r, ri) => {
          if (r.name !== null) num++;
          const ruleDraft = r.tags.includes('@draft');
          return (
            <div key={ri} class={'rule' + (ruleDraft ? ' draft' : '')} data-rule={ri}>
              {r.name !== null && (
                <div class={'rulehead' + hit(r.ln)}>
                  <span class="kbadge rule">Regel {num}</span>
                  <h2>{r.name}</h2>
                  <Tags tags={r.tags} />
                </div>
              )}
              {r.desc && <div class="desc">{r.desc}</div>}
              {r.notes.map((n, i) => <NoteBlock key={i} note={n} hit={hit} lineNumbers={lineNumbers} />)}
              {r.scenarios.map((s, si) => {
                const key = scenKey(ri, si);
                const open = !collapsed[key];
                const exCount = s.examples.reduce((n, e) => n + e.rows.length - 1, 0);
                const draft = ruleDraft || s.tags.includes('@draft');
                const nq = s.notes.filter(n => n.kind === 'question').reduce((n, q) => n + q.items.length, 0);
                const colors = kwColors(s.steps);
                return (
                  <div key={key} class={'card' + (KIND_CLASS[s.kind] ?? ' k-sm') + (draft ? ' draft' : '')} data-scen={key}>
                    <button class={'cardhead' + hit(s.ln)} onClick={() => onToggle(key)} aria-expanded={open}>
                      <span class="chev">{open ? '▼' : '▶'}</span>
                      <span class="kbadge">{s.kind}</span>
                      <span class="scname">{s.name || (s.kind === 'Bakgrunn' ? 'Felles forutsetninger' : '')}</span>
                      <Tags tags={s.tags} />
                      {nq > 0 && <span class="qbadge" title="Åpne spørsmål">? {nq}</span>}
                      <span class="scmeta">{s.steps.length} steg{exCount ? ` · ${exCount} eksempler` : ''} · L{s.ln}</span>
                    </button>
                    {open && (
                      <div class={'steps' + (lineNumbers ? '' : ' nolines')}>
                        {(s.desc || s.notes.length > 0) && (
                          <div class="cardnotes">
                            {s.desc && <div class="desc">{s.desc}</div>}
                            {s.notes.map((n, i) => <NoteBlock key={i} note={n} hit={hit} lineNumbers={lineNumbers} />)}
                          </div>
                        )}
                        {s.steps.map((st, ti) => (
                          <Fragment key={ti}>
                            <StepNotes step={st} hit={hit} lineNumbers={lineNumbers} />
                            <StepRow step={st} color={colors[ti]} lineNumbers={lineNumbers} flash={flash.has(stepKey(ri, si, ti))} marked={!!hit(st.ln, stepEnd(st))} />
                          </Fragment>
                        ))}
                        {s.examples.map((ex, ei) => (
                          <div key={ei} class="examples">
                            <span />
                            <div>
                              <span class="label"><span class="kbadge">Eksempler</span>{ex.name && <span>{ex.name}</span>}<Tags tags={ex.tags} /></span>
                              {ex.desc && <div class="desc">{ex.desc}</div>}
                              <Table rows={ex.rows} ex />
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          );
        })}

      </div>
    </>
  );
}
