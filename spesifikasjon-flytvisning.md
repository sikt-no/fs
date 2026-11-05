# Spesifikasjon: Flyter – visning av flytene og relasjonene deres i FS Kravforvaltning

Denne spesifikasjonen er grunnlaget for å designe en ny visning i FS Kravforvaltning, i Claude Design. Visningen viser flytene i `krav/_Flyter` og relasjonene deres: fasene, kravene hver fase bygger på, og flytene som bygger på hverandre. Brukeren velger en flyt i filtreet, som et krav i Krav i dag, og ser hele flyten med relasjonene.

Brukeren velger hvor mange nivåer med `@depends-on-` som skal følges fra flyten: bare kravene fasene bygger på, også kravene de kravene bygger på, og så videre, helt til alle avhengighetene i flyten er avdekket. Visningen tar utgangspunkt i flyten, og viser referansene mellom vanlige krav bare når de er en del av en avhengighetskjede fra flyten. `@ref-` mellom vanlige krav følges ikke, siden en henvisning ikke er en avhengighet. En `@ref-` på en regel eller et scenario i et krav som pekes på med `@depends-on-`, er et anker, og sier hvilken del av kravet som følges (3.3).

## 1. Bakgrunn

### Kravene

Kravene er `.feature`-filer (Gherkin på norsk) under `krav/`, i tre mappenivåer: domene → sub-domene → kapabilitet. Hvert krav har en unik Feature-ID som tag på `Egenskap:`, for eksempel `@OPT-BEH-BEH-011`, i tillegg til prioritet (`@must`, `@should`, `@could`, `@wont`) og status (`@draft`, `@planned`, `@in-progress`, `@implemented`, `@deprecated`).

### Flytene

En flyt er et løp på tvers av domener, fase for fase. Den svarer på «hva skjer fra … til …?». Flytene ligger i `krav/_Flyter/<NN Prosess>/<flyt>.feature`, og er feature-filer med samme format som et krav, med ID-en `@FLY-<prosess>-<flyt>-NNN`.

```
krav/_Flyter/
└── 10 Opptaksløpet/                  # prosess
    ├── opptaksløpet.feature          # oversiktsflyt: fasene i hele løpet
    └── saksbehandlertildeling.feature
```

- Hver `Regel:` er en **fase**, i rekkefølge.
- `@depends-on-<Feature-ID>` på fasen peker på kravene fasen går gjennom. En fase kan ha flere.
- En **oversiktsflyt** (én per prosess, med ID-en `@FLY-<prosess>-<prosess>-001`, f.eks. `@FLY-OPT-OPT-001` Opptaksløpet) har faser som peker på andre flyter i samme prosess (`@depends-on-FLY-OPT-SAK-001`). Det kalles *flyt på flyt*.
- En **fase uten krav** har ingen `@depends-on-`. Den har `@openquestion` og en `# ÅPNE SPØRSMÅL:` som sier hvilket krav eller hvilken flyt som mangler.
- En fase kan også ha `@ref-<Feature-ID>`: en henvisning for leseren, som ikke gjør fasen avhengig av kravet.
- `@depends-on-` peker på hele kravet. Bygger fasen bare på noen regler eller scenarioer i kravet, har de delene i kravet `@ref-<flytens ID>`: **ankeret** (*Anker* i `krav/README.md`). Det samme gjelder mellom vanlige krav: har A `@depends-on-B`, og har en del i B `@ref-A`, bygger A bare på de delene av B.
- Kommentaren rett under taggen sier ofte hvilken regel i kravet fasen bygger på, for eksempel `# «Søknadsalternativene fordeles når søknaden sendes inn eller endres, og fordelingen ligger fast»`. Den brukes når kravet ikke har noe anker.
- Scenarioene i fasen beskriver **overleveringen**: tilstanden som én aktør eller ett system lager, og den neste bruker. Det som skjedde i en tidligere fase, står som en tilstand i `Gitt`.
- **Kjente brudd** i løpet står i en kommentar under beskrivelsen: `# Kjent brudd: STEK-263, …`.

### To statuser

Det viktigste flytene viser, er at kravene kan være levert hver for seg uten at løpet virker. Testene for hvert krav setter opp tilstanden selv, så de kan gå grønt selv om det ene kravet aldri får det det andre lager.

