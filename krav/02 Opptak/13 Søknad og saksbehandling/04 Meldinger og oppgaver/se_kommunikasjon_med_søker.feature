# language: no
# BEGREPER (2026-11-10): Bytt «saksbehandlende organisasjon» med «behandler» når fila likevel endres. Se krav/02 Opptak/begreper.md.
@OPT-SØK-MEL-004 @should @draft @scope-meldinger-varslinger-og-oppgaver
Egenskap: Se kommunikasjon med søker
  Som saksbehandler ved saksbehandlende organisasjon
  ønsker jeg å se all kommunikasjon med søkeren
  slik at jeg kan dokumentere hva søkeren har fått beskjed om, også i en klagesak.

  Opptaksforvalteren følger med på utsendingene: hvem som har fått dem, og hvilke som har feilet.

  # Kilde: workshop om meldinger 2026-11-09 (Miro), K12 og beslutning 9.
  # Blokkert: bygger på den nye sporingsloggen, og endringsloggen er stoppet (BAT-324).
  # At saksbehandleren ser om søkeren har lest en mangel, står i
  # 02 Behandling/søknadsmangler.feature (@OPT-BEH-BEH-008).
  # Endringene i saken står i 02 Behandling/hendelseslogg_for_saksbehandling.feature (@OPT-BEH-BEH-016).

  # Avklart 2026-11-10 (R5, svar 11 og 22): meldingene ses bare av organisasjonene som er forvalter, tilbyder eller
  # behandler på søknaden. En melding er delt med dem, med mindre avsenderen har merket den som intern. Opptaksforvalteren
  # og opptaksinformatøren ser de samme meldingene som saksbehandlerne ved organisasjonen.
  Regel: Meldingene ses bare av organisasjonene som er forvalter, tilbyder eller behandler på søknaden

    Scenariomal: Se en melding en annen organisasjon har sendt
      Gitt søknaden er i et samordna opptak der tilbyderen og behandleren er ulike organisasjoner
      Og behandleren har sendt en <type> melding til søkeren
      Og jeg er <rolle> ved <organisasjon>
      Når jeg ser kommunikasjonen med søkeren
      Så <ser> jeg meldingen

      Eksempler:
        | type   | rolle             | organisasjon                          | ser      |
        | delt   | saksbehandler     | tilbyderen av søknadsalternativet     | ser      |
        | delt   | opptaksforvalter  | forvalteren av opptaket               | ser      |
        | delt   | opptaksinformatør | tilbyderen av søknadsalternativet     | ser      |
        | intern | saksbehandler     | tilbyderen av søknadsalternativet     | ser ikke |
        | intern | saksbehandler     | behandleren av søknadsalternativet    | ser      |
        | delt   | saksbehandler     | en organisasjon uten rolle i opptaket | ser ikke |

  Regel: Saksbehandleren ser meldingene til og fra søkeren med dato og klokkeslett

  Regel: Saksbehandleren ser om søkeren har åpnet meldingen

  Regel: Opptaksforvalteren ser mottakerne av en utsending og utsendingene som feilet
