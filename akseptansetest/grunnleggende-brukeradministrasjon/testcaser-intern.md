# Intern akseptansetest – Grunnleggende brukeradministrasjon

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5125963817 (utkast)
- **Scope**: @scope-grunnleggende-brukeradministrasjon, @scope-restanser-etter-onboarding, @scope-synlighet-og-gjelder-for   (bare på deler av kravene; kilden er kravmappa)
- **Krav**: 5 feature-filer, commit `64d875a` (2026-10-21), lest fra `origin/main`
- **Ord fra skjermen**: fs-admin `origin/main` `276c822e4` (2026-10-21), lest med `git show`; den lokale klonen er ikke oppdatert
- **Verifisering**: `verify-1 - Grunnleggende brukeradministrasjon-2026-10-14-1544.md` og `roller-gjelder-for/spec/verify-2026-10-19-0839.md`, 32 av 38 funnet, 6 usikre (tatt med etter beslutning fra testansvarlig)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5126127626 (utkast)
- **Laget**: 2026-10-21 av fs-testcaser-intern
- **Sporing**:

  | Nr | Feature-ID | Regel | Scenario |
  |---|---|---|---|
  | 1.1 | `@BRU-PER-GRU-004` | Deaktivering fryser tildelingene | Deaktivere en personbruker med aktive tildelinger |
  | 1.2 | `@BRU-PER-GRU-004` | Skille mellom deaktivering og fjerning | Deaktivering skiller seg fra fjerning av tildelinger |
  | 2.1 | `@BRU-PER-GRU-012` | En fjerning gjelder én rolle for en organisasjon og et miljø | Fjerne en rolle for valgt organisasjon og miljø |
  | 2.2 | `@BRU-PER-GRU-012` | En eller flere roller kan fjernes i én operasjon | Fjerne en aktiv rolle fra en personbruker |
  | 2.3 | `@BRU-PER-GRU-012` | En eller flere roller kan fjernes i én operasjon | Fjerne flere roller samtidig |
  | 2.4 | `@BRU-PER-GRU-012` | Bruker kan kun fjerne roller de har rettighet til å fjerne | Fjerning er ikke tilgjengelig for roller uten rettighet |
  | 2.5 | `@BRU-PER-GRU-012` | Bruker kan kun fjerne roller de har rettighet til å fjerne | Fjerning er begrenset til organisasjoner jeg administrerer |
  | 3.1 | `@BRU-PER-GRU-007` | Detaljer organiseres i logiske datagrupper | Se navn |
  | 3.2 | `@BRU-PER-GRU-007` | Detaljer organiseres i logiske datagrupper | Se Feide-ID |
  | 3.3 | `@BRU-PER-GRU-007` | Detaljer organiseres i logiske datagrupper | Se hjemorganisasjon |
  | 3.4 | `@BRU-PER-GRU-007` | Detaljer organiseres i logiske datagrupper | Hjemorganisasjonen er ukjent |
  | 3.5 | `@BRU-PER-GRU-007` | Detaljer organiseres i logiske datagrupper | Se status |
  | 4.1 | `@BRU-PER-GRU-001` | Liste over alle personbrukere | Se liste over personbrukere |
  | 4.2 | `@BRU-PER-GRU-001` | Liste over alle personbrukere | Liste viser de 50 første personbrukerne |
  | 4.3 | `@BRU-PER-GRU-001` | Liste over alle personbrukere | Laste inn 50 flere personbrukere |
  | 4.4 | `@BRU-PER-GRU-001` | Liste over alle personbrukere | Alle personbrukere er lastet inn |
  | 4.5 | `@BRU-PER-GRU-001` | Liste over alle personbrukere | Navigere til detaljside for personbruker |
  | 4.6 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Fritekst-søk på navn |
  | 4.7 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Fritekst-søk på Feide-ID |
  | 4.8 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Tilgjengelige statuser i filter |
  | 4.9 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Filtrere på status |
  | 4.10 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Tilgjengelige hjemorganisasjoner i filter |
  | 4.11 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Filtrere på hjemorganisasjon |
  | 4.12 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Tilgjengelige roller i filter |
  | 4.13 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Filtrere på rolle |
  | 4.14 | `@BRU-PER-GRU-001` | Søk og filtrering av personbrukere | Kombinere søk og filtre |
  | 4.15 | `@BRU-PER-GRU-001` | Synlighet via administrasjonsrettigheter | Brukeradministrator ser personbrukere med hjemorganisasjon i organisasjonene jeg administrerer |
  | 4.16 | `@BRU-PER-GRU-001` | Synlighet via administrasjonsrettigheter | Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer |
  | 4.17 | `@BRU-PER-GRU-001` | Synlighet via administrasjonsrettigheter | Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer |
  | 5.1 | `@BRU-PER-GRU-008` | Visning av roller | Se brukerens roller med «Gjelder for» |
  | 5.2 | `@BRU-PER-GRU-008` | Filtrering av roller | Filtrere på navn |
  | 5.3 | `@BRU-PER-GRU-008` | Filtrering av roller | Tilgjengelige organisasjoner i filter |
  | 5.4 | `@BRU-PER-GRU-008` | Filtrering av roller | Filtrere på organisasjon |
  | 5.5 | `@BRU-PER-GRU-008` | Filtrering av roller | Tilgjengelige miljøer i filter |
  | 5.6 | `@BRU-PER-GRU-008` | Filtrering av roller | Filtrere på miljø |
  | 5.7 | `@BRU-PER-GRU-008` | Filtrering av roller | Kombinere filtre |

  Ikke testbart nå (uten nummer): `@BRU-PER-GRU-012` «Tilganger som kom fra rollen faller bort» og «Tilgang som også er tildelt direkte består», og delen «hvem som gjorde den» i `@BRU-PER-GRU-004` «Deaktivere en personbruker med aktive tildelinger».

