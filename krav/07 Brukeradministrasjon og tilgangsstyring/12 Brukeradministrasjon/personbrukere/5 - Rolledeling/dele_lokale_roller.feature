# language: no
# GitHub: #502
# Kilde: Brukerhistorie BH9 (temp/brukerhistorier.md)
@BRU-PER-DEL-001 @draft
Egenskap: Dele lokale roller med andre organisasjoner
  Som superrolleadministrator
  ønsker jeg å kunne dele rollene min organisasjon har opprettet med andre organisasjoner
  slik at andre kan dra nytte av rolle-definisjoner vi har laget, uten å måtte oppfinne hjulet på nytt.

  Scenario: Dele en lokal rolle med en spesifikk organisasjon
    Gitt at min organisasjon har en lokal rolle vi vil dele
    Når superrolleadministrator deler rollen med en annen organisasjon
    Så skal mottakerorganisasjonen kunne tildele rollen til sine egne brukere

  Scenario: Dele en rolle åpent med alle organisasjoner
    Gitt at min organisasjon har en lokal rolle vi vil gjøre tilgjengelig bredt
    Når superrolleadministrator markerer rollen som åpent delt
    Så skal alle organisasjoner kunne se og tildele rollen til egne brukere

# ÅPNE SPØRSMÅL:
# - Hva er "superrolleadministrator" — egen rolle, eller en utvidelse av rolleadministrator?
# - Skal mottakerorganisasjonen kunne kopiere og endre rollen lokalt, eller bruke "live" versjon?
# - Hvis kildeorganisasjonen endrer rollen senere, slår endringen automatisk inn hos mottakerorganisasjoner?
# - Skal det være en oppdagbarhets-mekanisme (katalog over delte roller) eller bare via direkte invitasjon?
# - Hvilke tilganger i rollen kan deles — alle, eller bare de som er "globale"? Hva med org-spesifikke tilganger?
# - Skal mottakerorganisasjonen kunne avbryte/avregistrere seg fra en delt rolle?
# - Hvordan håndteres historikk på delte roller (BRU-PER-HIS-002) — vises tildelinger på tvers av organisasjoner?
