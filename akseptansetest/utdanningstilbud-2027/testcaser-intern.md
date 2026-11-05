# Intern akseptansetest – Utdanningstilbud i samordna opptak 2027

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137235987
- **Scope**: @scope-utdanningstilbud-i-opptak-2027, @scope-utdanningstilbud-2027
- **Krav**: 15 feature-filer, commit `b67676a` (2026-10-23)
- **Verifisering**: verify-02 Utdanningstilbud i opptak-2026-10-22-1915.md (21 av 40 funnet), verify-04 Behandle et utdanningstilbud-2026-10-22-1915.md (23 av 31 funnet)
- **Skjermens ord**: fs-admin `origin/main` `be244a345` (2026-10-23). Ingen av kravene har `.design.md`, og oppgavene har ingen skisser.
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5136613418
- **Laget**: 2026-10-23 av fs-testcaser-intern. Oppdatert 2026-10-26 med testbrukerne, opptaket og fasene fra testplanen, og sortert i blokker (én testbruker i én fase) for å teste raskere.
- **Sporing**:

  | Nr | Feature-ID | Regel | Scenario |
  |---|---|---|---|
  | 1.1 | `@OPT-OPT-UTD-026` | Utdanningstilbud kan fjernes før opptaket åpner for søknad | Fjerne utdanningstilbud før søknadsåpning |
  | 1.2 | `@OPT-OPT-UTD-026` | Utdanningstilbud kan fjernes før opptaket åpner for søknad | Fjerne flere utdanningstilbud av gangen før søknadsåpning |
  | 1.3 | `@OPT-OPT-UTD-026` | Utdanningstilbud kan ikke fjernes etter at opptaket har åpnet for søknad | Fjerning av utdanningstilbud etter søknadsåpning avvises |
  | 1.4 | `@OPT-OPT-UTD-026` | Opptaksforvalter ved deltakende organisasjon kan fjerne utdanningstilbud organisasjonen tilbyr, fram til redigeringsfristen | Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen |
  | 1.5 | `@OPT-OPT-UTD-026` | Opptaksforvalter ved deltakende organisasjon kan fjerne utdanningstilbud organisasjonen tilbyr, fram til redigeringsfristen | Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen |
  | 2.1 | `@OPT-OPT-UTD-002` | Opptaksforvalter ved deltakende organisasjon kan legge til enkelttilbud | Legge til enkelttilbud fra organisasjonen opptaksforvalter er ved |
  | 2.2 | `@OPT-OPT-UTD-002` | Opptaksforvalter kan legge til flere utdanningstilbud av gangen | Legge til flere utdanningstilbud av gangen |
  | 2.3 | `@OPT-OPT-UTD-002` | Opptaksforvalter ved forvaltende organisasjon kan legge til utdanningstilbud for alle deltakende organisasjoner | Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon |
  | 2.5 | `@OPT-OPT-UTD-002` | Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering | Kan ikke knytte utdanningstilbud til opptaket før redigering åpner |
  | 2.6 | `@OPT-OPT-UTD-002` | Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering | Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering |
  | 2.7 | `@OPT-OPT-UTD-002` | Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering | Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger |
  | 2.8 | `@OPT-OPT-UTD-002` | Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering | Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger |
  | 3.1 | `@OPT-OPT-UTD-001` | Grunndata fra utdanningsregisteret vises tydelig | Se grunndata om utdanning |
  | 3.2 | `@OPT-OPT-UTD-001` | Opptaksforvalter ved forvaltende organisasjon kan filtrere på organisasjon | Filtrere på organisasjon som opptaksforvalter ved forvaltende organisasjon |
  | 3.3 | `@OPT-OPT-UTD-001` | Opptaksforvalter kan filtrere på starttermin og startår | Filtrere på starttermin og startår |
  | 3.4 | `@OPT-OPT-UTD-001` | Opptaksforvalter kan filtrere på navn på studieprogram | Fritekst-søk på studieprogramnavn |
  | 3.5 | `@OPT-OPT-UTD-001` | Opptaksforvalter kan filtrere på utdanningstilbud med ufullstendige opplysninger | Filtrere på utdanningstilbud som mangler kompetanseregelverk |
  | 3.6 | `@OPT-OPT-UTD-001` | Opptaksforvalter kan filtrere på utdanningstilbud med ufullstendige opplysninger | Filtrere på utdanningstilbud som mangler rangeringsregelverk |
  | 3.7 | `@OPT-OPT-UTD-001` | Opptaksforvalter ved deltakende organisasjon ser kun utdanningstilbud organisasjonen tilbyr | Deltakende organisasjon ser kun utdanningstilbudene sine |
  | 3.8 | `@OPT-OPT-UTD-001` | Opptaksforvalter ved deltakende organisasjon ser kun utdanningstilbud organisasjonen tilbyr | Deltakende organisasjon ser ikke utdanningstilbud en annen organisasjon tilbyr |
  | 3.9 | `@OPT-OVO-SAM-001` | Organisasjoner som ikke deltar, kan ikke se opptaket | Organisasjon som ikke deltar, ser ikke opptaket |
  | 3.10 | `@OPT-OVO-SAM-001` | Organisasjoner som ikke deltar, kan ikke se opptaket | Organisasjon som ikke deltar, kan ikke åpne opptaket |
  | 4.1 | `@OPT-OPT-UTD-003` | Opptaksforvalter ved deltakende organisasjon eller forvaltende organisasjon kan trekke utdanningstilbud | Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud |
  | 4.2 | `@OPT-OPT-UTD-003` | Trekking er ikke mulig etter trekkfristen for deltakende organisasjoner | Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen |
  | 5.1a | `@OPT-OPT-UTD-016` | Beskrivelse til Min kompetanse kan angis per språk | Angi beskrivelse på <språk> (bokmål) |
  | 5.1b | `@OPT-OPT-UTD-016` | Beskrivelse til Min kompetanse kan angis per språk | Angi beskrivelse på <språk> (nynorsk) |
  | 5.1c | `@OPT-OPT-UTD-016` | Beskrivelse til Min kompetanse kan angis per språk | Angi beskrivelse på <språk> (engelsk) |
  | 5.1d | `@OPT-OPT-UTD-016` | Beskrivelse til Min kompetanse kan angis per språk | Angi beskrivelse på <språk> (nordsamisk) |
  | 6.1 | `@OPT-OPT-UTD-022` | Informasjon om studieavgift kan angis på utdanningstilbudet | Registrere informasjon om studieavgift |
  | 6.2 | `@OPT-OPT-UTD-022` | Informasjon om studieavgift kan angis på utdanningstilbudet | Se informasjon om studieavgift |
  | 7.1 | `@OPT-OPT-UTD-017` | Søkeord kan angis på utdanningstilbudet | Legge til søkeord på utdanningstilbud |
  | 7.2 | `@OPT-OPT-UTD-017` | Søkeord kan angis på utdanningstilbudet | Legge til flere søkeord på samme utdanningstilbud |
  | 7.3 | `@OPT-OPT-UTD-017` | Søkeord kan angis på utdanningstilbudet | Fjerne søkeord fra utdanningstilbud |
  | 8.1 | `@OPT-OPT-UTD-013` | Kvoteflyt registreres ikke lenger på utdanningstilbudet | Kvoteflyt kan ikke registreres på utdanningstilbudet |
  | 9.1 | `@OPT-OPT-UTD-015` | Standardregel for poenglikhet vises på utdanningstilbudet | Se standardregel for poenglikhet |
  | 9.2 | `@OPT-OPT-UTD-015` | Regel for poenglikhet kan overstyres på utdanningstilbudet | Overstyre regel for poenglikhet |
  | 9.3 | `@OPT-OPT-UTD-015` | Regel for poenglikhet kan overstyres på utdanningstilbudet | Kun regler tilgjengelige for opptaket kan velges |
  | 10.1 | `@OPT-OPT-UTD-012` | Planlagt antall studieplasser kan registreres | Registrere planlagt antall studieplasser |
  | 10.2 | `@OPT-OPT-UTD-012` | Planlagt antall studieplasser kan registreres | Se planlagt antall studieplasser |
  | 11.1 | `@OPT-OPT-UTD-010` | Poenggrense for årets tidligopptak kan registreres og vises | Registrere poenggrense for tidligopptak |
  | 11.2 | `@OPT-OPT-UTD-010` | Poenggrense for årets tidligopptak kan registreres og vises | Se registrert poenggrense for tidligopptak |
  | 12.1 | `@OPT-OPT-UTD-014` | Krav om politiattest kan registreres | Registrere krav om politiattest |
  | 12.2 | `@OPT-OPT-UTD-014` | Krav om medisinsk attest kan registreres | Registrere krav om medisinsk attest |
  | 13.1 | `@OPT-OPT-UTD-011` | Studietypenummer kan påføres utdanningstilbudet | Registrere studietypenummer på utdanningstilbud |
  | 13.2 | `@OPT-OPT-UTD-011` | Studietypenummer kan påføres utdanningstilbudet | Se studietypenummer på utdanningstilbud |
  | 14.1 | `@OPT-OPT-UTD-025` | Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud | Sette tidlig søknadsfrist |
  | 14.2 | `@OPT-OPT-UTD-025` | Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud | Sette tidlig dokumentasjonsfrist |
  | 15.1 | `@OPT-OPT-UTD-009` | URL til beskrivelse hentes fra utdanningsregisteret og vises | Se URL til beskrivelse av utdanningstilbudet |
  | 15.2 | `@OPT-OPT-UTD-009` | URL til beskrivelse hentes fra utdanningsregisteret og vises | Utdanningstilbud uten beskrivelses-URL |