---

Intern akseptansetest av «Grunnleggende brukeradministrasjon». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5125963817). Felt med gul bakgrunn fylles ut av teamet før testen.

Testen går i testmiljøet: [Fylles ut: URL]. Menypunktet «Personbrukere» vises der bare når flaggene `tilgangsstyring-meny` og `tilgangsstyring-brukeradministrasjon` er på. Fs-admin har dem alltid på i development, review og test [Fylles ut: bekreftet av teamet].

## Slik tester du

- Ta testcasene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med alvorlighetsgrad. Spørsmål underveis tas i Slack-tråden «Akseptansetesting Grunnleggende brukeradministrasjon».
- Del 1 og 2 endrer de ekte tilgangene til testbrukerne. Gjør radene «Gjør klar til neste test», så alt er satt tilbake når testen er ferdig.

## Testcaser

### Del 1: Aktivere og deaktivere en personbrukers samlede tilganger (aktivere_og_deaktivere_bruker.feature)

#### Regel: Deaktivering fryser tildelingene

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.1 | Deaktivere en personbruker med aktive tildelinger | 1. Logg inn med Feide som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>3. Skriv inn navnet på personbrukeren som skal deaktiveres ([Fylles ut: testbruker fra testdata, med flere aktive roller]) i «Navn». <br>4. Velg personbrukeren i listen. <br>5. Velg fanen «Roller», og noter rollene i lista. <br>6. Velg «Deaktiver» øverst på siden. <br>7. Velg «Deaktiver bruker» i dialogen «Deaktivere bruker?». <br>8. Last siden på nytt. <br>9. Velg fanen «Detaljer». <br>10. Velg fanen «Roller». <br>11. Be personbrukeren logge inn i FS Admin. | Etter steg 8 viser «Status» øverst på siden «Deaktivert», og knappen «Aktiver» vises i stedet for «Deaktiver». Under «Detaljer» står tidspunktet for deaktiveringen ved «Deaktivert». Under «Roller» står de samme rollene som i steg 5. Personbrukeren kommer ikke til dataene i FS Admin ved innloggingen [Sjekk begrep: hva personbrukeren ser]. | | |
| | | *Gjør klar til neste test: velg «Aktiver» på personbrukeren, og deretter «Aktiver bruker».* | | | |

