import { mkdir, writeFile } from 'node:fs/promises';
import { dirname, isAbsolute, join, resolve, sep } from 'node:path';

/**
 * Absolutt sti for en krav-fil som skal skrives. Stien er relativ til repo-roten, må ligge under krav/,
 * og være en `.feature`- eller `.md`-fil. Kaster ved alt annet (`..`, absolutte stier, andre filtyper).
 */
export function kravPath(repoRoot: string, path: string): string {
  if (typeof path !== 'string' || !path || isAbsolute(path) || path.includes('\\') || path.split('/').some(s => s === '..' || s === '.' || s === '')) {
    throw new Error(`Ugyldig sti: ${path}`);
  }
  if (!path.endsWith('.feature') && !path.endsWith('.md')) throw new Error(`Bare .feature- og .md-filer kan redigeres: ${path}`);
  const kravDir = join(repoRoot, 'krav');
  const abs = resolve(repoRoot, path);
  if (!abs.startsWith(kravDir + sep)) throw new Error(`Filen må ligge under krav/: ${path}`);
  return abs;
}

/** Skriver fila. Watcheren (Vite eller Workspace.watch) plukker opp endringen og sender `krav:update`. */
export async function saveFile(repoRoot: string, path: string, text: string) {
  if (typeof text !== 'string') throw new Error('Mangler tekst');
  const abs = kravPath(repoRoot, path);
  await mkdir(dirname(abs), { recursive: true });
  await writeFile(abs, text, 'utf8');
}
