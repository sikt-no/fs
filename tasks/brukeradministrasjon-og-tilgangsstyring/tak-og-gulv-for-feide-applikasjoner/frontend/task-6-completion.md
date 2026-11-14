# Task #6 Completion Report: Tildel grunntilgang

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: L
**Commit**: felles commit for Task #5–#9

## Summary

`ApplikasjonGrunntilgangActions` (én `ListActions`-meny, `scope: 'list'`, vises bare når `harNoenForvaltning`) med `TildelGrunntilgangAction`: kaskade organisasjon → miljø → roller (multi), advarsel øverst, ett alias per rolle, delvis suksess.

## Files (under `.../ApplikasjonDetails/components/`)

- Ny: `ApplikasjonGrunntilgang/components/ApplikasjonGrunntilgangActions/` (+ test, a11y)
- Ny: `.../actions/TildelGrunntilgangAction/` (komponent, css, test, a11y). Operasjon `GetGrunntilgangForTildeling` ved dialogen.
- Ny: `ApplikasjonGrunntilgang/hooks/useLeggTilBrukergrunntilganger.tsx` (`GRUNNTILGANG_SAMLEDE_FEIL`, `GRUNNTILGANG_OPPFRISK`)
- Ny: `Felles/utils/kjorRolleBatch.ts`: felles løp for de fire mutasjonene (bygger alias, mapper utfall, oppfrisker, utleder felles feil)
- Ny: `Felles/testdata/forvaltningsrettFixture.ts`

## Technical Decisions / deviations

- **Advarselen er `GuidePanel variant="warning"`, ikke `Alert variant="warning"`:** SDS `Alert` har bare `success` og `critical`. `GuidePanel` warning er repoets mønster for et permanent varsel.
- **Ingen eksplisitt `__typename` i `errors`:** CLAUDE.md forbyr det. Apollo legger det til, og koden skiller på det som i `useTildelPersonbrukerTilganger`.
- «Allerede i grunntilgangen» henter `first: 100` og følger `hasNextPage` med `fetchMore` (cache-policyen slår sammen sidene), så det blir ingen avkorting.
- Tom `feideApplikasjoner` uten feil regnes som suksess.
- Én organisasjon forhåndsvelges og låses, som i de andre dialogene.

## Acceptance Criteria Met

- ✅ Meny, kaskade, nullstilling ved bytte, ikke-valgbare roller med forklaring
- ✅ Advarsel; input `{ applikasjonId, tilgangskodeId, organisasjonId, miljoId }`
- ✅ Utfall: snackbar og lukk / `AliasBatchUtfall` / én samlet feil
- ✅ Feilmapping for alle feiltypene, serverens melding for `ErPlanlagt`
- ✅ `refetchQueryNames` for listen og dialogspørringene, ventet på
- ✅ Tester: kaskade, ikke-valgbare roller, delvis suksess (`ErPlanlagt`), samlet feil, alt vellykket; a11y for dialog og meny

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
