# Testrapport – agentisk funksjonstest – Saksbehandlertildeling, runde 2

- **Nivå**: agentisk
- **Fase**: 2
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2 (utkast)
- **Scope**: –
- **Grunnlag**: `kjoring-2026-11-04-1510/resultat.md`, lest 2026-11-05 01:03
- **Confluence**: –
- **Laget**: 2026-11-05 av fs-testrapport

---

Testrapport for «Saksbehandlertildeling, runde 2». Rapporten bygger på den agentiske kjøringen 2026-11-04 15:10 til 2026-11-05 00:28 (omgangene oppsett, R1, INN, FOR, END, STD og FLY). Alle statuser er foreslått av agenten. Testansvarlig har ikke gått gjennom dem.

Nr i tabellene er omgangen og linjen i `resultat.md` (for eksempel R1-70). Tallene er regnet ut med et skript fra radene i `resultat.md`, og tellingen er per rad, altså per eksempel i en scenariomal. Rad END-141 dekker tre eksempler i én rad. Kravfila og flytfila har samme blob-hash som i headerne til testene (`d49bb56c` og `61fda4b3`), så kravene er uendret siden testene ble laget. Headeren i `resultat.md` er skrevet etter oppsettet («Tester: ingen ennå», «Kravstatus: ikke sjekket») og er ikke oppdatert.

## Oppsummering

| Felt | Innhold |
|---|---|
| Kjøring | `kjoring-2026-11-04-1510`, kjørt av agent (chrome-devtools) for testansvarlig Håkon Medhus Fornes, mot TEST: test-fsadmin.sikt.no og test.minkompetanse.no. Versjon er ikke oppgitt (testplanen: [Fylles ut]) |
| Testcaser | 89 bestått, 5 ikke bestått, 11 ikke testet, 0 ikke fylt ut, av 105 (foreslått av agenten). Testene har 91 scenarioer: 66 fra kravene og 25 utledet |
| Fra scenarioene i kravene | 77 testcaser: 73 for `@OPT-BEH-BEH-011` (62 bestått, 3 ikke bestått, 8 ikke testet) og 4 for flyten `@FLY-OPT-SAK-001` (3 bestått, 1 ikke testet) |
| Utledet av agenten | 28 testcaser (24 bestått, 2 ikke bestått, 2 ikke testet) |
| Oppsett (ikke testcaser) | 7 nøkler: 2 bestått, 4 ikke bestått, 1 ikke testet. De fire søknadene som ikke bestod, er forklart (F9) og laget på nytt |
| Funn | 0 Stopper, 3 Må fikses før innføring, 9 Kan fikses senere (foreslått, testansvarlig bestemmer). Av dem 1 «Kravet dekker ikke». I tillegg 9 funn om testmiljøet, testdata og testene, som ikke gjelder løsningen |
| Testdata | Reglene, unntakene og søknadene ble laget av oppsettet. Det manglet: tilbudsgarantityper, søkerinnlogging i Min kompetanse og HK-dir-personaer med tilgang til «Opprett søknad» (se «Testdata og bevis») |
| Rettingene fra runde 1 | STEK-652, 653, 655, 656 og 658 er bekreftet av testcaser som er bestått (se «Rettingene fra runde 1») |
| Gjennomgått av testansvarlig | [Fylles ut av testansvarlig] |
| Stikkprøve av beståtte testcaser | [Fylles ut av testansvarlig]   (størrelsen avgjøres etter en risikovurdering, det er ikke noe fast antall) |
| Inngangskriterium til intern akseptansetest | Ikke oppfylt ennå: to av tre kriterier er oppfylt, og gjennomgangen til testansvarlig mangler (se «Inngangskriteriet til intern akseptansetest») |

## Inngangskriteriet til intern akseptansetest

Sjekkes for seg, fordi det er inngangen til fase 3. Den agentiske rapporten har ingen beslutning, bare dette.

| Kriterium | Oppfylt |
|---|---|
| Alle testcasene er kjørt (ingen «ikke fylt ut», og «ikke testet» har begrunnelse) | Ja: 0 ikke fylt ut, og alle 91 scenarioene i testene har en rad. De 11 «ikke testet» har begrunnelse (se «Ikke testet»). Merk: 8 regler uten scenario som testplanen la til fase 2, har ingen testcase (se «Regler uten scenario») |
| Ingen funn med «Stopper» står åpne | Ja: ingen funn er foreslått som «Stopper». Hvis testansvarlig vurderer F1 og F-INN-3 (Min kompetanse) som «Stopper», er kriteriet ikke oppfylt |
| Testansvarlig har gått gjennom rapporten, også funnene og stikkprøven av de beståtte | [Fylles ut av testansvarlig] |

## Resultat per krav