| Status | Kommer fra | Sier |
|---|---|---|
| Fremdrift | Statusen på kravene fasene bygger på | «3 av 5 faser levert» |
| Flytens egen status | Taggen på flyten | at overleveringene virker i koden |

Flytens egen status går `@draft` → `@planned` → `@implemented`. Den hopper over `@in-progress`. Designet må få fram at dette er to ulike ting.

### Omfang i dag (22.10.2026)

- 2 flyter i én prosess, `10 Opptaksløpet`:
  - `opptaksløpet.feature` (oversiktsflyt, `@draft`): 6 faser, der bare én peker på en flyt, og fem har «Flyten for fasen er ikke skrevet».
  - `saksbehandlertildeling.feature` (`@planned`): 5 faser, som bygger på 5 ulike krav. `OPT-BEH-BEH-011` går igjen i fire av fasene.
- Konvensjonen er en pilot, og antallet vil vokse. Designet må tåle flere prosesser, 10–15 flyter per prosess, opptil ca. 10 faser per flyt og 1–4 krav per fase.

## 2. Appen visningen skal inn i

FS Kravforvaltning (`fs-kravforvaltning/`) er en Preact-app som kjører som dev-server, desktop-app (Electron) og statisk bygg på GitHub Pages. Den har i dag tre visninger, valgt med bryteren «Krav | Avvik | Oppgaver» i toppfeltet (`src/TopBar.tsx`, `type Mode`):

- **Krav**: filtreet til venstre (`src/Sidebar.tsx`, med søk, statusprikker og tellere per mappe), feature-visningen i midten (`src/FeatureView.tsx`), og innholdspanelet til høyre (`src/Outline.tsx`). Claude-panelet kan åpnes helt til høyre.
- **Avvik**: dashbord over avvikene fra konvensjonene.
- **Oppgaver**: tavla med oppgavene.

Visuelt språk som skal gjenbrukes (`src/theme.css`):

- Fonter: IBM Plex Sans (tekst), IBM Plex Mono (ID-er, tagger, stier).
- Flater: `--bg`, `--panel`, `--surface`, `--sunken`, linjer `--line`/`--line2`, tekst `--ink`/`--ink2`/`--muted`, aksent `--acc` (lilla) med `--acc-soft`/`--acc-ink`, feil `--err`, advarsel `--warn`.
- Statusfarger: `--st-draft`, `--st-planned`, `--st-in-progress`, `--st-implemented`, `--st-deprecated`, `--st-none`, `--st-partial`, `--st-changing`. Status vises som prikk og etikett (`STATUS_LABEL` i `shared/model.ts`: draft, planned, in-progress, implemented, deprecated, ingen status, delvis utkast, endres).
- Nøkkelordfarger for Gherkin: `--k-feat`, `--k-rule`, `--k-sc`, `--k-gitt`, `--k-naar`, `--k-saa`.
- Lys og mørk modus. Begge skal designes.

## 3. Ny visning: Flyter

### Plassering og navigasjon

- En fjerde knapp i bryteren: **Krav | Avvik | Oppgaver | Flyter**. `Mode` får verdien `'flyter'`.
- Rute: `#/flyter/<sti til flyten>`, f.eks. `#/flyter/krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature`. Uten sti vises startsiden (3.5). Ruta huskes som de andre (`kravforvaltning:hash`).
- **Filtreet er det samme komponentet som i Krav** (`Sidebar`), med søket og statusprikkene, men avgrenset til `krav/_Flyter`: prosessene som mapper, og flytene som filer. Oversiktsflyten står øverst i prosessen, med eget ikon.
- Klikk på en flyt i en fase (flyt på flyt) gjør den til valgt flyt, med ny rute, så tilbake-knappen virker. Brødsmulen viser veien: Opptaksløpet → Saksbehandlertildeling.
- Klikk på et krav i en fase åpner kravet i Krav. Har relasjonen et anker, åpnes kravet på den første delen med ankeret, ellers på regelen i kommentaren når den finnes. Klikk på et scenario i fasen åpner flyten i Krav på linja (samme `focus` som søket bruker).
- I Krav får metalinja på en flyt lenken «Vis flyten», og metalinja på et vanlig krav lenken «Med i N flyter» når kravet er med i en flyt. Begge åpner Flyter.

### 3.1 Valgt flyt: hodet

