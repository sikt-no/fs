// Samtalen i Claude-panelet. Rene funksjoner over hendelsene fra core/claude.ts, så de kan testes med node --test.
import type { ClaudeEvent, ClaudeMcpServer, ExecuteTarget } from '../shared/api.ts';
import type { Answers, Question } from '../shared/question.ts';

export type ChatPreset = 'summary' | 'pr';

export type ChatItem =
  /** `preset`: den faste meldingen bak «Oppsummer samtalen» (`summary`) eller «Lag forslag til PR» (`pr`), som vises kort */
  | { kind: 'user'; text: string; path: string | null; skill?: string | null; mentions?: string[]; preset?: ChatPreset }
  | { kind: 'assistant'; text: string }
  | { kind: 'tool'; id: string; name: string; summary: string; state: 'running' | 'ok' | 'error' }
  | { kind: 'done'; ok: boolean; text: string }
  /** Claude vil bruke et verktøy som må godkjennes (`mcp__*`, WebFetch): kortet med «Tillat», «Tillat alltid» og «Avvis» */
  | { kind: 'permission'; id: string; tool: string; input: Record<string, string>; state: PermissionState }
  /** Claude spør med AskUserQuestion: kortet med valgene, «Send svar» og «Hopp over». `answers` når det er besvart */
  | { kind: 'question'; id: string; questions: Question[]; state: QuestionState; answers: Answers | null };

/** `pending`: venter på brukeren. `timeout`, `closed`, `ended`: avvist fordi tiden gikk ut, panelet ble lukket eller kjøringen sluttet */
export type PermissionState = 'pending' | 'allowed' | 'denied' | 'timeout' | 'closed' | 'ended';
/** `answered`: besvart. `skipped`: «Hopp over». Resten som for spørsmål om lov */
export type QuestionState = 'pending' | 'answered' | 'skipped' | 'timeout' | 'closed' | 'ended';

export interface Chat {
  items: ChatItem[];
  /** Fortsetter samtalen med `--resume` */
  sessionId: string | null;
  /** Kjøringen som pågår */
  runId: string | null;
  /** Filer Claude har endret i samtalen (Edit/Write), relative til repoet */
  touched: string[];
  /** Skillen som er valgt for samtalen (én om gangen), eller `null` */
  skill: string | null;
  /** Skillen som sist ble lastet med `/<skill>`; byttes skillen, lastes den nye med neste melding */
  skillLoaded: string | null;
  /** Skillene som er lastet inn i samtalen: med `/<skill>`, eller med Skill-verktøyet uten å bli stoppet */
  loadedSkills: string[];
  /** Tokens brukt av konteksten i siste svar, og kontekstvinduet til modellen */
  context: { used: number; window: number | null } | null;
  /**
   * Versjonen (hash) av hver skill da den ble lastet i samtalen; er den endret siden, er skillen utdatert her.
   * Heter ikke `skillVersions`: den første utgaven fylte inn versjonen på disk i gamle samtaler, og de verdiene stemmer ikke.
   */
  loadedVersions: Record<string, string>;
  /** Samtalen denne fortsetter fra (startet fra en oppsummering, eller fordi en skill var oppdatert) */
  continuesFrom: string | null;
  /** Utførekjøring fra Spesifikasjoner («Utfør i <repo>»): Claude kjører i kode-repoet. Mangler i eldre samtaler. */
  target?: ExecuteTarget | null;
  /** «Tillat alltid i denne samtalen»: verktøyene som sendes som `allowTools` og ikke spørres om igjen */
  alwaysAllowed: string[];
  /** MCP-serverne fra siste init, og om de er koblet til */
  mcp: ClaudeMcpServer[];
}

export const EMPTY_CHAT: Chat = {
  items: [],
  sessionId: null,
  runId: null,
  touched: [],
  skill: null,
  skillLoaded: null,
  loadedSkills: [],
  context: null,
  loadedVersions: {},
  continuesFrom: null,
  alwaysAllowed: [],
  mcp: [],
};

/** Versjonen av hver skill på disk, fra `claudeSkills` */
export type SkillHashes = Record<string, string>;

