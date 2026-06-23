# language: no
# GitHub: #495
# Kilde: Brukerhistorie BH4 (temp/brukerhistorier.md)
@BRU-PER-OAR-003 @draft
Egenskap: Se konsekvens av å fjerne en rolle
  Som brukeradministrator
  ønsker jeg å se konsekvensen av å fjerne en rolle før jeg bekrefter handlingen
  slik at jeg ikke tar bort tilgang fra brukere uten å vite hva som skjer.

  Scenario: Forhåndsvise konsekvens av å fjerne en rolle fra en bruker
    Gitt at brukeradministrator skal fjerne en rolle fra en bruker
    Når brukeradministrator initierer fjerning
    Så skal det vises hvilke konkrete tilganger brukeren vil miste

  Scenario: Forhåndsvise konsekvens av å slette en rolle som er tildelt mange brukere
    Gitt at en rolle er tildelt flere brukere
    Når en rolleadministrator initierer sletting av rollen
    Så skal det vises hvor mange brukere som blir berørt
    Og hvilke tilganger brukerne mister som ikke kommer fra andre roller de fortsatt har

# ÅPNE SPØRSMÅL:
# - Skal forhåndsvisningen vise per bruker, eller bare aggregert?
# - Skal det skilles mellom tilganger som forsvinner helt (eneste kilde) og tilganger som beholdes via andre roller?
# - Forholdet til BRU-PER-OAR-002 — bør konsekvens-visning være obligatorisk del av fjernings-flyten, eller en separat "preview"-handling?
# - Skal det være varsling til berørte brukere når store endringer gjøres?
# - Hvor langt skal beregningen gå når en rolle inngår i andre roller (kjedeeffekt)?
