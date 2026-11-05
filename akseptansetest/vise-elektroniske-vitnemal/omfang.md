# Omfang – Se søkerens elektroniske vitnemål

- **Testplan**: [testplan.md](testplan.md)
- **Confluence**: –
- **Laget**: 2026-11-05 av fs-testplan

---

Omfanget for «Se søkerens elektroniske vitnemål»: kravene og flytene som testes, og det som ikke er med. Kravene i «Omfang» er kriteriene for godkjent, og alle skillene i testflyten leser dem herfra. Testplanen: Testplan – Se søkerens elektroniske vitnemål.

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Se søkerens elektroniske vitnemål](https://github.com/sikt-no/fs/blob/e66cf6bb/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vise_elektroniske_vitnem%C3%A5l.feature) | `@OPT-BEH-BEH-005` | `@in-progress` (delvis levert) | 9 |

Scenarioene i testen:

- Regel «Søkerens elektroniske vitnemål vises»: «Se at søkeren har elektroniske vitnemål», «Søker uten elektroniske vitnemål», «Poeng som ikke kan beregnes, vises tomme», «Åpne et vitnemål i ny fane», «Annullert vitnemål som er brukt i en beregning vises» og «Annullert vitnemål som ikke er brukt i en beregning vises ikke» (6 av 8)
- Regel «Innsyn styres av rettighet, ikke av hvem som har tatt saken»: «Saksbehandler med leserettighet ser søkerens vitnemål», «Bruker uten lesetilgang ser ikke vitnemålsoversikten» og «Saken er tilordnet en annen saksbehandler» (3 av 3)

«Bruker uten lesetilgang ser ikke vitnemålsoversikten» er levert (regelen er `@implemented`), men var usikker i verifiseringen 2026-11-05: opptaksforvalteren for opptaket og tilbyderen av et søknadsalternativ ser også vitnemålene. Scenarioet testes som det står, med en testbruker som verken er forvalter eller tilbyder.

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av det samme kravet: `npx playwright test --grep "@OPT-BEH-BEH-005"`.

### Åpne spørsmål

`@openquestion` stopper ikke testen: delen er klar til implementasjon, og testes som den står. Oversikten viser hvor mye som står åpent. Tallene regnes fra kravfilene og verify-rapporten.

| Krav | Feature-ID | Regler med åpent spørsmål | Scenarioer med åpent spørsmål | Scenarioer i testen |
|---|---|---|---|---|
| [Se søkerens elektroniske vitnemål](https://github.com/sikt-no/fs/blob/e66cf6bb/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vise_elektroniske_vitnem%C3%A5l.feature) | `@OPT-BEH-BEH-005` | 0 av 2 | 1 av 11 | 0 |

Scenarioet med åpent spørsmål, «Åpne vitnemålsoversikten», er ikke levert, og står i «Venter på verifisering».

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

Ingen av kravene er med i en flyt.

### Vurdering per krav (fase 3)

Den interne akseptansetesten tester flyter og avhengigheter. Per krav vurderes det hva som testes:

| Krav | Inngår i flyt | Vurdering |
|---|---|---|
| `@OPT-BEH-BEH-005` | Ingen | Testes som oppgaven «Se søkerens vitnemål i saksbehandlingen». Kravet viser det flyten «Importere VGS-vitnemål fra KREG» (`@FLY-OPT-VIT-001`, `@planned`) lager: vitnemålene, opptakssystemets påstand om GSK og annulleringen. Foreslå å koble kravet til flyten med `fs-krav` (modus E) |

Scenarioene som tas med i fase 3, er de som inngår i flytene, ikke alle. Er en tidligere levert flyt avhengig av noe leveransen endrer, står den med som regresjon (finn dem med `grep -rn "@depends-on-<Feature-ID>" krav/_Flyter/`).

### Avhengighetskart

Testleder vurderer om leveransen trenger et avhengighetskart. Teamet lister da det leveransen bygger på eller påvirker utenfor brukerens flyt, og det sjekkes underveis i flytene der det er mulig, ellers for seg.

| Avhengighet | Type | Hvordan sjekkes det |
|---|---|---|
| Importen av VGS-vitnemål fra KREG (jobben ved søknadshendelser, `@FLY-OPT-VIT-001`) | Integrasjon og batchjobb | Testes for seg: vitnemålene i oversikten er de samme som søkeren har i KREG, og et vitnemål som er annullert i KREG, vises som annullert |
| Poengberegningen i opptak (kontrollmotoren) | Annen modul i FS | I oppgaven: poengene per vitnemål stemmer med den automatiske poengberegningen for samme vitnemål |
| Opptakssystemets påstand om GSK (`@OPT-BEH-BEH-015`) | Annen modul i FS | I oppgaven: teksten om uenighet vises når opptakssystemet er uenig med skolen. Selve påstanden testes ikke før «Åpne vitnemålsoversikten» er avklart |

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [Se søkerens elektroniske vitnemål](https://github.com/sikt-no/fs/blob/e66cf6bb/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vise_elektroniske_vitnem%C3%A5l.feature) | `@OPT-BEH-BEH-005` | `@in-progress` | Scenario «Åpne vitnemålsoversikten» (usikker): opptakssystemets påstand om GSK vises bare som en tekst ved uenighet, ikke som egen opplysning (fs-admin `VitnemalsbehandlingSection.tsx:173-177`). Avhenger av det åpne spørsmålet til designeren |
| [Se søkerens elektroniske vitnemål](https://github.com/sikt-no/fs/blob/e66cf6bb/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vise_elektroniske_vitnem%C3%A5l.feature) | `@OPT-BEH-BEH-005` | `@in-progress` | Scenario «Vitnemålene kan ikke hentes» (ikke funnet): en feilet henting fra KREG bare logges (fs-plattform `SoknadshendelseJobb.java:395-417`), og seksjonen skjules |

## Regler uten scenario

`fs-verify` rapporterer regler i koden som ikke har et scenario i kravet, for eksempel valideringer og tilgangssjekker. De er input til de agentiske testcasene (fase 2).

| Krav | Regel i koden | Funnet i | Testes i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-BEH-BEH-005` | «Brukt i en beregning» omfatter også kravelement-vurdering og GSK-konklusjon, ikke bare poeng | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentConditions.java:41-64` | ja: beslutningstabell for annullert × brukt | ja (`fs-krav`): kravet sier bare poeng |
| `@OPT-BEH-BEH-005` | Vitnemål med samme utstedelsesdato sorteres på vitnemålsnummer | `fs-plattform/opptak/opptak-subgraph/src/main/resources/schema/features/experimental/saksbehandling/sak.graphqls:129` | ja | nei |
| `@OPT-BEH-BEH-005` | Vitnemål uten utstedelsesdato sorteres sist | `fs-plattform/…/saksbehandling/sak.graphqls:129` | ja | nei |
| `@OPT-BEH-BEH-005` | Poengene rundes til én desimal | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentPoengService.java:54` | ja | nei |
| `@OPT-BEH-BEH-005` | Feilmeldingen ved lasting har en annen tekst enn design.md | `fs-admin/src/common/messages/nb/soknadsbehandling.json:544-545` | nei: gjelder «Vitnemålene kan ikke hentes», som venter | nei (rett design.md eller koden) |
| `@OPT-BEH-BEH-005` | Ukjent GSK, førstegangsvitnemål eller utstedt dato vises som «-» | `fs-admin/src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx:90-91,180-182` | ja | nei |
| `@OPT-BEH-BEH-005` | Telleren teller også annullerte vitnemål som er brukt i en beregning | `VitnemalsbehandlingSection.tsx:105` | ja | ja (`fs-krav`): åpent designspørsmål |
| `@OPT-BEH-BEH-005` | Feiler bare poengene eller GSK-kontrollen, vises «-» uten melding | `VitnemalsbehandlingSection.tsx:63,70` | nei: feilen kan ikke framkalles i testmiljøet | nei |
| `@OPT-BEH-BEH-005` | Poeng beregnes også for annullerte vitnemål | `VgsDokumentPoengService.java:35-46` | ja: sammen med «Annullert vitnemål som er brukt i en beregning vises» | ja (`fs-krav`): åpent designspørsmål |
| `@OPT-BEH-BEH-005` | Varselet «Poengene bygger på et vitnemål som er annullert.» over tabellen, med handlingstekst bare for MODIFISERE_SØKNADSBEHANDLING | `VitnemalsbehandlingSection.tsx:59,88,122-127` | ja: vises når et annullert vitnemål vises | ja (`fs-krav`): kravet sier at varselet hører til L2 |
| `@OPT-BEH-BEH-005` | Opptakssystemets påstand er null for annullerte vitnemål og kompetansebevis, så uenighet vises ikke for dem | `fs-plattform/…/saksbehandling/vgs-dokument.graphqls:31-35` | ja | nei |
| `@OPT-BEH-BEH-005` | Når et vitnemål som er brukt i en sak, blir annullert i KREG, får saken en tagg og settes tilbake til under behandling | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/AnnullertVitnemaalService.java:44-56` | nei: krever en annullering i KREG under testen | ja (`fs-krav`): hører til `@OPT-BEH-BEH-034` |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| `@OPT-BEH-BEH-005` «Åpne vitnemålsoversikten» | Venter på verifisering: opptakssystemets påstand om GSK vises ikke som egen opplysning, og hvordan den skal vises, er et åpent spørsmål til designeren |
| `@OPT-BEH-BEH-005` «Vitnemålene kan ikke hentes» | Venter på verifisering: en feilet henting fra KREG lagres ikke, så feilmeldingen er ikke laget |
| Tilgang for opptaksforvalter og tilbyder | Ikke avklart i kravet: tilbyderen skal se vitnemålene (avklart 2026-11-03), og det er ikke avklart for opptaksforvalteren. Tilgang testes ikke egen i fase 2 |
| Flyten «Importere VGS-vitnemål fra KREG» (`@FLY-OPT-VIT-001`) | Flyten bygger ikke på kravet, og er `@planned` |
