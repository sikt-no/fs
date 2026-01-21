# language: no
@TIL-BRU-BRU-001 @skip @personopplysninger
Egenskap: Opprettelse av personbruker

  Bakgrunn: Når en bruker logger inn i Min kompetanse for første gang må det opprettes en bruker
    Gitt Brukeren logger inn Min kompetanse for første gang

  Scenario: Opprette personbruker som har norsk fødsels -og/eller D-nummer
    Når brukeren har norsk fødselsnummer eller D-nummer
    Og brukeren ikke tidligere har vært innlogget i Min kompetanse
    Så opprettes bruker automatisk med person og kontaktinformasjon
    Så skal brukeren se sine opplysninger på profilsiden

  Scenariomal: Administrator oppretter søknad for person uten norsk fnr/dnr og må legge inn grunnleggende opplysninger for person
    Gitt at administrator legger inn "<personopplysninger>" for person uten fnr/dnr
    Når saksbehandler legger inn "<navn>"
    Når saksbehandler legger inn "<fødselsdato>"
    Når saksbehandler legger inn "<kjønn>"
    Når saksbehandler legger inn "<statsborgerskap>"
    Når saksbehandler legger inn "<e-post>"
    Når saksbehandler legger inn "<telefonnummer>"
    Når saksbehandler legger inn "<kontaktadresse>"
    Så blir registrert person tilgjengelig i Min kompetanse

    Eksempler:
      | navn | fødselsdato | kjønn | statsborgerskap | e-post | telefonnummer | kontaktadresse |
