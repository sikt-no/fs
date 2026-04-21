# language: no
@BRU-APP-API-006 @must @planned
Egenskap: Redigere beskrivelse for API-bruker
  Som bruker
  ønsker jeg å redigere beskrivelsen for en API-bruker
  slik at informasjonen er oppdatert og korrekt.

  # Krav fra Confluence: K19 Redigere beskrivelse for API-bruker

  Scenario: Oppdatere beskrivelse
    Gitt jeg ser detaljer for en API-bruker
    Når jeg oppdaterer beskrivelsen
    Så er den nye beskrivelsen lagret på API-brukeren
