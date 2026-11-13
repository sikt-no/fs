# Analysis: Velge fag per poengvariant (L3, `@OPT-BEH-BEH-022`)

Rolle: frontend (fs-admin). Analysert 2026-11-12 mot fs-admin `main` (`206935039`), fs-admin-branchen
`origin/feat/opptak-l2-velge-vitnemaal` (`b191b0cdc`), og fs-plattform-branchene
`origin/opptak/L2-legg-vitnemaal-til-grunn` (`ca66796161`) og `origin/vitnemalsbehandling-tabeller`
(`c0baf8b778`).

## Problem Statement

Det kanoniske kravet står i spec-dokumentet (se _Krav-input referanse_). Sett fra fs-admin: steg 2
«Grunnlag» i søknadsbehandlingen må la saksbehandleren

- se fagene på vitnemålet som er valgt for en poengvariant, med eksamensform, opprinnelig og forbedret
  karakter, år/termin og merknader, og tilleggsfag i en egen tabell
- krysse av hvilke fag som teller, per poengvariant, innenfor grensene backend oppgir (valgbar,
  23/6-regelen)
- velge vitnemål per poengvariant, og få fagvalg og egne poeng for vitnemålet tilbake når hen bytter
  tilbake
- legge inn karakter-, realfags- og språkpoeng selv, med validering mot poengtypen
- bruke vitnemål og fagvalg fra én poengvariant i andre
- få et varsel, ikke en sperre, når grunnlaget for poengvarianten for kvoten for førstegangsvitnemål
  har forbedringer, både ved «Beregn poeng» og «Bruk poeng»
- se at søkeren ikke er kvalifisert, og at fagvalget er lagret, men poengene ikke

Alt dette bygger på L2 (`@OPT-BEH-BEH-004`: «Beregn poeng»/«Bruk poeng», valg av vitnemål), som
ikke er merget i noen av repoene ennå.

## Current State

### fs-admin `main`

- **Rute:** `src/app/opptak/[id]/soknadsbehandling/sak/[sakId]/(sak)/grunnlag/page.tsx:10-15`
  rendrer `GrunnlagCard` og `VitnemalsbehandlingSection` under hverandre. Ingen feature flag.
- **`GrunnlagCard`** (`src/domains/soknadsbehandling/features/GrunnlagCard/GrunnlagCard.tsx`):
  avkrysning av grunnlag (VOV, VPL, PRA …) med `leggTilGrunnlag`/`fjernGrunnlag`, én mutasjon per
  klikk, og `refetchQueryNames(...)` på sju spørringer (`:152-160`). Dette er boksen «Grunnlag» øverst
  i skissen, og ligger utenfor L3.
- **`VitnemalsbehandlingSection`**
  (`src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx`):
  bare L1. En `Details` med en lesetabell over vitnemålene (nummer, utstedt, GSK, førstegang,
  KAR/REA/SPR fra `VgsDokument.poeng`) og en lenke som åpner vitnemålet i ny fane (`:156-167`).
  Ingen valg, ingen fag.
- **`VgsDokumentFagTabell`**
  (`src/domains/soknadsbehandling/features/VgsDokumentView/components/VgsDokumentFagTabell/VgsDokumentFagTabell.tsx`):
  fagtabellen på siden for ett vitnemål (`/vgsdokument/[vgsDokumentId]`). Leser fragmentet
  `VgsDokumentFagTabellFields` (`:12-28`) med `useFragment`, og har kolonnene omfang, kode, fag,
  standpunkt, eksamen, eksamensform, år og merknader (`:32-41`). Den viser bare `aar`, ikke
  `terminkode` (skissen viser «V13»), har én rad per `fagkode` (`key={rad.fagkode}`, `:76`) og ingen
  avkrysning.
- **`PoengberegningCard`** (egen fane `poengberegning`): poenglisten for saken med
  `settPoengV4` per rad (`PoengberegningCardRow.tsx:22-46`), «La stå» og merknad.
  `utils/validatePoints.ts:16-54` validerer en poengverdi mot `Poengtype.minimum`, `maksimum`,
  `poengtrinn` og `antallSifre`. Det er de samme grensene kravet «Ugyldig verdi for <poengtype>
  stoppes» viser til.
- **`Vitnemalskalkulator`** (`PoengberegningCard/Vitnemalskalkulator/`): en eldre manuell kalkulator
  med `lagreVitnemalUtregning` og karakterrader med `inngarIUtregning`. Den importeres ikke noe sted
  utenfor egen mappe og egne tester, og er altså død kode i dag. Den hører tematisk til L4b
  (kalkulatoren), ikke L3.
