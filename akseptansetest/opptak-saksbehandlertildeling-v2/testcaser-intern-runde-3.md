# Intern akseptansetest – Saksbehandlertildeling, runde 3

- **Nivå**: intern (fase 3), runde 3: retest av funnene fra runde 2, og en kort grunnflyt
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2
- **Krav**: `@OPT-BEH-BEH-011` og `@FLY-OPT-SAK-001`, branchen `krav/saksbehandlertildeling-v2` (PR #936), 2026-11-11
- **Verifisering**: [verify-2026-11-11-0945.md](../../tasks/opptak/saksbehandlertildeling/spec/verify-2026-11-11-0945.md). Dokumentene i saken er levert. Alle søknadsalternativene i saken venter på fs-admin MR !3362. At tilbyderen ser dokumentene, er ikke bygget (`@openquestion`)
- **Runde 2**: [Intern akseptansetest – Saksbehandlertildeling, runde 2](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5173018630/Intern+akseptansetest+Saksbehandlertildeling+runde+2), 6 funn
- **Confluence**: [Fylles ut når siden er publisert]
- **Laget**: 2026-11-11 av fs-testcaser-intern. Testansvarlig ba om en kort runde: bare det som feilet i runde 2, og en grunnflyt for å se at tildelingen virker. Resten er gjennomgått i runde 2 og i den agentiske testen.
- **Sporing**:

  | Nr | Del | Feature-ID | Regel (fase) | Scenario | Funn i runde 2 |
  |---|---|---|---|---|---|
  | 1 | a | `@FLY-OPT-SAK-001` | Søknadsalternativene fordeles når søknaden sendes | Søknaden blir én sak hos hver saksbehandlende organisasjon | – |
  | 1 | b | `@FLY-OPT-SAK-001`, `@OPT-BEH-BEH-011` | Den saksbehandlende organisasjonen ser saken; Saksbehandlende organisasjon ser bare saker hos organisasjonen | Saksbehandleren ser bare saken hos organisasjonen sin; Saksbehandleren ser alle søknadsalternativene på søknaden; Saksbehandleren ser dokumentene søkeren har lastet opp | 3 |
  | 1 | c | `@OPT-BEH-BEH-011` | Tilbyderen ser saksbehandlingen når en annen organisasjon saksbehandler utdanningstilbudet | Tilbyderen ser søknadsalternativ som en annen organisasjon saksbehandler; Tilbyderen kan ikke endre saksbehandlingen; Tilbyderen ser alle søknadsalternativene på søknaden | 1, 2, 3, 4 |
  | 1 | d | `@OPT-BEH-BEH-011` | Tilbyderen ser saksbehandlingen … | Tilbyderen setter tilbudsgaranti | 6 |
  | 1 | e | `@OPT-BEH-BEH-011` | Opptaksforvalteren ved forvaltende organisasjon ser alle sakene i opptaket | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner | 1 |
  | 2 | – | `@OPT-BEH-BEH-011` | Saksbehandlende organisasjon ser bare saker hos organisasjonen | Søkeren ser saksbehandlende organisasjon, men ikke sakene | – (aldri testet, STEK-664 er levert) |

---

Intern akseptansetest av «Saksbehandlertildeling», runde 3. Testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2). Felt med gul bakgrunn fylles ut av teamet før testen.

## Slik tester du

- Dette er en kort runde, ca. 30 minutter. Den sjekker at funnene fra runde 2 er rettet, og at tildelingen fortsatt virker fra søknad til sak. Det som er gått gjennom før, testes ikke på nytt.
- Testcasene er oppgaver, ikke oppskrifter. Steget sier hva du skal få til og hva du skal se etter.
- Fordelingen skjer i en jobb som går omtrent hvert 30. sekund. Vent et minutt før du sjekker hvem som har fått saken.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor.
- Alt skjer i testopptaket «HÅK1 er KUL 2 - Saksbehandlertildeling». Endre ikke andre opptak.
- Funn skrives i «Funn», med funntype, alvorlighetsgrad og fasen du fant det i («3. Intern»). Spørsmål underveis tas i #søknadsbehandling-team-puff.

## Før testen (teamet)

| # | Forutsetning | Status |
| --- | --- | --- |
| F1 | fs-admin MR !3362 (alle søknadsalternativene i saken, STEK-675) er merget og ute i test-fsadmin | [Fylles ut] |
| F2 | Lesemodusen (STEK-672) er ute i test-fsadmin | [Fylles ut] |
| F3 | Én søknad i testopptaket der søkeren har lastet opp et dokument, med studieønsker ved minst to læresteder som fordeles til ulike organisasjoner. Søknader opprettet på vegne av søkeren i FS Admin har ingen opplastede dokumenter, så den lages i Min kompetanse med en TestID-søker (høyst fem TestID-søkere totalt) | [Fylles ut: søknadsnummer] |
| F4 | Testopptaket har tilbudsgarantityper. Mangler de, er 1d «Ikke testet» | [Fylles ut] |
| F5 | Utdanningstilbudet tilbyderen ser i 1c, har kvote, så poengene er regnet ut (funn 4 i runde 2: poengene vises per kvote) | [Fylles ut: utdanningstilbud] |

## Testcaser

