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
# tidligere samordna opptak, fra lokale opptak i FS Admin, og fra lokale opptak i
# FS-klienten når konklusjonen er med i oversikten over kvalitetssikrede
# GSK-konklusjoner.
#
# Gjenbruk i 2027-opptaket (STEK-442): det er ikke avklart hvordan gjenbruksdata skal
# organiseres i produktområdet. For 2027 lastes GSK-konklusjonene og annulleringene
# fra det gamle opptakssystemet (gjenbruksbasen i SODA, tabellene gskvedtak og
# gskvedtakannullering) inn i midlertidige gjenbrukstabeller før opptaket. De er
# konklusjoner fra tidligere opptak i dette kravet. Tabellene fjernes etter
# 2027-opptaket.
@OPT-BEH-BEH-015 @must @planned
Egenskap: Automatisk GSK-konklusjon
  Som saksbehandler
  ønsker jeg at søknader der søkeren åpenbart har generell studiekompetanse, får GSK-konklusjonen automatisk
  slik at jeg bare trenger å vurdere generell studiekompetanse der grunnlaget ikke er entydig.

  Generell studiekompetanse (GSK) er det generelle opptakskravet til høyere utdanning.
  Når søkerens vitnemål importeres, beregner opptakssystemet sin egen påstand om GSK
  for hvert vitnemål, uavhengig av påstanden fra KREG. Påstanden lagres på vitnemålet,
  med grunnlagskoden og tidspunktet den ble beregnet, og gjelder i alle opptak.
  Søknader som ikke har en GSK-konklusjon, får en positiv konklusjon når et vitnemål
  har påstanden GSK. Når søknaden opprettes, importeres vitnemålene først. Gir ingen av
  dem GSK, ser systemet etter en positiv konklusjon fra et tidligere opptak. Ellers
  vurderes GSK manuelt. Dette er en del av vitnemålsimporten, ikke av den automatiske
  saksbehandlingen.
  Automatikken setter aldri en negativ konklusjon på søknaden, og overskriver aldri en
  konklusjon som finnes. Den gjelder alle opptak, også fagskoleopptak.

  # Fagskoleopptak: avklart 2026-10-13 at automatikken også gjelder fagskoleopptak.
  # Det avviker fra Sikts tolkning i Confluence v2 om at GSK i fagskoleopptak ikke
  # skal lagres som konklusjon, fordi GSK der er et alternativt kompetansekrav.

  Regel: Opptakssystemets påstand om GSK på vitnemålet

    Scenario: Vitnemål som gir generell studiekompetanse
      Gitt at søkeren har et vitnemål som ikke er annullert
      Og at vitnemålet har utstedelsesdato
      Og at løpet på vitnemålet gir generell studiekompetanse
      Og at vitnemålet består seksfagskontrollen
      Når vitnemålet importeres 26.10.2026 kl. 10:14
      Så har vitnemålet påstanden at søkeren har generell studiekompetanse
      Og grunnlagskoden er grunnlagskoden for løpet på vitnemålet
      Og grunnlagsdatoen er utstedelsesdatoen på vitnemålet
      Og påstanden er beregnet 26.10.2026 kl. 10:14

    Scenario: Påstanden fra KREG brukes ikke
      # Koden (GskVedtakAutoService) krever i dag at KREG sier GSK. Det skal fjernes.
      Gitt at søkeren har et vitnemål som gir generell studiekompetanse
      Og at påstanden fra KREG er at søkeren ikke har generell studiekompetanse
      Når vitnemålet importeres
      Så har vitnemålet påstanden at søkeren har generell studiekompetanse

    Scenario: Hvert vitnemål får sin egen påstand
      Gitt at søkeren har to vitnemål som ikke er annullert
      Når vitnemålene importeres
      Så har begge vitnemålene en påstand om generell studiekompetanse

    Scenario: Grunnlagskoder som settes automatisk
      Gitt at søkeren har et vitnemål som gir generell studiekompetanse
      Når vitnemålet importeres
      Så er grunnlagskoden i påstanden på vitnemålet en av disse:
        | grunnlagskode | vitnemål                                    | reform |
        | AØA           | allmenne og økonomiske fag                  | R94    |
        | RFA           | andre studieforberedende vitnemål           | R94    |
        | TEK           | teknisk fagskole fra og med 2000            | R94    |
        | KLS           | studieforberedende vitnemål                 | KL     |
        | KLY           | yrkesfaglige vitnemål                       | KL     |

    @openquestion
    Scenariomal: Påstanden er at søkeren ikke har GSK når <grunn>
      # ÅPNE SPØRSMÅL:
      # - Får et kompetansebevis påstanden at søkeren ikke har GSK, eller ingen påstand?
      Gitt at <grunn>
      Når vitnemålet importeres
      Så har vitnemålet påstanden at søkeren ikke har generell studiekompetanse

      Eksempler:
        | grunn                                                  |
        | vitnemålet mangler utstedelsesdato                     |
        | løpet på vitnemålet ikke gir generell studiekompetanse |
        | vitnemålet ikke består seksfagskontrollen              |

    Scenario: Annullert vitnemål får ingen påstand
      Gitt at søkeren har et annullert vitnemål
      Når vitnemålet importeres
      Så har vitnemålet ingen påstand om generell studiekompetanse

  Regel: Konklusjon på søknaden fra vitnemålet

    Scenario: Søknaden får konklusjonen fra vitnemålet
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål med påstanden at søkeren har GSK
      Når vitnemålet importeres
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden og grunnlagsdatoen er de samme som i påstanden

    Scenario: Påstanden om at søkeren ikke har GSK gir ingen konklusjon
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkerens eneste vitnemål har påstanden at søkeren ikke har GSK
      Når vitnemålet importeres
      Så får søknaden ingen GSK-konklusjon fra vitnemålet

    @openquestion
    Scenario: Det nyeste vitnemålet som gir GSK, brukes
      # ÅPNE SPØRSMÅL:
      # - Er det nyeste vitnemålet det med senest utstedelsesdato, eller det som ble importert sist?
      Gitt at søkeren har to vitnemål med påstanden at søkeren har GSK
      Når vitnemålene importeres
      Så bygger søknadens GSK-konklusjon på det nyeste av dem

    @openquestion
    Scenario: Alle søknader uten konklusjon oppdateres
      # ÅPNE SPØRSMÅL:
      # - Oppdateres også søknader i avsluttede opptak?
      Gitt at søkeren har en søknad uten GSK-konklusjon og en søknad med GSK-konklusjon
      Når et vitnemål med påstanden at søkeren har GSK importeres
      Så får søknaden uten konklusjon en positiv GSK-konklusjon
      Og GSK-konklusjonen på den andre søknaden er uendret

  Regel: Konklusjon fra tidligere opptak
    # Grunnlagskoder: avklart 2026-10-13 at alle positive konklusjoner kan gjenbrukes,
    # uansett grunnlagskode. Grunnlagskoden kopieres, så den kan være hvilken som helst
    # av kodene i bruk (f.eks. IB, HUT, UTA), også koder som er satt manuelt. Tabellen
    # med fem koder under «Opptakssystemets påstand om GSK på vitnemålet» gjelder bare
    # vitnemål.

    @openquestion
    Scenario: Gjenbruke positiv konklusjon fra tidligere samordna opptak
      # ÅPNE SPØRSMÅL:
      # - Gjenbruksbasen har konklusjoner med kildekoden IMM (1907–2001) i tillegg til
      #   NOM (samordna opptak, 1997–2026). Skal IMM-konklusjonene også gjenbrukes?
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

    Scenario: Konklusjon fra FS-klienten som ikke er kvalitetssikret, gjenbrukes ikke
      Gitt at søkerens eneste positive GSK-konklusjon er satt i FS-klienten i et lokalt opptak
      Og at konklusjonen ikke er med i oversikten over kvalitetssikrede GSK-konklusjoner
      Når søknaden opprettes
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

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
      Når vitnemålet importeres
      Så er GSK-konklusjonen på søknaden uendret

    Scenario: Systemet setter aldri en negativ konklusjon
      Gitt at søkeren ikke har noe grunnlag for generell studiekompetanse
      Når søknaden opprettes
      Så får søknaden ingen negativ GSK-konklusjon

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

    Scenario: Se hvilket opptak en gjenbrukt konklusjon kommer fra
      Gitt at søknaden har fått en GSK-konklusjon som er gjenbrukt fra et tidligere opptak
      Når saksbehandleren ser på GSK-konklusjonen
      Så ser saksbehandleren hvilket opptak konklusjonen kommer fra

