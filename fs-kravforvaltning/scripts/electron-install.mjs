// Electron-pakken har bare JavaScript-delen: selve programmet lastes ned av `node_modules/electron/install.js`, som er
// installasjonsskriptet til pakken. Det kjører ikke når npm ikke tillater installasjonsskript for avhengigheter
// (npm 11 med `allow-scripts`), og da feiler `npm run app:dev` med «Electron uninstall». Kjøres som `postinstall`.
// install.js gjør ingenting når riktig versjon allerede ligger i `dist/`. Feiler nedlastingen, stopper ikke installasjonen:
// nettleserversjonen (`npm run dev`) trenger ikke Electron.
import { spawnSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import { join } from 'node:path';

const install = join(import.meta.dirname, '..', 'node_modules', 'electron', 'install.js');
if (existsSync(install) && !process.env.ELECTRON_SKIP_BINARY_DOWNLOAD) {
  const r = spawnSync(process.execPath, [install], { stdio: 'inherit' });
  if (r.status !== 0) console.warn('Klarte ikke å laste ned Electron. Kjør `node node_modules/electron/install.js` før `npm run app:dev`.');
}
