# Plasstildeling

## Metadata

- **Issue**: [sikt-no/fs#216](https://github.com/sikt-no/fs/issues/216)
- **Initiativ**: #216 Ferdigstilling av plasstildeling i opptak
- **Fase**: design
- **Prioritet**: high
- **Type**: feature
- **Eier**: –
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lenker**:
  - design: [design.md](design.md) — mål, retning, prinsipper, regelverk og åpne spørsmål
  - plan: –
  - review: –
  - PRs: –
  - Jira Epic: [TAKE-3](https://sikt.atlassian.net/browse/TAKE-3)
  - Confluence: [T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377)
- **Krav (Gherkin)**: `krav/02 Opptak/14 Plasstildeling/` (skal utarbeides)

## Kort beskrivelse

Ferdigstille plasstildeling i opptak slik at opptaksforvalter kan opprette runder, kjøre plasstildelinger, publisere resultat til søker, og håndtere svar — klar for første samordna opptak 2027.

## Oppgaver

| # | Oppgave | Github-issue |
|---|---------|-------------|
| 1 | Legge til runder for plasstildeling i ett opptak | |
| 2 | Sette antall tilbud som skal gis per utdanningskvote | |
| 3 | Sette plassflyt mellom utdanningskvoter | |
| 4 | Starte en ny plasstildeling | |
| 5 | Gjennomføre plasstildeling | |
| 6 | Vise resultatet til saksbehandler | |
| 7 | Publisere resultatet til søkerne | |
| 8 | Håndtere svar fra søker | |
| 9 | Systemet gir automatisk nye tilbud ved nei-svar (utenfor scope) | NA|

## Statuslogg

| Dato       | Hendelse                          | Av            | Lenke til review        |
|------------|-----------------------------------|---------------|-------------------------|
| 2026-09-09 | Tatt inn i veikart (design)       | @karensikt    | –                       |
| 2026-09-09 | Gap-analyse verifisert mot kode   | –             | design.md               |
| 2026-09-09 | Del 1 og 2 renskrevet             | @karensikt    | design.md               |

---

## Funksjonell løsning per oppgave

### Oppgave 1 — legge til runder for plasstildeling i ett opptak

Opptaksrunder opprettes sammen med opptaket og knyttes til ett opptak. Grunnlagsdata er navn, rundetype og svarfrist.

**Figma-prototype:** https://twins-gave-22504012.figma.site/

**Issue:** [#107](https://github.com/sikt-no/fs/issues/107) (lukket)

### Oppgave 2 — sette antall tilbud som skal gis per utdanningskvote

For hvert utdanningstilbud må det defineres hvor mange tilbud som skal gis i hver utdanningskvote i denne plasstildelingen. Saksbehandler ser en liste over utdanningstilbud med utdanningskvoter, aksepterte tilbud, gitte tilbud og antall planlagte studieplasser (kapasitet). Tallet settes per utdanningskvote; totaltallet vises.

Antall tilbud som skal gis per utdanningskvote virker.

**Begrepsendring:** feltnavnet «overbooking» skal endres. Historisk betydde overbooking at lærestedet ga flere tilbud enn antall studieplasser, som buffer mot frafall. I dagens felt er verdien i praksis rundens absolutte antall tilbud som skal gis, ikke et tillegg på toppen.

**Utgått fra tidligere utkast:** ønsket antall ja-svar totalt, med utledet overbookingsrate og forrige års tilbud er ikke med.

**Figma-prototype:** https://undo-aloft-06472321.figma.site/

### Oppgave 3 — sette plassflyt mellom utdanningskvoter

Plassflyt mellom utdanningskvoter på samme utdanningstilbud virker, inkludert flere ledd etter hverandre.

Det som ikke er mulig: en utdanningskvote kan bare sende ledige plasser videre til én mottakende utdanningskvote, plasser kan ikke flyte mellom ulike utdanningstilbud, og de kan ikke flyte fra én plasstildeling til en senere.

### Oppgave 4 — starte en ny plasstildeling

Man bestiller en plasstildeling, og den kjøres automatisk i bakgrunnen. Den bygger riktig videre på forrige publiserte runde.

**Åpent:** i hvilken grad utledes starten på en runde fra datoene som er satt i opptaket? Setter man dato for rundene og lar systemet starte tildelingen, eller er det en startknapp noen må trykke på? Svaret avgjør om «start» er en handling eller en tilstand.

**Svakhet:** feiler en plasstildeling, er eneste mulighet å starte en helt ny. Det finnes ingen måte å rette opp eller kjøre den samme på nytt.

**Issue:** [#108](https://github.com/sikt-no/fs/issues/108) (lukket)

### Oppgave 5 — gjennomføre plasstildeling

Tildelingen avgjør hvor mange søkere som får plass i hver utdanningskvote, og hva poenggrensen for å komme inn ble. Den må ta hensyn til plassflyt mellom utdanningskvoter, og til at noen utdanningskvoter kan gi tilbud til alle kvalifiserte uten poenggrense. Tilbudsgarantier tas fra den utdanningskvoten lærestedet eller HK-dir har markert.

Søkeren prøves i utdanningskvotene etter kvoteprioritet — normalt den mest spesielle utdanningskvoten først, den minst spesielle sist.

Rangeringen hentes fra søknadsbehandlingen. Hver søker som er kvalifisert til en utdanningskvote får beregnet poengsum og rangering der, slik at det er tydelig hvem som står først i køen. Selve rangeringen og poengberegningen virker, men systemet fanger ikke opp at en søker har endret søknaden sin mellom runder, og en søker som mister kvalifiseringen forsvinner stille fra resultatet i stedet for å få et tydelig avslag (bryter prinsipp 1).

Selve tildelingen virker, inkludert utdanningskvoter uten poenggrense.

**Poenggrensen per utdanningskvote beregnes og lagres aldri**, selv om det finnes en plass å vise den. Fjorårets medianverdi, som er viktig for hvem som får tidlig tilbud, settes i forbindelse med søknadsbehandlingen og er en annen kilde.

**Åpne spørsmål:** se [design.md](design.md), del 2, punkt 10 (flere poengsummer i samme kvotetype) og punkt 7 (delte ventelistenumre).

**Issue:** [#71](https://github.com/sikt-no/fs/issues/71) (lukket), [#92](https://github.com/sikt-no/fs/issues/92) (lukket)

### Oppgave 6 — vise resultatet til saksbehandler

Hver søker skal ha ett tydelig svar per søknad: tilbud, venteliste med nummer, eller avslag. Fikk søkeren plass gjennom plassflyt fra en annen utdanningskvote, skal det kunne spores i etterkant, for eksempel ved klage.

Begge deler virker. **Ventelistenummeret når aldri fram til søkeren**, selv om innstillingen for å vise det finnes.

**Issue:** [#109](https://github.com/sikt-no/fs/issues/109) (lukket)

### Oppgave 7 — publisere resultatet til søkerne

Søkerne skal se resultatet sitt i Min kompetanse på et bestemt, kontrollert tidspunkt. Det må være mulig å beregne tildelingen før den gjøres synlig, og å velge å ikke publisere den i det hele tatt (prøvetildeling).

Publisering virker og gir kontroll over når søkeren ser resultatet. Ubegrensede prøveopptak på alle rundetyper er dermed godt løst, fordi beregning og publisering er separate steg — nettopp slik lærestedene har bedt om.

Søkeren skal se tilbud, avslag eller venteliste, og vedtaket med begrunnelse: kvalifisering, rangering, poenggrense. Hullet er ventelistenummeret fra oppgave 6.

**Issue:** [#111](https://github.com/sikt-no/fs/issues/111), [#72](https://github.com/sikt-no/fs/issues/72), [#221](https://github.com/sikt-no/fs/issues/221)

### Oppgave 8 — håndtere svar fra søker

Søkeren skal kunne akseptere eller avslå tilbudet, eller stå på venteliste, innenfor en svarfrist. Svarene skal kunne utløse en etterfylling som bygger videre på forrige plasstildeling.

Grunnfunksjonen virker: søkeren kan takke ja eller nei, og forrige rundes tilbud beholdes automatisk til neste runde.

Fire sider er verdt en faglig diskusjon, og alle fire står som avklaringspunkter i [design.md](design.md), del 2:

- Et nei-svar frigjør ikke plassen før svarfristen er ute. Blir plassen stående reservert for lenge?
- En søker som godtar og senere trekker seg, frigjør aldri plassen igjen.
- Når en søker har både et tilbud og et kansellert resultat på samme utdanningstilbud — hva skal vises?
- Det finnes ingen mulighet for saksbehandler å overstyre et enkelt resultat manuelt. Alt krever full omkjøring.

**Issue:** [#170](https://github.com/sikt-no/fs/issues/170), [#264](https://github.com/sikt-no/fs/issues/264), [#512](https://github.com/sikt-no/fs/issues/512)

### Oppgave 9 — systemet gir automatisk nye tilbud ved nei-svar på tilbud (utenfor scope)

Utenfor scope for 2027-opptaket. Systemet skulle automatisk gi nye tilbud fra venteliste når noen faller fra, og fylle på opp mot grensen for antall tilbud som skal gis, uten manuell overvåking.

Behovet står igjen som sannsynlig mangel mot HK-dirs meldte behov: lærestedene har bedt om en mekanisme som raskt kompenserer for søkere som takker nei fordi de fikk tilbud høyere opp, uten å vente på neste runde. Se avklaringspunkt 3 i [design.md](design.md).

---

## Mistenkte feil

Seks mistenkte feil er identifisert, og de er ikke bevisste valg:

| Feil | Konsekvens | Issue |
|------|------------|-------|
| Bortfall beregnes mot feil tilbud når en søker har flere tilbud samtidig | Søkeren kan miste et studieønske hun skulle beholdt | |
| Ventelistenumre kan kollidere mellom runder | To søkere kan ha samme nummer, eller samme søker ulike | |
| Fristsjekk bruker applikasjonsklokke i stedet for databaseklokke | Fristsjekken kan være upålitelig ved klokkedrift | |
| Historiske resultater leses tilbake med feil resultattype (kollaps til IKKE_GYLDIG) | Søker som mistet kvalifisering forsvinner stille — bryter prinsipp 1 | |
| Harde tallgrenser (9999/99) feller hele kjøringen | En plasstildeling med for mange søkere krasjer | |
| Søkers svar knyttes til runde på løpenummer alene, uten rundetype | Svar kan havne på feil runde når det finnes flere rundetyper | |

Disse bør registreres som issues, ikke behandles som åpne spørsmål.

---

## Gap-analyse per oppgave

Evidensnivå: **M** = verifisert i datamodellen, **V** = verifisert i koden

### Oppgave 1 — Legge til runder

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Navn på runde | `opptak.opptaksrunde.navn` NOT NULL | Ingen | M |
| Svarfrist for søker | `opptaksrunde.svarfrist` NOT NULL | Ingen | M |
| Dato for når plasstildelingen skal publiseres til søkere | **Ingen kolonne** | Feltet finnes ikke i modellen | M |
| Rundetype (hoved/tillegg/supplerende) | `opptaksrundetype_kode` | Se strukturfunn under | M |
| Publiseringstidspunkt | `opptaksrunde.publiseringstidspunkt` (nullable) | Automatisk publisering avgrenset bort | M |
| Periode for å endre parametere | `opptaksrunde.periode_endre_opptaksparametere` (tstzrange) | Finnes i modellen, ikke i krav | M |

**Strukturfunn:** `opptaksrundetype_kode` er del av **primærnøkkelen** til `opptak.opptaksrunde` og følger med i hver fremmednøkkel ut derfra. En runde kan ikke bytte type etter oppretting, og løpenummer er unikt per rundetype, ikke per opptak.

### Oppgave 2 — Antall tilbud som skal gis

Fire tall i fire tabeller:

| Tabell | Kolonne | Nivå | Brukes av algoritmen | Ev. |
|--------|---------|------|---------------------|-----|
| `opptak.utdanningstilbud` | `antall_studieplasser` | Per utdanningstilbud (kapasitet) | Nei — kun visning | M+V |
| `opptak.kvote` | `onsket_antall_deltakere` | Per kvotetype, per opptak | **Fallback** når overbook mangler | M+V |
| `opptak.opptaksparametere` | `overbook_antall_plasser` | Per utdanningskvote **per runde** | **Ja — dette er antall tilbud som skal gis** | M+V |
| `plasstildeling.studiekvote` | `onsket_antall_tilbud` NOT NULL | Per utdanningskvote **per plasstildeling** | Nei — kun visning/snapshot | M+V |

**Verifisert i koden:** `KvoterService:98-104` er eksplisitt: `overbook_antall_plasser` er antall tilbud som skal gis, med fallback til `onsket_antall_deltakere`. Begrepet «overbook» er misvisende — kolonnen er det faktiske antallet tilbud som skal gis, ikke et tillegg.

### Oppgave 3 — Plassflyt

| Krav | Funn | Ev. |
|------|------|-----|
| Flyt til én mottakende utdanningskvote | `studiekvote` har **ett** sett flyt-kolonner — bekreftet, én mottaker | M |
| Kan ikke krysse utdanningstilbud | Flyt-FK-en gjenbruker kildens org/utdanning/periode — strukturelt umulig | M |
| Flyt fra en tidligere plasstildeling | Modellen kan peke på en annen runde/tildeling, men **koden bruker det ikke** | M+V |
| Plassflyt opererer innenfor én tildeling | `Opptakskjoringsalgoritme` bygger flytkart og omfordeler innenfor én kjøring | V |
| Mellom runder: `basert_pa`-kjeden | Resultater videreføres via `basert_pa`, ikke plassflyt | V |
| Plassflyt kan endres per tildeling | Tre nivåer: `regelverk.kvotetype` → `opptak.kvote` → `studiekvote` | M |
| Siste utdanningskvote (stopper flyten) | NULL i flyt-kolonnene | M |
| Sirkularitetsvern i koden | `findPaafyllingsStudiekvoter` og `finnKvoterSomFlyterTil` bruker visited-sett, logger `warnf("Cycle detected...")` | V |
| Sirkularitetsvern i skjemaet | **Ingen CHECK-constraint eller trigger** | V |
| Test for sirkularitet | `testCircularPlassflytDoesNotHang` bekrefter at algoritmen håndterer sykler | V |

Plassflyt opererer kun innenfor én plasstildeling. Kryss-tildeling-kolonnene i modellen brukes ikke av koden. Sirkularitetsvernet finnes i koden men ikke i databasen.

### Oppgave 4 — Starte en ny plasstildeling

| Krav | Funn | Ev. |
|------|------|-----|
| Bygge på forrige publiserte tildeling | `plasstildeling.*_basert_pa` — `OpprettPlasstildelingService` finner grunnlaget automatisk | M+V |
| Kjører automatisk i bakgrunnen | `plasstildelingsstatus` med default `'KLAR'`, egen kodetabell | M |
| Beregning skilt fra publisering | `plasstildeling.publiseres` (boolean) | M |
| Kjøre om / avbryte en feilet tildeling | Aktivt avvist som beslutning | S |
| Se at en tildeling feilet | Ikke eksponert i GraphQL | S |

### Oppgave 5 — Gjennomføre plasstildeling

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Poenggrense per utdanningskvote lagres | `plasstildeling.poenggrense` tabell finnes | **Tabellen populeres ikke av koden.** Tre skriveoperasjoner (studiekvoter, kvotesøknader, resultater) — ingen for poenggrense | M+V |
| Poenggrense vist til søker er riktig | Kjent feil, men tabellen er tom uansett | S+V |
| Rangering hentes fra søknadsbehandlingen | `kvotesoknad` med `rangering`, `poengsum`, `prioritet`, `har_tilbudsgaranti`, `svartype_kode` | Ingen | M |
| Endret søknad fanges opp mellom runder | Åpen avklaring | S |
| Søker som mister kvalifisering får avslag | Les/skriv-asymmetri i resultattype | S |
| Tilbudsgaranti fra markert utdanningskvote | `opptak.tilbudsgaranti_kvote` | Ingen | M |
| Kvoteprioritet | Tre nivåer: `kvotetype` → `kvote` → `studiekvote` | Ingen | M |
| Poenglikhetsregel koblet til opptaket | Regelen henger på **kvotetype**, ikke opptak | M |
| Fire poenglikhetsregler | To av fire ser ut til å være dekket | S |

Poenggrense-beregning er designet i skjemaet men **ikke implementert**. Hele tabellen er tom. Dette er en ny feature, ikke en feilretting.

### Oppgave 6 — Vise resultatet til saksbehandler

| Krav | Funn | Ev. |
|------|------|-----|
| Tilbud / venteliste med nummer / avslag | `plasstildelingsresultat` med `svartype_kode`, `ventelistenummer`, `plasstildelingsresultat_type_kode` | M |
| Spore plass via plassflyt | `plasstildelingsresultat.plass_fra_kvotetype_kode` med FK | M |
| Ventelistenummer er entydig | **Ingen unikhetsskranke** | M |
| Vis ventelistenummer til søker | `utdanningstilbud.vis_ventelistenummer_for_soker` (default false) | M |
| Vis poenggrense til søker | `utdanningstilbud.vis_poenggrense_for_soker` (default false) | M |

Resultatet finnes **to steder**: per tildeling i `plasstildeling.plasstildelingsresultat` og denormalisert på `soknad.soknadsalternativ`. Mulig kilde til inkonsistens.

### Oppgave 7 — Publisere resultatet

| Krav | Funn | Ev. |
|------|------|-----|
| Kontroll over publiseringstidspunkt | `plasstildeling.publiseres` + `opptaksrunde.publiseringstidspunkt` | M |
| Vedtak med begrunnelse | Henger på poenggrense-gapet — tabellen er tom | M+V |
| Melding om vedtak til søker | `soknad.sokermelding` med FK til `kommunikasjon.melding` og `opptaksrunde` — røret finnes | M |
| Arv av svartype ved publisering | Åpen avklaring | S |

### Oppgave 8 — Håndtere svar fra søker

| Krav | Funn | Ev. |
|------|------|-----|
| Søker svarer ja/nei innen frist | `soknad.opptakssvar` per søker, alternativ og runde | M |
| Svar knyttes til riktig runde | PK uten `opptaksrundetype_kode` — rettet i skjema, ikke i kode | M+S |
| Fristsjekk | Bruker applikasjonsklokke i stedet for databaseklokke | S |
| Trukket ja frigjør plassen | **Ingen kolonne** for trekk/frigjøring i `opptakssvar` | M |
| Manuell overstyring | `soknadsalternativ` har skrivbare resultattype-kolonner + `skal_spesialbehandles` | M |

---

## Kjernetjenester i koden

Verifisert i `fs-plattform/opptak`:

| Tjeneste | Ansvar |
|----------|--------|
| `KvoterService` | Leser utdanningskvotekonfigurasjon (kapasitet, prioritet, plassflytmål). Antall tilbud som skal gis: `overbook_antall_plasser` med fallback til `onsket_antall_deltakere` |
| `KvotesumService` | Beregner beste poengscore per søker per kvotetype — input-forberedelse |
| `OpprettPlasstildelingService` | Oppretter ny plasstildeling-rad med status KLAR, finner `basert_pa`-grunnlaget automatisk |
| `Opptakskjoringsalgoritme` | Selve tildelingsalgoritmen. Bygger flytkart, omfordeler plasser innenfor én kjøring |
| `PlasstildelingSkriveService` | Tre skriveoperasjoner: studiekvoter, kvotesøknader, resultater. **Ikke** poenggrense |

---

## Arbeid som må gjøres

1. Prosessbeskrivelse for plasstildeling på fs.sikt.no. Plasstildeling har ingen egen side i dag; den vises kun som enkeltoppgaven «tildel plass» i opptaksprosessen.
2. Eksempler per oppgave. Én Gherkin-feature per oppgave, slik at hver oppgave har konkrete eksempler på hva som skal kunne utføres. `krav/02 Opptak/14 Plasstildeling/` er ledig.
3. Oppdatere begrepene på fs.sikt.no etter begrepsendringene i [design.md](design.md).
4. Registrere de seks mistenkte feilene som issues.
5. Verifisere negative opptaksparametere mot dagens løsning.
