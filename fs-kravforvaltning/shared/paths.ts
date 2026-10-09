// Filene vieweren kan skrive, vise som endringer og sende med «Lag PR»: kravene, spesifikasjonene og
// tilstandsfila under tasks/ (Spesifikasjoner-visningen), og skissene fra save_sketch. Felles for core/, server/ og rendereren.

/** Krav-fil: `.feature` eller `.md` under krav/ */
export const isKravPath = (p: string) => p.startsWith('krav/') && (p.endsWith('.feature') || p.endsWith('.md'));

/** `tasks/<domene>/<slug>/utforing.md` eller `tasks/<domene>/<slug>/spec/spec-*.md` (også `spec-changes-*.md`) */
export const isSpecPath = (p: string) => /^tasks\/[^/]+\/[^/]+\/(utforing\.md|spec\/spec-[^/]+\.md)$/.test(p);

/**
 * Bilde i en oppgave: skisse fra fs-specify eller fs-specify-delta (`tasks/<d>/<s>/spec/krav-input/sketches/…` eller
 * `tasks/<d>/<s>/spec/krav-input/changes/<dato>-<ref>/sketches/…`, også i undermapper som `figma/<slug>/sub-frames/`),
 * eller skjermbilde fra fs-verify (`tasks/<d>/<s>/spec/verify-<dato>-<HHMM>/…`, ved siden av `verify-<dato>-<HHMM>.md`).
 * Skrives av `save_sketch` i Claude-panelet (core/approve.ts), og kan sendes med «Lag PR», men ikke redigeres som tekst.
 */
export const isSketchPath = (p: string) =>
  /^tasks\/[^/]+\/[^/]+\/spec\/(krav-input\/(changes\/[^/]+\/)?sketches|verify-[^/]+)\/([^/]+\/)*[^/]+\.(png|jpe?g|webp)$/i.test(p);

/**
 * Det `fs-specify`, `fs-specify-delta` og `fs-verify` skriver i oppgavemappas `spec/`: spesifikasjonen, `spec.log.md`,
 * `questions-*.md`, `verify-*.md`, og `krav-input/` (manifest, Figma-artefakter og skisser, og råkopier av kravene i eldre oppgaver).
 * Kan sendes med «Lag PR», men bare `isSpecPath` kan redigeres i vieweren.
 */
export const isTaskSpecFile = (p: string) => /^tasks\/[^/]+\/[^/]+\/spec\/([^/]+\/)*[^/]+\.(md|feature|json|txt|png|jpe?g|webp)$/i.test(p);

const cleanPath = (p: string) => typeof p === 'string' && !p.includes('\\') && !p.split('/').some(s => s === '..' || s === '.' || s === '');

/** En sti vieweren kan vise som endring og ta med i en PR, relativt til repo-roten, uten `.`, `..` eller tomme ledd */
export const isEditablePath = (p: string) => cleanPath(p) && (isKravPath(p) || isSpecPath(p) || isSketchPath(p) || isTaskSpecFile(p));

/** En skisse `save_sketch` kan skrive: `isSketchPath`, uten `.`, `..` eller tomme ledd */
export const isSketchFile = (p: string) => cleanPath(p) && isSketchPath(p);