const addSkill = (list: string[], s: string) => (list.includes(s) ? list : [...list, s]);
const withVersion = (v: Record<string, string>, s: string, hashes: SkillHashes) => (hashes[s] ? { ...v, [s]: hashes[s] } : v);

/**
 * Neste melding i samtalen, med filene og mappene lagt ved med @. `invoke`: meldingen skal laste den valgte skillen
 * (`/<skill>`), og versjonen den har nå (`hashes`), lagres.
 */
export function send(
  chat: Chat,
  text: string,
  path: string | null,
  mentions: string[] = [],
  hashes: SkillHashes = {},
  preset?: ChatPreset,
): { chat: Chat; invoke: boolean } {
  // De faste meldingene (oppsummering, PR-forslag) skal ikke laste en ny versjon av skillen inn i samtalen
  const invoke = !preset && !!chat.skill && chat.skill !== chat.skillLoaded;
  return {
    chat: {
      ...chat,
      skillLoaded: invoke ? chat.skill : chat.skillLoaded,
      loadedSkills: invoke && chat.skill ? addSkill(chat.loadedSkills, chat.skill) : chat.loadedSkills,
      loadedVersions: invoke && chat.skill ? withVersion(chat.loadedVersions, chat.skill, hashes) : chat.loadedVersions,
      items: [...chat.items, { kind: 'user', text, path, skill: chat.skill, ...(mentions.length ? { mentions } : {}), ...(preset ? { preset } : {}) }],
    },
    invoke,
  };
}

/**
 * Skillene som er lastet i samtalen, men endret på disk siden. Med lagret versjon: en annen hash enn den som ble lagret.
 * Uten (samtaler fra før versjonene ble lagret): skillen er endret på disk (`changedAt`) etter at samtalen ble
 * startet (`since`, ms), så den lastet en eldre versjon.
 */
export function staleSkills(chat: Chat, hashes: SkillHashes, changedAt: Record<string, number> = {}, since?: number): string[] {
  return chat.loadedSkills.filter(s => {
    const v = chat.loadedVersions[s];
    if (v) return !!hashes[s] && v !== hashes[s];
    return since != null && !!changedAt[s] && changedAt[s] > since;
  });
}


/**
 * Skillen som gjelder der brukeren er i vieweren: den valgte hvis den er tillatt der. Ellers den første
 * tillatte (Krav og Avvik, `preselect`), eller ingen (Oppgaver, der Claude da kan bruke alle de tillatte).
 */
export function effectiveSkill(chosen: string | null, allowed: string[], preselect = true): string | null {
  if (chosen && allowed.includes(chosen)) return chosen;
  return preselect ? (allowed[0] ?? null) : null;
}

export function chooseSkill(chat: Chat, skill: string | null): Chat {
  return chat.skill === skill ? chat : { ...chat, skill };
}

export function started(chat: Chat, runId: string): Chat {
  return { ...chat, runId };
}

const EDIT_TOOLS = ['Edit', 'Write', 'MultiEdit', 'NotebookEdit', 'mcp__kravforvaltning__save_sketch'];

