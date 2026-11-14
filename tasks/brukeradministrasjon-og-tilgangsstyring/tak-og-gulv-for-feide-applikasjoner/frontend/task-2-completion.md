# Task #2 Completion Report: Herd `DetailPageTabbedContent` for vilkårsfaner og dyplenke

## Status: ✅ COMPLETED

**Date Completed**: 2026-11-06 · **Priority**: High · **Size**: M
**Commit**: `feat(detaljside): faner kan være betinget og tåle dyplenke mens siden laster`

## Summary

`DetailPageTabbedContent` filtrerer barn med `Children.toArray(...).filter(isValidElement)`, har ny valgfri `pending` som hindrer tilbakestilling av ukjent `?tab=`, og `Tabs` får `key={tabIds.join('|')}`.

## Files

- Endret: `src/common/components/layouts/DetailPageLayout/components/DetailPageTabbedContent/DetailPageTabbedContent.tsx`
- Ny: `DetailPageTabbedContent.test.tsx` (4 tester: false-barn, pending beholder `?tab=`, fanen velges når den dukker opp, ukjent `?tab=` uten pending tilbakestilles)

## Technical Decisions / notes for review

- nuqs utelater standardverdien fra URL-en (clearOnDefault), så tilbakestilling til første fane vises som at `tab` forsvinner fra URL-en. Testen sjekker valgt fane i tillegg.
- `key` på `Tabs` monterer alle `TabPanel` på nytt når Feide-fanene dukker opp etter at detaljspørringen er lastet. Det skjer én gang per sidevisning; Apollo-cachen gjør det billig og nuqs-tilstanden overlever.

## Test Results

`npx jest src/common/components/layouts/DetailPageLayout/components/DetailPageTabbedContent` + alle tester som bruker komponenten (`git grep -l DetailPageTabbedContent -- '*.test.tsx'`) — grønt.

## Acceptance Criteria Met

- ✅ `children` tillater `false | null | undefined`
- ✅ `pending?: boolean`
- ✅ `Tabs` keyes på fane-id-ene
- ✅ De fire testene
- ✅ Eksisterende brukere uendret (ingen ny påkrevd prop)

**Completed by**: Claude (AI Assistant) · **Review Status**: Ready for review
