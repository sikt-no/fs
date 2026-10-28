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
| Testansvarlig | [Fylles ut] |
| Dato for test | [Fylles ut] |
| Spørsmål underveis | [Fylles ut: kanal på Slack] |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | Samtidig Sild (10830798485) | Søker med sendt søknad (1000670) der «Psykologi profesjon» tilbyr tidlig opptak og «Biovitenskap» ikke gjør det | – | Søke om tidlig opptak, se søknadsalternativene, informasjonen og begrunnelsene, legge til et søknadsalternativ etterpå |
| 2 | Heidi Lykke (05849540000) | Søker med sendt søknad (1004306) med bare «Rettsvitenskap (jus)» ved UiO, som ikke tilbyr tidlig opptak | – | Ikke kunne søke når ingen søknadsalternativer tilbyr det |
| 3 | Fredag Lørdag (12919210263) | Søker med en søknad som ikke er sendt | – | Ikke kunne søke før søknaden er sendt |
| 4 | Ullen Bikkje (31900699630) | Søker med sendt søknad (1004225) i opptak 2, der fristen for tidlig opptak er ute | – | Ikke kunne søke etter fristen |

Testbrukerne er søkere, som ikke hører til en organisasjon, så det er ingen synlighet mellom organisasjoner å teste. Bytt testbruker under «Meny» og «Velg testsøker». Viser siden «404 - Siden finnes ikke» etter byttet, velg «Til forsiden».

### Testdata

