# Intern akseptansetest – Utdanningstilbud i samordna opptak 2027

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137235987
- **Scope**: @scope-utdanningstilbud-i-opptak-2027, @scope-utdanningstilbud-2027
- **Krav**: 15 feature-filer, commit `b67676a` (2026-10-23)
- **Verifisering**: verify-02 Utdanningstilbud i opptak-2026-10-22-1915.md (21 av 40 funnet), verify-04 Behandle et utdanningstilbud-2026-10-22-1915.md (23 av 31 funnet)
- **Skjermens ord**: fs-admin `origin/main` `be244a345` (2026-10-23). Ingen av kravene har `.design.md`, og oppgavene har ingen skisser.
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5136613418
- **Laget**: 2026-10-23 av fs-testcaser-intern
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
  | 2.4 | `@OPT-OPT-UTD-002` | Kun utdanningstilbud fra deltakende organisasjoner kan legges til | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud |
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
  | 9.4 | `@OPT-OPT-UTD-015` | Utdanningstilbudet kan ikke overstyre poenglikhetsregelen når opptaket ikke åpner for unntak | Kan ikke overstyre regel for poenglikhet når opptaket ikke åpner for unntak |
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

Intern akseptansetest av «Utdanningstilbud i samordna opptak 2027». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137235987). Felt med gul bakgrunn fylles ut av teamet før testen.

Testen har 47 testcaser og tar 1,5–3 timer. Den er delt i to økter: økt 1 er del 1–4 (utdanningstilbud i opptaket, 21 testcaser), og økt 2 er del 5–15 (detaljsiden for et utdanningstilbud, 26 testcaser).

## Slik tester du

- Ta testcasene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med alvorlighetsgrad. Spørsmål underveis tas i Slack-tråden «Akseptansetesting Utdanningstilbud i samordna opptak 2027».
- Testmiljøet er [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/). Du bytter testbruker ved å logge ut (menyen øverst til høyre) og logge inn igjen som den nye testbrukeren. [Sjekk begrep: hvordan man logger ut og bytter bruker i test-fsadmin]
- Slik kommer du til utdanningstilbudene i et opptak: velg «Opptak» på forsiden, velg opptaket i lista, og velg «Gå til utdanningstilbud» i kortet «Utdanningstilbud».

## Testcaser

## Økt 1: Utdanningstilbud i opptaket

### Del 1: Fjerne utdanningstilbud fra opptak (fjerne_utdanningstilbud.feature)

#### Regel: Utdanningstilbud kan fjernes før opptaket åpner for søknad

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.1 | Fjerne utdanningstilbud før søknadsåpning | 1. Logg inn som testbruker 1 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: forvaltende organisasjon]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak som ikke har åpnet for søknad, med redigering åpen]», og velg «Gå til utdanningstilbud». <br>3. Kryss av for utdanningstilbudet «[Fylles ut: utdanningstilbud A]». <br>4. Velg «Handlinger», og velg «Fjern utdanningstilbud». <br>5. Les dialogen «Fjern utdanningstilbud», og velg «Fjern». <br>6. Last siden på nytt. | Dialogen spør «Er du sikker på at du vil fjerne ett utdanningstilbud fra dette opptaket?». Etter «Fjern» vises meldingen «1 utdanningstilbud ble fjernet». Utdanningstilbudet står ikke lenger i lista, heller ikke etter at siden er lastet på nytt. | | |
| 1.2 | Fjerne flere utdanningstilbud av gangen før søknadsåpning | 1. Fortsett som testbruker 1, i det samme opptaket som i 1.1. <br>2. Kryss av for utdanningstilbudene «[Fylles ut: utdanningstilbud B]» og «[Fylles ut: utdanningstilbud C]». <br>3. Velg «Handlinger», og velg «Fjern utdanningstilbud». <br>4. Velg «Fjern» i dialogen. <br>5. Last siden på nytt. | Dialogen spør «Er du sikker på at du vil fjerne 2 utdanningstilbud fra dette opptaket?». Etter «Fjern» vises meldingen «2 utdanningstilbud ble fjernet». Ingen av de to utdanningstilbudene står i lista, heller ikke etter at siden er lastet på nytt. | | |
| | | *Gjør klar til neste test: legg utdanningstilbud A, B og C til i opptaket igjen («Handlinger» → «Legg til utdanningstilbud»).* | | | |

