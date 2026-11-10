# Implementasjonsdetaljer: Se brukere som har en spesifikk rolle

**Relatert feature:** [`se_brukere_på_rolle.feature`](./se_brukere_på_rolle.feature)

Detaljene gjelder scenarioene merket `@must`, og filtrene og antallet som er avklart i
workshopen 09.–10.11.2026. Det finnes ingen skisser. Detaljene bygger på mønstrene som finnes i
FS Admin i dag (personbrukere-listen og detaljsiden for en personbruker).

## Overordnet UI-mønster

To nye sider under Tilgangsstyring i FS Admin, ved siden av «Personbrukere» og «Applikasjoner»:

- **Rolleoversikten**: en liste over rollene brukeradministratoren har rett til å tildele.
- **Rollens oversiktsside**: en detaljside for én rolle, med listen over de aktive
  tildelingene av rollen til brukere brukeradministratoren ellers kan se. Herfra gis rollen til
  en person med fødselsnummer, D-nummer eller SNR, og tildelinger fjernes (se
  [`administrere_brukere_på_rolle.design.md`](./administrere_brukere_på_rolle.design.md)).

Forslag til ruter, etter mønsteret for personbrukere: `/tilgangsstyring/roller` og
`/tilgangsstyring/roller/[id]`.

## Komponenter og layout

### Rolleoversikten

- Samme listekomponent som personbrukere-listen (`NavigationList` med `ListItemCell`).
- Én rad per rolle. Kolonner: «Rolle» (rollekoden) og «Beskrivelse».
- Sortert på rollekode, stigende.
- Søk på rollenavn (scenarioet «Søke fram en rolle») er `@draft` og bygges ikke nå.

### Rollens oversiktsside

- Overskrift: rollekoden, med beskrivelsen under.
- Listen har ingen egen overskrift.
- Knappen «Gi rollen til en person» ligger i listens egen flate, som handlingselement for
  listen. Den åpner dialogen fra BRU-PER-ROL-002.
- Liste over tildelingene, med samme listekomponent. Én rad per tildeling av rollen. Kolonner:
  - «Navn». Mangler navnet, vises personens fødselsnummer, D-nummer eller SNR i stedet
    (BRU-PER-GRU-013, regelen «Nummeret vises bare når navnet mangler»).
  - «Gjelder for organisasjon» (organisasjonen tildelingen gjelder for)
  - «Miljø» (miljøet tildelingen gjelder)
- Hver rad har handlingen «Fjern tildeling» (BRU-PER-ROL-002).
- Radene lenker ikke til detaljsiden for brukeren.
- Antall treff teller tildelinger, ikke brukere.
- Filtre: organisasjon og miljø. Miljøfilteret kan brukes uten at en organisasjon er valgt.

## Interaksjonsmønstre

### Primærhandling
Velge en rolle i rolleoversikten åpner rollens oversiktsside.

### Sekundære handlinger
- «Gi rollen til en person» i listens flate på rollens oversiktsside (BRU-PER-ROL-002).
- «Fjern tildeling» på en rad (BRU-PER-ROL-002).

### Navigasjon
- **Inn:** Menypunktet «Roller» under Tilgangsstyring, ved siden av «Personbrukere» og
  «Applikasjoner».
- **Ut:** Tilbake til rolleoversikten (brødsmulesti, som på detaljsiden for en personbruker).
  Detaljsiden for en person nås fra brukeroversikten, ikke fra radene.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Laster | Samme lasteindikator som personbrukere-listen |
| Tom rolleoversikt | Brukeradministratoren har ingen roller hen kan tildele. Teksten under |
| Tom liste på rollens oversiktsside | Ingen brukere brukeradministratoren kan se, har rollen aktivt tildelt. Teksten under. Knappen «Gi rollen til en person» vises fortsatt |
| Feil ved henting | Felles feilvisning som på personbrukere-listen |
| Bruker uten navn | Navnet er ikke kjent: personen har ikke logget inn, eller påloggingen oppga ikke navnet (BRU-PER-GRU-013, regelen «Navnet hentes fra påloggingen»). Navnekolonnen viser personens nummer i stedet |

## Tekster

Tekstene er godkjent av Kjetil 09.10.2026, med endringene fra workshopen 09.–10.11.2026
(kolonnen «Gjelder for organisasjon», nummeret i stedet for «Navn ikke kjent», og «Fjern
tildeling»). Dette er fasiten for tekstene.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Rolleoversikten | Brukeradministratoren har ingen roller hen kan tildele | «Du har ingen roller du kan tildele.» | – | Rolleoversikten viser bare roller brukeradministratoren har rett til å tildele |
| Rollens oversiktsside | Ingen brukere brukeradministratoren kan se, har rollen | «Ingen brukere du har tilgang til, har denne rollen.» | – | Vise tildelingene av en rolle |
| Kolonneoverskrift | Alltid | «Gjelder for organisasjon» (finnes i fs-admin) | – | Vise tildelingene av en rolle |
| Navnekolonnen | Navnet til personen er ikke kjent | Personens fødselsnummer, D-nummer eller SNR | – | GRU-013: Nummeret vises i stedet for navnet når navnet mangler |
| Handling på raden | Alltid | «Fjern tildeling» | – | ROL-002: Fjerne en tildeling fra rollens oversiktsside |

**Skisser:** ingen skisser finnes.

## Per-scenario detaljer

### Scenario: Åpne en rolle fra rolleoversikten
Hele raden er klikkbar, som i personbrukere-listen.

### Scenario: Rolleoversikten viser bare roller brukeradministratoren har rett til å tildele
Utvalget gjøres av API-et. Klienten filtrerer ikke selv, slik «tildel roller»-dialogen heller
ikke gjør det i dag. API-et har i dag `tildelbareTilgangskoder(organisasjonId, miljoId)`, som
svarer for én organisasjon og ett miljø om gangen. Rolleoversikten trenger rollene på tvers av
organisasjonene og miljøene brukeradministratoren administrerer.

### Scenario: Vise tildelingene av en rolle
Listen viser bare tildelinger som er aktive nå, både direkte tildelte og arvede roller, til de
samme brukerne som brukeradministratoren ser i brukeroversikten. En bruker med flere
tildelinger av rollen står på én rad per tildeling.

### Scenario: Brukere brukeradministratoren ellers ikke kan se, vises ikke
Utvalget gjøres av API-et. En bruker som ikke vises, nevnes ikke, heller ikke som et antall.

### Scenario: Antallet på rollens oversiktsside teller tildelinger
Antall treff i listen er antallet tildelinger, så det stemmer med antallet rader.

### Scenario: Filtrere tildelingene på miljø uten å velge organisasjon
Miljøfilteret er ikke låst til en organisasjon er valgt.

### Scenario: Miljøfilteret tilbyr miljøene som er synlige i listen
Valgene er miljøene til tildelingene brukeradministratoren ser i listen, for eksempel test og
review, ikke miljøene brukeradministratoren kan tildele i (`mineTildelingsmiljoer`). Et miljø
med bare tildelinger brukeradministratoren ikke kan se, tilbys ikke. Det krever en kilde for
miljøene til de synlige tildelingene, ikke bare den innlastede siden av listen.

## Åpne designspørsmål

- [ ] Skal raden vise Feide-brukere og personer i samme liste til tildelingene er flyttet fra
      Feide-brukerne til personene (BRU-PER-GRU-014), og skal de i så fall merkes ulikt?
- [ ] Heter menypunktet «Roller»?
