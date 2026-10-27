# language: no
# Utledet fra Jira STEK-218 (med STEK-219, -220, -221, -223, -224, -225) og koden i
# opptak-service (AutomatiskPoengberegningService, PoengService), sjekket mot main 2026-10-27.
# Tilleggspoeng fra poengalgoritmer (alder, kjønn, høyere utdanning) er et eget krav
# (automatiske_tilleggspoeng.feature), og kravelementer står i automatisk_kvalifisering.feature.
# Når poengene beregnes (utløsere og orkestrering) hører til en egen epic.
@OPT-BEH-BEH-018 @must @draft
Egenskap: Automatisk beregning av vitnemålspoeng
  Som saksbehandler
  ønsker jeg at karakterpoeng, realfagspoeng, språkpoeng og skolepoeng beregnes automatisk fra søkerens vitnemål
  slik at jeg bare trenger å behandle poengene der grunnlaget ikke er entydig.

  Beregningen bruker søkerens eneste vitnemål, og er bare mulig når søkeren har ett elektronisk
  vitnemål. Hvilke karakterer som teller, og hvordan de regnes om til poeng, eies av Team Puff og
  er ikke beskrevet her.

  Bakgrunn:
    Gitt at søkeren har en søknad i opptaket

  @depends-on-OPT-REG-RAN-002
  Regel: Karakterpoeng, realfagspoeng og språkpoeng beregnes fra søkerens eneste vitnemål
    # Opptaksforvalteren kobler poengtypen til karakterpoeng, realfagspoeng eller språkpoeng i regelverket.

    Scenariomal: Poengtype som beregnes fra vitnemålet
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at opptaksforvalteren har koblet poengtypen "<poengtype>" til <poeng> fra vitnemålet
      Og at søknaden har poengtypen "<poengtype>"
      Når vitnemålspoengene beregnes automatisk
      Så har poengtypen fått <poeng> beregnet fra vitnemålet

      Eksempler:
        | poengtype | poeng         |
        | KAR-NOM   | karakterpoeng |
        | REA-NOM   | realfagspoeng |
        | SPR-NOM   | språkpoeng    |

    Scenario: Poengtype uten kobling til vitnemålet beregnes ikke
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at søknaden har en poengtype som ikke er koblet til poeng fra vitnemålet
      Når vitnemålspoengene beregnes automatisk
      Så er poengtypen uendret

    Scenario: Beregnet poeng rundes til antall desimaler poengtypen har
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at poengtypen for karakterpoeng har ett desimal
      Når vitnemålspoengene beregnes automatisk
      Så har karakterpoenget ett desimal

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

  Regel: Ingen automatisk beregning uten ett entydig vitnemål
    Søkere med flere vitnemål behandles i vitnemålsbehandlingen.

    Scenariomal: Ingen automatiske vitnemålspoeng når <grunn>
      Gitt at <grunn>
      Når vitnemålspoengene beregnes automatisk
      Så får søknaden ingen vitnemålspoeng beregnet automatisk
      Og det fremgår at søkeren ikke har ett entydig vitnemål

      Eksempler:
        | grunn                                            |
        | søkeren har flere vitnemål som ikke er annullert |
        | søkerens eneste dokument er et kompetansebevis   |
        | søkerens eneste vitnemål er annullert            |
        | søkeren ikke har noe vitnemål                    |

    Scenario: Kompetansebevis ved siden av ett vitnemål hindrer ikke beregningen
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at søkeren har et kompetansebevis
      Når vitnemålspoengene beregnes automatisk
      Så har poengtypene fått poeng beregnet fra vitnemålet alene

    Scenario: Automatisk beregnede vitnemålspoeng fjernes når søkeren har to vitnemål
      Gitt at søknaden har vitnemålspoeng som er beregnet automatisk fra et vitnemål
      Og at søkeren har fått et vitnemål til
      Når vitnemålspoengene beregnes automatisk
      Så er de automatisk beregnede vitnemålspoengene fjernet

  @ref-OPT-BEH-BEH-004
  Regel: Poeng som saksbehandleren har låst, beregnes ikke på nytt
    # Hvordan et poeng låses av at saksbehandleren velger grunnlag, og hvordan det låses opp, står i kravet.

    Scenario: Poeng som saksbehandleren endrer, blir stående
      Gitt at søknaden har et vitnemålspoeng som er beregnet automatisk
      Når saksbehandleren endrer poenget
      Så beregnes ikke poenget automatisk på nytt

    Scenariomal: Saksbehandleren overstyrer automatisk beregnet <poeng>
      Gitt at søknaden har <poeng> som er beregnet automatisk
      Når saksbehandleren endrer <poeng>
      Så gjelder saksbehandlerens verdi
      Og den automatiske beregningen endrer ikke <poeng> senere

      Eksempler:
        | poeng         |
        | karakterpoeng |
        | realfagspoeng |
        | språkpoeng    |
        | skolepoeng    |

    Scenario: Låst poeng beregnes ikke på nytt
      Gitt at søknaden har et låst vitnemålspoeng
      Når vitnemålspoengene beregnes automatisk
      Så er det låste poenget uendret

    Scenario: Poeng som ikke er låst, beregnes på nytt
      Gitt at søknaden har et vitnemålspoeng som er beregnet automatisk
      Og at poenget ikke er låst
      Når vitnemålspoengene beregnes automatisk
      Så er poenget erstattet med det nye beregnede poenget

    Scenario: Saksbehandlerens merknad på poenget er uendret
      Gitt at saksbehandleren har skrevet en merknad på et vitnemålspoeng
      Når vitnemålspoengene beregnes automatisk
      Så er merknaden uendret

  Regel: Det fremgår hvordan et poeng er beregnet

    Scenario: Se hvilket vitnemål et automatisk beregnet poeng bygger på
      Gitt at søknaden har et vitnemålspoeng som er beregnet automatisk
      Når saksbehandleren ser på poengene
      Så ser saksbehandleren hvilket vitnemål poenget er beregnet fra

    Scenario: Se hvorfor vitnemålspoengene ikke er beregnet
      Gitt at vitnemålspoengene ikke kunne beregnes automatisk fordi søkeren ikke har ett entydig vitnemål
      Når saksbehandleren ser på poengene
      Så ser saksbehandleren at vitnemålspoengene ikke er beregnet fordi søkeren ikke har ett entydig vitnemål
