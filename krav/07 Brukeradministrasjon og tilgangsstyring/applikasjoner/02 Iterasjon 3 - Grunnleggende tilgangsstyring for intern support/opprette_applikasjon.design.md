# Designnotater: Opprette applikasjon

**Relatert feature:** [`opprette_applikasjon.feature`](./opprette_applikasjon.feature)

## Overordnet UI-mønster

Opprettelse skjer i en **dialogboks (modal)** som åpnes fra listevisningen for applikasjoner. Alle obligatoriske felter fylles ut i dialogen, og ved vellykket opprettelse lukkes dialogen og brukeren navigeres videre til **detaljsiden for den nyopprettede applikasjonen**.

## Komponenter og layout

Dialogboks med:

- **Tittel:** "Opprett ny applikasjon"
- **Felter** (obligatoriske, men avhengig av valgt identitetsleverandør):
  - Identitetsleverandør — valg mellom *Feide* og *Maskinporten*. *FS* er et tredje valg, og
    vises bare for administratorer med applikasjonsadministrator-rollen for Sikt
  - Ekstern ID — ID hos valgt identitetsleverandør (verifiseres ved innsending); gjelder Feide
    og Maskinporten
  - Navn — fylles ut i dialogen når identitetsleverandøren er FS; for Feide og Maskinporten
    hentes navnet i stedet fra idP-en og er ikke et felt i dialogen
  - Organisasjon — valgliste; antall valg avhenger av rollen:
    - Tilgang til kun én organisasjon: forhåndsvalgt og låst
    - Tilgang til flere organisasjoner: valgliste begrenset til disse
    - Super-applikasjonsadministrator: valgliste over alle organisasjoner
- **Knapper i bunnen:** *Avbryt* (sekundær) og *Opprett* (primær)

## Interaksjonsmønstre

### Primærhandling
*Opprett*-knappen sender skjemaet. Verifiserer ekstern ID mot identitetsleverandøren, sjekker unik visningsnavn og unik ID. Er identitetsleverandøren FS, verifiseres i stedet at organisasjonen har en registrert FS-datakilde i alle miljøer, før noe opprettes. Ved suksess lukkes dialogen og brukeren navigeres til detaljsiden for applikasjonen.

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
| Feil (mangler FS-datakilde) | Feilmelding på toppen av dialogen: "Organisasjonen mangler FS-datakilde i {miljø} — applikasjonen ble ikke opprettet". Dialogen holdes åpen med utfylte verdier |
| Suksess | Dialog lukkes, navigasjon til detaljside, eventuelt toast/banner "Applikasjonen er opprettet" på detaljsiden |

## Per-scenario detaljer

### Scenario: Velge identitetsleverandør ved opprettelse
Valget mellom Feide og Maskinporten presenteres tydelig (radioknapper eller segmentert kontroll). Etter opprettelse vises identitetsleverandøren som låst/skrivebeskyttet på detaljsiden.

### Scenario: FS som identitetsleverandør
FS vises som alternativ **bare** for en administrator med applikasjonsadministrator-rollen for Sikt. For alle andre skal alternativet ikke vises i det hele tatt — ikke som et deaktivert valg, jf. prosjektmønsteret for manglende rettighet. Velges FS, provisjonerer opprettelsen en maskinbruker i FS' webtjenester, og dialogen bør si det: det opprettes noe utenfor applikasjonsoversikten, og handlingen er derfor tyngre enn de to andre valgene.

Dialogen viser ikke miljøvalg for FS: applikasjonen er miljøløs, og identiteten gjelder i alle miljøer med én gang. I stedet for ekstern ID-oppslag fylles navnet ut manuelt (se Navn-feltet over), og innsending verifiserer i stedet at organisasjonen har registrert FS-datakilde i alle miljøer — mangler den i ett, avvises hele opprettelsen med en feilmelding som navngir miljøet, og ingenting opprettes delvis. Passord settes ikke i dialogen: detaljsiden blir inngangen til å sette ett passord per miljø, med den samme passordflyten som for øvrige applikasjoner.

Avgrensningen bør ikke lekke inn i detaljsiden: når applikasjonen først finnes, er den organisasjonens egen, og handlingene der (navn og beskrivelse, deaktivering og reaktivering, passordbytte) gates som for de øvrige applikasjonene.

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

- **IdP-velger:** Radioknapper med Feide og Maskinporten — og FS som et tredje valg for
  administratorer med applikasjonsadministrator-rollen for Sikt (besluttet 24. august 2026)
- **Organisasjonsvelger:** Vanlig nedtrekksliste (uten søk), også for super-applikasjonsadministrator
- **Plassering av "Opprett applikasjon"-knapp:** I `ActionButtons`-slot i `ListPageLayout` (etablert prosjektmønster for handlinger i listevisninger)
- **Suksess-feedback:** Toast/snackbar på detaljsiden etter navigasjon ("Applikasjonen er opprettet")
- **Lasting under idP-verifisering:** Spinner i *Opprett*-knappen; knappen deaktiveres og dialogen kan ikke lukkes mens forespørselen pågår

## Åpne designspørsmål

Disse følger av `@openquestion`-scenarioene i [`opprette_applikasjon.feature`](./opprette_applikasjon.feature) og må avklares før dialogen kan bygges ferdig.

### Feiltilstand når identitetsleverandøren ikke svarer

Tilstandstabellen over dekker «ID ikke funnet» og «ID i bruk», men ikke at selve oppslaget feiler teknisk — idP utilgjengelig, timeout eller uventet svar. Skal dialogen vise en egen feilmelding som skiller teknisk feil fra en avvist ID, og la brukeren forsøke innsending på nytt uten å fylle ut skjemaet igjen?

Jf. *Scenario: AVKLAR håndtering når identitetsleverandøren ikke svarer*.

### Forhåndsvisning av visningsnavn

Navnet hentes ved innsending og vises først på detaljsiden, slik at en navnekollisjon møter brukeren etter at skjemaet er sendt — på et navn brukeren ikke selv har fylt ut og ikke kan rette. Skal navnet i stedet hentes og vises til bekreftelse i dialogen før opprettelsen fullføres (to-trinns oppslag)? Det vil endre både layouten og primærhandlingen beskrevet over.

Jf. *Scenario: AVKLAR om visningsnavnet vises før opprettelsen fullføres*.