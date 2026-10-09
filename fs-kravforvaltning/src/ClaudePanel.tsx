import { useEffect, useRef, useState } from 'preact/hooks';
import { CLAUDE_SKILLS_SHOWN, type ClaudeEvent, type ClaudeStatus, type ExecuteTarget, type PtyStartRequest } from '../shared/api';
import type { GitChange, Snapshot } from '../shared/model';
import { isEditablePath } from '../shared/paths';
import {
  applyEvent,
  contextLabel,
  chooseSkill,
  effectiveSkill,
  createConversation,
  createExecuteConversation,
  currentChat,
  EMPTY_CHAT,
  removeConversation,
  restoreConversations,
  selectConversation,
  editedFiles,
  send,
  staleSkills,
  started,
  toolLabel,
  allowAlways,
  needsAuth,
  pendingPermissions,
  pendingQuestions,
  createTerminalConversation,
  terminalExited,
  updateConversation,
  type ChatItem,
  type ChatPreset,
  type Conversations,
} from './claudeChat';
import { PR_PROMPT, PR_PROMPT_SHORT, type PrProposal } from './prProposal';
import { ChatMarkdown } from './ChatMarkdown';
import { registerClaude, setClaudeBusy } from './claudeBridge';
import { CodeDirs, codeDirPaths, useCodeDirs } from './CodeDirs';
import { knownSkills, refreshSkills, skillChangedAt, SkillPicker, skillHashes, useSkillHashes } from './ClaudeSkills';
import { SUMMARY_PROMPT, SUMMARY_PROMPT_SHORT, summaryDraft, summaryIn, summaryMentions, type ChatSummary } from './chatSummary';
import { readDraft, saveDraft } from './claudeDraft';
import { appendQuote } from './selection';
import { covered } from './mention';
import { MENTION_LIST_ID, MentionPicker, useMentions } from './MentionPicker';
import { transport } from './transport';
import { answerQuestion, QuestionCard } from './QuestionCard';
import { TerminalView } from './TerminalView';
import { ResizeHandle } from './ResizeHandle';

/** Slik vises de faste meldingene i samtalen */
const PRESET: Record<ChatPreset, { label: string; text: string }> = {
  summary: { label: 'Oppsummer samtalen', text: SUMMARY_PROMPT_SHORT },
  pr: { label: 'Lag forslag til PR', text: PR_PROMPT_SHORT },
};

// Samtalene lever utenfor komponenten og lagres i localStorage, så de blir stående når panelet lukkes,
// visningen byttes eller vieweren lastes inn på nytt. Claude Code husker selve samtalene (`--resume`).
const KEY = 'kravforvaltning:claudeChats';
const read = (): unknown => {
  try {
    return JSON.parse(localStorage.getItem(KEY) ?? 'null');
  } catch {
    return null;
  }
};
let saveTimer: ReturnType<typeof setTimeout> | undefined;
const persist = () => {
  clearTimeout(saveTimer);
  saveTimer = setTimeout(() => {
    try {
      localStorage.setItem(KEY, JSON.stringify(convs));
    } catch {
      /* full eller utilgjengelig lagring: samtalene lever videre i minnet */
    }
  }, 300);
};

// Til backenden har svart på hvilke kjøringer som pågår, regnes alle lagrede kjøringer som i gang
const stored = read();
const storedRuns = ((stored as Conversations | null)?.list ?? []).map(c => c?.chat?.runId).filter((r): r is string => !!r);
let convs: Conversations = restoreConversations(stored, storedRuns);
const listeners = new Set<() => void>();
const set = (next: Conversations) => {
  if (next === convs) return;
  convs = next;
  persist();
  listeners.forEach(l => l());
};
if (transport.kind !== 'static') {
  transport
    .call('claudeActive')
    .then(active => {
      set(restoreConversations(convs, active));
      // Spørsmål om lov som venter i backenden, får kortet tilbake etter en omlasting
      return transport.call('claudePending');
    })
    .then(list => {
      for (const { runId, event } of list) {
        const next = applyEvent(convs, runId, event, Date.now(), skillHashes());
        if (next) set(next);
      }
    }, () => {});
}

/** Svarer på et spørsmål om lov. «Tillat alltid» lagres på samtalen, så verktøyet tillates også i de neste meldingene. */
function answerPermission(convId: string, item: Extract<ChatItem, { kind: 'permission' }>, behavior: 'allow' | 'deny', always = false, reason: 'user' | 'closed' = 'user') {
  if (always) set(updateConversation(convs, convId, ch => allowAlways(ch, item.tool), Date.now()));
  return transport.call('claudeApprove', { id: item.id, behavior, always, reason }).catch(() => false);
}