| Krav | Regel | Teknikk | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|---|
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket | Positiv (scenario fra kravet) | 11 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket | grenseverdianalyse (utledet) | 7 | 1 | 0 |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket | ekvivalensklasser (utledet) | 8 | 1 | 0 |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket | tilstandsoverganger (utledet) | 2 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Ved «Alle som deltar i opptaket» saksbehandler lærestedet søkeren har prioritert høyest | Positiv (scenario fra kravet) | 2 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Ved «Bare tilbyderen – bare dette studieønsket» saksbehandler tilbyderen bare søknadsalternativet med behandlertildelingsregelen | Positiv (scenario fra kravet) | 2 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen | Positiv (scenario fra kravet) | 8 | 1 | 0 |
| `@OPT-BEH-BEH-011` | Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen | ekvivalensklasser (utledet) | 3 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket | Positiv (scenario fra kravet) | 10 | 0 | 1 |
| `@OPT-BEH-BEH-011` | Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket | ekvivalensklasser (utledet) | 3 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket | grenseverdianalyse (utledet) | 1 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Ved «Bare tilbyderen – også for studieønsker uten egen regel» saksbehandler tilbyderen også søknadsalternativene uten egen behandlertildelingsregel | Positiv (scenario fra kravet) | 2 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Ved «Tilbydere i samme sektor» saksbehandler én organisasjon alle søknadsalternativene i sektoren | Positiv (scenario fra kravet) | 8 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast | Positiv (scenario fra kravet) | 9 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak | Positiv (scenario fra kravet) | 4 | 0 | 5 |
| `@OPT-BEH-BEH-011` | Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak | grenseverdianalyse (delvis utledet) | 3 | 0 | 1 |
| `@FLY-OPT-SAK-001` | Søknadsalternativene fordeles når søknaden sendes | Positiv (scenario fra kravet) | 2 | 0 | 0 |
| `@FLY-OPT-SAK-001` | Den saksbehandlende organisasjonen ser saken | Positiv (scenario fra kravet) | 1 | 0 | 1 |
| `@OPT-BEH-BEH-011` | Saksbehandlende organisasjon ser bare saker hos organisasjonen | Positiv (scenario fra kravet) | 1 | 1 | 1 |
| `@OPT-BEH-BEH-011` | Saksbehandlende organisasjon ser bare saker hos organisasjonen | tilstandsoverganger (utledet) | 0 | 0 | 1 |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket | Positiv (scenario fra kravet) | 1 | 0 | 0 |
| `@OPT-BEH-BEH-011` | Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet | Positiv (scenario fra kravet) | 1 | 1 | 1 |

