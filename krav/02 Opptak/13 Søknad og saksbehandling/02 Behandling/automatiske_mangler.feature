# language: no
# BEGREPER (2026-11-10): Bytt «saksbehandlende organisasjon» med «behandler» når fila likevel endres. Se krav/02 Opptak/begreper.md.
# GitHub: #413
# Reglene er skilt ut fra OPT-BEH-BEH-008 (søknadsmangler.feature) 2026-11-02, så de kan leveres
# med den automatiske saksbehandlingen uten resten av søknadsmangler.
@OPT-BEH-BEH-036 @must @in-progress @scope-automatisk-ferdigbehandling
Egenskap: Automatiske mangler
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg at saken får mangler automatisk når søkeren ikke er kvalifisert, eller når generell studiekompetanse fullføres i vår
  slik at søkeren får beskjed om hva som mangler, uten at jeg må registrere manglene selv.

  Noen mangler lages automatisk. Er søkeren ikke kvalifisert, får saken automatiske
  mangeltekster for kravelementene søkeren ikke oppfyller, og tekstene slettes automatisk når
  søkeren blir kvalifisert. Mangelen for generell studiekompetanse som fullføres i vår, settes og
  sjekkes ut automatisk, med mangelkoden opptaksforvalteren har merket i regelverkssamlingen.
  Mangelkodene og manglene saksbehandleren registrerer, står i søknadsmangler (OPT-BEH-BEH-008).

  Bakgrunn:
    Gitt at opptaket bruker en regelverkssamling

  @depends-on-OPT-BEH-BEH-020 @ref-FLY-OPT-AUT-001 @ref-OPT-BEH-BEH-025 @ref-OPT-BEH-BEH-026
  Regel: Saken får automatiske mangeltekster når søkeren ikke er kvalifisert

    De automatiske mangeltekstene følger kvalifiseringen. Er søkeren ikke kvalifisert på
    kompetanseregelverket, har saken én automatisk mangeltekst for kompetanseregelverket. Teksten
    viser kravelementene som ikke er oppfylt, ordnet etter kravlistene, så søkeren ser at
    kravlistene er alternativer. Blir søkeren kvalifisert, slettes teksten automatisk. Det
    gjelder uansett om kravelementene er vurdert av den automatiske behandlingen eller av
    saksbehandleren i steget «Spesielle opptakskrav». En automatisk mangeltekst har ingen
    mangelkode, og saksbehandleren kan ikke gjøre noe med den. Mener saksbehandleren at søkeren
    oppfyller kravet, vurderer saksbehandleren kravelementet som oppfylt.

    # Avklart 30.10.2026: den automatiske behandlingen lager ikke mangler med mangelkode, bare
    # automatiske mangeltekster. Teksten lages av navnet på kravelementet, etter et fast mønster
    # som står i implementasjonsdetaljene. Kravelementene får ingen egen tekst til søkeren. Det
    # avviker fra raffineringen, som sa at tekstene skulle hentes fra opptakskravene.
    # Avklart 30.10.2026, endret 03.11.2026: er søkeren ikke kvalifisert på noen kravliste, får
    # kompetanseregelverket én samlet mangeltekst. Teksten har navnet på hvert kravelement som
    # ikke er oppfylt, gruppert per kravliste. Hvordan teksten ser ut, avgjøres i designet.
    # Avklart 30.10.2026: saksbehandleren kan ikke kommentere, sjekke ut eller slette en
    # automatisk mangeltekst.

    @implemented
    Scenariomal: Saken får en automatisk mangeltekst når <vurdert av> vurderer at et kravelement ikke er oppfylt
      Gitt at søknadsalternativene i saken har et kravelement
      Når <vurdert av> vurderer at kravelementet ikke er oppfylt
      Så er søkeren ikke kvalifisert
      Og har saken en automatisk mangeltekst som viser at kravelementet ikke er oppfylt

      Eksempler:
        | vurdert av                   |
        | den automatiske behandlingen |
        | saksbehandleren              |

    @implemented
    Scenario: Saken får ikke mangeltekst når søkeren er kvalifisert på en annen kravliste
      Gitt at søknadsalternativet har kravlisten "Matematikk R2" og kravlisten "Matematikk R1 og Fysikk 2"
      Og at vitnemålet har "Matematikk R1" og "Fysikk 2", men ikke "Matematikk R2"
      Når den automatiske behandlingen vurderer kravelementene
      Så er søkeren kvalifisert for søknadsalternativet
      Og saken har ikke en automatisk mangeltekst for "Matematikk R2"

    @implemented
    Scenario: Saken får mangeltekster i alle kravlistene når søkeren ikke er kvalifisert på noen
      Gitt at søknadsalternativet har kravlisten "Matematikk R2" og kravlisten "Matematikk R1 og Fysikk 2"
      Og at vitnemålet har "Matematikk R1", men ikke "Matematikk R2" og ikke "Fysikk 2"
      Når den automatiske behandlingen vurderer kravelementene
      Så har saken en automatisk mangeltekst for "Matematikk R2"
      Og saken har en automatisk mangeltekst for "Fysikk 2"

    Scenario: Mangelteksten viser kravelementene som ikke er oppfylt, ordnet etter kravlistene
      Gitt at søknadsalternativet har kravlisten "Matematikk R2" og kravlisten "Matematikk R1 og Fysikk 2"
      Og at vitnemålet har "Matematikk R1", men ikke "Matematikk R2" og ikke "Fysikk 2"
      Når den automatiske behandlingen vurderer kravelementene
      Så har saken én automatisk mangeltekst for kompetanseregelverket
      Og mangelteksten viser "Matematikk R2" under kravlisten "Matematikk R2"
      Og mangelteksten viser "Fysikk 2" under kravlisten "Matematikk R1 og Fysikk 2"
      Men mangelteksten viser ikke "Matematikk R1"

    @implemented
    Scenariomal: De automatiske mangeltekstene slettes når <vurdert av> vurderer at søkeren er kvalifisert
      Gitt at saken har en automatisk mangeltekst som viser at et kravelement ikke er oppfylt
      Når <vurdert av> vurderer at kravelementet er oppfylt
      Så er søkeren kvalifisert
      Og saken har ikke en automatisk mangeltekst for kravelementet

      Eksempler:
        | vurdert av                   |
        | den automatiske behandlingen |
        | saksbehandleren              |

    @implemented
    Scenario: Saksbehandleren ser de automatiske mangeltekstene sammen med de registrerte manglene
      Gitt at saken har en automatisk mangeltekst
      Og at saksbehandleren har registrert en mangel
      Når saksbehandleren åpner manglene i saken
      Så ser saksbehandleren den automatiske mangelteksten og mangelen saksbehandleren har registrert

    @implemented
    Scenario: Søkeren ser de automatiske mangeltekstene når saken er ferdig behandlet
      # Avklart 2026-11-02: tekstene publiseres når saken blir ferdig behandlet, hvis
      # saksbehandleren ikke har publisert dem før.
      Gitt at saken har en automatisk mangeltekst
      Når saken blir ferdig behandlet
      Så ser søkeren den automatiske mangelteksten i Min kompetanse

    @implemented
    Scenario: Søkeren ser ikke de automatiske mangeltekstene mens saken er under behandling
      Gitt at saken er under behandling
      Og at saken har en automatisk mangeltekst
      Når søkeren åpner dokumentasjonssiden i Min kompetanse
      Så ser ikke søkeren den automatiske mangelteksten

    @implemented
    Scenario: Søkeren ser mangeltekstene per søknadsalternativ
      Gitt at saken er ferdig behandlet
      Og at saken har en automatisk mangeltekst for søknadsalternativet
      Når søkeren åpner dokumentasjonssiden i Min kompetanse
      Så ser søkeren mangelteksten under søknadsalternativet

    @implemented
    Scenario: Søkeren ser ikke mangelteksten når søknadsalternativet er fjernet
      # Avklart 30.10.2026: mangelteksten slettes ikke, men vises ikke lenger.
      Gitt at saken har en automatisk mangeltekst for et kravelement for søknadsalternativet
      Og at ingen andre søknadsalternativer i saken har kravelementet
      Når søkeren fjerner søknadsalternativet fra søknaden
      Så ser ikke søkeren mangelteksten i Min kompetanse
      Og saken har fortsatt den automatiske mangelteksten

    @implemented
    Scenario: Saksbehandleren kan ikke endre en automatisk mangeltekst
      Gitt at saken har en automatisk mangeltekst
      Når saksbehandleren åpner manglene i saken
      Så ser ikke saksbehandleren muligheten til å kommentere, sjekke ut eller slette den automatiske mangelteksten

  @ref-FLY-OPT-AUT-001 @depends-on-OPT-BEH-BEH-008 @implemented
  # OPT-BEH-BEH-008: «Opptaksforvalteren forvalter mangelkodene i regelverkssamlingen»
  Regel: Opptaksforvalteren merker én mangelkode for generell studiekompetanse som fullføres i vår
    # Avklart 05.11.2026 (Jøran og Geir, #951): ingen automatikk setter mangler på søknadene som
    # finnes, eller gjør noe annet med dem, når regelverket eller innstillingene endres. Merkes
    # mangelkoden etter at søknadene er kommet inn, får sakene i dem ikke mangelen, og fjernes
    # merkingen, blir manglene som finnes, stående. Det skal ikke skje i praksis, fordi
    # opptaksforvalteren får en advarsel når opptaket opprettes uten merket mangelkode
    # (OPT-OVO-GRU-001).
    # Bør ses på: rutiner som retter opp søknadene og saksbehandlingen når regelverket eller
    # innstillingene endres etter at opptaket er åpnet. Problemer som dette håndteres der.
    # Avklart 05.11.2026 (#951): endrer søkeren søknaden etter merkingen, får sakene mangelen. Det
    # er søkerens endring, ikke merkingen, som setter den.

    Mangelkoden som er merket, er den saken får automatisk når søkeren oppgir at generell
    studiekompetanse fullføres i vår (se «Mangelen for generell studiekompetanse som fullføres i
    vår settes og sjekkes ut automatisk»). Bare én mangelkode i
    regelverkssamlingen kan være merket, og den må være i kategorien «Generelle krav» og stoppe
    for opptak.
    # I det gamle systemet het mangelkoden DUA. Eksemplet med to mangelkoder bruker den koden.

    Scenario: Opptaksforvalteren merker mangelkoden for generell studiekompetanse som fullføres i vår
      Gitt at regelverkssamlingen har en mangelkode i kategorien "Generelle krav", som stopper for opptak
      Når opptaksforvalteren merker mangelkoden for generell studiekompetanse som fullføres i vår
      Så er mangelkoden merket for generell studiekompetanse som fullføres i vår i regelverkssamlingen

    Scenario: Bare én mangelkode i regelverkssamlingen kan være merket for generell studiekompetanse som fullføres i vår
      Gitt at regelverkssamlingen har mangelkodene "DUA" og "VIT"
      Og at mangelkoden "DUA" er merket for generell studiekompetanse som fullføres i vår
      Når opptaksforvalteren merker mangelkoden "VIT" for generell studiekompetanse som fullføres i vår
      Så avvises endringen med melding om at mangelkoden "DUA" allerede er merket

    Scenariomal: Mangelkoden kan ikke merkes når den <avvik>
      Gitt at regelverkssamlingen har en mangelkode som <avvik>
      Når opptaksforvalteren merker mangelkoden for generell studiekompetanse som fullføres i vår
      Så avvises endringen

      Eksempler:
        | avvik                            |
        | er i kategorien "Spesielle krav" |
        | ikke stopper for opptak          |

    Scenario: Opptaksforvalteren ser en advarsel på mangelkodene når ingen mangelkode er merket
      Gitt at ingen mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Når opptaksforvalteren åpner mangelkodene i regelverkssamlingen
      Så ser opptaksforvalteren en advarsel om at ingen mangelkode er merket for generell studiekompetanse som fullføres i vår

    Scenario: Sakene i søknadene som finnes fra før, får ikke mangelen når mangelkoden merkes
      Gitt at ingen mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Og at søkeren har oppgitt i søknaden at generell studiekompetanse fullføres i vår
      Og at søknaden har saker hos to saksbehandlende organisasjoner
      Når opptaksforvalteren merker en mangelkode for generell studiekompetanse som fullføres i vår
      Så har ingen av sakene i søknaden den automatiske mangelen for generell studiekompetanse som fullføres i vår

    Scenario: Saken får mangelen når søkeren endrer søknaden etter at mangelkoden er merket
      Gitt at søkeren har oppgitt i søknaden at generell studiekompetanse fullføres i vår, før en mangelkode ble merket for generell studiekompetanse som fullføres i vår
      Og at saken ikke har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Og at en mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Når søkeren endrer søknaden
      Så har saken den automatiske mangelen for generell studiekompetanse som fullføres i vår

    Scenario: Manglene som finnes fra før, blir stående når merkingen fjernes
      Gitt at en mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Og at saken har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Når opptaksforvalteren fjerner merkingen av mangelkoden for generell studiekompetanse som fullføres i vår
      Så har saken fortsatt den automatiske mangelen for generell studiekompetanse som fullføres i vår

  @ref-FLY-OPT-AUT-001 @depends-on-OPT-SØK-SØK-018 @ref-OPT-OVO-GRU-001 @depends-on-OPT-BEH-BEH-008
  # OPT-BEH-BEH-008: «Saksbehandleren sjekker ut mangelen når søkeren har dokumentert på nytt»
  Regel: Mangelen for generell studiekompetanse som fullføres i vår settes og sjekkes ut automatisk

    Søkere som fullfører videregående opplæring i vår, oppgir i søknaden at generell
    studiekompetanse fullføres i vår, det vil si at vitnemålet kommer senere. Alle sakene i
    søknaden får da automatisk en mangel med mangelkoden opptaksforvalteren har merket i
    regelverkssamlingen (se «Opptaksforvalteren merker én mangelkode for generell studiekompetanse
    som fullføres i vår»). Mangelkoden er i kategorien «Generelle krav» og
    stopper for opptak. «Stopper for opptak» virker som for andre mangelkoder, og står i
    OPT-PLA-TIL-001.

    Mangelen er klar til publisering når den settes, så søkeren ser den i Min kompetanse, men
    søkeren får ikke egen melding om den. Endrer søkeren søknaden til at generell
    studiekompetanse ikke fullføres i vår, slettes mangelen hvis den ikke er sjekket ut.

    Når saken er behandlet helautomatisk, sjekker den automatiske behandlingen ut mangelen som et
    av de siste stegene før saken er ferdig behandlet. Saksbehandleren kan også sjekke
    ut mangelen, for eksempel når søkeren har dokumentert vitnemålet på annen måte.
    # Avklart 30.10.2026: er ingen mangelkode merket, får opptaksforvalteren et varsel første
    # gang en søknad ikke får mangelen, og en advarsel allerede når opptaket opprettes
    # (OPT-OVO-GRU-001).
    # Avklart 30.10.2026: saksbehandleren kan sjekke ut mangelen, men ikke slette den. Bare
    # automatikken sletter den, når søkeren endrer søknaden.
    # Avklart 30.10.2026: en mangel som er sjekket ut, blir stående når søkeren endrer søknaden.

    Scenario: Alle sakene i søknaden får mangel når søkeren oppgir at generell studiekompetanse fullføres i vår
      Gitt at en mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Og at søknaden har saker hos to saksbehandlende organisasjoner
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så har begge sakene i søknaden den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Og saksloggen viser at mangelen ble registrert fordi søkeren oppga at generell studiekompetanse fullføres i vår

    Scenario: Saken får ikke mangel når ingen mangelkode er merket
      Gitt at ingen mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så har ikke saken en automatisk mangel for generell studiekompetanse som fullføres i vår
      Og opptaksforvalteren ved organisasjonen som forvalter opptaket, får varsel om at ingen mangelkode er merket

    Scenario: Opptaksforvalteren får varselet bare første gang
      Gitt at ingen mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Og at opptaksforvalteren ved organisasjonen som forvalter opptaket, har fått varsel om at ingen mangelkode er merket
      Når en ny søker oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så får ikke opptaksforvalteren et nytt varsel

    Scenario: Søkeren ser den automatiske mangelen i Min kompetanse
      Gitt at en mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så ser søkeren mangelen for generell studiekompetanse som fullføres i vår i Min kompetanse

    @implemented
    Scenario: Søkeren får ikke egen melding om den automatiske mangelen
      Gitt at en mangelkode i regelverkssamlingen er merket for generell studiekompetanse som fullføres i vår
      Når søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår
      Så har søkeren ikke mottatt en melding om mangler

    Scenario: Mangelen slettes når søkeren endrer søknaden
      Gitt at saken har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Og at mangelen for generell studiekompetanse som fullføres i vår ikke er sjekket ut
      Når søkeren endrer søknaden til at generell studiekompetanse ikke fullføres i vår
      Så har ikke saken mangelen for generell studiekompetanse som fullføres i vår
      Og saksloggen viser at mangelen ble slettet fordi søkeren endret søknaden

    @implemented
    Scenario: Mangel som er sjekket ut slettes ikke når søkeren endrer søknaden
      Gitt at saken har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Og at mangelen for generell studiekompetanse som fullføres i vår er sjekket ut
      Når søkeren endrer søknaden til at generell studiekompetanse ikke fullføres i vår
      Så har saken fortsatt mangelen for generell studiekompetanse som fullføres i vår

    @implemented
    Scenario: Saksbehandleren kan ikke slette den automatiske mangelen
      # Avklart 06.11.2026: å sjekke ut mangelen står i OPT-BEH-BEH-008 («Saksbehandleren sjekker
      # ut mangelen når søkeren har dokumentert på nytt»), og gjentas ikke her.
      Gitt at saken har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Når saksbehandleren åpner manglene i saken
      Så ser saksbehandleren ikke muligheten til å slette mangelen for generell studiekompetanse som fullføres i vår

    Scenario: Mangelen sjekkes ut når saken er behandlet helautomatisk
      Gitt at saken har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Når den automatiske behandlingen har behandlet saken helautomatisk
      Så er mangelen for generell studiekompetanse som fullføres i vår sjekket ut før saken er ferdig behandlet
      Og saksloggen viser at den automatiske behandlingen sjekket ut mangelen

    @implemented
    Scenario: Mangelen sjekkes ikke ut når saken ikke er behandlet helautomatisk
      Gitt at saken har den automatiske mangelen for generell studiekompetanse som fullføres i vår
      Når den automatiske behandlingen sender saken til saksbehandleren
      Så er ikke mangelen for generell studiekompetanse som fullføres i vår sjekket ut
