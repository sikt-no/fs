# language: no
# GitHub: #481
# Kilde: Brukerhistorie BH1 (temp/brukerhistorier.md)
@BRU-PER-GRU-003 @draft
Egenskap: Tildele og fjerne tilganger og roller hos en Feide-bruker
  Som brukeradministrator
  ønsker jeg å tildele og fjerne tilganger og roller hos en Feide-bruker
  slik at brukeren har det riktige settet av tilganger til enhver tid.

  Scenario: Tildele en ny rolle til en bruker
    Gitt at brukeradministrator er på brukerens detaljside
    Når brukeradministrator velger å tildele en rolle
    Så skal rollen legges til brukerens tildelinger
    Og endringen skal være sporbar i historikk

  Scenario: Fjerne en eksisterende tilgang fra en bruker
    Gitt at en bruker har en aktiv tilgang
    Når brukeradministrator velger å fjerne tilgangen
    Så skal tilgangen fjernes fra brukeren
    Og endringen skal være sporbar i historikk

# ÅPNE SPØRSMÅL:
# - Hvilke begrensninger gjelder for hvem som kan tildele hva? (egen organisasjon, rolle-hierarki, delegering)
# - Skal det være en bekreftelsesdialog ved fjerning, særlig for kritiske tilganger?
# - Hva skjer med data brukeren har opprettet hvis tilgangen fjernes? (eierskap, sletting, anonymisering)
# - Skal det gå varsel til brukeren når tilganger endres? Se BRU-PER-HIS-003.
# - Kan flere tilganger tildeles/fjernes i én batch-operasjon?
# - Hvilke valideringer kreves før tildeling går igjennom? (taushetserklæring, organisasjonstilhørighet)
