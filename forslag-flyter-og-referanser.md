# Forslag: referanser mellom krav og flyter på tvers av domener

Status: forslag til diskusjon, oktober 2026

Eksempler fra `02 Opptak` står i [forslag-flyter-og-referanser-eksempler.md](forslag-flyter-og-referanser-eksempler.md).

## Problemet

Kravene i `krav/` er ordnet etter domene → sub-domene → kapabilitet. Det fungerer godt for å finne ett krav, men to ting mangler:

1. **Et krav kan ikke referere til et krav i et annet domene.** I dag skrives referansene som fritekst i kommentarer, for eksempel `# … står i tildele_saksbehandlende_organisasjon.feature (@OPT-BEH-BEH-011)`. Verken skillene eller FS Kravforvaltning kan lese dem, og de blir stående og peke feil når et krav flyttes, får ny ID eller slettes.
2. **Vi kan ikke vise en flyt som går over flere domener.** Ingen steder beskriver hva som skjer fra en utdanning er registrert i utdanningsregisteret til søkeren har fått studieplass. Flere flyter går gjennom det samme kravet, så flytene kan ikke ligge i mappestrukturen.

En kartlegging av `02 Opptak/12 Utdanningstilbud` (29 feature-filer) viste:

- Bare **én** referanse med ID ut av mappa.
- **8 kandidater til flyter** som går gjennom mappa.
- Samme krav i flere flyter: `@OPT-OPT-UTD-004` (opptaksinnstillinger) er med i fire av dem.
- **Overlapp:** samme regel beskrevet to eller tre steder, for eksempel saksbehandlertildelingsregelen (UTD-028, UTD-004 og BEH-BEH-011) og poenggrensen for tidlig opptak (UTD-010 og UTD-004).

## Beste praksis i Gherkin

Gherkin har ingen `include` eller import mellom features, og det er bevisst. Hver feature skal kunne leses og kjøres alene.

- **Scenarioer kaller ikke andre scenarioer.** Det som skjedde i et annet domene, skrives som en tilstand i `Gitt`: `Gitt søkeren har takket ja til studieplassen`. Step definitionen setter opp tilstanden direkte, uten å kjøre den andre flyten.
- **Steg som går igjen, er koblingen i testene.** Samme formulering i flere features gir én felles step definition.
- **Flyter skrives som egne, tynne «journey»-scenarioer.** De er få, deklarative og typisk `@e2e`, og beskriver overleveringene mellom domener, ikke reglene. Reglene står i kravene, og flyten peker på dem (testpyramiden).
- **Mange-til-mange løses med tagger, ikke med mappestruktur.** ID-er og tagger gir «brukes av» og «inngår i». Hos oss leses de med `grep` og skillene, og FS Kravforvaltning viser dem i tillegg.

Konvensjonen skal virke uten FS Kravforvaltning, bare med filene, `grep` og skillene. Appen er en visning på toppen, ikke en forutsetning.

## Forslag 1: referanser med `@depends-on-` og `@ref-`

Et krav peker på et annet krav med en tag og Feature-ID-en til kravet. Det er to typer, og de skiller seg på hva referansen betyr:

| Tag | Betyr | Settes |
|---|---|---|
| `@depends-on-<Feature-ID>` | Delen bygger på kravet. Endres kravet, må delen sjekkes, og delen kan ikke leveres før kravet | Bare der delen bygger på kravet |
| `@ref-<Feature-ID>` | Henvisning for den som leser: «se også», «avgjøres der» | Der det hjelper den som leser |

**Én test avgjør typen:** Må denne delen sjekkes hvis kravet det pekes på, endres? Svarer du ja, er det `@depends-on-`. Ellers er det `@ref-`.

```gherkin
  @depends-on-OPT-OVO-INN-001 @depends-on-OPT-OPT-UTD-004
  Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det
    # Tidlig opptak må være slått på både på opptaket og på utdanningstilbudet.

  @ref-OPT-PLA-TIL-002
  Regel: Opptaksforvalter setter tak for antall tilbud per tildelingsrunde
    # Hvordan taket brukes i plasstildelingen, står der.
```

