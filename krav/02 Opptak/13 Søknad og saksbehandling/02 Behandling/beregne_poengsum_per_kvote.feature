# language: no
# Utledet fra koden i fs-plattform (opptak), sjekket mot main 2026-10-29: PoengsumService og
# PoengberegningService regner ut poengsummen, PropageringService starter utregningen, og
# KvotesumV2Service viser den høyeste poengsummen per kvote i saksbehandlingen (kvotesummerV2 i
# fs-admin). Poengtypene og poengene i dem står i OPT-BEH-BEH-018 og OPT-BEH-BEH-028, og
# kvoteplasseringen i OPT-BEH-BEH-012.
@OPT-BEH-BEH-031 @must @implemented @scope-automatisk-kvalifisering-og-poengsum @ref-OPT-BEH-BEH-012 @ref-OPT-BEH-BEH-018 @ref-OPT-BEH-BEH-028
Egenskap: Beregne poengsum per kvote
  Som saksbehandler
  ønsker jeg at søkerens poengsum regnes ut for hver kvote søkeren er plassert i
  slik at søkeren kan rangeres i kvotene uten at jeg regner ut poengsummen selv.

  Poengsummen regnes ut for hver kvote søkeren er plassert i, og for hvert grunnlag kvoten er
  koblet til, med poengformelen til kvotetypen. Den regnes ut på nytt når grunnlaget, poengene,
  kravelementene eller kvoteplasseringen endres, både når saksbehandleren endrer dem og når den
  automatiske behandlingen gjør det.

  Bakgrunn:
    Gitt at søkeren har en søknad i opptaket

  @ref-FLY-OPT-AUT-001
  Regel: Søkeren får en poengsum for hver kvote og hvert grunnlag kvoten er koblet til

    Scenario: Poengsum for grunnlaget kvoten er koblet til
      Gitt at søkeren er plassert i en kvotetype
      Og at saken har et grunnlag
      Og at kvotetypen er koblet til grunnlaget
      Når poengsummen regnes ut
      Så har søkeren en poengsum i kvotetypen for grunnlaget

    Scenario: Grunnlag kvoten ikke er koblet til, gir ingen poengsum i kvoten
      Gitt at søkeren er plassert i en kvotetype
      Og at saken har grunnlagene "VES" og "PRA"
      Og at kvotetypen bare er koblet til grunnlaget "VES"
      Når poengsummen regnes ut
      Så har søkeren en poengsum i kvotetypen for grunnlaget "VES"
      Men søkeren har ingen poengsum i kvotetypen for grunnlaget "PRA"

    Scenario: Kvote søkeren ikke er plassert i, gir ingen poengsum
      Gitt at det finnes en kvotetype søkeren ikke er plassert i
      Når poengsummen regnes ut
      Så har søkeren ingen poengsum i kvotetypen søkeren ikke er plassert i

  @depends-on-OPT-REG-KVO-001 @depends-on-OPT-REG-RAN-002 @ref-FLY-OPT-AUT-001
  # OPT-REG-KVO-001: «En kvotetype kan ha en default poengformel»
  Regel: Poengsummen regnes ut med poengformelen til kvotetypen
    # Poengformelen til kvotetypen settes i regelverket, og poengformlene opprettes i OPT-REG-RAN-002.

    Scenario: Poengsummen følger poengformelen til kvotetypen
      Gitt at poengformelen til kvotetypen har uttrykket "KAR + ALD"
      Og at søkeren har 45 karakterpoeng og 4 alderspoeng
      Når poengsummen regnes ut
      Så er poengsummen i kvotetypen 49

  @ref-FLY-OPT-AUT-001
  Regel: Bare grunnlag søkeren er kvalifisert på, gir poengsum
    # Avklart 2026-10-29: søkeren får bare poengsum på grunnlag søkeren er kvalifisert på for
    # kompetanseregelverket.

    Scenario: Grunnlag søkeren ikke er kvalifisert på, gir ingen poengsum
      Gitt at søkeren er plassert i en kvotetype
      Og at søkeren ikke er kvalifisert på grunnlaget
      Når poengsummen regnes ut
      Så har søkeren ingen poengsum i kvotetypen for grunnlaget

  @ref-FLY-OPT-AUT-001
  Regel: Poengsummen regnes ut på nytt når det den bygger på, endres

    Scenariomal: Poengsummen regnes ut på nytt når <endring>
      Gitt at søkeren har en poengsum i en kvotetype
      Når <endring>
      Så er poengsummen i kvotetypen regnet ut på nytt

      Eksempler:
        | endring                                |
        | grunnlaget endres                      |
        | poengene endres                        |
        | vurderingen av et kravelement endres   |
        | kvoteplasseringen endres               |

    @ref-OPT-BEH-BEH-016
    Scenario: Uendret poengsum gir ikke nytt innslag i endringsloggen
      Gitt at søkeren har en poengsum i en kvotetype
      Når poengsummen regnes ut på nytt uten at den endres
      Så har endringsloggen ikke fått noe nytt innslag for poengsummen

  @ref-FLY-OPT-AUT-001
  Regel: En poengsum som ikke kan regnes ut, stopper ikke de andre

    Scenario: Poengsummen i de andre kvotene regnes ut når én kvote feiler
      Gitt at søkeren er plassert i kvotetypene "ORD" og "ORD-F"
      Og at poengformelen til kvotetypen "ORD-F" ikke kan regnes ut
      Når poengsummen regnes ut
      Så har søkeren en poengsum i kvotetypen "ORD"
      Men søkeren har ingen poengsum i kvotetypen "ORD-F"

    Scenario: Saksbehandleren ser hvorfor poengsummen ikke kan regnes ut
      # Avklart 4.11.2026: årsaken vises per kvote og grunnlag i oppsummeringen av saken, ikke på
      # poengtypen (STEK-650).
      Gitt at poengformelen til kvotetypen bruker en poengtype søkeren ikke har poeng i
      Og at poengsummen for grunnlaget i kvotetypen ikke kan regnes ut
      Når saksbehandleren ser oppsummeringen av saken
      Så ser saksbehandleren hvorfor poengsummen for grunnlaget i kvotetypen ikke kan regnes ut

    Scenario: Poengsummene fjernes når søkeren ikke er plassert i noen kvote
      Gitt at søkeren har en poengsum i en kvotetype
      Når søkeren ikke lenger er plassert i noen kvote
      Så har søkeren ingen poengsum

    Scenario: Poengsummene fjernes når saken ikke har noe grunnlag
      Gitt at søkeren har en poengsum i en kvotetype
      Når saken ikke lenger har noe grunnlag
      Så har søkeren ingen poengsum

  @ref-OPT-PLA-TIL-002 @ref-FLY-OPT-AUT-001
  Regel: Saksbehandleren ser den høyeste poengsummen per kvote for hvert søknadsalternativ
    # Plasstildelingen bruker den samme poengsummen («Søkeren rangeres etter den høyeste
    # poengsummen i utdanningskvoten» i OPT-PLA-TIL-002).

    Scenario: Den høyeste poengsummen i kvoten vises
      Gitt at søkeren har poengsummen 48,5 for grunnlaget "VES" og 52,3 for grunnlaget "PRA" i en kvotetype for søknadsalternativet
      Når saksbehandleren ser oppsummeringen av saken
      Så ser saksbehandleren poengsummen 52,3 i kvotetypen for søknadsalternativet

    Scenario: Søknadsalternativ søkeren ikke er kvalifisert til, viser ingen poengsum
      Gitt at søkeren ikke er kvalifisert til søknadsalternativet
      Når saksbehandleren ser oppsummeringen av saken
      Så ser saksbehandleren ingen poengsum for søknadsalternativet
