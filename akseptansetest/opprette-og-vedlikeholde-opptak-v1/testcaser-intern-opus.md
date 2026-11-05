# Intern akseptansetest – Opprette og vedlikeholde opptak (Opus)

- **Kjøres av**: CDP-agent med Opus
- **Kopi av**: [testcaser-intern.md](testcaser-intern.md), med «Faktisk resultat» og «Status» tømt
- **Kjøring-ID**: 1026-1026 (skjermbilder i `kjoring-2026-10-26-1026-opus/`)
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
| 1.1 | Opprette et samordna opptak | 1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). 2. Gå til «Opptak» (<https://test-fsadmin.sikt.no/opptak>). 3. Under «SAMORDNA OPPTAK», velg «Opprett». Siden «Opprett samordna opptak» åpnes. 4. Skriv inn «Samordna opptak 2027 (test opus 1026-1026)» i «Navn på opptaket (bokmål)». 5. Skriv inn «Samordna opptak 2027 (test opus 1026-1026)» i «Navn på opptaket (nynorsk)». 6. Skriv inn «Coordinated admission 2027 (test opus 1026-1026)» i «Navn på opptaket (engelsk)». 7. Under «Samordning», velg «Inviter organisasjoner til samordningen». 8. Skriv inn «Universitetet i Oslo» i «Søk etter navn», og marker «Universitetet i Oslo». 9. Velg «Legg til 1 organisasjon». 10. Under «Innstillinger for opptaket», velg \[Fylles ut: opptakstype\] i «Opptakstype». 11. Velg «UHG 2027» i «Regelverksamling knyttet til opptaket». 12. Velg «Realkompetanse» i «Godkjente utdanningsbakgrunner». 13. Velg «Loddtrekning» i «Poenglikhetsregel». 14. Under «Generelle frister», velg «Fyll inn testdatoer». 15. Velg «Lagre». 16. Gå til «Opptak», og skriv inn «Samordna opptak 2027 (test opus 1026-1026)» i «Opptaksnavn». 17. Velg opptaket i lista. | Etter steg 15 vises «Lagring vellykket», og siden til opptaket åpnes. I lista over opptak står «Samordna opptak 2027 (test opus 1026-1026)», med HK-dir i «Organisasjon». På siden til opptaket kan testbruker 1 velge «Endre innstillinger for opptaket», og under «Samordnede organisasjoner» står Universitetet i Oslo. | Testdata avviker: «UHG 2027» finnes ikke i «Regelverksamling knyttet til opptaket» (valgene er AKKSEPTANSETEST-KVOTER, HYUTEST2026, MARITSTEST, UHGTEST2026), så «UHGTEST2026 – Mini-UHG til simulering høsten 2026» ble valgt. «Loddtrekning» finnes ikke i «Poenglikhetsregel», så «Loddnummer, laveste nummer først» ble valgt. Opptakstype: «Samordna opptak til universiteter og høgskoler». «Lagring vellykket» vises, og siden til opptaket åpnes (https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjky). I lista står opptaket (UHG, Publisert), men «Organisasjon» er tom, ikke HK-dir. «Endre innstillinger for opptaket» finnes, og Universitetet i Oslo står under «Samordnede organisasjoner». Skjermbilder: 1.1-c til 1.1-g. | Ikke bestått |

#### Regel: Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 1.2 | Lagre opptak uten navn | 1. Logg inn som testbruker 1. Gå til «Opptak», og velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 7–14. La navnene (steg 4–6) stå tomme. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står de tre navnefeltene, og ingen andre felt. | Steg 7–14 utfylt (med testdataene fra 1.1), navnene tomme. «Lagre» kan ikke velges (deaktivert). Under «Fyll ut obligatoriske felt:» står bare «Navn på opptaket (bokmål)», «Navn på opptaket (nynorsk)» og «Navn på opptaket (engelsk)». | Bestått |
| 1.3 | Lagre opptak uten regelverkssamling | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men hopp over steg 11. La «Regelverksamling knyttet til opptaket» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Regelverksamling tilknyttet opptaket» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Regelverksamling tilknyttet opptaket». | Bestått |
| 1.4 | Lagre opptak uten opptakstype | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men hopp over steg 10. La «Opptakstype» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Opptakstype» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Opptakstype». | Bestått |
|  |  | *Gjør klar til neste test: velg «Avbryt».* |  |  |  |

#### Regel: Utdanningsbakgrunner, poenglikhetsregel, maks antall søknadsalternativer og tak for tilbud per tildelingsrunde må være satt for å lagre et opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 1.5a | Lagre opptak uten utdanningsbakgrunner | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men hopp over steg 12. La «Godkjente utdanningsbakgrunner» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Godkjente utdanningsbakgrunner» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Godkjente utdanningsbakgrunner». | Bestått |
| 1.5b | Lagre opptak uten standard poenglikhetsregel | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men hopp over steg 13. La «Poenglikhetsregel» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Poenglikhetsregel» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Poenglikhetsregel». | Bestått |
| 1.5c | Lagre opptak uten maks antall søknadsalternativer | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men skriv «Samordna opptak 2027 1.5c (test opus 1026-1026)» i alle tre navnefeltene. Fjern tallet i «Antall søknadsalternativer» (forhåndsutfylt med 10). 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Antall søknadsalternativer» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | Tallet 10 fjernet, feltet er tomt. «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Antall søknadsalternativer». Ingen opptak ble lagret. | Bestått |
| 1.5d | Lagre opptak uten tak for antall tilbud per tildelingsrunde | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 4–14, men skriv «Samordna opptak 2027 1.5d (test opus 1026-1026)» i alle tre navnefeltene. Fjern tallet i «Tilbud per tildelingsrunde» (forhåndsutfylt med 1). 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Tilbud per tildelingsrunde» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | Tallet 1 fjernet, feltet er tomt. «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Tilbud per tildelingsrunde». Ingen opptak ble lagret. | Bestått |
|  |  | *Gjør klar til neste test: velg «Avbryt». Er et opptak blitt lagret i 1.5c eller 1.5d, skriv det i «Faktisk resultat». Det har eget navn, og påvirker ikke resten av testen.* |  |  |  |

#### Regel: Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 1.6 | Angi opptaksnavn på flere språk | 1. Åpne opptaket fra 1.1, og velg «Endre innstillinger for opptaket». 2. «Navn på opptaket (samisk)»: «Samordna opptak 2027 (test opus 1026-1026)». 3. Velg «Lagre». 4. Åpne opptaket igjen, og velg «Endre innstillinger for opptaket». | Navnet står på alle fire språk. | «Lagring vellykket». Etter at opptaket er åpnet på nytt, står navnet på bokmål, nynorsk, engelsk og samisk («Samordna opptak 2027 (test opus 1026-1026)» på samisk). | Bestått |
| 1.7 | Lagre opptak med navn på alle obligatoriske språk | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Navn på bokmål og nynorsk: «Samordna opptak 2027 navn (test opus 1026-1026)». Navn på engelsk: «Coordinated admission 2027 name (test opus 1026-1026)». La samisk stå tomt. 3. Fyll ut resten som i 1.1, steg 7–14. 4. Velg «Lagre». 5. Åpne opptaket igjen, og velg «Endre innstillinger for opptaket». | «Lagring vellykket». Navnene står på bokmål, nynorsk og engelsk. Samisk er tomt. | «Lagring vellykket» (https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjkz). I «Endre innstillinger for opptaket» står «Samordna opptak 2027 navn (test opus 1026-1026)» på bokmål og nynorsk og «Coordinated admission 2027 name (test opus 1026-1026)» på engelsk. Samisk er tomt. | Bestått |
| 1.8a | Navn mangler på et obligatorisk språk (bokmål) | 1. Velg «Opprett» under «SAMORDNA OPPTAK». 2. Fyll ut som i 1.1, steg 5–14. La «Navn på opptaket (bokmål)» stå tom. 3. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (bokmål)» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | Steg 5–14 utfylt, bokmål tom. «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Navn på opptaket (bokmål)». | Bestått |
| 1.8b | Navn mangler på et obligatorisk språk (nynorsk) | 1. Fyll ut bokmål. Fjern nynorsk. 2. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (nynorsk)» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | Bokmål fylt ut, nynorsk fjernet. «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Navn på opptaket (nynorsk)». | Bestått |
| 1.8c | Navn mangler på et obligatorisk språk (engelsk) | 1. Fyll ut nynorsk. Fjern engelsk. 2. Prøv å velge «Lagre». | «Lagre» kan ikke velges. «Navn på opptaket (engelsk)» står under «Fyll ut obligatoriske felt:», og er det eneste feltet der. | Nynorsk fylt ut, engelsk fjernet. «Lagre» kan ikke velges. Under «Fyll ut obligatoriske felt:» står bare «Navn på opptaket (engelsk)». «Avbryt» tar brukeren tilbake til «Opptak». | Bestått |
|  |  | *Gjør klar til neste test: velg «Avbryt».* |  |  |  |

### Del 2: Samordna opptak (samordna\_opptak.feature)

Bruk opptaket fra 1.1, «Samordna opptak 2027 (test opus 1026-1026)».

#### Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.1 | Legge til lærested i samordna opptak | 1. Logg inn som testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). 2. Gå til «Opptak». 3. Skriv inn «Samordna opptak 2027 (test opus 1026-1026)» i «Opptaksnavn», og velg opptaket. 4. Noter adressen (URL) til siden. Den brukes i 2.2 og 2.4. 5. Velg «Endre innstillinger for opptaket». 6. Under «Samordning», velg «Inviter organisasjoner til samordningen». 7. Skriv inn «Norges teknisk» i «Søk etter navn». 8. Marker «Norges teknisk-naturvitenskapelige universitet». 9. Velg «Legg til 1 organisasjon». 10. Velg «Lagre». 11. Logg ut, og logg inn/bytt til testbruker 2 (Ansvarsfull Fotkrem, opptaksforvalter ved NTNU). 12. Gå til «Opptak», og velg «Samordna opptak 2027 (test opus 1026-1026)». 13. Velg «Gå til utdanningstilbud». 14. Velg «Handlinger», og så «Legg til utdanningstilbud». 15. Skriv inn \[Fylles ut: navn på et utdanningstilbud ved NTNU i TEST, for Opus. Ikke det samme som i kjøringene med de andre modellene, eller i en tidligere kjøring med Opus\] i «Utdanningsnavn». 16. Marker utdanningstilbudet. 17. Velg «Legg til (1)». 18. Gå ut av siden, og velg «Gå til utdanningstilbud» igjen. | Utdanningstilbudet står i lista, med NTNU i «Organisasjon». | Adressen fra steg 4: https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjky. NTNU lagt til, lagret, og står under «Samordnede organisasjoner». Første forsøk som testbruker 2: «Handlinger» fantes ikke, fordi «Fyll inn testdatoer» (1.1, steg 14) satte «Redigering stenger» til 26.10.2026, 00:00, altså før testen (siden viste «Redigering stengt: 26.10.2026, 00:00»). Avvik fra stegene: testbruker 1 endret «Redigering stenger» til 01.12.2026, 00:00. Da viste siden «Redigeringsfrist: 01.12.2026, 00:00 (om 36 dager)» og «Handlinger». Utdanningstilbud valgt for Opus: «Biomarin innovasjon - bachelor» (298BMI, 2014 Høst). «Utdanningstilbud lagt til» vises. Etter at siden er åpnet på nytt, står det i lista med NTNU i «Organisasjon» (status «Har mangler»). «Administreres av:» viser «-», ikke HK-dir. | Bestått |

#### Regel: Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.2 | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | 1. Logg ut, og logg inn/bytt til testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark). 2. Gå til adressen fra 2.1, steg 4, og legg til «/utdanningstilbud» bak. 3. Se etter «Handlinger». | «Legg til utdanningstilbud» finnes ikke. | Som testbruker 3, på https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjky/utdanningstilbud: «Handlinger» finnes ikke, så «Legg til utdanningstilbud» finnes heller ikke. Men siden åpnes, og testbruker 3 ser utdanningstilbudet til NTNU i lista (se 2.4). | Bestått |

#### Regel: Organisasjoner som ikke deltar, kan ikke se opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.3 | Organisasjon som ikke deltar, ser ikke opptaket. Uavklart: avhenger av et feature-flagg | 1. Som testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark), gå til «Opptak». 2. Skriv inn «Samordna opptak 2027 (test opus 1026-1026)» i «Opptaksnavn». | Opptaket står ikke i lista. | Med filteret «Samordna opptak 2027 (test opus 1026-1026)» viser lista «Listen er tom» og «Ingen opptak funnet». Feature-flagg ikke endret (alle av). | Bestått |
| 2.4 | Organisasjon som ikke deltar, kan ikke åpne opptaket. Kjent mangel (TAKE-434) | 1. Som testbruker 3 (Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark), gå til adressen fra 2.1, steg 4. | Opptaket vises ikke. \[Sjekk begrep: hva siden viser, f.eks. «Siden finnes ikke»\] | Kjent mangel TAKE-434. Testbruker 3 kan åpne https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjky: siden viser oppsummeringen, fristene, type, regelverksamling, «Samordnede organisasjoner» og «Gå til utdanningstilbud». «Endre innstillinger for opptaket» vises ikke. Også /utdanningstilbud kan åpnes, med utdanningstilbudet til NTNU. | Ikke bestått |

#### Regel: En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.5 | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket. Kjent mangel (TAKE-433) | Bruk utdanningstilbudet fra 2.1. 1. Logg ut, og logg inn/bytt til testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). 2. Gå til «Opptak», og velg «Samordna opptak 2027 (test opus 1026-1026)». 3. Velg «Endre innstillinger for opptaket». 4. Under «Samordnede organisasjoner», velg krysset («Fjern NTNU») ved NTNU. 5. Velg «Lagre». | NTNU fjernes ikke. En melding sier at utdanningstilbudene til NTNU må fjernes først. \[Sjekk begrep: teksten i meldingen\] | Krysset «Fjern NTNU» fjerner NTNU fra lista i skjemaet. Etter «Lagre» vises meldingen «Utdanningstilbudene til Norges teknisk-naturvitenskapelige universitet må fjernes først». Når opptaket åpnes på nytt, står NTNU fortsatt under «Samordnede organisasjoner». Kjent mangel TAKE-433 ser ut til å være rettet. | Bestått |
|  |  | *Gjør klar til neste test: er NTNU fjernet, legg NTNU til igjen som i 2.1, steg 5–10.* |  |  |  |
| 2.6 | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test opus 1026-1026)». 2. Velg «Endre innstillinger for opptaket». 3. Under «Samordnede organisasjoner», velg krysset («Fjern …») ved Universitetet i Oslo. 4. Velg «Lagre». 5. Gå til «Opptak», og åpne opptaket igjen. 6. Åpne «Samordnede organisasjoner». | Universitetet i Oslo står ikke under «Samordnede organisasjoner». | Krysset «Fjern UIO» og «Lagre». Når opptaket åpnes på nytt, står bare NTNU under «Samordnede organisasjoner». Universitetet i Oslo står ikke der. | Bestått |

