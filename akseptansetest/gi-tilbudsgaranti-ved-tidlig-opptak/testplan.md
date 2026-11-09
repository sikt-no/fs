# Testplan – Gi tilbudsgaranti ved tidlig opptak

- **Leveranse**: feature-fil
- **Kilde**: `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`
- **Scope**: @scope-tidlig-opptak
- **Scope-fil**: [opptak/tidlig-opptak](../../tasks/opptak/tidlig-opptak/scope.md)
- **Krav**: 1 feature-fil, 0 `@implemented`, 1 delvis levert, 0 flyter, commit `072f40ee` (2026-11-09, main etter PR #986)
- **Verifisering**: [verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-09-1136.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-09-1136.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074
- **Laget**: 2026-11-09 av fs-testplan

- **Undersider**: [omfang.md](omfang.md), [testcaser-og-testdata.md](testcaser-og-testdata.md), [sporbarhet.md](sporbarhet.md)

---

Testplan for «Gi tilbudsgaranti ved tidlig opptak». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Innhold

Testplanen er delt i hovedsiden og tre undersider, så hver del kan oppdateres for seg. I Confluence står innholdsfortegnelsen og lista over undersider (med testrapportene og testsidene) over tabellen.

| Side | Innhold | Fil |
|---|---|---|
| Testplan (denne siden) | Testbeskrivelse, roller, tid og kanal, forutsetninger, kriterier for godkjent, funn, beslutning, status i flyten og vedlegg | `testplan.md` |
| [Omfang – Gi tilbudsgaranti ved tidlig opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5180882969) | Kravene som testes, åpne spørsmål, avhengighetskart, det som venter på verifisering, regler uten scenario og det som ikke er med | `omfang.md` |
| [Testcaser og testdata – Gi tilbudsgaranti ved tidlig opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181505546) | Omfanget av testcasene som skal lages, testbrukerne, tilgangsmatrisen og testdataene | `testcaser-og-testdata.md` |
| [Sporbarhet – Gi tilbudsgaranti ved tidlig opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5182062606) | Scenarioene fra kravet til koden og til testen | `sporbarhet.md` |

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Opptaksforvalteren kan prøvekjøre og gjennomføre tidligopptaket i FS Admin, under «Plasstildeling» og «Tidlig opptak». Søkere som deltar, og som har nok poeng (poenggrensen for tidlig opptak, eller median poengsum fra forrige opptak når grensen ikke er satt), får tilbudsgaranti på det høyest prioriterte søknadsalternativet. Prøvekjøringen viser hvor mange søkere som har søkt, deltar og har saker som ikke er ferdig behandlet, og hvor mange tilbudsgarantier som ville blitt satt, uten å lagre noe. |
| Versjon | main på dagen testen kjøres (fs-plattform og fs-admin). Verifisert mot fs-plattform `1f07615d7a` og fs-admin `7df232046` (2026-11-09) |
| Testmiljø | [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/) |
| Kilde | [gi_tilbudsgaranti_ved_tidlig_opptak.feature](https://github.com/sikt-no/fs/blob/072f40ee/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) |
| Scope | `@scope-tidlig-opptak` · [scope.md på GitHub](https://github.com/sikt-no/fs/blob/072f40ee/tasks/opptak/tidlig-opptak/scope.md) |
| Saker | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) · [STEK-269](https://sikt.atlassian.net/browse/STEK-269), [STEK-489](https://sikt.atlassian.net/browse/STEK-489), [STEK-676](https://sikt.atlassian.net/browse/STEK-676) |
| Berører andre team | Plasstildelingen leser tilbudsgarantiene i hovedopptaket (`@OPT-PLA-TIL-002`). Medianen kommer fra registreringen av poengopplysninger (`@OPT-OPT-UTD-010`, Shinkansen) |
| Kjente begrensninger | - Gjennomføringen kan ikke settes tilbake. Den går gjennom alle søkere i opptak 34 som har søkt om tidlig opptak, også søkerne fra den eksterne testen og testen av saksbehandlingen, og søkerne ser svaret med en gang. Prøvekjøringen lagrer ingenting.<br>- Prøvekjøringen viser ikke utdanningstilbudene med mangelfulle innstillinger (venter på verifisering, kommentert på STEK-489). Etter gjennomføringen viser en melding antall avvik, ikke antall utdanningstilbud.<br>- Etiketten «Har saker som ikke er behandlet» sier ikke at saker uten konklusjon telles med.<br>- Feilmeldingen når tilbudsgarantitypen for tidlig opptak mangler eller er tvetydig, er teknisk. |
| Avhengighetskart | Under «Flyter» på [Omfang – Gi tilbudsgaranti ved tidlig opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5180882969) |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | [Fylles ut: navn] | Eier testen fra start til beslutning. Har ansvaret for at agenten blir kjørt og tester riktig (kjøringen kan gjøres av andre), går gjennom testcasene før kjøringen og funnene etterpå, tar stikkprøver av beståtte testcaser etter en risikovurdering, og skriver beslutningen i testrapporten |
| Kjører av agenten | [Fylles ut: navn] | Starter den agentiske funksjonstesten (fase 2) |
| Kontaktperson i teamet | [Fylles ut: navn] | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut: navn] | [Fylles ut: hvilke deler] |
| Eksterne testere | [Fylles ut: om leveransen skal til ekstern akseptansetest, og hvem] | Gjennomfører testen i flytene |
| Kontaktperson i den eksterne testen | [Fylles ut: navn, normalt testansvarlig] | Én per test. Svarer på spørsmål underveis, har ansvaret for at funnene blir fulgt opp, og går gjennom resultatet med partene |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Agentisk funksjonstest | [Fylles ut: dato for kjøringen, og hvem som kjører agenten] |
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | [Fylles ut: dato, «Avklares med de eksterne partene» eller «Ikke aktuell»]. Hvordan spørsmål tas underveis (e-post, telefon eller møte), og hvem som beslutter, avtales med testerne før testen |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Gi tilbudsgaranti ved tidlig opptak» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene i «Testdata» finnes i testmiljøet, i utgangstilstanden der. Tilstander som bygger på datoer, er sjekket samme dag som testen | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake før hver kjøring | Nei. Gjennomføringen kan ikke settes tilbake, og søkerne med søknad om tidlig opptak kan ikke brukes på nytt. En ny kjøring trenger nye søkere |
| 4 | Testbrukerne finnes i rollene ved organisasjonene kravene gjelder (tilgangsmatrisen) | [Fylles ut av teamet: bekreft at ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) har alle de fire tilgangene fs-admin krever, og at KORT DOMPAP • OPPTAK_FORVALTER (UIT) gir tilbyderrollen] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten. Åpne spørsmål stopper ikke, og står i «Åpne spørsmål» | 25 av 27 scenarioer er funnet (2026-11-09), kontrollert av `fs-verify-kontroll`. De 2 som mangler, venter på verifisering. Kontroll av en annen person: Daniel Sachse, 2026-11-09 |
| 6 | De agentiske testcasene (`fs-testcaser-cdp`) er laget, og testansvarlig og teamet har gått gjennom dem før kjøringen | Venter |
| 7 | Flyttestcasene for den interne akseptansetesten (`fs-testcaser-intern`) er laget og gått gjennom av testansvarlig | Venter |
| 8 | Testansvarlig er logget inn i FS Admin i en egen Chrome-profil til testingen, CDP-agenten kan bytte til hver testbruker i «Overstyrt bruker», og nøklene i testbrukere og testdata er utfylt | [Fylles ut av teamet] |
| 9 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |
| 10 | Opptak 34 har nøyaktig én aktiv tilbudsgarantitype for tidlig opptak som gir tilbud og kan brukes av opptaksforvalteren. Ellers stopper gjennomføringen | [Fylles ut av teamet] |

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

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Etter den eksterne akseptansetesten er beslutningen vurdert mot flytene og kravene, og hvem som beslutter, er avtalt med partene før testen. Kontaktpersonen går gjennom resultatet med partene.

## Status i flyten

| Fase | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | [verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-09-1136.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-09-1136.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5180653598) | 2 ikke funnet, 0 usikker | 2026-11-09 |
| 1. Testrapport – verifisering | [testrapport-verifisering-2026-11-09.md](testrapport-verifisering-2026-11-09.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181767779) | Klar, med forbehold: de 25 leverte scenarioene kan testes | 2026-11-09 |
| 1. Testplan | (denne siden) | Laget | 2026-11-09 |
| 2. Agentisk funksjonstest | – | Venter | |
| 3. Intern akseptansetest | – | Venter | |
| 4. Ekstern akseptansetest | – | [Fylles ut: Venter eller Ikke aktuell] | |

Testrapportene (verifisering, agentisk, intern og ekstern) står som undersider, og lenken står i raden for fasen.

## Vedlegg

| Vedlegg | Lenke |
|---|---|
| Verifiseringsrapporten (fase 1) | [Verifisering – Gi tilbudsgaranti ved tidlig opptak – 2026-11-09 11:36](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5180653598) · [verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-09-1136.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-09-1136.md) · [teamvisning](https://claude.ai/artifact/GBzMJsMvjP5xXAUvb6MCKE) |
| Agentisk testrapport (fase 2) | – |
| Testcasene for fase 2 | – |
| Testcasene for fase 3 | – |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
