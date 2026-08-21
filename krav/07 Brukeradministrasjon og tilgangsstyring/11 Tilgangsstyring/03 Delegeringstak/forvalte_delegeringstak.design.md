# Designnotater: Forvalte delegeringstak for applikasjoner

**Relaterte features:**
[`se_delegeringstak.feature`](./se_delegeringstak.feature) (BRU-TIL-DEL-001) og
[`endre_delegeringstak.feature`](./endre_delegeringstak.feature) (BRU-TIL-DEL-002).

Notatet er skrevet som utgangspunkt for en designdiskusjon. Begge features står som `@could @draft`:
kravene er ikke besluttet. Ett valg er likevel tatt på forhånd og presenteres som gitt — hvem som
kan endre et tak. Det står i eget avsnitt under.

## Hva et delegeringstak er

En Feide-applikasjon kan opptre i to roller. Den kan handle **som seg selv**, med tilganger tildelt
applikasjonen som subjekt — det er tilgangslisten BRU-APP-API-003 beskriver. Og den kan handle **på
vegne av en innlogget bruker**. Delegeringstaket gjelder bare det siste: det er den øvre grensen
for hvor mye av en brukers egen myndighet applikasjonen får bære.

Taket gir applikasjonen ingenting alene. En takrad som ikke møter en tilsvarende brukertilgang er
uten virkning, og en brukertilgang som ikke møter en takrad blir ikke formidlet. Håndhevelsen er et
snitt:

```
formidlet til bruker = tak(applikasjon) ∩ tilganger(bruker)
```

Snittet tas per (organisasjon, tilgang), i ett miljø, **etter** at implikasjoner er ekspandert på
begge sider (migrering 0011, videreført i 0019 og 0033). To egenskaper ved snittet er hele grunnen
til at kravene finnes:

1. **Det er stille.** En tilgang taket ikke bærer forsvinner uten feilmelding. Symptomet er at
   flaten svarer tomt — ikke at noe avvises.
2. **Det treffer bare brukere gjennom en applikasjon.** Den samme brukeren har tilgangen andre
   steder, så feilen ser ut som et problem med applikasjonen eller med grafen.

Erfaring har vist at dette er den vanligste årsaken til at en ny tilgang «ikke virker»: tilgangen
ble innført i katalogen, men ikke lagt inn i taket til applikasjonen den skulle brukes gjennom.
Regelen er derfor skrevet ned på tabellen selv (migrering 0043): *taket må følge tilgangskatalogen*.

### Grensen er ikke absolutt

To presiseringer som bør med i enhver visning, fordi de ellers gir feil forventning:

- **Tilganger som gjelder alle** legges til *etter* snittet. Taket begrenser brukerens egne
  tilganger, ikke alt applikasjonen kan vise.
- **Deaktivering av applikasjonen** undertrykker hele resultatet, uavhengig av taket. Brukerens
  egne tilganger berøres ikke.

## Utgangspunktet: modellen finnes, flaten gjør ikke

Tabellen for delegeringstak er en del av tilgangsmodellen fra første migrering (0003), og har vært
i produksjon siden. Formen:

| Del | Innhold |
|-----|---------|
| Nøkkel | applikasjon, tilgang, organisasjon, miljø — én rad per kombinasjon, med gyldighetsperiode |
| Temporalitet | Perioder kan ikke overlappe. Et tak trekkes tilbake ved å lukke perioden, aldri ved å slette raden |
| Sporing | Tidspunkt og aktør for både innlegging og avslutning |
| Avgrensning | Fremmednøkkelen peker på **Feide-applikasjon**, ikke på subjekt generelt |

Den siste raden er en viktig avgrensning for kravene: **bare applikasjoner som brukere logger inn i
har et delegeringstak.** Maskinbrukere og Maskinporten-klienter opptrer alltid som seg selv, og for
dem finnes taket ikke som begrep. Det er derfor visningen ikke skal dukke opp på disse
applikasjonene i det hele tatt — ikke som en tom liste.

Det som ikke finnes er forvaltningen. Ingen del av løsningen skriver til taket i dag: ingen
mutasjon, ingen synkronisering, ingen flate. Radene legges inn manuelt av databaseforvaltningen,
og konvergeringer gjøres som migreringer. Taket er samtidig driftsdata — hvilke
(organisasjon, miljø)-par en applikasjon skal dekke er en driftsbeslutning, ikke noe en migrering
kan vite. Det er den kombinasjonen som gjør status quo ustabil: en regel som må håndheves løpende,
uten et sted å håndheve den.

