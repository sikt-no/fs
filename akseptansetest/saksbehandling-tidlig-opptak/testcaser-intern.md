# Intern akseptansetest – Saksbehandling av tidlig opptak

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786
- **Scope**: –
- **Krav**: 2 feature-filer, commit `5605e7e` (2026-10-27)
- **Verifisering**: verify-finne_søknader_om_tidlig_opptak-2026-10-26-1441.md (6 av 6 funnet), verify-vurdere_søknad_om_tidlig_opptak-2026-10-26-1441.md (9 av 9 funnet)
- **Skjermens ord**: fs-admin `e93c74d2e` (origin/main, 2026-10-27)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5149065264
- **Laget**: 2026-10-27 av fs-testcaser-intern
- **Sporing**:

  | Nr | Feature-ID | Regel | Scenario |
  |---|---|---|---|
  | 1.1 | `@OPT-BEH-BEH-009` | Søk og filtrering av saker på tidlig opptak | Filteret for tidlig opptak er ikke i bruk som standard |
  | 1.2a | `@OPT-BEH-BEH-009` | Søk og filtrering av saker på tidlig opptak | Filtrere på tidlig opptak (søkeren har søkt om tidlig opptak) |
  | 1.2b | `@OPT-BEH-BEH-009` | Søk og filtrering av saker på tidlig opptak | Filtrere på tidlig opptak (konklusjonen for tidlig opptak mangler) |
  | 1.2c | `@OPT-BEH-BEH-009` | Søk og filtrering av saker på tidlig opptak | Filtrere på tidlig opptak (saken har konklusjon for tidlig opptak) |
  | 1.3 | `@OPT-BEH-BEH-009` | Søk og filtrering av saker på tidlig opptak | Saker der søkeren ikke har søkt, mangler ikke konklusjon |
  | 1.4 | `@OPT-BEH-BEH-009` | Søk og filtrering av saker på tidlig opptak | Valgene for konklusjon kombineres med eller |
  | 1.5 | `@OPT-BEH-BEH-009` | Søk og filtrering av saker på tidlig opptak | Søkt om tidlig opptak kombineres med valgene for konklusjon med og |
  | 1.6 | `@OPT-BEH-BEH-009` | Søk og filtrering av saker på tidlig opptak | Filteret for tidlig opptak kombineres med saksbehandlingsstatus |
  | 2.1 | `@OPT-BEH-BEH-013` | Saksbehandler ser søkerens grunnlag for tidlig opptak | Se søkerens begrunnelse for tidlig opptak |
  | 2.2 | `@OPT-BEH-BEH-013` | Saksbehandler ser søkerens grunnlag for tidlig opptak | Se dokumentasjonskrav for begrunnelsen |
  | 2.3 | `@OPT-BEH-BEH-013` | Saksbehandler konkluderer om søkeren deltar i tidligopptaket | Velge blant konklusjonene opptaket har |
  | 2.4a | `@OPT-BEH-BEH-013` | Saksbehandler konkluderer om søkeren deltar i tidligopptaket | Konkludere om søkeren deltar i tidligopptaket (KFF – deltar) |
  | 2.4b | `@OPT-BEH-BEH-013` | Saksbehandler konkluderer om søkeren deltar i tidligopptaket | Konkludere om søkeren deltar i tidligopptaket (KIF – ikke deltar) |
  | 2.5 | `@OPT-BEH-BEH-013` | Saksbehandler konkluderer om søkeren deltar i tidligopptaket | Konkludere før dokumentasjonsfristen har gått ut |
  | 2.6 | `@OPT-BEH-BEH-013` | Saksbehandler konkluderer om søkeren deltar i tidligopptaket | Søknad uten ønske om tidlig opptak viser ikke tidlig opptak |
  | 2.7 | `@OPT-BEH-BEH-013` | Saksbehandler konkluderer om søkeren deltar i tidligopptaket | Konklusjon per organisasjon |
  | 2.8 | `@OPT-BEH-BEH-013` | Konklusjonen kan endres også etter at tidligopptaket er gjennomført | Endre konklusjon før tidligopptaket er gjennomført |
  | 2.9 | `@OPT-BEH-BEH-013` | Konklusjonen kan endres også etter at tidligopptaket er gjennomført | Endre konklusjonen etter at tidligopptaket er gjennomført |

