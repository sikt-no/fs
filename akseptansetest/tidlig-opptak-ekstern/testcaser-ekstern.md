# Ekstern akseptansetest – Tidlig opptak og tilbudsgaranti

- **Nivå**: ekstern (fase 4)
- **Testplan**: ingen felles testplan. Testen samler tre leveranser, hver med sin interne test:
  - Søke om tidlig opptak: [akseptansetesting.md](../soke-om-tidlig-opptak/akseptansetesting.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5144772613 (én side, gammelt mønster)
  - Saksbehandling av tidlig opptak: [testplan.md](../saksbehandling-tidlig-opptak/testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786
  - Tilbudsgaranti i saksbehandlingen 2027: `akseptansetest/tilbudsgaranti-2027/` på branchen `akseptansetest/tilbudsgaranti-2027` (PR #787, ikke merget) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130158105
- **Scope**: @scope-tidlig-opptak, @scope-tilbudsgaranti-2027
- **Krav**: 4 feature-filer, commit `990afe3f` (2026-11-03): `@OPT-SØK-SØK-011`, `@OPT-BEH-BEH-009`, `@OPT-BEH-BEH-013`, `@OPT-BEH-BEH-010`
- **Flyter**: ingen. Flyten for tidlig opptak er ikke skrevet (åpent spørsmål i `@FLY-OPT-OPT-001`). Rekkefølgen er arbeidsprosessen, valgt av Jens Thomassen 2026-11-03: søkeren søker, søker om tidlig opptak, saksbehandler konkluderer, tilbudsgaranti settes, søkeren endrer søknaden
- **Bygger på**: de interne testene over. Testrapporter: [saksbehandling, intern](../saksbehandling-tidlig-opptak/testrapport-intern-2026-10-30.md): venter på beslutning (forslag: godkjent). Søke om tidlig opptak: beslutning ikke ført, 2.4b kjøres på nytt etter rettingen (TOT-2556). Tilbudsgaranti: godkjent 2026-10-28 (muntlig), ingen testrapport. Ingen agentisk funksjonstest (fase 2) for noen av dem
- **Flytbeskrivelser og krav**: [flytbeskrivelser-ekstern.md](flytbeskrivelser-ekstern.md)
- **Gjennomgang av kravene**: [Fylles ut: møte <dato> eller skriftlig, sendt <dato>]
- **Testere**: [Fylles ut]
- **Kontaktperson**: Tina Lund Ravndal
- **Hvem beslutter**: [Fylles ut: hvem beslutter, avtales med partene før testen]
- **Testmiljøet**: [Fylles ut: nullstilles ikke i testperioden <fra–til>, avtalt med drift]
- **Ordene fra skjermen**: fra de interne testene (Min kompetanse og fs-admin, oktober 2026). «Legg til studieønsker» er avgrenset til opptaket til søknaden (min-kompetanse `src/app/[locale]/soknader/[soknadId]/studies/page.tsx`), «Finn studier» viser ikke opptaket
- **Testdata som må lages før testen**:

  | Testdata | Tilstand | Brukes i | Lages av | Laget |
  |---|---|---|---|---|
  | Søkerne i «Søkere til testerne» | Kan velges i «Velg testsøker», har ingen søknad og ingen studieønsker i opptak 34 (sjekket 2026-11-03, spørringen står under). Én søker per tester | 0a | Kontaktpersonen deler ut | |
  | Opptak 34 «Samordna UHG-simulering høsten 2026» | Tidlig opptak slått på, lenke til informasjon, søknadsfrist for tidlig opptak 6.10.2027, ordinær frist 13.10.2027. Minst ett grunnlag for tidlig opptak aktivt | 0–4 | Finnes | |
  | Studietilbudene i opptak 34 | «Automasjon, ingeniør - bachelor (ordinær, y-vei)» (UiT, Tromsø, tilbyr tidlig opptak), «Elektronisk systemingeniør - bachelor i ingeniørfag» (NTNU, Trondheim i Min kompetanse og Gløshaugen i FS Admin, tilbyr tidlig opptak), «Bachelor i ingeniørfag, allmenn maskinteknikk» (HVL, Bergen, tilbyr ikke) | 0a, 0b | Finnes | |
  | Konklusjonene for tidlig opptak i opptak 34 | «Kan få tidligopptak, har godkjent grunn.» finnes | 2c | Finnes | |
  | Tilbudsgarantitypene i opptak 34 | «Tilbudsgaranti etter ny vurdering» (saksbehandler) og «Tilbudsgaranti, forhåndsløfte» (opptaksforvalter) | 3a, 3b | Lagt inn for testen av tilbudsgaranti (`oppsett/for-testen-1-kopier-tilbudsgarantityper.sql` på PR #787). Legges inn igjen hvis databasen nullstilles | |
  | Testbruker 2: saksbehandler ved UiT | «KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)». Saken havner hos UiT når «Automasjon …» er førsteprioritet (sett i generalprøven 2026-11-03) | 2, 3a, 4b | Finnes | |
  | Testbruker 3: opptaksforvalter ved HK-dir | «ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)». Raden med OPPTAK_FORVALTER_OG_OPPTAK_SAKSBEHANDLER finnes ikke i TEST (2026-11-03) | 3b | Finnes | |
  | Opptak 108 «Nord Test» | Fem treff på «Automasjon, ingeniør …» har søknadsfrist «11. november» (2026). Etter fristen er treffet i opptak 34 det eneste | 0a | Finnes | |

- **Klar til test** (krysses av av kontaktpersonen):
  - [ ] Leveransen er godkjent internt og lagt ut i testmiljøet (alle tre: søke om tidlig opptak, saksbehandling og tilbudsgaranti)
  - [ ] Kravene er gått gjennom med partene
  - [ ] Testbeskrivelsen er klar
  - [ ] Testdataene er laget, og testmiljøet nullstilles ikke i testperioden
  - [ ] Hvem som beslutter, er avtalt med partene
  - [ ] Kontaktpersonen har logget inn som hver testbruker og ser testdataene
  - [ ] Kontaktpersonen har kjørt punkt 0 med én søker, og sett at saken havner hos UiT og vises for testbruker 2
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5166825479 (publisert 2026-11-03, under Testplaner; v4: endringer fra Jens Thomassens gjennomkjøring 2026-11-04, v5: rettet etter kommentarene)
- **Laget**: 2026-11-03 av fs-testcaser-ekstern
- **Generalprøve**: [kjoring-2026-11-03-1442/resultat.md](kjoring-2026-11-03-1442/resultat.md) (agent, søker ØKOLOGISK BADERING). Stegene er rettet etter den samme dag
- **Sporing**:

  | Nr | Steg | Feature-ID | Scenario | Intern |
  |---|---|---|---|---|
  | 0 | a, b | – | Testdata: søkeren søker på studiene (ingen krav i testen) | – |
  | 1 | a | `@OPT-SØK-SØK-011` | Søke om tidlig opptak fra søknadsdetaljene; Se informasjon om tidlig opptak i opptaket; Se hvilke søknadsalternativer som tilbyr tidlig opptak | 1.1, 2.1, 2.2 |
  | 1 | b | `@OPT-SØK-SØK-011` | Søke om tidlig opptak med en begrunnelse | 2.4a |
  | 1 | c | `@OPT-SØK-SØK-011` | Kvitteringen viser søknadsalternativene som tilbyr tidlig opptak | 2.4b |
  | 2 | a | `@OPT-BEH-BEH-009` | Filtrere på tidlig opptak (konklusjonen mangler) | 2.1, 2.2 |
  | 2 | b | `@OPT-BEH-BEH-013` | Se søkerens begrunnelse for tidlig opptak; Se dokumentasjonskrav for begrunnelsen | 1.1, 1.2 |
  | 2 | c | `@OPT-BEH-BEH-013` | Konkludere om søkeren deltar i tidligopptaket (deltar) | 1.4a |
  | 2 | d | `@OPT-BEH-BEH-009` | Filtrere på tidlig opptak (konklusjonen mangler, og søkeren har søkt) | 2.1, 2.2 |
  | 3 | a | `@OPT-BEH-BEH-010` | Sette tilbudsgaranti i feltet for rollen (saksbehandler) | 1.1a |
  | 3 | b | `@OPT-BEH-BEH-010` | Sette tilbudsgaranti i feltet for rollen (opptaksforvalter); Se tilbudsgarantiene fra alle rollene | 1.1c |
  | 4 | a | `@OPT-SØK-SØK-011` | Søknaden om tidlig opptak blir stående når søknadsalternativene endres | 5.1 |
  | 4 | b | `@OPT-BEH-BEH-010` | Tilbudsgarantien følger søknadsalternativet når prioriteten endres (flytter til prioritet 3) | 1.14a |

  Interne nummer: 1 = søke om tidlig opptak, 2 = saksbehandling (for 2a–2d), 3–4 = tilbudsgaranti (for 3a–4b).

- **Ikke testbart nå** (fra kravene, med kilden):
  - `@OPT-BEH-BEH-010` «Endringer i tilbudsgarantien kan spores»: endringsloggen i opptak er fjernet (2026-10-30). Kravet er ikke endret.
  - `@OPT-BEH-BEH-007` (tilbudsgaranti fra gjennomføringen av tidligopptaket): `@in-progress`, ikke levert i fs-admin (MR !3226).
  - Tilbyderen setter tilbudsgaranti: tilbyderen ser bare saken når tilbyderen er ved lærestedet som behandler saken (STEK-576). Saken ligger hos UiT, og vi har bare tilbyder som testbruker ved NTNU.
  - `@OPT-BEH-BEH-013` «Konklusjon per organisasjon»: krever to saker. Valgt bort 2026-11-03 (én sak og én konklusjon).

- **Spørringen for søkerne** (2026-11-03, scratchpad, ikke tatt vare på): personer blant de første 999 i `tilgangskontroll.person` (det «Velg testsøker» viser), med fødselsnummer, uten søknad og uten studieønsker i opptak 34, og uten søkerne fra de interne testene. 40 treff. Tatt ut: Kari Nilsen (fødselsnummer som ser ekte ut) og navn som ligner ekte personer.

---

Velkommen til akseptansetesten av tidlig opptak og tilbudsgaranti. I testen sjekker du om du kan gjøre jobben din i flytene løsningen skal understøtte: at hvert steg virker, og at stegene henger sammen. Les [Informasjonsskriv til eksterne testere](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155815432) før du starter. Hva løsningen skal gjøre, står i [Flytbeskrivelser til partene – Tilbudsgaranti / Tidlig opptak 2026-11-05](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5165383733).

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Søkeren kan søke om tidlig opptak i Min kompetanse etter at søknaden er sendt, med ett grunnlag, og får kvittering. Saksbehandleren finner søknadene om tidlig opptak i FS Admin, ser søkerens grunnlag og hva som må dokumenteres, og setter en konklusjon. Saksbehandler, tilbyder og opptaksforvalter kan gi søkeren tilbudsgaranti på et studieønske, og tilbudsgarantien følger studieønsket når søkeren endrer rekkefølgen. |
| Versjon | Slik testmiljøet er 5. november 2026 |
| Flytene som testes | - Fra søknad til søknad om tidlig opptak (søkeren) <br>- Fra søknad om tidlig opptak til konklusjon (saksbehandleren) <br>- Manuelle tilbudsgarantier (saksbehandleren og opptaksforvalteren) <br>- Søkeren endrer søknaden etterpå |
| Hvor du tester | Min kompetanse: [https://test.minkompetanse.no/](https://test.minkompetanse.no/) · FS Admin: [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/) |
| Feature-flagg som er slått på | Tidlig opptak i Min kompetanse (slått på for testen) |
| Testbrukere og roller | - Testbruker 1: søkeren du får fra kontaktpersonen (se «Søkere til testerne»), søker i Min kompetanse <br>- Testbruker 2: KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT), i FS Admin <br>- Testbruker 3: ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR), i FS Admin |
| Testdata | - Opptaket «Samordna UHG-simulering høsten 2026», med tidlig opptak. Søknadsfristen for tidlig opptak er 6.10.2027 <br>- Tre studier i opptaket: «Automasjon, ingeniør - bachelor (ordinær, y-vei)» ved UiT og «Elektronisk systemingeniør - bachelor i ingeniørfag» ved NTNU tilbyr tidlig opptak. «Bachelor i ingeniørfag, allmenn maskinteknikk» ved HVL gjør det ikke <br>- Søkeren din har ingen søknad i opptaket når du starter. Du lager søknaden selv i testcase 0, og resten av testen bruker den. Søknaden behandles av UiT |
| Avhengigheter | Ingen |
| Dette kan du ikke gjøre i testen | - Gjennomføre tidligopptaket, så søkerne får tilbudsgaranti fra tidligopptaket. Det kommer senere, og tilbudsgarantien settes for hånd i testen <br>- Se hvem som har satt eller fjernet en tilbudsgaranti. Knappen «Endringslogg» i saken viser «Ingen endringer» inntil videre <br>- Sette tilbudsgaranti som tilbyder når saken behandles av et annet lærested. Det er en kjent mangel som rettes <br>- Trekke søknaden om tidlig opptak. Det finnes ikke i løsningen, så hver tester har sin egen søker |
| Tid | Ca. 60 minutter. |
| Kontaktperson | Tina Lund Ravndal. Spørsmål underveis tas på [Fylles ut: hvordan spørsmål tas, avtales med testerne] |
| Hvem beslutter | [Fylles ut: hvem beslutter, avtales med partene før testen] |

Mangler en testbruker eller testdata, si fra til kontaktpersonen før du starter.

### Søkere til testerne

Hver tester bruker sin egen søker, så dere ikke forstyrrer hverandre. Søknaden om tidlig opptak kan ikke trekkes, så en søker kan bare brukes én gang. Kontaktpersonen fyller ut hvem som har hvilken søker.

| Søker | Fødselsnummer | Brukt av |
|---|---|---|
| ØKOLOGISK BADERING | 22820998719 | Agentisk testing 2026-11-03 |
| GRETTEN PEDAL | 15841298656 | SIKT internt 2026-11-04 |
| TRIST RYGG | 21921199411 | [Fylles ut] |
| FORMBAR JUICE | 16870999619 | [Fylles ut] |
| TRU KJETTING | 04811199368 | [Fylles ut] |
| UROMANTISK PLASMA | 21891499547 | [Fylles ut] |
| UFORNUFTIG GRAF | 04919097138 | [Fylles ut] |
| AKUSTISK ELG | 17880999990 | [Fylles ut] |
| VOKAL ADRESSAT | 23908596919 | [Fylles ut] |
| OVEREKSPONERT STOKK | 04901298462 | [Fylles ut] |
| FIKTIV MOTVIND | 03911098481 | [Fylles ut] |
| UVITENDE BJØRNUNGE | 25811398082 | [Fylles ut] |
| MUNTER JORDBÆR | 12811398266 | [Fylles ut] |
| RØD NATTERGAL | 03840998958 | [Fylles ut] |

### Slik bytter du testbruker

- **Min kompetanse:** gå til forsiden, åpne «Meny» øverst til høyre, og velg søkeren din under «Velg testsøker». Viser siden «404 - Siden finnes ikke» etter byttet, velg «Til forsiden». [Fylles ut: hvordan testerne logger inn i Min kompetanse]
- **FS Admin:** skriv navnet i feltet i den gule linja øverst, og velg raden for testbrukeren: «KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)» for testbruker 2, og «ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)» for testbruker 3. Last så inn siden på nytt (F5, eller Cmd+R på Mac). Uten det kan FS Admin oppføre seg rart etter byttet, på grunn av en kjent feil som ikke er en del av testen.

