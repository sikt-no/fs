# Analysis: Applikasjon-tilgangsstyring — krav-oppdateringer etter Iter 2-implementasjon

> **Scope:** delta-analyse av de 7 commitene på `fruitbat`-branchen brukeren har listet, festet til SHA [`8f5e0bd`](https://github.com/sikt-no/fs/commit/8f5e0bddedf7c5731722c5fc80159a95db197909). Vurdert opp mot dagens fs-admin-implementasjon (Iter 2 er ferdig på branch `poc-skills-execute-result`, 22 tasks levert) og Figma-skissene i `docs/skisser/`.
>
> **Read-only:** denne analysen er bevisst løsnings-fri (`bat-analyze`). Løsningsdesign hører hjemme i `bat-plan`.
>
> **Foregående analyse:** `docs/ACTIVE-ITERATION-2/analysis-applikasjon-tilgangsstyring.md` (samme initiativ, før Iter 2 ble implementert). Den la grunnlaget; denne analysen ser kun på hva som har endret seg siden.

## Problem Statement

Etter at Iter 2 ble levert (lese-/lett-redigerings-flyt på `/tilgangsstyring/applikasjoner`, samt en god del av Iter 3-mutasjonene), har kravarbeidet i `sikt-no/fs#31` gått videre i to retninger:

1. **Gap-lukking mot Figma-skisser** — flere felter og scenarier er lagt til som ikke var med i Iter 2-kravene. Dette dekker fire av de syv commitene (`59eba3d`, `cee226d`, `4f2e9a4`, og deler av `7ceb640`).
2. **Skarpere krav rundt redigering, opprettelse og obligatoriske felter** — tre commits (`e04d704`, `a7efc9f`, `ccaf83a`) presiserer hvordan redigering, opprettelse og listefiltrering skal oppføre seg. Plus omdøpningen `rediger_beskrivelse → rediger_detaljer` som utvider scopet for editerings-flyten i info-fanen.
3. **Endringslogg som ny iterasjon** — `Iterasjon 4 / endringslogg.feature` (BRU-APP-API-016) er ny i scope og merket `@must @draft` med fire åpne spørsmål. Ble ikke flagget av brukeren som en av "de syv commitene", men ligger på branchen og hører til samme initiativ. Skal nevnes i analysen så `bat-plan` får tatt stilling.

Til sammen betyr dette at fs-admin må:

- Utvide listevisningen med ett ekstra felt og ett ekstra filter.
- Bygge om detalj-fanen fra "klikk en knapp pr. felt" til en samlet rediger-modus med navn + beskrivelse.
- Endre tilgangstildelings-rekkefølge (org → miljø → tilgangskode) og legge til org-filter + tilgangskode-filter + arv-håndtering i tilgangslisten.
- Flytte fjerning av tilganger fra in-row til en samlet modal.
- Forholde seg til at applikasjonen kan være deaktivert under tildeling/fjerning.
- Vurdere endringslogg som ny fane på detaljsiden.

## Endrings­oversikt — commits og påvirkede features

| Commit | Dato | Påvirker | Type endring |
| --- | --- | --- | --- |
| `4f2e9a4` | 2026-05-20 | `vise_tilganger`, `tildele_tilgang`, `fjerne_tilgang` | Utvidet tilgangsliste: organisasjon + beskrivelse pr. tilgang, organisasjons-filter, arv-håndtering, deaktivert-tilstand |
| `cee226d` | 2026-05-20 | `se_detaljer`, `vise_tilganger` | Detaljer-fanen: idP + organisasjon + inline rediger. Tilgangsliste: tilgangskode-fritekstfilter, fjern miljø-sortering, dedup arv |
| `59eba3d` | 2026-05-20 | `listevisning_og_sok`, `se_detaljer`, `tildele_tilgang`, `fjerne_tilgang` | Gap-analyse mot Figma: "Antall tilganger"-kolonne, ny Se status-scenario, org→miljø→tilgangskode-rekkefølge, modal for fjerning |
| `7ceb640` | 2026-05-20 | `rediger_beskrivelse` → `rediger_detaljer` | Omdøp + utvid med navn-redigering |
| `ccaf83a` | 2026-05-20 | `listevisning_og_sok` | Miljø-filter på applikasjonslisten |
| `a7efc9f` | 2026-05-27 | `administrere_ansvarlig`, `rediger_detaljer`, `opprette_applikasjon` | Obligatoriske felter (navn, ansvarlig) ved oppretting og redigering |
| `e04d704` | 2026-05-27 | `rediger_detaljer` | Ulagrede endringer forkastes ved navigering |

Eneste fil som *ikke* er rørt av disse commitene: `passordbytte.feature`, `deaktivere_applikasjon.feature`, og selve `systemkrav.md`-filene for Iter 2/3. (Iter 4 + endringslogg-filen er ny scope, men ikke en del av de listede commitene.)

## Krav-delta pr. feature

Sammenligningen er gjort mellom snapshot i `docs/ACTIVE-ITERATION-2/krav-input/` (versjonen Iter 2-implementasjonen var basert på) og den festede SHA-en på `fruitbat`.

### `BRU-APP-API-001` — Listevisning og søk (`listevisning_og_sok.feature`)

**Endringer:**

- Felt-tabellen i "Se liste over applikasjoner" får én ny rad: `Antall tilganger` (commit `59eba3d`, gap-analyse mot Figma).
- Ny scenario `Filtrere på miljø` (commit `ccaf83a`) — *"vises kun applikasjoner som er aktive i det valgte miljøet"*.

**Konsekvens for fs-admin:** Filteret + det nye listefeltet eksisterer ikke i koden eller schema-en i dag (`ApplikasjonerFilterInput` har bare `navnContains`, `organisasjonsIder`, `status`, `tilgangskoder`). Skissen `applikasjoner-listevisning.png` viser miljø-chip pr. rad og "8 tilganger / 12 tilganger" i én av de senere kolonnene — `ApplikasjonerResultRow` viser miljø-chips og status, men ikke antall-tilganger.

### `BRU-APP-API-002` — Se detaljer (`se_detaljer.feature`)

**Endringer (commit `cee226d` + `59eba3d`):**

- Tre nye `Scenario`-er: `Se identitetsleverandør`, `Se organisasjon`, `Se status` (siste tilført i `59eba3d` "Legg til Se status-scenario").
- Ny regel: *"Detaljer kan redigeres direkte fra detaljer-fanen"* med scenario `Aktivere redigering av detaljer` (*"Når jeg velger å redigere, så blir alle redigerbare felter i detaljer-fanen omgjort til inputfelter"*).

**Konsekvens for fs-admin:** Topbar-en (`ApplikasjonTopBar.tsx`) viser allerede idP-chip, organisasjon og status — men inni *info-fanen* (`ApplikasjonInformation.tsx`) finnes ikke idP-feltet, og redigering skjer i dag via tre separate dialog-knapper (`RedigerBeskrivelseDialog`, `SettAnsvarligDialog`, `PassordbytteDialog`). Skissen `applikasjon-detaljevisning-aktiv-tab-detaljer-rediger-modus.png` bekrefter at det skal være én rediger-toggle som åpner alle redigerbare felter som inputs samtidig — dette er en strukturell endring fra dialog-mønsteret til inline edit.

### `BRU-APP-API-003` — Vise tilganger (`vise_tilganger.feature`)

**Endringer (commit `cee226d` + `4f2e9a4`):**

- Felt pr. innslag utvidet fra `tilgangskode + miljø` til `tilgangskode + beskrivelse + organisasjon + miljø`.
- Nytt filter: `Filtrere tilgangsliste på organisasjon`.
- Nytt filter: `Filtrere tilgangsliste på tilgangskode` (fritekst, erstatter det gamle multi-select-filteret som tidligere het "Filtrere tilgangsliste på tilgang").
- Sortering: `på miljø eller tilgangskode` → `på tilgangskode` (miljø fjernet).
- Ny regel: *"Arvede tilganger kan skjules fra listen"* med 4 scenarier:
  - `Arvet tilgang er merket med opphav` (viser hvilken tilgang den arves fra).
  - `Arvet tilgang med flere opphav listes kun én gang` (dedup).
  - `Skjule arvede tilganger` / `Vise arvede tilganger` (toggle).

**Konsekvens for fs-admin:** Tilgangs-fragmenten i `ApplikasjonTilgangRowFieldsFragment` har allerede `tilgangskode`, `tilgangsbeskrivelse`, `miljo` og `organisasjon` — så beskrivelse + organisasjon er bare et spørsmål om JSX. **Men:**

1. Filter-input på client er `ApplikasjonTilgangerFilterInput { miljoer, tilgangskoder }`. **Mangler:** `organisasjonsIder`, og det er uklart om backend tilbyr fritekst-søk på `tilgangskoder` eller om det fortsatt er en eksakt match-array. Krav-en sier *"tilgangskoden inneholder den innskrevne teksten"* → fritekst, ikke array.
2. `ApplikasjonTilgangerOrderByField` har både `MILJO` og `TILGANGSKODE` — `MILJO` skal nå fjernes fra UI-en (kan bli stående i schema).
3. **Arv finnes ikke i schema-en i dag.** Krav-en introduserer "arvet tilgang", "opphav til arv", og dedup-logikk — dette er nye begreper både for backend og frontend. Skissen `applikasjon-detaljevisning-aktiv-tab-tilganger.png` viser "Arvet"-badge på enkelte rader + en "Vis arvede tilganger"-toggle i filter-sidebaren — det bekrefter UI-mønsteret.

### `BRU-APP-API-005` — Administrere ansvarlig (`administrere_ansvarlig.feature`)

**Endringer (commit `a7efc9f`):**

- Ny regel: *"Ansvarlig er obligatorisk og kan ikke fjernes"* med scenario `Lagring avvises når ansvarlig ikke er valgt`.
- Implisitt konsekvens: tidligere regel het *"Ansvarlig kan settes, endres og fjernes"* (med scenario `Fjerne ansvarlig`). Den er nå borte fra filen — fjerning er ikke lenger en støttet operasjon.

**Konsekvens for fs-admin:** Koden har `FjernAnsvarligConfirmDialog.tsx` og `fjernApplikasjonAnsvarligMutation.ts`. Disse må **fjernes** (eller skjules) — UI-knappen "Fjern ansvarlig" i `ApplikasjonInformation.tsx:282-289` er nå et brudd på kravet. Sjekklisten må gjenspeile at obligatorisk-validering må flytte inn i Sett/Endre-flyten.

### `BRU-APP-API-006` — Rediger detaljer (`rediger_detaljer.feature`)

**Tidligere navn:** `rediger_beskrivelse.feature`. Omdøpt i `7ceb640`.

**Endringer (commits `7ceb640`, `a7efc9f`, `e04d704`):**

- Ny regel: *"Redigering av navn krever rettighet over applikasjonens organisasjon"* med 4 scenarier (Oppdatere navn, applikasjonsadministrator i egne org, ikke tilgjengelig i andres org, super-administrator).
- Ny regel: *"Navn er obligatorisk og kan ikke lagres tomt"* med scenario `Lagring avvises når navn er tomt`.
- Ny regel: *"Ulagrede endringer forkastes når brukeren forlater redigeringsvisningen"* med to scenarier:
  - `Forlate siden med ulagrede endringer` (router-navigasjon nullstiller).
  - `Bytte fane med ulagrede endringer` (tab-bytte nullstiller).
- Beholdt regel: *"Redigering av beskrivelse krever rettighet over applikasjonens organisasjon"* (uendret).

**Konsekvens for fs-admin:** Tre store ting:

1. **Navn-redigering eksisterer ikke** — det er ingen mutation `redigerApplikasjonNavn` i schema, ingen `kanRedigereNavn`-felt på `Applikasjon`, ingen UI-knapp. Det er åpenbart at krav-arbeidet ser for seg navn som en redigerbar visningsverdi som ikke nødvendigvis kommer fra idP-en — men det er det ikke i schema-en (`OpprettApplikasjon` lar navnet "hentes fra idP-en" og "være globalt unikt"). Dette er en motsetning som må avklares.
2. **`RedigerBeskrivelseDialog`-mønsteret er feil mønster.** Krav + skisse sier inline rediger-modus med ett samlet "Rediger"-toggle, ikke dialog pr. felt.
3. **Reset-på-navigering** er en discardable-changes-mekanikk som fs-admin ikke håndterer i dag. Dette er en cross-cutting concern (router-event-lytting + tab-event-lytting) som må løses generisk eller komponenten-lokalt.

### `BRU-APP-API-007` — Tildele tilgang (`tildele_tilgang.feature`)

**Endringer (commits `59eba3d`, `4f2e9a4`):**

- Rekkefølge endret: alle scenarier ber nå om at bruker velger **organisasjon → miljø → tilgangskode**, ikke miljø først. Tre scenarier omformulert:
  - `Tildele en tilgang i et valgt miljø` → `Tildele en tilgang i valgt organisasjon og miljø`.
  - `Tildele flere tilganger samtidig i ett valgt miljø` → `Tildele flere tilganger samtidig i valgt organisasjon og miljø`.
  - `Tildele tilgang til en eksisterende FS-applikasjon` → bruker valgt organisasjon + miljø.
- Ny regel: *"Bruker kan kun tildele tilganger de selv har rettighet til å tildele"* har ny scenario `Valglisten for tilgangskode avhenger av valgt organisasjon og miljø` — implementasjons-detaljen om "valglisten viser kun tilganger jeg har rettighet til å tildele" er borte til fordel for den eksplisitte kombinasjons-avhengigheten.
- Endret scenario: `Allerede tildelt tilgang vises som ikke-valgbar` — implementasjonsdetaljen *"gråtonet"* er fjernet (commit-meldingen i `59eba3d`: *"fjern implementasjonsdetalj om gråtone"*).
- Ny regel: *"Tilganger kan tildeles selv om applikasjonen er deaktivert"* (commit `4f2e9a4`).

**Konsekvens for fs-admin:** `TildelTilgangerDialog.tsx` + `tildelbareQuery.ts` er bygget på det gamle mønsteret. To åpne implementerings-spørsmål:

1. **Query for tildelbare tilganger må parametriseres på (orgId, miljø).** I dag tar `GetTildelbareApplikasjonTilganger`-query-en applikasjons-id og returnerer en flat liste. Hvis valglisten avhenger av valgt (org, miljø)-kombinasjon, må enten query-en re-kjøres ved hver org/miljø-endring, eller man henter en fullstendig dataset og filtrerer client-side. Det er en backend-avgjørelse.
2. **Deaktivert-applikasjon-tilfellet** — UI-en må ikke disable tildelings-knappen, men topbar-en bør fortsatt vise status.

### `BRU-APP-API-008` — Fjerne tilgang (`fjerne_tilgang.feature`)

**Endringer (commit `59eba3d` + `4f2e9a4`):**

- **Hele struktureringen er endret.** Tidligere mønster: bekreftelsesdialog pr. enkelt-tilgang (radio-rad-style) + bulk-mønster der man velger flere i listen og bekrefter. Nytt mønster: én samlet modal hvor bruker velger org + miljø + tilganger og bekrefter alle på én gang.
- Ny regel: *"Fjerning av tilganger skjer via modal"* med 3 scenarier (Velge, Bekrefte, Avbryte).
- Bevart: *"Bruker kan kun fjerne tilganger de har rettighet til å fjerne"*.
- Ny regel: *"Tilganger kan fjernes selv om applikasjonen er deaktivert"* (commit `4f2e9a4`).
- Ny regel: *"Arvede tilganger kan ikke fjernes direkte"* (commit `4f2e9a4`).

**Konsekvens for fs-admin:** `FjernTilgangerDialog.tsx` + `FjernValgteTilgangerButton.tsx` er allerede en modal-flyt (Iter 2-tasken endte med bulk-modell), men:

1. **Inngangen er nå "Åpne modal → velg org, miljø, tilganger"**, ikke "Hak av rader i tilgangslisten → bekreft". Skissen `applikasjon-detaljevisning-aktiv-tab-tilganger.png` viser begge knapper i toppen ("+ Tildel tilganger" og "Fjern tilganger") som åpner hver sin modal — det matcher det nye mønsteret.
2. **Listen i tilgangs-fanen skal sannsynligvis ikke ha radio-/sjekkbokser pr. rad lenger** — selection-state forsvinner sammen med det gamle bulk-mønsteret.

### `BRU-APP-API-009` — Opprette applikasjon (`opprette_applikasjon.feature`)

**Endringer (commit `a7efc9f`):**

- Ny regel: *"Opprettelse krever et navn"* (med to scenarier — avvist hvis tomt, lagret hvis fylt inn).
- Ny regel: *"Opprettelse krever en ansvarlig"* (samme mønster).
- Ny regel: *"Nyopprettet applikasjon har status Aktiv"* (eksplisitt — tidligere implisitt).

**Konsekvens for fs-admin:** `OpprettApplikasjonDialog.tsx` må ta inn både navn og ansvarlig som obligatoriske felter. I dag har den `identitetsleverandor` + `eksternId` + `organisasjonsId`, ikke navn (navn hentes fra idP). Dette skaper en spenning med `opprette_applikasjon.feature` Regel: *"Applikasjonen identifiseres av en ekstern ID som verifiseres mot identitetsleverandøren"* der *"navnet på applikasjonen er hentet fra <identitetsleverandør>"*.

**Tolkning som må avklares:** navn-feltet ved opprettelse kan være enten (a) det "globalt unike visningsnavnet" som hentes fra idP-en og som bruker bare ser i en preview-trinn, eller (b) et redigerbart felt som overstyrer idP-navnet. `BRU-APP-API-006`'s navn-redigering antyder (b) — at navn er noe bruker kan endre uavhengig av idP. Da må krav for opprettelse + redigering harmoniseres, og schema-en utvides.

### `BRU-APP-API-010` — Deaktivere (`deaktivere_applikasjon.feature`)

**Ingen endringer** i de listede commitene. Filen ble lagt til på branchen tidligere og er uendret siden Iter 2 ble snappet av.

### Nye filer: Iterasjon 4 + endringslogg

**`endringslogg.feature` (BRU-APP-API-016, `@must @draft`):**

- En ny fane (eller modal?) på detaljsiden som viser hvem som har gjort hva.
- Rettighet styres av administrasjonsrettigheter.
- 4 `@openquestion`-scenarier: hva logges, hva inneholder en loggpost, retention, rekkefølge/paginering/filtrering.

`Iterasjon 4 / systemkrav.md` understreker at iterasjonen *"handler primært om sporbarhet — selve den selvbetjente funksjonaliteten (oversikt over egne applikasjoner, tildele/fjerne tilganger på egne) er allerede dekket av features fra Iterasjon 2 og 3 gjennom rettighetsregler basert på applikasjonsadministrator-rollen."* Det vil si: lokale administratorer kan allerede gjøre alt — det som mangler er audit-loggen.

**Konsekvens for fs-admin:** Et helt nytt domene. Verken schema (`getApplikasjonEndringer`, `ApplikasjonEndring`-type), UI (ny fane eller modal), eller mock-data eksisterer. På grunn av `@draft`-statusen og åpne spørsmål skal dette **ikke** scopes inn i Iter 3-implementasjonen — men det må adresseres som egen plan-runde.

### Nice to have (uendret)

- `BRU-APP-API-015` (sist-brukt) er allerede dekket av `sistBrukt`-feltet i Iter 2-implementasjonen, og rendres i info-fanen (`ApplikasjonInformation.tsx`).
- `BRU-APP-API-017` (masseadministrasjon) er fortsatt `@could @draft` — utenfor scope.

## Current State

### fs-admin etter Iter 2

`docs/ACTIVE-ITERATION-2/` viser 22 fullførte tasks. Live på branch `poc-skills-execute-result` (denne checkout-en). Sentrale komponenter:

- **Routes:** `src/app/tilgangsstyring/applikasjoner/{layout.tsx, page.tsx, [applikasjonId]/{layout.tsx, page.tsx}}`.
- **Listevisning:** `src/domains/support/features/Applikasjoner/{Applikasjoner.tsx, components/{ApplikasjonerFilter.tsx, ApplikasjonerResultList.tsx, ApplikasjonerResultRow.tsx, OpprettApplikasjonButton.tsx, OpprettApplikasjonDialog/, filter/{ApplikasjonerSearchFilter.tsx, ApplikasjonerOrganisasjonFilter.tsx, ApplikasjonerStatusFilter.tsx}}, hooks/{useGetApplikasjoner.tsx, useGetApplikasjonerState.tsx}}`.
- **Detaljside:** `src/domains/support/features/Applikasjon/{Applikasjon.tsx, components/{ApplikasjonTopBar.tsx, ApplikasjonInformation.tsx, ApplikasjonTilganger.tsx, ApplikasjonTilgangerFilter.tsx, ApplikasjonTilgangerResultList.tsx, ApplikasjonTilgangerResultRow.tsx, ApplikasjonTilgangerOrderBy.tsx, tilganger/{ApplikasjonTilgangerMiljoFilter.tsx, ApplikasjonTilgangerTilgangskodeFilter.tsx}}, hooks/{useGetApplikasjon.tsx, useApplikasjonTilganger.tsx, useApplikasjonTilgangerState.tsx}}`.
- **Dialoger (alle eksisterer):** `RedigerBeskrivelseDialog`, `PassordbytteDialog`, `SettAnsvarligDialog`, `FjernAnsvarligConfirmDialog`, `DeaktiverApplikasjonDialog`, `TildelTilgangerDialog`, `FjernTilgangerDialog`, `OpprettApplikasjonDialog`.
- **A11y-tests:** Hver komponent har en `.a11y.test.tsx`. Verifisert via `find`.
- **Mock-API:** `src/mocks/handlers/applikasjoner/{queries.ts, mutations.ts, applikasjoner.verify.ts}`, fixtures i `src/mocks/fixtures/applikasjoner/{applikasjoner.ts, tilganger.ts, organisasjoner.ts, ansvarlige.ts, store.ts}`.

### Schema-typer i dag (`src/__generated__/graphql.ts`)

```text
ApplikasjonerFilterInput { navnContains, organisasjonsIder, status, tilgangskoder }
ApplikasjonerOrderByField { Navn, Organisasjon, SistBrukt, Status }
ApplikasjonTilgangerFilterInput { miljoer, tilgangskoder }
ApplikasjonTilgangerOrderByField { Miljo, Tilgangskode }
Applikasjon { id, navn, beskrivelse, status, miljoer: [Miljo], identitetsleverandor: IdentitetsleverandorType, organisasjon, ansvarlig, opprettet*, endret*, sistBrukt, kan{EndrePassord,AdministrereAnsvarlig,RedigereBeskrivelse,Deaktivere,TildeleTilganger,FjerneTilganger} }
ApplikasjonTilgang { id, tilgangskode, tilgangsbeskrivelse, miljo, organisasjon }
```

Mutations som finnes: `deaktiverApplikasjon`, `reaktiverApplikasjon`, `byttApplikasjonPassord`, `redigerApplikasjonBeskrivelse`, `settApplikasjonAnsvarlig`, `fjernApplikasjonAnsvarlig`, `tildelApplikasjonTilganger`, `fjernApplikasjonTilganger`, `opprettApplikasjon`.

### Skissene (`docs/skisser/`)

Verifisert under analysen:

- `applikasjoner-listevisning.png` — filter-sidebar (Navn / Miljø / Organisasjon / Tilgang / Status), navn+badges+beskrivelse i venstre kolonne, organisasjon, antall-tilganger (eks. "8 tilganger"), status, "Opprett"-knapp øverst til høyre.
- `applikasjon-detaljevisning.png` — `<navn>` som heading, statuschip + miljø-chips + "Organisasjon: NTNU / Ansvarlig: Eli Wold / Antall tilganger: 14" som under-info. "Detaljer"-tab åpen, men i listen vises tilganger (mock-illustrasjon — UI-tilstanden er åpenbart "Tilganger" i denne skissen). "Deaktiver"-knapp øverst til høyre.
- `applikasjon-detaljevisning-aktiv-tab-detaljer-lese-modus.png` / `-rediger-modus.png` — bekrefter inline rediger-toggle for hele detaljer-fanen.
- `applikasjon-detaljevisning-aktiv-tab-tilganger.png` — sidebar (Tilgangskode-fritekstfilter, Miljø, Organisasjon, Tilknytning, "Vis arvede tilganger"-toggle), 14-rads tilgangsliste hvor noen rader har "Arvet"-badge (med "Tilgangen er arvet fra «emne-skriv1»…" som beskrivelse). Topp-actions: "+ Tildel tilganger", "Fjern tilganger", "Tilgangskode" sort.

## Key Findings

1. **Iter 2 + 3 ble levert mot tidligere krav, og 4 av 6 features er nå strukturelt endret.** Beskrivelse/redigering, tildeling, fjerning, og tilgangs-listing må bygges om — ikke bare utvides. Spesielt rediger-flyten skifter fra "knapp pr. felt → dialog" til "én rediger-toggle → inline inputs".
2. **`rediger_beskrivelse.feature` er fjernet og erstattet av `rediger_detaljer.feature`** med utvidet scope (navn). Hvis det er en eksisterende symlink/referanse til den gamle filen i kodebasen eller i en åpen PR-beskrivelse, må den fanges opp.
3. **`Fjern ansvarlig`-flyten er gone.** Eksisterende kode (`FjernAnsvarligConfirmDialog`, `fjernApplikasjonAnsvarlig`-mutation, knapp i `ApplikasjonInformation.tsx:282-289`) reflekterer ikke det nye kravet.
4. **Arv av tilganger er nytt vokabular.** Verken backend-schema, frontend-modeller eller mock-data har dette. Behandlingen av arv (merking, dedup, vis/skjul-toggle) krever en samordnet endring på alle tre lag.
5. **Org→miljø→tilgangskode-kaskaden i tildelings-flyten** krever enten en parametrisert query (`tildelbareApplikasjonTilganger(orgId, miljo)`) eller at hele datasettet hentes og filtreres client-side. Det er backend-avgjørelse.
6. **"Antall tilganger" som listefelt** finnes ikke som felt på `Applikasjon`-typen i dag — backend må eksponere det (enten som `applikasjon.tilganger.totalCount` aggregert eller som et eget skalarfelt).
7. **Miljø-filter på applikasjonslisten** mangler både i schema (`ApplikasjonerFilterInput` har ikke `miljoer`) og i UI (`ApplikasjonerFilter.tsx`).
8. **Endringslogg (BRU-APP-API-016) er nytt domene.** Krav-en er `@draft` med åpne spørsmål — passer ikke for implementasjon ennå, men `bat-plan` skal gjøre eksplisitt avgjørelse om scoping.
9. **Discardable-changes-mekanikk** (`e04d704`) er en cross-cutting concern fs-admin ikke har et mønster for i dag — verken router-blocker eller tab-change-guard er i bruk i andre rediger-flyter.
10. **Navn-feltets natur er motstridende mellom features.** `opprette_applikasjon.feature` sier navnet hentes fra idP-en og må være globalt unikt; `rediger_detaljer.feature` sier brukere med rett rolle kan oppdatere navnet. Kombinasjonen krever (a) avklaring, og (b) sannsynligvis et schema-skille mellom *idP-navn/visningsnavn* og *bruker-overstyrt navn*.

## Technical Constraints

- **Backend-eierskap:** Schema-endringene under (miljø-filter, antallTilganger, arv-modell, organisasjons-filter i tilgangsliste, navn-redigerings-mutation, endringslogg-query) ligger hos backend-agent — se `Dependencies` under. Frontend kan parallellisere via mock-API (allerede gjort i Iter 2; samme mønster).
- **CLAUDE.md-krav på testing:** Hver ny komponent eller endret komponent må fortsatt ha `.a11y.test.tsx`. Endringer i `ApplikasjonInformation`, `ApplikasjonTilganger` osv. krever sannsynligvis at testene oppdateres for ny edit-modus + arv-badges.
- **`fs-admin-detail-pages`-skill:** Inline rediger-modus i info-fanen må følge `DetailPageLayout`-familien. Hvis arvede tilganger får skjul-/vis-toggle, plasser den i tilgangs-tabens filter-sidebar (jf. `fs-admin-list-filters`).
- **`fs-admin-list-filters`-skill:** Miljø-filter og organisasjons-filter på henholdsvis listevisningen og tilgangslisten må følge `FilterWrapper` + `renderAsChips`-kontrakten.
- **`graphql-consumer`-skill:** Nye fragments (rediger-modus-felter, arv-felter, antallTilganger) må colocaters med komponentene som leser dem. Ikke utvid eksisterende fragments med felter som bare brukes i rediger-modus.
- **i18n:** Norsk-eneste; nye strenger må legges til `src/messages/nb/support.json` med eksisterende `support.Applikasjon*`-namespacing-konvensjon.
- **Feature-flag:** `tilgangsstyring-meny`-flagget gating-modellen fra Iter 2 antas å gjelde fortsatt — verifiser i `src/features/Header/Menu/Menu.tsx` før plan-fasen.

## Dependencies

### Internal

- **`ApplikasjonInformation`** (info-fanen): omskrives fra dialog-knapper til inline rediger-modus. Bidrar til `RedigerBeskrivelseDialog`-fjerning og ny `kanRedigereNavn`-gating.
- **`ApplikasjonTilganger`** + alle underkomponenter: utvidet med organisasjons-filter, tilgangskode-fritekstfilter, arv-merking, dedup-håndtering, "vis/skjul arvede"-toggle.
- **`ApplikasjonerFilter`** + `useGetApplikasjonerState`: miljø-filter lagt til.
- **`ApplikasjonerResultRow`**: "Antall tilganger"-felt lagt til.
- **`FjernTilgangerDialog`**: omstrukturert til "velg org + miljø + tilganger inni modalen", ikke "hak av rader → bekreft".
- **`TildelTilgangerDialog`**: kaskaderende org→miljø→tilgangskode-state, valgliste avhengig av kombinasjon, deaktivert-applikasjon-tilfellet.
- **`OpprettApplikasjonDialog`**: navn + ansvarlig som obligatoriske felter, validering.
- **Mock-API**: alle fixtures + handlers oppdateres for nye felter (`antallTilganger`, `miljoer`-filter, `tilgangskode`-fritekst, arv-relasjoner). Aktivt teardown-friendly mønster siden Iter 2.

### External

- **Backend / SuperGraf-agent (`sikt-no/fs`):** schema-endringer som krever koordinasjon. Ikke filed her — er candidates til `bat-plan` å løfte etter at planen er konkretisert. Se cross-agent-seksjonen.
- **Sikt Design System:** ingen nye komponenter forventet — `TagStatus` med ny variant for "Arvet"-badge holder.
- **Apollo Client 4:** ingen nye krav; eksisterende `useFragment` + `useQuery`-mønster fra Iter 2 dekker.
- **`next-intl`:** norsk-oversettelser for nye strenger.

### Cross-agent

> Disse er *kandidater* per `bat-analyze`-konvensjonen — selve hand-off-issuene filer `bat-plan` etter at planen er på plass og det konkrete behovet er artikulert.

1. **Backend / SuperGraf-schema-agent — Iter 3+ schema-utvidelser:**
   - `ApplikasjonerFilterInput.miljoer: [Miljo!]` (miljø-filter på listen).
   - `Applikasjon.antallTilganger: Int!` eller `applikasjon.tilganger.totalCount` synlig på liste-rad (uten å hente full liste).
   - `ApplikasjonTilgangerFilterInput.organisasjonsIder: [ID!]` + endret `tilgangskoder` til fritekst-match (eller separat `tilgangskodeContains: String`).
   - Arv-modellen: `ApplikasjonTilgang.arvetFra: [ApplikasjonTilgang!]` (eller dual-felt med opphav + dedup-håndtering).
   - `redigerApplikasjonNavn`-mutation eller utvidet `redigerApplikasjonBeskrivelse → redigerApplikasjonDetaljer` med både navn og beskrivelse.
   - `kanRedigereNavn: Boolean!`-felt (eller utvide `kanRedigereBeskrivelse` til `kanRedigereDetaljer`).
   - `TildelbareApplikasjonTilganger(orgId, miljo)`-parametrisering.
   - Avklare *visningsnavn fra idP* vs *bruker-overstyrt navn* i `OpprettApplikasjon` + `Applikasjon`-typen.
   - **`@must @draft` Endringslogg-domenet:** ny `ApplikasjonEndring`-type, `Applikasjon.endringer`-relasjon eller egen query, retention-modell. Trenger først at åpne spørsmål er besvart.
2. **Backend / autentiserings-agent — `Fjern ansvarlig`-mutation deprecation:** mutation eksisterer fortsatt, må flagges som deprecated/fjernes når UI-koden er borte.
3. **Krav-arbeid / produkt-eier:**
   - Avklare navn-feltets natur (idP-navn vs. visningsnavn vs. bruker-overstyrt).
   - Lukke 4 `@openquestion` på endringslogg.
   - Bekrefte at iterasjon-4 endringslogg skal være en egen fane i `DetailPageTabbedContent` (eller en seksjon i info-fanen, eller en egen route).

## Requirements Impact

| Requirement                                            | Status etter Iter 2-impl | Påvirkning fra ny krav-versjon                                                                                       |
| ------------------------------------------------------ | ------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| BRU-APP-API-001 Listevisning og søk                    | Implementert             | Nytt listefelt (antallTilganger) + nytt filter (miljø)                                                               |
| BRU-APP-API-002 Se detaljer                            | Implementert             | Inline rediger-toggle erstatter dialog-mønster; idP/org/status synlige felter i info-fanen                          |
| BRU-APP-API-003 Vise tilganger                         | Implementert             | Tre nye filter (org, tilgangskode-fritekst), arv-håndtering (badge, dedup, toggle), beskrivelse + organisasjon i raden |
| BRU-APP-API-004 Passordbytte                           | Implementert             | Ingen endring                                                                                                        |
| BRU-APP-API-005 Administrere ansvarlig                 | Implementert             | Obligatorisk-validering + `Fjern ansvarlig`-flyten fjernes                                                           |
| BRU-APP-API-006 Rediger detaljer                       | Delvis (kun beskrivelse) | Navn-redigering ny; ulagrede-endringer-reset ny; rediger-modus inline                                                |
| BRU-APP-API-007 Tildele tilgang                        | Implementert             | Kaskade org→miljø→tilgangskode; tildele til deaktivert applikasjon                                                  |
| BRU-APP-API-008 Fjerne tilgang                         | Implementert (bulk)      | Strukturelt endret — fjerning skjer via samlet modal; arvede tilganger ikke fjernbare; fjerne fra deaktivert applikasjon |
| BRU-APP-API-009 Opprette applikasjon                   | Implementert             | Navn + ansvarlig obligatoriske; "status Aktiv" eksplisitt                                                            |
| BRU-APP-API-010 Deaktivere                             | Implementert             | Ingen endring                                                                                                        |
| BRU-APP-API-015 Sist brukt                             | Implementert (info-fane) | Ingen endring                                                                                                        |
| BRU-APP-API-016 Endringslogg                           | **Ny — ikke startet**    | `@must @draft` med 4 åpne spørsmål. Iter 4-scope.                                                                    |
| BRU-APP-API-017 Masseadministrasjon                    | Ikke startet             | Ingen endring (`@could @draft`)                                                                                      |

## Krav-input fra GitHub

- **Kilde-issue:** [#31](https://github.com/sikt-no/fs/issues/31) (initiativ)
- **Sub-issues i scope:** [#434](https://github.com/sikt-no/fs/issues/434) (Iter 2), [#435](https://github.com/sikt-no/fs/issues/435) (Iter 3), [#437](https://github.com/sikt-no/fs/issues/437) (Nice to have), pluss Iter 4 / [#453](https://github.com/sikt-no/fs/issues/453) (endringslogg) som er ny i scope.
- **Repo / branch:** `sikt-no/fs` @ `fruitbat` (branch hentet fra initiativets `linkedBranches`).
- **Branch-SHA ved henting:** [`8f5e0bddedf7c5731722c5fc80159a95db197909`](https://github.com/sikt-no/fs/commit/8f5e0bddedf7c5731722c5fc80159a95db197909)
- **Main-SHA ved henting:** [`8b4bc23612666cb3460d02b8738915c65712e448`](https://github.com/sikt-no/fs/commit/8b4bc23612666cb3460d02b8738915c65712e448) (alle krav-filer er `status: added` mot main — diffingen er gjort mot snapshot i `docs/ACTIVE-ITERATION-2/krav-input/`)
- **Hentede `.feature`-filer:** se [`krav-input/manifest.md`](krav-input/manifest.md) og [`krav-input/fruitbat/...`](krav-input/fruitbat/).
- **Hentet:** 2026-05-28

## Open Questions

- [ ] **Navn-feltets natur:** er navnet på en applikasjon (a) hentet eksklusivt fra idP-en og uforanderlig fra fs-admin, (b) initialt hentet fra idP-en men kan overstyres av bruker, eller (c) helt uavhengig av idP-en? `opprette_applikasjon.feature` antyder (a); `rediger_detaljer.feature` antyder (b) eller (c). Krever produkt-eier-avklaring før `bat-plan` kan utforme rediger-flyten.
- [ ] **`antallTilganger`-feltet:** er det fornuftig som direkte felt på `Applikasjon` (cache-effektivt på listen), eller skal man bruke `applikasjon.tilganger.totalCount` (consistency med pagination-konvensjonen)? Backend-avgjørelse, men har konsekvens for cache-invalidering ved tildel/fjern-mutasjoner.
- [ ] **Tildelbare-tilganger-query: parametrisert eller pre-loaded?** Krav-en sier *"vises kun tilgangskoder jeg har rettighet til å tildele for den valgte kombinasjonen av organisasjon og miljø"* — backend må enten støtte `tildelbareApplikasjonTilganger(orgId, miljo)` eller eksponere full matrise og la client filtrere.
- [ ] **Arv-modellen:** schema-formen for "arvet tilgang" må defineres — er det en `arvetFra: [ApplikasjonTilgang!]`-self-relasjon på `ApplikasjonTilgang`, eller en separat type? Krav-en antyder mange-til-én (én arvet kan ha flere opphav).
- [ ] **Endringslogg-scope (BRU-APP-API-016):** skal Iter 3-planen inkludere stub for endringslogg-fanen, eller utsettes hele til en separat Iter 4-plan? `@draft` taler for å vente; tab-strukturen kan likevel forberedes.
- [ ] **`Fjern ansvarlig`-mutation deprecation:** skal mutationen og dialogen fjernes umiddelbart, eller bevares som "skjult" inntil backend bekrefter at intet eksternt avhenger av mutationen?
- [ ] **Endringslogg som fane vs. som side-modal:** `Iterasjon 4 / systemkrav.md` sier *"åpnes endringsloggen på detaljsiden"* — uavklart om dette er en fane (jf. eksisterende "Detaljer | Tilganger") eller en knapp som åpner modal/seksjon.
- [ ] **Discardable-changes-mekanikk:** trenger fs-admin et generelt mønster (router-blocker + tab-bytte-guard) eller skal det implementeres komponent-lokalt for rediger-detaljer-fanen? Påvirker andre rediger-flyter på sikt.
