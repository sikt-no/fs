import { useContext, useEffect, useRef, useState } from 'preact/hooks';
import { createContext, Fragment, type RefObject } from 'preact';
import { STATUSES, type Entry, type Lint, type Status, type Note, type Step } from '../shared/model';
import { RULE } from '../shared/rules';
import { segments, type FindResult } from './find';
import { StatusIcon, statusColor } from './Sidebar';
import { useCopy } from './useCopy';
import { SelectionMenu } from './SelectionMenu';
import type { VerifyScope } from './verifyPrompt';
import { VerifyMenu } from './VerifyMenu';

export const scenKey = (ri: number, si: number) => `${ri}-${si}`;
export const stepKey = (ri: number, si: number, ti: number) => `${ri}-${si}-${ti}`;

const GITHUB = 'https://github.com/sikt-no/fs/issues/';
const isStatus = (t: string) => (STATUSES as readonly string[]).includes(t.slice(1));
const MOSCOW = ['@must', '@should', '@could', '@wont'];
/** Scrollgrensene for når egenskapshodet slås sammen og foldes ut igjen (hysterese) */
const COMPACT_AT = 60;
const EXPAND_AT = 12;

const PARAM = /(<[^>]+>)/;
const REF = /([A-ZÆØÅ]{2,4}(?:-[A-ZÆØÅ]{2,4}){2}-\d{3}|#\d+|"[^"]+\.feature")/;

/** Søket i fila: treffene og hvilket som er gjeldende */
export interface FindState {
  result: FindResult;
  cur: number;
}
const FindCtx = createContext<FindState | null>(null);

/**
 * Tekst med parametere/referanser (`re`) og søketreff markert. `loc` er tekstbiten i `findHits`;
 * treffene får `data-hit`, som hoppet til gjeldende treff bruker.
 */
function Txt({ text, loc, re = null, cls = '' }: { text: string; loc: string; re?: RegExp | null; cls?: string }) {
  const find = useContext(FindCtx);
  return (
    <>
      {segments(text, re, find?.result.at.get(loc)).map((g, i) => {
        const c = [g.mark && cls, g.hit !== undefined && 'hit', g.hit !== undefined && g.hit === find?.cur && 'cur'].filter(Boolean).join(' ');
        return (
          <span key={i} class={c || undefined} data-hit={g.hit !== undefined ? `f-${g.hit}` : undefined}>
            {g.t}
          </span>
        );
      })}
    </>
  );
}
const Params = ({ text, loc }: { text: string; loc: string }) => <Txt text={text} loc={loc} re={PARAM} cls="param" />;
const Refs = ({ text, loc }: { text: string; loc: string }) => <Txt text={text} loc={loc} re={REF} cls="ref" />;

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

/**
 * Kopierer en tittel til utklippstavla. Ligger inni tittelen, så ikonet følger siste ord når tittelen brytes.
 * Er et `span`, fordi scenariohodet selv er en knapp; klikket stoppes så kortet ikke foldes.
 */
function CopyTitle({ text }: { text: string }) {
  const [copied, copy] = useCopy();
  const run = (e: Event) => {
    e.preventDefault();
    e.stopPropagation();
    copy(text);
  };
  const label = copied ? 'Kopiert' : 'Kopier tittelen';
  return (
    <span
      class={'copytitle' + (copied ? ' done' : '')}
      role="button"
      tabIndex={0}
      title={label}
      aria-label={label}
      onClick={run}
      onKeyDown={e => (e.key === 'Enter' || e.key === ' ') && run(e)}
    >
      <svg viewBox="0 0 16 16" width="14" height="14" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
        {copied ? (
          <path d="M3.5 8.5l3 3 6-7" />
        ) : (
          <>
            <rect x="5.25" y="5.25" width="8" height="8.5" rx="1.5" />
            <path d="M10.75 5.25V3.5a1.25 1.25 0 0 0-1.25-1.25h-5.5A1.25 1.25 0 0 0 2.75 3.5v6.5a1.25 1.25 0 0 0 1.25 1.25h1.25" />
          </>
        )}
      </svg>
    </span>
  );
}

/** Åpne spørsmål og vanlige kommentarer, vist rett under elementet de hører til. */
function NoteBlock({ note, loc, hit, lineNumbers }: { note: Note; loc: string; hit: (from: number, to?: number) => string; lineNumbers: boolean }) {
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
            <li key={i} class={hit(q.ln) || undefined} data-ln={q.ln}>
              <Refs text={q.text} loc={`${loc}:${i}`} />
              {lineNumbers && <span class="qln">L{q.ln}</span>}
            </li>
          ))}
        </ol>
      </div>
    );
  }
  return (
    <div class={'note' + hit(note.ln, last)} data-ln={note.ln}>
      {note.head && <span class="nhead">{note.head}</span>}
      {note.items.length > 0 && <div class="ntext"><Refs text={note.items.map(i => i.text).join('\n')} loc={loc} /></div>}
      {lineNumbers && <span class="qln">L{note.ln}</span>}
    </div>
  );
}

