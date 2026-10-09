import { useEffect, useMemo, useRef, useState } from 'preact/hooks';
import { displayStatus, type Snapshot } from '../shared/model';
import type { SketchKind, SpecDoc } from '../shared/spec';
import { DOMAINS } from '../shared/tasks';
import { emptyStep, STEP_STATUSES, type SpecRun } from '../shared/utforing';
import { useClaudeTarget } from './claudeBridge';
import { shortPath, type MentionFilter } from './mention';
import { makeMentionIndex, mentionItems, searchMentions, type MentionHit, type MentionItem } from './search';
import { highlight, StatusIcon } from './Sidebar';
import { colOf, currentRepo, featureId, handoffPrompt, missing, pickable, prShort, specifyPrompt, stepIcon, verifyPrompt, type Card, type ColConf } from './specboard';
import { useCopy } from './useCopy';
import { useVerifyScreenshots } from './verifyScreenshots';

/** Handlingene som går til Claude Code utenfor panelets vanlige samtale */
export interface SpecActions {
  /** Utførekjøring i kode-repoet (Claude-panelet med cwd i repoet); `null` når den ikke er tilgjengelig */
  execute: ((c: Card, repo: string) => void) | null;
  /** Hvorfor «Utfør i …» ikke kan brukes */
  executeWhy: string;
  /** Kan repoet utføres i (Claude Code finnes, og den lokale klonen er valgt)? */
  canExecute: (repo: string) => boolean;
  /** «Utfør med team i <repo>»: terminalen med agent teams, i kode-repoet; `null` når den ikke er tilgjengelig */
  executeTeam: ((c: Card, repo: string) => void) | null;
  /** «Verifiser i terminal med agent team» (fs-verify-agent-teams); `null` når den ikke er tilgjengelig */
  verifyTeam: ((c: Card, screenshots: boolean) => void) | null;
}

interface Props {
  c: Card;
  col: ColConf;
  repos: string[];
  repoName: (r: string) => string;
  cards: Card[];
  entries: Snapshot;
  ro: boolean;
  dirty: boolean;
  me: string;
  onClose: () => void;
  onDoc: (fn: (d: SpecDoc) => void, log?: string) => void;
  onRun: (fn: (r: SpecRun) => void, log?: string) => void;
  onSend: () => void;
  onOpenKrav: (path: string) => void;
  actions: SpecActions;
}

const COL_WHY: Record<string, string> = {
  utkast: 'Fylles ut før den kan sendes.',
  klar: 'Komplett. Velg rute og send.',
  verifisering: 'Alle steg er levert.',
  verifisert: 'Kravene er @implemented, eller fs-verify fant alt.',
};
const RES_C: Record<string, string> = { funnet: 'var(--st-implemented)', 'ikke funnet': 'var(--err)', usikker: 'var(--st-in-progress)' };
const resMark = (r: string | null) => (r === 'funnet' ? 'omk omk--ok' : r === 'ikke funnet' ? 'omk omk--no' : r === 'usikker' ? 'omk sp-mk--us' : 'omk omk--na');
const SKETCH_C: Record<SketchKind, string> = { OK: 'var(--st-implemented)', Avvik: 'var(--err)', Uavklart: 'var(--st-in-progress)' };

/** En knapp som sender en prompt til Claude-panelet når det er åpent, og ellers kopierer den. Med `skill` starter den en ny samtale med skillen */
function ClaudeAction({ label, prompt, solid, skill }: { label: string; prompt: () => string; solid?: boolean; skill?: string }) {
  const claude = useClaudeTarget();
  const [copied, copy] = useCopy();
  return (
    <button
      class={'spbtn ' + (solid ? 'solid' : 'acc')}
      disabled={claude.ready && claude.busy}
      title={claude.ready ? (claude.busy ? 'Claude jobber i samtalen; vent til svaret er ferdig' : skill ? `Starter en ny samtale med ${skill} i Claude-panelet` : 'Sender prompten til samtalen i Claude-panelet') : 'Claude-panelet er lukket: prompten kopieres'}
      onClick={() => (claude.ready ? void (skill ? claude.withSkill(prompt(), skill) : claude.send(prompt())) : copy(prompt()))}
    >
      <span class="sp-dia" />
      {claude.ready ? label : copied ? 'Kopiert' : `${label} (kopier prompt)`}
    </button>
  );
}

