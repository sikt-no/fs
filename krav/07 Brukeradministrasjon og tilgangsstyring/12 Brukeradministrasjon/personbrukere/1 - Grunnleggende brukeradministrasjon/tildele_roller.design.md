# Implementasjonsdetaljer: Tildele roller til en personbruker

**Relatert feature:** [`tildele_roller.feature`](./tildele_roller.feature)

Foreløpig dekker implementasjonsdetaljene bare valglisten for rolle, og særlig regelen om taket. Resten av dialogen kan legges til her når det trengs.

## Overordnet UI-mønster

Tildelingen skjer i dialogen «Tildel roller», som åpnes fra rollefanen på detaljsiden for personbrukeren. Dialogen har tre valg i kaskade: organisasjon, miljø og roller. Valglisten for rolle er en flervalgsliste med søk, der hver rad viser rollekoden og beskrivelsen.

## Komponenter og layout

- **Organisasjon:** valgliste. Én organisasjon gir et forhåndsvalgt og låst felt.
- **Miljø:** valgliste.
- **Roller:** flervalgsliste med søkefelt øverst. Hver rad har avkrysning, rollekode og beskrivelse. Listen er låst til organisasjon og miljø er valgt.

## Interaksjonsmønstre

### Primærhandling

Tildel de avkryssede rollene for valgt organisasjon og miljø.

### Sekundære handlinger

- Søke i valglisten for rolle på kode eller beskrivelse.
- Bytte organisasjon eller miljø. Da hentes valglisten for rolle på nytt for den nye kombinasjonen, og avkrysningene nullstilles.

### Navigasjon

- **Inn:** handlingen «Tildel roller» i rollefanen på detaljsiden for personbrukeren.
- **Ut:** dialogen lukkes, og rollefanen viser de nye tildelingene.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Organisasjon eller miljø ikke valgt | Valglisten for rolle er låst, med hjelpetekst om å velge organisasjon og miljø først |
| Laster | Valglisten for rolle er låst, med lastetekst |
| Tom | Valglisten for rolle er låst, med hjelpeteksten for tom liste (se *Tekster*). Gjelder både når administratoren ikke har rettighet i kombinasjonen, og når ingen applikasjon har tak i organisasjonen og miljøet |
| Med valg | Bare forretningsroller som er i taket til minst én applikasjon i organisasjonen og miljøet, eller som en slik rolle gir, og som ikke er utgått |

## Tekster

Hjelpetekster, feilmeldinger, bekreftelser og andre tekster med variasjoner. Dette er fasiten for tekstene, også når en skisse viser noe annet.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Valglisten for rolle | Listen er tom for valgt organisasjon og miljø | «Ingen roller å tildele i denne kombinasjonen.» | Teksten finnes i FS Admin i dag (`rollerIngenRettighet`, varianten for roller, i `tilgangsstyring.json`). Samme tekst uansett hvorfor listen er tom, også når ingen applikasjon har tak | Valglisten for rolle er tom når ingen applikasjon har tak i organisasjonen og miljøet |

**Skisser:** [skjermbilde av dagens dialog](../../../../../tasks/brukeradministrasjon-og-tilgangsstyring/tildele-roller-forretningsroller/spec/krav-input/changes/2026-10-29-krav-rolleliste-begrenset-av-tak/sketches/dagens-tildel-roller-dialog.png) (Universitetet i Stavanger, Produksjon). Det viser dagens valgliste, med roller utenfor taket, og ingen tekster med variasjoner. Det er ikke en skisse av ønsket løsning.

## Per-scenario detaljer

### Regel: Valglisten for rolle viser bare roller som er i taket til en applikasjon i valgt organisasjon og miljø

- Filtreringen skjer på serveren, som et filter på den samme kilden valglisten bruker i dag. Klienten filtrerer ikke selv.
- Ingen ny visuell markering: en rolle utenfor taket vises ikke i det hele tatt, heller ikke som et deaktivert valg.
- Tildeling av en rolle utenfor taket avvises ikke. Regelen gjelder bare hva valglisten viser.
- Gjelder ikke valglisten for tilganger, og ikke tildeling til applikasjoner.
- Bare tak som gjelder nå, teller: gyldighetsperioden inneholder tidspunktet nå, og taket er ikke ugyldiggjort.
- Brukerveiledningen i FS Admin (`src/features/Brukerveiledninger/innhold/personbrukere.md`) har en «Under utvikling»-merknad om valglisten for rolle. Den må oppdateres når filteret er på plass.

### Scenario: En rolle som ikke er i noe tak kan fortsatt fjernes

Fjern-dialogen er uendret: den viser personbrukerens tildelinger uavhengig av taket.

## Åpne designspørsmål

- [x] Skal den tomme valglisten ha en egen tekst når ingen applikasjon har tak i organisasjonen og miljøet, så den skiller seg fra «ingen rettighet»? I dag gir begge tilfellene «Ingen roller å tildele i denne kombinasjonen.», og klienten kan ikke skille dem uten mer informasjon fra serveren.
  **Beslutning 2026-10-29 (Kjetil):** Den nøytrale teksten «Ingen roller å tildele i denne kombinasjonen.» beholdes. Den følger mønsteret i tilgangsstyringsmodulen i FS Admin: dialogen for applikasjoner bruker samme tekst («Ingen tilganger å tildele i denne kombinasjonen.»), og koden sier at den tomme listen er porten (`useTildelbareTilgangskoder`), så klienten skiller ikke på hvorfor listen er tom. En tildeling som faktisk avvises, har en egen feilmelding: «Du har ikke rettighet til å tildele i denne kombinasjonen av organisasjon og miljø.»
