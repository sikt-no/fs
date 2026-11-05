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
# vitnemålsimporten, og lagrer opptakssystemets egen påstand om GSK på vitnemålet,
# ved siden av skolens påstand, som kontroll. Dette kravet tar inn gjenbruk fra
# saksbehandlingen i tidligere samordna opptak, fra lokale opptak i FS Admin, og fra
# lokale opptak i FS-klienten når konklusjonen er kvalitetssikret.
#
# Gjenbruk i 2027-opptaket (STEK-442): det er ikke avklart hvordan gjenbruksdata skal
# organiseres i produktområdet. For 2027 lastes GSK-konklusjonene og annulleringene
# fra det gamle opptakssystemet (gjenbrukstabellene i SODA, det vil si tabellene gskvedtak
# og gskvedtakannullering) inn i midlertidige gjenbrukstabeller før opptaket. De er
# konklusjoner fra tidligere opptak i dette kravet. Tabellene fjernes etter
# 2027-opptaket.
@OPT-BEH-BEH-015 @must @in-progress @scope-automatisk-gsk-konklusjon
Egenskap: Automatisk GSK-konklusjon
  Som saksbehandler
  ønsker jeg at søknader der søkeren åpenbart har generell studiekompetanse, får GSK-konklusjonen automatisk
  slik at jeg bare trenger å vurdere generell studiekompetanse der grunnlaget ikke er entydig.

  Generell studiekompetanse (GSK) er det generelle opptakskravet til høyere utdanning.
  Et vitnemål har to svar på om søkeren har GSK, ja eller nei: «GSK OK» fra KREG og
  opptakssystemets påstand. «GSK OK» setter skolen når vitnemålet legges inn i KREG, og det
  kommer fra KREG sammen med vitnemålet (OPT-BEH-BEH-030). KREG beregner ikke GSK selv.
  Opptakssystemet forholder seg bare til KREG, ikke til skolenes systemer. Når søkerens
  vitnemål importeres fra KREG til opptakssystemet, kjører fs-opptaks kontrollmotor
  seksfagskontrollen på hvert vitnemål, som en kontroll av «GSK OK» fra KREG. Resultatet er
  opptakssystemets påstand. Den lagres på opptakssystemets
  kopi av vitnemålet, sammen med tidspunktet den ble beregnet og hvilken beregning som
  ble brukt. Grunnlagskoden for løpet lagres også, uansett hva påstandene er.
  Hvordan påstanden og grunnlagskoden beregnes, står i OPT-BEH-BEH-027.

  Vitnemålet gir GSK når det har «GSK OK» fra KREG. «GSK OK» fra KREG er fasit. Sier fs-opptaks
  kontrollmotor noe annet, får saksbehandleren et varsel, men den automatiske behandlingen stopper
  ikke. «Gir GSK» betyr det i kravene om automatisk saksbehandling. Saksbehandleren ser
  både «GSK OK» fra KREG og opptakssystemets påstand i vitnemålsbehandlingen (OPT-BEH-BEH-005).

  Påstandene brukes i saksbehandlingen i alle aktive opptak. «Importeres» betyr i
  dette kravet alltid at opptakssystemet henter vitnemålet fra KREG (OPT-BEH-BEH-030),
  ikke at vitnemålet kommer inn i KREG. Søknader som ikke har en GSK-konklusjon, får en
  positiv konklusjon når et vitnemål gir GSK, og løpet på vitnemålet finnes i
  opptakssystemets liste over løp. Har løpet ingen grunnlagskode, får konklusjonen KLY for et
  løp fra Kunnskapsløftet og RFA for et løp fra Reform 94, som i det gamle FS. Finnes ikke
  løpet i listen, får konklusjonen også KLY eller RFA, og opptaksforvalteren får et varsel i
  FS Admin om at løpet mangler. Et vitnemål med et løp i listen brukes før et vitnemål med et
  løp som ikke finnes i listen. Vitnemål importeres fra KREG når
  søknaden opprettes, og når KREG får nye vitnemål for en søker med aktive søknader. Når
  søknaden opprettes, importeres vitnemålene fra KREG først. Gir ingen av dem en konklusjon, ser
  systemet etter en positiv konklusjon fra et tidligere opptak. Ellers vurderes GSK
  manuelt. Den automatiske saksbehandlingen setter også konklusjonen, som første steg, på
  søknadene i opptaket som ikke har en. Påstandene på vitnemålet beregnes ikke på nytt da.
  Automatikken setter aldri en negativ konklusjon på søknaden, og overskriver aldri en
  konklusjon som finnes. Den gjelder alle opptak, også fagskoleopptak.

  # Fagskoleopptak: avklart 2026-10-13 at automatikken også gjelder fagskoleopptak.
  # Det avviker fra Sikts tolkning i Confluence v2 om at GSK i fagskoleopptak ikke
  # skal lagres som konklusjon, fordi GSK der er et alternativt kompetansekrav.

  @ref-FLY-OPT-AUT-001 @depends-on-OPT-BEH-BEH-027 @ref-FLY-OPT-VIT-001
  Regel: Opptakssystemets påstand om GSK på vitnemålet
    # Hvordan GSK-vitnemålsberegningen virker (seksfagskontrollen og grunnlagskoden), står der.
    # Avklart 30.10.2026: «systemet i videregående skole» fra innspillet i PR #857 er skolens
    # påstand, som kommer fra KREG.

    Scenario: Opptakssystemets påstand er at søkeren har generell studiekompetanse
      Gitt at søkeren har et vitnemål som ikke er annullert
      Og at vitnemålet har utstedelsesdato
      Og at løpet på vitnemålet gir generell studiekompetanse
      Og at vitnemålet består seksfagskontrollen
      Når vitnemålet importeres fra KREG 26.10.2026 kl. 10:14
      Så er opptakssystemets påstand at søkeren har generell studiekompetanse
      Og grunnlagskoden er grunnlagskoden for løpet på vitnemålet
      Og grunnlagsdatoen er utstedelsesdatoen på vitnemålet
      Og påstanden er beregnet 26.10.2026 kl. 10:14
      Og påstanden viser hvilken beregning i kontrollmotoren som ble brukt

    Scenario: Opptakssystemets påstand beregnes uavhengig av GSK OK fra KREG
      Gitt at søkeren har et vitnemål som består seksfagskontrollen
      Og at vitnemålet ikke har «GSK OK» fra KREG
      Når vitnemålet importeres fra KREG
      Så er opptakssystemets påstand at søkeren har generell studiekompetanse

    Scenario: Hvert vitnemål får sin egen påstand
      Gitt at søkeren har to vitnemål som ikke er annullert
      Når vitnemålene importeres fra KREG
      Så har begge vitnemålene en påstand fra opptakssystemet om generell studiekompetanse

    Scenario: Grunnlagskoder som settes automatisk
      Gitt at søkeren har et vitnemål som består seksfagskontrollen
      Når vitnemålet importeres fra KREG
      Så er grunnlagskoden på vitnemålet en av disse:
        | grunnlagskode | vitnemål                                    | reform |
        | AØA           | allmenne og økonomiske fag                  | R94    |
        | RFA           | andre studieforberedende vitnemål           | R94    |
        | TEK           | teknisk fagskole fra og med 2000            | R94    |
        | KLS           | studieforberedende vitnemål                 | KL     |
        | KLY           | yrkesfaglige vitnemål                       | KL     |
        | KLF           | påbygging på VG4 (PBPBY4)                   | KL     |

    Scenariomal: Opptakssystemets påstand er at søkeren ikke har GSK når <grunn>
      Gitt at <grunn>
      Når vitnemålet importeres fra KREG
      Så er opptakssystemets påstand at søkeren ikke har generell studiekompetanse

      Eksempler:
        | grunn                                                  |
        | vitnemålet mangler utstedelsesdato                     |
        | løpet på vitnemålet ikke gir generell studiekompetanse |
        | vitnemålet ikke består seksfagskontrollen              |

    Scenario: Annullert vitnemål får ingen påstand fra opptakssystemet
      Gitt at søkeren har et annullert vitnemål
      Når vitnemålet importeres fra KREG
      Så har vitnemålet ingen påstand fra opptakssystemet om generell studiekompetanse

    Scenario: Kompetansebevis får ingen påstand fra opptakssystemet
      Gitt at søkerens eneste dokument er et kompetansebevis
      Når kompetansebeviset importeres fra KREG
      Så har kompetansebeviset ingen påstand fra opptakssystemet om generell studiekompetanse

  @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-025
  Regel: Vitnemålet gir GSK når det har GSK OK fra KREG
    # Avklart 2026-11-02 med domeneeksperten: skolens påstand («GSK OK» fra KREG) er fasit.
    # Opptakssystemets påstand er en kontroll. Er den uenig, får saksbehandleren et varsel,
    # men den automatiske behandlingen stopper ikke. KREG har ingen egen påstand om GSK, bare
    # skolens. Erstatter avklaringen 30.10.2026 om at minst én av tre påstander må være ja.
    # Kode i dag: GskKonklusjonEvaluator stopper automatikken når kontrollmotoren er uenig med
    # skolen (KRYSSJEKK_FEILET), og gir ikke noe varsel.

    Scenario: Vitnemålet gir GSK når det har GSK OK fra KREG
      Gitt at søkeren har et vitnemål som ikke er annullert
      Og at vitnemålet har «GSK OK» fra KREG
      Når vitnemålet importeres fra KREG
      Så gir vitnemålet GSK

    Scenario: Vitnemålet gir ikke GSK når det ikke har GSK OK fra KREG
      Gitt at søkeren har et vitnemål som ikke er annullert
      Og at vitnemålet ikke har «GSK OK» fra KREG
      Og at fs-opptaks kontrollmotor sier at vitnemålet består seksfagskontrollen
      Når vitnemålet importeres fra KREG
      Så gir ikke vitnemålet GSK

    Scenario: Uenighet med skolen stopper ikke den automatiske behandlingen
      Gitt at søkeren har et vitnemål som ikke er annullert
      Og at vitnemålet har «GSK OK» fra KREG
      Og at fs-opptaks kontrollmotor sier at vitnemålet ikke består seksfagskontrollen
      Når vitnemålet importeres fra KREG
      Så gir vitnemålet GSK
      Og den automatiske behandlingen av saken stopper ikke

    Scenario: Annullert vitnemål gir ikke GSK
      Gitt at søkeren har et annullert vitnemål
      Og at vitnemålet har «GSK OK» fra KREG
      Når vitnemålet importeres fra KREG
      Så gir ikke vitnemålet GSK

  Regel: Saksbehandleren får varsel når opptakssystemet er uenig med skolen
    # Avklart 2026-11-02. Sier skolen nei, gir vitnemålet ikke GSK, og saken behandles
    # manuelt uansett, men varselet vises på samme måte. Hvordan varselet vises, står i
    # vise_elektroniske_vitnemål.design.md.

    Scenariomal: Saksbehandleren ser at opptakssystemet er uenig med skolen når vitnemålet <skolen> GSK OK fra KREG
      Gitt at søkeren har et vitnemål som ikke er annullert
      Og at vitnemålet <skolen> «GSK OK» fra KREG
      Og at fs-opptaks kontrollmotor sier at vitnemålet <kontrollmotoren> seksfagskontrollen
      Når saksbehandleren ser på vitnemålsbehandlingen i saken
      Så ser saksbehandleren et varsel ved vitnemålet om at opptakssystemet er uenig med skolen om GSK

      Eksempler:
        | skolen   | kontrollmotoren |
        | har      | ikke består     |
        | ikke har | består          |

  @ref-FLY-OPT-AUT-001 @ref-FLY-OPT-VIT-001
  Regel: Konklusjon på søknaden fra vitnemålet

    Scenario: Søknaden får konklusjonen fra vitnemålet
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål som gir GSK
      Når vitnemålet importeres fra KREG
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden er grunnlagskoden for løpet på vitnemålet
      Og grunnlagsdatoen er utstedelsesdatoen på vitnemålet

    Scenariomal: Søknaden får konklusjonen fra vitnemålet når saken er <status>
      # Avklart 2026-11-04 (Sondre, opptak !6566): behandlingsstatusen på saken spiller ingen
      # rolle. Statusen endres ikke av konklusjonen, som for resten av den automatiske
      # behandlingen (OPT-BEH-BEH-029).
      Gitt at saken har behandlingsstatusen "<status>"
      Og at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål som gir GSK
      Når vitnemålet importeres fra KREG
      Så får søknaden en positiv GSK-konklusjon
      Og saken har fortsatt behandlingsstatusen "<status>"

      Eksempler:
        | status           |
        | Ikke behandlet   |
        | Under behandling |
        | Behandlet        |

    Scenario: Søknaden får grunnlagskoden for løpet når opptakssystemet er uenig med skolen
      # Avklart 2026-11-02: grunnlagskoden gis fra løpet uansett hva opptakssystemets påstand er
      # (OPT-BEH-BEH-027, «Grunnlagskoden gis selv om påstanden ikke er GSK»).
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at vitnemålet har «GSK OK» fra KREG
      Og at fs-opptaks kontrollmotor sier at vitnemålet ikke består seksfagskontrollen
      Og at løpet på vitnemålet har grunnlagskoden KLS
      Når vitnemålet importeres fra KREG
      Så får søknaden en positiv GSK-konklusjon med grunnlagskoden KLS

    Scenariomal: Søknaden får grunnlagskoden <grunnlagskode> når et løp fra <reform> ikke finnes i opptakssystemets liste over løp
      # Avklart 2026-11-04 (Sondre): som i det gamle FS gir et løp som ikke finnes i listen, KLY
      # eller RFA etter reformen. Løpene som har manglet i listen, har stort sett vært yrkesfaglige.
      # Erstatter innspillet i PR #878 om at et ukjent løp ikke gir noen konklusjon.
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at vitnemålet har «GSK OK» fra KREG
      Og at løpet på vitnemålet er fra <reform>
      Og at løpet på vitnemålet ikke finnes i opptakssystemets liste over løp
      Når vitnemålet importeres fra KREG
      Så får søknaden en positiv GSK-konklusjon med grunnlagskoden <grunnlagskode>

      Eksempler:
        | reform          | grunnlagskode |
        | Kunnskapsløftet | KLY           |
        | Reform 94       | RFA           |

    Scenario: Et vitnemål med et løp i listen brukes før et nyere vitnemål med et ukjent løp
      # Avklart 2026-11-04 (Sondre).
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har to vitnemål som gir GSK
      Og at løpet på det nyeste vitnemålet ikke finnes i opptakssystemets liste over løp
      Og at løpet på det eldste vitnemålet finnes i listen med grunnlagskoden KLS
      Når vitnemålene importeres fra KREG
      Så bygger søknadens GSK-konklusjon på det eldste vitnemålet
      Og grunnlagskoden er KLS

    Scenario: Det nyeste vitnemålet brukes når ingen av løpene finnes i listen
      # Avklart 2026-11-04 (Sondre).
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har to vitnemål fra Kunnskapsløftet som gir GSK
      Og at ingen av løpene på vitnemålene finnes i opptakssystemets liste over løp
      Når vitnemålene importeres fra KREG
      Så bygger søknadens GSK-konklusjon på vitnemålet med senest utstedelsesdato
      Og grunnlagskoden er KLY

    @draft @openquestion
    Scenario: Opptaksforvalteren får varsel om et løp som mangler i listen over løp
      # Avklart 2026-11-02 (Ingrid Helset, etter samtale med Jøran og Geir, og bekreftet av
      # domeneeksperten): opptaksforvalteren får
      # et varsel, så noen kan sjekke om løpet skal legges inn i listen. HK-dir eier
      # opptakskodene og bestemmer grunnlagskoden, og Sikt oppdaterer listen over løp (2027).
      # Avklart 2026-11-02: varselet kommer bare i FS Admin, ikke på e-post eller andre steder.
      # ÅPNE SPØRSMÅL:
      # - Hvor i FS Admin får opptaksforvalteren varselet?
      # - Får opptaksforvalteren ett varsel per løp, eller ett per vitnemål med løpet?
      Gitt at løpet på vitnemålet ikke finnes i opptakssystemets liste over løp
      Når vitnemålet importeres fra KREG
      Så får opptaksforvalteren et varsel i FS Admin om at løpet mangler i listen over løp

    Scenariomal: Søknaden får grunnlagskoden <grunnlagskode> når et løp fra <reform> ikke har en grunnlagskode
      # Innspill i PR #878: finnes løpet i listen over løp, men har ingen grunnlagskode, settes
      # konklusjonen likevel. Avklart 2026-11-02: som i det gamle FS, KLY eller RFA etter reformen.
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at vitnemålet har «GSK OK» fra KREG
      Og at løpet på vitnemålet er fra <reform>
      Og at løpet finnes i opptakssystemets liste over løp, men ikke har en grunnlagskode
      Når vitnemålet importeres fra KREG
      Så får søknaden en positiv GSK-konklusjon med grunnlagskoden <grunnlagskode>

      Eksempler:
        | reform          | grunnlagskode |
        | Kunnskapsløftet | KLY           |
        | Reform 94       | RFA           |

    @draft @openquestion
    Scenario: Opptaksforvalteren får varsel om et løp uten grunnlagskode
      # Avklart 2026-11-02: søknaden får konklusjonen med KLY eller RFA, men
      # opptaksforvalteren får et varsel, så grunnlagskoden kan legges inn i listen over løp
      # senere. HK-dir eier opptakskodene. Avklart 2026-11-02: varselet kommer bare i FS Admin.
      # ÅPNE SPØRSMÅL:
      # - Hvor i FS Admin får opptaksforvalteren varselet? Samme sted som varselet om et løp som
      #   mangler i listen over løp.
      Gitt at vitnemålet har «GSK OK» fra KREG
      Og at løpet finnes i opptakssystemets liste over løp, men ikke har en grunnlagskode
      Når vitnemålet importeres fra KREG
      Så får opptaksforvalteren et varsel i FS Admin om at løpet mangler grunnlagskode

    Scenario: Vitnemål som ikke gir GSK, gir ingen konklusjon
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkerens eneste vitnemål ikke gir GSK
      Når vitnemålet importeres fra KREG
      Så får søknaden ingen GSK-konklusjon fra vitnemålet

    Scenario: Vitnemålet med senest utstedelsesdato brukes
      Gitt at søkeren har to vitnemål som gir GSK
      Når vitnemålene importeres fra KREG
      Så bygger søknadens GSK-konklusjon på vitnemålet med senest utstedelsesdato

    Scenario: Alle søknader uten konklusjon oppdateres
      Gitt at søkeren har en søknad uten GSK-konklusjon og en søknad med GSK-konklusjon
      Og at opptakene ikke er avsluttet
      Når et vitnemål som gir GSK, importeres fra KREG
      Så får søknaden uten konklusjon en positiv GSK-konklusjon
      Og GSK-konklusjonen på den andre søknaden er uendret

    Scenario: Søknader i avsluttede opptak oppdateres ikke
      Gitt at søkeren har en søknad uten GSK-konklusjon i et avsluttet opptak
      Når et vitnemål som gir GSK, importeres fra KREG
      Så får søknaden ingen GSK-konklusjon

    Scenario: Nytt vitnemål fra KREG etter at søknaden er opprettet
      # Hvordan nye vitnemål hentes, står i OPT-BEH-BEH-030 («Nye og annullerte vitnemål i
      # KREG importeres for aktive søkere»).
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at opptaket ikke er avsluttet
      Når KREG får et nytt vitnemål for søkeren
      Så importeres vitnemålet fra KREG
      Og GSK-vitnemålsberegningen kjører for vitnemålet uten at noen starter den

  @ref-FLY-OPT-AUT-001
  Regel: Konklusjon fra tidligere opptak
    # Grunnlagskoder: avklart 2026-10-13 at alle positive konklusjoner kan gjenbrukes,
    # uansett grunnlagskode. Grunnlagskoden kopieres, så den kan være hvilken som helst
    # av kodene i bruk (f.eks. IB, HUT, UTA), også koder som er satt manuelt. Tabellen
    # med seks koder under «Opptakssystemets påstand om GSK på vitnemålet» gjelder bare
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

    Scenario: Gjenbruke kvalitetssikret konklusjon fra FS-klienten
      # Avklart 30.10.2026: de tidligere GSK-konklusjonene importeres til opptakssystemet med en
      # batch-jobb. Hvor de kommer fra, står ikke i kravet.
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkerens eneste positive GSK-konklusjon er satt i FS-klienten i et lokalt opptak
      Og at konklusjonen er kvalitetssikret
      Når søknaden opprettes
      Så får søknaden en positiv GSK-konklusjon
      Og grunnlagskoden og grunnlagsdatoen er de samme som i den tidligere konklusjonen

    Scenario: Annullert konklusjon gjenbrukes ikke
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkerens eneste positive GSK-konklusjon fra et tidligere opptak er annullert
      Når søknaden opprettes
      Så får søknaden ingen GSK-konklusjon fra tidligere opptak

    Scenario: Konklusjon med annullering fram i tid gjenbrukes ikke
      # Avklart 30.10.2026: en annullering stopper gjenbruken uansett dato.
      Gitt at søknaden ikke får GSK-konklusjon fra vitnemålet
      Og at søkerens eneste positive GSK-konklusjon fra et tidligere opptak er annullert fra en dato fram i tid
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

  @draft @depends-on-OPT-OVO-FRI-001
  # OPT-OVO-FRI-001: «Opptaksforvalter kan sette når den automatiske saksbehandlingen starter og avsluttes»
  Regel: Automatikken setter GSK-konklusjonen bare mens den automatiske saksbehandlingen pågår
    # Avklart 2026-11-03. Er hendelsene ikke satt, pågår den automatiske saksbehandlingen til opptaket er
    # historisk. Hendelsene er de samme som i OPT-BEH-BEH-032. Importen av vitnemålet og
    # GSK-vitnemålsberegningen kjører uansett.
    # Avklart 2026-11-03: når saksbehandleren starter den automatiske behandlingen selv, settes
    # GSK-konklusjonen også utenfor perioden (OPT-BEH-BEH-032).

    Scenario: Ingen automatisk konklusjon før den automatiske saksbehandlingen starter
      Gitt at «Automatisk saksbehandling starter» er "2027-04-16 08:00" i opptaket
      Og at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål som gir GSK
      Når vitnemålet importeres fra KREG 2027-04-15 kl. 10:00
      Så får søknaden ingen GSK-konklusjon fra vitnemålet

    Scenario: Ingen automatisk konklusjon etter at den automatiske saksbehandlingen er avsluttet
      Gitt at «Automatisk saksbehandling avsluttes» er "2027-07-15 12:00" i opptaket
      Og at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål som gir GSK
      Når vitnemålet importeres fra KREG 2027-07-15 kl. 12:01
      Så får søknaden ingen GSK-konklusjon fra vitnemålet

    Scenario: Den automatiske saksbehandlingen pågår til opptaket er historisk når hendelsene ikke er satt
      Gitt at opptaket ikke har hendelsene for den automatiske saksbehandlingen
      Og at opptaket ikke er historisk
      Og at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål som gir GSK
      Når vitnemålet importeres fra KREG
      Så får søknaden en positiv GSK-konklusjon

  @ref-FLY-OPT-AUT-001
  Regel: GSK-konklusjonen settes også når den automatiske behandlingen kjører
    # Første steg når den automatiske behandlingen kjører for et opptak. Konklusjonen settes
    # etter de samme reglene som når vitnemålet importeres fra KREG: vitnemålet går foran tidligere
    # konklusjoner, bare den siste tidligere konklusjonen gjenbrukes, og en konklusjon som
    # finnes, overskrives ikke. GSK-vitnemålsberegningen kjøres ikke på nytt.
    # Etter prosesstegningen «GSK-beregning for gitt opptak» (2026-10-29). Tegningen kaller
    # GSK-konklusjonen «GSK-beregning». Begrepet er avklart 2026-11-03, se begreper.md.

    Scenario: Søknaden får konklusjonen fra vitnemålet i den automatiske behandlingen
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at søkeren har et vitnemål som gir GSK
      Når den automatiske behandlingen kjører for opptaket
      Så får søknaden en positiv GSK-konklusjon

    Scenario: Søknaden får konklusjonen fra et tidligere opptak i den automatiske behandlingen
      Gitt at søknaden ikke har noen GSK-konklusjon
      Og at ingen av søkerens vitnemål gir GSK
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

  @ref-FLY-OPT-VIT-001 @ref-OPT-BEH-BEH-034
  Regel: Annullert vitnemål
    # Kilden: vitnemålene hentes fra KREG. Er et vitnemål annullert der, trekkes
    # konklusjonene som bygger på det, ikke tilbake automatisk. Saken får en merknad og
    # taggen «Vitnemål annullert», og settes tilbake til under behandling hvis den er ferdig
    # behandlet (OPT-BEH-BEH-034). Saksbehandleren vurderer konklusjonen. Det gjelder bare i
    # opptak som ikke er avsluttet. I avsluttede opptak står saken urørt.
    # Avklart 29.10.2026, og bekreftet 2026-11-02: konklusjonen trekkes ikke lenger tilbake automatisk. Før stod det
    # at automatiske og gjenbrukte konklusjoner som bygger på vitnemålet, ikke lenger var
    # positive. Kode i dag: GskVedtakTilbakekallingService trekker konklusjonen tilbake.
    # Konklusjoner fra gjenbruksbasen (STEK-442) vet ikke hvilket vitnemål de bygger på.
    # For dem er det annulleringene i gjenbruksbasen som gjelder.

    Scenario: Automatisk konklusjon står når vitnemålet annulleres
      Gitt at søknaden har en automatisk GSK-konklusjon som bygger på et vitnemål
      Og at opptaket ikke er avsluttet
      Når vitnemålet annulleres
      Så er GSK-konklusjonen på søknaden uendret
      Og saken får taggen "Vitnemål annullert"

    Scenario: Gjenbrukt konklusjon står når vitnemålet annulleres
      Gitt at søknaden har en GSK-konklusjon som er gjenbrukt fra et tidligere opptak
      Og at den tidligere konklusjonen bygger på et vitnemål
      Og at opptaket ikke er avsluttet
      Når vitnemålet annulleres
      Så er GSK-konklusjonen på søknaden uendret
      Og saken får taggen "Vitnemål annullert"

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
      Så får saken taggen "Vitnemål annullert"

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

