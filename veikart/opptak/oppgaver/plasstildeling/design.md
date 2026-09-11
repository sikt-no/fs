# Plasstildeling

Vi skal kunne fordele studieplasser i flere runder, med kontroll over når søkeren ser resultatet, og med et resultat som kan forklares i etterkant. Det meste av dette virker i dag. Dette dokumentet beskriver hva løsningen gjør, hva den ikke gjør, og hvilke valg som gjenstår.

Dokumentet er skrevet for alle som trenger å forstå hva plasstildeling er, hvilke prinsipper den hviler på, og hvilke spørsmål som gjenstår. Funksjonell løsning per oppgave, gap-analyse og tekniske detaljer ligger i [oppgave.md](oppgave.md).

**Status:** oppdatert etter raffinering av rundetyper, 2026-09-10. Bygger på tidligere raffineringer og gjennomgang av koden.

---

**Tre beslutninger bør leses før resten, fordi alt annet følger av dem. Alle tre er tatt.**

1. **Rundetypen styrer hvordan en runde oppfører seg.** Fire rundetyper — hovedtildeling, supplering, etterfylling og ledige studieplasser — definerer hver sin oppførsel for bortfall, automatisk nye tilbud ved opprykk ("kompensasjonstilbud"), og om søkeren kan ha flere tilbud. Arven fra forrige publiserte runde (informasjonsarv) er nødvendig i alle rundetyper etter hovedtildelingen, men det er rundetypen som bestemmer reglene. Se *Rundetyper og oppførsel*.

2. **Beregning og publisering er to separate steg.** En plasstildeling kan kjøres og bevisst ikke publiseres. Det er dette som gjør ubegrensede prøvetildelinger mulig, og det er nettopp det lærestedene har bedt om.

3. **Plasstildelingen hviler på korrekt saksbehandling. Plasstildeling utføres som bestilling, og gir ikke et resultat man kan rette.** Hvis plasstildelingen feiler, er eneste utvei å rette saksbehandlingsfeil og bestille en ny. For å endre fra ikke-tilbud til tilbud, kan man bruke tilbudsgaranti.

---

## Del 1: mål og retning

### Hva plasstildeling er, og hva det ikke er

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
- **Ikke to ulike suppleringslogikker.** Supplering har kompensasjonstilbud — det finnes bare én logikk. Den historiske forskjellen mellom UHG og HYU videreføres ikke.

### Fire prinsipper løsningen hviler på

#### 1. Ingen søker skal forsvinne stille

Hver søknad som er med i en plasstildeling skal komme ut med et svar. En søker som mister kvalifiseringen sin mellom to runder skal få et tydelig avslag, ikke bare falle ut av resultatlisten.

Dette prinsippet byter dagens løsning med, og det er verdt å si hvorfor det er alvorlig: et stille bortfall av tilbud gjør at fraværet av et resultat kan bety to helt ulike ting — at søkeren aldri var med, eller at hun ble tatt ut underveis — og da kan vi ikke svare søkeren på hva som skjedde med søknaden hennes.

#### 2. Søkeren skal kunne stole på tilbudet sitt

Fra det øyeblikket en søker har fått et tilbud, skal ikke en senere runde kunne ta det fra henne. Det er dette som skiller etterfylling fra hovedtildelingen, og det er grunnen til at forrige rundes tilbud fryses og garanteres i etterfyllingsrunder. I suppleringsrunder gjelder prinsippet indirekte: søkeren beholder tilbudet sitt med mindre hun rykker opp til en høyere prioritet.

#### 3. Ledige plasser skal ikke gå tapt, men de flyter bare der noen har bestemt at de skal flyte

Er det ønsket flere tilbud i en utdanningskvote enn det finnes kvalifiserte søkere i den, overføres de overskytende plassene til en annen utdanningskvote — men bare til den ene utdanningskvoten lærestedet har pekt på, og bare innenfor samme utdanningstilbud. Én utdanningskvote er siste utdanningskvote og sender ikke plasser videre, typisk ordinær kvote.

