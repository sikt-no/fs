# language: no
# Jira: SHI-702
@OPT-OPT-UTD-023 @must @draft
Egenskap: Kvalitetssikre studiestart på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å kvalitetssikre og korrigere studiestart for utdanningstilbudet
  slik at søkeren får korrekt informasjon om når studiet starter.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Studiestart kan kvalitetssikres per utdanningstilbud

    Scenario: Se foreslått studiestart for utdanningstilbudet
      Gitt at utdanningstilbudet har en foreslått studiestart
      Så vises den foreslåtte studiestarten

    Scenario: Korrigere studiestart når forslaget er feil
      Gitt at den foreslåtte studiestarten er feil for utdanningstilbudet
      Når opptaksforvalter korrigerer studiestarten
      Så lagres den korrigerte studiestarten på utdanningstilbudet

# ÅPNE SPØRSMÅL:
# - I dag settes "august" for alle høstkull. Hvordan skal korrekt studiestart fastsettes per tilbud?
# - Hvilken presisjon skal studiestart ha (måned, eller konkret dato)?
# - Skal studiestart valideres mot noe (f.eks. semesterets rammer)?
