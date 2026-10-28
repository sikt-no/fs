# language: no
# Generert av fs-testcaser-cdp 2026-10-27
# Krav: krav/02 Opptak/11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature @ 0f010d4 (blob 045c8103c36017e82ce247206e78c26f383d4e8d)
#
# {KJØRING} byttes ut med dato og klokkeslett når kjøringen starter. Opptak kan ikke slettes, så opptak testen oppretter, har {KJØRING} i navnet.
# «Utfylling A» står øverst i ../01 Grunnoppsett/opprett_opptak.feature.
# «Åpne opptaket «<nøkkel>»» betyr: gå til «Opptak», skriv navnet på opptaket (fra miljøfila) i «Opptaksnavn», og velg opptaket i lista.
# Scenarioene med @endrer-data endrer testdata-opptaket, og setter det tilbake til verdiene de noterte.
#
# Poenglikhetsreglene heter noe annet i skjermen enn i kravet: «Loddtrekning» er «Loddnummer, laveste nummer først»,
# og «Alder, eldre foran yngre» / «rangering etter alder» er «Alder, eldste først». Stegene bruker skjermens ord
# (grunndata, V14__regelverk_grunndata.sql i fs-plattform, så de er like i alle miljøer).
@TST-OPT-OVO-INN-001 @depends-on-OPT-OVO-INN-001
Egenskap: Innstillinger for opptak
  Opptaksforvalteren ved forvaltende organisasjon setter innstillingene for opptaket, og innstillingene står på
  opptaket når det åpnes på nytt.

  Regel: Opptaksforvalter kan endre opptakstype så lenge ingen utdanningstilbud er knyttet til opptaket

    Scenario: Endre opptakstype når ingen utdanningstilbud er knyttet til opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har fylt ut som i Utfylling A, men med «Samordna opptak 2027 opptakstype (test {KJØRING})» i alle tre navnefeltene, og lagret
      Når jeg går til «Opptak», åpner «Samordna opptak 2027 opptakstype (test {KJØRING})», og velger «Endre innstillinger for opptaket»
      Og jeg velger «Samordna opptak til fagskoler» i «Opptakstype»
      Og jeg velger «Fyll inn testdatoer» under «Generelle frister», hvis fristene er tomme etter byttet
      Og jeg velger «Lagre»
      Og jeg går til «Opptak», og åpner opptaket igjen
      Så viser «Type» «Samordna opptak til fagskoler» [Sjekk begrep: siden kan vise koden «FSU»]

    Scenario: Kan ikke endre opptakstype når utdanningstilbud er knyttet til opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-med-utdanningstilbud» har minst ett utdanningstilbud
      Når jeg åpner opptaket «opptak-samordna-med-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Så kan jeg ikke velge en annen verdi i «Opptakstype» [Sjekk begrep: feltet er låst, eller valgene mangler]
      Og jeg velger «Avbryt»

  Regel: Opptaksforvalter kan endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket

    @endrer-data
    Scenario: Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-uten-utdanningstilbud» har ingen utdanningstilbud
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Regelverksamling knyttet til opptaket»
      Og jeg velger regelverkssamlingen «regelverkssamling-samordna-annen» i «Regelverksamling knyttet til opptaket»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen
      Så viser «Regelverksamling» regelverkssamlingen «regelverkssamling-samordna-annen»
      # Setter tilbake:
      Og jeg velger «Endre innstillinger for opptaket», setter «Regelverksamling knyttet til opptaket» tilbake til verdien jeg noterte, og velger «Lagre»

    Scenario: Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-med-utdanningstilbud» har utdanningstilbud som bruker regler fra regelverkssamlingen
      Når jeg åpner opptaket «opptak-samordna-med-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Så kan jeg ikke velge en annen verdi i «Regelverksamling knyttet til opptaket» [Sjekk begrep: feltet er låst, eller valgene mangler]
      Og jeg velger «Avbryt»

  Regel: Opptaksforvalter setter standard poenglikhetsregel for opptaket

    # [Sjekk testdata: at «Alle søkere med samme poengsum får tilbud» finnes som valg (`poenglikhetsregler` i miljøfila)]
    @endrer-data
    Scenario: Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdiene i «Poenglikhetsregel», «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.» og «Tillatte poenglikhetsregler»
      Og jeg velger «Loddnummer, laveste nummer først» i «Poenglikhetsregel»
      Og jeg krysser av for «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.»
      Og jeg velger disse i «Tillatte poenglikhetsregler»
        | Poenglikhetsregel                                               |
        | Alle søkere med samme poengsum får tilbud                       |
        | Alder, eldste først                                             |
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «Loddnummer, laveste nummer først» i «Poenglikhetsregel»
      Og «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.» er krysset av
      Og «Tillatte poenglikhetsregler» har de to reglene i tabellen, og ingen andre
      # Setter tilbake:
      Og jeg setter de tre feltene tilbake til verdiene jeg noterte, og velger «Lagre»

    @endrer-data
    Scenario: Standard poenglikhetsregel uten mulighet for unntak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdiene i «Poenglikhetsregel», «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.» og «Tillatte poenglikhetsregler»
      Og jeg velger «Alder, eldste først» i «Poenglikhetsregel»
      Og jeg fjerner krysset for «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «Alder, eldste først» i «Poenglikhetsregel»
      Og «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.» er ikke krysset av
      Og jeg ser ikke «Tillatte poenglikhetsregler»
      # Setter tilbake:
      Og jeg setter de tre feltene tilbake til verdiene jeg noterte, og velger «Lagre»

    # Teknikk: beslutningstabell (kan overstyres × valgte unntak)
    #   | Kan overstyres | Valgte unntak | Resultat                                              |
    #   | av             | –             | «Tillatte poenglikhetsregler» vises ikke, kan lagres  | (scenarioet over)
    #   | på             | ingen         | kan ikke lagres, «Tillatte poenglikhetsregler» mangler | (denne)
    #   | på             | én            | kan lagres                                            | (neste)
    #   | på             | flere         | kan lagres                                            | (første scenario)
    @utledet
    Scenario: Opptaksforvalter setter standard poenglikhetsregel for opptaket: kan overstyres uten valgte unntak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A
      Og jeg krysser av for «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.»
      Og jeg lar «Tillatte poenglikhetsregler» stå tomt
      Så kan «Lagre» ikke velges
      Og «Tillatte poenglikhetsregler» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

    # Teknikk: beslutningstabell (raden «på, én»)
    @utledet
    Scenario: Opptaksforvalter setter standard poenglikhetsregel for opptaket: kan overstyres med ett unntak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med «Samordna opptak 2027 ett unntak (test {KJØRING})» i alle tre navnefeltene
      Og jeg krysser av for «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.»
      Og jeg velger «Alder, eldste først» i «Tillatte poenglikhetsregler»
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      Når jeg går til «Opptak», åpner «Samordna opptak 2027 ett unntak (test {KJØRING})», og velger «Endre innstillinger for opptaket»
      Så har «Tillatte poenglikhetsregler» bare «Alder, eldste først»
      Og jeg velger «Avbryt»

  Regel: Opptaksforvalter kan sette startnummer for søknadene

    @endrer-data
    Scenario: Sette startnummer for søknader i opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Startnummer for søknader»
      Og jeg fjerner tallet i «Startnummer for søknader», og skriver «1001»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «1001» i «Startnummer for søknader»
      # Setter tilbake:
      Og jeg setter «Startnummer for søknader» tilbake til verdien jeg noterte, og velger «Lagre»

    # «Startnummer for søknader» er forhåndsutfylt med 1 (emptyObjectGenerators.ts i fs-admin). Scenarioet tømmer feltet.
    Scenario: Startnummeret er 1 når opptaksforvalter ikke har satt det
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med «Samordna opptak 2027 startnummer (test {KJØRING})» i alle tre navnefeltene
      Og jeg fjerner tallet i «Startnummer for søknader» (forhåndsutfylt med 1)
      Og jeg velger «Lagre»
      Og jeg går til «Opptak», åpner «Samordna opptak 2027 startnummer (test {KJØRING})», og velger «Endre innstillinger for opptaket»
      Så står «1» i «Startnummer for søknader»
      Og jeg velger «Avbryt»
      # Kan «Lagre» ikke velges med tomt felt, er det et funn av typen «Kravet dekker ikke»: skriv det i «Faktisk resultat».

    # Teknikk: grenseverdianalyse (minste gyldige verdi er 1, V0__kodeverk.sql:35 krever > 0)
    @utledet
    Scenario: Opptaksforvalter kan sette startnummer for søknadene: startnummer 1
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med «Samordna opptak 2027 startnummer 1 (test {KJØRING})» i alle tre navnefeltene
      Og jeg fjerner tallet i «Startnummer for søknader», og skriver «1»
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»

    # Teknikk: grenseverdianalyse og ekvivalensklasser (like under min, desimaltall og tekst er ugyldige)
    # Skjemaet godtar 0 (min={0}, OpptakSettings.tsx:280), og API-et avviser 0 med «En av de angitte verdiene er ugyldig»
    # (OpprettOpptakMutations.java:701). Kravet sier ikke hvilken melding som skal vises: en generell melding er et funn av typen «Kravet dekker ikke».
    @utledet
    Scenariomal: Opptaksforvalter kan sette startnummer for søknadene: ugyldig startnummer «<verdi>»
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med «Samordna opptak 2027 startnummer <verdi> (test {KJØRING})» i alle tre navnefeltene
      Og jeg fjerner tallet i «Startnummer for søknader», og skriver «<verdi>»
      Og jeg velger «Lagre», hvis det kan velges
      Så blir opptaket ikke lagret
      Og jeg ser hva som er galt med «Startnummer for søknader» [Sjekk begrep: meldingen]

      Eksempler:
        | verdi |
        | 0     |
        | 1,5   |
        | abc   |

    # Teknikk: grenseverdianalyse (største heltall i databasen, 2147483647)
    @utledet
    Scenario: Opptaksforvalter kan sette startnummer for søknadene: stort startnummer
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med «Samordna opptak 2027 stort startnummer (test {KJØRING})» i alle tre navnefeltene
      Og jeg fjerner tallet i «Startnummer for søknader», og skriver «2147483647»
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      Når jeg går til «Opptak», åpner «Samordna opptak 2027 stort startnummer (test {KJØRING})», og velger «Endre innstillinger for opptaket»
      Så står «2147483647» i «Startnummer for søknader»
      Og jeg velger «Avbryt»

  # AVKLART 2026-10-26 i kravet: taket gjelder ordinær søknad og ledige studieplasser hver for seg. Virkningen testes ikke her.
  Regel: Opptaksforvalter setter tak for antall søknadsalternativer

    @endrer-data
    Scenario: Sette maks antall søknadsalternativer
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdien i «Antall søknadsalternativer»
      Og jeg fjerner tallet i «Antall søknadsalternativer», og skriver «10»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «10» i «Antall søknadsalternativer»
      # Setter tilbake:
      Og jeg setter «Antall søknadsalternativer» tilbake til verdien jeg noterte, og velger «Lagre»

    # Teknikk: grenseverdianalyse (0 er like under minste gyldige verdi, 1 er minste gyldige verdi). Tomt felt er testet i opprett_opptak.feature.
    # Skjemaet godtar 0 (min={0}, OpptakSettings.tsx:293), og API-et avviser 0 med en generell melding.
    @utledet
    Scenariomal: Opptaksforvalter setter tak for antall søknadsalternativer: <verdi> søknadsalternativer
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med «Samordna opptak 2027 maks <verdi> (test {KJØRING})» i alle tre navnefeltene
      Og jeg fjerner tallet i «Antall søknadsalternativer» (forhåndsutfylt med 10), og skriver «<verdi>»
      Og jeg velger «Lagre», hvis det kan velges
      Så <resultat>

      Eksempler:
        | verdi | resultat                                                                                         |
        | 0     | blir opptaket ikke lagret, og jeg ser hva som er galt med «Antall søknadsalternativer» [Sjekk begrep: meldingen] |
        | 1     | ser jeg «Lagring vellykket»                                                                      |

  Regel: Opptaksforvalter kan åpne for tidlig opptak

    @endrer-data
    Scenario: Aktivere tidlig opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og tidlig opptak er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg skriver «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
      Og jeg fyller ut «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser» under «Tidlig opptak» med en dato 30 dager etter testdagen
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen
      Så står «Kan søke på tidlig opptak» som aktivert under «Oppsummert»
      # Setter tilbake:
      Og jeg velger «Endre innstillinger for opptaket», fjerner krysset for «Kan søke på tidlig opptak», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

    @endrer-data
    Scenario: Sette lenke til informasjon om tidlig opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og tidlig opptak er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg skriver «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
      Og jeg fyller ut «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser» under «Tidlig opptak» med en dato 30 dager etter testdagen
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
      # Setter tilbake:
      Og jeg fjerner krysset for «Kan søke på tidlig opptak», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

    Scenario: Lenken må være satt når tidlig opptak er aktivert
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg fyller ut «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser» under «Tidlig opptak» med en dato 30 dager etter testdagen
      Og jeg lar «Informasjonsside tidlig opptak» stå tomt
      Så kan «Lagre» ikke velges
      Og «Informasjonsside tidlig opptak» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

    # Teknikk: ekvivalensklasser (lenken: tom (scenarioet over), bare mellomrom, uten http eller https, med https (scenarioene over))
    @utledet
    Scenario: Opptaksforvalter kan åpne for tidlig opptak: lenke med bare mellomrom
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg fyller ut «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser» under «Tidlig opptak» med en dato 30 dager etter testdagen
      Og jeg skriver tre mellomrom i «Informasjonsside tidlig opptak»
      Så kan «Lagre» ikke velges
      Og «Informasjonsside tidlig opptak» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

    # Teknikk: ekvivalensklasser (lenken må være en http- eller https-adresse, V0__kodeverk.sql:30 og OpprettOpptakMutations.java:700)
    @utledet
    Scenario: Opptaksforvalter kan åpne for tidlig opptak: lenke uten http eller https
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med «Samordna opptak 2027 lenke (test {KJØRING})» i alle tre navnefeltene
      Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
      Og jeg fyller ut «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser» under «Tidlig opptak» med en dato 30 dager etter testdagen
      Og jeg skriver «www.samordnaopptak.no/tidlig-opptak» i «Informasjonsside tidlig opptak»
      Og jeg velger «Lagre»
      Så ser jeg «Lenken må være en http- eller https-adresse»
      Og jeg går til «Opptak», skriver «Samordna opptak 2027 lenke (test {KJØRING})» i «Opptaksnavn», og ser «Ingen opptak funnet»

  Regel: Opptaksforvalter kan åpne for søknad på ledige studieplasser

    @endrer-data
    Scenario: Aktivere ledige studieplasser
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og ledige studieplasser er ikke aktivert i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Ledige studieplasser» under «Valg for opptaket»
      Og jeg fyller ut disse under «Ledige studieplasser» i fristene
        | Felt                    | Dato       |
        | Publiseres på nettsiden | 20.07.2027 |
        | Åpner for søking        | 25.07.2027 |
        | Stenger for søking      | 01.09.2027 |
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så er «Ledige studieplasser» krysset av
      Og datoene i tabellen står i feltene under «Ledige studieplasser»
      # Setter tilbake:
      Og jeg fjerner krysset for «Ledige studieplasser», velger «Slå av valget» i «Slå av valget?», og velger «Lagre»

    # Teknikk: beslutningstabell (datoene for ledige studieplasser vises bare når valget er på)
    @utledet
    Scenario: Opptaksforvalter kan åpne for søknad på ledige studieplasser: datoene vises bare når valget er på
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A
      Så ser jeg ikke kortet «Ledige studieplasser» i fristene
      Når jeg krysser av for «Ledige studieplasser» under «Valg for opptaket»
      Så ser jeg kortet «Ledige studieplasser», med «Publiseres på nettsiden», «Åpner for søking» og «Stenger for søking»
      Når jeg fjerner krysset for «Ledige studieplasser»
      Så ser jeg ikke kortet «Ledige studieplasser» i fristene
      Og jeg velger «Avbryt»

  Regel: Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket

    Scenario: Legge til utdanningsbakgrunner fra godkjent liste
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og utdanningsbakgrunnene «utdanningsbakgrunner-godkjente» står blant de godkjente utdanningsbakgrunnene
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg åpner «Godkjente utdanningsbakgrunner»
      Så er «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» blant valgene
      Og jeg velger «Avbryt»

    @endrer-data
    Scenario: Legge til flere utdanningsbakgrunner
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer hvilke utdanningsbakgrunner som står i «Godkjente utdanningsbakgrunner»
      Og jeg velger «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» i «Godkjente utdanningsbakgrunner», de som ikke står der fra før
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» i «Godkjente utdanningsbakgrunner»
      # Setter tilbake:
      Og jeg fjerner de utdanningsbakgrunnene som ikke stod der fra før, og velger «Lagre»

    @endrer-data
    Scenario: Fjerne en utdanningsbakgrunn fra opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer hvilke utdanningsbakgrunner som står i «Godkjente utdanningsbakgrunner»
      Og jeg velger «Steinerskole» og «Realkompetanse» i «Godkjente utdanningsbakgrunner», de som ikke står der fra før, og velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Og jeg fjerner «Steinerskole» fra «Godkjente utdanningsbakgrunner»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «Steinerskole» ikke i «Godkjente utdanningsbakgrunner»
      Og «Realkompetanse» står der
      # Setter tilbake:
      Og jeg setter «Godkjente utdanningsbakgrunner» tilbake til de jeg noterte, og velger «Lagre»

    Scenario: Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og en søker har valgt «Steinerskole» i opptaket «opptak-utdanningsbakgrunn-valgt-av-soker»
      Når jeg åpner opptaket «opptak-utdanningsbakgrunn-valgt-av-soker»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg fjerner «Steinerskole» fra «Godkjente utdanningsbakgrunner»
      Og jeg velger «Lagre»
      Så ser jeg «Utdanningsbakgrunnen er valgt av en søker og kan ikke fjernes fra opptaket»
      Når jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «Steinerskole» i «Godkjente utdanningsbakgrunner»
      Og jeg velger «Avbryt»

    Scenario: Den siste utdanningsbakgrunnen kan ikke fjernes
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og «Steinerskole» er den eneste utdanningsbakgrunnen i opptaket «opptak-en-utdanningsbakgrunn»
      Når jeg åpner opptaket «opptak-en-utdanningsbakgrunn»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg fjerner «Steinerskole» fra «Godkjente utdanningsbakgrunner»
      Så ser jeg «Velg minst én utdanningsbakgrunn.» ved «Godkjente utdanningsbakgrunner»
      Og kan «Lagre» ikke velges
      Og «Godkjente utdanningsbakgrunner» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

  # «Ikke relevant for samordna opptak 2027, men antatt løst allerede» (kravet).
  Regel: Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon

    Scenario: Opplasting er åpen når opptaksforvalter ikke har endret innstillingen
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med «Samordna opptak 2027 opplasting (test {KJØRING})» i alle tre navnefeltene
      Og jeg velger «Lagre»
      Og jeg går til «Opptak», og åpner «Samordna opptak 2027 opplasting (test {KJØRING})»
      Så står «Søker kan laste opp dokumenter» som aktivert under «Oppsummert»
      Når jeg velger «Endre innstillinger for opptaket»
      Så er «Søker kan laste opp dokumenter» krysset av
      Og jeg velger «Avbryt»

    @endrer-data
    Scenario: Åpne for dokumentasjonsopplasting
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer om «Søker kan laste opp dokumenter» er krysset av
      Og jeg fjerner krysset for «Søker kan laste opp dokumenter», hvis det er krysset av, og velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Og jeg krysser av for «Søker kan laste opp dokumenter»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så er «Søker kan laste opp dokumenter» krysset av
      # Setter tilbake:
      Og jeg setter «Søker kan laste opp dokumenter» tilbake slik jeg noterte, og velger «Lagre»

    @endrer-data
    Scenario: Stenge for dokumentasjonsopplasting
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer om «Søker kan laste opp dokumenter» er krysset av
      Og jeg krysser av for «Søker kan laste opp dokumenter», hvis det ikke er krysset av, og velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Og jeg fjerner krysset for «Søker kan laste opp dokumenter»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så er «Søker kan laste opp dokumenter» ikke krysset av
      # Setter tilbake:
      Og jeg setter «Søker kan laste opp dokumenter» tilbake slik jeg noterte, og velger «Lagre»
