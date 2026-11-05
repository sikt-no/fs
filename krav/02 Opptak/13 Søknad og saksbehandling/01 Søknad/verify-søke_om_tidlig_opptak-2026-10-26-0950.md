# Verifisering: søke_om_tidlig_opptak.feature

- **Dato:** 2026-10-26 09:50
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/søke_om_tidlig_opptak.feature` (1 feature-filer)
- **Kode:** `fs-plattform` (main, 26d0862b43, oppdatert), `min-kompetanse` (main, ab8be322, 1 bak origin)
- **Omfang:** `@in-progress` (fra prompten)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei (SØK-011 er Min kompetanse, ikke fs-admin)
- **Confluence:** https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5143887891

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `MK` = `min-kompetanse/src/app/[locale]/soknader/[soknadId]`
- `PS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`

## Oppsummering

- Scenarioer: 9 funnet, 0 ikke funnet, 0 usikker, av 9
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 0
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-011` | `@OPT-OVO-INN-001` Innstillinger | 1 | `@in-progress` | – | ikke levert, `@OPT-SØK-SØK-011` kan ikke leveres før dette · Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det |
| `@OPT-SØK-SØK-011` | `@OPT-OPT-UTD-004` Opptaksinnstillinger for utdanningstilbud | 1 | `@draft` | – | ikke levert, `@OPT-SØK-SØK-011` kan ikke leveres før dette · Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det |

Avhengigheter: 2 på nivå 1, 2 av dem ikke `@implemented`.

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-SØK-SØK-011` | Søke om tidlig opptak fra søknadsdetaljene | funnet | `MK/_components/tidlig-opptak/tidlig-opptak-section.tsx:46` — knappen «Søk om tidlig opptak» på søknadssiden; `MK/_utils/has-tidlig-opptak.ts:13` — opptaket og minst ett søknadsalternativ tilbyr tidlig opptak |
| `@OPT-SØK-SØK-011` | Kan ikke søke om tidlig opptak før søknaden er sendt | funnet | `PS/soknad/StudiekurvService.java:841` — søknaden lages først ved levering; `PS/soknad/tidligopptak/SokTidligOpptakService.java:57` — avviser uten søknad; tidlig opptak finnes ikke i utfyllingen i Min kompetanse |
| `@OPT-SØK-SØK-011` | Søke om tidlig opptak med en begrunnelse | funnet | `PS/soknad/tidligopptak/SokTidligOpptakService.java:73` — lagrer begrunnelsen, `:85` — lager kvittering (`PS/soknad/SoknadKvitteringService.java:70`); `MK/tidlig-opptak/_components/tidlig-opptak-form.tsx:40` — sender begrunnelsen |
| `@OPT-SØK-SØK-011` | Se hvilke søknadsalternativer som tilbyr tidlig opptak | funnet | avgjort av brukeren: det holder at søkeren ser hvilke søknadsalternativer som ikke tilbyr tidlig opptak. `MK/tidlig-opptak/_utils/use-excluded-from-tidlig-opptak.ts:19` og `_components/tidlig-opptak-exclusions.tsx:41` — siden for tidlig opptak viser bare søknadsalternativene som ikke tilbyr tidlig opptak («Obs! Disse studieønskene tilbyr ikke tidlig opptak.»). At et søknadsalternativ tilbyr det, går bare fram av at det ikke står i lista. Søknadssiden viser «Tilbyr ikke tidlig opptak» først som svar etter tidligopptaket (`MK/_utils/use-soknadsalternativ-tidlig-opptak-tag.tsx:17`) |
| `@OPT-SØK-SØK-011` | Se informasjon om tidlig opptak i opptaket | funnet | `MK/_utils/get-tidlig-opptak-url.ts:5` — leser lenken på opptaket, `MK/_components/tidlig-opptak/tidlig-opptak-section.tsx:57` — viser «Les mer»; `PS/opptak/OpprettOpptakMutations.java:105` — lagrer lenken |
| `@OPT-SØK-SØK-011` | Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det | funnet | `MK/_utils/has-tidlig-opptak.ts:13` — boksen skjules; `PS/soknad/tidligopptak/SokTidligOpptakService.java:98` — avviser når verken opptaket eller noe søknadsalternativ tilbyr det |
| `@OPT-SØK-SØK-011` | Se begrunnelsene søkeren kan velge | funnet | `MK/tidlig-opptak/_utils/use-active-tidlig-opptak-begrunnelsetyper.ts:15` — bare aktive begrunnelser; `MK/tidlig-opptak/_components/tidlig-opptak-details.tsx:52` — forklaringen og dokumentasjonskravet per begrunnelse; `PS/soknad/tidligopptak/SokTidligOpptakService.java:121` — avviser en inaktiv begrunnelse |
| `@OPT-SØK-SØK-011` | Kan ikke søke om tidlig opptak etter fristen | funnet | `MK/_hooks/use-is-tidlig-opptak-visible.ts:13` — boksen skjules etter fristen når søkeren ikke har søkt; `PS/opptak/Opptaksfrister.java:44` — avviser etter fristen, kalt fra `SokTidligOpptakService.java:67` |
| `@OPT-SØK-SØK-011` | Søknaden om tidlig opptak blir stående når søknadsalternativene endres | funnet | `PS/soknad/tidligopptak/SokTidligOpptakService.java:74` — det eneste stedet begrunnelsen skrives; `PS/soknad/StudiekurvService.java:841` — ny levering nullstiller den ikke |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-011` | Se hvilke søknadsalternativer som tilbyr tidlig opptak | funnet | usikker | `MK/tidlig-opptak/_components/tidlig-opptak-exclusions.tsx:41` — bare søknadsalternativene som ikke tilbyr tidlig opptak vises, og bare på siden for tidlig opptak |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

