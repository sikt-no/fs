# Ekstern akseptansetest – Opprette opptak 2027

- **Nivå**: ekstern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165
- **Scope**: @scope-opprette-opptak-2027
- **Krav**: 5 feature-filer (`@OPT-OVO-GRU-001`, `@OPT-OVO-SAM-001`, `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, `@OPT-OVO-OVE-001`), commit `a8d128e` (2026-10-21)
- **Bygger på**: [intern akseptansetest](testcaser-intern.md), [testrapport](testrapport-intern-2026-10-23.md). Utfallet er ikke skrevet i rapporten. Produkteier 23.10: Del 4 (frister) er testet og godkjent uten at resultatene er fylt ut, og Del 5 (oversikten) er godkjent
- **Testere**: HK-dir, som opptaksforvalter ved forvaltende organisasjon (testbruker 1)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137334279
- **Laget**: 2026-10-23 av fs-testcaser-ekstern
- **Sporing**:

  | Nr | Del | Feature-ID | Scenario | Intern |
  |---|---|---|---|---|
  | 1 | a | `@OPT-OVO-GRU-001` | Opprette et samordna opptak | 1.1 |
  | 1 | b | `@OPT-OVO-GRU-001` | Angi opptaksnavn på flere språk | 1.6 |
  | 2 | a | `@OPT-OVO-SAM-001` | Filtrere på universiteter og høyskoler · Filtrere på fagskoler | 2.11, 2.12 |
  | 2 | b | `@OPT-OVO-SAM-001` | Legge til organisasjon som finnes i utdanningsregisteret | 2.9 |
  | 2 | c | `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket | 2.6 |
  | 2 | d | `@OPT-OVO-SAM-001` | Se og navigere til saksbehandlertildelingen for opptaket | 2.13 |
  | 3 | a | `@OPT-OVO-INN-001` | Endre opptakstype når ingen utdanningstilbud er knyttet til opptaket · Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket | 3.1, 3.3 |
  | 3 | b | `@OPT-OVO-INN-001` | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud | 3.5 |
  | 3 | c | `@OPT-OVO-INN-001` | Sette startnummer for søknader i opptaket · Sette maks antall søknadsalternativer · Sette tak for antall tilbud per tildelingsrunde | 3.7, 3.9, 3.10 |
  | 3 | d | `@OPT-OVO-INN-001` | Aktivere tidlig opptak · Sette lenke til informasjon om tidlig opptak | 3.13, 3.14 |
  | 3 | e | `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | 3.16 |
  | 3 | f | `@OPT-OVO-INN-001` | Legge til flere utdanningsbakgrunner · Fjerne en utdanningsbakgrunn fra opptaket | 3.18, 3.19 |
  | 3 | g | `@OPT-OVO-INN-001` | Åpne for dokumentasjonsopplasting | 3.23 |
  | 4 | a | `@OPT-OVO-FRI-001` | Sette når redigering av utdanningstilbud åpner · Sette når redigering av utdanningstilbud stenger | 4.1, 4.2 |
  | 4 | b | `@OPT-OVO-FRI-001` | Sette søknadsdato · Sette ordinær søknadsfrist | 4.3, 4.4 |
  | 4 | c | `@OPT-OVO-FRI-001` | Sette omprioriteringsfrist · Sette frist for sletting av søknadsalternativer | 4.5, 4.6 |
  | 4 | d | `@OPT-OVO-FRI-001` | Sette ordinær dokumentasjonsfrist · Sette ettersendingsfrist | 4.7, 4.8 |
  | 4 | e | `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak · Sette dokumentasjonsfrist for tidlig opptak | 4.12, 4.13 |
  | 4 | f | `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser · Sette dato for når ledige studieplasser kan søkes · Sette dato for når ledige studieplasser stenger for søkning | 4.9, 4.10, 4.11 |
  | 4 | g | `@OPT-OVO-FRI-001` | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | 4.16 |
  | 4 | h | `@OPT-OVO-FRI-001` | Sette dato for aldersberegning · Sette frist for endring av utdanningsbakgrunn | 4.17, 4.19 |
  | 4 | i | `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | 4.20 |
  | 5 | a | `@OPT-OVO-OVE-001` | Se liste over opptak · Liste er sortert etter når opptaket ble opprettet som standard | 5.1, 5.2 |
  | 5 | b | `@OPT-OVO-OVE-001` | Fritekst-søk på navn | 5.8 |
  | 5 | c | `@OPT-OVO-OVE-001` | Filtrere på opptakstype | 5.10 |
  | 5 | d | `@OPT-OVO-OVE-001` | Velge sorteringsretning for type (stigende, synkende) | 5.3c, 5.3d |
  | 5 | e | `@OPT-OVO-OVE-001` | Navigere til detaljside for opptak | 5.7 |

  Noen deler dekker to eller tre scenarioer som hører sammen i arbeidet (for eksempel to frister i samme kort), så testen holder seg under én time.

---

Velkommen til akseptansetesten av «Opprette opptak 2027». I testen sjekker du om løsningen virker for det du skal bruke den til. Du trenger ikke kjenne bakgrunnen for leveransen.

## Før du starter

| Felt | Innhold |
|---|---|
| Hva er laget | Du kan opprette et samordna opptak i FS Admin, invitere læresteder til det, og sette innstillingene og fristene for opptaket. Du finner opptaket igjen i oversikten over opptak. |
| Hvor du tester | [https://test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak) |
| Hvem du er | Testbruker 1: Ordentlig rundskriv, opptaksforvalter ved HK-dir |
| Dette kan du ikke gjøre i testen | - Navnet på HK-dir vises ikke ennå i oversikten over opptak, og heller ikke etter «Administreres av». <br>- Opptakene du lager, kan ikke slettes. Bruk navnene i stegene. |
| Tid | Ca. 50 minutter. Frist: [Fylles ut: frist] |
| Spørsmål underveis | Karen Skadsheim Sikkeland, i [Fylles ut: Slack-kanal] |

## Slik fyller du ut

1. Ta testcasene i rekkefølge. Følg stegene.
2. Hver testcase er en oppgave. Hver del har sin egen rad med «Faktisk resultat» og «Status».
3. Skriv det du så i «Faktisk resultat». Sett «Status»: Bestått, Ikke bestått eller Ikke testet.
4. Sjekk at det du har lagret, står der når du åpner opptaket igjen.
5. Stemmer noe ikke, skriv det i «Funn»: hva du gjorde, hva du forventet og hva du fikk. Ta skjermbilde hvis du kan.

## Testcaser

### 1. Opprett et samordna opptak (ca. 8 minutter)

**Hensikt:** Opprette opptaket som de andre oppgavene bygger på, med det som må være på plass for å lagre det.

**Testdata:** testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). Bruker: regelverkssamlingen «UHG 2027». Lager: «Samordna opptak 2027 (ekstern test)».

| Del | Hva du gjør | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1a | Opprett opptaket | 1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). <br>2. Gå til «Opptak». Under «SAMORDNA OPPTAK», velg «Opprett». <br>3. Navn på bokmål og nynorsk: «Samordna opptak 2027 (ekstern test)». Navn på engelsk: «Coordinated admission 2027 (external test)». <br>4. «Opptakstype»: [Fylles ut: opptakstype]. <br>5. «Regelverksamling knyttet til opptaket»: «UHG 2027». <br>6. «Godkjente utdanningsbakgrunner»: «Realkompetanse». <br>7. «Poenglikhetsregel»: «Loddtrekning». <br>8. Velg «Fyll inn testdatoer». <br>9. Velg «Lagre». | «Lagring vellykket». Opptaket åpnes. | | |
| 1b | Legg til navnet på samisk | 10. Velg «Endre innstillinger for opptaket». <br>11. «Navn på opptaket (samisk)»: «Samordna opptak 2027 (ekstern test)». <br>12. Velg «Lagre». <br>13. Velg «Endre innstillinger for opptaket». | Navnet står på alle fire språk. | | |

