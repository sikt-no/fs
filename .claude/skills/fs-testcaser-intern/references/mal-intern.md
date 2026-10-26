# Mal: Intern akseptansetest

For testansvarlig (domeneekspert) og de andre interne testerne. Formen er den [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326) gir i *Fase 3* og *Testplan og sluttrapport*: én testcase per flyt, med flere scenarioer i rekkefølgen arbeidsprosessen går, og eget resultat per scenario.

Siden er for testerne. Testbeskrivelsen (miljø, versjon, flagg, testbrukere, testdata, roller) står i testplanen, og siden lenker dit i stedet for å gjenta den. Beslutningen står i testrapporten.

Fase 3 tester flyter og avhengigheter. Feltvalidering, feilsituasjoner og grenseverdier er testet i fase 2, og tilgang i fase 1, og tas ikke med her. Testansvarlig kan ta stikkprøver.

I fila skrives stegene i én tabellcelle, nummerert og skilt med `<br>`. Ved publisering blir de en nummerert liste i cella (se `confluence.md`).

Fila skrives til `akseptansetest/<testplan-slug>/testcaser-intern.md`. Alt over den første streken er metadata for repoet, og publiseres ikke. Sporingen fra testcase og del til krav står i metadataene, så `fs-testrapport` kan telle per flyt og krav.

