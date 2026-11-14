# Task #9 Completion Report: Tildel og fjern delegeringstak (direkte rader)

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: L
**Commit**: felles commit for Task #5–#9

## Summary

`ApplikasjonDelegeringstakActions` med `TildelDelegeringstakAction` og `FjernDelegeringstakAction`, bygget som grunntilgang, men uten advarselen og uten `SyntetiskApplikasjonIEktMiljo`. Ett alias per rolle mot `leggTilBrukerdelegeringer`/`fjernBrukerdelegeringer` via `kjorRolleBatch`.

## Files

- Ny: `.../ApplikasjonDelegeringstak/components/ApplikasjonDelegeringstakActions/` (meny + test, a11y; begge dialoger med test, a11y, css)
- Ny: `hooks/useLeggTilBrukerdelegeringer.tsx` (`DELEGERINGSTAK_SAMLEDE_FEIL` = `ManglerDelegeringsforvaltning`, `BrukerdelegeringApplikasjonFinnesIkke`, `NetworkError`) og `hooks/useFjernBrukerdelegeringer.tsx`
- `rollerAlleredeIDelegeringstak` eksportert fra `TildelDelegeringstakAction.tsx` (+ egen test), så fase 2 kan ta med flere kilder.

## Acceptance Criteria Met

- ✅ Samme oppbygning som #6/#7, uten advarsel
- ✅ Valglisten for organisasjon har bare organisasjoner (fra forvaltningsretten), aldri samlinger
- ✅ «Allerede i delegeringstaket» i én funksjon
- ✅ Samlet feil vs. feil per rad som beskrevet; tom payload = suksess; refetch
- ✅ Tester, inkludert `BrukerdelegeringErPlanlagt` på én rad, og a11y

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
