# Task #1 Completion Report: Flytt alias-batchen og gjør feilsettet til et argument

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: S
**Commit**: `refactor(tilgangsstyring): flytt alias-batchen ut av personbrukerfeaturen` (branch `kjetihoy/BAT-411-delegeringstak-grunntilgang`)

## Summary

`batchTildeling.ts` og testen er flyttet (git mv) til `src/domains/tilgangsstyring/utils/aliasBatch/aliasBatch.ts`/`.test.ts`. `utledFellesFeil(elementer, samledeFeil)` tar settet som argument; det gamle settet er eksportert som `PERSONBRUKER_SAMLEDE_FEIL` og sendes av de fire personbruker-hookene.

## Files Modified

- `src/domains/tilgangsstyring/utils/aliasBatch/aliasBatch.ts` (flyttet): nytt argument, JSDoc oppdatert (bruksområdet, `OpprettApplikasjonFeil` som generell feiltype).
- `aliasBatch.test.ts` (flyttet): kall oppdatert + ny test for et annet sett.
- `useTildel/FjernPersonbrukerTilganger.tsx`, `useTildel/FjernFeideBrukerTilganger.tsx`: import og `PERSONBRUKER_SAMLEDE_FEIL`.
- Testene for `TildelRolleAction`/`FjernRolleAction` (+ a11y): kun importsti.

## Test Results

`npx jest src/domains/tilgangsstyring/utils src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller` — grønt. ESLint/prettier via lint-staged ved commit, `tsc --noEmit` grønt.

## Acceptance Criteria Met

- ✅ Flyttet til `utils/aliasBatch/` (A7)
- ✅ `utledFellesFeil(elementer, samledeFeil: ReadonlySet<string>)`, `PERSONBRUKER_SAMLEDE_FEIL`
- ✅ Ingen atferdsendring, eksisterende tester uendret i innhold
- ✅ Ny test: samling bare når alle feilene er i settet

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