#### Regel: Utdanningstilbud kan ikke fjernes etter at opptaket har åpnet for søknad

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.3 | Fjerning av utdanningstilbud etter søknadsåpning avvises | 1. Logg inn som testbruker 1 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: forvaltende organisasjon]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak som har åpnet for søknad, med redigering fortsatt åpen]», og velg «Gå til utdanningstilbud». <br>3. Kryss av for utdanningstilbudet «[Fylles ut: utdanningstilbud]». <br>4. Velg «Handlinger», og velg «Fjern utdanningstilbud». <br>5. Velg «Fjern» i dialogen. <br>6. Last siden på nytt. | Utdanningstilbudet fjernes ikke, og meldingen «Kunne ikke fjerne utdanningstilbudet» vises. Utdanningstilbudet står fortsatt i lista etter at siden er lastet på nytt. | | |

#### Regel: Opptaksforvalter ved deltakende organisasjon kan fjerne utdanningstilbud organisasjonen tilbyr, fram til redigeringsfristen

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.4 | Deltakende organisasjon fjerner eget utdanningstilbud før redigeringsfristen | 1. Logg ut, og logg inn som testbruker 2 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: deltakende organisasjon A]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak som ikke har åpnet for søknad, med redigering åpen]», og velg «Gå til utdanningstilbud». <br>3. Se at øverst står «Redigeringsfrist» med en dato fram i tid. <br>4. Kryss av for utdanningstilbudet «[Fylles ut: utdanningstilbud som deltakende organisasjon A tilbyr]». <br>5. Velg «Handlinger», og velg «Fjern utdanningstilbud». <br>6. Velg «Fjern» i dialogen. <br>7. Last siden på nytt. | Meldingen «1 utdanningstilbud ble fjernet» vises. Utdanningstilbudet står ikke lenger i lista, heller ikke etter at siden er lastet på nytt. | | |
| | | *Gjør klar til neste test: legg utdanningstilbudet til i opptaket igjen.* | | | |
| 1.5 | Deltakende organisasjon kan ikke fjerne eget utdanningstilbud etter redigeringsfristen | 1. Fortsett som testbruker 2 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: deltakende organisasjon A]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak der redigeringen er stengt]», og velg «Gå til utdanningstilbud». <br>3. Se at øverst står «Redigering stengt». <br>4. Finn utdanningstilbudet «[Fylles ut: utdanningstilbud som deltakende organisasjon A tilbyr]» i lista. | Menyen «Handlinger» vises ikke, og det er ingen avkrysningsbokser i lista. Testbruker 2 har ingen mulighet til å fjerne utdanningstilbudet. | | |

### Del 2: Legge til utdanningstilbud i opptak (legge_til_utdanningstilbud.feature)

#### Regel: Opptaksforvalter ved deltakende organisasjon kan legge til enkelttilbud

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.1 | Legge til enkelttilbud fra organisasjonen opptaksforvalter er ved | 1. Fortsett som testbruker 2 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: deltakende organisasjon A]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak som ikke har åpnet for søknad, med redigering åpen]», og velg «Gå til utdanningstilbud». <br>3. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>4. Skriv inn «[Fylles ut: navnet på en utdanning ved deltakende organisasjon A, minst 3 tegn]» i «Utdanningsnavn». <br>5. Kryss av for utdanningen «[Fylles ut: utdanning D]» i «Resultater». <br>6. Velg «Legg til (1)». <br>7. Last siden på nytt. | Meldingen «Utdanningstilbud lagt til» vises. Utdanningstilbudet står i lista over utdanningstilbud i opptaket, med deltakende organisasjon A i «Organisasjon», også etter at siden er lastet på nytt. | | |

#### Regel: Opptaksforvalter kan legge til flere utdanningstilbud av gangen

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.2 | Legge til flere utdanningstilbud av gangen | 1. Fortsett som testbruker 2, i det samme opptaket som i 2.1. <br>2. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>3. Kryss av for utdanningene «[Fylles ut: utdanning E]» og «[Fylles ut: utdanning F]» i «Resultater». <br>4. Velg «Legg til (2)». <br>5. Last siden på nytt. | Meldingen «Utdanningstilbud lagt til» vises. Begge utdanningstilbudene står i lista over utdanningstilbud i opptaket, også etter at siden er lastet på nytt. | | |
| | | *Gjør klar til neste test: fjern utdanningstilbud D, E og F fra opptaket («Handlinger» → «Fjern utdanningstilbud»).* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til utdanningstilbud for alle deltakende organisasjoner

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.3 | Opptaksforvalter ved forvaltende organisasjon legger til utdanningstilbud for en annen organisasjon | 1. Logg ut, og logg inn som testbruker 1 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: forvaltende organisasjon]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak som ikke har åpnet for søknad, med redigering åpen]», og velg «Gå til utdanningstilbud». <br>3. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>4. Velg «[Fylles ut: deltakende organisasjon A]» i «Organisasjon». <br>5. Kryss av for utdanningen «[Fylles ut: utdanning G ved deltakende organisasjon A]» i «Resultater». <br>6. Velg «Legg til (1)». <br>7. Last siden på nytt. | Meldingen «Utdanningstilbud lagt til» vises. Utdanningstilbudet står i lista over utdanningstilbud i opptaket, med deltakende organisasjon A i «Organisasjon», også etter at siden er lastet på nytt. | | |
| | | *Gjør klar til neste test: fjern utdanningstilbud G fra opptaket.* | | | |

