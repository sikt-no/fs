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
# - Søkere med flere vitnemål: grunnlaget fra vitnemålet saksbehandleren har valgt, står i
#   behandle_automatisk_på_valgt_vitnemål.feature (@OPT-BEH-BEH-039).
@OPT-BEH-BEH-019 @must @in-progress @scope-automatisk-grunnlag-og-poeng @ref-OPT-BEH-BEH-012 @ref-OPT-BEH-BEH-018
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

  Grunnlaget ligger på saken, og settes når den automatiske behandlingen kjører for saken.
  Hver sak behandles for seg (OPT-BEH-BEH-032), ut fra utdanningstilbudene organisasjonen
  behandler i saken. Det saksbehandleren gjør, gjelder bare saken hos organisasjonen
  saksbehandleren er ved. Grunnlag som saksbehandleren har valgt, endres aldri av
  automatikken. Det fremgår om et grunnlag er satt automatisk eller av saksbehandleren.

  # Avklart 06.11.2026: grunnlaget settes per sak, ikke i alle sakene i søknaden samtidig.
  # Avklart 30.10.2026: grunnlaget ligger på saken, ikke på søknaden. FS-klienten har det på
  # personen. Spørsmålet ble tatt opp i raffineringen og med HK-dir 16.03.2026.

  # Avklart 30.10.2026: grunnlaget blir stående når studieønsket som ga det, fjernes (STEK-505).

  @depends-on-OPT-REG-GRU-001 @ref-FLY-OPT-AUT-001 @ref-FLY-OPT-SAM-001 @implemented
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

    Scenario: Søkeren som er akkurat 22 år, får grunnlaget som krever et vitnemål
      Gitt at regelverket har et grunnlag som krever førstegangsvitnemål og har aldersgrensen under 22 år
      Og at regelverket har et grunnlag som krever et vitnemål
      Og at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Og at vitnemålet er førstegangsvitnemål
      Og at søkeren er 22 år på datoen for aldersberegning
      Når søknaden behandles automatisk
      Så får saken grunnlaget som krever et vitnemål
      Men saken får ikke grunnlaget som krever førstegangsvitnemål

    Scenario: Alderen regnes ut på datoen for aldersberegning
      Gitt at opptaket har 31.12.2026 som dato for aldersberegning
      Og at regelverket har et grunnlag med aldersgrensen under 22 år
      Og at søkeren er født 15.10.2004
      Og at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Når søknaden behandles automatisk 01.09.2026
      Så får ikke saken grunnlaget med aldersgrensen under 22 år

    Scenario: Førstegangsvitnemål går foran
      Gitt at søkeren passer til et grunnlag som krever førstegangsvitnemål
      Og at søkeren også passer til et grunnlag som bare krever et vitnemål
      Når søknaden behandles automatisk
      Så får saken grunnlaget som krever førstegangsvitnemål
      Men saken får ikke grunnlaget som bare krever et vitnemål

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

  @depends-on-OPT-BEH-BEH-015 @ref-FLY-OPT-AUT-001 @implemented
  Regel: Ingen automatisk grunnlag uten ett vitnemål som gir generell studiekompetanse
    # Ett vitnemål er nok, også når søkeren har lastet opp et kompetansebevis.
    # Har søkeren flere vitnemål, stopper den automatiske behandlingen til
    # saksbehandleren har valgt vitnemålet (OPT-BEH-BEH-039).

    @deprecated
    Scenariomal: Ingen grunnlag settes automatisk når <grunn> (avvikles)
      Gitt at <grunn>
      Når søknaden behandles automatisk
      Så får saken ingen grunnlag automatisk

      Eksempler:
        | grunn                                                       |
        | søkeren ikke har noe elektronisk vitnemål                   |
        | søkerens eneste elektroniske dokument er et kompetansebevis |
        | vitnemålet ikke gir generell studiekompetanse               |
        | ingen av grunnlagene i regelverket passer til søkeren       |

    # Avklart 06.11.2026: kompetansebevis kommer ikke fra KREG, så raden om kompetansebevis er tatt ut.
    Scenariomal: Ingen grunnlag settes automatisk når <grunn>
      Gitt at <grunn>
      Når søknaden behandles automatisk
      Så får saken ingen grunnlag automatisk

      Eksempler:
        | grunn                                                 |
        | søkeren ikke har noe elektronisk vitnemål             |
        | vitnemålet ikke gir generell studiekompetanse         |
        | ingen av grunnlagene i regelverket passer til søkeren |

    Scenario: Søker med flere vitnemål behandles ikke automatisk
      Gitt at søkeren har to elektroniske vitnemål som ikke er annullert
      Og at saksbehandleren ikke har valgt ett av vitnemålene
      Når søknaden behandles automatisk
      Så blir søknaden ikke behandlet automatisk
      Og saken får ingen grunnlag automatisk

    Scenario: Opplastet kompetansebevis stopper ikke automatikken
      # Avklart 06.11.2026: kompetansebevis kommer bare som dokumenter søkeren laster opp, ikke
      # fra KREG. Saksbehandleren finner sakene med filteret «Ubehandlet opplastet dok.» i
      # saksoversikten. Filteret er ikke beskrevet i et krav ennå.
      Gitt at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Og at søkeren har lastet opp et kompetansebevis
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

  @ref-FLY-OPT-AUT-001 @implemented
  Regel: Grunnlaget settes når den automatiske behandlingen kjører

    Scenario: Hver sak i søknaden får grunnlaget når den automatiske behandlingen kjører for saken
      # Avklart 06.11.2026: erstatter «Automatikken setter grunnlaget i alle sakene i søknaden».
      Gitt at søknaden har saker hos to saksbehandlende organisasjoner
      Og at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Når den automatiske behandlingen kjører for saken hos den ene saksbehandlende organisasjonen
      Så får saken hos den ene saksbehandlende organisasjonen grunnlaget automatisk
      Men saken hos den andre saksbehandlende organisasjonen får ikke grunnlaget før den automatiske behandlingen kjører for den saken

    Scenario: Grunnlaget settes av den automatiske behandlingen
      Gitt at søkeren har ett elektronisk vitnemål som gir generell studiekompetanse
      Når den automatiske behandlingen kjøres for søknaden
      Så får saken grunnlaget automatisk

  @draft @openquestion
  Regel: Grunnlaget kan settes fra utdanningstilbudet når søknadsalternativet opprettes
    # ÅPNE SPØRSMÅL:
    # - FS-klienten kan sette et grunnlag fra studieprogrammet når
    #   søknadsalternativet opprettes («Aut.kvalgrunnlag»). Skal det
    #   videreføres? Avgjøres når lokale opptak tas inn (30.10.2026). Gjelder ikke
    #   den automatiske behandlingen.

    Scenario: Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes
      Gitt at utdanningstilbudet har et grunnlag som skal settes automatisk
      Når søkeren søker på utdanningstilbudet
      Så får saken grunnlaget fra utdanningstilbudet

  Regel: Grunnlag som saksbehandleren har valgt, endres ikke av automatikken

    @implemented
    Scenario: Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag
      Gitt at saksbehandleren har lagt til et grunnlag i saken
      Og at søkeren passer til et annet grunnlag
      Når søknaden behandles automatisk
      Så er grunnlagene i saken uendret

    @implemented
    Scenario: Grunnlaget saksbehandleren legger til, gjelder bare saken hos organisasjonen
      Gitt at søknaden har saker hos to saksbehandlende organisasjoner
      Når saksbehandleren ved den ene saksbehandlende organisasjonen legger til et grunnlag
      Så har saken hos den ene saksbehandlende organisasjonen grunnlaget
      Og saken hos den andre saksbehandlende organisasjonen har ikke grunnlaget

    Scenario: Saksbehandleren velger et grunnlag som automatikken har satt
      Gitt at saken har et grunnlag som er satt automatisk
      Når saksbehandleren legger til grunnlaget som er satt automatisk
      Så er grunnlaget satt av saksbehandleren
      Og grunnlaget er ikke lenger satt automatisk

    @implemented
    Scenario: Automatikken fjerner ikke grunnlag saksbehandleren har lagt til
      Gitt at saksbehandleren har lagt til et grunnlag i saken
      Og at søkeren ikke lenger passer til grunnlaget
      Når søknaden behandles automatisk
      Så har saken fortsatt grunnlaget

    @implemented
    Scenario: Grunnlaget blir stående når studieønsket som ga det, fjernes
      Gitt at saken har et grunnlag som er satt automatisk
      Og at grunnlaget bare finnes i regelverket til søknadsalternativet
      Når søkeren fjerner søknadsalternativet fra søknaden
      Så har saken fortsatt grunnlaget

    @implemented
    Scenario: Saksbehandleren fjerner et grunnlag som er satt automatisk
      Gitt at saken har et grunnlag som er satt automatisk
      Når saksbehandleren fjerner grunnlaget
      Så har ikke saken lenger grunnlaget

    Scenario: Automatikken setter ikke et grunnlag som saksbehandleren har fjernet
      # Avklart 30.10.2026: bare grunnlaget saksbehandleren fjernet, holdes borte. De andre
      # grunnlagene låses ikke. Kode i dag: grunnlaget settes på nytt når den automatiske
      # behandlingen kjører igjen.
      Gitt at saksbehandleren har fjernet et grunnlag som var satt automatisk
      Og at søkeren fortsatt passer til grunnlaget
      Når søknaden behandles automatisk
      Så får saken ikke grunnlaget

    Scenario: Automatikken erstatter grunnlaget når søkeren passer til et annet
      # Avklart 30.10.2026: grunnlaget automatikken har satt, speiler vitnemålet saken er
      # behandlet på. Kode i dag: begge grunnlagene beholdes.
      Gitt at saken har et grunnlag som er satt automatisk
      Og at søkeren nå passer til et annet grunnlag
      Når søknaden behandles automatisk
      Så har saken bare det nye grunnlaget

    # Avklart 30.10.2026: det trengs ingen egen funksjon for å låse opp grunnlagene for
    # automatikken. Saksbehandleren fjerner grunnlaget som ble lagt til, og starter behandlingen
    # på nytt (OPT-BEH-BEH-032), eller legger selv til et grunnlag som ble fjernet.

    @depends-on-OPT-OVO-FRI-001
    # Regelen «Opptaksforvalter setter dato for aldersberegning».
    Scenario: Grunnlag utenfor aldersgrensen kan ikke velges manuelt
      # Avklart 09.11.2026: når opptaket har dato for aldersberegning, tilbys ikke grunnlag der
      # søkeren er utenfor aldersgrensen. Erstatter avklaringen fra 30.10.2026. Kode i dag:
      # grunnlaget kan legges til, og søkeren blir da ikke plassert i kvoten (STEK-583).
      # Uten dato kan ikke alderen regnes ut, så da vises grunnlaget, og avvises når det velges
      # («Opptaket mangler dato for aldersberegning»).
      Gitt at opptaket har dato for aldersberegning eller dato for publisering av resultatet
      Og at søkeren er utenfor aldersgrensen til et grunnlag
      Når saksbehandleren velger grunnlag for saken
      Så kan ikke saksbehandleren velge grunnlaget utenfor aldersgrensen

    @depends-on-OPT-OVO-FRI-001
    # Regelen «Opptaksforvalter setter dato for aldersberegning».
    Scenario: Grunnlag utenfor aldersgrensen blir ikke lagt til
      # Grunnlaget tilbys ikke i FS Admin (scenarioet over). Scenarioet gjelder når grunnlaget legges
      # til gjennom API-et.
      Gitt at opptaket har dato for aldersberegning eller dato for publisering av resultatet
      Og at søkeren er utenfor aldersgrensen til et grunnlag
      Når grunnlaget utenfor aldersgrensen legges til i saken
      Så blir ikke grunnlaget lagt til
      Og saksbehandleren ser at søkeren er utenfor aldersgrensen til grunnlaget

  @depends-on-OPT-OVO-FRI-001
  # Regelen «Opptaksforvalter setter dato for aldersberegning».
  Regel: Grunnlag med aldersgrense krever dato for aldersberegning

    Scenario: Opptaket mangler dato for aldersberegning
      # Avklart 30.10.2026: grunnlaget vises, men kan ikke legges til, og saksbehandleren får
      # beskjed. Grunnlag med aldersgrense filtreres ikke bort. Kode i dag: grunnlaget avvises,
      # men FS Admin viser bare at grunnlaget ikke kunne endres.
      Gitt at regelverket har et grunnlag med aldersgrensen under 22 år
      Og at opptaket ikke har dato for aldersberegning eller dato for publisering av resultatet
      Når saksbehandleren velger grunnlaget for saken
      Så får saksbehandleren beskjed om at opptaket mangler dato for aldersberegning
      Og grunnlaget er ikke lagt til

    Scenario: Grunnlag uten aldersgrense kan legges til når opptaket mangler dato for aldersberegning
      # Avklart 09.11.2026: datoen kreves bare når grunnlaget som velges, har aldersgrense.
      # Kode i dag: datoen kreves så snart ett grunnlag i opptaket har aldersgrense.
      Gitt at opptaket ikke har dato for aldersberegning eller dato for publisering av resultatet
      Når saksbehandleren velger et grunnlag uten aldersgrense for saken
      Så er grunnlaget lagt til

  @ref-OPT-BEH-BEH-028 @implemented
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
