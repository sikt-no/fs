# language: no
# GitHub: #446
@BRU-APP-API-009 @must @implemented
Egenskap: Opprette applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å opprette en ny applikasjon
  slik at tilganger kan tildeles.

  En applikasjon har én identitetsleverandør som velges ved opprettelse —
  Feide, Maskinporten eller FS (Maskinbruker). Identitetsleverandøren kan ikke endres
  senere, men applikasjonen kan tildeles tilganger i flere miljøer.
  Applikasjonen identifiseres eksternt ved identifikatoren fra
  identitetsleverandøren og internt ved en systemgenerert unik ID.
  Visningsnavnet oppgis ved opprettelse, og må være globalt unikt på
  tvers av alle organisasjoner.

  Feide og Maskinporten identifiserer applikasjonen med en ekstern ID
  som verifiseres mot identitetsleverandøren ved opprettelse. FS
  identifiserer applikasjonen med et brukernavn som oppgis direkte, og
  en FS-applikasjon har samme identitet i alle miljøer. I løsningen
  vises identitetsleverandøren FS som «FS (Maskinbruker)». I stegene
  står den som FS.

  FS som identitetsleverandør — en maskinbruker-applikasjon — er
  utfaset for nye integrasjoner, og lærestedene kan ikke opprette dem
  selv. Opprettelse er likevel ikke stengt: applikasjonsadministratorer
  hos Sikt kan opprette maskinbruker-applikasjoner så lenge FS'
  webtjenester lever. Opprettelsen provisjonerer en maskinbruker i de
  webtjenestene, med replikering av passordet, og det er en flate Sikt
  drifter — den skal kunne forvaltes fra applikasjonsoversikten framfor
  av databaseforvaltningen.

  Avgrensningen er viktig: det er bare opprettelsen som er gatet hos
  Sikt. Den løpende forvaltningen av en maskinbruker-applikasjon som
  finnes — navn og beskrivelse, deaktivering og reaktivering,
  passordbytte — følger de ordinære reglene i BRU-APP-API-006,
  BRU-APP-API-010 og BRU-APP-API-004, altså rettigheten hos
  applikasjonseier. Eksisterende maskinbruker-applikasjoner forvaltes i
  den samme applikasjonsoversikten som Feide- og
  Maskinporten-applikasjoner, og alle administrasjonshandlinger
  (listevisning, tilgangsstyring, passordbytte, beskrivelse,
  deaktivering) gjelder også for dem.

  Applikasjonseier er organisasjonen applikasjonen tilhører. Begrepet
  brukes i stedet for organisasjon i applikasjonskravene, fordi en
  organisasjon opptrer i to roller på de samme flatene: den som eier
  applikasjonen, og den hvis data en tilgang gjelder. Den siste omtales
  som «gjelder for».

  # Krav fra Confluence: K8 Opprette ny API-bruker, Discovery: Registrer applikasjon (4612784227), Rammeinnsikt: Grunnleggende selvbetjent administrasjon av API-brukere (4401102853)

  Regel: Opprettelse krever valg av identitetsleverandør

    @deprecated
    Scenario: Velge identitetsleverandør ved opprettelse
      Når jeg starter opprettelse av en ny applikasjon
      Så kan jeg velge én av identitetsleverandørene Feide og Maskinporten
      Og identitetsleverandøren settes på applikasjonen og kan ikke endres senere

    @in-progress
    Scenario: Velge identitetsleverandør ved opprettelse, inkludert FS
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Når jeg starter opprettelse av en ny applikasjon
      Så kan jeg velge én av identitetsleverandørene Feide, Maskinporten og FS (Maskinbruker)
      Og identitetsleverandøren settes på applikasjonen og kan ikke endres senere

    @deprecated
    Scenario: FS er ikke en valgbar identitetsleverandør
      Når jeg starter opprettelse av en ny applikasjon
      Så er FS ikke tilgjengelig som identitetsleverandør

  @planned
  Regel: Bare Sikt kan opprette en applikasjon med FS som identitetsleverandør

    # FS er utfaset som identitetsleverandør for nye integrasjoner, men opprettelse er
    # ikke stengt. En maskinbruker-applikasjon provisjonerer en maskinbruker i FS'
    # webtjenester, med replikering av passordet, og det er en flate Sikt drifter. Så
    # lenge de webtjenestene lever skal flaten kunne forvaltes fra
    # applikasjonsoversikten framfor av databaseforvaltningen. Selvbetjent opprettelse
    # hos lærestedene er stengt — det er ikke lærestedets eget valg å ta i bruk en
    # utfaset integrasjonsform. fs-plattform (tilgangsstyring) håndhever gaten i dag.

    Scenario: FS er ikke en valgbar identitetsleverandør for en lokal administrator
      Gitt jeg har applikasjonsadministrator-rollen for en organisasjon som ikke er Sikt
      Når jeg starter opprettelse av en ny applikasjon
      Så kan jeg velge én av identitetsleverandørene Feide og Maskinporten
      Men FS (Maskinbruker) er ikke tilgjengelig som identitetsleverandør

    Scenario: Forsøk på å opprette en maskinbruker-applikasjon uten rettigheten avvises
      Gitt jeg ikke har applikasjonsadministrator-rollen for Sikt
      Når jeg forsøker å opprette en applikasjon med FS som identitetsleverandør
      Så avvises opprettelsen
      Og det fremgår at opprettelse av maskinbruker-applikasjoner krever applikasjonsadministrator hos Sikt

    Scenario: Opprettelsen provisjonerer en maskinbruker
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Når jeg oppretter en applikasjon med FS som identitetsleverandør og en valgt applikasjonseier
      Så er applikasjonen opprettet på den valgte applikasjonseieren
      Og det er provisjonert en tilhørende maskinbruker i FS' webtjenester

  @planned
  Regel: Opprettelsen av en maskinbruker-applikasjon er alt-eller-ingenting

    # Maskinbruker-applikasjonen selv har ingen miljødimensjon — det er provisjoneringen i
    # FS' webtjenester som skjer per miljø. Mangler applikasjonseieren FS-datakilde i ett
    # av miljøene, finnes det ingen delvis provisjonert tilstand: hele opprettelsen avvises.

    Scenario: Opprettelsen avvises i sin helhet når applikasjonseieren mangler FS-datakilde i et miljø
      Gitt jeg har applikasjonsadministrator-rollen for Sikt
      Og applikasjonseieren mangler registrert FS-datakilde i minst ett miljø
      Når jeg forsøker å opprette en applikasjon med FS som identitetsleverandør for applikasjonseieren
      Så avvises opprettelsen i sin helhet
      Og det fremgår hvilket miljø applikasjonseieren mangler FS-datakilde i
      Og applikasjonen er ikke opprettet i noe miljø

  @planned
  Regel: Bare opprettelsen av en maskinbruker-applikasjon er gatet hos Sikt

    # Gatingen gjelder handlingen «ta i bruk en utfaset integrasjonsform», ikke
    # applikasjonen som sådan. Når den først finnes, er den applikasjonseierens
    # applikasjon på linje med de øvrige.

    Scenario: Løpende forvaltning følger applikasjonseier
      Gitt det finnes en maskinbruker-applikasjon
      Og jeg har rettighet til å administrere applikasjoner for applikasjonseieren
      Så kan jeg endre navn og beskrivelse, deaktivere og reaktivere applikasjonen og bytte passord
      Og ingen av de handlingene krever applikasjonsadministrator hos Sikt

    Scenario: Manglende Sikt-rettighet skjuler ikke den løpende forvaltningen
      Gitt det finnes en maskinbruker-applikasjon der jeg administrerer applikasjonseieren
      Og jeg har ikke applikasjonsadministrator-rollen for Sikt
      Når jeg åpner detaljsiden for applikasjonen
      Så ser jeg de samme administrasjonshandlingene som for en Feide- eller Maskinporten-applikasjon
      Men jeg ser ingen handling for å opprette en ny applikasjon med FS som identitetsleverandør

  Regel: Opprettelse krever en applikasjonseier

    Scenario: Opprette applikasjon når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg oppretter en ny applikasjon
      Så er min organisasjon satt som applikasjonseier

    Scenario: Opprette applikasjon når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg oppretter en ny applikasjon og velger en av mine organisasjoner
      Så er den valgte organisasjonen satt som applikasjonseier

    Scenario: Super-applikasjonsadministrator velger blant alle organisasjoner
      Gitt jeg har super-applikasjonsadministrator-rollen
      Når jeg åpner valglisten for applikasjonseier ved opprettelse
      Så omfatter valglisten alle organisasjoner i systemet
      Og den organisasjonen jeg velger settes som applikasjonseier

  Regel: Opprettelse krever et navn

    Scenario: Navn må fylles inn for å opprette applikasjon
      Når jeg forsøker å opprette en ny applikasjon uten å fylle inn navn
      Så avvises opprettelsen
      Og det fremgår at navn er obligatorisk

    Scenario: Navn lagres ved opprettelse
      Når jeg oppretter en ny applikasjon med et navn
      Så er det oppgitte navnet lagret på applikasjonen

  Regel: Feide- og Maskinporten-applikasjoner identifiseres av en ekstern ID som verifiseres mot identitetsleverandøren

    @deprecated
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

    @in-progress
    Scenariomal: Opprette applikasjon med ekstern identitet og oppgitt navn
      Når jeg oppretter en ny applikasjon med identitetsleverandør <identitetsleverandør>, et navn og en ID
      Og ID-en finnes hos <identitetsleverandør>
      Så er applikasjonen opprettet
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

    @openquestion
    Scenario: AVKLAR håndtering når identitetsleverandøren ikke svarer
      # ÅPNE SPØRSMÅL:
      # - Kravene skiller i dag kun mellom at ID-en finnes og at den ikke finnes.
      #   Hva skal skje når identitetsleverandøren er utilgjengelig eller svarer
      #   for sent — skal opprettelsen avvises med en egen melding om teknisk feil,
      #   eller skal oppslaget kunne forsøkes på nytt?
      Gitt spørsmålet er åpent

    Scenario: Ekstern ID trenger ikke tilhøre applikasjonseier
      Gitt jeg oppretter en ny applikasjon med en valgt applikasjonseier
      Når ID-en hos identitetsleverandøren tilhører en annen organisasjon
      Så er applikasjonen likevel opprettet på den valgte applikasjonseieren

  @in-progress
  Regel: Konsument sin virksomhetsidentifikator oppgis ikke ved opprettelse

    Scenario: Konsument sin virksomhetsidentifikator er ikke en del av opprettelsen
      Når jeg oppretter en ny applikasjon
      Så er konsument sin virksomhetsidentifikator ikke en del av opprettelsen

    Scenario: Maskinporten-applikasjon får ukjent virksomhetsidentifikator
      Når jeg oppretter en ny applikasjon med Maskinporten som identitetsleverandør
      Så er konsument sin virksomhetsidentifikator registrert som "ukjent" på applikasjonen

  @in-progress
  Regel: FS-applikasjoner identifiseres av et brukernavn som ikke verifiseres mot en ekstern kilde

    Scenario: Opprette applikasjon med FS-brukernavn
      Når jeg oppretter en ny applikasjon med FS som identitetsleverandør og et brukernavn
      Så er applikasjonen opprettet
      Og applikasjonen identifiseres ved brukernavnet

    Scenario: Opprettelse avvises når FS-brukernavnet allerede er i bruk
      Gitt en applikasjon med FS som identitetsleverandør og et gitt brukernavn allerede finnes
      Når jeg forsøker å opprette en ny applikasjon med FS og samme brukernavn
      Så avvises opprettelsen
      Og det fremgår at brukernavnet allerede er i bruk

    Scenario: FS-brukernavnet skiller mellom store og små bokstaver
      Gitt en applikasjon med FS som identitetsleverandør og brukernavnet "app1" allerede finnes
      Når jeg oppretter en ny applikasjon med FS som identitetsleverandør og brukernavnet "App1"
      Så er applikasjonen opprettet
      Og applikasjonen identifiseres ved brukernavnet "App1"

    Scenario: FS-applikasjonen har samme identitet i alle miljøer
      Når jeg oppretter en ny applikasjon med FS som identitetsleverandør
      Så er miljø ikke en del av opprettelsen
      Og applikasjonen har samme identitet i alle miljøer

  @in-progress
  Regel: Beskrivelse kan angis ved opprettelse

    Scenario: Angi beskrivelse ved opprettelse
      Når jeg oppretter en ny applikasjon med en beskrivelse
      Så er den oppgitte beskrivelsen lagret på applikasjonen

    Scenario: Opprette applikasjon uten beskrivelse
      Når jeg oppretter en ny applikasjon uten å fylle inn beskrivelse
      Så er applikasjonen opprettet
      Og applikasjonen har ingen beskrivelse

  Regel: Systemet tildeler hver applikasjon en intern unik ID

    Scenario: Intern ID genereres ved opprettelse
      Når jeg oppretter en ny applikasjon
      Så har systemet generert en intern unik ID for applikasjonen
      Og den interne ID-en er uavhengig av identitetsleverandør

  Regel: Visningsnavn må være globalt unikt på tvers av alle organisasjoner

    @deprecated
    Scenariomal: Opprettelse avvises når visningsnavn allerede er i bruk
      Gitt en applikasjon med et gitt visningsnavn allerede finnes
      Når jeg forsøker å opprette en ny applikasjon med identitetsleverandør <identitetsleverandør> og en ID hvis navn hos <identitetsleverandør> er det samme visningsnavnet
      Så avvises opprettelsen
      Og det fremgår at visningsnavnet allerede er i bruk

      Eksempler:
        | identitetsleverandør |
        | Feide                |
        | Maskinporten         |

    @in-progress
    Scenario: Opprettelse avvises når visningsnavnet er i bruk hos samme identitetsleverandør
      Gitt en applikasjon med identitetsleverandør Feide og et gitt visningsnavn allerede finnes
      Når jeg forsøker å opprette en ny applikasjon med identitetsleverandør Feide og samme visningsnavn
      Så avvises opprettelsen
      Og det fremgår at visningsnavnet allerede er i bruk

    @in-progress
    Scenario: Opprettelse avvises når visningsnavnet er i bruk hos en annen identitetsleverandør
      Gitt en applikasjon med identitetsleverandør Feide og et gitt visningsnavn allerede finnes
      Når jeg forsøker å opprette en ny applikasjon med identitetsleverandør Maskinporten og samme visningsnavn
      Så avvises opprettelsen
      Og det fremgår at visningsnavnet allerede er i bruk

  Regel: Nyopprettet applikasjon har status Aktiv

    Scenario: Nyopprettet applikasjon har status Aktiv som standard
      Når jeg oppretter en ny applikasjon
      Så har applikasjonen status "Aktiv"

  Regel: Nyopprettet applikasjon har ingen tilganger og er ikke aktiv i noen miljøer

    Scenario: Nyopprettet applikasjon er ikke aktiv i noen miljøer
      Gitt jeg har opprettet en ny applikasjon
      Så er applikasjonen ikke aktiv i noen miljøer
      Og applikasjonen blir først aktiv i et miljø når den får tildelt sin første tilgang i det miljøet

    @deprecated
    Scenario: Nyopprettet applikasjon kan autentisere umiddelbart
      Gitt jeg har opprettet en ny applikasjon
      Så kan applikasjonen autentisere seg umiddelbart med sin eksterne identitet
      Men applikasjonen får ikke tilgang til data før den har en tilgang i et miljø

    @in-progress
    Scenario: Nyopprettet Feide- eller Maskinporten-applikasjon kan autentisere umiddelbart
      Gitt jeg har opprettet en ny applikasjon med Feide eller Maskinporten som identitetsleverandør
      Så kan applikasjonen autentisere seg umiddelbart med sin eksterne identitet
      Men applikasjonen får ikke tilgang til data før den har en tilgang i et miljø

    @in-progress
    Scenario: Nyopprettet FS-applikasjon kan først autentisere når passord er satt
      Gitt jeg har opprettet en ny applikasjon med FS som identitetsleverandør
      Så kan applikasjonen først autentisere seg i et miljø når det er satt passord for det miljøet
      Men applikasjonen får ikke tilgang til data før den har en tilgang i miljøet
