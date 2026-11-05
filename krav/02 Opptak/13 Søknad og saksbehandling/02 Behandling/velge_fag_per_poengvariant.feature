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

  # AVKLART 03.11.2026: reglene for beregning og lagring står i regelen
  # «Poengene beregnes fortløpende og lagres når grunnlaget er klart» i denne fila
  # (flyttet fra L2 30.10.2026, endret 04.11.2026). Poengene beregnes på nytt
  # hver gang grunnlaget endres, en endring lagres når saksbehandleren velger
  # å lagre grunnlaget, og endringer hører til vitnemålet de er gjort for. Regelen for leserettighet står i
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

  Regel: Fagvalget gjøres per poengvariant

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenario: Velge hvilke fag som skal telle
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg behandler en bestemt poengvariant
      Når jeg velger hvilke fag som skal telle
      Og jeg velger å lagre grunnlaget
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

    @ref-OPT-BEH-BEH-020 @openquestion
    # ÅPNE SPØRSMÅL:
    # - Fagene velges per poengvariant, men kravelementene vurderes per
    #   grunnlag. Hvilke fag legges til grunn for vurderingen når
    #   poengvariantene på samme grunnlag har ulikt fagvalg?
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

    Scenario: Ingen poeng lagres for en poengvariant der søkeren ikke er kvalifisert
      Gitt søkeren oppfyller ikke de spesielle opptakskravene på grunnlaget en poengvariant hører til
      Når jeg velger å lagre grunnlaget
      Så ser jeg at søkeren ikke er kvalifisert på grunnlaget
      Og poengene for poengvarianten er ikke lagret
      # AVKLART 05.11.2026: poengene lagres ikke for en poengvariant der
      # søkeren ikke oppfyller de spesielle opptakskravene, slik FS-klienten
      # gjør (teknisk beskrivelse av vitnemålsbehandling, G. M. Vangen).
      # Besvart av Marit Bjørnerud Rønning og Ingrid Grimstad Helset på siden
      # med åpne spørsmål 04.11.2026. Kvalifiseringen avgjøres per grunnlag
      # (avklart 05.11.2026, «Kravelementene vurderes per grunnlag»).

    Scenario: Bruke fagvalget fra én poengvariant i andre poengvarianter
      Gitt jeg har valgt fagene i én poengvariant
      Når jeg velger å bruke det samme fagvalget i de andre poengvariantene
      Så har de andre poengvariantene det samme fagvalget
      Men tilleggsfag er ikke valgt i poengvarianten for kvoten for førstegangsvitnemål
      # AVKLART 04.11.2026: saksbehandleren kan bruke fagvalget fra én
      # poengvariant i de andre, så det ikke må gjøres på nytt i hver av dem.
      # Kvoteregelen gjelder fortsatt: tilleggsfag blir ikke valgt i
      # poengvarianten for kvoten for førstegangsvitnemål. Forslaget kom fra
      # FS-klienten, som kan kopiere en beregning til andre poengvarianter og
      # grunnlag (teknisk beskrivelse av vitnemålsbehandling, G. M. Vangen).

    # AVKLART 04.11.2026: tilleggsfag som saksbehandleren legger til for hånd
    # (L4a, «Legge til et nytt fag under tilleggsfag»), følger de samme
    # reglene som tilleggsfagene som står på vitnemålet: de teller ikke før
    # de er valgt i en poengvariant, og kan ikke velges i kvoten for
    # førstegangsvitnemål, med de samme unntakene.
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
      # poengvarianten for førstegangsvitnemål. Det dekkes av dette
      # scenarioet.
      #
      # AVKLART 04.11.2026: «Et vitnemål gjelder ikke alle poengvarianter» er
      # fjernet. Det bygde på at tabellen POENGVARIANTVITNEMAL i FS-klienten
      # sier hvilke vitnemål som gjelder for hver poengvariant. Ifølge den
      # tekniske beskrivelsen av vitnemålsbehandling (G. M. Vangen) lagrer
      # tabellen bare hvilket vitnemål saksbehandleren har valgt. Den eneste
      # regelen er kvoteregelen i dette scenarioet.
      #
      # Bekreftet i den tekniske beskrivelsen av vitnemålsbehandling i
      # FS-klienten (G. M. Vangen, lest 03.11.2026): grunnlaget VOV tillater
      # ikke tillegg («Det er ikke anledning å velge tillegg for grunnlag
      # VOV»).

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

  @draft @openquestion
  Regel: Kravelementene vurderes i samme bilde som fagene
    # ÅPNE SPØRSMÅL:
    # - Er scenarioene riktige? Regelen er skrevet etter avklaringen
    #   05.11.2026, og er ikke gått gjennom ennå.
    # - Skissen «Steg 2 Grunnlag – behandle e-vitnemål» har allerede en
    #   seksjon «Spesielle opptakskrav» nederst i steg 2, med kravelement,
    #   grunnlag, «Dekker kravet?», «La stå», resultat og «Vis per grunnlag».
    #   Den er grå i skissen. Betyr det at den ikke er med, eller at den er
    #   deaktivert? Avklares med designeren.

    # AVKLART 05.11.2026: kravelementene vurderes i samme bilde som fagene,
    # under «2. Grunnlag», både for elektroniske og manuelt innlagte
    # vitnemål, så saksbehandleren slipper å klikke fram og tilbake.
    # «3. Spesielle opptakskrav» viser det som er vurdert i steg 2. Innspill
    # fra Ingrid Grimstad Helset på siden med åpne spørsmål 05.11.2026.
    # Erstatter avklaringen 03.11.2026 om at kravelementene bare vurderes
    # under spesielle opptakskrav. Hvordan saksbehandleren overstyrer
    # vurderingen, står i automatisk_kvalifisering.feature
    # (@OPT-BEH-BEH-020) og i L4a («Saksbehandleren kan overstyre
    # kontrollmotoren for et fag»).

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenario: Vurdere kravelementene i grunnlaget
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg ser grunnlaget på søknaden
      Så ser jeg kravelementene for hvert grunnlag sammen med fagene
      Og jeg kan vurdere kravelementene uten å gå til spesielle opptakskrav

    Scenario: Spesielle opptakskrav viser vurderingen fra grunnlaget
      Gitt jeg har vurdert et kravelement i grunnlaget
      Når jeg går til spesielle opptakskrav
      Så ser jeg vurderingen jeg gjorde i grunnlaget

  Regel: Poengene beregnes fortløpende og lagres når grunnlaget er klart

    # Poengene beregnes av kontrollmotoren i opptak, i samme løsning. Når
    # saksbehandleren setter sammen grunnlaget (poengvariant, fag, forbedringer
    # og tilleggsfag), beregnes poengene på nytt hver gang grunnlaget endres,
    # så saksbehandleren ser virkningen av hver endring. Grunnlaget og
    # poengene lagres først når saksbehandleren velger å lagre grunnlaget, så
    # sakens poeng aldri bygger på et grunnlag som er halvveis satt sammen.
    #
    # Flyttet hit fra L2 (velge_vitnemål_som_grunnlag.feature) 30.10.2026. I
    # L2 beregnes og lagres poengene med en gang saksbehandleren velger et
    # vitnemål.
    #
    # AVKLART 04.11.2026: det er ingen egen handling for å beregne poengene.
    # De beregnes automatisk hver gang grunnlaget endres, og saksbehandleren
    # lagrer grunnlaget med en egen handling. Det erstatter avklaringen fra
    # 21.10.2026 om at poengene står tomme til saksbehandleren velger å
    # beregne dem, og gjelder også L4a og L4b. FS-klienten skiller på samme
    # måte mellom å beregne («Beregn») og å ta poengene i bruk («Bruk
    # BeregnP») (teknisk beskrivelse av vitnemålsbehandling, G. M. Vangen).
    # Scenarioene «Poengene er tomme til jeg beregner dem» og «Beregne
    # poengene fra det endrede grunnlaget» er erstattet av de to første
    # scenarioene under.

    Scenario: Poengene beregnes når grunnlaget endres
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg endrer grunnlaget for en poengvariant
      Så er poengene på poengvarianten beregnet på nytt fra det endrede grunnlaget
      Men endringen i grunnlaget er ikke lagret ennå

    Scenario: Lagre grunnlaget
      Gitt jeg har endret grunnlaget for en poengvariant
      Når jeg velger å lagre grunnlaget
      Så er endringen i grunnlaget lagret
      Og poengene på poengvarianten er lagret

    Scenario: Advarsel om endringer som ikke er lagret
      Gitt jeg har endret grunnlaget for en poengvariant
      Og jeg har ikke lagret grunnlaget etter endringen
      Når jeg går fra saken
      Så blir jeg advart om at endringen i grunnlaget ikke er lagret
      Og jeg kan velge å bli på saken
      # AVKLART 21.10.2026: saksbehandleren skal advares før de forlater
      # saken med endringer som ikke er lagret. Utformingen av advarselen
      # hører i implementasjonsdetaljene.
      #
      # Endret 04.11.2026: endringen lagres når saksbehandleren velger å
      # lagre grunnlaget, ikke når poengene beregnes.

    Scenario: Grunnlaget kontrolleres mot vitnemålskravene når det lagres
      Gitt jeg har endret grunnlaget
      Og grunnlaget oppfyller ikke vitnemålskravene
      Når jeg velger å lagre grunnlaget
      Så ser jeg at grunnlaget ikke oppfyller vitnemålskravene
      Og jeg kan velge å lagre grunnlaget likevel
      # Forslag fra FS-klienten (teknisk beskrivelse av vitnemålsbehandling,
      # G. M. Vangen, lest 03.11.2026): «Bruk BeregnP» kjører NVB-kontrollen
      # på vitnemålet slik saksbehandleren har endret det, og spør om
      # poengene skal lagres når kontrollen feiler.
      #
      # AVKLART 04.11.2026: grunnlaget kontrolleres mot vitnemålskravene når
      # saksbehandleren lagrer det. Feiler kontrollen, ser saksbehandleren
      # hvorfor, og kan velge å lagre grunnlaget likevel, for eksempel ved
      # dispensasjon.

    Scenario: Kontrollere grunnlaget mot vitnemålskravene uten å lagre
      Gitt jeg har endret grunnlaget
      Når jeg velger å kontrollere grunnlaget mot vitnemålskravene
      Så ser jeg om grunnlaget oppfyller vitnemålskravene
      Men endringen i grunnlaget er ikke lagret ennå
      # AVKLART 04.11.2026: saksbehandleren kan kontrollere grunnlaget med en
      # egen handling, uten å lagre, som med «NVB-kontroll» i FS-klienten
      # (teknisk beskrivelse av vitnemålsbehandling, G. M. Vangen).

    Scenario: Advarsel om vitnemål med dispensasjon
      Gitt søkeren har et vitnemål som er utstedt med dispensasjon
      Når jeg legger vitnemålet til grunn
      Så ser jeg at vitnemålet er utstedt med dispensasjon
      Og jeg kan lagre grunnlaget
      # Forslag fra FS-klienten (samme kilde): et vitnemål med dispensasjon
      # gir advarselen «Dette er et vitnemål med dispensasjon», og
      # behandlingen fortsetter.
      #
      # AVKLART 04.11.2026: saksbehandleren advares når vitnemålet er utstedt
      # med dispensasjon, men advarselen stopper ingenting. Den forklarer
      # hvorfor kontrollen mot vitnemålskravene kan feile. Teksten hører i
      # implementasjonsdetaljene.

    Scenariomal: Velge om <poengtype> jeg har lagt inn selv, skal beholdes
      Gitt jeg har lagt inn <poengtype> selv på en poengvariant
      Når jeg endrer grunnlaget for poengvarianten
      Så ser jeg at <poengtype> jeg la inn selv, vil bli overskrevet av de beregnede poengene
      Og jeg kan velge å beholde <poengtype> jeg la inn selv

      Eksempler:
        | poengtype     |
        | karakterpoeng |
        | realfagspoeng |
        | språkpoeng    |
      # Spørsmålet kom fra domeneekspertene 22.10.2026: en lagret verdi skal
      # ikke overstyres av automatikken, men når saksbehandleren aktivt endrer
      # grunnlaget, må systemet kunne overstyre den. Flyttet hit fra L2
      # 30.10.2026.
      #
      # AVKLART 04.11.2026: saksbehandleren blir spurt, ser at verdien
      # saksbehandleren la inn selv, vil bli overskrevet av poengene som
      # beregnes fra det endrede grunnlaget, og velger om den skal beholdes. Erstatter «Poeng
      # jeg har lagt inn selv, når poengene beregnes på nytt». Låsen mot den
      # automatiske poengberegningen gjelder fortsatt (L2).

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
