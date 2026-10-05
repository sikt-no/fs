import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vite';
import preact from '@preact/preset-vite';
import { kravPlugin } from './server/kravPlugin.ts';
import { modeOn } from './core/workspace.ts';

const repoRoot = fileURLToPath(new URL('..', import.meta.url));

export default defineConfig(({ mode }) => ({
  // Oppgaver og Spesifikasjoner (tasks/) er skjult med mindre de slås på: `npm run dev:oppgaver`,
  // `npm run dev:spesifikasjoner`, `--mode oppgaver+spesifikasjoner`, eller OPPGAVER=1 / SPESIFIKASJONER=1
  plugins: [preact(), kravPlugin(repoRoot, { oppgaver: modeOn(mode, 'oppgaver'), spesifikasjoner: modeOn(mode, 'spesifikasjoner') })],
  // Relative stier, så bygget fungerer under en understi (GitHub Pages: /fs/)
  base: './',
  // Hele krav/-snapshotet bygges inn i bundelen ved statisk bygg
  build: { chunkSizeWarningLimit: 2000 },
  server: {
    // Fast port: localStorage (samtaler, sist viste fil) lagres per origin
    port: 5173,
    strictPort: true,
    fs: { allow: [repoRoot] },
  },
}));
