# Analyse: Grunnleggende brukeradministrasjon (personbrukere)

> GAP-analyse mellom implementert frontend (fs-admin-prototype), implementert backend
> (tilgangsstyring) og kravene (BRU-PER-GRU-001–006). Skrevet 2026-08-20, verifisert mot
> fs-plattform `main @ 3134a3fe1e`, fs-admin `main @ 29447717d` + branch
> `BAT-185-grunnleggende-brukeradministrasjon-v-1-frontend`, fs-krav-branch
> `grunnleggende-brukeradministrasjon-og-tilgangsstyring`.

## 1. Frontend i dag (fs-admin)

**Prototypen ligger IKKE på main.** Den ligger på umerget branch
`origin/BAT-185-grunnleggende-brukeradministrasjon-v-1-frontend` (basert på main @ c71120ffa).
På main finnes kun applikasjons-slicen (delvis migrert til ekte skjema).

- Ruter: `/tilgangsstyring/personbrukere` (liste) og `/tilgangsstyring/personbrukere/[id]`
  (detalj med faner Detaljer / Tilganger / Roller), bak Unleash-flagget
  `tilgangsstyring-brukeradministrasjon`.
- Komponenter: `src/domains/tilgangsstyring/features/PersonbrukereOverview/**` og
  `.../PersonbrukerDetails/**` (inkl. `TildelTilgangModal`, `FjernTilgangModal`,
  `TildelRolleModal`, `FjernRolleModal`, `DeaktiverPersonbrukerModal`, `ReaktiverPersonbrukerModal`).
- 100 % mocket via MSW: `src/mocks/personbrukere/` (handlers/store/fixtures, 84 brukere,
  persona-basert synlighet). Mock-SDL: `src/mocks/personbrukere/schema/personbrukere.graphql`
  — eksplisitt ment som input til subgraf-planlegging. Env-switch
  `NEXT_PUBLIC_ENABLE_PERSONBRUKER_MOCKS`. Alle personbruker-hooks bruker rå `gql` og er
  codegen-ekskludert i `codegen.ts` (de facto «hva er ennå ikke ekte»-registeret).
- Pre-flight-sjekkliste for backend: `src/mocks/personbrukere/teardown-personbrukere.md`.

**Operasjoner prototypen forventer:** queries `personbrukere` (connection m/ filter
navn/feideId/status/organisasjonId/rollekode/miljoKode), `personbruker(id)` (m/ seks
`kan*`-flagg), `personbrukerMedTilganger`/`personbrukerMedRoller`,
`personbrukereFilterOptions`, `mineBrukerAdminOrganisasjoner`,
`tildelbarePersonbrukerTilganger/Roller`; mutasjoner `tildel/fjernPersonbrukerTilganger`,
`tildel/fjernPersonbrukerRoller`, `deaktiver/reaktiverPersonbruker` — alle med envelope
`XSuksess | MutasjonAvvist` og delvis suksess (`tildelte` + `avviste` per element).

## 2. Backend i dag (tilgangsstyring, main)

**Eksisterer og gjenbrukes direkte:**
- Datamodellen: `feide_bruker` (subjekt-subtype), `rolle`/`rolle_implikasjon` (rekursiv,
  matcher begrepsbruk.md), temporale append-only tildelingstabeller (`subjektrolletildeling`
  m/ `tstzrange`, DELETE blokkert av trigger, aktørkolonner autoutfylt), view
  `subjektrolletildeling_med_arv` (subjekt-generisk; eksponert i dag som `ApplikasjonTilgang`).
- RLS-policyer `feide_bruker_les`/`feide_bruker_skriv` (privilegier
  `BRUKERADMIN_WSBRUKER_LES`/`_SKRIV` via `auth.orger_med_tilgang()`); hele
  `auth.login_*`-sesjonsmaskineriet; databasen er autorisasjonspunktet, ikke Java.
- GraphQL-typene `FeideBruker` (@node 20016, federert `@key(brukernavn)`), `Tilgangsrolle`,
  `Organisasjon`, `Miljo`; `tilgangsstyringNode(id)`; connection-/filter-/orderBy-mønsteret.
- Test-harnessen i tre lag: pgTAP (`tilgangsstyring-new-db/src/test/sql/`, `PostgresTestBase`),
  Quarkus-IT (`SkrivemutasjonerGraphqlTest` som mal), unit.

**Applikasjonsadministrasjonen som mønster** (kopieres for brukeradmin):
- Skjema i `tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_exp.graphqls`:
  batch-mutasjoner `opprettXer(input: [..!]!): Payload { xer, errors: [XError] }`; deklarativ
  feilhåndtering `@error(handlers:)` på SQLSTATE (42501 → `ManglerSkrivetilgang` osv.);
  ukjent/RLS-skjult/ugyldig id kollapser til én feiltype (ingen eksistens-orakel).
- `@service`-klasser får request-scopet `DSLContext` (RLS-sesjon allerede montert) og **må selv
  wrappe i `ctx.transactionResult`** (Graphitron gjør det ikke); payload setter kun PK,
  Graphitron re-henter valgte felter.
- Deaktiveringsmønster (0017/0026): `deaktivert_tidspunkt` + GENERATED `status` + aktørkolonner,
  guarded UPDATE (`.and(deaktivertTidspunkt.isNull())`), 0-rader disambiguert med
  eksistenssjekk mot `auth.orger_med_tilgang('..._SKRIV')`.
- Opprett via plpgsql-funksjoner **SECURITY INVOKER** (RLS er eneste autorisasjonspunkt).

