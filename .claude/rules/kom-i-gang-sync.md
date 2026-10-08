---
paths:
  - "krav/README.md"
  - "kom-i-gang.html"
---

# Hold kom-i-gang.html i synk med krav/README.md

`kom-i-gang.html` i rota av repoet er en kort innføring i kravarbeidet. Den publiseres med FS Kravforvaltning på <https://sikt-no.github.io/fs/kom-i-gang.html>. Siden følger «Kort fortalt» i `krav/README.md`:

- **Hvor kravene ligger:** domene, sub-domene og kapabilitet
- **Hvordan en kravfil ser ut:** eksempelfila, taggene, Gitt/Når/Så og åpne spørsmål
- **Livsløpet til et krav, og slik bidrar du:** statusene, hvem som setter dem, og skillene

Fila er en eksport fra Claude Design. Den er pakket og komprimert, og kan ikke rettes for hånd. Kilden er fila «Krav i FS.dc.html» i prosjektet <https://claude.ai/design/p/7b91011d-fa2b-4086-8b9a-52fd52db2459?file=Krav+i+FS.dc.html>. For å åpne prosjektet trenger man lisensen «Claude for utviklere».

## Når du endrer `krav/README.md`

Endrer du noe av dette, si fra til brukeren at `kom-i-gang.html` må oppdateres i Claude Design og eksporteres på nytt:

- mappenivåene eller nummereringen
- eksempelet på en kravfil, eller taggene (ID, prioritet, status)
- statusene, rekkefølgen mellom dem, eller hvem som setter dem
- skillene for kravarbeid, eller hva de gjør

Si hva på siden som ikke stemmer lenger. Endres bare formuleringen, trenger ikke siden å endres.

## Når `kom-i-gang.html` endres

Ikke endre fila selv. Ny eksport legges over den gamle fila med samme navn, så lenkene i `README.md`, `krav/README.md` og `STATIC_PAGES` i `fs-kravforvaltning/src/markdown.ts` fortsatt virker.
