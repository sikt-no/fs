# Designnotat: Tildele tilgang mot en organisasjonssamling

**Relatert feature:**
[`tildele_tilgang_mot_organisasjonssamling.feature`](./tildele_tilgang_mot_organisasjonssamling.feature)
(BRU-TIL-SAM-002).

Til forskjell fra forvaltningen av samlingene selv (BRU-TIL-SAM-001, som fortsatt er en
designdiskusjon) er denne delen besluttet. Notatet forklarer de to valgene som bærer kravet:
hvordan tildelingen er gatet, og hvorfor kravet står uavhengig av hvordan samlingene forvaltes.

## Status 13.11.2026: API-et er bygget, flaten i FS Admin er ikke

Sjekket mot tilgangsstyringen på fs-plattform main og fs-admin main 13.11.2026. Kravet står
som `@planned`. Hva som er bygget, står her og ikke som tagger i featuren.

| Regel i featuren | API (fs-plattform) | FS Admin |
|---|---|---|
| En tildeling gjelder én tilgang, én applikasjon, én samling og ett miljø | Bygget | Ikke bygget |
| Tildeling mot en samling krever rettighet til å tildele i hver av medlemsorganisasjonene | Bygget | Ikke bygget |
| En utgått tilgang kan ikke tildeles mot en samling | Avvisningen er bygget (!6766). At utgåtte tilganger ikke står i listen over tilganger som kan tildeles, kommer med !6773, som var åpen 13.11 | Ikke bygget |
| Å gi en tilgang som alt er gitt, eller trekke tilbake en som ikke gjelder, er suksess | Bygget | Ikke bygget |
| En tilgang trekkes tilbake ved at gyldigheten lukkes, og historikken består | Bygget | Ikke bygget |
| Tilbaketrekking berører ikke tilgang som består på annen vei | Bygget | Fjerning av den direkte tildelingen, med beskjeden om at applikasjonen fortsatt har tilgangen, er bygget. Tilbaketrekking mot samlingen er ikke bygget |
| En tilgang gitt gjennom en samling vises i applikasjonens tilgangsliste, men fjernes ikke der | Bygget | Bygget (BAT-308 og BAT-311) |
| Virkningen følger medlemslisten | Bygget | Ingen flate trengs |
| Tildelingene mot en samling er skjermet, mens katalogen og medlemslisten er åpen | Bygget | Ingen side for samlinger |

I API-et finnes `tildelSamlingTilganger` og `fjernSamlingTilganger`, `tildelbareSamlingTilgangskoder`,
`Query.organisasjonssamlinger` med `medlemskap` og `tilganger`, `samlingTilganger` på de tre
applikasjonstypene, og `Samlingstilgang.tilgangsrolle`. Skjemaet er experimental.

**Det som mangler i FS Admin:** handlingen «Tildel mot organisasjonssamling» på Tilganger-fanen
(samling, miljø, tilganger og medlemslisten), tilbaketrekking av en tilgang gitt gjennom en
samling, og en side som viser samlingen, medlemslisten og tildelingene mot den. Utkastet i
fs-admin !2736 ble lukket 13.11.2026 fordi API-et og tilgangslisten har gått forbi det. En ny,
mindre endring fra main er anbefalt. Den bør bruke `tildelbareSamlingTilgangskoder` og
`Samlingstilgang.tilgangsrolle`, og vise feilene for manglende rettighet og for utgått tilgang.

## Utgangspunktet: mengden finnes, skriveflaten er den nye delen

Datamodellen for organisasjonssamlinger kom med migrering 0029: katalogen over samlinger,
temporale medlemskap per miljø, og temporale tildelinger mot en samling. Autorisasjonen utvider
en aktiv tildeling mot en samling til de organisasjonene som er aktive medlemmer **i det samme
miljøet**, side om side med de direkte tildelingene, og resultatet rolleekspanderes og
dedupliseres. Utvidelsen krysser aldri miljø.

Migrering 0045 åpnet **én** av de tre flatene: å gi og trekke tilbake en tilgang mot en samling
som alt finnes. Katalogen og medlemskapene er fortsatt bare skrivbare for databaseforvaltningen,
og hvem som skal få forvalte dem, er BRU-TIL-SAM-001s spørsmål.

