# Intern akseptansetest – Tilbudsgaranti i saksbehandlingen 2027

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130158105
- **Scope**: @scope-tilbudsgaranti-2027
- **Krav**: 1 feature-fil, commit `6478bee` (2026-10-22)
- **Verifisering**: [verify-2026-10-22-0850.md](../../tasks/opptak/tilbudsgaranti/spec/verify-2026-10-22-0850.md), 17 av 17 funnet
- **Ordene fra skjermen**: fs-admin `ba0ec3ef70` (de 8 nyere commitene på main rører ikke saksbehandlingen), endringsloggen fra fs-plattform `0229f59fb3`. Min kompetanse er ikke lest, så stegene for søkeren er merket `[Sjekk begrep]`
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130289193
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
  | 1.6 | `@OPT-BEH-BEH-010` | Tilbudsgarantien kan endres og fjernes av rollen som satte den | Endre tilbudsgaranti |
  | 1.7 | `@OPT-BEH-BEH-010` | Tilbudsgarantien kan endres og fjernes av rollen som satte den | Fjerne tilbudsgaranti |
  | 1.8 | `@OPT-BEH-BEH-010` | Tilbudsgarantien kan endres og fjernes av rollen som satte den | Tilbudsgarantien fra en annen rolle blir stående |
  | 1.9 | `@OPT-BEH-BEH-010` | Tilbudsgarantien kan endres og fjernes av rollen som satte den | Opptaksforvalter ser ikke muligheten til å endre tilbudsgarantien fra saksbehandler |
  | 1.10 | `@OPT-BEH-BEH-010` | Tilbudsgarantitypene hører til opptaket | Bare tilbudsgarantitypene i opptaket kan velges |
  | 1.11 | `@OPT-BEH-BEH-010` | Endringer i tilbudsgarantien kan spores | Se hvem som har satt tilbudsgarantien |
  | 1.12 | `@OPT-BEH-BEH-010` | Endringer i tilbudsgarantien kan spores | Se hvem som har fjernet tilbudsgarantien |
  | 1.13 | `@OPT-BEH-BEH-010` | Endringer i tilbudsgarantien kan spores | Se hvilken tilbudsgarantitype som ble satt |
  | 1.14a | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (flyttes ned fra prioritet 1 til 2) |
  | 1.14b | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (flyttes opp fra prioritet 2 til 1) |
  | 1.15 | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (saksbehandler, tilbyder og opptaksforvalter, i én gjennomkjøring) |
  | 1.16a | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien faller bort når søknadsalternativet fjernes (fjerner søknadsalternativet) |
  | 1.16b | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien faller bort når søknadsalternativet fjernes (trekker søknaden) |
  | 1.17a | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen (prioritet 1) |
  | 1.17b | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen (prioritet 2) |

---

Intern akseptansetest av «Tilbudsgaranti i saksbehandlingen 2027». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130158105). Felt med gul bakgrunn fylles ut av teamet før testen.

## Slik tester du

- Ta testcasene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med alvorlighetsgrad. Spørsmål underveis tas i Slack-tråden «Akseptansetesting Tilbudsgaranti i saksbehandlingen 2027».

**Slik åpner du søknadsalternativet i saken.** De fleste testcasene starter her, og stegene viser til denne framgangsmåten som «Åpne søknadsalternativet»:

1. Gå til «Søknadsbehandling» i menyen, og velg opptaket «Samordna UHG-simulering høsten 2026» (opptak 34) under «Velg Opptak».
2. Skriv inn søknadsnummeret i «Søknadsnummer» på siden «Saker på …», og åpne saken.
3. Velg «Søknadsalternativer» i skuffen til høyre.
4. Åpne søknadsalternativet ved å velge det i listen.

Testcasene bruker søknadsalternativ 1, «Elektronisk systemingeniør - bachelor i ingeniørfag» ved NTNU, Trondheim, i søknaden til Overbevisende Havhest (søknadsnummer 1000836).

Under søknadsalternativet står de tre feltene «Tilbudsgaranti fra behandler», «Tilbudsgaranti fra tilbyder» og «Tilbudsgaranti fra forvalter». Feltet for rollen du har, er en nedtrekksliste. De andre feltene viser bare verdien.

Søkeren endrer søknaden i Min kompetanse: https://test.minkompetanse.no/nb/soknader/c29rbmFkOjU2NDE3ZjlhLTYxMTItNDRlYS1hMmRiLThmOGFkMzJlY2FkYiwzNA

**Slik bytter du testbruker:** logg ut fra menyen øverst til høyre [Sjekk begrep], og logg inn som den nye testbrukeren.

## Testcaser

## Oppgave: tilbudsgaranti

### Del 1: Gi tilbudsgaranti (gi_tilbudsgaranti.feature)

