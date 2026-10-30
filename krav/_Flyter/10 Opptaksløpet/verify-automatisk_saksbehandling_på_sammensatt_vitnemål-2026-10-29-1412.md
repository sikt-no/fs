# Verifisering: Automatisk saksbehandling på sammensatt vitnemål (FLY-OPT-SAM-001)

- **Dato:** 2026-10-29 14:12
- **Krav:** `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling_på_sammensatt_vitnemål.feature` (1 feature-fil)
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
- `MIG/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`

## Oppsummering

- Scenarioer: 0 funnet, 6 ikke funnet, 0 usikker, av 6
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-SAM-001` | Saksbehandleren setter sammen et vitnemål i vitnemålsbehandleren | – | mangler krav |
| `@FLY-OPT-SAM-001` | Saksbehandleren starter den automatiske behandlingen for saken | `@OPT-BEH-BEH-025` (`@draft`, Regel: Har søkeren flere vitnemål med påstanden GSK, behandles saken automatisk på vitnemålet saksbehandleren velger) | nei |
| `@FLY-OPT-SAM-001` | Søknaden får ikke grunnlaget for førstegangsvitnemål på det sammensatte vitnemålet | `@OPT-BEH-BEH-019` (`@draft`, Scenario: Sammensatt vitnemål gir ikke grunnlaget som krever førstegangsvitnemål) | nei |
| `@FLY-OPT-SAM-001` | Resten av saken behandles som i den automatiske saksbehandlingen | `@FLY-OPT-AUT-001` (`@draft`, 13 faser med ankeret) | nei |

`@FLY-OPT-SAM-001`: 0 av 4 faser levert.

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@FLY-OPT-SAM-001` | `@OPT-BEH-BEH-019` Automatisk valg av grunnlag | 1 | `@draft` | – | ikke levert, `@FLY-OPT-SAM-001` kan ikke leveres før dette |
| `@FLY-OPT-SAM-001` | `@OPT-BEH-BEH-025` Ferdigbehandle en sak | 1 | `@draft` | – | ikke levert, `@FLY-OPT-SAM-001` kan ikke leveres før dette |
| `@FLY-OPT-SAM-001` | `@FLY-OPT-AUT-001` Automatisk saksbehandling | 1 | `@draft` | – | ikke levert, `@FLY-OPT-SAM-001` kan ikke leveres før dette |

Avhengigheter: 3 på nivå 1, 3 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@FLY-OPT-SAM-001` | Saksbehandleren setter sammen et vitnemål av fag fra flere dokumenter | ikke funnet | fasen mangler krav. Søkt likevel etter «sammensatt», «sammenflett», «kombinert vitnem», «poengvariant», «VPL», «23/6», «23/5», «flere dokument», «fag_aktiv», «forbedring» i fs-plattform og fs-admin: ingen kode som setter sammen et vitnemål. Tabellene `vgs_dokument_fag_aktiv` og `vgs_dokument_fag_forbedring` (`MIG/V177__soknadsbehandling_vgs_dokument.sql`) knytter fag fra et vitnemål til en sak og poengvariant, men brukes ikke av noen kode |
| `@FLY-OPT-SAM-001` | Det sammensatte vitnemålet er ikke et førstegangsvitnemål | ikke funnet | fasen mangler krav. Førstegangsvitnemål leses fra `vgs_dokument.foerstegangsvm` fra KREG (`SGS:131`); det finnes ikke noe sammensatt vitnemål som kan få verdien |
| `@FLY-OPT-SAM-001` | Det sammensatte vitnemålet har bare resultater søkeren har | ikke funnet | fasen mangler krav — ingen kode for sammensatt vitnemål |
| `@FLY-OPT-SAM-001` | Saken behandles helautomatisk på det sammensatte vitnemålet | ikke funnet | fasen er ikke levert: `@OPT-BEH-BEH-025` er `@draft`. Søkt likevel: lages: `BSA:30-34` sender bare `sakId`, og `AS/records/BehandleSakInput.java:9` har bare `sakId` · brukes: `SGS:110-114` kaster `FlereVitnemaalException` når søkeren har flere VGS-dokumenter (vitnemålet og kompetansebeviset i Bakgrunn) |
| `@FLY-OPT-SAM-001` | Søknaden på det sammensatte vitnemålet får ikke grunnlaget som krever førstegangsvitnemål | ikke funnet | fasen er ikke levert: `@OPT-BEH-BEH-019` er `@draft`. Mekanismen finnes for et vitnemål som ikke er førstegangsvitnemål: `SGS:306` hopper over grunnlag som krever førstegangsvitnemål når `foerstegangsvm` ikke er sann. Saken kommer ikke dit med flere dokumenter (`SGS:110-114`) |
| `@FLY-OPT-SAM-001` | Saken er ferdig behandlet på det sammensatte vitnemålet | ikke funnet | fasen er ikke levert: `@FLY-OPT-AUT-001` er `@draft` — ikke søkt |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-plattform` | !6438 STEK-632: grunnlagslåsen avledes av status_automatisk_utregnet, ikke la_staa (`mahj/STEK-632`) | åpen | – | 0/6 | usikker kobling: endrer `SetteGrunnlagService`, men kaster fortsatt `FlereVitnemaalException` (teller bare ikke-annullerte dokumenter) |
| `fs-plattform` | !6456 STEK-551 Opptak: annullerte vitnemål brukt i en beregning vises på saken (`opptak/vgs-annullert-brukt-i-beregning`) | åpen | – | 0/6 | usikker kobling: annullerte vitnemål, ikke sammensatt vitnemål |
| `fs-admin` | !3274 Draft: vis at et vitnemål brukt i beregningen er annullert (`opptak/vitnemal-annullert-status`) | utkast | – | 0/6 | usikker kobling: bare `VitnemalsbehandlingSection` |

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

