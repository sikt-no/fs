# Implementasjonsdetaljer: Se brukere som har en spesifikk rolle

**Relatert feature:** [`se_brukere_på_rolle.feature`](./se_brukere_på_rolle.feature)

Detaljene gjelder scenarioene merket `@must`, og filtrene og antallet som er avklart i
workshopen 09.–10.11.2026 og av Kjetil 13.11.2026. Det finnes ingen skisser. Detaljene bygger på
mønstrene som finnes i FS Admin i dag (personbrukere-listen og detaljsiden for en personbruker),
og er sjekket mot fs-admin !3046 og fs-plattform !6706 13.11.2026.

## Overordnet UI-mønster

To nye sider under Tilgangsstyring i FS Admin, ved siden av «Personbrukere» og «Applikasjoner»:

- **Rolleoversikten**: en liste over rollene i delegeringstaket i organisasjonene og miljøene
  brukeradministratoren administrerer, også for den som bare kan lese.
- **Rollens oversiktsside**: en detaljside for én rolle, med listen over de aktive
  tildelingene av rollen til brukere brukeradministratoren ellers kan se. Herfra gis rollen til
  en person med fødselsnummer, D-nummer eller SNR, og tildelinger fjernes (se
  [`administrere_brukere_på_rolle.design.md`](./administrere_brukere_på_rolle.design.md)).

Rutene er `/tilgangsstyring/roller` og `/tilgangsstyring/roller/[id]`, etter mønsteret for
personbrukere.

## Komponenter og layout

### Rolleoversikten

- Samme listekomponent som personbrukere-listen (`NavigationList` med `ListItemCell`).
- Én rad per rolle. Kolonner: «Rolle» (rollekoden) og «Beskrivelse».
- Bare roller (navnerom av typen forretning), ikke tilganger, og bare roller i delegeringstaket.
  Sortert på rollekode, stigende.
- En utgått rolle har merkelappen «Utgått» ved rollekoden.
- Filtre: søk på rollekode eller beskrivelse, og valget «Utgåtte roller» («Skjul utgåtte», som
  er standard, eller «Vis utgåtte»). Ingen filter på organisasjon og miljø.

### Rollens oversiktsside

- Overskrift: rollekoden, med beskrivelsen under.
- Listen har ingen egen overskrift.
- Knappen «Gi rollen til en person» ligger i listens egen flate, som handlingselement for
  listen. Den åpner dialogen fra BRU-PER-ROL-002. Den vises ikke for en utgått rolle, og ikke
  for den som bare kan lese.
- Liste over tildelingene, med samme listekomponent. Én rad per tildeling av rollen. Kolonner:
  - «Navn». Mangler navnet, vises personens fødselsnummer, D-nummer eller SNR i stedet
    (BRU-PER-GRU-013, regelen «Nummeret vises bare når navnet mangler»).
  - «Gjelder for organisasjon» (organisasjonen tildelingen gjelder for)
  - «Miljø» (miljøet tildelingen gjelder)
- Rader der rollen er tildelt direkte, i en organisasjon og et miljø der brukeradministratoren har rett til å tildele, har handlingen «Fjern tildeling». Rader med arvet rolle, eller med rolle gitt gjennom en organisasjonssamling, har den ikke (BRU-PER-ROL-002). De sier i stedet hvor rollen kommer fra: «Arvet fra {roller}» eller «Via samling {navn}».
- Radene lenker ikke til detaljsiden for brukeren.
- Antall treff teller tildelinger, ikke brukere.
- Filtre: navn, organisasjon og miljø. Miljøfilteret kan brukes uten at en organisasjon er
  valgt, og å bytte organisasjon tømmer ikke miljøfilteret.

## Interaksjonsmønstre

### Primærhandling
Velge en rolle i rolleoversikten åpner rollens oversiktsside.

### Sekundære handlinger
- «Gi rollen til en person» i listens flate på rollens oversiktsside (BRU-PER-ROL-002).
- «Fjern tildeling» på en rad (BRU-PER-ROL-002).

### Navigasjon
- **Inn:** Menypunktet «Roller» under Tilgangsstyring, ved siden av «Personbrukere» og
  «Applikasjoner», og kortet «Roller» på Tilgangsstyring-siden.
- **Ut:** Tilbake til rolleoversikten (brødsmulesti, som på detaljsiden for en personbruker).
  Detaljsiden for en person nås fra brukeroversikten, ikke fra radene.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Laster | Samme lasteindikator som personbrukere-listen |