Mottakeren er en **applikasjon**. Det er applikasjonsadministratorens flyt, den samme som
BRU-APP-API-007 og BRU-APP-API-008 beskriver for én organisasjon, bare rettet mot en mengde.
API-et tar bare applikasjoner. Datamodellen skiller ikke, og lesesiden viser allerede roller en
person har fått gjennom en samling (rollelistene og siden for en rolle). Om personer skal kunne
være mottaker, er fortsatt åpent.

## Gatingen: full dekning, ikke delvis

Rettigheten er **den samme som for å tildele mot én organisasjon**: tildelingsretten per
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
  hver enkelt medlemsorganisasjon i, ikke mer og ikke mindre.

**Den tomme mengden er et eget ledd.** «Ingen medlemsorganisasjon utenfor rettigheten min» er
trivielt sant for en samling uten aktive medlemmer i miljøet, og uten et tillegg ville enhver
innlogget kunne skrevet en tildeling mot en slik samling. Regelen krever derfor også at kalleren
har tildelingsrett et sted i miljøet, altså er en administrator med tildelingsmyndighet i det
hele tatt. En tildeling mot en tom samling har ingen virkning før organisasjoner meldes inn.

Det samme uttrykket (`har_samling_tildelingsrett`) brukes av databasens radtilgang, av
mutasjonene før de skriver, og av `tildelbareSamlingTilgangskoder`. Listen over tilganger som
kan tildeles, er derfor tom nøyaktig når tildelingen ville blitt avvist, og den tomme listen er
gaten for handlingen i flaten.

**Alternativet er avvist.** Å gate tildeling mot samling på et globalt privilegium på Sikt-nivå,
slik forvaltningen av samlinger må gates siden en samling ikke har noen eierorganisasjon å skope
til, ville gjort tildeling mot samling til et Sikt-anliggende. Bestillingen er at
applikasjonsadministratorer skal kunne bruke samlinger, og dekningskravet er det som gjør det
forsvarlig uten å flytte handlingen til Sikt. Utkastet i #546 hadde den globale rettigheten også
for tildeling. Det er erstattet av dette kravet.

## Dekningen vurderes ved tildelingstidspunktet

Sjekken skjer når tildelingen gis. Meldes en organisasjon inn i en samling som alt har
tildelinger, utvides de tildelingene til den nye organisasjonen, uten at dekningskravet ser det.
Ingen sjekk på tildelingssiden kan forhindre det, heller ikke en strengere enn denne.

Det er ikke et hull i regelen, men en presisering av hvor den hører: det som kan fange dette er
en revalidering **på medlemskapssiden** (avvis en innmelding som ville utvidet en eksisterende
tildeling utover innmelderens egen rett), eller en varsling. Begge hører i forvaltningsflaten for
medlemskap, som ikke er åpnet, og de er en del av grunnen til at medlemskapsforvaltningen er
strengere gatet enn tildelingen. Notert som oppfølger til BRU-TIL-SAM-001.

## Uavhengig av forvaltningsmodellen

Kravet gjelder likt enten samlinger og medlemslister forvaltes gjennom en flate i løsningen, via
API, eller bare av databaseforvaltningen gjennom migreringer:

- Alle reglene i featuren er formulert mot en samling som **finnes** og en medlemsliste som
  **gjelder**. Ingen av dem forutsetter hvem som skrev dem, eller hvordan.
- Dekningskravet leser medlemslisten slik den er, uansett hvem som vedlikeholder den.
- Dynamikken, at virkningen følger medlemslisten, er en egenskap ved utvidelsen i
  autorisasjonen, ikke ved forvaltningsflaten.

Konsekvensen er at tildeling mot samling kan tas i bruk før forvaltningsspørsmålet er avgjort.
Migrering 0029 oppretter én samling, «FS-læresteder», og det er nok til at kravet har mening.
Blir forvaltningen senere en flate i løsningen, endrer ikke det en enkelt regel her.

## Temporalitet, idempotens og «fortsatt effektiv»

Tildelingen er temporalt modellert, som de direkte tildelingene: å trekke tilbake er å **lukke
gyldigheten**, ikke å slette innslaget. Historikken svarer derfor på hva som har vært gitt, når,
av hvem, og når det ble trukket tilbake. API-et oppgir hvem som ga og trakk tilbake, som personen. Feltet
er tomt når det ble gjort maskinelt, eller når du ikke kan se personen.

