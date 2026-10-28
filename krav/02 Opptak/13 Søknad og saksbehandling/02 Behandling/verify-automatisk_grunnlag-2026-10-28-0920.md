# Verifisering: automatisk_grunnlag.feature

- **Dato:** 2026-10-28 09:20
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_grunnlag.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 6aef37f4a4, oppdatert), `fs-admin` (main, 56703096c, oppdatert)
- **Åpne MR-er:** 1 MR i fs-admin, 3 brancher uten MR i fs-plattform (0 med kode for kravene)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `SGS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/SetteGrunnlagService.java`
- `ASS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/autosak/AutomatiskSaksbehandlingService.java`
- `SAK` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling`
- `SCHEMA` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `ADMIN` = `fs-admin/src/domains/soknadsbehandling/features`

## Oppsummering

- Scenarioer: 17 funnet, 10 ikke funnet, 2 usikker, av 29
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: ikke sjekket i denne kjøringen
- Regler i koden uten scenario: 2
- Åpne spørsmål: 0 regler og 7 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | `@OPT-BEH-BEH-015` Automatisk GSK-konklusjon | 1 | `@planned` | – | ikke levert, `@OPT-BEH-BEH-019` kan ikke leveres før dette |
| `@OPT-BEH-BEH-019` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-BEH-BEH-019` kan ikke leveres før dette; Regel: Opptaksforvalter setter dato for aldersberegning |
| `@OPT-BEH-BEH-019` | `@OPT-REG-GRU-001` Grunnlag og mangelkoder | 1 | `@implemented` | – | Regel: Grunnlaget velges ut fra egenskapene regelverket har gitt det |

