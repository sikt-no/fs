# language: no
# GitHub: #376
@OPT-BEH-BEH-007 @must @draft
Egenskap: Automatisk kvoteplassering
  Som saksbehandler
  ønsker jeg at søkere plasseres i kvoter ut fra grunnlag, alder og svar på kvotespørsmål
  slik at jeg bare tar stilling til kvotespørsmålene som ikke kan besvares automatisk.

  Regel: Søkeren plasseres automatisk i en kvote uten kvotespørsmål

    Scenario: Plassering i kvote uten kvotespørsmål
      Gitt at kvotetypen "ORD" ikke har kvotespørsmål
      Og at grunnlaget "VES" er koblet til kvotetypen "ORD"
      Og at søkeren er kvalifisert på grunnlaget "VES"
      Når saksbehandleren behandler søknaden på grunnlaget "VES"
      Så plasseres søkeren i kvotetypen "ORD"
      Og oppsummeringen av saken viser kvotetypen "ORD" med søkerens poengsum

    Scenario: Søkeren er ikke kvalifisert på grunnlaget
      Gitt at kvotetypen "ORD" ikke har kvotespørsmål
      Og at grunnlaget "VES" er koblet til kvotetypen "ORD"
      Og at søkeren ikke er kvalifisert på grunnlaget "VES"
      Når saksbehandleren behandler søknaden på grunnlaget "VES"
      Så plasseres ikke søkeren i kvotetypen "ORD"

    Scenario: Kvote uten kvotespørsmål vises ikke blant kvotespørsmålene
      Gitt at kvotetypen "ORD" ikke har kvotespørsmål
      Når saksbehandleren åpner kvotene i søknadsbehandlingen
      Så vises ikke kvotetypen "ORD" blant kvotespørsmålene saksbehandleren skal ta stilling til

    Scenario: Grunnlag som ikke er koblet til kvotetypen
      Gitt at grunnlaget "PRA" ikke er koblet til kvotetypen "ORDF"
      Når saksbehandleren behandler søknaden på grunnlaget "PRA"
      Så plasseres ikke søkeren i kvotetypen "ORDF"

  Regel: Aldersgrensen på grunnlaget avgjør om søkeren kan plasseres i kvotene grunnlaget er koblet til

    Scenariomal: Aldersgrense på grunnlaget
      Gitt at grunnlaget "<grunnlag>" har aldersgrensen <operator> <grense> år
      Og at grunnlaget "<grunnlag>" er koblet til kvotetypen "<kvotetype>"
      Og at søkeren er <alder> år på datoen for aldersberegning
      Når saksbehandleren behandler søknaden på grunnlaget "<grunnlag>"
      Så er søkeren <plassering> i kvotetypen "<kvotetype>"

      Eksempler:
        | grunnlag | operator   | grense | alder | kvotetype | plassering    |
        | VOV      | mindre enn | 22     | 21    | ORDF      | plassert      |
        | VOV      | mindre enn | 22     | 22    | ORDF      | ikke plassert |
        | PRA      | større enn | 22     | 23    | ORD       | plassert      |
        | PRA      | større enn | 22     | 22    | ORD       | ikke plassert |
        | VES      | lik        | 22     | 22    | JENTER-22 | plassert      |

    Scenario: Kvotespørsmål stilles ikke når aldersgrensen ikke er møtt
      Gitt at grunnlaget "VOV" har aldersgrensen mindre enn 22 år
      Og at grunnlaget "VOV" er koblet til kvotetypen "JENTER-HARDANGER"
      Og at kvotetypen "JENTER-HARDANGER" har kvotespørsmålet "FRA-HARDANGER"
      Og at søkeren er 23 år på datoen for aldersberegning
      Når saksbehandleren behandler søknaden på grunnlaget "VOV"
      Så ser ikke saksbehandleren kvotespørsmålet "FRA-HARDANGER"
      Og søkeren er ikke plassert i kvotetypen "JENTER-HARDANGER"

  Regel: Alderen beregnes fra opptakets dato for aldersberegning

    Scenario: Alder beregnes fra datoen opptaket har satt
      Gitt at opptaket har dato for aldersberegning "2027-04-15"
      Og at søkeren er født "2005-06-01"
      Når søknaden behandles
      Så er søkerens opptaksalder 21 år

    Scenario: Standarddato for aldersberegning
      Gitt at opptaket ikke har dato for aldersberegning
      Og at opptaket har dato for publisering av resultat "2027-07-15"
      Og at søkeren er født "2005-09-01"
      Når søknaden behandles
      Så er søkerens opptaksalder 22 år

    @openquestion
    Scenario: Opptak med aldersregler mangler dato for aldersberegning
      # ÅPNE SPØRSMÅL:
      # - Hva skal saksbehandleren og opptaksforvalteren se når datoen mangler? Varselet i fs-admin (STEK-533) er ikke levert.
      # - Datoen som ble brukt, vises ikke etter at søknaden er behandlet. Skal den vises, og i så fall hvor?
      Gitt at regelverket i opptaket har en aldersgrense eller gir alderspoeng
      Og at opptaket verken har dato for aldersberegning eller dato for publisering av resultat
      Når søknaden behandles
      Så behandles ikke søknaden før opptaket har en av datoene

    Scenario: Opptak uten aldersregler trenger ikke dato for aldersberegning
      Gitt at regelverket i opptaket verken har aldersgrense eller gir alderspoeng
      Og at opptaket verken har dato for aldersberegning eller dato for publisering av resultat
      Når søknaden behandles
      Så behandles søknaden uten dato for aldersberegning

  Regel: Søkeren plasseres i en kvote med kvotespørsmål når alle kvotespørsmålene er besvart ja

    Scenario: Alle kvotespørsmål besvart ja
      Gitt at kvotetypen "JENTER-HARDANGER" har kvotespørsmålene "ER-KVINNE" og "FRA-HARDANGER"
      Og at kvotespørsmålet "ER-KVINNE" er besvart ja automatisk
      Når saksbehandleren besvarer kvotespørsmålet "FRA-HARDANGER" med ja
      Så plasseres søkeren i kvotetypen "JENTER-HARDANGER"

    Scenario: Ett kvotespørsmål besvart nei
      Gitt at kvotetypen "JENTER-HARDANGER" har kvotespørsmålene "ER-KVINNE" og "FRA-HARDANGER"
      Og at kvotespørsmålet "ER-KVINNE" er besvart ja automatisk
      Når saksbehandleren besvarer kvotespørsmålet "FRA-HARDANGER" med nei
      Så plasseres ikke søkeren i kvotetypen "JENTER-HARDANGER"

  Regel: Saksbehandleren tar stilling til kvotespørsmål, ikke til kvotetyper

    Scenario: Kvotespørsmålene vises i søknadsbehandlingen
      Gitt at søkeren behandles på et grunnlag som er koblet til kvotetypen "SAMISK"
      Og at kvotetypen "SAMISK" har kvotespørsmålet "SAMISK-TILH"
      Når saksbehandleren åpner kvotene i søknadsbehandlingen
      Så ser saksbehandleren kvotespørsmålet "Er du av samisk ætt?"
      Men saksbehandleren ser ikke kvotetypen "SAMISK" som et eget valg

    Scenario: Samme kvotespørsmål på flere kvotetyper vises én gang
      Gitt at kvotespørsmålet "FRA-HARDANGER" er knyttet til kvotetypene "JENTER-HARDANGER" og "HARDANGER"
      Når saksbehandleren åpner kvotene i søknadsbehandlingen
      Så vises kvotespørsmålet "FRA-HARDANGER" én gang
      Og svaret på kvotespørsmålet "FRA-HARDANGER" gjelder for begge kvotetypene

  Regel: Kvotespørsmål med algoritme besvares automatisk og kan ikke endres av saksbehandleren

    Scenario: Automatisk besvart kvotespørsmål vises låst
      Gitt at kvotespørsmålet "ER-KVINNE" er koblet til algoritmen "Er kvinne"
      Og at søkeren er registrert som kvinne
      Når saksbehandleren åpner kvotene i søknadsbehandlingen
      Så ser saksbehandleren at kvotespørsmålet "ER-KVINNE" er besvart ja automatisk
      Og saksbehandleren ser merknaden om hvorfor kvotespørsmålet "ER-KVINNE" er besvart slik
      Men saksbehandleren kan ikke endre svaret på kvotespørsmålet "ER-KVINNE"

    Scenario: Svar på automatisk kvotespørsmål avvises i API-et
      Gitt at kvotespørsmålet "ER-KVINNE" er koblet til algoritmen "Er kvinne"
      Når et svar på kvotespørsmålet "ER-KVINNE" sendes inn direkte mot API-et
      Så avvises lagringen av svaret

  Regel: Endringsloggen viser at maskinbrukeren har plassert søkeren i kvoten

    Scenario: Automatisk kvoteplassering i endringsloggen
      Gitt at søknaden er behandlet automatisk
      Og at automatikken har plassert søkeren i kvotetypen "ORD"
      Når saksbehandleren ser på endringsloggen for saken
      Så ser saksbehandleren et innslag utført av maskinbrukeren
      Og saksbehandleren ser hvem som startet den automatiske behandlingen

    Scenario: Kvoteplasseringen viser opptaksalderen
      Gitt at automatikken har plassert søkeren i kvotetypen "ORDF" der grunnlaget har en aldersgrense
      Når saksbehandleren ser på kvoteplasseringen
      Så ser saksbehandleren opptaksalderen som ble brukt mot aldersgrensen