## Besluttet: hvem kan endre et tak

**Endring av et delegeringstak krever applikasjonsadministrator hos Sikt.** Dette er avgjort, og
features er skrevet under den forutsetningen.

Begrunnelsen er hvem endringen treffer. Et takinnslag navngir organisasjonen applikasjonen får
opptre innenfor — ikke organisasjonen som eier applikasjonen. En utvidelse gir altså en
applikasjon, ofte eid av en annen part, lov til å handle i en organisasjons navn. Resten av
applikasjonsforvaltningen er skopet slik at en administrator forvalter det som hører til sine egne
organisasjoner; her ville det samme skopet gjort utvidelsen til et valg for den som eier
applikasjonen eller for den som blir berørt, og ingen av de to er riktig part alene.

**Lesing forblir bredere.** Organisasjonen som har lånt ut myndighet skal kunne se det, uten å
kunne endre det. Dagens modell har allerede en egen leseregel med organisasjonsskop ved siden av
skriveregelen (migrering 0019), så beslutningen krever at skriveregelen strammes — ikke at lesingen
gjøres om. Det er verdt å merke seg fordi den motsatte antakelsen ville fjernet lesesynet til
organisasjonene i samme grep.

Konsekvensen for kravene er at BRU-TIL-DEL-001 og BRU-TIL-DEL-002 har ulike aktører: den første er
skrevet fra organisasjonens side, den andre fra Sikts.

## De tre alternativene

### (a) Forvaltningsflate — valgt retning

Taket får en eier i løsningen: et API for å lese og endre, og senere en flate. Lesing er
organisasjonsskopet, endring er gatet på applikasjonsadministrator hos Sikt. Endringer er
temporale og sporbare, og idempotente — å legge inn en delegering som allerede gjelder er ingen
endring.

*Hvorfor:* det er den eneste av de tre som gir regelen et sted å bo. Taket er driftsdata som endres
uavhengig av deployer, og et API gjør både utvidelsen og tilbaketrekkingen til en handling med
aktør, tidspunkt og bekreftelse i stedet for et manuelt innslag. Det gir dessuten
BRU-TIL-DEL-001-halvdelen gratis: når taket først er lesbart gjennom løsningen, kan flaten forklare
et avskåret snitt i stedet for å vise en tom liste.

*Kostnaden:* taket får en skriveflate, og skriveflater kan misbrukes. Det er derfor gatingen er
strammere enn mønsteret ellers, og derfor tilbaketrekking må være like lett som utvidelse.

### (b) Migrerings- og driftseid — status quo formalisert

Taket endres bare gjennom reviewet migrering. Regelen om at taket må følge katalogen håndheves som
prosess: den som innfører en tilgang har ansvar for takradene i samme endring.

*Argumentet for:* hver utvidelse får en review, og det finnes ingen skriveflate å misbruke.
Nullkostnad å beholde.

*Hvorfor den ikke velges:* migreringer kjører ved deploy, mens taket er driftsdata. En organisasjon
som senere skal dekkes av en applikasjon får ikke radene av seg selv, og en ny tilgang får ikke
radene av seg selv. Erfaringen med feilklassen er nettopp fra dette regimet — prosesskravet ble
ikke oppfylt fordi ingenting minnet noen på det. Alternativet er dessuten ikke gratis på lesesiden:
uten en flate er det fortsatt umulig for en organisasjon å se hva den har lånt ut, og umulig for
support å forklare et tomt svar uten databasetilgang.

### (c) Modellendring — taket enumererer bare de fingranede tilgangene

Taket slutter å nevne grovkornede, sammensatte tilganger og lister bare de fingranede
privilegiene. Ekspansjonen fra sammensatt til fingranet skjer utelukkende på brukersiden av
snittet.

*Argumentet for:* det er det eneste alternativet som gjør feilklassen strukturelt umulig for den
store gruppen tilganger. En ny sammensatt rolle trenger da ingen takrader i det hele tatt, og
vedlikeholdsflaten krymper til privilegiene.

