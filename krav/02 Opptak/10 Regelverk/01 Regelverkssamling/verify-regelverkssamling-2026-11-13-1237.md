# Verifisering: Regelverkssamling

- **Dato:** 2026-11-13 12:37
- **Krav:** `krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (origin/main, 6e691fe635, lest direkte fra origin/main, klonen er 265 bak), `fs-admin` (origin/main, 2ab5f3743, lest direkte fra origin/main, klonen står på en annen branch)
- **Repoer:** P = fs-plattform, A = fs-admin · ✓ funnet, ✗ mangler, ~ delvis eller usikker, – ikke relevant
- **Åpne MR-er:** 1 MR i fs-plattform, 3 i fs-admin (0 med kode for kravene)
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `RS` = `fs-admin/src/domains/regelverk/features/Regelverksamling`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `GQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/regelverk/regelverk.graphqls`
- `REG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk`

## Oppsummering

Tallene for hele kjøringen, regnet ut fra tabellene under.

- Scenarioer: 10 funnet, 1 ikke funnet, 3 usikker, av 14
- Mangler: fs-plattform 1 scenarioer, fs-admin 4 (3 usikker)
- Forslag: 0 kan leveres, 3 delvis levert, 0 kan slettes, 2 kan leveres når det er avklart, 1 blir stående
- Tilgang og datakonsistens: 6 stemmer, 0 avviker, 0 ikke funnet, 4 usikker, av 10
- Regler i koden uten scenario: 18
- Åpne spørsmål: 1 regler og 1 scenarioer i gating-settet, 0 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 3 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

Hva som kan endres i kravene, ut fra resultatene. *Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-REG-SAM-001` — Regel: Regelverkssamlingene kan filtreres på organisasjonen som eier dem (`krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature:58`): `@planned` fjernes, 2/2 funnet `[P ✓ · A ✓]`
- `@OPT-REG-SAM-001` — Scenario: Kan ikke opprette regelverkssamling for en annen organisasjon (`krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature:81`): `@planned` fjernes, 1/1 funnet `[P ✓ · A ✓]`
- `@OPT-REG-SAM-001` — Scenario: Kan ikke kopiere regelverkssamling til en annen organisasjon (`krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature:102`): `@planned` fjernes, 1/1 funnet `[P ✓ · A ✓]`

**Kan leveres når det er avklart**

- `@OPT-REG-SAM-001` — Regel: Opptaksforvaltere, saksbehandlere og opptaksinformatører ser regelverkssamlingene ved alle organisasjoner (`krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature:13`): kan få `@implemented` hvis saksbehandler og opptaksinformatør har FS-ADMIN_SE_REGELVERK i rollekatalogen — «Se en regelverkssamling som en annen organisasjon eier» (`krav/…/regelverkssamling.feature:15`) er `usikker` `[P ✓ · A ~]`: API-et lar alle innloggede lese (`MIG/V221__regelverksamling_rls.sql:7-10`), og fs-admin krever SE eller MODIFISERE_REGELVERK (`fs-admin/src/app/regelverk/regelverksamlinger/layout.tsx:13`) · mangler i fs-admin (1)
- `@OPT-REG-SAM-001` — Regel: Bare opptaksforvalter oppretter, endrer, kopierer og sletter regelverkssamlinger (`krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature:29`): kan få `@implemented` hvis saksbehandler og opptaksinformatør har SE_REGELVERK og ikke MODIFISERE_REGELVERK i rollekatalogen — «Saksbehandler og opptaksinformatør ser regelverkssamlingen, men endrer den ikke» (`:31`) og «Bare opptaksforvalter kan opprette en regelverkssamling» (`:42`) er `usikker` `[P ✓ · A ~]`: koden skiller på SE og MODIFISERE (`RS/components/RegelverksamlingDetailActions.tsx:31-40`, `RS/RegelverksamlingOverview.tsx:34-39`, `MIG/V196__regelverksamlingRLS.sql:16-50`) · mangler i fs-admin (2)

