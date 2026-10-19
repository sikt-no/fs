# Ekstern akseptansetest – Opprette og vedlikeholde opptak

- **Nivå**: ekstern (trinn 3)
- **Oppgave**: [tasks/opptak/opprette-og-vedlikeholde-opptak](../oppgave.md)
- **Krav**: `@OPT-OVO-GRU-001`, `@OPT-OVO-SAM-001`, `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, slik de står i sikt-no/fs#754, commit `0ee0b59` (19.10.2026, ikke merget). Sporingen fra test til krav står på kvalitetssikringssiden
- **Testere**: HK-dir
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5120458755
- **Laget**: 2026-10-19 av fs-akseptansetest, revidert 2026-10-19 etter innspill fra kontaktpersonen

---

Velkommen til akseptansetesten av hvordan et samordna opptak opprettes og settes opp i FS Admin. I testen sjekker du om løsningen gjør det kravene sier. Du tester ikke om kravene er de riktige, og du trenger ikke kjenne bakgrunnen for saken. Les [Informasjonsskriv om akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5108334635/Informasjonsskriv+om+akseptansetesting) før du starter.

## Før du starter

| Felt | Innhold |
|---|---|
| Hva er laget | En side i FS Admin der du oppretter et samordna opptak: navnet, hvilke læresteder som deltar, innstillingene og fristene. Lærestedene som deltar, ser innstillingene og fristene, men kan ikke endre dem |
| Hvor du tester | [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak) |
| Dette kan du ikke gjøre i testen | - Se hva søkerne ser av innstillingene og fristene. <br>- Fylle ut «Svarfrist» under «Hovedopptak». Den skal stå tom. |
| Tid | Ca. 50 minutter. Frist: [Fylles ut] |
| Spørsmål underveis | Karen Skadsheim Sikkeland, i [Fylles ut: Teams, e-post eller møte] |

## Slik fyller du ut

1. Ta testene i rekkefølge, og følg stegene slik de står.
2. «Testbruker» sier hvem du skal være. «Testdata» sier hva du bruker, og hva du lager som de neste testene trenger.
3. Skriv det du så i «Faktisk resultat», og Ja, Nei eller Delvis i «Bestått?».
4. Sjekk at det du har lagret, står der når du åpner opptaket igjen.
5. Stemmer noe ikke, skriv hva du gjorde, hva du forventet og hva du fikk. Ta skjermbilde hvis du kan.

## Testene

### Del 1: Opprette opptaket (ca. 10 minutter)

| # | Testbruker | Hva du tester | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 1 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir [Fylles ut: om HK-dir får egne testbrukere] | Opprette et samordna opptak | **Bruker:** regelverkssamlingen «UHG 2027» [Fylles ut: navnet i testmiljøet] og opptakstypen «UHG». <br>**Lager:** opptaket «Samordna opptak 2027 – HK-dir test», som brukes i resten av testen | 1. Logg inn i FS Admin som Ordentlig Rundskriv [Sjekk begrep: hvordan testeren logger inn og velger rolle]. <br>2. Gå til [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak), og velg «Opprett opptak» [Sjekk begrep]. <br>3. Velg at opptaket skal være samordnet [Sjekk begrep]. <br>4. Under «Navn»: skriv «Samordna opptak 2027 – HK-dir test» i «Opptaksnavn (Bokmål)» og «Opptaksnavn (Nynorsk)», og «Coordinated admission 2027 – HK-dir test» i «Opptaksnavn (Engelsk)». <br>5. Under «Innstillinger for opptaket»: velg «UHG» i «Velg opptakstype» og «UHG 2027» i «Velg regelverksamling knyttet til opptaket». <br>6. I «Godkjente utdanningsbakgrunner»: velg «Norsk videregående skole (inkluderer 23/5-regelen, forkurs og fagskole)», «Utenlandsk videregående skole» og «Realkompetanse». <br>7. Skriv 10 i «Antall søknadsalternativer». Se at feltet for hvor mange utdanningstilbud en søker kan få opptak til («Tilbud per tildelingsrunde» [Sjekk begrep]) står på 1, og la det stå. <br>8. Velg «Loddtrekning» i «Poenglikhetsregel». <br>9. Ikke fyll ut noe under «Generelle frister». <br>10. Lagre. <br>11. Gå til opptakslista, og åpne «Samordna opptak 2027 – HK-dir test» igjen. | Opptaket er lagret, og står i opptakslista. HK-dir står som forvalter av opptaket. Navnene og innstillingene står slik du la dem inn | | |
| 2 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Opptaket må ha navn på nynorsk | **Bruker:** de samme verdiene som i test 1. <br>**Lager:** ingenting. Opptaket «Feiltest» skal ikke bli lagret | 1. Gå til [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak), og velg «Opprett opptak». <br>2. Fyll ut som i steg 3–8 i test 1, men skriv navnet «Feiltest» bare på bokmål og engelsk. La «Opptaksnavn (Nynorsk)» stå tomt. <br>3. Lagre. <br>4. Avbryt opprettingen, og gå til opptakslista. | Opptaket lagres ikke, og du ser at navnet på nynorsk må fylles ut. «Feiltest» står ikke i opptakslista | | |

### Del 2: Invitere læresteder (ca. 10 minutter)

| # | Testbruker | Hva du tester | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 3 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Invitere læresteder, og se bare én type lærested | **Bruker:** opptaket fra test 1. <br>**Lager:** NTNU og Høgskolen i Molde som deltakere | 1. Åpne «Samordna opptak 2027 – HK-dir test». <br>2. Under «Samordning»: velg «Inviter organisasjoner til samordningen». <br>3. Velg å se bare fagskoler [Sjekk begrep: filteret for lærestedstype]. <br>4. Velg å se bare universiteter og høyskoler. <br>5. Legg til «NTNU» og «Høgskolen i Molde». <br>6. Lagre, og åpne opptaket igjen. | I steg 3 ser du bare norske fagskoler. I steg 4 ser du bare norske universiteter og høyskoler. Etter steg 6 står NTNU og Høgskolen i Molde under «Samordnede organisasjoner» | | |
| 4 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Fjerne et lærested som ikke har utdanningstilbud i opptaket | **Bruker:** opptaket fra test 1, med Høgskolen i Molde fra test 3 | 1. Fjern «Høgskolen i Molde» med krysset på kortet. <br>2. Lagre, og åpne opptaket igjen. | Høgskolen i Molde står ikke lenger under «Samordnede organisasjoner». NTNU står der fortsatt | | |
| 5 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Knytte regler for saksbehandlertildeling til opptaket | **Bruker:** opptaket fra test 1 og reglene [Fylles ut: hvilke regler, og hvor de finnes] | 1. Knytt reglene for saksbehandlertildeling til opptaket [Fylles ut: hvor]. <br>2. Lagre, og åpne opptaket igjen. | Reglene for saksbehandlertildeling står på opptaket | | |

### Del 3: Innstillinger (ca. 15 minutter)

Alle testene gjøres på «Samordna opptak 2027 – HK-dir test» fra test 1. Hver test slutter med at du lagrer, går til opptakslista og åpner opptaket igjen.

| # | Testbruker | Hva du tester | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 6 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Endre regelverkssamling før lærestedene har knyttet til utdanningstilbud | **Bruker:** opptaket fra test 1 og regelverkssamlingen «UHG 2027 v2» [Fylles ut: navnet i testmiljøet] | 1. Velg «UHG 2027 v2» i «Velg regelverksamling knyttet til opptaket». <br>2. Lagre, og åpne opptaket igjen. <br>3. Velg «UHG 2027» igjen, og lagre. | Etter steg 2 er regelverkssamlingen «UHG 2027 v2». Etter steg 3 er den «UHG 2027» igjen | | |
| 7 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Åpne for søknad på ledige studieplasser | **Bruker:** opptaket fra test 1 | 1. Kryss av for «Ledige studieplasser» under «Valg for opptaket». Ikke kryss av for «Kan søke på tidlig opptak». <br>2. Under «Generelle frister», kortet «Ledige studieplasser»: skriv 20.07.2027 i «Publiseres på nettsiden», 25.07.2027 i «Åpner for søking» og 01.09.2027 i «Stenger for søking». <br>3. Lagre, og åpne opptaket igjen. | «Ledige studieplasser» er krysset av, og de tre datoene står slik du la dem inn | | |
| 8 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Tidlig opptak krever lenke til informasjon | **Bruker:** opptaket fra test 1 | 1. Kryss av for «Kan søke på tidlig opptak». <br>2. Under kortet «Tidlig opptak»: skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» og i «Dokumentasjonsfrist». <br>3. La feltet for lenken til informasjon om tidlig opptak [Sjekk begrep] stå tomt. <br>4. Lagre. | Opptaket lagres ikke, og du ser at lenken må fylles ut | | |
| 9 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Åpne for tidlig opptak | **Bruker:** opptaket fra test 1 og lenken <https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html> | 1. Skriv lenken i feltet for lenken til informasjon om tidlig opptak. <br>2. Skriv 15.02.2027 kl. 23:59 i «Frist for å sette poenggrenser». <br>3. Lagre, og åpne opptaket igjen. | «Kan søke på tidlig opptak» er krysset av. Lenken og de tre fristene for tidlig opptak står slik du la dem inn | | |
| 10 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Startnummer og dokumentasjonsopplasting | **Bruker:** opptaket fra test 1, der «Startnummer for søknader» sto tomt | 1. Se på «Startnummer for søknader». <br>2. Skriv 1001 i «Startnummer for søknader». <br>3. Fjern krysset for «Søker kan laste opp dokumenter». <br>4. Lagre, og åpne opptaket igjen. <br>5. Kryss av for «Søker kan laste opp dokumenter» igjen, og lagre. | I steg 1 er startnummeret 1. Etter steg 4 er det 1001, og «Søker kan laste opp dokumenter» er ikke krysset av. Etter steg 5 er den krysset av | | |

### Del 4: Frister (ca. 10 minutter)

| # | Testbruker | Hva du tester | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 11 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Sette de generelle fristene | **Bruker:** opptaket fra test 1 | Under «Generelle frister»: <br>1. «Redigering av studier»: 01.10.2026 i «Redigering åpner» og 06.06.2027 i «Redigering stenger». <br>2. «Søkeperiode»: 01.02.2027 i «Åpner for søking» og 15.04.2027 kl. 23:59 i «Ordinær søknadsfrist». <br>3. «Endre søknad»: 15.04.2027 kl. 23:59 i «Omprioriteringsfrist» og 01.05.2027 kl. 23:59 i «Slette søknadsalternativer». <br>4. «Dokumentasjon»: 15.04.2027 kl. 23:59 i «Ordinær frist» og 01.07.2027 kl. 23:59 i «Ettersendingsfrist». <br>5. «Saksbehandlertildeling»: 01.05.2027 kl. 23:59 i «Endre utdanningsbakgrunn». <br>6. «Hovedopptak»: 15.07.2027 i «Publiseringsdato». La «Svarfrist» stå tom. <br>7. Lagre, og åpne opptaket igjen. | Alle fristene står slik du la dem inn | | |
| 12 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Dato for aldersberegning | **Bruker:** opptaket fra test 1, med publiseringsdatoen fra test 11 | 1. Se på datoen for aldersberegning [Sjekk begrep]. <br>2. Skriv 30.06.2027, lagre, og åpne opptaket igjen. | I steg 1 er datoen 31.12.2027, fordi hovedopptaket publiseres i 2027. Etter steg 2 er den 30.06.2027 | | |
| 13 | Ordentlig Rundskriv, opptaksforvalter ved HK-dir | Egne frister for søkere med realkompetanse | **Bruker:** opptaket fra test 1 og utdanningsbakgrunnen «Realkompetanse» | 1. Under «Utdanningsbakgrunner med avvikende frister»: velg «Legg til ny utdanningsbakgrunn», og velg «Realkompetanse». <br>2. Skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» og i «Frist dokumentasjon». <br>3. Lagre, og åpne opptaket igjen. | Kortet «Realkompetanse» står med søknadsfrist og dokumentasjonsfrist 01.03.2027 kl. 23:59 | | |

### Del 5: Som lærested som deltar (ca. 5 minutter)

| # | Testbruker | Hva du tester | Testdata | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|---|
| 14 | Ansvarsfull Fotkrem, opptaksforvalter ved NTNU | Lærestedet ser innstillingene og fristene, men kan ikke endre dem | **Bruker:** opptaket fra test 1, med alt du satte i del 1–4 | 1. Bytt rolle til Ansvarsfull Fotkrem (opptaksforvalter, NTNU) [Sjekk begrep: hvor du bytter rolle]. <br>2. Gå til [test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak), og åpne «Samordna opptak 2027 – HK-dir test». <br>3. Se gjennom innstillingene og fristene. <br>4. Prøv å endre «Ordinær søknadsfrist». | Du ser alle innstillingene og fristene du satte i del 1–4, med de samme verdiene. Du kan ikke endre dem | | |

## Andre funn og erfaringer

Her skriver du det du oppdager som ikke står i testene, f.eks. om brukervennlighet, eller om du savner en test. Kontaktpersonen vurderer om og hvor det følges opp.

| Hva gjorde du? | Hvor gjorde du det? | Hva vil du melde om? |
|---|---|---|
| | | |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Lokale opptak | Testen gjelder samordna opptak |
| Hva søkerne ser av fristene og innstillingene, og hva fristene gjør for lærestedenes utdanningstilbud | Testes når søknaden og utdanningstilbudene er klare |
| Første svarfrist på opptaket | Er ikke avklart ennå |
| Bytte regelverkssamling etter at lærestedene har knyttet til utdanningstilbud | Testes internt, fordi det trenger utdanningstilbud fra lærestedene |
| Kopiere et tidligere opptak, og deaktivere et opptak | Kommer senere |

## Konklusjon

| Felt | Innhold |
|---|---|
| Utfall | Godkjent / Godkjent med forbehold / Ikke godkjent |
| Begrunnelse | |
| Testet av og dato | |
