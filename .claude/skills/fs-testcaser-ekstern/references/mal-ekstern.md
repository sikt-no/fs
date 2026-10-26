# Mal: Ekstern akseptansetest

For erfarne brukere fra lærestedene og andre eksterne parter, for eksempel HK-dir i opptak. Sikt leder testen og legger til rette. Den er lettere enn den interne med vilje: testerne skal komme raskt i gang, og skal ikke trenge bakgrunnen for leveransen.

Fra [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326), fase 4:

- **Grunnlag:** de eksterne partene har egne krav og akseptansekriterier, og lager eller eier testcasene sine. Feature-filene våre er ikke grunnlaget. Testcasene her er et forslag å starte fra.
- **Hvilke scenarioer, hvor grundig og rekkefølge:** partene bestemmer. Forslaget er hovedflyten i leveransene som testes, i rekkefølgen i arbeidsprosessen, med flere scenarioer satt sammen til én testcase.
- **Hvor grundig:** feilsituasjonene er testet i den agentiske funksjonstesten (fase 2).
- **Sikt leverer:** testmiljø, testdata og testbrukere, flytbeskrivelsene fra den interne testen, og rapportene fra fase 2 og 3, så partene ser hva som er testet.
- **Funn:** avvik fra våre krav (feil) og krav vi ikke har (endringsforslag, som går til kravarbeidet). Samme maler og alvorlighetsgrader som i den interne testen, og en fast kanal for tilbakemeldinger.

Og:

- **Ingen intern informasjon:** Feature-ID-er, scope-id-er, tagger, commits, Jira, GitHub, feature-flagg, kodeverdier og verify-resultater. Sporingen står i metadataene.
- **Kort.** Sikt mot høyst 10 testcaser og under én time. Blir det mer, foreslå å dele i flere økter.

I fila skrives stegene i én tabellcelle, nummerert og skilt med `<br>`. Ved publisering blir de en nummerert liste i cella (se `confluence.md`).

Fila skrives til `akseptansetest/<testplan-slug>/testcaser-ekstern.md`. Alt over den første streken er metadata for repoet, og publiseres ikke. Flytbeskrivelsene til partene står i en egen fil, `flytbeskrivelser-ekstern.md` (malen står under).

```markdown
# Ekstern akseptansetest – <leveranse>

- **Nivå**: ekstern (fase 4)
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Scope**: @scope-<slug>[, …]
- **Krav**: <N> feature-filer, commit `<sha>` (<YYYY-MM-DD>)
- **Bygger på**: [intern akseptansetest](testcaser-intern.md), [testrapport](testrapport-intern-<dato>.md): <utfall>, [agentisk testrapport](testrapport-agentisk-<dato>.md)
- **Flytbeskrivelser**: [flytbeskrivelser-ekstern.md](flytbeskrivelser-ekstern.md)
- **Partenes krav**: <fil eller side> | ikke mottatt ennå | ingen
- **Testere**: <HK-dir, læresteder>
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testcaser-ekstern
- **Sporing**:

  | Nr | Steg i oppgaven | Feature-ID | Scenario | Intern |
  |---|---|---|---|---|
  | 1 | a | `@DOM-SUB-KAP-NNN` | <scenariotittel fra kravet> | 1.1 |
  | 1 | b | `@FLY-PRO-FLY-NNN` | <fasen>: <scenariotittel fra flyten> | 4.1 |

---

Velkommen til akseptansetesten av <leveranse>. I testen sjekker du om løsningen dekker det du skal bruke den til, etter deres egne krav. Du trenger ikke kjenne bakgrunnen for leveransen.

Testcasene under er et forslag fra Sikt. Dere bestemmer selv hva dere tester, hvor grundig og i hvilken rekkefølge: bruk forslaget som det er, endre det, eller legg til egne testcaser i «Testcaser fra partene».

## Før du starter

| Felt | Innhold |
|---|---|
| Hva er laget | <2–3 setninger med vanlige ord: hva du kan gjøre, og hvor i løsningen> |
| Hvor du tester | [<url>](<url>) |
| Dette kan du ikke gjøre i testen | - <kort> <br>- <…> |
| Tid | Ca. <N> minutter. Frist: <dato> |
| Hva Sikt har testet | [Flytbeskrivelser og testrapporter](<url>) |
| Spørsmål og tilbakemeldinger | <kontaktperson>, i <fast kanal> |

## Slik fyller du ut

1. Ta testcasene i rekkefølge, og følg stegene slik de står.
2. Hver testcase er en oppgave du gjør i løsningen. Den har flere deler, og hver del har sin egen rad med «Faktisk resultat» og «Status».
3. Skriv det du så i «Faktisk resultat», og Bestått, Ikke bestått eller Ikke testet i «Status».
4. Sjekk at det du har lagret, står der når du åpner siden igjen.
5. Stemmer noe ikke, skriv det i «Funn»: hva du gjorde, hva du forventet og hva du fikk. Ta skjermbilde hvis du kan. Velg «Avvik fra krav» når løsningen ikke gjør det den skal, og «Endringsforslag» når du savner noe som ikke er avtalt.

## Testcaser

### <Nr>. <Oppgaven i arbeidsprosessen, med vanlige ord> (ca. <N> minutter)

**Hensikt:** <hva testeren skal få til, og hvorfor det er viktig i arbeidsprosessen>

**Testdata:** testbruker <nr> (<navn>, <rolle> ved <organisasjon>). Bruker: <data som må finnes>. Lager: <data som de neste testcasene trenger>.

| Del | Hva du gjør | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| <Nr>a | <med vanlige ord> | 1. Logg inn som testbruker <nr> (<navn>, <rolle> ved <organisasjon>). <br>2. Gå til «…». <br>3. … | <det du ser> | | |
| <Nr>b | <med vanlige ord> | 4. … <br>5. … | <det du ser> | | |

## Testcaser fra partene

<Tom ved utsendelse. Partene legger inn egne testcaser etter sine egne krav, med samme tabell og kolonner som over.>

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Feilmeldinger og sperrer | Testet i den agentiske funksjonstesten |
| <med vanlige ord> | <kommer senere / gjelder ikke dere / testes på en annen måte> |

## Funn

| # | Testcase | Fase funnet | Funntype | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|---|---|
| | | 4. Ekstern | <Avvik fra krav / Endringsforslag> | | | | | | |

<Tabellene «Funntype» og «Alvorlighetsgrad» fra `alvorlighetsgrad.md`, ordrett. Et endringsforslag går til kravarbeidet, og har ikke alvorlighetsgrad «Stopper» uten at partene sier det.>

## Andre funn og erfaringer

Her skriver du det du oppdager som ikke står i testcasene, for eksempel om brukervennlighet, eller om du savner noe i arbeidsprosessen.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
```

## Nummerering

- Testcasene nummereres fra 1. Delene (ett scenario hver) får bokstav: `1a`, `1b`, `1c`.
- Stegene løper gjennom hele testcasen, så del `1b` fortsetter der `1a` slapp.
- En testcase som følger en flyt, har delene i rekkefølgen i flyten. Scenarioet i flyten er en egen del, og står i sporingen med flyt-ID-en og fasen.
- Sporingen har en rad per del. Feature-ID-ene står bare i metadataene, ikke på siden til partene.

## Flytbeskrivelser til partene

Eksporten av flytene fra den interne testen, og oversikten over hva Sikt har testet. Den gis til partene sammen med testsiden, så de ser hva som er testet, og kan bruke flytene som utgangspunkt for sine egne testcaser. Fila skrives til `akseptansetest/<testplan-slug>/flytbeskrivelser-ekstern.md`. Alt over den første streken er metadata for repoet, og publiseres ikke. Siden har ingen Feature-ID-er, scope-id-er, tagger, Jira-saker eller kodeverdier.

```markdown
# Flytbeskrivelser – <leveranse>

- **Nivå**: ekstern (fase 4), vedlegg til testcaser-ekstern.md
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Bygger på**: [testcaser-intern.md](testcaser-intern.md), flytene i «Flyter» i testplanen, og rapportene: [verifisering](<fil>), [agentisk](testrapport-agentisk-<dato>.md), [intern](testrapport-intern-<dato>.md)
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testcaser-ekstern
- **Sporing**:

  | Beskrivelse | Flyt | Testcase intern |
  |---|---|---|
  | <tittel på siden> | `@FLY-PRO-FLY-NNN` | 1 |

---

Flytbeskrivelser for <leveranse>. Her ser du hva som er laget, hvordan arbeidet går fra start til slutt, og hva Sikt har testet, så du kan bruke det når du planlegger testene dine.

## <Flyten med vanlige ord, f.eks. «Fra opprettet opptak til tilbud»>

**Hva flyten handler om:** <2–3 setninger med vanlige ord>

| Trinn | Hvem | Hva skjer | Hva det neste trinnet bruker |
|---|---|---|---|
| 1 | <rolle med vanlige ord> | <hva brukeren gjør og ser> | <det som er laget, og som neste trinn bruker> |

**Dette kan du ikke gjøre i testen:** <kjente mangler som berører flyten, uten saksnummer, eller «Ingen»>

## Hva Sikt har testet

| Fase | Hva | Utfall | Funn som står igjen |
|---|---|---|---|
| Kontroll av at alt er laget | <N> av <N> funksjoner funnet i løsningen | <klar / ikke klar> | <kort, eller «Ingen»> |
| Funksjonstest (agent) | <N> testcaser, med gyldige og ugyldige data, og feilmeldinger | <utfall> | <kort, eller «Ingen»> |
| Intern akseptansetest | <N> arbeidsoppgaver testet av domeneekspertene | <utfall> | <kort, eller «Ingen»> |

Rapportene: [funksjonstesten](<url>), [den interne testen](<url>).

## Partenes krav og hva Sikt har testet

<Bare når partene har sendt egne krav eller akseptansekriterier. Uten: «Partene bestemmer selv hva de tester.» Ikke mottatt ennå: `[Fylles ut: partenes krav]`.>

| Ditt krav | Testet av Sikt | Hvor |
|---|---|---|
| <partens krav med deres ord> | <ja / delvis / nei / ikke kartlagt> | <flyt og testcase, med vanlige ord> |
```