## Slik fyller du ut

1. Følg hver flyt steg for steg, slik du ville gjort det i arbeidet. Gå videre til neste steg først når det forrige virker.
2. Svar på om steget fungerte som forventet: **Ja**, **Nei** eller **Delvis**. Sjekk at endringen er lagret, at den står der når du åpner saken igjen, og at neste steg bruker det du registrerte.
3. Virker ikke et steg, eller lar flyten deg ikke gjøre jobben, er det et funn. Prøv deg fram på en annen måte bare hvis det er nødvendig for å komme videre, og skriv ned hva du gjorde. Kom du ikke fram til et steg, la svaret stå tomt, og skriv hvorfor.
4. Ved Nei eller Delvis: skriv i «Funn» hva du gjorde, hva du forventet og hva du fikk, så en annen kan gjøre det samme og se det samme. Ta skjermbilde hvis du kan, og gi funnet en alvorlighetsgrad. Velg «Feil» når flyten ikke lar deg gjøre jobben, eller løsningen avviker fra det Sikt har informert om, og «Endringsforslag» når flyten ikke dekker et behov du har. Du trenger ikke finne årsaken. Er du usikker på om noe er feil, beskriv det, og la kontaktpersonen vurdere det.
5. Ser du andre ting underveis, for eksempel om brukervennlighet, skriv dem i «Andre funn», merket som utenfor testens omfang.
6. «Status» fylles ut av kontaktpersonen.

