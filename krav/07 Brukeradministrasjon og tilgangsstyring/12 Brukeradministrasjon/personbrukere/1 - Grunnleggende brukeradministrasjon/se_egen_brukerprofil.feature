# language: no
# GitHub: #486
# Kilde: Bullet fra #350-body — "Bruker kan se sin egen brukerprofil og tilganger"
@BRU-PER-GRU-008 @draft
Egenskap: Se egen brukerprofil og tilganger
  Som bruker av FS Admin
  ønsker jeg å se min egen brukerprofil og hvilke tilganger og roller jeg har
  slik at jeg vet hva jeg har lov å gjøre og hvem jeg kan kontakte ved endringer.

  Scenario: Bruker åpner egen profil
    Gitt at brukeren er innlogget
    Når brukeren åpner sin egen profil
    Så skal personopplysninger som er registrert om brukeren vises
    Og alle aktive tilganger og roller vises

  Scenario: Bruker ser status og kilde til tilgangene sine
    Gitt at brukeren har tilganger med tidsbegrensning eller stedkoder
    Når brukeren åpner egen profil
    Så skal status, gyldighetstidsrom og stedkoder være synlige per tilgang

# ÅPNE SPØRSMÅL:
# - Skal brukeren kunne se hvem som tildelte hver enkelt tilgang, og når?
# - Skal det være en kontakt-knapp eller "be om endring"-funksjon herfra? (Se BRU-PER-ETT-002.)
# - Skal brukeren kunne se ventende tilgangsforespørsler hen har sendt inn?
# - Skiller "egen profil" seg fra brukeradministrators visning (BRU-PER-GRU-002) — annen layout, færre felt?
# - Skal historikk på egne tilganger være synlig for brukeren selv?
