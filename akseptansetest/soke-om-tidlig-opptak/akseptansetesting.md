# Akseptansetesting søke om tidlig opptak

- **Krav**: `@OPT-SØK-SØK-011`, commit `184daa8` (2026-10-26), 9 scenarioer i 5 regler
- **Verifisering**: [verify-søke_om_tidlig_opptak-2026-10-26-0950.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/verify-s%C3%B8ke_om_tidlig_opptak-2026-10-26-0950.md), 9 av 9 funnet · [testrapport-verifisering-2026-10-26.md](testrapport-verifisering-2026-10-26.md)
- **Ordene fra skjermen**: min-kompetanse `2ca3bdd6`, kvitteringen fra fs-plattform `26d0862b43`
- **Oppsett av testmiljøet**: [oppsett.md](oppsett.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5144772613
- **Form**: én side, etter [Akseptansetesting saksbehandlertildeling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130911779). Erstatter testplanen og testcasene for intern akseptansetest

---

Testbeskrivelse og testgjennomføring for akseptansetesten av «Søke om tidlig opptak». Siden følger oppsettet på [Akseptansetesting saksbehandlertildeling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130911779) og [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850), og bygger på den nyeste versjonen av kravet. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Sak (GitHub og Jira) | GitHub [#456](https://github.com/sikt-no/fs/issues/456), [#525](https://github.com/sikt-no/fs/issues/525) · Jira [STEK-188](https://sikt.atlassian.net/browse/STEK-188), [STEK-267](https://sikt.atlassian.net/browse/STEK-267) |
| Krav (.feature) | [søke\_om\_tidlig\_opptak.feature](https://github.com/sikt-no/fs/blob/184daa8/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature) (`@OPT-SØK-SØK-011`, `@must`, `@implemented`), commit `184daa8`, 26.10.2026. 9 scenarioer i 5 regler testes. Kravet er ikke med i en flyt. Verifisert 26.10.2026: alle 9 funnet i koden ([verifisering](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5143887891), [testrapport](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5146836993)). |
| Hva er laget | Søkeren kan søke om tidlig opptak i Min kompetanse, fra søknaden etter at den er sendt. Søkeren ser hvilke søknadsalternativer som ikke tilbyr tidlig opptak, leser hvem som kan søke og hva som må dokumenteres for hver begrunnelse, velger én begrunnelse og sender. Søkeren får kvittering i Mine meldinger. Søknaden om tidlig opptak gjelder hele søknaden, og kan bare sendes før fristen for tidlig opptak. |
| Brukerhistorie | Som søker ønsker jeg å søke om tidlig opptak med en begrunnelse, slik at jeg kan få tidlig svar på om jeg er sikret plass på studiet jeg ønsker meg mest. |
| Hvor testes det (miljø/URL) | Min kompetanse i testmiljøet: <https://test.minkompetanse.no/> |
| Versjon og feature-flagg | [Fylles ut: versjon. Verifisert mot fs-plattform `26d0862b43` og min-kompetanse `ab8be322`] · `enable-tidlig-opptak` (på i testmiljøet) |
| Berører andre team? | Nei. Tidlig opptak må være slått på i opptaket (`@OPT-OVO-INN-001`) og på utdanningstilbudet (`@OPT-OPT-UTD-004`). Ingen av de kravene er levert ennå, så innstillingene er satt i testdataene. |
| Utenfor scope | Hvordan søknaden om tidlig opptak vurderes, og svaret søkeren får. Se «Ikke med i denne testen». |
| Kjente begrensninger | Søkeren kan ikke trekke ønsket om tidlig opptak, så hver gjennomkjøring trenger en søker som ikke har søkt. Søknaden lagrer ikke når søkeren søkte: søkeren ser «Du har søkt om tidlig opptak.» uten dato, og tidspunktet står i kvitteringen. Etter fristen vises ikke boksen «Tidlig opptak» for en søker som ikke har søkt. Løsningen godtar en søknad om tidlig opptak selv om ingen av søkerens søknadsalternativer tilbyr det, men Min kompetanse viser ikke muligheten i det tilfellet. |
| Kontaktperson i teamet | [Fylles ut] |
| Testansvarlig | Marit Bjørnerud Rønning |
| Dato for test | [Fylles ut] |
| Spørsmål underveis | [Fylles ut: kanal på Slack] |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | Samtidig Sild (10830798485) | Søker med sendt søknad (1000670) der «Psykologi profesjon» tilbyr tidlig opptak og «Biovitenskap» ikke gjør det | – | Søke om tidlig opptak, se søknadsalternativene, informasjonen og begrunnelsene, legge til et søknadsalternativ etterpå |
| 2 | Heidi Lykke (05849540000) | Søker med sendt søknad (1004306) med bare «Rettsvitenskap (jus)» ved UiO, som ikke tilbyr tidlig opptak | – | Ikke kunne søke når ingen søknadsalternativer tilbyr det |
| 3 | Frisk Frosk (05849509715) | Søker uten søknad i «Samordna UHG-simulering høsten 2026». Søknaden startes i testen, og sendes ikke | – | Ikke kunne søke før søknaden er sendt |
| 4 | Ullen Bikkje (31900699630) | Søker med sendt søknad (1004225) i opptak 2, der fristen for tidlig opptak er ute | – | Ikke kunne søke etter fristen |

Testbrukerne er søkere, som ikke hører til en organisasjon, så det er ingen synlighet mellom organisasjoner å teste. Gå til forsiden før du bytter testbruker, og bytt under «Meny» og «Velg testsøker». Viser siden «404 - Siden finnes ikke» etter byttet, velg «Til forsiden».

### Testdata

| Hva | **Status** |
|---|---|
| «Samordna UHG-simulering høsten 2026» (opptak 34) med tidlig opptak, søknadsfrist for tidlig opptak 6.10.2027 og lenke til informasjon om tidlig opptak | På plass |
| Utdanningstilbud i opptak 34 som tilbyr tidlig opptak (23 stykker), og som ikke gjør det («Biovitenskap» og «Rettsvitenskap (jus)» ved UiO). Flere opptak har utdanningstilbud med de samme navnene: de i opptak 34 har søknadsfrist 13.10.2027 | På plass |
| Grunnlaget «Avvikle virksomheten» er inaktivt i opptak 34 (3.1), og de fire andre er aktive | Settes før testen, og tilbake etterpå ([oppsett.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/soke-om-tidlig-opptak/oppsett.md)) |
| «Grunnskolelærerutdanning for trinn 5-10 (300 studiepoeng)» i Halden, som tilbyr tidlig opptak, for 5.1 | På plass |
| «Opptak UHM 2025» (opptak 2), der søknadsfristen for tidlig opptak gikk ut 22.10.2026, for 4.1 | På plass |
| Søknadene til testbruker 1 og 2. Søknadene i testmiljøet blir ikke liggende lenge | Sjekkes dagen før testen, og gjøres klare igjen ved behov ([oppsett.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/soke-om-tidlig-opptak/oppsett.md)) |
| Testbruker 3 har ingen søknad i «Samordna UHG-simulering høsten 2026», heller ikke en som ikke er sendt | Sjekkes dagen før testen. Søknaden fra 1.2 slettes etter testen ([oppsett.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/soke-om-tidlig-opptak/oppsett.md)) |
| Søknaden om tidlig opptak fra testbruker 1 (2.4) | Kan ikke settes tilbake. Neste gjennomkjøring trenger en ny testbruker 1 |

**NB: Sjekk at testmiljøet har dataene før testen.**

### Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

Søknadene åpnes under «Meny» øverst til høyre og «Mine søknader». Der står søknadene med navnet på opptaket, ikke med søknadsnummeret. Testbruker 1 har søknader i flere opptak, og testen bruker søknaden i «Samordna UHG-simulering høsten 2026». Boksen «Tidlig opptak» står under «Om søknaden» på «Søknadsdetaljer».

Testcasene står i den rekkefølgen de kjøres, sortert etter testbruker, så testbrukeren byttes tre ganger. Nummeret viser regelen i kravet. 2.4a sender søknaden om tidlig opptak for testbruker 1, og det kan ikke gjøres om. Derfor står 2.4a og 2.4b etter testcasene som trenger at testbruker 1 ikke har søkt, og før 5.1, som bygger på dem. 2.1 står før 2.2, fordi «Søk om tidlig opptak» i 2.2 går til en ny side, bort fra lenken i 2.1.

### Testbruker 1: Samtidig Sild

| # | Regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|
| 1.1 | 1: Søkeren ber om tidlig opptak etter at søknaden er sendt | Søke om tidlig opptak fra søknadsdetaljene | Som testbruker 1: åpne «Søknad til Samordna UHG-simulering høsten 2026» | Boksen «Tidlig opptak» står på søknadsdetaljene, med teksten om tidlig opptak og knappen «Søk om tidlig opptak» | | |
| 2.1 | 2: Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Se informasjon om tidlig opptak i opptaket | Som testbruker 1: åpne «Søknad til Samordna UHG-simulering høsten 2026», og velg «Les mer om tidlig opptak og hvilken dokumentasjon som kreves» i boksen «Tidlig opptak» | Lenken åpner siden opptaket har satt: <https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html> | | |
| 2.2 | 2: Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Se hvilke søknadsalternativer som tilbyr tidlig opptak | Som testbruker 1: åpne «Søknad til Samordna UHG-simulering høsten 2026», og velg «Søk om tidlig opptak». Ikke velg «Send søknad» | Boksen «Obs! Disse studieønskene tilbyr ikke tidlig opptak.» viser «Biovitenskap» ved UiO, men ikke «Psykologi profesjon» | | |
| 3.1 | 3: Søkeren velger én begrunnelse fra opptakets liste | Se begrunnelsene søkeren kan velge | «Avvikle virksomheten» er inaktivt i opptaket. Som testbruker 1: åpne «Søknad til Samordna UHG-simulering høsten 2026», velg «Søk om tidlig opptak», og åpne «Hvem kan søke tidlig opptak?». Ikke velg «Send søknad» | Disse fire grunnlagene kan velges under «Velg et grunnlag for tidlig opptak»: «Jeg må flytte med familien på grunn av jobb, barnehageplass eller skolebytte», «Jeg er i jobb og har oppsigelsestid, eller må søke permisjon», «Jeg må søke oppholdstillatelse for å studere» og «Jeg har behov for særskilt tilrettelegging på studiestedet». «Hvem kan søke tidlig opptak?» forklarer hva som må dokumenteres for de samme fire. Ingen andre grunnlag står noen av stedene, heller ikke det inaktive grunnlaget om å avvikle virksomheten | | |
| 2.4a | 2: Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Søke om tidlig opptak med en begrunnelse | Som testbruker 1: åpne «Søknad til Samordna UHG-simulering høsten 2026», og velg «Søk om tidlig opptak». Velg «Jeg er i jobb og har oppsigelsestid, eller må søke permisjon» under «Velg et grunnlag for tidlig opptak», og «Send søknad». Åpne «Søknad til Samordna UHG-simulering høsten 2026» igjen | Søknaden viser «Du har søkt om tidlig opptak.», med en påminnelse om dokumentasjonen for grunnlaget, og «Søk om tidlig opptak» er borte | | |
| 2.4b | 2: Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Søke om tidlig opptak med en begrunnelse: kvitteringen | Som testbruker 1: velg «Meldinger» i oversikten, og åpne den nyeste meldingen, «Du har søkt om tidlig opptak» | Kvitteringen viser bare «Psykologi profesjon» under «Du har søkt tidlig opptak til følgende studier:», ikke «Biovitenskap» | | |
| 5.1 | 5: Søknaden om tidlig opptak gjelder hele søknaden | Søknaden om tidlig opptak blir stående når søknadsalternativene endres | Testbruker 1 har søkt om tidlig opptak (2.4). Som testbruker 1: åpne «Søknad til Samordna UHG-simulering høsten 2026», og velg «Legg til studieønsker +». Legg til «Grunnskolelærerutdanning for trinn 5-10 (300 studiepoeng)» i Halden, og fortsett fram til og med «Lagre endringer». Åpne «Søknad til Samordna UHG-simulering høsten 2026» igjen | Det nye studieønsket står i søknaden, og boksen viser fortsatt «Du har søkt om tidlig opptak.», med påminnelsen for det samme grunnlaget som i 2.4 | | |

### Testbruker 2: Heidi Lykke

| # | Regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|
| 2.3 | 2: Søkeren kan søke om tidlig opptak når opptaket tilbyr det | Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det | Som testbruker 2: åpne «Søknad til Samordna UHG-simulering høsten 2026» | Boksen «Tidlig opptak» og knappen «Søk om tidlig opptak» vises ikke | | |

### Testbruker 3: Frisk Frosk

| # | Regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|
| 1.2 | 1: Søkeren ber om tidlig opptak etter at søknaden er sendt | Kan ikke søke om tidlig opptak før søknaden er sendt | Som testbruker 3: velg «Finn studier», skriv inn «Psykologi profesjon», velg det første av treffene med søknadsfrist 13.10.2027, og velg «Legg til» og «Til studiekurv». «Psykologi profesjon» tilbyr tidlig opptak. Gå gjennom stegene fram til «Send søknad», uten å sende. Velg «Mine søknader»: søknaden står ikke under «Aktive søknader», siden den ikke er sendt | «Tidlig opptak» og «Søk om tidlig opptak» vises ikke noe sted | | |

### Testbruker 4: Ullen Bikkje

| # | Regel | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|---|
| 4.1 | 4: Tidlig opptak kan bare søkes innen søknadsfristen for tidlig opptak | Kan ikke søke om tidlig opptak etter fristen | Fristen for tidlig opptak i «Opptak UHM 2025» gikk ut 22.10.2026, og minst ett av søknadsalternativene tilbyr tidlig opptak. Som testbruker 4: åpne «Søknad til Opptak UHM 2025» | Boksen «Tidlig opptak» og knappen «Søk om tidlig opptak» vises ikke | | |

### Ikke med i denne testen

| Scenario | Begrunnelse |
|---|---|
| Se når søkeren søkte om tidlig opptak | Ikke avklart: en utvidelse for senere |
| Søkeren ser dokumentasjonsfristen for tidlig opptak (regel) | Utkast, ikke avklart |
| Vurdering av søknaden om tidlig opptak, og svaret søkeren får | Egne krav (`@OPT-BEH-BEH-008`, `@OPT-SØK-SØK-012`) |

## Funn

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| 1 | 2.4b | Kvitteringen viser både «Psykologi profesjon» og «Biovitenskap» under «Du har søkt tidlig opptak til følgende studier:». «Biovitenskap» tilbyr ikke tidlig opptak. Årsak: kvitteringen tar med alle studieønskene når opptaket har tidlig opptak (fs-plattform, `SoknadKvitteringService`). Den samme tolkningen gjør at løsningen godtar en søknad om tidlig opptak selv om ingen søknadsalternativer tilbyr det (`SokTidligOpptakService`). Marit Bjørnerud Rønning satte testcasen til «Ikke bestått», og er enig i at feilen bør rettes | Kvitteringen viser bare studieønskene der utdanningstilbudet tilbyr tidlig opptak, her «Psykologi profesjon». Opptaket må ha tidlig opptak, og hvert utdanningstilbud tilbyr det eller ikke. **Kravet dekker ikke:** `@OPT-SØK-SØK-011` sier bare at søkeren får kvittering, ikke hvilke studier den viser. Forventningen er avklart 30.10.2026, og må inn i kravet | Som testbruker 1: velg «Meldinger» i oversikten, og åpne meldingen «Du har søkt om tidlig opptak» | – | Forslag: Må fikses før innføring | – |
| 2 | 2.2 | Boksen «Obs! Disse studieønskene tilbyr ikke tidlig opptak.» viser bare studieønskene som ikke tilbyr tidlig opptak. Testeren ble usikker: «hvor er mine andre ønsker?» | Ønske: siden viser også studieønskene som tilbyr tidlig opptak, eller for eksempel «Av dine 5 ønsker er det 1 som ikke tilbyr» | Som en søker som ikke har søkt om tidlig opptak, med studieønsker som tilbyr tidlig opptak og som ikke gjør det: åpne søknaden, og velg «Søk om tidlig opptak» | – | Forslag: Kan fikses senere | – |

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig.

## Beslutning

| Felt | Innhold |
|---|---|
| Utfall | Godkjent / Godkjent med forbehold / Ikke godkjent |
| Begrunnelse | |
| Kjente mangler og avtalt retting | |
| Besluttet av og dato | |

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |
