# Analyse: Tak og gulv for Feide-applikasjoner

- **Krav:** `@BRU-APP-API-018` (taket) og `@BRU-APP-API-019` (gulvet). Jira: [BAT-411](https://sikt.atlassian.net/browse/BAT-411)
- **Repo og rolle:** fs-plattform (tilgangsstyring), `backend`
- **Kodesjekk:** fs-plattform `origin/main` `f842e2a012` (2026-11-04). Spec-en sjekket mot `e70cfb4fa3`, som er eldre; funnene i spec-en står seg. fs-admin `origin/main` `6816bd2d6`, samme som spec-en.
- **Avgrensning:** analysen beskriver hva som finnes, hva som berøres, føringer, avhengigheter og gap. Den foreslår ingen løsning – det er jobben til `bat-plan`.

## Problemstilling

FS Admin skal få to faner på detaljsiden for Feide-applikasjoner, én for taket og én for gulvet. Applikasjonsadministratoren skal se rollene som gjelder nå, med gyldighetstidsrommet, og tildele og fjerne forretningsroller per organisasjon og miljø. Se [spec-en](../spec/spec-tak-og-gulv-for-feide-applikasjoner.md).

For fs-plattform betyr det at tilgangsstyringen må tilby det fanene trenger gjennom grafen:

- **Taket:** lesing og skriving finnes for direkte rader. Tak fra organisasjonssamlinger er ikke synlige i grafen (gap 2 fra fs-specify).
- **Gulvet:** tabellen og beregningen finnes, men ingenting er skrivbart, og grafen har ingen typer eller mutasjoner for gulvet (gap 1 fra fs-specify).

Avgjort av Kjetil (04.11.2026): kravet er riktig, og koden skal endres. Retten til å forvalte gulvet er den samme som for taket: forretningsrollen `APPLIKASJONSADMINISTRATOR` for applikasjonseieren og for organisasjonen på raden, i samme miljø. Kommentaren i 0099 om et eget privilegium følges ikke.

## Begreper

Begrepene følger `tilgangsstyring/docs/tilgangsmodell.md` og `malarkitektur.md`:

- **Taket** (delegeringstaket): `applikasjon_brukerdelegering`, og samlingsformen `applikasjon_brukerdelegering_organisasjonssamling`. Taket bestemmer hvilke av brukerens egne roller appen får formidle.
- **Gulvet:** `applikasjon_brukergrunntilgang`. Det appen gir alle brukere, også ukjente. Ligger utenfor taket.
- **Effektiv tilgang:** `((brukerroller ∩ tak(app)) ∪ gulv(app) ∪ åpne_roller) MINUS nekt(bruker)`, se `kombiner_tildelinger` (0099).
- **Rollen og privilegiet:** forretningsrollen `APPLIKASJONSADMINISTRATOR` (`0040-forretnings-og-ui-roller.sql:86`) bærer privilegiet `BRUKERADMIN_WSBRUKER_SKRIV` gjennom implikasjonene i rollekatalogen (`0040:165`, `0043-delegeringstak-nye-roller.sql:128`). Policyene måler privilegiet, ikke rollen. `APPLIKASJON_ADMINISTRATOR` med understrek står bare i `malarkitektur.md:198`.
- **Invariantene I0–I5:** `tilgangsstyring/docs/syntetiske-og-ekte-data.md`.

## Slik er det i dag

### Taket: tabeller, funksjoner og policyer

| Objekt | Hvor | Merknad |
|---|---|---|
| `applikasjon_brukerdelegering` | `0003`, skriveregel `0048`, policyer `0119` | PK `(subjekt_id, rollekode, organisasjonskode, miljokode, gyldig_periode WITHOUT OVERLAPS)`. FK til `feide_applikasjon`, så taket gjelder bare Feide-applikasjoner. |
| `kan_forvalte_delegering(subjekt_id, organisasjonskode, miljokode)` | `0048-forvalte-delegeringstak.sql:167` | Eneste sted regelen står. Ledd 1: `BRUKERADMIN_WSBRUKER_SKRIV` i radens (miljø, organisasjon). Ledd 2: samme privilegium i eierorganisasjonen, samme miljø. SECURITY INVOKER (fail-closed). **Nøyaktig regelen Kjetil har bestemt for gulvet.** |
| `applikasjon_brukerdelegering_les` | `0048` | To grener: LES i radens (miljø, organisasjon), eller i eierorganisasjonen. I2 er ikke håndhevet her ennå (`syntetiske-og-ekte-data.md:81`). |
| `applikasjon_brukerdelegering_opprett` / `_endre` / `_slett` | `0119-en-policy-per-operasjon.sql:170–211` | Alle bruker `kan_forvalte_delegering`. |
| `applikasjon_brukerdelegering_organisasjonssamling` | `0080`, policyer `0119:213–260` | Skriving krever full dekning (`kan_forvalte_delegering_samling`, `0080:170`). Lesing krever også full dekning (`kan_lese_delegering_samling`): LES i hver aktive medlemsorganisasjon, eller i eierorganisasjonen. |
| `raa_delegeringstilganger(env, subjekt)` | `0080:113` | Utvider samlingstaket til medlemmene for beregningen. Én applikasjon om gangen; ikke en lesekilde for lister. |
| `roller_i_applikasjonstak(org, miljø)` | `0127` | Valglistekilde for personbrukere (SECURITY DEFINER). Utvider samlingstaket per organisasjon, men svarer bare med rollekoder, uten applikasjon eller kilde. |

### Taket: grafen (`schema_delegeringstak.graphqls`, experimental)

- `FeideApplikasjon.brukerdelegeringer(filter: BrukerdelegeringerFilterInput)` (`:169`) er en connection som leser bare direkte rader. Filtre: `miljoer`, `organisasjoner`, `erAktivNaa`. «Filter i spørringen, ikke RLS» er altså mulig for direkte rader.
- `Brukerdelegering` (`:38`) har `tilgangsrolle`, `organisasjon`, `miljo`, `gyldighetsperiode { fraTidspunkt, tilTidspunkt }`, `erAktivNaa` og sporingsfelt. Ingen node-id (perioden er i PK). Ingen kilde/tilknytning (`DIREKTE`/`SAMLING`).
- `leggTilBrukerdelegeringer` og `fjernBrukerdelegeringer` (`:380`, `:400`) via `BrukerdelegeringForvaltningService`. Idempotente; fjerning lukker `gyldig_periode`. Feil: `ManglerDelegeringsforvaltning`, `BrukerdelegeringApplikasjonFinnesIkke`, `BrukerdelegeringTilgangskodeFinnesIkke`.
- Begge er alt eller ingenting i én `transactionResult` (graphitron#530).
- `tilgangskodeId` tar imot hvilken som helst `Tilgangsrolle`; ingen avgrensning til navneromstype `forretning`.
- Tester: `DelegeringstakGraphqlTest`, pgTAP 42, 70 og 99.

### Gulvet (`0099-gulv-per-applikasjon.sql`)

- `applikasjon_brukergrunntilgang` (`:21`): `subjekt_id`, `subjekt_type` (CHECK: bare `feide_applikasjon`), `rollekode`, `organisasjonskode`, `miljokode`, `gyldig_periode`, sporingskolonner. PK som for taket. Samme temporale triggere; fjerning lukker perioden.
- **Skrivingen er sperret i to lag:** `REVOKE INSERT, UPDATE, DELETE … FROM ${app_role}` (`:99`), og ingen `_opprett`/`_endre`/`_slett`-policy. Bare `applikasjon_brukergrunntilgang_les` (`:101`, I2 i `0117:36`).
- Lesepolicyen har samme to grener som taket, pluss I2: fra et syntetisk miljø er gulvet til ekte applikasjoner usynlig.
- I4: triggeren `gulv_krever_lik_klassifisering` (`:207–227`, `TS204`).
- Beregningen er på plass: `raa_grunntilganger(env, app)` (`:234`), `kombiner_tildelinger` (`:257`), kjernene `tilganger_for_bruker*` og `tilganger_for_feidetjeneste_og_bruker_med_sudo` (`:304–438`). FS-fiktive fødselsnumre: gulvet begrenses til hjemorganisasjonen. `gc_temporale_rader` (`:462`).
- jOOQ er klar (`<periodetabeller>`, `tilgangsstyring-new-jooq/pom.xml:20`).
- Grafen har ingen typer, felt eller mutasjoner for gulvet.
- Tester: pgTAP 20, 100 og 01 (`policies_are`, `01_structural_tests.sql:101–113`; gulvet står med bare `_les`).

### Mønstre med presedens

- **Én policy per tabell og operasjon (0119).** SKRIV gir LES gjennom implikasjonene. UPDATE med WHERE krever synlighet gjennom lesepolicyen. I2 også i USING på `_endre`/`_slett` (0117).
- **Samlingsrader per organisasjon, med kilde (0104/0107):** `samlingstildelinger_i_mine_les_organisasjoner()` utvider samlingstildelinger til medlemmene; synlig der en direkte rad ville vært det. Kilde som `Tilknytning.SAMLING` (`applikasjon_tilganger.graphqls:34`). Kan ikke fjernes per organisasjon (`SamlingstildelingKanIkkeFjernes`).
- **Søsterflaten for nekt:** `brukerrollenekt_opprett/_endre/_slett` (`0119:97–137`).
- **Delvis suksess for personbrukere** gjøres i klienten med alias-batch (`useTildelPersonbrukerTilganger`, `byggAliasBatch`).
- **Rettighetsgating i klienten** via `Query.mineTilganger`; serveren leverer ikke `kan*`-flagg.

## Hovedfunn

1. **Gulvet mangler hele skrivestien:** tabellrettigheter (REVOKE `0099:99`), policyene `_opprett/_endre/_slett`, service/mutasjon og graftyper. Regelen finnes allerede som `kan_forvalte_delegering` med samme signatur som gulvradene.
2. **«Eget privilegium» står mange steder og strider mot beslutningen:** `0099:9–12`, `:60–66`, `:114–118`; `0117:55–61`; takpolicy-kommentarene i `0048` og `0119:178–191`; `tilgangsmodell.md` §`applikasjon_brukergrunntilgang` (ca. `:630–640`) og §Effektiv tilgang (ca. `:706`); `docs/specs/gulv-per-applikasjon/plan-gulv-per-applikasjon.md:39`, `:51`.
3. **Samlingstak er ikke synlige i grafen.** Ingen lesekilde utvider samlingstaket per organisasjon med kilde og periode.
4. **Lesereglene for samlingstak og direkte tak er ulike** (full dekning vs. radens organisasjon). 0104/0107 løste tilsvarende for tildelinger.
5. **«Gjelder nå» og gyldighetstidsrom** finnes for taket; for gulvet bare i jOOQ.
6. **Ingen avgrensning til forretningsroller på serveren** for tak eller gulv.
7. **Ingen valglistekilde for organisasjon og miljø med `BRUKERADMIN_WSBRUKER_SKRIV`.** Eksisterende kilder måler tildelingsrettigheter. `mineTilganger` kan brukes til gating i klienten.
8. **Delvis suksess er ikke et gap i fs-plattform** (alias-batch i klienten).
9. **Effektiv tilgang er implementert** (pgTAP 20, 37, 70); trenger bare regresjonsdekning.
10. **Eksisterende gulvrader kan inneholde tilganger, ikke bare forretningsroller** (migreringen i 0099 `:144–203` kopierte impliserte koder). Ikke verifisert mot data.

## Tekniske føringer

- RLS er porten; servicen har ingen egen rettighetslogikk foran skrivingen.
- Én policy per tabell og operasjon, pinnet av pgTAP 01.
- Regelen formuleres ett sted (`kan_forvalte_delegering`).
- Temporalt: DELETE blokkeres; fjerning lukker `gyldig_periode`; `now()` er konstant i en transaksjon.
- I2: lesepolicy og USING på `_endre`/`_slett` for gulvet (0117). For taket er I2 ikke håndhevet ennå (`syntetiske-og-ekte-data.md:81`).
- I4: håndheves for gulvet (TS204); for taket ikke ved direkte skriving (`syntetiske-og-ekte-data.md:84`).
- I5: `kan_forvalte_delegering` matcher begge ledd med radens `miljokode`.
- `local` må holdes lik `test` (`tilgangsmodell.md` ca. `:552–557`); en skriveflate i `test` oppdaterer ikke `local`.
- Graphitron: `@service` åpner ingen transaksjon (graphitron#530); `@error` bærer én exception per kall; ingen node-id for tak- eller gulvrader.
- Experimental-flaten (`features/experimental/`).
- Endringslogg og nekt er utenfor.

## Avhengigheter

- **Internt:** `kan_forvalte_delegering` (0048), I2-mønsteret (0117), policykonvensjonen (0119), triggerne i 0099, `organisasjonssamlingsmedlemskap` og 0104/0107. Docs: `tilgangsmodell.md`, `syntetiske-og-ekte-data.md`, ev. `malarkitektur.md`. Tester: pgTAP 01, 20, 42, 70, 100 og `DelegeringstakGraphqlTest`. Takleddene i `roller_i_applikasjonstak` (0127) må følges opp.
- **Eksternt:** Graphitron og supergrafen (experimental).
- **fs-admin (frontend):** faner på `ApplikasjonDetails` (i dag `detaljerTab` og `tilgangerTab`, `ApplikasjonDetails.tsx:91–104`), dialoger etter `TildelRolleAction`/`FjernRolleAction` og `useTildelPersonbrukerTilganger`, `formatGyldighetstidsrom`, gating via `mineTilganger`. Blokkeres av fs-plattform for gulvet og samlingstak; direkte tak kan bygges mot dagens graf.
- **Krav og design (sikt-no/fs#914):** åpne designspørsmål om fanenavn, visning av kilde og advarsel for gulvet. Blokkerer ikke fs-plattform.

## Hvordan koden står mot kravene

| Regel i kravet | Status i fs-plattform |
|---|---|
| Fane bare for Feide-applikasjoner | Støttet (FK/CHECK mot `feide_applikasjon`). |
| Alle som kan se applikasjonen ser fanen; listen viser det som gjelder nå med gyldighetstidsrom | Taket: støttet for direkte rader. Gulvet: gap. |
| Samlingstak vises per organisasjon med kilde, kan ikke velges/fjernes, regnes som allerede i taket | Gap (ingen lesekilde; ulike leseregler; `leggTilBrukerdelegeringer` avviser ikke direkte rad når rollen alt er i taket via samling). |
| Én rolle per organisasjon og miljø, flere samtidig, delvis suksess | Taket: støttet (alias-batch). Gulvet: gap. |
| Fjerne én eller flere | Taket: støttet. Gulvet: gap. |
| Bare forretningsroller | Ingen avgrensning på serveren. Åpent spørsmål. |
| Forvaltning krever rollen for eieren og radens organisasjon i samme miljø | Taket: støttet. Gulvet: gap, men predikatet finnes. |
| Valglisten for organisasjon og miljø begrenset | Ingen serverkilde; gating via `mineTilganger`. |
| En rolle som alt er i taket/gulvet kan ikke velges | Klienten kan utlede for direkte rader; samlingsleddet avhenger av gapet over. |
| Effekten av tak og gulv | Støttet (`kombiner_tildelinger`, pgTAP 20/37/70). |

- **Dekket:** effekten av tak og gulv; lesing, tildeling og fjerning for direkte tak; forvaltningsregelen for taket.
- **I faresonen:** `@BRU-APP-API-019` i sin helhet, og regelen om samlingstak i `@BRU-APP-API-018`.
- **Andre mangler:** utdaterte kommentarer og docs om «eget privilegium»; ingen valglistekilde; ingen avgrensning til forretningsroller; `local`/`test` kan komme ut av synk; mulige gulvrader med tilganger.

## Krav-input referanse

- **Spec-dokument:** [`spec-tak-og-gulv-for-feide-applikasjoner.md`](../spec/spec-tak-og-gulv-for-feide-applikasjoner.md)
- **Krav-input-manifest:** [`krav-input/manifest.md`](../spec/krav-input/manifest.md)

## Avklarte spørsmål (Kjetil, 04.11.2026)

- [x] **Bare forretningsroller:** (a) bare valglisten i FS Admin filtrerer. Ingen avgrensning på serveren, og eksisterende rader røres ikke.
- [x] **Synlighet av samlingstak per organisasjon:** (a) som 0104/0107 – samlingstaket vises der en direkte takrad ville vært synlig.
- [x] **Valglisten for organisasjon og miljø:** (a) utledes i klienten fra `mineTilganger`.
- [x] **`local` og `test`:** varselet i `tilgangsmodell.md` holder; skriving speiles ikke.
- [x] **I2 for taket:** innenfor dette arbeidet.
- [x] **Direkte tildeling når rollen alt er i taket via samling:** klienten hindrer det; serveren avviser ikke.
