---
name: fs-testcaser-cdp
description: Lager og oppdaterer de varige testene for den agentiske funksjonstesten (fase 2 i teststrategien (forslag), «Teststrategi for FS – fra krav til akseptanse» i Confluence, STUDIEADM): `cdp-tester/`, Gherkin som en agent kjører i Chrome med `cdp`-skillen mot et testmiljø, fra kravene under `krav/`. Inndata er krav (en feature-fil, en mappe, `@scope-<slug>`, en oppgave eller en Feature-ID), en flyt, en eksisterende test, eller en testplan, som bare velger kravene («Omfang»). For hvert krav: finnes testen og er kravet uendret, gjøres ingenting; er kravet endret, foreslås en oppdatering som diff; mangler testen, lages den. Hvert scenario i gating-settet som er `@implemented`, blir et uavhengig, konkret scenario, og i tillegg lager skillen testcaser fra reglene (også regler i koden uten scenario, fra verify-rapporten): positiv og negativ testing, obligatoriske felt (tomt, bare mellomrom, for lang verdi, feilmeldingen kontrollert), og testteknikk valgt per regel (grenseverdianalyse, ekvivalensklasser, beslutningstabell, tilstandsoverganger) og skrevet i testen. Testbrukere og testdata er nøkler. Testene lager dataene sine selv, fordi data i testmiljøet kan slettes når som helst: oppsettet (`cdp-tester/_Oppsett/<sti>/oppsett.feature`) lager testdataene gjennom løsningen i hver kjøring, ett scenario per nøkkel. Miljøfila (`cdp-tester/_Miljøer/<miljø>.md`) er den autoritative oversikten over personaene og rollene i FS Admin, grunndataene og data testene ikke kan lage: testbrukeren kobles til en persona der. Testene kjenner ikke til testplaner: de har ingen status, kjente mangler, henvisninger til en testplan eller miljøverdier, og kan kjøres frittstående og senere. Overleveringene i flytene i `krav/_Flyter` blir tester i `cdp-tester/_Løp/`. Hvert scenario har skjermens ord, testbruker og testdata som nøkler (ikke navn), og en `Så` agenten kan se. Referansene til kravene er `@depends-on-<Feature-ID>` (og `@ref-`), identiske `Regel:`- og `Scenario:`-titler, og en header med kravfila og commit og blob-hash, som gir en diff når kravet er endret. Skriver `cdp-tester/<kravstien>/<fil>.feature`, `README.md` («Krever») og oppsettet, og nye nøkler i miljøfila når brukeren sier ja. Reglene for å kjøre testene står i `cdp-tester/README.md`. Endrer aldri `krav/`. Trigges av "lag CDP-tester", "oppdater CDP-tester", "agentisk funksjonstest", "agentisk test", "cdp-tester", "kjørbare tester for kravet", "tester for CDP", "fase 2", "fs-testcaser-cdp".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# CDP-tester

## Task

$ARGUMENTS

## Din rolle

Du gjør kravene om til varige tester som en agent kan kjøre i Chrome, uten å gjette. Kravene i `krav/` er deklarative, og sier hva som skal gjelde. Testene her sier hvordan det sjekkes i skjermen: skjermens ord, konkrete verdier og noe som kan ses. Konvensjonene står i [`cdp-tester/README.md`](../../../cdp-tester/README.md).

Det er fase 2 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326), den agentiske funksjonstesten (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)). Den er obligatorisk, og kommer før den interne akseptansetesten. Testene lages fra kravene, med eller uten en testplan, og kan være laget tidligere.

Fra strategien:

- **Mål:** bekrefte at hver funksjon virker som kravet sier, med gyldige og ugyldige data.
- **Omfang:** alle scenarioene leveransen har gjort `@implemented`, pluss testcasene du utleder fra reglene, også reglene `fs-verify` fant i koden uten scenario. Du velger teknikken per regel. Gis en testplan, er «Testcaser som skal lages» der en sjekk: avvikene står i oppsummeringen, aldri i testene.
- **Hva testes:** positiv testing (hvert scenario slik det står, en scenariomal gir én testcase per eksempel), negativ testing (ugyldige verdier, feil format, handlinger i feil rekkefølge, data som ikke finnes eller er slettet), og obligatoriske felt: hvert felt testes tomt, med bare mellomrom og med for lang verdi, og feilmeldingen kontrolleres.
- **Teknikk:** du velger teknikken ut fra regelen, og skriver hvilken som er brukt i testen: grenseverdianalyse (min, maks, like over og like under, tomt felt), ekvivalensklasser, beslutningstabeller for regler med flere betingelser, og tilstandsoverganger (for eksempel statusene til en søknad).
- **Ikke her:** roller, tilgangsstyring og datakonsistens verifiseres i koden i fase 1 (`fs-verify`). Scenarioene i kravet testes som de står, også synlighet for en rolle, men du utleder ikke egne testcaser for roller og tilgang. Flyter på tvers og avhengigheter testes i fase 3.
- **Utenfor kravet:** utleder du et tilfelle kravet ikke sier noe om, og løsningen oppfører seg uventet, er det et funn av typen «Kravet dekker ikke». Det avklares i kravet (`fs-krav`), ikke bare i testen.