**Blir stående**

- `@OPT-REG-SAM-001` — Regel: En regelverkssamling kan deaktiveres (`@draft @openquestion`, 0/1 funnet): samlingen kan settes inaktiv, men kan fortsatt velges for nye opptak (`fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSettings/RegelverksamlingCombobox/RegelverksamlingCombobox.tsx:19-35`), slik det åpne spørsmålet sier · mangler i fs-plattform (1), fs-admin (1)

## Endringer

Det som er endret i kravfilene og i resultatet: i kjøringen (det sikre, når brukeren sa ja) og i gjennomgangen av rapporten.

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | Regel: Regelverkssamlingene kan filtreres på organisasjonen som eier dem | `@planned` fjernet | ja i kjøringen |
| `@OPT-REG-SAM-001` | Scenario: Kan ikke opprette regelverkssamling for en annen organisasjon | `@planned` fjernet | ja i kjøringen |
| `@OPT-REG-SAM-001` | Scenario: Kan ikke kopiere regelverkssamling til en annen organisasjon | `@planned` fjernet | ja i kjøringen |

## Oversikt per krav

Hvor mange scenarioer som er funnet i hvert krav, og hvor mange som mangler i hvert repo.

| Feature-ID | Egenskap | Funnet | Mangler i P | Mangler i A | Hva som gjenstår |
| --- | --- | --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | Regelverkssamling | 10/14 | 1 | 4 (3 usikker) | Rollene til saksbehandler og opptaksinformatør i rollekatalogen, og deaktiveringen |

Mangler: fs-plattform 1 scenarioer i 1 krav, fs-admin 4 i 1 krav (3 usikker). 0 av 1 krav er funnet i alle repoene.

`Funnet` er scenarioene som er funnet i alle repoene de gjelder, av alle scenarioene i kravet. `Mangler i P` og `A` er scenarioene som ikke er funnet i repoet (`ikke funnet` eller `usikker`). Et scenario som mangler i flere repoer, telles i hvert av dem. `–` betyr at ingen scenarioer i kravet gjelder repoet.

## Scenarioer

