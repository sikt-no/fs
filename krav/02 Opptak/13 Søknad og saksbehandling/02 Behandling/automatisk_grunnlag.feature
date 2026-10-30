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
# Flere kilder (fra utkastet i PR #818): Jira FOL-34, STEK-297, STEK-298,
# STEK-299, STEK-514, STEK-454, STEK-430, STEK-315, STEK-317, STEK-505,
# STEK-583, STEK-280. Confluence PFS 4460740612 «Brukerhistorier automatisk
# valg av grunnlag», 4453629977 «2026-03-11 Raffinering automatisk valg av
# grunnlag», 4022829198 «Automatisere valg av grunnlag», 4986798081 «Endring i
# hvordan kvote og grunnlag henger sammen». GitHub #199. I FS-klienten setter
# «Godkjenn VM» i Søknad samlebilde og rutinen FS158.001 grunnlaget sammen med
# poengene.
#
# AVGRENSNING
#
# - Hvilke grunnlag som finnes, og egenskapene de har for automatikken
#   (aldersgrense, krever et vitnemål, krever førstegangsvitnemål), settes opp
#   i regelverket (grunnlag.feature).
# - GSK-konklusjonen settes i automatisk_gsk_konklusjon.feature.
# - Hvordan alderspoeng, kjønnspoeng og de andre tilleggspoengene beregnes, står i
#   automatiske_tilleggspoeng.feature (@OPT-BEH-BEH-028).
# - Vitnemålspoeng står i automatisk_poengberegning.feature (@OPT-BEH-BEH-018),
#   og kravelementene i automatisk_kvalifisering.feature (@OPT-BEH-BEH-020).
# - Søkere med flere vitnemål behandles i vitnemålsbehandlingen.
@OPT-BEH-BEH-019 @must @draft @ref-OPT-BEH-BEH-012 @ref-OPT-BEH-BEH-018
Egenskap: Automatisk grunnlag
  Som saksbehandler
  ønsker jeg at saken får grunnlaget sitt automatisk når søkerens vitnemål og alder avgjør det
  slik at jeg bare trenger å velge grunnlag der det ikke er entydig.

  Grunnlaget avgjør hvilke opptakskrav søknaden vurderes mot, hvordan søkeren
  rangeres, og hvilke kvoter søkeren kan plasseres i. Har søkeren ett
  elektronisk vitnemål som gir generell studiekompetanse, velger systemet
  grunnlaget ut fra vitnemålet og alderen til søkeren. Hvilke grunnlag som kan
  velges automatisk, og hva som skal til, bestemmes av egenskapene
  regelverket har gitt grunnlaget.

  Grunnlaget ligger på saken. Automatikken setter det samme grunnlaget i alle sakene i
  søknaden, men det saksbehandleren gjør, gjelder bare saken hos organisasjonen
  saksbehandleren er ved. Grunnlag som saksbehandleren har valgt, endres aldri av
  automatikken. Det fremgår om et grunnlag er satt automatisk eller av saksbehandleren.

  # Avklart 30.10.2026: grunnlaget ligger på saken, ikke på søknaden. FS-klienten har det på
  # personen. Spørsmålet ble tatt opp i raffineringen og med HK-dir 16.03.2026.

  # Avklart 30.10.2026: grunnlaget blir stående når studieønsket som ga det, fjernes (STEK-505).

  @depends-on-OPT-REG-GRU-001 @ref-FLY-OPT-AUT-001
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
      Så får saken grunnlaget som <grunnlag>

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
      Så får saken grunnlaget med aldersgrensen under 22 år

    Scenario: Førstegangsvitnemål går foran
      Gitt at søkeren passer til et grunnlag som krever førstegangsvitnemål
      Og at søkeren også passer til et grunnlag som bare krever et vitnemål
      Når søknaden behandles automatisk
      Så får saken grunnlaget som krever førstegangsvitnemål
      Men saken får ikke grunnlaget som bare krever et vitnemål

    @ref-FLY-OPT-SAM-001
    Scenario: Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål
      # Avklart 2026-10-29: et sammensatt vitnemål er aldri et førstegangsvitnemål.
      Gitt at regelverket har et grunnlag som krever førstegangsvitnemål og har aldersgrensen under 22 år
      Og at regelverket har et grunnlag som krever et vitnemål
      Og at søkeren er 21 år på datoen for aldersberegning
      Og at saken behandles automatisk på et sammensatt vitnemål
      Når søknaden behandles automatisk
      Så får saken grunnlaget som krever et vitnemål
      Men saken får ikke grunnlaget som krever førstegangsvitnemål

    Scenario: Ingen grunnlag settes når flere grunnlag passer like godt
      # Avklart 30.10.2026: to grunnlag med de samme egenskapene er en feil i regelverket, og
      # regelverket må justeres så det ikke skjer. Kode i dag: grunnlaget med lavest kode
      # velges, og det logges en advarsel.
      Gitt at søkeren passer like godt til to grunnlag
      Når søknaden behandles automatisk
      Så får saken ingen grunnlag automatisk

    Scenario: Grunnlag uten egenskaper for automatikken settes ikke
      Gitt at regelverket har et grunnlag uten aldersgrense, uten krav om vitnemål og uten krav om førstegangsvitnemål
      Når søknaden behandles automatisk
      Så får ikke saken grunnlaget uten egenskaper for automatikken

    Scenario: Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes
      Gitt at søkeren passer til et grunnlag som ikke er med i regelverket til noen av utdanningstilbudene i søknaden
      Når søknaden behandles automatisk
      Så får ikke saken grunnlaget

    Scenario: Grunnlag som ikke er aktivt, settes ikke
      Gitt at søkeren passer til et grunnlag som ikke er aktivt
      Når søknaden behandles automatisk
      Så får ikke saken grunnlaget

  @depends-on-OPT-BEH-BEH-015 @ref-FLY-OPT-AUT-001
  Regel: Ingen automatisk grunnlag uten ett vitnemål som gir generell studiekompetanse
    # Ett vitnemål er nok, også når søkeren har et kompetansebevis i tillegg.
    # Søkere med flere vitnemål behandles i vitnemålsbehandlingen, og den
    # automatiske behandlingen stopper for dem til saksbehandleren har valgt
    # vitnemålet.

    Scenariomal: Ingen grunnlag settes automatisk når <grunn>
      Gitt at <grunn>
      Når søknaden behandles automatisk
      Så får saken ingen grunnlag automatisk

      Eksempler:
        | grunn                                                       |
        | søkeren ikke har noe elektronisk vitnemål                   |
        | søkerens eneste elektroniske dokument er et kompetansebevis |
        | vitnemålet ikke gir generell studiekompetanse               |
        | ingen av grunnlagene i regelverket passer til søkeren       |

    Scenario: Søker med flere vitnemål behandles ikke automatisk
      Gitt at søkeren har to elektroniske vitnemål som ikke er annullert
      Og at saksbehandleren ikke har valgt ett av vitnemålene
      Når søknaden behandles automatisk
      Så blir søknaden ikke behandlet automatisk
      Og saken får ingen grunnlag automatisk

    @ref-OPT-BEH-BEH-025
    Scenario: Grunnlag fra vitnemålet saksbehandleren har valgt
      Gitt at søkeren har to elektroniske vitnemål som gir generell studiekompetanse, ett fra 2024 og ett fra 2025
      Og at saksbehandleren har valgt vitnemålet fra 2025
      Når søknaden behandles automatisk
      Så får saken grunnlaget ut fra vitnemålet fra 2025

    Scenario: Kompetansebevis ved siden av vitnemålet stopper ikke automatikken
      Gitt at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Og at søkeren har et elektronisk kompetansebevis
      Når søknaden behandles automatisk
      Så får saken grunnlaget ut fra vitnemålet

    Scenario: Annullert vitnemål teller ikke
      Gitt at søkeren har to elektroniske vitnemål
      Og at det ene vitnemålet er annullert
      Og at det andre vitnemålet gir generell studiekompetanse
      Når søknaden behandles automatisk
      Så får saken grunnlaget ut fra vitnemålet som ikke er annullert

    Scenario: Grunnlaget settes etter GSK-konklusjonen
      Gitt at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Og at søknaden ikke har noen GSK-konklusjon
      Når søknaden behandles automatisk
      Så får søknaden GSK-konklusjonen fra vitnemålet
      Og saken får grunnlaget ut fra vitnemålet

  @ref-FLY-OPT-AUT-001
  Regel: Grunnlaget settes når den automatiske behandlingen kjører

    Scenario: Automatikken setter grunnlaget i alle sakene i søknaden
      Gitt at søknaden har saker hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"
      Og at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Når søknaden behandles automatisk
      Så har sakene hos "Universitetet i Oslo" og "UiT Norges arktiske universitet" det samme grunnlaget

    Scenario: Grunnlaget settes av den automatiske behandlingen
      Gitt at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Når den automatiske behandlingen kjøres for søknaden
      Så får saken grunnlaget automatisk

    @openquestion
    Scenario: Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes
      # ÅPNE SPØRSMÅL:
      # - FS-klienten kan sette et grunnlag fra studieprogrammet når
      #   søknadsalternativet opprettes («Aut.kvalgrunnlag»). Skal det
      #   videreføres? Avgjøres når lokale opptak tas inn (30.10.2026). Gjelder ikke
      #   den helautomatiske flyten. Blir kravet @planned før det, får scenarioet @draft.
      Gitt at utdanningstilbudet har et grunnlag som skal settes automatisk
      Når søkeren søker på utdanningstilbudet
      Så får saken grunnlaget fra utdanningstilbudet

  Regel: Grunnlag som saksbehandleren har valgt, endres ikke av automatikken

    Scenario: Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag
      Gitt at saksbehandleren har lagt til et grunnlag i saken
      Og at søkeren passer til et annet grunnlag
      Når søknaden behandles automatisk
      Så er grunnlagene i saken uendret

    Scenario: Grunnlaget saksbehandleren legger til, gjelder bare saken hos organisasjonen
      Gitt at søknaden har saker hos "Universitetet i Oslo" og "UiT Norges arktiske universitet"
      Når saksbehandleren ved Universitetet i Oslo legger til grunnlaget "PRA"
      Så har saken hos "Universitetet i Oslo" grunnlaget "PRA"
      Og saken hos "UiT Norges arktiske universitet" har ikke grunnlaget "PRA"

    Scenario: Saksbehandleren velger et grunnlag som automatikken har satt
      Gitt at saken har et grunnlag som er satt automatisk
      Når saksbehandleren legger til grunnlaget som er satt automatisk
      Så er grunnlaget satt av saksbehandleren
      Og grunnlaget er ikke lenger satt automatisk

    Scenario: Automatikken fjerner ikke grunnlag
      Gitt at saken har et grunnlag som er satt automatisk
      Og at søkeren ikke lenger passer til grunnlaget
      Når søknaden behandles automatisk
      Så har saken fortsatt grunnlaget

    Scenario: Grunnlaget blir stående når studieønsket som ga det, fjernes
      Gitt at saken har et grunnlag som er satt automatisk
      Og at grunnlaget bare finnes i regelverket til "Informatikk, UiO"
      Når søkeren fjerner "Informatikk, UiO" fra søknaden
      Så har saken fortsatt grunnlaget

    Scenario: Saksbehandleren fjerner et grunnlag som er satt automatisk
      Gitt at saken har et grunnlag som er satt automatisk
      Når saksbehandleren fjerner grunnlaget
      Så har ikke saken lenger grunnlaget

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
      Så får saken ikke grunnlaget

    @openquestion
    Scenario: Automatikken erstatter grunnlaget når søkeren passer til et annet
      # ÅPNE SPØRSMÅL:
      # - Har automatikken satt et grunnlag, og søkeren passer senere til et
      #   annet (for eksempel etter nytt vitnemål), beholdes begge i dag.
      #   Skal det nye erstatte det gamle?
      Gitt at saken har et grunnlag som er satt automatisk
      Og at søkeren nå passer til et annet grunnlag
      Når søknaden behandles automatisk
      Så har saken bare det nye grunnlaget

    @openquestion
    Scenario: Gjøre søknaden tilgjengelig for automatikken igjen
      # ÅPNE SPØRSMÅL:
      # - Ny stack har ingen måte å låse opp grunnlagene på. Raffineringen
      #   spurte hvordan en sak settes tilbake slik at den kan behandles
      #   automatisk igjen. Trengs det?
      Gitt at grunnlagene i saken er låst mot automatikken
      Når saksbehandleren låser opp grunnlagene
      Og søknaden behandles automatisk
      Så kan søknaden få grunnlag automatisk igjen

    @openquestion
    Scenario: Grunnlag utenfor aldersgrensen kan ikke velges manuelt
      # ÅPNE SPØRSMÅL:
      # - I dag kan saksbehandleren velge et grunnlag selv om søkeren er utenfor
      #   aldersgrensen. Søkeren blir da ikke plassert i kvoten (STEK-583). Skal
      #   valget hindres?
      Gitt at søkeren er utenfor aldersgrensen til et grunnlag
      Når saksbehandleren legger til grunnlaget
      Så blir ikke grunnlaget lagt til

  @depends-on-OPT-OVO-FRI-001
  # Regelen «Opptaksforvalter setter dato for aldersberegning».
  Regel: Grunnlag med aldersgrense krever dato for aldersberegning

    @openquestion
    Scenario: Opptaket mangler dato for aldersberegning
      # ÅPNE SPØRSMÅL:
      # - I dag stopper valget av grunnlaget med en beskjed når opptaket har
      #   alderspoeng og verken dato for aldersberegning eller dato for
      #   publisering av resultatet. Alderen kan da ikke fastslås. Skal grunnlag
      #   med aldersgrense heller filtreres bort, så de ikke kan velges?
      Gitt at regelverket har grunnlaget "VOV" med aldersgrensen under 22 år
      Og at opptaket ikke har dato for aldersberegning eller dato for publisering av resultatet
      Når saksbehandleren velger grunnlaget "VOV" for søknaden
      Så får saksbehandleren beskjed om at opptaket mangler dato for aldersberegning
      Og grunnlaget er ikke lagt til

  @ref-OPT-BEH-BEH-028
  Regel: Når grunnlaget settes, vurderes søknaden på nytt
    # Gjelder uansett om grunnlaget er satt automatisk eller av saksbehandleren.
    # Hvordan tilleggspoengene regnes ut, står i kravet.

    Scenario: Opptakskrav, kvoter og tilleggspoeng følger grunnlaget saksbehandleren legger til
      Gitt at saken har et grunnlag
      Når saksbehandleren legger til et annet grunnlag
      Så er opptakskravene vurdert på nytt mot grunnlagene
      Og kvotene søkeren kan plasseres i er oppdatert etter grunnlagene
      Og tilleggspoengene er regnet ut for grunnlagene

    Scenario: Opptakskrav, kvoter og tilleggspoeng følger grunnlaget som er satt automatisk
      Gitt at søknaden ikke har noe grunnlag
      Når saken får et grunnlag automatisk
      Så er opptakskravene vurdert mot grunnlaget
      Og kvotene søkeren kan plasseres i er oppdatert etter grunnlaget
      Og tilleggspoengene er regnet ut for grunnlaget

  Regel: Sporbarhet

    Scenario: Se at grunnlaget er satt automatisk
      Gitt at saken har fått grunnlaget automatisk
      Når saksbehandleren ser på grunnlagene
      Så ser saksbehandleren at grunnlaget er satt automatisk

    Scenario: Se hvorfor grunnlaget ble valgt
      Gitt at saken har fått grunnlaget automatisk fordi søkeren har førstegangsvitnemål og er 21 år
      Når saksbehandleren ser på grunnlagene
      Så ser saksbehandleren at grunnlaget ble valgt på grunn av førstegangsvitnemålet og alderen på 21 år

    Scenario: Endringsloggen viser at den automatiske behandlingen satte grunnlaget
      Gitt at saken har fått grunnlaget automatisk
      Når saksbehandleren ser i endringsloggen for søknaden
      Så ser saksbehandleren at grunnlaget ble satt av den automatiske behandlingen
