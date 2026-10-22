# Spec: Tildele saksbehandlende organisasjon

## Kilde

- **Oppgave:** `tasks/opptak/saksbehandlertildeling/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **GitHub:** [#207](https://github.com/sikt-no/fs/issues/207)
- **Jira:** [STEK-242](https://sikt.atlassian.net/browse/STEK-242) (epic). Det som gjenstår: STEK-568, STEK-569, STEK-570, STEK-571 (sub-tasks STEK-573 til STEK-577), STEK-572 (sub-tasks STEK-578 til STEK-581) og STEK-558
- **Hentet:** 2026-10-12 14:00

## Omfang

Spesifikasjonen dekker hvordan søknadsalternativene i et samordnet opptak fordeles til saksbehandlende organisasjon: tildelingsreglene opptaksforvalteren setter opp, unntakene for utdanningsbakgrunn og ledige studieplasser, saksbehandling på vegne av et lærested, at fordelingen ligger fast, flytting når utdanningsbakgrunnen endres, og hvem som ser sakene. Mye er bygget (STEK-492). Det som gjenstår, står i kartleggingen [verify-tildele_saksbehandlende_organisasjon-2026-10-08.md](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-tildele_saksbehandlende_organisasjon-2026-10-08.md). Valg av tildelingsregel per utdanningstilbud (`@OPT-OPT-UTD-004`) er ikke med, fordi kravet er `@draft`. Statusen «Overført» er heller ikke med.

## Krav

- **`tildele_saksbehandlende_organisasjon.feature`** (`@OPT-BEH-BEH-011`): saksbehandlertildelingsreglene i opptaket, fordelingen etter «Alle som deltar i opptaket», «Bare tilbyderen» og «Tilbydere i samme sektor», unntak, saksbehandling på vegne av et lærested, når fordelingen skjer, flytting ved endret utdanningsbakgrunn, og innsyn for saksbehandler, opptaksforvalter og tilbyder. ([krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature))

### Utenfor scope (`@draft`)

- **`tildele_saksbehandlende_organisasjon.feature`, scenario `Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til`**: venter på avklaring med domeneekspert om en flyttet sak skal få status «Overført», og om det hører hjemme her eller i et eget krav om endring av B-rolle.

### Utsatt (2026-10-22)

Disse delene er validert, men utsatt. Kravet blir stående som `@in-progress` til de er levert.

- **Regel «Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket»**: valget i FS Admin mangler. Utsatt i [STEK-579](https://sikt.atlassian.net/browse/STEK-579). Teamet vil verifisere det som er laget, før det tas inn mer.
- **Regel «Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet»**: utsatt i [STEK-576](https://sikt.atlassian.net/browse/STEK-576) (On Hold).
- **Scenario `Søkeren ser saksbehandlende organisasjon, men ikke sakene`**: søkeren ser ikke sakene, men visningen av saksbehandlende organisasjon mangler i API-et og min-kompetanse. Utsatt sammen med delene over.

### Relaterte krav som ikke er med

- `opptaksinnstillinger_utdanningstilbud.feature` (`@OPT-OPT-UTD-004`, `@draft`), regelen «Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud».
- `se_saksbehandlende_organisasjon.feature` (`@OPT-SØK-SØK-005`, `@draft`, PR #623): hva søkeren ser.
- `samordnet_opptak.feature` (`@OPT-OVO-SAM-001`, `@in-progress`), regelen om saksbehandlertildeling i samordnet opptak. Den hører til oppgaven `opprette-og-vedlikeholde-opptak`.

## Skisser

### Skisse: Saksbehandlertildeling

- **Type:** `figma`
- **Referanse:** <https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=18283-139419> (`fileKey` `LmoNQlmAuE2FlE0fUo5GoO`, `nodeId` `18283:139419`, siden «Saksbehandlertildeling»)
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/saksbehandlertildelingsregler/screenshot.png), [design-context.md](krav-input/sketches/figma/saksbehandlertildelingsregler/design-context.md). Skjermbildet av seksjonen «Endre utdanningsbakgrunn og B-rolle», sub-frames og variabler ble ikke hentet (grensen for kall i Figma-MCP).
- **Dekker krav:** `tildele_saksbehandlende_organisasjon.feature`
  - «Saksbehandlertildelingsregler» → regelen «Opptaksforvalteren ved forvaltende organisasjon setter opp saksbehandlertildelingsreglene for opptaket» (standardregel, liste, status, sletting)
  - «Opprett tildelingsregel» og «JOU» → fordelingene, organisasjon for sektoren og unntak for utdanningsbakgrunn
  - «Studiealternativ knyttet til JOU» → scenario `Se hvilke utdanningstilbud som er knyttet til saksbehandlertildelingsregelen`
  - «Endre utdanningsbakgrunn og B-rolle» → regelen «Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak»
- **Valideringsstatus:** `Avvik`:
  1. Unntakstabellen har «Realkompetanse → Tilbyder». Kravet sier at realkompetanse alltid saksbehandles av tilbyderen, uten unntak på regelen.
  2. Skjemaet har avkrysningen «Ledige studieplasser fordeles til tilbyder». Kravet sier at ledig studieplass alltid saksbehandles av tilbyderen.
  3. Skissen viser ikke valget av organisasjon som saksbehandler på vegne av et lærested (regelen «Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket»).
  4. Tekstene bruker «institusjon» («Søknaden går til institusjonen du velger her», kolonnen «Institusjon»). Terminologien i `krav/README.md` er «organisasjon» eller «lærested».
- **Beslutning ved avvik:**
  - 1 og 2: Kravene er riktige, skissen er utdatert. Avklart med domeneekspert i PR #684 (realkompetanse og ledige studieplasser).
  - 3: Ulikt scope. Skissen dekker ikke denne regelen, og den trenger en skisse før den bygges i FS Admin.
  - 4: Kravene er riktige. Tekstene rettes når implementasjonsdetaljene skrives.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature` | `@OPT-BEH-BEH-011 @must @planned` | `@OPT-BEH-BEH-011 @must @in-progress` |