*Hvorfor den ikke velges nå:* det er en semantikkendring i selve håndhevelsen, ikke en ny flate.
Snittet nuller i dag også de grovkornede kodene, og en visning som spør «hvilke tilganger har jeg
her» leser nettopp dem — så endringen berører mer enn autorisasjonen. Den forutsetter også at
skillet mellom sammensatt og fingranet er entydig i katalogen for alle tilganger, ikke bare de
kjente. Alternativet er ikke forkastet: det er det naturlige neste steget hvis forvaltningsflaten
viser at takradene for sammensatte tilganger aldri bærer noen egen beslutning. Det bør vurderes på
nytt når (a) har vært i bruk en stund.

De tre utelukker ikke hverandre helt: (a) og (c) kan kombineres, og (a) reduserer smerten ved å
utsette (c).

## Beslektede mekanismer med samme forvaltningshull

Delegeringstaket er ikke alene. Samme migrering som utvidet håndhevelsen (0013) la til tre andre
mekanismer, og alle tre har nøyaktig det samme hullet: modellen finnes og er i produksjon,
forvaltningen finnes ikke, og endringer skjer bare gjennom migrering. Spørsmålet over —
forvaltningsflate, migreringseid eller modellendring — er derfor ikke et spørsmål om taket alene.
De tre får ingen egne features her; poenget er at diskusjonen bør tas for hele settet på én gang.

Rekkefølgen i håndhevelsen er hele historien (0013, videreført i 0019 og 0033):

```
effektiv(bruker via applikasjon) = ( tak ∩ ( brukerroller ∪ gulv ) ∪ åpne roller ) MINUS nekt
```

Gulvet ligger **innenfor** taket, åpne roller **utenfor** det, og nekt trekkes fra **ytterst**.

| Mekanisme | Plass i håndhevelsen | Hvem en endring treffer | Skriveregel i dag | Flate |
|-----------|----------------------|--------------------------|-------------------|-------|
| Delegeringstak | Snittets ene side | Brukere i én organisasjon, gjennom én applikasjon | Organisasjonsskopet skriverett | Ingen |
| Gulv | Legges til brukersiden før snittet | Alle brukere, kjente og ukjente | Organisasjonsskopet skriverett — ingen ekstra gate | Ingen |
| Åpne roller | Legges til etter snittet | Alle kallere, brukere og applikasjoner | Eget privilegium — som ikke finnes i katalogen | Ingen |
| Nekt | Trekkes fra ytterst | Én bruker, i én organisasjon | Organisasjonsskopet skriverett — ingen ekstra gate | Ingen |

### Gulvet: minste tilgang alle brukere har

Gulvet er takets motpart. Det er et sett (organisasjon, tilgang, miljø) som gjelder **alle**
brukere, uten noen henvisning til hvem brukeren er — det finnes ingen brukerkolonne. En bruker
løsningen ikke kjenner ennå får gulvet ved første pålogging.

To egenskaper gjør endringer her tyngre enn de ser ut:

- **Gulvet er organisasjonsuavhengig.** En gulvrad ved én organisasjon gjelder alle brukere, ikke
  bare organisasjonens egne. Det er tilsiktet — en student fra ett lærested kan levere ved et annet
  hvis det andre lærestedet har lagt tilgangen i gulvet sitt — men det betyr at rekkevidden av en
  gulvendring ikke er avgrenset av hvem som er «våre» brukere.
- **Gulvet begrenses fortsatt av taket.** Det legges til på brukersiden *før* snittet, så en
  gulvtilgang formidles bare der applikasjonen også er delegert den. Taket er altså en reell
  bremsekloss på gulvet, i motsetning til på åpne roller.

Skriving er i dag skopet til organisasjonen med den samme skriveretten som resten av
brukeradministrasjonen (0013, strammet til (miljø, organisasjon) i 0019). Gulvet har altså **ingen
ekstra gate**, selv om en gulvendring treffer alle brukere på én gang og taket — som treffer én
applikasjon — nå foreslås gatet hos Sikt. Det er en asymmetri det er verdt å ta stilling til: hvis
begrunnelsen for Sikt-gatingen er hvem endringen treffer, peker den enda sterkere mot gulvet.

Ingenting i løsningen leser eller skriver gulvet utenfor databasemodulen.

### Åpne roller: data som er offentlige

