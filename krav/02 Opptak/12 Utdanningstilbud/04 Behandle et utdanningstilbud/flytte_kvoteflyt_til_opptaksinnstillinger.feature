# language: no
# Jira: SHI-691
@OPT-OPT-UTD-013 @must @draft
Egenskap: Flytte registrering av kvoteflyt til opptaksinnstillinger
  Som opptaksforvalter
  ønsker jeg å registrere kvoteflyt i opptaksinnstillingene i stedet for på det enkelte utdanningstilbudet
  slik at kvoteflyt forvaltes ett sted for hele opptaket.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et opptak

  Regel: Kvoteflyt registreres i opptaksinnstillinger

    Scenario: Registrere kvoteflyt i opptaksinnstillinger
      Når opptaksforvalter registrerer kvoteflyt i opptaksinnstillingene
      Så lagres kvoteflyten på opptaket

  Regel: Kvoteflyt registreres ikke lenger på utdanningstilbudet

    Scenario: Kvoteflyt kan ikke registreres på utdanningstilbudet
      Gitt at opptaksforvalter har åpnet et utdanningstilbud
      Så er det ikke mulig å registrere kvoteflyt på utdanningstilbudet

# ÅPNE SPØRSMÅL:
# - Bør dette kravet ligge i "03 Opptaksinnstillinger" i stedet, siden det flytter funksjonalitet dit? (Plassert her foreløpig fordi det tilhører paraply-saken SHI-686.)
# - Hva omfatter "kvoteflyt" konkret, og hvilke innstillinger inngår?
# - Skal eksisterende kvoteflyt-registreringer på utdanningstilbud migreres til opptaksinnstillinger?
