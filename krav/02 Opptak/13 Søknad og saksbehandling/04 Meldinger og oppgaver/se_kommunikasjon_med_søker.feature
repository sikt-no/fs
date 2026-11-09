# language: no
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

  Regel: Saksbehandleren ser meldingene til og fra søkeren med dato og klokkeslett

  Regel: Saksbehandleren ser om søkeren har åpnet meldingen

  Regel: Opptaksforvalteren ser mottakerne av en utsending og utsendingene som feilet
