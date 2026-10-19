# Ekstern akseptansetest – Opprette og vedlikeholde opptak

- **Nivå**: ekstern (trinn 3)
- **Oppgave**: [tasks/opptak/opprette-og-vedlikeholde-opptak](../oppgave.md)
- **Krav**: `@OPT-OVO-GRU-001`, `@OPT-OVO-SAM-001`, `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, slik de står i sikt-no/fs#754, commit `0ee0b59` (19.10.2026, ikke merget)
- **Bygger på**: [intern akseptansetest 2](akseptansetest-intern-opprette-og-vedlikeholde-opptak-2.md) (eksternt nr. → internt nr.: 1 → 1.1/1.2, 2 → 1.3, 3 → 2.1 og intern 1: 2.6–2.8, 4 → 2.1, 5 → intern 1: 2.10, 6 → 3.2, 7 → 3.3, 8 → 3.4, 9 → 3.6, 10 → 3.7–3.9, 11 → 3.10–3.15, 12 → 3.17, 13 → 3.18, 14 → 4.1)
- **Testere**: HK-dir
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5120458755
- **Laget**: 2026-10-19 av fs-akseptansetest

---

Velkommen til akseptansetesten av hvordan et samordna opptak opprettes og settes opp i FS Admin. I testen sjekker du om løsningen gjør det kravene sier. Du tester ikke om kravene er de riktige, og du trenger ikke kjenne bakgrunnen for saken. Les [Informasjonsskriv om akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5108334635/Informasjonsskriv+om+akseptansetesting) før du starter.

## Før du starter

| | |
|---|---|
| Hva er laget | En side i FS Admin der du oppretter et samordna opptak: navnet, hvilke læresteder som deltar, innstillingene og fristene. Lærestedene som deltar, ser innstillingene og fristene, men kan ikke endre dem |
| Hvor du tester | <https://test-fsadmin.sikt.no/opptak> |
| Hvem du er | Del 1–4: opptaksforvalter i HK-dir (testbrukeren Ordentlig Rundskriv). Del 5: opptaksforvalter ved et lærested som deltar (testbrukeren Ansvarsfull Fotkrem, NTNU). [Fylles ut: om HK-dir får egne testbrukere] |
| Tid | Ca. 50 minutter. Frist: [Fylles ut] |
| Spørsmål underveis | Karen Skadsheim Sikkeland, i [Fylles ut: Teams, e-post eller møte] |

## Slik fyller du ut

1. Ta testene i rekkefølge, og følg stegene slik de står.
2. Skriv det du så i «Faktisk resultat», og Ja, Nei eller Delvis i «Bestått?».
3. Sjekk at det du har lagret, står der når du åpner opptaket igjen.
4. Stemmer noe ikke, skriv hva du gjorde, hva du forventet og hva du fikk. Ta skjermbilde hvis du kan.

## Testene

### Del 1: Opprette opptaket

**Logg inn som:** Opptaksforvalter i HK-dir (Ordentlig Rundskriv)
**Tid:** ca. 10 minutter

| # | Hva du tester | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 1 | Opprette et samordna opptak | 1. Gå til <https://test-fsadmin.sikt.no/opptak>, og velg «Opprett opptak» [Sjekk begrep]. <br>2. Velg at opptaket skal være samordnet [Sjekk begrep]. <br>3. Under «Navn»: skriv «Samordna opptak 2027 – HK-dir test» i «Opptaksnavn (Bokmål)» og «Opptaksnavn (Nynorsk)», og «Coordinated admission 2027 – HK-dir test» i «Opptaksnavn (Engelsk)». <br>4. Under «Innstillinger for opptaket»: velg «UHG» i «Velg opptakstype» og «UHG 2027» [Fylles ut: navnet i testmiljøet] i «Velg regelverksamling knyttet til opptaket». <br>5. I «Godkjente utdanningsbakgrunner»: velg «Norsk videregående skole (inkluderer 23/5-regelen, forkurs og fagskole)», «Utenlandsk videregående skole» og «Realkompetanse». <br>6. Skriv 10 i «Antall søknadsalternativer». Se at feltet for hvor mange utdanningstilbud en søker kan få opptak til («Tilbud per tildelingsrunde» [Sjekk begrep]) står på 1, og la det stå. <br>7. Velg «Loddtrekning» i «Poenglikhetsregel». <br>8. Ikke fyll ut noe under «Generelle frister». <br>9. Lagre. <br>10. Gå til opptakslista, og åpne «Samordna opptak 2027 – HK-dir test» igjen. | Opptaket er lagret, og står i opptakslista. HK-dir står som forvalter av opptaket. Navnene og innstillingene står slik du la dem inn | | |
| 2 | Opptaket må ha navn på nynorsk | 1. Gå til <https://test-fsadmin.sikt.no/opptak>, og velg «Opprett opptak». <br>2. Fyll ut som i steg 2–7 i test 1, men med navnet «Feiltest» bare på bokmål og engelsk. La «Opptaksnavn (Nynorsk)» stå tomt. <br>3. Lagre. <br>4. Avbryt opprettingen. | Opptaket lagres ikke, og du ser at navnet på nynorsk må fylles ut. «Feiltest» står ikke i opptakslista | | |

### Del 2: Invitere læresteder

**Logg inn som:** Opptaksforvalter i HK-dir (Ordentlig Rundskriv)
**Tid:** ca. 10 minutter

| # | Hva du tester | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 3 | Invitere læresteder, og se bare én type lærested | 1. Åpne «Samordna opptak 2027 – HK-dir test». <br>2. Under «Samordning»: velg «Inviter organisasjoner til samordningen». <br>3. Velg å se bare fagskoler [Sjekk begrep: filteret for lærestedstype]. <br>4. Velg å se bare universiteter og høyskoler. <br>5. Legg til «NTNU» og «Høgskolen i Molde». <br>6. Lagre, og åpne opptaket igjen. | I steg 3 ser du bare norske fagskoler. I steg 4 ser du bare norske universiteter og høyskoler. Etter steg 6 står NTNU og Høgskolen i Molde under «Samordnede organisasjoner» | | |
| 4 | Fjerne et lærested som ikke har utdanningstilbud i opptaket | 1. Fjern «Høgskolen i Molde» med krysset på kortet. <br>2. Lagre, og åpne opptaket igjen. | Høgskolen i Molde står ikke lenger under «Samordnede organisasjoner». NTNU står der fortsatt | | |
| 5 | Knytte regler for saksbehandlertildeling til opptaket | 1. Knytt reglene for saksbehandlertildeling til opptaket [Fylles ut: hvor og hvilke regler]. <br>2. Lagre, og åpne opptaket igjen. | Reglene for saksbehandlertildeling står på opptaket | | |

### Del 3: Innstillinger

**Logg inn som:** Opptaksforvalter i HK-dir (Ordentlig Rundskriv)
**Tid:** ca. 15 minutter

Alle testene gjøres på «Samordna opptak 2027 – HK-dir test». Hver test slutter med at du lagrer, går til opptakslista og åpner opptaket igjen.

| # | Hva du tester | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 6 | Endre regelverkssamling før lærestedene har knyttet til utdanningstilbud | 1. Velg «UHG 2027 v2» [Fylles ut: navnet i testmiljøet] i «Velg regelverksamling knyttet til opptaket». <br>2. Lagre, og åpne opptaket igjen. <br>3. Velg «UHG 2027» igjen, og lagre. | Etter steg 2 er regelverkssamlingen «UHG 2027 v2». Etter steg 3 er den «UHG 2027» | | |
| 7 | Åpne for søknad på ledige studieplasser | 1. Kryss av for «Ledige studieplasser» under «Valg for opptaket». Ikke kryss av for «Kan søke på tidlig opptak». <br>2. Under «Generelle frister», kortet «Ledige studieplasser»: skriv 20.07.2027 i «Publiseres på nettsiden», 25.07.2027 i «Åpner for søking» og 01.09.2027 i «Stenger for søking». <br>3. Lagre, og åpne opptaket igjen. | «Ledige studieplasser» er krysset av, og de tre datoene står slik du la dem inn | | |
| 8 | Tidlig opptak krever lenke til informasjon | 1. Kryss av for «Kan søke på tidlig opptak». <br>2. Under kortet «Tidlig opptak»: skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» og i «Dokumentasjonsfrist». <br>3. La feltet for lenken til informasjon om tidlig opptak [Sjekk begrep] stå tomt. <br>4. Lagre. | Opptaket lagres ikke, og du ser at lenken må fylles ut | | |
| 9 | Åpne for tidlig opptak | 1. Skriv <https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html> i feltet for lenken. <br>2. Skriv 15.02.2027 kl. 23:59 i «Frist for å sette poenggrenser». <br>3. Lagre, og åpne opptaket igjen. | «Kan søke på tidlig opptak» er krysset av. Lenken og de tre fristene for tidlig opptak står slik du la dem inn | | |
| 10 | Dokumentasjonsopplasting og startnummer | 1. Se at «Startnummer for søknader» er 1. <br>2. Skriv 1001 i «Startnummer for søknader». <br>3. Fjern krysset for «Søker kan laste opp dokumenter». <br>4. Lagre, og åpne opptaket igjen. <br>5. Kryss av for «Søker kan laste opp dokumenter» igjen, og lagre. | I steg 1 er startnummeret 1. Etter steg 4 er det 1001, og «Søker kan laste opp dokumenter» er ikke krysset av. Etter steg 5 er den krysset av | | |

### Del 4: Frister

**Logg inn som:** Opptaksforvalter i HK-dir (Ordentlig Rundskriv)
**Tid:** ca. 10 minutter

| # | Hva du tester | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 11 | Sette de generelle fristene | Under «Generelle frister»: <br>1. «Redigering av studier»: 01.10.2026 i «Redigering åpner» og 06.06.2027 i «Redigering stenger». <br>2. «Søkeperiode»: 01.02.2027 i «Åpner for søking» og 15.04.2027 kl. 23:59 i «Ordinær søknadsfrist». <br>3. «Endre søknad»: 15.04.2027 kl. 23:59 i «Omprioriteringsfrist» og 01.05.2027 kl. 23:59 i «Slette søknadsalternativer». <br>4. «Dokumentasjon»: 15.04.2027 kl. 23:59 i «Ordinær frist» og 01.07.2027 kl. 23:59 i «Ettersendingsfrist». <br>5. «Saksbehandlertildeling»: 01.05.2027 kl. 23:59 i «Endre utdanningsbakgrunn». <br>6. «Hovedopptak»: 15.07.2027 i «Publiseringsdato». La «Svarfrist» stå tomt. <br>7. Lagre, og åpne opptaket igjen. | Alle fristene står slik du la dem inn | | |
| 12 | Dato for aldersberegning | 1. Se på datoen for aldersberegning [Sjekk begrep]. <br>2. Skriv 30.06.2027, lagre, og åpne opptaket igjen. | I steg 1 er datoen 31.12.2027, fordi hovedopptaket publiseres i 2027. Etter steg 2 er den 30.06.2027 | | |
| 13 | Egne frister for søkere med realkompetanse | 1. Under «Utdanningsbakgrunner med avvikende frister»: velg «Legg til ny utdanningsbakgrunn», og velg «Realkompetanse». <br>2. Skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» og i «Frist dokumentasjon». <br>3. Lagre, og åpne opptaket igjen. | Kortet «Realkompetanse» står med søknadsfrist og dokumentasjonsfrist 01.03.2027 kl. 23:59 | | |

### Del 5: Som lærested som deltar

**Logg inn som:** Opptaksforvalter ved et lærested som deltar (Ansvarsfull Fotkrem, NTNU)
**Tid:** ca. 5 minutter

| # | Hva du tester | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 14 | Lærestedet ser innstillingene og fristene, men kan ikke endre dem | 1. Bytt rolle til Ansvarsfull Fotkrem (opptaksforvalter, NTNU) [Sjekk begrep: hvor du bytter rolle]. <br>2. Gå til <https://test-fsadmin.sikt.no/opptak>, og åpne «Samordna opptak 2027 – HK-dir test». <br>3. Se gjennom innstillingene og fristene. <br>4. Prøv å endre «Ordinær søknadsfrist». | Du ser alle innstillingene og fristene du satte i del 1–4, med de samme verdiene. Du kan ikke endre dem | | |

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

| | |
|---|---|
| Utfall | Godkjent / Godkjent med forbehold / Ikke godkjent |
| Begrunnelse | |
| Testet av og dato | |
