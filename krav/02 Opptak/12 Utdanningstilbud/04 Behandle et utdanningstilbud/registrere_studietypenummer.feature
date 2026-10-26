# language: no
# Jira: SHI-689
@OPT-OPT-UTD-011 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Registrere studietypenummer på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å påføre utdanningstilbudet et studietypenummer
  slik at utdanningstilbudet kan identifiseres entydig.

  # AVKLART 2026-10-22: «Studienummer» i Jira (SHI-689) er studietypenummeret, som velges fra kodeverket for studietype.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Studietypenummer kan påføres utdanningstilbudet

    Scenario: Registrere studietypenummer på utdanningstilbud
      Når opptaksforvalter velger et studietypenummer for utdanningstilbudet
      Så lagres studietypenummeret på utdanningstilbudet

    Scenario: Se studietypenummer på utdanningstilbud
      Gitt at utdanningstilbudet har et registrert studietypenummer
      Så vises studietypenummeret på utdanningstilbudet
