# Verifisering: 11 Opprette og vedlikeholde opptak

- **Dato:** 2026-10-15 09:09
- **Krav:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak` (8 feature-filer, 4 verifisert)
- **Kode:** `fs-plattform` (main, a98283692e, oppdatert etter `pull --ff-only`, var 50 bak origin), `fs-admin` (main, d82f9b539, oppdatert), `min-kompetanse` (main, 7d0e6ccf, oppdatert, klonet 2026-10-15). MR 3072 i fs-admin (`ross/TAKE-396-rediger-opptakstype-og-regsamlingz`, 85cd29b87, ikke merget) er lest for seg, og teller ikke i resultatene.
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 4 kontrollører (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei (chrome-devtools-MCP finnes ikke i økta)

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`.

Stiene er forkortet:

- `OOM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpprettOpptakMutations.java`
- `OF` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Opptaksfrister.java`
- `OUB` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpptakUtdanningsbakgrunner.java`
- `UTM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `SKS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `DLS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/dokument/DokumentLagerService.java`
- `STO` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/tidligopptak/SokTidligOpptakService.java`
- `TTG` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`
- `OGQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/opptak.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `KID` = `fs-plattform/opptak/docs/krav-11-opptak-ikke-dekket.md`
- `OM` = `fs-admin/src/domains/opptak/features/OpptakManagement`
- `OMP` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakManagementPage.tsx`
- `OS` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSettings/OpptakSettings.tsx`
- `CDI` = `fs-admin/src/domains/opptak/features/OpptakManagement/utils/convertDataToInput.tsx`
- `FK` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakDeadlinesSamordna/fristKort.ts`
- `MSG` = `fs-admin/src/common/messages/nb/opptak.json`
- `MK` = `min-kompetanse/src`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-001` | Opprette et opptak | 8/8 | ingen | Alt funnet. API-et avviser ikke en tom `navn` eller et manglende språk. Brukeren avgjorde at sperren i fs-admin er nok for nå (se `## Oppfølging`). |
| `@OPT-OVO-SAM-001` | Samordna opptak | 8/11 | fs-admin | Regelverkssamlingen kan ikke endres på et opptak som finnes (MR 3072 løser det). «Sett saksbehandlertildeling» vises også i lokale opptak. Deltakeren ser ikke opptakets faktiske innstillinger. |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | 6/15 | fs-plattform, fs-admin, min-kompetanse | Opptakstype og regelverkssamling kan ikke endres i fs-admin (MR 3072). fs-plattform bruker ikke startnummeret, flagget for ledige studieplasser eller flagget for dokumentasjonsopplasting, og tilbudsgarantien leser ikke flagget for tidlig opptak. Lenken til informasjon om tidlig opptak mangler, og min-kompetanse lagrer ikke «Utenlandsk utdanning». |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | 8/21 | fs-plattform, fs-admin, min-kompetanse | fs-plattform håndhever ikke redigeringsfristene for utdanningstilbud, fristen for sletting, den ordinære dokumentasjonsfristen eller fristen for endring av utdanningsbakgrunn, og fristen for poenggrenser finnes ikke. min-kompetanse viser ikke datoene for ledige studieplasser, den nye dokumentasjonsfristen for tidlig opptak eller første svarfrist før tilbud. |

Gjenstår: fs-plattform, fs-admin, min-kompetanse 2, fs-admin 1, ingen 1.

## Oppsummering

