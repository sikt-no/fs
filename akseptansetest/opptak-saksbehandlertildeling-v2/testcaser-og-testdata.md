# Testcaser og testdata – Saksbehandlertildeling, runde 2

- **Testplan**: [testplan.md](testplan.md) · Confluence: ikke opprettet ennå
- **Confluence**: –
- **Laget**: 2026-11-04 av fs-testplan

---

Testcasene som skal lages, testbrukerne og testdataene for «Saksbehandlertildeling, runde 2». Siden synkes med testene i `cdp-tester/` og miljøfila (*Synk med testene og miljøfila* i `fs-testplan`). Testplanen: [Testplan – Saksbehandlertildeling, runde 2](testplan.md).

## Testcaser som skal lages

Omfanget av testcasene, ikke testcasene selv. `fs-testcaser-cdp` lager testcasene for fase 2 ut fra tabellen, og `fs-testcaser-intern` testcasene for fase 3. Teamet og testansvarlig går gjennom omfanget før testcasene lages.

### Fase 2: agentisk funksjonstest

Alt skjer i det felles testopptaket `opptak-samordna-saksbehandlertildeling`, og ingenting utenfor det opptaket endres. Utdanningstilbudene i eksemplene i kravene byttes med utdanningstilbudene i opptaket. Rekkefølge og isolasjon:

- Oppsettet lager reglene, unntakene og søknadene i opptaket i hver kjøring. Søknadene sendes inn av søkeren (testbruker 6) i Min kompetanse, og testansvarlig logger inn når agenten trenger søkeren.
- Unntak for lærested legges på en egen regel (for eksempel «UVH» på ett utdanningstilbud), aldri på standardregelen «ORD». OsloMet og Arkitektur- og designhøgskolen i Oslo deltar ikke i testopptaket, så unntaket settes opp med deltakerne i opptaket: «UiT saksbehandler på vegne av HVL», og et par til av deltakerne. Testene av unntak for lærested kjøres etter de vanlige fordelingstestene.
- Scenarioene som bytter standardregelen kjøres sist, og setter standardregelen tilbake til «ORD».
- Scenarioet «Organisasjon i et unntak for lærested kan ikke tas ut av opptaket» prøves ikke i fase 2. Det ville ført til at en deltaker tas ut av testopptaket, og feiler valideringen, er opptaket ødelagt for resten av testene. Scenarioet er flyttet til fase 3 som kandidat til høyest risiko.
- Tre scenarioer trenger noe utenfor testopptaket eller noe opptaket ikke har: «Nytt opptak får standard behandlertildelingsregel …» (et nytt opptak), «Behandlertildelingsreglene er ikke tilgjengelige i lokale opptak» (et lokalt opptak) og «Hver tilbyder saksbehandler sitt eget søknadsalternativ når standardregelen gjelder bare søknadsalternativet» (fagskoler i et annet opptak). Avklart 04.11.2026: agenten leser bare utenfor testopptaket, og endrer ingenting der. «Nytt opptak …» sjekkes i det nyeste samordna opptaket som finnes, og «… lokale opptak» i et lokalt opptak som finnes. Fagskolescenarioet testes i testopptaket ved å bytte standardregelen til «UVH» til slutt, med to av deltakerne, og så tilbake til «ORD».

