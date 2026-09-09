# Plasstildeling

Vi skal kunne fordele studieplasser i flere runder, med kontroll over naar soekeren ser resultatet, og med et resultat som kan forklares i etterkant. Det meste av dette virker i dag. Dette dokumentet beskriver hva loesningen gjoer, hva den ikke gjoer, og hvilke valg som gjenstaar.

Dokumentet er skrevet for tre lesergrupper. Del 1 og del 2 forutsetter ingen kjennskap til loesningen. Del 3 er for utviklere og kravarbeid.

**Status:** renskrevet raffinering, 2026-09-08. Bygger paa raffinering med HK-dir og gjennomgang av dagens loesning.

---

**Tre beslutninger boer leses foer resten, fordi alt annet foelger av dem. To er tatt. Den tredje er ikke, og boer tas.**

1. **Rundetypen styrer ikke lenger hvordan en runde oppfoerer seg.** Det gjoer arven: om runden bygger videre paa en tidligere publisert runde. Historisk var det rundetypen som avgjorde om et nei-svar frigjoerde plassen, om tidligere tilbud sto ved lag, og om det ble satt nye bortfall. I dagens loesning er dette flyttet — se *Hva en runde arver*.

2. **Beregning og publisering er to separate steg.** En plasstildeling kan kjoeres og bevisst ikke publiseres. Det er dette som gjoer ubegrensede proevetildelinger mulig, og det er nettopp det laerestedene har bedt om.

3. **En plasstildeling er i dag en kjoering man bestiller, ikke et resultat man kan rette.** Feiler den, er eneste utvei aa bestille en ny; ett enkelt manuelt tilbud krever full omkjoering av hele tildelingen. Nesten alt under *Funn paa tvers* foelger av denne ene egenskapen. Om det skal endres er en beslutning for produkteier — den boer tas bevisst, ikke oppdages under et opptak.

---

## Del 1: maal og retning

### Hva dette er, og hva det ikke er

Med plasstildeling mener vi beregningen som avgjoer hvem som faar plass, hvem som staar paa venteliste, og hvem som faar avslag — gjennomfoert for en runde i et opptak. Det er noe annet enn soknadsbehandlingen, som avgjoer om en soker er kvalifisert og hvor sterkt hun konkurrerer.

Skillet er ikke en formalitet. De to har ulikt fangstpunkt, ulik eier og ulik livssyklus:

|                  | Soknadsbehandling | Plasstildeling |
|------------------|-------------------|----------------|
| **Spoersmaalet** | er sokeren kvalifisert, og hvor staar hun i koeen? | hvem faar plassene som finnes? |
| **Skjer**        | loepende, per soknad | som en kjoering, per runde |
| **Eier**         | saksbehandler | opptaksleder |
| **Dekkes her**   | nei — vi abonnerer paa resultatet | ja |

Rangeringen kommer altsaa fra soknadsbehandlingen. Plasstildelingen eier ikke poengberegningen; den eier fordelingen. Det er derfor oppgave 3 nedenfor handler om aa hente og holde seg oppdatert paa rangeringen, ikke om aa beregne den.

**En runde er ikke det samme som en plasstildeling.** Runden er vinduet i opptaket der plasser fordeles og sokere faar svar. Plasstildelingen er beregningen som gjennomfoeres i runden. En runde kan ha mange plasstildelinger — proevetildelinger som ikke publiseres, og til slutt en som publiseres.

### Maal

- Hver soker faar ett tydelig svar per soknad: tilbud, venteliste med nummer, eller avslag.
- Laerestedet bestemmer hvor mange tilbud som skal gis per kvote per studietilbud, og kan la ledige plasser flyte til en annen kvote framfor aa gaa tapt.
- En plasstildeling kan kjoeres, kvalitetssikres og forkastes uten at sokeren merker noe.
- Resultatet skal kunne forklares i etterkant — hvorfor fikk denne sokeren tilbud, hvorfor fikk ikke den neste? Saerlig ved klage.
- En ny runde skal kunne bygge videre paa en tidligere uten aa miste resultatene fra den.

### Ikke-maal

- **Ikke kvalifiseringsvurdering.** Den hoerer i soknadsbehandlingen.
- **Ikke poengberegning.** Samme sted. Plasstildelingen leser rangeringen.
- **Ikke opptaksadministrasjon.** Oppretting av opptak og tilknytning av utdanningstilbud er dekket andre steder.
- **Ikke automatisk frafallskompensasjon i denne runden.** Se avklaringspunkt 3 — dette er stroeket fra scope i notatene, men staar samtidig igjen som meldt behov, og det henger ikke sammen.

### Fire prinsipper loesningen hviler paa

#### 1. Ingen soker skal forsvinne stille

Hver soknad som er med i en plasstildeling skal komme ut med et svar. En soker som mister kvalifiseringen sin mellom to runder skal faa et tydelig avslag, ikke bare falle ut av resultatlisten.

Dette er prinsippet dagens loesning bryter mest merkbart, og det er verdt aa si hvorfor det er alvorlig: et stille bortfall er ikke bare daarlig service. Det gjoer at fravaeret av et resultat kan bety to helt ulike ting — at sokeren aldri var med, eller at hun ble tatt ut underveis — og da kan vi ikke svare sokeren paa hva som skjedde med soknaden hennes.

#### 2. Sokeren skal kunne stole paa tilbudet sitt

Fra det oeyeblikket en soker har faatt et tilbud, skal ikke en senere runde kunne ta det fra henne. Det er dette som skiller etterfylling fra et nytt opptak, og det er grunnen til at forrige rundes tilbud fryses og garanteres naar en runde bygger paa en tidligere publisert runde.

