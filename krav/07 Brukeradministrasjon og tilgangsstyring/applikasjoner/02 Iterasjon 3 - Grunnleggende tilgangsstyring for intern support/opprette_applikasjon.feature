# language: no
# GitHub: #446
@BRU-APP-API-009 @must @planned
Egenskap: Opprette applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å opprette en ny applikasjon
  slik at tilganger kan tildeles.

  En applikasjon har én identitetsleverandør som velges ved opprettelse —
  Feide, Maskinporten eller FS. Identitetsleverandøren kan ikke endres
  senere, men applikasjonen kan tildeles tilganger i flere miljøer.
  Applikasjonen identifiseres eksternt ved ID-en fra idP-en og internt
  ved en systemgenerert unik ID. Visningsnavnet, som hentes fra idP-en,
  må være globalt unikt på tvers av alle organisasjoner.

  FS som identitetsleverandør er fortsatt utfaset for nye eksterne
  integrasjoner, men Sikt kundestøtte kan opprette applikasjoner med FS
  som identitetsleverandør — maskinbrukere — fra applikasjonsoversikten.
  For øvrige administratorer er FS ikke valgbart. En slik applikasjon
  opprettes uten valg av miljø: identiteten blir den samme i alle
  miljøer, og passord settes etterpå per miljø. Eksisterende
  FS-applikasjoner består som data og forvaltes i den samme
  applikasjonsoversikten som Feide- og Maskinporten-applikasjoner —
  alle administrasjonshandlinger (listevisning, tilgangsstyring,
  passordbytte, beskrivelse, deaktivering) gjelder også for dem.

  # Krav fra Confluence: K8 Opprette ny API-bruker, Discovery: Registrer applikasjon (4612784227), Rammeinnsikt: Grunnleggende selvbetjent administrasjon av API-brukere (4401102853)

  Regel: Opprettelse krever valg av identitetsleverandør

    Scenario: Velge identitetsleverandør ved opprettelse
      Når jeg starter opprettelse av en ny applikasjon
      Så kan jeg velge én av identitetsleverandørene Feide og Maskinporten
      Og identitetsleverandøren settes på applikasjonen og kan ikke endres senere

    @implemented
    Scenario: FS er valgbar identitetsleverandør for Sikt kundestøtte
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg starter opprettelse av en ny applikasjon
      Så kan jeg i tillegg velge FS som identitetsleverandør

    @implemented
    Scenario: FS er ikke valgbar for øvrige administratorer
      Gitt jeg har applikasjonsadministrator-rollen for egen organisasjon
      Når jeg starter opprettelse av en ny applikasjon
      Så er FS ikke tilgjengelig som identitetsleverandør

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

  Regel: Opprettelse krever et navn

    Scenario: Navn må fylles inn for å opprette applikasjon
      Når jeg forsøker å opprette en ny applikasjon uten å fylle inn navn
      Så avvises opprettelsen
      Og det fremgår at navn er obligatorisk

    Scenario: Navn lagres ved opprettelse
      Når jeg oppretter en ny applikasjon med et navn
      Så er det oppgitte navnet lagret på applikasjonen

  Regel: Applikasjonen identifiseres av en ekstern ID som verifiseres mot identitetsleverandøren

    Scenariomal: Opprette applikasjon med ekstern identitet
      Når jeg oppretter en ny applikasjon med identitetsleverandør <identitetsleverandør> og en ID
      Og ID-en finnes hos <identitetsleverandør>
      Så er applikasjonen opprettet
      Og navnet på applikasjonen er hentet fra <identitetsleverandør>
      Og applikasjonen identifiseres eksternt ved ID-en

      Eksempler:
        | identitetsleverandør |
        | Feide                |
        | Maskinporten         |

    Scenariomal: Opprettelse avvises når ID ikke finnes hos kilden
      Når jeg forsøker å opprette en applikasjon med identitetsleverandør <identitetsleverandør> og en ID som ikke finnes hos <identitetsleverandør>
      Så avvises opprettelsen
      Og det fremgår at ID-en ikke kunne verifiseres

      Eksempler:
        | identitetsleverandør |
        | Feide                |
        | Maskinporten         |

    Scenariomal: Opprettelse avvises når ID allerede er registrert
      Gitt en applikasjon med identitetsleverandør <identitetsleverandør> og en gitt ID allerede er registrert
      Når jeg forsøker å opprette en ny applikasjon med samme identitetsleverandør og samme ID
      Så avvises opprettelsen
      Og det fremgår at ID-en allerede er i bruk

      Eksempler:
        | identitetsleverandør |
        | Feide                |
        | Maskinporten         |

  Regel: Systemet tildeler hver applikasjon en intern unik ID

    Scenario: Intern ID genereres ved opprettelse
      Når jeg oppretter en ny applikasjon
      Så har systemet generert en intern unik ID for applikasjonen
      Og den interne ID-en er uavhengig av identitetsleverandør

  Regel: Visningsnavn må være globalt unikt på tvers av alle organisasjoner

    Scenariomal: Opprettelse avvises når visningsnavn allerede er i bruk
      Gitt en applikasjon med et gitt visningsnavn allerede finnes
      Når jeg forsøker å opprette en ny applikasjon med identitetsleverandør <identitetsleverandør> og en ID hvis navn hos <identitetsleverandør> er det samme visningsnavnet
      Så avvises opprettelsen
      Og det fremgår at visningsnavnet allerede er i bruk

      Eksempler:
        | identitetsleverandør |
        | Feide                |
        | Maskinporten         |

  @implemented
  Regel: Applikasjon med FS som identitetsleverandør opprettes av Sikt kundestøtte og gjelder i alle miljøer

    Scenario: Sikt kundestøtte oppretter applikasjon med FS som identitetsleverandør
      Gitt jeg har super-applikasjonsadministrator-rollen
      Og organisasjonen har en registrert FS-datakilde i alle miljøer
      Når jeg oppretter en ny applikasjon med identitetsleverandør FS, et navn og en organisasjon
      Så er applikasjonen opprettet
      Og applikasjonen har den samme identiteten i alle miljøer
      Og opprettelsen krevde ikke at jeg valgte miljø

    Scenario: Opprettelsen avvises når organisasjonen mangler FS-datakilde i et miljø
      Gitt jeg har super-applikasjonsadministrator-rollen
      Og organisasjonen mangler registrert FS-datakilde i minst ett miljø
      Når jeg forsøker å opprette en ny applikasjon med identitetsleverandør FS for organisasjonen
      Så avvises opprettelsen i sin helhet
      Og det fremgår hvilket miljø organisasjonen mangler FS-datakilde i
      Og applikasjonen er ikke opprettet i noe miljø

    Scenario: Passord settes per miljø etter opprettelsen
      Gitt jeg har opprettet en ny applikasjon med identitetsleverandør FS
      Og applikasjonen har ennå ikke noe passord
      Når applikasjonen skal autentisere seg i et miljø
      Så må det først settes et passord for applikasjonen i det miljøet
      Og passordet settes med den samme passordflyten som for øvrige applikasjoner

  Regel: Nyopprettet applikasjon har status Aktiv

    Scenario: Nyopprettet applikasjon har status Aktiv som standard
      Når jeg oppretter en ny applikasjon
      Så har applikasjonen status "Aktiv"

  Regel: Nyopprettet applikasjon har ingen tilganger og er ikke aktiv i noen miljøer

    Scenario: Nyopprettet applikasjon er ikke aktiv i noen miljøer
      Gitt jeg har opprettet en ny applikasjon
      Så er applikasjonen ikke aktiv i noen miljøer
      Og applikasjonen blir først aktiv i et miljø når den får tildelt sin første tilgang i det miljøet

    Scenario: Nyopprettet applikasjon kan autentisere umiddelbart
      Gitt jeg har opprettet en ny applikasjon
      Så kan applikasjonen autentisere seg umiddelbart med sin eksterne identitet
      Men applikasjonen får ikke tilgang til data før den har en tilgang i et miljø
      Og en applikasjon med FS som identitetsleverandør kan autentisere seg i et miljø så snart passordet for miljøet er satt