**Relevante umergede brancher:**
- `origin/tilgangsstyring/fase4-tildel-fjern` — `tildelApplikasjonTilganger`/
  `fjernApplikasjonTilganger`, migrasjon `0035-tildel-og-fjern-tilganger.sql`
  (subjekt-agnostiske RLS-policyer, `krev_tildelingsrett`/`effektiv_tilgang`/`krev_tilgangskode`,
  privilegium `BRUKERADMIN_TILDELING_SKRIV`), `ApplikasjonTilgangService`, feiltypene
  `ManglerTildelingsrett`/`ArvetTilgangKanIkkeFjernes`, pgTAP 31, IT
  `TildelingsmutasjonerGraphqlTest` (651 linjer), typeId 20018. **Nærmeste referanse for
  bruker-tildeling; bør merges før skrivesiden.**
- `origin/tilgangsstyring/fase4-tildelbar` — `rolle.tildelbar`-vakt mot selv-eskalering (0031).
- `origin/tilgangsstyring/mineTilganger` — gjenoppretter `Query.mineTilganger` (eies av annet team).

**Gotchas:** `tilgangsstyring-db/` og `tilgangsstyring-jooq/` på disk er kun stale `target/`
(ikke i git) — ignoreres. jOOQ-generert kode er committet → regenerering er serielt
koordineringspunkt. Migrasjonsnummer 0028 og 0035 samt pgTAP 31 og typeId 20018 er
reservert av eksisterende brancher.

## 3. GAP-matrise

| Krav | Frontend (BAT-185-prototype) | Backend (main) |
|---|---|---|
| GRU-001 liste/søk | ✅ (mangler «Sist innlogget»-kolonne) | ❌ ingen brukere-listequery; innloggingstidspunkt lagres ikke |
| GRU-002 se tildelinger | ✅ (mangler tidsrom-/stedkodevisning) | ⚠️ arv-viewet finnes, men ikke eksponert fra `FeideBruker`; `tildelt av`/`tildelt dato` finnes som kolonner i grunntabell, ikke i viewet |
| GRU-003 tildel/fjern | ✅ inkl. delvis suksess-UI | ❌ på main; mønster på `fase4-tildel-fjern` (alt-eller-ingenting) |
| GRU-004 deaktiver/reaktiver | ✅ | ❌ for brukere (0018-kommentar sier eksplisitt «personer kan ikke deaktiveres»); mønster finnes for applikasjoner |
| GRU-005 stedkoder | ❌ | ❌ (ingen stedkode-dimensjon i modellen) — utsatt |
| GRU-006 tidsbegrensning | ❌ | ⚠️ tstzrange-perioder finnes; ingen API — utsatt |
| Klient-gating | mock-persona + seks `kan*`-flagg | `mineTilganger` fjernet fra main (annet team eier gjenopprettingen); arkitekten har avvist server-beregnede `kan*`-flagg (`docs/tilgangsmodell.md:200–240`) |
| Tilgang vs. rolle-skille | to separate faner/typer i UI | ❌ ingen distinksjon i data — `rolle` er én uniform type |
| Kontraktsform | mock-envelope, rot-oppslag `personbruker(id)`, `Person{navn}` | plattform: `tilgangsstyringNode`, errors-union m/ `path`, batch-input, `FeideBruker{brukernavn}` — persondata (navn) eies av SIS |
| Delvis suksess | forventes av UI + krav | ⚠️ plattformmønsteret er alt-eller-ingenting — krever per-element-resultat i payload i stedet for @error |

## 4. Begrensninger og føringer

- Mutasjoner er kun tillatt på `/graphql/production`-pathen (`EnvironmentGraphqlResource`).
- Tildelingstabellene er append-only: fjerning = lukke periode, aldri DELETE.
- Nyopprettet bruker uten tildelinger er usynlig under `feide_bruker_les`-RLS (kjent
  egenskap; opprett bruker er uansett utenfor scope).
- Deaktivering håndheves ved tokenutstedelse — utstedte JWT-er lever i inntil 1 time
  (sesjonsterminering er åpent kravspørsmål i GRU-004).
- Arkitektens dokumenterte avvisninger (`docs/tilgangsmodell.md`): ingen superadmin-snarvei,
  ingen server-beregnede `kan*`-flagg — klienten skal gate på egne roller.

## 5. Cross-contributor

| Rolle | Hva trengs | Hvorfor det blokkerer |
|---|---|---|
| Kravansvarlig (#481/GRU-003) | Beslutning: delvis suksess vs. alt-eller-ingenting ved bulk-tildeling | Låser transaksjonssemantikken i `FeideBrukerTilgangService` (skjemaet tåler begge, jf. plan B5) |
| mineTilganger-/gating-teamet | `Query.mineTilganger` + frontend-gatingmekanisme | Frontend-migreringen fjerner `kan*`-flaggene og trenger gating-mekanismen som erstatning for knappe-synlighet |
| Kravansvarlig / produkteier | Aksept for at «Navn»-kolonnen leveres som `brukernavn` inntil SIS-federert navn er på plass | GRU-001 lister «Navn»; subgrafen eier ikke persondata (plan B1) |
| Eier av fase4-branchene | Merge av `fase4-tildel-fjern` (0035) | Vertikal B bygger på tildelingsmaskineriet der (fallback: cherry-pick changesetene) |
| Rolledefinisjonsarbeidet («4 - Opprette og administrere roller») | Endelige rollekoder for personadministrator/super-personadministrator | I dag gjenbruker `feide_bruker`-RLS `BRUKERADMIN_WSBRUKER_*`; egne person-privilegier er mulig senere innstramming |
