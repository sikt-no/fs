# language: no
@BRU-TIL-KAT-002 @must @planned
Egenskap: Oppdatere beskrivelsen av en tilgang
  Som bidragsyter til dokumentasjonen av tilgangskatalogen
  ønsker jeg å oppdatere beskrivelsen av en tilgang
  slik at det står forklart hva tilgangen faktisk gir, uten at jeg kan endre hva tilgangen er.

  Beskrivelsen er det eneste i katalogen som er ren dokumentasjon. Koden identifiserer tilgangen,
  og alt annet i tilgangsstyringen peker på den; beskrivelsen forklarer den. Derfor er det den
  ene delen av katalogen som kan forvaltes av flere enn dem som forvalter selve modellen — den
  som kan fagområdet skal kunne forbedre forklaringen uten å kunne røre begrepet.

  Rettigheten gir derfor tilgang til ett felt, ikke til katalogen. Avgrensningen er et krav til
  håndhevingen, ikke bare til hvordan flaten ser ut: et forsøk på å endre noe annet skal avvises
  uansett hvilken vei det kommer inn, også når det følger med i den samme forespørselen som en
  gyldig beskrivelsesendring.

  Å endre en beskrivelse endrer ingenting for dem som har tilgangen. Det er nettopp derfor
  rettigheten kan være videre enn utviklerrettigheten i BRU-TIL-KAT-001.

  # ÅPNE SPØRSMÅL:
  # - Skal rettigheten kunne avgrenses til et fagområde eller et navnerom, eller gjelder den
  #   hele katalogen?
  # - Skal en beskrivelsesendring kunne foreslås av flere og godkjennes av noen, eller er
  #   rettigheten i seg selv godkjenningen?

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har rettighet til å oppdatere beskrivelser i tilgangskatalogen

  Regel: Rettigheten gir rett til å oppdatere beskrivelsen

    Scenario: Oppdatere beskrivelsen av en tilgang
      Gitt en tilgang finnes i katalogen
      Når jeg oppdaterer beskrivelsen av tilgangen
      Så er den nye beskrivelsen lagret
      Og den vises der tilgangen er nevnt

    Scenario: Beskrivelsen kan tømmes
      Gitt en tilgang har en beskrivelse
      Når jeg fjerner beskrivelsen
      Så står tilgangen uten beskrivelse
      Og tilgangen finnes fortsatt i katalogen

    Scenario: Finne tilgangen som skal dokumenteres
      Gitt katalogen har tilganger uten beskrivelse
      Når jeg åpner tilgangskatalogen
      Så ser jeg alle tilgangene som finnes, også de uten tildelinger
      Og jeg kan se hvilke som mangler beskrivelse

    Scenario: Endringen er sporbar
      Gitt jeg har oppdatert beskrivelsen av en tilgang
      Når jeg åpner tilgangen
      Så ser jeg tidspunktet for endringen og hvem som gjorde den

  Regel: Rettigheten gir ikke rett til noe annet enn beskrivelsen

    # Avgrensningen er et håndhevingskrav. Den skal ligge i API-et og i datalaget, ikke bare i
    # hvilke felter en flate viser: en klient som sender inn mer enn en beskrivelse skal få det
    # avvist, uansett hvilken inngang den bruker.

    Scenario: Forsøk på å endre tilgangskoden avvises
      Gitt en tilgang finnes i katalogen
      Når jeg forsøker å endre koden til tilgangen
      Så avvises endringen
      Og det fremgår at rettigheten bare omfatter beskrivelsen

    Scenario: Forsøk på å opprette en tilgang avvises
      Når jeg forsøker å opprette en ny tilgang i katalogen
      Så avvises opprettelsen
      Og det fremgår at rettigheten bare omfatter beskrivelsen

    Scenario: Forsøk på å ta en tilgang ut av bruk avvises
      Gitt en tilgang finnes i katalogen
      Når jeg forsøker å ta tilgangen ut av bruk
      Så avvises endringen

    Scenario: Forsøk på å endre hvilke tilganger en tilgang omfatter avvises
      Gitt en tilgang omfatter andre tilganger
      Når jeg forsøker å endre hvilke tilganger den omfatter
      Så avvises endringen

    Scenario: Forsøk på å endre hvilket navnerom en tilgang hører til avvises
      Gitt en tilgang hører til et navnerom
      Når jeg forsøker å flytte tilgangen til et annet navnerom
      Så avvises endringen

    Scenario: Forsøk på å tildele eller fjerne en tilgang avvises
      Gitt en tilgang finnes i katalogen
      Når jeg forsøker å tildele tilgangen til noen
      Så avvises tildelingen
      Og det fremgår at rettigheten ikke omfatter tildeling

    Scenario: En forespørsel som endrer mer enn beskrivelsen avvises i sin helhet
      Gitt en tilgang finnes i katalogen
      Når jeg sender inn en endring som både oppdaterer beskrivelsen og noe annet
      Så avvises hele endringen
      Og beskrivelsen er uendret

    Scenario: Avgrensningen gjelder uansett inngang
      Gitt jeg bruker API-et direkte i stedet for en flate
      Når jeg forsøker å endre noe annet enn beskrivelsen
      Så avvises endringen på samme måte

  Regel: En beskrivelsesendring påvirker ingen tilganger

    Scenario: Tildelinger er uendret etter en beskrivelsesendring
      Gitt en tilgang er tildelt flere applikasjoner og brukere
      Når jeg oppdaterer beskrivelsen av tilgangen
      Så har de samme applikasjonene og brukerne den samme tilgangen som før

    Scenario: Ingen mister eller får tilgang til data
      Gitt en bruker arbeider med en tilgang
      Når beskrivelsen av tilgangen oppdateres
      Så er det brukeren kan gjøre uendret

    Scenario: Andre deler av tilgangsmodellen er uberørt
      Gitt en tilgang er nevnt i et delegeringstak og i et nekt
      Når jeg oppdaterer beskrivelsen av tilgangen
      Så er både delegeringstaket og nektet uendret
