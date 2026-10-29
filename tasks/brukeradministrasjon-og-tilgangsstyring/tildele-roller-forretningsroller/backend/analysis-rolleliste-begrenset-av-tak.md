# Analysis: The role list in «Tildel roller» is limited by the delegation cap

> Produced by `bat-analyze` on 2026-10-29. Read against fs-plattform `origin/main` @ `dd12aff611` and fs-admin `origin/main` @ `9f1df4aa3`, both fetched the same day. Open MRs were read from their `refs/merge-requests/<n>/head`. Covers both repos (tilgangsstyring subgraph and FS Admin).
>
> The rule (BRU-PER-GRU-003) was `@draft` when the analysis started. Kjetil validated it the same day; it is now `@planned` through the egenskap and part of the BAT-326 scope.

## Problem Statement

When a user administrator gives a personbruker roles, the role list shows every business role the administrator may assign in the chosen organisation and environment. Many of them have no effect there, because no Feide application has the role in its cap (`applikasjon_brukerdelegering`) for that organisation and environment. Effective access through an application is `brukerroller ∩ tak(app)`, so a role outside every cap is dead for the user.

The rule narrows the list to business roles that are in the cap of at least one application in the organisation and environment, directly or through an organisation collection, or that a role in such a cap implies. No cap gives an empty list. The rule only filters the list: assignment, removal, tilganger and application administration are unchanged.

Seen from the code, this is a new condition on the query the dialog already uses. The difficult part is that the condition depends on data the administrator may not be allowed to read.

## Current State

### The dialog and its query (fs-admin)

| File (fs-admin, `origin/main`) | Role |
|---|---|
| `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/components/PersonbrukerRollerActions/actions/TildelRolleAction/TildelRolleAction.tsx` | The dialog. **One component for both tabs**, parameterised on `fane` (`roller` / `tilganger`). Cascade organisation → environment → codes (`:104`, `:115`) |
| `.../PersonbrukerRoller/hooks/useTildelbareBrukerTilgangskoder.tsx` | Query `tildelbareBrukerTilgangskoder` → `mineTildelbareTilgangsroller(first: 1000, filter: {organisasjonId, miljoId, navneromstyper, skjulUtgatte: true})` (`:37`). Sends `Feature-Flags: experimental`. Refetched when the pair changes |
| `.../PersonbrukerRoller/hooks/useGetPersonbrukerRollerTypes.ts:65` | `NAVNEROMSTYPER_PER_FANE`: `roller` → `[FORRETNING]`, `tilganger` → `[FRONTEND, SUBGRAF, TILGANGSSTYRING]`. This is the only thing that separates the roles tab from the tilganger tab in the query |
| `TildelRolleAction.tsx:257-263` | The code list is disabled when the pair is incomplete, while loading, or when the list is empty. Empty → `rollerIngenRettighet` |
| `src/common/messages/nb/tilgangsstyring.json:174` | `rollerIngenRettighet`: «Ingen roller å tildele i denne kombinasjonen.» (roller) / «Ingen tilganger å tildele i denne kombinasjonen.» (tilganger) |

The component's own doc comment says «Den tomme kodelisten er rettighetsgaten»: today an empty list means only that the administrator lacks the right to assign in the pair. The message key is named for that meaning (`…IngenRettighet`).

«Allerede tildelt» is derived on the client from the personbruker's DIRECT assignments (`useFjernbareBrukerTilganger`), not from the server list.

### The query (fs-plattform)

`Query.mineTildelbareTilgangsroller` in `tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_personbruker_tilgang_med_nummer.graphqls:127`, filter input `MineTildelbareTilgangsrollerFilterInput` at `:157`. Experimental. `@asConnection(defaultFirstValue: 100)`, sorted on `ROLLEKODE`, returns `Tilgangsrolle` over table `rolle`.

The whole selection is one `@condition` with `override: true`: `TildelingskilderConditions.erTildelbarForPersonbrukere` (`tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/TildelingskilderConditions.java:62`), with `argMapping` for `organisasjonskode`, `miljokode`, `navneromstyper`, `skjulUtgatte`. The filters today:

| Filter | How |
|---|---|
| Right to assign | `EXISTS` against `orger_med_feidebruker_tildelingsrett()` / `orger_med_person_tildelingsrett()` for the pair (`harPersonbrukerrett`, `:149`). Not per role: the right covers the whole catalogue |
| `organisasjonId`, `miljoId` | Field conditions `organisasjonIParet` / `miljoIParet` are `noCondition()`. The pair is handled in the main condition, because `rolle` has no FK to `organisasjon` |
| `navneromstyper` | `EXISTS` on `navnerom.navneromstypekode` |
| `skjulUtgatte` | `utgatt_tidspunkt IS NULL OR > now()` |
| `kodeEllerBeskrivelseContains` | Own field condition |

Nothing reads the cap. The class doc says the selection is a UI hint and that the source of truth is the assign functions and RLS.

Tests: `TildelbareRollerOgMiljoerQueryTest` (fixture orgs 97041–97042, subjects −9820…−9825) and `TilgangsrolleUtgattGraphqlTest:303` (the `skjulUtgatte` filter).

**Another consumer is on the way.** fs-admin !3046 (stacked on !3197, BAT-257) adds `RollerOverview/hooks/useGetMineTildelbareRoller.tsx`. It uses the same query for the role overview page with `filter: {navneromstyper: [FORRETNING]}` and **no organisation or environment**. The test class above already calls it «kildene til rolleoversikten, valglistene i dialogen «Gi rollen til en person» og radene på rollesiden».

### Where caps live (tilgangsstyring-new-db)

| Object | Defined | Content |
|---|---|---|
| `applikasjon_brukerdelegering` | `0003:459`, columns split later | `(subjekt_id → feide_applikasjon, rollekode, organisasjonskode, miljokode, gyldig_periode tstzrange)`, PK with `WITHOUT OVERLAPS`, `invalidert_tidspunkt` (GC tombstone) |
| `applikasjon_brukerdelegering_organisasjonssamling` | `0080` | Same shape with `organisasjonssamlingslopenr` in place of `organisasjonskode`. One row gives the cap in every active member organisation in the row's environment |
| `organisasjonssamlingsmedlemskap` | `0029:94` | Temporal membership `(organisasjonssamlingslopenr, organisasjonskode, miljokode, gyldig_periode)`. RLS `USING (true)`: open read |
| `rolle`, `rolle_implikasjon` | `0005:53-54` | RLS `USING (true)`: open read |

Only Feide applications have caps. The FK goes to `feide_applikasjon` in both tables, so Maskinporten and machine-user applications never contribute.

Validity: «active» is `invalidert_tidspunkt IS NULL AND gyldig_periode @> now()` on both cap rows and memberships (the pattern in `raa_delegeringstilganger`). A row with a future start is not active.

Caps are environment data: «Ingen grafflate og ingen seed» (0080). Migrations `0043` and `0059` only mirror existing cap rows for FS Admin (`service_id` 2196456) and `dev-brukeradmin` (0020). In an environment without cap rows, these are no-ops.

### RLS on caps

- `applikasjon_brukerdelegering_les` (`0048:311`): `BRUKERADMIN_WSBRUKER_LES` in the row's (environment, organisation), **or** LES in the application's owner organisation (`feide_applikasjoner_eid_av_mine_les_organisasjoner_per_miljo()`).
- `applikasjon_brukerdelegering_organisasjonssamling_les` (`0080:278`): LES in **every** active member organisation (`kan_lese_delegering_samling`, `0080:214`), or LES in the owner organisation.
- The write policies (`…_skriv`, FOR ALL) also grant reading to holders of `BRUKERADMIN_WSBRUKER_SKRIV`.

A user administrator for personbrukere has `BRUKERADMIN_PERSON_TILDELING_SKRIV` (from !6413, only that one for `PERSONBRUKER`), which carries no `WSBRUKER_LES`. An administrator who lacks application administration therefore sees no cap rows at all through RLS. In a collection, partial LES coverage also hides the row. An INVOKER condition over the cap tables would give an empty list for exactly the administrators the rule is meant for.

### How implications and caps are expanded today

- `tilgangsstyring.utvid_nedover(orgtilgang[])` (`0061:55`): recursive closure over `rolle_implikasjon` (active edges), downwards, keeping `organisasjonskode`. INVOKER, granted to the app role.
- `tilgangsstyring.raa_delegeringstilganger(p_env, p_subjekt_id)` (last body `0080:113`): the cap for **one application** in one environment, direct rows `UNION` collection rows × active memberships. INVOKER, granted to the app role. It reads past RLS only because its callers (`tilganger_for_*`, `auth.*`) are SECURITY DEFINER.
- `tilgangsstyring.utvidede_delegeringstilganger(p_env, p_subjekt_id)` (`0061:315`) = `utvid_nedover(raa_delegeringstilganger(...))`.
- The gulv migration `0099` (changeset `0099-migrer-gulvradene`) has an inline CTE `tak` that reads both cap forms across **all** applications, with collection periods intersected and `utvid_nedover` per row. It is the only existing query of the shape «caps across all applications», but it was a one-off data migration, not a function.