- **Feature-ID, ikke slug.** Kravene har ID-er, og ID-en er det som slås opp, med `grep` eller i en skill.
- **Plassering:** på `Egenskap:`, `Regel:` eller `Scenario:`/`Scenariomal:`, på den delen referansen gjelder. Bygger hele kravet på et annet krav, står taggen på `Egenskap:`. Står referansen på delen den gjelder, blir ikke tag-linja på egenskapen lang.
- **Retningen gir seg selv av hvor taggen står.** Den motsatte retningen («hva bygger på dette kravet?») skrives ikke ned, men finnes med `grep`. Ellers må det samme holdes i synk to steder.
- **Kommentaren er valgfri.** Skal referansen forklares, eller peke på én regel i kravet, skrives det i en kommentar under taggen.
- **Kjent begrensning:** taggen peker på hele kravet. For store krav, som `gi_tilbudsgaranti_ved_tidlig_opptak.feature` (over 400 linjer), er det grovt, og regelen må stå i kommentaren.

### Hvorfor to typer, og ikke én

Med én type blandes to ting:

- **Avhengigheter.** Søknaden bygger på innstillingene for opptak. Endres innstillingene, må søknaden sjekkes, og søknaden kan ikke leveres først.
- **Henvisninger.** Innstillingene for opptak sier at antall tilbud per runde avgjøres av rundetypen i plasstildelingen. Det er en grense, ikke en avhengighet.

Blandes de, tar konsekvensanalysen med alle henvisningene, og vi kan ikke se at et krav venter på et annet. Med `@depends-on-`:

- **Konsekvensanalysen blir presis.** `grep -rn "@depends-on-OPT-OVO-INN-002" krav/` gir bare kravene som må sjekkes når standard plassflyt endres, og `--grep @depends-on-…` kjører bare testene deres.
- **Planleggingen får et svar.** `fs-specify` kan si fra «kravet bygger på @OPT-BEH-BEH-014, som er @draft» når kravet hentes inn i en oppgave, og `fs-scope` kan ordne oppgavene etter avhengighetene.
- **Flytene bruker den.** Hver fase i en flyt bygger på kravene sine (forslag 2).

### Hvorfor ikke retning (`@ref-here-`, `@ref-there-`)

Retningen gir seg selv av hvor taggen står. En tag for den motsatte retningen ville sagt det samme én gang til, i en annen fil, og de to må holdes i synk for hånd. Det `grep` kan regne ut, skal ikke skrives ned.

### Det som ikke er en referanse

- **Eierskap ved overlapp** («regelen eies av X»): når overlappen er ryddet, står regelen bare ett sted. De andre kravene peker dit med `@depends-on-` eller `@ref-`, etter testen over.
- **Historikk** («Skilt ut fra @OPT-BEH-BEH-004», «Feature-ID endret fra …», «flyttet hit …»): den gamle ID-en finnes ikke lenger, så en referanse til den ville gitt avvik. Historikk står i en kommentar eller i git-historikken.

### Hvorfor en tag, og ikke en kommentar

| | Kommentar (`# Se også: @ID`) | Tag (`@depends-on-…`, `@ref-…`) |
|---|---|---|
| Lesing | Fritekst som må tolkes | Gherkin-parseren leser den allerede, og `grep` finner den sikkert |
| Filtrering | Nei | `npx playwright test --grep @depends-on-OPT-BEH-BEH-011` kjører alt som bygger på kravet |
| Presisjon | Kan peke på en regel med tittel | Peker på en egenskap. Regelen står i en kommentar ved behov |
| Mønster i repoet | Nytt | Samme mønster som `@scope-<slug>` |

### Uten app: `grep` og skillene

| Spørsmål | Svar |
|---|---|
| Hva bygger dette kravet på, og hva viser det til? | Taggene `@depends-on-` og `@ref-` i fila |
| Hva må sjekkes når kravet endres? | `grep -rn "@depends-on-OPT-OPT-UTD-004" krav/` |
| Hva henger sammen med kravet? | `grep -rnE "@(depends-on\|ref)-OPT-OPT-UTD-004" krav/` |
| Hva må testes når kravet endres? | `npx playwright test --grep @depends-on-OPT-OPT-UTD-004` |

Skillene bruker referansene:

