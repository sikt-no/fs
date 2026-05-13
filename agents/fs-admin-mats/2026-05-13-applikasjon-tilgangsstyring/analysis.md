# Analysis: Applikasjon-tilgangsstyring (sak #31)

**Initiativ:** [`sikt-no/fs#31`](https://github.com/sikt-no/fs/issues/31) — *"Grunnleggende selvbetjent tilgangsstyring for applikasjoner via FS Admin"*
**Krav-branch:** `fruitbat`
**Dato:** 2026-05-13
**Agent:** fs-admin-mats
**Mode:** Analyse (ingen kode foreslås — det er planleggingsfasens jobb).

## Problem Statement

Sak #31 erstatter dagens maskinbruker-POC i FS Admin med en helt ny, selvbetjent løsning kalt **applikasjon-tilgangsstyring**. To grupper trenger den:

1. **Lokale administratorer** ved lærestedene (kunde-side) med applikasjonsadministrator-rolle — skal kunne administrere sine egne integrasjoner uten å gå via Sikt support.
2. **Sikt support / nasjonalt forvaltningsansvarlig** — trenger tverr-organisatorisk oversikt og dataeier-ansvar for nasjonale registre (Utdanningsregister, RUST).

Initiativet er stort: 17 krav-filer fordelt på 4 iterasjoner (1 676 linjer Gherkin-krav på `fruitbat`). Kravowner har eksplisitt instruert at:

- **Den eksisterende maskinbruker-POC-en skal fjernes** — det skal ikke bygges videre på den.
- **Nye GraphQL-spørringer** skal lages — dagens maskinbruker-spørringer skal ikke gjenbrukes.
- Det er en **greenfield-erstatning**, ikke en migrering.

> **Note for andre agenter:** Filsti-referanser nedenfor peker på `fs-admin`-repoen (`gitlab.sikt.no/studieadm/fs-admin`), ikke `sikt-no/fs`. Stiene er på formen `src/...` slik de finnes der.

## Current State

### Dagens maskinbruker-POC i `fs-admin`

POC-en er en eksperimentell støttefunksjon (alle queries har `Feature-Flags: experimental`-header) som lar Sikt support se maskinbrukere og generere nye passord. Den er **ikke** innført i produksjon (per krav-body på #31).

#### Route-tre

- `src/app/tilgangsstyring/maskinbrukere/layout.tsx` — breadcrumb
- `src/app/tilgangsstyring/maskinbrukere/page.tsx` — listevisning
- `src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/layout.tsx`
- `src/app/tilgangsstyring/maskinbrukere/[maskinbrukerid]/page.tsx` — detaljside

#### Feature-implementasjon — to parallelle mapper

- `src/domains/support/features/MaskinBruker/` — **detaljside**, sannsynligvis aktiv. Inneholder `Maskinbruker.tsx`, `MaskinbrukerInformation`, `MigrerPassord(+Dialog)`, `DataTilganger/*`, `ApiTilganger/*`, filter, hooks (`useGetMaskinbruker`, to Zustand-stores).
- `src/domains/support/features/Maskinbrukere/` — **listevisning**, *muligens dead code* (parallelt navn med casing-forskjell). Inneholder `Maskinbrukere.tsx`, `MaskinbrukereResultList`, fire filtre, dupliserte hooks (`useGetMaskinbrukere`, `useGetAllMaskinbrukere`, duplikat av `useGetMaskinbruker`).

Total telling fra eksplorerende inventar: **41 unike kildefiler, ~686 grep-treff** av "maskinbruker" (case-insensitive).

#### GraphQL-operasjoner (alle med `Feature-Flags: experimental`)

- Query `maskinbrukere` (paginert liste, filtrert via `MaskinbrukereFilter` input)
- Query `maskinbrukereGittIder([ID])`
- Query `maskinbrukerDetaljer($id: ID!)` (inline i `useGetMaskinbruker.ts:28-90`)
- Query `maskinbrukerDetaljerAlt` (alternativ — dupliserer detaljer)
- Query `tilgangsroller` (henter `apier` og `datatilgangsroller` med maskinbruker-relasjoner)
- Query `apiTilgangerForMaskinbrukere`, `apiTilgangerForMaskinbrukereV2` (V1 = deprecated, V2 = aktiv)
- Query `dataTilgangerForMaskinbrukere`
- Mutation `MaskinbrukerGenererPassord($input: GenererOgSettNyttPassordInput!) -> { passord }`

#### Genererte typer

`src/__generated__/graphql.ts` har ~241 linjer maskinbruker-typer: `Maskinbruker`, `ApiTilgangForMaskinbruker(V2)`, `DatatilgangForMaskinbruker`, alle tilhørende `*Connection`/`*ConnectionEdge`, `MaskinbrukereFilter`, `MaskinbrukerApiTilgangerFilterInput(V2)`, koblings-connections via `Kontaktperson` og `AuthOrganisasjon`. Genereres på nytt fra schema — fjernes automatisk når schema endres.

#### Inngangspunkter i UI-en

- `src/features/FSAdminIndex/FSAdminIndex.tsx:139-142` — kort på landingssiden
- `src/features/Header/Menu/Menu.tsx:108-109` — header-meny
- `src/domains/search/features/CommandPalette/hooks/useCommands.tsx:81-84` — Ctrl+K command
- `src/domains/support/features/TilgangsstyringIndex/TilgangsstyringIndex.tsx:58,61,66` — "Tilgangsstyring"-hub

#### Oversettelser

- `src/common/messages/nb/support.json` — `Maskinbruker*` og `Maskinbrukere*` (~12 nøkler)
- `src/common/messages/nb/features.json` — `maskinbrukere*`
- `src/common/messages/nb/search.json` — `maskinbruker.name`

#### Tester

- `src/features/FSAdminIndex/FSAdminIndex.a11y.test.tsx:33-35,159-161,187` — mocker maskinbruker-label
- Ingen `Maskinbruker*.a11y.test.tsx` ble funnet i selve feature-mappene → **a11y-dekning mangler for den eksisterende POC-en** (vil dukke opp som krav når den nye løsningen bygges, jf. CLAUDE.md: "Every component MUST have ComponentName.a11y.test.tsx").

### Hva sak #31 leverer (krav-side)

Strukturen på krav-settet (på branchen `fruitbat` i denne coord-repoen, under `krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/`):

#### Iterasjon 2 — Support: Oversikt og passordbytte (#434)

*Lesefokus + lett redigering. Ingen tilgangsendring.*

| ID | Feature | Issues |
|---|---|---|
| BRU-APP-API-001 | Listevisning og søk i applikasjoner (felt: navn, beskrivelse, miljøer, ansvarlig, organisasjon, status; paginering 50; tekstsøk + filter på organisasjon, tilgang, status; synlighet styrt av rolle + ansvarlig-relasjon) | #438, #448, #449 |
| BRU-APP-API-002 | Se detaljer (grunnleggende info, sporing, miljøer, ansvarlig) | #439 |
| BRU-APP-API-003 | Vise tilganger (tab, tilgangskode+miljø, filter, sortering, paginering) | #440 |
| BRU-APP-API-004 | Passordbytte (systemgenerert, basic auth, ett aktivt om gangen, vises én gang) | #441 |
| BRU-APP-API-005 | Administrere ansvarlig (feide-bruker fra applikasjonens organisasjon; feide-gruppe = `@could`) | #442 |
| BRU-APP-API-006 | Redigere beskrivelse | #443 |

#### Iterasjon 3 — Grunnleggende tilgangsstyring for intern support (#435)

*Skriveoperasjoner som påvirker tilgangen. Forutsetter Iter 2.*

| ID | Feature | Issues |
|---|---|---|
| BRU-APP-API-007 | Tildele tilgang (én eller flere tilganger i ett eksplisitt miljø; allerede tildelte gråtoned; valgliste begrenset til rettigheter; tildeling i nytt miljø → applikasjon aktiv) | #444, #450 |
| BRU-APP-API-008 | Fjerne tilgang (bekreftelsesdialog; bulk innen samme miljø) | #445, #451 |
| BRU-APP-API-009 | Opprette applikasjon (idP Feide/Maskinporten kun, ID verifiseres mot kilde, intern unik ID, globalt unikt visningsnavn; **FS er utfaset**) | #446 |
| BRU-APP-API-010 | Deaktivere/reaktivere (reversibel; beholder tilgangene; ingen permanent sletting) | #447 |

#### Iterasjon 4 — Grunnleggende selvbetjent administrasjon

*Selvbetjeningen er **allerede** dekket av rettighetsregler i Iter 2/3. Iter 4 er primært sporbarhet.*

| ID | Feature | Issues |
|---|---|---|
| BRU-APP-API-016 | Endringslogg (`@draft`, 4 åpne spørsmål om hva som logges, retention, paginering) | #453 |

#### Nice to have — Tilleggsfunksjonalitet (#437)

| ID | Feature | Issues |
|---|---|---|
| BRU-APP-API-015 | Sist brukt tidspunkt (`@could @draft`) | #452 |
| BRU-APP-API-017 | Masseadministrasjon av tilganger (`@could @draft`) | #454 |

### Gjennomgående domene-konsepter som er nye

| Konsept | Forklaring | Påvirkning |
|---|---|---|
| **Applikasjon** | Ny domeneentitet, erstatter "maskinbruker"/"API-bruker"-terminologien | Nye GraphQL-typer, nye URL-er, ny mental modell |
| **Identitetsleverandør** | Hver applikasjon har én av: **Feide**, **Maskinporten**, eller (legacy) **FS**. Settes ved opprettelse, kan ikke endres. FS er utfaset for nye. | Nye enum-verdier; ID-er verifiseres mot kilden; visningsnavn hentes fra idP |
| **Miljø** | Tilganger gjelder per miljø; en applikasjon kan ha tilganger i flere miljøer; tildeling i nytt miljø "aktiverer" applikasjonen der | Eksplisitt miljøvalg ved tildeling; status er per-miljø |
| **Tilgang** | Det som tidligere het "rolle" / "datatilgang" / "api-tilgang" — kollapses til ett samlebegrep ("tilgang") med tilgangskode + miljø | Forenkler UI vs dagens dobbeltvisning (data/api) |
| **Ansvarlig** | Feide-bruker (eller feide-gruppe `@could`) fra applikasjonens organisasjon. Arver passordbytte-rett. | Ny relasjon — søk avgrenset til applikasjonens organisasjon |
| **applikasjonsadministrator-rollen** | Rolle for én eller flere organisasjoner. Bestemmer synlighet og redigeringsrettighet. | Rollesjekk styrer alle Iter 2/3-handlinger |
| **super-applikasjonsadministrator** | Global rolle — ser/administrerer alle på tvers av organisasjoner. Brukes av Sikt support. | Erstatter dagens "experimental feature flag"-gating |
| **Status: aktiv / deaktivert** | Deaktivering er reversibel og bevarer tilgangene. Ingen permanent sletting (K10 utelatt). | Ny lifecycle-modell |

## Key Findings

1. **Greenfield, ikke migrering.** Kravowner instruerer eksplisitt at det skal lages nye GraphQL-spørringer og at den eksisterende POC-en skal fjernes. Det betyr en **parallell-implementasjon** — bygg ny side om side, riv ned gammel, ikke refaktorer.
2. **Parallelle mapper `MaskinBruker/` og `Maskinbrukere/` i dagens kode** — den eksplorerende inventaret oppdaget at `Maskinbrukere/` (listevisning) sannsynligvis er dead code, mens `MaskinBruker/` (detalj) er aktiv. Dette må bekreftes før noe slettes (sjekk om `Maskinbrukere`-eksporter brukes noen steder). Hvis bekreftet dead, kan den slettes **uavhengig** av sak #31-tempoet.
3. **GraphQL-schema for "applikasjon" eksisterer ikke ennå.** `grep -E "Applikasjon" schema.graphql` gir 0 treff. Hele typesystemet — `Applikasjon`, `Tilgang`, `Miljø`, `Ansvarlig`, `Identitetsleverandør`-enum, alle `*Connection`/`*Edge`, alle filter-inputs, alle mutations — må leveres av backend før fs-admin-implementasjonen kan starte for alvor. **Dette er den enkeltstående største blokkereren** for sak #31.
4. **Rolle-modellen er ny.** Dagens fs-admin har ingen `applikasjonsadministrator` eller `super-applikasjonsadministrator`-roller. Disse må eksponeres via UserActions / persona-mekanismen (jf. `5a1789e4a fix(auth): refetch user actions when persona override changes` — det finnes allerede et persona-system å henge dette på).
5. **Iterasjonsstrukturen er ikke 1:1 med sub-issue-strukturen.** Iter 4-folderen inneholder bare `endringslogg.feature` (issue #453, som offisielt er sub-issue av #437 "Nice to have"). Iter 4s "selvbetjent administrasjon" er i praksis ikke nye features — det er allerede dekket av Iter 2+3 via rolle-regler. Dette er ikke en feil; det er en bevisst avgjørelse dokumentert i `Iter 4/systemkrav.md`-notatene.
6. **Identitetsleverandør-verifisering krever sanntidsoppslag mot Feide og Maskinporten.** Opprettelse (BRU-APP-API-009) sier "Når jeg oppretter ... Og ID-en finnes hos `<identitetsleverandør>` Så er applikasjonen opprettet ... Og navnet på applikasjonen er hentet fra `<identitetsleverandør>`". Dette er en backend-mutation som kaller eksterne API-er — ikke noe fs-admin gjør selv. Frontend trenger bare "verifiser ID" + "opprett" mutations, men feilbildet (ID finnes ikke / allerede registrert / visningsnavn-kollisjon) må modelleres tydelig i mutation-responsen.
7. **Passordbytte-flyten har sterke krav til frontend-håndtering.** Generert passord vises kun én gang, skjult som standard, kopierbart, tilgjengelig kun frem til dialogen lukkes. Dette må implementeres uten å logge passordet i Apollo cache eller console (sensitiv data — ikke gjenbruk dagens `MaskinbrukerGenererPassord`-flyt direkte; sjekk om dagens implementasjon allerede har sikker håndtering, bruk det som mønster).
8. **Persona-override + UserActions-flyten er allerede modnet.** Den nylige fixen (`5a1789e4a fix(auth): refetch user actions when persona override changes`) viser at apollo-klienten kan håndtere rolle-bytte midt i sesjonen. Dette betyr at applikasjonsadministrator-rettigheter (som ofte vil være "for én av flere organisasjoner") kan henges på den eksisterende UserActions-mekanismen uten ny infrastruktur.
9. **Endringsloggen (#453) har fire formelle åpne spørsmål** (markert med `@openquestion` Gherkin-tag). Dette er i `@draft`-status og kan trygt skyves ut av første leveranseløp.
10. **Felles UI-mønster: filtrering + paginering 50** er gjentatt i flere features (listevisning, vise tilganger). FS Admin har allerede slike mønstre i andre features (`opptak`, `regelverk`) — gjenbruk eksisterende komponenter (`*Filter`, `*OrderBy`, `*ResultList`-mønster). Maskinbruker-POC-en har nettopp slike eksempler (`MaskinbrukereSearchFilter`, `OrganisationConnectionFilter`, `NeedsAttentionFilter`) — kan brukes som referanse selv om koden fjernes.

## Technical Constraints

- **Framework-stack** (fra `CLAUDE.md`): Next.js 16 App Router (webpack-bundler, *ikke* turbopack), React 19, Apollo Client 4, NextAuth.js + Feide OIDC, next-intl, Sikt Design System (`@sikt/sds-*`).
- **GraphQL-first**: schema-først med codegen. Frontend kan **ikke** skrive queries før schema har relevante typer. `npm run watch:codegen` på utvikling.
- **CSS Modules + Sikt Design System** — ingen generiske UI-biblioteker (eksplisitt forbudt i CLAUDE.md).
- **Norsk domenespråk, engelsk kode** — komponenter er PascalCase engelsk, men `Applikasjon`, `Tilgang`, `Ansvarlig` brukes som GraphQL-typenavn (norsk i datalaget).
- **Apollo auth flow** har en to-lags interceptor (`src/lib/apollo/authErrorInterceptor.ts` + `/api/graphql/route.ts`) som håndterer sesjonsutløp. Nye applikasjon-queries arver dette automatisk.
- **a11y-tester er obligatoriske** — alle nye komponenter må ha `*.a11y.test.tsx`. Maskinbruker-POC-en mangler dette — ny implementasjon må ikke arve mangelen.
- **Coverage-thresholds**: 60 % branches/functions/lines, 90 % statements (fra `CLAUDE.md`).
- **GraphQL-spørringer i `queries.ts`** plasseres kun *hvis* de deles mellom server- og client-komponent. Ellers ligger de inline i komponent-mappa. Ikke gjenbruk queries mellom forskjellige komponenter (CLAUDE.md-regel).
- **Branch-konvensjon**: `<user>/<issue-number>-<type>-<description>`. Conventional commits.
- **Persona-override**: `5a1789e4a` viser at user-actions refetches når persona-override endres — applikasjon-rollesjekker må respektere dette uten special-casing.
- **GraphQL proxy logging** ble nylig splittet (`74c721701`) i AUTH_FLOW vs GRAPHQL_PROXY akser — nye applikasjon-feilkoder skal følge eksisterende `AUTH_FLOW`-konvensjoner (f.eks. `SESSION_EXPIRED`) der relevant.
- **Norsk språk** — alle UI-tekster via `src/messages/nb/`. Bruk `/externalize-i18n`-kommando for å unngå hardkodede strenger.

## Dependencies

### Intern (fs-admin)

| Komponent / område | Hvorfor relevant |
|---|---|
| `src/app/tilgangsstyring/` route group | Ny ruteforesatt (sannsynligvis `/tilgangsstyring/applikasjoner/...`) — må sameksistere med dagens `maskinbrukere/` til sistnevnte slettes |
| `src/domains/support/features/TilgangsstyringIndex/` | Hub-side; må få nytt kort for "applikasjoner" og fjerne maskinbruker-kortet |
| `src/features/FSAdminIndex/FSAdminIndex.tsx` (landingsside) | Maskinbruker-kort må erstattes |
| `src/features/Header/Menu/Menu.tsx` | Menyentry må byttes |
| `src/domains/search/features/CommandPalette/hooks/useCommands.tsx` | Command palette må reflektere ny rute |
| `src/lib/apollo/*` | Ingen endringer ventet — eksisterende auth-flyt fungerer for nye queries |
| Persona / UserActions-systemet | Nye actions for `applikasjonsadministrator` / `super-applikasjonsadministrator` må hentes; verifiser at backend leverer dem |
| `src/common/messages/nb/*` | Nye nøkler for applikasjon-domenet; gamle maskinbruker-nøkler bort |
| `src/__generated__/{gql,graphql}.ts` | Regenereres når schema oppdateres — ingen manuell action |
| `schema.graphql` (lokal kopi) | Må oppdateres ved codegen for å peke på supergraf med nye typer |
| `routes.d.ts` | Auto-genereres via `generate:routes` — dekker både nye og gamle ruter til man fjerner gamle |

### Ekstern

| Avhengighet | Hva trengs |
|---|---|
| **Sikt Design System** | Eventuelt nytt: skjul/vis-passord-input, ID-verifisering-feltkomponent. Sannsynligvis dekket av eksisterende `sds-*`-pakker. Sjekk under planning. |
| **Feide og Maskinporten** | Backend kaller disse, ikke frontend — men feilmodellen må kommuniseres tydelig fra GraphQL-mutation til UI |
| **Apollo Client 4** | Cache-policies for `Applikasjon` (probably `keyFields: ["id"]`) må settes |

### Cross-agent (hand-off-kandidater)

> Disse er kandidater for issues filed via `agent-coord`. Brukeren bestemmer hvilke som skal opprettes.

**Target agent: `backend`** (registrert i `$COORD_REPO/agents/backend/`)

1. **GraphQL-schema for `applikasjon`-domenet** — *kritisk blokker for hele sak #31*
   Trengs: typer `Applikasjon`, `Tilgang`, `Miljø`, `Ansvarlig` (+ koblings-typer for Kontaktperson, AuthOrganisasjon), enum `Identitetsleverandør { Feide, Maskinporten, FS }` (FS markert deprecated), alle `*Connection`/`*Edge` for paginering, filter-inputs for liste-/tilgangs-spørringer.
   Queries: `applikasjoner(after, first, filter)`, `applikasjon(id: ID!)`, `tilganger`-listing (med filter på applikasjon/miljø/organisasjon).
   Mutations: `opprettApplikasjon`, `tildelTilgang(input)`, `fjernTilgang(input)`, `deaktiverApplikasjon`, `reaktiverApplikasjon`, `genererNyttPassord`, `settAnsvarlig`, `fjernAnsvarlig`, `oppdaterBeskrivelse`. Feilmodell: ID-verifisering-feil mot idP, visningsnavn-kollisjon, allerede-registrert-ID må kunne returneres distinkt (extension-codes a la `APPLIKASJON_VISNINGSNAVN_KOLLISJON`).
   Hvorfor blokkerer: Ingen frontend-implementasjon kan starte uten dette. Codegen krever schema-typer.

2. **UserActions / persona for `applikasjonsadministrator` og `super-applikasjonsadministrator`**
   Trengs: Nye `UserAction`-enum-verdier som returneres av eksisterende user-actions-spørringen, *med organisasjons-scoping* (en bruker har applikasjonsadministrator-rolle for organisasjon X, ikke globalt). Detalj: hvordan returneres "rolle for én av flere organisasjoner"? Foreslås: `applikasjonsadministratorForOrganisasjon: [OrganisasjonID]` i tillegg til boolean `superApplikasjonsadministrator`.
   Hvorfor blokkerer: Hele synlighets-modellen i Iter 2/3 baserer seg på rolle-sjekk i frontend.

3. **Identitetsleverandør-verifiseringsmutation** *(kan eventuelt slås sammen med opprettelses-mutation)*
   Spørsmål til backend-agent: skal frontend kalle en separat `verifiserIdentitetsleverandorID(idp, externalId)`-spørring før opprettelse for å gi tidlig feedback, eller skal opprettelses-mutation håndtere alt og frontend bare vise feilen? Påvirker UX (en eller to-stegs flyt).

4. **Endringslogg-domene (#453)** *(kan vente — `@draft`)*
   Trengs: Når backend har avklart hva som logges, retention, struktur. Foreløpig **kjør i parallell med Iter 4** — ingen blocker for Iter 2/3.

Sannsynligvis ingen andre cross-agent-hand-offs nødvendig (Feide/Maskinporten-integrasjonen er ren backend; design-system-endringer er internt Sikt-arbeid uten en registrert agent for det per i dag).

## Requirements Impact

Det finnes ingen `docs/ACTIVE/requirements-*.md` i fs-admin-repoen — kravene er Gherkin-filer i denne coord-repoen på `fruitbat`-branchen, og er også speilet lokalt hos fs-admin-agenten. Krav-koblingen brukes via `BRU-APP-API-NNN`-id-er og GitHub-saksnumrene 438–454.

| Krav-id | Dekker | Status etter dagens kode |
|---|---|---|
| BRU-APP-API-001 til -006 (Iter 2) | Lese-/lett-redigerings-flyt | **Ikke dekket** — krever ny applikasjon-løsning. Maskinbruker-POC dekker delvis listevisning og passordbytte, men på feil domene-modell. |
| BRU-APP-API-007 til -010 (Iter 3) | Skrive-operasjoner (opprett, tilgangsstyring, deaktiver) | **Ikke dekket** — eksisterende POC har kun passordbytte-mutation, ingen opprettelse eller tilgangstildeling. |
| BRU-APP-API-016 (Iter 4 — endringslogg) | Sporbarhet | **Ikke dekket** — ingen logg-visning eksisterer. `@draft` — kan vente. |
| BRU-APP-API-015, -017 (Nice-to-have) | Sist brukt, masseadmin | **Ikke dekket** — `@could @draft`. |

**Krav i risiko:** Iter 4-endringsloggen har fire `@openquestion`-scenarios. Hvis disse ikke avklares før Iter 4 startes, blir leveransen forsinket. Anbefaling: ta avklarings-runden parallelt med Iter 2-byggingen.

**Manglende krav som ble oppdaget**: ingen — kravsettet virker komplett for de fire iterasjonene. Det nevnes i Iter 3-systemkravet at "K10 (permanent sletting) er bevisst utelatt" — dette er konsistent ikke et hull.

## Krav-input fra GitHub

- **Kilde:** issue [`sikt-no/fs#31`](https://github.com/sikt-no/fs/issues/31) (initiativ) + sub-issues #434, #435, #437 og 14 leaf-issues (#438–#447, #452–#454, samt #448–#451 referert i feature-markører).
- **Linket PR(s):** Ingen åpen PR fra `fruitbat` mot `main` ennå.
- **Repo / ref:** `sikt-no/fs` @ `fruitbat`
- **Hentede `.feature`-filer:** 17 filer, totalt 1 676 linjer — speilet lokalt hos fs-admin-mats-agenten. På denne coord-repoen ligger originalene under `krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/`.
- **Hentet:** 2026-05-13

## Open Questions

> *Når disse blir besvart: behold valgmuligheten, legg til besluttet alternativ og begrunnelse, marker spørsmålet som besvart.*

### Avklaring med kravowner / produkteier

- [ ] **Er mappen `src/domains/support/features/Maskinbrukere/` (listevisning) faktisk dead code?** Inventaret antyder at `MaskinBruker/` (detalj) er den aktive, mens `Maskinbrukere/` parallelt kan være restmateriale. Bekreftes via runtime-sjekk + import-grep i planleggingsfasen.
- [ ] **Skal "applikasjon" få egen URL-rot (`/tilgangsstyring/applikasjoner/`), eller skal `/maskinbrukere/` redirectes til ny rute?** Krav-body på #31 sier "ny løsning" — antydning er at det skal være helt ny rute, men det er ikke eksplisitt.
- [ ] **Skal eksisterende maskinbruker-POC fjernes som første eller siste handling?** Argument for å fjerne først: rydder kontekstet, ingen forvirring om gjenbruk. Argument for å fjerne sist: bevarer fallback hvis produksjons-rollout av ny løsning skulle feile. Anbefales å diskutere i planleggings-fasen.
- [ ] **Skal feide-grupper som ansvarlig (BRU-APP-API-005 `@could`-scenarios) inkluderes i Iter 2-leveransen eller utsettes?** `@could` betyr offisielt utsettbar, men kunde-side admin-er ønsker det ofte.
- [ ] **Endringslogg åpne spørsmål** (4 stk i `endringslogg.feature`): hva logges, hva inneholder en post, retention, sortering/paginering/filtrering. Avklares før Iter 4 starter.

### Avklaring med backend-agent

- [ ] **GraphQL-schema-design:** Skal `Tilgang` være én flat type med `tilgangskode + miljø + organisasjon`, eller en kompositt med subreferanser? Påvirker hvor mye normalisering Apollo cache trenger.
- [ ] **ID-verifisering-flyten:** Egen verifiseringsmutation før opprettelse, eller alt-i-en opprettelses-mutation som returnerer strukturerte feil? Påvirker UX-flyt.
- [ ] **Visningsnavn-kollisjon:** Skal frontend sjekke unikhet ved input-tid (debounced), eller bare ved submit?
- [ ] **Rollemodell-eksponering:** Er `applikasjonsadministratorForOrganisasjon: [OrganisasjonID]` riktig kontrakt, eller skal det modelleres som en relasjon på `Person` / `Bruker`-typen?

### Avklaring innenfor fs-admin-mats-agent

- [ ] **Iterasjon-leveranse-rekkefølge:** Levere Iter 2 + 3 sammen (siden Iter 3 forutsetter Iter 2 og selvbetjent-flyt fra Iter 4 allerede er dekket av Iter 2/3-rettighetsregler), eller dele opp slik at Iter 2 lanseres alene først?
- [ ] **Hvor mye av dagens maskinbruker-UI-mønstre skal gjenbrukes som *kode-referanse* (ikke kopiering)?** F.eks. `MaskinbrukereSearchFilter` og `OrganisationConnectionFilter` har ferdige UI-mønstre. Ren copy-paste vil bryte instruksjonen om å "ikke bygge videre på dagens POC", men å bruke dem som visuell referanse er innenfor.

---

## Neste steg

1. **Bekreft scope** med kravowner / produkteier (se Open Questions).
2. **File hand-off-issue til `backend`-agent** for GraphQL-schema (kritisk blokker). Anbefales å bruke `agent-coord`-skillen med en link til denne analysen.
3. **Kjør `bat-plan`** når schema-design er enige om, med scope = Iter 2 alene (anbefalt minste leveringsenhet — gir lesefokus i produksjon, lite risiko, klar verdi for support).
4. **I parallell**: avklar de fire `@openquestion`-scenariene for endringsloggen (Iter 4) — kan tas på avklaringsmøte uten å blokkere Iter 2/3.