- Feature-ID (mono), tittel, prioritet, prosess (brødsmule) og beskrivelsen (fortellingen under `Egenskap:`).
- **Fremdrift** og **flytens egen status** ved siden av hverandre, tydelig skilt:
  - Fremdrift som en stolpe med ett segment per fase, farget med fasens status, og teksten «3 av 5 faser levert».
  - Flytens egen status som statusetikett, med forklaringen «Overleveringene er verifisert i koden» (`@implemented`) eller «Overleveringene er ikke verifisert» (ellers).
- **Kjente brudd** som varsel under hodet.
- Antall åpne spørsmål i flyten, med lenke til det første.
- «Brukes i»: oversiktsflyten(e) som har en fase med `@depends-on-` til denne flyten, med fasenummeret.

### 3.2 Valgt flyt: fasene

Fasene i rekkefølge. Hver fase viser:

- **Nummer og tittel** (`Regel:`-tittelen).
- **Status for fasen**: levert når alle kravene fasen bygger på, er `@implemented`, ellers den laveste statusen. `missing` (eget, tydelig uttrykk) når fasen ikke har krav.
- **Kravene fasen bygger på** (`@depends-on-`), som kort: ID, tittel, statusprikk, domene og sub-domene (dempet), og delene i kravet fasen bygger på: ankrene («Regel: <tittel>» eller «Scenario: <tittel>», merket `@ref-`), ellers regelen i kommentaren under taggen når den finnes.
- **Henvisningene** (`@ref-`) dempet, under kravene, så de ikke leses som avhengigheter.
- **Overleveringen**: scenarioene i fasen, sammenfoldet. Når de er foldet sammen, vises scenariotittelen, `Gitt`-steget (tilstanden fra forrige fase) og `Så`-steget (det fasen lager). Foldet ut vises alle stegene, med nøkkelordfargene fra feature-visningen.
- **`@openquestion`** og spørsmålene fra `# ÅPNE SPØRSMÅL:`, sammenfoldet.

Fase uten krav: et tomt, stiplet kort med spørsmålet, f.eks. «Flyten for fasen er ikke skrevet (forslaget: tidlig_opptak.feature)». Det skal være tydelig at noe mangler.

Fase i en oversiktsflyt: kortet er flyten fasen peker på, med flytens fremdrift (ministolpe) og egen status. Klikk åpner flyten.

Krav som går igjen i flere faser (som `OPT-BEH-BEH-011` i fase 1, 3, 4 og 5 i Saksbehandlertildeling), markeres, så brukeren ser at det er samme krav. Hover eller fokus på kravet uthever det i alle fasene.

Forslag til layout, for designet å velge mellom:

- **a) Vertikal tidslinje**: fasene under hverandre, med en linje mellom dem og overleveringen som en «bro» mellom to faser. Tåler lange fasetitler, mange krav per fase og smal skjerm.
- **b) Horisontal svømmebane**: fasene som kolonner fra venstre mot høyre, og kravene som kort under. Viser løpet godt, men blir trangt med mange faser.
- **c) Flytdiagram**: faser som noder og overleveringer som kanter, med kravene som en egen rad under. Bra for oversiktsflyten. Må ha a) eller b) ved siden av, så innholdet kan leses uten grafen.

Anbefaling: a) som standard, og b) eller c) for oversiktsflyten, der fasene er flyter og hvert kort er lite.

### 3.3 Nivåer av avhengigheter

Kravene en fase bygger på, bygger ofte selv på andre krav. Flyten virker ikke før hele kjeden er levert, så brukeren må kunne se alle avhengighetene i flyten, ikke bare de som står på fasene.

**Velgeren for nivåer** står i hodet, og gjelder hele flyten:

| Valg | Viser |
|---|---|
| 1 nivå (standard) | Kravene fasene bygger på (`@depends-on-` på `Regel:` i flyten) |
| 2 nivåer | Også kravene de kravene bygger på |
| 3 nivåer | Ett nivå til |
| Alle | Hele kjeden, til det ikke finnes flere `@depends-on-` |

- Valget huskes (`kravforvaltning:flowDepth` i localStorage), og står også i ruta (`#/flyter/<sti>?nivåer=2`), så en lenke viser det samme.
- Ved siden av velgeren står det hvor mange krav hvert nivå gir: «1 nivå: 5 krav · Alle: 9 krav». Da ser brukeren om det finnes mer å avdekke, uten å bytte nivå.
- Et nivå er ett `@depends-on-`-steg. I en oversiktsflyt er fasenes flyter nivå 1, kravene i de flytene nivå 2, og så videre. Flyt på flyt teller altså som ett nivå.

