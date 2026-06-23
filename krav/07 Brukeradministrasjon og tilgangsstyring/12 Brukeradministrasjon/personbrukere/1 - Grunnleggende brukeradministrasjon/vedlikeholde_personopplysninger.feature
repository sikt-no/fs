# language: no
# GitHub: #487
# Kilde: Bullet fra #350-body — "Brukers nødvendige personopplysninger kan vedlikeholdes"
@BRU-PER-GRU-009 @draft
Egenskap: Vedlikeholde personopplysninger for bruker
  Som brukeradministrator
  ønsker jeg å kunne oppdatere nødvendige personopplysninger om en bruker
  slik at brukerregisteret er korrekt og brukbart for kommunikasjon og tilgangsstyring.

  Scenario: Oppdatere kontaktopplysninger
    Gitt at brukeradministrator er på en brukers detaljside
    Når brukeradministrator endrer kontakt-feltet (f.eks. e-post eller telefonnummer)
    Så skal endringen lagres
    Og endringen skal være sporbar i historikk

# ÅPNE SPØRSMÅL:
# - Hvilke felt regnes som "nødvendige personopplysninger" — minimumsliste vs. utvidet liste?
# - Hva kan brukeren selv vedlikeholde vs. hva er forbeholdt brukeradministrator?
# - Skal noen felt være read-only fordi de hentes fra autoritative kilder (Feide, Folkeregister, HR)?
# - Hvordan håndteres synkronisering hvis verdier endres i begge ender (i FS Admin og i kildesystemet)?
# - Forholdet til eksisterende personopplysningsfeatures i `05 Opplysninger om person/`?
# - Er det validering på enkelte felt (e-postformat, telefonformat)?
