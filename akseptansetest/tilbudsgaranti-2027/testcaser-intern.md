# Intern akseptansetest – Tilbudsgaranti i saksbehandlingen 2027

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5130158105 (utkast)
- **Scope**: @scope-tilbudsgaranti-2027
- **Krav**: 1 feature-fil, commit `6478bee` (2026-10-22)
- **Verifisering**: [verify-2026-10-22-0850.md](../../tasks/opptak/tilbudsgaranti/spec/verify-2026-10-22-0850.md), 17 av 17 funnet
- **Ordene fra skjermen**: fs-admin `ba0ec3ef70` (de 8 nyere commitene på main rører ikke saksbehandlingen), endringsloggen fra fs-plattform `0229f59fb3`. Min kompetanse er ikke lest, så stegene for søkeren er merket `[Sjekk begrep]`
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5130289193 (utkast)
- **Laget**: 2026-10-22 av fs-testcaser-intern
- **Sporing**:

  | Nr | Feature-ID | Regel | Scenario |
  |---|---|---|---|
  | 1.1a | `@OPT-BEH-BEH-010` | Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt | Sette tilbudsgaranti i feltet for rollen (saksbehandler) |
  | 1.1b | `@OPT-BEH-BEH-010` | Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt | Sette tilbudsgaranti i feltet for rollen (tilbyder) |
  | 1.1c | `@OPT-BEH-BEH-010` | Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt | Sette tilbudsgaranti i feltet for rollen (opptaksforvalter) |
  | 1.2 | `@OPT-BEH-BEH-010` | Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt | Bare tilbudsgarantitypene for rollen kan velges |
  | 1.3 | `@OPT-BEH-BEH-010` | Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt | Saksbehandler ser ikke muligheten til å sette tilbudsgaranti som tilbyder eller opptaksforvalter |
  | 1.4 | `@OPT-BEH-BEH-010` | Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt | Se tilbudsgarantiene fra alle rollene |
  | 1.5 | `@OPT-BEH-BEH-010` | Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt | Sette tilbudsgaranti når søknaden ikke kan poengberegnes |
  | 1.6 | `@OPT-BEH-BEH-010` | Tilbudsgarantien kan endres og fjernes av rollen som satte den | Endre tilbudsgaranti |
  | 1.7 | `@OPT-BEH-BEH-010` | Tilbudsgarantien kan endres og fjernes av rollen som satte den | Fjerne tilbudsgaranti |
  | 1.8 | `@OPT-BEH-BEH-010` | Tilbudsgarantien kan endres og fjernes av rollen som satte den | Tilbudsgarantien fra en annen rolle blir stående |
  | 1.9 | `@OPT-BEH-BEH-010` | Tilbudsgarantien kan endres og fjernes av rollen som satte den | Opptaksforvalter ser ikke muligheten til å endre tilbudsgarantien fra saksbehandler |
  | 1.10 | `@OPT-BEH-BEH-010` | Tilbudsgarantitypene hører til opptaket | Bare tilbudsgarantitypene i opptaket kan velges |
  | 1.11 | `@OPT-BEH-BEH-010` | Endringer i tilbudsgarantien kan spores | Se hvem som har satt tilbudsgarantien |
  | 1.12 | `@OPT-BEH-BEH-010` | Endringer i tilbudsgarantien kan spores | Se hvem som har fjernet tilbudsgarantien |
  | 1.13 | `@OPT-BEH-BEH-010` | Endringer i tilbudsgarantien kan spores | Se hvilken tilbudsgarantitype som ble satt |
  | 1.14a | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (til prioritet 1) |
  | 1.14b | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (til prioritet 3) |
  | 1.14c | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (nytt søknadsalternativ som prioritet 1) |
  | 1.15a | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (saksbehandler) |
  | 1.15b | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (tilbyder) |
  | 1.15c | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (opptaksforvalter) |
  | 1.16a | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien faller bort når søknadsalternativet fjernes (fjerner søknadsalternativet) |
  | 1.16b | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien faller bort når søknadsalternativet fjernes (trekker søknaden) |
  | 1.17a | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen (prioritet 1) |
  | 1.17b | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen (prioritet 2) |

---

Intern akseptansetest av «Tilbudsgaranti i saksbehandlingen 2027». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5130158105). Felt med gul bakgrunn fylles ut av teamet før testen.

## Slik tester du

- Ta testcasene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med alvorlighetsgrad. Spørsmål underveis tas i Slack-tråden «Akseptansetesting Tilbudsgaranti i saksbehandlingen 2027».

