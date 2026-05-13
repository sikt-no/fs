# Designnotater: Opprette applikasjon

**Relatert feature:** [`opprette_applikasjon.feature`](./opprette_applikasjon.feature)

## Overordnet UI-mønster

Opprettelse skjer i en **dialogboks (modal)** som åpnes fra listevisningen for applikasjoner. Alle obligatoriske felter fylles ut i dialogen, og ved vellykket opprettelse lukkes dialogen og brukeren navigeres videre til **detaljsiden for den nyopprettede applikasjonen**.

## Komponenter og layout

Dialogboks med:

- **Tittel:** "Opprett ny applikasjon"
- **Felter** (alle obligatoriske):
  - Identitetsleverandør — valg mellom *Feide* og *Maskinporten* (FS skal ikke være valgbar)
  - Ekstern ID — ID hos valgt identitetsleverandør (verifiseres ved innsending)
  - Organisasjon — valgliste; antall valg avhenger av rollen:
    - Tilgang til kun én organisasjon: forhåndsvalgt og låst
    - Tilgang til flere organisasjoner: valgliste begrenset til disse
    - Super-applikasjonsadministrator: valgliste over alle organisasjoner
- **Knapper i bunnen:** *Avbryt* (sekundær) og *Opprett* (primær)

## Interaksjonsmønstre

### Primærhandling
*Opprett*-knappen sender skjemaet. Verifiserer ekstern ID mot identitetsleverandøren, sjekker unik visningsnavn og unik ID. Ved suksess lukkes dialogen og brukeren navigeres til detaljsiden for applikasjonen.

### Sekundære handlinger
- *Avbryt* lukker dialogen uten å opprette
- Lukke dialogen via X eller Escape-tast tilsvarer Avbryt

### Navigasjon
- **Inn:** Knapp "Opprett applikasjon" i listevisningen åpner dialogen
- **Ut (suksess):** Automatisk navigasjon til detaljsiden for nyopprettet applikasjon
- **Ut (avbryt):** Tilbake til listevisningen, ingen endring

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Tom (åpning) | Identitetsleverandør og organisasjon kan ha forhåndsvalg når det er entydig (én org), ellers tomme felter |
| Validering | Felt-spesifikke feilmeldinger ved fokus-ut / innsending |
| Sender | *Opprett*-knappen viser lasting og er deaktivert; dialogen er ikke lukkbar mens forespørselen pågår |
| Feil (ID ikke funnet) | Feilmelding ved ID-feltet: "ID-en kunne ikke verifiseres hos {identitetsleverandør}" |
| Feil (ID i bruk) | Feilmelding ved ID-feltet: "ID-en er allerede registrert" |
| Feil (visningsnavn i bruk) | Feilmelding på toppen av dialogen: "Visningsnavnet «{navn}» er allerede i bruk" — siden navnet hentes fra idP-en, kan brukeren ikke endre det her |
| Suksess | Dialog lukkes, navigasjon til detaljside, eventuelt toast/banner "Applikasjonen er opprettet" på detaljsiden |

## Per-scenario detaljer

### Scenario: Velge identitetsleverandør ved opprettelse
Valget mellom Feide og Maskinporten presenteres tydelig (radioknapper eller segmentert kontroll). Etter opprettelse vises identitetsleverandøren som låst/skrivebeskyttet på detaljsiden.

### Scenario: FS er ikke en valgbar identitetsleverandør
FS skal ikke vises som alternativ i dialogen i det hele tatt.

### Scenario: Opprette applikasjon når administrator har tilgang til kun én organisasjon
Organisasjonsfeltet er forhåndsvalgt med administratorens eneste organisasjon og kan ikke endres.

### Scenario: Opprette applikasjon når administrator har tilgang til flere organisasjoner
Organisasjonsfeltet er en valgliste begrenset til administratorens organisasjoner.

### Scenario: Super-applikasjonsadministrator velger blant alle organisasjoner
Organisasjonsfeltet viser alle organisasjoner i systemet, med søk i lista hvis antallet er stort.

### Scenariomal: Opprette applikasjon med ekstern identitet
Visningsnavnet hentes fra idP-en ved innsending — det vises *ikke* som et redigerbart felt i dialogen. Etter suksess vises det fulle navnet på detaljsiden.

### Scenariomal: Opprettelse avvises når ID ikke finnes hos kilden
Verifisering skjer ved innsending (ikke under skriving), siden den krever et oppslag mot idP-en. Feilmelding plasseres ved ID-feltet.

### Scenariomal: Opprettelse avvises når ID allerede er registrert
Samme behandling som "ID ikke funnet" — feilmelding ved ID-feltet, men med annen tekst.

### Scenario: Intern ID genereres ved opprettelse
Den interne ID-en vises ikke i dialogen, men kan vises på detaljsiden etter opprettelse.

### Scenariomal: Opprettelse avvises når visningsnavn allerede er i bruk
Feilmeldingen plasseres på toppen av dialogen, ikke ved et felt — fordi visningsnavnet ikke er et felt brukeren har fylt ut. Teksten må forklare at navnet hentes fra idP-en og foreslå hva brukeren kan gjøre (f.eks. bytte navn i idP-en eller kontakte eier av eksisterende applikasjon).

### Scenario: Nyopprettet applikasjon er ikke aktiv i noen miljøer
Detaljsiden viser tydelig at applikasjonen ikke er aktiv i noen miljøer og hva som må til for å aktivere den (tildele tilgang).

### Scenario: Nyopprettet applikasjon kan autentisere umiddelbart
Vurder en informasjonsboks på detaljsiden som forklarer at applikasjonen kan autentisere, men ikke får data før den får tilgang i et miljø.

## Avklarte valg

- **IdP-velger:** Radioknapper med Feide og Maskinporten
- **Organisasjonsvelger:** Vanlig nedtrekksliste (uten søk), også for super-applikasjonsadministrator
- **Plassering av "Opprett applikasjon"-knapp:** I `ActionButtons`-slot i `ListPageLayout` (etablert prosjektmønster for handlinger i listevisninger)
- **Suksess-feedback:** Toast/snackbar på detaljsiden etter navigasjon ("Applikasjonen er opprettet")
- **Lasting under idP-verifisering:** Spinner i *Opprett*-knappen; knappen deaktiveres og dialogen kan ikke lukkes mens forespørselen pågår

## Åpne designspørsmål

Ingen utestående.