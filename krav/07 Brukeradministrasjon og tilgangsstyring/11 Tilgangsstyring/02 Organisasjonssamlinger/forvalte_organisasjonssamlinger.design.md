# Designnotater: Forvalte organisasjonssamlinger

**Relaterte features:**
[`forvalte_organisasjonssamlinger.feature`](./forvalte_organisasjonssamlinger.feature) (BRU-TIL-SAM-001) og
[`tildele_tilgang_via_organisasjonssamling.feature`](./tildele_tilgang_via_organisasjonssamling.feature) (BRU-TIL-SAM-002).

Notatet er skrevet som utgangspunkt for en designdiskusjon. Begge features står som `@could @draft`:
kravene er ikke besluttet, og flere av valgene under er åpne.

## Utgangspunktet: modellen finnes, flaten gjør ikke

Datamodellen for organisasjonssamlinger er merget og ligger i produksjonsløypa (fs-plattform
MR 5262). Den består av tre deler:

| Del | Hva den holder | Temporal |
|-----|----------------|----------|
| Samlingskatalogen | Navn (unikt, og samtidig forretningsnøkkelen), beskrivelse, et generert løpenummer, og spor av hvem som opprettet og endret raden. Ingen eierorganisasjon, ingen miljødimensjon. | Nei |
| Medlemskapene | Hvilke organisasjoner som er medlem av en samling, **i hvilket miljø** og i hvilke perioder. | Ja |
| Tildelingene mot samling | Hvilket subjekt som har fått hvilken rolle mot en samling, i hvilket miljø og i hvilke perioder. | Ja |

Autorisasjonen leser allerede alle tre: en aktiv tildeling mot en samling utvides til de
organisasjonene som er aktive medlemmer av samlingen **i det samme miljøet**, side om side med de
direkte tildelingene, og resultatet rolleekspanderes og dedupliseres. Utvidelsen krysser aldri
miljø.

Det som ikke finnes er forvaltningen. I dag kan bare databaseforvaltningen skrive samlinger,
medlemskap og tildelinger mot samling — standardposisjonen er lukket, fordi det å skrive her er å
dele ut tilgang bredt. Én samling er opprettet, «FS-læresteder», med 37 medlemsorganisasjoner
(36 læresteder og Sikt) i produksjonsmiljøet. Det er ikke opprettet noen tildeling mot den, så
modellen gir foreløpig ingen tilgang gjennom samlinger.

Katalogen og medlemskapene er lesbare for alle som er innlogget — hvilke samlinger som finnes og
hvilke organisasjoner de består av trenger ingen skjerming. Tildelingene er ikke lesbare på samme
måte: hvem som har fått tilgang bredt gjennom en samling er skjermet. Det er den forskjellen
scenarioet «Samlingen er synlig uten forvaltningsrettighet» uttrykker, og den bør UI-et speile:
katalog og medlemsliste er åpen lesning, tildelingslisten er det ikke.

## Fem kapabilitetsområder

1. **Katalog** — liste og detaljside: navn, beskrivelse, antall medlemmer, medlemsliste per miljø.
2. **Medlemskap** — melde en organisasjon inn og ut, per miljø, med historikk.
3. **Tildeling via samling** — tildele og trekke tilbake en tilgang mot en samling i ett miljø.
4. **Proveniens og synlighet** — det skal fremgå hvorfor en bruker har en tilgang. Åpent, se under.
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
  Skjermet, jf. avsnittet over.

## Interaksjonsmønstre

### Primærhandlinger
*Opprett samling* (listesiden), *Legg til medlem* og *Tildel tilgang mot samling* (detaljsiden).

### Sekundære handlinger
*Endre navn/beskrivelse*, *Fjern medlem*, *Fjern tildeling*, *Vis historikk*.

### Manglende rettighet skjuler handlingen
Uten den globale forvaltningsrettigheten vises ingen av handlingene — ikke som deaktiverte knapper,
men skjult. Dette følger prosjektmønsteret for manglende tilgang.

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

## Åpent spørsmål: proveniens

En bruker kan ha en tilgang i en organisasjon av tre grunner:

1. tilgangen er tildelt direkte på organisasjonen,
2. en sterkere tilgang brukeren har omfatter den, eller
3. organisasjonen er medlem av en samling det er tildelt en tilgang mot.

Visningen av mine tilganger skiller i dag ikke på dette. Spørsmålet er hvordan 3 skal uttrykkes:

- **Egen tilknytningsverdi** for samling — ærligst, men utvider en verdimengde flere flater leser.
- **Undertype av «arvet»** — mindre inngripende, men slår sammen to ganske ulike årsaker: at en
  rolle omfatter en annen, og at en organisasjon er medlem av en mengde.
- **Ikke skille** — enklest, men da kan en administrator se en tilgang uten å kunne forklare eller
  fjerne den, fordi den ikke ligger på organisasjonen den vises på.

Valget henger sammen med hva flaten skal tilby fra visningen: en samlingsderivert tilgang kan ikke
trekkes tilbake på organisasjonen den vises på — den fjernes ved å fjerne tildelingen mot
samlingen, eller ved å melde organisasjonen ut. Det bør ikke kunne forveksles med en direkte
tildeling man kan fjerne der og da.

Spørsmålet er ikke løst her. Scenarioene som avhenger av svaret er merket `@openquestion` i
[`tildele_tilgang_via_organisasjonssamling.feature`](./tildele_tilgang_via_organisasjonssamling.feature).

## Ikke-funksjonelt: skalavakt

Utvidelsen fra samling til medlemmer skjer i autorisasjonsoppslaget, altså i en sti som treffes ved
pålogging og ved tilgangsvurderinger. Kostnaden vokser med antall medlemmer.

Teamet målte 2026-08-17 at oppslagene holder seg innenfor rammene for en samling med 500 medlemmer,
og at knekkpunktet ligger et sted mellom 500 og 5 000 medlemmer. Målingen sier altså at 500 er
trygt og at 5 000 ikke er det — ikke hvor grensen går.

Kravet er derfor formulert som en vakt, ikke som et tak: **samlinger med over 500 medlemmer skal
måles før de tas i bruk.** Det er en grense satt der kunnskapen slutter, og den bør flyttes når
noen måler videre. Til sammenligning har den eneste samlingen som finnes i dag 37 medlemmer, så
grensen er ikke i veien for noe kjent behov.

Åpent: om 500 skal være en hard grense i flaten eller et varsel forvalteren kan gå videre fra.

## Avklarte valg

- Forvaltning gates på en global rettighet, ikke på organisasjonsnivå (følger av modellen).
- Miljø velges eksplisitt på detaljsiden; det finnes ikke et «alle miljøer»-syn over medlemskap.
- Katalog og medlemsliste er åpen lesning; tildelinger mot samling er skjermet.
- Historikk vises som perioder, ikke som siste status.

## Åpne designspørsmål

- [ ] Hva heter den globale forvaltningsrettigheten, og hvilken rolle i forretningsrollesettet
      bærer den?
- [ ] Hvordan skal proveniens vises i mine tilganger — egen verdi, undertype av arvet, eller ikke
      skilles?
- [ ] Er 500 medlemmer en hard grense i flaten, eller et varsel?
- [ ] Skal tildeling mot samling gjelde både brukere og applikasjoner?
- [ ] Skal delegering til en applikasjon senere kunne uttrykkes mot en samling?
- [ ] Skal en samling kunne avvikles, og hva skjer i så fall med tildelingene mot den?
- [ ] Hører forvaltningen i FS Admin, eller i en egen flate for Sikt-interne oppgaver?