#### Regel: Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.7 | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test opus 1026-1026)». 2. Velg «Endre innstillinger for opptaket». 3. Velg «Alder, eldre foran yngre» i «Poenglikhetsregel». 4. Noter datoen i «Ordinær søknadsfrist». Endre den til én dag senere, og noter den nye datoen. 5. Velg «Lagre». 6. Åpne opptaket igjen. | «Poenglikhetsregel» er «Alder, eldre foran yngre», og «Ordinær søknadsfrist» har den nye datoen. | «Alder, eldre foran yngre» finnes ikke i «Poenglikhetsregel». Nærmeste valg, «Alder, eldste først», ble brukt. «Ordinær søknadsfrist» var 09.11.2026, 00:00 og ble endret til 10.11.2026, 00:00. Lagret. Etter at opptaket er åpnet på nytt, er «Poenglikhetsregel» «Alder, eldste først», og «Ordinær søknadsfrist» 10.11.2026, 00:00. | Bestått |
|  |  | *Gjør klar til neste test: velg «Avbryt».* |  |  |  |
| 2.8 | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger. Kjent mangel (TAKE-432) | 1. Logg ut, og logg inn/bytt til testbruker 2 (Ansvarsfull Fotkrem, opptaksforvalter ved NTNU). 2. Gå til «Opptak», og velg «Samordna opptak 2027 (test opus 1026-1026)». 3. Velg «Vis alle frister». 4. Se etter «Endre innstillinger for opptaket». | Alle innstillingene og fristene på opptaket vises, også «Alder, eldre foran yngre» og søknadsfristen fra 2.7. «Endre innstillinger for opptaket» finnes ikke, og «Administreres av HK-dir» står der. | Kjent mangel TAKE-432. «Endre innstillinger for opptaket» finnes ikke. «Vis alle frister» viser alle fristene, også den nye søknadsfristen fra 2.7 (10.11.2026, 00:00, med etiketten «Ordinær»). Men poenglikhetsregelen («Alder, eldste først») vises ikke noe sted på siden, og heller ikke antall søknadsalternativer og tilbud per tildelingsrunde: oppsummeringen har bare type, regelverksamling og tre valg. «Administreres av» står, men uten HK-dir (tomt). | Ikke bestått |
|  |  | *Rydd opp etter 2.7: logg ut, og logg inn/bytt til testbruker 1. Gå til «Opptak», velg opptaket, og velg «Endre innstillinger for opptaket». Velg «Loddtrekning» i «Poenglikhetsregel», og sett «Ordinær søknadsfrist» tilbake til datoen du noterte før endringen i 2.7. Velg «Lagre».* |  |  |  |

