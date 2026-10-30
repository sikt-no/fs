# Verifisering: vise_elektroniske_vitnemål.feature

- **Dato:** 2026-10-28 10:09
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (commit 6aef37f4a4 på main, angitt av brukeren; klonen er 2 bak origin), `fs-admin` (commit 31ed05b6f på main, angitt av brukeren; klonen er 1 bak origin)
- **Åpne MR-er:** ingen funnet (`glab mr list` ga ingen liste; branchene med «vgs», «vitnem» og «STEK-55» i navnet er sjekket, og ingen har kode for kravet som ikke er merget)
- **Omfang:** `@in-progress`, avgrenset til L1 (fra prompten). Koden går bevisst lenger enn L1 (fagene på vitnemålet), og det er ikke vurdert
- **Avhengigheter:** ingen (kravet har ingen `@depends-on-`)
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated` eller `@demo` (`@openquestion` alene er med).

Stiene er forkortet:

- `sak.graphqls` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/sak.graphqls`
- `vgs-dokument.graphqls` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/vgs-dokument.graphqls`
- `vgs/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/`
- `migration/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `Section.tsx` = `fs-admin/src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx`
- `VgsDokumentView.tsx` = `fs-admin/src/domains/soknadsbehandling/features/VgsDokumentView/VgsDokumentView.tsx`
- `grunnlag/page.tsx` = `fs-admin/src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/grunnlag/page.tsx`