En åpen rad legges til **alle** kalleres tilganger — både brukere og applikasjoner som opptrer som
seg selv — og legges til *etter* snittet, altså utenfor takets kontroll. Den ekspanderes transitivt
på samme måte som en tildeling, så å åpne en tilgang åpner også alt den impliserer. Bare nekt kan
overstyre den for en enkeltbruker.

En presisering, fordi formen inviterer til en feillesing: en åpen rad er **ikke** organisasjonsløs.
Den bærer organisasjon og miljø, og organisasjonen angir *hvem sine data* som er åpne — ikke hvem
som får lese dem. Åpenhet er derfor en beslutning hver organisasjon tar for seg, per miljø, men
virkningen er global.

Lesing er allerede global: hvem som har åpnet hva er synlig for alle innloggede, bevisst, fordi
åpenhet skal kunne etterprøves. Skriving krever et **eget** privilegium
(`REGISTRER_APEN_ROLLE`) framfor den ordinære skriveretten, nettopp fordi åpning omgår både taket og
brukerdimensjonen.

Men privilegiet har ingen operasjon å styre. Regelen har pekt på det siden 0013, mens katalograden
for privilegiet bare opprettes i eksempeldata-changesettet i samme migrering — i en base uten
eksempeldata finnes tilgangen ikke, og ingen kan ha den. Åpning er i praksis stengt for alle andre
enn databaseforvaltningen. Det gir to utganger, og dagens tilstand er ingen av dem:

1. **Bygg flaten.** Da er privilegiet tiltenkt bærer, og bør forfremmes til en ordentlig katalograd.
2. **Rydd privilegiet bort**, og si eksplisitt at åpning er en migreringsbeslutning.

Å la det stå som nå er den ene tilstanden som ikke bør bestå: en regel som peker på en tilgang som
ikke finnes ser ut som en gate, men er en dør ingen kan åpne.

### Nekt: tilbaketrekking som trumfer alt

Nekt trekkes fra ytterst og slår alt annet, åpne roller inkludert. Det er mekanismen som setter en
enkeltbruker **under** gulvet — for eksempel en bruker som ikke lenger skal kunne sende inn noe selv
om gulvet sier at alle kan.

Tre egenskaper hører med:

- **Nekt ekspanderer oppover.** Å nekte en lesetilgang fjerner også skrive- og administrasjons-
  tilgangene som impliserer den, så ingen sterkere tilgang kan gi tilbake det som er nektet. Motsatt
  vei går det aldri: å nekte skriving fjerner ikke lesing, så «ta bort skriv, behold les» er mulig.
- **Nekt gjelder bare brukere**, som en databasegaranti — samme mønster som at et tak bare kan
  gjelde en Feide-applikasjon. En applikasjons tilgang trekkes tilbake ved å avslutte dens egne
  tildelinger, ikke med nekt.
- **Nekt er alltid per konkret organisasjon.** Skal en bruker fratas noe i flere organisasjoner, er
  det én rad per organisasjon. Det finnes ingen «overalt»-form.

Skriveregelen er den samme organisasjonsskopede skriveretten som resten av brukeradministrasjonen,
uten ekstra gate. Hullene er to, og de peker i motsatte retninger:

- **Ingen flate for å ilegge eller oppheve.** Et nekt er den handlingen som må kunne skje raskest av
  alle fire — det er verktøyet når noe må stanses nå. I dag krever det databaseforvaltningen.
- **Ingen synlighet, verken for den nektede eller for administratoren.** En bruker som er satt under
  gulvet får ingen forklaring, og en administrator kan ikke se at det er et nekt som skjærer. Det er
  samme feilklasse som det stille snittet, men med motsatt fortegn: her er det en bevisst beslutning
  ingen kan se, framfor et hull ingen har tatt.

### Hva dette betyr for diskusjonen

Alle fire mekanismene har samme form — temporale perioder, miljødimensjon, sporet aktør — og samme
hull. De er derimot ikke like ofte i bruk, og det er sannsynligvis den viktigste forskjellen:

- **Taket** endres når en applikasjon eller tilgangskatalogen endres. Det er løpende drift, og det er
  derfor det er dette som brekker først.
- **Gulv og åpne roller** er sjeldne, tunge beslutninger med bred rekkevidde. De ligner mer på
  modellendringer enn på drift.
- **Nekt** er sjeldent, men når det trengs, trengs det med én gang. Det er den ene av de fire der
  friksjon er en risiko i seg selv.