- **Rettighet:** `useKanSaksbehandle(sakId)` (`src/domains/soknadsbehandling/hooks/useKanSaksbehandle`)
  gir skrivetilgang ut fra `FS_ADMIN_MODIFISERE_SØKNADSBEHANDLING` hos organisasjonen som behandler
  saken. Det dekker «rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler
  saken» i alle Bakgrunn-blokkene i L3.

### fs-admin `origin/feat/opptak-l2-velge-vitnemaal` (L2, ikke merget, sist endret 2026-11-12)

Branchen endrer 11 filer (+1539/−179). Hovedfilen er `VitnemalsbehandlingSection.tsx` (567 linjer):

- **Spørringer:** `GetSakVgsDokumenter` henter `vgsDokumenter` og fragmentet
  `VitnemalsbehandlingPoeng` (`vitnemaalsbehandlingKombinasjoner` + `poengListe`).
  `BeregnVitnemaalpoeng` er en **query** med `fetchPolicy: 'no-cache'` (lagrer ingenting).
  `LeggVitnemaalTilGrunn` er «Bruk poeng».
- **Modell:** én rad per **kombinasjon** (poengvariant × kompetanseregelverk × grunnlag) i den nye
  `KombinasjonTabell` («Kvalifisering og poengberegning»), med en avkrysning per rad. Krysset er
  arbeidstilstand og lagres ikke. Ett vitnemål velges med radioknapp, og gjelder alle kryssede
  kombinasjoner. Å velge et vitnemål krysser av kombinasjonene som bygger på det nå.
- **«Poeng for vitnemålsutvalg»:** knappene «Beregn poeng» og «Bruk poeng», og en `<dl>` med
  KAR oppr., KAR forbdr. (alltid `-`), REA, SPR og SUM, alle **skrivebeskyttet**. «Bruk poeng» er
  bare aktiv når den siste beregningen ble gjort med de samme valgene (`valgNokkel`).
- **Førstegangsvitnemål:** beregningen returnerer `grunnlagSomKreverForstegangsvitnemaal`, og viser et
  varsel med teksten «Fjern krysset for kombinasjonen for å kunne bruke poengene». «Bruk poeng»
  avvises av backend med `KREVER_FOERSTEGANGSVITNEMAAL`. Det er en **sperre**.
- **Ingen fagtabell** i seksjonen. «Vitnemålsutvalg <nummer>»-blokken fra skissen finnes ikke.
- Ingen `useUnsavedChanges`, selv om L2-kravet har «Advarsel om endringer som ikke er lagret».

### fs-plattform

- **L2-API** (`origin/opptak/L2-legg-vitnemaal-til-grunn`,
  `opptak/opptak-subgraph/.../experimental/saksbehandling/vitnemaal-grunnlag.graphqls`):
  `beregnVitnemaalpoeng(input: {sakId, vgdoknr, kombinasjoner})`,
  `leggVitnemaalTilGrunn(...)`, `Sak.vitnemaalsbehandlingKombinasjoner`, og
  `VitnemaalGrunnlagAvvisning.KREVER_FOERSTEGANGSVITNEMAAL`. Det finnes ingen inputfelt for fagvalg
  eller poeng lagt inn for hånd, og `Vitnemaalberegning` har ingen KAR forbedret.
- **Tabeller for vitnemålsbehandleren** (`origin/vitnemalsbehandling-tabeller`,
  `V503__vitnemalsbehandling.sql`, ikke merget): `vitnemalsbehandling` (én rad per kombinasjon, med
  valgt `vgdoknr`) og `vitnemalsbehandling_fag` (fagrader av typen `ORIGINAL`, `FORBEDRING` og
  `TILLEGG`, med `inngar_i_beregning`, «bare én rad per fag kan inngå»). Fremmednøkkelen
  `vitnemalsbehandling_fag_valgt_dokument_fk` krever at radene peker på dokumentet som er valgt
  **nå**: «Et nytt dokument kan ikke velges før radene for det gamle er slettet.»
- **Publisert skjema:** verken `test/experimental` eller den lokale `schema.graphql` har L2-feltene.
  `VgsDokumentFag` har `fagkode`, `fagnavn`, `karakterStandpunkt`, `karakterEksamen`,
  `eksamensformkode`, `omfang`, `aar`, `terminkode` og `merknader`, men **ikke** forbedring, tillegg,
  valgbar eller fagstatus. `Grunnlag.forbedringTillatt` finnes i test-skjemaet (regelverk).
- Spec-dokumentets kodesjekk bekrefter at `kompetanse.vgs_dokument_fag` har nøkkelen
  `(vgdoknr, fagkode)`, og at forbedring og tillegg fra KREG ikke lagres i opptak.

## Key Findings

