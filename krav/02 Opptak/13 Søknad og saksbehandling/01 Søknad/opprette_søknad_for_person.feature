# language: no
@OPT-SØK-SØK-002 @must @draft
Egenskap: Registrere, endre og trekke søknad på søkerens vegne
  Som opptaksforvalter hos forvalteren
  ønsker jeg å registrere, endre og trekke en søknad på søkerens vegne
  slik at søkere som ikke kan registrere eller endre søknaden selv, likevel kan søke opptak.

  Noen søkere kan ikke registrere søknaden selv, for eksempel fordi de ikke har norsk eID,
  eller fordi de har fått lov til å søke etter søknadsfristen. Før søknaden registreres, slår
  opptaksforvalteren opp søkeren, så søkeren ikke får to søknader, og det ikke opprettes en ny
  profil i Min kompetanse som senere må slås sammen med en annen. Oppslaget viser bare det som
  trengs for å kjenne igjen søkeren, så ingen kan snoke i profilene i Min kompetanse.

  # Kilde: utkastene «Registrere søknad på vegne av søker» og «Endre søknad på vegne av søker»
  # fra fagperson i opptak, november 2026. De to er slått sammen her, og erstatter den forrige
  # versjonen av kravet. Feltene for en søker uten fødselsnummer er tatt med fra den forrige versjonen.
  # Saksbehandlers overstyring av utdanningsbakgrunnen er et eget krav.

  Regel: Bare opptaksforvalter hos forvalteren kan registrere, endre og trekke en søknad på søkerens vegne

    Scenariomal: Registrere en søknad på søkerens vegne
      Gitt jeg er <rolle> hos <organisasjonens rolle> i opptaket
      Når jeg vil registrere en søknad på søkerens vegne
      Så <utfall>

      Eksempler:
        | rolle             | organisasjonens rolle | utfall                                          |
        | opptaksforvalter  | forvalteren           | kan jeg registrere søknaden                     |
        | opptaksforvalter  | tilbyderen            | ser jeg ikke muligheten til å registrere søknad |
        | saksbehandler     | behandleren           | ser jeg ikke muligheten til å registrere søknad |
        | saksbehandler     | forvalteren           | ser jeg ikke muligheten til å registrere søknad |
        | opptaksinformatør | forvalteren           | ser jeg ikke muligheten til å registrere søknad |

    Scenariomal: Endre en søknad på søkerens vegne
      Gitt søkeren har en søknad i opptaket
      Og jeg er <rolle> hos <organisasjonens rolle> i opptaket
      Når jeg åpner søknaden
      Så <utfall>

      Eksempler:
        | rolle             | organisasjonens rolle | utfall                                       |
        | opptaksforvalter  | forvalteren           | kan jeg endre søknaden på søkerens vegne     |
        | opptaksforvalter  | tilbyderen            | ser jeg ikke muligheten til å endre søknaden |
        | saksbehandler     | behandleren           | ser jeg ikke muligheten til å endre søknaden |
        | saksbehandler     | forvalteren           | ser jeg ikke muligheten til å endre søknaden |
        | opptaksinformatør | forvalteren           | ser jeg ikke muligheten til å endre søknaden |

    Scenariomal: Trekke en søknad på søkerens vegne
      Gitt søkeren har en søknad i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og jeg er <rolle> hos <organisasjonens rolle> i opptaket
      Når jeg vil trekke søknaden på søkerens vegne
      Så <utfall>

      Eksempler:
        | rolle             | organisasjonens rolle | utfall                                        |
        | opptaksforvalter  | forvalteren           | kan jeg trekke søknaden                       |
        | opptaksforvalter  | tilbyderen            | ser jeg ikke muligheten til å trekke søknaden |
        | saksbehandler     | behandleren           | ser jeg ikke muligheten til å trekke søknaden |
        | saksbehandler     | forvalteren           | ser jeg ikke muligheten til å trekke søknaden |
        | opptaksinformatør | forvalteren           | ser jeg ikke muligheten til å trekke søknaden |

  Regel: Opptaksforvalteren kan registrere og endre søknaden også etter søknadsfristen

    Scenariomal: Registrere søknaden når søknadsfristen <fristsituasjon>
      Gitt søknadsfristen i opptaket <fristsituasjon>
      Når jeg registrerer en søknad på søkerens vegne
      Så er søknaden registrert i opptaket

      Eksempler:
        | fristsituasjon   |
        | ikke har gått ut |
        | har gått ut      |

    Scenariomal: Endre søknaden når søknadsfristen <fristsituasjon>
      Gitt søkeren har en søknad i opptaket
      Og søknadsfristen i opptaket <fristsituasjon>
      Når jeg endrer søknaden på søkerens vegne
      Så er endringen lagret på søknaden

      Eksempler:
        | fristsituasjon   |
        | ikke har gått ut |
        | har gått ut      |

  @openquestion
  Regel: Søknaden kan ikke registreres eller endres når opptaket er avsluttet
    # ÅPNE SPØRSMÅL:
    # - Hvilken status på opptaket er «avsluttet», og hvilke er «åpent eller i bruk»? Koden avviser i dag bare et arkivert opptak.
    # - Koden krever at søkingen i opptaket har åpnet, også for opptaksforvalteren. Skal det stå i kravet?
    # - Kan opptaksforvalteren registrere og endre søknader når opptaket er avpublisert?

    Scenario: Registrere en søknad i et avsluttet opptak
      Gitt opptaket er avsluttet
      Når jeg vil registrere en søknad på søkerens vegne
      Så avvises registreringen
      Og jeg får beskjed om at opptaket ikke lenger er i bruk

    Scenario: Endre en søknad i et avsluttet opptak
      Gitt søkeren har en søknad i opptaket
      Og opptaket er avsluttet
      Når jeg vil endre søknaden på søkerens vegne
      Så avvises endringen
      Og jeg får beskjed om at opptaket ikke lenger er i bruk

  @openquestion
  Regel: Søkeren slås opp før søknaden registreres
    # ÅPNE SPØRSMÅL:
    # - Kan søkeren også slås opp på d-nummer, eller bare på fødselsnummer?

    Scenario: Personoppslaget kommer før registreringen
      Når jeg begynner å registrere en søknad på søkerens vegne
      Så må jeg slå opp søkeren før jeg kan registrere søknaden

    Scenario: Fødselsnummer er førstevalget i personoppslaget
      Når jeg slår opp søkeren
      Så er oppslag på fødselsnummer valgt

    Scenariomal: Personoppslag uten fødselsnummer krever eksakt treff på <søkekriterium>
      Gitt søkeren har en profil i Min kompetanse
      Når jeg slår opp søkeren med <søkekriterium>
      Så <resultat>

      Eksempler:
        | søkekriterium                   | resultat                                    |
        | hele e-postadressen             | får jeg treff på profilen                   |
        | fullt navn og fødselsdato       | får jeg treff på profilen                   |
        | bare navnet                     | får jeg ingen treff                         |
        | bare fødselsdatoen              | får jeg ingen treff                         |
        | en del av e-postadressen        | får jeg ingen treff                         |

    Scenario: Velge profil når oppslaget gir flere treff
      Når personoppslaget gir treff på flere profiler
      Så velger jeg profilen søknaden skal kobles til

    Scenario: For mange treff i personoppslaget
      Når personoppslaget gir treff på flere enn 5 profiler
      Så vises ingen av treffene
      Og jeg får beskjed om å gjøre oppslaget mer presist

  Regel: Personoppslaget viser bare det som trengs for å kjenne igjen søkeren

    Scenario: Personoppslag finnes bare når en søknad registreres
      Gitt jeg er ikke i gang med å registrere en søknad på søkerens vegne
      Når jeg vil slå opp en person i Min kompetanse
      Så ser jeg ikke muligheten til å slå opp personen

    Scenario: Profilene i Min kompetanse kan ikke listes opp
      Når jeg registrerer en søknad på søkerens vegne
      Så kan jeg ikke bla gjennom eller liste opp profilene i Min kompetanse

    Scenario: Oppslag på fødselsnummer viser navn og fødselsnummer
      Når et personoppslag på fødselsnummer gir treff på en profil
      Så ser jeg navnet og fødselsnummeret til søkeren
      Men jeg ser ingen andre opplysninger fra profilen

    Scenariomal: Oppslag på <søkekriterium> viser opplysningene som trengs for å kontrollere treffet
      Når et personoppslag på <søkekriterium> gir treff
      Så ser jeg navnet, fødselsdatoen og e-postadressen for hvert treff
      Og opplysningene er ikke maskert
      Men jeg ser ingen andre opplysninger fra profilene

      Eksempler:
        | søkekriterium             |
        | e-postadresse             |
        | fullt navn og fødselsdato |

    Scenario: Personoppslaget og koblingen blir logget
      Når jeg slår opp en søker eller kobler en søknad til en profil
      Så logges hvem som gjorde det, når, i hvilket opptak og med hvilke søkekriterier

  @openquestion
  Regel: Søkeren kan ha bare én søknad i opptaket
    # ÅPNE SPØRSMÅL:
    # - Regnes en trukket søknad som en søknad i opptaket? Koden lar i dag opptaksforvalteren registrere en ny søknad når den forrige er trukket, og gjenoppretter da den trukne søknaden med et nytt søknadsnummer.

    Scenario: Søkeren har allerede en søknad i opptaket
      Gitt søkeren har en søknad i opptaket
      Når jeg slår opp søkeren
      Så får jeg beskjed om at søkeren allerede har en søknad i opptaket
      Og jeg kan ikke registrere en ny søknad for søkeren i opptaket

    Scenario: Søkeren har ingen søknad i opptaket
      Gitt søkeren har ingen søknad i opptaket
      Når jeg slår opp søkeren
      Så kan jeg registrere en søknad for søkeren

  Regel: Søknaden kobles til profilen personoppslaget gir treff på

    Scenario: Oppslag på fødselsnummer gir treff på en profil
      Gitt søkeren har en profil i Min kompetanse med norsk fødselsnummer
      Og personoppslaget på fødselsnummeret ga treff på profilen
      Når jeg registrerer søknaden
      Så er søknaden koblet til profilen
      Og det er ikke opprettet en ny profil

    Scenariomal: Oppslag på <søkekriterium> gir treff på en profil med fødselsnummer
      Gitt søkeren har en profil i Min kompetanse med norsk fødselsnummer
      Og personoppslaget på <søkekriterium> ga treff på profilen
      Når jeg registrerer søknaden
      Så er søknaden koblet til profilen
      Og det er ikke opprettet en ny profil

      Eksempler:
        | søkekriterium             |
        | e-postadresse             |
        | fullt navn og fødselsdato |

    @depends-on-OPT-SØK-SØK-004
    Scenario: Søkerens digitale resultater er med i søknaden
      Gitt søknaden er koblet til en profil med norsk fødselsnummer
      Når jeg har registrert søknaden
      Så er søkerens digitale resultater tilgjengelige i søknaden

    Scenario: Oppslaget gir treff på en profil med alternativ innlogging
      Gitt søkeren har ikke norsk fødselsnummer
      Og søkeren har en profil i Min kompetanse med alternativ innlogging
      Og personoppslaget ga treff på profilen
      Når jeg registrerer søknaden
      Så er søknaden koblet til profilen
      Og det er ikke opprettet en ny profil
      Og søkeren ser søknaden når søkeren logger inn med alternativ innlogging

  Regel: En ny profil opprettes bare når personoppslaget ikke gir treff

    Scenario: Ny profil når oppslaget ikke gir treff
      Gitt personoppslaget ga ikke treff på noen profil
      Når jeg registrerer en søknad på søkerens vegne
      Så er det opprettet en ny profil
      Og søknaden er koblet til den nye profilen

    @depends-on-OPT-SØK-SØK-004
    Scenario: Ny profil for en søker med fødselsnummer
      Gitt det finnes ingen profil med fødselsnummeret til søkeren
      Når jeg registrerer en søknad med fødselsnummeret til søkeren
      Så er det opprettet en ny profil med fødselsnummeret
      Og søkerens digitale resultater er tilgjengelige i søknaden

    Scenario: Søkeren logger inn for første gang etter at opptaksforvalteren har opprettet profilen
      Gitt det ble opprettet en ny profil med søkerens fødselsnummer da søknaden ble registrert
      Når søkeren logger inn med ID-porten for første gang
      Så kommer søkeren inn på profilen som ble opprettet
      Og søkeren ser søknaden

    @openquestion
    Scenario: Ny profil for en søker uten fødselsnummer
      # ÅPNE SPØRSMÅL:
      # - Hvordan blir innloggingsdetaljene til (brukernavn og passord), og hvordan får søkeren dem?
      Gitt søkeren har ikke norsk fødselsnummer
      Og personoppslaget ga ikke treff på noen profil
      Når jeg registrerer en søknad på søkerens vegne
      Så er det opprettet en ny profil med alternativ innlogging
      Og det er laget innloggingsdetaljer for søkeren
      Og søknaden er koblet til den nye profilen

    Scenario: Opplysningene jeg legger inn for en søker uten fødselsnummer
      Gitt søkeren har ikke norsk fødselsnummer
      Og personoppslaget ga ikke treff på noen profil
      Når jeg registrerer en søknad på søkerens vegne
      Så må jeg legge inn disse opplysningene om søkeren:
        | opplysning      |
        | Navn            |
        | Fødselsdato     |
        | Kjønn           |
        | Statsborgerskap |
        | E-postadresse   |
        | Telefonnummer   |
        | Kontaktadresse  |

  @openquestion
  Regel: Det går fram av søknaden at opptaksforvalteren har registrert eller endret den
    # ÅPNE SPØRSMÅL:
    # - Hvem ser det: saksbehandlerne, søkeren, eller begge?
    # - Skal det vises hvilken opptaksforvalter som gjorde det, og når?

    Scenariomal: Søknaden viser at den er <handling> av opptaksforvalter
      Når jeg har <handling> søknaden på søkerens vegne
      Så går det fram av søknaden at den er <handling> av opptaksforvalter

      Eksempler:
        | handling      |
        | registrert    |
        | endret        |
        | trukket       |
        | gjenopprettet |

  @openquestion
  Regel: Opptaksforvalteren kan legge inn en kommentar på søknaden
    # ÅPNE SPØRSMÅL:
    # - Hvem ser kommentaren? Bare ansatte, eller også søkeren?
    # - Kan kommentaren være en merknad i saken (@OPT-BEH-BEH-044), eller er det noe annet?

    Scenario: Registrere søknaden med en kommentar
      Når jeg registrerer en søknad på søkerens vegne med en kommentar, for eksempel et saksnummer
      Så er kommentaren lagret på søknaden

    Scenario: Registrere søknaden uten kommentar
      Når jeg registrerer en søknad på søkerens vegne uten kommentar
      Så er søknaden registrert i opptaket

  @openquestion
  Regel: Opptaksforvalteren kan endre søknadsalternativene og trekke søknaden på søkerens vegne
    # ÅPNE SPØRSMÅL:
    # - Gjelder fristene søkeren har for å endre prioriteringen og slette søknadsalternativer (@OPT-SØK-SØK-006), også for opptaksforvalteren?
    # - Koden avviser trekking når plasstildelingen har kjørt. Skal det stå i kravet, eller gjelder regelen for søkeren (en ferdigbehandlet søknad kan ikke trekkes, @OPT-SØK-SØK-008)?

    Scenariomal: Endre søknaden på søkerens vegne: <endring>
      Gitt søkeren har en søknad i opptaket
      Når jeg <endring> på søkerens vegne
      Så er endringen lagret på søknaden

      Eksempler:
        | endring                                       |
        | legger til et søknadsalternativ               |
        | sletter et søknadsalternativ                  |
        | endrer prioriteringen av søknadsalternativene |
        | trekker søknaden                              |

  @openquestion @ref-OPT-SØK-SØK-019
  Regel: Opptaksforvalteren kan laste opp og slette dokumentasjon på søkerens vegne
    # ÅPNE SPØRSMÅL:
    # - Tilgangsscopet (tilgang-i-opptak-2027, svar 21) og begrepslista sier at bare dokumentforvalter hos forvalteren laster opp og sletter dokumentasjon på søkerens vegne. Skal opptaksforvalteren også kunne det?

    Scenariomal: Endre dokumentasjonen på søkerens vegne: <endring>
      Gitt søkeren har en søknad i opptaket
      Når jeg <endring> på søkerens vegne
      Så er endringen lagret på søknaden

      Eksempler:
        | endring                                     |
        | laster opp dokumentasjon i søknaden         |
        | sletter dokumentasjon som er lastet opp     |

  @openquestion
  Regel: Opptaksforvalteren kan gjenopprette en trukket søknad
    # ÅPNE SPØRSMÅL:
    # - Hva skjer når et søknadsalternativ ikke kan gjenopprettes, for eksempel fordi utdanningstilbudet ikke lenger er med i opptaket? Koden gjenoppretter da resten og sier hvilke som er utelatt.

    Scenariomal: Gjenopprette en søknad som er trukket av <trukket av>
      Gitt søknaden er trukket av <trukket av>
      Når jeg gjenoppretter søknaden
      Så er søknaden aktiv i opptaket igjen
      Og søknaden har de samme søknadsalternativene som før den ble trukket
      Og søknadsalternativene har den samme prioriteringen som før søknaden ble trukket

      Eksempler:
        | trukket av       |
        | søkeren          |
        | opptaksforvalter |

  @openquestion
  Regel: Opptaksforvalteren kan endre personopplysningene til en søker med alternativ innlogging
    # ÅPNE SPØRSMÅL:
    # - Hvilke personopplysninger kan opptaksforvalteren endre?

    Scenario: Endre personopplysningene til en søker med alternativ innlogging
      Gitt søkeren har en profil med alternativ innlogging
      Når jeg endrer personopplysningene på søknaden
      Så er endringen lagret

  @depends-on-OPT-SØK-SØK-010
  Regel: Søkeren får en kvittering i Min kompetanse når opptaksforvalteren har gjort noe på søkerens vegne
    # Kvitteringen er en melding i Mine meldinger. Kvitteringen når søknaden er registrert, endret,
    # trukket eller gjenopprettet på søkerens vegne, står i @OPT-SØK-SØK-010
    # («Søkeren får kvittering for saksbehandlerens endringer»).

    Scenario: Kvittering når personopplysningene er endret
      Gitt søkeren har en profil med alternativ innlogging
      Når jeg har endret personopplysningene på søknaden
      Så får søkeren en kvittering i Min kompetanse om at opplysningene er endret
