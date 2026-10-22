# Flyter og referanser i FS Kravforvaltning

Spesifikasjon for visningen av flyter og referanser (steg 6 i [`forslag-flyter-og-referanser.md`](../../forslag-flyter-og-referanser.md)). Den er grunnlaget for designet i Claude Design, og for implementasjonen etterpå.

Konvensjonen står i *Referanser* og *Flyter* i [`krav/README.md`](../../krav/README.md), og den er autoritativ. Dette dokumentet sier hva appen viser, og hva den regner ut. Konvensjonen virker uten appen, med filene, `grep` og skillene. Visningen er et tillegg.

## Hva visningen svarer på

| Spørsmål | Hvem spør | Hvor |
|---|---|---|
| Hva bygger kravet på, og hva viser det til? | Den som skriver eller leser kravet | Kravvisningen |
| Hva må sjekkes når kravet endres? | Den som endrer et levert krav, `fs-krav` | Kravvisningen |
| Hvilke flyter går kravet gjennom? | Den som endrer kravet | Kravvisningen |
| Hva skjer fra … til …? | Domeneeksperter, produkteiere, nye i teamet | Flytvisningen |
| Hvor langt har løpet kommet, og hvor brytes det? | Produkteiere, testansvarlige | Flytvisningen og oversikten |
| Hvilke faser mangler krav? | Den som planlegger (`fs-scope`) | Flytvisningen og Avvik |

## Begrepene

### Referanse

Et krav peker på et annet krav med en tag og Feature-ID-en til kravet.

| Tag | Betyr | Etikett i appen |
|---|---|---|
| `@depends-on-<Feature-ID>` | Delen bygger på kravet. Endres kravet, må delen sjekkes, og delen kan ikke leveres før kravet | **Bygger på** |
| `@ref-<Feature-ID>` | Henvisning for den som leser: «se også», «står der» | **Se også** |

- Taggen står på delen referansen gjelder: `Egenskap:`, `Regel:` eller `Scenario:`/`Scenariomal:`. Taggen på `Egenskap:` gjelder hele kravet.
- Taggen peker alltid på hele kravet. Gjelder den én regel i kravet, står regeltittelen i en kommentar under taggen.
- Retningen gir seg av hvor taggen står. Den andre retningen skrives ikke ned, men regnes ut:

| Retning | Etikett i appen | Utledes av |
|---|---|---|
| Andre krav har `@depends-on-` til dette kravet | **Brukes av** | Alle `@depends-on-<ID>` i `krav/` |
| Andre krav har `@ref-` til dette kravet | **Henvist fra** | Alle `@ref-<ID>` i `krav/` |
| Flyter har `@depends-on-` til dette kravet | **Inngår i flyter** | `@depends-on-<ID>` i `krav/_Flyter/` |

«Brukes av» er konsekvensanalysen: det er kravene som må sjekkes når kravet endres. «Henvist fra» er bare for den som leser, og skal ikke se like viktig ut.

### Flyt

En flyt er en feature-fil i `krav/_Flyter/<NN Prosess>/` som beskriver et løp på tvers av domener, fase for fase.

| Begrep | I fila | I appen |
|---|---|---|
| Prosess | Mappa, f.eks. `10 Opptaksløpet`, nummerert fra 10 i livsløpsrekkefølge | Gruppe i oversikten |
| Oversiktsflyt | Fila med samme navn som prosessen, ID `@FLY-<P>-<P>-001` | Prosessens hovedflyt, fasene peker på flyter |
| Flyt | Feature-fil, ID `@FLY-<prosess>-<flyt>-NNN` | Én flytvisning |
| Fase | `Regel:`, i rekkefølgen i fila | Kolonne i flytvisningen |
| Kravene i fasen | `@depends-on-` på `Regel:` | Kort i fasen |
| Flyt på flyt | `@depends-on-FLY-…` på en fase | Kort som åpner den andre flyten |
| Fase uten krav | `Regel:` uten `@depends-on-`, med `@openquestion` og `# ÅPNE SPØRSMÅL:` | Tydelig hull i løpet |
| Overlevering | Scenarioene i fasen: `Gitt` er tilstanden fra forrige fase | Mellom kolonnene |
| Kjent brudd | `# Kjent brudd: STEK-263, …` under beskrivelsen | Markering på flyten, og på fasen når det kan avgjøres |

