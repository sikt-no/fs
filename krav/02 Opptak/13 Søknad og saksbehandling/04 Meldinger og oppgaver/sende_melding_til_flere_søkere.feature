# language: no
@OPT-SØK-MEL-005 @should @draft @scope-meldinger-til-flere-sokere
Egenskap: Sende melding til flere søkere
  Som opptaksforvalter ved organisasjonen som forvalter opptaket
  ønsker jeg å sende en melding til et utvalg av søkerne eller til alle søkerne
  slik at søkerne som berøres, får vite det i tide.

  Saksbehandleren og de ansatte ved tilbyderen kan også sende til et utvalg av søkerne. Meldingen til én
  søker står i sende_melding_til_søker.feature.

  # Kilde: workshop om meldinger 2026-11-09 (Miro), K6, K7, K9, K10, K11 og beslutning 6.

  # ÅPNE SPØRSMÅL:
  # - Tilbyderen er lærestedet som tilbyr utdanningstilbudet (begreper.md), ikke en rolle.
  #   Hvilken rolle har de ansatte ved tilbyderen som sender meldinger?
  # - Er et avlyst studium det samme som et trukket utdanningstilbud
  #   (12 Utdanningstilbud/02 Utdanningstilbud i opptak/trekke_utdanningstilbud.feature)?
  # - K7: workshopen ville se på andre måter å løse dokumentasjonskravene på.
  # - K9-3 og K10-2: kan søkeren bytte søknadsalternativ når et studium avlyses eller endres?
  # - Beslutning 6 sier at forvalteren avgjør hva som er store endringer, men K10 er
  #   tilbyderens behov. Hvem sender meldingen?

  Regel: Opptaksforvalteren sender melding til et utvalg av søkerne eller til alle søkerne i opptaket

  Regel: Saksbehandleren og de ansatte ved tilbyderen sender melding til et utvalg av søkerne, men ikke til alle

  Regel: Søkerne til et utdanningstilbud med opptaksprøve får informasjon om opptaksprøven

  Regel: Søkerne i en søkergruppe får informasjon om dokumentasjonskravene for gruppen

  Regel: Søkerne til et utdanningstilbud som er avlyst, får melding om avlysningen

  Regel: Søkerne til et utdanningstilbud med store endringer i studieplanen får melding om endringene
