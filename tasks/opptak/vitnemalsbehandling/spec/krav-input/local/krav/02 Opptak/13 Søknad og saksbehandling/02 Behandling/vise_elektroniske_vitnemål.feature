# language: no
# GitHub: #613
#
# KILDER OG ETTERPRØVBARHET
#
# Skilt ut fra vitnemålsbehandling.feature (@OPT-BEH-BEH-004) 23.09.2026 som
# leveranse L1 av seks i initiativet #607 Vitnemålsbehandling. Parent-featuren
# beholder L2–L6 og står fortsatt som @draft, fordi leveransekuttet for dem
# ikke er besluttet. L1 er besluttet, og kravteksten for den er ferdig.
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
# og hentKompetansebevis. Integrasjonen finnes allerede, så denne leveransen
# er i hovedsak presentasjon.
#
# AVGRENSNING MOT SENERE LEVERANSER
#
# Ingen valg og ingen beregning. Saksbehandleren ser hva søkeren har, og
# slipper å slå opp i FS-klienten. Å legge et vitnemål til grunn hører i L2
# (#608), fagvalg per poengvariant i L3 (#609), manuell inntasting av fag i L4
# (#610), sammenligning av vitnemål i L5 (#611) og varsel ved nytt vitnemål
# fra NVB i L6 (#612).
#
# Tilgangsregelen er snevret til det denne leveransen kan innfri: innsyn. At
# endringsrettighet gir mulighet til å *behandle* vitnemålet, og at
# leserettighet skjuler den muligheten, kan ikke verifiseres før det finnes
# noe å endre. De to scenarioene følger L2 og står fortsatt i
# vitnemålsbehandling.feature.
#
# Resultater fra høyere utdanning er utenfor. De finnes i dag bare som en
# umodellert JSON-streng fra Vitnemålsportalen (Soker.vitnemal: String, i
# ELMO-format, se VitnemalService i opptak-service). Initiativ #319 slår fast
# at «høyere utdanning er ikke viktig for 2026».
#
# BEGREPSBRUK
#
# Denne featuren kaller seksjonen «vitnemålsoversikten», fordi den i L1 bare
# viser. Fra L2 får samme seksjon valg, og vitnemålsbehandling.feature kaller
# den da «vitnemålsbehandlingen». Bør samordnes når L2 planlegges.
#
# UI-detaljer. Plassering, accordion-oppførsel, kolonnebredder og
# vindushåndtering hører i vise_elektroniske_vitnemål.design.md, jf.
# utdype-implementasjon-skillen.
#
@OPT-BEH-BEH-005 @must @planned
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

  Regel: Søkerens elektroniske vitnemål vises

    Scenario: Se at søkeren har elektroniske vitnemål
      Gitt søkeren har elektroniske vitnemål
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg hvor mange elektroniske vitnemål søkeren har
      Men vitnemålsoversikten er ikke åpnet

    Scenario: Åpne vitnemålsoversikten
      Gitt søkeren har to elektroniske vitnemål
      Når jeg åpner vitnemålsoversikten
      Så ser jeg hvert vitnemål med følgende opplysninger
        | felt                |
        | Utstedelsesdato     |
        | Dokumenttype        |
        | Status              |
        | Førstegangsvitnemål |
        | Reform              |
        | Dispensasjon        |
        | Påstand om GSK      |
      # AVKLART 21.09.2026: dispensasjon og påstand om GSK vises som del av
      # vitnemålets opplysninger, selv om selve GSK-vurderingen er avgrenset
      # ut av initiativet. Begrunnelse: de er kontekst for hvilket vitnemål som
      # bør legges til grunn, og saksbehandleren skal slippe å bytte
      # skjermbilde for å se dem.
      #
      # Feltene er verifisert mot NVB_VGDOK og mot KREG-spørringen
      # hentKompetansebevis: datoUtstedt, vgdoktypekode, status, foerstegangsvm,
      # reformkode, dispensasjonskode og paastandOmGsk.

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
      # alltid skal være åpent står i vitnemålsbehandling.feature, og må
      # innfris sammen med skjemaet.

    Scenario: Åpne et vitnemål i eget vindu
      Gitt søkeren har elektroniske vitnemål
      Når jeg velger å åpne et vitnemål i eget vindu
      Så vises vitnemålet i et eget vindu ved siden av saksbehandlingen
      # Formålet er å kunne lese vitnemålet mens saksbehandlingen står åpen,
      # eventuelt på en ekstern skjerm.

    Scenario: Annullert vitnemål som er brukt i en beregning vises
      Gitt søkeren har et annullert vitnemål
      Og det annullerte vitnemålet er brukt i en beregning på dette opptaket
      Når jeg åpner vitnemålsoversikten
      Så ser jeg det annullerte vitnemålet tydelig markert som annullert
      # At et annullert vitnemål ikke kan legges til grunn for en ny beregning
      # er en konsekvens av valget, og hører derfor i L2 (#608). Den
      # begrensningen står fortsatt i vitnemålsbehandling.feature.

    Scenario: Vitnemål uten relevans for opptaket vises ikke
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