#### Regel: Kun utdanningstilbud fra deltakende organisasjoner kan legges til

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.4 | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | 1. Fortsett som testbruker 1, i det samme opptaket som i 2.3. <br>2. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>3. Åpne «Organisasjon», og se gjennom valgene. <br>4. Skriv inn «[Fylles ut: navnet på en utdanning ved organisasjonen som ikke deltar]» i «Utdanningsnavn». | «[Fylles ut: organisasjon som ikke deltar, f.eks. NTNU]» står ikke blant valgene i «Organisasjon». Søket gir ingen utdanninger fra organisasjonen som ikke deltar. | | |

#### Regel: Deltakende organisasjoner kan knytte til og redigere utdanningstilbud bare i perioden opptaket er åpent for redigering

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.5 | Kan ikke knytte utdanningstilbud til opptaket før redigering åpner | 1. Logg ut, og logg inn som testbruker 2 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: deltakende organisasjon A]). <br>2. Gå til «Opptak», og velg opptaket «[Fylles ut: opptak der redigeringen ikke har åpnet ennå]». <br>3. Se på kortet «Utdanningstilbud» under «Oppgaver». | Kortet viser «Redigering åpner [dato]» i stedet for «Gå til utdanningstilbud». Testbruker 2 kommer ikke til lista, og kan ikke legge til utdanningstilbud. | | |
| 2.6 | Kan knytte til og redigere utdanningstilbud i perioden opptaket er åpent for redigering | 1. Fortsett som testbruker 2. <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak som ikke har åpnet for søknad, med redigering åpen]», og velg «Gå til utdanningstilbud». <br>3. Se at øverst står «Redigeringsfrist» med en dato fram i tid. <br>4. Velg «Handlinger», og velg «Legg til utdanningstilbud». <br>5. Kryss av for utdanningen «[Fylles ut: utdanning D]», og velg «Legg til (1)». <br>6. Velg utdanningstilbudet i lista for å åpne det. <br>7. Velg «Rediger». <br>8. Skriv inn «100» i «Planlagte studieplasser». <br>9. Velg «Lagre». <br>10. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Utdanningstilbudet står i lista etter steg 5. På detaljsiden vises «Rediger». Etter «Lagre» vises «Endringene er lagret.», og «Planlagte studieplasser» viser 100 når utdanningstilbudet åpnes igjen. | | |
| | | *Gjør klar til neste test: fjern utdanningstilbud D fra opptaket.* | | | |
| 2.7 | Kan ikke knytte til eller redigere utdanningstilbud etter at redigering stenger | 1. Fortsett som testbruker 2. <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak der redigeringen er stengt]», og velg «Gå til utdanningstilbud». <br>3. Se at øverst står «Redigering stengt», og at menyen «Handlinger» ikke vises. <br>4. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud som deltakende organisasjon A tilbyr]» i lista. <br>5. Velg «Rediger». <br>6. Se hvilke felt som kan endres. <br>7. Skriv inn «80» i «Planlagte studieplasser». <br>8. Velg «Lagre». <br>9. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Testbruker 2 kan ikke legge til utdanningstilbud, fordi «Handlinger» mangler. I redigering kan bare «Planlagte studieplasser» og «Ant. kvoteplasser» endres, og resten kan bare leses. Etter «Lagre» vises «Endringene er lagret.», og «Planlagte studieplasser» viser 80 når utdanningstilbudet åpnes igjen. | | |
| 2.8 | Opptaksforvalter ved forvaltende organisasjon kan redigere utdanningstilbud etter at redigering stenger | 1. Logg ut, og logg inn som testbruker 1 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: forvaltende organisasjon]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak der redigeringen er stengt]», og velg «Gå til utdanningstilbud». <br>3. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud som deltakende organisasjon A tilbyr]». <br>4. Velg «Rediger». <br>5. Åpne «Tags», skriv inn «Akseptansetest» i søkefeltet, og velg «Legg til «Akseptansetest»». <br>6. Velg «Lagre». <br>7. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Alle feltene kan endres. Etter «Lagre» vises «Endringene er lagret.», og «Tags» viser «Akseptansetest» når utdanningstilbudet åpnes igjen. | | |
| | | *Gjør klar til neste test: fjern tagen «Akseptansetest» igjen.* | | | |

