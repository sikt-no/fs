# Spec: Automatisk GSK-konklusjon

## Kilde

- **Scope:** `tasks/opptak/automatisk-gsk-konklusjon/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling`
- **GitHub:** [#723](https://github.com/sikt-no/fs/issues/723)
- **Hentet:** 2026-11-02 12:20

## Omfang

Søknaden får GSK-konklusjonen automatisk når skolens påstand («GSK OK» fra KREG) er ja, og løpet på vitnemålet finnes i listen over løp. Grunnlagskoden kommer fra løpet: PBPBY4 gir KLF, og et løp uten grunnlagskode gir KLY eller RFA etter reformen, som i det gamle FS. Opptakssystemet beregner sin egen påstand med kontrollmotoren når vitnemålet importeres, og lagrer den på vitnemålet. Er den uenig med skolen, ser saksbehandleren et varsel, men automatikken stopper ikke. Løp som mangler i listen, eller mangler grunnlagskode, gir varsel til opptaksforvalteren. Et annullert vitnemål trekker ikke tilbake konklusjonen. Taggen «Vitnemål annullert» hører til `@OPT-BEH-BEH-034`, og konklusjonene fra tidligere opptak bygger på importtabellen i STEK-442.

## Krav

- **`automatisk_gsk_konklusjon.feature`** (`@OPT-BEH-BEH-015`) — når søknaden får GSK-konklusjonen automatisk: fra vitnemålet, fra et tidligere opptak, i den automatiske behandlingen, ved annullering, og varslene. ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_gsk_konklusjon.feature))
- **`beregne_gsk_fra_vitnemål.feature`** (`@OPT-BEH-BEH-027`) — opptakssystemets påstand: seksfagskontrollen, løpet og grunnlagskoden. ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_gsk_fra_vitnemål.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_gsk_fra_vitnem%C3%A5l.feature))

### Utenfor scope (`@draft`)

- **`beregne_gsk_fra_vitnemål.feature` — regel `Fag som saksbehandleren har tatt ut av kontrollene, telles ikke med`** — venter på: hva fagstatusen er, og hvem som setter den. Kravet for fagstatusen er ikke skrevet.

## Skisser

### Skisse: `Varsel om uenighet i vitnemålsbehandlingen`

- **Type:** `lokal-bilde`
- **Referanse:** skjermdump av saken i fs-admin med påtegning, 2026-11-02
- **Lagrede artefakter:** [varsel-uenighet-vitnemalsbehandling.png](krav-input/sketches/varsel-uenighet-vitnemalsbehandling.png)
- **Dekker krav:** `automatisk_gsk_konklusjon.feature` (scenario: `Saksbehandleren ser at opptakssystemet er uenig med skolen når skolen sier at søkeren <skolen> generell studiekompetanse`)
- **Valideringsstatus:** `OK` — skissen viser et «!» ved antallet på «Vitnemålsbehandling» og en tekst under vitnemålsnummeret, som kommentaren i scenarioet. Teksten i skissen er en plassholder.

Ingen skisse for resten: varslene til opptaksforvalteren er ikke avklart, og resten er backend.

## Kodesjekk

- **Sjekket:** fs-plattform (origin/main 2026-11-02), fs-admin (origin/main 2026-10-30). GSK-koden er ikke endret siden verify 2026-10-30. Alle avvikene er avklart med domeneeksperten 2026-11-02: koden skal endres.
- `@OPT-BEH-BEH-015`: kravet sier at uenighet mellom skolen og opptakssystemet gir varsel og ikke stopper automatikken. Koden stopper automatikken uten varsel (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskKonklusjonEvaluator.java:64-69`, `KRYSSJEKK_FEILET`). Koden skal endres.
- `@OPT-BEH-BEH-027`: kravet sier at PBPBY4 alltid gir KLF. Koden gir grunnlagskoden for løpet uten tillegget (`GskKonklusjonEvaluator.java:43-47`, `:70-71`). Koden skal endres.
- `@OPT-BEH-BEH-015`, `@OPT-BEH-BEH-027`: kravet sier at et løp uten grunnlagskode gir KLY eller RFA, også i den automatiske behandlingen. Koden gjør det bare når saksbehandleren starter kontrollen (`GskKonklusjonEvaluator.java:61`, `GskVedtakAutoService.java:89` sender `false`). Koden skal endres.
- `@OPT-BEH-BEH-015`: kravet sier at opptakssystemets påstand beregnes når vitnemålet importeres, og lagres på vitnemålet med tidspunkt og beregning. Koden beregner bare i den automatiske behandlingen, og lagrer bare skolens påstand (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/KregVgsParser.java:104`). Koden skal endres.
- `@OPT-BEH-BEH-015`: kravet sier at konklusjonen står når vitnemålet annulleres. Koden trekker den tilbake, også i andre og avsluttede opptak (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskVedtakTilbakekallingService.java:64-90`). Koden skal endres.
- `@OPT-BEH-BEH-015`: varslene til saksbehandleren og opptaksforvalteren finnes ikke i koden.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature` | `@OPT-BEH-BEH-015 @must @planned` | `@OPT-BEH-BEH-015 @must @in-progress` |
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_gsk_fra_vitnemål.feature` | `@OPT-BEH-BEH-027 @must @planned` | `@OPT-BEH-BEH-027 @must @in-progress` |

## Åpne spørsmål

- [ ] Hvor får opptaksforvalteren varselet om et løp som mangler i listen over løp, eller mangler grunnlagskode? (`@OPT-BEH-BEH-015`)
- [ ] Hvordan oppdager opptakssystemet at et vitnemål er annullert, når søkeren ikke endrer søknaden? Krever abonnement på endringer i KREG, i en egen sak. (`@OPT-BEH-BEH-015`)
- [ ] Teksten i varselet om uenighet mangler (`vise_elektroniske_vitnemål.design.md`, «Varsel når opptakssystemet er uenig med skolen om GSK»). Implementasjonsdetaljer for resten av `automatisk_gsk_konklusjon.feature` mangler.

## Rute

fs-plattform → fs-admin
