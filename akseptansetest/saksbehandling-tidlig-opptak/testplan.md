# Testplan – Saksbehandling av tidlig opptak

- **Leveranse**: feature-fil
- **Kilde**: `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/finne_søknader_om_tidlig_opptak.feature`, `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vurdere_søknad_om_tidlig_opptak.feature`, `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`
- **Scope**: @scope-tidlig-opptak
- **Scope-fil**: [opptak/tidlig-opptak](../../tasks/opptak/tidlig-opptak/scope.md)
- **Krav**: 3 feature-filer, 2 `@implemented`, 1 delvis levert, 0 flyter, commit `a742c008` (2026-11-05), med `@OPT-BEH-BEH-007` slik det står i PR #906 og taggene fra verifiseringen 2026-11-04
- **Verifisering**: [verify-finne_søknader_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-finne_s%C3%B8knader_om_tidlig_opptak-2026-10-26-1441.md), [verify-vurdere_søknad_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-vurdere_s%C3%B8knad_om_tidlig_opptak-2026-10-26-1441.md), [verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-04-1359.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-04-1359.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786 (versjonen fra 2026-10-27, uten `@OPT-BEH-BEH-007`)
- **Laget**: 2026-10-27 av fs-testplan. Ny versjon 2026-11-04 av fs-testplan: `@OPT-BEH-BEH-007` (STEK-489) lagt til, og planen delt i fire filer

- **Undersider**: [omfang.md](omfang.md), [testcaser-og-testdata.md](testcaser-og-testdata.md), [sporbarhet.md](sporbarhet.md)

---

Testplan for «Saksbehandling av tidlig opptak». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

Versjonen fra 2026-11-04 tar med gjennomføringen av tidligopptaket (`@OPT-BEH-BEH-007`). `@OPT-BEH-BEH-009` og `@OPT-BEH-BEH-013` er testet internt 2026-10-30 (10 av 10 bestått), og testrapporten venter på beslutning. Den testen gjelder fortsatt for dem. `@OPT-BEH-BEH-007` starter på fase 1.

## Innhold

Testplanen er delt i hovedsiden og tre undersider, så hver del kan oppdateres for seg. I Confluence står innholdsfortegnelsen og lista over undersider (med testrapportene og testsidene) over tabellen.

| Side | Innhold | Fil |
|---|---|---|
| Testplan (denne siden) | Testbeskrivelse, roller, tid og kanal, forutsetninger, kriterier for godkjent, funn, beslutning, status i flyten og vedlegg | `testplan.md` |
| Omfang – Saksbehandling av tidlig opptak | Kravene og flytene som testes, åpne spørsmål, avhengighetskart, det som venter på verifisering, regler uten scenario og det som ikke er med | `omfang.md` |
| Testcaser og testdata – Saksbehandling av tidlig opptak | Omfanget av testcasene som skal lages, testbrukerne, tilgangsmatrisen og testdataene | `testcaser-og-testdata.md` |
| Sporbarhet – Saksbehandling av tidlig opptak | Scenarioene fra kravet til koden og til testen | `sporbarhet.md` |

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Saksbehandleren kan filtrere sakene i et opptak på om søkeren har søkt om tidlig opptak, og på om saken mangler eller har konklusjon for tidlig opptak. I saken ser saksbehandleren søkerens begrunnelse og dokumentasjonskravet for den, og velger en av opptakets konklusjoner for tidlig opptak. Nytt (STEK-489): under «Plasstildeling» har opptaket fanen «Tidlig opptak», der opptaksforvalteren setter poenggrensen for tidlig opptak per utdanningstilbud, prøvekjører tidligopptaket og ser antall søkere og tilbudsgarantier, og gjennomfører det. Søkere som deltar, er kvalifisert og når poenggrensen (eller har reservert studieplass eller tidligopptakstilbud fra tilbyder), får tilbudsgaranti på det høyest prioriterte søknadsalternativet |
| Versjon | 009/013: testet i test-fsadmin 2026-10-30 (fs-plattform `97fbafa9b3`, fs-admin `2b7d1f87a`). 007: verifisert mot main 2026-11-04 (fs-plattform `3a3ef0403e`, fs-admin `29b2c1708`, STEK-489 = `f480d771d`), lagt ut i TEST |
| Testmiljø | [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/) |
| Feature-flagg | Ingen. Gjennomføringen er i experimental-skjemaet i fs-plattform, som er på i TEST |
| Kilde | [finne_søknader_om_tidlig_opptak.feature](https://github.com/sikt-no/fs/blob/bacd06f4/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/finne_s%C3%B8knader_om_tidlig_opptak.feature), [vurdere_søknad_om_tidlig_opptak.feature](https://github.com/sikt-no/fs/blob/bacd06f4/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vurdere_s%C3%B8knad_om_tidlig_opptak.feature), [gi_tilbudsgaranti_ved_tidlig_opptak.feature](https://github.com/sikt-no/fs/blob/bacd06f4/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) |
| Scope | `@scope-tidlig-opptak` · [`scope.md` på GitHub](https://github.com/sikt-no/fs/blob/bacd06f4/tasks/opptak/tidlig-opptak/scope.md) |
| Saker | [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) · [STEK-188](https://sikt.atlassian.net/browse/STEK-188), [STEK-268](https://sikt.atlassian.net/browse/STEK-268), [STEK-561](https://sikt.atlassian.net/browse/STEK-561), [STEK-269](https://sikt.atlassian.net/browse/STEK-269), [STEK-489](https://sikt.atlassian.net/browse/STEK-489) |
| Berører andre team | Nei. Tilbudsgarantiene brukes av plasstildelingen i hovedopptaket (se «Avhengighetskart») |
| Kjente begrensninger | 009/013: Kortet viser søkerens behov (teksten søkeren så, i første person) under «Begrunnelse fra søker», ikke navnet på begrunnelsen. Mangler teksten for en begrunnelse, vises «-». «Har konklusjon» i filteret tar også med en sak med konklusjon der søkeren ikke har søkt (bare mulig utenom saksbehandlingen). Etter bytte av testbruker må siden lastes inn på nytt (F5). 007: Dialogen for prøvekjøring viser bare fem tall (har søkt, har saker som ikke er behandlet, deltar, totale tilbudsgarantier og tilbudsgarantier på første prioritet). Utfallet per søknadsalternativ, mangelfulle innstillinger og kvotevarselet vises ikke, og grensen for kvotevarsel kan ikke angis (9 av 29 scenarioer venter på verifisering). Hjelpeteksten sier at poenggrensen kan stå blank når medianen er OK, men uten poenggrense gis ingen tilbudsgaranti. Kolonnene «T.O. søkere totalt» og «T.O. søkere 1. pri.» viser alltid «-». En gjennomføring publiserer svaret til søkerne, så den gjøres ikke i opptak 34 uten avtale (bare prøvekjøring i fase 2) |
| Avhengighetskart | Under «Flyter» på Omfang – Saksbehandling av tidlig opptak |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | [Fylles ut: navn] | Eier testen fra start til beslutning. Har ansvaret for at agenten blir kjørt og tester riktig (kjøringen kan gjøres av andre), går gjennom testcasene før kjøringen og funnene etterpå, tar stikkprøver av beståtte testcaser etter en risikovurdering, og skriver beslutningen i testrapporten |
| Kjører av agenten | Patrick Sletvold | Starter den agentiske funksjonstesten (fase 2) |
| Kontaktperson i teamet | [Fylles ut: navn] | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | Marit Rønning (fagperson) | Alle testcasene i den interne akseptansetesten |
| Eksterne testere | [Fylles ut: om leveransen skal til ekstern akseptansetest, og hvem] | Bare når leveransen skal til ekstern akseptansetest. Gjennomfører testen i flytene |
| Kontaktperson i den eksterne testen | [Fylles ut: navn, normalt testansvarlig] | Bare ved ekstern akseptansetest. Én per test. Svarer på spørsmål underveis, har ansvaret for at funnene blir fulgt opp, og går gjennom resultatet med partene |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Agentisk funksjonstest | [Fylles ut: dato]. Kjøres av Patrick Sletvold (007) |
| Intern akseptansetest | 009/013: 2026-10-30. 007: [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | Avklares med de eksterne partene. Hvordan spørsmål tas underveis (e-post, telefon eller møte), og hvem som beslutter, avtales med testerne før testen |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Saksbehandling av tidlig opptak» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | 009/013: Oppfylt. 007: lagt ut (oppgitt av teamet 2026-11-04), [Fylles ut av teamet: virker] |
| 2 | Testdataene i «Testdata» finnes i testmiljøet, i utgangstilstanden der. Tilstander som bygger på datoer, er sjekket samme dag som testen | 009/013: Oppfylt. 007: [Fylles ut av teamet: opptak 34 har tidlig opptak, nøyaktig én aktiv tilbudsgarantitype i kategorien for tidlig opptak, poenggrenser og søkere med ferdig behandlede saker, konklusjon og poengsum] |
| 3 | Testdataene kan settes tilbake før hver kjøring | Oppfylt for 009/013: velg «Ikke valgt» i «Konklusjon». 007: prøvekjøringen lagrer ingenting. Poenggrensene som endres i testen, settes tilbake av testen |
| 4 | Testbrukerne finnes i rollene ved organisasjonene kravene gjelder (tilgangsmatrisen) | 009/013: Oppfylt. 007: **Ikke oppfylt** (sjekket i TEST 2026-11-06). Ingen rad i «Overstyrt bruker» har alt som trengs for «Kjør tidligopptak». ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) gir `FS-ADMIN_MODIFISERE_OPPTAK`, `FS-ADMIN_OPPTAK_TILBGARANTI_GI_VIA_OPPTAK` og `FS-ADMIN_SE_OPPTAK`, men ikke `FS-ADMIN_SE_SØKNADSBEHANDLING`. OPPTAK_SAKSBEHANDLER (HK-DIR) gir `FS-ADMIN_SE_SØKNADSBEHANDLING`, men ikke de andre. Knappen vises derfor ikke for noen av dem i opptak 34, og backend krever det samme (`erOpptaksforvalter`: `SE_SOKNADSBEHANDLING` og `MODIFISERE_OPPTAK`). Det trengs en persona med begge rollene, eller at `OPPTAK_FORVALTER` gir `SE_SØKNADSBEHANDLING` i rollekatalogen |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten. Åpne spørsmål stopper ikke, og står i «Åpne spørsmål» | 009/013: alle 15 funnet (2026-10-26), kontroll av en annen person venter. Kravene er endret 2026-11-02 («Ferdig behandlet» heter nå «Behandlet»), bare ordlyd. 007: 20 funnet, 7 ikke funnet, 2 usikker av 29 (2026-11-04), kontrollert av `fs-verify-kontroll`. De 20 leverte delene testes. Kontroll av en annen person: Venter |
| 6 | De agentiske testcasene (`fs-testcaser-cdp`) er laget, og testansvarlig og teamet har gått gjennom dem før kjøringen | Laget 2026-11-05. Gjennomgang: Venter. Verdiene til nøklene i miljøfila er ikke fylt ut |
| 7 | Flyttestcasene for den interne akseptansetesten (`fs-testcaser-intern`) er laget og gått gjennom av testansvarlig | 009/013: Laget. 007: Venter |
| 8 | Testansvarlig er logget inn i FS Admin i en egen Chrome-profil til testingen, CDP-agenten kan bytte til hver testbruker i «Overstyrt bruker», og nøklene i testbrukere og testdata er utfylt | [Fylles ut av teamet]. `cdp`-skillen er ikke installert på maskinen til den som kjører agenten ennå |
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

Fase 3 og 4 bruker de samme tre utfallene. I fase 4 kalles godkjent og godkjent med forbehold «Akseptert» i flyten.

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene (i fase 3 og 4). |

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Etter den eksterne akseptansetesten er beslutningen vurdert mot flytene og kravene, og hvem som beslutter, er avtalt med partene før testen. Kontaktpersonen går gjennom resultatet med partene.

## Status i flyten

| Fase | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | 009/013: [verify-finne_søknader_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-finne_s%C3%B8knader_om_tidlig_opptak-2026-10-26-1441.md), [verify-vurdere_søknad_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-vurdere_s%C3%B8knad_om_tidlig_opptak-2026-10-26-1441.md) · Confluence: [Finne søknader](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148966925), [Vurdere søknad](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148835843) | Alt funnet | 2026-10-26 |
| 1. Verifisering (`fs-verify`) | 007: [verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-04-1359.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-04-1359.md) | 7 ikke funnet, 2 usikker | 2026-11-04 |
| 1. Testplan | (denne siden) | Laget (ny versjon med 007) | 2026-11-04 |
| 1. Testrapport – verifisering | 009/013: [testrapport-verifisering-2026-10-27.md](testrapport-verifisering-2026-10-27.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148803102). 007: – | 009/013: Klar. 007: Venter | 2026-10-27 |
| 2. Agentisk funksjonstest | – | 009/013: Ikke aktuell (testet før fase 2 ble en del av flyten). 007: Venter | |
| 3. Intern akseptansetest | 009/013: [testcaser-intern.md](testcaser-intern.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5149065264). [testrapport-intern-2026-10-30.md](testrapport-intern-2026-10-30.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5158928698) | 009/013: Gjennomført, 10 av 10 bestått. Venter på beslutning (forslag: Godkjent). 007: Venter | 2026-10-30 |
| 4. Ekstern akseptansetest | – | Venter | |

Testrapportene (verifisering, agentisk, intern og ekstern) står som undersider, og lenken står i raden for fasen.

## Vedlegg

| Vedlegg | Lenke |
|---|---|
| Verifiseringsrapporten (fase 1) | 009/013: se «Status i flyten». 007: [verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-04-1359.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-04-1359.md) |
| Agentisk testrapport (fase 2) | – |
| Testcasene for fase 2 | [`cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`](../../cdp-tester/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/) (laget 2026-11-05), og kjøringen i `akseptansetest/saksbehandling-tidlig-opptak/kjoring-<dato>/` |
| Testcasene for fase 3 | 009/013: [testcaser-intern.md](testcaser-intern.md). 007: – |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