1. **L3 kan ikke bygges på `main`.** Branchen `feat/opptak-l3-velge-fag-per-poengvariant` står på
   `main` (`git log main..HEAD` er tom), mens alt L3 utvider (radioknapp for vitnemål, «Beregn
   poeng»/«Bruk poeng», `KombinasjonTabell`) bare finnes på L2-branchen. Begge L2-branchene, i
   fs-admin og i fs-plattform, ble endret i dag.
2. **L2-koden har en sperre som L3 gjør om til et varsel.** L2 avviser «Bruk poeng» med
   `KREVER_FOERSTEGANGSVITNEMAAL` og ber saksbehandleren fjerne krysset. L3 («Varsel om forbedringer
   i poengvarianten for førstegangsvitnemål», avklart 11.11.2026) sier at dette er et varsel som ikke
   stopper noe, både for tilleggsfag/forbedrede karakterer og for et vitnemål med forbedringer. Det må
   endres både i backend (avvisningen) og i fs-admin (`kreverForstegangVarselHandling`,
   `avvisningKreverFoerstegangsvitnemaal`, testene).
3. **Kravet sier «per poengvariant». Koden og datamodellen sier «per kombinasjon».** L2-UI,
   L2-API og V503 bruker nøkkelen poengvariant × kompetanseregelverk × grunnlag. Skissens tabell har
   også én rad per slik kombinasjon (ALMLP/LÆRA-PRA/PRA …). Samtidig sier kravet «Kravelementene
   vurderes per grunnlag», ikke per poengvariant. Om fagvalget lagres per kombinasjon, får to
   kombinasjoner med samme poengvariant hvert sitt fagvalg. Det må være en bevisst beslutning.
4. **API-et har ingenting av det L3 trenger ennå.** Det mangler fag per vitnemålsutvalg med
   opprinnelig/forbedret karakter, tilleggsfag, `valgbar` og (for 23/6) låste fag, en input for
   fagvalg og egne poeng til både beregn og bruk, varsel om forbedringer i stedet for avvisning,
   «bruk på andre poengvarianter», og et utfall for «ikke kvalifisert, fagvalg lagret, poeng ikke
   lagret». Frontend kan bygge mot mock (`fs-admin-mock-api-with-data`), men ikke mot ekte data.
5. **V503-modellen hindrer at endringer huskes per vitnemål.** Kravet («Endringer på et vitnemål
   huskes når jeg bytter tilbake») krever at fagvalg og egne poeng for et vitnemål overlever et bytte.
   V503 krever at fagradene slettes før et nytt dokument velges. L2-backend har også fjernet at
   «Poeng lagt inn selv huskes per vitnemål» (`425d097503`).
6. **Fagtabellen finnes, men som ren visning et annet sted.** `VgsDokumentFagTabell` har nesten alle
   kolonnene kravet ber om (mangler termin i «År», og Opprinnelig/Forbedret som kolonnepar). Den er
   bundet til `VgsDokument`-fragmentet og nøklet på `fagkode`. Med forbedringer kan samme fagkode
   stå to ganger, og da kolliderer `key`.
7. **Valideringen av egne poeng finnes allerede.** `validatePoints` dekker min, maks, trinn og antall
   sifre fra poengtypen. L2-fragmentet henter `antallDesimaler` og `poengtypeVitnemalskravKode`, men
   ikke `minimum`/`maksimum`/`poengtrinn`/`antallSifre`. Feilmeldingene ligger under
   `soknadsbehandling.PoengberegningCard`, og må flyttes eller deles etter `fs-admin-i18n-structure`.
8. **Skissen viser KAR opprinnelig og KAR forbedret som to felt.** Kravet har tre poengtyper
   (karakterpoeng, realfagspoeng, språkpoeng). Det er ikke avklart hvilken KAR saksbehandleren legger
   inn, eller om begge kan legges inn.
9. **Pattern-match:** ingen kjent mønster (list-, detail-, article- eller domain-index-side) gir
   treff ≥90. L3 er en utvidelse av en seksjon inne i et eksisterende steg, ikke en ny side.
   Relevante skills i planleggingen: `fs-admin-tables-vs-lists` (fagtabell med avkrysning i rader),
   `fs-admin-inputs` (poengfelt, checkbox-labels), `fs-admin-buttons` (async «Bruk poeng»),
   `fs-admin-i18n-structure` og `graphql-consumer`.
10. **Ingen brukerveiledning dekker steget.** `grep` i `src/features/Brukerveiledninger/innhold/`
    finner bare `opprette-opptak.md` og `utdanningstilbud-i-samordna-opptak.md`, som ikke handler om
    søknadsbehandling.

## Technical Constraints

