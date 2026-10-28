# Mal: Testplan

Testplanen er hovedsiden for en leveranse i Confluence, og grunnlaget for testcasene i den agentiske funksjonstesten (fase 2), den interne akseptansetesten (fase 3) og den eksterne akseptansetesten (fase 4). Malen er utledet fra [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326) (*Testplan og sluttrapport*, og radene for hver fase) og «Mal: Testbeskrivelse» i [rutinen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5091196953).

Testplanen lages etter verifiseringen (fase 1), og bygger på resultatet. Testplanen planlegger: den sier hvilke krav og flyter som testes, omfanget av testcasene som skal lages (*Testcaser som skal lages*), hvilke testbrukere og testdata testene trenger, og når fasene er ferdige. Selve testcasene lages av `fs-testcaser-cdp` (fase 2) og `fs-testcaser-intern` (fase 3), og står, med resultatene, på undersider og i `cdp-tester/`. Testplanen er hovedsiden, og lenker til dem. De eneste delene andre skills endrer, er sin egen rad i «Status i flyten», «Vedlegg» og radene i «Sporbarhet per krav».

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
| Avhengighetskart | [Avhengighetskart](#avhengighetskart), eller «Ikke aktuelt» |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | <navn> | <rolle fra kravene> | <organisasjon> | <hvilke krav eller deler> |

Testbrukerne finnes i rollene scenarioene nevner, ved organisasjonene kravet gjelder. Antallet bestemmes per krav ut fra tilgangsmatrisen. Det lages ikke egne testcaser for roller og tilgang i fase 2: `fs-verify` har verifisert i koden at de er laget slik kravet sier (fase 1). Scenarioene i kravet, også om synlighet, testes som de står.

Kolonnene `Nøkkel` (etter `Nr`), `Innlogging` og `Start-URL` (etter `Organisasjon`) er alltid med, fordi den agentiske funksjonstesten (fase 2) bruker dem:

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | <rolle>-<relasjon> | <navn> | <forretningsrollen fra koden> | <organisasjon> | <raden i «Overstyrt bruker»: `<NAVN> • <rolle> (<organisasjon>)` (ellers Chrome-profil eller Feide-ID)> | <URL> | <hvilke krav eller deler> |

Nøkkelen er rollen og relasjonen scenarioet trenger (`opptak-forvalter-deltakende`), aldri organisasjonen eller personen, og endres ikke om testbrukeren eller organisasjonen byttes. Rollene foreslås fra koden (*Finne rollene og foreslå testbrukere*), og personaen og `Innlogging` kopieres fra miljøfila (`cdp-tester/_Miljøer/<miljø>.md`), som er kilden: «Fra [<miljø>.md](<lenke>), <dato>». Er de uenige, gjelder miljøfila. Aldri passord i testplanen. Se [`roller-og-testdata.md`](../../../references/akseptansetest/roller-og-testdata.md).

#### Tilgangsmatrise

Fra tilgangsradene i verify-rapporten. Den viser hvilke roller kravet har ved hvilke organisasjoner, og hvilken testbruker som dekker hver rad. En rad uten tilgang trenger ingen testbruker, med mindre et scenario handler om den.

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@DOM-SUB-KAP-NNN` | <rolle> | ser / endrer / ingen tilgang | ser / endrer / ingen tilgang | <Nr> / – |

### Testdata

Testdataene testene trenger, med nøkkel. Testplanen sier hvilke data som trengs og hvilken tilstand de skal ha, ikke hvordan de lages: det løses separat, og ligger utenfor teststrategien. Testdata er syntetiske. Navnet og `Søk/URL` kopieres fra miljøfila, som er kilden: «Fra [<miljø>.md](<lenke>), <dato>».

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| <opptak, søker, regelverkssamling …> | <nøkkel> | <navn> | <lenke eller sted> | <hvordan objektet åpnes> | <hva testen forutsetter, med datoene i forhold til testdagen> | <Feature-ID og scenario, eller testcase-Nr> |

Data scenarioet selv lager (for eksempel «Opprett opptak»), står ikke her: de lages av stegene i testcasen (R13 i `testcase-regler.md`).

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

## Testcaser som skal lages

Omfanget av testcasene, ikke testcasene selv. `fs-testcaser-cdp` lager testcasene for fase 2 ut fra tabellen, og `fs-testcaser-intern` flyttestene for fase 3. Teamet og testansvarlig går gjennom omfanget før testcasene lages.

### Fase 2: agentisk funksjonstest

| Krav | Regel | Scenarioer | Utledede testcaser | Teknikk |
|---|---|---|---|---|
| `@DOM-SUB-KAP-NNN` | <regeltittel, eller regel i koden uten scenario> | <N> (scenariomal: <N> eksempler) | <hva som prøves: obligatoriske felt «<felt>», «<felt>» (tomt, bare mellomrom, for lang verdi), grenseverdier for «<felt>», ugyldige statusoverganger …> | grenseverdianalyse / ekvivalensklasser / beslutningstabell / tilstandsoverganger / – |

Testcasene står i `cdp-tester/<kravstien>/` (lenke når de er laget). Finnes testene fra før, står de her som de er, og lages testene etter testplanen, synkes tabellen med `fs-testplan` (*Synk med testene og miljøfila*). Utledede testcaser lages bare der regelen har verdier eller betingelser å teste.

### Fase 3: intern akseptansetest

| Flyt eller oppgave | Krav | Scenarioer i flyten | Avhengigheter som sjekkes | Regresjon |
|---|---|---|---|---|
| <tittel på flyten, eller «Oppgave uten flyt: <oppgave>»> | `@DOM-SUB-KAP-NNN`, … | <N> | <fra avhengighetskartet, eller «–»> | ja: <tidligere levert flyt> / nei |

Krav som ikke er med i noen flyt: <N>. De testes som oppgaver uten flyt, eller står i «Ikke med i denne testen» (se *Vurdering per krav*).

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
| 2 | Testdataene i «Testdata» finnes i testmiljøet, i utgangstilstanden der. Tilstander som bygger på datoer, er sjekket samme dag som testen | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake før hver kjøring | [Fylles ut av teamet] |
| 4 | Testbrukerne finnes i rollene ved organisasjonene kravene gjelder (tilgangsmatrisen) | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten. Åpne spørsmål stopper ikke, og står i «Åpne spørsmål» | <fra verify-rapporten, eller «Venter»> |
| 6 | De agentiske testcasene (`fs-testcaser-cdp`) er laget, og testansvarlig og teamet har gått gjennom dem før kjøringen | Venter |
| 7 | Flyttestcasene for den interne akseptansetesten (`fs-testcaser-intern`) er laget og gått gjennom av testansvarlig | Venter |
| 8 | Testansvarlig er logget inn i FS Admin i en egen Chrome-profil til testingen, CDP-agenten kan bytte til hver testbruker i «Overstyrt bruker», og nøklene i testbrukere og testdata er utfylt | [Fylles ut av teamet] |
| 9 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |
| 10 | <Kjent brudd i flyten «<tittel>»: <bruddet, med saken> er løst> | <Venter / Løst>   (én rad per kjent brudd, bare når flyten har det, nummerert etter de andre radene) |

## Kriterier for godkjent

Kravene i «Omfang» er kriteriene for godkjent: hvert scenario er et akseptansekriterium. Mangler et viktig tilfelle, legges det inn i kravet (`fs-krav`), ikke her. Fasene er ferdige når:

| Fase | Ferdig når |
|---|---|
| 1. Verifisering | Alle scenarioene er funnet, og en annen person har kontrollert rapporten. Åpne spørsmål står i testplanen, men stopper ikke |
| 2. Agentisk funksjonstest | Alle testcasene er kjørt, ingen funn med «Stopper» står åpne, og testansvarlig har gått gjennom rapporten. Det er inngangskriteriet til intern akseptansetest |
| 3. Intern akseptansetest | Beslutningen er tatt: godkjent, godkjent med forbehold eller ikke godkjent |
| 4. Ekstern akseptansetest | De eksterne partene har akseptert mot sine egne krav |

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

## Vedlegg

| Vedlegg | Lenke |
|---|---|
| Verifiseringsrapporten (fase 1) | <lenke til undersiden, eller verify-rapporten i repoet> |
| Agentisk testrapport (fase 2) | – |
| Testcasene for fase 2 | `cdp-tester/<kravstien>/`, og kjøringen i `akseptansetest/<slug>/kjoring-<dato>/` |
| Testcasene for fase 3 | – |

## Sporbarhet per krav

Fylles ut av rapportene etter hvert som fasene er ferdige. Raden følger scenarioet fra kravet til koden og til testen.

| Krav | Scenario | Kode (fase 1) | Testcase, teknikk og resultat (fase 2) | Flyt (fase 3) |
|---|---|---|---|---|
| `@DOM-SUB-KAP-NNN` | <scenario> | `<repo>/<fil>:<linje>` | <Nr, teknikk, resultat> | <flyt og fase, eller «–»> |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
```
