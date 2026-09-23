## Title:

`Tilgangsstyring · Applikasjoner: producer-schema for filter-kilder og synlighet for tilganger`

---

## Sammendrag

Frontend-delta for applikasjoner-visning (sikt-no/fs#31 — "Grunnleggende selvbetjent tilgangsstyring") er ferdig implementert i fs-admin med mock-API som "live spec". Vi trenger producer-side schema og resolver-arbeid i fs-plattform / SuperGrafen for å erstatte mocken med ekte data.

Endringene er konservative og bakoverkompatible (kun tillegg — ingen breaking changes):

- **2 nye Query-felter** for listevisnings-filter-kilder (`mineSynligeOrganisasjoner`, `mineSynligeMiljoer`)
- **2 nye `Applikasjon`-felter** for tilganger-tab-filter-kilder (`tilgangerOrganisasjoner`, `tilgangerMiljoer`)
- **1 autorisasjons-grense** på den eksisterende `Applikasjon.tilganger`-resolveren (server-side WHERE-clause på rolle; ingen SDL-endring, kun resolver-kontrakt)

Eksisterende `mineApplikasjonsAdminOrganisasjoner`-query beholdes **uendret**. Den brukes fortsatt for "redigeringsrett"-gating (Opprett-knapp) på fire kall-steder i fs-admin og må ikke slås sammen med de nye queriene — semantikken er bevisst forskjellig (`Admin-` = redigeringsrett, `Synlige-` = innsynsscope).

---

## Lag A — SDL (ferdige felter)

Alle SDL-snutter er sitater fra fs-admin-planens `## GraphQL-endringer`-seksjon (Op #1–#4), Lag A. Doc-strings og non-null-/listekontrakter er bevisste — se *Kontekst og begrunnelse* nederst.

### Op #1 — `Query.mineSynligeOrganisasjoner`

```graphql
# Nytt Query-felt. Returnerer unionen av (a) organisasjoner admin har applikasjons-
# administrator-rollen for, og (b) organisasjoner som eier applikasjoner med tilganger
# inn i data admin administrerer. Hver organisasjon listes én gang, alfabetisk etter navn.
extend type Query {
  """
  Organisasjoner brukeren har innsynsscope på i applikasjoner-listen. Settet er rolle-
  utledet fra påloggede admin-roller og er ment som kilde for filter-dropdowns i
  applikasjoner-oversikten. Ikke det samme som `mineApplikasjonsAdminOrganisasjoner`,
  som beskriver hvilke organisasjoner brukeren kan opprette / redigere applikasjoner i.
  """
  mineSynligeOrganisasjoner: [Organisasjon!]!
}
```

### Op #2 — `Query.mineSynligeMiljoer`

```graphql
extend type Query {
  """
  Miljøer brukeren har innsynsscope på i applikasjoner-listen. Settet er unionen av
  (a) miljøer der applikasjoner i administrerte organisasjoner kan tilordnes tilganger,
  og (b) miljøer der andre organisasjoner sine applikasjoner har tilganger inn i data
  admin administrerer. Hvert miljø listes én gang, alfabetisk etter `navn`.
  """
  mineSynligeMiljoer: [Miljo!]!
}
```

### Op #3 — `Applikasjon.tilgangerOrganisasjoner`

```graphql
# Nye felter på eksisterende Applikasjon-type. Begge derives på server-siden fra
# det SAMME rolle-filtrerte tilgangs-sett som Applikasjon.tilganger-connection
# allerede returnerer — samme autorisasjons-WHERE-clause i resolveren.
extend type Applikasjon {
  """
  Distinkte organisasjoner representert i den (rolle-filtrerte) tilgangslisten for
  denne applikasjonen. Alfabetisk sortert etter `navn`. Ment som kilde for filter-
  dropdown på tilganger-fanen. Bruker samme rolle-filter som
  `Applikasjon.tilganger`-feltet — eier-admin ser alle, kryss-org-admin ser kun
  organisasjoner hvis tilgang gir innsyn i egne data.
  """
  tilgangerOrganisasjoner: [Organisasjon!]!
}
```

### Op #4 — `Applikasjon.tilgangerMiljoer`

```graphql
extend type Applikasjon {
  """
  Distinkte miljøer representert i den (rolle-filtrerte) tilgangslisten for denne
  applikasjonen. Alfabetisk sortert etter `navn`. Samme rolle-filter som
  `Applikasjon.tilganger` og `Applikasjon.tilgangerOrganisasjoner`.
  """
  tilgangerMiljoer: [Miljo!]!
}
```

### Op #5 — Autorisasjons-grense (ingen SDL-endring)

```graphql
# Ingen SDL-endring. Dokumentert som autorisasjons-regel i field-resolveren:
#
#   Applikasjon.tilganger:
#     - Hvis innlogget bruker har applikasjons-admin-rolle for applikasjonens
#       eier-organisasjon → returner alle tilganger (uendret).
#     - Ellers → returner kun tilganger hvor `tilgang.organisasjon.id` er i settet av
#       organisasjoner brukeren har applikasjons-admin-rolle for ("kryss-org-admin").
#     - Filter/orderBy/pagination-parametrene er uendret; filteret er en autorisasjons-
#       grense, ikke et brukervalg.
#
# Konsekvens for `totalCount` / `pageInfo` / `nodes`: alle reflekterer det rolle-
# filtrerte settet (totalCount er count etter rolle-filter + frivillig brukerfilter).
```

---

## Autorisasjons-regel — viktige presiseringer

Dette er den ene biten som ikke er ren SDL-tillegg, og hvor det er lett å bygge feil. Vær oppmerksom på:

1. **Implementeres som WHERE-clause i resolveren, ikke som filter-input i schemaet.** Rolle-filteret er en `forbidden-by-policy`-grense (autorisasjon), ikke en `narrowed-by-preference`-grense (brukervalg). Vi har eksplisitt forkastet å eksponere noe som `ApplikasjonTilgangerFilter.onlyMyOrgs: Boolean`, fordi en `false`-verdi ville implisitt be om data brukeren ikke har rett til. Dette er konsistent med hvordan synligheten av selve `applikasjoner`-listen allerede er resolver-implementert (ikke en filter-input).

2. **JWT/session-context for innlogget bruker forventes allerede å være tilgjengelig** i resolveren. Den eksisterende `applikasjoner`-list-resolveren bruker samme bruker-rolle-info for å håndheve listevisnings-synligheten — dette er bare å gjenbruke samme kontekst på `Applikasjon.tilganger`-resolveren (og på de to nye `Query.mineSynlige*`-resolverne og de to nye `Applikasjon.tilganger*`-resolverne).

3. **`totalCount`, `pageInfo` og `nodes` på `Applikasjon.tilganger` skal alle reflektere det rolle-filtrerte settet.** Hvis `tilgang` ikke er synlig for innlogget bruker, eksisterer den ikke for henne — heller ikke i tellingen. "Last inn flere"-paginering, antall-visning og lignende konsumenter skal se konsistente tall.

4. **Samme rolle-filter / WHERE-clause må deles mellom `Applikasjon.tilganger`, `Applikasjon.tilgangerOrganisasjoner` og `Applikasjon.tilgangerMiljoer`.** De tre feltene må returnere data utledet fra det _samme_ rolle-filtrerte settet — ellers kan filter-dropdownen tilby valg som ikke finnes i resultatlisten (eller motsatt). Foretrukket implementasjon: del én underlying query / DataLoader på tvers av de tre feltene for én applikasjon-id, slik at vi unngår N+1.

5. **Frontend mottar ingen rolle-context-signal og viser intet UI-signal** ("filtrert pga. din rolle"-merke). Dette er en avklart spec-beslutning i fs-admin-planen — endring kan legges til senere uten schema-endring.

---

## Hvordan teste — mock-API som "live spec"

Hele schema-endringen er allerede implementert i fs-admin sitt MSW-baserte mock-API, og brukes per i dag som referanse mens producer-arbeidet pågår. Bruk dette som executable spec — diff producer-implementasjonen mot mocken og resultatet bør være observasjonelt likt for de samme `Applikasjon`-id-ene.

**Mock-filer (i `sikt-no/fs-admin`, branch `applications-and-application-detail-delta` — eller hvor de er merget når dette leses):**

- **`src/mocks/applikasjoner/schema/applikasjoner.graphql`** — den lokale SDL-en mock-en serverer mot. Inneholder begge `Query.mineSynlige*`-feltene og begge `Applikasjon.tilganger*`-feltene.
- **`src/mocks/applikasjoner/handlers/queries.ts`** — MSW-handlers, inkludert:
  - `mineSynligeOrganisasjonerHandler` / `mineSynligeMiljoerHandler` for de to nye Query-feltene
  - `buildApplikasjonMedTilgangerResponse` — rolle-filter på `Applikasjon.tilganger` (eier-admin → alle, kryss-org-admin → kun tilganger inn i admin-egne data), og populering av `tilgangerMiljoer` / `tilgangerOrganisasjoner` fra det rolle-filtrerte settet
- **`src/mocks/applikasjoner/fixtures/applikasjoner.ts`** — `MINE_ADMIN_ORG_IDS` brukes som persona/rolle-proxy. `SYNLIGE_APPLIKASJONER` viser hvordan synligheten _allerede_ er modellert for listevisning og er kilden for unionen (a)+(b) i `mineSynligeOrganisasjoner`-svaret.
- **`src/mocks/applikasjoner/handlers/queries.test.ts`** — unit-tester som bekrefter rolle-filter for både eier-admin og kryss-org-admin-scenarier, og at `tilgangerMiljoer` / `tilgangerOrganisasjoner` stemmer overens med det rolle-filtrerte settet. Bruk disse testene som referanse for hva producer-resolveren skal returnere.

Persona-modellen i mocken er bevisst enkel (én "innlogget" admin med et fast sett `MINE_ADMIN_ORG_IDS`), men dekker begge sider av regelen:

- **Eier-admin** — applikasjonens eier-organisasjon er i `MINE_ADMIN_ORG_IDS` → returner alle tilganger.
- **Kryss-org-admin** — eier-organisasjonen er IKKE i `MINE_ADMIN_ORG_IDS`, men én eller flere tilganger peker på organisasjoner som ER i `MINE_ADMIN_ORG_IDS` → returner kun de tilgangene.
- **Super-admin / system-applikasjon** (`a.organisasjon === null`) — behandles som eier-admin (returner alle). Konsistent med listevisnings-synligheten.

---

## Out-of-scope for dette issuet

- **Migrasjon av fs-admin til codegen + fragment-colocation.** Når producer-schemaet er merget, åpner vi en separat fs-admin-plan som migrerer de fire nye/endrede TRANSITIONAL-hookene (`useGetMineSynligeOrganisasjoner`, `useGetMineSynligeMiljoer`, `useGetApplikasjonTilgangerFilterOptions`, det utvidede selection-settet i `useGetApplikasjonTilganger`) og de fire filter-komponentene over på `import { gql } from '@/__generated__'` + codegen-typer + `useFragment`/`@unmask`-mønster. Det er teknisk gjeld som ryddes opp _etter_ at producer er på plass — ikke en del av dette issuet.
- **UI-signal for rolle-filtrert tilgangsliste** ("Filtrert pga. din rolle"-merke). Avklart i fs-admin-spec til "ingen markering" for denne iterasjonen. Kan legges til senere uten schema-endring.
- **`mineApplikasjonsAdminOrganisasjoner`-queryen** beholdes uendret. Den brukes fortsatt på fire frontend-kall-steder for `Opprett applikasjon`-gating (`ApplikasjonerOverview.tsx`, `OpprettApplikasjonModal.tsx`, `TildelTilgangModal.tsx`, `FjernTilgangModal.tsx`) og må ikke endres som del av dette arbeidet.

---

## Kontekst og begrunnelse

For den fulle begrunnelsen — hvorfor separate queries i stedet for å utvide eksisterende, hvorfor server-side felter i stedet for client-side derivasjon fra `tilganger.nodes`, hvorfor non-null lister, hvorfor ingen paginering på `mineSynlige*`/`tilganger*`-listene, og forholdet til producer-konvensjonene (`fs-sikt-no-producer-schema-design`, `fs-sikt-no-producer-naming`, `fs-sikt-no-producer-best-practice`) — se fs-admin-planens `## GraphQL-endringer`-seksjon, Op #1–#5 Lag C.

Kort oppsummert:

- **Hvorfor egne `Query.mineSynlige*`-felter, ikke union i eksisterende `mineApplikasjonsAdminOrganisasjoner`?** De to bruksområdene er semantisk forskjellige (`redigeringsrett` vs. `innsynsscope`) og må kunne drifte fra hverandre uten å bryte hverandres kontrakt. `mineApplikasjonsAdminOrganisasjoner` brukes til Opprett-knapp-gating; sammenslåing ville koblet to uavhengige forretningsregler.
- **Hvorfor server-side `Applikasjon.tilganger*`-felter, ikke client-side derivasjon fra `tilganger.nodes`?** Client-side derivasjon ville stille-skjult organisasjoner/miljøer som ligger lenger ned i den paginerte connection (`first: 50` default; en applikasjon med >50 tilganger kan spenne flere organisasjoner enn de første 50 viser). Silent failure er verre enn én ekstra felt-evaluering på serveren, særlig når serveren allerede har det rolle-filtrerte settet i hånda fra connection-queryens WHERE-clause.
- **Hvorfor ingen Cursor-paginering på de fire nye listene?** Per `fs-sikt-no-producer-best-practice §Paginering`-unntaket ("svært god kontroll på at antallet elementer som kan returneres er lavt"). `mineSynlige*`-listene er admin-rolle-bounded (typisk 5–50). `tilgangerOrganisasjoner` / `tilgangerMiljoer` er content-bounded av tilgangs-listen for én enkelt applikasjon (typisk ≤ 10 distinkte organisasjoner, ≤ 5 miljøer). Speiler eksisterende `mineApplikasjonsAdminOrganisasjoner`-mønster.

---

## Referanser

- **Initiativ:** sikt-no/fs#31 — "Grunnleggende selvbetjent tilgangsstyring"
- **Spec (delta):** [`spec-changes-2026-06-16-b0e8de5.md`](https://github.com/sikt-no/fs/blob/main/tasks/applikasjoner-visning-delta/spec-changes-2026-06-16-b0e8de5.md) — § Endret (5 punkter) + nytt § Regel: Synlighet for tilganger
- **Analyse:** [`analysis-applikasjoner-visning-delta.md`](https://github.com/sikt-no/fs/blob/main/tasks/applikasjoner-visning-delta/analysis-applikasjoner-visning-delta.md)
- **Plan med full GraphQL-begrunnelse:** [`plan-applikasjoner-visning-delta.md`](https://github.com/sikt-no/fs/blob/main/tasks/applikasjoner-visning-delta/plan-applikasjoner-visning-delta.md) — `## GraphQL-endringer` (Op #1–#5, Lag A/B/C)
- **Implementerte fs-admin-deliverables (completion-docs):**
  - Task #1 — mock-API med rolle-filter + nye filter-kilder: [`task-1-completion.md`](https://github.com/sikt-no/fs/blob/main/tasks/applikasjoner-visning-delta/task-1-completion.md)
  - Task #2 — nye TRANSITIONAL hooks: [`task-2-completion.md`](https://github.com/sikt-no/fs/blob/main/tasks/applikasjoner-visning-delta/task-2-completion.md)
  - Task #3 — listevisnings-filter-refaktor: [`task-3-completion.md`](https://github.com/sikt-no/fs/blob/main/tasks/applikasjoner-visning-delta/task-3-completion.md)
  - Task #4 — utvidet detalj-query + tilganger-tab-filter-refaktor: [`task-4-completion.md`](https://github.com/sikt-no/fs/blob/main/tasks/applikasjoner-visning-delta/task-4-completion.md)
  - Task #5 — persona-cache-flush verifikasjon: [`task-5-completion.md`](https://github.com/sikt-no/fs/blob/main/tasks/applikasjoner-visning-delta/task-5-completion.md)
- **Producer-guidelines (`bat-graphql-dev` references):** `fs-sikt-no-producer-schema-design.md`, `fs-sikt-no-producer-naming.md`, `fs-sikt-no-producer-best-practice.md`

---

_Issue-utkast generert som del av fs-admin Task #6 (`task-6-completion.md`)._
