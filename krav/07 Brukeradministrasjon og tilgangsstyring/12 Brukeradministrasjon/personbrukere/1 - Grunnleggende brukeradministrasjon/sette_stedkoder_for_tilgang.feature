# language: no
# GitHub: #483
# Kilde: Brukerhistorie BH10 (temp/brukerhistorier.md)
@BRU-PER-GRU-005 @draft
Egenskap: Sette stedkoder for en tilgang
  Som brukeradministrator
  ønsker jeg å sette hvilke stedkoder en gitt tilgang skal gjelde for
  slik at tilgangen begrenses til de delene av organisasjonen brukeren har ansvar for.

  Scenario: Tildele tilgang med spesifikke stedkoder
    Gitt at brukeradministrator skal tildele en tilgang som støtter stedkode-begrensning
    Når brukeradministrator velger ett eller flere stedkoder for tilgangen
    Så skal tilgangen kun gjelde for de valgte stedkodene

  Scenario: Endre stedkoder på eksisterende tilgang
    Gitt at en bruker har en tilgang med stedkoder
    Når brukeradministrator endrer stedkode-utvalget
    Så skal tilgangens scope oppdateres tilsvarende
    Og endringen skal være sporbar i historikk

# ÅPNE SPØRSMÅL:
# - Gjelder stedkode-begrensning for alle tilgangstyper, eller bare et utvalg? Hvordan vises dette i UI-en?
# - Skal stedkoder kunne settes på rolle-nivå, eller bare på enkelttilganger?
# - Skal hierarkiske stedkoder (overordnet kode dekker underliggende) støttes?
# - Hva er kilden til lovlige stedkode-verdier — fra hvilken organisasjon eller register?
# - Skal en administrator kunne sette stedkoder utenfor egen organisasjon, eller bare innenfor?
