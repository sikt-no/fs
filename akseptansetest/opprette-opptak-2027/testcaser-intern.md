# Intern akseptansetest – Opprette opptak 2027

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165
- **Scope**: @scope-opprette-opptak-2027
- **Krav**: 5 feature-filer, commit `a8d128e` (2026-10-21). Alle scenarioene testes, også i kravene som er `@in-progress` (avgjort av produkteier 21.10.2026)
- **Verifisering**: verify-2026-10-21-1442.md (50 av 63 funnet) og verify-2026-10-21-2142.md (12 av 12)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126422620
- **Laget**: 2026-10-21 av fs-testcaser-intern. 100 testcaser, 2 ikke testbare nå
- **Sporing**:

  | Nr | Feature-ID | Regel | Scenario |
  |---|---|---|---|
  | 1.1 | `@OPT-OVO-GRU-001` | Opptaksforvalter kan opprette et opptak | Opprette et samordna opptak |
  | 1.2 | `@OPT-OVO-GRU-001` | Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak | Lagre opptak uten navn |
  | 1.3 | `@OPT-OVO-GRU-001` | Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak | Lagre opptak uten regelverkssamling |
  | 1.4 | `@OPT-OVO-GRU-001` | Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak | Lagre opptak uten opptakstype |
  | 1.5a | `@OPT-OVO-GRU-001` | Utdanningsbakgrunner, poenglikhetsregel, maks antall søknadsalternativer og tak for tilbud per tildelingsrunde må være satt for å lagre et opptak | Lagre opptak uten <innstilling> (utdanningsbakgrunner) |
  | 1.5b | `@OPT-OVO-GRU-001` | Utdanningsbakgrunner, poenglikhetsregel, maks antall søknadsalternativer og tak for tilbud per tildelingsrunde må være satt for å lagre et opptak | Lagre opptak uten <innstilling> (standard poenglikhetsregel) |
  | 1.5c | `@OPT-OVO-GRU-001` | Utdanningsbakgrunner, poenglikhetsregel, maks antall søknadsalternativer og tak for tilbud per tildelingsrunde må være satt for å lagre et opptak | Lagre opptak uten <innstilling> (maks antall søknadsalternativer) |
  | 1.5d | `@OPT-OVO-GRU-001` | Utdanningsbakgrunner, poenglikhetsregel, maks antall søknadsalternativer og tak for tilbud per tildelingsrunde må være satt for å lagre et opptak | Lagre opptak uten <innstilling> (tak for antall tilbud per tildelingsrunde) |
  | 1.6 | `@OPT-OVO-GRU-001` | Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne | Angi opptaksnavn på flere språk |
  | 1.7 | `@OPT-OVO-GRU-001` | Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne | Lagre opptak med navn på alle obligatoriske språk |
  | 1.8a | `@OPT-OVO-GRU-001` | Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne | Navn mangler på et obligatorisk språk (bokmål) |
  | 1.8b | `@OPT-OVO-GRU-001` | Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne | Navn mangler på et obligatorisk språk (nynorsk) |
  | 1.8c | `@OPT-OVO-GRU-001` | Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne | Navn mangler på et obligatorisk språk (engelsk) |
  | 2.1 | `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak | Legge til lærested i samordna opptak |
  | 2.2 | `@OPT-OVO-SAM-001` | Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud |
  | 2.3 | `@OPT-OVO-SAM-001` | Organisasjoner som ikke deltar, kan ikke se opptaket | Organisasjon som ikke deltar, ser ikke opptaket |
  | 2.4 | `@OPT-OVO-SAM-001` | Organisasjoner som ikke deltar, kan ikke se opptaket | Organisasjon som ikke deltar, kan ikke åpne opptaket |
  | 2.5 | `@OPT-OVO-SAM-001` | En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket |
  | 2.6 | `@OPT-OVO-SAM-001` | En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket |
  | 2.7 | `@OPT-OVO-SAM-001` | Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger |
  | 2.8 | `@OPT-OVO-SAM-001` | Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger |
  | 2.9 | `@OPT-OVO-SAM-001` | Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere | Legge til organisasjon som finnes i utdanningsregisteret |
  | 2.10 | `@OPT-OVO-SAM-001` | Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til |
  | 2.11 | `@OPT-OVO-SAM-001` | Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket | Filtrere på universiteter og høyskoler |
  | 2.12 | `@OPT-OVO-SAM-001` | Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket | Filtrere på fagskoler |
  | 2.13 | `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak | Se og navigere til saksbehandlertildelingen for opptaket |
  | 3.1 | `@OPT-OVO-INN-001` | Opptaksforvalter kan endre opptakstype så lenge ingen utdanningstilbud er knyttet til opptaket | Endre opptakstype når ingen utdanningstilbud er knyttet til opptaket |
  | 3.2 | `@OPT-OVO-INN-001` | Opptaksforvalter kan endre opptakstype så lenge ingen utdanningstilbud er knyttet til opptaket | Kan ikke endre opptakstype når utdanningstilbud er knyttet til opptaket |
  | 3.3 | `@OPT-OVO-INN-001` | Opptaksforvalter kan endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket |
  | 3.4 | `@OPT-OVO-INN-001` | Opptaksforvalter kan endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket | Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket |
  | 3.5 | `@OPT-OVO-INN-001` | Opptaksforvalter setter standard poenglikhetsregel for opptaket | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud |
  | 3.6 | `@OPT-OVO-INN-001` | Opptaksforvalter setter standard poenglikhetsregel for opptaket | Standard poenglikhetsregel uten mulighet for unntak |
  | 3.7 | `@OPT-OVO-INN-001` | Opptaksforvalter kan sette startnummer for søknadene | Sette startnummer for søknader i opptaket |
  | 3.8 | `@OPT-OVO-INN-001` | Opptaksforvalter kan sette startnummer for søknadene | Startnummeret er 1 når opptaksforvalter ikke har satt det |
  | 3.9 | `@OPT-OVO-INN-001` | Opptaksforvalter setter tak for antall søknadsalternativer | Sette maks antall søknadsalternativer |
  | 3.10 | `@OPT-OVO-INN-001` | Opptaksforvalter setter tak for antall tilbud per tildelingsrunde | Sette tak for antall tilbud per tildelingsrunde |
  | 3.11 | `@OPT-OVO-INN-001` | Opptaksforvalter setter tak for antall tilbud per tildelingsrunde | Taket er forhåndsutfylt med 1 |
  | 3.12 | `@OPT-OVO-INN-001` | Opptaksforvalter setter tak for antall tilbud per tildelingsrunde | Endre taket etter at opptaket er opprettet |
  | 3.13 | `@OPT-OVO-INN-001` | Opptaksforvalter kan åpne for tidlig opptak | Aktivere tidlig opptak |
  | 3.14 | `@OPT-OVO-INN-001` | Opptaksforvalter kan åpne for tidlig opptak | Sette lenke til informasjon om tidlig opptak |
  | 3.15 | `@OPT-OVO-INN-001` | Opptaksforvalter kan åpne for tidlig opptak | Lenken må være satt når tidlig opptak er aktivert |
  | 3.16 | `@OPT-OVO-INN-001` | Opptaksforvalter kan åpne for søknad på ledige studieplasser | Aktivere ledige studieplasser |
  | 3.17 | `@OPT-OVO-INN-001` | Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket | Legge til utdanningsbakgrunner fra godkjent liste |
  | 3.18 | `@OPT-OVO-INN-001` | Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket | Legge til flere utdanningsbakgrunner |
  | 3.19 | `@OPT-OVO-INN-001` | Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket | Fjerne en utdanningsbakgrunn fra opptaket |
  | 3.20 | `@OPT-OVO-INN-001` | Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket | Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes |
  | 3.21 | `@OPT-OVO-INN-001` | Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket | Den siste utdanningsbakgrunnen kan ikke fjernes |
  | 3.22 | `@OPT-OVO-INN-001` | Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon | Opplasting er åpen når opptaksforvalter ikke har endret innstillingen |
  | 3.23 | `@OPT-OVO-INN-001` | Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon | Åpne for dokumentasjonsopplasting |
  | 3.24 | `@OPT-OVO-INN-001` | Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon | Stenge for dokumentasjonsopplasting |
  | 4.1 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud | Sette når redigering av utdanningstilbud åpner |
  | 4.2 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud | Sette når redigering av utdanningstilbud stenger |
  | 4.3 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne åpne for søkning | Sette søknadsdato |
  | 4.4 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette generell søknadsfrist for opptaket | Sette ordinær søknadsfrist |
  | 4.5 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette omprioriteringsfrist | Sette omprioriteringsfrist |
  | 4.6 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for sletting av søknadsalternativer | Sette frist for sletting av søknadsalternativer |
  | 4.7 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette dokumentasjonsfrister | Sette ordinær dokumentasjonsfrist |
  | 4.8 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette dokumentasjonsfrister | Sette ettersendingsfrist |
  | 4.9 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser | Sette informasjonsfrist for ledige studieplasser |
  | 4.10 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser | Sette dato for når ledige studieplasser kan søkes |
  | 4.11 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser | Sette dato for når ledige studieplasser stenger for søkning |
  | 4.12 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | Sette søknadsfrist for tidlig opptak |
  | 4.13 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | Sette dokumentasjonsfrist for tidlig opptak |
  | 4.14a | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | Opptaket kan ikke lagres uten <frist> når tidlig opptak er aktivert (søknadsfristen for tidlig opptak) |
  | 4.14b | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | Opptaket kan ikke lagres uten <frist> når tidlig opptak er aktivert (dokumentasjonsfristen for tidlig opptak) |
  | 4.14c | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | Opptaket kan ikke lagres uten <frist> når tidlig opptak er aktivert (fristen for å sette poenggrenser for tidlig opptak) |
  | 4.15 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak | Sette frist for poenggrenser for tidlig opptak |
  | 4.16 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for opptaksresultat | Sette dato for når hovedopptaket publiseres og søker kan forvente svar |
  | 4.17 | `@OPT-OVO-FRI-001` | Opptaksforvalter setter dato for aldersberegning | Sette dato for aldersberegning |
  | 4.18 | `@OPT-OVO-FRI-001` | Opptaksforvalter setter dato for aldersberegning | Standarddato når datoen ikke er satt |
  | 4.19 | `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn | Sette frist for endring av utdanningsbakgrunn |
  | 4.20 | `@OPT-OVO-FRI-001` | Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister | Legge til utdanningsbakgrunn med avvikende frister |
  | 4.21a | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (datoen for når redigering av utdanningstilbud åpner) |
  | 4.21b | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (datoen for når redigering av utdanningstilbud stenger) |
  | 4.21c | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (datoen for når søknaden åpner) |
  | 4.21d | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (den ordinære søknadsfristen) |
  | 4.21e | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (omprioriteringsfristen) |
  | 4.21f | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (fristen for sletting av søknadsalternativer) |
  | 4.21g | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (den ordinære dokumentasjonsfristen) |
  | 4.21h | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (ettersendingsfristen) |
  | 4.21i | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (fristen for endring av utdanningsbakgrunn) |
  | 4.21j | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> (datoen for når hovedopptaket publiseres) |
  | 4.22a | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> når ledige studieplasser er aktivert (informasjonsfristen for ledige studieplasser) |
  | 4.22b | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> når ledige studieplasser er aktivert (datoen for når ledige studieplasser kan søkes) |
  | 4.22c | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Opptaket kan ikke lagres uten <frist> når ledige studieplasser er aktivert (datoen for når ledige studieplasser stenger for søkning) |
  | 4.23 | `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | Dato for aldersberegning og avvikende frister kan stå tomme |
  | 5.1 | `@OPT-OVO-OVE-001` | Liste over alle opptak | Se liste over opptak |
  | 5.2 | `@OPT-OVO-OVE-001` | Liste over alle opptak | Liste er sortert etter når opptaket ble opprettet som standard |
  | 5.3a | `@OPT-OVO-OVE-001` | Liste over alle opptak | Velge sorteringsretning for opprettet (stigende) |
  | 5.3b | `@OPT-OVO-OVE-001` | Liste over alle opptak | Velge sorteringsretning for opprettet (synkende) |
  | 5.3c | `@OPT-OVO-OVE-001` | Liste over alle opptak | Velge sorteringsretning for type (stigende) |
  | 5.3d | `@OPT-OVO-OVE-001` | Liste over alle opptak | Velge sorteringsretning for type (synkende) |
  | 5.3e | `@OPT-OVO-OVE-001` | Liste over alle opptak | Velge sorteringsretning for organisasjon (stigende) |
  | 5.3f | `@OPT-OVO-OVE-001` | Liste over alle opptak | Velge sorteringsretning for organisasjon (synkende) |
  | 5.4 | `@OPT-OVO-OVE-001` | Liste over alle opptak | Liste viser de 50 første opptakene |
  | 5.5 | `@OPT-OVO-OVE-001` | Liste over alle opptak | Laste inn 50 flere opptak |
  | 5.6 | `@OPT-OVO-OVE-001` | Liste over alle opptak | Alle opptak er lastet inn |
  | 5.7 | `@OPT-OVO-OVE-001` | Liste over alle opptak | Navigere til detaljside for opptak |
  | 5.8 | `@OPT-OVO-OVE-001` | Søk og filtrering av opptak | Fritekst-søk på navn |
  | 5.9 | `@OPT-OVO-OVE-001` | Søk og filtrering av opptak | Tilgjengelige opptakstyper i filter |
  | 5.10 | `@OPT-OVO-OVE-001` | Søk og filtrering av opptak | Filtrere på opptakstype |
  | 5.11 | `@OPT-OVO-OVE-001` | Søk og filtrering av opptak | Kombinere filtre |

