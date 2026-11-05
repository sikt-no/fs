# Verifisering: endringene i PR #843 (opptaksstatus)

- **Dato:** 2026-10-29 10:50
- **Krav:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opptaksstatus.feature`, `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/finne_studier.feature` (bare Regel: Synlighet via publiseringen av opptaket), `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/søke_på_opptak.feature` (bare Regel: Søkeren kan ikke begynne på eller endre en søknad når opptaket er avpublisert) (3 feature-filer)
- **Kode:** `fs-plattform` (origin/main, `2538996e87`, lest med git show/grep; lokal main 2 bak origin), `fs-admin` (origin/main, `212e67f76`, lest med git show/grep; utsjekket branch `karen.sikkeland/216-feat-plasstildeling-runder-utkast` med lokale endringer er ikke lest), `min-kompetanse` (main, `86a284c5`, oppdatert)
- **Åpne MR-er:** ikke sjekket (glab finnes ikke på maskinen). 1 branch uten MR-sjekk i fs-plattform med kode for kravene
- **Omfang:** endringene i PR #843, uansett status (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `OH` = `fs-admin/src/domains/opptak/features/OpptakDetails/components/OpptakHandlinger/OpptakHandlinger.tsx`
- `AEO` = `fs-admin/src/domains/opptak/features/OpptakManagement/utils/emptyObjectGenerators.ts`
- `ACI` = `fs-admin/src/domains/opptak/features/OpptakManagement/utils/convertDataToInput.tsx`
- `UGO` = `fs-admin/src/domains/opptak/features/OpptakOverviewView/hooks/useGetOpptak.tsx`
- `OOM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpprettOpptakMutations.java`
- `OF` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Opptaksfrister.java`
- `OSK` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Opptaksstatuskoder.java`
- `UM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `V2S` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudV2Service.java`
- `OS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpptakService.java`
- `SKS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `URS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/klient/ureg/UregStudieprogramService.java`
- `SGQ` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/soknad/soknad.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `MKS` = `min-kompetanse/src/components/find-studier/_utils/get-search-param-funcs.ts`

## Oppsummering

- Scenarioer: 11 funnet, 9 ikke funnet, 0 usikker, av 20
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 2
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 4 stemmer, 1 avviker, 1 ikke funnet, 1 usikker, av 7
- Regler i koden uten scenario: 7
- Åpne spørsmål: 3 regler og 11 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