| Tom rolleoversikt | Ingen roller er i delegeringstaket i organisasjonene og miljøene brukeradministratoren administrerer. Teksten under |
| Tom rolleoversikt med filter | Ingen roller passer filteret. Teksten under |
| Tom liste på rollens oversiktsside | Ingen brukere brukeradministratoren kan se, har rollen aktivt tildelt. Teksten under. Knappen «Gi rollen til en person» vises fortsatt |
| Tom liste med filter | Ingen tildelinger passer filteret. Teksten under |
| Feil ved henting | Felles feilvisning som på personbrukere-listen |
| Bruker uten navn | Navnet er ikke kjent: personen har ikke logget inn, eller påloggingen oppga ikke navnet (BRU-PER-GRU-013, regelen «Navnet hentes fra påloggingen»). Navnekolonnen viser personens nummer i stedet. **Status 13.11.2026:** API-et har ikke nummeret ennå, og FS Admin viser «Navn ikke kjent». Det er et avvik som rettes i koden (Kjetil, 13.11.2026) |

## Tekster

Tekstene er godkjent av Kjetil 09.10.2026, med endringene fra workshopen 09.–10.11.2026
(kolonnen «Gjelder for organisasjon», nummeret i stedet for «Navn ikke kjent», og «Fjern
tildeling»), og menypunktet «Roller», antallet og teksten for tom rolleoversikt godkjent 13.11.2026. Dette er fasiten for
tekstene. Tekstene merket «fra fs-admin !3046, ikke godkjent» er bygget, men ikke godkjent.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Menypunkt og sidetittel | Alltid | «Roller» | – | Åpne en rolle fra rolleoversikten |
| Kort på Tilgangsstyring-siden | Alltid | «Roller», «Se rollene du kan tildele, og hvem som har dem. Herfra gir du en rolle til en person med fødselsnummer, D-nummer eller SNR.», knappen «Gå til roller» (fra fs-admin !3046, ikke godkjent) | – | Åpne en rolle fra rolleoversikten |
| Rolleoversikten | Ingen roller i delegeringstaket | «Du har ingen roller du kan se.» | Den samme teksten for den som kan tildele og den som bare kan lese, fordi listen viser de samme rollene for begge |  Rolleoversikten viser bare roller i delegeringstaket |
| Rolleoversikten, filter | Alltid | «Rolle eller beskrivelse» (fra fs-admin !3046, ikke godkjent) | – | Søke fram en rolle |
| Rolleoversikten, filter | Alltid | «Utgåtte roller», med valgene «Skjul utgåtte» og «Vis utgåtte» (fra fs-admin !3046, ikke godkjent) | – | Utgåtte roller vises ikke i rolleoversikten som standard |
| Rolleoversikten, ved rollekoden | Rollen er utgått | «Utgått» (fra fs-admin !3046, ikke godkjent) | – | En utgått rolle er merket når utgåtte roller vises |
| Rolleoversikten | Ingen roller passer filteret | «Ingen roller funnet», «Endre eller tøm filtrene for å vise flere roller.» (fra fs-admin !3046, ikke godkjent) | – | Søke fram en rolle |
| Rollens oversiktsside | Ingen brukere brukeradministratoren kan se, har rollen | «Ingen brukere du har tilgang til, har denne rollen.» | – | Vise tildelingene av en rolle |
| Rollens oversiktsside | Ingen tildelinger passer filteret | «Ingen brukere funnet», «Endre eller tøm filtrene for å vise flere brukere.» (fra fs-admin !3046, ikke godkjent) | – | Filtrere tildelingene på organisasjon |
| Antallet over listen | Alltid | «{antall} tildelinger i listen», med «tildeling» i entall | entall og flertall | Antallet på rollens oversiktsside teller tildelinger |
| Kolonneoverskrift | Alltid | «Gjelder for organisasjon» (finnes i fs-admin) | – | Vise tildelingene av en rolle |
| Navnekolonnen | Navnet til personen er ikke kjent | Personens fødselsnummer, D-nummer eller SNR | – | GRU-013: Nummeret vises i stedet for navnet når navnet mangler |
| Raden | Rollen er arvet gjennom en annen rolle | «Arvet fra {roller}», eller «Arvet» når rollene ikke er kjent (fra fs-admin !3046, ikke godkjent) | `{roller}`: rollekodene, kommaseparert | ROL-002: En rad med arvet rolle har ikke «Fjern tildeling» |
| Raden | Rollen er gitt gjennom en organisasjonssamling | «Via samling {navn}» (fra fs-admin !3046, ikke godkjent) | `{navn}`: navnet på samlingen | ROL-002: En rad med rolle gitt gjennom en organisasjonssamling har ikke «Fjern tildeling» |
| Filter på rollens oversiktsside | Alltid | «Navn», «Organisasjon» («Alle organisasjoner»), «Miljø» («Alle miljøer») (fra fs-admin !3046, ikke godkjent) | – | Filtrere tildelingene på organisasjon |
| Handling på raden | Rader der rollen er tildelt direkte, ikke arvet og ikke gjennom en organisasjonssamling | «Fjern tildeling» | – | ROL-002: Fjerne en tildeling fra rollens oversiktsside |

**Skisser:** ingen skisser finnes.

