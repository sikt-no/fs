# language: no
#
# Grovutkast 21.10.2026. Kildene er samlet, men ingen regel er gjennomgått med
# produkteier eller Team Puff. Reglene bygger på dagens FS-klient, koden i ny
# stack og brukerhistoriene i Confluence. Følg «Krav fra kode, skisser eller
# FS-klienten» i krav/README.md i valideringen: for hver regel må det avklares
# om det er ønsket atferd, eller bare slik koden er.
#
# Føring: Det nye skal fungere slik det fungerer i FS-klienten i dag. Den
# automatiske settingen brukes sammen med den manuelle, der saksbehandleren
# legger til og fjerner grunnlag i steget «Grunnlag».
#
# ÅPNE SPØRSMÅL:
# - Hvilket «grunnlag» gjelder saken? Kravet bygger på kvalifikasjonsgrunnlaget
#   på saken (VOV, VES, PRA osv.), som styrer kvalifisering, rangering og
#   kvoter. Det er det FOL-34, STEK-296 og koden kaller «automatisk setting av
#   grunnlag». Grunnlagskoden i GSK-konklusjonen (AØA, KLS osv.) settes
#   automatisk i automatisk_gsk_konklusjon.feature. Gjelder saken også den, er
#   det så langt dette utkastet kom.
#
# KILDER
#
# Jira: FOL-34 (initiativet, akseptansetest 30.11.2026, peker på
# @OPT-REG-GRU-001), STEK-296 (epic) med STEK-297 (regelen), STEK-298 (låsing
# og endringslogg) og STEK-299 (egenskapene på grunnlaget i fs-admin),
# STEK-514 (bare ett grunnlag, backlog), STEK-454, STEK-430, STEK-315,
# STEK-317, STEK-505, STEK-583, STEK-280.
#
# Confluence PFS: 4460740612 «Brukerhistorier automatisk valg av grunnlag»,
# 4453629977 «2026-03-11 Raffinering automatisk valg av grunnlag», 4022829198
# «Automatisere valg av grunnlag» (eksempler for VOV, VES, VPL, PRA og BCH),
# 4986798081 «Endring i hvordan kvote og grunnlag henger sammen», 5108858885
# «Status søknadsbehandling – utkast 15.10.2026». «Forretningsregler –
# Grunnlag» er en tom mal.
#
# GitHub: #199, kriteriet «Systemet skal automatisk velge hvilke grunnlag
# søknaden skal behandles ut fra». Det finnes ingen egen issue.
#
# FS-klienten (gitlab.sikt.no/fs/fs-klient): «Godkjenn VM» i vitnemålsrammen i
# Søknad samlebilde (w_soknad_saml.srw:5020–5118, pk_opptakvtm.p_godkjennvtm)
# og rutinen FS158.001 (wr_fs158_001.srw, pk_fs158001) setter
# kvalifikasjonsgrunnlaget sammen med poengene. Regelen ligger i PL/SQL.
# Søkeren kan ha flere grunnlag (PERSONKVALGRUNNLAG), og bare noen
# kombinasjoner er forbudt (ULOVLIGEKVALGRUNNLAG: VOV+VOT, VES+VPL). Grunnlaget
# ligger på personen. Studieprogrammet kan ha et grunnlag som settes når
# søknadsalternativet opprettes («Aut.kvalgrunnlag»,
# OPPTAKSTUDIEPROGRAM.KVALGRUNNLAGKODE_AUTOMATISK). FS-klienten har ingen
# låsing, men FS158.001 hopper over søknader der «Kan saksbehandles» er satt.
#
# Ny stack: SetteGrunnlagService i opptak-service (fs-plattform), kalt fra
# behandleSakAutomatisk etter GSK-konklusjonen. Manuelt: leggTilGrunnlag og
# fjernGrunnlag (LeggTilGrunnlagService, FjernGrunnlagService). I fs-admin er
# steget «Grunnlag» (GrunnlagCard) en avkrysningsliste uten markering av hva
# som er satt automatisk, og uten rollesjekk.
#
# AVGRENSNING
#
# - Hvilke grunnlag som finnes, og egenskapene deres, settes opp i regelverket
#   (grunnlag.feature).
# - GSK-konklusjonen settes i automatisk_gsk_konklusjon.feature.
# - Poengene beregnes i automatisk_poengberegning.feature (@OPT-BEH-BEH-018).
# - Kvoteplasseringen står i automatisk_kvoteplassering.feature.
# - Søkere med flere vitnemål får vitnemålet valgt av saksbehandleren i
#   vitnemålsbehandlingen.
@OPT-BEH-BEH-019 @must @draft @ref-OPT-BEH-BEH-012 @ref-OPT-BEH-BEH-015 @ref-OPT-BEH-BEH-018
Egenskap: Automatisk grunnlag
  Som saksbehandler
  ønsker jeg at søknaden får grunnlaget sitt automatisk når søkerens vitnemål og alder avgjør det
  slik at jeg bare trenger å velge grunnlag der det ikke er entydig.

  Grunnlaget avgjør hvilke opptakskrav søknaden vurderes mot, hvordan søkeren
  rangeres, og hvilke kvoter søkeren kan plasseres i. Har søkeren ett
  elektronisk vitnemål med påstanden at søkeren har GSK, eller har
  saksbehandleren valgt ett av vitnemålene, velger systemet grunnlaget ut fra
  vitnemålet og søkerens alder. Hvilke grunnlag som kan
  velges automatisk, og hva som skal til, bestemmes av egenskapene
  regelverksbyggeren har gitt grunnlaget i regelverket.

  Grunnlag som saksbehandleren har valgt, endres aldri av automatikken. Det
  fremgår om et grunnlag er satt automatisk eller av saksbehandleren.

  # ÅPNE SPØRSMÅL:
  # - Skal grunnlaget ligge på saken eller på søknaden? FS-klienten har det på
  #   personen. Spørsmålet ble tatt opp i raffineringen og med HK-dir 16.03.2026.
  # - Skal et studieønske som fjernes, også fjerne grunnlaget det ga (STEK-505)?

  @depends-on-OPT-REG-GRU-001
  Regel: Grunnlaget velges ut fra egenskapene regelverket har gitt det
    # Egenskapene er aldersgrense, «krever et vitnemål» og «krever
    # førstegangsvitnemål». Koden kjenner ingen grunnlagskoder.

    @openquestion
    Scenariomal: Grunnlag ut fra alder og førstegangsvitnemål
      # ÅPNE SPØRSMÅL:
      # - Hvor går aldersgrensen for VOV? Confluence (PFS 4022829198) sier at
      #   22 år med førstegangsvitnemål gir VES. Dokumentasjonen til
      #   FS-klienten sier at VOV gjelder til og med 22 år.
      Gitt at søknadsalternativenes regelverk har grunnlagene "VOV" og "VES"
      Og at grunnlaget "VOV" krever førstegangsvitnemål og har en aldersgrense
      Og at grunnlaget "VES" krever et vitnemål
      Og at søkeren har ett elektronisk vitnemål med påstanden at søkeren har GSK
      Og at vitnemålet <er førstegangsvitnemål>
      Og at søkeren er <alder> år på datoen for aldersberegning
      Når søknaden behandles automatisk
      Så får søknaden grunnlaget "<grunnlag>"

      Eksempler:
        | er førstegangsvitnemål      | alder | grunnlag |
        | er førstegangsvitnemål      | 21    | VOV      |
        | ikke er førstegangsvitnemål | 21    | VES      |
        | er førstegangsvitnemål      | 22    | VES      |

    Scenario: Bare grunnlag i søknadsalternativenes regelverk kan settes
      Gitt at søkeren har ett elektronisk vitnemål med påstanden at søkeren har GSK
      Og at et grunnlag som passer søkeren, ikke er med i regelverket til noen av søknadsalternativene
      Når søknaden behandles automatisk
      Så får ikke søknaden grunnlaget som ikke er med i regelverket

    Scenario: Grunnlag uten egenskaper for automatikken settes ikke automatisk
      # PRA, REA, VPL og BCH velges av saksbehandleren.
      Gitt at søknadsalternativenes regelverk har et grunnlag uten aldersgrense, uten krav om vitnemål og uten krav om førstegangsvitnemål
      Når søknaden behandles automatisk
      Så får ikke søknaden grunnlaget uten egenskaper for automatikken

    Scenario: Førstegangsvitnemål går foran
      Gitt at søkeren passer til et grunnlag som krever førstegangsvitnemål
      Og at søkeren også passer til et grunnlag som bare krever et vitnemål
      Når søknaden behandles automatisk
      Så får søknaden grunnlaget som krever førstegangsvitnemål

    @openquestion
    Scenario: Flere grunnlag passer like godt
      # ÅPNE SPØRSMÅL:
      # - Ny stack velger grunnlaget med lavest kode alfabetisk, og logger en
      #   advarsel. Er det ønsket, eller skal ingen settes, eller alle?
      Gitt at søkeren passer like godt til to grunnlag
      Når søknaden behandles automatisk
      Så får søknaden ett av grunnlagene

  @openquestion
  Regel: Søknaden kan få flere grunnlag
    # ÅPNE SPØRSMÅL:
    # - FS-klienten gir søkeren flere grunnlag, og forbyr bare noen
    #   kombinasjoner (VOV med VOT, VES med VPL). Ny stack setter alltid ett.
    #   Fagfolkene vil at førstegangsvitnemål skal gi både VOV og VES
    #   (STEK-514). Hvilke kombinasjoner er gyldige, og hvor settes de opp?
    # - Svaret må stemme med «Førstegangsvitnemål går foran» og den første raden i
    #   «Grunnlag ut fra alder og førstegangsvitnemål», som i dag gir bare VOV.

    Scenario: Søker med førstegangsvitnemål får både "VOV" og "VES"
      Gitt at søknadsalternativenes regelverk har grunnlagene "VOV" og "VES"
      Og at søkeren har ett elektronisk førstegangsvitnemål med påstanden at søkeren har GSK
      Og at søkeren er innenfor aldersgrensen for "VOV"
      Når søknaden behandles automatisk
      Så får søknaden grunnlagene "VOV" og "VES"

    Scenario: Grunnlag som ikke kan kombineres, settes ikke sammen
      Gitt at to grunnlag ikke kan kombineres
      Når søknaden behandles automatisk
      Så får ikke søknaden begge grunnlagene

  Regel: Ingen automatisk grunnlag uten ett entydig vitnemål

    Scenariomal: Ingen grunnlag settes automatisk når <grunn>
      Gitt at <grunn>
      Når søknaden behandles automatisk
      Så får søknaden ingen grunnlag automatisk

      Eksempler:
        | grunn                                                                                                       |
        | søkeren har flere elektroniske vitnemål som ikke er annullert, og saksbehandleren har ikke valgt ett av dem |
        | søkerens eneste elektroniske dokument er et kompetansebevis                                                 |
        | vitnemålet har påstanden at søkeren ikke har GSK                                                            |
        | søkeren ikke har noe elektronisk vitnemål                                                                   |
        | ingen av grunnlagene i regelverket passer søkeren                                                           |

    @ref-OPT-BEH-BEH-025
    Scenario: Grunnlag fra vitnemålet saksbehandleren har valgt
      # Avklart 2026-10-26 i review av PR #818: har saksbehandleren valgt vitnemålet, behandles
      # saken automatisk på det.
      Gitt at søkeren har to elektroniske vitnemål med påstanden at søkeren har GSK, ett fra 2024 og ett fra 2025
      Og at saksbehandleren har valgt vitnemålet fra 2025
      Når søknaden behandles automatisk
      Så får søknaden grunnlaget ut fra vitnemålet fra 2025

  @openquestion
  Regel: Når grunnlaget settes
    # ÅPNE SPØRSMÅL:
    # - Når skal grunnlaget settes automatisk? Det kan følge de samme
    #   anledningene som poengberegningen: når søknaden kommer inn med
    #   elektronisk vitnemål, når søkeren får vitnemål innen
    #   ettersendingsfristen, eller når saksbehandleren starter den automatiske
    #   behandlingen for én eller flere søknader. I dag starter
    #   saksbehandleren den med «Start automatisk behandling» for én søknad.
    # - FS-klienten kan sette et grunnlag fra studieprogrammet når
    #   søknadsalternativet opprettes («Aut.kvalgrunnlag»). Skal det
    #   videreføres?

    Scenario: Saksbehandleren starter den automatiske behandlingen
      Gitt at søkeren har ett elektronisk vitnemål med påstanden at søkeren har GSK
      Når saksbehandleren starter den automatiske behandlingen for søknaden
      Så får søknaden grunnlaget automatisk

    Scenario: Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes
      Gitt at utdanningstilbudet har et grunnlag som skal settes automatisk
      Når søkeren søker på utdanningstilbudet
      Så får søknaden grunnlaget fra utdanningstilbudet

  Regel: Grunnlag som saksbehandleren har valgt, endres ikke av automatikken

    Scenario: Grunnlag som saksbehandleren legger til, låser grunnlagene
      Gitt at søknaden har grunnlag som er satt automatisk
      Når saksbehandleren legger til et grunnlag
      Så er grunnlagene på søknaden låst mot automatikken

    Scenario: Automatikken setter ikke grunnlag på en låst sak
      Gitt at saksbehandleren har lagt til et grunnlag på søknaden
      Når søknaden behandles automatisk
      Så er grunnlagene på søknaden uendret

    Scenario: Automatikken fjerner aldri grunnlag
      Gitt at søknaden har et grunnlag
      Og at søkeren ikke lenger passer til grunnlaget
      Når søknaden behandles automatisk
      Så har søknaden fortsatt grunnlaget

    Scenario: Saksbehandleren endrer grunnlag som er satt automatisk
      Gitt at søknaden har et grunnlag som er satt automatisk
      Når saksbehandleren fjerner grunnlaget
      Så har ikke søknaden lenger grunnlaget

    @openquestion
    Scenario: Gjøre søknaden tilgjengelig for automatikken igjen
      # ÅPNE SPØRSMÅL:
      # - Ny stack har ingen måte å låse opp grunnlagene på. Raffineringen
      #   spurte hvordan en sak settes tilbake slik at den kan behandles
      #   automatisk igjen. Trengs det?
      Gitt at grunnlagene på søknaden er låst mot automatikken
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

  Regel: Når grunnlaget endres, vurderes søknaden på nytt

    Scenario: Kvalifisering, poeng og kvoter vurderes på nytt
      Gitt at søknaden har et grunnlag
      Når grunnlaget på søknaden endres
      Så er opptakskravene vurdert på nytt mot grunnlagene
      Og poengene og kvotene er oppdatert etter grunnlagene

  Regel: Sporbarhet

    Scenario: Se at grunnlaget er satt automatisk
      # I fs-admin ser et grunnlag som er satt automatisk, likt ut som et
      # grunnlag saksbehandleren har valgt.
      Gitt at søknaden har fått grunnlaget automatisk
      Når saksbehandleren ser på grunnlagene
      Så ser saksbehandleren at grunnlaget er satt automatisk
      Og saksbehandleren ser hvorfor grunnlaget ble valgt

    Scenario: Endringsloggen viser at automatikken satte grunnlaget
      Gitt at søknaden har fått grunnlaget automatisk
      Når saksbehandleren ser i endringsloggen
      Så ser saksbehandleren at grunnlaget ble satt av den automatiske behandlingen