**Hvilken del av kravet som følges.** En `@depends-on-` kan stå på hele kravet (`Egenskap:`), på en `Regel:` eller på et `Scenario:`. Når fasen (eller kravet over i kjeden) bare bygger på en del av kravet B, sier ankeret hvilken: delene i B med `@ref-<ID-en som peker på B>`. Uten anker kan kommentaren under taggen ha regeltittelen. Delen leses i denne rekkefølgen:

1. **Ankeret:** delene i B med `@ref-<A>`, der A er fasens flyt eller kravet over i kjeden.
2. **Regeltittelen** i «…» i kommentaren under `@depends-on-B`, når den er en regel i B.
3. Ellers **hele kravet**.

Hva som følges for hver del:

| Delen | `@depends-on-` som følges i B |
|---|---|
| `Regel:` | på `Egenskap:`, på regelen og på scenarioene under den |
| `Scenario:`/`Scenariomal:` | på `Egenskap:`, på regelen over scenarioet (taggene på en regel gjelder alle scenarioene i den) og på scenarioet |
| Hele kravet | alle |

Brukeren velger:

- **Bare delen fasen bygger på** (standard): delen fra ankeret eller kommentaren følges. Uten noen av dem følges hele kravet, og det vises.
- **Hele kravet**: alle `@depends-on-` i kravet følges, uansett hvor de står. Dette gir alle avhengighetene som finnes, også dem som kanskje ikke angår flyten.

Standarden er «bare delen», fordi ankeret og kommentaren er det forfatteren har sagt om hva fasen bygger på.

Ankeret sier hvilket krav eller hvilken flyt som bygger på delen, ikke hvilken fase eller hvilken del av A. Har flere faser `@depends-on-B`, følges de samme delene av B fra alle fasene. Skal fasene skilles, står regeltittelen i «…» i kommentaren under taggen i hver fase. Den brukes da bare når ankrene ikke sier noe for fasen: et anker vinner alltid over kommentaren.

Ankeret sier hva som **følges og vises**. Det endrer ikke fremdriften: en fase er levert når kravene den bygger på, er `@implemented` som helhet (se 7).

Eksempel fra repoet: fase 2 i Saksbehandlertildeling bygger på `OPT-OPT-UTD-004`, med kommentaren «Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud». Følger man hele kravet, gir nivå 2 fire krav. Følger man bare regelen, gir nivå 2 ett krav (`OPT-BEH-BEH-011`). Med et anker i stedet for kommentaren står `@ref-FLY-OPT-SAK-001` på regelen i `OPT-OPT-UTD-004`, og resultatet er det samme. Se kapittel 5.

**Visningen av nivåene:**

- I fasekortet (3.2) vises avhengighetene som et tre under kravet de kommer fra, med innrykk per nivå og en linje som viser retningen («bygger på»). Hvert nivå kan foldes sammen.
- Hver avhengighet viser ID, tittel, status, **hvor i kravet over den taggen står**: «hele kravet», «Regel: <tittel>» eller «Scenario: <tittel>», og **hvilken del av kravet som følges**: ankrene (merket `@ref-`), ellers regelen i kommentaren under taggen når den finnes.
- **Samme krav flere steder.** Et krav som allerede er vist (i en annen fase, eller høyere i treet), vises ikke på nytt med hele treet sitt. Det vises som en kort lenke («`OPT-BEH-BEH-011`, se fase 1») som uthever kravet der det står først. Det holder treet lesbart, og viser samtidig at kravet går igjen.
- **Ring.** Peker kjeden tilbake på et krav som allerede er i kjeden, stopper treet der med et ringvarsel (3.6).
- **Status gjennom kjeden.** Hver fase får i tillegg til sin egen status også en **kjedestatus**: den laveste statusen i hele treet til valgt nivå. Er fasens krav levert, men et krav lenger ned i kjeden er draft, vises det som en advarsel på fasen: «Fasen bygger på et krav som er draft, 2 nivåer ned». Fremdriften i hodet regnes fortsatt bare fra nivå 1, så tallet ikke endrer seg når brukeren bytter nivå. Kjedestatusen står ved siden av fremdriften.

### 3.4 Kravene i flyten

