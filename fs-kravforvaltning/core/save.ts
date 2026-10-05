import { mkdir, unlink, writeFile } from 'node:fs/promises';
import { dirname, isAbsolute, join, resolve, sep } from 'node:path';
import { isKravPath, isSketchFile, isSpecPath } from '../shared/paths.ts';

/**
 * Absolutt sti for en fil som skal skrives. Stien er relativ til repo-roten, og må være en `.feature`- eller
 * `.md`-fil under krav/, eller en spesifikasjon eller tilstandsfil under tasks/ (`tasks/<d>/<s>/spec/spec-*.md`,
 * `tasks/<d>/<s>/utforing.md`). Kaster ved alt annet (`..`, absolutte stier, andre filtyper og mapper).
 */
export function kravPath(repoRoot: string, path: string): string {
  if (typeof path !== 'string' || !path || isAbsolute(path) || path.includes('\\') || path.split('/').some(s => s === '..' || s === '.' || s === '')) {
    throw new Error(`Ugyldig sti: ${path}`);
  }
  if (path.startsWith('tasks/')) {
    if (!isSpecPath(path)) throw new Error(`Under tasks/ kan bare spec/spec-*.md og utforing.md redigeres: ${path}`);
  } else if (!path.endsWith('.feature') && !path.endsWith('.md')) throw new Error(`Bare .feature- og .md-filer kan redigeres: ${path}`);
  const top = join(repoRoot, path.startsWith('tasks/') ? 'tasks' : 'krav');
  const abs = resolve(repoRoot, path);
  if (!abs.startsWith(top + sep) || (!path.startsWith('tasks/') && !isKravPath(path))) throw new Error(`Filen må ligge under krav/: ${path}`);
  return abs;
}

/** Skriver fila. Watcheren (Vite eller Workspace.watch) plukker opp endringen og sender `krav:update` (eller `krav:tasks`). */
export async function saveFile(repoRoot: string, path: string, text: string) {
  if (typeof text !== 'string') throw new Error('Mangler tekst');
  const abs = kravPath(repoRoot, path);
  await mkdir(dirname(abs), { recursive: true });
  await writeFile(abs, text, 'utf8');
}

/** Sletter fila. Watcheren sender `krav:update` uten entry, og slettingen kommer med i «Lag PR» som andre endringer. */
export async function deleteFile(repoRoot: string, path: string) {
  await unlink(kravPath(repoRoot, path));
}

/**
 * Skriver et bilde fra `save_sketch` i Claude-panelet. Stien må være `isSketchFile` (`tasks/<d>/<s>/spec/krav-input/…/sketches/…`
 * eller `tasks/<d>/<s>/spec/verify-<dato>/…`); bildene redigeres ikke som tekst, så `kravPath` tar dem ikke.
 */
export async function saveSketch(repoRoot: string, path: string, bytes: Uint8Array) {
  if (!isSketchFile(path)) {
    throw new Error(
      `Bilder lagres under tasks/<domene>/<slug>/spec/krav-input/sketches/ (eller krav-input/changes/<dato>-<ref>/sketches/), eller tasks/<domene>/<slug>/spec/verify-<dato>/ for skjermbilder fra fs-verify, som .png, .jpg eller .webp: ${path}`,
    );
  }
  const abs = resolve(repoRoot, path);
  if (!abs.startsWith(join(repoRoot, 'tasks') + sep)) throw new Error(`Ugyldig sti: ${path}`);
  await mkdir(dirname(abs), { recursive: true });
  await writeFile(abs, bytes);
}