/** En sti fra et verktøykall, relativ til repoet: `/…/repo/tasks/x.md` → `tasks/x.md` */
const repoRelative = (p: string) => p.replace(/^.*?\/((?:krav|tasks)\/)/, '$1').replace(/^\.?\//, '');

/**
 * Filene Claude har endret i samtalen (Edit/Write som gikk bra), relative til repoet. Også utenfor krav/,
 * f.eks. en rapport i tasks/, som `touched` ikke tar med.
 */
export function editedFiles(chat: Chat): string[] {
  const out: string[] = [];
  for (const i of chat.items) {
    if (i.kind !== 'tool' || !EDIT_TOOLS.includes(i.name) || i.state !== 'ok' || !i.summary) continue;
    const p = repoRelative(i.summary);
    if (!out.includes(p)) out.push(p);
  }
  return out;
}

/**
 * Legger en hendelse fra kjøringen `runId` inn i samtalen; hendelser fra andre kjøringer ignoreres.
 * `hashes`: versjonen av skillene nå, som lagres når Claude laster en med Skill-verktøyet.
 */
export function apply(chat: Chat, runId: string, ev: ClaudeEvent, hashes: SkillHashes = {}): Chat {
  if (runId !== chat.runId) return chat;
  switch (ev.kind) {
    case 'init':
      return { ...chat, sessionId: ev.sessionId, mcp: ev.mcp ?? chat.mcp };
    case 'permission':
      if (chat.items.some(i => i.kind === 'permission' && i.id === ev.id)) return chat;
      return { ...chat, items: [...chat.items, { kind: 'permission', id: ev.id, tool: ev.tool, input: ev.input, state: 'pending' }] };
    case 'permissionDone': {
      const state: PermissionState = ev.behavior === 'allow' ? 'allowed' : ev.reason === 'user' ? 'denied' : ev.reason;
      return { ...chat, items: chat.items.map(i => (i.kind === 'permission' && i.id === ev.id ? { ...i, state } : i)) };
    }
    case 'question':
      if (chat.items.some(i => i.kind === 'question' && i.id === ev.id)) return chat;
      return { ...chat, items: [...chat.items, { kind: 'question', id: ev.id, questions: ev.questions, state: 'pending', answers: null }] };
    case 'questionDone': {
      const state: QuestionState = ev.answers ? 'answered' : ev.reason === 'user' ? 'skipped' : ev.reason;
      return { ...chat, items: chat.items.map(i => (i.kind === 'question' && i.id === ev.id ? { ...i, state, answers: ev.answers } : i)) };
    }
    case 'text':
      return { ...chat, items: [...chat.items, { kind: 'assistant', text: ev.text }] };
    case 'tool': {
      const touched = EDIT_TOOLS.includes(ev.name) && ev.summary.startsWith('krav/') && !chat.touched.includes(ev.summary) ? [...chat.touched, ev.summary] : chat.touched;
      return { ...chat, touched, items: [...chat.items, { kind: 'tool', id: ev.id, name: ev.name, summary: ev.summary, state: 'running' }] };
    }
    case 'toolResult': {
      const tool = chat.items.find((i): i is Extract<ChatItem, { kind: 'tool' }> => i.kind === 'tool' && i.id === ev.id);
      const skill = tool?.name === 'Skill' && !ev.isError ? tool.summary : null;
      return {
        ...chat,
        loadedSkills: skill ? addSkill(chat.loadedSkills, skill) : chat.loadedSkills,
        // Lastes en skill på nytt med Skill-verktøyet, får den versjonen som gjelder nå
        loadedVersions: skill ? withVersion(chat.loadedVersions, skill, hashes) : chat.loadedVersions,
        items: chat.items.map(i => (i.kind === 'tool' && i.id === ev.id ? { ...i, state: ev.isError ? 'error' : 'ok' } : i)),
      };
    }
    case 'usage':
      return { ...chat, context: { used: ev.tokens, window: chat.context?.window ?? null } };
    case 'done': {
      const secs = ev.durationMs != null ? ` · ${(ev.durationMs / 1000).toFixed(1)} s` : '';
      const text = ev.ok ? `Ferdig${ev.turns != null ? ` · ${ev.turns} steg` : ''}${secs}` : ev.error ?? 'Feil';
      // Verktøy som aldri fikk svar (avbrutt eller feil) er ikke lenger i gang
      const items = endPending(chat.items.map(i => (i.kind === 'tool' && i.state === 'running' ? { ...i, state: ev.ok ? 'ok' : 'error' } as ChatItem : i)));
      const context = chat.context && ev.contextWindow ? { ...chat.context, window: ev.contextWindow } : chat.context;
      return { ...chat, runId: null, context, sessionId: ev.sessionId ?? chat.sessionId, items: [...items, { kind: 'done', ok: ev.ok, text }] };
    }
  }
}

/** Spørsmål om lov som fortsatt venter, når kjøringen er over, er avvist av backenden */
const endPending = (items: ChatItem[]) => items.map(i => ((i.kind === 'permission' || i.kind === 'question') && i.state === 'pending' ? ({ ...i, state: 'ended' } as ChatItem) : i));

/** Spørsmålene om lov i samtalen som venter på brukeren */
export function pendingPermissions(chat: Chat): Extract<ChatItem, { kind: 'permission' }>[] {
  return chat.items.filter((i): i is Extract<ChatItem, { kind: 'permission' }> => i.kind === 'permission' && i.state === 'pending');
}

/** Spørsmålene fra AskUserQuestion i samtalen som venter på brukeren */
export function pendingQuestions(chat: Chat): Extract<ChatItem, { kind: 'question' }>[] {
  return chat.items.filter((i): i is Extract<ChatItem, { kind: 'question' }> => i.kind === 'question' && i.state === 'pending');
}

/** «Tillat alltid i denne samtalen»: verktøyet sendes som `allowTools` med de neste meldingene */
export function allowAlways(chat: Chat, tool: string): Chat {
  return chat.alwaysAllowed.includes(tool) ? chat : { ...chat, alwaysAllowed: [...chat.alwaysAllowed, tool] };
}

/** MCP-serverne som må logges inn med `/mcp` i terminalen */
export function needsAuth(chat: Chat): string[] {
  return chat.mcp.filter(m => m.status === 'needs-auth').map(m => m.name);
}

/** Visningsnavn for verktøyene */
export const TOOL_LABEL: Record<string, string> = {
  Read: 'Leser',
  Glob: 'Finner filer',
  Grep: 'Søker',
  Edit: 'Endrer',
  Write: 'Skriver',
  Skill: 'Bruker skill',
  TodoWrite: 'Planlegger',
  WebFetch: 'Henter fra nettet',
  AskUserQuestion: 'Spør deg',
};

/** Visningsnavnet til et verktøy: `TOOL_LABEL`, eller «Figma: get_screenshot» for `mcp__figma__get_screenshot` */
export function toolLabel(name: string): string {
  if (TOOL_LABEL[name]) return TOOL_LABEL[name];
  const m = name.match(/^mcp__([\w.-]+?)__([\w.-]+)$/);
  if (!m) return name;
  if (m[1] === 'kravforvaltning' && m[2] === 'save_sketch') return 'Lagrer skisse';
  // claude.ai-koblinger: `claude_ai_Atlassian_Rovo` → «Atlassian Rovo»
  const server = m[1].replace(/^claude_ai_/, '').replace(/_/g, ' ');
  return `${server.charAt(0).toUpperCase()}${server.slice(1)}: ${m[2]}`;
}

/** En lagret samtale i panelet. Claude Code husker selve samtalen (`sessionId`); her ligger det vieweren viser. */
export interface Conversation {
  id: string;
  title: string;
  createdAt: number;
  updatedAt: number;
  chat: Chat;
}

/** Alle samtalene, nyeste først, og hvilken som er åpen */
export interface Conversations {
  list: Conversation[];
  current: string | null;
}

export const NO_CONVERSATIONS: Conversations = { list: [], current: null };
export const UNTITLED = 'Ny samtale';

/** Tittelen er starten av første melding */
export function titleOf(text: string): string {
  const line = text.trim().split('\n')[0].replace(/\s+/g, ' ');
  return line.length > 60 ? line.slice(0, 57).trimEnd() + '…' : line || UNTITLED;
}

export function currentChat(cs: Conversations): Conversation | null {
  return cs.list.find(c => c.id === cs.current) ?? null;
}

/**
 * Ny, tom samtale øverst, og åpen, med `skill` valgt. En tom samtale som allerede finnes, gjenbrukes.
 * `continuesFrom`: samtalen den nye fortsetter fra (vises i den tomme samtalen).
 */
export function createConversation(cs: Conversations, id: string, now: number, skill: string | null = null, continuesFrom: string | null = null): Conversations {
  const empty = cs.list.find(c => !c.chat.items.length && !c.chat.runId);
  if (empty) {
    if (!continuesFrom) return { ...cs, current: empty.id };
    const chat = { ...empty.chat, skill, continuesFrom };
    return { list: cs.list.map(c => (c.id === empty.id ? { ...c, chat } : c)), current: empty.id };
  }
  return { list: [{ id, title: UNTITLED, createdAt: now, updatedAt: now, chat: { ...EMPTY_CHAT, skill, continuesFrom } }, ...cs.list], current: id };
}

/** Ny samtale for en utførekjøring i kode-repoet, med fast tittel (ikke første melding, som er handoff-prompten) */
export function createExecuteConversation(cs: Conversations, id: string, now: number, target: ExecuteTarget, title: string): Conversations {
  return { list: [{ id, title, createdAt: now, updatedAt: now, chat: { ...EMPTY_CHAT, target } }, ...cs.list], current: id };
}

/** Sletter samtalen; er den åpen, åpnes den neste i lista */
export function removeConversation(cs: Conversations, id: string): Conversations {
  const i = cs.list.findIndex(c => c.id === id);
  if (i < 0) return cs;
  const list = cs.list.filter(c => c.id !== id);
  const current = cs.current === id ? (list[Math.min(i, list.length - 1)]?.id ?? null) : cs.current;
  return { list, current };
}

export function selectConversation(cs: Conversations, id: string): Conversations {
  return cs.list.some(c => c.id === id) ? { ...cs, current: id } : cs;
}

/**
 * Endrer chatten i én samtale. Samtalen flyttes øverst når den får en ny melding, og får tittel fra
 * første melding.
 */
export function updateConversation(cs: Conversations, id: string, fn: (chat: Chat) => Chat, now: number): Conversations {
  const conv = cs.list.find(c => c.id === id);
  if (!conv) return cs;
  const chat = fn(conv.chat);
  if (chat === conv.chat) return cs;
  const firstUser = chat.items.find(i => i.kind === 'user');
  const title = conv.title === UNTITLED && firstUser?.kind === 'user' ? titleOf(firstUser.text) : conv.title;
  const next = { ...conv, chat, title, updatedAt: now };
  const moved = chat.items.length > conv.chat.items.length && chat.items.at(-1)?.kind === 'user';
  const rest = cs.list.filter(c => c.id !== id);
  return { ...cs, list: moved ? [next, ...rest] : cs.list.map(c => (c.id === id ? next : c)) };
}

/** Sender en hendelse til samtalen som eier kjøringen. `false` når ingen samtale venter på den. */
export function applyEvent(cs: Conversations, runId: string, ev: ClaudeEvent, now: number, hashes: SkillHashes = {}): Conversations | false {
  const conv = cs.list.find(c => c.chat.runId === runId);
  return conv ? updateConversation(cs, conv.id, chat => apply(chat, runId, ev, hashes), now) : false;
}


/**
 * Leser samtalene tilbake fra lagringen. Kjøringer som ikke lenger pågår i backenden (`active`),
 * ble avsluttet mens vieweren lastet inn på nytt; svaret ligger hos Claude og kommer med neste melding.
 */
export function restoreConversations(raw: unknown, active: string[]): Conversations {
  const r = raw as Partial<Conversations> | null;
  if (!r || !Array.isArray(r.list)) return NO_CONVERSATIONS;
  const list = r.list
    .filter((c): c is Conversation => !!c && typeof c.id === 'string' && !!c.chat && Array.isArray(c.chat.items))
    .map(c => {
      // `skillVersions` fra den første utgaven er versjonen på disk, ikke den som ble lastet (se `loadedVersions`)
      const { skillVersions: _old, ...rest } = c.chat as Chat & { skillVersions?: unknown };
      const chat: Chat = { ...EMPTY_CHAT, ...rest };
      if (!chat.runId || active.includes(chat.runId)) return { ...c, chat };
      const items = endPending(chat.items.map(i => (i.kind === 'tool' && i.state === 'running' ? ({ ...i, state: 'ok' } as ChatItem) : i)));
      return {
        ...c,
        chat: { ...chat, runId: null, items: [...items, { kind: 'done', ok: false, text: 'Avsluttet mens siden lastet inn på nytt. Claude husker svaret; spør videre for å se det.' } as ChatItem] },
      };
    });
  const current = list.some(c => c.id === r.current) ? r.current! : (list[0]?.id ?? null);
  return { list, current };
}

/** «59k av 1M · 6 %», eller bare «59k» når vinduet ikke er kjent */
export function contextLabel(ctx: { used: number; window: number | null }): string {
  const k = (n: number) => (n >= 1e6 ? `${+(n / 1e6).toFixed(n % 1e6 ? 1 : 0)}M` : n >= 1000 ? `${Math.round(n / 1000)}k` : String(n));
  if (!ctx.window) return k(ctx.used);
  return `${k(ctx.used)} av ${k(ctx.window)} · ${Math.min(100, Math.round((ctx.used / ctx.window) * 100))} %`;
}
