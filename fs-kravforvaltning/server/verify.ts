import { existsSync, readdirSync, readFileSync, statSync } from 'node:fs';
import { join, sep } from 'node:path';
import { htmlOf, isVerifyReport, VERIFY_ROOTS, type VerifySnapshot } from '../shared/verify.ts';

/**
 * Leser verify-rapportene (`verify-*.md`) i krav/, tasks/ og akseptansetest/, med teksten, og om rapportvisningen
 * (`verify-*.html`) ligger ved siden av. HTML-fila leses først når den vises (kallet `readReport`).
 */
export function readVerify(repoRoot: string): VerifySnapshot {
  const out: VerifySnapshot = {};
  for (const root of VERIFY_ROOTS) {
    const dir = join(repoRoot, root);
    if (!existsSync(dir)) continue;
    for (const f of readdirSync(dir, { recursive: true, encoding: 'utf8' })) {
      const path = `${root}/${f.split(sep).join('/')}`;
      if (path.split('/').some(s => s.startsWith('.') || s === 'node_modules') || !isVerifyReport(path)) continue;
      const abs = join(repoRoot, path);
      try {
        const html = htmlOf(path);
        const htmlAbs = join(repoRoot, html);
        const has = existsSync(htmlAbs);
        out[path] = {
          path,
          source: readFileSync(abs, 'utf8'),
          html: has ? html : null,
          savedAt: statSync(abs).mtimeMs,
          htmlAt: has ? statSync(htmlAbs).mtimeMs : null,
        };
      } catch {
        /* fila forsvant mens mappa ble lest; neste hendelse leser på nytt */
      }
    }
  }
  return out;
}
