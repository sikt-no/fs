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
@OPT-BEH-BEH-018 @must @in-progress @scope-automatisk-grunnlag-og-poeng @depends-on-OPT-BEH-BEH-015 @depends-on-OPT-BEH-BEH-019 @ref-OPT-BEH-BEH-008 @ref-OPT-BEH-BEH-032 @ref-OPT-BEH-BEH-035
Egenskap: Automatisk beregning av vitnemålspoeng
  Som saksbehandler
  ønsker jeg at karakterpoeng, realfagspoeng, språkpoeng og skolepoeng beregnes automatisk fra søkerens vitnemål
  slik at jeg bare trenger å behandle poengene der grunnlaget ikke er entydig.

  Beregningen bruker søkerens eneste vitnemål, og er bare mulig når søkeren har ett elektronisk
  vitnemål. Søkere med flere vitnemål behandles manuelt, eller automatisk på vitnemålet
  saksbehandleren velger (OPT-BEH-BEH-039). Hvilke karakterer som teller, og hvordan de regnes om
  til poeng, er ikke beskrevet her.

  Poengene ligger på saken, som grunnlaget (OPT-BEH-BEH-019), og beregnes når den automatiske
  behandlingen kjører for saken. Det saksbehandleren overstyrer eller låser, gjelder bare saken
  hos organisasjonen saksbehandleren er ved. Avklart 30.10.2026, endret 06.11.2026.

  # Avklart 29.10.2026, endret 2026-11-03: opptaksforvalteren kan sette når den automatiske
  # saksbehandlingen starter og avsluttes i opptaket (OPT-BEH-BEH-032, OPT-OVO-FRI-001).

  Bakgrunn:
    Gitt at søkeren har en søknad i opptaket

  @depends-on-OPT-REG-RAN-002 @ref-FLY-OPT-AUT-001 @implemented
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

    # Har søkeren flere vitnemål, eller gir vitnemålet ikke generell studiekompetanse, får saken
    # ikke grunnlag automatisk, og uten grunnlag beregnes ingen poeng (OPT-BEH-BEH-019,
    # OPT-BEH-BEH-039). Endret 09.11.2026.
    Scenariomal: Ingen automatiske vitnemålspoeng når <grunn>
      Gitt at <grunn>
      Når vitnemålspoengene beregnes automatisk
      Så får saken ingen vitnemålspoeng beregnet automatisk
      Og det fremgår at søkeren ikke har ett entydig vitnemål

      Eksempler:
        | grunn                                 |
        | søkerens eneste vitnemål er annullert |
        | søkeren ikke har noe vitnemål         |

    @implemented
    Scenario: Opplastet kompetansebevis hindrer ikke beregningen
      # Avklart 06.11.2026: kompetansebevis kommer bare som dokumenter søkeren laster opp, ikke
      # fra KREG. Saksbehandleren finner sakene med filteret «Ubehandlet opplastet dok.» i
      # saksoversikten. Filteret er ikke beskrevet i et krav ennå.
      Gitt at søkeren har ett vitnemål som ikke er annullert
      Og at søkeren har lastet opp et kompetansebevis
      Når vitnemålspoengene beregnes automatisk
      Så har poengtypene fått poeng beregnet fra vitnemålet alene

    # Scenarioet «Vitnemålspoeng fra vitnemålet saksbehandleren har valgt» er flyttet til
    # OPT-BEH-BEH-039 (06.11.2026). Søkere med flere vitnemål behandles manuelt.

  @ref-OPT-BEH-BEH-004 @implemented
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
    Scenario: Finne saker som er behandlet automatisk
      # Brukerbehov fra raffineringen (PFS 4392517645): å kunne søke opp hvem som er behandlet
      # automatisk. FS158.001 har «Vis tidligere behandlinger».
      # Avklart 06.11.2026 (økt med fagfolk): et filter i saksoversikten holder. Det trengs ingen
      # logg eller rapport i denne flyten.
      # ÅPNE SPØRSMÅL:
      # - Raffineringen ønsket å skille sakene som er behandlet helautomatisk fra dem der
      #   saksbehandleren har startet den automatiske behandlingen. Skal filteret skille dem?
      Gitt at noen saker i opptaket er behandlet automatisk
      Når saksbehandleren filtrerer på saker som er behandlet automatisk
      Så ser saksbehandleren bare sakene som er behandlet automatisk
