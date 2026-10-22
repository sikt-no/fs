# language: no
# Generert av fs-testcaser-cdp 2026-10-22 (pilot, skrevet for hånd) fra akseptansetest/grunnleggende-brukeradministrasjon/testplan.md
# Krav: krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/søke_opp_bruker.feature @ c9fd3ed (blob f538492)
# Ord fra skjermen: fs-admin @ 768a71abd (2026-10-21), PersonbrukereOverview, og messages/nb/tilgangsstyring.json
@TST-BRU-PER-GRU-001 @depends-on-BRU-PER-GRU-001
Egenskap: Listevisning og søk i personbrukere
  Testene sjekker personbrukerlisten i FS Admin slik brukeradministratoren ser den. Pilot: bare scenarioene som ikke trenger bestemte testdata.

  Bakgrunn:
    Gitt jeg er logget inn som «brukeradministrator-alle-miljoer»
    Og jeg har valgt «Tilgangsstyring» i menyen og deretter «Personbrukere»

  Regel: Liste over alle personbrukere

    # Testcase: 4.1
    Scenario: Se liste over personbrukere
      Når jeg ser listen «Resultater»
      Så har listen kolonnene «Navn», «Feide-ID», «Hjemorganisasjon» og «Status»
      Og radene i listen er sortert etter «Navn» i stigende rekkefølge
      Og hver rad viser et navn eller «-», en Feide-ID, en hjemorganisasjon eller «-», og en status

    # Testcase: 4.2
    Scenario: Liste viser de 50 første personbrukerne
      Gitt det finnes personbrukere «over-50-personbrukere»
      Når jeg ser listen «Resultater»
      Så ser jeg teksten «Viser 50 av N rader», der N er større enn 50
      Og listen har 50 rader
      Og «Last inn flere» er tilgjengelig

    # Testcase: 4.3
    Scenario: Laste inn 50 flere personbrukere
      Gitt det finnes personbrukere «over-50-personbrukere»
      Og jeg ser listen «Resultater» med 50 rader
      Når jeg velger «Last inn flere»
      Så har listen 100 rader, eller alle N rader når N er mindre enn 100
      Og de 50 første radene er de samme som før, i samme rekkefølge

    # Testcase: 4.4
    Scenario: Alle personbrukere er lastet inn
      Gitt det finnes personbrukere «over-50-personbrukere»
      Og jeg har valgt «Last inn flere» til knappen ikke lenger vises
      Når jeg ser listen «Resultater»
      Så vises ikke «Last inn flere»
      Og jeg ser teksten «N rader i listen», der N er antall rader i listen

  Regel: Søk og filtrering av personbrukere

    # Testcase: 4.8
    Scenario: Tilgjengelige statuser i filter
      Gitt filtrene er synlige, og er siden smal, har jeg åpnet «Filter»
      Når jeg åpner filteret «Status»
      Så kan jeg velge mellom «Alle statuser», «Aktiv» og «Deaktivert»
      Og «Alle statuser» er valgt som standard
