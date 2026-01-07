# language: no
@skip @støtteprosesser @sikkerhet
Egenskap:  Tilgangsstyring - Oversikt over API-tilganger
  Som systemadministrator ved organisasjon som bruker FS til studieadministrasjon, trenger jeg å vite hvilke API-tilganger som hvilke maskinbrukere
  har tilgang til enhver tid, slik at jeg vet hvilke apier og data de ulike maskinbrukerne har tilgang til for å ivareta personvern og sikkerhet.

  Bakgrunn:
    Gitt at bruker er systemadministrator for organisasjon
    Gitt at systemadministrator er på oversiktsside for tilgangsstyring av APIer
    Gitt at systemadministrator klikker på "Vis tilganger"

  Scenariomal: Systemadministrator ser API-tilganger og hvilke maskinbrukere som har API-tilganger
    Når at "<systemadministrator>" er på siden for å vise tilganger
    Så ser "<systemadministrator>" en oversikt over "<API-roller>" med "<beskrivelse av rollen>"
    Så ser "<systemadministrator>" hvilke "<maskinbrukere>" som har "<API-roller>"

    Eksempler:
    |systemadministrator|API-roller|beskrivelse av rollen|maskinbrukere|

  Scenariomal: Sikts systemadministratorer filtrerer oversikt over maskinbrukere på eierorganisasjon
    Gitt at "<systemadministrator>" klikker på "Vis tilganger"
    Når "<systemadministrator>" søker etter "<API-rolle>"
    Så får systemadministrator "<output>"

    Eksempler:
      |systemadministrator|API-rolle|output|

  Scenariomal: systemadministrator filtrerer oversikt over API-tilganger på API
    Gitt at "<systemadministrator>" er på "Vis tilganger"
    Når "<systemadministrator>" velger hvilke "<API>"
    Så oppdateres maskinbrukeroversikten til å vise "<API-tilganger>" som er gyldige for "<API>"

    Eksempler:
      |systemadministrator|API|API-tilganger|

  Scenariomal: Sikts systemadministratorer filtrerer oversikt over API-tilganger på eierorganisasjon
    Gitt at "<systemadministrator>" jobber for Sikt
    Gitt at "<systemadministrator>" er på "Vis tilganger"
    Når "<systemadministrator>" velger eierorgansiasjon "<eierorgansiasjon>"
    Så oppdateres maskinbrukeroversikten til å vise "<API-tilganger>" som er gyldige for "<eierorganisasjon>"

    Eksempler:
      |systemadministrator|eierorganisasjon|API-tilganger|



