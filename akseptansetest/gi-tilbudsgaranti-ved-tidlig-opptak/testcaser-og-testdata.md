# Testcaser og testdata – Gi tilbudsgaranti ved tidlig opptak

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181505546
- **Laget**: 2026-11-09 av fs-testplan

---

Testcasene som skal lages, testbrukerne og testdataene for «Gi tilbudsgaranti ved tidlig opptak». Siden synkes med testene i `cdp-tester/` og miljøfila (*Synk med testene og miljøfila* i `fs-testplan`). Testplanen: Testplan – Gi tilbudsgaranti ved tidlig opptak.

## Testcaser som skal lages

Omfanget av testcasene, ikke testcasene selv. `fs-testcaser-cdp` lager testcasene for fase 2 ut fra tabellen, og `fs-testcaser-intern` testcasene for fase 3. Teamet og testansvarlig går gjennom omfanget før testcasene lages.

### Fase 2: agentisk funksjonstest

| Krav | Regel | Scenarioer | Utledede testcaser | Teknikk |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | 20 (scenariomaler: 3 og 2 eksempler, til sammen 23 testcaser) | Poengsum like under, lik og like over poenggrensen (grensen har én desimal). Rekkefølgen på sjekkene: tidligopptakstilbud fra tilbyder, saken er ferdig behandlet, konklusjon, deltar, reservert studieplass, kvalifisering og poengsum, i kombinasjoner der to av dem slår ut samtidig | grenseverdianalyse, beslutningstabell, tilstandsoverganger (ny gjennomføring) |
| `@OPT-BEH-BEH-007` | Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt | 2 (scenariomal: 5 eksempler, til sammen 6 testcaser) | Poengsum like under og lik medianen. Poenggrense satt til 0 | grenseverdianalyse, ekvivalensklasser |
| `@OPT-BEH-BEH-007` | Opptaksforvalter ser utfallet av tidligopptaket | 2 | Ingen tilbudsgarantitype for tidlig opptak, og to aktive. En søker med to saker som ikke er ferdig behandlet, telles én gang | ekvivalensklasser |
| `@OPT-BEH-BEH-007` | Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket | 1 | – | – |
| `@OPT-BEH-BEH-007` | Regel i koden: søknadsalternativ uten poengsum gir ikke tilbudsgaranti | 0 | Saken er ferdig behandlet, søkeren deltar og er kvalifisert, men har ingen poengsum i garantikvoten | – |
| `@OPT-BEH-BEH-007` | Regel i koden: poengsummen tas bare fra kvoter søkeren skal kvoteplasseres i | 0 | Høyere poengsum i en kvote søkeren ikke skal kvoteplasseres i, gir ikke tilbudsgaranti | ekvivalensklasser |
| `@OPT-BEH-BEH-007` | Regel i koden: ett kvalifisert grunnlag holder | 0 | To grunnlag: ett kvalifisert og ett ikke kvalifisert, og ett ikke vurdert og ett ikke kvalifisert | beslutningstabell |
| `@OPT-BEH-BEH-007` | Regel i koden: trukne søknadsalternativer er ikke med | 0 | Søkeren har trukket søknadsalternativet med høyest prioritet | – |
| `@OPT-BEH-BEH-007` | Regel i koden: tidligopptakstilbud uten søknad om tidlig opptak | 0 | Søkeren har ikke søkt om tidlig opptak, men tilbyder har gitt tidligopptakstilbud | – |
| `@OPT-BEH-BEH-007` | Regel i koden: reservert studieplass fra opptaksforvalter erstattes | 0 | Opptaksforvalteren har satt reservert studieplass, og søkeren får tilbudsgaranti fra tidligopptaket på samme søknadsalternativ | – |
| `@OPT-BEH-BEH-007` | Regel i koden: gjennomføringen er sperret | 0 | Ulagret poenggrense, og prøvekjøringen gir feil | tilstandsoverganger |

Testcasene står i `cdp-tester/<kravstien>/` (lenke når de er laget). Finnes testene fra før, står de her som de er, og lages testene etter testplanen, synkes tabellen med `fs-testplan` (*Synk med testene og miljøfila*). Utledede testcaser lages bare der regelen har verdier eller betingelser å teste.

Gjennomføringen kan ikke settes tilbake (se «Kjente begrensninger» i testplanen). Testcasene bør bruke prøvekjøringen der scenarioet ikke krever at tilbudsgarantien lagres, og gjennomføre så få ganger som mulig.