---

Intern akseptansetest av «Utdanningstilbud i samordna opptak 2027». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137235987).

Testen har 49 testcaser og tar 1,5–3 timer. Den er delt i to økter: økt 1 er blokk A–F (fase 1 og 2, 18 testcaser), og økt 2 er blokk G–L (detaljsiden for et utdanningstilbud, og så fase 3–5, 31 testcaser).

## Slik tester du

- Ta blokkene i rekkefølge, fra A til L, og testcasene i den rekkefølgen de står i blokken. Følg stegene slik de står. Nummeret viser hvilket krav testcasen hører til. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med alvorlighetsgrad. Spørsmål underveis tas i Slack-tråden «Akseptansetesting Utdanningstilbud i samordna opptak 2027».
- Logg inn hver testbruker i sitt eget nettleservindu, med en egen Chrome-profil eller et inkognitovindu. Da logger hver testbruker inn bare én gang, og du bytter vindu mellom blokkene. [Sjekk: at innlogging med Feide i test-fsadmin virker i flere vinduer samtidig]
- Testmiljøet er [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/). Har du bare ett vindu, bytter du testbruker ved å logge ut (menyen øverst til høyre) og logge inn igjen som den nye testbrukeren. [Sjekk begrep: hvordan man logger ut og bytter bruker i test-fsadmin]
- Slik kommer du til utdanningstilbudene i et opptak: velg «Opptak» på forsiden, velg opptaket i lista, og velg «Gå til utdanningstilbud» i kortet «Utdanningstilbud».

Alle testcasene bruker opptaket «Sektordemo 23.10.26». Opptaket må være i ulike tilstander, og testbruker 1 (ORDENTLIG RUNDSKRIV) flytter fristene i opptaket i blokk A, C, H, I og K. Hver blokk er én testbruker i én fase, så du bytter testbruker bare mellom blokkene. Du velger selv hvilke utdanningstilbud og utdanninger du bruker, så lenge de passer med testcasen. Fjerning og trekking kan ikke angres, og ingenting trenger å settes tilbake etter testen. Testbrukerne og testdataene står i testplanen.