En egen fane eller seksjon under fasene: **alle kravene flyten bygger på, til valgt nivå**, i én liste uten duplikater. For hvert krav: status, nivået det først dukker opp på, hvilke faser det er med i (direkte eller via et annet krav), hvilket krav det kommer via, og om kravet også er med i andre flyter. Lista kan sorteres på nivå, status og domene.

Den svarer på «hva må være levert for at flyten skal virke?», og «hvilke andre flyter berøres hvis dette kravet endres?». Med «Alle» er lista hele avhengighetsflaten til flyten.

For en oversiktsflyt er lista kravene i alle flytene den består av, gruppert per flyt.

### 3.5 Startsiden (ingen flyt valgt)

- Prosessene, med oversiktsflyten øverst og flytene under, hver med fremdriftsstolpe og egen status.
- Nøkkeltall: antall flyter, faser, faser uten krav, flyter som er `@implemented`, og kjente brudd.
- Varslene fra 3.6 for alle flytene, med lenke til flyten og fasen. Varslene regnes med «Alle» nivåer, så ingenting skjules av nivåvalget.

### 3.6 Varsler

Visningen viser det som krever flere filer, og som parseren derfor ikke sjekker per fil:

| Varsel | Når | Visning |
|---|---|---|
| Fase uten krav | Fasen har ingen `@depends-on-` | Stiplet kort (3.2) |
| Brutt referanse | Feature-ID-en en fase eller et krav i kjeden peker på, finnes ikke | Kortet med `--err` og «Finnes ikke» |
| Avviklet krav | Et krav i kjeden er `@deprecated` | Advarsel (`--warn`): den som peker på kravet, må peke på kravet som erstatter det |
| Kjeden bak | Et krav lenger ned i kjeden har lavere status enn kravet over | Advarsel på fasen, med nivået (3.3) |
| Flyten bak kravene | Flyten er `@implemented`, men et krav i kjeden er det ikke | Advarsel i hodet: kravet er endret etter at flyten ble verifisert |
| Flyt på flyt på tvers av prosesser | En fase peker på en flyt i en annen prosess | Advarsel: flyten den bygger på, skal ligge i samme prosess |
| Ring | `@depends-on-` går i ring, mellom flyter eller mellom krav i kjeden | Varsel i hodet med ringen listet |

Varslene i hodet gjelder hele kjeden, uansett hvilket nivå som er valgt. Ligger varselet dypere enn valgt nivå, sier det hvor dypt («3 nivåer ned»), og et klikk viser nivået.

### 3.7 Tilstander

- **Ingen flyter**: startsiden forklarer hva en flyt er, med lenke til *Flyter* i `krav/README.md`, og at en flyt skrives med `fs-krav`.
- **Parse-feil**: sist gyldige modell, med samme banner som i Krav.
- **Live-oppdatering**: lagres en flyt eller et krav en flyt bygger på, beregnes visningen på nytt. Fremdrift som endres, kan markeres kort (`--flash`), som i Avvik.
- **Statisk bygg (GitHub Pages)**: visningen virker likt, siden den bare leser snapshotet.
- **Smal skjerm**: tidslinjen, og svømmebanen blir til tidslinje. Treet med nivåer får mindre innrykk.
- **Ingen flere nivåer**: når det valgte nivået ikke gir flere krav enn nivået over, står det «Ingen krav på nivå 3: alle avhengighetene er vist».

### 3.8 Tilgjengelighet

- Et diagram er aldri eneste måten å se fasene og kravene på.
- Status vises med etikett i tillegg til farge, også i fremdriftsstolpen (tekst og `aria-label`).
- Rekkefølgen på fasene står i tekst (nummer), ikke bare som plassering eller pil.
- Alt er nåbart med tastatur.
- Treet med nivåer er et `tree` med `aria-level`, så nivået leses opp.

## 4. Datamodell

Flytene bygges i rendereren av snapshotet (`Snapshot` i `shared/model.ts`), med en ren funksjon i `src/flows.ts`, testet i `src/flows.test.ts`. Ingenting nytt trengs fra backenden.