---

Intern akseptansetest av «Opprette opptak 2027». Testbrukere og testdata står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165). Gule felt fylles ut av teamet før testen.

## Slik tester du

- Ta testcasene i rekkefølge. Følg stegene.
- Skriv hva du så i «Faktisk resultat». Sett «Status»: Bestått, Ikke bestått eller Ikke testet.
- «Kjent mangel» betyr at vi vet at det ikke virker ennå. Test likevel, og sett Ikke bestått hvis det ikke virker.
- Funn skrives i «Funn». Spørsmål tas i Slack-tråden.
- Opptakene du lager, kan ikke slettes. Bruk navnene i stegene.
- Kan du ikke velge «Lagre»? Se hva som står under «Fyll ut obligatoriske felt:». Fyll ut det, og skriv det i «Faktisk resultat».
- Testen tas i tre økter. Økt 1 (Del 1–2) står på denne siden. Økt 2 (Del 3) og økt 3 (Del 4–5) er undersider.

## Testcaser

### Del 1: Opprette et opptak (opprett_opptak.feature)

#### Regel: Opptaksforvalter kan opprette et opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.1 | Opprette et samordna opptak | 1. Logg inn som testbruker 1 (Ordentlig rundskriv, HK-dir). <br>2. Gå til «Opptak». Under «SAMORDNA OPPTAK», velg «Opprett». <br>3. Navn på bokmål og nynorsk: «Samordna opptak 2027 (test)». Navn på engelsk: «Coordinated admission 2027 (test)». <br>4. «Opptakstype»: [Fylles ut: opptakstype]. <br>5. «Regelverksamling knyttet til opptaket»: «UHG 2027». <br>6. «Godkjente utdanningsbakgrunner»: «Realkompetanse». <br>7. «Poenglikhetsregel»: «Loddtrekning». <br>8. Velg «Fyll inn testdatoer». Da fylles alle fristene ut. <br>9. Velg «Inviter organisasjoner til samordningen». Velg «Universitetet i Oslo», og så «Legg til 1 organisasjon». <br>10. Velg «Lagre». <br>11. Gå til «Opptak», søk på navnet, og åpne opptaket. | «Lagring vellykket». Opptaket står i lista med HK-dir under «Organisasjon». Universitetet i Oslo står under «Samordnede organisasjoner». | | |

