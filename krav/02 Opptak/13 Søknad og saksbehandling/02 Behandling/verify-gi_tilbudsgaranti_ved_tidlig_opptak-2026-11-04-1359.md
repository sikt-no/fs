# Verifisering: gi_tilbudsgaranti_ved_tidlig_opptak.feature (STEK-489 merget)

- **Dato:** 2026-11-04 13:59
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature` (1 feature-fil, med endringene i #906)
- **Kode:** `fs-plattform` (origin/main, 3a3ef0403e, lest med git; arbeidstreet er 108 bak origin og ble ikke brukt), `fs-admin` (origin/main, 29b2c1708, lest med git; arbeidstreet står på den slettede branchen for STEK-489. Kontrollen leste 2f2ddf24e, som bare har én endret linje i `soknadsbehandling.json` i tillegg)
- **Åpne MR-er:** 7 MR-er i fs-admin, 2 i fs-plattform (0 med kode for kravene)
- **Omfang:** `@in-progress` (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `P/svc` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`
- `P/schema` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/tidligopptak-tilbudsgaranti-automatikk.graphqls`
- `P/manuell` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SettTilbudsgarantitypeService.java`
- `P/algo` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/plasstildeling/algoritme/Opptakskjoringsalgoritme.java`
- `A/TO` = `fs-admin/src/domains/plasstildeling/features/TidligOpptak`
- `A/knapp` = `A/TO/components/KjorTidligopptakButton/KjorTidligopptakButton.tsx`
- `A/modal` = `A/TO/components/TidligOpptakResultModal/TidligOpptakResultModal.tsx`
- `A/liste` = `A/TO/components/TidligOpptakUtdanningstilbudList/TidligOpptakUtdanningstilbudList.tsx`
- `A/msg` = `fs-admin/src/common/messages/nb/plasstildeling.json`
- `A/tgselect` = `fs-admin/src/domains/soknadsbehandling/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx`

## Oppsummering

- Scenarioer: 20 funnet, 7 ikke funnet, 2 usikker, av 29
- Forslag: 0 kan leveres, 1 delvis levert, 0 kan slettes, 2 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: 5 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 6 (1 ikke beskrevet)
- Regler i koden uten scenario: 18
- Åpne spørsmål: 0 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 20 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

*Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-BEH-BEH-007` — Gi tilbudsgaranti ved tidlig opptak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`, 20/29 funnet): `@implemented` på Regel: Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket (linje 434), og på Scenario: Tilbudsgaranti ut fra poenggrensen (linje 168), Søkere som ikke deltar får ikke tilbudsgaranti (182), Søknader uten konklusjon er ikke med i tidligopptaket (190), Søkere som ikke er kvalifisert får ikke tilbudsgaranti (197), Tilbudsgaranti på det høyest prioriterte søknadsalternativet (213), Bare ferdig behandlede saker er med i tidligopptaket (229), Reservert studieplass gir tilbudsgaranti uten poenggrense (239), Reservert studieplass gir tilbudsgaranti uten kvalifisering (248), Den høyeste poengsummen til søknadsalternativet gjelder (261), Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet (272), Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet (281), Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket (291), Tidligopptakstilbud fra tilbyder går foran poengsummen (304), En ny gjennomføring fjerner ikke tilbudsgarantien (331), Ny gjennomføring tar med en sak som er blitt ferdig behandlet (339), Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring (349), Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak (358), Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon (375), Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak (421). Linjene er i kravfila med taggene, på toppen av #906

**Kan leveres når det er avklart**

- `@OPT-BEH-BEH-007` — Scenario: Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum (`krav/…/gi_tilbudsgaranti_ved_tidlig_opptak.feature:314`): kan få `@implemented` hvis visningen i saken dekker «opptaksforvalter ser at søkeren har tidligopptakstilbud» — `usikker`: `P/svc:627-631` beholder tilbudet før status og konklusjon sjekkes; forvalteren ser FOP og FOR per søknadsalternativ i saken, `A/tgselect:43-62, 266-267, 322-327`, men ikke i tidligopptaket
- `@OPT-BEH-BEH-007` — Scenario: Prøvekjøre tidligopptaket (`krav/…/gi_tilbudsgaranti_ved_tidlig_opptak.feature:322`): kan få `@implemented` hvis totaltallet i prøvekjøringen dekker «ser at søkeren ville fått tilbudsgaranti på "Sykepleie, høst 2027"» — `usikker`: `P/svc:108-115, 147-149` ruller tilbake; `A/modal:103-122` viser bare «Totale tilbudsgarantier» og antall på første prioritet

**Blir stående**

- `@OPT-BEH-BEH-007` — Gi tilbudsgaranti ved tidlig opptak (`@in-progress`, 20/29 funnet): 7 ikke funnet og 2 usikker. Rapporten over utfallet mangler i fs-admin: utfallet per søknadsalternativ, mangelfulle innstillinger og kvotevarselet vises ikke, og grensen for kvotevarsel kan ikke angis. Gjenstår i fs-admin

## Oppfølging

- **Usikker:** `@OPT-BEH-BEH-007` «Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum» (`krav/…:314`) — `P/svc:627-631` dekker regelen. Kontrollen: forvalteren ser tilbudet i saken (`A/tgselect:43-62, 266-267, 322-327`), men ikke i tidligopptaket. Om det dekker «opptaksforvalter ser», må avklares
- **Usikker:** `@OPT-BEH-BEH-007` «Prøvekjøre tidligopptaket» (`krav/…:322`) — `P/svc:108-115, 147-149`; `A/knapp:96-104`. Kontrollen: `A/modal:103-122` viser ikke hvilken søker eller hvilket utdanningstilbud som ville fått tilbudsgaranti
- **Ikke funnet:** `@OPT-BEH-BEH-007` «Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti» (`krav/…:204`) — ingen garanti (`P/svc:698-724`), men «opptaksforvalter ser at kvalifiseringen ikke er vurdert» mangler: fs-admin henter verken `detaljer` eller `perUtfall` (`A/modal:28-38`). Søkt etter «KVALIFISERING_IKKE_VURDERT», «perUtfall», «detaljer», «tidligopptakStatus», «tidligopptakResultat», «utfall» i fs-admin
- **Ikke funnet:** `@OPT-BEH-BEH-007` «Se utfallet for hver søker» (`krav/…:365`) — API-et har det (`P/svc:1091-1116, 1210-1238`; `P/schema:113-152`), fs-admin viser bare fem totaltall (`A/modal:28-38, 69-122`)
- **Ikke funnet:** `@OPT-BEH-BEH-007` «Se utdanningstilbud med mangelfulle innstillinger» (`krav/…:381`) — MANGLER_POENGGRENSE i `P/svc:378-385`; fs-admin viser bare antall avvik i en snackbar etter en ekte gjennomføring (`A/knapp:129-135`), ikke i prøvekjøringen og ikke hvilket tilbud
- **Ikke funnet:** `@OPT-BEH-BEH-007` «Varsel når tilbudsgarantiene overskrider kvoten» (`krav/…:392`) — KVOTEANDEL_OVERSKREDET i `P/svc:417-426`; i fs-admin bare en del av «N utdanningstilbud er feilkonfigurert» (`A/knapp:129-135`). Søkt etter «KVOTEANDEL», «kvotevarsel» i fs-admin
- **Ikke funnet:** `@OPT-BEH-BEH-007` «Kvotevarselet tar med tilbudsgarantier fra en tidligere gjennomføring» (`krav/…:400`) — backend teller dem (`P/svc:617, 1196-1200`); samme mangel i fs-admin
- **Ikke funnet:** `@OPT-BEH-BEH-007` «Kvotevarsel ved 30 prosent når grensen ikke er angitt» (`krav/…:408`) — standardverdi 30 i `P/svc:94-95`; fs-admin sender ikke grensen (`A/knapp:103`) og viser ikke varselet
- **Ikke funnet:** `@OPT-BEH-BEH-007` «Angi grensen for kvotevarsel» (`krav/…:414`) — API-et tar `kvotevarselProsent` (`P/schema:66-71`); fs-admin har ikke noe felt for det (`A/knapp:103, 114`)
- **Kontrollen endret:** `@OPT-BEH-BEH-007` «Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum» — ikke funnet → usikker: forvalteren ser FOP og FOR i saken, `A/tgselect:43-62, 266-267, 322-327`
- **Kontrollen endret:** `@OPT-BEH-BEH-007` «Prøvekjøre tidligopptaket» — funnet → usikker: `A/modal:103-122` viser bare totaltall
- **Kontrollen endret:** 7 regler uten scenario lagt til (kvalifiseringsregelen, poengsumkildene, kvotevarselgrensen, FOP på tilbud uten tidlig opptak, tellingen i snackbaren, dialogen under kjøring, poenggrense bare på tilbud med tidlig opptak)
- **Bygger på #906:** kravet er verifisert slik det står på main (`a742c008`). PR #906 (`krav/beh-007-referanser`) gir «Gjennomføre tidligopptaket på nytt» tittelen «En ny gjennomføring fjerner ikke tilbudsgarantien», og «Se antall saker …» tittelen «Se antall søkere med saker …», der steget nå sier søkere. Stegene er ellers de samme, og titlene i rapporten er fra #906. Med endringen i #906 sier kravet søkere, slik koden teller (`A/modal:81-98`)
- **Rollene i fs-admin er strengere enn i backend:** «Kjør tidligopptak» krever også `SE_OPPTAK` og `OPPTAK_TILBGARANTI_GI_VIA_OPPTAK` (`A/knapp:49-54`). Backend sjekker opptaksforvalter (`P/svc:102-106`), og ifølge dokumentasjonen `OPPTAK_TILBGARANTI_GI_VIA_OPPTAK` ved skriving (`P/schema:52-54`). En forvalter uten `SE_OPPTAK` ser ikke knappen
- **Experimental-skjemaet:** `P/schema` er i experimental-skjemaet, så funksjonen må være slått på i miljøet som testes
- **Åpent spørsmål:** `@OPT-BEH-BEH-007` «Reservert studieplass gir tilbudsgaranti uten kvalifisering» (`krav/…:248`) — Gir reservert studieplass (RSO eller RES) tilbudsgaranti også når søkeren ikke er kvalifisert, eller kvalifiseringen ikke er vurdert? Fagperson svarte ja 13.10.2026, men har sendt spørsmålet videre til en annen domeneekspert. Koden gjør det (`P/svc:681-684`)
- **Ikke sjekket:** `utforing.md` finnes ikke i `tasks/opptak/tidlig-opptak/`, så ingen steg er sendt tilbake

## Endringer

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Regel: Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket, og 19 scenarioer (se *Delvis levert*) | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-007` | Scenario: Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum | ingen | Spurt i kjøringen om koden dekker scenarioet. Svar: vet ikke. Står som `usikker` |
| `@OPT-BEH-BEH-007` | Scenario: Prøvekjøre tidligopptaket | ingen | Spurt i kjøringen om koden dekker scenarioet. Svar: vet ikke. Står som `usikker` |

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti ut fra poenggrensen | funnet | `P/svc:765-775`, `A/knapp:111-115` |
| `@OPT-BEH-BEH-007` | Søkere som ikke deltar får ikke tilbudsgaranti | funnet | `P/svc:667-675` |
| `@OPT-BEH-BEH-007` | Søknader uten konklusjon er ikke med i tidligopptaket | funnet | `P/svc:657-665` |
| `@OPT-BEH-BEH-007` | Søkere som ikke er kvalifisert får ikke tilbudsgaranti | funnet | `P/svc:707-715` |
| `@OPT-BEH-BEH-007` | Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti | ikke funnet | Ingen garanti: `P/svc:698-724`. Forvalteren ser det ikke: `A/modal:28-38` henter verken `detaljer` eller `perUtfall` — søkt etter «KVALIFISERING_IKKE_VURDERT», «perUtfall», «detaljer», «tidligopptakStatus», «tidligopptakResultat», «utfall» i fs-admin |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti på det høyest prioriterte søknadsalternativet | funnet | `P/svc:590-609, 859` |
| `@OPT-BEH-BEH-007` | Bare ferdig behandlede saker er med i tidligopptaket | funnet | `P/svc:644-652`, `A/modal:81-98` |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten poenggrense | funnet | `P/svc:681-684` |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten kvalifisering | funnet | `P/svc:681-684, 688-724` |
| `@OPT-BEH-BEH-007` | Den høyeste poengsummen til søknadsalternativet gjelder | funnet | `P/svc:888-918` |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet | funnet | `P/svc:972-992, 1017-1019, 1074-1079` |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet | funnet | `P/svc:259-266, 1014-1016, 1074-1079` |
| `@OPT-BEH-BEH-007` | Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket | funnet | `P/svc:614-631` |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder går foran poengsummen | funnet | `P/svc:595-608, 627-631` |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum | usikker | `P/svc:627-631` står før status- og konklusjonssjekken. «Opptaksforvalter ser at søkeren har tidligopptakstilbud»: ikke i tidligopptaket (`A/modal:28-38`), men i saken per søknadsalternativ (`A/tgselect:43-62, 266-267, 322-327`). Finneren: ikke funnet. Kontrollen: usikker. Brukeren: vet ikke |
| `@OPT-BEH-BEH-007` | Prøvekjøre tidligopptaket | usikker | `P/svc:108-115, 147-149`, `A/knapp:96-104`. «Ser at søkeren ville fått tilbudsgaranti på "Sykepleie, høst 2027"» vises ikke per søker: `A/modal:103-122` viser bare totaltall. Finneren: funnet. Kontrollen: usikker. Brukeren: vet ikke |
| `@OPT-BEH-BEH-007` | En ny gjennomføring fjerner ikke tilbudsgarantien | funnet | `P/svc:616-626` |
| `@OPT-BEH-BEH-007` | Ny gjennomføring tar med en sak som er blitt ferdig behandlet | funnet | `P/svc:529-536, 821-873` |
| `@OPT-BEH-BEH-007` | Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring | funnet | `P/svc:591-594, 1037-1067` |
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak | funnet | `P/algo:208-211` |
| `@OPT-BEH-BEH-007` | Se utfallet for hver søker | ikke funnet | API-et har det (`P/svc:1091-1116, 1210-1238`; `P/schema:113-152`), men fs-admin viser bare fem totaltall (`A/modal:28-38, 69-122`) — søkt som over |
| `@OPT-BEH-BEH-007` | Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon | funnet | `P/svc:176-181, 219-222`, `A/modal:81-98` |
| `@OPT-BEH-BEH-007` | Se utdanningstilbud med mangelfulle innstillinger | ikke funnet | `P/svc:378-385`; fs-admin viser bare antall avvik etter gjennomføringen (`A/knapp:129-135`) — søkt etter «MANGLER_POENGGRENSE», «konfigurasjonsavvik» i fs-admin |
| `@OPT-BEH-BEH-007` | Varsel når tilbudsgarantiene overskrider kvoten | ikke funnet | `P/svc:417-426`; i fs-admin bare en del av antall feilkonfigurerte (`A/knapp:129-135`) — søkt etter «KVOTEANDEL», «kvotevarsel» |
| `@OPT-BEH-BEH-007` | Kvotevarselet tar med tilbudsgarantier fra en tidligere gjennomføring | ikke funnet | `P/svc:617, 1196-1200`; samme mangel i fs-admin |
| `@OPT-BEH-BEH-007` | Kvotevarsel ved 30 prosent når grensen ikke er angitt | ikke funnet | `P/svc:94-95`, `P/schema:71`; fs-admin sender ikke grensen (`A/knapp:103`) og viser ikke varselet |
| `@OPT-BEH-BEH-007` | Angi grensen for kvotevarsel | ikke funnet | `P/schema:66-71`; fs-admin har ikke noe felt (`A/knapp:103, 114`) |
| `@OPT-BEH-BEH-007` | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak | funnet | `P/svc:279-291`, `P/schema:354-383`, `A/knapp:90-94`, `A/modal:150-154, 177-186` |
| `@OPT-BEH-BEH-007` | Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket | funnet | `P/manuell:60-103`, `A/tgselect:235-238, 322-329` |