| Blokk | Testbruker | Fristene i Sektordemo 23.10.26 | Testcaser |
|---|---|---|---|
| A | testbruker 1 (ORDENTLIG RUNDSKRIV) | Sett fase 1: redigering av utdanningstilbud åpner i morgen | – |
| B | testbruker 2 (KORT DOMPAPP UiT) | Fase 1 | 2.5 |
| C | testbruker 1 (ORDENTLIG RUNDSKRIV) | Sett fase 2: redigering er åpen, og søknad er ikke åpnet | 1.1, 1.2, 2.3, 3.1–3.6 |
| D | testbruker 2 (KORT DOMPAPP UiT) | Fase 2 | 2.1, 2.2, 2.6, 1.4 |
| E | testbruker 3 (KORT DOMPAPP UIO) | Fase 2 | 3.7, 3.8 |
| F | testbruker 4 (VENNLIG SKOG HiØ) | Fase 2 | 3.9, 3.10 |
| G | testbruker 1 (ORDENTLIG RUNDSKRIV) | Fase 2 | 5.1a–15.2, alt på detaljsiden for et utdanningstilbud |
| H | testbruker 1 (ORDENTLIG RUNDSKRIV) | Sett fase 3: søknad er åpnet, og redigering er fortsatt åpen | 1.3 |
| I | testbruker 1 (ORDENTLIG RUNDSKRIV) | Sett fase 4: redigering er stengt, og trekkfristen er ikke passert | 2.8, 4.1 |
| J | testbruker 2 (KORT DOMPAPP UiT) | Fase 4 | 1.5, 2.7 |
| K | testbruker 1 (ORDENTLIG RUNDSKRIV) | Sett fase 5: trekkfristen er passert | – |
| L | testbruker 2 (KORT DOMPAPP UiT) | Fase 5 | 4.2 |

## Testcaser

## Økt 1: blokk A–F (fase 1 og 2)

### Blokk A: testbruker 1 (ORDENTLIG RUNDSKRIV), setter fase 1

Logg inn som testbruker 1 (ORDENTLIG RUNDSKRIV, opptaksforvalter ved Sikt). Sett fristene i Sektordemo 23.10.26 slik at redigering av utdanningstilbud åpner i morgen (fase 1).

### Blokk B: testbruker 2 (KORT DOMPAPP UiT), fase 1

Logg inn som testbruker 2 (KORT DOMPAPP UiT, opptaksforvalter ved UiT Norges arktiske universitet).

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 2.5 | Legge til utdanningstilbud i opptak <br>Regel: Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering | Kan ikke knytte utdanningstilbud til opptaket før redigering åpner | 1. Gå til «Opptak», og velg opptaket «Sektordemo 23.10.26». <br>2. Se på kortet «Utdanningstilbud» under «Oppgaver». | Kortet viser «Redigering åpner [dato]» i stedet for «Gå til utdanningstilbud». Testbruker 2 kommer ikke til lista, og kan ikke legge til utdanningstilbud. | | |

### Blokk C: testbruker 1 (ORDENTLIG RUNDSKRIV), setter fase 2

Bytt til testbruker 1 (ORDENTLIG RUNDSKRIV, opptaksforvalter ved Sikt). Sett fristene slik at redigering av utdanningstilbud er åpen, og søknad ikke er åpnet (fase 2). Gå til «Opptak», velg «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». Kopier adressen til siden fra adressefeltet, og ta vare på den til blokk F.

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 1.1 | Fjerne utdanningstilbud fra opptak <br>Regel: Utdanningstilbud kan fjernes før opptaket åpner for søknad | Fjerne utdanningstilbud før søknadsåpning | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Kryss av for et utdanningstilbud du velger. <br>3. Velg «Handlinger», og velg «Fjern utdanningstilbud». <br>4. Les dialogen «Fjern utdanningstilbud», og velg «Fjern». <br>5. Last siden på nytt. | Dialogen spør «Er du sikker på at du vil fjerne ett utdanningstilbud fra dette opptaket?». Etter «Fjern» vises meldingen «1 utdanningstilbud ble fjernet». Utdanningstilbudet står ikke lenger i lista, heller ikke etter at siden er lastet på nytt. | | |
| 1.2 | Fjerne utdanningstilbud fra opptak <br>Regel: Utdanningstilbud kan fjernes før opptaket åpner for søknad | Fjerne flere utdanningstilbud av gangen før søknadsåpning | 1. Bruk det samme opptaket som i 1.1. <br>2. Kryss av for to andre utdanningstilbud du velger. <br>3. Velg «Handlinger», og velg «Fjern utdanningstilbud». <br>4. Velg «Fjern» i dialogen. <br>5. Last siden på nytt. | Dialogen spør «Er du sikker på at du vil fjerne 2 utdanningstilbud fra dette opptaket?». Etter «Fjern» vises meldingen «2 utdanningstilbud ble fjernet». Ingen av de to utdanningstilbudene står i lista, heller ikke etter at siden er lastet på nytt. | | |
| 2.3 | Legge til utdanningstilbud i opptak <br>Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til utdanningstilbud for alle deltakende organisasjoner | Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>3. Velg «UiT Norges arktiske universitet» i «Organisasjon». <br>4. Kryss av for en utdanning ved UiT som du velger i «Resultater». <br>5. Velg «Legg til (1)». <br>6. Last siden på nytt. | Meldingen «Utdanningstilbud lagt til» vises. Utdanningstilbudet står i lista over utdanningstilbud i opptaket, med «UiT» i «Organisasjon», også etter at siden er lastet på nytt. | | |
| 3.1 | Listevisning og søk i utdanningstilbud i opptaket <br>Regel: Grunndata fra utdanningsregisteret vises tydelig | Se grunndata om utdanning | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg et utdanningstilbud i lista. <br>3. Se på delen «Basisinformasjon». | «Basisinformasjon» er merket «Kilde: Utdanningsregisteret». Delen viser navnet («Navn (bokmål)» og de andre språkene), «Utdanningsnivå», «Institusjon», «Studiested» og «Studiepoeng», med verdier fra utdanningsregisteret. Feltene i «Basisinformasjon» kan ikke endres med «Rediger». | | |
| 3.2 | Listevisning og søk i utdanningstilbud i opptaket <br>Regel: Opptaksforvalter ved forvaltende organisasjon kan filtrere på organisasjon | Filtrere på organisasjon som opptaksforvalter ved forvaltende organisasjon | 1. Gå til lista over utdanningstilbud i det samme opptaket som i 3.1. <br>2. Velg «UiT» i filteret «Organisasjon». | Lista viser bare utdanningstilbud med «UiT» i «Organisasjon». | | |
| | | | *Gjør klar til neste test: velg «Fjern alle filtre».* | | | |
| 3.3 | Listevisning og søk i utdanningstilbud i opptaket <br>Regel: Opptaksforvalter kan filtrere på starttermin og startår | Filtrere på starttermin og startår | 1. Gå til lista over utdanningstilbud i det samme opptaket. <br>2. Velg «2027 Høst» i filteret «Oppstart». [Sjekk begrep: valget i testdataene] <br>3. Velg «Høst» i filteret «Termin». [Sjekk begrep] | Lista viser bare utdanningstilbud med oppstart høst 2027 i kolonnen «Oppstart». | | |
| | | | *Gjør klar til neste test: velg «Fjern alle filtre».* | | | |
| 3.4 | Listevisning og søk i utdanningstilbud i opptaket <br>Regel: Opptaksforvalter kan filtrere på navn på studieprogram | Fritekst-søk på studieprogramnavn | 1. Gå til lista over utdanningstilbud i det samme opptaket. <br>2. Skriv inn en del av navnet på et utdanningstilbud i opptaket, for eksempel «sykepleie», i «Søk». | Lista viser bare utdanningstilbud med søketeksten i navnet, og filteret vises som «Søk: [søketeksten]». | | |
| | | | *Gjør klar til neste test: velg «Fjern alle filtre».* | | | |
| 3.5 | Listevisning og søk i utdanningstilbud i opptaket <br>Regel: Opptaksforvalter kan filtrere på utdanningstilbud med ufullstendige opplysninger | Filtrere på utdanningstilbud som mangler kompetanseregelverk | 1. Gå til lista over utdanningstilbud i det samme opptaket. <br>2. Velg «Har mangler» i filteret «Status». | Lista viser utdanningstilbudene uten kompetanseregelverk, med «Ikke valgt» i «Kompetanseregelverk» og «Har mangler» i «Status». Ingen av radene har «OK» i «Status». | | |
| 3.6 | Listevisning og søk i utdanningstilbud i opptaket <br>Regel: Opptaksforvalter kan filtrere på utdanningstilbud med ufullstendige opplysninger | Filtrere på utdanningstilbud som mangler rangeringsregelverk | 1. Behold «Har mangler» valgt i filteret «Status». <br>2. Se gjennom kolonnen «Rangeringsregelverk» i lista. | Lista viser utdanningstilbudene uten rangeringsregelverk, med «Ikke valgt» i «Rangeringsregelverk» og «Har mangler» i «Status». | | |
| | | | *Gjør klar til neste test: velg «Fjern alle filtre».* | | | |

