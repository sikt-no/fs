# Task #3 Completion Report: Gating per miljø, `useForvaltningsrettPerMiljo`

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: L
**Commit**: `feat(tilgangsstyring): felles grunnlag for delegeringstak og grunntilgang` (felles commit for Task #3 og #4)

## Summary

Ny hook som henter `mineSynligeMiljoer` og `mineTilganger(filter: { miljo, navnerom: <fs-admin> })` for hvert miljø (Promise.all, `cache-first`, følger `hasNextPage` til slutten), og svarer på `APPLIKASJONSADMINISTRASJON_SKRIV` for (miljø, eier) og (miljø, organisasjon). Regelen «rolle og organisasjon på samme rad» er trukket ut av `useWithRole` som ren funksjon.

## Files

- Ny: `src/features/WithRole/harRolleIOrganisasjon.ts` (+ `.test.ts`): `rollekoderIOrganisasjoner`, `harRolleIOrganisasjon`.
- Endret: `src/features/WithRole/useWithRole.ts` bruker `rollekoderIOrganisasjoner` (ingen atferdsendring).
- Ny: `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/Felles/hooks/useForvaltningsrettPerMiljo.tsx` (+ `.test.tsx`, 6 tester).

## Technical Decisions

- `Brukertilgang` har ingen id, så radene lagres inline under `Query.mineTilganger`. Første side for miljøet fs-admin kjører mot deler cachenøkkel med autorisasjonsspørringen; feltutvalget på radene er derfor det samme som i `useMineTilgangerQuery` (pluss normalisert organisasjonsnavn). Hooken bruker engangs `client.query`, ikke en watched query; bytt ikke til `useQuery` uten å se på dette.
- Feil eller manglende navnerom/miljøer gir `error` og ingen forvaltning (lukket).
- Returnerer `kanForvalte`, `harNoenForvaltning`, `organisasjoner` (med navn for valglisten), `miljoerFor`, `loading`, `error`.

## Test Results

`npx jest src/features/WithRole src/domains/tilgangsstyring/features/ApplikasjonDetails/components/Felles/hooks` — grønt (to miljøer med eier i ett, uten rolle for eier, rolle på feil rad, paginering over to sider, nettverksfeil, manglende navnerom). `useWithRole`-testene går uendret.

## Acceptance Criteria Met

- ✅ API som beskrevet, rollekoden fra `frontendrolle`, navnerom fra `useTilgangerFilter()`
- ✅ Miljøer fra egen `mineSynligeMiljoer`-operasjon; `mineTilganger` paginert til slutten
- ✅ `harRolleIOrganisasjon` delt med `useWithRole`
- ✅ Lukket ved feil; bruker ikke tildelings-hookene eller `_TILDELING` (kommentar i hook og test)

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
