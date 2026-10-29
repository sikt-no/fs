# language: no
# GitHub: #723
#
# Designgrunnlag: Confluence PFS 4825382930 «Automatisk tildeling av
# GSK-konklusjon» og PFS 4920279258 «Gsk-konklusjoner v2 (Steg 1 - sekvensiell
# saksbehandling)». Jira-epic STEK-249.
#
# Vitnemålsveien finnes i fs-plattform (opptak-service, autosak/gsk:
# GskVedtakAutoService, GskVedtakTilbakekallingService), og kjøres som første
# steg i den automatiske saksbehandlingen. Kravet flytter beregningen til
# vitnemålsimporten, og lagrer opptakssystemets egen påstand om GSK på vitnemålet.
# Påstanden fra KREG brukes ikke lenger. Dette kravet tar inn gjenbruk fra
# saksbehandlingen i tidligere samordna opptak, fra lokale opptak i FS Admin, og fra
# lokale opptak i FS-klienten når konklusjonen er med i oversikten over
# kvalitetssikrede GSK-konklusjoner.
#
# Gjenbruk i 2027-opptaket (STEK-442): det er ikke avklart hvordan gjenbruksdata skal
# organiseres i produktområdet. For 2027 lastes GSK-konklusjonene og annulleringene
# fra det gamle opptakssystemet (gjenbrukstabellene i SODA, det vil si tabellene gskvedtak
# og gskvedtakannullering) inn i midlertidige gjenbrukstabeller før opptaket. De er
# konklusjoner fra tidligere opptak i dette kravet. Tabellene fjernes etter
# 2027-opptaket.
@OPT-BEH-BEH-015 @must @planned
Egenskap: Automatisk GSK-konklusjon
  Som saksbehandler
  ønsker jeg at søknader der søkeren åpenbart har generell studiekompetanse, får GSK-konklusjonen automatisk
  slik at jeg bare trenger å vurdere generell studiekompetanse der grunnlaget ikke er entydig.

  Generell studiekompetanse (GSK) er det generelle opptakskravet til høyere utdanning.
  Når søkerens vitnemål importeres fra KREG til opptakssystemet, beregner opptakssystemet
  sin egen påstand om GSK for hvert vitnemål, uavhengig av påstanden fra KREG. Påstanden,
  ja eller nei, lagres på opptakssystemets kopi av vitnemålet, sammen med tidspunktet den
  ble beregnet og hvilken beregning som ble brukt. Er påstanden ja, lagres også
  grunnlagskoden. Hvordan påstanden og grunnlagskoden beregnes, står i OPT-BEH-BEH-027.

  Påstanden brukes i saksbehandlingen i alle aktive opptak. «Importeres» betyr i
  dette kravet alltid at opptakssystemet henter vitnemålet fra KREG (OPT-BEH-BEH-030),
  ikke at vitnemålet kommer inn i KREG. Søknader som ikke har en GSK-konklusjon, får en
  positiv konklusjon når et vitnemål har påstanden GSK. Vitnemål importeres fra KREG når
  søknaden opprettes, og når KREG får nye vitnemål for en søker med aktive søknader. Når
  søknaden opprettes, importeres vitnemålene fra KREG først. Gir ingen av dem GSK, ser
  systemet etter en positiv konklusjon fra et tidligere opptak. Ellers vurderes GSK
  manuelt. Den automatiske saksbehandlingen setter også konklusjonen, som første steg, på
  søknadene i opptaket som ikke har en. Påstanden på vitnemålet beregnes ikke på nytt da.
  Automatikken setter aldri en negativ konklusjon på søknaden, og overskriver aldri en
  konklusjon som finnes. Den gjelder alle opptak, også fagskoleopptak.

  # Fagskoleopptak: avklart 2026-10-13 at automatikken også gjelder fagskoleopptak.
  # Det avviker fra Sikts tolkning i Confluence v2 om at GSK i fagskoleopptak ikke
  # skal lagres som konklusjon, fordi GSK der er et alternativt kompetansekrav.

  @ref-FLY-OPT-AUT-001 @depends-on-OPT-BEH-BEH-027 @ref-FLY-OPT-VIT-001
  @openquestion
  Regel: Opptakssystemets påstand om GSK på vitnemålet
    # ÅPNE SPØRSMÅL:
    # - Innspill i PR #857: importen skal også ta vare på påstanden om GSK fra «systemet
    #   i videregående skole». Hvilket system er det, og kommer påstanden fra KREG eller
    #   fra en annen kilde? Påstanden fra KREG tas vare på i OPT-BEH-BEH-030.
    # Hvordan GSK beregnes for vitnemålet (seksfagskontrollen og grunnlagskoden), står der.

    Scenario: Vitnemål som gir generell studiekompetanse
      Gitt at søkeren har et vitnemål som ikke er annullert
      Og at vitnemålet har utstedelsesdato
      Og at løpet på vitnemålet gir generell studiekompetanse
      Og at vitnemålet består seksfagskontrollen
      Når vitnemålet importeres fra KREG 26.10.2026 kl. 10:14
      Så har vitnemålet påstanden at søkeren har generell studiekompetanse
      Og grunnlagskoden er grunnlagskoden for løpet på vitnemålet
      Og grunnlagsdatoen er utstedelsesdatoen på vitnemålet
      Og påstanden er beregnet 26.10.2026 kl. 10:14
      Og påstanden viser hvilken beregning i kontrollmotoren som ble brukt

    Scenario: Påstanden fra KREG brukes ikke
      # Koden (GskVedtakAutoService) krever i dag at KREG sier GSK. Det skal fjernes.
      Gitt at søkeren har et vitnemål som gir generell studiekompetanse
      Og at påstanden fra KREG er at søkeren ikke har generell studiekompetanse
      Når vitnemålet importeres fra KREG
      Så har vitnemålet påstanden at søkeren har generell studiekompetanse

    Scenario: Hvert vitnemål får sin egen påstand
      Gitt at søkeren har to vitnemål som ikke er annullert
      Når vitnemålene importeres fra KREG
      Så har begge vitnemålene en påstand om generell studiekompetanse

    Scenario: Grunnlagskoder som settes automatisk
      Gitt at søkeren har et vitnemål som gir generell studiekompetanse
      Når vitnemålet importeres fra KREG
      Så er grunnlagskoden i påstanden på vitnemålet en av disse:
        | grunnlagskode | vitnemål                                    | reform |
        | AØA           | allmenne og økonomiske fag                  | R94    |
        | RFA           | andre studieforberedende vitnemål           | R94    |
        | TEK           | teknisk fagskole fra og med 2000            | R94    |
        | KLS           | studieforberedende vitnemål                 | KL     |
        | KLY           | yrkesfaglige vitnemål                       | KL     |

    Scenariomal: Påstanden er at søkeren ikke har GSK når <grunn>
      Gitt at <grunn>
      Når vitnemålet importeres fra KREG
      Så har vitnemålet påstanden at søkeren ikke har generell studiekompetanse
      Og påstanden har ingen grunnlagskode

      Eksempler:
        | grunn                                                  |
        | vitnemålet mangler utstedelsesdato                     |
        | løpet på vitnemålet ikke gir generell studiekompetanse |
        | vitnemålet ikke består seksfagskontrollen              |

    Scenario: Annullert vitnemål får ingen påstand
      Gitt at søkeren har et annullert vitnemål
      Når vitnemålet importeres fra KREG
      Så har vitnemålet ingen påstand om generell studiekompetanse

    Scenario: Kompetansebevis får ingen påstand
      Gitt at søkerens eneste dokument er et kompetansebevis
      Når kompetansebeviset importeres fra KREG
      Så har kompetansebeviset ingen påstand om generell studiekompetanse

  @ref-FLY-OPT-AUT-001 @ref-FLY-OPT-VIT-001
  Regel: Konklusjon på søknaden fra vitnemålet

    Scenario: Søknaden får konklusjonen fra vitnemålet
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål med påstanden at søkeren har GSK
      Når vitnemålet importeres fra KREG
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden og grunnlagsdatoen er de samme som i påstanden

    Scenario: Påstanden om at søkeren ikke har GSK gir ingen konklusjon
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkerens eneste vitnemål har påstanden at søkeren ikke har GSK
      Når vitnemålet importeres fra KREG
      Så får søknaden ingen GSK-konklusjon fra vitnemålet

    Scenario: Vitnemålet med senest utstedelsesdato brukes
      Gitt at søkeren har to vitnemål med påstanden at søkeren har GSK
      Når vitnemålene importeres fra KREG
      Så bygger søknadens GSK-konklusjon på vitnemålet med senest utstedelsesdato

    Scenario: Alle søknader uten konklusjon oppdateres
      Gitt at søkeren har en søknad uten GSK-konklusjon og en søknad med GSK-konklusjon
      Og at opptakene ikke er avsluttet
      Når et vitnemål med påstanden at søkeren har GSK importeres fra KREG
      Så får søknaden uten konklusjon en positiv GSK-konklusjon
      Og GSK-konklusjonen på den andre søknaden er uendret

    Scenario: Søknader i avsluttede opptak oppdateres ikke
      Gitt at søkeren har en søknad uten GSK-konklusjon i et avsluttet opptak
      Når et vitnemål med påstanden at søkeren har GSK importeres fra KREG
      Så får søknaden ingen GSK-konklusjon

    @openquestion
    Scenario: Nytt vitnemål fra KREG etter at søknaden er opprettet
      # ÅPNE SPØRSMÅL:
      # - Hvordan FS-opptak abonnerer på endringer i KREG for aktive søkere, er ikke
      #   besluttet. Det settes opp i en egen sak.
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at opptaket ikke er avsluttet
      Når KREG får et nytt vitnemål for søkeren
      Så importeres vitnemålet fra KREG
      Og GSK beregnes for vitnemålet uten at noen starter det

  @ref-FLY-OPT-AUT-001
  Regel: Konklusjon fra tidligere opptak
    # Grunnlagskoder: avklart 2026-10-13 at alle positive konklusjoner kan gjenbrukes,
    # uansett grunnlagskode. Grunnlagskoden kopieres, så den kan være hvilken som helst
    # av kodene i bruk (f.eks. IB, HUT, UTA), også koder som er satt manuelt. Tabellen
    # med fem koder under «Opptakssystemets påstand om GSK på vitnemålet» gjelder bare
    # vitnemål.

    # Kildekoder: avklart 2026-10-27 at alle rader i gjenbruksbasen kan gjenbrukes i 2027,
    # både NOM (samordna opptak, 1997–2026) og IMM (1907–2001).
    Scenario: Gjenbruke positiv konklusjon fra tidligere samordna opptak
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkeren har en positiv GSK-konklusjon fra et tidligere samordna opptak
      Når søknaden opprettes
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden og grunnlagsdatoen er de samme som i den tidligere konklusjonen

    Scenario: Vitnemålet går foran tidligere konklusjon
      Gitt at søkeren har et vitnemål som gir generell studiekompetanse
      Og at søkeren har en positiv GSK-konklusjon fra et tidligere opptak
      Når søknaden opprettes
      Så bygger søknadens GSK-konklusjon på vitnemålet

    # Negative konklusjoner: avklart 2026-10-13. Overskriver saksbehandleren en positiv
    # konklusjon med «ikke kvalifisert», kopieres den vurderingen aldri, men den stopper
    # gjenbruken av eldre positive konklusjoner. Derfor må negative konklusjoner lagres
    # som konklusjoner. Det avviker fra Confluence v2, der negative konklusjoner bare er
    # mangler og ikke bevares.
    # Den siste konklusjonen: avklart 2026-10-26 at det er konklusjonen som ble satt
    # sist, også når søkeren har flere konklusjoner fra samme år og termin, fra ulike
    # organisasjoner.
    Scenario: Bare den siste tidligere konklusjonen gjenbrukes
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkeren har en positiv GSK-konklusjon fra et opptak i 2024
      Og at søkeren har en negativ GSK-konklusjon fra et opptak i 2025
      Når søknaden opprettes
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

    Scenario: Negative konklusjoner gjenbrukes ikke
      Gitt at søkeren bare har negative GSK-konklusjoner fra tidligere opptak
      Når søknaden opprettes
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

    Scenario: Gjenbruke positiv konklusjon fra lokalt opptak
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkerens eneste positive GSK-konklusjon er satt i FS Admin i et lokalt opptak
      Når søknaden opprettes
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden og grunnlagsdatoen er de samme som i den tidligere konklusjonen

    @openquestion
    Scenario: Gjenbruke kvalitetssikret konklusjon fra FS-klienten
      # ÅPNE SPØRSMÅL:
      # - Hva heter oversikten over kvalitetssikrede GSK-konklusjoner, og hvor ligger den?
      #   Det er en egen sak, som skal ses på senere.
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkerens eneste positive GSK-konklusjon er satt i FS-klienten i et lokalt opptak
      Og at konklusjonen er med i oversikten over kvalitetssikrede GSK-konklusjoner
      Når søknaden opprettes
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden og grunnlagsdatoen er de samme som i den tidligere konklusjonen

    @draft @openquestion
    Scenario: Annullert konklusjon gjenbrukes ikke
      # ÅPNE SPØRSMÅL:
      # - En annullering kan gjelde fra en dato fram i tid. Gjenbrukes konklusjonen fram til den datoen?
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkerens eneste positive GSK-konklusjon fra et tidligere opptak er annullert
      Når søknaden opprettes
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

    # Gjelder bare konklusjoner som vet hvilket vitnemål de bygger på. Konklusjonene fra
    # gjenbruksbasen gjør ikke det. For dem er det annulleringene i gjenbruksbasen som
    # gjelder (se «Annullert konklusjon gjenbrukes ikke»).
    Scenario: Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke
      Gitt at søkeren har en positiv GSK-konklusjon fra et avsluttet opptak
      Og at vitnemålet konklusjonen bygger på, er annullert
      Når søknaden opprettes
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

  @ref-FLY-OPT-AUT-001
  Regel: Automatikken setter bare positive konklusjoner, og bare der ingen finnes

    Scenario: Ingen grunnlag for generell studiekompetanse
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkeren ikke har noen positiv GSK-konklusjon fra et tidligere opptak
      Når søknaden opprettes
      Så får søknaden ingen GSK-konklusjon
      Og generell studiekompetanse vurderes manuelt

    Scenario: Konklusjon på søknaden overskrives ikke
      Gitt at søknaden har en GSK-konklusjon, satt av en hvilken som helst organisasjon i opptaket
      Og at søkeren har et vitnemål som gir generell studiekompetanse
      Når vitnemålet importeres fra KREG
      Så er GSK-konklusjonen på søknaden uendret

    Scenario: Systemet setter aldri en negativ konklusjon
      Gitt at søkeren ikke har noe grunnlag for generell studiekompetanse
      Når søknaden opprettes
      Så får søknaden ingen negativ GSK-konklusjon

  @ref-FLY-OPT-AUT-001
  Regel: GSK-konklusjonen settes også når den automatiske behandlingen kjører
    # Første steg når den automatiske behandlingen kjører for et opptak. Konklusjonen settes
    # etter de samme reglene som når vitnemålet importeres fra KREG: vitnemålet går foran tidligere
    # konklusjoner, bare den siste tidligere konklusjonen gjenbrukes, og en konklusjon som
    # finnes, overskrives ikke. Påstanden på vitnemålet beregnes ikke på nytt.
    # Etter prosesstegningen «GSK-beregning for gitt opptak» (2026-10-29).

    Scenario: Søknaden får konklusjonen fra vitnemålet i den automatiske behandlingen
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål med påstanden at søkeren har GSK
      Når den automatiske behandlingen kjører for opptaket
      Så får søknaden en positiv GSK-konklusjon

    Scenario: Søknaden får konklusjonen fra et tidligere opptak i den automatiske behandlingen
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at ingen av søkerens vitnemål har påstanden at søkeren har GSK
      Og at den siste GSK-konklusjonen søkeren har fra et tidligere opptak, er positiv
      Når den automatiske behandlingen kjører for opptaket
      Så får søknaden en positiv GSK-konklusjon

    Scenario: Konklusjonen overskrives ikke i den automatiske behandlingen
      Gitt at søknaden har en GSK-konklusjon
      Når den automatiske behandlingen kjører for opptaket
      Så er GSK-konklusjonen på søknaden uendret

  # Reglene for manuell endring ligger i grenselandet mellom automatisk og manuell
  # saksbehandling, og kan bli flyttet til et eget krav når kravstrukturen bygges ut.
  # At saksbehandleren ser søkerens tidligere GSK-konklusjoner og henter én inn i
  # opptaket når automatikken ikke har satt noen (STEK-443), skal bli et eget krav.
  Regel: Saksbehandleren endrer GSK-konklusjonen

    Scenario: Overskrive positiv konklusjon med negativ konklusjon
      Gitt at søknaden har en positiv GSK-konklusjon
      Når saksbehandleren setter en negativ GSK-konklusjon
      Så er GSK-konklusjonen på søknaden negativ

    Scenario: Legge til positiv konklusjon når ingen finnes
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren legger til en positiv GSK-konklusjon
      Så er GSK-konklusjonen på søknaden positiv

    Scenario: Bare positive konklusjoner kan legges til når ingen finnes
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren legger til en GSK-konklusjon
      Så kan saksbehandleren bare velge positive GSK-konklusjoner

  @ref-FLY-OPT-VIT-001
  Regel: Annullert vitnemål
    # Kilden: vitnemålene hentes fra KREG. Er et vitnemål annullert der, trekkes
    # konklusjonene som bygger på det, tilbake. Det gjelder bare i opptak som ikke er
    # avsluttet. I avsluttede opptak står konklusjonen urørt.
    # Konklusjoner fra gjenbruksbasen (STEK-442) vet ikke hvilket vitnemål de bygger på,
    # og trekkes ikke tilbake etter denne regelen. For dem er det annulleringene i
    # gjenbruksbasen som gjelder.
    # Melding til søkeren: avklart 2026-10-13 at søkeren ikke får egen beskjed om at
    # konklusjonen er trukket tilbake. Søkeren får vite det gjennom resultatet av
    # saksbehandlingen.

    Scenario: Automatisk konklusjon trekkes tilbake når vitnemålet annulleres
      Gitt at søknaden har en automatisk GSK-konklusjon som bygger på et vitnemål
      Og at opptaket ikke er avsluttet
      Og at ingen har låst eller endret konklusjonen manuelt
      Når vitnemålet annulleres
      Så er konklusjonen ikke lenger positiv
      Og konklusjonen viser at vitnemålet den bygde på, er annullert

    Scenario: Gjenbrukt konklusjon trekkes tilbake når vitnemålet annulleres
      Gitt at søknaden har en GSK-konklusjon som er gjenbrukt fra et tidligere opptak
      Og at den tidligere konklusjonen bygger på et vitnemål
      Og at opptaket ikke er avsluttet
      Og at ingen har låst eller endret den gjenbrukte konklusjonen manuelt
      Når vitnemålet annulleres
      Så er den gjenbrukte konklusjonen ikke lenger positiv
      Og den gjenbrukte konklusjonen viser at vitnemålet den bygde på, er annullert

    Scenario: Konklusjon i avsluttet opptak trekkes ikke tilbake
      Gitt at søknaden har en automatisk GSK-konklusjon som bygger på et vitnemål
      Og at opptaket er avsluttet
      Når vitnemålet annulleres
      Så er GSK-konklusjonen på søknaden uendret

    @openquestion
    Scenario: Annulleringen oppdages uten at søkeren endrer søknaden
      # ÅPNE SPØRSMÅL:
      # - Hvordan FS-opptak abonnerer på endringer i KREG for aktive søkere, er ikke
      #   besluttet. Det settes opp i en egen sak. I dag hentes vitnemålene bare når en
      #   søknadshendelse behandles.
      Gitt at søknaden har en automatisk GSK-konklusjon som bygger på et vitnemål
      Og at opptaket ikke er avsluttet
      Og at søkeren ikke har sendt inn eller endret søknaden etter at konklusjonen ble satt
      Når vitnemålet annulleres i KREG
      Så er konklusjonen ikke lenger positiv

  Regel: Sporbarhet
    # Søkerens innsyn: avklart 2026-10-13 at det er utenfor dette kravet om søkeren
    # skal kunne se om GSK-konklusjonen er satt automatisk eller manuelt. Søkeren kan
    # klage som vanlig, uansett om behandlingen var automatisk.

    Scenario: Se hva den automatiske konklusjonen bygger på
      Gitt at søknaden har fått GSK-konklusjonen automatisk
      Når saksbehandleren ser på GSK-konklusjonen
      Så ser saksbehandleren at konklusjonen er satt automatisk
      Og saksbehandleren ser om konklusjonen bygger på et vitnemål eller et tidligere opptak

    Scenario: Se hvilket opptak en gjenbrukt konklusjon kommer fra
      Gitt at søknaden har fått en GSK-konklusjon som er gjenbrukt fra et tidligere opptak
      Når saksbehandleren ser på GSK-konklusjonen
      Så ser saksbehandleren hvilket opptak konklusjonen kommer fra

