# language: no
#
# Kilden er kontrollmotoren i fs-plattform (opptak-service, autosak/kontrollmotor:
# Kravelementer.GSK, og autosak/gsk: GskKonklusjonEvaluator). Kontrollmotoren er en
# port av kravkodene i NVB2 (krav-kl.txt og krav-r94.txt på
# soda.samordnaopptak.no/open/nvb/), og er AB-testet mot NVB2 på 1,43 millioner
# vitnemål. Avvikene fra testen er rettet. NVB2 er referansen når kravet valideres.
#
# Påstanden fra KREG: avklart 2026-10-27 at beregningen ikke bruker påstanden fra KREG.
# Avklart 30.10.2026: beregningen gir opptakssystemets påstand, ved siden av skolens og
# KREGs påstand, og vitnemålet gir GSK når minst én av dem er ja (@OPT-BEH-BEH-015).
# Koden krever i dag at KREG sier GSK, og bruker kontrollmotoren som kryssjekk. Det er
# et avvik fra kravet.
@OPT-BEH-BEH-027 @must @draft
Egenskap: Beregne GSK fra vitnemål
  Som saksbehandler
  ønsker jeg at opptakssystemet beregner sin egen påstand om generell studiekompetanse for et vitnemål
  slik at GSK-konklusjonen bygger på de samme reglene for alle søkere.

  Generell studiekompetanse (GSK) er det generelle opptakskravet til høyere utdanning.
  Systemet beregner GSK for ett vitnemål om gangen. Beregningen ser på fagene på
  vitnemålet og løpet vitnemålet er utstedt for. Seksfagskontrollen sjekker om fagene
  oppfyller alle delkravene for reformen. Resultatet er opptakssystemets påstand om GSK
  for vitnemålet. Påstanden er GSK når vitnemålet består seksfagskontrollen, og løpet gir
  en grunnlagskode. Ellers er påstanden ikke GSK. Har løpet en grunnlagskode, gis den
  uansett hva påstanden er. «Påstanden» betyr i dette kravet opptakssystemets påstand. Når vitnemålet
  gir GSK, ut fra alle tre påstandene, står i @OPT-BEH-BEH-015.

  Hvilke vitnemål som beregnes, når beregningen skjer, og hva resultatet brukes til,
  står i @OPT-BEH-BEH-015. Det gjelder også annullerte vitnemål, vitnemål uten
  utstedelsesdato og kompetansebevis.

  @openquestion
  Regel: Fag som saksbehandleren har tatt ut av kontrollene, telles ikke med
    # Fagresultatene på vitnemålet har en fagstatus. Saksbehandleren bruker den til å
    # angi om et fag skal være med i kontrollene av vitnemålet. Avklart 2026-10-27 at
    # fagstatusen hører til et annet krav, og at kontrollene må følge den.
    # ÅPNE SPØRSMÅL:
    # - Kravet for fagstatusen er ikke skrevet. Når det finnes, får regelen
    #   @depends-on- til det.

    Scenario: Fag som er tatt ut av kontrollene, oppfyller ikke et delkrav
      Gitt at vitnemålet har samfunnsfag (SAF1001)
      Og at saksbehandleren har tatt faget ut av kontrollene
      Når GSK beregnes for vitnemålet
      Så er delkravet for samfunnsfag ikke oppfylt

  Regel: Reformen på vitnemålet avgjør hvilke delkrav som gjelder

    Scenariomal: Delkravene for <reform>
      Gitt at vitnemålet er fra <reform>
      Når GSK beregnes for vitnemålet
      Så må vitnemålet oppfylle delkravene for <delkrav>

      Eksempler:
        | reform          | delkrav                                                                |
        | Kunnskapsløftet | matematikk, naturfag, samfunnsfag, engelsk, og norsk og historie       |
        | Reform 94       | matematikk, engelsk, naturfag, nyere historie, samfunnslære og norsk   |

    Scenariomal: Vitnemål fra Kunnskapsløftet uten <delkrav> får påstanden ikke GSK
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet oppfyller alle delkravene unntatt <delkrav>
      Når GSK beregnes for vitnemålet
      Så er påstanden ikke GSK

      Eksempler:
        | delkrav           |
        | matematikk        |
        | naturfag          |
        | samfunnsfag       |
        | engelsk           |
        | norsk og historie |

    Scenariomal: Vitnemål fra Reform 94 uten <delkrav> får påstanden ikke GSK
      Gitt at vitnemålet er fra Reform 94
      Og at vitnemålet oppfyller alle delkravene unntatt <delkrav>
      Når GSK beregnes for vitnemålet
      Så er påstanden ikke GSK

      Eksempler:
        | delkrav        |
        | matematikk     |
        | engelsk        |
        | naturfag       |
        | nyere historie |
        | samfunnslære   |
        | norsk          |

  Regel: Matematikk for Kunnskapsløftet
    # Fagkoder fra Kunnskapsløftet 2006 som er ført som erstatning for et fag fra
    # Reform 94 (merknadkode FAM13), teller bare når de erstatter et fag fra Reform 94
    # som gir det samme. Det gjelder programfagene R1, R2, S1 og S2.

    Scenariomal: Matematikkravet er oppfylt med <alternativ>
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har <fag>
      Når GSK beregnes for vitnemålet
      Så er delkravet for matematikk oppfylt

      Eksempler:
        | alternativ                         | fag                                                                                                                              |
        | 224 timer studieforberedende       | matematikk 224 timer (MAT1008 eller MAT1003)                                                                                     |
        | matematikk 1 og matematikk 2P      | matematikk 1 (MAT1007, MAT1002, MAT1013, MAT1011, MAT1021 eller MAT1019) og matematikk 2P (MAT1023, MAT1017 eller MAT1015)        |
        | matematikk 1 og programfag         | matematikk 1 (MAT1007, MAT1002, MAT1013, MAT1011, MAT1021 eller MAT1019) og R1, S1, R2 eller S2, skriftlig eller muntlig        |
        | påbygging                          | matematikk for yrkesfag på vg1 (1T-Y eller 1P-Y) og matematikk 2T-Y eller 2P-Y på vg3 (MAT1010, MAT1005 eller MAT1151)         |
        | programfag                         | R1 (REA3022 eller REA3056), R2 (REA3024 eller REA3058), S1 (REA3026 eller REA3060) eller S2 (REA3028 eller REA3062), skriftlig   |

    Scenariomal: Påbygging med matematikk <fag> på vg1
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har matematikk <fag> på vg1 (<fagkoder>)
      Og at vitnemålet har matematikk 2T-Y på vg3 (MAT1010)
      Når GSK beregnes for vitnemålet
      Så er delkravet for matematikk oppfylt

      Eksempler:
        | fag  | fagkoder                                                                                                              |
        | 1P-Y | MAT1001, MAT1111 (Matematikk 1P-Y BA), MAT1113, MAT1115, MAT1117, MAT1119, MAT1121, MAT1123, MAT1125, MAT1127 eller MAT1129 |
        | 1T-Y | MAT1006, MAT1131, MAT1133, MAT1135, MAT1137, MAT1139, MAT1141, MAT1143, MAT1145, MAT1147 eller MAT1149              |

    Scenario: Matematikk for yrkesfag på vg1 alene oppfyller ikke matematikkravet
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålets eneste matematikkfag er matematikk 1P-Y (MAT1001)
      Når GSK beregnes for vitnemålet
      Så er delkravet for matematikk ikke oppfylt

  Regel: Naturfag for Kunnskapsløftet

    Scenariomal: Naturfagkravet er oppfylt med <alternativ>
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har <fag>
      Når GSK beregnes for vitnemålet
      Så er delkravet for naturfag oppfylt

      Eksempler:
        | alternativ                   | fag                                                                                                                   |
        | studieforberedende           | naturfag for studieforberedende på vg1 (NAT1007, NAT1002, NAT1019 eller NAT1005)                                      |
        | påbygging, standard plan     | naturfag for yrkesfag på vg1 (NAT1001 eller NAT1008–NAT1017) og naturfag på vg3 påbygging (NAT1003 eller NAT1018)    |
        | påbygging, samisk plan       | naturfag for yrkesfag på vg1, samisk plan (NAT1004 eller NAT1020–NAT1029) og naturfag på vg3 påbygging, samisk plan (NAT1006 eller NAT1030) |

    Scenariomal: Vg1 og vg3 fra ulike planer oppfyller ikke naturfagkravet
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har naturfag for yrkesfag på vg1 etter <plan vg1>
      Og at vitnemålet har naturfag på vg3 påbygging etter <plan vg3>
      Og at vitnemålet ikke har naturfag for studieforberedende på vg1
      Når GSK beregnes for vitnemålet
      Så er delkravet for naturfag ikke oppfylt

      Eksempler:
        | plan vg1      | plan vg3      |
        | standard plan | samisk plan   |
        | samisk plan   | standard plan |

  Regel: Samfunnsfag for Kunnskapsløftet

    Scenariomal: Samfunnsfagkravet er oppfylt med <fagkode>
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har <fag> (<fagkode>)
      Når GSK beregnes for vitnemålet
      Så er delkravet for samfunnsfag oppfylt

      Eksempler:
        | fagkode | fag                                                |
        | SAF1001 | Samfunnsfag                                        |
        | SAF1002 | Samfunnsfag i videregående opplæring, samisk plan  |
        | SAK1001 | Samfunnskunnskap                                   |
        | SAK1002 | Samfunnskunnskap, samisk plan                      |

  Regel: Engelsk for Kunnskapsløftet

    Scenariomal: Engelskkravet er oppfylt med <fagkode>
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har <fag> (<fagkode>)
      Når GSK beregnes for vitnemålet
      Så er delkravet for engelsk oppfylt

      Eksempler:
        | fagkode | fag                                              |
        | ENG1002 | Engelsk, vg1 studieforberedende utdanningsprogram |
        | ENG1007 | Engelsk, vg1 studieforberedende utdanningsprogram |
        | ENG1006 | engelsk for tegnspråklige                        |
        | ENG1011 | engelsk for tegnspråklige                        |
        | ENG1003 | Engelsk, vg2 yrkesfaglige utdanningsprogram      |
        | ENG1005 | engelsk for yrkesfag eller døve                  |
        | ENG1009 | Engelsk, vg1 yrkesfaglige utdanningsprogram      |
        | ENG1013 | engelsk for yrkesfag eller døve                  |
        | SPR3008 | programfag i engelsk                             |
        | SPR3010 | programfag i engelsk                             |
        | SPR3012 | programfag i engelsk                             |
        | SPR3029 | Engelsk 1                                        |
        | SPR3031 | Engelsk 2                                        |

  Regel: Norsk og historie for Kunnskapsløftet
    # Fagkodene for samisk 2. språk og finsk 2. språk står ikke i kravet, men i FF_sf_samisk2
    # og FF_sf_finsk2 i krav-kl.txt (NVB2). Avklart 30.10.2026.
    # Standard norsk er én av tre varianter: norsk hovedmål, sidemål og muntlig, norsk for
    # elever med kort botid eller som går over fra Reform 94, eller norsk for tegnspråklige.
    # Alle tre variantene gjelder der kravet sier «standard norsk».

    Scenariomal: Standard norsk med <variant>
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har <fag>
      Når GSK beregnes for vitnemålet
      Så har vitnemålet standard norsk

      Eksempler:
        | variant                                 | fag                                                                                                                                                   |
        | norsk hovedmål, sidemål og muntlig      | norsk hovedmål (NOR1211, NOR1267, NOR1231 eller NOR1270), norsk sidemål (NOR1212, NOR1268, NOR1232 eller NOR1271) og norsk muntlig (NOR1213, NOR1269, NOR1233 eller NOR1272) |
        | kort botid, studieforberedende          | norsk skriftlig for kort botid (NOR1405 eller NOR1420) og norsk muntlig for kort botid (NOR1406 eller NOR1421)                                        |
        | kort botid, påbygging                   | norsk skriftlig for kort botid (NOR1410 eller NOR1422) og norsk muntlig for kort botid (NOR1411 eller NOR1423)                                        |
        | overgang fra Reform 94                  | NOR1063 og NOR1064                                                                                                                                    |
        | NOR1050 og NOR1049 uten VMM25           | NOR1050 og NOR1049, og vitnemålet har ikke merknaden VMM25                                                                                            |
        | norsk for tegnspråklige                 | norsk tekstskaping (NOR1033, NOR1072, NOR1253 eller NOR1074), norsk muntlig for tegnspråklige (NOR1034, NOR1073, NOR1254 eller NOR1075) og norsk for døve (NOR1039, NOR1079, NOR1259 eller NOR1080) |

    Scenariomal: Merknaden VMM25 med <fag> gir ikke standard norsk
      # Er VMM25 ført sammen med disse fagene, er det en feilføring.
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har merknaden VMM25
      Og at vitnemålet har <fag>
      Og at vitnemålet ikke har norsk hovedmål, sidemål og muntlig
      Og at vitnemålet ikke har norsk for tegnspråklige
      Når GSK beregnes for vitnemålet
      Så har vitnemålet ikke standard norsk

      Eksempler:
        | fag                       |
        | norsk for kort botid      |
        | NOR1063 og NOR1064        |
        | NOR1050 og NOR1049        |

    Scenario: NOR1049 som privatist med merknaden VMM25 erstatter norsk hovedmål
      # Avklart 30.10.2026.
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har norsk hovedmål (NOR1049) ført som privatist
      Og at vitnemålet har merknaden VMM25
      Og at vitnemålet har norsk sidemål og norsk muntlig
      Når GSK beregnes for vitnemålet
      Så har vitnemålet standard norsk

    Scenariomal: Norskkravet er oppfylt med <variant>
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har <fag>
      Når GSK beregnes for vitnemålet
      Så er norskdelen av delkravet for norsk og historie oppfylt

      Eksempler:
        | variant                     | fag                                                                                                                                                   |
        | standard norsk              | standard norsk, med en av de tre variantene                                                                                                          |
        | samisk 1. språk             | samisk 1. språk skriftlig og muntlig (nordsamisk, sørsamisk eller lulesamisk), og norsk for samisk 1. språk (NOR1025, NOR1280, NOR1245 eller NOR1282, og NOR1026, NOR1281, NOR1246 eller NOR1283) eller standard norsk, med en av de tre variantene |
        | samisk eller finsk 2. språk | samisk eller finsk 2. språk, og norsk skriftlig for samisk eller finsk 2. språk (NOR1218, NOR1287, NOR1238 eller NOR1288) med norsk muntlig, eller standard norsk, med en av de tre variantene |

    Scenariomal: Standard norsk krever historie etter standard plan (<fagkode>)
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har standard norsk, med en av de tre variantene
      Og at vitnemålet har <fag> (<fagkode>)
      Når GSK beregnes for vitnemålet
      Så er delkravet for norsk og historie oppfylt

      Eksempler:
        | fagkode | fag                                                     |
        | HIS1002 | Historie, vg3 studieforberedende utdanningsprogram      |
        | HIS1010 | Historie, vg3 studieforberedende utdanningsprogram      |
        | HIS1003 | Historie, vg3 påbygging til generell studiekompetanse   |
        | HIS1011 | Historie, vg3 påbygging til generell studiekompetanse   |

    Scenario: Standard norsk med historie etter samisk plan oppfyller ikke kravet
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet har standard norsk
      Og at vitnemålets eneste historiefag er historie etter samisk plan (HIS1005)
      Når GSK beregnes for vitnemålet
      Så er delkravet for norsk og historie ikke oppfylt

    Scenariomal: <variant> godtar alle historiefagene
      Gitt at vitnemålet er fra Kunnskapsløftet
      Og at vitnemålet oppfyller norskkravet med <variant>
      Og at vitnemålet har ett av disse historiefagene:
        | fagkode | fag                                                                  |
        | HIS1002 | Historie, vg3 studieforberedende utdanningsprogram                   |
        | HIS1010 | Historie, vg3 studieforberedende utdanningsprogram                   |
        | HIS1005 | historie for studieforberedende, samisk plan                         |
        | HIS1013 | historie for studieforberedende, samisk plan                         |
        | HIS1003 | Historie, vg3 påbygging til generell studiekompetanse                |
        | HIS1011 | Historie, vg3 påbygging til generell studiekompetanse                |
        | HIS1006 | Historie, samisk plan, vg3 påbygging til generell studiekompetanse   |
        | HIS1014 | historie på vg3 påbygging, samisk eller finsk plan                   |
        | HIS1008 | historie på vg3 påbygging, samisk eller finsk plan                   |
        | HIS1015 | historie på vg3 påbygging, samisk eller finsk plan                   |
      Når GSK beregnes for vitnemålet
      Så er delkravet for norsk og historie oppfylt

      Eksempler:
        | variant                     |
        | samisk 1. språk             |
        | samisk eller finsk 2. språk |

  Regel: Delkravene for Reform 94

    Scenariomal: Delkravet for <delkrav> er oppfylt med <alternativ>
      Gitt at vitnemålet er fra Reform 94
      Og at vitnemålet har <fag>
      Når GSK beregnes for vitnemålet
      Så er delkravet for <delkrav> oppfylt

      Eksempler:
        | delkrav        | alternativ                  | fag                                                                                                                 |
        | matematikk     | privatist                   | VG1302, VG1303, VG1340 eller VG1341                                                                                 |
        | matematikk     | elev                        | VG1300, VG1301, VG1307, VG1308, VG1330, VG1331, VG1346 eller VG1347                                                 |
        | matematikk     | yrkesfag med tillegg        | VF1310 eller VF1320, og VG1332, VG1333, VG1342 eller VG1343                                                         |
        | engelsk        | elev                        | Engelsk elever (VG1200), VG1201 eller VG1202                                                                        |
        | engelsk        | privatist                   | VG1205 og VG1200, VG1201 eller VG1203, eller VG1206 og VG1207                                                       |
        | engelsk        | yrkesfag                    | VF2210 eller VF2211                                                                                                 |
        | naturfag       | naturfag                    | Naturfag (elever) (VG1400) eller VG1401                                                                             |
        | nyere historie | nyere historie              | Nyere historie (ny plan) (VG4600) eller VG4607                                                                      |
        | samfunnslære   | samfunnslære                | Samfunnslære (VG2500)                                                                                               |
        | norsk          | norsk                       | norsk hovedmål skriftlig (VG4000, VG4002 eller VG4004), norsk muntlig (VG4001, VG4003 eller VG4006) og VG4005      |
        | norsk          | norsk som andrespråk        | VG4160 eller VG4161, og VG4165                                                                                      |
        | norsk          | samisk 1. språk             | norsk for samiske (VG4120 eller VG4123, og VG4125) eller norsk, og samisk 1. språk (nordsamisk, sørsamisk eller lulesamisk) |
        | norsk          | samisk 2. språk             | norsk for samiske eller norsk, og samisk 2. språk (nordsamisk, sørsamisk eller lulesamisk)                          |
        | norsk          | finsk 2. språk              | norsk for finske (VG4121 eller VG4124, og VG4126) eller norsk, og finsk 2. språk (VG4180 eller VG4181, og VG4185)  |
        | norsk          | tegnspråk                   | norsk for tegnspråklige (VG4122) og tegnspråk 1. språk (VG4190)                                                     |

    Scenario: Norsk for tegnspråklige alene oppfyller ikke norskkravet
      Gitt at vitnemålet er fra Reform 94
      Og at vitnemålet har norsk for tegnspråklige (VG4122)
      Og at vitnemålet ikke har tegnspråk 1. språk (VG4190)
      Når GSK beregnes for vitnemålet
      Så er delkravet for norsk ikke oppfylt

  Regel: Løpet på vitnemålet gir grunnlagskoden
    # Innspill i PR #857: grunnlagskoden slås opp i tabellen over løp (VGS_LOEP, feltet
    # VGS_LOEP.GRUNNLAGSTYPE_KODE i det gamle systemet) med programområdekodene på
    # vitnemålet, normalt tre.
    # Løpet settes sammen av programområdekodene på vitnemålet, etter nivået på
    # programområdet. Vitnemålet har alltid én programområdekode per nivå. Avklart 30.10.2026.
    # Kode i dag: opptak setter løpskoden sammen selv (VgsDokumentVitnemaalMapper), og får den
    # ikke fra KREG. Det må avklares i arkitekturen om det skal gjøres i KREG eller i opptak.
    # Det er en implementasjonsdetalj, og endrer ikke regelen.

    Scenario: Løpet settes sammen av programområdene etter nivå
      Gitt at vitnemålet har programområdet "C" på nivå 3
      Og at vitnemålet har programområdet "A" på nivå 1
      Og at vitnemålet har programområdet "B" på nivå 2
      Når GSK beregnes for vitnemålet
      Så er løpet på vitnemålet løpet med programområdene "A", "B" og "C", i den rekkefølgen

    Scenario: Påstanden er GSK med grunnlagskoden for løpet
      Gitt at vitnemålet oppfyller alle delkravene for reformen
      Og at løpet på vitnemålet har grunnlagskoden KLS
      Når GSK beregnes for vitnemålet
      Så er påstanden GSK med grunnlagskoden KLS

    Scenario: Grunnlagskoden gis selv om påstanden ikke er GSK
      # Avklart 30.10.2026: søknaden kan få GSK-konklusjonen fra skolens eller KREGs påstand
      # (OPT-BEH-BEH-015), og trenger da grunnlagskoden for løpet.
      Gitt at løpet på vitnemålet har grunnlagskoden KLS
      Og at vitnemålet ikke oppfyller delkravet for matematikk
      Når GSK beregnes for vitnemålet
      Så er påstanden ikke GSK
      Og grunnlagskoden på vitnemålet er KLS

    Scenario: Ukjent løp
      Gitt at løpet på vitnemålet ikke finnes i opptakssystemets liste over løp
      Når GSK beregnes for vitnemålet
      Så er påstanden ikke GSK

    Scenario: Påbyggingsruten PBPBY4 gir grunnlagskoden for løpet
      # PBPBY4 er en alternativ påbyggingsrute, og ikke et eget løp.
      Gitt at løpskoden på vitnemålet er løpskoden for et løp med tillegget «_PBPBY4»
      Og at vitnemålet oppfyller alle delkravene for reformen
      Når GSK beregnes for vitnemålet
      Så er påstanden GSK med grunnlagskoden for løpet uten tillegget

  @openquestion
  Regel: Yrkesfaglige løp uten grunnlagskode
    # Avklart 30.10.2026: et yrkesfaglig løp uten grunnlagskode gir KLY eller RFA når
    # vitnemålet importeres (@OPT-BEH-BEH-015), ikke bare når saksbehandleren starter
    # kontrollen. Kode i dag: bare når saksbehandleren starter kontrollen, som i det gamle FS
    # (FS158001).
    # ÅPNE SPØRSMÅL:
    # - Sier skolen eller KREG at søkeren har GSK, men løpet har ingen grunnlagskode eller
    #   er ukjent, får søknaden en positiv GSK-konklusjon uten grunnlagskode (OPT-BEH-BEH-015).
    #   Skal KLY eller RFA gis da, eller setter saksbehandleren grunnlagskoden?
    # «Løp»: avklart 2026-10-27 at løp er et begrep saksbehandlerne kjenner.

    Scenariomal: Yrkesfaglig løp fra <reform> gir grunnlagskoden <grunnlagskode>
      Gitt at vitnemålet er fra <reform>
      Og at løpet på vitnemålet ikke har en grunnlagskode
      Og at løpet er fra <reform>
      Og at vitnemålet oppfyller alle delkravene for <reform>
      Når GSK beregnes for vitnemålet
      Så er påstanden GSK med grunnlagskoden <grunnlagskode>

      Eksempler:
        | reform          | grunnlagskode |
        | Kunnskapsløftet | KLY           |
        | Reform 94       | RFA           |

    Scenario: Løp og vitnemål fra ulike reformer
      Gitt at løpet på vitnemålet ikke har en grunnlagskode
      Og at løpet er fra Reform 94
      Og at vitnemålet er fra Kunnskapsløftet
      Når GSK beregnes for vitnemålet
      Så er påstanden ikke GSK