```ts
export interface PhaseLink {
  kind: 'depends-on' | 'ref';
  id: string;                   // Feature-ID uten @, et krav eller en flyt (FLY-…)
  path: string | null;          // null når ID-en ikke finnes (brutt referanse)
  isFlow: boolean;
  status: DisplayStatus | null;
  note: string | null;          // kommentaren under taggen, f.eks. regeltittelen i kravet
}

export interface Handover {
  scenario: string;
  ln: number;
  given: string[];
  then: string[];
  openQuestion: boolean;
}

export interface FlowPhase {
  n: number;                    // 1-basert
  title: string;                // Regel-tittelen
  ln: number;
  links: PhaseLink[];
  openQuestions: string[];      // fra # ÅPNE SPØRSMÅL:
  handovers: Handover[];
  status: DisplayStatus | 'missing'; // laveste status blant @depends-on-, 'missing' uten
}

export interface Flow {
  path: string;
  id: string;                   // FLY-OPT-SAK-001
  title: string;
  process: string;              // «10 Opptaksløpet»
  overview: boolean;            // ID-en er FLY-<p>-<p>-001
  status: Status | null;        // flytens egen status
  progress: { delivered: number; total: number };
  knownBreaks: string[];        // «# Kjent brudd: …»
  phases: FlowPhase[];
  usedBy: { flow: string; phase: number }[]; // oversiktsflyter som peker på flyten
}

/** En @depends-on- i et vanlig krav, og hvor den står */
export interface KravDep {
  id: string;                   // Feature-ID-en det pekes på
  part: 'feature' | 'rule' | 'scenario';
  partName: string | null;      // regel- eller scenariotittel, null for hele kravet
  rule: string | null;          // regelen delen hører til (for et scenario: regelen over)
  ln: number;
  note: string | null;
}

/** En del av et krav med @ref-<A>: A bygger bare på denne delen, når A har @depends-on- til kravet */
export interface Anchor {
  part: 'rule' | 'scenario';
  name: string;                 // regel- eller scenariotittelen
  rule: string | null;          // regelen delen hører til (for et scenario: regelen over)
  ln: number;
}

/** Delen av kravet som følges: ankrene, regelen fra kommentaren, eller hele kravet (null) */
export type Focus = { kind: 'anchor'; parts: Anchor[] } | { kind: 'note'; rule: string } | null;

/** Én node i avhengighetstreet under en fase */
export interface DepNode {
  id: string;
  path: string | null;          // null: brutt referanse
  status: DisplayStatus | null;
  level: number;                // 1 = står på fasen
  via: KravDep | PhaseLink;     // taggen som førte hit
  focus: Focus;                 // delen av kravet som følges fra kravet (eller flyten) over
  seenAt: { phase: number; level: number } | null; // satt når kravet er vist før: vis som lenke, ikke tre
  cycle: boolean;               // kjeden peker tilbake hit: stopp
  children: DepNode[];
}

export interface FlowIndex {
  flows: Flow[];
  byProcess: Map<string, Flow[]>;
  /** Feature-ID til et krav → flytene og fasene kravet er med i, på nivå 1 */
  flowsThrough: Map<string, { flow: string; phase: number }[]>;
  /** Feature-ID → @depends-on- i kravet, for å følge kjeden */
  kravDeps: Map<string, KravDep[]>;
  /** Feature-ID → ID-en i @ref- → delene i kravet med den taggen (ankrene) */
  anchors: Map<string, Map<string, Anchor[]>>;
  warnings: { kind: 'missing' | 'broken' | 'deprecated' | 'chain-behind' | 'flow-behind' | 'cross-process' | 'cycle'; flow: string; phase?: number; id?: string; level?: number }[];
}

export type Follow = 'part' | 'whole';

export function buildFlows(snapshot: Snapshot): FlowIndex;

/** Avhengighetstreet for hver fase i flyten, til og med `depth` nivåer (Infinity for alle) */
export function dependencyTree(index: FlowIndex, flow: Flow, depth: number, follow: Follow): DepNode[][];

/** Kravene flyten bygger på, uten duplikater, med nivået hvert krav først dukker opp på (3.4) */
export function flatDependencies(tree: DepNode[][]): { id: string; level: number; phases: number[]; via: string[] }[];
```