### Blokk D: testbruker 2 (KORT DOMPAPP UiT), fase 2

Bytt til testbruker 2 (KORT DOMPAPP UiT, opptaksforvalter ved UiT Norges arktiske universitet).

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 2.1 | Legge til utdanningstilbud i opptak <br>Regel: Opptaksforvalter ved deltakende organisasjon kan legge til enkelttilbud | Legge til enkelttilbud fra organisasjonen opptaksforvalter er ved | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>3. Skriv inn minst 3 tegn av navnet på en utdanning ved UiT i «Utdanningsnavn». <br>4. Kryss av for en utdanning du velger i «Resultater». <br>5. Velg «Legg til (1)». <br>6. Last siden på nytt. | Meldingen «Utdanningstilbud lagt til» vises. Utdanningstilbudet står i lista over utdanningstilbud i opptaket, med «UiT» i «Organisasjon», også etter at siden er lastet på nytt. | | |
| 2.2 | Legge til utdanningstilbud i opptak <br>Regel: Opptaksforvalter kan legge til flere utdanningstilbud av gangen | Legge til flere utdanningstilbud av gangen | 1. Bruk det samme opptaket som i 2.1. <br>2. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>3. Kryss av for to utdanninger du velger i «Resultater». <br>4. Velg «Legg til (2)». <br>5. Last siden på nytt. | Meldingen «Utdanningstilbud lagt til» vises. Begge utdanningstilbudene står i lista over utdanningstilbud i opptaket, også etter at siden er lastet på nytt. | | |
| 2.6 | Legge til utdanningstilbud i opptak <br>Regel: Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering | Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Se at øverst står «Redigeringsfrist» med en dato fram i tid. <br>3. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>4. Kryss av for en utdanning du velger, og velg «Legg til (1)». <br>5. Velg utdanningstilbudet i lista for å åpne det. <br>6. Velg «Rediger». <br>7. Skriv inn «100» i «Planlagte studieplasser». <br>8. Velg «Lagre». <br>9. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Utdanningstilbudet står i lista etter steg 5. På detaljsiden vises «Rediger». Etter «Lagre» vises «Endringene er lagret.», og «Planlagte studieplasser» viser 100 når utdanningstilbudet åpnes igjen. | | |
| 1.4 | Fjerne utdanningstilbud fra opptak <br>Regel: Opptaksforvalter ved deltakende organisasjon kan fjerne utdanningstilbud organisasjonen tilbyr, fram til redigeringsfristen | Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Se at øverst står «Redigeringsfrist» med en dato fram i tid. <br>3. Kryss av for et utdanningstilbud som UiT tilbyr. <br>4. Velg «Handlinger», og velg «Fjern utdanningstilbud». <br>5. Velg «Fjern» i dialogen. <br>6. Last siden på nytt. | Meldingen «1 utdanningstilbud ble fjernet» vises. Utdanningstilbudet står ikke lenger i lista, heller ikke etter at siden er lastet på nytt. | | |

### Blokk E: testbruker 3 (KORT DOMPAPP UIO), fase 2