### Fase 3: intern akseptansetest

| Flyt eller oppgave | Krav | Scenarioer i flyten | Avhengigheter som sjekkes | Regresjon |
|---|---|---|---|---|
| Oppgave uten flyt: gjennomføre tidligopptaket (prøvekjøre, gjennomføre, og se svaret hos søkeren) | `@OPT-BEH-BEH-007` | [Fylles ut: velges når testcasene lages] | `@OPT-BEH-BEH-013`: konklusjonen per organisasjon gir riktig utfall, og konklusjonen kan endres etter gjennomføringen (utsatt fra testplanen for saksbehandling av tidlig opptak). `@OPT-SØK-SØK-012`: søkeren ser svaret | nei |

Krav som ikke er med i noen flyt: 1. Det testes som en oppgave uten flyt (se *Vurdering per krav*).

I tillegg til flytene har den interne testen tre deler (*Fase 3* i `akseptansetest/README.md`). Omfanget avgjøres når testcasene lages, etter kjøringen i fase 2:

| Del | Omfang | Hvem velger |
|---|---|---|
| Det den agentiske testen ikke klarte | Testcasene fra fase 2 som blir «Ikke testet». Kjent på forhånd: søkere med søknad, konklusjon og poengsum i bestemte tilstander, som må lages før testen | Kjøringen i fase 2 |
| Opplevelse og helhet | Fanen «Tidlig opptak» under «Plasstildeling»: lista over utdanningstilbud med poenggrense og median, prøvekjøringen og tallene i den, og meldingene etter gjennomføringen | Testansvarlig |
| Høyest risiko | Kandidater: at gjennomføringen ikke kan settes tilbake, reservert studieplass som erstattes, tidligopptakstilbud uten søknad om tidlig opptak, ny gjennomføring som flytter tilbudsgarantien, og etiketten for saker som mangler konklusjon | Testansvarlig, etter en risikovurdering |

## Testbrukere

Personaene er fra [test.md](../../cdp-tester/_Miljøer/test.md), 2026-11-09, og er de samme som i den eksterne testen av tidlig opptak og tilbudsgaranti (2026-11-05).

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | `opptak-forvalter-forvaltende` | ORDENTLIG RUNDSKRIV | `OPPTAK_FORVALTER` | HK-dir | ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/plasstildeling/tidlig-opptak | Sette poenggrensen, prøvekjøre og gjennomføre tidligopptaket |
| 2 | `opptak-saksbehandler-behandlende-tidlig-opptak` | KORT DOMPAP | `OPPTAK_SAKSBEHANDLER` | UiT | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/soknadsbehandling | Konklusjon, kvalifisering, poeng og ferdigbehandling i sakene (testdata) |
| 3 | `opptak-tilbyder-behandlende` | KORT DOMPAP | `OPPTAK_FORVALTER` [Fylles ut: bekreft at rollen gir `OPPTAK_TILBGARANTI_GI_VIA_UTDTILBUD` ved UiT] | UiT | KORT DOMPAP • OPPTAK_FORVALTER (UIT) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/soknadsbehandling | Tidligopptakstilbud og manuell tilbudsgaranti fra tilbyder |
| 4 | `soker-tidlig-opptak` | Søkerne i «Søkere til testerne» i den eksterne testen som ikke er brukt | Søker | – | «Velg testsøker» i Min kompetanse | https://test.minkompetanse.no/ | Søknaden og søknaden om tidlig opptak (testdata), og svaret etter gjennomføringen |

Testbrukerne finnes i rollene scenarioene nevner, ved organisasjonene kravet gjelder. Antallet bestemmes per krav ut fra tilgangsmatrisen. Det lages ikke egne testcaser for roller og tilgang i fase 2: `fs-verify` har verifisert i koden at de er laget slik kravet sier (fase 1). Scenarioene i kravet, også om synlighet, testes som de står.

Nøkkel 2, 3 og 4 er lagt inn i miljøfila 2026-11-09. Tilbyderrollen for nøkkel 3 er ikke bekreftet.

### Tilgangsmatrise

Fra tilgangsradene i verify-rapporten. Den viser hvilke roller kravet har ved hvilke organisasjoner, og hvilken testbruker som dekker hver rad. En rad uten tilgang trenger ingen testbruker, med mindre et scenario handler om den.

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Opptaksforvalter ved organisasjonen som forvalter opptaket | prøvekjører og gjennomfører | ingen tilgang (gjennomføringen avvises uten forvaltertilgang) | 1 |
| `@OPT-BEH-BEH-007` | Tilbyder ved lærestedet som behandler saken | setter tilbudsgaranti | ingen tilgang | 3 |

