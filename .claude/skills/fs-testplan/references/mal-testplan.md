# Mal: Testplan

Testplanen er hovedsiden for en leveranse i Confluence, og grunnlaget for testcasene i den interne og den eksterne akseptansetesten. Malen er utledet fra [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850) (*Testplan og sluttrapport*, og radene for hvert trinn) og «Mal: Testbeskrivelse» i [rutinen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5091196953).

Testplanen lages etter verifiseringen (steg 1), og bygger på resultatet. Testplanen er planen før testen. Resultatene står på undersidene (testcasene og testrapportene), ikke her. Den eneste delen andre skills endrer, er sin egen rad i «Status i flyten».

Fila skrives til `akseptansetest/<testplan-slug>/testplan.md`. Alt over den første streken er metadata for repoet, og publiseres ikke.

```markdown
# Testplan – <leveranse>

- **Leveranse**: scope | oppgave | mappe | feature-fil
- **Kilde**: `@scope-<slug>` | `tasks/<domene>/<slug>` | `krav/<sti>/` | `krav/<sti>/<fil>.feature`[, …]
- **Scope**: @scope-<slug>[, @scope-<slug> …] | –   (scope-id-ene kravene har)
- **Scope-fil**: [scope-<slug>](../../tasks/<domene>/scope-<slug>.md)[, …]   (når kravene har scope)
- **Oppgaver**: [<domene>/<slug>](../../tasks/<domene>/<slug>/oppgave.md)[, …]   (når det finnes oppgaver)
- **Krav**: <N> feature-filer, <N> `@implemented`, <N> flyter, commit `<sha>` (<YYYY-MM-DD>)
- **Verifisering**: [verify-<YYYY-MM-DD>-<HHMM>.md](<sti til rapporten>)[, …] | –   (verify-rapportene testplanen bygger på)
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testplan

---

Testplan for «<leveranse>». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | <2–4 setninger: hva brukeren kan gjøre, og hvor i løsningen> |
| Versjon | <versjon, release eller dato for deploy> |
| Testmiljø | [<url>](<url>) (alltid et testmiljø, aldri produksjon) |
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

**Bare når teamet har svart ja på CDP (steg 4b):** legg til kolonnene `Nøkkel` (etter `Nr`), `Innlogging` og `Start-URL` (etter `Organisasjon`):

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | <nøkkel> | <navn> | <rolle fra kravene> | <organisasjon> | <verdi i «Overstyrt bruker», Chrome-profil eller Feide-ID> | <URL> | <hvilke krav eller deler> |

Nøkkelen er et stabilt navn i kebab-case for rollen (`brukeradministrator-alle-miljoer`), og endres ikke om navnet på testbrukeren byttes. Aldri passord i testplanen. Ved nei står kolonnene ikke i testplanen. Se [`roller-og-testdata.md`](../../../references/akseptansetest/roller-og-testdata.md).

### Testdata

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| <opptak, søker, regelverkssamling …> | <navn> | <lenke eller sted> | Ja / Nei / <hvordan> |

**Bare når teamet har svart ja på CDP:** legg til kolonnene `Nøkkel` (etter `Hva`), og `Søk/URL`, `Utgangstilstand` og `Brukes av` (etter `Hvor`):

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av | Kan settes tilbake |
|---|---|---|---|---|---|---|---|
| <opptak, søker, regelverkssamling …> | <nøkkel> | <navn> | <lenke eller sted> | <hvordan objektet åpnes> | <hva testen forutsetter> | <Feature-ID og scenario, eller testcase-Nr> | Ja / Nei / <hvordan> |

Kolonnene for CDP står bare i testplanen, ikke i testcasene for den eksterne testen.

## Omfang

Det som testes, er kravene som er `@implemented`. Feature-ID-ene her er kravene resten av testflyten bruker.

<Én underseksjon per gruppe: per oppgave i scope-tabellen (scope), per kapabilitetsmappe i rekkefølgen i `krav/` (mappe). Én oppgave eller enkeltfiler: bare tabellen, uten underseksjon.>

### <Oppgave eller kapabilitet>

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [<tittel>](<lenke til GitHub på commiten>) | `@DOM-SUB-KAP-NNN` | `@implemented` | <N> |

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet, har åpne spørsmål eller er demo, og som ikke er under endring. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av de samme kravene: `npx playwright test --grep @scope-<slug>` (eller `--grep "@<ID-1>|@<ID-2>"` uten scope). Med flyter: `--grep "@scope-<slug>|@FLY-<ID>"`.

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

### <Tittel på flyten> (`@FLY-PRO-FLY-NNN`, `@implemented` | `@planned`)

- **Testes**: hele flyten | deler av flyten (fasene <fasene>)
- **Hvorfor**: <flyten er levert / <n> av <N> faser er levert / teamet valgte fasene i leveransen>

| Fase | Bygger på | Fase levert | I leveransen | Scenarioer i testen |
|---|---|---|---|---|
| <regeltittel> | `@DOM-SUB-KAP-NNN` (`@implemented`), `@DOM-SUB-KAP-NNN` (`@planned`) | ja / nei / mangler krav | ja / nei | <N> / – |

Ingen av kravene er med i en flyt.                                     <når det ikke er flyter>

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [<tittel>](<lenke>) | `@DOM-SUB-KAP-NNN` | `@in-progress` | <hele kravet / delen «<regel>»> |

Ingen.                                                                  <når tabellen er tom>

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| <krav eller scenario> | <venter på verifisering / ikke avklart ennå: åpent spørsmål / kommer senere / skal fjernes> |
| <flyt: fase eller overlevering> | <fasen er ikke levert / fasen mangler krav / overleveringen er ikke funnet / fasen er ikke i leveransen / kjent brudd> |

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
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | <fra verify-rapporten i steg 1, og steg 3, eller «Venter»> |
| 6 | Testcasene er laget og gått gjennom av testansvarlig | Venter |
| 7 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |
| 8 | CDP-agenten kan logge inn som hver testbruker, og nøklene i testbrukere og testdata er utfylt (rad 8 tas bare med når teamet har valgt CDP) | [Fylles ut av teamet] |
| 9 | <Kjent brudd i flyten «<tittel>»: <bruddet, med saken>> er løst | <Venter / Løst>   (én rad per kjent brudd, bare når flyten har det, nummerert etter de andre radene) |

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
| 1. Verifisering (`fs-verify`) | <lenke til verify-rapporten> | Alt funnet / <N> ikke funnet, <N> usikker / Ikke kjørt | <dato i rapporten> |
| 2. Testplan | (denne siden) | Laget | <YYYY-MM-DD> |
| 3. Testrapport – verifisering | – | Venter | |
| 4. Intern akseptansetest | – | Venter | |
| 4b. CDP-kjøring (valgfri) | – | Venter / Ikke aktuell | |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | – | Venter / Ikke aktuell | |
| 7. Testrapport – ekstern | – | Venter / Ikke aktuell | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
```
