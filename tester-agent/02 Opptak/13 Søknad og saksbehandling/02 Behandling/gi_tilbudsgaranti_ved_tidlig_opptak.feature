# language: no
# Generert av fs-testcaser-cdp 2026-11-09. Rettet 2026-11-10 etter kjøringen (Klargjøring K steg 5 og Poengsum P), og 2026-11-13
# (testdataene for «Annen tilbudsgaranti på et høyere prioritert …» og en søker med to saker)
# Krav: krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature @ 9e267353 (blob a409c3e78fbabcdb46286c0e2d0163e9243154c2)
#
# Bare scenarioene som er levert, er med: regelen «Opptaksforvalter gjennomfører tidligopptaket», to scenarioer
# om medianen, to om utfallet og regelen om manuell tilbudsgaranti. Scenarioene som er utkast (@draft), er ikke med.
#
# «Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak» er heller ikke med. Resultatet kan bare ses når
# hovedopptaket kjøres, og det hører til plasstildelingen (@OPT-PLA-TIL-002), ikke til tidligopptaket.
#
# Gjennomføringen går gjennom alle søkerne i opptaket som har søkt om tidlig opptak, og kan ikke settes tilbake.
# Derfor har hvert scenario sin egen søker: «sak-tidlig-opptak-…» er en liste med søkere i miljøfila, og hvert
# scenario tar en søker fra lista som ikke er brukt i kjøringen eller i en tidligere kjøring, og skriver den i
# resultatet. Søkerne står med saken ikke ferdig behandlet og uten konklusjon, så en gjennomføring i et annet
# scenario ikke gir dem tilbudsgaranti. Scenarioet gjør søkeren klar selv (Klargjøring K).
#
# Poenggrensen sammenlignes med søkerens egen poengsum: scenarioet leser poengsummen P i saken, og setter
# poenggrensen ut fra den. Det gir de samme grenseverdiene som eksemplene i kravet (poeng 55, 50 og 45 mot
# grense 50 er grensen P - 5, P og P + 5), uten at søkerne må ha bestemte poengsummer.
#
# Klargjøring K (saksbehandleren gjør saken klar for tidligopptaket):
#   1. Bytt til «opptak-saksbehandler-behandlende-tidlig-opptak» i «Overstyrt bruker», og last inn siden på nytt.
#   2. Gå til «Opptak», velg «opptak-tidlig-opptak», og velg «Gå til søknader».
#   3. Søk på søkeren, og åpne saken.
#   4. Velg steget «1. Tidlig opptak», og velg konklusjonen der søkeren deltar i «Konklusjon». «Konklusjonen er lagret» vises.
#   5. Velg «Behandlet» i «Behandlingsstatus». Last inn siden på nytt: «Behandlingsstatus» står som «Behandlet».
#
# Poengsum P (søkerens poengsum til et utdanningstilbud):
#   1. Som «opptak-saksbehandler-behandlende-tidlig-opptak», åpne saken til søkeren, og velg steget «7. Oppsummering».
#   2. Under utdanningstilbudet, les «Poeng» i tabellen «Poengsum per kvote og grunnlag» (kvoten ORD). Det er P.
#   Steget «5. Poeng» viser poengradene, ikke poengsummen per kvote, og kan stå som «Ingen poengberegning».
#
# Gjennomføring G (opptaksforvalteren gjennomfører tidligopptaket):
#   1. Bytt til «opptak-forvalter-forvaltende» i «Overstyrt bruker», og last inn siden på nytt.
#   2. Gå til «Opptak», velg «opptak-tidlig-opptak», velg «Plasstildeling» og fanen «Tidlig opptak».
#   3. Velg «Kjør tidligopptak». Dialogen «Kjøre tidligopptak?» viser prøvekjøringen.
#   4. Vent til «Beregner resultatet…» er borte, og velg «Kjør tidligopptak» i dialogen.
#   5. «Tidligopptaket er kjørt.» vises.
#
# «Og fordelingen har delt saken (opptil 2 minutter)»: fordelingen skjer i tildelingsjobben. Agenten søker på søknadsnummeret
# under «Gå til søknader» som «opptak-saksbehandler-behandlende-tidlig-opptak-andre» omtrent hvert 30. sekund, til saken
# finnes, og ellers i inntil 2 minutter. Finnes den ikke da, er testcasen «Ikke testet».
#
# Se tilbudsgarantien S: som «opptak-saksbehandler-behandlende-tidlig-opptak», åpne saken til søkeren på nytt
# (last inn siden), og les «Tilbudsgaranti fra forvalter» for hvert søknadsalternativ i saken.
@TST-OPT-BEH-BEH-001 @depends-on-OPT-BEH-BEH-007
Egenskap: Gi tilbudsgaranti ved tidlig opptak
  Tester at opptaksforvalteren kan prøvekjøre og gjennomføre tidligopptaket, og at søkerne som deltar og har nok
  poeng, får tilbudsgaranti på det høyest prioriterte søknadsalternativet.

  Regel: Opptaksforvalter gjennomfører tidligopptaket

    @endrer-data
    Scenariomal: Tilbudsgaranti ut fra poenggrensen
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak» i saken (som i Poengsum P)
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>»
      Og jeg skriver <grense> i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så <garanti> under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

      Eksempler:
        | grense | garanti                                                     |
        | P - 5  | står «tilbudsgarantitype-tidlig-opptak»                     |
        | P      | står «tilbudsgarantitype-tidlig-opptak»                     |
        | P + 5  | står ikke «tilbudsgarantitype-tidlig-opptak»                |

    # Teknikk: grenseverdianalyse (poengsummen like under grensen, med én desimal)
    @utledet @endrer-data
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: poengsummen er 0,1 under poenggrensen
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak» i saken (som i Poengsum P)
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>»
      Og jeg skriver P + 0,1 i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

    Scenario: Søkere som ikke deltar får ikke tilbudsgaranti
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg gjør søkerens sak klar som i Klargjøring K, men velger konklusjonen der søkeren ikke deltar i «Konklusjon»
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for noen av søknadsalternativene i saken til søkeren (som i S)

    Scenario: Søknader uten konklusjon er ikke med i tidligopptaket
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg gjør søkerens sak klar som i Klargjøring K, men hopper over steg 4, så «Konklusjon» står som «Ikke valgt»
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for noen av søknadsalternativene i saken til søkeren (som i S)

    Scenario: Søkere som ikke er kvalifisert får ikke tilbudsgaranti
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-ikke-kvalifisert»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    Scenario: Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisering-ikke-vurdert»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    # Teknikk: beslutningstabell (kvalifiseringen med flere grunnlag: ett kvalifisert holder; ikke vurdert og
    # ikke kvalifisert er «ikke vurdert»). Regel i koden uten scenario.
    #   | grunnlag 1     | grunnlag 2        | tilbudsgaranti |
    #   | kvalifisert    | ikke kvalifisert  | ja             |
    #   | ikke vurdert   | ikke kvalifisert  | nei            |
    @utledet
    Scenariomal: Opptaksforvalter gjennomfører tidligopptaket: kvalifiseringen har flere grunnlag
      Gitt jeg tar en ubrukt søker fra «<søker>»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så <garanti> under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

      Eksempler:
        | søker                                                      | garanti                                      |
        | sak-tidlig-opptak-grunnlag-kvalifisert-og-ikke-kvalifisert | står «tilbudsgarantitype-tidlig-opptak»      |
        | sak-tidlig-opptak-grunnlag-ikke-vurdert-og-ikke-kvalifisert | står ikke «tilbudsgarantitype-tidlig-opptak» |

    @endrer-data
    Scenariomal: Tilbudsgaranti på det høyest prioriterte søknadsalternativet
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak» i saken (som i Poengsum P)
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>»
      Og jeg skriver <grense> i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «<garanti>» i saken til søkeren (som i S)
      Og står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «<ikke garanti>»
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

      Eksempler:
        | grense | garanti                              | ikke garanti                         |
        | P - 5  | utdanningstilbud-tidlig-opptak       | utdanningstilbud-tidlig-opptak-andre |
        | P + 5  | utdanningstilbud-tidlig-opptak-andre | utdanningstilbud-tidlig-opptak       |

    # Teknikk: ekvivalensklasser (et trukket søknadsalternativ er ikke med). Regel i koden uten scenario.
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: søknadsalternativet med høyest prioritet er trukket
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg er logget inn som «soker-tidlig-opptak» med søkeren
      Og jeg fjerner «utdanningstilbud-tidlig-opptak» fra søknaden i Min kompetanse [Sjekk begrep]
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak-andre» i saken til søkeren (som i S)

    Scenario: Bare ferdig behandlede saker er med i tidligopptaket
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg gjør søkerens sak klar som i Klargjøring K, men hopper over steg 5, så saken ikke har statusen «Behandlet»
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for noen av søknadsalternativene i saken til søkeren (som i S)

    @ref-OPT-SØK-SØK-016 @endrer-data
    Scenario: Reservert studieplass gir tilbudsgaranti uten poenggrense
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak» i saken (som i Poengsum P)
      Og jeg velger «tilbudsgarantitype-reservert-studieplass-behandler» i «Tilbudsgaranti fra behandler» for «utdanningstilbud-tidlig-opptak», og «Tilbudsgaranti lagret» vises
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», skriver P + 5 der, og velger «Lagre poenggrenser»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

    @ref-OPT-SØK-SØK-016
    Scenario: Reservert studieplass gir tilbudsgaranti uten kvalifisering
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-ikke-kvalifisert»
      Og jeg velger «tilbudsgarantitype-reservert-studieplass-behandler» i «Tilbudsgaranti fra behandler» for «utdanningstilbud-tidlig-opptak», og «Tilbudsgaranti lagret» vises
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    # Teknikk: beslutningstabell (reservert studieplass gir tilbudsgaranti bare når søkeren deltar og saken er
    # ferdig behandlet, se notatet om reservert studieplass i kravet)
    #   | reservert studieplass | deltar | ferdig behandlet | tilbudsgaranti |
    #   | ja                    | nei    | ja               | nei            |
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: reservert studieplass når søkeren ikke deltar
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg velger «tilbudsgarantitype-reservert-studieplass-behandler» i «Tilbudsgaranti fra behandler» for «utdanningstilbud-tidlig-opptak», og «Tilbudsgaranti lagret» vises
      Og jeg gjør søkerens sak klar som i Klargjøring K, men velger konklusjonen der søkeren ikke deltar i «Konklusjon»
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for noen av søknadsalternativene i saken til søkeren (som i S)

    # Teknikk: tilstandsoverganger (reservert studieplass satt av opptaksforvalteren blir erstattet).
    # Regel i koden uten scenario.
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: reservert studieplass fra opptaksforvalter blir erstattet
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg velger «tilbudsgarantitype-reservert-studieplass-forvalter» i «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren, og «Tilbudsgaranti lagret» vises
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      Og står ikke «tilbudsgarantitype-reservert-studieplass-forvalter» der

    Scenario: Den høyeste poengsummen til søknadsalternativet gjelder
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-to-kvoter»
      Og jeg leser de to poengsummene til «utdanningstilbud-tidlig-opptak» i saken: den laveste L og den høyeste H
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>»
      Og jeg skriver en poenggrense mellom L og H i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

    # Teknikk: ekvivalensklasser (en poengsum i en kvote søkeren ikke skal kvoteplasseres i, teller ikke).
    # Regel i koden uten scenario.
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: poengsummen i en kvote søkeren ikke skal kvoteplasseres i
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-poeng-i-kvote-uten-kvoteplassering»
      Og poenggrensen for «utdanningstilbud-tidlig-opptak» i fanen «Tidlig opptak» er høyere enn poengsummen i kvotene søkeren skal kvoteplasseres i, og lavere enn poengsummen i den andre kvoten
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    # Teknikk: ekvivalensklasser (ingen poengsum i garantikvoten). Regel i koden uten scenario.
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: søknadsalternativet har ingen poengsum
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-uten-poengsum»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    Scenario: Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og poenggrensen for «utdanningstilbud-tidlig-opptak» i fanen «Tidlig opptak» er lavere enn søkerens poengsum
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg velger «tilbudsgarantitype-forvalter-gir-ikke-tilbud» i «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren, og «Tilbudsgaranti lagret» vises
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    Scenario: Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og poenggrensen for «utdanningstilbud-tidlig-opptak» i fanen «Tidlig opptak» er lavere enn søkerens poengsum
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg velger «tilbudsgarantitype-forvalter-gir-tilbud» i «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren, og «Tilbudsgaranti lagret» vises
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    # Prioritet 1 skal ikke selv gi tilbudsgaranti i tidligopptaket, for da erstattes tilbudsgarantien der
    # (som i «Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet»). Derfor er poenggrensen
    # på prioritet 1 over søkerens poengsum.
    @endrer-data
    Scenario: Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak» i saken (som i Poengsum P)
      Og poenggrensen for «utdanningstilbud-tidlig-opptak-andre» i fanen «Tidlig opptak» er lavere enn søkerens poengsum
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>»
      Og jeg skriver P + 5 i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»
      Og jeg velger «tilbudsgarantitype-forvalter-gir-tilbud» i «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren, og «Tilbudsgaranti lagret» vises
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak-andre» i saken til søkeren (som i S)
      Og står «tilbudsgarantitype-forvalter-gir-tilbud» fortsatt under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak»
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

    @endrer-data
    Scenario: Tidligopptakstilbud fra tilbyder går foran poengsummen
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak» i saken (som i Poengsum P)
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», skriver P + 5 der, og velger «Lagre poenggrenser»
      Og jeg er logget inn som «opptak-tilbyder-behandlende»
      Og jeg velger «tilbudsgarantitype-tilbyder-tidligopptakstilbud» i «Tilbudsgaranti fra tilbyder» for «utdanningstilbud-tidlig-opptak» i saken til søkeren, og «Tilbudsgaranti lagret» vises
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      Og står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak-andre»
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

    Scenario: Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-uten-poengsum»
      Og jeg er logget inn som «opptak-tilbyder-behandlende»
      Og jeg velger «tilbudsgarantitype-tilbyder-tidligopptakstilbud» i «Tilbudsgaranti fra tilbyder» for «utdanningstilbud-tidlig-opptak» i saken til søkeren, og «Tilbudsgaranti lagret» vises
      Og «Konklusjon» i steget «Tidlig opptak» står som «Ikke valgt», og saken har ikke statusen «Behandlet»
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tilbyder-tidligopptakstilbud» fortsatt under «Tilbudsgaranti fra tilbyder» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      Og står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak»

    # Teknikk: ekvivalensklasser (søkeren har ikke søkt om tidlig opptak, men har tidligopptakstilbud).
    # Regel i koden uten scenario. Kravet sier ikke om søkeren da skal være med (uklart om ønsket).
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: tidligopptakstilbud uten søknad om tidlig opptak
      Gitt jeg tar en ubrukt søker fra «sak-uten-soknad-om-tidlig-opptak»
      Og jeg er logget inn som «opptak-tilbyder-behandlende»
      Og jeg velger «tilbudsgarantitype-tilbyder-tidligopptakstilbud» i «Tilbudsgaranti fra tilbyder» for «utdanningstilbud-tidlig-opptak» i saken til søkeren, og «Tilbudsgaranti lagret» vises
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    Scenario: Prøvekjøre tidligopptaket
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og poenggrensen for «utdanningstilbud-tidlig-opptak» i fanen «Tidlig opptak» er lavere enn søkerens poengsum
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg velger «Kjør tidligopptak», og noterer tallet ved «Totale tilbudsgarantier» i dialogen «Kjøre tidligopptak?»
      Og jeg lukker dialogen uten å velge «Kjør tidligopptak»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg bytter til «opptak-forvalter-forvaltende», åpner fanen «Tidlig opptak» på nytt og velger «Kjør tidligopptak»
      Så viser «Totale tilbudsgarantier» i dialogen «Kjøre tidligopptak?» 1 mer enn tallet jeg noterte
      Og dialogen viser «Dette er en prøvekjøring. Tallene viser hva som skjer hvis du kjører nå. Ingenting er lagret eller sendt ennå.»
      Og jeg lukker dialogen uten å velge «Kjør tidligopptak»
      Og står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for noen av søknadsalternativene i saken til søkeren (som i S)

    # Teknikk: tilstandsoverganger (gjennomføringen kan ikke startes før poenggrensene er lagret).
    # Regel i koden uten scenario.
    @utledet
    Scenario: Opptaksforvalter gjennomfører tidligopptaket: poenggrensen er ikke lagret
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>»
      Når jeg skriver en annen verdi i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», uten å velge «Lagre poenggrenser»
      Og jeg velger «Kjør tidligopptak»
      Så viser dialogen «Du har poenggrenser som ikke er lagret. Lagre dem før du kjører tidligopptak, så kjøringen bruker de nye grensene.»
      Og «Kjør tidligopptak» i dialogen kan ikke velges
      # Setter tilbake:
      Og jeg lukker dialogen, og laster inn siden på nytt uten å lagre
      Og verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>» er den jeg noterte

    @endrer-data
    Scenario: En ny gjennomføring fjerner ikke tilbudsgarantien
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak» i saken (som i Poengsum P)
      Og poenggrensen for «utdanningstilbud-tidlig-opptak» i fanen «Tidlig opptak» er lavere enn P
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Og jeg gjennomfører tidligopptaket som i Gjennomføring G
      Og «tilbudsgarantitype-tidlig-opptak» står under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», skriver P + 5 der, og velger «Lagre poenggrenser»
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» fortsatt under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

    Scenario: Ny gjennomføring tar med en sak som er blitt ferdig behandlet
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og poenggrensen for «utdanningstilbud-tidlig-opptak» i fanen «Tidlig opptak» er lavere enn søkerens poengsum
      Og jeg gjør søkerens sak klar som i Klargjøring K, men hopper over steg 5, så saken ikke har statusen «Behandlet»
      Og jeg gjennomfører tidligopptaket som i Gjennomføring G
      Og «tilbudsgarantitype-tidlig-opptak» står ikke under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      Og jeg velger «Behandlet» i «Behandlingsstatus» i saken til søkeren, og «Behandlingsstatus» står som «Behandlet» etter at siden er lastet inn på nytt
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)

    @endrer-data
    Scenario: Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak» i saken (som i Poengsum P)
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», skriver P + 5 der, og velger «Lagre poenggrenser»
      Og poenggrensen for «utdanningstilbud-tidlig-opptak-andre» er lavere enn søkerens poengsum der
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Og jeg gjennomfører tidligopptaket som i Gjennomføring G
      Og «tilbudsgarantitype-tidlig-opptak» står under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak-andre» i saken til søkeren (som i S)
      Og jeg skriver P - 5 i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak» i saken til søkeren (som i S)
      Og står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak-andre»
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>», og velger «Lagre poenggrenser»

  Regel: Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt

    # Søkerne i «sak-tidlig-opptak-median-over», «-lik» og «-under» har poengsummen over, lik og under medianen
    # fra forrige opptak for «utdanningstilbud-tidlig-opptak-med-median». Poenggrensen settes ut fra søkerens
    # poengsum P, som i regelen over.
    @endrer-data
    Scenariomal: Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak
      Gitt jeg tar en ubrukt søker fra «<søker>»
      Og jeg leser søkerens poengsum P til «utdanningstilbud-tidlig-opptak-med-median» i saken (som i Poengsum P)
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og «Median i fjor» for «utdanningstilbud-tidlig-opptak-med-median» viser en median
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-med-median>»
      Og jeg <poenggrense> i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-med-median>», og velger «Lagre poenggrenser»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så <garanti> under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak-med-median» i saken til søkeren (som i S)
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-med-median>», og velger «Lagre poenggrenser»

      Eksempler:
        | søker                         | poenggrense             | garanti                                      |
        | sak-tidlig-opptak-median-over  | tømmer feltet           | står «tilbudsgarantitype-tidlig-opptak»      |
        | sak-tidlig-opptak-median-lik   | tømmer feltet           | står «tilbudsgarantitype-tidlig-opptak»      |
        | sak-tidlig-opptak-median-under | tømmer feltet           | står ikke «tilbudsgarantitype-tidlig-opptak» |
        | sak-tidlig-opptak-median-over  | skriver P + 2           | står ikke «tilbudsgarantitype-tidlig-opptak» |
        | sak-tidlig-opptak-median-under | skriver P - 2           | står «tilbudsgarantitype-tidlig-opptak»      |

    # Teknikk: grenseverdianalyse (poenggrensen 0 er satt, og går foran medianen: alle kvalifiserte som deltar,
    # får tilbudsgaranti, se teksten på siden)
    @utledet @endrer-data
    Scenario: Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt: poenggrensen er 0
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-median-under»
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg noterer verdien i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-med-median>»
      Og jeg skriver 0 i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-med-median>», og velger «Lagre poenggrenser»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak-med-median» i saken til søkeren (som i S)
      # Setter tilbake:
      Og jeg skriver verdien jeg noterte i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-med-median>», og velger «Lagre poenggrenser»

    Scenario: Ingen tilbudsgaranti uten poenggrense og uten median fra forrige opptak
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-uten-median»
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-uten-median>» er tom, og «Median i fjor» viser «-»
      Og jeg gjør søkerens sak klar som i Klargjøring K
      Når jeg gjennomfører tidligopptaket som i Gjennomføring G
      Så står ikke «tilbudsgarantitype-tidlig-opptak» under «Tilbudsgaranti fra forvalter» for «utdanningstilbud-tidlig-opptak-uten-median» i saken til søkeren (som i S)

  Regel: Opptaksforvalter ser utfallet av tidligopptaket

    # Tallet gjelder hele opptaket, også søkere fra andre tester. Derfor sjekkes forskjellen: de tre sakene
    # gjøres ferdig behandlet med konklusjon, og tallet blir 3 lavere.
    Scenario: Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon
      Gitt jeg tar to ubrukte søkere fra «sak-tidlig-opptak-kvalifisert», A og B
      Og jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert», C, og gjør saken til C klar som i Klargjøring K, men hopper over steg 4, så «Konklusjon» står som «Ikke valgt»
      Og jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg velger «Kjør tidligopptak», og noterer tallet ved «Har saker som ikke er behandlet» i dialogen «Kjøre tidligopptak?»
      Og jeg lukker dialogen uten å velge «Kjør tidligopptak»
      Og jeg gjør sakene til A og B klar som i Klargjøring K, og velger konklusjonen der søkeren deltar i saken til C
      Når jeg bytter til «opptak-forvalter-forvaltende», åpner fanen «Tidlig opptak» på nytt og velger «Kjør tidligopptak»
      Så viser «Har saker som ikke er behandlet» i dialogen 3 mindre enn tallet jeg noterte
      Og jeg lukker dialogen uten å velge «Kjør tidligopptak»

    # Teknikk: ekvivalensklasser (en søker med to saker som ikke er ferdig behandlet, telles én gang)
    # Søknaden får én sak, hos organisasjonen som saksbehandler prioritet 1. Med realkompetanse saksbehandler hver
    # tilbyder sitt eget søknadsalternativ, så saken deles i to når saksbehandleren overstyrer utdanningsbakgrunnen.
    @utledet
    Scenario: Opptaksforvalter ser utfallet av tidligopptaket: en søker med to saker som ikke er ferdig behandlet
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-to-tilbydere»
      Og jeg er logget inn som «opptak-saksbehandler-behandlende-tidlig-opptak»
      Og jeg åpner saken til søkeren, og velger «Realkompetanse» i «Velg overstyrt utdanningsbakgrunn» under «Utdanningsbakgrunn»
      Og jeg ser «Utdanningsbakgrunn overstyrt»
      Og fordelingen har delt saken (opptil 2 minutter)
      Og jeg bytter til «opptak-forvalter-forvaltende», og har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
      Og jeg velger «Kjør tidligopptak», og noterer tallet ved «Har saker som ikke er behandlet» i dialogen «Kjøre tidligopptak?»
      Og jeg lukker dialogen uten å velge «Kjør tidligopptak»
      Og jeg gjør søkerens sak hos organisasjonen til «opptak-saksbehandler-behandlende-tidlig-opptak» klar som i Klargjøring K
      Og jeg gjør søkerens sak hos organisasjonen til «opptak-saksbehandler-behandlende-tidlig-opptak-andre» klar som i Klargjøring K, med «opptak-saksbehandler-behandlende-tidlig-opptak-andre» i steg 1
      Når jeg bytter til «opptak-forvalter-forvaltende», åpner fanen «Tidlig opptak» på nytt og velger «Kjør tidligopptak»
      Så viser «Har saker som ikke er behandlet» i dialogen 1 mindre enn tallet jeg noterte
      Og jeg lukker dialogen uten å velge «Kjør tidligopptak»

    @ref-OPT-OVO-INN-004
    Scenariomal: Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «<opptak>»
      Når jeg velger «Kjør tidligopptak»
      Så viser dialogen «Kjøre tidligopptak?» en feilmelding om at <feilen>
      Og «Kjør tidligopptak» i dialogen kan ikke velges
      Og jeg lukker dialogen

      Eksempler:
        | opptak                                         | feilen                                                          |
        | opptak-tidlig-opptak-uten-tilbudsgarantitype   | det ikke finnes noen tilbudsgarantitype for tidlig opptak («Fant ingen tilbudsgarantitype») |
        | opptak-tidlig-opptak-to-tilbudsgarantityper    | tilbudsgarantitypen er tvetydig («tvetydig»)                    |

  Regel: Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket

    @endrer-data
    Scenario: Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket
      Gitt jeg tar en ubrukt søker fra «sak-tidlig-opptak-kvalifisert»
      Og «Konklusjon» i steget «Tidlig opptak» i saken står som «Ikke valgt»
      Og jeg er logget inn som «opptak-tilbyder-behandlende»
      Og jeg har åpnet saken til søkeren i «opptak-tidlig-opptak»
      Når jeg velger «tilbudsgarantitype-tilbyder-tidligopptakstilbud» i «Tilbudsgaranti fra tilbyder» for «utdanningstilbud-tidlig-opptak»
      Og «Tilbudsgaranti lagret» vises
      Og jeg laster inn siden på nytt, og åpner saken igjen
      Så står «tilbudsgarantitype-tilbyder-tidligopptakstilbud» i «Tilbudsgaranti fra tilbyder» for «utdanningstilbud-tidlig-opptak»
      # Setter tilbake (søkeren er brukt, og tas ikke igjen, men tilbudsgarantien skal ikke påvirke senere gjennomføringer):
      Og jeg velger «Ikke valgt» i «Tilbudsgaranti fra tilbyder» for «utdanningstilbud-tidlig-opptak», og «Tilbudsgaranti lagret» vises
