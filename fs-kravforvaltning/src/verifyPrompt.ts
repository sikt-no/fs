// Promptene til fs-verify fra knappene i vieweren. Rene funksjoner, testet i verifyPrompt.test.ts.
import { statusOf, type Entry } from '../shared/model.ts';
import { featureId } from './specboard.ts';

/** Linja om skjermbilder: fs-verify spør ikke når den står i prompten. Adressen (test-fsadmin) står i skillen */
export const screenshotLine = (on: boolean) => (on ? 'Ta skjermbilder av scenarioene som har en skjerm.' : 'Ingen skjermbilder.');

/** Hva «Verifiser» gjelder: hele egenskapen, eller regelen med indeksen i `model.rules` */
export type VerifyScope = { kind: 'feature' } | { kind: 'rule'; index: number };

const tag = (s: string | null) => (s ? `@${s}` : 'ingen statustag');

/**
 * «Verifiser» på en egenskap eller en regel i feature-visningen: fs-verify i modusen *Verifisere uansett status*.
 * `screenshots`: valget «Ta skjermbilder» (utelatt: fs-verify spør). `null` når regelen ikke finnes.
 */
export function verifyKravPrompt(e: Entry, scope: VerifyScope, screenshots?: boolean): string | null {
  const f = e.model;
  if (!f) return null;
  const id = featureId(e);
  const file = `${e.path}${id ? ` (${id})` : ''}`;
  const feature = `Status på Egenskap: ${tag(statusOf(f.tags))}.`;
  const lines: string[] = [];
  if (scope.kind === 'feature') {
    lines.push(`Verifiser egenskapen «${f.title}» i ${file} uansett status (se «Verifisere uansett status» i fs-verify).`, feature);
  } else {
    const r = f.rules[scope.index];
    if (!r || r.name === null) return null;
    const own = statusOf(r.tags);
    lines.push(
      `Verifiser regelen «${r.name}» (linje ${r.ln}) i ${file} uansett status (se «Verifisere uansett status» i fs-verify).`,
      `Status på regelen: ${own ? `@${own}` : 'ingen egen statustag (arver fra egenskapen)'}. ${feature}`,
    );
  }
  if (screenshots !== undefined) lines.push(screenshotLine(screenshots));
  return lines.join('\n');
}
