# language: no
#
# Kilder: Jira STEK-252 (automatisk setting av grunnlag, del av epic STEK-218) og
# STEK-296. Funksjonaliteten finnes i fs-plattform (opptak-service, autosak:
# SetteGrunnlagService), og kjøres som steg i den automatiske saksbehandlingen
# etter GSK-konklusjonen. Det er bare koblet til automatisk behandling av
# søknader med digitalt vitnemål fra videregående skole fra KREG.
# Manuelt velger saksbehandleren grunnlag i steget «Grunnlag» i fs-admin
# (leggTilGrunnlag og fjernGrunnlag).
#
# AVGRENSNING
#
# - Hvilke grunnlag som finnes, og egenskapene de har for automatikken
#   (aldersgrense, krever et vitnemål, krever førstegangsvitnemål), settes opp
#   i regelverket (grunnlag.feature).
# - GSK-konklusjonen settes i automatisk_gsk_konklusjon.feature.
# - Hvordan alderspoeng, kjønnspoeng og de andre tilleggspoengene beregnes, står i
#   automatiske_tilleggspoeng.feature (@OPT-BEH-BEH-028), som skrives på en annen branch.
# - Vitnemålspoeng står i automatisk_poengberegning.feature (@OPT-BEH-BEH-018),
#   og kravelementene i automatisk_kvalifisering.feature (@OPT-BEH-BEH-020).
# - Søkere med flere vitnemål behandles i vitnemålsbehandlingen.
@OPT-BEH-BEH-019 @must @draft
Egenskap: Automatisk grunnlag
  Som saksbehandler
  ønsker jeg at søknaden får grunnlaget sitt automatisk når søkerens vitnemål og alder avgjør det
  slik at jeg bare trenger å velge grunnlag der det ikke er entydig.

  Grunnlaget avgjør hvilke opptakskrav søknaden vurderes mot, hvordan søkeren
  rangeres, og hvilke kvoter søkeren kan plasseres i. Har søkeren ett
  elektronisk vitnemål som gir generell studiekompetanse, velger systemet
  grunnlaget ut fra vitnemålet og alderen til søkeren. Hvilke grunnlag som kan
  velges automatisk, og hva som skal til, bestemmes av egenskapene
  regelverket har gitt grunnlaget.

  Grunnlag som saksbehandleren har valgt, endres aldri av automatikken. Det
  fremgår om et grunnlag er satt automatisk eller av saksbehandleren.

  @depends-on-OPT-REG-GRU-001
  Regel: Grunnlaget velges ut fra egenskapene regelverket har gitt det
    # Regelverket kan gi et grunnlag en aldersgrense, og kreve at søkeren har et
    # vitnemål, eller et førstegangsvitnemål. Grunnlag uten noen av disse
    # egenskapene velges bare av saksbehandleren. Egenskapene står ikke i
    # grunnlag.feature ennå.

    Scenariomal: Grunnlag ut fra førstegangsvitnemål og alder
      Gitt at regelverket har et grunnlag som krever førstegangsvitnemål og har aldersgrensen under 22 år
      Og at regelverket har et grunnlag som krever et vitnemål
      Og at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Og at vitnemålet <førstegangsvitnemål>
      Og at søkeren er <alder> år på datoen for aldersberegning
      Når søknaden behandles automatisk
      Så får søknaden grunnlaget som <grunnlag>

      Eksempler:
        | førstegangsvitnemål         | alder | grunnlag                   |
        | er førstegangsvitnemål      | 21    | krever førstegangsvitnemål |
        | er førstegangsvitnemål      | 24    | krever et vitnemål         |
        | ikke er førstegangsvitnemål | 21    | krever et vitnemål         |

    Scenario: Alderen regnes ut på datoen for aldersberegning
      Gitt at opptaket har 31.12.2026 som dato for aldersberegning
      Og at regelverket har et grunnlag med aldersgrensen under 22 år
      Og at søkeren er født 15.03.2005
      Og at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Når søknaden behandles automatisk 01.09.2026
      Så får søknaden grunnlaget med aldersgrensen under 22 år

    Scenario: Førstegangsvitnemål går foran
      Gitt at søkeren passer til et grunnlag som krever førstegangsvitnemål
      Og at søkeren også passer til et grunnlag som bare krever et vitnemål
      Når søknaden behandles automatisk
      Så får søknaden grunnlaget som krever førstegangsvitnemål
      Men søknaden får ikke grunnlaget som bare krever et vitnemål

    Scenario: Grunnlag som bare har en aldersgrense, kommer sist
      Gitt at søkeren passer til et grunnlag som bare har en aldersgrense
      Og at søkeren også passer til et grunnlag som krever et vitnemål
      Når søknaden behandles automatisk
      Så får søknaden grunnlaget som krever et vitnemål

    Scenario: Grunnlag uten egenskaper for automatikken settes ikke
      Gitt at regelverket har et grunnlag uten aldersgrense, uten krav om vitnemål og uten krav om førstegangsvitnemål
      Når søknaden behandles automatisk
      Så får ikke søknaden grunnlaget uten egenskaper for automatikken

    Scenario: Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes
      Gitt at søkeren passer til et grunnlag som ikke er med i regelverket til noen av utdanningstilbudene i søknaden
      Når søknaden behandles automatisk
      Så får ikke søknaden grunnlaget

    Scenario: Grunnlag som ikke er aktivt, settes ikke
      Gitt at søkeren passer til et grunnlag som ikke er aktivt
      Når søknaden behandles automatisk
      Så får ikke søknaden grunnlaget

  @depends-on-OPT-BEH-BEH-015
  Regel: Ingen automatisk grunnlag uten ett vitnemål som gir generell studiekompetanse
    # Ett vitnemål er nok, også når søkeren har et kompetansebevis i tillegg.
    # Søkere med flere vitnemål behandles i vitnemålsbehandlingen, og den
    # automatiske behandlingen stopper for dem.

    Scenariomal: Ingen grunnlag settes automatisk når <grunn>
      Gitt at <grunn>
      Når søknaden behandles automatisk
      Så får søknaden ingen grunnlag automatisk

      Eksempler:
        | grunn                                                       |
        | søkeren ikke har noe elektronisk vitnemål                   |
        | søkerens eneste elektroniske dokument er et kompetansebevis |
        | vitnemålet ikke gir generell studiekompetanse               |
        | ingen av grunnlagene i regelverket passer til søkeren       |

    Scenario: Søker med flere vitnemål behandles ikke automatisk
      Gitt at søkeren har to elektroniske vitnemål som ikke er annullert
      Når søknaden behandles automatisk
      Så blir søknaden ikke behandlet automatisk
      Og søknaden får ingen grunnlag automatisk

    Scenario: Kompetansebevis ved siden av vitnemålet stopper ikke automatikken
      Gitt at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Og at søkeren har et elektronisk kompetansebevis
      Når søknaden behandles automatisk
      Så får søknaden grunnlaget ut fra vitnemålet

    Scenario: Annullert vitnemål teller ikke
      Gitt at søkeren har to elektroniske vitnemål
      Og at det ene vitnemålet er annullert
      Og at det andre vitnemålet gir generell studiekompetanse
      Når søknaden behandles automatisk
      Så får søknaden grunnlaget ut fra vitnemålet som ikke er annullert

    Scenario: Grunnlaget settes etter GSK-konklusjonen
      Gitt at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Og at søknaden ikke har noen GSK-konklusjon
      Når søknaden behandles automatisk
      Så får søknaden GSK-konklusjonen fra vitnemålet
      Og søknaden får grunnlaget ut fra vitnemålet

  Regel: Grunnlaget settes når den automatiske behandlingen kjører

    Scenario: Grunnlaget settes av den automatiske behandlingen
      Gitt at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Når den automatiske behandlingen kjøres for søknaden
      Så får søknaden grunnlaget automatisk

  Regel: Grunnlag som saksbehandleren har valgt, endres ikke av automatikken

    Scenario: Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag
      Gitt at saksbehandleren har lagt til et grunnlag på søknaden
      Og at søkeren passer til et annet grunnlag
      Når søknaden behandles automatisk
      Så er grunnlagene på søknaden uendret

    Scenario: Saksbehandleren velger et grunnlag som automatikken har satt
      Gitt at søknaden har et grunnlag som er satt automatisk
      Når saksbehandleren legger til grunnlaget som er satt automatisk
      Så er grunnlaget satt av saksbehandleren
      Og grunnlaget er ikke lenger satt automatisk

    Scenario: Automatikken fjerner ikke grunnlag
      Gitt at søknaden har et grunnlag som er satt automatisk
      Og at søkeren ikke lenger passer til grunnlaget
      Når søknaden behandles automatisk
      Så har søknaden fortsatt grunnlaget

    Scenario: Saksbehandleren fjerner et grunnlag som er satt automatisk
      Gitt at søknaden har et grunnlag som er satt automatisk
      Når saksbehandleren fjerner grunnlaget
      Så har ikke søknaden lenger grunnlaget

    @openquestion
    Scenario: Automatikken setter ikke et grunnlag som saksbehandleren har fjernet
      # ÅPNE SPØRSMÅL:
      # - Utgangspunktet er at saken er låst for automatikken når
      #   saksbehandleren har gjort endringer på den, men «la stå» er fjernet
      #   fra grunnlaget. Fjerner saksbehandleren et grunnlag som er satt
      #   automatisk, låser det i dag ikke saken, og kjøres den automatiske
      #   behandlingen igjen, settes grunnlaget på nytt. Skal fjerningen låse
      #   saken, så grunnlaget holdes borte?
      Gitt at saksbehandleren har fjernet et grunnlag som var satt automatisk
      Og at søkeren fortsatt passer til grunnlaget
      Når søknaden behandles automatisk
      Så får søknaden ikke grunnlaget

    @openquestion
    Scenario: Automatikken erstatter grunnlaget når søkeren passer til et annet
      # ÅPNE SPØRSMÅL:
      # - Har automatikken satt et grunnlag, og søkeren passer senere til et
      #   annet (for eksempel etter nytt vitnemål), beholdes begge i dag.
      #   Skal det nye erstatte det gamle?
      Gitt at søknaden har et grunnlag som er satt automatisk
      Og at søkeren nå passer til et annet grunnlag
      Når søknaden behandles automatisk
      Så har søknaden bare det nye grunnlaget

  Regel: Når grunnlaget settes, vurderes søknaden på nytt
    # Gjelder uansett om grunnlaget er satt automatisk eller av saksbehandleren.

    Scenario: Opptakskrav og kvoter følger grunnlaget saksbehandleren legger til
      Gitt at søknaden har et grunnlag
      Når saksbehandleren legger til et annet grunnlag
      Så er opptakskravene vurdert på nytt mot grunnlagene
      Og kvotene søkeren kan plasseres i er oppdatert etter grunnlagene

    Scenario: Opptakskrav og kvoter følger grunnlaget som er satt automatisk
      Gitt at søknaden ikke har noe grunnlag
      Når søknaden får et grunnlag automatisk
      Så er opptakskravene vurdert mot grunnlaget
      Og kvotene søkeren kan plasseres i er oppdatert etter grunnlaget

  Regel: Poeng fra poengalgoritmene settes uavhengig av hvem som setter grunnlaget
    # Hvordan tilleggspoengene beregnes, står i automatiske_tilleggspoeng.feature
    # (@OPT-BEH-BEH-028). Poengene bygger ikke på vitnemålet.

    Scenario: Saksbehandleren velger grunnlag og søknaden får poengene grunnlaget gir
      Gitt at rangeringsregelverket gir alderspoeng og kjønnspoeng for grunnlaget
      Og at søknaden ikke har noe grunnlag
      Når saksbehandleren legger til grunnlaget
      Så har søknaden alderspoeng og kjønnspoeng for grunnlaget

    Scenario: Søker uten elektronisk vitnemål får poeng fra poengalgoritmene
      Gitt at søkeren ikke har noe elektronisk vitnemål
      Og at rangeringsregelverket gir alderspoeng og kjønnspoeng for grunnlaget
      Når saksbehandleren legger til grunnlaget
      Så har søknaden alderspoeng og kjønnspoeng for grunnlaget

    Scenario: Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget
      Gitt at rangeringsregelverket gir alderspoeng og kjønnspoeng for to grunnlag
      Og at søknaden har det ene grunnlaget
      Når saksbehandleren bytter til det andre grunnlaget
      Så har søknaden alderspoeng og kjønnspoeng for det andre grunnlaget

    Scenario: Poengene er låst for automatikken når saksbehandleren har behandlet saken
      Gitt at saksbehandleren har behandlet saken
      Og at søknaden har alderspoeng og kjønnspoeng for grunnlaget
      Når den automatiske behandlingen kjøres for søknaden
      Så er alderspoengene og kjønnspoengene på søknaden uendret

    Scenariomal: Samme poeng uansett hvem som setter grunnlaget
      Gitt at rangeringsregelverket gir alderspoeng og kjønnspoeng for grunnlaget
      Og at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Når <hvem> setter grunnlaget på søknaden
      Så har søknaden de samme alderspoengene og kjønnspoengene for grunnlaget

      Eksempler:
        | hvem                         |
        | den automatiske behandlingen |
        | saksbehandleren              |

  Regel: Sporbarhet

    Scenario: Se at grunnlaget er satt automatisk
      Gitt at søknaden har fått grunnlaget automatisk
      Når saksbehandleren ser på grunnlagene
      Så ser saksbehandleren at grunnlaget er satt automatisk

    Scenario: Se hvorfor grunnlaget ble valgt
      Gitt at søknaden har fått grunnlaget automatisk fordi søkeren har førstegangsvitnemål og er 21 år
      Når saksbehandleren ser på grunnlagene
      Så ser saksbehandleren at grunnlaget ble valgt på grunn av førstegangsvitnemålet og alderen på 21 år

    Scenario: Endringsloggen viser at den automatiske behandlingen satte grunnlaget
      Gitt at søknaden har fått grunnlaget automatisk
      Når saksbehandleren ser i endringsloggen for søknaden
      Så ser saksbehandleren at grunnlaget ble satt av den automatiske behandlingen