| Krav | Regel | Scenarioer | Utledede testcaser | Teknikk |
|---|---|---|---|---|
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket | 10 (scenariomal: 2 eksempler) | Regelen deaktiveres og aktiveres igjen. Ny regel er aktiv som standard. Lista over valg for standardregelen viser bare aktive regler. Regel som søknader er tildelt etter får «Slett» (feiler ved lagring, se «Kjente begrensninger») | tilstandsoverganger (aktiv, inaktiv, standard, i bruk), ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Ved «Alle som deltar i opptaket» saksbehandler lærestedet søkeren har prioritert høyest | 2 | Søkerens prioritering byttes, og fordelingen skal ikke endres etterpå | beslutningstabell (regel × prioritering) |
| `@OPT-BEH-BEH-011` | Ved «Bare tilbyderen – også for studieønsker uten egen regel» saksbehandler tilbyderen også søknadsalternativene uten egen behandlertildelingsregel | 2 | Tilbyderen på første og på siste prioritet | beslutningstabell |
| `@OPT-BEH-BEH-011` | Ved «Bare tilbyderen – bare dette studieønsket» saksbehandler tilbyderen bare søknadsalternativet med behandlertildelingsregelen | 2 | Standardregelen byttet til «UVH» (se rekkefølge over) | beslutningstabell |
| `@OPT-BEH-BEH-011` | Ved «Tilbydere i samme sektor» saksbehandler én organisasjon alle søknadsalternativene i sektoren | 7 (scenariomal: 2 eksempler) | Organisasjon for sektoren tom og valgt. Organisasjon som ikke deltar i opptaket finnes ikke blant valgene | ekvivalensklasser, beslutningstabell |
| `@OPT-BEH-BEH-011` | Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen | 8 (scenariomal: 2 eksempler) | Én søker per utdanningsbakgrunn: «Utenlandsk», «Videregående steinerskole» (i FS Admin heter den ikke «Rudolf Steinerskole»), «Realkompetanse», «Dispensasjon» og norsk. Ledig studieplass med og uten unntak. Ugyldige unntak (to for samme bakgrunn, unntak for «Realkompetanse» eller «Dispensasjon») | beslutningstabell (utdanningsbakgrunn × regel × ledig studieplass), ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket | 8 (scenariomaler: 3 + 2 eksempler) | Unntaket for lærested på en egen regel («UVH»). Begge kolonnene, «Saksbehandles av» og «På vegne av», er påkrevd. Lærestedet kan ikke saksbehandle på vegne av seg selv. «Legg til unntak» er skjult uten deltakere og deaktivert når alle deltakerne er brukt. Organisasjon som ikke deltar i opptaket, finnes ikke blant valgene. Regelen kan ikke lagres mens en organisasjon i unntaket ikke deltar. Ett scenario flyttet til fase 3 (uttak av organisasjon) | ekvivalensklasser, beslutningstabell (rolle i unntaket × tilfelle), tilstandsoverganger |
| `@OPT-BEH-BEH-011` | Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast | 7 (scenariomal: 3 eksempler) | Fordelingen er asynkron: testen venter på tildelingsjobben (ca. hvert 30. sekund i runde 1) og sjekker at ingenting fordeles før. Saksnummer `søknadsnummer-løpenummer` | tilstandsoverganger (sendt, fordelt, endret), ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak | 9 (scenariomaler: 2 + 2 + 2 + 3 eksempler) | Fristen før, ved og etter. Saksbehandleren og opptaksforvalteren (HK-dir) etter fristen, med «Flytt saken». Saksbehandleren kan ikke fjerne en overstyring opptaksforvalteren har gjort. Fristen kan ikke omgås ved å endre søknaden på vegne av søkeren. Ny sak er ubehandlet, og mottakerens eksisterende sak gjenbrukes. Tilbudsgaranti ved flytting testes bare hvis tilbudsgarantityper finnes (se «Testdata») | grenseverdianalyse (fristen), tilstandsoverganger, beslutningstabell (rolle × frist) |
| `@OPT-BEH-BEH-011` | Saksbehandlende organisasjon ser bare saker hos organisasjonen | 3 | Saksbehandler ved UiO, ved HK-dir og ved en organisasjon uten sak. Søkeren ser organisasjonen i «Kontakt saksbehandler» (opptakets organisasjon før søknadsalternativet er fordelt) | beslutningstabell (rolle × organisasjon) |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket | 1 | – | – |
| `@OPT-BEH-BEH-011` | Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet | 3 | Tilbyderen ser saken i «Saker i opptak», bare sine egne søknadsalternativer, og praksisperiodene. Ser ikke dokumentene eller interne merknader. Setter tilbudsgaranti | beslutningstabell (rolle × organisasjon) |
| `@OPT-BEH-BEH-011` | Regel i koden: «Kode» er påkrevd, 1 til 40 tegn, store bokstaver, tall og tegnene `_:,.-+`, unik i opptaket, og kan ikke endres etter opprettelse | – | «Kode» tom, bare mellomrom, 40 og 41 tegn, små bokstaver, ugyldig tegn, duplikat og endring etter opprettelse | grenseverdianalyse, ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Regel i koden: «Navn» er påkrevd, høyst 100 tegn | – | «Navn» tom, bare mellomrom, 100 og 101 tegn | grenseverdianalyse |
| `@OPT-BEH-BEH-011` | Regel i koden: «Hvem skal saksbehandle?» er påkrevd, nøyaktig én av fire | – | Ingen valgt. Hver av de fire | ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Regel i koden: ny regel er aktiv som standard | – | Opprett uten å røre «Aktiv» | – |
| `@OPT-BEH-BEH-011` | Regel i koden: standardregelen må være aktiv, og lista viser bare aktive regler | – | Inaktiv regel finnes ikke blant valgene | ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Regel i koden: utdanningstilbud kan ikke velge en inaktiv regel eller en regel fra et annet opptak | – | Inaktiv regel avvises | ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Regel i koden: høyst ett unntak per utdanningsbakgrunn, og «Realkompetanse» og «Dispensasjon» kan ikke ha unntak | – | Forsøk på to unntak for samme bakgrunn. De to bakgrunnene vises deaktivert med forklaring | ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Regel i koden: organisasjon for sektoren er valgfri, og gjelder bare «Tilbydere i samme sektor» | – | Tom organisasjon, og organisasjon valgt på en regel med en annen fordeling | ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Regel i koden: unntak for lærested, begge kolonner er påkrevd, og lærestedet kan ikke saksbehandle på vegne av seg selv | – | Én kolonne tom. Samme organisasjon i begge | ekvivalensklasser |
| `@OPT-BEH-BEH-011` | Regel i koden: «Legg til unntak» for lærested er skjult uten deltakere og deaktivert når alle deltakerne er brukt | – | Alle deltakerne brukt (testopptaket har fire deltakere) | grenseverdianalyse |
| `@OPT-BEH-BEH-011` | Regel i koden: regelen kan ikke lagres mens en organisasjon i unntaket for lærested eller sektoren ikke deltar i opptaket | – | Se unntak for lærested over. Prøves uten å ta noen ut av opptaket, og ellers flyttet til fase 3 | – |
| `@OPT-BEH-BEH-011` | Regel i koden: bare én aktiv regel med «Alle som deltar i opptaket», også når en inaktiv regel aktiveres | – | Aktiver en inaktiv regel med «Alle som deltar i opptaket» | tilstandsoverganger |
| `@OPT-BEH-BEH-011` | Regel i koden: et opptak kan bare gjøres lokalt uten deltakere eller andre regler enn standardregelen | – | Ikke i testopptaket (se «Tre scenarioer …» over) | – |
| `@OPT-BEH-BEH-011` | Regel i koden: fordelingen er asynkron, og venter når opptaket mangler standardregel | – | Se rekkefølgen over: standardregelen fjernes ikke i testopptaket | – |
| `@OPT-BEH-BEH-011` | Regel i koden: tom sak blir inaktiv og vises ikke i «Saker i opptak», og aktiveres igjen når den får et alternativ | – | Søknadsalternativ flyttes bort fra saken, og tilbake | tilstandsoverganger |
| `@OPT-BEH-BEH-011` | Regel i koden: saksnummeret er `søknadsnummer-løpenummer`, og løpenummeret fortsetter fra det høyeste | – | Ny sak etter flytting | – |
| `@OPT-BEH-BEH-011` | Regel i koden: mottakerens eksisterende sak for søknaden gjenbrukes uten å nullstille status eller innhold | – | Flytt et søknadsalternativ til en organisasjon som har sak | tilstandsoverganger |
| `@OPT-BEH-BEH-011` | Regel i koden: tildelt saksbehandler blir stående på den gamle saken, og den nye saken har ingen | – | Sjekk begge sakene etter flytting | – |
| `@OPT-BEH-BEH-011` | Regel i koden: saksbehandlerens overstyring lagres alltid, men flytter bare når den gjelder i tildelingen. Opptaksforvalteren kan da velge «Flytt saken» | – | Overstyring etter fristen, og «Flytt saken» | tilstandsoverganger, beslutningstabell |
| `@OPT-BEH-BEH-011` | Regel i koden: saksbehandleren kan ikke fjerne eller endre en overstyring opptaksforvalteren har gjort | – | Saksbehandler prøver å endre | – |
| `@OPT-BEH-BEH-011` | Regel i koden: fristen kan ikke omgås ved å endre søknaden på vegne av søkeren | – | Saksbehandler endrer søknaden på vegne av søkeren etter fristen | grenseverdianalyse |
| `@OPT-BEH-BEH-011` | Regel i koden: søkeren ser opptakets organisasjon som kontakt når søknadsalternativet ikke er fordelt ennå | – | Søkeren ser «Kontakt saksbehandler» rett etter innsending, før tildelingsjobben har kjørt | – |
| `@OPT-BEH-BEH-011` | Regel i koden: tilbyderen ser praksisperiodene i saken | – | Se «Tilbyderen ser saksbehandlingen …» over | – |
| `@OPT-BEH-BEH-011` | Regel i koden: tilbyderen ser bare sakene der den har et søknadsalternativ, ikke de andre sakene i søknaden | – | Se «Tilbyderen ser saksbehandlingen …» over | – |