## Åpne spørsmål

- [x] Saksbehandleren ved HK-dir: kravet sier at saksbehandleren bare ser sakene HK-dir saksbehandler. I dag gir SE_SØKNADSBEHANDLING ved forvaltende organisasjon lesetilgang til alle sakene i opptaket, beskrevet som et bevisst personvernvalg (`V329`, STEK-269).
  - **Beslutning (2026-10-12):** Kravet gjelder. Domeneeksperten bekrefter at saksbehandleren ved HK-dir bare skal se sakene HK-dir saksbehandler. Opptaksforvalteren ved forvaltende organisasjon ser fortsatt alle sakene (regelen «Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket»). De som laget `V329` (STEK-269), får beskjed om at valget endres.
- [x] Tilbudsgaranti ved flytting: scenarioet `Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til` sier at tilbudsgarantien følger med. I dag nullstilles garantien som organisasjonen saken flyttes fra, har satt. Gjelder kravet alle garantier, eller bare dem fra forvalter og tilbyder?
  - **Beslutning (2026-10-22, Håkon):** Tilbudsgarantiene beholdes når saken flyttes, unntatt den saksbehandleren har satt. Koden gjør dette (`BehandlertildelingService`). Kravet er presisert 2026-10-22: scenarioet er en scenariomal for garantien fra tilbyder og opptaksforvalter, og scenarioet `Tilbudsgarantien fra saksbehandleren følger ikke med til organisasjonen det flyttes til` er nytt.
- [ ] Implementasjonsdetaljer mangler for `tildele_saksbehandlende_organisasjon.feature` (`tildele_saksbehandlende_organisasjon.design.md`). Utsatt fordi Figma-MCP nådde grensen for kall.
- [ ] Skisse mangler for valget av organisasjon som saksbehandler på vegne av et lærested.
- [ ] Funn i fs-admin fra [verify-2026-10-21-1600.md](verify-2026-10-21-1600.md), ikke rettet. Lagt inn som [STEK-629](https://sikt.atlassian.net/browse/STEK-629) under STEK-572:
  - Valglista for organisasjon for sektoren henter alle organisasjoner, ikke bare dem som deltar i opptaket (`BehandlertildelingsregelSektorOrganisasjonCombobox.tsx`). Backend avviser først ved lagring.
  - «Opprett» i saksbehandlertildelingsreglene sjekker rollen uten organisasjon (`BehandlertildelingsreglerResultList.tsx:69-72`), så opptaksforvaltere ved deltakende læresteder ser knappen. Backend avviser lagringen.
- [x] Presisering i kravet: `Unntaket går foran saksbehandlertildelingsregel der bare tilbyderen saksbehandler` holder bare når standardregelen også har unntaket for «Utenlandsk». Det står ikke i `Gitt`.
  - **Endret (2026-10-22):** `Gitt` sier nå at standardregelen har unntaket.
- [x] «Tildelingsreglene» i kravet (åpent spørsmål fra main, begrepslista nr. 17).
  - **Beslutning (2026-10-22, Håkon):** byttes til «saksbehandlertildelingsreglene» overalt, også i flyten `@FLY-OPT-SAK-001`. To scenarioer har fått ny tittel: `Saksbehandlertildelingsreglene er ikke tilgjengelige i lokale opptak` og `Deltakende lærested kan ikke endre saksbehandlertildelingsreglene`.


## Rute

fs-plattform → fs-admin
