# language: no
# GitHub: #563
# Implementert i fs-plattform !6135 (utkast, ikke merget).
@BRU-TIL-KAT-004 @must @draft
Egenskap: Hindre sykliske implikasjoner mellom roller
  Som forvalter av rollekatalogen
  ønsker jeg at en implikasjon som ville gitt en syklus, avvises
  slik at roller ikke blir til én og samme rolle uten at noen har bestemt det.

  En syklus i implikasjonene gjør alle rollene i den til én rolle: den som har én av dem, har alle.
  Det endrer hva hver av rollene gir, også for alle som allerede har dem, og er derfor aldri ønsket.
  En implikasjon som ville gitt en syklus, avvises, uansett hvor mange roller syklusen går
  gjennom. En rolle kan heller ikke innebære seg selv.

  Hvem som kan legge til implikasjoner, står i BRU-TIL-KAT-003.

  Bakgrunn:
    Gitt forvalteren er innlogget i løsningen
    Og forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene rollene ligger i

  Regel: En implikasjon som ville gitt en syklus, avvises

    Scenario: En rolle kan ikke innebære seg selv
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAKSLEDER"
      Så avvises forespørselen
      Og det fremgår at implikasjonen ville gitt en syklus

    Scenario: To roller kan ikke innebære hverandre
      Gitt "OPPTAK_SKRIV" innebærer "OPPTAK_LES"
      Når forvalteren legger til at "OPPTAK_LES" innebærer "OPPTAK_SKRIV"
      Så avvises forespørselen
      Og det fremgår at implikasjonen ville gitt en syklus

    Scenario: En syklus gjennom flere roller avvises
      Gitt "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Og "OPPTAK_SKRIV" innebærer "OPPTAK_LES"
      Når forvalteren legger til at "OPPTAK_LES" innebærer "OPPTAKSLEDER"
      Så avvises forespørselen
      Og det fremgår at implikasjonen ville gitt en syklus

    Scenario: En implikasjon som ville gitt en syklus, stopper hele forespørselen
      Gitt "OPPTAK_SKRIV" innebærer "OPPTAK_LES"
      Når forvalteren i én forespørsel legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV" og at "OPPTAK_LES" innebærer "OPPTAK_SKRIV"
      Så avvises forespørselen
      Og "OPPTAKSLEDER" innebærer ikke "OPPTAK_SKRIV"

  Regel: To roller som innebærer den samme rollen, danner ikke en syklus

    Scenario: En implikasjon mellom to roller med en felles implisert rolle godtas
      Gitt "OPPTAKSLEDER" innebærer "OPPTAK_LES"
      Og "OPPTAK_SKRIV" innebærer "OPPTAK_LES"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så innebærer "OPPTAKSLEDER" rollen "OPPTAK_SKRIV"
