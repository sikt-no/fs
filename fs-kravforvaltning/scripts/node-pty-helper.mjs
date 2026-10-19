// node-pty 1.1 kommer med ferdigbygde binærfiler, men `spawn-helper` er ikke kjørbar etter `npm install` (og
// installasjonsskriptet til node-pty kjører ikke når npm ikke tillater det). Uten kjørbar spawn-helper feiler alle
// terminaløkter med «posix_spawnp failed». Kjøres som `postinstall`; core/pty.ts prøver det samme når appen kjører.
import { chmodSync, existsSync, statSync } from 'node:fs';
import { join } from 'node:path';

if (process.platform !== 'win32') {
  const root = join(import.meta.dirname, '..', 'node_modules', 'node-pty');
  for (const sub of ['build/Release', `prebuilds/${process.platform}-${process.arch}`]) {
    const f = join(root, sub, 'spawn-helper');
    if (existsSync(f)) chmodSync(f, statSync(f).mode | 0o111);
  }
}
