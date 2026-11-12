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
# Feature-ID-en er endret fra @OPT-BEH-BEH-007 til @OPT-BEH-BEH-022, fordi
# gi_tilbudsgaranti_ved_tidlig_opptak.feature også bruker 007 (26.10.2026).
#
@OPT-BEH-BEH-022 @must @planned
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

  # AVKLART 03.11.2026, endret 11.11.2026: reglene for beregning og lagring
  # står i L2 (velge_vitnemål_som_grunnlag.feature, «Poengene beregnes og
  # lagres når saksbehandleren bruker dem»), og gjelder også her.
  # Saksbehandleren beregner poengene uten å lagre, og grunnlaget
  # kontrolleres, poengene beregnes og alt lagres når saksbehandleren velger
  # å bruke poengene. Endringer hører til vitnemålet de er gjort for. Regelen for leserettighet står i
  # vitnemålsbehandling.md. Rettigheten til å endre står derfor i Bakgrunn
  # under reglene der saksbehandleren endrer noe, som i L2.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
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
      #
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): «År» er
      # visningsnavnet for året og terminen faget er tatt.

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
      #
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): at et fag er
      # fordypningsfag, vises som en merknad på faget.

  Regel: Vitnemålet kan velges per poengvariant

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    # L2 lar saksbehandleren velge ett vitnemål for hele saken. Denne regelen
    # utvider valget til hver poengvariant.
    #
    # AVKLART 03.11.2026: når L3 er levert, velges vitnemålet alltid per
    # poengvariant. Saksbehandleren velger først poengvarianten, og så
    # vitnemålet for den. Det finnes ikke lenger ett valg for hele saken, slik
    # som i L2. Skissen har allerede en radioknapp per poengvariant i
    # «Kvalifisering og poengberegning».

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

    Scenario: Endringer på et vitnemål gjelder ikke for et annet vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg har gjort endringer i grunnlaget for vitnemålet
      Når jeg velger et annet vitnemål
      Så er endringene jeg gjorde for det forrige vitnemålet, ikke brukt i grunnlaget
      # AVKLART 21.10.2026: hver redigering hører til vitnemålet den er gjort
      # for. Fra L3 gjelder det poeng saksbehandleren har lagt inn selv
      # («Legge inn <poengtype> selv på en poengvariant», flyttet fra L2
      # 11.11.2026) og fagvalg, og fra L4 manuelt innlagte eller endrede fag.

    Scenario: Endringer på et vitnemål huskes når jeg bytter tilbake
      Gitt jeg har gjort endringer i grunnlaget for et vitnemål
      Og jeg har byttet til et annet vitnemål
      Når jeg velger det forrige vitnemålet igjen
      Så er endringene jeg gjorde for det forrige vitnemålet, brukt i grunnlaget igjen
      # AVKLART 21.10.2026: redigeringene skal huskes når saksbehandleren
      # bytter vitnemål, så de ikke må gjøres på nytt.
      #
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): de to
      # scenarioene over er flyttet hit fra L2, fordi saksbehandleren først kan
      # gjøre endringer på et vitnemål i L3 (poeng lagt inn selv, fagvalg) og
      # L4 (endrede og manuelt innlagte fag).

  Regel: Fagvalget gjøres per poengvariant

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenario: Velge hvilke fag som skal telle
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg behandler en bestemt poengvariant
      Når jeg velger hvilke fag som skal telle
      Og jeg velger å bruke poengene
      Så er poengene for den poengvarianten beregnet fra de valgte fagene
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
      Og jeg ser hvilke kompetansekrav hver poengsum gjelder for
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): saksbehandleren
      # ser hvilke kompetansekrav hver poengsum gjelder for, ikke hvilke
      # søknadsalternativer.
      #
      # AVKLART 08.10.2026: ulik poengsum per søknadsalternativ (VPL i FS)
      # håndteres med fagvalget per poengvariant. Hvilken poengvariant et
      # søknadsalternativ bruker, står i regelverket.
      #
      # Bakgrunn (Samordna opptaks wiki, «Realfagspoeng»): fag som dekker
      # spesielle opptakskrav, legges inn først og bruker av taket på 4
      # poeng for realfags- og språkpoeng. Ulike opptakskrav gir derfor ulik
      # plass til andre poenggivende fag. Når taket er nådd, kan ikke flere
      # karakterer tas med.

    @ref-OPT-BEH-BEH-020
    Scenario: Kravelementene vurderes per grunnlag
      Gitt søkeren har tatt et fag som privatist etter fylte 21 år
      Og faget dekker et kravelement
      Når kravelementene vurderes
      Så oppfyller faget kravelementet på grunnlaget for ordinær kvote
      Men faget oppfyller ikke kravelementet på grunnlaget for kvoten for førstegangsvitnemål
      # AVKLART 05.11.2026: kravelementene og kvalifiseringen vurderes per
      # grunnlag, ikke per poengvariant, også i vitnemålsbehandleren. Det er
      # det samme som i den automatiske vurderingen (OPT-BEH-BEH-020,
      # «Om søkeren er kvalifisert, avgjøres per grunnlag»). Marit Bjørnerud
      # Rønning skrev på siden med åpne spørsmål 04.11.2026 at det er gjort om
      # til per grunnlag. Erstatter avklaringen 03.11.2026 og scenarioet
      # «Kravelementene vurderes per poengvariant».

    @ref-OPT-BEH-BEH-020
    Scenario: Kravelementene kontrolleres mot fagene i poengvarianten som lagres
      Gitt jeg har valgt vitnemål og fag for en poengvariant
      Når jeg velger å bruke poengene
      Så er kravelementene kontrollert mot vitnemålet og fagene som er valgt i poengvarianten
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): når
      # saksbehandleren lagrer en poengvariant, kontrollerer kontrollmotoren
      # fagsammensetningen i den poengvarianten. Det trengs ikke et eget valg
      # av fag for kravelementene. Kvalifiseringen gjelder fortsatt per
      # grunnlag. Lukker spørsmålet om hvilke fag som legges til grunn når
      # poengvariantene på samme grunnlag har ulikt fagvalg.

    Scenario: Ingen poeng lagres for en poengvariant der søkeren ikke er kvalifisert
      Gitt søkeren oppfyller ikke de spesielle opptakskravene på grunnlaget en poengvariant hører til
      Når jeg velger å bruke poengene
      Så ser jeg at søkeren ikke er kvalifisert på grunnlaget
      Og fagvalget for poengvarianten er lagret
      Men poengene for poengvarianten er ikke lagret
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): fagvalget
      # lagres, men ikke poengene.
      #
      # AVKLART 05.11.2026: poengene lagres ikke for en poengvariant der
      # søkeren ikke oppfyller de spesielle opptakskravene, slik FS-klienten
      # gjør (teknisk beskrivelse av vitnemålsbehandling, G. M. Vangen).
      # Besvart av Marit Bjørnerud Rønning og Ingrid Grimstad Helset på siden
      # med åpne spørsmål 04.11.2026. Kvalifiseringen avgjøres per grunnlag
      # (avklart 05.11.2026, «Kravelementene vurderes per grunnlag»).

    Scenario: Bruke vitnemålet og fagvalget fra én poengvariant i andre poengvarianter
      Gitt jeg har valgt vitnemål og fag i én poengvariant
      Når jeg velger hvilke andre poengvarianter vitnemålet og fagvalget skal brukes på
      Så har poengvariantene jeg valgte, det samme vitnemålet og det samme fagvalget
      Men tilleggsfag er ikke valgt i poengvarianten for kvoten for førstegangsvitnemål
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): saksbehandleren
      # velger hvilke poengvarianter vitnemålet og fagvalget skal brukes på, og
      # både vitnemålet og fagvalget brukes. Het «Bruke fagvalget fra én
      # poengvariant i andre poengvarianter», og kopierte bare fagvalget til
      # alle de andre poengvariantene.
      #
      # AVKLART 04.11.2026: saksbehandleren kan bruke fagvalget fra én
      # poengvariant i de andre, så det ikke må gjøres på nytt i hver av dem.
      # Kvoteregelen gjelder fortsatt: tilleggsfag blir ikke valgt i
      # poengvarianten for kvoten for førstegangsvitnemål. Forslaget kom fra
      # FS-klienten, som kan kopiere en beregning til andre poengvarianter og
      # grunnlag (teknisk beskrivelse av vitnemålsbehandling, G. M. Vangen).

    # AVKLART 04.11.2026: tilleggsfag som saksbehandleren legger til for hånd
    # (L4a, «Legge til et nytt fag under tilleggsfag»), følger de samme
    # reglene som tilleggsfagene som står på vitnemålet: de teller ikke før
    # de er valgt i en poengvariant, og gir det samme varselet i kvoten for
    # førstegangsvitnemål (endret 11.11.2026).
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

    Scenariomal: Varsel om forbedringer i poengvarianten for førstegangsvitnemål når jeg <handling>
      Gitt grunnlaget for poengvarianten for kvoten for førstegangsvitnemål har forbedringer
      Når jeg velger å <handling>
      Så ser jeg et varsel om at forbedringer som hovedregel ikke teller i kvoten for førstegangsvitnemål
      Men <resultat>

      Eksempler:
        | handling         | resultat                                           |
        | beregne poengene | poengene er beregnet med forbedringene             |
        | bruke poengene   | grunnlaget og poengene er lagret med forbedringene |
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): erstatter
      # «Tilleggsfag kan ikke velges i poengvarianten for førstegangsvitnemål».
      # Forbedringer er tilleggsfag og forbedrede karakterer. Saksbehandleren
      # kan legge dem til i poengvarianten for kvoten for førstegangsvitnemål,
      # og får et varsel som ikke stopper noe, når poengene beregnes og brukes.
      # Om et unntak gjelder (R2, poenggivende fag på yrkesfagsløpet), er
      # saksbehandlerens vurdering. Avviker fra FS-klienten, der grunnlaget VOV
      # ikke tillater tillegg. Teksten hører i
      # velge_fag_per_poengvariant.design.md.
      #
      # AVKLART 07.10.2026: nye fag og forbedringer teller bare i ordinær
      # kvote, aldri i kvoten for førstegangsvitnemål (Samordna opptaks wiki,
      # sidene «Kvoter» og «Poengberegning norske søkere»). Søkeren konkurrerer
      # i begge kvotene med hver sin poengsum, og mister ikke kvoten fordi et
      # tilleggsfag velges i ordinær kvote. Dette erstatter begrunnelsen fra
      # 21.09.2026, som sa at søkeren kunne slås ut av kvoten. Unntakene står
      # i de to scenarioene under. Fra 11.11.2026 er hovedregelen et varsel,
      # ikke en sperre.
      #
      # Hvilken poengvariant som hører til hvilken kvote, står i regelverket.
      #
      # Verifisert i FS-klienten: f_forbedretvitnemal(vgdoknr, poengvariant)
      # returnerer 1 når vitnemålet har et valgt tilleggsfag for akkurat den
      # poengvarianten. Valget er altså per poengvariant, og det er derfor
      # varselet kan gjelde én poengvariant og ikke en annen.
      #
      # Et vitnemål med forbedringer kan legges til grunn for poengvarianten
      # for førstegangsvitnemål, med det samme varselet (endret 11.11.2026,
      # var en sperre).
      #
      # AVKLART 04.11.2026: «Et vitnemål gjelder ikke alle poengvarianter» er
      # fjernet. Det bygde på at tabellen POENGVARIANTVITNEMAL i FS-klienten
      # sier hvilke vitnemål som gjelder for hver poengvariant. Ifølge den
      # tekniske beskrivelsen av vitnemålsbehandling (G. M. Vangen) lagrer
      # tabellen bare hvilket vitnemål saksbehandleren har valgt. Den eneste
      # regelen er kvoteregelen i dette scenarioet, som fra 11.11.2026 er et
      # varsel.
      #
      # Bekreftet i den tekniske beskrivelsen av vitnemålsbehandling i
      # FS-klienten (G. M. Vangen, lest 03.11.2026): grunnlaget VOV tillater
      # ikke tillegg («Det er ikke anledning å velge tillegg for grunnlag
      # VOV»). Det videreføres ikke (11.11.2026).

    Scenario: Tilleggsfag kan velges i ordinær kvote
      Gitt søkeren har et førstegangsvitnemål med et tilleggsfag
      Når jeg velger tilleggsfaget for poengvarianten i ordinær kvote
      Så inngår tilleggsfaget i beregningen for den poengvarianten
      Men poengene for kvoten for førstegangsvitnemål er uendret

    Scenario: Matematikk R2 på kompetansebevis kan tas med i kvoten for førstegangsvitnemål
      Gitt søkeren har et førstegangsvitnemål
      Og søkeren har matematikk R2 på et kompetansebevis
      Og jeg har vurdert at R2 er tatt innen normal tid
      Når jeg velger R2 for poengvarianten for kvoten for førstegangsvitnemål
      Så inngår R2 i beregningen for poengvarianten
      # AVKLART 07.10.2026: om et unntak gjelder, er saksbehandlerens
      # vurdering.
      #
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): løsningen
      # håndhever ikke unntakene. Saksbehandleren kan velge forbedringer i
      # poengvarianten for førstegangsvitnemål for alle søkere, og får varselet
      # i «Varsel om forbedringer i poengvarianten for førstegangsvitnemål når
      # jeg <handling>». Dette scenarioet og det neste er eksempler på når
      # saksbehandleren bruker forbedringen likevel.
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
      Når jeg velger faget for poengvarianten for kvoten for førstegangsvitnemål
      Så inngår faget i beregningen for poengvarianten
      # Samordna opptaks wiki, «Kvoter»: fag som gir språk- eller
      # realfagspoeng, tatt samtidig med studiekompetansefagene, kan tas med
      # i kvoten for førstegangsvitnemål.

  # Reglene for beregning og lagring står i L2 (velge_vitnemål_som_grunnlag.feature,
  # «Poengene beregnes og lagres når saksbehandleren bruker dem»), og gjelder
  # også her. Regelen var her fra 30.10.2026, og ble flyttet tilbake til L2
  # 11.11.2026 (gjennomgang av L3 og L4 med domeneekspertene).

  Regel: Saksbehandleren kan legge inn poeng selv på en poengvariant

    # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): saksbehandleren
    # blir ikke spurt om poeng saksbehandleren har lagt inn selv, skal
    # beholdes. Endres grunnlaget for poengvarianten, gjelder regelen i L2: de
    # lagrede poengene står til saksbehandleren beregner eller bruker
    # poengene på nytt («De lagrede poengene vises til jeg beregner på nytt»).
    # Scenariomalen «Velge om <poengtype> jeg har lagt inn selv, skal
    # beholdes» (avklart 04.11.2026, etter spørsmål fra domeneekspertene
    # 22.10.2026) er fjernet.

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenariomal: Legge inn <poengtype> selv på en poengvariant
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg legger inn <poengtype> selv på en poengvariant
      Og jeg velger å bruke poengene
      Så er verdien jeg la inn for <poengtype>, brukt for poengvarianten
      Og alle poengene på poengvarianten er låst mot automatisk reberegning

      Eksempler:
        | poengtype     |
        | karakterpoeng |
        | realfagspoeng |
        | språkpoeng    |
      # AVKLART 07.10.2026: saksbehandleren kan legge inn realfagspoeng selv
      # på poengvarianten. Det dekker også fag med forsøkskode i R94 (endret 12.11.2026: markeringen av fag i L4a er fjernet).
      # Poengene låses på samme måte som når grunnlaget velges, og kan låses
      # opp med «Låse opp et poeng».
      #
      # AVKLART 21.10.2026: utvidet fra bare realfagspoeng til alle tre
      # poengtypene som vises. Det er alle poengene på poengvarianten som låses, ikke bare
      # poengtypen saksbehandleren la inn. Steget «Og det fremgår at
      # <poengtype> er satt av en saksbehandler» er tatt ut, se «Se hvilket
      # vitnemål et poeng bygger på».
      #
      # Endret 30.10.2026: verdien lagres når saksbehandleren legger den inn,
      # som valget av vitnemål.
      #
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): flyttet hit fra
      # L2 (velge_vitnemål_som_grunnlag.feature). Verdien er en del av
      # grunnlaget, og lagres når saksbehandleren velger å bruke poengene, som
      # resten av grunnlaget (L2, «Poengene beregnes og lagres når
      # saksbehandleren bruker dem»). Erstatter endringen 30.10.2026.

    Scenariomal: Ugyldig verdi for <poengtype> stoppes
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg legger inn en ugyldig verdi for <poengtype> på en poengvariant
      Så ser jeg at verdien er ugyldig
      Og jeg kan ikke bruke poengene før verdien er rettet

      Eksempler:
        | poengtype     |
        | karakterpoeng |
        | realfagspoeng |
        | språkpoeng    |
      # AVKLART 21.10.2026: skjemaet skal stoppe ugyldige verdier, både for
      # realfagspoeng og språkpoeng. Grensene, for eksempel taket på
      # realfagspoeng, står på poengtypen i opptak, så skjemaet må få dem
      # derfra. Utformingen av beskjeden hører i
      # velge_vitnemål_som_grunnlag.design.md.
      #
      # AVKLART 11.11.2026 (gjennomgang med domeneekspertene): flyttet hit fra
      # L2 sammen med «Legge inn <poengtype> selv på en poengvariant», og
      # karakterpoeng er lagt til i eksemplene. Verdien lagres når
      # saksbehandleren bruker poengene, så en ugyldig verdi stopper at
      # poengene kan brukes, som karakterregelen i L4a og L4b.

  Regel: Saksbehandleren kan bare endre fagvalget slik en regel tillater

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    # AVKLART 07.10.2026: vitnemålsbehandleren håndhever at grunnlaget bare
    # endres etter faste regler. Det er de videregående skolene som utsteder
    # vitnemål og avgjør hva som oppfyller vitnemålskravene. Saksbehandleren
    # kan ikke sette sammen et grunnlag søkeren kunne hatt. Vil søkeren ha en
    # annen fagsammensetning, må søkeren kontakte skolen.
    #
    # Regelen er delt mellom L3 og L4a (besluttet 08.10.2026): her står
    # grensene for fagvalget. Tillegg og endringer i karakterer står i
    # endre_fag_i_grunnlaget.feature.

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

    @ref-OPT-BEH-BEH-023
    Scenario: Studiekompetansefag fra andre dokumenter legges inn under tilleggsfag etter 23/6-regelen
      Gitt søkeren rangeres etter 23/6-regelen
      Og søkeren har et elektronisk vitnemål
      Og noen av studiekompetansefagene er dokumentert på andre dokumenter
      Når jeg legger det elektroniske vitnemålet til grunn
      Så kan jeg legge inn studiekompetansefagene fra de andre dokumentene manuelt under tilleggsfag
      # AVKLART 04.11.2026: finnes det et elektronisk vitnemål, legges det til
      # grunn, og studiekompetansefagene fra de andre dokumentene legges inn
      # manuelt under tilleggsfag (L4a, «Legge til et nytt fag under
      # tilleggsfag»). Slik gjør også FS-klienten i grunnlaget for
      # 23/5-regelen (teknisk beskrivelse av vitnemålsbehandling,
      # G. M. Vangen). 23/6-regelen er det eneste stedet der fag kan hentes
      # fritt fra ulike dokumenter. Erstatter «Hente studiekompetansefag fra
      # flere dokumenter etter 23/6-regelen».

    @ref-OPT-BEH-BEH-037
    Scenario: Alle studiekompetansefag legges inn i kalkulatoren etter 23/6-regelen når det ikke finnes elektronisk vitnemål
      Gitt søkeren rangeres etter 23/6-regelen
      Og søkeren ikke har elektroniske vitnemål
      Når jeg setter sammen grunnlaget
      Så legger jeg inn alle studiekompetansefagene manuelt i kalkulatoren
      # AVKLART 04.11.2026: finnes det ikke et elektronisk vitnemål, legges
      # alle fagene inn manuelt i kalkulatoren (L4b).
