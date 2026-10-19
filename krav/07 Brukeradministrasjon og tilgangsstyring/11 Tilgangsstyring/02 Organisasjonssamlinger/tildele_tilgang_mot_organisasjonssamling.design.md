# Designnotat: Tildele tilgang mot en organisasjonssamling

**Relatert feature:**
[`tildele_tilgang_mot_organisasjonssamling.feature`](./tildele_tilgang_mot_organisasjonssamling.feature)
(BRU-TIL-SAM-002).

Til forskjell fra forvaltningen av samlingene selv (BRU-TIL-SAM-001, som fortsatt er en
designdiskusjon) er denne delen besluttet og under bygging. Notatet forklarer de to valgene som
bærer kravet: hvordan tildelingen er gatet, og hvorfor kravet står uavhengig av hvordan
samlingene forvaltes.

## Utgangspunktet: mengden finnes, skriveflaten er den nye delen

Datamodellen for organisasjonssamlinger er i produksjonsløypa (migrering 0029): katalogen over
samlinger, temporale medlemskap per miljø, og temporale tildelinger mot en samling.
Autorisasjonen utvider allerede en aktiv tildeling mot en samling til de organisasjonene som er
aktive medlemmer **i det samme miljøet**, side om side med de direkte tildelingene, og resultatet
rolleekspanderes og dedupliseres. Utvidelsen krysser aldri miljø.

Det som manglet var skriveflaten: tildelingstabellen var lukket for alt annet enn
databaseforvaltningen. Migrering 0045 åpner **én** av de tre flatene — å gi og trekke tilbake en
tilgang mot en samling som alt finnes. Katalogen og medlemskapene er like lukkede som før, og
hvem som skal få forvalte dem er fortsatt BRU-TIL-SAM-001s spørsmål.

Mottakeren er en **applikasjon**. Det er applikasjonsadministratorens flyt, den samme som
BRU-APP-API-007 og BRU-APP-API-008 beskriver for én organisasjon, bare rettet mot en mengde.
Brukere som mottaker er ikke tatt med: modellen skiller ikke, men behovet er bare kjent for
applikasjoner, og en flate vi ikke vet formen på er lettere å legge til enn å ta bort.

## Gatingen: full dekning, ikke delvis

Rettigheten er **den samme som for å tildele mot én organisasjon** — tildelingsretten per
(organisasjon, miljø), `BRUKERADMIN_TILDELING_SKRIV`. Ingen ny rollekode, ingen egen
samlingsrolle. Å tildele mot en mengde er ikke en annen handling enn å tildele mot et medlem av
den.

Kravet er at rettigheten må finnes i miljøet for **hver** organisasjon som er aktivt medlem av
samlingen der. Begrunnelsen er anti-eskalering:

- Én tildeling mot samlingen gir tilgangen i hver aktive medlemsorganisasjon. Holdt det å ha
  rettigheten i **én** av dem, kunne en administrator ved ett lærested gitt en applikasjon
  tilgang ved alle de andre ved å gå gjennom en samling lærestedet er medlem av. Rekkevidden av
  det man skriver må ligge innenfor rekkevidden av det man har rett til.
- Formen gir en administrator myndighet over nøyaktig de samlingene hen alt har myndighet over
  hver enkelt medlemsorganisasjon i — ikke mer, ikke mindre.

**Den tomme mengden er et eget ledd.** «Ingen medlemsorganisasjon utenfor rettigheten min» er
trivielt sant for en samling uten aktive medlemmer i miljøet, og uten et tillegg ville enhver
innlogget kunne skrevet en tildeling mot en slik samling. Regelen krever derfor også at kalleren
har tildelingsrett et sted i miljøet, altså er en administrator med tildelingsmyndighet i det
hele tatt. En tildeling mot en tom samling har ingen virkning før organisasjoner meldes inn.

**Alternativet er avvist.** Å gate tildeling mot samling på et globalt, Sikt-nivå privilegium —
slik forvaltningen av samlinger må gates, siden en samling ikke har noen eierorganisasjon å skope
til — ville gjort tildeling mot samling til et Sikt-anliggende. Bestillingen er at
applikasjonsadministratorer skal kunne bruke samlinger, og dekningskravet er det som gjør det
forsvarlig uten å flytte handlingen til Sikt.

## Dekningen vurderes ved tildelingstidspunktet

Sjekken skjer når tildelingen gis. Meldes en organisasjon inn i en samling som alt har
tildelinger, utvides de tildelingene til den nye organisasjonen — uten at dekningskravet ser det.
Ingen sjekk på tildelingssiden kan forhindre det, heller ikke en strengere enn denne.

Det er ikke et hull i regelen, men en presisering av hvor den hører: det som kan fange dette er
en revalidering **på medlemskapssiden** (avvis en innmelding som ville utvidet en eksisterende
tildeling utover innmelderens egen rett), eller en varsling. Begge hører i forvaltningsflaten for
medlemskap, som ikke er åpnet, og de er en del av grunnen til at medlemskapsforvaltningen er
strengere gatet enn tildelingen. Notert som oppfølger til BRU-TIL-SAM-001.

## Uavhengig av forvaltningsmodellen

Kravet gjelder likt enten samlinger og medlemslister forvaltes gjennom en flate i løsningen, via
API, eller kun av databaseforvaltningen gjennom migreringer:

