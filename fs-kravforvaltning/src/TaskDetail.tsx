import type { ComponentChildren } from 'preact';
import { useState } from 'preact/hooks';
import { DOMAINS, parseIssue, type IssueRef } from '../shared/tasks';
import { ClaudeAction } from './SpecDetail';
import { StatusIcon } from './Sidebar';
import { colOf, COL_WHY, kravPrompt, taskSpecifyPrompt, type Card, type ColConf, type ColKey, type TaskCard } from './specboard';

/** Hvor mange krav panelet viser før «+ N flere» */
const MAX_KRAV = 12;

const KRAV_FROM: Record<string, string> = {
  scope: 'fra scope-raden',
  spec: 'fra spesifikasjonene',
  lenke: 'fra «Krav (Gherkin)»',
};

interface Props {
  t: TaskCard;
  col: ColConf;
  /** Hva som mangler før oppgaven kommer videre (kolonnene som utledes fra kravene) */
  missing: string[];
  /** Spesifikasjonen som vises under oppgaven */
  sel: Card | null;
  ro: boolean;
  dirty: boolean;
  colName: (k: ColKey) => string;
  onSpec: (c: Card | null) => void;
  onNewSpec: () => void;
  onClose: () => void;
  onOpenKrav: (path: string) => void;
  /** Detaljene for spesifikasjonen som er valgt (SpecDetail) */
  children?: ComponentChildren;
}

/**
 * Detaljpanelet (440 px) for oppgaven som er valgt: kolonnen og hva som mangler, metadata og scope, kravene med status,
 * avvikene i mappa, og spesifikasjonene i oppgaven som faner, med den valgte under.
 */