Testcasene står i `cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/` (lenke når de er laget). Fem regler i koden testes ikke i fase 2, fordi det er uklart om koden gjør det kravet ønsker: standardregelen uten verdi, organisasjon i unntak for utdanningsbakgrunn som ikke deltar, grunnlag og poeng som blir igjen i den gamle saken ved flytting, fristen som ikke er satt, og opptaksforvalterens innsyn i interne merknader etter flytting (se «Regler uten scenario» på [Omfang](omfang.md)). Utledede testcaser lages bare der regelen har verdier eller betingelser å teste.

### Fase 3: intern akseptansetest

| Flyt eller oppgave | Krav | Scenarioer i flyten | Avhengigheter som sjekkes | Regresjon |
|---|---|---|---|---|
| Flyten «Saksbehandlertildeling» (de to leverte fasene), med fordelingsreglene 2 til 5 i `@OPT-BEH-BEH-011` | `@FLY-OPT-SAK-001`, `@OPT-BEH-BEH-011` | 4 i flyten (fordelingsreglene har 13 scenarioer, testet i detalj i fase 2) | Tildelingsjobben (asynkron fordeling), tilbudsgarantien i `@OPT-BEH-BEH-010`, Min kompetanse (søkerens visning) | nei |
| Oppgaven «Sette opp behandlertildelingsreglene for opptaket, med unntak for lærested og utdanningsbakgrunn» | `@OPT-BEH-BEH-011` | Utvalg av 26 (oppsett 10, unntak for utdanningsbakgrunn og ledige studieplasser 8, unntak for lærested 8) | Regel per utdanningstilbud i `@OPT-OPT-UTD-004` (brukes som forutsetning) | nei |
| Oppgaven «Søknaden endres og flyttes» | `@OPT-BEH-BEH-011` | Utvalg av 16 (fordelingen ligger fast 7, flytting 9) | Fristen i `@OPT-OVO-FRI-001`, tildelingsjobben, tilbudsgarantien i `@OPT-BEH-BEH-010` | nei |
| Oppgaven «Innsyn: saksbehandler, tilbyder, opptaksforvalter og søker» | `@OPT-BEH-BEH-011` | Utvalg av 7 (ser bare saker 3, opptaksforvalteren ser alle 1, tilbyderen 3) | Min kompetanse (søkerens visning, MR !994) | nei |