#### Regel: Skille mellom deaktivering og fjerning

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.2 | Deaktivering skiller seg fra fjerning av tildelinger | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på personbrukeren fra 1.1. <br>2. Sjekk at «Status» er «Aktiv». <br>3. Velg fanen «Roller», og noter rollene i lista. <br>4. Velg «Deaktiver». <br>5. Velg «Deaktiver bruker» i dialogen. <br>6. Last siden på nytt, og velg fanen «Roller». <br>7. Velg «Aktiver». <br>8. Velg «Aktiver bruker» i dialogen «Aktivere bruker?». <br>9. Last siden på nytt, og velg fanen «Roller». <br>10. Be personbrukeren logge inn i FS Admin. | Etter steg 6 er «Status» «Deaktivert», og alle rollene fra steg 3 står fortsatt under «Roller». Etter steg 9 er «Status» «Aktiv», og de samme rollene står der, uten at noen er tildelt på nytt. Personbrukeren kommer inn i FS Admin og har tilgangen rollene gir, igjen. | | |

### Del 2: Fjerne roller fra en personbruker (fjerne_roller.feature)

#### Regel: En fjerning gjelder én rolle for en organisasjon og et miljø

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.1 | Fjerne en rolle for valgt organisasjon og miljø | 1. Logg inn som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>3. Skriv inn navnet på personbrukeren som har samme rolle i flere kombinasjoner av organisasjon og miljø ([Fylles ut: testbruker fra testdata]) i «Navn». <br>4. Velg personbrukeren i listen. <br>5. Velg fanen «Roller», og noter hvilke kombinasjoner av «Gjelder for» og «Miljø» rollen [Fylles ut: rolle] har. <br>6. Velg «Fjern roller». <br>7. Velg [Fylles ut: organisasjon A] i «Organisasjon». <br>8. Velg [Fylles ut: miljø] i «Miljø». <br>9. Kryss av for [Fylles ut: rolle] under «Roller». <br>10. Velg «Fjern roller». <br>11. Last siden på nytt, og velg fanen «Roller». | Meldingen «1 rolle fjernet» vises. Etter steg 11 står ikke rollen lenger med organisasjonen og miljøet fra steg 7 og 8, men den står fortsatt med de andre kombinasjonene fra steg 5. | | |

#### Regel: En eller flere roller kan fjernes i én operasjon

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.2 | Fjerne en aktiv rolle fra en personbruker | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på personbrukeren fra 2.1, fanen «Roller». <br>2. Noter en aktiv rolle i lista ([Fylles ut: rolle]), med «Gjelder for» og «Miljø». <br>3. Velg «Fjern roller». <br>4. Velg organisasjonen fra steg 2 i «Organisasjon». <br>5. Velg miljøet fra steg 2 i «Miljø». <br>6. Kryss av for rollen fra steg 2 under «Roller». <br>7. Velg «Fjern roller». <br>8. Last siden på nytt, og velg fanen «Roller». | Meldingen «1 rolle fjernet» vises. Etter steg 8 står ikke rollen fra steg 2 lenger i lista med den organisasjonen og det miljøet. | | |
| 2.3 | Fjerne flere roller samtidig | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på personbrukeren fra 2.1, fanen «Roller». <br>2. Noter to roller med samme «Gjelder for» og «Miljø» ([Fylles ut: rolle 1 og rolle 2]). <br>3. Velg «Fjern roller». <br>4. Velg organisasjonen fra steg 2 i «Organisasjon». <br>5. Velg miljøet fra steg 2 i «Miljø». <br>6. Kryss av for begge rollene under «Roller». <br>7. Velg «Fjern roller». <br>8. Last siden på nytt, og velg fanen «Roller». | Meldingen «2 roller fjernet» vises. Etter steg 8 står ingen av de to rollene lenger i lista med den organisasjonen og det miljøet. | | |

