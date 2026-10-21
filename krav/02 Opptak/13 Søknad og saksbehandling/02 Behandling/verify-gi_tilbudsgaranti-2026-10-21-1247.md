# Verifisering: gi_tilbudsgaranti.feature

- **Dato:** 2026-10-21 12:47
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 4f5b152cea, oppdatert), `fs-admin` (main, a05c9f696d, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei (chrome-devtools finnes ikke i økta)

Gating-sett: alle scenarioene i scope, også `@draft`, `@planned` og `@openquestion`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `STS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SettTilbudsgarantitypeService.java`
- `BTS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingService.java`
- `EAC` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/ErAktivConditions.java`
- `SKS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `TIO` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/tidligopptak.graphqls`
- `SAK` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/sak.graphqls`
- `V346` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V346__kolonnevern_tilbudsgaranti.sql`
- `V351` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V351__endringslogg_ident_og_soknadsniva.sql`
- `TGS` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx`
- `ALI` = `fs-admin/src/domains/soknadsbehandling/features/AuditLogCard/AuditLogItem/AuditLogItem.tsx`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-010` | Gi tilbudsgaranti | 13/17 | fs-plattform, fs-admin | Endringsloggen sier ikke hvilket søknadsalternativ endringen i tilbudsgarantien gjelder. Tilbudsgarantien fra saksbehandler følger ikke med når søknadsalternativet flyttes (STEK-626). |

Gjenstår: fs-plattform, fs-admin 1, ingen 0.

## Oppsummering

- Scenarioer: 13 funnet, 4 ikke funnet, 0 usikker, av 17
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-010` | Sette tilbudsgaranti i feltet for rollen | funnet | P: funnet · A: funnet — `TIO:162-187`, `STS:23-35`, `STS:111-115`, `TGS:305-337` — én mutasjon og én kolonne per rolle, og tre felt i saken. Alle tre eksemplene |
| `@OPT-BEH-BEH-010` | Bare tilbudsgarantitypene for rollen kan velges | funnet | P: funnet · A: funnet — `STS:76-86` avviser en type når `kan_brukes_av_<rolle>` ikke er satt, `TGS:275-298` viser bare typene for rollen |
| `@OPT-BEH-BEH-010` | Saksbehandler ser ikke muligheten til å sette tilbudsgaranti som tilbyder eller opptaksforvalter | funnet | P: funnet · A: funnet — `TGS:235-242`, `TGS:316-337` viser feltene for tilbyder og opptaksforvalter skrivebeskyttet, uten valg, `V346:152-169` stopper endringen i backend |
| `@OPT-BEH-BEH-010` | Se tilbudsgarantiene fra alle rollene | funnet | P: funnet · A: funnet — `SAK:743-748`, `TGS:43-63`, `TGS:305-337`, etikettene «Tilbudsgaranti fra behandler/tilbyder/forvalter» i `fs-admin/src/common/messages/nb/soknadsbehandling.json:756-758` |
| `@OPT-BEH-BEH-010` | Sette tilbudsgaranti når søknaden ikke kan poengberegnes | funnet | P: funnet · A: ikke relevant — `STS:69-120`, `V346:91-108` sjekker ikke poengberegningen |
| `@OPT-BEH-BEH-010` | Endre tilbudsgaranti | funnet | P: funnet · A: funnet — `STS:111-115` skriver over kolonnen, `TGS:161-172`, `TGS:311-313` lagrer ved endring |
| `@OPT-BEH-BEH-010` | Fjerne tilbudsgaranti | funnet | P: funnet · A: funnet — `TIO:163` («Null fjerner verdien»), `STS:75-76`, `STS:111-112`, `TGS:167`, `TGS:280` |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien fra en annen rolle blir stående | funnet | P: funnet · A: ikke relevant — `STS:111-113` oppdaterer bare kolonnen for rollen |
| `@OPT-BEH-BEH-010` | Opptaksforvalter ser ikke muligheten til å endre tilbudsgarantien fra saksbehandler | funnet | P: funnet · A: funnet — `TGS:231-234`, `TGS:305-308` krever `MODIFISERE_SØKNADSBEHANDLING` for den saksbehandlende organisasjonen, `V346:137-150` |
| `@OPT-BEH-BEH-010` | Bare tilbudsgarantitypene i opptaket kan velges | funnet | P: funnet · A: funnet — `TGS:65-78`, `TGS:244-250` henter typene for opptaket, `TIO:16-17`, `STS:77-81` sjekker opptaket |
| `@OPT-BEH-BEH-010` | Se hvem som har satt tilbudsgarantien | ikke funnet | P: delvis · A: delvis — `STS:103-109`, `STS:134` og `ALI:59-80` viser «Behandler satte tilbudsgarantien [type]» med bruker og tidspunkt, men ikke hvilket søknadsalternativ. En sak kan ha flere søknadsalternativer (`SAK:127`), og `EndringPaSak` (`SAK:179-190`) og viewet `endringslogg_for_sak` (`V351:167-178`) har ikke `utdanningstilbudsnr` — søkt etter «endringslogg_for_sak», «row_data», «EndringPaSak», «endringsloggV2» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-010` | Se hvem som har fjernet tilbudsgarantien | ikke funnet | P: delvis · A: delvis — `STS:124-126`, `ALI:59-69` viser «Behandler fjernet tilbudsgarantien» med bruker og tidspunkt, men ikke hvilket søknadsalternativ — søkt som over |
| `@OPT-BEH-BEH-010` | Se hvilken tilbudsgarantitype som ble satt | ikke funnet | P: delvis · A: delvis — `STS:127-134`, `ALI:80` viser typen og rollen, men ikke hvilket søknadsalternativ — søkt som over |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet når prioriteten endres | funnet | P: funnet · A: ikke relevant — `SKS:1274-1308` upserter søknadsalternativet og endrer bare prioriteten, `sak_soknadsalternativ` røres ikke, `BTS:407-414`. Alle tre eksemplene |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon | ikke funnet | P: delvis · A: ikke relevant — `BTS:461-481` kopierer tilbudsgarantien fra tilbyder og opptaksforvalter, men ikke fra saksbehandler (STEK-626) — søkt etter «TILBUDSGARANTITYPE_KODE_FRA_BEHANDLER», «flyttBehandlere», «insertInto(SAK_SOKNADSALTERNATIV» i fs-plattform |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien faller bort når søknadsalternativet fjernes | funnet | P: funnet · A: ikke relevant — `SKS:1279-1285` (fjerne), `SKS:611-617` (trekke), `EAC:31-45` skjuler søknadsalternativet i saken |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen | funnet | P: funnet · A: ikke relevant — `SKS:1288-1306` setter `slettet` til null, og raden i `sak_soknadsalternativ` er urørt, `EAC:37-45`. Begge eksemplene |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-010` | Se hvem som har satt tilbudsgarantien | usikker | ikke funnet | `SAK:179-190`, `V351:167-178` — søknadsalternativet står ikke i loggraden, og kan ikke nås gjennom API-et |
| `@OPT-BEH-BEH-010` | Se hvem som har fjernet tilbudsgarantien | usikker | ikke funnet | Samme som over |
| `@OPT-BEH-BEH-010` | Se hvilken tilbudsgarantitype som ble satt | usikker | ikke funnet | Samme som over |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-010` | Gi tilbudsgaranti | `@planned` | 13/17 | 4 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Inaktiv tilbudsgaranti-type:** `STS:76-86` sjekker ikke `er_aktiv`, og `TGS:275-298` filtrerer valgene på rollen, ikke på `erAktiv`. En type som alt er lagret, blir stående som valg (`TGS:282`). Kravet sier ingenting om aktive typer.
- **Kravet er ikke hentet inn i en oppgave:** `@OPT-BEH-BEH-010` er `@planned`, og ble verifisert uansett status. Kravet ble verifisert på branchen `krav/tilbudsgaranti-sporing` (PR #772, ikke merget). `fs-specify` henter det inn i en oppgave.
- **Ikke sjekket:** min-kompetanse finnes ikke blant kodeklonene. Ingen av scenarioene gjelder det søkeren ser.