---

Intern akseptansetest av «Saksbehandling av tidlig opptak». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786). Felt med gul bakgrunn fylles ut av teamet før testen.

Testcasene bruker disse søkerne fra testdataene i testplanen. Alle sakene behandles ved organisasjonen til testbruker 1, ellers ser ikke testbruker 1 dem i sakslisten. Navnene og søknadsnumrene fylles ut av teamet.

| Søker | Søkt om tidlig opptak | Konklusjon for tidlig opptak | Behandlingsstatus | Navn og søknadsnummer |
|---|---|---|---|---|
| Søker A | ja | «KFF – Kan få tidlig opptak, har godkjent grunn» | Behandlet | [Fylles ut: navn og søknadsnummer] |
| Søker B | ja | ingen | Ikke behandlet | [Fylles ut: navn og søknadsnummer] |
| Søker C | ja | «KIF – Kan ikke få tidlig opptak, mangler grunn» | Under behandling | [Fylles ut: navn og søknadsnummer] |
| Søker D | nei | ingen | Ikke behandlet | [Fylles ut: navn og søknadsnummer] |
| Søker E | ja, med søknadsalternativer ved organisasjonen til testbruker 1 og testbruker 2 | ingen | Ikke behandlet | [Fylles ut: navn og søknadsnummer] |
| Søker F | ja, i et opptak der tidligopptaket er gjennomført, med tilbudsgaranti fra tidligopptaket | «KFF – Kan få tidlig opptak, har godkjent grunn» | Behandlet | [Fylles ut: opptak, navn og søknadsnummer] |

Konklusjonene heter kanskje noe annet i opptaket. Står det andre navn i «Konklusjon», bruk den som gir deltakelse der det står «KFF», og den som ikke gir deltakelse der det står «KIF». [Fylles ut: navnene på konklusjonene i opptaket]

## Slik tester du

- Ta testcasene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med alvorlighetsgrad. Spørsmål underveis tas i Slack-tråden «Akseptansetesting Saksbehandling av tidlig opptak».
- Er listen lang, kan du skrive søknadsnummeret i «Søknadsnummer» for å se om en søknad er med. Fjern det igjen før neste testcase.

## Testcaser

### Del 1: Finne søknader om tidlig opptak (finne_søknader_om_tidlig_opptak.feature)

#### Regel: Søk og filtrering av saker på tidlig opptak

