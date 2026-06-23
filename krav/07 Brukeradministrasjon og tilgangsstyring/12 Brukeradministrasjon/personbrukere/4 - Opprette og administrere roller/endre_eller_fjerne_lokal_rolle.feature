# language: no
# GitHub: #494
# Kilde: Brukerhistorie BH8 (temp/brukerhistorier.md)
@BRU-PER-OAR-002 @draft
Egenskap: Endre eller fjerne egne lokale roller
  Som rolleadministrator
  ønsker jeg å endre eller fjerne lokale roller som min organisasjon har opprettet
  slik at rollene holder seg oppdatert med endringer i ansvarsfordeling.

  Scenario: Endre sammensetningen av en eksisterende rolle
    Gitt at en lokal rolle eksisterer i egen organisasjon
    Når rolleadministrator legger til eller fjerner tilganger eller underliggende roller
    Så skal endringen lagres
    Og endringen skal være sporbar i historikk
    Og endringen skal slå inn for alle som allerede har rollen tildelt

  Scenario: Fjerne en lokal rolle
    Gitt at en lokal rolle eksisterer
    Når rolleadministrator velger å fjerne rollen
    Så skal rolleadministrator se konsekvensene før bekreftelse (se BRU-PER-OAR-003)
    Og rollen fjernes først etter bekreftelse

# ÅPNE SPØRSMÅL:
# - Skal endring av en rolle som er tildelt mange brukere kreve ekstra bekreftelse?
# - Kan en rolle som inngår i andre roller fjernes — eller må sammensetningen brytes opp først?
# - Hva skjer med brukere som har rollen når rollen fjernes — mister alle tilgangene umiddelbart, eller beholdes de som direkte tildelinger?
# - Skal endringer kunne forhåndsvises ("dette vil legge til X tilgang for Y brukere") før de tas i bruk?
# - Hvem regnes som "egne" roller — bare de man har opprettet selv, eller alle i egen organisasjon?
