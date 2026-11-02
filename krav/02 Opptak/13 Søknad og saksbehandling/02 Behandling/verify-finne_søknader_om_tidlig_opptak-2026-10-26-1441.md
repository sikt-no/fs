# Verifisering: finne_søknader_om_tidlig_opptak.feature

- **Dato:** 2026-10-26 14:41
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/finne_søknader_om_tidlig_opptak.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 97fbafa9b3, lest fra origin/main), `fs-admin` (main, 2b7d1f87a, oppdatert)
- **Omfang:** `@in-progress` (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei
- **Confluence:** https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148966925

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `A-filter` = `fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/components/SakFilter/SakFilter.tsx`
- `A-input` = `fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/hooks/toSakFilterInput.ts`
- `P-sak` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/sak.graphqls`
- `P-cond` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SakFilterConditions.java`
- `P-service` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SakService.java`

## Oppsummering

- Scenarioer: 6 funnet, 0 ikke funnet, 0 usikker, av 6
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-009` | Filteret for tidlig opptak er ikke i bruk som standard | funnet | `fs-admin/src/domains/soknadsbehandling/features/SakOverviewView/hooks/useGetSakOverviewState.tsx:45` starter med `tidligopptak: []`; `A-input:49-50` sender feltene bare når valgene er gjort; uten dem gir `P-service:68-71` og `P-cond:142-145` ingen betingelse |
| `@OPT-BEH-BEH-009` | Filtrere på tidlig opptak | funnet | `A-filter:122-128` har valgene Har søkt / Mangler konklusjon / Har konklusjon; `A-input:12-26, 49-50` gjør dem om til `harSoktTidligopptak` og `tidligopptakKonklusjon`; `P-sak:326, 334`; `P-service:68-82` (søkt = begrunnelsestype satt); `P-cond:156-163` (har = konklusjon satt; mangler = ingen konklusjon og søkt) |
| `@OPT-BEH-BEH-009` | Saker der søkeren ikke har søkt, mangler ikke konklusjon | funnet | `P-cond:161-163` krever `harSoktTidligopptak` for `MANGLER_KONKLUSJON` |
| `@OPT-BEH-BEH-009` | Valgene for konklusjon kombineres med eller | funnet | `P-cond:142-153` legger valgene i `DSL.or` |
| `@OPT-BEH-BEH-009` | Søkt om tidlig opptak kombineres med valgene for konklusjon med og | funnet | `A-input:49-50` sender søkt og konklusjon som to felt; `P-sak:326` og `P-sak:334` er to separate `@condition` på `SakFilterV2Input`, og antallene kombinerer dem med og (`P-cond:134-139`) |
| `@OPT-BEH-BEH-009` | Filteret for tidlig opptak kombineres med saksbehandlingsstatus | funnet | `A-input:34` sender `statuskoder` sammen med tidlig opptak; `P-sak:269` er en egen `@condition`, og `UNDER_BEHANDLING` finnes i `SakStatusKode` |

## Kontroll

Kontrollen endret ingen resultater.

## Forslag til endringer

**Kan leveres**

- `@OPT-BEH-BEH-009` — Finne søknader om tidlig opptak (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/finne_søknader_om_tidlig_opptak.feature`, `@in-progress` → `@implemented`, 6/6 funnet)

**Delvis levert**

Ingen.

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-009` | Finne søknader om tidlig opptak | `finne_søknader_om_tidlig_opptak.feature` | `@in-progress` | 6/6 |

## Ikke levert

Ingen.

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **«Har konklusjon» krever ikke at søkeren har søkt:** `P-cond:156-158` sjekker bare at saken har konklusjon, og `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SettTidligopptakKonklusjonService.java:29-58` setter konklusjonen også når søkeren ikke har søkt. Kravet sier at valgene for konklusjon bare gjelder saker der søkeren har søkt. Ingen scenario dekker en sak med konklusjon uten søkt, så det endrer ikke resultatet. Kan rettes i koden (`harSattTidligopptakKonklusjon` med `harSoktTidligopptak(sak, true)`), eller presiseres i kravet med `fs-krav`.
- **Ikke sjekket:** min-kompetanse finnes ikke blant kodeklonene. Kravet gjelder bare saksbehandleren i fs-admin.