- Scenarioer: 30 funnet, 20 ikke funnet, 5 usikker, av 55
- Krav levert (status satt til `@implemented`): 1
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 3
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-GRU-001` | Opprette et samordna opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:82-97,143-149` lagrer type, navn, regelverkssamling, `erSamordnet` og deltakerne. Organisasjonen kommer fra regelverkssamlingen (`OOM:85`), og bare den organisasjonen kan skrive (`MIG/V280__opptak_v2_skjema.sql:1057-1060`, `MIG/V319__opptak_v2_skriving_krever_forvalter.sql:32-37`). `fs-admin/src/domains/opptak/features/OpptakOverviewView/components/OpprettOpptakPanels/OpprettOpptakPanels.tsx:30-60`, `OMP:276-301,364-375`, `CDI:126-133` |
| `@OPT-OVO-GRU-001` | Opprette et lokalt opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:85,97`. `OpprettOpptakPanels.tsx:88-100`, `OMP:244-246,364` skjuler Samordning, `CDI:128` sender `erSamordnet: false` |
| `@OPT-OVO-GRU-001` | Lagre opptak uten navn | funnet | P: delvis · A: funnet · M: ikke relevant — `OMP:160-172,212` sperrer Lagre så lenge navnene er tomme (`.trim()`). API-et avviser et utelatt `navn` (`OGQL:95`), men godtar `""` (`OOM:83`). Brukeren avgjorde at sperren i fs-admin er nok for nå |
| `@OPT-OVO-GRU-001` | Lagre opptak uten regelverkssamling | funnet | P: funnet · A: funnet · M: ikke relevant — `OGQL:105` (`regelverksamlingId: ID!`), `MIG/V280__opptak_v2_skjema.sql:229` (NOT NULL), `OMP:174-177,212` |
| `@OPT-OVO-GRU-001` | Lagre opptak uten opptakstype | funnet | P: funnet · A: funnet · M: ikke relevant — `OGQL:93` (`opptakstypeId: ID!`), `OOM:591-596` avviser en ukjent kode, `OMP:173,212` |
| `@OPT-OVO-GRU-001` | Angi opptaksnavn på flere språk | funnet | P: funnet · A: funnet · M: ikke relevant — `OGQL:97,178` og `OOM:160-162,292-294,327-347` lagrer nob, nno, eng og sme. `OM/OpptakInformation/OpptakInformation.tsx:44-96`, `CDI:46-53,127,157-167` |
| `@OPT-OVO-GRU-001` | Lagre opptak med navn på alle obligatoriske språk | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:160-162,327-347`, `OpptakInformation.tsx:44-87` merker bokmål, nynorsk og engelsk som påkrevd, `OMP:160-172,212` |
| `@OPT-OVO-GRU-001` | Navn mangler på et obligatorisk språk | funnet | P: mangler · A: funnet · M: ikke relevant — `OMP:163,167,171` sjekker hvert språk og sperrer Lagre (`:212`), så alle tre radene i `Eksempler:` er dekket. API-et hopper over tomme språk uten feil (`OOM:327-347`, `KID:47-49`). Brukeren avgjorde at sperren i fs-admin er nok for nå |
| `@OPT-OVO-SAM-001` | Legge til lærested i samordna opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:520-561` lagrer deltakerne, og INSERT på utdanningstilbud godtar deltakerne (`MIG/V280__opptak_v2_skjema.sql:1160-1165`, `MIG/V300__rls_over_paa_auth_claims.sql:52-68`). `OM/Samordning/Samordning.tsx:73-82`, `OMP:341-353`, og deltakeren får «Legg til» (`fs-admin/src/domains/opptak/features/OpptakSøknadsalternativer/OpptakSøknadsalternativer.tsx:71-77,132-145`) |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `MIG/V280__opptak_v2_skjema.sql:1160-1165` krever MODIFISERE_OPPTAK hos forvalteren eller en deltaker. `OpptakSøknadsalternativer.tsx:71-77` skjuler «Legg til» og massehandlingene |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | ikke funnet | P: funnet · A: delvis · M: ikke relevant — `OOM:177-306` og `MIG/V319__opptak_v2_skriving_krever_forvalter.sql:32-34,74-82`. I fs-admin kan innstillingene og fristene endres, men regelverkssamlingen er låst (`OS:222-233`), og `CDI:150-193` sender ikke `regelverksamlingId`. I MR 3072: `OS:141,206` og `CDI:158-161` |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger | usikker | P: funnet · A: delvis · M: ikke relevant — skrivingen krever forvaltertilgang (`MIG/V319__opptak_v2_skriving_krever_forvalter.sql:32-34,60-68,74-82`, `OOM:252-259`). Deltakeren ser «Administreres av …» og ingen redigering (`fs-admin/src/domains/opptak/features/OpptakDetails/OpptakDetails.tsx:62-80`), men tre innstillinger er hardkodet som aktivert (`OpptakDetails.tsx:105-122`), og resten vises ikke |
| `@OPT-OVO-SAM-001` | Lokalt opptak tillater ikke andre organisasjoner | funnet | P: ikke relevant · A: funnet · M: ikke relevant — API-et trenger ikke sperre (AVKLART i feature-fila). `OMP:244-246,364-375` viser Samordning bare for samordna opptak, og `CDI:188-190` sender deltakerne bare da |
| `@OPT-OVO-SAM-001` | Legge til organisasjon som finnes i utdanningsregisteret | funnet | P: funnet · A: funnet · M: ikke relevant — `OGQL:131,210` (`URegOrganisasjon`), `OOM:520-561`. `OM/Samordning/components/InviterOrganisasjonerModal/InviterOrganisasjonerModal.tsx:51-65,158` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | funnet | P: funnet · A: funnet · M: ikke relevant — FK til replikaen av utdanningsregisteret (`MIG/V280__opptak_v2_skjema.sql:321-322`), og bruddet gir en feilmelding (`OOM:572-576`). Velgeren viser bare organisasjoner fra utdanningsregisteret (`InviterOrganisasjonerModal.tsx:51-84`) |
| `@OPT-OVO-SAM-001` | Filtrere på universiteter og høyskoler | funnet | P: funnet · A: funnet · M: ikke relevant — `InviterOrganisasjonerModal/components/OrganisasjonFilters/OrganisasjonFilters.tsx:97-103` («Type lærested»), `InviterOrganisasjonerModal.tsx:54,58`. `fs-plattform/utdanningsregisteret/utdanningsregisteret-service/src/main/java/no/utdanningsregisteret/conditions/URegOrganisasjonConditions.java:63-77` filtrerer på lærestedstypen |
| `@OPT-OVO-SAM-001` | Filtrere på fagskoler | funnet | P: funnet · A: funnet · M: ikke relevant — det samme filteret med lærestedstypen FAGSKOLE |
| `@OPT-OVO-SAM-001` | Sette regler for fordeling av søknader til saksbehandlerorganisasjoner | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:349-394` (`settBehandlertildelingsregelDefault`), skrivingen bare for forvalteren (`MIG/V395__behandlertildelingsregel_per_opptak.sql:130-136`), og fordelingen i `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingService.java:113-147,204-229`. `OM/Samordning/Samordning.tsx:50-60` og `BehandlertildelingsregelStandard.tsx:85-87,121-150` |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling er ikke relevant for lokale opptak | ikke funnet | P: ikke relevant · A: delvis · M: ikke relevant — regelsidene gir 404 for lokale opptak (`fs-admin/src/app/opptak/[id]/behandlertildelingsregler/layout.tsx:32-35`). Men «Sett saksbehandlertildeling på valgte utdanningstilbud» vises i alle opptak (`OpptakSøknadsalternativer/components/UtdanningstilbudBatchActions/UtdanningstilbudBatchActions.tsx:74-82,117-138`), og regelen kan endres på detaljsiden (`UtdanningstilbudDetails.tsx:222-225,665-679`) |
| `@OPT-OVO-INN-001` | Endre opptakstype | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `OOM:223-225`. I fs-admin er feltet låst ved redigering (`OS:220`), og `CDI:159-180` sender ikke `opptakstypeId`. I MR 3072: `OS:141,185`, `CDI:158-161`, men bare så lenge opptaket ikke har utdanningstilbud |
| `@OPT-OVO-INN-001` | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `OOM:226-237`. I fs-admin er feltet låst ved redigering (`OS:232`), og `regelverksamlingId` sendes bare ved oppretting (`CDI:132`). I MR 3072: `OS:141,206`, `CDI:158-161` |
| `@OPT-OVO-INN-001` | Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:227-230` avviser endringen. `OS:232` låser feltet ved redigering |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:238-242,262-274,462-485`, `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/poeng/PoenglikhetService.java:137-141`, `UTM:279-306`. `OS:295-326`, `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails/UtdanningstilbudDetails.tsx:227-241,687-697` |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel uten mulighet for unntak | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:465-469`, `UTM:300-306`. `CDI:104-110`, `UtdanningstilbudDetails.tsx:698-701` |
| `@OPT-OVO-INN-001` | Sette startnummer for søknader i opptaket | ikke funnet | P: delvis · A: funnet · M: ikke relevant — lagres (`OOM:88,199-201`), men ingen leser verdien. Søknadsnummeret kommer fra en felles sekvens (`SKS:866`, `KID:15`). `OS:258-269`, `CDI:138,173` |
| `@OPT-OVO-INN-001` | Sette maks antall søknadsalternativer | funnet | P: funnet · A: funnet · M: funnet — `SKS:479-485,832-838,974-980`. `OS:270-281`, `CDI:140,175`. `MK/components/application-priorities/valideringsfeil/soknadskladd-validerings-feil.tsx:43-50` |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | usikker | P: delvis · A: funnet · M: funnet — søknaden bruker flagget (`STO:98-118`), men tilbudsgarantien ser bare på flagget til utdanningstilbudet (`TTG:307-310,580-589`). `OS:338-345`, `FK:60-61`. min-kompetanse krever både opptakets og tilbudets flagg (`MK/app/[locale]/soknader/[soknadId]/_utils/has-tidlig-opptak.ts:13-18`), mens fs-plattform krever ett av dem |
| `@OPT-OVO-INN-001` | Sette lenke til informasjon om tidlig opptak | ikke funnet | P: mangler · A: mangler · M: delvis — ingen felt i `OGQL:280-310` eller i migrasjonene. min-kompetanse har lenken hardkodet (`MK/intl/external-url/external-urls.tsx:30-32`). Søkt etter «lenke», «url», «link», «tidlig-opptak.html» og «samordnaopptak.no» i alle tre repoene |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | ikke funnet | P: delvis · A: funnet · M: mangler — lagres (`OOM:208-210`), men all bruk av flagget er på utdanningstilbudet, og søknadsvinduet styres av rundetypen (`OF:105-117`). `OS:331-337`, `FK:69-70`. min-kompetanse har bare mock-data for ledige studieplasser |
| `@OPT-OVO-INN-001` | Legge til utdanningsbakgrunner fra godkjent liste | funnet | P: funnet · A: funnet · M: ikke relevant — `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/utdanningsbakgrunn.graphqls:3,27-36`, `OUB:36-48`. `OS:55-59,156-160,236-253` |
| `@OPT-OVO-INN-001` | Legge til flere utdanningsbakgrunner | ikke funnet | P: funnet · A: funnet · M: delvis — søknaden sjekker valget mot opptakets bakgrunner (`SKS:209-218`, `MIG/V429__soknad_utdanningsbakgrunn_fra_opptak_v2.sql:30-42`). `OM/utils/utdanningsbakgrunnUtils.ts:94-101`. min-kompetanse viser opptakets bakgrunner, men lagrer ikke «Utenlandsk utdanning» (UTLAND) (`MK/app/[locale]/admission/[opptakId]/application/(steps)/background/utdanningsbakgrunn-choices.tsx:54-66`) |
| `@OPT-OVO-INN-001` | Fjerne en utdanningsbakgrunn fra opptaket | funnet | P: funnet · A: funnet · M: ikke relevant — `OUB:72-74` sletter bakgrunner som ikke er med, og `OOM:572-574` gir en egen melding når en søker har valgt bakgrunnen. `OMP:150-157,384-397` |
| `@OPT-OVO-INN-001` | Åpne for dokumentasjonsopplasting | usikker | P: delvis · A: funnet · M: funnet — flagget lagres (`OOM:94,211-213`), men opplastingen leser det ikke (`DLS:76-100`, `SKS:289-314`, `KID:45`). Søkeren kan laste opp, men ikke fordi innstillingen åpner for det |
| `@OPT-OVO-INN-001` | Stenge for dokumentasjonsopplasting | ikke funnet | P: delvis · A: funnet · M: mangler — opplastingen sjekker ikke flagget (`DLS:76-100`, `SKS:289-314`, `KID:18`). Søkt etter «kanLasteOpp» og «kan_laste_opp» i min-kompetanse |
| `@OPT-OVO-FRI-001` | Opptaksforvalter må kunne åpne for tilknytning og redigering av utdanningstilbud | ikke funnet | P: delvis · A: delvis · M: ikke relevant — `REDIGERING_STUDIER_ÅPNER` kan settes (`FK:34`), men `UTM:73-101,324-387` og RLS (`MIG/V280__opptak_v2_skjema.sql:1160-1187`) sjekker ingen dato (`KID:43`) |
| `@OPT-OVO-FRI-001` | Opptaksforvalter må kunne stenge for tilknytning, redigering og trekking av utdanningstilbud | ikke funnet | P: delvis · A: delvis · M: ikke relevant — `REDIGERING_STUDIER_FRIST` kan settes (`FK:35`), men `UTM:344-372` og `slettUtdanningstilbud` (`UTM:374-387`) sjekker verken frist eller plasstildelingsrunde (`KID:19`) |
| `@OPT-OVO-FRI-001` | Sette søknadsdato | ikke funnet | P: delvis · A: funnet · M: delvis — innsending før `SØKING_ÅPNER` avvises (`OF:54-59,150-160`), men tilbudene er synlige fra de opprettes (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudV2Service.java:33-35`, `KID:44`). Finn studier viser dem også (`MK/components/find-studier/_utils/get-search-param-funcs.ts:114-115`). `FK:41` |
| `@OPT-OVO-FRI-001` | Sette ordinær søknadsfrist | funnet | P: funnet · A: funnet · M: ikke relevant — `OF:54-59,105-111` avviser innsending etter fristen (`SKS:800,982`). `FK:42` |
| `@OPT-OVO-FRI-001` | Sette omprioriteringsfrist | funnet | P: funnet · A: funnet · M: ikke relevant — `OF:34-42` avviser endret prioritering etter fristen (`SKS:470`). `FK:48` |
| `@OPT-OVO-FRI-001` | Sette frist for sletting av søknadsalternativer | ikke funnet | P: delvis · A: funnet · M: ikke relevant — `FRIST_SLETTE_STUDIER` kan settes (`FK:49`), men ingen leser den. Sletting stenger ved omprioriteringsfristen (`SKS:470,1274-1285`, `KID:20`) |
| `@OPT-OVO-FRI-001` | Sette ordinær dokumentasjonsfrist | ikke funnet | P: delvis · A: funnet · M: ikke relevant — `FRIST_ORDINÆR_OPPLASTING` kan settes (`FK:55`), men opplastingen sjekker ingen frist (`DLS:76-183`, `SKS:289-322`, `KID:21`) |
| `@OPT-OVO-FRI-001` | Sette ettersendingsfrist | usikker | P: delvis · A: funnet · M: ikke relevant — `OF:24-32` avviser ettersending etter fristen (`SKS:376`). Men `registrerOpplastetDokumentForSoker` kobler dokumentet rett til søknaden når `soknadsId` er med, uten fristsjekk (`DLS:158-170,205-221`). min-kompetanse sender ikke `soknadsId` (`MK/components/file/_mutations/use-mutation-file-upload.ts:185-191`). `FK:56` |
| `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser | ikke funnet | P: funnet · A: funnet · M: mangler — `LEDIGE_STUDIEPLASSER_PUBLISER` lagres og kan leses (`MIG/V280__opptak_v2_skjema.sql:1568`, `OGQL:278`). `FK:72`. min-kompetanse viser ikke datoen (`MK/components/sections/deadlines/use-hendelser-and-date-by-opptak.tsx:22-30`) |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | ikke funnet | P: delvis · A: funnet · M: mangler — `LEDIGE_STUDIEPLASSER_ÅPNER` gjelder først når en runde som ikke er HOVED er publisert (`OF:105-117,136-148`). `FK:73`. Finn studier skjuler tilbud med utløpt ordinær frist (`get-search-param-funcs.ts:115`) |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser stenger for søkning | funnet | P: funnet · A: funnet · M: ikke relevant — etter datoen er vinduet stengt i begge grenene av `OF:105-117` (`SKS:800,982`). `FK:74` |
| `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `STO:66-67` og `OF:44-52`. Etter fristen blir søknaden stående i det ordinære opptaket. `FK:59-66` |
| `@OPT-OVO-FRI-001` | Sette dokumentasjonsfrist for tidlig opptak | ikke funnet | P: funnet · A: funnet · M: mangler — `FRIST_TIDLIGOPPTAK_OPPLASTING` (`MIG/V380__tidlig_frist_kategori.sql:11-13`) settes i `FK:65`, men min-kompetanse leser bare den gamle koden `FRIST_TIDLIG_OPPLASTING` (`MK/components/sections/deadlines/use-hendelser-and-date-by-opptak.tsx:24`) |
| `@OPT-OVO-FRI-001` | Sette frist for poenggrenser for tidlig opptak | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen hendelsestype for fristen, verken i migrasjonene eller i enumen. `FK:62`: «skipped for now». Søkt etter «poenggrense» sammen med «frist», «FRIST_POENG» og «sette poenggrenser» i alle tre repoene |
| `@OPT-OVO-FRI-001` | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | funnet | P: funnet · A: funnet · M: funnet — `PUBLISERING_RESULTAT` (`MIG/V280__opptak_v2_skjema.sql:1567`, `OGQL:278`). `FK:88`. `MK/app/[locale]/admission/[opptakId]/application/confirmation/_components/deadlines.tsx:23-26,45-58` |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | ikke funnet | P: funnet · A: delvis · M: mangler — svarfristen ligger på runden (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpptaksrundeMutations.java:59,114`), og hendelsestypen `SVARFRIST` avvises. Feltet i fs-admin vises ikke (`FK:89-91`, `OM/OpptakDeadlinesSamordna/OpptakDeadlinesSamordna.tsx:190-192`). min-kompetanse viser svarfristen først etter tilbud (`MK/app/[locale]/soknader/_utils/get-soknadsalternativ-svarfrist.ts:8-17`) |
| `@OPT-OVO-FRI-001` | Sette dato for aldersberegning | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:71,179-183`, `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/AldersberegningsdatoUtleder.java:43-49`. `FK:82` |
| `@OPT-OVO-FRI-001` | Standarddato når datoen ikke er satt | funnet | P: funnet · A: funnet · M: ikke relevant — `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/AldersberegningsdatoDefault.java:19-21,34-50` gir 31.12 i publiseringsåret. `OMP:194-200` krever ikke feltet |
| `@OPT-OVO-FRI-001` | Sette frist for at saksbehandler kan endre søkers utdanningsbakgrunn | ikke funnet | P: delvis · A: delvis · M: ikke relevant — fristen avgjør bare om endringen teller i tildelingen (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Utdanningsbakgrunnsfrist.java:28-39`). Overstyringen lagres uansett (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/UtdanningsbakgrunnOverstyringService.java:80-94`), og fs-plattform kaller det et bevisst valg (`KID:23-24`). `FK:80` |
| `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | usikker | P: delvis · A: funnet · M: ikke relevant — fristene lagres per bakgrunn (`OUB:68-115`), og fs-admin har ett kort per bakgrunn (`OM/UtdanningsbakgrunnerAvvikendeFrister/UtdanningsbakgrunnerAvvikendeFrister.tsx:45-50,106-126`). Søknaden leser dem ikke (`OF:191-200`). Regelkommentaren (L146-147) legger det til 13 Søknad og saksbehandling |
| `@OPT-OVO-FRI-001` | Søker uten registrert utdanningsbakgrunn følger ordinære frister | funnet | P: funnet · A: funnet · M: ikke relevant — alle søknader måles mot opptakets egne frister (`OF:54-59,191-200`). `MSG:223,313` |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | ikke funnet (M: ikke relevant) | ikke funnet (M: mangler) | Scenarioet sier at muligheten blir tilgjengelig for søknad, og min-kompetanse har bare mock-data for ledige studieplasser |
| `@OPT-OVO-FRI-001` | Sette ettersendingsfrist | funnet | usikker | `DLS:158-170,205-221` — `registrerOpplastetDokumentForSoker` med `soknadsId` kobler dokumentet til søknaden uten fristsjekk |

## Levert

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-001` | Opprette et opptak | `01 Grunnoppsett/opprett_opptak.feature` | `@in-progress` | 8/8 |

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Samordna opptak | `@in-progress` | 8/11 | 2 ikke funnet, 1 usikker |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | `@in-progress` | 6/15 | 7 ikke funnet, 2 usikker |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | `@in-progress` | 8/21 | 11 ikke funnet, 2 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Navn valideres bare i fs-admin:** API-et godtar `navn: ""` og et opptak uten navn på bokmål, nynorsk eller engelsk (`OOM:83,327-347`, `KID:47-49`). Brukeren avgjorde 2026-10-15 at sperren i fs-admin (`OMP:160-212`) er nok for nå, og ba om at det flagges her.
- **MR 3072:** den dekker «Endre opptakstype» og «Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket» (INN-001) og regelverkssamlingen i «Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger» (SAM-001). Den låser også opptakstypen når opptaket har utdanningstilbud, noe scenarioet ikke krever. Den er laget fra `66ce0295e`, før TAKE-384, og `OS` er endret på main siden, så den må rebases.
- **Samordna opptak er bak et feature-flagg:** `opptak-opprett-samordna` er av som standard (`fs-admin/src/common/types/generated/unleash.ts:25`).
- **Søkeren ser bare bokmålsnavnet:** min-kompetanse leser `opptak.navn`, aldri `oversatteNavn`. Det gjelder regelen «Navn som eksponeres til søkere må kunne angis på flere språk».
- **Ettersending etter fristen gjennom API-et:** se raden «Sette ettersendingsfrist» (`DLS:158-170`).
- **Tidlig opptak tolkes ulikt:** fs-plattform lar søkeren søke når opptaket eller tilbudet tilbyr tidlig opptak (`STO:98-118`), min-kompetanse krever begge (`has-tidlig-opptak.ts:13-18`), og tilbudsgarantien ser bare på tilbudet (`TTG:307-310`).
- **To koder for dokumentasjonsfristen i tidlig opptak:** fs-admin skriver `FRIST_TIDLIGOPPTAK_OPPLASTING` (`MIG/V380__tidlig_frist_kategori.sql:11-13`), min-kompetanse leser `FRIST_TIDLIG_OPPLASTING` (`MIG/V280__opptak_v2_skjema.sql:1579`).
- **Søknadsvinduet kan bytte for tidlig:** publiseres en TIDLIG- eller TEST-runde før søknadsfristen, måles ordinære søknader mot vinduet for ledige studieplasser (`OF:105-117,136-148`).
- **Deltaker kan se «Opprett» for saksbehandlertildelingsregler med direkte URL:** `fs-admin/src/domains/opptak/features/Behandlertildelingsregler/components/BehandlertildelingsreglerResultList.tsx:68-84` sjekker ikke organisasjonen. fs-plattform avviser lagringen.
- **Poenglikhetsregelen «Alle søkere med samme poengsum får tilbud»:** koden `ALLE` kan velges på opptaket (`MIG/V378__poenglikhet_alle_far_tilbud.sql`), men plasstildelingen kjenner den ikke (`fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/plasstildeling/domain/Poenglikhetsregel.java`). Det hører til kravene for plasstildeling.
- **fs-plattforms egen liste over hull:** `KID` (2026-10-05) stemmer fortsatt med de fleste funnene for INN-001 og FRI-001.
- **Krav utenfor scope:** `03 Innstillinger/sette_plassflyt.feature` (`@draft`), `05 Tekster/fellestekster.feature` (`@wont @draft`), `05 Tekster/svarmeldingsmal.feature` (`@wont @draft`) og `06 Hendelseslogg/hendelseslogg.feature` (`@should @draft`) — ikke klare for verifisering, se `fs-krav`.
