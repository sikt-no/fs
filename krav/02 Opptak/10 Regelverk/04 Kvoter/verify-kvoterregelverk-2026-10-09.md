# Verifisering: Kvotetype

- **Dato:** 2026-10-09
- **Krav:** `krav/02 Opptak/10 Regelverk/04 Kvoter/kvoterregelverk.feature` (hele egenskapen, verifisert uansett status)
- **Kode:** `fs-plattform` (origin/main `dd2d886b2b`), `fs-admin` (origin/main `665c3b41a`)

## Oppsummering

- Retagget `@in-progress` → `@implemented`: 0 (egenskapen er `@draft`, og ikke alt er funnet)
- Fortsatt ikke levert: aldersgrensen bare på grunnlaget, og rangering etter kvoterangering. Kvoteprioritet, plassflyt og «i bruk»-melding mangler i fs-admin
- Slettet (`@deprecated`): 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-REG-KVO-001` | Opprette ordinær kvote | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvotetype/KvotetypeMutations.java:38` · `fs-admin/src/domains/regelverk/features/Kvoteregelverk/components/KvoteBasicInfoCard/KvoteBasicInfoCard.tsx:50` |
| `@OPT-REG-KVO-001` | Opprette førstegangsvitnemålskvote | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvotetype/KvotetypeMutations.java:38` |
| `@OPT-REG-KVO-001` | Flerspråklig navn på kvotetype | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvotetype/KvotetypeMutations.java:202` · `KvoteBasicInfoCard.tsx:88` |
| `@OPT-REG-KVO-001` | Sette default poengformel | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvotetype/KvotetypeMutations.java:47` · `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/PoengberegningService.java:328` |
| `@OPT-REG-KVO-001` | Sette kvoteprioritet | usikker | Backend lagrer og bruker prioriteten (`KvotetypeMutations.java:50`), men fs-admin har ikke noe felt for den |
| `@OPT-REG-KVO-001` | Sette default plassflyt | usikker | Backend lagrer og bruker plassflyten (`KvotetypeMutations.java:49`), men fs-admin har ikke noe felt for den |
| `@OPT-REG-KVO-001` | Koble grunnlag til kvotetype | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvotetype/KvotetypeMutations.java:183` · `fs-admin/src/domains/regelverk/features/Kvoteregelverk/components/KvoteGrunnlag/KvoteGrunnlag.tsx` |
| `@OPT-REG-KVO-001` | Aldersgrensen følger grunnlaget | ikke funnet | Aldersgrensen settes per kvotetype (`fs-admin/src/domains/regelverk/features/Kvoteregelverk/components/KvoteGrunnlag/KvoteGrunnlag.tsx:127`, `KvotetypeMutations.java:197`), og plasseringen leser bare `kvotetype_grunnlag.aldersgrense_default` |
| `@OPT-REG-KVO-001` | Kvotetype uten grunnlag og kvotespørsmål | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:146` |
| `@OPT-REG-KVO-001` | Kvoterangering | ikke funnet | Kvoterangeringen lagres (`KvotetypeMutations.java:46`), men leses ikke av noen kode som rangerer søkere. IH heter «Sivilingeniør, ingeniørhøgskole» i `V14__regelverk_grunndata.sql:20` |
| `@OPT-REG-KVO-001` | Slette kvotetype | funnet | `fs-admin/src/domains/regelverk/features/Kvoteregelverk/Kvoteregelverk.tsx:166` |
| `@OPT-REG-KVO-001` | Kan ikke slette kvotetype som er i bruk | usikker | Backend gir `KvotetypeIBrukError`, men fs-admin viser bare «Kunne ikke slette kvotetypen» (`Kvoteregelverk.tsx:174`) |

## Retagget til @implemented

Ingen.

## Fortsatt ikke levert

- **`@OPT-REG-KVO-001` — Kvotetype**: Aldersgrensen følger grunnlaget — ikke funnet
- **`@OPT-REG-KVO-001` — Kvotetype**: Kvoterangering — ikke funnet
- **`@OPT-REG-KVO-001` — Kvotetype**: Sette kvoteprioritet — usikker (ikke i fs-admin)
- **`@OPT-REG-KVO-001` — Kvotetype**: Sette default plassflyt — usikker (ikke i fs-admin)
- **`@OPT-REG-KVO-001` — Kvotetype**: Kan ikke slette kvotetype som er i bruk — usikker (generell feilmelding i fs-admin)

## Oppfølging

- `KvotetypeIT` tester «i bruk» med en referanse fra en annen kvotetype (plassflyt), ikke fra et utdanningstilbud.
- Ingen step definitions i `tester/steps/` for kravet.
