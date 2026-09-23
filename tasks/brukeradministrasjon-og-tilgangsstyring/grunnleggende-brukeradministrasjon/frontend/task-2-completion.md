# Task #2 Completion Report: Feature flag, ruter og navigasjonsinnganger

## Status: ✅ COMPLETED

**Date Completed**: 2026-07-08
**Task**: Feature flag, ruter og navigasjonsinnganger
**Priority**: High
**Size**: M

## Summary

Implemented the entry points for the personbruker feature: new feature flag
`tilgangsstyring-brukeradministrasjon` (typed via the generated Unleash types),
flag-gated routes `/tilgangsstyring/personbrukere` and
`/tilgangsstyring/personbrukere/[id]` with placeholder pages, a flag-gated
«Personbrukere» sub-item in the main menu under Tilgangsstyring, and an active
flag-gated «Personbrukere» card on the Tilgangsstyring index page. Typed routes
were regenerated, i18n keys added, and unit + a11y tests written for all
changed components. All paths below are relative to the fs-admin repo.

## Files Created

### 1. `src/app/tilgangsstyring/personbrukere/layout.tsx` (17 lines)

Route layout mirroring `applikasjoner/layout.tsx`: `PageHeaderWrapper` with
`breadcrumbTitle={t('personbrukereTitle')}` from
`domains.tilgangsstyring.app`, giving the breadcrumb trail
«Hjem > Tilgangsstyring > Personbrukere».

### 2. `src/app/tilgangsstyring/personbrukere/page.tsx` (33 lines)

