// Samtalen i Claude-panelet. Rene funksjoner over hendelsene fra core/claude.ts, så de kan testes med node --test.
import type { ClaudeEvent } from '../shared/api.ts';

export type ChatItem =
  | { kind: 'user'; text: string; path: string | null; skill?: string | null; mentions?: string[] }
  | { kind: 'assistant'; text: string }
  | { kind: 'tool'; id: string; name: string; summary: string; state: 'running' | 'ok' | 'error' }
  | { kind: 'done'; ok: boolean; text: string };

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
}

export const EMPTY_CHAT: Chat = { items: [], sessionId: null, runId: null, touched: [], skill: null, skillLoaded: null, loadedSkills: [], context: null };

const addSkill = (list: string[], s: string) => (list.includes(s) ? list : [...list, s]);

/** Neste melding i samtalen, med filene og mappene lagt ved med @. `invoke`: meldingen skal laste den valgte skillen (`/<skill>`) */
export function send(chat: Chat, text: string, path: string | null, mentions: string[] = []): { chat: Chat; invoke: boolean } {
  const invoke = !!chat.skill && chat.skill !== chat.skillLoaded;
  return {
    chat: {
      ...chat,
      skillLoaded: invoke ? chat.skill : chat.skillLoaded,
      loadedSkills: invoke && chat.skill ? addSkill(chat.loadedSkills, chat.skill) : chat.loadedSkills,
      items: [...chat.items, { kind: 'user', text, path, skill: chat.skill, ...(mentions.length ? { mentions } : {}) }],
    },
    invoke,
  };
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

const EDIT_TOOLS = ['Edit', 'Write', 'MultiEdit', 'NotebookEdit'];

/** Legger en hendelse fra kjøringen `runId` inn i samtalen; hendelser fra andre kjøringer ignoreres */
export function apply(chat: Chat, runId: string, ev: ClaudeEvent): Chat {
  if (runId !== chat.runId) return chat;
  switch (ev.kind) {
    case 'init':
      return { ...chat, sessionId: ev.sessionId };
    case 'text':
      return { ...chat, items: [...chat.items, { kind: 'assistant', text: ev.text }] };
    case 'tool': {
      const touched = EDIT_TOOLS.includes(ev.name) && ev.summary.startsWith('krav/') && !chat.touched.includes(ev.summary) ? [...chat.touched, ev.summary] : chat.touched;
      return { ...chat, touched, items: [...chat.items, { kind: 'tool', id: ev.id, name: ev.name, summary: ev.summary, state: 'running' }] };
    }
    case 'toolResult': {
      const tool = chat.items.find((i): i is Extract<ChatItem, { kind: 'tool' }> => i.kind === 'tool' && i.id === ev.id);
      const loadedSkills = tool?.name === 'Skill' && !ev.isError ? addSkill(chat.loadedSkills, tool.summary) : chat.loadedSkills;
      return {
        ...chat,
        loadedSkills,
        items: chat.items.map(i => (i.kind === 'tool' && i.id === ev.id ? { ...i, state: ev.isError ? 'error' : 'ok' } : i)),
      };
    }
    case 'usage':
      return { ...chat, context: { used: ev.tokens, window: chat.context?.window ?? null } };
    case 'done': {
      const secs = ev.durationMs != null ? ` · ${(ev.durationMs / 1000).toFixed(1)} s` : '';
      const text = ev.ok ? `Ferdig${ev.turns != null ? ` · ${ev.turns} steg` : ''}${secs}` : ev.error ?? 'Feil';
      // Verktøy som aldri fikk svar (avbrutt eller feil) er ikke lenger i gang
      const items = chat.items.map(i => (i.kind === 'tool' && i.state === 'running' ? { ...i, state: ev.ok ? 'ok' : 'error' } as ChatItem : i));
      const context = chat.context && ev.contextWindow ? { ...chat.context, window: ev.contextWindow } : chat.context;
      return { ...chat, runId: null, context, sessionId: ev.sessionId ?? chat.sessionId, items: [...items, { kind: 'done', ok: ev.ok, text }] };
    }
  }
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
};

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

/** Ny, tom samtale øverst, og åpen, med `skill` valgt. En tom samtale som allerede finnes, gjenbrukes. */
export function createConversation(cs: Conversations, id: string, now: number, skill: string | null = null): Conversations {
  const empty = cs.list.find(c => !c.chat.items.length && !c.chat.runId);
  if (empty) return { ...cs, current: empty.id };
  return { list: [{ id, title: UNTITLED, createdAt: now, updatedAt: now, chat: { ...EMPTY_CHAT, skill } }, ...cs.list], current: id };
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
export function applyEvent(cs: Conversations, runId: string, ev: ClaudeEvent, now: number): Conversations | false {
  const conv = cs.list.find(c => c.chat.runId === runId);
  return conv ? updateConversation(cs, conv.id, chat => apply(chat, runId, ev), now) : false;
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
      const chat = { ...EMPTY_CHAT, ...c.chat };
      if (!chat.runId || active.includes(chat.runId)) return { ...c, chat };
      const items = chat.items.map(i => (i.kind === 'tool' && i.state === 'running' ? ({ ...i, state: 'ok' } as ChatItem) : i));
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
