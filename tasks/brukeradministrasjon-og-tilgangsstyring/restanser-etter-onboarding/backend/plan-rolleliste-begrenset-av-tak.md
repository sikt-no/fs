# Plan: The role list in «Tildel roller» is limited by the delegation cap (backend)

> Produced by `bat-plan` on 2026-10-29 for the backend role (fs-plattform, tilgangsstyring), from
> [`analysis-rolleliste-begrenset-av-tak.md`](analysis-rolleliste-begrenset-av-tak.md). Checked
> against fs-plattform `origin/main` @ `b2b61dbbb1` and the open MRs the same day.
> Rule: BRU-PER-GRU-003, «Valglisten for rolle viser bare roller som er i taket til en applikasjon i
> valgt organisasjon og miljø» (BAT-326, [PR #866](https://github.com/sikt-no/fs/pull/866)).

## Proposed Solution

### Architecture Approach

An opt-in boolean on `MineTildelbareTilgangsrollerFilterInput`. When it is `true`, the existing
condition `TildelingskilderConditions.erTildelbarForPersonbrukere` adds
`rolle.rollekode IN (SELECT rollekode FROM roller_i_applikasjonstak(org, miljø))`. Without the
field, or with `false`, the query is unchanged, so the tilganger tab, the role overview and other
consumers see no difference.

`roller_i_applikasjonstak(p_organisasjonskode, p_miljokode)` is a new `SECURITY DEFINER` SQL
function. It returns only role codes: the business roles in the cap of at least one Feide
application for the pair (direct rows and collection rows × active memberships, same environment),
closed downwards through `utvid_nedover`. It reads past RLS because a personbruker administrator
normally cannot read caps. The window is limited to pairs where the caller has the right to assign
to personbrukere (`orger_med_feidebruker_tildelingsrett()` ∪ `orger_med_person_tildelingsrett()`);
for any other pair it returns nothing. It never returns applications or cap rows.

The function is uncorrelated, so Postgres evaluates it once per query and hashes the result; the
per-row cost on `rolle` is a hash probe.

### Key Technical Decisions

1. **Opt-in filter field `skjulUtenforTak: Boolean`** (decided by Kjetil).
   - Why: one query has three consumers (both tabs of the dialog, the role overview). The rule
     covers only the roles tab. Same shape as `skjulUtgatte`, a verb-first boolean
     (fsp-graphql-standards). Experimental, like the rest of the file.
   - Without both `organisasjonId` and `miljoId` the cap is undefined, so `skjulUtenforTak: true`
     gives an empty list. Documented on the field.
   - Alternative: a condition that always applies. Rejected, it would change the tilganger tab and
     the overview.
2. **A narrow `SECURITY DEFINER` function, gated on the right to assign** (decided).
   - Why: the cap tables are invisible to the administrator under RLS
     (`applikasjon_brukerdelegering_les`, `…_organisasjonssamling_les`). An INVOKER condition would
     give an empty list for exactly the administrators the rule is for.
   - Window: only role codes, only for pairs where the caller may assign to personbrukere. This
     answers the 0029 objection (no cross-organisation read channel): the caller already sees the
     whole catalogue for the pair, and learns only which of those roles have effect there.
   - Alternative: reuse `utvidede_delegeringstilganger` per application. Rejected: per application,
     INVOKER, and it would expose which application.
3. **What counts** (decided):
   - Only Feide applications (the FK already restricts both cap tables to `feide_applikasjon`).
   - Only caps valid now: `gyldig_periode @> now() AND invalidert_tidspunkt IS NULL` on direct cap
     rows, collection cap rows and memberships (as in `raa_delegeringstilganger`, last body 0080).
   - Deactivated applications (`deaktivert_tidspunkt IS NOT NULL`, as `applikasjon_er_deaktivert`)
     do not count.
   - Synthetic applications count only when the CHOSEN environment (`miljo.er_syntetisk` for
     `p_miljokode`, not `auth.current_miljokode()`) is synthetic. Real applications count in both.
   - Implications downwards only (`utvid_nedover`, active edges).
4. **No enforcement.** `tildel_brukertilgang` and removal are unchanged.
5. **Navneromstype composes.** The function returns whatever is in the cap (caps may contain
   non-business roles); the client sends `navneromstyper: [FORRETNING]` as today.
6. **Numbers.** Migration `0127` (first free after main's `0125`; `0126` is held by !6357, and
   `0109`, `0116`, `0117`, `0119`, `0121`, `0064` by other open MRs). pgTAP `107` (`94`, `99`, `100`,
   `102`, `106` held). Note the holds in the root changelog comment. No `CREATE OR REPLACE` of an
   existing function, so no last-body risk.
7. **Minimal touch in `TildelingskilderConditions`.** !6413 changes the same method and the query
   description. Add one parameter and one `if` block, and one sentence to the description, so the
   rebase is a small textual merge. GraphQL tests in a new class next to
   `TildelbareRollerOgMiljoerQueryTest`, with its own fixture, so !6413's test changes do not
   collide.

### File Changes Overview

- New: `tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0127-roller-i-applikasjonstak.sql`
- `…/db/changelog/db-changelog-root.xml`: include 0127 with a comment (depends on 0080, 0061, 0085,
  0088; holds listed).
- New: `tilgangsstyring/tilgangsstyring-new-db/src/test/sql/107_roller_i_applikasjonstak.sql` (pgTAP).
- `tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/TildelingskilderConditions.java`:
  new parameter `skjulUtenforTak` on `erTildelbarForPersonbrukere`.
- `tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_personbruker_tilgang_med_nummer.graphqls`:
  field, `argMapping`, descriptions.
- New: `tilgangsstyring/tilgangsstyring-app/src/test/java/no/sikt/fs/tilgangsstyring/RollelisteBegrensetAvTakQueryTest.java`.
- `tilgangsstyring/docs/tilgangsmodell.md` (dialog-list paragraph),
  `tilgangsstyring/docs/syntetiske-og-ekte-data.md` (I2 row in «Hvor reglene håndheves»).
- jOOQ is regenerated by the build (`tilgangsstyring-new-jooq`), giving `Tables.ROLLER_I_APPLIKASJONSTAK`.

## GraphQL-endringer

Scope is one field on an existing experimental input; `bat-graphql-dev` was not needed.

```graphql
input MineTildelbareTilgangsrollerFilterInput {
  # … existing fields unchanged …
  """
  Vis kun rollene som er i taket til minst én Feide-applikasjon i kombinasjonen av
  `organisasjonId` og `miljoId`, direkte eller gjennom en organisasjonssamling organisasjonen er
  medlem av, og rollene en slik rolle gir. Bare tak som gjelder nå, teller, og ikke tak til
  deaktiverte applikasjoner. Tak til syntetiske applikasjoner teller bare når miljøet er
  syntetisk. Uten tak er listen tom, og uten både `organisasjonId` og `miljoId` også. Taket
  begrenser bare listen: en tildeling utenfor taket avvises ikke. Utelatt eller `false` gir lista
  uendret.
  """
  skjulUtenforTak: Boolean
}
```

fs-admin (separate MR, frontend role): `useTildelbareBrukerTilgangskoder` sends
`skjulUtenforTak: true` only when `fane === 'roller'` in `TildelRolleAction`. Implemented by: Task #3.

## Implementation Tasks

### Task #1: Migration 0127, `roller_i_applikasjonstak`

**Priority**: High · **Size**: M · **Dependencies**: None · **Addresses**: BRU-PER-GRU-003

**Acceptance Criteria**:
- [ ] `tilgangsstyring.roller_i_applikasjonstak(p_organisasjonskode INTEGER, p_miljokode TEXT) RETURNS TABLE(rollekode TEXT)`,
      `LANGUAGE sql STABLE SECURITY DEFINER`, `SET search_path = tilgangsstyring, pg_temp`.
- [ ] Direct rows and collection rows × active membership (same environment, org = p_org); all
      three valid now.
- [ ] Joins `feide_applikasjon`: not deactivated; `NOT er_syntetisk OR` the chosen `miljo.er_syntetisk`.
- [ ] Expanded with `utvid_nedover`; distinct role codes.
- [ ] Empty unless `(p_miljokode, p_organisasjonskode)` is in the caller's Feide or person
      assignment right.
- [ ] `REVOKE ALL … FROM PUBLIC`, `GRANT EXECUTE … TO ${app_role}`, `COMMENT ON FUNCTION` saying
      why DEFINER and what limits the window.
- [ ] Root changelog include with dependency and hold comment.

**Implementation Notes**: No comment line may start with a Liquibase directive word.

### Task #2: pgTAP 107

**Priority**: High · **Size**: M · **Dependencies**: Task #1

**Acceptance Criteria** (each a separate assertion, run as the app role with `set_claims`):
- [ ] Structure: DEFINER, PUBLIC has no EXECUTE, app role has, result has exactly one column `rollekode`.
- [ ] Direct cap gives the role; another organisation or another environment does not.
- [ ] Collection cap gives the role in an active member; not in a non-member, not with an expired
      membership, not with a membership in another environment.
- [ ] Implication: a role implied by a cap role is returned; a role that implies a cap role is not.
- [ ] Period: future, expired and invalidated cap rows do not count (direct and collection).
- [ ] Deactivated application's cap does not count.
- [ ] Synthetic application's cap counts in a synthetic chosen environment, not in a real one; a
      real application's cap counts in both. Independent of the calling environment.
- [ ] Without the right in the pair (no right, only LES, only the application right) → nothing.
- [ ] Feide right and person right both open the window.

### Task #3: GraphQL filter field and condition

**Priority**: High · **Size**: S · **Dependencies**: Task #1

**Acceptance Criteria**:
- [ ] `skjulUtenforTak` on the input, added to `argMapping`.
- [ ] `erTildelbarForPersonbrukere` gains `Boolean skjulUtenforTak`; `true` with both keys →
      `rolle.ROLLEKODE.in(select … from ROLLER_I_APPLIKASJONSTAK.call(org, miljø))`; `true` without
      both → `falseCondition()`.
- [ ] Query description mentions the opt-in cap filter in one sentence.
- [ ] api-design-review run on the change.

### Task #4: GraphQL tests

**Priority**: High · **Size**: M · **Dependencies**: Task #3

**Acceptance Criteria** (new `RollelisteBegrensetAvTakQueryTest`, own orgs/subject ids):
- [ ] Opt-in: without the field and with `false`, the list is as before (roles outside the cap included).
- [ ] With `true`: direct cap, collection cap and implied role are listed; a role outside the cap is not.
- [ ] Composes with `navneromstyper` and `skjulUtgatte`.
- [ ] No cap in the pair → empty; without `miljoId` or `organisasjonId` → empty.
- [ ] The administrator cannot read the cap rows herself (fixture has no `WSBRUKER_LES`), yet the list is filtered.

### Task #5: Documentation

**Priority**: Medium · **Size**: S · **Dependencies**: Task #3

**Acceptance Criteria**:
- [ ] `tilgangsmodell.md`: the dialog-list paragraph says the role list can be limited to the cap,
      through `roller_i_applikasjonstak`, and why it reads past RLS.
- [ ] `syntetiske-og-ekte-data.md`: I2 row mentions the function (chosen environment, synthetic
      applications), with pgTAP 107.

### Task #6: Verify, MR

**Priority**: High · **Size**: M · **Dependencies**: Tasks #1–#5

**Acceptance Criteria**:
- [ ] `mvn test -pl :tilgangsstyring-new-db` against an own `kjh-` container (not port 5432).
- [ ] Service and app tests green (rerun the two known flaky tests alone if needed).
- [ ] Draft MR assigned to kjetihoy, BAT-326 + PR #866 on top, conflict with !6413 noted.

## Risk Assessment

### Technical Risks

- **Rebase against !6413** (same method, same description). Mitigation: minimal diff; whoever
  merges last resolves a small textual conflict.
- **Oracle for caps.** Mitigation: gated on the right to assign in the pair; returns roles only.
- **Interaction with !6238 (I2 policies on caps) and !6357 (synthetic apps rejected everywhere).**
  The function reads past RLS, so !6238's policies do not affect it; it applies the I2-like rule
  itself on the chosen environment. If !6357 lands, synthetic applications get no effect anywhere,
  and the synthetic branch here may be tightened later.
- **Empty list in review/local.** Caps are environment data; manual checks need cap rows.

### Testing Requirements

- pgTAP 107 (Task #2), GraphQL test class (Task #4), existing `TildelbareRollerOgMiljoerQueryTest`
  and `TilgangsrolleUtgattGraphqlTest` unchanged and green.

## Success Criteria

- [ ] All acceptance criteria met, all tests passing, pipeline green.
- [ ] The filter is opt-in; no other consumer changes.

## Requirements Traceability

| Scenario (BRU-PER-GRU-003, rule on the cap) | Addressed by |
|---|---|
| Role shown only when an application has it in the cap for the chosen org and environment | #1, #2, #3, #4 |
| A role not in any cap is not shown | #1, #2, #4 |
| A collection's cap applies to its member organisations | #1, #2, #4 |
| A role given by a cap role is shown | #1, #2, #4 |
| Empty list when no application has a cap | #1, #3, #4 |
| A role in no cap can still be removed | unchanged (no task) |

## Cross-contributor dependencies

- **frontend (fs-admin):** send `skjulUtenforTak: true` from the roles tab of `TildelRolleAction`
  only, and update the user guide note. Blocked until this MR is on `main`.
