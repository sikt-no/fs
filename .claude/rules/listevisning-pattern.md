# Mønster for listevisning i krav

Designmønster for `.feature`-filer som beskriver en listevisning med søk, filtrering og paginering. Bruk dette som mal når du skriver eller reviewer krav som handler om å vise mange elementer av samme type (applikasjoner, organisasjoner, brukere, studierettigheter osv.).

Målet er at listevisninger oppfører seg gjenkjennelig på tvers av domener, slik at brukere og utviklere kjenner igjen mønsteret.

Kanonisk eksempel: `krav/07 Brukeradministrasjon og tilgangsstyring/applikasjoner/01 Iterasjon 2 - Support – Oversikt og passordbytte/listevisning_og_sok.feature`.

## Når mønsteret gjelder

Bruk mønsteret når kravet beskriver en oversiktsside med en liste av elementer av samme type. Det gjelder *ikke* for detaljsider, treeview, kort-galleri uten paginering, eller dashbord.

## Strukturen

Organiser kravet i tre `Regel:`-blokker i denne rekkefølgen:

1. **Liste** — selve listevisningen, kolonner, sortering og paginering.
2. **Søk og filtrering** — fritekst-søk og filtere.
3. **Synlighet** (når relevant) — hvilke elementer brukeren ser basert på rolle/rettighet.

Ikke ta med en `Regel:`-blokk hvis den ikke gir mening for domenet (f.eks. utelat «Synlighet» når alle brukere ser samme liste).

## Formuleringsregler

Disse reglene sikrer at listevisninger leses likt på tvers av domener. `<elementer>` står for flertallsform av elementtypen (applikasjoner, organisasjoner, brukere, studierettigheter, …) og `<element>` for entallsform. `<X>`-side er domene-spesifikk oversiktsside (applikasjonsoversikten, organisasjonsoversikten, …).

### Tittel og fortelling

- `Egenskap:`-tittel: `Listevisning og søk i <elementer>`.
- Fortellingen (Som / ønsker / slik at) holdes til tre linjer og uttrykker brukerens *intensjon* med listen — ikke UI:
  - `Som <rolle>`
  - `ønsker jeg en oversikt over <elementer> jeg har tilgang til, med mulighet for søk og filtrering`
  - `slik at jeg raskt kan finne og følge opp riktig <element>.`

### `Regel:`-titler

Bruk disse formuleringene (med domene-spesifikt objekt):

- `Regel: Liste over alle <elementer>`
- `Regel: Søk og filtrering av <elementer>`
- `Regel: Synlighet via <rettighet/rolle>` — f.eks. `Synlighet via administrasjonsrettigheter`.

Hvis en regel dekker konkrete kravpunkter (K1, K11, …), legg dem i parentes til slutt: `Regel: Liste over alle <elementer> (K1)`.

### `Bakgrunn:`

Hold `Bakgrunn:` minimal — typisk én linje:

```
Bakgrunn:
  Gitt jeg er innlogget i løsningen
```

Domene-spesifikke forutsetninger (roller, organisasjon) hører hjemme i det enkelte scenarioet, ikke i bakgrunnen.

### Scenario-titler (kanoniske formuleringer)

Bruk disse titlene direkte, kun bytt ut `<elementer>`/`<element>`/`<X>`:

**Liste:**

- `Scenario: Se liste over <elementer>`
- `Scenariomal: Velge sorteringsretning for <felt>`
- `Scenario: Liste viser de 50 første <elementer>`
- `Scenario: Laste inn 50 flere <elementer>`
- `Scenario: Alle <elementer> er lastet inn`
- `Scenario: Navigere til detaljside for <element>`

**Søk og filtrering** (ett par per filter):

- `Scenario: Fritekst-søk på <felt>`
- `Scenario: Tilgjengelige <verdier> i filter` — f.eks. `Tilgjengelige miljøer i filter`, `Tilgjengelige statuser i filter`.
- `Scenario: Filtrere på <verdi>` — f.eks. `Filtrere på miljø`, `Filtrere på status`.
- `Scenario: Kombinere filtre`

**Synlighet:**

- `Scenario: <Rolle> ser <elementer> fra <scope>` — f.eks. `Applikasjonsadministrator ser applikasjoner fra egne organisasjoner`.
- `Scenario: Super-<rolle> ser alle <elementer>`

### Stegformuleringer

Bruk førsteperson («jeg»), presens, og samme verb på tvers av features:

- Åpne listen: `Når jeg åpner <X>-oversikten`.
- Referere til synlig liste i etterfølgende scenario: `Gitt jeg ser listen over <elementer>`.
- Sortering: `Når jeg velger å sortere på <felt> i <retning> rekkefølge` / `Så vises <elementer> sortert etter <felt> i <retning> rekkefølge`.
- Initial visning: `Så ser jeg totalt antall treff og antall som er lastet` + `Og listen viser de 50 første <elementer>`.
- Last inn flere: `Når jeg velger å laste inn flere` / `Så lastes de neste 50 <elementer> inn i listen`.
- Alle lastet: `Så er muligheten til å laste inn flere ikke tilgjengelig`.
- Navigasjon: `Når jeg velger en <element>` / `Så ser jeg detaljsiden for valgt <element>`.
- Fritekst-søk: `Når jeg søker med fritekst på <felt>` / `Så filtreres listen til <elementer> som matcher søket`.
- Åpne filter: `Når jeg åpner <X>-filteret`.
- Standardvalg: `Og "Alle <verdier>" er valgt som standard` (alltid i anførselstegn).
- Velge filterverdi: `Når jeg velger <verdi> som filter` / `Så vises kun <elementer> ...`.
- Kombinere: `Når jeg kombinerer fritekst-søk med ett eller flere filter` / `Så vises kun <elementer> som matcher alle kriteriene`.

