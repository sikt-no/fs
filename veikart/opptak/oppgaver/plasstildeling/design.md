# Plasstildeling

Vi skal kunne fordele studieplasser i flere runder, med kontroll over når søkeren ser resultatet, og med et resultat som kan forklares i etterkant. Det meste av dette virker i dag. Dette dokumentet beskriver hva løsningen gjør, hva den ikke gjør, og hvilke valg som gjenstår.

Dokumentet er skrevet for alle som trenger å forstå hva plasstildeling er, hvilke prinsipper den hviler på, og hvilke spørsmål som gjenstår. Funksjonell løsning per oppgave, gap-analyse og tekniske detaljer ligger i [oppgave.md](oppgave.md).

**Status:** renskrevet raffinering, 2026-09-09. Bygger på tidligere raffineringer og gjennomgang av koden. 

---

**Tre beslutninger bør leses før resten, fordi alt annet følger av dem. To er tatt. Nummer 1 skal gjenvisiteres nå.**

1. **Rundetypen styrer ikke lenger hvordan en runde oppfører seg.** Det gjør arven: om runden bygger videre på en tidligere publisert runde. Historisk var det rundetypen som avgjorde om et nei-svar frigjorde plassen, om tidligere tilbud sto ved lag, og om det ble satt nye bortfall. I dagens løsning er dette flyttet — se *Hva en runde arver*.

2. **Beregning og publisering er to separate steg.** En plasstildeling kan kjøres og bevisst ikke publiseres. Det er dette som gjør ubegrensede prøvetildelinger mulig, og det er nettopp det lærestedene har bedt om.

3. **Plasstildelingen hviler på korrekt saksbehandling. Plasstildeling utføres som bestilling, og gir ikke et resultat man kan rette.** Hvis plasstildelingen feiler, er eneste utvei å rette saksbehandlingsfeil og bestille en ny. For å endre fra ikke-tilbud til tilbud, kan man bruke tilbudsgaranti.

---

## Del 1: mål og retning

### Hva dette er, og hva det ikke er

Med plasstildeling mener vi beregningen som avgjør hvem som får plass, hvem som står på venteliste, og hvem som får avslag — gjennomført for én runde i et opptak. Det er noe annet enn søknadsbehandlingen, som avgjør om en søker er kvalifisert og hvor sterkt hun konkurrerer.

Skillet er ikke en formalitet. De to har ulikt fangstpunkt, ulik eier og ulik livssyklus:

|                  | Søknadsbehandling | Plasstildeling |
|------------------|-------------------|----------------|
| **Spørsmålet**   | er søkeren kvalifisert, og hvor står hun i køen? | hvem får plassene som finnes? |
| **Skjer**        | løpende, per søknad | som en kjøring, per runde |
| **Eier**         | saksbehandler | opptaksleder |
| **Dekkes her**   | nei — vi abonnerer på resultatet | ja |

Rangeringen kommer altså fra søknadsbehandlingen. Plasstildelingen eier ikke poengberegningen; den eier fordelingen. Det er derfor oppgave 3 nedenfor handler om å hente og holde seg oppdatert på rangeringen, ikke om å beregne den. 

**En runde er ikke det samme som en plasstildeling.** Runden er vinduet i opptaket der plasser fordeles og søkere får svar. Plasstildelingen er beregningen som gjennomføres i runden. Én runde kan ha mange plasstildelinger — prøvetildelinger som ikke publiseres, og til slutt én som publiseres.

### Mål

- Hver søker får ett tydelig svar per søknad: tilbud, venteliste med nummer, eller avslag.
- Lærestedet bestemmer hvor mange tilbud som skal gis per utdanningskvote per utdanningstilbud, og kan la ledige plasser flyte til en annen utdanningskvote framfor at plassene blir stående ubrukt.
- En plasstildeling kan kjøres, kvalitetssikres og forkastes uten at søkeren merker noe.
- Resultatet skal kunne forklares i etterkant — hvorfor fikk denne søkeren tilbud, hvorfor fikk ikke den neste? Særlig nødvendig ved klager på vedtak.
- En ny runde skal kunne bygge videre på en tidligere uten å miste resultatene fra den.

### Ikke-mål

