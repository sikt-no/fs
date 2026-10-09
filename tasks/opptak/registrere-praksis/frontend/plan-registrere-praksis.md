# Plan: Registrere praksis (opptak): praksiskalkulator in fs-admin

> Produced by `bat-plan` on 2026-10-08. **Frontend only.** Inputs: [`analysis-registrere-praksis.md`](analysis-registrere-praksis.md) (source of truth), [`questions-bat-analyze-2026-10-08.md`](questions-bat-analyze-2026-10-08.md), [`questions-domene-registrere-praksis.md`](questions-domene-registrere-praksis.md), the spec (`fs/tasks/opptak/registrere-praksis/spec/spec-registrere-praksis.md`) and `registrere_praksis.design.md`. All Q-D1–Q-D8 and Q-T1–Q-T6 are decided and are used as given.
>
> Built only from `main` (`a44f90adb`) and the inputs above. The branches `praksiskalkulator` / `praksiskalkulator-api`, their `docs/ACTIVE/*`, and any `Praksiskalkulator` feature folder were not read.
>
> The backend changes **B2–B7** are prerequisites owned by the backend, **not tasks in this plan**. See *Dependencies*.

## Proposed Solution

### Architecture Approach

A separate client-rendered page for one sak, a **sibling route** of the `(sak)` group, like `endresoknad`:

```
src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(praksis)/
  layout.tsx                    → PageHeaderWrapper: breadcrumb back to the sak (soknadskode)
  praksiskalkulator/
    layout.tsx                  → PageHeaderWrapper: "Praksiskalkulator"
    page.tsx                    → FeatureFlag → WithRole(SE) → Suspense → <Praksiskalkulator sakId />
```

The URL is unchanged (`/opptak/[id]/soknadsbehandling/sak/[sakId]/praksiskalkulator`). The `(praksis)` route group exists because `PageHeaderWrapper` keys each crumb by the pathname minus the layout's selected segments: two wrappers at the same level get the same key, and the page crumb replaces the sak crumb. See [task-3-completion.md](task-3-completion.md).

```
Praksiskalkulator (client)                              ← page query (sak + praksisberegning)
├─ PraksisSakTopbar          søker + sak identity (FlexDataFieldSection)
├─ GuidePanel "Under utvikling"   only while the feature runs on the mock (removed in Task #16)
└─ Grid { base: 1fr, desktop: 2fr 1fr }
   ├─ PraksisperioderCard (Surface)
   │   ├─ heading "Registrerte praksisperioder" + count, "Opprett" (MODIFISERE)
   │   ├─ PraksisperioderTable (FSTable)
   │   │    Arbeidsgiver/praksistype | Periode (+⚠ when radnummer ∈ some overlapp.radnumre)
   │   │    | Omfang | Beregnet praksis | Inkluder (InkluderCheckbox) | Rediger / Slett
   │   └─ OverlappVarsler (one Alert per backend overlap entry)
   ├─ PraksisSummer (two Surface cards: sumOppgitt, sumJustert)
   └─ PraksisperiodeSidePanel (open in create/edit mode)
        └─ PraksisperiodeForm (fields, client validation, server errors)
             └─ BeregnetVarighet (beregnPraksis preview, debounced)
```

**Data flow.** The page query fetches `sak: node(id: $sakId) { id ... on Sak { praksisberegning { ...PraksisberegningFields } } }`. Every mutation (opprett, endre, slett, inkluder) selects the **same fragment** under `sak { id praksisberegning }` in its payload. Apollo normalises `Sak` on `id` and replaces the embedded `praksisberegning`, so the table, overlap warnings and sums re-render from the backend's numbers with no refetch and no client arithmetic (Technical Constraints → "Calculated values are display-only", rules 1–4).

