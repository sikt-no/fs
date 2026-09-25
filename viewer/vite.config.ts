import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vite';
import preact from '@preact/preset-vite';
import { kravPlugin } from './server/kravPlugin.ts';

const repoRoot = fileURLToPath(new URL('..', import.meta.url));

export default defineConfig({
  plugins: [preact(), kravPlugin(repoRoot)],
  // Relative stier, så bygget fungerer under en understi (GitHub Pages: /fs/)
  base: './',
  // Hele krav/-snapshotet bygges inn i bundelen ved statisk bygg
  build: { chunkSizeWarningLimit: 2000 },
  server: {
    port: 5173,
    fs: { allow: [repoRoot] },
  },
});
