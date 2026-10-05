import { existsSync } from 'node:fs';
import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { app, BrowserWindow, dialog, ipcMain, nativeTheme, safeStorage, shell } from 'electron';
import type { Boot } from '../shared/api.ts';
import { createApi, dispatch } from '../core/api.ts';
import { createAuth, type TokenStore } from '../core/auth.ts';
import { ClaudeRunner } from '../core/claude.ts';
import { ensureClone, isoVcs } from '../core/vcs-isogit.ts';
import { modeOn, Workspace, type WorkspaceEvent } from '../core/workspace.ts';

/**
 * Desktop-appen (FS Kravforvaltning): vieweren med redigering og PR, uten at git må være installert.
 *
 * Ved første oppstart klones repoet (grunn klone av main) til appens datamappe med isomorphic-git.
 * Main-prosessen kjører den samme kjernen som dev-serveren (core/), og rendereren snakker med den
 * over IPC via preload-broen (`window.krav`). Innlogging mot GitHub skjer med device flow, og tokenet
 * lagres kryptert med safeStorage.
 *
 * Miljøvariabler:
 * - `KRAV_REPO`: bruk en eksisterende klone i stedet for appens egen (f.eks. dette repoet under utvikling)
 * - `KRAV_REPO_URL`: repoet som klones (standard https://github.com/sikt-no/fs.git)
 * - `KRAV_GITHUB_CLIENT_ID`: OAuth-appen for device flow (kan også bakes inn ved bygg med MAIN_VITE_KRAV_GITHUB_CLIENT_ID)
 * - `OPPGAVER=1`: vis Oppgaver-modusen (eller bygg/start med `--mode oppgaver`, f.eks. `npm run app:dev:oppgaver`)
 * - `SPESIFIKASJONER=1`: vis Spesifikasjoner (eller `--mode spesifikasjoner`, f.eks. `npm run app:dev:spesifikasjoner`; begge: `--mode oppgaver+spesifikasjoner`)
 * - `KRAV_CLAUDE_PATH`: stien til `claude`, hvis den ikke finnes på vanlige steder
 */

const REPO_URL = process.env.KRAV_REPO_URL || 'https://github.com/sikt-no/fs.git';
const CLIENT_ID = process.env.KRAV_GITHUB_CLIENT_ID || import.meta.env.MAIN_VITE_KRAV_GITHUB_CLIENT_ID || null;
const here = fileURLToPath(new URL('.', import.meta.url));

/** Tokenet fra device flow, kryptert med operativsystemets nøkkelring (Keychain, DPAPI, libsecret) */
function safeStore(file: string): TokenStore {
  let cached: string | null | undefined;
  return {
    async get() {
      if (cached !== undefined) return cached;
      try {
        cached = safeStorage.decryptString(await readFile(file));
      } catch {
        cached = null;
      }
      return cached;
    },
    async set(token) {
      cached = token;
      if (!token) return void (await rm(file, { force: true }));
      if (!safeStorage.isEncryptionAvailable()) return; // bare i minnet, må logge inn på nytt ved neste start
      await writeFile(file, safeStorage.encryptString(token), { mode: 0o600 });
    },
  };
}

let win: BrowserWindow | null = null;
const send = (event: string, data?: unknown) => win?.webContents.send('krav:event', event, data);

/** Klonen er klar og arbeidsflaten lest; rendereren venter på denne før den tegner */
const ready = (async () => {
  await app.whenReady();
  const dir = process.env.KRAV_REPO ? resolve(process.env.KRAV_REPO) : join(app.getPath('userData'), 'repo');
  const store = safeStore(join(app.getPath('userData'), 'github-token.bin'));
  if (!existsSync(join(dir, '.git'))) {
    await mkdir(dir, { recursive: true });
    send('krav:progress', 'Henter kravene fra GitHub …');
    await ensureClone(dir, REPO_URL, await store.get(), msg => send('krav:progress', `Henter kravene fra GitHub: ${msg}`));
  }
  const mode = import.meta.env.MODE;
  const ws = new Workspace(dir, isoVcs(dir), { oppgaver: modeOn(mode, 'oppgaver'), spesifikasjoner: modeOn(mode, 'spesifikasjoner') });
  await ws.readAll();
  for (const event of ['krav:update', 'krav:git', 'krav:tasks'] as WorkspaceEvent[]) ws.on(event, data => send(event, data));
  ws.watch();
  // Repoet er appens egen klone, så kodeklonene ligger ikke ved siden av; brukeren velger dem under «Kodemapper»
  const claude = new ClaudeRunner(dir, { siblingDirs: false, onSaved: () => ws.refreshGit(), onDone: () => ws.refreshGit() });
  claude.on(data => send('krav:claude', data));
  app.on('before-quit', () => {
    ws.close();
    claude.close();
  });
  const api = createApi(ws, createAuth({ clientId: CLIENT_ID, store }), claude);
  api.pickDir = async () => {
    const opts = { title: 'Velg kodemappe', properties: ['openDirectory' as const] };
    const r = await (win ? dialog.showOpenDialog(win, opts) : dialog.showOpenDialog(opts));
    return r.canceled ? null : (r.filePaths[0] ?? null);
  };
  return api;
})();

ipcMain.handle('krav:boot', async (): Promise<Boot | { error: string }> => {
  try {
    return (await ready).boot();
  } catch (e) {
    return { error: e instanceof Error ? e.message : String(e) };
  }
});

ipcMain.handle('krav:invoke', async (_e, method: string, arg: unknown) => {
  try {
    return { ok: true, value: (await dispatch(await ready, method, arg)) ?? null };
  } catch (e) {
    return { ok: false, error: e instanceof Error ? e.message : String(e) };
  }
});

function createWindow() {
  win = new BrowserWindow({
    width: 1400,
    height: 900,
    title: 'FS Kravforvaltning',
    // Samme bakgrunn som vieweren (--bg i theme.css), så vinduet ikke er hvitt før siden er tegnet
    backgroundColor: nativeTheme.shouldUseDarkColors ? '#141415' : '#f7f7f6',
    webPreferences: { preload: join(here, '../preload/index.cjs'), contextIsolation: true, sandbox: true },
  });
  // Lenker (GitHub, PR-er, innlogging) åpnes i nettleseren, ikke i appen
  win.webContents.setWindowOpenHandler(({ url }) => {
    if (/^https?:/.test(url)) void shell.openExternal(url);
    return { action: 'deny' };
  });
  win.webContents.on('will-navigate', (e, url) => {
    if (url.startsWith('http') && !url.startsWith(process.env.ELECTRON_RENDERER_URL ?? '\0')) {
      e.preventDefault();
      void shell.openExternal(url);
    }
  });
  if (process.env.ELECTRON_RENDERER_URL) void win.loadURL(process.env.ELECTRON_RENDERER_URL);
  else void win.loadFile(join(here, '../renderer/index.html'));
  win.on('closed', () => (win = null));
}

app.whenReady().then(() => {
  createWindow();
  app.on('activate', () => BrowserWindow.getAllWindows().length === 0 && createWindow());
});
app.on('window-all-closed', () => process.platform !== 'darwin' && app.quit());
