# Verifisering: endringene i PR #843 (opptaksstatus)

- **Dato:** 2026-10-30 09:07
- **Krav:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opptaksstatus.feature`, `krav/02 Opptak/11 Opprette og vedlikeholde opptak/07 Oversikt over opptak/listevisning_og_sok_i_opptak.feature` (bare scenarioene som er endret i PR-en: Se liste over opptak, Velge sorteringsretning for <felt>, Tilgjengelige statuser i filter, Filtrere på status), `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/finne_studier.feature` (bare Regel: Synlighet via publiseringen av opptaket), `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/søke_på_opptak.feature` (bare Regel: Søkeren kan ikke begynne på eller endre en søknad når opptaket er avpublisert) (4 feature-filer)
- **Kode:** `fs-plattform` (origin/main, `e70216d1c4`, oppdatert, lest med git show/grep), `fs-admin` (origin/main, `bd9f430d0`, oppdatert, lest med git show/grep; utsjekket branch `karen.sikkeland/216-feat-plasstildeling-runder-utkast` med lokale endringer er ikke lest), `min-kompetanse` (origin/main, `8fbe6625`, oppdatert)
- **Åpne MR-er:** ikke sjekket (glab finnes ikke på maskinen). 1 branch uten MR-sjekk i fs-plattform med kode for kravene
- **Omfang:** alle krav uansett status, avgrenset til endringene i PR #843 (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `OH` = `fs-admin/src/domains/opptak/features/OpptakDetails/components/OpptakHandlinger/OpptakHandlinger.tsx`
- `AEO` = `fs-admin/src/domains/opptak/features/OpptakManagement/utils/emptyObjectGenerators.ts`
- `ACI` = `fs-admin/src/domains/opptak/features/OpptakManagement/utils/convertDataToInput.tsx`
- `OVV` = `fs-admin/src/domains/opptak/features/OpptakOverviewView`
- `UGO` = `fs-admin/src/domains/opptak/features/OpptakOverviewView/hooks/useGetOpptak.tsx`
- `SOO` = `fs-admin/src/domains/soknadsbehandling/features/SakOpptakOverview/hooks/useGetOpptak.tsx`
- `OOM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpprettOpptakMutations.java`
- `OF` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Opptaksfrister.java`
- `OSK` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Opptaksstatuskoder.java`
- `UM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `V2S` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudV2Service.java`
- `OS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpptakService.java`
- `SKS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `URS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/klient/ureg/UregStudieprogramService.java`
- `OGQ` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/opptak.graphqls`
- `SGQ` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/soknad/soknad.graphqls`
- `SAKGQ` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/sak.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `MKS` = `min-kompetanse/src/components/find-studier/_utils/get-search-param-funcs.ts`

## Oppsummering

- Scenarioer: 15 funnet, 9 ikke funnet, 0 usikker, av 24
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 3
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 7 stemmer, 2 avviker, 0 ikke funnet, 0 usikker, av 9
- Regler i koden uten scenario: 15
- Åpne spørsmål: 3 regler og 11 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

