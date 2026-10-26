# Intern akseptansetest – Søke om tidlig opptak

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5144772613
- **Scope**: –
- **Krav**: 1 feature-fil, commit `184daa8` (2026-10-26)
- **Verifisering**: [verify-søke_om_tidlig_opptak-2026-10-26-0950.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/verify-s%C3%B8ke_om_tidlig_opptak-2026-10-26-0950.md), 9 av 9 funnet
- **Ordene fra skjermen**: min-kompetanse `2ca3bdd6` (origin/main), kvitteringen fra fs-plattform `26d0862b43`. Tittelen på kvitteringen kommer fra fs-plattform, og er ikke funnet
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5146705926
- **Laget**: 2026-10-26 av fs-testcaser-intern
- **Sporing**:

  | Nr | Feature-ID | Regel | Scenario |
  |---|---|---|---|
  | 1.1 | `@OPT-SØK-SØK-011` | Søkeren ber om tidlig opptak etter at søknaden er sendt | Søke om tidlig opptak fra søknadsdetaljene |
  | 1.2 | `@OPT-SØK-SØK-011` | Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Se hvilke søknadsalternativer som tilbyr tidlig opptak |
  | 1.3 | `@OPT-SØK-SØK-011` | Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Se informasjon om tidlig opptak i opptaket |
  | 1.4 | `@OPT-SØK-SØK-011` | Søkeren velger én begrunnelse fra opptakets liste | Se begrunnelsene søkeren kan velge |
  | 1.5 | `@OPT-SØK-SØK-011` | Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Søke om tidlig opptak med en begrunnelse |
  | 1.6 | `@OPT-SØK-SØK-011` | Søknaden om tidlig opptak gjelder hele søknaden | Søknaden om tidlig opptak blir stående når søknadsalternativene endres |
  | 1.7 | `@OPT-SØK-SØK-011` | Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det |
  | 1.8 | `@OPT-SØK-SØK-011` | Søkeren ber om tidlig opptak etter at søknaden er sendt | Kan ikke søke om tidlig opptak før søknaden er sendt |
  | 1.9 | `@OPT-SØK-SØK-011` | Tidlig opptak kan bare søkes innen søknadsfristen for tidlig opptak | Kan ikke søke om tidlig opptak etter fristen |

---

Intern akseptansetest av «Søke om tidlig opptak». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5144772613). Felt med gul bakgrunn fylles ut av teamet før testen.

## Slik tester du

- Ta testcasene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med alvorlighetsgrad. Spørsmål underveis tas i Slack-tråden «Akseptansetesting Søke om tidlig opptak».

Hele testen er i Min kompetanse, <https://test.minkompetanse.no/>, som søker.

**Slik åpner du søknaden.** De fleste testcasene starter her, og stegene viser til denne framgangsmåten som «Åpne søknaden»:

1. Velg «Meny» øverst til høyre, og «Mine søknader».
2. Åpne søknaden i opptaket [Fylles ut: opptaket fra testplanen]. Siden heter «Søknadsdetaljer». Boksen «Tidlig opptak» står under «Om søknaden».

**Slik bytter du testbruker:** Velg «Meny» øverst til høyre, og velg den nye testbrukeren under «Velg testsøker» [Sjekk begrep: om testmiljøet bytter søker slik, eller med «Logg ut» og ny innlogging].

**Søknaden om tidlig opptak kan ikke trekkes.** Når testbruker 1 har sendt i 1.5, kan det ikke gjøres om i løsningen. Kjøres testen på nytt, trengs en ny søker (se testplanen).

## Testcaser

Testcasene er ordnet etter testbruker, så du bytter søker så sjelden som mulig. Regelen i kravet står under hver scenariotittel.

### Del 1: Søke om tidlig opptak (søke_om_tidlig_opptak.feature)

#### Testbruker 1: søker med en sendt søknad, som ikke har søkt om tidlig opptak

