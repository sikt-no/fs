# language: no
# GitHub: #454
@BRU-APP-API-017 @could @draft
Egenskap: Masseadministrasjon av roller
  Som bruker
  ønsker jeg å se en liste over roller for å tildele eller fjerne én eller flere roller
  til/fra én eller flere API-brukere.

  # Krav fra Confluence: K17 Masseadministrasjon av roller (Kan ha)

  Scenario: Tildele rolle til flere API-brukere
    Gitt jeg er på oversiktssiden over roller
    Når jeg velger en rolle og tildeler den til flere API-brukere
    Så har alle valgte API-brukere fått rollen

  Scenario: Fjerne rolle fra flere API-brukere
    Gitt jeg er på oversiktssiden over roller
    Når jeg velger en rolle og fjerner den fra flere API-brukere
    Så har ingen av de valgte API-brukerne lenger rollen