Ingen. Begge `@depends-on-` i scope (finne_studier.feature:306 og søke_på_opptak.feature:184) peker på `@OPT-OVO-GRU-004`, som selv er i scope. listevisning_og_sok_i_opptak.feature har bare `@ref-`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | Opptaket er upublisert når det er opprettet | funnet | `AEO:14` — nytt opptak får `Opptaksstatus.Upublisert`; `ACI:59-63` sender den; `OOM:64,69,87` lagrer statusen |
| `@OPT-OVO-GRU-004` | Publisere opptaket | funnet | `OH:45-53` — Upublisert gir «Publiser opptaket», som setter Publisert; `OH:109-125` kaller `oppdaterOpptak`; `OOM:192-193` lagrer statusen |
| `@OPT-OVO-GRU-004` | Opptaksforvalter ved deltakende organisasjon kan ikke publisere opptaket | funnet | `OH:92-94` — `useWithRole(MODIFISERE_OPPTAK)` på opptakets organisasjon; `OH:140-146` viser bare «Administreres av …», uten meny; `MIG/V319__opptak_v2_skriving_krever_forvalter.sql:32-34` — RLS krever `har_forvaltertilgang`; `OOM:263-269` gir IkkeAutorisert |
| `@OPT-OVO-GRU-004` | Avpublisere opptaket | funnet | `OH:47,52` — Publisert gir «Avpubliser opptaket», som setter Upublisert, med bekreftelse i `OH:186-218` |
| `@OPT-OVO-GRU-004` | Opptaket er aktivt når det er lagret | funnet | Avgjort av brukeren 2026-10-30: «ikke arkivert» er det samme som aktivt. Koden har ingen «aktiv»-status. Nytt opptak er UPUBLISERT (`AEO:14`), og `OF:140-150` (`assertOpptakAktivt`) regner alt som ikke er ARKIVERT som aktivt, men bare for søkerens handlinger. Koden har én statusakse (`OSK:5-7`), kravet to (aktiv/historisk ved siden av publisert/upublisert). |
| `@OPT-OVO-GRU-004` | Deltakende organisasjon ser et aktivt opptak før det er publisert | funnet | Saksbehandlerens opptaksoversikt: `fs-admin/src/app/soknadsbehandling/layout.tsx:12-14` (SE_ eller MODIFISERE_SØKNADSBEHANDLING) og `SOO:7-31` henter `opptak` uten statusfilter; `MIG/V280__opptak_v2_skjema.sql:1054-1055` — `SELECT USING (true)`. Forvalterens oversikt (`UGO:21-26`) har heller ikke statusfilter som standard |
| `@OPT-OVO-GRU-004` | Gjøre opptaket historisk | ikke funnet | `OH:45-48` har ingen handling for Arkivert. API-et godtar ARKIVERT via `OOM:192-193` — søkt etter «historisk», «arkiver», «avsluttOpptak», «arkiverOpptak», «Opptaksstatus.Arkivert», «ARKIVERT» i fs-admin, fs-plattform og min-kompetanse |
| `@OPT-OVO-GRU-004` | Opptaket kan ikke gjøres historisk før plasstildelingen er ferdig | ikke funnet | Ingen sjekk på status eller plasstildeling i `OOM:176-272` — søkt etter «plasstildeling» og «ARKIVERT» sammen |
| `@OPT-OVO-GRU-004` | Opptaksforvalter ved deltakende organisasjon kan ikke gjøre opptaket historisk | ikke funnet | Handlingen finnes ikke for noen. RLS (`V319:32-34`) ville stoppet deltakeren fra å sette ARKIVERT via API-et |
| `@OPT-OVO-GRU-004` | Innstillingene kan ikke endres i et historisk opptak | ikke funnet | `OOM:176-272` har ingen ARKIVERT-sjekk; `OH:150-158` viser «Endre innstillinger for opptaket» uansett status — søkt etter «ARKIVERT», «Arkivert» i fs-admin og fs-plattform |
| `@OPT-OVO-GRU-004` | Oppgaver kan ikke utføres i et historisk opptak | ikke funnet | ARKIVERT sperrer bare trekking og sletting av utdanningstilbud (`UM:1101-1103, 1145-1149`). Å knytte til utdanningstilbud styres av et tidsvindu (`UM:144,172,188`), ikke status. Ingen treff på «arkivert» eller «opptaksstatus» i saksbehandling og plasstildeling |
| `@OPT-OVO-GRU-004` | Saksbehandler kan søke etter søknader i et historisk opptak | funnet | `SAKGQ:9, 297-299` — `sakerV2` filtrerer på opptak, uten vilkår på opptaksstatus; RLS `MIG/V454…sql:35-40` uten opptaksstatus. Søket virker fordi ingenting stopper det |
| `@OPT-OVO-OVE-001` | Se liste over opptak | funnet | `OVV/components/OpptakResultList/OpptakResultList.tsx:61-78` — Navn, Type (koden), Status (`OpptakStatusTag`, l.65-66), Organisasjon (forkortelse), Opprettet og antall utdanningstilbud |
| `@OPT-OVO-OVE-001` | Velge sorteringsretning for <felt> | funnet | Avgjort av brukeren 2026-10-30: sortering på koden er godt nok. `OVV/components/OpptakOrderBy/OpptakOrderBy.tsx:19-24` og `OGQ:362-368` — sortering på opprettet, status, type og organisasjon. Kontrollen: status sorteres på koden (`OGQ:365`, PUBLISERT før UPUBLISERT), og organisasjon på organisasjonskoden (`OGQ:367`), mens lista viser «Ikke publisert»/«Publisert» og forkortelsen. Det brukeren ser for status og organisasjon, er derfor ikke sortert |
| `@OPT-OVO-OVE-001` | Tilgjengelige statuser i filter | funnet | `OVV/components/filter/OpptakStatusFilter/OpptakStatusFilter.tsx:11-15, 57-70` — «Ikke publisert», «Publisert» (og «Arkivert», som kravet sier ikke er med nå); `OVV/hooks/useGetOpptakOverviewState.ts:8` — ingen status valgt som standard |
| `@OPT-OVO-OVE-001` | Filtrere på status | funnet | `UGO:23` sender `opptakStatuser`; `OGQ:58` filtrerer på `opptaksstatus_kode` på opptaket |
| `@OPT-SØK-SØK-013` | Søkeren ser utdanningstilbud i et publisert opptak | funnet | `MKS:114-115` — Finn studier sender `opptaksstatuser: ["PUBLISERT"]`; `V2S:89-94` filtrerer på tilbudets egen status, som er PUBLISERT fra synken (`URS:253`), ikke på opptakets; `V2S:130-145` skjuler tilbud når opptakets ordinære søknadsfrist er utløpt eller mangler |
| `@OPT-SØK-SØK-013` | Søkeren ser utdanningstilbud i et publisert opptak før søknaden åpner | funnet | Ingen filter på SØKING_ÅPNER på main (`SGQ:16-20`, `V2S:89-145`). Blir branchen TAKE-467 merget slik den er, brytes dette (se `## Åpne MR-er og brancher`) |
| `@OPT-SØK-SØK-013` | Søkeren ser ikke utdanningstilbud i et upublisert opptak | ikke funnet | ikke funnet på main — `V2S:89-94` filtrerer på `utdanningstilbud.opptaksstatus_kode`, som bare synken skriver, alltid som PUBLISERT (`URS:253`, `OSK:9-10`: «også i et upublisert opptak»). Finnes på branchen `feature/take-467-upubliserte-opptak` (fs-plattform, branch uten MR-sjekk): `V2S` `harOpptaksstatuser` og `erSynligForSokere` — filtrerer på statusen til opptaket |
| `@OPT-SØK-SØK-013` | Søkeren ser ikke utdanningstilbud der søknadsfristen har gått ut | funnet | `V2S:130-145` `ekskluderUtlopteOrdinareSoknadsfrister`, aktivert i `MKS:114`. Koden ser på fristen for opptaket, ikke for utdanningstilbudet (det er det `@openquestion` spør om) |
| `@OPT-SØK-SØK-013` | Søkeren ser ikke et trukket utdanningstilbud | ikke funnet | `SGQ:203-242` (`SokerUtdanningstilbudFilterInput`) har ikke `erTrukket`, og `MKS:107-118` sender ingenting om trukne tilbud — søkt etter «trukket», «erTrukket», «TRUKKET_TIDSPUNKT» i min-kompetanse og fs-plattform, og i branchene `*trukket*` (de gjelder trukket søknad) |
| `@OPT-SØK-SØK-001` | Søkeren kan ikke begynne på en søknad når opptaket er avpublisert | ikke funnet | ikke funnet på main — `OF:140-151` sperrer bare ARKIVERT, og kladd og studiekurv (`SKS:61-111, 140-170`) sjekker ikke opptaksstatus. På branchen `feature/take-467-upubliserte-opptak` sperres innsending av en ny søknad (`OF` `assertCurrentIsAfter` med `opptakErPublisert`), men ikke kladd og studiekurv |
| `@OPT-SØK-SØK-001` | Søkeren kan ikke endre søknaden når opptaket er avpublisert | ikke funnet | ikke funnet på main — omprioritering (`SKS:471`), ettersending (`SKS:377`) og endring (`SKS:973, 983`) sjekker bare ARKIVERT og fristene. Finnes på branchen `feature/take-467-upubliserte-opptak` (fs-plattform, branch uten MR-sjekk): `OF` `assertCurrentIsAfter` med `opptakErPublisert` |
| `@OPT-SØK-SØK-001` | Søkeren ser søknaden når opptaket er avpublisert | funnet | `SGQ:126-151, 197` — søkerens søknader hentes uten filter på opptaksstatus; `min-kompetanse/src/utils/meg-som-soker-queries/get-meg-som-soker-soknader-query-variables.ts:11-19` sender bare id, opptak, aktiv og trukket. Funnet fordi ingenting filtrerer søknaden bort |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | tilgang | Opptaksforvalter oppretter opptaket | Opptaksforvalter oppretter opptaket, som er upublisert (l.21) | INSERT krever MODIFISERE_OPPTAK på opptakets organisasjon | stemmer | `MIG/V280__opptak_v2_skjema.sql:1057-1060`, `OOM:164-169` |
| `@OPT-OVO-GRU-004` | tilgang | Opptaksforvalter ved forvaltende organisasjon endrer opptaket (publiserer og avpubliserer) | Bare forvaltende organisasjon publiserer og avpubliserer (Regel l.18 og l.36) | RLS krever forvaltertilgang på opptakets organisasjon; fs-admin viser menyen bare for den | stemmer | `V319:32-34`, `MIG/V318…sql:33-46`, `OH:92-94, 140-146`, `OOM:263-269` |
| `@OPT-OVO-GRU-004` | organisasjon | Deltakende organisasjon leser opptaket | Deltakende organisasjon ser opptaket før det er publisert (l.54) | SELECT er åpen, og organisasjonsfilteret treffer deltakerne | stemmer | `V280:1054-1055`, `OS:48-67` |
| `@OPT-OVO-GRU-004` | tilgang | Opptaksforvalter gjør opptaket historisk | Bare forvaltende organisasjon (l.62) | UPDATE-policyen gjelder alle statusendringer, også til ARKIVERT, så bare forvalteren kan sette den. Handlingen mangler (se scenarioene) | stemmer | `V319:32-34`, `OOM:263-269` |
| `@OPT-OVO-GRU-004` | tilgang | Saksbehandler ved deltakende organisasjon leser opptaksoversikten | Saksbehandleren ser opptaket i opptaksoversikten (l.58-59) | Saksbehandlerens oversikt er `/soknadsbehandling`, med SE_ eller MODIFISERE_SØKNADSBEHANDLING, og henter opptak uten filter | stemmer | `fs-admin/src/app/soknadsbehandling/layout.tsx:12-14`, `SOO:7-31`, `V280:1054-1055` |
| `@OPT-OVO-GRU-004` | tilgang | Saksbehandler leser søknader i et opptak, uansett opptaksstatus | Saksbehandleren søker også i et historisk opptak (l.113) | Ingen sperre på opptaksstatus | stemmer | `SAKGQ:9`, `MIG/V454…sql:35-40` |
| `@OPT-SØK-SØK-013` | konsistens | Systemet holder synligheten for søkerne i takt med publiseringen | Søkerne ser tilbudene når opptaket er publisert, og ikke når det er upublisert (l.307) | `utdanningstilbud.opptaksstatus_kode` settes bare ved synk (alltid PUBLISERT) og holdes ikke i takt med `opptak.opptaksstatus_kode` | avviker | `URS:253`, `OSK:9-10`, `V2S:89-94`, `OOM:192-193` |
| `@OPT-SØK-SØK-013` | tilgang | Søker eller anonym leser utdanningstilbud | Finn studier er åpen for alle (beskrivelsen) | SELECT er åpen; synligheten styres bare av filtrene i GraphQL og klienten | stemmer | `V280:1157-1158` |
| `@OPT-SØK-SØK-013` | tilgang | Søker eller anonym leser utdanningstilbud i et upublisert opptak via API-et | Søkerne ser ikke tilbud i et upublisert opptak (l.307) | `utdanningstilbudForSokere` har ingen fast betingelse på publisering. En klient som ikke sender `opptaksstatuser`, får alle tilbudene | avviker | `SGQ:16-20`, `V280:1157-1158`, `MKS:115` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | Et ARKIVERT opptak stopper søkerens handlinger: begynne, sende, endre, trekke, besvare tilbud og søke tidlig opptak («Opptak er arkivert») | tilstandsovergang | `OF:140-150`, `SKS:577, 973, 1067`, `BesvarSoknadService.java:99` | legg til scenario med `fs-krav` |
| `@OPT-OVO-GRU-004` | Utdanningstilbud kan bare trekkes i et publisert opptak; i et upublisert opptak slettes de, og i et publisert eller arkivert opptak kan de ikke slettes | tilstandsovergang | `UM:1095-1127, 1140-1159` | testes i fase 2 |
| `@OPT-OVO-GRU-004` | Bekreftelse før publisering og avpublisering («Vil du publisere opptaket?»), og ved avpublisering har Avbryt fokus | annet | `OH:55-58, 102-107, 186-218` | testes i fase 2 |
| `@OPT-OVO-GRU-004` | `opprettOpptak` tar statusen fra klienten, så en API-klient kan opprette et opptak som allerede er PUBLISERT eller ARKIVERT | validering | `OOM:64, 69, 87, 761-765` | uklart om ønsket |
| `@OPT-OVO-GRU-004` | `oppdaterOpptak` validerer ikke overgangen, så statusen kan settes fritt, også fra ARKIVERT tilbake | validering | `OOM:192-193` | uklart om ønsket |
| `@OPT-OVO-GRU-004` | Et arkivert opptak kan verken publiseres eller avpubliseres i løsningen, menyen har bare «Endre innstillinger» | tilstandsovergang | `OH:45-48, 138, 159-171` | dekkes av `@draft`-scenario: Innstillingene kan ikke endres i et historisk opptak |
| `@OPT-OVO-GRU-004` | Utdanningstilbud som synkes fra UREG, får status PUBLISERT, også i et upublisert opptak | annet | `OSK:9-10`, `URS:253` | uklart om ønsket |
| `@OPT-OVO-GRU-004` | Feilmelding når statusen ikke finnes i kodeverket («Fant ikke opptaksstatusen») | validering | `OH:111-114` | testes i fase 2 |
| `@OPT-OVO-OVE-001` | Statusfilteret har også Arkivert | annet | `OVV/components/filter/OpptakStatusFilter/OpptakStatusFilter.tsx:14` | dekkes av `@draft`-scenario: Innstillingene kan ikke endres i et historisk opptak (Regel: Et historisk opptak kan bare ses og søkes i, opptaksstatus.feature:86) |
| `@OPT-OVO-OVE-001` | Sortering på status bruker koden (PUBLISERT, UPUBLISERT), ikke teksten som vises | annet | `OGQ:365`, `MIG/V280__opptak_v2_skjema.sql:282` | testes i fase 2 |
| `@OPT-OVO-OVE-001` | Sortering på organisasjon bruker organisasjonskoden, mens lista viser forkortelsen | annet | `OGQ:367`, `V280:279`, `OVV/components/OpptakResultList/OpptakResultList.tsx:68-70` | testes i fase 2 |
| `@OPT-OVO-OVE-001` | Organisasjonsfilteret bak flagget `opptak-filter-organisasjon` begrenser lista til organisasjonene der brukeren har MODIFISERE_ eller SE_OPPTAK; uten flagget vises alle opptak | tilgangssjekk | `UGO:11-14, 25, 33`, `OS:48-67` | uklart om ønsket |
| `@OPT-SØK-SØK-013` | Tilbud i et opptak uten ordinær søknadsfrist (SØKNADSFRIST_ORDINÆR) vises ikke i Finn studier | annet | `V2S:126-145` | legg til scenario med `fs-krav` |
| `@OPT-SØK-SØK-013` | Filterverdiene i Finn studier hentes også bare for PUBLISERT, med tilbudets egen status | annet | `min-kompetanse/src/components/find-studier/studier-filters/_queries/filter-options.ts:30` | testes i fase 2 |
| `@OPT-SØK-SØK-013` | (TAKE-467, ikke merget) Tilbud vises først når SØKING_ÅPNER har passert, og ikke når hendelsen mangler | tilstandsovergang | `origin/feature/take-467-upubliserte-opptak`: `V2S` `erSynligForSokere` | uklart om ønsket |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | Status på opptaket | 2 av 5 | 6 av 12 | 0 |
| `@OPT-SØK-SØK-013` | Listevisning og søk i utdanningstilbud (bare regelen i scope) | 0 av 1 | 2 av 5 | 0 |
| `@OPT-SØK-SØK-001` | Søke på opptak (bare regelen i scope, `@draft @openquestion`, med i gating fordi den er verifisert uansett status) | 1 av 1 | 3 av 3 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes på branchen` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | `feature/take-467-upubliserte-opptak` (commit `3894fd5da6`, «TAKE-467: Upubliserte opptak skjules for søkere og kan ikke søkes på», 2026-10-28) | branch uten MR-sjekk | `@OPT-SØK-SØK-013`, `@OPT-SØK-SØK-001` | 2/4 | Ingen nye commits siden 29.10, og 54 commits bak main. Finner «… ikke … i et upublisert opptak» (SØK-013) og «… ikke endre søknaden …» (SØK-001), og sperrer innsending av ny søknad, men ikke kladd og studiekurv. Skjuler også tilbud før SØKING_ÅPNER, og det **bryter** «Søkeren ser utdanningstilbud i et publisert opptak før søknaden åpner». Feilmeldingen ved avpublisert opptak er «Søking har ikke åpnet». glab mangler, så det er ikke sjekket om branchen har en MR |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | scenario | Opptaket er aktivt når det er lagret | funnet | usikker | `OSK:5-7`, `OF:140-150` — «aktiv» er en tolkning av «ikke ARKIVERT», og koden har ikke aksen aktiv/historisk ved siden av publisert/upublisert |
| `@OPT-OVO-GRU-004` | scenario | Deltakende organisasjon ser et aktivt opptak før det er publisert | funnet | funnet | Beviset flyttet til saksbehandlerens oversikt: `fs-admin/src/app/soknadsbehandling/layout.tsx:12-14`, `SOO:7-31` |
| `@OPT-OVO-GRU-004` | tilgang | Opptaksforvalter gjør opptaket historisk | ikke funnet | stemmer | `V319:32-34` — UPDATE-policyen gjelder også ARKIVERT; det som mangler, er handlingen, ikke tilgangssjekken |
| `@OPT-OVO-GRU-004` | tilgang | Saksbehandler ved deltakende organisasjon leser opptaksoversikten | usikker | stemmer | `fs-admin/src/app/soknadsbehandling/layout.tsx:12-14`, `SOO:7-31` — saksbehandleren har sin egen oversikt, `/opptak` er forvalterens |
| `@OPT-OVO-GRU-004` | tilgang | Opptaksforvalter oppretter opptaket | – | stemmer | Tilføyd: `V280:1057-1060`, `OOM:164-169` |
| `@OPT-OVO-OVE-001` | scenario | Velge sorteringsretning for <felt> | funnet | usikker | `OGQ:365, 367` — status og organisasjon sorteres på koden, ikke det som vises |
| `@OPT-SØK-SØK-013` | tilgang | Søker eller anonym leser utdanningstilbud i et upublisert opptak via API-et | – | avviker | Tilføyd: `SGQ:16-20` har ingen fast betingelse, synligheten styres bare av filteret klienten sender |
| `@OPT-OVO-GRU-004` | regel | Et arkivert opptak kan verken publiseres eller avpubliseres | – | dekkes av `@draft` | Tilføyd: `OH:45-48, 138, 159-171` |
| `@OPT-OVO-GRU-004` | regel | Utdanningstilbud fra UREG får PUBLISERT, også i et upublisert opptak | – | uklart om ønsket | Tilføyd: `OSK:9-10`, `URS:253` |
| `@OPT-OVO-GRU-004` | regel | Feilmelding når statusen ikke finnes | – | testes i fase 2 | Tilføyd: `OH:111-114` |
| `@OPT-OVO-OVE-001` | regel | Sortering på organisasjon bruker organisasjonskoden | – | uklart om ønsket | Tilføyd: `OGQ:367`, `V280:279` |
| `@OPT-OVO-OVE-001` | regel | Organisasjonsfilteret bak flagg | – | uklart om ønsket | Tilføyd: `UGO:11-14, 25, 33`, `OS:48-67` |
| `@OPT-SØK-SØK-013` | regel | Filterverdiene i Finn studier hentes bare for PUBLISERT | – | testes i fase 2 | Tilføyd: `filter-options.ts:30` |
| `@OPT-SØK-SØK-013` | regel | TAKE-467 skjuler tilbud før SØKING_ÅPNER | – | uklart om ønsket | Tilføyd: branchen `erSynligForSokere` |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen.

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-OVO-GRU-004` — Status på opptaket (`@implemented`, 6/12 funnet, 1 usikker) — allerede levert. Det som mangler, er de `@draft`-reglene om aktivt og historisk opptak (l.45, l.61, l.85), som er utenfor scope nå. Ingen endring
- `@OPT-OVO-OVE-001` — Listevisning og søk i opptak (`@implemented`, 3/4 funnet, 1 usikker) — allerede levert. Sorteringen på status og organisasjon må avklares (se spørsmålet)