Ingen. Begge `@depends-on-` i scope (finne_studier.feature:306 og søke_på_opptak.feature:187) peker på `@OPT-OVO-GRU-004`, som selv er i scope.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | Opptaket er upublisert når det er opprettet | funnet | `AEO:14` — nytt opptak får `Opptaksstatus.Upublisert`; `ACI:59-63` sender UPUBLISERT som standard; `OOM:64,69,87` lagrer statusen (fs-admin-commit `9da259785`, 2026-10-28) |
| `@OPT-OVO-GRU-004` | Publisere opptaket | funnet | `OH:45-53` — Upublisert gir «Publiser opptaket», som setter Publisert; `OH:109-119` kaller `oppdaterOpptak` med `opptaksstatusId`; `OOM:192-193` lagrer statusen |
| `@OPT-OVO-GRU-004` | Opptaksforvalter ved deltakende organisasjon kan ikke publisere opptaket | funnet | `OH:92-94` — `useWithRole(MODIFISERE_OPPTAK)` på eierorganisasjonen; `OH:140-146` viser bare «Administreres av …», uten meny; `MIG/V319__opptak_v2_skriving_krever_forvalter.sql:32-34` — RLS krever `har_forvaltertilgang`; `OOM:263-269` gir «Mangler tilgang» |
| `@OPT-OVO-GRU-004` | Avpublisere opptaket | funnet | `OH:47,52` — Publisert gir «Avpubliser opptaket», som setter Upublisert, med bekreftelse i `OH:186-218` |
| `@OPT-OVO-GRU-004` | Opptaket er aktivt når det er lagret | funnet | Nytt opptak er UPUBLISERT (`AEO:14`), og `OF:140-150` (`assertOpptakAktivt`) regner alt som ikke er ARKIVERT som aktivt. Koden har én statusakse (UPUBLISERT/PUBLISERT/ARKIVERT, `OSK:5-7`), og «aktiv» er en tolkning, ikke et eget felt |
| `@OPT-OVO-GRU-004` | Deltakende organisasjon ser et aktivt opptak før det er publisert | funnet | `MIG/V280__opptak_v2_skjema.sql:1054-1055` — `SELECT USING (true)`; `UGO:21-26` — ingen statusfilter som standard; `OS:48-63` — organisasjonsfilteret treffer eieren og de samordna deltakerne. Krever at saksbehandleren har SE_OPPTAK (se `## Tilgang og datakonsistens`) |
| `@OPT-OVO-GRU-004` | Gjøre opptaket historisk | ikke funnet | `OH:45-48` har ingen handling for Arkivert, og fs-admin har ingen annen. API-et godtar ARKIVERT via `OOM:192-193` uten noen sjekk — søkt etter «historisk», «avslutt», «arkiv», «ARKIVERT», «Arkivert» i fs-admin og fs-plattform |
| `@OPT-OVO-GRU-004` | Opptaket kan ikke gjøres historisk før plasstildelingen er ferdig | ikke funnet | Ingen sjekk på status eller plasstildeling i `OOM:176-272` — søkt etter «OPPTAKSSTATUS» og «ARKIVERT» under `…/plasstildeling` |
| `@OPT-OVO-GRU-004` | Opptaksforvalter ved deltakende organisasjon kan ikke gjøre opptaket historisk | ikke funnet | Handlingen finnes ikke for noen. Deltakeren ser ingen meny (`OH:140-146`), og RLS (`V319:32-34`) ville stoppet ARKIVERT via API-et |
| `@OPT-OVO-GRU-004` | Innstillingene kan ikke endres i et historisk opptak | ikke funnet | `OOM:176-272` har ingen ARKIVERT-sjekk; `OH:150-158` viser «Endre innstillinger for opptaket» uansett status — søkt etter «ARKIVERT», «Arkivert» i fs-admin og fs-plattform |
| `@OPT-OVO-GRU-004` | Oppgaver kan ikke utføres i et historisk opptak | ikke funnet | ARKIVERT sperrer bare trekking og sletting av utdanningstilbud (`UM:1101-1103, 1145-1149`), ikke at tilbud knyttes til opptaket. Ingen treff på «OPPTAKSSTATUS» eller «ARKIVERT» i saksbehandling og plasstildeling |
| `@OPT-OVO-GRU-004` | Saksbehandler kan søke etter søknader i et historisk opptak | funnet | `fs-admin/src/app/opptak/[id]/soknadsbehandling/page.tsx` → `toSakFilterInput.ts:32` → `sakerV2` (`fs-plattform/…/saksbehandling/sak.graphqls:286-300`) — ingen vilkår på opptaksstatus, og ingen RLS på ARKIVERT. Søket virker fordi ingenting stopper det, ikke fordi kravet er bygget |
| `@OPT-SØK-SØK-013` | Søkeren ser utdanningstilbud i et publisert opptak | funnet | `MKS:114-115` — Finn studier sender `opptaksstatuser: ["PUBLISERT"]`; `V2S:89-94` filtrerer på tilbudets egen status, som er PUBLISERT fra synken (`URS:253`), ikke på opptakets status; `V2S:125-140` skjuler tilbud når opptakets ordinære søknadsfrist er utløpt eller mangler |
| `@OPT-SØK-SØK-013` | Søkeren ser utdanningstilbud i et publisert opptak før søknaden åpner | funnet | Ingen filter på SØKING_ÅPNER på main (`V2S:125-140` ser bare på søknadsfristen). Blir branchen TAKE-467 merget slik den er, brytes dette (se `## Åpne MR-er og brancher`) |
| `@OPT-SØK-SØK-013` | Søkeren ser ikke utdanningstilbud i et upublisert opptak | ikke funnet | ikke funnet på main — `V2S:89-94` filtrerer på `utdanningstilbud.opptaksstatus_kode`, som synken alltid setter til PUBLISERT (`URS:253`, `OSK:9-10`: «også i et upublisert opptak»), og som aldri synkes fra opptaket. Finnes på branchen `feature/take-467-upubliserte-opptak` (fs-plattform, branch uten MR-sjekk): `V2S` `harOpptaksstatuser` og `erSynligForSokere` — filtrerer på statusen til opptaket |
| `@OPT-SØK-SØK-013` | Søkeren ser ikke utdanningstilbud der søknadsfristen har gått ut | funnet | `V2S:125-140` `ekskluderUtlopteOrdinareSoknadsfrister`, aktivert i `MKS:114`. Koden ser på fristen for opptaket, ikke for utdanningstilbudet (det er det `@openquestion` spør om) |
| `@OPT-SØK-SØK-013` | Søkeren ser ikke et trukket utdanningstilbud | ikke funnet | `SGQ:203-242` (`SokerUtdanningstilbudFilterInput`) har ikke `erTrukket`, og `MKS:107-118` sender ingenting om trukne tilbud. `V2S:96-102` brukes bare av saksbehandlerens inngang — søkt etter «trukket», «erTrukket», «trukketTidspunkt» i min-kompetanse og fs-plattform |
| `@OPT-SØK-SØK-001` | Søkeren kan ikke begynne på en søknad når opptaket er avpublisert | ikke funnet | ikke funnet på main — `OF:140-150` sperrer bare ARKIVERT, og fristsjekkene ser bare på tidspunkt. Heller ikke på branchen `feature/take-467-upubliserte-opptak` (fs-plattform): kladd og studiekurv (`SKS:61-111, 140-180`) kan opprettes uten sjekk, og bare levering stoppes |
| `@OPT-SØK-SØK-001` | Søkeren kan ikke endre søknaden når opptaket er avpublisert | ikke funnet | ikke funnet på main — omprioritering (`SKS:471`), ettersending (`SKS:377`) og endring (`SKS:973, 983`) sjekker bare ARKIVERT og fristene. Finnes på branchen `feature/take-467-upubliserte-opptak` (fs-plattform, branch uten MR-sjekk): `OF` `assertCurrentIsAfter` med `opptakErPublisert` sperrer levering, omprioritering, ettersending og endring |
| `@OPT-SØK-SØK-001` | Søkeren ser søknaden når opptaket er avpublisert | funnet | `SGQ:126-151, 197` — søkerens søknader hentes uten filter på opptaksstatus; `min-kompetanse/src/utils/meg-som-soker-queries/get-meg-som-soker-soknader-query-variables.ts:11-19` sender bare id, opptak, aktiv og trukket. Funnet fordi ingenting filtrerer søknaden bort |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | tilgang | Opptaksforvalter ved forvaltende organisasjon endrer opptaket (publiserer og avpubliserer) | Bare forvaltende organisasjon publiserer og avpubliserer (Regel l.18 og l.36) | RLS krever forvaltertilgang på eierorganisasjonen; fs-admin viser menyen bare for eieren | stemmer | `V319:32-34`, `OH:92-94, 140-146`, `OOM:263-269` |
| `@OPT-OVO-GRU-004` | organisasjon | Deltakende organisasjon leser opptaket | Deltakende organisasjon ser opptaket før det er publisert (l.53) | SELECT er åpen, og organisasjonsfilteret treffer deltakerne | stemmer | `V280:1054-1055`, `OS:48-63` |
| `@OPT-OVO-GRU-004` | tilgang | Opptaksforvalter gjør opptaket historisk | Bare forvaltende organisasjon, og bare når plasstildelingen er ferdig (l.61) | Ingen handling. Forvalteren kan sette ARKIVERT via `oppdaterOpptak` uten sjekk og uten at koden valideres; RLS stopper deltakeren | ikke funnet | `OOM:192-193` |
| `@OPT-OVO-GRU-004` | tilgang | Saksbehandler ved deltakende organisasjon leser opptaksoversikten | Saksbehandleren ser opptaket i opptaksoversikten (l.57-58) | Opptaksoversikten krever `FS-ADMIN_MODIFISERE_OPPTAK` eller `FS-ADMIN_SE_OPPTAK`, og OPPTAK og SØKNADSBEHANDLING er bevisst adskilte tilganger | usikker | `fs-admin/src/app/opptak/layout.tsx`, `MIG/V318…:49` |
| `@OPT-OVO-GRU-004` | tilgang | Saksbehandler leser søknader i et opptak, uansett opptaksstatus | Saksbehandleren søker også i et historisk opptak (l.112) | Ingen sperre på opptaksstatus | stemmer | `fs-plattform/…/saksbehandling/sak.graphqls:286-300` |
| `@OPT-SØK-SØK-013` | konsistens | Systemet holder synligheten for søkerne i takt med publiseringen | Søkerne ser tilbudene når opptaket er publisert, og ikke når det er upublisert (l.307) | `utdanningstilbud.opptaksstatus_kode` settes bare ved synk (alltid PUBLISERT) og holdes ikke i takt med `opptak.opptaksstatus_kode` | avviker | `URS:253`, `OSK:9-10`, `V2S:89-94`, `OOM:192-193` |
| `@OPT-SØK-SØK-013` | tilgang | Søker eller anonym leser utdanningstilbud | Finn studier er åpen for alle (beskrivelsen) | SELECT er åpen; synligheten styres bare av filtrene i GraphQL og klienten | stemmer | `V280:1157-1158` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | Et ARKIVERT opptak stopper søkerens handlinger: begynne, sende, endre, trekke, besvare tilbud og søke tidlig opptak («Opptak er arkivert») | tilstandsovergang | `OF:140-150`, `SKS:577, 973, 1067, 1156`, `BesvarSoknadService.java:106`, `SokTidligOpptakService.java:55` | legg til scenario med `fs-krav` |
| `@OPT-OVO-GRU-004` | Utdanningstilbud kan bare trekkes i et publisert opptak; i et upublisert opptak slettes de («Opptaket er ikke publisert, så studiet kan ikke trekkes»), og i et publisert eller arkivert opptak kan de ikke slettes | tilstandsovergang | `UM:1095-1108, 1140-1159` | testes i fase 2 |
| `@OPT-OVO-GRU-004` | Bekreftelse før publisering og avpublisering («Vil du publisere opptaket?»), og ved avpublisering har Avbryt fokus | annet | `OH:55-58, 102-107, 186-218` | testes i fase 2 |
| `@OPT-OVO-GRU-004` | Opptaksoversikten har statuskolonne og statusfilter (Upublisert, Publisert, Arkivert) | annet | `fs-admin/src/domains/opptak/features/OpptakOverviewView/components/filter/OpptakStatusFilter/OpptakStatusFilter.tsx:12-14`, `…/OpptakResultList/OpptakResultList.tsx:65-66` | uklart om ønsket |
| `@OPT-OVO-GRU-004` | `opprettOpptak` tar statusen fra klienten, så en API-klient kan opprette et opptak som allerede er PUBLISERT eller ARKIVERT | validering | `OOM:64, 69, 87` | uklart om ønsket |
| `@OPT-OVO-GRU-004` | `oppdaterOpptak` validerer ikke statusen (det gjør `opprettOpptak`), så statusen kan settes fritt, også fra ARKIVERT tilbake | validering | `OOM:192-193` (jf. `OOM:69`) | uklart om ønsket |
| `@OPT-SØK-SØK-013` | Tilbud i et opptak uten ordinær søknadsfrist (SØKNADSFRIST_ORDINÆR) vises ikke i Finn studier | annet | `V2S:125-140` | legg til scenario med `fs-krav` |

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
| `fs-plattform` | `feature/take-467-upubliserte-opptak` (commit `3894fd5da6`, «TAKE-467: Upubliserte opptak skjules for søkere og kan ikke søkes på», 2026-10-28) | branch uten MR-sjekk | `@OPT-SØK-SØK-013`, `@OPT-SØK-SØK-001` | 2/4 | Finner «… ikke … i et upublisert opptak» (SØK-013) og «… ikke endre søknaden …» (SØK-001). Skjuler også tilbud før SØKING_ÅPNER, og det **bryter** «Søkeren ser utdanningstilbud i et publisert opptak før søknaden åpner» (endret 2026-10-29). Sperrer ikke at søkeren begynner på en søknad. Feilmeldingen ved avpublisert opptak er «Søking har ikke åpnet». glab mangler, så det er ikke sjekket om branchen har en MR |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | scenario | Saksbehandler kan søke etter søknader i et historisk opptak | usikker | funnet | `fs-plattform/…/saksbehandling/sak.graphqls:286-300` — søket i saksbehandlingen (`sakerV2`) har ikke noe vilkår på opptaksstatus |
| `@OPT-OVO-GRU-004` | tilgang | Saksbehandler ved deltakende organisasjon leser opptaksoversikten | – | usikker | Tilføyd: `fs-admin/src/app/opptak/layout.tsx` krever SE_ eller MODIFISERE_OPPTAK |
| `@OPT-OVO-GRU-004` | tilgang | Saksbehandler leser søknader i et opptak, uansett status | – | stemmer | Tilføyd: `sak.graphqls:286-300` |
| `@OPT-SØK-SØK-013` | tilgang | Søker eller anonym leser utdanningstilbud | – | stemmer | Tilføyd: `V280:1157-1158` |
| `@OPT-OVO-GRU-004` | regel | `oppdaterOpptak` validerer ikke statusen | – | uklart om ønsket | Tilføyd: `OOM:192-193` |
| `@OPT-SØK-SØK-013` | regel | Tilbud i et opptak uten ordinær søknadsfrist vises ikke | – | legg til scenario | Tilføyd: `V2S:125-140` |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-OVO-GRU-004` — Status på opptaket (`krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opptaksstatus.feature`, `@draft` → `@in-progress`, 7/12 funnet) — `@implemented` på: Regel: Opptaksforvalter ved forvaltende organisasjon publiserer opptaket (linje 18), Regel: Opptaksforvalter ved forvaltende organisasjon kan avpublisere opptaket (linje 36), Regel: Opptaket er aktivt når det er opprettet (linje 45), Scenario: Saksbehandler kan søke etter søknader i et historisk opptak (linje 112). Kravet er ikke validert (`@draft`) og ikke i en spesifikasjon.

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-SØK-SØK-013` — Regel: Synlighet via publiseringen av opptaket (`@draft`, 3/5 funnet) — egenskapen er `@draft`, og en regel kan ikke være levert når egenskapen ikke er det. Synligheten følger ikke publiseringen av opptaket på main
- `@OPT-SØK-SØK-001` — Regel: Søkeren kan ikke begynne på eller endre en søknad når opptaket er avpublisert (`@draft @openquestion`, 1/3 funnet) — sperrene finnes ikke på main

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-004` | Status på opptaket (publisering og avpublisering; Regel l.45, l.61 og l.85 fikk `@draft` etter avklaring med brukeren) | `krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opptaksstatus.feature` | `@draft` | 4/4 |

Brukeren avklarte at aktivt, historisk og arkivert opptak er utenfor scope nå og fortsatt er utkast. Regel l.45 fikk `@draft`, og l.61 og l.85 fikk `@draft @openquestion`, så gating-settet ble Regel l.18 og l.36 (4 scenarioer, alle funnet). Forslaget om delvis levert (7/12) ble ikke brukt.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-013` | Regel: Synlighet via publiseringen av opptaket | `@draft` | 3/5 | 2 ikke funnet |
| `@OPT-SØK-SØK-001` | Regel: Søkeren kan ikke begynne på eller endre en søknad når opptaket er avpublisert | `@draft` | 1/3 | 2 ikke funnet |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Finn studier følger ikke publiseringen av opptaket:** på main er tilbudene synlige i et upublisert opptak, fordi filteret ser på tilbudets egen status (`V2S:89-94`, `URS:253`, `OSK:9-10`). Det er rettet på `feature/take-467-upubliserte-opptak`, men ikke merget.
- **TAKE-467 er i strid med kravet:** branchen skjuler tilbudene til SØKING_ÅPNER har passert, men kravet ble endret 2026-10-29 til at søkerne ser tilbudene i et publisert opptak også før søknaden åpner (finne_studier.feature:318, frister_og_hendelser.feature). Det bør avklares med teamet før branchen merges.
- **Én statusakse i koden, to i kravet:** koden har UPUBLISERT/PUBLISERT/ARKIVERT på én akse (`OSK:5-7`), mens kravet har publisert/upublisert og aktiv/historisk. Det går bare opp hvis et historisk opptak alltid er upublisert (PR-beskrivelsen sier det, men scenarioene gjør det ikke). Koden og PR-en bruker «arkivert» (`opptak.json:25`), der kravet sier «historisk».
- **Feilmelding ved avpublisert opptak:** på TAKE-467-branchen får søkeren «Søking har ikke åpnet» (`SoknadFeilSoknadfristIkkeStartet`) når opptaket er avpublisert. Det hører til det åpne spørsmålet i søke_på_opptak.feature:191.
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Opptaksforvalter ved forvaltende organisasjon kan gjøre opptaket historisk» — Kan et historisk opptak gjøres aktivt igjen? (I dag kan `oppdaterOpptak` sette en hvilken som helst status, `OOM:192-193`.)
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Opptaksforvalter ved forvaltende organisasjon kan gjøre opptaket historisk» — Når er opptaket ferdig nok til å gjøres historisk: etter siste tildelingsrunde, etter siste svarfrist, eller når klagene er behandlet?
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Opptaksforvalter ved forvaltende organisasjon kan gjøre opptaket historisk» — Skal statusen hete «avsluttet» i stedet for «historisk»? (Koden og fs-admin sier «Arkivert».)
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Et historisk opptak kan bare ses og søkes i» — Vises historiske opptak i opptaksoversikten, og skal lista kunne filtreres på aktiv og historisk? (fs-admin har allerede et statusfilter med Arkivert.)
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Et historisk opptak kan bare ses og søkes i» — Kan et historisk opptak brukes som grunnlag for et nytt opptak?
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Oppgaver kan ikke utføres i et historisk opptak» — Skal saksbehandler kunne behandle klager i et historisk opptak?
- **Åpent spørsmål:** `@OPT-OVO-GRU-004` «Saksbehandler kan søke etter søknader i et historisk opptak» — Hva ber HK-dir om i HK-9848, og når skal det gjelde?
- **Åpent spørsmål:** `@OPT-SØK-SØK-013` «Søkeren ser ikke utdanningstilbud der søknadsfristen har gått ut» — Hvilken frist styrer når tilbudet forsvinner? (Koden bruker fristen for opptaket.)
- **Åpent spørsmål:** `@OPT-SØK-SØK-013` «Søkeren ser ikke et trukket utdanningstilbud» — Skal et trukket tilbud skjules eller vises som trukket?
- **Åpent spørsmål:** `@OPT-SØK-SØK-001` «Regel: Søkeren kan ikke begynne på eller endre en søknad når opptaket er avpublisert» — Hva skjer med søknader som er påbegynt eller sendt inn mens opptaket er avpublisert, og hvordan får søkeren vite det?
- **Tilgang avviker:** `@OPT-SØK-SØK-013` systemet holder synligheten i takt med publiseringen — kravet sier at søkerne ikke ser tilbud i et upublisert opptak, men `utdanningstilbud.opptaksstatus_kode` holdes ikke i takt med opptaket, `URS:253`.
- **Tilgang ikke funnet:** `@OPT-OVO-GRU-004` opptaksforvalter gjør opptaket historisk — handlingen finnes ikke, og API-et lar forvalteren sette ARKIVERT uten sjekk, `OOM:192-193`.
- **Tilgang usikker:** `@OPT-OVO-GRU-004` saksbehandler ved deltakende organisasjon leser opptaksoversikten — oversikten krever SE_OPPTAK, `fs-admin/src/app/opptak/layout.tsx`. Bør kravet si opptaksforvalter, eller skal saksbehandlere uten SE_OPPTAK se oversikten?
- **`@draft` uten åpent spørsmål:** `@OPT-OVO-GRU-004` «Regel: Opptaket er aktivt når det er opprettet» (opptaksstatus.feature:46) har `@draft` uten `@openquestion`, og vises som avvik («utkast som ikke er gjennomgått») i FS Kravforvaltning til den er gjennomgått med `fs-krav`.
- **Ikke sjekket:** åpne MR-er (glab finnes ikke på maskinen), og fs-admin på branchen som er utsjekket (lest origin/main i stedet).
- **Krav utenfor scope:** `opprett_opptak.feature`, `frister_og_hendelser.feature` og `listevisning_og_sok_i_opptak.feature` — bare kommentarer er endret, eller en `@draft`-regel er fjernet, i PR #843. Ikke verifisert. listevisning_og_sok_i_opptak.feature sier at status ikke er med i lista, men fs-admin har statuskolonne og statusfilter (se `## Regler uten scenario`).
