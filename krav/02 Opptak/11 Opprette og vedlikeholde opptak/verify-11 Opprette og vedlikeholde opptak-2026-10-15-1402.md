# Verifisering: 11 Opprette og vedlikeholde opptak

- **Dato:** 2026-10-15 14:02
- **Krav:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak/` (9 feature-filer)
- **Kode:** `fs-plattform` (main, `d09400fb54`, oppdatert), `fs-admin` (main, `9d0d71982`, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`.

Stiene er forkortet:

- `P/` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/`
- `P-skjema/` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/`
- `P-mig/` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/`
- `P-ft/` = `fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak/funksjonstest/`
- `A/` = `fs-admin/src/domains/opptak/features/`
- `FK` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakDeadlinesSamordna/fristKort.ts`
- `OF` = `P/opptak/Opptaksfrister.java`
- `SKS` = `P/soknad/StudiekurvService.java`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Samordna opptak | 9/11 | fs-admin | Regelverkssamlingen kan ikke endres i redigering (TAKE-396 er ikke på main). Utdanningstilbud i lokale opptak viser feltet «Saksbehandlertildeling» skrivebeskyttet |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | 7/15 | fs-plattform, fs-admin | fs-admin kan ikke endre opptakstype og regelverkssamling (TAKE-396). fs-plattform bruker ikke startnummeret, flaggene for ledige studieplasser og dokumentasjonsopplasting på opptaket, eller flagget for tidlig opptak i saksbehandlingen. Lenken til tidlig opptak finnes ikke |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | 8/21 | fs-plattform, fs-admin | fs-plattform håndhever ikke fristene for redigering av utdanningstilbud, sletting av søknadsalternativer og ordinær dokumentasjon, og bruker ikke de avvikende fristene for utdanningsbakgrunn. Fristen for poenggrenser i tidlig opptak og svarfristen finnes ikke |

Gjenstår: fs-plattform, fs-admin 2, fs-admin 1, ingen 0.

## Oppsummering

