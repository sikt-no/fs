# backend agent — memory

Append-only journal. Each turn appends a new `##` entry. Never edit prior entries; never rewrite history. Entries are read by the `frontend` counterpart from the tail to catch up.

Entry format:

```
## YYYY-MM-DDTHH:MMZ — backend
- worked on: <issue-ref or topic>
- blocked: <issue-ref opened against frontend, if any>
- next: <what's queued for the next turn>
```

---

## 2026-05-02T00:00Z — backend
- worked on: seeded by frontend during bootstrap of agent-coord layout
- blocked: none
- next: first real turn — sync-in via skill, surface blockers, work on chosen issue

## 2026-05-28T13:20Z — backend
- worked on: applikasjoner backend ingest analysis (pure-local, no GitHub issue). Mock SDL `docs/ingest/applikasjoner.graphql` on the fs-admin side; this analysis lands the ingest direction in `tilgangsstyring/`. Published `agents/backend/2026-05-28-applikasjoner-backend-ingest/analysis.md` with 8 decisions: `@asConnection` over hand-written connections, `IdentitetsleverandorType.FS` → `MASKINBRUKER`, federate `Organisasjon` (`@key(fields:"id")`) but trim audit shapes (`ApplikasjonPerson { id, navn }`), `Applikasjon` + `ApplikasjonTilgang` as full federation entities, `kanX` flags via Java resolver, per-column DB audit (`status` / `miljoer` / `sist_brukt` / `endretTidspunkt` nullability / `eksternId` per-subtype mapping as concrete bat-plan gaps), `ansvarligKandidater` hybrid (cache-first + Feide-API fallback + upsert-on-assignment), `byttApplikasjonPassord` is Maskinporten-only (rotates client_secret via Maskinporten Admin API, not `PassordService`).
- blocked: none — analysis is complete; bat-plan is the natural next step.
- next: bat-plan to turn the 8 decisions and the column-audit gap list into concrete tasks. Cross-agent ask for fs-admin (frontend) will be filed by bat-plan once the plan exists: confirm enum rename `FS → MASKINBRUKER`, confirm connection-shape switch to `@asConnection`-generated types, confirm `Organisasjon`-federation in queries, confirm `byttApplikasjonPassord` is Maskinporten-only on the UI side.

## 2026-05-29T06:31Z — backend
- worked on: `/sta-fso-bat-utilitybelt:bat-plan` on slug `applikasjoner-backend-ingest`. Translated the 7 (8 with the corrigendum) decisions from `analysis.md` into a 13-task work-breakdown. Published `agents/backend/2026-05-28-applikasjoner-backend-ingest/plan.md` next to the existing analysis. Plan covers: DDL extensions (`deaktivert_tidspunkt`, optional `Organisasjon.navn`), SQL view `applikasjon_v` to unify `eksternId` across the three subtype tables, jOOQ regen, federation `Organisasjon`, full `schema_applikasjoner.graphqls` with `@asConnection` + `@key` + `@externalField` for `kanX`, payload + error record classes, three new services (`ApplikasjonService`, `MaskinportenHemmelighetsService`, `AnsvarligKandidatService`), `KanFlagsResolver`, condition/filter classes, approval tests, and the producer-side SDL update for `docs/ingest/applikasjoner.graphql`. Plan-level resolutions added for the DDL gaps the analysis surfaced: `status` derived from `deaktivert_tidspunkt`, `miljoer` derived from active `subjektrolletildeling`, `sistBrukt` ships nullable (no event source yet), `endretTidspunkt` relaxed to nullable, `eksternId` unified via view, `iso6523_actorid_upis` absent. Self-authored `## GraphQL-endringer`-section citing Graphitron call sites in the repo — did not invoke `bat-graphql-dev` as a separate skill (decisions were exhaustively recorded in the analysis already; producer-guidelines citations were derivable from the codebase).
- handed off: filed [sikt-no/fs#469](https://github.com/sikt-no/fs/issues/469) against `agent:fs-admin-mats` asking for producer-side SDL sign-off on three items: (1) `IdentitetsleverandorType.FS` → `MASKINBRUKER`, (2) delete hand-written `*Connection`/`*Edge`/`PageInfo` in favour of `@asConnection`, (3) relax `endretTidspunkt` to nullable. Body links to the whole feature folder so fs-admin-mats reads `analysis.md` + `plan.md` together. Two other candidate hand-offs (iso6523 exposure, tildelbar definition) were surfaced to the user but explicitly deferred — user chose to file only the producer-SDL sign-off this turn.
- next: backend implementation can start on Tasks #1 (DDL extensions + `Organisasjon.navn` decision) and #2 (`applikasjon_v` view) immediately — no fs-admin dependency. Task #13 (producer-SDL update) waits on #469. Task #8 (`MaskinportenHemmelighetsService`) has an out-of-band prerequisite: confirm Sikt's Maskinporten service-token can call the Admin API for client-secret rotation, or provision a new credential — not yet investigated.
