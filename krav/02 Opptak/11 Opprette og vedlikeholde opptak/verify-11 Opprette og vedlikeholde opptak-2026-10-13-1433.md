# Verifisering: TAKE-384 og TAKE-341 i 11 Opprette og vedlikeholde opptak

- **Dato:** 2026-10-13 14:33
- **Krav:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak`, seks regler for Jira TAKE-384 og TAKE-341 (2 feature-filer)
- **Kode:** `fs-plattform` (232e96546a, `main`), `fs-admin` (5dc342325, branch `maada/TAKE-384`, for TAKE-384-reglene), `fs-admin` (9d898817d, branch `maada/TAKE-341-hendelser-og-frister`, for TAKE-341-reglene)
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 2 finnere (`fs-verify-krav`), 2 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei (test-fsadmin kjører `main`, ikke branchene)

Gating-sett: alle scenarioene i scope, også `@draft`, `@planned` og `@openquestion`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `OOM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpprettOpptakMutations.java`
- `OF` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Opptaksfrister.java`
- `OUB` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpptakUtdanningsbakgrunner.java`
- `SKS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `STO` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/tidligopptak/SokTidligOpptakService.java`
- `TTG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`
- `OGQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/opptak.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `OM` = `fs-admin/src/domains/opptak/features/OpptakManagement`
- `MSG` = `fs-admin/src/common/messages/nb/opptak.json`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | 1/6 | fs-plattform, fs-admin | Søkeren leser utdanningsbakgrunnene fra `soknad_v2`, ikke det opptaksforvalteren har valgt i `opptak_v2`. fs-plattform leser ikke opptakets flagg for ledige studieplasser, og tilbudsgarantien leser ikke opptakets flagg for tidlig opptak. Lenken til informasjon om tidlig opptak mangler i begge repoene. |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | 4/8 | fs-plattform, fs-admin | Fristen for poenggrenser i tidlig opptak mangler i begge repoene. Datoen for når ledige studieplasser kan søkes, gjelder først når en runde som ikke er HOVED er publisert. |

Gjenstår: fs-plattform, fs-admin 2, ingen 0.

## Oppsummering

