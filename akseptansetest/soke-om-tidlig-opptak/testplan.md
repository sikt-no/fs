# Testplan – Søke om tidlig opptak

- **Leveranse**: feature-fil
- **Kilde**: `krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/søke_om_tidlig_opptak.feature`
- **Scope**: –
- **Oppgaver**: [opptak/tidlig-opptak](../../tasks/opptak/tidlig-opptak/oppgave.md)
- **Krav**: 1 feature-filer, 1 `@implemented`, 0 delvis levert, 0 flyter, commit `709fc89` (2026-10-26)
- **Verifisering**: [verify-søke_om_tidlig_opptak-2026-10-26-0950.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/verify-s%C3%B8ke_om_tidlig_opptak-2026-10-26-0950.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5144772613
- **Laget**: 2026-10-26 av fs-testplan

---

Testplan for «Søke om tidlig opptak». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Søkeren kan søke om tidlig opptak i Min kompetanse, fra søknaden etter at den er sendt. Søkeren ser hvilke søknadsalternativer som ikke tilbyr tidlig opptak, leser hvem som kan søke og hva som må dokumenteres for hver begrunnelse, velger én begrunnelse og sender. Søkeren får kvittering i Mine meldinger. Søknaden om tidlig opptak gjelder hele søknaden, og kan bare sendes før fristen for tidlig opptak. Hvordan søknaden vurderes, og svaret søkeren får, testes ikke her. |
| Versjon | [Fylles ut: versjon eller dato for deploy. Verifisert mot fs-plattform `26d0862b43` og min-kompetanse `ab8be322`] |
| Testmiljø | [https://test.minkompetanse.no/](https://test.minkompetanse.no/) |
| Feature-flagg | `enable-tidlig-opptak` (på i testmiljøet) |
| Kilde | Feature-fila [søke_om_tidlig_opptak.feature](https://github.com/sikt-no/fs/blob/709fc898357b5c8e2b0d62571983b02c296746a6/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature), i oppgaven [tidlig-opptak](https://github.com/sikt-no/fs/tree/709fc898357b5c8e2b0d62571983b02c296746a6/tasks/opptak/tidlig-opptak) |
| Scope | Ingen |
| Saker | [#456](https://github.com/sikt-no/fs/issues/456), [#525](https://github.com/sikt-no/fs/issues/525) · [STEK-188](https://sikt.atlassian.net/browse/STEK-188), [STEK-267](https://sikt.atlassian.net/browse/STEK-267) |
| Berører andre team | Nei |
| Kjente begrensninger | <ul><li>Søkeren kan ikke trekke ønsket om tidlig opptak. Når en testbruker har søkt, kan det ikke gjøres om i løsningen, så hver gjennomkjøring trenger en søker som ikke har søkt.</li><li>Søknaden lagrer ikke når søkeren søkte om tidlig opptak. Søkeren ser «Du har søkt om tidlig opptak.» uten dato, og tidspunktet står i kvitteringen i Mine meldinger. Å vise tidspunktet på søknaden er en utvidelse for senere.</li><li>Etter fristen for tidlig opptak vises ikke boksen «Tidlig opptak» for en søker som ikke har søkt.</li><li>Løsningen godtar en søknad om tidlig opptak når opptaket har tidlig opptak, selv om ingen av søkerens søknadsalternativer tilbyr det. Min kompetanse viser ikke muligheten i det tilfellet, så søkeren merker det ikke.</li><li>Kravet bygger på at tidlig opptak er slått på i opptaket og på utdanningstilbudet (`@OPT-OVO-INN-001`, `@OPT-OPT-UTD-004`). Ingen av de kravene er levert ennå, så innstillingene må være satt i testdataene.</li></ul> |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | Samtidig Sild (fødselsnummer 10830798485, søknad 1000670). Gjøres klar før testen: legger til «Biovitenskap» ved UiO, så søknaden har ett søknadsalternativ som ikke tilbyr tidlig opptak | Søker med en sendt søknad der noen søknadsalternativer tilbyr tidlig opptak og noen ikke, og som ikke har søkt om tidlig opptak | – | Søke om tidlig opptak, se søknadsalternativene som ikke tilbyr det, begrunnelsene og lenken, og legge til et søknadsalternativ etterpå (`@OPT-SØK-SØK-011`) |
| 2 | Heidi Lykke (fødselsnummer 05849540000, søknad 1004306), med bare «Rettsvitenskap (jus)» ved UiO | Søker med en sendt søknad der ingen søknadsalternativer tilbyr tidlig opptak | – | Ikke kunne søke om tidlig opptak (`@OPT-SØK-SØK-011`) |
| 3 | Fredag Lørdag (fødselsnummer 12919210263), med en søknad i opptaket som ikke er sendt | Søker som ikke har sendt søknaden ennå | – | Ikke kunne søke om tidlig opptak før søknaden er sendt (`@OPT-SØK-SØK-011`) |
| 4 | Ullen Bikkje (fødselsnummer 31900699630, søknad 1004225 i opptak 2) | Søker med en sendt søknad i opptaket der søknadsfristen for tidlig opptak er ute, der minst ett søknadsalternativ tilbyr tidlig opptak, og som ikke har søkt om tidlig opptak | – | Ikke kunne søke om tidlig opptak etter fristen (`@OPT-SØK-SØK-011`) |

Testbrukerne er søkere, som ikke hører til en organisasjon. Det er ingen synlighet mellom organisasjoner å teste i denne leveransen.

### Testdata

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| Et opptak med tidlig opptak, en søknadsfrist for tidlig opptak som ikke er ute, lenke til informasjon om tidlig opptak, og begrunnelser for tidlig opptak der minst én ikke er aktiv | «Samordna UHG-simulering høsten 2026» (opptak 34). Søknadsfristen for tidlig opptak er 6.10.2027. Grunnlaget «Avvikle virksomheten» gjøres inaktivt før testen (1.4), med `tidlig-opptak-34-gjor-grunnlag-inaktivt.sql` i `fs-plattform/opptak/local/`, og aktivt igjen etterpå med `tidlig-opptak-34-gjor-grunnlag-aktivt.sql` | Min kompetanse | Ja, grunnlaget gjøres aktivt igjen etter testen |
| Utdanningstilbud i opptaket som tilbyr tidlig opptak, og utdanningstilbud som ikke gjør det | 23 tilbyr tidlig opptak. «Biovitenskap» og «Rettsvitenskap (jus)» ved UiO gjør det ikke | Min kompetanse. Flere opptak har utdanningstilbud med de samme navnene. De i opptak 34 har søknadsfrist 13.10.2027 | Trengs ikke |
| Et utdanningstilbud som tilbyr tidlig opptak, som testbruker 1 kan legge til etter å ha søkt | «Grunnskolelærerutdanning for trinn 5-10 (300 studiepoeng)» i Halden (utdanningstilbud 126) | Min kompetanse, søknadsfrist 13.10.2027 | Søknadsalternativet kan fjernes igjen |
| Et opptak med tidlig opptak der søknadsfristen for tidlig opptak er ute (22.10.2026), og et utdanningstilbud som tilbyr tidlig opptak, for 1.9 | «Opptak UHM 2025» (opptak 2) | Min kompetanse | Trengs ikke, opptaket endres ikke |
| Søknadene til testbruker 1, 2 og 3. Søknadene i testmiljøet blir ikke liggende lenge, så de sjekkes, og gjøres klare igjen ved behov, dagen før testen | – | Min kompetanse | Ja, som i «Gjør klar»-stegene i testcasene |
| Søknaden om tidlig opptak fra testbruker 1 | – | – | Nei, søkeren kan ikke trekke ønsket. Bruk en ny søker, eller nullstill i databasen |

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Søke om tidlig opptak](https://github.com/sikt-no/fs/blob/709fc898357b5c8e2b0d62571983b02c296746a6/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature) | `@OPT-SØK-SØK-011` | `@implemented` | 9 |

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av de samme kravene: `npx playwright test --grep "@OPT-SØK-SØK-011"`.

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

Ingen av kravene er med i en flyt.

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

Ingen.

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| `@OPT-SØK-SØK-011` «Se når søkeren søkte om tidlig opptak» | Ikke avklart ennå: en utvidelse for senere, som ikke er prioritert nå |
| `@OPT-SØK-SØK-011` regelen «Søkeren ser dokumentasjonsfristen for tidlig opptak» | Utkast, ikke avklart ennå |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | [Fylles ut] | Eier testen fra start til beslutning, og skriver beslutningen i testrapporten |
| Kontaktperson i teamet | [Fylles ut] | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut] | [Fylles ut] |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | [Fylles ut: dato, «Avklares med de eksterne partene» eller «Ikke aktuell»] |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Søke om tidlig opptak» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene er identifisert og tilgjengelige | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt | [Fylles ut av teamet] |
| 4 | Testbrukerne finnes i rollene leveransen gjelder, i minst to organisasjoner | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | `fs-verify` fant alle 9 scenarioene (2026-10-26 09:50), kontrollert av `fs-verify-kontroll`. Kontrollen av en person venter på steg 3 |
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
| 1. Verifisering (`fs-verify`) | [Verifisering – Søke om tidlig opptak – 2026-10-26 09:50](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5143887891) · [verify-søke_om_tidlig_opptak-2026-10-26-0950.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/verify-s%C3%B8ke_om_tidlig_opptak-2026-10-26-0950.md) | Alt funnet | 2026-10-26 |
| 2. Testplan | (denne siden) | Laget | 2026-10-26 |
| 3. Testrapport – verifisering | [Testrapport – verifisering – Søke om tidlig opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5146836993) · [testrapport-verifisering-2026-10-26.md](testrapport-verifisering-2026-10-26.md) | Klar | 2026-10-26 |
| 4. Intern akseptansetest | [Intern akseptansetest – Søke om tidlig opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5146705926) · [testcaser-intern.md](testcaser-intern.md) | Klar til test | 2026-10-26 |
| 4b. CDP-kjøring (valgfri) | – | Ikke aktuell | |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | – | Venter | |
| 7. Testrapport – ekstern | – | Venter | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
