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
    # Filteret er ett valg som er av eller på (avkrysningsboks), ikke en
    # nedtrekksliste. Det finnes ikke noe valg for «ikke søkt om tidlig opptak»
    # (avklart 08.10.2026).
    #
    # «Ikke vurdert for tidlig opptak» er et eget valg av samme slag. Det viser
    # sakene der søkeren har søkt om tidlig opptak, og saksbehandleren ikke har
    # konkludert om søkeren deltar i tidligopptaket. Det er sakene som må
    # vurderes før tidligopptaket gjennomføres (avklart 08.10.2026).

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

    Scenario: Filtrere på saker som ikke er vurdert for tidlig opptak
      Gitt opptaket har følgende saker:
        | søker          | søkt om tidlig opptak | konklusjon for tidlig opptak |
        | Kari Nordmann  | ja                    | deltar                       |
        | Per Hansen     | ja                    | ingen                        |
        | Ola Nordmann   | nei                   | ingen                        |
      Når saksbehandler velger filteret "Ikke vurdert for tidlig opptak"
      Så vises kun saken til "Per Hansen"

    Scenario: Kombinere filteret for tidlig opptak med andre filtre
      Når saksbehandler kombinerer filteret for tidlig opptak med ett eller flere andre filtre
      Så vises kun saker som matcher alle kriteriene
