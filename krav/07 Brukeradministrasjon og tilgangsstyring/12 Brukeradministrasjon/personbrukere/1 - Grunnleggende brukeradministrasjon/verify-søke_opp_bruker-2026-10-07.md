# Verifisering: søke_opp_bruker.feature (@BRU-PER-GRU-001), uansett status

- **Dato:** 2026-10-07
- **Krav:** `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon/søke_opp_bruker.feature`
- **Kode:** `fs-admin`, `fs-plattform`

## Oppsummering

- Retagget `@in-progress` → `@implemented`: 0 (egenskapen var allerede `@implemented`)
- Deler i leverte krav som er levert (`@in-progress` fjernet): 2 (begge hjemorganisasjon-scenarioene, etter beslutning fra brukeren, se under)
- Fortsatt `@in-progress`: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 4 scenarioer

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-001` | Se liste over personbrukere | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukereOverview/components/PersonbrukereResultList/PersonbrukereResultList.tsx:124` (Navn, Feide-ID, Hjemorganisasjon, Status), `fs-admin/src/domains/tilgangsstyring/features/PersonbrukereOverview/hooks/useGetPersonbrukereState.tsx:46` (NAVN_ASC), `fs-plattform/tilgangsstyring/tilgangsstyring-app/src/main/resources/schema/features/experimental/schema_brukeradmin.graphqls:211` · skjermbilde 1 i chat |
| `@BRU-PER-GRU-001` | Velge sorteringsretning for navn | ikke funnet | Sorteringsvalget er bevisst utelatt i UI (`PersonbrukereResultList.tsx:67`). API-et støtter NAVN i begge retninger (`schema_brukeradmin.graphqls:211`, test `FeideBrukereQueryTest.sorteringPaNavn`) |
| `@BRU-PER-GRU-001` | Liste viser de 50 første personbrukerne | funnet | `useGetPersonbrukereState.tsx:48` (`initFirst: 50`), `PersonbrukereResultList.tsx:98` (loadedCount/totalCount) · skjermbilde 1 («Viser 50 av 71 rader») |
| `@BRU-PER-GRU-001` | Laste inn 50 flere personbrukere | funnet | `PersonbrukereResultList.tsx:87` (`first + pageSize`) · skjermbilde 2 |
| `@BRU-PER-GRU-001` | Alle personbrukere er lastet inn | funnet | `fs-admin/src/common/components/lists/components/ListBody/ListBody.tsx:64` (knappen vises bare ved `hasNextPage`) · skjermbilde 2 («71 rader i listen», ingen knapp) |
| `@BRU-PER-GRU-001` | Navigere til detaljside for personbruker | funnet | `PersonbrukereResultList.tsx:110` · skjermbilde 9 |
| `@BRU-PER-GRU-001` | Fritekst-søk på navn | funnet | `fs-plattform/tilgangsstyring/tilgangsstyring-service/src/main/java/no/sikt/fs/tilgangsstyring_service/FeideBrukereFilterConditions.java:83`, `useGetPersonbrukere.tsx:97` · skjermbilde 4 («martin» → 2 treff) |
| `@BRU-PER-GRU-001` | Fritekst-søk på Feide-ID | funnet | `FeideBrukereFilterConditions.java:66`, `useGetPersonbrukere.tsx:98` · skjermbilde 5 («kjeti» → 3 treff) |
| `@BRU-PER-GRU-001` | Tilgjengelige statuser i filter | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukereOverview/components/filter/PersonbrukereStatusFilter/PersonbrukereStatusFilter.tsx:40`, «Alle statuser» `fs-admin/src/common/messages/nb/domains.json:67` · skjermbilde 3 |
| `@BRU-PER-GRU-001` | Filtrere på status | funnet | `useGetPersonbrukere.tsx:101`, test `FeideBrukereQueryTest.statusfilteret` · skjermbilde 6 (tom liste: ingen deaktiverte personbrukere i test) |
| `@BRU-PER-GRU-001` | Tilgjengelige hjemorganisasjoner i filter | usikker | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukereOverview/hooks/useGetMineBrukeresHjemmeorganisasjoner.tsx:51` (distinkt, sortert), «Alle hjemorganisasjoner» `domains.json:63`, `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0081-mine-brukeres-hjemmeorganisasjoner.sql:22` · skjermbilde 3. Kilden bygger på hele RLS-innsynet, mens listen skjuler brukere fra andre organisasjoner som bare har inaktive roller (`useGetPersonbrukere.tsx:108`). Filteret kan da tilby en hjemorganisasjon som ikke finnes i listen. Følges opp i BAT-276 |
| `@BRU-PER-GRU-001` | Filtrere på hjemorganisasjon | funnet | `useGetPersonbrukere.tsx:99` → `FeideBrukereFilterConditions.java:130`, test `FeideBrukereQueryTest.hjemmeorganisasjonsfilteret` · skjermbilde 8 |
| `@BRU-PER-GRU-001` | Tilgjengelige roller i filter | funnet | `fs-admin/src/domains/tilgangsstyring/features/PersonbrukereOverview/hooks/useGetMineSynligeBrukerroller.tsx:42` (sortert), `FeideBrukereFilterConditions.java:241`, view `0033-deaktivering-feide-bruker.sql:209` (DISTINCT, aktive), «Alle roller» `domains.json:65` · skjermbilde 3. Merk: «Forvalter systemet» står to ganger, fordi to ulike roller (OPPTAKADMINISTRATOR, OPPTAK_ADMINISTRATOR) har samme beskrivelse |
| `@BRU-PER-GRU-001` | Filtrere på rolle | funnet | `useGetPersonbrukere.tsx:100` → `FeideBrukereFilterConditions.java:156`, test `FeideBrukereQueryTest.rollefilteret` · skjermbilde 7 |
| `@BRU-PER-GRU-001` | Kombinere søk og filtre | funnet | `useGetPersonbrukere.tsx:94`, test `FeideBrukereQueryTest.filtreKombineres` · skjermbilde 8 (navn + hjemorganisasjon + rolle) |
| `@BRU-PER-GRU-001` | Brukeradministrator ser personbrukere med hjemorganisasjon i organisasjonene jeg administrerer | funnet | Domenegrenen `fs-plattform/tilgangsstyring/tilgangsstyring-new-db/src/main/resources/db/changelog/0069-saksdelegering-og-se-saksbehandlere.sql:94`, ikke delt på miljø (`0076-miljostyrt-tildelingsgren-feidebruker.sql:26`), beholdes av `FeideBrukereFilterConditions.java:216`. Alle 71 i test har Sikt som hjemorganisasjon |
| `@BRU-PER-GRU-001` | Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer | funnet | `0076-miljostyrt-tildelingsgren-feidebruker.sql:50` (miljø og organisasjon må stemme), `FeideBrukereFilterConditions.java:217` (aktiv), test `FeideBrukereQueryTest.skjulInaktiveFraAndreOrganisasjoner`. Ingen slik bruker i test |
| `@BRU-PER-GRU-001` | Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer | funnet | `FeideBrukereFilterConditions.java:208`, `useGetPersonbrukere.tsx:108`, test `FeideBrukereQueryTest.skjulInaktiveFraAndreOrganisasjoner`. Merk: RLS har også en tredje gren for saksbehandlere (`0069:97`), som kravet ikke nevner |
| `@BRU-PER-GRU-001` | Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer | funnet | `0076-miljostyrt-tildelingsgren-feidebruker.sql:56`, `FeideBrukereFilterConditions.java:218` |
| `@BRU-PER-GRU-001` | Kolonnen "Sist brukt" vises i listen | ikke funnet | Søkte etter «Sist brukt», `sistInnlogget` og `sistBrukt`. `schema_brukeradmin.graphqls:216` og `PersonbrukereResultList.tsx:36` sier at innloggingstidspunktet ikke lagres |
| `@BRU-PER-GRU-001` | Velge sorteringsretning for sist brukt | ikke funnet | Som over |