Filteret «Tidlig opptak» vises bare når minst én sak i opptaket treffer et av valgene.

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.1 | Filteret for tidlig opptak er ikke i bruk som standard | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>2. Gå til «Søknadsbehandling». <br>3. Velg opptaket [Fylles ut: opptak] i «Velg Opptak». <br>4. Se på filteret «Tidlig opptak» og på listen «Saker i opptak». | Ingen av valgene i «Tidlig opptak» («Har søkt tidlig opptak», «Mangler konklusjon på tidlig opptak», «Har konklusjon på tidlig opptak») er krysset av. Listen viser søknadene til søker A, B, C og D. | | |
| 1.2a | Filtrere på tidlig opptak (søkeren har søkt om tidlig opptak) | 1. Fortsett fra 1.1. <br>2. Kryss av for «Har søkt tidlig opptak» i «Tidlig opptak». | Listen viser søknadene til søker A, B og C. Søknaden til søker D vises ikke. | | |
| | | *Gjør klar til neste test: fjern krysset for «Har søkt tidlig opptak».* | | | |
| 1.2b | Filtrere på tidlig opptak (konklusjonen for tidlig opptak mangler) | 1. Fortsett fra 1.2a. <br>2. Kryss av for «Mangler konklusjon på tidlig opptak» i «Tidlig opptak». | Listen viser søknaden til søker B. Søknadene til søker A, C og D vises ikke. | | |
| | | *Gjør klar til neste test: fjern krysset for «Mangler konklusjon på tidlig opptak».* | | | |
| 1.2c | Filtrere på tidlig opptak (saken har konklusjon for tidlig opptak) | 1. Fortsett fra 1.2b. <br>2. Kryss av for «Har konklusjon på tidlig opptak» i «Tidlig opptak». | Listen viser søknadene til søker A og C. Søknadene til søker B og D vises ikke. | | |
| | | *Gjør klar til neste test: fjern krysset for «Har konklusjon på tidlig opptak».* | | | |
| 1.3 | Saker der søkeren ikke har søkt, mangler ikke konklusjon | 1. Fortsett fra 1.2c. <br>2. Kryss av for «Mangler konklusjon på tidlig opptak» i «Tidlig opptak». <br>3. Skriv søknadsnummeret til søker D i «Søknadsnummer». | Søknaden til søker D vises ikke, selv om søker D ikke har noen konklusjon. | | |
| | | *Gjør klar til neste test: tøm «Søknadsnummer», og fjern krysset for «Mangler konklusjon på tidlig opptak».* | | | |
| 1.4 | Valgene for konklusjon kombineres med eller | 1. Fortsett fra 1.3. <br>2. Kryss av for «Mangler konklusjon på tidlig opptak» i «Tidlig opptak». <br>3. Kryss av for «Har konklusjon på tidlig opptak» i «Tidlig opptak». | Listen viser søknadene til søker A, B og C. Søknaden til søker D vises ikke. | | |
| | | *Gjør klar til neste test: fjern begge kryssene.* | | | |
| 1.5 | Søkt om tidlig opptak kombineres med valgene for konklusjon med og | 1. Fortsett fra 1.4. <br>2. Kryss av for «Har søkt tidlig opptak» i «Tidlig opptak». <br>3. Kryss av for «Mangler konklusjon på tidlig opptak» i «Tidlig opptak». | Listen viser søknaden til søker B. Søknadene til søker A, C og D vises ikke. | | |
| | | *Gjør klar til neste test: fjern begge kryssene.* | | | |
| 1.6 | Filteret for tidlig opptak kombineres med saksbehandlingsstatus | 1. Fortsett fra 1.5. <br>2. Kryss av for «Har konklusjon på tidlig opptak» i «Tidlig opptak». <br>3. Kryss av for «Under behandling» i «Behandlingsstatus». | Listen viser søknaden til søker C. Søknadene til søker A, B og D vises ikke. | | |
| | | *Gjør klar til neste test: fjern begge kryssene.* | | | |

### Del 2: Vurdere søknad om tidlig opptak (vurdere_søknad_om_tidlig_opptak.feature)

#### Regel: Saksbehandler ser søkerens grunnlag for tidlig opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.1 | Se søkerens begrunnelse for tidlig opptak | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>2. Gå til «Søknadsbehandling», og velg opptaket [Fylles ut: opptak]. <br>3. Velg «Gå til sak» på søknaden til søker B. <br>4. Gå til steget «Tidlig opptak». | Steget «Tidlig opptak» finnes i saken. Under «Begrunnelse fra søker» står [Fylles ut: teksten for begrunnelsen søker B valgte]. | | |
| 2.2 | Se dokumentasjonskrav for begrunnelsen | 1. Fortsett fra 2.1. <br>2. Se på «Dokumentasjonskrav» i steget «Tidlig opptak». | Under «Dokumentasjonskrav» står [Fylles ut: dokumentasjonskravet for begrunnelsen søker B valgte]. | | |