- **CLAUDE.md, UI-føring:** SDS og felleskomponenter først, ingen custom styling på input- og
  output-felt, layout med `<Grid>`/`<Flex>` (aldri `display: flex/grid` i CSS for ny kode).
  L2-branchen har allerede egen CSS for `<dl>`-poengene (`styles.beregnet`).
- **CLAUDE.md, ulagrede endringer:** hvert skjema skal bruke `useUnsavedChanges` med baseline og
  `markClean()`. Fagvalg og egne poeng er ulagret arbeidstilstand til «Bruk poeng».
- **GraphQL:** spørringer ved komponenten, ingen gjenbruk mellom komponenter, `refetchQueryNames(...)`
  aldri strenger, ingen `__typename` i operasjoner, testmocks importerer dokumentet fra komponentfilen.
- **Codegen bruker `production/experimental`.** L2- og L3-feltene finnes ikke der. Utvikling krever
  `GRAPHQL_SCHEMA_LOCATION` mot test eller `GRAPHQL_SCHEMA_INTROSPECTION_URL` mot en lokal gateway
  (bare `.env.local`), og koden kan ikke merges før feltene er i produksjonsskjemaet. Ellers feiler
  typesjekken.
- **Testkrav:** hver komponent skal ha `*.a11y.test.tsx`. L2 har a11y-tester for seksjonen og
  `KombinasjonTabell`.
- **Changeset** (`fs-admin-changesets`) med prefikset `Søknadsbehandling:`. Ingen feature flag gater
  grunnlag-steget i dag.
- **Tilgjengelighet:** radioknappene for vitnemål ligger i en `RadioFieldset` rundt en tabell (L2), og
  avkrysning per fag og per kombinasjon trenger unike labels (L2 bruker
  `velgKombinasjon {poengvariant}, {kompetansekrav}, {grunnlag}`).
- **Brukerens regel:** ingen hjemmesnekret logikk der et verktøy eller backend allerede har svaret.
  Regler som valgbar, 23/6 og «tilleggsfag ikke valgt i FSB ved kopiering» bør komme fra backend, ikke
  fra fs-admin.

## Dependencies

- **Internal:**
  - `VitnemalsbehandlingSection` og `KombinasjonTabell` (L2-branchen) utvides direkte.
  - `VgsDokumentFagTabell` (L1) er kandidat for gjenbruk, eller som referanse for kolonner og tekster.
  - `PoengberegningCard` deler `Poeng`-entitetene. «Bruk poeng» med egne poeng låser alle poengene på
    poengvarianten (`laStaa`), og raden der må vise det uten refetch, slik L2 allerede gjør via
    fragmentet.
  - `validatePoints` og meldingene i `soknadsbehandling.PoengberegningCard`.
  - `useKanSaksbehandle`, `useUnsavedChanges`, `refetchQueryNames`.
- **External:**
  - opptak-subgraph i fs-plattform (L2-API-et, som utvides for L3).
  - Publisert SDL på `fs.sikt.no/api/schema/...` for codegen.
  - KREG (`nvb2.vgdokfag`: `status_forbedring`, `status_tillegg`, `faginfokode`) via opptak.
- **Cross-contributor:**
  - **backend (fs-plattform/opptak):** lagre forbedring og tillegg fra KREG i opptak (spec-dokumentets
    kodeavvik). Uten dette finnes ingen opprinnelig/forbedret eller tilleggsfag å vise. *Blokkerer hele
    regelen «Fagene på det valgte vitnemålet vises» og alt om tilleggsfag.*
  - **backend:** eksponere fag per vitnemålsutvalg (per kombinasjon eller poengvariant), med
    `valgbar`/låst, opprinnelig og forbedret karakter, tilleggsfag og gjeldende fagvalg. *Blokkerer
    fagtabellen og avkrysningen.*
  - **backend:** utvide `beregnVitnemaalpoeng`/`leggVitnemaalTilGrunn` med fagvalg og egne poeng,
    returnere KAR forbedret, erstatte `KREVER_FOERSTEGANGSVITNEMAAL`-avvisningen med et varsel, og
    returnere «ikke kvalifisert, poeng ikke lagret». *Blokkerer «Beregn poeng»/«Bruk poeng» i L3.*
  - **backend:** endre V503 (eller lagre på en annen måte) slik at fagvalg og egne poeng huskes per
    vitnemål. *Blokkerer «Endringer på et vitnemål huskes når jeg bytter tilbake».*
  - **backend:** «bruk vitnemål og fagvalg på andre poengvarianter», med kvoteregelen om tilleggsfag i
    FSB. *Blokkerer det scenarioet.*
  - **spesifikasjon (sikt-no/fs):** `velge_fag_per_poengvariant.design.md` (varseltekst for forbedringer
    i førstegangskvoten, beskjed om ugyldig verdi). Spec-dokumentets åpne spørsmål «Implementasjonsdetaljer
    mangler». *Blokkerer endelige tekster, ikke strukturen.*
  - **design:** tilstandene som ikke er skissert (varselet, ugyldig verdi, valg av andre poengvarianter,
    ikke kvalifisert).
  - **fs-admin (L2-eier):** L2 må merges før L3 kobles på «Beregn poeng»/«Bruk poeng» (spørsmål 1).
  - **L2-eier, fs-plattform og fs-admin:** fjern sperren `KREVER_FOERSTEGANGSVITNEMAAL` før L2 merges
    (spørsmål 2).