Krav som ikke er med i noen flyt: 0. `@OPT-BEH-BEH-011` er med i flyten «Saksbehandlertildeling», og delene flyten ikke dekker, testes som de tre oppgavene over.

I tillegg til flytene har den interne testen tre deler (*Fase 3* i `akseptansetest/README.md`). Omfanget avgjøres når testcasene lages, etter kjøringen i fase 2:

| Del | Omfang | Hvem velger |
|---|---|---|
| Det den agentiske testen ikke klarte | Testcasene fra fase 2 som blir «Ikke testet». Kjent på forhånd: tilbudsgaranti ved flytting (tilbudsgarantityper er ikke bekreftet i testopptaket), ledig studieplass (ledige studieplasser er ikke bekreftet), og uttak av organisasjon i unntak for lærested. Søkerens visning i Min kompetanse, når testansvarlig ikke rekker å logge inn som søker under kjøringen | Kjøringen i fase 2 |
| Opplevelse og helhet | Skjermene for behandlertildelingsregler og unntak, saken og «Søknadsalternativer» i «Søknadsbehandling», og «Kontakt saksbehandler» hos søkeren: forståelig og brukbar, tekster og fagspråk (for eksempel «Saksbehandles av» og «På vegne av»), universell utforming | Testansvarlig |
| Høyest risiko | Kandidater: kodeavvikene under «Kjente begrensninger» (valget av utdanningsbakgrunn som tilbyderen får men ikke kan lagre, «Slett» på en regel søknader er tildelt etter, uttak av organisasjon i «Fordeles til»), tilbyderens innsyn, uttak av organisasjon i unntak for lærested, og de rettede funnene fra runde 1 (STEK-652, 653, 655, 656 og 658) | Testansvarlig, etter en risikovurdering |

## Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | ORDENTLIG RUNDSKRIV | Opptaksforvalter og saksbehandler (`OPPTAK_FORVALTER`, `OPPTAK_SAKSBEHANDLER`) | HK-dir | Reglene, unntak, frist, se alle sakene, flytte saken |
| 2 | ANSVARSFULL FOTKREM | Opptaksforvalter (`OPPTAK_FORVALTER`) | NTNU | Kan ikke endre reglene, velger regel på utdanningstilbud (sektor) |
| 3 | KORT DOMPAP | Saksbehandler (`OPPTAK_SAKSBEHANDLER`) | UiO | Ser bare sin sak, overstyrer utdanningsbakgrunn, legger til søknadsalternativ på vegne av søkeren |
| 4 | GRUNDIG PROTOKOLL | Saksbehandler (`OPPTAK_SAKSBEHANDLER`) | HK-dir | Ser bare saken hos HK-dir, får flyttede saker |
| 5 | KORT DOMPAP | Saksbehandler (`OPPTAK_SAKSBEHANDLER`) | UiT | Ser saken der UiO saksbehandler et UiT-tilbud, setter tilbudsgaranti, kan ikke endre |
| 6 | [Fylles ut: hvilken syntetisk testperson i ID-porten (Tenor)] | Søker | – | Sender inn og endrer søknaden i Min kompetanse. Testansvarlig logger inn når agenten trenger søkeren |

Testbruker 2 er opptaksforvalter ved NTNU, ikke ved UiO: miljøfila eier nøkkelen `opptak-forvalter-deltakende`, og NTNU er en av deltakerne i testopptaket.

