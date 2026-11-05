# Intern akseptansetest – Saksbehandlertildeling, runde 2

- **Nivå**: intern (fase 3)
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2
- **Scope**: –
- **Krav**: 1 feature-fil og 1 flyt, branchen `krav/saksbehandlertildeling-v2` (PR #936), 2026-11-05
- **Verifisering**: [verify-tildele_saksbehandlende_organisasjon-2026-11-04-1317.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-tildele_saksbehandlende_organisasjon-2026-11-04-1317.md), 62 av 62 funnet i kravet
- **Agentisk funksjonstest**: [testrapport-agentisk-2026-11-05.md](testrapport-agentisk-2026-11-05.md), gjennomgått av testansvarlig: [Fylles ut av testansvarlig], åpne funn med «Stopper»: 0
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5173018630/Intern+akseptansetest+Saksbehandlertildeling+runde+2
- **Laget**: 2026-11-05 av fs-testcaser-intern. Testansvarlig ba om få og åpne testcaser: fagpersonen får en oppgave og hva som skal vurderes, ikke et klikk for klikk-oppskrift. Fordelingen er testet i detalj i fase 2.
- **Sporing**:

  | Nr | Del | Feature-ID | Regel (fase) | Scenario |
  |---|---|---|---|---|
  | 1 | a | `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon setter opp behandlertildelingsreglene for opptaket | Opprette behandlertildelingsregel |
  | 1 | a | `@OPT-BEH-BEH-011` | Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket | Legge til unntak for lærested |
  | 1 | b | `@FLY-OPT-SAK-001` | Søknadsalternativene fordeles når søknaden sendes | Søknaden blir én sak hos hver saksbehandlende organisasjon |
  | 1 | b | `@OPT-BEH-BEH-011` | (fordelingsreglene, regel 2 til 6) | Det fagpersonen velger å prøve |
  | 1 | c | `@FLY-OPT-SAK-001` | Den saksbehandlende organisasjonen ser saken | Saksbehandleren ved den saksbehandlende organisasjonen ser saken |
  | 1 | d | `@OPT-BEH-BEH-011` | Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet | Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler |
  | 1 | e | `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner |
  | 2 | a | `@OPT-BEH-BEH-011` | Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast | Ny prioritering endrer ikke saksbehandlende organisasjon; Nytt søknadsalternativ uten egen behandlertildelingsregel får samme saksbehandlende organisasjon som før |
  | 2 | b | `@OPT-BEH-BEH-011` | Søknadsalternativene flyttes når utdanningsbakgrunnen endres til en bakgrunn med unntak | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen ikke har gått ut |
  | 2 | c | `@OPT-BEH-BEH-011` | Søknadsalternativene flyttes … | Organisasjonen søknadsalternativet flyttes til, får en ubehandlet sak; Interne merknader blir igjen hos organisasjonen søknadsalternativet flyttes fra |
  | 2 | d | `@OPT-BEH-BEH-011` | Søknadsalternativene flyttes … | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen har gått ut; Opptaksforvalteren ved forvaltende organisasjon er ikke bundet av fristen |
  | C1 | – | `@OPT-BEH-BEH-011` | Saksbehandlende organisasjon ser bare saker hos organisasjonen | Søkeren ser saksbehandlende organisasjon, men ikke sakene |
  | C2 | – | `@OPT-BEH-BEH-011` | Søknadsalternativene flyttes … | Søkeren bytter til utenlandsk utdanningsbakgrunn; Søkeren bytter til realkompetanse; Bytte fra <utdanningsbakgrunn> til norsk utdanningsbakgrunn flytter ingen søknadsalternativer |
  | C3 | – | `@OPT-BEH-BEH-011` | Søknadsalternativene flyttes … | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til |
  | C4 | – | `@OPT-BEH-BEH-011` | Et lærested kan ha saksbehandlingen sin hos en annen organisasjon i opptaket | Organisasjon i et unntak for lærested kan ikke tas ut av opptaket |
  | H1 | – | `@OPT-BEH-BEH-011` | Tilbyderen ser saksbehandlingen … | Tilbyderen kan ikke endre saksbehandlingen |
  | H2 | – | `@OPT-OVO-FRI-001` | (forutsetning) | Fristen for endring av utdanningsbakgrunn lagres |

---

Intern akseptansetest av «Saksbehandlertildeling, runde 2». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2). Felt med gul bakgrunn fylles ut av teamet før testen.

## Slik tester du

