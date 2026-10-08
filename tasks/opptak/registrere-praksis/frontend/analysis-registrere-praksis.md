# Analysis: Registrere praksis (opptak): praksiskalkulator for søknadsbehandler

> Produced by `bat-analyze` on 2026-10-08. Findings only: no solutions. Those belong in `bat-plan`.
>
> **Scope and sources.** The frontend part is based only on fs-admin `main` (branch `stek-549-feat-registrere-praksis` = `main` @ `a44f90adb`) plus the spec. The backend part reviews fs-plattform branch `opptak/praksiskalkulator` (34 commits since merge-base `25ae3a20de`) as a **proposal**.
>
> **Not read (on purpose).** The branches `praksiskalkulator` / `praksiskalkulator-api` (local or origin), any earlier BAT output, and any `Praksiskalkulator` feature folder were not read. Three things came up during the survey, and none of them were opened:
> - The git refs `origin/praksiskalkulator` and `origin/praksiskalkulator-api` exist.
> - `.next/` holds build output from an earlier praksiskalkulator build, e.g. `.next/server/app/opptak/[id]/soknadsbehandling/sak/[sakId]/praksiskalkulator` and `.next/server/chunks/ssr/*_features_Praksiskalkulator_Praksiskalkulator_tsx_*.js`.
> - The backend commit `68839b3d39` is titled "praksisberegning portert fra fs-admin". The calculation algorithm comes from the earlier fs-admin POC, and it was reviewed here only as it stands in fs-plattform.
>
> **How the numbers were produced.** The backend numbers in this document come from running the branch's own `Praksisberegner.java` on its own (compiled unchanged, with a scratch test harness). Frontend number behaviour was checked in Node (`JSON.parse` + `Math.floor`).

## Problem Statement

Søknadsbehandlere must be able to register a søker's praksisperioder on a **sak**. Each period has a periode, omfang (stillingsprosent or timer), an optional arbeidsgiver and an optional praksistype. The system then calculates how many years of praksis that gives, both per period and in total. The total is shown two ways: as "Sum av oppgitte perioder" and as "Justert for overlapp", where days above 100 % are not counted. The canonical statement is in [`spec-registrere-praksis.md`](../spec/spec-registrere-praksis.md) and `registrere_praksis.feature` (`@OPT-BEH-BEH-003`). Texts and layout are in `registrere_praksis.design.md`.

From the codebase's point of view:

- **fs-admin has nothing for this today.** There is no route, no feature folder, and no GraphQL operations. The published schema that fs-admin generates its types from has no praksis types.
- The spec's route is `fs-plattform → fs-admin`. The fs-admin work depends on the backend branch `opptak/praksiskalkulator`. That branch is unmerged, so its GraphQL contract is still open to change, and several findings below say it should change.
- The page is a **separate page for one sak**, opened from the sak view. It shows which søker and sak it belongs to (decided 07.10.2026). The sketch shows a table card, an overlap warning, two sum cards, and a form panel on the right-hand side.

## Current State

### fs-admin (main)

**Sak route tree** (`src/app/opptak/[id]/soknadsbehandling/`):

- `layout.tsx:5-8` sets `PageHeaderWrapper` with the breadcrumb "Saker". There is **no role gate** on `/opptak/[id]/soknadsbehandling/**`.
- `sak/[sakId]/page.tsx:9-13` redirects to `gsk` or `grunnlag` (`src/domains/soknadsbehandling/utils/getRequiredSakSteps.ts`).
- The `sak/[sakId]/(sak)/` route group holds the stage tabs `gsk`, `grunnlag`, `kravliste`, `kvoteplassering`, `poengberegning` and `oppsummering`. Their order is defined in `src/domains/soknadsbehandling/utils/stageUtils.ts:8-22`.
  - `(sak)/layout.tsx` is a server component. It runs the `GET_SAK_MINIMAL` query (lines 22-46) via `getClient()` (56-61). The breadcrumb is `soknadskode ?? sakId.slice(0,7)` (66).
  - The left column holds `SaksbehandlerCard`, `PersonaliaCard`, `UtdanningsbakgrunnCard`, `DokumenterCard` and `SakActionButtons` (76-90). The right column holds `SakStageProgress`, the tab content and `StageNavigation` (92-98). `SakDrawer` is wrapped in `PreloadQuery GET_SAK_BADGE_COUNTS` (99-103).
  - Each tab card fetches its own data with `useSuspenseQuery`, e.g. `PoengberegningCard.tsx:55-58`.
- **There are already sibling pages outside `(sak)`.** They don't get the cards, drawer or stage chrome:
  - `sak/[sakId]/endresoknad/page.tsx:20-29`. It wraps the page in `FeatureFlag soknadsbehandling-handle-pa-vegne-av`, then its own `PageHeaderWrapper breadcrumbTitle`, then Suspense around `EndreSoknadView`. It is opened from `EndreSoknadButton.tsx:25-30`, a `ButtonLink` with a typed `href {pathname, params}` rendered in `SaksbehandlerCard.tsx:229`. The view uses `LayoutHeading`, `LayoutActionbar` and `Surface`.
  - `sak/[sakId]/vitnemalutdanning/[sokerId]/layout.tsx` and the `vitnemalvideregaende` twin. Both are client layouts that build the breadcrumb from the person's name. They are opened from `DokumenterCard.tsx:73,85`.
- **Søker/sak identity:** `src/domains/soknadsbehandling/features/PersonaliaCard/PersonaliaCard.tsx:22+` (query `PersonaliaSak`) reads `saksnummer`, `statuskode`, `soknad{soknadskode, opptak{navn}}` and `soker.opptakPerson{fornavn, etternavn, identifikasjon}`.
- **Closest existing analogue:** `src/domains/soknadsbehandling/features/PoengberegningCard/Vitnemalskalkulator/Vitnemalskalkulator.tsx`. It is an SDS `Dialog` with a `DataTable` (`DecimalNumberInput` cells, a `CheckboxInput` "inngår" column), a summary `Surface` card, and a save mutation through `useGetMutationErrors`. Its pure calculation is in `utils/beregnPoeng.ts`, with tests. It is **not rendered anywhere**: it has no importers and uses `fakeData.semester` (~line 331).

**Roles:**

- `src/common/types/generated/tilgangsroller.ts:67` defines `frontendrolle` `FS-ADMIN_OPPTAK_SØKNADSBEHANDLER`. Nothing in `src/` uses it yet.
- Write actions in the sak area are gated on `FS-ADMIN_MODIFISERE_SØKNADSBEHANDLING` with `useWithRole`: `PoengberegningCardRow.tsx:55`, `KvoteplasseringCard.tsx:78`, `TilbudsgarantitypeSelect.tsx:232`.
- `WithRole` (`src/features/WithRole/WithRole.tsx:14-35`) is documented as a UI hint only. Access is enforced by the backend.

**GraphQL:**

- `codegen.ts` uses the client preset to generate `src/__generated__/`, with scalars mapped as **`BigDecimal → number`** (`codegen.ts:43`) and `LocalDate → string`.
- The schema comes from published SDL, `production/experimental` (`graphqlSchemaLocation.ts:22`). Introspecting a local gateway with `GRAPHQL_SCHEMA_INTROSPECTION_URL` is `.env.local` only.
- `refetchQueryNames` (`src/common/lib/apollo/refetchQueryNames.ts:22`) is mandatory for refetches.
- Mutation errors are joined with `useGetMutationErrors` (`src/common/hooks/useGetMutationErrors/useGetMutationErrors.ts:32-75`). They are shown as an inline `errorText`, a snackbar, or an `Alert` list, and **never mapped to fields from server errors**. Field validation is done client-side by hand, e.g. `plasstildeling/features/OpprettRundeForm/utils/getFieldError.ts` and `PoengberegningCard/utils/validatePoints.ts`.
- The current schema and generated types have no hits for `Praksisperiode`, `praksisberegning`, `arbeidserfaring` or `stillingsprosent`. The `Praksistype` that does exist (schema:53234) is the emne/undervisning type, which is a different code list.
- Commit `0d81c389c` (on main) enforces `id` in GraphQL selections with @graphql-eslint.

**Building blocks (common):**

- `FSTable` (`src/common/components/tables/FSTable/`). Example: `BehandlertildelingsregelUnntak.tsx:266-275`. `DataTable` supports `renderField` for inputs and checkboxes in cells.
- `FSModal` (`src/common/components/FSModal/`) is a native `<dialog>`. **There is no generic side panel or drawer component.** `SakDrawer` is specific to the sak area.
- Inputs:
  - Date picker: `InputDatepicker` from `@sikt/sds-input-datepicker`, e.g. `OpprettRundeForm.tsx:156`.
  - Numbers: `FSNumberInput` (`inputs/FSNumberInput/FSNumberInput.tsx:14-76`, with `decimals`, `min`/`max` and comma locale).
  - Segmented choice: `ToggleSegment` from `@sikt/sds-toggle`. Its only use is `regelverk/components/OperatorToggle/OperatorToggle.tsx:27-46`.
  - Also `FSRadioGroup`, `FSCheckbox` / `CheckboxInput`, `FSTextInput` and `FSSelect`.
