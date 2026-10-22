# Verifisering: Automatisk kvoteplassering

- **Dato:** 2026-10-22 12:17
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/automatisk_kvoteplassering.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 24aaa90bbf, oppdatert), `fs-admin` (main, 1efab6d91, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `P-svc` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `P-graph` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling`
- `A-sb` = `fs-admin/src/domains/soknadsbehandling/features`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering | 14/15 | fs-admin | Opptaksalderen vises bare i endringsloggen, ikke der saksbehandleren ser kvoteplasseringen. Kravet på branchen `krav/opptaksalder-endringslogg` flytter scenarioet til endringsloggen, og er ikke merget. |

Gjenstår: fs-admin 1, ingen 0.

## Oppsummering

- Scenarioer: 14 funnet, 0 ikke funnet, 1 usikker, av 15
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
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
| `@OPT-BEH-BEH-012` | Kvoteplasseringen viser opptaksalderen | usikker | P: funnet · A: delvis — opptaksalderen lagres i merknaden og intensjonen (`P-svc/regelverk/kvoteplassering/KvoteplasseringGrunnlagService.java:178-189,216-229`), og vises i endringsloggen (`A-sb/AuditLogCard/AuditLogItem/AuditLogItem.tsx:80`). `A-sb/KvoteplasseringCard/KvoteplasseringCard.tsx:27-35` henter ikke `Kvoteplassering.merknadAutomatisk`, så den vises ikke der saksbehandleren ser kvoteplasseringen, som kravet på main sier |

## Kontroll

Kontrollen endret ingen resultater.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering | `@draft` | 14/15 | 0 ikke funnet, 1 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Kravet om opptaksalderen er endret på en annen branch:** `krav/opptaksalder-endringslogg` (commit `315b01d`) bytter «Kvoteplasseringen viser opptaksalderen» med «Endringsloggen viser opptaksalderen» (plassert og ikke plassert) og «Ny automatisk behandling uten endring gir ikke nytt innslag». Det er det STEK-588 har bygget. Merges den, bør kravet verifiseres på nytt.
- **Endret siden forrige verifisering (2026-10-09):** aldersgrensen leses fra grunnlaget (STEK-584), kvotespørsmål stilles ikke når aldersgrensen ikke er møtt (STEK-585), og opptaksalderen står i endringsloggen (STEK-588).
- **Kravet er `@draft`:** alt unntatt opptaksalderen er funnet. Kravet må valideres med `fs-krav` før det kan bli `@planned`, eller settes `@implemented` direkte med verifisering uansett status når alt er funnet.
