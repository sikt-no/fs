import { contextBridge, ipcRenderer } from 'electron';

/**
 * Broen mellom rendereren og main-prosessen i desktop-appen, lagt på `window.krav`.
 * Formen er `KravBridge` i src/transport.ts; rendereren bruker den via `transport`.
 */
const listeners = new Map<string, Set<(data: unknown) => void>>();
ipcRenderer.on('krav:event', (_e, event: string, data: unknown) => {
  // Framdrift mens repoet klones første gang, før vieweren er tegnet
  if (event === 'krav:progress') {
    const el = document.getElementById('boot');
    if (el) el.textContent = String(data);
  }
  listeners.get(event)?.forEach(fn => fn(data));
});

contextBridge.exposeInMainWorld('krav', {
  async boot() {
    const res = await ipcRenderer.invoke('krav:boot');
    if (res && 'error' in res) {
      const el = document.getElementById('boot');
      if (el) el.textContent = `Kunne ikke starte: ${res.error}`;
      throw new Error(res.error);
    }
    return res;
  },
  invoke: (method: string, arg?: unknown) => ipcRenderer.invoke('krav:invoke', method, arg),
  on(event: string, fn: (data: unknown) => void) {
    if (!listeners.has(event)) listeners.set(event, new Set());
    listeners.get(event)!.add(fn);
    return () => void listeners.get(event)?.delete(fn);
  },
});
