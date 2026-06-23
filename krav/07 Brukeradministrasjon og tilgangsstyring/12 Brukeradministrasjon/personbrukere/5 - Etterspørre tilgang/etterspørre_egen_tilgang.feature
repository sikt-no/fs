# language: no
# GitHub: #498
# Kilde: Brukerhistorie BH12 (temp/brukerhistorier.md)
@BRU-PER-ETT-002 @draft
Egenskap: Etterspørre egen tilgang
  Som bruker av FS Admin
  ønsker jeg å kunne etterspørre tilgang til funksjonalitet jeg ikke har
  slik at jeg kan be om det jeg trenger uten å gå utenfor systemet.

  Scenario: Bruker etterspør en spesifikk tilgang
    Gitt at brukeren er innlogget
    Og brukeren mangler en spesifikk tilgang
    Når brukeren etterspør tilgangen med en kort begrunnelse
    Så skal forespørselen registreres
    Og ansvarlig brukeradministrator skal varsles (se BRU-PER-ETT-004)

  Scenario: Bruker oppdager mangel ved bruk
    Gitt at brukeren prøver å nå en funksjon hen ikke har tilgang til
    Når brukeren får feilmeldingen om manglende tilgang
    Så skal det være en mulighet å etterspørre tilgangen direkte derfra

# ÅPNE SPØRSMÅL:
# - Skal brukeren kunne be om en navngitt rolle, eller bare om "tilgang til funksjon X"?
# - Skal begrunnelse være obligatorisk eller valgfri?
# - Hvem er "ansvarlig brukeradministrator" når en bruker etterspør tilgang — leder, organisasjons-admin, eller systemet?
# - Skal det være cooldown / rate limiting for å unngå spam-forespørsler?
# - Skal brukeren kunne se status på egne forespørsler (ventende, godkjent, avslått, med begrunnelse)?
# - Hva er forholdet til BRU-PER-GRU-008 (se egen brukerprofil) — kan forespørsler administreres derfra?
