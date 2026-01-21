# language: no

@FOR-ADM-UTD-002
Egenskap: Endre eksisterende utdanning
Som administrator ved lærested som tilbyr utdanning i Norge trenger jeg å endre og tilgjengeliggjøre endringer av utdanning med informasjon som gjør at både vi og andre aktører i utdannings-Norge vet utdanningen vi tilbyr er endret.

  Scenariomal: Administrator endrer på akkredittert utdanning
    Gitt bla bla
    Når administrator "<endrer på utdanning>"
    Så oppdateres opplysninger om utdanning
    Så lagres endringen i historikk

    Eksempler:
    |endrer på utdanning|
    |endre navn|
    |endre kode|
    |endre læringsutbytte|

    Scenario: Legge ned utdanning
      Gitt bla bla
      Når administrator legger ned utdanning
      Så endrer utdanningen status fra aktiv til utløpt
      Så lagres endringen i historikk
