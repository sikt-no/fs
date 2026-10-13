# language: no
# GitHub: #563
# Implementert i fs-plattform !6135 (utkast, ikke merget).
@BRU-TIL-KAT-003 @must @draft
Egenskap: Forvalte implikasjoner mellom roller
  Som forvalter av rollekatalogen
  ønsker jeg å legge til og fjerne implikasjoner mellom roller
  slik at det en rolle innebærer, kan endres i løsningen og ikke bare direkte i databasen.

  En implikasjon fra rolle A til rolle B betyr at den som har A, også har B. Implikasjonen endrer
  både hva A gir og hvor langt B rekker. Derfor kreves full forvaltningsrett for rollekatalogen i
  eierorganisasjonen til navnerommet til begge rollene, slik det kreves når en rolle flyttes mellom
  navnerom. Uten det kravet kunne forvalteren av ett navnerom gi rollene sine rekkevidde inn i et
  annet.

  At rollene ikke kan danne en syklus, står i BRU-TIL-KAT-004. Hvordan en endret implikasjon virker
  inn i tildelinger og delegeringstak, står i BRU-TIL-KAT-005. Hva en utgått rolle betyr for
  implikasjonene, står i BRU-TIL-KAT-008.

  Bakgrunn:
    Gitt forvalteren er innlogget i løsningen
    Og rollen "OPPTAKSLEDER" ligger i navnerommet "fs"
    Og rollene "OPPTAK_SKRIV" og "OPPTAK_LES" ligger i navnerommet "opptak"

  Regel: En implikasjon kan legges til og fjernes

    Scenario: Legge til en implikasjon
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så har den som har rollen "OPPTAKSLEDER", også rollen "OPPTAK_SKRIV"

    Scenario: Fjerne en implikasjon
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Og "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så innebærer "OPPTAKSLEDER" ikke lenger "OPPTAK_SKRIV"

    Scenariomal: En implikasjon kan gå ut fra en rolle uansett rolletype
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "opptak"
      Og rollen "OPPTAK_SKRIV" har rolletypen <rolletype>
      Når forvalteren legger til at "OPPTAK_SKRIV" innebærer "OPPTAK_LES"
      Så innebærer "OPPTAK_SKRIV" rollen "OPPTAK_LES"

      Eksempler:
        | rolletype        |
        | enkelttilgang    |
        | sammensatt rolle |

  Regel: Flere implikasjoner endres i én forespørsel, alt eller ingenting

    Scenario: Legge til flere implikasjoner i én forespørsel
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Når forvalteren i én forespørsel legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV" og at "OPPTAK_SKRIV" innebærer "OPPTAK_LES"
      Så innebærer "OPPTAKSLEDER" rollen "OPPTAK_SKRIV"
      Og "OPPTAK_SKRIV" innebærer rollen "OPPTAK_LES"

    Scenario: Én implikasjon som avvises, stopper hele forespørselen om å legge til
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Men forvalteren har ikke forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "sis"
      Og rollen "STUDENT_LES" ligger i navnerommet "sis"
      Når forvalteren i én forespørsel legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV" og at "OPPTAKSLEDER" innebærer "STUDENT_LES"
      Så avvises forespørselen
      Og "OPPTAKSLEDER" innebærer ikke "OPPTAK_SKRIV"

    Scenario: Én implikasjon som avvises, stopper hele forespørselen om å fjerne
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Men forvalteren har ikke forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "sis"
      Og rollen "STUDENT_LES" ligger i navnerommet "sis"
      Og "OPPTAKSLEDER" innebærer både "OPPTAK_SKRIV" og "STUDENT_LES"
      Når forvalteren i én forespørsel fjerner implikasjonene fra "OPPTAKSLEDER" til "OPPTAK_SKRIV" og fra "OPPTAKSLEDER" til "STUDENT_LES"
      Så avvises forespørselen
      Og "OPPTAKSLEDER" innebærer fortsatt "OPPTAK_SKRIV"

  Regel: Full forvaltningsrett kreves i eierorganisasjonene til navnerommene til begge rollene

    Scenariomal: Legge til en implikasjon med og uten forvaltningsrett
      Gitt forvalteren <rett i fs> full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "fs"
      Og forvalteren <rett i opptak> full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "opptak"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så <resultat>

      Eksempler:
        | rett i fs   | rett i opptak | resultat                                         |
        | har         | har           | innebærer "OPPTAKSLEDER" rollen "OPPTAK_SKRIV"   |
        | har         | har ikke      | avvises forespørselen som manglende rett          |
        | har ikke    | har           | avvises forespørselen som manglende rett          |

    Scenariomal: Fjerne en implikasjon med og uten forvaltningsrett
      Gitt "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Og forvalteren <rett i fs> full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "fs"
      Og forvalteren <rett i opptak> full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "opptak"
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så <resultat>

      Eksempler:
        | rett i fs   | rett i opptak | resultat                                              |
        | har         | har           | innebærer "OPPTAKSLEDER" ikke lenger "OPPTAK_SKRIV"   |
        | har         | har ikke      | avvises forespørselen som manglende rett               |
        | har ikke    | har           | avvises forespørselen som manglende rett               |

    Scenario: Retten til å oppdatere beskrivelser er ikke nok
      Gitt forvalteren har rett til å oppdatere beskrivelser i rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Men forvalteren har ikke full forvaltningsrett for rollekatalogen i noen av eierorganisasjonene
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så avvises forespørselen som manglende rett

  Regel: En endring som allerede gjelder, er vellykket

    # Legg til og fjern beskriver hvordan implikasjonene skal være etterpå. Er de det allerede, er
    # det ingenting å gjøre, og forespørselen er vellykket. Retten kreves likevel, så en forespørsel
    # uten noe å endre er ingen vei rundt den.

    Scenario: Legge til en implikasjon som allerede gjelder
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Og "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så er forespørselen vellykket
      Og implikasjonen har fortsatt tidspunktet den først ble lagt til

    Scenario: Fjerne en implikasjon som ikke gjelder
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Og "OPPTAKSLEDER" innebærer ikke "OPPTAK_SKRIV"
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så er forespørselen vellykket

    Scenario: Legge til en implikasjon som allerede gjelder, krever forvaltningsrett
      Gitt "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Og forvalteren har ikke full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "opptak"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så avvises forespørselen som manglende rett

    Scenario: Fjerne en implikasjon som ikke gjelder, krever forvaltningsrett
      Gitt "OPPTAKSLEDER" innebærer ikke "OPPTAK_SKRIV"
      Og forvalteren har ikke full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "opptak"
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så avvises forespørselen som manglende rett

  Regel: Svaret avslører ikke hvilke roller som finnes

    # Ved fjerning er en rolle som ikke finnes, bare en implikasjon som ikke gjelder. Svaret blir
    # det samme som for en kjent rolle uten implikasjonen, slik det er for en ukjent tilgang i et
    # delegeringstak. Ved å legge til har en rolle som ikke finnes, ingen eierorganisasjon å ha
    # forvaltningsrett i, og forespørselen avvises som manglende rett.

    Scenario: Fjerne en implikasjon til en rolle som ikke finnes
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "fs"
      Og rollen "FINNES_IKKE" finnes ikke i rollekatalogen
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "FINNES_IKKE"
      Så er forespørselen vellykket
      Og svaret er det samme som for en rolle som finnes, men som "OPPTAKSLEDER" ikke innebærer

    Scenario: Fjerne en implikasjon til en rolle som ikke finnes, uten forvaltningsrett for den kjente rollen
      Gitt forvalteren har ikke full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "fs"
      Og rollen "FINNES_IKKE" finnes ikke i rollekatalogen
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "FINNES_IKKE"
      Så avvises forespørselen som manglende rett

    Scenario: Legge til en implikasjon til en rolle som ikke finnes
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonen til navnerommet "fs"
      Og rollen "FINNES_IKKE" finnes ikke i rollekatalogen
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "FINNES_IKKE"
      Så avvises forespørselen som manglende rett
      Og svaret er det samme som for en rolle i et navnerom forvalteren ikke har forvaltningsrett i

  Regel: En fjernet implikasjon blir stående som historikk

    @openquestion
    Scenario: Fjernet implikasjon er bevart med hvem som fjernet den
      # ÅPNE SPØRSMÅL:
      # - Skal historikken kunne leses i løsningen? I dag er den bevart, men vises ikke.
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Og "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så er implikasjonen bevart med tidspunktet den ble lagt til og tidspunktet den ble fjernet
      Og det er bevart hvem som la den til og hvem som fjernet den

    Scenario: En implikasjon som legges til på nytt, får et nytt innslag
      Gitt forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene "fs" og "opptak"
      Og implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV" er fjernet
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så innebærer "OPPTAKSLEDER" rollen "OPPTAK_SKRIV"
      Og den fjernede implikasjonen er fortsatt bevart med tidspunktet den ble fjernet