- **Ikke kvalifiseringsvurdering.** Den hører i søknadsbehandlingen.
- **Ikke poengberegning.** Samme sted. Plasstildelingen leser rangeringen.
- **Ikke opptaksadministrasjon.** Oppretting av opptak og tilknytning av utdanningstilbud er dekket andre steder.
- **Ikke automatisk nye tilbud ved nei-svar på tilbud i 2027-opptaket.** Se avklaringspunkt 3

### Fire prinsipper løsningen hviler på

#### 1. Ingen søker skal forsvinne stille

Hver søknad som er med i en plasstildeling skal komme ut med et svar. En søker som mister kvalifiseringen sin mellom to runder skal få et tydelig avslag, ikke bare falle ut av resultatlisten.

Dette er prinsippet dagens løsning bryter mest merkbart, og det er verdt å si hvorfor det er alvorlig: et stille bortfall gjør at fraværet av et resultat kan bety to helt ulike ting — at søkeren aldri var med, eller at hun ble tatt ut underveis — og da kan vi ikke svare søkeren på hva som skjedde med søknaden hennes.

#### 2. Søkeren skal kunne stole på tilbudet sitt

Fra det øyeblikket en søker har fått et tilbud, skal ikke en senere runde kunne ta det fra henne. Det er dette som skiller etterfylling fra et nytt opptak, og det er grunnen til at forrige rundes tilbud fryses og garanteres når en runde bygger på en tidligere publisert runde.

#### 3. Ledige plasser skal ikke gå tapt, men de flyter bare der noen har bestemt at de skal flyte

Er det ønsket flere tilbud i en utdanningskvote enn det finnes kvalifiserte søkere i den, overføres de overskytende plassene til en annen utdanningskvote — men bare til den ene utdanningskvoten lærestedet har pekt på, og bare innenfor samme utdanningstilbud. Minst én utdanningskvote er siste utdanningskvote og sender ikke plasser videre, typisk ordinær kvote.

At flyten er eksplisitt og retningsbestemt er et bevisst valg, ikke en begrensning: en plass som flyter dit ingen har bestemt, gir et resultat ingen kan forklare søkeren.

#### 4. Beregning og publisering er skilt

En plasstildeling er beregnet når den er beregnet. Den er synlig for søkeren først når noen har publisert den. Kvalitetssikring skjer i mellomrommet.

Dette prinsippet er billig å ha og dyrt å miste: uten det må hver kvalitetssikring skje i produksjon, med søkeren som testpublikum.

### Slik henger det sammen

```
                      ┌──────────────────────────────────────────────┐
   OPPTAK ───────────►│   RUNDER I OPPTAKET        (oppgave 1)       │
   navn, rundetype,   │   én eller flere per opptak                  │
   datoer             └───────────────────┬──────────────────────────┘
                                          │
   SØKNADSBEHANDLING                      │     INNSTILLINGER PER UTDANNINGSKVOTE
   kvalifisering                          │     antall tilbud som skal gis,
        │                                 │     plassflyt,
        ▼                                 │     utdanningskvote for tilbudsgaranti,
   kvotetilhørighet, poeng, rangering     │     (oppgave 2 og 3)
                                          │              |
                                          │              │
        └───────────────┐                 │              │
                        ▼                 ▼              ▼
                     ╔═════════════════════════════════════════════╗
   forrige           ║   PLASSTILDELING     (oppgave 4 og 5)       ║
   publiserte  ─────►║  hvem får plass — og hva ble poenggrensen?  ║
   runde (arv)       ╚══════════════════════┬══════════════════════╝
                                            │
                                            ▼
              resultat per søknad: tilbud / venteliste (nr) / avslag
              poenggrense per utdanningskvote  ·  spor av plassflyt
                                            │
                     ┌──────────────────────┴──────────────────────┐
                     ▼                                             ▼
           SAKSBEHANDLER (oppgave 6)                  PUBLISERING (oppgave 7)
           kvalitetssikring før publisering            valgfri — en prøve-
                                                      tildeling publiseres ikke
                                                                   │
                                                                   ▼
                                                     SVAR FRA SØKER (oppgave 8)
                                                     ja / nei / står på venteliste
                                                                   │
                                             utløser ny runde ─────┘
```

Legg merke til pilen nederst til venstre: arven fra forrige publiserte runde er en inngang til beregningen på linje med innstillingene og rangeringen. Det er den som gjør etterfylling mulig, og det er den som avgjør hvordan runden oppfører seg.

### Hva en runde arver fra forrige