- `fs-krav` setter `@depends-on-` og `@ref-` når et krav skrives, og når overlapp ryddes. Når et levert krav endres, eller et krav fjernes, lister den kravene med `@depends-on-` til kravet, og spør om de også må endres. Når et krav slettes eller får ny ID, oppdaterer eller fjerner den referansene til kravet.
- `fs-krav-avvik` rapporterer referanser som ikke stemmer:
  - ID-en finnes ikke, for eksempel etter at et krav er slettet eller har fått ny ID
  - et krav refererer til seg selv
  - samme referanse står to ganger på samme del
  - samme par har både `@depends-on-` og `@ref-` (`@depends-on-` er allerede en referanse)
  - `@depends-on-` går i ring, også via flere krav (A → B → A)
- `fs-specify` og `fs-specify-delta` tar med kravene det refereres til, som kontekst i spesifikasjonen, og sier fra når et krav bygger på et krav som ikke er `@planned` eller lenger.

### I FS Kravforvaltning, i tillegg

- referansene blir lenker
- «Bygger på», «Brukes av» og «Se også» vises på kravene
- de samme sjekkene som `fs-krav-avvik` gjør, vises som avvik

`@depends-on-OPT-…` og `@ref-OPT-…` treffer ikke regexen for Feature-ID, fordi taggene ikke starter med en stor bokstav, og blir ikke lest som nye ID-er.

## Forslag 2: flyter i `krav/_Flyter`

En flyt er en egen feature-fil som beskriver et løp på tvers av domener, fase for fase. Hver fase bygger på kravene sine med `@depends-on-`. Flyten gjentar ikke reglene.

### Struktur: prosess → flyt

```
krav/_Flyter/
├── 10 Opptaksløpet/
│   ├── opptaksløpet.feature                  # oversikt: fasene i hele løpet
│   ├── klargjøre_opptaket.feature
│   ├── finne_og_søke_studier.feature
│   ├── tidlig_opptak.feature
│   ├── fra_søknad_til_studieplass.feature
│   └── endringer_etter_søknadsåpning.feature
├── 11 Studieløpet/
└── 12 Planlegge utdanning/
```

- **Prosess (nivå 1):** et livsløp på tvers av domener, nummerert fra `10` i livsløpsrekkefølge. Prosessene speiler ikke `krav/`-treet: Opptaksløpet starter i `01 Utdanning`, går gjennom `02 Opptak` og ender i `03 Gjennomføre studier`.
- **Oversiktsflyt:** én per prosess. Hver `Regel:` er en fase, og `@depends-on-` peker på flyten for fasen, for eksempel `@depends-on-FLY-OPT-TID-001`.
- **Flyt:** hver `Regel:` er en fase, og `@depends-on-` på regelen peker på kravene fasen går gjennom. Bare filer under prosessen, ingen flere mappenivåer.
- **ID:** `@FLY-<prosess>-<flyt>-NNN`, for eksempel `@FLY-OPT-TID-001`.
- **Kjente brudd** i løpet (for eksempel en Jira-sak) står i en kommentar på flyten.
- **Flyt på flyt:** en fase kan bygge på en annen flyt med `@depends-on-FLY-…`. Oversiktsflyten er bare en flyt der alle fasene peker på flyter. En flyt som en annen flyt bygger på, ligger i samme prosessmappe, og må selv bestå terskelen. Gjør den ikke det, er den en fase som peker på krav.
- **Fase uten krav:** en fase uten `@depends-on-` viser at kravet mangler. Det er nyttig å finne, men skal ikke bli stående: `fs-krav-avvik` rapporterer det.

Siden flytene bruker den samme taggen som kravene, finner `grep -rn "@depends-on-OPT-OPT-UTD-004" krav/` både kravene og flytene som bygger på UTD-004.

### Eksempel

