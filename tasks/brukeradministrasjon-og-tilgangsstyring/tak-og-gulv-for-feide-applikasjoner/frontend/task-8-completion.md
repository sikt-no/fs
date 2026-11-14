# Task #8 Completion Report: Fanen «Delegeringstak» med liste (direkte rader)

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: M
**Commit**: felles commit for Task #5–#9

## Summary

«Delegeringstak» (`id="delegeringstak"`, `ArrowLineUpIcon`) står mellom Tilganger og Grunntilgang for Feide-applikasjoner. Listen går mot `brukerdelegeringer(filter: { erAktivNaa: true })`, uten `tilknytning` og uten sporingsfelt, med samme kolonner som grunntilgang.

## Files

- Ny: `.../components/ApplikasjonDelegeringstak/` (fane + a11y, `hooks/useGetApplikasjonDelegeringstak.tsx` + test for `delegeringstakRadNokkel`, `components/ApplikasjonDelegeringstakResultList/` + test, `testdata/delegeringstakMocks.ts`)
- Endret: `ApplikasjonDetails.tsx` og `ApplikasjonDetails.test.tsx` (rekkefølgen Detaljer, Tilganger, Delegeringstak, Grunntilgang; dyplenke for begge fanene)
- `tilgangsstyring.json`: `ApplikasjonDetails.delegeringstakTab`, `ApplikasjonDelegeringstakResultList.*`

## Acceptance Criteria Met

- ✅ Plassering, vilkår, dyplenke
- ✅ `brukerdelegeringer` med `erAktivNaa`, ingen sporingsfelt
- ✅ Radnøkkelen i én hjelpefunksjon (`delegeringstakRadNokkel`)
- ✅ Tester og a11y

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