Logg inn som testbruker 3 (KORT DOMPAPP UIO, opptaksforvalter ved Universitetet i Oslo).

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 3.7 | Listevisning og søk i utdanningstilbud i opptaket <br>Regel: Opptaksforvalter ved deltakende organisasjon ser kun utdanningstilbud organisasjonen tilbyr | Deltakende organisasjon ser kun utdanningstilbudene sine | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Se gjennom kolonnen «Organisasjon» i lista. | Lista viser bare utdanningstilbud med «UiO» i «Organisasjon». | | |
| 3.8 | Listevisning og søk i utdanningstilbud i opptaket <br>Regel: Opptaksforvalter ved deltakende organisasjon ser kun utdanningstilbud organisasjonen tilbyr | Deltakende organisasjon ser ikke utdanningstilbud en annen organisasjon tilbyr | 1. Gå til lista over utdanningstilbud i Sektordemo 23.10.26. <br>2. Skriv inn navnet på et utdanningstilbud som UiT tilbyr, for eksempel det fra 2.1, i «Søk». | Utdanningstilbudet som UiT tilbyr, står ikke i lista. | | |

Kjent mangel: verifiseringen 2026-10-22 fant at en deltakende organisasjon ser alle utdanningstilbudene i opptaket. Ser testbruker 3 utdanningstilbud fra andre organisasjoner, skriv det i «Faktisk resultat», og sett «Ikke bestått». Avviket føres som en kjent mangel, og gir ikke «Ikke godkjent» alene.

### Blokk F: testbruker 4 (VENNLIG SKOG HiØ), fase 2

Logg inn som testbruker 4 (VENNLIG SKOG HiØ, opptaksforvalter ved Høgskolen i Østfold). Høgskolen i Østfold deltar ikke i Sektordemo 23.10.26.

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 3.9 | Samordna opptak <br>Regel: Organisasjoner som ikke deltar, kan ikke se opptaket | Organisasjon som ikke deltar, ser ikke opptaket | 1. Gå til «Opptak». <br>2. Se gjennom lista over opptak. | «Sektordemo 23.10.26» står ikke i lista over opptak, og testbruker 4 ser ingen av utdanningstilbudene i opptaket. | | |
| 3.10 | Samordna opptak <br>Regel: Organisasjoner som ikke deltar, kan ikke se opptaket | Organisasjon som ikke deltar, kan ikke åpne opptaket | 1. Lim inn adressen til siden «Utdanningstilbud» i Sektordemo 23.10.26, som testbruker 1 kopierte i blokk C, i adressefeltet, og gå til siden. | Testbruker 4 ser verken opptaket eller utdanningstilbudene i det. | | |

Kjent mangel: verifiseringen av opprette og vedlikeholde opptak 2026-10-19 fant ikke at organisasjoner som ikke deltar, er stengt ute fra opptaket. Ser testbruker 4 opptaket eller utdanningstilbudene i det, skriv det i «Faktisk resultat», og sett «Ikke bestått». Avviket føres som en kjent mangel, og gir ikke «Ikke godkjent» alene.

## Økt 2: blokk G–L (detaljsiden, så fase 3–5)

Mellom øktene står opptaket i fase 2.

### Blokk G: testbruker 1 (ORDENTLIG RUNDSKRIV), fase 2