#### Regel: Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.9 | Legge til organisasjon som finnes i utdanningsregisteret | 1. Logg ut, og logg inn/bytt til testbruker 1 (Ordentlig rundskriv, opptaksforvalter ved HK-dir). 2. Gå til «Opptak», og velg «Samordna opptak 2027 (test opus 1026-1026)». 3. Velg «Endre innstillinger for opptaket». 4. Velg «Inviter organisasjoner til samordningen». 5. Skriv inn «Universitetet i Oslo» i «Søk etter navn». 6. Marker «Universitetet i Oslo». 7. Velg «Legg til 1 organisasjon». 8. Velg «Lagre». 9. Gå til «Opptak», og åpne opptaket igjen. 10. Åpne «Samordnede organisasjoner». | Universitetet i Oslo står under «Samordnede organisasjoner». | Universitetet i Oslo markert, «Legg til 1 organisasjon», lagret. Når opptaket åpnes på nytt, står Universitetet i Oslo (og NTNU) under «Samordnede organisasjoner». | Bestått |
| 2.10 | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | 1. Som testbruker 1, velg «Endre innstillinger for opptaket» på «Samordna opptak 2027 (test opus 1026-1026)». 2. Velg «Inviter organisasjoner til samordningen». 3. Skriv inn \[Fylles ut: navn på en organisasjon som ikke finnes i utdanningsregisteret\] i «Søk etter navn». | «Ingen treff» vises. Organisasjonen kan ikke markeres. | Organisasjonsnavnet «Høgskolen i Atlantis» ble brukt (feltet var ikke fylt ut). Dialogen viser «Viser 0 av 126 organisasjoner» og «Ingen treff». Ingen rader kan markeres, og knappen er «Legg til 0 organisasjoner». | Bestått |
|  |  | *Gjør klar til neste test: velg «Lukk».* |  |  |  |