/** Detaljpanelet (440 px) for kortet som er valgt. Alt kan redigeres, unntatt i statisk bygg. */
export function SpecDetail({ c, col, repos, repoName, cards, entries, ro, dirty, me, onClose, onDoc, onRun, onSend, onOpenKrav, actions }: Props) {
  const canEdit = !ro;
  const colKey = colOf(c);
  const cur = currentRepo(c);
  const [openFeat, setOpenFeat] = useState<Record<string, boolean>>({});
  const [promptFor, setPromptFor] = useState<string | null>(null);
  const [copied, copy] = useCopy();
  const [shots, setShots] = useVerifyScreenshots();
  /** Steget i repoet settes til «pågår», med agenten som har tatt det, og en linje i loggen */
  const startStep = (r: string, what: string) =>
    onRun(run => {
      const st = run.steps.find(x => x.repo === r);
      if (!st) return;
      st.status = 'pågår';
      if (!st.by) st.by = 'agent:' + (r === 'fs-admin' || r === 'min-kompetanse' ? 'frontend' : r === 'fs-plattform' ? 'subgraph' : 'utvikler');
    }, `startet ${what} i ${repoName(r)}`);
  const all = c.feats.flatMap(f => f.sc);
  const unsent = !c.run.route.length;
  const routeList = unsent ? c.doc.rute : c.run.route;
  const miss = missing(c);
  const q = c.doc.sporsmal.filter(x => !x.done).length;

  // Ruta før sending er forslaget i spec-dokumentet (## Rute); etter sending ruta i utforing.md
  const editRoute = (fn: (r: string[]) => string[], log?: string) =>
    unsent
      ? onDoc(d => {
          d.rute = fn([...d.rute]);
        })
      : onRun(r => {
          r.route = fn([...r.route]);
          r.steps = r.route.map(x => r.steps.find(s => s.repo === x) ?? emptyStep(x));
        }, log);

  return (
    <aside class="spdetail">
      <div class="spd">
        <div class="spd-path mono">
          <span class="ell">{c.path}</span>
          <button class="spbtn small" onClick={onClose}>
            Lukk ×
          </button>
        </div>

        <div class="spd-head">
          <input
            class="spd-title"
            value={c.doc.title}
            disabled={ro}
            placeholder="Tittel på spesifikasjonen"
            onChange={e => {
              const v = (e.target as HTMLInputElement).value;
              onDoc(d => {
                d.title = v;
              });
            }}
          />
          <div class="spd-col">
            <span class="ochip acc">
              <span class={col.key.startsWith('repo:') ? 'sp-ic sp-ic--repo' : ''} />
              {col.name}
            </span>
            <span class="omuted">{cur ? 'Første steg som ikke er levert.' : COL_WHY[colKey]}</span>
          </div>
        </div>

        {dirty && (
          <div class="spd-dirty">
            <span class="dot" />
            <span>{c.key === 'ny' ? 'Skrives til disk når spesifikasjonen har tittel og første krav.' : 'Endret lokalt. Kommer med i neste «Lag PR» og gjelder først når den er på main.'}</span>
          </div>
        )}

        {colKey === 'utkast' && (
          <div class="spd-box">
            <div class="spd-box-h">Mangler før Klart til utvikling</div>
            {miss.map(m => (
              <div key={m} class="spd-miss">
                <span class="omk omk--no" />
                <span>{m}</span>
              </div>
            ))}
            {canEdit && c.key !== 'ny' && (
              <div class="spd-box-f">
                <ClaudeAction label={`Kjør ${c.doc.delta ? 'fs-specify-delta' : 'fs-specify'}`} prompt={() => specifyPrompt(c)} />
              </div>
            )}
          </div>
        )}

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Omfang</span>
            <span class="mono omuted">## Omfang</span>
          </div>
          <textarea
            rows={4}
            disabled={ro}
            value={c.doc.omfang}
            placeholder="2–5 setninger om hva spesifikasjonen dekker og ikke dekker"
            onChange={e => {
              const v = (e.target as HTMLTextAreaElement).value;
              onDoc(d => {
                d.omfang = v;
              });
            }}
          />
        </section>

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Feature-filer</span>
            <span class="mono omuted">
              {c.feats.length} filer · {all.length} scenarioer
            </span>
          </div>
          {c.feats.map((f, i) => {
            const key = f.id || f.file;
            const open = !!openFeat[key];
            const okN = f.sc.filter(x => x.r === 'funnet').length;
            const has = f.sc.some(x => x.r);
            const st = f.path ? displayStatus(entries[f.path] ?? { status: null }) : null;
            return (
              <div key={key} class={'spfeat' + (open ? ' open' : '')}>
                <div class="spfeat-h" onClick={() => setOpenFeat(o => ({ ...o, [key]: !open }))}>
                  {st ? <StatusIcon s={st} /> : <span class="omk omk--no" title="Finnes ikke under krav/" />}
                  <div class="spfeat-t">
                    <span class="mono ell">{f.file}</span>
                    <span class="mono omuted small">
                      {f.id} · {f.status ? '@' + f.status : f.remove ? 'slettet' : 'finnes ikke'}
                      {f.remove && ' · skal fjernes'}
                    </span>
                  </div>
                  <span class="mono small" style={{ color: has && okN < f.sc.length ? 'var(--err)' : has ? 'var(--st-implemented)' : 'var(--muted)' }}>
                    {has ? `${okN}/${f.sc.length} funnet` : `${f.sc.length} scen.`}
                  </span>
                  <span class={'spchev' + (open ? ' up' : '')} />
                  {canEdit && (
                    <button
                      class="spx"
                      title="Fjern koblingen til feature-filen"
                      onClick={e => {
                        e.stopPropagation();
                        onDoc(d => {
                          d.krav.splice(i, 1);
                        }, `fjernet ${f.file}`);
                      }}
                    >
                      ×
                    </button>
                  )}
                </div>
                {open && (
                  <div class="spfeat-sc">
                    {f.path && (
                      <a
                        href={'#/' + encodeURI(f.path)}
                        class="small"
                        onClick={e => {
                          e.preventDefault();
                          onOpenKrav(f.path!);
                        }}
                      >
                        Åpne kravet
                      </a>
                    )}
                    {f.sc.map(s => (
                      <div key={s.t} class="spsc" title={s.bevis || undefined}>
                        <span class={resMark(s.r)} />
                        <span>
                          {s.t}
                          {s.remove && <span class="omuted"> (fjernes)</span>}
                        </span>
                        <span class="mono small" style={{ color: s.r ? RES_C[s.r] : 'var(--muted)' }}>
                          {s.r ?? 'ikke verifisert'}
                        </span>
                      </div>
                    ))}
                    {!f.sc.length && <span class="omuted small">Ingen scenarioer å implementere.</span>}
                  </div>
                )}
              </div>
            );
          })}
          {!c.feats.length && <span class="omuted">Ingen krav ennå. Legg til feature-filene spesifikasjonen skal dekke. Domenet settes fra det første kravet.</span>}
          {canEdit && <KravPicker c={c} cards={cards} entries={entries} onAdd={(refs, log) => onDoc(d => d.krav.push(...refs), log)} />}
        </section>

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Skisser</span>
            <span class="mono omuted">## Skisser</span>
          </div>
          {c.doc.skisser.map((k, i) => (
            <div key={i} class="spsketch">
              <div class="spsketch-thumb">
                <span class="mono">screenshot</span>
              </div>
              <div class="spsketch-b">
                <div class="spsketch-row">
                  <input
                    class="spinl strong"
                    value={k.name}
                    disabled={ro}
                    onChange={e => {
                      const v = (e.target as HTMLInputElement).value;
                      onDoc(d => {
                        d.skisser[i].name = v;
                      });
                    }}
                  />
                  {canEdit && (
                    <button class="spx" title="Fjern skisse" onClick={() => onDoc(d => void d.skisser.splice(i, 1))}>
                      ×
                    </button>
                  )}
                </div>
                <div class="spsketch-row">
                  <input
                    class="spinl mono acc"
                    value={k.url}
                    disabled={ro}
                    placeholder="https://www.figma.com/design/…"
                    onChange={e => {
                      const v = (e.target as HTMLInputElement).value.trim();
                      onDoc(d => {
                        d.skisser[i].url = v;
                      });
                    }}
                  />
                  {k.url && (
                    <a href={k.url} target="_blank" rel="noreferrer" class="small">
                      ↗
                    </a>
                  )}
                </div>
                <div class="spsketch-row">
                  <select
                    value={k.kind}
                    disabled={ro}
                    style={{ color: SKETCH_C[k.kind], borderColor: SKETCH_C[k.kind] }}
                    onChange={e => {
                      const v = (e.target as HTMLSelectElement).value as SketchKind;
                      onDoc(d => {
                        d.skisser[i].kind = v;
                      });
                    }}
                  >
                    <option value="OK">OK</option>
                    <option value="Avvik">Avvik</option>
                    <option value="Uavklart">Uavklart</option>
                  </select>
                  {k.kind !== 'OK' && (
                    <input
                      class="spinl"
                      value={k.note}
                      disabled={ro}
                      placeholder="Hva avviker?"
                      onChange={e => {
                        const v = (e.target as HTMLInputElement).value;
                        onDoc(d => {
                          d.skisser[i].note = v;
                        });
                      }}
                    />
                  )}
                </div>
                <div class="spsketch-row">
                  <span class="mono omuted small">dekker</span>
                  <input
                    class="spinl mono small"
                    value={k.dekker}
                    disabled={ro}
                    placeholder="ingen krav valgt"
                    onChange={e => {
                      const v = (e.target as HTMLInputElement).value;
                      onDoc(d => {
                        d.skisser[i].dekker = v;
                      });
                    }}
                  />
                </div>
              </div>
            </div>
          ))}
          {!c.doc.skisser.length &&
            (c.doc.ingenSkisse !== null ? (
              <div class="spsketch-row">
                <span class="omuted">Ingen skisse:</span>
                <input
                  class="spinl"
                  value={c.doc.ingenSkisse}
                  disabled={ro}
                  placeholder="grunn"
                  onChange={e => {
                    const v = (e.target as HTMLInputElement).value;
                    onDoc(d => {
                      d.ingenSkisse = v;
                    });
                  }}
                />
                {canEdit && (
                  <button class="spx" onClick={() => onDoc(d => void (d.ingenSkisse = null))}>
                    ×
                  </button>
                )}
              </div>
            ) : (
              <span class="omuted">Ingen skisse. Klart til utvikling krever minst én, eller «Ingen skisse: grunn».</span>
            ))}
          {canEdit && (
            <div class="sprow-btns">
              <button class="spbtn dashed" onClick={() => onDoc(d => void d.skisser.push({ name: 'Ny skisse', url: '', kind: 'Uavklart', note: '', dekker: '', fields: [] }))}>
                + Legg til skisse
              </button>
              {!c.doc.skisser.length && c.doc.ingenSkisse === null && (
                <button class="spbtn dashed" onClick={() => onDoc(d => void (d.ingenSkisse = ''))}>
                  Ingen skisse
                </button>
              )}
            </div>
          )}
        </section>

        <section class="spd-sec tight">
          <div class="spd-sec-h">
            <span>Åpne spørsmål</span>
            <span class="mono omuted">{q} åpne</span>
          </div>
          {c.doc.sporsmal.map((x, i) => (
            <div key={i} class="spq">
              <button class={'spchk' + (x.done ? ' on' : '')} disabled={ro} onClick={() => onDoc(d => void (d.sporsmal[i].done = !x.done))}>
                {x.done ? '✓' : ''}
              </button>
              <input
                class={'spinl' + (x.done ? ' done' : '')}
                value={x.t}
                disabled={ro}
                onChange={e => {
                  const v = (e.target as HTMLInputElement).value;
                  onDoc(d => void (d.sporsmal[i].t = v));
                }}
              />
              {canEdit && (
                <button class="spx" onClick={() => onDoc(d => void d.sporsmal.splice(i, 1))}>
                  ×
                </button>
              )}
            </div>
          ))}
          {canEdit && (
            <input
              class="spadd"
              placeholder="+ Nytt spørsmål (Enter)"
              onKeyDown={e => {
                const el = e.target as HTMLInputElement;
                const v = el.value.trim();
                if (e.key !== 'Enter' || !v) return;
                el.value = '';
                onDoc(d => void d.sporsmal.push({ t: v, done: false }));
              }}
            />
          )}
        </section>

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Rute</span>
            <span class="mono omuted">{unsent ? '## Rute (forslag)' : 'utforing.md'}</span>
          </div>
          <div class="sproute-edit">
            {routeList.map((r, i) => (
              <span key={r} class="sproute-i">
                {i > 0 && <span class="omuted">→</span>}
                <span class="sproute-pill mono">
                  <span class={stepIcon(c.run.steps.find(s => s.repo === r)?.status)} />
                  <span>{repoName(r)}</span>
                  {canEdit && (
                    <>
                      <button title="Tidligere" style={{ opacity: i > 0 ? 1 : 0.3 }} onClick={() => i > 0 && editRoute(a => ([a[i - 1], a[i]] = [a[i], a[i - 1]]) && a)}>
                        ‹
                      </button>
                      <button title="Senere" style={{ opacity: i < routeList.length - 1 ? 1 : 0.3 }} onClick={() => i < routeList.length - 1 && editRoute(a => ([a[i + 1], a[i]] = [a[i], a[i + 1]]) && a)}>
                        ›
                      </button>
                      <button title="Fjern fra ruta" class="del" onClick={() => editRoute(a => a.filter(x => x !== r), `${repoName(r)} fjernet fra ruta`)}>
                        ×
                      </button>
                    </>
                  )}
                </span>
              </span>
            ))}
            {canEdit && repos.some(r => !routeList.includes(r)) && (
              <select
                class="spaddrepo"
                value=""
                onChange={e => {
                  const v = (e.target as HTMLSelectElement).value;
                  if (v) editRoute(a => [...a, v], `${repoName(v)} lagt til i ruta`);
                }}
              >
                <option value="">+ repo</option>
                {repos
                  .filter(r => !routeList.includes(r))
                  .map(r => (
                    <option key={r} value={r}>
                      {repoName(r)}
                    </option>
                  ))}
              </select>
            )}
          </div>
          {unsent && (
            <div class="spd-send">
              <span>
                {colKey === 'utkast'
                  ? 'Ruta kan settes nå, men spesifikasjonen sendes først når den er komplett.'
                  : routeList.length
                    ? 'Forslag fra spec-dokumentet. Endre rekkefølgen over og send.'
                    : 'Legg til minst ett repo og send.'}
              </span>
              {canEdit && colKey === 'klar' && routeList.length > 0 && (
                <button class="spbtn solid" onClick={onSend}>
                  Sett rute og send
                </button>
              )}
            </div>
          )}
        </section>

        {!unsent && (
          <section class="spd-sec">
            <span class="spd-sec-h">
              <span>Steg</span>
            </span>
            {c.run.route.map((r, i) => {
              const s = c.run.steps.find(x => x.repo === r) ?? emptyStep(r);
              const isCur = r === cur;
              const other = !!s.by && s.by !== me && !s.by.startsWith('agent:');
              const back = s.back ? all.filter(a => a.r && a.r !== 'funnet') : [];
              const pk = r;
              return (
                <div key={r} class={'spstepbox' + (isCur ? ' cur' : '')}>
                  <div class="spstepbox-h">
                    <span class="mono omuted small">
                      {i + 1}/{c.run.route.length}
                    </span>
                    <span class={stepIcon(s.status)} />
                    <span class="mono strong">{repoName(r)}</span>
                    {isCur && <span class="sptag acc">gjeldende</span>}
                    <div class="spseg">
                      {STEP_STATUSES.map(t => (
                        <button
                          key={t}
                          disabled={ro}
                          class={s.status === t ? 'on ' + (t === 'levert' ? 'ok' : t === 'pågår' ? 'wip' : 'wait') : ''}
                          onClick={() =>
                            s.status !== t &&
                            onRun(run => {
                              const st = run.steps.find(x => x.repo === r) ?? (run.steps.push(emptyStep(r)), run.steps[run.steps.length - 1]);
                              st.status = t;
                              if (t !== 'pågår') st.back = null;
                            }, `${repoName(r)}: ${t}`)
                          }
                        >
                          {t}
                        </button>
                      ))}
                    </div>
                  </div>
                  <div class="spstepbox-b">
                    <span class="omuted">Tatt av</span>
                    <div class="spcolm">
                      <input
                        class="spinl mono"
                        value={s.by}
                        disabled={ro}
                        placeholder="@person eller agent:rolle"
                        onChange={e => {
                          const v = (e.target as HTMLInputElement).value.trim();
                          onRun(run => {
                            const st = run.steps.find(x => x.repo === r);
                            if (st) st.by = v;
                          }, v ? `${v} tok ${repoName(r)}` : undefined);
                        }}
                      />
                      {other && <span class="spwarn">{s.by} har steget. Endrer du det, overstyrer du dem når PR-en merges.</span>}
                    </div>
                    <span class="omuted">PR</span>
                    <div class="spcolm">
                      {s.pr.map((p, k) => (
                        <div key={p} class="sprow">
                          <a href={p} target="_blank" rel="noreferrer" class="mono ell">
                            {prShort(p)} ↗
                          </a>
                          {canEdit && (
                            <button
                              class="spx"
                              onClick={() =>
                                onRun(run => {
                                  run.steps.find(x => x.repo === r)?.pr.splice(k, 1);
                                })
                              }
                            >
                              ×
                            </button>
                          )}
                        </div>
                      ))}
                      {canEdit && (
                        <input
                          class="spadd mono"
                          placeholder="+ Legg til PR-lenke (Enter)"
                          onKeyDown={e => {
                            const el = e.target as HTMLInputElement;
                            const v = el.value.trim();
                            if (e.key !== 'Enter' || !v) return;
                            el.value = '';
                            onRun(run => void run.steps.find(x => x.repo === r)?.pr.push(v), `la til PR ${prShort(v)}`);
                          }}
                        />
                      )}
                      {s.status === 'levert' && !s.pr.length && <span class="errc small">levert krever PR</span>}
                    </div>
                    <span class="omuted">Overlevering</span>
                    <textarea
                      class="mono"
                      rows={Math.max(2, s.handoff.split('\n').length)}
                      value={s.handoff}
                      disabled={ro}
                      placeholder="Nye felt, queries og mutations, endepunkter, kjente avvik"
                      onChange={e => {
                        const v = (e.target as HTMLTextAreaElement).value;
                        onRun(run => {
                          const st = run.steps.find(x => x.repo === r);
                          if (st) st.handoff = v;
                        });
                      }}
                    />
                    <span class="omuted">Blokkert</span>
                    <div class="sprow">
                      <button
                        class={'sptoggle' + (s.blocked !== null ? ' on' : '')}
                        disabled={ro}
                        aria-pressed={s.blocked !== null}
                        onClick={() =>
                          onRun(run => {
                            const st = run.steps.find(x => x.repo === r);
                            if (st) st.blocked = st.blocked === null ? 'uten grunn' : null;
                          }, s.blocked !== null ? `${repoName(r)}: blokkering fjernet` : `${repoName(r)}: blokkert`)
                        }
                      >
                        <span />
                      </button>
                      {s.blocked !== null && (
                        <input
                          class="spinl spblock"
                          value={s.blocked === 'uten grunn' ? '' : s.blocked}
                          disabled={ro}
                          placeholder="Grunn"
                          onChange={e => {
                            const v = (e.target as HTMLInputElement).value.trim();
                            onRun(run => {
                              const st = run.steps.find(x => x.repo === r);
                              if (st) st.blocked = v || 'uten grunn';
                            });
                          }}
                        />
                      )}
                    </div>
                  </div>
                  {back.length > 0 && (
                    <div class="spback">
                      <span class="strong">Sendt tilbake av fs-verify · {s.back}</span>
                      {back.map(b => (
                        <div key={b.t} class="spsc" title={b.bevis || undefined}>
                          <span class={resMark(b.r)} />
                          <span>{b.t}</span>
                          <span class="mono small" style={{ color: RES_C[b.r!] }}>
                            {b.r}
                          </span>
                        </div>
                      ))}
                    </div>
                  )}
                  {isCur && canEdit && (
                    <div class="sprow-btns pad">
                      <button
                        class="spbtn solid"
                        disabled={s.blocked !== null || !actions.execute || !actions.canExecute(r)}
                        title={s.blocked !== null ? 'Steget er blokkert' : actions.execute && actions.canExecute(r) ? `Utførekjøring i Claude-panelet, cwd = ${repoName(r)}` : actions.executeWhy}
                        onClick={() => {
                          if (!actions.execute || !actions.canExecute(r) || s.blocked !== null) return;
                          startStep(r, 'utførekjøring');
                          actions.execute(c, r);
                        }}
                      >
                        <span class="sp-dia light" />
                        Utfør i {repoName(r)}
                      </button>
                      {actions.executeTeam && (
                        <button
                          class="spbtn acc"
                          disabled={s.blocked !== null || !actions.canExecute(r)}
                          title={s.blocked !== null ? 'Steget er blokkert' : actions.canExecute(r) ? `Interaktiv Claude Code med agent teams i en terminal i Claude-panelet, cwd = ${repoName(r)}` : actions.executeWhy}
                          onClick={() => {
                            if (!actions.executeTeam || !actions.canExecute(r) || s.blocked !== null) return;
                            startStep(r, 'utførekjøring med agent team');
                            actions.executeTeam(c, r);
                          }}
                        >
                          Utfør med team
                        </button>
                      )}
                      <button class="spbtn acc" onClick={() => setPromptFor(promptFor === pk ? null : pk)}>
                        {promptFor === pk ? 'Skjul prompt' : `Kopier prompt til ${repoName(r)}`}
                      </button>
                    </div>
                  )}
                  {promptFor === pk && (
                    <div class="spprompt">
                      <div class="spprompt-h">
                        Handoff-prompt · ekstern Claude Code-økt i {repoName(r)}
                        <button class={'spbtn small ' + (copied ? 'solid' : 'acc')} onClick={() => copy(handoffPrompt(c, r))}>
                          {copied ? 'Kopiert' : 'Kopier'}
                        </button>
                      </div>
                      <pre>{handoffPrompt(c, r)}</pre>
                    </div>
                  )}
                </div>
              );
            })}
          </section>
        )}

        {colKey === 'verifisering' && canEdit && (
          <div class="spd-send">
            <span>Alle steg er levert. fs-verify kjøres avgrenset til denne spesifikasjonen, med de valgte kodemappene.</span>
            <label class="spd-check">
              <input type="checkbox" checked={shots} onChange={e => setShots((e.currentTarget as HTMLInputElement).checked)} />
              Ta skjermbilder (test-fsadmin)
            </label>
            <ClaudeAction label="Verifiser" prompt={() => verifyPrompt(c, shots)} skill="fs-verify" solid />
            {actions.verifyTeam && (
              <button class="spbtn acc" title="fs-verify-agent-teams i en terminal i Claude-panelet: én teammate per feature-fil" onClick={() => actions.verifyTeam?.(c, shots)}>
                Verifiser i terminal med agent team
              </button>
            )}
          </div>
        )}

        <section class="spd-sec">
          <div class="spd-sec-h">
            <span>Logg</span>
            <span class="mono omuted">append-only</span>
          </div>
          <div class="splog mono">
            {c.run.log.map((e, i) => (
              <div key={i}>
                <span class="omuted">{e.d}</span>
                <span>
                  {e.who} — {e.t}
                </span>
              </div>
            ))}
            {!c.run.log.length && <span class="omuted">Ingen hendelser ennå.</span>}
          </div>
        </section>
      </div>
    </aside>
  );
}