No existing function answers «which roles are in some application's cap for (organisation, environment)». The existing ones are per application (`p_subjekt_id`) and INVOKER.

### Existing SECURITY DEFINER helpers of a similar kind

These read past RLS and return a narrow answer. They show the house pattern (`SET search_path = tilgangsstyring, pg_temp`, `REVOKE ALL … FROM PUBLIC`, `GRANT EXECUTE … TO ${app_role}`, a `COMMENT ON FUNCTION` that says why DEFINER is used):

| Function | Migration | Narrow answer |
|---|---|---|
| `effektiv_tilgang_gjennom_samling(subjekt, rolle, org, miljø)` | 0107 | SAMLING/ARVET/NULL for one concrete combination, with its own recursive implication closure |
| `effektiv_tilgang` | 0035 | Same, for direct assignments |
| `samlingstildelinger_i_mine_les_organisasjoner()` | 0107 | Collection assignments filtered on the caller's own LES |
| `ekte_applikasjoner()` | 0105 | Which applications are real, past the read policies (used by I2 policies) |
| `applikasjon_er_deaktivert(subjekt)` | 0019 | Boolean |
| `orger_med_tildelingsrett()` (+ `_feidebruker_`, `_person_` variants) | 0035/0085/0087 | The caller's (org, env) pairs with the right, read from claims |
| `hele_rollekjeden(rollekode)`, `filterroller_med_arv(text[])` | 0072, 0070 | Role closures over the catalogue |
| `kan_forvalte_delegering`, `kan_forvalte_delegering_samling` | 0048, 0080 | «May I», INVOKER on purpose |

0029 records the counter-argument in a comment: «En DEFINER-helper med (miljø, subjekt_id) som parametre ville gitt app-rollen en ny lesekanal på tvers av organisasjoner — nøyaktig det RLS er der for å hindre.»

### Assignment path

`tildelPersonbrukerTilganger` → `tildel_brukertilgang` (last body 0102) checks the right to assign and I2/I4, but not the cap. It does not read `applikasjon_brukerdelegering`. This matches the decision that the backend does not reject assignments outside the cap.

## Key Findings

1. **One query, three consumers.** `mineTildelbareTilgangsroller` feeds both tabs of the dialog (roles and tilganger, separated only by `navneromstyper`). In !3046 it also feeds the role overview (no org/env), and its test class names the «Gi rollen til en person» dialog. A condition that always applies would change the tilganger tab and the overview, which the rule excludes. Kjetil's hint (a new filter on the existing query) fits: today's filters are opt-in fields on `MineTildelbareTilgangsrollerFilterInput` through `argMapping`, with `skjulUtgatte` as the closest model.
2. **The cap cannot be read under the caller's RLS.** A personbruker administrator normally has no `BRUKERADMIN_WSBRUKER_LES`, so both cap tables are invisible to them. Collections need full LES coverage. «In some cap» has to be decided past RLS, and the answer must not reveal which application or which cap.
3. **No existing helper fits.** `raa_delegeringstilganger`/`utvidede_delegeringstilganger` are per application and INVOKER. The only «all applications» query is the inline CTE in the 0099 data migration. The DEFINER helpers above give the pattern for a narrow window, and 0029 gives the argument a reviewer will raise against a broad one.
4. **Implications are downwards only.** `utvid_nedover` is the existing closure, and the rule («en rolle som en rolle i taket gir») matches that direction. A business role that is not in a cap itself, but implies roles that are, is not shown.
5. **Validity (decided by Kjetil 29.10.2026):** only caps valid right now count, `gyldig_periode @> now() AND invalidert_tidspunkt IS NULL`, for direct cap rows, collection cap rows and the collection membership alike. This is what every existing cap reader does (`raa_delegeringstilganger`, 0080). 0099 deviated (it included future starts and intersected periods), so it is not a template for this condition.
6. **I2 and synthetic applications bear on what counts.**
   - !6238 (BAT-318, open) adds restrictive SELECT policies so that real applications' caps are invisible from a synthetic environment. A helper that reads past RLS skips those policies. The answer is a role set without application identity, so whether I2 is touched depends on whether the role list counts as «data about» the application.
   - !6357 (BAT-350, open) rejects synthetic applications in every environment. A synthetic application's cap then never gives effect anywhere. `0099` already excluded them in real environments.
   - A deactivated application (`deaktivert_tidspunkt`) gives no effect either (`tilganger_for_applikasjon` filters on `applikasjon_er_deaktivert`).
   - The environment in the filter (`miljoId`, the target environment) is not the request's environment (`auth.current_miljokode()`). Test is administered from production (I5).