#### Regel: Bruker kan kun fjerne roller de har rettighet til å fjerne

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.4 | Fjerning er ikke tilgjengelig for roller uten rettighet | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>3. Skriv inn navnet på personbrukeren som har en rolle testbruker 1 ikke har rett til å fjerne ([Fylles ut: testbruker fra testdata]) i «Navn», og velg personbrukeren i listen. <br>4. Velg fanen «Roller», og finn rollen [Fylles ut: rolle, organisasjon og miljø]. <br>5. Velg «Fjern roller». <br>6. Åpne «Organisasjon», og se om organisasjonen fra steg 4 kan velges. <br>7. Kan den velges: velg den, og velg miljøet fra steg 4 i «Miljø». <br>8. Se under «Roller». | Rollen fra steg 4 kan ikke velges for fjerning: organisasjonen eller miljøet finnes ikke i valgene, eller rollen står ikke under «Roller». | | |
| 2.5 | Fjerning er begrenset til organisasjoner jeg administrerer | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på personbrukeren fra 2.4. <br>2. Velg fanen «Roller», og sjekk at «Gjelder for» har roller i både [Fylles ut: organisasjon A] og [Fylles ut: organisasjon B]. <br>3. Velg «Fjern roller». <br>4. Åpne «Organisasjon». | «Organisasjon» viser bare organisasjoner testbruker 1 er brukeradministrator for, med [Fylles ut: organisasjon A], og ikke [Fylles ut: organisasjon B]. Rollene i [Fylles ut: organisasjon B] kan ikke fjernes. | | |
| | | *Gjør klar til neste test: velg «Avbryt». Gå til personbrukeren fra 2.1, velg «Tildel roller», og tildel rollene som ble fjernet i 2.1–2.3, med samme organisasjon og miljø.* | | | |

#### Regel: Fjerning av en rolle fjerner tilgangene rollen ga

Begge scenarioene står i «Ikke testbart nå».

### Del 3: Se detaljer for personbruker (se_detaljer.feature)

#### Regel: Detaljer organiseres i logiske datagrupper

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.1 | Se navn | 1. Logg inn som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>3. Skriv inn [Fylles ut: navnet på en personbruker med hjemorganisasjon i organisasjon A] i «Navn». <br>4. Velg personbrukeren i listen. | Detaljsiden åpnes på fanen «Detaljer». «Navn» viser [Fylles ut: navnet]. | | |
| 3.2 | Se Feide-ID | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på personbrukeren fra 3.1, fanen «Detaljer». | «Feide-ID» viser [Fylles ut: Feide-ID-en til personbrukeren]. | | |
| 3.3 | Se hjemorganisasjon | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på personbrukeren fra 3.1, fanen «Detaljer». | «Hjemorganisasjon» viser [Fylles ut: organisasjon A]. | | |
| 3.4 | Hjemorganisasjonen er ukjent | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>3. Skriv inn [Fylles ut: navnet på personbrukeren med et domene i Feide-ID-en som ikke er registrert på noen organisasjon] i «Navn», og velg personbrukeren i listen. <br>4. Se «Hjemorganisasjon» under «Detaljer». <br>5. Velg fanen «Roller», og noter organisasjonene under «Gjelder for». | «Hjemorganisasjon» viser «-». Ingen av organisasjonene fra steg 5 står som hjemorganisasjon. | | |
| 3.5 | Se status | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Åpne personbrukeren fra 3.1, fanen «Detaljer». | «Status» viser «Aktiv». (Visningen av «Deaktivert» er testet i 1.1.) | | |

### Del 4: Listevisning og søk i personbrukere (søke_opp_bruker.feature)