Avhengigheter: 3 på nivå 1, 2 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | Grunnlag ut fra førstegangsvitnemål og alder | funnet | `SGS:301-327,330-336,287-288` — førstegangsgrunnlaget forkastes ved alder over grensen eller vitnemål som ikke er førstegangsvitnemål, og grunnlaget som krever et vitnemål vinner da; alle tre radene |
| `@OPT-BEH-BEH-019` | Alderen regnes ut på datoen for aldersberegning | funnet | `SGS:164-167`, `SAK/AldersberegningsdatoUtleder.java:43-56` — alderen regnes på opptakets dato for aldersberegning, ikke kjøredatoen |
| `@OPT-BEH-BEH-019` | Førstegangsvitnemål går foran | funnet | `SGS:287-288,330-336,183-205` — prioritet 1 vinner, og bare den valgte kandidaten skrives |
| `@OPT-BEH-BEH-019` | Flere grunnlag passer like godt | funnet | `SGS:289-298` — advarsel i loggen og laveste grunnlagskode; søknaden får ett grunnlag |
| `@OPT-BEH-BEH-019` | Grunnlag uten egenskaper for automatikken settes ikke | funnet | `SGS:255-259` — bare grunnlag med aldersgrense, krav om vitnemål eller krav om førstegangsvitnemål blir kandidater |
| `@OPT-BEH-BEH-019` | Bare grunnlag i regelverket til utdanningstilbudene i søknaden kan settes | funnet | `SGS:133-134,236-253,144-152,209-225` — kandidatene hentes fra regelverksamlingene til søknadsalternativene |
| `@OPT-BEH-BEH-019` | Grunnlag som ikke er aktivt, settes ikke | funnet | `SGS:254` — `GRUNNLAG.ER_AKTIV.isTrue()` |
| `@OPT-BEH-BEH-019` | Ingen grunnlag settes automatisk når <grunn> | funnet | `SGS:115-117` (ingen dokument), `:119-126` (bare kompetansebevis), `:127-129` (ikke GSK), `:170-181` (ingen treff) — alle fire radene |
| `@OPT-BEH-BEH-019` | Søker med flere vitnemål behandles ikke automatisk | funnet | `SGS:110-114` kaster `FlereVitnemaalException`, og `ASS:89` ruller tilbake hele behandlingen; `SCHEMA/saksbehandling/automatisk-saksbehandling.graphqls:230` |
| `@OPT-BEH-BEH-019` | Grunnlag fra vitnemålet saksbehandleren har valgt | ikke funnet | `SGS:371-376,110-114` teller dokumentene uten noe valg, og `vgs_dokument` har ingen valgkolonne (`V176__kompetanse_vgs.sql:102-117`); bare GSK kan settes fra et valgt dokument — søkt etter «valgt_vitnem», «valgtVitnem», «velgVitnem», «VALGT_DOKUMENT», «gjeldende_vitnem» i fs-plattform og fs-admin (også !3193, som bare viser vitnemålene) |
| `@OPT-BEH-BEH-019` | Kompetansebevis ved siden av vitnemålet stopper ikke automatikken | ikke funnet | Koden gjør det motsatte: `SGS:371-376` henter VM og KB, og `:110-114` kaster ved to dokumenter før typesjekken på `:119` |
| `@OPT-BEH-BEH-019` | Annullert vitnemål teller ikke | funnet | `SGS:374` — annullerte dokumenter filtreres bort før tellingen |
| `@OPT-BEH-BEH-019` | Grunnlaget settes etter GSK-konklusjonen | funnet | `ASS:112-120` (GSK) før `ASS:122-124` (grunnlag), i samme transaksjon |
| `@OPT-BEH-BEH-019` | Grunnlaget settes av den automatiske behandlingen | funnet | `ASS:122-124`; `ADMIN/SakActionButtons/components/BehandleSakAutomatiskButton/BehandleSakAutomatiskButton.tsx:28-32`, brukt i `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/layout.tsx:112` |
| `@OPT-BEH-BEH-019` | Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes | ikke funnet | Bare `SGS:189`, `SAK/LeggTilGrunnlagService.java:113` og `SAK/KvalifikasjonsgrunnlagOppdateringService.java:142` skriver grunnlag på saken; `grunnlagkode_default` på `kvotetype_grunnlag` brukes til kvoteplassering, ikke når søknadsalternativet opprettes — søkt etter «kvalgrunnlag», «aut_grunnlag», «automatisk_grunnlag» i migrasjonene |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke grunnlag når saksbehandleren har lagt til et grunnlag | funnet | `SAK/LeggTilGrunnlagService.java:125` setter `la_staa = true`, og `SGS:99-105,227-234` hopper over hele saken |
| `@OPT-BEH-BEH-019` | Saksbehandleren velger et grunnlag som automatikken har satt | funnet | `SAK/LeggTilGrunnlagService.java:127-131` — `la_staa = true`, `status_automatisk_utregnet = false` og merknaden tømmes |
| `@OPT-BEH-BEH-019` | Automatikken fjerner ikke grunnlag | funnet | `SGS:187-205,171-181` — bare upsert, ingen sletting |
| `@OPT-BEH-BEH-019` | Saksbehandleren fjerner et grunnlag som er satt automatisk | funnet | `SAK/FjernGrunnlagService.java:89-106`; `ADMIN/GrunnlagCard/GrunnlagCard.tsx:107-115` |
| `@OPT-BEH-BEH-019` | Automatikken setter ikke et grunnlag som saksbehandleren har fjernet | ikke funnet | Koden gjør det motsatte: `SAK/FjernGrunnlagService.java:90-98` sletter raden uten sperre, og `SGS:227-234` setter grunnlaget på nytt |
| `@OPT-BEH-BEH-019` | Automatikken erstatter grunnlaget når søkeren passer til et annet | ikke funnet | `SGS:187-205` legger bare til, og fjerner aldri det gamle grunnlaget |
| `@OPT-BEH-BEH-019` | Gjøre søknaden tilgjengelig for automatikken igjen | ikke funnet | Ingen mutasjon setter `la_staa = false` på grunnlag: `SCHEMA/saksbehandling/sak.graphqls:763-777`, `SCHEMA/regelverk/kvalifisering.graphqls:143-153` — søkt etter «LA_STAA, false», «laStaa» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-019` | Grunnlag utenfor aldersgrensen kan ikke velges manuelt | ikke funnet | `SAK/LeggTilGrunnlagService.java:162-190` og `SAK/GyldigeGrunnlagService.java` sjekker ikke alder; branchen `mahj/STEK-585` endrer bare kvotene |
| `@OPT-BEH-BEH-019` | Opptaket mangler dato for aldersberegning | usikker | `SAK/LeggTilGrunnlagService.java:45` → `SAK/AldersberegningsdatoUtleder.java:17-24,37-41` kaster `ManglerAldersberegningsdatoFeil` før grunnlaget lagres, men fs-admin viser bare «Kunne ikke endre grunnlag» (`ADMIN/GrunnlagCard/GrunnlagCard.tsx:138-146`, `fs-admin/src/common/messages/nb/soknadsbehandling.json:522`), ikke at datoen mangler |
| `@OPT-BEH-BEH-019` | Opptakskrav, kvoter og tilleggspoeng følger grunnlaget saksbehandleren legger til | ikke funnet | Opptakskrav og kvoter følger med (`SAK/LeggTilGrunnlagService.java:55-59` → `SAK/PropageringService.java:105-121`), men tilleggspoengene regnes ikke ut: `SAK/PoengRadOppdateringService.java:115-131` lager rader med poeng = null, og `AutomatiskPoengberegningService` kalles bare fra `ASS:134` — søkt etter «beregnPoengAutomatisk», «AutomatiskPoengberegningService» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-019` | Opptakskrav, kvoter og tilleggspoeng følger grunnlaget som er satt automatisk | funnet | `ASS:129` (propagering), `ASS:134-135` og `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/AutomatiskPoengberegningService.java:156-161` (alders- og kjønnspoeng), `ASS:146-147` |
| `@OPT-BEH-BEH-019` | Se at grunnlaget er satt automatisk | ikke funnet | `SGS:198` lagrer `status_automatisk_utregnet`, men `SCHEMA/regelverk/kvalifisering.graphqls:143-153` eksponerer det ikke, og `ADMIN/GrunnlagCard/GrunnlagCard.tsx:18-41` henter det ikke — søkt etter «statusAutomatiskUtregnet», «merknadAutomatisk» i fs-admin (også !3193) |
| `@OPT-BEH-BEH-019` | Se hvorfor grunnlaget ble valgt | ikke funnet | `SGS:349-361` lagrer årsaken i `merknad_automatisk`, men feltet er ikke eksponert for grunnlag og vises ikke — samme søk |
| `@OPT-BEH-BEH-019` | Endringsloggen viser at den automatiske behandlingen satte grunnlaget | usikker | Tabellen auditeres (`V291__saksbehandling_skjema.sql:1490`), `ASS:104-110` setter intensjonen «Automatisk saksbehandling», og `ADMIN/AuditLogCard/AuditLogItem/AuditLogItem.tsx:70-80` viser maskinbrukeren; men innslaget (`SCHEMA/saksbehandling/sak.graphqls:189-201`) sier ikke at det var grunnlaget som ble satt |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

