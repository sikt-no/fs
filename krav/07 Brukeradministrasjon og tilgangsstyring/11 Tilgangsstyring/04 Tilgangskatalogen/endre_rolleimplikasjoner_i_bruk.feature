# language: no
# GitHub: #563
# Implementert i fs-plattform !6135 (utkast, ikke merget).
@BRU-TIL-KAT-005 @must @draft
Egenskap: Endre implikasjoner mellom roller som er i bruk
  Som forvalter av rollekatalogen
  ønsker jeg å vite at en endret implikasjon virker inn overalt rollene er i bruk
  slik at jeg forstår hvem endringen rammer før jeg gjør den.

  En tildeling og et delegeringstak nevner en rolle, ikke det rollen innebærer på det tidspunktet de
  ble opprettet. Endres implikasjonene til rollen, endres derfor også hva tildelingen gir og hvor
  langt delegeringstaket rekker. Det er tilsiktet. En implikasjon avvises ikke fordi den utvider et
  delegeringstak som finnes. Konsekvensen er at den som endrer en implikasjon, må vite at endringen
  virker inn i alle tildelinger og delegeringstak som nevner rollene, og det skal gå fram av
  operasjonene.

  Hvem som kan endre implikasjoner, står i BRU-TIL-KAT-003.

  # ÅPNE SPØRSMÅL:
  # - Skal forvalteren kunne se hvilke tildelinger og delegeringstak en endring rammer, før
  #   endringen gjøres?

  Bakgrunn:
    Gitt forvalteren er innlogget i løsningen
    Og forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene rollene ligger i

  Regel: En endret implikasjon gjelder for alle som allerede har rollen

    Scenario: En ny implikasjon gir den impliserte rollen til alle som har rollen
      Gitt en personbruker har fått tildelt rollen "OPPTAKSLEDER"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så har personbrukeren rollen "OPPTAK_SKRIV" gjennom tildelingen av "OPPTAKSLEDER"
      Og tildelingen av "OPPTAKSLEDER" er uendret

    Scenario: En fjernet implikasjon tar den impliserte rollen fra dem som bare hadde den gjennom implikasjonen
      Gitt en personbruker har fått tildelt rollen "OPPTAKSLEDER"
      Og "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så har personbrukeren ikke lenger rollen "OPPTAK_SKRIV"

    Scenario: En fjernet implikasjon tar ikke en rolle som også er tildelt på annen måte
      Gitt en personbruker har fått tildelt rollene "OPPTAKSLEDER" og "OPPTAK_SKRIV"
      Og "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så har personbrukeren fortsatt rollen "OPPTAK_SKRIV"

  Regel: Et delegeringstak følger implikasjonene til rollene taket nevner

    Scenario: En ny implikasjon utvider delegeringstaket
      Gitt en organisasjon har et delegeringstak som nevner rollen "OPPTAKSLEDER"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så rekker delegeringstaket også til rollen "OPPTAK_SKRIV"

    Scenario: En implikasjon avvises ikke fordi den utvider et delegeringstak
      Gitt en organisasjon har et delegeringstak som nevner rollen "OPPTAKSLEDER"
      Og delegeringstaket rekker ikke til rollen "OPPTAK_SKRIV"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så er forespørselen vellykket

    Scenario: En fjernet implikasjon snevrer inn delegeringstaket
      Gitt en organisasjon har et delegeringstak som nevner rollen "OPPTAKSLEDER"
      Og "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så rekker delegeringstaket ikke lenger til rollen "OPPTAK_SKRIV"

  Regel: Et nekt følger implikasjonene til rollen som er nektet

    Scenario: Et nekt på en implisert rolle tar også rollen som innebærer den
      Gitt en personbruker har fått tildelt rollen "OPPTAKSLEDER"
      Og personbrukeren har et nekt på rollen "OPPTAK_SKRIV"
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så tar nektet på "OPPTAK_SKRIV" også rollen "OPPTAKSLEDER" fra personbrukeren

  Regel: Det går fram av operasjonene hvor en endret implikasjon virker

    Scenario: Operasjonen for å legge til en implikasjon beskriver virkningen
      Når forvalteren leser beskrivelsen av operasjonen for å legge til implikasjoner
      Så går det fram at implikasjonen virker i alle tildelinger og delegeringstak som nevner rollen den går ut fra

    Scenario: Operasjonen for å fjerne en implikasjon beskriver virkningen
      Når forvalteren leser beskrivelsen av operasjonen for å fjerne implikasjoner
      Så går det fram at fjerningen virker i alle tildelinger og delegeringstak som nevner rollen den går ut fra