#### Regel: Saksbehandler konkluderer om søkeren deltar i tidligopptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.3 | Velge blant konklusjonene opptaket har | 1. Fortsett fra 2.2. <br>2. Åpne nedtrekkslisten «Konklusjon». | Listen har «Ikke valgt» og konklusjonene i opptaket: [Fylles ut: navnene på konklusjonene, f.eks. «KFF – Kan få tidlig opptak, har godkjent grunn» og «KIF – Kan ikke få tidlig opptak, mangler grunn»], og ingen andre. | | |
| 2.4a | Konkludere om søkeren deltar i tidligopptaket (KFF – deltar) | 1. Fortsett fra 2.3. <br>2. Velg «KFF – Kan få tidlig opptak, har godkjent grunn» i «Konklusjon». <br>3. Velg «Lagre og avslutt». <br>4. Velg «Gå til sak» på søknaden til søker B igjen, og gå til steget «Tidlig opptak». | Meldingen «Konklusjonen er lagret» vises etter steg 2. Når saken åpnes igjen, står «KFF – Kan få tidlig opptak, har godkjent grunn» i «Konklusjon». | | |
| 2.4b | Konkludere om søkeren deltar i tidligopptaket (KIF – ikke deltar) | 1. Fortsett fra 2.4a. <br>2. Velg «KIF – Kan ikke få tidlig opptak, mangler grunn» i «Konklusjon». <br>3. Velg «Lagre og avslutt». <br>4. Velg «Gå til sak» på søknaden til søker B igjen, og gå til steget «Tidlig opptak». | Meldingen «Konklusjonen er lagret» vises etter steg 2. Når saken åpnes igjen, står «KIF – Kan ikke få tidlig opptak, mangler grunn» i «Konklusjon». | | |
| 2.5 | Konkludere før dokumentasjonsfristen har gått ut | 1. Sjekk at dokumentasjonsfristen for tidlig opptak i opptaket ikke har gått ut: [Fylles ut: fristen]. <br>2. Fortsett fra 2.4b, i saken til søker B. <br>3. Velg «KFF – Kan få tidlig opptak, har godkjent grunn» i «Konklusjon». <br>4. Velg «Lagre og avslutt». <br>5. Velg «Gå til sak» på søknaden til søker B igjen, og gå til steget «Tidlig opptak». | «Konklusjon» kan velges selv om fristen ikke har gått ut. Når saken åpnes igjen, står «KFF – Kan få tidlig opptak, har godkjent grunn» i «Konklusjon». | | |
| | | *Gjør klar til neste test: velg «Ikke valgt» i «Konklusjon» for søker B, så søker B igjen er uten konklusjon.* | | | |
| 2.6 | Søknad uten ønske om tidlig opptak viser ikke tidlig opptak | 1. Gå tilbake til «Saker i opptak». <br>2. Velg «Gå til sak» på søknaden til søker D. <br>3. Se på stegene i saken. | Steget «Tidlig opptak» finnes ikke i saken. | | |
| 2.7 | Konklusjon per organisasjon | 1. Velg «Gå til sak» på søknaden til søker E, og gå til steget «Tidlig opptak». <br>2. Velg «KFF – Kan få tidlig opptak, har godkjent grunn» i «Konklusjon». <br>3. Logg ut, og logg inn som testbruker 2 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon B]). [Fylles ut: hvordan man bytter testbruker i testmiljøet] <br>4. Gå til «Søknadsbehandling», og velg opptaket [Fylles ut: opptak]. <br>5. Velg «Gå til sak» på søknaden til søker E, og gå til steget «Tidlig opptak». <br>6. Velg «KIF – Kan ikke få tidlig opptak, mangler grunn» i «Konklusjon». <br>7. Velg «Lagre og avslutt», og åpne saken til søker E igjen. <br>8. Logg ut, og logg inn som testbruker 1 igjen. <br>9. Åpne saken til søker E, og gå til steget «Tidlig opptak». | Etter steg 7 står «KIF – Kan ikke få tidlig opptak, mangler grunn» i «Konklusjon» for testbruker 2. Etter steg 9 står fortsatt «KFF – Kan få tidlig opptak, har godkjent grunn» i «Konklusjon» for testbruker 1. | | |
| | | *Gjør klar til neste test: velg «Ikke valgt» i «Konklusjon» for søker E, som testbruker 1 og som testbruker 2.* | | | |

