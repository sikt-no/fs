# Testcaser og testdata – Gi tilbudsgaranti ved tidlig opptak

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181505546
- **Laget**: 2026-11-09 av fs-testplan
- **Synket**: 2026-11-13 med testene i `tester-agent/` og miljøfila (forrige: 2026-11-09, med `cdp-tester/`)

---

Testcasene som skal lages, testbrukerne og testdataene for «Gi tilbudsgaranti ved tidlig opptak». Siden synkes med testene i `tester-agent/` og miljøfila (*Synk med testene og miljøfila* i `fs-testplan`). Testplanen: Testplan – Gi tilbudsgaranti ved tidlig opptak.

## Testcaser som skal lages

Omfanget av testcasene, ikke testcasene selv. `fs-testcaser-agent` lager testcasene for fase 2 ut fra tabellen, og `fs-testcaser-intern` testcasene for fase 3. Teamet og testansvarlig går gjennom omfanget før testcasene lages.

### Fase 2: agentisk funksjonstest

| Krav | Regel | Scenarioer | Utledede testcaser | Teknikk |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | 21 (scenariomaler: 3 og 2 eksempler, til sammen 24 testcaser) | 8: poengsummen 0,1 under poenggrensen; kvalifiseringen har flere grunnlag (2 eksempler); reservert studieplass når søkeren ikke deltar; og reglene i koden: søknadsalternativet med høyest prioritet er trukket, poengsum i en kvote søkeren ikke skal kvoteplasseres i, ingen poengsum, og poenggrensen er ikke lagret | grenseverdianalyse, beslutningstabell, ekvivalensklasser, tilstandsoverganger |
| `@OPT-BEH-BEH-007` | Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt | 3 (scenariomal: 5 eksempler, til sammen 7 testcaser) | 1: poenggrensen er 0 | grenseverdianalyse |
| `@OPT-BEH-BEH-007` | Opptaksforvalter ser utfallet av tidligopptaket | 3 («Tidligopptaket stopper …» er en scenariomal med 2 opptak, til sammen 4 testcaser) | 1: en søker med to saker som ikke er ferdig behandlet, telles én gang | ekvivalensklasser |
| `@OPT-BEH-BEH-007` | Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket | 1 | – | – |

Til sammen 46 testcaser: 36 fra scenarioene i kravet og 10 utledede. De to reglene i koden om reservert studieplass fra opptaksforvalter og tidligopptakstilbud uten søknad om tidlig opptak har fått scenario i kravet (2026-11-13), og er ikke lenger utledet. De andre reglene i koden som testes i fase 2 (se «Regler uten scenario» i omfanget), er testet under regelen de hører til. Dobbelttellingen i «Feilkonfigurerte utdanningstilbud» har ingen egen utledet testcase: unøyaktigheten er kjent og akseptert. Avvik fra planen: beslutningstabellen for rekkefølgen på sjekkene er bare raden med reservert studieplass når søkeren ikke deltar. Rekkefølgen dekkes ellers av scenarioene i kravet.

Testcasene står i [`tester-agent/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`](../../tester-agent/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) (synket 2026-11-13). Finnes testene fra før, står de her som de er, og lages testene etter testplanen, synkes tabellen med `fs-testplan` (*Synk med testene og miljøfila*). Utledede testcaser lages bare der regelen har verdier eller betingelser å teste.

Gjennomføringen kan ikke settes tilbake (se «Kjente begrensninger» i testplanen). Derfor tar hvert scenario sin egen søker fra en liste i miljøfila. Søkerne står med saken ikke ferdig behandlet, og scenarioet gjør saken klar selv, så en gjennomføring i ett scenario ikke gir tilbudsgaranti til søkerne i de andre. Poenggrensen settes ut fra søkerens egen poengsum (P − 5, P og P + 5), og settes tilbake etterpå.

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

Personaene er fra [test.md](../../tester-agent/_Miljøer/test.md), 2026-11-09, og er de samme som i den eksterne testen av tidlig opptak og tilbudsgaranti (2026-11-05).

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | `opptak-forvalter-forvaltende` | ORDENTLIG RUNDSKRIV | `OPPTAK_FORVALTER` | HK-dir | ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/plasstildeling/tidlig-opptak | Sette poenggrensen, prøvekjøre og gjennomføre tidligopptaket |
| 2 | `opptak-saksbehandler-behandlende-tidlig-opptak` | KORT DOMPAP | `OPPTAK_SAKSBEHANDLER` | UiT | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/soknadsbehandling | Konklusjon, kvalifisering, poeng og ferdigbehandling i sakene (testdata) |
| 3 | `opptak-tilbyder-behandlende` | KORT DOMPAP | `OPPTAK_FORVALTER` [Fylles ut: bekreft at rollen gir `OPPTAK_TILBGARANTI_GI_VIA_UTDTILBUD` ved UiT] | UiT | KORT DOMPAP • OPPTAK_FORVALTER (UIT) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/soknadsbehandling | Tidligopptakstilbud og manuell tilbudsgaranti fra tilbyder |
| 4 | `soker-tidlig-opptak` | Søkerne i «Søkere til testerne» i den eksterne testen som ikke er brukt | Søker | – | «Velg testsøker» i Min kompetanse | https://test.minkompetanse.no/ | Søknaden og søknaden om tidlig opptak (testdata), og svaret etter gjennomføringen |
| 5 | `opptak-saksbehandler-behandlende-tidlig-opptak-andre` | KORT DOMPAP | `OPPTAK_SAKSBEHANDLER` | NTNU | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (NTNU) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/soknadsbehandling | Gjør den andre saken klar i testen om en søker med to saker (testdata) |

