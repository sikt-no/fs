# language: no
@OPT-OPT-TEK-001 @wont @draft
Egenskap: Informasjon til søker i søknadsprosessen
  Som søker
  ønsker jeg relevant informasjon underveis i søknadsprosessen
  slik at jeg forstår hva jeg må gjøre og hva som skjer videre.
  # Informasjonen som vises til søker er ikke redigerbar av opptaksforvalter i brukergrensesnittet.
  # Generisk tekst forvaltes i et felles repo der HK-dir kan foreslå endringer via merge request.
  # Dynamisk informasjon (frister, datoer, tak) utledes fra opptakets innstillinger og frister.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" er opprettet
    Og at søker er innlogget

  Regel: Søker informeres om prioritering av søknadsalternativer

    Scenario: Søker ser informasjon om begrensning på antall tilbud per tildelingsrunde
      Gitt at opptaksforvalter har satt tak for antall tilbud per tildelingsrunde til 1
      Når søker skal prioritere sine søknadsalternativer
      Så informeres søker om at hen kun kan få tilbud på sitt høyest prioriterte alternativ per tildelingsrunde

  Regel: Søker informeres om utdanningsbakgrunn

    Scenario: Søker ser utdanningsbakgrunner som gjelder for opptaket
      Gitt at opptaket har definert utdanningsbakgrunner
      Når søker skal angi sin utdanningsbakgrunn
      Så ser søker de utdanningsbakgrunnene som er satt i opptaket
      Og søker kan velge den utdanningsbakgrunnen som gjelder for seg

  Regel: Søker får kvittering etter innsendt søknad

    # Kvitteringen er en standardmelding som ikke kan redigeres av opptaksforvalter.
    # Den inneholder informasjon utledet fra opptakets frister og innstillinger.

    Scenario: Kvittering viser søknadsinformasjon
      Når søker har sendt inn søknaden
      Så ser søker en kvittering med følgende informasjon
        | Informasjon                                                       |
        | Søknadsnummer                                                     |
        | Status "Innsendt" med dato for innsending                         |
        | Dokumentasjonsfrist                                               |
        | Når søker kan forvente svar på søknaden                           |

    Scenario: Kvittering viser påminnelse om dokumentasjonsfrist
      Gitt at opptaket har ordinær dokumentasjonsfrist "2027-04-15"
      Når søker har sendt inn søknaden
      Så inneholder kvitteringen en påminnelse om at dokumentasjon må lastes opp innen dokumentasjonsfristen

    Scenario: Kvittering viser når søker kan forvente svar
      Gitt at opptaket har satt dato for når søker kan forvente svar til "2027-07-15"
      Når søker har sendt inn søknaden
      Så inneholder kvitteringen informasjon om at søker kan forvente svar fra denne datoen

    Scenario: Kvittering informerer om studieavgift for søkere utenfor EU/EØS
      Gitt at søker har utdanningsbakgrunn utenfor EU/EØS
      Når søker har sendt inn søknaden
      Så inneholder kvitteringen informasjon om studieavgift

    Scenario: Kvittering viser informasjon om flere søknadsalternativer
      Gitt at søker har lagt til flere søknadsalternativer i søknaden
      Når søker har sendt inn søknaden
      Så inneholder kvitteringen informasjon om søkers prioriterte søknadsalternativer