- Dette er en test av at saksbehandlertildelingen gir mening i arbeidet ditt, og henger sammen med resten av FS. Den agentiske testen har prøvd hver regel og hvert unntak for seg (105 testcaser), så du trenger ikke gjøre det på nytt.
- Testcasene er oppgaver, ikke oppskrifter. Steget sier hva du skal få til og hva du skal se etter. Velg gjerne utdanningstilbud og søkere som ligner ekte saker du kjenner.
- **Skriv ned hva du forventer før du sjekker.** Når testcasen ber deg sende inn en søknad, skriv i «Faktisk resultat» hvilken organisasjon du mener skal saksbehandle hvert studieønske, og hvorfor. Så sjekker du. Det er avviket mellom det du forventer og det løsningen gjør, som er interessant.
- Fordelingen skjer i en jobb som går omtrent hvert 30. sekund. Vent et minutt før du sjekker hvem som har fått saken.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor.
- Alt skjer i testopptaket «HÅK1 er KUL 2 - Saksbehandlertildeling». Endre ikke andre opptak.
- Søknader på vegne av en søker opprettes som saksbehandler ved UiO (testbruker 3). Saksbehandlerne ved HK-dir får ikke lov i testmiljøet nå (se testrapporten for fase 2).
- Funn skrives i «Funn», med funntype, alvorlighetsgrad og fasen du fant det i («3. Intern»). Spørsmål underveis tas i #søknadsbehandling-team-puff.

## Avhengigheter

Ingen avhengighetskart for denne leveransen. To ting sjekkes underveis: at fordelingen faktisk kjører (tildelingsjobben, i 1b), og at søkeren ser resultatet i Min kompetanse (C1).

## Testcaser

### 1. Fra behandlertildelingsregel til sak (flyten «Saksbehandlertildeling») (ca. 30 minutter)

**Hensikt:** se at en regel du setter opp, faktisk avgjør hvem som får saken, og at hver organisasjon ser det den skal. Det viser overleveringen fra opptaksforvalteren, via søknaden, til saksbehandleren.

**Testdata:** testbruker 1 (ORDENTLIG RUNDSKRIV, opptaksforvalter ved HK-dir), testbruker 3 (KORT DOMPAP, saksbehandler ved UiO), testbruker 5 (KORT DOMPAP, saksbehandler ved UiT). Bruker: utdanningstilbudene i testopptaket. Lager: én behandlertildelingsregel og to søknader, som brukes i testcase 2.

**Avhengigheter som sjekkes:** tildelingsjobben (1b).

Fasene «Søknadsalternativene fordeles når søknaden sendes» og «Den saksbehandlende organisasjonen ser saken», se testplanen.

| Del | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1a | Sette opp en regel som ligner en ekte situasjon | 1. Logg inn som testbruker 1. <br>2. Åpne «Behandlertildelingsregler» i testopptaket (via «Rediger opptak» → «Samordning»). <br>3. Tenk på et studium som i virkeligheten må saksbehandles av lærestedet selv (for eksempel med opptaksprøve), eller et lærested som får hjelp av et annet lærested. Lag en regel for det, med fordelingen du mener passer, og gjerne et unntak for utdanningsbakgrunn eller for lærested. <br>4. Sett regelen på ett utdanningstilbud i testopptaket («Gå til utdanningstilbud» → «Handlinger» → «Sett regelverk og saksbehandlertildeling»). | Regelen er lagret, og står på utdanningstilbudet. Du forstår hva hvert valg betyr uten hjelp | | |
| 1b | Søknaden fordeles slik du forventer | 5. Logg inn som testbruker 3. <br>6. Opprett to søknader på vegne av søkere («Gå til søknader» → «Opprett søknad»): én der utdanningstilbudet med din regel står først, og én der det står lenger ned. Bruk norsk utdanningsbakgrunn på den ene og utenlandsk på den andre. <br>7. Skriv ned hvem du forventer saksbehandler hvert studieønske. <br>8. Vent et minutt. Logg inn som testbruker 1, og se hvilken organisasjon som er saksbehandlende organisasjon («B-rolle») for hvert studieønske, i «Saker i opptak». | Hvert studieønske har den saksbehandlende organisasjonen du forventet, og søknaden har én sak per organisasjon | | |
| 1c | Den saksbehandlende organisasjonen ser saken | 9. Logg inn som saksbehandler ved en organisasjon som fikk en sak i 1b (testbruker 3 eller 5). <br>10. Finn søknaden i «Saker i opptak». | Saksbehandleren finner saken, og ser studieønskene organisasjonen skal saksbehandle | | |
| 1d | Tilbyderen ser saken når en annen organisasjon saksbehandler | 11. Finn et studieønske i 1b der tilbyderen ikke er saksbehandlende organisasjon. Logg inn som saksbehandler ved tilbyderen. <br>12. Åpne saken. | Tilbyderen ser saken i lesemodus, kan ikke endre grunnlag eller poeng, og ser ikke de interne merknadene. Vurder om det tilbyderen ser, er det tilbyderen trenger | | |
| 1e | Opptaksforvalteren ser alle sakene | 13. Logg inn som testbruker 1, og søk på søknadsnumrene fra 1b i «Saker i opptak». | Opptaksforvalteren ser sakene hos alle organisasjonene | | |

