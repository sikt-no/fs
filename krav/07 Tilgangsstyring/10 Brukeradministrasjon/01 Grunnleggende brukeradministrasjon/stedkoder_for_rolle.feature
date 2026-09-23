# language: no
@TIL-BRU-GRU-005 @must @draft
Egenskap: Stedkoder for rolle
  Som en brukeradministrator
  ønsker jeg å sette hvilke stedkoder en rolle skal gjelde for
  slik at brukerens tilgang begrenses til relevante organisasjonsenheter.

  Bakgrunn:
    Gitt at brukeradministratoren er logget inn i FS Admin
    Og brukeradministratoren har søkt opp en Feide-bruker
    Og brukeren har rollen "Saksbehandler"

  Regel: En rolle kan begrenses til én eller flere stedkoder

    Scenario: Sette stedkode for en rolle
      Når brukeradministratoren setter stedkode "150000" for rollen "Saksbehandler"
      Så gjelder rollen "Saksbehandler" kun for stedkode "150000"

    Scenario: Sette flere stedkoder for en rolle
      Når brukeradministratoren setter stedkodene "150000" og "185000" for rollen "Saksbehandler"
      Så gjelder rollen "Saksbehandler" for stedkodene "150000" og "185000"

# ÅPNE SPØRSMÅL:
# - Skal en rolle uten stedkode bety at den gjelder for alle stedkoder (ubegrenset), eller må minst én stedkode alltid settes?
