# Plasstildeling

Vi skal kunne fordele studieplasser i flere runder, med kontroll over når søkeren ser resultatet, og med et resultat som kan forklares i etterkant. Det meste av dette virker i dag. Dette dokumentet beskriver hva løsningen gjør, hva den ikke gjør, og hvilke valg som gjenstår.

Dokumentet er skrevet for tre lesergrupper. Del 1 og del 2 forutsetter ingen kjennskap til løsningen. Del 3 er for utviklere og kravarbeid.

**Status:** renskrevet raffinering, 2026-09-09. Bygger på tidligere raffineringer og gjennomgang av koden. 

---

**Tre beslutninger bør leses før resten, fordi alt annet følger av dem. To er tatt. Den tredje er ikke, og bør tas.**

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

| Regel | Merknad |
|-------|---------|
| Alder — eldste eller yngste først | Eldste først er forskriftsfestet i det ordinære tilfellet |
| Loddtrekning | |
| Alle med samme sum får tilbud | Kan settes som unntak per utdanningstilbud |
| Tidspunkt for levert søknad — tidligste vinner | Egen regel for runden «ledige studieplasser» |

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

## Del 3: funksjonell løsning per oppgave

### Oppgave 1 — legge til runder for plasstildeling i ett opptak

Opptaksrunder opprettes sammen med opptaket og knyttes til ett opptak. Grunnlagsdata er navn, rundetype og svarfrist.

**Figma-prototype:** https://twins-gave-22504012.figma.site/

**Issue:** [#107](https://github.com/sikt-no/fs/issues/107) (lukket)

### Oppgave 2 — sette antall tilbud som skal gis per utdanningskvote

For hvert utdanningstilbud må det defineres hvor mange tilbud som skal gis i hver utdanningskvote i denne plasstildelingen. Saksbehandler ser en liste over utdanningstilbud med utdanningskvoter, aksepterte tilbud, gitte tilbud og antall planlagte studieplasser (kapasitet). Tallet settes per utdanningskvote; totaltallet vises.

Antall tilbud som skal gis per utdanningskvote virker.

**Begrepsendring:** feltnavnet «overbooking» skal endres. Historisk betydde overbooking at lærestedet ga flere tilbud enn antall studieplasser, som buffer mot frafall. I dagens felt er verdien i praksis rundens absolutte antall tilbud som skal gis, ikke et tillegg på toppen. Dette er avklart — se *Begrepsendringer*.

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

**Åpne spørsmål:** se del 2, punkt 10 (flere poengsummer i samme kvotetype) og punkt 7 (delte ventelistenumre).

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

Fire sider er verdt en faglig diskusjon, og alle fire står som avklaringspunkter i del 2:

- Et nei-svar frigjør ikke plassen før svarfristen er ute. Blir plassen stående reservert for lenge?
- En søker som godtar og senere trekker seg, frigjør aldri plassen igjen.
- Når en søker har både et tilbud og et kansellert resultat på samme utdanningstilbud — hva skal vises?
- Det finnes ingen mulighet for saksbehandler å overstyre et enkelt resultat manuelt. Alt krever full omkjøring.

**Issue:** [#170](https://github.com/sikt-no/fs/issues/170), [#264](https://github.com/sikt-no/fs/issues/264), [#512](https://github.com/sikt-no/fs/issues/512)

### Oppgave 9 — systemet gir automatisk nye tilbud ved nei-svar på tilbud (utenfor scope)

Utenfor scope for 2027-opptaket. Systemet skulle automatisk gi nye tilbud fra venteliste når noen faller fra, og fylle på opp mot grensen for antall tilbud som skal gis, uten manuell overvåking.

Behovet står igjen som sannsynlig mangel mot HK-dirs meldte behov: lærestedene har bedt om en mekanisme som raskt kompenserer for søkere som takker nei fordi de fikk tilbud høyere opp, uten å vente på neste runde. Se avklaringspunkt 3.

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

Vår påstand: disse hører ikke i «Hva vi trenger avklart» — de er issues, og bør registreres som det. Å behandle en feil som et åpent spørsmål gjør at den venter på et møte i stedet for på en rettelse.

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

1. Prosessbeskrivelse for plasstildeling på fs.sikt.no. Plasstildeling har ingen egen side i dag; den vises kun som enkeltoppgaven «tildel plass» i opptaksprosessen. Diagrammet og oppgaveinndelingen i dette dokumentet er utgangspunktet.
2. Eksempler per oppgave. Én Gherkin-feature per oppgave, slik at hver oppgave har konkrete eksempler på hva som skal kunne utføres. `krav/02 Opptak/14 Plasstildeling/` er ledig og følger nummereringen etter 13 Søknadsbehandling.
3. Oppdatere begrepene på fs.sikt.no etter tabellen over og begrepslisten under.
4. Registrere de seks mistenkte feilene som issues.
5. Verifisere negative opptaksparametere mot dagens løsning.
6. ~~Skrive om rollebeskrivelsen for opptaksforvalter~~ — avklart: opptaksforvalter utfører alle oppgaver knyttet til plasstildeling.

---

## Referanser

- 2025-05-15 Raffinering med HK-dir. Plasstildeling
- Plasstildelingsløpet i Opptak
- 2026-09-08 Raffinering plasstildeling
- HK-dirs behovsnotat 2024
- Opptaksforskriften § 7-1 fjerde ledd
- Opptaksprosessen på fs.sikt.no — mangler egen side for plasstildeling
