# Analysis: Delegeringstak og grunntilgang for Feide-applikasjoner (fs-admin)

- **Krav:** `@BRU-APP-API-018` (delegeringstaket), `@BRU-APP-API-019` (grunntilgangen). Jira: [BAT-411](https://sikt.atlassian.net/browse/BAT-411). Krav-PR: sikt-no/fs#914.
- **Repo og rolle:** fs-admin, `frontend`. Backend-siden står i `../backend/analysis-…` og `../backend/plan-…` (fs-plattform, T1–T7).
- **Kodegrunnlag:** fs-admin `origin/main` `7905c4fa2` (2026-11-05). fs-plattform `origin/main` `3909b3e3b9` (2026-11-05). Publisert SDL `production/experimental` og `test/experimental` hentet 2026-11-05 (identiske for feltene under).
- **Analysen foreslår ikke løsninger.** Den beskriver hva som finnes, hva som mangler og hva som avhenger av backend.

## Problem Statement

Spec-dokumentet ([`spec-tak-og-gulv-for-feide-applikasjoner.md`](../spec/spec-tak-og-gulv-for-feide-applikasjoner.md)) beskriver to nye faner på detaljsiden for Feide-applikasjoner, én for delegeringstaket og én for grunntilgangen. Applikasjonsadministratoren ser rollene som gjelder nå, med gyldighetstidsrommet, og tildeler og fjerner forretningsroller per organisasjon og miljø. Delegeringstak gjennom en organisasjonssamling vises med kilde, men forvaltes ikke.

Sett fra fs-admin er dette:

- to nye faner på `ApplikasjonDetails`, som bare vises for `FeideApplikasjon`
- to lister over grafens `FeideApplikasjon.brukerdelegeringer` (delegeringstaket) og `FeideApplikasjon.brukergrunntilganger` (grunntilgangen)
- to par tildel- og fjern-dialoger mot `leggTil…`/`fjern…`-mutasjonene, med delvis suksess per rad
- gating etter en rett fs-admin i dag ikke leser klientside: `BRUKERADMIN_WSBRUKER_SKRIV` i både eierorganisasjonen og radens organisasjon, i samme miljø

## Current State

### Detaljsiden for applikasjoner

- `src/domains/tilgangsstyring/features/ApplikasjonDetails/ApplikasjonDetails.tsx:89-109`: `DetailPageTabbedContent` med to faner, «Detaljer» (`id="detaljer"`) og «Tilganger» (`id="tilganger"`). Fanene er faste, uten vilkår.
- `hooks/useGetApplikasjon.tsx:34-131`: `node(id)` med inline-fragmenter på `FeideApplikasjon`, `MaskinportenApplikasjon` og `MaskinbrukerApplikasjon`. Sender `Feature-Flags: experimental` (`:156`).
- `hooks/useGetApplikasjonTypes.ts:50-68`: UI-enumen `Identitetsleverandor` (FEIDE, MASKINPORTEN, MASKINBRUKER) utledes av `__typename`, og `toApplikasjonDetailNode` legger den på detaljnoden (`:95-102`). Klienten kan altså allerede avgjøre om applikasjonen er en Feide-applikasjon.
- Ingenting i fs-admin leser delegeringstaket eller grunntilgangen i dag. `git grep` på `brukerdelegeringer`, `brukergrunntilganger`, `Brukerdelegering` og `Brukergrunntilgang` i `src/` gir ingen treff utenom genererte typer.

### Tilganger-fanen: nærmeste mønster på samme side

`components/ApplikasjonTilganger/` er den fanen fanene for delegeringstak og grunntilgang vil ligne mest på:

- `ApplikasjonTilganger.tsx:27-54`: `DetailPageContentFilterAndResult` med filter i sidebar og `ApplikasjonTilgangerResultList` i hovedfeltet.
- `components/ApplikasjonTilgangerResultList/ApplikasjonTilgangerResultList.tsx:113-193`: `ActionList` med paginering (`useDataListQuery`-props), `orderByElement`, `activeFilterElement`, `filterElement`, `actionsElement`. Radene er `ActionListItem` med `ListItemCell`, og miljø vises som `TagStatus`. Arv og samling vises som tagger: `ArvetTag` og `SamlingTag` (`:163-167`).
- `components/ApplikasjonTilgangerActions/ApplikasjonTilgangerActions.tsx:41-77`: Tildel og Fjern ligger i én `ListActions`-meny (`scope: 'list'`), som eier `FSModal`-skallet. Menyen gates på `APPLIKASJONSADMINISTRASJON_TILDELING` **uten** organisasjonsavgrensning (`:43`).
- `actions/TildelTilgangAction/TildelTilgangAction.tsx:85-344`: kaskade av tre `FSCombobox`-er (organisasjon → miljø → koder, multi-select). Kildene er `mineTildelingsorganisasjoner`, `mineTildelingsmiljoer` (mottaker `APPLIKASJON`) og `tildelbareTilgangskoder`. Feil vises som én `Alert` i `FSModalFeedback`. Ett atomisk kall, ikke alias-batch.
- `actions/FjernTilgangAction/FjernTilgangAction.tsx`: samme kaskade. Kandidatene er applikasjonens tildelinger i kombinasjonen. Arvede rader og samlingsrader står som `disabled` med forklaring i `description`.

### Rollefanen for personbrukere: mønsteret kravene viser til

Design-dokumentene peker på `TildelRolleAction` og `FjernRolleAction` for personbrukere (BRU-PER-GRU-003/012):

- `features/PersonbrukerDetails/components/PersonbrukerRoller/components/PersonbrukerRollerActions/actions/TildelRolleAction/TildelRolleAction.tsx` (544 linjer): samme kaskade som over, men **delvis suksess per rad** (JSDoc `:90-104`). Gikk alt gjennom, lukkes modalen med snackbar. Ellers holdes den åpen med utfallet per rad. «Allerede tildelt» utledes fra de direkte tildelingene i kombinasjonen, og slike koder kan ikke velges (BAT-274, `:84-88`).
- `hooks/batchTildeling.ts`: `byggAliasBatch`, `byggAliasVariabler`, `delIBiter`, `utledFellesFeil`, `MAKS_ALIAS_PER_KALL = 25`. Ett alias-rotfelt per rad. Settet `SAMLEDE_FEIL` (`:38-45`) er hardkodet til personbrukerfeil (`ManglerTildelingsrett`, `FeideBrukerIkkeFunnet`, `PersonbrukerIkkeFunnet`, `SyntetiskPersonIEktMiljo`, `EktePersonISyntetiskMiljo`, `NetworkError`).
- `components/PersonbrukerRollerResultList/PersonbrukerRollerResultList.tsx:133-140`: `formatGyldighetstidsrom` er en lokal funksjon inne i komponenten, ikke en delt util. Formatet er «01.05.2026 –», «– 01.08.2026», «01.05.2026 – 01.08.2026», og `ingenVerdi` når begge mangler. Brukt i `:264`.

### Gating og tilganger i klienten

- `src/features/WithRole/useWithRole.ts:8-14, 41-78`: sjekker **frontendroller** (navnerom `fs-admin`), med valgfri `organisasjonskode` som krever at rolle og organisasjon står på samme rad.
- `src/common/lib/auth/globalUserContext.tsx:130-190` og `hooks/useTilgangerFilter.ts:36-90`: `mineTilganger` hentes **for ett miljø**, det fs-admin kjører mot (`MILJO_KODE_BY_ENV`), og for navnerommet `fs-admin`. Det finnes ingen hook som henter `mineTilganger` for flere miljøer.
- `src/common/types/generated/tilgangsroller.ts:20-26`: frontendrollene `APPLIKASJONSADMINISTRASJON`, `_LES`, `_SKRIV`, `_TILDELING`.
- fs-plattform `0040-forretnings-og-ui-roller.sql:158-168`: `APPLIKASJONSADMINISTRATOR` → `APPLIKASJONSADMINISTRASJON` → `APPLIKASJONSADMINISTRASJON_SKRIV` → `BRUKERADMIN_WSBRUKER_SKRIV`. På `origin/main` er `APPLIKASJONSADMINISTRASJON_SKRIV` den eneste rollen som impliserer `BRUKERADMIN_WSBRUKER_SKRIV`. `APPLIKASJONSADMINISTRASJON_TILDELING` impliserer `BRUKERADMIN_TILDELING_SKRIV`, som er en annen rett.

### Felles komponenter og infrastruktur

- `src/common/components/layouts/DetailPageLayout/components/DetailPageTabbedContent/DetailPageTabbedContent.tsx:24-95`: `children` er typet som `ReactElement | ReactElement[]`. Komponenten leser `child.props.id` på hvert barn (`:46, :53, :58, :81-89`) uten å filtrere bort `false`/`null`. Den aktive fanen ligger i `?tab=` (nuqs). Finnes ikke fanen blant barna, settes URL-en tilbake til første fane (`:63-67`).
- `src/domains/tilgangsstyring/components/SamlingTag/SamlingTag.tsx`: tag med samlingenes navn, tar `tilknytning` og en **liste** `organisasjonssamlinger` (`SamlingForVisning { lopenummer, navnAlleSprak }`).
- `src/domains/tilgangsstyring/components/FeideBrukerNavn/FeideBrukerNavn.tsx`: viser `FeideBruker` (navn, ellers brukernavn). Det finnes ingen tilsvarende komponent for `Personbruker` som aktør.
- `src/common/lib/apollo/cacheConfig.ts:109-138`: `nodesCursorPagination(['filter', 'orderBy'])` er registrert for `Applikasjon.tilganger`, `FeideBruker.tilganger` og `Personbruker.tilganger`. Ingen policy for `brukerdelegeringer` eller `brukergrunntilganger`.
- `graphqlSchemaLocation.ts`: codegen leser **production/experimental**-SDL. Typer som bare finnes i test, gir kompileringsfeil til de er i produksjon.
- Tekster: `src/common/messages/nb/tilgangsstyring.json:254-266` (`ApplikasjonDetails.detaljerTab`, `tilgangerTab`).
- Brukerveiledninger: `src/features/Brukerveiledninger/innhold/` har ingen veiledning for applikasjoner.

### Grafen på fs-plattform `origin/main` og i publisert SDL

**Grunntilgang (T3 og T4, i produksjon):** `schema_gulv.graphqls`

- `FeideApplikasjon.brukergrunntilganger(filter: BrukergrunntilgangerFilterInput)`: `@asConnection(defaultFirstValue: 10)`, filter `miljoer`, `organisasjoner`, `erAktivNaa`. Sortering `ORGANISASJONSKODE, MILJOKODE, ROLLEKODE, OPPRETTET_TIDSPUNKT`.
- `Brukergrunntilgang`: `tilgangsrolle`, `organisasjon`, `miljo`, `gyldighetsperiode { fraTidspunkt tilTidspunkt }`, `erAktivNaa`, `lagtTilAvBruker: Personbruker`, `fjernetAvBruker: Personbruker`. Ingen node-id.
- `leggTilBrukergrunntilganger` / `fjernBrukergrunntilganger(input: [{ applikasjonId, tilgangskodeId, organisasjonId, miljoId }])`. Payload `feideApplikasjoner` + `errors`. Hvert kall er alt eller ingenting. Mutasjonsbeskrivelsen anbefaler selv alias per element for delvis suksess.
- Feiltyper:
  - legg til: `ManglerGrunntilgangsforvaltning`, `BrukergrunntilgangApplikasjonFinnesIkke`, `BrukergrunntilgangTilgangskodeFinnesIkke`, `SyntetiskApplikasjonIEktMiljo`, `BrukergrunntilgangErPlanlagt`
  - fjern: `ManglerGrunntilgangsforvaltning`, `BrukergrunntilgangApplikasjonFinnesIkke`, `BrukergrunntilgangErPlanlagt`
  - `BrukergrunntilgangErPlanlagt` betyr at rollen har et innslag i grunntilgangen som begynner å gjelde senere. Slike innslag kommer fra migreringer.

**Delegeringstak (direkte rader, i produksjon):** `schema_delegeringstak.graphqls`

- `FeideApplikasjon.brukerdelegeringer(filter: BrukerdelegeringerFilterInput)`, med samme filter og sortering som grunntilgangen.
- `Brukerdelegering`: `tilgangsrolle`, `organisasjon`, `miljo`, `gyldighetsperiode`, `erAktivNaa`, `delegertAvFeideBruker: FeideBruker`, `delegertAvApplikasjon`, `trukketTilbakeAvFeideBruker`, `trukketTilbakeAvApplikasjon`. Ingen `tilknytning` og ingen samlingsrader.
- `leggTilBrukerdelegeringer` / `fjernBrukerdelegeringer` med de samme fire delene. Feil: `ManglerDelegeringsforvaltning`, `BrukerdelegeringApplikasjonFinnesIkke`, `BrukerdelegeringTilgangskodeFinnesIkke` (bare legg til).

**Delegeringstak gjennom en organisasjonssamling (T5, !6576, åpent):** Branchen `tilgangsstyring/BAT-411-tak-gulv-t6-samlingstak-i-grafen` (2026-11-05) er **dagens kandidat, ikke kontrakten**. Den flytter `Brukerdelegering` til viewet `applikasjon_brukerdelegering_med_samling` og legger til `tilknytning: BrukerdelegeringTilknytning! { DIREKTE, SAMLING }` og `organisasjonssamling: Organisasjonssamling` (entall). Sorteringen får i tillegg `TILKNYTNING` og `KILDENOKKEL`. Ifølge oppdragsgiver redesignes dette, trolig til én `Brukerdelegering` med `tilknytning` over en Graphitron-`@routine`. Beslutningen er ventet 06.11. Merk nummereringen: «T5 (!6576)» her dekker planens T5 (DB) og T6 (graf).

**Kildene for valglistene:**

- `Query.mineTildelingsorganisasjoner` / `mineTildelingsmiljoer(mottaker: TildelingsmottakerInput)`: enumen har bare `APPLIKASJON` (`BRUKERADMIN_TILDELING_SKRIV`), `PERSONBRUKER` (`BRUKERADMIN_PERSON_TILDELING_SKRIV`) og utelatt (Feide-bruker). Ingen verdi svarer til `BRUKERADMIN_WSBRUKER_SKRIV`.
- `Query.tildelbareTilgangskoder` sjekker tildelingsretten. `Query.mineTildelbareTilgangsroller` sjekker `BRUKERADMIN_PERSON_TILDELING_SKRIV`, men har `navneromstyper: [FORRETNING]`.
- `Query.tilgangsroller(filter: { navnerom: [ID!] })` er hele rollekatalogen, filtrert på navnerom-id. Ingen filter på navneromstype.
- `Query.navnerom` gir `Tilgangsnavnerom { id kode navneromstype }`.
- `Query.mineTilganger(filter: { miljo: ID!, navnerom: ID })` gir det effektive settet per miljø. Uten `navnerom` kommer alle navnerom med, også privilegier i subgraf-navnerom.
- `Query.mineSynligeMiljoer` gir miljøene.

## Key Findings

1. **Grunntilgang kan bygges mot produksjonsgrafen nå.** Lesing, forvaltning og feiltypene finnes i publisert `production/experimental`-SDL, så codegen virker uten overstyring.
2. **Delegeringstak med direkte rader kan bygges nå. Delegeringstak gjennom en organisasjonssamling kan ikke.** Felt for kilde (`tilknytning`, samling) finnes ikke i noen publisert SDL. Fram til T5 er levert, ser fanen bare direkte rader, og «allerede i delegeringstaket gjennom en organisasjonssamling» kan ikke utledes.
3. **Gating-primitivet backend forutsetter, finnes ikke i fs-admin.** Kontrakten sier at klienten utleder fra `mineTilganger` per miljø: `BRUKERADMIN_WSBRUKER_SKRIV` i (miljø, eier) og (miljø, radens organisasjon). Tre ting står i veien:
   - `useTilganger`/`useWithRole` leser bare navnerommet `fs-admin`, så `BRUKERADMIN_WSBRUKER_SKRIV` (et privilegium i et annet navnerom) er aldri synlig der. Det synlige motstykket er frontendrollen `APPLIKASJONSADMINISTRASJON_SKRIV`, som impliserer privilegiet (0040:165). Det er en implikasjon, ikke privilegiet selv: får privilegiet senere flere kilder, svarer de to ulikt.
   - `mineTilganger` hentes for **ett** miljø, det fs-admin kjører mot. Kravene trenger svar per miljø: valglisten for miljø, og fjern-muligheten per rad i et gitt miljø. Det er et nytt databehov, ikke gjenbruk.
   - Dagens kaskade-hooks (`useGetMineTildelingsorganisasjoner`, `useGetMineTildelingsmiljoer(…, APPLIKASJON)`, `useTildelbareTilgangskoder`) sjekker `BRUKERADMIN_TILDELING_SKRIV`. Gjenbrukt som de er, ville de vist feil organisasjoner og miljøer. **Dette er den letteste feilen å gjøre i planen.**
4. **Ingen eksisterende kilde gir valglisten for rolle.** `tildelbareTilgangskoder` og `mineTildelbareTilgangsroller` sjekker andre retter. `tilgangsroller(filter: { navnerom })` med id-en til navnerommet `fs` (type `forretning`, slått opp via `Query.navnerom`, som `tilgangerFilterService` gjør for `fs-admin`) er den kilden som passer. Ingen applikasjons-hook gjør dette i dag. Serveren avgrenser ikke til forretningsroller, så filteret er klientens (backend-beslutning 1).
5. **Fanene kan ikke legges inn med vilkår uten videre.** `DetailPageTabbedContent` leser `.props.id` på hvert barn, og et `false`-barn (`{erFeide && <Panel/>}`) vil feile. Mens detaljspørringen laster, er identitetsleverandøren ukjent. En dyplenke `?tab=<delegeringstak>` blir da satt tilbake til første fane av effekten i `:63-67`, før fanen finnes.
6. **Delvis suksess finnes som mønster, men er knyttet til personbrukere.** `batchTildeling.ts` ligger under `PersonbrukerRoller/hooks/`, og `SAMLEDE_FEIL` inneholder bare personbrukerfeil. Delegeringstak og grunntilgang har egne feiltyper som gjelder hele kombinasjonen (`ManglerDelegeringsforvaltning`, `ManglerGrunntilgangsforvaltning`, `…ApplikasjonFinnesIkke`, `SyntetiskApplikasjonIEktMiljo`), og en feil per rad (`BrukergrunntilgangErPlanlagt`). Tilganger-fanen for applikasjoner bruker ikke alias-batch. Den kaller én gang, atomisk. Det finnes allerede import på tvers av features (`TildelTilgangAction` importerer `useGetMineTildelingsmiljoer` fra `PersonbrukerDetails`).
7. **Mutasjonspayloaden er applikasjonen, ikke listen.** Listene må hentes på nytt (`refetchQueryNames`, `awaitRefetchQueries`, som i dag). Lesing følger innsyn, og innsyn er ikke det samme som skriverett. Tilganger-fanen har derfor en egen «tom payload»-tekst (`TildelTilgangAction.tsx:71-76, 260-265`). Her er payloaden `feideApplikasjoner`, som kan være tom av samme grunn.
8. **«Bare det som gjelder nå» er et filter i spørringen.** `erAktivNaa: true` på begge feltene. Uten det kommer hele historikken. `totalCount` gjelder det kalleren ser.
9. **Gyldighetstidsrommet har ferdig format, men ikke delt kode.** `formatGyldighetstidsrom` er lokal i `PersonbrukerRollerResultList.tsx:133`. Grafen gir `tilTidspunkt: null` for «til videre», og perioden er halvåpen.
10. **Sporingsfeltene er ulike på delegeringstak og grunntilgang, men kravene ber ikke om dem.** Listefeltene i kravene er Rolle, Organisasjon, Miljø og Gyldighetstidsrom. Grunntilgang har `lagtTilAvBruker: Personbruker`, delegeringstak har `delegertAvFeideBruker: FeideBruker`. Vises en aktør, gjelder BAT-416: navnet, ellers Feide-id-en til første koblede Feide-bruker, ellers «–». Det er ingen `Personbruker`-aktørkomponent i fs-admin, og begrunnelsen i `FeideBrukerNavn.tsx` om at sporing bare viser brukernavn er opphevet av BAT-416.
11. **Rader i grunntilgangen kan ha koder som ikke er forretningsroller** (fra migreringen i 0099, ifølge backend-kontrakten). Listen og fjern-dialogen kan ikke anta at alle rader er forretningsroller.
12. **Samme rolle kan stå flere ganger i delegeringstaket for samme organisasjon og miljø**, i T5-kandidaten: én gang direkte og én gang per organisasjonssamling. Radnøkler og «allerede i delegeringstaket»-utledningen må tåle det. `SamlingTag` tar en liste samlinger, mens kandidaten har én `organisasjonssamling` per rad.
13. **Cache:** `brukerdelegeringer` og `brukergrunntilganger` er paginerte connection-felt på `FeideApplikasjon` uten type-policy i `cacheConfig.ts`.

## Technical Constraints

- **CLAUDE.md (fs-admin):**
  - komponentnavn i PascalCase med `function`
  - `.a11y.test.tsx` per feature/komponent (unntaket for delte listekomponenter gjelder `ActionList`-resultatlister)
  - spørringer ligger ved komponenten og deles ikke
  - `refetchQueryNames(...)`, aldri strenger
  - ikke `__typename` i spørringer
  - SDS- og felleskomponenter først, layout med `Grid`/`Flex`
  - changeset for brukerrettede endringer (`fs-admin-changesets`)
  - sjekk brukerveiledninger (ingen for applikasjoner)
  - arbeidsspråk engelsk, domenespråk norsk
- **Skills i repoet:** `fs-admin-detail-pages`, `fs-admin-list-results`, `fs-admin-list-filters`, `fs-admin-modal`, `fs-admin-inputs`, `fs-admin-buttons`, `graphql-consumer`, `fs-admin-i18n-structure`, `fs-admin-mock-api-with-data`.
- **Dialogmønster:** fs-admin bruker `ListActions` med `FSModal` for tildeling og fjerning, både på applikasjons- og personbrukersiden. Min kompetanse unngår modaler, men fs-admins eget mønster gjelder her (oppdragsgivers føring).
- **Codegen mot production-SDL:** felt fra T5 kan ikke brukes i kode på `main` før de er i produksjon. Lokalt kan `GRAPHQL_SCHEMA_LOCATION` peke på `test/experimental`.
- **Feltene er experimental:** spørringene sender `Feature-Flags: experimental` (som `useGetApplikasjon`).
- **Ingen serverberegnede `kan*`-flagg:** arkitekten har avvist dem (`useGetApplikasjonTypes.ts:73-77`, `useGetPersonbrukerTypes.ts:55-75`). Gating er et UI-hint, og håndhevingen ligger i RLS (`kan_forvalte_delegering`).
- **Mutasjonene er alt eller ingenting per kall.** Delvis suksess krever ett alias per element.
- **Ingen node-id på radene.** Fjerning tar de fire delene (applikasjon, rolle, organisasjon, miljø), og radnøkler må bygges av dem (+ tilknytning/samling for delegeringstak).
- **Ord:** bruk «delegeringstak» og «grunntilgang» (Kjetils terminologibeslutning 06.11.2026), aldri «tak», «gulv» eller «samlingstak». Skriv «delegeringstak gjennom en organisasjonssamling». Ellers kravenes og grafens ord (forretningsrolle, organisasjonssamling, applikasjonsadministrator-rollen, gyldighetstidsrom). Kontrakten beholder sine navn (`Brukerdelegering`, `Brukergrunntilgang`, `brukerdelegeringer`, `brukergrunntilganger`, feiltypene). Lag ikke nye ord.

## Dependencies

- **Internt (fs-admin):**
  - `ApplikasjonDetails.tsx` og `useGetApplikasjon` (identitetsleverandør)
  - `DetailPageTabbedContent` (vilkårsfaner, dyplenke)
  - `ActionList`/`ListActions`/`FSModal`/`FSCombobox`
  - `batchTildeling.ts` (alias-batch, nå under personbrukerfeaturen)
  - `SamlingTag` (kilde for delegeringstak gjennom en organisasjonssamling)
  - `formatGyldighetstidsrom` (lokal i personbrukerlisten)
  - `useWithRole`/`useTilganger`/`useTilgangerFilter` (ett miljø, `fs-admin`-navnerom)
  - `cacheConfig.ts`
  - `tilgangsstyring.json`
- **Eksternt:**
  - fs-plattform tilgangsstyring-subgrafen via supergrafen
  - publisert SDL for codegen
  - `@sikt/sds-*`
- **Cross-contributor:**
  - **backend (fs-plattform), T5 / !6576, delegeringstak gjennom en organisasjonssamling:**
    - Behov: samlingsrader i listen over delegeringstak med kilde (DIREKTE/SAMLING og hvilken samling), og en entydig radform.
    - Hvorfor det blokkerer: tre krav i `@BRU-APP-API-018` kan ikke oppfylles uten det: «Delegeringstak gjennom en organisasjonssamling vises per organisasjon», «Listen viser hvor delegeringstaket kommer fra» og «Rolle i delegeringstaket gjennom en organisasjonssamling regnes som allerede i delegeringstaket». «Delegeringstak gjennom en organisasjonssamling kan ikke fjernes» er trivielt oppfylt så lenge samlingsrader ikke vises.
    - Formen er åpen til 06.11. Klientpunkter som avhenger av den:
      - feltnavn og enum
      - én eller flere samlinger per rad
      - om samme (org, miljø, rolle) kan stå flere ganger
      - sorteringsnøkkel og paginering
      - om `trukketTilbakeAv*` er null for samlingsrader
  - **backend (fs-plattform), T7 / !6580, docs:** blokkerer ikke fs-admin. Teksten i fs-admin kan lene seg på den for forklaringen av delegeringstak og grunntilgang.
  - **backend (fs-plattform), ingen task, valgfritt:** en kilde for organisasjoner og miljøer der man kan forvalte delegeringstak og grunntilgang (som `mineTildelingsorganisasjoner` med egen mottaker) finnes ikke. Backend har bestemt at klienten utleder dette fra `mineTilganger` (beslutning 3), så dette er ikke en bestilling. Det er notert fordi utledningen per miljø er det mest kompliserte på klientsiden (funn 3).
  - **krav og design (sikt-no/fs#914):**
    - Behov: fanenavn og plassering, visning av kilde for delegeringstak gjennom en organisasjonssamling, og om dialogen for grunntilgang skal advare.
    - Hvorfor det blokkerer: tekster og layout i fs-admin.

## Requirements Impact

**Kan oppfylles med det som finnes i fs-admin og grafen nå:**

- *Fanen for delegeringstaket/grunntilgangen vises bare for Feide-applikasjoner* (018, 019): identitetsleverandøren finnes i adapteren. Vilkårsfaner og dyplenke må håndteres (funn 5).
- *Alle som kan se applikasjonen, ser fanene* (018, 019): lesingen følger lesereglene på serveren. Ingen gating på visning.
- *Listen viser Rolle, Organisasjon, Miljø, Gyldighetstidsrom, og bare det som gjelder nå* (018, 019): `erAktivNaa: true` og `gyldighetsperiode` finnes. Formatet finnes i personbrukerlisten.
- *Tildele og fjerne én eller flere roller for én organisasjon og ett miljø* (018, 019): mutasjonene finnes for begge.
- *Delvis suksess* (018, 019): alias-batch finnes som mønster (funn 6). Feiltypene for delegeringstak og grunntilgang må mappes.
- *En rolle som allerede er i delegeringstaket/grunntilgangen for samme kombinasjon kan ikke velges* (018 direkte, 019): kan utledes fra listene (`filter: { organisasjoner, miljoer, erAktivNaa }`), som `useFjernbareBrukerTilganger` gjør for personbrukere.
- *Bare forretningsroller i valglisten* (018, 019): klientfilter over `tilgangsroller` med `fs`-navnerommet (funn 4).

**I fare:**

- *Forvaltning krever applikasjonsadministrator-rollen for eier og radens organisasjon i samme miljø*, *Valglisten for organisasjon er begrenset*, *Valglisten for miljø avhenger av valgt organisasjon*, *Forvaltning ikke tilgjengelig uten rollen for eieren*, *Fjerning begrenset til organisasjoner jeg administrerer* (018, 019): krever `mineTilganger` per miljø, og det henter fs-admin ikke i dag (funn 3). Gjenbruk av tildelings-hookene gir feil svar. Serveren håndhever uansett, så risikoen gjelder UI-et, ikke sikkerheten.
- *Delegeringstak gjennom en organisasjonssamling vises per organisasjon*, *Listen viser hvor delegeringstaket kommer fra*, *Rolle i delegeringstaket gjennom en organisasjonssamling regnes som allerede i delegeringstaket* (018): blokkert av T5 (funn 2).
- *Organisasjonssamling kan ikke velges ved tildeling i delegeringstaket* (018): valglisten for organisasjon bygges av organisasjoner, så dette er oppfylt så lenge kilden ikke inneholder samlinger.

**Mangler eller uklart, oppdaget i analysen:**

- Hvilke miljøer valglisten for miljø skal tilby, er ikke avgrenset i kravene utover retten. Dette gjelder alle miljøer der retten gjelder, eller bare miljøene applikasjonen har (`FeideApplikasjon.miljoer`). Tilganger-fanen tilbyr miljøene der retten gjelder.
- `BrukergrunntilgangErPlanlagt` (et planlagt innslag i grunntilgangen) er ikke beskrevet i kravene. Raden vises ikke i listen (den gjelder ikke nå), men både tildeling og fjerning kan få feilen.
- Effekten av delegeringstaket og grunntilgangen ved innlogging (siste regel i begge featurene) er backend-atferd og har ingen flate i fs-admin.

## Krav-input referanse

Lenkene under er skrevet for den publiserte kopien i `tasks/<domain>/<slug>/frontend/`.

- **Spec-dokument:** [`spec-tak-og-gulv-for-feide-applikasjoner.md`](../spec/spec-tak-og-gulv-for-feide-applikasjoner.md)
- **Krav-input-manifest:** [`krav-input/manifest.md`](../spec/krav-input/manifest.md)
- **Backend:** [`analysis-tak-og-gulv-for-feide-applikasjoner.md`](../backend/analysis-tak-og-gulv-for-feide-applikasjoner.md), [`plan-tak-og-gulv-for-feide-applikasjoner.md`](../backend/plan-tak-og-gulv-for-feide-applikasjoner.md) («Kontrakt for fs-admin», «Klientskisse (fs-admin)»)

## Open Questions

- [ ] **Fanenavn og plassering** (design.md for 018 og 019): hva heter fanene, og hvor står de blant «Detaljer» og «Tilganger»?
- [ ] **Visning av kilde for delegeringstak gjennom en organisasjonssamling** (design.md for 018): (a) egen kolonne, (b) tag som `SamlingTag` («Via samling …») i rollecellen, slik Tilganger-fanen gjør, eller (c) noe annet?
- [ ] **Advarsel i dialogen for grunntilgang** (design.md for 019): skal dialogen si at en rolle i grunntilgangen gis til alle brukere av applikasjonen, også ukjente? Mutasjonsbeskrivelsen sier det eksplisitt.
- [ ] **T5-formen** (!6576, beslutning 06.11): én `Brukerdelegering` med `tilknytning` over en `@routine`, eller view-varianten på branchen? Én eller flere samlinger per rad? Skal fs-admin levere delegeringstak med direkte rader først og delegeringstak gjennom en organisasjonssamling etterpå, eller vente?
- [ ] **Kilde for gating per miljø:** (a) `mineTilganger` per miljø i `mineSynligeMiljoer`, med navnerommet `fs-admin` og sjekk på `APPLIKASJONSADMINISTRASJON_SKRIV`, (b) det samme uten navnerom og med sjekk på `BRUKERADMIN_WSBRUKER_SKRIV`, eller (c) en egen serverkilde (avvist av backend i dag, beslutning 3)?
- [ ] **Hvilke miljøer valglisten for miljø skal tilby:** alle der retten gjelder for eier og organisasjon, eller bare dem applikasjonen har i `miljoer`?
- [ ] **Sporingsfelt:** skal listene vise hvem som la til (grunntilgang har `lagtTilAvBruker: Personbruker`, delegeringstak bare `delegertAvFeideBruker: FeideBruker`)? Kravene ber ikke om det. Vises det, gjelder BAT-416.
- [ ] **Delt alias-batch:** skal `batchTildeling.ts` brukes på tvers av features der den står, eller er plasseringen et planspørsmål? Settet `SAMLEDE_FEIL` må uansett få feilene for delegeringstak og grunntilgang.
