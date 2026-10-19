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

  Applikasjonseier er organisasjonen applikasjonen tilhører. Begrepet
  brukes i stedet for organisasjon i applikasjonskravene, fordi en
  organisasjon opptrer i to roller på de samme flatene: den som eier
  applikasjonen, og den hvis data en tilgang gjelder. Den siste omtales
  som «gjelder for».

  Opprettelse av FS-applikasjoner (maskinbruker-applikasjoner) skal
  begrenses til applikasjonsadministratorer for organisasjonene med
  organisasjonskode 20754 (Sikt), 7777 og 7778 (Sikts testhøyskoler), så lenge FS'
  webtjenester lever. Begrensningen gjelder både det som vises i
  løsningen, og kall direkte mot API-et. Lærestedene skal ikke kunne
  opprette dem selv.
  Opprettelsen provisjonerer en maskinbruker i FS' webtjenester, med
  replikering av passordet, og det er en flate Sikt drifter. Bare
  opprettelsen begrenses: den løpende forvaltningen av en FS-applikasjon
  som finnes (navn og beskrivelse, deaktivering og reaktivering,
  passordbytte) følger BRU-APP-API-006, BRU-APP-API-010 og
  BRU-APP-API-004, med rettigheten hos applikasjonseieren. Endringen er
  besluttet 24. august 2026, og står som utkast i reglene under til den
  er validert.

  # Krav fra Confluence: K8 Opprette ny API-bruker, Discovery: Registrer applikasjon (4612784227), Rammeinnsikt: Grunnleggende selvbetjent administrasjon av API-brukere (4401102853)

  Regel: Opprettelse krever valg av identitetsleverandør

    @deprecated @scope-applikasjoner-etter-design-review
    Scenario: Velge identitetsleverandør ved opprettelse, inkludert FS
      Når jeg starter opprettelse av en ny applikasjon
      Så kan jeg velge én av identitetsleverandørene Feide, Maskinporten og FS (Maskinbruker)
      Og identitetsleverandøren settes på applikasjonen og kan ikke endres senere

    @planned
    Scenario: Velge identitetsleverandør ved opprettelse
      Gitt jeg har ikke applikasjonsadministrator-rollen for Sikt (20754), 7777 eller 7778
      Når jeg starter opprettelse av en ny applikasjon i løsningen
      Så kan jeg velge én av identitetsleverandørene Feide og Maskinporten
      Og identitetsleverandøren settes på applikasjonen og kan ikke endres senere

  @draft @openquestion
  Regel: Bare applikasjonsadministratorer for Sikt, 7777 og 7778 kan opprette en applikasjon med FS som identitetsleverandør
    # ÅPNE SPØRSMÅL:
    # - Backenden avviser med «Du har ikke rettighet til å opprette
    #   maskinbruker-applikasjoner.» Er det teksten kravet skal ha?
    # - Backenden krever i tillegg skrivetilgang for applikasjonseieren i både demo og
    #   produksjon. Skal det stå i kravet?
    # Backenden sjekker i dag bare Sikt (20754), ikke testhøyskolene 7777 og 7778.

    Scenario: Applikasjonsadministrator for Sikt, 7777 eller 7778 kan velge FS i løsningen
      Gitt jeg har applikasjonsadministrator-rollen for Sikt (20754), 7777 eller 7778
      Når jeg starter opprettelse av en ny applikasjon i løsningen
      Så kan jeg velge FS som identitetsleverandør

    Scenario: FS er ikke en valgbar identitetsleverandør for en lokal administrator
      Gitt jeg har ikke applikasjonsadministrator-rollen for Sikt (20754), 7777 eller 7778
      Når jeg starter opprettelse av en ny applikasjon i løsningen
      Så er FS ikke tilgjengelig som identitetsleverandør

    Scenario: API-et oppretter en FS-applikasjon for en applikasjonsadministrator for Sikt, 7777 eller 7778
      Gitt jeg har applikasjonsadministrator-rollen for Sikt (20754), 7777 eller 7778
      Når jeg via API-et oppretter en applikasjon med FS som identitetsleverandør
      Så er applikasjonen opprettet

    Scenario: API-et avviser opprettelse av en FS-applikasjon uten rettigheten
      Gitt jeg har ikke applikasjonsadministrator-rollen for Sikt (20754), 7777 eller 7778
      Når jeg via API-et forsøker å opprette en applikasjon med FS som identitetsleverandør
      Så avvises opprettelsen
      Og det fremgår at opprettelse av maskinbruker-applikasjoner krever applikasjonsadministrator-rollen for Sikt, 7777 eller 7778

    Scenario: Opprettelsen provisjonerer en maskinbruker
      Gitt jeg har applikasjonsadministrator-rollen for Sikt (20754), 7777 eller 7778
      Når jeg oppretter en applikasjon med FS som identitetsleverandør og velger en applikasjonseier
      Så er applikasjonen opprettet på den valgte applikasjonseieren
      Og det er provisjonert en tilhørende maskinbruker i FS' webtjenester

  @draft @openquestion
  Regel: Opprettelsen av en FS-applikasjon er alt-eller-ingenting
    # ÅPNE SPØRSMÅL:
    # - Databasen sier hvilke miljøer som mangler FS-datakilde, men det er ikke sjekket om
    #   meldingen når fram til brukeren, og reserveteksten i fs-admin nevner ikke miljøet.
    #   Skal miljøet alltid stå i meldingen?
    # Maskinbrukeren provisjoneres i FS' webtjenester per miljø. Mangler applikasjonseieren
    # FS-datakilde i ett av miljøene, finnes det ingen delvis provisjonert tilstand.

    Scenario: Opprettelsen avvises i sin helhet når applikasjonseieren mangler FS-datakilde i et miljø
      Gitt jeg har applikasjonsadministrator-rollen for Sikt (20754), 7777 eller 7778
      Og applikasjonseieren mangler registrert FS-datakilde i minst ett miljø
      Når jeg forsøker å opprette en applikasjon med FS som identitetsleverandør for applikasjonseieren
      Så avvises opprettelsen i sin helhet
      Og det fremgår hvilket miljø applikasjonseieren mangler FS-datakilde i
      Og applikasjonen er ikke opprettet i noe miljø

  @draft @openquestion
  Regel: Bare opprettelsen av en FS-applikasjon er begrenset til Sikt, 7777 og 7778
    # ÅPNE SPØRSMÅL:
    # - Hører reglen hjemme her, eller i BRU-APP-API-006, BRU-APP-API-010 og BRU-APP-API-004?
    # Begrensningen gjelder handlingen «ta i bruk en utfaset integrasjonsform», ikke
    # applikasjonen. Når den finnes, er den applikasjonseierens applikasjon på linje med
    # de øvrige.

    Scenario: Løpende forvaltning følger applikasjonseieren
      Gitt det finnes en FS-applikasjon på en applikasjonseier
      Og jeg har rettighet til å administrere applikasjoner hos applikasjonseieren
      Så kan jeg endre navn og beskrivelse, deaktivere og reaktivere applikasjonen og bytte passord
      Og ingen av handlingene krever applikasjonsadministrator-rollen for Sikt, 7777 eller 7778

    Scenario: Manglende rolle for Sikt, 7777 eller 7778 skjuler ikke den løpende forvaltningen i løsningen
      Gitt det finnes en FS-applikasjon på en organisasjon jeg administrerer
      Og jeg har ikke applikasjonsadministrator-rollen for Sikt (20754), 7777 eller 7778
      Når jeg åpner detaljsiden for applikasjonen
      Så ser jeg de samme administrasjonshandlingene som for en Feide- eller Maskinporten-applikasjon
      Men jeg ser ingen handling for å opprette en ny applikasjon med FS som identitetsleverandør

  Regel: Opprettelse krever en applikasjonseier

    Scenario: Opprette applikasjon når administrator har tilgang til kun én organisasjon
      Gitt jeg har tilgang til kun én organisasjon
      Når jeg oppretter en ny applikasjon
      Så er organisasjonen jeg har tilgang til satt som applikasjonseier

    Scenario: Opprette applikasjon når administrator har tilgang til flere organisasjoner
      Gitt jeg har tilgang til flere organisasjoner
      Når jeg oppretter en ny applikasjon og velger en av organisasjonene jeg har tilgang til
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

    @deprecated @scope-applikasjoner-etter-design-review
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

    @scope-applikasjoner-etter-design-review
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

  @in-progress @scope-applikasjoner-etter-design-review
  Regel: Konsument sin virksomhetsidentifikator oppgis ikke ved opprettelse

    Scenario: Konsument sin virksomhetsidentifikator er ikke en del av opprettelsen
      Når jeg oppretter en ny applikasjon
      Så er konsument sin virksomhetsidentifikator ikke en del av opprettelsen

    Scenario: Maskinporten-applikasjon får ukjent virksomhetsidentifikator
      Når jeg oppretter en ny applikasjon med Maskinporten som identitetsleverandør
      Så er konsument sin virksomhetsidentifikator registrert som "ukjent" på applikasjonen

  @in-progress @scope-applikasjoner-etter-design-review
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

  @scope-applikasjoner-etter-design-review
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

    @deprecated @scope-applikasjoner-etter-design-review
    Scenariomal: Opprettelse avvises når visningsnavn allerede er i bruk
      Gitt en applikasjon med et gitt visningsnavn allerede finnes
      Når jeg forsøker å opprette en ny applikasjon med identitetsleverandør <identitetsleverandør> og en ID hvis navn hos <identitetsleverandør> er det samme visningsnavnet
      Så avvises opprettelsen
      Og det fremgår at visningsnavnet allerede er i bruk

      Eksempler:
        | identitetsleverandør |
        | Feide                |
        | Maskinporten         |

    @scope-applikasjoner-etter-design-review
    Scenario: Opprettelse avvises når visningsnavnet er i bruk hos samme identitetsleverandør
      Gitt en applikasjon med identitetsleverandør Feide og et gitt visningsnavn allerede finnes
      Når jeg forsøker å opprette en ny applikasjon med identitetsleverandør Feide og samme visningsnavn
      Så avvises opprettelsen
      Og det fremgår at visningsnavnet allerede er i bruk

    @in-progress @scope-applikasjoner-etter-design-review
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

    @in-progress @scope-applikasjoner-etter-design-review
    Scenario: Nyopprettet Feide- eller Maskinporten-applikasjon kan autentisere umiddelbart
      Gitt jeg har opprettet en ny applikasjon med Feide eller Maskinporten som identitetsleverandør
      Så kan applikasjonen autentisere seg umiddelbart med sin eksterne identitet
      Men applikasjonen får ikke tilgang til data før den har en tilgang i et miljø

    @in-progress @scope-applikasjoner-etter-design-review
    Scenario: Nyopprettet FS-applikasjon kan først autentisere når passord er satt
      Gitt jeg har opprettet en ny applikasjon med FS som identitetsleverandør
      Så kan applikasjonen først autentisere seg i et miljø når det er satt passord for det miljøet
      Men applikasjonen får ikke tilgang til data før den har en tilgang i miljøet