### 2. Inviter læresteder til samordningen (ca. 8 minutter)

**Hensikt:** Bestemme hvilke læresteder som er med i det samordna opptaket.

**Testdata:** testbruker 1. Bruker: opptaket fra testcase 1.

| Del | Hva du gjør | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 2a | Finn læresteder etter type | 1. Åpne «Samordna opptak 2027 (ekstern test)», og velg «Endre innstillinger for opptaket». <br>2. Velg «Inviter organisasjoner til samordningen». <br>3. Velg [Sjekk begrep: «Universitet» og «Høgskole»] i «Type lærested». <br>4. Fjern valgene, og velg [Sjekk begrep: «Fagskole»]. <br>5. Fjern valgene. | I steg 3 står bare universiteter og høyskoler i lista. I steg 4 står bare fagskoler. | | |
| 2b | Legg til to læresteder | 6. Skriv inn «Universitetet i Oslo» i «Søk etter navn», og marker det. <br>7. Skriv inn «Norges teknisk» i «Søk etter navn», og marker «Norges teknisk-naturvitenskapelige universitet». <br>8. Velg «Legg til 2 organisasjoner». <br>9. Velg «Lagre». | «Lagring vellykket». Begge står under «Samordnede organisasjoner». | | |
| 2c | Fjern et lærested | 10. Velg «Endre innstillinger for opptaket». <br>11. Under «Samordnede organisasjoner», velg krysset ved Universitetet i Oslo. <br>12. Velg «Lagre». | Bare NTNU står under «Samordnede organisasjoner». | | |
| 2d | Se saksbehandlertildelingen | 13. På siden til opptaket, se etter saksbehandlertildelingen. <br>14. Velg «Saksbehandlertildelingsregler». | Siden viser saksbehandlertildelingen, og lenken åpner «Behandlertildelingsregler». | | |