## Tilgang og datakonsistens

Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | tilgang | opptaksforvalter gjennomfører og prøvekjører tidligopptaket | stemmer | `P/svc:100-106`, `A/knapp:49-54, 80-88` |
| `@OPT-BEH-BEH-007` | organisasjon | opptaksforvalter gjennomfører for hele opptaket | stemmer | `P/svc:959-962, 994-1001` |
| `@OPT-BEH-BEH-007` | tilgang | opptakseier eller tilbyder endrer poenggrensen | ikke beskrevet | kravet sier ikke beskrevet, koden gjør: opptakseier med `MODIFISERE_OPPTAK`, eller tilbyder i samordna opptak når redigeringsfasen er åpen, bare på tilbud som tilbyr tidlig opptak — `A/TO/hooks/useKanEndrePoenggrense.ts:44-79` |
| `@OPT-BEH-BEH-007` | tilgang | tilbyder endrer manuell tilbudsgaranti | stemmer | `P/manuell:68-77`, `A/tgselect:235-238` |
| `@OPT-BEH-BEH-007` | konsistens | opptaksforvalter prøvekjører | stemmer | `P/svc:108-115, 147-149` |
| `@OPT-BEH-BEH-007` | konsistens | opptaksforvalter gjennomfører på nytt | stemmer | `P/svc:538-545` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Poenggrensen er 0–999,9, med én desimal | grense | `A/liste:25, 27, 135-137` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Tidligopptaket kan ikke prøvekjøres eller kjøres med poenggrenser som ikke er lagret («Du har poenggrenser som ikke er lagret …») | validering | `A/knapp:99-101`, `A/modal:150-154, 162-165` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-007` | Prøvekjøringen starter når dialogen «Kjøre tidligopptak?» åpnes, og gjennomføringen gjøres fra dialogen | tilstandsovergang | `A/knapp:96-104`, `A/modal:150-154` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Dialogen kan ikke lukkes mens gjennomføringen pågår | tilstandsovergang | `A/modal:155-156, 188` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Hjelpeteksten sier at poenggrensen kan stå blank når medianen fra i fjor er OK, men uten poenggrense gis ingen garanti, og medianen brukes ikke | annet | `A/msg` `TidligOpptak.informasjon1`, `P/svc:725-732` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Søkere med tidligopptakstilbud er med selv om de ikke har søkt tidlig opptak | annet | `P/svc:501-534` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-007` | Et tidligopptakstilbud (FOP) avgjør søkeren og får FOR, også på et utdanningstilbud som ikke tilbyr tidlig opptak | annet | `P/svc:627-642, 968` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Utdanningstilbud uten rangeringsregelverk, kompetanseregelverk eller kvote gir ingen garanti, og er avvik | validering | `P/svc:386-409, 688-697, 734-752` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-007` | Mangler poengsummen (poengberegningen er ikke kjørt), gis ingen garanti (MANGLER_POENGSUM) | validering | `P/svc:754-763` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud og trukne søknadsalternativer er ikke med | annet | `P/svc:352, 858` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Kvalifisert når minst ett grunnlag er kvalifisert; ikke kvalifisert bare når alle er vurdert til nei, ellers ikke vurdert | annet | `P/svc:779-803` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Poengsummen tas bare fra aktive kvoter søkeren skal kvoteplasseres i, fra grunnlag rangeringsregelverket åpner for, og fra kvotetyper tilbudet har | annet | `P/svc:911-916, 926-949` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Kvotevarselet måles mot tilbudsgarantikvoten; et tilbud uten den gir aldri varsel | annet | `P/svc:329-348, 418` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Kvotevarselet kommer først over grensen; nøyaktig 30 % gir ikke varsel | grense | `P/svc:418-419` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Snackbaren «N utdanningstilbud er feilkonfigurert» teller avvik, ikke utdanningstilbud, og regner kvotevarsel som feilkonfigurering | annet | `A/knapp:129-135`, `P/svc:372-428` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Kolonnene «T.O. søkere totalt» og «T.O. søkere 1. pri.» viser alltid «-» | annet | `A/liste:145-147` | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Fristen for å fylle inn poenggrenser vises over lista | annet | `A/TO/TidligOpptak.tsx:76-97` | testes i fase 2 |
| `@OPT-BEH-BEH-007` | Poenggrensen kan bare endres på tilbud som tilbyr tidlig opptak («Ikke tidlig opptak her») | validering | `A/TO/hooks/useKanEndrePoenggrense.ts:61`, `A/liste:120-121` | testes i fase 2 |

## Åpne spørsmål

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak | 0 av 3 | 1 av 29 | 0 |
