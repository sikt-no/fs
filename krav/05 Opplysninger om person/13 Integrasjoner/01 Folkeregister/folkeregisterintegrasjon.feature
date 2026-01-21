# language: no
@OPP-INT-FOL-001 @skip @personopplysning
Egenskap: Integrasjon mot folkeregisteret for å oppdatere personopplysninger for læresteder
Som person som bruker Min kompetanse (søker, student eller resultateier) som er registert i folkeregisteret skal jeg slippe å oppdatere
  mine personopplysninger flere steder, slik at læresteder har korrekt person- og kontaktinformasjon om meg, tiltaler meg ved riktig navn og
  kontakter meg på riktig adresse og kan behandle meg korrekt mht mine personopplysninger når det er aktuelt.

  Hjemmelsgrunnlag aktive studenter: GDPR art. 6 nr. 1 bokstav e) fordi behandlingen er nødvendig for å kunne utføre en oppgave i allmennhetens interesse eller
  utøve offentlig myndighet som behandlingsansvarlig er pålagt. I tillegg kan læresteder innhente og behandle personopplysninger i hht universitets- og høyskoleloven § 4-15.

  Bakgrunn:
    Gitt at lærestedet har søkt og fått tilgang til Folkeregisteret
    Gitt at lærestedet har delegert tilgang til Folkeregisteret videre til FS/Sikt
    Gitt at person har minst én søknad, studierett eller resultat ved lærested

  Scenariomal: Lærested "uten hjemmel" kan spørre med fødselsnummer
    Gitt at lærested har tilgangspakke privat eller offentlig "uten hjemmel" hos Folkeregisteret
    Når "<fødselsnummer>" for "<endringshendelse>" matcher person ved lærested
    Så utføres oppdatering av "<personopplysning>"

    Eksempler:
      |fødselsnummer|endringshendelse|personopplysning|

    @versjon2
  Scenariomal: Lærested med tilgangspakke "privat" må spørre med fødselsnummer og navn
    Gitt at lærested har tilgangspakke "privat"
    Når "<fødselsnummer>" og "<navn"> for "<endringshendelse>" matcher person ved lærested
    Så utføres oppdatering av "<personopplysning>"

    Eksempler:
      |fødselsnummer|endringshendelse|personopplysning|

  Scenariomal: Oppdatere navn
    Når "<person>" endrer fra "<gammelt navn>" til "<nytt navn>" i folkeregisteret
    Så oppdateres personens navn FS
    Så lagres navneendringen i historikk

    Eksempler:
      | person |gammelt navn |nytt navn|

  Scenariomal: Trunkere som pr. dags dato er for lange for FS (over 200 tegn)
    Gitt at "<nytt navn>" i folkeregisteret er på over 200 tegn
    Når "<person>" endrer fra "<gammelt navn>" til "<nytt navn>" i folkeregisteret
    Så trunkeres "<nytt navn>" før oppdateringen
    # midlertidig løsning inntil vi kan utvide antall tillatte tegn i databasen

    Eksempler:
     |person |nytt navn| gammelt navn |

@versjon1
  Scenariomal: Systemadministrator få varsel om oppdatering av fødselsnummer
    Når "<person>" blir oppdatert fra "<gammelt fødselsnummer>" til "<nytt fødselsnummer>" i folkeregisteret
    Så mottar "<systemadministrator>" varsel om avvikssak til behandling

    Eksempler:
      | person | gammelt fødselsnummer |nytt fødselsnummer|systemadministrator|

 @versjon2
 Scenariomal: Systemadministrator få varsel om oppdatering av Dnr
    Når "<person>" blir oppdatert fra "<snr>" til "<Dnr>" i folkeregisteret
    Så mottar "<systemadministrator>" varsel om avvikssak til behandling

    Eksempler:
      | person | gammelt fødselsnummer |nytt fødselsnummer|systemadministrator|      

