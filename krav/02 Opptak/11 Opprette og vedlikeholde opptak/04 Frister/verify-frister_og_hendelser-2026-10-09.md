# Verifisering: Frister og hendelser for opptak — dato for aldersberegning

- **Dato:** 2026-10-09
- **Krav:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature`, regelen «Alderen beregnes fra opptakets dato for aldersberegning» (verifisert uansett status)
- **Kode:** `fs-plattform` (origin/main `7860426b6c`), `fs-admin` (origin/main `9858ccdcd`)

## Oppsummering

- Retagget `@in-progress` → `@implemented`: 0 (regelen står under en `@in-progress` egenskap, og blir levert når hele egenskapen verifiseres)
- Alle fire scenarioene i regelen er funnet
- Regelen er flyttet hit fra `automatisk_kvoteplassering.feature` (`@OPT-BEH-BEH-012`)

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-FRI-001` | Alder beregnes fra datoen opptaket har satt | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/AldersberegningsdatoUtleder.java:44` · `fs-admin/src/domains/opptak/components/OpptakDeadlineInputs/OpptakDeadlineInput.test.tsx:94` |
| `@OPT-OVO-FRI-001` | Standarddato for aldersberegning | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/AldersberegningsdatoUtleder.java:51` · `AldersberegningsdatoUtlederTest.java:89` |
| `@OPT-OVO-FRI-001` | Opptak med aldersregler mangler dato for aldersberegning | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/AldersberegningsdatoUtleder.java:17` · `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/LeggTilGrunnlagService.java:45` · `AldersberegningsdatoUtlederTest.java:109` |
| `@OPT-OVO-FRI-001` | Opptak uten aldersregler trenger ikke dato for aldersberegning | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/AldersberegningsdatoUtleder.java:37` · `AldersberegningsdatoBetingetKravIT.java:183` |

## Retagget til @implemented

Ingen.

## Oppfølging

- Opptaksforvalteren setter datoen sammen med de andre fristene i fs-admin (`OpptakDeadlineInputs`).
- Resten av egenskapen `@OPT-OVO-FRI-001` er ikke verifisert i denne kjøringen.
- Ingen step definitions i `tester/steps/` for regelen.
