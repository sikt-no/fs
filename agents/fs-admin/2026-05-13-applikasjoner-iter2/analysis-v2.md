# Analysis: Applikasjoner — Iterasjon 2 (Support: Oversikt og passordbytte)

> **Scope:** [sikt-no/fs#434](https://github.com/sikt-no/fs/issues/434) — sub-issue under initiativ [#31](https://github.com/sikt-no/fs/issues/31) "Grunnleggende selvbetjent tilgangsstyring for applikasjoner via FS Admin".
>
> **Sketch:** [`docs/ACTIVE/applikasjoner-listevisning.png`](applikasjoner-listevisning.png) — wireframe of the listevisning. This analysis is anchored to that sketch.
>
> **Out of scope:** Iterasjon 3 (`#435`), Iterasjon 4 selvbetjent administrasjon, Nice-to-have (`#437`). Per `bat-analyze`-skillen: **no solution design** — only context, current state, constraints, dependencies, and open questions.
>
> **Cross-agent context:** `fs-admin-mats` har levert en parallell, bredere analyse som dekker Iter 2 **og** Iter 3 ([`agents/fs-admin-mats/2026-05-13-applikasjon-tilgangsstyring/analysis-v2.md`](../../../fs/agents/fs-admin-mats/2026-05-13-applikasjon-tilgangsstyring/analysis-v2.md) i coord-repoet). Denne analysen er smalere — kun Iter 2, og fokuserer på listevisningen som sketchen viser. Hvor relevant peker jeg på fs-admin-mats' funn istedenfor å duplisere.

## Problem Statement

FS Admin har i dag en POC for "maskinbrukere" som **aldri ble innført** og som per initiativ #31 skal fjernes. Iterasjon 2 leverer det første brukbare flatesteget av en **ny** applikasjons-administrasjon: en lese-/lett-redigerings-løsning som lar Sikt support og lokale applikasjonsadministratorer:

1. Finne riktig applikasjon via en filtrerbar, søkbar oversikt (sketchen).
2. Se grunnleggende detaljer + tilganger.
3. Bytte passord når kunden ber om det.
4. Korrigere utdaterte data (ansvarlig, beskrivelse).

Iterasjonen åpner ikke for å opprette, deaktivere eller tildele/fjerne tilganger — det kommer i Iter 3.

**Tre eksplisitte føringer fra initiativ-issuet** ([#31](https://github.com/sikt-no/fs/issues/31)) som rammer alt arbeid i Iter 2:

1. "Vi lager en ny løsning … vi bygger ikke videre på dagens POC for visning av maskinbruker i FS Admin."
2. "Dagens løsning for maskinbruker i FS Admin er ikke innført og skal fjernes."
3. "Vi skal lage nye graphql spørringer for applikasjon. Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker."

## Current State

### Hva som finnes i fs-admin i dag

Det er **ingen** `Applikasjon`-flate i koden ennå. Den eksisterende POC-en er for "maskinbrukere" og lever under:

- `src/domains/support/features/Maskinbrukere/` — listevisning (POC)
- `src/domains/support/features/MaskinBruker/` — detalj + passord-flyt (POC)
- `src/domains/support/features/TilgangsstyringIndex/` — domene-landingsside
- Routes: `src/app/tilgangsstyring/maskinbrukere/{page,layout,[maskinbrukerid]}` 
- Meny-gating: Unleash-flag `tilgangsstyring-meny` ([`src/features/Header/Menu/Menu.tsx`](../../src/features/Header/Menu/Menu.tsx))

`fs-admin-mats`-analysen kartlegger POC-en i detalj (LOC, filtre, MigrerPassord-dialogen, Zustand-stores osv.) — ikke duplisert her.

### Hva sketchen viser

`applikasjoner-listevisning.png` er en wireframe av Iter 2-listevisningen. Layout og elementer som leses ut:

| Område                  | Innhold i sketchen                                                                                |
| ----------------------- | ------------------------------------------------------------------------------------------------- |
| **Brødsmuler**          | `Hjem › Tilgangsstyring › Applikasjoner`                                                          |
| **Topp-header**         | "Applikasjoner" som sidetittel; "+ Opprett"-knapp øverst til høyre                                |
| **Action-bar (over)**   | Søkefelt (med "Navn"-placeholder) øverst til høyre                                                |
| **Sidebar (venstre)**   | Filtere: Navn (tekst), Miljø (select), Organisasjon (select), Tilgang (select), Status (select). "Tøm filtre"-link øverst i sidebar. |
| **Resultat-område**     | Header "Resultater · 67 applikasjoner i listen"; treff-rader med flere kolonner                   |
| **Rad-innhold**         | Navn ("minapplikasjon" + miljø-tags "Prod" / "Demo"), beskrivelse, organisasjon ("NTNU"), ansvarlig-rolle, "13 tilganger", status-tag ("aktiv" / "deaktivert") og chevron som indikerer navigasjon til detalj |
| **Bunn**                | "Last inn flere" — paginering via "load more"                                                     |

Sketchen viser også en "+ Opprett"-knapp. Per krav-spesifikasjonen (`systemkrav.md` for Iter 2) er **opprettelse ikke en del av Iter 2** — den ligger i Iter 3 (`opprette_applikasjon.feature`). Knappen i sketchen er altså forskutterende; for Iter 2 må vi avklare om den skjules eller vises disabled (se Åpne spørsmål).

### Krav-tekstene (oppsummert)

Seks `.feature`-filer + `systemkrav.md` for Iter 2 ligger i [`docs/ACTIVE/krav-input/fruitbat/.../01 Iterasjon 2 …/`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/). Listevisningen drives av:

- **`listevisning_og_sok.feature`** (`@BRU-APP-API-001`, GitHub `#438, #448, #449`) — det primære kravet for siden i sketchen.
- Detalj-relaterte features (`se_detaljer`, `vise_tilganger`, `passordbytte`, `administrere_ansvarlig`, `rediger_beskrivelse`) sklir over på detaljsiden, men listevisningen må navigere til den.

Kjernekravene fra `listevisning_og_sok.feature`:

| Regel                                                      | Krav                                                                                                                                                                              |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Liste over alle applikasjoner (K1)                         | Kolonner: Navn, Beskrivelse, Miljøer, Ansvarlig, Organisasjon, Status. Default sortert på Navn ASC. Paginering 50 om gangen. Totalt antall + antall lastet vises. Rad-klikk → detalj. |
| Søk og filtrering (K2)                                     | Fritekst-søk på Navn. Filter på Organisasjon, Tilgang (`@could` — kan utsettes), Status. Filtre kan kombineres med søk.                                                          |
| Synlighet via administrasjonsrettigheter (K11, K12)        | Lokal admin ser applikasjoner i sine organisasjoner **og** applikasjoner med tilganger inn i deres organisasjoner. Super-admin ser alt, inkl. applikasjoner uten organisasjon.   |
| Synlighet via ansvarlig-relasjon                           | Brukere som er direkte ansvarlig ser applikasjonen. Ansvarlig via feide-gruppe er `@could`.                                                                                       |

**Avvik mellom sketch og krav som må noteres:**

- Sketchen har et **Miljø-filter** i sidebaren. `listevisning_og_sok.feature` nevner ikke miljø-filter på lista (kun som radkolonne). Miljø-filter er derimot et eksplisitt krav på **tilganger-tab-en** i detalj (`vise_tilganger.feature`). Trolig sketch-utvidelse vs. krav — se Åpne spørsmål.
- Sketchen viser **antall tilganger** ("13 tilganger") som radfelt. Det er ikke listet i `listevisning_og_sok.feature` sin kolonne-tabell. Igjen — sketch-detalj vs. krav-presisjon.

### Pattern-detektering

Kjørt `bat-fs-admin-patterns`:

- **Pattern:** `ListPageLayout` — **100/100 confidence**.
- **Signaler:** primær ("oversikt over alle applikasjoner", "liste over applikasjoner") + plural entitet; sekundære: filtrering, fritekst-søk, sortering, paginering "last inn flere", topp 50; strukturelle: sidebar-filter, two-column layout (sketchen bekrefter), organisasjons-kontekst, navigasjon til detalj.
- **Cross-pattern:** `list-page-layout--detail-page-layout` gjelder også — flyt fra liste til detalj med bevart URL-state.

Pattern-guiden peker eksplisitt på `EmnerOverview` / `EmneDetails` som gold-standard og advarer mot å kopiere `Maskinbrukere` — det er anti-pattern (Fuse.js + `first: 1000` + ingen `useDataListQuery`). Initiativ #31 sier akkurat det samme i klartekst.

## Key Findings

1. **Listevisningen i sketchen mapper rent til `ListPageLayout`-patteren.** Alle elementer (sidebar-filter, søk, sortert NavigationList med load-more, totalCount/loadedCount, rad → detalj) finnes som standard byggeklosser i `src/common/`. Ingen ny layout-arkitektur trengs.
2. **`EmnerOverview` ↔ `EmneDetails` er den autoritative referansen.** Pattern-skillen sier det, og fs-admin-mats peker også på den (samme retning, uavhengig kilde — sterkere signal).
3. **`Maskinbrukere`-POC-en må ikke gjenbrukes** — verken kode, GraphQL-spørringer eller mønster. Dette står i issue-body til #31 og i pattern-skillens anti-patterns. Det betyr at GraphQL-spørringer **må skrives nytt mot et `applikasjon`-skjema som ennå ikke finnes**.
4. **Ingen `Applikasjon`-typer i `src/common/types/generated/`.** Schema-team må levere typer (entitet, filter-input, orderBy-input, connection) før frontend kan kompilere mot ekte typer. Et arbeid i mellomtiden kan gjøres mot MSW-mocks (jf. tidligere `/applications`-eksperiment som *ikke* lever på denne branchen — bare i hukommelsen fra et tidligere eksperiment).
5. **Synlighetsreglene (K11, K12) er server-side ansvar.** Frontend skal sende `filter` + (mest sannsynlig) en `organisasjonskode`/kontekst — selve "hva ser jeg" må håndheves i schema/backend. Dette er konsistent med hvordan `EmnerOverview` håndterer eier-organisasjon (injiseres i query-hook, ikke i URL-state).
6. **Sketch er ikke 1-til-1 med krav.** Miljø-filter, antall-tilganger som radfelt, "+ Opprett"-knapp (Iter 3) — disse er sketch-detaljer som krever produkt-avklaring før plan-fase. Se Åpne spørsmål.
7. **Tilganger-tab-en i detaljsiden (`vise_tilganger.feature`) er en sub-list-pattern.** Hører hjemme i detaljanalysen — ikke listevisningen — men bygger på `ActionList` eller tilsvarende. Nevnes her kun for å unngå sammenblanding med list-page-patteren.

## Technical Constraints

- **Bygges som ny flate, ikke utvidelse av POC** (#31 §1, §2). Iter 2 skal levere et nytt domeneflateområde for applikasjoner, ikke modifisere `Maskinbrukere`/`MaskinBruker`.
- **GraphQL: nytt skjema kreves** (#31 §3). Cannot reuse `MaskinbrukereFilter`, `Maskinbruker`-typen, `apiTilgangerV2` osv. Schema-team må levere nye `Applikasjon*`-typer.
- **CLAUDE.md (project root):** `Apollo Client 4` + `next-intl` + `Sikt Design System` + CSS Modules + a11y-tester påkrevd. ListPageLayout-patteren er allerede i tråd med dette.
- **`useDataListState` + `useDataListQuery` er kanonisk.** Skill-guide og pattern-anti-patterns understreker dette eksplisitt. Server-side filter + orderBy via GraphQL — ikke klient-side `Fuse.js`/in-memory sortering.
- **`href`-prop på `NavigationListItem`** (ikke `router.push`) — bevarer browser-historikk og scroll, og lar URL-state holde filtre live ved Back-navigasjon (cross-pattern-guide).
- **Organisasjonskontekst: ikke i URL-state.** `eierOrganisasjonskode` (eller analogt felt) skal injiseres fra `useMineLaresteder()` i query-hook'en — ikke ligge i URL'en. Anti-pattern flagget eksplisitt.
- **Norsk forretningsspråk + engelsk kode.** "Applikasjon"/"Applikasjoner" som entitetsnavn i UI; engelsk i komponentnavn (`ApplikasjonerOverview` el. tilsvarende — endelig navnevalg er plan-arbeid).
- **i18n via `next-intl`:** keys i `src/messages/nb/` matchende domene-struktur. Translasjons-keys legges i tilsvarende namespace (sannsynligvis `support.*` eller nytt `tilgangsstyring.applikasjoner.*`).
- **A11y-test påkrevd** for hver ny komponent (CLAUDE.md). Pattern-guidens "complete NavigationList props"-krav inkluderer dette.
- **Permission gating:** `useAdmissioUserActions`-enumen mangler `applikasjonsadministrator`/`super-applikasjonsadministrator` (per fs-admin-mats). Disse må legges til (cross-agent ask), ellers kan ikke menyen og siden gates riktig.

## Dependencies

### Internal (fs-admin)

- **`ListPageLayout`** og familie (`ListPageActionbar`, `ListPageSidebar`, `ListPageContent`) — finnes, kanonisk dokumentert i [`src/common/components/layouts/ListPageLayout/CLAUDE.md`](../../src/common/components/layouts/ListPageLayout/CLAUDE.md).
- **`NavigationList`** + `NavigationListItem` — finnes ([`src/components/lists/NavigationList/NavigationList.tsx`](../../src/components/lists/NavigationList/NavigationList.tsx)).
- **`useDataListState`** + **`useDataListQuery`** — kanoniske hooks i [`src/common/hooks/`](../../src/common/hooks/).
- **`FilterWrapper`** / `FilterReset` / `OrderBy` — list-enhancer-familien.
- **`useMineLaresteder`** — organisasjonskontekst.
- **`NoOrgError`** — fallback når brukeren ikke har en relevant organisasjon. Må eksistere eller opprettes i domenet for applikasjoner.
- **Breadcrumbs** — for detaljsiden tilbake til lista.
- **`Menu.tsx`** — ny meny-oppføring "Applikasjoner" under `/tilgangsstyring` (sketchen viser dette i brødsmulen). Krever ny userAction.
- **`userActions.ts`-enum** — utvides med applikasjonsadministrator-handlinger.
- **`TilgangsstyringIndex`-domeneindeks** — får sannsynligvis et nytt kort/lenke til Applikasjoner; må vurderes mot eksisterende Maskinbrukere-kort (som skal vekk).
- **i18n-namespaces** — nye keys må legges til i `src/messages/nb/`.
- **Sletting av POC** — `Maskinbrukere/`, `MaskinBruker/`, `useMaskinbruker*`-hooks, `/tilgangsstyring/maskinbrukere`-routes, relevante i18n-keys. fs-admin-mats har talt opp ~2972 LOC.

### External

- **`@sikt/sds-*`** — Sikt Design System (allerede i bruk).
- **Apollo Client 4** — via `DynamicApolloWrapper`.
- **`nuqs`** — URL-state for `useDataListState`.
- **`next-intl`** — i18n.
- **Feide / Unleash** — Unleash-flagget `tilgangsstyring-meny` kontrollerer i dag menyen; må beslutte om det gjenbrukes, byttes ut, eller fjernes når den nye flaten ruller ut.

### Cross-agent (kandidater for hand-off — filed av `bat-plan`, ikke her)

- **`backend`-agenten** — Ny `Applikasjon`-flate i SuperGraf-skjemaet. Trenger:
  - Entitetstype `Applikasjon` med feltene listevisningen rendrer (navn, beskrivelse, miljøer, ansvarlig, organisasjon, status, antall tilganger). Sketchen er primær kilde for hvilke felter listen viser.
  - `ApplikasjonerFilter`-input med felter for: `navnContains`, `organisasjonskoder: [String!]`, `statuser: [ApplikasjonStatus!]`, `tilgangskoder: [String!]` (`@could` — kan utsettes), `miljoer: [Miljo!]` (hvis Iter 2 skal ha miljø-filter; jf. åpent spørsmål).
  - `QueryApplikasjonerOrderByInput` med minst `NAVN`.
  - Connection-pattern (`edges`/`node`/`pageInfo`/`totalCount`) — konsistent med eksisterende mønster.
  - Synlighetsregler (K11/K12 + ansvarlig-relasjon) håndheves server-side basert på innlogget brukers rettigheter — frontend skal ikke filtrere på dette.
  - Deprecation/fjerning av `maskinbrukere`-query og tilhørende typer (koordinert med fs-admin-fjerning).
  - **Hvorfor det blokkerer:** uten typer kan vi ikke gjøre `npm run compile`, og vi mister kompilator-feedback. Mocks kan tideligst-til-mye, men er ikke målet.
- **`fs-admin-mats`-agenten** — Har en parallell, bredere analyse for Iter 2+3. Ingen direkte hand-off, men koordinering: hvem eier hvilken del av implementasjonen? Plan-fasen må avklare.

## Requirements Impact

Per `systemkrav.md` for Iter 2: alle 6 kapabiliteter er **Må ha** og **Planlagt**. Listevisningen (BRU-APP-API-001 / K1, K2, K11, K12) er det eneste som **fullt** dekkes av sketchen. De øvrige (detaljer, tilganger-tab, passordbytte, ansvarlig, beskrivelse) skjer på detaljsiden og er utenfor scope for denne analysen — men listevisningen må navigere til detaljsiden, så `/{ny-rute}/applikasjoner/[id]` må eksistere som minst-en-stub når plan-fasen begynner på dem.

- **Adressert:** BRU-APP-API-001 (listevisning + søk + filter + paginering + synlighet).
- **Berørt indirekte:** BRU-APP-API-002 til -006 (detaljside-flyt) — listevisningen lenker dit.
- **Avdekkede gap:**
  - `applikasjonsadministrator`/`super-applikasjonsadministrator`-enum mangler i `userActions.ts`.
  - Sketch viser miljø-filter og "antall tilganger"-kolonne som ikke står i `listevisning_og_sok.feature`. Krav vs. design må avstemmes.
  - "+ Opprett"-knappen i sketchen tilhører Iter 3 (`opprette_applikasjon.feature`). Trenger avklaring for Iter 2-leveransen.

## Krav-input fra GitHub

- **Kilde-issue:** [#31](https://github.com/sikt-no/fs/issues/31) (initiativ) → [#434](https://github.com/sikt-no/fs/issues/434) (Iterasjon 2 — sub-issue valgt for denne analysen).
- **Repo / branch:** `sikt-no/fs` @ branch `fruitbat` (utledet fra at krav-filene allerede ligger lokalt under `docs/ACTIVE/krav-input/fruitbat/…`; ingen branch eksplisitt navngitt i issue-body, men `fruitbat` matcher mappestrukturen).
- **Hentede `.feature`-filer (alle i Iter 2-mappen):**
  - [`listevisning_og_sok.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/listevisning_og_sok.feature) — **primær for sketchen**
  - [`se_detaljer.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/se_detaljer.feature)
  - [`vise_tilganger.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/vise_tilganger.feature)
  - [`passordbytte.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/passordbytte.feature)
  - [`administrere_ansvarlig.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/administrere_ansvarlig.feature)
  - [`rediger_beskrivelse.feature`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/rediger_beskrivelse.feature)
  - [`systemkrav.md`](krav-input/fruitbat/krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/applikasjoner/01%20Iterasjon%202%20-%20Support%20%E2%80%93%20Oversikt%20og%20passordbytte/systemkrav.md)
- **Hentet:** 2026-05-07 (tidsstempel fra tidligere økt — filene var allerede på disk ved analysens start; manifest under `docs/ACTIVE/krav-input/` mangler eksplisitt timestamp).

## Sketch-mapping (referanse)

| Sketch-element                                | Komponent fra ListPageLayout-pattern             |
| --------------------------------------------- | ------------------------------------------------ |
| Brødsmuler                                    | `Breadcrumbs` (over layouten)                    |
| Side-tittel "Applikasjoner"                   | `ListPageLayout` `title`-prop                    |
| "+ Opprett"-knapp                             | `ListPageActionbar` — *kun Iter 3*; avklar Iter 2 |
| Søkefelt "Navn"                               | Filter-felt i `ListPageSidebar` *eller* topp-bar |
| Sidebar med 5 filtre + "Tøm filtre"           | `ListPageSidebar` med `FilterWrapper` + `FilterReset` |
| "Resultater · 67 i listen"                    | `NavigationList` `headerText` + `totalCount`/`loadedCount` |
| Resultat-rader m/ chevron                     | `NavigationListItem` med `href`                  |
| Miljø-tags ("Prod"/"Demo") i rad              | `TagWithIcon` el. tilsvarende inni listeraden    |
| Status-tag ("aktiv"/"deaktivert") i rad       | `TagStatus` fra `@sikt/sds-tag` (allerede i bruk) |
| "Last inn flere" nederst                      | `NavigationList` `onLoadMore` + `hasNextPage`    |

## Open Questions

- [ ] **Miljø-filter i listevisning:** sketchen viser det, men `listevisning_og_sok.feature` lister kun Organisasjon/Tilgang/Status. Skal Miljø-filteret med i Iter 2 — og må kravet i så fall oppdateres? *Hvis ja: trigger backend-arbeid (utvidet `ApplikasjonerFilter`-input).*
- [ ] **"Antall tilganger" som radfelt:** sketchen viser "13 tilganger" per rad. Skal det med i listevisningen — eller kun på detaljsiden? *Hvis ja: feltet må eksponeres på `Applikasjon`-typen via SuperGraf.*
- [ ] **"+ Opprett"-knapp i Iter 2:** `opprette_applikasjon.feature` ligger i Iter 3 (`#435`). Skal knappen i Iter 2 skjules helt, eller vises disabled med tooltip "Kommer i Iterasjon 3"?
- [ ] **Filter "Tilgang" er `@could`** i Iter 2 (`listevisning_og_sok.feature` linje 73). Skal det med i denne iterasjonen, eller utsettes? Påvirker både UI og backend-filter-input.
- [ ] **Synlighet via feide-gruppe er `@could`** (linje 118). Ut eller inn i Iter 2?
- [ ] **Rute-struktur og side-plassering:** under `/tilgangsstyring/applikasjoner` (gjenbruker dagens domeneprefix, parallelt med `/tilgangsstyring/maskinbrukere` som skal fjernes), eller egen toppnivå-route? Plan-arbeid, men avklares før plan.
- [ ] **User-action-navn:** hvilke nøyaktige enum-verdier skal `userActions.ts` få (`SE_APPLIKASJONER` / `MODIFISERE_APPLIKASJONER`?, eller noe annet)? Krever koordinering med fs-admin-mats og backend.
- [ ] **Koordinering med fs-admin-mats:** to agenter har analysert samme initiativ samme dag. Skal én av oss implementere, eller splittes arbeidet (f.eks. liste vs. detalj)?
- [ ] **Unleash-flagging:** ny `applikasjoner-meny`-flag, eller gjenbruk `tilgangsstyring-meny` mens POC-en rives?

---

*Analysen er bevisst smal (kun listevisning, kun Iter 2) for å matche sketchen. Detaljside-flyten og Iter 3 er dekket av `fs-admin-mats`-analysen i coord-repoet.*