- **Kravene er fasit for hva som testes.** Testene dekker gating-settet som er `@implemented` (også de leverte delene i et krav som er delvis levert), i rekkefølgen i feature-fila. Endre aldri kravene eller taggene i `krav/`. Alle scenarioene i gating-settet blir tester. Er et scenario uklart, mangler forventet resultat eller motsier koden, skriv testen så godt kravet lar deg, merk det med `[Sjekk begrep]` eller en kommentar, og foreslå `fs-krav` i oppsummeringen. Kan testen ikke kjøres, er det kjøringen som viser det.
- **Testene er varige, og kjenner ikke testplanen.** De overlever testplaner og akseptansetester, og skal kunne kjøres frittstående senere. Derfor har de nøkler for testbruker og testdata, aldri navn, Feide-ID eller `testbruker <nr>`, og ingen miljø-URL. De har heller ikke status for kravet eller leveransen, kjente mangler, saker med status, resultater fra verifiseringen eller en kjøring, henvisninger til en testplan eller testcaser i den, eller verdier som bare gjelder ett miljø («Bare det som varer» i `cdp-tester/README.md`). En testplan kan velge hvilke krav som får tester, men testene og `README.md`-ene viser aldri til den.
- **Testene lager dataene sine.** Data i testmiljøet kan slettes eller nullstilles når som helst. Oppsettet (`cdp-tester/_Oppsett/<sti>/oppsett.feature`) lager testdataene gjennom løsningen i hver kjøring, med `{KJØRING}` i navnene (*Oppsettet* i `cdp-tester/README.md`). Data som deles i kjøringen og endres av et scenario, settes tilbake (R13).
- **Miljøfila er autoritativ** for personaene og rollene i FS Admin, grunndataene (kodeverk, organisasjoner, regelverkssamlinger) og data testene ikke kan lage gjennom løsningen (`cdp-tester/_Miljøer/<miljø>.md`). Testbrukerne kobles til en persona der.
- **Testene er verktøyuavhengige.** Gherkin-filene skal kunne leses og brukes av flere (agenter, testere, andre verktøy). Det som er spesifikt for CDP, står bare i *Kjøring og resultat* i `cdp-tester/README.md` og i resultatmalen.
- **Agenten foreslår, mennesker godkjenner.** Agenten kan aldri godkjenne en leveranse. Testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene, etter en risikovurdering.
- **Gjett aldri det bare teamet vet.** Det som mangler, står som `[Fylles ut: <hva>]` i miljøfila, og scenarioet blir «Ikke testet» i kjøringen til det er utfylt.
- **Åpne spørsmål gater ikke.** Et scenario eller en regel med `@openquestion` (uten `@draft`) blir testcase som den står.
- **Overskriv aldri håndrettede scenarioer.** Finnes testfila fra før, vis en diff og foreslå.
- **Alltid et testmiljø, aldri produksjon.**
- **Publiser aldri til Confluence uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i stedet for `grep` og `git`, og skriv `commit ikke sjekket (Claude-panelet)` i headeren.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`cdp-tester/README.md`](../../../cdp-tester/README.md): mappestrukturen, Gherkin-reglene, referansene, «Krever» og *Miljøfila* (også *Vedlikehold av miljøfila*).
2. [`references/mal-cdp.md`](references/mal-cdp.md): malene for testfila, `README.md` og resultatet.
3. [`.claude/references/akseptansetest/roller-og-testdata.md`](../../references/akseptansetest/roller-og-testdata.md): *Nøkkelen*, *Finne rollene og foreslå testbrukere*, *Testdata* og *Lese koden*.
4. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): *Finn kravene*, gating-settet og flytene.
5. [`.claude/references/akseptansetest/testcase-regler.md`](../../references/akseptansetest/testcase-regler.md): reglene for fase 2 i tabellen der (R1–R9 og R12–R16), blant annet R9 (feilsituasjoner), R13 (testen kan kjøres på nytt), R14 (følg stegene slik de står) og R16 (kjent mangel). R10 (avhengigheter mellom testcaser) og R11s regler for fase 3 og 4 gjelder ikke: CDP-scenarioene er uavhengige.
6. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

