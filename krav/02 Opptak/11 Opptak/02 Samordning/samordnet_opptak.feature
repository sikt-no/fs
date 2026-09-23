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
  # Følgevirkninger: Deltagende organisasjoner kan få søknader de har behandlerrolle for etter saksbehandlertildelingen
  # Deltagende organisasjoners opptaksforvaltere kan se og vedlikeholde info på egne utdanningstilbud, og saksbehandlere kan se info om egne utdanningstilbud

  Regel: Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud

    Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud
      Gitt at organisasjonen "NTNU" ikke er lagt til som deltaker i opptaket
      Så kan ikke NTNU knytte utdanningstilbud til opptaket

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

  Regel: Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket

    Scenario: Kun universiteter og høyskoler kan delta i UHG-opptak
      Gitt at opptaket "Samordna opptak 2027" har opptakstype "UHG"
      Når opptaksforvalter ved forvaltende organisasjon legger til deltakere
      Så er kun norske universiteter og høyskoler tilgjengelige

    Scenario: Kun fagskoler kan delta i HYU-opptak
      Gitt at opptaket "Samordna fagskoleopptak 2027" har opptakstype "HYU"
      Når opptaksforvalter ved forvaltende organisasjon legger til deltakere
      Så er kun norske fagskoler tilgjengelige

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Jobbes med av et annet team. Hvilke valgmuligheter finnes for fordeling
  #   av saker til saksbehandlere/saksbehandlerorganisasjoner?
  Regel: Opptaksforvalter ved forvaltende organisasjon knytter regler for saksbehandlertildeling i samordnet opptak

    Scenario: Sette regler for fordeling av søknader til saksbehandlerorganisasjoner
      Når opptaksforvalter ved forvaltende organisasjon knytter saksbehandlertildelingsregler for opptaket
      Så fordeles søknader til deltakende organisasjoner etter de angitte reglene

    Scenario: Saksbehandlertildeling er ikke relevant for lokale opptak
      Gitt at opptaket "Lokalt opptak høst 2027" er opprettet som lokalt
      Så er innstillinger for saksbehandlertildeling ikke tilgjengelige

