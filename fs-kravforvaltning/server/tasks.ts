import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs';
import { join, sep } from 'node:path';
import type { RawTask, TasksSnapshot } from '../shared/tasks.ts';

/** Filene serveren sender innholdet til (for planer bare boks-linjene); resten sendes bare som stier */
const withSource = (f: string) =>
  f === 'oppgave.md' || f === 'utforing.md' || /^reviews\/[^/]+\.md$/.test(f) || /^[^/]+\/plan-[^/]+\.md$/.test(f) || isSpecDoc(f) || /^spec\/verify-[^/]+\.md$/.test(f);
/** Spesifikasjonene fra fs-specify og fs-specify-delta */
const isSpecDoc = (f: string) => /^spec\/spec-[^/]+\.md$/.test(f);

const dirs = (abs: string) =>
  readdirSync(abs, { withFileTypes: true })
    .filter(d => d.isDirectory() && !d.name.startsWith('.'))
    .map(d => d.name)
    .sort();

function readTask(abs: string, dom: string, slug: string): RawTask {
  const files = readdirSync(abs, { recursive: true, encoding: 'utf8' })
    .map(f => f.split(sep).join('/'))
    .filter(f => !f.split('/').some(p => p.startsWith('.')) && statSync(join(abs, f)).isFile())
    .sort();
  const sources: Record<string, string> = {};
  const mtimes: Record<string, number> = {};
  for (const f of files.filter(isSpecDoc)) mtimes[f] = statSync(join(abs, f)).mtimeMs;
  for (const f of files.filter(withSource)) {
    const src = readFileSync(join(abs, f), 'utf8');
    // Av planene trengs bare avkrysningsboksene; resten av teksten ville bare gjort bygget større
    sources[f] = f.includes('/plan-') ? src.split('\n').filter(l => /^\s*[-*+]\s+\[[ xX]\]/.test(l)).join('\n') : src;
  }
  return { dom, slug, files, sources, mtimes };
}

/**
 * Leser tasks/: én oppføring per domenemappe (med roadmap.md) og én per oppgavemappe under den.
 * Undermapper i mal/ tas med som oppgaver i domenet «mal», slik at regel 4 kan slå ut på dem.
 * Tolkningen skjer i shared/tasks.ts.
 */
export function readTasks(repoRoot: string): TasksSnapshot {
  const root = join(repoRoot, 'tasks');
  const snap: TasksSnapshot = { domains: {}, tasks: [] };
  if (!existsSync(root)) return snap;
  for (const dom of dirs(root)) {
    const domAbs = join(root, dom);
    if (dom !== 'mal') {
      const roadmap = join(domAbs, 'roadmap.md');
      snap.domains[dom] = existsSync(roadmap) ? readFileSync(roadmap, 'utf8') : null;
    }
    for (const slug of dirs(domAbs)) snap.tasks.push(readTask(join(domAbs, slug), dom, slug));
  }
  return snap;
}