### Del 3: Listevisning og søk i utdanningstilbud i opptaket (listevisning_utdanningstilbud.feature)

#### Regel: Grunndata fra utdanningsregisteret vises tydelig

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.1 | Se grunndata om utdanning | 1. Fortsett som testbruker 1 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: forvaltende organisasjon]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak med utdanningstilbud fra minst to organisasjoner]», og velg «Gå til utdanningstilbud». <br>3. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud]» i lista. <br>4. Se på delen «Basisinformasjon». | «Basisinformasjon» er merket «Kilde: Utdanningsregisteret». Delen viser navnet («Navn (bokmål)» og de andre språkene), «Utdanningsnivå», «Institusjon», «Studiested» og «Studiepoeng», med verdier fra utdanningsregisteret. Feltene i «Basisinformasjon» kan ikke endres med «Rediger». | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon kan filtrere på organisasjon

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.2 | Filtrere på organisasjon som opptaksforvalter ved forvaltende organisasjon | 1. Fortsett som testbruker 1, i lista over utdanningstilbud i det samme opptaket som i 3.1. <br>2. Velg «[Fylles ut: kortnavnet til deltakende organisasjon A, f.eks. UiO]» i filteret «Organisasjon». | Lista viser bare utdanningstilbud med deltakende organisasjon A i «Organisasjon». | | |
| | | *Gjør klar til neste test: velg «Fjern alle filtre».* | | | |

#### Regel: Opptaksforvalter kan filtrere på starttermin og startår

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.3 | Filtrere på starttermin og startår | 1. Fortsett som testbruker 1, i lista over utdanningstilbud i det samme opptaket. <br>2. Velg «2027 Høst» i filteret «Oppstart». [Sjekk begrep: valget i testdataene] <br>3. Velg «Høst» i filteret «Termin». [Sjekk begrep] | Lista viser bare utdanningstilbud med oppstart høst 2027 i kolonnen «Oppstart». | | |
| | | *Gjør klar til neste test: velg «Fjern alle filtre».* | | | |

#### Regel: Opptaksforvalter kan filtrere på navn på studieprogram

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.4 | Fritekst-søk på studieprogramnavn | 1. Fortsett som testbruker 1, i lista over utdanningstilbud i det samme opptaket. <br>2. Skriv inn «[Fylles ut: del av navnet på et utdanningstilbud i opptaket, f.eks. sykepleie]» i «Søk». | Lista viser bare utdanningstilbud med søketeksten i navnet, og filteret vises som «Søk: [søketeksten]». | | |
| | | *Gjør klar til neste test: velg «Fjern alle filtre».* | | | |

#### Regel: Opptaksforvalter kan filtrere på utdanningstilbud med ufullstendige opplysninger

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.5 | Filtrere på utdanningstilbud som mangler kompetanseregelverk | 1. Fortsett som testbruker 1, i lista over utdanningstilbud i det samme opptaket. <br>2. Velg «Har mangler» i filteret «Status». | Lista viser utdanningstilbudet «[Fylles ut: utdanningstilbud uten kompetanseregelverk]», med «Ikke valgt» i «Kompetanseregelverk» og «Har mangler» i «Status». Ingen av radene har «OK» i «Status». | | |
| 3.6 | Filtrere på utdanningstilbud som mangler rangeringsregelverk | 1. Fortsett som testbruker 1, med «Har mangler» valgt i filteret «Status». <br>2. Se gjennom kolonnen «Rangeringsregelverk» i lista. | Lista viser utdanningstilbudet «[Fylles ut: utdanningstilbud uten rangeringsregelverk]», med «Ikke valgt» i «Rangeringsregelverk» og «Har mangler» i «Status». | | |
| | | *Gjør klar til neste test: velg «Fjern alle filtre».* | | | |

### Del 4: Trekke utdanningstilbud fra opptak (trekke_utdanningstilbud.feature)

#### Regel: Opptaksforvalter ved deltakende organisasjon eller forvaltende organisasjon kan trekke utdanningstilbud

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.1 | Opptaksforvalter ved forvaltende organisasjon trekker utdanningstilbud | 1. Fortsett som testbruker 1 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: forvaltende organisasjon]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: publisert opptak der redigeringen er stengt og trekkfristen ikke er passert]», og velg «Gå til utdanningstilbud». <br>3. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud som kan trekkes. Det kan ikke angres]». <br>4. Velg «Trekk studiet fra opptaket» i delen «Opptaksinnstillinger». <br>5. Les dialogen, og velg «Trekk studiet». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien. | Dialogen «Trekk studiet fra opptaket» sier «Studiet trekkes fra opptaket og blir ikke lenger tilbudt søkerne. Dette kan ikke angres.». Etter «Trekk studiet» vises «Studiet er trukket fra opptaket», og detaljsiden viser «Utdanningstilbudet er trukket fra opptaket og kan ikke endres.». I lista har utdanningstilbudet «Trukket» i «Status». | | |

