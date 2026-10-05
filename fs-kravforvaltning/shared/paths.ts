// Filene vieweren kan skrive, vise som endringer og sende med «Lag PR»: kravene, og spesifikasjonene og
// tilstandsfila under tasks/ (Spesifikasjoner-visningen). Felles for core/, server/ og rendereren.

/** Krav-fil: `.feature` eller `.md` under krav/ */
export const isKravPath = (p: string) => p.startsWith('krav/') && (p.endsWith('.feature') || p.endsWith('.md'));

/** `tasks/<domene>/<slug>/utforing.md` eller `tasks/<domene>/<slug>/spec/spec-*.md` (også `spec-changes-*.md`) */
export const isSpecPath = (p: string) => /^tasks\/[^/]+\/[^/]+\/(utforing\.md|spec\/spec-[^/]+\.md)$/.test(p);

/** En sti vieweren kan skrive og ta med i en PR, relativt til repo-roten, uten `.`, `..` eller tomme ledd */
export const isEditablePath = (p: string) =>
  typeof p === 'string' && !p.includes('\\') && !p.split('/').some(s => s === '..' || s === '.' || s === '') && (isKravPath(p) || isSpecPath(p));