## Testcaser

Testcasene bygger på hverandre: alle bruker søknaden du lager i testcase 0. Ta dem i rekkefølge.

### 0. Søk på studier i opptaket (ca. 15 minutter)

**Hensikt:** lage søknaden resten av testen bruker. Søknaden har to studier som tilbyr tidlig opptak, ved to læresteder, og ett som ikke gjør det.

**Testdata:** testbruker 1 (søkeren du har fått, søker). Finnes fra før: opptaket «Samordna UHG-simulering høsten 2026» og de tre studiene. Lager: en sendt søknad med «Automasjon, ingeniør …» som førsteprioritet, «Elektronisk systemingeniør …» som andre og «Bachelor i ingeniørfag, allmenn maskinteknikk» som tredje.

| Steg | Hva du gjør | Slik gjør du det | Forventet resultat | Fungerte det? (Ja / Nei / Delvis) | Hva du gjorde og så | Status |
|---|---|---|---|---|---|---|
| 0a | Søk på det første studiet, og send søknaden | 1. Gå til [https://test.minkompetanse.no/](https://test.minkompetanse.no/), og velg søkeren din under «Meny» og «Velg testsøker» (testbruker 1, søker). <br>2. Velg «Finn studier», og skriv inn «Automasjon, ingeniør». <br>3. Velg «Legg til» på «Automasjon, ingeniør - bachelor (ordinær, y-vei)» ved UIT, Tromsø, med søknadsfrist «13. oktober 2027». Treff med en annen søknadsfrist hører til andre opptak. <br>4. Velg «Til studiekurv». <br>5. Velg «Start søknad», og gå gjennom «Prioritering», «Dokumentasjon» og «Oppsummering». <br>6. Velg «Send søknad». <br>7. Skriv ned søknadsnummeret i kvitteringen («Søknadsnummer»). Du trenger det i testcase 2–4. <br>8. Velg «Gå til min oversikt». | Kvitteringen viser «Søknaden er sendt inn», med søknadsnummeret. Under «Aktive søknader» i oversikten står «Søknad til Samordna UHG-simulering høsten 2026», med «Søknaden er innsendt» | | | |
| 0b | Legg til to studier til | 9. Velg «Til søknad» under «Søknad til Samordna UHG-simulering høsten 2026». <br>10. Velg «Legg til studieønsker». Lista viser bare studiene i opptaket. <br>11. Skriv «Elektronisk systemingeniør» i søkefeltet, og velg «Legg til» på «Elektronisk systemingeniør - bachelor i ingeniørfag» ved NTNU, Trondheim. <br>12. Skriv «allmenn maskinteknikk» i søkefeltet, og velg «Legg til» på «Bachelor i ingeniørfag, allmenn maskinteknikk» ved HVL, Bergen. <br>13. Velg «Prioritering». Står studiene i en annen rekkefølge enn i forventet resultat, flytt dem med pilene. <br>14. Velg «Dokumentasjon», «Oppsummering» og «Lagre endringer». | Søknaden vises igjen, med tre studieønsker: 1. «Automasjon, ingeniør …», 2. «Elektronisk systemingeniør …», 3. «Bachelor i ingeniørfag, allmenn maskinteknikk». Boksen «Tidlig opptak» står i søknaden, med «Søk om tidlig opptak» | | | |

### 1. Søk om tidlig opptak (ca. 10 minutter)

**Hensikt:** søkeren ber om tidlig opptak med et grunnlag, og får vite hvilke studier søknaden gjelder. Det er det saksbehandleren vurderer i testcase 2.

**Testdata:** testbruker 1 (søkeren din). Finnes fra før: søknaden fra testcase 0. Lager: søknaden om tidlig opptak, som testcase 2 behandler.

| Steg | Hva du gjør | Slik gjør du det | Forventet resultat | Fungerte det? (Ja / Nei / Delvis) | Hva du gjorde og så | Status |
|---|---|---|---|---|---|---|
| 1a | Les om tidlig opptak, og se hvilke studier som tilbyr det | 1. Fortsett som testbruker 1, i «Søknad til Samordna UHG-simulering høsten 2026». <br>2. Velg «Les mer om tidlig opptak og hvilken dokumentasjon som kreves» i boksen «Tidlig opptak», og les siden. Gå tilbake til søknaden. <br>3. Velg «Søk om tidlig opptak». <br>4. Åpne «Hvem kan søke tidlig opptak?». | Lenken åpner informasjonssiden om tidlig opptak. Boksen «Obs! Disse studieønskene tilbyr ikke tidlig opptak.» viser «Bachelor i ingeniørfag, allmenn maskinteknikk», og ingen andre. «Hvem kan søke tidlig opptak?» forklarer hva som må dokumenteres for hvert grunnlag | | | |
| 1b | Søk om tidlig opptak med et grunnlag | 5. Velg «Jeg er i jobb og har oppsigelsestid, eller må søke permisjon» under «Velg et grunnlag for tidlig opptak». <br>6. Velg «Send søknad». | Søknaden vises igjen, med «Du har søkt om tidlig opptak.» og en påminnelse om dokumentasjonen for grunnlaget. «Søk om tidlig opptak» er borte | | | |
| 1c | Se kvitteringen | 7. Velg «Meny» og «Mine meldinger», og åpne den nyeste meldingen, «Du har søkt om tidlig opptak». | Under «Du har søkt tidlig opptak til følgende studier:» står «Automasjon, ingeniør …» og «Elektronisk systemingeniør …», men ikke «Bachelor i ingeniørfag, allmenn maskinteknikk» | | | |

### 2. Behandle søknaden om tidlig opptak (ca. 10 minutter)

**Hensikt:** saksbehandleren finner søknadene som venter på vurdering, vurderer grunnlaget og setter en konklusjon, så det er tydelig hvilke saker som er ferdige.

**Testdata:** testbruker 2 (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)). Finnes fra før: søknaden om tidlig opptak fra testcase 1. Lager: konklusjonen på saken.

