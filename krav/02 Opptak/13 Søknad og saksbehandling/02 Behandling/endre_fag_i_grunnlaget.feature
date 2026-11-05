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
# Bygger på L2 og L3. Reglene for beregning og lagring fra L3 («Poengene beregnes fortløpende og lagres når grunnlaget er klart»,
# flyttet fra L2 30.10.2026) gjelder også her (avklart 03.11.2026, endret
# 04.11.2026): poengene beregnes på nytt hver gang grunnlaget endres, en
# endring lagres når saksbehandleren velger å lagre grunnlaget, og endringer
# hører til vitnemålet de er gjort for. Regelen for leserettighet står i
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

    Scenario: Stryke et fag som overlapper med påbygging på kompetansebevis
      Gitt søkeren har et yrkesfaglig vitnemål
      Og jeg har lagt til fagene fra påbyggingen til generell studiekompetanse under tilleggsfag
      Og jeg har vurdert at et fag på vitnemålet overlapper med et fag i påbyggingen
      Når jeg stryker faget på vitnemålet
      Så inngår faget på vitnemålet ikke i beregningen
      Og faget fra påbyggingen inngår i stedet
      # AVKLART 07.10.2026: hvilke fag som overlapper, er saksbehandlerens
      # vurdering, fordi reglene har mange unntak. Hovedreglene: norsk
      # strykes på vitnemålet og hentes fra kompetansebeviset. Matematikk og
      # naturfag strykes fra vitnemålet bare når faget er ført med henholdsvis
      # 224 og 140 timer samlet på kompetansebeviset.
      #
      # AVKLART 03.11.2026: påbyggingen er et opplastet kompetansebevis, og
      # fagene fra den legges til under tilleggsfag. Scenarioet gjelder fag
      # med ulik fagkode som overlapper, f.eks. norsk på det yrkesfaglige
      # vitnemålet og norsk i påbyggingen. Et fag med samme fagkode er en
      # forbedring («Et tilleggsfag kan ikke ha samme fagkode som et fag på
      # vitnemålet»).

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

    Scenario: Advarsel når grunnlaget ikke tillater forbedringer
      Gitt søkeren har bare grunnlag som ikke tillater forbedringer
      Når jeg legger inn en forbedring på et fag på vitnemålet
      Så ser jeg at søkeren ikke har grunnlag som tillater forbedringer
      Men forbedringen kan legges inn
      # AVKLART 04.11.2026: saksbehandleren advares, men advarselen stopper
      # ingenting. Den sier at forbedringen ikke får betydning for søkeren.
      # Forslaget kom fra FS-klienten, som gir advarselen «Søker har ikke
      # grunnlag som tillater forbedringer» (teknisk beskrivelse av
      # vitnemålsbehandling, G. M. Vangen). Henger sammen med kvoteregelen i
      # L3 («Tilleggsfag kan ikke velges i poengvarianten for
      # førstegangsvitnemål»). Teksten hører i
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

    Scenario: Fag fritatt på grunnlag av fag tatt i utlandet får ikke karakter
      Gitt et fag på vitnemålet er ført som fritatt
      Og jeg har vurdert at fritaket bygger på et fag tatt i utlandet
      Når jeg ser faget i grunnlaget
      Så ser jeg ikke muligheten til å legge inn karakter på faget
      # Utenlandske karakterer konverteres ikke i disse tilfellene, og faget
      # skal ikke være med i beregningen (samme kilde).

    Scenario: Markere at et fag med forsøkskode gir realfagspoeng
      Gitt vitnemålet har et R94-fag med fagkode som begynner på «FS»
      Og jeg har vurdert at faget gir realfagspoeng
      Når jeg markerer at faget gir realfagspoeng
      Så gir faget realfagspoeng
      # AVKLART 07.10.2026: kontrollmotoren gir ikke realfagspoeng for
      # forsøkskoder i R94 automatisk (Samordna opptaks wiki,
      # «Realfagspoeng»). Saksbehandleren retter det i vitnemålsbehandleren.

    Scenariomal: Karakter som ikke er et heltall fra 1 til 6, kan ikke legges til
      Gitt jeg legger til eller endrer en karakter i grunnlaget
      Når jeg legger inn <karakter> som karakter
      Så ser jeg at karakteren må være et heltall fra 1 til 6
      Og jeg kan ikke lagre grunnlaget før karakteren er rettet

      Eksempler:
        | karakter |
        | 0        |
        | 7        |
        | 4,5      |
        | B        |
      # AVKLART 03.11.2026: bare heltall fra 1 til 6 kan legges inn, også når
      # saksbehandleren legger til en forbedring eller et nytt fag fra et
      # kompetansebevis, en ny karakter fra privatisteksamen, eller den
      # opprinnelige karakteren på et fag som er fritatt. Saksbehandleren
      # regner om utenlandske karakterer selv. Samme regel som i L4b
      # («Karakterer legges inn som heltall fra 1 til 6»).

  @ref-OPT-BEH-BEH-020
  Regel: Saksbehandleren kan overstyre kontrollmotoren for et fag

    # AVKLART 04.11.2026: kontrollmotoren kjenner ikke alltid igjen et fag,
    # for eksempel et tilleggsfag fra en annen reform enn vitnemålet (se
    # «Legge til et nytt fag under tilleggsfag»). Saksbehandleren kan da
    # markere at faget gir realfagspoeng eller språkpoeng, eller dekker et
    # kravelement, i stedet for å overstyre summen av poengene eller
    # kravelementet. Det gjør overstyringen sporbar per fag.
    # «Markere at et fag med forsøkskode gir realfagspoeng» er et eksempel på
    # denne regelen.
    #
    # Fra før kan saksbehandleren overstyre vurderingen av et kravelement
    # (automatisk_kvalifisering.feature, @OPT-BEH-BEH-020) og poengene på
    # saken (automatisk_poengberegning.feature, @OPT-BEH-BEH-018) og på en
    # poengvariant (L2, «Legge inn <poengtype> selv på en poengvariant»).

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenariomal: Markere at et fag gir <poengtype>
      Gitt kontrollmotoren gir ikke <poengtype> for et fag i grunnlaget
      Og jeg har vurdert at faget gir <poengtype>
      Når jeg markerer at faget gir <poengtype>
      Så gir faget <poengtype>

      Eksempler:
        | poengtype     |
        | realfagspoeng |
        | språkpoeng    |

    Scenario: Markere at et fag dekker et kravelement
      Gitt kontrollmotoren har ikke vurdert at et fag i grunnlaget dekker et kravelement
      Og jeg har vurdert at faget dekker kravelementet
      Når jeg markerer at faget dekker kravelementet
      Så er kravelementet oppfylt med faget

    Scenario: Det fremgår at kontrollmotoren er overstyrt for et fag
      Gitt jeg har markert at et fag gir realfagspoeng
      Når jeg ser faget i grunnlaget
      Så ser jeg at kontrollmotoren er overstyrt for faget

    Scenario: Markeringen på et fag endres ikke av automatikken
      Gitt jeg har markert at et fag gir realfagspoeng
      Når søknaden behandles automatisk
      Så gir faget fortsatt realfagspoeng
      # AVKLART 04.11.2026: markeringen låses mot automatikken, slik
      # saksbehandlerens vurdering av et kravelement gjør i
      # automatisk_kvalifisering.feature («Saksbehandlerens vurdering av et
      # kravelement endres ikke av automatikken»). Regelen er validert, og
      # hører til L4a på linje med resten av kravet.