```gherkin
# language: no
@FLY-OPT-TID-001 @should @draft @e2e
Egenskap: Tidlig opptak
  Søkeren søker tidlig opptak, får søknaden vurdert, får tilbudsgaranti,
  og får tilbud i hovedopptaket.
  # Kjent brudd: STEK-263, tilbudsgarantien fra tidligopptaket leses ikke i hovedopptaket.

  @depends-on-OPT-OVO-INN-001 @depends-on-OPT-OVO-FRI-001 @depends-on-OPT-OPT-UTD-004
  Regel: Opptaket og utdanningstilbudet åpner for tidlig opptak
    Scenario: Søkeren kan søke tidlig opptak
      Gitt opptaket åpner for tidlig opptak
      Og utdanningstilbudet tilbyr tidlig opptak
      Når søknadsfristen for tidlig opptak er åpen
      Så kan søkeren søke tidlig opptak på utdanningstilbudet

  @depends-on-OPT-SØK-SØK-011 @depends-on-OPT-BEH-BEH-009 @depends-on-OPT-BEH-BEH-013
  Regel: Søknaden om tidlig opptak vurderes
    Scenario: Søkeren deltar i tidligopptaket
      Gitt søkeren har søkt tidlig opptak
      Når saksbehandleren konkluderer at søkeren deltar i tidligopptaket
      Så er søkeren med når tidligopptaket gjennomføres

  @depends-on-OPT-BEH-BEH-007 @depends-on-OPT-PLA-TIL-002
  Regel: Tilbudsgarantien gir tilbud i hovedopptaket
    Scenario: Søkeren med tilbudsgaranti får tilbud i hovedopptaket
      Gitt søkeren har tilbudsgaranti fra tidligopptaket
      Når plasstildelingen i hovedopptaket gjennomføres
      Så får søkeren tilbud på søknadsalternativet
```

Hele flyten, med fem faser, står i eksemplene.

### To statuser for en flyt

Et brudd i overleveringen kan skjules av kravene. Når både tilbudsgarantien (`@OPT-BEH-BEH-007`) og plasstildelingen (`@OPT-PLA-TIL-002`) er `@implemented`, ser løpet levert ut. Testene for hvert krav setter likevel opp tilstanden selv, så de går grønt uten at garantien fra tidligopptaket faktisk når plasstildelingen. Bare flyten tester overleveringen.

| Status | Kommer fra | Sier |
|---|---|---|
| Fremdrift | Statusen på kravene flyten bygger på | «3 av 5 faser levert» |
| Flytens egen status | Taggen på flyten (`@draft` → `@planned` → `@in-progress` → `@implemented`), satt av `fs-verify` når scenarioene i flyten er verifisert | at overleveringene virker |

Først når begge er ferdige, er løpet levert. En flyt kan kjøres som `@e2e`-test når stegene har step definitions.

### Hva er en flyt?

En kandidat er en flyt når den:

1. går over minst to sub-domener eller domener
2. har en overlevering: en tilstand som én aktør eller ett system lager, og en annen bruker
3. svarer på et spørsmål noen faktisk stiller: «hva skjer fra … til …?»

Faller den på terskelen, er det nok med `@depends-on-` eller `@ref-` mellom kravene. Det gjelder også når ett krav bare bruker noe et annet krav setter, som standard plassflyt.

### Kartleggingen av `12 Utdanningstilbud` med terskelen

| Kandidat | Blir |
|---|---|
| Fra utdanningsregisteret til opptaket + Klargjøre før søknadsåpning | `klargjøre_opptaket` |
| Fra utdanningstilbud til søkeren i Min kompetanse | `finne_og_søke_studier` |
| Tidlig opptak | `tidlig_opptak` |
| Fra utdanningstilbud til plasstildeling + Fordeling til saksbehandlere | `fra_søknad_til_studieplass` |
| Endringer og trekking etter oppstart | `endringer_etter_søknadsåpning` |
| Neste års opptak bygger på fjorårets | Ingen flyt, bare `@ref-` mellom UTD-021, UTD-031 og UTD-010 |

Det gir **1 prosess og 5 flyter for hele Opptak**, ikke 8 for ett sub-domene.

### Uten app

- Flytfila leses som den er: fasene i rekkefølge, med kravene på hver fase.
- Hvilke flyter går gjennom kravet? `grep -rln "@depends-on-OPT-OPT-UTD-004" krav/_Flyter/`
- Fremdriften for flyten: en skill slår opp statusen på kravene flyten bygger på, og sier hvilke faser som ikke er levert.

### I FS Kravforvaltning, i tillegg

- flyten med én bane per domene, og fasene i rekkefølge
- «Inngår i flyter» på hvert krav
- fremdriften og flytens egen status

## Det vi ikke gjør

