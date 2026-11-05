# language: no
# Jira: SHI-691
@OPT-OPT-UTD-013 @must @implemented
Egenskap: Kvoteflyt registreres ikke på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg at kvoteflyt ikke registreres på det enkelte utdanningstilbudet
  slik at plassflyten forvaltes ett sted, i regelverket.

  # AVKLART 2026-10-22: Kvoteflyt er plassflyten. Den er en del av regelverket, og settes i
  # regelverkssamlingen av regelverksforvalter, ikke i opptaksinnstillingene (avklart av produkteier 2026-10-21).

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et opptak

  @ref-OPT-REG-KVO-003
  Regel: Kvoteflyt registreres ikke lenger på utdanningstilbudet

    Scenario: Kvoteflyt kan ikke registreres på utdanningstilbudet
      Gitt at opptaksforvalter har åpnet et utdanningstilbud
      Så er det ikke mulig å registrere kvoteflyt på utdanningstilbudet
