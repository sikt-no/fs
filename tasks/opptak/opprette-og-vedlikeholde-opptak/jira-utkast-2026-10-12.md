# Utkast til Jira-saker — opprette og vedlikeholde opptak

Fra verifiseringen 2026-10-12 ([rapporten](../../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/verify-11%20Opprette%20og%20vedlikeholde%20opptak-2026-10-12-1220.md)) sammenlignet med sakene under epicen [TAKE-318](https://sikt.atlassian.net/browse/TAKE-318). Utkast, ikke opprettet i Jira.

Kodereferansene er fra fs-plattform `5f808f1e09`, fs-admin `c5718833a` og min-kompetanse `ddb661fd`.

---

## Del 1: Justere saker som finnes

### 1.1 Kommentar på TAKE-395 «Frontend må støtte alle språk»

> Kravet er endret 2026-10-12: navn på **bokmål, nynorsk og engelsk** er obligatorisk (`@OPT-OVO-GRU-001`, regelen «Opptaket må ha navn på bokmål, nynorsk og engelsk»). Grenen `maada/TAKE-395` krever bokmål og nynorsk, men ikke engelsk. Opptaket skal ikke kunne lagres når ett av de tre mangler.
>
> fs-plattform validerer ikke språkene i dag: `lagreOversatteNavn` hopper over tomme språk (`OpprettOpptakMutations.java:166-168, 344-349`). Bør tas i TAKE-397/TAKE-401, eller i en egen backend-sak.

### 1.2 Ny underoppgave under TAKE-381 «Legg til utdanningsbakgrunner for opptaket og sette avvikende frister»

- **Type:** Sub-task (backend)
- **Tittel:** BE: Utdanningsbakgrunner og avvikende frister på opptaket skal gjelde for søkeren
- **Beskrivelse:**
  - Det forvalteren legger til, lagres i `opptak_v2.utdanningsbakgrunn` (`OpptakUtdanningsbakgrunner.java:72-96`). Søkeren velger og sjekkes mot `soknad_v2.utdanningsbakgrunn` (`StudiekurvService.java:41, 209-216`), som alltid får NORSK og UTLAND når opptaket opprettes (`OpprettOpptakMutations.java:116, 358-374`).
  - Ingen søknadskode leser fristene per utdanningsbakgrunn (`utdanningsbakgrunn_hendelse`). Alle søkere følger opptakets frister.
- **Akseptansekriterier** (`@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`):
  - Søkeren kan bare velge utdanningsbakgrunnene som er lagt til opptaket.
  - En utdanningsbakgrunn som fjernes fra opptaket, kan ikke lenger velges.
  - Søkere med en utdanningsbakgrunn som har avvikende frister, får de fristene. Andre følger opptakets frister.

### 1.3 Ny sak under TAKE-318 (oppfølging av TAKE-320, som er Done)

- **Type:** Story
- **Tittel:** Tidlig opptak: lenke til informasjon, flagget på opptaket i saksbehandlingen, og én fristkode for dokumentasjon
- **Beskrivelse:**
  - Lenken til informasjon om tidlig opptak finnes ikke. min-kompetanse har en hardkodet lenke (`tidlig-opptak-section.tsx:28`).
  - Saksbehandlingen leser bare flagget på utdanningstilbudet, ikke på opptaket (`TidligopptakTilbudsgarantiService.java:263-305`). fs-plattform slipper søkeren til når opptaket *eller* tilbudet tilbyr tidlig opptak (`SokTidligOpptakService.java:98-118`), min-kompetanse krever begge (`has-tidlig-opptak.ts:13-17`).
  - Det finnes to koder for dokumentasjonsfristen: `FRIST_TIDLIG_OPPLASTING` (V280) og `FRIST_TIDLIGOPPTAK_OPPLASTING` (V380). min-kompetanse viser bare den første.
- **Akseptansekriterier** (`@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`):
  - Opptaksforvalter kan sette én lenke per opptak til informasjon om tidlig opptak, og søkeren ser den i Min kompetanse.
  - Aktiveres tidlig opptak på opptaket, gjelder det både for søknaden og saksbehandlingen, og fs-plattform og min-kompetanse tolker flagget likt.
  - Dokumentasjonsfristen for tidlig opptak har én kode, og søkeren ser fristen forvalteren har satt.

---

## Del 2: Nye saker

Alle under epicen TAKE-318.

### 2.1 Endre frister på et opptak som finnes

- **Type:** Story · **Prioritet:** Høy (før 16. november)
- **Repo:** fs-admin (og fs-plattform hvis bulk-endepunktet mangler)
- **Beskrivelse:** Fristene er låst når opptaket redigeres (`OpptakManagementPage.tsx:277-286`, «hendelser-on-edit disabled until bulk endpoint lands»), og `convertOpptakDataToOppdaterOpptakInput` sender ikke hendelser (`convertDataToInput.tsx:112-126`). Alle frister må i dag settes når opptaket opprettes.
- **Akseptansekriterier** (`@OPT-OVO-FRI-001`, `@OPT-OVO-SAM-001` «Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger»):
  - Opptaksforvalter ved forvaltende organisasjon kan endre alle fristene på et opptak som finnes.
  - Frister som ingen kode bruker, er ikke obligatoriske ved oppretting (`OpptakManagementPage.tsx:126-129`).

### 2.2 Maks antall søknadsalternativer lagres ikke

- **Type:** Bug · **Prioritet:** Høy
- **Repo:** fs-admin
- **Beskrivelse:** Feltet i `OpptakSettings.tsx:209-223` skriver til `maksAntallUtdanningstilbud`, som bare kan leses (`opptak.graphqls:289`). Verken opprett- eller oppdater-inputen sender `maksSoknadsalternativer` (`convertDataToInput.tsx:71-126`). fs-plattform håndhever taket (`StudiekurvService.java:452-458`).
- **Akseptansekriterier** (`@OPT-OVO-INN-001` «Sette maks antall søknadsalternativer»):
  - Tallet forvalteren setter, lagres, og søkeren kan ikke legge til flere søknadsalternativer enn det.

### 2.3 Lokale opptak: skjule saksbehandlertildeling i fs-admin

- **Type:** Story · **Prioritet:** Middels
- **Repo:** fs-admin
- **Beskrivelse:** Lokale opptak skal fortsatt kunne opprettes som i dag. Det er ikke gitt at skillet mellom samordna og lokale opptak skal bevares, så det er nok at brukergrensesnittet sperrer (avklart 2026-10-12). API-et trenger ikke endres. fs-admin skjuler allerede samordning for lokale opptak, men feltet «Saksbehandlertildeling» vises på utdanningstilbud i lokale opptak (`UtdanningstilbudDetails.tsx:591-608`), og det samme gjør massehandlingen «Sett saksbehandlertildeling» (`UtdanningstilbudBatchActions.tsx:69-79`).
- **Akseptansekriterier** (`@OPT-OVO-SAM-001` «Saksbehandlertildeling er ikke relevant for lokale opptak»):
  - Lokale opptak kan opprettes som før.
  - Opptaksforvalter ser ikke muligheten til å sette saksbehandlertildeling, verken på et utdanningstilbud eller som massehandling, i et lokalt opptak.

### 2.4 Håndheve fristene for redigering av utdanningstilbud

- **Type:** Story
- **Repo:** fs-plattform
- **Beskrivelse:** `REDIGERING_STUDIER_ÅPNER` og `REDIGERING_STUDIER_FRIST` lagres, men leses ikke av mutasjonene på utdanningstilbud.
- **Akseptansekriterier** (`@OPT-OVO-FRI-001`):
  - Lærestedene kan knytte til og redigere utdanningstilbud bare mellom åpne- og stengedatoen.
  - Etter fristen kan antall studieplasser fortsatt endres fram til første plasstildelingsrunde.
  - Etter fristen kan bare opptaksforvalter ved forvaltende organisasjon trekke utdanningstilbud.

### 2.5 Håndheve frist for sletting av søknadsalternativer og ordinær dokumentasjonsfrist

- **Type:** Story
- **Repo:** fs-plattform
- **Beskrivelse:** `FRIST_SLETTE_STUDIER` og `FRIST_ORDINÆR_OPPLASTING` lagres, men brukes ikke. Opplasting sjekker bare ettersendingsfristen (`StudiekurvService.java:349`). min-kompetanse viser dokumentasjonsfristen som tekst (`file-upload-section.tsx:55`).
- **Akseptansekriterier** (`@OPT-OVO-FRI-001`):
  - Søkeren kan ikke slette søknadsalternativer etter fristen.
  - Det som skjer etter den ordinære dokumentasjonsfristen, er avklart og bygget. (Avklar: stenges opplasting, eller regnes det som ettersending?)

### 2.6 Søknadsdato styrer når søkeren kan begynne

- **Type:** Story
- **Repo:** fs-plattform, min-kompetanse
- **Beskrivelse:** I dag stoppes bare innsending før `SØKING_ÅPNER` (`StudiekurvService.java:773`). Kladd kan opprettes før datoen, og tilbudene er synlige.
- **Akseptansekriterier** (`@OPT-OVO-FRI-001` «Sette søknadsdato»):
  - Søkeren kan ikke starte en søknad før søknadsdatoen.
  - Utdanningstilbudene i opptaket er ikke synlige for søkerne før søknadsdatoen (avklart 2026-10-12).

### 2.7 Frist for poenggrenser i tidlig opptak

- **Type:** Story
- **Repo:** fs-plattform, fs-admin
- **Beskrivelse:** Det finnes ingen hendelsestype for fristen.
- **Akseptansekriterier** (`@OPT-OVO-FRI-001` «Sette frist for poenggrenser for tidlig opptak»):
  - Opptaksforvalter ved forvaltende organisasjon kan sette fristen, og deltakende organisasjoner må sette poenggrensene for tidlig opptak innen den.

### 2.8 Startnummer for søknader og dokumentasjonsopplasting brukes ikke

- **Type:** Story
- **Repo:** fs-plattform, min-kompetanse
- **Beskrivelse:** Startnummeret lagres (`OpprettOpptakMutations.java:205-207`), men søknadsnummeret kommer fra den felles sekvensen `soknad_v2.soknadsnummer_seq` (`StudiekurvService.java:839`). `KAN_LASTE_OPP_DOKUMENTER` lagres, men leses ikke. Opplasting er alltid åpen (`edit-documentation.tsx:36-41`).
- **Akseptansekriterier** (`@OPT-OVO-INN-001`):
  - Søknadene i opptaket nummereres fra startnummeret.
  - Stenger opptaksforvalter for dokumentasjonsopplasting, kan søkeren ikke laste opp.

### 2.9 Søkeren ser informasjonsfrist for ledige studieplasser og første svarfrist

- **Type:** Story
- **Repo:** min-kompetanse (avklar hvilket team)
- **Beskrivelse:** `LEDIGE_STUDIEPLASSER_PUBLISER` vises ikke (`use-hendelser-and-date-by-opptak.tsx:22-30`). Svarfristen vises bare etter at søkeren har fått svar (`get-soknadsalternativ-svarfrist.ts:17`).
- **Akseptansekriterier** (`@OPT-OVO-FRI-001`):
  - Søkeren ser når ledige studieplasser publiseres.
  - Søkeren ser den seneste fristen for å svare på et eventuelt tilbud.

### 2.10 Rydding

- **Type:** Task · **Prioritet:** Lav
- **Repo:** fs-plattform
- **Beskrivelse og akseptansekriterier:**
  - Tomt opptaksnavn avvises i backend, ikke bare i fs-admin (`OpprettOpptakMutations.java:85`).
  - `opptak/docs/krav-11-opptak-ikke-dekket.md` bruker de nye feature-ID-ene (`OPT-OVO-…`) og mappa `11 Opprette og vedlikeholde opptak`.
  - `SamordnetOpptakFT.java:44` er tagget `OPT-OVO-SAM-001`, ikke `OPT-OPT-SAM-001`.

---

## Ikke med (hører trolig hjemme hos andre)

- **Tak for antall tilbud per runde**: brukes i plasstildelingen, og kravet er flyttet til `14 Plasstildeling/01 Runder/forvalte_runder.feature` (2026-10-12). Tas av teamet for plasstildeling.
- **Flagget for ledige studieplasser på opptaket**: markeringen står i `innstillinger.feature`, og finnes i fs-admin. At plasstildelingen bruker flagget, tas av teamet for plasstildeling.
- **Kreve studierett**: regelen er tagget `@wont` i kravet. Avklar om den skal tas ut før den kommer på lista.
- **TAKE-336** (teste at oppretting og vedlikehold fungerer etter kravene): bruk verifiseringsrapporten som sjekkliste.