- Feedback and actions: `Alert variant="warning"` from `@sikt/sds-message` (the local `common/components/Alert` is deprecated), `Surface` for the sum cards, and `ButtonWithConfirmation`.
- Layouts: `BasicPageLayout` (e.g. `BehandlertildelingsregelDetails.tsx:28`), `DetailPageLayout`, and the shared `layouts/components/*`.

**Formatting:**

- Dates: `src/common/utils/dateUtil/dateUtil.ts` (`dateFormats.date` dd.MM.yyyy, registered in `src/common/i18n/request.ts:49-50`).
- Numbers: **no utility exists for truncating to two decimals.** The code rounds ad hoc with `toFixed(2)` (`VitnemalskalkulatorOppsummering.tsx:23,27`, `FSNumberInput.tsx:266-271`).

**Testing:**

- a11y tests use jest-axe + `MockedProvider` and mock roles with `tilgangerMedRoller(...)`, e.g. `KvoteplasseringCard.a11y.test.tsx:14-19`.
- There are no MSW mocks for opptak/sak (`src/mocks/handlers.ts` only covers applikasjoner).

### fs-plattform/opptak, branch `opptak/praksiskalkulator` (proposal)

| Layer | File | Role |
|---|---|---|
| Kodeverk | `opptak-migrations/.../V403__arbeidserfaringstype.sql` | New table `kodeverk.arbeidserfaringstype` (kode, navn, er_aktiv), seeded with 37 codes ("Foreløpig liste: praksistypene i FSKODER (PRAKSISTYPE) som gjelder søker", line 22) |
| Table + RLS | `V404__sak_praksisperiode.sql` | `saksbehandling.sak_praksisperiode`, PK (sak key, `radnummer`); CHECK constraints for dates, omfang and grunnlag; audit; RLS on `SE_/MODIFISERE_SØKNADSBEHANDLING` per organisation |
| Pure calculation | `opptak-service/.../praksis/Praksisberegner.java` | Calendar months, per-period years, sums and overlap |
| Read/preview adapter | `PraksisberegningService.java` | `Sak.praksisberegning` (batched per sak) and `Query.beregnPraksis` (preview without saving) |
| Write | `PraksisperiodeService.java` | `opprett`/`endre`/`slettPraksisperiode`, one period at a time, in a transaction, with audit |
| Rules | `PraksisperiodeRegler.java` | Validation, normalisation to a DB row (`tilRad`), access checks; shared by write and preview |
| API | `opptak-subgraph/.../experimental/saksbehandling/praksis.graphqls` + `sak.graphqls` (+7 lines) | Types, inputs, mutations, error union |
| Tests | `PraksisberegnerTest` (537 lines), `PraksisperiodeReglerTest`, `PraksisberegningServiceTest`, `PraksisperiodeServiceIT`, `PraksisperiodeIT` (over the wire), `SakPraksisperiodeRLSIT` | Gherkin-named unit, integration and RLS tests |

Branch hygiene:

- The branch is **46 commits behind `origin/main`**. `V402` is now taken on main (`V402__tidligopptak_begrunnelsetype_behov_og_paminner.sql`). V403/V404 don't collide today, but this must be checked again after rebase.
- The prompt mentioned V402–V404. On the branch, the migrations are V403 and V404 only, after commit `0e43f5ad4e` moved them.
- Commit `7c13f9e032` adds `beregnPraksis` and is titled "(WIP)".

## Backend review: rule by rule

Legend: ✅ implemented correctly · 🔀 implemented differently · ❌ missing · ➕ extra (in code, not in spec) · ⚠️ correct in principle, but with a defect.

### Regel: Praksisperioder registreres manuelt på saken

| Spec rule / scenario | Status | Evidence |
|---|---|---|
| Registrere en praksisperiode (type, start, slutt). Stored on the sak and counted in the total | ✅ | `PraksisperiodeService.java:60-89`; total computed on read, `PraksisberegningService.java:55-87` |
| Praksisperioder hører til saken / Praksis fra andre saker vises ikke | ✅ | Keyed on (soker_id, opptak_kode, organisasjonskode), `V404:21-23`; read filters on the sak key, `PraksisberegningService.java:68-71` |
| Registrert praksis ligger fast (same periods, same inclusion, same total later) | ⚠️ | Periods and inclusion are stored. The **total is recomputed on every read** and is never stored (`sak.graphqls` +7, `@service praksisberegningForSak`), so a later change to the calculation code changes historical totals. See Q-D7. |
| Se registrerte praksisperioder (Arbeidsgiver, Type, Start, Slutt, Omfang, Beregnet praksis) | ✅ | `praksis.graphqls:88-106` |
| Velge praksistype: all types with `status_gjelder_soker = J` from the common praksistype code list | 🔀 | Implemented as **its own copy**, `kodeverk.arbeidserfaringstype` (`V403:4-60`), with 37 hard-coded rows ("Foreløpig liste"), its own `er_aktiv` flag, and only active types served (`praksis.graphqls:3-8`). The field is named `arbeidserfaringstype`, not praksistype. It cannot be verified from here whether the 37 rows equal `FSKODER.PRAKSISTYPE WHERE status_gjelder_soker='J'`. The fskode alternative was removed in `724f6620e6`. See Q-D1. |
| Inkludere en praksisperiode (one flag per period, filters before overlap) | ✅ / naming | Filtering is correct (`Praksisberegner.java:149`). The API and DB still call the field **`relevant`** (`praksis.graphqls:103,130,145`, `V404:17,59`), although the spec renamed it to "Inkluder" on 02.10.2026. |
| Ikke-inkluderte perioder telles ikke med / Overlapp bare mellom inkluderte | ✅ | `Praksisberegner.java:149-158`. Tested: `PraksisberegnerTest` "Overlappssummene beregnes kun på relevante praksisperioder" |
| En ny praksisperiode er inkludert som standard | 🔀 | The input has `relevant: Boolean!` (`praksis.graphqls:145`), so the client must send `true` and the backend has **no default**. If null reached the service, `tilRad` would store `false` (`PraksisperiodeRegler.java:226`). The default is the frontend's responsibility. |
| Startdato og sluttdato obligatorisk; praksistype valgfri | ✅ | `startdato: LocalDate!`; sluttdato is checked at `PraksisperiodeRegler.java:100-102`; DB `NOT NULL` (`V404:11-12`); type nullable |
| Oppgi arbeidsgiver (valgfri) | ✅ ➕ | ➕ Max 200 characters (`PraksisperiodeRegler.java:32,106-110`, `V404:26-27`) and trimming (`:191-196`) |
| Uten sluttdato kan ikke lagres | ✅ | `PraksisperiodeRegler.java:100-102`. Test `utenSluttdato` |
| Sluttdato før startdato kan ikke lagres | ✅ | `:103-105` plus DB CHECK `V404:28-29` |
| Ugyldig dato kan ikke lagres | 🔀 | Rejected by the GraphQL `LocalDate` scalar as a **top-level GraphQL error**, not a `PraksisperiodeValideringFeil`. Field-level feedback must come from the frontend. |
| Sluttdato fram i tid regnes som oppgitt | ✅ | No check against today's date. Test `sluttdatoFramITid` |
| `@wont` Knytte til dokumentasjon | ✅ (absent) | Not implemented |

### Regel: Omfanget oppgis som stillingsprosent eller antall timer

| Spec rule / scenario | Status | Evidence |
|---|---|---|
| Proporsjonal stillingsprosent (2,00 / 1,00 / 0,40 / 0,00) | ✅ | `Praksisberegner.java:118-123`; harness confirms all four |
| Timebasert mot årsverk (1,00 / 0,50 / 0,40) | ✅ | `:108-116` |
| Standard årsverk 1 650; can be adjusted per period; stored on the period | ✅ | `:26`, `PraksisperiodeRegler.java:222-225` stores the default explicitly; `V404:16` |
| Én måte per periode | ✅ | `grunnlag` field plus `tilRad` nulls the other columns (`PraksisperiodeRegler.java:220-225`); DB CHECK `V404:38-43` |
| Timer påkrevd når grunnlag = TIMER | ✅ | `:127-129` |
| Stillingsprosent 0–100 inclusive | ✅ ➕ | `:116-119`; ➕ at most two decimals (`:120-122`) |
| Timer > 0 | ✅ ➕ | `:130-132`; ➕ at most two decimals, ➕ `MAKS_TIMER` 10 000 000 (`:36,136-138`) |
| Timer ≤ kalendertid (inclusive limit) | ✅ | `Praksisberegner.java:92-101`, `PraksisperiodeRegler.java:151-158`. Tests `timerOverKalendertiden`, `timerPaGrensen` |
| Endring som gir mer enn kalendertiden kan ikke lagres | ✅ | `doEndre` re-validates the whole new period (`PraksisperiodeService.java:93-95`) |
| Timebasert omfang overskrives ikke når datoene endres | ✅ | Explicit `grunnlag`; hours are not recomputed from dates. Test `timebasertUavhengigAvDatoer` |
| ➕ Timer per årsverk > 0, ≤ 2 decimals, < 10 M | ➕ | `:139-150` |