Dette er den viktigste tabellen i dokumentet, fordi den erstatter det rundetypen gjorde før:

| Egenskap | Runde uten arv (første runde) | Runde med arv (etterfylling) |
|----------|-------------------------------|------------------------------| 
| Tidligere tilbud | finnes ikke | fryses og garanteres |
| Nytt tilbud fra venteliste | – | søkeren mister ikke det gamle automatisk |
| Bortfall på lavere prioriteter | settes | settes ikke |
| Nei-svar | – | frigjør plassen først når svarfristen er ute |

Begrunnelsen for høyre kolonne er prinsipp 2: på dette stadiet skal søkeren kunne stole på tilbudet sitt. Men det gir også oppførselen én modus, og det er kilden til flere av de åpne spørsmålene i del 2 — se avklaringspunkt 2.

### Status per oppgave

| # | Oppgave | Status | Det som mangler |
|---|---------|--------|-----------------|
| 1 | Legge til runder for plasstildeling i ett opptak | Støttet | Dato for når plasstildelingen skal skje finnes ikke i modellen |
| 2 | Sette antall tilbud som skal gis per utdanningskvote | Delvis | Fire tall i fire tabeller er uavklart; begrepsrengjøring ugjort |
| 3 | Sette plassflyt mellom utdanningskvoter | Delvis | Én mottakende utdanningskvote; ingen flyt mellom utdanningstilbud; ingen flyt mellom tildelinger |
| 4 | Starte en ny plasstildeling | Støttet | Feiler en tildeling, kan den ikke kjøres om — bare erstattes av en ny |
| 5 | Gjennomføre plasstildeling | Delvis | Poenggrensen beregnes og lagres aldri; endret søknad mellom runder fanges ikke opp; tapt kvalifisering gir stille bortfall |
| 6 | Vise resultatet til saksbehandler | Delvis | Ventelistenummeret når ikke fram til søkeren, selv om innstillingen finnes |
| 7 | Publisere resultatet til søkerne | Støttet | Ett hull, se oppgave 6 — det som publiseres mangler ventelistenummer |
| 8 | Håndtere svar fra søker | Delvis | Trukket ja-svar frigjør aldri plassen; ingen manuell overstyring av enkeltresultat |
| 9 | Systemet gir automatisk nye tilbud ved nei-svar på tilbud | Utenfor scope | Se avklaringspunkt 3 |

«Delvis» betyr her at kjernefunksjonen virker og at det som mangler er navngitt. Ingen av oppgavene er usikre på om de virker.

### Funn å undersøke på tvers av oppgavene

To funn tilhører ingen enkeltoppgave, og de er de tyngste i dokumentet:

2. **Tilgangsstyringen er alt-eller-ingenting.** Én rolle ser alle søkernavn og alle resultater i hele opptaket, uten finere inndeling. Behovet er opptaksleder- og saksbehandlertilganger avgrenset til de organisasjonene brukeren har tilgang fra. Dette er ikke bare en manglende feature — det er et personvernfunn, og det hører derfor også i del 2.

3. **Seks mistenkte feil i koden er identifisert.** De er ikke bevisste valg. To er beskrevet: bortfall kan beregnes mot feil tilbud når en søker har flere tilbud samtidig, og ventelistenumre kan kollidere mellom runder. De fire øvrige er listet i del 4.

### Blindsoner

Dette er hva løsningen ikke svarer på, og som ikke lukkes med mer arbeid på samme sted:

| Blindsoner | Hva det betyr |
|-----------|---------------|
| Plassflyt mellom utdanningstilbud | Plasser flyter mellom utdanningskvoter innenfor ett utdanningstilbud. Ledig kapasitet på ett tilbud kan ikke brukes på et annet |
| Flere mottakende utdanningskvoter | En utdanningskvote kan sende overskytende plasser til én utdanningskvote, ikke fordele dem på flere. Flerledds-kjeder virker, forgrening gjør ikke |
| Poenggrense som historikk | Poenggrensen søkeren eventuelt ser i dag kommer fra en annen kilde enn tildelingen. Fjorårets median, som er viktig for tidlig tilbud, settes i søknadsbehandlingen 
| Negative opptaksparametere | Den historiske muligheten for å redusere antall aktive tilbud i et suppleringsopptak er ikke verifisert mot dagens løsning |

---

## Del 2: regelverk, roller og personvern