Begge operasjonene er idempotente: å gi en tilgang som alt gjelder, og å trekke tilbake en som
ikke gjelder, er suksess uten at historikken endres. Idempotensen er ikke en bakvei rundt
gatingen: rettigheten sjekkes også i de tilfellene der ingen rad skrives, så «du mangler
rettighet» og «det var alt gjort» er ulike svar. Sjekken kommer også før oppslaget av
applikasjonen og tilgangskoden, så en kaller uten rettighet ikke kan bruke API-et til å finne ut
hvilke applikasjoner og tilgangskoder som finnes. En forespørsel med flere innslag er
alt-eller-ingenting.

**Det finnes ikke ett «fortsatt effektiv»-svar for en tilbaketrekking mot en samling**, og
featuren lover ikke ett. En applikasjon kan beholde tilgangen i noen medlemsorganisasjoner,
gjennom en direkte tildeling, gjennom en annen samling, eller fordi en sterkere tilgang omfatter
den, og miste den i resten. Svaret er altså ett per organisasjon. Det ærlige stedet å lese det er
tilgangslisten på applikasjonen. API-et følger dette: svaret på en tilbaketrekking er samlingen,
ikke tilgangen.

Den andre veien har ett svar, og der lover featuren det: fjernes den direkte tildelingen i en
medlemsorganisasjon, består tilgangen gjennom samlingen, og FS Admin sier at applikasjonen
fortsatt har tilgangen. De to veiene er uavhengige.

## Applikasjonens tilgangsliste: rader «Via samlingen …»

Avklart av implementasjonen (fs-plattform migrering 0107, fs-admin BAT-308 og BAT-311): en
tildeling mot en samling gir en rad i tilgangslisten på applikasjonen i hver organisasjon som er
aktivt medlem av samlingen i miljøet, med tilknytningen «Via samling». Rolleimplikasjonene fra
den gir arvede rader. Er tilgangen i tillegg tildelt direkte i samme organisasjon, står raden
som direkte og kan fjernes. API-et har da samlingen på raden, men FS Admin viser merket bare på
rader med tilknytningen «Via samling».

| Hvor | Tekst i FS Admin |
|---|---|
| Merket på raden | «Via samlingen {navn}» (flere: «Via samlingene {navn}») |
| Filter for tilknytning | «Via samling» |
| Raden i dialogen for å fjerne tilganger (kan ikke velges) | «Via samling {navn} — kan bare trekkes tilbake for hele samlingen» |
| Feilen fra API-et om raden likevel sendes | «Tilgangen er gitt gjennom en organisasjonssamling og kan ikke fjernes for én organisasjon. Den må trekkes tilbake for hele samlingen.» |

Raden er synlig for den som ville sett en direkte tildeling til applikasjonen i den
organisasjonen og det miljøet. Det er en annen og videre mengde enn den som ser tildelingene mot
samlingen, se under.

Utkastet i fs-admin !2736 hadde en egen seksjon for tildelingene mot samlinger under de direkte
tilgangene. Den ville vist de samme tildelingene to ganger, og main har valgt radene i stedet.

## Skjermet lesning: du ser det du kunne skrevet

Katalogen og medlemslistene er åpen lesning: hvilke samlinger som finnes og hvilke organisasjoner
de består av, trenger ingen skjerming. **Tildelingene mot en samling er skjermet**, og
lesesemantikken er den samme mengden som skrivesemantikken: du ser de tildelingene du selv kunne
skrevet, altså de mot samlinger der rettigheten din dekker hver aktive medlemsorganisasjon i
miljøet. For alle andre er listen tom. Det gjelder både på samlingen og i `samlingTilganger` på
applikasjonen.

Det gir en felle flaten må håndtere: **en tom liste betyr ikke at samlingen er uten tildelinger.**
Featuren har et eget scenario for det, og UI-et bør si det, ikke vise «ingen tilganger».

To ting i implementasjonen er åpne spørsmål i featuren:

- Raden i tilgangslisten på applikasjonen viser samlingen for alle som ville sett en direkte
  tildeling der. En administrator i én medlemsorganisasjon ser altså at applikasjonen har
  tilgangen gjennom samlingen, men får en tom liste over tildelingene mot samlingen.
- En tildeling mot samlingen kan være synlig uten at applikasjonen er det: uten innsyn i
  applikasjonen (lesetilgang i eierorganisasjonen) viser raden tilgang, miljø og gyldighet, men
  ikke hvilken applikasjon.