#### Regel: Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.2 | Lagre opptak uten navn | 1. Logg inn som testbruker 1. Gå til «Opptak», og velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Fyll ut som i 1.1, steg 4–8. La navnene stå tomme. <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står de tre navnefeltene. | | |
| 1.3 | Lagre opptak uten regelverkssamling | 1. Velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Fyll ut som i 1.1, steg 3–8. La «Regelverksamling knyttet til opptaket» stå tom. <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Regelverksamling tilknyttet opptaket» står under «Fyll ut obligatoriske felt:». | | |
| 1.4 | Lagre opptak uten opptakstype | 1. Velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Fyll ut som i 1.1, steg 3–8. La «Opptakstype» stå tom. <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Opptakstype» står under «Fyll ut obligatoriske felt:». | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Utdanningsbakgrunner, poenglikhetsregel, maks antall søknadsalternativer og tak for tilbud per tildelingsrunde må være satt for å lagre et opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.5a | Lagre opptak uten utdanningsbakgrunner | 1. Velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Fyll ut som i 1.1, steg 3–8. La «Godkjente utdanningsbakgrunner» stå tom. <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Godkjente utdanningsbakgrunner» står under «Fyll ut obligatoriske felt:». | | |
| 1.5b | Lagre opptak uten standard poenglikhetsregel | 1. Velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Fyll ut som i 1.1, steg 3–8. La «Poenglikhetsregel» stå tom. <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Poenglikhetsregel» står under «Fyll ut obligatoriske felt:». | | |
| 1.5c | Lagre opptak uten maks antall søknadsalternativer. Kjent mangel (TAKE-431) | 1. Velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Fyll ut som i 1.1, steg 3–8. Fjern tallet i «Antall søknadsalternativer». <br>3. Prøv å velge «Lagre». | Opptaket kan ikke lagres. | | |
| 1.5d | Lagre opptak uten tak for antall tilbud per tildelingsrunde. Kjent mangel (TAKE-431) | 1. Velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Fyll ut som i 1.1, steg 3–8. La «Tilbud per tildelingsrunde» stå tom. <br>3. Prøv å velge «Lagre». | Opptaket kan ikke lagres. | | |
| | | *Gjør klar til neste test: velg «Avbryt». Har opptaket blitt lagret, gi det «(test)» i navnet.* | | | |

#### Regel: Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.6 | Angi opptaksnavn på flere språk | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. «Navn på opptaket (samisk)»: «Samordna opptak 2027 (test)». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen, og velg «Endre innstillinger for opptaket». | Navnet står på alle fire språk. | | |
| 1.7 | Lagre opptak med navn på alle obligatoriske språk | 1. Velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Navn på bokmål og nynorsk: «Samordna opptak 2027 navn (test)». Navn på engelsk: «Coordinated admission 2027 name (test)». La samisk stå tomt. <br>3. Fyll ut resten som i 1.1, steg 4–8. <br>4. Velg «Lagre». <br>5. Åpne opptaket igjen, og velg «Endre innstillinger for opptaket». | «Lagring vellykket». Navnene står på bokmål, nynorsk og engelsk. Samisk er tomt. | | |
| 1.8a | Navn mangler på et obligatorisk språk (bokmål) | 1. Velg «Opprett» under «SAMORDNA OPPTAK». <br>2. Fyll ut som i 1.1, steg 3–8. La «Navn på opptaket (bokmål)» stå tom. <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (bokmål)» står under «Fyll ut obligatoriske felt:». | | |
| 1.8b | Navn mangler på et obligatorisk språk (nynorsk) | 1. Fyll ut bokmål. Fjern nynorsk. <br>2. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (nynorsk)» står under «Fyll ut obligatoriske felt:». | | |
| 1.8c | Navn mangler på et obligatorisk språk (engelsk) | 1. Fyll ut nynorsk. Fjern engelsk. <br>2. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (engelsk)» står under «Fyll ut obligatoriske felt:». | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

### Del 2: Samordna opptak (samordna_opptak.feature)

Bruk opptaket fra 1.1, «Samordna opptak 2027 (test)».

#### Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.1 | Legge til lærested i samordna opptak | 1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). <br>2. Gå til «Opptak». <br>3. Skriv inn «Samordna opptak 2027 (test)» i «Opptaksnavn», og velg opptaket. <br>4. Noter adressen (URL) til siden. Den brukes i 2.2 og 2.4. <br>5. Velg «Endre innstillinger for opptaket». <br>6. Under «Samordning», velg «Inviter organisasjoner til samordningen». <br>7. Skriv inn «Norges teknisk» i «Søk etter navn». <br>8. Marker «Norges teknisk-naturvitenskapelige universitet». <br>9. Velg «Legg til 1 organisasjon». <br>10. Velg «Lagre». <br>11. Logg ut, og logg inn/bytt til testbruker 2 (Ansvarsfull Fotkrem, opptaksforvalter ved NTNU). <br>12. Gå til «Opptak», og velg «Samordna opptak 2027 (test)». <br>13. Velg «Gå til utdanningstilbud». <br>14. Velg «Handlinger», og så «Legg til utdanningstilbud». <br>15. Skriv inn [Fylles ut: navn på et utdanningstilbud ved NTNU i TEST] i «Utdanningsnavn». <br>16. Marker utdanningstilbudet. <br>17. Velg «Legg til (1)». <br>18. Gå ut av siden, og velg «Gå til utdanningstilbud» igjen. | Utdanningstilbudet står i lista, med NTNU i «Organisasjon». | | |

#### Regel: Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.2 | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | 1. Logg ut, og logg inn/bytt til testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark). <br>2. Gå til adressen fra 2.1, steg 4, og legg til «/utdanningstilbud» bak. <br>3. Se etter «Handlinger». | «Legg til utdanningstilbud» finnes ikke. | | |

#### Regel: Organisasjoner som ikke deltar, kan ikke se opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.3 | Organisasjon som ikke deltar, ser ikke opptaket. Uavklart: avhenger av et feature-flagg | 1. Som testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark), gå til «Opptak». <br>2. Skriv inn «Samordna opptak 2027 (test)» i «Opptaksnavn». | Opptaket står ikke i lista. | | |
| 2.4 | Organisasjon som ikke deltar, kan ikke åpne opptaket. Kjent mangel (TAKE-434) | 1. Som testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark), gå til adressen fra 2.1, steg 4. | Opptaket vises ikke. [Sjekk begrep: hva siden viser, f.eks. «Siden finnes ikke»] | | |

#### Regel: En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.5 | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket. Kjent mangel (TAKE-433) | Bruk utdanningstilbudet fra 2.1. <br>1. Logg ut, og logg inn/bytt til testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). <br>2. Gå til «Opptak», og velg «Samordna opptak 2027 (test)». <br>3. Velg «Endre innstillinger for opptaket». <br>4. Under «Samordnede organisasjoner», velg krysset («Fjern NTNU») ved NTNU. <br>5. Velg «Lagre». | NTNU fjernes ikke. En melding sier at utdanningstilbudene til NTNU må fjernes først. [Sjekk begrep: teksten i meldingen] | | |
| | | *Gjør klar til neste test: er NTNU fjernet, legg NTNU til igjen som i 2.1, steg 5–10.* | | | |
| 2.6 | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test)». <br>2. Velg «Endre innstillinger for opptaket». <br>3. Under «Samordnede organisasjoner», velg krysset («Fjern …») ved Universitetet i Oslo. <br>4. Velg «Lagre». <br>5. Gå til «Opptak», og åpne opptaket igjen. <br>6. Åpne «Samordnede organisasjoner». | Universitetet i Oslo står ikke under «Samordnede organisasjoner». | | |

#### Regel: Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.7 | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test)». <br>2. Velg «Endre innstillinger for opptaket». <br>3. Velg «Alder, eldre foran yngre» i «Poenglikhetsregel». <br>4. Endre datoen i «Ordinær søknadsfrist» til én dag senere. Noter datoen. <br>5. Velg «Lagre». <br>6. Åpne opptaket igjen. | «Poenglikhetsregel» er «Alder, eldre foran yngre», og «Ordinær søknadsfrist» har den nye datoen. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 2.8 | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger. Kjent mangel (TAKE-432) | 1. Logg ut, og logg inn/bytt til testbruker 2 (Ansvarsfull Fotkrem, opptaksforvalter ved NTNU). <br>2. Gå til «Opptak», og velg «Samordna opptak 2027 (test)». <br>3. Velg «Vis alle frister». <br>4. Se etter «Endre innstillinger for opptaket». | Alle innstillingene og fristene på opptaket vises, også «Alder, eldre foran yngre» og søknadsfristen fra 2.7. «Endre innstillinger for opptaket» finnes ikke, og «Administreres av HK-dir» står der. | | |

#### Regel: Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.9 | Legge til organisasjon som finnes i utdanningsregisteret | 1. Logg ut, og logg inn/bytt til testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). <br>2. Gå til «Opptak», og velg «Samordna opptak 2027 (test)». <br>3. Velg «Endre innstillinger for opptaket». <br>4. Velg «Inviter organisasjoner til samordningen». <br>5. Skriv inn «Universitetet i Oslo» i «Søk etter navn». <br>6. Marker «Universitetet i Oslo». <br>7. Velg «Legg til 1 organisasjon». <br>8. Velg «Lagre». <br>9. Gå til «Opptak», og åpne opptaket igjen. <br>10. Åpne «Samordnede organisasjoner». | Universitetet i Oslo står under «Samordnede organisasjoner». | | |
| 2.10 | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | 1. Som testbruker 1, velg «Endre innstillinger for opptaket» på «Samordna opptak 2027 (test)». <br>2. Velg «Inviter organisasjoner til samordningen». <br>3. Skriv inn [Fylles ut: navn på en organisasjon som ikke finnes i utdanningsregisteret] i «Søk etter navn». | «Ingen treff» vises. Organisasjonen kan ikke markeres. | | |
| | | *Gjør klar til neste test: velg «Lukk».* | | | |

#### Regel: Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.11 | Filtrere på universiteter og høyskoler | 1. Som testbruker 1, velg «Endre innstillinger for opptaket» på «Samordna opptak 2027 (test)». <br>2. Velg «Inviter organisasjoner til samordningen». <br>3. Velg [Sjekk begrep: «Universitet» og «Høgskole»] i «Type lærested». | Bare norske universiteter og høyskoler står i lista. Ingen fagskoler. | | |
| | | *Gjør klar til neste test: fjern valgene i «Type lærested».* | | | |
| 2.12 | Filtrere på fagskoler | Fortsett i dialogen fra 2.11. <br>1. Som testbruker 1, velg [Sjekk begrep: «Fagskole»] i «Type lærested». | Bare norske fagskoler står i lista. | | |
| | | *Gjør klar til neste test: velg «Lukk», og så «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2.13 | Se og navigere til saksbehandlertildelingen for opptaket. Kjent mangel (TAKE-447) | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test)». <br>2. Se etter saksbehandlertildelingen på siden til opptaket. <br>3. Velg «Saksbehandlertildelingsregler». | Siden til opptaket viser saksbehandlertildelingen. Lenken åpner «Behandlertildelingsregler». | | |

### Del 3: Innstillinger for opptak (innstillinger.feature)