| Steg | Hva du gjør | Slik gjør du det | Forventet resultat | Fungerte det? (Ja / Nei / Delvis) | Hva du gjorde og så | Status |
|---|---|---|---|---|---|---|
| 2a | Finn søknadene som mangler konklusjon | 1. Gå til [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/), og velg testbruker 2 (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)), som i «Slik bytter du testbruker». <br>2. Velg «Opptak», skriv «Samordna UHG-simulering» i «Opptaksnavn», og åpne «Samordna UHG-simulering høsten 2026» med pila. <br>3. Velg «Gå til søknader» under «Søknader». <br>4. Åpne «Tidlig opptak» nederst i filtrene, og kryss av for «Mangler konklusjon på tidlig opptak». | Lista viser bare søknadene som mangler konklusjon på tidlig opptak. Søknaden din står der, med «Ikke behandlet» | | | |
| 2b | Se grunnlaget og hva som må dokumenteres | 5. Åpne saken med pila. Er det flere saker i lista, åpne den med søknadsnummeret fra 0a. | Saken åpner på «1. Tidlig opptak». Under «Begrunnelse fra søker» står «Jeg er i jobb og har oppsigelsestid, eller må søke permisjon». Under «Dokumentasjonskrav» står hva søkeren må dokumentere for grunnlaget | | | |
| 2c | Sett konklusjon | 6. Velg «Kan få tidligopptak, har godkjent grunn.» i «Konklusjon». <br>7. Velg «Saker» i stien øverst. Filtrene er nullstilt, så skriv søknadsnummeret fra 0a i «Søknadsnummer». Ofte holder det med en del av nummeret, for eksempel de fire siste sifrene. <br>8. Åpne saken med pila. | Meldingen «Konklusjonen er lagret» vises etter steg 6. Når saken åpnes igjen, står «Kan få tidligopptak, har godkjent grunn.» i «Konklusjon» | | | |
| 2d | Se at saken er ferdig vurdert | 9. Velg «Saker» i stien øverst. Skriv søknadsnummeret i «Søknadsnummer», og kryss av for «Mangler konklusjon på tidlig opptak» under «Tidlig opptak». <br>10. Fjern krysset, og kryss av for «Har søkt tidlig opptak». | Med «Mangler konklusjon på tidlig opptak» viser lista «Ingen resultater». Med «Har søkt tidlig opptak» står søknaden i lista | | | |