### 3. Sett innstillingene for opptaket (ca. 12 minutter)

**Hensikt:** Sette opp hvordan opptaket skal fungere for søkerne og i saksbehandlingen.

**Testdata:** testbruker 1. Bruker: opptaket fra testcase 1, regelverkssamlingen «UHG 2027 v2».

| Del | Hva du gjør | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 3a | Endre opptakstype og regelverk | 1. Åpne «Samordna opptak 2027 (ekstern test)», og velg «Endre innstillinger for opptaket». <br>2. «Opptakstype»: [Fylles ut: en annen opptakstype]. <br>3. «Regelverksamling knyttet til opptaket»: «UHG 2027 v2». <br>4. Velg «Lagre». | Lagret. Den nye opptakstypen og «UHG 2027 v2» står på opptaket. | | |
| 3b | Tillat unntak fra poenglikhetsregelen | 5. Velg «Endre innstillinger for opptaket». <br>6. Kryss av for «Poenglikhetsregel skal kunne overstyres på utdanningstilbudet.». <br>7. «Tillatte poenglikhetsregler»: «Alle søkere med samme poengsum får tilbud» og «Alder, eldre foran yngre». <br>8. Velg «Lagre». | Lagret. De to reglene står i «Tillatte poenglikhetsregler». | | |
| 3c | Sett startnummer og tak | 9. Velg «Endre innstillinger for opptaket». <br>10. «Startnummer for søknader»: 1001. <br>11. «Antall søknadsalternativer»: 10. <br>12. «Tilbud per tildelingsrunde»: 1. <br>13. Velg «Lagre». | Lagret. 1001, 10 og 1 står i feltene. | | |
| 3d | Åpne for tidlig opptak | 14. Velg «Endre innstillinger for opptaket». <br>15. Kryss av for «Kan søke på tidlig opptak». <br>16. Lenke til informasjonssiden [Sjekk begrep: feltet]: «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html». <br>17. Velg «Fyll inn testdatoer». <br>18. Velg «Lagre». | Lagret. «Kan søke på tidlig opptak» er krysset av, og lenken står der. | | |
| 3e | Åpne for ledige studieplasser | 19. Velg «Endre innstillinger for opptaket». <br>20. Kryss av for «Ledige studieplasser». <br>21. Velg «Fyll inn testdatoer». <br>22. Velg «Lagre». | Lagret. «Ledige studieplasser» er krysset av, med datoer. | | |
| 3f | Endre utdanningsbakgrunnene | 23. Velg «Endre innstillinger for opptaket». <br>24. Velg «Utenlandsk utdanning» og «Steinerskole» i «Godkjente utdanningsbakgrunner». <br>25. Velg «Lagre». <br>26. Velg «Endre innstillinger for opptaket». Fjern «Steinerskole», og velg «Lagre». | Lagret. «Realkompetanse» og «Utenlandsk utdanning» står i «Godkjente utdanningsbakgrunner». | | |
| 3g | La søkerne laste opp dokumenter | 27. Velg «Endre innstillinger for opptaket». <br>28. Kryss av for «Søker kan laste opp dokumenter». <br>29. Velg «Lagre». | Lagret. «Søker kan laste opp dokumenter» er krysset av. | | |

### 4. Sett fristene for opptaket (ca. 12 minutter)

**Hensikt:** Sette fristene som styrer redigering av studier, søknaden, dokumentasjonen og svarene.

**Testdata:** testbruker 1. Bruker: opptaket fra testcase 1 og 3 (med tidlig opptak og ledige studieplasser).

Alle stegene gjøres under «Endre innstillinger for opptaket». Lagre etter hver del, og sjekk at datoene står der når du åpner opptaket igjen.