Krav: [Tildele saksbehandlende organisasjon](https://github.com/sikt-no/fs/blob/7d4ee5d1/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) (`@OPT-BEH-BEH-011`) og flyten `@FLY-OPT-SAK-001`.

Per teknikk (utledet er testcasene agenten har utledet fra reglene):

| Teknikk | Testcaser | Bestått | Ikke bestått | Ikke testet | Av dem utledet |
|---|---|---|---|---|---|
| Positiv (scenario fra kravet) | 74 | 62 | 3 | 9 | 0 |
| grenseverdianalyse | 13 | 11 | 1 | 1 | 10 |
| ekvivalensklasser | 15 | 14 | 1 | 0 | 15 |
| tilstandsoverganger | 3 | 2 | 0 | 1 | 3 |

Testplanen nevner også beslutningstabell som teknikk. Ingen rad i `resultat.md` har den som teknikk, så de fordelingsscenarioene står som positiv testing.

## Rettingene fra runde 1

| Sak | Retting | Testcaser | Foreslått resultat |
|---|---|---|---|
| STEK-652 | Feilmelding ved bytte av standardregel | STD-145 og FOR-110 (byttet til «ISO» og tilbake, «Lagring vellykket»), R1-55 og R1-78 (melding når opptaket har en aktiv regel med «Alle som deltar i opptaket»), R1-77 (lista viser bare aktive regler) | Bestått |
| STEK-653 | Forklaring når en regel ikke kan deaktiveres | R1-58, R1-59, R1-60 («Regelen er standard for opptaket og kan ikke deaktiveres eller slettes», og tilsvarende for regel knyttet til studiealternativ) | Bestått |
| STEK-655 | Nytt søknadsalternativ som overskrev saken | END-124, END-125, END-129, END-130, END-131 | Bestått |
| STEK-656 | Nytt søknadsalternativ følger fordelingen søknaden har | END-128, END-129, END-130 | Bestått |
| STEK-658 | Opptaksforvalteren ved HK-dir kan overstyre og flytte etter fristen | END-140 (ikke bundet av fristen), END-142 og END-143 («Flytt saken») | Bestått |

Koblingen mellom sakene og testcasene er lest av titlene på rettingene i testplanen. Testansvarlig bekrefter den.

## Regler uten scenario

Fra «Regler uten scenario» i [omfang.md](omfang.md) (29 regler i koden, fra verify-rapporten 2026-11-04 13:17). Av dem tok testplanen 24 med i fase 2 og 5 ikke (uklart om ønsket).

| Utfall i kjøringen | Antall |
|---|---|
| Testet (bestått eller ikke bestått) | 11 |
| Delvis testet | 3 |
| Ikke testet, med begrunnelse | 2 |
| Planlagt i fase 2, men uten testcase i kjøringen | 8 |
| Ikke planlagt i fase 2 (uklart om ønsket) | 5 |

| Krav | Regel i koden | Funnet i | Testet i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-BEH-BEH-011` | Kode: 1–40 tegn, store bokstaver, tall og `_:,.-+`, unik i opptaket, påkrevd, kan ikke endres etter opprettelse | `fs-plattform/…/V395__behandlertildelingsregel_per_opptak.sql:71`; `fs-admin/…/BehandlertildelingsregelEditor.tsx:352` | ja: R1-63 til R1-70 (7 bestått, 1 ikke bestått: F12) | nei |
| `@OPT-BEH-BEH-011` | Navn er påkrevd, maks 100 tegn | `fs-admin/…/BehandlertildelingsregelEditor.tsx:284-286` | ja: R1-71 til R1-74 (3 bestått, 1 ikke bestått: F13) | nei |
| `@OPT-BEH-BEH-011` | Fordelingen («Hvem skal saksbehandle?») er påkrevd, nøyaktig én av fire | `fs-admin/…/BehandlertildelingsregelEditor.tsx:286` | ja: R1-75 (bestått) | nei |
| `@OPT-BEH-BEH-011` | Ny regel er aktiv som standard | `fs-plattform/…/BehandlertildelingsregelMutations.java:51` | ja: R1-76 (bestått) | nei |
| `@OPT-BEH-BEH-011` | Standardregelen må være aktiv; lista over valg viser bare aktive regler | `fs-plattform/…/OpprettOpptakMutations.java:418-422`; `fs-admin/…/BehandlertildelingsregelStandard.tsx:37` | ja: R1-77 (bestått) | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | API-et lar standardregelen settes til ingen; tildelingen stopper da | `fs-plattform/…/OpprettOpptakMutations.java:395-398`; `fs-plattform/…/BehandlertildelingService.java:95-98` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Utdanningstilbud kan ikke velge en inaktiv regel eller en regel fra et annet opptak | `fs-plattform/…/UtdanningstilbudMutations.java:361-385` | ja: R1-80 (bestått) | nei |
| `@OPT-BEH-BEH-011` | Høyst ett unntak per utdanningsbakgrunn; realkompetanse og dispensasjon kan ikke ha unntak (vises deaktivert med forklaring) | `fs-plattform/…/BehandlertildelingsregelMutations.java:171-190`; `fs-admin/…/BehandlertildelingsregelUnntak.tsx:107-120` | ja: FOR-91 til FOR-93 (bestått) | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | Organisasjonen i unntak for utdanningsbakgrunn trenger ikke delta i opptaket; tom organisasjon betyr tilbyderen | `fs-plattform/…/BehandlertildelingsregelMutations.java:197-199`; `fs-admin/…/BehandlertildelingsregelUnntak.tsx:80-90` | nei: uklart om ønsket, avklares først (se F-FOR-2) | avklares først |
| `@OPT-BEH-BEH-011` | Organisasjon for sektoren er valgfri (tom betyr tilbyderen søkeren har prioritert høyest) og gjelder bare «Tilbydere i samme sektor» | `fs-admin/…/convertDataToInput.ts:41-47` | ja: R1-81 (bestått) | nei |
| `@OPT-BEH-BEH-011` | Unntak for lærested: begge kolonner er påkrevd, og lærestedet kan ikke saksbehandle på vegne av seg selv | `fs-admin/…/BehandlertildelingsregelPaVegneAv.tsx:46-47,126-135`; `fs-plattform/…/V478__behandlertildelingsregel_pa_vegne_av.sql:31-32` | ja: FOR-103 til FOR-105 (bestått) | nei |
| `@OPT-BEH-BEH-011` | «Legg til unntak» for lærested er skjult når opptaket ikke har deltakere, og deaktivert når alle deltakerne er brukt | `fs-admin/…/BehandlertildelingsregelPaVegneAv.tsx:136-138,289-309` | delvis: FOR-106 (bestått, deaktivert når alle er brukt). «Skjult uten deltakere» er ikke prøvd, testopptaket har deltakere | nei |
| `@OPT-BEH-BEH-011` | Regelen kan ikke lagres (heller ikke en endring av navnet på en inaktiv regel) mens en organisasjon i unntaket for lærested eller sektoren ikke deltar i opptaket | `fs-plattform/…/BehandlertildelingsregelMutations.java:86-87,113-127` | delvis: FOR-98 og FOR-99 (bestått, organisasjon som ikke deltar finnes ikke blant valgene). Lagring mens en organisasjon tas ut av opptaket er ikke prøvd (FOR-107, flyttet til fase 3) | nei |
| `@OPT-BEH-BEH-011` | Bare én aktiv regel med «Alle som deltar i opptaket» gjelder også når en inaktiv regel aktiveres | `fs-plattform/…/V395__behandlertildelingsregel_per_opptak.sql:88-90` | ja: R1-55 og R1-78 (bestått) | nei |
| `@OPT-BEH-BEH-011` | Et opptak kan bare gjøres lokalt når det ikke har deltakere eller andre regler enn standardregelen | `fs-plattform/…/OpprettOpptakMutations.java:329-346` | nei: ingen testcase i kjøringen | nei |
| `@OPT-BEH-BEH-011` | Fordelingen er asynkron (hendelsesjobben), og venter når opptaket mangler standardregel | `fs-plattform/…/SoknadshendelseJobb.java:287-313` | nei: ingen testcase i kjøringen | nei |
| `@OPT-BEH-BEH-011` | Tom sak blir inaktiv (slettes ikke) og vises ikke i «Saker i opptak»; den aktiveres igjen når den får et alternativ | `fs-plattform/…/BehandlertildelingService.java:554-602`; `fs-plattform/…/sak.graphqls:2-8` | delvis: END-143 viser at saken hos UiO ikke lenger vises etter flytting. At saken aktiveres igjen er ikke prøvd | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | Saksnummeret er `søknadsnummer-løpenummer`, og løpenummeret fortsetter fra det høyeste | `fs-plattform/…/BehandlertildelingService.java:441-468,604-616` | nei: ingen testcase i kjøringen | nei |
| `@OPT-BEH-BEH-011` | Ved flytting blir grunnlag, poeng og kvote igjen i den gamle saken; flyttes alternativet tilbake, kan de gamle radene dukke opp igjen | `fs-plattform/…/BehandlertildelingService.java:375-378,411-427` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Mottakerens eksisterende sak for søknaden gjenbrukes uten å nullstille status eller innhold | `fs-plattform/…/BehandlertildelingService.java:445-457` | nei: ingen testcase i kjøringen | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | Tildelt saksbehandler blir stående på den gamle saken; den nye saken har ingen | `fs-plattform/…/BehandlertildelingService.java:458-465` | nei: ingen testcase i kjøringen | nei |
| `@OPT-BEH-BEH-011` | Saksbehandlerens overstyring lagres alltid, men flytter bare når den gjelder i tildelingen; opptaksforvalteren kan da velge «Flytt saken» | `fs-plattform/…/UtdanningsbakgrunnOverstyringService.java:44-76,109-124`; `fs-admin/…/UtdanningsbakgrunnCard.tsx:227-247` | ja: END-139, END-142 og END-143 (bestått) | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | Saksbehandleren kan ikke fjerne eller endre en overstyring opptaksforvalteren har gjort | `fs-plattform/…/UtdanningsbakgrunnOverstyringService.java:126-149` | nei: ingen testcase i kjøringen | nei |
| `@OPT-BEH-BEH-011` | Fristen kan ikke omgås ved å endre søknaden på vegne av søkeren | `fs-plattform/…/OppdaterSoknadISoknadsbehandlingService.java:150-176` | ikke testet: END-144 (F-END-1) | nei |
| `@OPT-BEH-BEH-011` | Er fristen ikke satt, regnes den som gått ut for saksbehandleren | `fs-plattform/…/Utdanningsbakgrunnsfrist.java:35-37` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Søkeren ser opptakets organisasjon som kontakt når søknadsalternativet ikke er fordelt ennå | `min-kompetanse/…/group-by-saksbehandler.ts:26-28` | ikke testet: INN-157 (F1, F-INN-3) | nei |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon ser de interne merknadene hos alle organisasjonene i opptaket, også etter flytting | `fs-plattform/…/V493__tilbyder_ser_saksbehandlingen.sql:69-87` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Tilbyderen ser praksisperiodene i saken | `fs-plattform/…/V501__tilbyderoppslag_per_sak.sql:75-90` | nei: ingen testcase i kjøringen | nei |
| `@OPT-BEH-BEH-011` | Tilbyderen ser bare sakene der den har et søknadsalternativ, ikke de andre sakene i søknaden | `fs-plattform/…/V501__tilbyderoppslag_per_sak.sql:22-35` | nei: ingen testcase i kjøringen. FLY-149 viste at tilbyderen ser bare sine egne søknadsalternativer i saken, men ikke at andre saker i søknaden er skjult | nei |

## Testdata og bevis

| Felt | Innhold |
|---|---|
| Testdata | Reglene (12), unntakene og søknadene (32, 91-1004368 til 91-1004399) ble laget av oppsettet gjennom løsningen. I første forsøk bestod 2 av 7 nøkler. Fire søknader fikk feil fordeling fordi ledige studieplasser var åpne (F9), og de ble laget på nytt etter at fristen ble satt tilbake. `soknad-visning` ble ikke laget fordi Min kompetanse ikke tar imot studieønsker (F1). Det manglet: tilbudsgarantityper (forutsetning 10 i testplanen), søkerinnlogging i Min kompetanse (forutsetning 12 og 13), og HK-dir-personaer med tilgang til «Opprett søknad» (F6). UiO-saksbehandleren opprettet søknadene i stedet |
| Kan kjøres på nytt | Ja, med forbehold. Oppsettet er rettet etter F2, F3, F5, F9 og F10. Søknadene er ikke slettet, og den interne merknaden fra UiO ligger igjen (F-INN-5). Tilstanden etter kjøringen står i `resultat.md` (standardregelen ORD, «Endre utdanningsbakgrunn» 04.12.2026 23:59, ledige studieplasser åpner 02.12.2026) |
| Bevis | `akseptansetest/opptak-saksbehandlertildeling-v2/kjoring-2026-11-04-1510/` (`resultat.md` er i git, skjermbilder er lokale og ikke i git) |

## Ikke bestått

| Nr | Scenario | Faktisk resultat | Funn |
|---|---|---|---|
| R1-70 | «Kode» kan ikke endres etter opprettelse (utledet) | «Kode» er en redigerbar tekstboks på en lagret regel for HK-dir-forvalteren. NTNU-personaen ser «Lesevisning» | F12 |
| R1-74 | «Navn» med 101 tegn (utledet) | Lagret uten feilmelding. Testansvarlig har bestemt at tekniske begrensninger holdes utenfor kravet, så dette er en observasjon. Testansvarlig avgjør om statusen står | F13 |
| FOR-120 | Ledig studieplass går foran unntak for utdanningsbakgrunn | Biovitenskap fikk HK-dir (unntaket), datafag fikk UiT (ledig studieplass, som kravet sier). Biovitenskap tilbyr trolig ikke ledige studieplasser, så dette ser ut til å være testdata og ikke en feil i løsningen. Testansvarlig vurderer statusen | F-FOR-1 |
| INN-154 | Saksbehandleren ser bare saken hos organisasjonen sin | UiO-saksbehandleren ser to saker: UiOs og HK-dirs, fordi UiO er tilbyder av «Informatikk: design, bruk, interaksjon». Resten av scenarioet stemmer | F-INN-1 |
| INN-161 | Tilbyderen kan ikke endre saksbehandlingen | UiT ser ikke merknaden, og «Grunnlag» og «Poeng» er i lesemodus. Men UiT ser «Endre søknad», «Endre utdanningsbakgrunn», «Skriv ny merknad», «Start automatisk behandling» og overskriften «Dokumenter» | F-INN-2 |

## Bestått, men faktisk resultat avviker

Testcaser med status «Bestått» der «Faktisk resultat» beskriver noe annet enn forventet resultat. Testansvarlig ser på dem og avgjør status. Skillen endrer ikke statusen.

| Nr | Scenario | Forventet resultat | Faktisk resultat |
|---|---|---|---|
| R1-66 | «Kode» med 41 tegn | Melding som sier hva som er galt (eller at en generell melding er nok) | «Regelen er ugyldig», uten å si at det er lengden (F14) |
| R1-67 | «Kode» med ugyldig tegn | Som over | «Regelen er ugyldig», uten å si at det er tegnet (F14) |
| FOR-84 | Tilbyderen saksbehandler ikke søkerens andre søknadsalternativer | To rader i «Saker i opptak» (kommentaren i testen) | Fire saker (NTNU, UiT, HK-dir, UiO), fordi søknaden har fem studieønsker hos fire organisasjoner. Resultatet i saken stemmer (F-FOR-4) |
| FOR-105 | Lærestedet kan ikke saksbehandle på vegne av seg selv | Valget er deaktivert | Valget er borte fra lista (F-FOR-5) |
| FOR-110 | Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet | Fagskoler i et annet opptak | Testet i testopptaket med standardregelen byttet til «ISO», og så satt tilbake til «Ordinær tildeling» |
| FOR-122 | Unntaket for lærested gjelder også når søkeren søker ledig studieplass | Unntaket gjelder ved ledig studieplass | Kan ikke skilles fra vanlig fordeling etter regelen, fordi det ikke vises om tilbudet tilbyr ledige studieplasser |
| END-128 | Ny prioritering endrer ikke saksbehandlende organisasjon | Knappen «Endre prioritering» | Knappene «Prioritering opp» og «Prioritering ned» i «Endre søknad» (F-END-3) |
| END-136 | Saksbehandleren endrer utdanningsbakgrunnen til Realkompetanse | Valget og bekreftelse | En bekreftelsesdialog («Endre utdanningsbakgrunn til Realkompetanse?») som testen ikke nevner (F-END-3) |
| END-139 | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen har gått ut | Fristen settes med ett forsøk | To første forsøk sa «Lagring vellykket» uten å lagre (F-END-5) |
| END-142 | Organisasjonen søknadsalternativet flyttes til, får en ubehandlet sak | Status «Ubehandlet» | Status «Ikke behandlet» (F-END-3) |
| INN-159 | Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler | Tilbyderen ser det UiO har saksbehandlet | UiO hadde ikke saksbehandlet, så bare standardverdiene ble sett (ikke kvalifisert, tom poengtabell) |
| FLY-148 | Saksbehandleren ved den saksbehandlende organisasjonen ser saken | UiO ser saken hos UiO | UiO ser også HK-dirs sak (F-INN-1) |

## Ikke testet

Testansvarlig vurderer begrunnelsene før intern test. Alle er kandidater til «Det den agentiske testen ikke klarte» i fase 3.

| Nr | Scenario | Begrunnelse |
|---|---|---|
| FOR-107 | Organisasjon i et unntak for lærested kan ikke tas ut av opptaket | Flyttet til fase 3. Et mislykket forsøk tar en deltaker ut av testopptaket |
| END-132 | Søkeren bytter til utenlandsk utdanningsbakgrunn | «Endre søknad» på vegne av søkeren har ikke valg for utdanningsbakgrunn, og søkeren kan ikke logge inn (F-END-1, F1) |
| END-133 | Søkeren bytter til realkompetanse | Samme (F-END-1) |
| END-134 | Bytte fra Realkompetanse til norsk utdanningsbakgrunn flytter ingen søknadsalternativer | Samme (F-END-1) |
| END-135 | Bytte fra Utenlandsk videregående skole til norsk utdanningsbakgrunn flytter ingen søknadsalternativer | Samme (F-END-1) |
| END-141 | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til (3 eksempler) | Tilbudsgarantityper finnes ikke i opptaket (F-END-4) |
| END-144 | Endring av søknaden på vegne av søkeren omgår ikke fristen (utledet) | «Endre søknad» har ikke valg for utdanningsbakgrunn (F-END-1) |
| FLY-149 | Tilbyderen kan sette tilbudsgaranti på søknadsalternativet som en annen organisasjon saksbehandler | Tilbudsgarantityper finnes ikke (F-INN-4) |
| INN-155 | Søkeren ser saksbehandlende organisasjon, men ikke sakene | `soknad-visning` finnes ikke, og Min kompetanse gir «Feilkode: 99» (F1, F-INN-3) |
| INN-157 | Søkeren ser opptakets organisasjon som kontakt før søknadsalternativet er fordelt (utledet) | Samme (F1, F-INN-3) |
| INN-160 | Tilbyderen setter tilbudsgaranti | Tilbudsgarantityper finnes ikke, og feltene er ren tekst for tilbyderen (F-INN-4) |

## Funn

Sortert etter alvorlighetsgrad. Alvorlighetsgraden er foreslått, og testansvarlig bestemmer. Ingen funn er foreslått som «Stopper»: ingen funn viser at systemet stopper eller har alvorlige konsekvenser i testmiljøet. Unntaket er F1 og F-INN-3, som kan bli «Stopper» hvis feilen også finnes i produksjon. Ingen funn har sak ennå.

| # | Fase funnet | Testcase | Type | Hva skjedde | Alvorlighetsgrad | Sak | Oppfølging |
|---|---|---|---|---|---|---|---|
| F-END-5 | 2 | END-139, oppsett av fristen | Feil | «Lagre» under «Rediger opptak» sa «Lagring vellykket» uten at fristen ble endret, to ganger (kontrollert etter ny innlasting). Tredje gang tok den, etter at feltet mistet fokus. Samme ved tilbakestilling. Samme feil som STEK-659 fra runde 1, som er lukket som Won't Do | Må fikses før innføring: meldingen sier at det er lagret, og feilen er stille. Midlertidig løsning: la feltet miste fokus og kontroller etter ny innlasting | – | Feil i løsningen: teamet lager oppgave. Testansvarlig vurderer STEK-659 på nytt |
| F-INN-2 | 2 | INN-161 | Feil | UiT (tilbyder) ser «Endre søknad», «Endre utdanningsbakgrunn», «Skriv ny merknad» og «Start automatisk behandling» i UiOs sak, og overskriften «Dokumenter». «Merk som behandlet» er deaktivert. Knappene er ikke trykket, så det er ikke kontrollert om de virker | Må fikses før innføring: kravet sier at tilbyderen ikke kan endre saksbehandlingen. Avvises lagringen (som for utdanningsbakgrunn, se «Kjente begrensninger» i testplanen), kan det være «Kan fikses senere». Virker knappene, vurder «Stopper» | – | Feil i løsningen: teamet lager oppgave og sier om knappene virker |
| F1 og F-INN-3 | 2 | oppsett `soknad-visning`, INN-155, INN-157 | Feil (årsak ikke avklart: Min kompetanse eller testmiljøet) | «Legg til» i Min kompetanse legger ikke studiet i kurven (`studieKurvLeggTilUtdanningstilbudV2` svarer `studiekurv: null` uten `errors`). «Finn studier» viser «Det oppsto en feil.» med «Feilkode: 99», også etter to innlastinger. Søkeren kan ikke legge inn studieønsker | Må fikses før innføring. Finnes feilen i produksjon, vurder «Stopper» | – | Feil i løsningen, eller utenfor testen hvis det er testmiljøet: teamet avklarer. Søkerens visning (MR !994) testes i fase 3 når det virker |
| F-INN-1 | 2 | INN-154, FLY-148 | Kravet dekker ikke | UiO-saksbehandleren ser to saker for søknaden: UiOs egen og HK-dirs sak, fordi UiO er tilbyder av «Informatikk: design, bruk, interaksjon». Scenarioet «Saksbehandleren ser bare saken hos organisasjonen sin» forventer én. Regelen «Tilbyderen ser saksbehandlingen …» sier at tilbyderen ser saken. Spørsmål: gjelder «ser bare saken hos organisasjonen sin» også når organisasjonen er tilbyder i en annen organisasjons sak, eller er tilbyderens innsyn et unntak? | Kan fikses senere | – | `fs-krav` med spørsmålet. Testansvarlig avgjør om det følges opp |
| F4 | 2 | oppsett av fristen | Feil | «Lagre» er deaktivert for «Endre utdanningsbakgrunn» når «Automatisk saksbehandling starter» og «avsluttes» er tomme. Lagring virker når de er fylt ut. Fristen hører til `@OPT-OVO-FRI-001`, ikke til kravet i denne testen | Kan fikses senere: midlertidig løsning er å fylle ut datoene | – | Feil i løsningen: teamet lager oppgave, eller `fs-krav` på `@OPT-OVO-FRI-001` hvis feltene skal henge sammen. Testansvarlig avgjør |
| F12 | 2 | R1-70 | Feil | HK-dir-forvalteren kan skrive i «Kode» på en lagret regel (ikke lagret). NTNU-personaen ser «Lesevisning». Regelen «Kode kan ikke endres etter opprettelse» står i koden, ikke i kravet | Kan fikses senere | – | Feil i løsningen: teamet lager oppgave |
| F13 | 2 | R1-74 | Observasjon | «Navn» med 101 tegn lagres uten feilmelding. Grensen på 100 tegn står i koden, kravet nevner ingen lengde. Testansvarlig har bestemt at tekniske begrensninger holdes utenfor kravet, så det er ikke «Kravet dekker ikke» | Kan fikses senere | – | Teamet vurderer |
| F14 | 2 | R1-66, R1-67 | Observasjon | «Kode» med 41 tegn eller ugyldig tegn gir bare «Regelen er ugyldig», uten å si hva som er galt | Kan fikses senere | – | Teamet vurderer |
| F-FOR-2 | 2 | FOR-85 | Observasjon | «Fordeles til» i unntak for utdanningsbakgrunn viser alle organisasjoner i registeret (rundt 80). «Saksbehandles av», «På vegne av» og «Velg organisasjon» viser bare deltakerne. Kravet sier ikke hvilke organisasjoner «Fordeles til» skal tilby | Kan fikses senere | – | Testansvarlig avgjør om det skal til `fs-krav` |
| F-FOR-3 | 2 | oppretting av søknad i FOR | Observasjon | Fjernes en rad under «Prioriterte utdanningstilbud», står prioriteringen igjen som «1» på begge radene til siden lastes på nytt (søknaden fikk riktig rekkefølge). Utenfor kravet | Kan fikses senere | – | Utenfor testen: teamet vurderer |
| F-END-2 | 2 | END (Endre søknad) | Observasjon | «Endre søknad» viser «Nasjonalitet» og «ID-type» som «Ikke utfylt» og ID-nummer tomt for søknader opprettet med «Opprett søknad». Fødselsdato vises én dag tidligere (31.12.1989 for 01.01.1990). Utenfor kravet | Kan fikses senere | – | Utenfor testen: teamet vurderer |
| F-STD-1 | 2 | STD-145 | Observasjon | «Opprett søknad» ga «Du mangler felter i personopplysninger som må fylles ut», uten å si hvilke. Gikk gjennom etter at «Nasjonalitet» og «Land» ble valgt i lista med tastaturet. Ikke sikkert hva som manglet | Kan fikses senere | – | Utenfor testen: teamet vurderer |
| F6, F8 og F11 | 2 | oppsett (søknadene) | Testmiljø | HK-dir-personaene (forvalter og saksbehandler) får «Krever MODIFISERE_SØKNADSBEHANDLING i opptakets organisasjon» ved «Opprett søknad». Rollen følger med i headerne for organisasjon 20827, så opptaket hører trolig til en annen organisasjon. UiO-saksbehandleren fikk opprettet søknadene | – | – | Utenfor testen: teamet retter personaene eller opptaket, og miljøfila |
| F7 | 2 | oppsett | Testmiljø | «Overstyrt bruker» gikk tilbake til «ANSVARSFULL FOTKREM • BRUKERADMINISTRATOR (Sikt testhøyskole)» etter navigasjon til en ny URL | – | – | Utenfor testen: teamet vurderer |
| F-INN-4 og F-END-4 | 2 | INN-160, END-141, FLY-149 | Testdata | Tilbudsgarantityper finnes ikke i opptaket (forutsetning 10 i testplanen). Tilbyderen ser de tre feltene som tekst «Ikke valgt». Tre scenarioer er «Ikke testet» | – | – | Teamet legger inn typene, og scenarioene testes i fase 3 |
| F-FOR-1 | 2 | FOR-120 | Testdata | Biovitenskap (`tilbud-saksbehandlende-tilbyder`) tilbyr trolig ikke ledige studieplasser, selv om miljøfila sier det. Datafag, som tilbyr, fikk UiT som kravet sier | – | – | Testcasen var feil: bruk datafag, eller finn et tilbud som tilbyr ledige studieplasser. Testansvarlig vurderer statusen |
| F-INN-5 | 2 | INN-161 | Testdata | Den interne merknaden fra UiO ligger igjen i saken til 91-1004373. «Slett» ble ikke sett | – | – | Utenfor testen |
| F9 | 2 | oppsett `soknad-norsk` m.fl. | Forklart, ikke en feil | «Informatikk, datafag - bachelor» fikk B-rolle UiT i de første søknadene. Søknadene ble laget mens ledige studieplasser var åpne (04.11.2026 15:00), og datafag tilbyr ledige studieplasser, så tilbyderen saksbehandlet, som kravet sier. Bekreftet med nye søknader etter at fristen ble satt tilbake | – | – | Testcasen var feil: oppsettet må si at ledige studieplasser er stengt når søknadene lages |
| F2, F3, F5 og F10 | 2 | oppsett | Testcasen var feil | Oppsettet stemmer ikke med skjermene: stegene i Min kompetanse (F2), navn med tall og telefon uten landskode avvises (F3), «Saksbehandlertildelingsregler» heter «Behandlertildelingsregler» (F5), og e-post må være unik per søker (F10) | – | – | Læring. Oppsettet er rettet |
| F-END-1 | 2 | END-132 til END-135, END-144 | Testcasen var feil | «Endre søknad» på vegne av søkeren har ikke valg for utdanningsbakgrunn, og søkeren kan ikke logge inn (F1). Overstyring i saken er saksbehandlerens handling, ikke søkerens | – | – | Testene følger skjermene, eller flyttes til søkeren i Min kompetanse (fase 3) |
| F-END-3, F-FOR-4 og F-FOR-5 | 2 | END, FOR-84, FOR-105 | Testcasen var feil | Stegene og ordene i testene stemmer ikke med skjermene: knapper, «Ikke behandlet», bekreftelsesdialogen ved overstyring, antall saker og «deaktivert» mot «ikke valgbar» | – | – | Læring: rett testene |

## Neste steg

Inngangskriteriet er ikke oppfylt ennå, fordi testansvarlig ikke har gått gjennom rapporten. Testansvarlig går gjennom rapporten, funnene og stikkprøven av de beståtte, og avgjør statusen på R1-74 og FOR-120 og alvorlighetsgradene. Når det er gjort og ingen funn er «Stopper», går leveransen videre til `fs-testcaser-intern` (testcasene for fase 3), med de 11 «ikke testet» som første del. F-INN-1 går til `fs-krav` med spørsmålet hvis testansvarlig vil følge det opp. F-END-5, F-INN-2 og F1 med F-INN-3 går til teamet for oppgaver. Oppdateringen av «Status i flyten» i testplanen og publiseringen i Confluence er ikke gjort.

## Læring

Fylles ut etter det korte møtet mellom testerne og teamlederne.

- Hvilke feil burde vært fanget tidligere? [Fylles ut etter møtet]
- Hva bør endres i testprosessen? [Fylles ut etter møtet]
- Testcaser som var feil eller uklare: oppsettet (F2, F3, F5, F9, F10), at «Endre søknad» på vegne av søkeren ikke kan bytte utdanningsbakgrunn (F-END-1), ord og steg som ikke stemmer med skjermen (F-END-3, F-FOR-4, F-FOR-5), og tilbudet «Biovitenskap» som ikke tilbyr ledige studieplasser (F-FOR-1)
- Regler uten scenario som burde vært i kravet (`fs-krav`, fra omfang.md): standardregelen må være aktiv, høyst ett unntak per utdanningsbakgrunn, tom sak blir inaktiv, mottakerens eksisterende sak gjenbrukes, og saksbehandlerens overstyring lagres alltid. Av dem er de to første og den siste testet, den tredje delvis og den fjerde ikke
- Åtte regler uten scenario som testplanen la til fase 2, har ingen testcase i `cdp-tester/`: lokale opptak, asynkron fordeling, saksnummer, mottakerens sak, tildelt saksbehandler, saksbehandlerens overstyring etter forvalterens, fristen omgås ikke, praksisperioder og tilbyderens innsyn i andre saker. Teamet og testansvarlig avgjør om testcasene skal lages