#### Regel: Trekking er ikke mulig etter trekkfristen for deltakende organisasjoner

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.2 | Opptaksforvalter ved deltakende organisasjon forsøker å trekke etter trekkfristen | 1. Logg ut, og logg inn som testbruker 2 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: deltakende organisasjon A]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak der trekkfristen er passert]», og velg «Gå til utdanningstilbud». <br>3. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud som deltakende organisasjon A tilbyr]». <br>4. Se på delen «Opptaksinnstillinger». | Knappen «Trekk studiet fra opptaket» vises ikke. Testbruker 2 kan ikke trekke utdanningstilbudet. | | |

## Økt 2: Behandle et utdanningstilbud

Alle testcasene i økt 2 gjøres som testbruker 1 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: forvaltende organisasjon]), på detaljsiden for utdanningstilbudet «[Fylles ut: utdanningstilbud for økt 2]» i opptaket «[Fylles ut: opptak for økt 2]», med mindre noe annet står. Utdanningstilbudet må ha kompetanseregelverk og rangeringsregelverk, ellers kan det ikke lagres.

### Del 5: Angi beskrivelse av utdanningstilbudet til Min kompetanse (angi_beskrivelse_til_min_kompetanse.feature)

#### Regel: Beskrivelse til Min kompetanse kan angis per språk

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 5.1a | Angi beskrivelse på bokmål | 1. Logg inn som testbruker 1 ([Fylles ut: navn], opptaksforvalter ved [Fylles ut: forvaltende organisasjon]). <br>2. Gå til «Opptak», velg opptaket «[Fylles ut: opptak for økt 2]», og velg «Gå til utdanningstilbud». <br>3. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud for økt 2]». <br>4. Velg «Rediger». <br>5. Velg fanen «Bokmål» under «Beskrivelse som vises for søker» i delen «Min kompetanse». <br>6. Skriv inn «Akseptansetest: beskrivelse på bokmål.» i beskrivelsesfeltet. <br>7. Velg «Lagre». <br>8. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». Under «Beskrivelse (bokmål)» står «Akseptansetest: beskrivelse på bokmål.» når utdanningstilbudet åpnes igjen, og merket ved «Beskrivelse som vises for søker» viser «1 av 4 språk». | | |
| 5.1b | Angi beskrivelse på nynorsk | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg fanen «Nynorsk». <br>4. Skriv inn «Akseptansetest: skildring på nynorsk.» i beskrivelsesfeltet. <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Under «Beskrivelse (nynorsk)» står «Akseptansetest: skildring på nynorsk.», og merket viser «2 av 4 språk». | | |
| 5.1c | Angi beskrivelse på engelsk | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg fanen «Engelsk». <br>4. Skriv inn «Acceptance test: description in English.» i beskrivelsesfeltet. <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Under «Beskrivelse (engelsk)» står «Acceptance test: description in English.», og merket viser «3 av 4 språk». | | |
| 5.1d | Angi beskrivelse på nordsamisk | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg fanen «Samisk». <br>4. Skriv inn «Akseptansetest: válddahus sámegillii.» i beskrivelsesfeltet. <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Under «Beskrivelse (samisk)» står «Akseptansetest: válddahus sámegillii.», og merket viser «4 av 4 språk» i grønt. | | |

### Del 6: Angi informasjon om studieavgift (angi_studieavgift.feature)

#### Regel: Informasjon om studieavgift kan angis på utdanningstilbudet

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 6.1 | Registrere informasjon om studieavgift | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg «Ja» i «Har utdanningstilbudet studieavgift?» i delen «Studietypenummer og studieavgift». <br>4. Velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». | | |
| 6.2 | Se informasjon om studieavgift | 1. Bruk utdanningstilbudet fra 6.1. <br>2. Se på delen «Studietypenummer og studieavgift». | «Studieavgift» viser «Ja». | | |
| | | *Gjør klar til neste test: sett «Har utdanningstilbudet studieavgift?» tilbake til verdien utdanningstilbudet hadde før.* | | | |

### Del 7: Angi søkeord på utdanningstilbudet (angi_søkeord.feature)

