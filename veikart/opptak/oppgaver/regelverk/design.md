# Regelverk

Opptaksforvalter skal kunne opprette og forvalte regelverkssamlinger som styrer hvem som er kvalifisert, hvordan søkere rangeres, og hvordan plasser fordeles mellom kvoter. Det meste av dette finnes i dag. Dette dokumentet beskriver hva løsningen gjør, hva den ikke gjør, og hvilke valg som gjenstår.

Dokumentet er skrevet for alle som trenger å forstå hva opptaksregelverk er, hvilke prinsipper det hviler på, og hvilke spørsmål som gjenstår. Funksjonell løsning per oppgave, gap-analyse og tekniske detaljer ligger i [oppgave.md](oppgave.md).

**Status:** første utkast, 2026-09-10. Bygger på prosessbeskrivelse fra behovskartlegging, gjennomgang av koden i `fs-plattform/opptak`, og HK-dir-feedback fra august 2026 ([TAKE-221](https://sikt.atlassian.net/browse/TAKE-221), [TAKE-235](https://sikt.atlassian.net/browse/TAKE-235), [TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)).

---

**Tre beslutninger bør leses før resten, fordi alt annet følger av dem. To er tatt. Den tredje er ikke, og bør tas.**

1. **En regelverkssamling er bundet til én organisasjon.** Samlingen eies av den organisasjonen som opprettet den, og den kan kopieres til andre organisasjoner. Endringer i originalen påvirker ikke kopien. Dette er tatt: koden og modellen virker slik.

2. **Poenglikhetsregelen hører ikke hjemme på de ulike rangeringsregelverket, men er en selvstendig regeltype.** HK-dir har meldt eksplisitt at poenglikhetsregel ikke skal settes på rangeringsregelverk, fordi regelen er default for alle utdanningstilbud i ett gitt opptak som bruker samme regelverkssamling. Forskriften er ulik mellom UHG og fagskole: i UHG er loddtrekning default med mulighet for lærestedet å velge «alle med lik sum får tilbud»; for HYU er rangering etter alder forskriftsfestet og kan ikke velges bort. Poenglikhetsregel skal knyttes til regelverkssamlingen som selvstendig regeltype. 

3. **Hva skjer med regelverket når søknader allerede er under behandling?** Det finnes ingen låseregel eller varslingsmekanisme som fanger opp at noen endrer et kompetansekrav eller en rangeringsregel mens søknader vurderes mot det. Konsekvensen av å endre regelverket etter at søknadsbehandling har startet er udefinert. Forslag om å innføre varslingsmekanisme, myk skranke, fordi det kan være behov for å rette feil i regelverk etter at søknader er behandlet. 

---

## Del 1: mål og retning

### Hva dette er, og hva det ikke er

Med opptaksregelverk mener vi reglene som avgjør om en søker er kvalifisert, og hvordan søkere rangeres mot hverandre når det er flere søkere enn plasser. Regelverket består av tre deler:

| Del | Spørsmålet den svarer på |
|-----|--------------------------|
| Kompetansekrav | Er søkeren kvalifisert? |
| Rangeringsregelverk med poengberegning | Hvor står søkeren i køen? |
|Poenglikhetsregel | Hva skal rangeringen gjøre med søkere som har fått lik poengsum?|
| Kvotetype med plassflyt | Hvilken køordning gjelder, og hvor går ledige plasser? |

Regelverket eies av en organisasjon (lærested eller sentralt opptaksorgan), pakkes i en regelverkssamling, og kobles til et utdanningstilbud i et opptak. Det er noe annet enn plasstildelingen, som bruker regelverket for å fordele plasser — se [plasstildeling/design.md](../plasstildeling/design.md).

| | Regelverk                                                     | Plasstildeling |
|---|---------------------------------------------------------------|----------------|
| **Spørsmålet** | Hva er reglene?                                               | Hvem får plassene? |
| **Skjer** | før opptak starter                                            | som en kjøring, per runde |
| **Eier** | opptaksforvalter ved lærested eller Samordna opptak nasjonalt | opptaksleder |
| **Dekkes her** | ja                                                            | nei |

### Mål

- Samordna opptak skal kunne opprette og forvalte regelverkssamlinger som lærsteder tar i bruk.
- Et enkelt lærested skal kunne opprette sin egen samling. (Aktuelt for lokale opptak)
- Kravene må kunne skrives på flere språk (bokmål, nynorsk, engelsk, samisk). 
- Samme krav, rangeringsregel eller kvotetype skal kunne brukes i flere ulike regelverk uten å måtte lages på nytt.
- Regelverket må kunne kobles til et utdanningstilbud, slik at søknadsbehandling og plasstildeling vet hvilke regler som gjelder.

### Ikke-mål

- **Ikke plasstildeling.** Fordeling av plasser er dekket i [plasstildeling/design.md](../plasstildeling/design.md).
- **Ikke søknadsbehandling.** Vurdering av den enkelte søker mot regelverket er saksbehandlerens domene.
- **Ikke poengberegning av søkeren.** Regelverket definerer *hvordan* poeng beregnes; selve beregningen skjer i søknadsbehandlingen.
- **Ikke forskriftshåndtering.** Systemet håndterer ikke forskriftstekster eller kobling til Lovdata.

---

## Del 2: løsningen slik den er i dag

### Regelverkssamling

En regelverkssamling er en pakke med opptaksregelverk — kompetansekrav, rangeringsregler, kvoter, poengberegning — som kan tas i bruk av ett eller flere utdanningstilbud.

**Eierskap:** Regelverkssamlingen eies av én organisasjon (`regelverksamling_kode` + `organisasjonskode`). Flere organisasjoner kan ha samlingen med samme kode — de får da hver sin kopi av innholdet.

**Deling:** Kopiering er løst via `kopierRegelverksamling`-mutasjonen, som kopierer alle 30+ tabeller fra en regelverkssamling til en annen organisasjon i én transaksjon. Endring i originalen påvirker ikke kopien.

**Rettighetsstyring:** Krever `MODIFISERE_REGELVERK`-handling på målorganisasjonen for å kopiere. Det finnes ingen «bruker»-rolle som kan bruke en samling uten å redigere den — tilgangen er alt-eller-ingenting.

**Synlighet på tvers:** HK-dir har meldt at læresteder må kunne se Samordna opptaks samlinger for kontrollformål ([TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)). I dag er det uavklart om lesetilgang finnes uten `MODIFISERE_REGELVERK`.

**Deaktivering:** En regelverkssamling kan deaktiveres (`er_aktiv = false`), men ikke slettes når den er i bruk.

**Kopiering fra detaljvisning:** HK-dir ønsker å kunne kopiere et element mens man står i det, i stedet for å opprette nytt og søke opp. Kopiering mangler helt for regelverkssamling fra detaljvisningen ([TAKE-235](https://sikt.atlassian.net/browse/TAKE-235)).

**Språkstøtte:** Navn lagres i `regelverksamling_sprak` med støtte for fire språk (nob, nno, eng, sme).

### Kompetansekrav

Kompetansekravene avgjør om en søker er kvalifisert. De er organisert i et hierarki:

```
kompetanseregelverk
  └── kompetansekrav (1..n)
        ├── grunnlag (1..n) — dokumentasjonsgrunnlag kravet gjelder for
        └── tilleggskrav (0..n)
              └── kravliste (1..n)
                    └── kravlisteelement (1..n)
                          └── kravelement — det konkrete kravet (fag, annet)
```

Et kompetanseregelverk kan knyttes til flere grunnlag (f.eks. generell studiekompetanse, realkompetanse). Kravelementer er de atomære kravene — et bestemt fag med karakterkrav, eller et annet krav (yrkeserfaring, aldersgrense). Kravelementer kan gjenbrukes på tvers av kompetanseregelverk innenfor samme regelverkssamling.

**Språkstøtte:** Kompetanseregelverk har `beskrivelse` og `forklaring` (markdown) per språk. Kravelementer har `beskrivelse` per språk. Kompetansekrav har et enkeltstående `navn`-felt (ikke flerspråklig).

**Validering:** Markdown-forklaringer valideres mot XSS (ingen rå HTML, blokkerte URI-skjemaer).

**Kravlogikk:** Både kompetansekrav og tilleggskrav har et `krever_alle`-flagg som styrer om alle underkrav må være oppfylt (AND) eller om ett er nok (OR). Kravlister har i tillegg `karakterkrav_snitt` for snittberegning.

**GSK for fagskole:** Fagskole kan valgfritt legge til GSK som kravelement i kompetanseregelverket, men HK-dir har meldt at dette ikke fungerer i praksis ([TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)). Det må avklares om modellen egner seg når fagskole velger å bruke GSK, eller om fagskolens kvalifiseringsstruktur trenger en annen tilnærming.

**Vitnemålskravkode:** Kravelementer har `vitnemalskrav_kode1` og `vitnemalskrav_kode2`, men HK-dir melder at det er uklart hvor kodene kommer fra, og at listen må være uttømmende før byggjobben starter. Kun to koder finnes i dag (KL og R94). Var tekstfelt, nå nedtrekksliste ([TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)).

### Rangeringsregelverk og poengberegning

Rangeringsregelverket bestemmer hvordan kvalifiserte søkere rangeres mot hverandre.

**Struktur:**

```
rangeringsregelverk
  ├── poenglikhetsregel — hva skjer ved lik poengsum (SKAL FLYTTES, se beslutning 2)
  └── rangeringsgrunnlag_poengtype (1..n) — kobler grunnlag til poengtyper
        ├── grunnlag — dokumentasjonsgrunnlaget
        └── poengtype = poengklasse + poengvariant
              ├── poengklasse — kategorien (f.eks. karakterpoeng, tilleggspoeng)
              └── poengvariant — varianten innenfor kategorien
```

**Poengberegning:** En poengtype er unikt identifisert av kombinasjonen poengklasse + poengvariant. Poengtypen har `minimum`, `maksimum`, `antall_desimaler`, `antall_sifre`, `poengtrinn` og en `poengalgoritme_kode`. Poengformler (`poengformel`) definerer uttrykk som summerer poengklasser.

**Poenglikhetsregler — nåværende modell og meldt endring:**

Dagens modell: Globale regler (PK: `poenglikhetsregel_kode`) med rekkefølge-kolonner for alder, loddtrekning, prioritet, søknadstidspunkt og underrepresentert kjønn. Regelen settes på rangeringsregelverket.

HK-dir melder at dette er feil plassering ([TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)): regelen hører til per utdanningstilbud i opptak, ikke per rangeringsregelverk. Begrunnelsen er at forskriften er ulik per opptakstype og rundetype:

| Opptakstype/rundetype            | Forskriftsfestet regel | Valgfrihet for lærested |
|----------------------------------|----------------------|------------------------|
| UHG (universiteter og høgskoler) | Loddtrekning (endres fra alder i 2027) | Kan velge «alle med lik sum får tilbud» |
| Fagskole                         | Rangering etter alder | Ingen (forskriftsfestet), men det kan bli aktuelt å tillate «alle med lik sum får tilbud» |
| Ledige studieplasser             | Tidspunkt for levert søknad | — |

Siden poenglikhetsregel (eller regler) i utgangspunktet enten er obligatorisk eller default for alle utdanningstilbud i opptaket, så er regelverkssamlingsnivå er foreslått som mulig plassering.

**Bulk-kobling grunnlag ↔ poengtyper:** HK-dir melder at å koble ett og ett tar lang tid ([TAKE-235](https://sikt.atlassian.net/browse/TAKE-235)), og ønsker å kunne koble flere grunnlag til flere poengtyper i én operasjon, ikke gjøre det én etter én. 

**Språkstøtte:** Rangeringsregelverk har `beskrivelse` per språk. Poengklasser og poengvarianter har `navn`/`beskrivelse` per språk.

### Kvotetype

En kvotetype definerer en køordning — en avsatt andel plasser for en bestemt gruppe søkere.

**Struktur:**

```
kvotetype
  ├── kvoterangering — metode for rangering (KP, SP, SPEV, IH)
  ├── poengformel — default poengformel
  ├── kvotetype_plassflyt — self-ref: ledige plasser går hit
  ├── kvoteprioritet_default — rekkefølge kvoter prøves i
  ├── kvotetype_grunnlag (1..n) — gyldige grunnlag med aldersgrenser
  └── kvotespørsmål (0..n) — spørsmål som avgjør kvotetilhørighet
        └── kvotespørsmål_preutfylling — JA, NEI, SAKSBEHANDLER, AUTOMATISK
```

**Plassflyt:** Definert på kvotetypen som en self-referanse (`kvotetype_kode_plassflyt`). Kan overstyres per utdanningstilbud på `kvote`-tabellen (`kvotetype_kode_overstyrer_plassflyt`). Se [plasstildeling/design.md](../plasstildeling/design.md) for hvordan plassflyt brukes i algoritmen.

**Kvotespørsmål:** Spørsmål som avgjør om en søker tilhører en kvote. Kan preutfylles automatisk eller av saksbehandler. Har en valgfri `kvotesporsmal_algoritme` for automatisk besvarelse.

**Språkstøtte:** Kvotetyper har `navn` per språk. Kvotespørsmål har `navn` og `kvotesporsmaltekst` per språk.

**Grunnlag og aldersgrenser:** HK-dir har meldt uklarhet om forskjellen mellom aldersgrense på kvotetype og aldersgrense på grunnlag, og om «automatisk valg av grunnlag» setter synlighet i saksbehandling eller velger automatisk. Spørsmålet om alder over 23 inkluderer de som fyller 23 samme år er også åpent ([TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)).

### Forslag: relativ fordeling på kvotetypenivå

> **Status:** forslag, ikke besluttet. Må forankres med prosjektleder.

I dag settes antall tilbud absolutt per utdanningskvote per utdanningstilbud. For UHG med hundrevis av utdanningstilbud betyr det hundrevis av manuelle konfigurasjoner per opptak. Forslaget er å flytte til **relativ fordeling** på kvotetypenivå i regelverkssamlingen, med mulighet for **absolutte unntak** for spesielle kvoter.

#### Slik fungerer det

Regelverkssamlingen definerer prosentvis fordeling mellom kvotetyper:

```
Regelverkssamling «UHG 2027»:
  ORDF (førstegangsvitnemål): 50 %
  ORD  (ordinær):             50 %
```

Et utdanningstilbud setter bare totaltall og eventuelle absolutte kvoter:

```
Utdanningstilbud «Sykepleie Nord»:
  Antall tilbud som skal gis: 278
  Samisk kvote: 2 (absolutt)
```

Plasstildelingen regner:

```
278 totalt − 2 samisk = 276 til relativ fordeling
ORDF: 276 × 50 % = 138
ORD:  276 × 50 % = 138
Plassflyt: samisk → ORD
```

#### Hva dette løser

- **Massivt redusert manuelt arbeid.** Fordelingen settes én gang på regelverkssamlingen, ikke per utdanningstilbud.
- **Konsistens.** Alle utdanningstilbud som bruker samme regelverkssamling får automatisk riktig fordeling.
- **Separasjon av ansvar.** Samordna opptak eier fordelingen (forskriftsfestet), lærestedet eier bare unntakene (spesielle kvoter).

#### Åpne spørsmål

1. **Overstyring per utdanningstilbud.** Trenger noen utdanningstilbud en annen fordeling enn den regelverkssamlingen angir? Forslag: overstyring er tillatt men sjelden, og flagges synlig.

2. **Avrunding.** 277 totalt − 2 samisk = 275 → 137,5 / 137,5. Hvem får den ekstra plassen? Forslag: én kvotetype er «resten» (typisk ORD) og tar eventuelle avrundingsdifferanser.

3. **Flere spesielle kvoter.** Et utdanningstilbud kan ha samisk kvote (2) + nordnorsk kvote (5). Beregning: 278 − 2 − 5 = 271, fordelt 50/50. Hva hvis de spesielle kvotene til sammen overstiger totaltallet? Svar: ikke lov — saksbehandler får varsel om feil.

4. **Forholdet til «antall tilbud som skal gis».** I dag er dette et absolutt tall per utdanningskvote. Med denne endringen blir det et beregnet tall — utledet fra relativ fordeling, totaltall og spesielle kvoter. Lærestedet setter bare totaltallet per utdanningstilbud.

5. **Forholdet til «antall ønsket ja-svar» i supplering.** Er dette også relativt? Svar: nei, dette er et absolutt tall (tak) på utdanningstilbudet som ikke skal overstiges i supplerings- og etterfyllingsrunder.

6. **Fagskole og lokale opptak.** Gjelder 50/50-fordelingen bare UHG? Fagskole kan ha en helt annen kvotestruktur. Regelverkssamlingen må kunne definere ulike fordelinger per opptakskontekst.

#### Konsekvenser

Beregningslogikken i plasstildelingen blir noe mer kompleks (relativ fordeling → absolutte tall før tildeling), men det er en engangsberegning per plasstildelingskjøring. Se også [plasstildeling/design.md](../plasstildeling/design.md) for hvordan dette påvirker algoritmen.

### Kobling til utdanningstilbud og opptak

Et utdanningstilbud kobles til regelverket via tre felter:

| Felt | Hva det peker på |
|------|-------------------|
| `regelverk_organisasjonskode` + `regelverksamling_kode` | Hvilken regelverkssamling som gjelder |
| `kompetanseregelverk_kode` | Hvilket kompetanseregelverk innenfor samlingen |
| `rangeringsregelverk_kode` | Hvilket rangeringsregelverk innenfor samlingen |

Kvoter opprettes per utdanningstilbud i `opptak_v2.kvote`, med FK til `regelverk.kvotetype` i den regelverkssamlingen utdanningstilbudet bruker.

**Filtrering og søk:** HK-dir melder at det er kritisk å kunne filtrere regelverk på tilknyttede utdanningstilbud og læresteder ([TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)). Fagskole omgår i dag dette med fritekst i navn, men det fungerer ikke for UHG. Dette er beskrevet som erstatning for basisdatarapportene.

---

## Del 3: gap-analyse per oppgave

Evidensnivå: **M** = verifisert i datamodellen, **V** = verifisert i koden, **H** = meldt av HK-dir, **S** = antakelse fra spesifikasjon/behov

### Oppgave 1 — Etablere og forvalte en regelverkssamling

| Krav | Funn | Gap                                                                                             | Ev. |
|------|------|-------------------------------------------------------------------------------------------------|-----|
| Opprette regelverkssamling | `opprettRegelverksamling` mutasjon | Ingen                                                                                           | V |
| Eierskap (hvem opprettet og forvalter) | `organisasjonskode` i PK | Ingen                                                                                           | M |
| Et lærested bruker en samling opprettet av en annen aktør | `kopierRegelverksamling` kopierer alt | Kopien er uavhengig — det er kloning, ikke deling                                               | V |
| Flere lærsteder bruker samme samling parallelt | Hver får sin kopi; endring hos én påvirker ikke andre | **Det er ikke deling, det er kopiering.** Hvis originalen endres, må kopiene oppdateres manuelt | V |
| Rettighetsstyring: «eier» vs. «bruker» | `MODIFISERE_REGELVERK`-handling | **Ingen «bruker»-rolle.** Tilgangen er alt-eller-ingenting                                      | V |
| Lærsteder kan se SOs samlinger for kontroll | Uavklart | **Tilgangsmodell-beslutning trengs**                                                            | H |
| Kopiere fra detaljvisning | Mangler for regelverkssamling | **Designes som mønster for alle elementtyper**                                                  | H |
| Deaktivere en regelverkssamling | `er_aktiv`-flagg | Ingen                                                                                           | M |
| Slette en regelverkssamling | `slettRegelverksamling` mutasjon | Feiler hvis i bruk (FK-integritetssjekk)                                                        | V |
| Språkstøtte for navn | `regelverksamling_sprak` med nob, nno, eng, sme | Ingen                                                                                           | M |
| Søke opp regelverkskomponenter i samlingene | Fritekst-søk finnes | **Mangler søk på tilknyttede utdanningstilbud og læresteder** — kritisk for kontroll            | H |

**Hovedfunn:** Kravet sier «et lærested skal kunne *bruke* en regelverkssamling opprettet av en annen aktør». Løsningen gjør dette via kopiering, ikke via deling med lesetilgang. Det betyr at endringer i originalen ikke propageres. HK-dir har i tillegg meldt at læresteder må kunne *se* SOs samlinger for kontrollformål — dette er uavklart i tilgangsmodellen.

### Oppgave 2 — Definere kompetansekrav

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Beskrive hvilke krav en søker må oppfylle | Hierarki: kompetanseregelverk → kompetansekrav → tilleggskrav → kravliste → kravlisteelement → kravelement | Ingen | M+V |
| Kravene på flere språk | `kompetanseregelverk_sprak` (beskrivelse + forklaring), `kravelement_sprak` (beskrivelse), fire språk | **Kompetansekrav har bare et enkeltspråklig `navn`-felt.** Mellomnivået mangler flerspråklig støtte | M |
| Samme krav brukes i flere regelverk uten å lages på nytt | Kravelementer er egne entiteter og kan gjenbrukes innenfor en regelverkssamling | **Gjenbruk på tvers av regelverkssamlinger krever kopiering.** Kravelementer er scopet til `(organisasjonskode, regelverksamling_kode)` | M |
| Logisk kombinasjon av krav (AND/OR) | `krever_alle`-flagg på kompetansekrav, tilleggskrav og kravliste | Ingen | M |
| Karakterkrav-snitt | `kravliste.karakterkrav_snitt` | Ingen | M |
| Vitnemålskrav | `kravelement.vitnemalskrav_kode1`, `vitnemalskrav_kode2` | **Kodekilde og uttømmende liste uavklart.** Kun KL og R94 finnes; HK-dir sier listen må være komplett | M+H |
| GSK som kravelement for fagskole | `krever_generell_studiekompetanse` på kompetansekrav | **Fungerer ikke for fagskole.** Må avklares om GSK skal være kravelement der | H |
| «Automatisk valg av grunnlag» | Felter finnes: `aldersgrense`, `aldersgrense_operator`, `krever_et_vitnemaal`, `krever_foerstegangsvitnemaal` | **Uklart hva det gjør.** HK-dir spør om det styrer synlighet eller automatisk valg, og om 23-årsgrensen inkluderer de som fyller 23 | H |
| Grunnlagskobling | `kompetansekrav_grunnlag` junction-tabell | Ingen | M |
| Validering av markdown | `MarkdownForklaringValidator` sjekker XSS | Ingen | V |
| Bruksstatistikk | `KravelementBruk` og `GrunnlagBruk` med antall aktive/totale | Ingen | V |

### Oppgave 3 — Definere hvordan søkere rangeres (poengberegning)

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Støtte flere delberegninger | Poengtyper (poengklasse + poengvariant) med min/maks/desimaler | Ingen | M |
| Definere poengformel | `poengformel` med `uttrykk` og kobling til poengklasser | Ingen | M |
| Poengalgoritme | `poengalgoritme`-tabell med `algoritme`-kolonne; `AlderspoengAlgoritme`, `KjonnspoengAlgoritme` i kode | Ingen | M+V |
| Poenglikhetsregel på riktig nivå | Settes i dag på rangeringsregelverk | **Feil plassering.** HK-dir: skal gjelde per opptak, ikke per regelverk. Feltet på rangeringsregelverk skal fjernes | M+H |
| Ulike regler per opptakstype | Globale regler, ingen kobling til opptakstype | **Forskriften krever ulike defaults.** UHG: loddtrekning (2027); fagskole: alder (ikke valgfri) | H |
| Lærested velger «alle med lik sum får tilbud» | Regelen finnes i den globale tabellen | **Valgfriheten er ikke kanalisert.** Intet hindrer feil valg | M |
| Bulk-kobling grunnlag ↔ poengtyper | Kobles én og én i dag | **HK-dir: «laaang tid».** Trenger designet bulk-interaksjon | H |
| Kobling mellom rangeringsregelverk og grunnlag | `rangeringsgrunnlag_poengtype` junction-tabell | Ingen | M |
| Språkstøtte | Rangeringsregelverk, poengklasse, poengvariant, poengtype har alle _sprak-tabeller | Ingen | M |

**Hovedfunn — poenglikhetsregel:** Dagens modell plasserer poenglikhetsregelen på rangeringsregelverket. HK-dir og domeneeksperter er enige om at dette er feil: regelen skal gjelde per regelverkssamling (eller opptak), uavhengig av hvilket rangeringsregelverk som brukes. I UHG er loddtrekning default fra 2027, med mulighet for lærestedet å velge «alle med lik sum». I fagskole er alder forskriftsfestet og ikke valgfri, men det kan bli aktuelt å tillate loddtrekning eller «alle med lik sum» i tillegg. Foreslått plassering: regelverkssamlingsnivå. Tidspunkt for levert søknad gjelder kun for runden «ledige studieplasser».

### Oppgave 4 — Definere kvoter

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Reservere plasser til bestemte grupper | `kvotetype` med `kvoterangering` (KP, SP, SPEV, IH) | Ingen | M |
| Plassflyt ved ufylte kvoter | `kvotetype_kode_plassflyt` self-referanse | Ingen | M |
| Overstyring av plassflyt per utdanningstilbud | `kvote.kvotetype_kode_overstyrer_plassflyt` | Ingen | M |
| Kvoteprioritet | `kvoteprioritet_default` på kvotetype; `kvoteprioritet_overstyring` på kvote | Ingen | M |
| Kvotespørsmål for kvotetilhørighet | `kvotesporsmal` med preutfylling og algoritme | Ingen | M |
| Grunnlag med aldersgrenser per kvote | `kvotetype_grunnlag` med `aldersgrense_default` og `aldersgrense_operator_default` | Ingen | M |
| Sirkularitetsvern for plassflyt i skjema | **Ingen CHECK-constraint eller trigger** | Sykler kan oppstå i konfigurasjonen; fanges kun i algoritmen ved kjøring | M+V |
| Språkstøtte | `kvotetype_sprak`, `kvotesporsmal_sprak` | Ingen | M |

### Oppgave 5 — Koble spesielle opptakskrav til kvoter

| Krav                                             | Funn | Gap | Ev. |
|--------------------------------------------------|------|-----|-----|
| Ekstra krav på en enkelt kvote                   | **Ingen direkte kobling** fra kvotetype til kompetanseregelverk | **Mangler i modellen.** En kvotetype har grunnlag og kvotespørsmål, men ingen FK til kompetanseregelverk | M |
| Uten å endre kravene for hele utdanningstilbudet | Utdanningstilbudet har ett kompetanseregelverk; kvoter har ikke egne | Bekrefter gapet: kvotespesifikke kompetansekrav er ikke støttet | M |

**Hovedfunn:** Dette er det største gapet i regelverksløsningen. En kvotetype kan ha kvotespørsmål som avgjør *tilhørighet*, men den kan ikke ha egne *kompetansekrav* som avgjør kvalifisering. Hele utdanningstilbudet deler ett kompetanseregelverk. For å legge strengere krav på en kvote (f.eks. krav om spesiell bakgrunn) må dette i dag løses utenfor systemet. Meldt som behov: [#511](https://github.com/sikt-no/fs/issues/511), [#265](https://github.com/sikt-no/fs/issues/265).

### Oppgave 6 — Koble regelverket til opptak og utdanningstilbud

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Utdanningstilbud vet hvilket regelverk som gjelder | `utdanningstilbud.kompetanseregelverk_kode` + `rangeringsregelverk_kode` | Ingen | M |
| Kvoter på utdanningstilbud | `opptak_v2.kvote` med FK til `regelverk.kvotetype` | Ingen | M |
| Kontroll når regelverket endres under behandling | **Ingen låsing, varsling eller versjonering** | **Udefinert oppførsel.** Regelverket kan endres mens søknader behandles mot det | V |
| Filtrere regelverk på tilknyttede studier og lærsteder | Mangler | **Kritisk for kontroll.** Erstatning for basisdatarapportene | H |
| Regelverkssamling må matche mellom utdanningstilbud og kvoter | FK-er sikrer at kvotens regelverkssamling matcher utdanningstilbudets | Ingen | M |

**Hovedfunn:** To gap her. Det ene er at det ikke finnes noen mekanisme som fanger opp at regelverket endres etter at søknadsbehandling har startet. Det andre er at læresteder ikke kan filtrere regelverk på tilknyttede utdanningstilbud — HK-dir beskriver dette som kritisk for kontrollarbeidet, og fagskole omgår i dag begrensningen med fritekst i navn.

---

## Funn på tvers av oppgavene

### 1. Poenglikhetsregel er feil plassert

HK-dir sier eksplisitt at poenglikhetsregel «skal ikke settes her» (på rangeringsregelverk). Regelen skal gjelde per opptak, ikke per regelverk. Forskriften er ulik mellom UHG og fagskole. Foreslått ny plassering: regelverkssamlingsnivå eller opptaksnivå. Feltet på rangeringsregelverk skal fjernes. Avklaringsspørsmål: skal fagskole også kunne velge «alle med lik sum»?

### 2. Kopiering er ikke deling

Modellen støtter at flere organisasjoner har samme regelverkssamling-kode, men hver har sin egen kopi. Endringer i originalen propageres ikke. HK-dir melder i tillegg at lærsteder må kunne *se* SOs samlinger for kontrollformål. Tilgangsmodellen for dette er uavklart.

### 3. Spesielle opptakskrav på kvoter mangler

Ingen kobling fra kvotetype til kompetanseregelverk. Meldt som behov: [#511](https://github.com/sikt-no/fs/issues/511), [#265](https://github.com/sikt-no/fs/issues/265).

### 4. Regelverksendring under behandling er uhåndtert

Ingen versjonering, låsing eller sporingslogg. Denne blindsonen er alvorligst når den kombineres med at saksbehandling kan pågå over lang tid, og at kompetansekrav kan ha komplekse hierarkier med mange nivåer.

### 5. Kompetansekrav.navn er ikke flerspråklig

Toppnivået (kompetanseregelverk) og bunnnivået (kravelement) har flerspråklig støtte, men mellomnivået kompetansekrav har bare et enkelt `navn`-felt. HK-dir har meldt at det er viktig å gi navn til kompetansekrav per regelverk, særlig for fagskole og kontrollarbeid.

### 6. GSK fungerer ikke for fagskole

«Krever generell studiekompetanse» er meningsfylt for UHG, men ikke for HYU. Det må avklares om GSK skal være kravelement i fagskolens kompetanseregelverk, eller om fagskolens kvalifiseringsstruktur trenger en annen inngang.

### 7. Filtrering på tilknyttede utdanningstilbud er kritisk

HK-dir beskriver dette som erstatning for basisdatarapportene. I dag finnes fritekst-søk på kode og navn, men ikke filtrering på hvilke utdanningstilbud som bruker et gitt regelverk.

---

## HK-dir-feedback (august 2026)

HK-dir har testet regelverk-domenet og gitt detaljerte tilbakemeldinger, sortert i tre saker:

**[TAKE-221](https://sikt.atlassian.net/browse/TAKE-221)** (Done) — feil og direkte gjennomførbare forbedringer. Positive tilbakemeldinger: koder vises nå i kompetanseregelverk-lista, mulighet for å opprette kravelement direkte i uttrykket, valg av navn/kode i forhåndsvisning, aktiv som default, poengvarianter «ok».

**[TAKE-235](https://sikt.atlassian.net/browse/TAKE-235)** (To Do) — designspørsmål. Åpne:
- Kopiere fra detaljvisning (mønster for alle elementtyper; mangler helt for regelverkssamling)
- Bulk-kobling grunnlag ↔ poengtyper

Lukkede: målform/språkhåndtering, regelverk-landingssiden, angre i uttrykksredigering, kontroll-/revisjonsarbeidsflyten. Poengformler-editoren → [TAKE-307](https://sikt.atlassian.net/browse/TAKE-307).

**[TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)** (To Do) — domene-/backend-avklaringer. Åpne:
- Poenglikhetsregel: feil plassering, skal fjernes fra rangeringsregelverk
- Vitnemålskravkode: kodekilde og uttømmende liste uavklart
- GSK som kravelement for fagskole
- «Automatisk valg av grunnlag»: uklart hva det gjør
- Filtrere regelverk på tilknyttede studier og lærsteder (kritisk)
- Søke opp regelverkskomponenter i samlingene
- Skal lærsteder kunne se SOs samlinger? (tilgangsmodell-beslutning)

Lukkede: kvalifisering/rangering/GSK på grunnlag, kjernefag, algoritme (→ TAKE-273), kvotetype (→ TAKE-274), kopiere regelverkssamling, sette til inaktiv (→ TAKE-254).

---

## Begrepsforklaringer — Oppretting og vedlikehold av regelverk

**Opptak** — selve «hendelsen» der søkere kan søke om studieplass innenfor en gitt periode — f.eks. «Samordna opptak 2027». Ett opptak kan omfatte flere lærsteder og mange utdanningstilbud.

**Opptaksregelverk** — fellesbegrep for reglene som avgjør om en søker er kvalifisert, og hvordan søkere rangeres mot hverandre. Består i praksis av kompetansekrav og rangeringsregler.

**Regelverkssamling** — en samlet «pakke» med opptaksregelverk (kompetansekrav, rangeringsregler, kvoter osv.) som kan tas i bruk av ett eller flere utdanningstilbud. Tenk på den som en mal — opprettet én gang, brukt mange steder.

**Kompetansekrav** — kravene en søker må oppfylle for å bli vurdert som kvalifisert til et studium (f.eks. bestemte fag, karakterer, eller yrkeserfaring).

**Rangeringsregelverk og poengberegning** — metoden som bestemmes for å rangere kvalifiserte søkere mot hverandre når det er flere søkere enn plasser — altså hvordan poengsummen deres beregnes.

**Poenglikhetsregel** — regelen som avgjør hvem som skal prioriteres når to søkere har eksakt samme poengsum. Forskriftsfestet per opptakstype: loddtrekning for UHG (fra 2027), alder for fagskole, søknadstidspunkt for ledige studieplasser.

**Kvotetype** — en definert køordning som reserverer en andel plasser for en bestemt gruppe søkere (f.eks. førstegangsvitnemål, ordinær kvote, eller en særskilt kvote). Kvotetypen er malen; når den kobles til et utdanningstilbud i et opptak, blir den en **utdanningskvote** — se [plasstildeling/design.md](../plasstildeling/design.md).

**Plassflyt** — når en kvotetype ikke fylles opp, kan de ledige plassene automatisk gå videre til en annen, definert kvotetype i stedet for å stå tomme. Defineres på kvotetypen og kan overstyres per utdanningstilbud.

**Utdanningstilbud** — det konkrete studiet en søker kan søke på (f.eks. «Sykepleie, Universitetet i Oslo, høst 2027»), knyttet til ett opptak og én regelverkssamling.

**Sentralt opptaksorgan** — en aktør (som Samordna opptak) som ikke selv er et lærested, men som kan opprette og forvalte regelverkssamlinger på tvers av flere lærsteder, og som kan koordinere et opptak der flere lærsteder deltar.

**Grunnlag** — dokumentasjonsgrunnlaget søkeren vurderes mot (f.eks. generell studiekompetanse, realkompetanse, 23/5-regelen). Et grunnlag kan brukes i både kompetansekrav og rangeringsregelverk.

**Kravelement** — det atomære kravet i et kompetanseregelverk: et bestemt fag med karakterkrav, eller et annet krav som yrkeserfaring eller aldersgrense. Har to typer: FAG og ANNET.

**Poengklasse** — en kategori i poengberegningen (f.eks. karakterpoeng, tilleggspoeng, alderspoeng). Har en default-verdi.

**Poengvariant** — en variant innenfor en poengklasse. Poengtypen er unikt identifisert av kombinasjonen poengklasse + poengvariant.

**Kvoterangering** — metoden for å rangere søkere innenfor en kvote. Fire typer: KP (Konkurransepoeng), SP (Skolepoeng), SPEV (Spesiell vurdering), IH.

**Kvotespørsmål** — spørsmål som avgjør om en søker tilhører en bestemt kvote. Kan besvares automatisk, av saksbehandler, eller preutfylles.

**Ledige studieplasser** — en rundetype i plasstildelingen der rangeringen styres av søknadstidspunkt i stedet for poeng. Relevant for regelverket fordi poenglikhetsregelen «tidspunkt for levert søknad» kun gjelder denne rundetypen. Se [plasstildeling/design.md](../plasstildeling/design.md) for fullstendig definisjon av rundetyper.

---

## Oppgavenummerering

| # | Oppgave | Github-issue |
|---|---------|-------------|
| 1 | Etablere og forvalte en regelverkssamling | |
| 2 | Definere kompetansekrav | |
| 3 | Definere hvordan søkere rangeres (poengberegning) | |
| 4 | Definere kvoter | |
| 5 | Koble spesielle opptakskrav til kvoter | |
| 6 | Koble regelverket til det konkrete utdanningstilbudet og opptaket | |

---

## Neste steg

1. **Flytt poenglikhetsregel.** Feltet på rangeringsregelverk skal fjernes. Avklar plassering: regelverkssamling eller opptak? Avklar om fagskole skal kunne velge «alle med lik sum».
2. **Ta beslutning 3:** Hva skjer med regelverket når søknader er under behandling? Låsing, versjonering, varsel, eller «på eget ansvar»?
3. **Avklar oppgave 5:** Spesielle opptakskrav på kvoter. Skal modellen utvides med FK fra kvotetype til kompetanseregelverk, eller løses dette via et annet mønster?
4. **Avklar GSK for fagskole.** Trenger fagskolens kvalifiseringsstruktur en annen inngang enn «kreves generell studiekompetanse»?
5. **Avklar vitnemålskravkoder.** Kodekilde og uttømmende liste må på plass før bygging.
6. **Avklar «automatisk valg av grunnlag».** Hva gjør det, og hva *bør* det gjøre?
7. **Design tilgangsmodell for synlighet.** Skal lærsteder kunne se SOs samlinger? Tilgangsmodell-beslutning.
8. **Design bulk-kobling grunnlag ↔ poengtyper.** Meldt som tidstyv av HK-dir.
9. **Bygg filtrering på tilknyttede studier.** Kritisk for kontrollarbeidet.
10. **Skriv eksempler.** Én Gherkin-feature per oppgave i `krav/02 Opptak/`.

---

## Kjernetjenester i koden

Verifisert i `fs-plattform/opptak`:

| Tjeneste | Ansvar |
|----------|--------|
| `RegelverksamlingService` | Oppretter, oppdaterer og deaktiverer regelverkssamlinger med flerspråklige navn |
| `KopierRegelverksamlingService` | Kopierer alle 30+ tabeller fra en regelverkssamling til en annen organisasjon |
| `KompetanseregelverkService` | CRUD for kompetanseregelverk med nestede kompetansekrav, tilleggskrav, kravlister |
| `KravelementService` | CRUD for kravelementer med vitnemålskrav-validering |
| `RangeringsregelverkMutations` | CRUD for rangeringsregelverk med poengtyper og poenglikhetsregel |
| `PoengklasseService`, `PoengvariantService`, `PoengtypeService` | CRUD for poengberegningens byggeklosser |
| `PoengformelService` | CRUD for poengformler med uttrykk |
| `PoenglikhetService` | CRUD for globale poenglikhetsregler |
| `KvotetypeMutations` | CRUD for kvotetyper med grunnlag og plassflyt |
| `KvotesporsmalService` | CRUD for kvotespørsmål med preutfylling og algoritme |
| `RegelverkBrukService` | Bruksstatistikk og in-bruk-sjekker for sletting |
| `AutomatiskPoengberegningService` | Automatisk poengberegning med alderspoeng- og kjønnspoeng-algoritmer |

---

## Referanser

- Prosessbeskrivelse «Oppgave 1–6» fra behovskartlegging
- Gap-analyse mot `fs-plattform/opptak` koden (2026-09-10)
- Migrasjoner V4, V36, V184–V189 (regelverksamling-refaktoreringen)
- [Plasstildeling design](../plasstildeling/design.md) — bruk av regelverket i plasstildelingen
- GitHub issues: [#511](https://github.com/sikt-no/fs/issues/511), [#265](https://github.com/sikt-no/fs/issues/265) (spesielle opptakskrav på kvoter)
- HK-dir regelverk-feedback: [TAKE-221](https://sikt.atlassian.net/browse/TAKE-221), [TAKE-235](https://sikt.atlassian.net/browse/TAKE-235), [TAKE-236](https://sikt.atlassian.net/browse/TAKE-236)
- Slack-samtale om poenglikhetsregler (2026-09-10): UHG loddtrekning default, fagskole alder forskriftsfestet, ledige studieplasser søknadstidspunkt