- **Referanser i kommentarer** (`# Se også:`). De er vanskelige å finne sikkert med `grep`, og kan ikke brukes til å filtrere testene.
- **Én referansetype.** Konsekvensanalysen ville tatt med alle henvisningene, og vi ville ikke sett at et krav venter på et annet.
- **Referansetyper etter retning** (`@ref-here-`, `@ref-there-`). Den motsatte retningen finnes med `grep`, og skal ikke holdes i synk for hånd.
- **Flere enn to typer** (`@forutsetter-`, `@mention-`, …). `@depends-on-` dekker både konsekvensanalysen og planleggingen. Flere typer gjør det vanskeligere å velge riktig.
- **Flyt-tagger på kravene** (`@flyt-<slug>`). De gir ikke rekkefølgen, og må holdes i synk med flyten. Koblingen står i flyten, og den andre retningen finnes med `grep`.
- **Regler kopiert inn i flyten.** De ville stått to steder, og de to versjonene ville glidd fra hverandre.
- **Flyter i Markdown eller YAML utenfor `krav/`.** Vi ville mistet status, avvik og testbarhet.
- **Flyter inne i domenemappene.** De som går på tvers av domener, ville ikke hatt noe naturlig hjem.

## Hva som må endres

| Hvor | Endring |
|---|---|
| `krav/README.md` | Konvensjonen for `@depends-on-` og `@ref-` med testen for typen, `_Flyter` med prosess → flyt, ID-formatet `@FLY-…`, de to statusene for en flyt, og terskelen |
| `fs-krav` | Sette referansene når et krav skrives, liste kravene med `@depends-on-` når et krav endres eller fjernes, oppdatere referansene når et krav slettes eller får ny ID, og en modus for å skrive en flyt |
| `fs-krav-avvik` | Rapportere referanser til ID-er som ikke finnes, selvreferanser, doble referanser, begge typer på samme par, `@depends-on-` i ring (også mellom flyter), og faser i en flyt uten `@depends-on-` |
| `fs-specify`, `fs-specify-delta` | Ta med kravene det refereres til, som kontekst, og si fra når et krav bygger på et krav som ikke er `@planned` |
| `fs-verify` | Verifisere scenarioene i en flyt, og sette flytens egen status |
| Kravene | Referansene i eksemplene først (steg 1). De 279 referansene som står som fritekst i dag, etter evalueringen |
| FS Kravforvaltning (`parse.ts` + tester) | Steg 1: avvik for formatet, referanse til kravet selv, samme referanse to ganger og begge typer på samme del |
| FS Kravforvaltning (visning) | Steg 6: lenker, «Bygger på», «Brukes av», tillate `_Flyter` med to nivåer, og visning av flyter |

## Forslag til rekkefølge

Referansene kommer først, fordi flytene bygger på dem. Så kommer tre piloter for flyt, fra den enkleste til den mest komplekse. Hver pilot tester noe nytt i forslaget. Etter pilotene evaluerer vi, før appen og resten av flytene.

| Steg | Hva | Tester |
|---|---|---|
| 0 | Beslutning | At teamet stiller seg bak forslaget |
| 1 | Referanser | `@depends-on-` og `@ref-` med skillene, uten app |
| 2 | Pilot 1: Saksbehandlertildeling | At strukturen virker, med lav risiko. Rydder et overlapp |
| 3 | Pilot 2: Automatisk saksbehandling | Faser uten krav, og en fase som er ett krav (kvoteplassering) |
| 4 | Pilot 3: Mangelmelding | Løkker, flere aktører, og flyt på flyt |
| 5 | Evaluering | Om formatet holder, før vi går videre |
| 6 | Visning i FS Kravforvaltning | Referanser og flyter i appen |
| 7 | Resten av flytene | Opptaksløpet, og så de andre prosessene |

### Steg 0: Beslutning

- Forslaget presenteres, og spørsmålene under *Til diskusjon* avklares.
- **Ferdig når:** testen for typen, prosessene og terskelen er bestemt, og det er klart hvem som eier flytene.

### Steg 1: Referanser

- Konvensjonen for `@depends-on-` og `@ref-` skrives i `krav/README.md` (*Referanser*).
- `fs-krav`, `fs-krav-avvik` og `fs-specify` / `fs-specify-delta` oppdateres (se *Hva som må endres*).
- Sjekkene som kan avgjøres ut fra én fil, legges i `parse.ts`, som regelen for README og parser krever: formatet, referanse til kravet selv, samme referanse to ganger, og begge typer på samme del. Sjekkene som krever flere filer (ID-en finnes, `@depends-on-` i ring), gjør `fs-krav-avvik`.
- Bare referansene i eksemplene gjøres om: eksempel 1 og 2 i [forslag-flyter-og-referanser-eksempler.md](forslag-flyter-og-referanser-eksempler.md), i seks filer i 11, 12, 13 og 14. Resten av Opptak endres ikke nå.
- **Ferdig når:** `grep -rn "@depends-on-OPT-OVO-INN-002" krav/` gir kravene fra eksempel 2, `npx playwright test --list` filtrert på taggen finner scenarioene deres, og parseren gir ingen nye avvik.