| Hva | **Status** |
|---|---|
| «Samordna UHG-simulering høsten 2026» (opptak 34) med tidlig opptak, søknadsfrist for tidlig opptak 6.10.2027 og lenke til informasjon om tidlig opptak | På plass |
| Utdanningstilbud i opptak 34 som tilbyr tidlig opptak (23 stykker), og som ikke gjør det («Biovitenskap» og «Rettsvitenskap (jus)» ved UiO). Flere opptak har utdanningstilbud med de samme navnene: de i opptak 34 har søknadsfrist 13.10.2027 | På plass |
| Grunnlaget «Avvikle virksomheten» er inaktivt i opptak 34 (3.1), og de fire andre er aktive | Settes før testen, og tilbake etterpå ([oppsett.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/soke-om-tidlig-opptak/oppsett.md)) |
| «Grunnskolelærerutdanning for trinn 5-10 (300 studiepoeng)» i Halden, som tilbyr tidlig opptak, for 5.1 | På plass |
| «Opptak UHM 2025» (opptak 2), der søknadsfristen for tidlig opptak gikk ut 22.10.2026, for 4.1 | På plass |
| Søknadene til testbruker 1, 2 og 3. Søknadene i testmiljøet blir ikke liggende lenge | Sjekkes dagen før testen, og gjøres klare igjen ved behov ([oppsett.md](https://github.com/sikt-no/fs/blob/main/akseptansetest/soke-om-tidlig-opptak/oppsett.md)) |
| Søknaden om tidlig opptak fra testbruker 1 (2.4) | Kan ikke settes tilbake. Neste gjennomkjøring trenger en ny testbruker 1 |

**NB: Sjekk at testmiljøet har dataene før testen.**

### Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

«Åpne søknaden» betyr: velg «Meny» øverst til høyre og «Mine søknader», og åpne søknaden i «Samordna UHG-simulering høsten 2026» (for testbruker 4: «Opptak UHM 2025»). Boksen «Tidlig opptak» står under «Om søknaden» på «Søknadsdetaljer».

**Ta 2.4 og 5.1 til slutt.** 2.4 sender søknaden om tidlig opptak for testbruker 1, og det kan ikke gjøres om. 1.1, 2.1, 2.2 og 3.1 trenger at testbruker 1 ikke har søkt, og 5.1 bygger på 2.4.

### Regel 1: Søkeren ber om tidlig opptak etter at søknaden er sendt

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 1.1 | Søke om tidlig opptak fra søknadsdetaljene | Som testbruker 1: åpne søknaden | Boksen «Tidlig opptak» står på søknadsdetaljene, med teksten om tidlig opptak og knappen «Søk om tidlig opptak» | | |
| 1.2 | Kan ikke søke om tidlig opptak før søknaden er sendt | Som testbruker 3: åpne søknaden som ikke er sendt, og gå gjennom stegene fram til «Send søknad», uten å sende | «Tidlig opptak» og «Søk om tidlig opptak» vises ikke noe sted | | |

### Regel 2: Søkeren kan søke om tidlig opptak når opptaket tilbyr det

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 2.1 | Se hvilke søknadsalternativer som tilbyr tidlig opptak | Som testbruker 1: åpne søknaden, og velg «Søk om tidlig opptak». Velg «Gå tilbake» uten å sende | Boksen «Obs! Disse studieønskene tilbyr ikke tidlig opptak.» viser «Biovitenskap» ved UiO, men ikke «Psykologi profesjon» | | |
| 2.2 | Se informasjon om tidlig opptak i opptaket | Som testbruker 1: åpne søknaden, og velg «Les mer om tidlig opptak og hvilken dokumentasjon som kreves» i boksen «Tidlig opptak» | Lenken åpner siden opptaket har satt: <https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html> | | |
| 2.3 | Kan ikke søke om tidlig opptak når ingen søknadsalternativer tilbyr det | Som testbruker 2: åpne søknaden | Boksen «Tidlig opptak» og knappen «Søk om tidlig opptak» vises ikke | | |
| 2.4 | Søke om tidlig opptak med en begrunnelse | Som testbruker 1: åpne søknaden, og velg «Søk om tidlig opptak». Velg «Oppsigelsestid/permisjon» under «Velg et grunnlag for tidlig opptak», og «Send søknad». Åpne søknaden igjen, og den nyeste kvitteringen i «Mine meldinger» | Søknaden viser «Du har søkt om tidlig opptak.», med en påminnelse om dokumentasjonen for grunnlaget, og «Søk om tidlig opptak» er borte. Kvitteringen [Sjekk begrep: tittelen] viser bare «Psykologi profesjon» under «Du har søkt tidlig opptak til følgende studier:» | | |

### Regel 3: Søkeren velger én begrunnelse fra opptakets liste

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 3.1 | Se begrunnelsene søkeren kan velge | «Avvikle virksomheten» er inaktivt i opptaket. Som testbruker 1: åpne søknaden, velg «Søk om tidlig opptak», og åpne «Hvem kan søke tidlig opptak?». Velg «Gå tilbake» uten å sende | «Hvem kan søke tidlig opptak?» forklarer hva som må dokumenteres for «Barnehageplass/skole/familie», «Oppsigelsestid/permisjon», «Oppholdstillatelse» og «Særskilt tilrettelegging». De samme kan velges under «Velg et grunnlag for tidlig opptak». «Avvikle virksomheten» står ikke noen av stedene | | |

### Regel 4: Tidlig opptak kan bare søkes innen søknadsfristen for tidlig opptak

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 4.1 | Kan ikke søke om tidlig opptak etter fristen | Fristen for tidlig opptak i «Opptak UHM 2025» gikk ut 22.10.2026, og minst ett av søknadsalternativene tilbyr tidlig opptak. Som testbruker 4: åpne søknaden | Boksen «Tidlig opptak» og knappen «Søk om tidlig opptak» vises ikke | | |

### Regel 5: Søknaden om tidlig opptak gjelder hele søknaden

| # | Scenario | Steg | Forventet resultat | Faktisk resultat | Bestått? |
|---|---|---|---|---|---|
| 5.1 | Søknaden om tidlig opptak blir stående når søknadsalternativene endres | Testbruker 1 har søkt om tidlig opptak (2.4). Som testbruker 1: velg «Legg til studieønsker», legg til «Grunnskolelærerutdanning for trinn 5-10 (300 studiepoeng)» i Halden, og send søknaden [Sjekk begrep: stegene når et studieønske legges til en sendt søknad]. Åpne søknaden igjen | Det nye studieønsket står i søknaden, og boksen viser fortsatt «Du har søkt om tidlig opptak.», med påminnelsen for det samme grunnlaget som i 2.4 | | |

### Ikke med i denne testen

| Scenario | Begrunnelse |
|---|---|
| Se når søkeren søkte om tidlig opptak | Ikke avklart: en utvidelse for senere |
| Søkeren ser dokumentasjonsfristen for tidlig opptak (regel) | Utkast, ikke avklart |
| Vurdering av søknaden om tidlig opptak, og svaret søkeren får | Egne krav (`@OPT-BEH-BEH-008`, `@OPT-SØK-SØK-012`) |

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
