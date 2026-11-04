# Verifisering: krav/02 Opptak/12 Utdanningstilbud/02 Utdanningstilbud i opptak

- **Dato:** 2026-10-22 19:15
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/02 Utdanningstilbud i opptak/` (4 feature-filer)
- **Kode:** `fs-plattform` (main, bbd797a3b9, oppdatert), `fs-admin` (main, 6a5c26a9e, oppdatert), `min-kompetanse` (main, f70409ca, oppdatert)
- **Omfang:** alle krav uansett status (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 4 finnere (`fs-verify-krav`), 12 kontrollører (`fs-verify-kontroll`), 2–7 feature-filer per finner
- **Skjermbilder:** nei
- **Confluence:** https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137367045

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `UM` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `UR` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Utdanningstilbudredigering.java`
- `USS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/klient/ureg/UregStudieprogramService.java`
- `SVC` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak`
- `SG` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `UREG` = `fs-plattform/utdanningsregisteret`
- `FA` = `fs-admin/src/domains/opptak`
- `OS` = `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakSøknadsalternativer`
- `UD` = `fs-admin/src/domains/opptak/features/UtdanningstilbudDetails`
- `AF` = `fs-admin/src/domains/opptak/features/AddUtdanningstilbud`
- `MSG` = `fs-admin/src/common/messages/nb/opptak.json`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak | 5/7 | fs-admin | «Fjern» skjules når redigeringsfristen er passert, ikke når opptaket har åpnet for søknad. Derfor ser opptaksforvalteren «Fjern» etter søknadsåpning så lenge redigeringen er åpen, og forvaltende organisasjon mister «Fjern» etter redigeringsfristen. |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak | 8/16 | fs-plattform, fs-admin | Begge repoene holder redigeringen åpen når åpningsdatoen ikke er satt (kravet sier stengt). Opptaket har ingen kriterier for utdanningstype og nivå, legg til-dialogen har ikke filter på utdanningstype eller NKR 5.1/5.2, og ingen jobb oppdaterer tilbudene fra utdanningsregisteret. «Velg alle» velger bare de 50 radene som er lastet. |
| `@OPT-OPT-UTD-001` | Listevisning og søk i utdanningstilbud i opptaket | 6/12 | fs-plattform, fs-admin | Deltakende organisasjon ser alle tilbudene i opptaket (lesepolicyen er `USING (true)`). Statusen «Har mangler» tar bare med kompetanseregelverk, rangeringsregelverk og minst én kvote, ikke kvoteprioritet, plassflyt, tilbudsgaranti, tidlig søknadsfrist eller poenggrense for tidlig opptak. |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak | 2/5 | fs-plattform, fs-admin, min-kompetanse | Deltakende organisasjon har ingen trekk-knapp i fs-admin, og fs-plattform avviser den når redigeringen er stengt. Trekk styres av at opptaket er publisert og redigeringen stengt, ikke av søknadsåpningen. Søkerne varsles ikke (delen er `@draft @openquestion`). |

Gjenstår: fs-plattform, fs-admin 2, fs-admin 1, fs-plattform, fs-admin, min-kompetanse 1, ingen 0.

## Oppsummering

- Scenarioer: 21 funnet, 17 ikke funnet, 2 usikker, av 40
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 23
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-026` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | Regel: Opptaksforvalter ved deltakende organisasjon kan fjerne utdanningstilbud organisasjonen tilbyr, fram til redigeringsfristen. Ikke levert, `@OPT-OPT-UTD-026` kan ikke leveres før dette |
| `@OPT-OPT-UTD-002` | `@OPT-OPT-UTD-005` Hente utdanninger fra utdanningsregisteret | 1 | `@draft` | – | Regel: Opptaksforvalter ser kun utdanningstilbud som matcher opptakets kriterier. Ikke levert, `@OPT-OPT-UTD-002` kan ikke leveres før dette |
| `@OPT-OPT-UTD-002` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | Regel: Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering. Ikke levert, `@OPT-OPT-UTD-002` kan ikke leveres før dette |

Avhengigheter: 2 på nivå 1, 2 av dem ikke `@implemented`.

## Scenarioer