#### Regel: Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.1a | Sette tilbudsgaranti i feltet for rollen (saksbehandler) | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU) på https://test-fsadmin.sikt.no/. <br>2. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>3. Velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler». <br>4. Se at meldingen «Tilbudsgaranti lagret» vises. <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti etter ny vurdering» etter at saken er åpnet igjen. | | |
| 1.1b | Sette tilbudsgaranti i feltet for rollen (tilbyder) | 1. Logg inn som testbruker 2 (Ansvarsfull Fotkrem - OPPTAK_FORVALTER, tilbyder ved NTNU). <br>2. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>3. Velg «Tilbudsgaranti etter realkompetansevurd.» i «Tilbudsgaranti fra tilbyder». <br>4. Se at meldingen «Tilbudsgaranti lagret» vises. <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra tilbyder» viser «Tilbudsgaranti etter realkompetansevurd.» etter at saken er åpnet igjen. | | |
| 1.1c | Sette tilbudsgaranti i feltet for rollen (opptaksforvalter) | 1. Logg inn som testbruker 3 (Ordentlig Rundskriv - OPPTAK_FORVALTER_OG_OPPTAK_SAKSBEHANDLER, opptaksforvalter ved HK-dir). <br>2. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>3. Velg «Tilbudsgaranti, forhåndsløfte» i «Tilbudsgaranti fra forvalter». <br>4. Se at meldingen «Tilbudsgaranti lagret» vises. <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra forvalter» viser «Tilbudsgaranti, forhåndsløfte» etter at saken er åpnet igjen. | | |
| 1.2 | Bare tilbudsgarantitypene for rollen kan velges | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>2. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>3. Åpne nedtrekkslisten «Tilbudsgaranti fra behandler», og se på valgene. | «Tilbudsgaranti etter realkompetansevurd.» (typen som bare kan brukes av tilbyder) er ikke et av valgene. «Tilbudsgaranti etter ny vurdering» er et av valgene. | | |
| 1.3 | Saksbehandler ser ikke muligheten til å sette tilbudsgaranti som tilbyder eller opptaksforvalter | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). Testbrukeren er ikke tilbyder eller opptaksforvalter for søknadsalternativet. <br>2. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>3. Se på de tre feltene for tilbudsgaranti. | «Tilbudsgaranti fra behandler» er en nedtrekksliste. «Tilbudsgaranti fra tilbyder» og «Tilbudsgaranti fra forvalter» viser bare verdien, og kan ikke endres. | | |
| 1.4 | Se tilbudsgarantiene fra alle rollene | 1. Bruk søknadsalternativ 1 fra 1.1a og 1.1c, som har tilbudsgaranti fra behandler og fra forvalter. <br>2. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>3. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). | «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti etter ny vurdering», og «Tilbudsgaranti fra forvalter» viser «Tilbudsgaranti, forhåndsløfte». | | |

#### Regel: Tilbudsgarantien kan endres og fjernes av rollen som satte den

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.6 | Endre tilbudsgaranti | 1. Bruk søknadsalternativ 1 fra 1.1a, som har «Tilbudsgaranti etter ny vurdering» fra behandler. <br>2. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>3. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>4. Velg «Tilbudsgaranti pga reservert plass» i «Tilbudsgaranti fra behandler». <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti pga reservert plass» etter at saken er åpnet igjen. | | |
| 1.7 | Fjerne tilbudsgaranti | 1. Bruk søknadsalternativ 1 fra 1.6, som har tilbudsgaranti fra behandler. <br>2. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>3. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>4. Velg «Ikke valgt» i «Tilbudsgaranti fra behandler». <br>5. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra behandler» viser «Ikke valgt» etter at saken er åpnet igjen. | | |
| 1.8 | Tilbudsgarantien fra en annen rolle blir stående | 1. Bruk søknadsalternativ 1, som har «Tilbudsgaranti, forhåndsløfte» fra forvalter (1.1c). <br>2. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>3. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>4. Velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler». <br>5. Velg «Ikke valgt» i «Tilbudsgaranti fra behandler». <br>6. Lukk saken, og åpne søknadsalternativet igjen. | «Tilbudsgaranti fra behandler» viser «Ikke valgt», og «Tilbudsgaranti fra forvalter» viser fortsatt «Tilbudsgaranti, forhåndsløfte». | | |
| 1.9 | Opptaksforvalter ser ikke muligheten til å endre tilbudsgarantien fra saksbehandler | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU), og velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler» på søknadsalternativ 1. <br>2. Bytt testbruker, og logg inn som testbruker 3 (Ordentlig Rundskriv - OPPTAK_FORVALTER_OG_OPPTAK_SAKSBEHANDLER, opptaksforvalter ved HK-dir). Testbrukeren er ikke saksbehandler for saken. <br>3. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>4. Se på «Tilbudsgaranti fra behandler». | «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti etter ny vurdering», men er ikke en nedtrekksliste, og kan ikke endres eller fjernes. | | |