## Per-scenario detaljer

### Scenario: Åpne en rolle fra rolleoversikten
Hele raden er klikkbar, som i personbrukere-listen. Menypunktet og kortet vises for den som har
lesetilgang til brukeradministrasjon, som «Personbrukere».

### Scenario: Rolleoversikten viser bare roller i delegeringstaket
Utvalget gjøres av API-et. Klienten filtrerer ikke selv. Listen har rollene som er i
delegeringstaket til en applikasjon i minst én av organisasjonene og miljøene der
brukeradministratoren har brukeradministrator-rollen, som valglisten for rolle i «Tildel roller»
(BRU-PER-GRU-003). I dag gir `mineTildelbareTilgangsroller` hele rollekatalogen til den som har
rett til å tildele i minst én organisasjon og ett miljø, og `skjulUtenforTak` virker bare for én
organisasjon og ett miljø. API-et trenger en kilde som gir rollene i delegeringstaket på tvers av
organisasjonene og miljøene, også for den som bare kan lese.

### Scenario: Brukeradministrator med bare leserett ser rollene
Den som bare kan lese, ser rolleoversikten, rollens oversiktsside, listen og filtrene, men ikke
«Gi rollen til en person» eller «Fjern tildeling» (BRU-PER-ROL-002).

### Scenario: Søke fram en rolle
Søketeksten sendes som `kodeEllerBeskrivelseContains`, og treffer rollekoden eller beskrivelsen
uavhengig av store og små bokstaver.

### Scenario: Utgåtte roller vises ikke i rolleoversikten som standard
«Skjul utgåtte» er standard og sender `skjulUtgatte: true`. «Vis utgåtte» sender det ikke. En
utgått rolle kan åpnes og ses, men ikke gis (BRU-PER-ROL-002).

### Scenario: Vise tildelingene av en rolle
Listen er `Tilgangsrolle.personbrukerTildelinger`. Den viser bare tildelinger som er aktive nå,
direkte, gjennom en organisasjonssamling eller arvet, og bare tildelinger til personer, ikke til
Feide-brukere. Utvalget gjøres av API-et: brukeradministratoren ser tildelingene i de
organisasjonene og miljøene der hen har lesetilgang til brukeradministrasjon for personer. En
bruker med flere tildelinger av rollen står på én rad per tildeling. Listen er sortert på
etternavn og fornavn, med radene til én person samlet.

### Scenario: Brukere brukeradministratoren ellers ikke kan se, vises ikke
Utvalget gjøres av API-et. En bruker som ikke vises, nevnes ikke, heller ikke som et antall.

### Scenario: Antallet på rollens oversiktsside teller tildelinger
Antall treff i listen er antallet tildelinger (`totalCount`), så det stemmer med antallet rader.

### Scenario: Filtrere tildelingene på miljø uten å velge organisasjon
Miljøfilteret er ikke låst til en organisasjon er valgt.

### Scenario: Miljøfilteret tilbyr miljøene som er synlige i listen
Valgene er miljøene til tildelingene brukeradministratoren ser i listen, for eksempel test og
review, ikke miljøene brukeradministratoren kan tildele i (`mineTildelingsmiljoer`). Et miljø
med bare tildelinger brukeradministratoren ikke kan se, tilbys ikke. Kilden er
`personbrukerTildelingerMiljoer`, som ser bort fra filteret og pagineringen, så et miljø tilbys
selv om ingen innlastet rad har det.

### Scenario: Organisasjonsfilteret tilbyr organisasjonene som er synlige i listen
Kilden er `personbrukerTildelingerOrganisasjoner`, som ser bort fra filteret og pagineringen.
Organisasjonene sorteres på navn i klienten.

### Scenario: Søke på navn i tildelingene
Søketeksten sendes som `navnContains`, og treffer «Fornavn Etternavn» og «Etternavn Fornavn».
Et tomt søkefelt sendes som ingen filtrering.

## Avklarte designspørsmål

- Teksten for tom rolleoversikt er «Du har ingen roller du kan se.», for både den som kan
  tildele og den som bare kan lese. Den erstatter «Du har ingen roller du kan tildele.».
  Avklart 13.11.2026 (Kjetil).
- Søket på rollekode og beskrivelse beholdes. Avklart 13.11.2026 (Kjetil).

- Listen viser bare personer. Feide-brukere står ikke i listen før tildelingene er flyttet til
  personen (BRU-PER-GRU-014). Avklart 13.11.2026 (Kjetil).
- Menypunktet heter «Roller». Avklart 13.11.2026 (Kjetil).
- Listen har ingen synlig overskrift. fs-admin !3046 viser «Brukere», fordi `ActionList` ikke
  kan skjule overskriften uten å fjerne antallet, filtrene og knappen. Det er et avvik som rettes
  i koden. Avklart 13.11.2026 (Kjetil).
