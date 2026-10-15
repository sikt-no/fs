# Verifisering: 11 Opprette og vedlikeholde opptak

- **Dato:** 2026-10-15 11:03
- **Krav:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak/` (9 feature-filer)
- **Kode:** `fs-plattform` (main, `fcd502fcb6`, oppdatert), `fs-admin` (main, `9d0d71982`, oppdatert)
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

## Oppsummering

- Scenarioer: 32 funnet, 14 ikke funnet, 9 usikker, av 55
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 3
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-GRU-001` | Opprette et samordna opptak | funnet | `fs-admin/src/app/opptak/opprett/[type]/page.tsx:8-11` og `A/OpptakManagement/OpptakManagementPage.tsx:244-246,276-286,364-375` oppretter med samordning, og `P/opptak/OpprettOpptakMutations.java:82-86,143-149` lagrer organisasjon og samordna organisasjoner. Bak feature-flagget `opptak-opprett-samordna` |
| `@OPT-OVO-GRU-001` | Opprette et lokalt opptak | funnet | `OpptakManagementPage.tsx:244-246`, `A/OpptakManagement/utils/convertDataToInput.tsx:128` og `OpprettOpptakMutations.java:82-86` |
| `@OPT-OVO-GRU-001` | Lagre opptak uten navn | funnet | `OpptakManagementPage.tsx:161-172,212,429` sperrer Lagre og viser hva som mangler. Bare i fs-admin |
| `@OPT-OVO-GRU-001` | Lagre opptak uten regelverkssamling | funnet | `OpptakManagementPage.tsx:174-177,212,429` og `P-skjema/opptak/opptak.graphqls:105` |
| `@OPT-OVO-GRU-001` | Lagre opptak uten opptakstype | funnet | `OpptakManagementPage.tsx:173,212,429`, `opptak.graphqls:93` og `OpprettOpptakMutations.java:590-594` |
| `@OPT-OVO-GRU-001` | Angi opptaksnavn på flere språk | funnet | `A/OpptakManagement/OpptakInformation/OpptakInformation.tsx:44-96` har nb, nn, en og se, og `OpprettOpptakMutations.java:292-293,327-345` lagrer dem (TAKE-395) |
| `@OPT-OVO-GRU-001` | Lagre opptak med navn på alle obligatoriske språk | funnet | `convertDataToInput.tsx:119-127` og `OpprettOpptakMutations.java:160-161,327-345` |
| `@OPT-OVO-GRU-001` | Navn mangler på et obligatorisk språk | funnet | `OpptakManagementPage.tsx:160-172,212,429` sperrer Lagre for hvert av nb, nn og en. Bare i fs-admin |
| `@OPT-OVO-SAM-001` | Legge til lærested i samordna opptak | funnet | `P-mig/V300__rls_over_paa_auth_claims.sql:52-66`, `P-ft/SamordnetOpptakFT.java:205-216` og `A/OpptakManagement/Samordning/Samordning.tsx:73-101` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet | `P-mig/V280__opptak_v2_skjema.sql:1160-1165` og `SamordnetOpptakFT.java:217-231` |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | usikker | API-et tillater det (`P-mig/V319__opptak_v2_skriving_krever_forvalter.sql:32-34`), og frister kan endres i fs-admin, men regelverkssamlingen er låst (`A/OpptakManagement/OpptakSettings/OpptakSettings.tsx:232`). TAKE-396 er ikke merget |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger | funnet | `V319:32-34`, `SamordnetOpptakFT.java:256-279` og `A/OpptakDetails/OpptakDetails.tsx:62-80` |
| `@OPT-OVO-SAM-001` | Lokalt opptak tillater ikke andre organisasjoner | funnet | `OpptakManagementPage.tsx:364` og `convertDataToInput.tsx:188-190`. Det holder at brukergrensesnittet sperrer (avklart 12.10) |
| `@OPT-OVO-SAM-001` | Legge til organisasjon som finnes i utdanningsregisteret | funnet | `V280:312-322`, `SamordnetOpptakFT.java:286-297` og `InviterOrganisasjonerModal.tsx:51-83` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | funnet | FK i `V280:321-322` og `SamordnetOpptakFT.java:298-316` |
| `@OPT-OVO-SAM-001` | Filtrere på universiteter og høyskoler | funnet | `InviterOrganisasjonerModal.tsx:44,58,173-178` og `SamordnetOpptakFT.java:317-322` |
| `@OPT-OVO-SAM-001` | Filtrere på fagskoler | funnet | `InviterOrganisasjonerModal.tsx:58` og `SamordnetOpptakFT.java:323-328` |
| `@OPT-OVO-SAM-001` | Sette regler for fordeling av søknader til saksbehandlerorganisasjoner | funnet | `OpprettOpptakMutations.java:348-395`, `SamordnetOpptakFT.java:329-361` og `A/Behandlertildelingsregler/components/BehandlertildelingsregelStandard.tsx:72-168` (STEK-578) |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling er ikke relevant for lokale opptak | usikker | Regelsiden gir 404 for lokale opptak (`fs-admin/src/app/opptak/[id]/behandlertildelingsregler/layout.tsx:32-35`), men utdanningstilbudet viser fortsatt feltet «Saksbehandlertildelingsregel» skrivebeskyttet (`A/UtdanningstilbudDetails/UtdanningstilbudDetails.tsx:766-771`) |
| `@OPT-OVO-INN-001` | Endre opptakstype | ikke funnet | API-et lagrer (`OpprettOpptakMutations.java:223-225`), men `OpptakSettings.tsx:220` sperrer feltet ved redigering, og `convertDataToInput.tsx:159-180` sender ikke typen. Finnes på grenen TAKE-396, ikke på main |
| `@OPT-OVO-INN-001` | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket | ikke funnet | API-et tillater (`OpprettOpptakMutations.java:226-236`), men `OpptakSettings.tsx:232` sperrer feltet. Finnes på grenen TAKE-396, ikke på main |
| `@OPT-OVO-INN-001` | Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket | funnet | `OpprettOpptakMutations.java:227-229` avviser, og `OpptakSettings.tsx:232` sperrer |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud | funnet | `OpptakSettings.tsx:295-326`, `OpprettOpptakMutations.java:238-274,461-512` og `A/UtdanningstilbudDetails/UtdanningstilbudDetails.tsx:241-251,773-787` |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel uten mulighet for unntak | funnet | `convertDataToInput.tsx:105` sender tom liste, og `OpprettOpptakMutations.java:262-267` lagrer bare standarden |
| `@OPT-OVO-INN-001` | Sette startnummer for søknader i opptaket | ikke funnet | Lagres (`OpprettOpptakMutations.java:88,199-200`), men søknadsnummeret kommer fra den felles sekvensen (`SKS:866`, `P-mig/V295__soknad_v2_endrede_tabeller.sql:67`) — søkt etter «soknadsnummer_starter_med», «startnummer» |
| `@OPT-OVO-INN-001` | Sette maks antall søknadsalternativer | funnet | `OpptakSettings.tsx:270-281`, `convertDataToInput.tsx:140,175` og `SKS:479-484` |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | usikker | Søknaden bruker flagget på opptaket (`P/soknad/tidligopptak/SokTidligOpptakService.java:98-118`), men saksbehandlingen ser bare på flagget på utdanningstilbudet (`TidligopptakTilbudsgarantiService.java:309`) |
| `@OPT-OVO-INN-001` | Sette lenke til informasjon om tidlig opptak | ikke funnet | Ingen felt i migrasjonene, `opptak.graphqls` eller fs-admin — søkt etter «lenke», «url», «link», «nettside» |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | ikke funnet | `OPPTAK.TILBYR_LEDIGE_STUDIEPLASSER` lagres, men leses ikke. Bare flagget på utdanningstilbudet brukes — søkt etter «tilbyr_ledige_studieplasser», «ledigeStudieplass» |
| `@OPT-OVO-INN-001` | Legge til utdanningsbakgrunner fra godkjent liste | funnet | `OpptakSettings.tsx:55-59,236-253` og `P/opptak/OpptakUtdanningsbakgrunner.java:36-48` (TAKE-384) |
| `@OPT-OVO-INN-001` | Legge til flere utdanningsbakgrunner | funnet | `OpptakManagementPage.tsx:260,283`, `OpptakUtdanningsbakgrunner.java:68-87` og `P-mig/V429__soknad_utdanningsbakgrunn_fra_opptak_v2.sql` |
| `@OPT-OVO-INN-001` | Fjerne en utdanningsbakgrunn fra opptaket | funnet | `FjernUtdanningsbakgrunnModal.tsx` og `OpptakUtdanningsbakgrunner.java:72-74`. En bakgrunn som en søker har valgt, kan ikke fjernes |
| `@OPT-OVO-INN-001` | Åpne for dokumentasjonsopplasting | usikker | Flagget lagres (`OpprettOpptakMutations.java:94,211-212`), men leses ikke. Opplasting er alltid åpen |
| `@OPT-OVO-INN-001` | Stenge for dokumentasjonsopplasting | ikke funnet | `kanLasteOppDokumenter` leses ikke, og `DokumentLagerService.java:76-145` stopper ikke opplasting |
| `@OPT-OVO-FRI-001` | Opptaksforvalter må kunne åpne for tilknytning og redigering av utdanningstilbud | ikke funnet | Settes i `FK:34`, men `REDIGERING_STUDIER_ÅPNER` leses ikke av noen kode eller RLS-policy |
| `@OPT-OVO-FRI-001` | Opptaksforvalter må kunne stenge for tilknytning, redigering og trekking av utdanningstilbud | ikke funnet | Settes i `FK:35`, men `REDIGERING_STUDIER_FRIST` håndheves ikke |
| `@OPT-OVO-FRI-001` | Sette søknadsdato | ikke funnet | Innsending sperres før datoen (`OF:57`, `SKS:800`), men utdanningstilbudene blir ikke synlige for søkere fra datoen (`UtdanningstilbudV2Service.java:82-97` filtrerer bare på søknadsfristen) |
| `@OPT-OVO-FRI-001` | Sette ordinær søknadsfrist | funnet | `OF:54-59,105-112`, `SKS:800,982` og `FK:42` |
| `@OPT-OVO-FRI-001` | Sette omprioriteringsfrist | funnet | `OF:34-42`, `SKS:470` og `FK:48` |
| `@OPT-OVO-FRI-001` | Sette frist for sletting av søknadsalternativer | ikke funnet | Settes i `FK:49`, men `FRIST_SLETTE_STUDIER` leses ikke. Sletting styres av omprioriteringsfristen (`SKS:470,518`) |
| `@OPT-OVO-FRI-001` | Sette ordinær dokumentasjonsfrist | ikke funnet | Settes i `FK:55`, men `soknadskladdLeggTilDokument` (`SKS:289-324`) har ingen fristsjekk |
| `@OPT-OVO-FRI-001` | Sette ettersendingsfrist | funnet | `OF:24-32`, `SKS:376` og `FK:56` |
| `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser | usikker | Settes i `FK:72` og kan leses av alle (`V280:1105-1106`). Visningen for søkerne er i min-kompetanse, som ikke er sjekket |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | funnet | `OF:105-116` og `FK:73`. Gjelder etter en publisert runde som ikke er hovedrunden |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser stenger for søkning | funnet | `OF:58,113-116` og `FK:74` |
| `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak | funnet | `SokTidligOpptakService.java:67`, `OF:44-52` og `FK:64` |
| `@OPT-OVO-FRI-001` | Sette dokumentasjonsfrist for tidlig opptak | usikker | Settes i `FK:65`, men leses ikke i fs-plattform. min-kompetanse er ikke sjekket |
| `@OPT-OVO-FRI-001` | Sette frist for poenggrenser for tidlig opptak | ikke funnet | Ingen hendelsestype, og `FK:62` sier «skipped for now» |
| `@OPT-OVO-FRI-001` | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | usikker | `PUBLISERING_RESULTAT` settes i `FK:88`, men kvitteringen tar datoen fra plasstildelingsrunden (`KvitteringMeldingService.java:331,352-361`). min-kompetanse er ikke sjekket |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | ikke funnet | `SVARFRIST` er fjernet fra kodeverket (`P-mig/V138__fjern_svarfrist.sql:3-13`) og avvises (`HendelseInputValidering.java:28-38`) |
| `@OPT-OVO-FRI-001` | Sette dato for aldersberegning | funnet | `OpprettOpptakMutations.java:71,179-183` og `FK:82` |
| `@OPT-OVO-FRI-001` | Standarddato når datoen ikke er satt | funnet | `AldersberegningsdatoDefault.java:34-50`, kalt fra `OpprettOpptakMutations.java:71,181` |
| `@OPT-OVO-FRI-001` | Sette frist for at saksbehandler kan endre søkers utdanningsbakgrunn | usikker | Delvis: `OppdaterSoknadISoknadsbehandlingService.java:168-175` stopper endring etter fristen bare for bakgrunner som kan flytte B-rollen, og overstyringen lagres uansett (`UtdanningsbakgrunnOverstyringService.java:62,80-90`) |
| `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | usikker | Lagres (`OpptakUtdanningsbakgrunner.java:95-114`, `utdanningsbakgrunnUtils.ts:16-19`), men ingen søknadskode leser `UTDANNINGSBAKGRUNN_HENDELSE` |
| `@OPT-OVO-FRI-001` | Søker uten registrert utdanningsbakgrunn følger ordinære frister | ikke funnet | Koden går imot `Gitt`: `V429:30-40` krever at søknaden har en bakgrunn fra opptaket, og fs-admin krever minst én (`OpptakManagementPage.tsx:179-180`) |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | usikker | ikke funnet | `P-mig/V138__fjern_svarfrist.sql:3-13` fjernet koden, og `HendelseInputValidering.java:28-38` avviser den |
| `@OPT-OVO-FRI-001` | Søker uten registrert utdanningsbakgrunn følger ordinære frister | usikker | ikke funnet | `V429:30-40` gjør at søkeren ikke kan søke med en bakgrunn som ikke er lagt til i opptaket |

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-001` | Opprette et opptak | `01 Grunnoppsett/opprett_opptak.feature` | `@in-progress` | 8/8 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Samordna opptak | `@in-progress` | 9/11 | 0 ikke funnet, 2 usikker |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | `@in-progress` | 7/15 | 6 ikke funnet, 2 usikker |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | `@in-progress` | 8/21 | 8 ikke funnet, 5 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Endring siden 12.10:** 32 funnet mot 26, av 55 mot 57 scenarioer. Nye funn: navn på flere språk og obligatoriske språk (TAKE-395), utdanningsbakgrunner (TAKE-384, V429), maks antall søknadsalternativer, lokalt opptak uten andre organisasjoner og standardregel for saksbehandlertildeling (STEK-578), og flere frister i fs-admin (TAKE-341). Rapporten fra 12.10 sjekket også min-kompetanse. Det gjør ikke denne, så noen funn om hva søkeren ser, er nå usikre.
- **TAKE-396 er ikke merget:** «Endre opptakstype» og «Endre regelverkssamling» er funnet på grenen `origin/ross/TAKE-396-rediger-opptakstype-og-regsamlingz` i fs-admin (`2fb6dd827`), men ikke på main. fs-plattform på main tar allerede imot endringen.
- **Samordna opptak bak feature-flagg:** `opptak-opprett-samordna` (`fs-admin/src/app/opptak/opprett/[type]/layout.tsx:29-38`) er på i dev, review og test. I produksjon styres det av Unleash.
- **Obligatoriske navn håndheves bare i fs-admin:** fs-plattform godtar tomt navn og manglende nynorsk og engelsk (`OpprettOpptakMutations.java:338`).
- **Utdanningsbakgrunn (V429) strider mot kravet:** Kravet sier at bakgrunner uten avvikende frister ikke trenger å registreres, men koden krever at søkeren velger en bakgrunn fra opptaket. Kravet eller koden må endres (`fs-krav`).
- **Svarfrist:** SVARFRIST er fjernet fra kodeverket, men fs-admin har fortsatt feltet (`FK:89-91`). Scenarioet bør tas med `fs-krav`.
- **Visning av innstillinger:** `A/OpptakDetails/OpptakDetails.tsx:106-122` viser tidlig opptak, dokumentopplasting og krav om studierett som påslått, uansett verdi (bak feature-flagg).
- **Ikke sjekket:** min-kompetanse er ikke klonet. Informasjonsfrist for ledige studieplasser, dokumentasjonsfrist for tidlig opptak og publiseringsdato er derfor usikre.
