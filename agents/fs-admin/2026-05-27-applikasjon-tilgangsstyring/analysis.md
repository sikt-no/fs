# Analysis (delta): Applikasjon-tilgangsstyring — Iteration 2

> **Scope:** Iter-2-runde av initiativ [#31](https://github.com/sikt-no/fs/issues/31). Dette dokumentet beskriver **bare deltaen** mellom iteration 1 (snapshot i [`docs/ACTIVE-ITERATION-2/`](../ACTIVE-ITERATION-2/)) og det oppdaterte krav-/skisse-grunnlaget per 2026-05-27. Punkter som er uendret er **ikke** gjentatt — referer til [`analysis-applikasjon-tilgangsstyring.md`](../ACTIVE-ITERATION-2/analysis-applikasjon-tilgangsstyring.md) i ACTIVE-ITERATION-2 for full kontekst.
>
> **Read-only:** løsning og task-bryting hører hjemme i `bat-plan`. Denne kjøringen bekrefter at iter-1-analysens hovedlinjer (POC-fjerning, `useDataListState`, `MigrerPassordDialog`-mønster, tre-akse permission-modell) fortsatt gjelder, og kartlegger **bare** det som er endret.
>
> **Sub-issues i scope (uendret som mengde, men #453 ny i kart):** [#434](https://github.com/sikt-no/fs/issues/434), [#435](https://github.com/sikt-no/fs/issues/435), [#437](https://github.com/sikt-no/fs/issues/437), [#453](https://github.com/sikt-no/fs/issues/453). Se [`krav-input/manifest.md`](krav-input/manifest.md) for full diff-tabell.

## Problem Statement (delta)

Iter-1-analysen tegnet applikasjons-administrasjon som en _rebuild_ av maskinbruker-POC-en med tre konkrete leveranser (Iter 2 / Iter 3 / Nice to have). Iter 2-runden endrer **ikke** dette bildet, men:

1. **Krav-arkitekturen har fått en ny iterasjon 4** ("Grunnleggende selvbetjent administrasjon") med ett `@must @draft`-feature `BRU-APP-API-016 Endringslogg` — _ikke_ et tillegg under "Nice to have", men en egen `@must`-iterasjon. GitHub-strukturen henger etter: #453 har fortsatt `parent = #437` (Nice to have) selv om kravfilen ligger i `03 Iterasjon 4/`.
2. **UX-detaljeringen for detaljsiden har skiftet fra en abstrakt "rediger beskrivelse"-flyt til en konkret lese↔rediger-toggle på Detaljer-fanen** — dokumentert i tre nye skisser ([`skisser/applikasjon-detaljevisning-aktiv-tab-detaljer-lese-modus.png`](skisser/applikasjon-detaljevisning-aktiv-tab-detaljer-lese-modus.png), [`skisser/applikasjon-detaljevisning-aktiv-tab-detaljer-rediger-modus.png`](skisser/applikasjon-detaljevisning-aktiv-tab-detaljer-rediger-modus.png), [`skisser/applikasjon-detaljevisning-aktiv-tab-tilganger.png`](skisser/applikasjon-detaljevisning-aktiv-tab-tilganger.png)). Det utløser også en omdøping av kravfila (`rediger_beskrivelse.feature` → `rediger_detaljer.feature`).
3. **`fjerne_tilgang`-flyten er omarbeidet** fra per-rad-fjerning + bekreftelsesdialog til en **bulk-fjern-modal** (organisasjon + miljø + multi-select i modalen).
4. **`tildele_tilgang`** krever nå alltid et eksplisitt `(organisasjon, miljø)`-par; tildelings-valglister filtreres per kombinasjon.

Alt øvrig — POC-fjerning, `MigrerPassordDialog`-mønsteret, tre-akse synlighetsmodell, identitetsleverandør-modell, paginering, side-om-side-utfasing — er bekreftet uendret.

## Current State (delta)

### Skisser (nye)

Iter 2 introduserer tre konkrete skisser av detaljsiden + beholder de to fra iter 1:

| Skisse                                                                                                                            | Innhold                                                                                                                                                                                                                                                                |
| --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`applikasjon-detaljevisning-aktiv-tab-detaljer-lese-modus.png`](skisser/applikasjon-detaljevisning-aktiv-tab-detaljer-lese-modus.png) | Detaljer-fanen, _lese-modus_. Single `Surface`-seksjon med felter i 5-kolonners rutenett: rad 1 (Navn, Beskrivelse, Organisasjon, Opprettet av, Sist endret av), rad 2 (Status-tag, Ansvarlig, Tidspunkt for opprettelse), rad 3 (Miljø-tags, Identitetsleverandør, Tidspunkt for sist endring). En enslig **Rediger**-knapp i seksjonshodet. |
| [`applikasjon-detaljevisning-aktiv-tab-detaljer-rediger-modus.png`](skisser/applikasjon-detaljevisning-aktiv-tab-detaljer-rediger-modus.png) | Samme seksjon i _rediger-modus_. Navn → `TextInput`, Beskrivelse → `TextArea`, Ansvarlig → `Select/Combobox`. Status, Miljø, Organisasjon, Identitetsleverandør, Opprettet av/sist endret av og tidspunktene forblir lese-felter. **Avbryt + Lagre** i stedet for Rediger. |
| [`applikasjon-detaljevisning-aktiv-tab-tilganger.png`](skisser/applikasjon-detaljevisning-aktiv-tab-tilganger.png)               | Tilganger-fanen, fullstendig. Filter-sidebar (`Tilgangskode`-fritekst, `Miljø`-select, `Organisasjon`-select, `Tilknytning`-select), resultatliste 14/14 tilganger, `+ Tildel tilganger` og `- Fjern tilganger` i top-right, sort-dropdown `Tilgangskode`. Rader viser tilgangskode + Demo/Prod-tags + evt. `Arvet`-merke, beskrivelse, og organisasjon. |
| [`applikasjon-detaljevisning.png`](skisser/applikasjon-detaljevisning.png)                                                        | _Iter-1-skisse, beholdt._ Annotert utgave av tilgangs-tabben med UX-spørsmål. Erstattes effektivt av de tre nye, men beholdes for sporbarhet.                                                                                                                                            |
| [`applikasjoner-listevisning.png`](skisser/applikasjoner-listevisning.png)                                                        | _Iter-1-skisse, beholdt._ Ingen endring i listevisningen — men selve krav-filen `listevisning_og_sok.feature` _har_ små endringer (Antall tilganger-kolonne + miljø-filter). Skissen er litt utdatert ift. krav-teksten, men strukturen stemmer.                                            |

**TopBar-kontrakt fra skissene (uendret på tvers av alle tre detalj-skissene):**

```
Status: <tag>   Miljø: <Demo> <Prod>   Organisasjon: <navn>   Ansvarlig: <navn>   Antall tilganger: <n>      [Deaktiver]
```

Det stadfester at TopBar er **felles for alle tabs** og at deaktiver-aksjonen ligger der (ikke inne i Detaljer-seksjonen). Iter-1-analysen hadde dette som hypotese; nå er det dokumentert.

### Krav-endringer per feature

Full diff-tabell ligger i [`krav-input/manifest.md`](krav-input/manifest.md). Hovedsubstansen:

#### `rediger_detaljer.feature` (erstatter `rediger_beskrivelse.feature`)

- Samme feature-ID `BRU-APP-API-006`, samme GitHub-issue `#443`, samme Confluence-K `K19`.
- Dekker nå **navn _og_ beskrivelse i ett feature** (i tråd med skissens combined edit-form).
- Nye regler:
  - "**Navn er obligatorisk og kan ikke lagres tomt**" — feilmelding "navn er obligatorisk".
  - "**Ulagrede endringer forkastes når brukeren forlater redigeringsvisningen**" — to scenarier: (a) navigere bort fra siden, (b) bytte fane. _"Så nullstilles siden / redigeringsvisningen til sin forrige lagrede tilstand"_.
- Rettighetsreglene er duplisert for `navn` og `beskrivelse` (samme tre-akse: applikasjonsadministrator over egen org / super-admin / annen org = ikke tilgang).

#### `administrere_ansvarlig.feature`

- Regel "Ansvarlig kan settes, endres og fjernes" → "**Ansvarlig kan settes og endres, men ikke fjernes**".
- Scenariet "Fjerne ansvarlig" fjernet; erstattet av "**Lagring avvises når ansvarlig ikke er valgt**" som del av en ny regel "Ansvarlig er obligatorisk og kan ikke fjernes".
- Søk-avgrensning og felde-bruker/-gruppe-valg er uendret.

#### `listevisning_og_sok.feature`

- Listeradene viser nå en **ny kolonne `Antall tilganger`** mellom Organisasjon og Status.
- Nytt scenario "**Filtrere på miljø**" (var ikke i iter-1-versjonen).
- Sortering, organisasjon-filter, tilgang-filter, status-filter, fritekst-søk: uendret.

#### `se_detaljer.feature`

- Nye scenarier:
  - **Se identitetsleverandør** ("Så ser jeg applikasjonens identitetsleverandør").
  - **Se organisasjon**.
  - **Se status** ("aktiv eller deaktivert").
- Ny regel "**Detaljer kan redigeres direkte fra detaljer-fanen**" med scenariet "Aktivere redigering av detaljer" — _"Når jeg velger å redigere / Så blir alle redigerbare felter i detaljer-fanen omgjort til inputfelter"_. Det er kontrakts-grunnlaget for in-place edit-mode.

#### `vise_tilganger.feature`

- Listeradene viser nå **fire datapunkter** (tilgangskode + beskrivelse + organisasjon + miljø), ikke bare to (tilgangskode + miljø). Stemmer med skissens fire kolonner.
- Filterne har skiftet: "filtrere på tilgang" → "**filtrere på organisasjon**" + "**filtrere på tilgangskode (fritekst)**". Stemmer med skissens fire filtre (`Tilgangskode`-fritekst, `Miljø`, `Organisasjon`, `Tilknytning`). _Merknad:_ `Tilknytning`-filteret i skissen har **ikke** et tilsvarende eksplisitt scenario i krav-teksten — kan være forhåndsvalg/tilstand for "Vis alle/Bare egne/Bare arvede" eller en utvidelse — flagget som åpent spørsmål.
- Sortering simplifisert til kun `tilgangskode` (var `miljø eller tilgangskode`).
- **Ny regel "Arvede tilganger kan skjules fra listen"** med fire scenarier:
  - "Arvet tilgang er merket med opphav" — visuelt merke + opphavs-tekst.
  - "Arvet tilgang med flere opphav listes kun én gang" — backend må deduplisere.
  - "Skjule arvede tilganger".
  - "Vise arvede tilganger".

#### `tildele_tilgang.feature` (Iter 3)

- **Tildeling krever nå alltid en eksplisitt `(organisasjon, miljø)`-kombinasjon**. Tidligere kunne org leses av kontekst; nå er det et krav i selve flyten.
- Valglisten for tilgangskode er gjort avhengig av valgt org+miljø: _"Valglisten for tilgangskode avhenger av valgt organisasjon og miljø"_.
- Allerede tildelte tilganger vises som **ikke valgbare** (var "gråtonet og ikke valgbar" — kosmetisk endring).
- **Ny regel "Tilganger kan tildeles selv om applikasjonen er deaktivert"** — `ApplikasjonStatus = INAKTIV` blokkerer ikke tildeling.

#### `fjerne_tilgang.feature` (Iter 3) — **strukturelt omarbeidet**

- Iter-1-formen var "per-rad-fjern → bekreftelsesdialog → confirm". Iter-2-formen er en **bulk-fjern-modal**:
  - "**Velge tilganger å fjerne**": åpne modal → velge org + miljø → se liste over tilganger jeg har rettighet til å fjerne for kombinasjonen → multi-select i modalen.
  - "**Bekrefte fjerning av valgte tilganger**": en confirm fjerner alle valgte i den valgte org+miljø-kombinasjonen samtidig.
  - "**Avbryte fjerning**": lukke modalen uten endring.
- Bekreftelsesdialog-konseptet (iter-1s "Regel: En fjerning krever en eksplisitt bekreftelse" + "Regel: Flere tilganger i ett miljø kan fjernes samtidig") er erstattet av modalens egen Bekreft-knapp.
- **Ny regel "Tilganger kan fjernes selv om applikasjonen er deaktivert"**.
- **Ny regel "Arvede tilganger kan ikke fjernes direkte"** — koblet til den nye `vise_tilganger.feature`-arv-modellen.

#### `opprette_applikasjon.feature` (Iter 3)

- **Ny regel "Opprettelse krever et navn"** (obligatorisk + scenariet "Navn lagres ved opprettelse"). Navnet er separat fra det globalt-unike `visningsnavn` som hentes fra idP-en — det vil si det finnes to navne-konsepter: idP-visningsnavn (autoritativt fra Feide/Maskinporten ved opprettelse) og applikasjons-navn (brukerredigerbart i `rediger_detaljer`). _Flagget som åpent spørsmål._
- **Ny regel "Opprettelse krever en ansvarlig"** — obligatorisk ved opprettelse, og ansvarlig forblir obligatorisk gjennom livssyklusen (jf. `administrere_ansvarlig`-endringen). Det betyr at applikasjoner som ikke har ansvarlig i dag (eksisterende FS-applikasjoner?) må håndteres som migrasjons-edge-case. _Flagget som åpent spørsmål._
- **Ny regel "Nyopprettet applikasjon har status Aktiv"** — `ApplikasjonStatus = AKTIV` som default.

#### `03 Iterasjon 4/endringslogg.feature` + `systemkrav.md` (**net-ny**)

- `BRU-APP-API-016 @must @draft` → GitHub-issue [#453](https://github.com/sikt-no/fs/issues/453).
- **Tre konkrete scenarier (rettighet)**:
  - Applikasjonsadministrator ser endringslogg for applikasjoner i egne organisasjoner.
  - Endringslogg er ikke tilgjengelig uten administrasjonsrettigheter.
  - Super-applikasjonsadministrator ser endringslogg for alle applikasjoner.
- **Fire `@openquestion`-scenarier** (åpne for kravarbeidet):
  - Hva som skal logges (alle administrative handlinger vs. kun sensitive; autentiseringshistorikk i samme logg eller separat).
  - Hva en loggpost inneholder (hvem/tid/type vs. også før/etter-verdier; håndtering av sensitive felter som passord).
  - Retention (evig / tidsbegrenset / plattform-policy).
  - Rekkefølge, paginering, filtrering (50-paginering, filter på type/person).
- `systemkrav.md` er eksplisitt på at iter 4 _ikke_ leverer egne K11-K14-features — disse er allerede dekket av rettighetsregler i `BRU-APP-API-001` / `-007` / `-008` (listevisning, tildele, fjerne). Iter-4-verdien er **sporbarhet**, ikke ny selvbetjent funksjonalitet.

### GitHub-struktur vs krav-struktur (delta)

- Sub-issues på #31: fortsatt #434, #435, #437 — **#453 er nytt issue, men `parent = #437`** (Nice to have). Krav-arkivet plasserer det derimot i "Iterasjon 4 — Grunnleggende selvbetjent administrasjon" med `@must`-prioritet.
- Det er en strukturell uoverensstemmelse mellom GitHub og krav-arkivet. `bat-krav` (ikke denne skillen) er det rette stedet for å avklare om #453 skal flyttes til et nytt #--456-iterasjon-4-paraply-issue.
- Iter-1-analysen forutså ikke #453. Den må legges til i scope eksplisitt.

## Key Findings (delta)

1. **Lese↔rediger-toggle på Detaljer-fanen er den sentrale UX-endringen.** Iter 1 modellerte navn-/beskrivelse-/ansvarlig-redigering som tre separate dialoger; iter 2 samler dem i én in-place edit-form på selve Detaljer-fanen med felles Avbryt/Lagre. **Reference-implementasjon i fs-admin er entydig**:
   - `src/common/components/inputs/ViewEditTextField/`, `ViewEditTextArea/`, `ViewEditSelect/` — alle tar `edit: boolean` og rendrer enten input eller `ReadOnlyTextField`.
   - `src/domains/opptak/features/OpptakManagement/OpptakSettings/OpptakSettings.tsx` — `editMode: boolean`-prop med samme fieldset, brukt av parent `OpptakManagementPage.tsx` som eier `editMode`-state og Rediger/Avbryt/Lagre-knappene.
   - Krav-regelen "ulagrede endringer forkastes ved navigasjon/tab-bytte" faller ut gratis hvis `editMode` er **lokal `useState` på Detaljer-fane-komponenten** (ikke URL-state). Lokal state dør med ruten.

2. **Bulk-fjern-modal har en eksisterende parallell i samme feature-mappe.** `src/domains/support/features/Applikasjon/components/TildelTilgangerDialog/` (fra tidligere POC-arbeid eller forberedt arbeid på `fruitbat`-branchen) implementerer allerede "modal opens → user picks org+miljø → candidate list narrows → multi-select → bulk mutate"-flyten. **Ny `FjernTilgangerDialog/` bygges parallelt** (samme filstruktur: `Button.tsx`, `Dialog.tsx`, `query.ts` for kandidater, `mutation.ts` for bulk-mutasjon). Ingen ny generell bulk-modal-abstraksjon trengs.

3. **Endringslogg-mønsteret eksisterer allerede i fs-admin.** `src/domains/soknadsbehandling/features/AuditLogCard/AuditLogCard.tsx` har en `endringslogg(first, after)`-Relay-connection-viewer med `AuditLogItem`-rader, hostet som en `Surface`-card med load-more (`fetchMore`-paginering — `INITIAL_ENTRIES = 3`, `ENTRIES_PER_PAGE = 10`, justerbart til 50 om kravene konkluderer slik). Ny `Applikasjon`-endringslogg gjenbruker formen, ikke koden — det er et nytt domene, ny query, ny `AuditLogItem`-variant.

4. **Arvede tilganger er datamodell + visuell dekorasjon, ikke en ny komponent.** Sketch + krav-tekst forutsetter at backend leverer arv-relasjoner og at hver tilgang-rad har en valgfri `Arvet`-`Tag` og opphavs-tekst. Skjul/vis-toggle er en `ToggleSwitch` over resultatlisten, URL-synket via `useDataListState`/`nuqs` som de andre filtrene. Backend må deduplisere (krav: "Arvet tilgang med flere opphav listes kun én gang").

5. **Tildelings-/fjernings-mutasjonene må nå alltid ta `(organisasjon, miljø)` som tuple.** Iter-1-Q7 besluttet "én atomic bulk-mutasjon med `tilgangIds: [ID!]!`". Det er fortsatt riktig, men inputen blir `tildelApplikasjonTilganger(input: { applikasjonId, organisasjonsId, miljoId, tilgangskoder: [String!]! })` og `fjernApplikasjonTilganger(input: { applikasjonId, organisasjonsId, miljoId, tilgangIds: [ID!]! })`. Schema-skissen i [`api-spec-applikasjon-tilgangsstyring.md` (iter 1)](../ACTIVE-ITERATION-2/api-spec-applikasjon-tilgangsstyring.md) må oppdateres tilsvarende av backend-agenten.

6. **Status `AKTIV/INAKTIV` blokkerer ikke tildeling/fjerning av tilganger.** Iter-1-analysens beslutning Q8 ("Deaktivering = `ApplikasjonStatus`-flagg, tilganger uberørte ved deaktivering") er bekreftet og utvidet: tilgangs-mutasjoner kan utføres mens applikasjonen er INAKTIV. Det betyr at deaktivert-tilstand kun stenger _autentisering_, ikke _administrasjon_.

7. **To navne-konsepter på applikasjonen er nå eksplisitt.** `opprette_applikasjon` opererer fortsatt med _visningsnavn_ hentet fra idP-en (globalt unikt, ikke brukerredigerbart). `rediger_detaljer` introduserer et brukerredigerbart _navn_. Det er minst tre tolkninger:
   - (a) Visningsnavn = idP-autoritativt, applikasjons-navn = en valgfri alias overstyrt i FS Admin.
   - (b) Visningsnavn = initielt sourced fra idP, så brukerredigerbart deretter (vil bryte regel om global unikhet).
   - (c) To separate felter (visningsnavn fra idP, navn for intern bruk).
   - **Flagget som åpent spørsmål.** Backend må klargjøre — det er en datamodell-beslutning, ikke en UI-beslutning.

8. **Ansvarlig er nå obligatorisk gjennom hele livssyklusen.** Iter-1-modellen tillot at en applikasjon kunne være "ansvarsløs". Iter-2-krav nekter dette (både ved opprettelse og i `administrere_ansvarlig`). For eksisterende FS-applikasjoner som per definisjon ikke har en ansvarlig registrert i FS-Admin-domenet, må migrasjon enten (a) tvangs-velge en ansvarlig som del av førstemøtet med ny UI, eller (b) backend leverer en initiell ansvarlig basert på legacy-data. **Flagget som åpent spørsmål.**

9. **`Tilknytning`-filteret i tilgangs-skissen mangler krav-dekning.** Skissen viser et filter `Tilknytning` med default "Alle tilknytninger". `vise_tilganger.feature` har et "skjul arvede"-toggle men ingen "tilknytnings"-konsept som scenario. Antagelse: `Tilknytning` ≈ "direkte tildelt / arvet / begge", altså _samme_ konsept som "skjul arvede"-toggle representert som et select-filter. Det betyr én av sketch og krav er litt foran/bak den andre. **Avklares før implementering.**

## Technical Constraints (delta)

Iter-1-CLAUDE.md-beskrankningene gjelder uendret. Spesifikke ny-konsekvenser av iter-2-deltaen:

- **Ingen URL-state for editMode på Detaljer-fanen.** Krav-regel "ulagrede endringer forkastes ved navigasjon" forutsetter at editMode lever i lokal `useState`, ikke `nuqs`. Det avviker fra det generelle prinsippet "filter/sort/paginering = URL-state" — men er korrekt fordi editMode er en _arbeidssesjon-modus_, ikke et delbart view-state. Kravet om at fane-bytte også forkaster endringer betyr at `DetailPageTabbedContent`-tab-switcher må trigge en unmount eller eksplisitt `cancelEdit`. _Verifisere oppførsel mot `DetailPageTabbedContentPanel`-implementasjonen i `bat-plan`._
- **Bulk-modaler bør ikke gjenbruke `useDataListState`.** Kandidat-tilgangs-listen inne i `FjernTilgangerDialog` er midlertidig modal-state (multi-select-checkboxene) og forkastes når modalen lukkes. Bruk lokal `useState` for valgte ID-er.
- **`Arvet`-rad-dedup er backend-ansvar.** Frontend skal ikke gjøre dedup-logikk på rader. Hvis backend ikke deduplifiserer, returneres et `inheritedFrom: [TilgangsRef!]!`-array per rad — UI viser "Arvet fra X, Y".
- **`AuditLogCard`-referansen leser fra `saker.endringslogg(first, after)` — ikke direkte gjenbrukbar.** Ny query: `applikasjoner(...).endringslogg(first, after)` eller en topp-nivå `applikasjon(id).endringslogg`. Backend-agenten må føye til feltet.
- **Skisset 5-kolonners rutenett på Detaljer-fanen mappes til `Grid`-komponenten i `@/common/components/Grid`.** Iter 1 brukte `Surface`-kort for ulike seksjoner; nå er det _én_ Surface med ett internt grid-oppsett. Responsivt skal denne falle til færre kolonner på smale skjermer — bør sjekkes mot `Grid`-CSS-modulen i `bat-plan`.

## Dependencies (delta)

Iter-1-tabellen er fortsatt gyldig. Tillegg fra iter-2-deltaen:

| Avhengighet                                                                                              | Hva som påvirkes (iter-2)                                                                                                                                                            |
| -------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `src/common/components/inputs/ViewEdit{TextField,TextArea,Select,NumberInput,ToggleSwitch}/`             | Eksisterer; gjenbrukes for Detaljer-fanens edit-mode. Ingen kode-endring her.                                                                                                        |
| `src/domains/opptak/features/OpptakManagement/OpptakSettings/`                                           | Ny referanse-implementasjon for editMode-section. Ingen kode-endring her, kun lese-kilde.                                                                                            |
| `src/domains/support/features/Applikasjon/components/TildelTilgangerDialog/`                             | Eksisterer som forarbeid (sannsynligvis fra `fruitbat`-branch-arbeid). Tjener som mal for ny `FjernTilgangerDialog/`. Kan måtte oppdateres til nytt `(org, miljø)`-input-skjema.       |
| _Ny mappe_: `src/domains/support/features/Applikasjon/components/FjernTilgangerDialog/`                  | Net-ny komponent. Speiles på `TildelTilgangerDialog/`-strukturen.                                                                                                                     |
| _Ny mappe_: `src/domains/support/features/Applikasjon/features/ApplikasjonEndringslogg/` (eller liknende) | Iter-4-feature. Mappestruktur og hosting (tredje tab vs. inline-card) er åpent — se Open Questions.                                                                                  |
| `src/domains/soknadsbehandling/features/AuditLogCard/`                                                   | Ingen kode-endring; tjener som referanse-mønster for ny endringslogg.                                                                                                                |
| GraphQL-schema (backend)                                                                                 | Tre nye/endrede mutation-input-typer: `tildelApplikasjonTilganger`, `fjernApplikasjonTilganger` (begge med `(applikasjonId, organisasjonsId, miljoId)`). Ny query `Applikasjon.endringslogg(first, after)`. Ny `Tilgang.arvetFra: [Tilgang!]!`-eller-tilsvarende relasjon. |
| `src/common/messages/nb/support.json`                                                                    | Nye nøkler: `support.ApplikasjonDetaljer.rediger`/`avbryt`/`lagre`, `support.ApplikasjonFjernTilgangerDialog.*`, `support.ApplikasjonEndringslogg.*`, `support.ApplikasjonListe.antallTilganger`, `support.VisTilganger.tilknytning`/`arvetFra`/`skjulArvede`. |

### Cross-agent (kandidat-handoffs — uendret + tillegg)

Iter-1-kandidatene (backend GraphQL-overflate, idP-verifikasjon, autorisasjons-rettigheter) gjelder fortsatt. Tillegg:

5. **Backend / SuperGraf-schema-agent — utvidelser for iter 2-deltaen:**
   - `Tilgang`-typen må modellere `arvetFra: [Tilgang!]!` (eller equivalent) for "arvet"-merking + dedup.
   - `Applikasjon.endringslogg(first, after): EndringsloggConnection!` (Relay) for iter-4-endringslogg.
   - Mutation-input for `tildel`/`fjern` med eksplisitt `(organisasjon, miljø)`-tuple.
   - Mutation `redigerApplikasjon(input: { id, navn?, beskrivelse?, ansvarligId? })` som tar alle tre felter samtidig (atomic save av Detaljer-redigeringsformen).
   - Avklaring av navne-modell (visningsnavn vs. applikasjons-navn — finding #7).
   - Default-ansvarlig for legacy FS-applikasjoner (finding #8).

## Requirements Impact (delta)

Tabellen fra iter-1 utvides med ett nytt feature:

| Feature-ID      | Egenskap                      | Iter | Prioritet      | GitHub  | Status              |
| --------------- | ----------------------------- | ---- | -------------- | ------- | ------------------- |
| BRU-APP-API-006 | Redigere _detaljer_ (var: _beskrivelse_) | 2    | @must @planned | #443    | **Omarbeidet**      |
| BRU-APP-API-016 | Endringslogg                  | **4**| @must @draft   | **#453**| **NY i iter 2**     |

Alle øvrige features har samme `@must @planned`-status. `@could @draft` på BRU-APP-API-015 og -017 er uendret.

## Krav-input fra GitHub

- **Kilde-issue(s):** [#31](https://github.com/sikt-no/fs/issues/31) (paraply), sub-issues [#434](https://github.com/sikt-no/fs/issues/434), [#435](https://github.com/sikt-no/fs/issues/435), [#437](https://github.com/sikt-no/fs/issues/437), [#453](https://github.com/sikt-no/fs/issues/453) (ny i scope; parent = #437 i GitHub, men plassert i krav-mappe `03 Iterasjon 4` med `@must`-prioritet).
- **Repo / branch:** `sikt-no/fs` @ [`fruitbat`](https://github.com/sikt-no/fs/tree/fruitbat) — uendret fra iter-1.
- **Hentede `.feature`-filer:** se [`krav-input/manifest.md`](krav-input/manifest.md) for full diff-tabell og lokale stier.
- **Hentet:** 2026-05-27

## Open Questions

Spørsmål reist av denne iter-2-analysen er avklart i samtale 2026-05-27. Beslutninger og rasjonale:

- [x] **#453-parent-mismatch.** **Beslutning:** #453 (endringslogg) er i scope som iter-4 `@must`. Krav-arkivets `03 Iterasjon 4`-plassering er autoritativ over GitHub-hierarkiet. **Follow-up for `bat-krav`:** flytte #453 fra parent #437 (Nice to have) til et nytt iter-4-paraply-issue, så GitHub stemmer med krav-arkivet.
- [x] **Endringslogg-plassering i UI.** **Beslutning:** Tredje fane `Endringslogg` på `DetailPageTabbedContent` — konsistent med eksisterende tab-mønster. URL blir `?tab=endringslogg`. `bat-plan` modellerer en tredje `DetailPageTabbedContentPanel` på applikasjon-detaljsiden.
- [x] **Navne-modell (finding #7).** **Beslutning:** To separate felter på `Applikasjon`-typen:
  - `visningsnavn` — hentet fra idP (Feide/Maskinporten) ved opprettelse, låst, globalt unik (håndhevet av backend, jf. K8).
  - `navn` — brukerredigerbart i FS Admin (via `rediger_detaljer`-flyten), display-vennlig alias. Ikke globalt unikt.
  - Begge vises på detaljsiden. `Navn`-feltet i skissen mapper til `navn`; `visningsnavn` får sitt eget read-only-felt (eller vises ved siden av `navn`).
- [x] **Default-ansvarlig for legacy FS-applikasjoner (finding #8).** **Beslutning:** Force-pick on first edit. Backend tillater `ansvarlig = null` for legacy-applikasjoner. UI viser en advarsel på detaljsiden (_"Mangler ansvarlig — må settes ved neste redigering"_) og blokkerer alle save-operasjoner på applikasjonen inntil ansvarlig er fylt inn. Migrasjon skjer organisk — ingen big-bang-backfill nødvendig.
- [x] **`Tilknytning`-filteret (finding #9).** **Beslutning:** Samme konsept som krav-filas "skjul/vis arvede"-toggle; skissen vinner på rendring. Implementeres som `Select` med tre opsjoner: _"Alle tilknytninger" / "Kun direkte" / "Kun arvede"_. **Follow-up for krav-eier:** justere `vise_tilganger.feature` så scenariene refererer til samme filter-navn (`Tilknytning`) i stedet for "skjul arvede"-toggle.
- [x] **`AuditLogItem`-rad-innhold (de fire `@openquestion`-scenariene).** **Beslutning:** UI shell now, content later. `bat-plan` modellerer UI-rammen (tredje fane + `Surface` + `AuditLogItem`-rader + "Last inn flere"-paginering 50) med en placeholder data-shape. Backend må fortsatt avklare hva som logges, loggpost-innhold, retention og filter — men frontend kan starte implementasjonen parallelt.
- [x] **Sketch-vs-krav-konsistens på listevisningen.** **Beslutning:** Krav-fila er autoritativ. `Antall tilganger`-kolonne legges til i listevisningen iht. `listevisning_og_sok.feature`. Skissen er litt utdatert, ikke en blokker.

Decisions inherited (uendret siden iter-1; bekreftet gjeldende):

- [x] Q1: Eksisterende FS-applikasjoner forvaltes i ny UI, kan ikke opprettes.
- [x] Q2: Side-om-side under feature-flag-kontroll.
- [x] Q3: POC-fjerning er trygt uten test-backfill.
- [x] Q4: Ny Unleash-flag for sub-itemen.
- [x] Q5: Backend eier all autorisasjon end-to-end.
- [x] Q6: Cross-org-synlighet (K11/K12) er implisitt i backend-autorisasjon.
- [x] Q7: Bulk-mutasjon for fjern + tildel — bekreftet og utvidet med `(org, miljø)`-tuple i iter 2.
- [x] Q8: Deaktivering = `ApplikasjonStatus`-flagg — utvidet til at INAKTIV ikke blokkerer tilgangs-mutasjoner.
- [x] Q9: "Last inn flere"-paginering for tilgangs-tab.
- [x] Q10: All spec-detalj ligger i `.feature`-filene.

## Notes

- **Iter-1-spørsmålene som lå åpne** (#437-`@draft`-håndtering, POC-rydde-PR-timing, `NyTilgangButton`-skjebne, USER_ACTION-enum-utvidelse-eller-ikke, backend-agent-aktivitet) er **fortsatt åpne** — de er ikke gjentatt her, men `bat-plan` må fortsatt adressere dem.
- **`opprette_applikasjon.design.md` har kun kosmetiske endringer** (markdown-formatering). Innholdet er substansielt uendret fra iter 1 — `bat-plan` kan referere til iter-1-versjonen direkte.
- **`systemkrav.md`-filene har kun kosmetiske endringer** (blanke linjer, italic-stil). Kapabilitets-tabellene er uendret.
- **Iter 4 introduserer ingen ny mappe i fs-admin-strukturen utover endringslogg-feature.** K11-K14 (selvbetjent oversikt, tildel, fjern på egne org) er bevisst implementert som rettighetsregler i Iter 2- og Iter 3-features — se `03/systemkrav.md` § "Funksjonalitet dekket av features fra tidligere iterasjoner".