- `IT` = `fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak/vgs/SakVgsDokumenterIT.java`
- `SoknadshendelseJobb.java` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`

## Oppsummering

- Scenarioer: 8 funnet, 3 ikke funnet, 0 usikker, av 11
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0 (6 deler fikk `@implemented`, delvis levert)
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0
- Tilgang og datakonsistens: 2 stemmer, 1 avviker, 0 ikke funnet, 0 usikker, av 4 (i tillegg 1 ikke beskrevet)
- Regler i koden uten scenario: 9
- Åpne spørsmål: 0 regler og 0 scenarioer i gating-settet, 0 utenfor gating (`@draft`)

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | Se at søkeren har elektroniske vitnemål | funnet | `grunnlag/page.tsx:13` — seksjonen ligger i steg «Grunnlag» under grunnlagskortet; `Section.tsx:82-94` — `<Details>` (lukket som standard) med «Vitnemålsbehandling» og en teller (`Badge`) med antall vitnemål; `sak.graphqls:120-130` — `Sak.vgsDokumenter` |
| `@OPT-BEH-BEH-005` | Åpne vitnemålsoversikten | funnet | `Section.tsx:97-158` — tabell med Vitnemålsnummer, Utstedt dato, GSK (skolens påstand, `gsk_ok`), Første, KAR, REA, SPR; `vgs-dokument.graphqls:8-28`; `sak.graphqls:130` — sortert på utstedelsesdato, så vitnemålsnummer, stigende; `vgs/VgsDokumentPoengService.java:32-49` — poeng per vitnemål fra kontrollmotoren i opptak (ikke Team Puff, som kravet sier) |
| `@OPT-BEH-BEH-005` | Søker uten elektroniske vitnemål | funnet | `Section.tsx:69-73` — ingenting vises ved tom liste; `sak.graphqls:122`; `IT:175-179` |
| `@OPT-BEH-BEH-005` | Vitnemålene kan ikke hentes | ikke funnet | Hentingen fra KREG/NVB skjer i en jobb (`SoknadshendelseJobb.java:392-412`) som bare logger feilen («Kunne ikke hente vitnemål fra KREG …; søknaden er tildelt likevel») og lagrer ingen status. Visningen leser bare `kompetanse.vgs_dokument` (`vgs-dokument.graphqls:5`), så feilet hentingen, er lista tom og seksjonen skjules (`Section.tsx:71-73`) — slik det ser ut når søkeren ikke har vitnemål. Det som finnes: `Section.tsx:59-67` viser «Kunne ikke hente søkerens elektroniske vitnemål» når GraphQL-spørringen eller feltet feiler. `KregUtilgjengeligFeil`, som kravet nevner, er fjernet i fs-plattform `8341771051` (STEK-433). Søkt etter «KregUtilgjengelig», «kreg», «nvb», «utilgjengelig», «hentet», «hentingFeilet» i fs-plattform og fs-admin |
| `@OPT-BEH-BEH-005` | Feilmelding når poengberegningen ikke svarer | ikke funnet | Bevisst fjernet (fs-admin MR, be8861b4): poeng som mangler vises som «-» (`Section.tsx:78-79,147-155`; `vgs/VgsDokumentPoengService.java:52-56` gir null), uten feilmelding. Feilmeldingen «Kunne ikke beregne poengene» fantes på forgjengerbranchen `opptak/vise-elektroniske-vitnemal`, og er tatt ut. Søkt etter «poengFeil», «Kunne ikke beregne» i fs-admin |
| `@OPT-BEH-BEH-005` | Åpne et vitnemål i ny fane | funnet | `Section.tsx:125-136` — vitnemålsnummeret er en lenke med `target="_blank"` til `…/sak/[sakId]/vgsdokument/[vgsDokumentId]`; `VgsDokumentView.tsx:33-77` viser vitnemålet |
| `@OPT-BEH-BEH-005` | Annullert vitnemål som er brukt i en beregning vises | ikke funnet | `vgs/VgsDokumentConditions.java:28-31` og `sak.graphqls:129` skjuler alle annullerte vitnemål, uten å sjekke om de er brukt i en beregning (koblingen finnes i `sak_poeng.vgdoknr`, `migration/V291__saksbehandling_skjema.sql:620,646`, men brukes ikke). Ingen markering av annullert i fs-admin. Søkt etter «annuller», «brukt», «beregning», «sak_poeng», «vgdoknr» i begge repoer |
| `@OPT-BEH-BEH-005` | Annullert vitnemål som ikke er brukt i en beregning vises ikke | funnet | `vgs/VgsDokumentConditions.java:29-31`, `sak.graphqls:129` — alle annullerte skjules (også de som er brukt); `IT:98,116-118` |
| `@OPT-BEH-BEH-005` | Saksbehandler med leserettighet ser søkerens vitnemål | funnet | `migration/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:35-40` — RLS på saken: SE_/MODIFISERE_SØKNADSBEHANDLING for organisasjonen som behandler saken; `migration/V179__RLS_for_kompetanse_vgs.sql:112-116` (omskrevet av V300) på vitnemålene; `IT:105-108` |
| `@OPT-BEH-BEH-005` | Bruker uten lesetilgang ser ikke vitnemålsoversikten | funnet | `migration/V454…sql:35-40`; `IT:181-185` — en annen organisasjon får ingen sak; `Section.tsx:57,69-73` — ingen sak gir ingen seksjon |
| `@OPT-BEH-BEH-005` | Saken er tilordnet en annen saksbehandler | funnet | Ingen sjekk av tilordning i `migration/V454…sql:35-40`, `vgs/VgsDokumentConditions.java:18-21` eller RLS på `vgs_dokument` |

## Tilgang og datakonsistens

Sjekket på kodenivå (*Tilgang og datakonsistens* i `fs-verify`): at rollene og tilgangene er implementert slik kravet sier. Ingenting er kjørt, og rollene er ikke testet. Radene er grunnlaget for testbrukerne i testplanen. Radene er ikke scenarioer, og står ikke i `## Scenarioer`.

