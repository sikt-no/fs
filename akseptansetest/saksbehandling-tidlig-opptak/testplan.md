# Testplan – Saksbehandling av tidlig opptak

- **Leveranse**: feature-fil
- **Kilde**: `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/finne_søknader_om_tidlig_opptak.feature`, `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vurdere_søknad_om_tidlig_opptak.feature`
- **Scope**: –
- **Oppgaver**: [opptak/tidlig-opptak](../../tasks/opptak/tidlig-opptak/oppgave.md)
- **Krav**: 2 feature-filer, 2 `@implemented`, 0 delvis levert, 0 flyter, commit `5605e7e` (2026-10-27)
- **Verifisering**: [verify-finne_søknader_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-finne_s%C3%B8knader_om_tidlig_opptak-2026-10-26-1441.md), [verify-vurdere_søknad_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-vurdere_s%C3%B8knad_om_tidlig_opptak-2026-10-26-1441.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786
- **Laget**: 2026-10-27 av fs-testplan

---

Testplan for «Saksbehandling av tidlig opptak». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Saksbehandleren kan filtrere sakene i et opptak på om søkeren har søkt om tidlig opptak, og på om saken mangler eller har konklusjon for tidlig opptak. I saken ser saksbehandleren søkerens begrunnelse og dokumentasjonskravet for den, og velger en av opptakets konklusjoner for tidlig opptak. Konklusjonen gjelder organisasjonen som behandler saken, og kan endres også etter at tidligopptaket er gjennomført. Steget for tidlig opptak vises bare når søkeren har søkt. |
| Versjon | [Fylles ut: versjon i test-fsadmin] (verifisert mot main: fs-plattform `97fbafa9b3`, fs-admin `2b7d1f87a`) |
| Testmiljø | [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/) |
| Feature-flagg | Ingen |
| Kilde | [finne_søknader_om_tidlig_opptak.feature](https://github.com/sikt-no/fs/blob/5605e7e/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/finne_s%C3%B8knader_om_tidlig_opptak.feature), [vurdere_søknad_om_tidlig_opptak.feature](https://github.com/sikt-no/fs/blob/5605e7e/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vurdere_s%C3%B8knad_om_tidlig_opptak.feature) |
| Scope | Ingen |
| Saker | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) · [STEK-188](https://sikt.atlassian.net/browse/STEK-188), [STEK-268](https://sikt.atlassian.net/browse/STEK-268), [STEK-561](https://sikt.atlassian.net/browse/STEK-561) |
| Berører andre team | Nei |
| Kjente begrensninger | Kortet viser søkerens behov (teksten søkeren så, i første person) under «Begrunnelse fra søker», ikke navnet på begrunnelsen. Mangler teksten for en begrunnelse, vises «-». «Har konklusjon» i filteret tar også med en sak med konklusjon der søkeren ikke har søkt (bare mulig utenom saksbehandlingen). Begge står i verify-rapportene. |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | [Fylles ut: navn] | Saksbehandler, med rett til å endre i søknadsbehandlingen | [Fylles ut: organisasjon A, f.eks. OsloMet] | Alle scenarioene i `@OPT-BEH-BEH-009` og `@OPT-BEH-BEH-013` |
| 2 | [Fylles ut: navn] | Saksbehandler, med rett til å endre i søknadsbehandlingen | [Fylles ut: organisasjon B, f.eks. NTNU] | `@OPT-BEH-BEH-013` «Konklusjon per organisasjon» |

Testbrukerne finnes i minst to organisasjoner, så vi kan teste at ingen ser data de ikke skal se.

### Testdata

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| Opptak med tidlig opptak slått på, med begrunnelser (med dokumentasjonskrav) og konklusjoner for tidlig opptak (f.eks. «KFF – Kan få tidlig opptak, har godkjent grunn» og «KIF – Kan ikke få tidlig opptak, mangler grunn») | [Fylles ut: opptak] | [Fylles ut: lenke] | [Fylles ut] |
| Søker A: har søkt om tidlig opptak, uten konklusjon | [Fylles ut: søker] | [Fylles ut] | Ja: velg «Ikke valgt» i «Konklusjon» |
| Søker B: har søkt om tidlig opptak, uten konklusjon | [Fylles ut: søker] | [Fylles ut] | – (endres ikke) |
| Søker C: har ikke søkt om tidlig opptak | [Fylles ut: søker] | [Fylles ut] | – (endres ikke) |
| Søker D: har søkt om tidlig opptak, uten konklusjon, med søknadsalternativer ved organisasjon A og organisasjon B | [Fylles ut: søker] | [Fylles ut] | Ja: velg «Ikke valgt» i «Konklusjon», ved begge organisasjonene |

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Vurdere søknad om tidlig opptak](https://github.com/sikt-no/fs/blob/5605e7e/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vurdere_s%C3%B8knad_om_tidlig_opptak.feature) | `@OPT-BEH-BEH-013` | `@implemented` | 6 av 9 (se «Ikke med i denne testen») |
| [Finne søknader om tidlig opptak](https://github.com/sikt-no/fs/blob/5605e7e/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/finne_s%C3%B8knader_om_tidlig_opptak.feature) | `@OPT-BEH-BEH-009` | `@implemented` | 2 av 6 (se «Ikke med i denne testen») |

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av de samme kravene: `npx playwright test --grep "@OPT-BEH-BEH-009|@OPT-BEH-BEH-013"`.

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

Ingen av kravene er med i en flyt.

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

Ingen.

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Detaljtesting av filtrene i «Finne søknader om tidlig opptak» (`@OPT-BEH-BEH-009`): «Filteret for tidlig opptak er ikke i bruk som standard», «Har konklusjon» i «Filtrere på tidlig opptak», «Valgene for konklusjon kombineres med eller», «Søkt om tidlig opptak kombineres med valgene for konklusjon med og» og «Filteret for tidlig opptak kombineres med saksbehandlingsstatus» | Scopet ut av denne testen. Det viktigste for saksbehandleren er å finne sakene som har med tidlig opptak å gjøre, og sakene som mangler konklusjon. Det testes. Alle scenarioene er funnet i koden i verifiseringen. |
| «Konkludere før dokumentasjonsfristen har gått ut» i «Vurdere søknad om tidlig opptak» (`@OPT-BEH-BEH-013`) | Scopet ut av denne testen. Kjøres testen før fristen, konkluderer testeren uansett før fristen. At konklusjonen ikke er knyttet til fristen, er funnet i koden i verifiseringen. |
| Søke om tidlig opptak (`@OPT-SØK-SØK-011`) | Utenfor leveransen. Søkeren lager søknadene saksbehandleren behandler, og de står i testdataene. |
| Regelen «Konklusjonen kan endres også etter at tidligopptaket er gjennomført» i «Vurdere søknad om tidlig opptak» (`@OPT-BEH-BEH-013`): «Endre konklusjon før tidligopptaket er gjennomført» og «Endre konklusjonen etter at tidligopptaket er gjennomført» | Scopet ut av denne testen. Å endre konklusjonen før gjennomføringen testes alt når testeren bytter konklusjon i «Konkludere om søkeren deltar i tidligopptaket». Å endre den etter gjennomføringen krever et opptak der tidligopptaket er gjennomført, og tas med når gjennomføringen av tidligopptaket (`@OPT-BEH-BEH-007`) testes. |
| Gjennomføre tidligopptaket og gi tilbudsgaranti (`@OPT-BEH-BEH-007`) | Utenfor leveransen |
| Publisere svar på tidlig opptak (`@OPT-BEH-BEH-014`) og søkerens svar (`@OPT-SØK-SØK-012`) | Utenfor leveransen |
| Søknadsmangel når dokumentasjonen mangler (`@OPT-BEH-BEH-008`) | Utenfor leveransen. Saksbehandleren bruker de vanlige søknadsmanglene. |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | [Fylles ut: navn] | Eier testen fra start til beslutning, og skriver beslutningen i testrapporten |
| Kontaktperson i teamet | [Fylles ut: navn] | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut: navn] | [Fylles ut: hvilke deler] |
| Eksterne testere | [Fylles ut: om leveransen skal til ekstern akseptansetest, og hvem] | Bare når leveransen skal til ekstern akseptansetest |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | Avklares med de eksterne partene |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Saksbehandling av tidlig opptak» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene er identifisert og tilgjengelige | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt | [Fylles ut av teamet] |
| 4 | Testbrukerne finnes i rollene leveransen gjelder, i minst to organisasjoner | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | Alle 15 scenarioene er funnet (2026-10-26), kontrollert av `fs-verify-kontroll`. Kontroll av en annen person: Venter |
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
| 1. Verifisering (`fs-verify`) | [verify-finne_søknader_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-finne_s%C3%B8knader_om_tidlig_opptak-2026-10-26-1441.md), [verify-vurdere_søknad_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-vurdere_s%C3%B8knad_om_tidlig_opptak-2026-10-26-1441.md) · Confluence: [Finne søknader](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148966925), [Vurdere søknad](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148835843) | Alt funnet | 2026-10-26 |
| 2. Testplan | (denne siden) | Laget | 2026-10-27 |
| 3. Testrapport – verifisering | [testrapport-verifisering-2026-10-27.md](testrapport-verifisering-2026-10-27.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148803102) | Klar | 2026-10-27 |
| 4. Intern akseptansetest | [testcaser-intern.md](testcaser-intern.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5149065264) | Klar til test | 2026-10-27 |
| 4b. CDP-kjøring (valgfri) | – | Ikke aktuell | |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | – | Venter | |
| 7. Testrapport – ekstern | – | Venter | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