Søkeordene heter «Tags» i løsningen.

#### Regel: Søkeord kan angis på utdanningstilbudet

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 7.1 | Legge til søkeord på utdanningstilbud | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Tags» i delen «Min kompetanse». <br>4. Skriv inn «Lege» i søkefeltet. <br>5. Velg «Lege» blant forslagene, eller «Legg til «Lege»» hvis det ikke finnes. <br>6. Lukk menyen, og velg «Lagre». <br>7. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». «Tags» viser «Lege» når utdanningstilbudet åpnes igjen. | | |
| 7.2 | Legge til flere søkeord på samme utdanningstilbud | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Tags», skriv inn «Design», og velg «Design» eller «Legg til «Design»». <br>4. Se at «Lege» fortsatt er krysset av. <br>5. Lukk menyen, og velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | «Tags» viser både «Lege» og «Design» når utdanningstilbudet åpnes igjen. | | |
| 7.3 | Fjerne søkeord fra utdanningstilbud | 1. Bruk utdanningstilbudet fra 7.2, som har tagen «Design». <br>2. Velg «Rediger». <br>3. Åpne «Tags», og fjern krysset ved «Design». <br>4. Lukk menyen, og velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | «Tags» viser «Lege», men ikke «Design», når utdanningstilbudet åpnes igjen. | | |
| | | *Gjør klar til neste test: fjern tagen «Lege».* | | | |

### Del 8: Kvoteflyt registreres ikke på utdanningstilbudet (flytte_kvoteflyt_til_opptaksinnstillinger.feature)

#### Regel: Kvoteflyt registreres ikke lenger på utdanningstilbudet

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 8.1 | Kvoteflyt kan ikke registreres på utdanningstilbudet | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Se gjennom alle delene på siden, også kolonnene i «Kvoter» under «Regelverk og kvoter». <br>4. Velg «Avbryt». | Det finnes ikke noe felt for kvoteflyt eller plassflyt på utdanningstilbudet. «Kvoter» har kolonnene «Prioritet», «Kvote», «Ant. kvoteplasser», «Andel av studieplasser» og «Tilbudsgarantier tar plasser fra». | | |

### Del 9: Overstyre regler for poenglikhet på utdanningstilbudet (overstyre_regler_for_poenglikhet.feature)

#### Regel: Standardregel for poenglikhet vises på utdanningstilbudet

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 9.1 | Se standardregel for poenglikhet | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. Opptaket har standardregelen «[Fylles ut: standardregel for poenglikhet i opptaket]», og tillater andre regler. <br>2. Velg «Rediger». <br>3. Åpne «Poenglikhetsregel» under «Regelverk og kvoter». | Øverst i lista står «[standardregelen] (standard for opptaket)». | | |

#### Regel: Regel for poenglikhet kan overstyres på utdanningstilbudet

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 9.2 | Overstyre regel for poenglikhet | 1. Fortsett i redigering fra 9.1. <br>2. Velg «[Fylles ut: en annen tillatt regel for poenglikhet]» i «Poenglikhetsregel». <br>3. Velg «Lagre». <br>4. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». «Poenglikhetsregel» viser den valgte regelen når utdanningstilbudet åpnes igjen. At regelen brukes i rangeringen, står i «Ikke testbart nå». | | |
| 9.3 | Kun regler tilgjengelige for opptaket kan velges | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Poenglikhetsregel», og se gjennom valgene. <br>4. Velg «Avbryt». | Valgene er standardregelen for opptaket og de reglene opptaket tillater: «[Fylles ut: reglene opptaket tillater]». Andre regler står ikke i lista. | | |
| | | *Gjør klar til neste test: tøm «Poenglikhetsregel», så utdanningstilbudet bruker standardregelen igjen, og lagre.* | | | |

#### Regel: Utdanningstilbudet kan ikke overstyre poenglikhetsregelen når opptaket ikke åpner for unntak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 9.4 | Kan ikke overstyre regel for poenglikhet når opptaket ikke åpner for unntak | 1. Gå til «Opptak», velg opptaket «[Fylles ut: opptak med standardregel for poenglikhet uten mulighet for unntak]», og velg «Gå til utdanningstilbud». <br>2. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud i det opptaket]». <br>3. Velg «Rediger». <br>4. Prøv å endre «Poenglikhetsregel». <br>5. Velg «Avbryt». | «Poenglikhetsregel» kan ikke endres i redigering, og viser standardregelen for opptaket: «[Fylles ut: standardregelen, f.eks. rangering etter alder]». | | |

### Del 10: Registrere planlagt antall studieplasser (registrere_planlagte_studieplasser.feature)

