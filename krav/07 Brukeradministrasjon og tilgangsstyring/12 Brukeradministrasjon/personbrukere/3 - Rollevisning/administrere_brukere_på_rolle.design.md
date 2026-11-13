# Implementasjonsdetaljer: Administrere brukere på en spesifikk rolle

**Relatert feature:** [`administrere_brukere_på_rolle.feature`](./administrere_brukere_på_rolle.feature)

Detaljene gjelder regelen merket `@must`, «Gi rollen til en person med fødselsnummer, D-nummer
eller SNR», og «Fjern tildeling» på radene. Reglene for selve tildelingen og tekstene som hører til dem, står i
[`gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.design.md`](../1%20-%20Grunnleggende%20brukeradministrasjon/gi_en_person_tilgang_med_fødselsnummer_d-nummer_eller_snr.design.md).
Det finnes ingen skisser. Detaljene bygger på «Tildel roller»-dialogen på detaljsiden for en
personbruker (`TildelRolleModal` i fs-admin), og er sjekket mot fs-admin !3046 13.11.2026.

## Overordnet UI-mønster

En dialog (`FSModal`, liten) som åpnes fra knappen «Gi rollen til en person» i listens flate
på rollens oversiktsside. Dialogen har samme oppbygning som «Tildel roller»: overskrift, felter, en
tilbakemeldingsflate og knapper i bunnen.

«Fjern tildeling» på en rad åpner en bekreftelse (`FSModal`, liten, `variant="alert"`) før
tildelingen fjernes.

## Komponenter og layout

### Dialogen «Gi rollen til en person»

- **Overskrift:** «Gi rollen til en person»
- **Rollen:** vises som tekst under overskriften, med rollekoden. Rollen kan ikke endres i
  dialogen; bare rollen på siden gis.
- **Felter**, i denne rekkefølgen:
  1. **Organisasjon** (`FSCombobox`): organisasjonene der brukeradministratoren har rett til å
     tildele personer (`mineTildelingsorganisasjoner` med mottakeren `PERSONBRUKER`), som i
     «Tildel roller», og bare de der rollen er i delegeringstaket i minst ett av miljøene. Har
     brukeradministratoren bare én slik organisasjon, er den valgt og feltet låst.
  2. **Miljø** (`FSCombobox`): miljøene der brukeradministratoren har rett til å tildele personer
     i den valgte organisasjonen (`mineTildelingsmiljoer` med mottakeren `PERSONBRUKER`), og der
     rollen er i delegeringstaket for organisasjonen. Låst til organisasjon er valgt, og tømmes
     når organisasjonen byttes, som i «Tildel roller».
  - Delegeringstaket avgjøres som i «Tildel roller» (BRU-PER-GRU-003): en applikasjon har rollen
    i delegeringstaket for organisasjonen og miljøet, direkte eller gjennom en
    organisasjonssamling, eller en rolle i delegeringstaket gir den. I dag finnes
    `skjulUtenforTak` bare på `mineTildelbareTilgangsroller` for én organisasjon og ett miljø
    om gangen; valglistene trenger en kilde som gir kombinasjonene for én rolle.
  3. **Fødselsnummer, D-nummer eller SNR** (tekstfelt): 11 siffer, numerisk tastatur på mobil.
     Ikke autofullføring (`autocomplete="off"`).
- Dialogen har ingen felt for stedkoder eller tidsbegrensning (regelen «Stedkoder og
  tidsbegrensning settes alltid per bruker»).
- **Knapper:** «Avbryt» (sekundær) og «Gi rollen» (primær).

### Bekreftelsen før «Fjern tildeling»

- **Overskrift:** «Fjerne tildelingen?»
- **Tekst:** hvem som mister rollen, for hvilken organisasjon og i hvilket miljø.
- **Knapper:** «Avbryt» og «Fjern tildeling» (kritisk).
- Feil vises i dialogens tilbakemeldingsflate, og dialogen blir stående.

## Interaksjonsmønstre

### Primærhandling
«Gi rollen» sender organisasjon, miljø, rolle og nummer i én operasjon. Ved suksess lukkes
dialogen, beskjeden vises som snackbar, og listen på rollens oversiktsside og filtervalgene
hentes på nytt. Personen står da i listen.

### Sekundære handlinger
- «Avbryt», X og Escape lukker dialogen uten å gi rollen.
- Flere roller gis etterpå fra detaljsiden for personen, som åpnes fra brukeroversikten.
  Radene på rollens oversiktsside lenker ikke dit, og snackbaren har ingen lenke.
- «Fjern tildeling» på en rad åpner bekreftelsen. Når den bekreftes, fjernes den ene tildelingen
  med den samme operasjonen som «Fjern roller» på detaljsiden for personen
  (`fjernPersonbrukerTilganger`). Ved suksess lukkes bekreftelsen med en snackbar, og listen og
  filtervalgene hentes på nytt.

