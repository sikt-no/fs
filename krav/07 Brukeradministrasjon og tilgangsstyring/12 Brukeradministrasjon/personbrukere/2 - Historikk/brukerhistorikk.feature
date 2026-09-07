# language: no
# GitHub: #488
# Kilde: Brukerhistorie BH16 (temp/brukerhistorier.md)
@BRU-PER-HIS-001 @draft
Egenskap: Brukerhistorikk - tilganger over tid
  Som brukeradministrator
  ønsker jeg å se fullstendig brukerhistorikk for en gitt Feide-bruker
  slik at jeg kan etterprøve hvilke tilganger og roller brukeren har hatt, og når.

  Scenario: Vise full historikk for en bruker
    Gitt at en bruker har hatt flere tilganger og roller over tid
    Når brukeradministrator åpner brukerens historikk
    Så skal alle tildelinger og fjerninger vises kronologisk
    Og det skal være tydelig når hver endring skjedde og hvem som gjorde den

  Scenario: Vise hvilke tilganger som var aktive på et gitt tidspunkt
    Gitt at brukeradministrator er i brukerens historikk
    Når brukeradministrator velger et tidspunkt
    Så skal det settet av tilganger og roller som var aktive på det tidspunktet vises

# ÅPNE SPØRSMÅL:
# - Hvor langt tilbake skal historikken gå — alt fra opprettelsen, eller en grense?
# - Skal historikken inkludere stedkode-endringer og tidsbegrensning-endringer, eller bare tildeling/fjerning?
# - Skal historikken være filtrerbar (per organisasjon, per rolle, per administrator)?
# - Skal det være eksport-mulighet for revisjonsformål? Format?
# - Skiller "automatisk endring" (f.eks. utløp) seg visuelt fra "manuell endring"?
# - Personvern: hvem kan se historikk om hvem? Skal endringer i taushetserklæring vises her?