## 1. Finn kravene, og om testene finnes

Argumentet sier hvilke krav som skal ha tester:

| Argument | Kravene |
|---|---|
| krav: en feature-fil, en mappe, `@scope-<slug>`, en oppgave eller en Feature-ID | Etter *Finn kravene* i `krav-fra-testplan.md` |
| en flyt: en sti under `krav/_Flyter/`, eller en `@FLY-`-ID | Flyten (steg 2, punkt 4) |
| en eksisterende test i `cdp-tester/` | Kravet i headeren (steg 5) |
| en testplan (`akseptansetest/<slug>`, eller en slug som finnes der) | Feature-ID-ene i «Omfang», og flytene i «Flyter». Les ikke noe annet fra testplanen enn «Testcaser som skal lages», som en sjekk (steg 2, punkt 6) |

Er det uklart, spør (`AskUserQuestion`). Let aldri etter en testplan når argumentet er krav.

For hvert krav, se etter testen: `grep -rln "@depends-on-<Feature-ID>" cdp-tester/`, og den speilede stien.

| Testen | Hva du gjør |
|---|---|
| finnes, og blob-hashen i headeren er lik kravfila nå, og ingen scenarioer i gating-settet mangler i testen | Ingenting. Testen står i oppsummeringen som «uendret» |
| finnes, men hashen er ulik, eller scenarioer i gating-settet mangler (også nye som er levert) | Oppdatering (steg 5) |
| finnes ikke | Lag den (steg 2–4) |

Vis lista før du lager eller endrer noe.

## 2. Finn scenarioene og ordene

1. Kravene og gating-settet per krav, som i `krav-fra-testplan.md`. Bare krav som er `@implemented` (og de leverte delene i et endret krav, og `@implemented`-delene i et krav som er delvis levert) blir tester. Er et krav du har fått som argument, ikke `@implemented`: si det, og spør om det skal lages likevel (testen kjøres ikke før kravet er levert).
2. Les verify-rapporten for kravene når den finnes. Et scenario som er `ikke funnet` eller `usikker` der, lages likevel når det er `@implemented`: om det er levert, avgjøres av kjøringen, ikke av testen. **Regler i koden uten scenario** (valideringer og andre regler verify-rapporten har funnet, og som kravet ikke sier noe om) er input til utledede testcaser (punkt 6). Tilgangssjekkene i rapporten testes ikke her: de er verifisert i koden i fase 1.
3. **Ordene fra skjermen:** `<feature>.design.md` og skissene, og koden (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren): menyer, ruter, felt, knapper, `Så`-tekster og feilmeldinger. Se *Lese koden* i `roller-og-testdata.md`. Merk det du ikke finner, `[Sjekk begrep]`.
4. **Flytene.** Flyten brukeren oppga, eller flytene som går gjennom kravene (*Finn flytene* i `krav-fra-testplan.md`), eller flytene i «Flyter» når en testplan valgte kravene. Hvilke scenarioer som blir tester, avgjøres etter *Hele eller deler av flyten* i den samme fila. Faser som ikke er levert, står i oppsummeringen, ikke i testene.
5. **Hva agenten kan se:** `Så` er noe som kan ses i skjermen. Kan kravets resultat ikke ses i skjermen, skriv det nærmeste som kan ses, og si det i oppsummeringen. At testdata mangler i et miljø, avgjør ikke om testen lages.
6. **Utledede testcaser.** For hver `Regel:`, og for hver regel i koden uten scenario: velg teknikk ut fra regelen, og lag testcasene teknikken gir. Valgte en testplan kravene, sammenlign med «Testcaser som skal lages» der, og skriv avvikene i oppsummeringen.
   - **Grenseverdianalyse** for tall, datoer og lengder: min, maks, like under og like over, og tomt felt.
   - **Ekvivalensklasser** for valg og kategorier: én verdi fra hver klasse, også en ugyldig.
   - **Beslutningstabell** for en regel med flere betingelser: én testcase per rad i tabellen. Ta tabellen med i `# Teknikk:`-kommentaren.
   - **Tilstandsoverganger** for noe som skifter status: gyldige overganger, og en ugyldig overgang som skal avvises.
   - **Obligatoriske felt:** for hvert obligatorisk felt som regelen eller skjemaet har, tre testcaser: tomt, bare mellomrom og for lang verdi. Feilmeldingen kontrolleres (R9 i `testcase-regler.md`). Finn de obligatoriske feltene og lengdene i koden eller i `<feature>.design.md`, og sjekk om feltet har en standardverdi (R5).
   - **Negativ testing:** ugyldige verdier, feil format, handlinger i feil rekkefølge, og handlinger på data som ikke finnes eller er slettet.
   - Hver slik testcase er `@utledet`, med `# Teknikk:` over scenarioet. Er det ikke grunnlag for en teknikk (regelen har ingen verdier eller betingelser), lag ingen testcase, og ikke finn på tilfeller for å fylle opp.
   - Slå sammen testcaser som sjekker det samme, og begrens antallet: grenseverdiene og de ugyldige klassene regelen faktisk har.