Resultatet for hvert scenario i gating-settet etter kontrollen, med beviset i koden. Tallene i rapporten regnes ut herfra, og FS Kravforvaltning leser tabellen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | Deaktivere regelverkssamling | ikke funnet | P ~ · A ~ — samlingen kan settes inaktiv (`RS/components/RedigerRegelverksamlingDialog.tsx:116-123`, `REG/RegelverksamlingService.java:48-59`), men valget av samling for et opptak sender ikke `erAktiv` (`fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSettings/RegelverksamlingCombobox/RegelverksamlingCombobox.tsx:19-35`, `:99-104`), selv om API-et har filteret (`GQL:91-92`); søkt etter «erAktiv», «aktiv» i combobox-mappa og i MR !3430 og !3384 |
| `@OPT-REG-SAM-001` | Se en regelverkssamling som en annen organisasjon eier | usikker | P ✓ · A ~ — `MIG/V221__regelverksamling_rls.sql:7-10` (SELECT for alle innloggede), `RS/hooks/useGetRegelverksamlinger.tsx:11-14`; sidene krever FS-ADMIN_SE_REGELVERK eller MODIFISERE_REGELVERK (`fs-admin/src/app/regelverk/regelverksamlinger/layout.tsx:13`). Om saksbehandler og opptaksinformatør har SE_REGELVERK, står i rollekatalogen i tilgangsstyringen, ikke i koden. OPPTAK_INNSYN finnes ikke i `fs-admin/src/common/types/generated/tilgangsroller.ts:110-131` |
| `@OPT-REG-SAM-001` | Saksbehandler og opptaksinformatør ser regelverkssamlingen, men endrer den ikke | usikker | P ✓ · A ~ — `RS/components/RegelverksamlingDetailActions.tsx:31-40` (Valg bare med MODIFISERE hos eieren, ellers lesevisning), `MIG/V196__regelverksamlingRLS.sql:16-50`. Avhenger av at rollene har SE og ikke MODIFISERE, som står i rollekatalogen. Finneren satte A ✓, kontrollen A ~ |
| `@OPT-REG-SAM-001` | Bare opptaksforvalter kan opprette en regelverkssamling | usikker | P ✓ · A ~ — `RS/RegelverksamlingOverview.tsx:34-39`, `MIG/V196__regelverksamlingRLS.sql:16-23`. Samme forbehold om rollekatalogen. Finneren satte A ✓, kontrollen A ~ |
| `@OPT-REG-SAM-001` | Filtrere på organisasjon | funnet | P ✓ · A ✓ — `RS/components/filter/RegelverksamlingOrganisasjonFilter/RegelverksamlingOrganisasjonFilter.tsx:30-57`, `RS/hooks/useGetRegelverksamlinger.tsx:11-14`, `GQL:87-88` |
| `@OPT-REG-SAM-001` | Regelverkssamlingene er sortert etter kode | funnet | P ✓ · A ✓ — `RS/hooks/useGetRegelverksamlingState.tsx:11-14`, `GQL:16`, `:173-175` |
| `@OPT-REG-SAM-001` | Opprette regelverkssamling | funnet | P ✓ · A ✓ — `RS/components/OpprettRegelverksamlingDialog.tsx:73-84`, `REG/RegelverksamlingService.java:25-41` |
| `@OPT-REG-SAM-001` | Kan ikke opprette regelverkssamling for en annen organisasjon | funnet | P ✓ · A ✓ — `RS/hooks/useOrganisasjonerForNyRegelverksamling.ts:35-53`, `RS/components/OpprettRegelverksamlingDialog.tsx:124-138`, `MIG/V196__regelverksamlingRLS.sql:16-23` |
| `@OPT-REG-SAM-001` | Regelverkssamling eies av organisasjonen som opprettet den | funnet | P ✓ · A ✓ — `RS/components/RegelverksamlingDetailActions.tsx:31-40`, `MIG/V196__regelverksamlingRLS.sql:37-41` |
| `@OPT-REG-SAM-001` | Kopiere regelverkssamling | funnet | P ✓ · A ✓ — `RS/RegelverksamlingOverview.tsx:49-57`, `RS/components/KopierRegelverksamlingDialog.tsx:95-115`, `REG/KopierRegelverksamlingService.java:104-111`, `:113-176` |
| `@OPT-REG-SAM-001` | Kan ikke kopiere regelverkssamling til en annen organisasjon | funnet | P ✓ · A ✓ — `RS/components/KopierRegelverksamlingDialog.tsx:80`, `:274-288`, `REG/KopierRegelverksamlingService.java:104-111` |
| `@OPT-REG-SAM-001` | Slette regelverkssamling som ikke er i bruk | funnet | P ✓ · A ✓ — `RS/components/SlettRegelverksamlingDialog.tsx:66-82`, `GQL:25`, `MIG/V381__cascade_delete_for_regelverksamling.sql:5-13` |
| `@OPT-REG-SAM-001` | Kan ikke slette regelverkssamling som er i bruk | funnet | P ✓ · A ✓ — `MIG/V280__opptak_v2_skjema.sql:250-253`, `RS/components/SlettRegelverksamlingDialog.tsx:77-80` |
| `@OPT-REG-SAM-001` | Se innholdet i en regelverkssamling | funnet | P ✓ · A ✓ — `fs-admin/src/domains/regelverk/features/DashboardView/components/RegelverkSectionTabs/RegelverkSectionTabs.tsx:30-94`, `GQL:4-11` |

## Tilgang og datakonsistens