**Slik åpner du søknadsalternativet i saken.** De fleste testcasene starter her, og stegene viser til denne framgangsmåten som «Åpne søknadsalternativet»:

1. Gå til «Søknadsbehandling» i menyen, og velg opptaket [Fylles ut: opptak] under «Velg Opptak».
2. Skriv inn søknadsnummeret i «Søknadsnummer» på siden «Saker på …», og åpne saken.
3. Velg «Søknadsalternativer» i skuffen til høyre.
4. Åpne søknadsalternativet ved å velge det i listen.

Under søknadsalternativet står de tre feltene «Tilbudsgaranti fra behandler», «Tilbudsgaranti fra tilbyder» og «Tilbudsgaranti fra forvalter». Feltet for rollen du har, er en nedtrekksliste. De andre feltene viser bare verdien.

**Slik bytter du testbruker:** logg ut fra menyen øverst til høyre [Sjekk begrep], og logg inn som den nye testbrukeren.

## Testcaser

## Oppgave: tilbudsgaranti

### Del 1: Gi tilbudsgaranti (gi_tilbudsgaranti.feature)

#### Regel: Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.1a | Sette tilbudsgaranti i feltet for rollen (saksbehandler) | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]) på https://test-fsadmin.sikt.no/. <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>3. Velg «Tilbudsgaranti innvilges etter klage» i «Tilbudsgaranti fra behandler». <br>4. Se at meldingen «Tilbudsgaranti lagret» vises. <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti innvilges etter klage» etter at saken er åpnet igjen. | | |
| 1.1b | Sette tilbudsgaranti i feltet for rollen (tilbyder) | 1. Logg inn som testbruker 2 ([Fylles ut: navn], tilbyder ved [Fylles ut: organisasjon B]). <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 2, som tilbys av organisasjon B] i søknaden til [Fylles ut: søker fra testdata 3]. <br>3. Velg «Tilbudsgaranti, særskilt vurdering» i «Tilbudsgaranti fra tilbyder». <br>4. Se at meldingen «Tilbudsgaranti lagret» vises. <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra tilbyder» viser «Tilbudsgaranti, særskilt vurdering» etter at saken er åpnet igjen. | | |
| 1.1c | Sette tilbudsgaranti i feltet for rollen (opptaksforvalter) | 1. Logg inn som testbruker 3 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: organisasjonen som forvalter opptaket]). <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>3. Velg «Tilbudsgaranti gitt etter telefonsamtale» i «Tilbudsgaranti fra forvalter». <br>4. Se at meldingen «Tilbudsgaranti lagret» vises. <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra forvalter» viser «Tilbudsgaranti gitt etter telefonsamtale» etter at saken er åpnet igjen. | | |
| 1.2 | Bare tilbudsgarantitypene for rollen kan velges | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>3. Åpne nedtrekkslisten «Tilbudsgaranti fra behandler», og se på valgene. | «Tilbudsgaranti, særskilt vurdering» (typen som bare kan brukes av tilbyder) er ikke et av valgene. «Tilbudsgaranti innvilges etter klage» er et av valgene. | | |
| 1.3 | Saksbehandler ser ikke muligheten til å sette tilbudsgaranti som tilbyder eller opptaksforvalter | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). Testbrukeren er ikke tilbyder eller opptaksforvalter for søknadsalternativet. <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 2, som tilbys av organisasjon B] i søknaden til [Fylles ut: søker fra testdata 3]. <br>3. Se på de tre feltene for tilbudsgaranti. | «Tilbudsgaranti fra behandler» er en nedtrekksliste. «Tilbudsgaranti fra tilbyder» og «Tilbudsgaranti fra forvalter» viser bare verdien, og kan ikke endres. | | |
| 1.4 | Se tilbudsgarantiene fra alle rollene | 1. Bruk søknadsalternativ 1 fra 1.1a og 1.1c, som har tilbudsgaranti fra behandler og fra forvalter. <br>2. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>3. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. | «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti innvilges etter klage», og «Tilbudsgaranti fra forvalter» viser «Tilbudsgaranti gitt etter telefonsamtale». | | |
| 1.5 | Sette tilbudsgaranti når søknaden ikke kan poengberegnes | 1. Logg inn som testbruker 2 ([Fylles ut: navn], tilbyder ved [Fylles ut: organisasjon B]). <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ som tilbys av organisasjon B] i søknaden som ikke kan poengberegnes ([Fylles ut: søker fra testdata 4]). <br>3. Velg «Tilbudsgaranti, særskilt vurdering» i «Tilbudsgaranti fra tilbyder». <br>4. Se at meldingen «Tilbudsgaranti lagret» vises. <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra tilbyder» viser «Tilbudsgaranti, særskilt vurdering» etter at saken er åpnet igjen. | | |

