# Intern akseptansetest 2 – Opprette og vedlikeholde opptak

- **Nivå**: intern (trinn 2), runde 2
- **Oppgave**: [tasks/opptak/opprette-og-vedlikeholde-opptak](../oppgave.md)
- **Krav**: `@OPT-OVO-GRU-001`, `@OPT-OVO-SAM-001`, `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, slik de står i sikt-no/fs#754, commit `0ee0b59` (19.10.2026, ikke merget)
- **Bygger på**: intern akseptansetest 1 (Confluence 5109022726), resultater 19.10.2026
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5120589830
- **Laget**: 2026-10-19 av fs-akseptansetest

---

Testbeskrivelse og testgjennomføring for runde 2 av den interne akseptansetesten av «Opprette og vedlikeholde opptak». Runde 2 tester det som ikke ble bestått eller ikke ble testet i runde 1, og kravene som er nye eller endret etter runde 1. Det som ble bestått i runde 1, står i «Bestått i runde 1». Siden følger rutinen [Kvalitetssikring og akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5091196953/Kvalitetssikring+og+akseptansetesting). Felt merket **[Fylles ut]** fylles ut av teamet før testen, og ord merket **[Sjekk begrep]** sjekkes mot skjermen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Sak | [sikt-no/fs#211](https://github.com/sikt-no/fs/issues/211) · Epic [TAKE-318](https://sikt.atlassian.net/browse/TAKE-318) |
| Krav | [opprett_opptak.feature](https://github.com/sikt-no/fs/blob/krav/opptak-akseptansetest/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) (`@OPT-OVO-GRU-001`, `@implemented`, med en `@planned`-regel), [samordna_opptak.feature](https://github.com/sikt-no/fs/blob/krav/opptak-akseptansetest/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) (`@OPT-OVO-SAM-001`), [innstillinger.feature](https://github.com/sikt-no/fs/blob/krav/opptak-akseptansetest/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) (`@OPT-OVO-INN-001`) og [frister_og_hendelser.feature](https://github.com/sikt-no/fs/blob/krav/opptak-akseptansetest/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) (`@OPT-OVO-FRI-001`), alle `@in-progress` unntatt den første. Versjonen i [sikt-no/fs#754](https://github.com/sikt-no/fs/pull/754), commit `0ee0b59` |
| Hva er laget | En side i FS Admin der opptaksforvalteren oppretter et samordna eller lokalt opptak. Siden har seksjonene «Navn» (bokmål, nynorsk, engelsk og samisk), «Samordning» (invitere læresteder), «Innstillinger for opptaket» (opptakstype, regelverkssamling, utdanningsbakgrunner, startnummer, antall søknadsalternativer, tak for utdanningstilbud, poenglikhetsregel, ledige studieplasser, tidlig opptak og dokumentasjonsopplasting), «Generelle frister» og «Utdanningsbakgrunner med avvikende frister» |
| Brukerhistorie | Som opptaksforvalter ønsker jeg å opprette et opptak for organisasjonen jeg forvalter, invitere læresteder, og sette innstillinger og frister, slik at utdanningstilbud kan knyttes til opptaket og søkere kan søke |
| Endret siden runde 1 | Kravene sier nå at innstillingene og fristene settes og finnes på opptaket. Virkningen hos søkeren, i saksbehandlingen og for utdanningstilbudene står i andre krav, og testes ikke her. Nye scenarioer: utdanningsbakgrunner, poenglikhetsregel, antall søknadsalternativer og tak for utdanningstilbud må være satt for å lagre; fristene kan stå tomme; taket er forhåndsutfylt med 1; startnummeret er 1 når det ikke er satt; opptakstype og regelverkssamling kan endres når som helst, med varsel når utdanningstilbud mister reglene; den siste utdanningsbakgrunnen kan ikke fjernes; tidlig opptak krever søknadsfrist og dokumentasjonsfrist; en organisasjon som ikke deltar, kan ikke åpne opptaket; en deltaker med utdanningstilbud kan ikke fjernes; en deltaker ser alle innstillinger og frister |
| Hvor testes det | Miljø: TEST. URL: <https://test-fsadmin.sikt.no/opptak> |
| Kvalitetssikring i teamet | [Kvalitetssikring i teamet – Opprette og vedlikeholde opptak](kvalitetssikring-opprette-og-vedlikeholde-opptak.md). [Fylles ut: gjennomført dato] |
| Berører andre team | Shinkansen (utdanningstilbud og redigeringsfristene), Puff (saksbehandlertildeling og fristen for endring av utdanningsbakgrunn), Min kompetanse (frister, tidlig opptak, dokumentasjonsopplasting), plasstildeling (publiseringsdato og tak for utdanningstilbud) |
| Kjente begrensninger | Kravene er hentet fra #754, som ikke er merget. Teamet bekrefter før testen hvilke av de nye scenarioene som er i miljøet (sjekkliste 4.4). Det som ikke er der, flyttes til «Ikke testbart nå». Samordna opptak ligger bak feature-flagget `opptak-opprett-samordna` (på i test). Eksemplene i kravene bruker «Universitetet i Oslo» som deltaker og «NTNU» som organisasjon som ikke deltar. I testen er NTNU deltaker og Fagskolen Vestfold og Telemark organisasjonen som ikke deltar, fordi det er organisasjonene til testbrukerne. Feltet for taket for utdanningstilbud het «Tilbud per tildelingsrunde» i runde 1 [Sjekk begrep] |
| Kontaktperson i teamet | Karen Skadsheim Sikkeland (deltar fra teamet: Maciek Adamczyk og Jøran Wigen Aasterud) |
| Testansvarlig | Marit Bjørnerud Rønning |
| Andre testere | [Fylles ut, og hvem som tar hvilke deler] |
| Tid | [Fylles ut: dato og klokkeslett]. Beregnet tid: ca. 100 minutter, fordelt på delene |
| Spørsmål underveis | Slack-tråden «Akseptansetesting opprette og vedlikeholde opptak 2» i [#fs-fremtidens-opptak](https://sikt-no.slack.com/archives/C0BVBHA9E2H) |

### Testbrukere

Du bytter testbruker med rollevelgeren i FS Admin [Sjekk begrep: hvor rollevelgeren står].

| Rolle (fra kravene) | Testbruker | Organisasjon | Brukes i |
|---|---|---|---|
| Opptaksforvalter ved forvaltende organisasjon | Ordentlig Rundskriv | HK-dir | Del 1, 2, 3 og 6 |
| Opptaksforvalter ved deltakende organisasjon | Ansvarsfull Fotkrem | NTNU | Del 4 |
| Opptaksforvalter ved en organisasjon som ikke deltar | Talefør Elv | Fagskolen Vestfold og Telemark | Del 5 |
| Opptaksforvalter ved et lærested med lokalt opptak | Ru Brødskive | Høgskulen på Vestlandet (HVL) | Del 7 |

### Testdata

| Hva | Verdi | Hvor du finner det | Brukes i |
|---|---|---|---|
| Opptaket du lager i testen | «Samordna opptak 2027 – test 2» | Lages i 1.2 | Del 1–6 |
| Det lokale opptaket du lager i testen | «Lokalt opptak høst 2027 – test 2» | Lages i 7.1 | Del 7 |
| Regelverkssamling | «UHG 2027» [Fylles ut: navnet i testmiljøet] | Nedtrekkslista «Velg regelverksamling knyttet til opptaket» | 1.2, 6.2 |
| Ny regelverkssamling | «UHG 2027 v2» [Fylles ut: navnet i testmiljøet] | Samme nedtrekksliste | 3.2, 6.2, 6.3 |
| Regelverkssamling for lokalt opptak | «Lokalt regelverk» [Fylles ut: navnet i testmiljøet] | Samme nedtrekksliste | 7.1 |
| Opptakstype | «UHG», og «HYU» for endringen [Sjekk begrep] | Nedtrekkslista «Velg opptakstype» | 1.2, 3.1 |
| Utdanningstilbud ved NTNU som kan knyttes til opptaket, og som får regler fra regelverkssamlingen | [Fylles ut: navn på utdanningstilbudet, og hvordan det får regler fra «UHG 2027»] | | 4.2, 6.1, 6.2 |
| Organisasjon som legges til og fjernes igjen | «Høgskolen i Molde» | Utdanningsregisteret, via «Inviter organisasjoner til samordningen» | 2.1 |

### Viktige endringer fra FS-klienten

- Opptakstype er et fast kodeverk som bare brukes til kategorisering. Opptaket arver ikke innstillinger fra opptakstypen.
- Samordning er en egenskap ved opptaket: forvaltende organisasjon inviterer læresteder, og bare forvaltende organisasjon kan endre innstillinger, frister og regelverk.
- Utdanningsbakgrunn styrer avvikende frister, ikke hvem som kan søke.
- Standard poenglikhetsregel settes på opptaket, ikke på rangeringsregelverket.
- Fristene har klokkeslett, og kan stå tomme.
- Navnet på opptaket skal være på bokmål, nynorsk og engelsk. Samisk er valgfritt.

## Åpne spørsmål

Ingen spørsmål avgjør forventet resultat i denne testen. S1, S3 og S4 fra runde 1 er besvart og skrevet inn i kravene. S2 (første svarfrist) er fortsatt åpen, og scenarioet er ikke med (se «Ikke med i denne testen»).

## Slik tester du

- Ta delene og testtilfellene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Bestått?» med Ja, Nei eller Delvis.
- Sjekk at det du har lagret, står der når du åpner opptaket igjen.
- Funn skrives i «Funn»: hva du gjorde, hva du forventet, hva du fikk.
- Mer i [Informasjonsskriv om akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5108334635/Informasjonsskriv+om+akseptansetesting).

## Testgjennomføring

### Del 1: Opprette et samordna opptak

**Logg inn som:** Opptaksforvalter ved forvaltende organisasjon (Ordentlig Rundskriv, HK-dir)
**Forutsetter:** Regelverkssamlingen «UHG 2027» finnes
**Tid:** ca. 20 minutter

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 1.1 | `@OPT-OVO-INN-001` Taket er forhåndsutfylt med 1 · Opplasting er åpen når opptaksforvalter ikke har endret innstillingen | 1. Gå til <https://test-fsadmin.sikt.no/opptak>. <br>2. Velg «Opprett opptak» [Sjekk begrep]. <br>3. Se på feltet for hvor mange utdanningstilbud en søker kan få opptak til («Tilbud per tildelingsrunde» [Sjekk begrep]) under «Innstillinger for opptaket». <br>4. Se på «Søker kan laste opp dokumenter» under «Valg for opptaket». | Feltet i steg 3 er forhåndsutfylt med 1. «Søker kan laste opp dokumenter» er krysset av | | |
| 1.2 | `@OPT-OVO-GRU-001` Opprette et samordna opptak · `@OPT-OVO-FRI-001` Lagre opptaket uten frister · `@OPT-OVO-GRU-001` Lagre opptak med navn på alle obligatoriske språk | Fortsett i skjemaet fra 1.1. <br>1. Velg at opptaket skal være samordnet [Sjekk begrep]. <br>2. Under «Navn»: skriv «Samordna opptak 2027 – test 2» i «Opptaksnavn (Bokmål)» og «Opptaksnavn (Nynorsk)», og «Coordinated admission 2027 – test 2» i «Opptaksnavn (Engelsk)». La «Opptaksnavn (Samisk)» stå tomt. <br>3. Under «Samordning»: velg «Inviter organisasjoner til samordningen», og legg til «NTNU». <br>4. Under «Innstillinger for opptaket»: velg «UHG» i «Velg opptakstype» og «UHG 2027» i «Velg regelverksamling knyttet til opptaket». <br>5. I «Godkjente utdanningsbakgrunner»: velg «Norsk videregående skole (inkluderer 23/5-regelen, forkurs og fagskole)», «Utenlandsk videregående skole» og «Realkompetanse». <br>6. La «Startnummer for søknader» stå tomt. Skriv 10 i «Antall søknadsalternativer». La taket fra 1.1 stå på 1. <br>7. Velg «Loddtrekning» i «Poenglikhetsregel». <br>8. Ikke kryss av for «Ledige studieplasser» eller «Kan søke på tidlig opptak». <br>9. Ikke fyll ut noe under «Generelle frister». <br>10. Lagre. <br>11. Kopier adressen (URL) til opptaket fra adressefeltet i nettleseren. Du trenger den i 5.2. <br>12. Gå til opptakslista, og åpne «Samordna opptak 2027 – test 2» igjen. | Opptaket er lagret uten frister. Det står i opptakslista. HK-dir står som forvalter av opptaket, og NTNU står under «Samordnede organisasjoner». Navnene på bokmål, nynorsk og engelsk og alle innstillingene fra steg 4–7 står slik du la dem inn | | |
| 1.3a | `@OPT-OVO-GRU-001` Lagre opptak uten utdanningsbakgrunner | 1. Gå til <https://test-fsadmin.sikt.no/opptak>, og velg «Opprett opptak». <br>2. Fyll ut som i steg 1–7 i 1.2, men med navnet «Feiltest 2027» på alle tre språk, og uten å velge noen utdanningsbakgrunn. <br>3. Lagre. | Opptaket lagres ikke, og du ser at utdanningsbakgrunner må velges | | |
| 1.3b | `@OPT-OVO-GRU-001` Lagre opptak uten standard poenglikhetsregel | 1. Velg utdanningsbakgrunnene igjen, som i 1.2. <br>2. Fjern valget i «Poenglikhetsregel». <br>3. Lagre. | Opptaket lagres ikke, og du ser at poenglikhetsregel må velges | | |
| 1.3c | `@OPT-OVO-GRU-001` Lagre opptak uten maks antall søknadsalternativer | 1. Velg «Loddtrekning» i «Poenglikhetsregel» igjen. <br>2. Tøm «Antall søknadsalternativer». <br>3. Lagre. | Opptaket lagres ikke, og du ser at antall søknadsalternativer må fylles ut | | |
| 1.3d | `@OPT-OVO-GRU-001` Lagre opptak uten tak for hvor mange utdanningstilbud en søker kan få opptak til | 1. Skriv 10 i «Antall søknadsalternativer» igjen. <br>2. Tøm feltet for taket («Tilbud per tildelingsrunde» [Sjekk begrep]). <br>3. Lagre. <br>4. Avbryt opprettingen, og sjekk at «Feiltest 2027» ikke står i opptakslista. | Opptaket lagres ikke, og du ser at taket må fylles ut. «Feiltest 2027» står ikke i opptakslista | | |

### Del 2: Invitere og fjerne læresteder

**Logg inn som:** Opptaksforvalter ved forvaltende organisasjon (Ordentlig Rundskriv, HK-dir)
**Forutsetter:** Opptaket fra 1.2
**Tid:** ca. 5 minutter

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 2.1 | `@OPT-OVO-SAM-001` Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket | 1. Åpne «Samordna opptak 2027 – test 2». <br>2. Under «Samordning»: velg «Inviter organisasjoner til samordningen», legg til «Høgskolen i Molde», og lagre. <br>3. Åpne opptaket igjen, og sjekk at «Høgskolen i Molde» står under «Samordnede organisasjoner». <br>4. Fjern «Høgskolen i Molde» med krysset på kortet, og lagre. <br>5. Åpne opptaket igjen. | «Høgskolen i Molde» står ikke lenger under «Samordnede organisasjoner». NTNU står der fortsatt | | |

Testen av å fjerne en deltaker som har utdanningstilbud, er i 6.1, etter at NTNU har knyttet et utdanningstilbud til opptaket.

### Del 3: Innstillinger og frister

**Logg inn som:** Opptaksforvalter ved forvaltende organisasjon (Ordentlig Rundskriv, HK-dir)
**Forutsetter:** Opptaket fra 1.2, uten utdanningstilbud
**Tid:** ca. 40 minutter

Alle testtilfellene i delen gjøres på «Samordna opptak 2027 – test 2». Hvert testtilfelle slutter med at du lagrer, går til opptakslista og åpner opptaket igjen.

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 3.1 | `@OPT-OVO-INN-001` Endre opptakstype | 1. Åpne opptaket. <br>2. Velg «HYU» i «Velg opptakstype». <br>3. Lagre, og åpne opptaket igjen. | Opptakstypen er «HYU». Ingenting annet på opptaket er endret | | |
| 3.2 | `@OPT-OVO-INN-001` Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket · `@OPT-OVO-SAM-001` Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | 1. Velg «UHG 2027 v2» i «Velg regelverksamling knyttet til opptaket». <br>2. Lagre, og åpne opptaket igjen. <br>3. Velg «UHG 2027» igjen, og lagre. | Regelverkssamlingen var «UHG 2027 v2» etter steg 2. Det kom ikke noe varsel, fordi opptaket ikke har utdanningstilbud. Etter steg 3 er den «UHG 2027» | | |
| 3.3 | `@OPT-OVO-INN-001` Aktivere ledige studieplasser · `@OPT-OVO-FRI-001` de tre datoene for ledige studieplasser | 1. Kryss av for «Ledige studieplasser» under «Valg for opptaket». Ikke kryss av for «Kan søke på tidlig opptak». <br>2. Under «Generelle frister», kortet «Ledige studieplasser»: skriv 20.07.2027 i «Publiseres på nettsiden», 25.07.2027 i «Åpner for søking» og 01.09.2027 i «Stenger for søking». <br>3. Lagre, og åpne opptaket igjen. | Opptaket er lagret uten at datoene for tidlig opptak er fylt ut. «Ledige studieplasser» er krysset av, og de tre datoene står slik du la dem inn | | |
| 3.4 | `@OPT-OVO-INN-001` Lenken må være satt når tidlig opptak er aktivert | 1. Kryss av for «Kan søke på tidlig opptak». <br>2. Under kortet «Tidlig opptak»: skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» og i «Dokumentasjonsfrist». <br>3. La feltet for lenken til informasjon om tidlig opptak [Sjekk begrep] stå tomt. <br>4. Lagre. | Opptaket lagres ikke, og du ser at lenken til informasjon om tidlig opptak må fylles ut | | |
| 3.5a | `@OPT-OVO-FRI-001` Opptaket kan ikke lagres uten søknadsfristen for tidlig opptak når tidlig opptak er aktivert | 1. Skriv <https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html> i feltet for lenken. <br>2. Tøm «Søknadsfrist» under kortet «Tidlig opptak». <br>3. Lagre. | Opptaket lagres ikke, og du ser at søknadsfristen for tidlig opptak må fylles ut | | |
| 3.5b | `@OPT-OVO-FRI-001` Opptaket kan ikke lagres uten dokumentasjonsfristen for tidlig opptak når tidlig opptak er aktivert | 1. Skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» igjen. <br>2. Tøm «Dokumentasjonsfrist» under kortet «Tidlig opptak». <br>3. Lagre. | Opptaket lagres ikke, og du ser at dokumentasjonsfristen for tidlig opptak må fylles ut | | |
| 3.6 | `@OPT-OVO-INN-001` Aktivere tidlig opptak · Sette lenke til informasjon om tidlig opptak · `@OPT-OVO-FRI-001` Sette søknadsfrist, dokumentasjonsfrist og frist for poenggrenser for tidlig opptak | 1. Skriv 01.03.2027 kl. 23:59 i «Dokumentasjonsfrist» igjen. <br>2. Skriv 15.02.2027 kl. 23:59 i «Frist for å sette poenggrenser». <br>3. Lagre, og åpne opptaket igjen. | «Kan søke på tidlig opptak» er krysset av. Lenken, søknadsfristen, dokumentasjonsfristen og fristen for poenggrenser står slik du la dem inn | | |
| 3.7 | `@OPT-OVO-INN-001` Stenge for dokumentasjonsopplasting · Åpne for dokumentasjonsopplasting | 1. Fjern krysset for «Søker kan laste opp dokumenter». <br>2. Lagre, åpne opptaket igjen, og se på «Søker kan laste opp dokumenter». <br>3. Kryss av for «Søker kan laste opp dokumenter» igjen. <br>4. Lagre, og åpne opptaket igjen. | Etter steg 2 er «Søker kan laste opp dokumenter» ikke krysset av. Etter steg 4 er den krysset av | | |
| 3.8 | `@OPT-OVO-INN-001` Startnummeret er 1 når opptaksforvalter ikke har satt det · Sette startnummer for søknader i opptaket | 1. Se på «Startnummer for søknader», som du lot stå tomt i 1.2. <br>2. Skriv 1001 i «Startnummer for søknader». <br>3. Lagre, og åpne opptaket igjen. | I steg 1 er startnummeret 1. Etter steg 3 er det 1001 | | |
| 3.9 | `@OPT-OVO-INN-001` Endre taket etter at opptaket er opprettet | 1. Endre taket for hvor mange utdanningstilbud en søker kan få opptak til («Tilbud per tildelingsrunde» [Sjekk begrep]) fra 1 til 2. <br>2. Lagre, og åpne opptaket igjen. | Taket er 2 | | |
| 3.10 | `@OPT-OVO-FRI-001` Sette når redigering av utdanningstilbud åpner · Sette når redigering av utdanningstilbud stenger | 1. Under «Generelle frister», kortet «Redigering av studier»: skriv 01.10.2026 i «Redigering åpner» og 06.06.2027 i «Redigering stenger». <br>2. Lagre, og åpne opptaket igjen. | Datoene står slik du la dem inn | | |
| 3.11 | `@OPT-OVO-FRI-001` Sette søknadsdato · Sette ordinær søknadsfrist | 1. Under kortet «Søkeperiode»: skriv 01.02.2027 i «Åpner for søking» og 15.04.2027 kl. 23:59 i «Ordinær søknadsfrist». <br>2. Lagre, og åpne opptaket igjen. | Datoene står slik du la dem inn | | |
| 3.12 | `@OPT-OVO-FRI-001` Sette omprioriteringsfrist · Sette frist for sletting av søknadsalternativer | 1. Under kortet «Endre søknad»: skriv 15.04.2027 kl. 23:59 i «Omprioriteringsfrist» og 01.05.2027 kl. 23:59 i «Slette søknadsalternativer». <br>2. Lagre, og åpne opptaket igjen. | Fristene står slik du la dem inn. Fristen for sletting kan være senere enn omprioriteringsfristen | | |
| 3.13 | `@OPT-OVO-FRI-001` Sette ordinær dokumentasjonsfrist · Sette ettersendingsfrist | 1. Under kortet «Dokumentasjon»: skriv 15.04.2027 kl. 23:59 i «Ordinær frist» og 01.07.2027 kl. 23:59 i «Ettersendingsfrist». <br>2. Lagre, og åpne opptaket igjen. | Fristene står slik du la dem inn | | |
| 3.14 | `@OPT-OVO-FRI-001` Sette frist for endring av utdanningsbakgrunn | 1. Under kortet «Saksbehandlertildeling»: skriv 01.05.2027 kl. 23:59 i «Endre utdanningsbakgrunn». <br>2. Lagre, og åpne opptaket igjen. | Fristen står slik du la den inn | | |
| 3.15 | `@OPT-OVO-FRI-001` Sette dato for når hovedopptaket publiseres og søker kan forvente svar | 1. Under kortet «Hovedopptak»: skriv 15.07.2027 i «Publiseringsdato». La «Svarfrist» stå tomt. <br>2. Lagre, og åpne opptaket igjen. | Publiseringsdatoen er 15.07.2027 | | |
| 3.16 | `@OPT-OVO-FRI-001` Standarddato når datoen ikke er satt | 1. Se på datoen for aldersberegning [Sjekk begrep: feltet og hvor det står]. Du har ikke satt den. | Datoen for aldersberegning er 31.12.2027, fordi hovedopptaket publiseres i 2027 | | |
| 3.17 | `@OPT-OVO-FRI-001` Sette dato for aldersberegning | 1. Skriv 30.06.2027 i datoen for aldersberegning. <br>2. Lagre, og åpne opptaket igjen. | Datoen for aldersberegning er 30.06.2027 | | |
| 3.18 | `@OPT-OVO-FRI-001` Legge til utdanningsbakgrunn med avvikende frister | 1. Under «Utdanningsbakgrunner med avvikende frister»: velg «Legg til ny utdanningsbakgrunn», og velg «Realkompetanse». <br>2. Skriv 01.03.2027 kl. 23:59 i «Søknadsfrist» og i «Frist dokumentasjon» på kortet «Realkompetanse». <br>3. Lagre, og åpne opptaket igjen. | Kortet «Realkompetanse» står under «Utdanningsbakgrunner med avvikende frister», med søknadsfrist og dokumentasjonsfrist 01.03.2027 kl. 23:59 | | |

### Del 4: Som deltakende lærested

**Logg inn som:** Opptaksforvalter ved deltakende organisasjon (Ansvarsfull Fotkrem, NTNU)
**Forutsetter:** Opptaket fra 1.2 med innstillingene og fristene fra del 3, og redigering av utdanningstilbud er åpen (3.10)
**Tid:** ca. 10 minutter

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 4.1 | `@OPT-OVO-SAM-001` Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger | 1. Bytt rolle til Ansvarsfull Fotkrem (opptaksforvalter, NTNU). <br>2. Gå til <https://test-fsadmin.sikt.no/opptak>, og åpne «Samordna opptak 2027 – test 2». <br>3. Se gjennom «Innstillinger for opptaket», «Generelle frister» og «Utdanningsbakgrunner med avvikende frister». <br>4. Prøv å endre «Ordinær søknadsfrist» og «Velg regelverksamling knyttet til opptaket». | Du ser alle innstillingene og fristene fra del 3, med de samme verdiene. Du kan ikke endre noen av dem | | |
| 4.2 | `@OPT-OVO-SAM-001` Legge til lærested i samordna opptak | 1. Knytt utdanningstilbudet [Fylles ut: navn på NTNU-tilbudet] til opptaket [Sjekk begrep: hvor og hvordan]. <br>2. Gå ut av opptaket, og åpne det igjen. | Utdanningstilbudet står i opptaket | | |

### Del 5: Som lærested som ikke deltar

**Logg inn som:** Opptaksforvalter ved en organisasjon som ikke deltar (Talefør Elv, Fagskolen Vestfold og Telemark)
**Forutsetter:** Adressen til opptaket fra 1.2, steg 11
**Tid:** ca. 5 minutter

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 5.1 | `@OPT-OVO-SAM-001` Organisasjon som ikke deltar, ser ikke opptaket | 1. Bytt rolle til Talefør Elv (opptaksforvalter, Fagskolen Vestfold og Telemark). <br>2. Gå til <https://test-fsadmin.sikt.no/opptak>. | «Samordna opptak 2027 – test 2» står ikke i opptakslista | | |
| 5.2 | `@OPT-OVO-SAM-001` Organisasjon som ikke deltar, kan ikke åpne opptaket | 1. Lim inn adressen du kopierte i 1.2, steg 11, i adressefeltet i nettleseren, og gå dit. | Du ser ikke opptaket, verken innstillingene, fristene eller utdanningstilbudene. Siden sier at du ikke har tilgang, eller at opptaket ikke finnes | | |

### Del 6: Endringer etter at lærestedet har knyttet til utdanningstilbud

**Logg inn som:** Opptaksforvalter ved forvaltende organisasjon (Ordentlig Rundskriv, HK-dir)
**Forutsetter:** NTNU har knyttet et utdanningstilbud med regler fra «UHG 2027» til opptaket (4.2)
**Tid:** ca. 10 minutter

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 6.1 | `@OPT-OVO-SAM-001` Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket | 1. Bytt rolle til Ordentlig Rundskriv (opptaksforvalter, HK-dir). <br>2. Åpne «Samordna opptak 2027 – test 2». <br>3. Fjern «NTNU» under «Samordnede organisasjoner» med krysset på kortet, og lagre. <br>4. Åpne opptaket igjen. | NTNU blir ikke fjernet. Du får beskjed om at utdanningstilbudene til NTNU må fjernes først. NTNU står fortsatt under «Samordnede organisasjoner» | | |
| 6.2 | `@OPT-OVO-INN-001` Varsel før regelverkssamlingen byttes | 1. Velg «UHG 2027 v2» i «Velg regelverksamling knyttet til opptaket», og lagre. <br>2. Les varselet. <br>3. Avbryt endringen. <br>4. Åpne opptaket igjen. | I steg 2 ser du et varsel om at utdanningstilbudene som bruker regler fra «UHG 2027», mister alle reglene. Etter steg 4 er regelverkssamlingen fortsatt «UHG 2027» | | |
| 6.3 | `@OPT-OVO-INN-001` Bytte regelverkssamling når utdanningstilbud er knyttet til opptaket | 1. Velg «UHG 2027 v2» i «Velg regelverksamling knyttet til opptaket», og lagre. <br>2. Bekreft endringen i varselet. <br>3. Åpne opptaket igjen. | Regelverkssamlingen er «UHG 2027 v2» | | |

### Del 7: Lokalt opptak

**Logg inn som:** Opptaksforvalter ved et lærested med lokalt opptak (Ru Brødskive, HVL)
**Forutsetter:** Regelverkssamlingen «Lokalt regelverk» finnes
**Tid:** ca. 10 minutter

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 7.1 | `@OPT-OVO-GRU-001` Opprette et lokalt opptak | 1. Bytt rolle til Ru Brødskive (opptaksforvalter, HVL). <br>2. Gå til <https://test-fsadmin.sikt.no/opptak>, og velg «Opprett opptak» [Sjekk begrep]. <br>3. Velg at opptaket skal være lokalt [Sjekk begrep]. <br>4. Skriv «Lokalt opptak høst 2027 – test 2» i «Opptaksnavn (Bokmål)» og «Opptaksnavn (Nynorsk)», og «Local admission autumn 2027 – test 2» i «Opptaksnavn (Engelsk)». <br>5. Velg «UHG» i «Velg opptakstype» og «Lokalt regelverk» i «Velg regelverksamling knyttet til opptaket». <br>6. Velg bare «Norsk videregående skole (inkluderer 23/5-regelen, forkurs og fagskole)» i «Godkjente utdanningsbakgrunner». <br>7. Skriv 5 i «Antall søknadsalternativer», la taket stå på 1, og velg «Loddtrekning» i «Poenglikhetsregel». <br>8. Ikke fyll ut noen frister. <br>9. Lagre, gå til opptakslista, og åpne opptaket igjen. | Opptaket er lagret og står i opptakslista. HVL forvalter opptaket. Navnene og innstillingene står slik du la dem inn | | |
| 7.2 | `@OPT-OVO-INN-001` Den siste utdanningsbakgrunnen kan ikke fjernes | 1. Fjern «Norsk videregående skole (inkluderer 23/5-regelen, forkurs og fagskole)» i «Godkjente utdanningsbakgrunner» med krysset. <br>2. Lagre. <br>3. Åpne opptaket igjen. | Utdanningsbakgrunnen blir ikke fjernet, og du ser at opptaket må ha minst én utdanningsbakgrunn. Etter steg 3 står den der fortsatt | | |

## Bestått i runde 1

Disse ble bestått i runde 1 (19.10.2026), og er ikke endret i kravene etter det. De testes ikke på nytt.

| Scenario | Nr. i runde 1 |
|---|---|
| Lagre opptak uten navn, uten regelverkssamling og uten opptakstype | 1.3–1.5 |
| Angi opptaksnavn på flere språk | 1.6 |
| Navn mangler på et obligatorisk språk | 1.8–1.10 |
| Organisasjon som ikke deltar kan ikke legge til utdanningstilbud, og ser ikke opptaket i lista | 2.2 |
| Lokalt opptak tillater ikke andre organisasjoner | 2.5 |
| Legge til organisasjon som finnes i utdanningsregisteret, og ikke en som ikke finnes | 2.6–2.7 |
| Filtrere på universiteter og høyskoler, og på fagskoler | 2.8–2.9 |
| Sette regler for saksbehandlertildeling, og saksbehandlertildeling er ikke relevant for lokale opptak | 2.10–2.11 |
| Standard poenglikhetsregel med og uten mulighet for unntak | 3.4–3.5 |
| Sette maks antall søknadsalternativer | 3.7 |
| Legge til, legge til flere og fjerne utdanningsbakgrunner, og en som søkere har valgt, kan ikke fjernes | 3.12–3.14, 3.18 |

## Ikke testbart nå

[Fylles ut av teamet før testen.] Scenarioer i testen som ikke er i miljøet (sjekkliste 4.4), flyttes hit med grunn og når de kan testes.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| | | |

## Ikke med i denne testen

| Scenario | Begrunnelse |
|---|---|
| Hva søkerne ser og kan gjøre (fristene i søknaden, tidlig opptak, dokumentasjonsopplasting, startnummeret, maks søknadsalternativer, ledige studieplasser) | Virkningen står nå i kravene i 13 Søknad og saksbehandling, og testes der. Reglene er `@draft`, uten oppgave ennå (#754, «Uløst arbeid») |
| Hva fristene gjør for utdanningstilbudene (redigering, trekking, antall studieplasser, poenggrenser) | Står i 12 Utdanningstilbud, og testes der |
| Hva fristen for endring av utdanningsbakgrunn gjør i saksbehandlertildelingen | Står i `tildele_saksbehandlende_organisasjon.feature` (Puff) |
| Sette første svarfrist som informasjon til søkere | `@openquestion` (Q19): er første svarfrist svarfristen på hovedrunden, eller en egen dato på opptaket? |
| Gjenbruke innstillinger fra et tidligere opptak | `@draft @openquestion` i `opprett_opptak.feature` |
| Deaktivere opptak | `@draft @openquestion` i `opprett_opptak.feature` |
| Krav om studierett for å søke | `@draft` i `innstillinger.feature`, ikke relevant for samordna opptak |
| Hendelseslogg, fellestekster og svarmeldingsmal | `@draft`, utsatt (se scope-fila) |

## Funn

| # | Testtilfelle | Hva gjorde du | Hva forventet du | Hva skjedde | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

Alvorlighetsgrad: **Stopper** (kritisk feil, stopper systemet eller har alvorlige konsekvenser), **Må fikses før innføring** (vesentlig feil, men det finnes en midlertidig løsning) eller **Kan fikses senere** (mindre feil, skrivefeil, visuelle avvik, forbedringer til backlog).

## Andre funn og erfaringer

Det du oppdager som ikke gjelder kravene, f.eks. brukervennlighet. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et scenario, skriv det her.

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
