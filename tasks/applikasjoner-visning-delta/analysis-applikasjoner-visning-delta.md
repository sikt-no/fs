# Analysis: Applikasjoner-visning delta (filtervalg og synlighet)

## Problem Statement

Delta-iterasjonen presiserer to ting i applikasjons-flyten:

1. **Hvor filterkildene for miljø og organisasjon kommer fra** — både i listevisningen (`/tilgangsstyring/applikasjoner`) og på Tilganger-fanen på detaljsiden (`/tilgangsstyring/applikasjoner/[id]`). Listevisning-filtrene er **rolle-utledet** (to grupper: admin-egne organisasjoner + organisasjoner som eier applikasjoner med tilganger inn i admin-egne data). Tilgangsfane-filtrene er **innhold-utledet** fra den rolle-filtrerte ufiltrerte tilgangslisten.
2. **En ny `Regel: Synlighet for tilganger`** — tilgangslisten skal være rolle-filtrert på serversiden, men uten UI-signal i frontend.

Spec-en (`spec-changes-2026-06-16-b0e8de5.md`) er kilde for *hva* som endres. Denne analysen vurderer *hvordan* den eksisterende koden står seg mot kravene.

## Current State

Greenfield-byggingen (`docs/specs/31-grunnleggende-selvbetjent-tilgangsstyring/`, Task #1–#16) har levert hele rammeverket: `ListPageLayout`/`DetailPageLayout`, `useDataListState`/`useDataListQuery`-hooks, alle fire filtre i begge kontekster, riktige defaults, sortering og pagination. Layout-laget er **ikke** påvirket av denne delta-en.

Kjernen ligger i kildene som driver filterelementene. Status per fil:

### Listevisning (`src/domains/tilgangsstyring/features/ApplikasjonerOverview/`)

- **`ApplikasjonerOverview.tsx`** + `ApplikasjonerFilter.tsx` + state-hook (`useGetApplikasjonerState.tsx`) + query-hook (`useGetApplikasjoner.tsx`) er på plass og følger fs-admin-mønsteret.
- **Miljø-filter** (`components/filter/ApplikasjonerMiljoFilter/ApplikasjonerMiljoFilter.tsx:40-43`): options er **hardkodet inline** som `[{ value: 'demo', label: t('miljoDemo') }, { value: 'prod', label: t('miljoProd') }]`. Komponent-kommentaren (linje 30-32) flagger eksplisitt at dette er en demo/prod-stub som skal byttes ut når schema lander.
- **Organisasjon-filter** (`ApplikasjonerOrganisasjonFilter.tsx:36`): options hentes via `useGetMineApplikasjonsAdminOrganisasjoner` — en query som **per dagens kontrakt kun returnerer admin-egne organisasjoner** (gruppe (a)). Komponent-kommentaren (linje 21-23) sier eksplisitt: *«This intentionally does not show every org the admin can 'see' (synlighet is server-enforced for the list itself); the filter narrows within the admin's own orgs only»*. Den intensjonen er nå **utdatert** mot delta-en.
- **State-hook** (`useGetApplikasjonerState.tsx:22-23`) har riktig konvensjon: `eierOrganisasjonskode` er bevisst utelatt fra URL-state; backend håndhever synlighet for *applikasjonslisten*. Den biten stemmer fortsatt.
- **Query-hook** (`useGetApplikasjoner.tsx`) bruker `useDataListQuery` mot operasjons-navnet `applikasjoner` — server-side filter/orderBy/pagination som det skal.

### Tilgangsfanen (`src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/`)

- **`ApplikasjonTilganger.tsx`** + filter-komponent + state-hook + query-hook er på plass.
- **Miljø-filter** (`ApplikasjonTilgangerMiljoFilter.tsx:39-42`): samme hardkodede `[demo, prod]`-stub. Kommentar linje 29: *«Options are kept inline (demo / prod) — same as ApplikasjonerMiljoFilter»*.
- **Organisasjon-filter** (`ApplikasjonTilgangerOrganisasjonFilter.tsx:9, 34`): importerer og bruker **samme** `useGetMineApplikasjonsAdminOrganisasjoner`-hook som listevisningen. Komponent-kommentaren (linje 22) sier *«Reuses the same hook as the list-page filter»* — som nå er feil to ganger over: kilden er feil i listevisningen, og prinsippet på tab-en skulle uansett vært et annet (innhold-utledet, ikke admin-org-utledet).
- **Query-hook** (`useGetApplikasjonTilganger.tsx`): henter `applikasjon(id) { tilganger(...) }` via operasjon `applikasjonMedTilganger` med server-side filter/orderBy/pagination. Hooken sender ingen rolle-kontekst — den forventer at server-siden allerede har rolle-filtrert lista.

### Mock-API (`src/mocks/applikasjoner/`)

- **Listevisning-synlighet er korrekt mocket.** `SYNLIGE_APPLIKASJONER` (`fixtures/applikasjoner.ts:572`) er allerede definert som unionen av (a) applikasjoner i admin-egne organisasjoner + (b) applikasjoner i andre organisasjoner med tilganger inn i admin-egne data — nøyaktig kravsspesifisert synlighet. Handleren `applikasjoner` (queries.ts:197-211) bruker dette settet.
- **`mineApplikasjonsAdminOrganisasjoner`-handleren** (queries.ts:353-359) returnerer bare gruppe (a) — admin-egne organisasjoner (`MINE_ADMIN_ORGANISASJONER`). Det er **ikke** unionen som listevisning-filteret nå må vise.
- **Tilgangs-listen rolle-filtreres IKKE i mock-handleren.** `buildApplikasjonMedTilgangerResponse` (queries.ts:237-253) returnerer alle `a.tilganger` for applikasjonen — uten å skille på om brukeren administrerer eierorganisasjonen eller bare har data-tilgang i en annen organisasjon.
- Det finnes ingen mock-query for «miljøer admin har innsyn i» — verken som rolle-utledet eller innhold-utledet kilde.

## Key Findings

1. **Layout og hook-mønstre er uberørt.** Delta-en endrer ikke filer som `ApplikasjonerOverview.tsx`, `ApplikasjonDetails.tsx`, `useGetApplikasjonerState.tsx`, eller `useGetApplikasjonTilgangerState.tsx`. URL-state, pagination, `useMineLaresteder`-integrasjon, navigering list → detalj er alt på plass.

2. **Fire `Select`-komponenter må refaktoreres til å hente options fra serveren** — to i listevisningen, to på tilgangsfanen. Komponentene er fire, men bare to *kilder*: én rolle-utledet (listevisning) og én innhold-utledet (tilgangsfane).

3. **Det finnes ingen nåværende kilde for de nye filterlistene.** `useGetMineApplikasjonsAdminOrganisasjoner` dekker bare gruppe (a) for listevisningen. Miljø-options er rene konstanter (`demo`/`prod`). Begge må erstattes / utvides — det er en ekte backend-endring, ikke en omkobling av eksisterende felt.

4. **«Regel: Synlighet for tilganger» har ingen frontend-effekt.** Frontenden sender ikke rolle-kontekst og må ikke vise UI-signal (bekreftet i åpent spørsmål i spec-en). Hele regelen er en **producer-side endring**: `applikasjon(id).tilganger` må returnere bare det rolle-tillatte settet. Hva frontenden mottar definerer også hva tilgangsfane-filtrene kan derives fra — kontrakten henger sammen.

5. **Apollo-cache krever oppmerksomhet på tilgangs-listen.** Etter delta-en er tilgangslisten kontekst-avhengig (ulike admin-brukere ser ulike sett for samme `Applikasjon:id`). `cacheConfig.ts` har allerede `nodesCursorPagination(['filter', 'orderBy'])` som key-args på `Applikasjon.fields.tilganger`. Cache-key bygger på `filter+orderBy`, **ikke** på rolle/persona. Hvis frontend-koden noen gang ble brukt av to ulike admins i samme klient-instans (typisk ved persona-bytte), ville cachen krysskontaminere. Det er en kant — i praksis bytter brukere session, ikke persona innad i samme session — men verdt å adresere når plan-fasen vurderer cache-invalidering.

6. **TRANSITIONAL-kommentarene i kode-basen er ikke samkjørt med dette delta-et.** Filene viser fortsatt til `docs/specs/31-grunnleggende-selvbetjent-tilgangsstyring` som «sannhetskilde for shapes». Det er fortsatt riktig for *strukturen* (ikke endret i denne delta-en), men skjema-utvidelsene som delta-en krever (nye/utvidede queries for filter-kilder, nytt rolle-filter på tilganger) er per i dag *ikke* dekket der. Plan-fasen må oppdatere mock-API + manuelle typer i samme runde.

## Technical Constraints

- **Sikt Design System + fs-admin-list-filters**: `Select` med en `"Alle X"`-første option som default — alle fire komponenter er allerede i tråd med dette. Beholdes som-er.
- **fs-admin-inputs §10 (`disabled` når ingenting å velge)**: `ApplikasjonerOrganisasjonFilter.tsx:62` setter `disabled={loading || options.length === 0}`. Det samme må gjelde for de nye miljø- og organisasjon-Selects når serveren er kilde, ikke en hardkodet enum.
- **Aldri `eierOrganisasjonskode`/`organisasjonskode` i URL-state** (cross-pattern best practice). Konvensjonen er allerede etablert; må videreføres når nye options-hooks introduseres.
- **GraphQL-konsument-konvensjoner** (`graphql-consumer`-skillen): nye queries for filter-options følger `useQuery`/`useSuspenseQuery`-mønsteret, med codegen-flyt når schema lander. Inntil da: følg samme TRANSITIONAL-mønster som `useGetMineApplikasjonsAdminOrganisasjoner` (inline `gql` + manuelle typer + MSW-handler).
- **`useDataListQuery` med server-side filter/orderBy** for selve listene — anti-pattern (`Maskinbrukere` med `first: 1000` + Fuse.js) skal **ikke** etableres. Dagens implementasjon overholder dette.
- **Alfabetisk sortering av options** i alle fire dropdowns (krav-tekst). Backend bør sortere i kilden; frontend ikke re-sortere uten grunn (`MINE_ADMIN_ORGANISASJONER` er allerede alfabetisk i mock, men nye kilde-queries må gjøre det samme).

## Dependencies

### Internal

- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerMiljoFilter/` — bytt hardkodet liste mot ny hook.
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/components/filter/ApplikasjonerOrganisasjonFilter/` — bytt fra `useGetMineApplikasjonsAdminOrganisasjoner` til ny utvidet kilde (eller utvid eksisterende hook med (b)).
- `src/domains/tilgangsstyring/features/ApplikasjonerOverview/hooks/useGetMineApplikasjonsAdminOrganisasjoner.tsx` — vurder å beholde for nettopp gating-bruken (`Opprett applikasjon`-knapp), siden den fortsatt er korrekt for *administrerbare* organisasjoner. Filterkilden er en *separat* hook.
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerMiljoFilter/` — bytt fra hardkodet liste til content-derived (fra det rolle-filtrerte tilgangs-sett-svaret).
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/components/ApplikasjonTilgangerFilter/filter/ApplikasjonTilgangerOrganisasjonFilter/` — samme: content-derived.
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/components/ApplikasjonTilganger/hooks/useGetApplikasjonTilganger.tsx` — ingen frontend-endring, men antar at server-svaret allerede er rolle-filtrert.
- `src/mocks/applikasjoner/handlers/queries.ts` + `src/mocks/applikasjoner/fixtures/*` — utvide eksisterende handler `mineApplikasjonsAdminOrganisasjoner` eller legge til to nye handlers for de utvidede filter-kildene; legge til persona-rolle-filter i `buildApplikasjonMedTilgangerResponse`.
- Oversettelses-nøkler under `src/messages/nb/domains/tilgangsstyring/` — eventuelle nye `*Loading`/`*Empty`-strenger hvis options-listen kan være tom.
- A11y-tester for de fire filter-komponentene må re-validere når kildene byttes.

### External

- **Apollo Client 4** + nuqs URL-state — uberørt.
- Sikt Design System (`@sikt/sds-select`) — uberørt.
- `next-intl` (filter-labels og «Alle …»-tekster) — uberørt.

### Cross-contributor

- **fs-plattform (producer-side schema)** — flere endringer:
  - **Listevisning, miljø-kilde**: ny query (forslag: `mineSynligeMiljoer`) som returnerer unionen av miljøer der admin-egne applikasjoner kan ha tilganger, og miljøer der andre organisasjoner sine applikasjoner har tilganger inn i admin-egne data. Hvert miljø returneres én gang, alfabetisk.
  - **Listevisning, organisasjon-kilde**: utvid `mineApplikasjonsAdminOrganisasjoner` til union (a) + (b), eller (renere) introduser en separat query (forslag: `mineSynligeOrganisasjoner`) og behold den eksisterende for «administrerbare» (Opprett-gating). Det er en semantisk forskjell som ikke bør slås sammen.
  - **Tilgangs-listen, rolle-filter**: `applikasjon(id).tilganger` må filtrere på server-siden basert på påloggede admin-roller — eier-admin ser alt, kryss-org-admin ser bare tilganger inn i egne data. Implementeres i WHERE-clause på databasen, ikke i en valgfri filter-input (det er en *autorisasjons*-grense, ikke en *brukervalg*-grense).
  - **Tilgangsfane, filter-kilder**: ingen nye queries — disse derives client-side fra `tilganger.nodes`-svaret (etter at det er rolle-filtrert). Det betyr at *responskvalitet* av tilganger-queryen er det som bestemmer riktigheten av filtrene.
  - Hand-off til `bat-graphql-dev` i plan-fasen for å lage utkast-skjema med begrunnelse mot producer-guidelines.

- **Backend-team / database**: synlighet-regelen for tilganger må implementeres i `Applikasjon.tilganger`-resolveren — typisk join mot admin-roller for innlogget bruker. Krever at JWT/session-context er tilgjengelig i resolveren (er det allerede for `applikasjoner`-listen).

- **QA / brukertest**: åpent spørsmål om rolle-filtrert tilgangsliste skal ha UI-signal er avklart til «nei» i denne iterasjonen. Hvis brukertest avdekker forvirring, kan markering legges til senere uten å endre kjernekravet (notert i spec-en).

## Requirements Impact

- **Krav addressed today** (uten endring):
  - `K1` (liste over applikasjoner), `K2` (søk og filtrering) på struktur-nivå — layout, paginering, kombi-filter.
  - `Tilgjengelige statuser i filter` + `Filtrere på status` — hardkodet i `ApplikasjonerStatusFilter` med riktige verdier og default, samsvarer med krav.
  - `Tilgjengelige tilknytninger i filter` + `Filtrere tilgangsliste på tilknytning` — `ApplikasjonTilgangerTilknytningFilter` allerede på plass med tre options.
  - `Se tilganger for en applikasjon` (formuleringsendring «alle tilganger» → «tilganger») — endrer ikke frontend-tekst eller -kode; bare en presisering som gjør rom for rolle-filtreringen.
  - `Arvet tilgang er merket med opphav` + `Arvet tilgang med flere opphav listes kun én gang` — implementert via `arvetFra`-array på nodet. Uendret av delta-en.
  - Cross-pattern URL-state (back-button bevarer filtre) — uendret.

- **Krav at risk** (matcher ikke dagens kode):
  - **`Tilgjengelige miljøer i filter` (listevisning)** — dagens kilde er en hardkodet `[demo, prod]`-konstant. Krav: rolle-utledet union av (a) og (b). **Gap.**
  - **`Tilgjengelige organisasjoner i filter` (listevisning)** — dagens kilde er bare gruppe (a) via `mineApplikasjonsAdminOrganisasjoner`. Krav: union av (a) og (b). **Gap.**
  - **`Tilgjengelige miljøer i filter` (tilganger-tab)** — dagens kilde er samme hardkodede `[demo, prod]`. Krav: innhold-utledet fra ufiltrert (rolle-filtrert) tilgangsliste. **Gap.**
  - **`Tilgjengelige organisasjoner i filter` (tilganger-tab)** — dagens kilde er `mineApplikasjonsAdminOrganisasjoner` (admin-egne). Krav: innhold-utledet fra ufiltrert (rolle-filtrert) tilgangsliste. **Gap.**
  - **`Regel: Synlighet for tilganger`** (begge scenarier) — dagens server-side (mock) returnerer alle tilganger uavhengig av rolle; producer-side må implementeres. **Gap.**

- **Krav nye / discovered** (ikke i krav-teksten, men implisitt av kontrakten):
  - Filter-kilde-queries må respektere samme bruker-session som applikasjon-listen — JWT/context-propagering må verifiseres for de nye endepunktene.
  - Når options-listen for et filter er **tom** (ingen miljøer eller ingen organisasjoner sett av admin), bør `Select` være `disabled` (per fs-admin-inputs §10) men fortsatt vise «Alle X» — det er en tom-tilstand, ikke en feiltilstand.

## Krav-input referanse

- **Spec-dokument:** [`spec-changes-2026-06-16-b0e8de5.md`](spec-changes-2026-06-16-b0e8de5.md)
- **Krav-input-manifest:** før/etter-tre under [`krav-input/changes/2026-06-16-b0e8de5/`](krav-input/changes/2026-06-16-b0e8de5/)
- **Producer-spec (greenfield):** `docs/specs/31-grunnleggende-selvbetjent-tilgangsstyring/spec-applikasjoner.md` (i fs-admin-repoet, lokal) — referert til av TRANSITIONAL-kommentarer i koden som «sannhetskilde for shapes»

## Open Questions

- [x] ~~**Schema-form for de utvidede filter-kildene (listevisning):** skal vi (a) utvide eksisterende `mineApplikasjonsAdminOrganisasjoner` til union (a)+(b) — bryter den semantiske betydningen «administrerbare» som brukes til Opprett-gating — eller (b) legge til en *ny* query (`mineSynligeOrganisasjoner` / `mineSynligeMiljoer`) og beholde den eksisterende for gating?~~ **Beslutning:** variant (b) — to separate queries. `mineApplikasjonsAdminOrganisasjoner` beholdes uendret som «administrerbare» (Opprett-gating-semantikk). Nye queries `mineSynligeOrganisasjoner` og `mineSynligeMiljoer` introduseres for filterkildene i listevisningen, og returnerer unionen av (a)+(b). Begrunnelse: de to bruksområdene er semantisk forskjellige — gate-knappen handler om *redigeringsrett*, filteret om *innsynsscope*. Sammenslåing ville koblet to uavhengige forretningsregler i samme felt og brutt kontrakten for én av dem ved fremtidig endring.
- [x] ~~**Skal tilgangsfane-filtrene derives client-side fra `tilganger.nodes`-svaret, eller eksponeres som egne server-felter på `Applikasjon`-typen** (f.eks. `Applikasjon.tilgangerMiljoer`, `Applikasjon.tilgangerOrganisasjoner`)?~~ **Beslutning:** server-side felter — `Applikasjon.tilgangerMiljoer` og `Applikasjon.tilgangerOrganisasjoner`, returnert i samme `applikasjonMedTilganger`-query (ingen ekstra round-trip). Begrunnelse: client-side derivasjon ville stille-skjult options som ligger lenger ned i den paginerte connection (default `first: 50`, en applikasjon med 200 tilganger kan spenne flere miljøer enn de første 50 viser) — det er silent failure, ikke synlig feil. Server-side felter bruker samme WHERE-clause / rolle-filter som connection allerede har, så autorisasjonsgrensen forblir konsistent. Begge feltene returnerer alfabetisk, hver entitet kun én gang.
- [x] ~~**Skal `useGetMineApplikasjonsAdminOrganisasjoner`-hooken (og dens nåværende bruk i `ApplikasjonerOrganisasjonFilter`) byttes ut helt, eller beholdes side om side med en ny `useGetMineSynligeOrganisasjoner`?**~~ **Beslutning:** behold + ny hook. `useGetMineApplikasjonsAdminOrganisasjoner` forblir uendret og dekker fire eksisterende redigeringsrett-bruksområder (Opprett-knapp-gating i `ApplikasjonerOverview.tsx:47`, `OpprettApplikasjonModal.tsx:72`, `TildelTilgangModal.tsx:77`, `FjernTilgangModal.tsx:94`). To nye hooks introduseres for listevisning-filtrene: `useGetMineSynligeOrganisasjoner` og `useGetMineSynligeMiljoer` — som returnerer unionen (a)+(b) per beslutning #1. Tilgangsfane-filtrene trenger ikke ny hook — leser server-felt `Applikasjon.tilgangerMiljoer` / `tilgangerOrganisasjoner` per beslutning #2. Navnemønster: `Admin-` = redigeringsrett, `Synlige-` = innsyn på listenivå, `Applikasjon.tilganger*` = innhold-utledet per applikasjon.
- [x] ~~**Apollo cache-invalidering ved rolle/persona-bytte:** trenger Tilganger-fane-cachen en form for `cache.evict` på `Applikasjon:id.tilganger` når bruker-context endres, eller er session-skifte alltid en full page-reload uansett?~~ **Beslutning:** ingen ny invalidering kreves. Fs-admin har allerede `usePersonaOverride.applyPersonaChange` (`src/common/lib/persona/hooks/usePersonaOverride.ts:32-53`) som ved persona-bytte kjører `apolloClient.refetchQueries({ include: 'active', updateCache: cache.reset })` — wiper hele cachen og re-fetcher alle aktive queries atomisk med nye persona-headers. Det dekker både `Applikasjon.tilganger` og `mineSynlige*`-hookene som alt annet, og er produksjons-herdet (kommentar i koden flagger at den valgte formuleringen unngår Apollo error 89). Full Feide-relogin er uansett page-load. Plan-fasen bør likevel verifisere at `usePersonaOverride` er aktivert i alle miljøer hvor tilgangsstyring brukes.
- [x] ~~**Mock-API rolle-filtrering for tilganger:** persona-modellen i `src/mocks/applikasjoner/fixtures/` har `MINE_ADMIN_ORG_IDS` — skal mocken bruke det settet til å rolle-filtrere tilgangs-listen, eller forblir mocken bevisst «ufiltrert» og bruker venter på ekte backend for å verifisere?~~ **Beslutning:** implementer i mock. Utvid `buildApplikasjonMedTilgangerResponse` (`src/mocks/applikasjoner/handlers/queries.ts:237-253`) med rolle-filter basert på `MINE_ADMIN_ORG_IDS` — eier-admin (applikasjonens eier-org i `MINE_ADMIN_ORG_IDS`) ser alle tilganger, kryss-org-admin ser kun tilganger hvis `tilgang.organisasjon.id` er i `MINE_ADMIN_ORG_IDS`. Filter-kildene fra beslutning #2 (`Applikasjon.tilgangerMiljoer` / `tilgangerOrganisasjoner`) derives fra det rolle-filtrerte settet og returneres samme sted. Begrunnelse: ~15 linjer kode + 1 test gjør `Regel: Synlighet for tilganger` testbart end-to-end uten producer-rundtur; konsistent med hvordan `SYNLIGE_APPLIKASJONER` (`fixtures/applikasjoner.ts:572`) allerede modellerer synlighet på listevisnings-nivå. Plan-fasen plasserer dette i samme task som mock-handler-utvidelsen for `mineSynlige*`-queriene fra beslutning #1.