#### Regel: Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.11 | Filtrere på universiteter og høyskoler | 1. Som testbruker 1, velg «Endre innstillinger for opptaket» på «Samordna opptak 2027 (test opus 1026-1026)». 2. Velg «Inviter organisasjoner til samordningen». 3. Velg \[Sjekk begrep: «Universitet» og «Høgskole»\] i «Type lærested». | Bare norske universiteter og høyskoler står i lista. Ingen fagskoler. | Valgene i «Type lærested» er «Fagskole», «Høyskole», «Universitet» og «Vitenskapelig høgskole». Med «Universitet» og «Høyskole» valgt: «Viser 79 av 81 organisasjoner», 15 universiteter og 64 høyskoler, ingen fagskoler. Vitenskapelige høgskoler (f.eks. NHH, NIH, VID, MF) er en egen type, og kommer ikke med (se Andre funn). | Bestått |
|  |  | *Gjør klar til neste test: fjern valgene i «Type lærested».* |  |  |  |
| 2.12 | Filtrere på fagskoler | Fortsett i dialogen fra 2.11. 1. Som testbruker 1, velg \[Sjekk begrep: «Fagskole»\] i «Type lærested». | Bare norske fagskoler står i lista. | Med bare «Fagskole» valgt: «Viser 37 av 37 organisasjoner», alle med typen Fagskole. | Bestått |
|  |  | *Gjør klar til neste test: velg «Lukk», og så «Avbryt».* |  |  |  |