#### Regel: Opptaksforvalter kan endre opptakstype så lenge ingen utdanningstilbud er knyttet til opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.1 | Endre opptakstype når ingen utdanningstilbud er knyttet til opptaket | Bruk opptaket fra 1.7 (uten utdanningstilbud). <br>1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). <br>2. Gå til «Opptak». <br>3. Skriv inn «Samordna opptak 2027 navn (test)» i «Opptaksnavn». <br>4. Velg opptaket i lista. <br>5. Velg «Endre innstillinger for opptaket». <br>6. Velg [Fylles ut: en annen opptakstype] i «Opptakstype». <br>7. Velg «Fyll inn testdatoer». <br>8. Velg «Lagre». <br>9. Åpne opptaket igjen. | Lagret. Etterpå står [Fylles ut: en annen opptakstype] i «Opptakstype». | | |
| 3.2 | Kan ikke endre opptakstype når utdanningstilbud er knyttet til opptaket | 1. Som testbruker 1, gå til «Opptak». <br>2. Skriv inn [Fylles ut: navn på opptak med utdanningstilbud] i «Opptaksnavn». <br>3. Velg opptaket i lista. <br>4. Velg «Endre innstillinger for opptaket». <br>5. Prøv å velge en annen verdi i «Opptakstype». | «Opptakstype» kan ikke velges. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter kan endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.3 | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket | 1. Som testbruker 1, åpne «Samordna opptak 2027 navn (test)», og velg «Endre innstillinger for opptaket». <br>2. Velg «UHG 2027 v2» i «Regelverksamling knyttet til opptaket». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. Etterpå står «UHG 2027 v2» i «Regelverksamling knyttet til opptaket». | | |
| 3.4 | Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket | 1. Som testbruker 1, gå til «Opptak». <br>2. Skriv inn [Fylles ut: navn på opptak med utdanningstilbud] i «Opptaksnavn». <br>3. Velg opptaket i lista. <br>4. Velg «Endre innstillinger for opptaket». <br>5. Prøv å velge en annen verdi i «Regelverksamling knyttet til opptaket». | «Regelverksamling knyttet til opptaket» kan ikke velges. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter setter standard poenglikhetsregel for opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.5 | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Velg «Loddtrekning» i «Poenglikhetsregel». <br>3. Kryss av for «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.». <br>4. Velg «Alle søkere med samme poengsum får tilbud» i «Tillatte poenglikhetsregler». <br>5. Velg «Alder, eldre foran yngre» i «Tillatte poenglikhetsregler». <br>6. Velg «Lagre». <br>7. Åpne opptaket igjen. | Lagret. Etterpå står «Loddtrekning» i «Poenglikhetsregel», og «Alle søkere med samme poengsum får tilbud» og «Alder, eldre foran yngre» i «Tillatte poenglikhetsregler». | | |
| 3.6 | Standard poenglikhetsregel uten mulighet for unntak | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Velg «Alder, eldre foran yngre» i «Poenglikhetsregel». <br>3. Fjern krysset for «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.». <br>4. Velg «Lagre». <br>5. Åpne opptaket igjen. | Lagret. Etterpå står «Alder, eldre foran yngre» i «Poenglikhetsregel», og «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.» er ikke krysset av. «Tillatte poenglikhetsregler» vises ikke. | | |

#### Regel: Opptaksforvalter kan sette startnummer for søknadene

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.7 | Sette startnummer for søknader i opptaket | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Skriv inn «1001» i «Startnummer for søknader». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. Etterpå står «1001» i «Startnummer for søknader». | | |
| 3.8 | Startnummeret er 1 når opptaksforvalter ikke har satt det <br>*Kjent mangel (TAKE-431)* | 1. Opprett et opptak som i 1.1, steg 1–8, med navnet «Samordna opptak 2027 startnummer (test)» på alle tre språk. Hopp over steg 9. <br>2. La «Startnummer for søknader» stå tom. <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen, og velg «Endre innstillinger for opptaket». | Lagret. Etterpå står «1» i «Startnummer for søknader». | | |

#### Regel: Opptaksforvalter setter tak for antall søknadsalternativer

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.9 | Sette maks antall søknadsalternativer | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Skriv inn «10» i «Antall søknadsalternativer». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. Etterpå står «10» i «Antall søknadsalternativer». | | |

#### Regel: Opptaksforvalter setter tak for antall tilbud per tildelingsrunde

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.10 | Sette tak for antall tilbud per tildelingsrunde | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Skriv inn «1» i «Tilbud per tildelingsrunde». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. Etterpå står «1» i «Tilbud per tildelingsrunde». | | |
| 3.11 | Taket er forhåndsutfylt med 1 <br>*Kjent mangel (TAKE-431)* | 1. Som testbruker 1, gå til «Opptak». <br>2. Under «SAMORDNA OPPTAK», velg «Opprett». <br>3. Se på «Tilbud per tildelingsrunde». | «1» står i «Tilbud per tildelingsrunde». | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 3.12 | Endre taket etter at opptaket er opprettet | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Skriv inn «2» i «Tilbud per tildelingsrunde». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. Etterpå står «2» i «Tilbud per tildelingsrunde». | | |

#### Regel: Opptaksforvalter kan åpne for tidlig opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.13 | Aktivere tidlig opptak | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Kryss av for «Kan søke på tidlig opptak». <br>3. Velg «Fyll inn testdatoer». <br>4. Velg «Lagre». <br>5. Åpne opptaket igjen. | Lagret. Etterpå er «Kan søke på tidlig opptak» krysset av. | | |
| 3.14 | Sette lenke til informasjon om tidlig opptak <br>*Kjent mangel (TAKE-420)* | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Skriv inn «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i [Sjekk begrep: feltet for informasjonsside om tidlig opptak]. <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. Etterpå står lenken i [Sjekk begrep: feltet for informasjonsside om tidlig opptak]. | | |
| 3.15 | Lenken må være satt når tidlig opptak er aktivert <br>*Kjent mangel (TAKE-420, TAKE-435)* | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Fjern teksten i [Sjekk begrep: feltet for informasjonsside om tidlig opptak]. <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står [Sjekk begrep: feltet for informasjonsside om tidlig opptak]. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter kan åpne for søknad på ledige studieplasser

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.16 | Aktivere ledige studieplasser | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Kryss av for «Ledige studieplasser». <br>3. Velg «Fyll inn testdatoer». <br>4. Noter datoene i «Publiseres på nettsiden», «Åpner for søking» og «Stenger for søking» under «Ledige studieplasser». <br>5. Velg «Lagre». <br>6. Åpne opptaket igjen. | Lagret. Etterpå er «Ledige studieplasser» krysset av, og de samme datoene står under «Ledige studieplasser». | | |

