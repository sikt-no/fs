# Analysis: Registrere praksis (opptak), backend in fs-plattform/opptak

> Produced by `bat-analyze` on 2026-10-09. **Backend only.** It measures the code merged to `main` in `e9db0247b4` (STEK-548: Praksiskalkulator i søknadsbehandlingen; `main` @ `7860426b6c`, with no later praksis commits) against the contract that was agreed in the frontend analysis. Decisions Q-D1–Q-D8 and Q-T1–Q-T6 are taken as given and not reopened.
>
> Inputs:
> - the spec: [`spec-registrere-praksis.md`](../spec/spec-registrere-praksis.md)
> - the frontend analysis: [`analysis-registrere-praksis.md`](../frontend/analysis-registrere-praksis.md), which defines the backend requirements B2–B7 and B9
> - the frontend plan: [`plan-registrere-praksis.md`](../frontend/plan-registrere-praksis.md), whose *Target backend contract* table is what fs-admin is building against

## Problem Statement

fs-admin is building the praksiskalkulator against an assumed contract and an MSW mock. Its switch to the real schema (frontend Task #16) is blocked until the backend delivers B2–B7. Commit `e9db0247b4` put the praksis backend on `main`.

This analysis answers one question: **which of B2–B7 does `main` meet, and what is still missing?** It also lists the files involved, the constraints any change must respect, and the open choices for `bat-plan`.

The krav are `registrere_praksis.feature` (`@OPT-BEH-BEH-003`). The spec is the source of truth for *what* is built.

## Current State

All paths are relative to `opptak/`.

| Layer | File | Role |
|---|---|---|
| Migrations | `opptak-migrations/.../V403__arbeidserfaringstype.sql`, `V404__sak_praksisperiode.sql` | Code list; table `saksbehandling.sak_praksisperiode` (PK = sak key + `radnummer`, column `relevant`, `numeric(5,2)`/`numeric(9,2)` omfang, CHECKs, RLS on `SE_`/`MODIFISERE_SØKNADSBEHANDLING`) |
| Calculation | `opptak-service/.../saksbehandling/praksis/Praksisberegner.java` | Pure and static. Calendar months, years per period, `sumOppgitt`, `sumJustert`, overlap segments. `MathContext.DECIMAL128` |
| Read / preview | `PraksisberegningService.java` | `praksisberegningForSak` (batch loader for `Sak.praksisberegning`), `beregnPraksis(List<PraksisperiodeInput>)` (preview), `beregn(rows)`, `normaliser` (strips trailing zeros) |
| Rules | `PraksisperiodeRegler.java` | `krevSak`, `krevSkrivetilgang` (MODIFISERE), `valider`/`validerPeriode` (throws one `PraksisperiodeValideringException` per failure), `validerArbeidserfaringstyper`, `tilRad` |
| Write | `PraksisperiodeService.java` | `opprett`/`endre`/`slett`/`endreInkluderingAvPraksisperiode`, one period per call, a transaction each, audit intent per operation |
| Errors | `PraksisperiodeFeilkode.java`, `PraksisperiodeValideringException.java` | 18 codes, each starting with its field (`TIMER_OVER_KALENDERTID`, …). The exception's message **is** the code |
| Records | `records/*.java` | `Praksisberegning`, `Praksisperiode`, `PraksisOverlapp(fra, til, radnumre, samletStillingsprosent)`, inputs |
| Schema | `opptak-subgraph/.../experimental/saksbehandling/praksis.graphqls` (226 lines), `sak.graphqls` (`Sak.praksisberegning`, lines 327–333) | Types, inputs, 4 mutations, `Query.beregnPraksis`, `Query.arbeidserfaringstyper`, error union |
| Tests | `PraksisberegnerTest` (537), `PraksisberegningServiceTest`, `PraksisperiodeReglerTest`, `PraksisperiodeServiceIT`, `PraksisperiodeIT` (over the wire), `SakPraksisperiodeRLSIT` | Unit, integration, RLS |

How a read flows: `Sak.praksisberegning` → `PraksisberegningService.praksisberegningForSak` → `beregn(rows)` → `Praksisberegner.beregnOverlapp` → `normaliser` → `BigDecimal` fields. The scalar is `ExtendedScalars.GraphQLBigDecimal` (`_shared.graphqls:1`), which is serialised as a JSON number.

How a write flows: the mutation → `PraksisperiodeService.do*` → `PraksisperiodeRegler` → SQL → returns `SakRecord`. Then `PraksisperiodePayload.sak` (`@splitQuery`) re-reads `praksisberegning`.

## Key Findings

### Status per backend requirement

| # | Requirement (from the frontend analysis) | Status on `main` | Evidence |
|---|---|---|---|
| **B2** | No `0.999…` where the result is mathematically whole or round (stillingsprosent, timer, overlap adjustment). Tests compare exactly | ❌ **Not met** | See *B2 in detail* |
| **B3** | Calculated values as decimal strings, in their own type | ❌ **Not met** | See *B3 in detail* |
| **B4** | Overlap per stretch, split where ">100 %" changes, incl. ≤100 % (not 0 %) and one-day, with an "over 100 %" flag | ❌ **Not met** (only one-day and 0 % are right) | See *B4 in detail* |
| **B5** | Validation errors with field + code, no "Praksisperiode N:" prefix | 🟡 **Partly met** | See *B5 in detail* |
| **B6** | `beregnPraksis` as a one-period preview: string value, field + code errors, `SE_SØKNADSBEHANDLING` check | ❌ **Not met** | See *B6 in detail* |
| **B7** | Its own Inkluder mutation (flag only, returns the sak, own audit intent, MODIFISERE) | ✅ **Met** | `praksis.graphqls:57-66`; `PraksisperiodeService.java:62-66, 132-152` (only `RELEVANT` is updated, no re-validation, `INTENSJON_INKLUDERING`, `forberedSkriving` → `krevSkrivetilgang`); IT `endreInkluderingOverWire` (`PraksisperiodeIT.java:176-197`) |

### B2 in detail: exactness

- Every period is divided down to years with DECIMAL128 before anything is summed:
  - stillingsprosent: `Praksisberegner.java:118-123` (`months / 12 × pct / 100`)
  - timer: `:115` (`timer / timerPerArsverk`)
  - the overlap excess per segment: `:184-188`
- So 1/3-year periods are stored as `0.333…3` (34 digits), and three of them add up to `0.999…9`. The code is unchanged since the frontend analysis's Review 3 (P1).
- **The tests hide the problem:**
  - `assertSum`/`assertAr` compare with a tolerance of `EKSAKT = 1E-30` (`PraksisberegnerTest.java:37, 103-120`). The P1 error is 1E-34, so the assertions pass.
  - `fullPresisjon` (`:221-231`) uses a tolerance of `1E-12`.
  - None of the B2 examples (3 × 4 months at 100 %; 3 × 550 t/1650; a year at 100 % with a contained month) is tested.
- `normaliser` (`PraksisberegningService.java:141-147`) only strips trailing zeros. It neither rounds nor fixes the value.

### B3 in detail: the wire format

- Every calculated field is `BigDecimal` (`praksis.graphqls:93, 95, 116, 125`). This scalar is shared: it is used 45 more times in the opptak schema outside `praksis.graphqls`.
- fs-admin maps `BigDecimal: 'number'` (`fs-admin/codegen.ts:49`). `JSON.parse` loses precision past about 17 significant digits before any client code runs.
- The IT confirms the number format: `body.getDouble("data.beregnPraksis.sumOppgitt")` with a tolerance of 1e-12 (`PraksisperiodeIT.java:304`).
- `PraksisOverlapp.samletStillingsprosent` (`:125`) is also a calculated `BigDecimal`.

### B4 in detail: overlap reporting

- **≤100 % is not reported.** Segments at or below 100 % + `TOLERANSE` are skipped with `continue` (`Praksisberegner.java:179-182`). The test `noyaktigHundreProsent` (`PraksisberegnerTest.java:414-421`) still asserts `overlapp == []`, under a name that says "varsles". `timebasertNoyaktigHundreProsent` (`:436-442`) asserts the same.
- **Entries are per segment, not per stretch.** Every distinct start or end date opens a new entry (`Praksisberegner.java:170-198`). Neighbouring segments on the same side of 100 % are never merged.
  - Q-D8 example 1 (A 50 % + B 40 % for 2020, C 20 % from 01.07): the backend returns **one** entry (01.07–31.12). Q-D8 requires two, because 01.01–30.06 at 90 % is missing.
  - Q-D8 example 2 (A 50 % + B 60 %, C 10 % from 01.07): the backend returns **two** entries (110 %, then 120 %). Q-D8 requires one.
  - `separateVinduer` (`:509-521`) locks in the per-segment behaviour.
- **Only the total is reported, not the flag.** `PraksisOverlapp` carries `samletStillingsprosent` (a `BigDecimal`), not an `over100Prosent` flag (`records/PraksisOverlapp.java`, `praksis.graphqls:119-126`). In a merged stretch the total can vary, so one value cannot describe it.
- **What already holds:**
  - 0 % intervals are filtered out (`:155-158`), as Q-D4 decided.
  - One-day overlaps are reported (test `:498`).
  - Only included periods take part (`:149`).
  - The `sumJustert` excess calculation itself is not affected by B4.

### B5 in detail: validation errors

- **What meets the requirement:**
  - Free text with the "Praksisperiode N:" prefix is gone. The exception message is now an enum name (`PraksisperiodeValideringException.java`, `PraksisperiodeFeilkode.java`), documented in the schema (`praksis.graphqls:197-211`).
  - The enum Javadoc says the names are part of the API.
  - The IT `valideringsmeldingerOverWire` (`PraksisperiodeIT.java:270-289`) checks that the code reaches the client as `message`.
- **What differs from the Q-T3 decision ("a field and a code must be added"):**
  1. There are no `felt`/`kode` fields. `PraksisperiodeValideringFeil` has only `path` + `message` (`praksis.graphqls:212-226`). The field is encoded as the code's prefix, and some prefixes have several words (`TIMER_PER_ARSVERK_…`, `ARBEIDSERFARINGSTYPE_…`). `path` is the GraphQL path of the mutation, not the input field.
  2. Only the first error is returned. `validerPeriode` throws on the first failure (`PraksisperiodeRegler.java:113-173`). The schema says so ("Bare den første feilen gis").
  3. The codes are not in the schema as an enum. A new code is a silent contract change for the client.
  4. The DB handler maps the FK violation to the description `ARBEIDSERFARINGSTYPE_UKJENT` (`praksis.graphqls:217-222`). The client gets the same code as from the explicit check.
- **Not covered, as the frontend analysis already noted:** an invalid date is rejected by the `LocalDate` scalar as a top-level error, before the rules run. Q-T3 leaves that rule to the client.
- **Precedent in opptak** for an error type with a separate code field: `SoknadFeilSoknadfristUtlopt { kode: String!, frist, message, path }` (`soknad/soknadErrors.graphqls:49-56`), filled from the exception's `getKode()`.

### B6 in detail: `beregnPraksis`

The signature is unchanged from the WIP version: `beregnPraksis(perioder: [PraksisperiodeInput!]!): Praksisberegning!` (`praksis.graphqls:10-20`, `PraksisberegningService.java:43-52`). It falls short of Q-T4 in five ways:

- **A list instead of one period.** It returns sums and overlap. The input also requires `radnummer` and `relevant` (`praksis.graphqls:129-142`).
- **No `sakId`, and so no access check.** `PraksisberegningService.beregnPraksis` calls no `krevSak`/`Claims.harTilgang`. Q-D5/Q-T4 decided on an `SE_SØKNADSBEHANDLING` check. Precedent for a Query with an access check and an errors payload: `vitnemalGittSokerIdV2` → `VitnemalGittSokerIdPayload { vitnemal, errors: [IkkeAutorisertError!] }` (`soknad/soknad.graphqls:14-41`, `VitnemalService.java:75-80`).
- **No errors payload, and the code is lost.** A validation failure becomes a top-level GraphQL error **without the message**. The IT documents this: "beregnPraksis har ingen feilunion, så valideringsfeil blir en top-level-feil uten meldingen" (`PraksisperiodeIT.java:307-319`). So the client cannot get the `TIMER_OVER_KALENDERTID` code from the preview at all, which is the rule Q-T3 relies on the backend for.
- **The value is a `BigDecimal`**, not a string (B3).
- **It shares `tilRad` with saving** (`PraksisperiodeRegler.java:218-241`), so the preview normalises the same way as a save. That is a property to keep.

### Other findings (B9 nits still open)

- **`relevant` is still the name** in the DB, the records and the schema (`V404:17,59`, `praksis.graphqls:114,141,156`). Only the new mutation's input uses `inkludert` (`:179`). The krav call it "Inkluder". `PraksisperiodeFelterInput.relevant: Boolean!` is required on create **and on every edit**.
- **`doEndre` validates before the access check.** Validation and the code-list lookup run before `forberedSkriving` (`PraksisperiodeService.java:101-104`), while `doOpprett` checks access first (`:70`). A user with read access only gets a validation error instead of `IkkeTilgangFeil`.
- **Stale comment.** `doOpprett:82` says validation happens after the radnummer is known "så feilmeldingene viser periodens nummer". The codes no longer contain the number.
- **Stale description and comment on a nullable field.** The schema text says "Tom liste når ingenting er lagret" for an object field (`sak.graphqls:327`). The service comment says "siden feltet er non-null" (`PraksisberegningService.java:54`), but the field is nullable.
- **`beregnetPraksis` is nullable** (`praksis.graphqls:115-116`). Stored rows can never lack omfang (V404 CHECK `omfang_check`), so the null branch only matters for preview input.
- **Untested RLS case:** "Saksbehandlere i andre opptak ser ikke praksisen" within the same organisation (`SakPraksisperiodeRLSIT` tests only another organisation, `:64`).
- **Not yet added** (B9 follow-ups from Q-D2, Q-D3, Q-D6): tests for month-end starts, a timer period that overlaps only part of a prosent period (825 t over 2024 + 100 % Jan–Jun → justert 0,75), and the ±2-day random cases.

## Technical Constraints

- **The shared `BigDecimal` scalar can't simply change** (Q-T1). It is defined once for the whole subgraph (`_shared.graphqls:1`) and used 45 times outside praksis. fs-admin maps it to `number` for every field. B3 needs a separate type for the praksis values.
- **Graphitron directives decide how errors and payloads work.**
  - Errors in a union reach the payload only through `@error` handlers (`GENERIC` on an exception class, or `DATABASE` on an SQL state).
  - Extra fields on an error type are filled from the exception's getters (precedent `SoknadFeilSoknadfristUtlopt.kode`).
  - A Query without an errors field turns an exception into a top-level error, and the message is not passed through (`PraksisperiodeIT.java:307`).
  - Schema changes must follow the Graphitron docs (`@record`, `@service`, `@error`, `@splitQuery`).
- **Federation and the supergraph.**
  - The praksis types live in `features/experimental`.
  - The payload's `sak: Sak @splitQuery` is what lets fs-admin update the cache from the payload (frontend Decision 5). It must stay.
  - Renaming or removing fields is breaking for the only known client, fs-admin. That client is not yet on the real schema (it builds on a mock until frontend Task #16).
- **One calculation path.** Read, preview and the per-period rule (`timerOverstigerKalendertiden`) all go through `Praksisberegner`. The month rule (Q-D2), even spread of timer hours (Q-D3) and the ±2-day justert deviation (Q-D6) are **accepted** and must not change as a side effect.
- **DB precision of the inputs.** `numeric(5,2)` stillingsprosent, `numeric(9,2)` timer and timerPerArsverk, and at most 2 decimals is validated (`PraksisperiodeRegler.java:200-202`). All calculated values are derived from these and from dates. They are never stored (Q-D7).
- **Access model** (Q-D5): `SE_` to read and `MODIFISERE_SØKNADSBEHANDLING` to change, per organisation. Checked through RLS plus `AuthRoutines.harHandlingFor` (`PraksisperiodeRegler.java:91-97`) or `Claims.harTilgang` (`VitnemalService.java:76`). The backend sees handlinger, not roles.
- **Repository rules** (CLAUDE.md, RETNINGSLINJER): comments only for what is surprising. Issue and migration references go in commits and the MR, not in code. Specs come before implementation, so schema first. MR descriptions need a Jira/krav reference near the top.
- **Migrations.** V403/V404 are merged. A rename of `relevant` in the DB would need a new migration, not an edit of V404.

## Dependencies

- **Internal (opptak):**
  - `Sak` (`sak.graphqls`), because `praksisberegning` and the payloads resolve `Sak`
  - `SakNokkel`
  - `AuditContext.setForSaksbehandling` (endringslogg intents)
  - `AuthRoutines` / `Claims` / `Handling`
  - the shared error types `FinnesIkkeFeil`, `IkkeTilgangFeil` (union `PraksisperiodeError`, `praksis.graphqls:195`)
  - `kodeverk.arbeidserfaringstype`
- **External:**
  - Graphitron code generation (opptak-subgraph build)
  - `graphql-java-extended-scalars` (`GraphQLBigDecimal`)
  - Apollo federation composition of `production/experimental`
- **Cross-contributor:**
  - **frontend (fs-admin), on `stek-549-feat-registrere-praksis`:**
    - Tasks #8–#15 run against `praksisContract.ts` and MSW.
    - **Task #16 is blocked** until B2–B6 are merged and deployed to `production/experimental`.
    - When the backend finalises the names, fs-admin must align the contract file and the mock. It already differs today: `relevant` vs `inkludert`, `PraksisGrunnlagInput`, `periode: PraksisperiodeFelterInput`, `felt`/`kode`, `over100Prosent`, and the `beregnPraksisperiode` signature.
    - The new decimal type needs a scalar mapping to `string` in `fs-admin/codegen.ts`. Task #16 stops if the values arrive as `number`.
  - **fs-krav / domain (B9):** align the krav text for Q-D1, Q-D2, Q-D3, Q-D5 and Q-D6, and the "Inkluder" naming. This is not code, but the traceability depends on it.
  - **Operations:** it is not known whether `e9db0247b4` is already deployed to `production/experimental`. Deployment is a prerequisite for frontend #16, whatever the state of B2–B6.

## Requirements Impact

Measured against `registrere_praksis.feature`. Only scenarios where the backend matters are listed.

- **Requirements addressed (backend correct today):**
  - Registrere en praksisperiode
  - Praksisperioder hører til saken
  - Praksis fra andre saker vises ikke
  - Registrert praksis ligger fast (Q-D7)
  - Velge praksistype (Q-D1)
  - Inkludere en praksisperiode (B7)
  - Praksisperioder som ikke er inkludert, telles ikke med
  - Overlapp beregnes bare mellom inkluderte
  - Startdato og sluttdato er obligatorisk; uten sluttdato; sluttdato før startdato
  - Sluttdato fram i tid
  - Proporsjonal / timebasert beregning (single values)
  - Standard årsverk 1 650; justerbart årsverk; per periode
  - Én måte per periode; timer påkrevd; 0–100 %; timer > 0
  - Timer over kalendertiden (save path); endring over kalendertiden
  - Timebasert omfang overskrives ikke
  - Oppdatere / slette
  - Sluttdatoen regnes med; delvis måned 30 dager (Q-D2)
  - Både oppgitt og justert sum (1,10 / 1,00)
  - Justert sum kan ikke overstige kalendertiden (±2 days, Q-D6)
  - Søknadsbehandler kan registrere; without søknadsbehandling access sees nothing (Q-D5, RLS)
- **Requirements at risk:**
  - *Praksis beregnes med full presisjon* and *Samlet praksis summeres på tvers av perioder*: sums that should be whole come out as `0.999…` and truncate to 0,99 (**B2**).
  - *Summen avkortes til to desimaler i visningen*: can't be done safely on a JSON number (**B3**). Truncation in the client depends on the client's number parser.
  - *Overlappende praksisperioder varsles*: overlaps ≤100 % get no warning, and the warning count per stretch doesn't match Q-D8 (**B4**).
  - *Timer som gir mer praksis enn kalendertiden …* **before saving** ("Beregnet varighet"): the preview cannot report the code (**B6**). It still works after saving through the mutation payload (B5, partly met).
  - *Saksbehandlere i andre opptak ser ikke praksisen*: correct by construction (RLS per organisation plus the sak key), but not tested within one organisation.
- **Missing requirements discovered:** none new in the krav.
  - The preview access check (Q-D5/Q-T4) is a decided requirement with no krav scenario. It is enforced nowhere today.
  - The B5 contract details (one error vs. all; codes as a schema enum vs. a documented string) are not decided at the level the code now needs (see Open Questions).

## Krav-input referanse

- **Spec-dokument:** [`spec-registrere-praksis.md`](../spec/spec-registrere-praksis.md)
- **Krav-input-manifest:** [`krav-input/manifest.md`](../spec/krav-input/manifest.md)
- **Frontend analysis (B2–B9, Q-D1–Q-D8, Q-T1–Q-T6):** [`analysis-registrere-praksis.md`](../frontend/analysis-registrere-praksis.md)

## Open Questions

These are choices *within* the decided contract, for `bat-plan` and the backend owner. They don't reopen Q-D or Q-T.

- [ ] **OQ-B1 (B3)** What type should the calculated values have on the wire?
  - (a) A new custom scalar (e.g. `Desimaltekst`), serialised as a plain-notation string and mapped to `string` in fs-admin.
  - (b) Plain `String` fields, with plain notation documented in the description.
  - (c) Something else.

  This also covers `samletStillingsprosent`, if it survives OQ-B4.
- [ ] **OQ-B2 (B2)** Which arithmetic should guarantee that whole and round results come out exact? Q-T1 says "how is up to the backend", but the choice decides which tests are possible.
  - (a) Exact rational arithmetic all the way, converted to a decimal once at the end.
  - (b) Sum in an exact intermediate unit (e.g. months × percent, or hours) and divide to years once per sum.
  - (c) Round each intermediate value to a fixed scale above display precision before summing.
  - (d) Something else.

  It must also cover the overlap excess.
- [ ] **OQ-B3 (B5)** Does the current form satisfy Q-T3's "field + code"?
  - (a) Accept the field-prefixed code in `message` as the contract.
  - (b) Add `felt` and `kode` as separate fields, following `SoknadFeilSoknadfristUtlopt.kode`.
  - (c) Additionally expose the codes as a GraphQL enum.

  Sub-question: is one error at a time acceptable, or should every failing field be returned?
- [ ] **OQ-B4 (B4)** What should an overlap entry carry?
  - (a) Replace `samletStillingsprosent` with `over100Prosent: Boolean!`, as in the frontend contract.
  - (b) Keep both, with the total as the minimum or maximum over the stretch.
  - (c) Something else.

  The merge rule is decided (Q-D8.1). What's open is only the field set and whether any field is still a calculated decimal (cf. B3).
- [ ] **OQ-B5 (B6)** How should the preview change?
  - (a) Replace `beregnPraksis` with a new field (e.g. `beregnPraksisperiode(sakId, periode)`) returning a payload with `beregnetPraksis` + `errors`.
  - (b) Change `beregnPraksis` in place.
  - (c) Keep the list version as well.

  Sub-questions:
  - Is `radnummer` part of the draft input?
  - Is `relevant` part of it?
  - Where does the access check live: through `sakId` + `krevSak`/RLS, or `Claims.harTilgang(SE_SØKNADSBEHANDLING)` as in `VitnemalService`?
- [ ] **OQ-B6 (B9 naming)** Should `relevant` be renamed to `inkludert` in the schema, and in the DB through a new migration, while fs-admin is the only client and not yet on the real schema? Or should it stay as `relevant` with a description?
- [ ] **OQ-B7 (B9 nits)** Should the nits ship together with B2–B6 or separately? They are the `doEndre` check order, the stale comments and descriptions, and the nullable `beregnetPraksis` on stored rows. So are the missing tests: month end, partial timer overlap, the ±2-day cases, and RLS for another opptak in the same organisation.
- [ ] **OQ-B8 (deploy)** Is `e9db0247b4` deployed to `production/experimental`? Should B2–B6 ship as one change, so fs-admin's Task #16 reconciles once, or step by step?
