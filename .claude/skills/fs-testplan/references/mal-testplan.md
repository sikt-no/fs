# Mal: Testplan

Testplanen er hovedsiden for en leveranse i Confluence, og grunnlaget for testcasene i den agentiske funksjonstesten (fase 2), den interne akseptansetesten (fase 3) og den eksterne akseptansetesten (fase 4). Malen er utledet fra [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326) (*Testplan og sluttrapport*, og radene for hver fase) og «Mal: Testbeskrivelse» i [rutinen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5091196953).

Testplanen lages etter verifiseringen (fase 1), og bygger på resultatet. Testplanen planlegger: den sier hvilke krav og flyter som testes, hvordan testdata lages, og hva som skal til for å godkjenne. Testcasene lages av `fs-testcaser-cdp` (fase 2) og `fs-testcaser-intern` (fase 3), og står på undersider. Resultatene står på undersidene (testcasene og testrapportene), ikke her. Den eneste delen andre skills endrer, er sin egen rad i «Status i flyten» og raden i «Sporbarhet per krav».

Fila skrives til `akseptansetest/<testplan-slug>/testplan.md`. Alt over den første streken er metadata for repoet, og publiseres ikke.

```markdown
# Testplan – <leveranse>

- **Leveranse**: scope | oppgave | mappe | feature-fil
- **Kilde**: `@scope-<slug>` | `tasks/<domene>/<slug>` | `krav/<sti>/` | `krav/<sti>/<fil>.feature`[, …]
- **Scope**: @scope-<slug>[, @scope-<slug> …] | –   (scope-id-ene kravene har)
- **Scope-fil**: [scope-<slug>](../../tasks/<domene>/scope-<slug>.md)[, …]   (når kravene har scope)
- **Oppgaver**: [<domene>/<slug>](../../tasks/<domene>/<slug>/oppgave.md)[, …]   (når det finnes oppgaver)
- **Krav**: <N> feature-filer, <N> `@implemented`, <N> delvis levert, <N> flyter, commit `<sha>` (<YYYY-MM-DD>)
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

Testbrukerne finnes i alle relevante roller ved organisasjonene kravet gjelder. Antallet bestemmes per krav ut fra tilgangsmatrisen: rolle × organisasjon (egen organisasjon, en annen organisasjon, ingen tilgang), så fase 2 kan teste roller med og uten tilgang.

Kolonnene `Nøkkel` (etter `Nr`), `Innlogging` og `Start-URL` (etter `Organisasjon`) er alltid med, fordi den agentiske funksjonstesten (fase 2) bruker dem:

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | <nøkkel> | <navn> | <rolle fra kravene> | <organisasjon> | <verdi i «Overstyrt bruker», Chrome-profil eller Feide-ID> | <URL> | <hvilke krav eller deler> |

Nøkkelen er et stabilt navn i kebab-case for rollen (`brukeradministrator-alle-miljoer`), og endres ikke om navnet på testbrukeren byttes. Aldri passord i testplanen. Se [`roller-og-testdata.md`](../../../references/akseptansetest/roller-og-testdata.md).

#### Tilgangsmatrise

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@DOM-SUB-KAP-NNN` | <rolle> | ser / endrer / ingen tilgang | ser / endrer / ingen tilgang | <Nr> |

### Testdata

Testautomatiseringen (fase 2) lager sine egne testdata, manuelt eller seedet via API, og stoler ikke på data som allerede finnes. Testdata er syntetiske. Vurderingen gjøres per krav (eller per gruppe av krav som deler data):

| Krav | Hva må opprettes | Opprettes av | Hvordan ryddes eller tilbakestilles | Kan testen kjøres på nytt |
|---|---|---|---|---|
| `@DOM-SUB-KAP-NNN` | <opptak, søker, regelverkssamling …, med verdiene som trengs> | Manuelt / API (<mutation eller endepunkt>) / Finnes i testmiljøet | <slettes, settes tilbake, ny unik verdi per kjøring, kan ikke ryddes> | Ja / Nei: <grunn> |

Kan dataene ikke slettes (slik at en ny kjøring finner dem igjen på navn), skal navnene gjøres unike per kjøring, eller testen forutsetter tilbakestilling av miljøet. Oppretter agenten dataene gjennom API-et, står kallet i raden, så testcasene kan gjenbruke det.

Dataene testcasene bruker, står med nøkkel:

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Opprettes av | Brukes av | Kan settes tilbake |
|---|---|---|---|---|---|---|---|---|
| <opptak, søker, regelverkssamling …> | <nøkkel> | <navn> | <lenke eller sted> | <hvordan objektet åpnes> | <hva testen forutsetter> | Manuelt / API / Finnes i testmiljøet | <Feature-ID og scenario, eller testcase-Nr> | Ja / Nei / <hvordan> |

