# Testrapport – agentisk funksjonstest – Gi tilbudsgaranti ved tidlig opptak

- **Nivå**: agentisk
- **Fase**: 2
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074
- **Scope**: @scope-tidlig-opptak
- **Grunnlag**: to kjøringer, lest 2026-11-13. [`kjoring-2026-11-13-1704/resultat.md`](kjoring-2026-11-13-1704/resultat.md) for de 5 testcasene som er nye eller endret etter at kravet ble levert (`93a20ea5`), og [`kjoring-2026-11-11-1057/resultat.md`](kjoring-2026-11-11-1057/resultat.md) for de 41 som ikke er endret. Prøven [`kjoring-2026-11-10-1440`](kjoring-2026-11-10-1440/resultat.md) er ikke talt med
- **Tester**: [`tester-agent/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`](../../tester-agent/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature), krav-blob `e6c37f57`
- **Forrige rapport**: [testrapport-agentisk-2026-11-11.md](testrapport-agentisk-2026-11-11.md)
- **Branch**: `testplan/beh-007-tidligopptak` (PR #989), oppdatert mot origin, 9 commits bak main (ingenting som gjelder leveransen)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5187174452
- **Laget**: 2026-11-13 av fs-testrapport

---

Testrapport for «Gi tilbudsgaranti ved tidlig opptak». Den bygger på de agentiske kjøringene 2026-11-11 og 2026-11-13 i TEST, mot kravet slik det er levert (`@OPT-BEH-BEH-007` er `@implemented` etter verifiseringen 2026-11-13).

## Hva er nytt siden rapporten 2026-11-11

- Kravet er levert i sin helhet. De to siste scenarioene («Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense» og «Se antall utdanningstilbud med mangelfulle innstillinger») er testet og bestått.
- To utledede testcaser er blitt scenarioer i kravet, med samme innhold: «Reservert studieplass fra opptaksforvalter blir erstattet» og «Tidligopptakstilbud fra tilbyder gjelder også uten søknad om tidlig opptak». Begge er kjørt på nytt og bestått.
- Dialogen i fs-admin er endret (STEK-489): etter gjennomføringen blir den stående som «Resultat for tidligopptak», med «Lukk», og prøvekjøringen har en ny tekst. Begge er sett 2026-11-13. Testcasene med gjennomføring fra 2026-11-11 er kjørt med den gamle dialogen, men det de sjekker (tilbudsgarantien i saken), er ikke endret.
- «Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak» er tatt ut av testen: resultatet kan bare ses når hovedopptaket kjøres, og hører til plasstildelingen (`@OPT-PLA-TIL-002`). Den var «Ikke testet» 2026-11-11.

## Oppsummering

| Felt | Innhold |
|---|---|
| Kjøringer | `kjoring-2026-11-11-1057` (startet av Jens Peter Thomassen, kjørt av Claude med cdp-skillen) og `kjoring-2026-11-13-1704` (startet av Daniel Sachse, kjørt av Claude med Vibium 26.8.21), begge mot TEST (https://test-fsadmin.sikt.no, opptak 34 «Samordna UHG-simulering høsten 2026»). Versjonen er ikke notert i kjøringene |
| Testcaser | 42 bestått, 0 ikke bestått, 4 ikke testet, 0 ikke fylt ut, av 46 (foreslått av agenten) |
| Fra scenarioene i kravet | 36 testcaser: 33 bestått, 3 ikke testet |
| Utledet av agenten | 10 testcaser (grenseverdier, beslutningstabell, tilstandsoverganger og ekvivalensklasser): 9 bestått, 1 ikke testet |
| Funn | Ingen nye. F1 fra prøven 2026-11-10 er rettet. 0 «Kravet dekker ikke» |
| Testdata | Søkerne og poenggrensene fantes. To opptak finnes ikke i TEST (`opptak-tidlig-opptak-uten-tilbudsgarantitype` og `opptak-tidlig-opptak-to-tilbudsgarantityper`). Testdataene for to testcaser er rettet i testen etter 2026-11-11, men ikke kjørt på nytt. Søkerne går tom. Se «Testdata og bevis» |
| Gjennomgått av testansvarlig | [Fylles ut av testansvarlig] |
| Stikkprøve av beståtte testcaser | [Fylles ut av testansvarlig] (størrelsen avgjøres etter en risikovurdering, det er ikke noe fast antall) |
| Inngangskriterium til intern akseptansetest | Ikke oppfylt ennå: testansvarlig er ikke utnevnt, og har ikke gått gjennom rapporten (se «Inngangskriteriet til intern akseptansetest») |

Scenariomalene er talt per eksempel: 3 i «Tilbudsgaranti ut fra poenggrensen», 2 i «… kvalifiseringen har flere grunnlag», 2 i «Tilbudsgaranti på det høyest prioriterte søknadsalternativet», 5 i scenariomalen med medianen og 2 i «Tidligopptaket stopper …».

## Inngangskriteriet til intern akseptansetest

Sjekkes for seg, fordi det er inngangen til fase 3. Den agentiske rapporten har ingen beslutning, bare dette.

| Kriterium | Oppfylt |
|---|---|
| Alle testcasene er kjørt (ingen «ikke fylt ut», og «ikke testet» har begrunnelse) | Ja: alle 46 har status, og de 4 som er «ikke testet», har begrunnelse (se «Ikke testet») |
| Ingen funn med «Stopper» står åpne | Ja: ingen åpne funn |
| Testansvarlig har gått gjennom rapporten, også funnene og stikkprøven av de beståtte | [Fylles ut av testansvarlig] |

## Resultat per krav

Kravet er [Gi tilbudsgaranti ved tidlig opptak](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) (`@OPT-BEH-BEH-007`, `@implemented`).

| Krav | Regel | Teknikk | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Positiv | 20 | 0 | 1 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Grenseverdi | 4 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Beslutningstabell | 3 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Tilstandsovergang | 1 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | Ekvivalensklasse | 3 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt | Grenseverdi | 6 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Median poengsum fra forrige opptak brukes når poenggrensen ikke er satt | Positiv | 2 | 0 | 0 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter ser utfallet av tidligopptaket | Positiv | 2 | 0 | 2 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter ser utfallet av tidligopptaket | Ekvivalensklasse | 0 | 0 | 1 |
| `@OPT-BEH-BEH-007` | Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket | Positiv | 1 | 0 | 0 |
| | **Til sammen** | | **42** | **0** | **4** |

«Positiv» er scenarioene i kravet som står uten egen teknikk i testen. Eksemplene i scenariomalene «Tilbudsgaranti ut fra poenggrensen» (P − 5, P og P + 5) og «Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak» (over, lik og under medianen, P + 2 og P − 2) er fra kravet, men er grenseverdier, og står under «Grenseverdi». De fem testcasene fra kjøringen 2026-11-13 står under «Positiv»: «Reservert studieplass fra opptaksforvalter blir erstattet», «Tidligopptakstilbud fra tilbyder gjelder også uten søknad om tidlig opptak» og «Prøvekjøre tidligopptaket» i den første regelen, «Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense» under medianen, og «Se antall utdanningstilbud med mangelfulle innstillinger» under utfallet.

## Regler uten scenario

Fra «Regler uten scenario» i omfanget (verify-rapportene 2026-11-09 og 2026-11-13). 9 av de 14 reglene skulle testes i fase 2, og alle 9 er testet og bestått. De 5 andre var ikke planlagt testet i fase 2.

| Krav | Regel i koden | Testet i fase 2 | Kravet bør få scenario |
|---|---|---|---|
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten poengsum i garantikvoten gir ikke tilbudsgaranti | ja: «… søknadsalternativet har ingen poengsum», bestått (2026-11-11) | nei |
| `@OPT-BEH-BEH-007` | Utdanningstilbud uten rangeringsregelverk, kvoter eller kompetanseregelverk gir ikke tilbudsgaranti | nei: utgangstilstanden kan ikke lages i opptak 34 uten å endre utdanningstilbudene andre tester bruker | nei: visningen er utsatt i kravet |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud er ikke med i tidligopptaket (og gir ingen avvik) | nei: utdanningstilbudene i opptak 34 brukes av andre tester | nei |
| `@OPT-BEH-BEH-007` | Poengsummen tas bare fra kvoter søkeren skal kvoteplasseres i og som tilbudet har, og fra grunnlag rangeringsregelverket åpner for | ja: «… poengsummen i en kvote søkeren ikke skal kvoteplasseres i», bestått (2026-11-11) | nei |
| `@OPT-BEH-BEH-007` | Kvalifiseringen: ett kvalifisert grunnlag holder, ellers ikke kvalifisert bare når alle grunnlagene er vurdert til nei | ja: «… kvalifiseringen har flere grunnlag» (2 eksempler), bestått (2026-11-11) | nei |
| `@OPT-BEH-BEH-007` | Trukne søknadsalternativer og saker som ikke er aktive, er ikke med | ja: «… søknadsalternativet med høyest prioritet er trukket», bestått (2026-11-11, se «Bestått, men faktisk resultat avviker») | nei |
| `@OPT-BEH-BEH-007` | En søker som ikke har søkt om tidlig opptak, men har et tidligopptakstilbud, er med og får tilbudsgaranti | ja: «Tidligopptakstilbud fra tilbyder gjelder også uten søknad om tidlig opptak», bestått (2026-11-13) | har fått scenario (2026-11-13) |
| `@OPT-BEH-BEH-007` | Reservert studieplass i kolonnen til opptaksforvalter erstattes av tilbudsgarantien fra tidligopptaket | ja: «Reservert studieplass fra opptaksforvalter blir erstattet», bestått (2026-11-13) | har fått scenario (2026-11-13) |
| `@OPT-BEH-BEH-007` | Treffer en skriving ingen rad, stoppes hele gjennomføringen og rulles tilbake | nei: krever samtidige endringer | nei |
| `@OPT-BEH-BEH-007` | Gjennomføringen er sperret i fs-admin til prøvekjøringen har gitt en oppsummering, når poenggrenser ikke er lagret, og når prøvekjøringen gir feil | ja: «… poenggrensen er ikke lagret», bestått (2026-11-11). Sperren ved feil i prøvekjøringen er ikke sett (opptakene uten eller med to tilbudsgarantityper finnes ikke) | nei |
| `@OPT-BEH-BEH-007` | «Feilkonfigurerte utdanningstilbud» teller mangler, ikke utdanningstilbud, og tar med overskredet kvote. «Konfigurasjonsavvik» står ved tallet | ja: «Se antall utdanningstilbud med mangelfulle innstillinger», tallet gikk fra 3 til 4 og «Konfigurasjonsavvik» sto ved tallet, bestått (2026-11-13). Dobbelttellingen er ikke testet for seg | nei: kjent og akseptert unøyaktighet (2026-11-13) |
| `@OPT-BEH-BEH-007` | Dialogen blir stående med resultatet etter gjennomføringen («Resultat for tidligopptak»), med «Lukk» og uten knapp for å kjøre igjen | ja: Gjennomføring G steg 5, sett 2026-11-13 | nei |
| `@OPT-BEH-BEH-007` | Kvotevarselet er 30 prosent når grensen ikke er angitt | nei: kvotevarselet er utsatt | nei: dekkes av det utsatte scenarioet |

## Testdata og bevis

| Felt | Innhold |
|---|---|
| Testdata | Søkerne i miljøfila ([`test.md`](../../tester-agent/_Milj%C3%B8er/test.md)), med søknadene laget i Min kompetanse 2026-11-10 og kvalifiseringen og poengsummen fra SQL-skriptet. Poenggrensene fra oppsettet 2026-11-10 (0 på «Datateknikk ingeniør» og «Elektronisk systemingeniør», tom på «Paramedisin» og begge «Medisin») sto fortsatt, og ble satt tilbake etter hvert scenario i begge kjøringene. `opptak-tidlig-opptak-uten-tilbudsgarantitype` og `opptak-tidlig-opptak-to-tilbudsgarantityper` finnes ikke i TEST |
| Kan kjøres på nytt | Ja, med nye søkere: gjennomføringen kan ikke settes tilbake, så hver testcase bruker sin egen søker. Igjen i `sak-tidlig-opptak-kvalifisert`: 34-1004225 og 34-1004258. Ingen igjen i `sak-uten-soknad-om-tidlig-opptak`. Det må lages flere søkere før en full kjøring |
| Bevis | `kjoring-2026-11-11-1057/` og `kjoring-2026-11-13-1704/` (`resultat.md` er i git, skjermbilder er lokale og ikke i git) |

Opptak 34 endres av andre i TEST: den har nå 31 utdanningstilbud i fanen «Tidlig opptak», og tallene i prøvekjøringen tar med søkere fra andre tester. Testcasene sjekker derfor søkerens egen sak, og testcasene med tall i prøvekjøringen sjekker forskjellen mellom to prøvekjøringer.

## Ikke bestått

Ingen.

## Bestått, men faktisk resultat avviker

Testcaser med status «Bestått» der «Faktisk resultat» beskriver noe annet enn forventet resultat, eller der stegene ikke ble tatt helt som de sto. Testansvarlig ser på dem og avgjør status. Skillen endrer ikke statusen.

| Nr | Scenario | Forventet resultat | Faktisk resultat |
|---|---|---|---|
| 1 | Tilbudsgaranti ut fra poenggrensen (grense P + 5) (2026-11-11) | «Tilbudsgaranti, forhåndsløfte» står ikke under «Tilbudsgaranti fra forvalter» for «Datateknikk ingeniør» | Som forventet for «Datateknikk ingeniør». Søkeren fikk i tillegg tilbudsgaranti på «Elektronisk systemingeniør» (prioritet 2), fordi poenggrensen der er 0 fra oppsettet. Testen sjekker bare prioritet 1 |
| 2 | Opptaksforvalter gjennomfører tidligopptaket: søknadsalternativet med høyest prioritet er trukket (2026-11-11) | Søkeren fjerner «Datateknikk ingeniør» fra søknaden i Min kompetanse, og får tilbudsgaranti på det andre søknadsalternativet | Tilbudsgarantien kom på «Elektronisk systemingeniør», som forventet. Men søknaden ble endret gjennom API-et Min kompetanse bruker, som søkeren, ikke i skjermen: «Velg testsøker» kunne ikke velges med CDP. Saken i FS Admin viser bare det gjenværende søknadsalternativet, ikke det fjernede som trukket |
| 3 | Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak (lik, tom poenggrense) (2026-11-11) | Klargjøring K lagres, og søkeren får tilbudsgaranti | Første klargjøring ble ikke lagret: etter ny innlasting sto saken som «Ikke behandlet» og «Konklusjon» «Ikke valgt», og saken var ikke med i gjennomføringen. Andre gang ble den lagret, og en egen gjennomføring ga tilbudsgaranti |
| 4 | Reservert studieplass fra opptaksforvalter blir erstattet (2026-11-13) | Klargjøring K: «Behandlet» i «Behandlingsstatus» lagres | «Behandlet» ga dialogen «Søkeren ser ikke alle manglene ennå» («Mangeltekst for HING»), som steget ikke nevnte. «Avbryt» lot saken stå som «Ikke behandlet». Med ja fra den som startet kjøringen ble «Publiser og sett til Behandlet» valgt, og mangelen ble publisert til den syntetiske søkeren. Resultatet er som forventet. Steget er rettet i testen etterpå (`c2fbb92f`) |

## Ikke testet

Testansvarlig vurderer begrunnelsene før beslutningen.

| Nr | Scenario | Begrunnelse |
|---|---|---|
| 1 | Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket | 2026-11-11: testdataene stemte ikke (saken lå hos organisasjonen som behandler prioritet 1, ikke UiT). Testdataene er rettet i testen 2026-11-13, men testcasen er ikke kjørt på nytt |
| 2 | Opptaksforvalter ser utfallet av tidligopptaket: en søker med to saker som ikke er ferdig behandlet | 2026-11-11: søkerne hadde én sak. Testen deler nå saken ved å overstyre utdanningsbakgrunnen (`sak-tidlig-opptak-to-tilbydere`), men er ikke kjørt på nytt |
| 3 | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak (`opptak-tidlig-opptak-uten-tilbudsgarantitype`) | Opptaket finnes ikke i TEST. Sjekken er funnet i koden i fase 1 (`TidligopptakTilbudsgarantiService.java:282`), og integrasjonstesten `utenGarantitypeGirFeil` i fs-plattform dekker den |
| 4 | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak (`opptak-tidlig-opptak-to-tilbudsgarantityper`) | Opptaket finnes ikke i TEST, og tilbudsgarantityper kan ikke legges til i FS Admin. Bare dekket av koden (`TidligopptakTilbudsgarantiService.java:289`) |

Nr. 1 og 2 kan kjøres i en ny runde når det er laget søkere. Nr. 3 og 4 er kjent på forhånd som data testene ikke kan lage, og er kandidater til delen «Det den agentiske testen ikke klarte» i den interne akseptansetesten. Testansvarlig avgjør om dekningen i koden holder.

## Funn

Sortert etter alvorlighetsgrad. «Fase funnet» er 2.

Ingen nye funn i kjøringene 2026-11-11 og 2026-11-13. F1 fra prøven 2026-11-10 er rettet og bekreftet:

| # | Fase funnet | Testcase | Type | Hva skjedde | Alvorlighetsgrad | Sak | Oppfølging |
|---|---|---|---|---|---|---|---|
| F1 | 2 | Alle testcasene med Gjennomføring G | Feil | «Kjør tidligopptak» vistes ikke for opptaksforvalteren ved HK-dir: rollen OPPTAK_FORVALTER ga ikke `FS-ADMIN_SE_SØKNADSBEHANDLING` | Ikke satt i kjøringen | – | Rettet i rollekatalogen før kjøringen 2026-11-11. Knappen vises, og gjennomføringen virker |

## Neste steg

- Utnevn testansvarlig. Testansvarlig går gjennom rapporten, «Bestått, men faktisk resultat avviker» og «Ikke testet», og tar en stikkprøve av de beståtte testcasene. Da er inngangskriteriet oppfylt, og neste steg er `fs-testcaser-intern` (testcasene for fase 3).
- Testdataene: lag flere søkere i opptak 34, og kjør «Annen tilbudsgaranti …» og «… en søker med to saker …» på nytt (`fs-testcaser-agent` har rettet testene).
- Kravet: ingen «Kravet dekker ikke». De to reglene uten scenario som skulle avklares med `fs-krav`, har fått scenario og er bestått.

## Læring

Fylles ut etter det korte møtet mellom testerne og teamlederne.

- Hvilke feil burde vært fanget tidligere? F1 (rollen til opptaksforvalteren) ble ikke fanget i fase 1, fordi `fs-verify` leste kravene til rollene i koden, men ikke rollekatalogen i TEST.
- Hva bør endres i testprosessen? Søkerne i opptak 34 brukes opp, fordi gjennomføringen ikke kan settes tilbake. En ny runde krever at det lages søkere først.
- Testcaser som var feil eller uklare: testdataene for søkere med prioritet 1 uten tidlig opptak og med to saker bygde på at én søknad kan få flere saker (rettet 2026-11-13). Klargjøring K nevnte ikke dialogen om mangler (rettet 2026-11-13).
- Regler uten scenario som burde vært i kravet: de to som var foreslått, har fått scenario.
