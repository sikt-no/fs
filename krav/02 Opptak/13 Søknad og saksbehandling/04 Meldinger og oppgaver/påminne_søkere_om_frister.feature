# language: no
@OPT-SØK-MEL-002 @must @draft @scope-meldinger-varslinger-og-oppgaver
Egenskap: Påminne søkere om frister
  Som opptaksforvalter ved organisasjonen som forvalter opptaket
  ønsker jeg at søkere som ikke har gjort det de skal, får påminnelse før fristen
  slik at flest mulig rekker fristen, og søkerne har hatt det som trengs for å gjøre alt riktig.

  Påminnelsene sendes av løsningen, etter innstillingene opptaksforvalteren har gjort. Som
  forvaltningsorgan har lærestedet ansvar for at søkerne har forutsetningene for å gjøre alt
  riktig med søknaden, og det er viktig i klagebehandlingen.

  # Kilde: workshop om meldinger 2026-11-09 (Miro), K1-2, K1-3, K8 og svar 5.

  Regel: Søkeren får påminnelse om en påbegynt søknad som ikke er levert

    Scenario: Søkeren med påbegynt søknad får påminnelse
      Gitt at søkeren har en påbegynt søknad som ikke er levert
      Når løsningen sender påminnelser om påbegynte søknader
      Så får søkeren påminnelse om at søknaden ikke er levert
      Og påminnelsen sier hva søkeren må gjøre, og når søknadsfristen går ut

    Scenario: Søkeren med levert søknad får ikke påminnelse
      Gitt at søkeren har levert søknaden
      Når løsningen sender påminnelser om påbegynte søknader
      Så får ikke søkeren påminnelse om påbegynt søknad

  Regel: Søkeren får påminnelse om dokumentasjonsfristen når søknaden har mangler

    Scenario: Søkeren som ikke har dokumentert mangelen, får påminnelse
      Gitt at søkerens søknad har mangler
      Og at søkeren ikke har lastet opp dokumentasjon
      Og at søkeren ikke har elektronisk vitnemål
      Og at søkeren ikke har oppgitt at søkeren får vitnemål i år
      Når løsningen sender påminnelser om dokumentasjonsfristen
      Så får søkeren påminnelse om dokumentasjonsfristen
      Og påminnelsen sier hva søkeren må gjøre, og når dokumentasjonsfristen går ut

    Scenariomal: Søkeren som <har gjort>, får ikke påminnelse
      Gitt at søkerens søknad har mangler
      Og at søkeren <har gjort>
      Når løsningen sender påminnelser om dokumentasjonsfristen
      Så får ikke søkeren påminnelse om dokumentasjonsfristen

      Eksempler:
        | har gjort                                |
        | har lastet opp dokumentasjon             |
        | har elektronisk vitnemål                 |
        | har oppgitt at søkeren får vitnemål i år |

    Scenario: Søkeren uten mangler får ikke påminnelse
      Gitt at søkerens søknad ikke har mangler
      Når løsningen sender påminnelser om dokumentasjonsfristen
      Så får ikke søkeren påminnelse om dokumentasjonsfristen

  Regel: Opptaksforvalteren bestemmer hvor ofte påminnelsene sendes, og når den siste sendes
    # Det er ikke satt et fast antall dager (svar 5).

    Scenariomal: Opptaksforvalteren setter opp påminnelser om <påminnelse>
      Når opptaksforvalteren setter opp påminnelser om <påminnelse>
      Så kan opptaksforvalteren velge hvor ofte påminnelsene sendes
      Og opptaksforvalteren kan velge når den siste påminnelsen før fristen sendes

      Eksempler:
        | påminnelse            |
        | påbegynte søknader    |
        | dokumentasjonsfristen |

  @openquestion
  Regel: Søkeren får påminnelse om en frist bare én gang
    # ÅPNE SPØRSMÅL:
    # - Kan det bli flere påminnelser om samme frist, avhengig av typen påminnelse,
    #   eller hvis det viser seg at påminnelsene bør gå oftere enn i dag?

    Scenario: Søkeren som har fått påminnelse om en frist, får den ikke på nytt
      Gitt at søkeren har fått påminnelse om dokumentasjonsfristen
      Når løsningen sender påminnelser om dokumentasjonsfristen
      Så får ikke søkeren en ny påminnelse om dokumentasjonsfristen

  Regel: Opptaksforvalteren ser hvilke søkere som har fått påminnelse

    Scenario: Opptaksforvalteren ser søkerne som har fått en påminnelse
      Gitt at løsningen har sendt påminnelse om påbegynt søknad til to søkere
      Når opptaksforvalteren ser på påminnelsene som er sendt
      Så ser opptaksforvalteren begge søkerne som har fått påminnelsen

    Scenario: Opptaksforvalteren ser påminnelsen på søknaden
      Gitt at søkeren har fått påminnelse om dokumentasjonsfristen
      Når opptaksforvalteren åpner søkerens søknad
      Så ser opptaksforvalteren at søkeren har fått påminnelsen, og når den ble sendt
