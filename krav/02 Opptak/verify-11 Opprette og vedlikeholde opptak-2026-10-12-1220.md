# Verifisering: 11 Opprette og vedlikeholde opptak

- **Dato:** 2026-10-12 12:20
- **Krav:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak` (7 feature-filer)
- **Kode:** `fs-plattform` (5f808f1e09), `fs-admin` (c5718833a), `min-kompetanse` (ddb661fd)
- **Kontroll:** `fs-verify-kontroll`
- **Skjermbilder:** nei (ingen nettleserverktøy i økta)

Gating-sett: scenarioene som ikke er tagget `@draft`, `@deprecated`, `@openquestion` eller `@demo`.

Stiene er forkortet:

- `OOM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpprettOpptakMutations.java`
- `OF` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Opptaksfrister.java`
- `SKS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `OGQL` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/opptak/opptak.graphqls`
- `MIG` = `fs-plattform/opptak/opptak-migrations/` (migrasjonene)
- `SFT` = `fs-plattform/opptak/opptak-subgraph/src/test/java/no/sikt/fs/opptak/funksjonstest/SamordnetOpptakFT.java`
- `OM` = `fs-admin/src/domains/opptak/features/OpptakManagement/`
- `OMP` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakManagementPage.tsx`
- `OS` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSettings/OpptakSettings.tsx`
- `CDI` = `fs-admin/src/domains/opptak/features/OpptakManagement/utils/convertDataToInput.tsx`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-001` | Opprette et opptak | 5/8 | fs-plattform, fs-admin | Navn på bokmål, nynorsk og engelsk: fs-admin kan bare fylle inn bokmål, og ingen av repoene krever nynorsk og engelsk. |
| `@OPT-OVO-SAM-001` | Samordna opptak | 8/11 | fs-plattform, fs-admin | fs-admin kan ikke endre frister og regelverk på et opptak som finnes. fs-plattform hindrer ikke deltakere og saksbehandlertildeling på lokale opptak. |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | 3/17 | fs-plattform, fs-admin, min-kompetanse | Flere innstillinger lagres, men brukes ikke (startnummer, tak for tilbud, ledige studieplasser, dokumentasjonsopplasting, studierett). fs-admin kan ikke endre opptakstype, regelverk, maks søknadsalternativer eller utdanningsbakgrunner. |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | 10/21 | fs-plattform, fs-admin, min-kompetanse | Flere frister lagres, men håndheves ikke (redigering av utdanningstilbud, sletting, ordinær dokumentasjonsfrist, avvikende frister). min-kompetanse viser ikke alle fristene. fs-admin låser fristene når opptaket redigeres. |

Gjenstår: fs-plattform, fs-admin 2, fs-plattform, fs-admin, min-kompetanse 2, ingen 0.

## Oppsummering

- Scenarioer: 26 funnet, 26 ikke funnet, 5 usikker, av 57
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 4
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OVO-GRU-001` | Opprette et samordna opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:65-170` (samordna organisasjoner `:149-155`, organisasjon `:87`), `fs-admin/src/app/opptak/opprett/[type]/page.tsx:8-11`, `CDI:71-90`. Knappen ligger bak feature-flagget `opptak-opprett-samordna` |
| `@OPT-OVO-GRU-001` | Opprette et lokalt opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `OMP:160-162` (`erSamordnet=false`), `OS:54-84`, `OOM:87,99` |
| `@OPT-OVO-GRU-001` | Lagre opptak uten navn | funnet | P: delvis · A: funnet · M: ikke relevant — `OMP:121,299` deaktiverer Lagre. `OGQL:95` `navn: String!`, men tom streng avvises ikke i fs-plattform |
| `@OPT-OVO-GRU-001` | Lagre opptak uten regelverkssamling | funnet | P: funnet · A: funnet · M: ikke relevant — `OMP:123,299`, `OGQL:105` |
| `@OPT-OVO-GRU-001` | Lagre opptak uten opptakstype | funnet | P: funnet · A: funnet · M: ikke relevant — `OMP:122,299`, `OGQL:93`, `OOM:613-618` |
| `@OPT-OVO-GRU-001` | Angi opptaksnavn på flere språk | ikke funnet | P: funnet · A: mangler · M: ikke relevant — fs-plattform har `oversatteNavn` (`OGQL:97,178`, `OOM:334-353`). fs-admin viser nynorsk, engelsk og samisk som deaktiverte «N/A» (`OM/OpptakInformation/OpptakInformation.tsx:49-51`) og sender bare `navn`. Grenen `maada/TAKE-395` i fs-admin er ikke merget |
| `@OPT-OVO-GRU-001` | Lagre opptak med navn på alle obligatoriske språk | ikke funnet | P: delvis · A: mangler · M: ikke relevant — `CDI:71-103` sender bare `navn`. TAKE-395 krever bokmål og nynorsk, men ikke engelsk |
| `@OPT-OVO-GRU-001` | Navn mangler på et obligatorisk språk | ikke funnet | P: mangler · A: delvis · M: ikke relevant — `OOM:166-168,344-349` hopper over tomme språk. fs-admin sjekker bare `navn` (`OMP:121`) |
| `@OPT-OVO-SAM-001` | Legge til lærested i samordna opptak | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:282,547`, `MIG/.../V300__rls_over_paa_auth_claims.sql:52-66`, `SFT:207-216`, `OM/Samordning/Samordning.tsx:73-101` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `MIG/.../V280__opptak_v2_skjema.sql:1160-1165`, `SFT:218-231` |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | ikke funnet | P: funnet · A: delvis · M: ikke relevant — fs-plattform tillater det (`MIG/.../V319__opptak_v2_skriving_krever_forvalter.sql:32-34`, `SFT:233-255`). fs-admin låser regelverk (`OS:182`) og frister (`OMP:277-279`) ved redigering |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger | funnet | P: funnet · A: funnet · M: ikke relevant — `V319:32-34`, `SFT:257-279`, `fs-admin/src/domains/opptak/features/OpptakDetails/OpptakDetails.tsx:62-80` |
| `@OPT-OVO-SAM-001` | Lokalt opptak tillater ikke andre organisasjoner | usikker | P: mangler · A: funnet · M: ikke relevant — fs-admin viser ikke samordning for lokale opptak (`OMP:258`, `CDI:128-130`). fs-plattform sjekker ikke `erSamordnet` (`OOM:149-155,282-288`). Finneren sa ikke funnet, kontrolløren usikker |
| `@OPT-OVO-SAM-001` | Legge til organisasjon som finnes i utdanningsregisteret | funnet | P: funnet · A: funnet · M: ikke relevant — `V280:321-322`, `SFT:287-297`, `OM/Samordning/InviterOrganisasjonerModal.tsx:51-65` |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | funnet | P: funnet · A: funnet · M: ikke relevant — `V280:321`, `OOM:591`, `SFT:299-316` |
| `@OPT-OVO-SAM-001` | Filtrere på universiteter og høyskoler | funnet | P: funnet · A: funnet · M: ikke relevant — `fs-plattform/utdanningsregisteret/.../organisasjon.graphql:277`, `URegOrganisasjonConditions.java:63-77`, `SFT:318-322` |
| `@OPT-OVO-SAM-001` | Filtrere på fagskoler | funnet | P: funnet · A: funnet · M: ikke relevant — samme filter med FAGSKOLE (`SFT:324-328`) |
| `@OPT-OVO-SAM-001` | Sette regler for fordeling av søknader til saksbehandlerorganisasjoner | funnet | P: funnet · A: delvis · M: ikke relevant — `BehandlertildelingService.java:110-137`, `OOM:376-423`, `SFT:330-362`. fs-admin har ikke UI for standardregelen eller behandler per deltaker |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling er ikke relevant for lokale opptak | ikke funnet | P: mangler · A: delvis · M: ikke relevant — `OOM:118-119,314-322` lager tildelingsregel for alle opptak. Feltet på utdanningstilbudet vises også for lokale opptak (`UtdanningstilbudDetails.tsx:591-608`) |
| `@OPT-OVO-INN-001` | Endre opptakstype | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `OOM:229-231` lagrer. `OS:165` deaktivert ved redigering, `CDI:112-126` sender ikke typen |
| `@OPT-OVO-INN-001` | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `OOM:232-243` tillater. `OS:182` alltid deaktivert ved redigering |
| `@OPT-OVO-INN-001` | Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:233-236` avviser endringen |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `OOM:244-280,489-512`, `MIG/.../V379__tillatte_poenglikhetsregler_pa_opptak.sql:74-78`, `RangeringService.java:134-146`, `OS:225-256` |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel uten mulighet for unntak | funnet | P: funnet · A: funnet · M: ikke relevant — `CDI:57-63,124`, `OOM:494-505` |
| `@OPT-OVO-INN-001` | Sette startnummer for søknader i opptaket | ikke funnet | P: mangler · A: funnet · M: ikke relevant — lagres (`OOM:205-207`), men søknadsnummeret kommer fra `soknad_v2.soknadsnummer_seq` (`SKS:839`) |
| `@OPT-OVO-INN-001` | Sette maks antall søknadsalternativer | ikke funnet | P: funnet · A: mangler · M: ikke relevant — håndheves (`SKS:452-458`), men fs-admin sender aldri `maksSoknadsalternativer` (`OS:209-223`, `CDI:71-126`) |
| `@OPT-OVO-INN-001` | Sette tak for antall tilbud en søker kan få per plasstildelingsrunde | ikke funnet | P: mangler · A: funnet · M: mangler — lagres (`OOM:208-210`), ingen plasstildelingskode leser `maksAntallTilbud` |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | usikker | P: delvis · A: funnet · M: funnet — søknaden bruker flagget (`SokTidligOpptakService.java:98-118`), men saksbehandlingen leser bare flagget på utdanningstilbudet (`TidligopptakTilbudsgarantiService.java:263-305`). Finneren sa funnet, kontrolløren usikker |
| `@OPT-OVO-INN-001` | Sette lenke til informasjon om tidlig opptak | ikke funnet | P: mangler · A: mangler · M: mangler — ingen felt. min-kompetanse har en hardkodet lenke (`tidlig-opptak-section.tsx:28`) — søkt etter «lenke», «url», «link» sammen med tidlig opptak |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | ikke funnet | P: delvis · A: funnet · M: ikke relevant — lagres på opptaket (`OOM:214-216`), men bare flagget på utdanningstilbudet leses (`RangeringService.java:138`, `BehandlertildelingService.java:211`) |
| `@OPT-OVO-INN-001` | Legge til utdanningsbakgrunner fra godkjent liste | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `OpptakUtdanningsbakgrunner.java:22-51`. Ingen UI i fs-admin |
| `@OPT-OVO-INN-001` | Legge til flere utdanningsbakgrunner | ikke funnet | P: delvis · A: mangler · M: delvis — lagres i `opptak_v2` (`OpptakUtdanningsbakgrunner.java:72-96`), men søkeren bruker `soknad_v2`, som alltid får NORSK og UTLAND (`OOM:116,358-374`, `SKS:209-216`) |
| `@OPT-OVO-INN-001` | Fjerne en utdanningsbakgrunn fra opptaket | ikke funnet | P: delvis · A: mangler · M: ikke relevant — sletter bare i `opptak_v2` (`OpptakUtdanningsbakgrunner.java:76-78`) |
| `@OPT-OVO-INN-001` | Åpne for dokumentasjonsopplasting | usikker | P: delvis · A: funnet · M: delvis — flagget lagres (`OOM:217-219`), men leses ikke. Opplasting er alltid åpen (`min-kompetanse/.../edit-documentation.tsx:36-41`) |
| `@OPT-OVO-INN-001` | Stenge for dokumentasjonsopplasting | ikke funnet | P: mangler · A: funnet · M: mangler — søkt etter `kanLasteOppDokumenter`, `KAN_LASTE_OPP_DOKUMENTER` i fs-plattform og min-kompetanse |
| `@OPT-OVO-INN-001` | Kreve studierett | ikke funnet | P: mangler · A: funnet · M: mangler — lagres (`OOM:220-222`), ingen kode leser `KREVER_STUDIERETT` |
| `@OPT-OVO-FRI-001` | Opptaksforvalter må kunne åpne for tilknytning og redigering av utdanningstilbud | ikke funnet | P: mangler · A: delvis · M: ikke relevant — `REDIGERING_STUDIER_ÅPNER` finnes bare i kodeverket (`V280:1569`) og enumen |
| `@OPT-OVO-FRI-001` | Opptaksforvalter må kunne stenge for tilknytning, redigering og trekking av utdanningstilbud | ikke funnet | P: mangler · A: delvis · M: ikke relevant — `REDIGERING_STUDIER_FRIST` leses ikke |
| `@OPT-OVO-FRI-001` | Sette søknadsdato | ikke funnet | P: delvis · A: funnet · M: mangler — bare innsending sperres før datoen (`SKS:773`, `OF:57`). Kladd og synlighet styres ikke |
| `@OPT-OVO-FRI-001` | Sette ordinær søknadsfrist | funnet | P: funnet · A: funnet · M: funnet — `OF:54-59`, `SKS:773,955`, `min-kompetanse/.../get-soknadsfrist.ts:22` |
| `@OPT-OVO-FRI-001` | Sette omprioriteringsfrist | funnet | P: funnet · A: funnet · M: funnet — `OF:34-42`, `SKS:443` |
| `@OPT-OVO-FRI-001` | Sette frist for sletting av søknadsalternativer | ikke funnet | P: mangler · A: delvis · M: mangler — `FRIST_SLETTE_STUDIER` brukes ikke |
| `@OPT-OVO-FRI-001` | Sette ordinær dokumentasjonsfrist | ikke funnet | P: mangler · A: funnet · M: delvis — vises (`file-upload-section.tsx:55`), men håndheves ikke (`SKS:262-295`) |
| `@OPT-OVO-FRI-001` | Sette ettersendingsfrist | funnet | P: funnet · A: funnet · M: funnet — `OF:24-32`, `SKS:349` |
| `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser | ikke funnet | P: funnet · A: funnet · M: mangler — `LEDIGE_STUDIEPLASSER_PUBLISER` vises ikke i min-kompetanse (`use-hendelser-and-date-by-opptak.tsx:22-30`) |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | funnet | P: funnet · A: funnet · M: ikke relevant — `OF:113-116,57` |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser stenger for søkning | funnet | P: funnet · A: funnet · M: ikke relevant — `OF:113-116,58` |
| `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak | funnet | P: funnet · A: funnet · M: funnet — `OF:44-52`, `SokTidligOpptakService.java:67`, `use-is-tidlig-opptak-visible.ts:13-24` |
| `@OPT-OVO-FRI-001` | Sette dokumentasjonsfrist for tidlig opptak | usikker | P: funnet · A: funnet · M: delvis — to koder: `FRIST_TIDLIGOPPTAK_OPPLASTING` (`V380__tidlig_frist_kategori.sql:12`) og `FRIST_TIDLIG_OPPLASTING` (`V280:1579`). min-kompetanse viser bare den siste |
| `@OPT-OVO-FRI-001` | Sette frist for poenggrenser for tidlig opptak | ikke funnet | P: mangler · A: mangler · M: ikke relevant — ingen hendelsestype (søkt etter «poenggrense» sammen med «frist» og «tidlig») |
| `@OPT-OVO-FRI-001` | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | funnet | P: funnet · A: funnet · M: funnet — `PUBLISERING_RESULTAT` vises (`confirmation/_components/deadlines.tsx:23-58`) |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | ikke funnet | P: delvis · A: delvis · M: mangler — svarfristen ligger på runden. min-kompetanse viser den bare etter at søkeren har fått svar (`get-soknadsalternativ-svarfrist.ts:17`) |
| `@OPT-OVO-FRI-001` | Sette dato for aldersberegning | funnet | P: funnet · A: funnet · M: ikke relevant — `V384__dato_aldersberegning.sql:12-16`, `OOM:73,187`, `OpptakDeadlineInput.tsx:35-36` |
| `@OPT-OVO-FRI-001` | Standarddato når datoen ikke er satt | funnet | P: funnet · A: funnet · M: ikke relevant — `AldersberegningsdatoDefault.java:19-21,34-50` |
| `@OPT-OVO-FRI-001` | Sette frist for at saksbehandler kan endre søkers utdanningsbakgrunn | usikker | P: delvis · A: delvis · M: ikke relevant — `OppdaterSoknadISoknadsbehandlingService.java:169-175` stopper endring etter fristen for noen bakgrunner, men overstyring lagres uansett (`UtdanningsbakgrunnOverstyringService.java:62-80`). Finneren sa ikke funnet, kontrolløren usikker |
| `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | ikke funnet | P: delvis · A: mangler · M: mangler — lagres (`OpptakUtdanningsbakgrunner.java:98-123`), men ingen søknadskode leser `utdanningsbakgrunn_hendelse` |
| `@OPT-OVO-FRI-001` | Søker uten registrert utdanningsbakgrunn følger ordinære frister | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `OF:54-59` bruker bare opptakets frister. Stemmer fordi ingen kode bruker avvikende frister |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-SAM-001` | Lokalt opptak tillater ikke andre organisasjoner | ikke funnet | usikker | `OMP:258`, `CDI:128-130` — fs-admin stopper det for brukeren, fs-plattform gjør det ikke |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | funnet | usikker | `TidligopptakTilbudsgarantiService.java:263-305` — saksbehandlingen leser ikke flagget på opptaket |
| `@OPT-OVO-FRI-001` | Sette frist for at saksbehandler kan endre søkers utdanningsbakgrunn | ikke funnet | usikker | `OppdaterSoknadISoknadsbehandlingService.java:169-175` — endringen stoppes etter fristen for noen bakgrunner |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OVO-GRU-001` | Opprette et opptak | `@in-progress` | 5/8 | 3 ikke funnet, 0 usikker |
| `@OPT-OVO-SAM-001` | Samordna opptak | `@in-progress` | 8/11 | 2 ikke funnet, 1 usikker |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | `@in-progress` | 3/17 | 12 ikke funnet, 2 usikker |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | `@in-progress` | 10/21 | 9 ikke funnet, 2 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Maks antall søknadsalternativer lagres aldri fra fs-admin:** feltet skriver til `maksAntallUtdanningstilbud`, og `maksSoknadsalternativer` sendes verken ved oppretting eller oppdatering (`OS:209-223`, `CDI:71-126`).
- **fs-admin låser frister, opptakstype og regelverk på et opptak som finnes:** `OMP:277-286` («hendelser-on-edit disabled until bulk endpoint lands»), `OS:165,182`.
- **To tabeller for utdanningsbakgrunn er ute av synk:** det forvalteren legger til, lagres i `opptak_v2.utdanningsbakgrunn`, mens søkeren bruker `soknad_v2.utdanningsbakgrunn`, som alltid får NORSK og UTLAND (`OOM:116,358-374`).
- **Lokale opptak sperres bare i fs-admin:** fs-plattform godtar deltakere og saksbehandlertildeling på lokale opptak (`OOM:149-155,282-288`), og deltakerrader gir skrivetilgang via `V300:52`.
- **To koder for dokumentasjonsfristen i tidlig opptak:** `FRIST_TIDLIG_OPPLASTING` (`V280:1579`) og `FRIST_TIDLIGOPPTAK_OPPLASTING` (`V380__tidlig_frist_kategori.sql:12`). min-kompetanse viser bare den første.
- **Fristen for endring av utdanningsbakgrunn virker annerledes enn kravet:** den gjelder bare noen bakgrunner, og overstyring lagres uansett (`UtdanningsbakgrunnOverstyringService.java:62-80`). `fs-plattform/opptak/docs/krav-11-opptak-ikke-dekket.md:23` kaller det et bevisst valg. Kravet eller koden må endres.
- **Flagget for ledige studieplasser på opptaket brukes ikke:** bare flagget på utdanningstilbudet leses, og vinduet styres av hvilken runde som sist er publisert (`OF:105-117`).
- **Tidlig opptak tolkes ulikt:** fs-plattform slipper søkeren til når opptaket *eller* tilbudet tilbyr tidlig opptak (`SokTidligOpptakService.java:98-118`), min-kompetanse krever begge (`has-tidlig-opptak.ts:13-17`).
- **Tomt opptaksnavn slipper gjennom i fs-plattform:** bare fs-admin stopper det (`OOM:85`).
- **Utdatert dokumentasjon og test-ID i fs-plattform:** `fs-plattform/opptak/docs/krav-11-opptak-ikke-dekket.md` bruker `OPT-OPT-…`-ID-er og mappa `11 Opptak`. `SFT:44` er tagget `OPT-OPT-SAM-001`, men kravet heter `@OPT-OVO-SAM-001`.
- **`@wont` på en `Regel:`:** «Kreve studierett» i `innstillinger.feature` ligger under en regel tagget `@wont`, som ikke tar scenarioet ut av gating-settet. Skal den holdes utenfor, må den tagges `@draft` eller `@deprecated`.
- **Krav utenfor scope:** `05 Tekster/fellestekster.feature` (`@draft`), `05 Tekster/svarmeldingsmal.feature` (`@draft`), `06 Hendelseslogg/hendelseslogg.feature` (`@draft`) — valideres med `fs-krav` før de kan verifiseres.
