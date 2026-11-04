# Intern akseptansetest – Opprette og vedlikeholde opptak (Sonnet)

- **Kjøres av**: CDP-agent med Sonnet
- **Kopi av**: [testcaser-intern.md](testcaser-intern.md), med «Faktisk resultat» og «Status» tømt
- **Kjøring-ID**: Erstatt `{KJØRING}` med dato og klokkeslett når kjøringen starter (`MMDD-HHMM`, f.eks. `1026-0930`), og bruk samme verdi i alle testcasene. Da får hver kjøring sine egne opptak, og kan kjøres på nytt uten å treffe opptakene fra en tidligere kjøring.
- **Endret fra hovedfila**: unike opptaksnavn per modell og kjøring, eget navn i 1.5c og 1.5d, eget utdanningstilbud i 2.1, og opprydning etter 2.8. I 1.2–1.5 og 1.7–1.8 er alle de andre obligatoriske feltene fylt ut (riktige steg fra 1.1), så hver testcase tester ett felt, og «Kjent mangel (TAKE-431)» er fjernet (levert i fs-admin 0.61.0).

- **Nivå**: intern
- **Testplan**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165/Testplan+Opprette+og+vedlikeholde+opptak
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126422620
- **Hentet**: 2026-10-25 fra Confluence (sist endret 2026-10-22). Økt 1 (Del 1–2). Økt 2 (Del 3) og økt 3 (Del 4–5) er undersider, og er ikke med her.

---

Intern akseptansetest av «Opprette opptak 2027». Testbrukere og testdata står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165/Testplan+Opprette+og+vedlikeholde+opptak). Gule felt fylles ut av teamet før testen.

## Slik tester du

- Ta testcasene i rekkefølge. Følg stegene.
- Skriv hva du så i «Faktisk resultat». Sett «Status»: Bestått, Ikke bestått eller Ikke testet.
- «Kjent mangel» betyr at vi vet at det ikke virker ennå. Test likevel, og sett Ikke bestått hvis det ikke virker.
- Funn skrives i «Funn». Spørsmål tas i Slack-tråden.
- Opptakene du lager, kan ikke slettes. Bruk navnene i stegene.
- Kan du ikke velge «Lagre»? Se hva som står under «Fyll ut obligatoriske felt:». Fyll ut det, og skriv det i «Faktisk resultat».
- Testen tas i tre økter. Økt 1 (Del 1–2) står på denne siden. Økt 2 (Del 3) og økt 3 (Del 4–5) er undersider.

## Økt 1: Opprette og samordne

### Del 1: Opprette et opptak (opprett\_opptak.feature)

#### Regel: Opptaksforvalter kan opprette et opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 1.1 | Opprette et samordna opptak | 1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). 2. Gå til «Opptak» (<https://test-fsadmin.sikt.no/opptak>). 3. Under «SAMORDNA OPPTAK», velg «Opprett». Siden «Opprett samordna opptak» åpnes. 4. Skriv inn «Samordna opptak 2027 (test sonnet {KJØRING})» i «Navn på opptaket (bokmål)». 5. Skriv inn «Samordna opptak 2027 (test sonnet {KJØRING})» i «Navn på opptaket (nynorsk)». 6. Skriv inn «Coordinated admission 2027 (test sonnet {KJØRING})» i «Navn på opptaket (engelsk)». 7. Under «Samordning», velg «Inviter organisasjoner til samordningen». 8. Skriv inn «Universitetet i Oslo» i «Søk etter navn», og marker «Universitetet i Oslo». 9. Velg «Legg til 1 organisasjon». 10. Under «Innstillinger for opptaket», velg \[Fylles ut: opptakstype\] i «Opptakstype». 11. Velg «UHG 2027» i «Regelverksamling knyttet til opptaket». 12. Velg «Realkompetanse» i «Godkjente utdanningsbakgrunner». 13. Velg «Loddtrekning» i «Poenglikhetsregel». 14. Under «Generelle frister», velg «Fyll inn testdatoer». 15. Velg «Lagre». 16. Gå til «Opptak», og skriv inn «Samordna opptak 2027 (test sonnet {KJØRING})» i «Opptaksnavn». 17. Velg opptaket i lista. | Etter steg 15 vises «Lagring vellykket», og siden til opptaket åpnes. I lista over opptak står «Samordna opptak 2027 (test sonnet {KJØRING})», med HK-dir i «Organisasjon». På siden til opptaket kan testbruker 1 velge «Endre innstillinger for opptaket», og under «Samordnede organisasjoner» står Universitetet i Oslo. |  |  |