Bytt til testbruker 1 (ORDENTLIG RUNDSKRIV, opptaksforvalter ved Sikt). Testcasene i blokken gjøres på detaljsiden for et utdanningstilbud du velger i Sektordemo 23.10.26, med mindre noe annet står. Utdanningstilbudet må ha kompetanseregelverk og rangeringsregelverk, ellers kan det ikke lagres.

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 5.1a | Angi beskrivelse av utdanningstilbudet til Min kompetanse <br>Regel: Beskrivelse til Min kompetanse kan angis per språk | Angi beskrivelse på bokmål | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg et utdanningstilbud med kompetanseregelverk og rangeringsregelverk. <br>3. Velg «Rediger». <br>4. Velg fanen «Bokmål» under «Beskrivelse som vises for søker» i delen «Min kompetanse». <br>5. Skriv inn «Akseptansetest: beskrivelse på bokmål.» i beskrivelsesfeltet. <br>6. Velg «Lagre». <br>7. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». Under «Beskrivelse (bokmål)» står «Akseptansetest: beskrivelse på bokmål.» når utdanningstilbudet åpnes igjen, og merket ved «Beskrivelse som vises for søker» viser «1 av 4 språk». | | |
| 5.1b | Angi beskrivelse av utdanningstilbudet til Min kompetanse <br>Regel: Beskrivelse til Min kompetanse kan angis per språk | Angi beskrivelse på nynorsk | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg fanen «Nynorsk». <br>4. Skriv inn «Akseptansetest: skildring på nynorsk.» i beskrivelsesfeltet. <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Under «Beskrivelse (nynorsk)» står «Akseptansetest: skildring på nynorsk.», og merket viser «2 av 4 språk». | | |
| 5.1c | Angi beskrivelse av utdanningstilbudet til Min kompetanse <br>Regel: Beskrivelse til Min kompetanse kan angis per språk | Angi beskrivelse på engelsk | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg fanen «Engelsk». <br>4. Skriv inn «Acceptance test: description in English.» i beskrivelsesfeltet. <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Under «Beskrivelse (engelsk)» står «Acceptance test: description in English.», og merket viser «3 av 4 språk». | | |
| 5.1d | Angi beskrivelse av utdanningstilbudet til Min kompetanse <br>Regel: Beskrivelse til Min kompetanse kan angis per språk | Angi beskrivelse på nordsamisk | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg fanen «Samisk». <br>4. Skriv inn «Akseptansetest: válddahus sámegillii.» i beskrivelsesfeltet. <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Under «Beskrivelse (samisk)» står «Akseptansetest: válddahus sámegillii.», og merket viser «4 av 4 språk» i grønt. | | |
| 6.1 | Angi informasjon om studieavgift <br>Regel: Informasjon om studieavgift kan angis på utdanningstilbudet | Registrere informasjon om studieavgift | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg «Ja» i «Har utdanningstilbudet studieavgift?» i delen «Studietypenummer og studieavgift». <br>4. Velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». | | |
| 6.2 | Angi informasjon om studieavgift <br>Regel: Informasjon om studieavgift kan angis på utdanningstilbudet | Se informasjon om studieavgift | 1. Bruk utdanningstilbudet fra 6.1. <br>2. Se på delen «Studietypenummer og studieavgift». | «Studieavgift» viser «Ja». | | |
| | | | *Søkeordene heter «Tags» i løsningen.* | | | |
| 7.1 | Angi søkeord på utdanningstilbudet <br>Regel: Søkeord kan angis på utdanningstilbudet | Legge til søkeord på utdanningstilbud | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Tags» i delen «Min kompetanse». <br>4. Skriv inn «Lege» i søkefeltet. <br>5. Velg «Lege» blant forslagene, eller «Legg til «Lege»» hvis det ikke finnes. <br>6. Lukk menyen, og velg «Lagre». <br>7. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». «Tags» viser «Lege» når utdanningstilbudet åpnes igjen. | | |
| 7.2 | Angi søkeord på utdanningstilbudet <br>Regel: Søkeord kan angis på utdanningstilbudet | Legge til flere søkeord på samme utdanningstilbud | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Tags», skriv inn «Design», og velg «Design» eller «Legg til «Design»». <br>4. Se at «Lege» fortsatt er krysset av. <br>5. Lukk menyen, og velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | «Tags» viser både «Lege» og «Design» når utdanningstilbudet åpnes igjen. | | |
| 7.3 | Angi søkeord på utdanningstilbudet <br>Regel: Søkeord kan angis på utdanningstilbudet | Fjerne søkeord fra utdanningstilbud | 1. Bruk utdanningstilbudet fra 7.2, som har tagen «Design». <br>2. Velg «Rediger». <br>3. Åpne «Tags», og fjern krysset ved «Design». <br>4. Lukk menyen, og velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | «Tags» viser «Lege», men ikke «Design», når utdanningstilbudet åpnes igjen. | | |
| 8.1 | Kvoteflyt registreres ikke på utdanningstilbudet <br>Regel: Kvoteflyt registreres ikke lenger på utdanningstilbudet | Kvoteflyt kan ikke registreres på utdanningstilbudet | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Se gjennom alle delene på siden, også kolonnene i «Kvoter» under «Regelverk og kvoter». <br>4. Velg «Avbryt». | Det finnes ikke noe felt for kvoteflyt eller plassflyt på utdanningstilbudet. «Kvoter» har kolonnene «Prioritet», «Kvote», «Ant. kvoteplasser», «Andel av studieplasser» og «Tilbudsgarantier tar plasser fra». | | |
| 9.1 | Overstyre regler for poenglikhet på utdanningstilbudet <br>Regel: Standardregel for poenglikhet vises på utdanningstilbudet | Se standardregel for poenglikhet | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. Sektordemo 23.10.26 har en standardregel for poenglikhet, og tillater andre regler. <br>2. Velg «Rediger». <br>3. Åpne «Poenglikhetsregel» under «Regelverk og kvoter». | Øverst i lista står «[standardregelen] (standard for opptaket)». | | |
| 9.2 | Overstyre regler for poenglikhet på utdanningstilbudet <br>Regel: Regel for poenglikhet kan overstyres på utdanningstilbudet | Overstyre regel for poenglikhet | 1. Fortsett i redigering fra 9.1. <br>2. Velg en annen regel som opptaket tillater, i «Poenglikhetsregel». <br>3. Velg «Lagre». <br>4. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». «Poenglikhetsregel» viser den valgte regelen når utdanningstilbudet åpnes igjen. At regelen brukes i rangeringen, står i «Ikke testbart nå». | | |
| 9.3 | Overstyre regler for poenglikhet på utdanningstilbudet <br>Regel: Regel for poenglikhet kan overstyres på utdanningstilbudet | Kun regler tilgjengelige for opptaket kan velges | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Poenglikhetsregel», og se gjennom valgene. <br>4. Velg «Avbryt». | Valgene er standardregelen for opptaket og de reglene opptaket tillater, slik de står i opptaksinnstillingene i Sektordemo 23.10.26. Andre regler står ikke i lista. | | |
| 10.1 | Registrere planlagt antall studieplasser <br>Regel: Planlagt antall studieplasser kan registreres | Registrere planlagt antall studieplasser | 1. Gå tilbake til detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Skriv inn «120» i «Planlagte studieplasser» under «Regelverk og kvoter». <br>4. Velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». Står kvoteplassene ikke til 120, vises en advarsel om at kvoteplassene ikke summerer til de planlagte studieplassene. | | |
| 10.2 | Registrere planlagt antall studieplasser <br>Regel: Planlagt antall studieplasser kan registreres | Se planlagt antall studieplasser | 1. Bruk utdanningstilbudet fra 10.1. <br>2. Se på «Planlagte studieplasser». | «Planlagte studieplasser» viser 120. | | |
| 11.1 | Registrere poengopplysninger for utdanningstilbudet <br>Regel: Poenggrense for årets tidligopptak kan registreres og vises | Registrere poenggrense for tidligopptak | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Kryss av for «Tidlig opptak» under «Regelverk og kvoter». <br>4. Skriv inn «45,5» i «Poenggrense». <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». | | |
| 11.2 | Registrere poengopplysninger for utdanningstilbudet <br>Regel: Poenggrense for årets tidligopptak kan registreres og vises | Se registrert poenggrense for tidligopptak | 1. Bruk utdanningstilbudet fra 11.1. <br>2. Se på «Tidlig opptak». | «Tidlig opptak» viser «Ja», og «Poenggrense» viser 45,5. | | |
| 12.1 | Registrere påkrevde attester på utdanningstilbudet <br>Regel: Krav om politiattest kan registreres | Registrere krav om politiattest | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Attester». <br>4. Velg en attest som har typen «Politiattest». [Sjekk begrep] <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». «Attester» viser politiattesten når utdanningstilbudet åpnes igjen. | | |
| 12.2 | Registrere påkrevde attester på utdanningstilbudet <br>Regel: Krav om medisinsk attest kan registreres | Registrere krav om medisinsk attest | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Attester». <br>4. Velg en attest som har typen «Medisinsk attest». [Sjekk begrep] <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | «Attester» viser både politiattesten fra 12.1 og den medisinske attesten når utdanningstilbudet åpnes igjen. | | |
| 13.1 | Registrere studietypenummer på utdanningstilbudet <br>Regel: Studietypenummer kan påføres utdanningstilbudet | Registrere studietypenummer på utdanningstilbud | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg et studietypenummer i «Studietypenummer» i delen «Studietypenummer og studieavgift». [Sjekk begrep] <br>4. Velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». | | |
| 13.2 | Registrere studietypenummer på utdanningstilbudet <br>Regel: Studietypenummer kan påføres utdanningstilbudet | Se studietypenummer på utdanningstilbud | 1. Bruk utdanningstilbudet fra 13.1. <br>2. Se på «Studietypenummer». | «Studietypenummer» viser nummeret og navnet som ble valgt i 13.1. | | |
| 14.1 | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet <br>Regel: Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud | Sette tidlig søknadsfrist | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg et utdanningstilbud. <br>3. Velg «Rediger». <br>4. Kryss av for «Tidlig søknadsfrist». <br>5. Velg 01.03.2027 kl. 23:59 i «Søknadsfrist for utdanningstilbudet». [Sjekk begrep: datoformatet i datovelgeren] <br>6. Velg 01.03.2027 kl. 23:59 i «Dokumentasjonsfrist for utdanningstilbudet». Feltet må fylles ut for å kunne lagre. <br>7. Velg «Lagre». <br>8. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». «Tidlig søknadsfrist» viser «Ja», og «Søknadsfrist for utdanningstilbudet» viser 01.03.2027 23:59 når utdanningstilbudet åpnes igjen. | | |
| 14.2 | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet <br>Regel: Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud | Sette tidlig dokumentasjonsfrist | 1. Bruk utdanningstilbudet fra 14.1. <br>2. Velg «Rediger». <br>3. Velg 01.03.2027 kl. 23:59 i «Dokumentasjonsfrist for utdanningstilbudet», hvis det ikke står der allerede. <br>4. Velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | «Dokumentasjonsfrist for utdanningstilbudet» viser 01.03.2027 23:59 når utdanningstilbudet åpnes igjen. | | |
| 15.1 | Vise URL til beskrivelse av utdanningstilbudet <br>Regel: URL til beskrivelse hentes fra utdanningsregisteret og vises | Se URL til beskrivelse av utdanningstilbudet | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg et utdanningstilbud med beskrivelses-URL i utdanningsregisteret. <br>3. Se på «Lenke til utdanning» i delen «Basisinformasjon». <br>4. Velg lenken. | «Lenke til utdanning» viser lenken til beskrivelsen. Lenken åpnes i en ny fane, og fører til beskrivelsen av utdanningen. | | |
| 15.2 | Vise URL til beskrivelse av utdanningstilbudet <br>Regel: URL til beskrivelse hentes fra utdanningsregisteret og vises | Utdanningstilbud uten beskrivelses-URL | 1. Gå tilbake til lista over utdanningstilbud i det samme opptaket. <br>2. Velg et utdanningstilbud uten beskrivelses-URL i utdanningsregisteret. <br>3. Se på «Lenke til utdanning» i delen «Basisinformasjon». | «Lenke til utdanning» viser «-», og ingen lenke. | | |

