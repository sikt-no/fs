# Verifisering: automatisk_kvalifisering.feature

- **Dato:** 2026-10-28 09:20
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 6aef37f4a4, oppdatert), `fs-admin` (main, 56703096c, oppdatert)
- **Åpne MR-er:** 2 MR-er i fs-admin, 0 i fs-plattform (0 med kode for kravene)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `AKV` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvalifisering/AutomatiskKravelementVurderingService.java`
- `KVAL` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvalifisering`
- `KM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/kontrollmotor`
- `ASS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskSaksbehandlingService.java`
- `VGS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs`
- `SCHEMA` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `ADMIN` = `fs-admin/src/domains/soknadsbehandling`

## Oppsummering

- Scenarioer: 28 funnet, 5 ikke funnet, 1 usikker, av 34
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: ikke sjekket i denne kjøringen
- Regler i koden uten scenario: 3
- Åpne spørsmål: 0 regler og 2 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | `@OPT-BEH-BEH-004` Velge vitnemål som grunnlag for poengberegningen | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-020` kan ikke leveres før dette |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-001` Kompetanseregelverk | 1 | `@implemented` | – | |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-002` Kravelement | 1 | `@implemented` | – | |

Avhengigheter: 3 på nivå 1, 1 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Fagkrav som er oppfylt på vitnemålet | funnet | `AKV:110-143,187-191`, `KM/KontrollMotor.java:90-95,196-198` — kravkoden på kravelementet kjøres i kontrollmotoren, og `kravet_er_oppfylt` skrives |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt på vitnemålet | funnet | `KM/KontrollMotor.java:196-198`, `AKV:188` — uten faget skrives `false` |
| `@OPT-BEH-BEH-020` | Karakteren fra vitnemålet registreres på fagkravet | funnet | `KM/KontrollMotor.java:72-77`, `KM/FagSoek.java:354-378`, `AKV:180,189` — snitt av standpunkt og eksamen skrives som resultat |
| `@OPT-BEH-BEH-020` | Fagkrav uten karakter oppfylles uten karakter | funnet | `KM/FagSoek.java:415-418`, `KM/KontrollMotor.java:197`, `AKV:180,189` — tom karakter gir oppfylt uten resultat |
| `@OPT-BEH-BEH-020` | Karakterkrav får karakteren fra vitnemålet | funnet | `KM/KontrollMotor.java:161,293-300`, `AKV:180,189` |
| `@OPT-BEH-BEH-020` | Beste karakter gjelder for programfag matematikk | funnet | `KM/KontrollMotor.java:84-89`, `KM/Kravelementer.java:89`, `KM/FagSoek.java:381-399` — `Karakterstrategi.BESTE` over R1/S1/R2/S2 |
| `@OPT-BEH-BEH-020` | Kravelement som ikke er koblet til vitnemålet, vurderes ikke | funnet | `AKV:128-139` — rader uten kjent kravkode hoppes over |
| `@OPT-BEH-BEH-020` | Kravelement vurderes mot vitnemål fra R94 | funnet | `KM/Kravelementer.java:376-490` (f.eks. `:392-398` Fysikk 1 med R94-kodene), `KM/FagSoek.java:60` |
| `@OPT-BEH-BEH-020` | Ugyldig karakter må vurderes manuelt | ikke funnet | Backend setter resultat til null og merknaden «… vurder manuelt» (`AKV:179-185,189-190`, `SCHEMA/saksbehandling/sak.graphqls:237`), men `ADMIN/features/KravlisteStudierCard` og `ADMIN/components/KravOppsummering` henter og viser ikke merknaden — søkt etter «merknadAutomatisk», «statusAutomatiskUtregnet», «vurder manuelt» i fs-admin (også !3236 og !3193) |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | `VGS/VgsDokumentVitnemaalService.java:42-55`, `AKV:102-104` — alle tre radene gir ingen vurdering |
| `@OPT-BEH-BEH-020` | Kravelementene vurderes mot vitnemålet saksbehandleren har valgt | ikke funnet | `AKV:216-225` bruker bare `byggVitnemaalForPerson` — søkt etter «valgtVitnemaal», «valgt_vitnemal», «velgVitnem», «byggVitnemaal(» i fs-plattform; bare GSK bruker et bestemt dokument |
| `@OPT-BEH-BEH-020` | Kompetansebevis ved siden av vitnemålet stopper ikke vurderingen | ikke funnet | Koden gjør det motsatte: `VGS/VgsDokumentVitnemaalService.java:48` krever nøyaktig ett ikke-annullert dokument, så VM + KB gir ingen vurdering |
| `@OPT-BEH-BEH-020` | Kvalifisert når alle kravelementene i en kravliste er oppfylt | funnet | `KVAL/KvalifiseringEvaluator.java:132-178,194-221` |
| `@OPT-BEH-BEH-020` | Kvalifisert når én av kravlistene er oppfylt | funnet | `KVAL/KvalifiseringEvaluator.java:159-160,288-322` |
| `@OPT-BEH-BEH-020` | Karakteren må nå karakterkravet | funnet | `KVAL/KvalifiseringEvaluator.java:203-211` |
| `@OPT-BEH-BEH-020` | Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet | funnet | `KVAL/KvalifiseringOppdateringService.java:97-117,168-182` — unntaket overstyrer for sitt grunnlag, og `er_kvalifisert` settes per grunnlag |
| `@OPT-BEH-BEH-020` | Kvalifisert per poengvariant | usikker | `KVAL/KvalifiseringOppdateringService.java:115-117` — kvalifiseringen er per grunnlag, ikke per poengvariant eller kvote; førstegangsvitnemål er en egenskap ved grunnlaget (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/SetteGrunnlagService.java:306-308`). Det åpne spørsmålet avgjør |
| `@OPT-BEH-BEH-020` | Kravelementet vurderes i den automatiske behandlingen | funnet | `ASS:131-147` — steg 1b etter poengene, og kvalifiseringen beregnes på nytt etterpå |
| `@OPT-BEH-BEH-020` | Feil i vurderingen stopper ikke resten av behandlingen | funnet | `ASS:165-174`, `AKV:77,95-101,142-148` — `KravelementVurderingException` fanges, og behandlingen fortsetter |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer vurderingen automatikken har satt | funnet | `ADMIN/features/KravlisteStudierCard/KravlisteStudierCard.tsx:212-224`, `KVAL/KvalifiserKravelementV4Service.java:208-246`, `AKV:122,195` |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer karakteren som automatikken har satt | funnet | `ADMIN/features/KravlisteStudierCard/KravlisteStudierCard.tsx:174-210`, `KVAL/KvalifiserKravelementV4Service.java:215-216,235-245` |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren vurderer, låses | funnet | `KVAL/KvalifiserKravelementV4Service.java:231-246` |
| `@OPT-BEH-BEH-020` | Saksbehandleren velger "la stå" på kravelementet | ikke funnet | Backend støtter at bare låsen settes (`KVAL/KvalifiserKravelementV4Service.java:186-192,260-277`, `SCHEMA/regelverk/kvalifisering.graphqls:82`), men fs-admin har ikke «La stå» for kravelementer, bare for poeng (`ADMIN/features/PoengberegningCard/PoengberegningCardRow/PoengberegningCardRow.tsx:160-218`) — søkt etter «laStaa», «la stå» i fs-admin (også !3236 og !3193) |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren bare ser på, vurderes automatisk igjen | funnet | `ADMIN/features/KravlisteStudierCard/KravlisteStudierCard.tsx:182-186` sender ingenting når verdien er uendret, og `AKV:122` vurderer rader med `la_staa = false` |
| `@OPT-BEH-BEH-020` | Låst kravelement vurderes ikke på nytt | funnet | `AKV:122,195` |
| `@OPT-BEH-BEH-020` | Andre kravelementer vurderes selv om saksbehandleren har vurdert ett | funnet | `AKV:110-124,159-167,193-195` — låsen gjelder per kravelement |
| `@OPT-BEH-BEH-020` | Nullstilt kravelement kan vurderes automatisk igjen | funnet | `ADMIN/features/KravlisteStudierCard/KravlisteStudierCard.tsx:188-194,219-222`, `KVAL/KvalifiserKravelementV4Service.java:235-245`, `KVAL/EffektivVerdi.java:17-25` — låsen fjernes når både karakter og vurdering er tomme |
| `@OPT-BEH-BEH-020` | Unntak per grunnlag endres ikke | funnet | `AKV:29-31,187-196` — automatikken skriver aldri til unntakstabellen |
| `@OPT-BEH-BEH-020` | Kravelementer for et grunnlag som fjernes, beholder vurderingen | funnet | `KVAL/KvalifiseringKravelementV2OppdateringService.java:25-31,55-76` — raden deaktiveres og aktiveres igjen med vurderingen |
| `@OPT-BEH-BEH-020` | Kravelementer for et nytt grunnlag vurderes | funnet | `ASS:122-129,140`, `KVAL/KvalifiseringKravelementV2OppdateringService.java:78-87` |
| `@OPT-BEH-BEH-020` | Se at kravelementet er vurdert automatisk | ikke funnet | `statusAutomatiskUtregnet` og `merknadAutomatisk` med vitnemålsnummer finnes i API-et (`AKV:185,190-191`, `SCHEMA/saksbehandling/sak.graphqls:233-241`), men `ADMIN/features/KravlisteStudierCard/KravlisteStudierCard.tsx:32-75` henter dem ikke — samme søk som over |
| `@OPT-BEH-BEH-020` | Manuell endring fjerner markeringen som automatisk vurdert | funnet | `KVAL/KvalifiserKravelementV4Service.java:207-209` — `status_automatisk_utregnet = false` |
| `@OPT-BEH-BEH-020` | Endringsloggen viser at automatikken vurderte kravelementet | funnet | `AKV:61,150-156`, `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/audit/AuditContext.java:104-113`, `V291__saksbehandling_skjema.sql:1492`, `ADMIN/features/AuditLogCard/AuditLogItem/AuditLogItem.tsx:36,70-80` — intensjonen «Maskinell kravelement-vurdering fra vitnemål» og maskinbrukeren vises |
| `@OPT-BEH-BEH-020` | Finne søkere som ikke er kvalifisert | funnet | `ADMIN/features/SakOverviewView/components/SakFilter/SakFilter.tsx:108-114`, `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SakFilterConditions.java:415-438` — filteret «Ikke kvalifiserte»; ingen rapport eller brev som FS102.004/FS120.002 |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