Kartleggingen viste 279 referanser i fritekst, ikke rundt 20: 28 historikk, 144 henvisninger, 18 avhengigheter og 89 uklare, i `02 Opptak` og `07 Brukeradministrasjon`. De gjøres om etter evalueringen (steg 5), med `fs-krav` og `fs-krav-avvik`. Før det må den doble ID-en `@OPT-SØK-SØK-013` ryddes: den brukes av både `finne_studier.feature` og `oppgi_at_generell_studiekompetanse_fullføres_i_vår.feature`.

### Steg 2: Pilot 1, saksbehandlertildeling

Den enkle piloten. Den tester strukturen med lav risiko, og rydder samtidig overlappet mellom `@OPT-OPT-UTD-028`, `@OPT-OPT-UTD-004` og `@OPT-BEH-BEH-011`.

1. **Rydde overlappet.** Bestem hvilket krav som eier valget av saksbehandlertildelingsregel per utdanningstilbud. De andre fjerner regelen, og peker dit med `@depends-on-` eller `@ref-`.
2. **Skjelett for prosessen:** `krav/_Flyter/10 Opptaksløpet/opptaksløpet.feature`, med fasene i hele løpet som `Regel:`-titler. Bare fasen for saksbehandlertildeling peker på en flyt foreløpig.
3. **Flyten:** `krav/_Flyter/10 Opptaksløpet/saksbehandlertildeling.feature` (`@FLY-OPT-SAK-001`, `@draft`):