### 3. Gi tilbudsgaranti (ca. 10 minutter)

**Hensikt:** saksbehandleren og opptaksforvalteren gir søkeren tilbudsgaranti på et studieønske, hver i sitt felt, og ser hverandres tilbudsgaranti.

**Testdata:** testbruker 2 (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)) og testbruker 3 (ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)). Finnes fra før: saken fra testcase 2. Lager: to tilbudsgarantier på «Elektronisk systemingeniør …», som testcase 4 bruker.

| Steg | Hva du gjør | Slik gjør du det | Forventet resultat | Fungerte det? (Ja / Nei / Delvis) | Hva du gjorde og så | Status |
|---|---|---|---|---|---|---|
| 3a | Gi tilbudsgaranti som saksbehandler | 1. Fortsett som testbruker 2, og åpne saken med pila i lista fra 2d. <br>2. Velg «Søknadsalternativer» til høyre, og åpne «Elektronisk systemingeniør - bachelor i ingeniørfag» med pila. <br>3. Velg «Tilbudsgaranti etter ny vurdering» i «Tilbudsgaranti fra behandler». <br>4. Last inn siden på nytt (F5, eller Cmd+R på Mac), og åpne søknadsalternativet igjen. | Meldingen «Tilbudsgaranti lagret» vises etter steg 3. Når siden er lastet på nytt, viser «Tilbudsgaranti fra behandler» «Tilbudsgaranti etter ny vurdering» | | | |
| 3b | Gi tilbudsgaranti som opptaksforvalter | 5. Bytt til testbruker 3 (ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)), som i «Slik bytter du testbruker». <br>6. Gå til sakslisten som i 2a (steg 2–3), skriv søknadsnummeret fra 0a i «Søknadsnummer», og åpne saken med pila. <br>7. Velg «Søknadsalternativer» til høyre, og åpne «Elektronisk systemingeniør …» med pila. <br>8. Velg «Tilbudsgaranti, forhåndsløfte» i «Tilbudsgaranti fra forvalter». <br>9. Last inn siden på nytt, og åpne søknadsalternativet igjen. | Meldingen «Tilbudsgaranti lagret» vises etter steg 8. «Tilbudsgaranti fra forvalter» viser «Tilbudsgaranti, forhåndsløfte». «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti etter ny vurdering» fra 3a, men kan ikke endres av deg | | | |

