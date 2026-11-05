# Testplan – Se søkerens elektroniske vitnemål

- **Leveranse**: feature-fil
- **Kilde**: `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature`
- **Scope**: @scope-vitnemalsbehandling
- **Scope-fil**: [opptak/vitnemalsbehandling](../../tasks/opptak/vitnemalsbehandling/scope.md)
- **Krav**: 1 feature-fil, 0 `@implemented`, 1 delvis levert, 0 flyter, commit `e66cf6bb` (2026-11-05). Taggene `@implemented` på linje 164 og 187 er ikke committet
- **Verifisering**: [verify-vise_elektroniske_vitnemål-2026-11-05-1242.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-vise_elektroniske_vitnem%C3%A5l-2026-11-05-1242.md)
- **Confluence**: –
- **Laget**: 2026-11-05 av fs-testplan

- **Undersider**: [omfang.md](omfang.md), [testcaser-og-testdata.md](testcaser-og-testdata.md), [sporbarhet.md](sporbarhet.md)

---

Testplan for «Se søkerens elektroniske vitnemål». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Innhold

Testplanen er delt i hovedsiden og tre undersider, så hver del kan oppdateres for seg. I Confluence står innholdsfortegnelsen og lista over undersider (med testrapportene og testsidene) over tabellen.