### Regel: Systemet summerer automatisk

| Spec rule / scenario | Status | Evidence |
|---|---|---|
| Samlet praksis summeres (3,50) / legges til (4,00) / slettes (2,50) | ✅ | Harness: 2 + 1.0 + 0.5 = 3.5 |
| Sluttdatoen regnes med | ✅ | `beregnKalendermaneder` uses `sluttdato + 1` (`Praksisberegner.java:74`) |
| Full presisjon, avkorting først i visningen | ⚠️ | No intermediate rounding (DECIMAL128, `:28`), and `normaliser` only strips trailing zeros (`PraksisberegningService.java:141-147`). **But** each period is divided by 12 on its own before summing (`:121-123`), so sums of repeating decimals end up *just below* the whole number. Three 4-month periods at 100 % give `0.9999…9` (34 digits) instead of 1. See Review 3, P1. |
| Summen avkortes til to desimaler i visningen | ❌ (backend) / ⚠️ contract | Left to the presentation layer (`Praksisberegner.java:17-18`). The `BigDecimal → number` mapping makes this unsafe. See Review 3, P2. |
| En delvis måned regnes med 30 dager (0,5 / 1,5 months) | ✅ / ⚠️ edge | Spec examples ✅ (harness: 0.0417 → 0,04 and 0.125 → 0,12). Start dates at month end are ambiguous: see Review 2, edge cases. |

### Regel: Overlappende praksisperioder varsles og vises med to summer

| Spec rule / scenario | Status | Evidence |
|---|---|---|
| Overlappende praksisperioder **varsles** (any overlap in time) | 🔀 / ❌ | Overlap is **reported only when the combined total is > 100 %** (`Praksisberegner.java:180-182`). 50 % + 40 % in the same year gives `overlapp = []` (harness). The test `noyaktigHundreProsent` is titled "…varsles og justeres ikke" but asserts `overlapp == []` (`PraksisberegnerTest.java:413-420`). design.md:70 requires a warning for overlaps "100 % eller mindre". **Blocker.** |
| Det fremgår hvilken periode overlappet gjelder | ⚠️ | `PraksisOverlapp{fra, til, radnumre, samletStillingsprosent}` exists, but split into **segments**. One continuous overlap whose total changes produces several entries (A 50 % + B 60 % for 2020, plus C 10 % from 01.07: two entries, 01.01–30.06 [1,2] 110 and 01.07–31.12 [1,2,3] 120). design.md:70-71 has a single text, "Du har {antall} perioder … ({fra}–{til})". |
| Både oppgitt og justert sum (1,10 / 1,00) | ✅ | Harness and test |
| Justert sum kan ikke overstige kalendertiden + it is shown that the total is > 100 % | ⚠️ | Mostly right, but **not exact**: the bound is wrong by up to ±1/180 year (≈ 2 days) in both directions. The test `kortManedKjentBegrensning` documents this as a "kjent begrensning" (`PraksisberegnerTest.java:524-535`). See Review 2. |
| Overlappssummene kun på inkluderte | ✅ | |

### Regel: Kun søknadsbehandler

| Spec rule / scenario | Status | Evidence |
|---|---|---|
| Søknadsbehandler can register, update and delete | ✅ | `krevSkrivetilgang` → `MODIFISERE_SØKNADSBEHANDLING` (`PraksisperiodeRegler.java:73-79`); RLS `V404:76-89` |
| Without the søknadsbehandler role: cannot see registration or praksis | 🔀 | Access is **based on actions (handlinger) per organisation, not on roles**. In `V12__tilgangskontroll_grunndata.sql:83-116`, `SE_SØKNADSBEHANDLING` is held by ADMINISTRATOR, SUPERBRUKER, SØKNADSBEHANDLER and **BRUKERSTØTTE**, and `MODIFISERE_` by ADMINISTRATOR, SUPERBRUKER and SØKNADSBEHANDLER. Praksis is visible to everyone who can see the sak. See Q-D5. |
| Saksbehandlere i andre opptak ser ikke praksisen | ✅ (indirect) | Praksis hangs off the sak, and RLS is per `organisasjonskode` (`V404:71-74`). Not tested specifically for "another opptak in the same organisation". |
| ➕ `Query.beregnPraksis` | ➕ | No sak, no access check, no RLS (`praksis.graphqls:15-19`, `PraksisberegningService.java:43-52`). It is pure calculation plus a kodeverk lookup, so the risk is low, but it is outside the spec's role rule. |

### Other code-level findings

- Stale comment: `PraksisberegningService.java:54` says "siden feltet er non-null", while `Sak.praksisberegning` is nullable (`sak.graphqls` +7, commit `28ed5d63a9`). The schema description says "Tom liste når ingenting er lagret", but the field is an object, not a list.
- Inconsistent order of checks:
  - `doOpprett` checks access before validation (`PraksisperiodeService.java:62` → `76`).
  - `doEndre` validates, and looks up the kodeverk, **before** the access check (`:94-96`). A user with read access only gets validation messages back instead of `IkkeTilgangFeil`.
- Dead branches given the validation and DB constraints:
  - `beregnPraksisperiode` returns `Optional.empty()` "when omfang is missing" (`Praksisberegner.java:112-120`). Stored rows can never lack omfang (`V404:38-43`), so `Praksisperiode.beregnetPraksis` is nullable in the schema for no reason (`praksis.graphqls:104-105`). This leaks into the frontend types.
  - Same for the "Én periode over 100 %" handling (test `PraksisberegnerTest` around line 446): it is unreachable after validation.
- Validation messages are free text with a technical prefix, e.g. "Praksisperiode 3: sluttdato er før startdato" (`PraksisperiodeRegler.java:96-158`). `PraksisperiodeValideringFeil` has only `path` and `message` (`praksis.graphqls:181-195`). The texts differ from design.md:77-84 ("Oppgi sluttdato.", "Antall timer må være mer enn 0.", …), and the radnummer they show is not visible in the UI.
- `Praksisperiode` has **no `id`** (only `radnummer` within the sak), and `Praksisberegning` has no `id` either. Apollo cannot normalise them, so they live embedded under `Sak`. This is relevant to fs-admin's new `id` lint rule (`0d81c389c`).

## Specific review 1: `PraksisberegningService.java`

**Responsibility, compared with the other classes:**

| Class | Responsibility |
|---|---|
| `Praksisberegner` | **Pure domain calculation**, static, no I/O: calendar months, years per period, `sumOppgitt`, `sumJustert`, overlap segments |
| `PraksisperiodeRegler` | **Rules**: validation, normalisation to a row (`tilRad`), the access checks `krevSak`/`krevSkrivetilgang`; shared by write and preview |
| `PraksisperiodeService` | **Write side**: one period per mutation, transaction, row lock for the next radnummer, audit, `FinnesIkke` |
| `PraksisberegningService` | **Read/preview adapter**: (1) `praksisberegningForSak`, the batch loader for the Graphitron field `Sak.praksisberegning` (one query for many saker, grouped per `SakNokkel`); (2) `beregnPraksis`, preview of unsaved periods; (3) `beregn(rows)`, mapping DB row → `Praksisberegner.Periode` → `Praksisberegning` record, plus `normaliser` |

**Is the split sensible?** Yes, broadly. The pure calculation is isolated and can be unit-tested, and the write side and the rules are separate. Read and preview share **one** code path (`beregn` → `Praksisberegner.beregnOverlapp`), so there is only one way to calculate. Smells and questions:

1. **Round trip in preview.** `beregnPraksis` goes Input → `tilRad` (a jOOQ `SakPraksisperiodeRecord` that is never stored) → `tilPeriode` → calculation (`PraksisberegningService.java:47-51`). This is deliberate, so that preview normalises the same way as saving, but it ties the preview to the DB record type.
2. **Half-empty `ArbeidserfaringstypeRecord`.** Only the code is filled in, and Graphitron fills in the name afterwards (`:123-126`). It works, but it is implicit.
3. **What `beregnPraksis` is for is unclear.**
   - It is marked "(WIP)" (commit `7c13f9e032`), and its schema text says it is for "summer og overlapp mens saksbehandler redigerer".
   - With "lagre én praksisperiode om gangen", the form only needs the *one* period's value ("Beregnet varighet"). For that, the overlap and the sums in the response are irrelevant, or misleading if only one period is sent (see Review 3).
   - It takes no `sakId`, so it cannot pick up the stored periods itself.
   - It has no access check (see above).
   - It has no errors payload: an invalid draft, which is a normal state while the user types, produces top-level GraphQL errors.
4. **Stale comment and a nullable field without a reason** (see above).
5. **Not dead, but duplication worth noting:** `PraksisberegningService.beregn` and `PraksisperiodeService` share `tilRad`/validation through `PraksisperiodeRegler`. That is good. No calculation logic is duplicated across classes. It is in the wrong layer only in this sense: the per-period validation `timerOverstigerKalendertiden` lives in `Praksisberegner` (the calculation), which is fine because it needs `beregnKalendermaneder`.