## Requirements Impact

Alle scenarioene står i `velge_fag_per_poengvariant.feature` (`@OPT-BEH-BEH-022`).

- **Requirements addressed (delvis, i L1/L2-koden):**
  - «Se fagene på vitnemålet»: kolonnene finnes i `VgsDokumentFagTabell`, men på en annen side, uten
    termin i «År» og ikke i steg 2.
  - «Se merknader på et fag»: `VgsDokumentFag.merknader` vises allerede i `VgsDokumentFagTabell`.
  - «Legge ulikt vitnemål til grunn for ulike poengvarianter»: L2-branchen gjør det mulig ved å krysse
    ulike kombinasjoner og bruke poeng to ganger, med ulike vitnemål. Det fremgår i tabellen hvilket
    vitnemål en kombinasjon bygger på.
  - Rettighet (Bakgrunn i hver regel): `useKanSaksbehandle`.
- **Requirements at risk:**
  - «Se opprinnelig og forbedret karakter samtidig», «Tilleggsfag teller ikke før det aktivt velges»,
    «Tilleggsfag kan velges i ordinær kvote», «Ikke alle fag kan velges bort»: dataene lagres ikke i
    opptak (Funn 4, kodeavviket i spec-dokumentet).
  - «Endringer på et vitnemål huskes når jeg bytter tilbake»: i strid med V503 (Funn 5).
  - «Varsel om forbedringer i poengvarianten for førstegangsvitnemål når jeg <handling>», eksempelet
    «bruke poengene»: L2 sperrer i dag (Funn 2).
  - «Velge hvilke fag som skal telle», «Fagvalget i én poengvariant påvirker ikke en annen»:
    avhenger av om «per poengvariant» betyr per kombinasjon (Funn 3).
  - «Legge inn <poengtype> selv på en poengvariant» og «Ugyldig verdi for <poengtype> stoppes»:
    poengene er skrivebeskyttet i L2, og API-et har ingen input for dem. Hvilken KAR som kan legges
    inn, er uklart (Funn 8).
  - «Studiekompetansefag kan ikke fjernes etter 23/6-regelen», «Velge hvordan matematikk på
    Vg2-nivå dekkes etter 23/6-regelen»: fs-admin vet ikke om søkeren rangeres etter 23/6, eller hvilke
    fag som er studiekompetansefag. Det må komme fra backend.
  - «Ingen poeng lagres for en poengvariant der søkeren ikke er kvalifisert»: `erKvalifisert` finnes
    per kombinasjon, men ikke et utfall fra «Bruk poeng» som sier at fagvalget er lagret og poengene
    ikke.
  - «Bruke vitnemålet og fagvalget fra én poengvariant i andre poengvarianter»: ingen mekanisme ennå
    (L2 bruker ett vitnemål på alle kryssede kombinasjoner, men uten fagvalg).
- **Missing requirements discovered:**
  - Visningen etter «Beregn poeng» av hvilken karakter som inngår (tatt ut av kravet 12.11.2026, uten
    eget scenario). Skissen gir ikke svar.
  - Kravet sier ikke hva som skjer med et ulagret fagvalg når saksbehandleren velger en annen
    kombinasjon eller et annet vitnemål. L2-kravet har «Advarsel om endringer som ikke er lagret», men
    L2-koden har ikke implementert den.
  - Fagstatus (elev/privatist) styrer «Kravelementene vurderes per grunnlag», men vises ikke og finnes
    ikke i `VgsDokumentFag`. Det er riktig for UI-et, men en backend-avhengighet.
  - Skissefeil: radioknappen står på 498463131357, mens overskriften er «Vitnemålsutvalg 498463131356»
    (spec-dokumentet).
  - `@ref-OPT-BEH-BEH-023`/`037` (L4a/L4b, legge inn fag manuelt) ligger utenfor L3. «Legg til fag» og
    de tomme radene i skissen skal derfor ikke bygges nå.

## Krav-input referanse