| Side | Innhold | Fil |
|---|---|---|
| Testplan (denne siden) | Testbeskrivelse, roller, tid og kanal, forutsetninger, kriterier for godkjent, funn, beslutning, status i flyten og vedlegg | `testplan.md` |
| Omfang – Se søkerens elektroniske vitnemål | Kravene og flytene som testes, åpne spørsmål, avhengighetskart, det som venter på verifisering, regler uten scenario og det som ikke er med | `omfang.md` |
| Testcaser og testdata – Se søkerens elektroniske vitnemål | Omfanget av testcasene som skal lages, testbrukerne, tilgangsmatrisen og testdataene | `testcaser-og-testdata.md` |
| Sporbarhet – Se søkerens elektroniske vitnemål | Scenarioene fra kravet til koden og til testen | `sporbarhet.md` |

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Saksbehandleren ser søkerens elektroniske vitnemål fra KREG i steg 2 «Grunnlag» i saksbehandlingen i FS Admin, i seksjonen «Vitnemålsbehandling». Seksjonen er lukket, med antall vitnemål, og viser hvert vitnemål med nummer, utstedt dato, GSK, førstegangsvitnemål og karakter-, realfags- og språkpoeng. Et vitnemål kan åpnes i ny fane, og et annullert vitnemål vises bare når det er brukt i en beregning på opptaket. Dette er leveranse L1 i vitnemålsbehandlingen: bare visning, ingen valg |
| Versjon | main 2026-11-05: fs-plattform `e2ed43b3ce`, fs-admin `f1d15446a` |
| Testmiljø | [https://test-fsadmin.sikt.no](https://test-fsadmin.sikt.no) |
| Feature-flagg | Ingen |
| Kilde | [vise_elektroniske_vitnemål.feature](https://github.com/sikt-no/fs/blob/e66cf6bb/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vise_elektroniske_vitnem%C3%A5l.feature) |
| Scope | `@scope-vitnemalsbehandling` · [`scope.md` på GitHub](https://github.com/sikt-no/fs/blob/e66cf6bb/tasks/opptak/vitnemalsbehandling/scope.md) |
| Saker | GitHub #613 (L1) · initiativ #607 |
| Berører andre team | Nei. Leveransen bygger på importen fra KREG og poengberegningen i opptak (se avhengighetskartet) |
| Kjente begrensninger | «Vitnemålene kan ikke hentes» er ikke laget: en feilet henting fra KREG lagres ikke, og seksjonen skjules. «Åpne vitnemålsoversikten» testes ikke: opptakssystemets påstand om GSK vises bare som en tekst ved uenighet. «Bruker uten lesetilgang ser ikke vitnemålsoversikten» er usikker i verifiseringen: opptaksforvalteren og tilbyderen ser også vitnemålene. Et vitnemål fra en annen organisasjon kan hentes direkte i API-et på id-en (MR !3337 retter fs-admin, ikke API-et). Fs-admin viser i tillegg et varsel over tabellen når et annullert vitnemål vises, som kravet sier hører til L2. Testdata for «Poeng som ikke kan beregnes» og «Annullert vitnemål som er brukt i en beregning» finnes ikke ennå |
| Avhengighetskart | Under «Flyter» på Omfang – Se søkerens elektroniske vitnemål |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | [Fylles ut] | Eier testen fra start til beslutning. Har ansvaret for at agenten blir kjørt og tester riktig (kjøringen kan gjøres av andre), går gjennom testcasene før kjøringen og funnene etterpå, tar stikkprøver av beståtte testcaser etter en risikovurdering, og skriver beslutningen i testrapporten |
| Kjører av agenten | Anne Katrine Bækkelie Grutle | Starter den agentiske funksjonstesten (fase 2) |
| Kontaktperson i teamet | Anne Katrine Bækkelie Grutle | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut] | [Fylles ut] |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Agentisk funksjonstest | [Fylles ut: dato]. Agenten kjøres av Anne Katrine Bækkelie Grutle |
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | Ikke aktuell |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Se søkerens elektroniske vitnemål» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene i «Testdata» finnes i testmiljøet, i utgangstilstanden der. Tilstander som bygger på datoer, er sjekket samme dag som testen | Ikke klar: `sak-vitnemal-uten-poeng` og `sak-annullert-vitnemal-brukt` mangler, og `sak-annullert-vitnemal-ikke-brukt` er ikke bekreftet |
| 3 | Testdataene kan settes tilbake før hver kjøring | Nei (miljøfila). Søkerne med vitnemål fra KREG kan ikke lages av testene |
| 4 | Testbrukerne finnes i rollene ved organisasjonene kravene gjelder (tilgangsmatrisen) | [Fylles ut av teamet: bekreft at sakene i opptak 62 behandles av NTNU, og at `OPPTAK_SAKSBEHANDLER` gir SE_SØKNADSBEHANDLING] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten. Åpne spørsmål stopper ikke, og står i «Åpne spørsmål» | Venter: 1 ikke funnet, 2 usikker (2026-11-05). Menneskelig kontroll er ikke gjort |
| 6 | De agentiske testcasene (`fs-testcaser-cdp`) er laget, og testansvarlig og teamet har gått gjennom dem før kjøringen | Venter |
| 7 | Flyttestcasene for den interne akseptansetesten (`fs-testcaser-intern`) er laget og gått gjennom av testansvarlig | Venter |
| 8 | Testansvarlig er logget inn i FS Admin i en egen Chrome-profil til testingen, CDP-agenten kan bytte til hver testbruker i «Overstyrt bruker», og nøklene i testbrukere og testdata er utfylt | [Fylles ut av teamet] |
| 9 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |

## Kriterier for godkjent

Kravene i «Omfang» er kriteriene for godkjent: hvert scenario er et akseptansekriterium. Mangler et viktig tilfelle, legges det inn i kravet (`fs-krav`), ikke her. Fasene er ferdige når:

| Fase | Ferdig når |
|---|---|
| 1. Verifisering | Alle scenarioene er funnet, og en annen person har kontrollert rapporten. Åpne spørsmål står i testplanen, men stopper ikke |
| 2. Agentisk funksjonstest | Alle testcasene er kjørt, ingen funn med «Stopper» står åpne, og testansvarlig har gått gjennom rapporten. Det er inngangskriteriet til intern akseptansetest |
| 3. Intern akseptansetest | Beslutningen er tatt: godkjent, godkjent med forbehold eller ikke godkjent |
| 4. Ekstern akseptansetest | Beslutningen er tatt: godkjent, godkjent med forbehold eller ikke godkjent, vurdert mot flytene og kravene. Hvem som beslutter, er avtalt med partene før testen |

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
| Ikke godkjent | Leveransen går tilbake til teamet med funnene (i fase 3 og 4). |

Selve beslutningen står i testrapportene.

## Status i flyten

| Fase | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | [verify-vise_elektroniske_vitnemål-2026-11-05-1242.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-vise_elektroniske_vitnem%C3%A5l-2026-11-05-1242.md) | 1 ikke funnet, 2 usikker | 2026-11-05 |
| 1. Testplan | (denne siden) | Laget | 2026-11-05 |
| 2. Agentisk funksjonstest | – | Venter | |
| 3. Intern akseptansetest | – | Venter | |
| 4. Ekstern akseptansetest | – | Ikke aktuell | |

Testrapportene (verifisering, agentisk, intern og ekstern) står som undersider, og lenken står i raden for fasen.

## Vedlegg

| Vedlegg | Lenke |
|---|---|
| Verifiseringsrapporten (fase 1) | [verify-vise_elektroniske_vitnemål-2026-11-05-1242.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-vise_elektroniske_vitnem%C3%A5l-2026-11-05-1242.md) |
| Agentisk testrapport (fase 2) | – |
| Testcasene for fase 2 | – |
| Testcasene for fase 3 | – |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