#### Regel: Tilbudsgarantien kan endres og fjernes av rollen som satte den

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.6 | Endre tilbudsgaranti | 1. Bruk søknadsalternativ 1 fra 1.1a, som har «Tilbudsgaranti innvilges etter klage» fra behandler. <br>2. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>3. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>4. Velg [Fylles ut: en annen type saksbehandler kan bruke, for eksempel «Reservert studieplass»] i «Tilbudsgaranti fra behandler». <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra behandler» viser den nye typen etter at saken er åpnet igjen. | | |
| 1.7 | Fjerne tilbudsgaranti | 1. Bruk søknadsalternativ 1 fra 1.6, som har tilbudsgaranti fra behandler. <br>2. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>3. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>4. Velg «Ikke valgt» i «Tilbudsgaranti fra behandler». <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra behandler» viser «Ikke valgt» etter at saken er åpnet igjen. | | |
| 1.8 | Tilbudsgarantien fra en annen rolle blir stående | 1. Bruk søknadsalternativ 1, som har «Tilbudsgaranti gitt etter telefonsamtale» fra forvalter (1.1c). <br>2. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>3. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>4. Velg «Tilbudsgaranti innvilges etter klage» i «Tilbudsgaranti fra behandler». <br>5. Velg «Ikke valgt» i «Tilbudsgaranti fra behandler». <br>6. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra behandler» viser «Ikke valgt», og «Tilbudsgaranti fra forvalter» viser fortsatt «Tilbudsgaranti gitt etter telefonsamtale». | | |
| 1.9 | Opptaksforvalter ser ikke muligheten til å endre tilbudsgarantien fra saksbehandler | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]), og velg «Tilbudsgaranti innvilges etter klage» i «Tilbudsgaranti fra behandler» på søknadsalternativ 1. <br>2. Bytt testbruker, og logg inn som testbruker 3 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: organisasjonen som forvalter opptaket]). Testbrukeren er ikke saksbehandler for saken. <br>3. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>4. Se på «Tilbudsgaranti fra behandler». | «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti innvilges etter klage», men er ikke en nedtrekksliste, og kan ikke endres eller fjernes. | | |

#### Regel: Tilbudsgarantitypene hører til opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.10 | Bare tilbudsgarantitypene i opptaket kan velges | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>3. Åpne nedtrekkslisten «Tilbudsgaranti fra behandler», og se på valgene. | [Fylles ut: typen som bare finnes i et annet opptak (testdata 2)] er ikke et av valgene. | | |

#### Regel: Endringer i tilbudsgarantien kan spores

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.11 | Se hvem som har satt tilbudsgarantien | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. Står det en tilbudsgaranti i «Tilbudsgaranti fra behandler», velg «Ikke valgt» først. <br>3. Velg «Tilbudsgaranti innvilges etter klage» i «Tilbudsgaranti fra behandler», og noter klokkeslettet. <br>4. Velg «Endringslogg» øverst i saken. | Endringsloggen har en rad med navnet til testbruker 1, tidspunktet du noterte, og teksten «Behandler satte tilbudsgarantien [Tilbudsgaranti innvilges etter klage] på [navnet på søknadsalternativ 1]». | | |
| 1.12 | Se hvem som har fjernet tilbudsgarantien | 1. Bruk søknadsalternativ 1 fra 1.11, som har tilbudsgaranti fra behandler. <br>2. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>3. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>4. Velg «Ikke valgt» i «Tilbudsgaranti fra behandler», og noter klokkeslettet. <br>5. Velg «Endringslogg» øverst i saken. | Endringsloggen har en rad med navnet til testbruker 1, tidspunktet du noterte, og teksten «Behandler fjernet tilbudsgarantien på [navnet på søknadsalternativ 1]». | | |
| 1.13 | Se hvilken tilbudsgarantitype som ble satt | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ 1] i søknaden til [Fylles ut: søker fra testdata 3]. <br>3. Velg [Fylles ut: en type saksbehandler kan bruke, for eksempel «Reservert studieplass»] i «Tilbudsgaranti fra behandler». <br>4. Velg «Endringslogg» øverst i saken. | Den nyeste raden i endringsloggen har navnet på typen du valgte i hakeparentes: «Behandler satte tilbudsgarantien [typen] på [navnet på søknadsalternativ 1]». | | |
| | | *Gjør klar til neste test: velg «Ikke valgt» i «Tilbudsgaranti fra behandler» på søknadsalternativ 1.* | | | |

