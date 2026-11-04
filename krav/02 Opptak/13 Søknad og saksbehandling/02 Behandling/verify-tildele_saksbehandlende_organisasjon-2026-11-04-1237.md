# Verifisering: tildele_saksbehandlende_organisasjon.feature

- **Dato:** 2026-11-04 12:37
- **Krav:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature` (1 feature-fil), og flyten `krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature`
- **Kode:** `fs-plattform` (main, b0c555e201, oppdatert), `fs-admin` (main, 52a3d0745, oppdatert), `min-kompetanse` (main, 19111241, oppdatert). Kravrepoet: `skills/fs-verify-rapporten-er-resultatet`, 7c10e402, oppdatert
- **Åpne MR-er:** 1 MR i fs-admin, 1 i min-kompetanse (1 med kode for kravene)
- **Omfang:** alle krav uansett status, flyter (valgt)
- **Avhengigheter:** 1 nivå, bare status
- **Kontroll:** `fs-verify-kontroll`
- **Menneskelig kontroll:** [Fylles ut: navn og dato for personen som har kontrollert rapporten]
- **Team:** 0 finnere (`fs-verify-krav`), 2 kontrollører (`fs-verify-kontroll`). Én feature-fil, så `fs-verify-agent-teams` fulgte `fs-verify` direkte, med kontrollørene som subagenter
- **Skjermbilder:** nei

Gating-sett: alle scenarioene, minus `@demo`, for `@OPT-BEH-BEH-011` (verifisert uansett status), og de som ikke er tagget `@draft`, `@deprecated` eller `@demo` for `@FLY-OPT-SAK-001`.

Stiene er forkortet:

- `Alg` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingAlgoritme.java`
- `Svc` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/BehandlertildelingService.java`
- `RegMut` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/regelverk/BehandlertildelingsregelMutations.java`
- `OppMut` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/OpprettOpptakMutations.java`
- `UtdMut` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/UtdanningstilbudMutations.java`
- `Ovst` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/UtdanningsbakgrunnOverstyringService.java`
- `Frist` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/opptak/Utdanningsbakgrunnsfrist.java`
- `Kurv` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/StudiekurvService.java`
- `Jobb` = `fs-plattform/opptak/opptak-subgraph/src/main/java/no/sikt/fs/opptak/app/SoknadshendelseJobb.java`
- `Mig` = `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration`
- `Regl` = `fs-admin/src/domains/opptak/features/Behandlertildelingsregler`
- `Sb` = `fs-admin/src/domains/soknadsbehandling`

## Oppsummering

- Scenarioer: 56 funnet, 8 ikke funnet, 0 usikker, av 64
- Forslag: 0 kan leveres, 1 delvis levert, 0 kan slettes, 1 kan leveres når det er avklart, 2 blir stående
- Tilgang og datakonsistens: 17 stemmer, 0 avviker, 0 ikke funnet, 0 usikker, av 18 (1 ikke beskrevet)
- Regler i koden uten scenario: 13
- Åpne spørsmål: 4 regler og 10 scenarioer i gating-settet, 1 utenfor gating (`@draft`)
- Endringer gjort: 0 krav og 4 deler fikk ny status, 0 filer og 0 blokker slettet

## Forslag til endringer

*Kan leveres* og *Delvis levert* er sikre: alle scenarioene er funnet, og kontrollen har bekreftet hver rad. De settes i kjøringen når brukeren sier ja (se `## Endringer`). Resten må avklares: gi rapporten tilbake til `fs-verify`.

**Delvis levert**

