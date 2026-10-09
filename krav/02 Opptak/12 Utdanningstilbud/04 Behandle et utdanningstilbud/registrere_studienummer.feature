# language: no
# Jira: SHI-689
@OPT-OPT-UTD-011 @must @draft
Egenskap: Registrere studienummer på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å påføre utdanningstilbudet et studienummer
  slik at utdanningstilbudet kan identifiseres entydig.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Studienummer kan påføres utdanningstilbudet

    Scenario: Registrere studienummer på utdanningstilbud
      Når opptaksforvalter registrerer et studienummer på utdanningstilbudet
      Så lagres studienummeret på utdanningstilbudet

    Scenario: Se studienummer på utdanningstilbud
      Gitt at utdanningstilbudet har et registrert studienummer
      Så vises studienummeret på utdanningstilbudet

# ÅPNE SPØRSMÅL:
# - Hva er "studienummer", og hvor kommer det fra? Begrepet er ikke en kjent størrelse i opptak eller utdanningsregisteret i dag (trenger raffinering).
# - Registreres studienummeret manuelt, eller hentes/utledes det fra en kilde?
# - Har studienummeret et bestemt format eller valideringsregler?
