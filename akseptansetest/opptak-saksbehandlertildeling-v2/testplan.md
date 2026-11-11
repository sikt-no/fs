# Testplan – Saksbehandlertildeling, runde 2

- **Leveranse**: feature-fil (`@OPT-BEH-BEH-011`) og flyt (`@FLY-OPT-SAK-001`)
- **Kilde**: `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature`, `krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature`
- **Scope**: –
- **Krav**: 2 feature-filer, 1 `@implemented`, 0 delvis levert, 1 flyt (`@planned`, testes delvis), commit `7d4ee5d1` (2026-11-04)
- **Verifisering**: [verify-tildele_saksbehandlende_organisasjon-2026-11-04-1317.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-tildele_saksbehandlende_organisasjon-2026-11-04-1317.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2
- **Laget**: 2026-11-04 av fs-testplan
- **GitHub-lenker**: gjelder branchen `krav/saksbehandlertildeling-v2` til PR-en er merget. Kravene og verify-rapporten ligger ikke på `main` ennå
- **Runde 1**: [Akseptansetesting saksbehandlertildeling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130911779/Akseptansetesting+saksbehandlertildeling) (Confluence) og [`akseptansetest/opptak-saksbehandlertildeling/`](../opptak-saksbehandlertildeling/)

- **Undersider**: [omfang.md](omfang.md), [testcaser-og-testdata.md](testcaser-og-testdata.md), [sporbarhet.md](sporbarhet.md)

---

Testplan for «Saksbehandlertildeling, runde 2». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt i hakeparentes som begynner med «Fylles ut» fylles ut før testen.

## Innhold

Testplanen er delt i hovedsiden og tre undersider, så hver del kan oppdateres for seg. I Confluence står innholdsfortegnelsen og lista over undersider (med testrapportene og testsidene) over tabellen.

| Side | Innhold | Fil |
|---|---|---|
| Testplan (denne siden) | Testbeskrivelse, roller, tid og kanal, forutsetninger, kriterier for godkjent, funn, beslutning, status i flyten og vedlegg | `testplan.md` |
| [Omfang – Saksbehandlertildeling, runde 2](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5169872955/Omfang+Saksbehandlertildeling+runde+2) | Kravene og flytene som testes, åpne spørsmål, avhengighetene, det som venter på verifisering, regler uten scenario og det som ikke er med | `omfang.md` |
| [Testcaser og testdata – Saksbehandlertildeling, runde 2](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170364449/Testcaser+og+testdata+Saksbehandlertildeling+runde+2) | Omfanget av testcasene som skal lages, testbrukerne, tilgangsmatrisen og testdataene | `testcaser-og-testdata.md` |
| [Sporbarhet – Saksbehandlertildeling, runde 2](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5169250346/Sporbarhet+Saksbehandlertildeling+runde+2) | Scenarioene fra kravet til koden og til testen | `sporbarhet.md` |

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | I et samordna opptak fordeles hvert søknadsalternativ til én saksbehandlende organisasjon, og søknaden blir én sak hos hver av dem. Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene i FS Admin, med unntak for utdanningsbakgrunn og ledige studieplasser. Nytt siden runde 1: unntak for lærested («Saksbehandles av» og «På vegne av»), så et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket. Tilbyderen ser saken i lesemodus når en annen organisasjon saksbehandler utdanningstilbudet (ikke interne merknader eller dokumenter), og kan sette tilbudsgaranti. Søkeren ser hvem som saksbehandler under «Kontakt saksbehandler» i Min kompetanse. Flyttes et søknadsalternativ, får organisasjonen det flyttes til en ny, ubehandlet sak, tilbudsgarantiene følger med, og de interne merknadene blir igjen. Rettingene fra runde 1 er med: feilmelding ved bytte av standardregel (STEK-652), forklaring når en regel ikke kan deaktiveres (STEK-653), nytt søknadsalternativ som overskrev saken (STEK-655), nytt søknadsalternativ som følger fordelingen søknaden har (STEK-656), og opptaksforvalteren ved HK-dir som kan overstyre og flytte etter fristen (STEK-658). STEK-654 og STEK-659 er lukket som Won't Do, og STEK-657 er Won't Do |
| Versjon | [Fylles ut: versjon, release eller dato for deploy] |
| Testmiljø | TEST: FS Admin [https://test-fsadmin.sikt.no](https://test-fsadmin.sikt.no) og Min kompetanse (test) |
| Feature-flagg | [Fylles ut: flagg som må være på, eller «Ingen»] |
| Kilde | Kravet [`tildele_saksbehandlende_organisasjon.feature`](https://github.com/sikt-no/fs/blob/7d4ee5d1/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) og flyten [`saksbehandlertildeling.feature`](https://github.com/sikt-no/fs/blob/7d4ee5d1/krav/_Flyter/10%20Opptaksl%C3%B8pet/saksbehandlertildeling.feature), på commit `7d4ee5d1`. Lenkene gjelder branchen `krav/saksbehandlertildeling-v2` til PR-en er merget |
| Scope | Ingen |
| Saker | GitHub [#207](https://github.com/sikt-no/fs/issues/207) · Jira [STEK-242](https://sikt.atlassian.net/browse/STEK-242) (epic), blant annet STEK-571, STEK-572, STEK-576, STEK-579, STEK-652, STEK-653, STEK-655, STEK-656, STEK-658, STEK-663, STEK-664 og STEK-668 (det gamle valget per deltaker i API-et) |
| Berører andre team | Behandlertildelingsreglene er en innstilling i opptaket (PUFF). Valget av regel per utdanningstilbud står i `@OPT-OPT-UTD-004`, fristen for endring av utdanningsbakgrunn i `@OPT-OVO-FRI-001`, og tilbudsgarantien i `@OPT-BEH-BEH-010`. Søkeren sender inn og endrer søknaden, og ser saksbehandlende organisasjon, i Min kompetanse (MR !994, regnes som implementert) |
| Kjente begrensninger | Tilbyderen ser saken i «Saker i opptak», og bare sine egne søknadsalternativer i den. Tilbyderen kan velge utdanningsbakgrunn i skjermen, men lagringen avvises. «Slett» vises for en regel søknader er tildelt etter, og feiler ved lagring. En organisasjon i «Fordeles til» i unntak for utdanningsbakgrunn kan tas ut av opptaket. Det gamle valget per deltaker finnes fortsatt i API-et (STEK-668). Fordelingen er asynkron: tildelingsjobben kjører ca. hvert 30. sekund (målt i runde 1), så testene må vente på den |
| Avhengighetskart | Ikke aktuelt. Avhengighetene står under «Flyter» på [Omfang – Saksbehandlertildeling, runde 2](omfang.md) |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | Håkon Medhus Fornes | Eier testen fra start til beslutning. Har ansvaret for at agenten blir kjørt og tester riktig (kjøringen kan gjøres av andre), går gjennom testcasene før kjøringen og funnene etterpå, tar stikkprøver av beståtte testcaser etter en risikovurdering, og skriver beslutningen i testrapporten |
| Kjører av agenten | Håkon Medhus Fornes | Starter den agentiske funksjonstesten (fase 2) |
| Kontaktperson i teamet | Håkon Medhus Fornes | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut: navn] | [Fylles ut: hvilke deler] |
| Fagperson for den interne testen | [Fylles ut: navn] | Går gjennom flytene og oppgavene i fase 3 |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Agentisk funksjonstest | 04.–05.11.2026. Kjørt av Håkon Medhus Fornes (agentene i Claude Code) |
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | Ikke aktuell |
| Spørsmål underveis | Slack-tråden «Akseptansetesting saksbehandlertildeling, runde 2» i #søknadsbehandling-team-puff |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene i «Testdata» finnes i testmiljøet, i utgangstilstanden der. Tilstander som bygger på datoer, er sjekket samme dag som testen | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake før hver kjøring | [Fylles ut av teamet] |
| 4 | Testbrukerne finnes i rollene ved organisasjonene kravene gjelder (tilgangsmatrisen) | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten. Åpne spørsmål stopper ikke, og står i «Åpne spørsmål» | 62 av 62 scenarioer i kravet er funnet. I flyten er 3 av 7 funnet (de tre som ikke er levert, er ikke funnet), og 1 var usikker fordi flyten brukte «SPE». Flyten bruker nå «UVH». Kontrollert av `fs-verify-kontroll` 04.11.2026. Venter på kontroll av en person |
| 6 | De agentiske testcasene (`fs-testcaser-cdp`) er laget, og testansvarlig og teamet har gått gjennom dem før kjøringen | Laget 04.11.2026 (`cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`), ikke gått gjennom før kjøringen |
| 7 | Flyttestcasene for den interne akseptansetesten (`fs-testcaser-intern`) er laget og gått gjennom av testansvarlig | Laget 05.11.2026, venter på gjennomgang av testansvarlig |
| 8 | Testansvarlig er logget inn i FS Admin i en egen Chrome-profil til testingen, CDP-agenten kan bytte til hver testbruker i «Overstyrt bruker», og nøklene i testbrukere og testdata er utfylt | [Fylles ut av teamet] |
| 9 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |
| 10 | Tilbudsgarantityper finnes i opptaket (`tilbudsgarantityper`). Bare en utvikler kan legge dem inn. Uten dem kan ikke tilbudsgaranti ved flytting og tilbyderens tilbudsgaranti testes | [Fylles ut av teamet] |
| 11 | Ledige studieplasser har åpnet i opptaket, og ett utdanningstilbud ved UiO tilbyr dem (`ledige-studieplasser-apnet`) | [Fylles ut av teamet] |
| 12 | Søkerens innlogging: en syntetisk testperson i ID-porten (Tenor) som kan søke i opptaket. Testansvarlig logger inn når agenten trenger søkeren | [Fylles ut] |
| 13 | MR !994 i min-kompetanse (søkerens visning av saksbehandlende organisasjon) er i testmiljøet, eller merget | [Fylles ut av teamet] |

## Kriterier for godkjent

Kravene i «Omfang» er kriteriene for godkjent: hvert scenario er et akseptansekriterium. Mangler et viktig tilfelle, legges det inn i kravet (`fs-krav`), ikke her. Fasene er ferdige når:

| Fase | Ferdig når |
|---|---|
| 1. Verifisering | Alle scenarioene er funnet, og en annen person har kontrollert rapporten. Åpne spørsmål står i testplanen, men stopper ikke |
| 2. Agentisk funksjonstest | Alle testcasene er kjørt, ingen funn med «Stopper» står åpne, og testansvarlig har gått gjennom rapporten. Det er inngangskriteriet til intern akseptansetest |
| 3. Intern akseptansetest | Beslutningen er tatt: godkjent, godkjent med forbehold eller ikke godkjent |
| 4. Ekstern akseptansetest | Ikke aktuell for denne leveransen |

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

## Status i flyten

| Fase | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | [Verifisering – Saksbehandlertildeling, runde 2 – 2026-11-04 13:17](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170364465/Verifisering+Saksbehandlertildeling+runde+2+2026-11-04+13+17) | Kravet: alt funnet (62/62). Flyten: 3 ikke funnet (faser som ikke er levert) | 2026-11-04 |
| 1. Testplan | (denne siden) | Laget | 2026-11-04 |
| 2. Agentisk funksjonstest | [testrapport-agentisk-2026-11-05.md](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5173837827/Testrapport+agentisk+funksjonstest+Saksbehandlertildeling+runde+2+2026-11-05), [kjøringen](kjoring-2026-11-04-1510/resultat.md) | Venter på gjennomgang (89 bestått, 5 ikke bestått, 11 ikke testet av 105) | 2026-11-05 |
| 3. Intern akseptansetest | [testcaser-intern.md](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5173018630/Intern+akseptansetest+Saksbehandlertildeling+runde+2) | Klar til test (når testrapporten for fase 2 er gått gjennom) | 2026-11-05 |
| 3. Intern akseptansetest, runde 3 | [Intern akseptansetest – Saksbehandlertildeling, runde 3](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5187895334) | Klar til test. Testdata satt opp i «HÅK1 er KUL» 11.11.2026. Del 3 (tilbyderen ser dokumentet) venter på STEK-687 | 2026-11-11 |
| 4. Ekstern akseptansetest | – | Ikke aktuell | |

Testrapportene (verifisering, agentisk, intern og ekstern) står som undersider, og lenken står i raden for fasen.

## Vedlegg

| Vedlegg | Lenke |
|---|---|
| Verifiseringsrapporten (fase 1) | [verify-tildele_saksbehandlende_organisasjon-2026-11-04-1317.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-tildele_saksbehandlende_organisasjon-2026-11-04-1317.md) |
| Runde 1 | [Akseptansetesting saksbehandlertildeling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130911779/Akseptansetesting+saksbehandlertildeling) (Confluence 5130911779), [`akseptansetest/opptak-saksbehandlertildeling/`](../opptak-saksbehandlertildeling/) |
| Agentisk testrapport (fase 2) | [testrapport-agentisk-2026-11-05.md](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5173837827/Testrapport+agentisk+funksjonstest+Saksbehandlertildeling+runde+2+2026-11-05) |
| Testcasene for fase 2 | [`cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`](../../cdp-tester/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/) |
| Testcasene for fase 3 | [testcaser-intern.md](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5173018630/Intern+akseptansetest+Saksbehandlertildeling+runde+2) |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