// —— «+ Legg til krav» ——

const FILTERS: [string, MentionFilter][] = [['Alle', 'all'], ['Mapper', 'dir'], ['Filer', 'file']];

interface PickerProps {
  c: Card;
  cards: Card[];
  entries: Snapshot;
  onAdd: (refs: SpecDoc['krav'], log: string) => void;
}

/**
 * Velgeren for krav: søk etter fil eller mappe i krav/ (samme Fuse-søk som treet og @ i Claude-panelet).
 * Hele krav plukkes, aldri enkeltscenarioer. En mappe legger til alle feature-filene under den som kan plukkes.
 */
function KravPicker({ c, cards, entries, onAdd }: PickerProps) {
  const items = useMemo(() => {
    const all = mentionItems(entries);
    return new Map([...all].filter(([p, i]) => p.startsWith('krav/') && (i.dir || i.entry?.kind === 'feature')));
  }, [entries]);
  const index = useMemo(() => makeMentionIndex(items), [items]);
  const [q, setQ] = useState('');
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(0);
  const [marked, setMarked] = useState<string[]>([]);
  const [filter, setFilter] = useState<MentionFilter>('all');
  const box = useRef<HTMLDivElement>(null);

  // Hvilken spesifikasjon hvert krav allerede er i (på Feature-ID)
  const taken = useMemo(() => {
    const m = new Map<string, Card>();
    for (const x of cards) for (const f of x.feats) if (f.id) m.set(f.id, x);
    return m;
  }, [cards]);
  const leaves = (it: MentionItem) => (it.dir ? [...items.values()].filter(i => !i.dir && i.path.startsWith(it.path + '/')) : [it]);
  const free = (it: MentionItem) => leaves(it).filter(l => l.entry && pickable(l.entry).ok && !taken.has(featureId(l.entry) ?? ''));

  const query = q.trim();
  const found: MentionHit[] = useMemo(() => {
    if (query) return searchMentions(index, items, query);
    // Uten søk: domenet til spesifikasjonen og sub-domenene i det, ellers domenene
    const top = c.dom && DOMAINS[c.dom] ? items.get(`krav/${DOMAINS[c.dom]}`) : undefined;
    const list = top ? [top, ...[...items.values()].filter(i => i.dir && i.parent === top.path)] : [...items.values()].filter(i => i.dir && i.depth === 1);
    return list.map(item => ({ item, ranges: [] }));
  }, [query, index, items, c.dom]);
  const ranges = new Map(found.map(h => [h.item.path, h.ranges]));
  const hits = found.map(h => h.item);
  const all = filter === 'all';
  const dA = filter === 'file' ? [] : hits.filter(i => i.dir);
  const fA = filter === 'dir' ? [] : hits.filter(i => !i.dir);
  const dirs = dA.slice(0, all ? 5 : 14);
  const files = fA.slice(0, all ? 7 : 14);
  const flat = [...dirs, ...files];

  useEffect(() => {
    box.current?.querySelector('.cmrow.act')?.scrollIntoView({ block: 'nearest' });
  }, [active, flat.length]);

  const commit = (paths: string[]) => {
    const feats = [...new Set(paths.flatMap(p => free(items.get(p)!).map(l => l.path)))].map(p => entries[p]);
    if (!feats.length) return;
    const refs = feats.map(e => ({ file: e.path.slice(e.path.lastIndexOf('/') + 1), id: featureId(e) ?? '', path: e.path, remove: e.status === 'deprecated' }));
    const dirsN = paths.filter(p => items.get(p)?.dir);
    const log = refs.length === 1 && !dirsN.length ? `la til ${refs[0].file}` : `la til ${refs.length} feature-filer${dirsN.length === 1 && paths.length === 1 ? ' fra ' + items.get(dirsN[0])!.name + '/' : ''}`;
    onAdd(refs, log);
    setMarked([]);
    setQ('');
  };
  const toggle = (p: string) => setMarked(m => (m.includes(p) ? m.filter(x => x !== p) : [...m, p]));
  const nMarked = new Set(marked.flatMap(p => free(items.get(p)!).map(l => l.path))).size;

  let n = 0;
  const row = (it: MentionItem) => {
    const i = n++;
    const nf = free(it).length;
    const ok = nf > 0;
    const mk = marked.includes(it.path);
    const e = it.entry;
    const owner = !it.dir && e ? taken.get(featureId(e) ?? '') : undefined;
    const pk = !it.dir && e ? pickable(e) : null;
    const meta = it.dir
      ? ok
        ? `${nf} feature`
        : leaves(it).some(l => l.entry && taken.get(featureId(l.entry) ?? '') === c)
          ? 'lagt til'
          : 'ingen å plukke'
      : owner
        ? owner === c || owner.key === c.key
          ? 'lagt til'
          : 'i ' + (owner.doc.title || 'annen spec')
        : pk && !pk.ok
          ? pk.why
          : (pk?.why ?? '');
    const range = ranges.get(it.path) ?? [];
    return (
      <div
        key={it.path}
        class={'cmrow' + (i === active && ok ? ' act' : '')}
        style={{ opacity: ok ? 1 : 0.45, cursor: ok ? 'pointer' : 'default' }}
        title={it.path}
        onMouseEnter={() => i !== active && setActive(i)}
        onClick={() => ok && commit([...new Set([...marked, it.path])])}
      >
        <span
          class={'cmchk' + (mk ? ' on' : '')}
          style={{ opacity: ok ? undefined : 0 }}
          onClick={ev => {
            ev.stopPropagation();
            if (ok) toggle(it.path);
          }}
        >
          {mk ? '✓' : ''}
        </span>
        {it.dir ? <span class="cm-dir" aria-hidden="true" /> : <StatusIcon s={displayStatus(e!)} />}
        <span class="cmname">
          {highlight(it.name, range)}
          {it.dir && '/'}
        </span>
        <span class="cmsub mono">{shortPath(it.parent)}</span>
        <span class="cmmeta mono">{meta}</span>
      </div>
    );
  };

  return (
    <div class="sppick">
      <input
        class="sppick-in"
        value={q}
        placeholder="+ Legg til krav: søk etter fil eller mappe"
        onInput={e => {
          setQ((e.target as HTMLInputElement).value);
          setOpen(true);
          setActive(0);
        }}
        onFocus={() => setOpen(true)}
        onBlur={() => setOpen(false)}
        onKeyDown={e => {
          const len = Math.max(flat.length, 1);
          const cur = flat[active];
          if (e.key === 'ArrowDown') setActive(a => (a + 1) % len);
          else if (e.key === 'ArrowUp') setActive(a => (a - 1 + len) % len);
          else if (e.key === 'Escape') setOpen(false);
          else if (e.key === 'Tab' && open) {
            if (cur && free(cur).length) toggle(cur.path);
          } else if (e.key === 'Enter') {
            const ps = marked.length ? marked : cur && free(cur).length ? [cur.path] : [];
            if (ps.length) commit(ps);
          } else return;
          e.preventDefault();
        }}
      />
      {open && (
        <div class="cmention sppick-pop" onMouseDown={e => e.preventDefault()}>
          <div class="cmhead">
            <span class="omuted">{query ? `${flat.length} treff` : 'Velg en mappe for å legge til alle feature-filene i den'}</span>
            <div class="cmfilter">
              {FILTERS.map(([label, f]) => (
                <button
                  key={f}
                  aria-pressed={filter === f}
                  onClick={() => {
                    setFilter(f);
                    setActive(0);
                  }}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>
          <div class="cmlist" ref={box}>
            {query && !flat.length && <div class="cmempty">Ingen treff for «{query}»</div>}
            {dirs.length > 0 && <div class="cmsec mono">{query ? 'Mapper' : 'Foreslått · mapper'}</div>}
            {dirs.map(row)}
            {dA.length > dirs.length && <div class="cmmore">+ {dA.length - dirs.length} flere mapper</div>}
            {files.length > 0 && <div class="cmsec mono">Filer</div>}
            {files.map(row)}
            {fA.length > files.length && <div class="cmmore">+ {fA.length - files.length} flere filer</div>}
          </div>
          <div class="cmfoot">
            <span class={marked.length ? 'acc' : ''}>{marked.length ? `${marked.length} merket · ${nMarked} feature-filer · ↵ legger til` : 'Mappe legger til alle feature-filer under den'}</span>
            <span class="mono">↑↓ · Tab merk · ↵ legg til · Esc</span>
          </div>
        </div>
      )}
    </div>
  );
}