#### Regel: Tilbudsgarantitypene hører til opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.10 | Bare tilbudsgarantitypene i opptaket kan velges | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>2. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>3. Åpne nedtrekkslisten «Tilbudsgaranti fra behandler», og se på valgene. | «Tilbudsgaranti gitt etter telefonsamtale», som bare finnes i opptak 1, er ikke et av valgene. | | |

#### Regel: Endringer i tilbudsgarantien kan spores

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.11 | Se hvem som har satt tilbudsgarantien | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>2. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). Står det en tilbudsgaranti i «Tilbudsgaranti fra behandler», velg «Ikke valgt» først. <br>3. Velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler», og noter klokkeslettet. <br>4. Velg «Endringslogg» øverst i saken. | Endringsloggen har en rad med navnet til testbruker 1, tidspunktet du noterte, og teksten «Behandler satte tilbudsgarantien [Tilbudsgaranti etter ny vurdering] på [Elektronisk systemingeniør - bachelor i ingeniørfag]». | | |
| 1.12 | Se hvem som har fjernet tilbudsgarantien | 1. Bruk søknadsalternativ 1 fra 1.11, som har tilbudsgaranti fra behandler. <br>2. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>3. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>4. Velg «Ikke valgt» i «Tilbudsgaranti fra behandler», og noter klokkeslettet. <br>5. Velg «Endringslogg» øverst i saken. | Endringsloggen har en rad med navnet til testbruker 1, tidspunktet du noterte, og teksten «Behandler fjernet tilbudsgarantien på [Elektronisk systemingeniør - bachelor i ingeniørfag]». | | |
| 1.13 | Se hvilken tilbudsgarantitype som ble satt | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>2. Åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» (søknadsalternativ 1) i søknaden til Overbevisende Havhest (søknadsnummer 1000836). <br>3. Velg «Tilbudsgaranti pga reservert plass» i «Tilbudsgaranti fra behandler». <br>4. Velg «Endringslogg» øverst i saken. | Den nyeste raden i endringsloggen har navnet på typen i hakeparentes: «Behandler satte tilbudsgarantien [Tilbudsgaranti pga reservert plass] på [Elektronisk systemingeniør - bachelor i ingeniørfag]». | | |
| | | *Gjør klar til neste test: velg «Ikke valgt» i «Tilbudsgaranti fra behandler» på søknadsalternativ 1.* | | | |

Endringsloggen skriver «endret» i stedet for «satte» når det allerede sto en tilbudsgaranti i feltet. Kravet har ikke et eget scenario for det.

