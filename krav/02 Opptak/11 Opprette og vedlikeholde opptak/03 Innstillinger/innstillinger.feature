# language: no
@OPT-OVO-INN-001 @must @in-progress
Egenskap: Innstillinger for opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å sette innstillinger for opptaket
  slik at opptaket har riktige rammer for søknad, saksbehandling og plasstildeling.
  # I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon endre innstillinger.
  # I lokale opptak er forvaltende organisasjon den eneste organisasjonen.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter kan endre opptakstype

    Scenario: Endre opptakstype
      Når opptaksforvalter endrer opptakstype for opptaket
      Så er opptakstypen oppdatert

  Regel: Opptaksforvalter kan endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket

    Scenario: Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket
      Gitt at opptaket ikke har noen utdanningstilbud
      Når opptaksforvalter endrer regelverkssamlingen til "UHG 2027 v2"
      Så er reglene i den nye regelverkssamlingen tilgjengelige for utdanningstilbud i opptaket

    Scenario: Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket
      Gitt at opptaket har utdanningstilbud som bruker regler fra gjeldende regelverkssamling
      Så kan ikke opptaksforvalter endre regelverkssamlingen

  # Poenglikhetsregel for ledige studieplasser styres av rundetypen i plasstildelingen,
  # ikke av opptakets standard poenglikhetsregel. Se krav/02 Opptak/14 Plasstildeling/.
  Regel: Opptaksforvalter setter standard poenglikhetsregel for opptaket

    Scenario: Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud
      Når opptaksforvalter setter standard poenglikhetsregel til "loddtrekning"
      Og opptaksforvalter angir at utdanningstilbud kan velges blant andre tilgjengelige regler
        | Poenglikhetsregel                          |
        | Alle søkere med samme poengsum får tilbud  |
        | Alder, eldre foran yngre                   |
      Så brukes loddtrekning som default for alle utdanningstilbud i opptaket
      Men det enkelte utdanningstilbud kan overstyre med en av de tilgjengelige reglene

    Scenario: Standard poenglikhetsregel uten mulighet for unntak
      Når opptaksforvalter kun setter standard poenglikhetsregel til "rangering etter alder"
      Så brukes rangering etter alder for alle utdanningstilbud i opptaket
      Og det er ikke mulig å overstyre regelen per utdanningstilbud

  Regel: Opptaksforvalter kan sette startnummer for søknadene

    Scenario: Sette startnummer for søknader i opptaket
      Når opptaksforvalter setter søknadsnummer med startnummer 1001 for opptaket "UHG 2027"
      Så får søknader i opptaket løpende nummer fra 1001
      Og søknadsnummeret får navnet til opptaket "UHG 2027" som tillegg i søknadsnummeret som ikke er synlig for søker eller saksbehandler
      Og søknadsnumrene er dermed unike for dette opptaket, selv om det ikke ser slik ut for søker eller saksbehandler

  Regel: Opptaksforvalter kan sette tak for antall søknadsalternativer

    Scenario: Sette maks antall søknadsalternativer
      Når opptaksforvalter setter maks antall søknadsalternativer til 10
      Så kan ikke en søker legge til flere enn 10 prioriterte søknadsalternativer i sin søknad

  Regel: Opptaksforvalter kan sette tak for antall tilbud per tildelingsrunde

    Scenario: Sette tak for antall tilbud en søker kan få per plasstildelingsrunde
      Når opptaksforvalter setter tak for antall tilbud per tildelingsrunde til 1
      Så kan ikke plasstildelingen gi flere enn 1 tilbud i en enkelt plasstildelingsrunde til en søker
      Og søker får se denne informasjonen

  Regel: Opptaksforvalter kan åpne for tidlig opptak

    Scenario: Aktivere tidlig opptak
      Når opptaksforvalter aktiverer tidlig opptak
      Så er tidlig opptak aktivert for opptaket
      Og muligheten for tidlig opptak blir tilgjengelig for søknad og saksbehandling
      # Frister for tidlig opptak settes i 04 Frister/frister_og_hendelser.feature

  Regel: Opptaksforvalter kan åpne for søknad på ledige studieplasser

    Scenario: Aktivere ledige studieplasser
      Når opptaksforvalter angir at opptaket tilbyr søknad på ledige studieplasser
      Så er ledige studieplasser aktivert for opptaket
      Og muligheten for ledige studieplasser blir tilgjengelig for søknad og saksbehandling
      # Datoer for ledige studieplasser settes i 04 Frister/frister_og_hendelser.feature

  Regel: Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket

    # Opptaksforvalter velger blant godkjente utdanningsbakgrunner fra utdanningsbakgrunn-tabellen.
    # Avvikende søknads- og dokumentasjonsfrister per utdanningsbakgrunn settes i
    # 04 Frister/frister_og_hendelser.feature.

    Scenario: Legge til utdanningsbakgrunner fra godkjent liste
      Når opptaksforvalter legger til utdanningsbakgrunner i opptaket
      Så kan opptaksforvalter velge blant utdanningsbakgrunner som er registrert i tabellen for godkjente utdanningsbakgrunner

    Scenario: Legge til flere utdanningsbakgrunner
      Når opptaksforvalter legger til utdanningsbakgrunnene "Realkompetanse", "Utenlandsk utdanning" og "Steinerskole" i opptaket
      Så finnes disse utdanningsbakgrunnene i opptaket
      Og søkere kan velge blant dem når de angir sin utdanningsbakgrunn

    Scenario: Fjerne en utdanningsbakgrunn fra opptaket
      Gitt at utdanningsbakgrunnen "Steinerskole" er lagt til i opptaket
      Når opptaksforvalter fjerner "Steinerskole" fra opptaket
      Så er "Steinerskole" ikke lenger tilgjengelig som utdanningsbakgrunn i opptaket

  # Ikke relevant for samordna opptak 2027, men antatt løst allerede
  Regel: Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon

    Scenario: Åpne for dokumentasjonsopplasting
      Når opptaksforvalter angir at søkere kan laste opp dokumentasjon
      Så kan søkere laste opp dokumentasjon som del av søknaden

    Scenario: Stenge for dokumentasjonsopplasting
      Når opptaksforvalter angir at søkere ikke kan laste opp dokumentasjon
      Så får søkere ikke laste opp dokumentasjon som del av søknaden

  @wont
  # Ikke relevant for samordna opptak
  Regel: Opptaksforvalter kan sette krav om studierett for å søke

    Scenario: Kreve studierett
      Når opptaksforvalter angir at det kreves studierett for å søke
      Så kan kun studenter med studierett ved lærestedet søke

  # Saksbehandlertildeling er flyttet til samordna_opptak.feature — kun relevant for samordnede opptak
  # Mulighet til å åpne for at utdanningstilbud skal kunne sette avvikende frister fra opptaket, gjelder foreløbig globalt
  # fordi det ikke har vært et problem at læresteder setter alternative frister uten avklaring med hk-dir før. Fristen settes på utdanningstilbudet.

