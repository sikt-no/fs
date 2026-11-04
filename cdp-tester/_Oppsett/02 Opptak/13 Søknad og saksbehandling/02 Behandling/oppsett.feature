# language: no
# Oppsett for testene i cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/ (samme sti under _Oppsett/)
#
# Kjøres først i hver kjøring, før testene i mappa og før flyten i _Løp/10 Opptaksløpet/. Lager reglene, unntakene og søknadene testene bruker, gjennom
# FS Admin og Min kompetanse, med {KJØRING} i kodene og navnene. Agenten skriver navn og URL i «Kjøringens testdata». Feiler et scenario, får nøkkelen
# ingen verdi, og testene som bruker den, blir «Ikke testet».
# {DATO:+N} er datoen N dager etter dagen kjøringen starter, og {DATO:-N} N dager før.
#
# Alt skjer i opptaket «opptak-samordna-saksbehandlertildeling». Ingenting utenfor opptaket endres. Opptaket finnes fra før (grunndata i miljøfila),
# fordi søknadene må sendes av søkere i Min kompetanse.
#
# Regelkodene er «K{KJØRING}-<suffiks>», med {KJØRING} uten mellomrom og kolon (for eksempel ååååmmdd-ttmm). En kode kan ha høyst 40 tegn, store
# bokstaver, tall og tegnene _:,.-+. Navnet er «<suffiks> (test {KJØRING})», bortsett fra «Inaktiv regel (test {KJØRING})» for «INA».
#
# SØKERNE. Høyst fem søkere i hele kjøringen: «soker-1» (norsk utdanningsbakgrunn), «soker-2» (utenlandsk), «soker-3» (steinerskole),
# «soker-4» (realkompetanse) og «soker-5» (endring og flytting). En søker har høyst én søknad i opptaket.
#   Søknadene opprettes i FS Admin på vegne av søkeren (Utfylling S), som «opptak-forvalter-forvaltende». Søkeren er en ny person med
#   fornavn «Test{KJØRING}» og etternavn etter nøkkelen (for eksempel «Soker1»), ID-type «Passnummer» og et passnummer som begynner med
#   «TST» og har {KJØRING} uten tegn. Aldri fødselsnummer. Agenten noterer navnet og søknadsnummeret i «Kjøringens testdata».
#   Bare «soker-1» logger inn selv og sender søknaden i Min kompetanse, fordi søkerens visning må ses der:
#   «Logg inn med ID-porten» → «TestID» → «Hent tilfeldig person» → «Autentiser» på https://test.minkompetanse.no, og søknaden sendes der.
# Søknadene til «soker-1» til «soker-4» opprettes bare her, og er bare lest av testene (noen scenarioer endrer og setter tilbake). «soker-5»
# endres i hvert scenario som trenger en annen fordeling («Endre søknad» på saken), og er derfor den eneste søkeren som endrer og flytter.
#
# Utfylling S: søknad på vegne av søkeren i FS Admin (som «opptak-forvalter-forvaltende»)
#   1. Fra opptaket: «Gå til søknader» → «Opprett søknad».
#   2. Under «Søker»: fyll inn fornavn, etternavn, fødselsdato (01.01.2000), kjønn, nasjonalitet «Norge», «ID-type» «Passnummer», «ID-nummer»,
#      adresse, postnummer «0001», poststed «Oslo», land «Norge», e-post «test{KJØRING}@example.invalid» og telefonnummer «99999999».
#   3. «Utdanningsbakgrunn»: utdanningsbakgrunnen oppsettet sier.
#   4. «Nytt søknadsalternativ»: legg til utdanningstilbudene i rekkefølgen oppsettet sier (første er prioritet 1).
#   5. Velg «Opprett søknad».
#   En søknad som skal endres, endres med «Endre søknad» på saken («Nytt søknadsalternativ», slett, «Lagre endringer»).
#   [Sjekk begrep: feltene som må fylles ut i «Opprett ny søknad»]
#
# Fordelingen skjer i tildelingsjobben. «Og fordelingen har kjørt (opptil 2 minutter)» betyr at agenten åpner siden på nytt omtrent hvert 30. sekund
# til hvert studieønske i søknaden har en «B-rolle» i saken, og ellers gir opp etter 2 minutter.
#
# Utfylling R: behandlertildelingsregel i FS Admin (som «opptak-forvalter-forvaltende»)
#   Fra opptaket: «Samordning» → «Saksbehandlertildelingsregler» → «Opprett».
#   «Kode», «Navn», «Status» («Aktiv» eller «Inaktiv»), «Hvem skal saksbehandle?» («Alle som deltar i opptaket», «Bare tilbyderen – også for
#   studieønsker uten egen regel», «Bare tilbyderen – bare dette studieønsket» eller «Tilbydere i samme sektor», og «Velg organisasjon» for sektor),
#   «Legg til unntak» under «Unntak for utdanningsbakgrunn» («Utdanningsbakgrunn», «Fordeles til») og under «Unntak for lærested» («Saksbehandles av»,
#   «På vegne av»). Velg «Lagre». «Tildelingsregelen er lagret.» vises.
@OPPSETT-OPT-BEH @ref-OPT-BEH-BEH-011 @ref-OPT-OVO-FRI-001
Egenskap: Oppsett for tildele saksbehandlende organisasjon
  Lager behandlertildelingsreglene og søknadene testene for tildele saksbehandlende organisasjon bruker, i utgangstilstanden testene forutsetter.

  Scenario: behandlertildelingsregler-i-opptaket
    Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
    Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling»
        Når jeg oppretter reglene i tabellen etter Utfylling R, alle med «Aktiv» unntatt «INA»
      | Kode (suffiks) | Hvem skal saksbehandle?                                    | Unntak for utdanningsbakgrunn                                       | Unntak for lærested («Saksbehandles av» → «På vegne av»)                                     |
      | ISO            | Bare tilbyderen – bare dette studieønsket                  | –                                                                   | –                                                                                            |
      | TIL            | Bare tilbyderen – også for studieønsker uten egen regel    | «Utenlandsk videregående skole» og «Videregående steinerskole» → {ORG:opptak-forvalter-forvaltende} | –                                                              |
      | SEK            | Tilbydere i samme sektor (ingen «Velg organisasjon»)       | –                                                                   | –                                                                                            |
      | SEO            | Tilbydere i samme sektor, «Velg organisasjon»: {ORG:opptak-forvalter-forvaltende} | –                                                   | –                                                                                            |
      | LAE            | Bare tilbyderen – bare dette studieønsket                  | –                                                                   | {ORG:opptak-saksbehandler-tilbyder} → {ORG:opptak-forvalter-deltakende}                      |
      | LAF            | Bare tilbyderen – bare dette studieønsket                  | –                                                                   | {ORG:opptak-forvalter-forvaltende} → {ORG:opptak-saksbehandler-saksbehandlende}              |
      | ALLE           | Bare tilbyderen – bare dette studieønsket                  | –                                                                   | {ORG:opptak-forvalter-forvaltende} → hver av de fire deltakerne i opptaket (fire rader)      |
      | INA            | Alle som deltar i opptaket (med «Inaktiv» under «Status»)  | –                                                                   | –                                                                                            |
      | FRI            | Tilbydere i samme sektor                                   | –                                                                   | –                                                                                            |
      | SLT            | Tilbydere i samme sektor (navn «Slettet regel (test {KJØRING})») | –                                                             | –                                                                                            |
      | UNT            | Tilbydere i samme sektor (navn «Unntaksregel (test {KJØRING})») | –                                                              | –                                                                                            |
      | UL             | Bare tilbyderen – bare dette studieønsket (navn «Lærestedunntak (test {KJØRING})») | –                                              | –                                                                                            |
    Og jeg åpner standardregelen i lista, og legger til unntak for «Utenlandsk videregående skole» og «Videregående steinerskole» med {ORG:opptak-forvalter-forvaltende} i «Fordeles til», hvis de ikke står der fra før, og velger «Lagre»
    Og jeg setter utdanningstilbudene som i tabellen: «Gå til utdanningstilbud», velg utdanningstilbudet, «Handlinger», «Sett regelverk og saksbehandlertildeling» [Sjekk begrep: dialogen], og velg regelen (eller «Fjern regelverk og saksbehandlertildeling» for «ingen»)
      | Utdanningstilbud (nøkkel)                              | Regel (suffiks) |
      | tilbud-saksbehandlende-uten-regel                      | ingen           |
      | tilbud-saksbehandlende-sektor-organisasjon             | SEO             |
      | tilbud-saksbehandlende-tilbyder                        | TIL             |
      | tilbud-saksbehandlende-laerested                       | LAF             |
      | tilbud-tilbyder-uten-regel                             | ingen           |
      | tilbud-tilbyder-sektor                                 | SEK             |
      | tilbud-deltakende-isolert                              | ISO             |
      | tilbud-deltakende-tilbyder                             | TIL             |
      | tilbud-deltakende-sektor                               | SEK             |
      | tilbud-deltakende-laerested                            | LAE             |
    Og jeg setter «Endre utdanningsbakgrunn» til {DATO:+30} 23:59 under «Rediger opptak» → «Saksbehandling», og velger «Lagre»
    Så står reglene i tabellen i lista over regler, med «Antall studier» 1 for «ISO», «SEO», «LAE» og «LAF», 2 for «TIL» og «SEK», og 0 for de andre
    Og standardregelen har «Alle i opptaket» i «Behandles av»
    Og jeg skriver koden til hver regel og navnet på standardregelen i «Kjøringens testdata» for «behandlertildelingsregler-i-opptaket»

  # Søknadene sendes etter at reglene står. «soknad-norsk» gir saker hos fire organisasjoner: {ORG:opptak-forvalter-deltakende} (isolert),
  # {ORG:opptak-saksbehandler-saksbehandlende} (resten), {ORG:opptak-saksbehandler-tilbyder} (unntak for lærested) og
  # {ORG:opptak-forvalter-forvaltende} (unntak for lærested).
  Scenario: soknad-norsk
    Gitt «behandlertildelingsregler-i-opptaket» har verdi i «Kjøringens testdata»
    Og jeg er innlogget i Min kompetanse (test) som søkeren «soker-1» med TestID («Hent tilfeldig person»), og har skrevet navnet på testpersonen i «Kjøringens testdata»
    Når jeg sender søknaden i Min kompetanse: velg opptaket, «Velg utdanningsbakgrunn», «Legg til studieønsker» og send inn [Sjekk begrep: knappene i Min kompetanse], med utdanningsbakgrunnen «Norsk videregående skole» [Sjekk begrep], og studieønskene «tilbud-deltakende-isolert», «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel», «tilbud-deltakende-laerested» og «tilbud-saksbehandlende-laerested» i den rekkefølgen
    Og fordelingen har kjørt (opptil 2 minutter)
    Og jeg bytter testbruker til «opptak-forvalter-forvaltende», og åpner sakene til søknaden i «Saker i opptak»
    Så står {ORG:opptak-forvalter-deltakende} som «B-rolle» på «tilbud-deltakende-isolert»
    Og {ORG:opptak-saksbehandler-saksbehandlende} står som «B-rolle» på «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
    Og {ORG:opptak-saksbehandler-tilbyder} står som «B-rolle» på «tilbud-deltakende-laerested»
    Og {ORG:opptak-forvalter-forvaltende} står som «B-rolle» på «tilbud-saksbehandlende-laerested»
    Og jeg skriver søknadsnummeret i «Kjøringens testdata» for «soknad-norsk»

  Scenario: soknad-utenlandsk
    Gitt «behandlertildelingsregler-i-opptaket» har verdi i «Kjøringens testdata»
    Og jeg er logget inn som «opptak-forvalter-forvaltende», og har skrevet navnet på søkeren «soker-2» i «Kjøringens testdata»
    Når jeg sender søknaden etter Utfylling S, med utdanningsbakgrunnen «Utenlandsk videregående skole», og studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel», «tilbud-deltakende-isolert» og «tilbud-saksbehandlende-tilbyder» i den rekkefølgen
    Og fordelingen har kjørt (opptil 2 minutter)
    Og jeg bytter testbruker til «opptak-forvalter-forvaltende», og åpner sakene til søknaden i «Saker i opptak»
    Så står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» og «tilbud-saksbehandlende-tilbyder»
    Og {ORG:opptak-forvalter-deltakende} står som «B-rolle» på «tilbud-deltakende-isolert»
    Og jeg skriver søknadsnummeret i «Kjøringens testdata» for «soknad-utenlandsk»

  Scenario: soknad-steinerskole
    Gitt «behandlertildelingsregler-i-opptaket» har verdi i «Kjøringens testdata»
    Og jeg er logget inn som «opptak-forvalter-forvaltende», og har skrevet navnet på søkeren «soker-3» i «Kjøringens testdata»
    Når jeg sender søknaden etter Utfylling S, med utdanningsbakgrunnen «Videregående steinerskole», og studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel», «tilbud-deltakende-isolert» og «tilbud-saksbehandlende-tilbyder» i den rekkefølgen
    Og fordelingen har kjørt (opptil 2 minutter)
    Og jeg bytter testbruker til «opptak-forvalter-forvaltende», og åpner sakene til søknaden i «Saker i opptak»
    Så står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
    Og jeg skriver søknadsnummeret i «Kjøringens testdata» for «soknad-steinerskole»

  Scenario: soknad-realkompetanse
    Gitt «behandlertildelingsregler-i-opptaket» har verdi i «Kjøringens testdata»
    Og jeg er logget inn som «opptak-forvalter-forvaltende», og har skrevet navnet på søkeren «soker-4» i «Kjøringens testdata»
    Når jeg sender søknaden etter Utfylling S, med utdanningsbakgrunnen «Realkompetanse», og studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel», «tilbud-deltakende-tilbyder» og «tilbud-deltakende-laerested» i den rekkefølgen
    Og fordelingen har kjørt (opptil 2 minutter)
    Og jeg bytter testbruker til «opptak-forvalter-forvaltende», og åpner sakene til søknaden i «Saker i opptak»
    Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på «tilbud-saksbehandlende-uten-regel»
    Og {ORG:opptak-saksbehandler-tilbyder} står som «B-rolle» på «tilbud-tilbyder-uten-regel» og «tilbud-deltakende-laerested»
    Og {ORG:opptak-forvalter-deltakende} står som «B-rolle» på «tilbud-deltakende-tilbyder»
    Og jeg skriver søknadsnummeret i «Kjøringens testdata» for «soknad-realkompetanse»

  # «soker-5» sender søknaden på nytt i hvert scenario som trenger den. Oppsettet gir den en utgangstilstand, så søkeren er logget inn og kjent.
  Scenario: soknad-endring-og-flytting
    Gitt «behandlertildelingsregler-i-opptaket» har verdi i «Kjøringens testdata»
    Og jeg er logget inn som «opptak-forvalter-forvaltende», og har skrevet navnet på søkeren «soker-5» i «Kjøringens testdata»
    Når jeg sender søknaden etter Utfylling S, med utdanningsbakgrunnen «Norsk videregående skole» [Sjekk begrep], og studieønskene «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» i den rekkefølgen
    Og fordelingen har kjørt (opptil 2 minutter)
    Og jeg bytter testbruker til «opptak-forvalter-forvaltende», og åpner sakene til søknaden i «Saker i opptak»
    Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
    Og jeg skriver søknadsnummeret i «Kjøringens testdata» for «soknad-endring-og-flytting»