I `Bevis` står **P** for fs-plattform, **A** for fs-admin og **M** for min-kompetanse, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud før søknadsåpning | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1120-1161` sletter bare når opptaket er `UPUBLISERT`; `OS/components/UtdanningstilbudActions/UtdanningstilbudActions.tsx:127-137`, `OS/hooks/useUtdanningstilbudBatchActions.ts:495-523` (kaller `slettUtdanningstilbudV3`, `OS/queries.ts:169-181`) |
| `@OPT-OPT-UTD-026` | Fjerne flere utdanningstilbud av gangen før søknadsåpning | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1121-1125,1156` sletter en liste i én setning; `OS/hooks/useUtdanningstilbudBatchActions.ts:503-505` sender alle valgte rader |
| `@OPT-OPT-UTD-026` | Muligheten til å fjerne utdanningstilbud vises ikke etter søknadsåpning | ikke funnet | P: ikke relevant · A: mangler · M: ikke relevant — `OS/components/UtdanningstilbudActions/UtdanningstilbudActions.tsx:127-137` skjuler «Fjern» bare når `redigeringErStengt` (`OS/OpptakSøknadsalternativer.tsx:144`, `FA/utils/redigeringsfase.ts:17-26`); opptaksstatusen brukes bare i `OS/components/OpptakTopBar/OpptakTopBar.tsx:94`. Søkt etter «publiser», «opptaksstatus», «SOKNAD_APNER», «slettUtdanningstilbud» i fs-admin |
| `@OPT-OPT-UTD-026` | Fjerning av utdanningstilbud etter søknadsåpning avvises | funnet | P: funnet · A: ikke relevant · M: ikke relevant — `UM:1142-1150` kaster `UtdanningstilbudOpptakErPublisertException` før sletting |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen | funnet | P: funnet · A: funnet · M: ikke relevant — `UR:28-35` slipper gjennom i redigeringsvinduet, DELETE-policyen `MIG/V280__opptak_v2_skjema.sql:1182-1186`; `FA/utils/kanEndreUtdanningstilbud.ts:22-27` |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen | funnet | P: funnet · A: funnet · M: ikke relevant — `UR:28-35` avviser alle som ikke er forvalter etter fristen; `OS/OpptakSøknadsalternativer.tsx:75-77,138-153` (`erLåstAvFrist` gir ingen handlinger) |
| `@OPT-OPT-UTD-026` | Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `UR:31,97-101` unntar forvalteren; men `OS/components/UtdanningstilbudActions/UtdanningstilbudActions.tsx:127-137` fjerner «Fjern» for alle når redigeringsfristen er passert, og testen `UtdanningstilbudActions.test.tsx:176` låser det |
| `@OPT-OPT-UTD-002` | Legge til enkelttilbud fra organisasjonen opptaksforvalter er ved | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:131-159`, `USS:147-158` sjekker at tilbyderen eier eller deltar; `FA/utils/utdanningsinstansFilterUtil.ts:55-67`, `AF/components/AddUtdanningstilbudAddButton.tsx:32-48` |
| `@OPT-OPT-UTD-002` | Legge til flere utdanningstilbud av gangen | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:132-139` tar en liste; `AF/components/AddUtdanningstilbudAddButton.tsx:32-48` sender alle valgte, «Legg til ({count})» (`MSG:500`) |
| `@OPT-OPT-UTD-002` | Legge til alle utdanningstilbudene i en filtrert liste | usikker | P: funnet · A: delvis · M: ikke relevant — «velg alle» (`AF/components/AddUtdanningstilbudResultList.tsx:59,72` → `fs-admin/src/common/components/lists/components/HeaderSelection/HeaderSelection.tsx:32-54`) velger bare radene som er lastet (`AF/hooks/useGetUtdanningsinstanserState.tsx:15`, PAGE_SIZE 50). Med flere enn 50 treff må opptaksforvalter laste inn alle først. Søkt etter «selectAllMatching», «velgAlle», «alle treff» |
| `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon | funnet | P: funnet · A: funnet · M: ikke relevant — insert-policyen `MIG/V280__opptak_v2_skjema.sql:1160-1165`, `USS:182-188`; `FA/utils/utdanningsinstansFilterUtil.ts:63-64` |
| `@OPT-OPT-UTD-002` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `USS:147-158` avviser («eier ikke og deltar ikke»), FK `MIG/V461__utdanningstilbud_tilbyder_i_opptaket.sql:65-69`, `UM:1372-1383`; `FA/utils/utdanningsinstansFilterUtil.ts:55-67` viser bare eierens og deltakernes tilbud (det holder etter AVKLART 2026-10-22) |
| `@OPT-OPT-UTD-002` | Se relevante utdanningstilbud | ikke funnet | P: mangler · A: mangler · M: ikke relevant — opptaket har ingen kriterier for utdanningstype eller nivå; fs-admin har bare et startfilter brukeren kan endre (`FA/utils/utdanningsinstansFilterUtil.ts:6-7`, med TODO «Dette stemmer bare for samordna UHG-opptak», `AF/hooks/useGetUtdanningsinstanserState.tsx:37-43`). Søkt etter «kriteri», «opptakskriter», «tillatt_(studie\|niva\|nkr\|utdanning)», «opptak_nkr», «utdanningstype» |
| `@OPT-OPT-UTD-002` | Filtrere på utdanningstype | ikke funnet | P: delvis · A: mangler · M: ikke relevant — filtrene i `AF/components/AddUtdanningstilbudFilter.tsx:28-72` har ikke utdanningstype; `QueryUtdanningsinstanserFilterInput` (`UREG/utdanningsregisteret-graphql-spec/src/main/resources/schema/features/beta/utdanningsinstans.graphql:155-180`) har den ikke, bare utdanningsmulighet (`…/beta/utdanningsmulighet.graphql:160`) |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for UHG-opptak | ikke funnet | P: delvis · A: delvis · M: ikke relevant — studienivåfilteret Høgskolekandidat/Bachelor/Master (`AF/components/filter/UtdanningsinstansStudienivaFilter/UtdanningsinstansStudienivaFilter.tsx:22-29`) gir NKR 6.1/6.2/7 (`UREG/utdanningsregisteret-service/src/main/java/no/utdanningsregisteret/conditions/UtdanningsintansConditions.java:98-100`), men utdanningstypen «studieprogram» mangler |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for HYU-opptak | ikke funnet | P: delvis · A: mangler · M: ikke relevant — `StudienivaInput` (`…/beta/utdanningsinstans.graphql:191-204`) har ikke 5.1/5.2; nkrkode-filteret (`…/beta/utdanningsinstans.graphql:169`) sendes ikke fra fs-admin (`AF/hooks/useGetUtdanningsinstanser.tsx:134-142`) |
| `@OPT-OPT-UTD-002` | Utdanninger utenfor filteret vises ikke | ikke funnet | P: delvis · A: delvis · M: ikke relevant — Bachelor (6.2) holder master ute (`UtdanningsintansConditions.java:99`), men «emner vises ikke» krever filteret på utdanningstype, som ikke finnes |
| `@OPT-OPT-UTD-002` | Kan ikke knytte utdanningstilbud til opptaket før redigering åpner | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:144` → `UR:28-35`, `UR:55-57` (`harIkkeApnet`); `FA/utils/redigeringsfase.ts:20-21`, `OS/OpptakSøknadsalternativer.tsx:75-77,138-153` skjuler handlingene |
| `@OPT-OPT-UTD-002` | Redigering er stengt når åpningsdatoen ikke er satt | ikke funnet | P: mangler · A: mangler · M: ikke relevant — koden gjør det motsatte: `UR:55-57` (`aapner != null && …`), `UR:17-18` («En hendelse som ikke er satt, stenger ingenting»), `SG/opptak/opptakshendelse.graphqls:260` («Ikke satt betyr at redigeringen er åpen»), testen `UtdanningstilbudredigeringTest.java:72`; `FA/utils/redigeringsfase.ts:20,26` gir `apen` |
| `@OPT-OPT-UTD-002` | Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering | funnet | P: funnet · A: funnet · M: ikke relevant — `UR:63-65` (`erApent`), `UM:144`, `UM:988-991`; `OS/OpptakSøknadsalternativer.tsx:75-77`, `UD/UtdanningstilbudDetails.tsx:110-121` |
| `@OPT-OPT-UTD-002` | Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger | funnet | P: funnet · A: funnet · M: ikke relevant — `UR:28-35` avviser etter fristen (fra `UM:144,172,188,254,991`), antall studieplasser via `UR:41-51`; `OS/OpptakSøknadsalternativer.tsx:75-77` skjuler handlingene (det holder etter AVKLART 2026-10-22), `UD/UtdanningstilbudDetails.tsx:107,123,322-325` lar bare antall studieplasser stå redigerbart |
| `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger | funnet | P: funnet · A: funnet · M: ikke relevant — `UR:31,98-101` slipper forvalteren gjennom; `UD/UtdanningstilbudDetails.tsx:107,110-121`, `OS/OpptakSøknadsalternativer.tsx:75` |
| `@OPT-OPT-UTD-002` | Endringer fra utdanningsregisteret oppdateres etter at redigering stenger | ikke funnet | P: delvis · A: mangler · M: ikke relevant — dataene fra utdanningsregisteret kopieres inn bare ved opprett/oppdater (`USS:204-231`), og `oppdaterUtdanningstilbudV3` (`UM:244-256`) avvises etter stengingen for andre enn forvalteren. Ingen jobb eller trigger oppdaterer tilbudene; `hentOgLagreNyeStudieprogrammerFra` (`USS:60-112`) kalles ingen steder. Søkt etter «oppdaterUtdanningstilbud», «@Scheduled», «CREATE TRIGGER», «deaktiver» |
| `@OPT-OPT-UTD-001` | Se grunndata om utdanning | funnet | P: funnet · A: funnet · M: ikke relevant — `UD/components/Basisinformasjon/Basisinformasjon.tsx:53` («Kilde: Utdanningsregisteret», `MSG:373`), `:59-125` navn, nivå, lærested, studiested og studiepoeng; `SG/utdanningstilbudV2.graphqls:162` |
| `@OPT-OPT-UTD-001` | Filtrere på organisasjon som opptaksforvalter ved forvaltende organisasjon | funnet | P: funnet · A: funnet · M: ikke relevant — `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:135-150`, sendt som `larestedIder` (`OS/hooks/useGetUtdanningstilbud.ts:15`); `SG/utdanningstilbudV2.graphqls:287` |
| `@OPT-OPT-UTD-001` | Deltakende organisasjon ser kun utdanningstilbudene sine | ikke funnet | P: mangler · A: mangler · M: ikke relevant — lesepolicyen er `USING (true)` (`MIG/V280__opptak_v2_skjema.sql:1157-1158`, ikke endret senere); spørringen (`SG/utdanningstilbudV2.graphqls:6-10,277-359`) filtrerer ikke på brukerens organisasjon; fs-admin viser hele resultatet (`OS/OpptakSøknadsalternativer.tsx:107`). `deltaker_organisasjonskode` (`MIG/V461__utdanningstilbud_tilbyder_i_opptaket.sql:65-66`) og `har_tilbydertilgang` brukes ikke til å begrense lista |
| `@OPT-OPT-UTD-001` | Deltakende organisasjon ser ikke utdanningstilbud en annen organisasjon tilbyr | ikke funnet | P: mangler · A: mangler · M: ikke relevant — samme som raden over (`MIG/V280__opptak_v2_skjema.sql:1157-1158`, `OS/hooks/useGetUtdanningstilbud.ts:12-33`) |
| `@OPT-OPT-UTD-001` | Filtrere på starttermin og startår | funnet | P: funnet · A: funnet · M: ikke relevant — `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:208-236` («Oppstart» og «Termin»), sendt i `OS/hooks/useGetUtdanningstilbud.ts:16-17`; `SG/utdanningstilbudV2.graphqls:281,283` |
| `@OPT-OPT-UTD-001` | Fritekst-søk på studieprogramnavn | funnet | P: funnet · A: funnet · M: ikke relevant — `SVC/UtdanningstilbudV2Service.java:129-164`, `sok` i `SG/utdanningstilbudV2.graphqls:331-334`; søkefeltet `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:72-82` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler kompetanseregelverk | funnet | P: funnet · A: funnet · M: ikke relevant — `MIG/V427__utdanningstilbud_status.sql:6-7,27` (HAR_MANGLER), `SVC/UtdanningstilbudV2Service.java:82-87`; «Har mangler» i `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:152-161` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler rangeringsregelverk | funnet | P: funnet · A: funnet · M: ikke relevant — `MIG/V427__utdanningstilbud_status.sql:28`, samme statusfilter |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritet eller plassflyt | ikke funnet | P: delvis · A: delvis · M: ikke relevant — `MIG/V427__utdanningstilbud_status.sql:29-32` krever bare minst én kvote; kvoteprioritet og plassflyt er ikke med i `er_komplett` og har ikke filter. Søkt etter «kvoteprioritet», «plassflyt», «er_komplett» |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler opplysninger om tilbudsgaranti | ikke funnet | P: mangler · A: mangler · M: ikke relevant — tilbudsgaranti er ikke med i `er_komplett` (`MIG/V427__utdanningstilbud_status.sql:27-32`) og har ingen filterinput (`SG/utdanningstilbudV2.graphqls:277-359`). Søkt etter «mangler», «ufullstendig», «tilbudsgaranti» |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist | ikke funnet | P: mangler · A: mangler · M: ikke relevant — datoen lagres per tilbud som hendelse (`SVC/UtdanningstilbudHendelseMutations.java:65-83`, `hendelser` i `SG/utdanningstilbudV2.graphqls:191`), men ingen filterinput, `er_komplett` eller filter i fs-admin ser på den (`SG/utdanningstilbudV2.graphqls:277-359`, `OS/hooks/useGetUtdanningstilbud.ts:12-33`) |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler poenggrense for tidlig opptak | ikke funnet | P: mangler · A: mangler · M: ikke relevant — `tidligOpptakPoenggrense` (`SG/utdanningstilbudV2.graphqls:202`) er ikke med i `er_komplett` og har ikke filter; «Tilbyr tidlig opptak» (`OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:163-173`) skiller ikke på poenggrense |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr | ikke funnet | P: funnet · A: mangler · M: ikke relevant — `UM:1064-1085` lar deltakeren trekke bare mens redigeringen er åpen (`UM:1075` → `UR:28-35`); `UD/UtdanningstilbudDetails.tsx:136-137` gir trekk-knappen bare til eieren, og `UD/utils/trekk.ts:8-10` bare når redigeringen er stengt. Ingen vei gjennom begge |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1064-1085` setter `trukket_tidspunkt`, forvalteren er ikke bundet av vinduet (`UR:31`); `UD/components/TrekkUtdanningstilbudButton/TrekkUtdanningstilbudButton.tsx:66-111` med bekreftelsen (`MSG:463`) |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud etter søknadsåpning | usikker | P: delvis · A: delvis · M: ikke relevant — tilbudet blir liggende med `trukket_tidspunkt` (`UM:1076-1081`), merket «Trukket» (`FA/components/UtdanningstilbudResultList/UtdanningstilbudResultList.tsx:186-189`, `UD/UtdanningstilbudDetails.tsx:252`). Men API-et krever opptaksstatus PUBLISERT (`UM:1095-1100`), og fs-admin viser knappen bare når redigeringen er stengt (`UD/utils/trekk.ts:8-10`), ikke ut fra søknadsåpningen |
| `@OPT-OPT-UTD-003` | Søkere varsles når utdanningstilbudet de har søkt på, trekkes | ikke funnet | P: mangler · A: mangler · M: mangler — `UM:1076-1081` setter bare `trukket_tidspunkt`; kvitteringstypene har bare SOKNAD_TRUKKET (`SG/kommunikasjon/kommunikasjon.graphqls:249`). Søkt etter «tilbud_?trukket», «TILBUD_TRUKKET», «trukketTidspunkt», «withdrawn» i alle tre |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen | funnet | P: funnet · A: funnet · M: ikke relevant — `UM:1101-1117` avviser etter FRIST_TREKKE_UTDANNINGSTILBUD; deltakeren får ikke knappen (`UD/UtdanningstilbudDetails.tsx:136-137`), feilmeldingen `TrekkUtdanningstilbudButton.tsx:45-46` (`MSG:472`) |