Ikke sjekket i denne kjøringen (se `## Oppfølging`).

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | Automatikken låser hele saken så snart én grunnlagsrad har `la_staa = true`; fjerner saksbehandleren alle grunnlagene sine, er saken åpen for automatikken igjen | tilstandsovergang | `SGS:99-105,227-234` | uklart om ønsket |
| `@OPT-BEH-BEH-019` | I fs-admin vises et automatisk grunnlag som valgt, så et klikk fjerner det; å «velge» det samme grunnlaget går bare via API-et | annet | `ADMIN/GrunnlagCard/GrunnlagCard.tsx:107-115` | uklart om ønsket |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | 0 av 7 | 7 av 29 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | !3193 feat(soknadsbehandling): vis søkerens elektroniske vitnemål (`opptak/vise-elektroniske-vitnemal`) | åpen | `@OPT-BEH-BEH-019` | 0/29 | usikker kobling; viser vitnemålene, uten valg av vitnemål |
| `fs-plattform` | `mahj/STEK-585` | branch uten MR | – | 0/29 | bare lokal; aldersfilter på kvoter |
| `fs-plattform` | `mahj/STEK-588` | branch uten MR | – | 0/29 | bare lokal; endringslogg for kvoteplassering |
| `fs-plattform` | `mahj/STEK-511` | branch uten MR | – | 0/29 | usikker kobling; bare lokal, gjelder søknadsmangler |

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

- `@OPT-BEH-BEH-019` — Automatisk grunnlag (`@draft`, 17/29 funnet) — 10 ikke funnet, 2 usikker; brukeren har valgt å beholde `@draft` til kravet er validert

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-019` | Automatisk grunnlag | `@draft` | 17/29 | 10 ikke funnet, 2 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Tilleggspoeng ved manuelt grunnlag:** når saksbehandleren legger til grunnlaget, regnes ikke alders- og kjønnspoeng ut (`SAK/PoengRadOppdateringService.java:115-131`). Det kan bare skje ved å trykke «Behandle automatisk» etterpå (feature-flagget `automatisk-soknadsbehandling-trigger`). Samme avvik i `@OPT-BEH-BEH-028`.
- **Vitnemål og kompetansebevis, og valgt vitnemål:** samme avvik som i `@OPT-BEH-BEH-018` og `@OPT-BEH-BEH-020` (`SGS:371-376,110-114`).
- **fs-admin viser ikke at grunnlaget er satt automatisk:** `status_automatisk_utregnet` og `merknad_automatisk` er lagret, men ikke eksponert i `SCHEMA/regelverk/kvalifisering.graphqls:143-153`.
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Flere grunnlag passer like godt» — Ny stack velger grunnlaget med lavest kode alfabetisk, og logger en advarsel. Er det ønsket, eller skal ingen settes?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Grunnlag fra utdanningstilbudet når søknadsalternativet opprettes» — Skal «Aut.kvalgrunnlag» fra FS-klienten videreføres?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Automatikken setter ikke et grunnlag som saksbehandleren har fjernet» — Skal fjerningen låse saken, så grunnlaget holdes borte?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Automatikken erstatter grunnlaget når søkeren passer til et annet» — Skal det nye erstatte det gamle?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Gjøre søknaden tilgjengelig for automatikken igjen» — Trengs det?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Grunnlag utenfor aldersgrensen kan ikke velges manuelt» — Skal valget hindres (STEK-583)?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` «Opptaket mangler dato for aldersberegning» — Skal grunnlag med aldersgrense heller filtreres bort, så de ikke kan velges?
- **Åpent spørsmål:** `@OPT-BEH-BEH-019` (egenskapen) — Skal grunnlaget ligge på saken eller på søknaden? Skal et studieønske som fjernes, også fjerne grunnlaget det ga (STEK-505)?
- **Ikke sjekket:** tilgang og datakonsistens. Finnerne og kontrollørene fikk ikke denne sjekken i denne kjøringen.
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-019` bygger på `@OPT-BEH-BEH-015` (`@planned`) og `@OPT-OVO-FRI-001` (`@in-progress`)
- **Forrige rapport:** `verify-automatisk_grunnlag-2026-10-27-1235.md` er slettet etter ønske fra brukeren (én verify-fil per krav).