Medlemslisten er samtidig forklaringen på et avslag: den sier hvilke organisasjoner rettigheten
kreves for. Å hente den sammen med et avslag er derfor det som gjør feilmeldingen brukbar.
Feilmeldingen fra API-et sier bare at rettigheten mangler for samlingen i miljøet.

## Utgått tilgang

En utgått tilgang kan ikke tildeles mot en samling. API-et avviser den med feilen at
tilgangskoden er utgått (fs-plattform !6766), som på de andre tildelingsveiene. Tildelinger den
alt har, gjelder videre og kan trekkes tilbake. Å tildele en utgått tilgang som alt gjelder mot
samlingen og miljøet, er suksess uten endring, så et nytt forsøk med flere tilganger ikke rulles
tilbake fordi én av dem er blitt utgått i mellomtiden.

At utgåtte tilganger ikke står i `tildelbareSamlingTilgangskoder`, kommer med fs-plattform !6773
(BAT-434), som var åpen 13.11.2026.

## Delegeringstaket er en annen mengde

Å tildele en tilgang mot en samling gir applikasjonen **egne tilganger** i medlemsorganisasjonene.
Det endrer ikke applikasjonens delegeringstak, altså hva applikasjonen kan gjøre på vegne av en
innlogget bruker.

Delegeringstaket har fått sin egen samlingsform (migrering 0080). Rollene der vises i
`FeideApplikasjon.delegeringstak` med tilknytningen SAMLING, én gang per medlemsorganisasjon
(fs-plattform !6576), og gjelder valglisten for roller i BRU-PER-GRU-003 («Taket for en
organisasjonssamling gjelder organisasjonene i samlingen»). Det finnes ingen mutasjon for å
utvide delegeringstaket mot en samling, så det skrives i dag bare av databaseforvaltningen. Om
det skal kunne gjøres fra løsningen, er et åpent spørsmål.

## Ikke-funksjonelt

Dekningskravet koster i takt med antall aktive medlemmer i miljøet, per tildeling som vurderes.
Migrering 0029 melder inn 37 organisasjoner i samlingen «FS-læresteder» i produksjon, og ved det
volumet er kostnaden uten betydning.
Forvaltningsregelen om at samlinger over 500 medlemmer skal ytelsesmåles før de tas i bruk (se
BRU-TIL-SAM-001), er også taket for dette predikatet. Grensen håndheves ikke, verken i API-et
eller i databasen. Den er en prosessregel.

## Avklarte valg

- Mottaker er en applikasjon, og tildelingen er applikasjonsadministratorens handling.
- Rettigheten er tildelingsretten, ikke et eget samlingsprivilegium, men den kreves for **hver**
  aktive medlemsorganisasjon i miljøet (full dekning), og for minst én organisasjon i miljøet.
- Tildeling og tilbaketrekking er temporale og idempotente, og historikken består.
- Tildelingene mot en samling er skjermet med samme mengde som skrivingen. Katalog og
  medlemsliste er åpen lesning.
- Kravet står uavhengig av forvaltningsmodellen for samlinger og medlemskap.
- AVKLART 13.11.2026 (fra implementasjonen): en tilgang gitt gjennom en samling vises i
  tilgangslisten på applikasjonen, som en rad per medlemsorganisasjon med «Via samlingen …», og
  kan ikke fjernes der.
- AVKLART 13.11.2026 (fra implementasjonen): en utgått tilgang kan ikke tildeles mot en samling,
  men kan trekkes tilbake.

## Åpne spørsmål

- [ ] Skal brukere kunne være mottaker av en tildeling mot en samling, eller bare applikasjoner?
      API-et tar bare applikasjoner, mens rollelistene for personer viser samlingsrader.
- [ ] Er det riktig at raden i tilgangslisten på applikasjonen viser samlingen for alle som ser
      applikasjonens tilganger i organisasjonen, mens tildelingene mot samlingen er skjermet?
- [ ] Skal den som kan tildele mot samlingen, se hvilken applikasjon en tildeling er gitt til,
      også uten innsyn i applikasjonen?
- [ ] Skal en innmelding i en samling revalideres mot innmelderens egen tildelingsrett, eller
      varsles? Hører i medlemskapsflaten.
- [ ] Skal delegeringstaket til en applikasjon kunne utvides mot en samling fra løsningen?
      Datamodellen har samlingsformen, men det finnes ingen flate for å skrive den.
