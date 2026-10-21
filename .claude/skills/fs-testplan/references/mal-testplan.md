# Mal: Testplan

Testplanen er hovedsiden for en leveranse i Confluence, og grunnlaget for testcasene i den interne og den eksterne akseptansetesten. Malen er utledet fra [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850) (*Testplan og sluttrapport*, og radene for hvert trinn) og «Mal: Testbeskrivelse» i [rutinen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5091196953).

Testplanen er planen før testen. Resultatene står på undersidene (testcasene og testrapportene), ikke her. Den eneste delen andre skills endrer, er sin egen rad i «Status i flyten».

Fila skrives til `akseptansetest/<testplan-slug>/testplan.md`. Alt over den første streken er metadata for repoet, og publiseres ikke.

```markdown
# Testplan – <leveranse>

- **Leveranse**: scope | oppgave | mappe | feature-fil
- **Kilde**: `@scope-<slug>` | `tasks/<domene>/<slug>` | `krav/<sti>/` | `krav/<sti>/<fil>.feature`[, …]
- **Scope**: @scope-<slug>[, @scope-<slug> …] | –   (scope-id-ene kravene har)
- **Scope-fil**: [scope-<slug>](../../tasks/<domene>/scope-<slug>.md)[, …]   (når kravene har scope)
- **Oppgaver**: [<domene>/<slug>](../../tasks/<domene>/<slug>/oppgave.md)[, …]   (når det finnes oppgaver)
- **Krav**: <N> feature-filer, <N> `@implemented`, commit `<sha>` (<YYYY-MM-DD>)
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testplan

---

Testplan for «<leveranse>». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | <2–4 setninger: hva brukeren kan gjøre, og hvor i løsningen> |
| Versjon | <versjon, release eller dato for deploy> |
| Testmiljø | [<url>](<url>) |
| Feature-flagg | <flagg som må være på, eller «Ingen»> |
| Kilde | <scopet, oppgaven, mappa eller filene, med lenke til GitHub> |
| Scope | `@scope-<slug>` · [scope-fila på GitHub](<lenke>), eller «Ingen» |
| Saker | <GitHub-issue> · <Jira> |
| Berører andre team | <fra `design.md` / `utforing.md`, eller «Nei»> |
| Kjente begrensninger | <det som ikke virker eller ikke kan testes i miljøet> |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | <navn> | <rolle fra kravene> | <organisasjon> | <hvilke krav eller deler> |

Testbrukerne finnes i minst to organisasjoner, så vi kan teste at ingen ser data de ikke skal se.

### Testdata

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| <opptak, søker, regelverkssamling …> | <navn> | <lenke eller sted> | Ja / Nei / <hvordan> |

## Omfang

Det som testes, er kravene som er `@implemented`. Feature-ID-ene her er kravene resten av testflyten bruker.

<Én underseksjon per gruppe: per oppgave i scope-tabellen (scope), per kapabilitetsmappe i rekkefølgen i `krav/` (mappe). Én oppgave eller enkeltfiler: bare tabellen, uten underseksjon.>

### <Oppgave eller kapabilitet>

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [<tittel>](<lenke til GitHub på commiten>) | `@DOM-SUB-KAP-NNN` | `@implemented` | <N> |

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet, har åpne spørsmål eller er demo, og som ikke er under endring. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av de samme kravene: `npx playwright test --grep @scope-<slug>` (eller `--grep "@<ID-1>|@<ID-2>"` uten scope)

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke bekreftet dem ennå. De tas med i testen når de er `@implemented`.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [<tittel>](<lenke>) | `@DOM-SUB-KAP-NNN` | `@in-progress` | <hele kravet / delen «<regel>»> |

Ingen.                                                                  <når tabellen er tom>

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| <krav eller scenario> | <venter på verifisering / ikke avklart ennå: åpent spørsmål / kommer senere / skal fjernes> |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | <navn> | Eier testen fra start til beslutning, og skriver beslutningen i testrapporten |
| Kontaktperson i teamet | <navn> | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | <navn> | <hvilke deler> |
| Eksterne testere | <HK-dir, læresteder> | <bare når leveransen skal til ekstern akseptansetest> |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Intern akseptansetest | <dato og klokkeslett>. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | <dato, eller «Avklares med de eksterne partene», eller «Ikke aktuell»> |
| Spørsmål underveis | Slack-tråden «Akseptansetesting <leveranse>» i <kanal> |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene er identifisert og tilgjengelige | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt | [Fylles ut av teamet] |
| 4 | Testbrukerne finnes i rollene leveransen gjelder, i minst to organisasjoner | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | <fra steg 2 og 3, eller «Venter»> |
| 6 | Testcasene er laget og gått gjennom av testansvarlig | Venter |
| 7 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |

## Kriterier for godkjent

Testansvarlig skriver hva som skal til for at testen blir godkjent, helst før utviklingen starter.

[Fylles ut av testansvarlig]

## Funn og alvorlighetsgrad

<Tabellen «Alvorlighetsgrad» og avsnittet om «Stopper» fra `alvorlighetsgrad.md`, ordrett.>

## Beslutning

<Tabellen «Beslutning» fra `alvorlighetsgrad.md`, ordrett. Selve beslutningen står i testrapportene.>

## Status i flyten

| Steg | Side | Status | Dato |
|---|---|---|---|
| 1. Testplan | (denne siden) | Laget | <YYYY-MM-DD> |
| 2. Verifisering (`fs-verify`) | – | Venter | |
| 3. Testrapport – verifisering | – | Venter | |
| 4. Intern akseptansetest | – | Venter | |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | – | Venter / Ikke aktuell | |
| 7. Testrapport – ekstern | – | Venter / Ikke aktuell | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
```