Denne delen setter løsningen opp mot regelverket og mot HK-dirs meldte behov. Den er skrevet for å bli motsagt: der vi har tatt et standpunkt står det som vår påstand, og der vi ikke har konkludert står det i *Hva vi trenger avklart*. Dette er funksjonelle beskrivelser med et forslag til innramming.

### Poenglikhetsregler er forskriftsfestet nasjonalt eller lokalt

At eldste søker går foran yngre ved poenglikhet følger av opptaksforskriften § 7-1 fjerde ledd. Forskriften vil endres til neste år, og yngre søkere skal gå foran eldre i UHG. Dagens løser ikke det.

Vår påstand: dette må dokumenteres slik at regelen er synlig som forskriftsfestet. Ellers vil vi får spørsmål om det.

Løsningen skal kunne håndtere flere regler, koblet til opptaket:

| Regel | Merknad                                                        |
|-------|----------------------------------------------------------------|
| Alder — eldste eller yngste først | Eldste først er forskriftsfestet for 2026, blir omvendt i 2027 |
| Loddtrekning |                                                                |
| Alle med samme sum får tilbud | Kan settes som unntak per utdanningstilbud                     |
| Tidspunkt for levert søknad — tidligste vinner | Egen regel for runden «ledige studieplasser»                   |

### Valgfriheten ved poenglikhet er redusert

Lærestedene kunne i 2020 velge mellom en strengere avgrensning og «alle med samme poengsum får tilbud», per utdanningstilbud. Enkelte har ønsket tilbake dette.

Vår påstand: lærestedet skal kunne legge unntakskrav på et utdanningstilbud, men bare i én retning — «alle med samme sum får tilbud». En strengere avgrensning enn forskriftens er ikke lov. Om dagens oppførsel dermed er riktig eller for grov, avhenger av om valgfriheten var mellom to lovlige alternativer eller mellom et lovlig og et ulovlig.

### Tilbudsgaranti tas fra en bestemt utdanningskvote

En tilbudsgaranti er en kode på en søknad som gir tilbud uavhengig av poengsum og kvalifiseringsstatus. Den brukes til å rette opp feil, men også til å gi tilbud til spesielle søkergrupper, til tilsagn i et tidligopptak, og til søkere med reservert plass.

For hvert utdanningstilbud kan opptaksforvalter ved lærestedet eller HK-dir sette om tilbudsgarantier skal tas fra en bestemt utdanningskvote, og i så fall hvilken. Plasstildelingen skal ta garantiplassene fra den utdanningskvoten som er markert for det.

Dette er verdt å merke seg fordi en tilbudsgaranti forbruker en plass: den er ikke gratis, den flytter belastningen til en utdanningskvote noen har pekt på.

### Tilgangsstyring er et personvernspørsmål, ikke bare en feature

At én rolle ser alle søkernavn og alle resultater i hele opptaket, uten inndeling per organisasjon, betyr at en saksbehandler ved ett lærested i praksis har innsyn i søkere som ikke angår hennes institusjon.

Vår påstand: dette er en for bred tilgang til personopplysninger, og inndeling per organisasjon er et krav og ikke en forbedring. Vi bringer det inn her framfor bare i funn-listen, fordi konsekvensen av å ikke rette dette kan ha personvernkonsekvenser.

### Søkeren skal kunne forstå svaret sitt

Søkeren skal se tilbud, avslag eller venteliste, og et vedtak med begrunnelse: kvalifisering, rangering, poenggrense, samt hvilken organisasjon som har behandlet søknaden. Slik ivaretar vi søkers innsynsrett og klagerett. 

To hull er verdt å nevne her og ikke bare i statustabellen, fordi de rammer nettopp forklarbarheten:

- **Ventelistenummeret når ikke fram til søkeren i dag**, selv om innstillingen for å vise det finnes. En venteliste uten nummer er ikke en venteliste for søkeren; det er en beskjed om at hun ikke fikk plass.
- **Poenggrensen lagres ikke av tildelingen.** Den poenggrensen søkeren eventuelt ser, kommer fra en annen kilde. Vedtaket begrunnes altså med et tall plasstildelingen selv ikke har.

Ved klage må det i tillegg kunne spores at en plass kom via plassflyt fra en annen utdanningskvote. Det virker i dag.

### Hva vi trenger avklart

Ordnet etter hvor mye svaret endrer løsningen.