Reglene står i kravene, ikke i flyten. Flyten beskriver overleveringene mellom dem.

### De to statusene for en flyt

Et brudd i overleveringen kan skjules av kravene: testene for hvert krav setter opp tilstanden selv, og går grønt selv om det ene kravet aldri får det det andre lager. Derfor har en flyt to statuser, og designet må vise begge, og skille dem tydelig.

| Status | Etikett | Kommer fra | Eksempel |
|---|---|---|---|
| Fremdrift | **Fremdrift** | Statusen på kravene fasene bygger på | «3 av 5 faser levert» |
| Flytens egen status | **Flytens status** | Statustaggen på flyten: `@draft` → `@planned` → `@implemented`, satt av `fs-verify` når overleveringene er funnet i koden. Ingen `@in-progress` | `@planned` |

Løpet er levert først når begge er ferdige. «5 av 5 faser levert» med flytens status `@planned` betyr: alle kravene er bygget, men det er ikke vist at overleveringene virker.

## Det appen regner ut

I dag sjekker parseren bare formatet på referansene (`refTags` i `server/parse.ts`). Modellen i `shared/model.ts` har ikke referansene som data, og det finnes ingen omvendt indeks. Visningen trenger dette:

### Per del (egenskap, regel, scenario)

- Utgående referanser: type (`depends-on` / `ref`), mål-ID, linje, og kommentaren under taggen (typisk regeltittelen i målet).
- Bare tagger teller. En ID som står i en kommentar eller i `# ÅPNE SPØRSMÅL:`, er ikke en referanse.

### Per mål-ID

- Kravet (eller kravene) som har ID-en: tittel, sti, domene, sub-domene, kapabilitet, og status med `displayStatus()` (så «endres» vises).
- Om målet er en flyt (`FLY-`).
- Om ID-en ikke finnes, eller finnes i flere krav (se *Kanttilfeller*).

### Per krav

- Bygger på, Se også (utgående, fra alle delene i kravet, gruppert per del).
- Brukes av, Henvist fra, Inngår i flyter (innkommende, med delen i kravet som refererer: «Regel: Søkeren kan søke om tidlig opptak …»).

### Per flyt

- Prosess, ID, tittel, beskrivelse, kjente brudd (fra kommentarene under beskrivelsen).
- Fasene i rekkefølge, med tittel, kravene (`@depends-on-`), henvisningene (`@ref-`), kommentarene (regeltitlene), scenarioene og `@openquestion`.
- Flytens status (taggen) og fremdriften.

### Fremdrift

| Hva | Regel |
|---|---|
| Fasens status | Den minst ferdige statusen blant kravene i fasen: `@draft` < `@planned` < `@in-progress` < `@implemented`. Fasen får fargen og ikonet til den statusen |
| Levert fase | Alle kravene i fasen er `@implemented`. Et levert krav som «endres», teller som levert, men vises som «endres» |
| Fase som bygger på en flyt | Levert når den flyten har alle fasene levert **og** flytens status `@implemented` |
| Fase uten krav | Aldri levert. Vises som «Fase uten krav», ikke som utkast |
| Krav med `@deprecated` | Teller ikke som levert. Gir avvik (se under) |
| Fremdriften for flyten | Antall leverte faser av alle faser: «3 av 5 faser levert» |

## Visningene

### 1. Ny modus «Flyter»

Fjerde knapp i toppfeltet: **Krav | Avvik | Oppgaver | Flyter** (`Mode` i `src/TopBar.tsx`). Badgen viser antall flyter med faser uten krav eller kjente brudd.

Hash-ruter, som de andre visningene (`src/main.tsx`, `src/tavleHash.ts`):

| Rute | Viser |
|---|---|
| `#/flyter` | Oversikten |
| `#/flyter/<prosess>/<flyt>` | Én flyt, f.eks. `#/flyter/10-opptakslopet/tidlig_opptak` |
| `#/flyter/<prosess>/<flyt>/<fase-nr>` | Flyten med én fase valgt (detaljpanel) |

#### Oversikten

