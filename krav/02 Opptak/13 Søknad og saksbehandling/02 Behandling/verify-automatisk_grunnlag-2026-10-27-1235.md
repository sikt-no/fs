# Verifisering: automatisk_grunnlag.feature

- **Dato:** 2026-10-27 12:35
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_grunnlag.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 651c89a7fa, oppdatert), `fs-admin` (main, 293c918cf, oppdatert)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `SGS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/SetteGrunnlagService.java`
- `ASS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskSaksbehandlingService.java`
- `LTG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/LeggTilGrunnlagService.java`
- `FG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/FjernGrunnlagService.java`
- `SB` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling`
- `POENG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng`

## Oppsummering

- Scenarioer: 18 funnet, 9 ikke funnet, 2 usikker, av 29
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | `@OPT-REG-GRU-001` Grunnlag og mangelkoder | 1 | `@implemented` | – | Regel: Grunnlaget velges ut fra egenskapene regelverket har gitt det |
| `@OPT-BEH-BEH-019` | `@OPT-BEH-BEH-015` Automatisk GSK-konklusjon | 1 | `@planned` | – | ikke levert, `@OPT-BEH-BEH-019` kan ikke leveres før dette |

Avhengigheter: 2 på nivå 1, 1 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | Grunnlag ut fra førstegangsvitnemål og alder | funnet | `SGS:301-336` — grunnlaget som krever førstegangsvitnemål avvises uten førstegangsvitnemål eller over aldersgrensen; da vinner grunnlaget som krever et vitnemål. Alle tre eksemplene dekket |
| `@OPT-BEH-BEH-019` | Alderen regnes ut på datoen for aldersberegning | funnet | `SGS:164-168,340`, `ASS:103` — alderen regnes mot datoen fra `AldersberegningsdatoUtleder`, ikke behandlingsdatoen |
| `@OPT-BEH-BEH-019` | Førstegangsvitnemål går foran | funnet | `SGS:287-299` — laveste prioritet vinner (førstegangsvitnemål 1, et vitnemål 2); bare ett grunnlag får rader (`SGS:187-205`) |
| `@OPT-BEH-BEH-019` | Grunnlag som bare har en aldersgrense, kommer sist | funnet | `SGS:327,330-336` — bare aldersgrense gir prioritet 3 |
| `@OPT-BEH-BEH-019` | Grunnlag uten egenskaper for automatikken settes ikke | funnet | `SGS:256-259` — kandidatene må ha minst én av de tre egenskapene |
| `@OPT-BEH-BEH-019` | Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes | funnet | `SGS:133,209-225,236-253` — kandidatene hentes fra regelverkssamlingene til søknadens utdanningstilbud |
| `@OPT-BEH-BEH-019` | Grunnlag som ikke er aktivt, settes ikke | funnet | `SGS:254` — `GRUNNLAG.ER_AKTIV.isTrue()` |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes automatisk når <grunn> | funnet | `SGS:115-129,171-181` — ingen vitnemål, bare kompetansebevis, ikke generell studiekompetanse eller ingen kandidat gir ingen skriving. Alle fire eksemplene dekket |
| `@OPT-BEH-BEH-019` | Søker med flere vitnemål behandles ikke automatisk | funnet | `SGS:110-114` kaster `FlereVitnemaalException`; behandlingen går i én transaksjon (`ASS:89`), så ingenting skrives |
| `@OPT-BEH-BEH-019` | Kompetansebevis ved siden av vitnemålet stopper ikke automatikken | ikke funnet | `SGS:372-376,110` — alle ikke-annullerte dokumenter telles, så vitnemål + kompetansebevis kaster `FlereVitnemaalException` (det motsatte av scenarioet) — søkt etter filtrering på dokumenttype før tellingen |
| `@OPT-BEH-BEH-019` | Annullert vitnemål teller ikke | funnet | `SGS:374` — annullerte dokumenter filtreres bort |
| `@OPT-BEH-BEH-019` | Grunnlaget settes etter GSK-konklusjonen | funnet | `ASS:114` (GSK-konklusjonen) kjører før `ASS:123-124` (grunnlaget) |
| `@OPT-BEH-BEH-019` | Grunnlaget settes av den automatiske behandlingen | funnet | `ASS:123-124,149-151` — grunnlaget settes som første steg og merkes som automatisk |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag | funnet | `LTG:125` setter «la stå»; `SGS:99-105,227-234` hopper over saken |
| `@OPT-BEH-BEH-019` | Saksbehandleren velger et grunnlag som automatikken har satt | funnet | `LTG:125-130` — setter «la stå», fjerner automatisk-merket og den automatiske merknaden |
| `@OPT-BEH-BEH-019` | Automatikken fjerner ikke grunnlag | funnet | `SGS:187-205` legger bare til; `SB/KvalifikasjonsgrunnlagOppdateringService.java:99-123` sletter bare ved omregning til andre kompetanseregelverk |
| `@OPT-BEH-BEH-019` | Saksbehandleren fjerner et grunnlag som er satt automatisk | funnet | `FG:90-106` — radene for grunnlaget slettes |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke et grunnlag som saksbehandleren har fjernet | ikke funnet | `FG:90-106` sletter uten å låse saken; `SGS:227-234` ser bare etter «la stå» på rader som finnes, så grunnlaget settes på nytt (som det åpne spørsmålet beskriver) |
| `@OPT-BEH-BEH-019` | Automatikken erstatter grunnlaget når søkeren passer til et annet | ikke funnet | `SGS:187-205` legger bare til det nye; det gamle blir stående (som det åpne spørsmålet beskriver) |
| `@OPT-BEH-BEH-019` | Opptakskrav og kvoter følger grunnlaget saksbehandleren legger til | funnet | `LTG:56-59` → `SB/PropageringService.java:105-121` — opptakskrav, kvalifisering og kvoter oppdateres |
| `@OPT-BEH-BEH-019` | Opptakskrav og kvoter følger grunnlaget som er satt automatisk | funnet | `ASS:129` — samme oppdatering rett etter at grunnlaget er satt |
| `@OPT-BEH-BEH-019` | Saksbehandleren velger grunnlag og søknaden får poengene grunnlaget gir | ikke funnet | `LTG:56-59` → `SB/PropageringService.java:105-121` → `SB/PoengRadOppdateringService.java:117-137` oppretter poengrader uten verdi; alders- og kjønnspoeng regnes bare ut i `POENG/AutomatiskPoengberegningService.java:157-162` — søkt etter alle kall til `beregnOgLagreAlderspoeng` og `beregnOgLagreKjonnspoeng` |
| `@OPT-BEH-BEH-019` | Søker uten elektronisk vitnemål får poeng fra poengalgoritmene | ikke funnet | som over — manuelt valgt grunnlag gir ingen poeng fra algoritmene |
| `@OPT-BEH-BEH-019` | Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget | ikke funnet | som over; `SB/PoengRadOppdateringService.java:106-113` aktiverer bare rader som har et poeng fra før |
| `@OPT-BEH-BEH-019` | Poengene er låst for automatikken når saksbehandleren har behandlet saken | usikker | `POENG/PoengService.java:52,66,151,200`, `POENG/AutomatiskPoengberegningService.java:82` — låsen er per poeng («la stå»), ikke per sak. Manuelt grunnlag låser ikke poengene. Avhenger av hva «behandlet saken» betyr — avgjort av brukeren: vet ikke |
| `@OPT-BEH-BEH-019` | Samme poeng uansett hvem som setter grunnlaget | ikke funnet | automatikken: `ASS:129-135` → `POENG/AutomatiskPoengberegningService.java:156-162`; saksbehandleren: ingen beregning (se over) |
| `@OPT-BEH-BEH-019` | Se at grunnlaget er satt automatisk | ikke funnet | lagres (`SGS:198-199`), men grunnlagstypen i API-et har bare kompetanseregelverk, grunnlag og kvalifisert (`fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/regelverk/kvalifisering.graphqls:143-153`), og `fs-admin/src/domains/soknadsbehandling/features/GrunnlagCard/GrunnlagCard.tsx` viser det ikke — søkt etter «statusAutomatisk», «merknadAutomatisk», «satt automatisk» i fs-admin |
| `@OPT-BEH-BEH-019` | Se hvorfor grunnlaget ble valgt | ikke funnet | årsak, alder og aldersgrense lagres i den automatiske merknaden (`SGS:349-361`), men er ikke i API-et for grunnlag og vises ikke i fs-admin — samme søk |
| `@OPT-BEH-BEH-019` | Endringsloggen viser at den automatiske behandlingen satte grunnlaget | usikker | `ASS:39,104-110` setter intensjonen «Automatisk saksbehandling» og maskinbruker; tabellen auditeres (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V291__saksbehandling_skjema.sql:1491`); `fs-admin/src/domains/soknadsbehandling/features/AuditLogCard/AuditLogItem/AuditLogItem.tsx:70-80` viser intensjon og maskinbruker. Oppføringen gjelder hele behandlingen og sier ikke at det var grunnlaget; avgjøres bare ved kjøring |

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-019` — Automatisk grunnlag (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_grunnlag.feature`, `@draft` → `@in-progress`, 18/29 funnet) — `@implemented` på: Regel: Grunnlaget velges ut fra egenskapene regelverket har gitt det (linje 39), Scenario: Ingen grunnlag settes automatisk når <grunn> (linje 102), Scenario: Søker med flere vitnemål behandles ikke automatisk (linje 114), Scenario: Annullert vitnemål teller ikke (linje 126), Scenario: Grunnlaget settes etter GSK-konklusjonen (linje 133), Regel: Grunnlaget settes når den automatiske behandlingen kjører (linje 140), Scenario: Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag (linje 149), Scenario: Saksbehandleren velger et grunnlag som automatikken har satt (linje 155), Scenario: Automatikken fjerner ikke grunnlag (linje 161), Scenario: Saksbehandleren fjerner et grunnlag som er satt automatisk (linje 167), Regel: Når grunnlaget settes, vurderes søknaden på nytt (linje 197)

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | `@draft` | 18/29 | 9 ikke funnet, 2 usikker. Brukeren beholdt `@draft` til kravet er validert |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Poeng fra algoritmene ved manuelt grunnlag:** `LTG:56-59` og `SB/PropageringService.java:105-121` regner ikke ut alders- og kjønnspoeng. Samme avvik står i `@OPT-BEH-BEH-028`.
- **Vitnemål og kompetansebevis:** `SGS:372-376` teller alle ikke-annullerte dokumenter, og hele den automatiske behandlingen stopper. Samme avvik står i `@OPT-BEH-BEH-018` og `@OPT-BEH-BEH-020`.
- **Grunnlag i API-et:** `kvalifisering.graphqls:143-153` eksponerer ikke automatisk-merket eller den automatiske merknaden for grunnlag, så fs-admin kan ikke vise dem uten en endring i fs-plattform.
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Automatikken setter ikke et grunnlag som saksbehandleren har fjernet» — skal fjerningen låse saken, så grunnlaget holdes borte?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Automatikken erstatter grunnlaget når søkeren passer til et annet» — skal det nye grunnlaget erstatte det gamle?
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-019` bygger på `@OPT-BEH-BEH-015` (`@planned`)
- **Delvis levert, men ikke validert:** brukeren beholdt `@draft`. Kravet valideres med `fs-krav`, og verifiseres på nytt etterpå.