Kolonnene `Nøkkel` (etter `Nr`), `Innlogging` og `Start-URL` (etter `Organisasjon`) er alltid med, fordi den agentiske funksjonstesten (fase 2) bruker dem. Fra [test.md](../../cdp-tester/_Miljøer/test.md), hentet 2026-11-04:

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | `opptak-forvalter-forvaltende` | ORDENTLIG RUNDSKRIV | `OPPTAK_FORVALTER`, `OPPTAK_SAKSBEHANDLER` | HK-dir | ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER_OG_OPPTAK_SAKSBEHANDLER (HK-dir) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjkx | Reglene, unntak, frist, se alle sakene, flytte saken |
| 2 | `opptak-forvalter-deltakende` | ANSVARSFULL FOTKREM | `OPPTAK_FORVALTER` | NTNU | ANSVARSFULL FOTKREM • OPPTAK_FORVALTER (NTNU) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjkx | Kan ikke endre reglene, velger regel på utdanningstilbud (sektor) |
| 3 | `opptak-saksbehandler-saksbehandlende` | KORT DOMPAP | `OPPTAK_SAKSBEHANDLER` | UiO | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UiO) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjkx | Ser bare sin sak, overstyrer utdanningsbakgrunn, legger til søknadsalternativ på vegne av søkeren |
| 4 | `opptak-saksbehandler-forvaltende` | GRUNDIG PROTOKOLL | `OPPTAK_SAKSBEHANDLER` | HK-dir | GRUNDIG PROTOKOLL • OPPTAK_SAKSBEHANDLER (HK-dir) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjkx | Ser bare saken hos HK-dir, får flyttede saker |
| 5 | `opptak-saksbehandler-tilbyder` | KORT DOMPAP | `OPPTAK_SAKSBEHANDLER` | UiT | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UiT) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjkx | Ser saken der UiO saksbehandler et UiT-tilbud, setter tilbudsgaranti, kan ikke endre |
| 6 | `soker` | [Fylles ut: hvilken testperson] | Søker | – | Testansvarlig logger inn i Min kompetanse (test) med ID-porten (testperson fra Tenor). Fødselsnummeret skrives ikke her | [Fylles ut: URL til Min kompetanse (test)] | Sender inn og endrer søknaden |

### Tilgangsmatrise