Etter svarene: begge de usikre scenarioene er funnet. `@OPT-OVO-GRU-004` har 7/12, og hele `@draft`-regelen «Opptaket er aktivt når det er opprettet» (l.45) er nå funnet, men den blir stående som `@draft`, fordi brukeren bestemte 2026-10-29 at aktivt og historisk opptak er utenfor scope. `@OPT-OVO-OVE-001` har 4/4.
- `@OPT-SØK-SØK-013` — Regel: Synlighet via publiseringen av opptaket (`@draft`, 3/5 funnet) — egenskapen er `@draft`, og en regel kan ikke være levert når egenskapen ikke er det. Synligheten følger ikke publiseringen av opptaket på main
- `@OPT-SØK-SØK-001` — Regel: Søkeren kan ikke begynne på eller endre en søknad når opptaket er avpublisert (`@draft @openquestion`, 1/3 funnet) — sperrene finnes ikke på main

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | Regel: Opptaket er aktivt når det er opprettet | `@draft` | 2/2 | Alt funnet. Aktivt og historisk opptak er utenfor scope (brukeren, 2026-10-29), og regelen blir stående som `@draft` |
| `@OPT-SØK-SØK-013` | Regel: Synlighet via publiseringen av opptaket | `@draft` | 3/5 | 2 ikke funnet |
| `@OPT-SØK-SØK-001` | Regel: Søkeren kan ikke begynne på eller endre en søknad når opptaket er avpublisert | `@draft` | 1/3 | 2 ikke funnet |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Ingenting er endret i koden siden 29.10 for disse kravene:** filene som var bevis, er de samme på main (fs-plattform `2538996e87..e70216d1c4`, fs-admin `212e67f76..bd9f430d0`, min-kompetanse `86a284c5..8fbe6625`). TAKE-467 har ingen nye commits.
- **Finn studier følger ikke publiseringen av opptaket:** på main er tilbudene synlige i et upublisert opptak, fordi filteret ser på tilbudets egen status (`V2S:89-94`, `URS:253`, `OSK:9-10`), og fordi API-et ikke har en fast betingelse (`SGQ:16-20`). Det er rettet på `feature/take-467-upubliserte-opptak`, men ikke merget.
- **TAKE-467 er i strid med kravet:** branchen skjuler tilbudene til SØKING_ÅPNER har passert, men kravet sier at søkerne ser tilbudene i et publisert opptak også før søknaden åpner (finne_studier.feature:318). Det bør avklares med teamet før branchen merges.
- **Én statusakse i koden, to i kravet:** koden har UPUBLISERT/PUBLISERT/ARKIVERT på én akse (`OSK:5-7`), mens kravet har publisert/upublisert og aktiv/historisk. Koden og fs-admin bruker «arkivert», der kravet sier «historisk».
- **Feilmelding ved avpublisert opptak:** på TAKE-467-branchen får søkeren «Søking har ikke åpnet» når opptaket er avpublisert. Det hører til det åpne spørsmålet i søke_på_opptak.feature:191.
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Opptaksforvalter ved forvaltende organisasjon kan gjøre opptaket historisk» — Kan et historisk opptak gjøres aktivt igjen? (I dag kan `oppdaterOpptak` sette en hvilken som helst status, `OOM:192-193`.)
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Opptaksforvalter ved forvaltende organisasjon kan gjøre opptaket historisk» — Når er opptaket ferdig nok til å gjøres historisk: etter siste tildelingsrunde, etter siste svarfrist, eller når klagene er behandlet?
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Opptaksforvalter ved forvaltende organisasjon kan gjøre opptaket historisk» — Skal statusen hete «avsluttet» i stedet for «historisk»? (Koden og fs-admin sier «Arkivert».)
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Et historisk opptak kan bare ses og søkes i» — Vises historiske opptak i opptaksoversikten, og skal lista kunne filtreres på aktiv og historisk? (fs-admin har allerede Arkivert i statusfilteret.)
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Et historisk opptak kan bare ses og søkes i» — Kan et historisk opptak brukes som grunnlag for et nytt opptak?
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Oppgaver kan ikke utføres i et historisk opptak» — Skal saksbehandler kunne behandle klager i et historisk opptak?
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Saksbehandler kan søke etter søknader i et historisk opptak» — Hva ber HK-dir om i HK-9848, og når skal det gjelde?
- **Åpent spørsmål:** `@OPT-SØK-SØK-013` «Søkeren ser ikke utdanningstilbud der søknadsfristen har gått ut» — Hvilken frist styrer når tilbudet forsvinner? (Koden bruker fristen for opptaket.)
- **Åpent spørsmål:** `@OPT-SØK-SØK-013` «Søkeren ser ikke et trukket utdanningstilbud» — Skal et trukket tilbud skjules eller vises som trukket?
- **Åpent spørsmål:** `@OPT-SØK-SØK-001` «Regel: Søkeren kan ikke begynne på eller endre en søknad når opptaket er avpublisert» — Hva skjer med søknader som er påbegynt eller sendt inn mens opptaket er avpublisert, og hvordan får søkeren vite det?
- **Tilgang avviker:** `@OPT-SØK-SØK-013` systemet holder synligheten i takt med publiseringen — kravet sier at søkerne ikke ser tilbud i et upublisert opptak, men `utdanningstilbud.opptaksstatus_kode` holdes ikke i takt med opptaket, `URS:253`.
- **Tilgang avviker:** `@OPT-SØK-SØK-013` søker eller anonym leser utdanningstilbud i et upublisert opptak via API-et — synligheten styres bare av filteret klienten sender, `SGQ:16-20`.
- **`@draft` uten åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Opptaket er aktivt når det er opprettet» (opptaksstatus.feature:46) har `@draft` uten `@openquestion`, og vises som avvik i FS Kravforvaltning til den er gjennomgått med `fs-krav`.
- **Ikke sjekket:** åpne MR-er (glab finnes ikke på maskinen), og fs-admin på branchen som er utsjekket (lest origin/main i stedet).
- **Krav utenfor scope:** `opprett_opptak.feature` og `frister_og_hendelser.feature` — bare kommentarer er endret, eller en `@draft`-regel er fjernet, i PR #843. Ikke verifisert.
