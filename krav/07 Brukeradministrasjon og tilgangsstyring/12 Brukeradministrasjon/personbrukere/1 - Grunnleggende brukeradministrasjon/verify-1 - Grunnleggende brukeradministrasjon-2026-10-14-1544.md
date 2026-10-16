# Verifisering: 1 - Grunnleggende brukeradministrasjon

- **Dato:** 2026-10-14 15:44
- **Krav:** `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon` (7 feature-filer)
- **Kode:** `fs-plattform` (main, 313ea12bb5, oppdatert), `fs-admin` (main, ddb5deb7a, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 7 kontrollører (`fs-verify-kontroll`), 1–2 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i `@planned`-, `@in-progress`- og `@implemented`-krav og -deler, også `@openquestion`, minus `@draft`, `@deprecated` og `@demo` (verifisert uansett status; `@draft` er holdt utenfor etter ønske fra brukeren).

Stiene er forkortet:

- `P-db` = `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog`
- `P-svc` = `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service`
- `P-schema` = `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental`
- `A-ts` = `fs-admin/src/domains/tilgangsstyring/features`
- `A-roller` = `fs-admin/src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller`
- `A-msg` = `fs-admin/src/common/messages/nb`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Aktivere og deaktivere en personbrukers samlede tilganger | 2/3 | fs-plattform | Reaktivering nuller det som er lagret om deaktiveringen, og lagrer ikke varig når og av hvem reaktiveringen ble gjort. Endringsloggen («fase 4b») er ikke laget. |
| `@BRU-PER-GRU-012` | Fjerne roller fra en personbruker | 5/7 | fs-admin | Serveren håndhever retten, men fs-admin tilbyr organisasjoner der administratoren bare har retten til å tildele til applikasjoner, og miljøer uten rett. |
| `@BRU-PER-GRU-007` | Se detaljer for personbruker | 5/5 | ingen | – |
| `@BRU-PER-GRU-001` | Listevisning og søk i personbrukere | 15/18 | fs-plattform | Synligheten teller enhver aktiv tildeling, også tilganger, ikke bare roller. Kildene til filtrene for hjemorganisasjon og rolle følger ikke det listen viser. |
| `@BRU-PER-GRU-010` | Automatisk synkronisering av roller fra namespacet "frontend/fs-admin" | 0/11 | fs-plattform, fs-admin | Ingen synkjobb, ingen markering av utgåtte roller og ingen rollehistorikk. Kilden («namespacet») kan ligge i et repo som ikke er sjekket. |
| `@BRU-PER-GRU-003` | Tildele roller til en personbruker | 6/8 | fs-plattform | Valglistene for organisasjon og rolle er unionen av retten til å tildele til applikasjoner og til personbrukere. |
| `@BRU-PER-GRU-008` | Se en personbrukers roller | 4/7 | fs-plattform, fs-admin | Kolonnen heter «Organisasjon», ikke «Gjelder for». Filtervalgene for organisasjon og miljø tar med organisasjoner og miljøer der brukeren bare har tilganger. |

Gjenstår: fs-plattform 3, fs-plattform, fs-admin 2, fs-admin 1, ingen 1.

## Oppsummering

- Scenarioer: 37 funnet, 8 ikke funnet, 14 usikker, av 59
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 2
- Krav og deler som ikke er levert: 5
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 5

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Deaktivere en personbruker med aktive tildelinger | funnet | P: funnet · A: funnet — `P-svc/FeideBrukerStatusService.java:119-127` (tidspunkt og aktør), `P-db/0033-deaktivering-feide-bruker.sql:74-75,106-114` (status DEAKTIVERT, tom tilgangsberegning), `P-db/0086-personsubjekt-inflight-migrering.sql:425`; `A-ts/PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerStatusActions.tsx:46,54-63` → `DeaktiverPersonbrukerModal.tsx:91-105` → `hooks/useDeaktiverPersonbruker.tsx:39-56` |
| `@BRU-PER-GRU-004` | Reaktivere en deaktivert personbruker | ikke funnet | P: delvis · A: funnet — status Aktiv og tildelingene gjelder igjen, utløpte blir ikke aktive (`P-svc/FeideBrukerStatusService.java:128-133`, test `30_deaktivering_feide_bruker.sql:200-236`; `A-ts/PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerStatusActions.tsx:47,65-76`, `ReaktiverPersonbrukerModal.tsx:88-108`). Mangler: reaktiveringen nuller `deaktivert_tidspunkt` og begge aktørkolonnene, så det som var lagret om deaktiveringen, beholdes ikke, og det lagres ikke varig når og av hvem reaktiveringen ble gjort. Endringsloggen er bare nevnt i kommentarer (`P-db/0026-deaktivert-av.sql:26-28`, `P-schema/schema_brukeradmin.graphqls:371-372`) — søkt etter «endringslogg», «fase 4b», «reaktivert_tidspunkt», «reaktivert_av», «statushistorikk», «feide_bruker_historikk» i fs-plattform og fs-admin |
| `@BRU-PER-GRU-004` | Deaktivering skiller seg fra fjerning av tildelinger | funnet | P: funnet · A: funnet — `P-svc/FeideBrukerStatusService.java:62-65`, `P-db/0033-deaktivering-feide-bruker.sql:11-15` (tildelingene røres ikke, test `30_deaktivering_feide_bruker.sql:186-205`); `A-ts/PersonbrukerDetails/components/PersonbrukerTopBar/PersonbrukerStatusActions.tsx:54-76`, `A-msg/domains.json:219,231` |
| `@BRU-PER-GRU-012` | Fjerne en rolle for valgt organisasjon og miljø | funnet | P: funnet · A: funnet — `A-roller/components/PersonbrukerRollerActions/actions/FjernRolleAction/FjernRolleAction.tsx:127-133`; `P-db/0087-tildeling-til-personsubjekt.sql:189-197` (lukker bare raden med samme rolle, organisasjon og miljø) |
| `@BRU-PER-GRU-012` | Fjerne en aktiv rolle fra en personbruker | funnet | P: funnet · A: funnet — `FjernRolleAction.tsx:263-316`; `P-schema/schema_brukeradmin.graphqls:656-658`, `P-svc/FeideBrukerTilgangService.java:89-118` → `fjern_brukertilgang` |
| `@BRU-PER-GRU-012` | Fjerne flere roller samtidig | funnet | P: funnet · A: funnet — `FjernRolleAction.tsx:398-407`, `A-roller/hooks/useFjernFeideBrukerTilganger.tsx:155-171`; `P-svc/FeideBrukerTilgangService.java:91-117` |
| `@BRU-PER-GRU-012` | Fjerning er ikke tilgjengelig for roller uten rettighet | usikker | P: funnet · A: delvis — `P-db/0087-tildeling-til-personsubjekt.sql:168-170` (`krev_feidebruker_tildelingsrett`), `P-svc/FeideBrukerTilgangService.java:209`. fs-admin skjuler handlingen uten rollen (`A-roller/PersonbrukerRoller.tsx:72`), men organisasjonsvelgeren bruker `mine_tildelingsorganisasjoner`, som er unionen av applikasjons- og personbrukerretten og ser bort fra miljø (`P-db/0057-tildelinger-splittes-etter-subjekttype.sql:433-448`), og miljøvelgeren bruker `mineSynligeMiljoer` (`FjernRolleAction.tsx:106-107`). Grensesnittet kan tilby en fjerning serveren avviser |
| `@BRU-PER-GRU-012` | Fjerning er begrenset til organisasjoner jeg administrerer | usikker | P: funnet · A: delvis — samme som raden over (`P-db/0057-tildelinger-splittes-etter-subjekttype.sql:436-441`) |
| `@BRU-PER-GRU-012` | Tilganger som kom fra rollen faller bort | funnet | P: funnet · A: ikke relevant — `P-db/0044-kilde-roller-for-tildelingsvisning.sql:32-112` (arvede rader avledes bare fra aktive direkte rader), `P-svc/FeideBrukerTilgangService.java:107-115` |
| `@BRU-PER-GRU-012` | Tilgang som også er tildelt direkte består | funnet | P: funnet · A: ikke relevant — `P-db/0087-tildeling-til-personsubjekt.sql:189-194` (bare rollens rad), `P-db/0044-kilde-roller-for-tildelingsvisning.sql:79-98` |
| `@BRU-PER-GRU-007` | Se navn | funnet | P: funnet · A: funnet — `P-schema/schema_brukeradmin.graphqls:227`, `P-svc/FeideBrukerConditions.java:24`; `A-ts/PersonbrukerDetails/components/PersonbrukerDetaljer/PersonbrukerDetaljer.tsx:76-77` |
| `@BRU-PER-GRU-007` | Se Feide-ID | funnet | P: funnet · A: funnet — `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/stable/applikasjoner.graphqls:148`; `PersonbrukerDetaljer.tsx:105`, `A-msg/domains.json:112` |
| `@BRU-PER-GRU-007` | Se hjemorganisasjon | funnet | P: funnet · A: funnet — `P-schema/schema_brukeradmin.graphqls:249` → `P-db/0073-feidebruker-hjemmeorganisasjon.sql:63-67`; `PersonbrukerDetaljer.tsx:63-66,111-115` |
| `@BRU-PER-GRU-007` | Hjemorganisasjonen er ukjent | funnet | P: funnet · A: funnet — `P-db/0073-feidebruker-hjemmeorganisasjon.sql:63-67` (uregistrert domene gir null); `PersonbrukerDetaljer.tsx:64-66,113` viser «-» (`A-msg/domains.json:118`), og bruker ikke tildelingsorganisasjonene |
| `@BRU-PER-GRU-007` | Se status | funnet | P: funnet · A: funnet — `P-schema/schema_brukeradmin.graphqls:239`, `P-db/0033-deaktivering-feide-bruker.sql:74`; `PersonbrukerDetaljer.tsx:84-87,93-101` |
| `@BRU-PER-GRU-001` | Se liste over personbrukere | funnet | P: funnet · A: funnet — `A-ts/PersonbrukereOverview/components/PersonbrukereResultList/PersonbrukereResultList.tsx:124-166` (Navn, Feide-ID, Hjemorganisasjon, Status), `A-ts/PersonbrukereOverview/hooks/useGetPersonbrukereState.tsx:45-47` (navn stigende); `P-schema/schema_brukeradmin.graphqls:158,173,185,195` |
| `@BRU-PER-GRU-001` | Liste viser de 50 første personbrukerne | funnet | P: funnet · A: funnet — `useGetPersonbrukereState.tsx:48` (`initFirst: 50`), `PersonbrukereResultList.tsx:98-99`; `P-schema/schema_brukeradmin.graphqls:85-88` (totalCount) |
| `@BRU-PER-GRU-001` | Laste inn 50 flere personbrukere | funnet | P: funnet · A: funnet — `PersonbrukereResultList.tsx:87-89`, `fs-admin/src/common/hooks/useDataListState/useDataListState.tsx:108` |
| `@BRU-PER-GRU-001` | Alle personbrukere er lastet inn | funnet | P: funnet · A: funnet — `fs-admin/src/common/components/lists/components/ListBody/ListBody.tsx:87-95` (`hasNextPage`) |
| `@BRU-PER-GRU-001` | Navigere til detaljside for personbruker | funnet | P: ikke relevant · A: funnet — `PersonbrukereResultList.tsx:107-115`, `fs-admin/src/app/tilgangsstyring/personbrukere/[id]/page.tsx` |
| `@BRU-PER-GRU-001` | Fritekst-søk på navn | funnet | P: funnet · A: funnet — `A-ts/PersonbrukereOverview/hooks/useGetPersonbrukere.tsx:97`; `P-svc/FeideBrukereFilterConditions.java:84-98` |
| `@BRU-PER-GRU-001` | Fritekst-søk på Feide-ID | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:98`; `P-svc/FeideBrukereFilterConditions.java:67-71` |
| `@BRU-PER-GRU-001` | Tilgjengelige statuser i filter | funnet | P: ikke relevant · A: funnet — `A-ts/PersonbrukereOverview/components/filter/PersonbrukereStatusFilter/PersonbrukereStatusFilter.tsx:40-43,69`, `A-msg/domains.json:67` |
| `@BRU-PER-GRU-001` | Filtrere på status | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:101-104`; `P-schema/schema_brukeradmin.graphqls:161` |
| `@BRU-PER-GRU-001` | Tilgjengelige hjemorganisasjoner i filter | usikker | P: delvis · A: funnet — `A-ts/PersonbrukereOverview/hooks/useGetMineBrukeresHjemmeorganisasjoner.tsx:51-58`, `A-msg/domains.json:63`; `P-db/0081-mine-brukeres-hjemmeorganisasjoner.sql:22-27` (DISTINCT). Kilden følger bare RLS, mens listen sender `skjulInaktiveFraAndreOrganisasjoner: true` (`useGetPersonbrukere.tsx:108`), så filteret kan vise en hjemorganisasjon som ikke finnes i listen |
| `@BRU-PER-GRU-001` | Filtrere på hjemorganisasjon | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:99`; `P-svc/FeideBrukereFilterConditions.java:131-147` |
| `@BRU-PER-GRU-001` | Tilgjengelige roller i filter | usikker | P: delvis · A: funnet — `A-ts/PersonbrukereOverview/hooks/useGetMineSynligeBrukerroller.tsx:42-44`, `A-msg/domains.json:65`; `P-svc/FeideBrukereFilterConditions.java:242-246` → viewet `feide_bruker_tildelingsrolle` (`P-db/0087-tildeling-til-personsubjekt.sql:224-233`) tar med tildelinger til personsubjekter og tilganger, så filteret kan vise koder ingen personbruker i listen har som rolle |
| `@BRU-PER-GRU-001` | Filtrere på rolle | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:100`; `P-svc/FeideBrukereFilterConditions.java:157-168` |
| `@BRU-PER-GRU-001` | Kombinere søk og filtre | funnet | P: funnet · A: funnet — `useGetPersonbrukere.tsx:94-109` (ett filterobjekt, OG); test `FeideBrukereQueryTest.java:539` |
| `@BRU-PER-GRU-001` | Brukeradministrator ser personbrukere med hjemorganisasjon i organisasjonene jeg administrerer | funnet | P: funnet · A: funnet — `P-db/0093-personbruker-oversikt.sql:146-165`, `P-db/0076-miljostyrt-tildelingsgren-feidebruker.sql:26-29`, `P-svc/FeideBrukereFilterConditions.java:217`; test `FeideBrukereQueryTest.java:769` |
| `@BRU-PER-GRU-001` | Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer | funnet | P: funnet · A: funnet — `P-svc/FeideBrukereFilterConditions.java:218-220` (aktiv tildeling i paret miljø og organisasjon); hjemorganisasjonen er brukerens egen (`PersonbrukereResultList.tsx:136-153`). Funnet fordi koden gir synlighet for enhver aktiv tildeling, også tilganger |
| `@BRU-PER-GRU-001` | Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer | ikke funnet | P: delvis · A: funnet — bare brukere uten noen aktiv tildeling skjules (`P-svc/FeideBrukereFilterConditions.java:209-224`). `harAktivTildeling` (`:257-272`) og RLS-grenen (`P-db/0076-miljostyrt-tildelingsgren-feidebruker.sql:50-59`) ser ikke på `rolle.rolletype` (`P-db/0034-rolletype-og-tildelingsvisning.sql:48-57`), så en personbruker med bare en aktiv tilgang er synlig — søkt etter «rolletype» i tilgangsstyring-service og changelog 0076–0095 |
| `@BRU-PER-GRU-001` | Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer | funnet | P: funnet · A: funnet — `P-svc/FeideBrukereFilterConditions.java:218-220` (`row(MILJOKODE, ORGANISASJONSKODE).in(...)`), `P-db/0076-miljostyrt-tildelingsgren-feidebruker.sql:54-58` |
| `@BRU-PER-GRU-010` | Ny rolle i namespacet knyttes til fs-admin | usikker | P: delvis · A: ikke relevant — rollen har `navneromskode` (`P-db/0051-navnerom-pa-rolle.sql:37`), men kommer bare inn med migrering (`P-db/0058-forretnings-og-ui-roller-brukeradmin.sql:67`) eller manuelt (`opprettTilgangsroller`, `P-schema/schema_rollekatalog_forvaltning.graphqls:281`). Kilden («namespacet») er ikke funnet, og kan ligge i et repo som ikke er sjekket |
| `@BRU-PER-GRU-010` | Rolle i et annet namespace knyttes ikke til fs-admin | usikker | P: delvis · A: ikke relevant — én `navneromskode` per rolle (`P-db/0051-navnerom-pa-rolle.sql:37-47`), men ingen synk som skiller på namespace |
| `@BRU-PER-GRU-010` | Endret rolle i namespacet oppdateres i rolletabellen | usikker | P: delvis · A: ikke relevant — `oppdaterTilgangsroller` er manuell (`P-schema/schema_rollekatalog_forvaltning.graphqls:305`), ingen synk utløser den |
| `@BRU-PER-GRU-010` | Synkronisering skjer uten at en administrator gjør noe | usikker | P: mangler · A: ikke relevant — ingen jobb, scheduler, Kafka-konsument eller webhook — søkt etter «synkroniser», «sync», «namespace», «navnerom», «@Scheduled», «KafkaListener», «cron», «webhook», «keycloak» i fs-plattform. `fs-plattform/tilgangsstyring/docs/navnerom-for-roller.md:211-213`: «fortsatt bare migrasjonsrollen som endrer katalogen» |
| `@BRU-PER-GRU-010` | Synkronisering forutsetter ikke en ny utrulling av fs-admin | usikker | P: mangler · A: ikke relevant — rollene kommer via Liquibase-migreringer, og fs-admin genererer rollekonstantene manuelt (`fs-admin/scripts/generate-tilgangsroller/CLAUDE.md`) |
| `@BRU-PER-GRU-010` | Rolle fjernet fra namespacet markeres som utgått | ikke funnet | P: mangler · A: ikke relevant — ingen utgått-kolonne på `rolle` (`P-db/0003-create-tilgangsstyring-tables.sql:35-44`, `0034:48`, `0051:38`); bare «slettes aldri» (`docs/navnerom-for-roller.md:181`) — søkt etter «utgått», «utgatt», «utfas», «avvikl», «deprecated», «obsolete», «retired», «er_aktiv» |
| `@BRU-PER-GRU-010` | Utgått rolle kan ikke tildeles på nytt | ikke funnet | P: mangler · A: delvis — `tildelbare_tilgangskoder` har ikke noe utgått-filter (`P-db/0057-tildelinger-splittes-etter-subjekttype.sql:405`); `A-roller/components/PersonbrukerRollerActions/actions/TildelRolleAction/TildelRolleAction.tsx:193-196` filtrerer bare på rolletype |
| `@BRU-PER-GRU-010` | Eksisterende tildelinger av en utgått rolle består | ikke funnet | P: mangler · A: ikke relevant — utgått finnes ikke |
| `@BRU-PER-GRU-010` | Rolle som kommer tilbake i namespacet er ikke lenger utgått | ikke funnet | P: mangler · A: ikke relevant — verken utgått eller synk finnes |
| `@BRU-PER-GRU-010` | Synkroniserte endringer er sporbare i historikk | ikke funnet | P: mangler · A: ikke relevant — `rolle` har bare `opprettet_*`/`endret_*` (`P-db/0003-create-tilgangsstyring-tables.sql:36-41`); flyttehistorikken er fjernet (`P-db/0051-navnerom-pa-rolle.sql:26-30`) — søkt etter «rolle_historikk», «rolle_logg», «historikk» i alle `*.graphqls` |
| `@BRU-PER-GRU-010` | Synkronisering som ikke lykkes endrer ikke rolletabellen | usikker | P: mangler · A: ikke relevant — ingen synk i klonene; kan ligge i et repo som ikke er sjekket |
| `@BRU-PER-GRU-003` | Tildele en rolle for valgt organisasjon og miljø | funnet | P: funnet · A: funnet — `P-svc/FeideBrukerTilgangService.java:62-87` → `tildel_brukertilgang` (`P-db/0087-tildeling-til-personsubjekt.sql:85-131`); `TildelRolleAction.tsx:303-308,351-381`, `A-roller/hooks/useTildelFeideBrukerTilganger.tsx:155-174` |
| `@BRU-PER-GRU-003` | Organisasjon er implisitt når administrator administrerer kun én organisasjon | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:121-128,356` forhåndsvelger og låser; `P-db/0057-tildelinger-splittes-etter-subjekttype.sql:433-442` |
| `@BRU-PER-GRU-003` | Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer | usikker | P: delvis · A: funnet — `mine_tildelingsorganisasjoner` er unionen av retten til å tildele til applikasjoner og til personbrukere, et bevisst «UI-hint» (`P-db/0057-tildelinger-splittes-etter-subjekttype.sql:402-404,433-448`); tildelingen avvises på serveren (`P-db/0087-tildeling-til-personsubjekt.sql:109-111`). `TildelRolleAction.tsx:108,178-182` |
| `@BRU-PER-GRU-003` | Tildele en rolle til en personbruker | funnet | P: funnet · A: funnet — `P-db/0087-tildeling-til-personsubjekt.sql:126-128`, `P-db/0003-create-tilgangsstyring-tables.sql:410` (aktiv fra tildelingen), `P-schema/schema_brukeradmin.graphqls:430-433` (tildeltAv, tildeltTidspunkt); `TildelRolleAction.tsx:303-336`, `A-roller/components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx:218-227` |
| `@BRU-PER-GRU-003` | Tildele flere roller samtidig | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:372-381` (flervalg), `useTildelFeideBrukerTilganger.tsx:155-174`; `P-svc/FeideBrukerTilgangService.java:67-81` |
| `@BRU-PER-GRU-003` | Delvis suksess ved samtidig tildeling av roller | funnet | P: funnet · A: funnet — ett rotfelt per rolle, hver i egen transaksjon (`useTildelFeideBrukerTilganger.tsx:36-42,188-207`, `P-svc/FeideBrukerTilgangService.java:64`); `TildelRolleAction.tsx:260-272,337-340,399-457` viser tildelte og avviste med årsak |
| `@BRU-PER-GRU-003` | Valglisten for rolle avhenger av valgt organisasjon og miljø | usikker | P: delvis · A: funnet — `tildelbare_tilgangskoder(org, miljø)` gir hele katalogen når kalleren har en av de to tildelingsrettene (`P-db/0057-tildelinger-splittes-etter-subjekttype.sql:405-424`, `P-svc/ApplikasjonTilgangService.java:180-198`), ikke filtrert på hva administratoren selv har; `TildelRolleAction.tsx:130-138,243-250` |
| `@BRU-PER-GRU-003` | Allerede tildelt rolle vises som ikke-valgbar | funnet | P: funnet · A: funnet — `TildelRolleAction.tsx:207-236` (direkte tildelte er `disabled`, «allerede tildelt», `A-msg/domains.json:170`); `P-db/0087-tildeling-til-personsubjekt.sql:115-124` |
| `@BRU-PER-GRU-008` | Se brukerens roller med «Gjelder for» | ikke funnet | P: funnet · A: mangler — `P-schema/schema_brukeradmin.graphqls:426-427` (`organisasjon`, «Organisasjonen tildelingen gjelder for»). Roller-fanen har kolonnen «Organisasjon» (`A-roller/components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx:202`, `A-msg/domains.json:143`) — søkt etter «gjelder for», «gjelderFor», «gjelder_for», «headerGjelder» i fs-admin `src/` |
| `@BRU-PER-GRU-008` | Filtrere på navn | funnet | P: funnet · A: funnet — `A-roller/components/PersonbrukerRollerFilter/filter/PersonbrukerRollerTilgangskodeFilter/PersonbrukerRollerTilgangskodeFilter.tsx:50-53`, `A-roller/hooks/useGetPersonbrukerRoller.tsx:134`; `P-svc/FeideBrukerTilgangerFilterConditions.java:34-38` |
| `@BRU-PER-GRU-008` | Tilgjengelige organisasjoner i filter | usikker | P: delvis · A: delvis — DISTINCT (`P-db/0023-synlighet-og-rettigheter.sql:211-214`), sortert (`A-roller/hooks/useGetPersonbrukerTilgangerFilterOptions.tsx:76-86`), «Alle organisasjoner» som standard. Valgene kommer fra `tildelingerOrganisasjoner` (`P-schema/schema_brukeradmin.graphqls:256`), som ikke skiller på rolletype, så Roller-fanen får også organisasjoner der brukeren bare har tilganger |
| `@BRU-PER-GRU-008` | Filtrere på organisasjon | funnet | P: funnet · A: funnet — `useGetPersonbrukerRoller.tsx:136`; `P-schema/schema_brukeradmin.graphqls:470-471` |
| `@BRU-PER-GRU-008` | Tilgjengelige miljøer i filter | usikker | P: delvis · A: delvis — DISTINCT (`P-db/0023-synlighet-og-rettigheter.sql:202-205`), sortert (`useGetPersonbrukerTilgangerFilterOptions.tsx:71-74`), «Alle miljøer» som standard. Samme avvik: `tildelingerMiljoer` (`P-schema/schema_brukeradmin.graphqls:261`) skiller ikke på rolletype |
| `@BRU-PER-GRU-008` | Filtrere på miljø | funnet | P: funnet · A: funnet — `useGetPersonbrukerRoller.tsx:135`; `P-schema/schema_brukeradmin.graphqls:472-473` |
| `@BRU-PER-GRU-008` | Kombinere filtre | funnet | P: funnet · A: funnet — `useGetPersonbrukerRoller.tsx:131-140` (ett filterobjekt); `P-schema/schema_brukeradmin.graphqls:463-477` |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@BRU-PER-GRU-001` | Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer | usikker | ikke funnet | `P-svc/FeideBrukereFilterConditions.java:257-272` og `P-db/0076-miljostyrt-tildelingsgren-feidebruker.sql:54-58` ser ikke på rolletype, og `P-db/0034-rolletype-og-tildelingsvisning.sql:51-57` sier at ingen tilgangsberegning leser kolonnen. Commit 2249384 i kravrepoet sier at koden må endres |

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Aktivere og deaktivere en personbrukers samlede tilganger | `aktivere_og_deaktivere_bruker.feature` | `@in-progress` | 2/3 |
| `@BRU-PER-GRU-001` | Scenario: Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer | `søke_opp_bruker.feature` | `@planned` | 1/1 |
| `@BRU-PER-GRU-001` | Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer | `søke_opp_bruker.feature` | `@planned` | 1/1 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@BRU-PER-GRU-004` | Scenario: Reaktivere en deaktivert personbruker | `@planned` | 0/1 | 1 ikke funnet. Brukeren svarte «Reaktivering mangler historikk, den kan du sette til planned» |
| `@BRU-PER-GRU-001` | Scenario: Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer | `@planned` | 0/1 | 1 ikke funnet |
| `@BRU-PER-GRU-010` | Automatisk synkronisering av roller fra namespacet "frontend/fs-admin" | `@draft` | 0/11 | 5 ikke funnet, 6 usikker. Brukeren svarte «Det er korrekt, sett det til draft» |
| `@BRU-PER-GRU-003` | Tildele roller til en personbruker | `@planned` | 6/8 | 0 ikke funnet, 2 usikker |
| `@BRU-PER-GRU-008` | Scenario: Se brukerens roller med «Gjelder for» | `@planned` | 0/1 | 1 ikke funnet |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

- **`@BRU-PER-GRU-001` — Scenario: Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner** (`søke_opp_bruker.feature`)
  - `P-svc/FeideBrukereFilterConditions.java:218-220,257-272` — en aktiv tilgang (rolletype TILGANG) i paret gir synlighet
  - `P-db/0076-miljostyrt-tildelingsgren-feidebruker.sql:50-59` — det samme i RLS-grenen
- **`@BRU-PER-GRU-001` — Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige** (`søke_opp_bruker.feature`)
  - `P-db/0093-personbruker-oversikt.sql:146-165` — policyen `feide_bruker_les`. Oppførselen er en delmengde av «… uten aktiv rolle …», så koden blir ikke borte når rolleskillet bygges
- **`@BRU-PER-GRU-001` — Scenario: Personbrukere med kun inaktiv datatilgang fra egne organisasjoner er ikke synlige** (`søke_opp_bruker.feature`)
  - `P-svc/FeideBrukereFilterConditions.java:266-270`, `A-ts/PersonbrukereOverview/hooks/useGetPersonbrukere.tsx:105-108` — aktivitetskravet, som teller tilganger og roller likt
- **`@BRU-PER-GRU-001` — Scenario: Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige** (`søke_opp_bruker.feature`)
  - `P-db/0076-miljostyrt-tildelingsgren-feidebruker.sql:54-58`, `P-svc/FeideBrukereFilterConditions.java:219-220` — parsjekken på miljø og organisasjon, som teller tilganger og roller likt
- **`@BRU-PER-GRU-008` — Scenario: Se brukerens roller** (`vise_roller.feature`)
  - `A-roller/components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx:189-229`, `A-msg/domains.json:139-145` — Roller-fanen viser den gamle feltlista, med «Organisasjon» i stedet for «Gjelder for»

## Oppfølging

- **Statusendringer etter beslutning fra brukeren:** `@BRU-PER-GRU-004` ble `@implemented` med `@planned` på scenarioet «Reaktivere en deaktivert personbruker» i stedet for en ny blokk ved siden av den leverte (*Endring av levert krav*), og `@BRU-PER-GRU-010` ble satt fra `@planned` til `@draft`. Begge ligger utenfor statusaksen `fs-verify` eier, og er gjort fordi brukeren ba om det.
- **Rolleskillet i synligheten er ikke bygget:** de to scenarioene i `@BRU-PER-GRU-001` som er levert, er funnet fordi koden gir synlighet for enhver aktiv tildeling (`P-svc/FeideBrukereFilterConditions.java:257-272`). Når «uten aktiv rolle» bygges (et rolletype-ledd i tildelingsgrenen og i RLS-grenen, `P-db/0076-miljostyrt-tildelingsgren-feidebruker.sql:50-59`), må de to leverte scenarioene sjekkes på nytt, og de fire `@deprecated`-scenarioene kan vurderes for sletting. Tre av dem (nr. 2–4) beskriver oppførsel som er en delmengde av de nye scenarioene, så de blir aldri «ingen spor funnet» ved å lete etter kode som er fjernet.
- **Sortering i personbrukerlisten:** API-et støtter sortering på navn i begge retninger (`P-schema/schema_brukeradmin.graphqls:150-159`), men sorteringskontrollen er fjernet i fs-admin (`A-ts/PersonbrukereOverview/components/PersonbrukereResultList/PersonbrukereResultList.tsx:67-70`). Det åpne spørsmålet ved «Velge sorteringsretning for navn» (`@draft`) er utdatert for API-siden.
- **Personsubjekt-API-et brukes ikke av fs-admin:** fs-plattform har `tildelPersonbrukerTilganger` med retten `BRUKERADMIN_PERSON_TILDELING_SKRIV` (`P-schema/schema_personbruker.graphqls:182-224`, `P-db/0087-tildeling-til-personsubjekt.sql:57-79`), men fs-admin bruker `tildelFeideBrukerTilganger` mot FeideBruker, og `mine_tildelingsorganisasjoner` og `tildelbare_tilgangskoder` tar ikke med person-retten. En administrator med bare person-retten får tomme valglister.
- **Tilganger-fanen er slått av:** `A-ts/PersonbrukerDetails/PersonbrukerDetails.tsx:126-134`. Bare Roller-fanen er montert.
- **Feltene står i experimental-kontrakten:** `navn`, `status` og `hjemmeorganisasjon` på FeideBruker står i `P-schema/` (tagges etter mappa, `fs-plattform/tilgangsstyring/tilgangsstyring-app/pom.xml:256`). Om de er eksponert i produksjonskontrakten, er ikke vurdert.
- **Åpne spørsmål uten tag:** `aktivere_og_deaktivere_bruker.feature` og `tildele_roller.feature` har en `# ÅPNE SPØRSMÅL:`-blokk nederst i fila uten `@openquestion`. Spørsmål 2 i `tildele_roller.feature` (hva rettigheten består i) avgjør de to usikre radene for `@BRU-PER-GRU-003`.
- **Ikke sjekket:** kilden til «namespacet frontend/fs-admin» for `@BRU-PER-GRU-010` (Keycloak eller annet rolleverktøy) er ikke blant kodeklonene.
- **Krav utenfor scope:** `fjerne_tilganger.feature` (`@draft`), `sette_stedkoder_for_tilgang.feature` (`@draft`), `sette_tidsbegrensning_for_tilgang.feature` (`@draft`), `tildele_tilganger.feature` (`@draft`), `vise_tilganger.feature` (`@draft`) — henvis til `fs-krav`.
