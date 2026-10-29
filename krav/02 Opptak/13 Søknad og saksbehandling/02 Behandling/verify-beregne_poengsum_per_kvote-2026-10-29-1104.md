# Verifisering: beregne_poengsum_per_kvote.feature

- **Dato:** 2026-10-29 11:04
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_poengsum_per_kvote.feature` (1 feature-filer)
- **Kode:** `fs-plattform` (origin/main, lest uten å bytte fra den utsjekkede branchen mahj/STEK-632, oppdatert), `fs-admin` (main, e7c91f629, oppdatert)
- **Åpne MR-er:** 3 MR-er i fs-admin, 0 i fs-plattform (0 med kode for kravene)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `PSS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/PoengsumService.java`
- `PBS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/PoengberegningService.java`
- `PRS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/PropageringService.java`
- `KSV` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/KvotesumV2Service.java`
- `OCN` = `fs-admin/src/domains/soknadsbehandling/features/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx`

## Oppsummering

- Scenarioer: 12 funnet, 1 ikke funnet, 0 usikker, av 13
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | `@OPT-REG-KVO-001` Kvoter i regelverket | 1 | `@implemented` | – | Regel: Poengsummen regnes ut med poengformelen til kvotetypen |
| `@OPT-BEH-BEH-031` | `@OPT-REG-RAN-002` Poengberegning | 1 | `@implemented` | – | Regel: Poengsummen regnes ut med poengformelen til kvotetypen |

Avhengigheter: 2 på nivå 1, 0 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | Poengsum for grunnlaget kvoten er koblet til | funnet | `PSS:61-68` — kvotene søkeren skal plasseres i (`SKAL_KVOTEPLASSERES`, `ER_AKTIV`); `PSS:115`, `PSS:334-375` — gyldige kombinasjoner av kvote og grunnlag fra `kvotetype_grunnlag`; `PSS:137-183` — én poengsum per kvotetype og grunnlag |
| `@OPT-BEH-BEH-031` | Grunnlag kvoten ikke er koblet til, gir ingen poengsum i kvoten | funnet | `PBS:139-142` — kombinasjoner som ikke er koblet i `kvotetype_grunnlag`, hoppes over og regnes aldri ut |
| `@OPT-BEH-BEH-031` | Kvote søkeren ikke er plassert i, gir ingen poengsum | funnet | `PSS:61-68` — bare kvoter med `SKAL_KVOTEPLASSERES` og `ER_AKTIV`; `PBS:342` — bare formlene til de kvotetypene |
| `@OPT-BEH-BEH-031` | Poengsummen følger poengformelen til kvotetypen | funnet | `PBS:328-361` — poengformelen til kvotetypen (`POENGFORMEL_KODE_DEFAULT`); `PBS:144-150` — `PoengberegningEvaluator.regnUt` med formelen og søkerens poeng |
| `@OPT-BEH-BEH-031` | Grunnlag søkeren ikke er kvalifisert på, gir ingen poengsum | funnet | `PSS:128`, `PSS:163-166` — grunnlag som ikke er kvalifisert, hoppes over; `PSS:294-307` — `er_kvalifisert` fra `sak_kvalifikasjonsgrunnlag` |
| `@OPT-BEH-BEH-031` | Poengsummen regnes ut på nytt når <endring> | funnet | `PRS:105-121` grunnlaget, `PRS:67-70` poengene, `PRS:77-85` kravelementene og `PRS:58-61` kvoteplasseringen kaller alle `oppdaterPoengsumIsolert` (`PRS:183-194`), som regner ut poengsummen (`PRS:187`) |
| `@OPT-BEH-BEH-031` | Uendret poengsum gir ikke nytt innslag i endringsloggen | funnet | `PSS:191-231` — bare endrede rader skrives (`compareTo` på `PSS:215`); `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V291__saksbehandling_skjema.sql:1498` — endringsloggen er audit-triggeren på `sak_poengsum` |
| `@OPT-BEH-BEH-031` | Poengsummen i de andre kvotene regnes ut når én kvote feiler | funnet | `PBS:152-177` — feilen i én kombinasjon fanges og logges, og de andre kombinasjonene beregnes |
| `@OPT-BEH-BEH-031` | Poengtypen viser hvorfor poengsummen ikke kan regnes ut | ikke funnet | `PBS:175-176`, `PBS:196-251` — årsaken skrives til `merknad_automatisk` på poengraden, og `poeng.graphqls:99` eksponerer `Poeng.merknadAutomatisk`, men bare når poengtypen har minimum over 0 (`PoengberegningEvaluator.java:194-198`). fs-admin viser den ikke: `PoengberegningCard.tsx:15-48` henter bare `merknad`, og `merknadAutomatisk` brukes bare i `KvoteplasseringCard.tsx` — søkt etter «merknadAutomatisk», «automatiskMerknad», «Poengberegning feilet» i fs-admin og i åpne MR-er |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når søkeren ikke er plassert i noen kvote | funnet | `PSS:70-73`, `PSS:378-384` — alle poengsummene slettes når søkeren ikke har noen kvote |
| `@OPT-BEH-BEH-031` | Poengsummene fjernes når søknaden ikke har noe grunnlag | funnet | `PSS:86-95` — alle poengsummene slettes når saken ikke har rangeringsgrunnlag; `PRS:114-119` |
| `@OPT-BEH-BEH-031` | Den høyeste poengsummen i kvoten vises | funnet | `KSV:277-281`, `KSV:321-340` — den høyeste poengsummen per kvotetype; `OCN:52-58`, `OCN:173-183`, `OCN:287` — vises i poengtabellen i oppsummeringen av saken |
| `@OPT-BEH-BEH-031` | Søknadsalternativ søkeren ikke er kvalifisert til, viser ingen poengsum | funnet | `KSV:52-62`, `KSV:227-230` — søknadsalternativ søkeren ikke er kvalifisert til, får ingen poengsum |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert. Scenarioene som bare finnes her, står som `ikke funnet` i `## Scenarioer`, med `finnes i MR !<iid>` i beviset.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | !3267 (`lars/e2e-utdanningstilbud-krav`) | utkast | – | 0/13 | usikker kobling; tester for utdanningstilbud |
| `fs-admin` | !3226 (`patsle/STEK-489-feat-tidlig-opptak-plasstildeling`) | åpen | – | 0/13 | usikker kobling; tidlig opptak i plasstildelingen |
| `fs-admin` | !3117 (`maciek/plasstildeling-feat-runder-oversikt`) | utkast | – | 0/13 | usikker kobling; plasstildeling |