**Units and rounding compared with the spec:**

| Topic | Code | Spec | Assessment |
|---|---|---|---|
| Output unit | Years (BigDecimal), everywhere | Years; "samlet praksis vises bare i år" | ✅ |
| Internal unit | Months: whole months + remaining days / 30 (`:73-86`) | Same | ✅ for the spec examples; ambiguous at month end (Review 2) |
| 30-day partial month | Remaining days / 30 | "En måned er alltid 30 dager" | ✅, but **not additive**: splitting a period changes the total (Review 3, P4) |
| Timer → calendar time | Timer / årsverk = years, independent of dates (`:108-116`). For overlap, converted to an implied stillingsprosent spread **evenly** over the period (`tilIntervall`, `:204-218`) | The spec only says timer/årsverk. Nothing on how timer are spread in time | 🔀 an assumption. See Q-D3 |
| Stillingsprosent incl. 0 % | 0 % is valid and gives 0 years (`:116`); 0 % periods are **removed from the overlap calculation** (`:157`, commit `3b244b7937`) | 0 % is valid | ✅ for the sum. ⚠️ A 0 % period never triggers an overlap warning, and the spec says nothing about this. See Q-D4 |
| Precision | DECIMAL128 (34 digits), division by 12 **per period** before summing | "Full presisjon internt" | ⚠️ gives `0.999…` for sums that should be whole numbers (Review 3, P1) |
| Truncation | Not in the backend | Truncate down to two decimals in the display | ⚠️ unsafe given the frontend scalar mapping (Review 3, P2) |

## Specific review 2: overlap calculation

**How it works** (`Praksisberegner.beregnOverlapp`, `:143-201`):

1. Calculate praksis per period. Keep only the **included** ones (`relevant`).
2. `sumOppgitt` = the sum of the included periods' praksis.
3. Turn each included period into an interval `[start, slutt+1)` with a stillingsprosent. Timer periods get an *implied* % = praksis / calendar time. Intervals with 0 % are dropped.
4. Split the timeline at every start and end. For each segment, add up the stillingsprosent of the active intervals.
5. If the total is above 100 % + 1E-9, then `overskudd += (total−100)/100 × calendar time(segment)`. The segment is reported as `PraksisOverlapp` if ≥ 2 periods are active.
6. `sumJustert = sumOppgitt − overskudd`.

**Per type or across all?** Overlap is computed **across all included periods**, regardless of praksistype/arbeidserfaringstype and of grunnlag (prosent/timer). The spec ("flere samtidige praksisperioder som til sammen overstiger 100 % stilling") doesn't group by type, so this matches. ✅

**Combining in an overlap:** stillingsprosent is **added up** per segment. Timer periods contribute their implied % spread evenly over the whole period. The total *per day* in the sum of the given periods (sumOppgitt) can exceed 100 %, by design. In `sumJustert` the excess above 100 % is removed per segment, but the segment's calendar time is counted with the 30-day rule on the *segment*, while the periods themselves are counted with the 30-day rule on the *whole period*. Month counting is not additive, so the cap is only approximate.

**Edge cases (harness numbers, all periods included):**

| Case | Periods | sumOppgitt | sumJustert | `overlapp` | Spec / comment | Test? |
|---|---|---|---|---|---|---|
| Spec example | 2020 50 % + 2020 60 % | 1.1 | 1.0 | 1 segment, 110 % | ✅ | ✅ |
| Overlap ≤ 100 % | 2020 50 % + 2020 40 % | 0.9 | 0.9 | **[]** | ❌ the spec requires a warning | ✅, but the test locks in the wrong behaviour |
| Exactly 100 % | 2020 50 % + 50 % | 1 | 1 | **[]** | ❌ the same | ✅ (`noyaktigHundreProsent`) |
| Same start and end date (one day) | 10.03.2020–10.03.2020 ×2 at 100 % | 0.00556 | 0.00278 | 1 segment, 200 % | ✅ (one day = 1/30 month). Shown as 0,00 år | Partly ("En felles dag", 30.06) |
| Adjacent | 01.01–30.06 + 01.07–31.12.2020 | 1.0 | 1.0 | [] | ✅ | ✅ (year boundary) |
| One shared day | 01.01–01.07 + 01.07–31.12.2020 | 1.00278 | 1.0 | 01.07–01.07, 200 % | ✅ by the spec. The UX shows a one-day warning | ✅ |
| Contained period | 2020 100 % + 15.03–14.04.2020 100 % | 1.0833 | **0.9999…97** | 1 segment | ⚠️ the justert sum is shown as **0,99** in BigDecimal (1,00 only by accident in JS, see Review 3, P2), while the year alone is 1,00 | ❌ |
| Partial overlap, partial months | 15.01–14.03.2021 + 01.02–28.02.2021 | 0.25 | 0.1667 | 1 segment | ✅ | ✅ |
| Overlap across a short month | 01.02–28.02 + 15.02–31.03.2021 | | 2 + 3/30 months | | ❌ exceeds the calendar time (2 months) by 3 days | ✅ "kjent begrensning" |
| Random search (3 periods, 100 %) | 05.01–12.03, 21.01–12.03, 26.01–27.03.2021 | | **0.2361** | | ❌ exceeds the union's calendar time **0.2306** by ≈ 2 days | ❌ |
| Same, other direction | 06.02–27.04, 31.01–12.04, 16.03–29.05.2021 | | 0.3278 | | ⚠️ 2 days *below* the union (0.3333) | ❌ |
| Total varies within one continuous overlap | A,B 2020 50/60 % + C 01.07–31.12 10 % | 1.15 | 1.00 | **2 segments** (110 % and 120 %) | ⚠️ the design expects one warning per overlap | ✅ "Separate vinduer" |
| Timer + prosent, partial | 825 t over the whole of 2024 + 100 % Jan–Jun 2024 | 1.0 | 0.75 | 01.01–30.06, 150 % | 🔀 assumes the hours are spread evenly. If the hours were worked in the autumn, there is no overlap | ❌ |
| Timer × 2 at the cap | 1650 t + 1650 t, 2020 | 2 | 1 | 200 % | ✅ | ✅ |
| Open-ended period | — | — | — | — | Not possible: `sluttdato NOT NULL` (`V404:12`) | ✅ (validation) |
| Excluded period overlapping | 50 % (incl.) + 60 % (not incl.) | 0.5 | 0.5 | [] | ✅ | ✅ |
| 0 % overlapping | 0 % + 100 % at the same time | — | — | [] | ❓ the spec is silent (Q-D4) | ✅ (timer 0) |

**Month-end edge cases in `beregnKalendermaneder`.** The start day is clamped to the last day of the target month (test `avkorterStartdag`):

| Period | Days | Months |
|---|---|---|
| 01.02–28.02.2021 | 28 | 1 |
| 28.01–27.02.2021 | 31 | 1 |
| 29.01–28.02.2021 | 31 | **1.0333** |
| 30.01–28.02.2021 / 31.01–28.02.2021 | 30 / 29 | **1.0333** |
| 31.01–30.03.2021 | 59 | 2 |
| 31.01–31.03.2021 | 60 | 2.0333 |

Two periods of 31 days each (28.01–27.02 and 29.01–28.02) give different calendar time. A 29-day period (31.01–28.02) gives *more* than a 28-day one (01.02–28.02) and as much as 30 days. The spec's "hele kalendermåneder + restdager/30" doesn't define what counts as a "whole calendar month" when the start day doesn't exist in the target month. See Q-D2.

**Edge cases with no test:** overlap ≤ 100 % that should be warned about; the contained period with justert `0.999…`; the random cases where justert > the union; timer periods that overlap only part of a prosent period; month-end start dates beyond `avkorterStartdag`; repeating decimals that should add up to a whole number (`fullPresisjon` uses a tolerance of 1E-12, `EKSAKT` = 1E-30, `TI_DESIMALER` = 5E-11, which hides the problem); several overlap segments for the same pair of periods.

## Specific review 3: one period compared with the whole sak

**Code paths:** opprett/endre/slett → `PraksisperiodeService` (validate one period, store the row), then the payload `sak` → `Sak.praksisberegning` → `PraksisberegningService.praksisberegningForSak` → `beregn(rows from DB)`. `beregnPraksis(inputs)` → `PraksisperiodeRegler.valider` + `tilRad` → **the same** `beregn`. **Nothing is stored**: the total is computed on read and cannot go stale in the DB after an update or delete. **The backend never rounds twice**: `normaliser` only strips trailing zeros.

So the discrepancies are not two different algorithms. They come from the following:

**P1: Repeating decimals in full precision (backend).** Division by 12 happens per period before summing (`Praksisberegner.java:121-123`).
- Three periods of 4 months (01.01–30.04, 01.05–31.08, 01.09–31.12.2020, all 100 %): each period is `0.3333…3`, and `sumOppgitt = sumJustert = 0.9999999999999999999999999999999999`. Truncated with BigDecimal → **0,99 år**. The same year as one period → **1,00 år**.
- Twelve monthly periods for 2020: sum `0.99999…97` → 0,99.
- The year at 100 % plus a contained month at 100 %: `sumJustert = 0.99999…97` → 0,99, although the year alone is 1,00.
- This works against the spec's own reason for full precision: "en søker med tolv korte arbeidsforhold kan tape … mot en søker med ett langt".

**P2: The wire format and truncation in the frontend.** `ExtendedScalars.GraphQLBigDecimal` is serialised as a JSON number. fs-admin maps `BigDecimal → number` (`codegen.ts:43`).
- In Node, `JSON.parse("0.9999999999999999999999999999999999") === 1`, so P1 happens to show **1,00** in fs-admin. A BigDecimal-aware consumer would show 0,99. **The same data gives different answers depending on the client.**
- Naive truncation in JS, `Math.floor(v*100)/100`, gives `0.29 → 0,28`, `0.57 → 0,56`, `1.15 → 1,14` and `4.35 → 4,34`. Concrete case: 478,5 timer / 1650 = exactly **0,29 år** from the backend, shown as **0,28 år**. The "A,B + C" example above (`sumOppgitt = 1.15`) is shown as **1,14 år**.
- The contract "avkorting skjer i presentasjonslaget" (`Praksisberegner.java:17-18`) can't be met safely with this scalar mapping unless there is a deliberate decision about where and how truncation happens. **This must be decided.** It is not a hidden frontend detail.

**P3: The sum of displayed rows ≠ the displayed total** (intended by the spec, but visible to the user):

| Case | Rows (truncated) | Sum of rows | Displayed total |
|---|---|---|---|
| 12 monthly periods 2020 | 0,08 × 12 | 0,96 | 0,99 (BigDecimal) / 1,00 (JS) |
| 3 × 4 months 2020 | 0,33 × 3 | 0,99 | 0,99 / 1,00 |
| Split February 2021 (01.02–14.02 + 15.02–28.02) | 0,03 + 0,03 | 0,06 | 0,07 |
| A 15.01–14.03 + B 01.02–28.02.2021 | 0,16 + 0,08 | 0,24 | oppgitt 0,25 |

The per-period value `beregnetPraksis` is always the **unadjusted** value. Overlap adjustment is not attributed to any period, so no row adds up to "Justert for overlapp".

**P4: Splitting a period changes the total** (a consequence of the 30-day rule):
- January 2021 as one period = 1 month = 0.0833. Split into 01.01–15.01 + 16.01–31.01 = 15/30 + 16/30 = **1.0333 months = 0.0861**. That is *more* praksis.
- February 2021 as one period = 1 month = 0.0833. Split into 01.02–14.02 + 15.02–28.02 = 28/30 = **0.0778**. That is *less*.
- When one period is edited ("lagre én om gangen"), the sak total can change by more than the change to that period suggests. See Q-D2.

**P5: Validation per period and against the other periods.** The cap `timer ≤ kalendertid` is checked **only per period** (`PraksisperiodeRegler.java:151-158`).
- Two timer periods with 1650 t each over 2020 are both accepted. Total: oppgitt 2,00, justert 1,00.
- This matches the spec: excess across periods is an *adjustment plus a warning*, not a rejection.

**P6: Preview compared with the stored total** (if `beregnPraksis` is used):
- `beregnPraksis` sums **only the periods that are sent in**. If the frontend sends only the draft, the sums and overlap describe one period and must not be added to the sak total.
- To get overlap-aware totals, the frontend must send all the stored periods (with their radnummer) **plus** the draft with an invented, unique radnummer (`valider` rejects duplicates and numbers < 1, `PraksisperiodeRegler.java:84-90`).
- The client cache can be stale if another søknadsbehandler has changed the sak meanwhile. The backend explicitly supports concurrent edits on different periods (`PraksisperiodeService.java:32-34`).

**P7: Toggling "Inkluder".** There is no dedicated mutation. The table checkbox must call `endrePraksisperiode` with **all** fields (`praksis.graphqls:35-43`), and the whole row is re-validated.

**P8: Totals over time.** Because totals are computed on read, the same stored periods will show a different total if the calculation code changes. This touches "samlet praksis er den samme som da jeg forlot saken". See Q-D7.

## Merge readiness: is the backend ready to merge as-is?

**No.** Findings that change the scope or contract for fs-admin, and must be resolved first:

1. **Overlap ≤ 100 % is not reported**, which breaks the spec and design.md:70. The test `noyaktigHundreProsent` confirms the wrong behaviour. Otherwise the frontend has to compute time overlap itself, which contradicts the schema's own premise that "beregningen bare finnes på serveren".
2. **Precision and truncation (P1 + P2).** The sums for whole numbers end in `0.999…`, and the scalar mapping makes truncation in fs-admin unreliable. The display contract (display-ready values, a string scalar, or exact rationals/months) must be decided before the frontend is built.
3. **Validation errors can't be mapped to fields.** They are free text, carry a technical prefix, and differ from design.md:77-84. Without error codes per field, fs-admin must re-implement *every* rule, including the 30-day calendar rule for the timer cap, in TypeScript, so there are two implementations of the same rule.
4. **The purpose and contract of `beregnPraksis`.** It is WIP, has no `sakId`, no access check and no errors payload, and it is easy to use in a way that gives sums that look wrong (P6).

All domain questions are decided (Q-D1–Q-D8). None of them adds backend work beyond the table below. Q-D1, Q-D2, Q-D3, Q-D5 and Q-D6 need the krav text aligned with `fs-krav`.

Fixable nits: the `relevant`/"Inkluder" naming; the stale comment and nullable `beregnetPraksis`; the order of checks in `doEndre`; the test name that says "varsles" for no warning; tolerances in tests that hide P1; rebase onto `origin/main` and re-check the V numbers.

### Status after walking through the open questions (2026-10-08)

The verdict is still **not ready to merge**. Every open question is decided, so the gaps are now concrete. What the backend must change before merge (details in Open Questions):

| # | Change | Source |
|---|---|---|
| ~~B1~~ | ~~Calendar time = days ÷ 30~~. **Dropped** when Q-D2 was reopened: the krav's month rule is kept, with no change to the calendar calculation. | Q-D2 (reopened) |
| B2 | Sums with no repeating-decimal error, e.g. add up in exact units (1/30 month × stillingsprosent) and divide once (P1) | Q-T1 |
| B3 | Calculated values sent as decimal strings, as a separate type, since the shared `BigDecimal` scalar can't simply change | Q-T1 |
| B4 | Overlap reported per stretch, split where "over 100 %" changes, including ≤ 100 % (except 0 %) and one-day overlaps, with an "over 100 %" flag | Q-T2, Q-D4, Q-D8 |
| B5 | Validation errors with field + code; no "Praksisperiode N:" prefix | Q-T3 |
| B6 | `beregnPraksis` narrowed to a preview of one period: value as a string, errors with field + code, access check (`SE_SØKNADSBEHANDLING`) | Q-T4, Q-D5 |
| B7 | Its own mutation for "Inkluder" | Q-T6 |
| ~~B8~~ | ~~Restricted to the søknadsbehandler role~~. **Dropped** when Q-D5 was reopened: praksis has the same access as the sak (`SE_/MODIFISERE_SØKNADSBEHANDLING`), which is what the backend already does. | Q-D5 (reopened) |
| B9 | Follow-ups, not backend code: align the krav text with `fs-krav` for Q-D1 (opptak copy of the code list), Q-D2 (month end/splitting), Q-D3 (even spread of timer periods), Q-D5 (access as the sak) and Q-D6 (±2 days); tests for month end, partial timer overlap and the ±2-day cases; nits above | Q-D1, Q-D2, Q-D3, Q-D5, Q-D6 |

Accepted as they are: the opptak copy `arbeidserfaringstype` (Q-D1), the month rule with month-end and splitting effects (Q-D2), even spread of timer periods (Q-D3), no warning for 0 % (Q-D4), access as the sak (Q-D5), justert ±2 days (Q-D6), sums recalculated on read (Q-D7), rows that don't add up to the sums (Q-D8.3).

B1 and B8 were in the first version of this table. They were dropped when Q-D2, Q-D5, Q-D6 and Q-D8.1 were reopened on 2026-10-08, because the first answers would have introduced errors (over-crediting with days ÷ 30; loss of access for administrator, superbruker and brukerstøtte, plus a change to the access model).

## Pattern analysis (fs-admin-patterns)

**No pattern matched (all < 90).**

| Pattern | Score | Reason |
|---|---|---|
| detail-page-layout-pattern | ~75/100 | Singular entity (sak, `[sakId]`), breadcrumb, Rediger/Slett. But the page's main content is a collection of praksisperioder plus an add form ("legg til", "skjema" are anti-pattern signals), not details about the sak. |
| list-page-layout-pattern | < 30 | No filter, search, sorting or paging. Small, bounded data set. |
| domain-index-pattern | < 10 | Not a landing page. |