## Testdata

Testdataene testene trenger, med nøkkel. Data i testmiljøet kan slettes eller nullstilles når som helst, så testene lager dataene sine selv når det går. Søkere med søknad og saker i bestemte tilstander kan ikke lages av oppsettet i FS Admin, og må lages før testen, i Min kompetanse og i saksbehandlingen. Testdata er syntetiske.

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| Opptaket | `opptak-tidlig-opptak` | Opptak 34, «Samordna UHG-simulering høsten 2026» | FS Admin | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0 | Samordna opptak med tidlig opptak slått på. Fristen for å søke om tidlig opptak er ikke ute ({DATO:+30} eller senere) | Alle |
| Tilbudsgarantitype for tidlig opptak | `tilbudsgarantitype-tidlig-opptak` | [Fylles ut] | Tilbudsgarantitypene i opptaket | – | Nøyaktig én aktiv type for tidlig opptak som gir tilbud og kan brukes av opptaksforvalteren | Alle som gjennomfører. «Tidligopptaket stopper uten én tilbudsgarantitype …» trenger i tillegg 0 og 2 slike typer |
| Utdanningstilbud med poenggrense | `utdanningstilbud-tidlig-opptak` | «Automasjon, ingeniør - bachelor (ordinær, y-vei)» (UiT) | Fanen «Tidlig opptak» | Søk på navnet | Tilbyr tidlig opptak. Poenggrensen settes til 50 av testbruker 1 | Regelen om gjennomføringen |
| Utdanningstilbud med lavere prioritet | `utdanningstilbud-tidlig-opptak-andre` | «Elektronisk systemingeniør - bachelor i ingeniørfag» (NTNU) | Fanen «Tidlig opptak» | Søk på navnet | Tilbyr tidlig opptak. Poenggrensen settes til 40 | «Tilbudsgaranti på det høyest prioriterte …», «Tidligopptakstilbud fra tilbyder går foran …», «Tilbudsgarantien flyttes …» |
| Utdanningstilbud med median | `utdanningstilbud-tidlig-opptak-med-median` | [Fylles ut] | Fanen «Tidlig opptak» | Søk på navnet | Tilbyr tidlig opptak, uten poenggrense, med median fra forrige opptak (vises i «Median i fjor») | Regelen om medianen |
| Utdanningstilbud uten median | `utdanningstilbud-tidlig-opptak-uten-median` | [Fylles ut] | Fanen «Tidlig opptak» | Søk på navnet | Tilbyr tidlig opptak, uten poenggrense og uten median fra forrige opptak | «Ingen tilbudsgaranti uten poenggrense og uten median …» |
| Saker for tidligopptaket | `sak-tidlig-opptak-<tilstand>` | [Fylles ut: én søker per tilstand fra «Søkere til testerne»] | Saksbehandlingen i opptak 34 | Søk på søknadskoden | Søknad om tidlig opptak, saken behandles av UiT. Én søker per tilstand: deltar, ferdig behandlet, kvalifisert og 55, 50 eller 45 poeng; deltar ikke; uten konklusjon; ikke kvalifisert; kvalifisering ikke vurdert; ikke ferdig behandlet; reservert studieplass; poeng i to kvoter; tidligopptakstilbud fra tilbyder; tilbudsgaranti fra opptaksforvalter som gir og ikke gir tilbud. [Fylles ut: hvordan søkeren får poengsummen] | Scenarioene i «Omfang» |
| Søkere med saker som ikke er ferdig behandlet eller mangler konklusjon | `sokere-ikke-ferdig-behandlet` | [Fylles ut] | Saksbehandlingen i opptak 34 | Søk på søknadskoden | 2 søkere med saker som ikke er ferdig behandlet, og 1 med en ferdig behandlet sak uten konklusjon. Søkerne fra de tidligere testene i opptak 34 telles også med | «Se antall søkere med saker som ikke er ferdig behandlet …» |

Data scenarioet selv lager (for eksempel poenggrensen og tilbudsgarantien fra gjennomføringen), står ikke her: de lages av stegene i testcasen (R13 i `testcase-regler.md`).

Kolonnene `Søk/URL`, `Utgangstilstand` og `Brukes av` står bare i testplanen, ikke i testcasene for den interne og den eksterne testen.
