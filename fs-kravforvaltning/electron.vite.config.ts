import { defineConfig } from 'electron-vite';
import preact from '@preact/preset-vite';

/**
 * Desktop-appen (electron-vite): main-prosess, preload og renderer.
 * Rendereren er den samme vieweren som i nettleseren (index.html + src/), men startdata og hendelser
 * kommer over IPC fra main-prosessen i stedet for fra Vite-pluginen. `virtual:krav*` finnes derfor ikke her,
 * og løses til `null`; src/transport.ts bruker `window.krav` når den finnes.
 */
export default defineConfig({
  main: {
    build: {
      outDir: 'out/main',
      lib: { entry: { index: 'electron/main.ts' } },
      // isomorphic-git og @cucumber/* pakkes inn, så appen ikke trenger node_modules ved kjøring
      externalizeDeps: false,
    },
  },
  preload: {
    build: {
      outDir: 'out/preload',
      lib: { entry: { index: 'electron/preload.ts' }, formats: ['cjs'] },
    },
  },
  renderer: {
    root: '.',
    plugins: [
      preact(),
      {
        name: 'krav-virtual-stub',
        resolveId: id => (id.startsWith('virtual:krav') ? '\0' + id : undefined),
        load: id => (id.startsWith('\0virtual:krav') ? 'export default null;' : undefined),
      },
    ],
    build: {
      outDir: 'out/renderer',
      rolldownOptions: { input: 'index.html' },
    },
  },
});
