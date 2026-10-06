# Verifisering: fjerne_roller.feature

- **Dato:** 2026-10-06
- **Krav:** `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/fjerne_roller.feature`
- **Kode:** `fs-admin`, `fs-plattform`

## Oppsummering

- Retagget `@planned` → `@implemented`: 1 (`@BRU-PER-GRU-012`). Statusen var `@planned`, selv om fila sto i `spec/spec-grunnleggende-brukeradministrasjon.md` og koden var bygget (under GRU-003/009).
- Fortsatt `@in-progress`: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Avvik håndtert som bug: 1 ([BAT-275](https://sikt.atlassian.net/browse/BAT-275))

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-012` | Fjerne en rolle for valgt organisasjon og miljø | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/components/FjernRolleModal/FjernRolleModal.tsx:387` · `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/FeideBrukerTilgangService.java:97` · `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0057-tildelinger-splittes-etter-subjekttype.sql:372` |
| `@BRU-PER-GRU-012` | Fjerne en aktiv rolle fra en personbruker | funnet | `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0057-tildelinger-splittes-etter-subjekttype.sql:372` (tildelingen avsluttes) |
| `@BRU-PER-GRU-012` | Fjerne flere roller samtidig | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/components/FjernRolleModal/FjernRolleModal.tsx:408` · `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/hooks/useFjernFeideBrukerTilganger.tsx:155` |
| `@BRU-PER-GRU-012` | Fjerning er ikke tilgjengelig for roller uten rettighet | funnet | Serveren håndhever rettigheten: `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0057-tildelinger-splittes-etter-subjekttype.sql:353`. Avvik i dialogen (miljøer uten rettighet kan velges, `FjernRolleModal.tsx:110`) håndteres som bug: [BAT-275](https://sikt.atlassian.net/browse/BAT-275) |
| `@BRU-PER-GRU-012` | Fjerning er begrenset til organisasjoner jeg administrerer | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/components/FjernRolleModal/FjernRolleModal.tsx:109` · `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0057-tildelinger-splittes-etter-subjekttype.sql:123` |
| `@BRU-PER-GRU-012` | Tilganger som kom fra rollen faller bort | funnet | `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0057-tildelinger-splittes-etter-subjekttype.sql:392` · test `tilgangsstyring-new-db/src/test/sql/18_arv_lukning.sql` |
| `@BRU-PER-GRU-012` | Tilgang som også er tildelt direkte består | funnet | `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0057-tildelinger-splittes-etter-subjekttype.sql:372` (bare tildelingen av rollen avsluttes) |

Utenfor gating-settet (`@draft @openquestion`): regelen «Fjerning av roller lagres i historikk» med scenarioene «Fjerning av en rolle lagres i historikk» og «Hver fjerning lagres individuelt i historikk». Lagringen finnes (`0024-sporing-delte-aktorkolonner.sql:217`), men hvem som skal se historikken, hvor lenge den lagres og avsjekk med juss er ikke avklart.

## Retagget til @implemented

| Feature-ID | Egenskap | Fil | Gating funnet |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-012` | Fjerne roller fra en personbruker | `fjerne_roller.feature` | 7 av 7 |

## Endringer i kravteksten (besluttet av produkteier 2026-10-06)

- Historikk-stegene er flyttet fra «Fjerne en aktiv rolle fra en personbruker» og «Fjerne flere roller samtidig» til en ny `@draft @openquestion`-regel. Historikk skal bare lagres; visning løses i egne oppgaver.
- De seks åpne spørsmålene på egenskapen er lukket: fjerning fra deaktivert personbruker er tillatt; rettigheten er brukeradministrator-rollen for organisasjonen (og miljøet); dialogen slik den er i koden er bekreftelsen; data personbrukeren har opprettet er utenfor scope; ingen varsling; ingen visning av konsekvens før fjerning.

## Oppfølging

- [BAT-275](https://sikt.atlassian.net/browse/BAT-275): miljøvelgeren i dialogen for å fjerne (og trolig tildele) roller viser miljøer uten rettighet.
- Ingen step definitions i `tester/steps/` for scenarioene.