## 3. Nøkler: roller og testdata

Miljøfila (`cdp-tester/_Miljøer/<miljø>.md`, normalt `test.md`) er kilden. Spør hvilket miljø når det finnes flere filer.

1. **Nøklene.** Fra scenarioene (`Gitt`-stegene og rollene i kravet) og de utledede testcasene: lag nøklene for testbrukere og testdata etter *Nøkkelen* i `roller-og-testdata.md` (rolle og relasjon, aldri organisasjon, person eller år). Bruk nøkler som finnes i miljøfila eller i «Krever» i andre mapper når de betyr det samme. Organisasjoner i stegene skrives `{ORG:<nøkkel>}`, `{ORGNAVN:<nøkkel>}` eller `{ORGKODE:<nøkkel>}`.
2. **«Krever».** Skriv nøklene i `cdp-tester/<sti>/README.md`, med typen og hvilke scenarioer som bruker dem (`Nøkkel | Type | Brukes av`). Typen er `testbruker`, `testdata (oppsett)` eller `testdata` (grunndata, i miljøfila). Hva nøkkelen krever, står ett sted: «Krever» i miljøfila for en testbruker, scenarioet i oppsettet for `testdata (oppsett)`, og «Utgangstilstand» i miljøfila for grunndata. Beskrivelsen sier egenskapene, ikke verdien i ett miljø. For en testbruker: rollene skjermene og API-et krever (*Finne rollene og foreslå testbrukere*, punkt 1–4 i `roller-og-testdata.md`, med `fil:linje` i oppsummeringen) og relasjonen til organisasjonen.
3. **Testbrukerne i miljøfila.** Finnes nøkkelen i «Testbrukere», sjekk at personaen fortsatt står i «Personaer» og har tildelingene «Krever» sier. Finnes den ikke, foreslå en persona fra «Personaer» som har rollen, ved en organisasjon som oppfyller relasjonen, og en annen organisasjon enn de andre testbrukerne når scenarioene skiller mellom dem. Er personaen ikke bekreftet (`–` i «Bekreftet»), si det. Finnes ingen som passer, si at en persona må legges til i fs-admin og tildelingen i tilgangsstyring, og foreslå raden med `[Fylles ut]`. Er katalogen gammel («Personaer sist sjekket»), foreslå *Vedlikehold av miljøfila* først.
4. **Testdataene i oppsettet.** Hver testdata-nøkkel som kan lages gjennom løsningen, får et scenario i `cdp-tester/_Oppsett/<sti>/oppsett.feature` (malen i `mal-cdp.md`): tittelen er nøkkelen, stegene gir utgangstilstanden (etter *Testdata* i `roller-og-testdata.md`, med datoene som `{DATO:±N}`), og siste steg skriver navnet og URL-en i «Kjøringens testdata». Finnes oppsettet, vis en diff. Grunndata og data testene ikke kan lage (for eksempel en søker med søknad), får en rad i miljøfila, med `[Fylles ut: <hva>]` når verdien mangler, og en kommentar i oppsettet.
5. **Kjørbar flere ganger.** Alt testene og oppsettet lager, får `{KJØRING}` i navnet, og søk etter dem bruker det unike navnet. Data fra oppsettet som et scenario endrer, settes tilbake i et avsluttende steg.
6. Skriv i miljøfila bare når brukeren sier ja. Stopp hvis en verdi ser ut som et ekte fødselsnummer eller et ekte navn.