Ikke sjekket i denne kjøringen (se `## Oppfølging`).

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | fs-admin nullstiller ett felt om gangen; har automatikken satt en karakter, blir kravelementet låst til både karakter og vurdering er tømt | tilstandsovergang | `ADMIN/features/KravlisteStudierCard/KravlisteStudierCard.tsx:190-193,219-222`, `KVAL/EffektivVerdi.java:17-25` | uklart om ønsket |
| `@OPT-BEH-BEH-020` | En karakter som ikke er et tall, gir oppfylt uten karakter og merknaden «vurder manuelt» | validering | `KM/FagSoek.java:415-418`, `AKV:182-183` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-020` | Bare forventede feil i vurderingen svelges; andre feil ruller tilbake hele behandlingen | annet | `ASS:165-174` | testes i fase 2 |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | 0 av 7 | 2 av 34 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | !3236 fix(soknadsbehandling): vis karakterkrav som kvalifisert i skuffen (`solov/skuff-karakterkrav-kvalifisert`) | åpen | `@OPT-BEH-BEH-020` | 0/34 | usikker kobling; rører bare kvalifisert-merkene i skuffen |
| `fs-admin` | !3193 feat(soknadsbehandling): vis søkerens elektroniske vitnemål (`opptak/vise-elektroniske-vitnemal`) | åpen | `@OPT-BEH-BEH-020` | 0/34 | usikker kobling; knytter ikke vitnemålene til kravelementer |

Branchen `solov/grunnlag-per-kravelement` i fs-plattform er merget i !5748 (18.09.2026) og er på main.

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen. Brukeren har valgt å beholde `@draft` til kravet er validert.

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-020` — Automatisk vurdering av spesielle opptakskrav (`@draft`, 28/34 funnet) — 5 ikke funnet, 1 usikker; brukeren har valgt å beholde `@draft` til kravet er validert

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | `@draft` | 28/34 | 5 ikke funnet, 1 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **fs-admin viser ikke det automatikken har gjort med kravelementene:** `statusAutomatiskUtregnet` og `merknadAutomatisk` hentes ikke i `ADMIN/features/KravlisteStudierCard/KravlisteStudierCard.tsx:32-75`, og det finnes ingen «La stå» for kravelementer.
- **Vitnemål og kompetansebevis, og valgt vitnemål:** samme avvik som i `@OPT-BEH-BEH-018` og `@OPT-BEH-BEH-019` (`VGS/VgsDokumentVitnemaalService.java:48`, `AKV:216-225`).
- **Åpent spørsmål:** `@OPT-BEH-BEH-020` «Kvalifisert per poengvariant» — FS-klienten avgjør om søkeren er kvalifisert per poengvariant og spesielt krav. Ny stack gjør det per grunnlag. Dekker grunnlaget det samme, eller trengs begge?
- **Åpent spørsmål:** `@OPT-BEH-BEH-020` «Finne søkere som ikke er kvalifisert» — Trengs et filter i saksoversikten, en rapport eller begge? Filteret finnes, men det gjelder hele kompetansekravet, også GSK.
- **Ikke sjekket:** tilgang og datakonsistens. Finnerne og kontrollørene fikk ikke denne sjekken i denne kjøringen.
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-020` bygger på `@OPT-BEH-BEH-004` (`@in-progress`)
- **Forrige rapport:** `verify-automatisk_kvalifisering-2026-10-27-1235.md` er slettet etter ønske fra brukeren (én verify-fil per krav).
