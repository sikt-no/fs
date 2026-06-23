# language: no
# GitHub: #484
# Kilde: Brukerhistorie BH15 (temp/brukerhistorier.md)
@BRU-PER-GRU-006 @draft
Egenskap: Sette start- og sluttidspunkt for tilganger
  Som brukeradministrator
  ønsker jeg å sette valgfritt start- og/eller sluttidspunkt for én enkelt tilgang, eller for det totale settet av tilganger hos en bruker
  slik at tilgangen er tidsbegrenset uten manuell oppfølging.

  Scenario: Sette sluttidspunkt på én enkelt tilgang
    Gitt at brukeradministrator skal tildele en tilgang
    Når brukeradministrator setter et sluttidspunkt
    Så skal tilgangen være aktiv frem til det tidspunktet
    Og tilgangen skal automatisk bli inaktiv etter tidspunktet

  Scenario: Sette starttidspunkt fram i tid
    Gitt at brukeradministrator skal tildele en tilgang
    Når brukeradministrator setter et starttidspunkt fram i tid
    Så skal tilgangen være inaktiv frem til starttidspunktet
    Og bli automatisk aktiv på starttidspunktet

  Scenario: Sette sluttidspunkt på alle brukerens tilganger samtidig
    Gitt at en bruker har flere aktive tilganger og roller
    Når brukeradministrator setter et felles sluttidspunkt for hele brukerens tilgangssett
    Så skal alle tilgangene automatisk bli inaktive på det tidspunktet

# ÅPNE SPØRSMÅL:
# - Granularitet på tidspunkt — dato, dato+tidspunkt, time?
# - Tidssone — alltid Europe/Oslo, eller noe annet?
# - Hva skjer hvis sluttidspunkt settes i fortiden? Avvis, eller deaktiver umiddelbart?
# - Hvordan varsles brukeren før utløp? (Se også varsling-temaet i BRU-PER-HIS-003.)
# - Kan tidsbegrensning settes på rolle-nivå, eller bare på tilgang og bruker samlet?
# - Forholdet mellom "tidsbegrensning utløpt" og "manuelt deaktivert" — vises de likt i historikk?