### 4. Søkeren endrer søknaden (ca. 10 minutter)

**Hensikt:** når søkeren endrer rekkefølgen på studiene, blir søknaden om tidlig opptak og tilbudsgarantiene stående.

**Testdata:** testbruker 1 (søkeren din) og testbruker 2 (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)). Finnes fra før: søknaden om tidlig opptak fra testcase 1, og tilbudsgarantiene fra testcase 3.

| Steg | Hva du gjør | Slik gjør du det | Forventet resultat | Fungerte det? (Ja / Nei / Delvis) | Hva du gjorde og så | Status |
|---|---|---|---|---|---|---|
| 4a | Endre rekkefølgen som søker | 1. Gå til [https://test.minkompetanse.no/](https://test.minkompetanse.no/), og velg søkeren din under «Meny» og «Velg testsøker» (testbruker 1). <br>2. Velg «Meny» og «Mine søknader», og «Vis søknad» under «Samordna UHG-simulering høsten 2026». <br>3. Velg «Rediger studieønsker», og pila ned på «Elektronisk systemingeniør …». <br>4. Velg «Lagre endringer». | Søknaden vises igjen, med «Elektronisk systemingeniør …» som prioritet 3. Boksen «Tidlig opptak» viser fortsatt «Du har søkt om tidlig opptak.», med påminnelsen for det samme grunnlaget som i 1b | | | |
| 4b | Se at tilbudsgarantiene fulgte med | 5. Gå til [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/), og velg testbruker 2 (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)), som i «Slik bytter du testbruker». <br>6. Gå til sakslisten som i 2a (steg 2–3), skriv søknadsnummeret fra 0a i «Søknadsnummer», og åpne saken med pila. <br>7. Velg «Søknadsalternativer» til høyre, og åpne «Elektronisk systemingeniør …» med pila. | «Elektronisk systemingeniør …» står som nummer 3. «Tilbudsgaranti fra behandler» viser fortsatt «Tilbudsgaranti etter ny vurdering», og «Tilbudsgaranti fra forvalter» viser «Tilbudsgaranti, forhåndsløfte». «Konklusjon» viser fortsatt «Kan få tidligopptak, har godkjent grunn.» | | | |

