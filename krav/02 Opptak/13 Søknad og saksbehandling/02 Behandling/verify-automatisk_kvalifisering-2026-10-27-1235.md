# Verifisering: automatisk_kvalifisering.feature

- **Dato:** 2026-10-27 12:35
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 651c89a7fa, oppdatert), `fs-admin` (main, 293c918cf, oppdatert)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `KV` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/kvalifisering`
- `AKV` = `KV/AutomatiskKravelementVurderingService.java`
- `V4` = `KV/KvalifiserKravelementV4Service.java`
- `KE` = `KV/KvalifiseringEvaluator.java`
- `KM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/kontrollmotor`
- `ASS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskSaksbehandlingService.java`
- `VDV` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentVitnemaalService.java`
- `FA` = `fs-admin/src/domains/soknadsbehandling/features`

## Oppsummering

- Scenarioer: 26 funnet, 3 ikke funnet, 5 usikker, av 34
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | `@OPT-BEH-BEH-004` Velge vitnemål som grunnlag for poengberegningen | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-020` kan ikke leveres før dette · Regel: Kravelementene vurderes bare mot ett entydig vitnemål |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-001` Kompetanseregelverk | 1 | `@implemented` | – | Regel: Om søkeren er kvalifisert, avgjøres per grunnlag |
| `@OPT-BEH-BEH-020` | `@OPT-REG-KRA-002` Kravelement | 1 | `@implemented` | – | Regel: Kravelementer som er koblet til vitnemålet, vurderes automatisk |

