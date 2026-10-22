---
paths:
  - "krav/README.md"
  - "tasks/README.md"
  - "akseptansetest/README.md"
  - ".claude/references/akseptansetest/**"
  - ".claude/skills/**"
  - "kom-i-gang.html"
---

# Hold kom-i-gang.html i synk med konvensjonene og skillene

`kom-i-gang.html` i rota av repoet er innføringen i kravarbeidet og akseptansetesten. Den publiseres med FS Kravforvaltning på <https://sikt-no.github.io/fs/kom-i-gang.html>. Fila i repoet er kilden: statisk HTML uten byggesteg, med et lite skript for prosessmenyen og velgeren i livsløpsdiagrammet (`data-o` på delene av diagrammet, `data-mode` på knappene).

Siden har to deler:

- **Oversikt** (`#oversikt`, startvisningen) følger «Kort fortalt» i `krav/README.md`: hvor kravene ligger, hvordan en kravfil ser ut, livsløpet til et krav, skillene og tavla. Den var opprinnelig «Krav i FS.dc.html» i Claude Design, men vedlikeholdes nå bare her.
- **Prosessen** (steg 1–12, og sidesporene Flyter, Endre og Avvikle) viser ett steg om gangen. Steg 1–6 følger `krav/README.md` og `tasks/README.md` (*Utføring* og *Tavla*). Steg 7–12 følger `akseptansetest/README.md`, `.claude/references/akseptansetest/` og teststrategien i Confluence.

## Når du endrer konvensjonene eller skillene

Oppdater siden i samme endring når noe av dette endres:

- mappenivåene eller nummereringen, eksempelet på en kravfil, eller taggene (`krav/README.md`)
- statusene, rekkefølgen mellom dem, eller hvem som setter dem
- skillene for kravarbeid, utvikling, verifisering eller akseptansetest, eller hva de lager
- kolonnene på tavla, eller protokollen i `utforing.md` (`tasks/README.md`)
- stegene i akseptansetesten, alvorlighetsgradene eller beslutningene (`akseptansetest/README.md`, `alvorlighetsgrad.md`)

Si fra til brukeren hvilke steg på siden som er endret. Endres bare formuleringen, trenger ikke siden å endres.

## Når du endrer siden

- Fila beholder navnet, så lenkene i `README.md`, `krav/README.md`, `akseptansetest/README.md` og `STATIC_PAGES` i `fs-kravforvaltning/src/markdown.ts` fortsatt virker. Adressen til et steg er `kom-i-gang.html#<steg>` (for eksempel `#testplan`). Endrer du id-en til et steg, sjekk lenkene til det.
- Fargene er tokens på `:root`, med mørk modus. Livsløpsdiagrammet har faste lyse farger, og står på et hvitt kort i begge modusene.
- Lenker til konvensjonene bruker vieweren (`./#/krav/README.md`). Andre filer i repoet lenkes på GitHub.
- Se over siden i nettleseren etterpå, i lys og mørk modus og på mobilbredde: menyen, «Forrige»/«Neste», tilbake-knappen i nettleseren og velgeren i livsløpsdiagrammet.
