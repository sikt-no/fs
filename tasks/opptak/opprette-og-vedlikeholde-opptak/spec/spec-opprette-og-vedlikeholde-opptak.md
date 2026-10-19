# Spec: Opprette og vedlikeholde opptak

## Kilde

- **Oppgave:** `tasks/opptak/opprette-og-vedlikeholde-opptak/`
- **Kilde-mappe:** `krav/02 Opptak/11 Opprette og vedlikeholde opptak/`
- **GitHub:** [#577](https://github.com/sikt-no/fs/issues/577), [#578](https://github.com/sikt-no/fs/issues/578), [#579](https://github.com/sikt-no/fs/issues/579)
- **Hentet:** 2026-09-30 14:14

## Krav

- **`opprett_opptak.feature`** (`@OPT-OVO-GRU-001`) — opptaksforvalter oppretter et opptak (samordna eller lokalt) med navn, regelverkssamling og opptakstype. Navn angis på bokmål, nynorsk, engelsk og samisk, der bokmål, nynorsk og engelsk er obligatorisk (endret 2026-10-12, se under). ([krav-input/local/krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opprett_opptak.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/01%20Opptak/opprett_opptak.feature))

- **`samordna_opptak.feature`** (`@OPT-OVO-SAM-001`, før `samordnet_opptak.feature`) — opptaksforvalter ved forvaltende organisasjon inviterer læresteder til samordna opptak, begrenser på lærestedstype, og knytter regler for saksbehandlertildeling til opptaket. Kun forvaltende organisasjon kan endre innstillinger. ([krav-input/local/krav/02 Opptak/11 Opprette og vedlikeholde opptak/02 Samordning/samordnet_opptak.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/02%20Samordning/samordnet_opptak.feature))

- **`innstillinger.feature`** (`@OPT-OVO-INN-001`) — opptaksforvalter setter innstillinger: opptakstype, regelverkssamling, standard poenglikhetsregel (med mulighet for overstyring per utdanningstilbud), startnummer, maks søknadsalternativer, utdanningsbakgrunner, aktivering av tidlig opptak, ledige studieplasser og dokumentasjonsopplasting. ([krav-input/local/krav/02 Opptak/11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/03%20Innstillinger/innstillinger.feature))

- **`frister_og_hendelser.feature`** (`@OPT-OVO-FRI-001`) — opptaksforvalter ved forvaltende organisasjon setter generelle frister: redigering av utdanningstilbud, søkeperiode, omprioriteringsfrist, sletting av søknadsalternativer, dokumentasjonsfrister, tidlig opptak (søknadsfrist, dokumentasjonsfrist, frist for poenggrenser), ledige studieplasser, frist for endring av utdanningsbakgrunn, informasjonsdatoer for opptaksresultat (publiseringsdato og første svarfrist), og dato for aldersberegning. I tillegg: legge til utdanningsbakgrunner med avvikende søknads- og dokumentasjonsfrister. ([krav-input/local/krav/02 Opptak/11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature](krav-input/local/krav/02%20Opptak/11%20Opptak/04%20Frister/frister_og_hendelser.feature))

### Utenfor scope (`@draft`)

- **`opprett_opptak.feature` — Regel: Det skal være mulig å gjenbruke innstillinger fra et tidligere opptak** — venter på: Hva kopieres og hva kopieres ikke?
- **`opprett_opptak.feature` — Regel: Opptaksforvalter kan deaktivere et opptak** — utkast, utsatt til senere iterasjon.
- **`innstillinger.feature` — Regel: Opptaksforvalter kan sette krav om studierett for å søke** — `@draft` fra 2026-10-12 (var `@wont`). Ikke gjennomgått.

### Relaterte krav som ikke er med (`@draft`)

- `fellestekster.feature` (`@OPT-OVO-TEK-001`, `@wont @draft`) — informasjon til søker i søknadsprosessen
- `svarmeldingsmal.feature` (`@OPT-OVO-TEK-002`, `@wont @draft`) — svarmeldingsmal for opptak
- `hendelseslogg.feature` (`@OPT-OVO-LOG-001`, `@should @draft`) — hendelseslogg for opptak, venter på generell løsning
- `opprette_plasstildelingsrunde.feature` (`@OPT-PLA-RUN-001`, `@draft`) i `krav/02 Opptak/14 Plasstildeling/01 Runder/` — kravet om at første plasstildelingsrunde opprettes fra publiseringsdatoen og første svarfrist

## Skisser

### Skisse: Opprett opptak — hele siden

- **Type:** `figma`
- **Referanse:** <https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20606-117530&m=dev> (`fileKey` `LmoNQlmAuE2FlE0fUo5GoO`, `nodeId` `20606:117530`, siden «Opprett nytt Samordna opptak»)
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/screenshot.png), [sub-frames/](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/sub-frames/) (01-informasjon, 02-samordning, 03-innstillinger, 04-frister, 05-utdanningsbakgrunner-avvikende-frister), [design-context.md](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/design-context.md), [variables.md](krav-input/sketches/figma/opprett-opptak-frister-og-hendelser/variables.md)
- **Dekker krav:** alle fire feature-filer. Seksjonene i skissen mapper til kravfilene:
  - **01 Navn** → `opprett_opptak.feature` (opprette med navn på flere språk)
  - **02 Samordning** → `samordnet_opptak.feature` (invitere organisasjoner)
  - **03 Innstillinger** → `innstillinger.feature` (opptakstype, regelverkssamling, utdanningsbakgrunner, startnummer, poenglikhetsregel m.m.)
  - **04 Generelle frister** → `frister_og_hendelser.feature` (alle fristgrupper)
  - **05 Utdanningsbakgrunner med avvikende frister** → `frister_og_hendelser.feature` (siste regel: legge til utdanningsbakgrunner med egne frister)
