# Spec: Registrere og beregne praksis for søker

## Kilde

- **Oppgave:** `tasks/opptak/registrere-praksis/`
- **Kilde:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature`
- **GitHub:** [#560](https://github.com/sikt-no/fs/issues/560)
- **Hentet:** 2026-09-29, fra `main` etter at [#648](https://github.com/sikt-no/fs/pull/648) ble slått sammen

## Krav

- **`registrere_praksis.feature`** (`@OPT-BEH-BEH-003`, `@must`). Opptakssaksbehandleren registrerer praksisperioder på en sak, med arbeidsgiver og praksistype (begge valgfrie), obligatorisk start- og sluttdato og omfang som stillingsprosent (0–100 %) eller timer. Praksis summeres i år med full presisjon, der en delvis måned regnes med 30 dager, og vises avkortet til to desimaler. En ny periode er relevant som standard, og relevansflagget filtrerer før overlappsberegningen. Ved overlapp vises sum av oppgitte perioder og sum justert for overlapp, og det gis varsel ved over 100 % stilling. Kravet dekker også validering av datoer og stillingsprosent, oppdatering og sletting, og tilgang. ([krav-input/local/…/registrere_praksis.feature](krav-input/local/krav/02%20Opptak/13%20Søknad%20og%20saksbehandling/02%20Behandling/registrere_praksis.feature))
  - Utenfor første leveranse: scenarioet «Knytte praksisperioden til dokumentasjon på søknaden» (`@could`, utsatt).
  - Kobling til opptakskrav hører ikke til denne spec-en. Den dekkes av `knytte_praksis_til_opptakskrav.feature` (`@OPT-BEH-BEH-006`).

## Skisser

### Skisse: Skisse til claude

- **Type:** `figma`
- **Referanse:** [FS-Admin – Seksjon Opptak, seksjonen «Skisse til claude»](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20747-108803), node `20747:108803`
- **Lagrede artefakter:**
  - [screenshot.png](krav-input/sketches/figma/skisse-til-claude/screenshot.png)
  - [sub-frames/01-sidelayout-i-fs-admin-pattern.png](krav-input/sketches/figma/skisse-til-claude/sub-frames/01-sidelayout-i-fs-admin-pattern.png): oversiktssiden «Praksiskalkulator»
  - [sub-frames/02-modal-on-background.png](krav-input/sketches/figma/skisse-til-claude/sub-frames/02-modal-on-background.png): dialogen «Legg til praksisperiode»
  - [design-context.md](krav-input/sketches/figma/skisse-til-claude/design-context.md)
- **Dekker krav:** `registrere_praksis.feature`, reglene «Praksisperioder registreres manuelt på saken», «Omfanget av en praksisperiode oppgis som stillingsprosent eller som antall timer», «Praksisperioder kan oppdateres og slettes», «Systemet summerer praksisperiodene automatisk» og «Overlappende praksisperioder varsles og vises med to summer».
- **Stemmer med kravene:**
  - Startdato og sluttdato er obligatoriske. Praksistype og arbeidsgiver er valgfrie.
  - «Tilknyttet dokumentasjon» er tatt ut, i tråd med at koblingen er `@could` og utsatt.
  - Listen viser arbeidsgiver og praksistype, periode, omfang, beregnet praksis, relevansmarkering og handlingene rediger og slett.
  - Relevans markeres per periode, og en periode kan ha markeringen fjernet (SPLFOLK).
  - Omfanget oppgis enten som stillingsprosent eller som timer i perioden.
  - «850 timer (av 1700)» gir 0,50 år, som er riktig: årsverket kan justeres per periode.
  - Overlapp over 100 % varsles med tidsrommet (15.06.2022–28.06.2022), og periodene som overlapper, er markert med varselikon.
  - Summene heter nå «Samlet beregnet oppgitt relevant praksis» og «Samlet beregnet relevant praksis justert for overlapp», som i kravet.
- **Valideringsstatus:** `Avvik`, med to funn. Avvik 2 (navn på summene) og 3 (tidsrom i overlappsvarselet) fra valideringen tidligere i dag er rettet i skissen.

| # | Avvik | Beslutning | Begrunnelse / konsekvens |
|---|---|---|---|
| 1 | Eksempeltallene stemmer ikke med regnereglene. 01.01.2020–31.12.2020 i 100 % vises som 2,00 år (skal være 1,00). 01.03.2021–28.06.2022 i 75 % vises som 0,25 år (blir omtrent 0,99). Summene stemmer heller ikke med radene: de tre relevante radene gir 2,55 slik skissen viser dem, men «oppgitt» viser 3,00. Med riktige tall blir begge summene omtrent 2,29 år. | **Kravene er riktige. Skissen er utdatert.** Besluttet tidligere 2026-09-29. | Tallene i skissen rettes etter regnereglene i kravet. |
| 2 | Feilmeldingene i dialogen er ikke skissert: startdato mangler, sluttdato mangler, sluttdato før startdato, ugyldig dato og (nytt i kravet) stillingsprosent utenfor 0–100 %. | **Kravene er riktige. Skissen er ufullstendig.** Besluttet tidligere 2026-09-29 for de fire første; stillingsprosent er ført inn under samme beslutning. | Feilmeldingene må skisseres før skissen kan legges til grunn. Eier: Julia. |

## Retagging

Kravet var allerede `@in-progress`. Ingen retagging.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature` | `@OPT-BEH-BEH-003 @must @in-progress` | uendret (allerede i arbeid) |

## Åpne spørsmål

- [ ] Skissen skal oppdateres på avvik 1 og 2 over. Eier: Julia.