- Scenarioer: 5 funnet, 4 ikke funnet, 5 usikker, av 14
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 6
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | usikker | P: delvis · A: funnet — `OOM:98,223-225` lagrer flagget, og søknaden bruker det (`STO:98-118`). Tilbudsgarantien i saksbehandlingen ser bare på flagget til utdanningstilbudet (`TTG:302-305`). `OM/OpptakSettings/OpptakSettings.tsx:373-380` og `OM/utils/convertDataToInput.tsx:147,182` (TAKE-341). min-kompetanse ikke sjekket |
| `@OPT-OVO-INN-001` | Sette lenke til informasjon om tidlig opptak | ikke funnet | P: mangler · A: mangler — `OGQL:91-138,169-219,255-314` har ikke noe felt for lenken, og `opptak_v2.opptak` ingen kolonne. Søkt etter «lenke», «url», «link», «href», «nettside», «nettadresse», «infoUrl» og «samordnaopptak.no» nær «tidlig» i fs-plattform (Java, `*.graphqls`, `MIG`) og fs-admin (`src/`, `MSG`, `src/__generated__/graphql.ts`, begge branchene) |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | ikke funnet | P: delvis · A: funnet — `OOM:95,214-216` lagrer flagget, og `OGQL:297` viser det, men ingen kode leser det. Vinduet for ledige studieplasser velges etter rundetype (`OF:105-117`), og behandlertildelingen og rangeringen bruker flagget på utdanningstilbudet. Søkt etter `OPPTAK.TILBYR_LEDIGE_STUDIEPLASSER`, `tilbyrLedigeStudieplasser` og `tilbyr_ledige_studieplasser`. `OM/OpptakSettings/OpptakSettings.tsx:366-372` (TAKE-341) |
| `@OPT-OVO-INN-001` | Legge til utdanningsbakgrunner fra godkjent liste | funnet | P: funnet · A: funnet — `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/utdanningsbakgrunn.graphqls:1-4,23-34` lister typene fra `opptak_v2.utdanningsbakgrunn_type`, og `OUB:22-51` avviser typer som ikke finnes, eller som søkeren ikke kan velge. `OM/OpptakSettings/OpptakSettings.tsx:53-58,134-138,234-251` viser typene med `kanVelgesAvSoker` i «Godkjente utdanningsbakgrunner» (TAKE-384) |
| `@OPT-OVO-INN-001` | Legge til flere utdanningsbakgrunner | ikke funnet | P: delvis · A: funnet — `OOM:157-164,294-296` og `OUB:72-96` lagrer bakgrunnene i `opptak_v2.utdanningsbakgrunn`. Søkeren velger fra `soknad_v2.utdanningsbakgrunn` (`SKS:207-216`), og den får alltid bare NORSK og UTLAND (`OOM:114-116,355-374`). «Realkompetanse» og «Steinerskole» kan altså ikke velges. `OM/OpptakManagementPage.tsx:237-245,260-268` og `OM/utils/utdanningsbakgrunnUtils.ts:97-110` sender de valgte (TAKE-384). min-kompetanse ikke sjekket |
| `@OPT-OVO-INN-001` | Fjerne en utdanningsbakgrunn fra opptaket | usikker | P: delvis · A: funnet — `OUB:76-78` sletter fra `opptak_v2.utdanningsbakgrunn`, men søkerens liste i `soknad_v2` endres ikke. Fjernes NORSK eller UTLAND, kan søkeren fortsatt velge den (`SKS:207-216`). For «Steinerskole» stemmer `Så`, men bare fordi den aldri kom til søkeren. `OM/OpptakSettings/OpptakSettings.tsx:234-251` og `OM/OpptakManagementPage.tsx:361-374` (bekreftelse, TAKE-384) |
| `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser | usikker | P: funnet · A: funnet — `MIG/V280__opptak_v2_skjema.sql:1568` (`LEDIGE_STUDIEPLASSER_PUBLISER`), og søkeren kan lese den (`OGQL:282`). `OM/OpptakDeadlinesSamordna/fristKort.ts:68-75` viser kortet bare når «Ledige studieplasser» er på (`OM/utils/hendelseVisibility.ts:12-13`, TAKE-341). Om søkeren ser datoen, avgjøres i min-kompetanse, som ikke er sjekket |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | usikker | P: delvis · A: funnet — `OF:105-117,136-147` bruker `LEDIGE_STUDIEPLASSER_ÅPNER` bare når den sist publiserte runden ikke er HOVED. En runde får publiseringstidspunkt når plasstildelingen publiseres (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/plasstildeling/service/PubliserPlasstildelingService.java:89-93`), eller når forvalteren setter det for hånd (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpptaksrundeMutations.java:115`). Datoen åpner altså ikke søkingen alene. `OM/OpptakDeadlinesSamordna/fristKort.ts:73` (TAKE-341) |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser stenger for søkning | funnet | P: funnet · A: funnet — `OF:58,113-116` avviser søknaden med `SoknadFeilSoknadfristUtlopt` etter `LEDIGE_STUDIEPLASSER_STENGER`, ved levering (`SKS:773`) og ved oppdatering (`SKS:955`). `OM/OpptakDeadlinesSamordna/fristKort.ts:74` (TAKE-341) |
| `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak | funnet | P: funnet · A: funnet — `STO:66-67,98-118` og `OF:44-52` avviser søknaden om tidlig opptak etter `SØKNADSFRIST_TIDLIG_OPPTAK`. En ordinær søknad sjekkes bare mot den ordinære fristen (`OF:54-59`), så etter fristen behandles den i det ordinære opptaket. `OM/OpptakDeadlinesSamordna/fristKort.ts:59-66` viser kortet bare når tidlig opptak er på (TAKE-341) |
| `@OPT-OVO-FRI-001` | Sette dokumentasjonsfrist for tidlig opptak | usikker | P: funnet · A: funnet — `MIG/V380__tidlig_frist_kategori.sql:11-12` (`FRIST_TIDLIGOPPTAK_OPPLASTING`), og søkeren kan lese den. `OM/OpptakDeadlinesSamordna/fristKort.ts:65` (TAKE-341). Om søkeren informeres, avgjøres i min-kompetanse, som ikke er sjekket. Det finnes to koder for fristen, se `## Oppfølging` |
| `@OPT-OVO-FRI-001` | Sette frist for poenggrenser for tidlig opptak | ikke funnet | P: mangler · A: mangler — det finnes ingen hendelsestype, verken i `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/opptakshendelse.graphqls:237-261`, i `MIG/V280__opptak_v2_skjema.sql:1559-1579` eller i `MIG/V380__tidlig_frist_kategori.sql`. `OM/OpptakDeadlinesSamordna/fristKort.ts:62` sier «skipped for now». Det som ligner, er poenggrensen på utdanningstilbudet (`MSG:334`), ikke en frist. Søkt etter «poenggrense», «poeng_grense», «FRIST_POENG», «fristPoeng» og «frist for å sette» |
| `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | funnet | P: funnet · A: funnet — `OUB:72-124` lagrer bakgrunnen og fristene i `utdanningsbakgrunn_hendelse` (`MIG/V400__hendelser_pa_utdanningstilbud_og_utdanningsbakgrunn.sql:164-191`). `OM/UtdanningsbakgrunnerAvvikendeFrister/UtdanningsbakgrunnerAvvikendeFrister.tsx:38-48` og `OM/UtdanningsbakgrunnerAvvikendeFrister/components/AvvikendeFristKort/AvvikendeFristKort.tsx:47-80` (søknadsfrist og frist for dokumentasjon). `OM/utils/utdanningsbakgrunnUtils.ts:75-110` sender fristene (TAKE-384). Søknaden bruker dem ikke ennå (`OF:191-200`), men regelen legger det til 13 Søknad og saksbehandling |
| `@OPT-OVO-FRI-001` | Søker uten registrert utdanningsbakgrunn følger ordinære frister | funnet | P: funnet · A: ikke relevant — `OF:54-59,191-200` leser bare fristene på opptaket |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | usikker (P: funnet) | usikker (P: delvis) | `TTG:302-305` — tilbudsgarantien leser bare flagget på utdanningstilbudet, ikke flagget på opptaket |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | funnet | usikker | `OF:105-117,136-147` — vinduet for ledige studieplasser gjelder først når en runde som ikke er HOVED er publisert |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-INN-001` | Regel: Opptaksforvalter kan åpne for tidlig opptak | `@in-progress` | 0/2 | 1 ikke funnet, 1 usikker |
| `@OPT-OVO-INN-001` | Regel: Opptaksforvalter kan åpne for søknad på ledige studieplasser | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OVO-INN-001` | Regel: Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket | `@in-progress` | 1/3 | 1 ikke funnet, 1 usikker |
| `@OPT-OVO-FRI-001` | Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser | `@in-progress` | 1/3 | 0 ikke funnet, 2 usikker |
| `@OPT-OVO-FRI-001` | Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | `@in-progress` | 1/3 | 1 ikke funnet, 1 usikker |
| `@OPT-OVO-FRI-001` | Regel: Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister | `@in-progress` | 2/2 | Alt funnet, og brukeren svarte «Stemmer», forutsatt at håndhevingen kommer senere. Egenskapen er ikke `@implemented`, så regelen kan ikke bli levert alene |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Scope:** TAKE-384 (utdanningsbakgrunner, fs-admin-branchen `maada/TAKE-384`) er reglene «Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket» i `innstillinger.feature` og «Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister» i `frister_og_hendelser.feature`. TAKE-341 (innstillingene styrer hvilke frister som vises, fs-admin-branchen `maada/TAKE-341-hendelser-og-frister`) er «Opptaksforvalter kan åpne for tidlig opptak» og «Opptaksforvalter kan åpne for søknad på ledige studieplasser» i `innstillinger.feature`, og reglene om ledige studieplasser og tidlig opptak i `frister_og_hendelser.feature`.
- **fs-admin-koden er ikke på `main`:** resultatene for fs-admin gjelder de to branchene. De må verifiseres på nytt når de er merget.
- **Branchene overlapper:** begge legger til «Godkjente utdanningsbakgrunner» i `OM/OpptakSettings/OpptakSettings.tsx`, hver på sin måte. TAKE-341 bruker `opptak.utdanningsbakgrunner` direkte (`OpptakSettings.tsx:158-188`). TAKE-384 bruker `valgteUtdanningsbakgrunner` og `onUtdanningsbakgrunnerChange` (`OpptakSettings.tsx:75-85,135-143`). Det gir trolig en konflikt når den andre merges.
- **Søkeren får ikke utdanningsbakgrunnene til opptaket:** søknaden leser `soknad_v2.utdanningsbakgrunn` (`SKS:207-216`), som bare får NORSK og UTLAND (`OOM:114-116,355-374`). Ifølge analysen for TAKE-384 løses det i TOT-1733, team Tind (`tasks/opptak/opprette-og-vedlikeholde-opptak/frontend/analysis-utdanningsbakgrunner.md:140`).
- **To koder for dokumentasjonsfristen i tidlig opptak:** `FRIST_TIDLIGOPPTAK_OPPLASTING` (`MIG/V380__tidlig_frist_kategori.sql:11-12`, brukt i `OM/OpptakDeadlinesSamordna/fristKort.ts:65`) og `FRIST_TIDLIG_OPPLASTING` (`MIG/V280__opptak_v2_skjema.sql:1579`) står begge i enumen (`opptakshendelse.graphqls:245-246`). min-kompetanse må lese den samme koden som fs-admin skriver.
- **TODO-en om kodene for avvikende frister kan fjernes:** `OM/utils/utdanningsbakgrunnUtils.ts:15-16` sier at kodene ikke er bekreftet av backend (TAKE-383). fs-plattform bruker de samme kodene i testen sin (`fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak/funksjonstest/UtdanningsbakgrunnOpptakFT.java:53-55`).
- **Ikke sjekket:** min-kompetanse er ikke blant kodeklonene i denne kjøringen. Det gjelder alt søkeren ser: tidlig opptak og lenken, utdanningsbakgrunnene, informasjonsfristen for ledige studieplasser og dokumentasjonsfristen for tidlig opptak.
- **Krav utenfor scope:** resten av reglene i `03 Innstillinger/innstillinger.feature` og `04 Frister/frister_og_hendelser.feature` (`@in-progress`) er ikke verifisert her. Se `verify-11 Opprette og vedlikeholde opptak-2026-10-12-1220.md`.