#### Regel: Liste over alle personbrukere

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.1 | Se liste over personbrukere | 1. Logg inn som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». | Siden «Personbrukere» viser en liste under «Resultater». Hver rad viser «Navn», «Feide-ID», «Hjemorganisasjon» og «Status». Listen er sortert etter navn, fra A til Å. | | |
| 4.2 | Liste viser de 50 første personbrukerne | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere» uten søk eller filter. <br>2. Les teksten over eller under listen om hvor mange rader som vises. <br>3. Tell radene i listen. | Teksten «Viser 50 av [antall] rader» vises, der [antall] er det totale antallet treff. Listen har 50 rader. | | |
| 4.3 | Laste inn 50 flere personbrukere | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere» med 50 rader lastet. <br>2. Velg «Last inn flere». | Listen har 50 rader til (eller resten, hvis det er færre enn 50 igjen), og teksten viser for eksempel «Viser 100 av [antall] rader». De første 50 radene står fortsatt øverst. | | |
| 4.4 | Alle personbrukere er lastet inn | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Velg «Last inn flere» til teksten viser samme tall to ganger («Viser [antall] av [antall] rader»). | Når alle er lastet, viser teksten «Viser [antall] av [antall] rader», og «Last inn flere» vises ikke. | | |
| 4.5 | Navigere til detaljside for personbruker | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Noter navnet og Feide-ID-en i en rad. <br>3. Velg raden. | Detaljsiden for personbrukeren åpnes, med navnet og Feide-ID-en fra steg 2. | | |

#### Regel: Søk og filtrering av personbrukere

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.6 | Fritekst-søk på navn | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Skriv inn [Fylles ut: en del av et navn, for eksempel et etternavn] i «Navn». | Listen viser bare personbrukere der navnet inneholder teksten fra steg 2. | | |
| 4.7 | Fritekst-søk på Feide-ID | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Tøm «Navn». <br>3. Skriv inn [Fylles ut: en del av en Feide-ID, for eksempel domenet til organisasjon A] i «Feide-ID». | Listen viser bare personbrukere der Feide-ID-en inneholder teksten fra steg 3. | | |
| 4.8 | Tilgjengelige statuser i filter | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Tøm «Feide-ID». <br>3. Åpne «Status». | «Status» har valgene «Alle statuser», «Aktiv» og «Deaktivert». «Alle statuser» er valgt fra før. | | |
| 4.9 | Filtrere på status | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Velg «Aktiv» i «Status». | Listen viser bare personbrukere med status «Aktiv». | | |
| | | *Gjør klar til neste test: velg «Alle statuser» i «Status».* | | | |
| 4.10 | Tilgjengelige hjemorganisasjoner i filter | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere» uten søk eller filter. <br>2. Velg «Last inn flere» til alle personbrukerne er lastet. <br>3. Noter hjemorganisasjonene i listen. <br>4. Åpne «Hjemorganisasjon». | «Hjemorganisasjon» har de samme hjemorganisasjonene som i steg 3, og ingen andre. Hver står én gang, og de er sortert alfabetisk. «Alle hjemorganisasjoner» er valgt fra før. | | |
| 4.11 | Filtrere på hjemorganisasjon | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Velg [Fylles ut: organisasjon A] i «Hjemorganisasjon». | Listen viser bare personbrukere med [Fylles ut: organisasjon A] i «Hjemorganisasjon». | | |
| | | *Gjør klar til neste test: velg «Alle hjemorganisasjoner» i «Hjemorganisasjon».* | | | |
| 4.12 | Tilgjengelige roller i filter | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Åpne «Rolle». | «Rolle» har rollene som er tildelt minst én personbruker i listen, med rollene til testbrukerne i testdataene ([Fylles ut: roller]). Hver rolle står én gang, og de er sortert alfabetisk. «Alle roller» er valgt fra før. | | |
| 4.13 | Filtrere på rolle | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Velg [Fylles ut: rolle] i «Rolle». <br>3. Velg en av personbrukerne i listen, og velg fanen «Roller». | Listen viser bare personbrukere som har rollen fra steg 2. Under «Roller» i steg 3 står rollen. | | |
| | | *Gjør klar til neste test: gå tilbake til «Personbrukere», og velg «Alle roller» i «Rolle».* | | | |
| 4.14 | Kombinere søk og filtre | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på siden «Personbrukere». <br>2. Skriv inn [Fylles ut: en del av et navn] i «Navn». <br>3. Skriv inn [Fylles ut: en del av en Feide-ID] i «Feide-ID». <br>4. Velg «Aktiv» i «Status». <br>5. Velg [Fylles ut: organisasjon A] i «Hjemorganisasjon». | Listen viser bare personbrukere der navnet og Feide-ID-en inneholder tekstene fra steg 2 og 3, med status «Aktiv» og hjemorganisasjon [Fylles ut: organisasjon A]. | | |
| | | *Gjør klar til neste test: tøm «Navn» og «Feide-ID», og velg «Alle statuser» og «Alle hjemorganisasjoner».* | | | |

