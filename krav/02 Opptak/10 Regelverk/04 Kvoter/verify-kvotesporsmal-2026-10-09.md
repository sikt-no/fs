# Verifisering: Kvotespørsmål

- **Dato:** 2026-10-09
- **Krav:** `krav/02 Opptak/10 Regelverk/04 Kvoter/kvotesporsmal.feature` (hele egenskapen, verifisert uansett status)
- **Kode:** `fs-plattform` (origin/main `dd2d886b2b`), `fs-admin` (origin/main `665c3b41a`)

## Oppsummering

- Retagget `@in-progress` → `@implemented`: 0 (egenskapen er `@draft`, og ikke alt er funnet)
- Fortsatt ikke levert: informasjon om automatisk plassering (STEK-539), og navnene på algoritmene i fs-admin
- Slettet (`@deprecated`): 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-REG-KVO-002` | Opprette kvotespørsmål | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvoteplassering/KvotesporsmalService.java:28` · `fs-admin/src/domains/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:164` |
| `@OPT-REG-KVO-002` | Flerspråklig kvotespørsmål | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvoteplassering/KvotesporsmalService.java:127` · `fs-admin/src/domains/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:267` |
| `@OPT-REG-KVO-002` | Tilgjengelige algoritmer | usikker | Bare `ER_MANN` og `ER_KVINNE` finnes, men nedtrekket viser koden, ikke navnet (`fs-admin/src/domains/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:89`) |
| `@OPT-REG-KVO-002` | Koble kvotespørsmål til en algoritme | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvoteplassering/KvotesporsmalService.java:43` · `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/KvotesporsmalAlgoritmeService.java:64` |
| `@OPT-REG-KVO-002` | Knytte kvotespørsmål til kvotetype | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvotetype/KvotetypeMutations.java:64` · `fs-admin/src/domains/regelverk/features/Kvoteregelverk/components/Kvotesporsmal/Kvotesporsmal.tsx:99` |
| `@OPT-REG-KVO-002` | Knytte flere kvotespørsmål til samme kvotetype | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/KvotesporsmalSvarService.java:422` |
| `@OPT-REG-KVO-002` | Informasjon om automatisk plassering | ikke funnet | Søkte etter infotekst i `fs-admin/src/domains/regelverk/features/Kvoteregelverk` og `regelverk.json` (STEK-539) |
| `@OPT-REG-KVO-002` | Slette kvotespørsmål | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvoteplassering/KvotesporsmalService.java:102` · `fs-admin/src/domains/regelverk/features/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:186` |

## Retagget til @implemented

Ingen.

## Fortsatt ikke levert

- **`@OPT-REG-KVO-002` — Kvotespørsmål**: Informasjon om automatisk plassering — ikke funnet (STEK-539)
- **`@OPT-REG-KVO-002` — Kvotespørsmål**: Tilgjengelige algoritmer — usikker (fs-admin viser koden, ikke navnet)

## Oppfølging

- Et språk lagres bare når både navn og spørsmålstekst er fylt ut, ellers hoppes det over uten feilmelding.
- Beskrivelsene av algoritmene er seedet bare på nob og nno.
- Ingen step definitions i `tester/steps/` for kravet.