Kravene ligger i en annen mappe (`sikt-no/fs`) enn denne analysen. Lokalt peker lenkene på klonen i
`/Users/geir/gitrepos/sikt/fs`. Publisert i oppgavemappen (`tasks/opptak/vitnemalsbehandling/frontend/`)
løses de relativt:

- **Spec-dokument:** [`spec-velge-fag-per-poengvariant.md`](../spec/spec-velge-fag-per-poengvariant.md)
- **Krav-input-manifest:** [`krav-input/manifest.md`](../spec/krav-input/manifest.md)
- **L2-spec (avhengighet):** [`spec-velge-vitnemal-som-grunnlag.md`](../spec/spec-velge-vitnemal-som-grunnlag.md)

## Open Questions

- [x] **1. Hvilken base skal L3 i fs-admin bygges på?**
  (a) Rebase `feat/opptak-l3-velge-fag-per-poengvariant` på `origin/feat/opptak-l2-velge-vitnemaal`
  og lever som stacked PR. (b) Vent til L2 er merget til `main`. (c) Start på `main` med det som er
  uavhengig av L2 (fagtabellen som egen komponent), og koble på etterpå.
  - **Beslutning (2026-11-12):** (c) Start på `main`. Det som ikke avhenger av L2-koden, bygges
    først, og kobles på «Beregn poeng»/«Bruk poeng» og radioknappen når L2 er merget.
  - **Begrunnelse:** besluttet av utvikleren uten egen analyse. Det gjør at L3 ikke blir avhengig av
    en L2-branch som fortsatt endres. Planen må skille ut hvilke deler som er uavhengige av L2.
- [x] **2. Sperren for førstegangsvitnemål i L2:** skal L2 merges med sperren og L3 gjøre den om til
  varsel, eller skal L2 rettes før merge? Hvem eier endringen i backend?
  (a) Merge L2 med sperren, og L3 retter. (b) Rett L2 før merge.
  - **Beslutning (2026-11-12):** (b) L2 rettes før merge. L2-eieren fjerner
    `KREVER_FOERSTEGANGSVITNEMAAL` i backend (avvisningen og enum-verdien) og i fs-admin
    (`kreverForstegangVarselHandling`, `avvisningKreverFoerstegangsvitnemaal`), og beholder varselet
    ved «Beregn poeng» uten «fjern krysset». L3 legger til varselet ved «Bruk poeng», og for
    tilleggsfag og forbedrede karakterer.
  - **Begrunnelse:** L2-kravet har ingen regel om førstegangsvitnemål, så sperren finnes bare i koden.
    L3-kravet opphever den eksplisitt (`velge_fag_per_poengvariant.feature:318-320`, «var en sperre»,
    endret 11.11.2026 i `8aca38be`). Med (a) ville produksjon fått en sperre uten kravgrunnlag til L3
    er ute, og det kan ta tid når L3 starter på `main` (spørsmål 1). API-et er experimental, så det
    koster lite å fjerne enum-verdien.
- [x] **3. «Per poengvariant» eller «per kombinasjon»?** Lagres fagvalg, vitnemålsvalg og egne poeng
  per kombinasjon (poengvariant × kompetanseregelverk × grunnlag), slik L2 og V503 gjør, eller per
  poengvariant, slik kravet sier? (a) Per kombinasjon, og kravet tolkes slik. (b) Per poengvariant, og
  L2/V503 endres. (c) Per kombinasjon i lagringen, men UI-et holder kombinasjonene med samme
  poengvariant i synk.
  - **Beslutning (2026-11-12):** (a) Per kombinasjon. Raden i «Kvalifisering og poengberegning» er
    enheten i UI-et, slik L2, V503 og V524 allerede er bygget. Domeneekspertene bekrefter at samme
    poengvariant under ulike kompetansekrav kan ha ulikt fagvalg, og kravteksten kan presiseres med
    `fs-krav`.
  - **Begrunnelse:** kravet gjør kvalifiseringen per grunnlag, knytter poengsum til kompetansekrav, og
    sier at poengvariantene på samme grunnlag kan ha ulikt fagvalg. Det tar ikke stilling til samme
    poengvariant under flere kompetansekrav. I skissen er rad og kombinasjon det samme (GENSP = GENS/PRA,
    GENSV = GENS/VPL). (b) ville krevd ombygging av L2 og to migreringer mens L2 rettes (spørsmål 2),
    og (c) ville lagt skjult regel-logikk i frontend. For fs-admin er (a) og (b) nesten like, så lenge
    API-et leverer radene.
