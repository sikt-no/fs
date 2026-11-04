# Omfang – Saksbehandlertildeling, runde 2

- **Testplan**: [testplan.md](testplan.md) · Confluence: [utkast](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5169872955/Omfang+Saksbehandlertildeling+runde+2 (utkast)
- **Laget**: 2026-11-04 av fs-testplan

---

Omfanget for «Saksbehandlertildeling, runde 2»: kravene og flytene som testes, og det som ikke er med. Kravene i «Omfang» er kriteriene for godkjent, og alle skillene i testflyten leser dem herfra. Testplanen: [Testplan – Saksbehandlertildeling, runde 2](testplan.md).

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Tildele saksbehandlende organisasjon](https://github.com/sikt-no/fs/blob/7d4ee5d1/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | `@OPT-BEH-BEH-011` | `@implemented` | 62 |

Kravet har 12 regler. En scenariomal teller som ett scenario:

| Regel | Scenarioer i testen |
|---|---|
| Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket | 10 |
| Ved «Alle som deltar i opptaket» saksbehandler lærestedet søkeren har prioritert høyest | 2 |
| Ved «Bare tilbyderen – også for studieønsker uten egen regel» saksbehandler tilbyderen også søknadsalternativene uten egen behandlertildelingsregel | 2 |
| Ved «Bare tilbyderen – bare dette studieønsket» saksbehandler tilbyderen bare søknadsalternativet med behandlertildelingsregelen | 2 |
| Ved «Tilbydere i samme sektor» saksbehandler én organisasjon alle søknadsalternativene i sektoren | 7 |
| Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen | 8 |
| Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket | 8 |
| Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast | 7 |
| Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak | 9 |
| Saksbehandlende organisasjon ser bare saker hos organisasjonen | 3 |
| Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket | 1 |
| Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet | 3 |
| Sum | 62 |

Kravet har ingen åpne spørsmål. I tillegg testes de fire scenarioene i de leverte fasene i flyten «Saksbehandlertildeling» (se «Flyter»). De har åpne spørsmål, som står under flytene.

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen.

De automatiske testene av de samme kravene: `npx playwright test --grep "@OPT-BEH-BEH-011|@FLY-OPT-SAK-001"`.

### Åpne spørsmål

`@openquestion` stopper ikke testen: delen er klar til implementasjon, og testes som den står. Tallene regnes fra kravfilene på commit `7d4ee5d1`, ikke fra verify-rapporten (flyten er endret etter rapporten, og fase 1 har ikke åpent spørsmål lenger).

| Krav | Feature-ID | Regler med åpent spørsmål | Scenarioer med åpent spørsmål | Scenarioer i testen |
|---|---|---|---|---|
| [Tildele saksbehandlende organisasjon](https://github.com/sikt-no/fs/blob/7d4ee5d1/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | `@OPT-BEH-BEH-011` | 0 av 12 | 0 av 62 | 62 |
| [Saksbehandlertildeling (flyt)](https://github.com/sikt-no/fs/blob/7d4ee5d1/krav/_Flyter/10%20Opptaksl%C3%B8pet/saksbehandlertildeling.feature) | `@FLY-OPT-SAK-001` | 1 av 2 faser i testen (2 av 5 i hele flyten) | 3 av 4 | 4 |

Åpent spørsmål: `@FLY-OPT-SAK-001` «Søknaden blir én sak hos hver saksbehandlende organisasjon»: Steget om at "Universitetet i Oslo" er saksbehandlende organisasjon for "Informatikk, UiO" og "Historie, UiT", og steget om "NTNU", gjentar fordelingsreglene i `@OPT-BEH-BEH-011`. Overleveringen er at regelen på utdanningstilbudet brukes når søknaden sendes inn, og at søknaden blir én sak per organisasjon. Holder det med de to siste stegene? Testes som det står, med «UVH».

Åpent spørsmål: `@FLY-OPT-SAK-001` regelen «Den saksbehandlende organisasjonen ser saken» (gjelder begge scenarioene i fasen): Scenarioet om tilbudsgaranti gjelder tilbyderen, ikke den saksbehandlende organisasjonen. Skal det flyttes til en egen fase («Tilbyderen setter tilbudsgaranti»), eller skal regeltittelen utvides? Testes som det står.

Åpent spørsmål: `@FLY-OPT-SAK-001` regelen «Den saksbehandlende organisasjonen ser saken»: Begge scenarioene står nesten ordrett i `@OPT-BEH-BEH-011` («Saksbehandleren ser bare saken hos organisasjonen sin» og «Tilbyderen setter tilbudsgaranti»). Hvilken overlevering skal fasen vise? Testes som det står.

Utenfor testen: regelen «Utdanningstilbudet får behandlertildelingsregel» (fase 2) har også et åpent spørsmål, om fase 1 og 2 skal slås sammen. Fasen er ikke levert (se «Ikke med i denne testen»).

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

### Saksbehandlertildeling (`@FLY-OPT-SAK-001`, `@planned`)

- **Testes**: deler av flyten (fase 3 og 4, de to leverte fasene)
- **Hvorfor**: 2 av 5 faser er levert. Overleveringene i de to leverte fasene er funnet i koden (verify-rapporten 2026-11-04 13:17), og de 4 scenarioene i dem testes. Flyten bruker «UVH» («Bare tilbyderen – bare dette studieønsket»), så scenarioet «Søknaden blir én sak hos hver saksbehandlende organisasjon», som var usikker i rapporten fordi flyten da brukte «SPE», testes med «UVH».

| Fase | Bygger på | Fase levert | I leveransen | Scenarioer i testen |
|---|---|---|---|---|
| Behandlertildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001` (`@in-progress`), `@OPT-BEH-BEH-011` (`@implemented`) | nei | ja | – |
| Utdanningstilbudet får behandlertildelingsregel | `@OPT-OPT-UTD-004` (`@draft`) | nei | nei | – |
| Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` (`@implemented`) | ja | ja | 2 |
| Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` (`@implemented`), `@OPT-BEH-BEH-010` (`@implemented`) | ja | ja | 2 |
| Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `@OPT-OVO-FRI-001` (`@in-progress`, regelen om fristen er ikke `@implemented` ennå), `@OPT-BEH-BEH-011` (`@implemented`) | nei | ja | – |

Fasene 1, 2 og 5 har scenarioer som ikke kan testes ennå (verify-rapporten fant 3 av 7 scenarioer i flyten, og 1 var usikker: «Søknaden blir én sak …», som nå testes med «UVH»).

### Vurdering per krav (fase 3)

Den interne akseptansetesten tester flyter og avhengigheter. Per krav vurderes det hva som testes:

| Krav | Inngår i flyt | Vurdering |
|---|---|---|
| `@OPT-BEH-BEH-011` | Saksbehandlertildeling (`@FLY-OPT-SAK-001`) | Flyten testes (fase 3 og 4). Resten av kravet testes som oppgaver uten flyt: oppsett med unntak, endring og flytting, og innsyn |

Scenarioene som tas med i fase 3, er de som inngår i flytene, ikke alle. Ingen andre flyter bygger på `@OPT-BEH-BEH-011` (søkt med `grep -rn "@depends-on-OPT-BEH-BEH-011" krav/_Flyter/`: bare denne flyten), så det er ingen regresjon av tidligere leverte flyter.

### Avhengighetskart

Ikke aktuelt: leveransen trenger ikke et eget avhengighetskart. Avhengighetene er:

- fristen for endring av utdanningsbakgrunn i `@OPT-OVO-FRI-001`
- regelen per utdanningstilbud i `@OPT-OPT-UTD-004`
- tilbudsgarantien i `@OPT-BEH-BEH-010`
- Min kompetanse (søkerens visning, MR !994, som regnes som implementert)
- tildelingsjobben, som fordeler søknadsalternativene asynkront

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

Ingen.

## Regler uten scenario

`fs-verify` rapporterer regler i koden som ikke har et scenario i kravet, for eksempel valideringer og tilgangssjekker. De er input til de agentiske testcasene (fase 2). Listen er ikke fullstendig: den har det som ble sett under letingen (verify-rapporten 2026-11-04 13:17, 29 regler). Sti til filene er forkortet, og står hele i verify-rapporten. Regler der det er uklart om koden gjør det kravet ønsker, testes ikke før teamet har avklart dem.

| Krav | Regel i koden | Funnet i | Testes i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-BEH-BEH-011` | Kode: 1–40 tegn, store bokstaver, tall og `_:,.-+`, unik i opptaket, påkrevd, kan ikke endres etter opprettelse | `fs-plattform/…/V395__behandlertildelingsregel_per_opptak.sql:71`; `fs-admin/…/BehandlertildelingsregelEditor.tsx:352` | ja | nei |
| `@OPT-BEH-BEH-011` | Navn er påkrevd, maks 100 tegn | `fs-admin/…/BehandlertildelingsregelEditor.tsx:284-286` | ja | nei |
| `@OPT-BEH-BEH-011` | Fordelingen («Hvem skal saksbehandle?») er påkrevd, nøyaktig én av fire | `fs-admin/…/BehandlertildelingsregelEditor.tsx:286` | ja | nei |
| `@OPT-BEH-BEH-011` | Ny regel er aktiv som standard | `fs-plattform/…/BehandlertildelingsregelMutations.java:51` | ja | nei |
| `@OPT-BEH-BEH-011` | Standardregelen må være aktiv; lista over valg viser bare aktive regler | `fs-plattform/…/OpprettOpptakMutations.java:418-422`; `fs-admin/…/BehandlertildelingsregelStandard.tsx:37` | ja | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | API-et lar standardregelen settes til ingen; tildelingen stopper da | `fs-plattform/…/OpprettOpptakMutations.java:395-398`; `fs-plattform/…/BehandlertildelingService.java:95-98` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Utdanningstilbud kan ikke velge en inaktiv regel eller en regel fra et annet opptak | `fs-plattform/…/UtdanningstilbudMutations.java:361-385` | ja | nei |
| `@OPT-BEH-BEH-011` | Høyst ett unntak per utdanningsbakgrunn; realkompetanse og dispensasjon kan ikke ha unntak (vises deaktivert med forklaring) | `fs-plattform/…/BehandlertildelingsregelMutations.java:171-190`; `fs-admin/…/BehandlertildelingsregelUnntak.tsx:107-120` | ja | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | Organisasjonen i unntak for utdanningsbakgrunn trenger ikke delta i opptaket; tom organisasjon betyr tilbyderen | `fs-plattform/…/BehandlertildelingsregelMutations.java:197-199`; `fs-admin/…/BehandlertildelingsregelUnntak.tsx:80-90` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Organisasjon for sektoren er valgfri (tom betyr tilbyderen søkeren har prioritert høyest) og gjelder bare «Tilbydere i samme sektor» | `fs-admin/…/convertDataToInput.ts:41-47` | ja | nei |
| `@OPT-BEH-BEH-011` | Unntak for lærested: begge kolonner er påkrevd, og lærestedet kan ikke saksbehandle på vegne av seg selv | `fs-admin/…/BehandlertildelingsregelPaVegneAv.tsx:46-47,126-135`; `fs-plattform/…/V478__behandlertildelingsregel_pa_vegne_av.sql:31-32` | ja | nei |
| `@OPT-BEH-BEH-011` | «Legg til unntak» for lærested er skjult når opptaket ikke har deltakere, og deaktivert når alle deltakerne er brukt | `fs-admin/…/BehandlertildelingsregelPaVegneAv.tsx:136-138,289-309` | ja | nei |
| `@OPT-BEH-BEH-011` | Regelen kan ikke lagres (heller ikke en endring av navnet på en inaktiv regel) mens en organisasjon i unntaket for lærested eller sektoren ikke deltar i opptaket | `fs-plattform/…/BehandlertildelingsregelMutations.java:86-87,113-127` | ja | nei |
| `@OPT-BEH-BEH-011` | Bare én aktiv regel med «Alle som deltar i opptaket» gjelder også når en inaktiv regel aktiveres | `fs-plattform/…/V395__behandlertildelingsregel_per_opptak.sql:88-90` | ja | nei |
| `@OPT-BEH-BEH-011` | Et opptak kan bare gjøres lokalt når det ikke har deltakere eller andre regler enn standardregelen | `fs-plattform/…/OpprettOpptakMutations.java:329-346` | ja | nei |
| `@OPT-BEH-BEH-011` | Fordelingen er asynkron (hendelsesjobben), og venter når opptaket mangler standardregel | `fs-plattform/…/SoknadshendelseJobb.java:287-313` | ja | nei |
| `@OPT-BEH-BEH-011` | Tom sak blir inaktiv (slettes ikke) og vises ikke i «Saker i opptak»; den aktiveres igjen når den får et alternativ | `fs-plattform/…/BehandlertildelingService.java:554-602`; `fs-plattform/…/sak.graphqls:2-8` | ja | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | Saksnummeret er `søknadsnummer-løpenummer`, og løpenummeret fortsetter fra det høyeste | `fs-plattform/…/BehandlertildelingService.java:441-468,604-616` | ja | nei |
| `@OPT-BEH-BEH-011` | Ved flytting blir grunnlag, poeng og kvote igjen i den gamle saken; flyttes alternativet tilbake, kan de gamle radene dukke opp igjen | `fs-plattform/…/BehandlertildelingService.java:375-378,411-427` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Mottakerens eksisterende sak for søknaden gjenbrukes uten å nullstille status eller innhold | `fs-plattform/…/BehandlertildelingService.java:445-457` | ja | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | Tildelt saksbehandler blir stående på den gamle saken; den nye saken har ingen | `fs-plattform/…/BehandlertildelingService.java:458-465` | ja | nei |
| `@OPT-BEH-BEH-011` | Saksbehandlerens overstyring lagres alltid, men flytter bare når den gjelder i tildelingen; opptaksforvalteren kan da velge «Flytt saken» | `fs-plattform/…/UtdanningsbakgrunnOverstyringService.java:44-76,109-124`; `fs-admin/…/UtdanningsbakgrunnCard.tsx:227-247` | ja | ja (`fs-krav`) |
| `@OPT-BEH-BEH-011` | Saksbehandleren kan ikke fjerne eller endre en overstyring opptaksforvalteren har gjort | `fs-plattform/…/UtdanningsbakgrunnOverstyringService.java:126-149` | ja | nei |
| `@OPT-BEH-BEH-011` | Fristen kan ikke omgås ved å endre søknaden på vegne av søkeren | `fs-plattform/…/OppdaterSoknadISoknadsbehandlingService.java:150-176` | ja | nei |
| `@OPT-BEH-BEH-011` | Er fristen ikke satt, regnes den som gått ut for saksbehandleren | `fs-plattform/…/Utdanningsbakgrunnsfrist.java:35-37` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Søkeren ser opptakets organisasjon som kontakt når søknadsalternativet ikke er fordelt ennå | `min-kompetanse/…/group-by-saksbehandler.ts:26-28` | ja | nei |
| `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon ser de interne merknadene hos alle organisasjonene i opptaket, også etter flytting | `fs-plattform/…/V493__tilbyder_ser_saksbehandlingen.sql:69-87` | nei: uklart om ønsket, avklares først | avklares først |
| `@OPT-BEH-BEH-011` | Tilbyderen ser praksisperiodene i saken | `fs-plattform/…/V501__tilbyderoppslag_per_sak.sql:75-90` | ja | nei |
| `@OPT-BEH-BEH-011` | Tilbyderen ser bare sakene der den har et søknadsalternativ, ikke de andre sakene i søknaden | `fs-plattform/…/V501__tilbyderoppslag_per_sak.sql:22-35` | ja | nei |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Flyten `@FLY-OPT-SAK-001`, fasen «Behandlertildelingsreglene settes for opptaket» | Fasen er ikke levert: `@OPT-OVO-SAM-001` er `@in-progress` |
| Flyten `@FLY-OPT-SAK-001`, fasen «Utdanningstilbudet får behandlertildelingsregel» | Fasen er ikke levert: `@OPT-OPT-UTD-004` er `@draft` |
| Flyten `@FLY-OPT-SAK-001`, fasen «Søknadsalternativene flyttes når utdanningsbakgrunnen endres» | Fasen er ikke levert: regelen om fristen i `@OPT-OVO-FRI-001` er ikke `@implemented`. Flyttingen testes likevel i kravet (regelen om flytting i `@OPT-BEH-BEH-011`) |
| «Overført» (status på en flyttet sak) | Tatt ut av kravet 04.11.2026, tas opp igjen hvis det meldes behov. |
| `@OPT-OPT-UTD-004` Regel «Opptaksforvalter kan velge behandlertildelingsregel per utdanningstilbud» | Eget krav, brukes som forutsetning: valget av regel på utdanningstilbudet. Kravet er et utkast (`@draft`) |
| `@OPT-OVO-FRI-001` Regel om fristen for endring av utdanningsbakgrunn | Eget krav, brukes som forutsetning. Regelen er ikke `@implemented` |
| `@OPT-BEH-BEH-010` Tilbudsgarantien | Eget krav, brukes som forutsetning (`@implemented`) |