/** Panelet lukkes: spørsmålene som venter, avvises, så Claude ikke venter til tiden går ut */
function denyAllPending() {
  for (const conv of convs.list) {
    for (const p of pendingPermissions(conv.chat)) void answerPermission(conv.id, p, 'deny', false, 'closed');
    for (const q of pendingQuestions(conv.chat)) void answerQuestion(q, null, 'closed');
  }
}

const PERMISSION_STATE: Record<Exclude<Extract<ChatItem, { kind: 'permission' }>['state'], 'pending'>, string> = {
  allowed: 'Tillatt',
  denied: 'Avvist',
  timeout: 'Avvist: ingen svar innen 5 minutter',
  closed: 'Avvist: panelet ble lukket',
  ended: 'Avvist: kjøringen ble avsluttet',
};

/** Kortet «Claude vil bruke <verktøy>», med parametrene og «Tillat», «Tillat alltid i denne samtalen» og «Avvis» */
function PermissionCard({ convId, item }: { convId: string; item: Extract<ChatItem, { kind: 'permission' }> }) {
  const params = Object.entries(item.input);
  const pending = item.state === 'pending';
  return (
    <div class={'cperm' + (pending ? '' : ' answered ' + item.state)} role={pending ? 'alertdialog' : undefined} aria-label={`Claude vil bruke ${toolLabel(item.tool)}`}>
      <div class="cperm-head">
        Claude vil bruke <b>{toolLabel(item.tool)}</b>
        <span class="mono muted cperm-tool">{item.tool}</span>
      </div>
      {params.length > 0 && (
        <dl class="cperm-params mono">
          {params.map(([k, v]) => (
            <div key={k}>
              <dt>{k}</dt>
              <dd title={v}>{v}</dd>
            </div>
          ))}
        </dl>
      )}
      {pending ? (
        <div class="cperm-btns">
          <button class="primbtn" onClick={() => void answerPermission(convId, item, 'allow')}>Tillat</button>
          <button class="smallbtn" onClick={() => void answerPermission(convId, item, 'allow', true)}>Tillat alltid i denne samtalen</button>
          <button class="smallbtn" onClick={() => void answerPermission(convId, item, 'deny')}>Avvis</button>
        </div>
      ) : (
        <div class="cperm-state muted">{item.state !== 'pending' && PERMISSION_STATE[item.state]}</div>
      )}
    </div>
  );
}
addEventListener('beforeunload', () => {
  clearTimeout(saveTimer);
  try {
    localStorage.setItem(KEY, JSON.stringify(convs));
  } catch {
    /* ignorer */
  }
});

// Hendelser som kommer før svaret på `claudeRun` (med runId) er framme, spilles av når det kommer
const early = new Map<string, ClaudeEvent[]>();
transport.on('krav:claude', ({ runId, event }: { runId: string; event: ClaudeEvent }) => {
  const next = applyEvent(convs, runId, event, Date.now(), skillHashes());
  if (next) set(next);
  else early.set(runId, [...(early.get(runId) ?? []), event]);
});

function useConversations() {
  const [, force] = useState(0);
  useEffect(() => {
    const l = () => force(n => n + 1);
    listeners.add(l);
    return () => void listeners.delete(l);
  }, []);
  return convs;
}

const newId = () => Date.now().toString(36) + Math.random().toString(36).slice(2, 6);

/** «i dag 14:05», «i går 09:12» eller «3. okt.» */
function when(ms: number) {
  const d = new Date(ms);
  const day = (x: Date) => x.toDateString();
  const time = d.toLocaleTimeString('nb', { hour: '2-digit', minute: '2-digit' });
  if (day(d) === day(new Date())) return `i dag ${time}`;
  if (day(d) === day(new Date(Date.now() - 864e5))) return `i går ${time}`;
  return d.toLocaleDateString('nb', { day: 'numeric', month: 'short' });
}

/** Standardbredden på panelet, og grensene når det dras */
export const CLAUDE_WIDTH = 380;
const MIN_WIDTH = 280;
const maxWidth = () => Math.max(MIN_WIDTH, Math.round(innerWidth * 0.7));

