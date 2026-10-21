# Spec: Se søkerens elektroniske vitnemål

## Kilde

- **Oppgave:** `tasks/opptak/vitnemalsbehandling/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **GitHub:** [#613](https://github.com/sikt-no/fs/issues/613) (leveranse L1 i initiativet [#607](https://github.com/sikt-no/fs/issues/607))
- **Hentet:** 2026-10-21 (HEAD `ccafff0`)

## Omfang

Saksbehandleren ser søkerens elektroniske VGS-vitnemål i steg 2 «Grunnlag»: en oversikt som er lukket som standard, med en teller. Hvert vitnemål vises med vitnemålsnummer, utstedelsesdato, GSK, førstegangsvitnemål og karakter-, realfags- og språkpoeng, og kan åpnes i en ny fane. Poengene per vitnemål kommer fra Team Puffs poengberegning, så L1 er ikke bare visning. Spesifikasjonen dekker ikke valg av vitnemål (L2), fag (L3, L4) eller resultater fra høyere utdanning.

## Krav

- **`vise_elektroniske_vitnemål.feature`** (`@OPT-BEH-BEH-005`, `@must`) — oversikten over vitnemålene med teller, opplysninger og poeng per vitnemål, sortering (førstegangsvitnemålet først, så eldste til nyeste), ny fane, feilmelding når vitnemålene ikke kan hentes, tomme poeng når poengberegningen ikke svarer, visning av annullerte vitnemål, og innsyn styrt av rettighet, ikke av tilordning. 11 scenarioer. ([krav/…/vise_elektroniske_vitnemål.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vise_elektroniske_vitnem%C3%A5l.feature))

Avklaringene fra gjennomgangen 21.10.2026 står som `AVKLART`-kommentarer i kravfila og i [vitnemålsbehandling.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vitnem%C3%A5lsbehandling.md).

## Skisser

### Skisse: Gjeldende skisser, steg 2

- **Type:** `figma`
- **Referanse:** [FS-Admin – Gjeldende skisser](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344)
- **Lagrede artefakter:**
  - [screenshot.png](krav-input/sketches/figma/gjeldende-skisser/screenshot.png)
  - [sub-frames/01-steg-2-grunnlag-vitnemalsbehandling.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/01-steg-2-grunnlag-vitnemalsbehandling.png)
  - [sub-frames/02-vitnemal-i-ny-fane.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/02-vitnemal-i-ny-fane.png)
- **Dekker krav:** `vise_elektroniske_vitnemål.feature`, regelen «Søkerens elektroniske vitnemål vises». Regelen om innsyn er ikke skissert.
  - Ramme 01: seksjonen «Vitnemålsbehandling» med teller, «Skjul», og tabellen «Vitnemål» med kolonnene Vitnemålsnummer, Utstedt dato, GSK, Første, KAR, REA og SPR. Førstegangsvitnemålet står først. Vitnemålsnummeret har ikon for ny fane.
  - Ramme 02: vitnemålet åpnet i ny fane, med skole, programområder, fag og karakterer, orden og atferd, fravær og «Førstegangsvitnemål».
- **Ulikt scope:** radioknappene for å velge vitnemål og «Legg inn manuelt» (L2, L4), «Kvalifisering og poengberegning» og «Poeng fra vitnemål» (L2, L3), fagene med opprinnelig og forbedret karakter (L3, L4), «Tilleggsfag» og «Spesielle opptakskrav». Ramme 03 viser sammenligning av vitnemål (L5) og ramme 04 FS-klienten i dag; de er ikke koblet til L1.
- **Valideringsstatus:** `Avvik: skissen viser ikke tre tilstander kravet krever: et annullert vitnemål som er brukt i en beregning, feilmeldingen når vitnemålene ikke kan hentes, og tomme poeng når poengberegningen ikke svarer.`
- **Beslutning ved avvik:** Kravene er riktige, skissen er ufullstendig — de tre tilstandene må skisseres.
- **Merknad:** knappen over fagene heter «Åpne i nytt vindu». Kravet er ny fane (avklart 21.10.2026). Teksten hører i implementasjonsdetaljene.

### Skisse: Målbilde vitnemålsbehandleren, steg 2 (erstattet)

- **Type:** `figma`
- **Referanse:** [FS-Admin – Seksjon Opptak, «Vitnemålsbehandleren»](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20402-102594)
- **Lagrede artefakter:** [krav-input/sketches/figma/malbilde-steg-2/](krav-input/sketches/figma/malbilde-steg-2/) (hentet 2026-09-30)
- **Dekker krav:** erstattet av «Gjeldende skisser» 21.10.2026. Beholdes fordi den har den eneste rammen for søker uten elektroniske vitnemål (`sub-frames/01-steg-2-grunnlag-ingen-e-vitnemal.png`).
- **Valideringsstatus:** `Avvik` (fra 2026-09-30): rammen for søker uten elektroniske vitnemål viser seksjonen lukket, mens kravet sier at den ikke vises. Se åpne spørsmål.

## Implementasjonsdetaljer

Mangler. `vise_elektroniske_vitnemål.design.md` er ikke laget, og brukeren valgte å vente (se åpne spørsmål).

## Kodesjekk

Ikke sjekket: ingen kodekloner.

## Retagging

Ingen retagging i denne kjøringen. Kravet var allerede `@in-progress` (satt for hånd 21.10.2026 i commit `ccafff0`, etter beslutning i teamet), og telles som allerede i arbeid.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature` | `@OPT-BEH-BEH-005 @must @in-progress` | uendret |

## Åpne spørsmål

- [ ] **Skissen er ufullstendig:** Tre tilstander må skisseres: et annullert vitnemål som er brukt i en beregning, feilmeldingen når vitnemålene ikke kan hentes, og tomme poeng når poengberegningen ikke svarer.
- [ ] **Søker uten elektroniske vitnemål (fra 2026-09-30):** Målbildet viser seksjonen også når søkeren ikke har elektroniske vitnemål. Kravet sier at den ikke vises. Hvilken av dem gjelder, og hva skal seksjonen eventuelt vise før skjemaet for manuell utfylling kommer i L4?
- [ ] **Implementasjonsdetaljer mangler** for `vise_elektroniske_vitnemål.feature`: feilmeldingen, teksten «Åpne i ny fane», telleren og visningen av et annullert vitnemål. Lages med `fs-implementasjonsdetaljer`.
- [ ] **Kolonnen «GSK»:** Er det påstanden om GSK fra vitnemålet (`paastandOmGsk`)?
- [ ] **Telleren:** Skal den telle annullerte vitnemål som er skjult?
- [ ] **«Brukt i en beregning»:** Gjelder det bare poeng, eller også GSK og kravelementer? Gjelder det opptaket eller søknaden? «Er brukt» eller «har vært brukt»?
- [ ] **Organisasjonen som behandler saken:** Hvilken organisasjon er det i et samordnet opptak?
- [ ] **Avhengighet til Team Puff:** Poengberegningen må kunne beregne poeng for hvert vitnemål, ikke bare for det som er lagt til grunn.

## Rute

fs-plattform → fs-admin
