# language: no
# GitHub: #454
@BRU-APP-API-017 @could @draft
Egenskap: Masseadministrasjon av roller
  Som bruker
  ønsker jeg å se en liste over roller for å tildele eller fjerne én eller flere roller
  til/fra én eller flere applikasjoner.

  # Krav fra Confluence: K17 Masseadministrasjon av roller (Kan ha)

  Scenario: Tildele rolle til flere applikasjoner
    Gitt jeg er på oversiktssiden over roller
    Når jeg velger en rolle og tildeler den til flere applikasjoner
    Så har alle valgte applikasjoner fått rollen

  Scenario: Fjerne rolle fra flere applikasjoner
    Gitt jeg er på oversiktssiden over roller
    Når jeg velger en rolle og fjerner den fra flere applikasjoner
    Så har ingen av de valgte applikasjonene lenger rollen
