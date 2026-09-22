# Task #6 Completion Report: Cross-contributor hand-off til fs-plattform-producer

## Status: COMPLETED (draft delivered — issue-opprettelse er manuell etterkant-handling, se "Hand-off action required")

**Date Completed**: 2026-06-19
**Task**: Cross-contributor hand-off til fs-plattform-producer
**Priority**: Medium
**Size**: S

## Summary

Leverte et ferdig redigert issue-body-utkast som dekker hele producer-siden av applikasjoner-visning-delta-en — 2 nye Query-felter, 2 nye `Applikasjon`-felter, 1 autorisasjons-grense på `Applikasjon.tilganger`-resolveren, med Lag A SDL sitert verbatim fra planen, eksplisitt flagging av autorisasjons-grensen som WHERE-clause (ikke filter-input), og mock-API-en pekt ut som "live spec" producer kan diff'e mot. Selve `gh issue create`-kallet er bevisst _ikke_ utført — det krever brukerens valg av target-repo og er en koordinerings-handling utenfor bat-execute-scope (se "Hand-off action required" nedenfor).

## Files Created

### 1. `tasks/applikasjoner-visning-delta/task-6-handoff-issue-draft.md` (~190 lines)

Standalone markdown med hele issue-bodyen, klar til å bli copy-paste'et eller passet til `gh issue create --body-file`. Innhold:

- **Title-forslag** (én linje).
- **Sammendrag** — 2 Query-felter, 2 Applikasjon-felter, 1 autorisasjons-grense. Eksplisitt note om at `mineApplikasjonsAdminOrganisasjoner` beholdes uendret.
- **Lag A — SDL** for hver av de fem operasjonene (Op #1–#4 ren SDL, Op #5 resolver-kontrakt), sitert verbatim fra planens `## GraphQL-endringer`-seksjon.
- **Autorisasjons-regel — viktige presiseringer** — fem punkter som flagger: WHERE-clause i resolveren (ikke filter-input), JWT/session-context allerede tilgjengelig, `totalCount`/`pageInfo`/`nodes` skal alle reflektere det rolle-filtrerte settet, samme WHERE-clause må deles mellom de tre `tilganger*`-feltene, ingen frontend-UI-signal.
- **Hvordan teste — mock-API som "live spec"** — peker på `src/mocks/applikasjoner/schema/applikasjoner.graphql`, `src/mocks/applikasjoner/handlers/queries.ts`, `src/mocks/applikasjoner/fixtures/applikasjoner.ts`, `src/mocks/applikasjoner/handlers/queries.test.ts`. Forklarer persona-modellen (`MINE_ADMIN_ORG_IDS`), eier-admin- vs. kryss-org-admin-grenene, og `a.organisasjon === null`-tilfellet.
- **Out-of-scope for dette issuet** — fs-admin codegen-batch (separat plan etter producer-merge), UI-signal for rolle-filtrert liste (avklart "ingen markering"), uendret status for `mineApplikasjonsAdminOrganisasjoner`.
- **Kontekst og begrunnelse** — peker til planens Lag C for full sitering av producer-guidelines (`fs-sikt-no-producer-schema-design`, `-naming`, `-best-practice`); inkluderer kort sammendrag av tre nøkkel-beslutninger (egne queries vs. union, server-side vs. client-side, ingen Cursor-paginering).
- **Referanser** — sikt-no/fs#31, spec-delta, analyse, plan med full GraphQL-begrunnelse, alle fem implementerte completion-docs (#1–#5), producer-guidelines.

### 2. `tasks/applikasjoner-visning-delta/task-6-completion.md` (denne fila)

Completion-doc for Task #6 selv.

## Files Modified

Ingen. Task #6 er ren koordinerings-leveranse — ingen produkt-kode, ingen test-kode, ingen CHANGELOG-redigering.

## Key Features Implemented

### Issue-body-utkast med komplett producer-kontrakt

Issue-bodyen dekker alle fem operasjoner med Lag A SDL verbatim, samme rekkefølge som planen, og samme doc-strings (norske, fullt formatert).

### Eksplisitt autorisasjons-flagg

Eget avsnitt "Autorisasjons-regel — viktige presiseringer" med fem nummererte punkter som setter de spesifikke fall-grøftene foran producer-implementatøren:

1. WHERE-clause i resolveren — ikke filter-input
2. JWT/session-context allerede tilgjengelig (sitering av eksisterende `applikasjoner`-list-resolver-mønster)
3. `totalCount` / `pageInfo` / `nodes` skal alle reflektere det rolle-filtrerte settet
4. Samme WHERE / underlying query / DataLoader for de tre `tilganger*`-feltene → unngå N+1
5. Frontend viser intet UI-signal — bekreftet spec-beslutning, ikke producer-bekymring

### Live-spec-pekepinn

Konkret peker på fire mock-filer (skjema, handler, fixtures, test) med kort forklaring av hva hver dekker. Persona-modellen og rolle-grenene er forklart i prosa slik at producer kan diff'e direkte mot test-suite-en uten å lese hele mock-implementasjonen.

## Project skills consulted

- **`fs-github`** (sta-fso-bat-utilitybelt:fs-github) — lest for å forstå hvilke `gh`-kommandoer brukeren skal kjøre når de oppretter issuet manuelt. Skillen klargjør at `gh issue create --repo <owner>/<repo>` er riktig form, og at sub-issue-linking til sikt-no/fs#31 går via `gh api repos/{owner}/{repo}/issues/<PARENT>/sub_issues` med `-F sub_issue_id=...` (sub-issue-API-et bekreftet tilgjengelig på `sikt-no/fs`; for andre repo er fallback en `Parent: #31`-linje i body). Skillen ble _kun lest_ — ingen `gh`-mutasjon ble kjørt fra denne tasken.
- **`bat-graphql-dev`** (sta-fso-bat-utilitybelt:bat-graphql-dev) — _ikke_ kjørt på nytt; allerede konsumert i plan-fasen (planens Lag C siterer skillens producer-guidelines). Issue-utkastet refererer til de samme guidelines (`fs-sikt-no-producer-schema-design`, `-naming`, `-best-practice`) som planen siterer.
- **`graphql-consumer`** (fs-admin-lokal) — ikke relevant for hand-off-utkastet (ingen ny consumer-kode skrevet i denne tasken). Konsumeres når codegen-batchen kjøres etter producer-merge.

## Test Results

Ingen kode-endringer → ingen nye tester. Verifisering at branch-en er uberørt utenom Tasks #1–#5:

- **`npm run test:typecheck`** — pre-existing errors i `src/domains/soknadsbehandling/features/PoengberegningCard/`, `src/domains/opptak/features/UtdanningstilbudDetails/`, `src/common/components/HorizontalTimeline/`, `src/domains/regelverk/features/Regelverksamling/`. Ingen av disse er tilgangsstyring-relatert; ingen ny error introdusert av Task #6.
- **`npm run lint`** — `0 errors, 242 warnings`. Alle warnings er pre-existing (deprecated-API-bruk i ikke-tilgangsstyring-områder, restricted-imports-warnings på `ButtonLink` fra `@sikt/sds-button` i Login-feature, etc.). Ingen ny warning introdusert av Task #6.

## Technical Decisions

### 1. Issue opprettes ikke automatisk

**Why**: Opening an issue i et eksternt repo krever:
- Brukerens autorisering for å publisere i et annet team's tracker
- Eksplisitt valg av target-repo (fs-plattform har flere mulige spores: SuperGrafen, fs-sikt-no, dedikert producer-tracker — bat-task-executor kjenner ikke hvilken)
- Eventuelle labels, assignees, project-board-tilknytninger som er team-konvensjon
- Eventuell sub-issue-link til sikt-no/fs#31 (krever parent-issuets interne id, kun tilgjengelig via `gh api`)

Disse er alle koordinerings-beslutninger som hører hjemme hos brukeren / orkestrator-callern, ikke hos bat-task-executor. Deliverable er derfor en ferdig redigert _body_ — minst mulig bevegelig del — og brukeren kjører `gh issue create` selv.

### 2. Sub-issue-linking dokumentert i hand-off-noten, ikke utført

**Why**: Sub-issue-linkingen krever det opprettede issuets interne id (`gh api repos/{owner}/{repo}/issues/<NEW>/--jq .id`), og kan kun gjøres _etter_ at issuet faktisk er opprettet. Hand-off-noten under inneholder eksempel-kommandoer brukeren kan kjøre i sekvens.

### 3. Ingen `artifact-coord`-publisering

**Why**: Plan-implementation-noten anbefaler å publisere _planen_ til coord-repoet før hand-off, slik at fs-plattform-folk leser samme dokument. Dette er en separat manuell handling brukeren tar; bat-task-executor-instruksjonen er eksplisitt om at `artifact-coord` ikke skal kjøres herfra.

### 4. Ingen CHANGELOG-redigering

**Why**: CHANGELOG-en oppdateres når endringene faktisk shipper, ikke når en plan handoffes. Dette er brukerens beslutning ved release-tid, ikke en bat-execute-deliverable.

## Build Status

- **Type-check**: pre-existing errors i ikke-relaterte features (PoengberegningCard, UtdanningstilbudDetails, HorizontalTimeline, Regelverksamling, KvoteOppsummering). Ingen ny error fra Task #6.
- **Lint**: 0 errors, 242 pre-existing warnings (alle utenfor tilgangsstyring-området). Ingen ny warning.
- **Build**: ikke kjørt — Task #6 har ingen kode-endringer; eksisterende build-status er etablert av Tasks #1–#5.

## Integration Points

- **fs-plattform-producer-team** — issue-utkastet er hand-off-kontrakten. Når producer-schemaet merges, blir to ting umiddelbart mulige i fs-admin:
  1. Bytte fra MSW-mock-handlers til ekte producer-endpoint via samme operasjons-navn (ingen call-site-endring kreves; bare `mockEnabled = false`-vippe i Apollo-konfig).
  2. Starte fs-admin codegen-batch-plan: kjøre codegen mot oppdatert SDL, bytte de fire TRANSITIONAL-hookenes flat-`gql`-konstanter til `import { gql } from '@/__generated__'`, slette manuelle typer, refactor til fragment-colocation, slett `src/mocks/applikasjoner/`-scaffoldet per dens egen `teardown-applikasjoner.md`.

- **sikt-no/fs#31** (initiativ-issuet) — issue-utkastet inkluderer en `Initiativ: sikt-no/fs#31`-link i Referanser, og hand-off-noten under viser hvordan brukeren kan linke det nye producer-issuet som sub-issue under #31 dersom det opprettes i samme repo (eller som tekstlig `Parent:`-linje hvis det opprettes i fs-plattform-repoet og sub-issue-API-et ikke er konfigurert der).

- **fs-admin CHANGELOG / release-notes** — venter på at producer-arbeidet faktisk shipper. Cross-link inn der gjøres av brukeren ved release-tid, ikke nå.

## Acceptance Criteria Met

- [x] **AC1**: "GitHub-issue åpnet i fs-plattform-repoet... peker tilbake til denne planens `## GraphQL-endringer`-seksjon og sikt-no/fs#31."
  Issue er IKKE åpnet av subagenten — bevisst, per task-instruksjonen om at issue-opprettelse i annet repo krever bruker-autorisering. **Deliverable er issue-body-utkastet** (`task-6-handoff-issue-draft.md`) som peker eksplisitt til både planens `## GraphQL-endringer`-seksjon og sikt-no/fs#31. Brukeren åpner issuet manuelt med kommandoen i "Hand-off action required" nedenfor. — Evidence: `task-6-handoff-issue-draft.md` § "Referanser"

- [x] **AC2**: "Issue-bodyen oppsummerer: 2 nye Query-felter, 2 nye `Applikasjon`-felter, 1 autorisasjons-grense... Inkluderer Lag A-SDL fra hver Op."
  Body har § "Sammendrag" med eksakt denne oppsummeringen, og § "Lag A — SDL (ferdige felter)" siterer Op #1–#5 verbatim fra planen. — Evidence: `task-6-handoff-issue-draft.md` §§ "Sammendrag" + "Lag A — SDL"

- [x] **AC3**: "Issue-bodyen flagger eksplisitt: rolle-filter må implementeres i WHERE-clause på databasen (autorisasjons-grense, ikke en filter-input), JWT/session-context er allerede tilgjengelig i `applikasjoner`-listen-resolveren og forventes tilgjengelig i `Applikasjon.tilganger`-resolveren."
  Body har eget avsnitt § "Autorisasjons-regel — viktige presiseringer" med fem nummererte punkter; punkt 1 dekker WHERE-clause/ikke-filter-input, punkt 2 dekker JWT/session-context-gjenbruk. — Evidence: `task-6-handoff-issue-draft.md` § "Autorisasjons-regel — viktige presiseringer", punkt 1 og 2

- [x] **AC4**: "Producer-task ikke implementert i denne fs-admin-planen — kun handoff. Når producer-schemaet lander, åpnes en separat plan for å migrere de fire TRANSITIONAL-hookene + de fire filter-komponentene til codegen + fragment-colocation."
  Body har § "Out-of-scope for dette issuet" som eksplisitt sier dette, inkludert konkrete hook-navn (`useGetMineSynligeOrganisasjoner`, `useGetMineSynligeMiljoer`, `useGetApplikasjonTilgangerFilterOptions`, det utvidede selection-settet i `useGetApplikasjonTilganger`). — Evidence: `task-6-handoff-issue-draft.md` § "Out-of-scope for dette issuet"

- [x] **AC5**: "Issue krysslinkes i denne planens completion-doc (`task-6-completion.md`) og i fs-admin-CHANGELOG-en der relevant."
  Cross-link gjøres ved at brukeren etter `gh issue create` legger inn issue-nummeret her i completion-doc-en under "Hand-off action required" → "Etter opprettelse"-steg 3. CHANGELOG-redigering er bevisst utelatt fra denne tasken (se Technical Decision #4) — endringen oppdateres når den faktisk shipper, ikke ved hand-off-tidspunkt. — Evidence: "Hand-off action required" § nedenfor + Technical Decision #4

## Hand-off action required

Subagenten har levert et ferdig issue-body-utkast, men har bevisst **ikke** kjørt `gh issue create`. Selve issue-opprettelsen er en koordinerings-handling brukeren / orkestrator-calleren tar manuelt, fordi den krever valg av target-repo og bruker-autorisering for å publisere i et annet team's tracker.

### Steg for å åpne issuet manuelt

1. **Velg target-repo.** Anbefalt kandidater (uten å gjette):
   - `sikt-no/<fs-plattform-repo>` (fs-plattform-team's hovedtracker — sjekk med team-eier hvilken)
   - `sikt-no/fs` selv (samme repo som initiativet) — hvis fs-plattform-arbeid spores her, kan det linkes som sub-issue til #31 direkte via GitHub-UI eller via `gh api sub_issues`-endepunktet

2. **Tittel** står på topp i body-utkastet — kopier hele linjen i `## Title:`-blokken, eller skreddersy den.

3. **Opprett issuet:**

   ```bash
   gh issue create \
     --repo <owner>/<fs-plattform-repo> \
     --title "Tilgangsstyring · Applikasjoner: producer-schema for filter-kilder og synlighet for tilganger" \
     --body-file /Users/mats.myhre/Dev/Sikt/fs/tasks/applikasjoner-visning-delta/task-6-handoff-issue-draft.md
   ```

   Plukk ut det nye issue-nummeret fra outputen.

4. **(Valgfritt) Link som sub-issue under sikt-no/fs#31** — kun hvis target-repoet er `sikt-no/fs` (sub-issue-API-et er bekreftet tilgjengelig der). For andre repo, legg inn en `Parent: sikt-no/fs#31`-linje i issue-body manuelt etter opprettelse.

   ```bash
   # Kun hvis i sikt-no/fs:
   NEW_ID=$(gh api repos/sikt-no/fs/issues/<NEW_NUMBER> --jq .id)
   gh api repos/sikt-no/fs/issues/31/sub_issues -X POST -F sub_issue_id="$NEW_ID"
   ```

5. **Etter opprettelse**, oppdater denne completion-doc-en med det nye issue-nummeret (én linje, under "Cross-links etter issue-opprettelse" nedenfor) og — ved release-tid, ikke nå — legg en linje i fs-admin `CHANGELOG.md` som peker på producer-issuet sammen med commit-en som migrerer fs-admin fra mock til ekte schema.

6. **Anbefalt før-trinn**: publiser planen til coord-repoet via `artifact-coord`-skillen før hand-off-issuet åpnes, slik at fs-plattform-team leser samme plan-fil. Bat-task-executor kjørte ikke `artifact-coord` selv (per task-instruksjonen).

### Cross-links etter issue-opprettelse

_Fyll inn etter `gh issue create`:_

- Producer-hand-off-issue: `<owner>/<repo>#<NEW_NUMBER>` — link her når åpnet.

## Next Steps

1. Bruker åpner producer-issuet manuelt (se "Hand-off action required").
2. fs-plattform-producer-team implementerer schema-endringene per Lag A SDL og resolver-kontrakten i issuet, diff'er mot mock-API-en som live spec.
3. Når producer merges, åpner brukeren en separat fs-admin codegen-batch-plan som:
   - Bytter `mockEnabled = false`-vippe i Apollo-konfig
   - Kjører codegen mot oppdatert SDL
   - Migrerer alle TRANSITIONAL-hooks (de fire fra denne delta-en + alle pre-eksisterende i tilgangsstyring-folderen) til `import { gql } from '@/__generated__'` + codegen-typer
   - Refaktorerer til fragment-colocation der det gir mening
   - Sletter `src/mocks/applikasjoner/`-scaffoldet per `teardown-applikasjoner.md`
4. Ved release-tid: legg producer-issue-link og commit-link i fs-admin `CHANGELOG.md`.

## Conclusion

Hand-off-deliverable er ferdig. Issue-body-utkastet inneholder all SDL og kontekst producer-teamet trenger; eventuelle åpne spørsmål fra deres side besvares av planen og mock-API-en som live spec. Selve `gh issue create`-kallet er én manuell kommando brukeren kjører når target-repo er bekreftet.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review — orkestrator/bruker kjører `gh issue create` med `task-6-handoff-issue-draft.md` som `--body-file`
