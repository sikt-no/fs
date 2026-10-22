# Verifisering: Automatisk kvoteplassering

- **Dato:** 2026-10-22 12:33
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvoteplassering.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 9633ab7d86, oppdatert), `fs-admin` (main, 1efab6d91, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `P-svc` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `P-mig` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `P-graph` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling`
- `A-sb` = `fs-admin/src/domains/soknadsbehandling/features`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering | 16/16 | ingen | Alt er funnet. |

Gjenstår: ingen 1.

## Oppsummering

- Scenarioer: 16 funnet, 0 ikke funnet, 0 usikker, av 16
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-012` | Plassering i kvote uten kvotespørsmål | funnet | P: funnet · A: funnet — `P-svc/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:142-156` plasserer i kvoter uten kvotespørsmål når grunnlaget er oppfylt, `A-sb/OppsummeringCard/OppsummeringsCardNy/OppsummeringsCardNy.tsx:52-58` viser kvotetype og poengsum |
| `@OPT-BEH-BEH-012` | Søkeren er ikke kvalifisert på grunnlaget | funnet | P: funnet · A: ikke relevant — `P-svc/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:316-337` teller bare kvalifiserte grunnlag |
| `@OPT-BEH-BEH-012` | Kvote uten kvotespørsmål vises ikke blant kvotespørsmålene | funnet | P: ikke relevant · A: funnet — `A-sb/KvoteplasseringCard/KvoteplasseringCard.tsx:91-92` lager bare rader fra kvotespørsmålene |
| `@OPT-BEH-BEH-012` | Grunnlag som ikke er koblet til kvotetypen | funnet | P: funnet · A: ikke relevant — `P-svc/saksbehandling/SoknadKvoteOppretterService.java:246-253`, `P-svc/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:272-289` krever koblingen i `kvotetype_grunnlag` |
| `@OPT-BEH-BEH-012` | Alder på datoen for aldersberegning | funnet | P: funnet · A: ikke relevant — `P-svc/saksbehandling/AldersberegningsdatoUtleder.java:43-55` bruker datoen for aldersberegning, ellers 31.12 i publiseringsåret, og `P-svc/regelverk/kvoteplassering/Aldersgrense.java:55` regner alderen. Begge eksemplene stemmer |
| `@OPT-BEH-BEH-012` | Aldersgrense på grunnlaget | funnet | P: funnet · A: ikke relevant — `P-svc/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:277-283,339-351` leser aldersgrensen fra grunnlaget, `P-svc/regelverk/kvoteplassering/Aldersgrense.java:40-42` gir mindre enn, større enn og lik. Alle fem eksemplene stemmer, også for kvoter med kvotespørsmål (`P-svc/saksbehandling/KvotesporsmalSvarService.java:415-416`) |
| `@OPT-BEH-BEH-012` | Kvotespørsmål stilles ikke når aldersgrensen ikke er møtt | funnet | P: funnet · A: funnet — `P-svc/saksbehandling/SoknadKvoteOppretterService.java:103,164-234` utelater kvoter med kvotespørsmål når aldersgrensen ikke er møtt, `P-graph/sak.graphqls:94-96` gir bare aktive kvoter, så `A-sb/KvoteplasseringCard/KvoteplasseringCard.tsx` viser ikke spørsmålet |
| `@OPT-BEH-BEH-012` | Alle kvotespørsmål besvart ja | funnet | P: funnet · A: ikke relevant — `P-svc/saksbehandling/KvotesporsmalSvarService.java:464-475` plasserer når alle er besvart ja |
| `@OPT-BEH-BEH-012` | Ett kvotespørsmål besvart nei | funnet | P: funnet · A: ikke relevant — `P-svc/saksbehandling/KvotesporsmalSvarService.java:470-471` plasserer ikke når ett er besvart nei |
| `@OPT-BEH-BEH-012` | Kvotespørsmålene vises i søknadsbehandlingen | funnet | P: ikke relevant · A: funnet — `A-sb/KvoteplasseringCard/KvoteplasseringCard.tsx:113-116,144-155` viser spørsmålsteksten, ikke kvotetypen |
| `@OPT-BEH-BEH-012` | Samme kvotespørsmål på flere kvotetyper vises én gang | funnet | P: ikke relevant · A: funnet — `A-sb/KvoteplasseringCard/KvoteplasseringCard.tsx:88-110` slår sammen like spørsmål og lagrer svaret på alle kvotetypene |
| `@OPT-BEH-BEH-012` | Automatisk besvart kvotespørsmål vises låst | funnet | P: funnet · A: funnet — `A-sb/KvoteplasseringCard/KvoteplasseringCard.tsx:149` og `A-sb/KvoteplasseringCard/components/KvotesporsmalRow/KvotesporsmalRow.tsx:54-63` låser spørsmålet og viser merknaden, `P-svc/autosak/KvotesporsmalAlgoritmeService.java:193-238` besvarer «Er kvinne» |
| `@OPT-BEH-BEH-012` | Svar på automatisk kvotespørsmål avvises i API-et | funnet | P: funnet · A: ikke relevant — `P-svc/saksbehandling/KvotesporsmalSvarService.java:137-151` avviser svar på kvotespørsmål med algoritme |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering i endringsloggen | funnet | P: funnet · A: funnet — `P-svc/autosak/AutomatiskSaksbehandlingService.java:104-110` og `P-svc/audit/AuditContext.java:104-112` lagrer den som startet og maskinbrukeren, `A-sb/AuditLogCard/AuditLogItem/AuditLogItem.tsx:63-75` viser begge |
| `@OPT-BEH-BEH-012` | Endringsloggen viser opptaksalderen | funnet | P: funnet · A: funnet — `P-svc/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:177-189` skriver endringen under en egen intensjon når aldersgrensen er i spill, :220-229 gir opptaksalder og grense både ved plassert og ikke plassert, `A-sb/AuditLogCard/AuditLogItem/AuditLogItem.tsx:80` viser intensjonen |
| `@OPT-BEH-BEH-012` | Ny automatisk behandling uten endring gir ikke nytt innslag | funnet | P: funnet · A: ikke relevant — `P-svc/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:171-180` endrer ikke merknaden når plasseringen er uendret, og `P-mig/V388__endringslogg_hopp_over_uendrede_oppdateringer.sql:59-72` logger ikke oppdateringer uten endrede felt |

## Kontroll

Kontrollen endret ingen resultater.

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering | `automatisk_kvoteplassering.feature` | `@draft` | 16/16 |

## Ikke levert

Ingen.

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Kombinasjonskvote som faller bort på grunn av alder:** en kvote med kvotespørsmål som tas ut fordi aldersgrensen ikke er møtt (`P-svc/saksbehandling/SoknadKvoteOppretterService.java:164`), gir ikke innslag med opptaksalderen i endringsloggen. Scenarioet gjelder en kvote uten kvotespørsmål, så det rammes ikke. Avklares eventuelt med `fs-krav`.
- **Levert uten validering:** kravet gikk fra `@draft` til `@implemented` med verifisering uansett status, uten gjennomgang i `fs-krav`.
- **Kontroll av scenario 1–14:** kontrollert av `fs-verify-kontroll` i en kjøring 2026-10-22 12:17, før sikt-no/fs#790 var merget. Teksten og koden for dem er ikke endret siden.