Ingen.

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-SØK-SØK-011` — Søke om tidlig opptak (`@in-progress`, 8/9 funnet) — 1 usikker: «Se hvilke søknadsalternativer som tilbyr tidlig opptak». Kan leveres hvis brukeren avgjør at scenarioet er funnet — bygger på `@OPT-OVO-INN-001`, som er `@in-progress`, og `@OPT-OPT-UTD-004`, som er `@draft`

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-011` | Søke om tidlig opptak | `søke_om_tidlig_opptak.feature` | `@in-progress` | 9/9 |

## Ikke levert

Ingen.

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Backend godtar mer enn kravet:** `PS/soknad/tidligopptak/SokTidligOpptakService.java:112` godtar søknaden når opptaket *eller* et søknadsalternativ tilbyr tidlig opptak. Kravet sier opptaket *og* minst ett søknadsalternativ. Siden et utdanningstilbud bare kan tilby tidlig opptak når opptaket gjør det (`PS/opptak/UtdanningstilbudMutations.java:301`), er sjekken i praksis bare «opptaket har tidlig opptak». Har opptaket tidlig opptak, men ingen av søkerens søknadsalternativer, godtar API-et søknaden, mens Min kompetanse skjuler boksen (`MK/_utils/has-tidlig-opptak.ts:13`). Kvitteringen tar da med alle søknadsalternativene (`PS/soknad/SoknadKvitteringService.java:131`). Ingen scenarioer tester tilfellet.
- **Feature-flagg:** alt i Min kompetanse er bak flagget `enable-tidlig-opptak` (`MK/page.tsx:84`, `MK/tidlig-opptak/page.tsx:33`).
- **Lenken vises bare i boksen:** «Les mer» står i boksen «Tidlig opptak» (`MK/_components/tidlig-opptak/tidlig-opptak-section.tsx:57`), og forsvinner med boksen etter fristen når søkeren ikke har søkt.
- **Bygger på krav som ikke er levert:** `@OPT-SØK-SØK-011` bygger på `@OPT-OVO-INN-001` (`@in-progress`) og `@OPT-OPT-UTD-004` (`@draft`)
- **Krav utenfor scope:** «Se når søkeren søkte om tidlig opptak» (`@draft @openquestion`) og regelen «Søkeren ser dokumentasjonsfristen for tidlig opptak» (`@draft`) er ikke verifisert — ikke klare, se `fs-krav`
