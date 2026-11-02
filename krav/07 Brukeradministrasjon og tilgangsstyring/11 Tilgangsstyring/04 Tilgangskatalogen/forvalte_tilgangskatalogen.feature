# language: no
@BRU-TIL-KAT-001 @must @planned
Egenskap: Forvalte tilgangskatalogen gjennom API
  Som utvikler hos Sikt
  ønsker jeg å opprette, endre og ta ut av bruk tilganger i tilgangskatalogen gjennom API
  slik at katalogen kan forvaltes som en del av løsningen, og ikke bare direkte i databasen.

  Tilgangskatalogen er listen over tilgangene som finnes: koden hver av dem identifiseres ved,
  og beskrivelsen av hva den gir. Alt annet i tilgangsstyringen peker på den — en tildeling, et
  delegeringstak og et nekt navngir en tilgang fra katalogen — så katalogen er både den mest
  leste og den mest inngripende listen i modellen. En ny tilgang der er ikke i seg selv en
  tilgang noen har fått; den er et begrep resten av modellen kan referere til.

  Katalogen forvaltes i dag av databaseforvaltningen. Denne egenskapen gir den et API med to
  nivåer: utviklere hos Sikt kan opprette, endre og ta en tilgang ut av bruk, mens det finnes en
  egen rettighet for dem som bare skal skrive beskrivelser, jf. BRU-TIL-KAT-002. Skillet er
  hensikten med kravet: dokumentasjonen av en tilgang bør kunne forbedres av dem som kan
  fagområdet, uten at de samtidig kan endre hva tilgangen er.

  # ÅPNE SPØRSMÅL:
  # - Skal implikasjoner mellom tilganger og navnerom for tilganger også forvaltes gjennom
  #   API-et, eller forblir de en beslutning i kildekoden? Denne egenskapen dekker tilgangene
  #   selv, ikke hvordan de henger sammen.
  # - Skal listingen kunne avgrenses per navnerom, eller er hele katalogen alltid ett svar?

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Hele tilgangskatalogen kan listes

    # Behovet som mangler i dag: ingen av inngangene til katalogen viser den i sin helhet. De
    # eksisterende listene er avledet av noe annet — tilgangene en applikasjon har, tilgangene
    # jeg selv har, tilgangene jeg kan tildele — og en tilgang uten en eneste tildeling er
    # dermed usynlig i løsningen, selv om den finnes. Både den som forvalter katalogen og den
    # som dokumenterer den trenger å se den som en liste.

    Scenario: Liste hele katalogen
      Når jeg åpner tilgangskatalogen
      Så ser jeg alle tilgangene som finnes
      Og hvert innslag viser tilgangskoden og beskrivelsen

    Scenario: Tilganger uten tildelinger er med i listen
      Gitt en tilgang finnes i katalogen uten å være tildelt noen
      Når jeg åpner tilgangskatalogen
      Så er tilgangen med i listen

    Scenario: Listen er paginert
      Gitt katalogen har flere tilganger enn det som vises om gangen
      Når jeg åpner tilgangskatalogen
      Så får jeg en avgrenset mengde innslag om gangen
      Og jeg kan hente de neste innslagene

    Scenario: Listen er sortert forutsigbart
      Når jeg åpner tilgangskatalogen
      Så er listen sortert etter tilgangskode i stigende rekkefølge

    Scenario: Listen er lesbar for alle som skal forvalte eller dokumentere katalogen
      Gitt jeg har rettighet til å oppdatere beskrivelser i katalogen
      Når jeg åpner tilgangskatalogen
      Så ser jeg alle tilgangene som finnes

    Scenario: Det fremgår hvilke tilganger som er tatt ut av bruk
      Gitt en tilgang er tatt ut av bruk
      Når jeg åpner tilgangskatalogen
      Så fremgår det at tilgangen ikke lenger skal tas i bruk
      Og jeg kan velge å se bare tilgangene som er i bruk

  Regel: Bare utviklere hos Sikt kan opprette, endre eller ta ut av bruk en tilgang

    Scenario: Utvikler oppretter en ny tilgang
      Gitt jeg har utviklerrettighet for tilgangskatalogen
      Når jeg oppretter en tilgang med en kode og en beskrivelse
      Så finnes tilgangen i katalogen
      Og den kan tildeles på lik linje med de øvrige tilgangene

    Scenario: Utvikler endrer en tilgang
      Gitt jeg har utviklerrettighet for tilgangskatalogen
      Og en tilgang finnes i katalogen
      Når jeg endrer beskrivelsen av tilgangen
      Så er den nye beskrivelsen lagret

    Scenario: Utvikler tar en tilgang ut av bruk
      Gitt jeg har utviklerrettighet for tilgangskatalogen
      Og en tilgang finnes i katalogen
      Når jeg tar tilgangen ut av bruk
      Så fremgår det i katalogen at tilgangen ikke lenger skal tas i bruk
      Og tilgangen er ikke slettet

    Scenario: Uten utviklerrettighet avvises opprettelse
      Gitt jeg ikke har utviklerrettighet for tilgangskatalogen
      Når jeg forsøker å opprette en tilgang
      Så avvises endringen
      Og det fremgår hvilken rettighet som kreves

    Scenario: Uten utviklerrettighet vises ingen handlinger for å endre katalogen
      Gitt jeg ikke har utviklerrettighet for tilgangskatalogen
      Når jeg åpner tilgangskatalogen
      Så ser jeg listen over tilganger
      Men jeg ser ingen handling for å opprette eller ta en tilgang ut av bruk

  Regel: Koden identifiserer tilgangen og settes én gang

    Scenario: Koden kan ikke endres etter opprettelse
      Gitt en tilgang finnes i katalogen
      Når jeg forsøker å endre koden til tilgangen
      Så avvises endringen
      Og det fremgår at koden identifiserer tilgangen og ikke kan endres

    Scenario: Opprettelse avvises når koden allerede er i bruk
      Gitt en tilgang med en gitt kode finnes i katalogen
      Når jeg forsøker å opprette en ny tilgang med den samme koden
      Så avvises opprettelsen
      Og det fremgår at koden allerede er i bruk

    Scenario: En tilgang som er i bruk kan ikke slettes
      Gitt en tilgang er tildelt noen
      Når jeg forsøker å fjerne tilgangen fra katalogen
      Så avvises fjerningen
      Og det fremgår at tilgangen kan tas ut av bruk i stedet

  Regel: Endringer i katalogen er sporbare

    Scenario: Se hvem som opprettet en tilgang
      Gitt en tilgang finnes i katalogen
      Når jeg åpner tilgangen
      Så ser jeg tidspunktet den ble opprettet og hvem som opprettet den

    Scenario: Se siste endring av en tilgang
      Gitt en tilgang i katalogen er endret
      Når jeg åpner tilgangen
      Så ser jeg tidspunktet for siste endring og hvem som gjorde den
