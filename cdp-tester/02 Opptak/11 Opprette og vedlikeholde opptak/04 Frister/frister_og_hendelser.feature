# language: no
# Generert av fs-testcaser-cdp 2026-10-29
# Krav: krav/02 Opptak/11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature @ 0ec4b48 (blob 4f977a93b2f73bd3a3d521204894bf20d68d7574)
#
# Elleve regler har et åpent spørsmål om @ref- til kravet der fristen brukes. Spørsmålene endrer ikke hva som testes.
#
# «Åpne opptaket «<nøkkel>»» betyr: gå til «Opptak», skriv navnet på opptaket (fra miljøfila) i «Opptaksnavn», og velg opptaket i lista.
# «Utfylling A» står øverst i ../01 Grunnoppsett/opprett_opptak.feature.
# Fristene står i kort under «Generelle frister» i «Endre innstillinger for opptaket». Datoene skrives som i skjemaet (dd.mm.åååå, og tt:mm når feltet har klokkeslett).
# Scenarioene med @endrer-data endrer testdata-opptaket, og setter fristen tilbake til verdien de noterte.
@TST-OPT-OVO-FRI-001 @depends-on-OPT-OVO-FRI-001
Egenskap: Frister og hendelser for opptak
  Opptaksforvalteren ved forvaltende organisasjon setter fristene for opptaket, og fristene står på opptaket når
  det åpnes på nytt.

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud

    @endrer-data
    Scenario: Sette når redigering av utdanningstilbud åpner
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Redigering åpner»
      Og jeg skriver «01.10.2026» i «Redigering åpner»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «01.10.2026» i «Redigering åpner»
      # Setter tilbake:
      Og jeg setter «Redigering åpner» tilbake til verdien jeg noterte, og velger «Lagre»

    @endrer-data
    Scenario: Sette når redigering av utdanningstilbud stenger
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Redigering stenger»
      Og jeg skriver «06.06.2027» i «Redigering stenger»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «06.06.2027» i «Redigering stenger»
      # Setter tilbake:
      Og jeg setter «Redigering stenger» tilbake til verdien jeg noterte, og velger «Lagre»

    # Teknikk: ekvivalensklasser (gyldig dato, tom (testet i «De ordinære fristene …»), delvis utfylt dato)
    # Meldingen står i opptak.json:227 i fs-admin.
    @utledet
    Scenario: Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud: dato som er delvis fylt ut
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg fjerner datoen i «Redigering åpner», og skriver bare «01.10» der
      Så ser jeg «Ugyldig dato. Fyll inn hele datoen, eller la feltet stå tomt.» ved «Redigering åpner»
      Og kan «Lagre» ikke velges
      Og jeg velger «Avbryt»

  # Feltet har navnet fra API-et: «Frist for å trekke utdanningstilbud» [Sjekk begrep: om feltet vises i kortet «Redigering av studier»].
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for å trekke utdanningstilbud

    @endrer-data
    Scenario: Sette frist for å trekke utdanningstilbud
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdiene i «Redigering stenger» og «Frist for å trekke utdanningstilbud»
      Og jeg skriver «06.06.2027» i «Redigering stenger»
      Og jeg skriver «20.06.2027 23:59» i «Frist for å trekke utdanningstilbud»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «20.06.2027 23:59» i «Frist for å trekke utdanningstilbud»
      # Setter tilbake:
      Og jeg setter de to fristene tilbake til verdiene jeg noterte, og velger «Lagre»

    Scenario: Opptaket kan ikke lagres uten fristen for å trekke utdanningstilbud
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Frist for å trekke utdanningstilbud»
      Og jeg fjerner datoen i «Frist for å trekke utdanningstilbud»
      Så kan «Lagre» ikke velges
      Og «Frist for å trekke utdanningstilbud» er det eneste feltet under «Fyll ut obligatoriske felt:»
      # Kunne «Lagre» velges, er testcasen «Ikke bestått». Agenten velger ikke «Lagre» (R14), så ingenting er endret.
      Og jeg velger «Avbryt»

    @endrer-data
    Scenariomal: Fristen for å trekke utdanningstilbud kan være samme dag som redigeringen stenger, eller senere
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdiene i «Redigering stenger» og «Frist for å trekke utdanningstilbud»
      Og jeg skriver «06.06.2027» i «Redigering stenger»
      Og jeg skriver «<trekkfrist>» i «Frist for å trekke utdanningstilbud»
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      Når jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «<trekkfrist>» i «Frist for å trekke utdanningstilbud»
      # Setter tilbake:
      Og jeg setter de to fristene tilbake til verdiene jeg noterte, og velger «Lagre»

      Eksempler:
        | trekkfrist       |
        | 06.06.2027 23:59 |
        | 20.06.2027 23:59 |

    # Feil rekkefølge gir et varsel, ikke en sperre: opptaket lagres.
    @endrer-data
    Scenario: Varsel når fristen for å trekke utdanningstilbud er før redigeringen stenger
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdiene i «Redigering stenger» og «Frist for å trekke utdanningstilbud»
      Og jeg skriver «06.06.2027» i «Redigering stenger»
      Og jeg skriver «05.06.2027 23:59» i «Frist for å trekke utdanningstilbud»
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      Og jeg ser et varsel om at fristen for å trekke utdanningstilbud er før redigeringen av utdanningstilbud stenger [Sjekk begrep: teksten, og om varselet vises før eller etter «Lagre»]
      Når jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «05.06.2027 23:59» i «Frist for å trekke utdanningstilbud»
      # Setter tilbake:
      Og jeg setter de to fristene tilbake til verdiene jeg noterte, og velger «Lagre»

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne åpne for søkning

    @endrer-data
    Scenario: Sette søknadsdato
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Åpner for søking» i kortet «Søkeperiode»
      Og jeg skriver «01.02.2027» i «Åpner for søking» i kortet «Søkeperiode»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «01.02.2027» i «Åpner for søking» i kortet «Søkeperiode»
      # Setter tilbake:
      Og jeg setter «Åpner for søking» tilbake til verdien jeg noterte, og velger «Lagre»

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette generell søknadsfrist for opptaket

    @endrer-data
    Scenario: Sette ordinær søknadsfrist
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Ordinær søknadsfrist»
      Og jeg skriver «15.04.2027 23:59» i «Ordinær søknadsfrist»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «15.04.2027 23:59» i «Ordinær søknadsfrist»
      # Setter tilbake:
      Og jeg setter «Ordinær søknadsfrist» tilbake til verdien jeg noterte, og velger «Lagre»

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette omprioriteringsfrist

    @endrer-data
    Scenario: Sette omprioriteringsfrist
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Omprioriteringsfrist»
      Og jeg skriver «15.04.2027 23:59» i «Omprioriteringsfrist»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «15.04.2027 23:59» i «Omprioriteringsfrist»
      # Setter tilbake:
      Og jeg setter «Omprioriteringsfrist» tilbake til verdien jeg noterte, og velger «Lagre»

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for sletting av søknadsalternativer

    @endrer-data
    Scenario: Sette frist for sletting av søknadsalternativer
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Slette søknadsalternativer»
      Og jeg skriver «15.04.2027 23:59» i «Slette søknadsalternativer»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «15.04.2027 23:59» i «Slette søknadsalternativer»
      # Setter tilbake:
      Og jeg setter «Slette søknadsalternativer» tilbake til verdien jeg noterte, og velger «Lagre»

  # Kravet kaller den ordinære datoen «informasjonsdato for dokumentasjon». Skjermen kaller feltet «Ordinær frist» i kortet «Dokumentasjon».
  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdato for dokumentasjon og ettersendingsfrist

    @endrer-data
    Scenario: Sette informasjonsdato for dokumentasjon
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Ordinær frist» i kortet «Dokumentasjon»
      Og jeg skriver «15.04.2027 23:59» i «Ordinær frist» i kortet «Dokumentasjon»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «15.04.2027 23:59» i «Ordinær frist» i kortet «Dokumentasjon»
      # Setter tilbake:
      Og jeg setter «Ordinær frist» tilbake til verdien jeg noterte, og velger «Lagre»

    @endrer-data
    Scenario: Sette ettersendingsfrist
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Ettersendingsfrist»
      Og jeg skriver «01.07.2027 23:59» i «Ettersendingsfrist»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «01.07.2027 23:59» i «Ettersendingsfrist»
      # Setter tilbake:
      Og jeg setter «Ettersendingsfrist» tilbake til verdien jeg noterte, og velger «Lagre»

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser

    @endrer-data
    Scenario: Sette informasjonsfrist for ledige studieplasser
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og ledige studieplasser er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Ledige studieplasser» under «Valg for opptaket»
      Og jeg skriver «20.07.2027» i «Publiseres på nettsiden» i kortet «Ledige studieplasser»
      Og jeg skriver «25.07.2027» i «Åpner for søking» i kortet «Ledige studieplasser»
      Og jeg skriver «01.09.2027» i «Stenger for søking» i kortet «Ledige studieplasser»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «20.07.2027» i «Publiseres på nettsiden» i kortet «Ledige studieplasser»
      # Setter tilbake:
      Og jeg fjerner krysset for «Ledige studieplasser», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

    @endrer-data
    Scenario: Sette dato for når ledige studieplasser kan søkes
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og ledige studieplasser er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Ledige studieplasser» under «Valg for opptaket»
      Og jeg skriver «20.07.2027» i «Publiseres på nettsiden» i kortet «Ledige studieplasser»
      Og jeg skriver «25.07.2027» i «Åpner for søking» i kortet «Ledige studieplasser»
      Og jeg skriver «01.09.2027» i «Stenger for søking» i kortet «Ledige studieplasser»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «25.07.2027» i «Åpner for søking» i kortet «Ledige studieplasser»
      # Setter tilbake:
      Og jeg fjerner krysset for «Ledige studieplasser», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

    @endrer-data
    Scenario: Sette dato for når ledige studieplasser stenger for søkning
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og ledige studieplasser er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Ledige studieplasser» under «Valg for opptaket»
      Og jeg skriver «20.07.2027» i «Publiseres på nettsiden» i kortet «Ledige studieplasser»
      Og jeg skriver «25.07.2027» i «Åpner for søking» i kortet «Ledige studieplasser»
      Og jeg skriver «01.09.2027» i «Stenger for søking» i kortet «Ledige studieplasser»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «01.09.2027» i «Stenger for søking» i kortet «Ledige studieplasser»
      # Setter tilbake:
      Og jeg fjerner krysset for «Ledige studieplasser», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak

    @endrer-data
    Scenario: Sette søknadsfrist for tidlig opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og tidlig opptak er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg skriver «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
      Og jeg skriver «01.03.2027 23:59» i «Søknadsfrist» i kortet «Tidlig opptak»
      Og jeg skriver «01.03.2027 23:59» i «Dokumentasjonsfrist» i kortet «Tidlig opptak»
      Og jeg skriver «15.02.2027 23:59» i «Frist for å sette poenggrenser» i kortet «Tidlig opptak»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «01.03.2027 23:59» i «Søknadsfrist» i kortet «Tidlig opptak»
      # Setter tilbake:
      Og jeg fjerner krysset for «Kan søke på tidlig opptak», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

    @endrer-data
    Scenario: Sette dokumentasjonsfrist for tidlig opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og tidlig opptak er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg skriver «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
      Og jeg skriver «01.03.2027 23:59» i «Søknadsfrist» i kortet «Tidlig opptak»
      Og jeg skriver «01.03.2027 23:59» i «Dokumentasjonsfrist» i kortet «Tidlig opptak»
      Og jeg skriver «15.02.2027 23:59» i «Frist for å sette poenggrenser» i kortet «Tidlig opptak»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «01.03.2027 23:59» i «Dokumentasjonsfrist» i kortet «Tidlig opptak»
      # Setter tilbake:
      Og jeg fjerner krysset for «Kan søke på tidlig opptak», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

    Scenariomal: Opptaket kan ikke lagres uten <frist> når tidlig opptak er aktivert
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og tidlig opptak er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg skriver «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
      Og jeg fyller ut «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser» i kortet «Tidlig opptak» med «01.03.2027 23:59», bortsett fra «<felt>»
      Så kan «Lagre» ikke velges
      Og «<i banneret>» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

      Eksempler:
        | frist                                              | felt                           | i banneret                                     |
        | søknadsfristen for tidlig opptak                   | Søknadsfrist                   | Søknadsfrist (tidlig opptak)                   |
        | dokumentasjonsfristen for tidlig opptak            | Dokumentasjonsfrist            | Dokumentasjonsfrist (tidlig opptak)            |
        | fristen for å sette poenggrenser for tidlig opptak | Frist for å sette poenggrenser | Frist for å sette poenggrenser (tidlig opptak) |

    @endrer-data
    Scenario: Sette frist for poenggrenser for tidlig opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og tidlig opptak er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg skriver «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
      Og jeg skriver «01.03.2027 23:59» i «Søknadsfrist» i kortet «Tidlig opptak»
      Og jeg skriver «01.03.2027 23:59» i «Dokumentasjonsfrist» i kortet «Tidlig opptak»
      Og jeg skriver «15.02.2027 23:59» i «Frist for å sette poenggrenser» i kortet «Tidlig opptak»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «15.02.2027 23:59» i «Frist for å sette poenggrenser» i kortet «Tidlig opptak»
      # Setter tilbake:
      Og jeg fjerner krysset for «Kan søke på tidlig opptak», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

    # Teknikk: beslutningstabell (kortet «Tidlig opptak» vises bare når valget er på)
    @utledet
    Scenario: Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak: fristene vises bare når tidlig opptak er på
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A
      Så ser jeg ikke kortet «Tidlig opptak» under «Generelle frister»
      Når jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Så ser jeg kortet «Tidlig opptak», med «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser»
      Når jeg fjerner krysset for «Kan søke på tidlig opptak»
      Så ser jeg ikke kortet «Tidlig opptak»
      Og jeg velger «Avbryt»

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for opptaksresultat

    @endrer-data
    Scenario: Sette dato for når hovedopptaket publiseres og søker kan forvente svar
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Publiseringsdato»
      Og jeg skriver «15.07.2027» i «Publiseringsdato»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «15.07.2027» i «Publiseringsdato»
      # Setter tilbake:
      Og jeg setter «Publiseringsdato» tilbake til verdien jeg noterte, og velger «Lagre»

    # Åpent spørsmål (Q19): er første svarfrist svarfristen på hovedrunden, eller en egen dato på opptaket? Testes som det står.
    @endrer-data
    Scenario: Sette første svarfrist som informasjon til søkere
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Svarfrist» i kortet «Hovedopptak» [Sjekk begrep: om feltet finnes i skjermen]
      Og jeg skriver «20.07.2027 23:59» i «Svarfrist»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «20.07.2027 23:59» i «Svarfrist»
      # Setter tilbake:
      Og jeg setter «Svarfrist» tilbake til verdien jeg noterte, og velger «Lagre»

  Regel: Opptaksforvalter setter dato for aldersberegning

    @endrer-data
    Scenario: Sette dato for aldersberegning
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Dato for aldersberegning»
      Og jeg skriver «31.12.2027» i «Dato for aldersberegning»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «31.12.2027» i «Dato for aldersberegning»
      Og feltet har ikke klokkeslett
      # Setter tilbake:
      Og jeg setter «Dato for aldersberegning» tilbake til verdien jeg noterte (eller tomt), og velger «Lagre»

    @endrer-data
    Scenario: Standarddato når datoen ikke er satt
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdiene i «Publiseringsdato» og «Dato for aldersberegning»
      Og jeg skriver «15.07.2027» i «Publiseringsdato»
      Og jeg fjerner datoen i «Dato for aldersberegning»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «31.12.2027» i «Dato for aldersberegning» [Sjekk begrep: om standarddatoen vises i feltet, eller bare i hjelpeteksten]
      # Setter tilbake:
      Og jeg setter de to datoene tilbake til verdiene jeg noterte (eller tomt), og velger «Lagre»

  Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn

    @endrer-data
    Scenario: Sette frist for endring av utdanningsbakgrunn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Endre utdanningsbakgrunn»
      Og jeg skriver «01.05.2027 23:59» i «Endre utdanningsbakgrunn»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «01.05.2027 23:59» i «Endre utdanningsbakgrunn»
      # Setter tilbake:
      Og jeg setter «Endre utdanningsbakgrunn» tilbake til verdien jeg noterte, og velger «Lagre»

  Regel: Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister

    # [Sjekk testdata: «Realkompetanse» står i «Godkjente utdanningsbakgrunner» i opptaket, og har ikke avvikende frister]
    @endrer-data
    Scenario: Legge til utdanningsbakgrunn med avvikende frister
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og «Realkompetanse» står i «Godkjente utdanningsbakgrunner» i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Legg til ny utdanningsbakgrunn» under «Utdanningsbakgrunner med avvikende frister»
      Og jeg velger «Realkompetanse» i «Utdanningsbakgrunner» i «Legg til utdanningsbakgrunner»
      Og jeg velger «Legg til»
      Og jeg skriver «01.03.2027 23:59» i «Søknadsfrist» i kortet «Realkompetanse»
      Og jeg skriver «01.03.2027 23:59» i «Frist dokumentasjon» i kortet «Realkompetanse»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så har kortet «Realkompetanse» under «Utdanningsbakgrunner med avvikende frister» «01.03.2027 23:59» i «Søknadsfrist» og i «Frist dokumentasjon»
      # Setter tilbake:
      Og jeg velger «Fjern» i kortet «Realkompetanse», velger «Ja, fortsett» i «Er du sikker?», og velger «Lagre»

  Regel: De ordinære fristene må være satt for å lagre opptaket

    # Et obligatorisk datofelt som tømmes på et lagret opptak, settes tilbake til forrige verdi når feltet forlates
    # (OpptakDeadlineInput.tsx:133-136 i fs-admin). Da kan «Lagre» velges, og banneret vises ikke. Står datoen der
    # igjen etter at feltet er forlatt, er det beskrevet i den utledede testcasen under.
    Scenariomal: Opptaket kan ikke lagres uten <frist>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og alle de ordinære fristene er satt i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg fjerner datoen i «<felt>»
      Så kan «Lagre» ikke velges
      Og «<i banneret>» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

      Eksempler:
        | frist                                                  | felt                                        | i banneret                    |
        | datoen for når redigering av utdanningstilbud åpner    | Redigering åpner                            | Redigering åpner              |
        | datoen for når redigering av utdanningstilbud stenger  | Redigering stenger                          | Redigering stenger            |
        | datoen for når søknaden åpner                          | Åpner for søking (i kortet «Søkeperiode»)   | Åpner for søking              |
        | den ordinære søknadsfristen                            | Ordinær søknadsfrist                        | Ordinær søknadsfrist          |
        | omprioriteringsfristen                                 | Omprioriteringsfrist                        | Omprioriteringsfrist          |
        | fristen for sletting av søknadsalternativer            | Slette søknadsalternativer                  | Slette søknadsalternativer    |
        | informasjonsdatoen for dokumentasjon                   | Ordinær frist (i kortet «Dokumentasjon»)    | Ordinær frist (dokumentasjon) |
        | ettersendingsfristen                                   | Ettersendingsfrist                          | Ettersendingsfrist            |
        | fristen for endring av utdanningsbakgrunn              | Endre utdanningsbakgrunn                    | Endre utdanningsbakgrunn      |
        | datoen for når hovedopptaket publiseres                | Publiseringsdato                            | Publiseringsdato              |

    # Teknikk: ekvivalensklasser (obligatorisk dato: gyldig dato, tømt, delvis utfylt (testet under redigering av utdanningstilbud))
    # OpptakDeadlineInput.tsx:133-136 i fs-admin: en obligatorisk dato som tømmes, settes tilbake til forrige verdi når feltet forlates.
    @utledet
    Scenario: De ordinære fristene må være satt for å lagre opptaket: en obligatorisk frist kan ikke tømmes
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og alle de ordinære fristene er satt i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Ordinær søknadsfrist»
      Og jeg fjerner datoen i «Ordinær søknadsfrist»
      Og jeg velger feltet «Omprioriteringsfrist»
      Så står verdien jeg noterte, i «Ordinær søknadsfrist»
      Og jeg ser ikke «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

    Scenariomal: Opptaket kan ikke lagres uten <frist> når ledige studieplasser er aktivert
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og ledige studieplasser er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Ledige studieplasser» under «Valg for opptaket»
      Og jeg fyller ut «Publiseres på nettsiden» med «20.07.2027», «Åpner for søking» med «25.07.2027» og «Stenger for søking» med «01.09.2027» i kortet «Ledige studieplasser», bortsett fra «<felt>»
      Så kan «Lagre» ikke velges
      Og «<i banneret>» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

      Eksempler:
        | frist                                                      | felt                    | i banneret                                     |
        | informasjonsfristen for ledige studieplasser               | Publiseres på nettsiden | Publiseres på nettsiden (ledige studieplasser) |
        | datoen for når ledige studieplasser kan søkes              | Åpner for søking        | Åpner for søking (ledige studieplasser)        |
        | datoen for når ledige studieplasser stenger for søkning    | Stenger for søking      | Stenger for søking (ledige studieplasser)      |

    @endrer-data
    Scenario: Dato for aldersberegning og avvikende frister kan stå tomme
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og alle de ordinære fristene er satt i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Dato for aldersberegning», og hvilke kort som står under «Utdanningsbakgrunner med avvikende frister»
      Og jeg fjerner datoen i «Dato for aldersberegning»
      Og jeg velger «Fjern» i hvert kort under «Utdanningsbakgrunner med avvikende frister», og «Ja, fortsett» i «Er du sikker?»
      Og jeg ser «Ingen utdanningsbakgrunner har avvikende frister. Søkerne følger de generelle fristene.»
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      # Setter tilbake:
      Og jeg setter «Dato for aldersberegning» og de avvikende fristene tilbake til det jeg noterte, og velger «Lagre»