/** `lns` er linja til hver rad, så markert tekst får riktig linjeområde */
function Table({ rows, lns, loc, ex, params }: { rows: string[][]; lns: number[]; loc: string; ex?: boolean; params?: boolean }) {
  return (
    <div>
      <div class={'table' + (ex ? ' ex' : '')} style={{ gridTemplateColumns: `repeat(${rows[0]?.length ?? 1}, auto)` }}>
        {rows.flatMap((r, ri) => r.map((c, ci) => <span key={`${ri}-${ci}`} class={ri === 0 ? 'th' : ''} data-ln={lns[ri]}>{params ? <Params text={c} loc={`${loc}:${ri}:${ci}`} /> : <Txt text={c} loc={`${loc}:${ri}:${ci}`} />}</span>))}
      </div>
    </div>
  );
}

/** Siste linje steget dekker i filen, inkludert tabell eller docstring. */
const stepEnd = (st: Step) => st.ln + (st.table?.length ?? 0) + (st.doc !== undefined ? st.doc.split('\n').length + 1 : 0);

function StepNotes({ step, loc, hit, lineNumbers }: { step: Step; loc: string; hit: (from: number, to?: number) => string; lineNumbers: boolean }) {
  return (
    <>
      {step.notes?.map((n, i) => (
        <div key={i} class="step stepnote">
          <span class="ln">{lineNumbers ? n.ln : ''}</span>
          <NoteBlock note={n} loc={`${loc}n${i}`} hit={hit} lineNumbers={false} />
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

function StepRow({ step, loc, color, flash, marked, lineNumbers }: { step: Step; loc: string; color: string; flash: boolean; marked: boolean; lineNumbers: boolean }) {
  return (
    <div class={'step' + (flash ? ' flash' : '') + (marked ? ' cursor' : '')} data-ln={step.ln}>
      <span class="ln">{lineNumbers ? step.ln : ''}</span>
      <span class={'kw' + (isAnd(step.kw) ? ' and' : '')} style={{ color }}>{step.kw}</span>
      <div class="steptext">
        <Params text={step.text} loc={loc} />
        {step.table && <Table rows={step.table} lns={step.table.map((_, i) => step.ln + 1 + i)} loc={loc} params />}
        {step.doc !== undefined && <pre class="docstring" data-ln={step.ln + 1}><Txt text={step.doc} loc={`${loc}:doc`} /></pre>}
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
        <div key={i} class={'lrow' + hit(l.ln)} data-ln={l.ln}>
          <span class={'mk ' + l.sev} title={l.sev === 'error' ? 'Feil' : 'Advarsel'} />
          <div>
            <span class="t" data-sep={'\n'}>{l.msg}</span>
            {RULE[l.rule] && <span class="h" data-sep={'\n'}>{RULE[l.rule].desc}</span>}
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
  /** Søket i fila, når det står et søk */
  find: FindState | null;
  /** Scenarioer brukeren har lukket mens søket står; de åpnes ikke av søket igjen */
  findClosed: Record<string, boolean>;
  /** Brukeren lukker et scenario mens søket står */
  onFindClose: (key: string) => void;
  /** Gå til en linje i fila (fra statusbåndet) */
  onLine: (ln: number) => void;
  /** Åpne fila i editoren; utelatt der redigering ikke er tilgjengelig */
  onEdit?: () => void;
  /** «Slett kravfil»; utelatt der redigering ikke er tilgjengelig */
  onDelete?: () => void;
  /** «Verifiser» på egenskapen eller en regel; utelatt når Claude-panelet ikke er tilgjengelig */
  onVerify?: (scope: VerifyScope, screenshots: boolean) => void;
  /** «I terminal med agent team» på egenskapen (fs-verify-agent-teams) */
  onVerifyTeam?: (screenshots: boolean) => void;
}

export function FeatureView({ entry, collapsed, flash, lineNumbers, mark, mainRef, onToggle, find, findClosed, onFindClose, onLine, onEdit, onDelete, onVerify, onVerifyTeam }: Props) {
  const f = entry.model;
  const hit = (from: number, to = from) => (mark && from <= mark.to && to >= mark.from ? ' cursor' : '');
  const fileName = entry.path.slice(entry.path.lastIndexOf('/') + 1);

  // Egenskapshodet slås sammen til ett kompakt kort når dokumentet scrolles
  const [compact, setCompact] = useState(false);
  const compactRef = useRef(compact);
  compactRef.current = compact;
  useEffect(() => {
    const main = mainRef.current;
    if (!main) return;
    // Sammenslåingen gjør dokumentet lavere. Er fila så kort at scrollTop da klemmes under EXPAND_AT,
    // ville hodet foldet seg ut igjen med en gang, så da blir det stående utfoldet.
    // Høydene måles på skjulte kopier utenfor flyten, så målingen ikke klemmer scrollTop
    const fits = () => {
      const head = main.querySelector<HTMLElement>('.fhead');
      if (!head) return true;
      const room = (compact: boolean) => {
        const el = head.cloneNode(true) as HTMLElement;
        el.className = 'fhead measure' + (compact ? ' compact' : '');
        Object.assign(el.style, { position: 'absolute', visibility: 'hidden', top: '0', left: '0', boxSizing: 'border-box', width: `${head.offsetWidth}px` });
        head.parentElement!.appendChild(el);
        const cs = getComputedStyle(el);
        const h = el.offsetHeight + parseFloat(cs.marginTop) + parseFloat(cs.marginBottom);
        el.remove();
        return h;
      };
      return main.scrollHeight - main.clientHeight - (room(false) - room(true)) >= EXPAND_AT;
    };
    const onScroll = () => {
      if (compactRef.current) setCompact(main.scrollTop >= EXPAND_AT);
      else if (main.scrollTop > COMPACT_AT && fits()) setCompact(true);
    };
    onScroll();
    main.addEventListener('scroll', onScroll, { passive: true });
    return () => main.removeEventListener('scroll', onScroll);
  }, []);

  // Dokumentet, der markert tekst får menyen «Kopier / Legg i samtalen»
  const docRef = useRef<HTMLDivElement>(null);

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
    <FindCtx.Provider value={find}>
      {banner}
      <div class={'doc' + (entry.error ? ' stale' : '')} ref={docRef}>
        <SelectionMenu docRef={docRef} path={entry.path} />
        <div class={'fhead' + (compact ? ' compact' : '')} style={{ top: bannerH }}>
          <div class="fcard">
            {f.tags.length > 0 && (
              <div class="tags" data-ln={f.tagLn ?? f.ln}>
                {f.tags.map(t =>
                  isStatus(t) ? (
                    <span key={t} class="tag status" style={{ '--tc': statusColor(t.slice(1)) }} data-sep=" ">
                      <StatusIcon s={t.slice(1) as Status} lg />{t}
                    </span>
                  ) : (
                    <span key={t} class={'tag' + (MOSCOW.includes(t) ? ' moscow' : '')} data-sep=" ">{t}</span>
                  ),
                )}
              </div>
            )}
            <div class="fbanner" data-ln={f.ln}><span class="kbadge inv">Egenskap</span><h1><Txt text={f.title} loc="title" />{f.title && <CopyTitle text={f.title} />}</h1></div>
          </div>
        </div>
        <div class="meta">
          {f.issue && <a href={GITHUB + f.issue} target="_blank" rel="noreferrer" data-ln={f.issueLn ?? f.ln} data-sep=" · ">GitHub #{f.issue} ↗</a>}
          <span data-ln={f.langLn ?? f.ln} data-sep=" · ">språk: {f.lang}</span>
          <span data-ln={f.ln} data-sep=" · ">{f.nRules} regler · {f.nScen} scenarioer</span>
          <span data-ln={f.ln} data-sep=" · ">{f.nLines} linjer</span>
          {onEdit && <button class="smallbtn editbtn" onClick={onEdit}>Rediger</button>}
          {onDelete && <button class="smallbtn editbtn" onClick={onDelete}>Slett kravfil</button>}
          {onVerify && <VerifyMenu what="egenskapen" onVerify={shots => onVerify({ kind: 'feature' }, shots)} onTerminal={onVerifyTeam} />}
        </div>

        <LintBand lint={f.lint} hit={hit} onLine={onLine} />

        {f.desc.length > 0 && (
          <div class="story">
            {f.desc.map((d, i) => <div key={i} data-ln={d.ln}>{d.lead && <b>{d.lead}</b>} <Txt text={d.rest} loc={`desc:${i}`} /></div>)}
          </div>
        )}

        {f.notes.map((n, i) => <NoteBlock key={i} note={n} loc={`fn${i}`} hit={hit} lineNumbers={lineNumbers} />)}

        {f.rules.map((r, ri) => {
          if (r.name !== null) num++;
          const ruleDraft = r.tags.includes('@draft');
          return (
            <div key={ri} class={'rule' + (ruleDraft ? ' draft' : '')} data-rule={ri}>
              {r.name !== null && (
                <div class={'rulehead' + hit(r.ln)} data-ln={r.ln}>
                  <span class="kbadge rule">Regel {num}</span>
                  <h2><Txt text={r.name} loc={`r${ri}`} />{r.name && <CopyTitle text={r.name} />}</h2>
                  <Tags tags={r.tags} />
                  {onVerify && <VerifyMenu what="regelen" onVerify={shots => onVerify({ kind: 'rule', index: ri }, shots)} />}
                </div>
              )}
              {r.desc && <div class="desc"><Txt text={r.desc} loc={`r${ri}:desc`} /></div>}
              {r.notes.map((n, i) => <NoteBlock key={i} note={n} loc={`r${ri}n${i}`} hit={hit} lineNumbers={lineNumbers} />)}
              {r.scenarios.map((s, si) => {
                const key = scenKey(ri, si);
                // Søket åpner lukkede scenarioer med treff, til brukeren lukker dem igjen
                const nHits = find?.result.perScen.get(key) ?? 0;
                const forced = nHits > 0 && !!collapsed[key] && !findClosed[key];
                const open = !collapsed[key] || forced;
                const exCount = s.examples.reduce((n, e) => n + e.rows.length - 1, 0);
                const draft = ruleDraft || s.tags.includes('@draft');
                const nq = s.notes.filter(n => n.kind === 'question').reduce((n, q) => n + q.items.length, 0);
                const colors = kwColors(s.steps);
                return (
                  <div key={key} class={'card' + (KIND_CLASS[s.kind] ?? ' k-sm') + (draft ? ' draft' : '')} data-scen={key}>
                    <button
                      class={'cardhead' + hit(s.ln)}
                      data-ln={s.ln}
                      onClick={() => {
                        if (open && find) onFindClose(key);
                        if (!forced) onToggle(key);
                      }}
                      aria-expanded={open}
                    >
                      <span class="chev">{open ? '▼' : '▶'}</span>
                      <span class="kbadge">{s.kind}</span>
                      <span class="scname">
                        <Txt text={s.name || (s.kind === 'Bakgrunn' ? 'Felles forutsetninger' : '')} loc={`s${key}`} />
                        {s.name && <CopyTitle text={s.name} />}
                      </span>
                      <Tags tags={s.tags} />
                      {nq > 0 && <span class="qbadge" title="Åpne spørsmål">? {nq}</span>}
                      {forced && <span class="findbadge forced">åpnet av søk</span>}
                      {nHits > 0 && <span class="findbadge">{nHits} treff</span>}
                      <span class="scmeta">{s.steps.length} steg{exCount ? ` · ${exCount} eksempler` : ''} · L{s.ln}</span>
                    </button>
                    {open && (
                      <div class={'steps' + (lineNumbers ? '' : ' nolines')}>
                        {(s.desc || s.notes.length > 0) && (
                          <div class="cardnotes">
                            {s.desc && <div class="desc"><Txt text={s.desc} loc={`s${key}:desc`} /></div>}
                            {s.notes.map((n, i) => <NoteBlock key={i} note={n} loc={`s${key}n${i}`} hit={hit} lineNumbers={lineNumbers} />)}
                          </div>
                        )}
                        {s.steps.map((st, ti) => (
                          <Fragment key={ti}>
                            <StepNotes step={st} loc={`t${key}-${ti}`} hit={hit} lineNumbers={lineNumbers} />
                            <StepRow step={st} loc={`t${key}-${ti}`} color={colors[ti]} lineNumbers={lineNumbers} flash={flash.has(stepKey(ri, si, ti))} marked={!!hit(st.ln, stepEnd(st))} />
                          </Fragment>
                        ))}
                        {s.examples.map((ex, ei) => (
                          <div key={ei} class="examples">
                            <span />
                            <div>
                              <span class="label"><span class="kbadge">Eksempler</span>{ex.name && <span><Txt text={ex.name} loc={`x${key}-${ei}:name`} /><CopyTitle text={ex.name} /></span>}<Tags tags={ex.tags} /></span>
                              {ex.desc && <div class="desc">{ex.desc}</div>}
                              <Table rows={ex.rows} lns={ex.lns ?? []} loc={`x${key}-${ei}`} ex />
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
    </FindCtx.Provider>
  );
}
