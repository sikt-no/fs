# Spec: Automatisk GSK-konklusjon

## Kilde

- **Scope:** `tasks/opptak/automatisk-gsk-konklusjon/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling`
- **GitHub:** [#723](https://github.com/sikt-no/fs/issues/723)
- **Hentet:** 2026-11-02 12:20

## Omfang

Søknaden får GSK-konklusjonen automatisk når vitnemålet har «GSK OK» fra KREG, og løpet på vitnemålet finnes i listen over løp. Grunnlagskoden kommer fra løpet: PBPBY4 gir KLF, og et løp uten grunnlagskode gir KLY eller RFA etter reformen, som i det gamle FS. fs-opptaks kontrollmotor beregner opptakssystemets påstand når vitnemålet importeres, og lagrer den på vitnemålet. Er den uenig med «GSK OK» fra KREG, ser saksbehandleren et varsel, men automatikken stopper ikke. Varslene i FS Admin til opptaksforvalteren om løp som mangler i listen, eller mangler grunnlagskode, er utkast og ikke med i leveransen. Et annullert vitnemål trekker ikke tilbake konklusjonen. Når et vitnemål som er brukt i en sak, blir annullert før søkeren er med i en publisert plasstildelingsrunde, får saken taggen «Vitnemål annullert», og en ferdig behandlet sak går tilbake til under behandling (`@OPT-BEH-BEH-034`). Merknaden på saken kommer senere. Konklusjonene fra tidligere opptak bygger på importtabellen i STEK-442.

## Krav

- **`automatisk_gsk_konklusjon.feature`** (`@OPT-BEH-BEH-015`) — når søknaden får GSK-konklusjonen automatisk: fra vitnemålet, fra et tidligere opptak, i den automatiske behandlingen, ved annullering, og varslene. ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_gsk_konklusjon.feature))
- **`beregne_gsk_fra_vitnemål.feature`** (`@OPT-BEH-BEH-027`) — opptakssystemets påstand: seksfagskontrollen, løpet og grunnlagskoden. ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_gsk_fra_vitnemål.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_gsk_fra_vitnem%C3%A5l.feature))
- **`håndtere_annullert_vitnemål.feature`** (`@OPT-BEH-BEH-034`) — taggen «Vitnemål annullert» og at en ferdig behandlet sak går tilbake til under behandling, når et vitnemål som er i bruk, blir annullert. ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/håndtere_annullert_vitnemål.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/h%C3%A5ndtere_annullert_vitnem%C3%A5l.feature))

### Utenfor scope (`@draft`)

- **`beregne_gsk_fra_vitnemål.feature` — regel `Fag som saksbehandleren har tatt ut av kontrollene, telles ikke med`** — venter på: hva fagstatusen er, og hvem som setter den. Kravet for fagstatusen er ikke skrevet.
- **`automatisk_gsk_konklusjon.feature` — scenario `Opptaksforvalteren får varsel om et løp som mangler i listen over løp`** — venter på: hvor i FS Admin opptaksforvalteren får varselet, og om det er ett varsel per løp eller ett per vitnemål med løpet.
- **`automatisk_gsk_konklusjon.feature` — scenario `Opptaksforvalteren får varsel om et løp uten grunnlagskode`** — venter på: hvor i FS Admin opptaksforvalteren får varselet.
- **`håndtere_annullert_vitnemål.feature` — regel `Saken får en merknad om det annullerte vitnemålet`** — venter på: hvordan systemet skal skrive en merknad på saken. I dag kan bare en innlogget person skrive merknader.

## Skisser

### Skisse: `Varsel om uenighet i vitnemålsbehandlingen`

- **Type:** `lokal-bilde`
- **Referanse:** skjermdump av saken i fs-admin med påtegning, 2026-11-02
- **Lagrede artefakter:** [varsel-uenighet-vitnemalsbehandling.png](krav-input/sketches/varsel-uenighet-vitnemalsbehandling.png)
- **Dekker krav:** `automatisk_gsk_konklusjon.feature` (scenario: `Saksbehandleren ser at opptakssystemet er uenig med skolen når vitnemålet <skolen> GSK OK fra KREG`)
- **Valideringsstatus:** `OK` — skissen viser et «!» ved antallet på «Vitnemålsbehandling» og en tekst under vitnemålsnummeret, som kommentaren i scenarioet. Teksten i skissen er en plassholder.

Ingen skisse for resten: varslene til opptaksforvalteren er ikke avklart, 034 bruker taggene og behandlingsstatusen som fs-admin viser i dag, og resten er backend.

## Kodesjekk