Prisen staar i prinsipp 3.

#### 3. Ledige plasser skal ikke gaa tapt, men de flyter bare der noen har bestemt at de skal flyte

Er det oensket flere tilbud i en kvote enn det finnes kvalifiserte sokere i den, overfores de overskytende plassene til en annen kvote — men bare til den ene kvoten laerestedet har pekt paa, og bare innenfor samme studietilbud. Minst en kvote er sistekvote og sender ikke plasser videre, typisk ordinaer kvote.

At flyten er eksplisitt og retningsbestemt er et bevisst valg, ikke en begrensning vi ikke rakk aa loese: en plass som flyter dit ingen har bestemt, gir et resultat ingen kan forklare sokeren.

#### 4. Beregning og publisering er skilt

En plasstildeling er beregnet naar den er beregnet. Den er synlig for sokeren foerst naar noen har publisert den. Kvalitetssikring skjer i mellomrommet.

Dette prinsippet er billig aa ha og dyrt aa miste: uten det maa hver kvalitetssikring skje i produksjon, med sokeren som testpublikum.

### Slik henger det sammen

```
                      ┌──────────────────────────────────────────────┐
   OPPTAK ───────────►│   RUNDER I OPPTAKET        (oppgave 1)       │
   navn, rundetype,   │   en eller flere per opptak                  │
   datoer             └───────────────────┬──────────────────────────┘
                                          │
   SOKNADSBEHANDLING                      │     INNSTILLINGER PER KVOTE
   kvalifisering                          │     maaltall, plassflyt,
        │                                 │     tilbud til alle kvalifiserte,
        ▼                                 │     kvote for tilbudsgaranti
   kvotetilhoerighet, poeng, rangering    │     (oppgave 2)
   (oppgave 3)                            │              │
        └───────────────┐                 │              │
                        ▼                 ▼              ▼
                     ╔═════════════════════════════════════════════╗
   forrige           ║        PLASSTILDELING     (oppgave 4)       ║
   publiserte  ─────►║  hvem faar plass — og hva ble poenggrensen? ║
   runde (arv)       ╚══════════════════════┬══════════════════════╝
                                            │
                                            ▼
              resultat per soknad: tilbud / venteliste (nr) / avslag
              poenggrense per kvote  ·  spor av plassflyt
                                            │
                     ┌──────────────────────┴──────────────────────┐
                     ▼                                             ▼
           SAKSBEHANDLER (oppgave 5)                  PUBLISERING (oppgave 6)
           kvalitetssikring foer publisering          valgfri — en proeve-
                                                      tildeling publiseres ikke
                                                                   │
                                                                   ▼
                                                     SVAR FRA SOKER (oppgave 7)
                                                     ja / nei / staar paa venteliste
                                                                   │
                                             utloeser ny runde ────┘
```

Legg merke til pilen nederst til venstre: arven fra forrige publiserte runde er en inngang til beregningen paa linje med innstillingene og rangeringen. Det er den som gjoer etterfylling mulig, og det er den som avgjoer hvordan runden oppfoerer seg.

### Hva en runde arver fra forrige

Dette er den viktigste tabellen i dokumentet, fordi den erstatter det rundetypen gjorde foer:

| Egenskap | Runde uten arv (foerste runde) | Runde med arv (etterfylling) |
|----------|-------------------------------|------------------------------|
| Tidligere tilbud | finnes ikke | fryses og garanteres |
| Nytt tilbud fra venteliste | – | sokeren mister ikke det gamle automatisk |
| Bortfall paa lavere prioriteter | settes | settes ikke |
| Nei-svar | – | frigjoer plassen foerst naar svarfristen er ute |

Begrunnelsen for hoeyre kolonne er prinsipp 2: paa dette stadiet skal sokeren kunne stole paa tilbudet sitt. Men det gir ogsaa oppfoerselen en modus, og det er kilden til flere av de aapne spoersmaalene i del 2 — se avklaringspunkt 2.

### Status per oppgave

| # | Oppgave | Status | Det som mangler |
|---|---------|--------|-----------------|
| 1 | Starte en ny plasstildeling | Stoettet | Feiler en tildeling, kan den ikke kjoeres om — bare erstattes av en ny |
| 2 | Sette maaltall og plassflyt per kvote | Delvis | En mottakerkvote per kvote; ingen flyt mellom studietilbud; ingen flyt mellom tildelinger |
| 3 | Hente rangering fra soknadsbehandlingen | Delvis | Endret soknad mellom runder fanges ikke opp; tapt kvalifisering gir stille bortfall |
| 4 | Gjennomfoere tildelingen og finne poenggrensen | Delvis | Poenggrensen beregnes og lagres aldri, selv om det finnes en plass aa vise den |
| 5 | Vise resultatet til saksbehandler | Delvis | Ventelistenummeret naar ikke fram til sokeren, selv om innstillingen finnes |
| 6 | Publisere resultatet til soekerne | Stoettet | Ett hull, se oppgave 5 — det som publiseres mangler ventelistenummer |
| 7 | Haandtere svar fra soker | Delvis | Trukket ja-svar frigjoer aldri plassen; ingen manuell overstyring av enkeltresultat |
| 8 | Frafallskompensasjon rett etter hovedopptaket | Avgrenset | Men se avklaringspunkt 3 |

«Delvis» betyr her at kjernefunksjonen virker og at det som mangler er navngitt. Ingen av oppgavene er usikre paa om de virker.

### Funn paa tvers av oppgavene

Tre funn tilhoerer ingen enkeltoppgave, og de er de tyngste i dokumentet:

1. **Ingen plasstildeling kan avbrytes eller kjoeres om.** Dette er beslutning 3 fra innledningen, sett fra driftssiden. Konsekvensen er at enhver feilretting — en feil innstilling, ett manuelt tilbud, en avbrutt kjoering — koster en full omkjoering av hele tildelingen.

2. **Tilgangsstyringen er alt-eller-ingenting.** En rolle ser alle sokernavn og alle resultater i hele opptaket, uten finere inndeling. Behovet er opptaksleder- og saksbehandlertilganger avgrenset til de organisasjonene brukeren har tilgang fra. Dette er ikke bare en manglende feature — det er et personvernfunn, og det hoerer derfor ogsaa i del 2.

3. **Seks mistenkte feil i koden er identifisert.** De er ikke bevisste valg. To er beskrevet: bortfall kan beregnes mot feil tilbud naar en soker har flere tilbud samtidig, og ventelistenumre kan kollidere mellom runder. De fire oevrige er listet i del 4.

### Blindsoner

Dette er hva loesningen ikke svarer paa, og som ikke lukkes med mer arbeid paa samme sted:

| Blindsone | Hva det betyr |
|-----------|---------------|
| Plassflyt mellom studietilbud | Plasser flyter mellom kvoter innenfor ett studietilbud. Ledig kapasitet paa ett tilbud kan ikke brukes paa et annet |
| Flere mottakerkvoter | En kvote kan sende overskytende plasser til en kvote, ikke fordele dem paa flere. Flerledds-kjeder virker, forgrening gjoer ikke |
| Poenggrense som historikk | Poenggrensen sokeren eventuelt ser i dag kommer fra en annen kilde enn tildelingen. Fjoraarets median, som er viktig for tidlig tilbud, settes i saksbehandlingen |
| Manuell overstyring | Det finnes ingen vei til aa endre ett enkelt resultat. Alt gaar gjennom en ny tildeling |
| Negative opptaksparametere | Den historiske muligheten for aa redusere antall aktive tilbud i et suppleringsopptak er ikke verifisert mot dagens loesning |

---

## Del 2: regelverk, roller og personvern

Denne delen setter loesningen opp mot regelverket og mot HK-dirs meldte behov. Den er skrevet for aa bli motsagt: der vi har tatt et standpunkt staar det som vaar paastand, og der vi ikke har konkludert staar det i *Hva vi trenger avklart*. Vi er ikke jurister — dette er funksjonelle beskrivelser med et forslag til innramming.

### Poenglikhet er delvis forskriftsfestet

At eldste soker gaar foran yngre ved poenglikhet foelger av opptaksforskriften § 7-1 fjerde ledd. Det er ikke et aapent spoersmaal, og notatene behandlet det som ett. Dagens kode er riktig.

Vaar paastand: dette hoerer i dokumentasjonen, ikke i diskusjonen. Det vi trenger er at regelen er synlig som forskriftsfestet, slik at den ikke blir tatt opp paa nytt hver gang noen leser at det finnes flere poenglikhetsregler.

Loesningen skal likevel kunne haandtere flere regler, koblet til opptaket:

| Regel | Merknad |
|-------|---------|
| Alder — eldste eller yngste foerst | Eldste foerst er forskriftsfestet i det ordinaere tilfellet |
| Loddtrekning | |
| Alle med samme sum faar tilbud | Kan settes som unntak per utdanningstilbud |
| Tidspunkt for levert soknad — tidligste vinner | Egen regel for runden «ledige studieplasser» |

### Valgfriheten ved poenglikhet kan vaere tapt

Laerestedene kunne tidligere velge mellom en strengere avgrensning og «alle med samme poengsum faar tilbud», per studium. I dag ser det ut til at hele likhetsgruppen alltid faar tilbud, uten alternativ.

Vaar paastand: laerestedet skal kunne legge unntakskrav paa et utdanningstilbud, men bare i en retning — «alle med samme sum faar tilbud». En strengere avgrensning enn forskriftens er ikke lov. Om dagens oppfoersel dermed er riktig eller for grov, avhenger av om valgfriheten var mellom to lovlige alternativer eller mellom et lovlig og et ulovlig.

### Tilbudsgaranti tas fra en bestemt kvote

En tilbudsgaranti er en kode paa en soknad som gir tilbud uavhengig av poengsum og kvalifiseringsstatus. Den brukes til aa rette opp feil, men ogsaa til aa gi tilbud til spesielle sokergrupper, til tilsagn i et tidligopptak, og til sokere med reservert plass.

For hvert studium kan laerestedet eller HK-dir sette om tilbudsgarantier skal tas fra en bestemt kvote, og i saa fall hvilken. Plasstildelingen skal ta garantiplassene fra den kvoten som er markert for det.

Dette er verdt aa merke seg fordi en tilbudsgaranti forbruker en plass: den er ikke gratis, den flytter belastningen til en kvote noen har pekt paa.

### Tilgangsstyring er et personvernspoersmaal, ikke bare en feature

At en rolle ser alle sokernavn og alle resultater i hele opptaket, uten inndeling per organisasjon, betyr at en saksbehandler ved ett laerested i praksis har innsyn i sokere som ikke angaar hennes institusjon.

Vaar paastand: dette er en for bred tilgang til personopplysninger, og inndeling per organisasjon er et krav og ikke en forbedring. Vi bringer det inn her framfor bare i funn-listen, fordi konsekvensen ikke er daarlig ergonomi — den er at behandlingen kan vaere mer omfattende enn den trenger aa vaere.

### Sokeren skal kunne forstaa svaret sitt

Sokeren skal se tilbud, avslag eller venteliste, og et vedtak med begrunnelse: kvalifisering, rangering, poenggrense.