Åpent spørsmål til regelen i 14.1 og 14.2: Hva skjer med søkere som ikke har lastet opp dokumentasjon innen den tidlige dokumentasjonsfristen? Kan søkeren ikke laste opp etter fristen, eller merkes dokumentasjonen som levert for sent for saksbehandleren? Svaret endrer ikke status på 14.1 og 14.2.

### Blokk H: testbruker 1 (ORDENTLIG RUNDSKRIV), setter fase 3

Fortsett som testbruker 1. Sett fristene slik at søknad er åpnet, og redigering av utdanningstilbud fortsatt er åpen (fase 3).

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 1.3 | Fjerne utdanningstilbud fra opptak <br>Regel: Utdanningstilbud kan ikke fjernes etter at opptaket har åpnet for søknad | Fjerning av utdanningstilbud etter søknadsåpning avvises | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Kryss av for et utdanningstilbud du velger. <br>3. Velg «Handlinger», og velg «Fjern utdanningstilbud». <br>4. Velg «Fjern» i dialogen. <br>5. Last siden på nytt. | Utdanningstilbudet fjernes ikke, og meldingen «Kunne ikke fjerne utdanningstilbudet» vises. Utdanningstilbudet står fortsatt i lista etter at siden er lastet på nytt. | | |

### Blokk I: testbruker 1 (ORDENTLIG RUNDSKRIV), setter fase 4

Fortsett som testbruker 1. Sett fristene slik at redigering av utdanningstilbud er stengt, og trekkfristen ikke er passert (fase 4).

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 2.8 | Legge til utdanningstilbud i opptak <br>Regel: Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering | Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg et utdanningstilbud som UiT tilbyr. <br>3. Velg «Rediger». <br>4. Åpne «Tags», skriv inn «Akseptansetest» i søkefeltet, og velg «Legg til «Akseptansetest»». <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Alle feltene kan endres. Etter «Lagre» vises «Endringene er lagret.», og «Tags» viser «Akseptansetest» når utdanningstilbudet åpnes igjen. | | |
| 4.1 | Trekke utdanningstilbud fra opptak <br>Regel: Opptaksforvalter ved deltakende organisasjon eller forvaltende organisasjon kan trekke utdanningstilbud | Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg et utdanningstilbud du velger å trekke. Det kan ikke angres. <br>3. Velg «Trekk studiet fra opptaket» i delen «Opptaksinnstillinger». <br>4. Les dialogen, og velg «Trekk studiet». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien. | Dialogen «Trekk studiet fra opptaket» sier «Studiet trekkes fra opptaket og blir ikke lenger tilbudt søkerne. Dette kan ikke angres.». Etter «Trekk studiet» vises «Studiet er trukket fra opptaket», og detaljsiden viser «Utdanningstilbudet er trukket fra opptaket og kan ikke endres.». I lista har utdanningstilbudet «Trukket» i «Status». | | |

### Blokk J: testbruker 2 (KORT DOMPAPP UiT), fase 4

