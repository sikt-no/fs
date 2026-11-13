# Designnotater: Forvalte organisasjonssamlinger

**Relatert feature:**
[`forvalte_organisasjonssamlinger.feature`](./forvalte_organisasjonssamlinger.feature) (BRU-TIL-SAM-001).

Notatet er skrevet som utgangspunkt for en designdiskusjon. Featuren står som `@could @draft`:
kravet er ikke besluttet, og flere av valgene under er åpne.

Å tildele en tilgang mot en samling er skilt ut i BRU-TIL-SAM-002,
`tildele_tilgang_mot_organisasjonssamling.feature` (sikt-no/fs#548). Den delen er besluttet, står
som `@must @planned`, og har et eget designnotat. Utkastets egen fil for tildeling er fjernet fra
denne PR-en, så ID-en BRU-TIL-SAM-002 bare finnes ett sted.

## Status 13.11.2026

Sjekket mot tilgangsstyringen på fs-plattform main og fs-admin main.

| Område | Finnes i dag |
|---|---|
| Katalog og medlemsliste | Kan leses i API-et av alle innloggede: `Query.organisasjonssamlinger`, sortert på navn, og `medlemskap` med filter på miljø, organisasjon, aktive og tidspunkt. FS Admin har ingen side for samlinger. |
| Opprette og endre samlinger, melde inn og ut | Finnes ikke. Databasen har bare leseregler for katalogen og medlemskapene, og API-et har ingen handlinger for dem. Bare databaseforvaltningen kan skrive dem, gjennom migreringer. |
| Global forvaltningsrettighet | Finnes ikke. Ingen rolle gir den. |
| Tildeling mot samling | Bygget i API-et for applikasjoner, med full dekning i stedet for den globale rettigheten. Se BRU-TIL-SAM-002. |
| Proveniens i listene | Tilgangslisten på applikasjonen, rollelistene for personbrukere og siden for en rolle viser en tilgang gitt gjennom en samling med «Via samling». Se avsnittet om proveniens. |
| Skalavakt | Håndheves ikke, verken i API-et eller i databasen. |

## Utgangspunktet: modellen finnes, flaten gjør ikke

Datamodellen for organisasjonssamlinger er merget og i produksjon (fs-plattform MR 5262,
migrering 0029). Den består av tre deler:

| Del | Hva den holder | Temporal |
|-----|----------------|----------|
| Samlingskatalogen | Navn (unikt, og samtidig forretningsnøkkelen), beskrivelse, et generert løpenummer, og spor av hvem som opprettet og endret raden. Ingen eierorganisasjon, ingen miljødimensjon. | Nei |
| Medlemskapene | Hvilke organisasjoner som er medlem av en samling, **i hvilket miljø** og i hvilke perioder. | Ja |
| Tildelingene mot samling | Hvilket subjekt som har fått hvilken rolle mot en samling, i hvilket miljø og i hvilke perioder. | Ja |

Autorisasjonen leser allerede alle tre: en aktiv tildeling mot en samling utvides til de
organisasjonene som er aktive medlemmer av samlingen **i det samme miljøet**, side om side med de
direkte tildelingene, og resultatet rolleekspanderes og dedupliseres. Utvidelsen krysser aldri
miljø.

Det som ikke finnes er forvaltningen. I dag kan bare databaseforvaltningen skrive samlinger og
medlemskap. Standardposisjonen er lukket, fordi det å skrive her er å dele ut tilgang bredt.
Tildelinger mot en samling kan siden migrering 0045 gis til applikasjoner gjennom API-et, av den
som har rettighet til å tildele i hver medlemsorganisasjon (BRU-TIL-SAM-002). Migrering 0029
oppretter samlingen «FS-læresteder» og melder inn 37 organisasjoner (36 læresteder og Sikt) i
produksjonsmiljøet. Hvilke tildelinger som er gitt mot den i produksjon, er ikke sjekket her.

Delegeringstaket til en Feide-applikasjon har fått en egen samlingsform (migrering 0080), som
leses i applikasjonens delegeringstak. Den kan heller ikke skrives fra API-et.

Katalogen og medlemskapene er lesbare for alle som er innlogget — hvilke samlinger som finnes og
hvilke organisasjoner de består av trenger ingen skjerming. Tildelingene er ikke lesbare på samme
måte: hvem som har fått tilgang bredt gjennom en samling er skjermet. Det er den forskjellen
scenarioet «Samlingen er synlig uten forvaltningsrettighet» uttrykker, og den bør UI-et speile:
katalog og medlemsliste er åpen lesning, tildelingslisten er det ikke.

## Fem kapabilitetsområder

1. **Katalog** — liste og detaljside: navn, beskrivelse, antall medlemmer, medlemsliste per miljø.
2. **Medlemskap** — melde en organisasjon inn og ut, per miljø, med historikk.
3. **Tildeling mot samling** — tildele og trekke tilbake en tilgang mot en samling i ett miljø.
   Skilt ut i BRU-TIL-SAM-002 (#548), og bygget i API-et for applikasjoner.
4. **Proveniens og synlighet** — det skal fremgå hvorfor en bruker har en tilgang. Avklart for
   listene i FS Admin, åpent for visningen av mine tilganger. Se under.
5. **Skalavakt** — samlinger over 500 medlemmer krever ytelsesmåling først. Se under.

## Overordnet UI-mønster

En **listeside** over samlinger, og en **detaljside** per samling. Mønsteret følger
applikasjonsoversikten: `ListPageLayout` med handlinger i `ActionButtons`-slot, og opprettelse i en
**dialogboks (modal)** med feltene navn og beskrivelse. Detaljsiden har medlemslisten som
hovedinnhold, med en egen seksjon for tildelinger.

Miljø er ikke et filter man kan la stå tomt her, slik det er i applikasjonsoversikten: både
medlemskap og tildeling *er* per miljø, og et «alle miljøer»-standardvalg ville vist en mengde som
ikke finnes. Detaljsiden bør derfor ha et eksplisitt valgt miljø, og gjøre valget synlig — antall
medlemmer betyr ingenting uten det.

## Komponenter og layout

**Listeside:** tabell med kolonnene Navn, Beskrivelse, Antall medlemmer. Sortert på navn stigende.
Knappen *Opprett samling* vises bare for forvalter med den globale rettigheten.

**Detaljside:**

- Toppfelt: navn, beskrivelse, og en tydelig markering av at samlingen ikke tilhører en
  organisasjon. Miljøvelger.
- Medlemsliste: organisasjonskode og navn, tidspunkt for innmelding, hvem som meldte inn. Handling
  *Fjern fra samling* per rad, og *Legg til medlem* over listen — begge bare for forvalter.
- Historikkvisning: avsluttede medlemskap med start- og sluttidspunkt, og hvem som gjorde hva. Kan
  ligge bak en fane eller et «vis historikk»-valg.
- Tildelingsseksjon: hvilke tilganger som er tildelt mot samlingen, i hvilket miljø, til hvem.
  Skjermet, jf. avsnittet over. Reglene for den står i BRU-TIL-SAM-002. På applikasjonens side
  har FS Admin valgt rader i den vanlige tilgangslisten, ikke en egen seksjon.

## Interaksjonsmønstre

### Primærhandlinger
*Opprett samling* (listesiden), *Legg til medlem* og *Tildel tilgang mot samling* (detaljsiden).

### Sekundære handlinger
*Endre navn/beskrivelse*, *Fjern medlem*, *Fjern tildeling*, *Vis historikk*.

### Manglende rettighet skjuler handlingen
Uten den globale forvaltningsrettigheten vises ingen av handlingene for samlingen og medlemskapene
— ikke som deaktiverte knapper, men skjult. Dette følger prosjektmønsteret for manglende tilgang.
*Tildel tilgang mot samling* er gatet på noe annet: rettigheten til å tildele i hver
medlemsorganisasjon (BRU-TIL-SAM-002).

### Bekreftelse på inngripende handlinger
Å fjerne et medlem eller en tildeling tar tilgang fra virkelige brukere i virkelige organisasjoner.
Begge bør ha et bekreftelsessteg som sier hvor mange organisasjoner og hvilke tilganger endringen
treffer, framfor en ren ja/nei-dialog.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Tom katalog | Forklaring av hva en samling er, og *Opprett samling* for forvalter |
| Samling uten medlemmer i valgt miljø | «Ingen medlemmer i dette miljøet» — ikke tolkes som en tom samling; mengden er per miljø |
| Laster | Skjelett i tabellen; miljøvalget er låst mens medlemslisten hentes |
| Feil (navn i bruk) | Feilmelding ved navnefeltet i dialogen |
| Feil (navn mangler) | Feltvalidering ved innsending |
| Nær skalagrensen | Varsel i medlemslisten når samlingen nærmer seg 500 medlemmer |
| Suksess | Toast, og medlemslisten oppdatert i valgt miljø |

## Designpoenget: samlinger har ingen eier

Resten av tilgangsstyringen er skopet: en rettighet gis for en organisasjon, en rolle og et miljø,
og en administrator forvalter det som hører til organisasjonene sine. En samling bryter med det.
Den går på tvers av organisasjoner og har ingen eierorganisasjon i modellen, så det finnes ingen
organisasjon å skope forvaltningsrettigheten til. Konsekvensen er at forvaltning av samlinger må
gates på en **global** rettighet, på Sikt-nivå.

Det er et bevisst avvik fra mønsteret, ikke et hull, og det har en praktisk følge som bør sies
høyt: en administrator ved et lærested kan ikke melde sitt eget lærested inn i en samling, selv om
lærestedet er det som blir medlem. Innmelding gir tilgang til data i *andre* organisasjoner til den
som er tildelt en rolle mot samlingen, og er derfor ikke lærestedets eget valg.

Rollen som bærer denne rettigheten finnes ikke i dag. Den hører hjemme i forretningsrollesettet som
er under arbeid, og bør ikke navngis her før det settet er avklart. Inntil da står features med
formuleringen «global forvaltningsrettighet for organisasjonssamlinger».

## Designpoenget: temporal historikk er et løfte vi kan holde

Både medlemskap og tildeling er temporalt modellert: et medlemskap avsluttes ved å lukke perioden
sin, ikke ved å slettes, og det samme gjelder en tildeling. Det gir tre spørsmål gratis, som
kravene derfor kan love:

- **Når ble organisasjonen medlem, og hvem meldte den inn?**
- **Hvilke organisasjoner besto samlingen av på et gitt tidspunkt?** — og dermed: hvem hadde
  tilgang gjennom samlingen da.
- **Når ble en organisasjon meldt ut, og av hvem?**

Gjeninnmelding gir en ny periode ved siden av den gamle, ikke en overskriving. UI-et bør vise dette
som en tidslinje per organisasjon framfor én rad med siste status — ellers går nettopp det
historikken er god for tapt.

## Proveniens: avklart i listene, åpent i mine tilganger

En bruker kan ha en tilgang i en organisasjon av tre grunner:

1. tilgangen er tildelt direkte på organisasjonen,
2. en sterkere tilgang brukeren har omfatter den, eller
3. organisasjonen er medlem av en samling det er tildelt en tilgang mot.

**AVKLART 13.11.2026 (fra implementasjonen) for listene i FS Admin:** samling er en egen
tilknytningsverdi ved siden av «direkte» og «arvet» (`Tilknytning.SAMLING`). Tilgangslisten på
applikasjonen, rollelistene for personbrukere og siden for en rolle viser raden med «Via samling» og
navnet på samlingen. Raden kan ikke fjernes for én organisasjon, og API-et avviser det
(`SamlingstildelingKanIkkeFjernes`). Har tilgangen flere kilder, står den første av direkte,
samling og arvet. Se BRU-TIL-SAM-002 og BRU-PER-ROL-001/-002.

Visningen av mine tilganger skiller fortsatt ikke på dette. Der er spørsmålet åpent, og
alternativene var:

- **Egen tilknytningsverdi** for samling — ærligst, men utvider en verdimengde flere flater leser.
- **Undertype av «arvet»** — mindre inngripende, men slår sammen to ganske ulike årsaker: at en
  rolle omfatter en annen, og at en organisasjon er medlem av en mengde.
- **Ikke skille** — enklest, men da kan en administrator se en tilgang uten å kunne forklare eller
  fjerne den, fordi den ikke ligger på organisasjonen den vises på.

Valget henger sammen med hva flaten skal tilby fra visningen: en samlingsderivert tilgang kan ikke
trekkes tilbake på organisasjonen den vises på — den fjernes ved å fjerne tildelingen mot
samlingen, eller ved å melde organisasjonen ut. Det bør ikke kunne forveksles med en direkte
tildeling man kan fjerne der og da.

For listene i FS Admin er dette løst slik: tilgangen merkes «Via samling» og kan ikke fjernes der.
For mine tilganger er spørsmålet ikke løst. Det henger sammen med om personer skal kunne få en
tilgang mot en samling, som er et åpent spørsmål i BRU-TIL-SAM-002. Scenarioene om mine tilganger
og om rollenekt sto i utkastets fil for tildeling, som er fjernet, og er tatt med som åpent
spørsmål i BRU-TIL-SAM-002.

## Ikke-funksjonelt: skalavakt

Utvidelsen fra samling til medlemmer skjer i autorisasjonsoppslaget, altså i en sti som treffes ved
pålogging og ved tilgangsvurderinger. Kostnaden vokser med antall medlemmer.

Teamet målte 2026-08-17 at oppslagene holder seg innenfor rammene for en samling med 500 medlemmer,
og at knekkpunktet ligger et sted mellom 500 og 5 000 medlemmer. Målingen sier altså at 500 er
trygt og at 5 000 ikke er det — ikke hvor grensen går.

Kravet er derfor formulert som en vakt, ikke som et tak: **samlinger med over 500 medlemmer skal
måles før de tas i bruk.** Det er en grense satt der kunnskapen slutter, og den bør flyttes når
noen måler videre. Til sammenligning melder migreringen som oppretter «FS-læresteder», inn 37
organisasjoner i produksjon, så grensen er ikke i veien for noe kjent behov.

Grensen håndheves ikke i dag, verken av tildelingen mot samlingen i API-et eller i databasen.

Åpent: om 500 skal være en hard grense i flaten eller et varsel forvalteren kan gå videre fra.

## Revalidering ved innmelding (fra BRU-TIL-SAM-002)

Dekningskravet for tildeling mot en samling vurderes når tildelingen gis. Meldes en organisasjon
inn i en samling som alt har tildelinger, utvides tildelingene til den nye organisasjonen uten at
dekningskravet ser det. Det som kan fange det, er en revalidering i medlemskapsflaten (avvis en
innmelding som ville utvidet en tildeling utover innmelderens egen rett) eller en varsling. Det er
en av grunnene til at forvaltningen av medlemskap er strengere gatet enn tildelingen.

## Avklarte valg

- Forvaltning gates på en global rettighet, ikke på organisasjonsnivå (følger av modellen).
- Miljø velges eksplisitt på detaljsiden; det finnes ikke et «alle miljøer»-syn over medlemskap.
- Katalog og medlemsliste er åpen lesning; tildelinger mot samling er skjermet.
- Historikk vises som perioder, ikke som siste status.
- AVKLART 13.11.2026 (fra implementasjonen): navnet er obligatorisk og unikt, og beskrivelsen er
  valgfri (datamodellen).
- AVKLART 13.11.2026 (fra implementasjonen): tildeling mot samling krever ikke den globale
  rettigheten, men rettighet til å tildele i hver medlemsorganisasjon (BRU-TIL-SAM-002).
- AVKLART 13.11.2026 (fra implementasjonen): i listene i FS Admin er samling en egen tilknytning,
  «Via samling», og en slik tilgang kan ikke fjernes for én organisasjon.

## Åpne designspørsmål

- [ ] Hva heter den globale forvaltningsrettigheten, og hvilken rolle i forretningsrollesettet
      bærer den?
- [ ] Hvordan skal proveniens vises i mine tilganger — egen verdi, undertype av arvet, eller ikke
      skilles? Listene i FS Admin har valgt egen verdi.
- [ ] Er 500 medlemmer en hard grense i flaten, eller et varsel?
- [ ] Skal en innmelding revalideres mot innmelderens egen tildelingsrett, eller varsles?
- [ ] Skal en samling kunne avvikles, og hva skjer i så fall med tildelingene mot den?
- [ ] Hører forvaltningen i FS Admin, eller i en egen flate for Sikt-interne oppgaver?

Spørsmålene om brukere som mottaker av en tildeling mot samling, og om delegeringstak mot en
samling, er flyttet til BRU-TIL-SAM-002.
