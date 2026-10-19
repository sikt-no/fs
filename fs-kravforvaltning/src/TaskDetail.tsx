import { useState } from 'preact/hooks';
import { DOMAINS, parseIssue, type IssueRef } from '../shared/tasks';
import { ClaudeAction, isNewSpec, type SpecActions } from './SpecDetail';
import { StatusIcon } from './Sidebar';
import {
  colIcon,
  colOf,
  COL_WHY,
  handoffPrompt,
  kravPrompt,
  kravSummary,
  missing,
  nextStep,
  specifyPrompt,
  stepIcon,
  taskSpecifyPrompt,
  verifyPrompt,
  type Card,
  type ColConf,
  type ColKey,
  type KravKey,
  type NextLine,
  type TaskCard,
} from './specboard';
import { useCopy } from './useCopy';
import { useVerifyScreenshots } from './verifyScreenshots';

/** Hvor mange krav panelet viser før «+ N flere» */
const MAX_KRAV = 12;

const KRAV_FROM: Record<string, string> = {
  scope: 'fra scope-raden',
  spec: 'fra spesifikasjonene',
  lenke: 'fra «Krav (Gherkin)»',
};

const KRAV_LABEL: Record<KravKey, string> = {
  implemented: '@implemented',
  'in-progress': '@in-progress',
  planned: '@planned',
  draft: '@draft',
  deprecated: '@deprecated',
  skeleton: 'skjelett',
  wont: '@wont',
  missing: 'finnes ikke',
};
const kravIcon = (k: KravKey) => (k === 'skeleton' || k === 'missing' ? 'st st--none' : k === 'wont' ? 'spnext-dot' : `st st--${k}`);

/** Ikonet til en linje i «Neste steg» */
const lineIcon = (l: NextLine) =>
  l.mark === 'err' ? 'omk omk--no' : l.mark === 'warn' ? 'omk sp-mk--us' : l.mark === 'ok' ? 'omk omk--ok' : l.mark === 'dot' ? 'spnext-dot' : l.mark === 'planned' ? 'st st--planned' : l.mark === 'col' ? colIcon(l.col!) : stepIcon(l.mark);

/** Hvor en lenke til et krav i panelet kommer fra, så Krav-visningen kan vise veien tilbake */
export interface KravFrom {
  /** Valget på tavla (`<dom>/<slug>`) */
  sel: string;
  title: string;
  col: ColKey;
  colName: string;
  /** Kravene i oppgaven: båndet vises så lenge en av dem er åpen */
  paths: string[];
  /** Filtrene på tavla, som tekst («ingen» uten filter) */
  filters: string;
}

interface Props {
  t: TaskCard;
  col: ColConf;
  /** Spesifikasjonen som er åpen i det brede panelet */
  open: Card | null;
  ro: boolean;
  dirty: boolean;
  colName: (k: ColKey) => string;
  repoName: (r: string) => string;
  actions: SpecActions;
  onSpec: (c: Card) => void;
  onNewSpec: () => void;
  onClose: () => void;
  onOpenKrav: (path: string) => void;
  /** «Sett rute og send» for spesifikasjonen */
  onSend: (c: Card) => void;
  /** Steget i repoet settes til «pågår» før en utførekjøring (`what`: «utførekjøring» eller «utførekjøring med agent team») */
  onStart: (c: Card, repo: string, what: string) => void;
}

/**
 * Detaljpanelet (440 px) for oppgaven som er valgt (designet «Spesifikasjoner», runde 4): kolonnen, scope, Jira-sak og
 * eier, «Neste steg» med knappen som gjør det, kravene med opptelling, spesifikasjonene som rader (de åpnes i det brede
 * panelet), og avvik og statuslogg sammenfoldet.
 */
