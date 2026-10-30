# Testplan – Saksbehandlertildeling

- **Leveranse**: oppgave
- **Kilde**: `tasks/opptak/saksbehandlertildeling`
- **Scope**: –
- **Oppgaver**: [opptak/saksbehandlertildeling](../../tasks/opptak/saksbehandlertildeling/) (ingen `oppgave.md`)
- **Krav**: 1 feature-fil, 0 `@implemented`, 1 delvis levert, 1 flyt, commit `a326792` (2026-10-23)
- **Verifisering**: [verify-2026-10-23-1041.md](../../tasks/opptak/saksbehandlertildeling/spec/verify-2026-10-23-1041.md), og for flyten [verify-saksbehandlertildeling-2026-10-22-1419.md](../../krav/_Flyter/10%20Opptaksl%C3%B8pet/verify-saksbehandlertildeling-2026-10-22-1419.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130911779/Akseptansetesting+saksbehandlertildeling
- **Laget**: 2026-10-23 av fs-testplan

---

Testplan for «Saksbehandlertildeling». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | I et samordna opptak fordeles hvert søknadsalternativ til én saksbehandlende organisasjon, og søknaden blir én sak hos hver av dem. Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene i FS Admin: standardregel, «Alle som deltar i opptaket», «Bare tilbyderen» (også for studieønsker uten egen regel, eller bare dette studieønsket) og «Tilbydere i samme sektor», med unntak for utdanningsbakgrunn. Realkompetanse og ledige studieplasser saksbehandles alltid av tilbyderen. Fordelingen ligger fast når søkeren endrer søknaden, men søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak, og tilbudsgarantiene følger med. Saksbehandleren ser bare sakene hos organisasjonen sin, og opptaksforvalteren ved forvaltende organisasjon ser alle. |
| Versjon | [Fylles ut: versjon eller dato for deploy] |
| Testmiljø | [Fylles ut: URL til testmiljøet for FS Admin og for Min kompetanse] |
| Feature-flagg | [Fylles ut: flagg som må være på, eller «Ingen»] |
| Kilde | Oppgaven [`tasks/opptak/saksbehandlertildeling`](https://github.com/sikt-no/fs/tree/a326792/tasks/opptak/saksbehandlertildeling), spesifikasjonen [`spec-tildele-saksbehandlende-organisasjon.md`](https://github.com/sikt-no/fs/blob/a326792/tasks/opptak/saksbehandlertildeling/spec/spec-tildele-saksbehandlende-organisasjon.md) |
| Scope | Ingen |
| Saker | GitHub [#207](https://github.com/sikt-no/fs/issues/207) · Jira [STEK-242](https://sikt.atlassian.net/browse/STEK-242) (epic), bl.a. STEK-492, STEK-568–STEK-581, STEK-622, STEK-626 og STEK-629 |
| Berører andre team | Behandlertildelingsreglene er en innstilling i opptaket (PUFF). Valget av behandlertildelingsregel per utdanningstilbud står i `@OPT-OPT-UTD-004`, fristen for endring av utdanningsbakgrunn i `@OPT-OVO-FRI-001`, og tilbudsgarantien i `@OPT-BEH-BEH-010`. Søkeren sender inn og endrer søknaden i Min kompetanse. |
| Kjente begrensninger | Saksbehandling på vegne av et lærested (STEK-579), tilbyderens innsyn i saksbehandlingen (STEK-576) og søkerens visning av saksbehandlende organisasjon er ikke laget, og testes ikke. Fristen for endring av utdanningsbakgrunn finnes i koden (STEK-622), men regelen om fristen i `@OPT-OVO-FRI-001` er ikke verifisert ennå. Åpnes siden for å opprette en behandlertildelingsregel direkte, får en opptaksforvalter ved et deltakende lærested et skjema, men lagringen avvises. En deaktivert behandlertildelingsregel brukes fortsatt i fordelingen, men den kan bare deaktiveres når den ikke er i bruk. Søkere med dispensasjon saksbehandles også av tilbyderen, som realkompetanse. |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | [Fylles ut] | Opptaksforvalter ved forvaltende organisasjon | HK-dir | Behandlertildelingsreglene, endring av utdanningsbakgrunn etter fristen, se alle sakene |
| 2 | [Fylles ut] | Opptaksforvalter ved deltakende lærested | Universitetet i Oslo | Kan ikke endre behandlertildelingsreglene, velge behandlertildelingsregel for utdanningstilbud (sektor) |
| 3 | [Fylles ut] | Saksbehandler | Universitetet i Oslo | Se bare saken hos organisasjonen sin, endre utdanningsbakgrunn, legge til søknadsalternativ på vegne av søkeren |
| 4 | [Fylles ut] | Saksbehandler | HK-dir | Se bare saken hos forvaltende organisasjon |
| 5 | [Fylles ut] | Søker | – | Sende inn og endre søknaden, endre utdanningsbakgrunn, søke ledig studieplass |

Testbrukerne finnes i minst to organisasjoner, så vi kan teste at ingen ser data de ikke skal se.

### Testdata

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| Samordna opptak forvaltet av HK-dir, med UiO, UiT, NTNU og HVL som deltakere, og standardregel «Alle som deltar i opptaket» | [Fylles ut] | [Fylles ut] | [Fylles ut] |
| Behandlertildelingsregler: «UVH» (bare dette studieønsket), «SPE» (også for studieønsker uten egen regel), «JOU» og «PAP» (tilbydere i samme sektor), med og uten unntak for «Utenlandsk» og «Rudolf Steinerskole» | [Fylles ut] | [Fylles ut] | Ja, kan opprettes i testen |
| Utdanningstilbud med og uten egen behandlertildelingsregel, ved flere læresteder (for eksempel Informatikk UiO, Historie UiT, Sykepleie NTNU, Utøvende musikk NTNU, Musikkpedagogikk HVL, Journalistikk HVL og UiT, Paramedisin NTNU) | [Fylles ut] | [Fylles ut] | [Fylles ut] |
| Utdanningstilbud med ledige studieplasser, og et opptak der ledige studieplasser har åpnet | [Fylles ut] | [Fylles ut] | [Fylles ut] |
| Opptak med frist for endring av utdanningsbakgrunn: én som ikke har gått ut, og én som har gått ut | [Fylles ut] | [Fylles ut] | [Fylles ut] |
| Søkere med norsk, utenlandsk og Rudolf Steinerskole utdanningsbakgrunn, og med realkompetanse | [Fylles ut] | [Fylles ut] | [Fylles ut] |
| Søknader med tilbudsgaranti fra saksbehandler, tilbyder og opptaksforvalter | [Fylles ut] | [Fylles ut] | [Fylles ut] |
| Et lokalt opptak | [Fylles ut] | [Fylles ut] | – |
| Et opptak der standardregelen er «Bare tilbyderen – bare dette studieønsket» (for eksempel fagskoleopptak) | [Fylles ut] | [Fylles ut] | [Fylles ut] |

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Tildele saksbehandlende organisasjon](https://github.com/sikt-no/fs/blob/a326792/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | `@OPT-BEH-BEH-011` | `@in-progress` (delvis levert) | 48 |

De leverte delene:

| Del | Scenarioer i testen |
|---|---|
| Regel: Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket | 10 |
| Regel: Ved «Alle som deltar i opptaket» saksbehandler lærestedet søkeren har prioritert høyest | 2 |
| Regel: Ved «Bare tilbyderen – også for studieønsker uten egen regel» saksbehandler tilbyderen også søknadsalternativene uten egen behandlertildelingsregel | 2 |
| Regel: Ved «Bare tilbyderen – bare dette studieønsket» saksbehandler tilbyderen bare søknadsalternativet med behandlertildelingsregelen | 2 |
| Regel: Ved «Tilbydere i samme sektor» saksbehandler én organisasjon alle søknadsalternativene i sektoren | 7 |
| Regel: Unntak for utdanningsbakgrunn og ledige studieplasser overstyrer behandlertildelingsregelen | 8 |
| Regel: Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast | 7 |
| Regel: Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak | 7 |
| Regel: Saksbehandlende organisasjon ser bare saker hos organisasjonen (2 av 3 scenarioer) | 2 |
| Regel: Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket | 1 |

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av de samme kravene: `npx playwright test --grep "@OPT-BEH-BEH-011|@FLY-OPT-SAK-001"`.

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

### Saksbehandlertildeling (`@FLY-OPT-SAK-001`, `@planned`)

- **Testes**: deler av flyten (fasen «Søknadsalternativene fordeles når søknaden sendes»)
- **Hvorfor**: 1 av 5 faser er levert

| Fase | Bygger på | Fase levert | I leveransen | Scenarioer i testen |
|---|---|---|---|---|
| Behandlertildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001` (`@in-progress`), `@OPT-BEH-BEH-011` (`@in-progress`, delvis levert: Regel «Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket» levert, Regel «Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket» ikke levert) | nei | ja | – |
| Utdanningstilbudet får behandlertildelingsregel | `@OPT-OPT-UTD-004` (`@draft`) | nei | nei | – |
| Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` (`@in-progress`, Regel «Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast» levert) | ja | ja | 1 |
| Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` (`@in-progress`, Regel «Saksbehandlende organisasjon ser bare saker hos organisasjonen» delvis levert, Regel «Tilbyderen ser saksbehandlingen …» ikke levert), `@OPT-BEH-BEH-010` (`@implemented`) | nei | ja | – |
| Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `@OPT-OVO-FRI-001` (`@in-progress`, regelen om fristen ikke levert), `@OPT-BEH-BEH-011` (`@in-progress`, Regel «Søknadsalternativene flyttes …» levert) | nei | ja | – |

Åpent spørsmål: `@FLY-OPT-SAK-001` «Søknaden blir én sak hos hver saksbehandlende organisasjon»: Steget om at "Universitetet i Oslo" er saksbehandlende organisasjon for "Informatikk, UiO" og "Historie, UiT", og steget om "NTNU", gjentar fordelingsreglene i OPT-BEH-BEH-011. Holder det med de to siste stegene? Testes som det står.

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [Tildele saksbehandlende organisasjon](https://github.com/sikt-no/fs/blob/a326792/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | `@OPT-BEH-BEH-011` | `@in-progress` | Delen «Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket»: valget finnes bare i API-et, ikke i FS Admin. Utsatt i STEK-579, og Ingrid Helset og Marit Bjørnerud Rønning foreslår at det lages som en behandlertildelingsregel (åpent spørsmål) |
| [Tildele saksbehandlende organisasjon](https://github.com/sikt-no/fs/blob/a326792/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | `@OPT-BEH-BEH-011` | `@in-progress` | Delen «Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet»: tilbyderen har ingen visning av søknadsalternativet. Utsatt i STEK-576, tas sammen med visning av saksbehandlingen for T-rollen |
| [Tildele saksbehandlende organisasjon](https://github.com/sikt-no/fs/blob/a326792/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/tildele_saksbehandlende_organisasjon.feature) | `@OPT-BEH-BEH-011` | `@in-progress` | Scenarioet «Søkeren ser saksbehandlende organisasjon, men ikke sakene»: saksbehandlende organisasjon finnes ikke i API-et for søkeren, og vises ikke i Min kompetanse. Utsatt |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| `@OPT-BEH-BEH-011` «Flyttet søknadsalternativ vises som overført hos organisasjonen det flyttes til» | Ikke avklart ennå: om en flyttet sak skal få status «Overført», eller om behandlingsstatusen skal bli «ikke behandlet» og dokumentene uåpnet |
| `@OPT-OPT-UTD-004` Regel «Opptaksforvalter kan velge behandlertildelingsregel per utdanningstilbud» | Kravet er et utkast. Valget brukes som forutsetning i testen |
| `@FLY-OPT-SAK-001` fasen «Behandlertildelingsreglene settes for opptaket» | Fasen er ikke levert |
| `@FLY-OPT-SAK-001` fasen «Utdanningstilbudet får behandlertildelingsregel» | Fasen er ikke levert |
| `@FLY-OPT-SAK-001` «Organisasjonen som saksbehandler på vegne av lærestedet får saken» | Overleveringen er ikke funnet: valget kan ikke gjøres i FS Admin |
| `@FLY-OPT-SAK-001` fasen «Den saksbehandlende organisasjonen ser saken» | Fasen er ikke levert |
| `@FLY-OPT-SAK-001` fasen «Søknadsalternativene flyttes når utdanningsbakgrunnen endres» | Fasen er ikke levert |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | [Fylles ut] | Eier testen fra start til beslutning, og skriver beslutningen i testrapporten |
| Kontaktperson i teamet | [Fylles ut] | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut] | [Fylles ut] |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | Ikke aktuell |
| Spørsmål underveis | Slack-tråden «Akseptansetesting saksbehandlertildeling» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene er identifisert og tilgjengelige | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt | [Fylles ut av teamet] |
| 4 | Testbrukerne finnes i rollene leveransen gjelder, i minst to organisasjoner | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | 48 av de 48 leverte scenarioene er funnet (49 av 56 i kravet), kontrollert av `fs-verify-kontroll` 23.10.2026. Venter på kontroll av en person |
| 6 | Testcasene er laget og gått gjennom av testansvarlig | Venter |
| 7 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |

## Kriterier for godkjent

Testansvarlig skriver hva som skal til for at testen blir godkjent, helst før utviklingen starter.

[Fylles ut av testansvarlig]

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
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |

## Status i flyten

| Steg | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | [verify-2026-10-23-1041.md](https://github.com/sikt-no/fs/blob/a326792/tasks/opptak/saksbehandlertildeling/spec/verify-2026-10-23-1041.md) | 7 ikke funnet, 0 usikker (de utsatte delene) | 2026-10-23 |
| 2. Testplan | [Akseptansetesting saksbehandlertildeling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130911779/Akseptansetesting+saksbehandlertildeling) (testplan og testgjennomføring på én side) | Laget | 2026-10-23 |
| 3. Testrapport – verifisering | – | Venter | |
| 4. Intern akseptansetest | – | Venter | |
| 4b. CDP-kjøring (valgfri) | – | Ikke aktuell | |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | – | Ikke aktuell | |
| 7. Testrapport – ekstern | – | Ikke aktuell | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
