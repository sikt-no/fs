# Verifisering: saksbehandlertildeling.feature og kravene flyten bygger på

- **Dato:** 2026-10-22 14:19
- **Krav:** `krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature` (`@FLY-OPT-SAK-001`), og kravene flyten bygger på (`@depends-on-`): `@OPT-OVO-SAM-001`, `@OPT-OVO-FRI-001`, `@OPT-OPT-UTD-004`, `@OPT-BEH-BEH-010`, `@OPT-BEH-BEH-011` (6 feature-filer)
- **Kode:** `fs-plattform` (main, 74ed8c2bfc, oppdatert), `fs-admin` (main, f610b4d30, oppdatert), `min-kompetanse` (main, a74f95da, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 6 kontrollører (`fs-verify-kontroll`), 1–2 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `OPS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `SCH` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `FT` = `fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak/funksjonstest`
- `ALG` = `OPS/saksbehandling/BehandlertildelingAlgoritme.java`
- `BTS` = `OPS/saksbehandling/BehandlertildelingService.java`
- `STS` = `OPS/saksbehandling/SettTilbudsgarantitypeService.java`
- `UOS` = `OPS/saksbehandling/UtdanningsbakgrunnOverstyringService.java`
- `TET` = `OPS/saksbehandling/TilbudsgarantiEndringstekst.java`
- `EAC` = `OPS/saksbehandling/ErAktivConditions.java`
- `TTG` = `OPS/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`
- `MUT` = `OPS/regelverk/BehandlertildelingsregelMutations.java`
- `OOM` = `OPS/opptak/OpprettOpptakMutations.java`
- `UM` = `OPS/opptak/UtdanningstilbudMutations.java`
- `KM` = `OPS/opptak/KvoteMutations.java`
- `UBF` = `OPS/opptak/Utdanningsbakgrunnsfrist.java`
- `KS` = `OPS/plasstildeling/service/KvoterService.java`
- `SKS` = `OPS/soknad/StudiekurvService.java`
- `JOBB` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`
- `UTG` = `SCH/opptak/utdanningstilbud.graphqls`, `KVG` = `SCH/regelverk/kvote.graphqls`, `SAK` = `SCH/saksbehandling/sak.graphqls`, `TIO` = `SCH/saksbehandling/tidligopptak.graphqls`
- `V280`, `V346`, `V395`, `V444`, `V454`, `V455` … = migrasjonene i `MIG` med det nummeret
- `SFT` = `FT/SamordnetOpptakFT.java`, `OFT` = `FT/OpptaksfristerFT.java`
- `ADO` = `fs-admin/src/domains/opptak/features`, `ADS` = `fs-admin/src/domains/soknadsbehandling/features`
- `AMP` = `ADO/OpptakManagement/OpptakManagementPage.tsx`
- `FK` = `ADO/OpptakManagement/OpptakDeadlinesSamordna/fristKort.ts`, `ODS` = `ADO/OpptakManagement/OpptakDeadlinesSamordna/OpptakDeadlinesSamordna.tsx`
- `ODI` = `fs-admin/src/domains/opptak/components/OpptakDeadlineInputs/OpptakDeadlineInput.tsx`
- `AOD` = `ADO/OpptakDetails`
- `BTR` = `ADO/Behandlertildelingsregler`, `EDIT` = `BTR/components/BehandlertildelingsregelEditor.tsx`
- `UD` = `ADO/UtdanningstilbudDetails`, `RF` = `UD/components/RegelverkFelter/RegelverkFelter.tsx`, `KV` = `UD/components/Kvoter/Kvoter.tsx`, `UE` = `UD/hooks/useUtdanningstilbudEndre.tsx`, `UQ` = `UD/UtdanningstilbudDetails.queries.ts`
- `TGS` = `ADS/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx`
- `UBC` = `ADS/UtdanningsbakgrunnCard/UtdanningsbakgrunnCard.tsx`, `ALI` = `ADS/AuditLogCard/AuditLogItem/AuditLogItem.tsx`, `ESV` = `ADS/EndreSoknadView/EndreSoknadView.tsx`, `SOQ` = `ADS/SakOverviewView/SakOverviewView.queries.ts`
- `MSG` = `fs-admin/src/common/messages/nb/opptak.json`
- `MK` = `min-kompetanse/src/app/[locale]`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Samordna opptak | 10/15 | fs-plattform, fs-admin | Lesesperre på opptak for organisasjoner som ikke deltar (i API-et og når siden åpnes direkte). Sperre mot å fjerne en deltaker som har utdanningstilbud. Deltakende organisasjon ser ikke alle innstillingene. |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | 23/25 | fs-plattform, fs-admin | Rekkefølgen på fristene sjekkes ikke (`@draft`). Første svarfrist settes på hovedrunden, ikke på opptaket, og om det er riktig, avhenger av Q19. |
| `@OPT-OPT-UTD-004` | Opptaksinnstillinger per utdanningstilbud | 13/25 | fs-plattform, fs-admin, min-kompetanse | Hovedkvoten, kvotetyper uten kvoteprioritet eller plassflyt, kvoteprioriteten fra regelverkssamlingen (fs-admin skriver en overstyring), visning av plassflyt og kvoteprioritet, fristen for poenggrensen, visningsflaggene for poenggrense og ventelistenummer, og tilbudsgarantikvoten i plasstildelingen. |
| `@OPT-BEH-BEH-010` | Gi tilbudsgaranti | 15/17 | fs-admin | En tilbyder som ikke selv er saksbehandlende organisasjon, kommer ikke til feltet for tilbudsgaranti i fs-admin. |
| `@OPT-BEH-BEH-011` | Tildele saksbehandlende organisasjon | 43/57 | fs-plattform, fs-admin, min-kompetanse | Valget av organisasjon som saksbehandler på vegne av et lærested (fs-admin). Tilbyderens innsyn i saksbehandlingen og tilbudsgarantien. Søkeren kan ikke velge utenlandsk utdanningsbakgrunn, og ser ikke saksbehandlende organisasjon. «Opprett» og organisasjonene for sektoren er ikke avgrenset i fs-admin. Status «Overført» (`@draft`). |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling | 5/8 | fs-admin | Valget av organisasjon som saksbehandler på vegne av et lærested, og tilbyderens vei inn til søknadsalternativet. Flytteksten mangler unntaket for utenlandsk utdanningsbakgrunn. |

Gjenstår: fs-plattform, fs-admin 2, fs-plattform, fs-admin, min-kompetanse 2, fs-admin 2, ingen 0.

## Oppsummering

- Scenarioer: 109 funnet, 28 ikke funnet, 10 usikker, av 147
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 6
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Fremdrift for flyter

Fremdriften kommer fra statusen på kravene fasene bygger på (`@depends-on-`). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Tildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001` (`@in-progress`), `@OPT-BEH-BEH-011` (`@planned`) | nei |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får saksbehandlertildelingsregel | `@OPT-OPT-UTD-004` (`@draft`) | nei |
| `@FLY-OPT-SAK-001` | Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` (`@planned`) | nei |
| `@FLY-OPT-SAK-001` | Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` (`@planned`), `@OPT-BEH-BEH-010` (`@implemented`) | nei |
| `@FLY-OPT-SAK-001` | Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `@OPT-OVO-FRI-001` (`@in-progress`), `@OPT-BEH-BEH-011` (`@planned`) | nei |

`@FLY-OPT-SAK-001`: 0 av 5 faser levert.

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Legge til lærested i samordna opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:572-616` lagrer deltakerne, `V280:1160-1165` og `V300:52-69` lar deltakerne legge til utdanningstilbud, `SFT:205-215`; `ADO/OpptakManagement/Samordning/Samordning.tsx:72-101` (Inviter), `ADO/OpptakManagement/OpptakSøknadsalternativer/OpptakSøknadsalternativer.tsx:61-77` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `V280:1160-1165` (RLS: eier eller deltaker), `SFT:217-230`; `OpptakSøknadsalternativer.tsx:68-77` (`canModify`) |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar, ser ikke opptaket | usikker | P: delvis · A: delvis · M: ikke relevant — `OPS/opptak/OpptakService.java:46-65` filtrerer på eier, deltaker og behandler bare når klienten ber om det, og lesingen er åpen (`V280:1054-1055`). fs-admin sender filteret bare når Unleash-flagget `opptak-filter-organisasjon` er på (`ADO/OpptakOverviewView/hooks/useGetOpptak.tsx:15-25`). Hvordan flagget står i miljøene, går ikke fram av koden |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar, kan ikke åpne opptaket | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `fs-admin/src/app/opptak/[id]/layout.tsx:26-39` gir 404 bare når opptaket ikke finnes, og `[id]/page.tsx:8-21` sjekker ikke organisasjonen; lesingen er åpen (`V280:1054-1055`). Søkt etter «erDeltaker», «deltarIOpptak», «harTilgangTilOpptak», «kanSeOpptak», «SE_OPPTAK», «opptak_opptak_select» i fs-admin og fs-plattform |
| `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `OOM:572-616` sletter deltakere uten å sjekke utdanningstilbud (bare `:586`), ingen FK eller trigger (`V280:312-324`); Fjern vises alltid (`ADO/OpptakManagement/Samordning/components/OrganisasjonCard/OrganisasjonCard.tsx:50-58`, `AMP:421-423`). Søkt etter «kan ikke fjernes», «harUtdanningstilbud», «BEFORE DELETE», «kanFjernes» |
| `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:588-594`, `V319:67-68`; `OrganisasjonCard.tsx:50-58`, `AMP:421-423,313-327` |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | funnet | P: funnet · A: funnet · M: ikke relevant — `V319:32-34,74-92` (`har_forvaltertilgang`), `SFT:232-254`; `fs-admin/src/app/opptak/[id]/rediger/layout.tsx:52-55`, `AOD/OpptakDetails.tsx:73-91` |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger | ikke funnet | P: funnet · A: delvis · M: ikke relevant — Endring er sperret (`V319:32-34`, `SFT:256-278`, `AOD/OpptakDetails.tsx:73-91`). Detaljsiden viser fristene (`AOD/components/OpptakTimeline/OpptakTimeline.tsx:48-75`), men `AOD/queries.ts:3-51` henter ikke de andre innstillingene, og `AOD/OpptakDetails.tsx:113-134` viser tre faste haker |
| `@OPT-OVO-SAM-001` | Lokalt opptak tillater ikke andre organisasjoner | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:79-83,298-302` (`DELTAKERE_BARE_SAMORDNET`), `OOM:343-355`, `SFT:280-284`; `AMP:306-308,430-441` |
| `@OPT-OVO-SAM-001` | Legge til organisasjon som finnes i utdanningsregisteret | funnet | P: funnet · A: funnet · M: ikke relevant — FK i `V280:320-321`, `SFT:286-296`; `ADO/OpptakManagement/Samordning/components/InviterOrganisasjonerModal/InviterOrganisasjonerModal.tsx:49-90` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | funnet | P: funnet · A: funnet · M: ikke relevant — FK i `V280:320-321`, `OOM:682-684` (feilmelding), `SFT:298-315`; fs-admin velger bare fra registeret (`InviterOrganisasjonerModal.tsx:49-90`) |
| `@OPT-OVO-SAM-001` | Filtrere på universiteter og høyskoler | funnet | P: funnet · A: funnet · M: ikke relevant — `InviterOrganisasjonerModal.tsx:43,55,152-159`, `InviterOrganisasjonerModal/components/OrganisasjonFilters/OrganisasjonFilters.tsx:49-51`; `SFT:317-321,375-396` |
| `@OPT-OVO-SAM-001` | Filtrere på fagskoler | funnet | P: funnet · A: funnet · M: ikke relevant — samme filter (`InviterOrganisasjonerModal.tsx:43,55,152-159`); `SFT:323-327` |
| `@OPT-OVO-SAM-001` | Se og navigere til saksbehandlertildelingen for opptaket | usikker | P: funnet · A: delvis · M: ikke relevant — Lenken finnes bare på redigeringssiden (`ADO/OpptakManagement/Samordning/Samordning.tsx:50-60`, `AMP:430-441`, `MSG:193`), ikke på detaljsiden (`AOD/OpptakDetails.tsx`). `design.md` sier ikke hvor lenken skal stå |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling er ikke relevant for lokale opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `MUT:213`, `OOM:404,453`, `SFT:363-373`; `fs-admin/src/app/opptak/[id]/behandlertildelingsregler/layout.tsx:32-35` (404), `AMP:430` |
| `@OPT-OVO-FRI-001` | Sette når redigering av utdanningstilbud åpner | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:40`, `OOM:120-131,745-760`, `OFT:309-328`; `FK:42,82-115`, `ODS:160-161,205-226` |
| `@OPT-OVO-FRI-001` | Sette når redigering av utdanningstilbud stenger | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:41`; `FK:43` |
| `@OPT-OVO-FRI-001` | Sette søknadsdato | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:42`, `OFT:415-436`; `FK:44` |
| `@OPT-OVO-FRI-001` | Sette ordinær søknadsfrist | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:43`, `OFT:438-453`; `FK:45`, `ODI:107` (med klokkeslett) |
| `@OPT-OVO-FRI-001` | Sette omprioriteringsfrist | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:44`, `OFT:455-479`; `FK:46` |
| `@OPT-OVO-FRI-001` | Sette frist for sletting av søknadsalternativer | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:45`; `FK:47` |
| `@OPT-OVO-FRI-001` | Sette ordinær dokumentasjonsfrist | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:46`; `FK:48` |
| `@OPT-OVO-FRI-001` | Sette ettersendingsfrist | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:47`, `OFT:481-504`; `FK:49` |
| `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:51`, `OFT:506-515`; `FK:53`, kortet vises når ledige studieplasser er på (`FK:38`) |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:52`, `OFT:517-529`; `FK:54,38` |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser stenger for søkning | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:53`, `OFT:531-546`; `FK:55,38` |
| `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:48`, `OFT:548-571`; `FK:50,37` |
| `@OPT-OVO-FRI-001` | Sette dokumentasjonsfrist for tidlig opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:49`, én kode (`V439:4-12`, `V444:64`), `OFT:573-586`; `FK:51`, `FK:21,87` |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> når tidlig opptak er aktivert | funnet | P: ikke relevant · A: funnet · M: ikke relevant — Alle 3 radene: `AMP:240-262` gjør de synlige fristene påkrevde, `AMP:270-274,497` sperrer Lagre, `AMP:508` og `MSG:136-138` viser hva som mangler. API-et godtar et opptak uten frister (se *Oppfølging*) |
| `@OPT-OVO-FRI-001` | Sette frist for poenggrenser for tidlig opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:21,50`, `SCH/opptak/opptakshendelse.graphqls:247`; `FK:52`, `ADO/OpptakManagement/utils/hendelseVisibility.ts:9-29` |
| `@OPT-OVO-FRI-001` | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:57`, `OFT:588-596`; `FK:58` |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | usikker | P: delvis · A: delvis · M: ikke relevant — Opptaket har ingen svarfrist (`V138__fjern_svarfrist.sql:5-13`, `OPS/opptak/HendelseInputValidering.java:28-39`, `FK:59` gir aldri et felt). Svarfristen settes på hovedrunden (`V280:372`, `fs-admin/src/domains/plasstildeling/features/OpprettRundeForm/OpprettRundeForm.tsx:45`), og `OFT:597-610` har scenariotittelen og tester den. Det er alternativet i Q19, som ikke er besvart |
| `@OPT-OVO-FRI-001` | Sette dato for aldersberegning | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:55`, `SCH/opptak/opptakshendelse.graphqls:238`; `FK:57`, `ODI:44-45,107` (valgfritt, bare dato) |
| `@OPT-OVO-FRI-001` | Standarddato når datoen ikke er satt | funnet | P: funnet · A: funnet · M: ikke relevant — `OPS/opptak/AldersberegningsdatoDefault.java:19-21,34-50` (31.12 i publiseringsåret), `OOM:73,185-189`; fs-admin sender ikke tomme frister (`ADO/OpptakManagement/utils/convertDataToInput.tsx:22-25,77`) |
| `@OPT-OVO-FRI-001` | Sette frist for endring av utdanningsbakgrunn | funnet | P: funnet · A: funnet · M: ikke relevant — `V444:54`; `FK:56` |
| `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | funnet | P: funnet · A: funnet · M: ikke relevant — `OPS/opptak/OpptakUtdanningsbakgrunner.java:83-112`; `ADO/OpptakManagement/utils/utdanningsbakgrunnUtils.ts:16-19,72-101`, `…/AvvikendeFristKort/AvvikendeFristKort.tsx:84-85` |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> | funnet | P: ikke relevant · A: funnet · M: ikke relevant — Alle 10 radene: fristene i kortene uten valg (`V444:40-47,54,57`) legges inn tomme (`ODS:160-161`) og er påkrevde (`AMP:240-262,270-274`), etikettene i `MSG:128-144`. API-et godtar et opptak uten frister (se *Oppfølging*) |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> når ledige studieplasser er aktivert | funnet | P: ikke relevant · A: funnet · M: ikke relevant — Alle 3 radene: `V444:51-53`, `FK:38`, `hendelseVisibility.ts:9-10`, `AMP:240-262,270-274`, `MSG:139-141` |
| `@OPT-OVO-FRI-001` | Dato for aldersberegning og avvikende frister kan stå tomme | funnet | P: funnet · A: funnet · M: ikke relevant — `AldersberegningsdatoDefault.java:34-43`; `AMP:243-246`, `ODI:44-45`, `AvvikendeFristKort.tsx:57` (`isRequired={false}`) |
| `@OPT-OVO-FRI-001` | Den ordinære søknadsfristen kan ikke være før søknaden åpner | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `AMP:187-274` sjekker bare at fristene er satt, `ODI:85-116` bare at datoen er hel. `OPS/opptak/Opptaksfrister.java:24-90` sjekker fristene når søkeren handler, ikke når opptaket lagres. Søkt etter «isBefore», «isAfter», «minValue», «maxValue», «må være etter», «kan ikke være før», «rekkefølge» i fs-admin og fs-plattform |
| `@OPT-OPT-UTD-004` | Sette regelverk på ett utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:318-391`, `OPS/regelverk/kvalifisering/KvalifiseringDescent.java:110-125`, `OPS/plasstildeling/service/KvotesumService.java:185-199`; `RF:139-170` |
| `@OPT-OPT-UTD-004` | Kun regelverk fra opptakets regelverkssamling kan velges | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:333-342,1363-1375` (batch `UM:813-842`); `RF:47-50`, `UQ:3-37` |
| `@OPT-OPT-UTD-004` | Rettigheter for oppretting av nye regelverk | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:349-351`; `RF:72-80` (bare eksisterende, aktive regelverk), `fs-admin/src/domains/opptak/utils/kanEndreUtdanningstilbud.ts:22-27` |
| `@OPT-OPT-UTD-004` | Legge til utdanningskvoter fra regelverkssamlingen | funnet | P: funnet · A: funnet · M: ikke relevant — `KM:60-95` (batch `KM:97-172`); `KV:65-95,142-154`, `UE:337-359` |
| `@OPT-OPT-UTD-004` | Utdanningstilbudet må ha hovedkvoten | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Hovedkvote finnes ikke som begrep; `KM:192-249` sjekker bare regelverkssamling, duplikater og garantikvoter. Søkt etter «hovedkvote», «hoved_kvote», «standardkvote», «default_kvote», «mainQuota», «påkrevd/obligatorisk kvote» i fs-plattform og fs-admin, og i kolonnene til kvotetype (`V4:364`, `V189:113-141`, `KVG:141-160`) |
| `@OPT-OPT-UTD-004` | Hovedkvoten kan ikke fjernes fra utdanningstilbudet | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Søkt som over. `KM:411-419,493-497` stopper bare sletting av tilbudsgarantikvoten, og `KV:97-111` lar alle kvoter fjernes |
| `@OPT-OPT-UTD-004` | Fjerne en utdanningskvote fra utdanningstilbudet | funnet | P: funnet · A: funnet · M: ikke relevant — `KM:486-508` (batch `KM:359-440`); `KV:97-111`, `UE:329-335` |
| `@OPT-OPT-UTD-004` | Kvotetyper som ikke er i regelverkssamlingen, kan ikke legges til | funnet | P: funnet · A: funnet · M: ikke relevant — `KM:80-83`, FK `kvote_utdanningstilbud_regelverksamling_fk` (`V280:875-880`), `KM:223-232`; `KV:65-78` |
| `@OPT-OPT-UTD-004` | Kvotetype uten <mangler> kan ikke legges til | ikke funnet | P: mangler · A: mangler · M: ikke relevant — Ingen av radene: `kvoteprioritet_default` og `kvotetype_kode_plassflyt` kan være tomme (`V4:364`, `KVG:153-156`), og `KM:60-95,174-186,192-249` sjekker dem ikke. Søkt etter «kvoteprioritet_default», «kvotetype_kode_plassflyt», «plassflyt», triggere og CHECK i migrasjonene |
| `@OPT-OPT-UTD-004` | Regelverksforvalter legger til en kvotetype i regelverkssamlingen | funnet | P: funnet · A: funnet · M: ikke relevant — `KVG:28-33`, `OPS/regelverk/kvotetype/KvotetypeMutations.java:38-55`; `fs-admin/src/domains/regelverk/features/Kvoteregelverk/Kvoteregelverk.tsx:120-135` |
| `@OPT-OPT-UTD-004` | Utdanningskvotene får kvoteprioriteten fra regelverkssamlingen | ikke funnet | P: delvis · A: mangler · M: ikke relevant — `KS:96-97` bruker kvotetypens prioritet bare når kvoten ikke har en overstyring, og API-et tar imot en overstyring (`UTG:402-403,453-454`, `KM:85,333-335`). fs-admin skriver plassen i lista som overstyring (`KV:92`, `UE:347,382`), så ORDF og ORD får 1 og 2, ikke 2 og 3 |
| `@OPT-OPT-UTD-004` | Utdanningskvotene følger plassflyten i regelverkssamlingen | funnet | P: funnet · A: funnet · M: ikke relevant — `KS:88-89`, `OPS/plasstildeling/algoritme/Opptakskjoringsalgoritme.java:390-411`; ingen API eller UI setter overstyringen av plassflyten (bare `KM:465-474` nullstiller den), `UE:342-351` |
| `@OPT-OPT-UTD-004` | Se plassflyten for et utdanningstilbud | ikke funnet | P: funnet · A: mangler · M: ikke relevant — API-et har plassflyten (`UTG:473`, `KVG:211`). fs-admin viser den ikke: `KV:206-264` har ikke kolonnen, og `UQ:205-217` henter den ikke. Søkt etter «plassflyt», «kvoteflyt», «flytTil» i hele fs-admin og i `src/common/messages` |
| `@OPT-OPT-UTD-004` | Kvoter som ikke er på utdanningstilbudet, vises ikke i plassflyten | ikke funnet | P: ikke relevant · A: mangler · M: ikke relevant — Plassflyten vises ikke i fs-admin (se raden over) |
| `@OPT-OPT-UTD-004` | Se kvoteprioriteten for et utdanningstilbud | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `KVG:212` gir kvotetypens prioritet. Kolonnen «Prioritet» (`KV:212`) viser overstyringen eller plassen i lista (`UD/utils/skjema.ts:64`), og `UQ:205-217` henter ikke `kvotetype { kvoteprioritet }` |
| `@OPT-OPT-UTD-004` | Lærestedet kan ikke endre plassflyten eller kvoteprioriteten | ikke funnet | P: delvis · A: delvis · M: ikke relevant — Plassflyten kan ikke endres (ingen API eller UI). Kvoteprioriteten kan endres: `UTG:402-403,453-454`, `KM:85,333-335`, og fs-admin skriver den fra rekkefølgen (`KV:92,100-102`, `UE:347,382`) |
| `@OPT-OPT-UTD-004` | Markere at utdanningstilbudet tilbyr tidlig opptak | funnet | P: funnet · A: funnet · M: funnet — `UM:290-316` (avvises uten tidlig opptak, `UM:294-298`), `TTG:320-323`; `UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:94-104`; `MK/soknader/[soknadId]/_utils/has-tidlig-opptak.ts:13-18` |
| `@OPT-OPT-UTD-004` | Sette poenggrense for tidlig opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:301-304`, `TTG:731`; `TidligFristOgOpptak.tsx:131-140` |
| `@OPT-OPT-UTD-004` | Lærestedet kan ikke endre poenggrensen for tidlig opptak etter fristen | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `FRIST_TIDLIGOPPTAK_POENGGRENSE` finnes bare som frist (`V444:21`, `SCH/opptak/opptakshendelse.graphqls:247`, `FK:52`), og `UM:290-316` sjekker den ikke. Låsen i fs-admin (`UD/UtdanningstilbudDetails.tsx:108-109`, `fs-admin/src/domains/opptak/utils/redigeringsfase.ts`) bruker fristen for redigering av utdanningstilbud. Søkt etter «FRIST_TIDLIGOPPTAK_POENGGRENSE», «poenggrensefrist», «frist.*poenggrense» |
| `@OPT-OPT-UTD-004` | Velge saksbehandlertildelingsregel for et utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:367-380` (bare samordna, `UM:371-376`), `BTS:200-224`; `RF:165-176` |
| `@OPT-OPT-UTD-004` | Utdanningstilbud uten egen saksbehandlertildelingsregel følger opptakets standardregel | funnet | P: funnet · A: funnet · M: ikke relevant — `BTS:110,223`; `RF:168,178-181` |
| `@OPT-OPT-UTD-004` | Kun aktive saksbehandlertildelingsregler i opptaket kan velges | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:343-365` (batch `UM:844-857`); `UQ:55-65` (`erAktiv: true`) |
| `@OPT-OPT-UTD-004` | Velge å vise poenggrense for søker | ikke funnet | P: delvis · A: funnet · M: mangler — `UM:253-273` lagrer flagget, og `UD/components/Opptaksinnstillinger/Opptaksinnstillinger.tsx:52-56` har bryteren, men ingen leser flagget (bare `UregStudieprogramService.java:270-274`). min-kompetanse viser poenggrensen uten vilkår (`MK/soknader/_queries/soknader-query.tsx:32`). Søkt etter «VIS_POENGGRENSE_FOR_SOKER», «visPoenggrense» i alle tre repoene |
| `@OPT-OPT-UTD-004` | Velge å vise ventelistenummer for søker | ikke funnet | P: delvis · A: funnet · M: mangler — `UM:260`, `Opptaksinnstillinger.tsx:59-63`; `OPS/soknad/opptakssvar/OpptakssvarService.java:213-228` ser ikke på flagget, og min-kompetanse henter ventelistenummeret uten vilkår (`soknader-query.tsx:50`). Søkt etter «VIS_VENTELISTENUMMER_FOR_SOKER», «visVentelistenummer» |
| `@OPT-OPT-UTD-004` | Sette hvor tilbudsgarantier tas fra | ikke funnet | P: delvis · A: funnet · M: ikke relevant — Lagres (`KM:90-92,510-528`) og vises (`KV:237-245`), men plasstildelingen leser ikke tilbudsgarantikvoten: tilbudsgarantien går via søknadsalternativet (`OPS/plasstildeling/…/RangertKvotesoknadService.java:94-96`, `Opptakskjoringsalgoritme.java:442-476`). `TILBUDSGARANTI_KVOTE` brukes bare i tidligopptaket (`TTG:300-319`) og til visning |
| `@OPT-BEH-BEH-010` | Sette tilbudsgaranti i feltet for rollen | usikker | P: funnet · A: delvis · M: ikke relevant — `TIO:163-184`, `STS:21-33,114-115` for alle tre rollene. Feltene er i `TGS:305-337`, men bare i saken (`SakDrawer`). Lesepolicyen på `sak` (`V454:35-40`) har ingen gren for tilbyderen, så en tilbyder som ikke også saksbehandler, kommer ikke til feltet (`STS:126-131`). Saksbehandler og opptaksforvalter er bekreftet |
| `@OPT-BEH-BEH-010` | Bare tilbudsgarantitypene for rollen kan velges | funnet | P: funnet · A: funnet · M: ikke relevant — `STS:74-84`; `TGS:275-298` |
| `@OPT-BEH-BEH-010` | Saksbehandler ser ikke muligheten til å sette tilbudsgaranti som tilbyder eller opptaksforvalter | funnet | P: funnet · A: funnet · M: ikke relevant — `V346:152-170`; `TGS:231-242`, `edit=` i `TGS:308,319,330` (skrivebeskyttet felt) |
| `@OPT-BEH-BEH-010` | Se tilbudsgarantiene fra alle rollene | funnet | P: funnet · A: funnet · M: ikke relevant — `SAK:763-767`; `TGS:43-63,305-337`, `fs-admin/src/common/messages/nb/soknadsbehandling.json:755-758` |
| `@OPT-BEH-BEH-010` | Sette tilbudsgaranti når søknaden ikke kan poengberegnes | usikker | P: funnet · A: delvis · M: ikke relevant — `STS:67-124` ser ikke på poengberegningen. Handlingen gjøres av tilbyderen i fs-admin, som ikke kommer til saken når tilbyderen ikke selv saksbehandler (`V454:35-40`) |
| `@OPT-BEH-BEH-010` | Endre tilbudsgaranti | funnet | P: funnet · A: funnet · M: ikke relevant — `STS:114-118`; `TGS:161-172,311-313` |
| `@OPT-BEH-BEH-010` | Fjerne tilbudsgaranti | funnet | P: funnet · A: funnet · M: ikke relevant — `TIO:163`, `STS:73-74,114-115`; `TGS:167,280` |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien fra en annen rolle blir stående | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `STS:114-115` skriver bare kolonnen for rollen, og `V346` stopper endringer i de andre |
| `@OPT-BEH-BEH-010` | Opptaksforvalter ser ikke muligheten til å endre tilbudsgarantien fra saksbehandler | funnet | P: funnet · A: funnet · M: ikke relevant — `V346:137-149`; `TGS:231-234,308` |
| `@OPT-BEH-BEH-010` | Bare tilbudsgarantitypene i opptaket kan velges | funnet | P: funnet · A: funnet · M: ikke relevant — `STS:75-84`; `TGS:65-78,244-250` |
| `@OPT-BEH-BEH-010` | Se hvem som har satt tilbudsgarantien | funnet | P: funnet · A: funnet · M: ikke relevant — `STS:101-112`, `TET:35-39,55-62`, `SAK:179-190`; `ALI:59-80` |
| `@OPT-BEH-BEH-010` | Se hvem som har fjernet tilbudsgarantien | funnet | P: funnet · A: funnet · M: ikke relevant — `TET:32-33`, `STS:101-112`; `ALI:59-80` |
| `@OPT-BEH-BEH-010` | Se hvilken tilbudsgarantitype som ble satt | funnet | P: funnet · A: funnet · M: ikke relevant — `TET:35-39,43-52`; `ALI:80` |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet når prioriteten endres | funnet | P: funnet · A: ikke relevant · M: ikke relevant — Alle tre radene: `SKS:1296-1331` endrer prioriteten uten å røre `sak_soknadsalternativ`, `BTS:200-225,390-397` |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon | funnet | P: funnet · A: ikke relevant · M: ikke relevant — Alle tre radene: `BTS:451-467` kopierer tilbudsgarantien fra behandler (`:456-458`, STEK-626), forvalter (`:459-461`) og tilbyder (`:462-464`) |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien faller bort når søknadsalternativet fjernes | funnet | P: funnet · A: ikke relevant · M: ikke relevant — Begge radene: `SKS:1296-1302,612-618`, `EAC:37-45` |
| `@OPT-BEH-BEH-010` | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen | funnet | P: funnet · A: ikke relevant · M: ikke relevant — Begge radene: `SKS:1312-1331` (`slettet = null`, `SKS:1328`), `EAC:37-45` |
| `@OPT-BEH-BEH-011` | Opprette saksbehandlertildelingsregel | funnet | P: funnet · A: funnet · M: ikke relevant — `MUT:38-56,123-136`; `EDIT:262-303,345-438` |
| `@OPT-BEH-BEH-011` | Nytt opptak får standard saksbehandlertildelingsregel med «Alle som deltar i opptaket» | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `OOM:120-121,367-379` (regelen «ORD», `behandles_av_alle`, aktiv) |
| `@OPT-BEH-BEH-011` | Bytte standard saksbehandlertildelingsregel | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:399-443`, `BTS:110,223`; `BTR/components/BehandlertildelingsregelStandard.tsx:37,116-166` |
| `@OPT-BEH-BEH-011` | Opptaket kan bare ha én aktiv saksbehandlertildelingsregel med «Alle som deltar i opptaket» | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `V395:87-90` (unik indeks `WHERE behandles_av_alle AND er_aktiv`) |
| `@OPT-BEH-BEH-011` | Se hvilke utdanningstilbud som er knyttet til saksbehandlertildelingsregelen | funnet | P: funnet · A: funnet · M: ikke relevant — `EDIT:218-233`, `BTR/hooks/useGetBehandlertildelingsregelUtdanningstilbud.tsx:14-15`, `BTR/components/BehandlertildelingsregelUtdanningstilbudResultList.tsx:66-73` |
| `@OPT-BEH-BEH-011` | Slette saksbehandlertildelingsregel som ikke er knyttet til utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `MUT:103-121`; `EDIT:235-262,482-502` |
| `@OPT-BEH-BEH-011` | Saksbehandlertildelingsregel som er knyttet til utdanningstilbud kan ikke slettes | funnet | P: funnet · A: funnet · M: ikke relevant — FK i backend (`IBrukError`, `EDIT:245-246`); `EDIT:482` viser slettknappen bare når regelen ikke er i bruk |
| `@OPT-BEH-BEH-011` | Saksbehandlertildelingsregel som <bruk> kan ikke deaktiveres | funnet | P: funnet · A: funnet · M: ikke relevant — Begge radene: `MUT:83-86,179-196`; `EDIT:314` |
| `@OPT-BEH-BEH-011` | Tildelingsreglene er ikke tilgjengelige i lokale opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `MUT:203-214`, `OOM:404`; `fs-admin/src/app/opptak/[id]/behandlertildelingsregler/layout.tsx:32-35` |
| `@OPT-BEH-BEH-011` | Deltakende lærested kan ikke endre tildelingsreglene | ikke funnet | P: funnet · A: delvis · M: ikke relevant — RLS `V395:128-146` avviser. fs-admin skjuler endring og sletting (`EDIT:155-157`), men «Opprett» (`BTR/components/BehandlertildelingsreglerResultList.tsx:68-84`) sjekker rollen i alle organisasjoner (`fs-admin/src/features/WithRole/useWithRole.ts:41-47`), så opptaksforvalteren ved UiO kommer til skjemaet (`BTR/OpprettBehandlertildelingsregelPage.tsx:21`) |
| `@OPT-BEH-BEH-011` | Lærestedet på første prioritet saksbehandler hele søknaden | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `ALG:212-238` |
| `@OPT-BEH-BEH-011` | Søknadsalternativ med egen saksbehandlertildelingsregel avgjør ikke hvem som saksbehandler resten av søknaden | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `ALG:182-186` (ISOLERT sprer ikke), `ALG:212-221` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler søknadsalternativene uten egen saksbehandlertildelingsregel | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `ALG:196-199` og `spreTilAvAlle` |
| `@OPT-BEH-BEH-011` | Tilbyderen søkeren har prioritert høyest saksbehandler søknadsalternativene uten egen saksbehandlertildelingsregel | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `ALG:188-199` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `ALG:182-186,212-221` |
| `@OPT-BEH-BEH-011` | Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `BTS:200-224,246-249`, `ALG:182-186` |
| `@OPT-BEH-BEH-011` | Tilbyderen søkeren har prioritert høyest i sektoren saksbehandler hele sektoren | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `ALG:200-208,268-281` |
| `@OPT-BEH-BEH-011` | Organisasjonen som er valgt på saksbehandlertildelingsregelen saksbehandler hele sektoren | funnet | P: funnet · A: funnet · M: ikke relevant — `ALG:203-205`, `BTS:233-236`; `EDIT:423-434`, `BTR/components/BehandlertildelingsregelSektorOrganisasjonCombobox.tsx:66-76` |
| `@OPT-BEH-BEH-011` | Søknadsalternativer i ulike sektorer fordeles hver for seg | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `ALG:196-209,229-233` |
| `@OPT-BEH-BEH-011` | Sektoren er lærestedene som har utdanningstilbud med samme saksbehandlertildelingsregel | funnet | P: funnet · A: funnet · M: ikke relevant — `BTS:200-224`, `ALG:203-206`; `RF:82-91,164-176` |
| `@OPT-BEH-BEH-011` | Søkerens prioritering avgjør hvem som saksbehandler søknadsalternativene uten egen saksbehandlertildelingsregel | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `ALG:188-195` sorterer TILBYDER og SEKTOR sammen etter prioritet (STEK-571) |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren kan velge <organisasjon> som organisasjon for sektoren | funnet | P: funnet · A: funnet · M: ikke relevant — Begge radene: `MUT:42-43,221-239` (deltaker og opptakets egen organisasjon, `MUT:222`), `ALG:203-205`; `EDIT:423-434` |
| `@OPT-BEH-BEH-011` | Organisasjonen for sektoren må delta i opptaket | ikke funnet | P: funnet · A: mangler · M: ikke relevant — Backend avviser (`MUT:221-239`). Kombinasjonsboksen henter alle organisasjoner (`BehandlertildelingsregelSektorOrganisasjonCombobox.tsx:15-28,46-48`), så UiB står blant valgene |
| `@OPT-BEH-BEH-011` | Legge til unntak for utdanningsbakgrunn | funnet | P: funnet · A: funnet · M: ikke relevant — `MUT:51-53,90-98,138-173`, `BTS:347-363`, `ALG:150-179`; `BTR/components/BehandlertildelingsregelUnntak.tsx:86-120,175-204`, `EDIT:465-469` |
| `@OPT-BEH-BEH-011` | HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn <utdanningsbakgrunn> | funnet | P: funnet · A: ikke relevant · M: ikke relevant — Begge radene: `BTS:128,347-363`, `ALG:157-178` |
| `@OPT-BEH-BEH-011` | Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `V407:16-27` (`behandles_tilbyder` på REAL og DISP), `BTS:126-127,340-345`, `ALG:162`, `MUT:150-161` |
| `@OPT-BEH-BEH-011` | Unntaket går foran saksbehandlertildelingsregel der bare tilbyderen saksbehandler | usikker | P: delvis · A: ikke relevant · M: ikke relevant — `ALG:133,150-178,194`: Utøvende musikk, NTNU går til HK-dir. Med unntaket bare på «SPE», som `Gitt` sier, får Informatikk, UiO likevel UiO (`ALG:16-20,212-221,244`). «HK-dir for begge» stemmer bare når standardregelen har det samme unntaket, og det står ikke i `Gitt` eller `Bakgrunn:` |
| `@OPT-BEH-BEH-011` | Saksbehandlertildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig | usikker | P: delvis · A: ikke relevant · M: ikke relevant — `ALG:157-160,182-186`: NTNU for Utøvende musikk, som scenarioet sier. HK-dir for Informatikk, UiO krever unntaket på standardregelen (`BTS:347-363`), som ikke står i `Gitt` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler alltid søknadsalternativ til ledig studieplass | funnet | P: funnet · A: ikke relevant · M: funnet — `V434:5-7`, `SKS:1302-1315,1337-1350`, `ALG:139-148`; `MK/_mutations/update-soknad/use-update-soknad.ts:24` |
| `@OPT-BEH-BEH-011` | Ledig studieplass går foran unntak for utdanningsbakgrunn | funnet | P: funnet · A: ikke relevant · M: funnet — `ALG:131-133,152-156`; `use-update-soknad.ts:24` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler ledig studieplass som legges til på vegne av søkeren | funnet | P: funnet · A: funnet · M: ikke relevant — `OPS/soknad/oppdatersoknad/OppdaterSoknadISoknadsbehandlingService.java:78`, `SKS:1043-1098,1337-1340`; `ESV:73` |
| `@OPT-BEH-BEH-011` | Velge organisasjon som saksbehandler på vegne av lærestedet når lærestedet legges til i opptaket | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `OOM:447-488` (`settSamordnaDeltakerBehandler`). Ingen UI i fs-admin kaller den: søkt etter «settSamordnaDeltakerBehandler», «SamordnaDeltakerBehandler», «behandlerOrganisasjon», «organisasjonskodeBehandler», «på vegne av» i `fs-admin/src` og `messages/nb` |
| `@OPT-BEH-BEH-011` | Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `BTS:123,136,259-267` |
| `@OPT-BEH-BEH-011` | Organisasjonen som saksbehandler på vegne av lærestedet må delta i opptaket | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `OOM:466-482` avviser; fs-admin har ikke valget (se raden over) |
| `@OPT-BEH-BEH-011` | Endret valg gjelder bare søknadsalternativer som ikke er fordelt | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `BTS:124,138`, `ALG:262-266`; fs-admin har ikke valget |
| `@OPT-BEH-BEH-011` | Søknadsalternativene fordeles når <hendelse> | funnet | P: funnet · A: funnet · M: funnet — Alle tre radene: `SKS:525,898,1006,1091`, `JOBB:311-312` → `BTS:93`; `ESV:73`; `MK/admission/[opptakId]/application/(steps)/summary/_components/submit-soknad-button.tsx:32,59`, `use-update-soknad.ts:24` |
| `@OPT-BEH-BEH-011` | Søknaden får én sak per saksbehandlende organisasjon | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `BTS:378-398,481-510` |
| `@OPT-BEH-BEH-011` | Tilbyder som ikke er saksbehandlende organisasjon får ingen sak | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `BTS:387,495-509` |
| `@OPT-BEH-BEH-011` | Ny prioritering endrer ikke saksbehandlende organisasjon | funnet | P: funnet · A: ikke relevant · M: funnet — `SKS:525`, `ALG:169,262-266`; `use-update-soknad.ts:24` |
| `@OPT-BEH-BEH-011` | Nytt søknadsalternativ uten egen saksbehandlertildelingsregel får samme saksbehandlende organisasjon som før | funnet | P: funnet · A: ikke relevant · M: funnet — `BTS:129,365-372`, `ALG:217,268-273`; `use-update-soknad.ts:24` |
| `@OPT-BEH-BEH-011` | Nytt søknadsalternativ der bare tilbyderen saksbehandler endrer ikke søknadsalternativene som er fordelt | funnet | P: funnet · A: ikke relevant · M: funnet — `ALG:196-199,229-233`; `use-update-soknad.ts:24` |
| `@OPT-BEH-BEH-011` | Sletting av søknadsalternativet fordelingen bygget på endrer ikke de andre søknadsalternativene | funnet | P: funnet · A: ikke relevant · M: funnet — `BTS:138,217,638-658`, `ALG:262-266`; `use-update-soknad.ts:24` |
| `@OPT-BEH-BEH-011` | Søkeren bytter til utenlandsk utdanningsbakgrunn | ikke funnet | P: funnet · A: ikke relevant · M: mangler — fs-plattform flytter (`V355:46-50` `omfordel_b_rolle` på UTLAND, `ALG:169-170`, `BTS:422-468`). Søkeren kan ikke velge Utenlandsk: `MK/admission/[opptakId]/application/(steps)/background/utdanningsbakgrunn-choices.tsx:50-65` sender bare koder i `UtdanningsbakgrunnInputKode`, som er IB, NORDISK, NORSK, REAL og STEINER (`SCH/soknad/utdanningsbakgrunn.graphqls:113-120`), og dropper resten uten melding |
| `@OPT-BEH-BEH-011` | Søkeren bytter til realkompetanse | funnet | P: funnet · A: ikke relevant · M: funnet — `V348:24-26`, `V407:25-27`, `BTS:126-127,340-345`, `ALG:162,169-170`; `utdanningsbakgrunn-choices.tsx:43-65` (REAL kan sendes, bak flagget `enable-utdanningsbakgrunn-step`) |
| `@OPT-BEH-BEH-011` | Bytte fra <utdanningsbakgrunn> til norsk utdanningsbakgrunn flytter ingen søknadsalternativer | funnet | P: funnet · A: ikke relevant · M: funnet — Begge radene: norsk har verken `omfordel_b_rolle` eller `behandles_tilbyder` (`V348:24-26,34-35`, `V355:46-49`), så `ALG:169` flytter ingenting; `utdanningsbakgrunn-choices.tsx:43-65` |
| `@OPT-BEH-BEH-011` | Saksbehandleren endrer utdanningsbakgrunnen til <utdanningsbakgrunn> | funnet | P: funnet · A: funnet · M: ikke relevant — Begge radene: `UOS:62,84-96`, `V355:41-44`, `BTS:126-127,313-333`, `ALG:162,169-170`; `UBC:170-182,200` |
| `@OPT-BEH-BEH-011` | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen <frist> | funnet | P: funnet · A: funnet · M: ikke relevant — Begge radene: `UBF:27-38` (en frist som ikke er satt, regnes som utløpt, `:36`), `UOS:88`, `BTS:313-321`; `UBC:200` |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen | usikker | P: delvis · A: delvis · M: ikke relevant — Fristen gjelder ikke opptaksforvalteren (`UBF:37,40-42`). Men skrivingen krever også `MODIFISERE_SØKNADSBEHANDLING` (`V455:20-23`, `UBC:149-152`), og `V454:8-9` sier at opptaksforvalteren ikke har den. Om en opptaksforvalter ved HK-dir har rollen, går ikke fram av koden |
| `@OPT-BEH-BEH-011` | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `BTS:413-415,432-467` (tilbudsgarantiene følger med, `:456-464`) |
| `@OPT-BEH-BEH-011` | Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til | ikke funnet | P: delvis · A: delvis · M: ikke relevant — Statusen «Overført» finnes ikke (`V291:2063-2066`). Dokumentene er uleste hos den nye organisasjonen: `OPS/saksbehandling/SaksdokumentSyncService.java:26-55` lager nye rader per organisasjon, og fs-admin viser det (`ADS/SakOverviewView/…/SakOverviewTable.tsx:179-181`, `…/DokumenterCard/DocumentItem/DocumentItem.tsx:35,44`). Søkt etter «overført», «overfort», «transferred» i alle tre repoene |
| `@OPT-BEH-BEH-011` | Saksbehandleren ser bare saken hos organisasjonen sin | funnet | P: funnet · A: funnet · M: ikke relevant — `V454:35-40`; `SOQ:17-24` (`sakerV2`) |
| `@OPT-BEH-BEH-011` | Søkeren ser saksbehandlende organisasjon, men ikke sakene | ikke funnet | P: delvis · A: ikke relevant · M: mangler — Søkeren ser ikke sakene (ingen søkergren i `V454:35-51`), men ingen felt gir saksbehandlende organisasjon per søknadsalternativ. min-kompetanse viser opptakets organisasjon som kontakt (`MK/soknader/[soknadId]/_components/contact-information/contact-organisasjon-name.tsx:14-22`). Søkt etter «behandlerOrganisasjon», «organisasjonskodeBehandler», «saksbehandl», «behandlende», «caseworker» i min-kompetanse og i `*.graphqls` |
| `@OPT-BEH-BEH-011` | Saksbehandleren ved forvaltende organisasjon ser bare saken hos forvaltende organisasjon | funnet | P: funnet · A: funnet · M: ikke relevant — `V454:20-40` (alle sakene krever også `MODIFISERE_OPPTAK`); `SOQ:17-24` |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner | funnet | P: funnet · A: funnet · M: ikke relevant — `V454:20-28,35-40`; `SOQ:17-24` |
| `@OPT-BEH-BEH-011` | Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler | ikke funnet | P: delvis · A: mangler · M: ikke relevant — Tilbyderen kan lese `sak_soknadsalternativ` (`V454:42-51`), men ikke `sak` (`V454:35-40`). Alle visningene i fs-admin går via en sak (`SakDrawer`, `sakerV2`). Søkt etter «sakSoknadsalternativ», «tilbyder» i `fs-admin/src/domains/opptak` og `src/domains/soknadsbehandling` |
| `@OPT-BEH-BEH-011` | Tilbyderen setter tilbudsgaranti | ikke funnet | P: funnet · A: mangler · M: ikke relevant — Backend: `STS:62-65,67-123`, `V346`. I fs-admin ligger valget bare i saken (`TGS:235-238,317-323`, under `app/opptak/[id]/soknadsbehandling/sak/[sakId]`), og UiT har ingen sak når «Historie, UiT» er fordelt til UiO (`V454:35-40`) |
| `@OPT-BEH-BEH-011` | Tilbyderen kan ikke endre saksbehandlingen | usikker | P: funnet · A: mangler · M: ikke relevant — Kolonnevernet (`V346`) lar tilbyderen bare skrive tilbudsgarantien fra tilbyder. Men `Når` (tilbyderen ser «Historie, UiT») kan ikke gjøres i fs-admin (se «Tilbyderen ser søknadsalternativ …»), så `Så` stemmer bare fordi tilbyderen ikke ser noe |
| `@FLY-OPT-SAK-001` | Lærestedene kan velge saksbehandlertildelingsregelen opptaket har satt opp | funnet | P: funnet · A: funnet · M: ikke relevant — lages: `MUT:38-56` (`regelverk.behandlertildelingsregel`, ISOLERT `:130`), `V395:130-136`; `EDIT:79-81,189` · brukes: `UQ:55-64` (aktive regler i opptaket, samme tabell), `RF:164-176`, NTNU får endre tilbudene sine (`V300:52-69`, `V307:62-66`, `fs-admin/src/domains/opptak/utils/kanEndreUtdanningstilbud.ts:22-27`) |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får saksbehandlertildelingsregelen fra opptaket | funnet | P: funnet · A: funnet · M: ikke relevant — lages: `MUT:48` (`er_aktiv` på regelen) · brukes: `UM:318-385` avviser regel fra et annet opptak (`:343`) og inaktiv regel (`:352-364`), og skriver `UTDANNINGSTILBUD.BEHANDLERTILDELINGSREGEL_KODE` (`:380`); `UE:142` |
| `@FLY-OPT-SAK-001` | Søknaden blir én sak hos hver saksbehandlende organisasjon | funnet | P: funnet · A: ikke relevant · M: funnet — lages: `UM:380`, `OOM:121`; innsending `MK/admission/[opptakId]/application/(steps)/summary/_components/submit-soknad-button.tsx:59` → `SKS:898-903` · brukes: `JOBB:265-312` → `BTS:200-225` leser regelkoden på tilbudet, `ALG:182-186,212-238`, én sak per organisasjon (`BTS:481-510`) |
| `@FLY-OPT-SAK-001` | Organisasjonen som saksbehandler på vegne av lærestedet får saken | ikke funnet | P: funnet · A: mangler · M: funnet — lages: `OOM:447-488` (`opptak_samordna_organisasjon.organisasjonskode_behandler`) · brukes: `BTS:136,259-267,481-510`. Ingen UI i fs-admin kaller `settSamordnaDeltakerBehandler`, så opptaksforvalteren kan ikke lage tilstanden i `Gitt`. Søkt etter «settSamordnaDeltakerBehandler», «SamordnaDeltaker», «behandlerOrganisasjon», «på vegne av» i `fs-admin/src` |
| `@FLY-OPT-SAK-001` | Saksbehandleren ved den saksbehandlende organisasjonen ser saken | funnet | P: funnet · A: funnet · M: ikke relevant — lages: `BTS:500-507` (`saksbehandling.sak.organisasjonskode`) · brukes: `V454:35-40` (RLS på samme felt), `SOQ:17-59` (`sakerV2`) |
| `@FLY-OPT-SAK-001` | Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler | ikke funnet | P: funnet · A: mangler · M: ikke relevant — lages: `BTS:391-397` (`sak_soknadsalternativ.organisasjonskode_behandler`) · brukes i backend: `STS:62-124`, `V454:42-62`, `V346:152-160`. I fs-admin ligger valget bare i saken (`TGS:236`, `SAK:127`), og lesepolicyen på `sak` (`V454:35-40`) har ingen gren for tilbyderen. Søkt etter «TILBGARANTI_GI_VIA_UTDTILBUD», «settTilbudsgarantitypeFraTilbyder», «sakSoknadsalternativer» |
| `@FLY-OPT-SAK-001` | Søknadsalternativene flyttes til HK-dir før fristen for endring av utdanningsbakgrunn | usikker | P: funnet · A: funnet · M: ikke relevant — lages: fristen `FRIST_SELVBETJENING_UTDANNINGSBAKGRUNN` (`FK:56`, `OOM:756`, `V355`) · brukes: `UBC:200,231-247` → `UBF:27-38`, `UOS:62,88-96`, `BTS:313-334,444,451`, `ALG:150-180`. HK-dir står ikke i koden: målet kommer fra et unntak for utenlandsk utdanningsbakgrunn på regelen (`BTS:347-363`), og uten unntaket flyttes ingenting (`ALG:157-162`). Flyten setter ikke opp unntaket |
| `@FLY-OPT-SAK-001` | Søknadsalternativene blir hos organisasjonen etter fristen for endring av utdanningsbakgrunn | funnet | P: funnet · A: funnet · M: ikke relevant — lages: fristen i `OPPTAKSHENDELSE` (som raden over) · brukes: `UBF:35-37` gir false etter fristen, `UOS:62,88` lagrer `b_rolle_overstyr = false`, og `BTS:314-319` bruker bare overstyringer som er sanne; `UBC:243-247` |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | ikke funnet | usikker | `OFT:597-610` tester svarfristen på hovedrunden under denne scenariotittelen. Det er alternativet i Q19, som ikke er besvart |
| `@OPT-BEH-BEH-010` | Sette tilbudsgaranti i feltet for rollen | funnet | usikker | `V454:35-40`: tilbyderen kan ikke lese saken, og feltet finnes bare i saken (`TGS`, `SakDrawer`). Gjelder eksempelet med tilbyder |
| `@OPT-BEH-BEH-010` | Sette tilbudsgaranti når søknaden ikke kan poengberegnes | funnet | usikker | Samme grunn: tilbyderen gjør handlingen i fs-admin, og kommer ikke til saken |
| `@OPT-BEH-BEH-011` | Søkeren bytter til utenlandsk utdanningsbakgrunn | funnet | ikke funnet | `utdanningsbakgrunn-choices.tsx:50-65` og `UtdanningsbakgrunnInputKode` (`SCH/soknad/utdanningsbakgrunn.graphqls:113-120`): søkeren kan ikke sende Utenlandsk |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen | funnet | usikker | `V455:20-23` og `UBC:149-152` krever også `MODIFISERE_SØKNADSBEHANDLING`, som opptaksforvalteren ikke har ifølge `V454:8-9` |
| `@OPT-BEH-BEH-011` | Tilbyderen setter tilbudsgaranti | usikker | ikke funnet | Kan avgjøres fra koden: valget ligger bare i saken, og tilbyderen kan ikke lese saken (`V454:35-40`) |
| `@OPT-BEH-BEH-011` | Tilbyderen kan ikke endre saksbehandlingen | funnet | usikker | `Så` stemmer bare fordi tilbyderen ikke ser noe av saken. `Når` kan ikke gjøres i fs-admin |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Samordna opptak | `@in-progress` | 10/15 | 3 ikke funnet, 2 usikker |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | `@in-progress` | 23/25 | 1 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-004` | Opptaksinnstillinger per utdanningstilbud | `@draft` | 13/25 | 12 ikke funnet, 0 usikker |
| `@OPT-BEH-BEH-010` | Gi tilbudsgaranti | `@implemented` | 15/17 | 0 ikke funnet, 2 usikker |
| `@OPT-BEH-BEH-011` | Tildele saksbehandlende organisasjon | `@planned` | 43/57 | 10 ikke funnet, 4 usikker |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling | `@planned` | 5/8 | 2 ikke funnet, 1 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Kjente brudd i flyten:** `@FLY-OPT-SAK-001` har to overleveringer som mangler i fs-admin: valget av organisasjon som saksbehandler på vegne av et lærested (`OOM:447-488` har ingen UI), og tilbyderens vei inn til søknadsalternativet en annen organisasjon saksbehandler (`V454:35-40`). Foreslås skrevet som kjent brudd i flyten med `fs-krav` (modus E).
- **Flyten mangler unntaket:** «Søknadsalternativene flyttes til HK-dir før fristen …» virker bare når regelen har et unntak som sender utenlandsk utdanningsbakgrunn til HK-dir (`BTS:347-363`, `ALG:157-162`, testet i `BehandlertildelingUtdanningsbakgrunnIT.java:37-43`). `Bakgrunn:` og `Gitt` setter det ikke opp. Rettes med `fs-krav`.
- **Samme mangel i OPT-BEH-BEH-011:** «Unntaket går foran …» og «Saksbehandlertildelingsregel uten unntak …» stemmer bare når standardregelen også har unntaket «Utenlandsk → HK-dir». Forslag til steg: `Og at standard saksbehandlertildelingsregel har unntak som fordeler "Utenlandsk" til HK-dir`.
- **Utdaterte kommentarer i kravene:** `gi_tilbudsgaranti.feature` (linje 185-189) sier at koden bare kopierer tilbudsgarantien fra tilbyder og opptaksforvalter (STEK-626), men `BTS:456-458` kopierer også den fra behandler. `tildele_saksbehandlende_organisasjon.feature` (linje 186-188) sier at koden gir SPE forrang, men `ALG:188-195` sorterer på prioritet. Ryddes med `fs-krav`.
- **OPT-BEH-BEH-010 er `@implemented`, men tilbyderen kommer ikke til feltet:** backend lar tilbyderen sette tilbudsgaranti (`STS:62-124`), men i fs-admin finnes feltet bare i saken, som tilbyderen ikke kan lese når en annen organisasjon saksbehandler (`V454:35-40`). Statusen er ikke endret. Det samme mangler i OPT-BEH-BEH-011 og i flyten.
- **Fristene håndheves bare i fs-admin:** API-et godtar et opptak uten frister (`OOM:71-83,745-760`, `OPS/opptak/HendelseInputValidering.java:29-39`, og `OFT:311` oppretter et opptak uten frister). De tre «Opptaket kan ikke lagres uten …»-scenarioene er `funnet` fordi fs-admin sperrer lagringen. Kontrolløren mener regelen også hører hjemme i fs-plattform. En `@integration`-test mot API-et vil feile.
- **Søkerens egen endring av utdanningsbakgrunn har ingen frist:** `UBF` kalles bare fra `UOS:62,179` og `OppdaterSoknadISoknadsbehandlingService.java:171`, ikke når søkeren endrer kladden (`SKS:985-993`). Det svarer på et av de åpne spørsmålene i OPT-BEH-BEH-011.
- **Unleash-flagg:** listen over opptak filtreres bare når `opptak-filter-organisasjon` er på (`ADO/OpptakOverviewView/hooks/useGetOpptak.tsx:15-25`), og søkerens steg for utdanningsbakgrunn på en innsendt søknad står bak `enable-utdanningsbakgrunn-step` (`MK/soknader/[soknadId]/_components/studier-steps-context-loader/studier-steps-context-loader.tsx:33-43`). Hvordan flaggene står i miljøene, er ikke sjekket.
- **Deltaker kan bare legge til utdanningstilbud mens søknaden er åpen:** `OpptakSøknadsalternativer.tsx:74-77` (`fase === 'apen'`). Scenarioet «Legge til lærested i samordna opptak» har ingen slik betingelse.
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Tildelingsreglene settes for opptaket» — Er «tildelingsreglene» et samlebegrep for saksbehandlertildelingsreglene, standardregelen og unntakene, eller skal ordet byttes? Skal flyten bruke «UVH», så testdataene betyr det samme i flyten og i kravet?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Utdanningstilbudet får saksbehandlertildelingsregel» — Skal fase 1 slutte med at «SPE» er aktiv i opptaket, eller skal de to fasene slås sammen?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Søknaden blir én sak hos hver saksbehandlende organisasjon» — Holder det med de to siste stegene?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Organisasjonen som saksbehandler på vegne av lærestedet får saken» — Skal scenarioet få steget `Gitt at "Arkitektur- og designhøgskolen i Oslo" og "OsloMet" deltar i opptaket`? Koden krever det (`OOM:466-482`).
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Den saksbehandlende organisasjonen ser saken» — Skal scenarioet om tilbudsgaranti flyttes til en egen fase, eller skal regeltittelen utvides? Hvilken overlevering skal fasen vise?
- **Åpent spørsmål:** `@OPT-OVO-SAM-001` — Fire regler spør om referanser: `@ref-OPT-OPT-UTD-001` («Organisasjoner som ikke deltar, kan ikke se opptaket»), `@ref-OPT-OPT-UTD-026` («En deltakende organisasjon kan ikke fjernes …»), `@ref-OPT-BEH-BEH-011` («… se og navigere til saksbehandlertildelingen …»), og om ordlyden om forvaltende organisasjon er utvetydig nok for tilgangsstyringen.
- **Åpent spørsmål:** `@OPT-OVO-FRI-001` «Sette første svarfrist som informasjon til søkere» — (Q19, TAKE-414) Er første svarfrist svarfristen på hovedrunden, eller en egen dato på opptaket?
- **Åpent spørsmål:** `@OPT-OVO-FRI-001` «Fristene må komme i riktig rekkefølge» (`@draft @openquestion`) — Hvilke frister må ligge før andre? Skal opptaket ikke kunne lagres når rekkefølgen er feil, eller skal opptaksforvalteren bare få en advarsel?
- **Åpent spørsmål:** `@OPT-OVO-FRI-001` — De andre reglene spør om referanser (`@ref-OPT-OPT-UTD-002/-003/-004/-007`, `@ref-OPT-SØK-SØK-001/-003/-006/-009/-011/-013/-014`, `@ref-OPT-BEH-BEH-008/-011`).
- **Åpent spørsmål:** `@OPT-OPT-UTD-004` «Rettigheter for oppretting av nye regelverk» — Skal bare opptaksforvalter ved forvaltende organisasjon få opprette nye kompetanse- og rangeringsregelverk, og deltakende organisasjon bare bruke eksisterende?
- **Åpent spørsmål:** `@OPT-OPT-UTD-004` «Opptaksforvalter kan styre visning av poenggrense og ventelistenummer» — Er det lov å overstyre visningen i samordna opptak, og bør det være opptaksinnstillinger i stedet?
- **Åpent spørsmål:** `@OPT-OPT-UTD-004` — De andre reglene spør om referanser (`@ref-OPT-OVO-INN-001`, `OPT-PLA-INN-001/-002`, `OPT-BEH-BEH-007/-014`, `@depends-on-OPT-OVO-FRI-001` på fristen for poenggrensen, og referansene i fritekst under egenskapen).
- **Åpent spørsmål:** `@OPT-BEH-BEH-010` — Skal kravet ha `@ref-OPT-BEH-BEH-007`, regelen «Tilbudsgarantien følger søknadsalternativet» `@ref-OPT-PLA-TIL-002`, og scenarioet om flytting `@depends-on-OPT-BEH-BEH-011`?
- **Åpent spørsmål:** `@OPT-BEH-BEH-011` «Opptaksforvalteren ved forvaltende organisasjon setter opp tildelingsreglene for opptaket» — Er «tildelingsreglene» et samlebegrep, eller skal ordet byttes?
- **Åpent spørsmål:** `@OPT-BEH-BEH-011` «Søknaden får én sak per saksbehandlende organisasjon» — «Når søknadsalternativene er fordelt» er en tilstand, ikke en handling. Hvilken handling er det?
- **Åpent spørsmål:** `@OPT-BEH-BEH-011` «Søknadsalternativene flyttes når utdanningsbakgrunnen endres …» — Gjelder fristen også søkerens egen endring? Skal regelen ha `@depends-on-OPT-OVO-FRI-001`?
- **Åpent spørsmål:** `@OPT-BEH-BEH-011` «Flyttet søknadsalternativ vises som overført …» (`@draft @openquestion`) — Skal statusen «Overført» og uleste dokumenter være med, og i så fall her eller i et eget krav?
- **Ingen `@e2e` for flyten:** det finnes ingen test for overleveringene, verken i `tester/steps/`, `cdp-tester/` eller kode-repoene. Ingen av de fem kravene har step definitions i `tester/steps/`.