To hull er verdt aa nevne her og ikke bare i statustabellen, fordi de rammer nettopp forklarbarheten:

- **Ventelistenummeret naar ikke fram til sokeren i dag**, selv om innstillingen for aa vise det finnes. En venteliste uten nummer er ikke en venteliste for sokeren; det er en beskjed om at hun ikke fikk plass.
- **Poenggrensen beregnes og lagres ikke av tildelingen.** Den poenggrensen sokeren eventuelt ser, kommer fra en annen kilde. Vedtaket begrunnes altsaa med et tall loesningen selv ikke har regnet ut.

Ved klage maa det i tillegg kunne spores at en plass kom via plassflyt fra en annen kvote. Det virker i dag.

### Hva vi trenger avklart

Ordnet etter hvor mye svaret endrer loesningen.

1. **Skal en plasstildeling kunne kjoeres om, avbrytes, eller korrigeres i enkeltresultater?** Dette er hovedspoersmaalet. Et ja betyr at plasstildelingen ikke bare er en kjoering, men et resultat med livssyklus — det er en annen loesning, ikke en justering av denne.
2. **Er en runde alltid etterfylling, eller skal den kunne vaere supplering?** Svaret avgjoer fire andre spoersmaal samtidig.
3. **Er frafallskompensasjon rett etter hovedopptaket i scope?** Notatene stryker den som oppgave 8 og lister den samtidig som sannsynlig mangel mot meldt behov. Begge kan ikke staa.
4. **Skal et nei-svar frigjore plassen foer svarfristen er ute?** I dag staar plassen «reservert» til fristen. Er det for lenge?
5. **Skal en soker som godtar og senere trekker seg, frigjore plassen til ventelisten?** I dag frigjoeres den aldri.
6. **Skal ventelistenumre staa uroert etter opprykk, eller nummereres paa nytt?** Gjenkjennbarhet mot korrekthet.
7. **Skal sokere med lik rangering paa venteliste dele nummer, eller faa vilkaarlige unike numre?** I dag: vilkaarlige unike.
8. **Boer maaltallet kunne oekes automatisk ved opprykk**, slik at en frigjoert plass ikke gaar tapt?
9. **Skal det finnes en «topp opp til oensket nivaa»-funksjon de foerste ukene**, framfor manuell overvaaking og etterfylling? Laerestedene har bedt om det.
10. **Naar en soker har flere poengsummer i samme kvotetype:** er det riktig at hoeyeste poengsum vinner, og at laveste grunnlagskode avgjoer ved likhet?
11. **Naar en soker har baade et tilbud og et kansellert resultat paa samme studietilbud** — skal det kansellerte vises til sokeren i stedet for tilbudet?
12. **Hva er funksjonalitetsforskjellen mellom rundetypene, utover arven?** Notatene sier dette maa gaas opp med HK-dir. Hvis svaret er «ingen», er rundetypen et navn og ikke en regel, og det boer staa.
13. **Hva skal rollen «opptaksforvalter» kunne gjore?** Notatene sier «faar lov aa sette plasstildelingslister i liste». Formuleringen er uklar og maa skrives om av den som eide den.

Spoersmaal 4–11 er produkteier- og HK-dir-spoersmaal. Spoersmaal 1–3 endrer omfanget. Spoersmaal 12–13 er hull i notatene, ikke i loesningen.

---

## Del 3: funksjonell loesning per oppgave

### Oppgave 1 — runder og oppstart av en plasstildeling

Opptaksrunder opprettes sammen med opptaket og knyttes til ett opptak. Grunnlagsdata er navn og rundetype.

Man bestiller en plasstildeling, og den kjoeres automatisk i bakgrunnen. Den bygger riktig videre paa forrige publiserte runde.

**Aapent:** i hvilken grad utledes starten paa en runde fra datoene som er satt i opptaket? Setter man dato for rundene og lar systemet starte tildelingen, eller er det en startknapp noen maa trykke paa? Svaret avgjoer om «start» er en handling eller en tilstand.

**Svakhet:** feiler en plasstildeling, er eneste mulighet aa starte en helt ny. Det finnes ingen maate aa rette opp eller kjoere den samme paa nytt.