### 2. Søknaden endres og flyttes (oppgave uten flyt) (ca. 25 minutter)

**Hensikt:** se at en søker som har fått en saksbehandlende organisasjon, beholder den når søknaden endres, og at søknaden flyttes bare når utdanningsbakgrunnen krever det, og bare innenfor fristen.

**Testdata:** testbruker 1, 3 og 4 (GRUNDIG PROTOKOLL, saksbehandler ved HK-dir). Bruker: søknaden med norsk utdanningsbakgrunn fra 1b. Fristen «Endre utdanningsbakgrunn» i testopptaket står på 04.12.2026 (har ikke gått ut).

Fasen «Søknadsalternativene flyttes når utdanningsbakgrunnen endres» i flyten er ikke levert ennå, så dette testes som en oppgave i kravet.

| Del | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2a | Fordelingen ligger fast når søknaden endres | 1. Logg inn som testbruker 3. Åpne søknaden med norsk utdanningsbakgrunn fra 1b, og velg «Endre søknad». <br>2. Bytt prioriteringen, og legg til et studieønske ved et annet lærested. Lagre. <br>3. Vent et minutt, og se på B-rollene. | De studieønskene som var fordelt, har samme saksbehandlende organisasjon. Det nye studieønsket uten egen regel følger den søknaden allerede har. Vurder om det er det du ville ønsket for søkeren | | |
| 2b | Saksbehandleren endrer til utenlandsk utdanningsbakgrunn før fristen | 4. Som testbruker 3: åpne saken, og endre utdanningsbakgrunnen til utenlandsk («Endre utdanningsbakgrunn»). <br>5. Vent et minutt, og se hvem som har saken. | Søknadsalternativene med unntak for utenlandsk er flyttet til HK-dir | | |
| 2c | Den nye organisasjonen tar over | 6. Skriv en intern merknad i saken før du flytter den, hvis du ikke gjorde det i 2b. <br>7. Logg inn som testbruker 4, og åpne saken hos HK-dir. | Saken hos HK-dir er «Ikke behandlet», og HK-dir ser ikke den interne merknaden fra UiO. Vurder om HK-dir har det de trenger for å saksbehandle videre | | |
| 2d | Etter fristen flytter bare opptaksforvalteren | 8. Som testbruker 1: sett fristen «Endre utdanningsbakgrunn» til i går («Rediger opptak» → «Saksbehandling»). Sjekk etter lagring at datoen står (se H2). <br>9. Som testbruker 3: endre utdanningsbakgrunnen på en annen søknad fra UiO til utenlandsk. <br>10. Som testbruker 1: åpne den samme saken, og velg «Flytt saken». <br>11. Sett fristen tilbake til 04.12.2026 23:59. | Etter steg 9 blir saken hos UiO, og saken sier at bare opptaksforvalteren kan flytte den. Etter steg 10 er den hos HK-dir | | |

## Det den agentiske testen ikke klarte

| Nr | Test i fase 2 | Hvorfor agenten ikke klarte den | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| C1 | Søkeren ser saksbehandlende organisasjon, men ikke sakene | Min kompetanse i testmiljøet tok ikke imot studieønsker («0 studier i kurv», senere «Feilkode: 99») | 1. Logg inn i Min kompetanse (test) med ID-porten (TestID, «Hent tilfeldig person»). <br>2. Søk på to eller tre studier i testopptaket ved ulike læresteder, og send søknaden. <br>3. Vent et minutt, og åpne søknaden din under «Kontakt saksbehandler». | Søkeren ser hvilken organisasjon som saksbehandler hvert studium, med kontaktinformasjon, og ser ingen saker eller saksbehandlere. Vurder om teksten er forståelig for en søker. Krever at MR !994 i Min kompetanse er i testmiljøet | | |
| C2 | Søkeren bytter utdanningsbakgrunn selv | Søknaden kan bare endres på vegne av søkeren i FS Admin, og «Endre søknad» har ikke utdanningsbakgrunn | 1. Som søkeren fra C1: endre utdanningsbakgrunnen til utenlandsk i Min kompetanse, og send. <br>2. Vent, og se hvem som har saken (som testbruker 1). <br>3. Bytt tilbake til norsk. | Etter steg 1 er søknadsalternativene hos HK-dir. Etter steg 3 er de fortsatt hos HK-dir (søkeren bytter ikke organisasjon uten grunn) | | |
| C3 | Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til (tilbudsgaranti) | Testopptaket har ingen tilbudsgarantityper | 1. Hvis testopptaket har fått tilbudsgarantityper: sett tilbudsgaranti på et studieønske som saksbehandler ved UiO, og flytt søknaden som i 2b. <br>2. Åpne saken hos HK-dir. | Tilbudsgarantien står fortsatt på studieønsket. Har opptaket ingen typer, er det «Ikke testet» | | |
| C4 | Organisasjon i et unntak for lærested kan ikke tas ut av opptaket | Et mislykket forsøk tar en deltaker ut av testopptaket, og ødelegger det for de andre testene | 1. Gjør dette til slutt. Som testbruker 1: prøv å ta en organisasjon som står i et unntak for lærested (fra 1a, eller kjøringens regel «LAE»), ut av opptaket. | Det avvises, og organisasjonen er fortsatt med i opptaket. Lykkes det, inviter organisasjonen tilbake med en gang, og skriv funn | | |

