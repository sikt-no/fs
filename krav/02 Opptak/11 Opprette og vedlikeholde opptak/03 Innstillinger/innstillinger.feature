# language: no
@OPT-OVO-INN-001 @must @implemented @scope-opprette-opptak-2027
Egenskap: Innstillinger for opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å sette innstillinger for opptaket
  slik at opptaket har riktige rammer for søknad, saksbehandling og plasstildeling.
  # I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon endre innstillinger.
  # I lokale opptak er forvaltende organisasjon den eneste organisasjonen.
  # AVKLART 2026-10-19 (akseptansetesten): Kravet her beskriver at innstillingene settes og finnes på opptaket.
  # Virkningen av hver innstilling står i kravet der innstillingen brukes, og det står under hver regel hvor.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  # AVKLART 2026-10-21 (produkteier): Opptakstype og regelverkssamling kan bare endres så lenge ingen
  # utdanningstilbud er knyttet til opptaket. Det erstatter avklaringen 2026-10-19 om at de kan endres når som
  # helst, med varsel om at utdanningstilbudene mister reglene.
  # Opptakstypen brukes bare til å kategorisere opptaket, og har ingen annen funksjon i systemet.
  Regel: Opptaksforvalter kan endre opptakstype så lenge ingen utdanningstilbud er knyttet til opptaket

    Scenario: Endre opptakstype når ingen utdanningstilbud er knyttet til opptaket
      Gitt at opptaket ikke har noen utdanningstilbud
      Når opptaksforvalter endrer opptakstype for opptaket
      Så er opptakstypen oppdatert

    Scenario: Kan ikke endre opptakstype når utdanningstilbud er knyttet til opptaket
      Gitt at opptaket har utdanningstilbud
      Så kan ikke opptaksforvalter endre opptakstypen

  Regel: Opptaksforvalter kan endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket

    # Hvilke regler utdanningstilbudene kan bruke, står i
    # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature.
    Scenario: Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket
      Gitt at opptaket ikke har noen utdanningstilbud
      Når opptaksforvalter endrer regelverkssamlingen til "UHG 2027 v2"
      Så har opptaket regelverkssamlingen "UHG 2027 v2"

    Scenario: Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket
      Gitt at opptaket har utdanningstilbud som bruker regler fra gjeldende regelverkssamling
      Så kan ikke opptaksforvalter endre regelverkssamlingen

  # Poenglikhetsregel for ledige studieplasser styres av rundetypen i plasstildelingen,
  # ikke av opptakets standard poenglikhetsregel. Se krav/02 Opptak/14 Plasstildeling/.
  # Virkningen står i 12 Utdanningstilbud/04 Behandle et utdanningstilbud/overstyre_regler_for_poenglikhet.feature
  # og 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  @ref-OPT-PLA-TIL-002
  Regel: Opptaksforvalter setter standard poenglikhetsregel for opptaket

    Scenario: Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud
      Når opptaksforvalter setter standard poenglikhetsregel til "loddtrekning"
      Og opptaksforvalter angir at utdanningstilbud kan velges blant andre tilgjengelige regler
        | Poenglikhetsregel                          |
        | Alle søkere med samme poengsum får tilbud  |
        | Alder, eldre foran yngre                   |
      Så har opptaket loddtrekning som standard poenglikhetsregel
      Og reglene i tabellen er tilgjengelige som unntak for utdanningstilbudene i opptaket

    Scenario: Standard poenglikhetsregel uten mulighet for unntak
      Når opptaksforvalter kun setter standard poenglikhetsregel til "rangering etter alder"
      Så har opptaket rangering etter alder som standard poenglikhetsregel
      Og opptaket har ingen poenglikhetsregler som er tilgjengelige som unntak for utdanningstilbudene

  Regel: Opptaksforvalter kan sette startnummer for søknadene

    # AVKLART 2026-10-15 (Q18, TAKE-413): Søker og saksbehandler ser bare løpenummeret, ikke opptakskoden.
    # Nummeret er unikt i opptaket, men nummerserien kan ha hull.
    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/søke_på_opptak.feature.
    Scenario: Sette startnummer for søknader i opptaket
      Når opptaksforvalter setter startnummer 1001 for søknadene i opptaket
      Så har opptaket startnummer 1001 for søknadene

    # AVKLART 2026-10-19: Startnummeret er ikke obligatorisk.
    Scenario: Startnummeret er 1 når opptaksforvalter ikke har satt det
      Gitt at opptaksforvalter ikke har satt startnummer for søknader i opptaket
      Så har opptaket startnummer 1 for søknadene

  Regel: Opptaksforvalter setter tak for antall søknadsalternativer

    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/studiekurv.feature.
    # AVKLART 2026-10-26 (ekstern akseptansetest, HK-dir): Når opptaket åpner for søknad på
    # ledige studieplasser, gjelder taket for den ordinære søknaden og for søknaden til ledige
    # studieplasser hver for seg. Med maks 10 kan søkeren ha opptil 10 søknadsalternativer i den
    # ordinære søknaden og opptil 10 i søknaden til ledige studieplasser.
    Scenario: Sette maks antall søknadsalternativer
      Når opptaksforvalter setter maks antall søknadsalternativer til 10
      Så har opptaket maks 10 søknadsalternativer

  # AVKLART 2026-10-19 (produkteier, etter fs-verify): Innstillingen er tilbake til tak for antall tilbud per
  # tildelingsrunde, slik fs-admin har feltet («Tilbud per tildelingsrunde», lagret i maks_antall_tilbud på opptaket).
  # Det erstatter regelen fra 2026-10-14 om hvor mange utdanningstilbud en søker kan få opptak til.
  # Taket er obligatorisk, er forhåndsutfylt med 1, og kan endres etter at opptaket er opprettet.
  # Virkningen i plasstildelingen står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  @ref-OPT-PLA-TIL-002 @deprecated
  Regel: Opptaksforvalter setter tak for antall tilbud per tildelingsrunde

    Scenario: Sette tak for antall tilbud per tildelingsrunde
      Når opptaksforvalter setter taket for antall tilbud per tildelingsrunde til 1
      Så har opptaket tak på 1 tilbud per tildelingsrunde

    Scenario: Taket er forhåndsutfylt med 1
      Når opptaksforvalter oppretter et nytt opptak
      Så er taket for antall tilbud per tildelingsrunde satt til 1

    Scenario: Endre taket etter at opptaket er opprettet
      Gitt at taket for antall tilbud per tildelingsrunde er 1
      Når opptaksforvalter endrer taket for antall tilbud per tildelingsrunde til 2
      Så har opptaket tak på 2 tilbud per tildelingsrunde

  Regel: Opptaksforvalter kan åpne for tidlig opptak

    # AVKLART 2026-10-15 (Q2, TAKE-408): Tidlig opptak krever både at opptaket åpner for tidlig opptak, og at
    # utdanningstilbudet tilbyr det. Det gjelder i søknaden, i kvitteringen og i saksbehandlingen. Et
    # utdanningstilbud kan bare tilby tidlig opptak når opptaket åpner for det, se
    # 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature.
    # Virkningen for søkerne står i 13 Søknad og saksbehandling/01 Søknad/søke_om_tidlig_opptak.feature.
    # Fristene for tidlig opptak settes i 04 Frister/frister_og_hendelser.feature, og må være satt når tidlig
    # opptak er aktivert.
    Scenario: Aktivere tidlig opptak
      Når opptaksforvalter aktiverer tidlig opptak
      Så er tidlig opptak aktivert for opptaket

    Scenario: Sette lenke til informasjon om tidlig opptak
      Gitt at tidlig opptak er aktivert for opptaket
      Når opptaksforvalter setter lenken "https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html" til informasjon om tidlig opptak
      Så har opptaket lenken til informasjon om tidlig opptak
      # Lagt til 09.10.2026 fra review av PR #654 (tidlig opptak): lenken settes per
      # opptak, av opptakseieren, ikke per utdanningstilbud. Er en del av å konfigurere
      # tidlig opptak i opptaket (#578). Ønske fra Min kompetanse i STEK-267. Søkerens side står i 13 Søknad og saksbehandling/01 Søknad/
      # søke_om_tidlig_opptak.feature. Koden har ikke noe felt for lenken i dag.

    # AVKLART 2026-10-15 (Q10, TAKE-408): Det er én lenke for alle språk. Hos Samordna opptak finnes informasjonen
    # bare på nynorsk i dag.
    Scenario: Lenken må være satt når tidlig opptak er aktivert
      Gitt at tidlig opptak er aktivert for opptaket
      Og at lenken til informasjon om tidlig opptak ikke er satt
      Når opptaksforvalter lagrer opptaket
      Så blir opptaket ikke lagret
      Og opptaksforvalter ser at lenken til informasjon om tidlig opptak må være satt

  Regel: Opptaksforvalter kan åpne for søknad på ledige studieplasser

    # Innstillingen gjelder hele opptaket. Hver plasstildelingsrunde åpnes for ledige studieplasser i
    # 14 Plasstildeling/01 Runder/forvalte_runder.feature, og bare når opptaket tilbyr det.
    # Søkerens side står i 13 Søknad og saksbehandling/01 Søknad/søke_på_ledige_studieplasser.feature.
    # AVKLART 2026-10-19 (akseptansetesten): Opptaksforvalter aktiverer ledige studieplasser og setter datoene,
    # og datoene finnes på opptaket. Datoene settes i 04 Frister/frister_og_hendelser.feature.

    Scenario: Aktivere ledige studieplasser
      Når opptaksforvalter angir at opptaket tilbyr søknad på ledige studieplasser
      Og opptaksforvalter setter datoene for ledige studieplasser
      Så er ledige studieplasser aktivert for opptaket
      Og opptaket har datoene for ledige studieplasser

  @ref-OPT-SØK-SØK-017
  Regel: Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket

    # Opptaksforvalter velger blant godkjente utdanningsbakgrunner fra utdanningsbakgrunn-tabellen.
    # Avvikende søknads- og dokumentasjonsfrister per utdanningsbakgrunn settes i
    # 04 Frister/frister_og_hendelser.feature.
    # Søkerens valg av utdanningsbakgrunn står i OPT-SØK-SØK-017.

    Scenario: Legge til utdanningsbakgrunner fra godkjent liste
      Når opptaksforvalter legger til utdanningsbakgrunner i opptaket
      Så kan opptaksforvalter velge blant utdanningsbakgrunner som er registrert i tabellen for godkjente utdanningsbakgrunner

    Scenario: Legge til flere utdanningsbakgrunner
      Når opptaksforvalter legger til utdanningsbakgrunnene "Realkompetanse", "Utenlandsk utdanning" og "Steinerskole" i opptaket
      Så finnes utdanningsbakgrunnene "Realkompetanse", "Utenlandsk utdanning" og "Steinerskole" i opptaket

    Scenario: Fjerne en utdanningsbakgrunn fra opptaket
      Gitt at utdanningsbakgrunnen "Steinerskole" er lagt til i opptaket
      Når opptaksforvalter fjerner "Steinerskole" fra opptaket
      Så finnes "Steinerskole" ikke lenger i opptaket

    # AVKLART 2026-10-15 (Q8, TAKE-407)
    Scenario: Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes
      Gitt at utdanningsbakgrunnen "Steinerskole" er lagt til i opptaket
      Og at en søker har valgt utdanningsbakgrunnen "Steinerskole"
      Når opptaksforvalter vil fjerne "Steinerskole" fra opptaket
      Så blir "Steinerskole" ikke fjernet
      Og opptaksforvalter ser at søkere har valgt utdanningsbakgrunnen

    # AVKLART 2026-10-19: Et opprettet opptak skal alltid ha minst én utdanningsbakgrunn.
    Scenario: Den siste utdanningsbakgrunnen kan ikke fjernes
      Gitt at "Steinerskole" er den eneste utdanningsbakgrunnen i opptaket
      Når opptaksforvalter vil fjerne "Steinerskole" fra opptaket
      Så blir "Steinerskole" ikke fjernet
      Og opptaksforvalter ser at opptaket må ha minst én utdanningsbakgrunn

  # Ikke relevant for samordna opptak 2027, men antatt løst allerede
  Regel: Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon

    # AVKLART 2026-10-15 (Q1, TAKE-413): Standardverdien er at søkerne kan laste opp dokumentasjon.
    # Innstillingen har alltid en verdi.
    # AVKLART 2026-10-15 (Q17, TAKE-413): Når opplasting er stengt, kan søkeren heller ikke ettersende
    # dokumentasjon. Saksbehandler kan fortsatt registrere dokumentasjon på søknaden.
    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/veilede_om_dokumentasjon.feature.
    Scenario: Opplasting er åpen når opptaksforvalter ikke har endret innstillingen
      Når opptaksforvalter oppretter et nytt opptak
      Så er opptaket åpent for at søkere kan laste opp dokumentasjon

    Scenario: Åpne for dokumentasjonsopplasting
      Når opptaksforvalter angir at søkere kan laste opp dokumentasjon
      Så er opptaket åpent for at søkere kan laste opp dokumentasjon

    Scenario: Stenge for dokumentasjonsopplasting
      Når opptaksforvalter angir at søkere ikke kan laste opp dokumentasjon
      Så er opptaket stengt for at søkere kan laste opp dokumentasjon

  @draft
  # Ikke relevant for samordna opptak
  Regel: Opptaksforvalter kan sette krav om studierett for å søke

    Scenario: Kreve studierett
      Når opptaksforvalter angir at det kreves studierett for å søke
      Så kan kun studenter med studierett ved lærestedet søke

  # Saksbehandlertildeling er flyttet til samordna_opptak.feature — kun relevant for samordnede opptak
  # Mulighet til å åpne for at utdanningstilbud skal kunne sette avvikende frister fra opptaket, gjelder foreløbig globalt
  # fordi det ikke har vært et problem at læresteder setter alternative frister uten avklaring med hk-dir før. Fristen settes på utdanningstilbudet.