#### Regel: Tilbudsgarantien følger søknadsalternativet

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.14a | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (flyttes ned fra prioritet 1 til 2) | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU), og velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler» på søknadsalternativ 1, som er prioritet 1 i søknaden til testbruker 4. <br>2. Logg inn i Min kompetanse som testbruker 4 (Overbevisende Havhest, søker, fnr 29900598090), og åpne søknaden [Sjekk begrep]. <br>3. Flytt søknadsalternativ 1 ned til prioritet 2, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1. <br>5. Åpne søknadsalternativ 1 i søknaden til testbruker 4. | Søknadsalternativ 1 står som prioritet 2, og «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti etter ny vurdering». | | |
| 1.14b | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (flyttes opp fra prioritet 2 til 1) | 1. Bruk søknadsalternativ 1 fra 1.14a, som er prioritet 2 og har tilbudsgaranti fra behandler. <br>2. Logg inn i Min kompetanse som testbruker 4 (Overbevisende Havhest, søker, fnr 29900598090), og åpne søknaden [Sjekk begrep]. <br>3. Flytt søknadsalternativ 1 opp til prioritet 1, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>5. Åpne søknadsalternativ 1 i søknaden til testbruker 4. | Søknadsalternativ 1 står som prioritet 1, og «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti etter ny vurdering». | | |
| 1.16a | Tilbudsgarantien faller bort når søknadsalternativet fjernes (fjerner søknadsalternativet) | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU), og velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler» på søknadsalternativet som er prioritet 1 i søknaden til testbruker 4. <br>2. Logg inn i Min kompetanse som testbruker 4 (Overbevisende Havhest, søker, fnr 29900598090), og åpne søknaden [Sjekk begrep]. <br>3. Fjern søknadsalternativet fra søknaden, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1. <br>5. Åpne saken til testbruker 4, og velg «Søknadsalternativer» i skuffen. | Søknadsalternativet står ikke i listen, og har ikke lenger tilbudsgaranti. | | |
| 1.16b | Tilbudsgarantien faller bort når søknadsalternativet fjernes (trekker søknaden) | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU), og velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler» på søknadsalternativet som er prioritet 1 i søknaden til testbruker 4. <br>2. Logg inn i Min kompetanse som testbruker 4 (Overbevisende Havhest, søker, fnr 29900598090), og trekk søknaden [Sjekk begrep]. <br>3. Bytt testbruker, og logg inn i FS Admin som testbruker 1. <br>4. Åpne saken til søkeren, og velg «Søknadsalternativer» i skuffen. | Søknaden er trukket, og søknadsalternativet har ikke lenger tilbudsgaranti. | | |
| | | *Gjør klar til neste test: gjenopprett søknaden i Min kompetanse [Sjekk begrep]. Søknadsalternativ 1 er fortsatt fjernet fra 1.16a.* | | | |
| 1.17a | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen (prioritet 1) | 1. Bruk søknadsalternativet fra 1.16a, som testbruker 4 har fjernet fra søknaden. Søknadsfristen i opptaket har ikke gått ut. <br>2. Logg inn i Min kompetanse som testbruker 4 (Overbevisende Havhest, søker, fnr 29900598090), og åpne søknaden [Sjekk begrep]. <br>3. Legg inn søknadsalternativet igjen som prioritet 1, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>5. Åpne søknadsalternativet i søknaden til testbruker 4. | Søknadsalternativet står som prioritet 1, og «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti etter ny vurdering» igjen. | | |
| 1.17b | Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen (prioritet 2) | 1. Bruk søknadsalternativet fra 1.17a. Fjern det fra søknaden i Min kompetanse først. <br>2. Logg inn i Min kompetanse som testbruker 4 (Overbevisende Havhest, søker, fnr 29900598090), og åpne søknaden [Sjekk begrep]. <br>3. Legg inn søknadsalternativet igjen som prioritet 2, og lagre søknaden [Sjekk begrep]. <br>4. Bytt testbruker, og logg inn i FS Admin som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>5. Åpne søknadsalternativet i søknaden til testbruker 4. | Søknadsalternativet står som prioritet 2, og «Tilbudsgaranti fra behandler» viser «Tilbudsgaranti etter ny vurdering» igjen. | | |
| | | *Gjør klar til neste test: søknadsalternativ 1 skal være prioritet 1, uten tilbudsgaranti. Etter 1.15 kan søknaden ikke brukes til flere tester.* | | | |
| 1.15 | Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon (saksbehandler, tilbyder og opptaksforvalter) | 1. Logg inn som testbruker 1 (Ansvarsfull Fotkrem - OPPTAK_SAKSBEHANDLER, saksbehandler ved NTNU). <br>2. Åpne søknadsalternativ 1 i søknaden til testbruker 4. <br>3. Velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler». <br>4. Bytt testbruker, og logg inn som testbruker 2 (Ansvarsfull Fotkrem - OPPTAK_FORVALTER, tilbyder ved NTNU). Åpne det samme søknadsalternativet. <br>5. Velg «Tilbudsgaranti etter realkompetansevurd.» i «Tilbudsgaranti fra tilbyder». <br>6. Bytt testbruker, og logg inn som testbruker 3 (Ordentlig Rundskriv - OPPTAK_FORVALTER_OG_OPPTAK_SAKSBEHANDLER, opptaksforvalter ved HK-dir). Åpne det samme søknadsalternativet. <br>7. Velg «Tilbudsgaranti, forhåndsløfte» i «Tilbudsgaranti fra forvalter». <br>8. Bytt testbruker, og logg inn som testbruker 1. Velg «Utenlandsk videregående skole» i «Utdanningsbakgrunn» i saken, og velg «Endre utdanningsbakgrunn». <br>9. Bytt testbruker, og logg inn som testbruker 3. Åpne søknadsalternativet i søknaden. | Saken ligger nå hos HK-dir. «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti etter ny vurdering», «Tilbudsgaranti fra tilbyder» viser «Tilbudsgaranti etter realkompetansevurd.», og «Tilbudsgaranti fra forvalter» viser «Tilbudsgaranti, forhåndsløfte». | | |

1.15 tar de tre eksemplene i scenariomalen (saksbehandler, tilbyder og opptaksforvalter) i én gjennomkjøring, og kjøres sist: når saken først er flyttet, kommer den ikke tilbake til den første organisasjonen, selv om utdanningsbakgrunnen settes tilbake.

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
| Sette tilbudsgaranti når søknaden ikke kan poengberegnes (1.5) | Testes senere |
| Et nytt søknadsalternativ legges over søknadsalternativet med tilbudsgaranti (tidligere 1.14c) | Ikke relevant: tilbudsgarantien er knyttet til søknadsalternativet, ikke til prioriteten, så et nytt søknadsalternativ endrer ikke tilbudsgarantien. Flyttingen ned og opp i 1.14a og 1.14b tester det samme |

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