- `@OPT-BEH-BEH-011` — Tildele saksbehandlende organisasjon (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature`, 54/57 funnet): `@implemented` på Regel: Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet (linje 476), Scenario: Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene (linje 287), Scenario: Organisasjonen som saksbehandler på vegne av lærestedet må delta i opptaket (linje 294), Scenario: Endret valg gjelder bare søknadsalternativer som ikke er fordelt (linje 299)

**Kan leveres når det er avklart**

- `@OPT-BEH-BEH-011` — Tildele saksbehandlende organisasjon (`krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature:4`): kan få `@implemented` hvis to scenarioer avklares. «Søkeren ser saksbehandlende organisasjon, men ikke sakene» (`krav/…/tildele_saksbehandlende_organisasjon.feature:455`) er `ikke funnet`: API-et finnes (`Mig/V504__soker_saksbehandlende_organisasjon.sql:15-26`), men visningen i min-kompetanse finnes bare i MR !994 (utkast). «Velge organisasjon som saksbehandler på vegne av lærestedet når lærestedet legges til i opptaket» (`krav/…:280`) er `ikke funnet`: fs-admin har bygget valget på behandlertildelingsregelen (`Regl/components/BehandlertildelingsregelPaVegneAv.tsx`), og det åpne spørsmålet på regelen (linje 275) spør om kravet skal skrives om slik. Det tredje scenarioet som ikke er funnet, «Flyttet søknadsalternativ vises som overført …» (linje 439), er `@draft`, og en `@implemented` egenskap kan ha `@draft`-deler, så det stopper ikke en vanlig verifisering av kravet.

**Blir stående**

- `@OPT-BEH-BEH-011` — Tildele saksbehandlende organisasjon (`@in-progress`, 54/57 funnet): 3 ikke funnet: «Velge organisasjon som saksbehandler på vegne av lærestedet når lærestedet legges til i opptaket», «Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til» (`@draft`), «Søkeren ser saksbehandlende organisasjon, men ikke sakene»
- `@FLY-OPT-SAK-001` — Saksbehandlertildeling (`@planned`, 2/7 funnet): 1 av 5 faser levert. Fase 1, 2, 4 og 5 venter på kravene de bygger på (se `## Fremdrift for flyter`). Overleveringene i fase 3 er funnet.

## Oppfølging

- **Ikke funnet:** `@OPT-BEH-BEH-011` «Velge organisasjon som saksbehandler på vegne av lærestedet når lærestedet legges til i opptaket» (`krav/…/tildele_saksbehandlende_organisasjon.feature:280`) — fs-plattform har `settSamordnaDeltakerBehandler` (`OppMut:437-477`), men fs-admin kaller den ikke. Søkt etter «settSamordnaDeltakerBehandler», «SamordnaDeltakerBehandler», «organisasjonskodeBehandler», «leggTilDeltaker» i fs-admin på main og i branchene under `## Åpne MR-er og brancher`
- **Ikke funnet:** `@OPT-BEH-BEH-011` «Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til» (`krav/…:439`, `@draft`) — ingen status «Overført». Søkt etter «overført», «overfort», «OVERFORT», «transferred», «ulest», «uåpnet» i alle tre repoene
- **Ikke funnet:** `@OPT-BEH-BEH-011` «Søkeren ser saksbehandlende organisasjon, men ikke sakene» (`krav/…:455`) — finnes i MR !994 (utkast, min-kompetanse). min-kompetanse på main viser bare opptakets organisasjon
- **Kravet er bak koden:** `@OPT-BEH-BEH-011` «Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket» (`krav/…:274`) — fs-admin setter «på vegne av» på behandlertildelingsregelen (STEK-579, `Regl/components/BehandlertildelingsregelPaVegneAv.tsx`, `RegMut:260-304`, `Mig/V478__behandlertildelingsregel_pa_vegne_av.sql`). Kravet sier at valget gjøres når lærestedet legges til i opptaket. Fordelingen støtter begge (`Svc:121`, `Svc:232-239`, `Alg:313-315`). Avklar med `fs-krav`
- **Åpent spørsmål:** `@OPT-BEH-BEH-011` «Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket» (`krav/…:273`) — Skal regelen skrives om, så «på vegne av» er en behandlertildelingsregel som opptaksforvalteren ved organisasjonen som oppretter opptaket, setter (forslag fra Ingrid Helset i STEK-579, 22.10.2026, som Marit Bjørnerud Rønning er enig i)? Koden i fs-admin gjør det allerede slik (se punktet over)
- **Åpent spørsmål:** `@OPT-BEH-BEH-011` «Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til» (`krav/…:429`, `@draft`) — status «Overført» og uleste dokumenter (workshoprapporten 29.05.2026), eller det Ingrid Helset sa 23.10.2026: behandlingsstatus «ikke behandlet» og dokumentene satt tilbake til uåpnet? Ikke bygget. Dokumentene har «lest» per sak (`Sb/features/DokumenterCard/DocumentItem/DocumentItem.tsx:35-44`), og flyttingen lager en ny sak (`Svc:385-428`)
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Behandlertildelingsreglene settes for opptaket» (`krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature:18`) — skal flyten bruke «UVH», så testdataene betyr det samme som i OPT-BEH-BEH-011?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Utdanningstilbudet får behandlertildelingsregel» (`krav/_Flyter/…:30`) — skal fase 1 og 2 slås sammen?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Søknaden blir én sak hos hver saksbehandlende organisasjon» (`krav/_Flyter/…:46`) — holder det med de to siste stegene?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Organisasjonen som saksbehandler på vegne av lærestedet får saken» (`krav/_Flyter/…:59`) — skal scenarioet ha steget om at AHO og OsloMet deltar i opptaket?
- **Åpent spørsmål:** `@FLY-OPT-SAK-001` «Den saksbehandlende organisasjonen ser saken» (`krav/_Flyter/…:72`) — skal scenarioet om tilbudsgaranti flyttes til en egen fase, og hvilken overlevering skal fasen vise?
- **Kontrollen endret:** `@OPT-BEH-BEH-011` regel uten scenario «En overstyring som har flyttet saken, kan endres av …» — «bare opptaksforvalteren» → «den som selv kunne satt den»: `Ovst:126-149` slipper også gjennom saksbehandleren før fristen, og alle for bakgrunner uten frist (REAL, DISP)
- **Merknad:** `@OPT-BEH-BEH-011` «Saksbehandleren ser bare saken hos organisasjonen sin» (`krav/…:450`) — når UiO tilbyr et søknadsalternativ som UiT saksbehandler, ser saksbehandleren ved UiO også saken hos UiT, gjennom tilbydergrenen (`Mig/V501__tilbyderoppslag_per_sak.sql:43-52`). Det følger av regelen på linje 476, men scenarioet sier ikke at ingen av søknadsalternativene i saken hos UiT er UiO-tilbud
- **Kontrollen rettet bevis:** `@OPT-BEH-BEH-011` «Tilbyderen setter tilbudsgaranti» — fs-admin-beviset var en testhjelper. Det riktige er `Sb/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx:235-237, 322-325`. Resultatet er uendret
- **Uklart om ønsket:** `@OPT-BEH-BEH-011` — et unntak for utdanningsbakgrunn kan fordele til en organisasjon som ikke deltar i opptaket (`RegMut:191-201`, `Regl/components/BehandlertildelingsregelUnntak.tsx:78`). Organisasjonen for sektoren og «på vegne av» må derimot delta
- **Bygger på krav som ikke er levert:** `@OPT-BEH-BEH-011` Regel: Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak bygger på `@OPT-OVO-FRI-001` (`@in-progress`). Ankeret, regelen om frist for endring av utdanningsbakgrunn (`krav/02 Opptak/11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature:281`), er ikke levert. Regelen i OPT-BEH-BEH-011 er allerede `@implemented`, og fristen er funnet i koden (`Frist:27-42`)
- **Testplan:** `akseptansetest/opptak-saksbehandlertildeling/testplan.md` har med kravet. Kjør `fs-testplan` på nytt når statusen er endret

## Endringer

| Feature-ID | Egenskap eller del | Endring | Avklart |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | Regel: Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-011` | Scenario: Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-011` | Scenario: Organisasjonen som saksbehandler på vegne av lærestedet må delta i opptaket | `@implemented` på delen | ja i kjøringen |
| `@OPT-BEH-BEH-011` | Scenario: Endret valg gjelder bare søknadsalternativer som ikke er fordelt | `@implemented` på delen | ja i kjøringen |

## Fremdrift for flyter

| Flyt | Fase | Bygger på | Fase levert |
| --- | --- | --- | --- |
| `@FLY-OPT-SAK-001` | Behandlertildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001` (`@in-progress`, hele kravet), `@OPT-BEH-BEH-011` (`@in-progress`, Regel: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket levert, Regel: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket ikke levert) | nei |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får behandlertildelingsregel | `@OPT-OPT-UTD-004` (`@draft`) | nei |
| `@FLY-OPT-SAK-001` | Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` (`@in-progress`, Regel: Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast levert) | ja |
| `@FLY-OPT-SAK-001` | Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` (`@in-progress`, Regel: Saksbehandlende organisasjon ser bare saker hos organisasjonen og Regel: Tilbyderen ser saksbehandlingen … ikke levert), `@OPT-BEH-BEH-010` (`@implemented`) | nei |
| `@FLY-OPT-SAK-001` | Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `@OPT-OVO-FRI-001` (`@in-progress`, Regel: … frist for endring av utdanningsbakgrunn ikke levert), `@OPT-BEH-BEH-011` (`@in-progress`, Regel: Søknadsalternativene flyttes … levert) | nei |

`@FLY-OPT-SAK-001`: 1 av 5 faser levert.

## Avhengigheter

Avhengighetene får aldri ny status i denne kjøringen.

| Krav i scope | Bygger på | Nivå | Status | Funnet | Merknad |
| --- | --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | `@OPT-OVO-FRI-001` Frister og hendelser | 1 | `@in-progress` | – | ikke levert. Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn |
| `@FLY-OPT-SAK-001` | `@OPT-OVO-SAM-001` Samordna opptak | 1 | `@in-progress` | – | ikke levert |
| `@FLY-OPT-SAK-001` | `@OPT-OPT-UTD-004` Opptaksinnstillinger for utdanningstilbud | 1 | `@draft` | – | ikke levert. Regel: Opptaksforvalter kan velge behandlertildelingsregel per utdanningstilbud |
| `@FLY-OPT-SAK-001` | `@OPT-BEH-BEH-010` Gi tilbudsgaranti | 1 | `@implemented` | – | |
| `@FLY-OPT-SAK-001` | `@OPT-OVO-FRI-001` Frister og hendelser | 1 | `@in-progress` | – | ikke levert. Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn |

## Scenarioer

| Feature-ID | Scenario | Resultat | Bevis |
| --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | Opprette behandlertildelingsregel | funnet | `RegMut:41-62`, `Regl/components/BehandlertildelingsregelEditor.tsx:296-320` |
| `@OPT-BEH-BEH-011` | Nytt opptak får standard behandlertildelingsregel med «Alle som deltar i opptaket» | funnet | `OppMut:112-114`, `OppMut:359-371` |
| `@OPT-BEH-BEH-011` | Bytte standard behandlertildelingsregel | funnet | `OppMut:389-430`, `Regl/components/BehandlertildelingsregelStandard.tsx:125`, `Svc:95`, `Svc:187` |
| `@OPT-BEH-BEH-011` | Opptaket kan bare ha én aktiv behandlertildelingsregel med «Alle som deltar i opptaket» | funnet | `Mig/V395__behandlertildelingsregel_per_opptak.sql:88-90` |
| `@OPT-BEH-BEH-011` | Se hvilke utdanningstilbud som er knyttet til behandlertildelingsregelen | funnet | `Regl/components/BehandlertildelingsreglerResultList.tsx:137-138`, `Regl/components/BehandlertildelingsregelUtdanningstilbudResultList.tsx:30-74` |
| `@OPT-BEH-BEH-011` | Slette behandlertildelingsregel som ikke er knyttet til utdanningstilbud | funnet | `RegMut:132-150`, `Regl/components/BehandlertildelingsregelEditor.tsx:254-280` |
| `@OPT-BEH-BEH-011` | Behandlertildelingsregel som er knyttet til utdanningstilbud kan ikke slettes | funnet | `Regl/components/BehandlertildelingsregelEditor.tsx:231-233, 522`, `Mig/V395__behandlertildelingsregel_per_opptak.sql:104-109` |
| `@OPT-BEH-BEH-011` | Behandlertildelingsregel som <bruk> kan ikke deaktiveres | funnet | `RegMut:89-92`, `RegMut:208-225` |
| `@OPT-BEH-BEH-011` | Behandlertildelingsreglene er ikke tilgjengelige i lokale opptak | funnet | `fs-admin/src/domains/opptak/features/OpptakManagement/OpptakManagementPage.tsx:439-441`, `fs-admin/src/app/opptak/[id]/behandlertildelingsregler/layout.tsx:32-35`, `RegMut:242` |
| `@OPT-BEH-BEH-011` | Deltakende lærested kan ikke endre behandlertildelingsreglene | funnet | `Regl/components/BehandlertildelingsreglerResultList.tsx:72-75`, `Regl/components/BehandlertildelingsregelEditor.tsx:164-166, 522`, `Mig/V395__behandlertildelingsregel_per_opptak.sql:130-136` |
| `@OPT-BEH-BEH-011` | Lærestedet på første prioritet saksbehandler hele søknaden | funnet | `Alg:257-283` |
| `@OPT-BEH-BEH-011` | Søknadsalternativ med egen behandlertildelingsregel avgjør ikke hvem som saksbehandler resten av søknaden | funnet | `Alg:227-231`, `Alg:257-266` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler søknadsalternativene uten egen behandlertildelingsregel | funnet | `Alg:241-244`, `Alg:274-283` |
| `@OPT-BEH-BEH-011` | Tilbyderen søkeren har prioritert høyest saksbehandler søknadsalternativene uten egen behandlertildelingsregel | funnet | `Alg:233-244`, `Alg:274-283` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer | funnet | `Alg:227-231`, `Alg:257-266` |
| `@OPT-BEH-BEH-011` | Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet | funnet | `Svc:187`, `Svc:218-220`, `Alg:227-231` |
| `@OPT-BEH-BEH-011` | Tilbyderen søkeren har prioritert høyest i sektoren saksbehandler hele sektoren | funnet | `Alg:245-253`, `Alg:317-330` |
| `@OPT-BEH-BEH-011` | Organisasjonen som er valgt på behandlertildelingsregelen saksbehandler hele sektoren | funnet | `Alg:248-251`, `Svc:207` |
| `@OPT-BEH-BEH-011` | Søknadsalternativer i ulike sektorer fordeles hver for seg | funnet | `Alg:245-253`, `Alg:274-283` |
| `@OPT-BEH-BEH-011` | Sektoren er lærestedene som har utdanningstilbud med samme behandlertildelingsregel | funnet | `Alg:236-253`, `Mig/V469__deltaker_skriver_bare_egne_utdanningstilbud.sql:78-80`, `UtdMut:340-361` |
| `@OPT-BEH-BEH-011` | Søkerens prioritering avgjør hvem som saksbehandler søknadsalternativene uten egen behandlertildelingsregel | funnet | `Alg:233-244` |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren kan velge <organisasjon> som organisasjon for sektoren | funnet | `Regl/components/BehandlertildelingsregelSektorOrganisasjonCombobox.tsx:81-95`, `RegMut:250-258` |
| `@OPT-BEH-BEH-011` | Organisasjonen for sektoren må delta i opptaket | funnet | `Regl/components/BehandlertildelingsregelSektorOrganisasjonCombobox.tsx:81-95`, `RegMut:250-258` |
| `@OPT-BEH-BEH-011` | Legge til unntak for utdanningsbakgrunn | funnet | `Regl/components/BehandlertildelingsregelUnntak.tsx:78-115`, `RegMut:167-202` |
| `@OPT-BEH-BEH-011` | HK-dir saksbehandler hele søknaden når søkeren har utdanningsbakgrunn <utdanningsbakgrunn> | funnet | `Svc:315-331`, `Alg:172-205` |
| `@OPT-BEH-BEH-011` | Hver tilbyder saksbehandler sitt eget søknadsalternativ når søkeren har realkompetanse | funnet | `Svc:111-113`, `Svc:308-313`, `Mig/V407__utdanningsbakgrunn_behandles_tilbyder.sql:15-17` |
| `@OPT-BEH-BEH-011` | Unntaket går foran behandlertildelingsregel der bare tilbyderen saksbehandler | funnet | `Alg:149-159`, `Alg:172-205`, `Alg:239` |
| `@OPT-BEH-BEH-011` | Behandlertildelingsregel uten unntak for søkerens utdanningsbakgrunn følges som vanlig | funnet | `Alg:179-182`, `Alg:227-231` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler alltid søknadsalternativ til ledig studieplass | funnet | `Alg:161-170`, `Kurv:1362-1371`, `Kurv:1391-1407` |
| `@OPT-BEH-BEH-011` | Ledig studieplass går foran unntak for utdanningsbakgrunn | funnet | `Alg:153-154`, `Alg:174-178` |
| `@OPT-BEH-BEH-011` | Tilbyderen saksbehandler ledig studieplass som legges til på vegne av søkeren | funnet | `Kurv:1100-1148`, `Kurv:1395`, `Alg:161-170` |
| `@OPT-BEH-BEH-011` | Velge organisasjon som saksbehandler på vegne av lærestedet når lærestedet legges til i opptaket | ikke funnet | fs-plattform har mutationen `settSamordnaDeltakerBehandler` (`OppMut:437-477`), men fs-admin kaller den ikke. I fs-admin velges «på vegne av» på behandlertildelingsregelen (`Regl/components/BehandlertildelingsregelPaVegneAv.tsx`, `RegMut:260-304`), ikke når lærestedet legges til — søkt etter «settSamordnaDeltakerBehandler», «SamordnaDeltakerBehandler», «organisasjonskodeBehandler», «leggTilDeltaker» i fs-admin, på main og i branchene |
| `@OPT-BEH-BEH-011` | Organisasjonen som saksbehandler på vegne av lærestedet får søknadsalternativene | funnet | `Svc:121`, `Svc:232-239`, `Alg:313-315` |
| `@OPT-BEH-BEH-011` | Organisasjonen som saksbehandler på vegne av lærestedet må delta i opptaket | funnet | `OppMut:456-470`, `RegMut:287-304` |
| `@OPT-BEH-BEH-011` | Endret valg gjelder bare søknadsalternativer som ikke er fordelt | funnet | `Alg:33-38`, `Alg:307-311` |
| `@OPT-BEH-BEH-011` | Søknadsalternativene fordeles når <hendelse> | funnet | `Kurv:953`, `Kurv:1063`, `Kurv:1148`, `Jobb:313` |
| `@OPT-BEH-BEH-011` | Søknaden får én sak per saksbehandlende organisasjon | funnet | `Svc:346-365`, `Svc:441-468` |
| `@OPT-BEH-BEH-011` | Tilbyder som ikke er saksbehandlende organisasjon får ingen sak | funnet | `Svc:354`, `Svc:441-468` |
| `@OPT-BEH-BEH-011` | Ny prioritering endrer ikke saksbehandlende organisasjon | funnet | `Alg:307-311`, `Svc:247-254` |
| `@OPT-BEH-BEH-011` | Nytt søknadsalternativ uten egen behandlertildelingsregel får samme saksbehandlende organisasjon som før | funnet | `Alg:207-225`, `Alg:317-323` |
| `@OPT-BEH-BEH-011` | Nytt søknadsalternativ der bare tilbyderen saksbehandler endrer ikke søknadsalternativene som er fordelt | funnet | `Alg:241-244`, `Alg:307-311` |
| `@OPT-BEH-BEH-011` | Sletting av søknadsalternativet fordelingen bygget på endrer ikke de andre søknadsalternativene | funnet | `Svc:181`, `Svc:333-340`, `Alg:307-311` |
| `@OPT-BEH-BEH-011` | Søkeren bytter til utenlandsk utdanningsbakgrunn | funnet | `Kurv:1040-1066`, `Mig/V355__selvbetjeningsfrist_utdanningsbakgrunn.sql:48-50`, `Alg:194-196` |
| `@OPT-BEH-BEH-011` | Søkeren bytter til realkompetanse | funnet | `Mig/V348__refordeling_b_rolle_ved_endret_utdanningsbakgrunn.sql:24-26`, `Svc:111-113`, `Alg:184`, `Alg:194-196` |
| `@OPT-BEH-BEH-011` | Bytte fra <utdanningsbakgrunn> til norsk utdanningsbakgrunn flytter ingen søknadsalternativer | funnet | `Mig/V348__refordeling_b_rolle_ved_endret_utdanningsbakgrunn.sql:20`, `Alg:194`, `Alg:307-311` |
| `@OPT-BEH-BEH-011` | Saksbehandleren endrer utdanningsbakgrunnen til <utdanningsbakgrunn> | funnet | `Ovst:44-75`, `Frist:32-33`, `Mig/V355__selvbetjeningsfrist_utdanningsbakgrunn.sql:42-44`, `Svc:282-301` |
| `@OPT-BEH-BEH-011` | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen <frist> | funnet | `Frist:35-37`, `Ovst:48, 66`, `Svc:282-290` |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen | funnet | `Frist:37-42`, `Sb/features/UtdanningsbakgrunnCard/UtdanningsbakgrunnCard.tsx:147-150, 230-246` |
| `@OPT-BEH-BEH-011` | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til | funnet | `Svc:385-428` |
| `@OPT-BEH-BEH-011` | Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til | ikke funnet | `@draft`. Flyttingen lager en ny sak hos organisasjonen det flyttes til (`Svc:385-428`), men setter ingen status «Overført» og markerer ikke dokumentene — søkt etter «overført», «overfort», «OVERFORT», «transferred», «ulest», «uåpnet» i fs-plattform, fs-admin og min-kompetanse |
| `@OPT-BEH-BEH-011` | Saksbehandleren ser bare saken hos organisasjonen sin | funnet | `Mig/V501__tilbyderoppslag_per_sak.sql:37-52` |
| `@OPT-BEH-BEH-011` | Søkeren ser saksbehandlende organisasjon, men ikke sakene | ikke funnet | ikke funnet på main — finnes i MR !994 (utkast, min-kompetanse, stek-664-vis-saksbehandlende-organisasjon): `src/app/[locale]/soknader/[soknadId]/_queries/soknad-query.tsx:90` — henter `saksbehandlendeOrganisasjon` per søknadsalternativ. API-et er på main i fs-plattform (`Mig/V504__soker_saksbehandlende_organisasjon.sql:15-26`) |
| `@OPT-BEH-BEH-011` | Saksbehandleren ved forvaltende organisasjon ser bare saken hos forvaltende organisasjon | funnet | `Mig/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:20-27`, `Mig/V501__tilbyderoppslag_per_sak.sql:37-42` |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner | funnet | `Mig/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:20-27`, `Mig/V501__tilbyderoppslag_per_sak.sql:41-42` |
| `@OPT-BEH-BEH-011` | Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler | funnet | `Mig/V501__tilbyderoppslag_per_sak.sql:22-52`, `Mig/V493__tilbyder_ser_saksbehandlingen.sql:18-45`, `Sb/hooks/useKanSaksbehandle.ts:23-41` |
| `@OPT-BEH-BEH-011` | Tilbyderen setter tilbudsgaranti | funnet | `Mig/V346__kolonnevern_tilbudsgaranti.sql:161-169`, `Sb/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx:235-237, 322-325` |
| `@OPT-BEH-BEH-011` | Tilbyderen kan ikke endre saksbehandlingen | funnet | `Mig/V493__tilbyder_ser_saksbehandlingen.sql:68-83, 89-150`, `Sb/hooks/useKanSaksbehandle.ts:30-41` |
| `@FLY-OPT-SAK-001` | Lærestedene kan velge behandlertildelingsregelen opptaket har satt opp | ikke funnet | fasen er ikke levert: `@OPT-OVO-SAM-001` er `@in-progress`, og ankeret i Regel: Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket i `@OPT-BEH-BEH-011` er ikke levert |
| `@FLY-OPT-SAK-001` | Utdanningstilbudet får behandlertildelingsregelen fra opptaket | ikke funnet | fasen er ikke levert: `@OPT-OPT-UTD-004` er `@draft` |
| `@FLY-OPT-SAK-001` | Søknaden blir én sak hos hver saksbehandlende organisasjon | funnet | lages: `UtdMut:340-395`, `Kurv:953` · brukes: `Svc:164-188`, `Jobb:265, 313`, `Svc:346-365, 441-468` |
| `@FLY-OPT-SAK-001` | Organisasjonen som saksbehandler på vegne av lærestedet får saken | funnet | lages: `OppMut:437-477` · brukes: `Svc:121, 232-239` |
| `@FLY-OPT-SAK-001` | Saksbehandleren ved den saksbehandlende organisasjonen ser saken | ikke funnet | fasen er ikke levert: Regel: Saksbehandlende organisasjon ser bare saker hos organisasjonen og Regel: Tilbyderen ser saksbehandlingen … i `@OPT-BEH-BEH-011` er ikke levert |
| `@FLY-OPT-SAK-001` | Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler | ikke funnet | fasen er ikke levert: som over |
| `@FLY-OPT-SAK-001` | Saksbehandlertildelingen bruker fristen opptaket har satt | ikke funnet | fasen er ikke levert: ankeret i `@OPT-OVO-FRI-001` er ikke levert |

## Tilgang og datakonsistens

Sjekket på kodenivå, ikke testet. Radene er grunnlaget for testbrukerne i testplanen.

| Feature-ID | Sjekk | Rolle og handling | Resultat | Bevis |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | tilgang | Opptaksforvalter ved forvaltende organisasjon oppretter, endrer og sletter behandlertildelingsregel | stemmer | `Mig/V395__behandlertildelingsregel_per_opptak.sql:130-136`, `Regl/components/BehandlertildelingsreglerResultList.tsx:72-75`, `Regl/components/BehandlertildelingsregelEditor.tsx:164-166` |
| `@OPT-BEH-BEH-011` | tilgang | Opptaksforvalter ved deltakende lærested oppretter, endrer eller sletter behandlertildelingsregel (avvises) | stemmer | `Mig/V395__behandlertildelingsregel_per_opptak.sql:130-136`, `RegMut:232-241` |
| `@OPT-BEH-BEH-011` | tilgang | Alle leser behandlertildelingsreglene | ikke beskrevet | kravet sier ikke hvem som kan lese reglene (bare at deltakende lærested åpner dem, linje 93), koden lar alle lese — `Mig/V395__behandlertildelingsregel_per_opptak.sql:128-129` |
| `@OPT-BEH-BEH-011` | tilgang | Opptaksforvalter ved forvaltende organisasjon endrer standardregel | stemmer | `Regl/components/BehandlertildelingsregelStandard.tsx:85-97`, `OppMut:389-430` |
| `@OPT-BEH-BEH-011` | tilgang | Opptaksforvalter ved forvaltende organisasjon endrer organisasjon som saksbehandler på vegne av lærested | stemmer | `OppMut:437-445`, `RegMut:260-304`, `Mig/V478__behandlertildelingsregel_pa_vegne_av.sql:48-54` |
| `@OPT-BEH-BEH-011` | tilgang | Opptaksforvalter ved deltakende lærested endrer behandlertildelingsregel for utdanningstilbudene ved lærestedet | stemmer | `Mig/V469__deltaker_skriver_bare_egne_utdanningstilbud.sql:78-80`, `UtdMut:340-361` |
| `@OPT-BEH-BEH-011` | organisasjon | Saksbehandler leser bare saker hos organisasjonen sin | stemmer | `Mig/V501__tilbyderoppslag_per_sak.sql:37-52` |
| `@OPT-BEH-BEH-011` | organisasjon | Saksbehandler ved forvaltende organisasjon (uten MODIFISERE_OPPTAK) leser bare saker hos forvaltende organisasjon | stemmer | `Mig/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:20-27` |
| `@OPT-BEH-BEH-011` | tilgang | Opptaksforvalter ved forvaltende organisasjon leser alle sakene i opptaket | stemmer | `Mig/V454__forvalter_ser_saker_krever_modifisere_opptak.sql:20-27`, `Mig/V501__tilbyderoppslag_per_sak.sql:41-42` |
| `@OPT-BEH-BEH-011` | tilgang | Tilbyder leser saken og søknadsalternativene på utdanningstilbudene sine, ikke interne merknader | stemmer | `Mig/V501__tilbyderoppslag_per_sak.sql:22-52`, `Mig/V493__tilbyder_ser_saksbehandlingen.sql:68-83` |
| `@OPT-BEH-BEH-011` | tilgang | Tilbyder endrer grunnlag og poeng (avvises) | stemmer | `Mig/V493__tilbyder_ser_saksbehandlingen.sql:89-150`, `Sb/hooks/useKanSaksbehandle.ts:30-41` |
| `@OPT-BEH-BEH-011` | tilgang | Tilbyder endrer tilbudsgaranti | stemmer | `Mig/V346__kolonnevern_tilbudsgaranti.sql:161-169`, `Sb/features/SakDrawer/components/SoknadsalternativerList/components/TilbudsgarantitypeSelect/TilbudsgarantitypeSelect.tsx:235-237` |
| `@OPT-BEH-BEH-011` | tilgang | Søker leser saksbehandlende organisasjon for søknadsalternativene sine, ikke sakene | stemmer | `Mig/V504__soker_saksbehandlende_organisasjon.sql:15-26` (fs-plattform; visningen i min-kompetanse er ikke merget) |
| `@OPT-BEH-BEH-011` | tilgang | Saksbehandler endrer utdanningsbakgrunn etter fristen (flytter ikke), opptaksforvalter er ikke bundet | stemmer | `Frist:27-42`, `Ovst:48, 66`, `Ovst:136-149` |
| `@OPT-BEH-BEH-011` | organisasjon | Organisasjon for sektoren og organisasjon på vegne av må delta i opptaket | stemmer | `RegMut:250-258`, `RegMut:287-304`, `OppMut:456-470` |
| `@OPT-BEH-BEH-011` | konsistens | Opptaksforvalter sletter behandlertildelingsregel som er i bruk (avvises) | stemmer | `Mig/V395__behandlertildelingsregel_per_opptak.sql:97-109`, `RegMut:137-148` |
| `@OPT-BEH-BEH-011` | konsistens | Opptaksforvalter deaktiverer behandlertildelingsregel som er standard eller i bruk (avvises) | stemmer | `RegMut:204-225` |
| `@OPT-BEH-BEH-011` | konsistens | Flytting av søknadsalternativ: saken som forlates, beholder merknader, dokumenter og grunnlag, og blir inaktiv uten alternativer | stemmer | `Svc:367-384`, `Svc:583-602` |

## Regler uten scenario

Regler i koden som ingen scenario i kravet dekker. Input til testplanen og den agentiske testen (fase 2). Lista har det som ble sett under letingen, og er ikke fullstendig.

| Feature-ID | Regel i koden | Type | Bevis | Forslag |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | Har opptaket ingen frist for endring av utdanningsbakgrunn, teller saksbehandlerens endring til utenlandsk eller steinerskole aldri i tildelingen, bare opptaksforvalterens | tilstandsovergang | `Frist:35-37` | uklart om ønsket |
| `@OPT-BEH-BEH-011` | Retter saksbehandleren søknaden på vegne av søkeren til en bakgrunn som flytter søknadsalternativene, etter fristen, avvises rettingen («kan bare settes på søknaden av forvalteren av opptaket, eller innenfor fristen for selvbetjent endring»). Overstyringen lagres derimot, men flytter ikke | validering | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/soknad/oppdatersoknad/OppdaterSoknadISoknadsbehandlingService.java:170-176` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-011` | En overstyring av utdanningsbakgrunnen som har flyttet saken, kan bare endres eller fjernes av den som selv kunne satt den: opptaksforvalteren, saksbehandleren før fristen, og alle for bakgrunner uten frist (realkompetanse, dispensasjon) | tilgangssjekk | `Ovst:126-149` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-011` | Realkompetanse og dispensasjon kan ikke få unntak på en behandlertildelingsregel | validering | `RegMut:179-190`, `Regl/components/BehandlertildelingsregelUnntak.tsx:101-115` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Én utdanningsbakgrunn kan bare ha ett unntak per behandlertildelingsregel | validering | `RegMut:171-178`, `Regl/components/BehandlertildelingsregelUnntak.tsx:101-103` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Et lærested kan ikke saksbehandle på vegne av seg selv | validering | `RegMut:292-295`, `OppMut:459-461` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | En organisasjon som er organisasjon for sektoren, eller lærested eller behandler i «på vegne av», på en regel som er aktiv eller i bruk, kan ikke tas ut av opptaket | validering | `OppMut:574-577`, `OppMut:642-690` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Tas organisasjonen som saksbehandler på vegne av en deltaker, ut av opptaket, nullstilles valget | tilstandsovergang | `OppMut:585-595` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | En inaktiv behandlertildelingsregel kan ikke være standard («er inaktiv og kan ikke være standard») | validering | `OppMut:417-421` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Standardregelen kan ikke slettes (slett-knappen vises ikke, og fremmednøkkelen avviser) | validering | `Mig/V395__behandlertildelingsregel_per_opptak.sql:97-101`, `Regl/components/BehandlertildelingsregelEditor.tsx:231-233, 522` | legg til scenario med `fs-krav` |
| `@OPT-BEH-BEH-011` | Søknader i et opptak uten standardregel blir ikke fordelt, men venter («Opptaket mangler default behandlertildelingsregel») | tilstandsovergang | `Svc:68`, `Svc:95-98`, `Jobb:300-306` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | En sak uten søknadsalternativer igjen blir inaktiv, og blir aktiv igjen når den får et søknadsalternativ | tilstandsovergang | `Svc:554-602` | testes i fase 2 |
| `@OPT-BEH-BEH-011` | Et unntak for utdanningsbakgrunn kan fordele til en organisasjon som ikke deltar i opptaket (sektoren og «på vegne av» må delta) | validering | `RegMut:191-201`, `Regl/components/BehandlertildelingsregelUnntak.tsx:78` | uklart om ønsket |

## Åpne spørsmål

| Feature-ID | Egenskap | Regler | Scenarioer | Utenfor gating (`@draft`) |
| --- | --- | --- | --- | --- |
| `@OPT-BEH-BEH-011` | Tildele saksbehandlende organisasjon | 1 av 12 | 4 av 57 | 1 |
| `@FLY-OPT-SAK-001` | Saksbehandlertildeling | 3 av 5 | 6 av 7 | 0 |

## Åpne MR-er og brancher

Koden i disse er ikke merget, og regnes ikke som levert.

| Repo | MR / branch | Status | Krav den ser ut til å levere | Funnet der | Merknad |
| --- | --- | --- | --- | --- | --- |
| `min-kompetanse` | [!994 Draft: feat(soknad): vis saksbehandlende organisasjon i kontakt seksjon](https://gitlab.sikt.no/fs/min-kompetanse/-/merge_requests/994) (`stek-664-vis-saksbehandlende-organisasjon`) | utkast | `@OPT-BEH-BEH-011` | 1/1 | Scenario: Søkeren ser saksbehandlende organisasjon, men ikke sakene |
| `fs-admin` | [!3066 feat(opptak): SHI-696 sett hovedregel for behandlertildeling og vis den på utdanningstilbud](https://gitlab.sikt.no/studieadm/fs-admin/-/merge_requests/3066) (`tuva/SHI-696-hovedregel-behandlertildeling`) | åpen | `@OPT-BEH-BEH-011` | 0/3 | bak main (235 commits). Standardregelen er allerede på main (STEK-578) |
| `fs-admin` | `STEK-576-tilbyder-ser-saken`, `STEK-579-paa-vegne-av-regel`, `hakon/STEK-579-fix-laerested-unntak-uten-deltakere`, `hakon/STEK-652-653-behandlertildelingsregler` | branch uten MR | `@OPT-BEH-BEH-011` | 0/3 | innholdet ser ut til å være på main |
| `fs-plattform` | `stek-576-tilbyderen-ser-saksbehandlingen-av-utda` | branch uten MR | `@OPT-BEH-BEH-011` | 0/3 | merget til main (b7fb33039d) |