@versjon1
  Scenariomal: Oppdatering av fødselsnummer 
    Når "<systemadministrator>" har behandlet avvikssak om fødselsnummerendring
    Så oppdaterer vi til "<nytt fødselsnummer>" i FS
    Så lagres fødselsnummerendring i historikk

    Eksempler:
      |nytt fødselsnummer|systemadministrator|

   Scenariomal: Automatisk oppdatering av fødselsnummer (senere versjon i FS Admin)
    Når "<person>" blir oppdatert fra "<gammelt fødselsnummer>" til "<nytt fødselsnummer>" i folkeregisteret
    Så oppdaterers fødselsnummer i FS
    Så lagres fødselsnummerendring i historikk
    Så mottar "<systemadministrator>" varsel om endret fødelsnummer

    Eksempler:
      | person | gammelt fødselsnummer |nytt fødselsnummer|systemadministrator|    

@versjon1
  Scenariomal: Registrere dødsfall
    Når en "<persons>" dødsfall blir registrert i folkeregisteret
    Så registrerer vi at "<person>" er død i FS
    Så mottar "<systemadministrator>" varsel om avvikssak til behandling

    Eksempler:
      |persons| person |

@versjon1 
  Scenariomal: Systemadministrator får varsel om dødsfall
    Gitt at en "<persons>" dødsfall blir registrert i folkeregisteret
    Når "<dødsfall>" registreres i FS
    Så mottar "<systemadministrator>" varsel om avvikssak til behandling

    Eksempler:
      |persons|dødsfall|systemadministrator|

      @versjon2
  Scenariomal: Velge statsborgerskap
    Gitt at en person blir opprettet med D-nr eller Fnr første gang
    Når en "<person>" har "<flere statsborgerskap>"
    Så oppdaterer oppdaterer vi til "<prioritert statsborgerskap>"

    Eksempler:
      |person         | flere statsborgerskap       |prioritert statsborgerskap|
      |navn navnesen 1|norsk, nordisk               |norsk                     |
      |navn navnesen 2|nordisk, EU/Sveits/UK        |nordisk                   |
      |navn navnesen 3|EU/Sveits/UK,resten av verden|EU/Sveits/UK              |
      |navn navnesen 4|resten av verden, ukjent     |resten av verden          |
      |navn navnesen 4|ukjent                       |ukjent                    |
      
    Scenario: Logging av endringer i personopplysninger fra folkeregisteret
      #usikker på om denne skal her eller hører hjemme et annet sted (vesensforskjell fra endringer som bevares i historikk)
      Gitt at en person har endret personopplysninger i folkeregisteret som er relevante for FS
      Når endringer registreres i FS
      Så logger vi endringene i 3 månder
      #hva slags logg, tilgjengelig for hvem?

        Scenariomal: Synliggjøre logg med oppdatering fra folkeregisteret (senere versjon i FS Admin)
    Gitt at "<person>" endrer "<personopplysning>" i folkeregisteret
    Når "<personopplysning>" oppdateres i FS
    Når administrator slår opp "<person>" i FS Admin
    Så ser administrator hvor vi har oppdatert opplysningene fra og når vi gjorde oppdateringen (sist oppdatert fra freg dato)
    #Så ser person hvor vi har oppdatert opplysningene fra og når vi gjorde oppdateringen (sist oppdatert fra freg dato)

    Eksempler:
      |person|personopplysning|

#adressebehovet må gjenbesøkes - i hvilke kontekster det er fortsatt aktuelt?
  Scenariomal: Oppdatere folkeregistert bostedsadresse
    Gitt at "<person>" har søkt utdanning eller er aktiv student
    Når "<person>" endrer "<folkeregistrert bostedsadresse>" i folkeregisteret
    Så oppdateres "<folkeregistrert adresse>" i FS

    Eksempler:
      | person | folkeregistrert adresse |
@skip
  Scenariomal: Oppdatere folkeregistert postadresse - kontaktadresse???
    Gitt at "<person>" har søkt utdanning eller er aktiv student
    Når "<person>" endrer "<folkeregistrert postadresse>" i folkeregisteret
    Så oppdateres "<kontaktadresse>" i FS

    Eksempler:
      | person | kontaktadresse |

    #ikke aktuell før vi ikke kan utlede kjønn fra fødselsnummer mer, det blir aktuelt fra 2030
  Scenariomal: Oppdatere kjønn
    Når "<person>" endrer "<kjønn>" i folkeregisteret
    Så oppdateres "<kjønn>" i FS

    Eksempler:
      | person | kjønn |
