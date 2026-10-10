import { app } from 'electron';
import electronUpdater from 'electron-updater';
import { latestReleaseTag, type Release } from '../shared/appUpdate.ts';

const { autoUpdater } = electronUpdater;

const RELEASES = 'https://api.github.com/repos/sikt-no/fs/releases?per_page=50';
const DOWNLOAD = 'https://github.com/sikt-no/fs/releases/download';
const INTERVAL_MS = 4 * 60 * 60_000;

/**
 * Oppdaterer desktop-appen fra GitHub-releasene med electron-updater. Ved oppstart og hver fjerde time finnes den
 * nyeste releasen av appen (filtrert på tagg-prefikset, se shared/appUpdate.ts), og `latest-mac.yml` (eller
 * `latest.yml` / `latest-linux.yml`) i den releasen leses. Er versjonen nyere, lastes den ned i bakgrunnen, og
 * `onDownloaded` får versjonen. Den installeres når appen avsluttes, eller med `installUpdate()`.
 *
 * Bare i den pakkede appen. `KRAV_UPDATE_URL` peker på en mappe med `latest-mac.yml` og filene i stedet for
 * GitHub-releasen (for å teste oppdateringen lokalt, se docs/release.md).
 */
export function startUpdater(onDownloaded: (version: string) => void) {
  if (!app.isPackaged) return;
  autoUpdater.autoDownload = true;
  autoUpdater.autoInstallOnAppQuit = true;
  // electron-updater logger hele HTTP-svaret ved feil; vi logger én linje selv
  autoUpdater.logger = null;
  autoUpdater.on('update-downloaded', info => {
    console.log(`Ny versjon lastet ned: ${info.version}`);
    onDownloaded(info.version);
  });
  // Feilen kommer også fra checkForUpdates() og logges der. Uten lytter kaster EventEmitter
  autoUpdater.on('error', () => {});
  const check = async () => {
    try {
      const url = process.env.KRAV_UPDATE_URL || (await feedUrl());
      if (!url) return;
      autoUpdater.setFeedURL({ provider: 'generic', url });
      await autoUpdater.checkForUpdates();
    } catch (e) {
      // Uten nett, når GitHub ikke svarer, eller når releasen er fra før appen kunne oppdatere seg selv (ingen
      // latest-mac.yml): ikke noe å melde, vi prøver igjen neste gang
      console.warn('Fant ingen oppdatering:', (e instanceof Error ? e.message : String(e)).split('\n')[0]);
    }
  };
  void check();
  setInterval(check, INTERVAL_MS);
}

/** Mappa med filene til den nyeste releasen av appen på GitHub */
async function feedUrl(): Promise<string | null> {
  const res = await fetch(RELEASES, { headers: { accept: 'application/vnd.github+json' } });
  if (!res.ok) throw new Error(`GitHub svarte ${res.status}`);
  const tag = latestReleaseTag((await res.json()) as Release[]);
  return tag && `${DOWNLOAD}/${tag}`;
}

/** Avslutter appen og installerer versjonen som er lastet ned */
export function installUpdate() {
  autoUpdater.quitAndInstall();
}
