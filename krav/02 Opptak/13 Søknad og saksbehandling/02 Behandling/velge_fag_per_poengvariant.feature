# language: no
# GitHub: #609
#
# Leveranse L3 av seks i initiativet #607 Vitnemålsbehandling. Skilt ut fra
# vitnemålsbehandling.feature 08.10.2026. Kilder, bakgrunn, avgrensninger og
# oversikten over leveransene står i vitnemålsbehandling.md i samme mappe.
#
# Bygger på L2 (velge_vitnemål_som_grunnlag.feature). Her ligger reglene for
# kvoten for førstegangsvitnemål, som er den vanskeligste enkeltbiten i hele
# initiativet.
#
@OPT-BEH-BEH-007 @must @draft
Egenskap: Velge fag per poengvariant
  Som saksbehandler i opptak
  ønsker jeg å velge hvilket vitnemål og hvilke fag som skal telle i hver poengvariant
  slik at søkeren blir riktig poengberegnet i hver kvote og til hvert søknadsalternativ.

  Både valget av vitnemål og valget av fag gjøres per poengvariant. Det er
  ikke ett valg som gjelder overalt: samme fag kan telle i én poengvariant og
  ikke i en annen. Der reglene gir et valg, skal saksbehandleren velge det
  som gir søkeren best uttelling. Saksbehandleren kan ikke sette sammen et
  vitnemål søkeren ikke har.

  Hvilken poengvariant som hører til hvilken kvote og hvilket
  søknadsalternativ, står i regelverket.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg kan se og endre søknadsbehandling for organisasjonen som behandler saken
    Og jeg er inne på søknaden til en søker

  Regel: Fagene på det valgte vitnemålet vises

    Scenario: Se fagene på vitnemålet
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg ser fagene på vitnemålet
      Så ser jeg hvert fag med følgende opplysninger
        | felt               |
        | Fagkode            |
        | Fagnavn            |
        | Omfang             |
        | År                 |
        | Standpunktkarakter |
        | Eksamenskarakter   |
        | Fagstatus          |
      # Feltene er verifisert mot NVB_VGDOKFAG og mot KregFag i
      # hentKompetansebevis: fagkode, fagnavn, fagOmfang, aar, terminkode,
      # fagstatuskode og vurdering.

    Scenario: Se opprinnelig og forbedret karakter samtidig
      Gitt vitnemålet har et fag søkeren har forbedret
      Når jeg ser fagene på vitnemålet
      Så ser jeg både den opprinnelige og den forbedrede karakteren for faget
      Og det fremgår hvilken av dem som inngår i beregningen
      # Verifisert i FS-klienten: dm_vitnemalbehandl_vmfag selvjoiner
      # NVB_VGDOKFAG mot seg selv på samme fagkode med ulik status_forbedring,
      # og viser radene som kolonneparet «Opprinnelig / Forbedret».
      # Designskissen i Confluence har samme kolonnepar.

    Scenario: Se merknader på et fag
      Gitt et fag på vitnemålet har en merknad
      Når jeg ser fagene på vitnemålet
      Så ser jeg merknaden på faget
      # KregFag.merknader og NVB_VGDOKFAG.merknadkode med merknadparameter.
      # Merknader forklarer f.eks. fritak eller særskilt vurderingsform, og er
      # nødvendige for at saksbehandleren skal forstå hvorfor et fag ser ut
      # som det gjør.

  Regel: Vitnemålet kan velges per poengvariant

    # L2 lar saksbehandleren velge ett vitnemål for hele saken. Denne regelen
    # utvider valget til hver poengvariant.

    Scenario: Legge ulikt vitnemål til grunn for ulike poengvarianter
      Gitt søkeren har to elektroniske vitnemål
      Når jeg legger det ene vitnemålet til grunn for én poengvariant
      Og jeg legger det andre vitnemålet til grunn for en annen poengvariant
      Så beregnes hver poengvariant fra sitt eget vitnemål
      Og det fremgår hvilket vitnemål hver poengvariant bygger på
      # AVKLART 21.09.2026: ulikt vitnemål per poengvariant er tillatt. Det er
      # den logiske konsekvensen av at fagvalget er per poengvariant, og
      # formålet er det samme — der reglene gir et valg, å velge det som gir
      # søkeren best uttelling.
      #
      # Verifisert i ny stack: Poeng er nøklet på blant annet poengklasse_kode
      # og poengvariant_kode, og har vitnemaalsnummer som eget felt.
      # Datamodellen støtter dette allerede; det måtte besluttes, ikke bygges.
      #
      # GSK-vedtaket har sitt eget vitnemaalsnummer for hele søkeren og
      # påvirkes ikke. GSK og poeng kan derfor peke på ulike vitnemål — det er
      # akseptert, fordi de svarer på ulike spørsmål: GSK om kvalifisering,
      # poeng om rangering.

    Scenario: Et vitnemål gjelder ikke alle poengvarianter
      Gitt søkeren har et vitnemål som ikke er gyldig for alle poengvarianter
      Når jeg velger vitnemålet
      Så kan jeg bare legge det til grunn for poengvariantene det gjelder for
      # Verifisert i FS-klienten: f_hentvitnemalpoengvariant slår opp
      # POENGVARIANTVITNEMAL på (vgdoknr, poengvariant) og returnerer 0 når
      # kombinasjonen ikke finnes. Et vitnemål er altså ikke universelt
      # gyldig.

  Regel: Fagvalget gjøres per poengvariant

    Scenario: Velge hvilke fag som skal telle
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg behandler en bestemt poengvariant
      Når jeg velger hvilke fag som skal telle
      Så beregnes poengene for den poengvarianten fra de valgte fagene
      Og fagvalget er lagret på poengvarianten
      # Fagvalget låser poenget mot automatisk reberegning på samme måte som
      # valget av vitnemål i L2 («Valget av grunnlag låser poenget mot
      # automatisk reberegning»).

    Scenario: Fagvalget i én poengvariant påvirker ikke en annen
      Gitt jeg har valgt et tilleggsfag i én poengvariant
      Når jeg åpner en annen poengvariant
      Så er tilleggsfaget ikke valgt der
      # AVKLART: fagvalget er per poengvariant. Begge datamodeller er entydige
      # på dette — FS-klientens TILLEGGVARIANT er nøklet på
      # (vgdoknr, fagkode, poengvariant), og VitnemalUtregning i ny stack er
      # nøklet på blant annet poengklasse_kode og poengvariant_kode.
      #
      # Merk at designskissen for tilleggsfag i Confluence viser én enkelt
      # avkryssingskolonne, uten å si hvilken poengvariant den gjelder. Den
      # kolonnen må forstås som valget for den poengvarianten saksbehandleren
      # har åpen.

    Scenario: Søkeren kan få ulik poengsum til ulike søknadsalternativer
      Gitt søkeren har to søknadsalternativer med ulike spesielle opptakskrav
      Og søknadsalternativene bruker hver sin poengvariant
      Når jeg velger fag for hver av poengvariantene
      Så beregnes hver poengvariant fra fagene jeg valgte for den
      Og jeg ser hvilke søknadsalternativer hver poengsum gjelder for
      # AVKLART 08.10.2026: ulik poengsum per søknadsalternativ (VPL i FS)
      # håndteres med fagvalget per poengvariant. Hvilken poengvariant et
      # søknadsalternativ bruker, står i regelverket.
      #
      # Bakgrunn (Samordna opptaks wiki, «Realfagspoeng»): fag som dekker
      # spesielle opptakskrav, legges inn først og bruker av taket på 4
      # poeng for realfags- og språkpoeng. Ulike opptakskrav gir derfor ulik
      # plass til andre poenggivende fag. Når taket er nådd, kan ikke flere
      # karakterer tas med.

    Scenario: Tilleggsfag teller ikke før det aktivt velges
      Gitt vitnemålet har et tilleggsfag
      Og jeg har ikke tatt stilling til tilleggsfaget
      Når poengene beregnes
      Så inngår ikke tilleggsfaget i beregningen
      # AVKLART 21.09.2026: et tilleggsfag er utenfor beregningen til
      # saksbehandleren aktivt velger det.
      #
      # Begrunnelse: det motsatte gjør at et førstegangsvitnemål blir
      # forbedret uten at noen har tatt et valg — se scenarioene under. Med
      # denne regelen er det alltid sporbart hvem som tok valget.
      #
      # Dette er en opprydding, ikke en videreføring. FS-klienten har to ulike
      # defaulter i samme bilde: dm_vitnemalbehandl_vmfag bruker
      # nvl(TVAR.status_valgt,'J') — altså med som standard — mens
      # dm_vitnemalbehandl_vmfag_tillegg bruker rå TVAR.status_valgt, altså
      # ikke med. Forskjellen ser ut som en tilfeldighet, og videreføres ikke.

    Scenario: Tilleggsfag kan ikke velges i poengvarianten for førstegangsvitnemål
      Gitt søkeren har et førstegangsvitnemål med et tilleggsfag
      Når jeg behandler poengvarianten for kvoten for førstegangsvitnemål
      Så ser jeg ikke muligheten til å velge tilleggsfaget
      # AVKLART 07.10.2026: nye fag og forbedringer teller bare i ordinær
      # kvote, aldri i kvoten for førstegangsvitnemål (Samordna opptaks wiki,
      # sidene «Kvoter» og «Poengberegning norske søkere»). Søkeren konkurrerer
      # i begge kvotene med hver sin poengsum, og mister ikke kvoten fordi et
      # tilleggsfag velges i ordinær kvote. Dette erstatter begrunnelsen fra
      # 21.09.2026, som sa at søkeren kunne slås ut av kvoten. Unntakene står
      # i de to scenarioene under.
      #
      # Hvilken poengvariant som hører til hvilken kvote, står i regelverket.
      #
      # Verifisert i FS-klienten: f_forbedretvitnemal(vgdoknr, poengvariant)
      # returnerer 1 når vitnemålet har et valgt tilleggsfag for akkurat den
      # poengvarianten. Valget er altså per poengvariant, og det er derfor
      # det kan hindres i én poengvariant og tillates i en annen.
      #
      # Et vitnemål med forbedringer kan ikke legges til grunn for
      # poengvarianten for førstegangsvitnemål. Det dekkes av «Et vitnemål
      # gjelder ikke alle poengvarianter».

    Scenario: Tilleggsfag kan velges i ordinær kvote
      Gitt søkeren har et førstegangsvitnemål med et tilleggsfag
      Når jeg velger tilleggsfaget for poengvarianten i ordinær kvote
      Så inngår tilleggsfaget i beregningen for den poengvarianten
      Men poengene for kvoten for førstegangsvitnemål er uendret

    Scenario: Matematikk R2 på kompetansebevis kan tas med i kvoten for førstegangsvitnemål
      Gitt søkeren har et førstegangsvitnemål
      Og søkeren har matematikk R2 på et kompetansebevis
      Og jeg har vurdert at R2 er tatt innen normal tid
      Når jeg behandler poengvarianten for kvoten for førstegangsvitnemål
      Så kan jeg velge R2 fra kompetansebeviset
      # AVKLART 07.10.2026: om et unntak gjelder, er saksbehandlerens
      # vurdering, og det er vitnemålsbehandleren som håndhever unntakene.
      #
      # Unntaket finnes fordi R2 ikke kan føres på samme vitnemål som
      # S-matematikk (Samordna opptaks wiki, «Kvoter»).
      #
      # Wikiens tredje unntak, nytt førstegangsvitnemål etter komprimert løp,
      # er utelatt med vilje. Avklart 07.10.2026 at det ikke forekommer.

    Scenario: Poenggivende fag på yrkesfagsløpet kan tas med i kvoten for førstegangsvitnemål
      Gitt søkeren kvalifiserer til kvoten for førstegangsvitnemål med yrkesfaglig vitnemål og studiekompetansefagene
      Og søkeren har et fag som gir språk- eller realfagspoeng
      Og jeg har vurdert at faget er tatt senest det semesteret søkeren oppnådde generell studiekompetanse
      Når jeg behandler poengvarianten for kvoten for førstegangsvitnemål
      Så kan jeg velge faget
      # Samordna opptaks wiki, «Kvoter»: fag som gir språk- eller
      # realfagspoeng, tatt samtidig med studiekompetansefagene, kan tas med
      # i kvoten for førstegangsvitnemål.

  Regel: Saksbehandleren kan bare endre fagvalget slik en regel tillater

    # AVKLART 07.10.2026: vitnemålsbehandleren håndhever at grunnlaget bare
    # endres etter faste regler. Det er de videregående skolene som utsteder
    # vitnemål og avgjør hva som oppfyller vitnemålskravene. Saksbehandleren
    # kan ikke sette sammen et grunnlag søkeren kunne hatt. Vil søkeren ha en
    # annen fagsammensetning, må søkeren kontakte skolen.
    #
    # Regelen er delt mellom L3 og L4 (besluttet 08.10.2026): her står
    # grensene for fagvalget. Tillegg og endringer i karakterer står i
    # legge_inn_og_endre_fag.feature.

    Scenario: Ikke alle fag kan velges bort
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg ser fagene på vitnemålet
      Så kan jeg bare velge bort fag som er merket som valgbare
      # Verifisert i FS-klienten: TILLEGGVARIANT.status_valgbar styrer dette,
      # og defaulter til 'N'. Fag som inngår i selve vitnemålsgrunnlaget kan
      # altså ikke hukes bort — det er tilleggsfagene valget gjelder.

    Scenario: Studiekompetansefag kan ikke fjernes etter 23/6-regelen
      Gitt søkeren rangeres etter 23/6-regelen
      Og søkeren har bestått studiekompetansefagene
      Når jeg ser fagene i grunnlaget
      Så ser jeg ikke muligheten til å fjerne studiekompetansefagene
      # Studiekompetansefagene skal alltid være med i snittet, uansett
      # karakter. Et fag på høyere nivå godtas bare som erstatning når
      # søkeren mangler selve fagkravet (Samordna opptaks wiki,
      # «Poengberegning norske søkere»). 23/5-regelen heter 23/6-regelen
      # fra 1. januar 2027.

    Scenario: Velge hvordan matematikk på Vg2-nivå dekkes etter 23/6-regelen
      Gitt søkeren rangeres etter 23/6-regelen
      Og søkeren har bestått 1P, 2P og R1
      Når jeg velger hvilke matematikkfag som skal inngå
      Så må 1P være med
      Og jeg kan velge 2P, R1 eller begge i tillegg

    Scenario: Hente studiekompetansefag fra flere dokumenter etter 23/6-regelen
      Gitt søkeren rangeres etter 23/6-regelen
      Og studiekompetansefagene er dokumentert på flere vitnemål og kompetansebevis
      Når jeg setter sammen grunnlaget
      Så kan jeg hente hvert studiekompetansefag fra det dokumentet det står på
      # 23/6-regelen er det eneste stedet der fag kan hentes fritt fra
      # ulike dokumenter.
