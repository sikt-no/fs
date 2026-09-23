# language: no
@OPT-OPT-INN-001 @must @draft
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

  # Løses av teamet som jobber med utdanningstilbud?
  Regel: Opptaksforvalter setter kriterier for hvilke typer og nivåer av utdanninger som kan delta i opptaket

    Scenario: Sette utdanningstype
      Når opptaksforvalter setter at opptaket kun skal ha studieprogram
      Så er det kun studieprogram som kan legges til som utdanningstilbud

    Scenario: Sette NKR-nivåer for UHG-opptak
      Når opptaksforvalter setter at opptaket kun skal ha studieprogram
      Og opptaksforvalter setter at NKR-nivåene 6.1 Høgskolekandidat, 6.2 Bachelor, 7 Master
      Så er det kun studieprogram på disse nivåene som kan legges til som utdanningstilbud i opptaket

    Scenario: Sette NKR-nivåer for HYU-opptak
      Når opptaksforvalter setter at opptaket kun skal ha studieprogram
      Og opptaksforvalter setter at NKR-nivåene 5.1 fagskole og 5.2 fagskole
      Så er det kun fagskoleutdanninger av typen studieprogram som kan legges til som utdanningstilbud

    Scenario: Utdanninger utenfor kriteriene er ikke tilgjengelige
      Gitt at opptaket kun tillater studieprogram på 6.2 bachelornivå
      Så dukker ikke emner opp som mulige utdanningstilbud
      Og studieprogram på 7 masternivå dukker ikke opp som mulige utdanningstilbud

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

    Scenario: Sette startnummer for opptak
      Når opptaksforvalter setter søknadsnummer med startnummer 1001 for opptaket "UHG 2027"
      Så får søknader i opptaket løpende nummer fra 1001
      Og søknadsnummeret får navnet til opptaket "UHG 2027" som tillegg i søknadsnummeret som ikke er synlig for søker eller saksbehandler
      Og søknadsnumrene er dermed unike for dette opptaket, selv om det ikke ser slik ut for søker eller saksbehandler

  Regel: Opptaksforvalter kan sette tak for antall søknadsalternativer

    Scenario: Sette maks antall søknadsalternativer
      Når opptaksforvalter setter maks antall søknadsalternativer til 10
      Så kan ikke en søker legge til flere enn 10 prioriterte søknadsalternativer i sin søknad

  Regel: Opptaksforvalter kan sette tak for antall tilbud per tildelingsrunde

    Scenario: Sette tak for antall tilbud en søker kan få per runde
      Når opptaksforvalter setter tak for antall tilbud per tildelingsrunde til 1
      Så kan ikke plasstildelingen gi flere enn 1 tilbud i en enkelt runde til en søker

  Regel: Opptaksforvalter kan åpne for tidlig opptak

    Scenario: Aktivere tidlig opptak
      Når opptaksforvalter aktiverer tidlig opptak
      Så kan opptaksforvalter sette frist for tidlig opptak
      Og muligheten for tidlig opptak og frist for tidlig opptak blir tilgjengelig for søknad og saksbehandling
      # Følgevirkninger i søknad og saksbehandling: det blir informert om tidlig opptaksfrist til søkere, det blir mulig for søkere å søke om tidlig opptak, det blir mulig for saksbehandlere å behandle søknader om tidlig opptak

  Regel: Opptaksforvalter kan åpne for søknad på ledige studieplasser

    Scenario: Aktivere ledige studieplasser
      Når opptaksforvalter angir at opptaket tilbyr søknad på ledige studieplasser
      Så kan opptaksforvalter sette dato for når ledige studieplasser legges ut
      Og informasjon om muligheten for ledige studieplasser blir tilgjengelig for søknad og saksbehandling
      # Følgevirkninger i søknad og saksbehandling: restplasser kan legges ut til søkere for ny søknad etter ordinær plasstildeling, merk at for å få gjort plasstildeling på ledige studieplasser, så må utdanningstilbud åpnes for det, og runde for ledige studieplasser må gjennomføres. 

  Regel: Opptaksforvalter kan angi om det er lov å sette avvikende søknadsfrister

    Scenario: Tillate avvikende søknadsfrister per utdanningstilbud
      Når opptaksforvalter angir at det er lov å sette tidligere søknadsfrister per utdanningstilbud
      Så kan opptaksforvalter ved deltakende organisasjon sette egne søknadsfrister på sine utdanningstilbud

  Regel: Opptaksforvalter kan angi en siste frist for å endre søkers utdanningsbakgrunn

    Scenario: Sette frist for endring av utdanningsbakgrunn
      Når opptaksforvalter angir en frist for å endre søkers utdanningsbakgrunn
      Så kan ikke saksbehandlere endre søkers utdanningsbakgrunn etter denne fristen

    Scenario: Generell saksbehandlingsfrist gjelder når egen frist for endring av utdanningsbakgrunn ikke er satt
      Gitt at opptaksforvalter ikke har angitt en egen frist for å endre søkers utdanningsbakgrunn
      Så kan saksbehandlere endre søkers utdanningsbakgrunn frem til den generelle saksbehandlingsfristen

    Scenario: Tillate avvikende søknadsfrister per utdanningsbakgrunn @openquestion
      #jobbes denne med at et annet team?
      Når opptaksforvalter angir at det er lov å sette avvikende søknadsfrister per utdanningsbakgrunn
      |nordisk|
      |eu/eøs|
      |utenfor eu/eøs|
      |realkompetanse|
      |steinerskolen|
      Så kan opptaksforvalter opprette utdanningsbakgrunner med egne søknads- og dokumentasjonsfrister

  # Ikke relevant for samordna opptak 2027
  Regel: Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon

    Scenario: Åpne for dokumentasjonsopplasting
      Når opptaksforvalter angir at søkere kan laste opp dokumentasjon
      Så kan søkere laste opp dokumentasjon som del av søknaden

  @wont
  # Ikke relevant for samordna opptak
  Regel: Opptaksforvalter kan sette krav om studierett for å søke

    Scenario: Kreve studierett
      Når opptaksforvalter angir at det kreves studierett for å søke
      Så kan kun studenter med studierett ved lærestedet søke

  # Saksbehandlertildeling er flyttet til samordnet_opptak.feature — kun relevant for samordnede opptak