Suggestions from the existing code:

- **Separate page per sak:** `sak/[sakId]/endresoknad/` (sibling of `(sak)`, own `PageHeaderWrapper`, `ButtonLink` from `SaksbehandlerCard`).
- **Small table without filters:** `fs-admin-tables-vs-lists` points to `FSTable` (small, no filter or paging, table structure in the sketch). For a checkbox in a cell: `DataTable renderField` (Vitnemalskalkulator) or `CheckboxInput` in `PoengberegningCardRow`.
- **Calculator plus sum card:** `Vitnemalskalkulator` and `VitnemalskalkulatorOppsummering` (not in use, so the pattern is unproven in production).
- Skills that apply when building: `fs-admin-inputs`, `fs-admin-buttons` ("Rediger"/"Slett"/"Bekreft"/"Avbryt"), `fs-admin-modal`, `fs-admin-placeholder`, `fs-admin-i18n-structure`, `graphql-consumer`, `fs-admin-changesets`.

## Key Findings

- fs-admin has **no** praksis code, route or schema today. Everything is new.
- The sak area already has a working precedent for a **separate page beside the stage tabs** (`endresoknad`, `vitnemal*`), and an unused calculator component (`Vitnemalskalkulator`) with a similar shape.
- The sketch's **right-hand side panel** has no generic common component. `FSModal` is a dialog. The design allows "sidepanel (eller dialog)" (design.md:7).
- **There is no form library.** Field validation is hand-written, and server errors are shown as text, not on fields.
- **There is no truncation utility.** Existing code rounds with `toFixed`, which is the wrong direction for this spec.
- `FS-ADMIN_OPPTAK_SØKNADSBEHANDLER` exists in `frontendrolle` but is unused. The sak area currently gates writes on `FS-ADMIN_MODIFISERE_SØKNADSBEHANDLING` and has no read gate.
- The backend is broadly well structured: a pure calculation, rules shared between write and preview, RLS, audit and good test coverage. It has four contract findings (Merge readiness 1–4) that change the frontend's work.

## Technical Constraints

- **CLAUDE.md / skills:**
  - SDS and common components first, with no custom styling on fields. Layout goes through `Grid`/`Flex` (no `display:flex/grid` in CSS). `FSOutputField` belongs in a `GridDataFieldSection`/`FlexDataFieldSection`.
  - Every component needs `*.a11y.test.tsx`.
  - GraphQL operations live next to their component, without `__typename`.
  - `refetchQueryNames(...)`; tests import the operation document from the component.
  - Changeset via `fs-admin-changesets`. Placeholder `-`. Create button = "Opprett". Labels via next-intl.
- **Codegen reads published SDL** (`production/experimental`). Frontend types for praksis exist only once the backend is **merged and deployed**. Before that, `GRAPHQL_SCHEMA_INTROSPECTION_URL` in `.env.local` is the only option, and it must never be committed or used in CI.
- **`BigDecimal → number`** (`codegen.ts:43`) means floating-point loss on full-precision values (Review 3, P2).
- **The `id` lint rule (`0d81c389c`, `eslint.config.js:93`)** is `@graphql-eslint/require-selections` with the default setting. It only requires `id` on types that **have** an `id` field. Checked 2026-10-08: `Praksisperiode` and `Praksisberegning` have no `id`, so there is no conflict. `Arbeidserfaringstype` (`id: ID!`) and `Sak` must have `id` selected. Because `Praksisperiode` has no `id`, Apollo stores the periods inline under `Sak.praksisberegning`. That is fine as long as the same field is not selected both with and without `id` in different operations.
- `/opptak/[id]/soknadsbehandling/**` has no role gate at layout level. The spec requires that the whole praksis part is hidden from users without the role.
- The backend sends `LocalDate` as an ISO string. Invalid dates fail at the scalar, so the frontend must validate date format and existence itself.
- **Calculated values are display-only** (follows from Q-T1, decided 2026-10-08):
  - Why this matters: fs-admin truncates `beregnetPraksis`, `sumOppgitt` and `sumJustert` to two decimals. That is safe because mutations only accept input values (dates, grunnlag, stillingsprosent/timer, timer per årsverk, arbeidsgiver, type, `relevant`). The backend recalculates everything from stored values after every save (Q-D7). There is no input field for calculated values.
  - The rules:
    1. **Never add up rows in fs-admin.** The sum cards always show the backend's `sumOppgitt`/`sumJustert`. Example: twelve monthly periods show 0,08 each (0,96 in total), but the right total is 1,00.
    2. **No optimistic updates of the sums.** After create/edit/delete, the sums come from the mutation payload (`PraksisperiodePayload.sak.praksisberegning`) or a refetch, never from fs-admin's own arithmetic.
    3. **Do not re-implement the calculation in fs-admin.** "Beregnet varighet" in the form comes from the backend (see Q-T4), so the form can't show something other than what gets saved.
    4. **Edits from the form send the period's input values** (the stored ones from the query, plus the user's changes), never anything derived. The Inkluder checkbox uses its own mutation (Q-T6), which only takes the flag.

## Dependencies

- **Internal (fs-admin):**
  - The sak layout `(sak)/layout.tsx` and/or `SaksbehandlerCard`/`SakActionButtons` (entry point to the calculator).
  - `PersonaliaCard` data (søker and sak identity).
  - `PageHeaderWrapper` (breadcrumbs).
  - `WithRole`/`useWithRole`.
  - `src/common/components/*` (FSTable, FSModal, inputs, Surface).
  - `dateUtil`. A new display rule for numbers.
- **External:** `@sikt/sds-input-datepicker`, `@sikt/sds-toggle`, `@sikt/sds-message`, `@sikt/sds-checkbox`; the opptak subgraph via the supergraph.
- **Cross-contributor:**
  - **Backend (fs-plattform/opptak):**
    - (a) Merge and deploy `opptak/praksiskalkulator` to `production/experimental`, so fs-admin can generate types. This blocks all frontend GraphQL work.
    - (b) Decide on overlap ≤ 100 %, the truncation/precision contract, field-coded errors and the purpose of `beregnPraksis`. All of these block the frontend's form and summary design.
    - (c) Rebase onto `origin/main` (V-number check).
  - **Domain/design (fs-krav / design):** Q-D1–Q-D8 below, plus the open design questions in design.md:107-112 (where the entry point goes, the timer variant of the form, texts for 1/0 periods, whether delete needs confirmation, the arbeidsgiver placeholder). These block the final UI texts and the domain behaviour.

## Requirements Impact

- **Requirements addressed by the backend proposal:** most of the scenarios in "Praksisperioder registreres manuelt", "Omfanget oppgis …", "Systemet summerer …" and "Praksisperioder kan oppdateres og slettes" (see the review tables).
- **Requirements at risk:**
  - *Overlappende praksisperioder varsles*: not reported for ≤ 100 %.
  - *Justert sum kan ikke overstige kalendertiden*: only approximate (±2 days).
  - *Praksis beregnes med full presisjon / Summen avkortes til to desimaler*: repeating decimals plus float truncation (0,99 vs 1,00; 0,29 → 0,28).
  - *Velge praksistype for søkere*: own code list, not the common one.
  - *Kun brukere med søknadsbehandler-rollen*: action-based access, which also covers brukerstøtte/admin/superbruker.
  - *Registrert praksis ligger fast*: the total is recomputed on read.
  - *En ny praksisperiode er inkludert som standard*: the default lives only in the frontend.
- **Missing requirements discovered:**
  - The behaviour of partial months at month end, and when a period is split (non-additivity).
  - How timer periods are spread in time when they overlap.
  - Whether a 0 % period that overlaps others should be warned about.
  - Whether one continuous overlap with varying total should give one warning or several.
  - Rows don't add up to the totals.
  - Whether a one-day overlap should give a warning.

## Krav-input referanse

- **Spec-dokument:** [`spec-registrere-praksis.md`](../spec/spec-registrere-praksis.md) (absolute: `/Users/anne.bekkelie/sikt/fs/tasks/opptak/registrere-praksis/spec/spec-registrere-praksis.md`)
- **Krav-input-manifest:** [`krav-input/manifest.md`](../spec/krav-input/manifest.md)
- Feature: `fs/krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature`, with `registrere_praksis.design.md` beside it
- Domain-expert questions: [`questions-domene-registrere-praksis.md`](questions-domene-registrere-praksis.md)

## Open Questions

Domain questions (details and numbers in [`questions-domene-registrere-praksis.md`](questions-domene-registrere-praksis.md)):

- [x] **Q-D1** Praksistype: should the list be the common `FSKODER.PRAKSISTYPE` (`status_gjelder_soker = J`), or is the opptak copy `arbeidserfaringstype` (37 codes, its own active flag) accepted? What happens when the common code list changes?
  - Options: (a) the common code list, as the krav says; (b) accept the opptak copy; (c) something else.
  - **Decision (2026-10-08): (b), the opptak copy `kodeverk.arbeidserfaringstype` is accepted.** The 🔀 deviation in the rule table is accepted and no longer blocks merge. Follow-up: someone must own keeping the copy in step with the common code list, and the krav text ("felles praksistypekodeverket") should be aligned with `fs-krav`. The frontend uses `Query.arbeidserfaringstyper` and shows "KODE – navn".
