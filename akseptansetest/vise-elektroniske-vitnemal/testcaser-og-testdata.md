# Testcaser og testdata – Se søkerens elektroniske vitnemål

- **Testplan**: [testplan.md](testplan.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5174067232 (utkast)
- **Laget**: 2026-11-05 av fs-testplan

---

Testcasene som skal lages, testbrukerne og testdataene for «Se søkerens elektroniske vitnemål». Siden synkes med testene i `tester-agent/` og miljøfila (*Synk med testene og miljøfila* i `fs-testplan`). Testplanen: Testplan – Se søkerens elektroniske vitnemål.

## Testcaser som skal lages

Omfanget av testcasene, ikke testcasene selv. `fs-testcaser-cdp` lager testcasene for fase 2 ut fra tabellen, og `fs-testcaser-intern` testcasene for fase 3. Teamet og testansvarlig går gjennom omfanget før testcasene lages.

### Fase 2: agentisk funksjonstest

| Krav | Regel | Scenarioer | Utledede testcaser | Teknikk |
|---|---|---|---|---|
| `@OPT-BEH-BEH-005` | Søkerens elektroniske vitnemål vises | 6 | Annullert × brukt i en beregning (poeng, kravelement-vurdering, GSK-konklusjon, ikke brukt): bare de brukte vises, markert «Annullert», med varselet over tabellen og poengene. Sortering når to vitnemål har samme utstedelsesdato, og når datoen mangler. «-» for ukjent GSK og førstegangsvitnemål. Poeng med én desimal. Telleren når et annullert vitnemål vises. Teksten om uenighet om GSK vises ikke for et annullert vitnemål | beslutningstabell / ekvivalensklasser |
| `@OPT-BEH-BEH-005` | Innsyn styres av rettighet, ikke av hvem som har tatt saken | 3 | – (tilgang er verifisert i koden i fase 1) | – |

Testcasene står i `tester-agent/02 Opptak/13 Søknad og saksbehandling/02 Behandling/` når de er laget. Finnes testene fra før, står de her som de er, og lages testene etter testplanen, synkes tabellen med `fs-testplan` (*Synk med testene og miljøfila*). Utledede testcaser lages bare der regelen har verdier eller betingelser å teste.

### Fase 3: intern akseptansetest

| Flyt eller oppgave | Krav | Scenarioer i flyten | Avhengigheter som sjekkes | Regresjon |
|---|---|---|---|---|
| Oppgave uten flyt: Se søkerens vitnemål i saksbehandlingen | `@OPT-BEH-BEH-005` | 9 | Importen fra KREG, poengberegningen i opptak, opptakssystemets påstand om GSK | nei |

Krav som ikke er med i noen flyt: 1. Det testes som en oppgave uten flyt (se *Vurdering per krav*).

I tillegg til flytene har den interne testen tre deler (*Fase 3* i `akseptansetest/README.md`). Omfanget avgjøres når testcasene lages, etter kjøringen i fase 2:

| Del | Omfang | Hvem velger |
|---|---|---|
| Det den agentiske testen ikke klarte | Testcasene fra fase 2 som blir «Ikke testet». Kjent på forhånd: søkere med vitnemål fra KREG kan ikke lages av testene, og `sak-vitnemal-uten-poeng` og `sak-annullert-vitnemal-brukt` finnes ikke ennå | Kjøringen i fase 2 |
| Opplevelse og helhet | Seksjonen «Vitnemålsbehandling» i steg 2 «Grunnlag», og siden med vitnemålet i ny fane: forståelig og brukbar, forkortelsene KAR, REA og SPR, teksten om uenighet om GSK, og universell utforming (telleren og varselikonet for skjermleser) | Testansvarlig |
| Høyest risiko | Kandidater: «Bruker uten lesetilgang …» (usikker: forvalter og tilbyder ser vitnemålene), vitnemål fra en annen organisasjon via API-et, varselet om annullert vitnemål (L2 i kravet), saken settes tilbake når et vitnemål annulleres, og «brukt i en beregning» som er videre enn kravet | Testansvarlig, etter en risikovurdering |

## Testbrukere

Fra [test.md](../../tester-agent/_Miljøer/test.md), 2026-11-05.

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | `opptak-saksbehandler-behandlende` | KORT DOMPAP | `OPPTAK_SAKSBEHANDLER` | NTNU [Fylles ut: bekreft at NTNU behandler sakene i opptak 62] | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (NTNU) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjYy | Alle scenarioene i regelen «Søkerens elektroniske vitnemål vises», «Saksbehandler med leserettighet …» og «Saken er tilordnet en annen saksbehandler» |
| 2 | `opptak-saksbehandler-behandlende-annen` | NØYE TANNHJUL | `OPPTAK_SAKSBEHANDLER` | NTNU | NØYE TANNHJUL • OPPTAK_SAKSBEHANDLER (NTNU) | – | Saksbehandleren saken er tilordnet i «Saken er tilordnet en annen saksbehandler» (logger ikke inn) |
| 3 | `opptak-saksbehandler-annen-organisasjon` | GLIMRENDE ELG | `OPPTAK_SAKSBEHANDLER` | Fagskolen Innlandet (FSGJØVIK) | GLIMRENDE ELG • OPPTAK_SAKSBEHANDLER (FSGJØVIK) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjYy | «Bruker uten lesetilgang ser ikke vitnemålsoversikten» |

Testbrukerne finnes i rollene scenarioene nevner, ved organisasjonene kravet gjelder. Antallet bestemmes per krav ut fra tilgangsmatrisen. Det lages ikke egne testcaser for roller og tilgang i fase 2: `fs-verify` har verifisert i koden at de er laget slik kravet sier (fase 1). Scenarioene i kravet, også om synlighet, testes som de står.

Nøkkelen er rollen og relasjonen scenarioet trenger, aldri organisasjonen eller personen, og endres ikke om testbrukeren eller organisasjonen byttes. Det er ikke bekreftet at `OPPTAK_SAKSBEHANDLER` gir SE_SØKNADSBEHANDLING i rollekatalogen. Testbruker 3 må verken være opptaksforvalter for opptaket eller tilbyder av et søknadsalternativ på sakene, ellers ser den vitnemålene.

### Tilgangsmatrise

Fra tilgangsradene i verify-rapporten. Den viser hvilke roller kravet har ved hvilke organisasjoner, og hvilken testbruker som dekker hver rad. En rad uten tilgang trenger ingen testbruker, med mindre et scenario handler om den.

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@OPT-BEH-BEH-005` | Saksbehandler med SE- eller MODIFISERE_SØKNADSBEHANDLING | ser (også når saken er tilordnet en annen) | ingen tilgang (scenario «Bruker uten lesetilgang …»). Avvik: API-et gir vitnemålet på id-en | 1, 2 / 3 |
| `@OPT-BEH-BEH-005` | Opptaksforvalter for opptaket | ser (ikke beskrevet i kravet, ikke avklart) | – | – |
| `@OPT-BEH-BEH-005` | Tilbyder av et søknadsalternativ | ser (avklart 2026-11-03, ikke i kravet ennå) | – | – |

## Testdata

Testdataene testene trenger, med nøkkel. Data i testmiljøet kan slettes eller nullstilles når som helst, så testene lager dataene sine selv der det går. Søkerne med vitnemål fra KREG kan ikke lages gjennom løsningen, så de må finnes i miljøet før testen. Navnet og `Søk/URL` er fra [test.md](../../tester-agent/_Miljøer/test.md), 2026-11-05. Testdata er syntetiske.

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| Opptak | `opptak-vitnemalsbehandling` | Opptak 62 [Fylles ut: navnet] | TEST | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjYy | Opptak med saker der søkerne har elektroniske vitnemål fra KREG | Alle scenarioene |
| Sak | `sak-to-elektroniske-vitnemal` | 1004255-1 | `opptak-vitnemalsbehandling` | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har to elektroniske vitnemål, ett førstegangsvitnemål | «Se at søkeren har elektroniske vitnemål», «Åpne et vitnemål i ny fane», «Saksbehandler med leserettighet …», «Bruker uten lesetilgang …» |
| Sak | `sak-uten-elektroniske-vitnemal` | 1004221-1 | `opptak-vitnemalsbehandling` | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har ingen elektroniske vitnemål | «Søker uten elektroniske vitnemål» |
| Sak | `sak-vitnemal-uten-poeng` | [Fylles ut] | `opptak-vitnemalsbehandling` | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har et elektronisk vitnemål som poengberegningen ikke gir poeng for (f.eks. et kompetansebevis eller ugyldige karakterer) | «Poeng som ikke kan beregnes, vises tomme» |
| Sak | `sak-annullert-vitnemal-brukt` | **Finnes ikke** | `opptak-vitnemalsbehandling` | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har et annullert vitnemål som er grunnlaget for et poeng på saken | «Annullert vitnemål som er brukt i en beregning vises», og de utledede testcasene for annullert × brukt |
| Sak | `sak-annullert-vitnemal-ikke-brukt` | 1004220-1 (ikke bekreftet at vitnemålet er annullert) | `opptak-vitnemalsbehandling` | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har et annullert vitnemål som ikke er brukt i en beregning på opptaket | «Annullert vitnemål som ikke er brukt i en beregning vises ikke» |
| Tilordning | `sak-tilordnet-annen-saksbehandler` | Lages av oppsettet | `opptak-vitnemalsbehandling` | Sak 1004220-1 | Saken er tilordnet testbruker 2 (`opptak-saksbehandler-behandlende-annen`) | «Saken er tilordnet en annen saksbehandler» |

Data scenarioet selv lager, står ikke her: de lages av stegene i testcasen (R13 i `testcase-regler.md`).

Kolonnene `Søk/URL`, `Utgangstilstand` og `Brukes av` står bare i testplanen, ikke i testcasene for den interne og den eksterne testen.
