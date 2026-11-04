# language: no
# Generert av fs-testcaser-cdp 2026-11-04
# Krav: krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature @ c6d5e79e (blob d49bb56cafcab6c88d371c0e5cb16681d1a1f978), på branchen krav/saksbehandlertildeling-v2
#
# Alt som endres, skjer i opptaket «opptak-samordna-saksbehandlertildeling». Reglene, unntakene og søknadene lages av oppsettet
# (cdp-tester/_Oppsett/02 Opptak/13 Søknad og saksbehandling/02 Behandling/oppsett.feature). Utdanningstilbudene i eksemplene i kravet er byttet
# med utdanningstilbudene som er nøkler i README.md («tilbud-…»), og organisasjonene med {ORG:<nøkkel>}. Unntak for lærested ligger på egne regler,
# aldri på standardregelen.
#
# Slik leses stegene:
#   «Søknaden «<nøkkel>» er sendt inn og fordelt» er søknaden oppsettet har sendt (nøkkelen er i «Kjøringens testdata»).
#   «Søkeren «soker-N» har sendt inn søknad med studieønskene … og utdanningsbakgrunnen …» betyr: søknaden er opprettet eller endret på vegne av
#     søkeren i FS Admin (Utfylling S i oppsettet). Bare «soker-1» logger inn selv i Min kompetanse (TestID), fordi søkerens visning må ses der.
#     Søkeren «soker-5» er arbeidssøknaden: hvert scenario endrer den først med «Endre søknad», så den trenger ingen opprydding. Utdanningsbakgrunnene heter «Norsk videregående skole» [Sjekk begrep], «Utenlandsk videregående skole», «Videregående steinerskole», «Realkompetanse» og «Dispensasjon» [Sjekk begrep].
#   «Og fordelingen har kjørt (opptil 2 minutter)»: fordelingen skjer i tildelingsjobben. Agenten åpner siden på nytt omtrent hvert 30. sekund til
#     hvert studieønske i søknaden har en «B-rolle», og ellers i inntil 2 minutter. Er den ikke satt da, er testcasen «Ikke testet».
#   «Åpner sakene til søknaden i «Saker i opptak»» betyr: «Søknadsbehandling», «Behandle» ved opptaket, og «Gå til sak» for hver rad med søknadens
#     «Søknadsnummer» (én rad per sak, altså per saksbehandlende organisasjon). Saksbehandlende organisasjon for et studieønske er «B-rolle» på
#     kortet til studieønsket i saken [Sjekk begrep: kortets plass i saken]. Hos søkeren står den som boksen under «Kontakt saksbehandler».
#   «{ORG:<nøkkel>}», «{ORGNAVN:<nøkkel>}» og «{ORGKODE:<nøkkel>}» er forkortelsen, navnet og koden til organisasjonen testbrukeren eller
#     testdataene <nøkkel> har, slått opp i miljøfila. Forvaltende organisasjon vises som «HK-dir» i skjermen.
#   Scenarioer med «Setter tilbake:» endrer data i opptaket, og setter dem tilbake til slutt (@endrer-data). Scenarioene som bytter standardregelen,
#   skal kjøres sist.
#   Fristen for «Endre utdanningsbakgrunn» står i oppsettet på {DATO:+30} 23:59. Scenarioer som flytter den, setter den tilbake til den verdien.
#   Scenarioet «Organisasjon i et unntak for lærested kan ikke tas ut av opptaket» må ikke kjøres i et opptak andre tester bruker: et mislykket
#   forsøk tar en deltaker ut av opptaket, og siste steg setter den tilbake.
@TST-OPT-BEH-BEH-001 @depends-on-OPT-BEH-BEH-011
Egenskap: Tildele saksbehandlende organisasjon
  Testene sjekker at behandlertildelingsreglene settes opp for opptaket, at søknadsalternativene fordeles til riktig saksbehandlende
  organisasjon, at fordelingen ligger fast og flyttes ved bytte av utdanningsbakgrunn, og hvem som ser sakene.


  @ref-OPT-OPT-UTD-004 @ref-FLY-OPT-SAK-001
  Regel: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket

    @endrer-data
    Scenario: Opprette behandlertildelingsregel
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «K{KJØRING}-OPP» i «Kode»
      Og jeg skriver «Opprettet regel (test {KJØRING})» i «Navn»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Og jeg velger «Aktiv» under «Status»
      Og jeg velger «Lagre»
      Så ser jeg «Tildelingsregelen er lagret.»
      Og jeg åpner lista over regler på nytt, og regelen «K{KJØRING}-OPP» står i lista med «Opprettet regel (test {KJØRING})» i «Navn», «Samme sektor» i «Behandles av» og «Aktiv» i «Status»
      # Setter tilbake:
      Og jeg åpner regelen «K{KJØRING}-OPP», velger «Slett» og bekrefter, og regelen står ikke lenger i lista

    Scenario: Nytt opptak får standard behandlertildelingsregel med «Alle som deltar i opptaket»
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-annet» er det nyeste samordna opptaket (opptaket leses bare, ingenting endres der)
      Når jeg åpner opptaket «opptak-samordna-annet», og velger «Saksbehandlertildelingsregler» under «Samordning»
      Så står én regel med «(standard for opptaket)» bak «Navn»
      Og regelen har «Alle i opptaket» i «Behandles av» og «Aktiv» i «Status»

    @endrer-data
    Scenario: Bytte standard behandlertildelingsregel
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg åpner opptaket «opptak-samordna-saksbehandlertildeling», og noterer verdien i «Standard for opptaket» (den settes tilbake til slutt)
      Når jeg velger «ISO (test {KJØRING})» i «Standard for opptaket»
      Og jeg ser «Lagring vellykket» [Sjekk begrep: meldingen når standardregelen byttes]
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-tilbyder-uten-regel»
      # Resultatet som kan ses i skjermen: hver tilbyder saksbehandler eget studieønske, fordi standardregelen nå er «Bare tilbyderen – bare dette studieønsket».
      # Setter tilbake:
      Og jeg velger den noterte verdien i «Standard for opptaket» igjen, og ser «Lagring vellykket» [Sjekk begrep]

    Scenario: Opptaket kan bare ha én aktiv behandlertildelingsregel med «Alle som deltar i opptaket»
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og opptaket har en aktiv regel med «Alle som deltar i opptaket» (standardregelen)
      Når jeg velger «Opprett»
      Og jeg skriver «K{KJØRING}-AL2» i «Kode»
      Og jeg skriver «To alle (test {KJØRING})» i «Navn»
      Og jeg velger «Alle som deltar i opptaket» under «Hvem skal saksbehandle?»
      Og jeg velger «Aktiv» under «Status»
      Og jeg velger «Lagre»
      Så ser jeg en feilmelding i en snackbar, og ikke «Tildelingsregelen er lagret.» [Sjekk begrep: teksten i feilmeldingen]
      Og regelen «K{KJØRING}-AL2» står ikke i lista over regler

    Scenario: Se hvilke utdanningstilbud som er knyttet til behandlertildelingsregelen
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og to utdanningstilbud er knyttet til regelen «K{KJØRING}-TIL»
      Når jeg åpner regelen «K{KJØRING}-TIL» i lista over regler
      Så ser jeg «Regelen er knyttet til 2 studiealternativer og kan ikke deaktiveres eller slettes.»
      Og jeg velger lenken «2 studiealternativer»
      Og jeg ser siden «Studiealternativer knyttet til K{KJØRING}-TIL» med to rader i «Studiealternativer», med «Navn» og «Organisasjon»

    Scenario: Slette behandlertildelingsregel som ikke er knyttet til utdanningstilbud
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-SLT» med «Slettet regel (test {KJØRING})» i «Navn», «Tilbydere i samme sektor» og «Aktiv» er opprettet uten utdanningstilbud
      Når jeg åpner regelen «K{KJØRING}-SLT» i lista over regler
      Og jeg velger «Slett», og bekrefter «Er du sikker på at du vil slette denne tildelingsregelen?»
      Så ser jeg «Tildelingsregelen er slettet.»
      Og regelen «K{KJØRING}-SLT» står ikke i lista over regler

    Scenario: Behandlertildelingsregel som er knyttet til utdanningstilbud kan ikke slettes
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og utdanningstilbudet «tilbud-deltakende-isolert» er knyttet til regelen «K{KJØRING}-ISO»
      Når jeg åpner regelen «K{KJØRING}-ISO» i lista over regler
      Så ser jeg ikke «Slett»
      Og jeg ser «Regelen er knyttet til ett studiealternativ og kan ikke deaktiveres eller slettes.»

    Scenariomal: Behandlertildelingsregel som <bruk> kan ikke deaktiveres
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og <regel> <bruk>
      Når jeg åpner <regel> i lista over regler
      Så er «Inaktiv» under «Status» ikke mulig å velge
      Og jeg ser «<melding>»

      Eksempler:
        | bruk                            | regel                   | melding |
        | er standard i opptaket          | regelen med «(standard for opptaket)» bak «Navn» | Regelen er standard for opptaket og kan ikke deaktiveres eller slettes. |
        | er knyttet til utdanningstilbud | regelen «K{KJØRING}-ISO» | Regelen er knyttet til ett studiealternativ og kan ikke deaktiveres eller slettes. |

    Scenario: Behandlertildelingsreglene er ikke tilgjengelige i lokale opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-lokalt-eksisterende» er et lokalt opptak (opptaket leses bare, ingenting endres der)
      Når jeg åpner opptaket «opptak-lokalt-eksisterende»
      Så ser jeg ikke «Saksbehandlertildelingsregler»
      Og adressen til «Behandlertildelingsregler» for opptaket gir ikke en liste over regler [Sjekk begrep: siden viser «Fant ikke siden» eller tilsvarende]

    Scenario: Deltakende lærested kan ikke endre behandlertildelingsreglene
      Gitt jeg er logget inn som «opptak-forvalter-deltakende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg ser lista over regler
      Så ser jeg ikke «Opprett»
      Og jeg åpner regelen «K{KJØRING}-ISO», og ser ikke «Lagre», «Slett» eller «Legg til unntak»

    # Teknikk: grenseverdianalyse (tomt felt)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Kode» står tomt
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «Utledet regel (test {KJØRING})» i «Navn»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Så kan jeg ikke velge «Lagre»
      Og «Kode» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der

    # Teknikk: grenseverdianalyse (bare mellomrom)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Kode» har bare mellomrom
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «   » i «Kode»
      Og jeg skriver «Utledet regel (test {KJØRING})» i «Navn»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Så kan jeg ikke velge «Lagre»
      Og «Kode» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der

    # Teknikk: grenseverdianalyse (maks 40 tegn, maks + 1)
    @utledet @endrer-data
    Scenariomal: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Kode» med <lengde> tegn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver en kode på <lengde> tegn som starter med «K{KJØRING}-» i «Kode»
      Og jeg skriver «Utledet regel (test {KJØRING})» i «Navn»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Og jeg velger «Lagre»
      Så <resultat>
      # Setter tilbake (bare når regelen ble lagret):
      Og jeg åpner regelen, velger «Slett» og bekrefter

      Eksempler:
        | lengde | resultat |
        | 40 | ser jeg «Tildelingsregelen er lagret.» |
        | 41 | ser jeg en feilmelding og ikke «Tildelingsregelen er lagret.» [Sjekk begrep: teksten i feilmeldingen] |

    # Teknikk: ekvivalensklasser (tegn utenom store bokstaver, tall og _:,.-+)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Kode» med ugyldig tegn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «K{KJØRING}#X» i «Kode»
      Og jeg skriver «Utledet regel (test {KJØRING})» i «Navn»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Og jeg velger «Lagre»
      Så ser jeg en feilmelding og ikke «Tildelingsregelen er lagret.» [Sjekk begrep: teksten i feilmeldingen]
      Og regelen står ikke i lista over regler

    # Teknikk: ekvivalensklasser (små bokstaver gjøres om til store)
    @utledet @endrer-data
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Kode» skrevet med små bokstaver
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «k{KJØRING}-liten» i «Kode»
      Og jeg skriver «Utledet regel (test {KJØRING})» i «Navn»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Så står «K{KJØRING}-LITEN» i «Kode»
      Og jeg velger «Lagre», og regelen «K{KJØRING}-LITEN» står i lista over regler
      # Setter tilbake:
      Og jeg åpner regelen, velger «Slett» og bekrefter

    # Teknikk: ekvivalensklasser (unik kode i opptaket)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Kode» som finnes fra før
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «K{KJØRING}-ISO» i «Kode»
      Og jeg skriver «Utledet regel (test {KJØRING})» i «Navn»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Og jeg velger «Lagre»
      Så ser jeg en feilmelding og ikke «Tildelingsregelen er lagret.» [Sjekk begrep: teksten i feilmeldingen]

    # Teknikk: ekvivalensklasser (ny regel / lagret regel)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Kode» kan ikke endres etter opprettelse
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg åpner regelen «K{KJØRING}-ISO» i lista over regler
      Så står «K{KJØRING}-ISO» som tekst under «Kode», og jeg kan ikke skrive i feltet [Sjekk begrep: feltet vises bare i lesemodus]

    # Teknikk: grenseverdianalyse (tomt felt)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Navn» står tomt
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «K{KJØRING}-UTL» i «Kode»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Så kan jeg ikke velge «Lagre»
      Og «Navn» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der

    # Teknikk: grenseverdianalyse (bare mellomrom)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Navn» har bare mellomrom
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «   » i «Navn»
      Og jeg skriver «K{KJØRING}-UTL» i «Kode»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Så kan jeg ikke velge «Lagre»
      Og «Navn» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der

    # Teknikk: grenseverdianalyse (maks 100 tegn, maks + 1)
    @utledet @endrer-data
    Scenariomal: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Navn» med <lengde> tegn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver et navn på <lengde> tegn som starter med «Navn (test {KJØRING}) » i «Navn»
      Og jeg skriver «K{KJØRING}-UTL» i «Kode»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Og jeg velger «Lagre»
      Så <resultat>
      # Setter tilbake (bare når regelen ble lagret):
      Og jeg åpner regelen, velger «Slett» og bekrefter

      Eksempler:
        | lengde | resultat |
        | 100 | ser jeg «Tildelingsregelen er lagret.» |
        | 101 | ser jeg en feilmelding og ikke «Tildelingsregelen er lagret.» [Sjekk begrep: teksten i feilmeldingen] |

    # Teknikk: ekvivalensklasser (ingen av de fire valgene)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: «Hvem skal saksbehandle?» er ikke valgt
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «K{KJØRING}-UTL» i «Kode»
      Og jeg skriver «Utledet regel (test {KJØRING})» i «Navn»
      Så kan jeg ikke velge «Lagre»
      Og «Hvem skal saksbehandle?» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der

    # Teknikk: ekvivalensklasser (standardverdi for «Status»)
    @utledet @endrer-data
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: ny regel er aktiv som standard
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg velger «Opprett»
      Og jeg skriver «K{KJØRING}-UTL» i «Kode»
      Og jeg skriver «Utledet regel (test {KJØRING})» i «Navn»
      Og jeg velger «Tilbydere i samme sektor» under «Hvem skal saksbehandle?»
      Så er «Aktiv» valgt under «Status» uten at jeg har valgt noe
      Og jeg velger «Lagre», og regelen har «Aktiv» i «Status» i lista
      # Setter tilbake:
      Og jeg åpner regelen, velger «Slett» og bekrefter

    # Teknikk: ekvivalensklasser (aktiv / inaktiv)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: lista over standardregler viser bare aktive regler
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-INA» er inaktiv, og «K{KJØRING}-ISO» er aktiv
      Når jeg åpner «Standard for opptaket»
      Så står «ISO (test {KJØRING})» blant valgene
      Og «Inaktiv regel (test {KJØRING})» står ikke blant valgene

    # Teknikk: tilstandsoverganger (inaktiv til aktiv)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: aktivere en regel med «Alle som deltar i opptaket» når opptaket har en aktiv
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-INA» er inaktiv og har «Alle som deltar i opptaket», og standardregelen er aktiv med «Alle som deltar i opptaket»
      Når jeg åpner regelen «K{KJØRING}-INA» i lista over regler
      Og jeg velger «Aktiv» under «Status», og velger «Lagre»
      Så ser jeg en feilmelding og ikke «Tildelingsregelen er lagret.» [Sjekk begrep: teksten i feilmeldingen]
      Og regelen har fortsatt «Inaktiv» i «Status» når jeg åpner lista på nytt

    # Teknikk: tilstandsoverganger (aktiv, inaktiv, aktiv)
    @utledet @endrer-data
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: regel uten utdanningstilbud deaktiveres og aktiveres igjen
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-FRI» er aktiv og har ingen utdanningstilbud
      Når jeg åpner regelen «K{KJØRING}-FRI» i lista over regler
      Og jeg velger «Inaktiv» under «Status», og velger «Lagre»
      Så har regelen «Inaktiv» i «Status» i lista
      Og jeg velger «Aktiv» under «Status» på regelen, og velger «Lagre»
      Og regelen har «Aktiv» i «Status» i lista

    # Teknikk: ekvivalensklasser (aktiv / inaktiv)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: utdanningstilbudet kan ikke få en inaktiv regel
      Gitt jeg er logget inn som «opptak-forvalter-deltakende»
      Og regelen «K{KJØRING}-INA» er inaktiv
      Når jeg åpner utdanningstilbudet «tilbud-deltakende-isolert», velger «Rediger» og åpner «Saksbehandlertildelingsregel»
      Så står «ISO (test {KJØRING})» blant valgene
      Og «Inaktiv regel (test {KJØRING})» står ikke blant valgene

    # Teknikk: ekvivalensklasser (fordeling)
    @utledet
    Scenario: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket: organisasjon for sektoren kan bare velges ved «Tilbydere i samme sektor»
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg åpner regelen «K{KJØRING}-SEK» i lista over regler
      Og «Velg organisasjon» vises under «Tilbydere i samme sektor»
      Når jeg velger «Alle som deltar i opptaket» under «Hvem skal saksbehandle?» uten å lagre
      Så vises ikke «Velg organisasjon»


  Regel: Ved «Alle som deltar i opptaket» saksbehandler lærestedet søkeren har prioritert høyest

    Scenario: Lærestedet på første prioritet saksbehandler hele søknaden
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-tilbyder-uten-regel»
      # Studieønskene uten egen regel står i søknaden som nummer to og tre, og lærestedet på det første av dem avgjør.

    Scenario: Søknadsalternativ med egen behandlertildelingsregel avgjør ikke hvem som saksbehandler resten av søknaden
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-deltakende-isolert»
      Og står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-tilbyder-uten-regel»


  Regel: Ved «Bare tilbyderen – også for studieønsker uten egen regel» saksbehandler tilbyderen også søknadsalternativene uten egen behandlertildelingsregel

    Scenario: Tilbyderen saksbehandler søknadsalternativene uten egen behandlertildelingsregel
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-deltakende-tilbyder» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-deltakende-tilbyder»

    Scenario: Tilbyderen søkeren har prioritert høyest saksbehandler søknadsalternativene uten egen behandlertildelingsregel
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-saksbehandlende-tilbyder», «tilbud-deltakende-tilbyder» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-tilbyder»
      Og står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-deltakende-tilbyder»


  Regel: Ved «Bare tilbyderen – bare dette studieønsket» saksbehandler tilbyderen bare søknadsalternativet med behandlertildelingsregelen

    Scenario: Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-deltakende-isolert»
      Og står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      # «Saker i opptak» har to rader for søknaden: én sak per saksbehandlende organisasjon.

    @endrer-data
    Scenario: Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg åpner opptaket «opptak-samordna-saksbehandlertildeling», og noterer verdien i «Standard for opptaket» (den settes tilbake til slutt)
      Og jeg velger «ISO (test {KJØRING})» i «Standard for opptaket», så standardregelen er «Bare tilbyderen – bare dette studieønsket»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-tilbyder-uten-regel», «tilbud-saksbehandlende-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-tilbyder-uten-regel»
      Og står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      # Fagskoleopptaket i kravet finnes ikke i testopptaket: standardregelen byttes til samme regel som i «Bytte standard behandlertildelingsregel», med to læresteder.
      # Setter tilbake:
      Og jeg velger den noterte verdien i «Standard for opptaket» igjen, og ser «Lagring vellykket» [Sjekk begrep]


  Regel: Ved «Tilbydere i samme sektor» saksbehandler én organisasjon alle søknadsalternativene i sektoren

    Scenario: Tilbyderen søkeren har prioritert høyest i sektoren saksbehandler hele sektoren
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-sektor», «tilbud-deltakende-sektor» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-tilbyder-sektor»
      Og står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-deltakende-sektor»
      Og står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»

    Scenario: Organisasjonen som er valgt på behandlertildelingsregelen saksbehandler hele sektoren
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og regelen «K{KJØRING}-SEO» har «Tilbydere i samme sektor» og «Velg organisasjon» satt til {ORG:opptak-forvalter-forvaltende}
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-sektor-organisasjon», «tilbud-saksbehandlende-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-sektor-organisasjon»
      Og står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»

    Scenario: Søknadsalternativer i ulike sektorer fordeles hver for seg
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og regelen «K{KJØRING}-SEK» og regelen «K{KJØRING}-SEO» er hver sin sektor
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-deltakende-sektor», «tilbud-saksbehandlende-sektor-organisasjon», «tilbud-saksbehandlende-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-deltakende-sektor»
      Og står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-sektor-organisasjon»

    @endrer-data
    Scenario: Sektoren er lærestedene som har utdanningstilbud med samme behandlertildelingsregel
      Gitt jeg er logget inn som «opptak-forvalter-deltakende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-SEK» er valgt på «tilbud-deltakende-sektor» og «tilbud-tilbyder-sektor»
      Når jeg åpner utdanningstilbudet «tilbud-deltakende-isolert», velger «Rediger», velger «K{KJØRING}-SEK» i «Saksbehandlertildelingsregel» og velger «Lagre»
      Og jeg åpner regelen «K{KJØRING}-SEK» i lista over regler, og velger lenken «3 studiealternativer»
      Så står «tilbud-deltakende-isolert» i lista over studiealternativer, med {ORG:opptak-forvalter-deltakende} i «Organisasjon»
      Og {ORG:opptak-forvalter-deltakende} har nå to studiealternativer i sektoren «K{KJØRING}-SEK»
      # Setter tilbake:
      Og jeg åpner utdanningstilbudet «tilbud-deltakende-isolert», velger «Rediger», velger «K{KJØRING}-ISO» i «Saksbehandlertildelingsregel» og velger «Lagre»

    Scenario: Søkerens prioritering avgjør hvem som saksbehandler søknadsalternativene uten egen behandlertildelingsregel
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-tilbyder-sektor», «tilbud-deltakende-tilbyder», «tilbud-saksbehandlende-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-tilbyder-sektor»
      Og står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-deltakende-tilbyder»

    @endrer-data
    Scenariomal: Opptaksforvalteren kan velge <organisasjon> som organisasjon for sektoren
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og jeg noterer at «Velg organisasjon» på regelen «K{KJØRING}-SEK» står på «Tilbyder» (settes tilbake til slutt)
      Når jeg åpner regelen «K{KJØRING}-SEK» i lista over regler
      Og jeg velger «<organisasjon>» i «Velg organisasjon», og velger «Lagre»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-deltakende-sektor», «tilbud-tilbyder-sektor» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står «<organisasjon>» som «B-rolle» på studieønskene «tilbud-deltakende-sektor» og «tilbud-tilbyder-sektor» når jeg åpner sakene til søknaden
      # Setter tilbake:
      Og jeg velger «Tilbyder» i «Velg organisasjon» på regelen «K{KJØRING}-SEK», og velger «Lagre»

      Eksempler:
        | organisasjon |
        | {ORG:opptak-saksbehandler-tilbyder} |
        | {ORG:opptak-forvalter-forvaltende} |

    Scenario: Organisasjonen for sektoren må delta i opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og {ORGNAVN:opptak-forvalter-ikke-deltakende} deltar ikke i opptaket
      Når jeg åpner regelen «K{KJØRING}-SEK» i lista over regler
      Når jeg åpner «Velg organisasjon»
      Så ser jeg ikke «{ORGNAVN:opptak-forvalter-ikke-deltakende}» blant valgene


  Regel: Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen

    @endrer-data
    Scenario: Legge til unntak for utdanningsbakgrunn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-UNT» med «Unntaksregel (test {KJØRING})» i «Navn», «Tilbydere i samme sektor» og «Aktiv» er opprettet uten unntak
      Når jeg åpner regelen «K{KJØRING}-UNT» i lista over regler
      Og jeg velger «Legg til unntak» under «Unntak for utdanningsbakgrunn»
      Og jeg velger «Utenlandsk videregående skole» i «Utdanningsbakgrunn» og {ORG:opptak-forvalter-forvaltende} i «Fordeles til»
      Og jeg velger «Legg til unntak» under «Unntak for utdanningsbakgrunn»
      Og jeg velger «Videregående steinerskole» i «Utdanningsbakgrunn» og {ORG:opptak-forvalter-forvaltende} i «Fordeles til» [Sjekk begrep: kravet sier «Rudolf Steinerskole»]
      Og jeg velger «Lagre»
      Så ser jeg «Tildelingsregelen er lagret.»
      Og jeg åpner regelen «K{KJØRING}-UNT» på nytt, og «Unntak for utdanningsbakgrunn» har to rader: «Utenlandsk videregående skole» og «Videregående steinerskole», begge med {ORG:opptak-forvalter-forvaltende} i «Fordeles til»
      # Setter tilbake:
      Og jeg velger «Slett» og bekrefter, og regelen «K{KJØRING}-UNT» står ikke lenger i lista

    Scenariomal: HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn <utdanningsbakgrunn>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «<soknad>» er sendt inn med utdanningsbakgrunnen «<utdanningsbakgrunn>» og fordelt
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på studieønsket «tilbud-tilbyder-uten-regel»

      Eksempler:
        | utdanningsbakgrunn | soknad |
        | Utenlandsk videregående skole | soknad-utenlandsk |
        | Videregående steinerskole | soknad-steinerskole |

    Scenario: Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-realkompetanse» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»
      Og står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-tilbyder-uten-regel»
      Og står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-deltakende-tilbyder»

    Scenario: Unntaket går foran behandlertildelingsregel der bare tilbyderen saksbehandler
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-utenlandsk» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-tilbyder»
      # Regelen K{KJØRING}-TIL har «Bare tilbyderen – også for studieønsker uten egen regel» og unntak for utenlandsk utdanningsbakgrunn.

    Scenario: Behandlertildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-utenlandsk» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så står {ORG:opptak-forvalter-deltakende} som «B-rolle» på studieønsket «tilbud-deltakende-isolert»
      Og står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-uten-regel»

    @endrer-data
    Scenario: Tilbyderen saksbehandler alltid søknadsalternativ til ledig studieplass
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og ledige studieplasser i opptaket har åpnet, og «tilbud-saksbehandlende-tilbyder» tilbyr ledige studieplasser
      Og søkeren «soker-5» har sendt inn søknad med studieønsket «tilbud-saksbehandlende-uten-regel» og utdanningsbakgrunnen «Norsk videregående skole»
      Når søkeren «soker-5» søker ledig studieplass på «tilbud-saksbehandlende-tilbyder» (lagt til på vegne av søkeren med «Endre søknad»)
      Og fordelingen har kjørt (opptil 2 minutter)
      Og jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-tilbyder»
      # Setter tilbake:
      Og søkeren «soker-5» fjerner ledig studieplass «tilbud-saksbehandlende-tilbyder» fra søknaden

    @endrer-data
    Scenario: Ledig studieplass går foran unntak for utdanningsbakgrunn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og ledige studieplasser i opptaket har åpnet, og «tilbud-saksbehandlende-tilbyder» tilbyr ledige studieplasser
      Og søkeren «soker-2» har søknaden «soknad-utenlandsk» med utdanningsbakgrunnen «Utenlandsk videregående skole»
      Når søkeren «soker-2» søker ledig studieplass på «tilbud-saksbehandlende-tilbyder» (lagt til på vegne av søkeren med «Endre søknad»)
      Og fordelingen har kjørt (opptil 2 minutter)
      Og jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-tilbyder»
      # «tilbud-saksbehandlende-tilbyder» står ikke i søknaden fra før, så det er ledig studieplass som avgjør, og ikke unntaket for utenlandsk utdanningsbakgrunn.
      # Setter tilbake:
      Og søkeren «soker-2» fjerner ledig studieplass «tilbud-saksbehandlende-tilbyder» fra søknaden

    @endrer-data
    Scenario: Tilbyderen saksbehandler ledig studieplass som legges til på vegne av søkeren
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og ledige studieplasser i opptaket har åpnet, og «tilbud-saksbehandlende-tilbyder» tilbyr ledige studieplasser
      Og søkeren «soker-5» har sendt inn søknad med studieønsket «tilbud-saksbehandlende-uten-regel» og utdanningsbakgrunnen «Norsk videregående skole»
      Når jeg bytter testbruker til «opptak-saksbehandler-saksbehandlende»
      Og jeg åpner saken til søknaden i «Saker i opptak», velger «Endre søknad» og legger til ledig studieplass på «tilbud-saksbehandlende-tilbyder»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og jeg åpner saken på nytt
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-tilbyder»
      # Setter tilbake:
      Og jeg fjerner ledig studieplass «tilbud-saksbehandlende-tilbyder» fra søknaden

    # Teknikk: ekvivalensklasser (valgt / ikke valgt bakgrunn)
    @utledet
    Scenario: Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen: to unntak for samme utdanningsbakgrunn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-TIL» har et unntak for «Utenlandsk videregående skole»
      Når jeg åpner regelen «K{KJØRING}-TIL» i lista over regler
      Når jeg velger «Legg til unntak» under «Unntak for utdanningsbakgrunn», og åpner «Utdanningsbakgrunn» i den nye raden
      Så er «Utenlandsk videregående skole» deaktivert i lista
      Og jeg fjerner den nye raden uten å lagre

    # Teknikk: ekvivalensklasser (bakgrunner som alltid fordeles til tilbyder)
    @utledet
    Scenariomal: Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen: <utdanningsbakgrunn> kan ikke få unntak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg åpner regelen «K{KJØRING}-TIL» i lista over regler
      Når jeg velger «Legg til unntak» under «Unntak for utdanningsbakgrunn», og åpner «Utdanningsbakgrunn» i den nye raden
      Så er «<utdanningsbakgrunn>» deaktivert i lista, med forklaringen «Fordeles alltid til tilbyder»
      Og jeg fjerner den nye raden uten å lagre

      Eksempler:
        | utdanningsbakgrunn |
        | Realkompetanse |
        | Dispensasjon [Sjekk testdata: finnes bakgrunnen i lista] |


  @ref-FLY-OPT-SAK-001
  Regel: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket

    @endrer-data
    Scenario: Legge til unntak for lærested
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-UL» med «Lærestedunntak (test {KJØRING})» i «Navn», «Bare tilbyderen – bare dette studieønsket» og «Aktiv» er opprettet uten unntak
      Når jeg åpner regelen «K{KJØRING}-UL» i lista over regler
      Når jeg velger «Legg til unntak» under «Unntak for lærested»
      Og jeg velger {ORG:opptak-forvalter-deltakende-annen} i «Saksbehandles av» og {ORG:opptak-forvalter-deltakende} i «På vegne av»
      Og jeg velger «Lagre»
      Så ser jeg «Tildelingsregelen er lagret.»
      Og jeg åpner regelen på nytt, og «Unntak for lærested» har én rad med {ORG:opptak-forvalter-deltakende-annen} i «Saksbehandles av» og {ORG:opptak-forvalter-deltakende} i «På vegne av»
      # Unntaket gjelder bare studieønsker fordelt etter regelen, og fordelingen er vist i scenarioene under.
      # Setter tilbake:
      Og jeg velger «Slett» og bekrefter, og regelen «K{KJØRING}-UL» står ikke lenger i lista

    Scenario: Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-deltakende-laerested»
      # «K{KJØRING}-LAE» har {ORG:opptak-saksbehandler-tilbyder} i «Saksbehandles av» og {ORG:opptak-forvalter-deltakende} i «På vegne av».

    @endrer-data
    Scenariomal: Unntaket for lærested gjelder også når <tilfelle>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «<soknad>» er sendt inn og fordelt, med <forutsetning>
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så står {ORG:opptak-saksbehandler-tilbyder} som «B-rolle» på studieønsket «tilbud-deltakende-laerested»
      # Setter tilbake:
      Og <tilbake>

      Eksempler:
        | tilfelle                        | soknad                | forutsetning | tilbake |
        | bare tilbyderen saksbehandler   | soknad-norsk          | «tilbud-deltakende-laerested» med regelen «K{KJØRING}-LAE» («Bare tilbyderen – bare dette studieønsket») | søknaden er uendret |
        | søkeren har realkompetanse      | soknad-realkompetanse | utdanningsbakgrunnen «Realkompetanse» | søknaden er uendret |
        | søkeren søker ledig studieplass | soknad-endring-og-flytting | ledig studieplass på «tilbud-deltakende-laerested» lagt til på vegne av søkeren «soker-5» med «Endre søknad» | søkeren fjerner ledig studieplass «tilbud-deltakende-laerested» fra søknaden |

    Scenariomal: Organisasjonene i unntaket for lærested må delta i opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og {ORGNAVN:opptak-forvalter-ikke-deltakende} deltar ikke i opptaket
      Når jeg åpner regelen «K{KJØRING}-LAE» i lista over regler
      Når jeg velger «Legg til unntak» under «Unntak for lærested», og åpner <kolonne>
      Så ser jeg ikke «{ORGNAVN:opptak-forvalter-ikke-deltakende}» blant valgene

      Eksempler:
        | kolonne            |
        | «Saksbehandles av» |
        | «På vegne av»      |

    Scenario: Forvaltende organisasjon kan saksbehandle på vegne av et lærested
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på studieønsket «tilbud-saksbehandlende-laerested»
      # «K{KJØRING}-LAF» har {ORG:opptak-forvalter-forvaltende} i «Saksbehandles av» og {ORG:opptak-saksbehandler-saksbehandlende} i «På vegne av».

    Scenario: Lærestedet kan bare ha ett unntak for lærested per behandlertildelingsregel
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-LAE» har unntak for lærested der {ORG:opptak-saksbehandler-tilbyder} saksbehandler på vegne av {ORG:opptak-forvalter-deltakende}
      Når jeg åpner regelen «K{KJØRING}-LAE» i lista over regler
      Når jeg velger «Legg til unntak» under «Unntak for lærested»
      Og jeg åpner «På vegne av» i den nye raden
      Så kan jeg ikke velge {ORG:opptak-forvalter-deltakende} i «På vegne av» (valget er deaktivert)
      Og jeg fjerner den nye raden uten å lagre

    @endrer-data
    Scenario: Nytt unntak for lærested gjelder bare søknadsalternativer som ikke er fordelt
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og søknaden «soknad-norsk» er sendt inn og fordelt, og «tilbud-deltakende-isolert» har {ORG:opptak-forvalter-deltakende} som «B-rolle»
      Når jeg åpner regelen «K{KJØRING}-ISO» i lista over regler
      Når jeg legger til unntak for lærested med {ORG:opptak-saksbehandler-tilbyder} i «Saksbehandles av» og {ORG:opptak-forvalter-deltakende} i «På vegne av», og velger «Lagre»
      Så ser jeg «Tildelingsregelen er lagret.»
      Og når jeg åpner sakene til søknaden «soknad-norsk» i «Saker i opptak», står {ORG:opptak-forvalter-deltakende} fortsatt som «B-rolle» på «tilbud-deltakende-isolert»
      # Setter tilbake:
      Og jeg åpner regelen «K{KJØRING}-ISO», fjerner unntaket med «Fjern» og velger «Lagre»

    @endrer-data
    Scenario: Organisasjon i et unntak for lærested kan ikke tas ut av opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og den aktive regelen «K{KJØRING}-LAE» har unntak for lærested der {ORG:opptak-saksbehandler-tilbyder} saksbehandler på vegne av {ORG:opptak-forvalter-deltakende}
      Når jeg åpner opptaket «opptak-samordna-saksbehandlertildeling», velger «Endre innstillinger for opptaket» og velger «Fjern {ORG:opptak-saksbehandler-tilbyder}» under «Samordnede organisasjoner»
      Og jeg velger «Lagre»
      Så ser jeg en feilmelding, og ikke «Lagring vellykket» [Sjekk begrep: teksten i feilmeldingen]
      Og når jeg åpner opptaket på nytt, står {ORG:opptak-saksbehandler-tilbyder} fortsatt under «Samordnede organisasjoner»
      # Setter tilbake (hvis forsøket ikke ble avvist og organisasjonen er tatt ut):
      Og jeg velger «Inviter organisasjoner til samordningen», skriver «{ORGNAVN:opptak-saksbehandler-tilbyder}» i «Søk etter navn», markerer organisasjonen, velger «Legg til 1 organisasjon» og «Lagre»

    # Teknikk: ekvivalensklasser (kolonne tom / fylt)
    @utledet
    Scenario: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket: «Saksbehandles av» står tomt
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg åpner regelen «K{KJØRING}-LAE» i lista over regler
      Når jeg velger «Legg til unntak» under «Unntak for lærested»
      Og jeg velger {ORG:opptak-saksbehandler-saksbehandlende} i «På vegne av» og lar «Saksbehandles av» stå tom
      Så kan jeg ikke velge «Lagre»
      Og «Unntak for lærested» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der
      Og jeg fjerner den nye raden uten å lagre

    # Teknikk: ekvivalensklasser (kolonne tom / fylt)
    @utledet
    Scenario: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket: «På vegne av» står tomt
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg åpner regelen «K{KJØRING}-LAE» i lista over regler
      Når jeg velger «Legg til unntak» under «Unntak for lærested»
      Og jeg velger {ORG:opptak-forvalter-forvaltende} i «Saksbehandles av» og lar «På vegne av» stå tom
      Så kan jeg ikke velge «Lagre»
      Og «Unntak for lærested» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der
      Og jeg fjerner den nye raden uten å lagre

    # Teknikk: ekvivalensklasser (samme / ulik organisasjon)
    @utledet
    Scenario: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket: lærestedet kan ikke saksbehandle på vegne av seg selv
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Når jeg åpner regelen «K{KJØRING}-LAE» i lista over regler
      Når jeg velger «Legg til unntak» under «Unntak for lærested», og velger {ORG:opptak-saksbehandler-saksbehandlende} i «Saksbehandles av»
      Så kan jeg ikke velge {ORG:opptak-saksbehandler-saksbehandlende} i «På vegne av» (valget er deaktivert)
      Og jeg fjerner den nye raden uten å lagre

    # Teknikk: grenseverdianalyse (alle deltakerne brukt)
    @utledet
    Scenario: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket: «Legg til unntak» er deaktivert når alle deltakerne har et unntak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Behandlertildelingsregler» fra opptaket «opptak-samordna-saksbehandlertildeling» (knappen «Saksbehandlertildelingsregler» under «Samordning»)
      Og regelen «K{KJØRING}-ALLE» har ett unntak for hver av de fire deltakerne i opptaket, som «På vegne av»
      Når jeg åpner regelen «K{KJØRING}-ALLE» i lista over regler
      Så er «Legg til unntak» under «Unntak for lærested» deaktivert
      Og regelen har fire rader under «Unntak for lærested»


  @ref-FLY-OPT-SAK-001 @ref-OPT-BEH-BEH-032
  Regel: Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast

    @endrer-data
    Scenariomal: Søknadsalternativene fordeles når <hendelse>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønsket «tilbud-saksbehandlende-uten-regel» og utdanningsbakgrunnen «Norsk videregående skole»
      Når <handling>
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på studieønsket «<tilbud>» når jeg åpner sakene til søknaden i «Saker i opptak»
      # Setter tilbake:
      Og <tilbake>

      Eksempler:
        | hendelse | handling | tilbud | tilbake |
        | søkeren sender inn søknaden | søkeren «soker-5» har trukket søknaden og sender den på nytt med studieønsket «tilbud-saksbehandlende-uten-regel» | tilbud-saksbehandlende-uten-regel | søknaden står som i oppsettet |
        | søkeren endrer søknaden | søkeren «soker-5» velger «Endre søknad» og «Legg til studieønsker» og legger til «tilbud-tilbyder-uten-regel» | tilbud-tilbyder-uten-regel | søkeren fjerner «tilbud-tilbyder-uten-regel» med «Fjern» |
        | saksbehandleren legger til et søknadsalternativ på vegne av søkeren | saksbehandleren ved {ORG:opptak-saksbehandler-saksbehandlende} velger «Endre søknad» i saken og legger til «tilbud-tilbyder-uten-regel» | tilbud-tilbyder-uten-regel | saksbehandleren fjerner «tilbud-tilbyder-uten-regel» |

    Scenario: Søknaden får én sak per saksbehandlende organisasjon
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt
      Når jeg går til «Søknadsbehandling», velger «Behandle» ved opptaket «opptak-samordna-saksbehandlertildeling», og åpner hver sak til søknaden i «Saker i opptak» med «Gå til sak»
      Så har søknaden fire rader i «Saker i opptak» med samme «Søknadsnummer»: én sak hos {ORG:opptak-forvalter-deltakende} med «tilbud-deltakende-isolert», én hos {ORG:opptak-saksbehandler-saksbehandlende} med «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel», én hos {ORG:opptak-saksbehandler-tilbyder} med «tilbud-deltakende-laerested», og én hos {ORG:opptak-forvalter-forvaltende} med «tilbud-saksbehandlende-laerested»

    Scenario: Tilbyder som ikke er saksbehandlende organisasjon får ingen sak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når jeg åpner sakene til søknaden i «Saker i opptak»
      Så ser jeg én rad for søknaden, og saken står hos {ORG:opptak-saksbehandler-saksbehandlende} med både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Og det finnes ingen rad for {ORG:opptak-saksbehandler-tilbyder} i «Saker i opptak» for søknaden, selv om {ORG:opptak-saksbehandler-tilbyder} er tilbyder av «tilbud-tilbyder-uten-regel»

    @endrer-data
    Scenario: Ny prioritering endrer ikke saksbehandlende organisasjon
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når søkeren «soker-5» velger «Endre prioritering», flytter «tilbud-tilbyder-uten-regel» foran «tilbud-saksbehandlende-uten-regel» og lagrer
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» når jeg åpner sakene til søknaden i «Saker i opptak»
      # Setter tilbake:
      Og søkeren flytter «tilbud-saksbehandlende-uten-regel» foran «tilbud-tilbyder-uten-regel» og lagrer

    @endrer-data
    Scenario: Nytt søknadsalternativ uten egen behandlertildelingsregel får samme saksbehandlende organisasjon som før
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når søkeren «soker-5» legger til «tilbud-tilbyder-uten-regel» som første prioritet (velger «Endre søknad», «Legg til studieønsker», og flytter «tilbud-tilbyder-uten-regel» øverst)
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på «tilbud-tilbyder-uten-regel» når jeg åpner sakene til søknaden i «Saker i opptak»
      # Setter tilbake:
      Og søkeren fjerner «tilbud-tilbyder-uten-regel» med «Fjern»

    @endrer-data
    Scenario: Nytt søknadsalternativ der bare tilbyderen saksbehandler endrer ikke søknadsalternativene som er fordelt
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Når søkeren «soker-5» legger til «tilbud-deltakende-isolert» (velger «Endre søknad» og «Legg til studieønsker»)
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-forvalter-deltakende} som «B-rolle» på «tilbud-deltakende-isolert» når jeg åpner sakene til søknaden i «Saker i opptak»
      Og {ORG:opptak-saksbehandler-saksbehandlende} står fortsatt som «B-rolle» på «tilbud-saksbehandlende-uten-regel»
      # Setter tilbake:
      Og søkeren fjerner «tilbud-deltakende-isolert» med «Fjern»

    @endrer-data
    Scenario: Sletting av søknadsalternativet fordelingen bygget på endrer ikke de andre søknadsalternativene
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-deltakende-tilbyder» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og {ORG:opptak-forvalter-deltakende} står som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-deltakende-tilbyder»
      Når søkeren «soker-5» velger «Endre søknad» og fjerner «tilbud-deltakende-tilbyder» med «Fjern»
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-forvalter-deltakende} fortsatt som «B-rolle» på «tilbud-saksbehandlende-uten-regel» når jeg åpner sakene til søknaden i «Saker i opptak»


  @depends-on-OPT-OVO-FRI-001 @ref-FLY-OPT-SAK-001
  Regel: Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak

    @endrer-data
    Scenario: Søkeren bytter til utenlandsk utdanningsbakgrunn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og {ORG:opptak-saksbehandler-saksbehandlende} står som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Når søkeren «soker-5» velger «Endre søknad», velger «Utenlandsk videregående skole» i «Velg utdanningsbakgrunn» og lagrer
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» når jeg åpner sakene til søknaden i «Saker i opptak»

    @endrer-data
    Scenario: Søkeren bytter til realkompetanse
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og {ORG:opptak-saksbehandler-saksbehandlende} står som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Når søkeren «soker-5» velger «Endre søknad», velger «Realkompetanse» i «Velg utdanningsbakgrunn» og lagrer
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på «tilbud-saksbehandlende-uten-regel», og {ORG:opptak-saksbehandler-tilbyder} på «tilbud-tilbyder-uten-regel», når jeg åpner sakene til søknaden i «Saker i opptak»

    @endrer-data
    Scenariomal: Bytte fra <utdanningsbakgrunn> til norsk utdanningsbakgrunn flytter ingen søknadsalternativer
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «<utdanningsbakgrunn>»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og jeg noterer «B-rolle» på «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Når søkeren «soker-5» velger «Endre søknad», velger «Norsk videregående skole» i «Velg utdanningsbakgrunn» og lagrer
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står «B-rolle» på «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» som notert når jeg åpner sakene til søknaden i «Saker i opptak»

      Eksempler:
        | utdanningsbakgrunn |
        | Realkompetanse |
        | Utenlandsk videregående skole |

    @endrer-data
    Scenariomal: Saksbehandleren endrer utdanningsbakgrunnen til <utdanningsbakgrunn>
      Gitt jeg er logget inn som «opptak-saksbehandler-saksbehandlende»
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og {ORG:opptak-saksbehandler-saksbehandlende} står som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Når jeg åpner saken til søknaden i «Saker i opptak», og velger «<utdanningsbakgrunn>» i «Velg overstyrt utdanningsbakgrunn» under «Utdanningsbakgrunn»
      Og jeg ser «Utdanningsbakgrunn overstyrt»
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle» på «tilbud-saksbehandlende-uten-regel», og {ORG:opptak-saksbehandler-tilbyder} på «tilbud-tilbyder-uten-regel», når jeg åpner sakene til søknaden i «Saker i opptak» som «opptak-forvalter-forvaltende»

      Eksempler:
        | utdanningsbakgrunn |
        | Realkompetanse |
        | Dispensasjon |

    @endrer-data
    Scenariomal: Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen <frist>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg noterer «Endre utdanningsbakgrunn» under «Rediger opptak» → «Saksbehandling», og setter den til <fristdato> (settes tilbake til slutt)
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og {ORG:opptak-saksbehandler-saksbehandlende} står som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Når jeg bytter testbruker til «opptak-saksbehandler-saksbehandlende», åpner saken til søknaden i «Saker i opptak», og velger «Utenlandsk videregående skole» i «Velg overstyrt utdanningsbakgrunn»
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står <organisasjon> som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» når jeg åpner sakene til søknaden i «Saker i opptak» som «opptak-forvalter-forvaltende»
      # Setter tilbake:
      Og jeg setter «Endre utdanningsbakgrunn» tilbake til {DATO:+30} 23:59

      Eksempler:
        | frist             | fristdato        | organisasjon |
        | ikke har gått ut  | {DATO:+30} 23:59    | {ORG:opptak-forvalter-forvaltende} |
        | har gått ut       | {DATO:-1} 23:59 | {ORG:opptak-saksbehandler-saksbehandlende} |

    @endrer-data
    Scenario: Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg setter «Endre utdanningsbakgrunn» under «Rediger opptak» → «Saksbehandling» til {DATO:-1} 23:59 (settes tilbake til slutt)
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og {ORG:opptak-saksbehandler-saksbehandlende} står som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Når jeg åpner saken til søknaden i «Saker i opptak», og velger «Utenlandsk videregående skole» i «Velg overstyrt utdanningsbakgrunn»
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-forvalter-forvaltende} som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» når jeg åpner sakene til søknaden i «Saker i opptak»
      # Setter tilbake:
      Og jeg setter «Endre utdanningsbakgrunn» tilbake til {DATO:+30} 23:59

    @endrer-data
    Scenariomal: Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg setter «Endre utdanningsbakgrunn» under «Rediger opptak» → «Saksbehandling» til {DATO:-1} 23:59 (settes tilbake til slutt)
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og «tilbudsgarantityper» finnes i opptaket (ellers er scenarioet ikke testbart)
      Og «tilbud-saksbehandlende-uten-regel» har «Tilbudsgaranti fra <rolle>» satt
      Når jeg bytter testbruker til «opptak-saksbehandler-saksbehandlende», åpner saken til søknaden og velger «Utenlandsk videregående skole» i «Velg overstyrt utdanningsbakgrunn»
      Og jeg bytter testbruker til «opptak-forvalter-forvaltende», åpner saken, og velger «Flytt saken»
      Og jeg ser «Saken flyttes etter den overstyrte utdanningsbakgrunnen»
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står «tilbud-saksbehandlende-uten-regel» i saken hos {ORG:opptak-forvalter-forvaltende}, uten behandlingsresultat (saksbehandlingen er startet på nytt)
      Og «tilbud-saksbehandlende-uten-regel» har fortsatt «Tilbudsgaranti fra <rolle>» under «Søknadsalternativer»
      # Tilbudsgarantien settes av saksbehandleren, av tilbyderen eller av forvalteren, i hver sin etikett («Tilbudsgaranti fra behandler», «… fra tilbyder», «… fra forvalter»).
      # Setter tilbake:
      Og jeg setter «Endre utdanningsbakgrunn» tilbake til {DATO:+30} 23:59

      Eksempler:
        | rolle            |
        | behandler        |
        | tilbyder         |
        | forvalter        |

    @endrer-data
    Scenario: Organisasjonen søknadsalternativet flyttes til, får en ubehandlet sak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg setter «Endre utdanningsbakgrunn» under «Rediger opptak» → «Saksbehandling» til {DATO:-1} 23:59 (settes tilbake til slutt)
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og saken hos {ORG:opptak-saksbehandler-saksbehandlende} har status «Under behandling» [Sjekk begrep: statusen kan settes i saken]
      Når jeg bytter testbruker til «opptak-saksbehandler-saksbehandlende», åpner saken og velger «Utenlandsk videregående skole» i «Velg overstyrt utdanningsbakgrunn»
      Og jeg bytter testbruker til «opptak-forvalter-forvaltende», åpner saken og velger «Flytt saken»
      Og fordelingen har kjørt (opptil 2 minutter)
      Så har søknaden en sak hos {ORG:opptak-forvalter-forvaltende} i «Saker i opptak» med «Ubehandlet» i «Status» [Sjekk begrep], og saken har «tilbud-saksbehandlende-uten-regel»
      # Setter tilbake:
      Og jeg setter «Endre utdanningsbakgrunn» tilbake til {DATO:+30} 23:59

    @endrer-data
    Scenario: Interne merknader blir igjen hos organisasjonen søknadsalternativet flyttes fra
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg setter «Endre utdanningsbakgrunn» under «Rediger opptak» → «Saksbehandling» til {DATO:-1} 23:59 (settes tilbake til slutt)
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og jeg bytter testbruker til «opptak-saksbehandler-saksbehandlende»
      Og jeg åpner saken til søknaden og skriver «Intern merknad (test {KJØRING})» med «Skriv ny merknad» under «Merknader»
      Når jeg velger «Utenlandsk videregående skole» i «Velg overstyrt utdanningsbakgrunn», bytter testbruker til «opptak-forvalter-forvaltende», åpner saken og velger «Flytt saken»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og jeg bytter testbruker til «opptak-saksbehandler-forvaltende» og åpner saken hos {ORG:opptak-forvalter-forvaltende}
      Så ser jeg «Ingen merknader ennå» under «Merknader»
      Og jeg ser ikke «Intern merknad (test {KJØRING})»
      # Setter tilbake:
      Og jeg setter «Endre utdanningsbakgrunn» tilbake til {DATO:+30} 23:59

    # Teknikk: grenseverdianalyse (frist gått ut)
    @utledet @endrer-data
    Scenario: Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak: endring av søknaden på vegne av søkeren omgår ikke fristen
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg setter «Endre utdanningsbakgrunn» under «Rediger opptak» → «Saksbehandling» til {DATO:-1} 23:59 (settes tilbake til slutt)
      Og søkeren «soker-5» har sendt inn søknad med studieønskene «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» i den rekkefølgen og utdanningsbakgrunnen «Norsk videregående skole»
      Og fordelingen har kjørt (opptil 2 minutter)
      Og {ORG:opptak-saksbehandler-saksbehandlende} står som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»
      Når jeg bytter testbruker til «opptak-saksbehandler-saksbehandlende», åpner saken, velger «Endre søknad» og endrer utdanningsbakgrunnen til «Utenlandsk videregående skole» på vegne av søkeren
      Og fordelingen har kjørt (opptil 2 minutter)
      Så står {ORG:opptak-saksbehandler-saksbehandlende} fortsatt som «B-rolle» på både «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» når jeg åpner sakene til søknaden i «Saker i opptak» som «opptak-forvalter-forvaltende»
      # Setter tilbake:
      Og jeg setter «Endre utdanningsbakgrunn» tilbake til {DATO:+30} 23:59


  @ref-FLY-OPT-SAK-001 @ref-OPT-BEH-BEH-032
  Regel: Saksbehandlende organisasjon ser bare saker hos organisasjonen

    Scenario: Saksbehandleren ser bare saken hos organisasjonen sin
      Gitt jeg er logget inn som «opptak-saksbehandler-saksbehandlende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt, med saker hos flere organisasjoner
      Når jeg åpner søknaden «soknad-norsk» i «Saker i opptak» under «Søknadsbehandling»
      Så ser jeg én rad for søknaden, og «tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel» står i saken med {ORG:opptak-saksbehandler-saksbehandlende} som «B-rolle»
      Og jeg ser ikke «tilbud-deltakende-isolert», «tilbud-deltakende-laerested» eller «tilbud-saksbehandlende-laerested» i saken

    Scenario: Søkeren ser saksbehandlende organisasjon, men ikke sakene
      Gitt jeg er logget inn i Min kompetanse (test) som søkeren «soker-1»
      Og søknaden «soknad-norsk» er sendt inn og fordelt
      Når jeg åpner søknaden min, og ser «Kontakt saksbehandler»
      Så ser jeg «Har du spørsmål angående søknaden, må det rettes til lærestedet det gjelder.»
      Og jeg ser fire bokser, én per saksbehandlende organisasjon ({ORG:opptak-forvalter-deltakende}, {ORG:opptak-saksbehandler-saksbehandlende}, {ORG:opptak-saksbehandler-tilbyder} og {ORG:opptak-forvalter-forvaltende}), med studiene hver organisasjon saksbehandler
      Men jeg ser ingen saker, saksnummer eller saksbehandlere

    Scenario: Saksbehandleren ved forvaltende organisasjon ser bare saken hos forvaltende organisasjon
      Gitt jeg er logget inn som «opptak-saksbehandler-forvaltende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt, med saker hos flere organisasjoner
      Når jeg åpner søknaden «soknad-norsk» i «Saker i opptak» under «Søknadsbehandling»
      Så ser jeg én rad for søknaden, og «tilbud-saksbehandlende-laerested» står i saken med {ORG:opptak-forvalter-forvaltende} som «B-rolle»
      Og jeg ser ikke «tilbud-deltakende-isolert», «tilbud-saksbehandlende-uten-regel», «tilbud-tilbyder-uten-regel» eller «tilbud-deltakende-laerested» i saken

    # Teknikk: tilstandsoverganger (sendt, fordelt)
    @utledet @endrer-data
    Scenario: Saksbehandlende organisasjon ser bare saker hos organisasjonen: søkeren ser opptakets organisasjon som kontakt før søknadsalternativet er fordelt
      Gitt jeg er logget inn i Min kompetanse (test) som søkeren «soker-1»
      Og søknaden «soknad-norsk» er sendt inn og fordelt
      Når jeg velger «Endre søknad» og «Legg til studieønsker», legger til «tilbud-tilbyder-sektor», og sender inn søknaden
      Og jeg åpner «Kontakt saksbehandler» med en gang, før fordelingen har kjørt [Sjekk begrep: tildelingsjobben tar ca. 30 sekunder, så vinduet er kort]
      Så står {ORG:opptak-forvalter-forvaltende} i boksen for studieønsket «tilbud-tilbyder-sektor»
      # Setter tilbake:
      Og jeg fjerner «tilbud-tilbyder-sektor» med «Fjern», og sender inn søknaden


  Regel: Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket

    Scenario: Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og søknaden «soknad-norsk» er sendt inn og fordelt, med saker hos flere organisasjoner
      Når jeg åpner søknaden «soknad-norsk» i «Saker i opptak» under «Søknadsbehandling»
      Så ser jeg fire rader for søknaden, med samme «Søknadsnummer»
      Og sakene står hos {ORG:opptak-forvalter-deltakende} («tilbud-deltakende-isolert»), {ORG:opptak-saksbehandler-saksbehandlende} («tilbud-saksbehandlende-uten-regel» og «tilbud-tilbyder-uten-regel»), {ORG:opptak-saksbehandler-tilbyder} («tilbud-deltakende-laerested») og {ORG:opptak-forvalter-forvaltende} («tilbud-saksbehandlende-laerested»)


  @ref-FLY-OPT-SAK-001
  Regel: Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet

    Scenario: Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler
      Gitt jeg er logget inn som «opptak-saksbehandler-tilbyder»
      Og «tilbud-tilbyder-uten-regel» er fordelt til {ORG:opptak-saksbehandler-saksbehandlende} i søknaden «soknad-norsk»
      Når jeg åpner «Saker i opptak» under «Søknadsbehandling», og åpner søknaden «soknad-norsk»
      Så ser jeg «tilbud-tilbyder-uten-regel» i saken
      Og jeg ser «B-rolle» {ORG:opptak-saksbehandler-saksbehandlende} på «tilbud-tilbyder-uten-regel», og resultatet av saksbehandlingen {ORG:opptak-saksbehandler-saksbehandlende} har gjort på «tilbud-tilbyder-uten-regel» (for eksempel poeng og kvalifisering)

    @endrer-data
    Scenario: Tilbyderen setter tilbudsgaranti
      Gitt jeg er logget inn som «opptak-saksbehandler-tilbyder»
      Og «tilbudsgarantityper» finnes i opptaket (ellers er scenarioet ikke testbart)
      Og «tilbud-tilbyder-uten-regel» er fordelt til {ORG:opptak-saksbehandler-saksbehandlende} i søknaden «soknad-norsk», og har «Ikke valgt» i «Tilbudsgaranti fra tilbyder»
      Når jeg åpner saken til søknaden «soknad-norsk», velger «Søknadsalternativer», og velger en tilbudsgaranti i «Tilbudsgaranti fra tilbyder» for «tilbud-tilbyder-uten-regel»
      Så ser jeg «Tilbudsgaranti lagret»
      Og jeg åpner saken på nytt, og den valgte tilbudsgarantien står i «Tilbudsgaranti fra tilbyder» for «tilbud-tilbyder-uten-regel»
      # Setter tilbake:
      Og jeg velger «Ikke valgt» i «Tilbudsgaranti fra tilbyder» for «tilbud-tilbyder-uten-regel», og ser «Tilbudsgaranti lagret»

    Scenario: Tilbyderen kan ikke endre saksbehandlingen
      Gitt jeg er logget inn som «opptak-saksbehandler-tilbyder»
      Og «tilbud-tilbyder-uten-regel» er fordelt til {ORG:opptak-saksbehandler-saksbehandlende} i søknaden «soknad-norsk», og saksbehandleren ved {ORG:opptak-saksbehandler-saksbehandlende} har skrevet en intern merknad i saken
      Når jeg åpner saken til søknaden «soknad-norsk», og velger «tilbud-tilbyder-uten-regel»
      Så ser jeg ikke de interne merknadene til {ORG:opptak-saksbehandler-saksbehandlende} under «Merknader»
      Og jeg ser ikke muligheten til å endre grunnlaget eller poengene (saken åpnes i lesemodus)
      Og jeg ser ikke «Dokumenter» i saken