#### Regel: Synlighet via administrasjonsrettigheter

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.15 | Brukeradministrator ser personbrukere med hjemorganisasjon i organisasjonene jeg administrerer | 1. Logg ut av FS Admin [Sjekk begrep: hvor man logger ut], og lukk nettleservinduet. <br>2. Logg inn med Feide som testbruker 3 ([Fylles ut: navn], brukeradministrator i bare ett miljø ([Fylles ut: miljø]) ved [Fylles ut: organisasjon A]). <br>3. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>4. Skriv inn [Fylles ut: navnet på en personbruker med hjemorganisasjon i organisasjon A, og roller bare i et annet miljø enn testbruker 3 administrerer] i «Navn». | Personbrukeren står i listen, med [Fylles ut: organisasjon A] i «Hjemorganisasjon». | | |
| 4.16 | Brukeradministrator ser personbrukere fra andre organisasjoner med aktiv rolle i organisasjonene jeg administrerer | 1. Logg ut, og logg inn med Feide som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>3. Skriv inn [Fylles ut: navnet på personbrukeren med hjemorganisasjon utenfor organisasjon A og en aktiv rolle i organisasjon A] i «Navn». | Personbrukeren står i listen. «Hjemorganisasjon» viser personbrukerens egen hjemorganisasjon ([Fylles ut: organisasjon]), ikke [Fylles ut: organisasjon A]. | | |
| 4.17 | Personbrukere med annen hjemorganisasjon er ikke synlige når rollen gjelder i et miljø jeg ikke administrerer | 1. Logg ut, og logg inn med Feide som testbruker 3 ([Fylles ut: navn], brukeradministrator i bare ett miljø ([Fylles ut: miljø]) ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>3. Skriv inn [Fylles ut: navnet på personbrukeren med hjemorganisasjon utenfor organisasjon A, og eneste aktive rolle i organisasjon A i et annet miljø] i «Navn». | Personbrukeren står ikke i listen. Teksten «Ingen personbrukere funnet» vises. | | |

### Del 5: Se en personbrukers roller (vise_roller.feature)

#### Regel: Visning av roller

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 5.1 | Se brukerens roller med «Gjelder for» | 1. Logg ut, og logg inn med Feide som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]). <br>2. Velg «Tilgangsstyring» i menyen, og deretter «Personbrukere». <br>3. Skriv inn navnet på personbrukeren med roller i både organisasjon A og B ([Fylles ut: testbruker fra testdata]) i «Navn», og velg personbrukeren i listen. <br>4. Velg fanen «Roller». | Under «Resultater» står én rad per rolle. Hver rad viser rollens navn med beskrivelsen, «Gjelder for», «Miljø», «Tildelt av» og «Tildelt dato». | | |

