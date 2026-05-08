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
- [BRU-APP-API-003 — Vise tilganger for applikasjon](#bru-app-api-003--vise-tilganger-for-applikasjon)
- [BRU-APP-API-004 — Passordbytte for applikasjon](#bru-app-api-004--passordbytte-for-applikasjon)
- [BRU-APP-API-005 — Administrere ansvarlig for applikasjon](#bru-app-api-005--administrere-ansvarlig-for-applikasjon)
- [BRU-APP-API-006 — Redigere beskrivelse for applikasjon](#bru-app-api-006--redigere-beskrivelse-for-applikasjon)

**Iterasjon 3 — Grunnleggende tilgangsstyring for intern support ([#435](https://github.com/sikt-no/fs/issues/435))**

- [BRU-APP-API-007 — Tildele tilgang til applikasjon](#bru-app-api-007--tildele-tilgang-til-applikasjon)
- [BRU-APP-API-008 — Fjerne tilgang fra applikasjon](#bru-app-api-008--fjerne-tilgang-fra-applikasjon)
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
        | felt          |
        | Navn          |
        | Beskrivelse   |
        | Miljøer       |
        | Ansvarlig     |
        | Organisasjon  |

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
    Scenario: Filtrere på tilgang
      Gitt jeg ser listen over applikasjoner
      Når jeg velger en tilgang som filter
      Så vises kun applikasjoner som har den valgte tilgangen

    Scenario: Kombinere filtre
      Gitt jeg ser listen over applikasjoner
      Når jeg kombinerer fritekst-søk med ett eller flere filter
      Så vises kun applikasjoner som matcher alle kriteriene

  Regel: Synlighet via administrasjonsrettigheter (K11, K12)

    Scenario: Applikasjonsadministrator ser applikasjoner fra egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for én eller flere organisasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg applikasjoner tilknyttet de organisasjonene jeg administrerer

    Scenario: Applikasjonsadministrator ser også applikasjoner med tilganger i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for én eller flere organisasjoner
      Og en applikasjon tilhører en annen organisasjon, men har tilganger som gir tilgang til data i en av mine organisasjoner
      Når jeg åpner applikasjonsoversikten
      Så ser jeg denne applikasjonen i listen
      Og det fremgår hvilken organisasjon applikasjonen tilhører

    Scenario: Super-applikasjonsadministrator ser alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg åpner applikasjonsoversikten
      Så ser jeg alle applikasjoner uavhengig av organisasjon
      Og jeg ser også applikasjoner som ikke er tilknyttet noen organisasjon

  Regel: Synlighet via ansvarlig-relasjon

    Scenario: Bruker som er registrert som ansvarlig ser applikasjonen
      Gitt jeg er registrert som ansvarlig for en applikasjon
      Og jeg har ikke applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Når jeg åpner applikasjonsoversikten
      Så ser jeg applikasjonen i listen
      Og det fremgår hvilken organisasjon applikasjonen tilhører

    @could
    Scenario: Bruker som er ansvarlig via feide-gruppe ser applikasjonen
      Gitt jeg er medlem av en feide-gruppe som er registrert som ansvarlig for en applikasjon
      Og jeg har ikke applikasjonsadministrator-rollen for organisasjonen applikasjonen tilhører
      Når jeg åpner applikasjonsoversikten
      Så ser jeg applikasjonen i listen
      Og det fremgår hvilken organisasjon applikasjonen tilhører
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

### BRU-APP-API-003 — Vise tilganger for applikasjon

**Fil:** [vise_tilganger.feature](01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature)
**GitHub:** [#440](https://github.com/sikt-no/fs/issues/440)

```gherkin
# language: no
# GitHub: #440
@BRU-APP-API-003 @must @planned
Egenskap: Vise tilganger for applikasjon
  Som bruker
  ønsker jeg å se hvilke tilganger en applikasjon har
  slik at jeg forstår hvilke rettigheter og miljøtilgang applikasjonen er tildelt.

  # Krav fra Confluence: K4 Se roller for API-bruker

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg har åpnet tab-en for tilganger

  Scenario: Se tilganger for en applikasjon
    Så ser jeg en liste over alle tilganger applikasjonen har
    Og hvert innslag viser tilgangskode og miljøet tilgangen gjelder for

  Scenario: Filtrere tilgangsliste på miljø
    Når jeg filtrerer tilgangslisten på miljø
    Så vises kun tilganger i de valgte miljøene
    Og filtervalget er begrenset til miljøer applikasjonen har tilganger i

  Scenario: Filtrere tilgangsliste på tilgang
    Når jeg filtrerer tilgangslisten på tilgang
    Så vises kun de valgte tilgangene
    Og filtervalget er begrenset til tilganger applikasjonen er tildelt

  Scenario: Sortere tilgangsliste
    Når jeg sorterer tilgangslisten på miljø eller tilgangskode
    Så vises tilgangene i valgt sorteringsrekkefølge

  Scenario: Laste flere tilganger
    Gitt applikasjonen har flere enn 50 tilganger
    Og de 50 første tilgangene er lastet inn
    Når jeg velger å laste inn flere
    Så lastes de neste tilgangene inn i listen
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

### BRU-APP-API-007 — Tildele tilgang til applikasjon

**Fil:** [tildele_tilgang.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/tildele_tilgang.feature)
**GitHub:** [#444](https://github.com/sikt-no/fs/issues/444), [#450](https://github.com/sikt-no/fs/issues/450)

```gherkin
# language: no
# GitHub: #444, #450
@BRU-APP-API-007 @must @planned
Egenskap: Tildele tilgang til applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å tildele en tilgang til en applikasjon for et gitt miljø og en gitt organisasjon
  slik at applikasjonen får tilgang til de dataene den trenger i riktig miljø.

  # Krav fra Confluence: K6 Tilordne rolle til API-bruker, K13 Tilordne rolle til API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon

  Regel: En tildeling gjelder én tilgang i ett eksplisitt valgt miljø

    Scenario: Tildele en tilgang i et valgt miljø
      Når jeg velger et miljø og en tilgang jeg har rettighet til å tildele
      Så har applikasjonen fått den valgte tilgangen i det valgte miljøet
      Og det fremgår tydelig hvilket miljø og hvilken organisasjon tildelingen gjelder

    Scenario: Tildele flere tilganger samtidig i ett valgt miljø
      Når jeg velger et miljø og flere tilganger jeg har rettighet til å tildele
      Så har applikasjonen fått alle de valgte tilgangene i det valgte miljøet

  Regel: Bruker kan kun tildele tilganger de selv har rettighet til å tildele

    Scenario: Valglisten viser kun tilganger jeg har rettighet til å tildele
      Når jeg åpner valglisten for å tildele en tilgang
      Så ser jeg kun tilganger jeg har rettighet til å tildele

  Regel: En tilgang som allerede er tildelt i valgt miljø kan ikke tildeles på nytt

    Scenario: Allerede tildelt tilgang vises som ikke-valgbar
      Gitt applikasjonen har en tilgang tildelt i et miljø
      Når jeg åpner valglisten for å tildele tilganger i samme miljø
      Så vises den allerede tildelte tilgangen gråtonet og ikke valgbar
      Og det fremgår at tilgangen allerede er tildelt

  Regel: Tilgangstildeling gjelder en organisasjon administratoren har rettighet for (K13)

    Scenario: Organisasjon er implisitt når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg velger et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen i det valgte miljøet for min organisasjon

    Scenario: Organisasjon velges når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg velger et miljø, en organisasjon og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt applikasjonen i det valgte miljøet for den valgte organisasjonen

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har applikasjonsadministrator-rollen for

  Regel: En applikasjon kan ha tilganger i flere miljøer

    Scenario: Tildeling i nytt miljø gjør applikasjonen aktiv i miljøet
      Gitt applikasjonen ikke har tilganger i et gitt miljø
      Når jeg tildeler en tilgang i det miljøet
      Så er applikasjonen aktiv i miljøet
      Og applikasjonen autentiserer seg i det miljøet med sin valgte autentiseringstype
```

---

### BRU-APP-API-008 — Fjerne tilgang fra applikasjon

**Fil:** [fjerne_tilgang.feature](02%20Iterasjon%203%20-%20Grunnleggende%20tilgangsstyring%20for%20intern%20support/fjerne_tilgang.feature)
**GitHub:** [#445](https://github.com/sikt-no/fs/issues/445), [#451](https://github.com/sikt-no/fs/issues/451)

```gherkin
# language: no
# GitHub: #445, #451
@BRU-APP-API-008 @must @planned
Egenskap: Fjerne tilgang fra applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å fjerne en tilgang fra en applikasjon
  slik at applikasjonen mister tilgang til data den ikke lenger skal ha.

  # Krav fra Confluence: K7 Fjerne rolle fra API-bruker, K14 Fjerne rolle fra API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg ser tilgangslisten applikasjonen har

  Regel: En fjerning krever en eksplisitt bekreftelse

    Scenario: Bekreftelsesdialog vises før enkelt-tilgang fjernes
      Gitt applikasjonen har en tilgang jeg har rettighet til å fjerne
      Når jeg velger å fjerne tilgangen
      Så vises en bekreftelsesdialog som viser tilgang og miljø som skal fjernes

    Scenario: Bekrefte fjerning av en enkelt-tilgang
      Gitt jeg har igangsatt fjerning av én tilgang
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger den tilgangen i det miljøet

    Scenario: Avbryte fjerning
      Gitt jeg har igangsatt fjerning av én eller flere tilganger
      Når jeg avbryter
      Så er ingen endringer gjort på applikasjonens tilganger

  Regel: Flere tilganger i ett miljø kan fjernes samtidig

    Scenario: Bekreftelsesdialog for bulk-fjerning lister alle valgte tilganger
      Gitt applikasjonen har flere tilganger jeg har rettighet til å fjerne i et miljø
      Når jeg velger flere av disse tilgangene innenfor det samme miljøet og velger å fjerne dem
      Så vises en bekreftelsesdialog som lister alle valgte tilganger og miljøet

    Scenario: Bekrefte bulk-fjerning
      Gitt jeg har igangsatt bulk-fjerning av tilganger i ett miljø
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger noen av de valgte tilgangene i det valgte miljøet

  Regel: Bruker kan kun fjerne tilganger de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for tilganger uten rettighet
      Gitt applikasjonen har en tilgang jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den tilgangen ikke tilgjengelig
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

  En applikasjon har én autentiseringstype som velges ved opprettelse —
  FS, Feide eller Maskinporten. Typen kan ikke endres senere, men
  applikasjonen kan tildeles tilganger i flere miljøer.

  # Krav fra Confluence: K8 Opprette ny API-bruker, Discovery: Registrer applikasjon (4612784227)

  Regel: Opprettelse krever valg av autentiseringstype

    Scenario: Velge autentiseringstype ved opprettelse
      Når jeg starter opprettelse av en ny applikasjon
      Så kan jeg velge én av autentiseringstypene FS, Feide og Maskinporten
      Og typen settes på applikasjonen og kan ikke endres senere

  Regel: Opprettelse krever en organisasjon

    Scenario: Opprette applikasjon når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg oppretter en ny applikasjon
      Så er applikasjonen opprettet på min organisasjon

    Scenario: Opprette applikasjon når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg oppretter en ny applikasjon og velger en av mine organisasjoner
      Så er applikasjonen opprettet på den valgte organisasjonen

    Scenario: Super-applikasjonsadministrator velger blant alle organisasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg åpner valglisten for organisasjon ved opprettelse
      Så omfatter valglisten alle organisasjoner i systemet
      Og applikasjonen opprettes på den organisasjonen jeg velger

  Regel: FS-applikasjon identifiseres av et globalt unikt visningsnavn

    Scenario: Opprette FS-applikasjon med visningsnavn
      Når jeg oppretter en ny applikasjon av typen FS med et visningsnavn
      Så er applikasjonen opprettet med det valgte visningsnavnet
      Og systemet har generert et brukernavn for applikasjonen

    Scenario: Visningsnavn må være unikt på tvers av alle organisasjoner
      Gitt en FS-applikasjon med et gitt visningsnavn allerede finnes
      Når jeg forsøker å opprette en ny FS-applikasjon med samme visningsnavn
      Så avvises opprettelsen
      Og det fremgår at visningsnavnet allerede er i bruk

  Regel: Feide- og Maskinporten-applikasjon identifiseres av en ID som verifiseres mot kilden

    Scenariomal: Opprette applikasjon med ekstern identitet
      Når jeg oppretter en ny applikasjon av typen <type> med en ID
      Og ID-en finnes i <type>
      Så er applikasjonen opprettet
      Og navnet på applikasjonen er hentet fra <type>
      Og applikasjonen identifiseres ved ID-en

      Eksempler:
        | type         |
        | Feide        |
        | Maskinporten |

    Scenariomal: Opprettelse avvises når ID ikke finnes hos kilden
      Når jeg forsøker å opprette en applikasjon av typen <type> med en ID som ikke finnes i <type>
      Så avvises opprettelsen
      Og det fremgår at ID-en ikke kunne verifiseres

      Eksempler:
        | type         |
        | Feide        |
        | Maskinporten |

    Scenariomal: Opprettelse avvises når ID allerede er registrert
      Gitt en applikasjon av typen <type> med en gitt ID allerede er registrert
      Når jeg forsøker å opprette en ny applikasjon av samme type med samme ID
      Så avvises opprettelsen
      Og det fremgår at ID-en allerede er i bruk

      Eksempler:
        | type         |
        | Feide        |
        | Maskinporten |

  Regel: Nyopprettet applikasjon har ingen tilganger og er ikke aktiv i noen miljøer

    Scenario: Nyopprettet applikasjon er ikke aktiv i noen miljøer
      Gitt jeg har opprettet en ny applikasjon
      Så er applikasjonen ikke aktiv i noen miljøer
      Og applikasjonen blir først aktiv i et miljø når den får tildelt sin første tilgang i det miljøet

    Scenario: Nyopprettet FS-applikasjon mangler passord
      Gitt jeg har opprettet en ny applikasjon av typen FS
      Så har applikasjonen ikke satt passord
      Og applikasjonen kan ikke benyttes til autentisering før passord settes via passordbytte

    Scenario: Nyopprettet Feide- eller Maskinporten-applikasjon kan autentisere umiddelbart
      Gitt jeg har opprettet en ny applikasjon av typen Feide eller Maskinporten
      Så kan applikasjonen autentisere seg umiddelbart med sin eksterne identitet
      Men applikasjonen får ikke tilgang til data før den har en tilgang i et miljø
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

  Regel: Deaktivering er reversibel og bevarer tilgangene

    Scenario: Deaktivert applikasjon beholder sine tilganger
      Gitt en applikasjon nettopp har blitt deaktivert
      Så er tilgangene som var tildelt fortsatt knyttet til applikasjonen
      Men tilgangene gir ikke faktisk tilgang så lenge applikasjonen er deaktivert

  Regel: Reaktivering krever bekreftelse og gjenoppretter applikasjonens tilganger

    Scenario: Bekreftelsesdialog vises før reaktivering
      Gitt jeg er på detaljsiden for en deaktivert applikasjon jeg kan administrere
      Når jeg velger å reaktivere applikasjonen
      Så vises en bekreftelsesdialog før reaktiveringen gjennomføres

    Scenario: Bekrefte reaktivering
      Gitt jeg har åpnet bekreftelsesdialogen for å reaktivere en applikasjon
      Når jeg bekrefter reaktiveringen
      Så er applikasjonen aktiv igjen
      Og tilgangene som var tildelt før deaktivering gjelder igjen

  Regel: Rettighet til å deaktivere og reaktivere følger administrasjonsrettighetene

    Scenario: Applikasjonsadministrator kan deaktivere applikasjoner i egne organisasjoner
      Gitt jeg har applikasjonsadministrator-rollen for en organisasjon
      Og applikasjonen tilhører den organisasjonen
      Så har jeg mulighet til å deaktivere og reaktivere applikasjonen

    Scenario: Super-applikasjonsadministrator kan deaktivere alle applikasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Så har jeg mulighet til å deaktivere og reaktivere enhver applikasjon uavhengig av organisasjon
```

---

