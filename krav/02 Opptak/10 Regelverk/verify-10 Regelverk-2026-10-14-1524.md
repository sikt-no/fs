# Verifisering: 10 Regelverk

- **Dato:** 2026-10-14 15:24
- **Krav:** `krav/02 Opptak/10 Regelverk/` (9 feature-filer)
- **Kode:** `fs-plattform` (main, `9f36cda8df`, oppdatert), `fs-admin` (main, `4336963fe`, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft`, `@planned` og `@openquestion`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `P/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `P-skjema/` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/`
- `P-mig/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `A/` = `fs-admin/src/domains/regelverk/features/`

## Oppsummering

- Scenarioer: 49 funnet, 9 ikke funnet, 19 usikker, av 77
- Krav levert (status satt til `@implemented`): 8
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | Opprette regelverkssamling | usikker | `P/regelverk/RegelverksamlingService.java:25-41` lagrer kode, eier og navn på fire språk, men `A/Regelverksamling/components/OpprettRegelverksamlingDialog.tsx:73,128-140` har bare navn på bokmål |
| `@OPT-REG-SAM-001` | Regelverkssamling eies av organisasjonen som opprettet den | funnet | `P-mig/V196__regelverksamlingRLS.sql:16-49` krever MODIFISERE_REGELVERK på eierorganisasjonen, og `A/Regelverksamling/components/RegelverksamlingDetailActions.tsx:31-37` skjuler Rediger og Slett for andre |
| `@OPT-REG-SAM-001` | Kopiere regelverkssamling | funnet | `P/regelverk/KopierRegelverksamlingService.java:69-97` kopierer samlingen med innhold til ny nøkkel, og `A/Regelverksamling/components/KopierRegelverksamlingDialog.tsx:170-183` |
| `@OPT-REG-SAM-001` | Deaktivere regelverkssamling | ikke funnet | Bryteren finnes (`A/Regelverksamling/components/RedigerRegelverksamlingDialog.tsx:116-123`), men inaktive samlinger kan velges for nye opptak (`fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSettings/OpptakSettings.tsx:43`), og backend sjekker ikke `er_aktiv` |
| `@OPT-REG-SAM-001` | Slette regelverkssamling som ikke er i bruk | funnet | `P-skjema/regelverk/regelverk.graphqls:25` og `A/Regelverksamling/components/SlettRegelverksamlingDialog.tsx:66-76` |
| `@OPT-REG-SAM-001` | Kan ikke slette regelverkssamling som er i bruk | ikke funnet | Sletting stoppes av FK (`P-mig/V280__opptak_v2_skjema.sql:250-253`), men `SlettRegelverksamlingDialog.tsx:77-79` viser bare en generell feil — søkt etter «brukesAvOpptak», «cannotDeleteActive», «i bruk» i fs-admin |
| `@OPT-REG-SAM-001` | Flerspråklig navn | ikke funnet | API-et lagrer fire språk (`P/regelverk/RegelverksamlingService.java:82-110`), men fs-admin har bare bokmål i opprett, rediger og kopier — søkt etter «nn:», «AlleSprak», «nynorsk», «samisk» |
| `@OPT-REG-SAM-001` | Se innholdet i en regelverkssamling | funnet | `A/DashboardView/components/RegelverkSectionTabs/RegelverkSectionTabs.tsx:13,30-92` har faner for alle fem delene |
| `@OPT-REG-KRA-001` | Opprette kompetanseregelverk | funnet | `P/regelverk/kvalifisering/KompetanseregelverkService.java:45-74` og `A/Kompetanseregelverk/components/BasicInfoCard/BasicInfoCard.tsx:91-136` |
| `@OPT-REG-KRA-001` | Flerspråklig beskrivelse og forklaring | funnet | `BasicInfoCard.tsx:75-156` har én fane per språk, lagret i `KompetanseregelverkService.java:511-595` |
| `@OPT-REG-KRA-001` | Kompetansekrav med flere grunnlag | funnet | `A/Kompetanseregelverk/Kompetanseregelverk.tsx:348-363` og `KompetansekravItemEdit.tsx:232-239` (flere grunnlag) |
| `@OPT-REG-KRA-001` | Alle krav må oppfylles (OG-logikk) | funnet | «og» i uttrykket gir `kreverAlle=true` (`parseExpressionToKompetansekrav.ts:335`), evaluert i `P/regelverk/kvalifisering/KvalifiseringEvaluator.java:132-175` |
| `@OPT-REG-KRA-001` | Ett av kravene er tilstrekkelig (ELLER-logikk) | funnet | «eller» gir `kreverAlle=false` (`parseExpressionToKompetansekrav.ts:341,347,389`), `KvalifiseringEvaluator.java:301-305` |
| `@OPT-REG-KRA-001` | Opprette kompetanseregelverk med alternative tilleggskrav | funnet | `parseExpressionToKompetansekrav.ts:286-348` og `KompetanseregelverkService.java:419-496` |
| `@OPT-REG-KRA-001` | Sette karakterkrav på kravelement | usikker | Standpunkt- og eksamenskrav finnes i API-et (`P-skjema/regelverk/kompetanseregelverk.graphqls:181-188`), men fs-admin har bare resultatkrav (`mapParsedToKravStructure.ts:36-37`), og vurderingen bruker bare resultatkrav (`KvalifiseringEvaluator.java:203-213`) |
| `@OPT-REG-KRA-001` | Sette gjennomsnittskrav | funnet | `NORSK[3]` gir resultatkrav, og NORSK regnes som snitt (`P/autosak/kontrollmotor/Kravelementer.java:1612-1640`) |
| `@OPT-REG-KRA-001` | Sette GSK-krav | funnet | `KompetansekravItemEdit.tsx:246-253`, `KompetanseregelverkService.java:257-259`, `KvalifiseringEvaluator.java:351-354` |
| `@OPT-REG-KRA-001` | Deaktivere kompetanseregelverk | funnet | `BasicInfoCard.tsx:129-136`, og bare aktive regelverk kan velges (`useRegelverkOptions.ts:53`) |
| `@OPT-REG-KRA-001` | Slette kompetanseregelverk som ikke er i bruk | funnet | `KompetanseregelverkService.java:229-245` og `Kompetanseregelverk.tsx:268-292` |
| `@OPT-REG-KRA-001` | Kan ikke slette kompetanseregelverk som er i bruk | funnet | `KompetanseregelverkIBrukException` (`KompetanseregelverkService.java:242-243`) gir «Regelverket er i bruk og kan ikke slettes» (`Kompetanseregelverk.tsx:279-281`) |
| `@OPT-REG-KRA-002` | Opprette fagkrav-kravelement | funnet | `P/regelverk/kvalifisering/KravelementService.java:31-75` og `A/Kravelementer/KravelementDetails/KravelementDetails.tsx:259-296,368-377` |
| `@OPT-REG-KRA-002` | Opprette annet kravelement | funnet | Kravtypen ANNET (`P-mig/V14__regelverk_grunndata.sql:13`), valgt i `KravelementDetails.tsx:75-83` |
| `@OPT-REG-KRA-002` | Markere kravelement som kjernefag | usikker | `erKjernefag` finnes i API-et (`KravelementService.java:48`), men valget er fjernet fra skjemaet i fs-admin (endringsloggen) |
| `@OPT-REG-KRA-002` | Sette vitnemålskravkoder | usikker | Feltet finnes (`KravelementDetails.tsx:379-389`), men «KL» avvises fordi kontrollmotoren ikke kjenner koden (`KravelementService.java:146-149`) |
| `@OPT-REG-KRA-002` | Flerspråklig navn på kravelement | funnet | `KravelementDetails.tsx:288-366` og `KravelementService.java:162-197` |
| `@OPT-REG-KRA-002` | Gjenbruke kravelement i flere kompetanseregelverk | funnet | `KompetanseregelverkService.java:480-482` og `KompetansekravItemEdit.tsx:30-47,263-267` |
| `@OPT-REG-KRA-002` | Slette kravelement | funnet | `KravelementService.java:130-143` og `KravelementDetails.tsx:182-202` |
| `@OPT-REG-RAN-001` | Opprette rangeringsregelverk | funnet | `P/opptak/RangeringsregelverkMutations.java:36-65` og `A/Rangeringsregelverk/components/RangeringBasicInfoCard/RangeringBasicInfoCard.tsx:65-106` |
| `@OPT-REG-RAN-001` | Koble grunnlag til poengtyper | funnet | `RangeringsregelverkMutations.java:127-139` og `PoengtypeRangering.tsx:85-106` |
| `@OPT-REG-RAN-001` | Flerspråklig beskrivelse | usikker | API-et lagrer fire språk (`RangeringsregelverkMutations.java:142-147`), men fs-admin har bare bokmål (`RangeringBasicInfoCard.tsx:76-93`) |
| `@OPT-REG-RAN-001` | Deaktivere rangeringsregelverk | funnet | `RangeringBasicInfoCard.tsx:98-106`, og bare aktive kan velges (`fs-admin/src/domains/opptak/features/UtdanningstilbudDetails/UtdanningstilbudDetails.tsx:200-203`) |
| `@OPT-REG-RAN-001` | Slette rangeringsregelverk | funnet | `P-skjema/regelverk/regelverk.graphqls:37` og `A/Rangeringsregelverk/components/Rangeringsregelverk/Rangeringsregelverk.tsx:218-229` |
| `@OPT-REG-RAN-001` | Kan ikke slette rangeringsregelverk som er i bruk | ikke funnet | FK stopper slettingen (`P-mig/V188__regelverksamling_rangeringsregelverk.sql:376-388`), men `Rangeringsregelverk.tsx:230-238` viser bare en generell feil. `cannotDeleteActive` finnes, men brukes ikke |
| `@OPT-REG-RAN-002` | Opprette poengklasse | usikker | `defaultVerdi` finnes i API-et (`P/regelverk/poeng/PoengklasseService.java:39`), men ikke i `A/Poengklasser/PoengklasseDetails/PoengklasseDetails.tsx:158-164` |
| `@OPT-REG-RAN-002` | Poengklasse med flerspråklig navn | funnet | `PoengklasseDetails.tsx:276-331` og `PoengklasseService.java:121-125` |
| `@OPT-REG-RAN-002` | Opprette poengvariant | funnet | `P/regelverk/poeng/PoengvariantService.java:26-47` og `A/Poengvarianter/PoengvariantDetails/PoengvariantDetails.tsx:269-300` |
| `@OPT-REG-RAN-002` | Opprette poengtype | funnet | `P/regelverk/poeng/PoengtypeService.java:28-49` og `A/Poengtyper/PoengtyperDetails/PoengtyperDetails.tsx:384-414,529-600` |
| `@OPT-REG-RAN-002` | Poengtype med algoritme | funnet | `PoengtyperDetails.tsx:427-436` og `P/regelverk/poeng/AutomatiskPoengberegningService.java:156-160` |
| `@OPT-REG-RAN-002` | Poengtype med poengtrinn | funnet | `PoengtyperDetails.tsx:547-560` og `P/regelverk/poeng/PoengAvrunder.java:22-30` |
| `@OPT-REG-RAN-002` | Opprette poengformel | funnet | `P/regelverk/poeng/PoengformelService.java:27-46` og `A/Poengformler/PoengformelDetails/PoengformelDetails.tsx:191-194` |
| `@OPT-REG-RAN-002` | Ugyldig formeluttrykk avvises | funnet | `A/Poengformler/utils/uttrykk/parser.ts:61-69` gir feil, og `PoengformelDetails.tsx:196,381-385` sperrer lagring (bare i frontend) |
| `@OPT-REG-RAN-002` | Slette poengklasse som ikke er i bruk | funnet | `PoengklasseService.java:100-114` og `PoengklasseDetails.tsx:184-203` |
| `@OPT-REG-RAN-002` | Kan ikke slette poengtype som er i bruk | funnet | `PoengtypeService.java:153-154` og `PoengtyperDetails.tsx:252-256` («Poengtypen er i bruk og kan ikke slettes») |
| `@OPT-REG-RAN-003` | Opprette poenglikhetsregel med loddtrekning | usikker | `P/regelverk/poeng/PoenglikhetService.java:48-91` har upsert, men reglene er globale og ikke i regelverkssamlingen, og fs-admin har ikke noe sted å forvalte dem |
| `@OPT-REG-RAN-003` | Opprette poenglikhetsregel med alder | usikker | Som over |
| `@OPT-REG-RAN-003` | Opprette poenglikhetsregel med søknadstidspunkt | usikker | Som over |
| `@OPT-REG-RAN-003` | Sette rekkefølge med flere kriterier | ikke funnet | Rekkefølgen er hardkodet per kode (`P/plasstildeling/service/UttrekkRangeringsstrategi.java:91-100`) — søkt etter «rekkefolge», «poenglikhet» i begge repoer |
| `@OPT-REG-RAN-003` | Deaktivere poenglikhetsregel | usikker | Bare via API-et (`PoenglikhetService.java:64,74`). fs-admin skjuler inaktive regler på opptaket, men kan ikke deaktivere |
| `@OPT-REG-RAN-003` | Slette poenglikhetsregel | usikker | Bare via API-et (`PoenglikhetService.java:98-125`) |
| `@OPT-REG-KVO-001` | Opprette ordinær kvote | funnet | `P/regelverk/kvotetype/KvotetypeMutations.java:38-55` og `A/Kvoteregelverk/components/KvoteBasicInfoCard/KvoteBasicInfoCard.tsx:141-165` |
| `@OPT-REG-KVO-001` | Opprette førstegangsvitnemålskvote | funnet | Samme kode, SP i `P-mig/V14__regelverk_grunndata.sql:18` |
| `@OPT-REG-KVO-001` | Flerspråklig navn på kvotetype | funnet | `KvotetypeMutations.java:202-210` og `KvoteBasicInfoCard.tsx:83-137` |
| `@OPT-REG-KVO-001` | Sette default poengformel | funnet | `KvotetypeMutations.java:47` og `P/regelverk/poeng/PoengberegningService.java:328-360` |
| `@OPT-REG-KVO-001` | Sette kvoteprioritet | usikker | Backend lagrer og bruker den (`KvotetypeMutations.java:50`, `P/plasstildeling/service/KvoterService.java:96-97`), men fs-admin har ikke feltet på kvotetypen |
| `@OPT-REG-KVO-001` | Sette default plassflyt | usikker | Backend lagrer og bruker den (`KvotetypeMutations.java:49`, `KvoterService.java:88-89`), men fs-admin har ikke feltet på kvotetypen |
| `@OPT-REG-KVO-001` | Koble grunnlag til kvotetype | funnet | `KvotetypeMutations.java:57-62,183-200` og `A/Kvoteregelverk/components/KvoteGrunnlag/KvoteGrunnlag.tsx:94-120` |
| `@OPT-REG-KVO-001` | Aldersgrensen følger grunnlaget | ikke funnet | Kvoteplasseringen leser aldersgrensen på grunnlaget (`P/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:287-361`), men fs-admin lar forvalteren sette en egen aldersgrense på kvotetypen (`KvoteGrunnlag.tsx:127-227`) |
| `@OPT-REG-KVO-001` | Kvotetype uten grunnlag og kvotespørsmål | funnet | `KvoteplasseringGrunnlagService.java:139-153` |
| `@OPT-REG-KVO-001` | Kvoterangering | ikke funnet | Lagres (`KvotetypeMutations.java:46`), men leses ikke av rangeringen — søkt etter «kvoterangering», «KVOTERANGERING», «SPEV», «IH» |
| `@OPT-REG-KVO-001` | Slette kvotetype | funnet | `P-skjema/opptak/kvote.graphqls:42-43` og `A/Kvoteregelverk/Kvoteregelverk.tsx:165-190` |
| `@OPT-REG-KVO-001` | Kan ikke slette kvotetype som er i bruk | ikke funnet | Backend gir `KvotetypeIBrukError`, men `Kvoteregelverk.tsx:173-176` viser bare en generell feil |
| `@OPT-REG-KVO-002` | Opprette kvotespørsmål | funnet | `P/regelverk/kvoteplassering/KvotesporsmalService.java:28-62` og `A/Kvotesporsmal/KvotesporsmalDetails/KvotesporsmalDetails.tsx:164-168` |
| `@OPT-REG-KVO-002` | Flerspråklig kvotespørsmål | funnet | `KvotesporsmalService.java:127-166` og `KvotesporsmalDetails.tsx:267-368` |
| `@OPT-REG-KVO-002` | Tilgjengelige algoritmer | usikker | ER_KVINNE og ER_MANN finnes (`P-mig/V297__seed_kvotesporsmal_kjonnsalgoritmer.sql:7-16`), men nedtrekket viser kodene (`KvotesporsmalDetails.tsx:91-94`) |
| `@OPT-REG-KVO-002` | Koble kvotespørsmål til en algoritme | funnet | `KvotesporsmalService.java:32-43` og `P/autosak/KvotesporsmalAlgoritmeService.java:64` |
| `@OPT-REG-KVO-002` | Knytte kvotespørsmål til kvotetype | funnet | `KvotetypeMutations.java:64,122-145` og `A/Kvoteregelverk/components/Kvotesporsmal/Kvotesporsmal.tsx:99-110` |
| `@OPT-REG-KVO-002` | Knytte flere kvotespørsmål til samme kvotetype | funnet | `P/saksbehandling/KvotesporsmalSvarService.java:422-433` |
| `@OPT-REG-KVO-002` | Informasjon om automatisk plassering | ikke funnet | Ingen tekst på kvotetypen (`Kvotesporsmal.tsx:146-168`). Teksten finnes bare i søknadsbehandlingen (`soknadsbehandling.json:250`) |
| `@OPT-REG-KVO-002` | Slette kvotespørsmål | funnet | `KvotesporsmalService.java:102-116` og `KvotesporsmalDetails.tsx:186-214` |
| `@OPT-REG-GRU-001` | Opprette grunnlag for generell studiekompetanse | usikker | `P/opptak/GrunnlagMutations.java:29-61` lagrer kode, flagg og beskrivelse, men `A/Grunnlag/GrunnlagDetails/GrunnlagDetails.tsx:267-333` har ikke beskrivelse og bare navn på bokmål |
| `@OPT-REG-GRU-001` | Opprette grunnlag for forkurs | usikker | Som over |
| `@OPT-REG-GRU-001` | Opprette grunnlag for realkompetanse | usikker | Skjul poeng finnes (`GrunnlagParametreFields.tsx:148-154`). Beskrivelse mangler i fs-admin |
| `@OPT-REG-GRU-001` | Grunnlag som brukes i kvalifisering men ikke poengberegning | usikker | API-et har egne flagg, men fs-admin har én avkrysning for begge (`GrunnlagParametreFields.tsx:131-139`) |
| `@OPT-REG-GRU-001` | Flerspråklig grunnlag | usikker | API-et har fire språk (`GrunnlagMutations.java:110-114`), fs-admin bare bokmål (`GrunnlagDetails.tsx:287-299`) |
| `@OPT-REG-GRU-001` | Grunnlag brukt på tvers | funnet | `GrunnlagBruk` (`P-skjema/regelverk/regelverk.graphqls:346-361`), og valgt i kompetansekrav, rangering og kvotetype i fs-admin |
| `@OPT-REG-GRU-001` | Slette grunnlag som ikke er i bruk | funnet | `regelverk.graphqls:30,425-432` og `GrunnlagDetails.tsx:166-203` |
| `@OPT-REG-GRU-001` | Se tilgjengelige mangelkoder | funnet | `P-skjema/saksbehandling/mangel.graphqls:2-3` og `fs-admin/src/app/regelverk/regelverksamlinger/[regelverksamlingId]/mangelkoder/page.tsx` |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | Deaktivere regelverkssamling | usikker | ikke funnet | `OpptakSettings.tsx:43` filtrerer ikke på aktiv, og ingen kode sjekker `er_aktiv` når samling velges |
| `@OPT-REG-SAM-001` | Kan ikke slette regelverkssamling som er i bruk | usikker | ikke funnet | Ingen melding om at samlingen er i bruk, bare en generell feil |
| `@OPT-REG-SAM-001` | Flerspråklig navn | usikker | ikke funnet | Brukeren kan bare oppgi bokmål i fs-admin |
| `@OPT-REG-RAN-001` | Kan ikke slette rangeringsregelverk som er i bruk | usikker | ikke funnet | `cannotDeleteActive` finnes, men brukes ikke i `Rangeringsregelverk.tsx` |
| `@OPT-REG-KVO-001` | Aldersgrensen følger grunnlaget | usikker | ikke funnet | «Men»-steget er ikke oppfylt: aldersgrensen kan fortsatt settes på kvotetypen |
| `@OPT-REG-KVO-001` | Kan ikke slette kvotetype som er i bruk | usikker | ikke funnet | Brukeren får bare en generell feil |

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | Regelverkssamling | `01 Regelverkssamling/regelverkssamling.feature` | `@draft` | 6/6 |
| `@OPT-REG-KRA-001` | Kompetanseregelverk | `02 Krav/kompetanseregelverk.feature` | `@draft` | 12/12 |
| `@OPT-REG-KRA-002` | Kravelement | `02 Krav/kravelement.feature` | `@draft` | 6/6 |
| `@OPT-REG-RAN-001` | Rangeringsregelverk | `03 Rangering/rangeringsregelverk.feature` | `@draft` | 5/5 |
| `@OPT-REG-RAN-002` | Poengberegning | `03 Rangering/poengberegning.feature` | `@draft` | 10/10 |
| `@OPT-REG-KVO-001` | Kvotetype | `04 Kvoter/kvoterregelverk.feature` | `@draft` | 9/9 |
| `@OPT-REG-KVO-002` | Kvotespørsmål | `04 Kvoter/kvotesporsmal.feature` | `@draft` | 7/7 |
| `@OPT-REG-GRU-001` | Grunnlag og mangelkoder | `05 Grunnlag/grunnlag.feature` | `@draft` | 7/7 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-REG-RAN-003` | Poenglikhetsregel | `@draft` | 0/6 | 1 ikke funnet, 5 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Kravene er justert etter koden før levering:** Brukeren valgte å skrive kravene om til det koden gjør (retrofitting). Tallene under `## Levert` gjelder scenarioene etter justeringen. Fjernet: navn og beskrivelse på flere språk for regelverkssamling, rangeringsregelverk og grunnlag, kjernefag på kravelement, og kvoteprioritet og default plassflyt på kvotetypen. Justert: navn bare på bokmål, generell feilmelding ved sletting av noe som er i bruk, resultatkrav i stedet for standpunkt- og eksamenskrav, «FFMAT» i stedet for «KL», én avkrysning for kvalifisering og rangering, ingen default-verdi på poengklasse, algoritmekodene i nedtrekket, og aldersgrensen uten «Men»-steget.
- **Videre ønsker (`@draft @openquestion`) i leverte krav:** deaktivering av regelverkssamling (har ingen virkning i dag), de fire rangeringsmetodene på kvotetypen (kvoterangeringen brukes ikke, og IH betyr noe annet i kodeverket), og informasjon om automatisk plassering på kvotetypen.
- **Poenglikhetsregler (#580):** reglene er faste koder i koden, globale, uten sted å forvalte dem i fs-admin, og rekkefølgen er hardkodet (`P/plasstildeling/service/UttrekkRangeringsstrategi.java:91-100`). Feltet for poenglikhetsregel på rangeringsregelverket er bare `@deprecated` (`P-skjema/regelverk/regelverk.graphqls:287,297,310`), og skrives fortsatt (`P/opptak/RangeringsregelverkMutations.java:44-45,77-78`).
- **Tekster som finnes, men ikke brukes:** `cannotDeleteActive` for rangeringsregelverk (`fs-admin/src/common/messages/nb/regelverk.json:965`). Meldingen om at noe er i bruk, mangler også for regelverkssamling og kvotetype.
- **Data kan forsvinne ved lagring i fs-admin:** default-verdi på poengklasse (`P/regelverk/poeng/PoengklasseService.java:77-85`) og kvoteprioritet og default plassflyt på kvotetypen (`P/regelverk/kvotetype/KvotetypeMutations.java:83-84`) settes til null når skjemaet lagres uten feltene (ikke kjørt).
- **Poengformler valideres bare i frontend:** `P/regelverk/poeng/PoengformelService.java:35-39` sjekker ikke uttrykket.
