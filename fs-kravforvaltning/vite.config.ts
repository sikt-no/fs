import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { defineConfig, type Plugin } from 'vite';
import preact from '@preact/preset-vite';
import { kravPlugin } from './server/kravPlugin.ts';
import { modeOn } from './core/workspace.ts';
import { STATIC_PAGES } from './src/markdown.ts';

const repoRoot = fileURLToPath(new URL('..', import.meta.url));

/** HTML-sidene i rota av repoet (kom-i-gang.html) serveres i dev, og legges ved siden av index.html i bygget */
function staticPages(): Plugin {
  const read = (page: string) => readFileSync(join(repoRoot, page));
  return {
    name: 'krav-static-pages',
    configureServer(server) {
      for (const page of STATIC_PAGES) {
        server.middlewares.use('/' + page, (_req, res) => {
          res.setHeader('Content-Type', 'text/html; charset=utf-8');
          res.end(read(page));
        });
      }
    },
    generateBundle() {
      for (const page of STATIC_PAGES) this.emitFile({ type: 'asset', fileName: page, source: read(page) });
    },
  };
}

export default defineConfig(({ mode }) => ({
  // Oppgaver og Spesifikasjoner (tasks/) er skjult med mindre de slås på: `npm run dev:oppgaver`,
  // `npm run dev:spesifikasjoner`, `--mode oppgaver+spesifikasjoner`, eller OPPGAVER=1 / SPESIFIKASJONER=1
  plugins: [preact(), staticPages(), kravPlugin(repoRoot, { oppgaver: modeOn(mode, 'oppgaver'), spesifikasjoner: modeOn(mode, 'spesifikasjoner') })],
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