- **Valideringsstatus:** `OK` med merknader:
  1. **Navn-seksjonen** sier «Alle felter må fylles», men kravet sier kun bokmål og nynorsk er obligatorisk. Teksten kan bety «alle påkrevde felt» snarere enn «alle fire språk». Ingen blokkerende avvik — avklares i implementasjon.
  2. **«Krav til studierett for å søke»** vises som avkryssingsboks i Innstillinger, men regelen er tagget `@wont` i kravet (ikke relevant for samordna opptak). Designet inkluderer den for fullstendighet. Ikke et avvik — implementasjonen følger MoSCoW-prioriteringen.
  3. **Samordning**: «Utdanninger: N»-badges vises per organisasjon — ekstra informasjon som ikke står i kravene, men som ikke er i konflikt.
  4. **Frister**: Alle grupper og felt i designet samsvarer med kravene. Seksjon 05 (utdanningsbakgrunner med avvikende frister) er ny siden forrige kjøring og matcher regelen i `frister_og_hendelser.feature`.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opprett_opptak.feature` | `@OPT-OVO-GRU-001 @must @planned` | `@OPT-OVO-GRU-001 @must @in-progress` |
| `krav/02 Opptak/11 Opprette og vedlikeholde opptak/02 Samordning/samordnet_opptak.feature` | `@OPT-OVO-SAM-001 @must @planned` | `@OPT-OVO-SAM-001 @must @in-progress` |
| `krav/02 Opptak/11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature` | `@OPT-OVO-INN-001 @must @planned` | `@OPT-OVO-INN-001 @must @in-progress` |
| `krav/02 Opptak/11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature` | `@OPT-OVO-FRI-001 @must @planned` | `@OPT-OVO-FRI-001 @must @in-progress` |

## Endringer etter innhenting

Kravene er `@in-progress`, og endres på stedet. Endringene står her, så den som implementerer, ser dem.

- **2026-10-19, etter fs-verify (`spec/verify-2026-10-19-1958.md`):**
  - `@OPT-OVO-INN-001`: **Taket er tilbake til «Tilbud per tildelingsrunde»**, slik fs-admin har feltet (`maks_antall_tilbud`). Regelen heter «Opptaksforvalter setter tak for antall tilbud per tildelingsrunde», og er fortsatt obligatorisk, forhåndsutfylt med 1 og kan endres. Det erstatter regelen fra 2026-10-14 om hvor mange utdanningstilbud en søker kan få opptak til.
  - `@OPT-OVO-INN-001`: Nytt scenario «Endre opptakstype når utdanningstilbud er knyttet til opptaket». Opptakstypen har ingen følgelogikk, så fs-admin skal ikke låse feltet.
  - `@OPT-OVO-SAM-001`: **Saksbehandlertildeling:** i denne iterasjonen skal opptaksforvalter ved forvaltende organisasjon kunne se saksbehandlertildelingen for et samordna opptak og navigere dit. Scenarioet «Sette regler for fordeling av søknader …» er tatt ut. Innstillingene løses av Puff i `tildele_saksbehandlende_organisasjon.feature`. I lokale opptak vises ikke saksbehandlertildelingen.
  - `@OPT-OVO-GRU-001`: Den `@planned` regelen om obligatoriske felt sier nå «tak for tilbud per tildelingsrunde».
- **2026-10-19, `@OPT-OVO-INN-001` og `@OPT-OVO-FRI-001`, etter akseptansetesten:** **Kravene beskriver nå at innstillingene og fristene settes og finnes på opptaket, ikke virkningen hos søkeren, i saksbehandlingen eller for utdanningstilbudene.** Virkningen står i kravet der verdien brukes, med en henvisning under hver regel. Virkninger som ikke hadde noe krav, er lagt inn som `@draft`-regler der de brukes, og står under «Uløst arbeid» i [scope-opprette-opptak-2027](../../scope-opprette-opptak-2027.md). Det betyr at oppgaven er ferdig når verdiene kan settes, lagres og vises igjen. Disse scenarioene er flyttet ut: «Lærestedet kan ikke endre poenggrensen for tidlig opptak etter fristen» (til `opptaksinnstillinger_utdanningstilbud.feature`), «Søker som bytter utdanningsbakgrunn …» og «Søker uten registrert utdanningsbakgrunn …» (til `søke_på_opptak.feature`), og de to scenarioene under regelen om frister som ikke er satt (til `søke_på_opptak.feature` og `prioritere_søknadsalternativer.feature`).
- **2026-10-19, `@OPT-OVO-FRI-001`:** **Fristene kan stå tomme.** Regelen heter nå «Fristene kan stå tomme når opptaket lagres». At fs-admin krever alle fristene, er en feil. Unntaket er nytt: når tidlig opptak er aktivert, kan ikke opptaket lagres uten søknadsfrist og dokumentasjonsfrist for tidlig opptak.
- **2026-10-19, `@OPT-OVO-FRI-001`:** Svar fra akseptansetesten. S1: opptaket har ingen egen publiseringsdato, og det åpne spørsmålet ved «Sette søknadsdato» (også Q16 om kladder) er lukket. S3: fristen for endring av utdanningsbakgrunn brukes av saksbehandlertildelingen, og sperrer ikke saksbehandleren. S4: søknaden bruker utdanningsbakgrunnene og fristene opptaket har.
- **2026-10-19, `@OPT-OVO-INN-001`:** Ledige studieplasser: opptaksforvalter aktiverer dem og setter datoene, og datoene finnes på opptaket. I testen måtte datoene for tidlig opptak settes for å lagre. Det er en feil i fs-admin.
- **2026-10-19, `@OPT-OVO-GRU-001`:** Reglene om navn er slått sammen til «Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne». Atferden er den samme.
- **2026-10-19, `@OPT-OVO-GRU-001`:** Ny regel «Utdanningsbakgrunner, poenglikhetsregel og tak for søknadsalternativer og utdanningstilbud må være satt for å lagre et opptak», tagget `@planned`. Kravet er levert, så regelen er et tillegg, og må hentes inn med `fs-specify` før den bygges. Startnummer for søknader er ikke obligatorisk.
- **2026-10-19, `@OPT-OVO-INN-001`:** **Opptakstype og regelverkssamling kan endres når som helst** (berører TAKE-396). Opptakstypen er bare kategorisering, og en endring påvirker ikke utdanningstilbud, søknader eller plasstildeling. Sperren mot å endre regelverkssamling når utdanningstilbud er knyttet til opptaket er fjernet. I stedet ser opptaksforvalter et varsel om at utdanningstilbudene mister alle reglene fra den gamle samlingen, og kan avbryte. Bekreftes endringen, mister utdanningstilbudene reglene.
- **2026-10-19, `@OPT-OVO-INN-001`:** Nytt scenario «Startnummeret er 1 når opptaksforvalter ikke har satt det». I dag bruker fs-plattform ikke startnummeret (se verify-rapporten 2026-10-15).
- **2026-10-19, `@OPT-OVO-INN-001`:** Regelen «Opptaksforvalter setter hvor mange utdanningstilbud en søker kan få opptak til» er validert, og er ikke lenger `@draft`. Den er nå **med i spesifikasjonen**. Taket er obligatorisk, forhåndsutfylt med 1, og kan endres etter at opptaket er opprettet. fs-admin har i dag feltet «Tilbud per tildelingsrunde» (`maks_antall_tilbud`), som ingen kode leser.
- **2026-10-19, `@OPT-OVO-INN-001`:** Nytt scenario «Den siste utdanningsbakgrunnen kan ikke fjernes». Et opprettet opptak skal alltid ha minst én utdanningsbakgrunn.
- **2026-10-19, `@OPT-OVO-SAM-001`:** Opptaksforvalter ved deltakende organisasjon ser **alle innstillinger og frister** som er satt på opptaket, ikke bare innstillingene.
- **2026-10-09, `@OPT-OVO-INN-001`:** Nytt scenario «Sette lenke til informasjon om tidlig opptak» under regelen «Opptaksforvalter kan åpne for tidlig opptak». Opptaksforvalteren setter én lenke per opptak til informasjon om tidlig opptak, og søkerne ser den i Min kompetanse («Les mer»). Hører til [#578](https://github.com/sikt-no/fs/issues/578) «Konfigurere tidlig behandling og tilbud». Kom fra reviewen av PR #654 (oppgaven `tasks/opptak/tidlig-opptak`), og ønsket i STEK-267. Lenken var før beskrevet per utdanningstilbud i `opptaksinnstillinger_utdanningstilbud.feature`. Koden har ikke noe felt for lenken i dag.
- **2026-10-08, `@OPT-OVO-SAM-001`:** Regelen «Opptaksforvalter ved forvaltende organisasjon knytter regler for saksbehandlertildeling i samordna opptak» er tilbake i fila (PR #684). Selve fordelingen av søknader står i `tildele_saksbehandlende_organisasjon.feature` (`@OPT-BEH-BEH-011`), og løses av Puff. Avklart 2026-10-12: det som hører til denne oppgaven, er å knytte reglene til opptaket.
- **2026-10-09, alle fire kravene:** Ordlyd: «samordnet opptak» er blitt «samordna opptak», og «runde» / «opptaksrunde» er blitt «plasstildelingsrunde». `samordnet_opptak.feature` heter nå `samordna_opptak.feature`. Ingen endring i hva som skal bygges.
- **2026-10-09, `@OPT-OVO-FRI-001`:** Dato for aldersberegning er lagt til fristene (#376). Skrevet om 2026-10-12: regelen «Opptaksforvalter setter dato for aldersberegning» har nå bare to scenarioer, «Sette dato for aldersberegning» og «Standarddato når datoen ikke er satt» (31.12 i året opptaksresultatene publiseres). Utregningen av alderen er flyttet til `automatisk_kvoteplassering.feature` (`@OPT-BEH-BEH-012`).
- **2026-10-12, `@OPT-OVO-GRU-001`:** Regelen om obligatoriske navn er skrevet om til «Opptaket må ha navn på bokmål, nynorsk og engelsk». **Engelsk er nå obligatorisk**, ikke bare bokmål og nynorsk. Nye scenarioer: «Lagre opptak med navn på alle obligatoriske språk», og scenariomalen «Navn mangler på et obligatorisk språk» (opptaket kan ikke lagres når ett av de tre mangler). Berører TAKE-395 i fs-admin, som i dag krever bokmål og nynorsk.
- **2026-10-12, `@OPT-OVO-INN-001`:** Regelen «Opptaksforvalter kan sette tak for antall tilbud per tildelingsrunde» er **flyttet ut** til `14 Plasstildeling/01 Runder/forvalte_runder.feature`, fordi den brukes i plasstildelingen. Den er ikke lenger en del av denne oppgaven. Regelen om at opptaket tilbyr søknad på ledige studieplasser står fortsatt her. Regelen om krav om studierett er satt til `@draft` (var `@wont`), og skal ikke bygges nå.
- **2026-10-14, `@OPT-OVO-INN-001`:** Rettelse til endringen over: taket per plasstildelingsrunde er tatt ut av `forvalte_runder.feature`. Hvor mange tilbud søkeren kan få, avgjøres av rundetypen (ett ordinært tilbud i hovedtildeling og supplering, flere i etterfylling, og tilbud på ledige studieplasser i tillegg). Innstillingen på opptaket er **hvor mange tilbud søkeren kan takke ja til** (i samordna opptak 1). Den står som ny regel «Opptaksforvalter setter hvor mange tilbud en søker kan takke ja til» i `innstillinger.feature`, tagget `@draft @openquestion` (standardverdien er ikke avklart), og er ikke med i spesifikasjonen før den er validert.
- **2026-10-12, `@OPT-OVO-FRI-001`:** Avklart i scenarioet «Sette søknadsdato»: **utdanningstilbudene blir synlige for søkerne først når opptaket åpner for søknad**. Steget sier nå «blir synlige for søkere fra denne datoen».
- **2026-10-12, alle fire kravene:** Har fått `@scope-opprette-opptak-2027`, og oppgaven hører til [scope-opprette-opptak-2027](../../scope-opprette-opptak-2027.md). Ingen endring i hva som skal bygges.
- **2026-10-12, `@OPT-OVO-SAM-001`:** Avklart at det ikke er gitt at skillet mellom samordna og lokale opptak skal bevares. Det er derfor nok at brukergrensesnittet ikke gjør det mulig å legge til andre organisasjoner eller sette saksbehandlertildeling i et lokalt opptak. API-et trenger ikke sperre det.

## Åpne spørsmål

Ingen åpne spørsmål.