Kolonnene `Søk/URL`, `Utgangstilstand` og `Brukes av` står bare i testplanen, ikke i testcasene for den interne og den eksterne testen.

## Omfang

Det som testes, er kravene som er `@implemented`, og de leverte delene i krav som er delvis levert. Feature-ID-ene her er kravene resten av testflyten bruker.

<Én underseksjon per gruppe: per oppgave i scope-tabellen (scope), per kapabilitetsmappe i rekkefølgen i `krav/` (mappe). Én oppgave eller enkeltfiler: bare tabellen, uten underseksjon.>

### <Oppgave eller kapabilitet>

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [<tittel>](<lenke til GitHub på commiten>) | `@DOM-SUB-KAP-NNN` | `@implemented` \| `@in-progress` (delvis levert) | <N> |

Åpent spørsmål: `@DOM-SUB-KAP-NNN` «<scenario eller regel>»: <spørsmålet>. Testes som det står.   [én linje per scenario eller regel i testen med `@openquestion`]

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av de samme kravene: `npx playwright test --grep @scope-<slug>` (eller `--grep "@<ID-1>|@<ID-2>"` uten scope). Med flyter: `--grep "@scope-<slug>|@FLY-<ID>"`.

### Åpne spørsmål

`@openquestion` stopper ikke testen: delen er klar til implementasjon, og testes som den står. Oversikten viser hvor mye som står åpent. Tallene regnes fra kravfilene og verify-rapporten.

| Krav | Feature-ID | Regler med åpent spørsmål | Scenarioer med åpent spørsmål | Scenarioer i testen |
|---|---|---|---|---|
| [<tittel>](<lenke>) | `@DOM-SUB-KAP-NNN` | <n> av <N> | <n> av <N> | <N> |

Ingen åpne spørsmål.                                                   <når ingen krav har `@openquestion` i testen>

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

### <Tittel på flyten> (`@FLY-PRO-FLY-NNN`, `@implemented` | `@planned`)

- **Testes**: hele flyten | deler av flyten (fasene <fasene>)
- **Hvorfor**: <flyten er levert / <n> av <N> faser er levert / teamet valgte fasene i leveransen>

| Fase | Bygger på | Fase levert | I leveransen | Scenarioer i testen |
|---|---|---|---|---|
| <regeltittel> | `@DOM-SUB-KAP-NNN` (`@implemented`), `@DOM-SUB-KAP-NNN` (`@planned`) | ja / nei / mangler krav | ja / nei | <N> / – |

Ingen av kravene er med i en flyt.                                     <når det ikke er flyter>

### Vurdering per krav (fase 3)

Den interne akseptansetesten tester flyter og avhengigheter. Per krav vurderes det hva som testes:

| Krav | Inngår i flyt | Vurdering |
|---|---|---|
| `@DOM-SUB-KAP-NNN` | <flyt, eller «Ingen»> | Flyten testes / Flyten testes ikke: <grunn> / Ny flyt bør lages (`fs-krav`, modus E) / Kobles til flyten <tittel> |

Scenarioene som tas med i fase 3, er de som inngår i flytene, ikke alle. Er en tidligere levert flyt avhengig av noe leveransen endrer, står den med som regresjon (finn dem med `grep -rn "@depends-on-<Feature-ID>" krav/_Flyter/`).

### Avhengighetskart

Testleder vurderer om leveransen trenger et avhengighetskart. Teamet lister da det leveransen bygger på eller påvirker utenfor brukerens flyt, og det sjekkes underveis i flytene der det er mulig, ellers for seg.

| Avhengighet | Type | Hvordan sjekkes det |
|---|---|---|
| <annen modul i FS, integrasjon, batchjobb, rapport, eksport eller annet teams leveranse> | <type> | I flyt <tittel> / Testes for seg: <hvordan> |

Ikke aktuelt: <grunn>                                                  <når testleder har vurdert at det ikke trengs>

## Venter på verifisering

Kravene er laget, men `fs-verify` har ikke funnet alt ennå. De tas med i testen når de er `@implemented`. For et krav som er delvis levert, står delene som ikke er levert, her.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [<tittel>](<lenke>) | `@DOM-SUB-KAP-NNN` | `@in-progress` | <hele kravet / delen «<regel>»> |

Ingen.                                                                  <når tabellen er tom>

## Regler uten scenario

`fs-verify` rapporterer regler i koden som ikke har et scenario i kravet, for eksempel valideringer og tilgangssjekker. De er input til de agentiske testcasene (fase 2).