- Prosessene i nummerrekkefølge. Under hver: oversiktsflyten først, så flytene i den rekkefølgen oversiktsflyten har dem, og til slutt flytene oversiktsflyten ikke peker på.
- Per flyt: tittel, ID, flytens status (statusikon og etikett), fremdrift («3 av 5 faser levert», med én liten markør per fase i fasens farge), antall faser uten krav, og kjente brudd.
- Oversiktsflyten kan vises som en tidslinje over hele løpet, der hver fase er en flyt.
- **Tomt:** «Ingen flyter ennå.» med lenke til *Flyter* i `krav/README.md`, og «Skriv en flyt med fs-krav» (åpner Claude-panelet med `fs-krav`).

#### Flytvisningen

- **Topp:** tittel, ID, beskrivelse, flytens status, fremdrift, kjente brudd, og «Åpne fila» (åpner flyten i Krav, der den kan redigeres).
- **Fasene som kolonner** i rekkefølgen i fila, nummerert (1, 2, 3 …), med tittelen på `Regel:` og fasens status.
- **Baner:** én bane per domene kravene ligger i. Ligger alle kravene i ett domene (som i alle pilotene, `02 Opptak`), er banene sub-domenene (`10 Regelverk`, `11 Opprette og vedlikeholde opptak`, `12 Utdanningstilbud`, `13 Søknad og saksbehandling`, `14 Plasstildeling`). Banene står i nummerrekkefølge, og bare baner med krav vises.
- **Kort per krav** i banen og fasen: statusikon (`StatusIcon`), tittel, Feature-ID, og regeltittelen fra kommentaren når referansen gjelder én regel. Et krav som går igjen i flere faser (som `@OPT-BEH-BEH-008` i mangelmeldingen), får ett kort per fase, og kortene er koblet visuelt når det ene er markert.
- **Flyt på flyt:** kortet er en flyt, med eget utseende, fremdrift og flytens status, og åpner den flyten.
- **Fase uten krav:** kolonnen har et tomt felt med «Fase uten krav», det åpne spørsmålet fra `# ÅPNE SPØRSMÅL:`, eventuelle `@ref-` (f.eks. «Se også: Poengberegning»), og «Skriv kravet med fs-krav».
- **Overleveringen** mellom to faser: scenarioet i fasen, kort. `Gitt` er tilstanden fra forrige fase, `Når` handlingen og `Så` resultatet. Den skal kunne leses uten å åpne fasen.
- **Brudd:** fase uten krav, krav som ikke er levert, og kjent brudd vises der løpet stopper, så det synes hvor løpet brytes.
- **Detaljpanel for en fase:** tittel, kravene med status og sti, henvisningene, kommentarene, scenarioene i sin helhet, og åpne spørsmål.
- **Klikk på et krav** åpner det i Krav. Mens kravet er åpent, viser Krav båndet «← <flyt>» tilbake til flyten (som «← <oppgave>» fra Oppgaver, `src/TaskBackBar.tsx`).

### 2. Kravvisningen

Gjelder `src/FeatureView.tsx` og innholdspanelet (`src/Outline.tsx`).

- **Referansetaggene blir lenker.** På egenskap, regel og scenario vises `@depends-on-OPT-OVO-INN-001` som en lenke med retning («Bygger på»), statusikon og tittel («Innstillinger for opptak»). `@ref-` vises svakere enn `@depends-on-`. Hover gir sti og status, klikk åpner kravet.
- **Panelet «Koblinger»**, med fem grupper. Tomme grupper vises ikke. Ingen koblinger: «Ingen koblinger».

| Gruppe | Innhold | Gruppert etter |
|---|---|---|
| Bygger på | Kravene dette kravet har `@depends-on-` til | Delen i dette kravet |
| Se også | Kravene dette kravet har `@ref-` til | Delen i dette kravet |
| Brukes av | Kravene med `@depends-on-` til dette kravet | Kravet som refererer, med delen |
| Henvist fra | Kravene med `@ref-` til dette kravet | Kravet som refererer, med delen |
| Inngår i flyter | Flytene med `@depends-on-` til dette kravet | Flyten, med fasen og fremdriften |

- Hver rad: statusikon, tittel, Feature-ID, og delen («Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det»). Klikk åpner kravet og går til delen.
- **Når kravet er en flyt:** «Vis flyten» øverst, som åpner flytvisningen.
- **Når kravet endres** («endres», eller `@deprecated` på egenskap eller del): «Brukes av» og «Inngår i flyter» trekkes fram, med teksten «Disse kravene må sjekkes når kravet endres».

### 3. Avvik

