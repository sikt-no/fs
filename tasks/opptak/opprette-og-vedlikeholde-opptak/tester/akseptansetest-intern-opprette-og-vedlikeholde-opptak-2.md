# Intern akseptansetest 2 – Opprette og vedlikeholde opptak

- **Nivå**: intern (trinn 2), runde 2
- **Oppgave**: [tasks/opptak/opprette-og-vedlikeholde-opptak](../oppgave.md)
- **Krav**: `@OPT-OVO-GRU-001`, `@OPT-OVO-SAM-001`, `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, slik de står i sikt-no/fs#754, commit `0ee0b59` (19.10.2026, ikke merget). Sporingen fra testtilfelle til krav står på kvalitetssikringssiden
- **Bygger på**: intern akseptansetest 1 (Confluence 5109022726), resultater 19.10.2026
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5120589830
- **Laget**: 2026-10-19 av fs-akseptansetest, revidert 2026-10-19 etter innspill fra kontaktpersonen

---

Runde 2 av den interne akseptansetesten av «Opprette og vedlikeholde opptak». Den tester det som ikke ble bestått eller ikke ble testet i runde 1, og det som er nytt etter runde 1. Felt med gul bakgrunn fylles ut av teamet før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er laget | En side i FS Admin der opptaksforvalteren oppretter et samordna eller lokalt opptak. Siden har seksjonene «Navn», «Samordning» (invitere læresteder), «Innstillinger for opptaket», «Generelle frister» og «Utdanningsbakgrunner med avvikende frister» |
| Brukerhistorie | Som opptaksforvalter ønsker jeg å opprette et opptak for organisasjonen jeg forvalter, invitere læresteder, og sette innstillinger og frister, slik at utdanningstilbud kan knyttes til opptaket og søkere kan søke |
| Hvor du tester | [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak) |
| Kvalitetssikring i teamet | [Kvalitetssikring i teamet – Opprette og vedlikeholde opptak](kvalitetssikring-opprette-og-vedlikeholde-opptak.md) |
| Dette kan du ikke gjøre i testen | - Se hva søkerne ser av innstillingene og fristene. Det testes ikke her. <br>- Fylle ut «Svarfrist» under «Hovedopptak». Den er ikke avklart, og skal stå tom. <br>- [Fylles ut av teamet: det som ikke er i testmiljøet ennå. Testtilfellene det gjelder, flyttes til «Ikke testbart nå».] |
| Kontaktperson i teamet | Karen Skadsheim Sikkeland (deltar fra teamet: Maciek Adamczyk og Jøran Wigen Aasterud) |
| Testansvarlig | Marit Bjørnerud Rønning |
| Andre testere | [Fylles ut, og hvem som tar hvilke deler] |
| Tid | [Fylles ut: dato og klokkeslett]. Beregnet tid: ca. 100 minutter |
| Spørsmål underveis | Slack-tråden «Akseptansetesting opprette og vedlikeholde opptak 2» i [#fs-fremtidens-opptak](https://sikt-no.slack.com/archives/C0BVBHA9E2H) |

## Slik tester du

- Ta delene og testtilfellene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Kolonnen «Testbruker» sier hvem du skal være. Kolonnen «Testdata» sier hva du bruker, og hva du lager som senere testtilfeller trenger.
- Fyll ut «Faktisk resultat» med det du så, og «Bestått?» med Ja, Nei eller Delvis.
- Sjekk at det du har lagret, står der når du åpner opptaket igjen.
- Funn skrives i «Funn»: hva du gjorde, hva du forventet, hva du fikk.
- Mer i [Informasjonsskriv om akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5108334635/Informasjonsskriv+om+akseptansetesting).

## Testgjennomføring

### Del 1: Opprette et samordna opptak (ca. 20 minutter)

| # | Testbruker | Scenario | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 1.1 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Feltene er forhåndsutfylt når du oppretter et opptak | Ingen | 1. Logg inn i FS Admin som Ordentlig Rundskriv [Sjekk begrep: hvordan testeren logger inn og velger rolle]. <br>2. Gå til [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak). <br>3. Velg «Opprett opptak» [Sjekk begrep]. <br>4. Se på feltet for hvor mange utdanningstilbud en søker kan få opptak til («Tilbud per tildelingsrunde» [Sjekk begrep]) under «Innstillinger for opptaket». <br>5. Se på «Søker kan laste opp dokumenter» under «Valg for opptaket». | Feltet i steg 4 står på 1. «Søker kan laste opp dokumenter» er krysset av | | |
| 1.2 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Opprette et samordna opptak uten frister | **Bruker:** regelverkssamlingen «UHG 2027» [Fylles ut: navnet i testmiljøet], opptakstypen «UHG» og organisasjonen «NTNU». <br>**Lager:** opptaket «Samordna opptak 2027 – test 2», som brukes i resten av testen | Fortsett i skjemaet fra 1.1. <br>1. Velg at opptaket skal være samordnet [Sjekk begrep]. <br>2. Under «Navn»: skriv «Samordna opptak 2027 – test 2» i «Opptaksnavn (Bokmål)» og «Opptaksnavn (Nynorsk)», og «Coordinated admission 2027 – test 2» i «Opptaksnavn (Engelsk)». La «Opptaksnavn (Samisk)» stå tomt. <br>3. Under «Samordning»: velg «Inviter organisasjoner til samordningen», og legg til «NTNU». <br>4. Under «Innstillinger for opptaket»: velg «UHG» i «Velg opptakstype» og «UHG 2027» i «Velg regelverksamling knyttet til opptaket». <br>5. I «Godkjente utdanningsbakgrunner»: velg «Norsk videregående skole (inkluderer 23/5-regelen, forkurs og fagskole)», «Utenlandsk videregående skole» og «Realkompetanse». <br>6. La «Startnummer for søknader» stå tomt. Skriv 10 i «Antall søknadsalternativer». La taket stå på 1. <br>7. Velg «Loddtrekning» i «Poenglikhetsregel». <br>8. Ikke kryss av for «Ledige studieplasser» eller «Kan søke på tidlig opptak». <br>9. Ikke fyll ut noe under «Generelle frister». <br>10. Lagre. <br>11. Kopier adressen (URL) til opptaket fra adressefeltet i nettleseren, og ta vare på den. Du trenger den i 5.2. <br>12. Gå til opptakslista, og åpne «Samordna opptak 2027 – test 2» igjen. | Opptaket er lagret uten frister, og står i opptakslista. HK-dir står som forvalter av opptaket, og NTNU står under «Samordnede organisasjoner». Navnene og innstillingene fra steg 2–7 står slik du la dem inn | | |
| 1.3a | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Opptaket kan ikke lagres uten utdanningsbakgrunner | **Bruker:** de samme verdiene som i 1.2. <br>**Lager:** ingenting. Opptaket «Feiltest 2027» skal ikke bli lagret | 1. Gå til [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak), og velg «Opprett opptak». <br>2. Fyll ut som i steg 1–7 i 1.2, men skriv «Feiltest 2027» som navn på alle tre språk, og ikke velg noen utdanningsbakgrunn. <br>3. Lagre. | Opptaket lagres ikke, og du ser at utdanningsbakgrunner må velges | | |
| 1.3b | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Opptaket kan ikke lagres uten poenglikhetsregel | Skjemaet fra 1.3a | 1. Velg utdanningsbakgrunnene som i 1.2. <br>2. Fjern valget i «Poenglikhetsregel». <br>3. Lagre. | Opptaket lagres ikke, og du ser at poenglikhetsregel må velges | | |
| 1.3c | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Opptaket kan ikke lagres uten antall søknadsalternativer | Skjemaet fra 1.3b | 1. Velg «Loddtrekning» i «Poenglikhetsregel» igjen. <br>2. Tøm «Antall søknadsalternativer». <br>3. Lagre. | Opptaket lagres ikke, og du ser at antall søknadsalternativer må fylles ut | | |
| 1.3d | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Opptaket kan ikke lagres uten tak for utdanningstilbud | Skjemaet fra 1.3c | 1. Skriv 10 i «Antall søknadsalternativer» igjen. <br>2. Tøm feltet for taket («Tilbud per tildelingsrunde» [Sjekk begrep]). <br>3. Lagre. <br>4. Avbryt opprettingen, og gå til opptakslista. | Opptaket lagres ikke, og du ser at taket må fylles ut. «Feiltest 2027» står ikke i opptakslista | | |

### Del 2: Invitere og fjerne læresteder (ca. 5 minutter)

| # | Testbruker | Scenario | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 2.1 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Fjerne et lærested som ikke har utdanningstilbud i opptaket | **Bruker:** opptaket «Samordna opptak 2027 – test 2» fra 1.2. <br>**Lager:** «Høgskolen i Molde» som deltaker, som fjernes igjen | 1. Åpne «Samordna opptak 2027 – test 2». <br>2. Under «Samordning»: velg «Inviter organisasjoner til samordningen», legg til «Høgskolen i Molde», og lagre. <br>3. Åpne opptaket igjen, og sjekk at «Høgskolen i Molde» står under «Samordnede organisasjoner». <br>4. Fjern «Høgskolen i Molde» med krysset på kortet, og lagre. <br>5. Åpne opptaket igjen. | «Høgskolen i Molde» står ikke lenger under «Samordnede organisasjoner». NTNU står der fortsatt | | |

### Del 3: Innstillinger og frister (ca. 40 minutter)

Alle testtilfellene i delen gjøres på «Samordna opptak 2027 – test 2» fra 1.2, før noe lærested har knyttet utdanningstilbud til opptaket. Hvert testtilfelle slutter med at du lagrer, går til opptakslista og åpner opptaket igjen.

| # | Testbruker | Scenario | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 3.1 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Endre opptakstype | **Bruker:** opptaket fra 1.2 og opptakstypen «HYU» [Sjekk begrep] | 1. Åpne opptaket. <br>2. Velg «HYU» i «Velg opptakstype». <br>3. Lagre, og åpne opptaket igjen. | Opptakstypen er «HYU». Ingenting annet på opptaket er endret | | |
| 3.2 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Endre regelverkssamling når opptaket ikke har utdanningstilbud | **Bruker:** opptaket fra 1.2 og regelverkssamlingen «UHG 2027 v2» [Fylles ut: navnet i testmiljøet] | 1. Velg «UHG 2027 v2» i «Velg regelverksamling knyttet til opptaket». <br>2. Lagre, og åpne opptaket igjen. <br>3. Velg «UHG 2027» igjen, og lagre. | Etter steg 2 er regelverkssamlingen «UHG 2027 v2», og det kom ikke noe varsel. Etter steg 3 er den «UHG 2027» igjen | | |
| 3.3 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Åpne for søknad på ledige studieplasser | **Bruker:** opptaket fra 1.2 | 1. Kryss av for «Ledige studieplasser» under «Valg for opptaket». Ikke kryss av for «Kan søke på tidlig opptak». <br>2. Under «Generelle frister», kortet «Ledige studieplasser»: skriv 20.07.2027 i «Publiseres på nettsiden», 25.07.2027 i «Åpner for søking» og 01.09.2027 i «Stenger for søking». <br>3. Lagre, og åpne opptaket igjen. | Opptaket er lagret, selv om fristene for tidlig opptak ikke er fylt ut. «Ledige studieplasser» er krysset av, og de tre datoene står slik du la dem inn | | |
| 3.4 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Tidlig opptak krever lenke til informasjon | **Bruker:** opptaket fra 1.2 | 1. Kryss av for «Kan søke på tidlig opptak». <br>2. Under kortet «Tidlig opptak»: skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» og i «Dokumentasjonsfrist». <br>3. La feltet for lenken til informasjon om tidlig opptak [Sjekk begrep] stå tomt. <br>4. Lagre. | Opptaket lagres ikke, og du ser at lenken til informasjon om tidlig opptak må fylles ut | | |
| 3.5a | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Tidlig opptak krever søknadsfrist | **Bruker:** opptaket fra 1.2 og lenken <https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html> | 1. Skriv lenken i feltet for lenken til informasjon om tidlig opptak. <br>2. Tøm «Søknadsfrist» under kortet «Tidlig opptak». <br>3. Lagre. | Opptaket lagres ikke, og du ser at søknadsfristen for tidlig opptak må fylles ut | | |
| 3.5b | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Tidlig opptak krever dokumentasjonsfrist | **Bruker:** opptaket fra 1.2 | 1. Skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» igjen. <br>2. Tøm «Dokumentasjonsfrist» under kortet «Tidlig opptak». <br>3. Lagre. | Opptaket lagres ikke, og du ser at dokumentasjonsfristen for tidlig opptak må fylles ut | | |
| 3.6 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Åpne for tidlig opptak med lenke og frister | **Bruker:** opptaket fra 1.2 | 1. Skriv 01.03.2027 kl. 23:59 i «Dokumentasjonsfrist» igjen. <br>2. Skriv 15.02.2027 kl. 23:59 i «Frist for å sette poenggrenser». <br>3. Lagre, og åpne opptaket igjen. | «Kan søke på tidlig opptak» er krysset av. Lenken, søknadsfristen, dokumentasjonsfristen og fristen for poenggrenser står slik du la dem inn | | |
| 3.7 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Stenge og åpne for at søkere kan laste opp dokumentasjon | **Bruker:** opptaket fra 1.2 | 1. Fjern krysset for «Søker kan laste opp dokumenter». <br>2. Lagre, åpne opptaket igjen, og se på «Søker kan laste opp dokumenter». <br>3. Kryss av for «Søker kan laste opp dokumenter» igjen. <br>4. Lagre, og åpne opptaket igjen. | Etter steg 2 er «Søker kan laste opp dokumenter» ikke krysset av. Etter steg 4 er den krysset av | | |
| 3.8 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Startnummer for søknader | **Bruker:** opptaket fra 1.2, der «Startnummer for søknader» sto tomt | 1. Se på «Startnummer for søknader». <br>2. Skriv 1001 i «Startnummer for søknader». <br>3. Lagre, og åpne opptaket igjen. | I steg 1 er startnummeret 1. Etter steg 3 er det 1001 | | |
| 3.9 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Endre taket for utdanningstilbud etter at opptaket er opprettet | **Bruker:** opptaket fra 1.2, der taket er 1 | 1. Endre taket for hvor mange utdanningstilbud en søker kan få opptak til («Tilbud per tildelingsrunde» [Sjekk begrep]) fra 1 til 2. <br>2. Lagre, og åpne opptaket igjen. | Taket er 2 | | |
| 3.10 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Sette når redigering av utdanningstilbud åpner og stenger | **Bruker:** opptaket fra 1.2. <br>**Lager:** åpen redigering av utdanningstilbud, som NTNU trenger i 4.2 | 1. Under «Generelle frister», kortet «Redigering av studier»: skriv 01.10.2026 i «Redigering åpner» og 06.06.2027 i «Redigering stenger». <br>2. Lagre, og åpne opptaket igjen. | Datoene står slik du la dem inn | | |
| 3.11 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Sette når søknaden åpner, og ordinær søknadsfrist | **Bruker:** opptaket fra 1.2 | 1. Under kortet «Søkeperiode»: skriv 01.02.2027 i «Åpner for søking» og 15.04.2027 kl. 23:59 i «Ordinær søknadsfrist». <br>2. Lagre, og åpne opptaket igjen. | Datoene står slik du la dem inn | | |
| 3.12 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Sette omprioriteringsfrist og frist for sletting av søknadsalternativer | **Bruker:** opptaket fra 1.2 | 1. Under kortet «Endre søknad»: skriv 15.04.2027 kl. 23:59 i «Omprioriteringsfrist» og 01.05.2027 kl. 23:59 i «Slette søknadsalternativer». <br>2. Lagre, og åpne opptaket igjen. | Fristene står slik du la dem inn. Fristen for sletting kan være senere enn omprioriteringsfristen | | |
| 3.13 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Sette ordinær dokumentasjonsfrist og ettersendingsfrist | **Bruker:** opptaket fra 1.2 | 1. Under kortet «Dokumentasjon»: skriv 15.04.2027 kl. 23:59 i «Ordinær frist» og 01.07.2027 kl. 23:59 i «Ettersendingsfrist». <br>2. Lagre, og åpne opptaket igjen. | Fristene står slik du la dem inn | | |
| 3.14 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Sette frist for endring av utdanningsbakgrunn | **Bruker:** opptaket fra 1.2 | 1. Under kortet «Saksbehandlertildeling»: skriv 01.05.2027 kl. 23:59 i «Endre utdanningsbakgrunn». <br>2. Lagre, og åpne opptaket igjen. | Fristen står slik du la den inn | | |
| 3.15 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Sette når hovedopptaket publiseres | **Bruker:** opptaket fra 1.2 | 1. Under kortet «Hovedopptak»: skriv 15.07.2027 i «Publiseringsdato». La «Svarfrist» stå tom. <br>2. Lagre, og åpne opptaket igjen. | Publiseringsdatoen er 15.07.2027 | | |
| 3.16 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Dato for aldersberegning når den ikke er satt | **Bruker:** opptaket fra 1.2, med publiseringsdatoen fra 3.15 | 1. Se på datoen for aldersberegning [Sjekk begrep: feltet og hvor det står]. Du har ikke satt den. | Datoen for aldersberegning er 31.12.2027, fordi hovedopptaket publiseres i 2027 | | |
| 3.17 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Sette dato for aldersberegning | **Bruker:** opptaket fra 1.2 | 1. Skriv 30.06.2027 i datoen for aldersberegning. <br>2. Lagre, og åpne opptaket igjen. | Datoen for aldersberegning er 30.06.2027 | | |
| 3.18 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Egne frister for søkere med realkompetanse | **Bruker:** opptaket fra 1.2 og utdanningsbakgrunnen «Realkompetanse» | 1. Under «Utdanningsbakgrunner med avvikende frister»: velg «Legg til ny utdanningsbakgrunn», og velg «Realkompetanse». <br>2. Skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» og i «Frist dokumentasjon» på kortet «Realkompetanse». <br>3. Lagre, og åpne opptaket igjen. | Kortet «Realkompetanse» står under «Utdanningsbakgrunner med avvikende frister», med søknadsfrist og dokumentasjonsfrist 01.03.2027 kl. 23:59 | | |

### Del 4: Som lærested som deltar (ca. 10 minutter)

| # | Testbruker | Scenario | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 4.1 | Ansvarsfull Fotkrem, opptaksforvalter ved NTNU | Lærestedet ser innstillingene og fristene, men kan ikke endre dem | **Bruker:** opptaket fra 1.2, med innstillingene og fristene fra del 3 | 1. Bytt rolle til Ansvarsfull Fotkrem (opptaksforvalter, NTNU) [Sjekk begrep: hvor du bytter rolle]. <br>2. Gå til [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak), og åpne «Samordna opptak 2027 – test 2». <br>3. Se gjennom «Innstillinger for opptaket», «Generelle frister» og «Utdanningsbakgrunner med avvikende frister». <br>4. Prøv å endre «Ordinær søknadsfrist» og «Velg regelverksamling knyttet til opptaket». | Du ser alle innstillingene og fristene fra del 3, med de samme verdiene. Du kan ikke endre noen av dem | | |
| 4.2 | Ansvarsfull Fotkrem, opptaksforvalter ved NTNU | Lærestedet kan knytte utdanningstilbud til opptaket | **Bruker:** opptaket fra 1.2, med redigeringen som er åpen fra 3.10, og utdanningstilbudet [Fylles ut: navn på et NTNU-tilbud som får regler fra «UHG 2027»]. <br>**Lager:** et utdanningstilbud i opptaket, som 6.1–6.3 trenger | 1. Knytt utdanningstilbudet til opptaket [Sjekk begrep: hvor og hvordan]. <br>2. Gå ut av opptaket, og åpne det igjen. | Utdanningstilbudet står i opptaket | | |

### Del 5: Som lærested som ikke deltar (ca. 5 minutter)

| # | Testbruker | Scenario | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 5.1 | Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark | Lærestedet ser ikke opptaket i lista | **Bruker:** opptaket fra 1.2 | 1. Bytt rolle til Talefør Elv (opptaksforvalter, Fagskolen Vestfold og Telemark). <br>2. Gå til [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak). | «Samordna opptak 2027 – test 2» står ikke i opptakslista | | |
| 5.2 | Talefør Elv, opptaksforvalter ved Fagskolen Vestfold og Telemark | Lærestedet kan ikke åpne opptaket med lenke | **Bruker:** adressen (URL) du kopierte i 1.2, steg 11 | 1. Lim inn adressen i adressefeltet i nettleseren, og gå dit. | Du ser ikke opptaket, verken innstillingene, fristene eller utdanningstilbudene. Siden sier at du ikke har tilgang, eller at opptaket ikke finnes | | |

### Del 6: Endringer etter at lærestedet har knyttet til utdanningstilbud (ca. 10 minutter)

| # | Testbruker | Scenario | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 6.1 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Et lærested med utdanningstilbud i opptaket kan ikke fjernes | **Bruker:** opptaket fra 1.2, med utdanningstilbudet NTNU knyttet til i 4.2 | 1. Bytt rolle til Ordentlig Rundskriv (opptaksforvalter, HK-dir). <br>2. Åpne «Samordna opptak 2027 – test 2». <br>3. Fjern «NTNU» under «Samordnede organisasjoner» med krysset på kortet, og lagre. <br>4. Åpne opptaket igjen. | NTNU blir ikke fjernet. Du får beskjed om at utdanningstilbudene til NTNU må fjernes først. NTNU står fortsatt under «Samordnede organisasjoner» | | |
| 6.2 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Varsel før regelverkssamlingen byttes | **Bruker:** opptaket fra 1.2, med utdanningstilbudet fra 4.2, og regelverkssamlingen «UHG 2027 v2» | 1. Velg «UHG 2027 v2» i «Velg regelverksamling knyttet til opptaket», og lagre. <br>2. Les varselet. <br>3. Avbryt endringen. <br>4. Åpne opptaket igjen. | I steg 2 ser du et varsel om at utdanningstilbudene som bruker regler fra «UHG 2027», mister alle reglene. Etter steg 4 er regelverkssamlingen fortsatt «UHG 2027» | | |
| 6.3 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Bytte regelverkssamling når opptaket har utdanningstilbud | **Bruker:** det samme som i 6.2 | 1. Velg «UHG 2027 v2» i «Velg regelverksamling knyttet til opptaket», og lagre. <br>2. Bekreft endringen i varselet. <br>3. Åpne opptaket igjen. | Regelverkssamlingen er «UHG 2027 v2» | | |

### Del 7: Lokalt opptak (ca. 10 minutter)

| # | Testbruker | Scenario | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 7.1 | Ru Brødskive, opptaksforvalter ved Høgskulen på Vestlandet (HVL) | Opprette et lokalt opptak | **Bruker:** regelverkssamlingen «Lokalt regelverk» [Fylles ut: navnet i testmiljøet] og opptakstypen «UHG». <br>**Lager:** opptaket «Lokalt opptak høst 2027 – test 2», med én utdanningsbakgrunn | 1. Bytt rolle til Ru Brødskive (opptaksforvalter, HVL). <br>2. Gå til [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak), og velg «Opprett opptak». <br>3. Velg at opptaket skal være lokalt [Sjekk begrep]. <br>4. Skriv «Lokalt opptak høst 2027 – test 2» i «Opptaksnavn (Bokmål)» og «Opptaksnavn (Nynorsk)», og «Local admission autumn 2027 – test 2» i «Opptaksnavn (Engelsk)». <br>5. Velg «UHG» i «Velg opptakstype» og «Lokalt regelverk» i «Velg regelverksamling knyttet til opptaket». <br>6. Velg bare «Norsk videregående skole (inkluderer 23/5-regelen, forkurs og fagskole)» i «Godkjente utdanningsbakgrunner». <br>7. Skriv 5 i «Antall søknadsalternativer», la taket stå på 1, og velg «Loddtrekning» i «Poenglikhetsregel». <br>8. Ikke fyll ut noen frister. <br>9. Lagre, gå til opptakslista, og åpne opptaket igjen. | Opptaket er lagret og står i opptakslista. HVL forvalter opptaket. Navnene og innstillingene står slik du la dem inn | | |
| 7.2 | Ru Brødskive, opptaksforvalter ved Høgskulen på Vestlandet (HVL) | Den siste utdanningsbakgrunnen kan ikke fjernes | **Bruker:** opptaket fra 7.1, som har én utdanningsbakgrunn | 1. Fjern «Norsk videregående skole (inkluderer 23/5-regelen, forkurs og fagskole)» i «Godkjente utdanningsbakgrunner» med krysset. <br>2. Lagre. <br>3. Åpne opptaket igjen. | Utdanningsbakgrunnen blir ikke fjernet, og du ser at opptaket må ha minst én utdanningsbakgrunn. Etter steg 3 står den der fortsatt | | |

## Bestått i runde 1

Dette ble bestått i runde 1 (19.10.2026), og testes ikke på nytt.

| Scenario | Nr. i runde 1 |
|---|---|
| Opptaket kan ikke lagres uten navn, regelverkssamling eller opptakstype | 1.3–1.5 |
| Navn på opptaket på flere språk, og navn som mangler på bokmål, nynorsk eller engelsk | 1.6, 1.8–1.10 |
| Et lærested som ikke deltar, kan ikke knytte utdanningstilbud til opptaket | 2.2 |
| Et lokalt opptak kan ikke ha andre læresteder | 2.5 |
| Bare organisasjoner fra utdanningsregisteret kan legges til | 2.6–2.7 |
| Filtrere på universiteter og høyskoler, og på fagskoler | 2.8–2.9 |
| Regler for saksbehandlertildeling i samordna opptak, ikke i lokale | 2.10–2.11 |
| Poenglikhetsregel med og uten unntak | 3.4–3.5 |
| Maks antall søknadsalternativer | 3.7 |
| Legge til og fjerne utdanningsbakgrunner, og en som søkere har valgt, kan ikke fjernes | 3.12–3.14, 3.18 |

## Ikke testbart nå

[Fylles ut av teamet før testen: testtilfeller som ikke kan gjennomføres i testmiljøet, med grunn og når de kan testes.]

| # | Hvorfor | Når det kan testes |
|---|---|---|
| | | |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Hva søkerne ser og kan gjøre: fristene i søknaden, tidlig opptak, dokumentasjonsopplasting, startnummeret, maks søknadsalternativer og ledige studieplasser | Testes sammen med søknaden |
| Hva fristene gjør for utdanningstilbudene: redigering, trekking, antall studieplasser og poenggrenser | Testes sammen med utdanningstilbudene |
| Hva fristen for endring av utdanningsbakgrunn gjør for hvem som saksbehandler søknaden | Testes sammen med saksbehandlertildelingen |
| Første svarfrist på opptaket | Er ikke avklart ennå |
| Kopiere et tidligere opptak, og deaktivere et opptak | Kommer senere |
| Krav om studierett for å søke | Gjelder ikke samordna opptak, og kommer senere |

## Funn

| # | Testtilfelle | Hva gjorde du | Hva forventet du | Hva skjedde | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

Alvorlighetsgrad: **Stopper** (kritisk feil, stopper systemet eller har alvorlige konsekvenser), **Må fikses før innføring** (vesentlig feil, men det finnes en midlertidig løsning) eller **Kan fikses senere** (mindre feil, skrivefeil, visuelle avvik, forbedringer til backlog).

## Andre funn og erfaringer

Det du oppdager som ikke gjelder testtilfellene, f.eks. brukervennlighet. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et testtilfelle, skriv det her.

| Hva gjorde du? | Hvor gjorde du det? | Hva vil du melde om? |
|---|---|---|
| | | |

## Beslutning

| Felt | Innhold |
|---|---|
| Utfall | Godkjent / Godkjent med forbehold / Ikke godkjent |
| Begrunnelse | |
| Kjente mangler og avtalt retting | |
| Besluttet av og dato | |

## Læring

Fylles ut i et kort møte mellom testerne og teamet etter testen.

- Hvilke feil burde vært fanget før akseptansetesten?
- Hva i testdokumentet var uklart (steg, testbrukere, testdata, begreper)?
- Hva bør inn i sjekklista for trinn 1, og hva bør ut?