- `@FLY-OPT-SAM-001` — Automatisk saksbehandling på sammensatt vitnemål (`@draft`, 0/6 funnet) — ingen faser er levert: fase 1 mangler krav, 025, 019 og AUT er `@draft`, og koden har ikke sammensatt vitnemål

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-SAM-001` | Automatisk saksbehandling på sammensatt vitnemål | `@draft` | 0/6 | 6 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Tabeller for aktive og forbedrede fag uten kode:** `vgs_dokument_fag_aktiv` og `vgs_dokument_fag_forbedring` (`MIG/V177__soknadsbehandling_vgs_dokument.sql`) knytter fag fra et vitnemål til en sak og en poengvariant, men ingen kode bruker dem. De kan være datagrunnlaget for et sammensatt vitnemål (VPL) når kravet skrives.
- **Ingen inngang for valgt vitnemål:** `behandleSakAutomatisk` tar bare `sakId` (`AS/records/BehandleSakInput.java:9`), og grunnlaget stopper med `FlereVitnemaalException` (`SGS:110-114`). Det gjelder også et sammensatt vitnemål.
- **Åpent spørsmål:** `@FLY-OPT-SAM-001` «Saksbehandleren setter sammen et vitnemål i vitnemålsbehandleren» — Kravet mangler. Hva er et sammensatt vitnemål, og hvordan løses det best? Det er trolig ulik poengsum per søknadsalternativ (VPL i FS), og det kan brukes til 23/6-regelen.
- **Åpent spørsmål:** `@FLY-OPT-SAM-001` «Saksbehandleren setter sammen et vitnemål i vitnemålsbehandleren» — Får det sammensatte vitnemålet påstanden om GSK? Svaret må kontrolleres mot kravene for GSK (OPT-BEH-BEH-015 og OPT-BEH-BEH-027).
- **Bygger på krav som ikke er levert:** `@FLY-OPT-SAM-001` bygger på `@OPT-BEH-BEH-019` (`@draft`), `@OPT-BEH-BEH-025` (`@draft`) og `@FLY-OPT-AUT-001` (`@draft`)
- **Krav utenfor scope:** `automatisk_saksbehandling_på_sammensatt_vitnemål.feature` (`@draft`) — valider flyten med `fs-krav` (modus B), og skriv kravet for å sette sammen et vitnemål (fase 1), før flyten kan bli `@planned`