7. **The empty list gets a second meaning.** Today «Ingen roller å tildele i denne kombinasjonen.» means «no right in this pair». With the rule it also means «no application has a cap here». Decided 29.10.2026: keep the neutral text (see Open Questions).
8. **Seed data.** Caps are environment data with no seed beyond mirroring FS Admin's existing rows. Locally and in review, the roles tab may be empty for the fixture unless caps exist for the chosen pair. This affects tests and manual verification, not production.
9. **Performance.** The condition runs per `rolle` row in a connection with `totalCount`, `first: 1000` from fs-admin. The existing cap readers are tuned per application (`idx_app_brukerdelegering_orgsamling_aktiv` is on `(subjekt_id, miljokode)`). There is no index on `applikasjon_brukerdelegering` led by `(organisasjonskode, miljokode)`. Check what the PK and `0003` indexes provide before assuming an access path.

## Technical Constraints

- **GraphQL (fsp-graphql-standards):** new schema goes in experimental. `schema_personbruker_tilgang_med_nummer.graphqls` is already experimental and fs-admin already sends `Feature-Flags: experimental`. Boolean fields start with a verb (`skjulUtgatte` is the model). Descriptions must be updated on the query (it currently says «hele rollekatalogen») and on the filter field.
- **Migrations (fsp-migration-standards):** on `main` the last migration is `0125`. Held by open MRs: `0109` (!6238), `0116`, `0117`, `0119` (!6324), `0121` (!6355), `0126` (!6357), and `0064`/`0097` in old MRs (!6322, !5926). **The next free migration number is `0127`.** pgTAP: on `main` up to `105`; held: `94` (!6238), `99`, `100`, `106` (!6324/!6355), `102` (!6357). **The next free pgTAP number is `107`.** `CREATE OR REPLACE` must start from the **last** body: `raa_delegeringstilganger` = 0080, `utvidede_delegeringstilganger`/`utvid_nedover` = 0061.
- **tilgangsstyring conventions:** a DEFINER function has `SET search_path = tilgangsstyring, pg_temp`, `REVOKE ALL FROM PUBLIC`, `GRANT EXECUTE TO ${app_role}`, and a `COMMENT ON FUNCTION` that states why DEFINER is used and what limits the window. Temporal rows are «active» by both conditions.
- **I2/I4/I5** (`tilgangsstyring/docs/syntetiske-og-ekte-data.md`): a request to a synthetic environment answers only with synthetic data. Synthetic subjects never reach a real environment. A right given in one environment applies only to data in that environment.
- **The selection is a UI hint**, per the `TildelingskilderConditions` javadoc and `tilgangsmodell.md`. That matches «the cap only limits the list».
- **No enforcement:** `tildel_brukertilgang` must stay unchanged with respect to the cap (decided).
- **fs-admin:** messages live in `src/common/messages/nb/*.json` as ICU with a `variant` select shared by both tabs. The dialog has a11y and unit tests with mocks of `mineTildelbareTilgangsroller` (`TildelRolleAction.test.tsx:167`, `.a11y.test.tsx:75`). The user guide `src/features/Brukerveiledninger/innhold/personbrukere.md` has an «Under utvikling» note about the role list that must be updated when the filter lands.
- **Deploy:** tilgangsstyring is in production on merge to `main`, so fs-admin can use a new field right after the main pipeline.

## Dependencies

- **Internal (fs-plattform):** `TildelingskilderConditions.erTildelbarForPersonbrukere` and its `argMapping`; the cap tables, memberships, `rolle_implikasjon`, `utvid_nedover`, and the classification of applications (`er_syntetisk`, `deaktivert_tidspunkt`); `tilgangsstyring/docs/tilgangsmodell.md` (paragraph on the dialog lists).
- **Open MRs touching the same code (fs-plattform):**
  - **!6413 (BAT-257):** changes `TildelingskilderConditions` and the description of `mineTildelbareTilgangsroller`. Must merge after fs-admin !3197. Textual conflict for parallel changes.
  - **!6238 (BAT-318):** I2 policies on both cap tables (0109, pgTAP 94).
  - **!6324 / !6355 (BAT-351 / BAT-359):** 0119 rewrites the policies of `applikasjon_brukerdelegering`.
  - **!6357 (BAT-350):** synthetic applications rejected everywhere (0126, pgTAP 102).
