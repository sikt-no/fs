# Verifisering: Automatisk saksbehandling på vitnemålet saksbehandleren velger (FLY-OPT-VAL-001)

- **Dato:** 2026-10-29 14:12
- **Krav:** `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling_på_valgt_vitnemål.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (origin/main, 755986355a, oppdatert), `fs-admin` (origin/main, f0ef84b83, oppdatert)
- **Åpne MR-er:** 2 MR-er i fs-plattform, 1 i fs-admin (0 med kode for kravene)
- **Omfang:** flyter, alle krav uansett status (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `AS/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/`
- `SGS` = `AS/SetteGrunnlagService.java`
- `BSA` = `fs-admin/src/domains/soknadsbehandling/features/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx`

## Oppsummering

- Scenarioer: 0 funnet, 3 ikke funnet, 0 usikker, av 3
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-VAL-001` | Saksbehandleren velger vitnemålet saken behandles automatisk på | `@OPT-BEH-BEH-025` (`@draft`, Regel: Har søkeren flere vitnemål med påstanden GSK, behandles saken automatisk på vitnemålet saksbehandleren velger) | nei |
| `@FLY-OPT-VAL-001` | Saksbehandleren starter den automatiske behandlingen for saken | `@OPT-BEH-BEH-025` (`@draft`, Regel: Har søkeren flere vitnemål med påstanden GSK, behandles saken automatisk på vitnemålet saksbehandleren velger) | nei |
| `@FLY-OPT-VAL-001` | Resten av saken behandles som i den automatiske saksbehandlingen | `@FLY-OPT-AUT-001` (`@draft`, 13 faser med ankeret) | nei |

`@FLY-OPT-VAL-001`: 0 av 3 faser levert.

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@FLY-OPT-VAL-001` | `@OPT-BEH-BEH-025` Ferdigbehandle en sak | 1 | `@draft` | – | ikke levert, `@FLY-OPT-VAL-001` kan ikke leveres før dette |
| `@FLY-OPT-VAL-001` | `@FLY-OPT-AUT-001` Automatisk saksbehandling | 1 | `@draft` | – | ikke levert, `@FLY-OPT-VAL-001` kan ikke leveres før dette |

Avhengigheter: 2 på nivå 1, 2 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@FLY-OPT-VAL-001` | Vitnemålet saksbehandleren velger, er valgt for den automatiske behandlingen | ikke funnet | fasen er ikke levert: `@OPT-BEH-BEH-025` er `@draft`. Søkt likevel: `AS/records/BehandleSakInput.java:9` og `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/automatisk-saksbehandling.graphqls:52` — inputen til `behandleSakAutomatisk` har bare `sakId`. Valg av vitnemål (`vgdoknr`) finnes bare for GSK-konklusjonen (`AS/gsk/SettGskKonklusjonService.java:66`), og brukes ikke av resten av behandlingen |
| `@FLY-OPT-VAL-001` | Saken behandles helautomatisk på det valgte vitnemålet | ikke funnet | fasen er ikke levert: `@OPT-BEH-BEH-025` er `@draft`. Søkt likevel: lages: `BSA:30-34` — knappen «Start automatisk behandling» sender bare `sakId` (`fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx:112`) · brukes: `SGS:110-114` kaster `FlereVitnemaalException` når søkeren har flere VGS-dokumenter, så saken behandles ikke automatisk |
| `@FLY-OPT-VAL-001` | Saken er ferdig behandlet på det valgte vitnemålet | ikke funnet | fasen er ikke levert: `@FLY-OPT-AUT-001` er `@draft` — behandlingen stopper i `SGS:110-114`, før poeng, kravelementer og kvoter |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | !6438 STEK-632: grunnlagslåsen avledes av status_automatisk_utregnet, ikke la_staa (`mahj/STEK-632`) | åpen | – | 0/3 | usikker kobling: endrer `SetteGrunnlagService`, men kaster fortsatt `FlereVitnemaalException` (teller bare ikke-annullerte dokumenter) |
| `fs-plattform` | !6456 STEK-551 Opptak: annullerte vitnemål brukt i en beregning vises på saken (`opptak/vgs-annullert-brukt-i-beregning`) | åpen | – | 0/3 | usikker kobling: annullerte vitnemål, ikke valg for automatisk behandling |
| `fs-admin` | !3274 Draft: vis at et vitnemål brukt i beregningen er annullert (`opptak/vitnemal-annullert-status`) | utkast | – | 0/3 | usikker kobling: bare `VitnemalsbehandlingSection` |

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen.

**Kan slettes**

Ingen.

**Blir stående**

- `@FLY-OPT-VAL-001` — Automatisk saksbehandling på vitnemålet saksbehandleren velger (`@draft`, 0/3 funnet) — ingen faser er levert: 025 og AUT er `@draft`, og koden stopper når søkeren har flere vitnemål

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-VAL-001` | Automatisk saksbehandling på vitnemålet saksbehandleren velger | `@draft` | 0/3 | 3 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Ingen inngang for valgt vitnemål:** `behandleSakAutomatisk` tar bare `sakId` (`AS/records/BehandleSakInput.java:9`), og grunnlaget stopper med `FlereVitnemaalException` (`SGS:110-114`). For å levere flyten må inputen, eller saken, kunne bære vitnemålet saksbehandleren har valgt, og grunnlaget, poengene og kravelementene må bruke det. Mønsteret finnes for GSK (`AS/gsk/SettGskKonklusjonService.java:66`).
- **Åpent spørsmål:** `@OPT-BEH-BEH-025` «Har søkeren flere vitnemål med påstanden GSK, behandles saken automatisk på vitnemålet saksbehandleren velger» — Hvordan skal saksbehandleren velge vitnemålet og starte behandlingen? Skal valget være i dialogen bak «Start automatisk behandling», eller et eget steg før?
- **Åpent spørsmål:** `@OPT-BEH-BEH-025` «Har søkeren flere vitnemål med påstanden GSK, behandles saken automatisk på vitnemålet saksbehandleren velger» — Hva skjer når saksbehandleren starter behandlingen uten å ha valgt vitnemål, og søkeren har flere vitnemål med påstanden at søkeren har GSK?
- **Bygger på krav som ikke er levert:** `@FLY-OPT-VAL-001` bygger på `@OPT-BEH-BEH-025` (`@draft`) og `@FLY-OPT-AUT-001` (`@draft`)
- **Krav utenfor scope:** `automatisk_saksbehandling_på_valgt_vitnemål.feature` (`@draft`) — valider flyten med `fs-krav` (modus B) før den kan bli `@planned`