## Kontroll

Kontrollen endret ingen resultater.

Kontrollen rettet linjenumrene i bevisene for PBS, PRS og `skrivDiff`, og fant at merknaden bare skrives når poengtypen har minimum over 0.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-031` — Beregne poengsum per kvote (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/beregne_poengsum_per_kvote.feature`, `@draft` → `@in-progress`, 12/13 funnet) — `@implemented` på: Regel: Søkeren får en poengsum for hver kvote og hvert grunnlag kvoten er koblet til (linje 22), Regel: Poengsummen regnes ut med poengformelen til kvotetypen (linje 45), Regel: Bare grunnlag søkeren er kvalifisert på, gir poengsum (linje 57), Regel: Poengsummen regnes ut på nytt når det den bygger på, endres (linje 70), Regel: Saksbehandleren ser den høyeste poengsummen per kvote for hvert søknadsalternativ (linje 115), Scenario: Poengsummen i de andre kvotene regnes ut når én kvote feiler, Scenario: Poengsummene fjernes når søkeren ikke er plassert i noen kvote, Scenario: Poengsummene fjernes når søknaden ikke har noe grunnlag

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-031` | Beregne poengsum per kvote | `@draft` | 12/13 | 1 ikke funnet, 0 usikker. Brukeren valgte å beholde `@draft` |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Merknaden skrives ikke alltid:** når poengtypen ikke har minimum over 0, regnes en manglende verdi som 0, og det skrives ingen merknad (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/PoengberegningEvaluator.java:194-198`).
- **Åpent spørsmål:** `@OPT-BEH-BEH-031` «Bare grunnlag søkeren er kvalifisert på, gir poengsum» — Koden regner bare ut poengsum for grunnlag søkeren er kvalifisert på for kompetanseregelverket. Er det ønsket, eller skal søkeren få poengsum uansett, og kvalifiseringen avgjøre om poengsummen brukes?
- **Ikke sjekket:** min-kompetanse er ikke blant kodeklonene. Kravet gjelder saksbehandlingen, så det har ingen betydning for resultatet.
