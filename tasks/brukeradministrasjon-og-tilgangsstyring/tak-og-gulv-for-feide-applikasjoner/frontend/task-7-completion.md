# Task #7 Completion Report: Fjern grunntilgang

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: M
**Commit**: felles commit for Task #5–#9

## Summary

`FjernGrunntilgangAction` i samme meny: organisasjon → miljø → rollene i grunntilgangen for kombinasjonen (multi), også koder som ikke er forretningsroller. Ingen advarsel. Samme utfallsvisning og feilmapping (fjern-unionen).

## Files

- Ny: `.../ApplikasjonGrunntilgangActions/actions/FjernGrunntilgangAction/` (komponent, css, test, a11y). Operasjon `GetGrunntilgangForFjerning` med samme radfelter som tildel-dialogen (samme cacheplass, rader uten id).
- Ny: `ApplikasjonGrunntilgang/hooks/useFjernBrukergrunntilganger.tsx`

## Acceptance Criteria Met

- ✅ Kandidater per (org, miljø), begrenset av forvaltningsretten
- ✅ Alias-batch og feilmapping (`ManglerGrunntilgangsforvaltning`, `…ApplikasjonFinnesIkke`, `…ErPlanlagt`)
- ✅ Ingen advarsel; refetch som #6
- ✅ Tester (kandidat som ikke er forretningsrolle, tom kombinasjon, alt vellykket, `ErPlanlagt` per rad, samlet feil) og a11y

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
