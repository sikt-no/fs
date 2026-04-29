# Iterasjon 2 og 3 — Administrasjon av applikasjoner

Aggregert oversikt over alle features i GitHub issue
[#434](https://github.com/sikt-no/fs/issues/434) (Iterasjon 2) og
[#435](https://github.com/sikt-no/fs/issues/435) (Iterasjon 3). Hver seksjon
gjengir hele innholdet i `.feature`-filen, slik at hele kravsettet finnes på ett
sted for arbeid med Claude Code.

## Innhold

**Iterasjon 2 — Support: Oversikt og passordbytte ([#434](https://github.com/sikt-no/fs/issues/434))**
- [BRU-APP-API-001 — Listevisning og søk i applikasjoner](#bru-app-api-001--listevisning-og-søk-i-applikasjoner)
- [BRU-APP-API-002 — Se detaljer for applikasjon](#bru-app-api-002--se-detaljer-for-applikasjon)
- [BRU-APP-API-003 — Vise roller for applikasjon](#bru-app-api-003--vise-roller-for-applikasjon)
- [BRU-APP-API-004 — Passordbytte for applikasjon](#bru-app-api-004--passordbytte-for-applikasjon)
- [BRU-APP-API-005 — Administrere ansvarlig for applikasjon](#bru-app-api-005--administrere-ansvarlig-for-applikasjon)
- [BRU-APP-API-006 — Redigere beskrivelse for applikasjon](#bru-app-api-006--redigere-beskrivelse-for-applikasjon)

**Iterasjon 3 — Grunnleggende tilgangsstyring for intern support ([#435](https://github.com/sikt-no/fs/issues/435))**
- [BRU-APP-API-007 — Tilordne rolle til applikasjon](#bru-app-api-007--tilordne-rolle-til-applikasjon)
- [BRU-APP-API-008 — Fjerne rolle fra applikasjon](#bru-app-api-008--fjerne-rolle-fra-applikasjon)
- [BRU-APP-API-009 — Opprette applikasjon](#bru-app-api-009--opprette-applikasjon)
- [BRU-APP-API-010 — Deaktivere applikasjon](#bru-app-api-010--deaktivere-applikasjon)

---

## Iterasjon 2 — Support: Oversikt og passordbytte

GitHub: [#434](https://github.com/sikt-no/fs/issues/434)

### BRU-APP-API-001 — Listevisning og søk i applikasjoner

**Fil:** [listevisning_og_sok.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature)
**GitHub:** [#438](https://github.com/sikt-no/fs/issues/438), [#448](https://github.com/sikt-no/fs/issues/448), [#449](https://github.com/sikt-no/fs/issues/449)

```gherkin
# language: no
# GitHub: #438, #448, #449
@BRU-APP-API-001 @must @planned
Egenskap: Listevisning og søk i applikasjoner
  Som bruker
  ønsker jeg en oversikt over applikasjoner jeg har tilgang til, med mulighet for søk og filtrering
  slik at jeg raskt kan finne og følge opp riktig applikasjon.

  # Krav fra Confluence: K1 Liste over alle API-brukere, K2 Søk og filtrering, K11 Oversikt over egne API-brukere, K12 Se API-brukere med tilgang til lærestedets data

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Liste over alle applikasjoner (K1)

    Scenario: Se liste over applikasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg en liste over alle applikasjoner
      Og listen er sortert etter navn i stigende rekkefølge
      Og hvert innslag viser følgende informasjon:
        | felt                |
        | Navn                |
        | Beskrivelse         |
        | Miljøer             |
        | Ansvarlig           |
        | Organisasjon        |
        | Type applikasjon     |
        | Oppfølgningsstatus  |

    Scenario: Liste viser de 50 første applikasjonene
      Når jeg åpner applikasjonsoversikten
      Så ser jeg totalt antall treff og antall som er lastet
      Og listen viser de 50 første applikasjonene

    Scenario: Laste inn 50 flere applikasjoner
      Gitt jeg ser listen over applikasjoner
      Og det finnes flere applikasjoner enn det som er lastet inn
      Når jeg velger å laste inn flere
      Så lastes de neste 50 applikasjonene inn i listen

    Scenario: Alle applikasjoner er lastet inn
      Gitt jeg ser listen over applikasjoner
      Og alle applikasjoner er lastet inn
      Så er muligheten til å laste inn flere ikke tilgjengelig

    Scenario: Navigere til detaljside for applikasjon
      Gitt jeg ser listen over applikasjoner
      Når jeg velger en applikasjon
      Så ser jeg detaljsiden for valgt applikasjon

  Regel: Søk og filtrering av applikasjoner (K2)

    Scenario: Fritekst-søk på navn
      Gitt jeg ser listen over applikasjoner
      Når jeg søker med fritekst på navn
      Så filtreres listen til applikasjoner som matcher søket

    Scenario: Filtrere på organisasjon
      Gitt jeg ser listen over applikasjoner
      Når jeg velger en organisasjon som filter
      Så vises kun applikasjoner tilknyttet valgt organisasjon

    @could
    Scenario: Filtrere på rolle
      Gitt jeg ser listen over applikasjoner
      Når jeg velger en rolle som filter
      Så vises kun applikasjoner som har den valgte rollen

    Scenario: Kombinere filtre
      Gitt jeg ser listen over applikasjoner
      Når jeg kombinerer fritekst-søk med ett eller flere filter
      Så vises kun applikasjoner som matcher alle kriteriene

  Regel: Synlighet styres av administrasjonsrettigheter (K11, K12)

    Scenario: Applikasjonsadministrator ser applikasjoner fra egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for én eller flere organisasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg applikasjoner tilknyttet de organisasjonene jeg administrerer

    Scenario: Applikasjonsadministrator ser også applikasjoner med roller i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for én eller flere organisasjoner
      Og en applikasjon tilhører en annen organisasjon, men har roller som gir tilgang til data i en av mine organisasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg denne applikasjonen i listen
      Og det fremgår hvilken organisasjon applikasjonen tilhører

    Scenario: Super-applikasjonsadministrator ser alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg åpner applikasjonsoversikten
      Så ser jeg alle applikasjoner uavhengig av organisasjon
      Og jeg ser også applikasjoner som ikke er tilknyttet noen organisasjon
```

---

### BRU-APP-API-002 — Se detaljer for applikasjon

**Fil:** [se_detaljer.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature)
**GitHub:** [#439](https://github.com/sikt-no/fs/issues/439)

```gherkin
# language: no
# GitHub: #439
@BRU-APP-API-002 @must @planned
Egenskap: Se detaljer for applikasjon
  Som bruker
  ønsker jeg å se detaljer for en applikasjon, organisert i logiske datagrupper,
  slik at jeg har oversikt over applikasjonen.

  # Krav fra Confluence: K3 Se detaljer for API-bruker

  Bakgrunn:
    Gitt jeg ser detaljer for en applikasjon

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se grunnleggende informasjon
      Så ser jeg navn og beskrivelse

    Scenario: Se sporingsinfo
      Så ser jeg opprettet av, opprettet tidspunkt, endret av og endret tidspunkt

    Scenario: Se miljøer
      Så ser jeg hvilke miljøer applikasjonen er aktiv i

    Scenario: Se ansvarlig
      Så ser jeg hvem som er ansvarlig for applikasjonen
```

---

### BRU-APP-API-003 — Vise roller for applikasjon

**Fil:** [vise_roller.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_roller.feature)
**GitHub:** [#440](https://github.com/sikt-no/fs/issues/440)

```gherkin
# language: no
# GitHub: #440
@BRU-APP-API-003 @must @planned
Egenskap: Vise roller for applikasjon
  Som bruker
  ønsker jeg å se hvilke roller en applikasjon har
  slik at jeg forstår hvilke rettigheter og miljøtilgang applikasjonen er tildelt.

  # Krav fra Confluence: K4 Se roller for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg har åpnet tab-en for roller

  Scenario: Se roller for en applikasjon
    Så ser jeg en liste over alle roller tilknyttet applikasjonen
    Og hvert innslag viser rollekode og miljøet rollen gjelder for

  Scenario: Filtrere rolleliste på miljø
    Når jeg filtrerer rollelisten på miljø
    Så vises kun roller i de valgte miljøene
    Og filtervalget er begrenset til miljøer applikasjonen har roller i

  Scenario: Filtrere rolleliste på rolle
    Når jeg filtrerer rollelisten på rolle
    Så vises kun de valgte rollene
    Og filtervalget er begrenset til roller applikasjonen er tildelt

  Scenario: Sortere rolleliste
    Når jeg sorterer rollelisten på miljø eller rollekode
    Så vises rollene i valgt sorteringsrekkefølge

  Scenario: Laste flere roller
    Gitt applikasjonen har flere enn 50 roller
    Og de 50 første rollene er lastet inn
    Når jeg velger å laste inn flere
    Så lastes de neste rollene inn i listen
```

---

### BRU-APP-API-004 — Passordbytte for applikasjon

**Fil:** [passordbytte.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/passordbytte.feature)
**GitHub:** [#441](https://github.com/sikt-no/fs/issues/441)

```gherkin
# language: no
# GitHub: #441
@BRU-APP-API-004 @must @planned
Egenskap: Passordbytte for applikasjon
  Som bruker
  ønsker jeg å sette nytt passord på en applikasjon jeg har rettighet til å administrere
  slik at jeg kan hjelpe med passordbytte.

  applikasjonen autentiserer seg med basic auth og har alltid kun ett
  aktivt passord om gangen. Passordet genereres av systemet.

  # Krav fra Confluence: K5 Sette nytt passord på API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Bruker kan kun endre passord på applikasjoner de har rettighet til å administrere

    Scenario: Passordbytte ikke tilgjengelig uten rettighet
      Gitt jeg ikke har rettighet til å endre passord på denne applikasjonen
      Så er muligheten til å sette nytt passord ikke tilgjengelig

  Regel: Nytt passord genereres av systemet

    Scenario: Generere nytt passord
      Gitt jeg har rettighet til å endre passord på denne applikasjonen
      Når jeg velger å generere et nytt passord
      Så genererer systemet et nytt passord for applikasjonen
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
      Gitt applikasjonen har et aktivt passord
      Når et nytt passord genereres
      Så fungerer ikke det gamle passordet lenger
      Og applikasjonen må autentisere seg med det nye passordet
```

---

### BRU-APP-API-005 — Administrere ansvarlig for applikasjon

**Fil:** [administrere_ansvarlig.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/administrere_ansvarlig.feature)
**GitHub:** [#442](https://github.com/sikt-no/fs/issues/442)

```gherkin
# language: no
# GitHub: #442
@BRU-APP-API-005 @must @planned
Egenskap: Administrere ansvarlig for applikasjon
  Som bruker
  ønsker jeg å sette og endre ansvarlig for en applikasjon
  slik at det alltid er klart hvem som er ansvarlig for applikasjonen.

  En ansvarlig er alltid en feide-bruker eller feide-gruppe, og er den
  som eventuelt har kontakt med tredjeparten som benytter applikasjonen.
  Ansvarlig arver muligheten til å endre passord på applikasjonen.

  # Krav fra Confluence: K18 Administrere ansvarlig for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Ansvarlig kan settes, endres og fjernes

    Scenario: Sette ansvarlig
      Gitt applikasjonen har ingen ansvarlig
      Når jeg søker opp og velger en feide-bruker fra applikasjonens organisasjon
      Så er den valgte feide-brukeren registrert som ansvarlig for applikasjonen

    Scenario: Endre ansvarlig
      Gitt applikasjonen har en ansvarlig
      Når jeg søker opp og velger en annen feide-bruker fra applikasjonens organisasjon
      Så er den nye feide-brukeren registrert som ansvarlig for applikasjonen

    Scenario: Fjerne ansvarlig
      Gitt applikasjonen har en ansvarlig
      Når jeg fjerner den ansvarlige
      Så har applikasjonen ikke lenger en ansvarlig registrert

  Regel: Søk etter ansvarlig er avgrenset til applikasjonens organisasjon

    Scenario: Kun treff fra applikasjonens egen organisasjon vises
      Gitt jeg velger å sette ansvarlig
      Når jeg søker etter en ansvarlig
      Så vises kun treff fra applikasjonens organisasjon

  Regel: En feide-gruppe kan settes som ansvarlig som alternativ til feide-bruker

    @could
    Scenario: Sette en feide-gruppe som ansvarlig
      Gitt applikasjonen har ingen ansvarlig
      Når jeg søker opp og velger en feide-gruppe fra applikasjonens organisasjon
      Så er den valgte feide-gruppen registrert som ansvarlig for applikasjonen

    @could
    Scenario: Søkeresultat inkluderer feide-grupper
      Gitt jeg velger å sette ansvarlig
      Når jeg søker etter en ansvarlig
      Så vises feide-grupper fra applikasjonens organisasjon i tillegg til feide-brukere

  Regel: Administrasjon av ansvarlig krever rettighet over applikasjonens organisasjon

    Scenario: Applikasjonsadministrator kan administrere ansvarlig for applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Så har jeg mulighet til å sette, endre og fjerne ansvarlig

    Scenario: Administrasjon av ansvarlig er ikke tilgjengelig for applikasjoner fra andre organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen, men ikke for organisasjonen applikasjonen tilhører
      Så er muligheten til å sette, endre og fjerne ansvarlig ikke tilgjengelig

    Scenario: Super-applikasjonsadministrator kan administrere ansvarlig for alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Så har jeg mulighet til å sette, endre og fjerne ansvarlig uavhengig av organisasjon
```

---

### BRU-APP-API-006 — Redigere beskrivelse for applikasjon

**Fil:** [rediger_beskrivelse.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/rediger_beskrivelse.feature)
**GitHub:** [#443](https://github.com/sikt-no/fs/issues/443)

```gherkin
# language: no
# GitHub: #443
@BRU-APP-API-006 @must @planned
Egenskap: Redigere beskrivelse for applikasjon
  Som bruker
  ønsker jeg å redigere beskrivelsen for en applikasjon
  slik at informasjonen er oppdatert og korrekt.

  # Krav fra Confluence: K19 Redigere beskrivelse for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: Redigering av beskrivelse krever rettighet over applikasjonens organisasjon

    Scenario: Oppdatere beskrivelse
      Gitt jeg har rettighet til å administrere applikasjonen
      Når jeg oppdaterer beskrivelsen
      Så er den nye beskrivelsen lagret på applikasjonen

    Scenario: Applikasjonsadministrator kan redigere beskrivelse for applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Så har jeg mulighet til å redigere beskrivelsen

    Scenario: Redigering av beskrivelse er ikke tilgjengelig for applikasjoner fra andre organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen, men ikke for organisasjonen applikasjonen tilhører
      Så er muligheten til å redigere beskrivelsen ikke tilgjengelig

    Scenario: Super-applikasjonsadministrator kan redigere beskrivelse for alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Så har jeg mulighet til å redigere beskrivelsen uavhengig av organisasjon
```

---

## Iterasjon 3 — Grunnleggende tilgangsstyring for intern support

GitHub: [#435](https://github.com/sikt-no/fs/issues/435)

### BRU-APP-API-007 — Tilordne rolle til applikasjon

**Fil:** [tilordne_rolle.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/tilordne_rolle.feature)
**GitHub:** [#444](https://github.com/sikt-no/fs/issues/444), [#450](https://github.com/sikt-no/fs/issues/450)

```gherkin
# language: no
# GitHub: #444, #450
@BRU-APP-API-007 @must @planned
Egenskap: Tilordne rolle til applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tilordne en rolle til en applikasjon for et gitt miljø og en gitt organisasjon
  slik at applikasjonen får tilgang til de dataene den trenger i riktig miljø.

  # Krav fra Confluence: K6 Tilordne rolle til API-bruker, K13 Tilordne rolle til API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: En tilordning gjelder én rolle i ett eksplisitt valgt miljø

    Scenario: Tilordne en rolle i et valgt miljø
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele
      Så har applikasjonen fått den valgte rollen i det valgte miljøet
      Og det fremgår tydelig hvilket miljø og hvilken organisasjon tilordningen gjelder

    Scenario: Tilordne flere roller samtidig i ett valgt miljø
      Når jeg velger et miljø og flere roller jeg har rettighet til å tildele
      Så har applikasjonen fått alle de valgte rollene i det valgte miljøet

  Regel: Bruker kan kun tildele roller de selv har rettighet til å tildele

    Scenario: Valglisten viser kun roller jeg har rettighet til å tildele
      Når jeg åpner valglisten for å tilordne en rolle
      Så ser jeg kun roller jeg har rettighet til å tildele

  Regel: En rolle som allerede er tildelt i valgt miljø kan ikke tilordnes på nytt

    Scenario: Allerede tildelt rolle vises som ikke-valgbar
      Gitt applikasjonen har en rolle tildelt i et miljø
      Når jeg åpner valglisten for å tilordne roller i samme miljø
      Så vises den allerede tildelte rollen gråtonet og ikke valgbar
      Og det fremgår at rollen allerede er tildelt

  Regel: Rolletildeling gjelder en organisasjon administratoren har rettighet for (K13)

    Scenario: Organisasjon er implisitt når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt applikasjonen i det valgte miljøet for min organisasjon

    Scenario: Organisasjon velges når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg velger et miljø, en organisasjon og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt applikasjonen i det valgte miljøet for den valgte organisasjonen

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har applikasjonsadministrator-rollen for

  @openquestion
  Scenario: AVKLAR avgrensning av hvilke miljøer rollen kan tilordnes i
    # ÅPNE SPØRSMÅL:
    # - Arkitekturføring: kan en applikasjon autentisere seg til flere miljøer
    #   samtidig, eller er en applikasjon knyttet til kun ett miljø (og kan
    #   dermed bare ha roller i det ene miljøet)? Svaret her styrer de øvrige
    #   spørsmålene under.
    # - Hvis applikasjon kan ha roller i flere miljøer: begrenses miljøvalget
    #   til miljøer applikasjonen allerede er aktiv i, eller kan applikasjonsadministratoren
    #   tildele roller i nye miljøer (evt. begrenset til miljøer administratoren
    #   selv har rettighet i)?
    # - Hvis flere miljøer er mulig: skal en tilordning i et nytt miljø
    #   automatisk gjøre applikasjonen aktiv i det miljøet?
    Gitt spørsmålet er åpent
```

---

### BRU-APP-API-008 — Fjerne rolle fra applikasjon

**Fil:** [fjerne_rolle.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/fjerne_rolle.feature)
**GitHub:** [#445](https://github.com/sikt-no/fs/issues/445), [#451](https://github.com/sikt-no/fs/issues/451)

```gherkin
# language: no
# GitHub: #445, #451
@BRU-APP-API-008 @must @planned
Egenskap: Fjerne rolle fra applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å fjerne en rolle fra en applikasjon
  slik at applikasjonen mister tilgang til data den ikke lenger skal ha.

  # Krav fra Confluence: K7 Fjerne rolle fra API-bruker, K14 Fjerne rolle fra API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg ser listen over roller applikasjonen har

  Regel: En fjerning krever en eksplisitt bekreftelse

    Scenario: Bekreftelsesdialog vises før enkeltrolle fjernes
      Gitt applikasjonen har en rolle jeg har rettighet til å fjerne
      Når jeg velger å fjerne rollen
      Så vises en bekreftelsesdialog som viser rolle og miljø som skal fjernes

    Scenario: Bekrefte fjerning av en enkeltrolle
      Gitt jeg har igangsatt fjerning av én rolle
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger den rollen i det miljøet

    Scenario: Avbryte fjerning
      Gitt jeg har igangsatt fjerning av én eller flere roller
      Når jeg avbryter
      Så er ingen endringer gjort på applikasjonens roller

  Regel: Flere roller i ett miljø kan fjernes samtidig

    Scenario: Bekreftelsesdialog for bulk-fjerning lister alle valgte roller
      Gitt applikasjonen har flere roller jeg har rettighet til å fjerne i et miljø
      Når jeg velger flere av disse rollene innenfor det samme miljøet og velger å fjerne dem
      Så vises en bekreftelsesdialog som lister alle valgte roller og miljøet

    Scenario: Bekrefte bulk-fjerning
      Gitt jeg har igangsatt bulk-fjerning av roller i ett miljø
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger noen av de valgte rollene i det valgte miljøet

  Regel: Bruker kan kun fjerne roller de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for roller uten rettighet
      Gitt applikasjonen har en rolle jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den rollen ikke tilgjengelig
```

---

### BRU-APP-API-009 — Opprette applikasjon

**Fil:** [opprette_applikasjon.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/opprette_applikasjon.feature)
**GitHub:** [#446](https://github.com/sikt-no/fs/issues/446)

```gherkin
# language: no
# GitHub: #446
@BRU-APP-API-009 @must @planned
Egenskap: Opprette applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å opprette en ny applikasjon
  slik at nye integrasjoner kan konfigureres.

  # Krav fra Confluence: K8 Opprette ny API-bruker

  Regel: Opprettelse krever navn og organisasjon for en vanlig applikasjonsadministrator

    Scenario: Opprette applikasjon når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg oppretter en ny applikasjon med et navn
      Så er applikasjonen opprettet med det valgte navnet og min organisasjon

    Scenario: Opprette applikasjon når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg oppretter en ny applikasjon med et navn og velger en av mine organisasjoner
      Så er applikasjonen opprettet med det valgte navnet og den valgte organisasjonen

  Regel: Super-applikasjonsadministrator kan opprette applikasjon uten organisasjon

    Scenario: Opprette applikasjon uten organisasjon
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg oppretter en ny applikasjon med et navn og uten å velge en organisasjon
      Så er applikasjonen opprettet uten organisasjon
      Og applikasjonen kan kun administreres av andre super-applikasjonsadministratorer

  Regel: Nyopprettet applikasjon kan ikke brukes før passord er satt og rolle er tildelt

    Scenario: Nyopprettet applikasjon har ikke passord
      Gitt jeg har opprettet en ny applikasjon
      Så har applikasjonen ikke satt passord
      Og applikasjonen kan ikke benyttes til autentisering før passord settes via passordbytte

    Scenario: Nyopprettet applikasjon er ikke aktiv i noen miljøer
      Gitt jeg har opprettet en ny applikasjon
      Så er applikasjonen ikke aktiv i noen miljøer
      Og applikasjonen blir først aktiv i et miljø når den får tildelt sin første rolle i det miljøet

  @openquestion
  Scenario: AVKLAR status på nyopprettet applikasjon uten passord og roller
    # ÅPNE SPØRSMÅL:
    # - Skal en nyopprettet applikasjon vises som "ikke aktiv" (eller tilsvarende
    #   status) i lista og på detaljsiden inntil den har fått passord og/eller
    #   sin første rolle, eller må den aktiveres eksplisitt?
    # - Hvordan forholder dette seg til "Deaktivere applikasjon" (K9)?
    #   Er "nyopprettet uten passord/roller" og "deaktivert" samme tilstand,
    #   eller to distinkte tilstander?
    Gitt spørsmålet er åpent
```

---

### BRU-APP-API-010 — Deaktivere applikasjon

**Fil:** [deaktivere_applikasjon.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/deaktivere_applikasjon.feature)
**GitHub:** [#447](https://github.com/sikt-no/fs/issues/447)

```gherkin
# language: no
# GitHub: #447
@BRU-APP-API-010 @must @planned
Egenskap: Deaktivere applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å deaktivere en applikasjon
  slik at en applikasjon som ikke lenger er i bruk ikke kan benyttes.

  # Krav fra Confluence: K9 Deaktivere API-bruker

  Regel: Deaktivering krever bekreftelse og hindrer autentisering

    Scenario: Bekreftelsesdialog vises før deaktivering
      Gitt jeg er på detaljsiden for en aktiv applikasjon jeg kan administrere
      Når jeg velger å deaktivere applikasjonen
      Så vises en bekreftelsesdialog før deaktiveringen gjennomføres

    Scenario: Bekrefte deaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å deaktivere en applikasjon
      Når jeg bekrefter deaktiveringen
      Så er applikasjonen ikke lenger aktiv
      Og applikasjonen kan ikke benyttes til autentisering

    Scenario: Avbryte deaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å deaktivere en applikasjon
      Når jeg avbryter
      Så er applikasjonen fortsatt aktiv

  Regel: Deaktivering er reversibel og bevarer rollene

    Scenario: Deaktivert applikasjon beholder sine roller
      Gitt en applikasjon nettopp har blitt deaktivert
      Så er rollene som var tildelt fortsatt knyttet til applikasjonen
      Men rollene gir ikke tilgang så lenge applikasjonen er deaktivert

  Regel: Reaktivering krever bekreftelse og gjenoppretter applikasjonens tilganger

    Scenario: Bekreftelsesdialog vises før reaktivering
      Gitt jeg er på detaljsiden for en deaktivert applikasjon jeg kan administrere
      Når jeg velger å reaktivere applikasjonen
      Så vises en bekreftelsesdialog før reaktiveringen gjennomføres

    Scenario: Bekrefte reaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å reaktivere en applikasjon
      Når jeg bekrefter reaktiveringen
      Så er applikasjonen aktiv igjen
      Og rollene som var tildelt før deaktivering gir igjen tilgang

  Regel: Rettighet til å deaktivere og reaktivere følger administrasjonsrettighetene
   
    Scenario: Applikasjonsadministrator kan deaktivere applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for en organisasjon
      Og applikasjonen tilhører den organisasjonen
      Så har jeg mulighet til å deaktivere og reaktivere applikasjonen

    Scenario: Super-applikasjonsadministrator kan deaktivere alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Så har jeg mulighet til å deaktivere og reaktivere enhver applikasjon uavhengig av organisasjon
```