/** Lange meldinger (f.eks. en prompt fra Avvik) foldes sammen til de første linjene */
function LongText({ text }: { text: string }) {
  const [open, setOpen] = useState(false);
  const lines = text.split('\n');
  const long = text.length > 500 || lines.length > 8;
  if (!long || open) return <>{text}{long && <button class="linkbtn cmore" onClick={() => setOpen(false)}>Vis mindre</button>}</>;
  const head = lines.slice(0, 6).join('\n');
  return (
    <>
      {head.length > 500 ? head.slice(0, 480).trimEnd() : head} …
      <button class="linkbtn cmore" onClick={() => setOpen(true)}>Vis hele ({text.length.toLocaleString('nb')} tegn)</button>
    </>
  );
}

interface Props {
  status: ClaudeStatus;
  /** Bredden i piksler, styrt av App og husket mellom øktene */
  width: number;
  onWidth: (w: number) => void;
  /** Fila brukeren ser på; sendes med som kontekst */
  path: string | null;
  /** Krav-treet, for @-omtale av filer og mapper */
  entries: Snapshot;
  /** Skillene som kan velges der brukeren er (i Avvik bare fs-krav) */
  allowedSkills: string[];
  /** Hvorfor en skill ikke kan velges her */
  skillHint: (skill: string) => string;
  /** Én skill er alltid valgt (Krav, Avvik); uten kan Claude bruke alle de tillatte når ingen er valgt (Oppgaver) */
  preselect: boolean;
  /** Claude kan lese kodeklonene (fs-admin, fs-plattform, min-kompetanse) her */
  codeDirs: boolean;
  /** Finnes fila i vieweren? Lenker til krav-filer i svarene åpner fila */
  has: (path: string) => boolean;
  onOpen: (path: string) => void;
  /** Viser mappa i treet */
  onReveal: (dir: string) => void;
  /** Åpner «Lag PR» utfylt med Claudes forslag; mangler der PR ikke kan lages */
  onPr?: (p: PrProposal) => void;
  /** Endringen i git for en krav-fil, til filene på PR-kortet */
  change?: (path: string) => GitChange | undefined;
  onClose: () => void;
}

/**
 * Samtale med den lokale Claude Code-en (`claude -p --output-format stream-json`), med repoet som arbeidsmappe.
 * Claude kan lese og endre filer, men ikke kjøre kommandoer. Endringene vises i vieweren med én gang,
 * og sendes som PR med «Lag PR» som vanlig. Foreslår Claude en PR (`krav-pr`-blokk), åpner kortet «Lag PR» utfylt.
 */