- **Sjekket:** fs-plattform (origin/main 2026-11-02), fs-admin (origin/main 2026-10-30). GSK-koden er ikke endret siden verify 2026-10-30. Alle avvikene er avklart med domeneeksperten 2026-11-02: koden skal endres.
- `@OPT-BEH-BEH-015`: kravet sier at uenighet mellom skolen og opptakssystemet gir varsel og ikke stopper automatikken. Koden stopper automatikken uten varsel (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskKonklusjonEvaluator.java:64-69`, `KRYSSJEKK_FEILET`). Koden skal endres.
- `@OPT-BEH-BEH-027`: kravet sier at PBPBY4 alltid gir KLF. Koden gir grunnlagskoden for løpet uten tillegget (`GskKonklusjonEvaluator.java:43-47`, `:70-71`). Koden skal endres.
- `@OPT-BEH-BEH-015`, `@OPT-BEH-BEH-027`: kravet sier at et løp uten grunnlagskode gir KLY eller RFA, også i den automatiske behandlingen. Koden gjør det bare når saksbehandleren starter kontrollen (`GskKonklusjonEvaluator.java:61`, `GskVedtakAutoService.java:89` sender `false`). Koden skal endres.
- `@OPT-BEH-BEH-015`: kravet sier at opptakssystemets påstand beregnes når vitnemålet importeres, og lagres på vitnemålet med tidspunkt og beregning. Koden beregner bare i den automatiske behandlingen, og lagrer bare skolens påstand (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/KregVgsParser.java:104`). Koden skal endres.
- `@OPT-BEH-BEH-015`: kravet sier at konklusjonen står når vitnemålet annulleres. Koden trekker den tilbake, også i andre og avsluttede opptak (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/gsk/GskVedtakTilbakekallingService.java:64-90`). Koden skal endres.
- `@OPT-BEH-BEH-015`: varslene til saksbehandleren og opptaksforvalteren finnes ikke i koden.

- `@OPT-BEH-BEH-034`: ingen kode går fra et annullert vitnemål til sakene der det er brukt. Annulleringen lagres (`VgsLagringService`, `ANNULLERING_OPPDATERT`), men `HentVgsVitnemaalService` bruker den ikke. Sjekken av om vitnemålet er brukt i poeng, kravelementer eller GSK finnes i fs-plattform !6456 (STEK-551, `VgsDokumentConditions.bruktIBeregningPaaOpptaket`), men er ikke tilgjengelig utenfor pakken, og sier ikke hva vitnemålet er brukt til. Koden skal endres, og bygges oppå !6456.
- `@OPT-BEH-BEH-034`: tagger er fritekst per opptak og organisasjon, uten systemtagger (`TaggService`, `TaggRepo`). Systemet må lage taggen «Vitnemål annullert» når den mangler. Jobben som henter vitnemål, kjører med RLS-bypass (`SoknadshendelseJobb`), så den kan sette taggen.
- `@OPT-BEH-BEH-034`: ingen kode setter `FERDIG_BEHANDLET` tilbake til `UNDER_BEHANDLING` automatisk. Mønsteret for `UBEHANDLET` → `UNDER_BEHANDLING` finnes (`MerknadService`, `GskVedtakService`).
- `@OPT-BEH-BEH-034`: «opptak som ikke er avsluttet» finnes ikke i koden. Avklart 2026-11-02: saken merkes ikke når søkeren er med i en plasstildelingsrunde som er publisert. Publiseringen skriver ett opptakssvar per søknadsalternativ (`publiserRundeV2`, `soknad_v2.opptakssvar`), så det kan sjekkes. Kravet er endret.
- `@OPT-BEH-BEH-034`: systemet kan ikke skrive en merknad på saken (`MerknadService.innloggetForfatter`, CHECK på forfatter i `merknad`). Avklart 2026-11-02: merknaden kommer senere, og regelen er `@draft`.
- `@OPT-BEH-BEH-034`: vitnemålene hentes fra KREG bare når søkeren blir tildelt i `SoknadshendelseJobb`. En annullering oppdages derfor bare da (se *Åpne spørsmål*).

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_gsk_konklusjon.feature` | `@OPT-BEH-BEH-015 @must @planned` | `@OPT-BEH-BEH-015 @must @in-progress` |
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_gsk_fra_vitnemål.feature` | `@OPT-BEH-BEH-027 @must @planned` | `@OPT-BEH-BEH-027 @must @in-progress` |
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/håndtere_annullert_vitnemål.feature` | `@OPT-BEH-BEH-034 @must @planned` | `@OPT-BEH-BEH-034 @must @in-progress` |

## Åpne spørsmål

- [ ] Hvordan oppdager opptakssystemet at et vitnemål er annullert, når søkeren ikke endrer søknaden? I dag hentes vitnemålene bare når søkeren blir tildelt. Det krever abonnement på endringer i KREG, eller en jobb som jevnlig sjekker vitnemålene som er i bruk. Egen oppgave i dette scopet. (`@OPT-BEH-BEH-015`, `@OPT-BEH-BEH-034`)
- [ ] Teksten i varselet om uenighet mangler (`vise_elektroniske_vitnemål.design.md`, «Varsel når opptakssystemet er uenig med skolen om GSK»). Implementasjonsdetaljer for resten av `automatisk_gsk_konklusjon.feature` mangler.

## Rute

fs-plattform → fs-admin
