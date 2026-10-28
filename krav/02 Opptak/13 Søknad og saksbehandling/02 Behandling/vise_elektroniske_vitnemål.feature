# language: no
# GitHub: #613
#
# KILDER OG ETTERPRØVBARHET
#
# Skilt ut fra vitnemålsbehandling.feature (@OPT-BEH-BEH-004) 23.09.2026 som
# leveranse L1 av seks i initiativet #607 Vitnemålsbehandling. 08.10.2026 ble
# også L2–L6 delt i hver sin kravspesifikasjon, og vitnemålsbehandling.feature
# ble erstattet av dem. Oversikten over leveransene, kildene og
# avgrensningene står i vitnemålsbehandling.md i samme mappe.
#
# Kravet dekker visning av søkerens elektroniske VGS-vitnemål i FS Admin,
# steg 2 «Grunnlag». Det erstatter oversiktsdelen av vitnemålsbehandling
# (FS143.001 Vg.dokument, w_vitnemalsbehandling.srw) i fsb10c,
# gitlab.sikt.no/fs/fs-klient. Referanser til tabeller, kolonner og
# tjenesteklasser står her for at påstandene skal kunne etterprøves — aldri
# som føring for datamodell eller teknologi.
#
# Designgrunnlag: Confluence PFS 4582014995 «Vitnemål og kvalifikasjoner
# (Steg 2 - sekvensiell saksbehandling)», med designskisser i Figma
# (FS-Admin - Seksjon Opptak, node 10119-38734). Jira-initiativ SOPP-184.
#
# Ny stack: VGS-resultatene kommer fra KREG/NVB — kompetansebevisByNasjonalId
# og hentKompetansebevis. Integrasjonen finnes allerede. Poengene per
# vitnemål (karakterpoeng, realfagspoeng og språkpoeng) beregnes av
# poengberegningen i opptak, den samme som i den automatiske poengberegningen
# (automatisk_poengberegning.feature). Den må kunne beregne poeng for hvert
# vitnemål, ikke bare for det som er lagt til grunn. AVKLART 21.10.2026:
# poengene per vitnemål er med i L1.
#
# AVGRENSNING MOT SENERE LEVERANSER
#
# Ingen valg. Saksbehandleren ser hva søkeren har, med poengene hvert
# vitnemål gir, og slipper å slå opp i FS-klienten. Å legge et vitnemål til grunn hører i L2
# (#608), fagvalg per poengvariant i L3 (#609), manuell inntasting av fag i L4
# (#610), sammenligning av vitnemål i L5 (#611) og varsel ved nytt vitnemål
# fra NVB i L6 (#612).
#
# Tilgangsregelen er snevret til det denne leveransen kan innfri: innsyn. At
# endringsrettighet gir mulighet til å *behandle* vitnemålet, og at
# leserettighet skjuler den muligheten, kan ikke verifiseres før det finnes
# noe å endre. De to scenarioene følger L2 og står i
# velge_vitnemål_som_grunnlag.feature.
#
# Resultater fra høyere utdanning er utenfor. De finnes i dag bare som en
# umodellert JSON-streng fra Vitnemålsportalen (Soker.vitnemal: String, i
# ELMO-format, se VitnemalService i opptak-service). Initiativ #319 slår fast
# at «høyere utdanning er ikke viktig for 2026».
#
# BEGREPSBRUK
#
# Denne featuren kaller seksjonen «vitnemålsoversikten», fordi den i L1 bare
# viser. Fra L2 får samme seksjon valg, og kravene for L2–L6 kaller den da
# «vitnemålsbehandlingen». Bør samordnes når L2 planlegges.
#
# UI-detaljer. Plassering, accordion-oppførsel, kolonnebredder og
# vindushåndtering hører i vise_elektroniske_vitnemål.design.md, jf.
# fs-implementasjonsdetaljer-skillen.
#
@OPT-BEH-BEH-005 @must @in-progress
Egenskap: Se søkerens elektroniske vitnemål
  Som saksbehandler i opptak
  ønsker jeg å se hvilke elektroniske vitnemål søkeren har
  slik at jeg kan vurdere grunnlaget uten å slå opp i FS-klienten.

  De fleste søknader trenger ingen vitnemålsbehandling: har søkeren ett
  elektronisk vitnemål uten forbedringer, klarer automatikken seg selv.
  Oversikten er derfor lukket som standard, med en teller som viser hvor mange
  elektroniske vitnemål søkeren har. Telleren er det saksbehandleren trenger
  for å se om saken er en av dem som krever et nærmere blikk.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg er inne på søknaden til en søker

  @ref-OPT-BEH-BEH-018
  Regel: Søkerens elektroniske vitnemål vises
    # Poengene per vitnemål beregnes som i den automatiske poengberegningen.

    @implemented
    Scenario: Se at søkeren har elektroniske vitnemål
      Gitt søkeren har elektroniske vitnemål
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg hvor mange elektroniske vitnemål søkeren har
      Men vitnemålsoversikten er ikke åpnet

    @implemented
    Scenario: Åpne vitnemålsoversikten
      Gitt søkeren har to elektroniske vitnemål
      Når jeg åpner vitnemålsoversikten
      Så ser jeg hvert vitnemål med følgende opplysninger
        | felt                |
        | Vitnemålsnummer     |
        | Utstedelsesdato     |
        | GSK                 |
        | Førstegangsvitnemål |
        | Karakterpoeng       |
        | Realfagspoeng       |
        | Språkpoeng          |
      Og vitnemålene er sortert etter utstedelsesdato, fra eldste til nyeste
      # AVKLART 22.10.2026: alle vitnemålene sorteres kronologisk, etter
      # utstedelsesdato. Erstatter avklaringen fra 21.10.2026 om at
      # førstegangsvitnemålet skulle stå først. Domeneekspertene påpekte at
      # førstegangsvitnemålet så å si alltid kommer først uansett.
      #
      # AVKLART 21.10.2026: opplysningene er vitnemålsnummer, utstedt dato,
      # GSK, førstegangsvitnemål (ja/nei), karakterpoeng, realfagspoeng og
      # språkpoeng, som i tabellen «Vitnemål» i Figma-målbildet.
      # Vitnemålsnummeret gjør at vitnemålet kan kjennes igjen. Dokumenttype,
      # status, reform og dispensasjon er tatt ut. At et annullert vitnemål
      # markeres, gjelder fortsatt («Annullert vitnemål som er brukt i en
      # beregning vises»).
      #
      # AVKLART 21.09.2026 (delvis erstattet 21.10.2026, dispensasjon vises
      # ikke lenger): dispensasjon og påstand om GSK vises som del av
      # vitnemålets opplysninger, selv om selve GSK-vurderingen er avgrenset
      # ut av initiativet. Begrunnelse: de er kontekst for hvilket vitnemål som
      # bør legges til grunn, og saksbehandleren skal slippe å bytte
      # skjermbilde for å se dem.
      #
      # Feltene fra vitnemålet er verifisert mot NVB_VGDOK og mot
      # KREG-spørringen hentKompetansebevis: datoUtstedt, foerstegangsvm og
      # paastandOmGsk. Poengene per vitnemål beregnes av poengberegningen i
      # opptak, ikke hentet fra KREG.

    @implemented
    Scenario: Søker uten elektroniske vitnemål
      Gitt søkeren ikke har elektroniske vitnemål
      Når jeg åpner grunnlaget på søknaden
      Så vises ikke vitnemålsoversikten
      # AVKLART: fra Confluence — «Dersom det ikke finnes tilgjengelige
      # elektroniske vitnemål skal ikke modul for vitnemål vises. MEN, da skal
      # også skjemaet for manuell utfylling alltid vises.»
      #
      # Andre halvdel av kravet er holdt utenfor denne leveransen: skjemaet for
      # å legge inn fag manuelt bygges i L4 (#610). Kravet om at skjemaet da
      # alltid skal være åpent står i legge_inn_og_endre_fag.feature, og må
      # innfris sammen med skjemaet.

    Scenario: Vitnemålene kan ikke hentes
      Gitt søkerens elektroniske vitnemål ikke kan hentes fra NVB
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg en tydelig feilmelding om at vitnemålene ikke kunne hentes
      # AVKLART 21.10.2026: når vitnemålene ikke kan hentes, skal
      # saksbehandleren få en tydelig feilmelding. Det skal ikke se ut som at
      # søkeren ikke har elektroniske vitnemål («Søker uten elektroniske
      # vitnemål»).
      #
      # Vitnemålene hentes fra KREG/NVB i en jobb når saken opprettes, ikke
      # når saksbehandleren åpner søknaden. Feiler hentingen, må det tas vare
      # på, så oversikten kan vise at vitnemålene ikke kunne hentes, og ikke
      # bare at søkeren ikke har noen. Utformingen av feilmeldingen hører i
      # vise_elektroniske_vitnemål.design.md.

    Scenario: Poeng som ikke kan beregnes, vises tomme
      Gitt søkeren har et elektronisk vitnemål som ikke gir poeng
      Når jeg åpner vitnemålsoversikten
      Så ser jeg vitnemålet med opplysningene fra vitnemålet
      Men karakterpoeng, realfagspoeng og språkpoeng vises tomme
      # AVKLART 28.10.2026: erstatter «Feilmelding når poengberegningen ikke
      # svarer». Poengberegningen er en del av opptak, ikke en ekstern
      # tjeneste som kan la være å svare, så feilmeldingen er tatt ut. Et
      # vitnemål som ikke gir poeng (f.eks. med ugyldige karakterer), vises
      # likevel, med tomme poeng.

    @implemented
    Scenario: Åpne et vitnemål i ny fane
      Gitt søkeren har elektroniske vitnemål
      Når jeg velger å åpne et vitnemål i ny fane
      Så vises vitnemålet i en ny fane
      Og saksbehandlingen står fortsatt åpen
      # Formålet er å kunne lese vitnemålet mens saksbehandlingen står åpen.
      #
      # AVKLART 21.10.2026: vitnemålet åpnes i en ny fane, ikke i et eget
      # vindu ved siden av saksbehandlingen.

    Scenario: Annullert vitnemål som er brukt i en beregning vises
      Gitt søkeren har et annullert vitnemål
      Og det annullerte vitnemålet er brukt i en beregning på dette opptaket
      Når jeg åpner vitnemålsoversikten
      Så ser jeg det annullerte vitnemålet tydelig markert som annullert
      # At et annullert vitnemål ikke kan legges til grunn for en ny beregning
      # er en konsekvens av valget, og hører derfor i L2 (#608),
      # velge_vitnemål_som_grunnlag.feature.
      #
      # AVKLART 28.10.2026 (Kari): eksempel. Søkeren har ett vitnemål, og
      # det er brukt i en beregning på saken. Senere kommer et nytt vitnemål,
      # og det første blir annullert. Da vises det første som annullert. Et
      # annullert vitnemål som aldri er brukt i en beregning, vises ikke.
      #
      # «Brukt i en beregning» betyr at vitnemålet er grunnlaget for et
      # poeng på saken (vitnemålsnummeret på poenget), enten poenget er
      # beregnet automatisk eller lagt til grunn av saksbehandleren.
      #
      # Varselet til saksbehandleren når et vitnemål som er brukt, blir
      # annullert, er ikke med i L1. Det finnes ingen skisse for markeringen
      # ennå. Utformingen hører i vise_elektroniske_vitnemål.design.md.

    @implemented
    Scenario: Annullert vitnemål som ikke er brukt i en beregning vises ikke
      Gitt søkeren har et annullert vitnemål
      Og det annullerte vitnemålet er ikke brukt i en beregning på dette opptaket
      Når jeg åpner vitnemålsoversikten
      Så vises ikke det annullerte vitnemålet
      # AVKLART 21.09.2026: relevans avgjøres av om vitnemålet har vært brukt i
      # en beregning på opptaket saksbehandleren jobber på. Et annullert
      # vitnemål som ligger til grunn for et tall saksbehandleren ser, må
      # være synlig — ellers kan ikke tallet forstås eller etterprøves. Gamle
      # vitnemål som aldri har vært i bruk i dette opptaket er bare støy.
      #
      # Verifisert i FS-klienten: dm_person_v_vitnemaal2 beregner
      # «godkjentbehandling = decode(vgdokstatuskode,'A',0,1)». Status A er
      # ikke til behandling, men FS-klienten skjuler ikke raden. Regelen over
      # er strammere: den skjuler også raden når den ikke har vært i bruk.
      #
      # Merk at GskAnnulleringUtenAnnullertVitnemaalError i gsk.graphqls
      # forutsetter at saksbehandleren kan se at et vitnemål er annullert.
      # Regelen over holder det synlig i nettopp de tilfellene feilen kan
      # oppstå.

  @implemented
  Regel: Innsyn styres av rettighet, ikke av hvem som har tatt saken

    Scenario: Saksbehandler med leserettighet ser søkerens vitnemål
      Gitt jeg kan se søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg søkerens elektroniske vitnemål

    Scenario: Bruker uten lesetilgang ser ikke vitnemålsoversikten
      Gitt jeg ikke kan se søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg ikke vitnemålsoversikten

    Scenario: Saken er tilordnet en annen saksbehandler
      Gitt saken er tilordnet en annen saksbehandler
      Og jeg kan se søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg søkerens elektroniske vitnemål
      # AVKLART 21.09.2026: tilgang styres av rettighet og organisasjon, ikke
      # av tilordning.
      #
      # Verifisert i ny stack: autorisasjon er SE_SØKNADSBEHANDLING og
      # MODIFISERE_SØKNADSBEHANDLING (Handling.java), håndhevet via
      # auth.har_tilgang og RLS. Tilordning er en egen mekanisme
      # (tilordneSaksbehandlerV3, fjernTilordnetSaksbehandler) for
      # arbeidsfordeling. Ingen tjeneste i opptak-service sjekker tilordnet
      # bruker før en endring — søk over hele tjenestelaget finner ingen slik
      # sjekk utenfor TilordningService selv.
      #
      # Kravet innfører derfor ikke tilordning som tilgangsgrense. Skulle det
      # bli ønsket senere, er det en utvidelse av autorisasjonsmodellen og
      # hører i et eget krav.
      #
      # At lesetilgang gir innsyn er i tråd med design-patterns-for-krav.md:
      # det er *muligheten til å endre* som skjules, ikke opplysningene. En
      # saksbehandler som ser et poeng må kunne se hva det bygger på.
