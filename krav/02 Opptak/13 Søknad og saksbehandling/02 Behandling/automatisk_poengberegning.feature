# language: no
# Utledet fra Jira STEK-218 (med STEK-219, -220, -221, -223, -224, -225) og koden i
# opptak-service (AutomatiskPoengberegningService, PoengService), sjekket mot main 2026-10-27.
# Tilleggspoeng fra poengalgoritmer (alder, kjønn, høyere utdanning) er et eget krav
# (automatiske_tilleggspoeng.feature), og kravelementer står i automatisk_kvalifisering.feature.
# Når poengene beregnes (utløsere og orkestrering) hører til en egen epic.
#
# Flere kilder (fra utkastet i PR #818): Jira FOL-36, STEK-454, STEK-430/431, STEK-507,
# STEK-512/513, STEK-514, STEK-529, SOPP-44. Confluence PFS 4392517645 «2026-02-25 Raffinering
# 100% helautomatisk poengberegning», 4405231624 «Helautomatisk poengberegning – brukerhistorier»,
# 4390191266 «Poengberegning – Automatisert», 4954554392 «Automatisk saksbehandling av flere
# elektroniske vitnemål», 4609146881 «Forretningsregler – Poeng». GitHub #199. I FS-klienten
# beregner «Godkjenn» i vitnemålsrammen og rutinen FS158.001 poengene, og manuell endring av
# poeng setter «la stå».
@OPT-BEH-BEH-018 @must @draft @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-008 @ref-OPT-BEH-BEH-032
Egenskap: Automatisk beregning av vitnemålspoeng
  Som saksbehandler
  ønsker jeg at karakterpoeng, realfagspoeng, språkpoeng og skolepoeng beregnes automatisk fra søkerens vitnemål
  slik at jeg bare trenger å behandle poengene der grunnlaget ikke er entydig.

  Beregningen bruker søkerens eneste vitnemål, og er bare mulig når søkeren har ett elektronisk
  vitnemål. Har søkeren flere vitnemål, velger saksbehandleren vitnemålet i
  vitnemålsbehandlingen, og den samme beregningen brukes da på vitnemålet saksbehandleren har
  valgt. Hvilke karakterer som teller, og hvordan de regnes om til poeng, er ikke beskrevet her.

  Poengene ligger på saken, som grunnlaget (OPT-BEH-BEH-019). Automatikken beregner de samme
  poengene i alle sakene i søknaden, men det saksbehandleren overstyrer eller låser, gjelder bare
  saken hos organisasjonen saksbehandleren er ved. Avklart 30.10.2026.

  # Avklart 29.10.2026: opptaksforvalteren skrur automatikken av og på for opptaket, og kan sette
  # tidspunktet da den stopper (OPT-BEH-BEH-032).

  Bakgrunn:
    Gitt at søkeren har en søknad i opptaket

  @depends-on-OPT-REG-RAN-002 @ref-FLY-OPT-AUT-001
  Regel: Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål
    # Opptaksforvalteren kobler poengtypen til karakterpoeng, realfagspoeng eller språkpoeng i regelverket.

    Scenariomal: Poengtype som beregnes fra vitnemålet
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at opptaksforvalteren har koblet poengtypen "<poengtype>" til <poeng> fra vitnemålet
      Og at saken har poengtypen "<poengtype>"
      Når vitnemålspoengene beregnes automatisk
      Så har poengtypen fått <poeng> beregnet fra vitnemålet

      Eksempler:
        | poengtype | poeng         |
        | KAR-NOM   | karakterpoeng |
        | REA-NOM   | realfagspoeng |
        | SPR-NOM   | språkpoeng    |

    Scenario: Poengtype uten kobling til vitnemålet beregnes ikke
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at saken har en poengtype som ikke er koblet til poeng fra vitnemålet
      Når vitnemålspoengene beregnes automatisk
      Så er poengtypen uendret

    Scenario: Beregnet poeng rundes til antall desimaler poengtypen har
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at poengtypen for karakterpoeng har ett desimal
      Når vitnemålspoengene beregnes automatisk
      Så har karakterpoenget ett desimal

  @ref-FLY-OPT-AUT-001
  Regel: Skolepoeng settes sammen av karakterpoeng, realfagspoeng og språkpoeng
    # Skolepoeng er karakterpoeng pluss realfagspoeng og språkpoeng, der de to siste til sammen teller høyst 4.

    Scenariomal: Skolepoeng beregnet fra vitnemålspoengene
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at vitnemålet gir <karakterpoeng> karakterpoeng, <realfagspoeng> realfagspoeng og <språkpoeng> språkpoeng
      Når vitnemålspoengene beregnes automatisk
      Så er skolepoengene <skolepoeng>

      Eksempler:
        | karakterpoeng | realfagspoeng | språkpoeng | skolepoeng |
        | 45            | 3             | 0          | 48         |
        | 45            | 3             | 2          | 49         |
        | 45            | 4             | 4          | 49         |

  @ref-FLY-OPT-AUT-001
  Regel: Ingen automatisk beregning uten ett entydig vitnemål
    Søkere med flere vitnemål behandles i vitnemålsbehandlingen.

    Scenariomal: Ingen automatiske vitnemålspoeng når <grunn>
      Gitt at <grunn>
      Når vitnemålspoengene beregnes automatisk
      Så får saken ingen vitnemålspoeng beregnet automatisk
      Og det fremgår at søkeren ikke har ett entydig vitnemål

      Eksempler:
        | grunn                                                                                  |
        | søkeren har flere vitnemål som ikke er annullert, og saksbehandleren har ikke valgt ett |
        | søkerens eneste dokument er et kompetansebevis                                         |
        | søkerens eneste vitnemål er annullert                                                  |
        | søkeren ikke har noe vitnemål                                                          |
        | vitnemålet ikke gir generell studiekompetanse                                          |
        | saken ikke har noe grunnlag                                                            |

    Scenario: Kompetansebevis ved siden av ett vitnemål hindrer ikke beregningen
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at søkeren har et kompetansebevis
      Når vitnemålspoengene beregnes automatisk
      Så har poengtypene fått poeng beregnet fra vitnemålet alene

    # Avklart 30.10.2026: får søkeren et vitnemål til, blir de automatisk beregnede
    # vitnemålspoengene stående til saksbehandleren har valgt vitnemål og startet behandlingen på
    # det. Et nytt vitnemål er ny dokumentasjon, og saken behandles ikke automatisk på nytt
    # (OPT-BEH-BEH-032).

    @ref-OPT-BEH-BEH-025
    Scenario: Vitnemålspoeng fra vitnemålet saksbehandleren har valgt
      Gitt at søkeren har to vitnemål som ikke er annullert, ett fra 2024 og ett fra 2025
      Og at saksbehandleren har valgt vitnemålet fra 2025
      Når vitnemålspoengene beregnes automatisk
      Så har poengtypene fått poeng beregnet fra vitnemålet fra 2025

  @ref-OPT-BEH-BEH-004
  Regel: Poeng som saksbehandleren har låst, beregnes ikke på nytt
    # Hvordan et poeng låses av at saksbehandleren velger grunnlag, og hvordan det låses opp, står i kravet.

    Scenario: Poeng som saksbehandleren endrer, blir stående
      Gitt at saken har et vitnemålspoeng som er beregnet automatisk
      Når saksbehandleren endrer poenget
      Så beregnes ikke poenget automatisk på nytt

    Scenariomal: Saksbehandleren overstyrer automatisk beregnet <poeng>
      Gitt at saken har <poeng> som er beregnet automatisk
      Når saksbehandleren endrer <poeng>
      Så gjelder saksbehandlerens verdi
      Og den automatiske beregningen endrer ikke <poeng> senere

      Eksempler:
        | poeng         |
        | karakterpoeng |
        | realfagspoeng |
        | språkpoeng    |

    Scenario: Låst poeng beregnes ikke på nytt
      Gitt at saken har et låst vitnemålspoeng
      Når vitnemålspoengene beregnes automatisk
      Så er det låste poenget uendret

    Scenario: Låse opp et poeng
      Gitt at saken har et låst vitnemålspoeng
      Når saksbehandleren låser opp poenget
      Og vitnemålspoengene beregnes automatisk
      Så er poenget beregnet automatisk på nytt

    Scenario: Poeng som ikke er låst, beregnes på nytt
      Gitt at saken har et vitnemålspoeng som er beregnet automatisk
      Og at poenget ikke er låst
      Når vitnemålspoengene beregnes automatisk
      Så er poenget erstattet med det nye beregnede poenget

    Scenario: Saksbehandlerens merknad på poenget er uendret
      Gitt at saksbehandleren har skrevet en merknad på et vitnemålspoeng
      Når vitnemålspoengene beregnes automatisk
      Så er merknaden uendret

  Regel: Det fremgår hvordan et poeng er beregnet

    Scenario: Se at poenget er beregnet automatisk, og hvilket vitnemål det bygger på
      Gitt at saken har et vitnemålspoeng som er beregnet automatisk
      Når saksbehandleren ser på poengene
      Så ser saksbehandleren at poenget er beregnet automatisk
      Og saksbehandleren ser hvilket vitnemål poenget er beregnet fra

    Scenario: Se hvorfor vitnemålspoengene ikke er beregnet
      Gitt at vitnemålspoengene ikke kunne beregnes automatisk fordi søkeren ikke har ett entydig vitnemål
      Når saksbehandleren ser på poengene
      Så ser saksbehandleren at vitnemålspoengene ikke er beregnet fordi søkeren ikke har ett entydig vitnemål

    @openquestion
    Scenario: Finne søknader som er behandlet automatisk
      # ÅPNE SPØRSMÅL:
      # - Brukerbehov fra raffineringen (PFS 4392517645): å kunne søke opp hvem som er behandlet
      #   automatisk, gjerne med skille mellom helautomatisk og halvautomatisk. FS158.001 har «Vis
      #   tidligere behandlinger». Er det et filter i saksoversikten, en logg, eller begge?
      Gitt at noen søknader i opptaket er behandlet automatisk
      Når saksbehandleren ser etter søknadene som er behandlet automatisk
      Så finner saksbehandleren søknadene som er behandlet automatisk
