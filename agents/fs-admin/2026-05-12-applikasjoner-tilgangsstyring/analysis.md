# Analysis: Selvbetjent tilgangsstyring for applikasjoner

**Initiativ:** [`sikt-no/fs#31`](https://github.com/sikt-no/fs/issues/31) — Grunnleggende selvbetjent tilgangsstyring for applikasjoner via FS Admin
**Krav-branch:** `fruitbat` (i `sikt-no/fs`)
**Scope:** Initiativ + alle sub-issues (#434 Iter 2, #435 Iter 3, #437 Nice-to-have) — pluss Iter 4 som ligger på branchen uten egen sub-issue

## Problem Statement

Applikasjonsadministratorer ved læresteder og hos Sikt mangler i dag en effektiv, selvbetjent måte å forvalte applikasjoner (tidligere kalt "API-brukere") som har tilgang til FS-data. Eksisterende verktøy (FS-klient og en POC for maskinbrukere i FS Admin) dekker ikke behovet for:

- **Lesetilgang** på tvers av organisasjoner for support og lokale administratorer.
- **Selvbetjent forvaltning** av applikasjoner — opprette, deaktivere, tildele/fjerne tilganger.
- **Sporbarhet** av endringer.
- **Avvikling** av FS som identitetsleverandør for nye applikasjoner (Feide/Maskinporten skal være eneste valg).

Initiativet leveres som **fire iterasjoner**, og krav-arbeidet er i sluttfasen — alle ikke-`@draft` features er `@planned` på `fruitbat`. Implementasjonsdetaljer i issue-body sier eksplisitt at vi **ikke skal bygge videre på dagens POC for maskinbrukere**, og at **nye GraphQL-spørringer skal lages — ikke gjenbruk av maskinbruker-spørringer**.

## Current State

### Eksisterende "POC" — Maskinbrukere

| Område | Fil(er) |
|---|---|
| **Routes** | `src/app/tilgangsstyring/maskinbrukere/page.tsx`, `src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/page.tsx`, `src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/layout.tsx`, `src/app/tilgangsstyring/maskinbrukere/layout.tsx` |
| **Listevisning feature** | `src/domains/support/features/Maskinbrukere/` — bruker `ListPageLayout`, har 4 filterkomponenter under `components/filter/`, OrderBy, ResultList, 5 hooks (inkl. `useGetMaskinbrukere` og 2 Zustand-stores) |
| **Detalj feature** | `src/domains/support/features/MaskinBruker/` — bruker `DetailPageLayout` med tabbed content, har `ApiTilganger/`, `DataTilganger/`, `MaskinbrukerInformation/`, `MigrerPassord/`, 3 hooks |
| **GraphQL-operasjoner** | `maskinbrukere` (liste), `maskinbrukerDetaljer` (detalj) — definert inline i hooks |
| **Tilgangsstyring landing** | `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx` (i dag kun med maskinbrukere-kort) |
| **CommandPalette** | `src/domains/search/features/CommandPalette/hooks/useCommands.tsx` (maskinbruker-kommando) |
| **Type-generert routes** | `src/common/types/generated/routes.d.ts` (`TilgangsstyringMaskinbrukereHref`, `TilgangsstyringMaskinbrukereMaskinbrukeridHref`) |
| **Navigasjon** | Header Menu, FSAdminIndex |

### Eksisterende mønstre i `src/common/`

| Building block | Sti |
|---|---|
| `ListPageLayout` | `src/common/components/layouts/ListPageLayout/CLAUDE.md` |
| `DetailPageLayout` (med `DetailPageTopBar`, `DetailPageTabbedContent`, `DetailPageTabbedContentPanel`) | `src/common/components/layouts/DetailPageLayout/CLAUDE.md` |
| `BasicPageLayout` | `src/common/components/layouts/BasicPageLayout/CLAUDE.md` |
| `NavigationList` / `ActionList` / `ExpandList` | `src/common/components/lists/*/CLAUDE.md` |
| `FilterWrapper` (list-enhancer) | `src/common/components/list-enhancers/FilterWrapper/CLAUDE.md` |
| `useDataListState` (URL-synket filter/sort/pagination via `nuqs`) | `src/common/hooks/useDataListState/CLAUDE.md` |
| `useDataListQuery` (GraphQL paginering integrert med state) | `src/common/hooks/useDataListQuery/CLAUDE.md` |

i18n-konvensjon: `src/common/messages/nb/<domene>.json` — for support-domenet er `support.json` allerede i bruk og er nettopp endret på denne branchen.

## Key Findings

1. **Initiativet er en ren erstatter** av maskinbruker-POC-en, ikke en utvidelse. Issue #31 sier eksplisitt: *"vi bygger ikke i videre på dagens POC for visning av maskinbruker i FS Admin"* og *"Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker"*. Det betyr ny GraphQL, nye komponenter, ny rute-tre — og en eventuell migrering/avvikling av maskinbrukere må håndteres separat.

2. **Domeneskifte i terminologi.** Krav-filene bruker konsekvent "applikasjon" (ikke "maskinbruker" eller "API-bruker"). Confluence-referansene K1–K19 mapper fra "API-bruker" til "applikasjon". Norske visningsstrenger bør følge dette.

3. **Mønsterpasning er svært klar:**
   - **`BRU-APP-API-001` (listevisning) → `ListPageLayout`** (score ~98/100). Krav-fila spesifiserer paginering 50, last-flere, fritekst-søk på navn, filter på organisasjon/tilgang/status, sortering på navn — alle features `useDataListState`/`useDataListQuery` er bygget for.
   - **`BRU-APP-API-002`–`-006` + `-010` + `-016` (detalj) → `DetailPageLayout`** (score ~98/100). Detalj-features grupperer i logiske datagrupper, har tabs (info, tilganger, endringslogg), og bruker `[id]`-parameter — alt `DetailPageLayout` med `DetailPageTabbedContent` er laget for.
   - **Master–detail flow** (klikk i liste → detaljside → tilbake) er dekket i `cross-patterns/list-page-layout--detail-page-layout.md` og krever ingen ekstra state-håndtering — URL er kilden til sannhet via `nuqs`.

4. **Tilganger-tab er nestet listevisning i detaljsiden.** `BRU-APP-API-003 vise_tilganger.feature` krever egen liste på detaljsiden med filter på miljø/tilgang, sortering, paginering 50. Det er nestet `ListPageLayout`-funksjonalitet i en tabbed `DetailPageLayout`-panel. Mønster-doc-en nevner at `useDataListState`/`useDataListQuery` kan brukes nestet — men det fordrer at backend støtter filter+orderBy+paginering på `tilganger`-relasjonen til en applikasjon (ikke som egen toppnode). **Aktivitet for `bat-graphql-dev`.**

5. **Opprettelse av applikasjon (`BRU-APP-API-009`) er en form/wizard**, ikke list/detail. `bat-fs-admin-patterns` skill har ingen form-pattern enda — krav-fila beskriver dialog-/skjema-flyt med:
   - Velg identitetsleverandør (Feide/Maskinporten, **ikke** FS)
   - Tast inn ekstern ID som **verifiseres mot idP-en** før applikasjonen lagres
   - Navn hentes fra idP
   - Org velges hvis bruker har flere
   Dette er en eksplisitt åpen plass — sannsynligvis et modal-skjema fra detaljside-flyten "ny applikasjon", med GraphQL-mutation som validerer ID. Bør avklares: dedikert side `/tilgangsstyring/applikasjoner/ny` eller modal fra listesiden? Begge er etablerte mønstre i fs-admin (eksempler bør hentes fra `regelverk`-domenet for skjema-patterns).

6. **Passordbytte (`BRU-APP-API-004`)** krever en dialog med éngangs-visning av systemgenerert passord — kopierbart, skjult som default. Krav: *"passordet kan ikke hentes opp igjen etter at dialogen er lukket"*. Det legger føringer på UX (advarsel, "kopier til utklippstavle"-knapp) og GraphQL (mutation returnerer passord én gang).

7. **Endringslogg (`BRU-APP-API-016`) er `@draft`** med fire `@openquestion`-scenarios — kan ikke planlegges teknisk før produkt avklarer hva som skal logges, hva en loggpost inneholder, retention og filtrering. Implementeres som ny tab på detaljsiden når avklart.

8. **Iterasjon 1 finnes ikke på `fruitbat`** som egen mappe. Antagelig var Iterasjon 1 maskinbruker-POC-en (allerede levert) — derfor inneholder krav-mappen kun Iter 2–4 + nice-to-have. Sub-issues på #31 er #434 (Iter 2), #435 (Iter 3), #437 (Nice-to-have). **Iter 4 mangler eget sub-issue** — bør avklares om #437 dekker det, eller om det trengs et nytt sub-issue.

9. **Autorisasjonsmodellen** ("applikasjonsadministrator" per org, "super-applikasjonsadministrator" overalt) går igjen i nesten alle features og må reflekteres i:
   - GraphQL: query-filter må respektere brukerens roller server-side
   - UI: handlinger som passordbytte, redigere beskrivelse, administrere ansvarlig, tildele/fjerne tilganger, deaktivere må kun vises når brukeren har rettigheten for applikasjonens organisasjon
   - Synlighet i lista: applikasjoner fra andre orgs som har tilganger inn i mine orgs skal også vises (K11/K12)

10. **Tildele tilgang (`BRU-APP-API-007`)** krever at valglisten **kun viser tilganger brukeren har rettighet til å tildele**, og at **allerede tildelte tilganger vises gråtonet og ikke-valgbar**. Dette legger føringer på GraphQL: trenger en query som returnerer "tilganger som kan tildeles til applikasjon X i miljø Y", og i UI bør bruk av `MultiSelect` med disabled-state vurderes.

## Pattern Analysis (fra `bat-fs-admin-patterns`)

### POSITIVE DETECTION: ListPageLayout (95+ confidence)

**For:** Applikasjoner-listesiden (`/tilgangsstyring/applikasjoner`)
**Krav-fil:** `listevisning_og_sok.feature` (`BRU-APP-API-001`)

**Komponenter å bruke:**
- `ListPageLayout` (sidebar med filtre + main content med resultatliste)
- `NavigationList` + `NavigationListItem` (klikkbare rader til detaljside)
- `FilterWrapper` (rundt sidebar-filtre)
- OrderBy-komponent (sortering på navn)
- Egen Søk-komponent (fritekst på navn)

**Hooks:**
- `useDataListState` (URL-synkronisert filter/sort/first via `nuqs`)
- `useDataListQuery` (GraphQL paginering med Apollo, `fetchMore`)
- Egen `useGetApplikasjoner(filter, orderBy, first)` som wrapper rundt query'en

**Filter-input som må støttes server-side:**
- `nameContains` (fritekst på navn)
- `organisasjon` (multi-select)
- `tilgang` (multi-select, `@could` på branch — kan utsettes)
- `status` (aktiv / deaktivert)

**Referanseimplementasjon:**
- `src/domains/support/features/Maskinbrukere/` — speil filstrukturen (men IKKE gjenbruk komponenter eller queries)
- `src/domains/utdanning/features/EmnerOverview/` — komplett gullstandard for ListPageLayout (per pattern-skill docs)

### POSITIVE DETECTION: DetailPageLayout (95+ confidence)

**For:** Applikasjon-detaljsiden (`/tilgangsstyring/applikasjoner/[applikasjonId]`)
**Krav-filer:** `se_detaljer.feature` (`-002`), `vise_tilganger.feature` (`-003`), `passordbytte.feature` (`-004`), `administrere_ansvarlig.feature` (`-005`), `rediger_beskrivelse.feature` (`-006`), `deaktivere_applikasjon.feature` (`-010`), `endringslogg.feature` (`-016`)

**Komponenter å bruke:**
- `DetailPageLayout`
- `DetailPageTopBar` (visningsnavn, status, ansvarlig, miljøer som chips)
- `DetailPageTabbedContent` med `DetailPageTabbedContentPanel`
- Action-knapper i topbar: "Bytt passord", "Deaktiver"/"Reaktiver", "Rediger beskrivelse"
- `ActionList` for tilganger-tab (nestet under detail; filter+sort+paginering 50)
- Bekreftelsesdialog (Sikt SDS modal/dialog) for passordbytte, deaktivering, fjerne tilganger

**Tabs (forslag basert på krav):**
1. **Informasjon** — grunnleggende info (navn, beskrivelse, organisasjon, identitetsleverandør, ekstern ID, intern ID, sporingsinfo, miljøer, ansvarlig). Inline edit eller dialog for ansvarlig og beskrivelse.
2. **Tilganger** — nestet liste med filter på miljø/tilgang, sortering, paginering. Handlinger: "Tildel tilgang" (åpner dialog), bulk-fjern.
3. **Endringslogg** — `@draft`, implementeres når krav er avklart.

**Hooks:**
- `useGetApplikasjon(id)` — Apollo `useQuery`
- `useGetApplikasjonTilganger(applikasjonId, filter, orderBy, first)` — egen query for nestet liste, eller fragment-basert om backend støtter det

**Referanseimplementasjon:**
- `src/domains/support/features/MaskinBruker/` — speil filstrukturen (men IKKE gjenbruk komponenter eller queries)
- Pattern-skill anbefaler `StudieprogramDetails` / `EmneDetails` som gullstandard

### NEGATIVE DETECTION: Form pattern (opprette/wizard)

Pattern-skillen har ingen form-pattern enda. `BRU-APP-API-009 opprette_applikasjon.feature` er en wizard/form. Mønster må finnes manuelt — se etter eksempler i `src/domains/regelverk/` eller andre features med "Opprett"-flyt. **Spør utvikler/designer** om listesiden skal ha en "Opprett applikasjon"-knapp som åpner modal eller navigerer til `/tilgangsstyring/applikasjoner/ny`.

### Cross-pattern: List ↔ Detail

Mønster-doc `cross-patterns/list-page-layout--detail-page-layout.md` gjelder direkte. Hovedpoeng: URL er state, ingen manuell preservation trengs ved tilbake-navigering.

## Technical Constraints

- **CLAUDE.md (root):** Next.js 16 App Router med Webpack-bundler, React 19, Apollo Client 4, NextAuth/Feide-autentisering, next-intl, Sikt Design System (`@sikt/sds-*`).
- **CLAUDE.md (root):** *"GraphQL queries should be closely related to components they're used in. Do NOT reuse queries between different components, even if similar."* Innebærer at applikasjoner-feature får sine egne queries lokalt i hooks, separat fra maskinbruker.
- **CLAUDE.md (root):** Hver komponent MÅ ha `*.a11y.test.tsx` (accessibility-test). Coverage-terskler: 60 % branches/functions/lines, 90 % statements.
- **CLAUDE.md (root):** Norsk er domenespråk, engelsk er kodespråk. i18n-strenger til `src/common/messages/nb/support.json` (jf. eksisterende maskinbruker-strenger) — eller egen `applikasjoner.json` om mengden blir stor (bør avklares).
- **PATTERNS.md (pattern-skill):** Aldri modifisér `src/common/`. Bruk byggeklossene som de er. Hvis et mønster ikke finnes, spør utvikler — ikke etabler nytt mønster selv.
- **next-intl-konvensjon:** Skriv aldri hardkodede norske strenger i komponentene. Bruk `useTranslations` og legg nøkler i `nb/`-fila. Skill `externalize-i18n` kan ekstrahere etterpå om nødvendig.
- **Routes:** Generert via `next typegen` i postinstall. Nye ruter (`/tilgangsstyring/applikasjoner` osv.) genererer typer automatisk — ingen manuell oppdatering av `routes.d.ts`.
- **Apollo cache (`src/common/lib/apollo/cacheConfig.ts`):** Endret på branchen — sannsynligvis allerede oppdatert for nye applikasjons-typer. Sjekk i planning-fasen.
- **Identitetsleverandører:** Feide og Maskinporten støttes for nye applikasjoner; FS er utfaset for opprettelse, men eksisterende FS-applikasjoner består og forvaltes som før (inkl. passordbytte).

## Dependencies

### Internal (innenfor fs-admin)

- **Maskinbruker-POC:** Avvikles/migreres. Hva som skjer med eksisterende ruter `/tilgangsstyring/maskinbrukere/*` må avgjøres — sannsynligvis lever de parallelt til migrering er klar, eller redirectes til `/tilgangsstyring/applikasjoner/[id]` når data er felles.
- **TilgangsstyringIndex** (`src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx`): Må få nytt kort/lenke til `/tilgangsstyring/applikasjoner`. I dag har den kun maskinbrukere-lenke.
- **CommandPalette** (`src/domains/search/features/CommandPalette/hooks/useCommands.tsx`): Trenger ny kommando "Gå til applikasjoner".
- **Header-meny / FSAdminIndex:** Lenker til ny rute må legges til.
- **i18n:** Nye nøkler i `src/common/messages/nb/support.json` (eller egen fil).
- **`MaskinBruker.module.css` (ny)** på branchen — sjekk om dette tilhører applikasjoner eller maskinbruker (uavklart fra git status alene).

### External

- **GraphQL API (supergraf):** Nye operasjoner trengs — krever koordinering med backend-team. **Cross-agent hand-off-kandidat.**
  - `applikasjoner(filter, orderBy, first, after)` — paginert liste (med edges/node-konvensjonen)
  - `applikasjon(id: ID!)` — enkelt-oppslag for detalj
  - Mutations: `opprettApplikasjon`, `byttPassord`, `setAnsvarlig`, `oppdaterBeskrivelse`, `tildelTilgang`, `fjernTilgang`, `deaktiverApplikasjon`, `reaktiverApplikasjon`
  - Type-modell: `Applikasjon`, `Tilgang`, `Identitetsleverandør`-enum, `Miljø`-enum, `Ansvarlig` (union av FeideBruker og FeideGruppe?), status-enum, sporingsfelter
- **Identitetsleverandør-oppslag:** Backend må verifisere ekstern ID mot Feide/Maskinporten ved opprettelse.
- **Roller/autorisasjon:** Server-side filtrering basert på "applikasjonsadministrator"-rolle. Sjekk om dette allerede finnes i Feide-claims eller om det er en separat rettighetstjeneste.
- **Confluence-referanser** i krav-filene (rammeinnsikt 4401102853, discovery 4612784227) — bakgrunn for designvalg.

### Cross-agent

- **`fs-supergraf`-agent (eller hvem som eier supergraf-utvikling):** Trenger GraphQL-skjema-utvidelse. Hele settet av operasjoner over.
  - Hva trengs: skjema-design for `Applikasjon` med relaterte typer; filter/orderBy/connection-pattern på liste; mutations for hele livssyklusen.
  - Hvorfor det blokkerer: frontend kan ikke implementere uten skjema. Mocking er en mulighet for tidlig prototyping (jf. eksisterende MSW-mock i `applications`-feature som ble fjernet på denne branchen — det er en kjent rute hvis det blir aktuelt igjen).
- **`fs-klient`/`platon`-agent (hvis ulike teams):** Eventuelle felles autoriseringsregler.

(Konkrete agent-IDer må sjekkes via `agent-coord` skill når brukeren ønsker å file hand-offs.)

## Requirements Impact

Det finnes ingen `docs/ACTIVE/requirements-*.md` i prosjektet — krav-grunnlaget er utelukkende `.feature`-filene fra `fruitbat`. Mappingen:

| Krav-ID | Iterasjon | GitHub | Status | Mønster |
|---|---|---|---|---|
| `BRU-APP-API-001` Listevisning og søk | 2 | #438, #448, #449 | `@planned` | ListPageLayout |
| `BRU-APP-API-002` Se detaljer | 2 | #439 | `@planned` | DetailPageLayout |
| `BRU-APP-API-003` Vise tilganger | 2 | #440 | `@planned` | Nested list i DetailPageLayout tab |
| `BRU-APP-API-004` Passordbytte | 2 | #441 | `@planned` | Dialog (Sikt SDS) |
| `BRU-APP-API-005` Administrere ansvarlig | 2 | #442 | `@planned` | Dialog / inline edit |
| `BRU-APP-API-006` Redigere beskrivelse | 2 | #443 | `@planned` | Inline edit / dialog |
| `BRU-APP-API-007` Tildele tilgang | 3 | #444, #450 | `@planned` | Dialog (multi-select) |
| `BRU-APP-API-008` Fjerne tilgang | 3 | #445, #451 | `@planned` | Bekreftelsesdialog (bulk) |
| `BRU-APP-API-009` Opprette applikasjon | 3 | #446 | `@planned` | Form/wizard (mønster må avklares) |
| `BRU-APP-API-010` Deaktivere applikasjon | 3 | #447 | `@planned` | Bekreftelsesdialog |
| `BRU-APP-API-015` Sist brukt tidspunkt | NTH | #452 | `@could @draft` | Felt i detaljside |
| `BRU-APP-API-016` Endringslogg | 4 | #453 | `@must @draft` | Ny tab i detaljside |
| `BRU-APP-API-017` Masseadministrasjon | NTH | #454 | `@could @draft` | Ute av scope inntil videre |

**Krav i risikoområdet:**
- `-016 Endringslogg` har fire åpne spørsmål — produkt må avklare før planning.
- `-009 Opprette applikasjon` har ID-verifisering mot ekstern idP som kan være ny capability i backend.
- `-007 Tildele tilgang` har "rettighet til å tildele" som krever ny autoriserings-logikk i query.

## Krav-input fra GitHub

- **Kilde:** initiativ-issue `#31` + sub-issues `#434`, `#435`, `#437` (alle med tomme body-er) og branch `fruitbat`
- **Linket PR(s):** ingen direkte på #31. Per-krav GitHub-issues (#438–#454) er referert i `.feature`-filenes `# GitHub:`-markører.
- **Repo / ref:** `sikt-no/fs` @ `fruitbat`
- **Hentede `.feature`-filer:** Se [`krav-input/manifest.md`](krav-input/manifest.md) for komplett liste med klikkbare lenker.
- **Hentet:** `2026-05-12`

## Open Questions

- [ ] **Migreringsstrategi for maskinbruker-POC:** Lever de gamle rutene `/tilgangsstyring/maskinbrukere/*` videre parallelt, eller redirectes/fjernes de når applikasjoner er live? (Produkt-/UX-beslutning, ikke teknisk per se — påvirker likevel route-tre og CommandPalette/navigasjon.)
- [ ] **Plassering av "Opprett applikasjon"-flyt:** Modal fra listesiden, eller egen rute `/tilgangsstyring/applikasjoner/ny`? Sistnevnte gir bedre djup-lenking; førstnevnte er raskere i flyt. Vurder ID-verifiseringen mot idP — den kan trenge sin egen interaksjonssteg ("verifiser → forhåndsvis navn → bekreft").
- [ ] **i18n-fil:** Holder vi alle applikasjons-strenger i eksisterende `support.json`, eller skiller vi ut til `applikasjoner.json`? Avhenger av mengde og fremtidig domeneoppdeling.
- [ ] **Tilganger-tab GraphQL:** Skal `tilganger`-relasjonen på `Applikasjon` støtte filter+orderBy+connection direkte, eller skal det være en egen top-level query `applikasjonTilganger(applikasjonId, filter, orderBy, first)`? Avklares i `bat-graphql-dev`-fasen.
- [ ] **Iterasjon 4 sub-issue:** #437 er "Nice to have: Tilleggsfunksjonalitet" — ikke "Iterasjon 4: Selvbetjent administrasjon". Mangler det et sub-issue for Iter 4, eller dekkes Iter 4 implisitt fordi mesteparten allerede er levert via rettighetsregler i Iter 2/3 (jf. systemkrav-noten)?
- [ ] **Endringslogg-krav:** Fire `@openquestion`-scenarios må avklares før Iter 4 kan planlegges teknisk.
- [ ] **Apollo cache typePolicies:** Hvilke nye typer (`Applikasjon`, `Tilgang`, `Ansvarlig`) trenger `keyFields`-konfigurasjon i `src/common/lib/apollo/cacheConfig.ts`?
- [ ] **Routenavn:** Bekreft `/tilgangsstyring/applikasjoner` (flertall, lowercase) — ikke `/applikasjoner` eller `/tilgangsstyring/applikasjon`. Stemmer med eksisterende konvensjon for `/tilgangsstyring/maskinbrukere`.