#### Regel: Konklusjonen kan endres også etter at tidligopptaket er gjennomført

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.8 | Endre konklusjon før tidligopptaket er gjennomført | 1. Logg inn som testbruker 1 ([Fylles ut: navn], saksbehandler ved [Fylles ut: organisasjon A]). <br>2. Gå til «Søknadsbehandling», og velg opptaket [Fylles ut: opptak] (der tidligopptaket ikke er gjennomført). <br>3. Velg «Gå til sak» på søknaden til søker A, og gå til steget «Tidlig opptak». <br>4. Velg «KIF – Kan ikke få tidlig opptak, mangler grunn» i «Konklusjon». <br>5. Velg «Lagre og avslutt», og åpne saken til søker A igjen. | Når saken åpnes igjen, står «KIF – Kan ikke få tidlig opptak, mangler grunn» i «Konklusjon». | | |
| | | *Gjør klar til neste test: velg «KFF – Kan få tidlig opptak, har godkjent grunn» i «Konklusjon» for søker A igjen.* | | | |
| 2.9 | Endre konklusjonen etter at tidligopptaket er gjennomført | 1. Gå til «Søknadsbehandling», og velg opptaket der tidligopptaket er gjennomført: [Fylles ut: opptak]. <br>2. Velg «Gå til sak» på søknaden til søker F. <br>3. Velg «Vis» på «Skuff», og velg fanen «Søknadsalternativer». <br>4. Noter tilbudsgarantien i «Tilbudsgaranti fra forvalter» på [Fylles ut: søknadsalternativet med tilbudsgaranti fra tidligopptaket]. <br>5. Gå til steget «Tidlig opptak». <br>6. Velg «KIF – Kan ikke få tidlig opptak, mangler grunn» i «Konklusjon». <br>7. Velg «Lagre og avslutt», og åpne saken til søker F igjen. <br>8. Velg «Vis» på «Skuff», og velg fanen «Søknadsalternativer». | Konklusjonen kan endres: «KIF – Kan ikke få tidlig opptak, mangler grunn» står i «Konklusjon» når saken åpnes igjen. I «Tilbudsgaranti fra forvalter» står fortsatt den samme tilbudsgarantien som i steg 4. | | |
| | | *Gjør klar til neste test: velg «KFF – Kan få tidlig opptak, har godkjent grunn» i «Konklusjon» for søker F igjen.* | | | |

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| Konklusjon per organisasjon (2.7): at søknadsalternativet ved organisasjon A er med i tidligopptaket, og søknadsalternativet ved organisasjon B ikke er det | Det ses først når opptaksforvalteren prøvekjører eller gjennomfører tidligopptaket, og det er ikke med i denne testen. Testcasen sjekker at konklusjonene lagres hver for seg. | Når gjennomføringen av tidligopptaket testes |
| Endre konklusjonen etter at tidligopptaket er gjennomført (2.9): at svaret søkeren har fått på tidlig opptak ikke er endret | Det ses av søkeren i Min kompetanse, og testplanen har ingen testbruker for søkeren | Når teamet legger til en testbruker for søker F, kan det legges inn som steg i 2.9 |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Søke om tidlig opptak | Testes i en annen leveranse. Søknadene saksbehandleren behandler, er testdata. |
| Gjennomføre tidligopptaket og gi tilbudsgaranti | Testes i en annen leveranse. Opptaket der tidligopptaket er gjennomført, er testdata. |
| Publisere svar på tidlig opptak, og svaret søkeren ser | Testes i en annen leveranse |
| Søknadsmangel når dokumentasjonen mangler | Saksbehandleren bruker de vanlige søknadsmanglene, som testes for seg |

## Funn

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

## Andre funn

Det du oppdager som ikke gjelder testcasene, for eksempel brukervennlighet, eller et tilfelle kravet ikke dekker. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et viktig tilfelle, legges det inn i kravet.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