## 4. Skriv testene

For hvert krav, skriv `cdp-tester/<kravets sti under krav/>/<samme filnavn som kravet>`, etter malen:

- Header med datoen, og kravfila med commit og blob-hash (`git rev-parse origin/main:<sti>`). Ingen henvisning til en testplan: testen hører ikke til én leveranse. Taggene: `@TST-…` og `@depends-on-<Feature-ID>` på `Egenskap:`. For en test som går over flere domener: `cdp-tester/_Løp/<NN Prosess>/<test>.feature`, med ett `@depends-on-` per krav.
- **En flyt** blir `cdp-tester/_Løp/<NN Prosess>/<samme filnavn som flyten>.feature`, med prosessmappa fra `krav/_Flyter`. Headeren har flytfila. `@TST-<prosess>-<flyt>-NNN @depends-on-FLY-<prosess>-<flyt>-NNN` står på `Egenskap:`, og hver `Regel:` har de samme `@depends-on-` som fasen i flyten. Titlene er flytens. Tilstanden i `Gitt` er en testdata-nøkkel med en `Utgangstilstand` som er laget gjennom løsningen i fasen før (for eksempel en søknad som har fått tilbudsgaranti i tidligopptaket), ikke lagt inn direkte. Ellers tester scenarioet ikke overleveringen. `Så` sjekkes der den neste aktøren jobber.
- `Regel:`- og `Scenario:`-titlene identiske med kravets. En `Scenariomal:` gir én rad i `Eksempler:` per eksempel i kravet.
- `Gitt` har testbruker som nøkkel, start (menyvei eller URL, med ordene fra skjermen), og testdata som nøkler, i utgangstilstanden i «Krever». Aldri «fra forrige scenario».
- **Utledede testcaser** (steg 2, punkt 6) står under regelen, med `@utledet` og `# Teknikk:`, og tittelen `<regelens tittel>: <hva som prøves>`. Én feilsituasjon prøver én ting: alle andre obligatoriske felt er fylt ut, så det er feltet testcasen handler om som stopper lagringen, og `Så` sier at det er det eneste som mangler. Et forhåndsutfylt felt tømmes, det «står» ikke tomt.
- `Når`: én handling per steg, skjermens ord i «», alle verdier med.
- `Så`: noe agenten ser. Gjør kravets generelle `Så` konkret (en tekst, et antall, noe synlig eller borte). Lagrer scenarioet noe, åpnes siden på nytt før `Så`.
- `@endrer-data` på scenarioet når det endrer data, med avsluttende steg som setter tilbake. Taggen sier at oppryddingen er med, og scenarioet kjøres som alle andre (*Regler for kjøringen* i `cdp-tester/README.md`).

Sjekkliste før du viser fram:

| # | Sjekk |
|---|---|
| 1 | Hvert scenario i gating-settet er generert |
| 2 | Ingen filer i `krav/` er endret, og ingen test ligger der |
| 3 | Ingen testfil har navn, Feide-ID, `testbruker <nr>`, passord eller miljø-URL |
| 4 | Hvert scenario er uavhengig, og har en `Så` agenten kan se |
| 5 | Referansene er sjekket (se under) |
| 6 | Det som må fylles ut, er merket `[Fylles ut …]` eller `[Sjekk begrep]`, og står i oppsummeringen |
| 7 | Hver testdata-nøkkel har et scenario i oppsettet (eller en rad i miljøfila for grunndata og data testene ikke kan lage), og testen kan kjøres på nytt (unike navn eller opprydding) |
| 8 | Hver utledede testcase har `@utledet` og `# Teknikk:`, og hver feilsituasjon prøver én ting |
| 9 | Ingen utledet testcase tester roller, tilgangsstyring eller datakonsistens (fase 1), eller flyter på tvers (fase 3, bortsett fra testene i `_Løp/`) |
| 10 | Valgte en testplan kravene: avvikene fra «Testcaser som skal lages» står i oppsummeringen, ikke i testene |
| 11 | Ingen testfil eller `README.md` i `cdp-tester/<sti>/` nevner en testplan, `akseptansetest/` eller testcaser derfra (`grep -rniE "testplan|akseptansetest|# Testcase:" cdp-tester/<sti>/`) |
| 12 | Testene og `README.md` har bare det som varer: ingen kravstatus, kjente mangler, saker med status, datoer fra verifiseringen eller kjøringer, eller verdier fra ett miljø («Bare det som varer» i `cdp-tester/README.md`) |
| 14 | Hver nøkkel i «Krever» finnes i oppsettet eller i miljøfila, eller er foreslått der (med `[Fylles ut]` når verdien mangler), og hver testbruker peker på en persona i «Personaer» |
| 13 | Ingen nøkkel har navnet på en organisasjon, en person eller et år, og ingen steg har navnet på en organisasjon (bruk `{ORG:<nøkkel>}`) |

