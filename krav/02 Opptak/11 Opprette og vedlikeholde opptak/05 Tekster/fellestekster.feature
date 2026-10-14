# language: no
@OPT-OVO-TEK-001 @wont @draft @scope-opprette-opptak-2027
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

    # Endret 2026-10-14: Taket per tildelingsrunde er tatt ut. Hvor mange tilbud søkeren kan få, avgjøres av
    # rundetypen, og hvor mange tilbud søkeren kan takke ja til, settes på opptaket (03 Innstillinger/innstillinger.feature).
    Scenario: Søker ser informasjon om antall tilbud søkeren kan få og takke ja til
      Gitt at opptaket tillater at en søker takker ja til 1 tilbud
      Når søker skal prioritere sine søknadsalternativer
      Så informeres søker om at søkeren bare kan få tilbud på det høyest prioriterte søknadsalternativet søkeren når i hovedtildeling og supplering
      Og søker informeres om at søkeren bare kan takke ja til 1 tilbud

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