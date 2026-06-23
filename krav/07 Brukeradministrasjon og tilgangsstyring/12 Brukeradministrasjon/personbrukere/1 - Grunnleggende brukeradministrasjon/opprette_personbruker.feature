# language: no
# GitHub: #485
# Kilde: Bullet fra #350-body — "Bruker kan opprettes av brukeradministrator"
@BRU-PER-GRU-007 @draft
Egenskap: Opprette personbruker
  Som brukeradministrator
  ønsker jeg å opprette en ny personbruker i FS Admin
  slik at en ansatt kan logge inn og få tilganger.

  Scenario: Opprette ny personbruker med Feide-identitet
    Gitt at brukeradministrator skal opprette en ny bruker
    Når brukeradministrator angir Feide-ID og nødvendige personopplysninger
    Så skal personbrukeren bli opprettet
    Og brukeren skal kunne logge inn med Feide

  Scenario: Forsøk på å opprette duplikat
    Gitt at en bruker med samme Feide-ID allerede eksisterer
    Når brukeradministrator forsøker å opprette en ny bruker med samme Feide-ID
    Så skal det vises en tydelig melding om at brukeren finnes
    Og det skal gis mulighet til å gå direkte til den eksisterende brukeren

# ÅPNE SPØRSMÅL:
# - Hvilke felt er obligatoriske ved oppretting? (Feide-ID, navn, e-post, organisasjon, stedkode?)
# - Skal personopplysninger hentes fra eksternt register (Folkeregister, HR-system) eller fylles inn manuelt?
# - Hva er forholdet til allerede eksisterende maskinbrukere — kan samme person ha begge?
# - Skal det være automatisk opprettelse via IAM-integrasjon (jf. #350-beskrivelse), og hvordan markeres det i UI-en?
# - Hvilke initielle tilganger settes — ingen, eller en default-rolle som ny ansatt?
# - Hva trigger overgang fra opprettelse → bruksvilkår-godkjenning → første innlogging?