**Issue:** [#108](https://github.com/sikt-no/fs/issues/108) (lukket), [#107](https://github.com/sikt-no/fs/issues/107) (lukket)

### Oppgave 2 — maaltall og plassflyt per kvote

For hvert utdanningstilbud maa det defineres hvor mange plasser som er ledige i hver kvote i denne plasstildelingen. Saksbehandler ser en liste over utdanningstilbud med kvoter, aksepterte tilbud, gitte tilbud og antall planlagte studieplasser (kapasitet). Tallet settes per kvote; totaltallet vises.

Maaltall per kvote virker. Plassflyt mellom kvoter paa samme studietilbud virker, inkludert flere ledd etter hverandre.

Det som ikke er mulig: en kvote kan bare sende ledige plasser videre til en mottakerkvote, plasser kan ikke flyte mellom ulike studietilbud, og de kan ikke flyte fra en plasstildeling til en senere.

**Begrepsendring:** feltnavnet «overbooking» skal endres. Historisk betydde overbooking at laerestedet ga flere tilbud enn antall studieplasser, som buffer mot frafall. I dagens felt er verdien i praksis rundens absolutte maaltall, ikke et tillegg paa toppen. Dette er avklart — se *Begrepsendringer*.

**Utgaatt fra tidligere utkast:** oensket antall ja-svar totalt, med utledet overbookingsrate og forrige aars tilbud er ikke med.

### Oppgave 3 — rangering fra soknadsbehandlingen

Hver soker som er kvalifisert til en kvote faar beregnet poengsum og rangering i soknadsbehandlingen, slik at det er tydelig hvem som staar foerst i koeen. Plasstildelingen abonnerer paa endringer i rangeringen og skal kunne beregne paa nytt hvis grunnlaget endres.

Selve rangeringen og poengberegningen virker.

To svakheter:

- Systemet fanger ikke opp at en soker har endret soknaden sin mellom runder.
- En soker som mister kvalifiseringen mellom to runder forsvinner stille fra resultatet i stedet for aa faa et tydelig avslag. Dette bryter prinsipp 1.

**Issue:** [#71](https://github.com/sikt-no/fs/issues/71) (lukket), [#92](https://github.com/sikt-no/fs/issues/92) (lukket)

### Oppgave 4 — gjennomfoere tildelingen og finne poenggrensen

Tildelingen avgjoer hvor mange sokere som faar plass i hver kvote, og hva poenggrensen for aa komme inn ble. Den maa ta hensyn til plassflyt mellom kvoter, og til at noen kvoter kan gi tilbud til alle kvalifiserte uten poenggrense. Tilbudsgarantier tas fra den kvoten laerestedet eller HK-dir har markert.

Sokeren proeves i kvotene etter kvoteprioritet — normalt den mest spesielle kvoten foerst, den minst spesielle sist.

Selve tildelingen virker, inkludert kvoter uten poenggrense.

**Poenggrensen per kvote beregnes og lagres aldri**, selv om det finnes en plass aa vise den. Fjoraarets medianverdi, som er viktig for hvem som faar tidlig tilbud, settes i forbindelse med saksbehandlingen og er en annen kilde.

**Aapne spoersmaal:** se del 2, punkt 10 (flere poengsummer i samme kvotetype) og punkt 7 (delte ventelistenumre).

### Oppgave 5 — vise resultatet til saksbehandler

Hver soker skal ha ett tydelig svar per soknad: tilbud, venteliste med nummer, eller avslag. Fikk sokeren plass gjennom plassflyt fra en annen kvote, skal det kunne spores i etterkant, for eksempel ved klage.

Begge deler virker. **Ventelistenummeret naar aldri fram til sokeren**, selv om innstillingen for aa vise det finnes.

**Issue:** [#109](https://github.com/sikt-no/fs/issues/109) (lukket)

### Oppgave 6 — publisere resultatet til soekerne

Soekerne skal se resultatet sitt i Min kompetanse paa et bestemt, kontrollert tidspunkt. Det maa vaere mulig aa beregne tildelingen foer den gjoeres synlig, og aa velge aa ikke publisere den i det hele tatt (proevetildeling).

Publisering virker og gir kontroll over naar sokeren ser resultatet. Ubegrensede proeveopptakk paa alle rundetyper er dermed godt loest, fordi beregning og publisering er separate steg — nettopp slik laerestedene har bedt om.

Sokeren skal se tilbud, avslag eller venteliste, og vedtaket med begrunnelse: kvalifisering, rangering, poenggrense. Hullet er ventelistenummeret fra oppgave 5.

**Issue:** [#111](https://github.com/sikt-no/fs/issues/111), [#72](https://github.com/sikt-no/fs/issues/72), [#221](https://github.com/sikt-no/fs/issues/221)

### Oppgave 7 — haandtere svar fra soker

Sokeren skal kunne akseptere eller avslaa tilbudet, eller staa paa venteliste, innenfor en svarfrist. Svarene skal kunne utloese en etterfylling som bygger videre paa forrige plasstildeling.

Grunnfunksjonen virker: sokeren kan takke ja eller nei, og forrige rundes tilbud beholdes automatisk til neste runde.

Fire sider er verdt en faglig diskusjon, og alle fire staar som avklaringspunkter i del 2:

- Et nei-svar frigjoer ikke plassen foer svarfristen er ute. Blir plassen staaende reservert for lenge?
- En soker som godtar og senere trekker seg, frigjoer aldri plassen igjen.
- Naar en soker har baade et tilbud og et kansellert resultat paa samme studietilbud — hva skal vises?
- Det finnes ingen mulighet for saksbehandler aa overstyre et enkelt resultat manuelt. Alt krever full omkjoering.

**Issue:** [#170](https://github.com/sikt-no/fs/issues/170), [#264](https://github.com/sikt-no/fs/issues/264), [#512](https://github.com/sikt-no/fs/issues/512)

### Oppgave 8 — kompensere automatisk for frafall rett etter hovedopptaket

Stroeket fra scope i raffineringen. Systemet skulle automatisk gi nye tilbud fra venteliste naar noen faller fra, og fylle paa opp mot grensen for antall tilbud, uten manuell overvaaking. Nivaaet skulle kunne justeres opp eller ned, inkludert aa aktivt dempe tilstroemningen dersom laerestedet har faatt for mange ja-svar.

Men behovet staar igjen som sannsynlig mangel mot HK-dirs meldte behov: laerestedene har bedt om en mekanisme som raskt kompenserer for sokere som takker nei fordi de fikk tilbud hoeyere opp, uten aa vente paa neste runde. I dagens loesning fryses og garanteres forrige rundes tilbud i alle runder med arv, og det er etterfyllings-oppfoersel, ikke supplerings-oppfoersel.

Enten er oppgaven ute av scope og boer ut av mangel-listen, eller den er en mangel og hoerer i veikartet. Se avklaringspunkt 3.

---

## Mistenkte feil

Seks mistenkte feil er identifisert, og de er ikke bevisste valg:

| Feil | Konsekvens | Issue |
|------|------------|-------|
| Bortfall beregnes mot feil tilbud naar en soker har flere tilbud samtidig | Sokeren kan miste et studieonske hun skulle beholdt | |
| Ventelistenumre kan kollidere mellom runder | To sokere kan ha samme nummer, eller samme soker ulike | |
| Fristsjekk bruker applikasjonsklokke i stedet for databaseklokke | Fristsjekken kan vaere upaalitelig ved klokkedrift | |
| Historiske resultater leses tilbake med feil resultattype (kollaps til IKKE_GYLDIG) | Soker som mistet kvalifisering forsvinner stille — bryter prinsipp 1 | |
| Harde tallgrenser (9999/99) feller hele kjoeringen | En plasstildeling med for mange sokere krasjer | |
| Sokers svar knyttes til runde paa loepenummer alene, uten rundetype | Svar kan havne paa feil runde naar det finnes flere rundetyper | |

Vaar paastand: disse hoerer ikke i «Hva vi trenger avklart» — de er issues, og boer registreres som det. Aa behandle en feil som et aapent spoersmaal gjoer at den venter paa et moete i stedet for paa en rettelse.

---

## Begrepsendringer

| Gammelt begrep | Nytt begrep | Begrunnelse |
|----------------|-------------|-------------|
| Opptakskjoering | Plasstildeling | Ikke lenger offisielt begrep |
| Kvoteflyt | Plassflyt | Det er plassene som flyter, ikke kvoten |
| Overbooking | Maaltall for runden | Verdien er rundens absolutte maaltall, ikke en buffer paa toppen — se oppgave 2 |

---

## Begrepsforklaringer

**Plasstildeling** — beregningen som avgjoer hvem som faar plass, staar paa venteliste, eller faar avslag, gjennomfoert for en runde i et opptak. Tidligere term: opptakskjoering, ikke lenger offisielt begrep.

**Runde i plasstildelingen** — et definert vindu i et opptak der plasser fordeles og sokere faar svar. Ett opptak kan ha flere runder, f.eks. hovedrunde og etterfyllingsrunde. Historisk styrte rundetypen hvilke regler som gjaldt. I dagens loesning er det ikke rundetypen, men om runden bygger videre paa en tidligere publisert runde, som avgjoer oppfoerselen.

**Utdanningskvote** — en koeordning. Kvalifiserte sokere plasseres i minst en kvote ut fra et regelverk (lov, forskrift eller studieplan), og faar plass i koeen etter poengsum i den aktuelle kvoten. Eksempler: foerstegangsvitnemaal, nordnorsk. Paa kvoten angis hvor mange plasser den har til disposisjon i denne konkrete plasstildelingen paa konkrete utdanningstilbud, og hvilken metode som brukes for aa fylle dem.

**Kvoteprioritet** — rekkefoelgen en soker proeves i de ulike kvotene et studietilbud har. Normalt proeves den mest spesielle kvoten foerst og den minst spesielle sist.

**Plassflyt** — innstilling som utloeses naar det er oensket flere tilbud i en kvote enn det er kvalifiserte sokere i kvoten. Plassflyt angir hvilken en annen kvote de overskytende plassene overfores til, innenfor samme studietilbud. Flyten kan gaa i flere ledd etter hverandre, og kan endres ved behov. Minst en kvote er sistekvote og kan ikke sende plasser videre, typisk ordinaer kvote. Tidligere term: kvoteflyt.

**Arv fra forrige runde** — at en plasstildeling bygger videre paa forrige publiserte runde: tidligere tilbud fryses og garanteres, og det settes ikke nye bortfall. Dette er noe annet enn plassflyt, som gjelder mellom kvoter i samme tildeling.

**Maaltall for runden** — hvor mange tilbud som skal gis i en kvote i denne plasstildelingen. Settes per kvote; totaltall vises. Tidligere feltnavn: overbooking.

**Poenggrense** — den laveste poengsummen som gav plass i en gitt kvote. Brukes til aa informere sokere om hvor «hoeytt» det var aa komme inn.

**Poenglikhetsregel** — hvordan sokere med lik poengsum behandles. Eldste soker foerst er forskriftsfestet i det ordinaere tilfellet; «alle med samme poengsum faar tilbud» kan settes som unntak per utdanningstilbud; loddtrekning og tidligste soknadstidspunkt finnes som regler.

**Tilbud til alle kvalifiserte** — en kvote kan settes opp uten poenggrense, slik at alle kvalifiserte faar plass uansett poengsum. Typisk ved lav soekning.

**Tilbudsgaranti** — en kode paa en soknad som gir tilbud om studieplass uavhengig av poengsum og kvalifiseringsstatus. Brukes til aa rette opp feil, gi tilbud til spesielle sokergrupper, gi tilsagn i et tidligopptak, eller til sokere med reservert plass. Per studium settes om garantier skal tas fra en bestemt kvote, og hvilken.

**Svar** — resultatet sokeren faar per soknad: tilbud om plass, plass paa venteliste med ventelistenummer, eller avslag.

**Etterfylling** — en ny runde som fyller opp plasser som ble ledige etter at sokere svarte nei eller ikke svarte i tide. Kjennetegnet ved at sokeren ikke mister et tilbud automatisk ved nytt tilbud fra venteliste, og at det ikke settes nye bortfall paa lavere prioriterte studieoensker — fordi sokeren paa dette stadiet skal kunne stole paa tilbudet sitt.

**Supplering** — aa gi nye tilbud raskt for aa kompensere for frafall, uten aa vente paa neste runde. Ikke det samme som etterfylling. Se avklaringspunkt 2.

**Roller** — opptaksleder starter runder og setter innstillinger. Saksbehandler kvalitetssikrer resultatet. Opptaksforvalter: rollebeskrivelsen i notatene er uklar og maa skrives om.

---

## Oppgavenummerering

Oppgavene er omstrukturert siden forrige runde. Kravnumrene foelger etter:

| Ny | Oppgave | Var foer |
|----|---------|----------|
| 1 | Legge til runder for plasstildeling i ett opptak | 1 |
| 2 | Sette plasstildelingsinnstillinger (antall tilbud per utdanningskvote) | 2 (delt) |
| 3 | Sette plassflyt mellom utdanningskvoter | 2 (delt) |
| 4 | Starte en ny plasstildeling | 1b |
| 5 | Gjennomfoere plasstildeling | 3 + 4 |
| 6 | Vise resultatet til saksbehandler | 5 |
| 7 | Publisere resultatet til soekerne | 6 |
| 8 | Haandtere svar fra soker | 7 |

---

## Gap-analyse per oppgave

Evidensnivaa: **M** = verifisert i datamodellen, **S** = dokumentert i en sak, **V** = verifisert i koden

### Oppgave 1 — Legge til runder

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Navn paa runde | `opptak.opptaksrunde.navn` NOT NULL | Ingen | M |
| Svarfrist for soker | `opptaksrunde.svarfrist` NOT NULL | Ingen | M |
| Dato for naar plasstildelingen skal skje | **Ingen kolonne** | Feltet finnes ikke i modellen | M |
| Rundetype (hoved/tillegg/supplerende) | `opptaksrundetype_kode` | Se strukturfunn under | M |
| Publiseringstidspunkt | `opptaksrunde.publiseringstidspunkt` (nullable) | Automatisk publisering avgrenset bort | M |
| Periode for aa endre parametere | `opptaksrunde.periode_endre_opptaksparametere` (tstzrange) | Finnes i modellen, ikke i krav | M |

**Strukturfunn:** `opptaksrundetype_kode` er del av **primaernoekkelen** til `opptak.opptaksrunde` og foelger med i hver fremmednoekkel ut derfra. En runde kan ikke bytte type etter oppretting, og loepenummer er unikt per rundetype, ikke per opptak.

### Oppgave 2 — Antall tilbud som skal gis

Fire tall i fire tabeller:

| Tabell | Kolonne | Nivaa | Brukes av algoritmen | Ev. |
|--------|---------|-------|---------------------|-----|
| `opptak.utdanningstilbud` | `antall_studieplasser` | Per utdanningstilbud (kapasitet) | Nei — kun visning | M+V |
| `opptak.kvote` | `onsket_antall_deltakere` | Per kvote, per opptak | **Fallback** naar overbook mangler | M+V |
| `opptak.opptaksparametere` | `overbook_antall_plasser` | Per kvote **per runde** | **Ja — dette er maaltallet** | M+V |
| `plasstildeling.studiekvote` | `onsket_antall_tilbud` NOT NULL | Per kvote **per plasstildeling** | Nei — kun visning/snapshot | M+V |

**Verifisert i koden:** `KvoterService:98-104` er eksplisitt: `overbook_antall_plasser` er maaltallet, med fallback til `onsket_antall_deltakere`. Begrepet «overbook» er misvisende — kolonnen er det faktiske antall tilbud som skal gis, ikke et tillegg.

### Oppgave 3 — Plassflyt

| Krav | Funn | Ev. |
|------|------|-----|
| Flyt til en mottakerkvote | `studiekvote` har **ett** sett flyt-kolonner — bekreftet, en mottaker | M |
| Kan ikke krysse utdanningstilbud | Flyt-FK-en gjenbruker kildens org/utdanning/periode — strukturelt umulig | M |
| Flyt fra en tidligere plasstildeling | Modellen kan peke paa en annen runde/tildeling, men **koden bruker det ikke** | M+V |
| Plassflyt opererer innenfor en tildeling | `Opptakskjoringsalgoritme` bygger flytkart og omfordeler innenfor en kjoering | V |
| Mellom runder: `basert_pa`-kjeden | Resultater viderefores via `basert_pa`, ikke plassflyt | V |
| Plassflyt kan endres per tildeling | Tre nivaaer: `regelverk.kvotetype` -> `opptak.kvote` -> `studiekvote` | M |
| Sistekvote (stopper flyten) | NULL i flyt-kolonnene | M |
| Sirkulaeritetsvern i koden | `findPaafyllingsStudiekvoter` og `finnKvoterSomFlyterTil` bruker visited-sett, logger `warnf("Cycle detected...")` | V |
| Sirkulaeritetsvern i skjemaet | **Ingen CHECK-constraint eller trigger** | V |
| Test for sirkularitet | `testCircularPlassflytDoesNotHang` bekrefter at algoritmen haandterer sykler | V |

Plassflyt opererer kun innenfor en plasstildeling. Kryss-tildeling-kolonnene i modellen brukes ikke av koden. Sirkularitetsvernet finnes i koden men ikke i databasen.

### Oppgave 4 — Starte en ny plasstildeling

| Krav | Funn | Ev. |
|------|------|-----|
| Bygge paa forrige publiserte tildeling | `plasstildeling.*_basert_pa` — `OpprettPlasstildelingService` finner grunnlaget automatisk | M+V |
| Kjoerer automatisk i bakgrunnen | `plasstildelingsstatus` med default `'KLAR'`, egen kodetabell | M |
| Beregning skilt fra publisering | `plasstildeling.publiseres` (boolean) | M |
| Kjoere om / avbryte en feilet tildeling | Aktivt avvist som beslutning | S |
| Se at en tildeling feilet | Ikke eksponert i GraphQL | S |

### Oppgave 5 — Gjennomfoere plasstildeling

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Poenggrense per kvote lagres | `plasstildeling.poenggrense` tabell finnes | **Tabellen populeres ikke av koden.** Tre skriveoperasjoner (studiekvoter, kvotesoknader, resultater) — ingen for poenggrense | M+V |
| Poenggrense vist til soker er riktig | Kjent feil, men tabellen er tom uansett | S+V |
| Rangering hentes fra soknadsbehandlingen | `kvotesoknad` med `rangering`, `poengsum`, `prioritet`, `har_tilbudsgaranti`, `svartype_kode` | Ingen | M |
| Endret soknad fanges opp mellom runder | Aapen avklaring | S |
| Soker som mister kvalifisering faar avslag | Les/skriv-asymmetri i resultattype | S |
| Tilbudsgaranti fra markert kvote | `opptak.tilbudsgaranti_kvote` | Ingen | M |
| Kvoteprioritet | Tre nivaaer: `kvotetype` -> `kvote` -> `studiekvote` | Ingen | M |
| Poenglikhetsregel koblet til opptaket | Regelen haenger paa **kvotetype**, ikke opptak | M |
| Fire poenglikhetsregler | To av fire ser ut til aa vaere dekket | S |

Poenggrense-beregning er designet i skjemaet men **ikke implementert**. Hele tabellen er tom. Dette er en ny feature, ikke en feilretting.

### Oppgave 6 — Vise resultatet til saksbehandler

| Krav | Funn | Ev. |
|------|------|-----|
| Tilbud / venteliste med nummer / avslag | `plasstildelingsresultat` med `svartype_kode`, `ventelistenummer`, `plasstildelingsresultat_type_kode` | M |
| Spore plass via plassflyt | `plasstildelingsresultat.plass_fra_kvotetype_kode` med FK | M |
| Ventelistenummer er entydig | **Ingen unikhetsskranke** | M |
| Vis ventelistenummer til soker | `utdanningstilbud.vis_ventelistenummer_for_soker` (default false) | M |
| Vis poenggrense til soker | `utdanningstilbud.vis_poenggrense_for_soker` (default false) | M |

Resultatet finnes **to steder**: per tildeling i `plasstildeling.plasstildelingsresultat` og denormalisert paa `soknad.soknadsalternativ`. Mulig kilde til inkonsistens.

### Oppgave 7 — Publisere resultatet

| Krav | Funn | Ev. |
|------|------|-----|
| Kontroll over publiseringstidspunkt | `plasstildeling.publiseres` + `opptaksrunde.publiseringstidspunkt` | M |
| Vedtak med begrunnelse | Haenger paa poenggrense-gapet — tabellen er tom | M+V |
| Melding om vedtak til soker | `soknad.sokermelding` med FK til `kommunikasjon.melding` og `opptaksrunde` — roeret finnes | M |
| Arv av svartype ved publisering | Aapen avklaring | S |

### Oppgave 8 — Haandtere svar fra soker

| Krav | Funn | Ev. |
|------|------|-----|
| Soker svarer ja/nei innen frist | `soknad.opptakssvar` per soker, alternativ og runde | M |
| Svar knyttes til riktig runde | PK uten `opptaksrundetype_kode` — rettet i skjema, ikke i kode | M+S |
| Fristsjekk | Bruker applikasjonsklokke i stedet for databaseklokke | S |
| Trukket ja frigjoer plassen | **Ingen kolonne** for trekk/frigjoering i `opptakssvar` | M |
| Manuell overstyring | `soknadsalternativ` har skrivbare resultattype-kolonner + `skal_spesialbehandles` | M |

---

## Kjernetjenester i koden

Verifisert i `fs-plattform/opptak`:

| Tjeneste | Ansvar |
|----------|--------|
| `KvoterService` | Leser kvotekonfigurasjon (kapasitet, prioritet, plassflytmaal). Maaltall: `overbook_antall_plasser` med fallback til `onsket_antall_deltakere` |
| `KvotesumService` | Beregner beste poengscore per soker per kvotetype — input-forberedelse |
| `OpprettPlasstildelingService` | Oppretter ny plasstildeling-rad med status KLAR, finner `basert_pa`-grunnlaget automatisk |
| `Opptakskjoringsalgoritme` | Selve tildelingsalgoritmen. Bygger flytkart, omfordeler plasser innenfor en kjoering |
| `PlasstildelingSkriveService` | Tre skriveoperasjoner: studiekvoter, kvotesoknader, resultater. **Ikke** poenggrense |

---

## Arbeid som maa gjoeres

1. Prosessbeskrivelse for plasstildeling paa fs.sikt.no. Plasstildeling har ingen egen side i dag; den vises kun som enkeltoppgaven «tildel plass» i opptaksprosessen. Diagrammet og oppgaveinndelingen i dette dokumentet er utgangspunktet.
2. Eksempler per oppgave. En Gherkin-feature per oppgave, slik at hver oppgave har konkrete eksempler paa hva som skal kunne utfoeres. `krav/02 Opptak/14 Plasstildeling/` er ledig og foelger nummereringen etter 13 Soknadsbehandling.
3. Oppdatere begrepene paa fs.sikt.no etter tabellen over og begrepslisten under.
4. Registrere de seks mistenkte feilene som issues.
5. Verifisere negative opptaksparametere mot dagens loesning.
6. Skrive om rollebeskrivelsen for opptaksforvalter — dagens formulering i notatene er uklar.

---

## Referanser

- 2025-05-15 Raffinering med HK-dir. Plasstildeling
- Plasstildelingsloepet i Opptak
- 2026-09-08 Raffinering plasstildeling
- HK-dirs behovsnotat 2024
- Opptaksforskriften § 7-1 fjerde ledd
- Opptaksprosessen paa fs.sikt.no — mangler egen side for plasstildeling