At flyten er eksplisitt og retningsbestemt er et bevisst valg, ikke en begrensning: en plass som flyter dit ingen har bestemt, gir et resultat ingen kan forklare søkeren.

#### 4. Beregning og publisering er skilt

En plasstildeling er beregnet når den er beregnet. Den er synlig for søkeren først når noen har publisert den. Kvalitetssikring skjer i mellomrommet.

Dette prinsippet er billig å ha og dyrt å miste: uten det må hver kvalitetssikring skje i produksjon, med søkeren som testpublikum.

### Slik henger det sammen

```
                      ┌──────────────────────────────────────────────┐
   OPPTAK ───────────►│   RUNDER I OPPTAKET        (oppgave 1)       │
   navn, datoer       │   én eller flere per opptak                  │
                      └───────────────────┬──────────────────────────┘
                                          │
                                          │ rundetype (hovedtildeling /
                                          │  supplering / etterfylling /
                                          │  ledige studieplasser)
                                          │
   SØKNADSBEHANDLING                      │     INNSTILLINGER PER UTDANNINGSKVOTE
   kvalifisering                          │     antall tilbud som skal gis,
        │                                 │     plassflyt, deltar i runden,
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

Legg merke til tre ting: (1) rundetypen er en eksplisitt inngang som styrer beregningens oppførsel, (2) arven fra forrige publiserte runde er nødvendig for alle runder etter hovedtildelingen, og (3) utdanningstilbud kan markeres for at de ikke deltar i en gitt rundetype.

### Rundetyper og oppførsel

Dette er den viktigste tabellen i dokumentet. Rundetypen styrer hva plasstildelingen gjør.

| Egenskap | Hovedtildeling | Supplering | Etterfylling | Ledige studieplasser |
|----------|----------------|------------|--------------|----------------------|
| Bortfall på lavere prioriteter | ja | ja | nei | nei |
| Kompensasjonstilbud ved opprykk | nei | ja | nei | nei |
| Søker kan ha flere tilbud samtidig | nei | nei | ja, må velge ett | ja, må velge ett |
| Informasjonsarv fra forrige runde | nei (første runde) | ja | ja | ja |
| Utdanningstilbud kan ekskluderes | nei | ja | ja | ja |
| Rangeringsmetode | poeng og rangering | poeng og rangering | poeng og rangering | søknadstidspunkt |

Rekkefølgen på rundetyper etter hovedtildelingen er valgfri — det er ikke noe krav om at supplering må komme før etterfylling. Normalt i samordna opptak vil man ha hovedrunde, én eller flere suppleringsrunder, og deretter eventuelt etterfylling og ledige studieplasser for de utdanningstilbudene som skal være med på det.

#### Hovedtildeling

Søkeren får tilbud på høyest mulige prioritet. Er søkeren kvalifisert, men ikke høyt nok rangert til å få tilbud, får hun ventelisteplass ut fra rangeringen. Lavere prioriteter faller bort. Søkeren må få beskjed om at lavere søknadsalternativer faller bort, for å frigjøre plass til andre søkere.

#### Supplering

Samme logikk som hovedtildeling med automatisk bortfall på lavere prioritet, men har med seg informasjonsarv fra runden før. Plasstildelingsalgoritmen gir automatisk nye tilbud ved opprykk (kompensasjonstilbud) opp til «antall ønsket ja-svar» på utdanningstilbudet. Målet er best mulig utnyttelse av kapasiteten: søker B kan komme inn for søker A som rykket opp til sin høyere prioritet.

Utdanningstilbud skal kunne markeres for at de ikke deltar i suppleringsopptaket. Søkeren skal da få en tydelig beskjed: «Vi tildeler ikke flere studieplasser på dette utdanningstilbudet. Opptaksvedtaket ditt er endelig.»

**Merbehov til senere:** nøkkeltall ut fra opptakstall i fjor, med forslag til «antall ønsket ja-svar».

#### Etterfylling

Det gis *ikke* kompensasjonstilbud ved opprykk. Det settes ikke automatisk bortfall av tilbud på lavere prioritet — søkeren kan ha mer enn ett tilbud og må velge ett.

Utdanningstilbud skal kunne markeres for at de ikke har etterfylling, slik at søkere ikke kan forvente å få nye tilbud.

#### Ledige studieplasser

Ledige studieplasser er en egenskap ved en etterfyllingsrunde og følger etterfyllingens regler. Det som skiller den er rangeringsmetoden: førstemann til mølla. Tidspunktet søkeren søkte på styrer, så fremt hun er kvalifisert. Tilbud gis først til eksisterende venteliste, deretter etter søknadstidspunkt.

Behandling av ledige studieplasser skjer fortløpende fra søknadsfrist. Runden trenger dato man kan starte å søke og søknadsfrist (ledig studieplass-periode).

Utdanningstilbud skal kunne markeres for at de ikke har ledige studieplasser. 

### Informasjonsarv mellom runder

Alle runder etter hovedtildelingen bygger videre på forrige publiserte runde. Informasjonsarven er nødvendig uavhengig av rundetype — den gir tildelingen oversikt over tidligere tilbud, ventelister og svar. Hva rundetypen gjør med den arvede informasjonen er ulikt:

| Egenskap | Hovedtildeling | Supplering | Etterfylling |
|----------|----------------|------------|--------------|
| Tidligere tilbud | finnes ikke | fryses og garanteres | fryses og garanteres |
| Nei-svar frigjør plass | – | ja, kompensasjonstilbud | ja, men ingen kompensasjonstilbud |
| Trukket ja-svar frigjør plass | – | ja | avklares |

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
| 9 | Kompensasjonstilbud ved opprykk (supplering) | Definert | Rundetype supplering er definert med kompensasjonstilbud som fullverdig del av løsningen |

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

At eldste søker går foran yngre ved poenglikhet følger av opptaksforskriften § 7-1 fjerde ledd. Forskriften vil endres til neste år, og aldersregelen forsvinner helt fra UHG, men beholdes i HYU. 

Vår påstand: Endringen og forskjellen mellom UHG og HYU bør dokumenteres slik at den er tydelig. 

Løsningen skal uansett kunne håndtere flere regler, koblet til opptaket:

| Regel | Merknad                                                      |
|-------|--------------------------------------------------------------|
| Alder — eldste eller yngste først | Eldste først er fortsatt aktuell for HYU-opptaket            |
| Loddtrekning |                                                              |
| Alle med samme sum får tilbud | Kan settes som unntak per utdanningstilbud                   |
| Tidspunkt for levert søknad — tidligste vinner | Egen regel som kun gjelder for runden «ledige studieplasser» |

### Valgfriheten ved poenglikhet er redusert

Lærestedene kunne i 2020 velge mellom en strengere avgrensning og «alle med samme poengsum får tilbud», per utdanningstilbud. Enkelte har ønsket tilbake dette.

Vår påstand: lærestedet skal kunne legge unntakskrav på et utdanningstilbud, men bare i én retning — «alle med samme sum får tilbud». En strengere avgrensning enn forskriftens er ikke lov. Om dagens oppførsel dermed er riktig eller for grov, avhenger av om valgfriheten var mellom to lovlige alternativer eller mellom et lovlig og et ulovlig.

### Tilbudsgaranti tas fra en bestemt utdanningskvote

En tilbudsgaranti er en kode på en søknad som gir tilbud uavhengig av poengsum og kvalifiseringsstatus. Den brukes til å rette opp feil, men også til å gi tilbud til spesielle søkergrupper, til tilsagn ved tidlig behandling og tilbud, og til søkere med reservert plass.

For hvert utdanningstilbud kan opptaksforvalter ved lærestedet eller HK-dir sette om tilbudsgarantier skal tas fra en bestemt utdanningskvote, og i så fall hvilken. Plasstildelingen skal ta garantiplassene fra den utdanningskvoten som er markert for det.

Dette er verdt å merke seg fordi en tilbudsgaranti forbruker en plass: den er ikke gratis, den flytter belastningen til en utdanningskvote noen har pekt på.

### Tilgangsstyring er et personvernspørsmål, ikke bare en feature

At én rolle ser alle søkernavn og alle resultater i hele opptaket, uten inndeling per organisasjon, betyr at en saksbehandler ved ett lærested i praksis har innsyn i søkere som ikke angår hennes lærested.

Vår påstand: dette er en for bred tilgang til personopplysninger, og inndeling per organisasjon er et krav og ikke en forbedring. Vi bringer det inn her framfor bare i funn-listen, fordi konsekvensen av å ikke rette dette kan ha personvernkonsekvenser.

### Søkeren skal kunne forstå svaret sitt

Søkeren skal se tilbud, avslag eller venteliste, og et vedtak med begrunnelse: kvalifisering, rangering, poenggrense, samt hvilken organisasjon som har behandlet søknaden. Slik ivaretar vi søkers innsynsrett og klagerett. 
Søker må også få en melding om at svar finnes med informasjon om svarfrist for å kunne ivareta sine rettigheter og plikter i tide. 

To hull er verdt å nevne her og ikke bare i statustabellen, fordi de rammer nettopp forklarbarheten:

- **Ventelistenummeret når ikke fram til søkeren i dag**, selv om innstillingen for å vise det finnes. En venteliste uten nummer er ikke en venteliste for søkeren; det er en beskjed om at hun ikke fikk plass.
- **Poenggrensen lagres ikke av tildelingen.** Den poenggrensen søkeren eventuelt ser, kommer fra en annen kilde. Vedtaket begrunnes altså med et tall plasstildelingen selv ikke har.

Ved klage må det i tillegg kunne spores at en plass kom via plassflyt fra en annen utdanningskvote. Det virker i dag.

### Hva vi trenger avklart

Ordnet etter hvor mye svaret endrer løsningen.

1. **Skal en plasstildeling kunne kjøres om, avbrytes, eller korrigeres i enkeltresultater?** Dette er hovedspørsmålet. Et ja betyr at plasstildelingen ikke bare er en kjøring, men et resultat med livssyklus — det er en annen løsning, ikke en justering av denne.
2. ~~**Er en runde alltid etterfylling, eller skal den kunne være supplering?**~~ **Avklart.** Fire rundetyper er definert: hovedtildeling, supplering, etterfylling og ledige studieplasser. Se *Rundetyper og oppførsel*.
3. ~~**Skal det gis automatisk nye tilbud ved opprykk?**~~ **Avklart.** Ja, dette er suppleringsrundens oppførsel — kompensasjonstilbud. Fullverdig del av løsningen.
4. **Skal et nei-svar frigjøre plassen før svarfristen er ute?** I dag står plassen «reservert» til fristen. Er det for lenge?
5. **Skal en søker som godtar og senere trekker seg, frigjøre plassen til ventelisten?** I dag frigjøres den aldri.
6. **Skal ventelistenumre stå urørt etter opprykk, eller nummereres på nytt?** Gjenkjennbarhet mot korrekthet.
7. **Skal søkere med lik rangering på venteliste dele nummer, eller få vilkårlige unike numre?** I dag: vilkårlige unike.
8. ~~**Bør antall tilbud som skal gis kunne økes automatisk ved opprykk?**~~ **Avklart.** Ja, i supplering. Kompensasjonstilbud gis opp til «antall ønsket ja-svar».
9. **Skal det finnes en «topp opp til ønsket nivå»-funksjon de første ukene**, framfor manuell overvåking og etterfylling? Lærestedene har bedt om det.
10. **Når en søker har flere poengsummer i samme kvotetype:** er det riktig at høyeste poengsum vinner, og at laveste grunnlagskode avgjør ved likhet?
11. **Når en søker har både et tilbud og et kansellert resultat på samme utdanningstilbud** — skal det kansellerte vises til søkeren i stedet for tilbudet?
12. ~~**Er det funksjonelle forskjeller mellom rundetypene, utover arven?**~~ **Avklart.** Ja. Se *Rundetyper og oppførsel*.
13. **Opptaksforvalter skal utføre alle oppgaver knyttet til plasstildeling.** Dette er avklart: opptaksforvalter er rollen som har tilgang til å legge til runder, sette innstillinger, starte tildelinger, publisere og håndtere resultater.

Spørsmål 4–7, 9–11 er prosjektleder- og HK-dir-spørsmål. Spørsmål 1 endrer omfanget. Spørsmål 2, 3, 8 og 12 er avklart.

---

## Begrepsendringer

| Gammelt begrep | Nytt begrep | Begrunnelse |
|----------------|-------------|-------------|
| Opptakskjøring | Plasstildeling | Ikke lenger offisielt begrep |
| Kvoteflyt | Plassflyt | Det er plassene som flyter, ikke kvoten |
| Overbooking | Antall tilbud som skal gis | Verdien er rundens absolutte antall tilbud, ikke en buffer på toppen — se oppgave 2 |
| – | Antall ønsket ja-svar | Nytt begrep for supplering: måltall for kompensasjonstilbud ved opprykk |

---

## Begrepsforklaringer

**Plasstildeling** — beregningen som avgjør hvem som får plass, står på venteliste, eller får avslag, gjennomført for én runde i et opptak. Tidligere term: opptakskjøring, ikke lenger offisielt begrep.

**Runde i plasstildelingen** — et definert vindu i et opptak der plasser fordeles og søkere får svar. Ett opptak kan ha flere runder, f.eks. hovedrunde, suppleringsrunde og etterfyllingsrunde. Rundetypen styrer hvilke regler som gjelder — se *Rundetyper og oppførsel*.

**Utdanningskvote** — en kvotetype anvendt på et utdanningstilbud i et opptak. Kvalifiserte søkere plasseres i minst én utdanningskvote ut fra et regelverk (lov, forskrift eller studieplan), og får plass i køen etter poengsum i den aktuelle utdanningskvoten. Eksempler: førstegangsvitnemål, nordnorsk. På utdanningskvoten angis hvor mange tilbud som skal gis i denne konkrete plasstildelingen, og hvilken metode som brukes for å fylle dem. Kvotetypen er malen og defineres i regelverket — se [regelverk/design.md](../regelverk/design.md).

**Kvoteprioritet** — rekkefølgen en søker prøves i de ulike utdanningskvotene et utdanningstilbud har. Normalt prøves den mest spesielle utdanningskvoten først og den minst spesielle sist.

**Plassflyt** — innstilling som utløses når det er ønsket flere tilbud i en utdanningskvote enn det er kvalifiserte søkere i utdanningskvoten. Plassflyt angir hvilken én annen utdanningskvote de overskytende plassene overføres til, innenfor samme utdanningstilbud. Flyten kan gå i flere ledd etter hverandre, og kan endres ved behov. Minst én utdanningskvote er siste utdanningskvote og kan ikke sende plasser videre, typisk ordinær kvote. Tidligere term: kvoteflyt.

**Informasjonsarv fra forrige runde** — at en plasstildeling bygger videre på forrige publiserte runde: oversikt over tidligere tilbud, ventelister og svar. Nødvendig i alle runder etter hovedtildelingen. Hva rundetypen gjør med den arvede informasjonen varierer — se *Rundetyper og oppførsel*. Dette er noe annet enn plassflyt, som gjelder mellom utdanningskvoter i samme tildeling.

**Antall tilbud som skal gis** — hvor mange tilbud som skal gis i en utdanningskvote i denne plasstildelingen. Settes per utdanningskvote; totaltall vises. Tidligere feltnavn: overbooking. **Merk:** det foreligger et forslag om å gå fra absolutt fordeling per utdanningskvote til relativ fordeling på kvotetypenivå i regelverkssamlingen, der plasstildelingen beregner absolutte tall fra prosentandel, totaltall og eventuelle absolutte unntak — se [regelverk/design.md, «Forslag: relativ fordeling på kvotetypenivå»](../regelverk/design.md#forslag-relativ-fordeling-på-kvotetypenivå).

**Antall ønsket ja-svar** — måltall per utdanningstilbud som styrer kompensasjonstilbud i suppleringsrunder. Når en søker rykker opp og frigjør en plass, gis plassen automatisk til neste på ventelisten — opp til dette tallet er nådd.

**Poenggrense** — den laveste poengsummen som gav plass i en gitt utdanningskvote. Brukes til å informere søkere om hvor «høyt» det var å komme inn.

**Poenglikhetsregel** — hvordan søkere med lik poengsum behandles. Forskriftsfestet per opptakstype: loddtrekning for UHG (fra 2027), alder for fagskole, søknadstidspunkt for ledige studieplasser. Lærestedet kan velge «alle med samme poengsum får tilbud» som unntak per utdanningstilbud.

**Tilbud til alle kvalifiserte** — en utdanningskvote kan settes opp uten poenggrense, slik at alle kvalifiserte får plass uansett poengsum. Typisk ved lav søkning.

**Tilbudsgaranti** — en kode på en søknad som gir tilbud om studieplass uavhengig av poengsum og kvalifiseringsstatus. Brukes til å rette opp feil, gi tilbud til spesielle søkergrupper, gi tilsagn ved tidlig behandling og tilbud, eller til søkere med reservert plass. Per studium settes om garantier skal tas fra en bestemt utdanningskvote, og hvilken.

**Opprykk** — når en søker får tilbud på en høyere prioritet, og den opprinnelige plassen fristilles.

**Kompensasjonstilbud** — automatisk nye tilbud ved opprykk. Når en søker rykker opp til en høyere prioritet og frigjør en plass, gis plassen automatisk til neste på ventelisten. Gjelder kun i suppleringsrunder, opp til «antall ønsket ja-svar».

**Svar** — resultatet søkeren får per søknad: tilbud om plass, plass på venteliste med ventelistenummer, eller avslag.

**Hovedtildeling** — den første runden i et opptak. Søkeren får tilbud på høyest mulige prioritet. Lavere prioriteter faller bort. Ingen informasjonsarv, fordi det ikke finnes en tidligere runde.

**Supplering** — en runde med samme bortfallslogikk som hovedtildelingen, men med informasjonsarv fra forrige runde og med kompensasjonstilbud: når en søker rykker opp til en høyere prioritet, gis den frigjorte plassen automatisk til neste på ventelisten, opp til «antall ønsket ja-svar». Utdanningstilbud kan markeres for at de ikke deltar i suppleringsopptaket.

**Etterfylling** — en runde som fyller opp plasser som ble ledige etter at søkere svarte nei eller ikke svarte i tide. Kjennetegnet ved at det ikke settes automatisk bortfall på lavere prioriteter — søkeren kan ha flere tilbud og må velge ett. Gir ikke kompensasjonstilbud ved opprykk. Utdanningstilbud kan markeres for at de ikke har etterfylling.

**Ledige studieplasser** — en egenskap ved en etterfyllingsrunde der rangeringen styres av søknadstidspunkt i stedet for poeng. Følger ellers etterfyllingens regler. Trenger en ledig studieplass-periode (startdato og søknadsfrist). Tilbud gis først til eksisterende venteliste.

**Roller** — opptaksforvalter ved lærestedet eller Samordna opptak utfører alle oppgaver knyttet til plasstildeling: legger til runder, setter innstillinger, starter tildelinger, publiserer og håndterer resultater. Saksbehandler kvalitetssikrer resultatet.

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
- 2026-09-10 Raffinering rundetyper
