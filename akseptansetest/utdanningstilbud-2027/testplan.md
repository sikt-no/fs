# Testplan – Utdanningstilbud i samordna opptak 2027

- **Leveranse**: mappe
- **Kilde**: `krav/02 Opptak/12 Utdanningstilbud/02 Utdanningstilbud i opptak/`, `krav/02 Opptak/12 Utdanningstilbud/04 Behandle et utdanningstilbud/`
- **Scope**: @scope-utdanningstilbud-i-opptak-2027, @scope-utdanningstilbud-2027
- **Scope-fil**: [scope-utdanningstilbud-i-opptak-2027](../../tasks/opptak/scope-utdanningstilbud-i-opptak-2027.md), [scope-utdanningstilbud-2027](../../tasks/opptak/scope-utdanningstilbud-2027.md)
- **Oppgaver**: [opptak/utdanningstilbud-i-opptak](../../tasks/opptak/utdanningstilbud-i-opptak/oppgave.md), [opptak/behandle-utdanningstilbud](../../tasks/opptak/behandle-utdanningstilbud/oppgave.md)
- **Krav**: 21 feature-filer, 10 `@implemented`, 5 delvis levert, 0 flyter, commit `b67676a` (2026-10-23)
- **Verifisering**: [verify-02 Utdanningstilbud i opptak-2026-10-22-1915.md](../../krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/verify-02%20Utdanningstilbud%20i%20opptak-2026-10-22-1915.md), [verify-04 Behandle et utdanningstilbud-2026-10-22-1915.md](../../krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/verify-04%20Behandle%20et%20utdanningstilbud-2026-10-22-1915.md). Rapportene er eldre enn commit `01eea94` (2026-10-23, SHI-747), som la til tre scenarioer i UTD-026, UTD-002 og UTD-003. Teamet har bekreftet at de tre ikke er levert.
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137235987/Testplan+Utdanningstilbud+i+samordna+opptak+2027
- **Laget**: 2026-10-23 av fs-testplan

---