#### Regel: Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 1.2 | Lagre opptak uten navn | 1. Logg inn som testbruker 1. Gå til «Opptak», og velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 7–14. La navnene (steg 4–6) stå tomme. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står de tre navnefeltene, og ingen andre felt. |  |  |
| 1.3 | Lagre opptak uten regelverkssamling | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men hopp over steg 11. La «Regelverksamling knyttet til opptaket» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Regelverksamling tilknyttet opptaket» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
| 1.4 | Lagre opptak uten opptakstype | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men hopp over steg 10. La «Opptakstype» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Opptakstype» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
|  |  | *Gjør klar til neste test: velg «Avbryt».* |  |  |  |

#### Regel: Utdanningsbakgrunner, poenglikhetsregel, maks antall søknadsalternativer og tak for tilbud per tildelingsrunde må være satt for å lagre et opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 1.5a | Lagre opptak uten utdanningsbakgrunner | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men hopp over steg 12. La «Godkjente utdanningsbakgrunner» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Godkjente utdanningsbakgrunner» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
| 1.5b | Lagre opptak uten standard poenglikhetsregel | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men hopp over steg 13. La «Poenglikhetsregel» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Poenglikhetsregel» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
| 1.5c | Lagre opptak uten maks antall søknadsalternativer | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men skriv «Samordna opptak 2027 1.5c (test sonnet {KJØRING})» i alle tre navnefeltene. Fjern tallet i «Antall søknadsalternativer» (forhåndsutfylt med 10). 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Antall søknadsalternativer» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
| 1.5d | Lagre opptak uten tak for antall tilbud per tildelingsrunde | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men skriv «Samordna opptak 2027 1.5d (test sonnet {KJØRING})» i alle tre navnefeltene. Fjern tallet i «Tilbud per tildelingsrunde» (forhåndsutfylt med 1). 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Tilbud per tildelingsrunde» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
|  |  | *Gjør klar til neste test: velg «Avbryt». Er et opptak blitt lagret i 1.5c eller 1.5d, skriv det i «Faktisk resultat». Det har eget navn, og påvirker ikke resten av testen.* |  |  |  |

#### Regel: Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 1.6 | Angi opptaksnavn på flere språk | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». 2. «Navn på opptaket (samisk)»: «Samordna opptak 2027 (test sonnet {KJØRING})». 3. Velg «Lagre». 4. Åpne opptaket igjen, og velg «Endre innstillinger for opptaket». | Navnet står på alle fire språk. |  |  |
| 1.7 | Lagre opptak med navn på alle obligatoriske språk | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Navn på bokmål og nynorsk: «Samordna opptak 2027 navn (test sonnet {KJØRING})». Navn på engelsk: «Coordinated admission 2027 name (test sonnet {KJØRING})». La samisk stå tomt. 3. Fyll ut resten som i 1.1, steg 7–14. 4. Velg «Lagre». 5. Åpne opptaket igjen, og velg «Endre innstillinger for opptaket». | «Lagring vellykket». Navnene står på bokmål, nynorsk og engelsk. Samisk er tomt. |  |  |
| 1.8a | Navn mangler på et obligatorisk språk (bokmål) | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 5–14. La «Navn på opptaket (bokmål)» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (bokmål)» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
| 1.8b | Navn mangler på et obligatorisk språk (nynorsk) | 1. Fyll ut bokmål. Fjern nynorsk. 2. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (nynorsk)» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
| 1.8c | Navn mangler på et obligatorisk språk (engelsk) | 1. Fyll ut nynorsk. Fjern engelsk. 2. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (engelsk)» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. |  |  |
|  |  | *Gjør klar til neste test: velg «Avbryt».* |  |  |  |

### Del 2: Samordna opptak (samordna\_opptak.feature)

Bruk opptaket fra 1.1, «Samordna opptak 2027 (test sonnet {KJØRING})».

#### Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.1 | Legge til lærested i samordna opptak | 1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). 2. Gå til «Opptak». 3. Skriv inn «Samordna opptak 2027 (test sonnet {KJØRING})» i «Opptaksnavn», og velg opptaket. 4. Noter adressen (URL) til siden. Den brukes i 2.2 og 2.4. 5. Velg «Endre innstillinger for opptaket». 6. Under «Samordning», velg «Inviter organisasjoner til samordningen». 7. Skriv inn «Norges teknisk» i «Søk etter navn». 8. Marker «Norges teknisk-naturvitenskapelige universitet». 9. Velg «Legg til 1 organisasjon». 10. Velg «Lagre». 11. Logg ut, og logg inn/bytt til testbruker 2 (Ansvarsfull Fotkrem, opptaksforvalter ved NTNU). 12. Gå til «Opptak», og velg «Samordna opptak 2027 (test sonnet {KJØRING})». 13. Velg «Gå til utdanningstilbud». 14. Velg «Handlinger», og så «Legg til utdanningstilbud». 15. Skriv inn \[Fylles ut: navn på et utdanningstilbud ved NTNU i TEST, for Sonnet. Ikke det samme som i kjøringene med de andre modellene, eller i en tidligere kjøring med Sonnet\] i «Utdanningsnavn». 16. Marker utdanningstilbudet. 17. Velg «Legg til (1)». 18. Gå ut av siden, og velg «Gå til utdanningstilbud» igjen. | Utdanningstilbudet står i lista, med NTNU i «Organisasjon». |  |  |

#### Regel: Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.2 | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | 1. Logg ut, og logg inn/bytt til testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark). 2. Gå til adressen fra 2.1, steg 4, og legg til «/utdanningstilbud» bak. 3. Se etter «Handlinger». | «Legg til utdanningstilbud» finnes ikke. |  |  |

#### Regel: Organisasjoner som ikke deltar, kan ikke se opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.3 | Organisasjon som ikke deltar, ser ikke opptaket. Uavklart: avhenger av et feature-flagg | 1. Som testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark), gå til «Opptak». 2. Skriv inn «Samordna opptak 2027 (test sonnet {KJØRING})» i «Opptaksnavn». | Opptaket står ikke i lista. |  |  |
| 2.4 | Organisasjon som ikke deltar, kan ikke åpne opptaket. Kjent mangel (TAKE-434) | 1. Som testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark), gå til adressen fra 2.1, steg 4. | Opptaket vises ikke. \[Sjekk begrep: hva siden viser, f.eks. «Siden finnes ikke»\] |  |  |

#### Regel: En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.5 | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket. Kjent mangel (TAKE-433) | Bruk utdanningstilbudet fra 2.1. 1. Logg ut, og logg inn/bytt til testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). 2. Gå til «Opptak», og velg «Samordna opptak 2027 (test sonnet {KJØRING})». 3. Velg «Endre innstillinger for opptaket». 4. Under «Samordnede organisasjoner», velg krysset («Fjern NTNU») ved NTNU. 5. Velg «Lagre». | NTNU fjernes ikke. En melding sier at utdanningstilbudene til NTNU må fjernes først. \[Sjekk begrep: teksten i meldingen\] |  |  |
|  |  | *Gjør klar til neste test: er NTNU fjernet, legg NTNU til igjen som i 2.1, steg 5–10.* |  |  |  |
| 2.6 | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test sonnet {KJØRING})». 2. Velg «Endre innstillinger for opptaket». 3. Under «Samordnede organisasjoner», velg krysset («Fjern …») ved Universitetet i Oslo. 4. Velg «Lagre». 5. Gå til «Opptak», og åpne opptaket igjen. 6. Åpne «Samordnede organisasjoner». | Universitetet i Oslo står ikke under «Samordnede organisasjoner». |  |  |

#### Regel: Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.7 | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test sonnet {KJØRING})». 2. Velg «Endre innstillinger for opptaket». 3. Velg «Alder, eldre foran yngre» i «Poenglikhetsregel». 4. Noter datoen i «Ordinær søknadsfrist». Endre den til én dag senere, og noter den nye datoen. 5. Velg «Lagre». 6. Åpne opptaket igjen. | «Poenglikhetsregel» er «Alder, eldre foran yngre», og «Ordinær søknadsfrist» har den nye datoen. |  |  |
|  |  | *Gjør klar til neste test: velg «Avbryt».* |  |  |  |
| 2.8 | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger. Kjent mangel (TAKE-432) | 1. Logg ut, og logg inn/bytt til testbruker 2 (Ansvarsfull Fotkrem, opptaksforvalter ved NTNU). 2. Gå til «Opptak», og velg «Samordna opptak 2027 (test sonnet {KJØRING})». 3. Velg «Vis alle frister». 4. Se etter «Endre innstillinger for opptaket». | Alle innstillingene og fristene på opptaket vises, også «Alder, eldre foran yngre» og søknadsfristen fra 2.7. «Endre innstillinger for opptaket» finnes ikke, og «Administreres av HK-dir» står der. |  |  |
|  |  | *Rydd opp etter 2.7: logg ut, og logg inn/bytt til testbruker 1. Gå til «Opptak», velg opptaket, og velg «Endre innstillinger for opptaket». Velg «Loddtrekning» i «Poenglikhetsregel», og sett «Ordinær søknadsfrist» tilbake til datoen du noterte før endringen i 2.7. Velg «Lagre».* |  |  |  |

