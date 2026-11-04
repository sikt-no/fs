# Flytbeskrivelser til partene – Tidlig opptak og tilbudsgaranti

- **Nivå**: ekstern (fase 4), vedlegg til [testcaser-ekstern.md](testcaser-ekstern.md)
- **Testplan**: ingen felles testplan, se metadataene i [testcaser-ekstern.md](testcaser-ekstern.md)
- **Bygger på**: de interne testene ([søke om tidlig opptak](../soke-om-tidlig-opptak/akseptansetesting.md), [saksbehandling](../saksbehandling-tidlig-opptak/testcaser-intern.md), tilbudsgaranti på PR #787), kravene `@OPT-SØK-SØK-011`, `@OPT-BEH-BEH-009`, `@OPT-BEH-BEH-013` og `@OPT-BEH-BEH-010` (commit `990afe3f`), og rapportene: verifisering ([søke](../soke-om-tidlig-opptak/testrapport-verifisering-2026-10-26.md), [saksbehandling](../saksbehandling-tidlig-opptak/testrapport-verifisering-2026-10-27.md), tilbudsgaranti på PR #787), [intern, saksbehandling](../saksbehandling-tidlig-opptak/testrapport-intern-2026-10-30.md). Ingen agentisk funksjonstest
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5165383733 (underside til testsiden, publisert 2026-11-03; v2: endringsloggen, v3: beslutningene for de interne testene, ført av Jens Thomassen 2026-11-04, v4: kvitteringen er testet på nytt)
- **Laget**: 2026-11-03 av fs-testcaser-ekstern
- **Sporing**:

  | Beskrivelse | Flyt | Krav | Testcase intern |
  |---|---|---|---|
  | Fra søknad om tidlig opptak til tilbudsgaranti | – (flyten er ikke skrevet) | `@OPT-SØK-SØK-011`, `@OPT-BEH-BEH-009`, `@OPT-BEH-BEH-013`, `@OPT-BEH-BEH-010` | SØK-011: 1.1, 2.1, 2.2, 2.4a, 2.4b, 5.1 · saksbehandling: 1.1, 1.2, 1.4a, 2.1, 2.2 · tilbudsgaranti: 1.1a, 1.1c, 1.14a |

- **Tallene i «Hva Sikt har testet»**: verifiseringen fant 10 av 10 (SØK-011: 9 av 9 26.10, og de to endrede scenarioene 02.11), 6 av 6 (BEH-009), 9 av 9 (BEH-013) og 17 av 17 (BEH-010). Intern: SØK-011 9 testcaser, funn 1 rettet (TOT-2556) og 2.4b ikke kjørt på nytt, funn 2 (ønske) står igjen. Saksbehandling 10 av 10 bestått. Tilbudsgaranti 18 testcaser kjørt 26.10, alle bestått, godkjent 28.10 (muntlig, ingen rapport).

---

Flytbeskrivelser og krav for tidlig opptak og tilbudsgaranti. Her ser du hvilke flyter som testes, hva løsningen skal gjøre i hvert steg, og hva Sikt allerede har testet. Testen vurderer ikke om kravene er riktige: mener du at kravene mangler noe, er det et endringsforslag. Er du usikker på noe i kravene, si fra til kontaktpersonen før du begynner.

## Fra søknad om tidlig opptak til tilbudsgaranti

**Hva flyten handler om:** en søker som trenger tidlig svar, for eksempel for å si opp en jobb eller flytte, søker om tidlig opptak med et grunnlag etter at søknaden er sendt. Saksbehandleren ved lærestedet som behandler saken, vurderer grunnlaget og setter en konklusjon. Saksbehandleren og opptaksforvalteren kan gi søkeren tilbudsgaranti på et studieønske, og tilbudsgarantien følger studieønsket når søkeren endrer søknaden.

| Steg | Hvem | Hva skjer | Hva neste steg bruker |
|---|---|---|---|
| 1 | Søkeren | Sender søknaden i Min kompetanse, med studier som tilbyr tidlig opptak og studier som ikke gjør det | Den sendte søknaden |
| 2 | Søkeren | Søker om tidlig opptak fra søknaden, med ett grunnlag fra opptakets liste, og får kvittering | Søknaden om tidlig opptak, med grunnlaget |
| 3 | Saksbehandleren | Finner søknadene om tidlig opptak som mangler konklusjon, ser grunnlaget og hva som må dokumenteres, og setter en konklusjon | Konklusjonen på saken |
| 4 | Saksbehandleren og opptaksforvalteren | Gir tilbudsgaranti på et studieønske, hver i sitt felt | Tilbudsgarantiene på studieønsket |
| 5 | Søkeren | Endrer rekkefølgen på studieønskene | Søknaden om tidlig opptak og tilbudsgarantiene blir stående |

**Hva løsningen skal gjøre:**

| Steg | Kravet med vanlige ord |
|---|---|
| 2 | Søkeren kan be om tidlig opptak fra søknaden, men først når søknaden er sendt. |
| 2 | Søkeren kan søke om tidlig opptak når opptaket har tidlig opptak, og minst ett av studieønskene tilbyr det. Søkeren ser hvilke studieønsker som ikke tilbyr tidlig opptak, og kan lese opptakets informasjon om tidlig opptak. Kvitteringen viser studiene søknaden om tidlig opptak gjelder. |
| 2 | Søkeren velger ett grunnlag fra listen opptaket har, og ser hva som må dokumenteres for hvert grunnlag. |
| 2 | Søkeren kan bare søke om tidlig opptak innen søknadsfristen for tidlig opptak. |
| 3 | Saksbehandleren kan finne sakene der søkeren har søkt om tidlig opptak, og sakene som mangler konklusjon. |
| 3 | Saksbehandleren ser søkerens grunnlag og hva som må dokumenteres for det. |
| 3 | Saksbehandleren velger en av opptakets konklusjoner for tidlig opptak. Konklusjonen gjelder lærestedet som behandler saken, og saken viser ikke tidlig opptak når søkeren ikke har søkt. |
| 3 | Konklusjonen kan endres, også etter at tidligopptaket er gjennomført. |
| 4 | Saksbehandler, tilbyder og opptaksforvalter kan gi tilbudsgaranti på et studieønske, hver i sitt felt, med tilbudsgarantitypene opptaket har for rollen. Alle ser de andres tilbudsgaranti, men kan bare endre sin egen. |
| 4 | Den som satte tilbudsgarantien, kan endre og fjerne den. Tilbudsgarantien fra en annen rolle blir stående. |
| 4 | Bare tilbudsgarantitypene i opptaket kan velges. |
| 4 | Endringer i tilbudsgarantien kan spores: hvem som satte eller fjernet den, når, og hvilken type. |
| 5 | Søknaden om tidlig opptak gjelder hele søknaden, og blir stående når studieønskene endres. |
| 5 | Tilbudsgarantien følger studieønsket når søkeren endrer rekkefølgen, eller når studieønsket flyttes til et annet lærested. Den faller bort når studieønsket fjernes, og gjelder igjen når det legges inn igjen før søknadsfristen. |

**Dette kan du ikke gjøre i testen:**

- Gjennomføre tidligopptaket, så søkerne med konklusjon får tilbudsgaranti fra tidligopptaket. Det kommer senere, og i testen settes tilbudsgarantien for hånd.
- Se hvem som har satt eller fjernet en tilbudsgaranti. Knappen «Endringslogg» i saken viser «Ingen endringer» inntil videre.
- Sette tilbudsgaranti som tilbyder når saken behandles av et annet lærested. Det er en kjent mangel som rettes.
- Trekke søknaden om tidlig opptak. Søkeren ser heller ikke når søknaden om tidlig opptak ble sendt (det står i kvitteringen).

## Hva Sikt har testet

| Fase | Hva | Utfall | Funn som står igjen |
|---|---|---|---|
| Kontroll av at alt er laget | Alle 42 funksjonene i de fire kravene er funnet i løsningen, og roller og tilganger er kontrollert | Klar | Ingen |
| Funksjonstest (agent) | Ikke gjennomført for disse leveransene | – | – |
| Intern akseptansetest | Søke om tidlig opptak: 9 testcaser. Saksbehandling: 10 testcaser. Tilbudsgaranti: 18 testcaser. Testet av domeneekspertene | Søke om tidlig opptak: godkjent med forbehold om at innhold i kvittering rettes. Saksbehandling: godkjent. Tilbudsgaranti: godkjent | Kvitteringen viste også studier uten tidlig opptak. Det er rettet, og testet på nytt. Ønske: siden for tidlig opptak viser også studieønskene som tilbyr tidlig opptak, ikke bare dem som ikke gjør det (kan fikses senere) |

Rapportene: [Fylles ut: lenker til rapportene som kan deles med partene]
