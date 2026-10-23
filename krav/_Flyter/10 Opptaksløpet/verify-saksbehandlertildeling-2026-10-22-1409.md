# Verifisering: saksbehandlertildeling.feature

- **Dato:** 2026-10-22 14:09
- **Krav:** `krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature` (1 feature-fil)
- **Kode:** `fs-plattform` (main, 74ed8c2bfc, oppdatert), `fs-admin` (main, f610b4d30, oppdatert), `min-kompetanse` (main, a74f95da, oppdatert)
- **Kontroll:** `fs-verify-kontroll`
- **Team:** 1 finner (`fs-verify-krav`), 1 kontrollør (`fs-verify-kontroll`), 1–1 feature-filer per finner
- **Skjermbilder:** nei

Gating-sett: alle scenarioene i scope, også `@draft` og `@planned`, minus `@demo` (verifisert uansett status).

Brukeren ba om å se hva som er implementert, uavhengig av status og åpne spørsmål. Derfor er det søkt etter scenarioene i alle fasene, også fasene som ikke er levert etter taggene. Flyten kan ikke bli `@implemented` før fasene er levert.

Stiene er forkortet:

- `SVC` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak`
- `SUB` = `fs-plattform/opptak/opptak-subgraph/src/main`
- `MIG` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `BTS` = `SVC/saksbehandling/BehandlertildelingService.java`
- `ALG` = `SVC/saksbehandling/BehandlertildelingAlgoritme.java`
- `AOPP` = `fs-admin/src/domains/opptak/features`
- `ASB` = `fs-admin/src/domains/soknadsbehandling/features`

## Oversikt per krav

`Gjenstår` sier hvilke repoer som må endres for at alle scenarioene i kravet skal være funnet.

| Feature-ID | Egenskap | Funnet | Gjenstår | Hva som gjenstår |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling | 6/8 | fs-plattform, fs-admin | Tilbyderen kommer ikke fram til søknadsalternativet når en annen organisasjon har saken. Det trengs en lesevei i fs-plattform og en flate i fs-admin. Det finnes heller ingen flate i fs-admin for å sette at en organisasjon saksbehandler på vegne av lærestedet (bare API-et). |

Gjenstår: fs-plattform, fs-admin 1, ingen 0.

## Oppsummering

- Scenarioer: 6 funnet, 1 ikke funnet, 1 usikker, av 8
- Krav levert (status satt til `@implemented`): 0
- Deler levert (status fjernet fra delen): 0
- Krav og deler som ikke er levert: 1
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
| `@FLY-OPT-SAK-001` | Lærestedene kan velge saksbehandlertildelingsregelen opptaket har satt opp | funnet | P: funnet · A: funnet · M: ikke relevant — lages: `SVC/regelverk/BehandlertildelingsregelMutations.java:38-55,130` (regelen lagres på opptaket med `er_aktiv`, og `ISOLERT` gir `behandles_isolert`), `AOPP/Behandlertildelingsregler/components/BehandlertildelingsregelEditor.tsx:155-157,280-290` (bare opptakets organisasjon, HK-dir, kan endre) · brukes: `AOPP/UtdanningstilbudDetails/UtdanningstilbudDetails.queries.ts:55-64` (aktive regler i opptaket, samme tabell), `AOPP/UtdanningstilbudDetails/components/RegelverkFelter/RegelverkFelter.tsx:82-91,164-176`; alle kan lese reglene (`MIG/V395__behandlertildelingsregel_per_opptak.sql:128-129`), og NTNU kan endre utdanningstilbudet som samordnet deltaker (`MIG/V300:52-68`, `fs-admin/src/domains/opptak/utils/kanEndreUtdanningstilbud.ts`) |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får saksbehandlertildelingsregelen fra opptaket | funnet | P: funnet · A: funnet · M: ikke relevant — lages: `AOPP/UtdanningstilbudDetails/hooks/useUtdanningstilbudEndre.tsx:128-146` (sender `behandlertildelingsregelId`) · brukes: `SVC/opptak/UtdanningstilbudMutations.java:318-385` (avviser regel fra et annet opptak og inaktiv regel, skriver `utdanningstilbud.behandlertildelingsregel_kode` :380), vises igjen i `RegelverkFelter.tsx:177-181` |
| `@FLY-OPT-SAK-001` | Søknaden blir én sak hos hver saksbehandlende organisasjon | funnet | P: funnet · A: ikke relevant · M: funnet — lages: `min-kompetanse/src/app/[locale]/admission/[opptakId]/application/(steps)/summary/_components/submit-soknad-button.tsx:59` → `leverSoknadskladd` → `SVC/soknad/StudiekurvService.java:893-903` (søknadshendelse) · brukes: `SUB/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java:312` → `BTS:200-225` (leser `behandlertildelingsregel_kode` fra fase 2, ellers standardregelen), `ALG:182-186` (ISOLERT gir NTNU), `ALG:212-238` (AV_ALLE gir UiO for Informatikk og Historie), `BTS:481-510` (én sak per organisasjon) |
| `@FLY-OPT-SAK-001` | Organisasjonen som saksbehandler på vegne av lærestedet får saken | usikker | P: funnet · A: mangler · M: funnet — lages: `SVC/opptak/OpprettOpptakMutations.java:447-487` (`settSamordnaDeltakerBehandler` skriver `opptak_samordna_organisasjon.organisasjonskode_behandler`, bare API) · brukes: `BTS:258-267,136` (samme kolonne, tilbyderen byttes med behandleren), `BTS:481-510` (saken lages hos OsloMet). Finneren: `ikke funnet`, fordi fs-admin ikke har noen flate for å sette forutsetningen (søkt etter «settSamordnaDeltakerBehandler», «organisasjonskodeBehandler», «vegne», «behandles av» i `fs-admin/src` og `src/common/messages/nb`). Kontrollen: overleveringen i `Når`/`Så` virker, bare `Gitt` mangler flate. Brukeren avgjør om en forutsetning som bare kan settes gjennom API-et, holder |
| `@FLY-OPT-SAK-001` | Saksbehandleren ved den saksbehandlende organisasjonen ser saken | funnet | P: funnet · A: funnet · M: ikke relevant — lages: `BTS:500-507` (setter `sak.organisasjonskode`) · brukes: `MIG/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:35-39` (saker leses på `sak.organisasjonskode`), `ASB/SakOverviewView/SakOverviewView.queries.ts:17-25` (`sakerV2`) |
| `@FLY-OPT-SAK-001` | Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler | ikke funnet | P: delvis · A: mangler · M: ikke relevant — lages: `SVC/saksbehandling/SettTilbudsgarantitypeService.java:62-123` (skriver `tilbudsgarantitype_kode_fra_tilbyder`; tilbyderen slipper gjennom på raden i `MIG/V454:41-55` og i kolonnevernet i `MIG/V346:161-167`) · brukes: ikke funnet. Tilbyderen kommer ikke fram til søknadsalternativet: det nås bare gjennom `Sak.sakSoknadsalternativer` (`SUB/resources/schema/features/experimental/saksbehandling/sak.graphqls:127`), og `sak` har ingen gren for tilbyderen (`MIG/V454:35-39`, `MIG/V346:74-76`). I fs-admin finnes valget bare i saken (`ASB/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx:196-213,312-322`) — søkt etter «tilbyder», «FraTilbyder», «erTilbyder», «tilbudsgaranti» i fs-admin og `node(id` / `SakSoknadsalternativ` i skjemaene i fs-plattform |
| `@FLY-OPT-SAK-001` | Søknadsalternativene flyttes til HK-dir før fristen for endring av utdanningsbakgrunn | funnet | P: funnet · A: funnet · M: ikke relevant — lages: fristen `FRIST_SELVBETJENING_UTDANNINGSBAKGRUNN` (`AOPP/OpptakManagement/OpptakDeadlinesSamordna/fristKort.ts:56`), saksbehandleren endrer bakgrunnen i `ASB/UtdanningsbakgrunnCard/UtdanningsbakgrunnCard.tsx:187-203` → `SVC/saksbehandling/UtdanningsbakgrunnOverstyringService.java:55-98,213-230` (setter `sak_soknad.b_rolle_overstyr` ut fra `SVC/opptak/Utdanningsbakgrunnsfrist.java:27-38`) · brukes: `BTS:313-334` (leser `b_rolle_overstyr`), `ALG:150-180` (unntaket for UTLAND), `BTS:422-469` (flytter alternativene til en sak hos HK-dir). Krever et UTLAND-unntak med HK-dir på regelen (`SVC/regelverk/BehandlertildelingsregelMutations.java:138-176`) |
| `@FLY-OPT-SAK-001` | Søknadsalternativene blir hos organisasjonen etter fristen for endring av utdanningsbakgrunn | funnet | P: funnet · A: funnet · M: ikke relevant — lages: `SVC/opptak/Utdanningsbakgrunnsfrist.java:35-37` (false etter fristen for en saksbehandler som ikke er opptaksforvalter), `SVC/saksbehandling/UtdanningsbakgrunnOverstyringService.java:84-94` (`b_rolle_overstyr = false`) · brukes: `BTS:314-321` (ser bort fra overstyringen, bruker søkerens egen bakgrunn), `ALG:169` (ingen flytting) |

## Kontroll

| Feature-ID | Scenario | Før kontroll | Etter kontroll | Hvorfor |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Organisasjonen som saksbehandler på vegne av lærestedet får saken | ikke funnet | usikker | `BTS:258-267,136` — overleveringen fra `settSamordnaDeltakerBehandler` virker i fs-plattform. Bare forutsetningen i `Gitt` mangler flate i fs-admin |

## Levert

Ingen.

## Ikke levert

| Feature-ID | Egenskap eller del | Status | Gating funnet | Hvorfor |
| --- | --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling | `@planned` | 6/8 | 1 ikke funnet, 1 usikker |

## Slettet

Ingen.

## @deprecated som fortsatt finnes i koden

Ingen.

## Oppfølging

- **Fasene er ikke levert:** ingen av de 5 fasene er levert etter taggene, selv om 6 av 8 overleveringer virker i koden. Kravene fasene bygger på, må verifiseres hver for seg (`@OPT-OVO-SAM-001` og `@OPT-OVO-FRI-001` er `@in-progress`, `@OPT-BEH-BEH-011` er `@planned`, `@OPT-OPT-UTD-004` er `@draft`) før flyten kan bli `@implemented`.
- **Kjent brudd i flyten:** at tilbyderen ikke kommer fram til søknadsalternativet når en annen organisasjon har saken, kan skrives som kjent brudd i flyten med `fs-krav` (modus E).
- **Frist som ikke er satt:** har opptaket ikke satt fristen for endring av utdanningsbakgrunn, regnes den som utløpt (`SVC/opptak/Utdanningsbakgrunnsfrist.java:36`). Da kan bare opptaksforvalteren flytte alternativene ved å endre bakgrunnen.
- **Kopi av kodeverket:** `opptak_v2.utdanningsbakgrunn_type` (`MIG/V400:80-111`) er en kopi, men fordelingen og fristsjekken leser `soknad_v2.utdanningsbakgrunn_type`. De stemmer i dag, men kan skille lag.
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Lærestedene kan velge saksbehandlertildelingsregelen opptaket har satt opp» — Er «tildelingsreglene» et samlebegrep for saksbehandlertildelingsreglene, standardregelen og unntakene, eller skal ordet byttes? Skal flyten bruke «UVH», så testdataene betyr det samme i flyten og i kravet?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Utdanningstilbudet får saksbehandlertildelingsregelen fra opptaket» — Skal fase 1 slutte med at «SPE» er aktiv i opptaket, eller skal de to fasene slås sammen?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Søknaden blir én sak hos hver saksbehandlende organisasjon» — Holder det med de to siste stegene?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Organisasjonen som saksbehandler på vegne av lærestedet får saken» — Skal scenarioet få steget om at AHO og OsloMet deltar i opptaket? Koden krever det for begge (`SVC/opptak/OpprettOpptakMutations.java:455-462,468-482`).
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Den saksbehandlende organisasjonen ser saken» — Skal scenarioet om tilbudsgaranti flyttes til en egen fase, eller skal regeltittelen utvides? Hvilken overlevering skal fasen vise?
