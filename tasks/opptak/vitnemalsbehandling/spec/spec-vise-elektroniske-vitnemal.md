# Spec: Se søkerens elektroniske vitnemål

## Kilde

- **Oppgave:** `tasks/opptak/vitnemalsbehandling/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **GitHub:** [#613](https://github.com/sikt-no/fs/issues/613) (leveranse L1 i initiativet [#607](https://github.com/sikt-no/fs/issues/607))
- **Hentet:** 2026-10-28 (HEAD `ef68c3a`)

## Omfang

Saksbehandleren ser søkerens elektroniske VGS-vitnemål i steg 2 «Grunnlag»: en oversikt som er lukket som standard, med en teller. Hvert vitnemål vises med vitnemålsnummer, utstedelsesdato, GSK, førstegangsvitnemål og karakter-, realfags- og språkpoeng, og kan åpnes i en ny fane. Poengene per vitnemål kommer fra poengberegningen i opptak, så L1 er ikke bare visning. Spesifikasjonen dekker ikke valg av vitnemål (L2), fag (L3, L4) eller resultater fra høyere utdanning.

## Krav

- **`vise_elektroniske_vitnemål.feature`** (`@OPT-BEH-BEH-005`, `@must`) — oversikten over vitnemålene med teller, opplysninger og poeng per vitnemål, sortering etter utstedelsesdato, fra eldste til nyeste, ny fane, feilmelding når vitnemålene ikke kan hentes, feilmelding og tomme poeng når poengberegningen ikke svarer, visning av annullerte vitnemål, og innsyn styrt av rettighet, ikke av tilordning. 11 scenarioer. ([krav/…/vise_elektroniske_vitnemål.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vise_elektroniske_vitnem%C3%A5l.feature))

**Endret etter henting (22.10.2026):** Kravet er endret på stedet etter svar fra domeneekspertene. Alle vitnemålene sorteres nå kronologisk (førstegangsvitnemålet står ikke først av seg selv), og scenarioet «Poengene vises tomme når poengberegningen ikke svarer» heter nå «Feilmelding når poengberegningen ikke svarer» og krever en feilmelding i tillegg til tomme poeng.

Avklaringene fra gjennomgangen 21.10.2026 står som `AVKLART`-kommentarer i kravfila og i [vitnemålsbehandling.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vitnem%C3%A5lsbehandling.md).

## Skisser

### Skisse: Gjeldende skisser, «Nyeste skisser»

- **Type:** `figma`
- **Referanse:** [FS-Admin – Gjeldende skisser, seksjonen «Nyeste skisser»](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344), på siden «Vitnemålsbehandler». Hentet på nytt 2026-10-28.
- **Lagrede artefakter:**
  - [screenshot.png](krav-input/sketches/figma/gjeldende-skisser/screenshot.png)
  - [sub-frames/01-steg-2-grunnlag-behandle-e-vitnemal.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/01-steg-2-grunnlag-behandle-e-vitnemal.png)
  - [sub-frames/02-visning-av-vitnemal.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/02-visning-av-vitnemal.png)
  - [sub-frames/03-annullert-vitnemal.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/03-annullert-vitnemal.png)
  - [sub-frames/05-annullert-vitnemal-lagt-til-grunn-fra-for-kun-leserettighet.png](krav-input/sketches/figma/gjeldende-skisser/sub-frames/05-annullert-vitnemal-lagt-til-grunn-fra-for-kun-leserettighet.png)
- **Dekker krav:** `vise_elektroniske_vitnemål.feature`, regelen «Søkerens elektroniske vitnemål vises». Regelen om innsyn er ikke skissert.
  - **Stemmer:** seksjonen «Vitnemålsbehandling» med teller og «Skjul», tabellen «Vitnemål» med kolonnene Vitnemålsnummer, Utstedt dato, GSK, Første, KAR, REA og SPR, sortert fra eldste til nyeste, og lenke med ikon for ny fane på vitnemålsnummeret.
  - **Stemmer:** «Visning av vitnemål» viser vitnemålet i egen side, med skole, programområder, fag og karakterer, orden og atferd, fravær og «Førstegangsvitnemål».
  - **Stemmer:** «annullert vitnemål» viser et annullert vitnemål som er brukt i en beregning: taggen «Annullert» etter nummeret, grå tekst, ingen radioknapp, og poengene står.
- **Ulikt scope:** radioknappene og «Legg inn manuelt» (L2, L4), «Kvalifisering og poengberegning» og «Poeng fra vitnemål» (L2, L3), fagene med opprinnelig og forbedret karakter (L3, L4), «Tilleggsfag», «Spesielle opptakskrav», og rammen «Outer Frame» med sammenligning av vitnemål (L5). Rammen «bilde 1» er et skjermbilde av FS-klienten og er ikke koblet til kravene.
- **Valideringsstatus:** `Avvik`: tre tilstander kravet krever, er ikke skissert: feilmeldingen når vitnemålene ikke kan hentes, feilmeldingen og de tomme poengene når poengberegningen ikke svarer, og søker uten elektroniske vitnemål. Knappen over fagene heter «Åpne i nytt vindu».
- **Beslutning ved avvik:** Kravene er riktige. Feilmeldingene skisseres ikke: tekstene og plasseringen står i implementasjonsdetaljene (avklart 2026-10-28). Knappen skal hete «Åpne i ny fane». Søker uten elektroniske vitnemål er fortsatt åpent.

### Skisse: Målbilde vitnemålsbehandleren, steg 2 (erstattet)

- **Type:** `figma`
- **Referanse:** [FS-Admin – Seksjon Opptak, «Vitnemålsbehandleren»](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20402-102594)
- **Lagrede artefakter:** [krav-input/sketches/figma/malbilde-steg-2/](krav-input/sketches/figma/malbilde-steg-2/) (hentet 2026-09-30)
- **Dekker krav:** erstattet av «Gjeldende skisser». Beholdes fordi den har den eneste rammen for søker uten elektroniske vitnemål (`sub-frames/01-steg-2-grunnlag-ingen-e-vitnemal.png`).
- **Valideringsstatus:** `Avvik` (fra 2026-09-30): rammen for søker uten elektroniske vitnemål viser seksjonen lukket, mens kravet sier at den ikke vises. Se åpne spørsmål.

## Implementasjonsdetaljer

- **`vise_elektroniske_vitnemål.feature`** — [vise_elektroniske_vitnemål.design.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vise_elektroniske_vitnem%C3%A5l.design.md) (5 åpne designspørsmål). Laget 2026-10-28, med feilmeldingene, «Åpne i ny fane» og tilstanden for annullert vitnemål.

## Kodesjekk

Ikke sjekket: ingen kodekloner.

## Retagging

Ingen retagging. Kravet er allerede `@in-progress` (satt for hånd 2026-10-21 i commit `ccafff0`, etter beslutning i teamet), og telles som allerede i arbeid.

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature` | `@OPT-BEH-BEH-005 @must @in-progress` | uendret |

