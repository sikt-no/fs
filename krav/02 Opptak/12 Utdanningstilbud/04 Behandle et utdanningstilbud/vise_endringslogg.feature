# language: no
# Jira: SHI-698
@OPT-OPT-UTD-019 @must @draft
Egenskap: Vise endringslogg for utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å se en endringslogg for registreringene som gjøres på utdanningstilbudet
  slik at jeg kan se hva som er endret, av hvem og når.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Endringslogg for utdanningstilbudet kan ses

    Scenario: Se endringslogg for registreringer på utdanningstilbudet
      Gitt at det er gjort registreringer på utdanningstilbudet
      Så vises en endringslogg over registreringene

    Scenario: Endringslogg viser hvem som endret og når
      Gitt at det er gjort en registrering på utdanningstilbudet
      Så viser endringsloggen hvem som gjorde endringen og tidspunktet

# ÅPNE SPØRSMÅL:
# - Hvilke felt og registreringer skal logges?
# - Kravet må raffineres og samkjøres med team-bat, som jobber med endringslogg nå.
