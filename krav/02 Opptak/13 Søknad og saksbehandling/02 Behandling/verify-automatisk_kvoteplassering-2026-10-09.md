# Verifisering: Automatisk kvoteplassering

- **Dato:** 2026-10-09
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvoteplassering.feature` (hele egenskapen, verifisert uansett status)
- **Kode:** `fs-plattform` (origin/main `dd2d886b2b`), `fs-admin` (origin/main `665c3b41a`)

## Oppsummering

- Retagget `@in-progress` → `@implemented`: 0 (egenskapen er `@draft`, og ikke alt er funnet)
- Fortsatt ikke levert: aldersgrensen på grunnlaget, at kvotespørsmål ikke stilles når aldersgrensen ikke er møtt, og visning av opptaksalderen i fs-admin
- Slettet (`@deprecated`): 0
- Regelen «Alderen beregnes fra opptakets dato for aldersberegning» er flyttet til `11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature` (`@OPT-OVO-FRI-001`), og verifisert der: `verify-frister_og_hendelser-2026-10-09.md`

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-012` | Plassering i kvote uten kvotespørsmål | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:138` · `fs-admin/src/domains/soknadsbehandling/features/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:52` |
| `@OPT-BEH-BEH-012` | Søkeren er ikke kvalifisert på grunnlaget | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:326` |
| `@OPT-BEH-BEH-012` | Kvote uten kvotespørsmål vises ikke blant kvotespørsmålene | funnet | `fs-admin/src/domains/soknadsbehandling/features/KvoteplasseringCard/KvoteplasseringCard.tsx:91` |
| `@OPT-BEH-BEH-012` | Grunnlag som ikke er koblet til kvotetypen | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SoknadKvoteOppretterService.java:150` |
| `@OPT-BEH-BEH-012` | Aldersgrense på grunnlaget | usikker | Operatorene stemmer (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvoteplassering/Aldersgrense.java:32`), men plasseringen leser `kvotetype_grunnlag.aldersgrense_default` (`KvoteplasseringGrunnlagService.java:285`), ikke `grunnlag.aldersgrense` |
| `@OPT-BEH-BEH-012` | Kvotespørsmål stilles ikke når aldersgrensen ikke er møtt | ikke funnet | Bare plasseringen blokkeres (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/KvotesporsmalSvarService.java:377`). `sak_kvote` aktiveres uten alderssjekk, og fs-admin viser spørsmålet |
| `@OPT-BEH-BEH-012` | Alle kvotespørsmål besvart ja | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/KvotesporsmalSvarService.java:422` |
| `@OPT-BEH-BEH-012` | Ett kvotespørsmål besvart nei | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/KvotesporsmalSvarService.java:428` |
| `@OPT-BEH-BEH-012` | Kvotespørsmålene vises i søknadsbehandlingen | funnet | `fs-admin/src/domains/soknadsbehandling/features/KvoteplasseringCard/KvoteplasseringCard.tsx:113` |
| `@OPT-BEH-BEH-012` | Samme kvotespørsmål på flere kvotetyper vises én gang | funnet | `fs-admin/src/domains/soknadsbehandling/features/KvoteplasseringCard/KvoteplasseringCard.tsx:88` (svaret spres av frontend, ikke backend) |
| `@OPT-BEH-BEH-012` | Automatisk besvart kvotespørsmål vises låst | funnet | `fs-admin/src/domains/soknadsbehandling/features/KvoteplasseringCard/KvotesporsmalRow.tsx:54` |
| `@OPT-BEH-BEH-012` | Svar på automatisk kvotespørsmål avvises i API-et | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/KvotesporsmalSvarService.java:134` |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering i endringsloggen | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/audit/AuditContext.java:103` · `fs-admin/src/domains/soknadsbehandling/features/AuditLogCard/AuditLogItem/AuditLogItem.tsx:63` |
| `@OPT-BEH-BEH-012` | Kvoteplasseringen viser opptaksalderen | usikker | Backend skriver opptaksalderen i `Kvoteplassering.merknadAutomatisk` (`KvoteplasseringGrunnlagService.java:208`), men fs-admin henter bare `kvotesporsmalSvar.merknadAutomatisk` (`KvoteplasseringCard.tsx:29`) |

## Retagget til @implemented

Ingen.

## Fortsatt ikke levert

- **`@OPT-BEH-BEH-012` — Automatisk kvoteplassering**: Aldersgrense på grunnlaget — usikker (grensen leses fra kvotetypen)
- **`@OPT-BEH-BEH-012` — Automatisk kvoteplassering**: Kvotespørsmål stilles ikke når aldersgrensen ikke er møtt — ikke funnet
- **`@OPT-BEH-BEH-012` — Automatisk kvoteplassering**: Kvoteplasseringen viser opptaksalderen — usikker (finnes i API, ikke i fs-admin)

## Oppfølging

- Ingen step definitions i `tester/steps/` for kravet.
- Erstatter `verify-automatisk_kvoteplassering-2026-10-08.md`, som gjaldt en eldre versjon av fila (med feature-ID `@OPT-BEH-BEH-007`) og før STEK-557 var merget.