### Tabeller

- Kolonner i «Se liste»-scenarioet: bruk en tabell med én kolonne `| felt |` og én kolonneoverskrift per rad. Verdier skrives med stor forbokstav (`Navn`, `Beskrivelse`, `Antall tilganger`).
- Statiske filterverdier (f.eks. statuser): bruk en tabell med kolonneoverskriften som matcher filteret (`| Status |`), og inkluder «Alle X»-raden øverst.
- `Scenariomal:`-eksempler holdes så korte som mulig — typisk én kolonne (`| retning |`) med `stigende` / `synkende`.

### Rekkefølge i `Og`-kjeder

Rekkefølgen på `Og`-ledd i «Tilgjengelige verdier i filter» skal være:

1. Hva filteret inneholder (eventuelt med kant-tilfeller på neste linje).
2. Eventuelle «hver verdi vises kun én gang»-garantier.
3. Sortering av verdiene.
4. Standardvalget («Alle X» er valgt som standard).

Dette gjør at filter-scenarioer leses likt på tvers av features.

## Liste

Inkluder disse scenarioene (tilpass formuleringer til domenet):

- **Se listen**: hvilke kolonner/felter som vises per rad. Bruk en tabell med en `| felt |`-kolonne.
- **Sortering**: bruk `Scenariomal:` med `Eksempler:` for stigende/synkende. Default sorteringsfelt og -retning bestemmes per feature — regelen påtvinger ikke noe spesifikt default.
- **Initial paginering**: «listen viser de første N» + «ser totalt antall treff og antall som er lastet».
- **Laste inn flere**: scenario for «last inn flere» når det finnes flere treff.
- **Alle lastet inn**: scenario der «last inn flere» ikke lenger er tilgjengelig.
- **Navigere til detaljside**: hva som skjer når brukeren velger et innslag.

### Paginering: 50 som default, kan overstyres

Default sidestørrelse for «last inn flere»-mønsteret er **50**. Bruk 50 med mindre domenet har en konkret grunn til å avvike (f.eks. tunge rader, ytelse, eller produkteier-beslutning). Hvis et krav bruker et annet tall, flagg det i review og be om begrunnelse.

## Søk og filtrering

For hvert filter, dekk to scenarioer:

1. **Tilgjengelige verdier** — hva som finnes i filteret, sortering av valgene, og hva som er valgt som standard. Standardvalget er alltid «Alle X» (f.eks. «Alle statuser», «Alle miljøer»).
2. **Filtrere på X** — hva som skjer når brukeren velger en konkret verdi.

I tillegg:

- **Fritekst-søk** på det mest relevante feltet (typisk navn).
- **Kombinere filtre**: ett scenario som sier at fritekst + filtere kombineres med AND.

Filterverdier sorteres alfabetisk i nedtrekk med mindre domenet har en annen naturlig rekkefølge (f.eks. status).

## Synlighet

Når listen er rolle-/rettighetsstyrt:

- Ett scenario per rolle som forklarer hva rollen ser.
- Vær eksplisitt om kant-tilfeller: elementer som tilhører andre organisasjoner men har relevans for brukerens organisasjon, super-administrator som ser alt, osv.
- Følg `design-patterns-for-krav.md`-regelen om at manglende tilgang skjuler elementet — ikke beskriv deaktiverte rader eller feilmeldinger ved klikk.

## Hva regelen *ikke* sier

- Ingen UI-detaljer (knapp vs. lenke, plassering, ikoner) — det hører hjemme i `<feature>.design.md` via `utdype-implementasjon`.
- Ingen ytelsestall utover sidestørrelsen.
- Ingen krav om uendelig scroll vs. eksplisitt «last inn flere»-knapp — beskriv brukerens intensjon («velger å laste inn flere»), ikke interaksjonen.

## Sjekkliste når du skriver eller reviewer

**Struktur:**

- [ ] `Egenskap:`-tittel: `Listevisning og søk i <elementer>`.
- [ ] Tre-linjers fortelling (Som / ønsker / slik at) som uttrykker intensjon, ikke UI.
- [ ] `Bakgrunn:` er minimal (typisk én `Gitt`-linje).
- [ ] Tre `Regel:`-blokker (Liste / Søk og filtrering / Synlighet), med synlighet utelatt hvis ikke relevant.
- [ ] `Regel:`-titler følger kanoniske formuleringer.

**Liste-regelen:**

- [ ] «Se liste»-scenario med kolonner som `| felt |`-tabell.
- [ ] Sortering dekket med `Scenariomal:` + `Eksempler:` (stigende/synkende).
- [ ] Paginering: initial visning, last inn flere, alle lastet inn.
- [ ] Navigasjon til detaljside.
- [ ] Sidestørrelse 50 (eller eksplisitt begrunnelse for annet tall).

**Søk og filtrering:**

- [ ] Fritekst-søk-scenario.
- [ ] Hvert filter har både «Tilgjengelige <verdier> i filter» og «Filtrere på <verdi>».
- [ ] «Alle X» (i anførselstegn) som default i hvert filter.
- [ ] `Og`-rekkefølge i filter-scenario: innhold → unikhet → sortering → standardvalg.
- [ ] «Kombinere filtre»-scenario.

**Stegformuleringer:**

- [ ] Førsteperson («jeg»), presens.
- [ ] Bruker kanoniske verb (`åpner <X>-oversikten`, `ser listen over <elementer>`, `velger å laste inn flere`, …).