export function TaskDetail({ t, col, missing, sel, ro, dirty, colName, onSpec, onNewSpec, onClose, onOpenKrav, children }: Props) {
  const [allKrav, setAllKrav] = useState(false);
  const task = t.task;
  const krav = allKrav ? t.krav : t.krav.slice(0, MAX_KRAV);
  const inSpec = new Set(t.specs.flatMap(s => s.feats.map(f => f.path)).filter(Boolean));
  const scopeLint = t.scope?.lint ?? [];
  const lint = [...task.lint, ...scopeLint];
  const derived = col.key === 'scope' || col.key === 'kravarbeid' || (col.key === 'spesifiseres' && !t.specs.length);
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
              <span class={col.key.startsWith('repo:') ? 'sp-ic sp-ic--repo' : ''} />
              {col.name}
            </span>
            <span class="omuted">{COL_WHY[col.key] ?? 'Første steg som ikke er levert.'}</span>
          </div>
        </div>

        {dirty && (
          <div class="spd-dirty">
            <span class="dot" />
            <span>Endret lokalt. Kommer med i neste «Lag PR» og gjelder først når den er på main.</span>
          </div>
        )}

        {derived && missing.length > 0 && (
          <div class="spd-box">
            <div class="spd-box-h">Mangler før {col.key === 'spesifiseres' ? colName('klar') : col.key === 'kravarbeid' ? colName('spesifiseres') : colName('kravarbeid')}</div>
            {missing.map(m => (
              <div key={m} class="spd-miss">
                <span class="omk omk--no" />
                <span>{m}</span>
              </div>
            ))}
            {!ro && (
              <div class="spd-box-f sprow-btns">
                {(col.key === 'scope' || col.key === 'kravarbeid') && t.krav.length > 0 && <ClaudeAction label="Kjør fs-krav" skill="fs-krav" prompt={() => kravPrompt(t)} />}
                {col.key === 'scope' && !t.krav.length && <ClaudeAction label="Kjør fs-scope" skill="fs-scope" prompt={() => `Revider scopet for oppgaven ${t.dir}/ (${task.title}) med fs-scope: hvilke krav skal oppgaven ha?`} />}
                {col.key === 'spesifiseres' && <ClaudeAction label="Kjør fs-specify" skill="fs-specify" prompt={() => taskSpecifyPrompt(t)} />}
                {col.key === 'spesifiseres' && (
                  <button class="spbtn" onClick={onNewSpec}>
                    + Ny spesifikasjon
                  </button>
                )}
              </div>
            )}
          </div>
        )}

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Oppgaven</span>
            <span class="mono omuted">oppgave.md</span>
          </div>
          <div class="spmeta">
            <span class="omuted">Issue</span>
            <span class="mono">{task.issue ? <a href={task.issue.url} target="_blank" rel="noreferrer">{task.issue.key}</a> : '–'}</span>
            <span class="omuted">Eier</span>
            <span class="mono">{task.owner ?? '–'}</span>
            <span class="omuted">Domene</span>
            <span class="mono">{task.dom}</span>
            <span class="omuted">Scope</span>
            <span>
              {t.scope ? (
                <>
                  <span class="mono">scope-{t.scope.slug}</span> <span class="omuted">· {t.scope.title}</span>
                </>
              ) : task.scope ? (
                <span class="mono" style={{ color: 'var(--err)' }}>scope-{task.scope} (finnes ikke)</span>
              ) : (
                <span class="omuted">ingen · opprett med fs-scope</span>
              )}
            </span>
            {task.initiativ && (
              <>
                <span class="omuted">Initiativ</span>
                <span>{task.initiativ}</span>
              </>
            )}
          </div>
        </section>

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Krav</span>
            <span class="mono omuted">
              {t.krav.length} {t.kravFrom ? KRAV_FROM[t.kravFrom] : ''}
            </span>
          </div>
          {krav.map(k => {
            const flags = [
              k.skeleton && k.path ? 'skjelett' : '',
              k.wont ? '@wont' : '',
              t.scope && k.scope && k.scope !== t.scope.slug ? `scope-${k.scope}` : '',
              t.scope && k.entry && !k.scope ? 'uten @scope' : '',
              k.path && !inSpec.has(k.path) && t.unspecced.includes(k) ? 'ingen spesifikasjon' : '',
            ].filter(Boolean);
            return (
              <div
                key={k.path ?? k.id ?? k.file}
                class="spkrav"
                onClick={() => k.path && onOpenKrav(k.path)}
                style={{ cursor: k.path ? 'pointer' : 'default' }}
                title={k.path ?? 'Finnes ikke under krav/'}
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

        {lint.length > 0 && (
          <section class="spd-sec">
            <div class="spd-sec-h">
              <span>Avvik</span>
              <span class="mono omuted">tasks/README.md</span>
            </div>
            {lint.map((l, i) => (
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

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Spesifikasjoner</span>
            <span class="mono omuted">spec/spec-*.md</span>
          </div>
          <div class="sptabs">
            {t.specs.map(s => {
              const isNew = s.key.endsWith('/ny');
              return (
                <button key={s.key} class={'sptab' + (sel?.key === s.key ? ' on' : '')} onClick={() => onSpec(s)}>
                  <span class="ell">{s.doc.title || (isNew ? 'Ny spesifikasjon' : s.file)}</span>
                  <span class="mono small omuted">{isNew ? 'utkast' : colName(colOf(s))}</span>
                </button>
              );
            })}
            {!ro && !t.specs.some(s => s.key.endsWith('/ny')) && (
              <button class="sptab add" onClick={onNewSpec}>
                + Ny spesifikasjon
              </button>
            )}
          </div>
          {!t.specs.length && <span class="omuted">Ingen spesifikasjoner ennå. Kjør fs-specify, eller lag en med «+ Ny spesifikasjon» når kravene er @planned.</span>}
        </section>

        {children}

        {task.log.length > 0 && (
          <section class="spd-sec">
            <div class="spd-sec-h">
              <span>Statuslogg</span>
              <span class="mono omuted">oppgave.md</span>
            </div>
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
          </section>
        )}
      </div>
    </aside>
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