- Alle reglene i featuren er formulert mot en samling som **finnes** og en medlemsliste som
  **gjelder**. Ingen av dem forutsetter hvem som skrev dem, eller hvordan.
- Dekningskravet leser medlemslisten slik den er, uansett hvem som vedlikeholder den.
- Dynamikken — at virkningen følger medlemslisten — er en egenskap ved utvidelsen i
  autorisasjonen, ikke ved forvaltningsflaten.

Konsekvensen er at tildeling mot samling kan tas i bruk før forvaltningsspørsmålet er avgjort.
I dag finnes én samling, opprettet av databaseforvaltningen; den er nok til at kravet har mening.
Blir forvaltningen senere en flate i løsningen, endrer ikke det en enkelt regel her.

## Temporalitet, idempotens og «fortsatt effektiv»

Tildelingen er temporalt modellert, som de direkte tildelingene: å trekke tilbake er å **lukke
gyldigheten**, ikke å slette innslaget. Historikken svarer derfor på hva som har vært gitt, når,
av hvem, og når det ble trukket tilbake. Begge operasjonene er idempotente — å gi en tilgang som
alt gjelder, og å trekke tilbake en som ikke gjelder, er suksess uten at historikken endres.
Idempotensen er ikke en bakvei rundt gatingen: rettigheten sjekkes også i de tilfellene der ingen
rad skrives, så «du mangler rettighet» og «det var alt gjort» er ulike svar.

**Det finnes ikke ett «fortsatt effektiv»-svar for en tilbaketrekking mot en samling**, og
featuren lover ikke ett. En applikasjon kan beholde tilgangen i noen medlemsorganisasjoner —
gjennom en direkte tildeling, gjennom en annen samling, eller fordi en sterkere tilgang omfatter
den — og miste den i resten. Svaret er altså ett per organisasjon. Det ærlige stedet å lese det er
applikasjonens egen tilgangsliste for organisasjonen; en enkeltverdi på tilbaketrekkingen måtte
enten forenkle eller være en liste vi ikke kan fylle ærlig, siden innsyn i de direkte tildelingene
er en annen rettighet enn den som kreves her.

Det som **er** synlig, og som featuren lover, er at en direkte tildeling står uendret etter at
tildelingen mot samlingen er trukket tilbake — og motsatt: fjernes den direkte tildelingen, består
tilgangen gjennom samlingen. De to veiene er uavhengige.

## Skjermet lesning: du ser det du kunne skrevet

Katalogen og medlemslistene er åpen lesning — hvilke samlinger som finnes og hvilke organisasjoner
de består av trenger ingen skjerming. **Tildelingene mot en samling er skjermet**, og
lesesemantikken er den samme mengden som skrivesemantikken: du ser de tildelingene du selv kunne
skrevet, altså de mot samlinger der rettigheten din dekker hver aktive medlemsorganisasjon i
miljøet. For alle andre er listen tom.

Det gir en felle flaten må håndtere: **en tom liste betyr ikke at samlingen er uten tildelinger.**
Featuren har et eget scenario for det, og UI-et bør si det, ikke vise «ingen tilganger».

Medlemslisten er samtidig forklaringen på et avslag: den sier hvilke organisasjoner rettigheten
kreves for. Å hente den sammen med et avslag er derfor det som gjør feilmeldingen brukbar.

## Ikke-funksjonelt

Dekningskravet koster i takt med antall aktive medlemmer i miljøet, per tildeling som vurderes.
Ved dagens volum (den eneste samlingen som finnes har 37 medlemmer i produksjon) er det uten
betydning. Forvaltningsregelen om at samlinger over 500 medlemmer skal ytelsesmåles før de tas i
bruk — se BRU-TIL-SAM-001 — er også taket for dette predikatet. Grensen håndheves ikke her; den er
en prosessregel.

## Avklarte valg

- Mottaker er en applikasjon; tildelingen er applikasjonsadministratorens handling.
- Rettigheten er tildelingsretten, ikke et eget samlingsprivilegium — men den kreves for **hver**
  aktive medlemsorganisasjon i miljøet (full dekning), og for minst én organisasjon i miljøet.
- Tildeling og tilbaketrekking er temporale og idempotente; historikken består.
- Tildelingene mot en samling er skjermet med samme mengde som skrivingen; katalog og medlemsliste
  er åpen lesning.
- Kravet står uavhengig av forvaltningsmodellen for samlinger og medlemskap.

## Åpne spørsmål

- [ ] Skal en tilgang som følger av en samling vises i applikasjonens egen tilgangsliste, og
      hvordan skal det fremgå at den ikke kan fjernes der? Provenienssporet henger sammen med
      visningen av mine tilganger, jf. BRU-TIL-SAM-001.
- [ ] Skal brukere kunne være mottaker av en tildeling mot en samling, eller bare applikasjoner?
- [ ] Skal en innmelding i en samling revalideres mot innmelderens egen tildelingsrett, eller
      varsles? Hører i medlemskapsflaten.
- [ ] Skal delegering til en applikasjon senere kunne uttrykkes mot en samling? I dag må
      delegering gjøres per organisasjon, og samlingsformen gjelder bare applikasjonens egne
      tilganger.