#### Regel: Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- | --- |
| 2.13 | Se og navigere til saksbehandlertildelingen for opptaket. Kjent mangel (TAKE-447) | 1. Som testbruker 1, gå til «Opptak», og velg «Samordna opptak 2027 (test opus 1026-1026)». 2. Se etter saksbehandlertildelingen på siden til opptaket. 3. Velg «Saksbehandlertildelingsregler». | Siden til opptaket viser saksbehandlertildelingen. Lenken åpner «Behandlertildelingsregler». | Kjent mangel TAKE-447. Siden til opptaket viser ikke saksbehandlertildelingen, og «Saksbehandlertildelingsregler» finnes ikke. Under «Oppgaver» står bare «Gå til utdanningstilbud», «Gå til søknader» og «Gå til plasstildeling». Feature-flagg ikke endret (alle av). | Ikke bestått |

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
| 1 | 1.1 | «Organisasjon» er tom for opptaket i lista over opptak. På siden til opptaket og på utdanningstilbudssiden er «Administreres av» tom («-»). | HK-dir i «Organisasjon» og i «Administreres av». | 1.1, steg 1–17 som testbruker 1. Se lista, og «Administreres av» på opptaket. | kjoring-2026-10-26-1026-opus/1.1-e-liste.png, kjoring-2026-10-26-1026-opus/2.8-a-frister.png | Må fikses før innføring (forslag) |  |
| 2 | 2.4 | Testbruker 3 (Fagskolen Vestfold og Telemark), som ikke deltar, kan åpne siden til opptaket og /utdanningstilbud, og ser innstillingene, fristene og utdanningstilbudet til NTNU. | Opptaket vises ikke. | Som testbruker 3, gå til https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjky. | kjoring-2026-10-26-1026-opus/2.4-tvt-opptaksside.png, kjoring-2026-10-26-1026-opus/2.2-tvt-utdanningstilbud.png | Må fikses før innføring (forslag) | TAKE-434 |
| 3 | 2.8 | Testbruker 2 (NTNU) ser ikke poenglikhetsregelen («Alder, eldste først»), antall søknadsalternativer eller tilbud per tildelingsrunde. Oppsummeringen har bare type, regelverksamling og tre valg. «Administreres av» er tom. | Alle innstillingene og fristene vises, og «Administreres av HK-dir». | 2.7, så 2.8 som testbruker 2. | kjoring-2026-10-26-1026-opus/2.8-a-frister.png | Må fikses før innføring (forslag) | TAKE-432 |
| 4 | 2.13 | Siden til opptaket viser ikke saksbehandlertildelingen, og «Saksbehandlertildelingsregler» finnes ikke. | Saksbehandlertildelingen vises, og lenken åpner «Behandlertildelingsregler». | Som testbruker 1, åpne opptaket. | kjoring-2026-10-26-1026-opus/2.13-a-opptaksside.png | Må fikses før innføring (forslag) | TAKE-447 |

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