1.5 sender søknaden om tidlig opptak, og det kan ikke gjøres om. Derfor kommer den etter de andre testcasene for testbruker 1, og før 1.6, som bygger på den.

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.1 | **Søke om tidlig opptak fra søknadsdetaljene** <br>*Regel: Søkeren ber om tidlig opptak etter at søknaden er sendt* | 1. Logg inn på <https://test.minkompetanse.no/> som testbruker 1 ([Fylles ut: navn og fødselsnummer], søker med en sendt søknad der noen studieønsker tilbyr tidlig opptak). <br>2. Åpne søknaden. <br>3. Se på boksen «Tidlig opptak». | Boksen «Tidlig opptak» står på søknadsdetaljene, med teksten om tidlig opptak og knappen «Søk om tidlig opptak». | | |
| 1.2 | **Se hvilke søknadsalternativer som tilbyr tidlig opptak** <br>*Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det* | *Før du starter: testbruker 1 har ikke søkt om tidlig opptak.* <br>1. Logg inn som testbruker 1 ([Fylles ut: navn og fødselsnummer]), hvis du ikke er logget inn. <br>2. Åpne søknaden, og velg «Søk om tidlig opptak». <br>3. Se på boksen «Obs! Disse studieønskene tilbyr ikke tidlig opptak.» <br>4. Velg «Gå tilbake» uten å sende. | Boksen viser studieønskene som ikke tilbyr tidlig opptak: [Fylles ut: studieønskene i søknaden som ikke tilbyr tidlig opptak]. Studieønskene som tilbyr tidlig opptak ([Fylles ut]), står ikke i boksen. | | |
| 1.3 | **Se informasjon om tidlig opptak i opptaket** <br>*Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det* | 1. Logg inn som testbruker 1 ([Fylles ut: navn og fødselsnummer]), hvis du ikke er logget inn. <br>2. Åpne søknaden. <br>3. Velg lenken «Les mer om tidlig opptak og hvilken dokumentasjon som kreves» i boksen «Tidlig opptak». | Lenken står i boksen, og åpner siden opptaket har satt: [Fylles ut: adressen til informasjonen om tidlig opptak i opptaket]. | | |
| 1.4 | **Se begrunnelsene søkeren kan velge** <br>*Regel: Søkeren velger én begrunnelse fra opptakets liste* | *Før du starter: testbruker 1 har ikke søkt om tidlig opptak.* <br>1. Logg inn som testbruker 1 ([Fylles ut: navn og fødselsnummer]), hvis du ikke er logget inn. <br>2. Åpne søknaden, og velg «Søk om tidlig opptak». <br>3. Åpne «Hvem kan søke tidlig opptak?». <br>4. Se på valgene under «Velg et grunnlag for tidlig opptak». <br>5. Velg «Gå tilbake» uten å sende. | Under «Hvem kan søke tidlig opptak?» står «For å søke tidlig opptak må du dokumentere minst én av disse grunnene:», med forklaringen og hva som må dokumenteres for hvert aktive grunnlag: [Fylles ut: de aktive grunnlagene i opptaket]. De samme grunnlagene kan velges under «Velg et grunnlag for tidlig opptak». «[Fylles ut: et grunnlag i opptaket som ikke er aktivt]» står ikke noen av stedene. | | |
| 1.5 | **Søke om tidlig opptak med en begrunnelse** <br>*Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det* | *Før du starter: testbruker 1 har ikke søkt om tidlig opptak.* <br>1. Logg inn som testbruker 1 ([Fylles ut: navn og fødselsnummer]), hvis du ikke er logget inn. <br>2. Åpne søknaden. <br>3. Velg «Søk om tidlig opptak» i boksen «Tidlig opptak». <br>4. Velg «[Fylles ut: et aktivt grunnlag i opptaket]» under «Velg et grunnlag for tidlig opptak». <br>5. Velg «Send søknad». <br>6. Velg «Meny» og «Mine søknader», og åpne søknaden igjen. <br>7. Velg «Meny» og «Mine meldinger», og åpne den nyeste kvitteringen. | Etter steg 6 står «Du har søkt om tidlig opptak.» i boksen «Tidlig opptak», med en påminnelse om dokumentasjonen for grunnlaget du valgte. Knappen «Søk om tidlig opptak» er borte. Etter steg 7 har kvitteringen [Sjekk begrep: tittelen, i skissen «Kvittering på søknad om tidlig opptak»], og under «Du har søkt tidlig opptak til følgende studier:» står bare studieønskene som tilbyr tidlig opptak. | | |
| 1.6 | **Søknaden om tidlig opptak blir stående når søknadsalternativene endres** <br>*Regel: Søknaden om tidlig opptak gjelder hele søknaden* | *Før du starter: testbruker 1 har søkt om tidlig opptak (fra 1.5).* <br>1. Logg inn som testbruker 1 ([Fylles ut: navn og fødselsnummer]), hvis du ikke er logget inn. <br>2. Åpne søknaden, og velg «Legg til studieønsker». <br>3. Finn [Fylles ut: et utdanningstilbud i opptaket som tilbyr tidlig opptak], og velg «Legg til». <br>4. Gå gjennom søknaden, og velg «Send søknad» [Sjekk begrep: stegene når et studieønske legges til en søknad som er sendt]. <br>5. Velg «Meny» og «Mine søknader», og åpne søknaden igjen. | Det nye studieønsket står i søknaden, og boksen «Tidlig opptak» viser fortsatt «Du har søkt om tidlig opptak.», med påminnelsen om dokumentasjonen for det samme grunnlaget som i 1.5. | | |
| | | *Gjør klar til neste test: fjern studieønsket du la til, hvis søknaden skal brukes igjen.* | | | |