- **Open MRs touching the same code (fs-admin):** the BAT-257 stack, all changing `TildelRolleAction.tsx` and `tilgangsstyring.json`: !3197 (base), !3046 (role overview and `GiRollenTilPersonModal`), !3210, !3245, !3251, and !3278 (`tilgangsstyring.json` only). None change `rollerIngenRettighet` or the hook's variables.
- **Cross-contributor:**
  - **frontend (fs-admin):** send the new filter only from the roles tab of `TildelRolleAction` (not tilganger, not `RollerOverview`, not `GiRollenTilPersonModal` unless decided). Blocked by the subgraph field being on `main`. Ordering against the BAT-257 stack and !6413.
  - **backend (fs-plattform):** the server-side filter and the database object that answers «in some cap». Must exist before fs-admin can send the filter.

## Requirements Impact

- **Addressed today:** none of the six scenarios in the new rule. The other list rules in `tildele_roller.feature` (only business roles, retired roles hidden, list depends on organisation and environment) are met. The removal scenario is met today and stays met as long as `FjernRolleAction`/`useFjernbareBrukerTilganger` are not touched.
- **At risk:**
  - «Taket for en organisasjonssamling gjelder organisasjonene i samlingen»: collection caps are hidden by RLS even for administrators with partial LES, and not visible through the graph's `FeideApplikasjon.brukerdelegeringer` (direct rows only), so they are hard to verify by hand.
  - The scenario outline (other environment / other organisation) depends on matching as in `raa_delegeringstilganger` (the collection row's `miljokode` = the membership's `miljokode`).
  - The exclusions (not tilganger, not application administration, not removal) depend on the filter being opt-in.
- **Missing requirements discovered:** whether caps of synthetic and deactivated applications count; whether «Gi rollen til en person» on the role page (!3046) follows the same rule.

## Krav-input referanse

- **Spec-dokument:** [`spec-changes-2026-10-29-krav-rolleliste-begrenset-av-tak.md`](../spec/spec-changes-2026-10-29-krav-rolleliste-begrenset-av-tak.md)
- **Krav-input-manifest:** [`krav-input/changes/2026-10-29-krav-rolleliste-begrenset-av-tak/manifest.md`](../spec/krav-input/changes/2026-10-29-krav-rolleliste-begrenset-av-tak/manifest.md)
- **Implementasjonsdetaljer:** [`tildele_roller.design.md`](../../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon/tildele_roller.design.md)

## Open Questions

From the spec:

- [x] **Status:** validated by Kjetil 29.10.2026; `@planned` through the egenskap.
- [x] **Task and scope:** stays in BAT-326 / scope-restanser-etter-onboarding (Kjetil 29.10.2026).
- [x] **Validity periods:** only caps valid right now count, for direct cap rows, collection cap rows and the collection membership alike (Kjetil 29.10.2026).
- [x] **Empty-state text:** keep «Ingen roller å tildele i denne kombinasjonen.» (Kjetil 29.10.2026). It follows the pattern in fs-admin's tilgangsstyring module, where the empty list is the gate and the client doesn't distinguish why it is empty.

Found by this analysis:

- [ ] **Synthetic and deactivated applications:** should their caps count? (a) every Feide application's cap; (b) exclude deactivated applications; (c) exclude synthetic applications too, in line with BAT-350 and the 0099 precedent; (d) exclude synthetic applications only in real environments.
- [ ] **Exposure past RLS:** is it acceptable that an administrator without `BRUKERADMIN_WSBRUKER_LES` learns which business roles are in some cap for an organisation where they hold the right to assign, without learning which application or cap? The rule requires it; the question is whether it needs a decision from the security side, given the 0029 argument against broad DEFINER helpers.
- [ ] **I2 for the answer:** from a synthetic environment, should caps of real applications count (cf. !6238)? The answer exposes no application, only roles.
- [ ] **«Gi rollen til en person» on the role page (!3046):** limited by the cap too, or only «Tildel roller» as the rule says?
- [ ] **Ordering:** build on top of the BAT-257 stack (fs-admin !3197 → !3046 …, fs-plattform !6413), or ahead of it?