| Del | Hva du gjør | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 4a | Redigering av studier | 1. Åpne «Samordna opptak 2027 (ekstern test)», og velg «Endre innstillinger for opptaket». <br>2. I kortet «Redigering av studier»: «Redigering åpner» 01.10.2026 kl. 00:00, «Redigering stenger» 06.06.2027 kl. 23:59. <br>3. Velg «Lagre». | Lagret, med de to datoene. | | |
| 4b | Søkeperioden | 4. I kortet «Søkeperiode»: «Åpner for søking» 01.02.2027 kl. 00:00, «Ordinær søknadsfrist» 15.04.2027 kl. 23:59. <br>5. Velg «Lagre». | Lagret, med de to datoene. | | |
| 4c | Endringer i søknaden | 6. I kortet «Endre søknad»: «Omprioriteringsfrist» og «Slette søknadsalternativer» 15.04.2027 kl. 23:59. <br>7. Velg «Lagre». | Lagret, med de to datoene. | | |
| 4d | Dokumentasjon | 8. I kortet «Dokumentasjon»: «Ordinær frist» 15.04.2027 kl. 23:59, «Ettersendingsfrist» 01.07.2027 kl. 23:59. <br>9. Velg «Lagre». | Lagret, med de to datoene. | | |
| 4e | Tidlig opptak | 10. I kortet «Tidlig opptak»: «Søknadsfrist» og «Dokumentasjonsfrist» 01.03.2027 kl. 23:59. <br>11. Velg «Lagre». | Lagret, med de to datoene. | | |
| 4f | Ledige studieplasser | 12. I kortet «Ledige studieplasser»: «Publiseres på nettsiden» 20.07.2027, «Åpner for søking» 25.07.2027 og «Stenger for søking» 01.09.2027, alle kl. 00:00. <br>13. Velg «Lagre». | Lagret, med de tre datoene. | | |
| 4g | Når svarene publiseres | 14. I kortet «Hovedopptak»: «Publiseringsdato» 15.07.2027 kl. 00:00. <br>15. Velg «Lagre». | Lagret, med datoen. | | |
| 4h | Saksbehandling | 16. I kortet «Saksbehandling»: «Dato for aldersberegning» 31.12.2027, «Endre utdanningsbakgrunn» 01.05.2027 kl. 23:59. <br>17. Velg «Lagre». | Lagret, med de to datoene. | | |
| 4i | Egen frist for realkompetanse | 18. Under «Utdanningsbakgrunner med avvikende frister», velg «Legg til ny utdanningsbakgrunn». <br>19. Velg «Realkompetanse», og «Legg til». <br>20. I kortet «Realkompetanse»: «Søknadsfrist» og «Frist dokumentasjon» 01.03.2027 kl. 23:59. <br>21. Velg «Lagre». | Lagret. Kortet «Realkompetanse» viser de to datoene. | | |

### 5. Finn opptaket i oversikten (ca. 8 minutter)

**Hensikt:** Finne igjen opptaket blant alle opptakene.

**Testdata:** testbruker 1. Bruker: opptaket fra testcase 1, og opptakene som finnes i TEST.

| Del | Hva du gjør | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 5a | Se oversikten | 1. Gå til «Opptak». | Lista viser «Navn», «Type», «Organisasjon», «Opprettet» og «Utdanningstilbud». Det nyeste opptaket står øverst. | | |
| 5b | Søk på navnet | 2. Skriv inn «ekstern test» i «Opptaksnavn». | Bare «Samordna opptak 2027 (ekstern test)» står i lista. | | |
| 5c | Filtrer på opptakstype | 3. Velg «Tøm filter». <br>4. Åpne «Type», og kryss av for opptakstypen fra 3a. | Bare opptak med den opptakstypen står i lista, også ditt. | | |
| 5d | Sorter på opptakstype | 5. Velg «Tøm filter». <br>6. Velg «Sortering: Opprettet», og så «Type». <br>7. Velg pilknappen ved «Sortering: Type» [Sjekk begrep], og velg den en gang til. | Lista er sortert etter «Type», først fra A til Å, så fra Å til A. | | |
| 5e | Åpne opptaket fra oversikten | 8. Velg «Samordna opptak 2027 (ekstern test)» i lista. | Siden til opptaket åpnes. | | |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Feilmeldinger, sperrer og felt som må fylles ut | Testet i den interne akseptansetesten |
| Hva lærestedene ser og kan gjøre i opptaket | Krever andre testbrukere. Testet i den interne akseptansetesten |
| Å fjerne et lærested som har lagt til studier i opptaket | Krever et lærested med studier i opptaket. Testet i den interne akseptansetesten |
| Lokale opptak | Ikke med i denne leveransen |
| Gjenbruke innstillinger fra et tidligere opptak, og deaktivere et opptak | Kommer senere |
| Hendelseslogg, fellestekster og svarmeldingsmal | Kommer senere |
| Lister med flere enn 50 opptak | TEST har færre opptak |

## Funn

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

## Andre funn og erfaringer

Her skriver du det du oppdager som ikke står i testcasene, for eksempel om brukervennlighet, eller om du savner noe i arbeidsprosessen.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