#### Testbruker 2: søker der ingen studieønsker tilbyr tidlig opptak

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.7 | **Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det** <br>*Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det* | 1. Bytt testbruker, og logg inn som testbruker 2 ([Fylles ut: navn og fødselsnummer], søker med en søknad der ingen studieønsker tilbyr tidlig opptak). <br>2. Åpne søknaden. | Boksen «Tidlig opptak» og knappen «Søk om tidlig opptak» vises ikke på søknadsdetaljene. | | |

#### Testbruker 3: søker som ikke har sendt søknaden

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| 1.8 | **Kan ikke søke om tidlig opptak før søknaden er sendt** <br>*Regel: Søkeren ber om tidlig opptak etter at søknaden er sendt* | 1. Bytt testbruker, og logg inn som testbruker 3 ([Fylles ut: navn og fødselsnummer], søker som ikke har sendt søknaden ennå). <br>2. Åpne søknaden som ikke er sendt, og gå gjennom stegene i søknaden fram til «Send søknad», uten å sende. <br>3. Se etter «Tidlig opptak» og «Søk om tidlig opptak» underveis. | «Tidlig opptak» og «Søk om tidlig opptak» vises ikke noe sted før søknaden er sendt. | | |

#### Testbruker 4: søker etter fristen for tidlig opptak

Denne testcasen kjøres til slutt, fordi fristen flyttes for hele opptaket. Ingen andre bør teste i opptaket mens fristen er flyttet.

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| | | *Gjør klar til neste test: opptaksforvalteren flytter «Søknadsfrist for tidlig opptak» [Sjekk begrep] i opptaket til i går, og noterer fristen som sto der. [Fylles ut: hvem som gjør det, og hvordan]* | | | |
| 1.9 | **Kan ikke søke om tidlig opptak etter fristen** <br>*Regel: Tidlig opptak kan bare søkes innen søknadsfristen for tidlig opptak* | 1. Bytt testbruker, og logg inn som testbruker 4 ([Fylles ut: navn og fødselsnummer], søker med en sendt søknad i opptaket, der minst ett studieønske tilbyr tidlig opptak, og som ikke har søkt om tidlig opptak). <br>2. Åpne søknaden. | Boksen «Tidlig opptak» og knappen «Søk om tidlig opptak» vises ikke, så søkeren kan ikke søke om tidlig opptak. | | |
| | | *Gjør klar til neste test: opptaksforvalteren flytter «Søknadsfrist for tidlig opptak» tilbake til fristen som sto der før.* | | | |

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|
| – | Alle scenarioene kan testes når testbrukerne og testdataene er på plass | – |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Se når søkeren søkte om tidlig opptak | Ikke avklart ennå: en utvidelse for senere |
| Se dokumentasjonsfristen for tidlig opptak | Ikke avklart ennå |

## Funn

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig.

## Andre funn

Det du oppdager som ikke gjelder testcasene, for eksempel brukervennlighet, eller et tilfelle kravet ikke dekker. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et viktig tilfelle, legges det inn i kravet.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