Det taler for at svaret kan bli ulikt per mekanisme: (a) for taket, en formalisert (b) for gulv og
åpne roller, og for nekt en flate nettopp fordi tempoet er poenget. Men det bør være et valg, ikke
en følge av at ingen har spurt for de tre andre.

### Samling-skop: bør tak, gulv og nekt også kunne peke på en mengde?

Tildelinger har nettopp fått en form ingen av de fire mekanismene har: de kan uttrykkes mot en
**organisasjonssamling** — en navngitt mengde organisasjoner — i stedet for mot én organisasjon.
Semantikken eies av BRU-TIL-SAM-002 (#548): én rad virker i hver organisasjon som er aktivt medlem
av samlingen i miljøet, og virkningen følger medlemslisten videre, slik at en organisasjon som
meldes inn omfattes automatisk. Dynamikken er tilsiktet og besluttet — den er hele poenget med å
tildele mot en mengde.

Spørsmålet det reiser her er om de fire mekanismene bør få samme skop. Svaret er ikke likt for alle
fire, og skillet følger **retningen** på det som utvides automatisk ved en innmelding: er det nye
medlemmet **mottaker** av rekkevidde, eller er det **kilden** til det som blir tilgjengelig?

**Taket bør kunne peke på en mengde.** Et tak som gjelder «alle FS-læresteder» er nettopp det taket
til en applikasjon som betjener hele sektoren er. I dag må forvalteren utvide taket manuelt per
applikasjon × tilgang × organisasjon hver gang en organisasjon kommer til, og det manuelle
innslaget er en kjent kilde til feilklassen dette notatet handler om: brukere ved en ny
organisasjon møter en tom flate, uten at noen får vite hvorfor. Risikoprofilen er mild, av to
grunner. **Taket formidler ingen tilgang av seg selv** — organisasjonssiden må fortsatt ha tildelt
brukeren noe før noe formidles — og takskriving er alt foreslått sentralforvaltet, så
samlingsformen flytter ikke myndighet, bare arbeid. Én interaksjon bør likevel stå skrevet framfor
å bli oppdaget: gulvrollene til en nyinnmeldt organisasjon vil formidles gjennom applikasjonen
straks organisasjonen blir medlem, siden gulvet ligger innenfor taket. Det er samme dynamikk som
alt er besluttet tilsiktet for tildelinger.

**Nekt bør kunne peke på en mengde, og begrunnelsen er fail-safe.** I dag krever «steng brukeren ute
overalt» én rad per organisasjon — tungvint akkurat i den situasjonen der tempoet er poenget. Et
samling-skopet nekt utvides i **trygg retning** ved en innmelding: mer nektes, aldri mindre. Den
automatiske utvidelsen, som er det krevende ved samlingsformen for de andre mekanismene, er her en
sikkerhetsegenskap. Sammen med at nekt ekspanderer oppover gjennom rolleimplikasjon betyr det at én
rad effektivt kan stenge en hel rollefamilie i alle medlemsorganisasjonene.

**Gulvet bør ikke få samlingsform nå — og heller ikke åpne roller.** Her snur
konsekvensretningen. En gulvrad åpner organisasjonens **egne** data for alle brukere. Et
samling-skopet gulv ville derfor gulv-åpnet en nyinnmeldt organisasjons data i innmeldingsøyeblikket,
på grunnlag av et vedtak fattet før organisasjonen ble medlem, om dens egne data. For tildelinger og
tak er et nytt medlem **mottaker** av rekkevidde; for gulv og åpne roller er det **kilden**. Det er
en kvalitativt skarpere konsekvens, de to mekanismene er alt de mest omfattende av de fire, og det
finnes ikke noe påvist behov for formen. Organisasjonsskopet beholdes til et konkret behov er
formulert.

| Mekanisme | Hva et samling-skop ville gi | Retningen ved innmelding | Anbefaling |
|-----------|------------------------------|--------------------------|------------|
| Delegeringstak | Ett takinnslag for «alle læresteder», som følger medlemslisten | Nytt medlem er mottaker av rekkevidde | Ja |
| Nekt | Én rad stenger brukeren i hele mengden | Mer nektes, aldri mindre — trygg retning | Ja |
| Gulv | Én rad åpner mengdens egne data for alle brukere | Nytt medlem er kilden | Nei, ikke nå |
| Åpne roller | Én rad gjør mengdens egne data offentlige | Nytt medlem er kilden | Nei, ikke nå |

**Koblingen til forvaltningen av samlinger.** Rir også tak og nekt på samlinger, blir
medlemskapsforvaltningen ytterligere sikkerhetsbærende: en innmelding utøver da ikke bare stående
tildelinger, men flytter også tak og nekt for organisasjonen som meldes inn. Det skjerper
spørsmålet som allerede ligger i kravdiskusjonen om forvaltning av organisasjonssamlinger (#546) —
hvem som får endre en medlemsliste, og hva som må revalideres når den endres.

## Overordnet UI-mønster

Delegeringstaket hører på **detaljsiden for applikasjonen**, som en egen fane ved siden av
applikasjonens egne tilganger. To lister som ser like ut men betyr ulike ting er den største
forvekslingsfaren i hele denne kapabiliteten, så fanen må navngi forskjellen — ikke bare heten
«Tilganger» og «Delegeringstak», men en setning som sier at den ene gjelder applikasjonen selv og
den andre brukere gjennom den.

Miljø er et eksplisitt valg, som i applikasjonsoversikten. En takrad *er* per miljø, og «alle
miljøer» er derfor et sammendrag som må merkes som det.

## Komponenter og layout

**Takvisning (fane på detaljsiden):** tabell med kolonnene Tilgangskode, Organisasjon, Miljø,
Gyldig fra. Filtre på miljø og organisasjon, som i tilgangsfanen. Handlingene *Legg til delegering*
og *Avslutt delegering* vises bare for applikasjonsadministrator hos Sikt.

**Legg til delegering:** dialogboks med tilgang, organisasjon og miljø. Flere rader i samme
endring bør være mulig — takrader kommer sjelden én om gangen, fordi en applikasjon typisk skal
dekke det samme settet i flere organisasjoner.

**Historikk:** avsluttede delegeringer med start- og sluttidspunkt og aktør, bak et eget valg.
Vises som perioder per (tilgang, organisasjon, miljø), ikke som siste status — ellers går det
historikken er god for tapt.

**Effektiv formidlingsevne:** den viktigste visningen, og den som ikke har et sted i dag. Den skal
kunne svare: *hvilke av brukerens tilganger kommer gjennom denne applikasjonen, og hvilke stopper i
taket?* Hvor den hører — på applikasjonen, i «mine tilganger», eller begge — er åpent, se under.

## Interaksjonsmønstre

### Primærhandlinger
*Legg til delegering* og *Avslutt delegering* (begge bare for applikasjonsadministrator hos Sikt).

### Sekundære handlinger
*Vis historikk*, *Vis taket på et gitt tidspunkt*, filtrering på miljø og organisasjon.

### Manglende rettighet skjuler handlingen
Uten rettigheten vises ingen av handlingene — skjult, ikke deaktivert, etter prosjektmønsteret.
Lesevisningen står, og det er poenget: en administrator skal kunne se hva som er lånt ut selv om
hun ikke kan endre det.

### Bekreftelse på inngripende handlinger
Både utvidelse og tilbaketrekking bør ha et bekreftelsessteg som sier hva endringen treffer:
hvilken organisasjon, hvilken tilgang, hvilket miljø. En utvidelse fordi den øker myndighet, en
tilbaketrekking fordi den tar formidlingsevne fra brukere som er i arbeid.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Applikasjon uten delegeringstak (maskinbruker, Maskinporten) | Ingen fane. Ikke en tom liste |
| Feide-applikasjon med tomt tak | «Applikasjonen kan ikke formidle noen brukertilganger» — en forklart tilstand, ikke en tom tabell |
| Tak uten innslag i valgt miljø | «Ingen delegeringer i dette miljøet» — mengden er per miljø |
| Avskåret snitt | Brukerens tilgang vises som ikke formidlet, med taket oppgitt som årsak |
| Laster | Skjelett i tabellen; miljøvalget låst mens listen hentes |
| Endring avvist av rettighet | Melding som sier at endring krever applikasjonsadministrator hos Sikt |
| Endring uten virkning (idempotent) | Bekreftelse som sier at delegeringen allerede gjaldt, uten ny historikkoppføring |
| Suksess | Toast, og listen oppdatert i valgt miljø |

## Designpoenget: leseskopet følger den berørte organisasjonen

Det er lett å lese taket som en egenskap ved applikasjonen, og dermed som noe eierorganisasjonen
forvalter. Modellen sier noe annet: hver rad navngir organisasjonen applikasjonen får opptre
innenfor, og det er den organisasjonen som har lånt ut myndighet. Leseskopet følger derfor den
berørte organisasjonen, ikke eieren.

Praktisk følge: en administrator ved et lærested kan se hvilke applikasjoner som kan opptre på
vegne av lærestedets brukere, og med hvilke tilganger — også når applikasjonen tilhører en annen
part. Det er en tilsiktet åpenhet. Motsatt ser eieren av en applikasjon bare de organisasjonene hun
selv administrerer, og altså ikke nødvendigvis hele taket til sin egen applikasjon. Det er den
uvante halvdelen av valget, og bør bekreftes i diskusjonen.

## Designpoenget: temporal historikk er et løfte vi kan holde

Taket er temporalt modellert med samme form som resten av tilgangsmodellen: en delegering avsluttes
ved at perioden lukkes, ikke ved at raden slettes, og perioder for samme kombinasjon kan ikke
overlappe. Tre spørsmål besvares dermed uten ny modellering:

- **Når fikk applikasjonen lov til dette, og hvem ga den lov?**
- **Hva kunne applikasjonen formidle på et gitt tidspunkt?** — og dermed: kunne den ha gjort det
  som skjedde?
- **Når ble lovet trukket tilbake, og av hvem?**

Gjeninnføring gir en ny periode ved siden av den gamle. For et tak er dette mer enn en
bekvemmelighet: spørsmålet «hadde denne applikasjonen lov til å gjøre det da» er et
sikkerhetsspørsmål, og svaret skal ikke avhenge av at ingen har ryddet.

## Avklarte valg

- Endring gates på applikasjonsadministrator hos Sikt; lesing forblir organisasjonsskopet.
- Bare applikasjoner brukere logger inn i har et delegeringstak — for øvrige vises ingen visning.
- Tilbaketrekking avslutter en periode; ingenting slettes.
- Historikk vises som perioder, ikke som siste status.
- Taket og applikasjonens egne tilganger er to lister, navngitt slik at de ikke forveksles.
- Idempotens: å legge inn en delegering som allerede gjelder er ingen endring, og gir ingen ny
  historikkoppføring.
- Miljø velges eksplisitt; «alle miljøer» er et sammendrag, ikke en mengde som finnes.

## Åpne designspørsmål

- [ ] Skal taket for Sikts egen administrasjonsflate følge tilgangskatalogen automatisk, slik at en
      ny administrasjonstilgang virker med én gang, eller forvaltes manuelt som alle andre tak?
      Automatikk fjerner den vanligste feilklassen for den ene applikasjonen den treffer oftest,
      men gjør samtidig taket til noe som utvides uten en beslutning per gang — og det er nettopp
      beslutningen per gang som er sikkerhetsverdien i (a).
- [ ] Hvor stort skal GUI-omfanget være i første omgang: bare lesevisning på detaljsiden, med
      endring gjennom API-et, eller lese- og endringsflate samtidig? Lesevisningen er den som
      løser feilsøkingsproblemet; endringsflaten er den som fjerner det manuelle innslaget.
- [ ] Hvor hører visningen av effektiv formidlingsevne — på applikasjonen, i «mine tilganger», eller
      begge? Spørsmålet er hvem som oppdager et hull først: den som forvalter applikasjonen, eller
      brukeren som mangler noe.
- [ ] Skal en organisasjon kunne be om en utvidelse den ikke selv kan utføre, som en forespørsel i
      løsningen, eller er forespørselen en supportoppgave utenfor? Gatingen gjør at noen må spørre
      noen andre, og det bør være et sted for det.
- [ ] Bør de fire mekanismene — tak, gulv, åpne roller og nekt — få samme forvaltningsmodell, eller
      er de forskjellige nok til å behandles ulikt? Gulv og nekt er sjeldne sikkerhetsbeslutninger,
      taket er løpende drift, og nekt er den ene der friksjon er en risiko i seg selv.
- [ ] Skal tak og nekt kunne uttrykkes mot en organisasjonssamling, slik tildelinger nå kan
      (BRU-TIL-SAM-002)? Retningsforskjellen taler for ja for tak og nekt, og nei for gulv og
      åpne roller — se avsnittet om samling-skop.
