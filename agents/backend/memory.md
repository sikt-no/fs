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