| Feature-ID | Sjekk | Rolle og handling | Kravet sier | Koden gjør | Resultat | Bevis |
| --- | --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | tilgang | Saksbehandler med SE_/MODIFISERE_SØKNADSBEHANDLING leser vitnemålene via saken | Regel «Innsyn styres av rettighet»: lesetilgang for organisasjonen som behandler saken gir innsyn | RLS på saken krever rettigheten for sakens organisasjon; vitnemålene hentes gjennom saken | stemmer | `migration/V454…sql:35-40`; `migration/V179…sql:112-116` slik `V300__rls_over_paa_auth_claims.sql:221-229` skrev den om |
| `@OPT-BEH-BEH-005` | organisasjon | Saksbehandler leser et vitnemål direkte med id (siden i ny fane) | Innsyn for organisasjonen som behandler saken | Siden henter `node(id)` for vitnemålet uten kobling til saken (`sakId` i adressen brukes ikke til tilgang). RLS på `vgs_dokument` krever rettigheten for en hvilken som helst organisasjon («saksbehandlere kan se alle vitnemål på tvers av organisasjoner») | avviker | `VgsDokumentView.tsx:15-27`; `migration/V179…sql:4,112-116`; `vgs-dokument.graphqls:2-3` |
| `@OPT-BEH-BEH-005` | tilgang | Opptaksforvalter (SE_SØKNADSBEHANDLING + MODIFISERE_OPPTAK) leser alle saker i opptaket, og dermed vitnemålene | ikke beskrevet | Leser alle sakene i opptaket | ikke beskrevet | `migration/V454…sql:20-28,39-40` |
| `@OPT-BEH-BEH-005` | tilgang | Opprette, endre, slette vitnemål | L1 er bare visning | Ingen saksbehandler kan skrive; lagringen skjer på jobbtilkoblingen | stemmer | `migration/V179…sql:118-133` slik V300 skrev den om; `SoknadshendelseJobb.java:387-389` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker (*Regler uten scenario* i `fs-verify`). Input til testplanen og den agentiske testen (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | Poengene vises med høyst én desimal (HALF_UP), heltall uten desimal («2», ikke «2,0») | annet | `vgs/VgsDokumentPoengService.java:51-55`; `Section.tsx:78-79` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Poeng som ikke kan beregnes (vitnemålet kan ikke bygges), vises som «-», uten feilmelding | standardverdi | `vgs-dokument.graphqls:19-22`; `vgs/VgsDokumentPoengService.java:36,52-56`; `Section.tsx:78-79` | legg til scenario med `fs-krav` (erstatter «Feilmelding når poengberegningen ikke svarer») |
| `@OPT-BEH-BEH-005` | Utstedelsesdato, GSK og førstegangsvitnemål som mangler, vises som «-» | standardverdi | `Section.tsx:75-76,139-146` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Vitnemål med samme utstedelsesdato sorteres på vitnemålsnummer | annet | `sak.graphqls:130` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Telleren teller bare vitnemål som ikke er annullert | annet | `Section.tsx:90`; `sak.graphqls:129` | uklart om ønsket |
| `@OPT-BEH-BEH-005` | Siden i ny fane viser «Fant ikke vitnemålet» når vitnemålet ikke finnes eller ikke kan leses, og «Noe gikk galt» ved feil | annet | `VgsDokumentView.tsx:46-47` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Poengene per vitnemål lagres ikke, påvirker ikke sakens poeng, og beregnes for hvert vitnemål for seg | annet | `vgs-dokument.graphqls:19-22`; `vgs/VgsDokumentPoengService.java:14-18` | uklart om ønsket |
| `@OPT-BEH-BEH-005` | Et vitnemål der annullert ikke er satt, regnes som ikke annullert | standardverdi | `vgs/VgsDokumentConditions.java:28-30` | testes i fase 2 |
| `@OPT-BEH-BEH-005` | Ingenting vises mens vitnemålene lastes (ingen lasteindikator) | annet | `Section.tsx:52-57,69-73` | uklart om ønsket |

## Åpne spørsmål

Tellet fra `@openquestion` i kravfilene. `@openquestion` stopper ikke leveransen og testen: delen testes som den står, og `@draft @openquestion` er utenfor gating-settet. Spørsmålene står i `## Oppfølging`.

Ingen åpne spørsmål.

## Kontroll

| Feature-ID | Type | Scenario, rad eller regel | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | scenario | Vitnemålene kan ikke hentes | usikker | ikke funnet | `SoknadshendelseJobb.java:392-412` — feil ved henting fra KREG logges bare, og ingenting lagres som visningen kan bruke; lista blir tom, og seksjonen skjules |
| `@OPT-BEH-BEH-005` | regel | Poengene lagres ikke og beregnes per vitnemål; annullert ikke satt = ikke annullert; ingen lasteindikator | – | lagt til | Funnet av kontrolløren (`vgs/VgsDokumentPoengService.java:14-18`, `vgs/VgsDokumentConditions.java:28-30`, `Section.tsx:52-57`) |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-BEH-BEH-005` — Se søkerens elektroniske vitnemål (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature`, `@in-progress` → `@in-progress`, 8/11 funnet) — `@implemented` på: Scenario: Se at søkeren har elektroniske vitnemål (linje 77), Scenario: Åpne vitnemålsoversikten (linje 83), Scenario: Søker uten elektroniske vitnemål (linje 121), Scenario: Åpne et vitnemål i ny fane (linje 161), Scenario: Annullert vitnemål som ikke er brukt i en beregning vises ikke (linje 180), Regel: Innsyn styres av rettighet, ikke av hvem som har tatt saken (linje 201)

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-BEH-BEH-005` — Se søkerens elektroniske vitnemål (`@in-progress`, 8/11 funnet) — «Vitnemålene kan ikke hentes», «Feilmelding når poengberegningen ikke svarer» og «Annullert vitnemål som er brukt i en beregning vises» er ikke funnet

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | Se søkerens elektroniske vitnemål (delvis: `@in-progress`, 6 deler `@implemented`: Regel: Innsyn styres av rettighet, ikke av hvem som har tatt saken; Scenario: Se at søkeren har elektroniske vitnemål; Scenario: Åpne vitnemålsoversikten; Scenario: Søker uten elektroniske vitnemål; Scenario: Åpne et vitnemål i ny fane; Scenario: Annullert vitnemål som ikke er brukt i en beregning vises ikke) | `vise_elektroniske_vitnemål.feature` | `@in-progress` | 8/11 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-005` | Se søkerens elektroniske vitnemål | `@in-progress` | 8/11 | 3 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Kravet er ikke oppdatert etter justeringene:** «Feilmelding når poengberegningen ikke svarer» (linje 147) er bevisst ikke bygget (fs-admin be8861b4). Poeng som mangler vises som «-». Scenarioet bør fjernes eller skrives om med `fs-krav`, sammen med de som eier kravet.
- **Feil ved henting fra NVB ser ut som ingen vitnemål:** hentingen fra KREG skjer i `SoknadshendelseJobb.java:392-412`, og en feil blir bare logget. Kravet (linje 134, AVKLART 21.10.2026) sier at det ikke skal se ut som at søkeren ikke har vitnemål. Enten må koden lagre at hentingen feilet, eller kravet skrives om med `fs-krav`. Kommentaren om `KregUtilgjengeligFeil` i kravet viser til kode som er fjernet (`8341771051`).
- **Annullerte vitnemål som er brukt i en beregning skjules:** `vgs/VgsDokumentConditions.java:28-31` skjuler alle annullerte. Kravet (linje 171) sier at de som er brukt i en beregning på opptaket, skal vises og markeres.
- **Poengene kommer ikke fra Team Puff:** de beregnes av kontrollmotoren i opptak (`vgs/VgsDokumentPoengService.java:26,37-39`). Kommentarene i kravet (linje 22-27 og under «Åpne vitnemålsoversikten») bør rettes med `fs-krav`.
- **Tilgang avviker:** `@OPT-BEH-BEH-005` saksbehandler leser et vitnemål direkte med id — kravet sier innsyn for organisasjonen som behandler saken; siden i ny fane henter vitnemålet uten kobling til saken, og RLS på `vgs_dokument` gjelder alle organisasjoner, `VgsDokumentView.tsx:15-27`, `migration/V179…sql:4,112-116`.
- **Koden går lenger enn L1:** siden i ny fane viser også fagene med karakterer, merknader, GSK-tekst og utskriftsdato (`VgsDokumentView.tsx:50-73`). Ikke vurdert mot L3–L5, etter avtale med brukeren.
- **Mulig berøring fra MR:** utkast-MR !6251 i fs-plattform (BAT-332, RLS på søker og person) kan påvirke oppslaget i `SOKER` i `vgs/VgsDokumentConditions.java:19-20`. Usikker kobling.
- **Oppgave og spesifikasjon finnes:** `tasks/opptak/vitnemalsbehandling/spec/spec-vise-elektroniske-vitnemal.md`. Kjøringen hadde bare kravfila som scope, så spesifikasjonen og `spec.log.md` er ikke oppdatert.
