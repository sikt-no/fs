# language: no
# Jira: SHI-701
@OPT-OPT-UTD-022 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Angi informasjon om studieavgift
  Som opptaksforvalter
  ønsker jeg å angi informasjon om eventuell studieavgift for utdanningstilbudet
  slik at søkeren vet om utdanningstilbudet har studieavgift.

  # AVKLART 2026-10-21: Opptaksforvalter registrerer studieavgiften direkte på utdanningstilbudet,
  # og informasjonen er foreløpig bare om utdanningstilbudet har studieavgift (ja eller nei).
  # Hva søkeren ser i Min kompetanse, står i 13 Søknad og saksbehandling/01 Søknad/se_utdanningstilbud.feature.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Informasjon om studieavgift kan angis på utdanningstilbudet

    Scenario: Registrere informasjon om studieavgift
      Når opptaksforvalter registrerer informasjon om studieavgift
      Så lagres informasjonen om studieavgift på utdanningstilbudet

    Scenario: Se informasjon om studieavgift
      Gitt at utdanningstilbudet har registrert informasjon om studieavgift
      Så vises informasjonen om studieavgift