Avvikene som krever flere filer, og som `fs-krav-avvik` gjør i dag, kan appen vise når den har indeksen. De står i seksjonen «Referanser» i `shared/rules.ts`, sammen med `ref-format`, `ref-self`, `ref-duplicate` og `ref-both-types`. Navnene er forslag:

| Id | Etikett | Alvor |
|---|---|---|
| `ref-missing` | Referanse til krav som ikke finnes | error |
| `ref-ambiguous` | Referanse til en ID som flere krav har | error |
| `ref-deprecated` | Bygger på et avviklet krav | warning |
| `ref-cycle` | `@depends-on-` i ring | error |
| `flow-phase-empty` | Fase uten krav | warning |
| `flow-cross-process` | Flyt på flyt på tvers av prosesser | warning |

Hvilke av dem som skal i `parse.ts`, og hvilke som blir i `fs-krav-avvik`, avgjøres ved implementasjonen. README-regelen gjelder: en sjekk som merkes *(sjekkes automatisk)*, må ha kode og tester i samme endring.

## Kanttilfeller designet må dekke

| Tilfelle | Eksempel | Vises som |
|---|---|---|
| ID-en finnes ikke | Kravet er slettet eller har fått ny ID | Lenken er gjennomstreket med «Finnes ikke», og avvik |
| ID-en finnes i flere krav | `@OPT-BEH-BEH-007` er både «Gi tilbudsgaranti ved tidlig opptak» og «Velge fag per poengvariant». Det samme gjelder `BEH-BEH-008`, `BEH-BEH-009`, `BEH-BEH-010` og `SØK-SØK-013` i dag | Lenken viser begge kravene og «ID brukt av flere krav», og avvik |
| Målet er `@draft` eller `@planned` | Fase 1 i tidlig opptak bygger på `@OPT-OPT-UTD-004` (`@draft`) | Statusikonet, og fasen får statusen |
| Målet er `@deprecated` | Et levert krav som skal fjernes | Gjennomstreket, og avvik |
| Målet «endres» | `@OPT-SØK-SØK-010` i mangelmeldingen | «endres»-ikonet. Fasen teller som levert |
| `@depends-on-` i ring | A → B → A | Avvik, med ringen |
| Mange koblinger | `@OPT-OPT-UTD-004` er i fire flyter, `@OPT-BEH-BEH-008` i alle seks fasene i mangelmeldingen | Gruppene kan foldes sammen, med antall |
| Referansen gjelder én regel i et stort krav | `gi_tilbudsgaranti_ved_tidlig_opptak.feature` har over 400 linjer | Regeltittelen fra kommentaren vises, og klikk går til regelen når tittelen finnes |
| Flyt på flyt | Fase 2 i mangelmeldingen bygger på `@FLY-OPT-SAK-001` | Eget kort for flyt |
| Fase med mange krav | Fasen «Fristen for manglene» har fire krav | Banene vokser i høyden, kolonnene holder bredden |
| Fase uten krav, med `@ref-` | «Poengene beregnes automatisk» viser til `@OPT-REG-RAN-002` | «Fase uten krav», med «Se også» |
| Smal skjerm og smalt vindu | Desktop-appen med Claude-panelet åpent | Fasene som en liste ovenfra og ned, med kravene under hver fase |
| Parse-feil i flytfila | | Banneret som i Krav, over sist gyldige versjon |

## Eksempeldata for designet

Det finnes ingen flytfiler i `krav/_Flyter` ennå. Designet bruker flytene under, fra pilotene i forslaget og eksempel 3 i [`forslag-flyter-og-referanser-eksempler.md`](../../forslag-flyter-og-referanser-eksempler.md). Statusen er den kravene har i dag (oktober 2026). Flytene er `@draft`.

Sub-domenene: 10 Regelverk, 11 Opprette og vedlikeholde opptak, 12 Utdanningstilbud, 13 Søknad og saksbehandling, 14 Plasstildeling (alle i `02 Opptak`).

### Kravene

