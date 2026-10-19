# Verifisering: overstyre_regler_for_poenglikhet.feature

- **Dato:** 2026-10-12 14:01
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/04 Behandle et utdanningstilbud/overstyre_regler_for_poenglikhet.feature` (1 feature-filer)
- **Kode:** `fs-plattform` (5f808f1e09), `fs-admin` (c5718833a), `min-kompetanse` (e6f5ddc4)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft`, `@planned` og `@openquestion`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `schema/` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/`
- `service/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `migration/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `detaljer/` = `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails/`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-015` | Overstyre regler for poenglikhet på utdanningstilbudet | 3/3 | ingen | – |

Gjenstår: ingen 1.

## Oppsummering

- Scenarioer: 3 funnet, 0 ikke funnet, 0 usikker, av 3
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-015` | Se default regel for poenglikhet | funnet | P: funnet · A: funnet · M: ikke relevant — `schema/utdanningstilbudV2.graphqls:122-131` (`poenglikhetsregel`: tilbudets egen regel, ellers opptakets standard) og `service/regelverk/poeng/PoenglikhetService.java:137-141` (`coalesce`); `detaljer/UtdanningstilbudDetails.tsx:181-197` og `:609-624` viser regelen på detaljsiden, med «{navn} (standard for opptaket)» (`fs-admin/src/common/messages/nb/opptak.json:239`) som valg når den kan overstyres, ellers som tekst |
| `@OPT-OPT-UTD-015` | Overstyre regel for poenglikhet | funnet | P: funnet · A: funnet · M: ikke relevant — `schema/opptak/utdanningstilbud.graphqls:65-73` (`oppdaterUtdanningstilbudPoenglikhet`) og `service/opptak/UtdanningstilbudMutations.java:250-292` lagrer regelen; rangeringen bruker gjeldende regel (`service/plasstildeling/service/RangeringService.java:134-146`); velgeren i `detaljer/UtdanningstilbudDetails.tsx:609-619`, lagret i `detaljer/hooks/useUtdanningstilbudEndre.tsx:180-192` |
| `@OPT-OPT-UTD-015` | Kun regler tilgjengelige for opptaket kan velges | funnet | P: funnet · A: funnet · M: ikke relevant — valgene er bare standarden og `tillattePoenglikhetsregler` (`detaljer/UtdanningstilbudDetails.tsx:184-197`), satt i opptaksinnstillingene (`fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSettings/PoenglikhetOverstyring/PoenglikhetOverstyring.tsx`); databasen avviser andre regler med FK `utdanningstilbud_poenglikhetsregel_tillatt_fk` (`migration/V379__tillatte_poenglikhetsregler_pa_opptak.sql:74-79`), og `service/opptak/UtdanningstilbudMutations.java:272-278` gjør bruddet om til en feilmelding |

## Kontroll

Kontrollen endret ingen resultater.

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-015` | Overstyre regler for poenglikhet på utdanningstilbudet | `overstyre_regler_for_poenglikhet.feature` | `@draft` | 3/3 |

## Ikke levert

Ingen.

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Åpne spørsmål i kravet:** fila har fortsatt `# ÅPNE SPØRSMÅL:` (hvilke regler som finnes, og hvordan tilgjengelige regler angis). Koden ser ut til å svare på begge (reglene i `regelverk.poenglikhetsregel`, de tillatte settes i opptaksinnstillingene, `PoenglikhetOverstyring.tsx`). Spørsmålene lukkes med `fs-krav`.
- **Eksperimentelt API:** hele API-et ligger under `schema/` (`experimental`), sammen med resten av detaljsiden, og changesetten `fs-admin/.changeset/opptak-poenglikhetsregel.md` sier at opptak ligger bak feature flag. Ingen flagg rundt akkurat poenglikhetsfeltet i fs-admin.
- **Forrige rapport:** `verify-12 Utdanningstilbud-2026-10-09-1424.md` fant 0/3 (fs-admin manglet). fs-admin-delen kom i `9858ccdcd` (2026-10-09, TAKE-349).