Endringsloggen skriver «endret» i stedet for «satte» når det allerede sto en tilbudsgaranti i feltet. Kravet har ikke et eget scenario for det.

#### Regel: Tilbudsgarantien følger søknadsalternativet

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.14a | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (til prioritet 1) | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]), og velg «Tilbudsgaranti innvilges etter klage» i «Tilbudsgaranti fra behandler» på søknadsalternativet som er prioritet 2 i søknaden til testbruker 4. <br>2. Logg inn i Min kompetanse som testbruker 4 ([Fylles ut: navn], søker), og åpne søknaden [Sjekk begrep]. <br>3. Flytt søknadsalternativet fra prioritet 2 til prioritet 1, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1. <br>5. Åpne søknadsalternativet i søknaden til testbruker 4. | Søknadsalternativet står som prioritet 1, og «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti innvilges etter klage». | | |
| 1.14b | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (til prioritet 3) | 1. Bruk søknadsalternativet fra 1.14a, som har tilbudsgaranti fra behandler. Flytt det tilbake til prioritet 2 i Min kompetanse først. <br>2. Logg inn i Min kompetanse som testbruker 4 ([Fylles ut: navn], søker), og åpne søknaden [Sjekk begrep]. <br>3. Flytt søknadsalternativet fra prioritet 2 til prioritet 3, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>5. Åpne søknadsalternativet i søknaden til testbruker 4. | Søknadsalternativet står som prioritet 3, og «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti innvilges etter klage». | | |
| 1.14c | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (nytt søknadsalternativ som prioritet 1) | 1. Bruk søknadsalternativet fra 1.14a, som har tilbudsgaranti fra behandler. Flytt det tilbake til prioritet 2 i Min kompetanse først. <br>2. Logg inn i Min kompetanse som testbruker 4 ([Fylles ut: navn], søker), og åpne søknaden [Sjekk begrep]. <br>3. Legg til [Fylles ut: et nytt søknadsalternativ i opptaket] som prioritet 1, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>5. Åpne søknadsalternativet med tilbudsgarantien i søknaden til testbruker 4. | Søknadsalternativet står som prioritet 3, og «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti innvilges etter klage». | | |
| | | *Gjør klar til neste test: fjern det nye søknadsalternativet fra søknaden i Min kompetanse.* | | | |
| 1.15a | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (saksbehandler) | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>2. Åpne søknadsalternativet [Fylles ut: søknadsalternativ] i søknaden til [Fylles ut: søker fra testdata 5]. <br>3. Velg «Tilbudsgaranti innvilges etter klage» i «Tilbudsgaranti fra behandler». <br>4. Velg [Fylles ut: utdanningsbakgrunnen som gir en annen saksbehandlende organisasjon] i «Utdanningsbakgrunn» i saken, og velg «Endre utdanningsbakgrunn». <br>5. Bytt testbruker, og logg inn som testbruker 3 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: organisasjonen som forvalter opptaket]). <br>6. Åpne søknadsalternativet i søknaden til [Fylles ut: søker fra testdata 5]. | Saken ligger nå hos [Fylles ut: den nye saksbehandlende organisasjonen], og «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti innvilges etter klage». | | |
| 1.15b | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (tilbyder) | 1. Logg inn som testbruker 2 ([Fylles ut: navn], tilbyder ved [Fylles ut: organisasjon B]), og velg «Tilbudsgaranti, særskilt vurdering» i «Tilbudsgaranti fra tilbyder» på søknadsalternativet i søknaden til [Fylles ut: søker fra testdata 5, med utdanningsbakgrunnen satt tilbake]. <br>2. Bytt testbruker, og logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>3. Velg [Fylles ut: utdanningsbakgrunnen som gir en annen saksbehandlende organisasjon] i «Utdanningsbakgrunn» i saken, og velg «Endre utdanningsbakgrunn». <br>4. Bytt testbruker, og logg inn som testbruker 3 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: organisasjonen som forvalter opptaket]). <br>5. Åpne søknadsalternativet i søknaden. | Saken ligger nå hos [Fylles ut: den nye saksbehandlende organisasjonen], og «Tilbudsgaranti fra tilbyder» viser fortsatt «Tilbudsgaranti, særskilt vurdering». | | |
| 1.15c | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (opptaksforvalter) | 1. Logg inn som testbruker 3 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: organisasjonen som forvalter opptaket]), og velg «Tilbudsgaranti gitt etter telefonsamtale» i «Tilbudsgaranti fra forvalter» på søknadsalternativet i søknaden til [Fylles ut: søker fra testdata 5, med utdanningsbakgrunnen satt tilbake]. <br>2. Bytt testbruker, og logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>3. Velg [Fylles ut: utdanningsbakgrunnen som gir en annen saksbehandlende organisasjon] i «Utdanningsbakgrunn» i saken, og velg «Endre utdanningsbakgrunn». <br>4. Bytt testbruker, og logg inn som testbruker 3. <br>5. Åpne søknadsalternativet i søknaden. | Saken ligger nå hos [Fylles ut: den nye saksbehandlende organisasjonen], og «Tilbudsgaranti fra forvalter» viser fortsatt «Tilbudsgaranti gitt etter telefonsamtale». | | |
| 1.16a | Tilbudsgarantien faller bort når søknadsalternativet fjernes (fjerner søknadsalternativet) | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]), og velg «Tilbudsgaranti innvilges etter klage» i «Tilbudsgaranti fra behandler» på søknadsalternativet som er prioritet 1 i søknaden til testbruker 4. <br>2. Logg inn i Min kompetanse som testbruker 4 ([Fylles ut: navn], søker), og åpne søknaden [Sjekk begrep]. <br>3. Fjern søknadsalternativet fra søknaden, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1. <br>5. Åpne saken til testbruker 4, og velg «Søknadsalternativer» i skuffen. | Søknadsalternativet står ikke i listen, og har ikke lenger tilbudsgaranti. | | |
| 1.16b | Tilbudsgarantien faller bort når søknadsalternativet fjernes (trekker søknaden) | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]), og velg «Tilbudsgaranti innvilges etter klage» i «Tilbudsgaranti fra behandler» på søknadsalternativet som er prioritet 1 i søknaden til [Fylles ut: søker fra testdata 6]. <br>2. Logg inn i Min kompetanse som søkeren fra testdata 6, og trekk søknaden [Sjekk begrep]. <br>3. Bytt testbruker, og logg inn i FS Admin som testbruker 1. <br>4. Åpne saken til søkeren, og velg «Søknadsalternativer» i skuffen. | Søknaden er trukket, og søknadsalternativet har ikke lenger tilbudsgaranti. | | |
| 1.17a | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen (prioritet 1) | 1. Bruk søknadsalternativet fra 1.16a, som testbruker 4 har fjernet fra søknaden. Søknadsfristen i opptaket har ikke gått ut. <br>2. Logg inn i Min kompetanse som testbruker 4 ([Fylles ut: navn], søker), og åpne søknaden [Sjekk begrep]. <br>3. Legg inn søknadsalternativet igjen som prioritet 1, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>5. Åpne søknadsalternativet i søknaden til testbruker 4. | Søknadsalternativet står som prioritet 1, og «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti innvilges etter klage» igjen. | | |
| 1.17b | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen (prioritet 2) | 1. Bruk søknadsalternativet fra 1.17a. Fjern det fra søknaden i Min kompetanse først. <br>2. Logg inn i Min kompetanse som testbruker 4 ([Fylles ut: navn], søker), og åpne søknaden [Sjekk begrep]. <br>3. Legg inn søknadsalternativet igjen som prioritet 2, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>5. Åpne søknadsalternativet i søknaden til testbruker 4. | Søknadsalternativet står som prioritet 2, og «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti innvilges etter klage» igjen. | | |

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| – | Alle scenarioene kan testes når testbrukerne og testdataene er på plass | – |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Forvalte tilbudsgarantityper | Kommer senere. Tilbudsgarantitypene legges inn per opptak for 2027 |
| Reservert studieplass | Kommer senere, satt på vent |
| Tilbudsgaranti fra tidligopptaket | Testes i en annen leveranse (tidlig opptak) |
| At søkeren med tilbudsgaranti får tilbud i plasstildelingen | Testes i en annen leveranse (plasstildeling) |
| Hvilken utdanningskvote tilbudsgarantiene tas fra | Testes i en annen leveranse (utdanningstilbud) |
| Velge utdanningskvote for tilbudsgaranti | Kommer senere |

## Funn

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig.

## Andre funn

Det du oppdager som ikke gjelder testcasene, for eksempel brukervennlighet, eller et tilfelle kravet ikke dekker. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et viktig tilfelle, legges det inn i kravet.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