### Navigasjon
- **Inn:** Knappen «Gi rollen til en person» i listens flate på rollens oversiktsside.
- **Ut (suksess):** Tilbake til rollens oversiktsside, med personen i listen.
- **Ut (avbryt):** Tilbake til rollens oversiktsside, ingen endring.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Knappen vises | Brukeradministratoren har rett til å tildele personer i minst én organisasjon, og rollen er ikke utgått. Knappen vises også når listen er tom. Med bare leserett vises den ikke |
| Åpning | Organisasjon er valgt når det bare finnes én organisasjon å velge; ellers er feltene tomme. Nummerfeltet er tomt |
| Validering | Feltfeil under feltet ved innsending. Mellomrom i nummeret fjernes, og nummeret sjekkes for 11 siffer, FS-generert serie og kontrollsifre i klienten før innsending. API-et sjekker det på nytt |
| Sender | «Gi rollen» viser «Gir rollen …» og er deaktivert |
| Feil | Feltfeil ved nummerfeltet for ugyldig nummer, FS-generert nummer, testperson i ekte miljø og ekte person i testmiljø. Andre feil i tilbakemeldingsflaten i dialogen. Dialogen blir stående, og feltene beholder verdiene |
| Suksess | Dialogen lukkes, og nummeret slettes fra skjemaets tilstand. Snackbar med beskjeden |
| «Fjern tildeling» vises | Raden er en direkte tildeling, og brukeradministratoren har rett til å tildele personer i både organisasjonen og miljøet på raden |
| Fjerner | «Fjern tildeling» i bekreftelsen viser «Fjerner …» og er deaktivert |
| Fjerning feilet | Bekreftelsen blir stående med årsaken i tilbakemeldingsflaten |

## Tekster

Tekstene er godkjent av Kjetil 09.10.2026, og tekstene i bekreftelsen før «Fjern tildeling» og hjelpeteksten under nummerfeltet 13.11.2026, bortsett fra der det står at de ikke er godkjent.
Tekstene for reglene i BRU-PER-GRU-013 (ugyldig nummer, testperson, rettighet og beskjeden ved
suksess) står i implementasjonsdetaljene for GRU-013.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Knapp på rollens oversiktsside | Brukeradministratoren har rett til å tildele personer i minst én organisasjon, og rollen er ikke utgått | «Gi rollen til en person» | – | Personen finnes ikke i løsningen |
| Dialogens overskrift | Dialogen er åpen | «Gi rollen til en person» | – | Personen finnes ikke i løsningen |
| Under overskriften | Dialogen er åpen | «Rolle: {rollekode}» | `{rollekode}` | Bare rollen på siden gis |
| Feltetikett | Alltid | «Organisasjon» | – | Valglisten for organisasjon er begrenset til organisasjoner brukeradministratoren administrerer |
| Feltetikett | Alltid | «Miljø» | – | Valglisten for miljø er begrenset til miljøer brukeradministratoren administrerer |
| Feltetikett | Alltid | «Fødselsnummer, D-nummer eller SNR» | – | Personen finnes ikke i løsningen |
| Hjelpetekst under nummerfeltet | Alltid | «11 siffer.» (godkjent 13.11.2026. Den tidligere teksten sa at nummeret ikke vises etter at rollen er gitt, og det gjelder ikke når navnet mangler) | – | Personen finnes ikke i løsningen |
| Plassholder i valglistene | Ingenting valgt | «Ikke valgt» (finnes i fs-admin) | – | – |
| Feltfeil, organisasjon eller miljø | Innsending uten organisasjon eller miljø | «Velg organisasjon og miljø.» (finnes i fs-admin som hjelpetekst) | – | Personen kan ikke legges til uten en rolle (GRU-013) |
| Feltfeil, nummer | Innsending uten nummer | «Oppgi fødselsnummer, D-nummer eller SNR.» | – | Personen finnes ikke i løsningen |
| Feltfeil, nummer | Nummeret har ikke 11 siffer | «Nummeret må ha 11 siffer.» | – | Personen finnes ikke i løsningen |
| Primærknapp | Alltid / mens operasjonen pågår | «Gi rollen» / «Gir rollen …» | per tilstand | Personen finnes ikke i løsningen |
| Sekundærknapp | Alltid | «Avbryt» | – | – |
| Handling på raden | Direkte tildeling i en organisasjon og et miljø der brukeradministratoren har rett til å tildele personer | «Fjern tildeling» | Skjermlesernavn: «Fjern tildeling: {navn}, {organisasjon}, {miljø}» | Fjerne en tildeling fra rollens oversiktsside |
| Bekreftelsens overskrift | «Fjern tildeling» er valgt | «Fjerne tildelingen?» | – | Fjerne en tildeling fra rollens oversiktsside |
| Bekreftelsens tekst | «Fjern tildeling» er valgt | «{navn} mister rollen {rollekode} for {organisasjon} i miljøet {miljø}. Tildelingen avsluttes, og rollen kan gis på nytt.» | `{navn}` er «Personen (navn ikke kjent)» når navnet mangler | Fjerne en tildeling fra rollens oversiktsside |
| Bekreftelsens knapper | Alltid / mens operasjonen pågår | «Avbryt», «Fjern tildeling» / «Fjerner …» | per tilstand | Fjerne en tildeling fra rollens oversiktsside |
| Snackbar | Tildelingen er fjernet | «Tildelingen er fjernet.» (fra fs-admin !3046, ikke godkjent) | «Tildelingen er fjernet — brukeren har fortsatt: {koder}» når personen fortsatt har rollen gjennom en annen rolle eller en organisasjonssamling | Fjerne en tildeling fra rollens oversiktsside |
| Tilbakemeldingsflaten i bekreftelsen | Fjerningen feilet | Feiltekstene fra «Fjern roller» på detaljsiden for personen (finnes i fs-admin) | Én tekst per feil: mangler rett, arvet, gitt gjennom en organisasjonssamling, finnes ikke, annen feil | Fjerne en tildeling fra rollens oversiktsside |