| Feature-ID | Tittel | Sub-domene | Status |
|---|---|---|---|
| `@OPT-REG-SAM-001` | Regelverkssamling | 10 | `@implemented` |
| `@OPT-REG-RAN-002` | Poengberegning | 10 | `@implemented` |
| `@OPT-REG-KVO-001` | Kvotetype | 10 | `@implemented` |
| `@OPT-OVO-SAM-001` | Samordna opptak | 11 | `@in-progress` |
| `@OPT-OVO-INN-001` | Innstillinger for opptak | 11 | `@in-progress` |
| `@OPT-OVO-INN-002` | Sette standard plassflyt for opptaket | 11 | `@planned` |
| `@OPT-OVO-INN-003` | Sette kvoteprioritet for opptaket | 11 | `@planned` |
| `@OPT-OVO-FRI-001` | Frister og hendelser for opptak | 11 | `@in-progress` |
| `@OPT-OPT-UTD-004` | Opptaksinnstillinger per utdanningstilbud | 12 | `@draft` |
| `@OPT-OPT-UTD-025` | Sette tidlig søknadsfrist og dokumentasjonsfrist på utdanningstilbudet | 12 | `@draft` |
| `@OPT-OPT-UTD-028` | Velge saksbehandlertildelingsregel for utdanningstilbudet | 12 | `@draft` |
| `@OPT-SØK-SØK-003` | Veilede søker om hvilken dokumentasjon som skal lastes opp | 13 | `@planned` |
| `@OPT-SØK-SØK-010` | Se meldinger om egne søknader | 13 | `@implemented`, endres |
| `@OPT-SØK-SØK-011` | Søke om tidlig opptak | 13 | `@in-progress` |
| `@OPT-SØK-SØK-012` | Se svar på søknad om tidlig opptak | 13 | `@in-progress` |
| `@OPT-BEH-BEH-005` | Se søkerens elektroniske vitnemål | 13 | `@planned` |
| `@OPT-BEH-BEH-007` | Gi tilbudsgaranti ved tidlig opptak (ID-en brukes også av «Velge fag per poengvariant», `@draft`) | 13 | `@in-progress` |
| `@OPT-BEH-BEH-008` | Søknadsmangler (ID-en brukes også av «Legge inn og endre fag») | 13 | `@planned` |
| `@OPT-BEH-BEH-009` | Finne søknader om tidlig opptak (ID-en brukes også av «Sammenligne vitnemål») | 13 | `@in-progress` |
| `@OPT-BEH-BEH-011` | Tildele saksbehandlende organisasjon | 13 | `@planned` |
| `@OPT-BEH-BEH-012` | Automatisk kvoteplassering | 13 | `@draft` |
| `@OPT-BEH-BEH-013` | Vurdere søknad om tidlig opptak | 13 | `@in-progress` |
| `@OPT-BEH-BEH-014` | Publisere svar på tidlig opptak | 13 | `@in-progress` |
| `@OPT-BEH-BEH-015` | Automatisk GSK-konklusjon | 13 | `@planned` |
| `@OPT-PLA-INN-002` | Plassflyt mellom utdanningskvoter | 14 | `@draft` |
| `@OPT-PLA-TIL-001` | Starte en plasstildeling | 14 | `@draft` |
| `@OPT-PLA-TIL-002` | Gjennomføre plasstildeling | 14 | `@draft` |

### Prosessen: 10 Opptaksløpet

Oversiktsflyten `@FLY-OPT-OPT-001` Opptaksløpet. Fasene som har flyt, peker på dem. Resten er faser uten krav foreløpig: Klargjøre opptaket, Finne og søke studier, Fra søknad til studieplass og Endringer etter søknadsåpning.

### Flyt: Tidlig opptak (`@FLY-OPT-TID-001`, `@draft`)

Kjent brudd: STEK-263, tilbudsgarantien fra tidligopptaket leses ikke i hovedopptaket.

| # | Fase | Bygger på | Fasens status | Overlevering (scenario) |
|---|---|---|---|---|
| 1 | Opptaket og utdanningstilbudet åpner for tidlig opptak | INN-001, FRI-001, UTD-004 | `@draft` | Gitt opptaket åpner for tidlig opptak, og utdanningstilbudet tilbyr tidlig opptak. Når søknadsfristen for tidlig opptak er åpen. Så kan søkeren søke tidlig opptak |
| 2 | Søknaden om tidlig opptak vurderes | SØK-011, BEH-009, BEH-013 | `@in-progress` | Gitt søkeren har søkt tidlig opptak. Når saksbehandleren konkluderer at søkeren deltar. Så er søkeren med når tidligopptaket gjennomføres |
| 3 | Søkeren får tilbudsgaranti | BEH-007 | `@in-progress` | Gitt søkeren er med i tidligopptaket og har nok poeng. Når opptaksforvalteren gjennomfører tidligopptaket. Så har søkeren tilbudsgaranti |
| 4 | Søkeren får svar på tidlig opptak | BEH-014, SØK-012 | `@in-progress` | Gitt søkeren har tilbudsgaranti. Når svaret publiseres. Så ser søkeren tilbudsgarantien |
| 5 | Tilbudsgarantien gir tilbud i hovedopptaket | BEH-007 (Regel: Tilbudsgarantien gjelder i hovedopptaket), PLA-TIL-002 (Regel: Søker med tilbudsgaranti får tilbud uavhengig av poengsum) | `@draft`, kjent brudd | Gitt søkeren har tilbudsgaranti fra tidligopptaket. Når plasstildelingen i hovedopptaket gjennomføres. Så får søkeren tilbud |

