# Task #5 Completion Report: Fanen «Grunntilgang» med liste

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: M
**Commit**: `feat(tilgangsstyring): fanene Delegeringstak og Grunntilgang for Feide-applikasjoner` (felles commit for Task #5–#9)

## Summary

`ApplikasjonDetails` viser «Grunntilgang» (`id="grunntilgang"`, `ArrowLineDownIcon`) som siste fane, bare for Feide-applikasjoner, og sender `pending={loading}`. Listen henter `brukergrunntilganger(filter: { erAktivNaa: true })` med `Feature-Flags: experimental` (via `useDataListQuery`) og viser Rolle, Organisasjon, Miljø (`TagStatus`) og Gyldighetstidsrom.

## Files (under `src/domains/tilgangsstyring/features/ApplikasjonDetails/`)

- Endret: `ApplikasjonDetails.tsx`. Ny: `ApplikasjonDetails.test.tsx` (fanerekkefølge, ingen faner for Maskinporten/maskinbruker, dyplenke etter lasting).
- Ny: `components/ApplikasjonGrunntilgang/ApplikasjonGrunntilgang.tsx` (+ `.a11y.test.tsx`)
- Ny: `.../hooks/useGetApplikasjonGrunntilgang.tsx` (operasjon `GetApplikasjonGrunntilgang`, `grunntilgangRadNokkel`)
- Ny: `.../components/ApplikasjonGrunntilgangResultList/` (+ test)
- Ny: `.../testdata/grunntilgangMocks.ts` (fixtures ved komponenttestene, ikke mock-API-et)
- `src/common/messages/nb/tilgangsstyring.json`: `ApplikasjonDetails.grunntilgangTab`, `ApplikasjonGrunntilgangResultList.*`

## Technical Decisions

- Spørringen er flat, ikke fragment-kolokert (graphql-consumer-skillens standard). «Ikke best practice — eksisterende mønster i området»: `ApplikasjonDetails` er flat, og `Brukergrunntilgang` har ingen id, så `useFragment` kan ikke lese radene fra cachen uten `@unmask`.
- Sidestørrelse 10 med lokal state for `first` (ingen URL-state, siden fanen ikke har filter eller sortering).
- Ingen sidebar: ingen filter i fase 1.

## Acceptance Criteria Met

- ✅ Fanen vises bare for FEIDE, etter Delegeringstak, med `pending`; dyplenke testet
- ✅ `erAktivNaa: true`, experimental-header, kolonnene, radnøkkel rolle|org|miljø
- ✅ Rader med koder som ikke er forretningsroller vises som andre (test)
- ✅ Ingen gating på visning; a11y-test for fanen

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
