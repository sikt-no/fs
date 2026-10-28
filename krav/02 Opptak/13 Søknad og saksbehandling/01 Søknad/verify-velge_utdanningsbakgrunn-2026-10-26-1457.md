# Verifisering: velge_utdanningsbakgrunn.feature

- **Dato:** 2026-10-26 14:57
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/velge_utdanningsbakgrunn.feature` (1 feature-fil, lokal versjon på `krav/velge-utdanningsbakgrunn` med commit `e4e81c4`, som ikke er på `main`)
- **Kode:** `fs-plattform` (main, 97fbafa9b3, oppdatert), `min-kompetanse` (main, 2ca3bdd6, oppdatert)
- **Åpne MR-er:** ikke sjekket (`glab` er ikke installert). Ingen remote-brancher har navn som peker på utdanningsbakgrunn
- **Omfang:** alle krav uansett status (fra prompten)
- **Avhengigheter:** ingen
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `SKS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `UBG` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/soknad/utdanningsbakgrunn.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `BG` = `min-kompetanse/src/app/[locale]/admission/[opptakId]/application/(steps)/background`

## Oppsummering

- Scenarioer: 3 funnet, 13 ikke funnet, 1 usikker, av 17
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-SØK-SØK-017` | Søkeren velger blant utdanningsbakgrunnene i opptaket | usikker | `BG/_queries/query-utdanningsbakgrunn.ts:17` henter utdanningsbakgrunnene i opptaket, og `BG/utdanningsbakgrunn-choices.tsx:80-90` viser dem som radioknapper. Men `BG/utdanningsbakgrunn-choices.tsx:54-66` lagrer bare kodene IB, NORDISK, NORSK, REAL og STEINER (`UBG:114-120`). «Utenlandsk utdanning» (UTLAND) blir ikke lagret, og søkeren får ingen feilmelding. Steget er bak flagget `enable-utdanningsbakgrunn-step` (`min-kompetanse/src/components/soknad-steps/context/soknad-steps-provider.tsx:105`) — brukeren svarte «vet ikke» |
| `@OPT-SØK-SØK-017` | En utdanningsbakgrunn som er fjernet fra opptaket, kan ikke velges | funnet | `BG/_queries/query-utdanningsbakgrunn.ts:17` viser bare utdanningsbakgrunnene i opptaket. `SKS:211-219` avviser en utdanningsbakgrunn som ikke er satt opp i opptaket |
| `@OPT-SØK-SØK-017` | Utdanningsbakgrunnen velges per søknad | funnet | `SKS:229-239`: kladden gjelder søkeren og opptaket, så valget følger ikke med til et annet opptak. `SKS:91-97` setter NORSK på en ny kladd når opptaket tilbyr NORSK, og `BG/utdanningsbakgrunn-choices.tsx:40-42` viser den som valgt — avgjort av brukeren: funnet, det viktige er at valget ikke følger med fra et annet opptak, og NORSK som standardverdi tas inn i kravet med `fs-krav` |
| `@OPT-SØK-SØK-017` | Søknaden kan ikke sendes inn uten utdanningsbakgrunn | funnet | `SKS:819-820` og `SKS:947-950` stopper innsendingen med `SoknadFeilUtdanningsbakgrunnMangler`. `min-kompetanse/src/app/_lib/error-handling/format-soknad-errors.ts:29` og `min-kompetanse/messages/files/nb.json:791` viser «Du må fylle inn informasjon om utdanningsbakgrunnen din før du kan sende inn søknaden.» |
| `@OPT-SØK-SØK-017` | Søkeren endrer utdanningsbakgrunn i en innsendt søknad | ikke funnet | `min-kompetanse/src/app/[locale]/soknader/[soknadId]/edit-studier/_utils/get-soknad-step-entries.ts:6-27` har bare prioritering, dokumentasjon og oppsummering. fs-plattform tillater endringen på en levert kladd (`SKS:172-181`), uten frist — søkt etter «utdanningsbakgrunn», «UTDANNINGSBAKGRUNN» i min-kompetanse |
| `@OPT-SØK-SØK-017` | Søkeren oppgir utdanningsland | ikke funnet | fs-plattform tar imot landkoden for UTLAND (`UBG:86-93`, `SKS:202-205`), men min-kompetanse har ingen landvelger i steget — søkt etter «landKode», «utdanningsland», «UTLAND», «internasjonal», «country» i min-kompetanse |
| `@OPT-SØK-SØK-017` | Nordiske land kan velges som utdanningsland | ikke funnet | Ingen landvelger i min-kompetanse. fs-plattform har NORDISK som egen utdanningsbakgrunn (`UBG:116`), ikke som land i lista for UTLAND — søkt som over |
| `@OPT-SØK-SØK-017` | Søknaden kan ikke sendes inn uten påkrevd utdanningsland | ikke funnet | `SKS:202-205` lar ikke UTLAND lagres uten land, så tilstanden oppstår ikke. `SoknadFeilUtdanningslandMangler` kastes bare når saksbehandleren oppretter en søknad (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/opprettsoknad/OpprettSoknadISoknadsbehandlingService.java:220`). Teksten finnes i `min-kompetanse/messages/files/nb.json:784` |
| `@OPT-SØK-SØK-017` | Utdanningsbakgrunn preutfylles fra GSK-konklusjon | ikke funnet | GSK-koden i `fs-plattform/opptak/opptak-service/.../autosak/gsk/` bruker ikke utdanningsbakgrunn — søkt etter «preutfyll», «prefill», «forhåndsutfyll», «gsk_konklusjon», «gskKonklusjon», «konklusjon» i begge repoene |
| `@OPT-SØK-SØK-017` | Utdanningsland preutfylles fra GSK-konklusjon | ikke funnet | Landkoden settes bare fra søkerens valg, fra kladden og fra saksbehandleren — søkt etter «setLandkodeUtdanningsbakgrunn», «LANDKODE_UTDANNINGSBAKGRUNN» i fs-plattform |
| `@OPT-SØK-SØK-017` | Siste GSK-konklusjon styrer utdanningslandet | ikke funnet | Som over |
| `@OPT-SØK-SØK-017` | Utdanningsbakgrunn preutfylles fra vitnemål | ikke funnet | «vitnem» finnes bare under `resultater/` i min-kompetanse, og fs-plattform har ingen kobling mellom vitnemål og utdanningsbakgrunn — søkt etter «vitnemål», «vitnemal», «diploma» |
| `@OPT-SØK-SØK-017` | Søkeren kan endre preutfylt utdanningsbakgrunn | ikke funnet | Det finnes ingen preutfylling fra GSK-konklusjon eller vitnemål, men NORSK preutfylles (`SKS:91-97`), og søkeren kan bytte til en annen av de fem kodene (`BG/utdanningsbakgrunn-choices.tsx:49-66`). Scenarioet (preutfylt «Utenlandsk utdanning» byttes til «Steinerskole») dekkes ikke, fordi UTLAND ikke kan lagres fra min-kompetanse — avgjort av brukeren: ikke funnet |
| `@OPT-SØK-SØK-017` | Søker med GSK-konklusjon kan ikke velge realkompetanse | ikke funnet | `kan_velges_av_soker` (`MIG/V400__hendelser_pa_utdanningstilbud_og_utdanningsbakgrunn.sql:96`) gjelder typer bare saksbehandleren kan sette (DISP), ikke søkere med GSK-konklusjon — søkt etter «realkompetanse», «REAL», «gsk», «kanVelgesAvSoker» |
| `@OPT-SØK-SØK-017` | Søker uten GSK-konklusjon kan velge realkompetanse | ikke funnet | Sperren finnes ikke. REAL kan velges av alle (`UBG:118`, `BG/utdanningsbakgrunn-choices.tsx:58`) — søkt som over |
| `@OPT-SØK-SØK-017` | Utdanningsland fra en tidligere søknad preutfylles | ikke funnet | Ingen kode leser utdanningslandet fra en søknad i et annet opptak, og min-kompetanse har ingen landvelger — søkt etter «setLandkodeUtdanningsbakgrunn», «tidligere søknad», «forrige søknad» |
| `@OPT-SØK-SØK-017` | GSK-konklusjon går foran en tidligere søknad | ikke funnet | Som over |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-017` | Utdanningsbakgrunnen velges per søknad | funnet | usikker | `SKS:91-97` — en ny kladd får NORSK når opptaket tilbyr NORSK |
| `@OPT-SØK-SØK-017` | Søkeren kan endre preutfylt utdanningsbakgrunn | ikke funnet | usikker | `SKS:91-97` — NORSK preutfylles og kan endres, men ikke fra GSK-konklusjon eller vitnemål |

## Forslag til endringer

**Kan leveres**

Ingen.

**Delvis levert**

- `@OPT-SØK-SØK-017` — Velge utdanningsbakgrunn i søknad (`krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/velge_utdanningsbakgrunn.feature`, `@draft` → `@in-progress`, 3/17 funnet) — `@implemented` på: Scenario: En utdanningsbakgrunn som er fjernet fra opptaket, kan ikke velges (linje 33), Scenario: Utdanningsbakgrunnen velges per søknad (linje 38), Scenario: Søknaden kan ikke sendes inn uten utdanningsbakgrunn (linje 44)

**Kan slettes**

Ingen.

**Blir stående**

Ingen.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-SØK-SØK-017` | Velge utdanningsbakgrunn i søknad | `@draft` | 3/17 | Brukeren avbrøt gjennomgangen |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Steget er bak et flagg:** utdanningsbakgrunnssteget i Min kompetanse vises bare når `enable-utdanningsbakgrunn-step` er på (`min-kompetanse/src/app/[locale]/admission/[opptakId]/application/(steps)/_components/soknad-steps-context-loader/soknad-steps-context-loader.tsx:35`). Om flagget er på i produksjon, er ikke sjekket.
- **Min kompetanse bruker det gamle API-et:** `utdanningsbakgrunner` og `nordisk` er `@deprecated` i fs-plattform (`UBG:4`, `UBG:80-81`). Det nye API-et (`opptakUtdanningsbakgrunner`, `opptakUtdanningsbakgrunn` med `landKode`, `UBG:82-93`) kan lagre «Utenlandsk utdanning» med land, men brukes ikke av min-kompetanse. Koden kaller steget «wip» (`BG/utdanningsbakgrunn-choices.tsx:54-57`).
- **NORSK preutfylles, og det står ikke i kravet:** `SKS:91-97` setter NORSK på en ny kladd når opptaket tilbyr NORSK. Det påvirker «Utdanningsbakgrunnen velges per søknad» og «Søknaden kan ikke sendes inn uten utdanningsbakgrunn», og er relevant for spørsmålet om preutfylling. Sjekk med `fs-krav`.
- **Utdanningsland er knyttet til UTLAND, ikke satt per opptak:** `SKS:202-205` og databasen krever land for UTLAND og ingen annen type. Det er et mulig svar på spørsmålet om hvor det bestemmes om en utdanningsbakgrunn krever utdanningsland.
- **Nordiske land er en egen utdanningsbakgrunn:** NORDISK er en egen type (`UBG:116`), ikke land i lista for «Utenlandsk utdanning» som kravet sier.
- **Endring etter innsending:** fs-plattform tillater at søkeren endrer utdanningsbakgrunnen på en levert kladd uten frist (`SKS:172-181`), men min-kompetanse har ikke steget i redigeringen av en innsendt søknad. `FRIST_SELVBETJENING_UTDANNINGSBAKGRUNN` gjelder saksbehandleren, ikke søkeren (`MIG/V355__selvbetjeningsfrist_utdanningsbakgrunn.sql:1-7`).
- **Åpent spørsmål:** `@OPT-SØK-SØK-017` «Søkeren kan endre utdanningsbakgrunn etter at søknaden er sendt inn» — Skal søkeren selv kunne endre utdanningsbakgrunnen etter at søknaden er sendt inn, eller er det bare saksbehandleren som kan det? Hvis søkeren kan det: til hvilken frist?
- **Åpent spørsmål:** `@OPT-SØK-SØK-017` «Søkeren oppgir utdanningsland når utdanningsbakgrunnen krever det» — Hvor er det bestemt om en utdanningsbakgrunn krever utdanningsland: på utdanningsbakgrunnen i den godkjente lista, eller per opptak av opptaksforvalter?
- **Åpent spørsmål:** `@OPT-SØK-SØK-017` «Utdanningsbakgrunn og utdanningsland preutfylles fra søkerens GSK-konklusjon eller vitnemål» — Hva skal gjelde for en søker med GSK-konklusjon: preutfylt og kan endres, steget hoppes over, eller bestemt per opptak? Hvor er det bestemt hvilke GSK-konklusjoner og vitnemålstyper som er koblet til en utdanningsbakgrunn?
- **Åpent spørsmål:** `@OPT-SØK-SØK-017` «En søker med GSK-konklusjon kan ikke velge en utdanningsbakgrunn som er sperret for søkere med GSK-konklusjon» — Gjelder sperren hvis steget hoppes over for søkere med GSK-konklusjon?
- **Ikke sjekket:** fs-admin (ingen klone). Åpne MR-er i GitLab (`glab` er ikke installert).
- **Kravfila er ikke på `main`:** regelen «Søkeren kan endre utdanningsbakgrunn etter at søknaden er sendt inn» er bare i commit `e4e81c4` på `krav/velge-utdanningsbakgrunn`, som er merget i PR #819 uten den.