#### Regel: Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.9 | Legge til organisasjon som finnes i utdanningsregisteret | 1. Logg ut, og logg inn/bytt til testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). 2. Gå til «Opptak», og velg «Samordna opptak 2027 (test sonnet {KJØRING})». 3. Velg «Endre innstillinger for opptaket». 4. Velg «Inviter organisasjoner til samordningen». 5. Skriv inn «Universitetet i Oslo» i «Søk etter navn». 6. Marker «Universitetet i Oslo». 7. Velg «Legg til 1 organisasjon». 8. Velg «Lagre». 9. Gå til «Opptak», og åpne opptaket igjen. 10. Åpne «Samordnede organisasjoner». | Universitetet i Oslo står under «Samordnede organisasjoner». |  |  |
| 2.10 | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | 1. Som testbruker 1, velg «Endre innstillinger for opptaket» på «Samordna opptak 2027 (test sonnet {KJØRING})». 2. Velg «Inviter organisasjoner til samordningen». 3. Skriv inn \[Fylles ut: navn på en organisasjon som ikke finnes i utdanningsregisteret\] i «Søk etter navn». | «Ingen treff» vises. Organisasjonen kan ikke markeres. |  |  |
|  |  | *Gjør klar til neste test: velg «Lukk».* |  |  |  |

#### Regel: Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.11 | Filtrere på universiteter og høyskoler | 1. Som testbruker 1, velg «Endre innstillinger for opptaket» på «Samordna opptak 2027 (test sonnet {KJØRING})». 2. Velg «Inviter organisasjoner til samordningen». 3. Velg \[Sjekk begrep: «Universitet» og «Høgskole»\] i «Type lærested». | Bare norske universiteter og høyskoler står i lista. Ingen fagskoler. |  |  |
|  |  | *Gjør klar til neste test: fjern valgene i «Type lærested».* |  |  |  |
| 2.12 | Filtrere på fagskoler | Fortsett i dialogen fra 2.11. 1. Som testbruker 1, velg \[Sjekk begrep: «Fagskole»\] i «Type lærested». | Bare norske fagskoler står i lista. |  |  |
|  |  | *Gjør klar til neste test: velg «Lukk», og så «Avbryt».* |  |  |  |

#### Regel: Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.13 | Se og navigere til saksbehandlertildelingen for opptaket. Kjent mangel (TAKE-447) | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test sonnet {KJØRING})». 2. Se etter saksbehandlertildelingen på siden til opptaket. 3. Velg «Saksbehandlertildelingsregler». | Siden til opptaket viser saksbehandlertildelingen. Lenken åpner «Behandlertildelingsregler». |  |  |

## Ikke testbart nå

| Scenario | Hvorfor | Når det kan testes |
| --- | --- | --- |
| 5.4 Liste viser de 50 første opptakene | TEST har færre enn 50 opptak | Når TEST har over 50 opptak |
| 5.5 Laste inn 50 flere opptak | TEST har færre enn 50 opptak, så «Last inn flere» vises ikke | Når TEST har over 50 opptak |

## Ikke med i denne testen

| Hva | Hvorfor |
| --- | --- |
| Gjenbruke innstillinger fra et tidligere opptak | Ikke avklart ennå |
| Deaktivere et opptak | Ikke avklart ennå |
| Krav om studierett for å søke | Ikke avklart ennå |
| Fristene må komme i riktig rekkefølge | Ikke avklart ennå |
| Første svarfrist som informasjon til søkere | Ikke avklart ennå |
| Hendelseslogg, fellestekster og svarmeldingsmal | Kommer senere |
| Lokale opptak | Tatt ut av denne testen |

## Funn

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
| --- | --- | --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |  |  |

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

## Andre funn

Det du oppdager som ikke gjelder testcasene. Kontaktpersonen vurderer om det følges opp.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
| --- | --- | --- |
|  |  |  |