#### Regel: Planlagt antall studieplasser kan registreres

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 10.1 | Registrere planlagt antall studieplasser | 1. Gå tilbake til detaljsiden for utdanningstilbudet «[Fylles ut: utdanningstilbud for økt 2]». <br>2. Velg «Rediger». <br>3. Skriv inn «120» i «Planlagte studieplasser» under «Regelverk og kvoter». <br>4. Velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». Står kvoteplassene ikke til 120, vises en advarsel om at kvoteplassene ikke summerer til de planlagte studieplassene. | | |
| 10.2 | Se planlagt antall studieplasser | 1. Bruk utdanningstilbudet fra 10.1. <br>2. Se på «Planlagte studieplasser». | «Planlagte studieplasser» viser 120. | | |
| | | *Gjør klar til neste test: sett «Planlagte studieplasser» tilbake til verdien utdanningstilbudet hadde før.* | | | |

### Del 11: Registrere poengopplysninger for utdanningstilbudet (registrere_poengopplysninger.feature)

#### Regel: Poenggrense for årets tidligopptak kan registreres og vises

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 11.1 | Registrere poenggrense for tidligopptak | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Kryss av for «Tidlig opptak» under «Regelverk og kvoter». <br>4. Skriv inn «45,5» i «Poenggrense». <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». | | |
| 11.2 | Se registrert poenggrense for tidligopptak | 1. Bruk utdanningstilbudet fra 11.1. <br>2. Se på «Tidlig opptak». | «Tidlig opptak» viser «Ja», og «Poenggrense» viser 45,5. | | |
| | | *Gjør klar til neste test: fjern krysset for «Tidlig opptak» hvis utdanningstilbudet ikke hadde det før.* | | | |

### Del 12: Registrere påkrevde attester på utdanningstilbudet (registrere_påkrevde_attester.feature)

#### Regel: Krav om politiattest kan registreres

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 12.1 | Registrere krav om politiattest | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Attester». <br>4. Velg «[Fylles ut: en politiattest i kodeverket, f.eks. «Ordinær politiattest»]», som har typen «Politiattest». [Sjekk begrep] <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». «Attester» viser politiattesten når utdanningstilbudet åpnes igjen. | | |

#### Regel: Krav om medisinsk attest kan registreres

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 12.2 | Registrere krav om medisinsk attest | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Åpne «Attester». <br>4. Velg «[Fylles ut: en medisinsk attest i kodeverket]», som har typen «Medisinsk attest». [Sjekk begrep] <br>5. Velg «Lagre». <br>6. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | «Attester» viser både politiattesten fra 12.1 og den medisinske attesten når utdanningstilbudet åpnes igjen. | | |
| | | *Gjør klar til neste test: fjern de to attestene fra «Attester».* | | | |

### Del 13: Registrere studietypenummer på utdanningstilbudet (registrere_studietypenummer.feature)

#### Regel: Studietypenummer kan påføres utdanningstilbudet

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 13.1 | Registrere studietypenummer på utdanningstilbud | 1. Fortsett på detaljsiden for det samme utdanningstilbudet. <br>2. Velg «Rediger». <br>3. Velg «[Fylles ut: studietypenummer og navn, f.eks. «12 Bachelor»]» i «Studietypenummer» i delen «Studietypenummer og studieavgift». [Sjekk begrep] <br>4. Velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». | | |
| 13.2 | Se studietypenummer på utdanningstilbud | 1. Bruk utdanningstilbudet fra 13.1. <br>2. Se på «Studietypenummer». | «Studietypenummer» viser nummeret og navnet som ble valgt i 13.1. | | |

### Del 14: Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet (sette_tidlig_søknadsfrist.feature)