1. **Skal en plasstildeling kunne kjøres om, avbrytes, eller korrigeres i enkeltresultater?** Dette er hovedspørsmålet. Et ja betyr at plasstildelingen ikke bare er en kjøring, men et resultat med livssyklus — det er en annen løsning, ikke en justering av denne.
2. **Er en runde alltid etterfylling, eller skal den kunne være supplering?** Svaret avgjør fire andre spørsmål samtidig.
3. **Skal det gis automatisk nye tilbud ved nei-svar på tilbud i 2027-opptaket?** Notatene stryker dette fra scope, men det står samtidig igjen som sannsynlig mangel mot meldt behov. Begge kan ikke stå.
4. **Skal et nei-svar frigjøre plassen før svarfristen er ute?** I dag står plassen «reservert» til fristen. Er det for lenge?
5. **Skal en søker som godtar og senere trekker seg, frigjøre plassen til ventelisten?** I dag frigjøres den aldri.
6. **Skal ventelistenumre stå urørt etter opprykk, eller nummereres på nytt?** Gjenkjennbarhet mot korrekthet.
7. **Skal søkere med lik rangering på venteliste dele nummer, eller få vilkårlige unike numre?** I dag: vilkårlige unike.
8. **Bør antall tilbud som skal gis kunne økes automatisk ved opprykk**, slik at en frigjort plass ikke går tapt?
9. **Skal det finnes en «topp opp til ønsket nivå»-funksjon de første ukene**, framfor manuell overvåking og etterfylling? Lærestedene har bedt om det.
10. **Når en søker har flere poengsummer i samme kvotetype:** er det riktig at høyeste poengsum vinner, og at laveste grunnlagskode avgjør ved likhet?
11. **Når en søker har både et tilbud og et kansellert resultat på samme utdanningstilbud** — skal det kansellerte vises til søkeren i stedet for tilbudet?
12. **Er det funksjonelle forskjeller mellom rundetypene, utover arven?** Dette må gås opp med domeneeksperter og avklares med prosjektleder. Hvis svaret er «ingen», er rundetypen et navn og ikke en regel, og det bør stå.
13. **Opptaksforvalter skal utføre alle oppgaver knyttet til plasstildeling.** Dette er avklart: opptaksforvalter er rollen som har tilgang til å legge til runder, sette innstillinger, starte tildelinger, publisere og håndtere resultater.

Spørsmål 4–11 er prosjektleder- og HK-dir-spørsmål. Spørsmål 1–3 endrer omfanget. Spørsmål 12–13 er hull i notatene, ikke i løsningen.

---

## Begrepsendringer

| Gammelt begrep | Nytt begrep | Begrunnelse |
|----------------|-------------|-------------|
| Opptakskjøring | Plasstildeling | Ikke lenger offisielt begrep |
| Kvoteflyt | Plassflyt | Det er plassene som flyter, ikke kvoten |
| Overbooking | Antall tilbud som skal gis | Verdien er rundens absolutte antall tilbud, ikke en buffer på toppen — se oppgave 2 |

---

## Begrepsforklaringer

**Plasstildeling** — beregningen som avgjør hvem som får plass, står på venteliste, eller får avslag, gjennomført for én runde i et opptak. Tidligere term: opptakskjøring, ikke lenger offisielt begrep.

**Runde i plasstildelingen** — et definert vindu i et opptak der plasser fordeles og søkere får svar. Ett opptak kan ha flere runder, f.eks. hovedrunde og etterfyllingsrunde. Historisk styrte rundetypen hvilke regler som gjaldt. I dagens løsning er det ikke rundetypen, men om runden bygger videre på en tidligere publisert runde, som avgjør oppførselen.

**Utdanningskvote** — en køordning. Kvalifiserte søkere plasseres i minst én utdanningskvote ut fra et regelverk (lov, forskrift eller studieplan), og får plass i køen etter poengsum i den aktuelle utdanningskvoten. Eksempler: førstegangsvitnemål, nordnorsk. På utdanningskvoten angis hvor mange tilbud som skal gis i denne konkrete plasstildelingen på konkrete utdanningstilbud, og hvilken metode som brukes for å fylle dem. Kvotetyper settes i opptaket; utdanningskvote er kvotetypen anvendt på et utdanningstilbud.