Testplan for «Utdanningstilbud i samordna opptak 2027». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Opptaksforvalter kan legge til utdanningstilbud i opptaket, ett og ett eller flere av gangen, og fjerne og trekke dem. Hvem som kan gjøre det, og når, avhenger av organisasjonen og av fristene for redigering i opptaket. I lista over utdanningstilbud i opptaket kan opptaksforvalteren søke og filtrere. På detaljsiden for et utdanningstilbud i FS Admin kan opptaksforvalter registrere planlagt antall studieplasser, studietypenummer, studieavgift, påkrevde attester, poenggrense for tidligopptak, tidlig søknadsfrist og dokumentasjonsfrist, beskrivelse og søkeord til Min kompetanse, og overstyre regelen for poenglikhet. |
| Versjon | [Fylles ut: versjon i test-fsadmin] (verifisert mot main: fs-plattform `bbd797a3b9`, fs-admin `6a5c26a9e`, min-kompetanse `f70409ca`) |
| Testmiljø | [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/) |
| Feature-flagg | Ingen |
| Kilde | [02 Utdanningstilbud i opptak](https://github.com/sikt-no/fs/tree/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak) og [04 Behandle et utdanningstilbud](https://github.com/sikt-no/fs/tree/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud) |
| Scope | `@scope-utdanningstilbud-i-opptak-2027` · [scope-fila på GitHub](https://github.com/sikt-no/fs/blob/b67676a/tasks/opptak/scope-utdanningstilbud-i-opptak-2027.md), `@scope-utdanningstilbud-2027` · [scope-fila på GitHub](https://github.com/sikt-no/fs/blob/b67676a/tasks/opptak/scope-utdanningstilbud-2027.md). `@OPT-OPT-UTD-013` har ikke scope. |
| Saker | [#398](https://github.com/sikt-no/fs/issues/398), [#594](https://github.com/sikt-no/fs/issues/594), [#595](https://github.com/sikt-no/fs/issues/595) · [SHI-710](https://sikt.atlassian.net/browse/SHI-710), [SHI-686](https://sikt.atlassian.net/browse/SHI-686), [SHI-747](https://sikt.atlassian.net/browse/SHI-747) |
| Berører andre team | Ikke for det som testes nå: det er i fs-admin og fs-plattform. Delene som venter, berører min-kompetanse (beskrivelsen og søkeordene for søkere) og utdanningsregisteret (filter på utdanningstype og NKR 5.1/5.2). |
| Kjente begrensninger | «Fjern» skjules når redigeringsfristen er passert, ikke når opptaket åpner for søknad. Derfor kan opptaksforvalter se «Fjern» etter søknadsåpning, men får en feilmelding (fs-plattform avviser fjerningen). En deltakende organisasjon kan slette en annen organisasjons utdanningstilbud via API-et, men fs-admin hindrer det. «(standard for opptaket)» står bare i nedtrekkslista for poenglikhet når man redigerer, ikke i lesevisningen. Studietypen kan byttes, men ikke fjernes. fs-admin lagrer tidlig søknadsfrist og tidlig dokumentasjonsfrist bare når begge er satt. Studieavgift er ja/nei, ikke et beløp. Redigeringsfristene kommer fra `@OPT-OVO-FRI-001` (delvis levert), og må kunne settes på testopptaket. |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | ORDENTLIG RUNDSKRIV | Opptaksforvalter ved forvaltende organisasjon | Sikt | Legge til for en annen organisasjon, fjerne, trekke, redigere etter redigeringsfristen, filtrere på organisasjon, og detaljsiden (UTD-001, 002, 003, 026 og 04 Behandle et utdanningstilbud) |
| 2 | KORT DOMPAPP UiT | Opptaksforvalter ved deltakende organisasjon | UiT Norges arktiske universitet | Legge til og fjerne tilbud organisasjonen tilbyr innenfor redigeringsperioden, og trekkfristen (UTD-002, 003, 026) |
| 3 | KORT DOMPAPP UIO | Opptaksforvalter ved deltakende organisasjon | Universitetet i Oslo | Den andre deltakende organisasjonen: ser bare utdanningstilbudene til UiO (UTD-001, testcase 3.7 og 3.8 i den interne akseptansetesten, som kjent mangel) |
| 4 | VENNLIG SKOG HiØ | Opptaksforvalter ved organisasjon som ikke deltar i opptaket | Høgskolen i Østfold | Ser verken opptaket eller utdanningstilbudene i det (`@OPT-OVO-SAM-001`, testcase 3.9 og 3.10 i den interne akseptansetesten, som kjent mangel) |

Testbrukerne finnes i minst to organisasjoner, så vi kan teste at ingen ser data de ikke skal se. Testeren velger selv hvilke utdanningstilbud og utdanninger som brukes i testcasene, så lenge de oppfyller kravene i testdata-tabellen.

### Testdata

Alle testcasene bruker opptaket «Sektordemo 23.10.26». Opptaket må være i ulike tilstander, og testbruker 1 (opptaksforvalter ved forvaltende organisasjon) flytter fristene i opptaket mellom fasene. Testcasene tas fase for fase, ikke i nummerrekkefølge. Fase 3–5 kommer sist, i tilfelle søknadsåpningen ikke kan flyttes tilbake. Ingenting trenger å settes tilbake etter testen.

| Fase | Fristene i Sektordemo 23.10.26 | Testcaser |
|---|---|---|
| 1 | Redigering av utdanningstilbud åpner i morgen | 2.5 |
| 2 | Redigering er åpen, og søknad er ikke åpnet | 1.1, 1.2, 1.4, 2.1–2.3, 2.6, del 3 og hele økt 2 (unntatt 9.4) |
| 3 | Søknad er åpnet, og redigering er fortsatt åpen | 1.3 |
| 4 | Redigering er stengt, og trekkfristen er ikke passert | 1.5, 2.7, 2.8, 4.1 |
| 5 | Trekkfristen er passert | 4.2 |

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| Opptaket, med deltakende organisasjoner, i fasene over | Sektordemo 23.10.26 | FS Admin, Opptak | Trenger ikke settes tilbake. Fjerning (1.1, 1.2, 1.4) og trekking (4.1) kan ikke angres. |
| Utdanningstilbud i opptaket: minst tre som kan fjernes, ett som kan trekkes, og ett for økt 2 med kompetanseregelverk og rangeringsregelverk | Testeren velger | Sektordemo 23.10.26 | Nei, de fjernes eller trekkes |
| Utdanningstilbud i opptaket fra UiT og UiO, med ulik starttermin og ulikt startår, og noen uten kompetanseregelverk eller rangeringsregelverk | Testeren velger | Sektordemo 23.10.26 | – |
| Utdanninger i utdanningsregisteret for de deltakende organisasjonene, nok til å legge til flere av gangen | Testeren velger | Utdanningsregisteret | – |
| Utdanningstilbud med og uten beskrivelses-URL i utdanningsregisteret | Testeren velger | Utdanningsregisteret | – |
| Standardregel for poenglikhet med tillatte unntak (9.1–9.3) | Sektordemo 23.10.26, som åpner for unntak fra standardregelen | FS Admin, Opptak | Ingenting endres |
| Reglene for poenglikhet som er tilgjengelige for opptaket. Bare de kan velges på utdanningstilbudet (9.3). | Reglene som er tilgjengelige i Sektordemo 23.10.26 | Opptaksinnstillingene i Sektordemo 23.10.26 | Ingenting endres |
| Utdanningstilbud i opptaket som bruker standardregelen for poenglikhet | Testeren velger | FS Admin, detaljsiden for utdanningstilbudet | Trenger ikke settes tilbake |
| Søknadsfrist for opptaket (14.1) | 15.04.2027 | Opptaksinnstillingene i Sektordemo 23.10.26 | – |

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

### 02 Utdanningstilbud i opptak

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Fjerne utdanningstilbud fra opptak](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/fjerne_utdanningstilbud.feature) | `@OPT-OPT-UTD-026` | `@in-progress` (delvis levert) | 5 |
| [Legge til utdanningstilbud i opptak](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/legge_til_utdanningstilbud.feature) | `@OPT-OPT-UTD-002` | `@in-progress` (delvis levert) | 7 |
| [Listevisning og søk i utdanningstilbud i opptaket](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/listevisning_utdanningstilbud.feature) | `@OPT-OPT-UTD-001` | `@in-progress` (delvis levert) | 6 |
| [Trekke utdanningstilbud fra opptak](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/trekke_utdanningstilbud.feature) | `@OPT-OPT-UTD-003` | `@in-progress` (delvis levert) | 2 |

Merknad: `@OPT-OPT-UTD-001` har åpne spørsmål om kravet som helhet: om det skal skrives om etter mønsteret for listevisning (liste, søk og filtrering, synlighet), og om Opptak skal skrive stegene i første person. Det endrer ikke det som testes nå.

### 04 Behandle et utdanningstilbud

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Angi beskrivelse av utdanningstilbudet til Min kompetanse](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_beskrivelse_til_min_kompetanse.feature) | `@OPT-OPT-UTD-016` | `@implemented` | 1 (scenariomal med 4 språk) |
| [Angi informasjon om studieavgift](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_studieavgift.feature) | `@OPT-OPT-UTD-022` | `@implemented` | 2 |
| [Angi søkeord på utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_s%C3%B8keord.feature) | `@OPT-OPT-UTD-017` | `@implemented` | 3 |
| [Kvoteflyt registreres ikke på utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/flytte_kvoteflyt_til_opptaksinnstillinger.feature) | `@OPT-OPT-UTD-013` | `@implemented` | 1 |
| [Overstyre regler for poenglikhet på utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/overstyre_regler_for_poenglikhet.feature) | `@OPT-OPT-UTD-015` | `@implemented` | 3 |
| [Registrere planlagt antall studieplasser](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_planlagte_studieplasser.feature) | `@OPT-OPT-UTD-012` | `@implemented` | 2 |
| [Registrere poengopplysninger for utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_poengopplysninger.feature) | `@OPT-OPT-UTD-010` | `@implemented` | 2 |
| [Registrere påkrevde attester på utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_p%C3%A5krevde_attester.feature) | `@OPT-OPT-UTD-014` | `@implemented` | 2 |
| [Registrere studietypenummer på utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_studietypenummer.feature) | `@OPT-OPT-UTD-011` | `@implemented` | 2 |
| [Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/sette_tidlig_s%C3%B8knadsfrist.feature) | `@OPT-OPT-UTD-025` | `@in-progress` (delvis levert) | 2 |
| [Vise URL til beskrivelse av utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/vise_beskrivelses_url.feature) | `@OPT-OPT-UTD-009` | `@implemented` | 2 |

Åpent spørsmål: `@OPT-OPT-UTD-025` «Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud»: Hva skjer med søkere som ikke har lastet opp dokumentasjon innen den tidlige dokumentasjonsfristen? Kan søkeren ikke laste opp etter fristen, eller merkes dokumentasjonen som levert for sent for saksbehandleren? Testes som det står.

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. I alt 42 scenarioer: 20 i 02 Utdanningstilbud i opptak og 22 i 04 Behandle et utdanningstilbud. To leverte scenarioer testes ikke i denne runden (se «Ikke med i denne testen»).

De automatiske testene av de samme kravene: `npx playwright test --grep "@OPT-OPT-UTD-026|@OPT-OPT-UTD-002|@OPT-OPT-UTD-001|@OPT-OPT-UTD-003|@OPT-OPT-UTD-016|@OPT-OPT-UTD-022|@OPT-OPT-UTD-017|@OPT-OPT-UTD-013|@OPT-OPT-UTD-015|@OPT-OPT-UTD-012|@OPT-OPT-UTD-010|@OPT-OPT-UTD-014|@OPT-OPT-UTD-011|@OPT-OPT-UTD-025|@OPT-OPT-UTD-009"`.

## Flyter

Ingen av kravene er med i en flyt.

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [Fjerne utdanningstilbud fra opptak](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/fjerne_utdanningstilbud.feature) | `@OPT-OPT-UTD-026` | `@in-progress` | «Muligheten til å fjerne utdanningstilbud vises ikke etter søknadsåpning»: fs-admin skjuler «Fjern» bare etter redigeringsfristen. «Deltakende organisasjon kan ikke fjerne utdanningstilbud en annen organisasjon tilbyr»: ikke levert (SHI-747). Lagt til etter rapporten 2026-10-22, og teamet har bekreftet at det ikke er levert. «Forvaltende organisasjon fjerner utdanningstilbud etter redigeringsfristen»: fs-admin skjuler «Fjern» for alle etter redigeringsfristen (åpent spørsmål). |
| [Legge til utdanningstilbud i opptak](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/legge_til_utdanningstilbud.feature) | `@OPT-OPT-UTD-002` | `@in-progress` | «Legge til alle utdanningstilbudene i en filtrert liste»: usikker, «Velg alle» velger bare de 50 radene som er lastet (åpent spørsmål). Regelen «Opptaksforvalter ser kun utdanningstilbud som matcher opptakets kriterier»: opptaket har ingen kriterier, og regelen bygger på `@OPT-OPT-UTD-005` (`@draft`). Regelen «Opptaksforvalter kan filtrere på utdanningstype og studienivå når utdanningstilbud legges til» (4 scenarioer): det finnes ikke filter på utdanningstype eller NKR 5.1/5.2 (åpent spørsmål). «Redigering er stengt når åpningsdatoen ikke er satt»: koden holder redigeringen åpen. «Endringer fra utdanningsregisteret oppdateres etter at redigering stenger»: ingen jobb oppdaterer tilbudene (åpent spørsmål). «Deltakende organisasjon kan ikke redigere utdanningstilbud en annen organisasjon tilbyr»: ikke levert (SHI-747). Lagt til etter rapporten 2026-10-22, og teamet har bekreftet at det ikke er levert. Regelen [«Opptaksforvalter ser campus for utdanningstilbudene som kan legges til»](https://github.com/sikt-no/fs/blob/e772f1b/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/legge_til_utdanningstilbud.feature) (2 scenarioer): ny regel 2026-10-23 ([#802](https://github.com/sikt-no/fs/pull/802)), ikke levert. Listen viser ikke campus ([SHI-748](https://sikt.atlassian.net/browse/SHI-748)). |
| [Listevisning og søk i utdanningstilbud i opptaket](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/listevisning_utdanningstilbud.feature) | `@OPT-OPT-UTD-001` | `@in-progress` | Regelen «Opptaksforvalter ved deltakende organisasjon ser kun utdanningstilbud organisasjonen tilbyr» (2 scenarioer): deltakende organisasjon ser alle tilbudene i opptaket. Filtrene på tilbud som mangler kvoteprioritet eller plassflyt (åpent spørsmål), opplysninger om tilbudsgaranti, dato for tidlig søknadsfrist og poenggrense for tidlig opptak: «Har mangler» tar bare med kompetanseregelverk, rangeringsregelverk og minst én kvote. Regelen om hva en deltakende organisasjon ser, testes likevel i den interne akseptansetesten (3.7 og 3.8), som en kjent mangel som ikke gir «Ikke godkjent» alene. Regelen [«Opptaksforvalter ser campus for utdanningstilbudene i opptaket»](https://github.com/sikt-no/fs/blob/e772f1b/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/listevisning_utdanningstilbud.feature) (1 scenario): ny regel 2026-10-23 ([#802](https://github.com/sikt-no/fs/pull/802)), ikke levert. Listen viser ikke campus ([SHI-749](https://sikt.atlassian.net/browse/SHI-749)). |
| [Trekke utdanningstilbud fra opptak](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/02%20Utdanningstilbud%20i%20opptak/trekke_utdanningstilbud.feature) | `@OPT-OPT-UTD-003` | `@in-progress` | «Opptaksforvalter ved deltakende organisasjon trekker utdanningstilbud organisasjonen tilbyr»: fs-admin har ingen trekk-knapp for deltakende organisasjon (åpent spørsmål). «Deltakende organisasjon kan ikke trekke utdanningstilbud en annen organisasjon tilbyr»: ikke levert (SHI-747). Lagt til etter rapporten 2026-10-22, og teamet har bekreftet at det ikke er levert. «Trekke utdanningstilbud etter søknadsåpning»: usikker, trekk styres av at opptaket er publisert og redigeringen stengt, ikke av søknadsåpningen (åpent spørsmål). |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/e772f1b/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | `@OPT-OVO-SAM-001` | `@in-progress` | Regelen «Organisasjoner som ikke deltar, kan ikke se opptaket» (2 scenarioer): «usikker» og «ikke funnet» i verifiseringen av opprette og vedlikeholde opptak 2026-10-19. Kravet hører til et annet scope (`@scope-opprette-opptak-2027`), men regelen testes i den interne akseptansetesten (3.9 og 3.10), som en kjent mangel som ikke gir «Ikke godkjent» alene. |
| [Angi beskrivelse av utdanningstilbudet til Min kompetanse](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_beskrivelse_til_min_kompetanse.feature) | `@OPT-OPT-UTD-016` | `@implemented`, delen `@in-progress` | «Søker ser beskrivelsen i Min kompetanse»: min-kompetanse henter ikke beskrivelsen, og viser beskrivelsen fra utdanningsregisteret (åpent spørsmål om språk som mangler). |
| [Angi søkeord på utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/angi_s%C3%B8keord.feature) | `@OPT-OPT-UTD-017` | `@implemented`, delen `@in-progress` | «Søker finner utdanningstilbud via søkeord»: søket for søkere matcher bare navnet (fs-plattform, og kanskje min-kompetanse). |
| [Registrere poengopplysninger for utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/registrere_poengopplysninger.feature) | `@OPT-OPT-UTD-010` | `@implemented`, delen `@in-progress` | «Se median poengsum for fjorårets opptatte»: fs-admin viser «Ikke tilgjengelig». Branchen `einor/shi-688-feat-median-og-poenggrenser` i fs-admin henter medianen, men er ikke merget. |
| [Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet](https://github.com/sikt-no/fs/blob/b67676a/krav/02%20Opptak/12%20Utdanningstilbud/04%20Behandle%20et%20utdanningstilbud/sette_tidlig_s%C3%B8knadsfrist.feature) | `@OPT-OPT-UTD-025` | `@in-progress` | «Tidlig søknadsfrist må være før søknadsfristen for opptaket»: verken fs-plattform eller fs-admin sjekker det (åpent spørsmål). |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| `@OPT-OPT-UTD-002` «Organisasjon som ikke deltar kan ikke legge til utdanningstilbud» (testcase 2.4) | Testes ikke i denne runden. Scenarioet er levert. |
| `@OPT-OPT-UTD-015` «Kan ikke overstyre regel for poenglikhet når opptaket ikke åpner for unntak» (testcase 9.4) | Testes ikke i denne runden. Scenarioet er levert. |
| `@OPT-OPT-UTD-019` Vise endringslogg for utdanningstilbudet | Ikke avklart ennå (`@draft`): hvilke felt som logges, og kravene fra Team Bat om endringslogg |
| `@OPT-OPT-UTD-021` Vise lenke til tidligere utdanningstilbud | Ikke avklart ennå (`@draft`): hva «tidligere utdanningstilbud» betyr, og om lenken settes manuelt |
| `@OPT-OPT-UTD-027` Sette kjønnspoeng på utdanningstilbudet | Kommer senere (`@draft`, skjelett uten scenarioer) |
| `@OPT-OPT-UTD-029` Vise poenggrense og ventelistenummer for søker | Kommer senere (`@draft`, skjelett uten scenarioer) |
| `@OPT-OPT-UTD-030` Eksportere utdanningstilbudet | Kommer senere (`@draft`, skjelett uten scenarioer) |
| `@OPT-OPT-UTD-031` Sammenligne med tidligere utdanningstilbud | Kommer senere (`@draft`, skjelett uten scenarioer) |
| `@OPT-OPT-UTD-003` «Søkere varsles når utdanningstilbudet de har søkt på, trekkes» | Ikke avklart ennå (`@draft @openquestion`): hva som skal skje med søkere som har søkt på utdanningstilbudet, og hvem som har ansvaret for avklaringen (SHI-685) |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | [Fylles ut: navn] | Eier testen fra start til beslutning, og skriver beslutningen i testrapporten |
| Kontaktperson i teamet | [Fylles ut: navn] | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut: navn] | [Fylles ut: hvilke deler] |
| Eksterne testere | [Fylles ut: HK-dir, læresteder] | Bare når leveransen skal til ekstern akseptansetest |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | Avklares med de eksterne partene |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Utdanningstilbud i samordna opptak 2027» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene er identifisert og tilgjengelige | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt | Ikke nødvendig: testdataene trenger ikke settes tilbake etter testen |
| 4 | Testbrukerne finnes i rollene leveransen gjelder, i minst to organisasjoner | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | Ikke oppfylt: 44 av 71 scenarioer funnet (25 ikke funnet, 2 usikker), og de tre scenarioene fra SHI-747 er ikke levert. Av de 44 som er funnet, testes 42 (to testes ikke i denne runden). Rapportene er kontrollert av `fs-verify-kontroll`, ikke av en annen person: [Fylles ut: hvem kontrollerer rapportene] |
| 6 | Testcasene er laget og gått gjennom av testansvarlig | Laget, venter på gjennomgang av testansvarlig |
| 7 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |

## Kriterier for godkjent

Testansvarlig skriver hva som skal til for at testen blir godkjent, helst før utviklingen starter.

[Fylles ut av testansvarlig]

## Funn og alvorlighetsgrad

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig.

## Beslutning

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Hvem som beslutter etter den eksterne akseptansetesten, avklares med de eksterne partene.

## Status i flyten

| Steg | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | [Verifisering – 02 Utdanningstilbud i opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137367045), [Verifisering – 04 Behandle et utdanningstilbud](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137596442) | 02: 17 ikke funnet, 2 usikker. 04: 8 ikke funnet, 0 usikker. Rapportene er eldre enn de tre scenarioene fra SHI-747, som teamet har bekreftet at ikke er levert | 2026-10-22 |
| 2. Testplan | (denne siden) | Laget | 2026-10-23 |
| 3. Testrapport – verifisering | – | Venter | |
| 4. Intern akseptansetest | [Intern akseptansetest – Utdanningstilbud i samordna opptak 2027](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5136613418) | Klar til test | 2026-10-23 |
| 4b. CDP-kjøring (valgfri) | – | Ikke aktuell | |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | – | Venter | |
| 7. Testrapport – ekstern | – | Venter | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
