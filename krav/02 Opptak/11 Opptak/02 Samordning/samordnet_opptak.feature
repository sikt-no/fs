# language: no
@OPT-OPT-SAM-001 @must @draft
Egenskap: Samordnet opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å invitere læresteder til å delta
  slik at de kan bidra med utdanningstilbud og behandle søknader.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet som samordnet

  Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordnet opptak

    Scenario: Legge til lærested i samordnet opptak
      Når opptaksforvalter ved forvaltende organisasjon legger til organisasjonen "Universitetet i Oslo" som deltaker i opptaket
      Så kan opptaksforvalter ved Universitetet i Oslo knytte egne utdanningstilbud til opptaket
      Og Universitetet i Oslo kan få søknader som de har behandlerrolle for
      Og opptaksforvalter ved Universitetet i Oslo kan vedlikeholde informasjon på egne utdanningstilbud
      Og saksbehandlere og opptaksforvaltere ved Universitetet i Oslo kan se informasjon om egne utdanningstilbud

  Regel: Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket

    Scenario: Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger
      Gitt at HK-dir har opprettet og dermed er forvalter av opptaket "Samordna opptak 2027"
      Når opptaksforvalter ved HK-dir åpner opptaket
      Så kan hen endre innstillinger, frister og regelverk

    Scenario: Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger
      Gitt at organisasjonen "Universitetet i Oslo" er lagt til som deltaker
      Når opptaksforvalter ved Universitetet i Oslo åpner opptaket
      Så kan hen se opptakets innstillinger
      Men hen kan ikke endre frister, regelverk eller andre innstillinger

  Regel: I et lokalt opptak kan ikke andre organisasjoner legges til

    Scenario: Lokalt opptak tillater ikke andre organisasjoner
      Gitt at opptaket "Lokalt opptak høst 2027" er opprettet som lokalt
      Så er det ikke mulig å legge til andre organisasjoner som deltakere

  Regel: Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere

    Scenario: Legge til organisasjon som finnes i utdanningsregisteret
      Når opptaksforvalter ved forvaltende organisasjon legger til organisasjonen "Universitetet i Oslo" som deltaker
      Så legges organisasjonen til fordi den finnes i utdanningsregisteret

    Scenario: Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til
      Gitt at organisasjonen "Ukjent organisasjon" ikke finnes i utdanningsregisteret
      Så kan den ikke legges til som deltaker i opptaket

  Regel: Opptaksforvalter skal kunne filtrere på hvilke lærestedstyper som får delta i opptak

    Scenario: I UHG-opptaket er det bare aktuelt med norske universiteter og høyskoler og i HYU-opptaket er det bare aktuelt med norske fagskoler  

  Regel: Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud

    Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Så kan ikke NTNU knytte utdanningstilbud til opptaket