#### Regel: Opptaksforvalter kan sette tidlig søknadsfrist per utdanningstilbud

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 14.1 | Sette tidlig søknadsfrist | 1. Gå til «Opptak», velg opptaket «[Fylles ut: opptak med søknadsfrist 15.04.2027 23:59, eller en annen søknadsfrist]», og velg «Gå til utdanningstilbud». <br>2. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud med tidlig søknadsfrist, f.eks. Politihøgskolen, høst 2027]». <br>3. Velg «Rediger». <br>4. Kryss av for «Tidlig søknadsfrist». <br>5. Velg 01.03.2027 kl. 23:59 i «Søknadsfrist for utdanningstilbudet». [Sjekk begrep: datoformatet i datovelgeren] <br>6. Velg 01.03.2027 kl. 23:59 i «Dokumentasjonsfrist for utdanningstilbudet». Feltet må fylles ut for å kunne lagre. <br>7. Velg «Lagre». <br>8. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | Etter «Lagre» vises «Endringene er lagret.». «Tidlig søknadsfrist» viser «Ja», og «Søknadsfrist for utdanningstilbudet» viser 01.03.2027 23:59 når utdanningstilbudet åpnes igjen. | | |
| 14.2 | Sette tidlig dokumentasjonsfrist | 1. Bruk utdanningstilbudet fra 14.1. <br>2. Velg «Rediger». <br>3. Velg 01.03.2027 kl. 23:59 i «Dokumentasjonsfrist for utdanningstilbudet», hvis det ikke står der allerede. <br>4. Velg «Lagre». <br>5. Gå tilbake til «Utdanningstilbud» i brødsmulestien, og åpne utdanningstilbudet igjen. | «Dokumentasjonsfrist for utdanningstilbudet» viser 01.03.2027 23:59 når utdanningstilbudet åpnes igjen. | | |
| | | *Gjør klar til neste test: fjern krysset for «Tidlig søknadsfrist» hvis utdanningstilbudet ikke hadde det før.* | | | |

Åpent spørsmål til regelen: Hva skjer med søkere som ikke har lastet opp dokumentasjon innen den tidlige dokumentasjonsfristen? Kan søkeren ikke laste opp etter fristen, eller merkes dokumentasjonen som levert for sent for saksbehandleren? Svaret endrer ikke status på 14.1 og 14.2.

### Del 15: Vise URL til beskrivelse av utdanningstilbudet (vise_beskrivelses_url.feature)

#### Regel: URL til beskrivelse hentes fra utdanningsregisteret og vises

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 15.1 | Se URL til beskrivelse av utdanningstilbudet | 1. Gå til «Opptak», velg opptaket «[Fylles ut: opptak for økt 2]», og velg «Gå til utdanningstilbud». <br>2. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud med beskrivelses-URL i utdanningsregisteret]». <br>3. Se på «Lenke til utdanning» i delen «Basisinformasjon». <br>4. Velg lenken. | «Lenke til utdanning» viser lenken til beskrivelsen. Lenken åpnes i en ny fane, og fører til beskrivelsen av utdanningen. | | |
| 15.2 | Utdanningstilbud uten beskrivelses-URL | 1. Gå tilbake til lista over utdanningstilbud i det samme opptaket. <br>2. Velg utdanningstilbudet «[Fylles ut: utdanningstilbud uten beskrivelses-URL i utdanningsregisteret]». <br>3. Se på «Lenke til utdanning» i delen «Basisinformasjon». | «Lenke til utdanning» viser «-», og ingen lenke. | | |

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| Overstyre regel for poenglikhet (9.2): at den overstyrte regelen brukes | Regelen brukes i rangeringen i plasstildelingen, og det kan ikke ses på utdanningstilbudet. 9.2 tester at valget lagres. | Når plasstildelingen kan kjøres i testmiljøet, og akseptansetesten av den har testdata med poenglikhet |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Fjerne: «Fjern utdanningstilbud» skal ikke vises etter at opptaket har åpnet for søknad | Venter på verifisering: løsningen skjuler valget når redigeringsfristen er passert, ikke når opptaket åpner for søknad |
| Fjerne: deltakende organisasjon kan ikke fjerne et utdanningstilbud en annen organisasjon tilbyr | Venter på verifisering: ikke levert ennå (SHI-747) |
| Fjerne: forvaltende organisasjon fjerner etter redigeringsfristen | Venter på verifisering: løsningen skjuler valget for alle når redigeringsfristen er passert |
| Legge til alle utdanningstilbudene i en filtrert liste | Venter på verifisering: «Velg alle» velger bare de 50 radene som er lastet |
| Legge til: se bare utdanningstilbud som passer opptakets kriterier | Venter på verifisering: opptaket har ingen kriterier ennå |
| Legge til: filtrere på utdanningstype og NKR-nivå (4 scenarioer) | Venter på verifisering: det finnes ikke filter på utdanningstype eller NKR 5.1/5.2 |
| Legge til: redigering er stengt når åpningsdatoen ikke er satt | Venter på verifisering: løsningen holder redigeringen åpen |
| Legge til: endringer fra utdanningsregisteret oppdateres etter at redigering stenger | Venter på verifisering: utdanningstilbudene oppdateres ikke automatisk |
| Legge til: deltakende organisasjon kan ikke redigere et utdanningstilbud en annen organisasjon tilbyr | Venter på verifisering: ikke levert ennå (SHI-747) |
| Liste: deltakende organisasjon ser bare utdanningstilbudene sine (2 scenarioer) | Venter på verifisering: deltakende organisasjon ser alle utdanningstilbudene i opptaket |
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