export function ClaudePanel({ status, width, onWidth, allowedSkills: modeSkills, skillHint: modeHint, preselect, codeDirs, path, entries, has, onOpen, onReveal, onPr, change, onClose }: Props) {
  // Desktop-appen: uten valgte kodemapper finnes det ingen kode å verifisere mot, så fs-verify gråtones
  const dirs = useCodeDirs();
  const noCode = transport.kind === 'electron' && codeDirs && !!dirs && !dirs.some(d => d.exists);
  const allowedSkills = noCode ? modeSkills.filter(s => s !== 'fs-verify') : modeSkills;
  // Skillene som kan velges i velgeren; de andre tillatte kan Claude bruke selv
  const choosable = allowedSkills.filter(s => CLAUDE_SKILLS_SHOWN.includes(s));
  const skillHint = (s: string) =>
    noCode && s === 'fs-verify' && modeSkills.includes(s) ? 'krever lokale kopier av fs-admin, fs-plattform eller min-kompetanse. Velg dem under «Kodemapper».' : modeHint(s);
  const cs = useConversations();
  const conv = currentChat(cs);
  const c = conv?.chat ?? EMPTY_CHAT;
  // Skills som er endret på disk siden de ble lastet i samtalen: den må fortsette i en ny samtale
  const hashes = useSkillHashes();
  const changedAt = skillChangedAt();
  const staleIn = (x: { chat: typeof c; createdAt: number }) => staleSkills(x.chat, hashes, changedAt, x.createdAt);
  const stale = conv ? staleIn(conv) : [];
  const summarized = c.items.some(i => i.kind === 'assistant' && !!summaryIn(i.text));
  const from = c.continuesFrom ? cs.list.find(x => x.id === c.continuesFrom) ?? null : null;
  const inputRef = useRef<HTMLTextAreaElement>(null);
  // Utkastet i feltet overlever omlasting og at panelet lukkes
  const [draft] = useState(readDraft);
  const [input, setInput] = useState(draft.text);
  const [error, setError] = useState<string | null>(null);
  const [showList, setShowList] = useState(false);
  // Tittelen på terminaløkten som startes, til ptyStart har svart (claude finnes, PATH fra skallet, node-pty)
  const [starting, setStarting] = useState<string | null>(null);
  const list = useRef<HTMLDivElement>(null);
  const running = c.runId !== null;
  // Skillen før den første samtalen finnes; ellers den samtalen har valgt. Er den ikke tillatt her,
  // gjelder den første tillatte i Krav og Avvik (fs-krav), og ingen i Oppgaver. Den lastes med neste melding.
  const [pending, setPending] = useState<string | null>(draft.pending);
  const skill = effectiveSkill(conv ? c.skill : pending, choosable, preselect);
  // Fila brukeren ser på, sendes med som kontekst. ✕ holder den utenfor til brukeren åpner en annen fil.
  // Etter omlasting er det samme fil, så ✕ blir stående.
  const [excluded, setExcluded] = useState<string | null>(draft.excluded);
  const context = path !== null && path !== excluded;
  const sentPath = context ? path : null;
  useEffect(() => {
    if (path !== excluded) setExcluded(null);
  }, [path]);
  // Filer og mapper lagt ved med @; de gjelder bare neste melding
  const mention = useMentions(entries, path, input, setInput, draft.mentions);
  const mentionKey = mention.mentions.join('\n');
  useEffect(() => saveDraft({ text: input, mentions: mention.mentions, excluded, pending }), [input, mentionKey, excluded, pending]);

  // Lukkes panelet, avvises spørsmålene som venter
  useEffect(() => denyAllPending, []);
  const auth = needsAuth(c);
  const edited = editedFiles(c).filter(isEditablePath);

  useEffect(() => {
    const el = list.current;
    if (el) el.scrollTop = el.scrollHeight;
  }, [c.items.length, conv?.id, showList]);

  /**
   * Sender `text` som ny melding i samtalen som er åpen (eller en ny). Brukes av inputfeltet, av «Send til Claude Code»
   * og av «Oppsummer samtalen» og «Lag forslag til PR» (`preset`).
   */
  const sendText = async (text: string, mentions: string[] = [], preset?: ChatPreset, inConv?: string, withSkill?: string) => {
    if (!text || (running && !inConv)) return;
    setError(null);
    setShowList(false);
    // Versjonen av skillen som lastes med meldingen, skal være den som er på disk nå
    await refreshSkills();
    let id = inConv ?? conv?.id;
    if (!id) {
      id = newId();
      set(createConversation(convs, id, Date.now(), skill));
    }
    const target = id;
    const cur = convs.list.find(x => x.id === target)!.chat;
    // En utførekjøring har ingen krav-skill: skillene er kode-repoets
    const before = cur.target ? cur : chooseSkill(cur, withSkill ?? skill);
    const { chat: after, invoke } = send(before, text, sentPath, mentions, skillHashes(), preset);
    set(updateConversation(convs, target, () => after, Date.now()));
    try {
      const { runId } = await transport.call(
        'claudeRun',
        before.target
          ? { prompt: text, sessionId: before.sessionId, path: sentPath, mentions, target: before.target, allowTools: before.alwaysAllowed }
          : {
              prompt: text,
              sessionId: before.sessionId,
              path: sentPath,
              mentions,
              skill: after.skill,
              skills: allowedSkills,
              invoke,
              knownSkills: knownSkills(),
              dirs: codeDirs ? await codeDirPaths() : [],
              allowTools: before.alwaysAllowed,
            },
      );
      set(updateConversation(convs, target, ch => started(ch, runId), Date.now()));
      for (const ev of early.get(runId) ?? []) {
        const next = applyEvent(convs, runId, ev, Date.now(), skillHashes());
        if (next) set(next);
      }
      early.delete(runId);
    } catch (e) {
      setError((e as Error).message);
    }
  };
  const submit = async () => {
    const text = input.trim();
    if (!text || running) return;
    const mentions = mention.mentions;
    setInput('');
    mention.clear();
    await sendText(text, mentions);
  };

  // Markert tekst fra feature-visningen legges i inputfeltet som sitat. Feltet lyser opp et øyeblikk.
  const [inputFlash, setInputFlash] = useState(false);
  const flashTimer = useRef<ReturnType<typeof setTimeout>>();
  useEffect(() => () => clearTimeout(flashTimer.current), []);
  const insertText = (quote: string) => {
    const next = appendQuote(inputRef.current?.value ?? input, quote);
    setInput(next);
    setInputFlash(true);
    clearTimeout(flashTimer.current);
    flashTimer.current = setTimeout(() => setInputFlash(false), 1200);
    setTimeout(() => {
      const ta = inputRef.current;
      if (!ta) return;
      ta.focus();
      ta.setSelectionRange(next.length, next.length);
      ta.scrollTop = ta.scrollHeight;
    }, 30);
  };

  // Mens panelet er åpent kan andre visninger sende en prompt hit («Send til Claude Code»), eller legge tekst i inputfeltet
  const sendRef = useRef(sendText);
  sendRef.current = sendText;
  // «Utfør i <repo>» fra Spesifikasjoner: ny samtale som kjører i kode-repoet
  const executeText = async (text: string, target: ExecuteTarget, title: string) => {
    const id = newId();
    set(createExecuteConversation(convs, id, Date.now(), target, title));
    await sendRef.current(text, [], undefined, id);
  };
  // «Verifiser» i feature-visningen: ny samtale med fs-verify (en tom samtale gjenbrukes)
  const withSkillText = async (text: string, s: string) => {
    const next = createConversation(convs, newId(), Date.now(), s);
    set(next);
    await sendRef.current(text, [], undefined, next.current ?? undefined, s);
  };
  // «Utfør med team» og «Verifiser … i terminal med agent team»: interaktiv claude i en pseudo-terminal
  const terminalText = async (text: string, req: Omit<PtyStartRequest, 'prompt'>, title: string) => {
    setError(null);
    setShowList(false);
    setStarting(title);
    try {
      const { id } = await transport.call('ptyStart', { ...req, prompt: text, cols: 100, rows: 32 });
      set(createTerminalConversation(convs, newId(), Date.now(), { id, mode: req.mode, repo: req.target?.repo }, title));
    } catch (e) {
      setError((e as Error).message);
    } finally {
      setStarting(null);
    }
  };
  const insertRef = useRef(insertText);
  insertRef.current = insertText;
  useEffect(() => {
    if (!status.available) return;
    registerClaude({ send: t => sendRef.current(t), execute: (t, target, title) => executeText(t, target, title), withSkill: (t, s) => withSkillText(t, s), terminal: (t, req, title) => terminalText(t, req, title), insert: t => insertRef.current(t) });
    return () => {
      registerClaude(null);
      setClaudeBusy(false);
    };
  }, [status.available]);
  useEffect(() => setClaudeBusy(running), [running]);

  /**
   * Ny samtale som fortsetter fra den som er åpen, med samme skill. Med en oppsummering legges den i inputfeltet,
   * og filene legges ved med @. Brukeren leser og sender selv; første melding laster den nye versjonen av skillen.
   */
  const continueIn = (summary?: ChatSummary, files: string[] = []) => {
    const skillNow = effectiveSkill(c.skill, choosable, preselect);
    set(createConversation(convs, newId(), Date.now(), skillNow, conv?.id ?? null));
    setShowList(false);
    if (!summary) return;
    setInput(summaryDraft(summary));
    mention.replace(summaryMentions(files));
    setTimeout(() => inputRef.current?.focus());
  };

  const remove = (id: string, title: string) => {
    if (!confirm(`Slette samtalen «${title}»?`)) return;
    const runId = convs.list.find(v => v.id === id)?.chat.runId;
    if (runId) void transport.call('claudeCancel', runId);
    set(removeConversation(convs, id));
  };

  const fileName = (p: string) => p.slice(p.lastIndexOf('/') + 1);

  return (
    <aside class="claude">
      <ResizeHandle
        width={width}
        onWidth={onWidth}
        edge="left"
        min={MIN_WIDTH}
        max={maxWidth}
        fallback={CLAUDE_WIDTH}
        label="Endre bredden på Claude-panelet"
      />
      <div class="claude-head">
        <span class="claude-mark" />
        <b>Claude</b>
        <span class="mono muted" title={status.path ?? ''}>{status.version?.split(' ')[0] ?? ''}</span>
        <div class="claude-btns">
          <button class="smallbtn" aria-pressed={showList} onClick={() => setShowList(v => !v)} title="Vis alle samtalene">
            Samtaler{cs.list.length > 0 && ` (${cs.list.length})`}
          </button>
          <button
            class="smallbtn"
            onClick={() => {
              set(createConversation(convs, newId(), Date.now(), effectiveSkill(null, choosable, preselect)));
              setShowList(false);
            }}
            title="Start en ny samtale"
          >
            Ny
          </button>
          <button class="smallbtn" onClick={onClose} aria-label="Lukk Claude-panelet">Lukk</button>
        </div>
      </div>
      {conv && !showList && !starting && !conv.chat.items.length && from && (
        <div class="claude-info">
          <div class="claude-title muted">{conv.title}</div>
        </div>
      )}
      {conv && !showList && !starting && c.terminal && (
        <div class="claude-info">
          <div class="claude-title" title={conv.title}>{conv.title}</div>
        </div>
      )}
      {conv && !showList && !starting && conv.chat.items.length > 0 && (
        <div class="claude-info">
          <div class="claude-title" title={conv.title}>{conv.title}</div>
          {c.target && (
            <div class="claude-exec" title={`Claude kjører i ${c.target.dir}, med repoets skills og CLAUDE.md. Kan endre koden der og bygge, teste og committe lokalt, men ikke pushe. I kravrepoet kan bare utforing.md endres.`}>
              <span class="sp-ic sp-ic--repo" />
              Utførekjøring i <b>{c.target.repo}</b>
              <span class="mono muted">· {c.target.spec.split('/').pop()}</span>
            </div>
          )}
          <div class="claude-meta">
            {c.context && (
              <span
                class="cctxmeter"
                title={`Tokens i konteksten ved siste svar (${c.context.used.toLocaleString('nb')}${c.context.window ? ` av ${c.context.window.toLocaleString('nb')}` : ''}). Claude Code komprimerer samtalen selv når vinduet blir fullt.`}
              >
                <span class={'cbar' + (c.context.window && c.context.used / c.context.window > 0.8 ? ' high' : '')} aria-hidden="true">
                  <span style={{ width: `${c.context.window ? Math.min(100, (c.context.used / c.context.window) * 100) : 0}%` }} />
                </span>
                Kontekst {contextLabel(c.context)}
              </span>
            )}
            <span class="cloaded" title="Skills som er lastet inn i samtalen">
              Lastet:{' '}
              {c.loadedSkills.length ? (
                c.loadedSkills.map(n =>
                  stale.includes(n) ? (
                    <span key={n} class="cctx-skill stale" title="Endret siden den ble lastet i samtalen">
                      {n} <b aria-hidden="true">↻</b>
                    </span>
                  ) : (
                    <span key={n} class="cctx-skill">{n}</span>
                  ),
                )
              ) : (
                <span class="muted">ingen skills</span>
              )}
            </span>
          </div>
        </div>
      )}

      {!status.available ? (
        <div class="claude-empty">
          Fant ikke Claude Code på maskinen. Installer det (se <a href="https://code.claude.com/docs" target="_blank" rel="noreferrer">code.claude.com/docs ↗</a>) og logg inn med{' '}
          <span class="mono">claude</span> i en terminal. Ligger det et uvanlig sted, start appen med <span class="mono">KRAV_CLAUDE_PATH</span> satt.
        </div>
      ) : showList ? (
        <div class="claude-list">
          {!cs.list.length && <div class="claude-empty">Ingen samtaler ennå.</div>}
          {cs.list.map(x => (
            <div key={x.id} class={'cconv' + (x.id === cs.current ? ' cur' : '')}>
              <button
                class="cconv-open"
                onClick={() => {
                  set(selectConversation(convs, x.id));
                  setShowList(false);
                }}
              >
                <span class="cconv-title">
                  {x.chat.runId && <span class="cdot" title="Claude jobber" />}
                  {x.title}
                </span>
                <span class="cconv-meta mono muted">
                  {x.chat.skill && <span>{x.chat.skill}</span>}
                  {staleIn(x).length > 0 && (
                    <span class="cconv-stale" title={`Oppdatert siden den ble lastet: ${staleIn(x).join(', ')}`}>
                      <span class="cstale-tri" aria-hidden="true" />
                      utdatert skill
                    </span>
                  )}
                  <span>{when(x.updatedAt)}</span>
                </span>
              </button>
              <button class="smallbtn cconv-del" onClick={() => remove(x.id, x.title)} aria-label={`Slett samtalen ${x.title}`} title="Slett samtalen">
                Slett
              </button>
            </div>
          ))}
        </div>
      ) : starting ? (
        <>
          <div class="claude-info">
            <div class="claude-title" title={starting}>{starting}</div>
          </div>
          <div class="claude-empty cstarting" role="status">
            <span class="spinner" aria-hidden="true" />
            Starter Claude Code i en terminal …
          </div>
        </>
      ) : c.terminal ? (
        <>
          {error && <div class="edwarn err" role="alert">{error}</div>}
          <TerminalView key={c.terminal.id} session={c.terminal} onExit={code => conv && set(updateConversation(convs, conv.id, ch => terminalExited(ch, code), Date.now()))} />
        </>
      ) : (
        <>
          <div class="claude-list" ref={list}>
            {!c.items.length && from && (
              <div class="claude-empty ccontinue">
                Fortsetter fra «{from.title}».{' '}
                <button class="linkbtn" onClick={() => set(selectConversation(convs, from.id))}>
                  Åpne den gamle samtalen
                </button>
              </div>
            )}
            {!c.items.length && !from && (
              <div class="claude-empty">
                Spør om kravene, eller be Claude endre dem. Claude kan lese og redigere filene, men ikke kjøre kommandoer eller lage PR.
                <br />
                <br />
                For eksempel: <i>«Gå gjennom denne fila mot konvensjonene og rett avvikene»</i>.
              </div>
            )}
            {c.items.map((i, n) =>
              i.kind === 'user' && i.preset ? (
                <div key={n} class="cmsg user cpreset" title={i.text}>
                  <span class="cpreset-label mono">{PRESET[i.preset].label}</span>
                  <span class="cpreset-text">{PRESET[i.preset].text}</span>
                </div>
              ) : i.kind === 'user' ? (
                <div key={n} class="cmsg user">
                  <LongText text={i.text} />
                  {(i.path || i.skill || i.mentions?.length) && (
                    <div class="cctx mono">
                      {i.skill && <span class="cctx-skill">{i.skill}</span>}
                      {[i.path, ...(i.mentions ?? [])]
                        .filter((p): p is string => !!p)
                        .map(p => (
                          <span key={p} class="cctx-file" title={p}>{fileName(p)}{entries[p] ? '' : '/'}</span>
                        ))}
                    </div>
                  )}
                </div>
              ) : i.kind === 'assistant' ? (
                <div key={n} class="cmsg assistant">
                  <ChatMarkdown text={i.text} has={has} onOpen={onOpen} onPr={onPr} change={change} onSummary={continueIn} skill={c.skill} edited={editedFiles(c)} />
                </div>
              ) : i.kind === 'tool' && i.name === 'AskUserQuestion' ? null : i.kind === 'tool' ? (
                <div key={n} class={'ctool ' + i.state}>
                  <span class="cdot" />
                  <span>{toolLabel(i.name)}</span>
                  {i.summary.startsWith('krav/') && (i.name === 'Read' || i.name === 'Edit' || i.name === 'Write') ? (
                    <button class="linkbtn mono" onClick={() => onOpen(i.summary)} title={i.summary}>{fileName(i.summary)}</button>
                  ) : (
                    <span class="mono muted" title={i.summary}>{i.summary}</span>
                  )}
                </div>
              ) : i.kind === 'permission' ? (
                <PermissionCard key={i.id} convId={conv!.id} item={i} />
              ) : i.kind === 'question' ? (
                <QuestionCard key={i.id} item={i} />
              ) : (
                <div key={n} class={'cdone' + (i.ok ? '' : ' err')}>{i.text}</div>
              ),
            )}
            {running && <div class="cdone muted">Claude jobber …</div>}
          </div>

          {/* Kravene, og det fs-specify og fs-verify skriver i oppgavemappa (spec/, utforing.md), kan sendes med «Lag PR» */}
          {edited.length > 0 && (
            <div class="ctouched">
              <span class="muted">Endret i samtalen:</span>
              {edited.map(p =>
                has(p) ? (
                  <button key={p} class="linkbtn mono" onClick={() => onOpen(p)} title={p}>{fileName(p)}</button>
                ) : (
                  <span key={p} class="mono muted" title={p}>{fileName(p)}</span>
                ),
              )}
              {onPr && (
                <button class="smallbtn ctouched-pr" disabled={running} onClick={() => void sendText(PR_PROMPT, [], 'pr')}>
                  Lag forslag til PR
                </button>
              )}
            </div>
          )}
          {stale.length > 0 && !running && (
            <div class={'cstale' + (summarized ? ' compact' : '')} role="status">
              <span class="cstale-tri" aria-hidden="true" />
              <div class="cstale-text">
                {stale.map((n, j) => (
                  <span key={n}>
                    {j > 0 && ', '}
                    <b class="mono">{n}</b>
                  </span>
                ))}{' '}
                {summarized
                  ? `er oppdatert siden ${stale.length === 1 ? 'den' : 'de'} ble lastet.`
                  : `er oppdatert siden ${stale.length === 1 ? 'den' : 'de'} ble lastet i denne samtalen. Start en ny samtale for å bruke den nye versjonen.`}
              </div>
              <div class="cstale-btns">
                {!summarized && (
                  <button class="primbtn" onClick={() => void sendText(SUMMARY_PROMPT, [], 'summary')}>
                    Oppsummer samtalen
                  </button>
                )}
                <button class="smallbtn" onClick={() => continueIn()}>
                  Ny samtale
                </button>
              </div>
            </div>
          )}
          {auth.length > 0 && (
            <div class="cstale compact" role="status">
              <span class="cstale-tri" aria-hidden="true" />
              <div class="cstale-text">
                {auth.map((n, j) => (
                  <span key={n}>
                    {j > 0 && ', '}
                    <b class="mono">{n}</b>
                  </span>
                ))}{' '}
                er ikke logget inn. Kjør <code>claude</code> i terminalen og <code>/mcp</code> én gang for å logge inn; det kan ikke gjøres herfra.
              </div>
            </div>
          )}
          {error && <div class="edwarn err" role="alert">{error}</div>}

          <div class="claude-input">
            {/* I en utførekjøring er skillene kode-repoets, og kodemappa er arbeidsmappa */}
            {!c.target && (
              <>
                <SkillPicker
                  value={skill}
                  allowed={allowedSkills}
                  hint={skillHint}
                  preselect={preselect}
                  disabled={running}
                  locked={stale.length > 0}
                  onChange={s => (conv ? set(updateConversation(convs, conv.id, ch => chooseSkill(ch, s), Date.now())) : setPending(s))}
                />
                {codeDirs && <CodeDirs />}
              </>
            )}
            <div class={'cinbox' + (inputFlash ? ' flash' : '')}>
              {mention.picker && (
                <MentionPicker
                  {...mention.picker}
                  onActive={mention.setActive}
                  onFilter={mention.setFilter}
                  onToggle={mention.toggle}
                  onCommit={mention.commit}
                />
              )}
              <textarea
                ref={inputRef}
                rows={3}
                value={input}
                placeholder="Spør Claude …"
                role="combobox"
                aria-expanded={!!mention.picker}
                aria-controls={mention.picker ? MENTION_LIST_ID : undefined}
                aria-activedescendant={mention.picker?.list.flat.length ? `${MENTION_LIST_ID}-${mention.picker.active}` : undefined}
                aria-autocomplete="list"
                onInput={e => {
                  const v = (e.target as HTMLTextAreaElement).value;
                  setInput(v);
                  mention.onInput(v);
                }}
                onBlur={mention.close}
                onKeyDown={e => {
                  if (mention.onKeyDown(e)) return;
                  if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    void submit();
                  }
                }}
                aria-label="Melding til Claude"
              />
              <div class="cinbox-foot">
                <div class="cbadges">
                  {/* Er fila alt lagt ved med @ (selv eller via en mappe), holder den badgen */}
                  {path &&
                    !covered(mention.mentions, path) &&
                    (context ? (
                      <span class="cfile">
                        <button class="cfile-open" onClick={() => onOpen(path)} title={`${path} · sendes med som kontekst`}>
                          <span class="cfile-icon" aria-hidden="true" />
                          <span class="cfile-name">{fileName(path)}</span>
                        </button>
                        <button class="cfile-x" onClick={() => setExcluded(path)} aria-label={`Ikke send med ${fileName(path)}`} title="Ikke send med fila">
                          ✕
                        </button>
                      </span>
                    ) : (
                      <button class="cfile off" onClick={() => setExcluded(null)} title={`Send med ${path} som kontekst`}>
                        + {fileName(path)}
                      </button>
                    ))}
                  {mention.mentions.map(p => {
                    const dir = !mention.items.get(p)?.entry;
                    return (
                      <span key={p} class="cfile">
                        <button class="cfile-open" onClick={() => (dir ? onReveal(p) : onOpen(p))} title={dir ? `Vis ${p} i treet` : `Åpne ${p}`}>
                          <span class={dir ? 'cfile-dir' : 'cfile-icon'} aria-hidden="true" />
                          <span class="cfile-name">
                            {fileName(p)}
                            {dir && '/'}
                          </span>
                        </button>
                        <button class="cfile-x" onClick={() => mention.remove(p)} aria-label={`Fjern ${fileName(p)}`} title="Fjern">
                          ✕
                        </button>
                      </span>
                    );
                  })}
                </div>
                {running ? (
                  <button class="smallbtn" onClick={() => void transport.call('claudeCancel', c.runId!)}>Avbryt</button>
                ) : (
                  <button class="primbtn" disabled={!input.trim()} onClick={() => void submit()}>Send</button>
                )}
              </div>
            </div>
            <div class="claude-send">
              <span class="muted">Enter sender · Shift+Enter ny linje · @ legger til filer og mapper</span>
            </div>
          </div>
        </>
      )}
    </aside>
  );
}
