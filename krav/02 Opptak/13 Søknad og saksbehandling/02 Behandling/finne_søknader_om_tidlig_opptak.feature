# language: no
# GitHub: #456
#
# KILDER
#
# Del av initiativet #456 Behandle søknader om tidlig opptak. Behovet kom fra
# kravgjennomgangen 08.10.2026: saksbehandleren må finne sakene der søkeren har
# søkt om tidlig opptak, for å vurdere dem i tide.
#
# Vurderingen og konklusjonen står i vurdere_søknad_om_tidlig_opptak.feature
# (OPT-BEH-BEH-008). Hva søkeren gjør, står i søke_om_tidlig_opptak.feature
# (OPT-SØK-SØK-011).
#
# Det finnes ikke noe krav for selve sakslisten i saksbehandlingen ennå. Dette
# kravet beskriver bare filteret for tidlig opptak. Sakslisten får ingen egen
# kolonne for tidlig opptak (avklart 08.10.2026). Kolonnene hører hjemme i et
# eget krav for sakslisten. Filteret følger
# «Søk og filtrering» i .claude/rules/listevisning-pattern.md.
#
# Koden (fs-plattform main, 07.10.2026) har ikke et slikt filter:
# SakFilterV2Input i saksbehandling/sak.graphqls filtrerer på status,
# utdanningsbakgrunn, levert tidspunkt med mer, men ikke på tidlig opptak.
#
@OPT-BEH-BEH-009 @must @in-progress
Egenskap: Finne søknader om tidlig opptak
  Som saksbehandler
  ønsker jeg å filtrere sakene på om søkeren har søkt om tidlig opptak
  slik at jeg raskt finner sakene som må vurderes før tidligopptaket gjennomføres.

  Bakgrunn:
    Gitt saksbehandler er innlogget i løsningen
    Og saksbehandler ser listen over saker i opptaket "Samordna opptak 2027"

  Regel: Søk og filtrering av saker på tidlig opptak
    En søker er med i tidligopptaket bare når saksbehandleren har konkludert med
    at søkeren deltar, og saken er ferdig behandlet. Filteret «Tidlig opptak ikke
    ferdig behandlet» er arbeidslisten over sakene der noe av dette mangler, slik
    at ingen søker faller ut av tidligopptaket uten at saksbehandleren har bestemt det.

    # Filteret er ett valg som er av eller på (avkrysningsboks), ikke en
    # nedtrekksliste. Det finnes ikke noe valg for «ikke søkt om tidlig opptak»
    # (avklart 08.10.2026).
    #
    # «Tidlig opptak ikke ferdig behandlet» er et eget valg av samme slag. Det
    # viser sakene der søkeren har søkt om tidlig opptak, og der saksbehandleren
    # ikke har konkludert, eller har konkludert med at søkeren deltar, men saken
    # ikke er ferdig behandlet. Saker med konklusjonen «deltar ikke» er ikke med,
    # uansett om saken er ferdig behandlet: for dem er det tatt et valg, og
    # statusen betyr ikke noe for tidligopptaket (avklart 08.10.2026). Valget het
    # tidligere «Ikke vurdert for tidlig opptak», og så bare på konklusjonen. Men
    # bare ferdig behandlede saker er med i tidligopptaket
    # (gi_tilbudsgaranti_ved_tidlig_opptak.feature), og en sak med konklusjonen
    # «deltar» som ikke er ferdig behandlet, ville falt ut uten å vises i filteret.
    # En mangel i dokumentasjonen påvirker ikke filteret.

    Scenario: Filteret for tidlig opptak er ikke valgt som standard
      Gitt opptaket har følgende saker:
        | søker         | søkt om tidlig opptak |
        | Kari Nordmann | ja                    |
        | Ola Nordmann  | nei                   |
      Når saksbehandler åpner sakslisten
      Så er filteret "Søkt om tidlig opptak" ikke valgt
      Og saksbehandler ser sakene til "Kari Nordmann" og "Ola Nordmann"

    Scenario: Filtrere på søkt om tidlig opptak
      Gitt opptaket har følgende saker:
        | søker         | søkt om tidlig opptak |
        | Kari Nordmann | ja                    |
        | Ola Nordmann  | nei                   |
      Når saksbehandler velger filteret "Søkt om tidlig opptak"
      Så vises kun saken til "Kari Nordmann"

    Scenario: Filtrere på saker der tidlig opptak ikke er ferdig behandlet
      Gitt opptaket har følgende saker:
        | søker          | søkt om tidlig opptak | konklusjon for tidlig opptak | ferdig behandlet |
        | Kari Nordmann  | ja                    | deltar                       | ja               |
        | Per Hansen     | ja                    | ingen                        | nei              |
        | Lise Berg      | ja                    | ingen                        | ja               |
        | Nils Dahl      | ja                    | deltar                       | nei              |
        | Anne Lie       | ja                    | deltar ikke                  | nei              |
        | Ola Nordmann   | nei                   | ingen                        | nei              |
      Når saksbehandler velger filteret "Tidlig opptak ikke ferdig behandlet"
      Så vises kun sakene til "Per Hansen", "Lise Berg" og "Nils Dahl"

    Scenario: Kombinere filteret for tidlig opptak med andre filtre
      Når saksbehandler kombinerer filteret for tidlig opptak med ett eller flere andre filtre
      Så vises kun saker som matcher alle kriteriene
