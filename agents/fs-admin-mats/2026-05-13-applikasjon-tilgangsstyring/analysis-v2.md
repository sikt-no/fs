# Analysis: Applikasjon-tilgangsstyring (Iterasjon 2 + 3)

> **Scope**: This analysis covers [sikt-no/fs#434](https://github.com/sikt-no/fs/issues/434) (Iterasjon 2 — Support: Oversikt og passordbytte) and [sikt-no/fs#435](https://github.com/sikt-no/fs/issues/435) (Iterasjon 3 — Grunnleggende tilgangsstyring for intern support), both children of the initiativ-issue [#31](https://github.com/sikt-no/fs/issues/31).
>
> The analysis is intentionally **solution-free** per `bat-analyze`. Solution design happens in `bat-plan`.

## Problem Statement

FS Admin today exposes a **POC ("proof of concept")** for managing maskinbrukere (machine users / API-brukere). The POC was never formally rolled out and is gated behind the Unleash flag `tilgangsstyring-meny`. The applikasjons-initiativ ([#31](https://github.com/sikt-no/fs/issues/31)) replaces this POC with a **net-new applikasjons-administration surface**.

Three explicit constraints from the initiativ-body force this to be a rebuild, not an extension:

1. _"Vi lager en ny løsning tilgangsstyring av applikasjoner, vi bygger ikke i videre på dagens POC for visning av maskinbruker i FS Admin."_
2. _"Dagens løsning for maskinbruker i FS Admin er ikke innført og skal fjernes."_
3. _"Vi skal lage nye graphql spørringer for applikasjon. Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker."_

The two iterations in scope deliver:

- **Iterasjon 2 (#434)**: read + light-edit support flow — listevisning, detaljer, tilganger-tab, passordbytte, administrere ansvarlig, redigere beskrivelse.
- **Iterasjon 3 (#435)**: write/lifecycle flow — opprette applikasjon (Feide/Maskinporten), tildele tilgang, fjerne tilgang, deaktivere/reaktivere.

Iterasjon 4 (selvbetjent administrasjon, endringslogg) and "Nice to have"-issue [#437](https://github.com/sikt-no/fs/issues/437) are **out of scope** for this analysis.

## Current State

### The maskinbruker POC

Lives entirely under `src/domains/support/features/` and totals ~2972 LOC across ~30 components.

**List view (`Maskinbrukere/`, ~1221 LOC)** — [`Maskinbrukere.tsx:17-35`](../../src/domains/support/features/Maskinbrukere/Maskinbrukere.tsx):

- Wraps `ListPageLayout` + `ListPageActionbar` + `ListPageSidebar` + `ListPageContent`
- Filters: `MaskinbrukereSearchFilter`, `ApiAccessFilter`, `NeedsAttentionFilter`, `OrganisationConnectionFilter`
- Sort: `MaskinbrukereOrderBy`
- Data hook: [`useGetMaskinbrukere.ts`](../../src/domains/support/features/Maskinbrukere/hooks/useGetMaskinbrukere.ts) — defines `GET_MASKINBRUKERE` inline (line 19), uses `context: { headers: { 'Feature-Flags': 'experimental' } }` (line 63) toward the SuperGraf gateway
- Client-side: organisation filter → API-access filter → Fuse.js fuzzy-search → sort (lines 76–145)

**Detail view (`MaskinBruker/`, ~1654 LOC)** — [`Maskinbruker.tsx:28-51`](../../src/domains/support/features/MaskinBruker/Maskinbruker.tsx):

- `DetailPageLayout` + `DetailPageTopBar` + `DetailPageTabbedContent` with two tabs (data-tilganger, API-tilganger)
- Each tab has its own filter/sort/list trio: `ApiTilgangerFilter/OrderBy/ResultList` and `DataTilgangerFilter/OrderBy/ResultList`
- Filter state persisted in Zustand-style stores: `useMaskinbrukerApiTilgangerFilterStore`, `useMaskinbrukerDataTilgangerFilterStore`
- **Password rotation**: [`MigrerPassord/MigrerPassordDialog.tsx`](../../src/domains/support/features/MaskinBruker/components/MigrerPassord/MigrerPassordDialog.tsx) — _this is the existing implementation of exactly the K5 pattern_ (masked password, eye-toggle, ClipboardWrapper, GuidePanel warning, one-shot display). Lines 38, 75–118.

**Routes** (`src/app/tilgangsstyring/`):

- `/tilgangsstyring` → `TilgangsstyringIndex` (intro card)
- `/tilgangsstyring/maskinbrukere` → `Maskinbrukere`
- `/tilgangsstyring/maskinbrukere/[maskinbrukerid]` → `Maskinbruker`

**Navigation gating** — [`Menu.tsx:95-112`](../../src/features/Header/Menu/Menu.tsx):

```ts
{ href: '/tilgangsstyring', title: 'Tilgangsstyring', featureFlag: 'tilgangsstyring-meny',
  subItems: [{ href: '/tilgangsstyring/maskinbrukere', title: 'Maskinbrukere' }] }
```

**i18n** — [`src/common/messages/nb/support.json`](../../src/common/messages/nb/support.json) (~133 lines) holds all `support.Maskinbruker*`-namespaces, including the rich `MaskinbrukerMigrerPassordDialog` keys.

**Tests** — none. Neither `*.a11y.test.tsx` nor `*.test.tsx` files exist in `src/domains/support/features/`. This violates the project's "every component MUST have `ComponentName.a11y.test.tsx`" rule.

### Permission model

- Hook: [`useAdmissioUserActions.tsx`](../../src/common/lib/auth/useAdmissioUserActions.tsx) — fetches `minBruker { id, organisasjon { id }, handlinger }` and exposes `{ userActions, userId, organisationId }`.
- Enum: [`src/common/types/userActions.ts`](../../src/common/types/userActions.ts) — current values: `SE_*` / `MODIFISERE_*` for `UTDANNING`, `SOKNAD`, `SOKNADSBEHANDLING`, `REGELVERK`, `ORGANISASJONER`, `OPPTAK`. **No applikasjonsadministrator or super-applikasjonsadministrator action.**
- Menu items gate via `userActions: USER_ACTION[]` array per item.

### GraphQL surface

- Schema source: `GRAPHQL_SCHEMA_LOCATION` (defaults to `https://supergraf-gateway-test.fsweb.no/graphql`) in [`src/codegen.ts:8`](../../src/codegen.ts).
- Generated artefacts: `src/__generated__/{graphql.ts, gql.ts, possibleTypes.json}`.
- Maskinbruker types currently in supergraf-schema: `Maskinbruker`, `ApiTilgangsrolle`, `DatatilgangForMaskinbruker`, `ApiTilgangForMaskinbrukerV2`, query field `maskinbrukere(first, after, filter: MaskinbrukereFilter)` returning a connection.
- These will need to be **removed or deprecated** in the supergraf-schema in parallel with FS-admin removing the POC.

### Reusable patterns already in the codebase

| Need                            | Reusable pattern                                                                                                                                                               |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Listing layout                  | `ListPageLayout` (`src/common/components/layouts/ListPageLayout/`)                                                                                                             |
| Detail layout with tabs         | `DetailPageLayout` + `DetailPageTabbedContent`                                                                                                                                 |
| Destructive-action confirmation | `ButtonWithConfirmation` (`src/common/components/buttons/ButtonWithConfirmation/`) — translations `components.ButtonWithConfirmation.title`, `common.cancel`, `common.confirm` |
| Copy-to-clipboard               | `ClipboardWrapper` (`src/common/components/ClipboardWrapper/`)                                                                                                                 |
| Masked one-shot secret          | `MigrerPassordDialog` pattern (eye-icon toggle + `ClipboardWrapper` + `GuidePanel variant="warning"`)                                                                          |
| Filter-state persistence        | Zustand-style hooks (see `useMaskinbrukerApiTilgangerFilterStore`)                                                                                                             |
| Permission gating               | `useAdmissioUserActions` + per-item `userActions: USER_ACTION[]`                                                                                                               |
| Codegen with new operations     | inline `gql()` calls picked up by `src/codegen.ts` glob                                                                                                                        |

## Key Findings

1. **The POC has the right _shape_ but wrong _contract_.** Almost every UI primitive the krav wants — listing with filters, detail with tabs, masked password dialog, confirmation dialogs — exists already. The constraint is at the data layer: new GraphQL surface, new permission codes, new domain naming.
2. **Removing the POC is non-trivial.** ~30 components, ~3000 LOC, route + nav menu + i18n keys + Apollo `Feature-Flags: experimental` header usage. There's no test scaffolding to lean on, so removal needs careful manual verification.
3. **No naming collision on "applikasjon"** in `src/`. Safe to introduce `src/domains/support/features/Applikasjoner/` and `Applikasjon/` parallel to the existing POC folders (or as their replacements).
4. **The MigrerPassordDialog already proves K5 (Passordbytte) UX.** The Iter 2 spec for K5 (one-time display, masked, copy, warning, regenerate) maps 1-to-1 onto the existing dialog. The behavior contract — "kan ikke hentes opp igjen etter at dialogen er lukket" — is also exactly what the current component enforces.
5. **The krav introduces a layered visibility model that's new** — three orthogonal axes:
   - **Rollebasert**: super-applikasjonsadministrator (alle) vs. applikasjonsadministrator (egne organisasjoner)
   - **Tilgangs-relasjon**: en applikasjonsadministrator skal også se _fremmede_ applikasjoner _hvis_ de har tilganger i admin'ens organisasjon (K12 — krever cross-org-join)
   - **Ansvarlig-relasjon**: feide-bruker (eller @could: feide-gruppe) ansvarlig ser applikasjonen
   - The current `handlinger`-modell på `minBruker` er én flat liste — denne tre-akse-modellen krever sannsynligvis enten organisasjons-skopa handlinger eller en separat applikasjon-synlighet-mekanisme på backend.
6. **Identitetsleverandør-konseptet er nytt for FS Admin.** Krav K8 forutsetter at backend kan slå opp Feide-ID og Maskinporten-ID mot kilden ved opprettelse, hente visningsnavn derfra, og forhindre duplikat-ID-er. FS er utfaset for nye, men eksisterende FS-applikasjoner skal vises og administreres som legacy.
7. **Bulk-fjerning av tilganger (K14) i ett miljø** er en bulk-mutasjon som ikke har en eksisterende parallell i fs-admin — det er enklere å bygge enn å gjenbruke.
8. **Globalt unikt visningsnavn (K8)** krever en globalt-unik constraint på backend, ikke noe fs-admin selv kan håndheve — feilen kommer som en valideringsfeil ved opprettelse.
9. **Reversibel deaktivering (K9)** krever et soft-delete-style state-felt (`aktiv | deaktivert`) på applikasjonen og at tilgangene blir bevart, men "gir ikke faktisk tilgang så lenge applikasjonen er deaktivert" — autorisasjons-logikken som faktisk håndhever dette er backend-ansvar.

## Technical Constraints

### From CLAUDE.md / project conventions

- **Next.js 16 App Router** med Webpack-bundler — nye sider plasseres som `src/app/<rute>/page.tsx`.
- **Apollo Client 4 + GraphQL codegen** med fragment masking _off_ (`fragmentMasking: false`, `inlineFragmentTypes: 'mask'` i `src/codegen.ts:20,35`). Nye queries plukkes opp automatisk via globben i `src/codegen.ts:12`.
- **GraphQL query-plassering**: queries skal være "closely related to components they're used in" og **ikke** gjenbrukes på tvers — bare flytt til feature-level `queries.ts` hvis både server- og klient-komponenter trenger samme query.
- **A11y-test påkrevd**: hver komponent må ha `ComponentName.a11y.test.tsx`. Nye applikasjon-komponenter bør bryte med POC-mønsteret og oppfylle dette.
- **CSS Modules + Sikt Design System** — ingen generiske UI-biblioteker.
- **Norsk forretningsdomene, engelsk kode**. Komponentnavn: `PascalCase`; mapper: `camelCase`.
- **Conventional commits** + ren git-historie.
- **i18n via next-intl**, meldingsfiler i `src/common/messages/nb/` (NB: prosjektet er allerede strukturert med en `support`-namespace under `support.json`, ikke per-feature filer som det generelle CLAUDE-mønsteret antyder).

### Fra krav-input

- **Identitetsleverandør låses ved opprettelse** — kan ikke endres senere. En applikasjon = én idP.
- **FS-applikasjoner kan ikke opprettes nye** — eksisterende består som legacy.
- **Passord-modell**: basic auth, ett aktivt passord, generert av systemet, vises én gang.
- **Bulk-operasjoner krever bekreftelse** med liste av berørte tilganger + miljø.
- **Søk for ansvarlig er begrenset til applikasjonens organisasjon.**
- **Visningsnavn må være globalt unikt** på tvers av alle organisasjoner.
- **Paginering 50 om gangen** for liste (Iter 2) og tilganger-tab (Iter 2).

### Plattform-rammer

- **Feide OIDC** via NextAuth.js — alle brukerkontekster (også "ansvarlig" som feide-bruker/gruppe) lever i denne identitets-modellen.
- **SuperGraf-gateway** er enkelt-endepunktet for GraphQL; alle nye applikasjon-operasjoner må eksponeres derfra.

## Dependencies

### Internal (fs-admin)

| Dependency                                                     | What's affected                                                                                                                              |
| -------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `src/__generated__/*`                                          | Codegen kjøres på nytt mot ny supergraf-schema med applikasjon-typer; gamle maskinbruker-typer forsvinner.                                   |
| `src/common/types/userActions.ts`                              | Trenger nye `USER_ACTION`-verdier for applikasjonsadministrator/super-applikasjonsadministrator.                                             |
| `src/features/Header/Menu/Menu.tsx`                            | Erstatt `Maskinbrukere`-sub-item med `Applikasjoner`. Vurder ny featureFlag (eller behold `tilgangsstyring-meny`).                           |
| `src/app/tilgangsstyring/`                                     | Routes endres: `/maskinbrukere/*` fjernes, `/applikasjoner/*` legges til. `TilgangsstyringIndex.tsx` oppdateres til å peke på applikasjoner. |
| `src/common/messages/nb/support.json`                          | Nye namespaces (`Applikasjoner`, `Applikasjon`, `ApplikasjonPassord`, osv.); gamle `Maskinbruker*`-nøkler avvikles.                          |
| `src/domains/support/features/Maskinbrukere/`, `MaskinBruker/` | ~3000 LOC slettes som del av POC-fjerningen.                                                                                                 |
| `useAdmissioUserActions`                                       | Ingen kode-endring nødvendig, men avhenger av at backend leverer de nye handlingene i `handlinger`-feltet.                                   |

### External

- **Sikt Design System (`@sikt/sds-*`)** — Dialog, Button, Tabs, Table, GuidePanel-komponentene som de eksisterende mønstrene allerede bruker.
- **Apollo Client 4** — `useQuery`, `useMutation`, cache-konfigurasjon i `src/lib/apollo/`.
- **NextAuth.js / Feide OIDC** — for ansvarlig-oppslag.
- **Maskinporten** — ny ekstern avhengighet på _backend_-siden for ID-verifikasjon; FS Admin ser dette kun gjennom GraphQL-feilmeldinger.
- **Confluence-referanser i krav** — K-numre (K1–K19, K11/K12, K13/K14, osv.) refererer Confluence-side `4401102853` for rammeinnsikten. Disse er kontekst, ikke direkte avhengighet.

### Cross-agent (candidate hand-offs)

> Per bat-analyze: disse er **kandidater**, ikke åpnede hand-offs. `bat-plan` revisiterer dem etter at planen finnes og kan filere via `agent-coord` med konkret kontekst.

1. **Backend / GraphQL-schema-agent** — eier supergraf-gateway og applikasjons-domenet.
   - _Hva trengs_: Ny GraphQL-overflate (`applikasjon`, `applikasjoner`, mutasjoner for opprett/tildel tilgang/fjern tilgang/deaktiver/reaktiver/passordbytte/sett ansvarlig/rediger beskrivelse), inkludert filter-input som dekker organisasjon, tilgang, status og fritekst-søk, og tre-akse-synlighetsmodell (rolle + org-tilgang + ansvarlig).
   - _Hvorfor blokkerer_: Initiativ-bestillingen forbyr gjenbruk av maskinbruker-queries, så fs-admin kan ikke starte før en ny schema-kontrakt er definert.
2. **Identitets-/Feide-/Maskinporten-agent** — eier kobling mot eksterne idP-er.
   - _Hva trengs_: Backend-tjeneste for å verifisere Feide-ID og Maskinporten-ID mot kilden ved opprettelse av applikasjon, hente visningsnavn fra idP-en, og avvise duplikat-ID-er. Også Feide-gruppe-oppslag for ansvarlig (@could-scenarier).
   - _Hvorfor blokkerer_: K8-scenariene for FE-opprettelse er ikke fullført før idP-verifikasjon eksisterer på backend.
3. **Autorisasjons-/handlinger-agent** — eier `handlinger`-feltet på `minBruker`.
   - _Hva trengs_: Nye `applikasjonsadministrator`- og `super-applikasjonsadministrator`-handlinger som leveres i `handlinger`-feltet. Tre-akse-synligheten (K11/K12 + ansvarlig-relasjon) trenger trolig organisasjons-skopa handlinger eller en utvidet kontrakt.
   - _Hvorfor blokkerer_: UI-gating (Menu, listevisning, detalj, mutasjonsknapper) krever de nye handlingene før komponentene kan gjemme/vise riktig.
4. **POC-fjernings-koordinering med supergraf-eier** (kan slås sammen med #1) — fjerne `maskinbrukere`-feltet og tilhørende typer fra supergraf-schema når fs-admin har migrert. Krever en kort utfasings-vindu der gammel + ny eksisterer samtidig.

`bat-plan` vil bekrefte disse med brukeren etter at planen er publisert og kan da invoke `agent-coord` med konkret kontekst (GraphQL-skisse, antall tasks, tidspunkter).

## Requirements Impact

Det finnes ingen `docs/ACTIVE/requirements-*.md` i repoet. Kravene leveres i stedet som Gherkin `.feature`-filer på `fruitbat`-branchen i `sikt-no/fs` (se _Krav-input fra GitHub_ under).

Kravene som inngår i denne analysen, oppsummert per feature-ID:

| Feature-ID      | Egenskap               | Iter | GitHub           |
| --------------- | ---------------------- | ---- | ---------------- |
| BRU-APP-API-001 | Listevisning og søk    | 2    | #438, #448, #449 |
| BRU-APP-API-002 | Se detaljer            | 2    | #439             |
| BRU-APP-API-003 | Vise tilganger         | 2    | #440             |
| BRU-APP-API-004 | Passordbytte           | 2    | #441             |
| BRU-APP-API-005 | Administrere ansvarlig | 2    | #442             |
| BRU-APP-API-006 | Redigere beskrivelse   | 2    | #443             |
| BRU-APP-API-007 | Tildele tilgang        | 3    | #444, #450       |
| BRU-APP-API-008 | Fjerne tilgang         | 3    | #445, #451       |
| BRU-APP-API-009 | Opprette applikasjon   | 3    | #446             |
| BRU-APP-API-010 | Deaktivere applikasjon | 3    | #447             |

**Confluence-K-referanser bevart i Gherkin-bakgrunnstekst**: K1, K2, K3, K4, K5, K6, K7, K8, K9, K11, K12, K13, K14, K18, K19. K10 (permanent sletting) er bevisst utelatt jf. systemkrav-notatet i Iter 3 — deaktivering er sluttilstanden.

## Krav-input fra GitHub

- **Kilde-issue(s):** [#434](https://github.com/sikt-no/fs/issues/434) (Iterasjon 2), [#435](https://github.com/sikt-no/fs/issues/435) (Iterasjon 3) — begge sub-issues av initiativ [#31](https://github.com/sikt-no/fs/issues/31)
- **Repo / branch:** `sikt-no/fs` @ [`fruitbat`](https://github.com/sikt-no/fs/tree/fruitbat) (sha `f2832a2d7a706d8981c1d34ef4ece647a9482644`)
- **Branch-navn-kilde:** brukeren oppga `fruitbat` direkte (begge sub-issues har tomme bodies — ingen branch-referanse å plukke fra)
- **Hentede `.feature`-filer:** [`docs/ACTIVE/krav-input/manifest.md`](krav-input/manifest.md) lister alle 12 filene + systemkrav-summaries (7 for Iter 2, 5 for Iter 3, alle `status: added`)
- **Hentet:** 2026-05-13

## Open Questions

> Alle 10 åpne spørsmål ble besvart av brukeren 2026-05-13. Spørsmålene er beholdt for sporing; under hvert er **Decision** (det brukeren bestemte), **Rationale** (hvorfor dette holder mot kravet) og **Impact** (hva som flyter ut av beslutningen og inn i plan-fasen).

- [x] **Migrasjon av eksisterende FS-applikasjoner**: Krav K8 sier "Eksisterende FS-applikasjoner består og administreres som før". Hva betyr "administreres som før" konkret — beholdes maskinbruker-POC-en for legacy FS-applikasjoner, eller flyttes legacy-applikasjoner inn i den nye applikasjon-visningen med idP-flagg `FS`? Initiativ-teksten sier samtidig "Dagens løsning ... skal fjernes". Disse to ser ut til å peke i ulik retning.
  - **Decision** (2026-05-13): Nye FS-applikasjoner kan **ikke** opprettes, men eksisterende FS-applikasjoner **vises** i den nye listen og **kan tilgangsstyres** (passord, ansvarlig, beskrivelse, tilganger, deaktivering).
  - **Rationale**: Forsoner de to tilsynelatende motstridende initiativ-utsagnene — "POC-en fjernes" gjelder *koden/rutene*, ikke *dataene*. FS-applikasjoner er en del av domenet og må forvaltes; de bare lever ikke i en egen UI-flate lenger.
  - **Impact**: Ny GraphQL trenger en `IdentitetsleverandørType`-enum med verdier `FEIDE | MASKINPORTEN | FS`, hvor `FS` returneres på legacy-applikasjoner men ikke er valgbar ved opprettelse. Opprett-skjema må filtrere bort `FS` fra valglisten (jf. `opprette_applikasjon.feature` scenariet "FS er ikke en valgbar identitetsleverandør").

- [x] **Erstatte eller leve side-om-side under utvikling**: skal `/tilgangsstyring/maskinbrukere`-ruten fjernes umiddelbart ved Iter 2-deploy, eller leve side-om-side med ny `/tilgangsstyring/applikasjoner` bak en featureFlag til Iter 3 er ute?
  - **Decision** (2026-05-13): Side-om-side under feature-flag-kontroll — POC-en er allerede gated bak `tilgangsstyring-meny`-flagg, så ingen "big bang" trengs.
  - **Rationale**: POC-en ble aldri rullet ut i prod (flag-gated), og ny rute kan parallelt gates bak en egen flag (se Q4). Risikoen ved å la dem leve i samme deploy er minimal.
  - **Impact**: Iter 2-deploy trenger ikke fjerne maskinbruker-POC-en. Fjerningen kan skje når Iter 3 er ute og ny flag er aktivert i prod. Migrasjons-arbeidet (fjerne ~3000 LOC) blir en egen rydde-PR.

- [x] **Test-strategi for POC-fjerning**: maskinbruker-POC-en har ingen tester. Skal vi backfill-le a11y-tester før fjerning (for safety net), eller stole på at fjerning er trygt fordi POC-en aldri var i prod?
  - **Decision** (2026-05-13): Fjerning er trygt — slett POC-koden uten å backfille tester.
  - **Rationale**: POC-en er feature-flag-gated og aldri rullet ut i prod, så fjerning endrer ikke noe brukervendt. Å skrive tester for kode som skal slettes er bortkastet arbeid.
  - **Impact**: POC-fjernings-PR-en kan være en mekanisk diff. **Ny** applikasjon-kode skal selvfølgelig oppfylle prosjektets a11y-test-krav fra første commit.

- [x] **Feature-flag-modell**: en ny `applikasjoner`-flag (e.g. `tilgangsstyring-applikasjoner`) under `tilgangsstyring-meny`, eller bare gjenbruke `tilgangsstyring-meny` og bytte ut sub-item?
  - **Decision** (2026-05-13): Lag en ny Unleash-flag for den nye sub-itemen.
  - **Rationale**: Lar oss aktivere ny vs. gammel UI uavhengig under utrulling, og gir et rent rollback-punkt hvis problemer dukker opp.
  - **Impact**: To flags totalt: `tilgangsstyring-meny` (parent — uendret) og ny `tilgangsstyring-applikasjoner` (sub-item-flagg, navn TBD i bat-plan). Krever endring i `src/common/types/generated/unleash.ts` via `npm run generate:unleash` etter at flagget er konfigurert i Unleash-portalen.

- [x] **"Ansvarlig arver passordbytte-rett" (K18 + K5)**: skal denne arven modelleres som en utvidet `handlinger`-sjekk på backend (ansvarlig-relasjonen gir handlingen), eller skal frontend regne det ut ved å sammenligne `minBruker.id` med `applikasjon.ansvarlig.id`?
  - **Decision** (2026-05-13): Backend håndterer all rolle- og handlings-evaluering. Frontend leser bare ferdig-evaluerte permission-flagg.
  - **Rationale**: Single source of truth for autorisasjon. Frontend ID-sammenligning ville duplisert backend-logikken og åpnet for divergens.
  - **Impact**: GraphQL-applikasjons-typen må eksponere brukerens *evaluerte* rettigheter for *denne* applikasjonen — f.eks. et `handlinger: [String!]!`-felt på `Applikasjon` (skopet til innlogget bruker), eller eksplisitte boolean-flagg som `kanEndrePassord`, `kanAdministrereAnsvarlig`, `kanRedigereBeskrivelse`, `kanTildelteTilganger`, `kanFjerneTilganger`, `kanDeaktivere`. bat-plan vurderer hvilket mønster som passer best.

- [x] **K11/K12 cross-org-synlighet**: visningsregelen "applikasjonsadministrator ser også applikasjoner med tilganger i egne organisasjoner" krever at GraphQL-listen returnerer applikasjoner fra _fremmede_ organisasjoner under visse betingelser. Hvordan eksponerer den nye schema-en dette — filter-input, eller implisitt i autorisasjon?
  - **Decision** (2026-05-13): Implisitt i autorisasjons-konteksten på backend. Frontend sender ingen synlighets-parameter.
  - **Rationale**: Konsistent med Q5 — backend eier autorisasjons-modellen end-to-end. Frontend kaller `applikasjoner(filter, paging)` og får tilbake settet brukeren har rett til å se.
  - **Impact**: `ApplikasjonerFilter`-input-typen begrenses til *brukerstyrt* filtrering (fritekst-søk, organisasjon, tilgang, status). Ingen "rolle"- eller "synlighets"-felt. Sortering på navn ASC/DESC + paginering `first/after`.

- [x] **Bulk-input-form for fjerning av tilganger (K14)**: forventes en `removeTilganger(applikasjonId, miljø, tilgangIds: [ID!])`-mutasjon (én call, flere tilganger), eller flere parallelle enkelt-fjerninger? Optimistic UI vs. atomic-commit-grensen ligger her.
  - **Decision** (2026-05-13): Én atomisk bulk-mutasjon med flere `tilgangIds`. Apollo `optimisticResponse` for umiddelbar UI-respons.
  - **Rationale**: Krav-scenariet "Bekrefte bulk-fjerning" beskriver en enkel bekreftelses-dialog → enkel commit av alle valgte; det matcher en atomisk operasjon. Optimistic UI gir umiddelbar tilbakemelding uten å vente på server.
  - **Impact**: GraphQL trenger én mutation av formen `fjernTilganger(applikasjonId: ID!, miljø: Miljø!, tilgangIds: [ID!]!): Applikasjon`. Frontend bruker `useMutation` med `optimisticResponse` som fjerner radene fra cache umiddelbart, og rollback ved feil. Tilsvarende kan vurderes for `tildelTilganger` (bulk-tildeling i ett miljø).

- [x] **Reaktivering bevarer "alle tidligere tilganger"**: hvis en applikasjon ble deaktivert i state X, og senere reaktiveres — bevares tilgangene som var aktive ved deaktivering, eller hele tilgangshistorikken? Krav-teksten sier "tidligere tilganger gjelder igjen" som er flertydig.
  - **Decision** (2026-05-13): Tilganger fjernes ikke ved deaktivering. Datamodellen har ingen "snapshot"; det er kun en status-flagg på applikasjonen.
  - **Rationale**: Forenkler både backend og frontend — deaktivering = `status: INAKTIV`, reaktivering = `status: AKTIV`. Tilgangs-tabellen er uberørt.
  - **Impact**: Applikasjons-typen får et `status: ApplikasjonStatus`-felt (`AKTIV | INAKTIV`). Mutasjonene `deaktiverApplikasjon` og `reaktiverApplikasjon` flipper bare statusen. Ingen separat audit-tabell for "tilganger ved deaktivering". Tilgangs-tab kan vises uendret når applikasjonen er deaktivert; UI markerer applikasjonen som inaktiv på topp-nivå.

- [x] **Tilgangs-tab paginering 50 om gangen (Iter 2 vise_tilganger)**: krav-filen sier "applikasjonen har flere enn 50 tilganger" som scenario-forutsetning. Realistisk antall — er dette en typisk applikasjon eller et edge-case? Påvirker UX-valg (load-more vs. virtualisering).
  - **Decision** (2026-05-13): Bygg "load more"-paginering, ikke virtualisering. Mange applikasjoner har < 50; noen > 50, men antallet er ikke høyt nok til å rettferdiggjøre virtualisering-kompleksitet.
  - **Rationale**: Konsistent med hoved-listens paginering. Virtualisering ville krevd custom-scroll-håndtering og bryter med Sikt-DS-tabell-mønsteret.
  - **Impact**: Tilgangs-tab bruker samme Apollo `useQuery` med `first: 50` og en "Last inn flere"-knapp som lister-siden. Cache-merging via Apollo `TypePolicies` for connection-paginering.

- [x] **Sub-issue-detaljer (#438–#451)**: hvert `.feature`-fil peker på 1–3 granulære sub-issues under #434/#435. Disse er ikke hentet i denne analysen — er det fakta som ligger i de granulære issue-bodies som ville påvirket planen, eller er all spec-detalj i Gherkin-filene?
  - **Decision** (2026-05-13): Sub-issue-bodies inneholder ikke krav. All spec-detalj ligger i `.feature`-filene.
  - **Rationale**: Sub-issues fungerer som trackere/ID-er, ikke som spec-dokumenter. `# GitHub:`-markøren i hver Gherkin-fil peker tilbake til trackeren, ikke en utvidet beskrivelse.
  - **Impact**: bat-plan trenger ikke å hente flere issue-bodies. Krav-input på `fruitbat`-branchen er komplett.
