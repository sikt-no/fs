# language: no
@opptakspilot @ci
Egenskap: 02 Opptak: 24 Søke på opptak
    Som borger ønsker jeg å kunne søke på et opptak til et studie jeg ønsker å delta på slik at jeg kan få skoleplass

  @opptakspilotkritisk
  Scenario: Søker ser viktig informasjon om et opptak: "<info>"
    Gitt personen er på hovedsiden til personflaten
    Når personen går inn på velg opptak
    Og personen velger et opptak
    Så ser personen "<info>"
    Eksempler:
      | info             |
      | Studiestart      |
      | Studieplasser    |
      | Studiekode       |
      | Progresjon       |
      | Utdanningsområde |
      | Semestre         |
      | Studiepoeng      |
      | Kjønnspoeng      |

  @opptakspilotkritisk
  Scenario: En person søker på et opptak med kun ett studie
    Gitt personen er på hovedsiden til personflaten
    Gitt personen er en søker
    Når personen går inn på velg opptak
    Og personen velger et opptak
    Og personen starter søknad
    Og personen aksepterer deling av elektronisk dokumentasjon med saksbehandler
    Og personen laster opp dokumentasjon
    Og personen går til oppsummering
    Og personen sender inn søknad
    Så får personen se en kvittering på at søknaden er mottatt
    Så får personen får se et søknadsnummer

  @opptakspilotkritisk
  Scenario: En person får feilmelding på ikke mottatt kvittering på søknad
    Gitt at personen har forsøkt å søke på et opptak
    Når det skjer noe galt med innsending av søknaden
    Så skal personen få en forklaring på hvorfor

  @opptakspilotkritisk
  Scenario: Søker kan finne utdanningstilbud i en ekstern studiekatalog hos aktuelt lærested og skal da kunne komme inn i en søknad i brukerflaten derfra
    Gitt personen er inne på hovedsiden til UiT
    Og personen er inne på UiT sin studiekatalog
    Når personen velger et utdanningstilbud fra studiekatalogen
    Og personen velger å søke på utdanningstilbudet
    Så blir personen sendt til utdanningstilbudet i personbrukerflaten

  @opptakspilotkritisk
  Scenario: Søker kan se oversikt over alle sine søknader
    Gitt personen har søkt på et opptak
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen se sine søknader i en liste

  @opptakspilotkritisk
  Scenario: Søker kan se en spesifikk søknad etter innsending
    Gitt personen er på hovedsiden til personflaten
    Gitt personen har søkt på et opptak
    Når personen trykker på Mine Søknader
    Og personen trykker på en søknad
    Så skal personen kunne se informasjon om søknaden

  @opptakspilotkritisk
  Scenario: Søker kan se at en søknad er mottatt etter innsending
    Gitt personen har søkt på et opptak
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen kunne se mottatt i informasjon om søknaden

  Scenario: Søker begynner på en søknad og lagrer den uten å sende inn
    Gitt personen er på hovedsiden til personflaten
    Gitt personen er en søker
    Når personen går inn på velg opptak
    Og personen velger et opptak
    Og personen starter søknad
    Og personen aksepterer deling av elektronisk dokumentasjon med saksbehandler
    Og personen laster opp dokumentasjon
    Og personen velger å lagre søknad til senere
    Så skal søknaden være mulig å fortsette på senere

  Scenario: Søker ser oversikt over påbegynte søknader
    Gitt personen har startet på en søknad og lagret den til senere
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen se en oversikt over alle påbegynte søknader

  Scenario: Søker går inn på en påbegynt søknader og fullfører den
    Gitt Gitt personen har startet på en søknad og lagret den til senere
    Og personen er på hovedsiden til personflaten
    Og personen trykker på Mine Søknader
    Når personen velger en påbegynt søknad
    Så skal personen kunne fortsette søknaden sin som vanlig

  @opptakspilotkritisk
  Scenario: Søker ser oversikt over innsendte søknader

  @opptakspilotkritisk
  Scenario: Søker kan se egenopplastet dokumentasjon
    Gitt at personen har søkt på et opptak og lastet opp dokumentasjon
    Når personen går inn på søknaden
    Så skal personen se hvilken dokumentasjon de har lastet opp

  @opptakspilotkritisk
  Scenario: Søker kan se dokumentasjon lastet opp av saksbehandler
    Gitt at personen har søkt på et opptak og en saksbeandler har lastet opp dokumentasjon
    Når personen går inn på søknaden
    Så skal personen se hvilken dokumentasjon saksbehandler har lastet opp

  @opptakspilotkritisk
  Scenario: Søker kan laste opp ytterligere dokumentasjon etter innsending av søknad
    Gitt at personen har søkt på et opptak
    Og personen går inn på søknaden
    Når personen laster opp dokumentasjon
    Så skal dokumentasjonen blir tilgjengelig for administratoren


  # @skip
  # Scenario: Person sletter opplastet dokumentasjon før innsending av søknad
  #   Gitt En person har lastet opp dokumentasjon
  #   Når Personen sletter et dokument
  #   Så blir dokumentet fjernet fra listen
  # @skip
  # Scenario: Person sletter opplastet dokumentasjon etter innsending av søknad
  #   Gitt En person har lastet opp dokumentasjon
  #   Når Personen sletter et dokument
  #   Så blir dokumentet fjernet fra listen
  #   Og blir dokumentet ikke lengre tilgjengelig for administrator
  # Scenario: Person kan se oversikt over påbegynte og innsendte søknader
  # Scenario: Person kan se søknad- og svarstatus på søknaden
  # Scenario: Person kan trekke søknaden
  # Scenario: Person kan laste opp ytterligere dokumentasjon etter innsending av søknad, innen gitte frister
  # Scenario: Person kan svare på tilbud om studieplass
  # Scenario: Person kan endre svar på søknad mellom ja og nei før en gitt frist
  # Scenario: Saksbehandler kan svare på tilbud manuelt på vegne av søker
  # Scenario: Søker kan gi tilbakemelding om sin opplevelse
  # Scenario: Søker oppgir om de søker på grunnlag av realkompetanse