Fremdrift: 0 av 5 faser levert.

### Flyt: Saksbehandlertildeling (`@FLY-OPT-SAK-001`, `@draft`)

| # | Fase | Bygger på | Fasens status |
|---|---|---|---|
| 1 | Tildelingsreglene settes for opptaket | OVO-SAM-001, BEH-011 | `@planned` |
| 2 | Utdanningstilbudet får saksbehandlertildelingsregel | UTD-028 | `@draft` |
| 3 | Søknadsalternativene fordeles når søknaden sendes | BEH-011 | `@planned` |
| 4 | Den saksbehandlende organisasjonen ser saken | BEH-011 | `@planned` |

Fremdrift: 0 av 4. Ett krav (BEH-011) går gjennom tre faser.

### Flyt: Automatisk saksbehandling (`@FLY-OPT-AUT-001`, `@draft`)

| # | Fase | Bygger på | Fasens status |
|---|---|---|---|
| 1 | Søkeren har ett entydig vitnemål | BEH-005 | `@planned` |
| 2 | GSK-konklusjonen settes automatisk | BEH-015 | `@planned` |
| 3 | Kravelementene vurderes automatisk | – | Fase uten krav |
| 4 | Poengene beregnes automatisk | – (Se også: REG-RAN-002) | Fase uten krav |
| 5 | Søkeren plasseres i kvoter automatisk | BEH-012, REG-KVO-001 | `@draft` |
| 6 | Saken blir ferdig behandlet og går til plasstildelingen | PLA-TIL-001 | `@draft` |

Fremdrift: 0 av 6, to faser uten krav.

### Flyt: Mangelmelding (`@FLY-OPT-MAN-001`, `@draft`)

| # | Fase | Bygger på | Fasens status |
|---|---|---|---|
| 1 | Mangelkodene finnes i regelverkssamlingen | REG-SAM-001, BEH-008 | `@planned` |
| 2 | Den saksbehandlende organisasjonen registrerer mangler | **FLY-OPT-SAK-001** (flyt), BEH-008 | `@draft` (fra flyten) |
| 3 | Søkeren får melding og ser manglene i Min kompetanse | BEH-008, SØK-010 (endres), SØK-003 | `@planned` |
| 4 | Fristen for manglene | BEH-008, FRI-001, UTD-025, INN-001 | `@draft` |
| 5 | Søkeren laster opp, og saksbehandleren sjekker ut mangelen | BEH-008 | `@planned` |
| 6 | En mangel som sperrer opptak, holder søkeren utenfor tilbudskjøringen | BEH-008, PLA-TIL-002 | `@draft` |

Fremdrift: 0 av 6. Tre aktører (opptaksforvalter, saksbehandler, søker), og en runde fram og tilbake som er egne scenarioer i fase 5 (dokumentert innen fristen, ikke dokumentert, sperrer opptak).

### Referanser på et krav

`@OPT-OVO-INN-002` Sette standard plassflyt for opptaket (`@planned`):

| Gruppe | Krav | Del |
|---|---|---|
| Se også | `@OPT-PLA-INN-002` Plassflyt mellom utdanningskvoter (`@draft`) | Egenskap |
| Brukes av | `@OPT-PLA-INN-002` Plassflyt mellom utdanningskvoter (`@draft`) | Egenskap |
| Brukes av | `@OPT-OPT-UTD-004` Opptaksinnstillinger per utdanningstilbud (`@draft`) | Regel: Lærestedene ser plassflyten og kvoteprioriteten for utdanningstilbudene sine |

`@OPT-OVO-INN-001` Innstillinger for opptak (`@in-progress`):