#### Regel: Filtrering av roller

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 5.2 | Filtrere på navn | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på fanen «Roller» fra 5.1. <br>2. Skriv inn [Fylles ut: en del av navnet på en rolle] i «Navn» under «Filter». | Lista viser bare roller der navnet inneholder teksten fra steg 2. | | |
| | | *Gjør klar til neste test: tøm «Navn» under «Filter».* | | | |
| 5.3 | Tilgjengelige organisasjoner i filter | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på fanen «Roller» fra 5.1, uten filter. <br>2. Noter organisasjonene i kolonnen «Gjelder for». <br>3. Åpne «Gjelder for» under «Filter». | «Gjelder for» har de samme organisasjonene som i steg 2, og ingen andre. Hver står én gang, og de er sortert alfabetisk. «Alle organisasjoner» er valgt fra før. | | |
| 5.4 | Filtrere på organisasjon | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på fanen «Roller» fra 5.1. <br>2. Velg [Fylles ut: organisasjon A] i «Gjelder for» under «Filter». | Lista viser bare roller med [Fylles ut: organisasjon A] i «Gjelder for». | | |
| | | *Gjør klar til neste test: velg «Alle organisasjoner» i «Gjelder for».* | | | |
| 5.5 | Tilgjengelige miljøer i filter | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på fanen «Roller» fra 5.1, uten filter. <br>2. Noter miljøene i kolonnen «Miljø». <br>3. Åpne «Miljø» under «Filter». | «Miljø» har de samme miljøene som i steg 2, og ingen andre. Hvert står én gang, og de er sortert alfabetisk. «Alle miljøer» er valgt fra før. | | |
| 5.6 | Filtrere på miljø | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på fanen «Roller» fra 5.1. <br>2. Velg [Fylles ut: miljø] i «Miljø» under «Filter». | Lista viser bare roller med [Fylles ut: miljø] i «Miljø». | | |
| | | *Gjør klar til neste test: velg «Alle miljøer» i «Miljø».* | | | |
| 5.7 | Kombinere filtre | 1. Fortsett som testbruker 1 ([Fylles ut: navn], brukeradministrator i alle miljøer ved [Fylles ut: organisasjon A]), på fanen «Roller» fra 5.1. <br>2. Skriv inn [Fylles ut: en del av navnet på en rolle] i «Navn» under «Filter». <br>3. Velg [Fylles ut: organisasjon] i «Gjelder for». <br>4. Velg [Fylles ut: miljø] i «Miljø». | Lista viser bare roller der navnet inneholder teksten fra steg 2, med organisasjonen fra steg 3 og miljøet fra steg 4. | | |

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| Fjerne roller: Tilganger som kom fra rollen faller bort | Fanen «Tilganger» er slått av på detaljsiden, så tilgangene en rolle gir, kan ikke ses i FS Admin | Når fanen «Tilganger» er slått på, eller teamet har beskrevet en annen måte å se tilgangene på [Fylles ut] |
| Fjerne roller: Tilgang som også er tildelt direkte består | Som over. Tilganger kan heller ikke tildeles direkte i FS Admin, så testdataene kan ikke lages der | Som over, og når testdataene finnes [Fylles ut] |
| Deaktivere en personbruker: det lagres hvem som gjorde deaktiveringen (del av 1.1) | FS Admin viser når personbrukeren ble deaktivert, men ikke hvem som gjorde det | [Fylles ut: om og når det skal vises] |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Reaktivere en deaktivert personbruker, med historikken om deaktiveringen | Kommer senere: historikken lagres ikke ennå |
| Valglistene for organisasjon og miljø følger rettigheten til å fjerne roller | Kommer senere |
| Akronym og søk i filtrene for hjemorganisasjon og organisasjon | Kommer senere |
| Personbrukere med annen hjemorganisasjon er ikke synlige uten aktiv rolle i organisasjonene jeg administrerer | Kommer senere |
| Tildele roller til en personbruker | Kommer senere |
| Se, tildele og fjerne tilganger | Kommer senere: planlagt etter første versjon |
| Stedkoder og start- og sluttidspunkt for tildelinger | Kommer senere |
| Automatisk synkronisering av roller | Kommer senere |
| Velge sorteringsretning for navn i listen | Ikke avklart ennå |
| «Sist brukt» i listen og på detaljsiden | Ikke avklart ennå |
| Tidsbegrensning og stedkoder på en rolle | Ikke avklart ennå |
| Historikk for fjerning av roller | Ikke avklart ennå |
| Synlighet via datatilgang | Skal fjernes |

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