## Deler levert

| Feature-ID | Del | Fil | Gating funnet |
| --- | --- | --- | --- |
| `@BRU-PER-GRU-001` | Scenario: Tilgjengelige hjemorganisasjoner i filter | `søke_opp_bruker.feature` | usikker, levert etter beslutning fra brukeren |
| `@BRU-PER-GRU-001` | Scenario: Filtrere på hjemorganisasjon | `søke_opp_bruker.feature` | 1 av 1 |

Brukeren bestemte at begge hjemorganisasjon-scenarioene skulle regnes som levert. Kanttilfellet i filteret følges opp i [BAT-276](https://sikt.atlassian.net/browse/BAT-276), under epic-en BAT-184.

Ikke hele egenskapen ble funnet: `Velge sorteringsretning for navn` og `Regel: Sist brukt-kolonne og sortering` er `@draft` og ikke bygget. De tre `@planned`-synlighetsscenarioene er funnet i koden, men er ikke hentet inn i en oppgave. De beholder `@planned` til de verifiseres hver for seg, eller til `fs-specify` henter dem inn.

## @deprecated som fortsatt finnes i koden

Alle fire beskriver samme oppførsel som `@planned`-erstatningene, med «datatilgang» der erstatningene sier «rolle». Koden er den samme, så den kan ikke bli borte uten at erstatningene også forsvinner.

- **`@BRU-PER-GRU-001` — Brukeradministrator ser personbrukere med datatilgang fra egne organisasjoner**
  - `fs-plattform/.../changelog/0076-miljostyrt-tildelingsgren-feidebruker.sql:50` — tildelingsgrenen (miljø og organisasjon)
  - `fs-admin/.../hooks/useGetPersonbrukere.tsx:108` — `skjulInaktiveFraAndreOrganisasjoner: true`
- **`@BRU-PER-GRU-001` — Personbrukere uten tilknytning til egne organisasjoner er ikke synlige**
  - `fs-plattform/.../changelog/0069-saksdelegering-og-se-saksbehandlere.sql:88` — `feide_bruker_les`
- **`@BRU-PER-GRU-001` — Personbrukere med kun inaktiv datatilgang fra egne organisasjoner er ikke synlige**
  - `fs-plattform/.../FeideBrukereFilterConditions.java:208` — `skjulInaktiveFraAndreOrganisasjoner`
- **`@BRU-PER-GRU-001` — Personbrukere med datatilgang i et miljø jeg ikke administrerer er ikke synlige**
  - `fs-plattform/.../changelog/0076-miljostyrt-tildelingsgren-feidebruker.sql:56`

## Oppfølging

- [BAT-276](https://sikt.atlassian.net/browse/BAT-276): verifiser at hjemorganisasjonsfilteret bare tilbyr hjemorganisasjoner som finnes i listen.
- Det åpne spørsmålet på `Velge sorteringsretning for navn` sier at API-et ikke støtter sortering på navn. API-et gjør det nå (`schema_brukeradmin.graphqls:211`). Bare UI-et mangler. Spørsmålet bør oppdateres med `fs-krav`.
- Rollefilteret viser «Forvalter systemet» to ganger (OPPTAKADMINISTRATOR og OPPTAK_ADMINISTRATOR har samme beskrivelse). Det er to ulike roller, men de ser like ut for brukeren.
- De fire `@deprecated`-scenarioene ser ut som omformuleringer av `@planned`-scenarioene. Avklar med `fs-krav` om de kan fjernes, eller om `@planned`-scenarioene skal bli levert samtidig.
- Ingen step definitions i `tester/steps/` for kravet.
- Skjermbildene ble tatt fra https://test-fsadmin.sikt.no/ (overstyrt bruker «Finn Admin (BRUKERADMINISTRATOR) Sikt testhøyskole»), og er ikke lagret, fordi scope er en `krav/`-sti og ikke en oppgave. Alle 71 personbrukerne i test er aktive og har Sikt som hjemorganisasjon. Derfor kunne verken status «Deaktivert» eller synlighet på tvers av organisasjoner vises.