**Referansesjekken** (ved hver generering og oppdatering):

1. Hver `@depends-on-` og `@ref-` peker på en Feature-ID (eller en flyt-ID) som finnes i nøyaktig én feature-fil under `krav/`.
2. Hver `Regel:` og hvert `Scenario:` finnes i den fila med samme tittel.
3. Hash i headeren er lik hash for kravfila nå. Er den ulik, er testen utdatert (se steg 5).
4. Hvert scenario i gating-settet er generert.

## 5. Oppdatere eksisterende tester

Finnes testfila fra før:

1. Sammenlign blob-hashen i headeren med kravfila nå. Er de like, og ingen scenarioer i gating-settet mangler i testen (heller ikke nye `@implemented`-deler i et krav som er delvis levert), er det ingenting å gjøre.
2. Ellers, list hva som er endret i kravet: nye, endrede og fjernede `Regel:` og `Scenario:`, med titlene (`git diff <commit-i-headeren>..origin/main -- <kravfila>`).
3. Vis forslaget som en diff mot testfila. Scenarioer som er rettet for hånd (andre steg enn skillen ville skrevet), nevnes, og skrives aldri over uten ja.
4. Skriv det brukeren godkjenner, og oppdater headeren (commit, hash, dato) og «Krever». Mangler et scenario i gating-settet i testen, lag det.
5. Fjernede krav: foreslå å slette testen, men slett aldri uten ja.
6. Har testene innhold som ikke varer, eller henvisninger til en testplan (sjekk 11 og 12), foreslå å fjerne det, eller flytte verdier til miljøfila.

## 6. Vis fram

Vis en kort oppsummering: kravene, og for hvert om testen var uendret, er oppdatert eller er ny; antall scenarioer generert og endret, antall `@utledet` og teknikkene som er brukt, antall `@endrer-data`, avvik fra «Testcaser som skal lages» når en testplan valgte kravene, antall scenarioer og regler med åpne spørsmål, scenarioer som er uklare eller der resultatet ikke kan ses i skjermen, testbrukerne med personaen de er koblet til (og om den er bekreftet), endringene du foreslår i miljøfila, og det som må fylles ut. Skriv aldri til Confluence uten ja.

Si hva som er neste steg: finnes det en testplan med kravene, synkes den med `fs-testplan` (skillen endrer aldri testplanen selv). Testene kjøres med `cdp`-skillen etter *Kjøring og resultat* i `cdp-tester/README.md`, mot miljøfila. Skillen kjører ikke testene selv. Hører kjøringen til en akseptansetest, sier `akseptansetest/README.md` hvor resultatet legges, og `fs-testrapport` (agentisk) lager rapporten.

## Kjøringen

Reglene for agenten som kjører testene (miljø-guard, forbudte kall, bytte av testbruker, bevis, funn og hvor resultatet legges) står i *Regler for kjøringen* i [`cdp-tester/README.md`](../../../cdp-tester/README.md), og malen for resultatet i [`references/mal-cdp.md`](references/mal-cdp.md). De står ikke her, fordi den som kjører testene, ikke trenger denne skillen.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene, scope-fila eller `oppgave.md`.
- Kjører ikke testene. Den lager og oppdaterer dem, og sier hvordan de kjøres.
- Lager ikke testdata selv. Den skriver oppsettet som lager dem i kjøringen, og kjører det ikke.
- Lager ikke testcasene for fase 3 og 4 (`fs-testcaser-intern`, `fs-testcaser-ekstern`), testplanen (`fs-testplan`) eller rapportene (`fs-testrapport`).
- Utleder ikke testcaser for roller, tilgangsstyring eller datakonsistens (fase 1, `fs-verify`), og ikke flyter på tvers (fase 3), bortsett fra overleveringene i `_Løp/`.
- Kjører aldri git add/commit/push, og kjører aldri `git pull` i kodeklonene.
