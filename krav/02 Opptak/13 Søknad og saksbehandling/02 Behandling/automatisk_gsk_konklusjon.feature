# language: no
# GitHub: #723
#
# Designgrunnlag: Confluence PFS 4825382930 «Automatisk tildeling av
# GSK-konklusjon» og PFS 4920279258 «Gsk-konklusjoner v2 (Steg 1 - sekvensiell
# saksbehandling)». Jira-epic STEK-249.
#
# Vitnemålsveien finnes i fs-plattform (opptak-service, autosak/gsk:
# GskVedtakAutoService, GskVedtakTilbakekallingService), og kjøres som første
# steg i den automatiske saksbehandlingen. Kravet flytter beregningen til når
# søknaden kommer inn, og konklusjonen fra vitnemålet til vitnemålet. Gjenbruk av konklusjoner fra
# tidligere opptak finnes ikke: koden ser bare etter konklusjoner i samme
# opptak. Confluence v2 setter gjenbruksbasen utenfor versjonen. Dette kravet
# tar inn gjenbruk fra tidligere samordna opptak, fra lokale opptak i FS Admin, og
# fra lokale opptak i FS-klienten når konklusjonen er med i oversikten over
# kvalitetssikrede GSK-konklusjoner.
@OPT-BEH-BEH-015 @must @planned
Egenskap: Automatisk GSK-konklusjon
  Som saksbehandler
  ønsker jeg at søknader der søkeren åpenbart har generell studiekompetanse, får GSK-konklusjonen automatisk
  slik at jeg bare trenger å vurdere generell studiekompetanse der grunnlaget ikke er entydig.

  Generell studiekompetanse (GSK) er det generelle opptakskravet til høyere utdanning.
  Når en søknad kommer inn, hentes søkerens vitnemål, og GSK beregnes for hvert
  vitnemål. Konklusjonen lagres på vitnemålet, med grunnlagskoden og tidspunktet
  den ble beregnet. Gir ingen vitnemål GSK, ser systemet etter en positiv konklusjon
  fra et tidligere opptak. Ellers vurderes GSK manuelt. GSK beregnes før den
  automatiske saksbehandlingen, og er ikke et steg i den.
  Automatikken setter aldri en negativ konklusjon, og overskriver aldri en konklusjon
  som finnes. Den gjelder alle opptak, også fagskoleopptak.

  # Fagskoleopptak: avklart 2026-10-13 at automatikken også gjelder fagskoleopptak.
  # Det avviker fra Sikts tolkning i Confluence v2 om at GSK i fagskoleopptak ikke
  # skal lagres som konklusjon, fordi GSK der er et alternativt kompetansekrav.

  @draft @openquestion
  Regel: Konklusjon fra vitnemålet
    # ÅPNE SPØRSMÅL:
    # - Får søknaden også en GSK-konklusjon fra vitnemålet, eller står konklusjonen bare på
    #   vitnemålet? Gjenbruk fra tidligere opptak, manuell endring og annullering gjelder i dag
    #   konklusjonen på søknaden.

    Scenario: Vitnemål som gir generell studiekompetanse
      Gitt at søkeren har et vitnemål som ikke er annullert
      Og at vitnemålet har utstedelsesdato
      Og at løpet på vitnemålet gir generell studiekompetanse
      Og at vitnemålet sier at søkeren har generell studiekompetanse
      Og at vitnemålet består seksfagskontrollen
      Når søknaden kommer inn
      Så har vitnemålet en positiv GSK-konklusjon
      Og grunnlagskoden er grunnlagskoden for løpet på vitnemålet
      Og grunnlagsdatoen er utstedelsesdatoen på vitnemålet

    Scenario: Tidspunktet for beregningen lagres på vitnemålet
      Gitt at søkeren har et vitnemål som gir generell studiekompetanse
      Når søknaden kommer inn 26.10.2026 kl. 10:14
      Så er GSK-konklusjonen på vitnemålet beregnet 26.10.2026 kl. 10:14

    Scenario: Hvert vitnemål får sin egen GSK-konklusjon
      Gitt at søkeren har to vitnemål som ikke er annullert
      Når søknaden kommer inn
      Så er GSK beregnet for begge vitnemålene

    Scenario: Grunnlagskoder som settes automatisk
      Gitt at søkeren har et vitnemål som gir generell studiekompetanse
      Når søknaden kommer inn
      Så er grunnlagskoden i GSK-konklusjonen på vitnemålet en av disse:
        | grunnlagskode | vitnemål                                    | reform |
        | AØA           | allmenne og økonomiske fag                  | R94    |
        | RFA           | andre studieforberedende vitnemål           | R94    |
        | TEK           | teknisk fagskole fra og med 2000            | R94    |
        | KLS           | studieforberedende vitnemål                 | KL     |
        | KLY           | yrkesfaglige vitnemål                       | KL     |

    Scenariomal: Ingen positiv konklusjon fra vitnemålet når <grunn>
      Gitt at <grunn>
      Når søknaden kommer inn
      Så finnes det ingen positiv GSK-konklusjon fra vitnemålet

      Eksempler:
        | grunn                                                         |
        | søkerens eneste dokument er et kompetansebevis                |
        | vitnemålet mangler utstedelsesdato                            |
        | løpet på vitnemålet ikke gir generell studiekompetanse        |
        | vitnemålet ikke sier at søkeren har generell studiekompetanse |
        | vitnemålet ikke består seksfagskontrollen                     |

  Regel: Konklusjon fra tidligere opptak
    # Grunnlagskoder: avklart 2026-10-13 at alle positive konklusjoner kan gjenbrukes,
    # uansett grunnlagskode. Grunnlagskoden kopieres, så den kan være hvilken som helst
    # av kodene i bruk (f.eks. IB, HUT, UTA), også koder som er satt manuelt. Tabellen
    # med fem koder under «Konklusjon fra vitnemålet» gjelder bare vitnemål.

    Scenario: Gjenbruke positiv konklusjon fra tidligere samordna opptak
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkeren har en positiv GSK-konklusjon fra et tidligere samordna opptak
      Når søknaden kommer inn
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden og grunnlagsdatoen er de samme som i den tidligere konklusjonen

    Scenario: Vitnemålet går foran tidligere konklusjon
      Gitt at søkeren har et vitnemål som gir generell studiekompetanse
      Og at søkeren har en positiv GSK-konklusjon fra et tidligere opptak
      Når søknaden kommer inn
      Så bygger søknadens GSK-konklusjon på vitnemålet

    # Negative konklusjoner: avklart 2026-10-13. Overskriver saksbehandleren en positiv
    # konklusjon med «ikke kvalifisert», kopieres den vurderingen aldri, men den stopper
    # gjenbruken av eldre positive konklusjoner. Derfor må negative konklusjoner lagres
    # som konklusjoner. Det avviker fra Confluence v2, der negative konklusjoner bare er
    # mangler og ikke bevares.
    Scenario: Bare den siste tidligere konklusjonen gjenbrukes
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkeren har en positiv GSK-konklusjon fra et opptak i 2024
      Og at søkeren har en negativ GSK-konklusjon fra et opptak i 2025
      Når søknaden kommer inn
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

    Scenario: Negative konklusjoner gjenbrukes ikke
      Gitt at søkeren bare har negative GSK-konklusjoner fra tidligere opptak
      Når søknaden kommer inn
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

    Scenario: Gjenbruke positiv konklusjon fra lokalt opptak
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkerens eneste positive GSK-konklusjon er satt i FS Admin i et lokalt opptak
      Når søknaden kommer inn
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
      Når søknaden kommer inn
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden og grunnlagsdatoen er de samme som i den tidligere konklusjonen

    Scenario: Konklusjon fra FS-klienten som ikke er kvalitetssikret, gjenbrukes ikke
      Gitt at søkerens eneste positive GSK-konklusjon er satt i FS-klienten i et lokalt opptak
      Og at konklusjonen ikke er med i oversikten over kvalitetssikrede GSK-konklusjoner
      Når søknaden kommer inn
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

    Scenario: Konklusjon som bygger på et annullert vitnemål gjenbrukes ikke
      Gitt at søkeren har en positiv GSK-konklusjon fra et avsluttet opptak
      Og at vitnemålet konklusjonen bygger på, er annullert
      Når søknaden kommer inn
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

  Regel: Automatikken setter bare positive konklusjoner, og bare der ingen finnes

    Scenario: Ingen grunnlag for generell studiekompetanse
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkeren ikke har noen positiv GSK-konklusjon fra et tidligere opptak
      Når søknaden kommer inn
      Så får søknaden ingen GSK-konklusjon
      Og generell studiekompetanse vurderes manuelt

    Scenario: Konklusjon på søknaden overskrives ikke
      Gitt at søknaden har en GSK-konklusjon, satt av en hvilken som helst organisasjon i opptaket
      Og at søkeren har et vitnemål som gir generell studiekompetanse
      Når søknaden kommer inn
      Så er GSK-konklusjonen på søknaden uendret

    Scenario: Systemet setter aldri en negativ konklusjon
      Gitt at søkeren ikke har noe grunnlag for generell studiekompetanse
      Når søknaden kommer inn
      Så får søknaden ingen negativ GSK-konklusjon

  # Reglene for manuell endring ligger i grenselandet mellom automatisk og manuell
  # saksbehandling, og kan bli flyttet til et eget krav når kravstrukturen bygges ut.
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

  Regel: Ny vurdering når søkeren får et nytt vitnemål

    Scenario: Nytt vitnemål når søknaden ikke har konklusjon
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når søkeren får et nytt vitnemål
      Så vurderes generell studiekompetanse automatisk på nytt

    Scenario: Nytt vitnemål når søknaden har konklusjon
      Gitt at søknaden har en GSK-konklusjon
      Når søkeren får et nytt vitnemål
      Så er GSK-konklusjonen på søknaden uendret

  Regel: Annullert vitnemål
    # Kilden: vitnemålene hentes fra KREG. Er et vitnemål annullert der, trekkes
    # konklusjonene som bygger på det, tilbake. Det gjelder bare i opptak som ikke er
    # avsluttet. I avsluttede opptak står konklusjonen urørt.
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
      # - Hvordan får systemet vite at et vitnemål er annullert, når søkeren ikke
      #   sender inn eller endrer en søknad? Varsel fra KREG, eller en jevnlig sjekk?
      #   I dag hentes vitnemålene bare når en søknadshendelse behandles.
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