#### Regel: Opptaksforvalter kan legge til utdanningsbakgrunner som gjelder for opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.17 | Legge til utdanningsbakgrunner fra godkjent liste | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Åpne «Godkjente utdanningsbakgrunner». | Lista viser de godkjente utdanningsbakgrunnene: [Fylles ut: de godkjente utdanningsbakgrunnene i TEST]. «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» er med. | | |
| 3.18 | Legge til flere utdanningsbakgrunner | Fortsett på samme side som 3.17. <br>1. Velg «Utenlandsk utdanning» i «Godkjente utdanningsbakgrunner». <br>2. Velg «Steinerskole» i «Godkjente utdanningsbakgrunner». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. Etterpå står «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» i «Godkjente utdanningsbakgrunner». | | |
| 3.19 | Fjerne en utdanningsbakgrunn fra opptaket | Fortsett på samme side som 3.18. <br>1. Fjern «Steinerskole» fra «Godkjente utdanningsbakgrunner». <br>2. Velg «Lagre». <br>3. Åpne opptaket igjen. | Lagret. Etterpå står «Realkompetanse» og «Utenlandsk utdanning» i «Godkjente utdanningsbakgrunner», men ikke «Steinerskole». | | |
| 3.20 | Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes | 1. Som testbruker 1, gå til «Opptak». <br>2. Skriv inn [Fylles ut: navn på opptak der en søker har valgt «Steinerskole»] i «Opptaksnavn». <br>3. Velg opptaket i lista. <br>4. Velg «Endre innstillinger for opptaket». <br>5. Fjern «Steinerskole» fra «Godkjente utdanningsbakgrunner». <br>6. Velg «Lagre». <br>7. Åpne opptaket igjen. | Meldingen «Utdanningsbakgrunnen er valgt av en søker og kan ikke fjernes fra opptaket» vises. Når opptaket åpnes igjen, står «Steinerskole» fortsatt i «Godkjente utdanningsbakgrunner». | | |
| 3.21 | Den siste utdanningsbakgrunnen kan ikke fjernes | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Velg «Steinerskole» i «Godkjente utdanningsbakgrunner». <br>3. Fjern «Realkompetanse» fra «Godkjente utdanningsbakgrunner». <br>4. Fjern «Utenlandsk utdanning» fra «Godkjente utdanningsbakgrunner». <br>5. Fjern «Steinerskole» fra «Godkjente utdanningsbakgrunner». <br>6. Prøv å velge «Lagre». | «Velg minst én utdanningsbakgrunn.» vises ved «Godkjente utdanningsbakgrunner». «Lagre» kan ikke velges, og under knappen står «Fyll ut obligatoriske felt:» med «Godkjente utdanningsbakgrunner». | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter kan styre om søkere kan laste opp dokumentasjon

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3.22 | Opplasting er åpen når opptaksforvalter ikke har endret innstillingen <br>*Kjent mangel (TAKE-431)* | 1. Som testbruker 1, gå til «Opptak». <br>2. Under «SAMORDNA OPPTAK», velg «Opprett». <br>3. Se på «Søker kan laste opp dokumenter». | «Søker kan laste opp dokumenter» er krysset av. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 3.23 | Åpne for dokumentasjonsopplasting | 1. Som testbruker 1, åpne «Samordna opptak 2027 (test)», og velg «Endre innstillinger for opptaket». <br>2. Kryss av for «Søker kan laste opp dokumenter». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. Etterpå er «Søker kan laste opp dokumenter» krysset av. | | |
| 3.24 | Stenge for dokumentasjonsopplasting | Fortsett på samme side som 3.23. <br>1. Fjern krysset for «Søker kan laste opp dokumenter». <br>2. Velg «Lagre». <br>3. Åpne opptaket igjen. | Lagret. Etterpå er «Søker kan laste opp dokumenter» ikke krysset av. | | |