## Kontroll

Kontrollen endret ingen resultater.

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-026` | Scenario: Muligheten til å fjerne utdanningstilbud vises ikke etter søknadsåpning | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-026` | Scenario: Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen | `@in-progress` | 1/1 | Alt funnet. Brukeren valgte «Ikke endre noe» |
| `@OPT-OPT-UTD-026` | Scenario: Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Scenario: Legge til alle utdanningstilbudene i en filtrert liste | `@planned` | 0/1 | 0 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-002` | Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | `@planned` | 1/1 | Alt funnet. Brukeren valgte «Ikke endre noe» |
| `@OPT-OPT-UTD-002` | Scenario: Se relevante utdanningstilbud | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Scenario: Filtrere på utdanningstype | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Scenario: Filtrere på NKR-nivå for UHG-opptak | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Scenario: Filtrere på NKR-nivå for HYU-opptak | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Scenario: Utdanninger utenfor filteret vises ikke | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Scenario: Kan ikke knytte utdanningstilbud til opptaket før redigering åpner | `@planned` | 1/1 | Alt funnet. Brukeren valgte «Ikke endre noe» |
| `@OPT-OPT-UTD-002` | Scenario: Redigering er stengt når åpningsdatoen ikke er satt | `@planned` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Scenario: Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger | `@planned` | 1/1 | Alt funnet. Brukeren valgte «Ikke endre noe» |
| `@OPT-OPT-UTD-002` | Scenario: Endringer fra utdanningsregisteret oppdateres etter at redigering stenger | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-001` | Scenario: Deltakende organisasjon ser kun utdanningstilbudene sine | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-001` | Scenario: Deltakende organisasjon ser ikke utdanningstilbud en annen organisasjon tilbyr | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-001` | Scenario: Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritet eller plassflyt | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-001` | Scenario: Filtrere på utdanningstilbud som mangler opplysninger om tilbudsgaranti | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-001` | Scenario: Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-001` | Scenario: Filtrere på utdanningstilbud som mangler poenggrense for tidlig opptak | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-003` | Scenario: Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-003` | Scenario: Trekke utdanningstilbud etter søknadsåpning | `@in-progress` | 0/1 | 0 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-003` | Scenario: Søkere varsles når utdanningstilbudet de har søkt på, trekkes | `@draft` | 0/1 | 1 ikke funnet, 0 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Begrunnelse rettet i kontrollen:** `@OPT-OPT-UTD-001` «Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist» — finneren skrev at datoen ikke finnes per utdanningstilbud. Den gjør det (`SVC/UtdanningstilbudHendelseMutations.java:65-83`). Resultatet står: det er filteret som mangler.
- **Deltakende organisasjon kan slette andres utdanningstilbud via API-et:** DELETE-policyen (`MIG/V280__opptak_v2_skjema.sql:1182-1186`) og `UM:1120-1161` sjekker ikke tilbyderen, så en deltaker kan slette en annen organisasjons tilbud i samme opptak. fs-admin hindrer det (`FA/utils/kanEndreUtdanningstilbud.ts:22-27`).
- **Filteret på organisasjon vises for alle i samordna opptak:** `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:135-150` vises ikke bare for forvaltende organisasjon. Kravet sier ikke at andre ikke skal se det.
- **«Har mangler» skiller ikke hva som mangler:** statusfilteret er ett valg for alle manglene (`OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:152-161`), mens kravet har ett scenario per mangel.
- **Åpent spørsmål:** `@OPT-OPT-UTD-003` «Søkere varsles når utdanningstilbudet de har søkt på, trekkes» — Hva skal skje med søkere som har søkt på utdanningstilbudet? Avklares med Tind og Puff (SHI-685). Hvem har ansvaret for avklaringen, funksjonell design eller domene og design (SHI-685)?
- **Bygger på krav som ikke er levert:** `@OPT-OPT-UTD-026` og `@OPT-OPT-UTD-002` bygger på `@OPT-OVO-FRI-001` (`@in-progress`), og `@OPT-OPT-UTD-002` på `@OPT-OPT-UTD-005` (`@draft`)