## Testcaser fra partene

Tom ved utsendelse. Partene som har egne krav, legger inn egne testcaser her, med samme tabell og kolonner som over.

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Enkeltfunksjoner, feltvalidering og feilmeldinger | Testet tidligere, i teamets egen testing og i Sikts interne akseptansetest |
| At søkeren ikke kan søke om tidlig opptak før søknaden er sendt, etter fristen, eller når ingen studier tilbyr det | Testet i Sikts interne akseptansetest |
| Filtrene for tidlig opptak i detalj, og hvordan de virker sammen med andre filtre | Testet i Sikts interne akseptansetest |
| Endre og fjerne en tilbudsgaranti, og hvilke tilbudsgarantityper hver rolle kan velge | Testet i Sikts interne akseptansetest |
| At tilbudsgarantien faller bort når studieønsket fjernes, og gjelder igjen når det legges inn igjen | Testet i Sikts interne akseptansetest |
| Søknader som deles mellom to læresteder, med hver sin konklusjon | Testet i Sikts interne akseptansetest. Søknaden i testen behandles av ett lærested |
| Gjennomføre tidligopptaket, og svaret søkeren får på søknaden om tidlig opptak | Kommer senere |
| Se hvem som har satt eller fjernet en tilbudsgaranti | Endringsloggen er tatt ut av løsningen inntil videre |
| Roller og tilganger | Kontrollert i koden før testen |
| Universell utforming og regresjon | Gjøres på andre måter |

## Funn

| # | Testcase | Fase funnet | Funntype | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|---|---|
| | | 4. Ekstern | | | | | | | |

| Type | Betyr | Hvor følges det opp |
|---|---|---|
| Feil | Flyten lar ikke testeren gjøre jobben, eller løsningen avviker fra kravene Sikt har gått gjennom | Teamet lager oppgave («Sak») |
| Endringsforslag | Et behov flyten ikke dekker | Går til kravarbeidet, der Sikt vurderer om det skal følges opp raskt eller vente |

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig. Et endringsforslag får ikke alvorlighetsgraden «Stopper» uten at partene sier det.

## Andre funn (utenfor testens omfang)

Her skriver du det du ser som ikke er en del av flytene, for eksempel om brukervennlighet. Kontaktpersonen vurderer hvor det følges opp.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |

## Når testen er ferdig

Dere konkluderer med ett av tre utfall: **godkjent**, **godkjent med forbehold** eller **ikke godkjent**, vurdert mot flytene og kravene. Godkjent med forbehold betyr at kjente mangler listes med ansvarlig og frist. Ikke godkjent betyr at leveransen går tilbake til teamet med funnene. Kontaktpersonen går gjennom resultatet med dere.