**Kvoteprioritet** — rekkefølgen en søker prøves i de ulike utdanningskvotene et utdanningstilbud har. Normalt prøves den mest spesielle utdanningskvoten først og den minst spesielle sist.

**Plassflyt** — innstilling som utløses når det er ønsket flere tilbud i en utdanningskvote enn det er kvalifiserte søkere i utdanningskvoten. Plassflyt angir hvilken én annen utdanningskvote de overskytende plassene overføres til, innenfor samme utdanningstilbud. Flyten kan gå i flere ledd etter hverandre, og kan endres ved behov. Minst én utdanningskvote er siste utdanningskvote og kan ikke sende plasser videre, typisk ordinær kvote. Tidligere term: kvoteflyt.

**Arv fra forrige runde** — at en plasstildeling bygger videre på forrige publiserte runde: tidligere tilbud fryses og garanteres, og det settes ikke nye bortfall. Dette er noe annet enn plassflyt, som gjelder mellom utdanningskvoter i samme tildeling.

**Antall tilbud som skal gis** — hvor mange tilbud som skal gis i en utdanningskvote i denne plasstildelingen. Settes per utdanningskvote; totaltall vises. Tidligere feltnavn: overbooking.

**Poenggrense** — den laveste poengsummen som gav plass i en gitt utdanningskvote. Brukes til å informere søkere om hvor «høyt» det var å komme inn.

**Poenglikhetsregel** — hvordan søkere med lik poengsum behandles. Eldste søker først er forskriftsfestet i det ordinære tilfellet; «alle med samme poengsum får tilbud» kan settes som unntak per utdanningstilbud; loddtrekning og tidligste søknadstidspunkt finnes som regler.

**Tilbud til alle kvalifiserte** — en utdanningskvote kan settes opp uten poenggrense, slik at alle kvalifiserte får plass uansett poengsum. Typisk ved lav søkning.

**Tilbudsgaranti** — en kode på en søknad som gir tilbud om studieplass uavhengig av poengsum og kvalifiseringsstatus. Brukes til å rette opp feil, gi tilbud til spesielle søkergrupper, gi tilsagn i et tidligopptak, eller til søkere med reservert plass. Per studium settes om garantier skal tas fra en bestemt utdanningskvote, og hvilken.

**Svar** — resultatet søkeren får per søknad: tilbud om plass, plass på venteliste med ventelistenummer, eller avslag.

**Etterfylling** — en ny runde som fyller opp plasser som ble ledige etter at søkere svarte nei eller ikke svarte i tide. Kjennetegnet ved at søkeren ikke mister et tilbud automatisk ved nytt tilbud fra venteliste, og at det ikke settes nye bortfall på lavere prioriterte studieønsker — fordi søkeren på dette stadiet skal kunne stole på tilbudet sitt.

**Supplering** — å gi nye tilbud raskt for å kompensere for frafall, uten å vente på neste runde. Ikke det samme som etterfylling. Se avklaringspunkt 2.

**Roller** — opptaksforvalter utfører alle oppgaver knyttet til plasstildeling: legger til runder, setter innstillinger, starter tildelinger, publiserer og håndterer resultater. Saksbehandler kvalitetssikrer resultatet.

---

## Oppgavenummerering


| Ny | Oppgave | Github-issue|
|----|---------|---------|
| 1 | Legge til runder for plasstildeling i ett opptak | 
| 2 | Sette antall tilbud som skal gis per utdanningskvote | 
| 3 | Sette plassflyt mellom utdanningskvoter | 
| 4 | Starte en ny plasstildeling | 
| 5 | Gjennomføre plasstildeling |
| 6 | Vise resultatet til saksbehandler | 
| 7 | Publisere resultatet til søkerne |
| 8 | Håndtere svar fra søker | 

---

## Neste steg

Funksjonell løsning per oppgave, gap-analyse mot datamodell og kode, mistenkte feil og gjenstående arbeid er dokumentert i [oppgave.md](oppgave.md). Sammen danner design.md og oppgave.md grunnlaget for å skrive krav med eksempler (Gherkin) per oppgave.

---

## Referanser

- 2025-05-15 Raffinering med HK-dir. Plasstildeling
- Plasstildelingsløpet i Opptak
- 2026-09-08 Raffinering plasstildeling
- HK-dirs behovsnotat 2024
- Opptaksforskriften § 7-1 fjerde ledd
- Opptaksprosessen på fs.sikt.no — mangler egen side for plasstildeling