- [x] **Q-D2** Calendar time at month end and when a period is split: (a) accept the current clamping and non-additivity, (b) define "whole calendar month" differently, (c) count days / 30 for the whole period?
  - **Decision (2026-10-08, reopened the same day): (a), keep the krav's month rule.** Calendar time = whole calendar months + remaining days ÷ 30, end date included (spørsmål 5, 29.09.2026), as the backend does today (`Praksisberegner.beregnKalendermaneder`, `:73-86`). All the krav examples hold (01.01.–31.12.2020 = 1,00 år; the summing example = 3,50 år; timer cap 1 650 t for 2020).
  - Accepted consequences, which should be documented in the krav and covered by tests:
    - **Month-end starts:** 29.01.–28.02.2021 gives 1,033 months, while 28.01.–27.02.2021 (also 31 days) gives 1,000 (the start day is clamped, test `avkorterStartdag`).
    - **Splitting:** splitting a period can change the total slightly (January 2021 split 01.–15./16.–31. = 1,033 months instead of 1; February split 01.–14./15.–28. = 0,933).
    - **Justert ±2 days**, see Q-D6.
  - **Why the first answer was reversed:** (c) days ÷ 30 for the whole period counts a year as 360 days and over-credits. 01.01.2020–21.12.2021, 10 days short of two years, would give 2,00 år instead of 1,97 and pass a "minimum to år" requirement. That goes against the krav's principle that the display must never show more praksis than the søker has, and it would have overturned spørsmål 5 and the krav examples.
  - No backend change for the calendar rule (B1 no longer applies).
- [x] **Q-D3** Timer periods in overlap: spread evenly over the period (as now), or something else?
  - Options: (a) spread evenly over the period, as now; (b) leave timer periods out of the overlap adjustment and only warn about them; (c) something else.
  - **Decision (2026-10-08): (a), even spread is accepted.** A timer period counts as the implied stillingsprosent `timer / årsverk / kalendertid` on every day of the period (`Praksisberegner.tilIntervall`, `:204-218`).
  - Follow-up: add a test for a timer period that overlaps only part of a prosent period (825 t over 2024 + 100 % Jan–Jun → justert 0,75 år). Document the assumption in the krav.
- [x] **Q-D4** Should a 0 % period that overlaps others be warned about?
  - Options: (a) no warning, since 0 % contributes nothing; (b) warn about time overlap with a 0 % period too.
  - **Decision (2026-10-08): (a), no warning for 0 %.** The current behaviour (`Praksisberegner.java:157`, commit `3b244b7937`) is accepted. This also applies if Q-T2 makes the backend report time overlap regardless of %: periods at 0 % stay out of that report.
- [x] **Q-D5** Access: is "can see the sak" (admin, superbruker, brukerstøtte included) enough, or should praksis be limited to the søknadsbehandler role, as the spec says?
  - Options: (a) the same access as the sak; (b) only the søknadsbehandler role, with new handlinger; (c) read the role catalogue's links first.
  - **Decision (2026-10-08, reopened the same day): (a), the same access as the sak.** The backend is kept as it is: `SE_SØKNADSBEHANDLING` to read and `MODIFISERE_SØKNADSBEHANDLING` to change, per organisation (RLS `V404:71-89`, `krevSkrivetilgang` `PraksisperiodeRegler.java:73-79`). That means:
    - administrator, superbruker and søknadsbehandler can change praksis;
    - brukerstøtte can read it (by the `V12:83-116` mirror; the production links are in the central tilgangsstyring).
  - Background (why "only søknadsbehandler" was dropped):
    - **The backend can't see roles.** The opptak backend never sees role codes, only handlinger from the token's `orgtilganger` claim (`AuthenticatedContextProvider.java:136-139`). Roles are expanded into handlinger in tilgangsstyring, and the backend's own `rolle`/`rollehandling` tables (V12) are only used for the sudo fallback in synthetic environments (`:602`).
    - **Role-only needs new handlinger.** Restricting to one role would have needed new handlinger in the central role catalogue (and the V12 mirror), plus an answer on whether `OPPTAK_SAKSBEHANDLER` is included.
    - **Who would lose access.** Administrator, superbruker and brukerstøtte would have lost access, unlike the rest of the sak data.
  - **The krav must be aligned with `fs-krav`.** The rule "Kun brukere med søknadsbehandler-rollen kan registrere praksis" and situasjon E should say that praksis follows access to søknadsbehandling for the sak's organisation.
  - **Frontend:** gate on `frontendrolle` `FS-ADMIN_SE_SØKNADSBEHANDLING` (see the page, entry point) and `FS-ADMIN_MODIFISERE_SØKNADSBEHANDLING` (register, change, delete, Inkluder), like the rest of the sak area (`PoengberegningCardRow.tsx:55`). Do not gate on `FS-ADMIN_OPPTAK_SØKNADSBEHANDLER`.
  - The backend gap from the first answer (B8) no longer applies. What's left: `Query.beregnPraksis` gets the same check as the rest (`SE_SØKNADSBEHANDLING`, see B6). Not tested yet: "Saksbehandlere i andre opptak ser ikke praksisen" within the same organisation.