| Gruppe | Krav | Del |
|---|---|---|
| Se også | `@OPT-PLA-TIL-002` Gjennomføre plasstildeling (`@draft`) | Regel: Opptaksforvalter setter standard poenglikhetsregel for opptaket, og Regel: Opptaksforvalter setter tak for antall tilbud per tildelingsrunde |
| Brukes av | `@OPT-SØK-SØK-011` Søke om tidlig opptak | Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det |
| Brukes av | `@OPT-OPT-UTD-004` Opptaksinnstillinger per utdanningstilbud | Regel: Opptaksforvalter kan markere at et utdanningstilbud tilbyr tidlig opptak |
| Inngår i flyter | Tidlig opptak (fase 1), Mangelmelding (fase 4) | |

## Rammer for designet

- **Bruk det som finnes:** `StatusIcon` (`src/Sidebar.tsx`, formene for hver status), statustokenene `--st-draft`, `--st-planned`, `--st-in-progress`, `--st-implemented`, `--st-deprecated`, `--st-changing`, `--st-none` i `src/theme.css`, `.tag`, `.minitag` og den stiplede kanten for utkast (`.rule.draft`, `.card.draft`), og `displayStatus()` og `STATUS_LABEL` i `shared/model.ts`.
- Visningen skal ligne Avvik og Oppgaver (designene «Gherkin Viewer v2» og «Spesifikasjoner» i Claude Design).
- Lys og mørk modus. Nettleser, GitHub Pages (skrivebeskyttet) og desktop-appen.
- Claude-panelet kan være åpent til høyre, så flytvisningen må virke i et smalere vindu.
- Bare visning. Flyter og referanser endres i feature-fila: i Krav (Editor), eller med `fs-krav` i Claude-panelet. Knappene i visningen åpner fila eller panelet.
- Tekstene er på norsk, med domenets ord (se *Terminologi* i `krav/README.md`). Ingen tagger i etikettene, men Feature-ID-en vises på kortene.

## Tekstene

| Hvor | Tekst |
|---|---|
| Toppfeltet | Flyter |
| Gruppene | Bygger på · Se også · Brukes av · Henvist fra · Inngår i flyter |
| Panelet | Koblinger · Ingen koblinger |
| Når kravet endres | Disse kravene må sjekkes når kravet endres |
| Flyten | Fremdrift · Flytens status · «N av M faser levert» · Kjent brudd · Vis flyten · Åpne fila |
| Fasen | Fase uten krav · Skriv kravet med fs-krav · Overlevering |
| Lenkene | Finnes ikke · ID brukt av flere krav · Avviklet |
| Tomt | Ingen flyter ennå. · Skriv en flyt med fs-krav |
| Tilbake | ← <flyt> |

## Det designet skal utforske

Varianter i Claude Design:

1. Flytvisningen: fasene som kolonner og banene som rader, eller omvendt.
2. Overleveringen: mellom kolonnene, som piler mellom kortene, eller i detaljpanelet.
3. Hvor «Koblinger» står: eget panel i kravvisningen, en seksjon i innholdspanelet (`Outline`), eller under tittelen.
4. Oversikten: liste per prosess, eller oversiktsflyten som tidslinje med flytene som faser.
5. Hvordan de to statusene vises sammen, så «alle faser levert, men flyten ikke verifisert» er tydelig.

## Det visningen ikke gjør

- Endrer ikke flyter eller referanser (det gjøres i fila).
- Viser ikke en graf over alle referansene i `krav/`. Koblingene vises fra ett krav eller én flyt om gangen.
- Gjetter ikke på referanser fra fritekst i kommentarer. De 279 referansene som står som fritekst i dag, vises ikke før de er gjort om til tagger.

## Åpne spørsmål

- Skal en fase med et krav som «endres», telle som levert, eller som ikke levert til endringen er levert?
- Teller krav med `@wont` i fremdriften?
- Skal banene være domene og sub-domene, eller aktør (opptaksforvalter, saksbehandler, søker)? Aktøren står ikke i taggene, og måtte leses fra brukerhistorien i kravene.
- Hvordan vises en fase der kravene er levert, men et kjent brudd gjelder overleveringen? Det kjente bruddet står i en kommentar på flyten, ikke på fasen.
- Skal Flyter være en egen modus, eller en del av Krav (som `_Flyter` i treet med en egen visning)?
