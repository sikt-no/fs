# Verifisering: krav/02 Opptak/12 Utdanningstilbud

- **Dato:** 2026-10-26 12:00
- **Krav:** `krav/02 Opptak/12 Utdanningstilbud/` (27 feature-filer), og flyten `krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature`
- **Kode:** `fs-plattform` (main, a1f42eef6e, ikke sjekket mot origin: ingen shell i økta), `fs-admin` (main, 8336410e53, ikke sjekket mot origin: ingen shell i økta)
- **Omfang:** `@in-progress`, flyter, alle krav uansett status (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll` (5 kontrollører; fem `funnet`-rader i `@OPT-OPT-UTD-004` som kontrollen ikke leste, er lest av lead-en)
- **Skjermbilder:** nei (brukeren valgte å sjekke den lokale fs-admin-klonen i stedet)

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Stiene er forkortet:

- `P` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `UM` = `P/opptak/UtdanningstilbudMutations.java`
- `KM` = `P/opptak/KvoteMutations.java`
- `UR` = `P/opptak/Utdanningstilbudredigering.java`
- `USS` = `P/klient/ureg/UregStudieprogramService.java`
- `SG` = `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `FA` = `fs-admin/src/domains/opptak`
- `OS` = `FA/features/OpptakManagement/OpptakSøknadsalternativer`
- `UD` = `FA/features/UtdanningstilbudDetails`
- `AF` = `FA/features/AddUtdanningstilbud`
- `MSG` = `fs-admin/src/common/messages/nb/opptak.json`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-006` | Fange opp endringer fra utdanningsregisteret | 2/6 | fs-plattform, fs-admin | Ingen jobb eller hendelse oppdaterer navn og status fra utdanningsregisteret; synken kjøres bare manuelt. Ingen varsling ved deaktivering eller reaktivering. |
| `@OPT-OPT-UTD-005` | Hente utdanninger fra utdanningsregisteret | 4/6 | fs-plattform, fs-admin | Opptaket har ingen kriterier for utdanningstype, nivå og studiestart. Bare «lærested som ikke deltar» holdes ute. |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak | 6/8 | fs-admin | «Fjern» skjules ved redigeringsfristen, ikke ved søknadsåpning, og forvaltende organisasjon mister «Fjern» etter fristen. |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak | 9/19 | fs-plattform, fs-admin | Campus vises ikke i lista; ingen opptakskriterier eller filter på utdanningstype og NKR 5.1/5.2; redigeringen er åpen når åpningsdatoen mangler (kravet sier stengt); ingen oppdatering fra utdanningsregisteret etter stenging. |
| `@OPT-OPT-UTD-001` | Listevisning og søk i utdanningstilbud i opptaket | 6/13 | fs-plattform, fs-admin | Deltakende organisasjon ser alle tilbudene (lesepolicyen er åpen). «Har mangler» tar ikke med kvoteprioritet, plassflyt, tilbudsgaranti, tidlig søknadsfrist eller poenggrense. Campus vises ikke i lista. |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak | 3/6 | fs-plattform, fs-admin | Deltakende organisasjon har ingen trekk-knapp, og fs-plattform avviser den etter stenging. Søkerne varsles ikke. |
| `@OPT-OPT-UTD-004` | Opptaksinnstillinger per utdanningstilbud | 13/25 | fs-plattform, fs-admin | Ingen hovedkvote; kvotetyper uten kvoteprioritet eller plassflyt kan legges til; kvoteprioriteten kommer fra listeposisjonen, ikke samlingen; plassflyten vises ikke; ingen frist for poenggrensen. |
| `@OPT-OPT-UTD-032` | Sette antall studieplasser per utdanningskvote | 2/2 | ingen | – |
| `@OPT-OPT-UTD-008` | Sette innstillinger for flere utdanningstilbud | 1/1 | ingen | – |
| `@OPT-OPT-UTD-007` | Sette antall studieplasser per utdanningstilbud | 4/6 | fs-plattform, fs-admin | Tak for ja-svar finnes ikke. fs-admin viser antall-feltet for deltakere etter publisert runde (fs-plattform avviser lagringen). |
| `@OPT-OPT-UTD-016` | Angi beskrivelse av utdanningstilbudet til Min kompetanse | 1/2 | min-kompetanse | min-kompetanse er ikke sjekket i denne kjøringen (forrige kjøring: henter ikke `UtdanningstilbudV2.beskrivelse`). |
| `@OPT-OPT-UTD-022` | Angi informasjon om studieavgift | 2/2 | ingen | – |
| `@OPT-OPT-UTD-017` | Angi søkeord på utdanningstilbudet | 3/4 | fs-plattform | Søket for søkere matcher bare navnet, ikke søkeordene. |
| `@OPT-OPT-UTD-030` | Eksportere utdanningstilbudet | 0/0 | ingen | Skjelett uten scenarioer (`@draft`). |
| `@OPT-OPT-UTD-013` | Kvoteflyt registreres ikke på utdanningstilbudet | 1/1 | ingen | – |
| `@OPT-OPT-UTD-015` | Overstyre regler for poenglikhet på utdanningstilbudet | 4/4 | ingen | – |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | 2/2 | ingen | – |
| `@OPT-OPT-UTD-010` | Registrere poengopplysninger for utdanningstilbudet | 2/3 | fs-admin | fs-admin henter ikke `fjoraretsMedianPoengsum`, og viser «Ikke tilgjengelig». |
| `@OPT-OPT-UTD-014` | Registrere påkrevde attester på utdanningstilbudet | 2/2 | ingen | – |
| `@OPT-OPT-UTD-011` | Registrere studietypenummer på utdanningstilbudet | 2/2 | ingen | – |
| `@OPT-OPT-UTD-031` | Sammenligne med tidligere utdanningstilbud | 0/0 | ingen | Skjelett uten scenarioer (`@draft`). |
| `@OPT-OPT-UTD-027` | Sette kjønnspoeng på utdanningstilbudet | 0/0 | ingen | Skjelett uten scenarioer (`@draft`), men funksjonen er bygget (se `## Oppfølging`). |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | 2/3 | fs-plattform, fs-admin | Ingen sjekk av at tidlig søknadsfrist er før opptakets søknadsfrist. |
| `@OPT-OPT-UTD-009` | Vise URL til beskrivelse av utdanningstilbudet | 2/2 | ingen | – |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | 0/2 | fs-plattform, fs-admin | Ingen endringslogg for utdanningstilbudet. |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | 0/2 | fs-plattform, fs-admin | Ingen kobling til et tidligere tilbud. |
| `@OPT-OPT-UTD-029` | Vise poenggrense og ventelistenummer for søker | 0/0 | ingen | Skjelett uten scenarioer (`@draft`). |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling (flyt) | 0/7 | fs-plattform, fs-admin | Ingen av de fem fasene er levert, så overleveringene er ikke søkt etter. |

Gjenstår: fs-plattform, fs-admin 11, fs-admin 2, fs-plattform 1, min-kompetanse 1, ingen 13.

## Oppsummering

- Scenarioer: 73 funnet, 46 ikke funnet, 11 usikker, av 130
- Krav levert (status satt til `@implemented`): 2
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 15
- Delvis levert (egenskapen `@in-progress`, deler satt til `@implemented`): 7 krav, 23 deler
- Slettet (`@deprecated`): 0 filer, 0 regler/scenarioer
- `@deprecated` som fortsatt finnes i koden: 0

## Fremdrift for flyter

Fremdriften kommer fra statusen på delen av kravene fasene bygger på (`@depends-on-`, og ankrene innenfor reglene i «…», ellers alle ankrene, ellers reglene i «…»). Den endrer ingen tagger.

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Tildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001` (`@in-progress`), `@OPT-BEH-BEH-011` (`@planned`) | nei |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får saksbehandlertildelingsregel | `@OPT-OPT-UTD-004` (`@draft`, Regel: Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud) | nei |
| `@FLY-OPT-SAK-001` | Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` (`@planned`) | nei |
| `@FLY-OPT-SAK-001` | Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` (`@planned`), `@OPT-BEH-BEH-010` (`@implemented`) | nei |
| `@FLY-OPT-SAK-001` | Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `@OPT-OVO-FRI-001` (`@in-progress`, Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn, ikke levert), `@OPT-BEH-BEH-011` (`@planned`) | nei |

`@FLY-OPT-SAK-001`: 0 av 5 faser levert.

## Avhengigheter

Kravene i scope bygger på disse kravene (`@depends-on-`, 1 nivå). Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-026` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-OPT-UTD-026` kan ikke leveres før dette |
| `@OPT-OPT-UTD-002` | `@OPT-OVO-FRI-001` Frister og hendelser for opptak | 1 | `@in-progress` | – | ikke levert, `@OPT-OPT-UTD-002` kan ikke leveres før dette |
| `@OPT-OPT-UTD-004` | `@OPT-REG-KVO-003` Sette plassflyt | 1 | `@planned` | – | ikke levert, `@OPT-OPT-UTD-004` kan ikke leveres før dette |
| `@OPT-OPT-UTD-004` | `@OPT-REG-KVO-004` Sette kvoteprioritet | 1 | `@planned` | – | ikke levert, `@OPT-OPT-UTD-004` kan ikke leveres før dette |
| `@OPT-OPT-UTD-004` | `@OPT-OVO-INN-001` Innstillinger | 1 | `@in-progress` | – | ikke levert, `@OPT-OPT-UTD-004` kan ikke leveres før dette |
| `@OPT-OPT-UTD-004` | `@OPT-BEH-BEH-011` Tildele saksbehandlende organisasjon | 1 | `@planned` | – | ikke levert, `@OPT-OPT-UTD-004` kan ikke leveres før dette |

Avhengigheter: 6 på nivå 1, 6 av dem ikke `@implemented`. `@depends-on-` mellom kravene i scope (UTD-002 → UTD-005, UTD-001 → UTD-025 og UTD-010, UTD-032 → UTD-007) er ikke avhengigheter her, fordi begge er i scope.

## Scenarioer

I `Bevis` står **P** for fs-plattform og **A** for fs-admin, med `funnet` / `delvis` / `mangler` / `ikke relevant` for hvert repo. min-kompetanse er ikke med i denne kjøringen.

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-OPT-UTD-006` | Studieprogrammet får nytt navn | ikke funnet | P: delvis · A: mangler — `USS:212-220` oppdaterer navnet bare ved manuell `oppdaterUtdanningstilbudV3` (`UM:244-256`); `hentOgLagreNyeStudieprogrammerFra` (`USS:61`) kalles bare fra tester. Søkt etter «@Scheduled», «@Incoming», «Kafka», «oppdaterNavn» |
| `@OPT-OPT-UTD-006` | Søk finner utdanningstilbudet på det nye navnet | ikke funnet | P: delvis · A: mangler — søket går på kopien `effektivt_studienavn` (`USS:219-220`), som bare oppdateres ved manuell synk |
| `@OPT-OPT-UTD-006` | Utdanningsinstansen deaktiveres | ikke funnet | P: delvis · A: mangler — `er_kansellert` settes fra UREG-status (`USS:216,353-354`) bare ved manuell synk; ingen varsling. Søkt etter «kansell», «deaktiv», «varsel» |
| `@OPT-OPT-UTD-006` | Deaktivert utdanningsinstans er ikke tilgjengelig | funnet | P: funnet · A: funnet — `AF/hooks/useGetUtdanningsinstanser.tsx:137` sender `statuskode: [Aktiv]` mot UREG live |
| `@OPT-OPT-UTD-006` | Reaktivert utdanningsinstans blir tilgjengelig igjen | funnet | P: funnet · A: funnet — samme live-filter, `AF/hooks/useGetUtdanningsinstanser.tsx:137,151-167` |
| `@OPT-OPT-UTD-006` | Utdanningsinstans for et trukket utdanningstilbud reaktiveres | ikke funnet | P: mangler · A: mangler — ingen kode fanger opp reaktivering. Søkt etter «reaktiv», «kansell», «varsel», «@Scheduled» |
| `@OPT-OPT-UTD-005` | Studieprogram fra deltakende lærested blir tilgjengelig | funnet | P: funnet · A: funnet — `USS:183-189` godtar bare tilbyder som eier eller deltar; `FA/utils/utdanningsinstansFilterUtil.ts:55-67`, `AF/hooks/useGetUtdanningsinstanser.tsx:136-144` |
| `@OPT-OPT-UTD-005` | Studiestart som er med i opptaket | usikker | P: delvis · A: delvis — `AF/hooks/useGetUtdanningsinstanserState.tsx:23` har ingen terminfilter som standard, så høst 2027 og vår 2028 er med, men opptaket har ingen studiestart-kriterier som styrer det |
| `@OPT-OPT-UTD-005` | Utdanningsinstans som ikke møter kriteriene | ikke funnet | P: delvis · A: delvis — bare «lærested som ikke deltar» holdes ute (`USS:148-158`); masternivå bare som UI-standard (`FA/utils/utdanningsinstansFilterUtil.ts:7`), ingen filter for emne eller studiestart. Søkt etter «utdanningstype», «emne», «kriteri» |
| `@OPT-OPT-UTD-005` | Samme studieprogram på to campuser | funnet | P: funnet · A: funnet — hver UREG-instans blir et eget tilbud med egen `CAMPUSKODE` (`USS:132-160,245-250`) |
| `@OPT-OPT-UTD-005` | Utdanningstilbudet bruker grunndata fra utdanningsregisteret | funnet | P: funnet · A: funnet — `USS:205-231` kopierer navn, organisasjon, campus, periode, NKR og NUS; `UD/UtdanningstilbudDetails.tsx:261` viser `Basisinformasjon` |
| `@OPT-OPT-UTD-005` | Ny utdanningsinstans etter første henting | funnet | P: funnet · A: funnet — lista spørres live mot UREG (`AF/hooks/useGetUtdanningsinstanser.tsx:151-167`, `USS:126-129`) |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud før søknadsåpning | funnet | P: funnet · A: funnet — `UM:1120-1166` sletter når opptaket er `UPUBLISERT` (`:1142-1150`); `OS/components/UtdanningstilbudActions/UtdanningstilbudActions.tsx:127-137` |
| `@OPT-OPT-UTD-026` | Fjerne flere utdanningstilbud av gangen før søknadsåpning | funnet | P: funnet · A: funnet — `UM:1121-1125,1159` sletter en liste; `OS/OpptakSøknadsalternativer.tsx:89-91` |
| `@OPT-OPT-UTD-026` | Muligheten til å fjerne utdanningstilbud vises ikke etter søknadsåpning | ikke funnet | P: ikke relevant · A: mangler — `UtdanningstilbudActions.tsx:127-137` skjuler «Fjern» bare ved `redigeringErStengt`; ingen sjekk av søknadsåpning i `OS`. Søkt etter «publiser», «opptaksstatus», «søknadsåpning» |
| `@OPT-OPT-UTD-026` | Fjerning av utdanningstilbud etter søknadsåpning avvises | funnet | P: funnet · A: ikke relevant — `UM:1142-1150` kaster `UtdanningstilbudOpptakErPublisertException` før sletting |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen | funnet | P: funnet · A: funnet — `UR:28-35`, DELETE-policy `MIG/V469__deltaker_skriver_bare_egne_utdanningstilbud.sql:85-86`; `FA/utils/kanEndreUtdanningstilbud.ts:22-27` |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen | funnet | P: funnet · A: funnet — `UR:28-35` avviser; `OS/OpptakSøknadsalternativer.tsx:75-77` skjuler handlingene |
| `@OPT-OPT-UTD-026` | Deltakende organisasjon kan ikke fjerne utdanningstilbud en annen organisasjon tilbyr | funnet | P: funnet · A: funnet — `MIG/V469:82-86`, `UM:1159-1163` kaster `IkkeAutorisertOpptakException`; `OS/OpptakSøknadsalternativer.tsx:79-88` |
| `@OPT-OPT-UTD-026` | Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen | ikke funnet | P: funnet · A: mangler — `UR:31,97-101` slipper forvalteren gjennom, men `UtdanningstilbudActions.tsx:127-137` skjuler «Fjern» for alle etter fristen |
| `@OPT-OPT-UTD-002` | Legge til enkelttilbud fra organisasjonen opptaksforvalter er ved | funnet | P: funnet · A: funnet — `UM:131-159`, `USS:145-159`; `FA/utils/utdanningsinstansFilterUtil.ts:55-67` |
| `@OPT-OPT-UTD-002` | Legge til flere utdanningstilbud av gangen | funnet | P: funnet · A: funnet — `UM:132-139` tar en liste; `AF/components/AddUtdanningstilbudAddButton.tsx:32-48` |
| `@OPT-OPT-UTD-002` | Legge til alle utdanningstilbudene i en filtrert liste | usikker | P: funnet · A: delvis — «Velg alle» (`HeaderSelection.tsx:33-50`) tar bare de 50 radene som er lastet (`AF/hooks/useGetUtdanningsinstanserState.tsx:15`) |
| `@OPT-OPT-UTD-002` | Se campus i listen over utdanningstilbud som kan legges til | ikke funnet | P: funnet · A: mangler — `AddUtdanningstilbudResultList.tsx:84-107` har ikke campus, og `useGetUtdanningsinstanser.tsx:44-99` henter det ikke. Søkt etter «campus», «studiested» i `FA` |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbudet på én campus | usikker | P: funnet · A: delvis — hver campus er en egen instans (`USS:215,250`) og kan legges til alene, men lista viser ikke campus |
| `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon | funnet | P: funnet · A: funnet — `MIG/V469:68-69`; `FA/utils/utdanningsinstansFilterUtil.ts:63-64` |
| `@OPT-OPT-UTD-002` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet | P: funnet · A: funnet — `USS:148-158`, `MIG/V469:20-35`; `FA/utils/utdanningsinstansFilterUtil.ts:55-67` |
| `@OPT-OPT-UTD-002` | Se relevante utdanningstilbud | ikke funnet | P: mangler · A: mangler — opptaket har ingen kriterier; fast startfilter med TODO «bare for samordna UHG-opptak» (`FA/utils/utdanningsinstansFilterUtil.ts:6-7`) |
| `@OPT-OPT-UTD-002` | Filtrere på utdanningstype | ikke funnet | P: delvis · A: mangler — ingen filter på utdanningstype i `AF/components/filter/`. Søkt etter «utdanningstype», «nus», «nkrkode» |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for UHG-opptak | usikker | P: delvis · A: delvis — studienivåfilteret gir NKR 6.1/6.2/7 (`AF/components/filter/UtdanningsinstansStudienivaFilter/…tsx:22-29`), men filteret på utdanningstype mangler |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for HYU-opptak | ikke funnet | P: delvis · A: mangler — ingen NKR 5.1/5.2; `nkrkode` sendes ikke fra fs-admin. Søkt etter «fagskole», «5.1», «5.2» |
| `@OPT-OPT-UTD-002` | Utdanninger utenfor filteret vises ikke | ikke funnet | P: delvis · A: delvis — krever filteret på utdanningstype, som ikke finnes |
| `@OPT-OPT-UTD-002` | Kan ikke knytte utdanningstilbud til opptaket før redigering åpner | funnet | P: funnet · A: funnet — `UR:28-35,55-57`, kalt fra `UM:144`; `FA/utils/redigeringsfase.ts:20-21`, `OS/OpptakSøknadsalternativer.tsx:75-77` |
| `@OPT-OPT-UTD-002` | Redigering er stengt når åpningsdatoen ikke er satt | ikke funnet | P: mangler · A: mangler — koden gjør det motsatte: `UR:17-18,56` regner manglende åpningsdato som åpent; `FA/utils/redigeringsfase.ts:20,26` gir `apen` |
| `@OPT-OPT-UTD-002` | Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering | funnet | P: funnet · A: funnet — `UR:63-65`, `UM:144`; `UD/UtdanningstilbudDetails.tsx:110-120` |
| `@OPT-OPT-UTD-002` | Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger | funnet | P: funnet · A: funnet — `UR:28-35,41-51`; `OS/OpptakSøknadsalternativer.tsx:75-77`, `UD/UtdanningstilbudDetails.tsx:107,123` (`kunAntall`) |
| `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger | funnet | P: funnet · A: funnet — `UR:31,97-101`; `UD/UtdanningstilbudDetails.tsx:107` |
| `@OPT-OPT-UTD-002` | Endringer fra utdanningsregisteret oppdateres etter at redigering stenger | ikke funnet | P: delvis · A: mangler — `hentOgLagreNyeStudieprogrammerFra` (`USS:61`) kalles bare fra tester; ingen `@Scheduled` i opptak-service |
| `@OPT-OPT-UTD-002` | Deltakende organisasjon kan ikke redigere utdanningstilbud en annen organisasjon tilbyr | funnet | P: funnet · A: funnet — UPDATE-policy `MIG/V469:74-80`; `FA/utils/kanEndreUtdanningstilbud.ts:22-27` |
| `@OPT-OPT-UTD-001` | Se grunndata om utdanning | funnet | P: funnet · A: funnet — `UD/components/Basisinformasjon/Basisinformasjon.tsx:53,59-124` viser kilden og grunndataene |
| `@OPT-OPT-UTD-001` | Se campus i listen over utdanningstilbud i opptaket | ikke funnet | P: funnet · A: mangler — `OS/queries.ts:70-115` henter ikke campus; campus bare på detaljsiden (`Basisinformasjon.tsx:104`) |
| `@OPT-OPT-UTD-001` | Filtrere på organisasjon som opptaksforvalter ved forvaltende organisasjon | funnet | P: funnet · A: funnet — `OS/components/UtdanningstilbudFilter/UtdanningstilbudFilter.tsx:135-150`, `OS/hooks/useGetUtdanningstilbud.ts:15` |
| `@OPT-OPT-UTD-001` | Deltakende organisasjon ser kun utdanningstilbudene sine | ikke funnet | P: mangler · A: mangler — lesepolicyen er `USING (true)` (`MIG/V280__opptak_v2_skjema.sql:1157-1158`), og `MIG/V469:13` endrer ikke lesesiden |
| `@OPT-OPT-UTD-001` | Deltakende organisasjon ser ikke utdanningstilbud en annen organisasjon tilbyr | ikke funnet | P: mangler · A: mangler — samme som over |
| `@OPT-OPT-UTD-001` | Filtrere på starttermin og startår | funnet | P: funnet · A: funnet — `UtdanningstilbudFilter.tsx:208-236`, `useGetUtdanningstilbud.ts:16-17` |
| `@OPT-OPT-UTD-001` | Fritekst-søk på studieprogramnavn | funnet | P: funnet · A: funnet — `P/opptak/UtdanningstilbudV2Service.java:151-187`; `UtdanningstilbudFilter.tsx:72-82` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler kompetanseregelverk | funnet | P: funnet · A: funnet — `MIG/V427__utdanningstilbud_status.sql:7,27`; `UtdanningstilbudFilter.tsx:152-161` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler rangeringsregelverk | funnet | P: funnet · A: funnet — `MIG/V427:28` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritet eller plassflyt | ikke funnet | P: delvis · A: delvis — `MIG/V427:29-32` krever bare minst én kvote; ingen nyere migrasjon endrer `er_komplett` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler opplysninger om tilbudsgaranti | ikke funnet | P: mangler · A: mangler — ikke med i `er_komplett` (`MIG/V427:27-32`), ingen filter i `SG/utdanningstilbudV2.graphqls:279-360` |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler dato for tidlig søknadsfrist | ikke funnet | P: mangler · A: mangler — bare filteret `tilbyrTidligOpptak` (`UtdanningstilbudFilter.tsx:163-173`) |
| `@OPT-OPT-UTD-001` | Filtrere på utdanningstilbud som mangler poenggrense for tidlig opptak | ikke funnet | P: mangler · A: mangler — ingen filter på manglende poenggrense |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr | ikke funnet | P: funnet · A: mangler — `UM:1064-1085` lar deltakeren trekke bare i redigeringsvinduet (`:1075`), mens `UD/UtdanningstilbudDetails.tsx:136-137` gir knappen bare til opptakseier, og `UD/utils/trekk.ts:9` bare når fasen er `stengt` |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud | funnet | P: funnet · A: funnet — `UM:1064-1084` setter `trukket_tidspunkt`; `UD/UtdanningstilbudDetails.tsx:136-137`, bekreftelse i `MSG:460-465` |
| `@OPT-OPT-UTD-003` | Deltakende organisasjon kan ikke trekke utdanningstilbud en annen organisasjon tilbyr | funnet | P: funnet · A: funnet — UPDATE under RLS (`UM:1076-1081`, `MIG/V469:74-80`) |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud etter søknadsåpning | usikker | P: delvis · A: delvis — tilbudet blir liggende med `trukket_tidspunkt`, men trekk styres av publisering (`UM:1096-1100`) og redigeringsfasen (`trekk.ts:9`), ikke av søknadsåpningen |
| `@OPT-OPT-UTD-003` | Søkere varsles når utdanningstilbudet de har søkt på, trekkes | ikke funnet | P: mangler · A: ikke relevant — `UM:1064-1084` setter bare tidspunktet. Søkt etter «varsl», «melding», «TILBUD_TRUKKET» |
| `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen | funnet | P: funnet · A: funnet — `UM:1101-1117` avviser etter `FRIST_TREKKE_UTDANNINGSTILBUD`; `MSG:472` |
| `@OPT-OPT-UTD-004` | Sette regelverk på ett utdanningstilbud | funnet | P: funnet · A: funnet — `UM:326-392` setter begge regelverkene; `UD/components/RegelverkFelter/RegelverkFelter.tsx:72-80,164-171` |
| `@OPT-OPT-UTD-004` | Kun regelverk fra opptakets regelverkssamling kan velges | funnet | P: funnet · A: funnet — `UM:342-351,1415-1427` (`validerRegelverksamling`); `RegelverkFelter.tsx:40-54` |
| `@OPT-OPT-UTD-004` | Rettigheter for oppretting av nye regelverk | usikker | P: ikke sjekket · A: ikke sjekket — hvem som kan opprette regelverk er ikke undersøkt; scenarioet har `@openquestion` |
| `@OPT-OPT-UTD-004` | Legge til utdanningskvoter fra regelverkssamlingen | funnet | P: funnet · A: funnet — `KM:98-137,196-253,287-303`; `UD/components/Kvoter/Kvoter.tsx:71-95,142-153` |
| `@OPT-OPT-UTD-004` | Utdanningstilbudet må ha hovedkvoten | ikke funnet | P: mangler · A: mangler — søkt etter «hovedkvote», «hoved_kvote», «mainQuota» i hele fs-plattform og `FA` |
| `@OPT-OPT-UTD-004` | Hovedkvoten kan ikke fjernes fra utdanningstilbudet | ikke funnet | P: mangler · A: mangler — `Kvoter.tsx:247-262` har slett på alle kvoter; `KM:368-474` sperrer bare garantikvote og kvote i bruk |
| `@OPT-OPT-UTD-004` | Fjerne en utdanningskvote fra utdanningstilbudet | funnet | P: funnet · A: funnet — `KM:368-474`; `UD/hooks/useUtdanningstilbudEndre.tsx:329-335`, `Kvoter.tsx:97-111` |
| `@OPT-OPT-UTD-004` | Kvotetyper som ikke er i regelverkssamlingen, kan ikke legges til | funnet | P: funnet · A: funnet — `KM:228-236,287-303` (`KVOTETYPE_ANNEN_REGELVERKSAMLING`); `Kvoter.tsx:65-78` |
| `@OPT-OPT-UTD-004` | Kvotetype uten <mangler> kan ikke legges til | ikke funnet | P: mangler · A: mangler — `KM:196-253` sjekker bare samling, duplikat og garantikvote; `kvoteprioritetDefault` og `plassflytKvotetypeKode` er valgfrie (`SG/regelverk/kvote.graphqls:141-161`) |
| `@OPT-OPT-UTD-004` | Regelverksforvalter legger til en kvotetype i regelverkssamlingen | funnet | P: funnet · A: funnet — `P/regelverk/kvotetype/KvotetypeMutations.java:40-66`; `fs-admin/src/domains/regelverk/features/Kvoteregelverk/Kvoteregelverk.tsx:64,130-135` |
| `@OPT-OPT-UTD-004` | Utdanningskvotene får kvoteprioriteten fra regelverkssamlingen | ikke funnet | P: delvis · A: mangler — fs-admin sender listeposisjonen som `kvoteprioritet` (`UD/utils/skjema.ts:64`, `useUtdanningstilbudEndre.tsx:342-347`), lagret som overstyring (`KM:86`) |
| `@OPT-OPT-UTD-004` | Utdanningskvotene følger plassflyten i regelverkssamlingen | funnet | P: funnet · A: ikke relevant — `P/plasstildeling/service/KvoterService.java:88-89` bruker kvotetypens plassflyt når overstyring ikke er satt, og `KM:79-89,333-344` setter den aldri |
| `@OPT-OPT-UTD-004` | Se plassflyten for et utdanningstilbud | ikke funnet | P: delvis · A: mangler — søkt etter «plassflyt», «placeFlow» i `fs-admin/src` |
| `@OPT-OPT-UTD-004` | Kvoter som ikke er på utdanningstilbudet, vises ikke i plassflyten | ikke funnet | P: mangler · A: mangler — plassflyten vises ikke |
| `@OPT-OPT-UTD-004` | Se kvoteprioriteten for et utdanningstilbud | ikke funnet | P: delvis · A: mangler — `Kvoter.tsx:212` viser `kvote.priority`, som er overstyringen (`SG/opptak/utdanningstilbud.graphqls:492`) eller listeposisjonen (`skjema.ts:64`), ikke prioriteten fra samlingen |
| `@OPT-OPT-UTD-004` | Lærestedet kan ikke endre plassflyten eller kvoteprioriteten | usikker | P: mangler · A: delvis — `Kvoter.tsx:206-265` har ingen felt for dem, men API-et tar imot overstyring av kvoteprioritet (`KM:342-344`), og `Kvoter.tsx:97-101` omnummererer ved fjerning |
| `@OPT-OPT-UTD-004` | Markere at utdanningstilbudet tilbyr tidlig opptak | funnet | P: funnet · A: funnet — `UM:297-324` (avviser når opptaket ikke har tidlig opptak, `:301-305`); `UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:96-97` |
| `@OPT-OPT-UTD-004` | Sette poenggrense for tidlig opptak | funnet | P: funnet · A: funnet — `UM:311` lagrer grensen, `P/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java:731-741` gir tilbudsgaranti over grensen; `UD/UtdanningstilbudDetails.tsx:158-165` |
| `@OPT-OPT-UTD-004` | Lærestedet kan ikke endre poenggrensen for tidlig opptak etter fristen | ikke funnet | P: mangler · A: mangler — `FRIST_TIDLIGOPPTAK_POENGGRENSE` er bare en hendelsestype (`MIG/V444__opptakshendelse_kategorier_og_rekkefolge.sql:21`); `oppdaterTidligOpptak` bruker redigeringsfristen (`UR:28-35`) |
| `@OPT-OPT-UTD-004` | Velge saksbehandlertildelingsregel for et utdanningstilbud | funnet | P: funnet · A: funnet — `UM:357-392` lagrer `BEHANDLERTILDELINGSREGEL_KODE`, `P/saksbehandling/BehandlertildelingService.java:200-224` bruker tilbudets regel; `RegelverkFelter.tsx:164-171` |
| `@OPT-OPT-UTD-004` | Utdanningstilbud uten egen saksbehandlertildelingsregel følger opptakets standardregel | funnet | P: funnet · A: funnet — `BehandlertildelingService.java:110-113,223` faller tilbake til opptakets standardregel |
| `@OPT-OPT-UTD-004` | Kun aktive saksbehandlertildelingsregler i opptaket kan velges | funnet | P: funnet · A: funnet — `UM:361-373` avviser inaktiv regel; `UD/UtdanningstilbudDetails.queries.ts:57` filtrerer på `erAktiv` |
| `@OPT-OPT-UTD-004` | Velge å vise poenggrense for søker | usikker | P: funnet · A: funnet — `UM:259-280` lagrer `VIS_POENGGRENSE_FOR_SOKER`; `UD/components/Opptaksinnstillinger/Opptaksinnstillinger.tsx:52-58`. Det søkeren ser, er ikke sjekket (min-kompetanse) |
| `@OPT-OPT-UTD-004` | Velge å vise ventelistenummer for søker | usikker | P: funnet · A: funnet — `UM:267`; `Opptaksinnstillinger.tsx:59-65`. Det søkeren ser, er ikke sjekket (min-kompetanse) |
| `@OPT-OPT-UTD-004` | Sette hvor tilbudsgarantier tas fra | funnet | P: funnet · A: funnet — `KM:91-93,357-363` (`settTilbudsgaranti`); `Kvoter.tsx:237-246` |
| `@OPT-OPT-UTD-032` | Sette antall studieplasser i en utdanningskvote | funnet | P: funnet · A: funnet — `KM:338-340` lagrer `ONSKET_ANTALL_DELTAKERE`; `Kvoter.tsx:130-133,216-236` viser antall og andel |
| `@OPT-OPT-UTD-032` | Summen av utdanningskvotene avviker fra antall studieplasser | funnet | P: ikke relevant · A: funnet — `Kvoter.tsx:69,182-195` viser varselet `kvoteplasserSumAvvik` (`MSG:370`) |
| `@OPT-OPT-UTD-008` | Sette regelverk på flere utdanningstilbud av gangen | funnet | P: funnet · A: funnet — `UM:476-495,818-880`; `OS/components/SettRegelverkBody/SettRegelverkBody.tsx:64-81,127-139` |
| `@OPT-OPT-UTD-007` | Sette antall studieplasser | funnet | P: funnet · A: funnet — `UM:956-998` (0–9999); `Kvoter.tsx:155-170` |
| `@OPT-OPT-UTD-007` | Sette tak for ja-svar | ikke funnet | P: mangler · A: mangler — søkt etter «tak for ja», «takJa», «jasvar», «ANTALL_JA_SVAR»; bare statistikk (`antallJaSvar`) |
| `@OPT-OPT-UTD-007` | Endre antall studieplasser etter at redigering av utdanningstilbud har stengt | funnet | P: funnet · A: funnet — `UR:41-51`, `UM:988-989`; `UD/UtdanningstilbudDetails.tsx:106-107,123` |
| `@OPT-OPT-UTD-007` | Endre antall studieplasser etter en plasstildeling som bare er kjørt for kontroll | funnet | P: funnet · A: funnet — `UR:90-95` låser bare når en runde har publiseringstidspunkt |
| `@OPT-OPT-UTD-007` | Deltakende organisasjon kan ikke endre antall studieplasser etter at første plasstildelingsrunde er publisert | usikker | P: funnet · A: delvis — `UR:47-50` avviser, men `UD/UtdanningstilbudDetails.tsx:107,123` viser feltet til lagringen feiler (mønsteret «manglende tilgang skjuler elementet» er ikke fulgt) |
| `@OPT-OPT-UTD-007` | Forvaltende organisasjon kan endre antall studieplasser etter at første plasstildelingsrunde er publisert | funnet | P: funnet · A: funnet — `UR:44,97-101`; `UD/UtdanningstilbudDetails.tsx:100-107` |
| `@OPT-OPT-UTD-016` | Angi beskrivelse på <språk> | funnet | P: funnet · A: funnet — `UM:178-192`, `skrivBeskrivelse` (`UM:1195-1209`), NOB/NNO/ENG/SME (`UM:1334-1341`); `UD/hooks/useUtdanningstilbudEndre.tsx:245-270` |
| `@OPT-OPT-UTD-016` | Søker ser beskrivelsen i Min kompetanse | usikker | P: funnet · A: ikke relevant — `SG/utdanningstilbudV2.graphqls:141-150` eksponerer `beskrivelse`; min-kompetanse er ikke sjekket |
| `@OPT-OPT-UTD-022` | Registrere informasjon om studieavgift | funnet | P: funnet · A: funnet — `UM:1000-1002`; `UD/components/StudietypeOgStudieavgift/StudietypeOgStudieavgift.tsx:58-70`, `useUtdanningstilbudEndre.tsx:196,217-219` |
| `@OPT-OPT-UTD-022` | Se informasjon om studieavgift | funnet | P: funnet · A: funnet — `SG/utdanningstilbudV2.graphqls:227-231`; `UD/UtdanningstilbudDetails.queries.ts:194`, `StudietypeOgStudieavgift.tsx:72-75` |
| `@OPT-OPT-UTD-017` | Legge til søkeord på utdanningstilbud | funnet | P: funnet · A: funnet — `UM:1034-1036`, `normaliserSokeord` (`UM:199-222`, 20 ord à 50 tegn); `useUtdanningstilbudEndre.tsx:194-195,216` |
| `@OPT-OPT-UTD-017` | Legge til flere søkeord på samme utdanningstilbud | funnet | P: funnet · A: funnet — `skrivSokeord` (`UM:1233-1249`) |
| `@OPT-OPT-UTD-017` | Fjerne søkeord fra utdanningstilbud | funnet | P: funnet · A: funnet — `skrivSokeord` erstatter alle radene (`UM:1232,1246`); `useUtdanningstilbudEndre.tsx:195-196` |
| `@OPT-OPT-UTD-017` | Søker finner utdanningstilbud via søkeord | ikke funnet | P: mangler · A: ikke relevant — `P/opptak/UtdanningstilbudV2Service.java:151-187` søker i navn, regelverk og kvotetype, ikke søkeord; `utdanningstilbudSokeord` (`SG/utdanningstilbudV2.graphqls:40-51`) er bare autoforslag. Søkt etter «sokeord», «UTDANNINGSTILBUD_SOKEORD» |
| `@OPT-OPT-UTD-013` | Kvoteflyt kan ikke registreres på utdanningstilbudet | funnet | P: funnet · A: funnet — ingen plassflyt i kvote-inputene (`SG/opptak/utdanningstilbud.graphqls:395-460`), bare på kvotetypen (`SG/regelverk/kvote.graphqls:154,180,211`); ingen treff i `fs-admin/src` |
| `@OPT-OPT-UTD-015` | Se standardregel for poenglikhet | funnet | P: funnet · A: funnet — `SG/opptak/opptak.graphqls:271-272`; `RegelverkFelter.tsx:93,100-109,196-198` |
| `@OPT-OPT-UTD-015` | Overstyre regel for poenglikhet | funnet | P: funnet · A: funnet — `UM:910-953` setter `POENGLIKHETSREGEL_KODE`; `useUtdanningstilbudEndre.tsx:232-243` |
| `@OPT-OPT-UTD-015` | Kun regler tilgjengelige for opptaket kan velges | funnet | P: funnet · A: funnet — FK i `MIG/V379__tillatte_poenglikhetsregler_pa_opptak.sql:74`, `UM:933-939`; `RegelverkFelter.tsx:100-109` |
| `@OPT-OPT-UTD-015` | Kan ikke overstyre regel for poenglikhet når opptaket ikke åpner for unntak | funnet | P: funnet · A: funnet — `SG/opptak/opptak.graphqls:122-127`; `RegelverkFelter.tsx:97-99,184,195-198` |
| `@OPT-OPT-UTD-012` | Registrere planlagt antall studieplasser | funnet | P: funnet · A: funnet — `UM:975-982,996-999`; `Kvoter.tsx:155-170` |
| `@OPT-OPT-UTD-012` | Se planlagt antall studieplasser | funnet | P: funnet · A: funnet — `SG/utdanningstilbudV2.graphqls:170-171`; `UD/UtdanningstilbudDetails.queries.ts:189`, `Kvoter.tsx:171-178` |
| `@OPT-OPT-UTD-010` | Se median poengsum for fjorårets opptatte | ikke funnet | P: funnet · A: mangler — `SG/utdanningstilbudV2.graphqls:205-210` (`fjoraretsMedianPoengsum`); fs-admin viser fast «Ikke tilgjengelig» (`UD/components/TidligFristOgOpptak/TidligFristOgOpptak.tsx:123-130`, TODO SHI-660). Søkt etter «median» i `fs-admin/src` |
| `@OPT-OPT-UTD-010` | Registrere poenggrense for tidligopptak | funnet | P: funnet · A: funnet — `UM:300-314`; `TidligFristOgOpptak.tsx:131-142`, `useUtdanningstilbudEndre.tsx:175-190` |
| `@OPT-OPT-UTD-010` | Se registrert poenggrense for tidligopptak | funnet | P: funnet · A: funnet — `SG/utdanningstilbudV2.graphqls:199-204`; `UD/UtdanningstilbudDetails.queries.ts:188`, `TidligFristOgOpptak.tsx:143-155` |
| `@OPT-OPT-UTD-014` | Registrere krav om politiattest | funnet | P: funnet · A: funnet — `MIG/V445__utdanningstilbud_attest.sql:30-31,56-67`, `P/opptak/UtdanningstilbudAttestMutations.java`; `UD/components/AttesterFelt/AttesterFelt.tsx:23-49` |
| `@OPT-OPT-UTD-014` | Registrere krav om medisinsk attest | funnet | P: funnet · A: funnet — `MIG/V445:30,56` (MEDICAL); `AttesterFelt.tsx:26-49` |
| `@OPT-OPT-UTD-011` | Registrere studietypenummer på utdanningstilbud | funnet | P: funnet · A: funnet — `UM:1004-1008` sjekker kodeverket `STUDIETYPE`; `StudietypeOgStudieavgift.tsx:45`, `UD/utils/skjema.ts:46,103` |
| `@OPT-OPT-UTD-011` | Se studietypenummer på utdanningstilbud | funnet | P: funnet · A: funnet — `UD/UtdanningstilbudDetails.queries.ts:198-200`; `StudietypeOgStudieavgift.tsx:54` |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist | funnet | P: funnet · A: funnet — `P/opptak/UtdanningstilbudHendelseMutations.java:30-84`; `useUtdanningstilbudEndre.tsx:299`, `TidligFristOgOpptak.tsx:40-75` |
| `@OPT-OPT-UTD-025` | Tidlig søknadsfrist må være før søknadsfristen for opptaket | ikke funnet | P: mangler · A: mangler — `UtdanningstilbudHendelseMutations.java:30-84` og `HendelseInputValidering` sammenligner ikke med opptakets frist; datovelgeren har ingen grense. Søkt etter «isBefore», «isAfter», «SOKNADSFRIST_TIDLIG_OPPTAK» |
| `@OPT-OPT-UTD-025` | Sette tidlig dokumentasjonsfrist | funnet | P: funnet · A: funnet — `UtdanningstilbudHendelseMutations.java:70-82`; `useUtdanningstilbudEndre.tsx:303` |
| `@OPT-OPT-UTD-009` | Se URL til beskrivelse av utdanningstilbudet | funnet | P: funnet · A: funnet — `fs-plattform/utdanningsregisteret/utdanningsregisteret-graphql-spec/src/main/resources/schema/features/beta/utdanningsspesifikasjon.graphql:36-37`; `Basisinformasjon.tsx:26-28,155-157` |
| `@OPT-OPT-UTD-009` | Utdanningstilbud uten beskrivelses-URL | funnet | P: funnet · A: funnet — `Basisinformasjon.tsx:159-160` viser ingen lenke uten URL |
| `@OPT-OPT-UTD-019` | Se endringslogg for registreringer på utdanningstilbudet | ikke funnet | P: mangler · A: mangler — søkt etter «endringslogg», «changelog», «audit», «historikk», «endret_av», «sistEndret» i fs-plattform/opptak og `FA` |
| `@OPT-OPT-UTD-019` | Endringslogg viser hvem som endret og når | ikke funnet | P: mangler · A: mangler — samme søk, ingen felt for hvem og når |
| `@OPT-OPT-UTD-021` | Sette lenke til tidligere utdanningstilbud | ikke funnet | P: mangler · A: mangler — `USS:432-447` (`finnForrigeTilbud`) slår opp internt ved import, lagrer og viser ingen lenke. Søkt etter «tidligere», «forrige», «forgjenger», «previous» |
| `@OPT-OPT-UTD-021` | Se lenke til tidligere utdanningstilbud | ikke funnet | P: mangler · A: mangler — ingen felt å vise |
| `@FLY-OPT-SAK-001` | Lærestedene kan velge saksbehandlertildelingsregelen opptaket har satt opp | ikke funnet | fasen er ikke levert: `@OPT-OVO-SAM-001` er `@in-progress`, `@OPT-BEH-BEH-011` er `@planned` — ikke søkt |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får saksbehandlertildelingsregelen fra opptaket | ikke funnet | fasen er ikke levert: `@OPT-OPT-UTD-004` er `@draft` — ikke søkt |
| `@FLY-OPT-SAK-001` | Søknaden blir én sak hos hver saksbehandlende organisasjon | ikke funnet | fasen er ikke levert: `@OPT-BEH-BEH-011` er `@planned` — ikke søkt |
| `@FLY-OPT-SAK-001` | Organisasjonen som saksbehandler på vegne av lærestedet får saken | ikke funnet | fasen er ikke levert: `@OPT-BEH-BEH-011` er `@planned` — ikke søkt |
| `@FLY-OPT-SAK-001` | Saksbehandleren ved den saksbehandlende organisasjonen ser saken | ikke funnet | fasen er ikke levert: `@OPT-BEH-BEH-011` er `@planned` — ikke søkt |
| `@FLY-OPT-SAK-001` | Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler | ikke funnet | fasen er ikke levert: `@OPT-BEH-BEH-011` er `@planned` — ikke søkt |
| `@FLY-OPT-SAK-001` | Saksbehandlertildelingen bruker fristen opptaket har satt | ikke funnet | fasen er ikke levert: `@OPT-OVO-FRI-001` er `@in-progress`, `@OPT-BEH-BEH-011` er `@planned` — ikke søkt |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-002` | Filtrere på NKR-nivå for UHG-opptak | ikke funnet | usikker | `AF/components/filter/UtdanningsinstansStudienivaFilter/…tsx:22-29` — studienivåfilteret (NKR 6.1/6.2/7) finnes, bare filteret på utdanningstype mangler |
| `@OPT-OPT-UTD-004` | Regelverksforvalter legger til en kvotetype i regelverkssamlingen | usikker | funnet | `P/regelverk/kvotetype/KvotetypeMutations.java:40-66` og `fs-admin/src/domains/regelverk/features/Kvoteregelverk/Kvoteregelverk.tsx:64,130-135` oppretter kvotetypen |
| `@OPT-OPT-UTD-004` | Utdanningskvotene følger plassflyten i regelverkssamlingen | usikker | funnet | `P/plasstildeling/service/KvoterService.java:88-89` faller tilbake til kvotetypens plassflyt, og overstyringen settes aldri |
| `@OPT-OPT-UTD-004` | Se kvoteprioriteten for et utdanningstilbud | usikker | ikke funnet | `SG/opptak/utdanningstilbud.graphqls:492` — feltet er overstyringen, og uten den viser fs-admin listeposisjonen |
| `@OPT-OPT-UTD-004` | Lærestedet kan ikke endre plassflyten eller kvoteprioriteten | ikke funnet | usikker | `UD/components/Kvoter/Kvoter.tsx:206-265` har ingen felt for dem, men API-et tar imot overstyring (`KM:342-344`) |
| `@OPT-OPT-UTD-004` | Sette poenggrense for tidlig opptak | usikker | funnet | `P/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java:731-741` gir tilbudsgaranti over grensen |

## Forslag til endringer

**Kan leveres**

- `@OPT-OPT-UTD-032` — Sette antall studieplasser per utdanningskvote (`krav/02 Opptak/12 Utdanningstilbud/03 Opptaksinnstillinger/sette_antall_studieplasser_per_kvote.feature`, `@draft` → `@implemented`, 2/2 funnet) — bygger på `@OPT-OPT-UTD-007`, som er `@draft`. Fila har åpne spørsmål i en kommentar (måltall eller fast antall, om lagring skal stoppes).
- `@OPT-OPT-UTD-008` — Sette innstillinger for flere utdanningstilbud (`krav/02 Opptak/12 Utdanningstilbud/03 Opptaksinnstillinger/sette_innstillinger_for_flere_utdanningstilbud.feature`, `@draft` → `@implemented`, 1/1 funnet). Fila har åpne spørsmål i en kommentar (mal eller engangsoppdatering, hvilke innstillinger).

**Delvis levert**

Delene som får `@implemented`, er regelen når alle scenarioene i den er funnet, ellers scenarioene som er funnet (se `## Scenarioer`). Linjene settes når brukeren har sagt ja.

- `@OPT-OPT-UTD-006` — Fange opp endringer fra utdanningsregisteret (`…/01 Hente fra utdanningsregisteret/fange_opp_endringer_fra_utdanningsregisteret.feature`, `@draft` → `@in-progress`, 2/6 funnet) — `@implemented` på: Scenario: Deaktivert utdanningsinstans er ikke tilgjengelig, Scenario: Reaktivert utdanningsinstans blir tilgjengelig igjen
- `@OPT-OPT-UTD-005` — Hente utdanninger fra utdanningsregisteret (`…/01 Hente fra utdanningsregisteret/hente_utdanninger_fra_utdanningsregisteret.feature`, `@draft` → `@in-progress`, 4/6 funnet) — `@implemented` på: Scenario: Studieprogram fra deltakende lærested blir tilgjengelig, Scenario: Samme studieprogram på to campuser, Regel: Grunndata gjenbrukes fra utdanningsregisteret, Regel: Nye utdanningsinstanser i utdanningsregisteret blir tilgjengelige
- `@OPT-OPT-UTD-026` — Fjerne utdanningstilbud fra opptak (`…/02 Utdanningstilbud i opptak/fjerne_utdanningstilbud.feature`, `@in-progress` → `@in-progress`, 6/8 funnet) — de seks funnede scenarioene; de fleste har `@implemented` fra før
- `@OPT-OPT-UTD-002` — Legge til utdanningstilbud i opptak (`…/02 Utdanningstilbud i opptak/legge_til_utdanningstilbud.feature`, `@in-progress` → `@in-progress`, 9/19 funnet) — de ni funnede scenarioene; de fleste har `@implemented` fra før
- `@OPT-OPT-UTD-001` — Listevisning og søk i utdanningstilbud i opptaket (`…/02 Utdanningstilbud i opptak/listevisning_utdanningstilbud.feature`, `@in-progress` → `@in-progress`, 6/13 funnet) — de seks funnede scenarioene; de fleste har `@implemented` fra før
- `@OPT-OPT-UTD-003` — Trekke utdanningstilbud fra opptak (`…/02 Utdanningstilbud i opptak/trekke_utdanningstilbud.feature`, `@in-progress` → `@in-progress`, 3/6 funnet) — Scenario: Deltakende organisasjon kan ikke trekke utdanningstilbud en annen organisasjon tilbyr kommer i tillegg til delene som har `@implemented` fra før
- `@OPT-OPT-UTD-004` — Opptaksinnstillinger per utdanningstilbud (`…/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature`, `@draft` → `@in-progress`, 13/25 funnet) — `@implemented` på: Regel: Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud, Regel: Opptaksforvalter kan sette opplysninger om tilbudsgaranti, Regel: Opptaksforvalter kan markere at et utdanningstilbud tilbyr tidlig opptak, og de funnede scenarioene i de andre reglene
- `@OPT-OPT-UTD-007` — Sette antall studieplasser per utdanningstilbud (`…/03 Opptaksinnstillinger/sette_studieplasser_og_antall_tilbud.feature`, `@draft` → `@in-progress`, 4/6 funnet) — `@implemented` på: Regel: Opptaksforvalter setter antall studieplasser, og de tre funnede scenarioene i regelen om endring etter publisert runde
- `@OPT-OPT-UTD-025` — Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet (`…/04 Behandle et utdanningstilbud/sette_tidlig_søknadsfrist.feature`, `@in-progress` → `@in-progress`, 2/3 funnet) — de to funnede scenarioene har `@implemented` fra før, ingen endring

**Kan slettes**

Ingen.

**Blir stående**

- `@OPT-OPT-UTD-016` — Angi beskrivelse av utdanningstilbudet til Min kompetanse (`@implemented`, 1/2 funnet) — delen om søkeren er `@in-progress` og ikke sjekket (min-kompetanse)
- `@OPT-OPT-UTD-017` — Angi søkeord på utdanningstilbudet (`@implemented`, 3/4 funnet) — søket for søkere bruker ikke søkeordene
- `@OPT-OPT-UTD-010` — Registrere poengopplysninger for utdanningstilbudet (`@implemented`, 2/3 funnet) — medianen vises ikke i fs-admin
- `@OPT-OPT-UTD-019` — Vise endringslogg for utdanningstilbudet (`@draft`, 0/2 funnet) — ikke bygget
- `@OPT-OPT-UTD-021` — Vise lenke til tidligere utdanningstilbud (`@draft`, 0/2 funnet) — ikke bygget
- `@OPT-OPT-UTD-030`, `@OPT-OPT-UTD-031`, `@OPT-OPT-UTD-027`, `@OPT-OPT-UTD-029` (`@draft`, 0/0) — skjeletter uten scenarioer
- `@FLY-OPT-SAK-001` — Saksbehandlertildeling (`@planned`, 0/7 funnet) — ingen av de fem fasene er levert

## Levert

Brukeren valgte «Gjør alle endringene».

| Feature-ID | Egenskap eller del | Fil | Fra | Gating funnet |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-032` | Sette antall studieplasser per utdanningskvote | `03 Opptaksinnstillinger/sette_antall_studieplasser_per_kvote.feature` | `@draft` | 2/2 |
| `@OPT-OPT-UTD-008` | Sette innstillinger for flere utdanningstilbud | `03 Opptaksinnstillinger/sette_innstillinger_for_flere_utdanningstilbud.feature` | `@draft` | 1/1 |
| `@OPT-OPT-UTD-006` | Fange opp endringer fra utdanningsregisteret (delvis: `@in-progress`, 2 deler `@implemented`) | `01 Hente fra utdanningsregisteret/fange_opp_endringer_fra_utdanningsregisteret.feature` | `@draft` | 2/6 |
| `@OPT-OPT-UTD-005` | Hente utdanninger fra utdanningsregisteret (delvis: `@in-progress`, 4 deler `@implemented`) | `01 Hente fra utdanningsregisteret/hente_utdanninger_fra_utdanningsregisteret.feature` | `@draft` | 4/6 |
| `@OPT-OPT-UTD-004` | Opptaksinnstillinger per utdanningstilbud (delvis: `@in-progress`, 10 deler `@implemented`) | `03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature` | `@draft` | 13/25 |
| `@OPT-OPT-UTD-007` | Sette antall studieplasser per utdanningstilbud (delvis: `@in-progress`, 4 deler `@implemented`) | `03 Opptaksinnstillinger/sette_studieplasser_og_antall_tilbud.feature` | `@draft` | 4/6 |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak (delvis: `@in-progress`, 1 del ny `@implemented`: Regel: Opptaksforvalter ved deltakende organisasjon kan fjerne utdanningstilbud organisasjonen tilbyr, fram til redigeringsfristen) | `02 Utdanningstilbud i opptak/fjerne_utdanningstilbud.feature` | `@in-progress` | 6/8 |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak (delvis: `@in-progress`, 1 del ny `@implemented`: Regel: Opptaksforvalter ved deltakende organisasjon kan bare redigere utdanningstilbud organisasjonen tilbyr) | `02 Utdanningstilbud i opptak/legge_til_utdanningstilbud.feature` | `@in-progress` | 9/19 |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak (delvis: `@in-progress`, 1 del ny `@implemented`: Scenario: Deltakende organisasjon kan ikke trekke utdanningstilbud en annen organisasjon tilbyr) | `02 Utdanningstilbud i opptak/trekke_utdanningstilbud.feature` | `@in-progress` | 3/6 |

`@OPT-OPT-UTD-001` og `@OPT-OPT-UTD-025` hadde allerede `@implemented` på alle delene som er funnet, og er ikke endret.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@OPT-OPT-UTD-006` | Fange opp endringer fra utdanningsregisteret | `@in-progress` | 2/6 | 4 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-005` | Hente utdanninger fra utdanningsregisteret | `@in-progress` | 4/6 | 1 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-026` | Fjerne utdanningstilbud fra opptak | `@in-progress` | 6/8 | 2 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-002` | Legge til utdanningstilbud i opptak | `@in-progress` | 9/19 | 7 ikke funnet, 3 usikker |
| `@OPT-OPT-UTD-001` | Listevisning og søk i utdanningstilbud i opptaket | `@in-progress` | 6/13 | 7 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-003` | Trekke utdanningstilbud fra opptak | `@in-progress` | 3/6 | 2 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-004` | Opptaksinnstillinger per utdanningstilbud | `@in-progress` | 13/25 | 8 ikke funnet, 4 usikker |
| `@OPT-OPT-UTD-007` | Sette antall studieplasser per utdanningstilbud | `@in-progress` | 4/6 | 1 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-016` | Scenario: Søker ser beskrivelsen i Min kompetanse | `@in-progress` | 0/1 | 0 ikke funnet, 1 usikker |
| `@OPT-OPT-UTD-017` | Scenario: Søker finner utdanningstilbud via søkeord | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-010` | Scenario: Se median poengsum for fjorårets opptatte | `@in-progress` | 0/1 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | `@in-progress` | 2/3 | 1 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-019` | Vise endringslogg for utdanningstilbudet | `@draft` | 0/2 | 2 ikke funnet, 0 usikker |
| `@OPT-OPT-UTD-021` | Vise lenke til tidligere utdanningstilbud | `@draft` | 0/2 | 2 ikke funnet, 0 usikker |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling | `@planned` | 0/7 | 7 ikke funnet, 0 usikker (ingen fase levert) |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Ikke sjekket:** min-kompetanse (brukeren valgte å holde den utenfor). Det gjelder hva søkeren ser i `@OPT-OPT-UTD-016`, `@OPT-OPT-UTD-017` og `@OPT-OPT-UTD-004` (poenggrense og ventelistenummer for søker). Branchene i klonene og i kravrepoet er ikke sjekket mot origin, fordi økta ikke hadde shell.
- **Kjønnspoeng er bygget, men kravet er et skjelett:** `@OPT-OPT-UTD-027` har bare en `Regel:`-tittel, mens koden har valgene Ingen, 1 til menn, 2 til menn og 2 til kvinner: `SG/opptak/utdanningstilbud.graphqls:375-381`, `UM:1013-1015`, `UD/components/KjonnspoengFelt/KjonnspoengFelt.tsx:20-72`, `MSG:386-393`. Scenarioene skrives med `fs-krav`.
- **Bygget uten krav:** «nytt for året» (`erNytt`, `SG/opptak/utdanningstilbud.graphqls:369`, `MIG/V452__utdanningstilbud_er_nytt_not_null.sql`, `UD/hooks/useUtdanningstilbudEndre.tsx:109,197-220`), og ID fra utdanningsinstansen (`UD/components/Basisinformasjon/Basisinformasjon.tsx:118`).
- **Medianen ligger på en branch som ikke er merget:** `einor/shi-688-feat-median-og-poenggrenser` i fs-admin. `@OPT-OPT-UTD-010` «Se median poengsum for fjorårets opptatte» blir funnet når den er merget.
- **Rolleforskjell i fs-admin og databasen:** fs-admin sjekker `MODIFISERE_OPPTAK` for deltakeren (`OS/OpptakSøknadsalternativer.tsx:50-52`), mens `MIG/V469:74-80` krever `MEDLEM_OPPTAK`. Ikke undersøkt om den ene gir den andre.
- **Trekk bare når redigeringen er stengt:** trekk-knappen vises bare i fasen `stengt` (`UD/utils/trekk.ts:9`). Er redigeringsfristen ikke satt, kan ingen trekke i fs-admin, selv om fs-plattform tillater forvalteren å trekke.
- **Scope-fila peker på filer som ikke finnes:** `tasks/opptak/scope-utdanningstilbud-2027.md:38` (`registrere_studienummer.feature`, nå `registrere_studietypenummer.feature`) og `:47` (`kvalitetssikre_studiestart.feature`, `@OPT-OPT-UTD-023`). Tabellen mangler `@OPT-OPT-UTD-027`, `-029`, `-030` og `-031`. Rettes med `fs-scope`.
- **Åpent spørsmål:** `@OPT-OPT-UTD-002` «Legge til alle utdanningstilbudene i en filtrert liste» — skal «velg alle» ta alle treff, ikke bare de 50 som er lastet?
- **Åpent spørsmål:** `@OPT-OPT-UTD-002` «Opptaksforvalter kan filtrere på utdanningstype og studienivå når utdanningstilbud legges til» — skal filteret på utdanningstype og NKR 5.1/5.2 bygges?
- **Åpent spørsmål:** `@OPT-OPT-UTD-002` «Endringer fra utdanningsregisteret oppdateres etter at redigering stenger» — skal oppdateringen bygges som en jobb i fs-plattform?
- **Åpent spørsmål:** `@OPT-OPT-UTD-001` «Filtrere på utdanningstilbud som mangler kvoter, kvoteprioritet eller plassflyt» — skal kvoteprioritet og plassflyt tas med i «Har mangler»?
- **Åpent spørsmål:** `@OPT-OPT-UTD-003` «Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr» og «Trekke utdanningstilbud etter søknadsåpning» — når skal deltakende organisasjon kunne trekke, og skal trekk styres av søknadsåpningen?
- **Åpent spørsmål:** `@OPT-OPT-UTD-026` «Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen» — skal fs-admin vise «Fjern» for forvaltende organisasjon fram til søknadsåpning?
- **Åpent spørsmål:** `@OPT-OPT-UTD-004` «Rettigheter for oppretting av nye regelverk» og spørsmålene om `@ref-`/`@depends-on-` i flere regler (se `# ÅPNE SPØRSMÅL:` i fila).
- **Åpent spørsmål:** `@OPT-OPT-UTD-016` «Beskrivelsen framvises søkeren i Min kompetanse» — hva ser søkeren når det ikke finnes noen beskrivelse på søkerens språk?
- **Åpent spørsmål:** `@OPT-OPT-UTD-017` «Søker finner utdanningstilbud via søkeord» — skal søkeordene tas med i søket i fs-plattform, og må min-kompetanse endres?
- **Åpent spørsmål:** `@OPT-OPT-UTD-010` «Se median poengsum for fjorårets opptatte» — leveres scenarioet når medianbranchen er merget?
- **Åpent spørsmål:** `@OPT-OPT-UTD-025` «Tidlig søknadsfrist må være før søknadsfristen for opptaket» — skal sjekken bygges, eller tas ut av kravet? Og hva skjer med søkere som ikke har lastet opp dokumentasjon innen den tidlige fristen?
- **Bygger på krav som ikke er levert:** `@OPT-OPT-UTD-026` og `@OPT-OPT-UTD-002` bygger på `@OPT-OVO-FRI-001` (`@in-progress`). `@OPT-OPT-UTD-004` bygger på `@OPT-REG-KVO-003` og `@OPT-REG-KVO-004` (`@planned`), `@OPT-OVO-INN-001` (`@in-progress`) og `@OPT-BEH-BEH-011` (`@planned`).
- **Jira SHI-686 dekket av krav:** SHI-687 (`@OPT-OPT-UTD-009`), SHI-688 og SHI-728 (`@OPT-OPT-UTD-010`), SHI-689 (`@OPT-OPT-UTD-011`), SHI-690 (`@OPT-OPT-UTD-012`), SHI-691 (`@OPT-OPT-UTD-013`), SHI-692 (`@OPT-OPT-UTD-014`), SHI-693 (`@OPT-OPT-UTD-015`), SHI-694 (`@OPT-OPT-UTD-016`), SHI-695 (`@OPT-OPT-UTD-017`), SHI-696 (`@OPT-OPT-UTD-004`, Regel: saksbehandlertildelingsregel), SHI-698 (`@OPT-OPT-UTD-019`), SHI-700 (`@OPT-OPT-UTD-021`), SHI-701 (`@OPT-OPT-UTD-022`), SHI-708 (`@OPT-OPT-UTD-025`), SHI-709 (`@OPT-OPT-UTD-003`).
- **Jira SHI-686 uten krav, men bygget:** SHI-731 «nytt for året» og SHI-727 «ID fra utdanningsinstansen vises» (se *Bygget uten krav* over).
- **Jira SHI-686 med krav som ikke dekker saken:** SHI-729 kjønnspoeng (`@OPT-OPT-UTD-027` er et skjelett, men koden finnes); SHI-750 studietypenummer med 4 siffer, ledende nuller og søk på nummeret (`@OPT-OPT-UTD-011` sier ingenting om det, og koden har fortsatt `NUMERIC(3)`, `fs-plattform/opptak/2026-so-basistabeller-v1.postgres-schema.sql:913`); SHI-752 tilbud uten studietype lagres, men flagges som ufullstendig (`er_komplett` i `MIG/V427:5-58` tar ikke med studietype, og ingen regel i `@OPT-OPT-UTD-011` eller `@OPT-OPT-UTD-001`); SHI-732 fristen 1. mars for poenglikhetsregel (står ikke i `@OPT-OPT-UTD-015`); SHI-703 kontaktinformasjon i Min kompetanse ligger i `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/se_egen_søknad.feature:61`, ikke her.
- **Jira SHI-686 uten krav og uten kode:** SHI-724 URL på studieretningsnivå, SHI-751 fagskole-studiekode (5-2 siffer), SHI-754 om studietypenummer bare gjelder UHG-opptak (avklaring), SHI-755 søkeord som forhåndsdefinert liste i opptaksinnstillinger (backlog). SHI-702 kvalitetssikre studiestart er lukket, og kravet er borte. SHI-697 (dokumentasjon) og SHI-746 (UI-feil) er ikke krav.
- **Status i krav og Jira er ulik:** `@OPT-OPT-UTD-004` er `@draft`, mens SHI-696 er Done (regelen er funnet, se *Delvis levert*). `@OPT-OPT-UTD-021` er `@draft`, mens SHI-700 er Closed: vurder å fjerne kravet med `fs-krav`. `@OPT-OPT-UTD-027` er `@draft`, mens SHI-729 er Done.
- **Krav uten sak i SHI-686:** `@OPT-OPT-UTD-029`, `@OPT-OPT-UTD-030` og `@OPT-OPT-UTD-031`. Mappene `01` og `02` hører til SHI-710 og SHI-747, og deler av `03` til #596 og #597.
