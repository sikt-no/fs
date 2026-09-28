import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vite';
import preact from '@preact/preset-vite';
import { kravPlugin } from './server/kravPlugin.ts';

const repoRoot = fileURLToPath(new URL('..', import.meta.url));

export default defineConfig(({ mode }) => ({
  // Oppgaver-modusen (tasks/) er skjult med mindre den slås på: `npm run dev:oppgaver`,
  // `npm run dev -- --mode oppgaver` eller miljøvariabelen OPPGAVER=1
  plugins: [preact(), kravPlugin(repoRoot, { oppgaver: mode === 'oppgaver' || process.env.OPPGAVER === '1' })],
  // Relative stier, så bygget fungerer under en understi (GitHub Pages: /fs/)
  base: './',
  // Hele krav/-snapshotet bygges inn i bundelen ved statisk bygg
  build: { chunkSizeWarningLimit: 2000 },
  server: {
    port: 5173,
    fs: { allow: [repoRoot] },
  },
}));
