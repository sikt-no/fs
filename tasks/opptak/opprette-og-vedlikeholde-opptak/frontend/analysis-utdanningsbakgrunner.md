# Analysis: Utdanningsbakgrunner med avvikende frister på opptak (frontend)

- **Jira:** [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381) (story), [TAKE-384](https://sikt.atlassian.net/browse/TAKE-384) (frontend-delsak). Backend: [TAKE-383](https://sikt.atlassian.net/browse/TAKE-383) (Done).
- **Oppgave:** rad «Legg til utdanningsbakgrunner for opptaket og sette avvikende frister» i `tasks/opptak/opprette-og-vedlikeholde-opptak/oppgave.md` (rad #7 i dagens tabell; Jira-beskrivelsen sier #10).
- **Repo / rolle:** fs-admin / frontend
- **Dato:** 2026-10-09

## Problem Statement

Spec-dokumentet ([spec-opprette-og-vedlikeholde-opptak.md](../spec/spec-opprette-og-vedlikeholde-opptak.md)) dekker hele «Opprette og vedlikeholde opptak». Denne analysen er avgrenset til de to reglene TAKE-381 peker på:

1. **`innstillinger.feature` (`@OPT-OVO-INN-001`), Regel: «Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket».** Opptaksforvalteren velger utdanningsbakgrunner fra tabellen over godkjente utdanningsbakgrunner, legger til flere og fjerner dem igjen.
2. **`frister_og_hendelser.feature` (`@OPT-OVO-FRI-001`), Regel: «Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister».** Opptaksforvalteren legger eksplisitt til en utdanningsbakgrunn med egen søknadsfrist og dokumentasjonsfrist. Bakgrunner uten avvikende frister trenger ikke registreres.

I Figma er dette to deler av siden «Opprett nytt Samordna opptak» (node `20606:117530`):

- **03 Innstillinger:** feltet «Godkjente utdanningsbakgrunner», en chip-liste der hver chip kan fjernes og listen åpnes med en nedtrekkspil.
- **05 Utdanningsbakgrunner med avvikende frister:** knappen «Legg til ny utdanningsbakgrunn», ett kort per bakgrunn med «Søknadsfrist» og «Frist dokumentasjon», og en «Fjern»-knapp per kort.

I dag har fs-admin ingen UI for noe av dette. Backend (TAKE-383) er ferdig og ligger i det eksperimentelle schemaet, så frontend-jobben er å koble opprett/rediger-skjemaet for opptak mot det nye API-et.

## Current State

### Sider og ruter

- `/opptak/opprett/[type]` (`src/app/opptak/opprett/[type]/page.tsx`) og `/opptak/[id]/rediger` (`src/app/opptak/[id]/rediger/page.tsx`) rendrer begge `OpptakManagementPage`. Opprett-siden velger modus med `opptakType`, rediger-siden med `opptakId`.
- Samordna opprett ligger bak flagget `opptak-opprett-samordna` (`src/app/opptak/opprett/[type]/layout.tsx`). Lokalt opprett har ikke flagg. Begge rutene krever `FS-ADMIN_MODIFISERE_OPPTAK`, og rediger krever i tillegg at brukeren tilhører eierorganisasjonen.

### Skjemaet — `src/domains/opptak/features/OpptakManagement/`

- **`OpptakManagementPage.tsx`** eier all skjematilstand i én `useState<OpptakFormState>` (L71). Tilstanden fylles fra `GET_OPPTAK_FROM_ID` (L78–83, med headeren `Feature-Flags: experimental`) i en `useEffect` (L122–142). `saveOpptak` (L148–201) kaller `opprettOpptakV3` eller `oppdaterOpptak` via konverteringsfunksjonene i `utils/convertDataToInput.tsx`.
  - Seksjonsrekkefølgen er OpptakInformation → Samordning (kun samordna) → OpptakSettings → OpptakDeadlinesSamordna (L235–270). Det finnes ingen seksjon 05.
  - **I redigeringsmodus er fristene låst:** `<fieldset disabled={editMode}>` med `TODO(mock-dont-hack): hendelser-on-edit disabled until bulk endpoint lands` (L261–270).
  - `saveDisabled` (L112–120) sperrer lagring når et fristfelt er ugyldig. Ugyldige felt samles i settet `ugyldigeHendelseKoder` (L74, L101–110), og **nøkkelen er hendelsestypekoden**.
- **`queries.ts`:**
  - `GET_OPPTAK_FROM_ID` (L3–55) henter ikke `utdanningsbakgrunner`.
  - `GET_OPPTAKHENDELSETYPER` (L76–86) henter alle hendelsestyper. `OpptakDeadlinesSamordna` kaller den med tomt kategorifilter (L84–86).
  - `CREATE_OPPTAK` (L98–111) og `OPPDATER_OPPTAK` (L113–126) sender ikke `utdanningsbakgrunner`.
- **`types.ts`** (L5): `OpptakFormState` utledes fra `GetOpptakFromIdQuery`. Nye felt i queryen endrer altså skjematypen, og `emptyOpptakData()` i `utils/emptyObjectGenerators.ts` (L6–28) må fylle dem.
- **`OpptakSettings/OpptakSettings.tsx`** har en egen query for opptakstyper og regelverksamlinger (L24–49). Til venstre ligger to `Select` og tre `NumberInput` (L136–222), til høyre et `Fieldset` med fire `ToggleSwitch` (L223–269). Feltet «Godkjente utdanningsbakgrunner» mangler.
- **`OpptakDeadlinesSamordna/OpptakDeadlinesSamordna.tsx`:**
  - Ved opprettelse initialiseres `opptak.hendelser` med én hendelse per hendelsestype (L88–127). Fristene grupperes i kort per kategori (L148–205).
  - `setHendelse` finner hendelsen som skal endres ut fra `kode` (L129–140), så komponenten forutsetter én hendelse per kode i én flat liste.
- **`utils/convertDataToInput.tsx`:**
  - Opprett (L52–86) sender `hendelser` som `OpprettOpptakshendelseV3Input`, med **rå v2-kode som `String`** (inkludert Æ/Ø/Å, se kommentaren i `OpptakDeadlinesSamordna.tsx` L110–111).
  - Oppdater (L88–111) sender verken `hendelser` eller `utdanningsbakgrunner`.

### Delte byggeklosser i nærheten

- **`src/domains/opptak/components/OpptakDeadlineInputs/OpptakDeadlineInput.tsx`** er en `InputDatepicker` med minuttoppløsning.
  - `label` er navnet på hendelsestypen (L90), og `isRequired` er sann for alt unntatt aldersberegning (L94).
  - Gyldigheten rapporteres per `hendelse.type?.kode` (L67–78).
  - Ved blur med tomt felt tilbakestilles feltet til startverdien (L115–118), så et satt felt kan ikke tømmes.
- **`OpptakDeadlinesSamordna/kodeUtils.ts`** (L8–19) oversetter mellom rå v2-kode (Æ/Ø/Å) og ASCII-enumen `OpptakshendelsestypeKode`.
- **`Samordning/components/OrganisasjonCard/OrganisasjonCard.tsx`** er nærmeste presedens på samme side for «kort med fjern-knapp»: `Surface`, `Flex` og en `Button` med `aria-label="Fjern {forkortelse}"`.
- **`src/common/components/inputs/FSCombobox/`** er den kanoniske comboboxen i fs-admin. Varianten `multiple wrap` tilsvarer chip-listen i Figma («POC v1»). Den brukes allerede i opptak av `AddUtdanningstilbud/.../UtdanningsinstansStudienivaFilter.tsx`.

### Backend-kontrakten (TAKE-383, eksperimentelt schema)

Verifisert mot `https://fs.sikt.no/api/schema/production/experimental` og `test/experimental` 2026-10-09 (likt i begge for disse typene):

- **Lesing:**
  - `Opptak.utdanningsbakgrunner: [OpptakUtdanningsbakgrunn!]` med feltene `id`, `beskrivelse: String!`, `type: OpptakUtdanningsbakgrunnstype` (`id`, `kode`, `navn`, `kanVelgesAvSoker: Boolean!`), `utloserTidligFrist: Boolean!` og `hendelser: [UtdanningsbakgrunnHendelse!]` (`id`, `hendelseTidspunkt: DateTime!`, `type: Opptakshendelsestype`).
  - `Query.opptakUtdanningsbakgrunnstyper: [OpptakUtdanningsbakgrunnstype!]` er tabellen over godkjente typer. Den inneholder også typer søkeren ikke kan velge selv (f.eks. DISP), og disse «kan ikke settes på et opptak».
- **Skriving:**
  - `OpprettOpptakV3Input.utdanningsbakgrunner` og `OppdaterOpptakInput.utdanningsbakgrunner: [OpptakUtdanningsbakgrunnInput!]` (`src/__generated__/graphql.ts` L2691–2697, L3880–3886). Ved opprettelse gir **utelatt liste NORSK + UTLAND**, og tom liste gir ingen bakgrunner. Ved oppdatering **erstatter listen alle bakgrunner**: bakgrunner som ikke er med, fjernes sammen med hendelsene sine. Utelatt liste lar bakgrunnene stå urørt.
  - `OpptakUtdanningsbakgrunnInput` (`src/__generated__/graphql.ts` L4897–4920) har feltene `utdanningsbakgrunnTypeId: ID!` (én gang per opptak, ikke-velgbare typer avvises), `beskrivelse: String!`, `utloserTidligFrist: Boolean!` og `hendelser: [HendelseInput!]`. `hendelser` erstatter hele settet for bakgrunnen, og utelatt liste ved oppdatering lar hendelsene stå urørt.
  - `HendelseInput` har feltene `opptakshendelsestypeKode: OpptakshendelsestypeKode!` (**ASCII-enum**, ikke rå streng) og `hendelseTidspunkt: DateTime!`. Hver hendelsestype kan bare forekomme én gang per bakgrunn.
  - `settUtdanningsbakgrunnHendelser(input: { utdanningsbakgrunnId, hendelser })` er en egen mutasjon som erstatter fristene på én eksisterende bakgrunn i én transaksjon.
  - `OppdaterOpptakInput.hendelser: [HendelseInput!]` finnes nå også. Den erstatter alle frister på opptaket, med særregel for `DATO_ALDERSBEREGNING`.

### Andre steder som leser utdanningsbakgrunner

- **Søknadsbehandling:**
  - `UtdanningsbakgrunnSelect.tsx` (L11–20) og `useGetUtdanningsbakgrunnOptions.tsx` (L8–15) leser `Query.utdanningsbakgrunner(filter: { opptakId })`, som returnerer typen `Utdanningsbakgrunn` («erstatter hentUtdanningsbakgrunn i admissio»). Det er ikke `Opptak.utdanningsbakgrunner`.
- **Behandlertildelingsregler:**
  - `GET_BEHANDLERTILDELINGSREGEL_UNNTAKSVALG` (`queries.ts` L69–73) bruker den globale listen `utdanningsbakgrunnstyper`, som ikke er avgrenset til opptaket.
- **Opptakets detaljside:**
  - `GET_OPPTAK_DETAILS` viser hverken innstillinger eller utdanningsbakgrunner.

## Key Findings

- **Backend er klar, frontend mangler alt.** Det finnes ingen query-felt, ingen input-mapping og ingen UI. Feltene for lesing og skriving finnes i schemaet, og typene for input ligger allerede i `src/__generated__/graphql.ts`, fordi codegen bruker det eksperimentelle schemaet.
- **Én liste i backend, to steder i designet.** Backend har én liste, `Opptak.utdanningsbakgrunner`, der hver bakgrunn kan ha frister. Figma viser to separate steder:
  - chip-listen i Innstillinger, som er settet av bakgrunner i opptaket;
  - kortene for avvikende frister, som er bakgrunnene i opptaket som har frister.

  Hvordan de to henger sammen, var ikke spesifisert, og er nå avgjort i beslutning 2–3: de er uavhengige, og seksjon 05 velger fra hele tabellen. Backend kan likevel ikke uttrykke et «kort uten chip», og det er en blokkerende backend-avhengighet.
- **Fjerning er destruktivt i backend.** Når en bakgrunn tas ut av listen ved `oppdaterOpptak`, slettes også hendelsene dens. Fjerner man en chip for en bakgrunn som har et kort, kan dagens API ikke beholde fristavviket (beslutning 3).
- **To kodeformater for hendelsestyper.**
  - De generelle fristene sendes ved opprettelse som rå v2-streng med Æ/Ø/Å (`OpprettOpptakshendelseV3Input.opptakshendelsestypeKode: String!`).
  - Bakgrunnsfrister (`HendelseInput`) krever ASCII-enumen `OpptakshendelsestypeKode`.

  `kodeUtils.getOpptakshendelsestypeKode` finnes, men brukes ikke i input-mappingen i dag.
- **Fristtyper per bakgrunn var uavklart. Avgjort i beslutning 1:** `SOKNADSFRIST_ORDINAER` + `FRIST_ORDINAER_OPPLASTING`, og backend må bekrefte. Designet viser «Søknadsfrist» og «Frist dokumentasjon», men ikke hvilke `OpptakshendelsestypeKode` de svarer til. Enumen har både vanlige koder (`SOKNADSFRIST_ORDINAER`, `FRIST_ORDINAER_OPPLASTING`) og mer spesialiserte (`SOKNADSFRIST_SAERSKILT_VURDERING`, `FRIST_REALKOMPETANSE`, `TIDLIG_SOKNADSFRIST`, `FRIST_TIDLIG_OPPLASTING`). `GET_OPPTAKHENDELSETYPER` henter alle typer uten kategorifilter, så hvis de bakgrunnsspesifikke typene er i den listen, vises de også i de generelle fristene.
- **Gjenbruk av fristfeltene kolliderer på kode.** `OpptakDeadlineInput` og `OpptakManagementPage` holder gyldighet per hendelsestypekode i ett felles sett, og `setHendelse` i `OpptakDeadlinesSamordna` matcher også på kode. To kort med samme fristtype, eller samme fristtype både generelt og per bakgrunn, vil overskrive hverandres gyldighetsstatus.
- **To påkrevde inputfelt finnes ikke i designet.** `OpptakUtdanningsbakgrunnInput` krever `beskrivelse: String!` og `utloserTidligFrist: Boolean!`, men ingen av dem vises i Figma.
- **Redigering er asymmetrisk.** De generelle fristene er låst i redigeringsmodus (venter på «bulk endpoint»). `oppdaterOpptak` tar nå både `hendelser` og `utdanningsbakgrunner[].hendelser`, så backend-forutsetningen for låsen ser ut til å være oppfylt. Å oppheve den låsen er likevel ikke en del av TAKE-384. Avvikende frister kan redigeres i redigeringsmodus (beslutning 6).
- **Backend-default kan gi skjulte bakgrunner.** Hvis frontend utelater `utdanningsbakgrunner` ved opprettelse, får opptaket NORSK + UTLAND uten at brukeren ser det i skjemaet. Beslutning 4: listen starter tom, sendes alltid og er påkrevd (minst én).
- **Ikke-velgbare typer må filtreres bort.** Typer med `kanVelgesAvSoker: false`, som DISP, må holdes ute av valgene, ellers avviser backend lagringen.
- **Ingen mønster-match.** `fs-admin-patterns` ga ingen treff (detaljside, listeside og domene-indeks scorer alle under 90). Dette er en skjemaseksjon i et eksisterende opprett/rediger-skjema, og nærmeste presedens er seksjonene på samme side (Samordning med `OrganisasjonCard`, `OpptakDeadlinesSamordna`).
- **Nummereringen er utdatert.** Jira-beskrivelsen peker på oppgave #10 i `oppgave.md`, men raden er nå #7 (#10 er hendelseslogg). «med hendelser» i tittelen på TAKE-384 betyr frister (opptakshendelser), ikke hendelseslogg.

## Technical Constraints

- **CLAUDE.md, UI-føring:**
  - Bruk SDS og felleskomponenter direkte (`FSCombobox`, `Surface`, `Flex`/`Grid`, `InputDatepicker`/`OpptakDeadlineInput`).
  - Ingen egen CSS på input-feltene. Layouten skal uttrykkes med `<Grid>`/`<Flex>`, og nye `.module.css` skal ikke inneholde `display: flex/grid` (`fs-admin-grid-and-flex`).
  - Komponentene skrives som `function`, og hver ny komponent trenger `*.a11y.test.tsx`.
- **`fs-admin-buttons`:**
  - «Legg til ny utdanningsbakgrunn» er en handlingsetikett. Merk at regelen om bare `"Opprett"` gjelder opprett-knapper, ikke «legg til».
  - «Fjern» trenger en entydig `aria-label` per kort, slik som `fjernOrganisasjon` i Samordning.
  - Lagring er asynkron. Dagens Lagre-knapp viser verken lastetilstand eller `disabled` mens lagringen pågår (`OpptakManagementPage.tsx` L282–292). Det er en eksisterende avvik, ikke noe denne saken skal rydde opp i.
- **`fs-admin-inputs`:** Etiketter beskriver verdien («Godkjente utdanningsbakgrunner», «Søknadsfrist»), ikke handlingen. Plassholdertekst brukes bare for format. Påkrevde felt markeres etter dagens konvensjon (`RequiredFieldLabel`). Her bruker OpptakSettings fortsatt den eldre varianten `helpText={tCommon('required')}`.
- **`fs-admin-modal`:** Hvis «Legg til ny utdanningsbakgrunn» åpner en dialog, skal den bruke `FSModal`. Samordning sin `InviterOrganisasjonerModal` er presedens på samme side.
- **`graphql-consumer` / CLAUDE.md:** Spørringer skal ligge nær komponenten. Bruk `refetchQueryNames(...)` og aldri `__typename` i spørringene. Nye felt i `GET_OPPTAK_FROM_ID` endrer `OpptakFormState`, så kjør `npm run compile` (graphql-codegen). Utdanningsbakgrunn-API-ene er eksperimentelle:
  - `GET_OPPTAK_FROM_ID` sender `Feature-Flags: experimental`.
  - `CREATE_OPPTAK`/`OPPDATER_OPPTAK` gjør det ikke.

  Det må verifiseres om gatewayen godtar eksperimentelle inputfelt i mutasjonene uten headeren.
- **i18n (`fs-admin-i18n-structure`):** Tekstene ligger i `src/common/messages/nb/opptak.json` under komponentnavnet (`OpptakSettings`, `OpptakDeadlines`, `Samordning` …). En ny komponent for seksjon 05 trenger sin egen toppnøkkel.
- **Tidssone:** Frister sendes som UTC via `toISOString(…, TIMEZONE_EUROPE_OSLO)` / `formatToUTC`, og `HendelseInput.hendelseTidspunkt` er `DateTime!`.
- **Domeneavgrensning:** Hold endringene innenfor `src/domains/opptak/`. Ikke endre delte filer (`src/common/`, `src/app/` utover ruter for opptak) uten at det er nødvendig.
- **Changeset:** Endringen er synlig for brukeren, så den trenger et changeset med prefikset `Opptak:` (`fs-admin-changesets`). Samordna opprett ligger bak `opptak-opprett-samordna`, så om changesetet skal nevne flagget, avgjøres i den skillen.

## Dependencies

- **Internt i fs-admin:**
  - `OpptakManagementPage`, `queries.ts`, `types.ts`, `utils/convertDataToInput.tsx`, `utils/emptyObjectGenerators.ts`, `OpptakSettings` og eventuelt `OpptakDeadlinesSamordna` / `OpptakDeadlineInput`.
  - Eksisterende tester: `OpptakManagementPage.test.tsx`, `OpptakManagementPage.a11y.test.tsx`, `OpptakSettings.test.tsx` / `.a11y.test.tsx`, `convertDataToInput.test.tsx` og `emptyObjectGenerators.test.ts`.
- **Eksternt:**
  - Supergraf-gatewayen med det eksperimentelle schemaet, der `opptakUtdanningsbakgrunnstyper`, `Opptak.utdanningsbakgrunner` og input-feltene ligger.
  - SDS-pakkene `@sikt/sds-combobox` (via `FSCombobox`) og `@sikt/sds-input-datepicker`.
- **Andre bidragsytere:**
  - **Backend (TAKE-383 / Tuva Hassel Stang):**
    - Bekreft fristkodene fra beslutning 1 (`SOKNADSFRIST_ORDINAER` + `FRIST_ORDINAER_OPPLASTING` per bakgrunn).
    - Avklar hvilke verdier `beskrivelse` og `utloserTidligFrist` skal ha.
    - **Ny, blokkerende for «kort uten chip» (beslutning 2):** Backend trenger en måte å lagre fristavvik på en bakgrunn som ikke er valgbar i opptaket, for eksempel et flagg på `OpptakUtdanningsbakgrunn`/`OpptakUtdanningsbakgrunnInput` eller separat lagring.
    - Utvikler opplyser at standarden NORSK + UTLAND ved utelatt liste er en midlertidig løsning, og at `utdanningsbakgrunner` skal bli påkrevd i API-et.
  - **Backend, søker og søknadsbehandling ([TOT-1733](https://sikt.atlassian.net/browse/TOT-1733), In progress, team Tind):** At søkere faktisk kan velge blant opptakets bakgrunner og får riktige frister. Ifølge TOT-1733 ligger opptakets bakgrunner og frister nå i `opptak_v2.utdanningsbakgrunn` og `opptak_v2.utdanningsbakgrunn_hendelse` (TAKE-356), men `Query.utdanningsbakgrunner(filter: { opptakId })` leser fortsatt den **gamle** `soknad_v2.utdanningsbakgrunn`. Bakgrunner som settes via TAKE-384, vises derfor **ikke** i fs-admins søknadsbehandling (`UtdanningsbakgrunnSelect`, `SakUtdanningsbakgrunnFilter`) før TOT-1733 er levert. Krav-scenariet «søkere kan velge blant dem» kan ikke verifiseres fra fs-admin før da.
  - **Design:** Ordlyd og plassering av infoteksten for «kort uten chip», og om de gamle fristene for realkompetanse og tidlig frist i den generelle griden skal ryddes (se _Å sjekke med design og backend_).
  - **Tilgrensende sak:** [STEK-484](https://sikt.atlassian.net/browse/STEK-484) (Backlog) handler om at fristen `FRIST_SELVBETJENING_UTDANNINGSBAKGRUNN` (krav: «frist for endring av utdanningsbakgrunn») ikke vises i opprett/rediger. Det er en egen sak, men den rører den samme fristgriden.

## Requirements Impact

- **Krav som er dekket i dag:** ingen av de to reglene. fs-admin leser og skriver ikke utdanningsbakgrunner på opptak.
- **`@OPT-OVO-INN-001`, Regel «Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket»:**
  - «Legge til utdanningsbakgrunner fra godkjent liste»: datakilden (`opptakUtdanningsbakgrunnstyper`) finnes. Typer med `kanVelgesAvSoker: false` må filtreres bort.
  - «Legge til flere utdanningsbakgrunner»: dekkes av multi-select. Delen «søkere kan velge blant dem» ligger utenfor fs-admin, se TOT-1733.
  - «Fjerne en utdanningsbakgrunn fra opptaket»: **i risiko.** Backend sletter også bakgrunnens frister. Beslutning 3 lar kortet bli stående med infotekst, men dagens API kan ikke lagre det (se beslutning 2).
- **`@OPT-OVO-FRI-001`, Regel «Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister»:**
  - «Legge til utdanningsbakgrunn med avvikende frister»: **i risiko.** Mappingen fra fristtype til kode er valgt (beslutning 1), men ikke bekreftet av backend. Fristfeltene kolliderer på kode, og «kort uten chip» er blokkert av API-et.
  - «Søker uten registrert utdanningsbakgrunn følger ordinære frister»: dette er et krav til søknad og saksbehandling. Beslutning 7 tillater kort uten frister (`hendelser: []`). Det er ufarlig for fristene, men et tomt kort uten chip legger bakgrunnen inn i opptaket.
- **Redigering:** I tråd med Bakgrunn («opptaket … er opprettet») gjelder kravene også et eksisterende opptak. Beslutning 6: avvikende frister kan redigeres via `oppdaterOpptak.utdanningsbakgrunner`, mens de generelle fristene fortsatt er låst.
- **Mangler i kravene:**
  - Kravene sier ikke hvordan chip-listen og fristkortene henger sammen, eller hva «Fjern» gjør. Det er nå avgjort i beslutning 2–3, og kravene bør oppdateres tilsvarende (`fs-krav` i sikt-no/fs).
  - Felles regel for frister: «I samordna opptak kan kun opptaksforvalter ved forvaltende organisasjon endre frister». Ruteguarden på `/rediger` sjekker eierorganisasjonen, så dette ser ut til å være dekket, men det bør bekreftes for samordna opptak.
  - Hjelpeteksten i Figma sier at valget også bestemmer hvilke bakgrunner som kan brukes i saksbehandlertildelingsreglene. Unntakstabellen der bruker i dag den globale listen `utdanningsbakgrunnstyper`. Dette er utenfor scope, men verdt å nevne.
  - Detaljsiden for opptaket (`OpptakDetails`) viser ikke bakgrunnene. Det står ikke i krav eller design, og etter beslutning 8 er det utenfor scope.
  - Kravet sier ikke at minst én utdanningsbakgrunn er påkrevd, men det er besluttet (beslutning 4) og bør inn i `innstillinger.feature`.

## Krav-input referanse

- **Spec-dokument:** [`spec-opprette-og-vedlikeholde-opptak.md`](../spec/spec-opprette-og-vedlikeholde-opptak.md)
- **Krav-input-manifest:** [`krav-input/manifest.md`](../spec/krav-input/manifest.md)
- **Skisser:** [`05-utdanningsbakgrunner-avvikende-frister.png`](../spec/krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/sub-frames/05-utdanningsbakgrunner-avvikende-frister.png), [`03-innstillinger-section.png`](../spec/krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/sub-frames/03-innstillinger-section.png). Nyere Figma-node fra utvikler: [`21751:285722`](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=21751-285722&m=dev) («TEST Plassflyt V1»). Den er ikke lagret i `krav-input/`, og en ny kjøring av `fs-specify` vil ta den med.

Kravkopiene i `krav-input/` er fra 2026-09-30. Reglene om utdanningsbakgrunner er uendret på `main` i sikt-no/fs per 2026-10-09. Eneste endringer er retagging (`@planned` → `@in-progress`, ID `OPT-OPT-*` → `OPT-OVO-*`) og to tekstjusteringer under informasjonsdatoer for opptaksresultat.

## Å sjekke med design og backend

Huskeliste for utvikler, samlet fra gjennomgangen av de åpne spørsmålene 2026-10-09.

**Backend (Tuva / TAKE-383):**
- [ ] **Fristkoder per bakgrunn:** Bekreft at «Søknadsfrist» / «Frist dokumentasjon» på en utdanningsbakgrunn skal være `SOKNADSFRIST_ORDINAER` / `FRIST_ORDINAER_OPPLASTING` (beslutning 1). De ligger samlet i én konstant i frontend.
- [ ] **Kort uten chip (blokkerende):** Gi mulighet til å lagre fristavvik på en bakgrunn som *ikke* er valgbar for søkere i opptaket (beslutning 2). Dagens `Opptak.utdanningsbakgrunner` gjør alt valgbart.
- [ ] **`beskrivelse` og `utloserTidligFrist`:** Frontend sender typens navn og `false` for nye bakgrunner (beslutning 5). Kan feltene bli valgfrie eller utledes i backend? Er `utloserTidligFrist` fortsatt i bruk nå som bakgrunner har egne frister?
- [ ] **Standard NORSK + UTLAND:** Fjern standarden ved utelatt liste og gjør `utdanningsbakgrunner` påkrevd i API-et (beslutning 4, utviklerens plan).
- [ ] **Mutasjoner og experimental-header:** Godtar gatewayen de eksperimentelle `utdanningsbakgrunner`-feltene i `opprettOpptakV3`/`oppdaterOpptak` uten headeren `Feature-Flags: experimental`?

**Design:**
- [ ] **Infotekst for «kort uten chip»:** Ordlyd og plassering (beslutning 2). Henger sammen med backend-punktet over.
- [ ] **Hjelpefelt i designet:** Bekreft at `beskrivelse` og «utløser tidlig frist» ikke skal vises i UI-et (beslutning 5).
- [ ] **Gamle frister i den generelle griden:** `FRIST_REALKOMPETANSE` («Realkompetansesøkere»), `TIDLIG_SØKNADSFRIST` og `FRIST_TIDLIG_OPPLASTING` overlapper seksjon 05 (følgefunn under beslutning 1).

## Open Questions

- [x] **1. Hvilke hendelsestypekoder er «Søknadsfrist» og «Frist dokumentasjon» på en utdanningsbakgrunn?**
  - (a) De samme kodene som de generelle fristene (`SOKNADSFRIST_ORDINAER` + `FRIST_ORDINAER_OPPLASTING`), gjeldende for bakgrunnen.
  - (b) Egne koder (f.eks. `SOKNADSFRIST_SAERSKILT_VURDERING` / `FRIST_REALKOMPETANSE`, eller `TIDLIG_SOKNADSFRIST` / `FRIST_TIDLIG_OPPLASTING`). Da må de trolig også holdes ute av de generelle fristene.
  - (c) Backend eksponerer en hendelseskategori for bakgrunnsfrister som frontend filtrerer på.

  **Beslutning (2026-10-09): (a).** `SOKNADSFRIST_ORDINAER` + `FRIST_ORDINAER_OPPLASTING` per bakgrunn, samlet i én konstant. Mappingen bekreftes med backend (Tuva, TAKE-383) før den skrives.

  **Begrunnelse:**
  - «Avvikende» leses som at bakgrunnen får sin egen versjon av de ordinære fristene. Det passer med designets «Søknadsfrist» / «Frist dokumentasjon».
  - Kodene finnes allerede i den generelle fristgriden, så de vises ikke to ganger.
  - Den nye modellen kommer fra TAKE-356 («tidlig frist»), og SDL-beskrivelsen av `OpptakUtdanningsbakgrunn.hendelser` sier «f.eks. tidlig frist». Det trekker mot (b), men backend låser ikke kodene (`HendelseInput` godtar hele enumen, én gang per type og bakgrunn).

  Fordi kodene ligger i én konstant, blir et annet svar fra backend en endring på én linje. **Følgefunn:** Den gamle modellen satte avvikende frister på opptaksnivå, med `utloserTidligFrist` på bakgrunnen og fristene `TIDLIG_SØKNADSFRIST`, `FRIST_TIDLIG_OPPLASTING` og `FRIST_REALKOMPETANSE` («Realkompetansesøkere»). Disse vises fortsatt i den generelle griden og kan bli overflødige eller forvirrende ved siden av seksjon 05. Det tas opp med fagsiden og er ikke en del av TAKE-384.
- [x] **2. Hvordan henger chip-listen i Innstillinger sammen med fristkortene i seksjon 05?**
  - (a) Kort kan bare legges til for bakgrunner som allerede er valgt i Innstillinger.
  - (b) «Legg til ny utdanningsbakgrunn» i seksjon 05 legger også bakgrunnen til i opptaket, og den dukker opp i chip-listen.
  - (c) To uavhengige visninger av samme liste, der alt synkes i én tilstand.

  **Beslutning (2026-10-09): først (a), revidert samme dag til uavhengige lister (se under).** De to stedene har ulike oppgaver:
  - **Chip-listen (FSCombobox `multiple`)** bestemmer hvilke bakgrunner som gjelder i opptaket. Det er disse søkere, og forvaltere av utdanningstilbud i opptaket, kan velge.
  - **Seksjon 05** setter bare *avvik* fra de to generelle fristene (ordinær søknadsfrist og ordinær dokumentasjonsfrist), og bare der et avvik finnes.

  ~~I første omgang velger «Legg til ny utdanningsbakgrunn» blant bakgrunnene som er valgt i chip-listen og som ikke har kort fra før.~~ **Revidert samme dag (under spørsmål 4):** «Legg til ny utdanningsbakgrunn» i seksjon 05 velger fra **hele** tabellen (`opptakUtdanningsbakgrunnstyper`, unntatt typer med `kanVelgesAvSoker: false`), uavhengig av chip-listen.

  **Oppfølging: kort uten chip.** Det brukeren legger inn, lagres, og det skal være lite automatikk. Et kort for en bakgrunn som ikke er valgt i chip-listen, legger ikke til chipen. Kortet viser i stedet en liten infotekst eller etikett om at fristendringen ikke kan brukes før bakgrunnen legges til i listen over. Brukeren kan lagre og rette opp senere.

  **⚠ Konflikt med API-et, blokkerer «kort uten chip».** Backend har én liste, `Opptak.utdanningsbakgrunner`, og alt i den kan velges av søkere. `OpptakUtdanningsbakgrunn` har ikke noe felt som skiller «valgt for opptaket» fra «har bare avvikende frister».

  Med dagens API skjer dette når et kort uten chip lagres:
  1. Bakgrunnen legges inn i opptakets liste og blir valgbar for søkere. Infoteksten stemmer da ikke.
  2. Ved ny innlasting kommer bakgrunnen tilbake som en vanlig bakgrunn, og frontend kan ikke vise den som «kort uten chip».

  Ønsket oppførsel krever en backend-endring, for eksempel et flagg på `OpptakUtdanningsbakgrunn`/`OpptakUtdanningsbakgrunnInput` som sier om bakgrunnen er valgbar i opptaket, eller separat lagring av fristavvik. Se _Dependencies → Backend_.

  **Begrunnelse:** Utviklerens valg. Seksjon 05 er et selvstendig verktøy for fristavvik, og koblingen til hva søkeren kan velge skal være tydelig, men ikke automatisk.

  Bekreftet mot Figma-node [`21751:285722`](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=21751-285722&m=dev) («TEST Plassflyt V1»), som er nyere enn skissen i spec-en (`20606:117530`). Seksjon 05 har samme oppbygging der, og de generelle fristene har fått undertittelen «Gjelder alle utdanningstilbud og utdanningsbakgrunner som ikke har avvikende frister.»
- [x] **3. Hva gjør «Fjern» på et fristkort?**
  - (a) Fjerner bare fristene. Bakgrunnen blir i opptaket og følger de generelle fristene.
  - (b) Fjerner bakgrunnen fra opptaket.

  Og omvendt: skal det å fjerne en chip i Innstillinger varsle når bakgrunnen har avvikende frister? Alternativene var å fjerne kortet stille, å vise en bekreftelse, eller å sperre chipen så lenge kortet finnes.

  **Beslutning (2026-10-09): (a).** «Fjern» på kortet fjerner bare fristavviket. Bakgrunnen blir i opptaket hvis den er valgt i chip-listen, og ved lagring sendes `hendelser: []` for den. Ingen bekreftelsesdialog, siden ingenting lagres før «Lagre».

  ~~Når chipen fjernes i Innstillinger, forsvinner kortet samtidig.~~ **Revidert som følge av revidert beslutning 2:** Kort og chips er uavhengige, og det skal være lite automatikk. Når chipen fjernes, blir kortet stående og får infoteksten for «kort uten chip». Hvordan dette lagres, avhenger av den samme API-konflikten som under spørsmål 2. Med dagens API sletter backend fristene til en bakgrunn som tas ut av listen.
- [x] **4. Hvilke utdanningsbakgrunner skal et nytt opptak ha som standard?** Backend gir NORSK + UTLAND når listen utelates.
  - (a) Utelat listen når brukeren ikke har endret den, og la backend sette standarden.
  - (b) Forhåndsvelg NORSK + UTLAND i chip-listen, så standarden er synlig, og send alltid listen.
  - (c) Start med tom liste og send alltid listen.

  **Beslutning (2026-10-09): (c), og feltet er påkrevd.**
  - Chip-listen starter tom og sendes alltid.
  - Minst én utdanningsbakgrunn må være valgt før opptaket kan lagres, både ved opprettelse og redigering.
  - Feltet markeres som påkrevd etter konvensjonen (`RequiredFieldLabel`), og regelen tas med i `saveDisabled` i `OpptakManagementPage`.

  **Begrunnelse (fra utvikler):** Standarden NORSK + UTLAND i backend er en midlertidig løsning som skal fjernes, og feltet skal etter hvert bli påkrevd også i API-et. Frontend skal derfor ikke bygge på den.
- [x] **5. Hva skal de påkrevde feltene `beskrivelse` og `utloserTidligFrist` inneholde?**
  - (a) Sett dem i frontend: `beskrivelse` = typens `navn` og `utloserTidligFrist` = `false`.
  - (b) Vis dem i UI-et.
  - (c) Be backend gjøre dem valgfrie eller utlede dem.

  **Beslutning (2026-10-09): (a), den enkleste løsningen (utvikler: «gjør det enkleste»).**
  - Nye bakgrunner får `beskrivelse` = typens `navn` og `utloserTidligFrist` = `false`.
  - Eksisterende bakgrunner fra `GET_OPPTAK_FROM_ID` beholder verdiene sine uendret.

  **Begrunnelse:** Blokkerer ikke implementasjonen, krever ingen nye felt utenfor designet, og overskriver ikke data som allerede er satt. Står også på listen _Å sjekke med design og backend_.
- [x] **6. Skal avvikende frister kunne redigeres på et eksisterende opptak?**
  - (a) Ja, via `oppdaterOpptak.utdanningsbakgrunner[].hendelser` i samme lagring.
  - (b) Ja, via `settUtdanningsbakgrunnHendelser` per bakgrunn.
  - (c) Nei, de låses som de generelle fristene i dag.

  Uansett svar: å oppheve låsen på de *generelle* fristene (nå som `oppdaterOpptak.hendelser` finnes) bør være en egen sak og ikke en del av TAKE-384.

  **Beslutning (2026-10-09): (a).**
  - Chip-listen og fristkortene kan redigeres i redigeringsmodus.
  - Når man trykker «Lagre», sendes hele listen som `oppdaterOpptak.utdanningsbakgrunner`, med `hendelser` per bakgrunn. Det er én mutasjon og én transaksjon, som for de andre innstillingene.
  - Seksjon 05 skal derfor ikke ligge inni `<fieldset disabled={editMode}>`.
  - Låsen på de generelle fristene blir stående og håndteres i en egen sak.

  **Begrunnelse:**
  - Bakgrunnene og avvikene deres lagres atomisk.
  - Det trengs ingen bakgrunns-id før første lagring, slik (b) ville krevd.
  - Det følger mønsteret ellers i `saveOpptak`.
- [x] **7. Hvilke frister må fylles ut på et kort?**
  - (a) Begge er påkrevd.
  - (b) Minst én.
  - (c) Begge er valgfrie, og et kort uten frister betyr ingen avvik. Det krever at et fristfelt kan tømmes, noe `OpptakDeadlineInput` ikke støtter i dag.

  **Beslutning (2026-10-09): (c).**
  - Begge fristene på et kort er valgfrie.
  - Et tomt felt betyr at bakgrunnen følger den generelle fristen.
  - Et kort uten frister lagres med `hendelser: []`.

  **Begrunnelse:** Utviklerens valg, i tråd med «lite automatikk». Det brukeren legger inn, lagres, og kan rettes senere.

  **Konsekvenser for implementasjonen:**
  - **Feltene må kunne tømmes.** `OpptakDeadlineInput` setter i dag `isRequired` for alle frister utenom aldersberegning, og et tomt felt tilbakestilles ved blur (L94, L115–118). Felt som kan tømmes må støttes. Aldersberegning-grenen (`onHendelseChange(kode, undefined)`) er presedens. Alternativt brukes `InputDatepicker` direkte.
  - **Tomme kort kan legge til bakgrunner.** Et tomt kort for en bakgrunn som ikke er valgt i chip-listen, legger bakgrunnen inn i opptaket uten avvik. Det er samme API-konflikt som under beslutning 2.
- [x] **8. Skal opptakets detaljside (`OpptakDetails`) vise valgte bakgrunner og avvikende frister?**
  - (a) Nei, det er utenfor TAKE-384.
  - (b) Ja, som read-only i en egen seksjon.

  **Beslutning (2026-10-09): (a) for detaljsiden.** Bakgrunnene og avvikene vises og redigeres på «Rediger opptak» (`/opptak/[id]/rediger`) på samme måte som ved opprettelse. Utvikler: «du kan legge de til på samme måte på rediger opptak».

  **Begrunnelse:** Begge rutene rendrer `OpptakManagementPage`, så chip-listen og seksjon 05 blir med på rediger-siden uten egen innsats (se beslutning 6). `OpptakDetails` endres ikke.