- Scenarioer: 24 funnet, 12 ikke funnet, 11 usikker, av 47
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 3
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Legge til lærested i samordna opptak | funnet | P: funnet · A: funnet — `P-mig/V300__rls_over_paa_auth_claims.sql:52-67`, `P-mig/V280__opptak_v2_skjema.sql:1160-1165`, `P-ft/SamordnetOpptakFT.java:206-216`, `A/OpptakManagement/Samordning/Samordning.tsx:73-101`, `A/OpptakManagement/OpptakSøknadsalternativer/OpptakSøknadsalternativer.tsx:61-77` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet | P: funnet · A: funnet — `P-mig/V280:1160-1165`, `P-ft/SamordnetOpptakFT.java:218-231`, `OpptakSøknadsalternativer.tsx:64-77` |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | usikker | P: funnet · A: delvis — `P-mig/V319__opptak_v2_skriving_krever_forvalter.sql:32-34` og `P-ft/SamordnetOpptakFT.java:233-255` tillater det. I fs-admin er regelverkssamlingen låst i redigering (`A/OpptakManagement/OpptakSettings/OpptakSettings.tsx:232`). TAKE-396 er ikke merget |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger | funnet | P: funnet · A: funnet — `P-mig/V319:32-34`, `P-ft/SamordnetOpptakFT.java:257-279`, `A/OpptakDetails/OpptakDetails.tsx:62-80` |
| `@OPT-OVO-SAM-001` | Lokalt opptak tillater ikke andre organisasjoner | funnet | P: ikke relevant · A: funnet — `A/OpptakManagement/OpptakManagementPage.tsx:364`, `A/OpptakManagement/utils/convertDataToInput.tsx:188-190`. Det holder at fs-admin sperrer (avklart 12.10) |
| `@OPT-OVO-SAM-001` | Legge til organisasjon som finnes i utdanningsregisteret | funnet | P: funnet · A: funnet — `P-mig/V280:312-322`, `P-ft/SamordnetOpptakFT.java:287-297`, `InviterOrganisasjonerModal.tsx:51-83` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | funnet | P: funnet · A: ikke relevant — fremmednøkkel i `P-mig/V280:321-322`, `P-ft/SamordnetOpptakFT.java:299-316` |
| `@OPT-OVO-SAM-001` | Filtrere på universiteter og høyskoler | funnet | P: funnet · A: funnet — `InviterOrganisasjonerModal.tsx:44,58,173-178`, `P-ft/SamordnetOpptakFT.java:318-322,375-396` |
| `@OPT-OVO-SAM-001` | Filtrere på fagskoler | funnet | P: funnet · A: funnet — `InviterOrganisasjonerModal.tsx:58,173-178`, `P-ft/SamordnetOpptakFT.java:324-328` |
| `@OPT-OVO-SAM-001` | Sette regler for fordeling av søknader til saksbehandlerorganisasjoner | funnet | P: funnet · A: funnet — `P/opptak/OpprettOpptakMutations.java:348-395`, `P-ft/SamordnetOpptakFT.java:330-362`, `A/Behandlertildelingsregler/components/BehandlertildelingsregelStandard.tsx:47-95` |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling er ikke relevant for lokale opptak | usikker | P: ikke relevant · A: delvis — siden for reglene gir 404 for lokale opptak (`fs-admin/src/app/opptak/[id]/behandlertildelingsregler/layout.tsx:32-35`), men utdanningstilbudet viser feltet «Saksbehandlertildeling» skrivebeskyttet også i lokale opptak (`A/UtdanningstilbudDetails/UtdanningstilbudDetails.tsx:751-771`) |
| `@OPT-OVO-INN-001` | Endre opptakstype | ikke funnet | P: funnet · A: mangler — `P/opptak/OpprettOpptakMutations.java:223-225` lagrer, men `OpptakSettings.tsx:220` sperrer feltet i redigering, og `convertDataToInput.tsx:159-180` sender ikke typen. Finnes på grenen TAKE-396 |
| `@OPT-OVO-INN-001` | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket | ikke funnet | P: funnet · A: mangler — `OpprettOpptakMutations.java:226-236` tillater, men `OpptakSettings.tsx:232` sperrer feltet, og oppdateringen sender ikke regelverkssamlingen. Finnes på grenen TAKE-396 |
| `@OPT-OVO-INN-001` | Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket | funnet | P: funnet · A: funnet — `OpprettOpptakMutations.java:226-230` avviser, og `OpptakSettings.tsx:232` sperrer |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud | funnet | P: funnet · A: funnet — `OpptakSettings.tsx:295-326`, `OpprettOpptakMutations.java:238-274,461-512`, `P/regelverk/poeng/PoenglikhetService.java:136-141`, `A/UtdanningstilbudDetails/UtdanningstilbudDetails.tsx:237-251,773-787` |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel uten mulighet for unntak | funnet | P: funnet · A: funnet — `convertDataToInput.tsx:104-105` sender tom liste, og `OpprettOpptakMutations.java:262-267` lagrer bare standarden |
| `@OPT-OVO-INN-001` | Sette startnummer for søknader i opptaket | ikke funnet | P: mangler · A: funnet — lagres (`OpprettOpptakMutations.java:88,199-200`), men leses ikke. Søknadsnummeret kommer fra den felles sekvensen (`SKS:866`, `P-mig/V295__soknad_v2_endrede_tabeller.sql:67,77`) — søkt etter «soknadsnummer_starter_med», «SOKNADSNUMMER_SEQ», «nextval» |
| `@OPT-OVO-INN-001` | Sette maks antall søknadsalternativer | funnet | P: funnet · A: funnet — `OpptakSettings.tsx:270-281`, `convertDataToInput.tsx:140,175`, `SKS:479-484` |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | usikker | P: delvis · A: funnet — søknaden bruker flagget på opptaket (`P/soknad/tidligopptak/SokTidligOpptakService.java:98-118`), men saksbehandlingen ser bare på flagget på utdanningstilbudet (`P/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java:309`) |
| `@OPT-OVO-INN-001` | Sette lenke til informasjon om tidlig opptak | ikke funnet | P: mangler · A: mangler — ingen felt i `P-skjema/opptak/opptak.graphqls`, migrasjonene eller fs-admin — søkt etter «lenke», «url», «link», «nettside», «informasjonslenke» |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | usikker | P: delvis · A: funnet — fs-admin viser og sletter fristene for ledige studieplasser etter flagget (`FK:70`, `OpptakSettings.tsx:93-108`), men fs-plattform leser bare flagget på utdanningstilbudet (`P/plasstildeling/service/RangeringService.java:138`, `P/saksbehandling/BehandlertildelingService.java:214`) |
| `@OPT-OVO-INN-001` | Legge til utdanningsbakgrunner fra godkjent liste | funnet | P: funnet · A: funnet — `OpptakSettings.tsx:55-59,157-160`, `P/opptak/OpptakUtdanningsbakgrunner.java:36-48` |
| `@OPT-OVO-INN-001` | Legge til flere utdanningsbakgrunner | funnet | P: funnet · A: funnet — `OpptakSettings.tsx:236-253`, `OpptakManagementPage.tsx:260,283`, `OpptakUtdanningsbakgrunner.java:68-87`, `SKS:209-214` |
| `@OPT-OVO-INN-001` | Fjerne en utdanningsbakgrunn fra opptaket | funnet | P: funnet · A: funnet — `OpptakUtdanningsbakgrunner.java:72-74`, `A/OpptakManagement/FjernUtdanningsbakgrunnModal/FjernUtdanningsbakgrunnModal.tsx` |
| `@OPT-OVO-INN-001` | Åpne for dokumentasjonsopplasting | usikker | P: delvis · A: funnet — flagget lagres (`OpprettOpptakMutations.java:94,211-212`), men leses ikke. Søkeren kan laste opp uansett (`P/soknad/dokument/DokumentLagerService.java:76-145`) |
| `@OPT-OVO-INN-001` | Stenge for dokumentasjonsopplasting | ikke funnet | P: mangler · A: funnet — `kanLasteOppDokumenter` leses ikke, og `DokumentLagerService.java:76-145` stopper ikke opplasting — søkt etter «KAN_LASTE_OPP_DOKUMENTER», «kan_laste_opp» |
| `@OPT-OVO-FRI-001` | Opptaksforvalter må kunne åpne for tilknytning og redigering av utdanningstilbud | ikke funnet | P: mangler · A: funnet — settes i `FK:34`, men `REDIGERING_STUDIER_ÅPNER` leses bare i kodeverket (V16, V123, V250, V280) — søkt etter «REDIGERING_STUDIER» i begge repoer |
| `@OPT-OVO-FRI-001` | Opptaksforvalter må kunne stenge for tilknytning, redigering og trekking av utdanningstilbud | ikke funnet | P: mangler · A: funnet — settes i `FK:35`, men `P/opptak/UtdanningstilbudMutations.java` sjekker ingen frist |
| `@OPT-OVO-FRI-001` | Sette søknadsdato | ikke funnet | P: delvis · A: funnet — innsending sperres før datoen (`OF:57`, `SKS:800`), men utdanningstilbudene skjules ikke før datoen (`P/opptak/UtdanningstilbudV2Service.java:82-97`) |
| `@OPT-OVO-FRI-001` | Sette ordinær søknadsfrist | funnet | P: funnet · A: funnet — `OF:54-59,105-112`, `SKS:800,982`, `FK:42` |
| `@OPT-OVO-FRI-001` | Sette omprioriteringsfrist | funnet | P: funnet · A: funnet — `OF:34-42`, `SKS:470`, `FK:48` |
| `@OPT-OVO-FRI-001` | Sette frist for sletting av søknadsalternativer | ikke funnet | P: mangler · A: funnet — settes i `FK:49`, men `FRIST_SLETTE_STUDIER` leses ikke, og `SKS:112-136` sletter uten fristsjekk |
| `@OPT-OVO-FRI-001` | Sette ordinær dokumentasjonsfrist | ikke funnet | P: mangler · A: funnet — settes i `FK:55`, men `FRIST_ORDINÆR_OPPLASTING` leses ikke, og `SKS:289-324` har ingen fristsjekk |
| `@OPT-OVO-FRI-001` | Sette ettersendingsfrist | funnet | P: funnet · A: funnet — `OF:24-32`, `SKS:359-376`, `FK:56` |
| `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser | usikker | P: funnet · A: funnet — settes i `FK:72` og `A/OpptakManagement/utils/defaultDateUtil.ts:8`, og kan leses (`P-mig/V280:1105-1106`). Visningen for søkerne er i min-kompetanse, som ikke er sjekket |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | funnet | P: funnet · A: funnet — `OF:105-116`, `FK:73`. Gjelder etter en publisert runde som ikke er hovedrunden |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser stenger for søkning | funnet | P: funnet · A: funnet — `OF:58,113-116`, `FK:74` |
| `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak | funnet | P: funnet · A: funnet — `P/soknad/tidligopptak/SokTidligOpptakService.java:66-67`, `OF:44-52`, `FK:64` |
| `@OPT-OVO-FRI-001` | Sette dokumentasjonsfrist for tidlig opptak | usikker | P: delvis · A: funnet — settes i `FK:65`, men `FRIST_TIDLIGOPPTAK_OPPLASTING` leses ikke i fs-plattform. min-kompetanse er ikke sjekket |
| `@OPT-OVO-FRI-001` | Sette frist for poenggrenser for tidlig opptak | ikke funnet | P: mangler · A: mangler — hendelsestypen finnes ikke i `P-skjema/…/opptakshendelse.graphqls:237-261` eller i kodeverket, og `FK:62` sier «skipped for now» |
| `@OPT-OVO-FRI-001` | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | usikker | P: delvis · A: funnet — `PUBLISERING_RESULTAT` settes i `FK:88`, men kvitteringen tar datoen fra plasstildelingsrunden (`P/soknad/KvitteringMeldingService.java:331,351-361`). min-kompetanse er ikke sjekket |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | ikke funnet | P: mangler · A: mangler — `SVARFRIST` er fjernet fra kodeverket (`P-mig/V138__fjern_svarfrist.sql:3-13`) og avvises (`P/opptak/HendelseInputValidering.java:28-38`) |
| `@OPT-OVO-FRI-001` | Sette dato for aldersberegning | funnet | P: funnet · A: funnet — `OpprettOpptakMutations.java:71,178-183`, `FK:82` |
| `@OPT-OVO-FRI-001` | Standarddato når datoen ikke er satt | funnet | P: funnet · A: ikke relevant — `P/opptak/AldersberegningsdatoDefault.java:34-50`, `P/saksbehandling/AldersberegningsdatoUtleder.java:43-56` |
| `@OPT-OVO-FRI-001` | Sette frist for at saksbehandler kan endre søkers utdanningsbakgrunn | usikker | P: delvis · A: funnet — `P/opptak/Utdanningsbakgrunnsfrist.java:28-39` sperrer bare endringer som kan flytte B-rollen (`P/soknad/oppdatersoknad/OppdaterSoknadISoknadsbehandlingService.java:169-175`), og overstyringen lagres uansett (`P/saksbehandling/UtdanningsbakgrunnOverstyringService.java:62,80-92`) |
| `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | usikker | P: delvis · A: funnet — fristene settes i `A/OpptakManagement/UtdanningsbakgrunnerAvvikendeFrister/UtdanningsbakgrunnerAvvikendeFrister.tsx` og lagres (`OpptakUtdanningsbakgrunner.java:89-114`), men ingen søknadskode leser `utdanningsbakgrunn_hendelse` |
| `@OPT-OVO-FRI-001` | Søker uten registrert utdanningsbakgrunn følger ordinære frister | usikker | P: delvis · A: delvis — en godkjent bakgrunn uten avvikende frister følger de ordinære fristene (`OF:54-59`), men en bakgrunn som ikke er lagt til i opptaket, kan ikke velges (`P-mig/V429__soknad_utdanningsbakgrunn_fra_opptak_v2.sql:30-40`, `OpptakManagementPage.tsx:179-180`) |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | ikke funnet | usikker | `FK:70` — fs-admin leser flagget og viser fristene for ledige studieplasser bare når det er på |
| `@OPT-OVO-FRI-001` | Søker uten registrert utdanningsbakgrunn følger ordinære frister | ikke funnet | usikker | `OF:54-59` — en godkjent bakgrunn uten avvikende frister følger de ordinære fristene. Resultatet avhenger av hva «ikke registrert» betyr |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Samordna opptak | `@in-progress` | 9/11 | 0 ikke funnet, 2 usikker |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | `@in-progress` | 7/15 | 5 ikke funnet, 3 usikker |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | `@in-progress` | 8/21 | 7 ikke funnet, 6 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Endring siden 11:03:** De tre kravene og fs-admin er uendret. fs-plattform har 16 nye commits (SHI-695, SHI-650, STEK-585, BAT-283 og andre), men ingen av dem gjelder scenarioene. To rader er endret i kontrollen, fra `ikke funnet` til `usikker` (se `## Kontroll`). Rapporten fra 11:03 er slettet etter ønske fra brukeren, og finnes i git-historikken.
- **Lokale opptak er ikke prioritert:** Brukeren svarte at lokale opptak kan stå som i dag, fordi samordna opptak er prioritert. Det gjelder feltet «Saksbehandlertildeling» på utdanningstilbud i lokale opptak (`A/UtdanningstilbudDetails/UtdanningstilbudDetails.tsx:751-771`).
- **TAKE-396 er ikke merget:** Endring av opptakstype og regelverkssamling finnes på grenen `ross/TAKE-396-rediger-opptakstype-og-regsamlingz` i fs-admin, ikke på main. fs-plattform tar allerede imot endringen.
- **Deltakende organisasjoner har mer tilgang enn kravet sier:** En deltakende organisasjon kan også endre utdanningstilbudene til andre deltakere (`P-mig/V319__opptak_v2_skriving_krever_forvalter.sql:11-15`).
- **Utdanningsbakgrunn:** «Søker uten registrert utdanningsbakgrunn» og «avvikende frister» avhenger av hvordan kravet leses. Kravet bør presiseres med `fs-krav`. Dokumentasjonen i fs-plattform sier at fristen for endring av utdanningsbakgrunn bevisst bare gjelder bakgrunner som kan flytte B-rollen (`fs-plattform/opptak/docs/krav-11-opptak-ikke-dekket.md`).
- **Svarfrist:** `SVARFRIST` er fjernet fra kodeverket. Scenarioet bør tas med `fs-krav`.
- **Ikke sjekket:** min-kompetanse er ikke klonet. Informasjonsfrist for ledige studieplasser, dokumentasjonsfrist for tidlig opptak og publiseringsdatoen er derfor usikre.
- **Krav utenfor scope:** `01 Grunnoppsett/opprett_opptak.feature` (`@implemented`) er allerede levert. `03 Innstillinger/sette_plassflyt.feature`, `03 Innstillinger/sette_kvoteprioritet.feature`, `05 Tekster/fellestekster.feature`, `05 Tekster/svarmeldingsmal.feature` og `06 Hendelseslogg/hendelseslogg.feature` (`@draft`) — `fs-krav`.