| Krav | Regel i koden | Funnet i | Testes i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@DOM-SUB-KAP-NNN` | <validering eller tilgangssjekk> | `<repo>/<fil>:<linje>` | ja / nei: <grunn> | ja (`fs-krav`) / nei |

Ingen.                                                                  <når verify-rapporten ikke fant noen>

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| <krav eller scenario> | <venter på verifisering / ikke avklart ennå: åpent spørsmål / kommer senere / skal fjernes> |
| <flyt: fase eller overlevering> | <fasen er ikke levert / fasen mangler krav / overleveringen er ikke funnet / fasen er ikke i leveransen / kjent brudd> |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | <navn> | Eier testen fra start til beslutning. Har ansvaret for at agenten blir kjørt og tester riktig (kjøringen kan gjøres av andre), går gjennom testcasene før kjøringen og funnene etterpå, tar stikkprøver av beståtte testcaser etter en risikovurdering, og skriver beslutningen i testrapporten |
| Kjører av agenten | <navn> | Starter den agentiske funksjonstesten (fase 2) |
| Kontaktperson i teamet | <navn> | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | <navn> | <hvilke deler> |
| Eksterne testere | <HK-dir, læresteder> | <bare når leveransen skal til ekstern akseptansetest> |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Agentisk funksjonstest | <dato for kjøringen, og hvem som kjører agenten> |
| Intern akseptansetest | <dato og klokkeslett>. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | <dato, eller «Avklares med de eksterne partene», eller «Ikke aktuell»> |
| Spørsmål underveis | Slack-tråden «Akseptansetesting <leveranse>» i <kanal> |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdata kan opprettes av testautomatiseringen (manuelt eller seedet via API), og vurderingen i «Testdata» er fylt ut | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt, så testen kan kjøres på nytt | [Fylles ut av teamet] |
| 4 | Testbrukerne finnes i alle relevante roller ved organisasjonene kravene gjelder (tilgangsmatrisen) | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | <fra verify-rapporten i fase 1, og fase 2, eller «Venter»> |
| 6 | De agentiske testcasene (`fs-testcaser-cdp`) er laget, og testansvarlig og teamet har gått gjennom dem før kjøringen | Venter |
| 7 | Flyttestcasene for den interne akseptansetesten (`fs-testcaser-intern`) er laget og gått gjennom av testansvarlig | Venter |
| 8 | CDP-agenten kan logge inn som hver testbruker, og nøklene i testbrukere og testdata er utfylt | [Fylles ut av teamet] |
| 9 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |
| 10 | <Kjent brudd i flyten «<tittel>»: <bruddet, med saken> er løst> | <Venter / Løst>   (én rad per kjent brudd, bare når flyten har det, nummerert etter de andre radene) |

## Kriterier for godkjent

Testansvarlig skriver hva som skal til for at testen blir godkjent, helst før utviklingen starter. Kriteriene per fase er et utgangspunkt, og kan strammes inn:

| Fase | Ferdig når |
|---|---|
| 1. Verifisering | Alle scenarioene er funnet, og en annen person har kontrollert rapporten. Åpne spørsmål står i rapporten, men stopper ikke |
| 2. Agentisk funksjonstest | Alle testcasene er kjørt, ingen funn med «Stopper» står åpne, og testansvarlig har gått gjennom rapporten. Det er inngangskriteriet til intern akseptansetest |
| 3. Intern akseptansetest | Beslutningen er tatt: godkjent, godkjent med forbehold eller ikke godkjent |
| 4. Ekstern akseptansetest | De eksterne partene har akseptert mot sine egne krav |

Leveransespesifikke kriterier:

[Fylles ut av testansvarlig]

## Funn og alvorlighetsgrad

<Tabellen «Alvorlighetsgrad» og avsnittet om «Stopper» fra `alvorlighetsgrad.md`, ordrett.>

## Beslutning

<Tabellen «Beslutning» fra `alvorlighetsgrad.md`, ordrett. Selve beslutningen står i testrapportene.>

## Status i flyten

| Fase | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | <lenke til verify-rapporten> | Alt funnet / <N> ikke funnet, <N> usikker / Ikke kjørt | <dato i rapporten> |
| Testplan | (denne siden) | Laget | <YYYY-MM-DD> |
| 2. Agentisk funksjonstest | – | Venter | |
| 3. Intern akseptansetest | – | Venter | |
| 4. Ekstern akseptansetest | – | Venter / Ikke aktuell | |

Testrapportene (verifisering, agentisk, intern og ekstern) står som undersider, og lenken står i raden for fasen.

## Sporbarhet per krav

Fylles ut av rapportene etter hvert som fasene er ferdige. Raden følger scenarioet fra kravet til koden og til testen.

| Krav | Scenario | Kode (fase 1) | Testcase og resultat (fase 2) | Flyt (fase 3) |
|---|---|---|---|---|
| `@DOM-SUB-KAP-NNN` | <scenario> | `<repo>/<fil>:<linje>` | <Nr, resultat> | <flyt og fase, eller «–»> |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
```
