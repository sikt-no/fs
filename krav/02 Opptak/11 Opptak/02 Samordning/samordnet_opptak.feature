# language: no
@OPT-OPT-SAM-001 @must @draft
Egenskap: Samordnet opptak
  Som opptaksforvalter for et samordnet opptak
  ønsker jeg å invitere læresteder til å delta
  slik at de kan bidra med utdanningstilbud og saksbehandlere.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet som samordnet

  Regel: Opptaksforvalter kan legge til organisasjoner i et samordnet opptak

    Scenario: Legge til lærested i samordnet opptak
      Når jeg legger til organisasjonen "Universitetet i Oslo" som deltaker i opptaket
      Så kan Universitetet i Oslo knytte egne utdanningstilbud til opptaket
      Og Universitetet i Oslo kan tildele egne saksbehandlere til søknadsbehandling
      Og Universitetet i Oslo kan se og følge opp søknader til egne utdanningstilbud

  Regel: Deltakende organisasjoner kan ikke endre opptakets fellesinnstillinger

    Scenario: Deltakende organisasjon kan se men ikke endre innstillinger
      Gitt at organisasjonen "Universitetet i Oslo" er lagt til som deltaker
      Når en opptaksforvalter ved Universitetet i Oslo åpner opptaket
      Så kan hen se opptakets fellesinnstillinger
      Men hen kan ikke endre frister, regelverk eller søkergrupper

  Regel: I et lokalt opptak kan ikke andre organisasjoner legges til

    Scenario: Lokalt opptak tillater ikke andre organisasjoner
      Gitt at opptaket "Lokalt opptak høst 2027" er opprettet som lokalt
      Så er det ikke mulig å legge til andre organisasjoner som deltakere

  Regel: Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud

    Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Så kan ikke NTNU knytte utdanningstilbud til opptaket
