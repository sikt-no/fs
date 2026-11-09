# language: no
@OPT-REG-SAM-002 @must @draft @ref-OPT-REG-SAM-001
Egenskap: Tilgang til regelverkssamlinger
  Som opptaksforvalter eller saksbehandler
  ønsker jeg å se regelverkssamlingene ved alle organisasjoner
  slik at jeg kan se hvilket regelverk som gjelder, og kopiere regelverk som passer for organisasjonen jeg er opptaksforvalter ved.
  # Avklart av produkteier 2026-11-09: alle som jobber med opptak (opptaksforvaltere og saksbehandlere) skal kunne lese
  # alt regelverk. Bare opptaksforvaltere kan opprette regelverkssamlinger og kopiere dem, og bare for organisasjonen sin.
  # Koden i dag (2026-11-09): fs-plattform lar alle lese alle regelverkssamlinger (V221__regelverksamling_rls.sql),
  # mens fs-admin viser bare regelverkssamlingene ved organisasjonene brukeren har tilgang til regelverket i
  # (useGetRegelverksamlinger.tsx og KopierRegelverksamlingDialog.tsx).
  # ÅPNE SPØRSMÅL:
  # - Skal saksbehandleren kunne endre eller slette regelverkssamlinger ved organisasjonen sin, eller bare se dem?

  Regel: Opptaksforvaltere og saksbehandlere kan se regelverkssamlingene ved alle organisasjoner

    Scenariomal: Se regelverkssamlinger ved andre organisasjoner
      Gitt <rolle> er innlogget i løsningen
      Og at det finnes en regelverkssamling ved en annen organisasjon enn organisasjonen <rolle> er tilknyttet
      Når <rolle> åpner regelverksoversikten
      Så ser <rolle> regelverkssamlingen ved den andre organisasjonen

      Eksempler:
        | rolle            |
        | opptaksforvalter |
        | saksbehandler    |

    Scenario: Brukere uten rolle i opptak ser ikke regelverkssamlingene
      Gitt brukeren er innlogget i løsningen
      Og at brukeren verken er opptaksforvalter eller saksbehandler ved noen organisasjon
      Når brukeren forsøker å åpne regelverksoversikten
      Så ser brukeren ingen regelverkssamlinger

  Regel: Bare opptaksforvalter kan opprette regelverkssamlinger

    Scenario: Saksbehandler kan ikke opprette regelverkssamlinger
      Gitt saksbehandler er innlogget i løsningen
      Når saksbehandler åpner regelverksoversikten
      Så kan saksbehandler ikke opprette en regelverkssamling

  Regel: Bare opptaksforvalter kan kopiere regelverkssamlinger

    Scenario: Saksbehandler kan ikke kopiere regelverkssamlinger
      Gitt saksbehandler er innlogget i løsningen
      Og at det finnes en regelverkssamling ved en annen organisasjon enn organisasjonen saksbehandler er tilknyttet
      Når saksbehandler åpner regelverkssamlingen ved den andre organisasjonen
      Så kan saksbehandler ikke kopiere regelverkssamlingen
