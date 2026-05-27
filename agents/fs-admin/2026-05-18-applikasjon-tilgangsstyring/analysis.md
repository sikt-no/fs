# Analysis: Applikasjon-tilgangsstyring (Iter 2 + 3 + Nice to have)

> **Scope:** sub-issues [#434](https://github.com/sikt-no/fs/issues/434) (Iter 2 — support: oversikt + passordbytte), [#435](https://github.com/sikt-no/fs/issues/435) (Iter 3 — grunnleggende tilgangsstyring), og [#437](https://github.com/sikt-no/fs/issues/437) (Nice to have — tilleggsfunksjonalitet), alle barn av initiativ [#31](https://github.com/sikt-no/fs/issues/31).
>
> **Read-only:** denne analysen er bevisst løsnings-fri (`bat-analyze`). Løsningsdesign hører hjemme i `bat-plan`.
>
> **Forrige analyse:** `fs-admin-mats` produserte en grundig analyse for #434 + #435 den 2026-05-13 (`agents/fs-admin-mats/2026-05-13-applikasjon-tilgangsstyring/analysis-v2.md` på `fruitbat`). Den ble brukt som kontekst, men alle fakta i denne analysen er verifisert mot dagens fs-admin-checkout og utvidet med #437. 10 av spørsmålene fra forrige runde er gjengitt som *Decisions inherited* nederst.

## Problem Statement

FS Admin har i dag en **POC** for å administrere maskinbrukere (API-brukere) som ligger under `src/domains/support/features/`. POC-en er aldri rullet ut i prod og er feature-flag-gated bak Unleash-flagget `tilgangsstyring-meny` ([`src/features/Header/Menu/Menu.tsx:85-92`](../../src/features/Header/Menu/Menu.tsx)).

Initiativ #31 erstatter denne POC-en med en **ny applikasjons-administrasjons-flate**. Initiativ-beskrivelsen er kompromissløs på tre punkter:

1. *"Vi lager en ny løsning tilgangsstyring av applikasjoner, vi bygger ikke i videre på dagens POC for visning av maskinbruker i FS Admin."*
2. *"Dagens løsning for maskinbruker i FS Admin er ikke innført og skal fjernes."*
3. *"Vi skal lage nye graphql spørringer for applikasjon. Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker."*

Det er altså en **rebuild**, ikke en utvidelse. Maskinbruker-koden (~3 000 LOC, ingen tester — verifisert via `wc -l src/domains/support/**/*.ts*` = 3 009) skal slettes.

De tre sub-issuene leverer:

- **Iter 2 (#434) — Support: lese-/lett-redigerings-flyt** for support-roller. 6 features (BRU-APP-API-001..-006): listevisning, detaljer, vise tilganger, passordbytte, administrere ansvarlig, redigere beskrivelse. Confluence-K-referanser: K1, K2, K3, K4, K5, K11, K12, K18, K19.
- **Iter 3 (#435) — Skrive-/livssyklus-flyt** for support. 4 features (BRU-APP-API-007..-010): tildele tilgang, fjerne tilgang, opprette applikasjon, deaktivere/reaktivere applikasjon. K-referanser: K6, K7, K8, K9, K13, K14.
- **Nice to have (#437) — Tilleggsfunksjonalitet**. 2 features, begge merket `@could @draft`: BRU-APP-API-015 sist-brukt-tidspunkt på detaljside (K15) og BRU-APP-API-017 masseadministrasjon av tilganger på tvers av applikasjoner (K17). **Disse er drafts** — `@draft`-taggen betyr at innholdet ikke er ferdig avklart i kravarbeidet ennå.

## Current State

### Maskinbruker-POC-en (det som skal fjernes)

Plassert under `src/domains/support/features/`, totalt **3 009 LOC** over ~30 komponenter. **Ingen tester** — verken `*.test.tsx` eller `*.a11y.test.tsx`. Dette bryter prosjektkravet "every component MUST have `ComponentName.a11y.test.tsx`" i CLAUDE.md.

**Listevisning** — [`src/domains/support/features/Maskinbrukere/Maskinbrukere.tsx`](../../src/domains/support/features/Maskinbrukere/Maskinbrukere.tsx):

- `ListPageLayout` + `ListPageActionbar` + `ListPageSidebar` + `ListPageContent` (importert fra `@/components/layouts/ListPageLayout` — som er en alias-tunnel til `@/common/components/layouts/...`).
- `MaskinbrukereFilter`, `MaskinbrukereResultList`, `FilterReset` fra `@/components/list-enhancers/FilterReset`.
- En `NyTilgangButton` i actionbar-en (men det er en knapp for å lage en *ny tilgang*, ikke en ny maskinbruker — pekes ut som litt forvirrende i POC-en).
- State-hook: [`useGetMaskinbrukereState`](../../src/domains/support/features/Maskinbrukere/hooks/useGetMaskinbrukereState.tsx) — sannsynligvis basert på `useDataListState` (URL-synced state).
- Data-hook: `useGetMaskinbrukere` (sender `context: { headers: { 'Feature-Flags': 'experimental' } }` mot SuperGraf-gateway-en).
- `useGetAllMaskinbrukere.ts` er allerede `@deprecated` med kommentaren "marked for removal".

**Detaljvisning** — [`src/domains/support/features/MaskinBruker/Maskinbruker.tsx`](../../src/domains/support/features/MaskinBruker/Maskinbruker.tsx):

- `DetailPageLayout` + `DetailPageTopBar` + `DetailPageTabbedContent` med **to tabs**: `DataTilganger` (database-ikon) og `ApiTilganger` (key-ikon).
- Hver tab har egne filter/sort/list-trios (`Api/DataTilgangerFilter`, `Api/DataTilgangerOrderBy`, `Api/DataTilgangerResultList`) og egen Zustand-style filter-store.
- **Passord-rotasjon**: [`MigrerPassord/MigrerPassordDialog.tsx`](../../src/domains/support/features/MaskinBruker/components/MigrerPassord/MigrerPassordDialog.tsx) implementerer **eksakt** K5-mønsteret — `Dialog` fra `@sikt/sds-dialog`, maskert visning (`••••••••••••••••`), `EyeIcon`-toggle, `ClipboardWrapper`, `GuidePanel variant="warning"`, generert serverside, vises kun mens dialogen er åpen.

**Domain-index** — [`src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`](../../src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx):

- `BasicPageLayout` + `BasicPageSection` + `Grid` + `Surface`-kort.
- Én navigasjons-kort som peker på `/tilgangsstyring/maskinbrukere`. Bruker `TilgangLogo`-SVG som dekor.

**Routes** — [`src/app/tilgangsstyring/`](../../src/app/tilgangsstyring/):

```
src/app/tilgangsstyring/
├── layout.tsx                                    # PageHeaderWrapper + breadcrumbTitle 'Tilgangsstyring'
├── page.tsx                                      # <TilgangsstyringIndex />
└── maskinbrukere/
    ├── layout.tsx
    ├── page.tsx                                  # <Maskinbrukere />
    └── [maskinbrukerid]/
        ├── layout.tsx
        └── page.tsx                              # <Maskinbruker id={…} />
```

**Menu-gating** — [`src/features/Header/Menu/Menu.tsx:82-99`](../../src/features/Header/Menu/Menu.tsx):

```ts
{
  href: '/tilgangsstyring',
  title: t('tilgangsstyring'),
  featureFlag: {
    flag: 'tilgangsstyring-meny',
    environmentsOverride: { inDevelopment: true, inReview: true, inTest: true },
  },
  subItems: [
    { href: '/tilgangsstyring/maskinbrukere', title: t('maskinbrukere') },
  ],
}
```

**i18n** — [`src/common/messages/nb/support.json`](../../src/common/messages/nb/support.json) (~133 linjer) inneholder alle `support.*Maskinbruker*`-namespaces, inkludert `support.MaskinbrukerMigrerPassordDialog` med rik tekst.

### Permission-modell (det som må utvides)

- **Hook**: [`src/common/lib/auth/useAdmissioUserActions.tsx`](../../src/common/lib/auth/useAdmissioUserActions.tsx) (med tunnel-eksport fra `src/lib/auth/useAdmissioUserActions.tsx`). Henter `minBruker { id, organisasjon { id }, handlinger }` og eksponerer `{ userActions, userId, organisationId }`.
- **Enum**: [`src/common/types/userActions.ts`](../../src/common/types/userActions.ts):

  ```ts
  export enum USER_ACTION {
    SE_UTDANNING, SE_SOKNADSBEHANDLING, SE_SOKNAD, SE_REGELVERK,
    SE_ORGANISASJONER, SE_OPPTAK,
    MODIFISERE_UTDANNING, MODIFISERE_SØKNAD, MODIFISERE_SOKNADSBEHANDLING,
    MODIFISERE_REGELVERK, MODIFISERE_ORGANISASJONER, MODIFISERE_OPPTAK,
  }
  ```

  **Ingen `applikasjonsadministrator`- eller `super-applikasjonsadministrator`-verdi.** Disse må legges til når backend leverer dem på `minBruker.handlinger`.

- `src/types/userActions.ts` er en `@deprecated`-tunnel som re-eksporterer fra `@/common/types/userActions` — så tunnel-importer fungerer fortsatt, men nye importer skal gå direkte.

### GraphQL-overflate (det som må erstattes)

- Skjema-kilde: `process.env.GRAPHQL_SCHEMA_LOCATION || 'https://supergraf-gateway-test.fsweb.no/graphql'` ([`codegen.ts:8`](../../codegen.ts)).
- Genererte artefakter: `src/__generated__/{graphql.ts,gql.ts,possibleTypes.json}` + `schema.graphql`.
- Codegen-glob plukker opp `gql(...)` i `src/**/!(*.d).{ts,tsx}` (ekskl. `__generated__`, `types`, tester) — så nye inline `gql()` plukkes opp uten config-endring.
- Scalar-mappinger: `BigDecimal/Long → number`, `LocalDate/Date/DateTime/Time/Duration → string`.
- `fragmentMasking: false`, `inlineFragmentTypes: 'mask'`, `nonOptionalTypename: true` — data-masking håndteres av Apollo i runtime, ikke via codegen.
- Maskinbruker-typer brukt i POC-en (`Maskinbruker`, `ApiTilgangsrolle`, `DatatilgangForMaskinbruker`, `ApiTilgangForMaskinbrukerV2`, query `maskinbrukere(first, after, filter)` → connection) lever i SuperGraf-skjemaet og må fases ut sammen med fs-admin-fjerningen.

### Gjenbrukbare mønstre i dagens kodebase

| Behov i krav | Gjenbrukbart mønster i fs-admin | Konfidens |
|---|---|---|
| Listevisning med filter/sort/paginering | `ListPageLayout` + `useDataListState` + `useDataListQuery` (CLAUDE.md i `src/common/hooks/useDataListState/` og `src/common/components/layouts/ListPageLayout/`) | 95/100 (LIST) |
| Detaljside med tabs | `DetailPageLayout` + `DetailPageTopBar` + `DetailPageTabbedContent` | 95/100 (DETAIL) |
| Maskert ett-gangs-passord | `MigrerPassordDialog` (lift verbatim — UX-mønsteret er identisk for K5) | 100/100 |
| Bekreftelses-dialog for destruktive handlinger | Sds `Dialog` + `Button` (POC bruker dette uten en egen `ButtonWithConfirmation`-wrapper i denne checkouten — se Notes) | — |
| Kopier-til-utklippstavle | `@/components/ClipboardWrapper/ClipboardWrapper` | — |
| Filter-state-persistens | `useDataListState` (URL-synced via `nuqs`) — ikke Zustand som POC-en faktisk bruker | — |
| Permission-gating | `useAdmissioUserActions` + `USER_ACTION[]` per menu-item | — |
| Master-detail navigasjons-state | URL-state via `useDataListState` + `NavigationListItem` med `href`; back-button bevarer filter automatisk (cross-pattern `list-page-layout--detail-page-layout.md`) | — |
| Domain-index | `BasicPageLayout` + `Surface`-kort + `ButtonLink` (eksisterer som `TilgangsstyringIndex` — kan utvides til å lenke til ny applikasjoner-rute i tillegg eller i stedet for maskinbrukere) | — |

### Pattern-detection (via `bat-fs-admin-patterns`)

Resultatet av pattern-scoring mot kravene:

- **ListPageLayout (applikasjon-listevisning)** — *Egenskap: Listevisning og søk i applikasjoner* har `oversikt over applikasjoner` + `filter` + `søk` + `sortering` + `paginering 50` → **≥95/100, POSITIV**.
- **DetailPageLayout (applikasjon-detaljside)** — *Egenskap: Se detaljer for applikasjon* + tab for tilganger + edit-handlinger (rediger beskrivelse, sette ansvarlig, passord) → **≥95/100, POSITIV**.
- **Cross-pattern `list-page-layout--detail-page-layout`** matcher: master-detail-flyt med back-navigasjon. Referanse-implementasjon: **EmnerOverview ↔ EmneDetails** under `src/domains/utdanning/features/`. URL-state via `useDataListState` er den korrekte tilnærmingen — POC-en bruker Zustand som er feil mønster og skal *ikke* gjenbrukes.
- **DomainIndexPattern** — `TilgangsstyringIndex` finnes allerede; ikke noe nytt domain-index. Eksisterende komponent oppdateres til å peke på applikasjoner-ruten (i tillegg til eller i stedet for maskinbrukere).
- **Form/modal-mønster for "Opprett applikasjon"** — ikke en av de tre katalog-mønstrene. `opprette_applikasjon.design.md` på fruitbat har detaljert UX-spec: Sds `Dialog`, åpnes fra `ActionButtons`-slot i `ListPageLayout`, naviger til detaljside ved suksess.

## Key Findings

1. **POC-en har riktig *shape* men feil *contract*.** Nesten alle UI-primitiver kravene trenger — listing med filter/sort/paginering, detalj med tabs, masked passord-dialog — eksisterer. Forskjellen ligger på data-laget (ny GraphQL-overflate, nye permission-koder, ny domene-navngiving).

2. **POC-fjerning er en ren mekanisk diff.** 3 009 LOC uten tester, kun feature-flag-gated, aldri i prod — kan slettes uten test-backfill. Den tunge jobben er å skrive ny kode, ikke å fjerne gammel.

3. **`useDataListState` (URL-state) er det rette mønsteret — ikke POC-ens Zustand-stores.** Cross-pattern-guiden er eksplisitt: filter, sort, paginering skal være URL-state. Det gir gratis back-button-bevaring (cross-pattern §"State Preservation Deep Dive"). Skal ikke gjenbruke `useMaskinbrukerApiTilgangerFilterStore`-mønsteret i ny kode.

4. **`MigrerPassordDialog` (K5-mønsteret) er produkstreft.** Maskert visning + eye-toggle + Clipboard + GuidePanel warning + ett-gangs visning. UX-bidraget kan løftes verbatim inn i nye `Applikasjon/components/PassordbytteDialog/`. Behavior-kontrakten — "kan ikke hentes opp igjen etter at dialogen er lukket" — er allerede implementert.

5. **Tre-akse synlighetsmodell er ny.** K11/K12 + ansvarlig-relasjonen krever at GraphQL-listen returnerer applikasjoner basert på tre orthogonale aksene:
   - Rolle (`super-applikasjonsadministrator` → alle / `applikasjonsadministrator` → egne organisasjoner).
   - Tilgangs-relasjon (admin i org X ser også applikasjoner som *ikke tilhører* X men har tilganger som *gjelder* X — krever cross-org-join).
   - Ansvarlig-relasjon (feide-bruker/-gruppe registrert som ansvarlig ser applikasjonen).
   Dagens flate `handlinger`-liste på `minBruker` dekker ikke dette. Backend må enten utvide til organisasjons-skopa handlinger eller eksponere per-applikasjon-evaluerte permissions.

6. **Identitetsleverandør-konseptet er nytt i fs-admin-domenet.** K8 forutsetter at backend verifiserer Feide-ID/Maskinporten-ID mot kilden ved opprettelse, henter visningsnavn fra idP-en, og avviser duplikater. FS er utfaset for nye applikasjoner; eksisterende FS-applikasjoner består som legacy data — alle administrasjonshandlinger gjelder også for dem, kun opprettelse er stengt (presiseringen er ny i commit `b9f2e4e` på `fruitbat`, jf. `iter2_og_3_oversikt.md` Regel "Listen inkluderer eksisterende FS-applikasjoner" og scenariet "Tildele tilgang til en eksisterende FS-applikasjon").

7. **Bulk-fjerning av tilganger (K14)** er en bulk-mutasjon uten eksisterende parallell i fs-admin. Den naturlige formen — én atomic call med `tilgangIds: [ID!]!` + optimistic UI — er besluttet (Q7 i `analysis-v2.md`). Tildelt parallell `tildelTilganger`-bulk er også mulig.

8. **Globalt unikt visningsnavn (K8)** håndheves av backend, ikke fs-admin. Feilen kommer som en valideringsfeil ved `opprettApplikasjon`-mutasjonen — `opprette_applikasjon.design.md` plasserer feilteksten på toppen av dialogen ("Visningsnavnet «{navn}» er allerede i bruk") fordi visningsnavnet ikke er et brukerredigerbart felt.

9. **Reversibel deaktivering (K9)** modelleres som en `ApplikasjonStatus`-flagg (`AKTIV | INAKTIV`) på applikasjonen (Q8 i `analysis-v2.md`). Tilganger fjernes ikke ved deaktivering, og reaktivering flipper bare statusen. Selve håndhevelsen av "ikke autentiseringen virker når status=INAKTIV" er backend-ansvar.

10. **Nice to have #437 (BRU-APP-API-015 + -017) er `@draft`.** Filene er korte (13 og 19 linjer) og merket både `@could` (kan ha) og `@draft` (kravarbeidet er ikke ferdigstilt). Dette betyr at:
    - BRU-APP-API-015 "Sist brukt tidspunkt" — kun ett scenario som forutsetter at backend leverer feltet `sistBrukt: DateTime` på applikasjonen. Lavt frontend-bidrag (~1 readonly-felt på detaljside) hvis backend leverer.
    - BRU-APP-API-017 "Masseadministrasjon av tilganger" — to scenarier på en *oversikts-side over tilganger* (ikke applikasjoner), som er en *helt ny* UI-flate utenfor de eksisterende mønstrene. Krever en ny side `/tilgangsstyring/tilganger` med liste over tilganger og bulk-tildel/-fjern på tvers av applikasjoner. **Dette er ikke trivielt** og bør være ut av scope inntil draft-en er ferdigstilt.

11. **Eksisterende `NyTilgangButton`-komponent under `src/domains/support/features/components/NyTilgangButton/`** virker som POC-relikvi. Navnet er forvirrende ("Ny tilgang") — den ligger i listevisningens actionbar men logikken bak er uklar. Den må enten slettes som del av POC-fjerningen eller refaktoreres til en konkret "Opprett applikasjon"-knapp jf. `opprette_applikasjon.design.md`.

12. **`TilgangsstyringIndex` er det eneste eksisterende landings-elementet og kan utvides i stedet for å lages på nytt.** Den har allerede `BasicPageLayout` + `Surface`-kort + ett `ButtonLink`-kort til `/tilgangsstyring/maskinbrukere`. Erstatt eller utvid med kort til `/tilgangsstyring/applikasjoner` jf. utfasings-strategien (Q2 i `analysis-v2.md`).

## Technical Constraints

### Fra prosjekt-CLAUDE.md

- **Next.js 16 App Router** med Webpack-bundler. Nye sider plasseres som `src/app/<rute>/page.tsx`.
- **Apollo Client 4** + GraphQL codegen. Fragment masking *off* (`fragmentMasking: false`, `inlineFragmentTypes: 'mask'`). Codegen-glob plukker opp nye inline `gql()` automatisk.
- **GraphQL-query-plassering**: "closely related to components they're used in" og **ikke** gjenbrukes på tvers. Flytt til feature-level `queries.ts` kun når både server- og klient-komponent trenger samme query.
- **A11y-test påkrevd**: hver komponent må ha `ComponentName.a11y.test.tsx`. Nye applikasjon-komponenter må oppfylle dette fra første commit (POC-en gjør ikke det og blir uansett slettet).
- **CSS Modules + Sikt Design System** (`@sikt/sds-*`). Ingen generiske UI-biblioteker.
- **Norsk forretningsdomene, engelsk kode**. `PascalCase` for komponenter, `camelCase` for variabler/mapper.
- **Conventional commits** + ren git-historie. Conventional-commit-validering via commitlint.
- **i18n**: meldingsfiler i `src/common/messages/nb/` — for support-domenet er det `support.json` (allerede én sentral fil for hele domenet, *ikke* per-feature filer som CLAUDE.md sin generelle veiledning antyder).

### Fra krav-input på `fruitbat`

- **Én idP per applikasjon, låst ved opprettelse** (Feide eller Maskinporten). FS er ikke valgbar for nye.
- **Eksisterende FS-applikasjoner forvaltes i samme oversikt** — listevisning, tilgangsstyring, passordbytte, ansvarlig, beskrivelse, deaktivering gjelder også for dem (presisert i `iter2_og_3_oversikt.md` Regel "Synlighet via tilgang til FS-applikasjoner").
- **Passord-modell**: basic auth, ett aktivt passord om gangen, systemgenerert, vises én gang.
- **Bulk-operasjoner krever bekreftelses-dialog** med liste over berørte tilganger + miljø.
- **Ansvarlig-søk** er begrenset til applikasjonens egen organisasjon. Ansvarlig kan være feide-bruker (must) eller feide-gruppe (`@could`).
- **Visningsnavn må være globalt unikt** på tvers av alle organisasjoner — backend håndhever.
- **Paginering 50 om gangen** for listevisning og tilganger-tab. "Last inn flere"-knapp, ikke virtualisering (Q9 i `analysis-v2.md`).
- **Cross-org synlighet (K11/K12)** håndteres implisitt i autorisasjon (Q6) — frontend sender ingen synlighets-parameter.

### Plattform

- **Feide OIDC** via NextAuth.js for alle brukerkontekster, inkl. ansvarlig-oppslag.
- **SuperGraf-gateway** (`supergraf-gateway-test.fsweb.no/graphql` i test) er eneste GraphQL-endepunkt. Alle nye applikasjon-operasjoner må eksponeres derfra.
- **Unleash feature-flags** — nytt flagg `tilgangsstyring-applikasjoner` (eller tilsvarende) skal styre ny UI separat fra parent-flagget `tilgangsstyring-meny` (Q4 i `analysis-v2.md`).

## Dependencies

### Internal (fs-admin)

| Avhengighet | Hva som påvirkes |
|---|---|
| [`src/__generated__/*`](../../src/__generated__/) | Codegen kjøres på nytt mot oppdatert SuperGraf-schema med applikasjon-typer. Maskinbruker-typer forsvinner i samme runde. |
| [`src/common/types/userActions.ts`](../../src/common/types/userActions.ts) | Nye `USER_ACTION`-verdier for `APPLIKASJONSADMINISTRATOR` / `SUPER_APPLIKASJONSADMINISTRATOR` (eller tilsvarende navnvalg) — eller per-applikasjon-permissions-mønster (Q5). |
| [`src/features/Header/Menu/Menu.tsx`](../../src/features/Header/Menu/Menu.tsx) (linjer 82-99) | Legg til sub-item `/tilgangsstyring/applikasjoner` med nytt featureFlag. Maskinbrukere-sub-item fjernes når POC-en avvikles. |
| [`src/app/tilgangsstyring/`](../../src/app/tilgangsstyring/) | Nye routes: `/applikasjoner/page.tsx`, `/applikasjoner/[applikasjonId]/page.tsx` + `layout.tsx`. Eksisterende `/maskinbrukere/*` slettes i samme PR eller en oppfølgings-PR. |
| [`src/domains/support/features/TilgangsstyringIndex/`](../../src/domains/support/features/TilgangsstyringIndex/) | Oppdater `TilgangsstyringIndex.tsx` til å peke på applikasjoner-ruten (sannsynligvis i tillegg til maskinbrukere mens begge eksisterer; så bare applikasjoner). i18n-nøkler `maskinbrukereDescription`/`maskinbrukereLabel` erstattes med `applikasjonerDescription`/`applikasjonerLabel`. |
| [`src/common/messages/nb/support.json`](../../src/common/messages/nb/support.json) | Nye namespaces: `support.Applikasjoner` (listevisning), `support.Applikasjon` (detalj), `support.ApplikasjonPassord`, `support.ApplikasjonAnsvarlig`, `support.ApplikasjonOpprett`, osv. Gamle `support.Maskinbruker*`-namespaces avvikles. |
| [`src/domains/support/features/Maskinbrukere/`](../../src/domains/support/features/Maskinbrukere/), [`MaskinBruker/`](../../src/domains/support/features/MaskinBruker/) (3 009 LOC) | Slettes som del av POC-fjerningen. Tidspunkt: når ny Unleash-flag er aktiv i prod (Q2). |
| [`src/domains/support/features/components/NyTilgangButton/`](../../src/domains/support/features/components/NyTilgangButton/) | Slettes eller erstattes med en konkret `OpprettApplikasjonButton` jf. `opprette_applikasjon.design.md`. |
| [`src/common/lib/auth/useAdmissioUserActions.tsx`](../../src/common/lib/auth/useAdmissioUserActions.tsx) | Ingen kode-endring nødvendig her, men avhenger av at backend leverer nye verdier i `minBruker.handlinger`. |
| `src/common/types/generated/unleash.ts` | Regenereres via `npm run generate:unleash` etter at nytt flagg `tilgangsstyring-applikasjoner` er opprettet i Unleash-portalen. |

### External

- **Sikt Design System** (`@sikt/sds-button`, `@sikt/sds-dialog`, `@sikt/sds-core`, `@sikt/sds-icons`, `@sikt/sds-message`) — alle komponenter eksisterer allerede i bruk.
- **Apollo Client 4** — `useQuery`, `useMutation`, `useSuspenseQuery`. Optimistic-response på bulk-mutasjoner (Q7).
- **NextAuth.js / Feide OIDC** — for ansvarlig-oppslag og innlogget bruker-id (Q5 forutsetter at backend gjør all autorisasjon, men frontend må sende session-token uansett).
- **Maskinporten** — ekstern avhengighet for *backend* (ID-verifikasjon). Fs-admin ser dette kun gjennom GraphQL feilmeldinger.
- **`nuqs`-bibliotek** — brukes av `useDataListState` for URL-state. Allerede en avhengighet, ingen ny installasjon.
- **Confluence-side `4401102853`** (Rammeinnsikt: "Grunnleggende selvbetjent administrasjon av API-brukere") — referert i Gherkin-bakgrunns-tekst. Kontekst, ikke direkte avhengighet.

### Cross-agent (kandidat-handoffs — ikke filed fra denne analysen)

> Per `bat-analyze` er disse **kandidater**. `bat-plan` revisiterer dem etter at plan finnes og kan da invoke `agent-coord` med konkret kontekst (GraphQL-skisse, antall tasks, tidspunkter). Selve hand-off-filing skjer ikke her.
>
> Merk: forrige `bat-plan`-runde fra `fs-admin-mats` filte et hand-off-issue `sikt-no/fs#455` som senere ble retired (lukket 2026-05-13 av brukeren, "POC hand-off, not live work" — se `agents/fs-admin-mats/memory.md`-entry 2026-05-13T08:21Z). Ny hand-off må derfor opprettes på nytt fra `bat-plan`, ikke gjenåpne #455.

1. **Backend / SuperGraf-schema-agent** (registrert som `backend` i `agents/backend/AGENT.md`, men ingen reell aktivitet utover bootstrap-entry per 2026-05-18).
   - *Hva trengs*: Ny GraphQL-overflate. Type `Applikasjon` med felter (id, navn, beskrivelse, organisasjon, identitetsleverandør: `FEIDE|MASKINPORTEN|FS`, status: `AKTIV|INAKTIV`, ansvarlig, miljøer, opprettet/endret-sporing, evaluerte per-bruker-rettigheter). Query `applikasjoner(filter, first, after)` → connection (fritekst-søk, organisasjon, tilgang, status). Mutasjoner: `opprettApplikasjon`, `byttApplikasjonPassord`, `settApplikasjonAnsvarlig`, `redigerApplikasjonBeskrivelse`, `tildelApplikasjonTilganger` (bulk), `fjernApplikasjonTilganger` (bulk), `deaktiverApplikasjon`, `reaktiverApplikasjon`. Filter-input begrenset til *brukerstyrt* filtrering (Q6 — ingen "rolle"- eller "synlighets"-felt).
   - *Hvorfor blokkerer*: Initiativ-bestillingen forbyr gjenbruk av maskinbruker-queries. Fs-admin kan ikke starte før schema-kontrakten er definert. Selvfølgelig kan en mock-fase parallelliseres via `bat-fs-mock-api-with-data`-skillen.

2. **Identitets-/Feide-/Maskinporten-agent** (ikke registrert per dagens dato — kan måtte opprettes eller løses inn under `backend`-paraplyen).
   - *Hva trengs*: Backend-tjeneste for å verifisere Feide-ID og Maskinporten-ID mot kilden ved opprettelse av applikasjon. Hente visningsnavn fra idP-en. Avvise duplikat-ID-er. Også Feide-gruppe-oppslag for ansvarlig (`@could`-scenarier i `administrere_ansvarlig.feature`).
   - *Hvorfor blokkerer*: K8 scenariomalene ("Opprette applikasjon med ekstern identitet" / "Opprettelse avvises når ID ikke finnes hos kilden") fungerer ikke uten idP-verifikasjon.

3. **Autorisasjons-/handlinger-agent** (kan være samme som backend).
   - *Hva trengs*: Nye handlings-verdier på `minBruker.handlinger` for applikasjonsadministrator-rollene, eller per-applikasjon-evaluerte rettigheter på `Applikasjon`-typen (Q5 konkluderer med sistnevnte: `kanEndrePassord`, `kanAdministrereAnsvarlig`, `kanRedigereBeskrivelse`, `kanTildelteTilganger`, `kanFjerneTilganger`, `kanDeaktivere`). `bat-plan` bestemmer endelig mønster.
   - *Hvorfor blokkerer*: UI-gating (Menu, listevisning, detalj, mutasjonsknapper) krever de nye permissions før komponentene kan skjule/vise riktig.

4. **POC-fjernings-koordinering med SuperGraf-eier** (kan slås sammen med #1). Fjerne `maskinbrukere`-feltet og tilhørende typer fra schema. Krever et kort utfasings-vindu der gammel + ny eksisterer (Q2 utfasing-side-om-side).

## Requirements Impact

Det finnes ingen `docs/ACTIVE/requirements-*.md`-fil i denne fs-admin-checkouten. Kravene leveres som Gherkin `.feature`-filer + `systemkrav.md` på `fruitbat`-branchen i `sikt-no/fs`. Snapshot er lagret under [`docs/ACTIVE/krav-input/`](krav-input/manifest.md).

Kravsett oppsummert per feature-ID:

| Feature-ID | Egenskap | Iter | Prioritet | GitHub |
|---|---|---|---|---|
| BRU-APP-API-001 | Listevisning og søk | 2 | @must @planned | #438, #448, #449 |
| BRU-APP-API-002 | Se detaljer | 2 | @must @planned | #439 |
| BRU-APP-API-003 | Vise tilganger | 2 | @must @planned | #440 |
| BRU-APP-API-004 | Passordbytte | 2 | @must @planned | #441 |
| BRU-APP-API-005 | Administrere ansvarlig | 2 | @must @planned | #442 |
| BRU-APP-API-006 | Redigere beskrivelse | 2 | @must @planned | #443 |
| BRU-APP-API-007 | Tildele tilgang | 3 | @must @planned | #444, #450 |
| BRU-APP-API-008 | Fjerne tilgang | 3 | @must @planned | #445, #451 |
| BRU-APP-API-009 | Opprette applikasjon | 3 | @must @planned | #446 |
| BRU-APP-API-010 | Deaktivere applikasjon | 3 | @must @planned | #447 |
| BRU-APP-API-015 | Sist brukt tidspunkt | Nice | @could @draft | #452 |
| BRU-APP-API-017 | Masseadministrasjon tilganger | Nice | @could @draft | #454 |

Confluence-K-referanser bevart: K1, K2, K3, K4, K5, K6, K7, K8, K9, K11, K12, K13, K14, K15, K17, K18, K19. K10 (permanent sletting) er bevisst utelatt — deaktivering er sluttilstanden.

## Krav-input fra GitHub

- **Kilde-issue(s)**: [#434](https://github.com/sikt-no/fs/issues/434) (Iter 2 — `@must @planned`), [#435](https://github.com/sikt-no/fs/issues/435) (Iter 3 — `@must @planned`), [#437](https://github.com/sikt-no/fs/issues/437) (Nice to have — `@could @draft`). Alle barn av paraply [#31](https://github.com/sikt-no/fs/issues/31).
- **Repo / branch**: `sikt-no/fs` @ [`fruitbat`](https://github.com/sikt-no/fs/tree/fruitbat). Branch hentet fra `linkedBranches` på paraply-issue #31 (sub-issuene har ingen egne `linkedBranches`). Brukerbekreftet at branchen heter `fruitbat`.
- **Hentede `.feature`-filer**: se [`docs/ACTIVE/krav-input/manifest.md`](krav-input/manifest.md) for full liste (12 `.feature` + 2 `systemkrav.md` + 1 design.md + 1 aggregert oversikt + 8 tilstøtende agents/shared-filer).
- **Hentet**: 2026-05-18

## Open Questions

Nye spørsmål fra denne analysen (alle krever brukeravklaring før `bat-plan`):

- [ ] **#437 i scope = ja, men begge features er `@draft`.** Skal `bat-plan` likevel produsere en plan for dem, eller vente til kravarbeidet er `@planned`? `BRU-APP-API-015` (sist brukt tidspunkt) er trivielt på frontend-siden (1 readonly-felt) hvis backend leverer; `BRU-APP-API-017` (masseadministrasjon på tvers av applikasjoner) krever en helt ny `/tilgangsstyring/tilganger`-rute uten eksisterende analog og er en betydelig utvidelse.
- [ ] **POC-fjerning og utfasing.** Q2 i forrige runde besluttet side-om-side under separate feature-flags inntil Iter 3 er ute. Konsekvens: Iter 2-deploy beholder maskinbruker-koden urørt, og en rydde-PR slettes POC-koden når nytt flagg er aktivert i prod. Bekreft at den strategien fortsatt gjelder (særlig hvis fjerning-PR-en skal være del av Iter 2-leveransen).
- [ ] **`NyTilgangButton`-eksisterende komponent** under POC — slettes eller forblir under utfasings-perioden? Hvis den henger igjen, kan navnet være forvirrende ved siden av ny `OpprettApplikasjonButton`.
- [ ] **Permission-modell — `USER_ACTION`-enum vs per-applikasjon-rettigheter.** Q5 fra forrige runde lente seg mot per-applikasjon `kanEndrePassord` osv. på selve `Applikasjon`-typen. Skal vi *også* utvide `USER_ACTION`-enum for menu-/route-level gating (top-level "har brukeren applikasjonsadministrator i det hele tatt"), eller gates det utelukkende på det nye Unleash-flagget? `bat-plan` trenger dette for å skissere riktig nøyaktig permission-modell.
- [ ] **Backend-agentens status.** `agents/backend/memory.md` har kun bootstrap-entry per 2026-05-02. Er det noen reell backend-agent som tar imot hand-offs nå, eller må vi gjøre det via humans?

Decisions inherited (besvart i `analysis-v2.md` 2026-05-13 av samme bruker — bekreft at de fortsatt gjelder):

- [x] **Q1: Eksisterende FS-applikasjoner forvaltes i ny UI, kan ikke opprettes.** Krav-tekstene oppdatert i commit `b9f2e4e` på `fruitbat` for å tydeliggjøre dette.
- [x] **Q2: Side-om-side under feature-flag-kontroll.** Ingen big-bang ved Iter 2-deploy.
- [x] **Q3: POC-fjerning er trygt uten test-backfill.** POC har ingen tester og er aldri rullet ut.
- [x] **Q4: Ny Unleash-flag for sub-itemen** (`tilgangsstyring-applikasjoner` eller tilsvarende), beholder `tilgangsstyring-meny` som parent.
- [x] **Q5: Backend eier all autorisasjon end-to-end.** Frontend leser ferdig-evaluerte per-applikasjon-rettigheter.
- [x] **Q6: Cross-org-synlighet (K11/K12) er implisitt i backend-autorisasjon.** Frontend sender ingen synlighets-parameter.
- [x] **Q7: Én atomic bulk-mutasjon for fjern (og evt. tildel) tilganger.** Apollo `optimisticResponse` for UI-respons.
- [x] **Q8: Deaktivering = `ApplikasjonStatus`-flagg.** Ingen tilgangs-snapshot; tilganger uberørte ved deaktivering.
- [x] **Q9: "Last inn flere"-paginering, ikke virtualisering** for tilgangs-tab.
- [x] **Q10: All spec-detalj ligger i `.feature`-filene** — sub-issue-bodies (#438–#451, #452, #454) inneholder ingen ekstra krav.

## Notes

- **CLAUDE.md-paths**: Prosjekt-CLAUDE.md beskriver layout som `src/features/<domain>/` mens den faktiske koden ligger under `src/domains/<domain>/features/`. Dette er en kjent inkonsistens — `src/domains/` er den nyere strukturen og er kanonisk for nye features. `src/features/` brukes for *cross-cutting* features som `Header/`, `Authentication/`, osv.
- **Alias-tunneler**: Mange importer i POC-en bruker `@/components/layouts/...` som er tunnel-eksporter til `@/common/components/layouts/...`. Nye filer bør bruke den direkte `@/common/`-stien for å unngå avhengighet til deprecation-tunneler.
- **`useDataListState` / `useDataListQuery`** finnes på to plasser: `src/common/hooks/...` (kanonisk) og `src/hooks/dataList/...` (sannsynligvis tunnel). Verifiser ved implementering at canoncial er `src/common/hooks/`.
- **Mock-API-skillen** (`bat-fs-mock-api-with-data`) er en mulig fast-path for å starte fs-admin-arbeidet før backend leverer schema. `bat-plan` kan vurdere om mock-fasen er verdt det.