export function TaskDetail({ t, col, open, ro, dirty, colName, repoName, actions, onSpec, onNewSpec, onClose, onOpenKrav, onSend, onStart }: Props) {
  const [allKrav, setAllKrav] = useState(false);
  const [showLint, setShowLint] = useState(true);
  const [showLog, setShowLog] = useState(false);
  const task = t.task;
  const krav = allKrav ? t.krav : t.krav.slice(0, MAX_KRAV);
  const inSpec = new Set(t.specs.flatMap(s => s.feats.map(f => f.path)).filter(Boolean));
  const lint = [...task.lint, ...(t.scope?.lint ?? [])];
  const summary = kravSummary(t);
  const lead = nextStep(t, col.key).spec;
  return (
    <aside class="spdetail">
      <div class="spd">
        <div class="spd-path mono">
          <span class="ell">{t.dir}/</span>
          <button class="spbtn small" onClick={onClose}>
            Lukk ×
          </button>
        </div>

        <div class="spd-head">
          <h2 class="spd-title static">{task.title}</h2>
          <div class="spd-col">
            <span class="ochip acc">
              <span class={colIcon(col.key)} />
              {col.name}
            </span>
            <span class="omuted">{COL_WHY[col.key] ?? 'Første steg som ikke er levert.'}</span>
          </div>
          <div class="spd-meta mono">
            {t.scope ? (
              <span class="sptag acc" title={t.scope.title}>
                scope-{t.scope.slug}
              </span>
            ) : task.scope ? (
              <span class="sptag err" title="Scope-fila finnes ikke">
                scope-{task.scope} (finnes ikke)
              </span>
            ) : (
              <span class="sptag" title="Opprett med fs-scope">
                uten scope
              </span>
            )}
            <span class="omuted">·</span>
            {task.issue ? (
              <a href={task.issue.url} target="_blank" rel="noreferrer">
                {task.issue.key}
              </a>
            ) : (
              <span class="omuted">ingen Jira-sak</span>
            )}
            <span class="omuted">·</span>
            <span>{task.owner ?? '–'}</span>
            {task.initiativ && (
              <>
                <span class="omuted">·</span>
                <span class="ell" title="Initiativ">
                  {task.initiativ}
                </span>
              </>
            )}
          </div>
        </div>

        {dirty && (
          <div class="spd-dirty">
            <span class="dot" />
            <span>Endret lokalt. Kommer med i neste «Lag PR» og gjelder først når den er på main.</span>
          </div>
        )}

        <NextStepBox t={t} col={col.key} ro={ro} colName={colName} repoName={repoName} actions={actions} onSpec={onSpec} onNewSpec={onNewSpec} onSend={onSend} onStart={onStart} />

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Krav</span>
            <span class="mono omuted">
              {t.krav.length} {t.kravFrom ? KRAV_FROM[t.kravFrom] : ''}
            </span>
          </div>
          {summary.length > 0 && (
            <div class="spkrav-sum mono">
              {summary.map(g => (
                <span key={g.k}>
                  <span class={kravIcon(g.k)} />
                  {g.n} {KRAV_LABEL[g.k]}
                </span>
              ))}
            </div>
          )}
          {krav.map(k => {
            const flags = [
              k.skeleton && k.path ? 'skjelett' : '',
              k.wont ? '@wont' : '',
              t.scope && k.scope && k.scope !== t.scope.slug ? `scope-${k.scope}` : '',
              t.scope && k.entry && !k.scope ? 'uten @scope' : '',
              k.path && !inSpec.has(k.path) && t.unspecced.includes(k) && t.specs.length ? 'ingen spesifikasjon' : '',
            ].filter(Boolean);
            return (
              <div
                key={k.path ?? k.id ?? k.file}
                class="spkrav"
                onClick={() => k.path && onOpenKrav(k.path)}
                style={{ cursor: k.path ? 'pointer' : 'default' }}
                title={k.path ? `Åpne ${k.path} i Krav` : 'Finnes ikke under krav/'}
              >
                <StatusIcon s={k.display} />
                <div class="spfeat-t">
                  <span class="ell">{k.title || k.file}</span>
                  <span class="mono omuted small">
                    {k.id ?? k.file} · {k.status ? '@' + k.status : 'finnes ikke'}
                    {k.sub && ` · ${k.sub}`}
                  </span>
                </div>
                <span class="spkrav-flags">
                  {flags.map(f => (
                    <span key={f} class="sptag">
                      {f}
                    </span>
                  ))}
                </span>
              </div>
            );
          })}
          {t.krav.length > MAX_KRAV && (
            <button class="linkbtn small" onClick={() => setAllKrav(v => !v)}>
              {allKrav ? 'Vis færre' : `+ ${t.krav.length - MAX_KRAV} flere`}
            </button>
          )}
          {t.kravMissing.map(m => (
            <div key={m} class="spd-miss bare">
              <span class="omk omk--no" />
              <span class="mono">{m} finnes ikke under krav/</span>
            </div>
          ))}
          {!t.krav.length && !t.kravMissing.length && <span class="omuted">Ingen krav er koblet til oppgaven. Legg dem i scope-raden med fs-scope, eller i en spesifikasjon.</span>}
        </section>

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Spesifikasjoner</span>
            <span class="mono omuted">spec/spec-*.md</span>
          </div>
          {t.specs.map(s => {
            const c = colOf(s);
            const cur = c.startsWith('repo:') ? c.slice(5) : null;
            const isNew = isNewSpec(s);
            const m = c === 'spesifiseres' ? missing(s) : [];
            return (
              <div key={s.key} class={'spspecrow' + (open?.key === s.key ? ' on' : '')} onClick={() => onSpec(s)} title="Åpne spesifikasjonen">
                <div class="spspecrow-t">
                  <span class="ell strong">{s.doc.title || (isNew ? 'Ny spesifikasjon' : s.file)}</span>
                  {s === lead && <span class="sptag acc">neste steg</span>}
                  <span class="push mono small spspecrow-col">
                    <span class={colIcon(c)} />
                    {isNew ? 'utkast' : colName(c)}
                  </span>
                </div>
                <div class="spspecrow-s mono small">
                  {s.run.route.length > 0 ? (
                    <span class="sproute">
                      {s.run.route.map((r, i) => (
                        <span key={r} class="sproute-i">
                          {i > 0 && <span class="sproute-sep">→</span>}
                          <span class={stepIcon(s.run.steps.find(x => x.repo === r)?.status)} />
                          <span style={{ color: r === cur ? 'var(--ink)' : 'var(--muted)', fontWeight: r === cur ? 600 : 400 }}>{repoName(r).replace(/^fs-/, '')}</span>
                        </span>
                      ))}
                    </span>
                  ) : (
                    <span class="ell omuted">{m.length ? 'Mangler: ' + m.join(' · ') : c === 'klar' ? `Rute ikke satt · ${s.file}` : s.file}</span>
                  )}
                  <span class="push spspecrow-open">Åpne →</span>
                </div>
              </div>
            );
          })}
          {!t.specs.length && <span class="omuted">Ingen spesifikasjoner ennå. Kjør fs-specify, eller lag en med «+ Ny spesifikasjon» når kravene er @planned.</span>}
          {!ro && t.specs.length > 0 && !t.specs.some(isNewSpec) && (
            <button class="spbtn dashed self-start" onClick={onNewSpec}>
              + Ny spesifikasjon
            </button>
          )}
        </section>

        <div class="spfolds">
          {lint.length > 0 && (
            <section class="spfold">
              <button class="spfold-h" onClick={() => setShowLint(v => !v)}>
                <span class={'spchev' + (showLint ? ' up' : '')} />
                <span>Avvik</span>
                <span class="sptag err">{lint.length}</span>
                <span class="push mono omuted small">tasks/README.md</span>
              </button>
              {showLint &&
                lint.map((l, i) => (
                  <div key={i} class="spd-miss bare" title={l.hint}>
                    <span class="omk omk--no" />
                    <span>
                      {l.title}
                      <span class="omuted small"> · {l.hint}</span>
                    </span>
                  </div>
                ))}
            </section>
          )}
          {task.log.length > 0 && (
            <section class="spfold">
              <button class="spfold-h" onClick={() => setShowLog(v => !v)}>
                <span class={'spchev' + (showLog ? ' up' : '')} />
                <span>Statuslogg</span>
                <span class="push mono omuted small">oppgave.md · {task.log.length}</span>
              </button>
              {showLog && (
                <div class="splog mono">
                  {task.log.slice(0, 6).map((e, i) => (
                    <div key={i}>
                      <span class="omuted">{e.d}</span>
                      <span>
                        {e.who ? e.who + ' — ' : ''}
                        {e.t}
                      </span>
                    </div>
                  ))}
                </div>
              )}
            </section>
          )}
        </div>
      </div>
    </aside>
  );
}

