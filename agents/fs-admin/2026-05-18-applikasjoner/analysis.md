# Analysis: Applikasjoner (Iterasjon 2 + 3)

> Scope: initiativ [sikt-no/fs#31](https://github.com/sikt-no/fs/issues/31) →
> sub-issues [#434](https://github.com/sikt-no/fs/issues/434) (Iter 2 — *Support: Oversikt og passordbytte*) og
> [#435](https://github.com/sikt-no/fs/issues/435) (Iter 3 — *Grunnleggende tilgangsstyring for intern support*).
>
> Krav-input er hentet fra branchen `fruitbat` på `sikt-no/fs` (ref. cross-reference fra schema-issue [#455](https://github.com/sikt-no/fs/issues/455)). Lokale kopier ligger under [`docs/ACTIVE/krav-input/fruitbat/`](krav-input/fruitbat) og er listet i [`docs/ACTIVE/krav-input/manifest.md`](krav-input/manifest.md).

## Problem Statement

FS Admin skal få en ny modul *Applikasjoner* som lar applikasjonsadministratorer og Sikt-support administrere applikasjoner ("API-brukere") på tvers av organisasjoner og identitetsleverandører (Feide, Maskinporten, og eksisterende FS-applikasjoner). Iter 2 leverer en **lese- og lett-redigerings-flyt** (oversikt, detalj, ansvarlig, beskrivelse, passordbytte). Iter 3 utvider med **tilgangsstyring** (opprette applikasjon, tildele/fjerne tilgang, deaktivere/reaktivere).

Iter 2 og Iter 3 er to faser av samme modul: Iter 3 bygger direkte på Iter 2-flyten (oversikt og detaljside må være på plass først).

## Current State

Det finnes en eksisterende **maskinbruker-POC** i FS Admin (`#31` slår eksplisitt fast at den ikke er innført og skal fjernes):

- **Listevisning:** [`src/domains/support/features/Maskinbrukere/`](../../src/domains/support/features/Maskinbrukere/)
- **Detaljside:** [`src/domains/support/features/MaskinBruker/`](../../src/domains/support/features/MaskinBruker/)
- **Ruter:**
  - `src/app/tilgangsstyring/maskinbrukere/page.tsx`
  - `src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/page.tsx`
- **GraphQL:** `GET_MASKINBRUKERE` i `Maskinbrukere/hooks/useGetMaskinbrukere.ts`, `MigrerPassord`-mutation i `MaskinBruker/components/MigrerPassord/`.
- **Oversettelser:** Nøkler i `src/common/messages/nb/support.json`, `features.json`, `search.json` (kommandopallett).

POC-en er dokumentert som **anti-pattern** i fs-admin sitt eget patterns-katalog (`.claude/skills/bat-fs-admin-patterns/known-patterns/list-page-layout-pattern/anti-patterns.md` og `.../detail-page-layout-pattern/anti-patterns.md`) — den bruker klient-side filtrering med Fuse.js og laster store datasett med `first: 1000` istedenfor å bruke `useDataListQuery` med server-side filter/orderBy.

Initiativet er **eksplisitt om at maskinbruker-POC-en ikke skal videreutvikles**: ny modul bygges fra bunnen ved siden av POC-en, og POC-en fjernes når ny løsning er på plass.

Ingen `applikasjon`/`applikasjoner`-kode finnes i repoet fra før — det nye feature-navnet kolliderer ikke med eksisterende kode.

## Key Findings

- **To iterasjoner, én modul.** Iter 2 (#434) og Iter 3 (#435) deler oversikts- og detaljsiden, men Iter 3 legger til *muterende* handlinger. Den naturlige byggerekkefølgen er Iter 2 → Iter 3.
- **UI-mønster: master-detail (cross-pattern).** `bat-fs-admin-patterns` matchet både `list-page-layout-pattern` og `detail-page-layout-pattern` med høy konfidens, og cross-pattern-dokumentet [`list-page-layout--detail-page-layout.md`](../../.claude/skills/bat-fs-admin-patterns/cross-patterns/list-page-layout--detail-page-layout.md) beskriver eksakt flyten kravet ber om (URL-synkronisert filter/sort/paginering, NavigationList → detail-side, breadcrumb tilbake).
- **Gold standard er EmnerOverview ↔ EmneDetails**, ikke maskinbruker-POC-en. Patterns-skillen og cross-pattern-dokumentet peker eksplisitt på `src/domains/utdanning/features/EmnerOverview/` og `EmneDetails/` som referansene som skal kopieres.
- **Identitetsleverandør er en del av domenet, ikke en filter.** Krav-listevisningen filtrerer på `Navn` (fritekst), `Organisasjon`, `Tilgang`, `Status` — den filtrerer *ikke* på identitetsleverandør. FS-applikasjoner vises i samme liste som Feide/Maskinporten, og samme administrasjonshandlinger gjelder. Skissens kolonner stemmer overens med kravet (Navn, Beskrivelse, Miljøer, Ansvarlig, Organisasjon, Status, ikon for identitetsleverandør og handlings-meny).
- **Synlighet styres av rolle.** Tre nivåer av synlighet i `listevisning_og_sok.feature`:
  1. Super-applikasjonsadministrator ser alle, inkludert applikasjoner uten organisasjon.
  2. Applikasjonsadministrator for organisasjon X ser X-applikasjoner *pluss* applikasjoner fra andre organisasjoner som har tilganger inn i X.
  3. Bruker registrert som ansvarlig (direkte eller via feide-gruppe — sistnevnte er `@could`) ser sine ansvars-applikasjoner.

  Dette er mer komplisert enn standard `useMineLaresteder`-mønsteret, der filter på `effectiveOrganisasjonskode` settes på query-nivå. Server-side må håndtere synlighet; klient sender bare frivillige filtre.
- **Paginering: "last inn flere" 50 om gangen** — matcher `useDataListState`/`useDataListQuery`-standardene.
- **Detaljside har 6 logiske områder** (mappet til Iter 2 + 3):
  - Grunnleggende info + sporing (Iter 2, `se_detaljer.feature`)
  - Miljøer + ansvarlig (Iter 2, `se_detaljer.feature` / `administrere_ansvarlig.feature`)
  - Tab "Tilganger" — liste med filtrering på miljø/tilgang og paginering (Iter 2 `vise_tilganger.feature`; Iter 3 `tildele_tilgang.feature`/`fjerne_tilgang.feature`)
  - Handling: rediger beskrivelse (Iter 2)
  - Handling: passordbytte (Iter 2 — modal-dialog med engangs-visning)
  - Handling: deaktivere/reaktivere (Iter 3)
- **Tilgangslisten på detaljsiden er en sub-list med ekte filtre og paginering** (filter på miljø og tilgang, sortering, *load more*). I patterns-katalogen er dette presist det case der man ikke skal bruke fragment-only, men en separat query med server-side filter/orderBy/`first`. Anti-patternen "klient-side Fuse.js for sub-list" som maskinbruker-POC-en gjør, må *ikke* kopieres.
- **Passordbytte har et sterkt sikkerhetskrav:** genereres på server, vises kun én gang, basic auth, alltid ett aktivt passord. Dette skal mest sannsynlig være en egen mutation som returnerer det rå passordet ett-og-bare-ett-gang — UI-en må ikke logge eller cache det.
- **Opprettelse er ID-verifiseringsdrevet (Iter 3).** Bruker velger Feide eller Maskinporten, oppgir ID, server slår opp navnet hos idP-en og verifiserer at ID-en finnes og ikke allerede er registrert. Visningsnavn må være globalt unikt — dette er en backend-validering som UI-en speiler. FS som idP er **ikke valgbar**.
- **Ansvarlig kan være feide-bruker eller (`@could`) feide-gruppe** fra applikasjonens egen organisasjon. Søk er begrenset til den ene organisasjonen.

## Technical Constraints

- **Next.js 16 App Router + Apollo Client 4.** Bruk typed `gql` fra `@/__generated__` (jf. graphql-consumer skill); ikke gjenbruk maskinbruker-queries (eksplisitt krav i #31: *"Vi skal ikke gjenbruke dagens graphql spørringer for maskinbruker"*).
- **Sikt Design System** (`@sikt/sds-*`) og `ListPageLayout` / `DetailPageLayout`-komponentene i `src/common/components/layouts/`.
- **URL-state via `useDataListState`** (nuqs-basert) — *ikke* `useState` for filtre. Browser-back må bevare filter/sort/paginering automatisk.
- **`useDataListQuery`** for selve henting — server-side `filter`, `orderBy`, `first`. Patterns-katalogen markerer klient-side filtrering med Fuse.js som anti-pattern.
- **Hver feature/komponent må ha `*.a11y.test.tsx`** (CLAUDE.md krav). Test-coverage 60% gren/funksjon/linje, 90% statements.
- **i18n via next-intl** — alle Norwegian strings i `src/common/messages/nb/`. Strukturen følger `domain.<ComponentName>.<key>` (se DetailPageLayout-guiden).
- **Backend-avhengighet: nytt GraphQL-skjema for `Applikasjon`-typen.** Schema-arbeidet er allerede flagget som et eget issue ([#460](https://github.com/sikt-no/fs/issues/460) — *"[fs-admin → backend] Nye Applikasjon-typer i SuperGraf-skjemaet (Iter 2 av initiativ #31)"*) som krysser-refererer #31. Krav-branchen inneholder også `Schema:`-issue [#455](https://github.com/sikt-no/fs/issues/455) for utvidet Maskinbruker/Applikasjon-type.
- **Synlighetsregler må håndheves server-side.** Klient kan ikke regne ut "ser også applikasjoner med tilganger i mine organisasjoner" alene — det krever data om alle tilganger, som er nettopp det server-side `filter` skal returnere et begrenset utvalg av.
- **Ingen permanent sletting.** Deaktivering er sluttilstand. Kun reversibel.

## Dependencies

### Internal

- `src/common/components/layouts/ListPageLayout/` — listevisning-rammeverk.
- `src/common/components/layouts/DetailPageLayout/` — detaljside med topbar + tabbed content.
- `src/common/components/lists/NavigationList/` — for liste-til-detalj-navigasjon (Iter 2 listevisning).
- `src/common/components/lists/ActionList/` eller separat query for tilgangslisten på detaljsiden (Iter 2 `vise_tilganger`, Iter 3 `tildele_tilgang`/`fjerne_tilgang`).
- `src/common/hooks/` — `useDataListState`, `useDataListQuery`.
- `src/lib/auth/globalUserContext.ts` — `useMineLaresteder` for organisasjonskontekst (med tillegg av synlighet-via-tilganger og synlighet-via-ansvarlig som backend må eksponere).
- `src/domains/support/features/{Maskinbrukere,MaskinBruker}/` — **fjernes** når ny modul går i drift; rutene `/tilgangsstyring/maskinbrukere*` avvikles. Frem til da: parallelle moduler.
- `src/app/tilgangsstyring/` — ny rute må plasseres her (sannsynlig `/tilgangsstyring/applikasjoner` og `/tilgangsstyring/applikasjoner/[id]`). Bekreftes i plan-fasen.
- Oversettelsesfiler i `src/common/messages/nb/` — nye nøkler `domain.ApplikasjonerOverview.*`, `domain.ApplikasjonDetails.*`, `domain.ApplikasjonInformation.*`, m.fl.

### External

- **SuperGrafen / fs-sikt backend** — nye `Applikasjon`-typer, queries (`applikasjoner`, `applikasjon(id)`), filter-input, orderBy-input, mutations (`opprettApplikasjon`, `settPassordPaApplikasjon`, `settAnsvarligPaApplikasjon`, `redigerBeskrivelsePaApplikasjon`, `tildelTilgangTilApplikasjon`, `fjernTilgangFraApplikasjon`, `deaktiverApplikasjon`, `reaktiverApplikasjon`). Konkret schema-design er ikke del av denne analysen.
- **Feide / Maskinporten** — backend må slå opp og verifisere ID-er ved opprettelse, og slå opp visningsnavn. UI får dette via mutation-respons.

### Cross-agent (candidates — *ikke* filt før plan-fasen)

- **fs-sikt / SuperGraf-team:** trenger nye `Applikasjon`-relaterte queries, mutations og synlighetsregler beskrevet over. Schema-issue [#460](https://github.com/sikt-no/fs/issues/460) er allerede åpen for Iter 2. Iter 3 (opprette + tilgangsstyring + deaktivering) krever sannsynligvis en utvidelse av [#460](https://github.com/sikt-no/fs/issues/460) eller et oppfølger-issue. `bat-plan` skal revurdere hand-off og linke til konkrete query-/mutation-skisser.

## Requirements Impact

- **Krav dekket** (Iter 2, må-ha): K1 + K2 + K11 + K12 (listevisning og søk), K3 (se detaljer), K4 (vise tilganger), K5 (passordbytte), K18 (administrere ansvarlig), K19 (rediger beskrivelse).
- **Krav dekket** (Iter 3, må-ha): K6 + K13 (tildele tilgang), K7 + K14 (fjerne tilgang), K8 (opprette applikasjon), K9 (deaktivere/reaktivere).
- **Krav bevisst utelatt:** K10 (permanent sletting) — deaktivering er sluttilstand. Avklart i begge `systemkrav.md`.
- **`@could`-scenarier som skal vurderes i plan-fasen:**
  - Filtrere på tilgang i listevisning (`listevisning_og_sok.feature`).
  - Feide-gruppe som ansvarlig (`administrere_ansvarlig.feature`) — krever søk i grupper i tillegg til brukere.
  - Ansvarlig via feide-gruppe gir synlighet i listevisningen (`listevisning_og_sok.feature`).
- **Risiko:** Synlighetsregelen "ser også applikasjoner med tilganger i mine organisasjoner" er ikke trivielt å håndheve server-side uten å eksponere data om andre organisasjoners applikasjoner. Trenger avklaring med backend om de støtter denne join-en effektivt før plan-fase.

## Pattern Match Summary

**Cross-pattern:** `list-page-layout` + `detail-page-layout` (master-detail).

| Pattern | Score | Result |
| --- | --- | --- |
| list-page-layout-pattern | ≈98/100 | Match. Primær: "oversikt over", "liste over alle", "se en liste". Sekundære: filter, søk, sortering, paginering. NB-bonus. |
| detail-page-layout-pattern | ≈95/100 | Match. Primær: "detaljer for", "se detaljer", "detaljsiden for en applikasjon". Sekundære: rediger, [id]-rute, tabs (tilganger), handlinger. |
| domain-index-pattern | <30/100 | Ingen match. Dette er ikke en landing-side — det er konkret data-funksjonalitet under et eksisterende domain (`tilgangsstyring`). |

**Konsekvens:** Følg cross-pattern-doc-en [`list-page-layout--detail-page-layout.md`](../../.claude/skills/bat-fs-admin-patterns/cross-patterns/list-page-layout--detail-page-layout.md). **Referanseimplementasjon:** `src/domains/utdanning/features/EmnerOverview/` ↔ `src/domains/utdanning/features/EmneDetails/`.

**Anti-patterns som *eksplisitt* skal unngås** (begge dokumentert som hentet fra maskinbruker-POC-en):
- Klient-side søk med Fuse.js / `first: 1000` for hovedlisten — bruk `useDataListQuery` med server-side `filter`/`orderBy`.
- Klient-side filter/sortering for tilgangslisten på detaljsiden — bruk enten fragment-only (hvis enkelt) eller separat query med server-side filter (tilgangslisten har reelle filtre, så *separat query* er riktig her).

## Krav-input fra GitHub

- **Kilde-issue(s):** [#31](https://github.com/sikt-no/fs/issues/31) (initiativ) → [#434](https://github.com/sikt-no/fs/issues/434) + [#435](https://github.com/sikt-no/fs/issues/435) (sub-issues i scope).
- **Repo / branch:** `sikt-no/fs` @ `fruitbat` (branchen er identifisert via cross-referansen [#455](https://github.com/sikt-no/fs/issues/455) — "krav på fruitbat"; den står ikke direkte i body-en til #31/#434/#435).
- **Hentede `.feature`-filer:** se [`docs/ACTIVE/krav-input/manifest.md`](krav-input/manifest.md) for full liste med klikkbare lenker (12 filer: 7 for Iter 2, 5 for Iter 3).
- **Hentet:** 2026-05-18

## Open Questions

- [ ] **Synlighet via tilganger:** kan backend effektivt returnere applikasjoner *fra andre organisasjoner* som har tilganger inn i administratorens egne organisasjoner, uten å lekke data? Trenger bekreftelse fra SuperGraf-team før plan-fase. (Krav fra `listevisning_og_sok.feature` *Regel: Synlighet via administrasjonsrettigheter*.)
- [ ] **Rute-navn og plassering:** `/tilgangsstyring/applikasjoner` ved siden av `/tilgangsstyring/maskinbrukere`, eller direkte under `/`? Skissen viser breadcrumb "Hjem / Tilgangsstyring / Applikasjoner", så `/tilgangsstyring/applikasjoner` er sannsynlig. Bekreftes i plan-fase.
- [ ] **Når kan `/tilgangsstyring/maskinbrukere`-koden fjernes?** Iter 2 dekker ikke alt POC-en gjør, men #31 sier den ikke er innført. Avklare avviklings-timing (sannsynlig: etter Iter 3 er i prod). Cross-referert i [#455](https://github.com/sikt-no/fs/issues/455).
- [ ] **`@could`-scenarier:** Skal Iter 2 inkludere "filter på tilgang" og feide-gruppe-ansvarlig nå, eller utsette til Iter 4 (`03 Iterasjon 4`)? Avklares med PO i plan-fase.
- [ ] **Passordbytte-respons:** returnerer mutationen det rå passordet i respons-feltet (basic auth-streng), eller en signert URL som UI-en gjør én ekstra GET mot? Sikkerhets-modellen påvirker UI-håndteringen (logging, cache, copy-to-clipboard-knappen).
- [ ] **Identitetsleverandør-ikon i listen:** skissen viser et "ID"-ikon i listevisningen. Bekrefte at vi har Sikt-ikoner for Feide / Maskinporten / FS, eller om vi bare bruker tekst-tag.

---

*Generert av `bat-analyze`. Pattern-detektering kjørt via `bat-fs-admin-patterns` (match: cross-pattern `list-page-layout` + `detail-page-layout`). Krav-input hentet via `fs-github`-skillen. Neste steg: `bat-plan`.*
