# language: no
# GitHub: #479
# Kilde: Brukerhistorie BHGB2 (temp/brukerhistorier.md)
@BRU-PER-GRU-001 @draft
Egenskap: Søke opp en bruker for administrasjon
  Som brukeradministrator
  ønsker jeg å søke opp en bruker
  slik at jeg kan administrere brukerens tilganger og roller.

  Scenario: Søke opp bruker via Feide-ID
    Gitt at brukeradministrator er på brukeroversikten
    Når brukeradministrator søker på en eksisterende Feide-ID
    Så skal den aktuelle brukeren vises i søkeresultatet

  Scenario: Søke opp bruker via navn
    Gitt at brukeradministrator er på brukeroversikten
    Når brukeradministrator søker på brukerens navn
    Så skal matchende brukere vises i søkeresultatet

  Scenario: Ingen treff på søk
    Gitt at brukeradministrator er på brukeroversikten
    Når brukeradministrator søker på en verdi som ikke finnes
    Så skal det vises en tydelig melding om at ingen brukere matcher

# ÅPNE SPØRSMÅL:
# - Hvilke felt skal være søkbare? (Feide-ID, e-post, navn, organisasjon, ansattnummer?)
# - Skal brukeradministrator kun se brukere ved egen organisasjon, eller kan administrator på Sikt søke på tvers?
# - Skal det være partial match / fuzzy search, eller eksakt match?
# - Hvordan håndteres deaktiverte brukere — vises de i søk, og hvordan markeres de?
# - Paginering eller maks antall resultater?