interface NextProps {
  t: TaskCard;
  col: ColKey;
  ro: boolean;
  colName: (k: ColKey) => string;
  repoName: (r: string) => string;
  actions: SpecActions;
  onSpec: (c: Card) => void;
  onNewSpec: () => void;
  onSend: (c: Card) => void;
  onStart: (c: Card, repo: string, what: string) => void;
}

/** «Neste steg»: hva som mangler eller skjer nå (`nextStep`), og knappen som gjør det */
function NextStepBox({ t, col, ro, colName, repoName, actions, onSpec, onNewSpec, onSend, onStart }: NextProps) {
  const n = nextStep(t, col);
  const s = n.spec;
  const [copied, copy] = useCopy();
  const [shots, setShots] = useVerifyScreenshots();
  const openSpec = s && (
    <button class="spbtn" onClick={() => onSpec(s)}>
      Åpne spesifikasjonen
    </button>
  );
  const btns = (() => {
    switch (n.kind) {
      case 'scope-tom':
        return <ClaudeAction label="Kjør fs-scope" skill="fs-scope" solid prompt={() => `Revider scopet for oppgaven ${t.dir}/ (${t.task.title}) med fs-scope: hvilke krav skal oppgaven ha?`} />;
      case 'skjelett':
      case 'kravarbeid':
        return <ClaudeAction label="Kjør fs-krav" skill="fs-krav" solid prompt={() => kravPrompt(t)} />;
      case 'mangler-spec':
        return (
          <>
            <ClaudeAction label="Kjør fs-specify" skill="fs-specify" solid prompt={() => taskSpecifyPrompt(t)} />
            <button class="spbtn" onClick={onNewSpec}>
              + Ny spesifikasjon
            </button>
          </>
        );
      case 'spec-mangler':
        return (
          <>
            {!isNewSpec(s!) && <ClaudeAction label={`Kjør ${s!.doc.delta ? 'fs-specify-delta' : 'fs-specify'}`} skill={s!.doc.delta ? 'fs-specify-delta' : 'fs-specify'} solid prompt={() => specifyPrompt(s!)} />}
            {openSpec}
          </>
        );
      case 'klar':
        return (
          <>
            <button class="spbtn solid" disabled={!s!.doc.rute.length} title={s!.doc.rute.length ? `Sender til ${repoName(s!.doc.rute[0])}` : 'Velg rute i spesifikasjonen først'} onClick={() => onSend(s!)}>
              <span class="sp-dia light" />
              Sett rute og send
            </button>
            {openSpec}
          </>
        );
      case 'repo': {
        const r = n.repo!;
        const blocked = s!.run.steps.find(x => x.repo === r)?.blocked != null;
        const can = !!actions.execute && actions.canExecute(r) && !blocked;
        return (
          <>
            <button
              class="spbtn solid"
              disabled={!can}
              title={blocked ? 'Steget er blokkert' : can ? `Utførekjøring i Claude-panelet, cwd = ${repoName(r)}` : actions.executeWhy}
              onClick={() => {
                if (!can) return;
                onStart(s!, r, 'utførekjøring');
                actions.execute!(s!, r);
              }}
            >
              <span class="sp-dia light" />
              Utfør i {repoName(r)}
            </button>
            {actions.executeTeam && (
              <button
                class="spbtn acc"
                disabled={blocked || !actions.canExecute(r)}
                title={blocked ? 'Steget er blokkert' : actions.canExecute(r) ? `Interaktiv Claude Code med agent teams i en terminal i Claude-panelet, cwd = ${repoName(r)}` : actions.executeWhy}
                onClick={() => {
                  if (blocked || !actions.canExecute(r)) return;
                  onStart(s!, r, 'utførekjøring med agent team');
                  actions.executeTeam!(s!, r);
                }}
              >
                Utfør med team
              </button>
            )}
            <button class={'spbtn ' + (copied ? 'solid' : 'acc')} title={`Handoff-prompt til en ekstern Claude Code-økt i ${repoName(r)}`} onClick={() => copy(handoffPrompt(s!, r))}>
              {copied ? 'Kopiert' : 'Kopier prompt'}
            </button>
          </>
        );
      }
      case 'verifisering':
        return (
          <>
            <ClaudeAction label="Verifiser" prompt={() => verifyPrompt(s!, shots)} skill="fs-verify" solid />
            {actions.verifyTeam && (
              <button class="spbtn acc" title="fs-verify-agent-teams i en terminal i Claude-panelet: én teammate per feature-fil" onClick={() => actions.verifyTeam?.(s!, shots)}>
                Verifiser med agent team
              </button>
            )}
            <label class="spd-check small">
              <input type="checkbox" checked={shots} onChange={e => setShots((e.currentTarget as HTMLInputElement).checked)} />
              Ta skjermbilder (test-fsadmin)
            </label>
          </>
        );
      default:
        return null;
    }
  })();
  return (
    <div class={'spnext ' + n.tone}>
      <div class="spnext-h">
        <span>Neste steg</span>
        <span class="push mono omuted small ell">{n.ctx}</span>
      </div>
      <div class="spnext-b">
        {n.lines.map((l, i) => (
          <div key={i} class="spnext-l">
            <span class={lineIcon(l)} />
            <div>
              <span class={l.mark === 'err' && /^(Blokkert|Sendt tilbake)/.test(l.t) ? 'err' : l.mark === 'col' || l.mark === 'warn' ? 'ink2' : ''}>{l.t}</span>
              {(l.sub || l.mark === 'col') && <span class="mono omuted small">{l.mark === 'col' ? colName(l.col!) : l.sub}</span>}
            </div>
          </div>
        ))}
      </div>
      {!ro && btns && <div class="spnext-f sprow-btns">{btns}</div>}
    </div>
  );
}