```markdown
# Intern akseptansetest – <leveranse>

- **Nivå**: intern (fase 3)
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Scope**: @scope-<slug>[, …] | –
- **Krav**: <N> feature-filer, commit `<sha>` (<YYYY-MM-DD>)
- **Verifisering**: <verify-fil>, <N> av <N> funnet
- **Agentisk funksjonstest**: <testrapport-agentisk-fil>, utfall: <utfall>
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testcaser-intern
- **Sporing**:

  | Nr | Del | Feature-ID | Regel (fase) | Scenario |
  |---|---|---|---|---|
  | 1 | a | `@FLY-PRO-FLY-NNN` | <regeltittel (fasen)> | <scenariotittel fra flyten> |
  | 1 | b | `@DOM-SUB-KAP-NNN` | <regeltittel> | <scenariotittel fra kravet> |
  | R1 | a | `@FLY-PRO-FLY-NNN` | <regeltittel (fasen)> | <scenariotittel fra flyten> |

---

Intern akseptansetest av «<leveranse>». Testbeskrivelsen, testbrukerne og testdataene står i [testplanen](<Confluence-url til testplanen>). Felt med gul bakgrunn fylles ut av teamet før testen.

## Slik tester du

- Dette er en test av at leveransen henger sammen i arbeidsprosessen og med resten av FS. Enkeltfunksjoner, obligatoriske felt og feilmeldinger er testet i den agentiske funksjonstesten, og testes ikke på nytt her. Du kan ta stikkprøver.
- Ta testcasene i rekkefølge, og følg stegene slik de står. Virker ikke et steg, er det et funn. Ikke prøv deg fram en annen vei.
- Hver testcase er en oppgave i arbeidsprosessen, med flere deler. Hver del har sin egen rad med «Faktisk resultat» og «Status».
- Fyll ut «Faktisk resultat» med det du så, og «Status» med Bestått, Ikke bestått eller Ikke testet. Ved «Ikke testet», skriv hvorfor i «Faktisk resultat».
- Sjekk at det du har lagret, står der når du åpner siden igjen.
- Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men test resten av testcasene hvis det er mulig.
- Funn skrives i «Funn», med funntype, alvorlighetsgrad og fasen du fant det i («3. Intern»). Spørsmål underveis tas i Slack-tråden «Akseptansetesting <leveranse>».

## Avhengigheter

<Bare når testleder har vurdert at leveransen trenger et avhengighetskart. Ellers: «Ingen avhengighetskart for denne leveransen.»>

| Avhengighet | Type | Hvordan den sjekkes | Hvor |
|---|---|---|---|
| <med vanlige ord> | <annen modul / integrasjon / batchjobb / rapport / eksport / annet teams leveranse> | <hva testeren ser, eller hvem som sjekker> | <i testcase 1b / testes for seg, se «Avhengigheter som testes for seg»> |

## Testcaser

### <Nr>. <Oppgaven i arbeidsprosessen, med vanlige ord> (<flytens tittel>) (ca. <N> minutter)

**Hensikt:** <hva testeren skal få til, og hva det viser: at det som lages i ett steg, blir brukt i det neste>

**Testdata:** testbruker <nr> (<navn>, <rolle> ved <organisasjon>). Bruker: <data som må finnes>. Lager: <data de neste testcasene trenger>.

**Avhengigheter som sjekkes:** <fra «Avhengigheter», eller «Ingen»>

<Hele flyten / Fasene <fasene>>, se testplanen. <En setning om hvorfor delene testes i denne rekkefølgen.>

| Del | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| <Nr>a | <scenariotittel fra flyten eller kravet> | 1. Logg inn som testbruker <nr> (<navn>, <rolle> ved <organisasjon>). <br>2. Gå til «…». <br>3. Skriv inn «…» i «…». <br>4. Velg «Lagre». <br>5. Gå ut av …, og åpne … igjen. | <det testeren ser> | | |
| <Nr>b | <scenariotittel> (<eksempel>) | 6. Logg inn som testbruker <nr> (<navn>, <rolle> ved <organisasjon>). <br>7. Gå til «…». <br>8. Sjekk at «…» står der, uten at du har gjort noe mer. | <det den neste aktøren ser: at tilstanden er brukt, ikke bare lagret> | | |
| | | *Gjør klar til neste test: …* | | | |

<Åpent spørsmål til <Nr>b: <spørsmålet med vanlige ord>. Står bare når delen har `@openquestion`.>

<Flere flyter: én testcase til, nummerert videre. Er en flyt for lang, del den mellom to faser, og la neste testcase bruke dataene fra den første (R10).>

### Regresjon

<Bare når leveransen endrer noe andre bygger på. Ellers utelates delen.>

### R<n>. <Oppgaven i arbeidsprosessen> (<flytens tittel>, levert tidligere)

**Hvorfor regresjon:** <hva leveransen endrer, og hvilken del av flyten som bygger på det>

**Testdata:** …

| Del | Scenario | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| R<n>a | <scenariotittel> | 1. … | … | | |

## Avhengigheter som testes for seg

<Bare når avhengighetskartet har avhengigheter som ikke sjekkes underveis i en flyt.>

| Nr | Avhengighet | Steg | Forventet resultat | Faktisk resultat | Status |
|---|---|---|---|---|---|
| A1 | <med vanlige ord> | 1. … | … | | |

## Ikke testbart nå

Scenarioene er laget, men kan ikke testes i testmiljøet ennå.

| Scenario | Hvorfor | Når det kan testes |
|---|---|---|

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Feltvalidering, feilmeldinger og grenseverdier | Testet i den agentiske funksjonstesten (fase 2) |
| <krav som ikke inngår i en flyt, med vanlige ord> | <venter på flyt / testes som egen oppgave / kommer senere> |
| <med vanlige ord> | <kort, uten tagger: ikke avklart ennå / kommer senere / testes i en annen leveranse> |

## Funn

| # | Testcase | Fase funnet | Funntype | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|---|---|
| | | 3. Intern | | | | | | | |

<Tabellene «Funntype» og «Alvorlighetsgrad» fra `alvorlighetsgrad.md`, ordrett.>

## Andre funn

Det du oppdager som ikke gjelder testcasene, for eksempel brukervennlighet, eller et tilfelle kravet ikke dekker. Kontaktpersonen vurderer om og hvor det følges opp. Mangler et viktig tilfelle, legges det inn i kravet.

| Hva gjorde du? | Hvor? | Hva vil du melde om? |
|---|---|---|
| | | |
```

## Nummerering

- Testcasene nummereres fra 1 i rekkefølgen i arbeidsprosessen, én per flyt (eller del av en flyt). Delene (ett scenario hver) får bokstav: `1a`, `1b`, `1c`.
- Stegene løper gjennom hele testcasen, så del `1b` fortsetter der `1a` slapp.
- En `Scenariomal:` som brukes i flyten, gir én del per eksempelrad som er med, med verdiene fra raden i scenariotittelen og stegene.
- Regresjonsflyter nummereres `R1`, `R2`, med delene `R1a`, `R1b`. Avhengigheter som testes for seg, nummereres `A1`, `A2`.
- Rader for opprydding («Gjør klar til neste test») har ikke nummer.
- Sporingen i metadataene har en rad per del: testcasenummer, bokstav, Feature-ID (kravet eller flyten scenarioet står i), regel og scenario.
