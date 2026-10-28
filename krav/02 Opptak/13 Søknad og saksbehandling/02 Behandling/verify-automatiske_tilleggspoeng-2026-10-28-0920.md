# Verifisering: automatiske_tilleggspoeng.feature

- **Dato:** 2026-10-28 09:20
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_tilleggspoeng.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 6aef37f4a4, oppdatert), `fs-admin` (main, 56703096c, oppdatert)
- **Åpne MR-er:** 1 MR i fs-admin, 1 branch uten MR i fs-plattform (0 med kode for kravene)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `POENG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng`
- `APS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/AutomatiskPoengberegningService.java`
- `SAK` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling`
- `ASS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskSaksbehandlingService.java`
- `SCHEMA` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling`
- `CARD` = `fs-admin/src/domains/soknadsbehandling/features/PoengberegningCard`

## Oppsummering

- Scenarioer: 8 funnet, 9 ikke funnet, 4 usikker, av 21
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: ikke sjekket i denne kjøringen
- Regler i koden uten scenario: 2
- Åpne spørsmål: 1 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | `@OPT-BEH-BEH-012` Automatisk kvoteplassering | 1 | `@implemented` | – | Regel: Søkerens alder beregnes på opptakets dato for aldersberegning |
| `@OPT-BEH-BEH-028` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-028` kan ikke leveres før dette; Regel: Opptaksforvalter setter dato for aldersberegning |
| `@OPT-BEH-BEH-028` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |

Avhengigheter: 3 på nivå 1, 1 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | Alderspoeng for søkerens alder | funnet | `POENG/Alderspoeng.java:31-88` — alle åtte radene; kalt fra `APS:156-160` med alderen på datoen for aldersberegning (`POENG/PoengService.java:90-103`). Bare i den automatiske behandlingen |
| `@OPT-BEH-BEH-028` | Alderspoengene viser hvilken alder de er regnet ut for | usikker | `POENG/PoengService.java:99-101` lagrer «Alderspoeng beregnet for 22 år per …» i `merknad_automatisk` (`SCHEMA/poeng.graphqls:98-99`), men `CARD/PoengberegningCard.tsx:15-45` henter og viser den ikke |
| `@OPT-BEH-BEH-028` | Standarddatoen brukes når datoen for aldersberegning ikke er satt | ikke funnet | Standarddatoen 31.12 i publiseringsåret finnes (`SAK/AldersberegningsdatoUtleder.java:43-56`, `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/AldersberegningsdatoDefault.java:19-21`), men ingen alderspoeng regnes ut når saksbehandleren velger grunnlaget (`SAK/PropageringService.java:105-121`) |
| `@OPT-BEH-BEH-028` | Kjønnspoeng for søkerens kjønn | funnet | `POENG/KjonnspoengAlgoritme.java:11-19`, `POENG/Kjonnspoeng.java:28-30` — alle sju radene; kalt fra `APS:161-162`. Bare i den automatiske behandlingen |
| `@OPT-BEH-BEH-028` | Kjønnspoengene viser hvilket kjønn de er regnet ut for | usikker | `POENG/PoengService.java:113-115` lagrer «Kjønnspoeng beregnet for Kvinne» i `merknad_automatisk`, men fs-admin henter og viser den ikke |
| `@OPT-BEH-BEH-028` | Poeng for høyere utdanning | ikke funnet | `poengalgoritme` har bare ALD_* og KJONN_* (`V170__poengalgoritme_alder_kjonn.sql:13-24`), og `APS:156-172` kjenner bare de prefiksene — søkt etter «HØY», «HOY_ALG», «høyere utdanning», «hoyereUtdanning», «HOYUT», «studiepoeng», «tilleggspoeng» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-028` | Automatikken velger grunnlaget | funnet | `ASS:123-135` — grunnlaget settes, poengradene lages og `beregnPoengAutomatisk` regner ut alderspoeng (ALG1, 23 år → 4, `POENG/Alderspoeng.java:41-42`) |
| `@OPT-BEH-BEH-028` | Saksbehandleren velger grunnlaget | ikke funnet | `SAK/LeggTilGrunnlagService.java:39-62` → `SAK/PropageringService.java:109-120` → `SAK/PoengRadOppdateringService.java:115-136` lager rader med poeng = null, og ingen algoritme kjøres — søkt etter «AutomatiskPoengberegningService», «beregnOgLagreAlderspoeng», «beregnOgLagreKjonnspoeng» i `opptak/*/src/main`; eneste kallsteder er `ASS:134` og mutasjonen `beregnPoengAutomatisk` |
| `@OPT-BEH-BEH-028` | Saksbehandleren får kjønnspoengene grunnlaget gir | ikke funnet | Samme kjede som raden over: ingen utregning av kjønnspoeng |
| `@OPT-BEH-BEH-028` | Poengene for grunnlaget som er fjernet, vises ikke lenger | funnet | `SAK/FjernGrunnlagService.java:50-53` → `SAK/PoengRadOppdateringService.java:46-48,94-102` setter `er_aktiv = false`, og `SCHEMA/sak.graphqls:97-99` filtrerer på `er_aktiv` |
| `@OPT-BEH-BEH-028` | Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget | ikke funnet | Poengraden er ikke knyttet til grunnlaget (`SAK/PoengRadOppdateringService.java:66-72,104-113,170-174`), så raden står med verdien den hadde, og ingenting regnes ut på nytt. Kontrollen endret fra usikker |
| `@OPT-BEH-BEH-028` | Poengene regnes ikke ut på nytt av seg selv når datoen for aldersberegning endres | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpprettOpptakMutations.java:172-178` — `oppdaterOpptak` rører ikke `sak_poeng` |
| `@OPT-BEH-BEH-028` | Søker uten elektronisk vitnemål får tilleggspoeng | ikke funnet | Ingen utregning når saksbehandleren velger grunnlaget (se «Saksbehandleren velger grunnlaget»); i automatikken er tilleggspoengene uavhengige av vitnemålet (`APS:116-160`) |
| `@OPT-BEH-BEH-028` | Tilleggspoengene er låst for automatikken når saksbehandleren har behandlet saken | usikker | Det finnes ingen lås på saken. Automatikken hopper over rader med `la_staa = true` (`APS:82`, `POENG/PoengService.java:52`), og `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/SetteGrunnlagService.java:99-105` hopper bare over grunnlagsvalget; poengene regnes ut på nytt for rader som ikke er låst (`ASS:131-135`) |
| `@OPT-BEH-BEH-028` | Tilleggspoengene regnes ut selv om poengene fra vitnemålet står tomme | ikke funnet | Samme kjede som «Saksbehandleren velger grunnlaget» |
| `@OPT-BEH-BEH-028` | Poengene er satt av saksbehandleren og står | funnet | `APS:82`, `POENG/PoengService.java:45-53` — bare rader med `la_staa = false` |
| `@OPT-BEH-BEH-028` | Saksbehandleren overstyrer et alderspoeng som er regnet ut automatisk | funnet | `CARD/PoengberegningCardRow/PoengberegningCardRow.tsx:57-62,138-140`, `POENG/SettPoengService.java:122,161-162`, `APS:82` |
| `@OPT-BEH-BEH-028` | Poengene som er regnet ut automatisk, er merket som det | ikke funnet | `status_automatisk_utregnet = true` settes bare av automatikken (`POENG/PoengService.java:49`), og fs-admin viser ikke feltet (`CARD/PoengberegningCard.tsx:15-45`) |
| `@OPT-BEH-BEH-028` | Poengene er ikke merket som automatiske etter at saksbehandleren har endret dem | funnet | `POENG/SettPoengService.java:162,177` — `status_automatisk_utregnet = false`, eksponert i `SCHEMA/poeng.graphqls:97` |
| `@OPT-BEH-BEH-028` | Poengtypen har en algoritme som ikke kan regnes ut | ikke funnet | Ingen algoritme kjøres når saksbehandleren velger grunnlaget; «Ukjent algoritmekode» skrives bare av automatikken (`POENG/PoengService.java:124-127`), og fs-admin viser ikke merknaden |
| `@OPT-BEH-BEH-028` | Automatikken fortsetter med de andre poengene når en algoritme ikke kan regnes ut | usikker | `APS:163-172` — en ukjent kode uten prefiksene ALD_/KJONN_ gir merknad og `continue`. Kontrollen: en ALD_-kode som ikke finnes i `POENG/AlderspoengAlgoritme.java:9-29` kaster og ruller tilbake hele behandlingen. Lead: ALD_ALG4/5 er fjernet fra databasen i `V396__fjern_ald_alg4_alg5.sql`, så det skjer bare om en ny ALD_-kode legges inn uten kode. Kontrollen endret fra funnet |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

Ikke sjekket i denne kjøringen (se `## Oppfølging`).

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | Saksbehandleren kan få tilleggspoengene regnet ut ved å trykke «Behandle automatisk» etter å ha valgt grunnlaget (bak feature-flagget `automatisk-soknadsbehandling-trigger`) | annet | `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:32,50-52`, `ASS:134` | uklart om ønsket |
| `@OPT-BEH-BEH-028` | En algoritmekode med prefikset ALD_ eller KJONN_ som ikke finnes i koden, ruller tilbake hele den automatiske behandlingen | annet | `POENG/AlderspoengAlgoritme.java:23-29` | testes i fase 2 |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng | 1 av 6 | 1 av 21 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | !3235 feat(soknadsbehandling): vis poengtypenavn i poengsteget (`solov/poengtypenavn-poengsteg`) | åpen | `@OPT-BEH-BEH-028` | 0/21 | legger bare til navnet på poengtypen |
| `fs-plattform` | `mahj/STEK-511` | branch uten MR | – | 0/21 | usikker kobling; bare lokal, gjelder søknadsmangler |

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | scenario | Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget | usikker | ikke funnet | `SAK/PoengRadOppdateringService.java:104-113,170-174` — raden beholder verdien, og ingenting regnes ut |
| `@OPT-BEH-BEH-028` | scenario | Automatikken fortsetter med de andre poengene når en algoritme ikke kan regnes ut | funnet | usikker | `POENG/AlderspoengAlgoritme.java:23-29` — en ukjent ALD_-kode kaster; lead fant at ALD_ALG4/5 er fjernet i `V396__fjern_ald_alg4_alg5.sql` |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen. Brukeren har valgt å beholde `@draft` til kravet er validert.

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-028` — Automatiske tilleggspoeng (`@draft`, 8/21 funnet) — 9 ikke funnet, 4 usikker; brukeren har valgt å beholde `@draft` til kravet er validert

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng | `@draft` | 8/21 | 9 ikke funnet, 4 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Tilleggspoeng ved manuelt grunnlag (kritisk):** alders- og kjønnspoeng regnes bare ut i den automatiske behandlingen (`ASS:134`). Når saksbehandleren legger til grunnlaget, lager `SAK/PoengRadOppdateringService.java:115-136` poengrader uten verdi. Dette gir sju av de ni «ikke funnet». Samme avvik i `@OPT-BEH-BEH-019`.
- **Poeng for høyere utdanning:** finnes ikke som poengalgoritme.
- **fs-admin viser ikke merknaden eller merket fra automatikken:** `CARD/PoengberegningCard.tsx:15-45` henter ikke `merknadAutomatisk` eller `statusAutomatiskUtregnet`.
- **Åpent spørsmål:** `@OPT-BEH-BEH-028` «Poeng for høyere utdanning regnes ut fra søkerens studiepoeng» — Hvilke studiepoeng teller med?
- **Ikke sjekket:** tilgang og datakonsistens. Finnerne og kontrollørene fikk ikke denne sjekken i denne kjøringen.
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-028` bygger på `@OPT-OVO-FRI-001` (`@in-progress`)
- **Forrige rapport:** `verify-automatiske_tilleggspoeng-2026-10-27-1235.md` er slettet etter ønske fra brukeren (én verify-fil per krav).