Testbrukerne finnes i rollene scenarioene nevner, ved organisasjonene kravet gjelder. Antallet bestemmes per krav ut fra tilgangsmatrisen. Det lages ikke egne testcaser for roller og tilgang i fase 2: `fs-verify` har verifisert i koden at de er laget slik kravet sier (fase 1). Scenarioene i kravet, også om synlighet, testes som de står.

Nøkkel 2, 3, 4 og 5 er lagt inn i miljøfila 2026-11-09. Tilbyderrollen for nøkkel 3 er ikke bekreftet.

### Tilgangsmatrise

Fra tilgangsradene i verify-rapporten. Den viser hvilke roller kravet har ved hvilke organisasjoner, og hvilken testbruker som dekker hver rad. En rad uten tilgang trenger ingen testbruker, med mindre et scenario handler om den.

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Opptaksforvalter ved organisasjonen som forvalter opptaket | prøvekjører og gjennomfører | ingen tilgang (gjennomføringen avvises uten forvaltertilgang) | 1 |
| `@OPT-BEH-BEH-007` | Tilbyder ved lærestedet som behandler saken | setter tilbudsgaranti | ingen tilgang | 3 |

## Testdata

Testdataene testene trenger, med nøkkel. Data i testmiljøet kan slettes eller nullstilles når som helst, så testene lager dataene sine selv når det går: oppsettet ([`_Oppsett/02 Opptak/13 Søknad og saksbehandling/02 Behandling/oppsett.feature`](../../tester-agent/_Oppsett/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/oppsett.feature)) setter poenggrensene i hver kjøring. Søkerne trenger kvalifisering og poengsum i bestemte tilstander, og kan ikke brukes på nytt etter en gjennomføring. De står som lister i miljøfila, og må lages før testen. Hvert scenario tar en søker som ikke er brukt. Fra [test.md](../../tester-agent/_Miljøer/test.md), 2026-11-09. Testdata er syntetiske.

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| Poenggrensene | `poenggrenser-tidlig-opptak` | Lages av oppsettet | Fanen «Tidlig opptak» | – | 0 på `utdanningstilbud-tidlig-opptak` og `utdanningstilbud-tidlig-opptak-andre`, tom på de to utdanningstilbudene med og uten median | Alle |
| Opptaket | `opptak-tidlig-opptak` | Opptak 34, «Samordna UHG-simulering høsten 2026» | FS Admin | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0 | Samordna opptak med tidlig opptak slått på, forvaltet av HK-dir. 24 utdanningstilbud, og alle unntatt ett tilbyr tidlig opptak | Alle |
| Utdanningstilbud | `utdanningstilbud-tidlig-opptak` | «Datateknikk ingeniør» (UiT, Alta) | Fanen «Tidlig opptak» | Søk på navnet | Tilbyr tidlig opptak, ved organisasjonen til testbruker 2 og 3 | De fleste scenarioene |
| Utdanningstilbud med lavere prioritet | `utdanningstilbud-tidlig-opptak-andre` | «Elektronisk systemingeniør - bachelor i ingeniørfag» (NTNU, Gløshaugen) | Fanen «Tidlig opptak» | Søk på navnet | Tilbyr tidlig opptak. Søkerne har det som prioritet 2 | «Tilbudsgaranti på det høyest prioriterte …», «Tidligopptakstilbud fra tilbyder går foran …», «Tilbudsgarantien flyttes …» |
| Utdanningstilbud med median | `utdanningstilbud-tidlig-opptak-med-median` | «Paramedisin» (UiT, Tromsø), median 47,8 | Fanen «Tidlig opptak» | Søk på navnet | Tilbyr tidlig opptak, med median fra forrige opptak | Regelen om medianen, også «Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense» |
| Utdanningstilbud uten median | `utdanningstilbud-tidlig-opptak-uten-median` | «Medisin» (UiT, Bodø). «Medisin» ved UiO har median | Fanen «Tidlig opptak» | Søk på navnet | Tilbyr tidlig opptak, uten median fra forrige opptak | «Ingen tilbudsgaranti uten poenggrense og uten median …», «Se antall utdanningstilbud med mangelfulle innstillinger» |
| Tilbudsgarantitype for tidlig opptak | `tilbudsgarantitype-tidlig-opptak` | «Tilbudsgaranti, forhåndsløfte» (FOR) | «Tilbudsgaranti fra forvalter» | – | Nøyaktig én aktiv type for tidlig opptak som gir tilbud og kan brukes av opptaksforvalteren | Alle som gjennomfører |
| Tidligopptakstilbud fra tilbyder | `tilbudsgarantitype-tilbyder-tidligopptakstilbud` | «Tilbudsgaranti, tidligsvar (foropptak)» (FOP) | «Tilbudsgaranti fra tilbyder» | – | Type for tidlig opptak som gir tilbud, og kan brukes av tilbyder | Scenarioene med tidligopptakstilbud fra tilbyder |
| Tilbudsgaranti fra forvalter som gir tilbud | `tilbudsgarantitype-forvalter-gir-tilbud` | «Generell lokal tilbudsgaranti» (LOK). Gir tilbud (sjekket i eksempeldataene) | «Tilbudsgaranti fra forvalter» | – | Gir tilbud, og er ikke for tidlig opptak eller reservert studieplass | «Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet», «Annen tilbudsgaranti på et høyere prioritert søknadsalternativ …» |
| Tilbudsgaranti fra forvalter som ikke gir tilbud | `tilbudsgarantitype-forvalter-gir-ikke-tilbud` | «Avslag restetorg - ikke kvalifisert» (RIK). Gir ikke tilbud (sjekket i eksempeldataene) | «Tilbudsgaranti fra forvalter» | – | Gir ikke tilbud | «Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet» |
| Reservert studieplass fra behandler | `tilbudsgarantitype-reservert-studieplass-behandler` | «Tilbudsgaranti pga reservert plass» (RES) | «Tilbudsgaranti fra behandler» | – | Kategori reservert studieplass, kan brukes av behandler | Scenarioene med reservert studieplass fra behandler |
| Reservert studieplass fra forvalter | `tilbudsgarantitype-reservert-studieplass-forvalter` | «Tilbudsgaranti, har Møttkode=R fra ifjor» (RSO) | «Tilbudsgaranti fra forvalter» | – | Kategori reservert studieplass, kan brukes av opptaksforvalter. Ingen type kan brukes av både behandler og forvalter | «Reservert studieplass fra opptaksforvalter blir erstattet» |
| Opptak uten tilbudsgarantitype for tidlig opptak | `opptak-tidlig-opptak-uten-tilbudsgarantitype` | **Finnes ikke** (se «Kjente begrensninger» i testplanen) | «Opptak» | Søk på navnet | Tidlig opptak slått på, ingen aktiv type for tidlig opptak | «Tidligopptaket stopper uten én tilbudsgarantitype …» |
| Opptak med to tilbudsgarantityper for tidlig opptak | `opptak-tidlig-opptak-to-tilbudsgarantityper` | **Finnes ikke** (se «Kjente begrensninger» i testplanen) | «Opptak» | Søk på navnet | Tidlig opptak slått på, to aktive typer for tidlig opptak | «Tidligopptaket stopper uten én tilbudsgarantitype …» |
| Søkere | `sak-tidlig-opptak-kvalifisert` | Søknadene er laget 2026-11-10 (34-1004197 til 34-1004258). Hvem som er i hvilken liste, står i miljøfila | «Søknadsbehandling» | Søk på søkerens navn i «Søknadsbehandling» | Søknad om tidlig opptak, saken hos UiT ikke ferdig behandlet og uten konklusjon. Kvalifisert, med poengsum over 5, til `utdanningstilbud-tidlig-opptak` (prioritet 1) og `-andre` (prioritet 2). Mange søkere per kjøring | De fleste scenarioene |
| Søkere i andre tilstander | `sak-tidlig-opptak-ikke-kvalifisert`, `-kvalifisering-ikke-vurdert`, `-grunnlag-kvalifisert-og-ikke-kvalifisert`, `-grunnlag-ikke-vurdert-og-ikke-kvalifisert`, `-to-kvoter`, `-poeng-i-kvote-uten-kvoteplassering`, `-uten-poengsum`, `-median-over`, `-median-lik`, `-median-under`, `-uten-median`, `-to-tilbydere`, og `sak-uten-soknad-om-tidlig-opptak` | Søknadene er laget 2026-11-10 (34-1004197 til 34-1004258). Hvem som er i hvilken liste, står i miljøfila | «Søknadsbehandling» | Søk på søkerens navn i «Søknadsbehandling» | Som `sak-tidlig-opptak-kvalifisert`, men i tilstanden nøkkelen sier. Utgangstilstanden for hver står i miljøfila | Scenarioet nøkkelen er laget for (se «Krever» ved testene) |

Data scenarioet selv lager (for eksempel poenggrensen og tilbudsgarantien fra gjennomføringen), står ikke her: de lages av stegene i testcasen (R13 i `testcase-regler.md`).

Kolonnene `Søk/URL`, `Utgangstilstand` og `Brukes av` står bare i testplanen, ikke i testcasene for den interne og den eksterne testen.