- [x] **4. Hvordan velger saksbehandleren hvilke andre poengvarianter vitnemålet og fagvalget skal
  brukes på?** (a) Avkrysningen per rad i «Kvalifisering og poengberegning» (L2s `krysset`) er valget.
  «Bruk poeng» lagrer vitnemål og fagvalg på alle kryssede rader. (b) En egen handling eller dialog
  etter lagring. (c) Avklares av design først (ikke skissert).
  - **Beslutning (2026-11-12):** (a) Avkrysningen per rad er valget. «Bruk poeng» lagrer vitnemål og
    fagvalg på alle kryssede rader.
  - **Begrunnelse:** besluttet av utvikleren uten egen analyse. Det gjenbruker mekanismen L2 allerede
    har (`krysset`), og skissen har en avkrysning per rad. Følge: kvoteregelen («tilleggsfag er ikke
    valgt i poengvarianten for kvoten for førstegangsvitnemål») må gjelde når en førstegangsrad er
    krysset sammen med andre. Den bør håndheves i backend, ikke i fs-admin.
- [x] **5. Hvordan skal «endringer huskes per vitnemål» lagres og leveres til frontend?** V503 sletter
  fagradene ved bytte. Får frontend det husket fagvalget og de egne poengene for et vitnemål fra API-et
  når radioknappen flyttes (før «Bruk poeng»), eller bare etter lagring?
  - **Beslutning (2026-11-12):** bare det som er lagret med «Bruk poeng», huskes. Når saksbehandleren
    flytter radioknappen tilbake til et vitnemål, henter fs-admin fagvalget og de egne poengene som
    sist ble lagret for raden og det vitnemålet. Ulagret arbeid går tapt ved bytte, etter en advarsel om
    ulagrede endringer.
  - **Begrunnelse:** besluttet av utvikleren. Fs-admin trenger da ikke holde arbeidstilstand per
    vitnemål. Backend må likevel lagre fagvalg og egne poeng per rad *og* vitnemål, og ikke slette dem
    ved bytte. Det er i strid med fremmednøkkelen i V503 (Funn 5), og blir et krav til backend. Fs-admin
    trenger en advarsel om ulagrede endringer når radioknappen flyttes med ulagret fagvalg (L2-kravets
    «Advarsel om endringer som ikke er lagret»). `useUnsavedChanges` dekker navigasjon bort fra siden,
    så planen må avklare om den også dekker bytte inne i seksjonen.
- [x] **6. Fagtabellen i steg 2:** (a) Utvid `VgsDokumentFagTabell` med valgmodus og
  Opprinnelig/Forbedret. (b) Lag en egen komponent i `VitnemalsbehandlingSection`, og la
  `VgsDokumentFagTabell` være ren visning. (c) Trekk ut felles kolonner og celler til en delt
  komponent.
  - **Anbefaling fra analysen:** (b), fordi datakilden er en annen type enn `VgsDokument.fag`,
    CLAUDE.md fraråder å gjenbruke spørringer mellom komponenter, `key={fagkode}` kolliderer med
    opprinnelig og forbedret rad, og L4a gjør at tabellene vil skille lag mer.
  - **Beslutning (2026-11-12, korrigert samme dag):** (b) En egen komponent under
    `VitnemalsbehandlingSection/components/`, bygget på `FSTable`, med eget fragment for L3-typen.
    `VgsDokumentFagTabell` er uendret, og forblir ren visning på vitnemålssiden (L1).
  - **Begrunnelse:** følger anbefalingen. Det første svaret, (a) utvide `VgsDokumentFagTabell`, var
    feil, og er rettet. Datakilden er en annen type enn `VgsDokument.fag`, og spørringer skal ikke
    gjenbrukes mellom komponenter. Med en egen komponent unngår vi også at `key={fagkode}` kolliderer,
    og at L1-visningen påvirkes av L4a. `FSTable` har ingen gruppert kolonneoverskrift, så
    «Opprinnelig»/«Forbedret» må løses med kolonnelabels eller en utvidelse. Om tilleggsfag bruker
    samme komponent, avgjøres i planen.
- [x] **7. Egne poeng: hvilke felt kan redigeres?** Skissen har KAR opprinnelig, KAR forbedret, REA og
  SPR som redigerbare felt, og SUM som beregnet. Kravet har karakterpoeng, realfagspoeng og
  språkpoeng. (a) Bare KAR forbedret (det som brukes), REA og SPR. (b) Begge KAR-feltene. (c) Én KAR, og
  skissen rettes.
  - **Beslutning (2026-11-12):** (b) KAR opprinnelig, KAR forbedret, REA og SPR kan legges inn. SUM
    beregnes.
  - **Begrunnelse:** besluttet av utvikleren, og følger skissen. Følger: kravet har bare
    «karakterpoeng» i eksemplene, så kravet bør få både opprinnelig og forbedret karakterpoeng
    (`fs-krav`). Backend må ta imot og lagre begge, og si hvilken poengtype de valideres mot
    (`validatePoints`). Det må også avklares hvilken KAR som brukes i SUM.
