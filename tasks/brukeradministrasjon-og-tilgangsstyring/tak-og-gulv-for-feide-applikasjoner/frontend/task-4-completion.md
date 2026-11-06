# Task #4 Completion Report: Cache-policy og felles verktøy

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: S
**Commit**: `feat(tilgangsstyring): felles grunnlag for delegeringstak og grunntilgang` (felles commit for Task #3 og #4)

## Summary

Cache-policy for `FeideApplikasjon.brukerdelegeringer`/`brukergrunntilganger`, delt `formatGyldighetstidsrom`, `useForretningsroller` og `AliasBatchUtfall`.

## Files

- `src/common/lib/apollo/cacheConfig.ts`: `FeideApplikasjon { brukerdelegeringer, brukergrunntilganger: nodesCursorPagination(['filter']) }`. `cacheConfig.test.ts`: ny test som verifiserer at sidene slås sammen og at den arvede `Applikasjon.tilganger`-policyen fortsatt gjelder via `possibleTypes`.
- Ny: `src/domains/tilgangsstyring/utils/gyldighetstidsrom/formatGyldighetstidsrom.ts` (+ test, fire tilfeller). `PersonbrukerRollerResultList.tsx` bruker den.
- Ny: `Felles/hooks/useForretningsroller.tsx` (+ test): `tilgangsroller(filter: { navnerom: [<fs>] })`, følger sidene, filtrerer bort utgåtte, sortert på kode.
- Ny: `Felles/components/AliasBatchUtfall/` (komponent, css, test, a11y-test).
- `tilgangsstyring.json`: `AliasBatchUtfall`.

## Technical Decisions

- `formatGyldighetstidsrom` tar datoformatereren som argument, så den er ren og kan brukes både med next-intl i komponentene og i tester.
- `AliasBatchUtfall` rendrer innholdet til `FSModalFeedback`; dialogen eier selve slotten (FSModal sorterer bare direkte barn).
- Tom `feideApplikasjoner` uten feil regnes som suksess, så utfallet har bare `ok`/`feilet`.

## Test Results

Jest på `cacheConfig.test.ts`, `utils/gyldighetstidsrom`, `Felles/` og `PersonbrukerRollerResultList` — grønt. `tsc --noEmit` grønt.

## Acceptance Criteria Met

- ✅ Cache-policy med kommentar, sammenslåing verifisert med test
- ✅ `formatGyldighetstidsrom` flyttet, fire tilfeller testet
- ✅ `useForretningsroller` med utgåtte filtrert
- ✅ `AliasBatchUtfall` med a11y-test

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