Om koden gir rollene tilgang slik kravet sier, holder data fra andre organisasjoner utenfor, og ikke gir foreldreløse eller motstridende data ved sletting og endring. Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

### Avvik

Sjekkene der koden ikke gjør det kravet sier, kravet ikke sier noe, eller tilgangssjekken ikke er funnet. Det kravet ikke beskriver, står også i `## Regler uten scenario`.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | tilgang | Saksbehandler leser regelverkssamlinger | usikker | kravet sier ja (Regel: Opptaksforvaltere, saksbehandlere og opptaksinformatører ser …), koden krever FS-ADMIN_SE_REGELVERK, og koblingen til rollen står i rollekatalogen — `fs-admin/src/app/regelverk/regelverksamlinger/layout.tsx:13` |
| `@OPT-REG-SAM-001` | tilgang | Opptaksinformatør leser regelverkssamlinger | usikker | som over. OPPTAK_INNSYN finnes ikke i fs-admins rolleliste — `fs-admin/src/common/types/generated/tilgangsroller.ts:110-131` |
| `@OPT-REG-SAM-001` | tilgang | Saksbehandler og opptaksinformatør endrer eller sletter ikke (API-et) | usikker | kravet sier nei, koden krever MODIFISERE_REGELVERK for å skrive, men om rollene bare har SE, står i rollekatalogen — `MIG/V196__regelverksamlingRLS.sql:25-50` |
| `@OPT-REG-SAM-001` | tilgang | Alle innloggede leser i API-et, også uten SE_REGELVERK | usikker | kravet nevner bare de tre opptaksrollene (og `@FEL-TIL-GRU-001`), koden har SELECT for alle innloggede, en «bevisst produktbeslutning» — `MIG/V221__regelverksamling_rls.sql:10`, `MIG/V285`:6-9 |

### Stemmer