## Åpne spørsmål

- [x] **Skissen er ufullstendig (fra 2026-10-21):** Et annullert vitnemål som er brukt i en beregning, er nå skissert (2026-10-28). Feilmeldingene skisseres ikke, men står i implementasjonsdetaljene (avklart 2026-10-28).
- [ ] **Søker uten elektroniske vitnemål (fra 2026-09-30):** Målbildet viser seksjonen også når søkeren ikke har elektroniske vitnemål. Kravet sier at den ikke vises. Gjeldende skisser har ingen ramme for dette. Hvilken av dem gjelder, og hva skal seksjonen eventuelt vise før skjemaet for manuell utfylling kommer i L4?
- [x] **Implementasjonsdetaljer mangler:** `vise_elektroniske_vitnemål.design.md` er laget 2026-10-28.
- [ ] **Kolonnen «GSK»:** Er det påstanden om GSK fra vitnemålet (`paastandOmGsk`)?
- [ ] **Telleren:** Skal den telle annullerte vitnemål som er skjult?
- [ ] **«Brukt i en beregning»:** Gjelder det bare poeng, eller også GSK og kravelementer? Gjelder det opptaket eller søknaden? «Er brukt» eller «har vært brukt»?
- [ ] **Organisasjonen som behandler saken:** Hvilken organisasjon er det i et samordnet opptak?
- [ ] **Poeng for hvert vitnemål:** Poengberegningen i opptak må kunne beregne poeng for hvert vitnemål, ikke bare for det som er lagt til grunn. Ifølge domeneekspertene må poengene være på plass til opptaket i 2027, men det er usikkert om de blir ferdige før L1 skal akseptansetestes. Kan L1 akseptansetestes uten poengene?

## Rute

fs-plattform → fs-admin