**Calculated values are strings.** `beregnetPraksis`, `sumOppgitt`, `sumJustert` and the preview value arrive as decimal strings (Q-T1). They go through exactly one function, `formatTruncatedDecimal` (Task #1), and nothing else in fs-admin reads them as numbers.

**Building before the backend is live (mock phase).** Codegen reads the published SDL (`production/experimental`), so praksis types exist only after B2–B7 are merged and deployed. Until then:

1. The **assumed target contract** lives in one file, `praksisContract.ts` (Task #2): TS types, enums for field/code, and the list of assumed names.
2. The feature folder is **excluded from codegen** (same as the `kodeverk` WIP and the applikasjoner mock in `codegen.ts`). Operations use `gql` from `@apollo/client` typed with `TypedDocumentNode<…>` from the contract file.
3. **MSW handlers** in `src/mocks/praksis/` (Task #7) answer the praksis operations in the browser, through the existing `MockProvider`. All other operations (sak, personalia, roles) go to the real gateway (`onUnhandledRequest: 'bypass'`). Because MSW is browser-only, **all praksis data is fetched from client components**.
4. The feature stays hidden behind a feature flag, and the page shows `fs-admin-under-utvikling`'s GuidePanel.
5. **Task #16 swaps to the published schema.** It is the only task that touches generated types. It removes the exclusion, switches to `graphql()`, applies the real names, and deletes the contract file, the mock and the GuidePanel.

`GRAPHQL_SCHEMA_INTROSPECTION_URL` may be used **locally** (`.env.local`) by a developer to check the operations against a backend branch. It is **never** part of a task's deliverable: never committed, never in `.env.example`, `mise.toml`, `k8s/` or CI.

### Target backend contract (assumed, single place)

The plan is written against the contract the analysis agreed on, not the current backend branch. **Every name below is a placeholder until the schema is published.** In code, they exist only in `praksisContract.ts` and in the `gql` documents, which Task #16 replaces.

| Concept | Decision | Assumed name/shape (placeholder) | Backend change |
|---|---|---|---|
| Root lookup | the sak is read through `node(id:)` + `... on Sak`, as everywhere in the sak area (`getSakBadgeCounts.operation.ts`) | `sak: node(id: $sakId) { id ... on Sak { praksisberegning { ... } } }`. The mock must return `__typename: "Sak"` so the inline fragment matches | exists |
| Read | `Sak.praksisberegning` (nullable), computed on read | `Sak.praksisberegning: Praksisberegning` | exists |
| Period | no `id`; `radnummer` identifies it within the sak | `Praksisperiode { radnummer: Int!, startdato: LocalDate!, sluttdato: LocalDate!, grunnlag: PraksisGrunnlag!, stillingsprosent, timer, timerPerArsverk, arbeidsgiver, arbeidserfaringstype { id kode navn }, inkludert: Boolean!, beregnetPraksis: <Desimaltekst> }` | rename `relevant` → "inkluder" (nit); B3 |
| Grunnlag | one per period | `enum PraksisGrunnlag { STILLINGSPROSENT, TIMER }` | exists |
| Calculated values | decimal strings, full precision, **plain notation** (no exponent) | `beregnetPraksis`, `sumOppgitt`, `sumJustert`: `String!` or a dedicated scalar mapped to `string` | B2, B3 (Q-T1) |
| Overlap | one entry per stretch, split where ">100 %" changes; includes ≤100 %, one-day; excludes 0 % | `overlapp: [PraksisOverlapp!]!`, `PraksisOverlapp { fra: LocalDate!, til: LocalDate!, radnumre: [Int!]!, over100Prosent: Boolean! }` | B4 (Q-T2, Q-D8) |
| Validation errors | field + code, no "Praksisperiode N:" prefix | `PraksisperiodeValideringFeil { message, path, felt: PraksisperiodeFelt, kode: PraksisperiodeFeilkode }` | B5 (Q-T3) |
| Felt | | `STARTDATO, SLUTTDATO, STILLINGSPROSENT, TIMER, TIMER_PER_ARSVERK, ARBEIDSGIVER, ARBEIDSERFARINGSTYPE` | B5 |
| Feilkode | | `PAKREVD, UGYLDIG_DATO, SLUTTDATO_FOR_STARTDATO, UTENFOR_GYLDIG_OMRADE, MA_VAERE_STORRE_ENN_NULL, OVERSTIGER_KALENDERTID, FOR_MANGE_DESIMALER, FOR_LANG, UKJENT_KODE` | B5 |
| Mutations | one period at a time; payload returns the sak | `opprettPraksisperiode`, `endrePraksisperiode`, `slettPraksisperiode`; payload `{ sak { id praksisberegning }, errors: [...] }` (errors envelope, as `useGetMutationErrors` expects) | exists, B5 |
| Inkluder | its own mutation, only the flag | `endreInkluderingAvPraksisperiode(input: { sakId, radnummer, inkludert })` → same payload | B7 (Q-T6) |
| Preview | one period, value + field-coded errors, `SE_` access check | `beregnPraksisperiode(sakId: ID!, periode: PraksisperiodeUtkastInput!): { beregnetPraksis: <Desimaltekst>, errors: [...] }` | B6 (Q-T4) |
| Code list | opptak copy, active only | `Query.arbeidserfaringstyper { id kode navn }` | exists (Q-D1) |
| Access | as the sak | `SE_/MODIFISERE_SØKNADSBEHANDLING` (RLS) | exists (Q-D5) |

When the schema is published, Task #16 reconciles this table with the real SDL. If a name differs, it changes in `praksisContract.ts`'s replacement (generated types) and the `gql` documents only.

### Key Technical Decisions

1. **Decision: the side panel is local to the feature (`PraksisperiodeSidePanel`), not a common component.**
    - Why:
        - The two existing panels, `SakDrawer` and `RegelverkSidePanel` (the analysis missed the second), are a different pattern. Both are **persistent, collapsible, tabbed info drawers** with a toggle button and `inert` tab content.
        - The form panel is **open-on-action**, with a heading, a close button, Avbryt/Bekreft, and focus that goes in and comes back. That leaves one callsite for this pattern.
        - It fails `fs-admin-common-components`' pattern test: no three unrelated callsites yet. Common's bar (Storybook Playground, CLAUDE.md, responsive 320–1920 px, domain-free texts as props) would be speculative abstraction now.
        - It is written domain-free inside (texts as props), so it can be promoted when a second callsite appears. That is noted in a comment, as `fs-admin-common-components` asks.
    - **A11y and focus contract:**
        - Non-modal `<section aria-labelledby={headingId}>`, with no focus trap, so the table stays usable while the panel is open.
        - On open, focus moves to the panel heading (`tabIndex={-1}`), so screen readers announce "Legg til praksisperiode" / "Rediger praksisperiode". On close (Avbryt, the X `aria-label="Lukk"`, Escape inside the panel, or a successful save), focus returns to the element that opened it (Opprett or that row's Rediger). If that element no longer exists (the row was deleted), focus goes to the card heading.
        - Escape is ignored while a datepicker or select popover inside the panel is open (they handle Escape themselves).
        - Clicking Rediger on another row while the panel is open replaces the content. Unsaved changes are discarded (ASSUMPTION A7).
    - **Narrow screens:** `Grid gridTemplateColumns={{ base: '1fr', desktop: '2fr 1fr' }}`. On narrow screens the panel stacks below the card, and focus moving to its heading scrolls it into view. There is no second (dialog) implementation.
    - **The collapse icon (⤡) in the sketch** is a panel↔dialog toggle. It is left out (ASSUMPTION A2): one container, no FSModal variant.
    - Alternative considered:
        - (a) A new common `SidePanel`: premature (see above).
        - (b) Reuse `RegelverkSidePanel`: it is in the regelverk domain and tabbed.
        - (c) `FSModal`: design.md:7 allows it, but Q-T5 chose a side panel.

2. **Decision: field errors are one feature-local `FieldErrors` map, fed by both client rules and server errors. No form library.**
    - Shape: `type PraksisperiodeFelt = …` (from the contract), `type FieldErrors = Partial<Record<PraksisperiodeFelt, string>>`.
    - **Client rules** in `validatePraksisperiode.ts`, the `getFieldError` precedent from `OpprettRundeForm`:
        - `validateField(felt, form, t)` runs on blur.
        - `validateAll(form, t)` runs on submit. It sets "touched" on all fields and stops the submit if any field has an error.
        - Rules (design.md:77-83, Q-T3): startdato/sluttdato required; a valid date; sluttdato ≥ startdato; stillingsprosent 0–100; timer required when grunnlag = TIMER; timer > 0.
        - **No calendar arithmetic:** the timer cap (design.md:84) is server-only.
    - **Server errors** in `mapPraksisperiodeErrors.ts`, a pure function: `(errors, t) → { fieldErrors, generalErrors }`.
        - `felt` decides the field. `kode` → i18n key through one lookup table in the same file. Known codes use the design.md texts; for example, `OVERSTIGER_KALENDERTID` → "Antall timer kan ikke gi mer praksis enn perioden fra startdato til sluttdato."
        - An unknown `kode` with a known `felt` → a generic field text ("Verdien er ikke gyldig.").
        - An unknown or missing `felt`, or a non-validation error such as `IkkeTilgangFeil` or `FinnesIkke` → `generalErrors`. These are shown as an `Alert variant="error"` at the top of the panel.
        - Top-level GraphQL errors → `useGetMutationErrors` → `generalErrors`.
        - **The server's message text is never shown.** The texts belong to fs-admin (Q-T3).
    - **Merge rule** in `usePraksisperiodeForm`:
        - The server's field errors replace the client's for the same field after submit.
        - When the user edits a field, its error is cleared.
        - On blur, the field is validated again by the client rules.
    - The same mapper handles `beregnPraksisperiode` preview errors. Those are shown only on fields the user has already touched, so they don't appear too early. This shows the timer cap before submit.
    - Errors are rendered through each input's own `errorText`/`error` prop (SDS). The input gets `aria-invalid` and `aria-describedby` from the component.
    - Alternative considered: react-hook-form or similar was rejected (CLAUDE.md: don't add libraries; no precedent in the repo).

3. **Decision: `formatTruncatedDecimal(value: string | null | undefined): string | null`, a string-only utility in `src/common/utils/decimalUtil/`.**
    - It parses `^-?\d+(\.\d+)?$`. It throws in development and returns `null` (rendered as `-`) for anything else, including exponent notation (`1E+1`, `5E-3`), so a malformed value is never shown as a plausible number.
    - It cuts the fraction to 2 digits, right-pads with `0`, and joins with `,`.
    - Integer part: grouping as nb-NO for ≥ 1000 (narrow no-break space, via `Intl.NumberFormat('nb-NO')` on the **integer digits only**, which are safe as `BigInt`).
    - No `Number()`, no `parseFloat`, no `toFixed`, no `Math.floor` anywhere in the path.
    - Required tests (P1/P2 in the analysis plus padding):

      | Input | Output |
           |---|---|
      | `"0.9999999999999999999999999999999999"` | `0,99` |
      | `"0.29"` | `0,29` (not `0,28`) |
      | `"0.57"` / `"1.15"` / `"4.35"` | `0,57` / `1,15` / `4,35` |
      | `"2.875"` | `2,87` |
      | `"1.996"` | `1,99` |
      | `"1"` / `"0"` / `"2.5"` / `"0.1"` | `1,00` / `0,00` / `2,50` / `0,10` |
      | `"0.0417"` / `"0.125"` | `0,04` / `0,12` |
      | `"1234.5"` | `1 234,50` |
      | `"1E+1"`, `""`, `"abc"`, `"1,5"` | `null` |
      | `null` / `undefined` | `null` |

    - Why common: the function is pure, domain-free and meets the common quality bar on its own. It is also the only safe answer to "truncate a BigDecimal string" anywhere in fs-admin.
    - Alternative considered: `Math.floor(v * 100) / 100` on numbers. It is wrong for P2 (`0.29 → 0,28`) and loses precision for P1.

4. **Decision: the table is `FSTable`.**
    - Setup: `getRowId = String(radnummer)`, `caption` = the card heading (visually hidden), `headerBackgroundColor="neutral"`.
    - Columns as design.md:16-23. Arbeidsgiver is bold. Type is "KODE – navn" on its own line. A missing arbeidsgiver or type gives `-`, in normal weight (`fs-admin-placeholder`).
    - Overlap icon:
        - `overlappendeRadnumre = new Set(overlapp.flatMap(o => o.radnumre))`, computed once.
        - Rows in the set get a warning icon inside the Periode cell's `getValue`, with `ScreenReaderOnly` text "Overlapper med en annen periode".
        - `highlightedRowIds` is not used: it changes row styling, and the icon is what the design asks for.
        - This is set membership on backend data, not overlap logic.
    - **Inkluder:**
        - `FSCheckbox` per row, with `aria-label` "Inkluder perioden {fra}–{til}".
        - **No optimistic toggle:** the checked state comes from the cache. The checkbox is disabled while its own mutation is pending.
        - Without MODIFISERE it is disabled (read-only).
        - `WithRole`'s indicator is turned off inside cells (`hideIndicator`, per its docs).
    - **Rediger / Slett:** `FSButton` "Rediger" (transparent, pencil icon) and `ButtonWithConfirmation` "Slett" (trash icon). Both are rendered only with MODIFISERE.
    - **Delete is confirmed** (ASSUMPTION A4), with message "Vil du slette praksisperioden {fra}–{til}?". `ButtonWithConfirmation` already gives the fixed "Bekreft handling / Avbryt / Bekreft" dialog. Delete can't be undone and changes the sums, so the cost of one extra click is low.
    - Alternative considered: `ActionList`. Rejected by `fs-admin-tables-vs-lists`: a small, bounded table-shaped data set with no filter or paging, and the sketch is a table.

5. **Decision: cache via the mutation payload and a shared fragment. No refetch by default, no optimistic response.**
    - One feature-local fragment, `PraksisberegningFields` in `praksisberegningFragment.ts`, is spread by the page query and by **all four** mutation payloads: `sak { id praksisberegning { ...PraksisberegningFields } }`.
    - Because `Praksisberegning` and `Praksisperiode` have no `id`, Apollo replaces the embedded object as a whole. Identical selections keep this clean, with no "cache data may be lost" warning.
    - This is a deliberate exception to "don't reuse queries between components". It is a fragment, not a query, and it is what makes the payload update work. Say so in a comment.
    - `refetchQueryNames('PraksiskalkulatorSak')` is the **fallback only**. Use it if the published payload does not return `sak` (decided in Task #16).
    - No `optimisticResponse` and no `cache.modify` arithmetic (rules 1–2).
    - `arbeidserfaringstyper` selects `id` (`@graphql-eslint/require-selections`), and `Sak` selects `id`.

6. **Decision: the page and its entry point.**
    - **Route:** sibling route `sak/[sakId]/(praksis)/praksiskalkulator/` (Q-T5; URL `sak/[sakId]/praksiskalkulator`). It has **two** `PageHeaderWrapper` levels, in two layouts:
        - The sak crumb in `(praksis)/layout.tsx` (`soknadskode ?? sakId.slice(0,7)`, href to `/opptak/[id]/soknadsbehandling/sak/[sakId]`). Routes outside `(sak)` do not get the sak crumb from `(sak)/layout.tsx`.
        - The page crumb "Praksiskalkulator" in `(praksis)/praksiskalkulator/layout.tsx`.
    - **Gates:**
        - `FeatureFlag` (Task #3) wraps the whole page.
        - `WithRole permittedRoles={[frontendrolle.FS_ADMIN_SE_SØKNADSBEHANDLING]}` wraps the page and the entry point.
        - `useWithRole([frontendrolle.FS_ADMIN_MODIFISERE_SØKNADSBEHANDLING])` gates Opprett, Rediger, Slett and Inkluder.
        - The `frontendrolle` const is used, not bare strings (CLAUDE.md). The older sak code uses bare strings, but new code doesn't.
        - Not `FS-ADMIN_OPPTAK_SØKNADSBEHANDLER` (Q-D5).
        - `permittedOrganizations` is left `undefined`, consistent with the rest of the sak area. The backend's RLS enforces access per organisation.
    - **Entry point (ASSUMPTION A1):**
        - A `PraksiskalkulatorButton` (`ButtonLink`, typed href) placed next to `EndreSoknadButton` in `SaksbehandlerCard.tsx:229`.
        - It is its own component, so moving it is one import plus one JSX line.
        - Label "Praksiskalkulator", the page's name. It is a navigation link, so it is a noun, not "Opprett".
    - **Søker and sak on the page (ASSUMPTION A1):**
        - A topbar `FlexDataFieldSection` with `FSOutputField`s for Søker (fornavn etternavn), Saksnummer, Søknad (søknadskode) and Opptak (navn).
        - Its own `PraksisSakTopbar` query on existing schema fields (the `PersonaliaCard` fields). It does not reuse `PersonaliaSak`.
        - **Not schema-blocked.**

7. **Decision: hide the feature behind a new Unleash flag, `soknadsbehandling-praksiskalkulator` (ASSUMPTION A9 for the name).**
    - Mock phase: `environmentsOverride={{ inReview: true, inDevelopment: true }}`. **Not `inTest`**, because `MockProvider` runs MSW in test too, and test users must not see mock praksis data.
    - Task #16 adds `inTest: true` once the real backend is in `production/experimental`.
    - Production follows the Unleash strategy (off).
    - Creating the flag in Unleash is an operator step outside the repo. After it, `npm run generate:unleash` updates `FeatureName`. Until then, Task #3 uses a typed cast with a comment, like `MockProvider` does for its local flag, and Task #16 removes it.

8. **Decision: preview ("Beregnet varighet") is debounced and only sent when the inputs are valid.**
    - `useBeregnPraksisPreview(sakId, form)` uses `useLazyQuery`. It fires 400 ms after the last change, and only when `validateAll` would pass for startdato, sluttdato and omfang (timer + timerPerArsverk or stillingsprosent). Arbeidsgiver and type don't affect the value and are not sent.
    - Stale responses are ignored (compare a request counter).
    - Display: `= {x} år` via `formatTruncatedDecimal`. Before a valid response, or while invalid, it shows `= - år` (ASSUMPTION A3; design.md:74 says "tom verdi").
    - The value is in an `aria-live="polite"` `FSOutputField`, so screen-reader users hear the update. The value is **never** added to the sums (Q-T4, P6).

9. **Decision: overlap warnings are only text selection over backend entries.**
    - One `Alert variant="warning"` per `overlapp` entry. Text variant: `over100Prosent` → design.md:71, else design.md:70.
    - `{antall}` = `radnumre.length`, written in words by `tallSomOrd(n)` (feature-local util: "to", "tre", … "tolv", digits above 12; ASSUMPTION A6).
    - `{fra}–{til}` via `dateUtil` `dateFormats.date`.
    - The order is the backend's order.

### File Changes Overview

New feature folder `src/domains/soknadsbehandling/features/Praksiskalkulator/` (**excluded from codegen until Task #16**):

```
Praksiskalkulator/
├── Praksiskalkulator.tsx (+ .a11y.test.tsx, .test.tsx)          page query, layout Grid, panel state
├── praksisContract.ts                                             ASSUMED contract (deleted in #16)
├── praksisberegningFragment.ts                                    shared fragment (see Decision 5)
├── components/
│   ├── PraksisperioderCard/
│   ├── PraksisperioderTable/
│   ├── InkluderCheckbox/
│   ├── SlettPraksisperiodeButton/
│   ├── OverlappVarsler/
│   ├── PraksisSummer/
│   ├── PraksisperiodeSidePanel/
│   ├── PraksisperiodeForm/
│   └── BeregnetVarighet/
├── hooks/
│   ├── usePraksisperiodeForm.ts (+ .test.ts)
│   └── useBeregnPraksisPreview.ts (+ .test.ts)
└── utils/
    ├── praksisperiodeFormState.ts (+ .test.ts)        form ⇄ stored period ⇄ mutation input (input values only)
    ├── validatePraksisperiode.ts (+ .test.ts)
    ├── mapPraksisperiodeErrors.ts (+ .test.ts)
    ├── formatOmfang.ts (+ .test.ts)                   "{prosent}%" / "{timer} timer (av {årsverk})"
    └── tallSomOrd.ts (+ .test.ts)
```

Other new files:

- `src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(praksis)/layout.tsx` (+ `layout.test.tsx`)
- `src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(praksis)/praksiskalkulator/{layout,page}.tsx` (+ `page.a11y.test.tsx`)
- `src/domains/soknadsbehandling/features/PraksiskalkulatorButton/` (entry point, real schema only)
- `src/domains/soknadsbehandling/features/PraksisSakTopbar/` (søker + sak identity; **outside** the excluded folder so it gets generated types from the real schema now)
- `src/common/utils/decimalUtil/formatTruncatedDecimal.ts` (+ `.test.ts`)
- `src/mocks/praksis/` (`schema/praksis.graphql`, `fixtures/`, `handlers/`, `store/`, `types.ts`, `teardown-praksis.md`)

Changed files:

- `codegen.ts`: exclude `src/domains/soknadsbehandling/features/Praksiskalkulator/**` (and the app route folder if it ever imports a praksis document) with a comment (Task #2; removed in #16).
- `src/mocks/handlers.ts`: register `praksisHandlers` (Task #7).
- `src/mocks/applikasjoner/teardown-applikasjoner.md`: note that `MockProvider`/`browser.ts`/`handlers.ts` are now also used by the praksis mock and must not be removed with applikasjoner (Task #7).
- `src/domains/soknadsbehandling/features/SaksbehandlerCard/SaksbehandlerCard.tsx`: render `PraksiskalkulatorButton` (Task #4).
- `src/common/messages/nb/soknadsbehandling.json`: new namespaces per component (`fs-admin-i18n-structure`), plus `common.underUtvikling` (doesn't exist for soknadsbehandling yet).
- `src/common/types/generated/unleash.ts`: regenerated after the flag exists (operator step, then Task #3 or #16).

**GraphQL:** there is no `## GraphQL-endringer` section. The schema belongs to the backend, and the contract decisions are already made (Q-T1–Q-T6, B2–B7). The assumed shape is in *Target backend contract* above. `bat-graphql-dev` was not run.

## Implementation Tasks

Legend for **Schema**:

- 🟢 **independent**: no praksis types; can merge any time.
- 🟡 **mock-backed**: written against `praksisContract.ts`, runs on MSW, renamed in Task #16.
- 🔴 **blocked**: needs the published schema (B2–B7 merged and deployed to `production/experimental`).

Order: tasks #1–#7 do not depend on the schema. #8–#15 build on the contract and the mock. #16 is the switch to the published schema. #17 is the changeset.

Common to **every** task:

- Follow CLAUDE.md: `function` components, `Grid`/`Flex` only (no `display:flex/grid` in CSS), and no custom styling on input or output fields.
- Every component gets `*.a11y.test.tsx` (jest-axe + `MockedProvider`, roles via `tilgangerMedRoller(...)`).
- Texts go through next-intl, following `fs-admin-i18n-structure`.
- Tests import operation documents from the component file and never redeclare them.
- No `__typename` in documents.
- `npm run lint`, typecheck and the affected tests pass.

---

### Task #1: Truncation utility for decimal strings ✅ ([completion](task-1-completion.md))

**Priority**: High · **Size**: S · **Dependencies**: None · **Schema**: 🟢
**Skills**: (none UI-specific). Read `src/common/utils/` conventions.
**Addresses**: *Summen avkortes til to desimaler i visningen*, *Praksis beregnes med full presisjon* (display side), Q-T1.

**Files**: `src/common/utils/decimalUtil/formatTruncatedDecimal.ts`, `formatTruncatedDecimal.test.ts`

**Acceptance Criteria**:

- [ ] `formatTruncatedDecimal(value: string | null | undefined): string | null` as in Decision 3.
- [ ] All test cases in the Decision 3 table pass, including `0,999… → 0,99`, `0.29 → 0,29`, padding (`"1" → 1,00`), and exponent or garbage input → `null`.
- [ ] No `Number`, `parseFloat`, `toFixed`, `Math.*` or float arithmetic in the implementation (a unit test asserts this for a 34-digit input where float conversion would round up: `"0.9999999999999999999999999999999999"` must not give `1,00`).
- [ ] The JSDoc states the contract: the input is a plain-notation decimal string from the backend, the output is display-only, and the result must never be fed back into arithmetic.

---

### Task #2: Assumed contract file + codegen exclusion ✅ ([completion](task-2-completion.md))

**Priority**: High · **Size**: S · **Dependencies**: None · **Schema**: 🟡 (it *is* the assumption)
**Skills**: `graphql-consumer`
**Addresses**: Q-T1–Q-T4, Q-T6 (shape only).

**Files**: `src/domains/soknadsbehandling/features/Praksiskalkulator/praksisContract.ts`, `praksisberegningFragment.ts`, `codegen.ts`

**Acceptance Criteria**:

- [ ] `praksisContract.ts` holds TS types for every shape in *Target backend contract* (`Praksisperiode`, `Praksisberegning`, `PraksisOverlapp`, `PraksisGrunnlag`, `PraksisperiodeFelt`, `PraksisperiodeFeilkode`, `PraksisperiodeValideringFeil`, the inputs, the payloads, `Arbeidserfaringstype`) and a `Desimaltekst = string` alias.
- [ ] The header comment lists every assumed name, points to this plan's contract table and to B2–B7, and states "delete in Task #16".
- [ ] `praksisberegningFragment.ts` exports the `PraksisberegningFields` fragment (`gql`, typed), with all fields the page needs: periods (input fields + `beregnetPraksis` + `inkludert`), `sumOppgitt`, `sumJustert`, and `overlapp { fra til radnumre over100Prosent }`.
- [ ] `codegen.ts` excludes the feature folder, with a comment in the same style as the kodeverk/applikasjoner exclusions ("remove in Task #16 of plan-registrere-praksis"). `npm run compile` passes.
- [ ] No other file declares praksis type names. Grep for `Praksisperiode` outside the feature folder and `src/mocks/praksis/` returns nothing.

**Implementation notes**: `require-selections` only runs on `GRAPHQL_REQUIRE_ID_PATHS`, which doesn't include this folder, so lint won't break on unknown types. Don't add the folder to that list until Task #16.

---

### Task #3: Route, layout, breadcrumbs, gates and page shell ✅ ([completion](task-3-completion.md))

**Priority**: High · **Size**: M · **Dependencies**: None (operator: Unleash flag, see Dependencies) · **Schema**: 🟢
**Skills**: `fs-admin-under-utvikling`, `fs-admin-i18n-structure`, `fs-admin-grid-and-flex`, data-field-sections (`src/common/components/data-field-sections/CLAUDE.md`), `graphql-consumer`, `fs-admin-placeholder`. Read `node_modules/next/dist/docs/` for `layout`/`page` + `PageProps` conventions.
**Addresses**: *Søknadsbehandler kan registrere praksis* (read part), *Bruker uten søknadsbehandler-rollen ser ikke registrert praksis* (frontend half, see the Q-D5 note in the traceability table), design.md:7-9, :48.

**Files**:

- `src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(praksis)/layout.tsx` (sak crumb), `(praksis)/praksiskalkulator/layout.tsx`, `page.tsx`
- `Praksiskalkulator/Praksiskalkulator.tsx` (shell: topbar + GuidePanel + empty Grid slots), `.a11y.test.tsx`
- `src/domains/soknadsbehandling/features/PraksisSakTopbar/PraksisSakTopbar.tsx`, `.a11y.test.tsx`, `.test.tsx`. It lives outside `Praksiskalkulator/` because that folder is excluded from codegen (Task #2), and this query must use generated types (`graphql()` from `@/__generated__`)
- `src/common/messages/nb/soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] Visiting `/opptak/{id}/soknadsbehandling/sak/{sakId}/praksiskalkulator` renders the page title "Praksiskalkulator". The breadcrumbs end with `… › Saker › {soknadskode} › Praksiskalkulator`, and the sak crumb links to the sak.
- [ ] The page is wrapped in `FeatureFlag flag="soknadsbehandling-praksiskalkulator"` with `environmentsOverride={{ inReview: true, inDevelopment: true }}`. If the flag is not yet in `FeatureName`, use a cast with a comment pointing to Task #16.
- [ ] `WithRole permittedRoles={[frontendrolle.FS_ADMIN_SE_SØKNADSBEHANDLING]}` wraps the content. A user without it gets the existing no-access fallback used elsewhere (find it, e.g. `FeatureDisabledMessage`); there is no praksis content and no query is fired.
- [ ] `PraksisSakTopbar` shows Søker, Saksnummer, Søknad and Opptak in a `FlexDataFieldSection` with `FSOutputField`. Its own query (operation name `PraksisSakTopbar`) uses **existing** schema fields and selects `id` on `Sak`. Missing values show `-`.
- [ ] The `GuidePanel variant="info"` follows `fs-admin-under-utvikling`. It is placed above the content, with title `soknadsbehandling.common.underUtvikling` (new key) and the message "Praksisperiodene er testdata til backend er klar." (wording ASSUMPTION A10).
- [ ] The layout `Grid` has slots for the card, the sums and the panel (`{ base: '1fr', desktop: '2fr 1fr' }`).
- [ ] The a11y tests cover: with the role, without the role, and with the flag off.

---

### Task #4: Entry point from the sak view ✅ ([completion](task-4-completion.md))

**Priority**: Medium · **Size**: S · **Dependencies**: #3 · **Schema**: 🟢
**Skills**: `fs-admin-buttons`, `fs-admin-i18n-structure`
**Addresses**: *Bruker uten søknadsbehandler-rollen ser ikke praksisregistreringen*, design.md:48 / :107 (ASSUMPTION A1).

**Files**: `src/domains/soknadsbehandling/features/PraksiskalkulatorButton/PraksiskalkulatorButton.tsx`, `.a11y.test.tsx`, `.test.tsx`; `SaksbehandlerCard.tsx`; `soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] `ButtonLink size="small"` with a typed `href` `{ pathname: '/opptak/[id]/soknadsbehandling/sak/[sakId]/praksiskalkulator', params }` and the label "Praksiskalkulator".
- [ ] It is rendered only when the flag is on (same flag and override as Task #3) **and** the user has `FS_ADMIN_SE_SØKNADSBEHANDLING`.
- [ ] It is placed next to `EndreSoknadButton` in `SaksbehandlerCard`. Moving it is a one-line change, documented in a code comment that refers to ASSUMPTION A1.
- [ ] Tests: hidden without the role, hidden with the flag off, and the link target is correct.

---

### Task #5: `PraksisperiodeSidePanel`, the form container ✅ ([completion](task-5-completion.md))

**Priority**: High · **Size**: M · **Dependencies**: None · **Schema**: 🟢
**Skills**: `fs-admin-grid-and-flex`, `fs-admin-buttons`, `fs-admin-i18n-structure`; read `fs-admin-modal` for the close/focus conventions the panel mirrors; `fs-admin-common-components` (to document why it is *not* common).
**Addresses**: design.md:7, :27, :45 ("Avbryt lukker skjemaet uten å lagre"), Q-T5.

**Files**: `Praksiskalkulator/components/PraksisperiodeSidePanel/PraksisperiodeSidePanel.tsx`, `.module.css` (visual only: surface and padding, no layout), `.a11y.test.tsx`, `.test.tsx`

**Acceptance Criteria**:

- [ ] Props: `open`, `heading`, `closeLabel`, `onClose`, `returnFocusRef`, `fallbackFocusRef`, `children`. All texts come in as props (domain-free inside), with a comment "candidate for common when a second callsite appears".
- [ ] It renders a non-modal `<section aria-labelledby>` with an `h2` heading (`tabIndex={-1}`) and a close icon button (`aria-label` from props).
- [ ] On open, focus moves to the heading. On close, focus goes to `returnFocusRef` if it is still connected, otherwise to `fallbackFocusRef` (tested).
- [ ] Escape inside the panel calls `onClose`, except when the event comes from an open popover (`event.defaultPrevented`). Escape outside the panel does nothing.
- [ ] No focus trap. A test asserts that Tab can leave the panel.
- [ ] It renders nothing when `open` is false. It is responsive via the parent `Grid` (no media queries in the panel).
- [ ] jest-axe has no violations in the open state.

---

### Task #6: Client validation, server error mapping and the form-state hook ✅ ([completion](task-6-completion.md))

**Priority**: High · **Size**: M · **Dependencies**: #2 · **Schema**: 🟡 (`felt`/`kode` names)
**Skills**: `fs-admin-inputs` (error texts and placement), `fs-admin-i18n-structure`
**Addresses**: *Startdato og sluttdato er obligatorisk*, *Praksisperiode uten sluttdato kan ikke lagres*, *Sluttdato før startdato kan ikke lagres*, *Ugyldig dato kan ikke lagres*, *Stillingsprosent utenfor 0–100 %*, *Praksisperiode med omfang i timer kan ikke lagres uten antall timer*, *Antall timer på 0 eller mindre*, *Timer som gir mer praksis enn kalendertiden* (server mapping), *Endring som gir mer praksis enn kalendertiden* (server mapping), Q-T3.

**Files**: `Praksiskalkulator/utils/praksisperiodeFormState.ts`, `validatePraksisperiode.ts`, `mapPraksisperiodeErrors.ts`, `hooks/usePraksisperiodeForm.ts`, each with `.test.ts`; `soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] `praksisperiodeFormState`:
    - `emptyForm()`: grunnlag STILLINGSPROSENT, `timerPerArsverk` `'1650'`, `inkludert` not part of the form.
    - `fromPeriode(p)`: input fields only, no `beregnetPraksis`.
    - `toOpprettInput(sakId, form)`: `inkludert: true` (*En ny praksisperiode er inkludert som standard*).
    - `toEndreInput(sakId, radnummer, form)`: **all** input fields (rule 4). Only the fields for the selected grunnlag are sent; the other omfang fields are `null`.
    - Each has a unit test.
- [ ] `validateField`/`validateAll` implement exactly the Q-T3 client rules, with the design.md:77-83 texts:
    - "Oppgi startdato." / "Oppgi sluttdato." / "Sluttdatoen kan ikke være før startdatoen." / "Oppgi en gyldig dato, for eksempel 01.07.2022." / "Oppgi en stillingsprosent fra 0 til 100." / "Oppgi antall timer i perioden." / "Antall timer må være mer enn 0."
    - Tests for each, plus boundaries: 0 and 100 are valid; 100.01 and -1 are invalid; startdato = sluttdato is valid; 31.02.2022 is an invalid date; sluttdato in the future is valid (*Sluttdato fram i tid regnes som oppgitt*).
    - **No calendar-time calculation** (a test asserts that 9999 timer over one day passes client validation).
- [ ] `mapPraksisperiodeErrors` follows Decision 2. Tests cover: every `kode` → text, `OVERSTIGER_KALENDERTID` → design.md:84 text on `TIMER`, an unknown `kode` → generic field text, an unknown `felt` → `generalErrors`, a non-validation error type → `generalErrors`, and the server `message` is never used.
- [ ] `usePraksisperiodeForm` exposes `form`, `setField`, `blur(felt)`, `touched`, `fieldErrors`, `generalErrors`, `submit(handler)` and `applyServerErrors(errors)`, with the merge rule from Decision 2. Tests: blur shows errors, editing clears them, submit with errors does not call the handler, and server errors land on the right field.
- [ ] A comment in `validatePraksisperiode.ts` says: "keep in sync with `PraksisperiodeRegler` (fs-plattform); backend is authoritative".

---

### Task #7: Mock API for the praksis operations (MSW) ✅ ([completion](task-7-completion.md))

**Priority**: High · **Size**: M · **Dependencies**: #2 · **Schema**: 🟡
**Skills**: `fs-admin-mock-api-with-data` (run it; the shape comes from `praksisContract.ts` + this plan's contract table), `graphql-consumer`
**Addresses**: enables building and testing #8–#15 before B2–B7. Fixtures mirror the spec's own examples.

**Files**: `src/mocks/praksis/{schema/praksis.graphql, types.ts, fixtures/*, store/*, handlers/{index,queries,mutations}.ts, handlers/*.test.ts, teardown-praksis.md}`; `src/mocks/handlers.ts`; `src/mocks/applikasjoner/teardown-applikasjoner.md`

**Acceptance Criteria**:

- [ ] Handlers for the praksis part of the page query (`PraksiskalkulatorSak`), `Arbeidserfaringstyper`, `BeregnPraksisperiode`, `OpprettPraksisperiode`, `EndrePraksisperiode`, `SlettPraksisperiode` and `EndreInkluderingAvPraksisperiode`. The operation names match the feature's documents exactly.
- [ ] The page query handler must return the **real** sak for non-praksis fields, or the page query is split so that only praksis operations are mocked. Pick one and document it in `teardown-praksis.md`. Recommended: the page query selects only `sak: node(id: $sakId) { id ... on Sak { praksisberegning {…} } }`, so the mock can answer it whole, with `__typename: "Sak"` (plus `__typename` on every nested object) so the inline fragment and Apollo normalisation work as they will against the real schema.
- [ ] **The mock does not calculate.** Fixtures are canned `Praksisberegning` states keyed by scenario, with values taken from the spec and the analysis, as strings:
    - the 3,50 år example;
    - 50 % + 60 % → oppgitt `"1.1"`, justert `"1"`, one overlap `over100Prosent: true`;
    - 50 % + 40 % → one overlap with `over100Prosent: false`;
    - the A/B/C Q-D8 example 1 (two entries) and example 2 (one entry);
    - P1 `"0.9999999999999999999999999999999999"`;
    - 478,5 t → `"0.29"`;
    - the empty sak;
    - one period;
    - a period with no arbeidsgiver or type.
- [ ] Mutations update an in-memory store per `sakId`, then return the next canned state (or recompute with a deliberately trivial stub clearly marked "mock only, not the algorithm"). Validation errors are returned with `felt` + `kode` for at least `OVERSTIGER_KALENDERTID` (e.g. timer > 1650 for a one-year period) and `PAKREVD`.
- [ ] `beregnPraksisperiode` returns a string value and can return `OVERSTIGER_KALENDERTID`.
- [ ] `teardown-praksis.md` lists every file to delete in Task #16 and the codegen exclusion to remove. `teardown-applikasjoner.md` gets a note that `MockProvider`, `browser.ts`, `handlers.ts` and `public/mockServiceWorker.js` are also used by the praksis mock.
- [ ] Handler unit tests in the same style as `src/mocks/applikasjoner/handlers/queries.test.ts`.

---

### Task #8: Page query, card and table (read)

**Priority**: High · **Size**: M · **Dependencies**: #1, #2, #3, #7 · **Schema**: 🟡
**Skills**: `fs-admin-tables-vs-lists`, `fs-admin-placeholder`, `fs-admin-i18n-structure`, `graphql-consumer`, `fs-admin-grid-and-flex`
**Addresses**: *Se registrerte praksisperioder*, *Registrert praksis ligger fast på saken* (display), *Praksisperioder hører til saken de er registrert på* (query by sakId), *Overlappende praksisperioder varsles* (row icon), *Summen avkortes …* (row values), design.md:13-23, :54-58, :66-69.

**Files**: `Praksiskalkulator.tsx` (page query `PraksiskalkulatorSak` with `useSuspenseQuery`, spreads the fragment), `components/PraksisperioderCard/*`, `components/PraksisperioderTable/*`, `utils/formatOmfang.ts` (+ test); `soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] The card shows the heading "Registrerte praksisperioder" and the count. The count uses an ICU plural: "{antall, plural, one {# registrert periode} other {# registrerte perioder}}" (ASSUMPTION A5).
- [ ] Empty sak (`praksisberegning` null or no periods): the count reads "0 registrerte perioder", and instead of the table it shows the paragraph "Saken har ingen registrerte praksisperioder." (ASSUMPTION A5).
- [ ] Table columns and content as in Decision 4 and design.md:16-23:
    - Periode is `dd.MM.yyyy–dd.MM.yyyy` via `dateUtil`.
    - Omfang is "{prosent}%" or "{timer} timer (av {timerPerArsverk})" via `formatOmfang`. Input numbers are shown nb-NO with up to 2 decimals; these are inputs, not calculated values.
    - Beregnet praksis is "{x} år" via `formatTruncatedDecimal`, bold. `null` shows `-` in normal weight.
- [ ] The warning icon and SR text appear on exactly the rows whose `radnummer` is in some `overlapp[].radnumre`. Tests use the mock's 50 % + 60 % and A/B/C fixtures.
- [ ] The Inkluder and Handlinger columns are rendered as **slots** (props/render functions) that #13 and #14 fill. In this task, Inkluder shows a disabled checkbox with the current value.
- [ ] Loading uses the standard `Skeleton` in the Suspense fallback (design.md:55). A query error shows `LayoutMessage severity="critical"`.
- [ ] No code in this task adds up `beregnetPraksis` values (a review check: grep for `reduce`/`+` on these fields).

---

### Task #9: Overlap warnings and sum cards

**Priority**: High · **Size**: S · **Dependencies**: #1, #8 · **Schema**: 🟡
**Skills**: `fs-admin-i18n-structure`, `fs-admin-grid-and-flex`, data-field-sections (for the cards, if `FSOutputField` is used)
**Addresses**: *Overlappende praksisperioder varsles*, *Både oppgitt og justert sum vises ved overlapp*, *Justert sum kan ikke overstige kalendertiden …* (">100 %" message), *Overlapp beregnes bare mellom inkluderte*, *Overlappssummene beregnes kun på inkluderte*, *Praksisperioder som ikke er inkludert, telles ikke med*, *Samlet praksis summeres …*, *Sluttdatoen regnes med*, *En delvis måned regnes med 30 dager*, *Summen avkortes til to desimaler*, *Praksis beregnes med full presisjon*, Q-D4, Q-D8.

**Files**: `components/OverlappVarsler/*`, `components/PraksisSummer/*`, `utils/tallSomOrd.ts` (+ test); `soknadsbehandling.json`; wiring in `Praksiskalkulator.tsx`

**Acceptance Criteria**:

- [ ] One `Alert variant="warning"` (from `@sikt/sds-message`, not the deprecated local `Alert`) per `overlapp` entry, in backend order:
    - `over100Prosent: false` → «Du har {antall} perioder som overlapper ({fra}–{til}).»
    - `true` → «Du har {antall} perioder som overlapper med et samlet omfang >100% ({fra}–{til}). Omfang over 100% blir ikke tatt med i beregningen.»
- [ ] `{antall}` is in words via `tallSomOrd` ("to", "tre", …, "tolv"; digits above 12). Unit tests cover 2, 3, 12 and 13.
- [ ] Q-D8 examples 1 and 2 (mock fixtures) render two and one warnings with the exact texts. No overlap → no warning.
- [ ] Two cards, "Sum av oppgitte perioder" and "Justert for overlapp", show `formatTruncatedDecimal(sumOppgitt|sumJustert)` + " år". An empty sak shows `0,00 år` if the backend returns `"0"`, otherwise `-`.
- [ ] A test with the P1 fixture shows **0,99 år** (it proves fs-admin doesn't round). A test with oppgitt `"1.1"` / justert `"1"` shows 1,10 / 1,00.
- [ ] No sum is computed in fs-admin. The sum cards take only the two backend strings as props.

---

### Task #10: Praksisperiode form fields (inside the panel)

**Priority**: High · **Size**: M · **Dependencies**: #5, #6 · **Schema**: 🟡 (`Arbeidserfaringstyper` query)
**Skills**: `fs-admin-inputs`, `fs-admin-buttons`, `fs-admin-grid-and-flex`, `fs-admin-i18n-structure`, `fs-admin-placeholder`, `graphql-consumer`
**Addresses**: *Registrere en praksisperiode* (form), *Velge praksistype for en praksisperiode*, *Oppgi arbeidsgiver for en praksisperiode*, *Omfanget oppgis på én av måtene*, *Antall timer per årsverk har en standardverdi*, *Saksbehandleren kan justere antall timer per årsverk*, *Antall timer per årsverk oppgis per praksisperiode*, *Timebasert omfang overskrives ikke når datoene endres*, the client-validation scenarios from #6 (rendering), design.md:27-34, :75-83, Q-D1.

**Files**: `components/PraksisperiodeForm/PraksisperiodeForm.tsx`, `.a11y.test.tsx`, `.test.tsx`; `soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] Fields, in design order:
    - "Beregningsgrunnlag": `ToggleSegment` "Stillingsprosent" / "Timer i perioden", default Stillingsprosent.
    - "Startdato" and "Sluttdato": `InputDatepicker`, side by side via `Grid`, placeholder «DD.MM.ÅÅÅÅ».
    - Omfang:
        - **Stillingsprosent:** «Omfang (Stillingsprosent)» `FSNumberInput decimals={2} min={0} max={100}`, with a "%" suffix.
        - **Timer (ASSUMPTION A3):** «Antall timer i perioden» and «Antall timer per årsverk», side by side in the omfang row. Årsverk is prefilled with 1650.
    - The «Beregnet varighet» slot (filled by #12).
    - «Arbeidsgiver (valgfri)»: `FSTextInput`, **no placeholder** (ASSUMPTION A8, `fs-admin-inputs`), maxLength 200.
    - «Praksistype (valgfri)»: a select of `arbeidserfaringstyper` shown as «KODE – navn». It has an explicit «Ikke valgt» option because null is allowed (`fs-admin-inputs` rule 4).
    - Buttons «Avbryt» and «Bekreft».
- [ ] Changing grunnlag shows only that grunnlag's fields. The hidden values are kept in form state, but only the selected grunnlag's fields are sent (#6). Switching back restores what was typed. Changing dates never rewrites timer (*Timebasert omfang overskrives ikke*).
- [ ] The `Arbeidserfaringstyper` query (operation `Arbeidserfaringstyper`, selects `id kode navn`) lives in this component.
- [ ] Field errors render through each input's own error prop, from `usePraksisperiodeForm` (#6). `generalErrors` render as an `Alert variant="error"` at the top of the form.
- [ ] Labels are noun phrases (`fs-admin-inputs`). No custom CSS on the fields.
- [ ] The a11y test has no violations in the empty, filled-with-errors and timer states.
- [ ] Presentational: `onSubmit`/`onCancel` and `submitting` come in as props (wired in #11).

---

### Task #11: Opprett and Rediger: mutations and panel wiring

**Priority**: High · **Size**: M · **Dependencies**: #8, #10 · **Schema**: 🟡
**Skills**: `graphql-consumer`, `fs-admin-buttons`, `fs-admin-inputs`, `fs-admin-i18n-structure`
**Addresses**: *Registrere en praksisperiode*, *En ny praksisperiode er inkludert som standard*, *Oppdatere en praksisperiode*, *Samlet praksis justeres når en praksisperiode legges til*, *Timer som gir mer praksis enn kalendertiden …* and *Endring som gir mer praksis …* (server errors on the field after submit), design.md:39-45.

**Files**: `PraksisperioderCard` ("Opprett" button), `PraksisperioderTable` (Rediger slot), `Praksiskalkulator.tsx` (panel state: `null | { mode: 'opprett' } | { mode: 'endre', radnummer }`), the mutation documents (`OpprettPraksisperiode`, `EndrePraksisperiode`) next to the component that calls them; `soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] "Opprett" (bare verb, `fs-admin-buttons`) in the card header opens the panel with the heading «Legg til praksisperiode» and an empty form. "Rediger" opens it with «Rediger praksisperiode» and `fromPeriode(row)`. Both are gated on MODIFISERE.
- [ ] Bekreft runs `validateAll`. If it passes, the mutation is sent with `toOpprettInput` / `toEndreInput`.
    - While the mutation is pending, the button shows the progress label («Lagrer…») and is `disabled`. Avbryt stays enabled.
- [ ] On success (no `errors`): the panel closes, focus returns (#5), and a snackbar confirms. The table, overlap warnings and sums come from the **payload** (`sak { id praksisberegning { ...PraksisberegningFields } }`), with no refetch, no `optimisticResponse` and no `cache.modify` (tests assert the new row and new sums come from the mocked payload).
- [ ] On `errors`: `applyServerErrors`. A mocked `OVERSTIGER_KALENDERTID` shows design.md:84 under the timer field. The panel stays open.
- [ ] Rule 4: the Endre mutation sends every input field of the period, including unchanged ones. A test asserts the variables.
- [ ] The «Beregnet varighet» slot in the form is left empty here and filled by #12.

---

### Task #12: «Beregnet varighet» preview

**Priority**: Medium · **Size**: M · **Dependencies**: #11 · **Schema**: 🟡 (B6 shape)
**Skills**: `graphql-consumer`, `fs-admin-placeholder`, `fs-admin-i18n-structure`, data-field-sections (`FSOutputField`)
**Addresses**: *Praksis beregnes proporsjonalt med stillingsprosenten* and *Timebasert praksis beregnes mot oppgitt årsverk* (preview display), *Saksbehandleren kan justere antall timer per årsverk*, *Timer som gir mer praksis enn kalendertiden …* (before submit), design.md:31, :74, :103, Q-T4.

**Files**: `components/BeregnetVarighet/*` (with the `BeregnPraksisperiode` document), `hooks/useBeregnPraksisPreview.ts` (+ test); slot wiring in `PraksisperiodeForm`; `soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] `useBeregnPraksisPreview` as Decision 8: it uses `useLazyQuery`, is debounced (400 ms), fires only when the date and omfang fields pass client validation, and ignores stale responses.
- [ ] `BeregnetVarighet` shows «= {x} år» via `formatTruncatedDecimal`, or «= - år» while empty or invalid, inside an `aria-live="polite"` output.
- [ ] Preview `errors` go through `mapPraksisperiodeErrors` and show only on touched fields. A mocked `OVERSTIGER_KALENDERTID` shows under the timer field before Bekreft.
- [ ] Tests use fake timers: there is no request while invalid, one request after the debounce, a stale response is dropped, and `"0.29"` shows 0,29.
- [ ] No preview value is ever passed to `PraksisSummer` (rule 3, Q-T4).

---

### Task #13: Inkluder checkbox

**Priority**: High · **Size**: S · **Dependencies**: #8 · **Schema**: 🟡
**Skills**: `fs-admin-inputs`, `graphql-consumer`, `fs-admin-i18n-structure`
**Addresses**: *Inkludere en praksisperiode i praksisberegningen*, *Praksisperioder som ikke er inkludert, telles ikke med*, *Overlapp beregnes bare mellom inkluderte*, design.md:44, :94, Q-T6.

**Files**: `components/InkluderCheckbox/*` (with the `EndreInkluderingAvPraksisperiode` document); `PraksisperioderTable` slot wiring; `soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] `FSCheckbox` with `aria-label` «Inkluder perioden {fra}–{til}». The checked state comes from the cache (`inkludert`).
- [ ] Toggling sends **only** `{ sakId, radnummer, inkludert }` (no other fields; a test asserts the variables). The checkbox is disabled while pending and there is no optimistic toggle.
- [ ] The sums and overlap warnings update from the payload. The mock fixture for "50 % incl. + 60 % not incl." shows 0,50 / 0,50 and no warning.
- [ ] On error, the checkbox keeps the cached value and a snackbar shows the localized error (`useGetMutationErrors`).
- [ ] Without MODIFISERE: disabled, and no mutation is possible. `WithRole` uses `hideIndicator` inside the table cell.

---

### Task #14: Slett with confirmation

**Priority**: Medium · **Size**: S · **Dependencies**: #8 · **Schema**: 🟡
**Skills**: `fs-admin-buttons`, `fs-admin-modal` (dialog conventions behind `ButtonWithConfirmation`), `graphql-consumer`, `fs-admin-i18n-structure`
**Addresses**: *Slette en praksisperiode*, *Samlet praksis justeres når en praksisperiode slettes*, design.md:43, :110 (ASSUMPTION A4).

**Files**: `components/SlettPraksisperiodeButton/*` (with the `SlettPraksisperiode` document); `PraksisperioderTable` slot wiring; `soknadsbehandling.json`

**Acceptance Criteria**:

- [ ] `ButtonWithConfirmation` (trash icon, label «Slett») with the message «Vil du slette praksisperioden {fra}–{til}?». Bekreft sends `{ sakId, radnummer }`.
- [ ] On success: the row disappears, and the sums and warnings update from the payload. If the panel was editing this row, it closes and focus goes to the card heading.
- [ ] On error: a snackbar with the localized error, and the row stays.
- [ ] Only with MODIFISERE. Avbryt in the confirmation sends nothing.

---

### Task #15: End-to-end walkthrough on the mock + a11y pass of the whole page

**Priority**: Medium · **Size**: S · **Dependencies**: #9, #11, #12, #13, #14 · **Schema**: 🟡
**Skills**: `run` (launch and drive the app), all of the above for spot fixes

**Acceptance Criteria**:

- [ ] `Praksiskalkulator.test.tsx` (MockedProvider) covers the spec flow: an empty sak, then Opprett 100 % 2020 (1,00 år), then the 3,50 år set, then Inkluder off, then Rediger, then Slett, with the sums following the payloads.
- [ ] `Praksiskalkulator.a11y.test.tsx` covers the full page with the panel open and closed, with overlap warnings, and with only SE (read-only).
- [ ] Manual run in `npm run dev` with the mock: keyboard-only flow (Tab, Escape, focus return), narrow viewport (≤ 768 px stacks the panel), and screen-reader labels on the icons and checkboxes. Findings are fixed or listed in the completion doc.

---

### Task #16: Switch to the published schema 🔴

**Priority**: High · **Size**: M · **Dependencies**: all of #1–#15 **and** backend B2–B7 merged and deployed to `production/experimental` · **Schema**: 🔴 **blocked**
**Skills**: `graphql-consumer`, `fs-admin-under-utvikling` (removal), `fs-admin-mock-api-with-data` (teardown)

**Acceptance Criteria**:

- [ ] Run `npm run compile` against the published SDL. Reconcile every row of *Target backend contract* with the real schema, and record the differences in the completion doc.
- [ ] Remove the `codegen.ts` exclusion. Switch every praksis document to `graphql()` from `@/__generated__` and use generated types. **Delete** `praksisContract.ts`.
- [ ] Confirm the decimal fields arrive as `string` in the generated types, not `number`. If they come as `BigDecimal → number`, **stop** and escalate (Q-T1 is broken).
- [ ] Confirm the payloads return `sak { id praksisberegning }`. If not, switch to `refetchQueryNames(...)` (Decision 5) and document it.
- [ ] Add the feature folder to `GRAPHQL_REQUIRE_ID_PATHS`, and lint passes.
- [ ] Delete `src/mocks/praksis/`, unregister it in `src/mocks/handlers.ts`, and follow `teardown-praksis.md`. If the applikasjoner mock is also gone by then, follow its teardown for the shared infrastructure.
- [ ] Remove the GuidePanel and `soknadsbehandling.common.underUtvikling` if unused.
- [ ] Flag: `environmentsOverride` gets `inTest: true` (both the page and the entry point). Replace the `FeatureName` cast with the generated name.
- [ ] Run all praksis tests against generated types and rewrite the MockedProvider mocks to the real shapes. Smoke-test in review/test against the real backend with the spec examples (3,50 år; 1,10 / 1,00; P1 shows **1,00** once B2 is fixed; `0.29 → 0,29`).
- [ ] `GRAPHQL_SCHEMA_INTROSPECTION_URL` is not in the diff.

---

### Task #17: Changeset

**Priority**: Low · **Size**: S · **Dependencies**: #16 (or the last user-facing task merged) · **Schema**: n/a
**Skills**: `fs-admin-changesets`

**Acceptance Criteria**:

- [ ] Ask the developer with `AskUserQuestion` whether the changeset should mention the flag `soknadsbehandling-praksiskalkulator`, as the skill requires. Say nothing about whether the flag is on in production.
- [ ] `.changeset/<name>.md`, written with Write, prefixed `Søknadsbehandling:`, describing the state after the change from the user's view. For example: "Søknadsbehandling: Søknadsbehandler kan nå registrere praksisperioder på en sak og se samlet praksis, også justert for overlapp."
- [ ] If `formatTruncatedDecimal` is considered user-visible across domains, skip it. It is an internal utility, so no `felles` changeset.

---

## Dependencies

### Backend (fs-plattform/opptak), prerequisites, not tasks in this plan

| # | What fs-admin needs | Blocks |
|---|---|---|
| B2 | Exact results: whole or round numbers never come out as `0.999…` (stillingsprosent, timer, overlap adjustment) | Correct display in #8/#9 against the real backend (#16 smoke test) |
| B3 | Calculated values as decimal **strings** in plain notation (own type/scalar, not the shared `BigDecimal → number`) | #1's input contract, #16 |
| B4 | Overlap per stretch, split at ">100 %", incl. ≤ 100 % and one-day, excl. 0 %, with `radnumre` + an "over 100 %" flag | #8 icon, #9 warnings, #16 |
| B5 | Validation errors with `felt` + `kode`, no "Praksisperiode N:" prefix | #6 mapping, #11, #16 |
| B6 | `beregnPraksis` as a one-period preview: string value, field-coded errors, `SE_` access check | #12 preview, #16 |
| B7 | Its own Inkluder mutation (flag only), returning the sak with sums | #13, #16 |
| — | Merge, rebase onto `origin/main` (re-check V-numbers), deploy to `production/experimental` | **#16** (everything 🔴) |

### Operator and outside the repo

- **Unleash:** create the flag `soknadsbehandling-praksiskalkulator` (name ASSUMPTION A9), then `npm run generate:unleash`. Without it, #3 and #4 use a cast that #16 removes.
- **Design** (design.md:107-112): confirm the ASSUMPTIONS below.
- **fs-krav** (B9): align the krav text for Q-D1, Q-D2, Q-D3, Q-D5 and Q-D6. This doesn't change the frontend, but the traceability table below reflects the decided behaviour, not the current krav wording.

## Assumptions to confirm with design

Each one is a default the plan builds on. Each is isolated so it is cheap to change.

| # | Open question | Default in this plan | Where to change |
|---|---|---|---|
| A1 | design.md:107: entry point placement, and how søker and sak are shown | `PraksiskalkulatorButton` next to «Endre søknad» in `SaksbehandlerCard`. A topbar with Søker, Saksnummer, Søknad and Opptak | `PraksiskalkulatorButton` import (1 line), `PraksisSakTopbar` |
| A2 | Sketch ⤡ icon (panel ↔ dialog) | Left out. One side panel, which stacks below on narrow screens | `PraksisperiodeSidePanel` |
| A3 | design.md:108: timer variant of the form | «Antall timer i perioden» + «Antall timer per årsverk» (prefilled 1 650) side by side in the omfang row. «Beregnet varighet» shows «= - år» while empty | `PraksisperiodeForm`, `BeregnetVarighet`, i18n |
| A4 | design.md:110: confirm before Slett | **Yes**, `ButtonWithConfirmation` with «Vil du slette praksisperioden {fra}–{til}?» | `SlettPraksisperiodeButton` |
| A5 | design.md:109: texts for 1 and 0 periods | «1 registrert periode» / «{n} registrerte perioder» / «0 registrerte perioder», plus «Saken har ingen registrerte praksisperioder.» in place of the table | i18n (ICU plural) |
| A6 | `{antall}` in words beyond the examples | Words for 2–12, digits above 12 | `tallSomOrd` |
| A7 | Rediger on another row while the panel has unsaved changes | Switch without asking; unsaved changes are lost | `Praksiskalkulator` panel state |
| A8 | design.md:111: «Ullevål sykehus» in the arbeidsgiver field | An example value, **not a placeholder**. The field has no placeholder (`fs-admin-inputs` rule 3) | `PraksisperiodeForm` |
| A9 | Feature flag name | `soknadsbehandling-praksiskalkulator` | `FeatureFlag`/`useTypedFlag` in #3, #4 |
| A10 | Text of the «Under utvikling» panel during the mock phase | «Praksisperiodene er testdata til backend er klar.» | i18n (removed in #16) |
| A11 | Panel heading vs. the button that opens it | The button is «Opprett» (`fs-admin-buttons` rule 2b), and the panel heading is design's «Legg til praksisperiode» / «Rediger praksisperiode» | i18n |

design.md:112 (fix the copy error in Figma sketch 05) is design's own follow-up and doesn't affect this plan, because the krav text applies.

## Risk Assessment

### Technical Risks

- **The real contract differs from the assumed one.** The applikasjoner mock diverged a lot; see `teardown-applikasjoner.md`.
    - **Mitigation:** every name lives in `praksisContract.ts`, the `gql` documents and the mock, nowhere else. Components get their data through props typed from the contract. #16 has a reconciliation step with a stop rule for the decimal-type mismatch.
- **Decimals arrive as `number` after all** (shared `BigDecimal` mapping, `codegen.ts:43`).
    - **Mitigation:** #16 stops and escalates. `formatTruncatedDecimal` only accepts strings, so a `number` won't type-check.
- **Exponent notation from Java `BigDecimal.toString()`** (`1E+1`).
    - **Mitigation:** the contract requires plain notation (B3), and the utility returns `null` (`-`) instead of a wrong number. It is tested.
- **Mock data shown in test.** `MockProvider` mounts MSW with `inTest: true`.
    - **Mitigation:** the praksis flag is not on in test until #16, and the GuidePanel labels the data as test data.
- **Shared mock infrastructure is torn down underneath us.** The applikasjoner mock is "dead" and scheduled for teardown.
    - **Mitigation:** #7 updates `teardown-applikasjoner.md` with the shared ownership.
- **Apollo cache warnings for an id-less `Praksisberegning`.**
    - **Mitigation:** the one shared fragment means identical selections everywhere. `refetchQueryNames` is the fallback.
- **Preview spam or early errors.**
    - **Mitigation:** debounce, only valid inputs, errors only on touched fields, stale responses dropped.
- **Duplicated simple rules drift from `PraksisperiodeRegler`.**
    - **Mitigation:** the client rules are only for faster feedback, and the backend errors (`felt` + `kode`) still land on the field. A sync comment, and the rule list in #6 is exactly Q-T3's.
- **Breadcrumb gap for routes outside `(sak)`.**
    - **Mitigation:** #3 adds the sak crumb explicitly in the route's layout.

### Testing Requirements

- Unit:
    - `formatTruncatedDecimal` (P1/P2 table)
    - `validatePraksisperiode`
    - `mapPraksisperiodeErrors`
    - `praksisperiodeFormState`
    - `usePraksisperiodeForm`
    - `useBeregnPraksisPreview` (fake timers)
    - `formatOmfang`
    - `tallSomOrd`
    - the mock handlers
- `*.a11y.test.tsx` for every component: page, topbar, card, table, Inkluder, Slett, overlap warnings, sums, side panel, form, Beregnet varighet, entry button.
- Integration (`Praksiskalkulator.test.tsx`): the spec flow on mocked payloads (#15).
- Manual: keyboard and focus, narrow viewport, screen reader (#15); real-backend smoke test (#16).

## Success Criteria

- [ ] All acceptance criteria met; lint, typecheck and tests pass.
- [ ] No arithmetic on calculated values anywhere in fs-admin (rules 1–4). Every calculated value goes through `formatTruncatedDecimal`.
- [ ] The feature is hidden behind the flag until #16, and runs against the published schema after #16 with no mock left.
- [ ] Every assumption in A1–A11 is confirmed or changed by design.
- [ ] Changeset written (#17).

## Requirements Traceability

`registrere_praksis.feature` (`@OPT-BEH-BEH-003`). **B-dep** = the scenario's correct behaviour in fs-admin depends on the named backend change. Every 🟡 task also depends on the merge and deploy (#16).

| Scenario | Task(s) | B-dep | Note |
|---|---|---|---|
| Registrere en praksisperiode | #10, #11 | B5 | |
| Praksisperioder hører til saken de er registrert på | #8 | — | Query by `sakId`. Enforced by the backend key |
| Praksis fra andre saker vises ikke | — (backend) | — | Backend key and RLS. No frontend logic |
| Registrert praksis ligger fast på saken | #8, #11 | — | Sums recomputed on read (Q-D7) |
| Se registrerte praksisperioder | #8 | B3 | |
| Velge praksistype for en praksisperiode | #10 | — | Opptak copy `arbeidserfaringstyper` (Q-D1) |
| Inkludere en praksisperiode i praksisberegningen | #13 | B7 | |
| Praksisperioder som ikke er inkludert, telles ikke med | #9, #13 | B3, B7 | |
| Overlapp beregnes bare mellom inkluderte praksisperioder | #8, #9, #13 | B4, B7 | |
| En ny praksisperiode er inkludert som standard | #6, #11 | — | Client sends `inkludert: true` |
| Startdato og sluttdato er obligatorisk | #6, #10 | — | |
| Oppgi arbeidsgiver for en praksisperiode | #10 | B5 | ≤ 200 characters is a server error |
| Praksisperiode uten sluttdato kan ikke lagres | #6, #10 | — | |
| Sluttdato før startdato kan ikke lagres | #6, #10 | — | |
| Ugyldig dato kan ikke lagres | #6, #10 | — | Client-only (the scalar rejects before rules) |
| Sluttdato fram i tid regnes som oppgitt | #6 | — | |
| ~~Knytte praksisperioden til dokumentasjon~~ | — | — | `@wont` |
| Praksis beregnes proporsjonalt med stillingsprosenten | #8, #12 | B2, B3, B6 | Preview and row value |
| Timebasert praksis beregnes mot oppgitt årsverk | #8, #12 | B2, B3, B6 | |
| Antall timer per årsverk har en standardverdi | #6, #10 | — | Prefilled 1650 |
| Saksbehandleren kan justere antall timer per årsverk | #10, #12 | B6 | |
| Antall timer per årsverk oppgis per praksisperiode | #8, #10 | — | Shown in Omfang |
| Omfanget oppgis på én av måtene per praksisperiode | #6, #10 | — | |
| Praksisperiode med omfang i timer kan ikke lagres uten antall timer | #6, #10 | — | |
| Stillingsprosent utenfor 0–100 % kan ikke lagres | #6, #10 | — | |
| Timer som gir mer praksis enn kalendertiden …, kan ikke lagres | #6, #11, #12 | **B5, B6** | Server-only rule, mapped to the field |
| Endring som gir mer praksis enn kalendertiden …, kan ikke lagres | #6, #11 | **B5, B6** | |
| Antall timer på 0 eller mindre kan ikke lagres | #6, #10 | — | |
| Timebasert omfang overskrives ikke når datoene endres | #6, #10 | — | |
| Oppdatere en praksisperiode | #11 | B5 | Rule 4: all input fields |
| Slette en praksisperiode | #14 | — | Confirmation A4 |
| Samlet praksis summeres på tvers av perioder | #9 | **B2, B3** | |
| Samlet praksis justeres når en praksisperiode legges til | #9, #11 | B3 | From payload |
| Samlet praksis justeres når en praksisperiode slettes | #9, #14 | B3 | From payload |
| Sluttdatoen regnes med i perioden | #9 | B3 | Display of the backend value |
| Summen avkortes til to desimaler i visningen | #1, #8, #9, #12 | **B3** | |
| Praksis beregnes med full presisjon | #1, #9 | **B2, B3** | P1 |
| En delvis måned regnes med 30 dager | #8, #9 | B3 | Month rule (Q-D2) |
| Overlappende praksisperioder varsles | #8, #9 | **B4** | ≤ 100 % included |
| Både oppgitt og justert sum vises ved overlapp | #9 | **B2, B3** | |
| Justert sum kan ikke overstige kalendertiden i perioden | #9 | **B4** (+ B2) | ±2 days accepted (Q-D6) |
| Overlappssummene beregnes kun på inkluderte praksisperioder | #9, #13 | B4, B7 | |
| Søknadsbehandler kan registrere praksis | #3, #11, #13, #14 | — | MODIFISERE gate (Q-D5) |
| Bruker uten søknadsbehandler-rollen ser ikke praksisregistreringen | #4, #3 | — | Per Q-D5: means "without søknadsbehandling access" (SE). Krav text to be aligned (B9) |
| Bruker uten søknadsbehandler-rollen ser ikke registrert praksis | #3 | — | As above. Backend RLS is authoritative |
| Saksbehandlere i andre opptak ser ikke praksisen | — (backend) | — | RLS per organisation. No frontend logic |