Sjekkene der koden gjør det kravet sier.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | tilgang | Opptaksforvalter leser regelverkssamlinger ved alle organisasjoner | stemmer | `MIG/V221__regelverksamling_rls.sql:7-10` |
| `@OPT-REG-SAM-001` | organisasjon | Opptaksforvalter oppretter, endrer, kopierer og sletter hos eieren | stemmer | `RS/RegelverksamlingOverview.tsx:34-39`, `RS/components/RegelverksamlingDetailActions.tsx:31-40`, `MIG/V196__regelverksamlingRLS.sql:16-50` |
| `@OPT-REG-SAM-001` | organisasjon | Opptaksforvalter ved en annen organisasjon får lesevisning, og kopierer til sin egen | stemmer | `RS/components/RegelverksamlingDetailActions.tsx:39`, `REG/KopierRegelverksamlingService.java:104-111` |
| `@OPT-REG-SAM-001` | organisasjon | API-et håndhever eierskapet ved endring, sletting og kopiering | stemmer | `MIG/V196__regelverksamlingRLS.sql:37-50`, `REG/KopierRegelverksamlingService.java:104-111` |
| `@OPT-REG-SAM-001` | konsistens | En samling i bruk kan ikke slettes | stemmer | `MIG/V280__opptak_v2_skjema.sql:250-253`, `MIG/V381__cascade_delete_for_regelverksamling.sql:6` |
| `@OPT-REG-SAM-001` | konsistens | Kopien er uavhengig av originalen | stemmer | `REG/KopierRegelverksamlingService.java:113-176` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | En samling med innhold slettes med alt innholdet, og brukeren bekrefter ved å skrive koden | tilstandsovergang | `RS/components/SlettRegelverksamlingDialog.tsx:58-64`, `:96-104` | legg til scenario med `fs-krav` |
| `@OPT-REG-SAM-001` | Valget av samling for et opptak er begrenset til opptakets organisasjon og organisasjonene der brukeren har regelverkstilgang | tilgangssjekk | `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSettings/RegelverksamlingCombobox/RegelverksamlingCombobox.tsx:86-104` | uklart om ønsket |
| `@OPT-REG-SAM-001` | Koden gjøres om til store bokstaver, har formatet `^[A-ZÆØÅ0-9_:,.\-+]{1,40}$`, og navnet har maks 100 tegn | validering | `RS/components/OpprettRegelverksamlingDialog.tsx:140-164`, `GQL:186` | testes i fase 2 |
| `@OPT-REG-SAM-001` | Koden kan ikke endres i Rediger, bare navnet og aktiv | annet | `RS/components/RedigerRegelverksamlingDialog.tsx:115` | legg til scenario med `fs-krav` |
| `@OPT-REG-SAM-001` | Navnet er obligatorisk også i Rediger | obligatorisk felt | `RS/components/RedigerRegelverksamlingDialog.tsx:95-97` | testes i fase 2 |
| `@OPT-REG-SAM-001` | Kopien må ha ny kode og nytt navn, og en kode som finnes ved målorganisasjonen, gir feil | validering | `RS/components/KopierRegelverksamlingDialog.tsx:208-215`, `REG/KopierRegelverksamlingService.java:84-90` | testes i fase 2 |
| `@OPT-REG-SAM-001` | Etter kopiering vises den nye samlingen | annet | `RS/components/KopierRegelverksamlingDialog.tsx:196-201` | testes i fase 2 |
| `@OPT-REG-SAM-001` | Kopi fra detaljsiden (Valg) bare for eieren. Andre kopierer fra oversikten | tilgangssjekk | `RS/components/RegelverksamlingDetailActions.tsx:31-40`, `:54-67` | testes i fase 2 |
| `@OPT-REG-SAM-001` | Kopien arver aktiv eller inaktiv fra kilden | standardverdi | `REG/KopierRegelverksamlingService.java:119-126` | uklart om ønsket |
| `@OPT-REG-SAM-001` | Kildelista i kopieringen har også inaktive samlinger | annet | `RS/components/KopierRegelverksamlingDialog.tsx:95-103` | dekkes av `@draft`-scenario: Deaktivere regelverkssamling |
| `@OPT-REG-SAM-001` | En ny samling blir aktiv | standardverdi | `RS/components/OpprettRegelverksamlingDialog.tsx:80`, `GQL:181` | testes i fase 2 |
| `@OPT-REG-SAM-001` | Organisasjonen forhåndsvelges ved opprett og kopi (valgt lærested med MODIFISERE, ellers den ene) | standardverdi | `RS/hooks/useOrganisasjonerForNyRegelverksamling.ts:55-60` | testes i fase 2 |
| `@OPT-REG-SAM-001` | Fritekstsøk på kode og navn, og statusfilter (aktiv/inaktiv) | annet | `RS/components/RegelverksamlingFilter/RegelverksamlingFilter.tsx:31-56` | legg til scenario med `fs-krav` |
| `@OPT-REG-SAM-001` | Organisasjonsfilteret viser bare organisasjoner med samlinger, sortert på navn | annet | `RS/hooks/useRegelverksamlingOrganisasjoner.ts:36-56` | legg til scenario med `fs-krav` |
| `@OPT-REG-SAM-001` | Organisasjonsfilteret bygges bare fra de første 1000 samlingene | grense | `RS/hooks/useRegelverksamlingOrganisasjoner.ts:11-12` | uklart om ønsket |
| `@OPT-REG-SAM-001` | Sorteringsretningen kan endres, og lista viser 50 om gangen | annet | `RS/components/RegelverksamlingOrderBy.tsx:14-18`, `RS/hooks/useGetRegelverksamlingState.tsx:15` | legg til scenario med `fs-krav` |
| `@OPT-REG-SAM-001` | Lista viser kode og navn, antall kompetanseregelverk, rangeringsregelverk, grunnlag og kvotetyper, og status | annet | `RS/components/RegelverksamlingResultList.tsx:63-98` | legg til scenario med `fs-krav` |
| `@OPT-REG-SAM-001` | Menyen Regelverk ligger bak funksjonsbryteren `regelverk` (alltid på i dev, review og test) | annet | `fs-admin/src/features/Header/Menu/Menu.tsx:56-65` | uklart om ønsket |