## Høyest risiko

| Nr | Hva som prøves | Hvorfor det er valgt | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| H1 | Tilbyderen kan ikke endre en annen organisasjons sak | I fase 2 så tilbyderen knappene «Endre søknad», «Endre utdanningsbakgrunn», «Skriv ny merknad» og «Start automatisk behandling» i saken til en annen organisasjon. Ingen av dem ble trykket på | 1. Som saksbehandler ved tilbyderen (som i 1d): prøv «Skriv ny merknad» og «Endre utdanningsbakgrunn» i saken til den andre organisasjonen, og lagre (det er testdata). <br>2. Last siden på nytt, og se om endringen står. | Handlingene avvises, eller vises ikke. Kan tilbyderen endre saken, er det et alvorlig funn | | |
| H2 | Fristen for endring av utdanningsbakgrunn lagres | I fase 2 sa «Rediger opptak» «Lagring vellykket» flere ganger uten at datoen ble lagret (som STEK-659), og fristen kan ikke lagres uten datoene for automatisk saksbehandling | 1. Gjøres i 2d. Etter hver lagring: last siden på nytt, og sjekk datoen. | Datoen står etter første lagring | | |

## Opplevelse og helhet

| Nr | Hva testeren vurderer | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| O1 | Tekster og begreper: behandlertildelingsreglene | 1. Gå gjennom skjermen for en regel (fra 1a), og lista over regler. | Ordene («Hvem skal saksbehandle?», «Alle i opptaket», «Tilbyderen, også andre», «Saksbehandles av», «På vegne av», «Unntak for utdanningsbakgrunn», «Fordeles til») er forståelige for en opptaksforvalter, og stemmer med fagspråket | | |
| O2 | Forståelig og brukbar: saken etter fordeling og flytting | 1. Se på sakene fra 1b og 2b som saksbehandler. | Saksbehandleren forstår hvorfor saken er hos organisasjonen, og om den er flyttet. Skriv hva som mangler, hvis noe | | |

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| Søknadsalternativet saksbehandles på nytt hos organisasjonen det flyttes til (tilbudsgaranti) | Testopptaket har ingen tilbudsgarantityper | Når en utvikler har lagt inn tilbudsgarantityper i testopptaket (C3) |
| Søkeren ser saksbehandlende organisasjon (C1, C2) | Min kompetanse i testmiljøet tok ikke imot studieønsker 04.11, og MR !994 er ikke merget | Når studiekurven virker i testmiljøet, og MR !994 er ute |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Feltvalidering, feilmeldinger og grenseverdier | Bestått i den agentiske funksjonstesten (fase 2) |
| Hver fordelingsregel og hvert unntak for seg | Testet i fase 2 (alle fire reglene, sektor, unntak for utdanningsbakgrunn, ledig studieplass og unntak for lærested bestått). Fagpersonen prøver dem i en sammenheng i 1b |
| Fasene «Behandlertildelingsreglene settes for opptaket», «Utdanningstilbudet får behandlertildelingsregel» og «Søknadsalternativene flyttes når utdanningsbakgrunnen endres» i flyten | Fasene er ikke levert ennå (kravene de bygger på, er ikke ferdige) |
| «Overført» | Tatt ut av kravet 04.11.2026, tas opp igjen hvis det meldes behov |
| Tekniske begrensninger (for eksempel lengden på «Navn») | Holdes utenfor kravet |

## Funn

| # | Testcase | Funntype | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Fase funnet | Sak |
|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | 3. Intern | |

## Andre funn

| # | Hva | Forslag |
|---|---|---|
| | | |
