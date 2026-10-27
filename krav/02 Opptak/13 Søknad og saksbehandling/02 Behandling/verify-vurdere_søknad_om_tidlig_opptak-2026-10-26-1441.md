# Verifisering: vurdere_søknad_om_tidlig_opptak.feature

- **Dato:** 2026-10-26 14:41
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vurdere_søknad_om_tidlig_opptak.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 97fbafa9b3, lest fra origin/main), `fs-admin` (main, 2b7d1f87a, oppdatert)
- **Omfang:** `@in-progress` (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `A-kort` = `fs-admin/src/domains/soknadsbehandling/features/TidligOpptakCard/TidligOpptakCard.tsx`
- `A-select` = `fs-admin/src/domains/soknadsbehandling/features/TidligOpptakCard/components/TidligopptakKonklusjonSelect/TidligopptakKonklusjonSelect.tsx`
- `A-steg` = `fs-admin/src/domains/soknadsbehandling/utils/getSkippedSakStages.ts`
- `P-sett` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SettTidligopptakKonklusjonService.java`
- `P-gql` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/tidligopptak.graphqls`
- `P-gjennomf` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`

## Oppsummering

- Scenarioer: 9 funnet, 0 ikke funnet, 0 usikker, av 9
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-013` | Se søkerens begrunnelse for tidlig opptak | funnet | avgjort av brukeren: visningen av `behov` regnes som begrunnelsen. `A-kort:28-36, 60, 70` viser `behov` på begrunnelsestypen under «Begrunnelse fra søker», ikke `navn` (`P-gql:76-79`). `behov` er tekst for søkeren i første person, og kan være null (`P-gql:88-89`, `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V402__tidligopptak_begrunnelsetype_behov_og_paminner.sql:6-11`); da viser kortet «-». At søkeren har søkt, vises ved at steget finnes (`A-steg:70-75`) |
| `@OPT-BEH-BEH-013` | Se dokumentasjonskrav for begrunnelsen | funnet | `A-kort:33-35, 61, 75-77` viser `dokumentasjon` under «Dokumentasjonskrav»; `P-gql:84-87` |
| `@OPT-BEH-BEH-013` | Velge blant konklusjonene opptaket har | funnet | `A-select:23-34, 81-90` henter opptakets konklusjoner (aktive, og den som er valgt); `P-sett:33-43` avviser en kode som ikke finnes i opptaket eller ikke er aktiv |
| `@OPT-BEH-BEH-013` | Konkludere om søkeren deltar i tidligopptaket | funnet | `A-select:112-113` sender koden; `P-sett:55-58` lagrer den på saken; om søkeren deltar, kommer fra `deltarITidligopptak` i kodeverket (`P-gql:108-109`), som gjennomføringen leser (`P-gjennomf:797, 837`) |
| `@OPT-BEH-BEH-013` | Konkludere før dokumentasjonsfristen har gått ut | funnet | `P-sett:29-65` sjekker ingen frist; `A-select:94, 149` stenger valget bare uten rolle eller uten konklusjoner |
| `@OPT-BEH-BEH-013` | Søknad uten ønske om tidlig opptak viser ikke tidlig opptak | funnet | `A-steg:69-75` hopper over steget når søknaden ikke har begrunnelse; `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/tidligopptak/page.tsx:12-15` sender videre til første steg |
| `@OPT-BEH-BEH-013` | Konklusjon per organisasjon | funnet | `P-sett:67-71`: saken har nøkkel søker, opptak og organisasjonskode; `P-gjennomf:807-819` kobler hvert søknadsalternativ til saken for organisasjonen som behandler det |
| `@OPT-BEH-BEH-013` | Endre konklusjon før tidligopptaket er gjennomført | funnet | `P-sett:55-58` overskriver verdien uten sperre; `A-select:72, 94` lar brukeren med `MODIFISERE_SØKNADSBEHANDLING` endre |
| `@OPT-BEH-BEH-013` | Endre konklusjonen etter at tidligopptaket er gjennomført | funnet | Ingen sperre i `P-sett:29-65`; konklusjonen leses bare av filtrene og av gjennomføringen (`P-gjennomf:192, 796-837`); garantien står på søknadsalternativet og svaret i `tidligopptak_resultat` (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V406__tidligopptak_resultat.sql:34-91`), og ingen av dem endres når konklusjonen settes |

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-013` — Vurdere søknad om tidlig opptak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vurdere_søknad_om_tidlig_opptak.feature`, `@in-progress` → `@in-progress`, 8/9 funnet) — `@implemented` på: Scenario: Se dokumentasjonskrav for begrunnelsen (linje 117), Regel: Saksbehandler konkluderer om søkeren deltar i tidligopptaket (linje 126), Regel: Konklusjonen kan endres også etter at tidligopptaket er gjennomført (linje 172)

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-013` | Vurdere søknad om tidlig opptak | `vurdere_søknad_om_tidlig_opptak.feature` | `@in-progress` | 9/9 |

## Ikke levert

Ingen.

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Hvilke tekstfelt på begrunnelsestypen skal brukes til hva i saksbehandlingen:** `A-kort:60, 70` viser `behov`, en tekst for søkeren i første person, under «Begrunnelse fra søker». Begrunnelsestypen har også `navn`, `tekst`, `dokumentasjon` og `paminner` (`P-gql:66-96`). Brukeren godtok visningen som oppfyllelse av kravet, men om den er i tråd med intensjonen, må avklares med teamet. Git-historikken til `A-kort` sier ikke hvorfor `behov` er valgt.
- **Valgfrie tekstfelt i databasen:** `behov` og `paminner` er nullbare (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V402__tidligopptak_begrunnelsetype_behov_og_paminner.sql:5-9`). Mangler `behov`, viser kortet «-», selv om søkeren har valgt en begrunnelse. Brukeren mener tekstfeltene ikke bør være valgfrie, men det endres ikke nå.
- **Ikke sjekket:** min-kompetanse finnes ikke blant kodeklonene. Kravet gjelder bare saksbehandleren i fs-admin.