Placeholder overview page (replaced by `PersonbrukereOverview` in Task #3).
Wrapped in `FeatureFlag flag="tilgangsstyring-brukeradministrasjon"` with
`environmentsOverride` dev/review/test on (same setup as `tilgangsstyring-meny`
usage; prod follows the server-side flag, which is off). Renders
`BasicPageLayout` + `BasicPageSection` + translated placeholder text.

### 3. `src/app/tilgangsstyring/personbrukere/page.a11y.test.tsx` (17 lines)

jest-axe test for the placeholder page.

### 4. `src/app/tilgangsstyring/personbrukere/[id]/layout.tsx` (19 lines)

Route layout mirroring `applikasjoner/[id]/layout.tsx` with
`breadcrumbTitle={t('personbrukerTitle')}`.

### 5. `src/app/tilgangsstyring/personbrukere/[id]/page.tsx` (40 lines)

Placeholder detail page (replaced by `PersonbrukerDetails` in Task #4). Client
page unwrapping `params` with React `use()` (same pattern as
`src/app/person/personsok/[id]/page.tsx`), gated behind the same flag, renders
a translated placeholder that includes the `id`.

### 6. `src/app/tilgangsstyring/personbrukere/[id]/page.a11y.test.tsx` (26 lines)

jest-axe test for the detail placeholder (renders through Suspense with a
resolved params promise).

### 7. `src/features/Header/Menu/Menu.test.tsx` (143 lines)

Unit tests for the menu: personbrukere sub-item visible in
development/test/review via `environmentsOverride`; hidden in production when
only `tilgangsstyring-meny` is enabled; visible when both flags are enabled;
whole section hidden when `tilgangsstyring-meny` is off; navigation via
`router.push('/tilgangsstyring/personbrukere')`; `aria-current="page"`
selection for sub-item and top-level routes.

### 8. `src/features/Header/Menu/Menu.a11y.test.tsx` (41 lines)

jest-axe tests for the menu, closed and open (with the personbrukere sub-item
visible).

### 9. `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.test.tsx` (22 lines)

Unit tests: active personbrukere card renders a link (`ButtonLink`) with
`href="/tilgangsstyring/personbrukere"`; the pre-existing Maskinbrukere button
remains disabled.

### 10. `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.a11y.test.tsx` (18 lines)

jest-axe test with both cards rendered.

## Files Modified

### 1. `src/common/types/generated/unleash.ts`

Added `'tilgangsstyring-brukeradministrasjon': [{ name: 'disabled'; enabled: false }]`
to `FeaturesVariantMap`, in the exact format the generator emits. **Manually
edited — see Deviations**: the flag must also be created in the Unleash server
(GitLab feature flags, project 3136 on gitlab.sikt.no — same server as
`tilgangsstyring-meny`) before production launch, after which
`npm run generate:unleash` reproduces this entry. Until then the flag is
disabled/absent in prod (= feature off in prod, as required) while
dev/review/test are forced on via `environmentsOverride` in code.

### 2. `src/common/types/generated/routes.d.ts`

Regenerated via `npm run generate:routes`. Now contains typed
`'/tilgangsstyring/personbrukere'` and
`{ pathname: '/tilgangsstyring/personbrukere/[id]', params: { id } }` hrefs.

### 3. `src/features/Header/Menu/Menu.tsx`

- New sub-item «Personbrukere» under Tilgangsstyring with
  `featureFlag: { flag: 'tilgangsstyring-brukeradministrasjon', environmentsOverride: { inDevelopment, inReview, inTest: true } }`.
  The parent item is already gated behind `tilgangsstyring-meny`, so the
  sub-item requires both flags.
- `buildNavigationItems` now filters `subItems` through `shouldShowMenuItem`
  (previously sub-items were never gated; required to honor sub-item flags).

### 4. `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`

Added an active «Personbrukere» card (Surface + Heading + Paragraph +
`ButtonLink` «Gå til personbrukere» with `ArrowRightIcon aria-hidden`,
matching the `UtdanningIndex` card idiom), wrapped in
`FeatureFlag flag="tilgangsstyring-brukeradministrasjon"` with the same
`environmentsOverride`. The disabled Maskinbrukere button/card is untouched.

### 5. `src/common/messages/nb/domains.json`

`tilgangsstyring.app`: added `personbrukereTitle`, `personbrukerTitle`,
`personbrukerePlaceholderText`, `personbrukerPlaceholderText` (parameterized
with `{id}`).

### 6. `src/common/messages/nb/features.json`

`Menu`: added `personbrukere: "Personbrukere"`.

### 7. `src/common/messages/nb/support.json`

`TilgangsstyringIndex`: added `personbrukereHeading`,
`personbrukereDescription`, `personbrukereLabel` («Gå til personbrukere»).

## Key Features Implemented

### ✅ Feature flag `tilgangsstyring-brukeradministrasjon`

Typed flag available to `FeatureFlag`/`useTypedFlag`; dev/review/test forced on
via `environmentsOverride`, prod off until the flag is created/enabled in the
Unleash server.

### ✅ Flag-gated routes with placeholders

`/tilgangsstyring/personbrukere` and `/tilgangsstyring/personbrukere/[id]`
render translated placeholders behind the flag; layouts produce the breadcrumb
«Hjem > Tilgangsstyring > Personbrukere». Typed `*Href`s generated.

### ✅ Menu entry gated behind both flags

«Personbrukere» under Tilgangsstyring; sub-item flag gating added to the menu's
item filtering (new capability, previously only top-level items were gated).

### ✅ Active Personbrukere card on TilgangsstyringIndex

Navigational `ButtonLink` card behind the flag; Maskinbrukere card untouched.

## Project skills consulted

- **`fs-admin-buttons`**: consulted before touching the index card. Decisive for
  using `ButtonLink` (navigation = link semantics, not `Button` +
  `router.push`), verb-phrase Norwegian label via `t(...)`
  («Gå til personbrukere»), and `aria-hidden` on the decorative icon.
- **i18n conventions (`src/common/messages/CLAUDE.md`)**: key placement
  (`domains.tilgangsstyring.app` for route titles/placeholders,
  `features.Menu` for menu labels, `support.TilgangsstyringIndex` for the
  card), camelCase keys, parameterized message for the id placeholder.
- GraphQL skills not applicable (no GraphQL operations in this task);
  `fs-admin-grid-and-flex` respected implicitly (no new CSS, existing
  `Flex`/`Grid` helpers reused).

## Test Results

All test files are TypeScript, run through the project's Jest setup:

- `npx jest --config jest.config.ts src/features/Header/Menu/Menu.test.tsx src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.test.tsx` — pass.
- `npx jest --config jest.a11y.config.ts` (targeted new a11y tests) — pass.
- `npm test` (full unit suite) — **215 suites / 1764 tests pass** (global
  coverage thresholds over the whole repo fail pre-existing; not gated on this
  branch — see below).
- `npm run test:sincemain` (the project's MR coverage gate) — **13 suites / 86
  tests pass**, changed-file coverage `Menu.tsx` 94.04% statements / 83.72%
  branches / 94.73% functions / 96% lines — above the 90/60/60/60 thresholds.
- `npm run test:a11y` (full a11y suite) — **262 suites / 843 tests pass**
  (first run had a flaky jest-worker child-process crash in the untouched
  `NoOrgError` suite; passes in isolation and the full suite is green on
  re-run with `--maxWorkers=4`).
- `npm run test:typecheck` — clean.
- `npm run lint` — 0 errors (260 pre-existing warnings repo-wide; **0 warnings
  in touched files**, verified with a targeted `npx eslint --no-cache` run).
- Prettier check on all touched files — clean.

## Technical Decisions

### 1. Route gating via `FeatureFlag` wrapper in the page components

**Why**: The plan says «samme mekanisme som applikasjoner-rutene», but the
applikasjoner routes have **no** route-level flag gate in the codebase (no
`FeatureFlag`/`useTypedFlag` anywhere under `src/app/tilgangsstyring/` or
`src/domains/tilgangsstyring/`). The established route-gating mechanism in the
repo is the `FeatureFlag` wrapper with `doNotFetchFlags` +
`environmentsOverride`, used by all utdanninger routes
(`src/app/utdanninger/emner/page.tsx` etc.). Used that idiom, which actually
fulfills the acceptance criterion (routes gated behind the flag).

### 2. Manual entry in generated `unleash.ts` instead of running `generate:unleash`

**Why**: `npm run generate:unleash` fetches the flag list from the Unleash
server (GitLab feature flags, project 3136) and regenerates the file. The flag
does not exist server-side yet and I have no write access to create it
(read-only client endpoint verified reachable; `glab` not installed, no
write-capable API access). Running the generator now would *remove* the new
flag from the types. Added the entry by hand in the generator's exact output
format instead. **Follow-up before launch**: create
`tilgangsstyring-brukeradministrasjon` in GitLab feature flags (same project
as `tilgangsstyring-meny`), leave it disabled for production, then re-run
`npm run generate:unleash` to confirm the file is reproduced identically.

### 3. Sub-item flag filtering added to `Menu.buildNavigationItems`

**Why**: `MenuItem` already supported `featureFlag` on sub-items, but
`buildNavigationItems` only filtered top-level items — a flag on a sub-item
was silently ignored. Filtering sub-items through the existing
`shouldShowMenuItem` is the minimal change that makes «gated bak både
`tilgangsstyring-meny` og det nye flagget» true (parent gate hides the whole
section; sub-item gate hides just Personbrukere).

### 4. Client `[id]` page with React `use(params)`

**Why**: The placeholder needs `useTranslations`, so the page is a client
component; `use(params)` is the established pattern for client dynamic pages
(`src/app/person/personsok/[id]/page.tsx`). A local
`params: Promise<{ id: string }>` interface mirrors
`applikasjoner/[id]/page.tsx` rather than the `PageProps<...>` global, so the
file does not depend on `next typegen` output for a brand-new route.

### 5. Placeholder markup = `BasicPageLayout` + `BasicPageSection`

**Why**: `BasicPageLayout` only accepts `BasicPageSection`/`Flex`/`Grid` as
content children (`filterBasicPageChildren`), so bare paragraphs would be
dropped. This gives the placeholder a proper h1 and section landmark for the
a11y tests, and is trivially deleted in Task #3/#4.

## Build Status

✅ **Build successful** — `npm run build` compiles («Compiled successfully in
19.6s») and the route table lists `ƒ /tilgangsstyring/personbrukere` and
`ƒ /tilgangsstyring/personbrukere/[id]`.
✅ **No new linter warnings** — targeted eslint run on all touched files is
clean; repo-wide warning count unchanged (pre-existing).
✅ **All imports resolved correctly** — typecheck clean.

## Integration Points

- **Task #3/#4** replace the placeholder page bodies with
  `<PersonbrukereOverview />` / `<PersonbrukerDetails id={id} />`; routes,
  breadcrumbs, typed hrefs, flag gating, menu and index entry are already in
  place. Task #3's `NavigationList` rows can use the typed
  `{ pathname: '/tilgangsstyring/personbrukere/[id]', params: { id } }` href.
- **Task #1 mock API** (`src/mocks/personbrukere/`) untouched, as required.
- **Unleash server**: flag creation in GitLab feature flags is the one
  remaining manual step before prod rollout (see Technical Decision #2); until
  then behavior is dev/review/test on, prod off — exactly the required
  rollout posture.

## Acceptance Criteria Met

- ✅ Feature flag `tilgangsstyring-brukeradministrasjon` with same
  `environmentsOverride` setup as `tilgangsstyring-meny` (dev/review/test on,
  prod off) — Evidence: `src/common/types/generated/unleash.ts:15`, override
  objects in both routes, `Menu.tsx` and `TilgangsstyringIndex.tsx`.
  ⚠️ Partial on the Unleash-server half: flag typed and effective locally;
  server-side creation documented as a pre-deploy follow-up (no write access
  from this environment) — accepted deviation per task instructions.
- ✅ Routes `personbrukere/{layout,page}.tsx` + `personbrukere/[id]/{layout,page}.tsx`
  after the applikasjoner pattern, placeholder pages — Evidence:
  `src/app/tilgangsstyring/personbrukere/` (4 files).
- ✅ Routes gated behind the flag; `npm run generate:routes` run, typed `*Href`
  exists — Evidence: `FeatureFlag` wrappers in both `page.tsx`;
  `src/common/types/generated/routes.d.ts:421-428`.
- ✅ Menu sub-item «Personbrukere» gated behind both flags — Evidence:
  `src/features/Header/Menu/Menu.tsx` (sub-item + sub-item filtering);
  verified by `Menu.test.tsx` (both-flags / only-meny / no-meny cases).
- ✅ Active «Personbrukere» card in `TilgangsstyringIndex` behind the flag;
  disabled Maskinbrukere button untouched — Evidence:
  `TilgangsstyringIndex.tsx`; `TilgangsstyringIndex.test.tsx` asserts the
  Maskinbrukere button is still disabled.
- ✅ i18n keys for menu/card/placeholder — Evidence:
  `src/common/messages/nb/{features,support,domains}.json`.
- ✅ a11y tests for changed components pass — Evidence: new
  `Menu.a11y.test.tsx`, `TilgangsstyringIndex.a11y.test.tsx`,
  `page.a11y.test.tsx` × 2 (components previously had no a11y tests at all);
  full `npm run test:a11y` green (262 suites / 843 tests).

## Next Steps

- Task #3 (`PersonbrukereOverview`) and Task #4 (`PersonbrukerDetails`) swap
  the placeholders for the real feature components (depend on Task #1 + #2 —
  both now done).
- Before production launch: create the flag in GitLab feature flags
  (project 3136), keep prod disabled, re-run `npm run generate:unleash`, and
  verify per the plan's risk mitigation («verifiseres i Unleash før merge»).

## Conclusion

The feature entrance is fully wired: flag, routes with breadcrumbs and typed
hrefs, menu entry and index card — all gated so dev/review/test see the
feature and production does not. All targeted and full test suites, typecheck,
lint and production build are green. Ready for Task #3/#4 to build on.

**Completed by**: bat-task-executor (subagent)
**Review Status**: Ready for review
