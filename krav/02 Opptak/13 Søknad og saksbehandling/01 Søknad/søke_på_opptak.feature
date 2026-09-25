# language: no
@OPT-SØK-SØK-001 @opptakspilot @implemented
Egenskap: Søke på opptak
    Som borger ønsker jeg å kunne søke på et opptak til et studie jeg ønsker å delta på slik at jeg kan få skoleplass

  @harTest @nih
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

  @harTest @nih
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

  @draft
  Scenario: En person får feilmelding på ikke mottatt kvittering på søknad
    Gitt at personen har forsøkt å søke på et opptak
    Når det skjer noe galt med innsending av søknaden
    Så skal personen få en forklaring på hvorfor

  @nih @draft
  Scenario: Søker kan finne utdanningstilbud i en ekstern studiekatalog hos aktuelt lærested og skal da kunne komme inn i en søknad i brukerflaten derfra
    Gitt personen er inne på hovedsiden til UiT
    Og personen er inne på UiT sin studiekatalog
    Når personen velger et utdanningstilbud fra studiekatalogen
    Og personen velger å søke på utdanningstilbudet
    Så blir personen sendt til utdanningstilbudet i personbrukerflaten

  @harTest
  Scenario: Søker kan se oversikt over alle sine søknader
    Gitt personen har søkt på et opptak
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen se sine søknader i en liste

  @harTest
  Scenario: Søker kan se en spesifikk søknad etter innsending
    Gitt personen er på hovedsiden til personflaten
    Gitt personen har søkt på et opptak
    Når personen trykker på Mine Søknader
    Og personen trykker på en søknad
    Så skal personen kunne se informasjon om søknaden

  @harTest
  Scenario: Søker kan se at en søknad er mottatt etter innsending
    Gitt personen har søkt på et opptak
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen kunne se mottatt i informasjon om søknaden

  @draft
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

  @draft
  Scenario: Søker ser oversikt over påbegynte søknader
    Gitt personen har startet på en søknad og lagret den til senere
    Og personen er på hovedsiden til personflaten
    Når personen trykker på Mine Søknader
    Så skal personen se en oversikt over alle påbegynte søknader

  @draft
  Scenario: Søker går inn på en påbegynt søknader og fullfører den
    Gitt personen har startet på en søknad og lagret den til senere
    Og personen er på hovedsiden til personflaten
    Og personen trykker på Mine Søknader
    Når personen velger en påbegynt søknad
    Så skal personen kunne fortsette søknaden sin som vanlig


  @draft
  Scenario: Søker ser oversikt over innsendte søknader

  @draft
  Scenario: Søker kan se egenopplastet dokumentasjon
    Gitt at personen har søkt på et opptak og lastet opp dokumentasjon
    Når personen går inn på søknaden
    Så skal personen se hvilken dokumentasjon de har lastet opp

  @draft
  Scenario: Søker kan se dokumentasjon lastet opp av saksbehandler
    Gitt at personen har søkt på et opptak og en saksbeandler har lastet opp dokumentasjon
    Når personen går inn på søknaden
    Så skal personen se hvilken dokumentasjon saksbehandler har lastet opp

  @draft
  Scenario: Søker kan laste opp ytterligere dokumentasjon etter innsending av søknad
    Gitt at personen har søkt på et opptak
    Og personen går inn på søknaden
    Når personen laster opp dokumentasjon
    Så skal dokumentasjonen blir tilgjengelig for administratoren


  @draft
  Scenario: Person sletter opplastet dokumentasjon før innsending av søknad
    Gitt En person har lastet opp dokumentasjon
    Når Personen sletter et dokument
    Så blir dokumentet fjernet fra listen

  @draft
  Scenario: Person sletter opplastet dokumentasjon etter innsending av søknad
    Gitt En person har lastet opp dokumentasjon
    Når Personen sletter et dokument
    Så blir dokumentet fjernet fra listen
    Og blir dokumentet ikke lengre tilgjengelig for administrator

  @draft
  Scenario: Person kan trekke søknaden

  @draft
  Scenario: Person kan svare på tilbud om studieplass
  @draft
  Scenario: Person kan endre svar på søknad mellom ja og nei før en gitt frist
  @draft
  Scenario: Saksbehandler kan svare på tilbud manuelt på vegne av søker
  @draft
  Scenario: Søker kan gi tilbakemelding om sin opplevelse