Avhengigheter: 3 på nivå 1, 1 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Fagkrav som er oppfylt på vitnemålet | funnet | `AKV:141-143,187-191` — kontrollmotoren vurderer kravkodene og skriver at kravet er oppfylt |
| `@OPT-BEH-BEH-020` | Fagkrav som ikke er oppfylt på vitnemålet | funnet | `AKV:182-184,188` — skriver ikke oppfylt, med merknaden «regnet ut til NEI» |
| `@OPT-BEH-BEH-020` | Karakteren fra vitnemålet registreres på fagkravet | funnet | `AKV:180,189`, `KM/KontrollMotor.java:65-77` — karakteren skrives som resultat |
| `@OPT-BEH-BEH-020` | Fagkrav uten karakter oppfylles uten karakter | funnet | `AKV:180`, `KM/KravelementVurdering.java:9-14` — oppfylt skrives uten karakter |
| `@OPT-BEH-BEH-020` | Karakterkrav får karakteren fra vitnemålet | funnet | `KM/KontrollMotor.java:134,161,294-300`, `AKV:180,189` |
| `@OPT-BEH-BEH-020` | Beste karakter gjelder for programfag matematikk | funnet | `KM/KontrollMotor.java:84-89` — programfag matematikk bruker beste karakter; `fs-plattform/opptak/opptak-service/src/test/java/no/sikt/fs/opptak/autosak/kontrollmotor/KontrollmotorKarakterTest.java:46` |
| `@OPT-BEH-BEH-020` | Kravelement som ikke er koblet til vitnemålet, vurderes ikke | funnet | `AKV:130-138` — bare kravelementer med en kjent kravkode vurderes |
| `@OPT-BEH-BEH-020` | Kravelement vurderes mot vitnemål fra R94 | funnet | `KM/FagSoek.java:59-61`, `KM/Kravelementer.java:77,100-102` — fagkoder for både Kunnskapsløftet og R94 under samme kravkode |
| `@OPT-BEH-BEH-020` | Ugyldig karakter må vurderes manuelt | usikker | `AKV:179-185` lagrer ingen karakter og merknaden «vurder manuelt», men `FA/KravlisteStudierCard` viser ikke den automatiske merknaden |
| `@OPT-BEH-BEH-020` | Ingen automatisk vurdering når <grunn> | funnet | `VDV:48-54`, `AKV:102-105` — flere, ingen eller bare kompetansebevis gir ingen vurdering. Alle tre eksemplene dekket |
| `@OPT-BEH-BEH-020` | Kravelementene vurderes mot vitnemålet saksbehandleren har valgt | ikke funnet | `AKV:224` → `VDV:42-56` leser ikke noe valgt vitnemål; bare GSK-vedtaket har et valgt vitnemål (`gsk.graphqls:296`) — søkt etter «valgtVitnemaal», «velgVitnemaal», «vgdoknr» i fs-plattform |
| `@OPT-BEH-BEH-020` | Kompetansebevis ved siden av vitnemålet stopper ikke vurderingen | ikke funnet | `VDV:48` — `size() != 1` gir ingen vurdering når søkeren har vitnemål og kompetansebevis |
| `@OPT-BEH-BEH-020` | Kvalifisert når alle kravelementene i en kravliste er oppfylt | funnet | `KE:154-158,213` |
| `@OPT-BEH-BEH-020` | Kvalifisert når én av kravlistene er oppfylt | funnet | `KE:159-161` |
| `@OPT-BEH-BEH-020` | Karakteren må nå karakterkravet | funnet | `KE:203-211` — karakteren sammenlignes med kravet; uten karakter er søkeren ikke kvalifisert |
| `@OPT-BEH-BEH-020` | Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet | funnet | `KE:146-166`, `KV/KvalifiseringOppdateringService.java:159-182` — hvert grunnlag vurderes for seg, og unntak gjelder per grunnlag |
| `@OPT-BEH-BEH-020` | Kvalifisert per poengvariant | usikker | `KE:58-76` vurderer bare per grunnlag; ingen kvalifisering per poengvariant funnet — søkt etter «privatist», «poengvariant». Scenarioet er et åpent spørsmål |
| `@OPT-BEH-BEH-020` | Kravelementet vurderes i den automatiske behandlingen | funnet | `ASS:134-140,146` — vurderes etter poengberegningen, før kvalifiseringen regnes på nytt |
| `@OPT-BEH-BEH-020` | Feil i vurderingen stopper ikke resten av behandlingen | funnet | `ASS:165-173`, `AKV:77` — feilen fanges i et eget savepoint, og behandlingen fortsetter |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer vurderingen automatikken har satt | funnet | `V4:209,220-221,236-245` — manuell vurdering låser kravelementet og fjerner automatisk-merket |
| `@OPT-BEH-BEH-020` | Saksbehandleren overstyrer karakteren som automatikken har satt | funnet | `V4:213-217,231-246` |
| `@OPT-BEH-BEH-020` | Kravelement som saksbehandleren vurderer, låses | funnet | `V4:235-245`; fs-admin bruker mutasjonen (`FA/KravlisteStudierCard/…/useKvalifiserKravelementMutation.ts:68`) |
| `@OPT-BEH-BEH-020` | Saksbehandleren lar kravelementet stå | usikker | `V4:186-193,260-277` — API-et kan sette «la stå» alene, men `FA/KravlisteStudierCard` har ingen «la stå» for kravelementer — søkt etter «laStaa» i fs-admin |
| `@OPT-BEH-BEH-020` | Låst kravelement vurderes ikke på nytt | funnet | `AKV:122,195` — kravelementer med «la stå» velges ikke og oppdateres ikke |
| `@OPT-BEH-BEH-020` | Andre kravelementer vurderes selv om saksbehandleren har vurdert ett | funnet | `AKV:159-167` — vurderingen og låsen gjelder hvert kravelement for seg |
| `@OPT-BEH-BEH-020` | Nullstilt kravelement kan vurderes automatisk igjen | funnet | `V4:213-246` — nullstilles begge verdiene, fjernes låsen |
| `@OPT-BEH-BEH-020` | Unntak per grunnlag endres ikke | funnet | `AKV:187-196` — skriver bare til kravelementet, aldri til unntakene |
| `@OPT-BEH-BEH-020` | Saksbehandleren fyller ut bare Ja eller Nei | funnet | `V4:221,245`, `AKV:122` — kravelementet låses, og karakteren blir tom |
| `@OPT-BEH-BEH-020` | Kravelementer for et grunnlag som fjernes, beholder vurderingen | funnet | `KV/KvalifiseringKravelementV2OppdateringService.java:55-76` — deaktiveres og aktiveres igjen uten å røre vurderingen |
| `@OPT-BEH-BEH-020` | Kravelementer for et nytt grunnlag vurderes | funnet | `KV/KvalifiseringKravelementV2OppdateringService.java:78-87`, `ASS:129` — nye kravelementer legges inn før den automatiske vurderingen |
| `@OPT-BEH-BEH-020` | Se at kravelementet er vurdert automatisk | ikke funnet | API-et har `statusAutomatiskUtregnet` og `merknadAutomatisk` (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/sak.graphqls:222-230`), men `FA/KravlisteStudierCard` henter og viser dem ikke — søkt etter «statusAutomatisk», «merknadAutomatisk», «automatisk» i fs-admin |
| `@OPT-BEH-BEH-020` | Manuell endring fjerner markeringen som automatisk vurdert | usikker | `V4:209` fjerner automatisk-merket, men den automatiske merknaden blir stående, og ingenting av det vises i fs-admin |
| `@OPT-BEH-BEH-020` | Endringsloggen viser at automatikken vurderte kravelementet | funnet | `AKV:61,150-156` setter maskinell intensjon; tabellen auditeres (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V291__saksbehandling_skjema.sql:1492`); `FA/AuditLogCard/AuditLogItem/AuditLogItem.tsx:36,70-80` viser intensjon og maskinbruker |
| `@OPT-BEH-BEH-020` | Finne søkere som ikke er kvalifisert | usikker | saksoversikten har filteret «Ikke kvalifiserte» (`fs-admin/src/…/SakFilter.tsx:111-112`, backend `SakFilterConditions.java:415-438`), men det gjelder søknadsalternativer generelt, ikke spesielle opptakskrav, og det finnes ingen rapport. Scenarioet er et åpent spørsmål |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Finne søkere som ikke er kvalifisert | ikke funnet | usikker | `fs-admin/src/…/SakFilter.tsx:111-112` — saksoversikten har filteret «Ikke kvalifiserte», som dekker delvis |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-020` — Automatisk vurdering av spesielle opptakskrav (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvalifisering.feature`, `@draft` → `@in-progress`, 26/34 funnet) — `@implemented` på: Scenario: Fagkrav som er oppfylt på vitnemålet (linje 99), Scenario: Fagkrav som ikke er oppfylt på vitnemålet (linje 106), Scenario: Karakteren fra vitnemålet registreres på fagkravet (linje 113), Scenario: Fagkrav uten karakter oppfylles uten karakter (linje 120), Scenario: Karakterkrav får karakteren fra vitnemålet (linje 128), Scenario: Beste karakter gjelder for programfag matematikk (linje 134), Scenario: Kravelement som ikke er koblet til vitnemålet, vurderes ikke (linje 140), Scenario: Kravelement vurderes mot vitnemål fra R94 (linje 146), Scenario: Ingen automatisk vurdering når <grunn> (linje 163), Scenario: Kvalifisert når alle kravelementene i en kravliste er oppfylt (linje 198), Scenario: Kvalifisert når én av kravlistene er oppfylt (linje 204), Scenario: Karakteren må nå karakterkravet (linje 211), Scenario: Søkeren kan være kvalifisert på ett grunnlag og ikke på et annet (linje 217), Regel: Kravelementene vurderes i den automatiske behandlingen (linje 236), Scenario: Saksbehandleren overstyrer vurderingen automatikken har satt (linje 257), Scenario: Saksbehandleren overstyrer karakteren som automatikken har satt (linje 263), Scenario: Kravelement som saksbehandleren vurderer, låses (linje 269), Scenario: Låst kravelement vurderes ikke på nytt (linje 280), Scenario: Andre kravelementer vurderes selv om saksbehandleren har vurdert ett (linje 285), Scenario: Nullstilt kravelement kan vurderes automatisk igjen (linje 292), Scenario: Unntak per grunnlag endres ikke (linje 298), Scenario: Saksbehandleren fyller ut bare Ja eller Nei (linje 303), Regel: Når grunnlaget endres, vurderes kravene på nytt (linje 310), Scenario: Endringsloggen viser at automatikken vurderte kravelementet (linje 337)

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-020` | Automatisk vurdering av spesielle opptakskrav | `@draft` | 26/34 | 3 ikke funnet, 5 usikker. Brukeren beholdt `@draft` til kravet er validert |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **fs-admin viser ikke det automatikken har gjort:** `FA/KravlisteStudierCard` henter ikke `statusAutomatiskUtregnet` eller `merknadAutomatisk`, og har ingen «la stå» for kravelementer, selv om API-et har alle tre.
- **Valgt vitnemål:** `VDV:42-56` leser ikke vitnemålet saksbehandleren har valgt, så automatikken hopper over søkere med flere vitnemål også etter at saksbehandleren har valgt.
- **Vitnemål og kompetansebevis:** `VDV:48` teller alle ikke-annullerte dokumenter. Samme avvik står i `@OPT-BEH-BEH-018` og `@OPT-BEH-BEH-019`.
- **Flere vitnemål stopper hele behandlingen:** `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/SetteGrunnlagService.java:109-112` kaster `FlereVitnemaalException` før kravelementene vurderes, så hele den automatiske behandlingen av saken stopper, ikke bare vurderingen.
- **Åpent spørsmål:** `@OPT-BEH-BEH-020` «Kvalifisert per poengvariant» — dekker grunnlaget det samme som poengvarianten i FS-klienten, eller trengs begge?
- **Åpent spørsmål:** `@OPT-BEH-BEH-020` «Finne søkere som ikke er kvalifisert» — trengs et filter i saksoversikten, en rapport eller begge?
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-020` bygger på `@OPT-BEH-BEH-004` (`@in-progress`)
- **Delvis levert, men ikke validert:** brukeren beholdt `@draft`. Kravet valideres med `fs-krav`, og verifiseres på nytt etterpå.
