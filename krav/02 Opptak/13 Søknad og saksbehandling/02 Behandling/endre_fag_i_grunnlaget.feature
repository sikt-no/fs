# language: no
# GitHub: #610
#
# Leveranse L4a i initiativet #607 Vitnemålsbehandling. Skilt ut fra
# vitnemålsbehandling.feature 08.10.2026. Kilder, bakgrunn, avgrensninger og
# oversikten over leveransene står i vitnemålsbehandling.md i samme mappe.
#
# Delt i to 03.11.2026, i gjennomgangen av L3 og L4 med teamet: denne fila
# (L4a «Endre fag», tidligere legge_inn_og_endre_fag.feature) leveres først,
# og manuell inntasting av fag og vitnemål er flyttet til L4b
# (legge_inn_vitnemål_manuelt.feature, @OPT-BEH-BEH-037). Ingen av dem kan
# kuttes.
#
# Bygger på L2 og L3. Reglene for beregning og lagring i L2 («Poengene
# beregnes og lagres når saksbehandleren bruker dem») gjelder også her
# (avklart 03.11.2026, endret 11.11.2026): saksbehandleren beregner poengene
# uten å lagre, og grunnlaget kontrolleres, poengene beregnes og alt lagres
# når saksbehandleren velger å bruke poengene. Endringer hører til
# vitnemålet de er gjort for. Regelen for leserettighet står i
# vitnemålsbehandling.md.
#
# Feature-ID-en er endret fra @OPT-BEH-BEH-008 til @OPT-BEH-BEH-023, fordi
# søknadsmangler.feature også bruker 008 (26.10.2026).
#
@OPT-BEH-BEH-023 @must @planned
Egenskap: Endre fag i grunnlaget
  Som saksbehandler i opptak
  ønsker jeg å legge til og endre fag slik reglene tillater
  slik at søkere med kompetansebevis, forbedringer eller fritak blir riktig poengberegnet.

  Ikke alt grunnlaget står riktig på det elektroniske vitnemålet. Noen fag
  står på et kompetansebevis, er forbedret, er ført som fritatt, eller
  overlapper med fag på et annet dokument. Saksbehandleren kan legge til og
  endre slike fag, men bare slik en regel tillater. Saksbehandleren kan ikke
  sette sammen et vitnemål søkeren ikke har. Fag som bare finnes i opplastet
  dokumentasjon, legges inn i L4b (legge_inn_vitnemål_manuelt.feature).

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg er inne på søknaden til en søker

  Regel: Saksbehandleren kan bare legge til og endre fag slik en regel tillater

    # AVKLART 07.10.2026: vitnemålsbehandleren håndhever at grunnlaget bare
    # endres etter faste regler. Det er de videregående skolene som utsteder
    # vitnemål og avgjør hva som oppfyller vitnemålskravene. Saksbehandleren
    # kan ikke sette sammen et grunnlag søkeren kunne hatt. Vil søkeren ha en
    # annen fagsammensetning, må søkeren kontakte skolen.
    #
    # Der regelen krever en vurdering av dokumentasjonen, er det
    # saksbehandleren som vurderer, og løsningen som håndhever utfallet.
    #
    # Regelen er delt mellom L3 og L4 (besluttet 08.10.2026): her står
    # tillegg og endringer i karakterer. Grensene for fagvalget står i
    # velge_fag_per_poengvariant.feature.

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenario: Fag som overlapper med påbygging, legges inn som forbedring
      Gitt søkeren har et yrkesfaglig vitnemål
      Og søkeren har påbygging til generell studiekompetanse på et kompetansebevis
      Og jeg har vurdert at et fag i påbyggingen overlapper med et fag på vitnemålet
      Når jeg legger inn karakteren fra påbyggingen som forbedring på faget på vitnemålet
      Så teller karakteren fra påbyggingen i stedet for den tidligere karakteren
      # AVKLART 12.11.2026 (gjennomgang med domeneekspertene): fag som
      # overlapper med påbyggingen, strykes ikke. Saksbehandleren legger
      # karakteren inn som forbedring på faget på vitnemålet. Hvilke fag som
      # overlapper, også timetallene for matematikk (224) og naturfag (140), er
      # saksbehandlerens vurdering. Erstatter «Stryke et fag som overlapper med
      # påbygging på kompetansebevis» og avklaringen 03.11.2026 om at fagene
      # fra påbyggingen legges inn under tilleggsfag.
      #
      # AVKLART 07.10.2026: hvilke fag som overlapper, er saksbehandlerens
      # vurdering, fordi reglene har mange unntak. Hovedreglene: norsk
      # hentes fra kompetansebeviset. Matematikk og naturfag hentes fra
      # kompetansebeviset bare når faget er ført med henholdsvis 224 og 140
      # timer samlet der.

    Scenario: Legge inn en forbedring på et fag på vitnemålet
      Gitt jeg har lagt et vitnemål til grunn
      Og søkeren har dokumentert en forbedring av et fag på vitnemålet
      Når jeg legger inn den forbedrede karakteren på faget i vitnemålet
      Så teller den forbedrede karakteren i stedet for den tidligere karakteren
      # AVKLART 03.11.2026: forbedringen er ofte dokumentert på et
      # kompetansebevis som søkeren har lastet opp. Saksbehandleren legger den
      # inn på faget i vitnemålet. At forbedringer ikke teller i kvoten for
      # førstegangsvitnemål, står i L3. Erstatter «Legge til en forbedring fra
      # et kompetansebevis».

    Scenario: Forbedringen gjelder selv om den gir lavere poengsum
      Gitt jeg har lagt et vitnemål til grunn
      Og søkeren har dokumentert en ny karakter i et fag på vitnemålet som er lavere enn den tidligere karakteren
      Når jeg legger inn den nye karakteren som forbedring på faget
      Så teller den nye karakteren i stedet for den tidligere karakteren
      # AVKLART 12.11.2026 (gjennomgang med domeneekspertene): en forbedring
      # gjelder alltid, også når den gir søkeren lavere poengsum.

    Scenario: Legge til et nytt fag under tilleggsfag
      Gitt jeg har lagt et vitnemål til grunn
      Og søkeren har dokumentert et nytt fag som ikke står på vitnemålet
      Når jeg legger til faget under tilleggsfag
      Så er faget et tilleggsfag på vitnemålet
      Og tilleggsfaget kan velges per poengvariant
      # AVKLART 03.11.2026: nye fag, ofte fra et opplastet kompetansebevis,
      # legges til under tilleggsfag. Hvordan tilleggsfag velges, står i L3.
      # Erstatter «Legge til et nytt fag fra et kompetansebevis».
      #
      # AVKLART 03.11.2026: alle nye fag kan legges til, også når faget verken
      # dekker spesielle opptakskrav eller gir språk- eller realfagspoeng.
      #
      # AVKLART 04.11.2026: tilleggsfaget kan være fra en annen reform enn
      # vitnemålet. FS-klienten krever samme reform («Faget må ha samme
      # reformkode som vitnemålet», teknisk beskrivelse av
      # vitnemålsbehandling, G. M. Vangen), men det videreføres ikke.
      # Saksbehandleren vurderer selv om faget kan brukes.
      # Saksbehandleren avgjør om tilleggsfaget skal være med i beregningen,
      # ved å velge det per poengvariant. Scenarioet «Nytt fag på
      # kompetansebevis som ikke kan legges til» er derfor fjernet.

    Scenario: Et tilleggsfag kan ikke ha samme fagkode som et fag på vitnemålet
      Gitt jeg har lagt et vitnemål til grunn
      Og vitnemålet har et fag med en bestemt fagkode
      Når jeg legger til et tilleggsfag med samme fagkode
      Så ser jeg at faget må legges inn som en forbedring av faget på vitnemålet
      Og tilleggsfaget er ikke lagt til
      # AVKLART 03.11.2026: et fag som allerede står på vitnemålet, kan ikke
      # legges til på nytt som tilleggsfag. En ny karakter i samme fag er en
      # forbedring, og legges inn på faget i vitnemålet («Legge inn en
      # forbedring på et fag på vitnemålet»). Teksten på beskjeden hører i
      # endre_fag_i_grunnlaget.design.md.

    @could
    Scenario: Hente et tilleggsfag fra et annet elektronisk vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Og søkeren har et annet elektronisk vitnemål som ikke er annullert
      Når jeg velger et fag fra det andre vitnemålet som tilleggsfag
      Så er faget et tilleggsfag på vitnemålet med karakterene fra det andre vitnemålet
      Og tilleggsfaget kan velges per poengvariant
      # AVKLART 04.11.2026: tilleggsfag legges inn manuelt («Legge til et nytt
      # fag under tilleggsfag»). Å hente faget med karakterene fra søkerens
      # andre elektroniske vitnemål er et ønske med prioritet could, og ikke
      # nødvendig for å levere L4a. Forslaget kom fra FS-klienten, som henter
      # tillegg fra «Vg.dok fag», uten annullerte vitnemål (teknisk beskrivelse
      # av vitnemålsbehandling, G. M. Vangen).

    Scenariomal: Advarsel om grunnlag uten forbedringer når jeg <handling>
      Gitt søkeren har bare grunnlag som ikke tillater forbedringer
      Og jeg har lagt inn en forbedring på et fag på vitnemålet
      Når jeg velger å <handling>
      Så ser jeg at søkeren ikke har grunnlag som tillater forbedringer
      Men <resultat>

      Eksempler:
        | handling         | resultat                                           |
        | beregne poengene | poengene er beregnet med forbedringen              |
        | bruke poengene   | grunnlaget og poengene er lagret med forbedringen  |
      # AVKLART 12.11.2026 (gjennomgang med domeneekspertene): advarselen
      # kommer når saksbehandleren beregner og bruker poengene, ikke når
      # forbedringen legges inn, som varselet om forbedringer i kvoten for
      # førstegangsvitnemål i L3. Het «Advarsel når grunnlaget ikke tillater
      # forbedringer».
      #
      # AVKLART 04.11.2026: saksbehandleren advares, men advarselen stopper
      # ingenting. Den sier at forbedringen ikke får betydning for søkeren.
      # Forslaget kom fra FS-klienten, som gir advarselen «Søker har ikke
      # grunnlag som tillater forbedringer» (teknisk beskrivelse av
      # vitnemålsbehandling, G. M. Vangen). Henger sammen med kvoteregelen i
      # L3 («Varsel om forbedringer i poengvarianten for førstegangsvitnemål
      # når jeg <handling>»). Teksten hører i
      # endre_fag_i_grunnlaget.design.md.

    Scenario: Privatisteksamen erstatter både standpunkt- og eksamenskarakter
      Gitt søkeren har tatt et fag på nytt som privatist
      Og jeg har vurdert at den nye karakteren lønner seg for søkeren
      Når jeg legger inn den nye eksamenskarakteren som forbedring på faget i vitnemålet
      Så erstatter den både den gamle standpunktkarakteren og den gamle eksamenskarakteren
      # AVKLART 07.10.2026: om erstatningen lønner seg for søkeren, avgjør
      # saksbehandleren. Bare ny, utsatt og særskilt prøve kan kombineres med
      # den gamle standpunktkarakteren.
      #
      # AVKLART 03.11.2026: en ny privatisteksamen i samme fag er en
      # forbedring, og legges inn på faget i vitnemålet («Et tilleggsfag kan
      # ikke ha samme fagkode som et fag på vitnemålet»).

    Scenario: Legge inn opprinnelig karakter på et fag fritatt etter tidligere reform
      Gitt et fag på vitnemålet er ført som fritatt
      Og jeg har vurdert at faget er tatt med karakter i norsk videregående skole i en tidligere reform
      Når jeg legger inn den opprinnelige karakteren på faget
      Så inngår faget med den opprinnelige karakteren i grunnlaget
      # AVKLART 07.10.2026: saksbehandleren legger den opprinnelige
      # karakteren inn på fritaksfaget, og vurderer selv hva fritaket bygger
      # på. Den opprinnelige karakteren må være dokumentert (Samordna opptaks
      # wiki, «Poengberegning norske søkere»).
      #
      # AVKLART 12.11.2026 (gjennomgang med domeneekspertene): bygger fritaket
      # på et fag tatt i utlandet, skal faget ikke ha karakter og ikke være med
      # i beregningen. Det er saksbehandlerens vurdering, og løsningen sperrer
      # ikke. Scenarioet «Fag fritatt på grunnlag av fag tatt i utlandet får
      # ikke karakter» er fjernet.

    Scenariomal: Karakter på et fag på vitnemålet som ikke er et heltall fra 1 til 6, kan ikke legges inn
      Gitt jeg legger inn en forbedring eller en opprinnelig karakter på et fag på vitnemålet
      Når jeg legger inn <karakter> som karakter
      Så ser jeg at karakteren må være et heltall fra 1 til 6
      Og jeg kan ikke bruke poengene før karakteren er rettet

      Eksempler:
        | karakter |
        | 0        |
        | 7        |
        | 4,5      |
        | B        |
      # AVKLART 03.11.2026: bare heltall fra 1 til 6 kan legges inn, også når
      # saksbehandleren legger inn en forbedring, en ny karakter fra
      # privatisteksamen, eller den opprinnelige karakteren på et fag som er
      # fritatt. Saksbehandleren regner om utenlandske karakterer selv.
      #
      # AVKLART 12.11.2026 (gjennomgang med domeneekspertene): regelen gjelder
      # fagene på vitnemålet. Tilleggsfag kan ha karakter med desimaler, og kan
      # legges inn som bestått (scenarioene under). Het «Karakter som ikke er et
      # heltall fra 1 til 6, kan ikke legges til».

    Scenario: Legge inn en karakter med desimaler på et tilleggsfag
      Gitt jeg legger til et tilleggsfag
      Når jeg legger inn 4,57 som karakter
      Så har tilleggsfaget karakteren 4,57
      # AVKLART 12.11.2026 (gjennomgang med domeneekspertene): et tilleggsfag
      # kan ha karakter fra 1,00 til 6,00, med høyst to desimaler.

    Scenariomal: Karakter på et tilleggsfag som ikke er fra 1,00 til 6,00 med høyst to desimaler, kan ikke legges inn
      Gitt jeg legger til et tilleggsfag
      Når jeg legger inn <karakter> som karakter
      Så ser jeg at karakteren må være fra 1,00 til 6,00, med høyst to desimaler
      Og jeg kan ikke bruke poengene før karakteren er rettet

      Eksempler:
        | karakter |
        | 0,99     |
        | 6,01     |
        | 4,567    |
        | B        |
      # Grenseverdiene 1,00 og 6,00 er gyldige. Teksten på beskjeden hører i
      # endre_fag_i_grunnlaget.design.md.

    Scenario: Legge inn et tilleggsfag som er bestått uten tallkarakter
      Gitt søkeren har dokumentert et tilleggsfag som er bestått uten tallkarakter
      Når jeg legger til tilleggsfaget som bestått
      Så inngår tilleggsfaget ikke i snittet
      Men tilleggsfaget teller i omfanget
      Og tilleggsfaget kan inngå i vurderingen av kravelementene
      # AVKLART 12.11.2026 (gjennomgang med domeneekspertene): som i L4b
      # («Legge inn et fag som er bestått uten tallkarakter»).

  # Regelen «Saksbehandleren kan overstyre kontrollmotoren for et fag» (avklart
  # 04.11.2026) er fjernet 12.11.2026 (gjennomgang med domeneekspertene).
  # Den handlet om spesielle opptakskrav, som er utenfor vitnemålsbehandleren,
  # og håndteres på andre måter. Den er ikke flyttet til et annet krav.
  # Realfagspoeng for forsøkskoder i R94, som kontrollmotoren ikke gir
  # automatisk, kan saksbehandleren legge inn selv på poengvarianten (L3,
  # «Legge inn <poengtype> selv på en poengvariant»).

  # Regelen «Saksbehandleren kan ta et fag ut av kontrollene» (flyttet hit fra
  # @OPT-BEH-BEH-027 10.11.2026, @draft) er fjernet 12.11.2026 (gjennomgang med
  # domeneekspertene). Den er dekket av fagvalget i L3
  # (velge_fag_per_poengvariant.feature, @OPT-BEH-BEH-022).
