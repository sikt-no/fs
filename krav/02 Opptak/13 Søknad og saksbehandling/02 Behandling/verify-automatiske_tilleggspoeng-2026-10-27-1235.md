# Verifisering: automatiske_tilleggspoeng.feature

- **Dato:** 2026-10-27 12:35
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_tilleggspoeng.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 651c89a7fa, oppdatert), `fs-admin` (main, 293c918cf, oppdatert)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `POENG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng`
- `APS` = `POENG/AutomatiskPoengberegningService.java`
- `PS` = `POENG/PoengService.java`
- `SB` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling`
- `LTG` = `SB/LeggTilGrunnlagService.java`
- `CARD` = `fs-admin/src/domains/soknadsbehandling/features/PoengberegningCard`

## Oppsummering

- Scenarioer: 8 funnet, 8 ikke funnet, 4 usikker, av 20
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | `@OPT-BEH-BEH-012` Automatisk kvoteplassering | 1 | `@implemented` | – | Scenario: Alderspoeng for søkerens alder |
| `@OPT-BEH-BEH-028` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-028` kan ikke leveres før dette · Scenario: Grunnlaget kan ikke velges uten dato for aldersberegning |
| `@OPT-BEH-BEH-028` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | |

Avhengigheter: 3 på nivå 1, 1 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | Alderspoeng for søkerens alder | funnet | `POENG/Alderspoeng.java:31-86`, `PS:95-98` — alle eksemplene stemmer, alderen regnes på datoen for aldersberegning (`APS:149-173`) — avgjort av brukeren: funnet; at saksbehandleren ikke får poengene, dekkes av «Saksbehandleren velger grunnlaget» (linje 97) |
| `@OPT-BEH-BEH-028` | Alderspoengene viser hvilken alder de er regnet ut for | usikker | `PS:99-101` lagrer «Alderspoeng beregnet for … år per …» som automatisk merknad, i API-et som `merknadAutomatisk` (`poeng.graphqls:99`), men `CARD/PoengberegningCard.tsx:18-40` henter den ikke |
| `@OPT-BEH-BEH-028` | Kjønnspoeng for søkerens kjønn | funnet | `POENG/KjonnspoengAlgoritme.java:11-19`, `PS:108-117` — alle eksemplene stemmer (`APS:161-162`) — avgjort av brukeren: funnet; at saksbehandleren ikke får poengene, dekkes av «Saksbehandleren får kjønnspoengene grunnlaget gir» (linje 103) |
| `@OPT-BEH-BEH-028` | Kjønnspoengene viser hvilket kjønn de er regnet ut for | usikker | `PS:113-115` lagrer merknaden, men fs-admin viser den ikke |
| `@OPT-BEH-BEH-028` | Poeng for høyere utdanning | ikke funnet | bare algoritmene for alder (`POENG/AlderspoengAlgoritme.java:9-16`) og kjønn finnes; `APS:36-37,156-173` kjenner bare disse — søkt etter «høyere utdanning», «hoyere», «studiepoeng», «HUTD», «poengalgoritme» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-028` | Automatikken velger grunnlaget | funnet | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskSaksbehandlingService.java:124-135` setter grunnlaget og regner så ut poengene; `APS:156-162` → `PS:90-103` lagrer alderspoengene |
| `@OPT-BEH-BEH-028` | Saksbehandleren velger grunnlaget | ikke funnet | `LTG:45-59` → `SB/PropageringService.java:105-122` → `SB/PoengRadOppdateringService.java` oppretter poengrader uten verdi; alderspoeng regnes bare ut i `APS` — søkt etter alle kall til `beregnOgLagreAlderspoeng` |
| `@OPT-BEH-BEH-028` | Saksbehandleren får kjønnspoengene grunnlaget gir | ikke funnet | som over; kjønnspoeng regnes bare ut i `APS:161-162` |
| `@OPT-BEH-BEH-028` | Poengene for grunnlaget som er fjernet, vises ikke lenger | funnet | `SB/FjernGrunnlagService.java:40-53` → `SB/PoengRadOppdateringService.java:141-147` deaktiverer poengene som ikke lenger hører til et grunnlag |
| `@OPT-BEH-BEH-028` | Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget | ikke funnet | `LTG` og `SB/FjernGrunnlagService.java` regner ikke ut alders- eller kjønnspoeng |
| `@OPT-BEH-BEH-028` | Poengene regnes ikke ut på nytt av seg selv når datoen for aldersberegning endres | usikker | ingen kode regner ut poengene på nytt når datoen endres (`fs-plattform/…/opptak/OpprettOpptakMutations.java`, `AldersberegningsdatoDefault.java`), men det er bare vist ved at ingenting ble funnet |
| `@OPT-BEH-BEH-028` | Tilleggspoengene regnes ut selv om poengene fra vitnemålet står tomme | ikke funnet | den automatiske behandlingen gjør det (`APS:156-173`), men scenarioet gjelder grunnlag saksbehandleren velger (`LTG:45-59`), og da regnes ingenting ut |
| `@OPT-BEH-BEH-028` | Grunnlaget kan ikke velges uten dato for aldersberegning | funnet | `LTG:45` → `SB/AldersberegningsdatoUtleder.java:19-23` stopper med «Opptak … mangler dato for aldersberegning» når poengtypen eller grunnlaget bruker alder (`fs-plattform/…/opptak/OpptakKreverAlderUtleder.java:15-18`). fs-admin har ikke varselet fra STEK-533 |
| `@OPT-BEH-BEH-028` | Standarddatoen brukes når datoen for aldersberegning ikke er satt | ikke funnet | standarddatoen finnes (`fs-plattform/…/opptak/AldersberegningsdatoDefault.java:22-24`) og brukes av automatikken (`APS:92,160`), men scenarioet gjelder grunnlag saksbehandleren velger, og da regnes ingenting ut |
| `@OPT-BEH-BEH-028` | Poengene er satt av saksbehandleren og står | funnet | `APS:82`, `PS:52` — poeng med «la stå» hoppes over; `POENG/SettPoengService.java:112` setter «la stå» som standard |
| `@OPT-BEH-BEH-028` | Saksbehandleren overstyrer et alderspoeng som er regnet ut automatisk | funnet | `POENG/SettPoengService.java:112,161-162` — endringen låser poenget og fjerner automatisk-merket; `APS:82` hopper over det |
| `@OPT-BEH-BEH-028` | Poengene som er regnet ut automatisk, er merket som det | ikke funnet | `PS:49` merker bare i den automatiske behandlingen; merket er i API-et (`poeng.graphqls:97`), men `CARD/PoengberegningCard.tsx:18-40` henter det ikke |
| `@OPT-BEH-BEH-028` | Poengene er ikke merket som automatiske etter at saksbehandleren har endret dem | funnet | `POENG/SettPoengService.java:162,177` — automatisk-merket fjernes |
| `@OPT-BEH-BEH-028` | Poengtypen har en algoritme som ikke kan regnes ut | ikke funnet | merknaden om ukjent algoritme skrives bare i den automatiske behandlingen (`PS:124-127`, `APS:163-172`), ikke når saksbehandleren velger grunnlaget |
| `@OPT-BEH-BEH-028` | Automatikken fortsetter med de andre poengene når en algoritme ikke kan regnes ut | usikker | `APS:163-172` — en algoritme med ukjent prefiks gir merknad, og resten regnes ut. Men en algoritme for alder eller kjønn med ukjent variant kaster (`POENG/AlderspoengAlgoritme.java:27`, `POENG/KjonnspoengAlgoritme.java:46`), og hele beregningen rulles tilbake (`APS:51`, STEK-507) |

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-028` — Automatiske tilleggspoeng (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatiske_tilleggspoeng.feature`, `@draft` → `@in-progress`, 6/20 funnet) — `@implemented` på: Scenario: Automatikken velger grunnlaget (linje 91), Scenario: Poengene for grunnlaget som er fjernet, vises ikke lenger (linje 109), Scenario: Grunnlaget kan ikke velges uten dato for aldersberegning (linje 142), Scenario: Poengene er satt av saksbehandleren og står (linje 159), Scenario: Saksbehandleren overstyrer et alderspoeng som er regnet ut automatisk (linje 164), Scenario: Poengene er ikke merket som automatiske etter at saksbehandleren har endret dem (linje 176)

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-028` | Automatiske tilleggspoeng | `@draft` | 8/20 | 8 ikke funnet, 4 usikker. Brukeren beholdt `@draft` til kravet er validert |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Poeng fra algoritmene ved manuelt grunnlag:** `LTG:45-59` og `SB/PropageringService.java:105-122` regner ikke ut alders- og kjønnspoeng. Det er grunnen til de fleste radene som er `ikke funnet` eller `usikker`. Samme avvik står i `@OPT-BEH-BEH-019`.
- **Ukjent algoritme ruller tilbake hele beregningen:** `POENG/AlderspoengAlgoritme.java:27` og `POENG/KjonnspoengAlgoritme.java:46` kaster, og `APS:51` ruller tilbake (STEK-507).
- **fs-admin viser ikke det automatikken har gjort:** `CARD/PoengberegningCard.tsx:18-40` henter ikke `merknadAutomatisk` eller `statusAutomatiskUtregnet`. Varselet om at opptaket mangler dato for aldersberegning (STEK-533) er heller ikke bygget i fs-admin.
- **Åpent spørsmål:** `@OPT-BEH-BEH-028` «Poeng for høyere utdanning regnes ut fra søkerens studiepoeng» — hvilke studiepoeng teller med?
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-028` bygger på `@OPT-OVO-FRI-001` (`@in-progress`)
- **Delvis levert, men ikke validert:** brukeren beholdt `@draft`. Kravet valideres med `fs-krav`, og verifiseres på nytt etterpå.
- **Kritisk:** brukeren sier at poengene fra algoritmene ved manuelt grunnlag («Saksbehandleren velger grunnlaget», linje 97, og «Saksbehandleren får kjønnspoengene grunnlaget gir», linje 103) må på plass før kravet kan regnes som ferdig.