### Del 4: Frister og hendelser for opptak (frister_og_hendelser.feature)

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne åpne og stenge for redigering av utdanningstilbud

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.1 | Sette når redigering av utdanningstilbud åpner | Bruk opptaket fra 1.1. <br>1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). <br>2. Gå til «Opptak», og skriv inn «Samordna opptak 2027 (test)» i «Opptaksnavn». <br>3. Velg opptaket i lista. <br>4. Velg «Endre innstillinger for opptaket». <br>5. Under «Generelle frister», i kortet «Redigering av studier», skriv inn 01.10.2026 kl. 00:00 i «Redigering åpner». <br>6. Velg «Lagre». <br>7. Åpne opptaket igjen. | Lagret. «Redigering åpner» viser 01.10.2026 kl. 00:00. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 4.2 | Sette når redigering av utdanningstilbud stenger | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Redigering av studier», skriv inn 06.06.2027 kl. 23:59 i «Redigering stenger». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Redigering stenger» viser 06.06.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne åpne for søkning

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.3 | Sette søknadsdato | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Søkeperiode», skriv inn 01.02.2027 kl. 00:00 i «Åpner for søking». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Åpner for søking» viser 01.02.2027 kl. 00:00. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette generell søknadsfrist for opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.4 | Sette ordinær søknadsfrist | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Søkeperiode», skriv inn 15.04.2027 kl. 23:59 i «Ordinær søknadsfrist». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Ordinær søknadsfrist» viser 15.04.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette omprioriteringsfrist

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.5 | Sette omprioriteringsfrist | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Endre søknad», skriv inn 15.04.2027 kl. 23:59 i «Omprioriteringsfrist». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Omprioriteringsfrist» viser 15.04.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for sletting av søknadsalternativer

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.6 | Sette frist for sletting av søknadsalternativer | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Endre søknad», skriv inn 15.04.2027 kl. 23:59 i «Slette søknadsalternativer». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Slette søknadsalternativer» viser 15.04.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette dokumentasjonsfrister

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.7 | Sette ordinær dokumentasjonsfrist | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Dokumentasjon», skriv inn 15.04.2027 kl. 23:59 i «Ordinær frist». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Ordinær frist» viser 15.04.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 4.8 | Sette ettersendingsfrist | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Dokumentasjon», skriv inn 01.07.2027 kl. 23:59 i «Ettersendingsfrist». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Ettersendingsfrist» viser 01.07.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for ledige studieplasser

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.9 | Sette informasjonsfrist for ledige studieplasser | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. Under «Valg for opptaket», kryss av for «Ledige studieplasser». <br>3. I kortet «Ledige studieplasser», skriv inn 20.07.2027 kl. 00:00 i «Publiseres på nettsiden». <br>4. Velg «Fyll inn testdatoer». <br>5. Velg «Lagre». <br>6. Åpne opptaket igjen. | Lagret. «Publiseres på nettsiden» viser 20.07.2027 kl. 00:00. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 4.10 | Sette dato for når ledige studieplasser kan søkes | Bruk opptaket fra 4.9. <br>1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Ledige studieplasser», skriv inn 25.07.2027 kl. 00:00 i «Åpner for søking». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Åpner for søking» i kortet «Ledige studieplasser» viser 25.07.2027 kl. 00:00. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 4.11 | Sette dato for når ledige studieplasser stenger for søkning | Bruk opptaket fra 4.9. <br>1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Ledige studieplasser», skriv inn 01.09.2027 kl. 00:00 i «Stenger for søking». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Stenger for søking» viser 01.09.2027 kl. 00:00. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frister for tidlig opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.12 | Sette søknadsfrist for tidlig opptak | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. Under «Valg for opptaket», kryss av for «Kan søke på tidlig opptak». <br>3. I kortet «Tidlig opptak», skriv inn 01.03.2027 kl. 23:59 i «Søknadsfrist». <br>4. Velg «Fyll inn testdatoer». <br>5. Velg «Lagre». <br>6. Åpne opptaket igjen. | Lagret. «Søknadsfrist» i kortet «Tidlig opptak» viser 01.03.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 4.13 | Sette dokumentasjonsfrist for tidlig opptak | Bruk opptaket fra 4.12. <br>1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Tidlig opptak», skriv inn 01.03.2027 kl. 23:59 i «Dokumentasjonsfrist». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Dokumentasjonsfrist» i kortet «Tidlig opptak» viser 01.03.2027 kl. 23:59. | | |
| 4.14a | Opptaket kan ikke lagres uten søknadsfristen for tidlig opptak når tidlig opptak er aktivert | Fortsett på samme side som 4.13. <br>1. I kortet «Tidlig opptak», fjern datoen i «Søknadsfrist». <br>2. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Søknadsfrist (tidlig opptak)». | | |
| 4.14b | Opptaket kan ikke lagres uten dokumentasjonsfristen for tidlig opptak når tidlig opptak er aktivert | Fortsett på samme side som 4.14a. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Tidlig opptak», fjern datoen i «Dokumentasjonsfrist». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Dokumentasjonsfrist (tidlig opptak)». | | |
| 4.14c | Opptaket kan ikke lagres uten fristen for å sette poenggrenser for tidlig opptak når tidlig opptak er aktivert. Kjent mangel (TAKE-427) | Fortsett på samme side som 4.14b. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Tidlig opptak», la «Frist for å sette poenggrenser» stå tom. [Sjekk begrep] <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Frist for å sette poenggrenser (tidlig opptak)». [Sjekk begrep] | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 4.15 | Sette frist for poenggrenser for tidlig opptak. Kjent mangel (TAKE-427) | Bruk opptaket fra 4.12. <br>1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Tidlig opptak», skriv inn 15.02.2027 kl. 23:59 i «Frist for å sette poenggrenser». [Sjekk begrep] <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Frist for å sette poenggrenser» viser 15.02.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette informasjonsdatoer for opptaksresultat

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.16 | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Hovedopptak», skriv inn 15.07.2027 kl. 00:00 i «Publiseringsdato». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Publiseringsdato» viser 15.07.2027 kl. 00:00. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter setter dato for aldersberegning

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.17 | Sette dato for aldersberegning | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Saksbehandling», skriv inn 31.12.2027 i «Dato for aldersberegning». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Dato for aldersberegning» viser 31.12.2027. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 4.18 | Standarddato når datoen ikke er satt | 1. Opprett et opptak som i 1.1, steg 1–8, med navnet «Samordna opptak 2027 alder (test)» på alle tre språk. Hopp over steg 9. <br>2. I kortet «Hovedopptak», skriv inn 15.07.2027 kl. 00:00 i «Publiseringsdato». <br>3. La «Dato for aldersberegning» stå tom. <br>4. Velg «Lagre». <br>5. Åpne opptaket igjen, og velg «Endre innstillinger for opptaket». | Lagret. «Dato for aldersberegning» viser 31.12.2027. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter ved forvaltende organisasjon må kunne sette frist for endring av utdanningsbakgrunn

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.19 | Sette frist for endring av utdanningsbakgrunn | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Saksbehandling», skriv inn 01.05.2027 kl. 23:59 i «Endre utdanningsbakgrunn». <br>3. Velg «Lagre». <br>4. Åpne opptaket igjen. | Lagret. «Endre utdanningsbakgrunn» viser 01.05.2027 kl. 23:59. | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: Opptaksforvalter kan legge til utdanningsbakgrunner med avvikende frister

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.20 | Legge til utdanningsbakgrunn med avvikende frister | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. Under «Utdanningsbakgrunner med avvikende frister», velg «Legg til ny utdanningsbakgrunn». <br>3. Velg «Realkompetanse» i «Utdanningsbakgrunner». <br>4. Velg «Legg til». <br>5. I kortet «Realkompetanse», skriv inn 01.03.2027 kl. 23:59 i «Søknadsfrist». <br>6. Skriv inn 01.03.2027 kl. 23:59 i «Frist dokumentasjon». <br>7. Velg «Lagre». <br>8. Åpne opptaket igjen. | Lagret. Kortet «Realkompetanse» viser 01.03.2027 kl. 23:59 i «Søknadsfrist» og «Frist dokumentasjon». | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |

#### Regel: De ordinære fristene må være satt for å lagre opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4.21a | Opptaket kan ikke lagres uten datoen for når redigering av utdanningstilbud åpner | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». <br>2. I kortet «Redigering av studier», fjern datoen i «Redigering åpner». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Redigering åpner». | | |
| 4.21b | Opptaket kan ikke lagres uten datoen for når redigering av utdanningstilbud stenger | Fortsett på samme side som 4.21a. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Redigering av studier», fjern datoen i «Redigering stenger». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Redigering stenger». | | |
| 4.21c | Opptaket kan ikke lagres uten datoen for når søknaden åpner | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Søkeperiode», fjern datoen i «Åpner for søking». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Åpner for søking». | | |
| 4.21d | Opptaket kan ikke lagres uten den ordinære søknadsfristen | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Søkeperiode», fjern datoen i «Ordinær søknadsfrist». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Ordinær søknadsfrist». | | |
| 4.21e | Opptaket kan ikke lagres uten omprioriteringsfristen | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Endre søknad», fjern datoen i «Omprioriteringsfrist». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Omprioriteringsfrist». | | |
| 4.21f | Opptaket kan ikke lagres uten fristen for sletting av søknadsalternativer | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Endre søknad», fjern datoen i «Slette søknadsalternativer». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Slette søknadsalternativer». | | |
| 4.21g | Opptaket kan ikke lagres uten den ordinære dokumentasjonsfristen | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Dokumentasjon», fjern datoen i «Ordinær frist». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Ordinær frist (dokumentasjon)». | | |
| 4.21h | Opptaket kan ikke lagres uten ettersendingsfristen | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Dokumentasjon», fjern datoen i «Ettersendingsfrist». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Ettersendingsfrist». | | |
| 4.21i | Opptaket kan ikke lagres uten fristen for endring av utdanningsbakgrunn | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Saksbehandling», fjern datoen i «Endre utdanningsbakgrunn». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Endre utdanningsbakgrunn». | | |
| 4.21j | Opptaket kan ikke lagres uten datoen for når hovedopptaket publiseres | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Hovedopptak», fjern datoen i «Publiseringsdato». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Publiseringsdato». | | |
| 4.22a | Opptaket kan ikke lagres uten informasjonsfristen for ledige studieplasser når ledige studieplasser er aktivert | Bruk opptaket fra 4.9. Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Ledige studieplasser», fjern datoen i «Publiseres på nettsiden». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Publiseres på nettsiden (ledige studieplasser)». | | |
| 4.22b | Opptaket kan ikke lagres uten datoen for når ledige studieplasser kan søkes når ledige studieplasser er aktivert | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Ledige studieplasser», fjern datoen i «Åpner for søking». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Åpner for søking (ledige studieplasser)». | | |
| 4.22c | Opptaket kan ikke lagres uten datoen for når ledige studieplasser stenger for søkning når ledige studieplasser er aktivert | Fortsett på samme side. <br>1. Velg «Fyll inn testdatoer». <br>2. I kortet «Ledige studieplasser», fjern datoen i «Stenger for søking». <br>3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står «Stenger for søking (ledige studieplasser)». | | |
| | | *Gjør klar til neste test: velg «Avbryt».* | | | |
| 4.23 | Dato for aldersberegning og avvikende frister kan stå tomme | 1. Opprett et opptak som i 1.1, steg 1–8, med navnet «Samordna opptak 2027 frister (test)» på alle tre språk. Hopp over steg 9. <br>2. La «Dato for aldersberegning» stå tom. Ikke legg til noe under «Utdanningsbakgrunner med avvikende frister». <br>3. Velg «Lagre». <br>4. Gå til «Opptak», og søk på navnet. | Lagret. Opptaket står i lista over opptak. | | |

