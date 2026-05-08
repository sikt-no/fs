# language: no
# GitHub: #446
@BRU-APP-API-009 @must @planned
Egenskap: Opprette applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å opprette en ny applikasjon
  slik at tilganger kan tildeles.

  En applikasjon har én identitetsleverandør som velges ved opprettelse —
  FS, Feide eller Maskinporten. Identitetsleverandøren kan ikke endres
  senere, men applikasjonen kan tildeles tilganger i flere miljøer.

  # Krav fra Confluence: K8 Opprette ny API-bruker, Discovery: Registrer applikasjon (4612784227)

  Regel: Opprettelse krever valg av identitetsleverandør

    Scenario: Velge identitetsleverandør ved opprettelse
      Når jeg starter opprettelse av en ny applikasjon
      Så kan jeg velge én av identitetsleverandørene FS, Feide og Maskinporten
      Og identitetsleverandøren settes på applikasjonen og kan ikke endres senere

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
      Når jeg oppretter en ny applikasjon med identitetsleverandør FS og et visningsnavn
      Så er applikasjonen opprettet med det valgte visningsnavnet
      Og systemet har generert et brukernavn for applikasjonen

    Scenario: Visningsnavn må være unikt på tvers av alle organisasjoner
      Gitt en FS-applikasjon med et gitt visningsnavn allerede finnes
      Når jeg forsøker å opprette en ny FS-applikasjon med samme visningsnavn
      Så avvises opprettelsen
      Og det fremgår at visningsnavnet allerede er i bruk

  Regel: Feide- og Maskinporten-applikasjon identifiseres av en ID som verifiseres mot kilden

    Scenariomal: Opprette applikasjon med ekstern identitet
      Når jeg oppretter en ny applikasjon med identitetsleverandør <identitetsleverandør> og en ID
      Og ID-en finnes hos <identitetsleverandør>
      Så er applikasjonen opprettet
      Og navnet på applikasjonen er hentet fra <identitetsleverandør>
      Og applikasjonen identifiseres ved ID-en

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

  Regel: Nyopprettet applikasjon har ingen tilganger og er ikke aktiv i noen miljøer

    Scenario: Nyopprettet applikasjon er ikke aktiv i noen miljøer
      Gitt jeg har opprettet en ny applikasjon
      Så er applikasjonen ikke aktiv i noen miljøer
      Og applikasjonen blir først aktiv i et miljø når den får tildelt sin første tilgang i det miljøet

    Scenario: Nyopprettet FS-applikasjon mangler passord
      Gitt jeg har opprettet en ny applikasjon med identitetsleverandør FS
      Så har applikasjonen ikke satt passord
      Og applikasjonen kan ikke benyttes til autentisering før passord settes via passordbytte

    Scenario: Nyopprettet Feide- eller Maskinporten-applikasjon kan autentisere umiddelbart
      Gitt jeg har opprettet en ny applikasjon med identitetsleverandør Feide eller Maskinporten
      Så kan applikasjonen autentisere seg umiddelbart med sin eksterne identitet
      Men applikasjonen får ikke tilgang til data før den har en tilgang i et miljø