- [x] **8. 23/6-regelen og valgbare fag:** kommer «rangeres etter 23/6», «valgbar» og «låst» (f.eks.
  1P, studiekompetansefag) ferdig avgjort per fag fra backend, så fs-admin bare viser låst/valgbar?
  (a) Ja, backend avgjør. (b) Fs-admin håndhever deler selv.
  - **Beslutning (2026-11-12):** (a) Backend avgjør. API-et leverer valgbar/låst per fagrad, og
    fs-admin har ingen 23/6-regler.
  - **Begrunnelse:** reglene hører til opptak, og skal gjelde likt for alle klienter. «Velge hvordan
    matematikk på Vg2-nivå dekkes» (1P må med, 2P og/eller R1 valgfritt) må da uttrykkes i API-et, og
    `fagvalg` må avvises eller korrigeres av backend hvis kombinasjonen er ugyldig. Det er et
    cross-contributor-krav.
- [x] **9. «År»-kolonnen:** skal den vise termin og år samlet («V13»), som skissen, også i
  `VgsDokumentFagTabell` på vitnemålssiden (L1)?
  (a) Bare i steg 2. (b) Begge steder. (c) Spør designeren.
  - **Beslutning (2026-11-12):** (b) Begge steder. Den nye fagtabellen i steg 2 og
    `VgsDokumentFagTabell` viser termin og år samlet («V13»).
  - **Begrunnelse:** utviklerens valg, for lik visning av fag. `VgsDokumentFagTabell` må hente
    `terminkode` i fragmentet (finnes i `VgsDokumentFag`). Formateringen bør ligge i én hjelpefunksjon
    som begge tabellene bruker, så de ikke skiller lag. Det er en brukersynlig endring på
    vitnemålssiden, og trenger changeset.
- [x] **10. Ikke kvalifisert:** hvordan vises at fagvalget er lagret, men poengene ikke? Tilstanden er
  ikke skissert. Avventer design, eller bruk samme mønster som varselet om førstegangsvitnemål?
  (a) Vent på design. (b) Samme mønster som varselet om førstegangsvitnemål. (c) Bare Kvalifisert = Nei
  og tomme poeng i raden.
  - **Beslutning (2026-11-13):** (a) Vent på design. Visningen bygges ikke før den er skissert.
  - **Begrunnelse:** utviklerens valg. Tilstanden står under «Ikke skissert» i spec-dokumentet, og
    designeren eier den. Avhengigheten er ført opp under _Cross-contributor_ (design). Backend må
    uansett returnere et utfall fra «Bruk poeng» som sier at fagvalget er lagret, men poengene ikke.
- [x] **11. Tekster:** skal L3 vente på `velge_fag_per_poengvariant.design.md` (`fs-implementasjonsdetaljer`)
  før varseltekst og beskjed om ugyldig verdi skrives, eller bruke midlertidige tekster som designeren
  godkjenner, slik L2 gjør («Tekstene må godkjennes av designeren»)?
  (a) Midlertidige tekster. (b) Vent på `design.md`.
  - **Beslutning (2026-11-13):** (a) Midlertidige tekster. Varseltekst og beskjed om ugyldig verdi
    skrives nå, og PR-en sier at designeren må godkjenne dem, slik L2 gjør.
  - **Begrunnelse:** utviklerens valg. Arbeidet stopper ikke mens `fs-implementasjonsdetaljer` venter.
    Når `velge_fag_per_poengvariant.design.md` finnes, må tekstene sjekkes mot den. Beskjeden om
    ugyldig verdi kan bygge på de eksisterende meldingene til `validatePoints`.
- [x] **12. Feature flag:** steg 2 har ingen flag i dag, og L2 legger ikke til en. Skal L3 (med fagvalg
  som lagres) ligge bak en flag til backend er i produksjon?
  (a) Ingen flag. (b) Feature flag.
  - **Beslutning (2026-11-13):** (b) L3 legges bak et Unleash-flag til det er godkjent.
  - **Begrunnelse:** utviklerens valg. L3 endrer hvordan saksbehandleren lagrer grunnlag, og bygges i
    deler fra `main` (spørsmål 1). Flagget lar delene deployes før helheten er klar. Flagget må legges
    til i Unleash og i `src/common/types/generated/unleash.ts`. Changesetet må følge regelen for
    feature flag i `fs-admin-changesets`. Planen må avklare hva flagget skjuler når L2 allerede er ute
    uten flag, f.eks. fagtabellen, egne poeng og avkrysning av fag.
