# language: no
@FEL-TIL-GRU-001 @must @draft
Egenskap: 10 Felleskrav: Ingen tilgang uten en regel
  Som Sikt ønsker vi at data bare er tilgjengelige når et krav sier hvem som får se eller endre dem,
  slik at ingen får tilgang ved en feil, og tilgangen kan holdes lukket når det er usikkert.

  Kravene sier hvem som får gjøre hva. Den som ikke er nevnt, får ikke. Kravene trenger derfor
  ikke liste opp alle som ikke får lov, bare dem der grensen er uventet (se Tags → Roller i krav/README.md).

  Regel: Den som ikke er nevnt i en regel, får ikke se eller endre dataene

    Scenario: En brukerrolle som ikke er nevnt i regelen, ser ikke saken
      Gitt regelen for saken sier at saksbehandler hos behandleren ser saken
      Og regelen sier ingenting om dokumentforvalter
      Når jeg er dokumentforvalter hos behandleren og åpner sakslista
      Så ser jeg ikke saken

    Scenario: En organisasjon som ikke er nevnt i regelen, ser ikke søknaden
      Gitt regelen for søknaden sier at forvalteren, tilbyderen og behandleren ser søknaden
      Når jeg er saksbehandler hos en organisasjon uten rolle i opptaket og søker etter søkeren
      Så finner jeg ikke søkeren

    Scenario: En regel som gir lesing, gir ikke endring
      Gitt regelen for saken sier at opptaksinformatør hos behandleren ser saken
      Når jeg er opptaksinformatør hos behandleren og åpner saken
      Så ser jeg saken
      Men jeg ser ikke muligheten til å endre den

  Regel: API-et gir aldri mer enn FS Admin
    # Avklart 2026-11-10 (svar 19 i avklaringsmøtet om tilgangsregler i opptak).

    Scenario: En integrasjon får det samme som en ansatt med de samme rollene ved samme organisasjon
      Gitt Politihøgskolens opptakssystem har rollen saksbehandler ved Politihøgskolen
      Når opptakssystemet henter søkere gjennom API-et
      Så får det søkerne til Politihøgskolen
      Men ikke søkere som bare har søkt utdanningstilbud ved andre organisasjoner

    Scenario: API-et avviser en endring regelen ikke gir
      Gitt en integrasjon har rollen opptaksinformatør ved behandleren
      Når integrasjonen forsøker å endre en sak gjennom API-et
      Så avvises det
