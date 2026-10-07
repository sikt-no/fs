# Implementasjonsdetaljer: Administrere brukere på en spesifikk rolle

**Relatert feature:** [`administrere_brukere_på_rolle.feature`](./administrere_brukere_på_rolle.feature)

Detaljene gjelder regelen merket `@must`, «Gi rollen til en person med fødselsnummer, D-nummer
eller SNR». Reglene for selve tildelingen og tekstene som hører til dem, står i
[`gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.design.md`](../1%20-%20Grunnleggende%20brukeradministrasjon/gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.design.md).
Det finnes ingen skisser. Detaljene bygger på «Tildel roller»-dialogen på detaljsiden for en
personbruker (`TildelRolleModal` i fs-admin).

## Overordnet UI-mønster

En dialog (`FSModal`, liten) som åpnes fra knappen «Gi rollen til en person» på rollens
oversiktsside. Dialogen har samme oppbygning som «Tildel roller»: overskrift, felter, en
tilbakemeldingsflate og knapper i bunnen.

## Komponenter og layout

- **Overskrift:** «Gi rollen til en person»
- **Rollen:** vises som tekst under overskriften, med rollekoden og beskrivelsen. Rollen kan
  ikke endres i dialogen; bare rollen på siden gis.
- **Felter**, i denne rekkefølgen:
  1. **Organisasjon** (`FSCombobox`): organisasjonene brukeradministratoren administrerer, som i
     «Tildel roller». Administrerer brukeradministratoren bare én organisasjon, er den valgt og
     feltet låst.
  2. **Miljø** (`FSCombobox`): miljøene brukeradministratoren administrerer. Låst til
     organisasjon er valgt, som i «Tildel roller».
  3. **Fødselsnummer, D-nummer eller SNR** (tekstfelt): 11 siffer, numerisk tastatur på mobil.
     Ikke autofullføring (`autocomplete="off"`).
- **Knapper:** «Avbryt» (sekundær) og «Gi rollen» (primær).

## Interaksjonsmønstre

### Primærhandling
«Gi rollen» sender organisasjon, miljø, rolle og nummer i én operasjon. Ved suksess lukkes
dialogen, beskjeden vises som snackbar, og listen på rollens oversiktsside lastes på nytt.
Personen står da i listen.

### Sekundære handlinger
- «Avbryt», X og Escape lukker dialogen uten å gi rollen.
- Flere roller gis etterpå fra detaljsiden for personen. Personen er klikkbar i listen, og
  snackbaren kan lenke dit (se åpne designspørsmål).

### Navigasjon
- **Inn:** Knappen «Gi rollen til en person» på rollens oversiktsside.
- **Ut (suksess):** Tilbake til rollens oversiktsside, med personen i listen.
- **Ut (avbryt):** Tilbake til rollens oversiktsside, ingen endring.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Åpning | Organisasjon er valgt når brukeradministratoren administrerer én; ellers er feltene tomme. Nummerfeltet er tomt |
| Validering | Feltfeil under feltet ved innsending. Nummeret sjekkes for 11 siffer og kontrollsifre i klienten før innsending, og API-et sjekker det på nytt |
| Sender | «Gi rollen» viser «Gir rollen …» og er deaktivert |
| Feil | Feltfeil ved nummerfeltet for ugyldig nummer og testperson. Andre feil i tilbakemeldingsflaten i dialogen. Dialogen blir stående, og feltene beholder verdiene |
| Suksess | Dialogen lukkes, og nummeret slettes fra skjemaets tilstand. Snackbar med beskjeden |

## Tekster

Alle tekstene er forslag og må godkjennes av Kjetil. Tekstene for reglene i BRU-PER-GRU-013
(ugyldig nummer, testperson, rettighet og beskjeden ved suksess) står i implementasjonsdetaljene
for GRU-013.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Knapp på rollens oversiktsside | Alltid | «Gi rollen til en person» | – | Personen finnes ikke i løsningen |
| Dialogens overskrift | Dialogen er åpen | «Gi rollen til en person» | – | Personen finnes ikke i løsningen |
| Under overskriften | Dialogen er åpen | «Rolle: {rollekode}» | `{rollekode}` | Bare rollen på siden gis |
| Feltetikett | Alltid | «Organisasjon» | – | Valglisten for organisasjon er begrenset til organisasjoner brukeradministratoren administrerer |
| Feltetikett | Alltid | «Miljø» | – | Valglisten for miljø er begrenset til miljøer brukeradministratoren administrerer |
| Feltetikett | Alltid | «Fødselsnummer, D-nummer eller SNR» | – | Personen finnes ikke i løsningen |
| Hjelpetekst under nummerfeltet | Alltid | «11 siffer. Nummeret vises ikke etter at rollen er gitt.» | – | Personen finnes ikke i løsningen |
| Plassholder i valglistene | Ingenting valgt | «Ikke valgt» (finnes i fs-admin) | – | – |
| Feltfeil, organisasjon eller miljø | Innsending uten organisasjon eller miljø | «Velg organisasjon og miljø.» (finnes i fs-admin som hjelpetekst) | – | Personen kan ikke legges til uten en rolle (GRU-013) |
| Feltfeil, nummer | Innsending uten nummer | «Oppgi fødselsnummer, D-nummer eller SNR.» | – | Personen finnes ikke i løsningen |
| Feltfeil, nummer | Nummeret har ikke 11 siffer | «Nummeret må ha 11 siffer.» | – | Personen finnes ikke i løsningen |
| Primærknapp | Alltid / mens operasjonen pågår | «Gi rollen» / «Gir rollen …» | per tilstand | Personen finnes ikke i løsningen |
| Sekundærknapp | Alltid | «Avbryt» | – | – |

**Skisser:** ingen skisser finnes.

## Per-scenario detaljer

### Scenario: Personen finnes ikke i løsningen
Operasjonen oppretter personen og gir rollen i én operasjon. Svaret har den nå synlige personen,
så klienten kan vise hen i listen og lenke til detaljsiden uten å slå opp på nummer.

### Scenario: Personen finnes, men brukeradministratoren ser hen ikke
Klienten gjør ingenting annerledes. Svaret og beskjeden er de samme som når personen ikke
fantes (GRU-013, «Svaret avslører ikke om personen fantes fra før»).

### Scenario: Valglisten for organisasjon er begrenset til organisasjoner brukeradministratoren administrerer
Samme kilde som «Tildel roller» (`mineTildelingsorganisasjoner`).

### Scenario: Organisasjonen er gitt når brukeradministratoren administrerer én organisasjon
Organisasjonen er valgt og feltet låst, som i «Tildel roller».

### Scenario: Valglisten for miljø er begrenset til miljøer brukeradministratoren administrerer
«Tildel roller» henter miljøene fra `mineSynligeMiljoer`. Dialogen skal bare vise miljøene
brukeradministratoren administrerer.

### Scenario: Bare rollen på siden gis
Dialogen har ikke noe rollefelt.

### Scenario: Flere roller gis etterpå fra detaljsiden for personen
Detaljsiden for personen har «Tildel roller» (BRU-PER-GRU-003). Den må kunne tildele til en
person, ikke bare til en Feide-bruker.

## Åpne designspørsmål

- [ ] Godkjenn tekstene i tabellen over.
- [ ] Skal snackbaren ved suksess ha en lenke til detaljsiden for personen («Åpne personen»), så
      brukeradministratoren kan gi flere roller med en gang? Snackbaren i fs-admin har i dag bare
      tekst.
- [ ] Skal nummeret skjules mens det skrives (som et passordfelt), eller vises som vanlig tekst
      til dialogen lukkes?
