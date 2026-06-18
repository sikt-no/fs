# language: no
# GitHub: #454
@BRU-APP-API-017 @could @draft
Egenskap: Masseadministrasjon av tilganger
  Som bruker
  ønsker jeg å se en liste over tilganger for å tildele eller fjerne én eller flere tilganger
  til/fra én eller flere applikasjoner.

  # Krav fra Confluence: K17 Masseadministrasjon av roller (Kan ha)

  Scenario: Tildele tilgang til flere applikasjoner
    Gitt jeg er på oversiktssiden over tilganger
    Når jeg velger en tilgang og tildeler den til flere applikasjoner
    Så er tilgangen tildelt alle valgte applikasjoner

  Scenario: Fjerne tilgang fra flere applikasjoner
    Gitt jeg er på oversiktssiden over tilganger
    Når jeg velger en tilgang og fjerner den fra flere applikasjoner
    Så har ingen av de valgte applikasjonene lenger tilgangen