- [x] **Q-D6** Justert sum: is the ±2-day deviation from the calendar time acceptable, or must the bound be exact?
  - Options: (a) accept the approximate bound (±2 days); (b) the bound must be exact; (c) leave for the domain experts.
  - **Decision (2026-10-08, reopened the same day): (a), ±2 days is accepted.**
    - **Where it comes from:** the month rule (Q-D2) is not additive. A 01.02.–28.02.2021 counts as 1,000 months whole, but as 14/30 + 14/30 = 0,933 months in segments. Together with B 15.02.–31.03.2021, justert becomes 2,1 months while the real time covered is 2 months.
    - **When it happens:** only when overlaps cut through a month. The amount is at most about 2–3 days in either direction (Review 2).
  - Follow-up:
    - Document it in the krav as a known consequence of the 30-day rule ("Justert sum kan ikke overstige kalendertiden" holds up to the month rule's deviation).
    - Keep the test `kortManedKjentBegrensning` (`PraksisberegnerTest.java:524-535`), and add the random cases from Review 2 as documentation of the size of the deviation.
  - The first answer, "resolved by Q-D2", fell away when Q-D2 was reopened.
- [x] **Q-D7** Should the total be stored at the time it is calculated ("ligger fast"), or always computed from the current rules?
  - Options: (a) recalculate on read, as now; (b) store a snapshot of the sums when saved; (c) leave for the domain experts.
  - **Decision (2026-10-08): (a), recalculating on read is OK.** "Registrert praksis ligger fast" means the stored periods, omfang and Inkluder choices are kept. The sums always follow the current calculation rules. The ⚠️ in the rule table and P8 in Review 3 are accepted. No backend change is needed.
  - Consequence: if the calculation rules change later, the sums change on saker that already have praksisperioder.
- [x] **Q-D8** Warning text: one warning per continuous overlap (with the varying total merged), or one per segment? Should a one-day overlap be warned about?
  - **Decision (2026-10-08), three parts:**
    1. **Split where "over 100 %" changes** (reopened the same day). Neighbouring segments are merged into one warning only while they're on the same side of 100 %. The warning gives the whole period and the number of distinct periods involved.
       - **Example 1:** A (50 %) and B (40 %) for 2020, plus C (20 %) from 01.07., gives two warnings: «Du har to perioder som overlapper (01.01.2020–30.06.2020).» and «Du har tre perioder som overlapper med et samlet omfang >100% (01.07.2020–31.12.2020). Omfang over 100% blir ikke tatt med i beregningen.»
       - **Example 2:** A (50 %) and B (60 %) for 2020, plus C (10 %) from 01.07., is over 100 % the whole way, so it gives **one** warning: «Du har tre perioder som overlapper med et samlet omfang >100% (01.01.2020–31.12.2020) …».
       - This matches the design's two text variants (design.md:70-71) exactly, and no warning claims more than is true.
       - The first answer ("one warning per continuous overlap") was dropped because a merged warning could say ">100%" for a period where only part of it is over 100 %.
    2. **Yes, warn about a one-day overlap.** Consistent with the krav (the end date is included). The current backend already reports 01.07.–01.07. at 200 % (harness, Review 2).
    3. **No explanation in the UI** that the rows don't add up to the sums. Truncation per value (krav) and unadjusted row values are accepted as they are (P3 in Review 3).

Technical questions (backend ↔ frontend contract):

- [x] **Q-T1** Where does truncation to two decimals happen, and in which number format (display-ready from the server / string scalar / frontend with decimal arithmetic)? See P1 and P2.
  - Options: (a) the server truncates and returns display-ready values; (b) the values are sent as strings, and fs-admin truncates by cutting the string; (c) JSON numbers stay, and fs-admin truncates with a float-safe helper.
  - **Decision (2026-10-08): (b), a string scalar, and fs-admin truncates.** Calculated values (`beregnetPraksis`, `sumOppgitt`, `sumJustert`, and any preview value) go over the wire as decimal strings in full precision. fs-admin truncates to two decimals by cutting the string (no float conversion), then formats with a comma.
  - Consequences and follow-ups:
    - **The scalar is shared.** `BigDecimal` is `ExtendedScalars.GraphQLBigDecimal` for the whole opptak subgraph (`_shared.graphqls:1`), and `codegen.ts:43` maps `BigDecimal → number` for **all** fields in fs-admin. Changing the shared scalar affects other features. The praksis values probably need their own type: a separate scalar, or `String` fields. That is for `bat-plan` and the backend.
    - **P1 must still be fixed in the backend.** A string truncates exactly what it receives. Today three 4-month periods at 100 % produce `"0.9999…9"`, which becomes **0,99**. The backend must avoid sums that land just below a whole number. With the month rule (Q-D2) this can be done by working in exact units, for example 1/30 month × stillingsprosent as an integer, adding up and dividing once at the end: 3 × 4 months = 12 months = exactly 1 år.
    - **fs-admin needs a new utility** for truncating decimal strings to two decimals. None exists today (see Current State, Formatting). It must also apply to "Beregnet varighet" in the form.
    - Input fields (`stillingsprosent`, `timer`, `timerPerArsverk`) can stay as numbers with at most two decimals. The question only concerns calculated values.
  - Confirmed again (2026-10-08) after going through what an edit does: truncation in fs-admin is safe for editing, because `endrePraksisperiode` only accepts input values and the backend recalculates from stored values after every save. The rules this depends on are under Technical Constraints → "Calculated values are display-only".
- [x] **Q-T2** Should the backend report time overlap regardless of %, and give "over 100 %" as a property of the overlap, as design.md:70-71 requires?
  - Options: (a) the backend reports finished warnings; (b) the backend reports all segments and fs-admin merges them; (c) fs-admin works out overlap from the dates; (d) leave open.
  - **Decision (2026-10-08): (a), the backend reports it.** The backend returns **one entry per stretch of overlap between included periods, split where "over 100 %" changes** (Q-D8.1). Each entry has: from, to (inclusive), the radnumre involved (distinct), and whether the stretch is over 100 %. Overlaps ≤ 100 % are included. Periods at 0 % are not (Q-D4). One-day overlaps are included (Q-D8.2).
  - fs-admin only picks the text variant (design.md:70 or :71) from the "over 100 %" flag, writes `{antall}` in words, and puts the warning icon on the rows named in `radnumre`. There is no overlap logic in fs-admin (Technical Constraints → "Calculated values are display-only").
  - Backend gap (blocks merge, confirms Merge readiness 1): `Praksisberegner.java:180-182` skips segments ≤ 100 %, and `PraksisOverlapp` is per segment. The test `noyaktigHundreProsent` must be turned around. The excess calculation for `sumJustert` still uses the > 100 % segments internally. The point from Q-D8.1 about overlaps with parts both over and under 100 % is resolved by splitting where "over 100 %" changes: every entry is entirely on one side of 100 %.
- [x] **Q-T3** Field-coded validation errors (e.g. `field` + `code`) instead of free text, so fs-admin doesn't have to duplicate the rules, the timer cap in particular?
  - Options: (a) the backend gives field + code for every error; (b) fs-admin validates everything itself; (c) a mix, with simple rules in fs-admin and the backend's field + code for the rest; (d) leave open.
  - **Decision (2026-10-08): (c), a mix.**
    - **fs-admin checks the simple field rules** on blur and on submit, with the design.md texts (:77-83). These are: startdato/sluttdato required, a valid date, sluttdato not before startdato, stillingsprosent 0–100, timer required, timer > 0. None of them need the calendar calculation, so this does not break "no calculation in fs-admin".
    - **The backend returns field + code** for every validation error, so fs-admin can put the text under the right field. That covers the rules fs-admin doesn't check: above all the timer cap ("Antall timer kan ikke gi mer praksis enn perioden fra startdato til sluttdato.", design.md:84, which needs the month rule), plus unknown arbeidserfaringstype and the backend's extra rules (≤ 2 decimals, max size, arbeidsgiver ≤ 200 characters). The backend still validates everything; fs-admin's checks are only for faster feedback.
  - Backend gap (blocks merge, confirms Merge readiness 3): `PraksisperiodeValideringFeil` has only `path` + free-text `message` with the "Praksisperiode N:" prefix (`PraksisperiodeRegler.java:96-158`, `praksis.graphqls:181-195`). A field and a code must be added. The texts the user sees are owned by fs-admin (next-intl), not the backend.
  - fs-admin has no pattern yet for mapping server errors to fields (Current State: errors are shown as an alert list). `bat-plan` must design that. Duplicated simple rules must stay in sync with `PraksisperiodeRegler`.
- [x] **Q-T4** Is `beregnPraksis` needed? If so: for one period only ("Beregnet varighet"), or with `sakId` so it includes the stored periods? With an errors payload and an access check?
  - Options: (a) narrow it to a preview of one period; (b) a preview with `sakId` that includes the stored periods and returns new sums; (c) drop it (no live "Beregnet varighet"); (d) leave open.
  - **Decision (2026-10-08): (a), a one-period preview.** It takes one draft period and returns only that period's calculated praksis, as a string (Q-T1), plus validation errors with field + code (Q-T3). No sums and no overlap in the answer. Access check `SE_SØKNADSBEHANDLING` for the organisation the search is about, like the rest of the sak (Q-D5).
  - fs-admin uses it only for "Beregnet varighet" (design.md:31, :74). The sum cards and the overlap warning change only after saving, through the mutation payload (Technical Constraints → "Calculated values are display-only", rule 2). The value is never added to the sums (P6 in Review 3 is no longer a risk).
  - Backend gap: today's `beregnPraksis(perioder: [PraksisperiodeInput!]!): Praksisberegning!` (`praksis.graphqls:15-19`, `PraksisberegningService.java:43-52`) takes a list, returns sums and overlap, has no errors payload and no access check. Its signature and return type must change. The "(WIP)" commit `7c13f9e032` covers the current version.
  - Open for `bat-plan`: how often fs-admin calls the preview while the user types (debounce, only when the fields are valid on the client) so as not to spam the server or show errors too early.
- [x] **Q-T5** Entry point and layout: a sibling route `sak/[sakId]/praksiskalkulator` like `endresoknad`; side panel compared with `FSModal`; should the role gate use `FS-ADMIN_OPPTAK_SØKNADSBEHANDLER` or `FS-ADMIN_MODIFISERE/SE_SØKNADSBEHANDLING` (which is what the backend actually enforces)?
  - **Decision (2026-10-08):**
    - **Route: a sibling route** `src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/praksiskalkulator/`, next to the `(sak)` group, like `endresoknad`. It has its own `PageHeaderWrapper` with a breadcrumb back to the sak, and no stage tabs, cards or drawer. Options considered: a tab inside `(sak)` (rejected, as it conflicts with the 07.10.2026 decision "egen side"), or leave open.
    - **Form: a new side panel**, as in the sketch. Options considered: `FSModal` (exists, and design.md:7 allows a dialog), or leave it to design. fs-admin has no generic side panel today (only the domain-specific `SakDrawer`), so this is new work. `bat-plan` must decide whether it becomes a common component (via `fs-admin-common-components`) or a local layout built with `Grid`/`Flex`. It must also cover focus handling, closing (Avbryt, the close icon, Escape), the collapse icon in the sketch, and behaviour on narrow screens.
    - **Role gate:** settled by Q-D5: `FS-ADMIN_SE_SØKNADSBEHANDLING` for the entry point in the sak view and the page itself, and `FS-ADMIN_MODIFISERE_SØKNADSBEHANDLING` for the actions (Opprett, Rediger, Slett, Inkluder).
    - **Still open, owned by design (design.md:107):** where the entry point goes in the sak view, and how søker and sak are shown on the page.
- [x] **Q-T6** Should "Inkluder" in the table be its own mutation, or go through `endrePraksisperiode` with all fields?
  - Options: (a) its own small mutation; (b) `endrePraksisperiode` with all fields; (c) leave open.
  - **Decision (2026-10-08): (a), its own small mutation.** It takes the sak, the radnummer and the new value, and changes only the flag: no new validation of the other fields, and no risk of sending stale field values when two søknadsbehandlere work on the same sak. It returns the sak with new sums (like `PraksisperiodePayload`) and the same error union. The audit gets its own intent, e.g. "Endret inkludering av praksisperiode". Access check `MODIFISERE_SØKNADSBEHANDLING`, like the other mutations (Q-D5).
  - Backend gap: the mutation doesn't exist today (`praksis.graphqls:22-55`). The naming should follow the krav ("Inkluder", not `relevant`), cf. the naming nit under Merge readiness.
  - Rule 4 under Technical Constraints ("send the period's original input values") still applies to `endrePraksisperiode` from the form, but no longer to the checkbox.
