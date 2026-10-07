# Implementasjonsdetaljer: Se brukere som har en spesifikk rolle

**Relatert feature:** [`se_brukere_på_rolle.feature`](./se_brukere_på_rolle.feature)

Detaljene gjelder scenarioene merket `@must`. Det finnes ingen skisser. Detaljene bygger på
mønstrene som finnes i FS Admin i dag (personbrukere-listen og detaljsiden for en personbruker).

## Overordnet UI-mønster

To nye sider under Tilgangsstyring i FS Admin, ved siden av «Personbrukere» og «Applikasjoner»:

- **Rolleoversikten**: en liste over rollene brukeradministratoren har rett til å tildele.
- **Rollens oversiktsside**: en detaljside for én rolle, med listen over brukere som har rollen
  aktivt tildelt, og som brukeradministratoren ellers kan se. Herfra gis rollen til en person
  med fødselsnummer, D-nummer eller SNR (se
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
- Knapp øverst til høyre: «Gi rollen til en person» (åpner dialogen fra BRU-PER-ROL-002).
- Liste over brukerne, med samme listekomponent. Én rad per bruker og tildeling av rollen.
  Kolonner:
  - «Navn»
  - «Organisasjon» (organisasjonen tildelingen gjelder)
  - «Miljø» (miljøet tildelingen gjelder)
- Fødselsnummer, D-nummer og SNR vises aldri (BRU-PER-GRU-013).
- En rad lenker til detaljsiden for brukeren.

## Interaksjonsmønstre

### Primærhandling
Velge en rolle i rolleoversikten åpner rollens oversiktsside.

### Sekundære handlinger
- «Gi rollen til en person» på rollens oversiktsside (BRU-PER-ROL-002).
- Velge en bruker i listen åpner detaljsiden for brukeren.

### Navigasjon
- **Inn:** Menypunktet «Roller» under Tilgangsstyring, ved siden av «Personbrukere» og
  «Applikasjoner».
- **Ut:** Til detaljsiden for en bruker, eller tilbake til rolleoversikten (brødsmulesti, som
  på detaljsiden for en personbruker).

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Laster | Samme lasteindikator som personbrukere-listen |
| Tom rolleoversikt | Brukeradministratoren har ingen roller hen kan tildele. Teksten under |
| Tom liste på rollens oversiktsside | Ingen brukere brukeradministratoren kan se, har rollen aktivt tildelt. Teksten under. Knappen «Gi rollen til en person» vises fortsatt |
| Feil ved henting | Felles feilvisning som på personbrukere-listen |
| Bruker uten navn | Personen har ikke logget inn ennå (BRU-PER-GRU-013, regelen «Navnet hentes fra påloggingen», `@draft`). Teksten under, i navnekolonnen |

## Tekster

Alle tekstene er forslag og må godkjennes av Kjetil. Dette er fasiten for tekstene.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Rolleoversikten | Brukeradministratoren har ingen roller hen kan tildele | «Du har ingen roller du kan tildele.» | – | Rolleoversikten viser bare roller brukeradministratoren har rett til å tildele |
| Rollens oversiktsside | Ingen brukere brukeradministratoren kan se, har rollen | «Ingen brukere du har tilgang til, har denne rollen.» | – | Vise brukere som har en aktiv rolle |
| Navnekolonnen | Personen har ikke noe navn ennå | «Ikke logget inn ennå» | – | Vise brukere som har en aktiv rolle |

**Skisser:** ingen skisser finnes.

## Per-scenario detaljer

### Scenario: Åpne en rolle fra rolleoversikten
Hele raden er klikkbar, som i personbrukere-listen.

### Scenario: Rolleoversikten viser bare roller brukeradministratoren har rett til å tildele
Utvalget gjøres av API-et. Klienten filtrerer ikke selv, slik «tildel roller»-dialogen heller
ikke gjør det i dag. API-et har i dag `tildelbareTilgangskoder(organisasjonId, miljoId)`, som
svarer for én organisasjon og ett miljø om gangen. Rolleoversikten trenger rollene på tvers av
organisasjonene og miljøene brukeradministratoren administrerer.

### Scenario: Vise brukere som har en aktiv rolle
Listen viser bare tildelinger som er aktive nå, både direkte tildelte og arvede roller. Det er de samme brukerne som
brukeradministratoren ser i brukeroversikten.

### Scenario: Brukere brukeradministratoren ellers ikke kan se, vises ikke
Utvalget gjøres av API-et. En bruker som ikke vises, nevnes ikke, heller ikke som et antall.

### Scenario: Åpne brukersiden fra rollens oversiktsside
Hele raden er klikkbar og åpner detaljsiden for brukeren, som i personbrukere-listen. Der
tildeler brukeradministratoren flere roller med «Tildel roller».

## Åpne designspørsmål

- [ ] Godkjenn tekstene i tabellen over.
- [ ] Skal raden vise Feide-brukere og personer i samme liste til tildelingene er flyttet fra
      Feide-brukerne til personene (BRU-PER-GRU-014), og skal de i så fall merkes ulikt?
- [ ] Teksten «Ikke logget inn ennå» passer ikke for en person som har logget inn med ID-porten,
      men ikke har navn. Avhenger av det åpne spørsmålet om ID-porten i BRU-PER-GRU-013.
- [ ] Heter menypunktet «Roller»?