Bytt til testbruker 2 (KORT DOMPAPP UiT, opptaksforvalter ved UiT Norges arktiske universitet).

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 1.5 | Fjerne utdanningstilbud fra opptak <br>Regel: Opptaksforvalter ved deltakende organisasjon kan fjerne utdanningstilbud organisasjonen tilbyr, fram til redigeringsfristen | Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Se at øverst står «Redigering stengt». <br>3. Finn et utdanningstilbud som UiT tilbyr i lista. | Menyen «Handlinger» vises ikke, og det er ingen avkrysningsbokser i lista. Testbruker 2 har ingen mulighet til å fjerne utdanningstilbudet. | | |
| 2.7 | Legge til utdanningstilbud i opptak <br>Regel: Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering | Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Se at øverst står «Redigering stengt», og at menyen «Handlinger» ikke vises. <br>3. Velg et utdanningstilbud som UiT tilbyr i lista. <br>4. Velg «Rediger». <br>5. Se hvilke felt som kan endres. <br>6. Skriv inn «80» i «Planlagte studieplasser». <br>7. Velg «Lagre». <br>8. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Testbruker 2 kan ikke legge til utdanningstilbud, fordi «Handlinger» mangler. I redigering kan bare «Planlagte studieplasser» og «Ant. kvoteplasser» endres, og resten kan bare leses. Etter «Lagre» vises «Endringene er lagret.», og «Planlagte studieplasser» viser 80 når utdanningstilbudet åpnes igjen. | | |

### Blokk K: testbruker 1 (ORDENTLIG RUNDSKRIV), setter fase 5

Bytt til testbruker 1 (ORDENTLIG RUNDSKRIV, opptaksforvalter ved Sikt). Sett fristene slik at trekkfristen for utdanningstilbud er passert (fase 5).

### Blokk L: testbruker 2 (KORT DOMPAPP UiT), fase 5

Bytt til testbruker 2 (KORT DOMPAPP UiT, opptaksforvalter ved UiT Norges arktiske universitet).

| Nr | Krav og regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|---|
| 4.2 | Trekke utdanningstilbud fra opptak <br>Regel: Trekking er ikke mulig etter trekkfristen for deltakende organisasjoner | Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen | 1. Gå til «Opptak», velg opptaket «Sektordemo 23.10.26», og velg «Gå til utdanningstilbud». <br>2. Velg et utdanningstilbud som UiT tilbyr. <br>3. Se på delen «Opptaksinnstillinger». | Knappen «Trekk studiet fra opptaket» vises ikke. Testbruker 2 kan ikke trekke utdanningstilbudet. | | |

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| Overstyre regel for poenglikhet (9.2): at den overstyrte regelen brukes | Regelen brukes i rangeringen i plasstildelingen, og det kan ikke ses på utdanningstilbudet. 9.2 tester at valget lagres. | Når plasstildelingen kan kjøres i testmiljøet, og akseptansetesten av den har testdata med poenglikhet |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Legge til: organisasjon som ikke deltar, kan ikke legge til utdanningstilbud (2.4) | Testes ikke i denne runden |
| Poenglikhet: kan ikke overstyre regelen når opptaket ikke åpner for unntak (9.4) | Testes ikke i denne runden |
| Fjerne: «Fjern utdanningstilbud» skal ikke vises etter at opptaket har åpnet for søknad | Venter på verifisering: løsningen skjuler valget når redigeringsfristen er passert, ikke når opptaket åpner for søknad |
| Fjerne: deltakende organisasjon kan ikke fjerne et utdanningstilbud en annen organisasjon tilbyr | Venter på verifisering: ikke levert ennå (SHI-747) |
| Fjerne: forvaltende organisasjon fjerner etter redigeringsfristen | Venter på verifisering: løsningen skjuler valget for alle når redigeringsfristen er passert |
| Legge til alle utdanningstilbudene i en filtrert liste | Venter på verifisering: «Velg alle» velger bare de 50 radene som er lastet |
| Legge til: se bare utdanningstilbud som passer opptakets kriterier | Venter på verifisering: opptaket har ingen kriterier ennå |
| Legge til: filtrere på utdanningstype og NKR-nivå (4 scenarioer) | Venter på verifisering: det finnes ikke filter på utdanningstype eller NKR 5.1/5.2 |
| Legge til: redigering er stengt når åpningsdatoen ikke er satt | Venter på verifisering: løsningen holder redigeringen åpen |
| Legge til: endringer fra utdanningsregisteret oppdateres etter at redigering stenger | Venter på verifisering: utdanningstilbudene oppdateres ikke automatisk |
| Legge til: deltakende organisasjon kan ikke redigere et utdanningstilbud en annen organisasjon tilbyr | Venter på verifisering: ikke levert ennå (SHI-747) |
| Liste: filtrere på utdanningstilbud som mangler kvoteprioritet eller plassflyt, tilbudsgaranti, tidlig søknadsfrist eller poenggrense for tidlig opptak (4 scenarioer) | Venter på verifisering: «Har mangler» tar bare med kompetanseregelverk, rangeringsregelverk og kvoter |
| Trekke: deltakende organisasjon trekker et utdanningstilbud organisasjonen tilbyr | Venter på verifisering: deltakende organisasjon har ikke knappen for å trekke |
| Trekke: deltakende organisasjon kan ikke trekke et utdanningstilbud en annen organisasjon tilbyr | Venter på verifisering: ikke levert ennå (SHI-747) |
| Trekke etter søknadsåpning | Venter på verifisering: muligheten til å trekke styres av at redigeringen er stengt, ikke av søknadsåpningen |
| Søkere varsles når utdanningstilbudet de har søkt på, trekkes | Ikke avklart ennå |
| Søkeren ser beskrivelsen i Min kompetanse | Venter på verifisering: Min kompetanse henter ikke beskrivelsen |
| Søkeren finner utdanningstilbudet via søkeord i Min kompetanse | Venter på verifisering: søket for søkere ser bare på navnet |
| Median poengsum for fjorårets opptatte | Venter på verifisering: FS Admin viser «Ikke tilgjengelig». Endringen er ikke tatt inn i løsningen ennå |
| Tidlig søknadsfrist må være før søknadsfristen for opptaket | Venter på verifisering: løsningen sjekker det ikke |
| Endringslogg, lenke til og sammenligning med tidligere utdanningstilbud, kjønnspoeng, poenggrense og ventelistenummer for søker, og eksport | Ikke avklart ennå, eller kommer senere |

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
