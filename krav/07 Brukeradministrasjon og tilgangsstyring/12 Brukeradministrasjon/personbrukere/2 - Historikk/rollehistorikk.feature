# language: no
# GitHub: #489
# Kilde: Brukerhistorie BH17 (temp/brukerhistorier.md)
@BRU-PER-HIS-002 @draft
Egenskap: Rollehistorikk - tildelinger over tid
  Som brukeradministrator
  ønsker jeg å se fullstendig rollehistorikk for en gitt rolle eller tilgang
  slik at jeg kan etterprøve hvilke brukere som har hatt rollen, og når.

  Scenario: Vise full historikk for en rolle
    Gitt at en rolle har blitt tildelt og fjernet hos flere brukere over tid
    Når brukeradministrator åpner rollens historikk
    Så skal alle tildelinger og fjerninger vises kronologisk
    Og det skal være tydelig hvilken bruker hver endring gjelder for, og hvem som gjorde endringen

  Scenario: Vise hvilke brukere som hadde rollen på et gitt tidspunkt
    Gitt at brukeradministrator er i rollens historikk
    Når brukeradministrator velger et tidspunkt
    Så skal det settet av brukere som hadde rollen aktiv på det tidspunktet vises

# ÅPNE SPØRSMÅL:
# - Skal rollehistorikk også vise hvilke tilganger rollen besto av på et gitt tidspunkt (rollens egen evolusjon)?
# - Skal historikken være tilgjengelig for både lokale roller og globale/delte roller?
# - Skal det være filtrerbart (per organisasjon, per administrator, per tidsrom)?
# - Eksport-format for revisjon?
# - Hvor lenge skal historikken bevares — er det lovpålagte retensjonskrav?
