# Mal: Intern akseptansetest

For testansvarlig (domeneekspert) og de andre interne testerne. Formen er den [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850) gir i *Testplan og sluttrapport*: én overskrift per krav og én tabell per regel, og hvert scenario blir én testcase.

Siden er for testerne. Testbeskrivelsen (miljø, versjon, flagg, testbrukere, testdata, roller) står i testplanen, og siden lenker dit i stedet for å gjenta den. Beslutningen står i testrapporten.

I fila skrives stegene i én tabellcelle, nummerert og skilt med `<br>`. Ved publisering blir de en nummerert liste i cella (se `confluence.md`).

Fila skrives til `akseptansetest/<testplan-slug>/testcaser-intern.md`. Alt over den første streken er metadata for repoet, og publiseres ikke. Sporingen fra testcase til krav står i metadataene, så `fs-testrapport` kan telle per krav og regel.

```markdown
# Intern akseptansetest – <leveranse>

- **Nivå**: intern
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Scope**: @scope-<slug>[, …] | –
- **Krav**: <N> feature-filer, commit `<sha>` (<YYYY-MM-DD>)
- **Verifisering**: <verify-fil>, <N> av <N> funnet
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testcaser-intern
- **Sporing**:

  | Nr | Feature-ID | Regel | Scenario |
  |---|---|---|---|
  | 1.1 | `@DOM-SUB-KAP-NNN` | <regeltittel> | <scenariotittel fra kravet> |

---

Intern akseptansetest av «<leveranse>». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](<Confluence-url til testplanen>). Felt med gul bakgrunn fylles ut av teamet før testen.

## Slik tester du

- Ta testcasene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med alvorlighetsgrad. Spørsmål underveis tas i Slack-tråden «Akseptansetesting <leveranse>».

## Testcaser

<Med scope: «## Oppgave: <tittel>» over kravene i hver oppgave, i rekkefølgen i scope-tabellen.>

### Del <n>: <tittel på kravet> (<feature-fil>)

#### Regel: <regeltittel>

| Nr | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| <n>.1 | <scenariotittel> | 1. Logg inn som testbruker <nr> (<navn>, <rolle> ved <organisasjon>). <br>2. Gå til «…». <br>3. Skriv inn «…» i «…». <br>4. Velg «Lagre». <br>5. Gå ut av …, og åpne … igjen. | <det testeren ser> | | |
| <n>.2a | <scenariotittel> (<eksempel>) | … | … | | |
| | | *Gjør klar til neste test: …* | | | |

<Et krav uten `Regel:` får én tabell rett under kravet.>

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| <med vanlige ord> | <kort, uten tagger: ikke avklart ennå / kommer senere / testes i en annen leveranse> |

## Funn

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|
| | | | | | | | |

<Tabellen «Alvorlighetsgrad» fra `alvorlighetsgrad.md`, ordrett.>

## Andre funn

Det du oppdager som ikke gjelder testcasene, for eksempel brukervennlighet, eller et tilfelle kravet ikke dekker. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et viktig tilfelle, legges det inn i kravet.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
```

## Nummerering

- `<del>.<n>`: delen er kravet, nummerert fra 1 i rekkefølgen i testplanen. `n` løper gjennom hele kravet, ikke per regel, så nummeret er unikt.
- En `Scenariomal:` gir én testcase per eksempelrad: `1.3a`, `1.3b`, med verdiene fra raden i scenariotittelen og stegene.
- Rader for opprydding («Gjør klar til neste test») har ikke nummer.