### Del 5: Listevisning og søk i opptak (listevisning_og_sok_i_opptak.feature)

#### Regel: Liste over alle opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 5.1 | Se liste over opptak | 1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). <br>2. Gå til https://test-fsadmin.sikt.no/opptak. <br>3. Finn «Samordna opptak 2027 (test)» i lista «Opptak». | Hver rad viser «Navn», «Type», «Organisasjon», «Opprettet» og «Utdanningstilbud». «Samordna opptak 2027 (test)» har HK-dir i «Organisasjon». | | |
| 5.2 | Liste er sortert etter når opptaket ble opprettet som standard | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Se på «Sortering» over lista. | Det står «Sortering: Opprettet». Det nyeste opptaket står øverst. | | |
| 5.3a | Velge sorteringsretning for opprettet (stigende) | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Velg pilknappen ved «Sortering: Opprettet» (Endre sorteringsretning). [Sjekk begrep] | Det eldste opptaket står øverst. | | |
| 5.3b | Velge sorteringsretning for opprettet (synkende) | Fortsett fra 5.3a. <br>1. Som testbruker 1, velg pilknappen ved «Sortering: Opprettet» igjen. | Det nyeste opptaket står øverst. | | |
| 5.3c | Velge sorteringsretning for type (stigende) | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Velg «Sortering: Opprettet». <br>3. Velg «Type». <br>4. Velg pilknappen ved «Sortering: Type». | Lista er sortert etter «Type», fra A til Å. | | |
| 5.3d | Velge sorteringsretning for type (synkende) | Fortsett fra 5.3c. <br>1. Som testbruker 1, velg pilknappen ved «Sortering: Type» igjen. | Lista er sortert etter «Type», fra Å til A. | | |
| 5.3e | Velge sorteringsretning for organisasjon (stigende) | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Velg «Sortering: Opprettet». <br>3. Velg «Organisasjon». <br>4. Velg pilknappen ved «Sortering: Organisasjon». | Lista er sortert etter organisasjon. Rekkefølgen følger organisasjonskoden, ikke nødvendigvis forkortelsen som vises. | | |
| 5.3f | Velge sorteringsretning for organisasjon (synkende) | Fortsett fra 5.3e. <br>1. Som testbruker 1, velg pilknappen ved «Sortering: Organisasjon» igjen. | Lista er sortert etter organisasjon, motsatt vei av 5.3e. Rekkefølgen følger organisasjonskoden, ikke nødvendigvis forkortelsen som vises. | | |
| 5.6 | Alle opptak er lastet inn | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Bla til bunnen av lista. | «Last inn flere» finnes ikke. Over lista står «<antall> rader i listen». | | |
| 5.7 | Navigere til detaljside for opptak | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Velg «Samordna opptak 2027 (test)» i lista. | Siden til «Samordna opptak 2027 (test)» åpnes. | | |

#### Regel: Søk og filtrering av opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 5.8 | Fritekst-søk på navn | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Skriv inn «Samordna opptak 2027» i «Opptaksnavn». | Lista viser «Samordna opptak 2027 (test)» og «Samordna opptak 2027 navn (test)». | | |
| | | *Gjør klar til neste test: velg «Tøm filter».* | | | |
| 5.9 | Tilgjengelige opptakstyper i filter | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Åpne «Type» i filteret. | Alle opptakstypene står i alfabetisk rekkefølge. Ingen er krysset av. | | |
| 5.10 | Filtrere på opptakstype | Fortsett fra 5.9. <br>1. Som testbruker 1, kryss av for [Fylles ut: opptakstype] under «Type». | Bare opptak med [Fylles ut: opptakstype] i «Type» vises. | | |
| | | *Gjør klar til neste test: velg «Tøm filter».* | | | |
| 5.11 | Kombinere filtre | 1. Som testbruker 1, gå til https://test-fsadmin.sikt.no/opptak. <br>2. Skriv inn «2027» i «Opptaksnavn». <br>3. Åpne «Type» i filteret. <br>4. Kryss av for [Fylles ut: opptakstype]. | Bare opptak med «2027» i navnet og [Fylles ut: opptakstype] i «Type» vises. | | |
| | | *Gjør klar til neste test: velg «Tøm filter».* | | | |

## Ikke testbart nå

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| 5.4 Liste viser de 50 første opptakene | TEST har færre enn 50 opptak | Når TEST har over 50 opptak |
| 5.5 Laste inn 50 flere opptak | TEST har færre enn 50 opptak, så «Last inn flere» vises ikke | Når TEST har over 50 opptak |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Gjenbruke innstillinger fra et tidligere opptak | Ikke avklart ennå |
| Deaktivere et opptak | Ikke avklart ennå |
| Krav om studierett for å søke | Ikke avklart ennå |
| Fristene må komme i riktig rekkefølge | Ikke avklart ennå |
| Første svarfrist som informasjon til søkere | Ikke avklart ennå |
| Hendelseslogg, fellestekster og svarmeldingsmal | Kommer senere |
| Lokale opptak | Tatt ut av denne testen |

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

Det du oppdager som ikke gjelder testcasene. Kontaktpersonen vurderer om det følges opp.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
