# language: no
@OPT-OVO-FRI-001 @must @in-progress @scope-opprette-opptak-2027
Egenskap: Frister og hendelser for opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å sette frister som styrer tidsrammene for opptaket
  slik at søkere, saksbehandlere og læresteder vet hva som gjelder når.

  # Disse fristene gjelder for alle utdanningstilbud og alle søkere i opptaket,
  # med mindre det er satt avvikende frister på utdanningstilbud eller utdanningsbakgrunn.
  # I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon endre frister for opptaket.
  # AVKLART 2026-10-19 (akseptansetesten): Kravet her beskriver at fristene settes og finnes på opptaket.
  # Virkningen av hver frist står i kravet der fristen brukes, og det står under hver regel hvor.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i legge_til_utdanningstilbud.feature, trekke_utdanningstilbud.feature og
    #   sette_studieplasser_og_antall_tilbud.feature. Skal regelen ha @ref-OPT-OPT-UTD-002, @ref-OPT-OPT-UTD-003
    #   og @ref-OPT-OPT-UTD-007?

    # AVKLART 2026-10-15 (Q4, Q5 og Q13, TAKE-410):
    # - Fristen stenger alt deltakende organisasjoner endrer på utdanningstilbudet. Unntaket er antall
    #   studieplasser. Oppdateringer fra utdanningsregisteret stoppes ikke. Antall tilbud som skal gis per
    #   utdanningskvote, settes på plasstildelingsrunden, og har sin egen periode (14 Plasstildeling).
    # - Alle utdanningstilbud i opptaket har samme redigeringsfrist. Et utdanningstilbud kan ikke ha egen frist.
    # - Forvaltende organisasjon kan fortsatt redigere etter fristen. I et lokalt opptak er lærestedet selv
    #   forvaltende organisasjon, så fristen begrenser ikke lærestedet.
    # Virkningen står i 12 Utdanningstilbud: perioden for å knytte til og redigere i
    # 02 Utdanningstilbud i opptak/legge_til_utdanningstilbud.feature, trekking i trekke_utdanningstilbud.feature,
    # og antall studieplasser i 03 Opptaksinnstillinger/sette_studieplasser_og_antall_tilbud.feature.
    # AVKLART 2026-10-19 (produkteier, erstatter avklaringen 2026-10-16): Låsen på antall studieplasser gjelder
    #   ikke opptaksforvalter ved forvaltende organisasjon, foreløpig. På sikt bør antall studieplasser komme fra
    #   antall plasser som er registrert på kullet i SIS.

    Scenario: Sette når redigering av utdanningstilbud åpner
      Når opptaksforvalter setter at redigering av utdanningstilbud åpner "2026-10-01"
      Så har opptaket dato for når redigering av utdanningstilbud åpner "2026-10-01"

    Scenario: Sette når redigering av utdanningstilbud stenger
      Når opptaksforvalter setter at redigering av utdanningstilbud stenger "2027-06-06"
      Så har opptaket dato for når redigering av utdanningstilbud stenger "2027-06-06"

  @ref-OPT-OPT-UTD-003
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for å trekke utdanningstilbud

    # Lagt til 2026-10-26: Trekkfristen er en egen frist, i tillegg til redigeringsfristen.
    # Virkningen står i 12 Utdanningstilbud/02 Utdanningstilbud i opptak/trekke_utdanningstilbud.feature.
    # AVKLART 2026-10-26 (produkteier): Trekkfristen må være satt for å lagre opptaket, og bør ikke være før
    # redigeringen av utdanningstilbud stenger.
    # AVKLART 2026-10-27 (produkteier, etter akseptansetesten): Feil rekkefølge gir et varsel, ikke en sperre.
    Scenario: Sette frist for å trekke utdanningstilbud
      Når opptaksforvalter setter fristen for å trekke utdanningstilbud til "2027-06-20 23:59"
      Så har opptaket frist for å trekke utdanningstilbud "2027-06-20 23:59"

    Scenario: Opptaket kan ikke lagres uten fristen for å trekke utdanningstilbud
      Gitt at fristen for å trekke utdanningstilbud ikke er satt
      Når opptaksforvalter lagrer opptaket
      Så blir opptaket ikke lagret
      Og opptaksforvalter ser at fristen for å trekke utdanningstilbud må være satt

    Scenariomal: Fristen for å trekke utdanningstilbud kan være samme dag som redigeringen stenger, eller senere
      Gitt at redigering av utdanningstilbud stenger "2027-06-06"
      Når opptaksforvalter setter fristen for å trekke utdanningstilbud til "<trekkfrist>"
      Og opptaksforvalter lagrer opptaket
      Så er opptaket lagret

      Eksempler:
        | trekkfrist       |
        | 2027-06-06 23:59 |
        | 2027-06-20 23:59 |

    Scenario: Varsel når fristen for å trekke utdanningstilbud er før redigeringen stenger
      Gitt at redigering av utdanningstilbud stenger "2027-06-06"
      Når opptaksforvalter setter fristen for å trekke utdanningstilbud til "2027-06-05 23:59"
      Og opptaksforvalter lagrer opptaket
      Så er opptaket lagret
      Og opptaksforvalter ser et varsel om at fristen for å trekke utdanningstilbud er før redigeringen av utdanningstilbud stenger

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne åpne for søkning
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i søke_på_opptak.feature og finne_studier.feature. Skal regelen ha @ref-OPT-SØK-SØK-001
    #   og @ref-OPT-SØK-SØK-013?

    # AVKLART 2026-10-19 (S1, akseptansetesten): Opptaket har ingen egen dato for når utdanningstilbudene
    # publiseres. Søkere kan ikke begynne på en søknad eller se utdanningstilbudene før søknaden åpner.
    # AVKLART 2026-10-15 (Q15, TAKE-412): Før det ser opptaksforvaltere og saksbehandlere utdanningstilbudene,
    # men ikke søkerne.
    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/søke_på_opptak.feature (søknaden) og
    # finne_studier.feature (Regel «Synlighet via søknadsperioden i opptaket»).
    Scenario: Sette søknadsdato
      Når opptaksforvalter setter at søknaden åpner "2027-02-01"
      Så har opptaket dato for når søknaden åpner "2027-02-01"

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette generell søknadsfrist for opptaket
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i søke_på_opptak.feature. Skal regelen ha @ref-OPT-SØK-SØK-001?

    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/søke_på_opptak.feature.
    Scenario: Sette ordinær søknadsfrist
      Når opptaksforvalter setter ordinær søknadsfrist til "2027-04-15 23:59"
      Så har opptaket ordinær søknadsfrist "2027-04-15 23:59"

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette omprioriteringsfrist
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i prioritere_søknadsalternativer.feature. Skal regelen ha @ref-OPT-SØK-SØK-006?

    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/prioritere_søknadsalternativer.feature.
    Scenario: Sette omprioriteringsfrist
      Når opptaksforvalter setter omprioriteringsfrist til "2027-04-15 23:59"
      Så har opptaket omprioriteringsfrist "2027-04-15 23:59"

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for sletting av søknadsalternativer
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i prioritere_søknadsalternativer.feature. Skal regelen ha @ref-OPT-SØK-SØK-006?

    # AVKLART 2026-10-15 (Q6, TAKE-411): Fristen for sletting kan være senere enn omprioriteringsfristen.
    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/prioritere_søknadsalternativer.feature.
    Scenario: Sette frist for sletting av søknadsalternativer
      Når opptaksforvalter setter frist for sletting av søknadsalternativer til "2027-04-15 23:59"
      Så har opptaket frist for sletting av søknadsalternativer "2027-04-15 23:59"

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdato for dokumentasjon og ettersendingsfrist
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i veilede_om_dokumentasjon.feature og søknadsmangler.feature. Skal regelen ha
    #   @ref-OPT-SØK-SØK-003 og @ref-OPT-BEH-BEH-008?
    # - Er ettersendingsfristen en frist (fristen for å rette en mangel, søknadsmangler.feature), eller en
    #   informasjonsdato? Den stenger ikke for opplasting.

    # AVKLART 2026-10-15 (Q14, TAKE-411): Den ordinære datoen er informasjon om når dokumentasjonen bør være
    # lastet opp.
    # AVKLART 2026-10-27 (produkteier, etter akseptansetesten): Ingen av datoene stenger for opplasting. Det gjør
    # bare innstillingen «Søker kan laste opp dokumenter» (03 Innstillinger/innstillinger.feature). Den ordinære
    # datoen heter derfor informasjonsdato for dokumentasjon, ikke dokumentasjonsfrist: «frist» brukes bare om
    # datoer som har en virkning.
    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/veilede_om_dokumentasjon.feature og
    # 02 Behandling/søknadsmangler.feature.
    Scenario: Sette informasjonsdato for dokumentasjon
      Når opptaksforvalter setter informasjonsdatoen for dokumentasjon til "2027-04-15 23:59"
      Så har opptaket informasjonsdato for dokumentasjon "2027-04-15 23:59"

    Scenario: Sette ettersendingsfrist
      Når opptaksforvalter setter ettersendingsfrist til "2027-07-01 23:59"
      Så har opptaket ettersendingsfrist "2027-07-01 23:59"

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i søke_på_ledige_studieplasser.feature. Skal regelen ha @ref-OPT-SØK-SØK-014?

    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/søke_på_ledige_studieplasser.feature.
    Scenario: Sette informasjonsfrist for ledige studieplasser
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Når opptaksforvalter setter informasjonsfrist for ledige studieplasser til "2027-07-20"
      Så har opptaket informasjonsfrist for ledige studieplasser "2027-07-20"

    Scenario: Sette dato for når ledige studieplasser kan søkes
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Når opptaksforvalter setter at ledige studieplasser kan søkes fra "2027-07-25"
      Så har opptaket dato for når ledige studieplasser kan søkes "2027-07-25"

    Scenario: Sette dato for når ledige studieplasser stenger for søkning
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Når opptaksforvalter setter at ledige studieplasser stenger for søkning "2027-09-01"
      Så har opptaket dato for når ledige studieplasser stenger for søkning "2027-09-01"

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i søke_om_tidlig_opptak.feature og opptaksinnstillinger_utdanningstilbud.feature. Skal
    #   regelen ha @ref-OPT-SØK-SØK-011 og @ref-OPT-OPT-UTD-004?

    # AVKLART 2026-10-15 (Q11, TAKE-408): Dokumentasjonsfristen for tidlig opptak settes på opptaket, og det
    # er den søkerne skal se. Koden har to koder for fristen i dag, og skal ha én.
    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/søke_om_tidlig_opptak.feature (søknadsfristen og
    # dokumentasjonsfristen) og i 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature
    # (fristen for poenggrenser).
    Scenario: Sette søknadsfrist for tidlig opptak
      Gitt at opptaket har aktivert tidlig opptak
      Når opptaksforvalter setter søknadsfrist for tidlig opptak til "2027-03-01 23:59"
      Så har opptaket søknadsfrist for tidlig opptak "2027-03-01 23:59"

    Scenario: Sette dokumentasjonsfrist for tidlig opptak
      Gitt at opptaket har aktivert tidlig opptak
      Når opptaksforvalter setter dokumentasjonsfrist for tidlig opptak til "2027-03-01 23:59"
      Så har opptaket dokumentasjonsfrist for tidlig opptak "2027-03-01 23:59"

    # AVKLART 2026-10-19 (akseptansetesten): Når tidlig opptak er aktivert, må søknadsfristen og
    # dokumentasjonsfristen for tidlig opptak være satt.
    # AVKLART 2026-10-21 (produkteier): Det gjelder også fristen for poenggrenser for tidlig opptak.
    Scenariomal: Opptaket kan ikke lagres uten <frist> når tidlig opptak er aktivert
      Gitt at opptaket har aktivert tidlig opptak
      Og at <frist> ikke er satt
      Når opptaksforvalter lagrer opptaket
      Så blir opptaket ikke lagret
      Og opptaksforvalter ser at <frist> må være satt

      Eksempler:
        | frist                                              |
        | søknadsfristen for tidlig opptak                   |
        | dokumentasjonsfristen for tidlig opptak            |
        | fristen for å sette poenggrenser for tidlig opptak |

    Scenario: Sette frist for poenggrenser for tidlig opptak
      Gitt at opptaket har aktivert tidlig opptak
      Når opptaksforvalter setter frist for å sette poenggrenser for tidlig opptak til "2027-02-15 23:59"
      Så har opptaket frist for å sette poenggrenser for tidlig opptak "2027-02-15 23:59"

  @openquestion
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for opptaksresultat
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i se_egen_søknad.feature. Skal regelen ha @ref-OPT-SØK-SØK-009?

    # Faktiske svarfrister og publiseringstidspunkter bestemmes ut fra innstillinger på plasstildelingsrunde og når plasstildelingensrundene faktisk blir publisert.
    # Virkningen står i 13 Søknad og saksbehandling/01 Søknad/se_egen_søknad.feature.

    Scenario: Sette dato for når hovedopptaket publiseres og søker kan forvente svar
      Når opptaksforvalter setter dato for når hovedopptaket publiseres til "2027-07-15"
      Så har opptaket dato for når hovedopptaket publiseres "2027-07-15"

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - (Q19, TAKE-414) Er første svarfrist svarfristen på hovedrunden, eller en egen dato på opptaket? Koden har
    #   fjernet datoen på opptaket, fordi svarfristen settes på plasstildelingsrunden. Anbefaling (produkteier
    #   2026-10-15): hovedrunden opprettes før søknaden åpner, så søkerne ser svarfristen derfra, og fristen
    #   ikke må settes to steder.
    Scenario: Sette første svarfrist som informasjon til søkere
      Når opptaksforvalter setter første svarfrist til "2027-07-20 23:59"
      Så har opptaket første svarfrist "2027-07-20 23:59"

  @ref-OPT-BEH-BEH-012 @ref-OPT-BEH-BEH-028
  # Selve utregningen av alderen skjer i saksbehandlingen, i regelen
  # «Søkerens alder beregnes på opptakets dato for aldersberegning».
  Regel: Opptaksforvalter setter dato for aldersberegning

    # Alderen søkeren har på denne datoen, brukes der regelverket har aldersgrenser,
    # for eksempel for å avgjøre om søkeren kan konkurrere i førstegangsvitnemålskvoten.

    Scenario: Sette dato for aldersberegning
      Når opptaksforvalter setter dato for aldersberegning til "2027-12-31"
      Så har opptaket dato for aldersberegning "2027-12-31"

    Scenario: Standarddato når datoen ikke er satt
      Gitt at opptaksresultatene publiseres i 2027
      Når opptaksforvalter ikke setter dato for aldersberegning
      Så er opptakets dato for aldersberegning "2027-12-31"

  @openquestion @ref-FLY-OPT-SAK-001
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i tildele_saksbehandlende_organisasjon.feature. Skal regelen ha @ref-OPT-BEH-BEH-011?

    # AVKLART 2026-10-19 (S3, akseptansetesten): Opptaket setter fristen, og saksbehandlertildelingen bruker den.
    # En endring av utdanningsbakgrunnen etter fristen flytter ikke søknaden til en annen saksbehandlende
    # organisasjon. Utdanningsbakgrunnen kan fortsatt endres, men bare opptaksforvalter ved forvaltende
    # organisasjon kan endre hvem som saksbehandler søknaden.
    # Virkningen står i 13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature
    # (Regel «Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak»).
    Scenario: Sette frist for endring av utdanningsbakgrunn
      Når opptaksforvalter setter frist for endring av utdanningsbakgrunn til "2027-05-01 23:59"
      Så har opptaket frist for endring av utdanningsbakgrunn "2027-05-01 23:59"

  @openquestion
  Regel: Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister
    # ÅPNE SPØRSMÅL:
    # - Virkningen står i søke_på_opptak.feature. Skal regelen ha @ref-OPT-SØK-SØK-001?

    # Opptaksforvalter legger eksplisitt til utdanningsbakgrunner som skal ha
    # egne søknads- og dokumentasjonsfrister. Utdanningsbakgrunner uten avvikende
    # frister følger opptakets generelle frister.
    # AVKLART 2026-10-15 (Q9, TAKE-407): Bare søknadsfristen og dokumentasjonsfristen kan overstyres per
    # utdanningsbakgrunn.
    # Virkningen for søkerne, også når søkeren bytter utdanningsbakgrunn (Q7), står i
    # 13 Søknad og saksbehandling/01 Søknad/søke_på_opptak.feature.

    Scenario: Legge til utdanningsbakgrunn med avvikende frister
      Når opptaksforvalter legger til utdanningsbakgrunnen "Realkompetanse" i opptaket
      Og opptaksforvalter setter søknadsfrist til "2027-03-01 23:59"
      Og opptaksforvalter setter dokumentasjonsfrist til "2027-03-01 23:59"
      Så har utdanningsbakgrunnen "Realkompetanse" søknadsfrist og dokumentasjonsfrist "2027-03-01 23:59" i opptaket

  # AVKLART 2026-10-21 (produkteier): Alle de ordinære fristene er obligatoriske, og leveres i scopet for å
  # opprette opptak nå. Det erstatter avklaringen 2026-10-19 om at fristene kan stå tomme (regelen «Fristene kan
  # stå tomme når opptaket lagres»). Fristene for tidlig opptak og ledige studieplasser er obligatoriske når de er
  # aktivert. Dato for aldersberegning og avvikende frister per utdanningsbakgrunn er valgfrie.
  # Hva en frist som ikke er satt, betyr når den brukes (Q3, TAKE-410 og TAKE-411), står i kravene der fristene
  # brukes.
  Regel: De ordinære fristene må være satt for å lagre opptaket

    Scenariomal: Opptaket kan ikke lagres uten <frist>
      Gitt at <frist> ikke er satt
      Når opptaksforvalter lagrer opptaket
      Så blir opptaket ikke lagret
      Og opptaksforvalter ser at <frist> må være satt

      Eksempler:
        | frist                                              |
        | datoen for når redigering av utdanningstilbud åpner    |
        | datoen for når redigering av utdanningstilbud stenger  |
        | datoen for når søknaden åpner                          |
        | den ordinære søknadsfristen                            |
        | omprioriteringsfristen                                 |
        | fristen for sletting av søknadsalternativer            |
        | informasjonsdatoen for dokumentasjon                   |
        | ettersendingsfristen                                   |
        | fristen for endring av utdanningsbakgrunn              |
        | datoen for når hovedopptaket publiseres                |

    Scenariomal: Opptaket kan ikke lagres uten <frist> når ledige studieplasser er aktivert
      Gitt at opptaket tilbyr søknad på ledige studieplasser
      Og at <frist> ikke er satt
      Når opptaksforvalter lagrer opptaket
      Så blir opptaket ikke lagret
      Og opptaksforvalter ser at <frist> må være satt

      Eksempler:
        | frist                                              |
        | informasjonsfristen for ledige studieplasser               |
        | datoen for når ledige studieplasser kan søkes              |
        | datoen for når ledige studieplasser stenger for søkning    |

    Scenario: Dato for aldersberegning og avvikende frister kan stå tomme
      Gitt at alle de ordinære fristene er satt
      Og at dato for aldersberegning ikke er satt
      Og at ingen utdanningsbakgrunn har avvikende frister
      Når opptaksforvalter lagrer opptaket
      Så er opptaket lagret

  @draft @openquestion
  Regel: Klokkeslettet for en frist er 23:59 som standard
    # ÅPNE SPØRSMÅL:
    # - Gjelder 23:59 for alle fristene og informasjonsdatoene, også datoene for når noe åpner (for eksempel
    #   når søknaden åpner), eller bare for datoene der noe stenger?

    # Lagt til 2026-10-27 etter akseptansetesten (TAKE-454): Med 00:00 blir fristene lett satt feil.
    Scenario: Ny frist får klokkeslettet 23:59
      Når opptaksforvalter setter den ordinære søknadsfristen til "2027-04-15" uten klokkeslett
      Så har opptaket ordinær søknadsfrist "2027-04-15 23:59"

  # AVKLART 2026-10-21 (produkteier): Sammenhengene mellom fristene er ikke viktige å levere nå.
  @draft @openquestion
  Regel: Opptaksforvalter får et varsel når fristene står i feil rekkefølge
    # ÅPNE SPØRSMÅL:
    # - Hvilke frister bør ligge før andre? Kandidater: åpner før stenger (redigering av utdanningstilbud, søknaden,
    #   ledige studieplasser), informasjonsdatoen for dokumentasjon senest lik ettersendingsfristen, søknadsfristen og
    #   informasjonsdatoen for dokumentasjon for tidlig opptak før den ordinære søknadsfristen, fristen for poenggrenser
    #   før søknadsfristen for tidlig opptak, omprioriteringsfristen og fristen for sletting etter at søknaden åpner,
    #   og avvikende frister per utdanningsbakgrunn etter at søknaden åpner.

    # AVKLART 2026-10-27 (produkteier, etter akseptansetesten, TAKE-457): Feil rekkefølge gir et varsel
    # (veiledning), ikke en sperre. Opptaket kan lagres, fordi et opptak kan ha grunner til å legge fristene
    # annerledes. Det gjelder alle fristene.
    Scenario: Varsel når sletting av søknadsalternativer er før søknaden åpner
      Gitt at søknaden åpner "2027-02-01"
      Når opptaksforvalter setter fristen for sletting av søknadsalternativer til "2027-01-15 23:59"
      Og opptaksforvalter lagrer opptaket
      Så er opptaket lagret
      Og opptaksforvalter ser et varsel om at fristen for sletting av søknadsalternativer er før søknaden åpner