Fra tilgangsradene i verify-rapporten (2026-11-04 13:17). Den viser hvilke roller kravet har ved hvilke organisasjoner, og hvilken testbruker som dekker hver rad. Det lages ikke egne testcaser for roller og tilgang: tilgangene er verifisert i koden i fase 1.

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@OPT-BEH-BEH-011` | Opptaksforvalter ved forvaltende organisasjon | endrer reglene og unntakene, ser alle sakene, overstyrer utdanningsbakgrunn og flytter saken uten frist | – | 1 |
| `@OPT-BEH-BEH-011` | Opptaksforvalter ved deltakende lærested | ser reglene, kan ikke endre | ser reglene, kan ikke endre | 2 |
| `@OPT-BEH-BEH-011` | Saksbehandler ved saksbehandlende organisasjon | ser saken, endrer grunnlag og poeng, overstyrer utdanningsbakgrunn (bundet av fristen) | ingen tilgang til sakene | 3 |
| `@OPT-BEH-BEH-011` | Saksbehandler ved forvaltende organisasjon | ser bare saken hos forvaltende organisasjon | ingen tilgang til sakene hos andre | 4 |
| `@OPT-BEH-BEH-011` | Saksbehandler ved tilbyder | ser saken og egne søknadsalternativer, setter tilbudsgaranti, kan ikke endre | ingen tilgang når organisasjonen ikke har et søknadsalternativ i saken | 5 |
| `@OPT-BEH-BEH-011` | Søker | ser saksbehandlende organisasjon for hvert søknadsalternativ, ikke sakene | – | 6 |

## Testdata

Testdataene testene trenger, med nøkkel. Data i testmiljøet kan slettes eller nullstilles når som helst, så testene lager dataene sine selv: oppsettet (`cdp-tester/_Oppsett/`, lages av `fs-testcaser-cdp`) lager reglene, unntakene og søknadene gjennom løsningen i hver kjøring, med kjøringen i navnet. Bare opptaket og data testene ikke kan lage, må finnes i miljøet før testen, og navnet og `Søk/URL` for dem kopieres fra miljøfila: «Fra [test.md](../../cdp-tester/_Miljøer/test.md), hentet 2026-11-04». Testdata er syntetiske.

Alt skjer i opptaket `opptak-samordna-saksbehandlertildeling`. Ingenting utenfor det opptaket skal endres.

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| Samordna opptak | `opptak-samordna-saksbehandlertildeling` | «HÅK1 er KUL 2 - Saksbehandlertildeling» (`T3BwdGFrOjkx`) | FS Admin, TEST | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjkx | Samordna opptak forvaltet av HK-dir, med UiO, UiT, NTNU og HVL som deltakere, standardregelen «ORD» («Alle som deltar i opptaket»), «SPE» på Biovitenskap (UiO) og Praktiske musikkaktiviteter (HVL), «JOU» på Automatisering med robotikk (HVL), og «PAP» med unntak for «Utenlandsk» og «Videregående steinerskole» til HK-dir. Søknaden er åpen. Testene får endre alt i dette opptaket, men ingenting utenfor det. Oppsettet kan ikke lage opptaket, fordi søknadene må komme fra Min kompetanse. Sist sjekket 2026-10-30 | Alle regler i `@OPT-BEH-BEH-011` og de to fasene i `@FLY-OPT-SAK-001` |
| Behandlertildelingsregler og unntak (blant annet «UVH» på ett utdanningstilbud, unntak for lærested «UiT saksbehandler på vegne av HVL» på «UVH», og unntak for utdanningsbakgrunn) | `behandlertildelingsregler-i-opptaket` | Lages av oppsettet | I opptaket | «Behandlertildelingsregler» i opptaket | Reglene og unntakene finnes med kjøringen i navnet. Unntak for lærested ligger på en egen regel, aldri på «ORD» | Fase 2: regel 1 til 7 |
| Søknader fra søkeren | `soknader-i-opptaket` | Lages av oppsettet (søkeren sender inn i Min kompetanse) | Min kompetanse (test), «Søknadsbehandling» i FS Admin | «Saker i opptak» | Søknader med ulik rekkefølge på utdanningstilbudene og ulik utdanningsbakgrunn. Hver søknad testes for seg | Fase 2: regel 2 til 12 |
| Frist for endring av utdanningsbakgrunn | `frist-utdanningsbakgrunn` | Settes i testen | «Rediger opptak» → «Saksbehandling» → «Endre utdanningsbakgrunn» | «Rediger opptak» | Fristen kan flyttes til før eller etter testdagen. Sist sjekket 2026-11-04 | Regelen om flytting |
| Tilbudsgarantityper | `tilbudsgarantityper` | [Fylles ut av teamet: finnes tilbudsgarantityper i opptaket?] | Saken → «Søknadsalternativer» | Saken → «Søknadsalternativer» | Opptaket har tilbudsgarantityper. Typene settes per opptak, og bare en utvikler kan legge dem inn. 30.10 viste saken «Ingen tilgjengelige tilbudsgarantier». Sist sjekket 2026-10-30 | Tilbudsgaranti ved flytting, og tilbyderen som setter tilbudsgaranti |
| Ledige studieplasser | `ledige-studieplasser-apnet` | [Fylles ut av teamet: har ledige studieplasser åpnet i opptaket, og hvilket utdanningstilbud tilbyr dem?] | «Rediger opptak» | «Rediger opptak» | Ledige studieplasser har åpnet, og ett utdanningstilbud ved UiO tilbyr ledige studieplasser | Regelen om unntak og ledige studieplasser, og unntak for lærested ved ledig studieplass |

Data scenarioet selv lager (for eksempel «Opprett behandlertildelingsregel»), står ikke her: de lages av stegene i testcasen (R13 i `testcase-regler.md`).

Kolonnene `Søk/URL`, `Utgangstilstand` og `Brukes av` står bare i testplanen, ikke i testcasene for den interne og den eksterne testen.