/** «+ Ny oppgave»: tittel, domene, Jira-sak og eier. Skriver en minimal oppgave.md fra malen. */
export function NewTaskForm({ me, onClose, onCreate }: { me: string; onClose: () => void; onCreate: (o: { title: string; dom: string; issue: IssueRef | null; owner: string | null }) => void }) {
  const [title, setTitle] = useState('');
  const [dom, setDom] = useState('');
  const [issue, setIssue] = useState('');
  const [owner, setOwner] = useState(me.startsWith('@') ? me : '');
  const ok = !!title.trim() && !!dom;
  return (
    <aside class="spdetail">
      <div class="spd">
        <div class="spd-path mono">
          <span class="ell">tasks/{dom || '‹domene›'}/…/oppgave.md</span>
          <button class="spbtn small" onClick={onClose}>
            Lukk ×
          </button>
        </div>
        <div class="spd-head">
          <h2 class="spd-title static">Ny oppgave</h2>
          <span class="omuted spd-lead">
            En oppgave i et initiativ opprettes med fs-scope, som også bestemmer kravene. Her lages en oppgave uten scope, med en minimal oppgave.md.
          </span>
        </div>
        <section class="spd-sec">
          <div class="spmeta form">
            <span class="omuted">Tittel</span>
            <input class="spinl strong" value={title} placeholder="Hva oppgaven leverer" onInput={e => setTitle((e.target as HTMLInputElement).value)} />
            <span class="omuted">Domene</span>
            <select value={dom} onChange={e => setDom((e.target as HTMLSelectElement).value)}>
              <option value="">velg …</option>
              {Object.entries(DOMAINS).map(([k, v]) => (
                <option key={k} value={k}>
                  {v}
                </option>
              ))}
            </select>
            <span class="omuted">Issue</span>
            <input class="spinl mono" value={issue} placeholder="BAT-1234 (valgfri)" onInput={e => setIssue((e.target as HTMLInputElement).value)} />
            <span class="omuted">Eier</span>
            <input class="spinl mono" value={owner} placeholder="@brukernavn" onInput={e => setOwner((e.target as HTMLInputElement).value)} />
          </div>
        </section>
        <div class="sprow-btns">
          <button
            class="spbtn solid"
            disabled={!ok}
            onClick={() => onCreate({ title: title.trim(), dom, issue: parseIssue(issue.trim()), owner: owner.trim() || null })}
          >
            Opprett oppgave
          </button>
        </div>
      </div>
    </aside>
  );
}