## Andre funn

Det du oppdager som ikke gjelder testcasene. Kontaktpersonen vurderer om det følges opp.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
| --- | --- | --- |
| 1.1, steg 10–13, og 2.7 | «Opprett samordna opptak» | Testdataene i stegene finnes ikke i TEST: «UHG 2027» (regelverksamlingene er AKKSEPTANSETEST-KVOTER, HYUTEST2026, MARITSTEST og UHGTEST2026), «Loddtrekning» (nærmeste er «Loddnummer, laveste nummer først») og «Alder, eldre foran yngre» (nærmeste er «Alder, eldste først»). Opptakstypen er ikke fylt ut. Brukt: «Samordna opptak til universiteter og høgskoler». |
| 1.1, steg 14, og 2.1 | «Generelle frister», «Fyll inn testdatoer» | «Fyll inn testdatoer» setter «Redigering åpner» og «Redigering stenger» til samme tidspunkt, i dag kl. 00:00. Redigeringen er da stengt før testen, så deltakende organisasjoner får ikke «Handlinger» og kan ikke legge til utdanningstilbud i 2.1. Løst ved å sette «Redigering stenger» til 01.12.2026. Testcasen eller testdatoene bør endres. |
| 1.1 og 2.1 | «Samordnede organisasjoner», i skjemaet og på siden til opptaket | Teksten mangler et ord: «Én organisasjon er med i samordningen i tillegg til som administrerer opptaket». «Administrator:» over knappen «Inviter organisasjoner til samordningen» er også tom. |
| 1.1 og 1.6 | Siden til opptaket, «Oppsummert» | «Kan søke på tidlig opptak» og «Krav til studierett for å søke» vises med samme hake som «Søker kan laste opp dokumenter», men bare «Søker kan laste opp dokumenter» er krysset av i «Endre innstillinger for opptaket». Det er uklart om oppsummeringen viser hva som er aktivert. |
| 2.8 | «Vis alle frister» | Flere frister har korte eller uklare navn i tidslinja: «Åpner», «Ordinær» (ordinær søknadsfrist), «Studier» (redigering stenger) og «Opptaksresultater». |
| 2.11 | «Type lærested» i «Velg deltaker-organisasjoner for samordning» | Det finnes en egen type «Vitenskapelig høgskole» (f.eks. NHH, NIH, VID, MF). Med «Universitet» og «Høyskole» kommer de ikke med. Testcasen bør si om de skal være med. «Universitetet i Trondheim» står tre ganger i lista. |