- Treet bygges bredde først, så hvert krav får det laveste nivået det finnes på, og `seenAt` peker dit.
- `focus` regnes for hver node fra ID-en over (fasens flyt, eller kravet over i kjeden): ankrene i `anchors.get(id)?.get(over)`, ellers `note` når den er en regeltittel i kravet, ellers `null`. Et anker gjelder uten å sjekke `@depends-on-`, fordi noden bare nås gjennom en `@depends-on-`.
- `follow: 'part'` følger bare `KravDep` med `part: 'feature'` og dem som hører til `focus` (tabellen i 3.3). `follow: 'whole'` følger alle.
- Et krav som er fulgt for én del, følges på nytt når det nås for en annen del, eller for hele kravet: det er ulike avhengigheter.
- `@ref-` samles fra `Regel:`- og `Scenario:`-linjene i alle krav. `@ref-` på `Egenskap:` er ikke et anker, siden det betyr hele kravet.
- Nivåtellingene ved velgeren («1 nivå: 5 krav · Alle: 9 krav») er `flatDependencies` per nivå, og regnes én gang per flyt.

- Relasjonene leses fra `tags` på reglene i modellen, ikke fra teksten. En `@depends-on-` som står i en kommentar, er ikke en relasjon.
- Fremdriften: en fase er levert når alle `@depends-on-`-kravene er `@implemented`. En fase uten krav teller med i `total`, men ikke i `delivered`. En fase som peker på en flyt, er levert når den flyten er `@implemented`.
- Kommentaren rett under en `@depends-on-`/`@ref-`-tag må knyttes til taggen. I dag er den en vanlig `Note` på regelen. Det kan gjøres i `buildFlows` fra `notes` og linjenumrene, eller i parseren (`server/parse.ts`).

## 5. Eksempeldata for designet

Ekte data fra repoet, så designet kan bruke riktige navn og mengder.

**Saksbehandlertildeling** (`@FLY-OPT-SAK-001`, `@must @planned @e2e`)

> Fra opptaket settes opp, til riktig organisasjon har saken. Opptaksforvalteren ved forvaltende organisasjon setter opp tildelingsreglene for opptaket, og hvert utdanningstilbud får en saksbehandlertildelingsregel. Når søkeren sender inn søknaden, fordeles søknadsalternativene, og søknaden blir én sak hos hver saksbehandlende organisasjon. …

| # | Fase | Bygger på | Merknad |
|---|---|---|---|
| 1 | Tildelingsreglene settes for opptaket | `OPT-OVO-SAM-001`, `OPT-BEH-BEH-011` | `@openquestion`, 2 spørsmål |
| 2 | Utdanningstilbudet får saksbehandlertildelingsregel | `OPT-OPT-UTD-004` | `@openquestion` |
| 3 | Søknadsalternativene fordeles når søknaden sendes | `OPT-BEH-BEH-011` | Scenario med `@openquestion` |
| 4 | Den saksbehandlende organisasjonen ser saken | `OPT-BEH-BEH-011`, `OPT-BEH-BEH-010` | `@openquestion` |
| 5 | Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `OPT-OVO-FRI-001`, `OPT-BEH-BEH-011` | |

Eksempel på overlevering (fase 2):

```
Scenario: Utdanningstilbudet får saksbehandlertildelingsregelen fra opptaket
  Gitt at saksbehandlertildelingsregelen "SPE" er aktiv i opptaket
  Når opptaksforvalteren ved NTNU velger "SPE" for utdanningstilbudet "Utøvende musikk, NTNU"
  Så har "Utøvende musikk, NTNU" saksbehandlertildelingsregelen "SPE"
```

Status på kravene: `OPT-OVO-SAM-001` in-progress, `OPT-BEH-BEH-011` planned, `OPT-OPT-UTD-004` draft, `OPT-BEH-BEH-010` implemented, `OPT-OVO-FRI-001` in-progress. Fremdrift: 0 av 5 faser levert.

**Nivåene i Saksbehandlertildeling.** Av de fem kravene på nivå 1 har bare `OPT-OPT-UTD-004` (Opptaksinnstillinger per utdanningstilbud) egne `@depends-on-`. Ingen av dem har flere, så «Alle» er det samme som 2 nivåer.

Med «Hele kravet»:

