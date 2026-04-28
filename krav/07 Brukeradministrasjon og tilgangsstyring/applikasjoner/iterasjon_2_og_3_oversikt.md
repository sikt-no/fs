# Iterasjon 2 og 3 — Administrasjon av API-brukere

Aggregert oversikt over alle features i GitHub issue
[#434](https://github.com/sikt-no/fs/issues/434) (Iterasjon 2) og
[#435](https://github.com/sikt-no/fs/issues/435) (Iterasjon 3). Hver seksjon
gjengir hele innholdet i `.feature`-filen, slik at hele kravsettet finnes på ett
sted for arbeid med Claude Code.

## Innhold

**Iterasjon 2 — Support: Oversikt og passordbytte ([#434](https://github.com/sikt-no/fs/issues/434))**
- [BRU-APP-API-001 — Listevisning og søk i API-brukere](#bru-app-api-001--listevisning-og-søk-i-api-brukere)
- [BRU-APP-API-002 — Se detaljer for API-bruker](#bru-app-api-002--se-detaljer-for-api-bruker)
- [BRU-APP-API-003 — Vise roller for API-bruker](#bru-app-api-003--vise-roller-for-api-bruker)
- [BRU-APP-API-004 — Passordbytte for API-bruker](#bru-app-api-004--passordbytte-for-api-bruker)
- [BRU-APP-API-005 — Administrere ansvarlig for API-bruker](#bru-app-api-005--administrere-ansvarlig-for-api-bruker)
- [BRU-APP-API-006 — Redigere beskrivelse for API-bruker](#bru-app-api-006--redigere-beskrivelse-for-api-bruker)

**Iterasjon 3 — Grunnleggende tilgangsstyring for intern support ([#435](https://github.com/sikt-no/fs/issues/435))**
- [BRU-APP-API-007 — Tilordne rolle til API-bruker](#bru-app-api-007--tilordne-rolle-til-api-bruker)
- [BRU-APP-API-008 — Fjerne rolle fra API-bruker](#bru-app-api-008--fjerne-rolle-fra-api-bruker)
- [BRU-APP-API-009 — Opprette API-bruker](#bru-app-api-009--opprette-api-bruker)
- [BRU-APP-API-010 — Deaktivere API-bruker](#bru-app-api-010--deaktivere-api-bruker)

---

## Iterasjon 2 — Support: Oversikt og passordbytte

GitHub: [#434](https://github.com/sikt-no/fs/issues/434)

### BRU-APP-API-001 — Listevisning og søk i API-brukere

**Fil:** [listevisning_og_sok.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature)
**GitHub:** [#438](https://github.com/sikt-no/fs/issues/438), [#448](https://github.com/sikt-no/fs/issues/448), [#449](https://github.com/sikt-no/fs/issues/449)

```gherkin
# language: no
# GitHub: #438, #448, #449
@BRU-APP-API-001 @must @planned
Egenskap: Listevisning og søk i API-brukere
  Som bruker
  ønsker jeg en oversikt over API-brukere jeg har tilgang til, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig API-bruker.

  # Krav fra Confluence: K1 Liste over alle API-brukere, K2 Søk og filtrering, K11 Oversikt over egne API-brukere, K12 Se API-brukere med tilgang til lærestedets data

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Liste over alle API-brukere (K1)

    Scenario: Se liste over API-brukere
      Når jeg åpner API-brukeroversikten
      Så ser jeg en liste over alle API-brukere
      Og listen er sortert etter navn i stigende rekkefølge
      Og hvert innslag viser følgende informasjon:
        | felt                |
        | Navn                |
        | Beskrivelse         |
        | Miljøer             |
        | Ansvarlig           |
        | Organisasjon        |
        | Type API-bruker     |
        | Oppfølgningsstatus  |

    Scenario: Liste viser de 50 første API-brukerne
      Når jeg åpner API-brukeroversikten
      Så ser jeg totalt antall treff og antall som er lastet
      Og listen viser de 50 første API-brukerne

    Scenario: Laste inn 50 flere API-brukere
      Gitt jeg ser listen over API-brukere
      Og det finnes flere API-brukere enn det som er lastet inn
      Når jeg velger å laste inn flere
      Så lastes de neste 50 API-brukerne inn i listen

    Scenario: Alle API-brukere er lastet inn
      Gitt jeg ser listen over API-brukere
      Og alle API-brukere er lastet inn
      Så er muligheten til å laste inn flere ikke tilgjengelig

    Scenario: Navigere til detaljside for API-bruker
      Gitt jeg ser listen over API-brukere
      Når jeg velger en API-bruker
      Så ser jeg detaljsiden for valgt API-bruker

  Regel: Søk og filtrering av API-brukere (K2)

    Scenario: Fritekst-søk på navn
      Gitt jeg ser listen over API-brukere
      Når jeg søker med fritekst på navn
      Så filtreres listen til API-brukere som matcher søket

    Scenario: Filtrere på organisasjon
      Gitt jeg ser listen over API-brukere
      Når jeg velger en organisasjon som filter
      Så vises kun API-brukere tilknyttet valgt organisasjon

    @could
    Scenario: Filtrere på rolle
      Gitt jeg ser listen over API-brukere
      Når jeg velger en rolle som filter
      Så vises kun API-brukere som har den valgte rollen

    Scenario: Kombinere filtre
      Gitt jeg ser listen over API-brukere
      Når jeg kombinerer fritekst-søk med ett eller flere filter
      Så vises kun API-brukere som matcher alle kriteriene

  Regel: Synlighet styres av administrasjonsrettigheter (K11, K12)

    Scenario: Api-brukeradministrator ser API-brukere fra egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for én eller flere organisasjoner
      Når jeg åpner API-brukeroversikten
      Så ser jeg API-brukere tilknyttet de organisasjonene jeg administrerer

    Scenario: Api-brukeradministrator ser også API-brukere med roller i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for én eller flere organisasjoner
      Og en API-bruker tilhører en annen organisasjon, men har roller som gir tilgang til data i en av mine organisasjoner
      Når jeg åpner API-brukeroversikten
      Så ser jeg denne API-brukeren i listen
      Og det fremgår hvilken organisasjon API-brukeren tilhører

    Scenario: Api-superbrukeradministrator ser alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Når jeg åpner API-brukeroversikten
      Så ser jeg alle API-brukere uavhengig av organisasjon
      Og jeg ser også API-brukere som ikke er tilknyttet noen organisasjon
```

---

### BRU-APP-API-002 — Se detaljer for API-bruker

**Fil:** [se_detaljer.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature)
**GitHub:** [#439](https://github.com/sikt-no/fs/issues/439)

```gherkin
# language: no
# GitHub: #439
@BRU-APP-API-002 @must @planned
Egenskap: Se detaljer for API-bruker
  Som bruker
  ønsker jeg å se detaljer for en API-bruker, organisert i logiske datagrupper,
  slik at jeg har oversikt over API-brukeren.

  # Krav fra Confluence: K3 Se detaljer for API-bruker

  Bakgrunn:
    Gitt jeg ser detaljer for en API-bruker

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se grunnleggende informasjon
      Så ser jeg navn og beskrivelse

    Scenario: Se sporingsinfo
      Så ser jeg opprettet av, opprettet tidspunkt, endret av og endret tidspunkt

    Scenario: Se miljøer
      Så ser jeg hvilke miljøer API-brukeren er aktiv i

    Scenario: Se ansvarlig
      Så ser jeg hvem som er ansvarlig for API-brukeren
```

---

### BRU-APP-API-003 — Vise roller for API-bruker

**Fil:** [vise_roller.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_roller.feature)
**GitHub:** [#440](https://github.com/sikt-no/fs/issues/440)

```gherkin
# language: no
# GitHub: #440
@BRU-APP-API-003 @must @planned
Egenskap: Vise roller for API-bruker
  Som bruker
  ønsker jeg å se hvilke roller en API-bruker har
  slik at jeg forstår hvilke rettigheter og miljøtilgang API-brukeren er tildelt.

  # Krav fra Confluence: K4 Se roller for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker
    Og jeg har åpnet tab-en for roller

  Scenario: Se roller for en API-bruker
    Så ser jeg en liste over alle roller tilknyttet API-brukeren
    Og hvert innslag viser rollekode og miljøet rollen gjelder for

  Scenario: Filtrere rolleliste på miljø
    Når jeg filtrerer rollelisten på miljø
    Så vises kun roller i de valgte miljøene
    Og filtervalget er begrenset til miljøer API-brukeren har roller i

  Scenario: Filtrere rolleliste på rolle
    Når jeg filtrerer rollelisten på rolle
    Så vises kun de valgte rollene
    Og filtervalget er begrenset til roller API-brukeren er tildelt

  Scenario: Sortere rolleliste
    Når jeg sorterer rollelisten på miljø eller rollekode
    Så vises rollene i valgt sorteringsrekkefølge

  Scenario: Laste flere roller
    Gitt API-brukeren har flere enn 50 roller
    Og de 50 første rollene er lastet inn
    Når jeg velger å laste inn flere
    Så lastes de neste rollene inn i listen
```

---

### BRU-APP-API-004 — Passordbytte for API-bruker

**Fil:** [passordbytte.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/passordbytte.feature)
**GitHub:** [#441](https://github.com/sikt-no/fs/issues/441)

```gherkin
# language: no
# GitHub: #441
@BRU-APP-API-004 @must @planned
Egenskap: Passordbytte for API-bruker
  Som bruker
  ønsker jeg å sette nytt passord på en API-bruker jeg har rettighet til å administrere
  slik at jeg kan hjelpe med passordbytte.

  API-brukeren autentiserer seg med basic auth og har alltid kun ett
  aktivt passord om gangen. Passordet genereres av systemet.

  # Krav fra Confluence: K5 Sette nytt passord på API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker

  Regel: Bruker kan kun endre passord på API-brukere de har rettighet til å administrere

    Scenario: Passordbytte ikke tilgjengelig uten rettighet
      Gitt jeg ikke har rettighet til å endre passord på denne API-brukeren
      Så er muligheten til å sette nytt passord ikke tilgjengelig

  Regel: Nytt passord genereres av systemet

    Scenario: Generere nytt passord
      Gitt jeg har rettighet til å endre passord på denne API-brukeren
      Når jeg velger å generere et nytt passord
      Så genererer systemet et nytt passord for API-brukeren
      Og det nye passordet er lagret

  Regel: Det genererte passordet vises én gang og kan kopieres

    Scenario: Passordet er skjult som standard
      Gitt systemet nettopp har generert et nytt passord
      Så vises passordet skjult med mulighet for å velge å vise det
      Og passordet kan kopieres

    Scenario: Passordet kan ikke hentes opp igjen etter at dialogen er lukket
      Gitt systemet har generert et nytt passord som jeg har sett
      Når jeg lukker dialogen
      Så er passordet ikke lenger tilgjengelig
      Og jeg må generere et nytt passord dersom jeg trenger å se det på nytt

  Regel: Kun ett passord er aktivt om gangen

    Scenario: Nytt passord erstatter det gamle umiddelbart
      Gitt API-brukeren har et aktivt passord
      Når et nytt passord genereres
      Så fungerer ikke det gamle passordet lenger
      Og API-brukeren må autentisere seg med det nye passordet
```

---

### BRU-APP-API-005 — Administrere ansvarlig for API-bruker

**Fil:** [administrere_ansvarlig.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/administrere_ansvarlig.feature)
**GitHub:** [#442](https://github.com/sikt-no/fs/issues/442)

```gherkin
# language: no
# GitHub: #442
@BRU-APP-API-005 @must @planned
Egenskap: Administrere ansvarlig for API-bruker
  Som bruker
  ønsker jeg å sette og endre ansvarlig for en API-bruker
  slik at det alltid er klart hvem som er ansvarlig for API-brukeren.

  En ansvarlig er alltid en feide-bruker eller feide-gruppe, og er den
  som eventuelt har kontakt med tredjeparten som benytter API-brukeren.
  Ansvarlig arver muligheten til å endre passord på API-brukeren.

  # Krav fra Confluence: K18 Administrere ansvarlig for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker

  Regel: Ansvarlig kan settes, endres og fjernes

    Scenario: Sette ansvarlig
      Gitt API-brukeren har ingen ansvarlig
      Når jeg søker opp og velger en feide-bruker fra API-brukerens organisasjon
      Så er den valgte feide-brukeren registrert som ansvarlig for API-brukeren

    Scenario: Endre ansvarlig
      Gitt API-brukeren har en ansvarlig
      Når jeg søker opp og velger en annen feide-bruker fra API-brukerens organisasjon
      Så er den nye feide-brukeren registrert som ansvarlig for API-brukeren

    Scenario: Fjerne ansvarlig
      Gitt API-brukeren har en ansvarlig
      Når jeg fjerner den ansvarlige
      Så har API-brukeren ikke lenger en ansvarlig registrert

  Regel: Søk etter ansvarlig er avgrenset til API-brukerens organisasjon

    Scenario: Kun treff fra API-brukerens egen organisasjon vises
      Gitt jeg velger å sette ansvarlig
      Når jeg søker etter en ansvarlig
      Så vises kun treff fra API-brukerens organisasjon

  Regel: En feide-gruppe kan settes som ansvarlig som alternativ til feide-bruker

    @could
    Scenario: Sette en feide-gruppe som ansvarlig
      Gitt API-brukeren har ingen ansvarlig
      Når jeg søker opp og velger en feide-gruppe fra API-brukerens organisasjon
      Så er den valgte feide-gruppen registrert som ansvarlig for API-brukeren

    @could
    Scenario: Søkeresultat inkluderer feide-grupper
      Gitt jeg velger å sette ansvarlig
      Når jeg søker etter en ansvarlig
      Så vises feide-grupper fra API-brukerens organisasjon i tillegg til feide-brukere

  Regel: Administrasjon av ansvarlig krever rettighet over API-brukerens organisasjon

    Scenario: Api-brukeradministrator kan administrere ansvarlig for API-brukere i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for organisasjonen API-brukeren tilhører
      Så har jeg mulighet til å sette, endre og fjerne ansvarlig

    Scenario: Administrasjon av ansvarlig er ikke tilgjengelig for API-brukere fra andre organisasjoner
      Gitt jeg har api-brukeradministrator-rollen, men ikke for organisasjonen API-brukeren tilhører
      Så er muligheten til å sette, endre og fjerne ansvarlig ikke tilgjengelig

    Scenario: Api-superbrukeradministrator kan administrere ansvarlig for alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Så har jeg mulighet til å sette, endre og fjerne ansvarlig uavhengig av organisasjon
```

---

### BRU-APP-API-006 — Redigere beskrivelse for API-bruker

**Fil:** [rediger_beskrivelse.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/rediger_beskrivelse.feature)
**GitHub:** [#443](https://github.com/sikt-no/fs/issues/443)

```gherkin
# language: no
# GitHub: #443
@BRU-APP-API-006 @must @planned
Egenskap: Redigere beskrivelse for API-bruker
  Som bruker
  ønsker jeg å redigere beskrivelsen for en API-bruker
  slik at informasjonen er oppdatert og korrekt.

  # Krav fra Confluence: K19 Redigere beskrivelse for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker

  Regel: Redigering av beskrivelse krever rettighet over API-brukerens organisasjon

    Scenario: Oppdatere beskrivelse
      Gitt jeg har rettighet til å administrere API-brukeren
      Når jeg oppdaterer beskrivelsen
      Så er den nye beskrivelsen lagret på API-brukeren

    Scenario: Api-brukeradministrator kan redigere beskrivelse for API-brukere i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for organisasjonen API-brukeren tilhører
      Så har jeg mulighet til å redigere beskrivelsen

    Scenario: Redigering av beskrivelse er ikke tilgjengelig for API-brukere fra andre organisasjoner
      Gitt jeg har api-brukeradministrator-rollen, men ikke for organisasjonen API-brukeren tilhører
      Så er muligheten til å redigere beskrivelsen ikke tilgjengelig

    Scenario: Api-superbrukeradministrator kan redigere beskrivelse for alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Så har jeg mulighet til å redigere beskrivelsen uavhengig av organisasjon
```

---

## Iterasjon 3 — Grunnleggende tilgangsstyring for intern support

GitHub: [#435](https://github.com/sikt-no/fs/issues/435)

### BRU-APP-API-007 — Tilordne rolle til API-bruker

**Fil:** [tilordne_rolle.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/tilordne_rolle.feature)
**GitHub:** [#444](https://github.com/sikt-no/fs/issues/444), [#450](https://github.com/sikt-no/fs/issues/450)

```gherkin
# language: no
# GitHub: #444, #450
@BRU-APP-API-007 @must @planned
Egenskap: Tilordne rolle til API-bruker
  Som bruker med api-brukeradministrator-rollen
  ønsker jeg å tilordne en rolle til en API-bruker for et gitt miljø og en gitt organisasjon
  slik at API-brukeren får tilgang til de dataene den trenger i riktig miljø.

  # Krav fra Confluence: K6 Tilordne rolle til API-bruker, K13 Tilordne rolle til API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker

  Regel: En tilordning gjelder én rolle i ett eksplisitt valgt miljø

    Scenario: Tilordne en rolle i et valgt miljø
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele
      Så har API-brukeren fått den valgte rollen i det valgte miljøet
      Og det fremgår tydelig hvilket miljø og hvilken organisasjon tilordningen gjelder

    Scenario: Tilordne flere roller samtidig i ett valgt miljø
      Når jeg velger et miljø og flere roller jeg har rettighet til å tildele
      Så har API-brukeren fått alle de valgte rollene i det valgte miljøet

  Regel: Bruker kan kun tildele roller de selv har rettighet til å tildele

    Scenario: Valglisten viser kun roller jeg har rettighet til å tildele
      Når jeg åpner valglisten for å tilordne en rolle
      Så ser jeg kun roller jeg har rettighet til å tildele

  Regel: En rolle som allerede er tildelt i valgt miljø kan ikke tilordnes på nytt

    Scenario: Allerede tildelt rolle vises som ikke-valgbar
      Gitt API-brukeren har en rolle tildelt i et miljø
      Når jeg åpner valglisten for å tilordne roller i samme miljø
      Så vises den allerede tildelte rollen gråtonet og ikke valgbar
      Og det fremgår at rollen allerede er tildelt

  Regel: Rolletildeling gjelder en organisasjon administratoren har rettighet for (K13)

    Scenario: Organisasjon er implisitt når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt API-brukeren i det valgte miljøet for min organisasjon

    Scenario: Organisasjon velges når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg velger et miljø, en organisasjon og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt API-brukeren i det valgte miljøet for den valgte organisasjonen

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har api-brukeradministrator-rollen for

  @openquestion
  Scenario: AVKLAR avgrensning av hvilke miljøer rollen kan tilordnes i
    # ÅPNE SPØRSMÅL:
    # - Arkitekturføring: kan en API-bruker autentisere seg til flere miljøer
    #   samtidig, eller er en API-bruker knyttet til kun ett miljø (og kan
    #   dermed bare ha roller i det ene miljøet)? Svaret her styrer de øvrige
    #   spørsmålene under.
    # - Hvis API-bruker kan ha roller i flere miljøer: begrenses miljøvalget
    #   til miljøer API-brukeren allerede er aktiv i, eller kan api-brukeradministratoren
    #   tildele roller i nye miljøer (evt. begrenset til miljøer administratoren
    #   selv har rettighet i)?
    # - Hvis flere miljøer er mulig: skal en tilordning i et nytt miljø
    #   automatisk gjøre API-brukeren aktiv i det miljøet?
    Gitt spørsmålet er åpent
```

---

### BRU-APP-API-008 — Fjerne rolle fra API-bruker

**Fil:** [fjerne_rolle.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/fjerne_rolle.feature)
**GitHub:** [#445](https://github.com/sikt-no/fs/issues/445), [#451](https://github.com/sikt-no/fs/issues/451)

```gherkin
# language: no
# GitHub: #445, #451
@BRU-APP-API-008 @must @planned
Egenskap: Fjerne rolle fra API-bruker
  Som bruker med api-brukeradministrator-rollen
  ønsker jeg å fjerne en rolle fra en API-bruker
  slik at API-brukeren mister tilgang til data den ikke lenger skal ha.

  # Krav fra Confluence: K7 Fjerne rolle fra API-bruker, K14 Fjerne rolle fra API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en API-bruker
    Og jeg ser listen over roller API-brukeren har

  Regel: En fjerning krever en eksplisitt bekreftelse

    Scenario: Bekreftelsesdialog vises før enkeltrolle fjernes
      Gitt API-brukeren har en rolle jeg har rettighet til å fjerne
      Når jeg velger å fjerne rollen
      Så vises en bekreftelsesdialog som viser rolle og miljø som skal fjernes

    Scenario: Bekrefte fjerning av en enkeltrolle
      Gitt jeg har igangsatt fjerning av én rolle
      Når jeg bekrefter fjerningen
      Så har API-brukeren ikke lenger den rollen i det miljøet

    Scenario: Avbryte fjerning
      Gitt jeg har igangsatt fjerning av én eller flere roller
      Når jeg avbryter
      Så er ingen endringer gjort på API-brukerens roller

  Regel: Flere roller i ett miljø kan fjernes samtidig

    Scenario: Bekreftelsesdialog for bulk-fjerning lister alle valgte roller
      Gitt API-brukeren har flere roller jeg har rettighet til å fjerne i et miljø
      Når jeg velger flere av disse rollene innenfor det samme miljøet og velger å fjerne dem
      Så vises en bekreftelsesdialog som lister alle valgte roller og miljøet

    Scenario: Bekrefte bulk-fjerning
      Gitt jeg har igangsatt bulk-fjerning av roller i ett miljø
      Når jeg bekrefter fjerningen
      Så har API-brukeren ikke lenger noen av de valgte rollene i det valgte miljøet

  Regel: Bruker kan kun fjerne roller de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for roller uten rettighet
      Gitt API-brukeren har en rolle jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den rollen ikke tilgjengelig
```

---

### BRU-APP-API-009 — Opprette API-bruker

**Fil:** [opprette_api_bruker.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_api_bruker.feature)
**GitHub:** [#446](https://github.com/sikt-no/fs/issues/446)

```gherkin
# language: no
# GitHub: #446
@BRU-APP-API-009 @must @planned
Egenskap: Opprette API-bruker
  Som bruker med api-brukeradministrator-rollen
  ønsker jeg å opprette en ny API-bruker
  slik at nye integrasjoner kan konfigureres.

  # Krav fra Confluence: K8 Opprette ny API-bruker

  Regel: Opprettelse krever navn og organisasjon for en vanlig api-brukeradministrator

    Scenario: Opprette API-bruker når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg oppretter en ny API-bruker med et navn
      Så er API-brukeren opprettet med det valgte navnet og min organisasjon

    Scenario: Opprette API-bruker når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg oppretter en ny API-bruker med et navn og velger en av mine organisasjoner
      Så er API-brukeren opprettet med det valgte navnet og den valgte organisasjonen

  Regel: Api-superbrukeradministrator kan opprette API-bruker uten organisasjon

    Scenario: Opprette API-bruker uten organisasjon
      Gitt jeg har api-superbrukeradministrator-rollen
      Når jeg oppretter en ny API-bruker med et navn og uten å velge en organisasjon
      Så er API-brukeren opprettet uten organisasjon
      Og API-brukeren kan kun administreres av andre api-superbrukeradministratorer

  Regel: Nyopprettet API-bruker kan ikke brukes før passord er satt og rolle er tildelt

    Scenario: Nyopprettet API-bruker har ikke passord
      Gitt jeg har opprettet en ny API-bruker
      Så har API-brukeren ikke satt passord
      Og API-brukeren kan ikke benyttes til autentisering før passord settes via passordbytte

    Scenario: Nyopprettet API-bruker er ikke aktiv i noen miljøer
      Gitt jeg har opprettet en ny API-bruker
      Så er API-brukeren ikke aktiv i noen miljøer
      Og API-brukeren blir først aktiv i et miljø når den får tildelt sin første rolle i det miljøet

  @openquestion
  Scenario: AVKLAR status på nyopprettet API-bruker uten passord og roller
    # ÅPNE SPØRSMÅL:
    # - Skal en nyopprettet API-bruker vises som "ikke aktiv" (eller tilsvarende
    #   status) i lista og på detaljsiden inntil den har fått passord og/eller
    #   sin første rolle, eller må den aktiveres eksplisitt?
    # - Hvordan forholder dette seg til "Deaktivere API-bruker" (K9)?
    #   Er "nyopprettet uten passord/roller" og "deaktivert" samme tilstand,
    #   eller to distinkte tilstander?
    Gitt spørsmålet er åpent
```

---

### BRU-APP-API-010 — Deaktivere API-bruker

**Fil:** [deaktivere_api_bruker.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/deaktivere_api_bruker.feature)
**GitHub:** [#447](https://github.com/sikt-no/fs/issues/447)

```gherkin
# language: no
# GitHub: #447
@BRU-APP-API-010 @must @planned
Egenskap: Deaktivere API-bruker
  Som bruker med api-brukeradministrator-rollen
  ønsker jeg å deaktivere en API-bruker
  slik at en API-bruker som ikke lenger er i bruk ikke kan benyttes.

  # Krav fra Confluence: K9 Deaktivere API-bruker

  Regel: Deaktivering krever bekreftelse og hindrer autentisering

    Scenario: Bekreftelsesdialog vises før deaktivering
      Gitt jeg er på detaljsiden for en aktiv API-bruker jeg kan administrere
      Når jeg velger å deaktivere API-brukeren
      Så vises en bekreftelsesdialog før deaktiveringen gjennomføres

    Scenario: Bekrefte deaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å deaktivere en API-bruker
      Når jeg bekrefter deaktiveringen
      Så er API-brukeren ikke lenger aktiv
      Og API-brukeren kan ikke benyttes til autentisering

    Scenario: Avbryte deaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å deaktivere en API-bruker
      Når jeg avbryter
      Så er API-brukeren fortsatt aktiv

  Regel: Deaktivering er reversibel og bevarer rollene

    Scenario: Deaktivert API-bruker beholder sine roller
      Gitt en API-bruker nettopp har blitt deaktivert
      Så er rollene som var tildelt fortsatt knyttet til API-brukeren
      Men rollene gir ikke tilgang så lenge API-brukeren er deaktivert

  Regel: Reaktivering krever bekreftelse og gjenoppretter API-brukerens tilganger

    Scenario: Bekreftelsesdialog vises før reaktivering
      Gitt jeg er på detaljsiden for en deaktivert API-bruker jeg kan administrere
      Når jeg velger å reaktivere API-brukeren
      Så vises en bekreftelsesdialog før reaktiveringen gjennomføres

    Scenario: Bekrefte reaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å reaktivere en API-bruker
      Når jeg bekrefter reaktiveringen
      Så er API-brukeren aktiv igjen
      Og rollene som var tildelt før deaktivering gir igjen tilgang

  Regel: Rettighet til å deaktivere og reaktivere følger administrasjonsrettighetene
   
    Scenario: Api-brukeradministrator kan deaktivere API-brukere i egne organisasjoner
      Gitt jeg har api-brukeradministrator-rollen for en organisasjon
      Og API-brukeren tilhører den organisasjonen
      Så har jeg mulighet til å deaktivere og reaktivere API-brukeren

    Scenario: Api-superbrukeradministrator kan deaktivere alle API-brukere
      Gitt jeg har api-superbrukeradministrator-rollen
      Så har jeg mulighet til å deaktivere og reaktivere enhver API-bruker uavhengig av organisasjon
```