| Fase | Bygger på |
|---|---|
| Tildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001`, `@OPT-BEH-BEH-011` |
| Utdanningstilbudet får saksbehandlertildelingsregel | `@OPT-OPT-UTD-004` eller `@OPT-OPT-UTD-028`, etter steg 1 i piloten |
| Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` |
| Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` |

- **Vi lærer:** om en flyt gir noe når ett stort krav (`tildele_saksbehandlende_organisasjon.feature`, 463 linjer) allerede beskriver det meste av løpet, og om terskelen holder for en flyt som så vidt består den.
- **Ferdig når:** flyten er validert med `fs-krav` og har `@planned`, og fremdriften kan leses ut fra kravene uten app.

### Steg 3: Pilot 2, automatisk saksbehandling

Flyten viser hva som skjer fra søknaden kommer inn, til saken er ferdig behandlet uten at en saksbehandler har gjort noe. Automatisk kvoteplassering er en fase i flyten, ikke en egen flyt: den er ett krav (`@OPT-BEH-BEH-012`), uten overlevering inni seg.

Flyten: `krav/_Flyter/10 Opptaksløpet/automatisk_saksbehandling.feature` (`@FLY-OPT-AUT-001`, `@draft`):

| Fase | Bygger på |
|---|---|
| Søkeren har ett entydig vitnemål | `@OPT-BEH-BEH-005` |
| GSK-konklusjonen settes automatisk | `@OPT-BEH-BEH-015` |
| Kravelementene vurderes automatisk | **Mangler krav** |
| Poengene beregnes automatisk | **Mangler krav** (regelverket for poengberegning: `@OPT-REG-RAN-002`) |
| Søkeren plasseres i kvoter automatisk | `@OPT-BEH-BEH-012`, `@OPT-REG-KVO-001` |
| Saken blir ferdig behandlet og går til plasstildelingen | `@OPT-PLA-TIL-001` |

- **Vi lærer:** hvordan en flyt finner krav som mangler. Kravelementene og poengberegningen finnes bare som kodenavn i en kommentar i `vitnemålsbehandling.feature` (`vurderKravelementerAutomatisk`, `beregnPoengAutomatisk`). De to fasene blir oppgaver for `fs-scope` / `fs-krav`.
- **Vi lærer også:** om en fase som er ett krav, er nok, eller om automatisk kvoteplassering trenger sin egen flyt likevel.
- **Ferdig når:** flyten finnes som `@draft`, og kravene som mangler, er lagt inn i et scope.

### Steg 4: Pilot 3, mangelmelding

Den komplekse piloten. Tre aktører (opptaksforvalter, saksbehandler og søker), fire sub-domener, og en runde fram og tilbake mellom saksbehandleren og søkeren.

Flyten: `krav/_Flyter/10 Opptaksløpet/mangelmelding.feature` (`@FLY-OPT-MAN-001`, `@draft`):

| Fase | Bygger på |
|---|---|
| Mangelkodene finnes i regelverkssamlingen | `@OPT-REG-SAM-001`, `@OPT-BEH-BEH-008` |
| Den saksbehandlende organisasjonen registrerer mangler | `@FLY-OPT-SAK-001` (flyt på flyt), `@OPT-BEH-BEH-008` |
| Søkeren får melding og ser manglene i Min kompetanse | `@OPT-BEH-BEH-008`, `@OPT-SØK-SØK-010`, `@OPT-SØK-SØK-003` |
| Fristen for manglene | `@OPT-BEH-BEH-008`, `@OPT-OVO-FRI-001`, `@OPT-OPT-UTD-025`, `@OPT-OVO-INN-001` |
| Søkeren laster opp, og saksbehandleren sjekker ut mangelen | `@OPT-BEH-BEH-008` |
| En mangel som sperrer opptak, holder søkeren utenfor tilbudskjøringen | `@OPT-BEH-BEH-008`, `@OPT-PLA-TIL-002` |

- **Løkken:** Gherkin har ikke løkker. Flyten viser én runde, og andre utfall (mangelen er ikke dokumentert innen fristen, mangelen sperrer opptak) blir egne scenarioer i fasen.
- **Vi lærer:** om formatet holder for et komplekst løp, om flyt på flyt er lett å lese, og om konsekvensanalysen på tvers virker: `grep -rn "@depends-on-OPT-OVO-FRI-001" krav/` skal gi mangelmeldingen.
- **Kjent risiko:** flere deler av `søknadsmangler.feature` er `@draft @openquestion`, for eksempel opplastingen. Flyten kan være `@draft` likevel. De åpne spørsmålene blir stående i kravet, ikke i flyten.
- **Ferdig når:** flyten finnes som `@draft`, og pilot 1 er en fase i den.

### Steg 5: Evaluering

Etter pilotene ser vi på:

- **Terskelen:** var den riktig for alle tre, og holder skillet mellom en fase som er ett krav, og en egen flyt?
- **Typene:** valgte vi riktig mellom `@depends-on-` og `@ref-` med testen, eller var det tvil?
- **Verdien:** fant flytene noe kravene ikke viste, som manglende krav, brudd eller overlapp?
- **Innsatsen:** hvor lang tid tok en flyt, og hva må `fs-krav` hjelpe med?
- **Ferdig når:** vi har bestemt om vi går videre, og eventuelle endringer er lagt inn i `krav/README.md`.

### Steg 6: Visning i FS Kravforvaltning

Referansene og flytene vises i appen: lenker, «Bygger på», «Brukes av» og «Se også», flyten med én bane per domene, og fremdriften og flytens egen status. Dette er et tillegg. Konvensjonen virker uten.

### Steg 7: Resten av flytene

- Tidlig opptak (`@FLY-OPT-TID-001`), med STEK-263 som kjent brudd.
- De andre flytene i Opptaksløpet: `klargjøre_opptaket`, `finne_og_søke_studier`, `fra_søknad_til_studieplass` og `endringer_etter_søknadsåpning`.
- De andre prosessene: Studieløpet og Planlegge utdanning.
- `fs-verify` verifiserer flytene og setter flytens egen status, når kravene de bygger på, er levert.

## Til diskusjon

- Holder testen for å velge mellom `@depends-on-` og `@ref-`: «Må denne delen sjekkes hvis kravet det pekes på, endres?»
- Er prosessene riktige: Opptaksløpet, Studieløpet, Planlegge utdanning?
- Holder terskelen for hva som er en flyt?
- Hvem eier flytene, når de går på tvers av team?
- Er saksbehandlertildeling, automatisk saksbehandling og mangelmelding de riktige pilotene?