```
Fase 2  Utdanningstilbudet får saksbehandlertildelingsregel
└─ OPT-OPT-UTD-004  Opptaksinnstillinger per utdanningstilbud           draft
   │  # «Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud»
   ├─ OPT-BEH-BEH-011  Tildele saksbehandlende organisasjon             planned   → se fase 1
   │     Regel: Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud
   ├─ OPT-REG-KVO-003  Sette standard plassflyt i regelverkssamlingen    planned
   │     Regel: Utdanningskvotene følger kvoteprioriteten og plassflyten i regelverkssamlingen
   │     Regel: Lærestedene ser plassflyten og kvoteprioriteten for utdanningstilbudene sine
   ├─ OPT-REG-KVO-004  Sette kvoteprioritet i regelverkssamlingen        planned
   │     (de samme to reglene)
   └─ OPT-OVO-INN-001  Innstillinger for opptak                          in-progress
         Regel: Opptaksforvalter kan markere at et utdanningstilbud tilbyr tidlig opptak
```

Med «Bare delen fasen bygger på» står bare `OPT-BEH-BEH-011` igjen under `OPT-OPT-UTD-004`. I dag kommer delen fra kommentaren. Med ankeret `@ref-FLY-OPT-SAK-001` på regelen i `OPT-OPT-UTD-004` blir treet det samme, og kortet viser «Regel: Opptaksforvalter kan velge saksbehandlertildelingsregel per utdanningstilbud · @ref-».

Tellingene ved velgeren: «1 nivå: 5 krav · Alle: 8 krav» (hele kravet) eller «1 nivå: 5 krav · Alle: 5 krav» (bare regelen, siden `OPT-BEH-BEH-011` allerede er på nivå 1).

I hele repoet har 14 krav egne `@depends-on-`, så de fleste kjedene er korte i dag. Designet må likevel tåle kjeder på 4–5 nivåer når flere krav får referanser.

**Opptaksløpet** (`@FLY-OPT-OPT-001`, `@must @draft @e2e`, oversiktsflyt)

| # | Fase | Bygger på |
|---|---|---|
| 1 | Opptaket klargjøres før søknadsåpning | – (forslaget: `klargjøre_opptaket.feature`) |
| 2 | Søkeren finner studier og søker | – (forslaget: `finne_og_søke_studier.feature`) |
| 3 | Søknadsalternativene fordeles til saksbehandlende organisasjoner | `FLY-OPT-SAK-001` Saksbehandlertildeling |
| 4 | Søkeren får tilbudsgaranti i tidlig opptak | – (forslaget: `tidlig_opptak.feature`) |
| 5 | Søknadene behandles, og studieplassene tildeles | – (forslaget: `fra_søknad_til_studieplass.feature`) |
| 6 | Søknader og utdanningstilbud endres etter søknadsåpning | – (forslaget: `endringer_etter_søknadsåpning.feature`) |

Fasene uten flyt har `@openquestion` og «Flyten for fasen er ikke skrevet (forslaget: …)».

## 6. Avgrensning

Ikke med i første versjon:

- Referansene mellom vanlige krav som ikke er en del av en kjede fra en flyt, og `@ref-` mellom vanlige krav. Visningen går alltid ut fra en flyt.
- Den andre retningen: hva som bygger på et krav i kjeden. Det ville gjort treet til en graf i begge retninger.
- Redigering av flytene i visningen (de endres i editoren eller med `fs-krav`).
- CDP-testene for overleveringene i `cdp-tester/_Løp/`. Kan legges til senere som en seksjon per fase («Tester for overleveringen»).
- Verify-rapportene for flytene (`verify-<flyt>-<dato>-<HHMM>.md` ved siden av flyten). Kan legges til senere som lenke i hodet.

## 7. Spørsmål til designet

- Vertikal tidslinje, horisontal svømmebane eller flytdiagram for fasene (3.2)? Og samme for oversiktsflyten, eller noe eget?
- Hvordan skilles fremdrift og flytens egen status, så de ikke forveksles?
- Hvor mye av overleveringen vises når fasen er foldet sammen?
- Hvordan vises et krav som går igjen i flere faser, eller flere steder i kjeden?
- Skal ankeret også avgjøre fremdriften: er en fase levert når delene den bygger på, er levert, og ikke først når hele kravet er `@implemented`? Det må i så fall endres i *Flyter* i `krav/README.md` og i fremdriften i `fs-verify` samtidig.
- Hvor står velgeren for nivåer og «Bare delen / Hele kravet», og hvordan skilles nivå 1 (det flyten selv sier) fra nivåene under (det kravene sier)?
- Hvordan vises kjedestatusen ved siden av fremdriften, uten at hodet får tre statuser som forveksles?
- Skal innholdspanelet til høyre (`Outline`) brukes, f.eks. som fasene i valgt flyt med status, for å hoppe mellom dem?
