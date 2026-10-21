# Mal: Ekstern akseptansetest

For erfarne brukere fra lærestedene og andre eksterne parter, for eksempel HK-dir i opptak. Sikt leder testen. Den er lettere enn den interne med vilje: testerne skal komme raskt i gang, og skal ikke trenge bakgrunnen for leveransen.

Fra [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850):

- **Hvilke scenarioer:** hovedflyten i kravene i leveransene som testes.
- **Hvor grundig:** feilsituasjonene er testet i den interne akseptansetesten. Flere scenarioer kan settes sammen til én testcase.
- **Rekkefølge:** rekkefølgen i arbeidsprosessen.
- **Testcasen inneholder:** en oppgave i arbeidsprosessen som går gjennom flere scenarioer i den rekkefølgen brukerne jobber, med hensikt, testdata og forventet resultat. Hvert scenario i oppgaven får eget resultat.

Og:

- **Ingen intern informasjon:** Feature-ID-er, scope-id-er, tagger, commits, Jira, GitHub, feature-flagg, kodeverdier og verify-resultater. Sporingen står i metadataene.
- **Kort.** Sikt mot høyst 10 testcaser og under én time. Blir det mer, foreslå å dele i flere økter.

I fila skrives stegene i én tabellcelle, nummerert og skilt med `<br>`. Ved publisering blir de en nummerert liste i cella (se `confluence.md`).

Fila skrives til `akseptansetest/<testplan-slug>/testcaser-ekstern.md`. Alt over den første streken er metadata for repoet, og publiseres ikke.

```markdown
# Ekstern akseptansetest – <leveranse>

- **Nivå**: ekstern
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Scope**: @scope-<slug>[, …]
- **Krav**: <N> feature-filer, commit `<sha>` (<YYYY-MM-DD>)
- **Bygger på**: [intern akseptansetest](testcaser-intern.md), [testrapport](testrapport-intern-<dato>.md): <utfall>
- **Testere**: <HK-dir, læresteder>
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testcaser-ekstern
- **Sporing**:

  | Nr | Steg i oppgaven | Feature-ID | Scenario | Intern |
  |---|---|---|---|---|
  | 1 | a | `@DOM-SUB-KAP-NNN` | <scenariotittel fra kravet> | 1.1 |

---

Velkommen til akseptansetesten av <leveranse>. I testen sjekker du om løsningen virker i praksis for det du skal bruke den til. Du trenger ikke kjenne bakgrunnen for leveransen.

## Før du starter

| Felt | Innhold |
|---|---|
| Hva er laget | <2–3 setninger med vanlige ord: hva du kan gjøre, og hvor i løsningen> |
| Hvor du tester | [<url>](<url>) |
| Dette kan du ikke gjøre i testen | - <kort> <br>- <…> |
| Tid | Ca. <N> minutter. Frist: <dato> |
| Spørsmål underveis | <kontaktperson>, i <kanal> |

## Slik fyller du ut

1. Ta testcasene i rekkefølge, og følg stegene slik de står.
2. Hver testcase er en oppgave du gjør i løsningen. Den har flere deler, og hver del har sin egen rad med «Faktisk resultat» og «Status».
3. Skriv det du så i «Faktisk resultat», og Bestått, Ikke bestått eller Ikke testet i «Status».
4. Sjekk at det du har lagret, står der når du åpner siden igjen.
5. Stemmer noe ikke, skriv det i «Funn»: hva du gjorde, hva du forventet og hva du fikk. Ta skjermbilde hvis du kan.

## Testcaser

### <Nr>. <Oppgaven i arbeidsprosessen, med vanlige ord> (ca. <N> minutter)

**Hensikt:** <hva testeren skal få til, og hvorfor det er viktig i arbeidsprosessen>

**Testdata:** testbruker <nr> (<navn>, <rolle> ved <organisasjon>). Bruker: <data som må finnes>. Lager: <data som de neste testcasene trenger>.

| Del | Hva du gjør | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| <Nr>a | <med vanlige ord> | 1. Logg inn som testbruker <nr> (<navn>, <rolle> ved <organisasjon>). <br>2. Gå til «…». <br>3. … | <det du ser> | | |
| <Nr>b | <med vanlige ord> | 4. … <br>5. … | <det du ser> | | |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Feilmeldinger og sperrer | Testet i den interne akseptansetesten |
| <med vanlige ord> | <kommer senere / gjelder ikke dere / testes på en annen måte> |

## Funn

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

<Tabellen «Alvorlighetsgrad» fra `alvorlighetsgrad.md`, ordrett.>

## Andre funn og erfaringer

Her skriver du det du oppdager som ikke står i testcasene, for eksempel om brukervennlighet, eller om du savner noe i arbeidsprosessen.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
```

## Nummerering

- Testcasene nummereres fra 1. Delene (ett scenario hver) får bokstav: `1a`, `1b`, `1c`.
- Stegene løper gjennom hele testcasen, så del `1b` fortsetter der `1a` slapp.
