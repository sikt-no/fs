# Task #5 Completion Report: Verifiser persona-override cache-flush dekker nye queries

## Status: COMPLETED (static verification — manual e2e remains as documented procedure)

**Date Completed**: 2026-06-19
**Task**: Verifiser persona-override cache-flush dekker nye queries
**Priority**: Medium
**Size**: S

## Summary

Static, code-level verification that `usePersonaOverride.applyPersonaChange` correctly invalidates Apollo cache for the four new/persona-sensitive queries introduced by Tasks #1–#4 (`mineSynligeOrganisasjoner`, `mineSynligeMiljoer`, `applikasjonTilgangerFilterOptions`, `applikasjonMedTilganger`). The mechanism (`apolloClient.refetchQueries({ include: 'active', updateCache: (cache) => cache.reset() })`) is intact, every new operation has a named `query` Apollo can identify as "active", and no `typePolicy` in `cacheConfig.ts` retains state for these fields across `cache.reset()`. No new cache invalidation code is required. A manual e2e verification procedure is documented for the user / QA to execute against a dev/review build.

This task is verification-only — no product code was modified.

## Files Created

None.

## Files Modified

None.

## Files Read (verification scope)

1. `src/common/lib/persona/hooks/usePersonaOverride.ts` — cache-flush implementation.
2. `src/common/lib/auth/providers/GlobalUserProvider.tsx` — confirms the hook is wired at the app-root provider level.
3. `src/features/EnvironmentIndicator/Personas/Personas.tsx` — confirms the persona override UI is available in dev/review/test environments via the `personas` feature flag.
4. `src/features/EnvironmentIndicator/EnvironmentIndicator.tsx` — confirms the gating envelope around the `Personas` UI.
5. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeOrganisasjoner.tsx` (Task #2).
6. `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineSynligeMiljoer.tsx` (Task #2).
7. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilgangerFilterOptions.tsx` (Task #4 variant (b)).
8. `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilganger.tsx` (existing, now persona-sensitive).
9. `src/common/hooks/useDataListQuery/useDataListQuery.tsx` — the `fetchPolicy` wrapper used by `useGetApplikasjonTilganger`.
10. `src/common/lib/apollo/cacheConfig.ts` — verified no `typePolicy` retains state across `cache.reset()` for the four operations.

## Key Findings

### 1. `usePersonaOverride.applyPersonaChange` is intact and wired

`src/common/lib/persona/hooks/usePersonaOverride.ts:32-53`:

```ts
const applyPersonaChange = useCallback(
  async (persona: UserPersona | null) => {
    const nextOverride: UserOverride = {
      isActive: !!persona,
      selectedPersona: persona ?? undefined,
    }
    syncPersonaToHeaders(persona ?? undefined)
    persistPersonaToCookie(nextOverride)
    try {
      await apolloClient.refetchQueries({
        include: 'active',
        updateCache: (cache) => {
          void cache.reset()
        },
      })
    } catch (error) {
      console.error('Error refetching Apollo queries after persona change:', error)
    }
    setOverride(nextOverride)
  },
  [apolloClient],
)
```

The hook is consumed by `GlobalUserProvider` (`src/common/lib/auth/providers/GlobalUserProvider.tsx:38`) which sits at the top of the app's provider stack — so every page that mounts a tilgangsstyring filter or list inherits the same `apolloClient` instance the hook flushes.

The `Personas` UI (`src/features/EnvironmentIndicator/Personas/Personas.tsx:33`) calls `adminOverride.setPersona(persona ?? null)`, which delegates to `applyPersonaChange` — so the cache-flush path is exercised on every persona switch in dev/review/test.

### 2. The four hooks declare named operations Apollo recognizes as "active"

Each `gql` block ships a unique operation name; `apolloClient.refetchQueries({ include: 'active' })` matches every observed query by its operation name.

| Hook file | Operation name | `fetchPolicy` |
|---|---|---|
| `useGetMineSynligeOrganisasjoner.tsx:27` | `mineSynligeOrganisasjoner` | `cache-first` |
| `useGetMineSynligeMiljoer.tsx:27` | `mineSynligeMiljoer` | `cache-first` |
| `useGetApplikasjonTilgangerFilterOptions.tsx:43` | `applikasjonTilgangerFilterOptions` | `cache-first` (with `skip: !applikasjonId`) |
| `useGetApplikasjonTilganger.tsx:39` (wraps `useDataListQuery`) | `applikasjonMedTilganger` | `cache-first` + `nextFetchPolicy: 'cache-first'` (via `useDataListQuery.tsx:53-54`) |

**`fetchPolicy: 'cache-first'` does NOT block `refetchQueries`.** `refetchQueries` is an explicit, imperative refetch path that bypasses the cache and re-issues each matching query against the network — the cache-first policy controls how the *initial* read resolves, not how a refetch resolves. In addition `cache.reset()` empties the normalized store, so even if the runtime fell back to a cache read, the cache for those operations would be empty and the read would miss → trigger a network round-trip. The double-coverage (`refetchQueries` re-runs the queries AND `cache.reset()` empties the store) is the precise reason analyse-beslutning #4 and plan-decision #4 conclude no additional `cache.evict` is needed.

### 3. `cacheConfig.ts` does not retain state across `cache.reset()` for any of the four operations

`src/common/lib/apollo/cacheConfig.ts:41-77` declares only two relevant `typePolicy` field-policies:

- `Query.applikasjoner: nodesCursorPagination(['filter', 'orderBy'])` — applies to the top-level list, not to any of the four queries verified here.
- `Applikasjon.tilganger: nodesCursorPagination(['filter', 'orderBy'])` — applies to the connection inside `applikasjonMedTilganger`. The `merge` function in `nodesCursorPagination` concatenates nodes for cursor pagination but does NOT persist data across `cache.reset()` (which wipes the entire normalized store, including all `Applikasjon:id.tilganger:*` entries).

There is **no field-policy** on `Query.mineSynligeOrganisasjoner`, `Query.mineSynligeMiljoer`, `Applikasjon.tilgangerMiljoer`, or `Applikasjon.tilgangerOrganisasjoner`. They default to the standard Apollo policy: the value is stored under the normalized identity of its parent (`ROOT_QUERY` or `Applikasjon:<id>`) and is fully wiped by `cache.reset()`.

Per analyse-beslutning #4 and plan-decision #4, the cache-key for `Applikasjon.tilganger` deliberately does NOT include persona — because the rolle-filter is a server-side authorization boundary that is consistently re-evaluated on every refetch. The `cache.reset() + refetchQueries({ include: 'active' })`-pair is the mechanism that makes the absence of a persona key-arg safe.

### 4. No `nextFetchPolicy` or other config trumps refetch

- `useGetMineSynligeOrganisasjoner`, `useGetMineSynligeMiljoer`, `useGetApplikasjonTilgangerFilterOptions` — only `fetchPolicy: 'cache-first'` is set; no `nextFetchPolicy`, no `notifyOnNetworkStatusChange: false`, no custom `client` instance.
- `useGetApplikasjonTilganger` uses `useDataListQuery` which sets `nextFetchPolicy: 'cache-first'` (`useDataListQuery.tsx:54`) — this also does not block `refetchQueries`. `nextFetchPolicy` governs what happens after the *first* completed query for that observable; it controls subsequent automatic re-reads (e.g. when variables change), not imperative `refetchQueries` calls.

None of the four hooks pin a fetch policy that prevents refetch on active queries.

## Project skills consulted

- `graphql-consumer` — re-read to verify the new operation-naming convention and the fact that `useQuery`-observed queries with named operations are matched by `refetchQueries({ include: 'active' })`. The four hooks all use named operations, so this acceptance criterion holds.
- `fs-admin-list-filters` — sanity-checked the filter wiring against the chip-strip / dropdown contract; not load-bearing for this task because we're not changing call-sites, just verifying the existing wiring around them.

No other repo-local skill matched this verification task (no UI is being authored, only static review and procedure-documentation).

## Test Results

This is a **verification task** — no product code was modified, so no new tests were written. Baseline build health was confirmed against the active branch:

- `npm run test:typecheck` — produces errors **only** in `src/domains/soknadsbehandling/features/PoengberegningCard/utils/validatePoints.test.ts` (unrelated to this delta — pre-existing test-file typing issue in a different domain). Filtering for `tilgangsstyring|persona|cacheConfig|usePersonaOverride` produces zero hits.
- `npm run lint` — `0 errors, 242 warnings`. None of the warnings touch the persona override hook, the four new hooks, or `cacheConfig.ts`.

### Manual e2e verification procedure (for the user / QA)

The acceptance criteria for this task include manual e2e verification in a development build. Since this subagent has no browser, the procedure is documented here for the user / QA to execute:

**Prerequisites**
- A running dev / review / test build of fs-admin (`npm run dev`, or any non-production environment URL — `studieadm-fs-admin-*.sokrates.edupaas.no`, `test-fsadmin.sikt.no`, `localhost:3000`). The `Personas` UI is gated by the `personas` feature flag, which is force-enabled in those three environments only (`EnvironmentIndicator.tsx:18-23`). It will not appear in production.
- Be logged in via Feide.

**Procedure A — Listevisning filter-dropdowns**

1. Navigate to `/tilgangsstyring/applikasjoner` (the applikasjoner-listevisning).
2. Locate the persona-override `<select>` in the top `EnvironmentIndicator`-bar (top of the page in dev/review/test builds). It is labelled with the current user's name + organisation.
3. Note the option-set in the **organisasjon** and **miljø** filter dropdowns in the sidebar — write down or screenshot the current options.
4. Switch persona via the dropdown to a different test persona (different `organisasjonsnummer` / `beskrivelse`).
5. Wait for the network requests to settle (Apollo will trigger `refetchQueries({ include: 'active' })`).
6. Re-open the **organisasjon** and **miljø** filter dropdowns.

**Expected**: the option-sets reflect the new persona's `mineSynligeOrganisasjoner` / `mineSynligeMiljoer`. If the new persona is a `org-sikt` admin and the previous was a cross-org-only admin (or vice versa), the visible options should differ.

**Fail criteria**: dropdowns still show the previous persona's option-set, or dropdowns are empty when they should not be, or the dropdowns show a stale chip (selected value) that is no longer in the new option-set.

**Procedure B — Tilganger-tab on an applikasjon detail page**

1. From the listevisning, click into one applikasjon row to land on `/tilgangsstyring/applikasjoner/[id]`.
2. Switch to the `Tilganger` tab.
3. Note the current row count, the visible organisasjoner in the rows, and the option-sets in the `ApplikasjonTilgangerMiljoFilter` + `ApplikasjonTilgangerOrganisasjonFilter` dropdowns.
4. Switch persona via the `EnvironmentIndicator` dropdown.
5. Wait for the network requests to settle.
6. Re-inspect the row count, visible organisasjoner, and dropdown option-sets.

**Expected**:
- The row count reflects the new persona's rolle-filter. An eier-admin for the applikasjon's eier-organisasjon sees all tilganger; a cross-org admin sees only tilganger whose `tilgang.organisasjon.id ∈ MINE_ADMIN_ORG_IDS` for the new persona.
- The miljø + organisasjon filter dropdowns reflect the *new* rolle-filtrerte set: the options that appear are exactly those represented in the new row-set.

**Fail criteria**:
- Row count is unchanged when the new persona has a different rolle-scope.
- Filter dropdowns still show options from the previous persona's rolle-scope.
- Selected filter chips (if any were active) reference values no longer in the new option-set.

**If the persona-override UI is not available (production-only build)**

Per the plan's Task #5 implementation notes, fall back to direct devtools invocation:

```js
// In browser devtools console:
window.__APOLLO_CLIENT__.refetchQueries({
  include: 'active',
  updateCache: (cache) => { cache.reset() }
})
```

This is the exact code path `applyPersonaChange` runs. If this triggers a refetch and new data arrives, the mechanism is verified. (Note: this won't change the underlying persona; it only verifies the Apollo-side mechanism.)

## Technical Decisions

### 1. No new `cache.evict` introduced

**Why**: The static review confirms the existing `cache.reset() + refetchQueries({ include: 'active' })`-pair fully invalidates all normalized entries for the four queries and re-issues each as a live network request with the new persona headers (`syncPersonaToHeaders` runs *before* `refetchQueries`, so the next round-trip carries the new identity). Adding a `cache.evict(Applikasjon:id.tilganger*)`-call would be redundant — the entire normalized store is already wiped one line earlier.

### 2. No `key-args` extension on persona

**Why**: Per plan-decision #4 / analyse-beslutning #4, persona is deliberately NOT a query key-arg. Doing so would (a) leak persona identity into the query identity (a privacy / observability anti-pattern), (b) defeat the cache-reset mechanism's purpose by making the cache key partition along an axis that's already invalidated wholesale, and (c) couple frontend cache semantics to an authorization concept that belongs strictly on the server.

### 3. The four hooks' `fetchPolicy: 'cache-first'` is correct as-is

**Why**: `cache-first` is the right default for these queries (small, bounded, low-mutation-rate, shared across multiple components per page). It does NOT prevent `refetchQueries` from re-issuing the operation — `refetchQueries` is imperative and bypasses cache regardless of the observable's normal fetch policy. The only edge that could prevent refetch would be a `fetchPolicy: 'cache-only'`, which none of the hooks set.

## Build Status

- `npm run test:typecheck` — passes for everything in our delta scope (the only failures are pre-existing in `src/domains/soknadsbehandling/.../validatePoints.test.ts`, unrelated to this task).
- `npm run lint` — `0 errors, 242 warnings` (warnings unrelated).
- No new linter warnings introduced.
- No new imports added.

## Integration Points

This task does not introduce any integration. It verifies that the existing integration between:

1. The persona-override mechanism (`usePersonaOverride.applyPersonaChange`, wired at `GlobalUserProvider`)
2. The Apollo cache (`cacheConfig.ts`)
3. The four new/persona-sensitive queries (Tasks #1–#4)

…remains consistent after the delta's new queries land. The verification confirms the chain is intact end-to-end at the code level.

## Acceptance Criteria Met

- [x] **Manual verifikasjon i development-build (procedure documented for QA)** — Procedure A above. Cannot be executed by this subagent (no browser); documented for execution against any dev/review/test build.
- [x] **Samme verifikasjon på en applikasjons tilganger-tab (procedure documented for QA)** — Procedure B above.
- [x] **Dokumenter at `usePersonaOverride.applyPersonaChange` (`src/common/lib/persona/hooks/usePersonaOverride.ts:32-53`) håndterer cache-flush korrekt for de nye queriene, og at ingen ny `cache.evict` er nødvendig** — see Key Findings §1–§3. Evidence: code quoted at `usePersonaOverride.ts:32-53`; `cacheConfig.ts:41-77` confirms no field-policy retains state; the four hooks all declare named operations Apollo matches via `include: 'active'`.
- [x] **Hvis verifikasjon avdekker at en query ikke re-fetches → åpne en separat task; ikke bake fix inn i denne** — Static review surfaces no defect. No follow-up task needed (see "Recommended follow-up tasks" below).

## Recommended follow-up tasks

**None.** The static review surfaced no bug, no edge case, and no missing operation name. All four hooks are properly named, properly observed by Apollo, properly typed, and properly covered by `cacheConfig.ts` (or correctly NOT covered, where coverage would be wrong).

If the manual e2e procedure (above) surfaces a real refetch failure when QA runs it, a separate task should be opened — but at the code level there is no reason to expect one.

## Next Steps

- **Operator / QA**: execute the manual verification procedure (Procedure A + Procedure B above) against a dev/review/test build before merging this delta to main. Document the result in this task's review thread or as an addendum to this completion doc.
- **Task #6**: cross-contributor hand-off to fs-plattform-producer can proceed in parallel; it does not depend on this task's manual verification result.
- **Future codegen-batch refactor**: when the producer schema lands and the TRANSITIONAL hooks are migrated to codegen, this verification should be re-run to confirm the same operation names are emitted by codegen and that the cache-flush still matches them.

## Conclusion

`usePersonaOverride.applyPersonaChange` correctly handles cache-flush for the four new/persona-sensitive queries introduced by Tasks #1–#4. The mechanism is intact, the operations are named, the cache configuration cooperates, and no new code is required. The manual verification procedure is documented for the operator / QA to execute against a dev/review/test build. Static-review conclusion matches plan-decision #4 and analyse-beslutning #4 exactly.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review (pending manual e2e verification by user / QA)
