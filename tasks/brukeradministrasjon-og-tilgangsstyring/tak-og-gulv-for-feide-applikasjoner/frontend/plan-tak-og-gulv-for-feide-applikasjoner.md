# Plan: Tak og gulv for Feide-applikasjoner (fs-admin)

- **Krav:** `@BRU-APP-API-018` (taket), `@BRU-APP-API-019` (gulvet). Jira: [BAT-411](https://sikt.atlassian.net/browse/BAT-411). Krav-PR: sikt-no/fs#914.
- **Bygger på:** [`analysis-tak-og-gulv-for-feide-applikasjoner.md`](./analysis-tak-og-gulv-for-feide-applikasjoner.md) (fs-admin), backend-planen [`../backend/plan-tak-og-gulv-for-feide-applikasjoner.md`](../backend/plan-tak-og-gulv-for-feide-applikasjoner.md) («Kontrakt for fs-admin»).
- **Kodegrunnlag:** fs-admin `origin/main` `7905c4fa2`. Publisert SDL `production/experimental` hentet på nytt 2026-11-06. fs-plattform `origin/main` `f9251773b1`.
- **To faser:**
  - **Fase 1 (kan bygges nå):** fanen «Grunntilgang» (gulvet) og fanen «Delegeringstak» (taket) med direkte rader. Lister, tildel- og fjern-dialoger, delvis suksess og gating. Task #1–#10.
  - **Fase 2 (blokkert av T5, !6576):** samlingstak i fanen «Delegeringstak». Task #11. Kontrakten er ikke avgjort, så tasken beskriver avhengigheten og vilkårene, ikke feltnavn.

## Rettelser til analysen (SDL hentet 2026-11-06)

Analysen er utdatert på to punkter. Planen bygger på SDL-en:

1. **Taket har `BrukerdelegeringErPlanlagt` (BAT-415).** Feilunionene i produksjon er:
   - `LeggTilBrukerdelegeringerError = BrukerdelegeringApplikasjonFinnesIkke | BrukerdelegeringErPlanlagt | BrukerdelegeringTilgangskodeFinnesIkke | ManglerDelegeringsforvaltning`
   - `FjernBrukerdelegeringerError = BrukerdelegeringApplikasjonFinnesIkke | BrukerdelegeringErPlanlagt | ManglerDelegeringsforvaltning`
   - `LeggTilBrukergrunntilgangerError = BrukergrunntilgangApplikasjonFinnesIkke | BrukergrunntilgangErPlanlagt | BrukergrunntilgangTilgangskodeFinnesIkke | ManglerGrunntilgangsforvaltning | SyntetiskApplikasjonIEktMiljo`
   - `FjernBrukergrunntilgangerError = BrukergrunntilgangApplikasjonFinnesIkke | BrukergrunntilgangErPlanlagt | ManglerGrunntilgangsforvaltning`
2. **Feltene har ingen `orderBy`-argument i produksjon.** `brukerdelegeringer` og `brukergrunntilganger` tar bare `after`, `filter` og `first` (standard 10). Listene får derfor ingen sorteringsvelger i fase 1.

Andre funn fra verifiseringen som planen bruker:

- `BRUKERADMIN_WSBRUKER_SKRIV` ligger i navnerommet `tilgangsstyring` (subgraf), ikke i `fs-admin` (fs-plattform `0040-forretnings-og-ui-roller.sql:141-142`). Frontendrollen `APPLIKASJONSADMINISTRASJON_SKRIV` i `fs-admin` impliserer det (0040:165). Gatingen bruker frontendrollen (A4).
- `useTilgangerFilter(navneromKode)` løser opp navnerom-id-en (standard `fs-admin`), men bare miljøet fs-admin kjører mot (`src/common/lib/auth/hooks/useTilgangerFilter.ts:59-61`).
- `useWithRole` matcher rolle og organisasjon på samme rad i `tilganger` (`src/features/WithRole/useWithRole.ts`), men bare for det ene miljøet i `GlobalUserProvider`.
- `useForretningRollerTilganger` (DebugFrame) er et ferdig eksempel på en egen `mineTilganger`-spørring utenfor provideren, med vakt på `hasNextPage` (`src/features/DebugFrame/components/RollerDebugSection/useForretningRollerTilganger.ts`).
- `FeideApplikasjon.miljoer` er «miljøene applikasjonen har minst én aktiv tilgang i», ikke miljøene den er registrert i. Det har betydning for spørsmål A5.
- `Brukerdelegering` har sporingsfeltene `delegertAvFeideBruker`/`delegertAvApplikasjon`/`trukketTilbakeAv…`. `Brukergrunntilgang` har `lagtTilAvBruker`/`fjernetAvBruker: Personbruker`.

## Avklarte valg

Hvert punkt var et åpent spørsmål fra analysen. Kjetil avklarte dem 06.11.2026. Ved hvert punkt står hvilke tasker som berøres.

### A1. Fanenavn og plassering

**Avklart (Kjetil, 06.11.2026):** fanene heter **«Delegeringstak»** (`id="delegeringstak"`) og **«Grunntilgang»** (`id="grunntilgang"`). De står etter «Tilganger», så rekkefølgen er Detaljer, Tilganger, Delegeringstak, Grunntilgang. Dyplenkene er `?tab=delegeringstak` og `?tab=grunntilgang`. Meldingsnøklene er `ApplikasjonDetails.delegeringstakTab` og `ApplikasjonDetails.grunntilgangTab`. Ikoner fra Phosphor (forslag: `ArrowLineUpIcon` og `ArrowLineDownIcon`).

- I UI-tekst brukes fanenavnene. «Tak» og «gulv» står fortsatt som domenebegreper i prosa og i kodenavn (`ApplikasjonTak`, `ApplikasjonGulv`, `useTakOgGulvForvaltning`), fordi grafen og kravene bruker dem.
- Berører: Task #2, #5, #8, #10, #11.

### A2. Hvordan kilden for samlingstak vises (fase 2)

**Avklart (Kjetil, 06.11.2026):** som en tag i rollecellen, samme mønster som `SamlingTag` i Tilganger-fanen («Via samling …»). Direkte rader får ingen tag.

- Berører: bare Task #11.

### A3. Advarsel i dialogen for grunntilgang

**Avklart (Kjetil, 06.11.2026):** ja. Tildel-dialogen for gulvet viser et `Alert` (`variant="warning"`) øverst: en rolle i gulvet gis til alle brukere av applikasjonen i organisasjonen og miljøet, også brukere uten egne roller. Mutasjonsbeskrivelsen og typebeskrivelsen for `Brukergrunntilgang` sier det samme.

- Berører: Task #6.

### A4. Kilde for gating per miljø

**Avklart (Kjetil, 06.11.2026):** analysens alternativ (a). Gatingen bruker frontendrollen **`APPLIKASJONSADMINISTRASJON_SKRIV` i navnerommet `fs-admin`**, ikke privilegiet `BRUKERADMIN_WSBRUKER_SKRIV` i `tilgangsstyring`. Klienten henter `mineTilganger(filter: { miljo, navnerom: <id for "fs-admin"> })` for hvert miljø i `mineSynligeMiljoer`, og sjekker at rollen står på samme rad som eierorganisasjonen og som radens organisasjon.

- Rollekoden kommer fra `frontendrolle.APPLIKASJONSADMINISTRASJON_SKRIV` (`src/common/types/generated/tilgangsroller.ts`). Navnerom-id-en for `fs-admin` kommer fra `useTilgangerFilter()` (standard `FS_ADMIN_NAVNEROM_KODE`). Det trengs ikke noe eget navneromsoppslag.
- Avveiningen: rollen *impliserer* privilegiet backend sjekker (0040:165), den er ikke privilegiet selv. I dag er den eneste kilden til privilegiet, så svarene er like. Får privilegiet senere flere kilder, kan UI-et skjule handlinger som serveren ville godtatt. Kjetil har valgt dette bevisst, fordi det følger fs-admins vokabular for gating (`useWithRole`). Se Risk Assessment.
- Berører: Task #3.

### A5. Hvilke miljøer valglisten for miljø tilbyr

**Avklart (Kjetil, 06.11.2026):** alle miljøer der `APPLIKASJONSADMINISTRASJON_SKRIV` (A4) gjelder både for eierorganisasjonen og for valgt organisasjon. Valglisten snevres ikke inn til `FeideApplikasjon.miljoer`. Det feltet er miljøene applikasjonen har *en aktiv tilgang* i, så en ny applikasjon uten tilganger ville ikke kunne få tak eller gulv i noe miljø.

- Berører: Task #3.

### A6. Vise aktør (hvem som la til)

**Avklart (Kjetil, 06.11.2026):** nei i fase 1. Kravene ber om Rolle, Organisasjon, Miljø og Gyldighetstidsrom. Spørringene selekterer derfor ikke `delegertAv*`, `trukketTilbakeAv*`, `lagtTilAvBruker` eller `fjernetAvBruker`.

- Skal aktør vises senere, gjelder BAT-416 (navnet, ellers Feide-id-en til første koblede Feide-bruker, ellers «–»). Det bør bli en egen oppfølgingstask etter BAT-416 steg 2.
- Berører: Task #5, #8.

### A7. Hvor den delte alias-batchen ligger

**Avklart (Kjetil, 06.11.2026):** `batchTildeling.ts` flyttes til `src/domains/tilgangsstyring/utils/aliasBatch/aliasBatch.ts`, og settet med feil som gjelder hele kallet blir et argument til `utledFellesFeil`. Personbruker-hookene sender dagens sett. Verktøyet er alt delt i praksis (`NETTVERKSFEIL` er typet med en import fra `ApplikasjonerOverview`), og tre features vil bruke det.

- Berører: Task #1.

## Proposed Solution

### Architecture Approach

Tak og gulv er to nesten like faner på `ApplikasjonDetails`. Hver fane følger Tilganger-fanens oppbygning, men med personbrukerrollenes delvise suksess:

```
ApplikasjonDetails
├─ DetailPageTabbedContent (herdet: tåler vilkårsfaner og dyplenke)
│  ├─ Detaljer
│  ├─ Tilganger
│  ├─ Delegeringstak (bare FeideApplikasjon)  → ApplikasjonTak
│  └─ Grunntilgang   (bare FeideApplikasjon)  → ApplikasjonGulv
│
ApplikasjonTak / ApplikasjonGulv
├─ <X>ResultList     ActionList, erAktivNaa: true, paginert, ingen orderBy
└─ <X>Actions        ListActions (scope 'list'), eier FSModal-skallet
   ├─ Tildel<X>Action   org → miljø → roller (multi), alias-batch, delvis suksess
   └─ Fjern<X>Action    org → miljø → rader, alias-batch, delvis suksess
│
Felles for begge (ApplikasjonDetails/components/TakOgGulvFelles/)
├─ hooks/useTakOgGulvForvaltning   gating per miljø (mineTilganger × miljøer)
├─ hooks/useForretningsroller      tilgangsroller(filter: { navnerom: [fs] })
├─ components/AliasBatchUtfall     utfall per rad (vellykket/feilet + melding)
└─ utils/formatGyldighetstidsrom   flyttet ut av PersonbrukerRollerResultList
```

Dataflyt for en tildeling:

1. `useTakOgGulvForvaltning(eierOrganisasjonId)` gir organisasjonene og miljøene der brukeren kan forvalte (A4, A5).
2. Brukeren velger organisasjon og miljø. Dialogen henter listen (`erAktivNaa: true`, filter på organisasjon og miljø) for å avgjøre «allerede i taket/gulvet», og forretningsrollene.
3. Valgte roller sendes som alias-batch, ett alias per rolle (`byggAliasBatch`). Hvert alias er alt eller ingenting.
4. Gikk alt gjennom: modalen lukkes og en snackbar vises. Ellers holdes modalen åpen med utfallet per rad, eller én samlet feil når hele kallet feilet av samme grunn (`utledFellesFeil`).
5. Listene hentes på nytt med `refetchQueryNames(...)` og `awaitRefetchQueries`.

Gating er et UI-hint. Serveren håndhever med RLS (`kan_forvalte_delegering`). Lesing gates ikke: alle som ser applikasjonen ser fanene.

### Key Technical Decisions

1. **Decision: Gating per miljø på frontendrollen `APPLIKASJONSADMINISTRASJON_SKRIV` i navnerommet `fs-admin` (A4), i en egen hook som utvider `useWithRole`-logikken til flere miljøer.**
   - Why:
     - Kjetil har valgt fs-admins eget gating-vokabular (A4). Det er samme rolle som skrivehandlingene på detaljsiden gates på i dag (`useWithRole` med `organisasjonskode`).
     - `useWithRole`/`useTilganger` dekker bare miljøet fs-admin kjører mot. Kravene trenger svar per (miljø, organisasjon), for to organisasjoner (eier og radens).
     - Det finnes ingen serverkilde (backend beslutning 3).
     - `mineTildelingsorganisasjoner`/`mineTildelingsmiljoer`/`tildelbareTilgangskoder` sjekker `BRUKERADMIN_TILDELING_SKRIV` og gir feil svar her. **De skal ikke brukes** (analysens funn 3). Det samme gjelder rollen `APPLIKASJONSADMINISTRASJON_TILDELING`, som Tilganger-fanen gater på.
   - Implementasjon:
     - Navnerom-id-en for `fs-admin` kommer fra `useTilgangerFilter()`. Rollekoden er `frontendrolle.APPLIKASJONSADMINISTRASJON_SKRIV`.
     - Hooken henter `mineSynligeMiljoer`, og deretter `mineTilganger(filter: { miljo, navnerom })` per miljø med `useApolloClient().query` i `Promise.all` (antall miljøer er dynamisk, i dag fire, så hooks i løkke er ikke mulig). Hver side hentes til `hasNextPage === false`.
     - Regelen «rolle og organisasjon på samme rad» trekkes ut av `useWithRole` som en ren funksjon, så `useWithRole` og den nye hooken bruker den samme.
   - Alternative considered:
     - Privilegiet `BRUKERADMIN_WSBRUKER_SKRIV` i `tilgangsstyring` (analysens b). Valgt bort av Kjetil, se A4.
     - Utvide `GlobalUserProvider` til flere miljøer. Forkastet: provideren er autorisasjonskjeden for hele fs-admin, og flere miljøer der ville gjort hver sidelasting dyrere for én fane.

2. **Decision: Herd `DetailPageTabbedContent` i stedet for å utsette hele fanelisten.**
   - Komponenten har tre problemer med vilkårsfaner:
     - (a) `.props.id` leses på hvert barn, så et `false`-barn krasjer.
     - (b) Effekten i `:63-67` setter `?tab=` tilbake til første fane når fanen ikke finnes. Mens detaljspørringen laster, finnes ikke `delegeringstak`/`grunntilgang`, så en dyplenke går tapt.
     - (c) `Tabs` er ukontrollert (`defaultIndex`), så valgt indeks oppdateres ikke når fanene dukker opp.
   - Løsning:
     - Barn filtreres med `Children.toArray(children).filter(isValidElement)` (løser a).
     - Ny valgfri prop `pending?: boolean`. Når den er `true`, kjører ikke tilbakestillingen (løser b).
     - `Tabs` får `key` av fane-id-ene (`ids.join('|')`), så den monteres på nytt med riktig `defaultIndex` når fanesettet endrer seg (løser c).
     - Typen på `children` utvides til å tillate `false | null | undefined`.
   - `ApplikasjonDetails` sender `pending={loading}` og legger fanene inn med `{erFeide && <DetailPageTabbedContentPanel …/>}`.
   - Why: Detaljer-fanen viser skjelett mens den laster i dag. Å utsette hele fanelisten til typen er kjent ville endret den oppførselen. Herdingen er generell og nyttig for andre detaljsider.
   - Alternative considered: render `DetailPageTabbedContent` først når `applikasjon` er lastet. Enklere, men fjerner dagens lasteskjelett og løser ikke (a) for andre brukere av komponenten.

3. **Decision: Én felles mappe for det tak og gulv deler, men egne komponenter og spørringer per fane.**
   - Why: CLAUDE.md sier at spørringer ligger ved komponenten og ikke deles. Mutasjonene, feiltypene og tekstene er ulike. Det som er likt, er gating, rollekatalogen, utfallsvisningen og datoformatet. Det er hooks og presentasjon, ikke spørringer mot listene.
   - Alternative considered: én generisk `TakEllerGulv`-komponent med `variant`. Forkastet: grenene i feilmapping, tekster og (i fase 2) samlingsrader gjør en variant-prop mer forvirrende enn to små kopier.

4. **Decision: Valglisten for rolle er `tilgangsroller(filter: { navnerom: [<id for "fs">] })`, filtrert bort `utgattTidspunkt` i fortiden.**
   - Why: ingen eksisterende kilde sjekker riktig rett (analysens funn 4). Navnerommet `fs` er forretningsnavnerommet (`FS_NAVNEROM_KODE`). Serveren avgrenser ikke, så filteret er klientens (backend beslutning 1).
   - Følge: listen og fjern-dialogen viser og kan fjerne rader med koder som ikke er forretningsroller (fra migreringen i 0099). Bare tildel-valglisten filtreres.
   - Alternative considered: `mineTildelbareTilgangsroller(navneromstyper: [FORRETNING])`. Forkastet: den sjekker `BRUKERADMIN_PERSON_TILDELING_SKRIV`.

5. **Decision: Delvis suksess med alias-batch, og `…ErPlanlagt` er en feil per rad.**
   - Settet med feil som gjelder hele kallet:
     - tak: `ManglerDelegeringsforvaltning`, `BrukerdelegeringApplikasjonFinnesIkke`, `NetworkError`
     - gulv: `ManglerGrunntilgangsforvaltning`, `BrukergrunntilgangApplikasjonFinnesIkke`, `SyntetiskApplikasjonIEktMiljo`, `NetworkError`
   - Feil per rad: `…ErPlanlagt` (meldingen fra serveren sier datoen, og vises som den er), `…TilgangskodeFinnesIkke`.
   - Why: `ErPlanlagt` gjelder én kombinasjon og én rolle. De andre treffer hvert alias likt (organisasjon/miljø/applikasjon).

6. **Decision: Ingen `orderBy`, ingen filter-sidebar i fase 1.**
   - Why: feltene har ikke `orderBy` i produksjon. Kravene ber ikke om filtrering, og listen er «bare det som gjelder nå». Standard `first: 10` med `ActionList`-paginering.
   - Alternative considered: filter på organisasjon og miljø som i Tilganger-fanen. Kan legges til senere uten kontraktendring (`filter.organisasjoner`/`miljoer` finnes).

7. **Decision: Ingen sporingsfelt i fase 1** (A6).

8. **Decision: Ikke `__typename` i spørringer, med ett unntak.** Feilunionene i mutasjonene må skilles på `__typename` (`errors { __typename … on Error { message } }`). Det er det etablerte mønsteret i `useTildelPersonbrukerTilganger`, og ikke et brudd på CLAUDE.md-regelen, som gjelder lesespørringer.

### File Changes Overview

Ingen schema-endringer i fase 1: alt som trengs, finnes i publisert `production/experimental`-SDL. `## GraphQL-endringer` er derfor utelatt, og `bat-graphql-dev` er ikke kjørt. Spørringsskisser står i taskene.

Endres:

- `src/common/components/layouts/DetailPageLayout/components/DetailPageTabbedContent/DetailPageTabbedContent.tsx` (+ test): herding (beslutning 2).
- `src/domains/tilgangsstyring/features/ApplikasjonDetails/ApplikasjonDetails.tsx` (+ a11y-test): vilkårsfanene «Delegeringstak» og «Grunntilgang», `pending`.
- `src/features/WithRole/useWithRole.ts`: regelen «rolle og organisasjon på samme rad» trekkes ut som en ren funksjon (f.eks. `src/features/WithRole/harRolleIOrganisasjon.ts`, + test), uten atferdsendring (beslutning 1).
- `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/hooks/batchTildeling.ts` og `batchTildeling.test.ts`: flyttes (A7). Importene i `useTildel/FjernPersonbrukerTilganger`, `useTildel/FjernFeideBrukerTilganger` og testene for `TildelRolleAction`/`FjernRolleAction` oppdateres.
- `src/domains/tilgangsstyring/features/PersonbrukerDetails/components/PersonbrukerRoller/components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx`: bruker den flyttede `formatGyldighetstidsrom`.
- `src/common/lib/apollo/cacheConfig.ts`: `FeideApplikasjon.brukerdelegeringer` og `brukergrunntilganger`.
- `src/common/messages/nb/tilgangsstyring.json`: nye nøkler under `ApplikasjonDetails` (`delegeringstakTab`, `grunntilgangTab`), `ApplikasjonTak.*` og `ApplikasjonGulv.*` (bare nb).
- `src/mocks/applikasjoner/{fixtures,handlers,schema,store}`: tak, gulv og de fire mutasjonene.

Nye filer (under `src/domains/tilgangsstyring/`):

- `utils/aliasBatch/aliasBatch.ts`, `aliasBatch.test.ts`
- `utils/gyldighetstidsrom/formatGyldighetstidsrom.ts`, `.test.ts`
- `features/ApplikasjonDetails/components/TakOgGulvFelles/`
  - `hooks/useTakOgGulvForvaltning.tsx`, `.test.tsx`
  - `hooks/useForretningsroller.tsx`, `.test.tsx`
  - `components/AliasBatchUtfall/AliasBatchUtfall.tsx`, `.test.tsx`, `.a11y.test.tsx`
- `features/ApplikasjonDetails/components/ApplikasjonGulv/`
  - `ApplikasjonGulv.tsx`, `.a11y.test.tsx`
  - `components/ApplikasjonGulvResultList/` (+ test)
  - `components/ApplikasjonGulvActions/` (+ test, a11y)
  - `components/ApplikasjonGulvActions/actions/TildelGulvAction/` (+ test, a11y, css)
  - `components/ApplikasjonGulvActions/actions/FjernGulvAction/` (+ test, a11y, css)
  - `hooks/useGetApplikasjonGulv.tsx`, `useLeggTilBrukergrunntilganger.tsx`, `useFjernBrukergrunntilganger.tsx` (+ tester)
- `features/ApplikasjonDetails/components/ApplikasjonTak/`: samme struktur, med `Tak` i navnene og `useGetApplikasjonTak`, `useLeggTilBrukerdelegeringer`, `useFjernBrukerdelegeringer`.
- `.changeset/<navn>.md`

## Implementation Tasks

Rekkefølge: felles grunnmur (#1–#4), gulvet (#5–#7), taket (#8–#9), avslutning (#10), fase 2 (#11). #1, #2, #3 og #4 er uavhengige av hverandre og kan gjøres parallelt.

### Task #1: Flytt alias-batchen og gjør feilsettet til et argument

**Priority**: High
**Size**: S
**Dependencies**: None
**Addresses Requirements**: delvis suksess (018, 019), forutsetning

**Acceptance Criteria**:

- [ ] `batchTildeling.ts` og testen ligger i `src/domains/tilgangsstyring/utils/aliasBatch/` som `aliasBatch.ts`/`aliasBatch.test.ts` (A7).
- [ ] `utledFellesFeil(elementer, samledeFeil: ReadonlySet<string>)`. Det gamle `SAMLEDE_FEIL` eksporteres som `PERSONBRUKER_SAMLEDE_FEIL` og sendes av de fire personbruker-hookene.
- [ ] Alle importer er oppdatert. Ingen atferdsendring: eksisterende tester for `TildelRolleAction`/`FjernRolleAction` og alias-batchen går uendret.
- [ ] Ny test: `utledFellesFeil` med et annet sett gir samlet feil bare når alle feilene er i settet.
- [ ] `npm run lint`, `tsc` og jest grønt.

**Implementation Notes**:
Ren refaktorering, eget commit. JSDoc-en i filen forklarer hvorfor alias og ikke liste-input. Den skal følge med uendret. Typen `OpprettApplikasjonFeil` kan stå. Det er nok å nevne i JSDoc at den brukes som generell feiltype.

### Task #2: Herd `DetailPageTabbedContent` for vilkårsfaner og dyplenke

**Priority**: High
**Size**: M
**Dependencies**: None
**Addresses Requirements**: «Fanen vises bare for Feide-applikasjoner» (018, 019)

**Acceptance Criteria**:

- [ ] `children` tillater `false | null | undefined` i tillegg til panelene. Barna filtreres med `Children.toArray(...).filter(isValidElement)` før `.props.id` leses.
- [ ] Ny valgfri prop `pending?: boolean`. Når `true`, setter ikke effekten `?tab=` tilbake.
- [ ] `Tabs` får `key` av fane-id-ene, så valgt fane følger `?tab=` når fanesettet endrer seg.
- [ ] Tester: (1) `false`-barn krasjer ikke og gir ingen fane, (2) `?tab=grunntilgang` med `pending` og uten den fanen beholdes i URL-en, (3) når fanen dukker opp og `pending` blir `false`, er den valgt, (4) ukjent `?tab=` uten `pending` settes til første fane som før.
- [ ] Eksisterende brukere av komponenten er uendret (ingen ny prop påkrevd).

**Implementation Notes**:
Sjekk andre detaljsider som bruker komponenten (`git grep DetailPageTabbedContent`), og kjør testene deres. Se `fs-admin-detail-pages`-skillen. Ikke legg fanene inn i `ApplikasjonDetails` i denne tasken. Det skjer i #5 og #8, så ingen tom fane kommer på `main`.

### Task #3: Gating per miljø, `useTakOgGulvForvaltning`

**Priority**: High
**Size**: L
**Dependencies**: None
**Addresses Requirements**: «Forvaltning krever applikasjonsadministrator-rollen for eier og radens organisasjon i samme miljø», «Valglisten for organisasjon er begrenset», «Valglisten for miljø avhenger av valgt organisasjon», «Forvaltning ikke tilgjengelig uten rollen for eieren», «Fjerning begrenset til organisasjoner jeg administrerer» (018, 019)

**Acceptance Criteria**:

- [ ] Hooken tar eierorganisasjonen og returnerer:
  - `kanForvalte(organisasjonskode, miljoId): boolean`: `APPLIKASJONSADMINISTRASJON_SKRIV` finnes for både (miljø, eier) og (miljø, organisasjon)
  - `harNoenForvaltning: boolean`: rollen finnes for eieren i minst ett miljø (styrer om menyen vises)
  - `organisasjoner`: organisasjonene med rollen i minst ett miljø der eieren også har den
  - `miljoerFor(organisasjonskode)`: miljøene der rollen gjelder både for eier og organisasjon (A5)
  - `loading`, `error`
- [ ] Rollekoden er `frontendrolle.APPLIKASJONSADMINISTRASJON_SKRIV` fra `src/common/types/generated/tilgangsroller.ts`, ikke en streng (A4).
- [ ] Navnerom-id-en er `navneromId` fra `useTilgangerFilter()` (standard `fs-admin`). Ingen egen oppslagsoperasjon for navnerom, og ingen `TILGANGSSTYRING_NAVNEROM_KODE`.
- [ ] Miljøene kommer fra `mineSynligeMiljoer { id kode navn }` i en egen operasjon ved hooken.
- [ ] `mineTilganger(filter: { miljo, navnerom }, first: MINE_TILGANGER_FIRST)` hentes for hvert miljø, og hver side følges til `pageInfo.hasNextPage === false`. Ingen stille trunkering.
- [ ] Regelen «rolle og organisasjon på samme rad» er trukket ut av `useWithRole` som en ren funksjon (f.eks. `harRolleIOrganisasjon(tilganger, rolle, organisasjonskode)`) og brukes av begge. `useWithRole` oppfører seg som før, og testene for den går uendret.
- [ ] Ved feil eller manglende navnerom/miljø: `kanForvalte` gir `false` (lukket), og `error` er satt.
- [ ] Hooken bruker **ikke** `useGetMineTildelingsorganisasjoner`, `useGetMineTildelingsmiljoer`, `useTildelbareTilgangskoder` eller rollen `APPLIKASJONSADMINISTRASJON_TILDELING`. De gjelder `BRUKERADMIN_TILDELING_SKRIV`, som er en annen rett. Testen dokumenterer hvorfor i en kommentar.
- [ ] Tester med mockede svar: to miljøer, eier med rollen bare i det ene, organisasjon med rollen i begge, gir ett miljø. Uten rollen for eieren gir `harNoenForvaltning: false`. Paginering med to sider.

**Implementation Notes**:
`useGetApplikasjon` selekterer allerede `organisasjon { id organisasjonskode … }` for alle tre typene, så eierorganisasjonen finnes på detaljnoden. Matchingen bruker `organisasjonskode`, som `useWithRole`. Radene i tak og gulv selekterer `organisasjonskode` (#5, #8).

Bruk `useApolloClient().query` i `Promise.all` per miljø, med `fetchPolicy: 'cache-first'` (rettighetene er beregnet av databasen, og en ny sidevisning er godt nok som oppfriskning). Mønster for en egen `mineTilganger`-spørring utenfor provideren, med `hasNextPage`-vakt: `useForretningRollerTilganger`. Miljøet fs-admin kjører mot kan også leses fra `useTilganger()`, men det er enklere og mer forutsigbart å hente alle miljøene på samme måte.

Hooken kalles én gang per fane og sendes ned som props, så dialogene ikke henter på nytt.

### Task #4: Cache-policy, felles verktøy og mock-API for tak og gulv

**Priority**: High
**Size**: M
**Dependencies**: None
**Addresses Requirements**: forutsetning for #5–#9

**Acceptance Criteria**:

- [ ] `cacheConfig.ts` har `FeideApplikasjon: { fields: { brukerdelegeringer: nodesCursorPagination(['filter']), brukergrunntilganger: nodesCursorPagination(['filter']) } }`, med kommentar i samme stil som `Applikasjon.tilganger`. Verifiser at policyen slår sammen med `Applikasjon`-policyen via `possibleTypes` (test eller manuell sjekk i Apollo DevTools).
- [ ] `formatGyldighetstidsrom` er flyttet til `utils/gyldighetstidsrom/` med tester for de fire tilfellene («01.05.2026 –», «– 01.08.2026», «01.05.2026 – 01.08.2026», `ingenVerdi`). `PersonbrukerRollerResultList` bruker den. Typen tar `{ fraTidspunkt?, tilTidspunkt? }`, så den passer både `BrukerdelegeringGyldighetsperiode` og `BrukergrunntilgangGyldighetsperiode`.
- [ ] `useForretningsroller()` henter `tilgangsroller(filter: { navnerom: [<id for "fs">] })` med `id kode beskrivelse utgattTidspunkt`, og filtrerer bort utgåtte. Navnerom-id-en slås opp på kode.
- [ ] `AliasBatchUtfall` viser utfallet per rad (rolle, vellykket/feilet, melding) i `FSModalFeedback`, med a11y-test. Lages ut fra visningen i `TildelRolleAction`, ikke en kopi av hele modalen.
- [ ] Mock-API (`fs-admin-mock-api-with-data`): fixtures for tak og gulv på minst én Feide-applikasjon, resolvere for begge listefeltene med `erAktivNaa`/`organisasjoner`/`miljoer`, og de fire mutasjonene. Mocken kan gi `…ErPlanlagt` for en bestemt rolle og `Mangler…forvaltning` for en bestemt organisasjon, så delvis suksess og samlet feil kan testes og vises lokalt.

**Implementation Notes**:
Les `src/mocks/applikasjoner/teardown-applikasjoner.md` før du endrer mocken. Hvis mock-skjemaet er generert fra SDL-en, holder det å legge til resolvere.

### Task #5: Fanen «Grunntilgang» (gulvet) med liste

**Priority**: High
**Size**: M
**Dependencies**: Task #2, Task #4
**Addresses Requirements**: «Fanen for gulvet vises bare for Feide-applikasjoner», «Alle som kan se applikasjonen, ser fanen», «Listen viser Rolle, Organisasjon, Miljø, Gyldighetstidsrom, og bare det som gjelder nå» (019)

**Acceptance Criteria**:

- [ ] `ApplikasjonDetails` viser «Grunntilgang» (`id="grunntilgang"`) som siste fane, etter «Delegeringstak» når den finnes, bare når `applikasjon.identitetsleverandor === FEIDE`, og sender `pending={loading}` (A1). Dyplenke `?tab=grunntilgang` åpner fanen etter lasting.
- [ ] `useGetApplikasjonGulv` henter med `Feature-Flags: experimental` (som `useGetApplikasjon`):
  ```graphql
  query applikasjonGulv($id: ID!, $first: Int, $after: String, $filter: BrukergrunntilgangerFilterInput) {
    node(id: $id) {
      ... on FeideApplikasjon {
        id
        brukergrunntilganger(first: $first, after: $after, filter: $filter) {
          totalCount
          nodes {
            tilgangsrolle { id kode beskrivelse }
            organisasjon { id organisasjonskode forkortelse navnAlleSprak { nb } }
            miljo { id kode navn }
            gyldighetsperiode { fraTidspunkt tilTidspunkt }
          }
          pageInfo { hasNextPage endCursor }
        }
      }
    }
  }
  ```
  med `filter: { erAktivNaa: true }`. Feltnavn på `Organisasjon` og `Miljo` verifiseres mot generert type.
- [ ] `ApplikasjonGulvResultList` bruker `ActionList` med paginering, kolonnene Rolle, Organisasjon, Miljø (som `TagStatus`, som Tilganger-fanen) og Gyldighetstidsrom (`formatGyldighetstidsrom`). Tom liste, lasting og feil har egne tekster.
- [ ] Radnøkkel: `${tilgangsrolle.id}|${organisasjon.id}|${miljo.id}` (ingen node-id).
- [ ] Rader med koder som ikke er forretningsroller vises som andre rader.
- [ ] Ingen gating på visning.
- [ ] Tester: listen rendres med data, tom tilstand, fanen «Grunntilgang» vises ikke for Maskinporten/maskinbruker, dyplenke `?tab=grunntilgang`. `.a11y.test.tsx` for `ApplikasjonGulv`.
- [ ] Tekster i `tilgangsstyring.json` (bare nb): `ApplikasjonDetails.grunntilgangTab` («Grunntilgang»), `ApplikasjonGulv.*`.

**Implementation Notes**:
Følg `fs-admin-list-results`. `ActionList`-resultatlister er unntatt kravet om egen a11y-test, men fanen er det ikke. Plasser `actionsElement` nå (tom til #6), eller legg den til i #6.

### Task #6: Tildel i gulvet

**Priority**: High
**Size**: L
**Dependencies**: Task #1, Task #3, Task #4, Task #5
**Addresses Requirements**: «Tildele én eller flere roller for én organisasjon og ett miljø», «Delvis suksess», «En rolle som allerede er i gulvet kan ikke velges», «Bare forretningsroller i valglisten», gating (019)

**Acceptance Criteria**:

- [ ] `ApplikasjonGulvActions` er én `ListActions`-meny (`scope: 'list'`) som eier `FSModal`-skallet, som `ApplikasjonTilgangerActions`. Menyen vises bare når `harNoenForvaltning` er `true`.
- [ ] `TildelGulvAction`: kaskade av `FSCombobox` organisasjon → miljø → roller (multi-select).
  - Organisasjoner fra `useTakOgGulvForvaltning.organisasjoner`.
  - Miljøer fra `miljoerFor(valgtOrganisasjon)`. Bytte organisasjon nullstiller miljø og roller.
  - Roller fra `useForretningsroller`. Roller som allerede er i gulvet for (org, miljø) står som `disabled` med forklaring. «Allerede i gulvet» hentes med `brukergrunntilganger(filter: { erAktivNaa: true, organisasjoner: [org], miljoer: [miljo] }, first: 100)` (egen spørring ved dialogen).
- [ ] Advarsel (A3) øverst i dialogen som `Alert variant="warning"`: alle brukere av applikasjonen får rollen i organisasjonen og miljøet, også brukere uten egne roller.
- [ ] `useLeggTilBrukergrunntilganger` sender én alias per rolle (`byggAliasBatch`, `delIBiter(…, MAKS_ALIAS_PER_KALL)`), input `{ applikasjonId, tilgangskodeId, organisasjonId, miljoId }`, med `errors { __typename … on Error { message } }`.
- [ ] Utfall:
  - alt gikk gjennom: lukk og vis snackbar
  - noe feilet: modalen holdes åpen med `AliasBatchUtfall`
  - alle feilet av en grunn som gjelder hele kallet (gulvsettet i beslutning 5): én `Alert`
- [ ] Feilmapping med egen tekst for `ManglerGrunntilgangsforvaltning`, `BrukergrunntilgangApplikasjonFinnesIkke`, `BrukergrunntilgangTilgangskodeFinnesIkke`, `SyntetiskApplikasjonIEktMiljo`, `BrukergrunntilgangErPlanlagt` (serverens melding, den har datoen) og standard.
- [ ] Tom `feideApplikasjoner` i payload uten feil regnes som suksess, med samme forklaring som `TildelTilgangAction.tsx:71-76` (lesing følger innsyn).
- [ ] `refetchQueryNames(...)` for listespørringen og «allerede i gulvet»-spørringen, `awaitRefetchQueries: true`.
- [ ] Tester: kaskaden, disabled-roller, delvis suksess (én rolle `ErPlanlagt`), samlet feil, alt vellykket. `.a11y.test.tsx` for dialogen og menyen.

**Implementation Notes**:
Bruk `TildelRolleAction` som mønster for delvis suksess (JSDoc `:90-104`), og `TildelTilgangAction` for menyen og kaskaden. Følg `fs-admin-modal` og `fs-admin-inputs`. Ikke importer kaskade-hookene fra Tilganger-fanen.

### Task #7: Fjern fra gulvet

**Priority**: High
**Size**: M
**Dependencies**: Task #6
**Addresses Requirements**: «Fjerne én eller flere roller», «Fjerning begrenset til organisasjoner jeg administrerer», «Delvis suksess» (019)

**Acceptance Criteria**:

- [ ] `FjernGulvAction` i samme meny: organisasjon → miljø → rader i gulvet for kombinasjonen (multi-select).
  - Organisasjoner og miljøer begrenses av `kanForvalte` på samme måte som i #6.
  - Kandidatene er radene som gjelder nå i (org, miljø). Rader med koder som ikke er forretningsroller er med.
- [ ] `useFjernBrukergrunntilganger` som alias-batch, samme utfallsvisning og feilmapping som #6 (fjern-unionen: `ManglerGrunntilgangsforvaltning`, `BrukergrunntilgangApplikasjonFinnesIkke`, `BrukergrunntilgangErPlanlagt`).
- [ ] Ingen advarsel om alle brukere ved fjerning.
- [ ] Refetch som #6.
- [ ] Tester og `.a11y.test.tsx` som #6.

**Implementation Notes**:
Mønster: `FjernRolleAction`. `BrukergrunntilgangErPlanlagt` ved fjerning betyr at innslaget ikke har begynt å gjelde. Raden vises ikke i listen, men kan finnes for samme kombinasjon.

### Task #8: Fanen «Delegeringstak» (taket) med liste (direkte rader)

**Priority**: High
**Size**: M
**Dependencies**: Task #2, Task #4 (og #5 for mønsteret)
**Addresses Requirements**: «Fanen for taket vises bare for Feide-applikasjoner», «Alle som kan se applikasjonen, ser fanen», «Listen viser Rolle, Organisasjon, Miljø, Gyldighetstidsrom, og bare det som gjelder nå» (018, direkte rader)

**Acceptance Criteria**:

- [ ] «Delegeringstak» (`id="delegeringstak"`) mellom «Tilganger» og «Grunntilgang», med samme vilkår som #5. Dyplenke `?tab=delegeringstak` åpner fanen etter lasting (A1).
- [ ] `useGetApplikasjonTak` som #5, men mot `brukerdelegeringer(filter: BrukerdelegeringerFilterInput)` med `erAktivNaa: true`. Ingen `tilknytning`, ingen sporingsfelt (A6).
- [ ] `ApplikasjonTakResultList` med de samme kolonnene og radnøkkelen som #5.
- [ ] Radnøkkelen bygges i én hjelpefunksjon (`takRadNokkel`), så fase 2 kan legge til kilde uten å lete.
- [ ] Tester og `.a11y.test.tsx` som #5, inkludert dyplenke `?tab=delegeringstak` og rekkefølgen Detaljer, Tilganger, Delegeringstak, Grunntilgang. Tekster `ApplikasjonDetails.delegeringstakTab` («Delegeringstak»), `ApplikasjonTak.*`.

**Implementation Notes**:
Kopier fra gulvet. Ikke lag en felles generisk liste (beslutning 3). Fanen viser bare direkte rader til fase 2. Det er ikke nødvendig med en tekst om det.

### Task #9: Tildel i og fjern fra taket (direkte rader)

**Priority**: High
**Size**: L
**Dependencies**: Task #1, Task #3, Task #8 (og #6/#7 for mønsteret)
**Addresses Requirements**: «Tildele og fjerne én eller flere roller», «Delvis suksess», «En rolle som allerede er i taket kan ikke velges» (direkte), «Organisasjonssamling kan ikke velges», gating (018)

**Acceptance Criteria**:

- [ ] `ApplikasjonTakActions` med `TildelTakAction` og `FjernTakAction`, samme oppbygning som #6 og #7, uten gulvets advarsel.
- [ ] Valglisten for organisasjon inneholder bare organisasjoner (fra `useTakOgGulvForvaltning`), aldri samlinger.
- [ ] «Allerede i taket» utledes av `brukerdelegeringer(filter: { erAktivNaa: true, organisasjoner, miljoer })`. Logikken ligger i én funksjon (`rollerAlleredeITaket`), så fase 2 kan ta med samlingsrader.
- [ ] Alias-batch mot `leggTilBrukerdelegeringer`/`fjernBrukerdelegeringer`. Samlet feil for `ManglerDelegeringsforvaltning`, `BrukerdelegeringApplikasjonFinnesIkke`, `NetworkError`. Per rad for `BrukerdelegeringErPlanlagt` og `BrukerdelegeringTilgangskodeFinnesIkke`.
- [ ] Tom `feideApplikasjoner` i payload håndteres som #6. Refetch som #6.
- [ ] Tester (inkludert `BrukerdelegeringErPlanlagt` på én rad) og `.a11y.test.tsx`.

**Implementation Notes**:
Kan deles i to commits (tildel, fjern). Feilsettene står i «Rettelser til analysen».

### Task #10: Changeset, brukerveiledning og sluttsjekk for fase 1

**Priority**: Medium
**Size**: S
**Dependencies**: Task #5–#9
**Addresses Requirements**: NFR (konvensjoner)

**Acceptance Criteria**:

- [ ] Ett changeset etter `fs-admin-changesets` som beskriver de to fanene for brukeren (ikke implementasjonen).
- [ ] Brukerveiledninger sjekket (`fs-admin-brukerveiledninger`). Det finnes ingen for applikasjoner. Notér i MR-en om en bør lages, ikke lag den her.
- [ ] Alle nye komponenter har `.a11y.test.tsx` (unntatt `ActionList`-resultatlister). Komponentene er `function` i PascalCase. Ingen `__typename` i lesespørringer.
- [ ] Bare nb-meldinger. Ingen hardkodede norske strenger i komponentene.
- [ ] Manuell sjekk lokalt mot mock: dyplenke `?tab=delegeringstak` og `?tab=grunntilgang`, Maskinporten-applikasjon uten fanene, delvis suksess, og at handlingsmenyen bare vises med `APPLIKASJONSADMINISTRASJON_SKRIV` for eierorganisasjonen.
- [ ] `npm run lint`, `tsc`, jest og a11y grønt.

**Implementation Notes**:
`pre-merge-check`-skillen kan kjøres før MR.

### Task #11 (fase 2): Samlingstak i fanen «Delegeringstak»

**Priority**: Medium
**Size**: M (anslag, settes når kontrakten er kjent)
**Dependencies**: fs-plattform T5/T6 (!6576) i **produksjons**-SDL. Task #8, Task #9.
**Addresses Requirements**: «Tak for en organisasjonssamling vises per organisasjon», «Listen viser hvor taket kommer fra», «Rolle i taket gjennom en organisasjonssamling regnes som allerede i taket», «Tak fra en organisasjonssamling kan ikke fjernes» (018)

**Blokkert.** Kontrakten redesignes. Den sannsynlige formen er én `Brukerdelegering` med `tilknytning` (DIREKTE/SAMLING) over en Graphitron-`@routine`, men det er ikke avgjort. Branchen `tilgangsstyring/BAT-411-tak-gulv-t6-samlingstak-i-grafen` er en kandidat, ikke kontrakten. Planen designer ikke mot den.

**Må være avklart før tasken størrelsesettes** (fra analysens Cross-contributor):

1. feltnavn og enum for kilden
2. én eller flere samlinger per rad
3. om samme (organisasjon, miljø, rolle) kan stå flere ganger
4. sorteringsnøkkel og paginering
5. om `trukketTilbakeAv*` er null for samlingsrader

**Acceptance Criteria** (som vilkår på kontrakten, ikke feltnavn):

- [ ] Hver rad i taklisten viser kilden: direkte, eller hvilken organisasjonssamling (A2).
- [ ] Samlingsrader vises per medlemsorganisasjon.
- [ ] Samlingsrader kan ikke fjernes: de er ikke kandidater i `FjernTakAction`.
- [ ] `rollerAlleredeITaket` tar med samlingsrader, så en rolle som er i taket gjennom en samling, ikke kan velges i `TildelTakAction`.
- [ ] Radnøkkelen (`takRadNokkel`) tar med kilden, så samme (org, miljø, rolle) fra direkte og fra samling ikke kolliderer.
- [ ] Tester for blandet liste, fjern-kandidater og «allerede i taket».

**Implementation Notes**:
Codegen leser produksjons-SDL, så koden kan ikke på `main` før feltene er i produksjon. Lokalt kan `GRAPHQL_SCHEMA_LOCATION` peke på `test/experimental`. `SamlingTag` tar i dag en *liste* samlinger. Er det én samling per rad, sendes en liste med ett element.

## Risk Assessment

### Technical Risks

- **Risk**: gating gir feil svar fordi noen gjenbruker kaskade-hookene fra Tilganger-fanen (`TILDELING_SKRIV`) eller rollen `APPLIKASJONSADMINISTRASJON_TILDELING`.
  - **Mitigation**: beslutning 1, eksplisitt AC i #3, #6 og #9, og en kommentar i `useTakOgGulvForvaltning`. Serveren håndhever uansett, så risikoen gjelder UI-et.
- **Risk**: gatingen sjekker en implikasjon, ikke privilegiet (A4). `APPLIKASJONSADMINISTRASJON_SKRIV` impliserer `BRUKERADMIN_WSBRUKER_SKRIV` (0040:165), men backend sjekker privilegiet (`kan_forvalte_delegering`). Får privilegiet senere flere kilder, eller endres implikasjonen, svarer UI-et og serveren ulikt. Da skjuler UI-et handlinger serveren ville godtatt, eller viser handlinger serveren avviser med `Mangler…forvaltning`.
  - **Mitigation**: Kjetil har valgt dette bevisst (A4). Rollekoden står ett sted (`frontendrolle.APPLIKASJONSADMINISTRASJON_SKRIV` i hooken), og hooken har en kommentar som peker på 0040:165. En avvisning vises uansett som en forståelig feil i dialogen (#6, #7, #9). Endringer i rollehierarkiet for applikasjonsadministrasjon bør sjekke denne hooken.
- **Risk**: `mineTilganger` per miljø gir flere kall (fire i dag) og et waterfall-hopp (miljøer og navnerom-id først).
  - **Mitigation**: navnerom-id-en kommer fra `useTilgangerFilter()` (`cache-first`, allerede hentet ved oppstart), `Promise.all` for miljøene, `cache-first`, og hooken kalles én gang per fane. Navnerommet `fs-admin` har få roller, så svarene er små.
- **Risk**: trunkerte rettigheter ved mer enn 100 rader per miljø.
  - **Mitigation**: paginering til `hasNextPage === false` (AC i #3).
- **Risk**: herdingen av `DetailPageTabbedContent` endrer oppførsel på andre detaljsider (remount av `Tabs` ved endret fanesett).
  - **Mitigation**: `key` endres bare når fane-id-ene endres, og det skjer ikke på sider med faste faner. Kjør testene for alle brukere av komponenten (#2).
- **Risk**: cache-policy på `FeideApplikasjon` slås ikke sammen med `Applikasjon`-policyen.
  - **Mitigation**: verifiser i #4. Fallback: registrer feltene på `Applikasjon` (de finnes bare på `FeideApplikasjon`, men policyen gjør ingen skade).
- **Risk**: «allerede i taket/gulvet» henter `first: 100` for én (org, miljø). Flere enn 100 aktive roller i én kombinasjon er usannsynlig, men mulig.
  - **Mitigation**: følg `hasNextPage` også her, eller vis en advarsel. Bestemmes i #6.
- **Risk**: T5-kontrakten lander med en form som krever endringer i listen fra #8 (f.eks. nytt felt i stedet for utvidet `brukerdelegeringer`).
  - **Mitigation**: radnøkkel og «allerede i taket» er isolert i hver sin funksjon (#8, #9). Fase 2 er en egen task.
- **Risk**: et avklart valg (A1–A7) endres etter at koden er skrevet.
  - **Mitigation**: hvert valg peker på tasken det berører. A1, A3 og A6 er tekst og én kolonne. A4 er rollekoden og navnerommet i én hook.

### Testing Requirements

- Enhetstester: `aliasBatch` (nytt feilsett-argument), `formatGyldighetstidsrom`, `harRolleIOrganisasjon` (uttrukket fra `useWithRole`), `useTakOgGulvForvaltning` (flere miljøer, eier uten `APPLIKASJONSADMINISTRASJON_SKRIV`, paginering, feil), `useForretningsroller` (utgåtte filtreres), `rollerAlleredeITaket`, `takRadNokkel`.
- Komponenttester: `DetailPageTabbedContent` (falske barn, `pending`, dyplenke), begge listene, alle fire dialogene (kaskade, disabled-roller, delvis suksess, samlet feil, alt vellykket, tom payload).
- `.a11y.test.tsx`: `ApplikasjonDetails`, `ApplikasjonTak`, `ApplikasjonGulv`, begge `…Actions`, alle fire dialogene, `AliasBatchUtfall`.
- Eksisterende tester for personbrukerrollene, Tilganger-fanen og `useWithRole` går uendret etter #1, #3 og #4.
- Manuell test mot mock-API-et (#10).

## Success Criteria

- [ ] All acceptance criteria for Task #1–#10 met
- [ ] All tests passing (lint, tsc, jest, a11y)
- [ ] Code follows project conventions (CLAUDE.md, skillene i analysen)
- [ ] Alle must-krav i 018 (direkte rader) og 019 er dekket i fase 1. Samlingstak-kravene i 018 er dekket av Task #11 når T5 er levert.
- [ ] Implementasjonen følger de avklarte valgene A1–A7 (Kjetil, 06.11.2026): fanene «Delegeringstak» og «Grunntilgang» etter «Tilganger», og gating på `APPLIKASJONSADMINISTRASJON_SKRIV` i `fs-admin` per miljø

## Requirements Traceability

| Requirement | Summary | Addressed by Task(s) | Status |
| --- | --- | --- | --- |
| 018, 019 | Fanen vises bare for Feide-applikasjoner | #2, #5, #8 | Planned |
| 018, 019 | Alle som kan se applikasjonen, ser fanen | #5, #8 | Planned |
| 018, 019 | Listen viser Rolle, Organisasjon, Miljø, Gyldighetstidsrom, bare det som gjelder nå | #4, #5, #8 | Planned |
| 018, 019 | Tildele én eller flere roller for én organisasjon og ett miljø | #6, #9 | Planned |
| 018, 019 | Fjerne én eller flere roller | #7, #9 | Planned |
| 018, 019 | Delvis suksess | #1, #4, #6, #7, #9 | Planned |
| 018, 019 | Bare forretningsroller i valglisten | #4, #6, #9 | Planned |
| 019 | Rolle allerede i gulvet kan ikke velges | #6 | Planned |
| 018 | Rolle allerede i taket kan ikke velges (direkte) | #9 | Planned |
| 018 | Rolle i taket gjennom samling regnes som allerede i taket | #11 | Blocked (T5) |
| 018, 019 | Forvaltning krever applikasjonsadministrator-rollen for eier og radens organisasjon i samme miljø | #3, #6, #7, #9 | Planned |
| 018, 019 | Valglisten for organisasjon er begrenset | #3, #6, #9 | Planned |
| 018, 019 | Valglisten for miljø avhenger av valgt organisasjon | #3, #6, #9 | Planned |
| 018, 019 | Forvaltning ikke tilgjengelig uten rollen for eieren | #3, #6, #9 | Planned |
| 018, 019 | Fjerning begrenset til organisasjoner jeg administrerer | #3, #7, #9 | Planned |
| 018 | Organisasjonssamling kan ikke velges ved tildeling | #9 | Planned |
| 018 | Tak for en organisasjonssamling vises per organisasjon | #11 | Blocked (T5) |
| 018 | Listen viser hvor taket kommer fra | #11 | Blocked (T5) |
| 018 | Tak fra en organisasjonssamling kan ikke fjernes | #11 (trivielt oppfylt i fase 1: samlingsrader vises ikke) | Blocked (T5) |
| 018, 019 | Effekt ved innlogging | – (backend, ingen flate i fs-admin) | N/A |

## Cross-contributor

- **backend (fs-plattform), T5/T6 (!6576), samlingstak:** trengs for Task #11. Blokkerer tre krav i 018. De fem klientpunktene under Task #11 må besvares i kontrakten.
- **backend (fs-plattform), BAT-416 steg 2 (pågår):** trengs bare hvis aktør skal vises senere (A6). Blokkerer ikke fase 1.
- **krav og design (sikt-no/fs#914):** A1 (fanenavn), A2 (kilde for samlingstak) og A3 (advarsel i gulvet) er avklart av Kjetil 06.11.2026. Ingenting står åpent for fs-admin. Design-dokumentene kan oppdateres med fanenavnene.
