import initial from 'virtual:krav';
import initialGit from 'virtual:krav-git';
import initialTasks from 'virtual:krav-tasks';
import repoRoot from 'virtual:krav-root';
import type { Api, ApiMethod, Boot } from '../shared/api';

/** Hendelsene backenden sender til rendereren */
export type KravEvent = 'krav:update' | 'krav:git' | 'krav:tasks' | 'krav:focus' | 'krav:blur' | 'krav:claude' | 'krav:pty' | 'krav:connect' | 'krav:disconnect';

/** Broen preload-skriptet i desktop-appen legger på `window.krav` (se electron/preload.ts) */
export interface KravBridge {
  boot(): Promise<Boot>;
  invoke(method: ApiMethod, arg?: unknown): Promise<{ ok: true; value: unknown } | { ok: false; error: string }>;
  on(event: string, fn: (data: unknown) => void): () => void;
}
declare global {
  interface Window {
    krav?: KravBridge;
  }
}

/**
 * Forbindelsen til backenden. Komponentene bruker bare denne, så de er like i nettleseren og i desktop-appen:
 * - `vite`: dev-serveren, med Vites websocket for hendelser og `POST /__krav/api/<kall>` for kall
 * - `static`: bygget på GitHub Pages; snapshotet er bakt inn, ingen hendelser og ingen redigering
 * - `electron`: desktop-appen, med IPC via `window.krav`
 */
export interface Transport {
  kind: 'vite' | 'static' | 'electron';
  /** Oppdateres visningen når filer endres? */
  live: boolean;
  boot(): Promise<Boot>;
  on(event: KravEvent, fn: (data: any) => void): () => void;
  call<M extends ApiMethod>(method: M, ...arg: Parameters<Api[M]>): ReturnType<Api[M]>;
}

function electron(bridge: KravBridge): Transport {
  return {
    kind: 'electron',
    live: true,
    boot: () => bridge.boot(),
    on: (event, fn) => bridge.on(event, fn),
    call: ((method: ApiMethod, arg?: unknown) =>
      bridge.invoke(method, arg).then(r => {
        if (!r.ok) throw new Error(r.error);
        return r.value;
      })) as Transport['call'],
  };
}

function vite(): Transport {
  const hot = import.meta.hot;
  // Vites egne hendelser for websocket-forbindelsen, under felles navn
  const alias: Partial<Record<KravEvent, string>> = { 'krav:connect': 'vite:ws:connect', 'krav:disconnect': 'vite:ws:disconnect' };
  return {
    kind: hot ? 'vite' : 'static',
    live: !!hot,
    boot: async () => ({ entries: initial, git: initialGit, tasks: initialTasks, editable: !!hot, repoRoot: hot ? repoRoot : null }),
    on(event, fn) {
      if (!hot) return () => {};
      const name = alias[event] ?? event;
      hot.on(name, fn);
      return () => hot.off(name, fn);
    },
    call: (async (method: ApiMethod, arg?: unknown) => {
      if (!hot) throw new Error('Redigering er bare tilgjengelig lokalt');
      const res = await fetch(`/__krav/api/${method}`, {
        method: 'POST',
        headers: { 'content-type': 'application/json' },
        body: arg === undefined ? '' : JSON.stringify(arg),
      });
      const data = (await res.json().catch(() => null)) as { ok: boolean; value?: unknown; error?: string } | null;
      if (!data?.ok) throw new Error(data?.error ?? `Serveren svarte ${res.status}`);
      return data.value;
    }) as Transport['call'],
  };
}

export const transport: Transport = typeof window !== 'undefined' && window.krav ? electron(window.krav) : vite();