**Skisser:** ingen skisser finnes.

## Per-scenario detaljer

### Scenario: Personen finnes ikke i løsningen
Operasjonen oppretter personen og gir rollen i én operasjon. Klienten bruker ikke svaret til å
vise personen; den henter listen på nytt, og personen står der. Klienten slår ikke opp på nummer.

### Scenario: Personen finnes, men brukeradministratoren ser hen ikke
Klienten gjør ingenting annerledes. Svaret og beskjeden er de samme som når personen ikke
fantes (GRU-013, «Svaret avslører ikke om personen fantes fra før»).

### Scenario: Valglisten for organisasjon er begrenset til organisasjoner brukeradministratoren administrerer
Samme kilde som «Tildel roller» (`mineTildelingsorganisasjoner`), med mottakeren `PERSONBRUKER`,
så bare retten til å tildele personer teller.

### Scenario: Organisasjonen er gitt når brukeradministratoren administrerer én organisasjon
Organisasjonen er valgt og feltet låst, som i «Tildel roller».

### Scenario: Valglisten for miljø er begrenset til miljøer brukeradministratoren administrerer
Valgene er `mineTildelingsmiljoer` for den valgte organisasjonen, med mottakeren `PERSONBRUKER`:
miljøene der brukeradministratoren har rett til å tildele personer i organisasjonen, og der
rollen er i delegeringstaket.

### Scenario: Organisasjon og miljø kan bare velges der rollen er i delegeringstaket
Se «Komponenter og layout». En kombinasjon der rollen ikke er i delegeringstaket, tilbys ikke,
slik valglisten for rolle i «Tildel roller» ikke tilbyr en rolle utenfor delegeringstaket.

### Scenario: En utgått rolle kan ikke gis fra rollesiden
Knappen «Gi rollen til en person» vises ikke for en utgått rolle. Rollens oversiktsside og
listen over tildelingene vises som for andre roller.

### Scenario: Brukeradministrator med bare leserett kan ikke gi eller fjerne
Knappen «Gi rollen til en person» og «Fjern tildeling» vises ikke. Listen og filtrene vises.

### Scenario: Bare rollen på siden gis
Dialogen har ikke noe rollefelt.

### Scenario: Flere roller gis etterpå fra detaljsiden for personen
Detaljsiden for personen har «Tildel roller» (BRU-PER-GRU-003), som også tildeler til en person.

### Scenario: Fjerne en tildeling fra rollens oversiktsside
Hver rad er én tildeling, så «Fjern tildeling» fjerner rollen for organisasjonen og miljøet på
raden. Brukerens øvrige tildelinger av rollen står urørt. Handlingen vises bare når
brukeradministratoren har rett til å tildele personer i både organisasjonen og miljøet på raden
(eget scenario i kravet).
API-et avviser også fjerningen uten retten (`ManglerTildelingsrett`).

### Regel: Rader med arvet rolle har ikke «Fjern tildeling»
Handlingen vises bare på rader der rollen er tildelt direkte. En arvet rolle fjernes ved å fjerne
rollen den arves gjennom. API-et avviser også fjerning av en arvet tildeling (`ARVET`).

### Regel: Rader med rolle gitt gjennom en organisasjonssamling har ikke «Fjern tildeling»
Handlingen vises ikke på rader der rollen er gitt gjennom en organisasjonssamling. Tildelingen
trekkes tilbake for hele samlingen der den er gitt. API-et avviser fjerning for én organisasjon
(`SAMLING`).

### Regel: Stedkoder og tidsbegrensning settes alltid per bruker
Dialogen har ingen felt for dem. De settes for tildelingen på detaljsiden for personen
(BRU-PER-GRU-005 og BRU-PER-GRU-006).

## Avklarte designspørsmål

- Hjelpeteksten under nummerfeltet er «11 siffer.», fordi nummeret vises når navnet mangler.
  Avklart 13.11.2026 (Kjetil).
- Bekreftelsen før «Fjern tildeling» og tekstene i den er godkjent. Avklart 13.11.2026 (Kjetil).
- «Fjern tildeling» vises bare når brukeradministratoren har rett til å tildele i både
  organisasjonen og miljøet på raden. Avklart 13.11.2026 (Kjetil).

- Snackbaren ved suksess har ingen lenke til detaljsiden for personen. Avklart 09.10.2026
  (Kjetil).
- Nummerfeltet vises som vanlig tekst, ikke maskert. Avklart 09.10.2026 (Kjetil).