### 1. Fra søknad til sak, og det hver organisasjon ser (ca. 25 minutter)

**Hensikt:** se at en søknad blir fordelt riktig, og at funnene fra runde 2 er rettet: saken er i lesemodus for den som ikke saksbehandler, saksbehandleren og tilbyderen ser alle søknadsalternativene, og saksbehandleren ser dokumentene.

**Testdata:** testbruker 1 (ORDENTLIG RUNDSKRIV, opptaksforvalter ved HK-dir), testbruker 3 (KORT DOMPAP, saksbehandler ved UiO), testbruker 5 (KORT DOMPAP, saksbehandler ved UiT). Søknaden fra F3. Behandlertildelingsreglene som står i testopptaket fra før.

**Avhengigheter som sjekkes:** tildelingsjobben (1a).

| Del | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 1a | Søknaden blir én sak hos hver saksbehandlende organisasjon | 1. Logg inn som testbruker 1, og finn søknaden fra F3 i «Saker i opptak».  2. Skriv ned hvilken organisasjon du forventer saksbehandler hvert studieønske, ut fra reglene på utdanningstilbudene. Sjekk så B-rollen på hvert studieønske. | Hvert studieønske har den saksbehandlende organisasjonen du forventet, og søknaden har én sak per organisasjon |  |  |
| 1b | Saksbehandleren ser hele søknaden og dokumentene (funn 3) | 3. Logg inn som saksbehandler ved en organisasjon som fikk en sak (testbruker 3 eller 5), og åpne saken.  4. Se på søknadsalternativene og dokumentene. | Saksbehandleren ser alle studieønskene på søknaden, med prioritet, tilbyder og saksbehandlende organisasjon. Studieønskene som behandles i en annen sak, er merket, og saksbehandlingen av dem vises ikke. Dokumentet søkeren lastet opp, vises og kan åpnes. Vurder om det er tydelig hvilke studieønsker du saksbehandler |  |  |
| 1c | Tilbyderen ser saken i lesemodus (funn 1, 2, 3 og 4) | 5. Finn et studieønske der tilbyderen ikke er saksbehandlende organisasjon. Logg inn som saksbehandler ved tilbyderen, og åpne saken.  6. Gå gjennom saken: knappene, manglene, søknadsalternativene og oppsummeringen. | Tilbyderen ser ingen knapper eller redigering den ikke har lov til å bruke, heller ikke for mangler og melding om mangel, og får ingen feilmelding. Tilbyderen ser alle studieønskene på søknaden, men saksbehandlingen bare for sine egne. Poengene vises i oppsummeringen (F5) |  |  |
| 1d | Tilbyderen setter tilbudsgaranti (funn 6) | 7. Som tilbyderen i 1c: sett tilbudsgaranti på studieønsket.  8. Last siden på nytt. | Tilbudsgarantien er lagret. Mangler testopptaket tilbudsgarantityper (F4), er det «Ikke testet» |  |  |
| 1e | Opptaksforvalteren ser saken i lesemodus (funn 1) | 9. Logg inn som testbruker 1, og åpne en sak hos UiO eller UiT for søknaden. | Opptaksforvalteren ser sakene hos alle organisasjonene. Det opptaksforvalteren ikke har lov til i saken, vises ikke |  |  |

### 2. Søkeren ser hvem som saksbehandler (ca. 5 minutter, valgfri)

**Hensikt:** søkerens visning i Min kompetanse er levert (STEK-664), men er ikke testet av noen ennå: verken den agentiske testen eller runde 2 kom til den.

**Testdata:** TestID-søkeren fra F3.

| Del | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2 | Søkeren ser saksbehandlende organisasjon, men ikke sakene | 1. Logg inn i Min kompetanse (test) som søkeren fra F3.  2. Åpne søknaden. | Søkeren ser hvilken organisasjon som saksbehandler hvert studieønske, og ingen saker eller saksbehandlere. Vurder om teksten er forståelig for en søker |  |  |

## Ikke testbart nå

| Scenario | Hvorfor | Når det kan testes |
| --- | --- | --- |
| Tilbyderen ser dokumentene søkeren har lastet opp (funn 5) | Ikke bygget. Scenarioet har et åpent spørsmål: ny sak, eller ta det ut av kravet | Når spørsmålet er avklart, og det eventuelt er bygget |

## Ikke med i denne runden

| Hva | Hvorfor |
| --- | --- |
| Sette opp behandlertildelingsregler, unntak og regel på utdanningstilbud | Gjort i runde 2 (1a) og bestått i den agentiske testen |
| Endre søknaden, flytte søknadsalternativene og fristen for endring av utdanningsbakgrunn | Bestått i den agentiske testen. Gått gjennom i runde 2, men ikke ført på testsiden |
| Dokumentene etter flytting | Verifisert i koden 11.11.2026, og flyttingen er bestått i den agentiske testen |
| Feltvalidering, feilmeldinger og grenseverdier | Bestått i den agentiske testen (fase 2) |
| «Overført» | Tatt ut av kravet 04.11.2026 |

## Funn

| # | Testcase | Funntype | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Fase funnet | Sak |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |  |  |

## Andre funn

| # | Hva | Forslag |
| --- | --- | --- |
|  |  |  |