## Åpne spørsmål

Hvor mange regler og scenarioer i hvert krav som har `@openquestion`. Spørsmålene stopper ikke leveransen, men står i testplanen til de er besvart.

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-REG-SAM-001` | Regelverkssamling | 1 av 9 | 1 av 14 | 0 |

## Åpne MR-er og brancher

MR-er og brancher som ser ut til å levere kravene. Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `fs-admin` | [!3430 Maada/regelverk opprett kun egen organisasjon](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3430) (`maada/regelverk-opprett-kun-egen-organisasjon`) | åpen | `@OPT-REG-SAM-001` | 0/1 | Eierkolonne i lista og strammere tilgang til innholdet. Ingen ny atferd for scenarioene |
| `fs-admin` | [!3384 eier av regelverksamling uten valgt lærested (BAT-357)](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3384) (`kjetihoy/BAT-357-regelverksamling-eier-uten-larested`) | utkast | `@OPT-REG-SAM-001` | 0/1 | Lærestedet forhåndsvelger ikke organisasjonen. Én organisasjon vises som skrivebeskyttet felt |
| `fs-admin` | [!3374 brukerveiledninger for regelverksamling …](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3374) (`brukerveiledning-opprette-regelverk`) | åpen | – | – | Bare veiledning |
| `fs-plattform` | [!6448 TAKE-461: Flytt opptak- og regelverksfeltene fs-admin bruker til beta](https://gitlab.sikt.no/fs/fs-plattform/-/merge_requests/6448) (`feature/take-461-beta`) | åpen | – | – | Ingen endring i atferden |

## Andre funn

Det som må følges opp, og som ikke står i de andre tabellene: det kravet ikke sier, det kontrollen rettet, spørsmålene, og det som ikke ble sjekket. Én rad per funn, sortert etter type og så i rekkefølgen kravene står i.

| Type | Feature-ID | Gjelder | Hva |
| --- | --- | --- | --- |
| Kontrollen endret | `@OPT-REG-SAM-001` | «Saksbehandler og opptaksinformatør ser regelverkssamlingen, men endrer den ikke», «Bare opptaksforvalter kan opprette en regelverkssamling» | A ✓ → A ~: utfallet avhenger av rollene i rollekatalogen. Resultatet `usikker` er uendret |
| Kontrollen endret | `@OPT-REG-SAM-001` | «Se innholdet i en regelverkssamling» | P – → P ✓: fanene henter innholdet fra API-et (`GQL:4-11`) |
| Åpent spørsmål | `@OPT-REG-SAM-001` | «En regelverkssamling kan deaktiveres» (`krav/02 Opptak/10 Regelverk/01 Regelverkssamling/regelverkssamling.feature:108`) | I dag har deaktivering ingen virkning: inaktive samlinger kan fortsatt velges for nye opptak. Skal de skjules når samling velges for et nytt opptak? |
| Ikke sjekket | – | Rollekatalogen i tilgangsstyringen | Hvilke frontendroller (SE_REGELVERK, MODIFISERE_REGELVERK) opptaksforvalter, saksbehandler og opptaksinformatør får, står ikke i noen av klonene |
| Merknad | `@OPT-REG-SAM-001` | «Kopiere regelverkssamling» | Kopiering fra en annen organisasjons samling skjer fra oversikten («Kopier fra eksisterende»). Valg › Kopier på detaljsiden er bare for eieren. Testen `KopierRegelverksamlingIT.java:440-463` gir brukeren SE_REGELVERK på kildeorganisasjonen. Ingen test viser kopi uten |
