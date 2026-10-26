---
name: fs-testcaser-cdp
description: Lager og oppdaterer de varige testene for den agentiske funksjonstesten (fase 2 i teststrategien (forslag), «Teststrategi for FS – fra krav til akseptanse» i Confluence, STUDIEADM): `cdp-tester/`, Gherkin som en agent kjører i Chrome med `cdp`-skillen mot et testmiljø, fra kravene under `krav/` og testplanen. Fase 2 er obligatorisk og tar mesteparten av den funksjonelle testingen. Hvert scenario i gating-settet som er `@implemented`, blir et uavhengig, konkret scenario, og i tillegg lager skillen testcaser fra reglene (også regler i koden uten scenario, fra verify-rapporten): positiv og negativ testing, obligatoriske felt (tomt, bare mellomrom, for lang verdi, feilmeldingen kontrollert), og testteknikk valgt per regel (grenseverdianalyse, ekvivalensklasser, beslutningstabell, tilstandsoverganger) og skrevet i testen. Testdataene er de testplanen lister, i utgangstilstanden der (hvordan de lages, er utenfor strategien), og testene er uavhengige og kan kjøres på nytt. Overleveringene i flytene i `krav/_Flyter` blir tester i `cdp-tester/_Løp/` (fase 3 tester flytene manuelt, men testene kan brukes av flere). Hvert scenario har skjermens ord, testbruker og testdata som nøkler (ikke navn), og en `Så` agenten kan se. Referansene til kravene er `@depends-on-<Feature-ID>` (og `@ref-`), identiske `Regel:`- og `Scenario:`-titler, og en header med kravfila og commit og blob-hash, som gir en diff når kravet er endret. Omfanget kommer fra «Testcaser som skal lages» i testplanen, og roller og testdata fra testplanens tabeller (kolonnene `Nøkkel`, `Søk/URL`, `Utgangstilstand`, `Brukes av`), eller de samme spørsmålene når testplan mangler. Skriver `cdp-tester/<kravstien>/<fil>.feature` og `README.md` («Krever», «Ikke kjørbart»), og sier hvordan agenten kjører dem og hvor resultatet og bevisene legges. Kan også kjøres manuelt, uten testplan, for å lage nye tester eller oppdatere eksisterende når kravene er endret. Endrer aldri `krav/`. Trigges av "lag CDP-tester", "oppdater CDP-tester", "agentisk funksjonstest", "agentisk test", "CDP-kjøring", "cdp-tester", "kjørbare tester for kravet", "tester for CDP", "fase 2", "fs-testcaser-cdp".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# CDP-tester

## Task

$ARGUMENTS

## Din rolle

Du gjør kravene om til varige tester som en agent kan kjøre i Chrome, uten å gjette. Kravene i `krav/` er deklarative, og sier hva som skal gjelde. Testene her sier hvordan det sjekkes i skjermen: skjermens ord, konkrete verdier og noe som kan ses. Konvensjonene står i [`cdp-tester/README.md`](../../../cdp-tester/README.md).

Det er fase 2 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326), den agentiske funksjonstesten (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)). Den er obligatorisk, kommer etter testplanen og før den interne akseptansetesten, og kan også kjøres manuelt, uten testplan.

Fra strategien:

- **Mål:** bekrefte at hver funksjon virker som kravet sier, med gyldige og ugyldige data.
- **Omfang:** alle scenarioene leveransen har gjort `@implemented`, pluss testcasene du utleder fra reglene, også reglene `fs-verify` fant i koden uten scenario. Testplanen viser omfanget og teknikken per regel («Testcaser som skal lages»). Følg det, og si fra når du finner mer eller mindre enn planen.
- **Hva testes:** positiv testing (hvert scenario slik det står, en scenariomal gir én testcase per eksempel), negativ testing (ugyldige verdier, feil format, handlinger i feil rekkefølge, data som ikke finnes eller er slettet), og obligatoriske felt: hvert felt testes tomt, med bare mellomrom og med for lang verdi, og feilmeldingen kontrolleres.
- **Teknikk:** du velger teknikken ut fra regelen, og skriver hvilken som er brukt i testen: grenseverdianalyse (min, maks, like over og like under, tomt felt), ekvivalensklasser, beslutningstabeller for regler med flere betingelser, og tilstandsoverganger (for eksempel statusene til en søknad).
- **Ikke her:** roller, tilgangsstyring og datakonsistens verifiseres i koden i fase 1 (`fs-verify`). Scenarioene i kravet testes som de står, også synlighet for en rolle, men du utleder ikke egne testcaser for roller og tilgang. Flyter på tvers og avhengigheter testes i fase 3.
- **Utenfor kravet:** utleder du et tilfelle kravet ikke sier noe om, og løsningen oppfører seg uventet, er det et funn av typen «Kravet dekker ikke». Det avklares i kravet (`fs-krav`), ikke bare i testen.

- **Kravene er fasit for hva som testes.** Testene dekker gating-settet som er `@implemented` (også de leverte delene i et krav som er delvis levert), i rekkefølgen i feature-fila. Endre aldri kravene eller taggene i `krav/`. Er et scenario ikke testbart som det står (uklart, mangler forventet resultat, motsier koden), noter det i «Ikke kjørbart», og foreslå `fs-krav`.
- **Testene er varige.** De overlever testplaner og akseptansetester. Derfor har de nøkler for testbruker og testdata, aldri navn, Feide-ID eller `testbruker <nr>`, og ingen miljø-URL.
- **Testdataene står i testplanen.** Hver testdata-nøkkel har en `Utgangstilstand` i testplanen, og testen forutsetter at dataene finnes slik før kjøringen. Hvordan de lages og settes tilbake, er utenfor teststrategien. Data scenarioet selv lager (for eksempel «Opprett opptak»), får et unikt navn per kjøring når de ikke kan slettes, og data testen endrer, settes tilbake (R13).
- **Testene er verktøyuavhengige.** Gherkin-filene skal kunne leses og brukes av flere (agenter, testere, andre verktøy). Det som er spesifikt for CDP, står bare i «Før en kjøring» og i resultatmalen.
- **Agenten foreslår, mennesker godkjenner.** Agenten kan aldri godkjenne en leveranse. Testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene, etter en risikovurdering.
- **Samme grunnlag som resten av flyten.** Roller og testdata kommer fra testplanen, eller fra de samme spørsmålene når den mangler: [`.claude/references/akseptansetest/roller-og-testdata.md`](../../references/akseptansetest/roller-og-testdata.md). Spør aldri teamet om noe testplanen allerede svarer på.
- **Gjett aldri det bare teamet vet.** Det som mangler, står som `[Fylles ut: <hva>]`, og scenarioet kjøres ikke før det er utfylt.
- **Åpne spørsmål gater ikke.** Et scenario eller en regel med `@openquestion` (uten `@draft`) blir testcase som den står. Spørsmålet står i resultatet.
- **Overskriv aldri håndrettede scenarioer.** Finnes testfila fra før, vis en diff og foreslå.
- **Alltid et testmiljø, aldri produksjon.**
- **Publiser aldri til Confluence uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i stedet for `grep` og `git`, og skriv `commit ikke sjekket (Claude-panelet)` i headeren.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`cdp-tester/README.md`](../../../cdp-tester/README.md): mappestrukturen, Gherkin-reglene, referansene og «Krever».
2. [`references/mal-cdp.md`](references/mal-cdp.md): malene for testfila, `README.md` og resultatet.
3. [`.claude/references/akseptansetest/roller-og-testdata.md`](../../references/akseptansetest/roller-og-testdata.md): spørsmålene og kolonnene.
4. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): kravene i en testplan, og gating-settet.
5. [`.claude/references/akseptansetest/testcase-regler.md`](../../references/akseptansetest/testcase-regler.md): reglene for fase 2 i tabellen der (R1–R9 og R12–R16), blant annet R9 (feilsituasjoner), R13 (testen kan kjøres på nytt), R14 (følg stegene slik de står) og R16 (kjent mangel). R10 (avhengigheter mellom testcaser) og R11s regler for fase 3 og 4 gjelder ikke: CDP-scenarioene er uavhengige.
6. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

## 1. Avgjør måten

Argumentet avgjør:

| Argument | Måte |
|---|---|
| en testplan (`akseptansetest/<slug>`, eller en slug som finnes der) | **Fra testplanen (fase 2).** Kravene er de i «Omfang» i testplanen. Roller, testdata og miljø fra testplanens tabeller |
| krav: en feature-fil, en mappe, `@scope-<slug>`, en oppgave eller en Feature-ID | **Manuelt.** Kravene finnes etter *Finn kravene* i `krav-fra-testplan.md` |
| en flyt: en sti under `krav/_Flyter/`, eller en `@FLY-`-ID | **Manuelt, flyt.** Bare flyten (steg 2, punkt 4) |
| en eksisterende test i `cdp-tester/` | **Manuelt, oppdatering** (se steg 5) |

Er det uklart, spør (`AskUserQuestion`).

**Fra testplanen:** les `testplan.md`, og siden i Confluence når den finnes (teamet kan ha fylt ut mer der). Mangler testplanen tabellene for fase 2 (nøkler, «Testcaser som skal lages»), si det, og spør om den skal lages eller oppdateres først (`fs-testplan`), eller om du skal fortsette manuelt.

**Manuelt:** finn en testplan som dekker kravene (`grep -rl "<Feature-ID>" akseptansetest/*/testplan.md`, nyeste først), og bruk tabellene i den når den har kolonnen `Nøkkel`. Finnes ingen, spør du etter en konkret verdi per nøkkel (steg 3), og bruker svarene bare til denne kjøringen: de lagres ikke i testene. Foreslå `fs-testplan` for å lagre dem, men krev det ikke.

## 2. Finn scenarioene og ordene

1. Kravene og gating-settet per krav, som i `krav-fra-testplan.md`. Bare krav som er `@implemented` (og de leverte delene i et endret krav, og `@implemented`-delene i et krav som er delvis levert) blir tester. Manuelt på et krav som ikke er `@implemented`: si det, og spør om det skal lages likevel (testen kjøres ikke før kravet er levert).
2. Les verify-rapporten for kravene når den finnes. Et scenario som er `ikke funnet` eller `usikker` der, kommer i «Ikke kjørbart» til teamet har svart. **Regler i koden uten scenario** (valideringer og andre regler verify-rapporten har funnet, og som kravet ikke sier noe om) er input til utledede testcaser (punkt 6). Tilgangssjekkene i rapporten testes ikke her: de er verifisert i koden i fase 1.
3. **Ordene fra skjermen:** `testcaser-intern.md` når den finnes (ordene og verdiene, uten avhengighetene mellom casene), `<feature>.design.md` og skissene, og koden (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren): menyer, ruter, felt, knapper, `Så`-tekster og feilmeldinger. Se *Lese koden* i `roller-og-testdata.md`. Merk det du ikke finner, `[Sjekk begrep]`.
4. **Flytene.** Fra flyten: flytene i «Flyter» i testplanen. Manuelt: flytene som går gjennom kravene (*Finn flytene* i `krav-fra-testplan.md`), eller flyten brukeren oppga. Hvilke scenarioer som blir tester, avgjøres etter *Hele eller deler av flyten* i den samme fila. Det som ikke blir test, står i «Ikke kjørbart» med grunnen («fasen er ikke levert», «overleveringen er ikke funnet»).
5. **Hva agenten kan se:** noe som ikke finnes i miljøet, eller som ikke kan ses i skjermen, kommer i «Ikke kjørbart», med grunn.
6. **Utledede testcaser.** For hver `Regel:`, og for hver regel i koden uten scenario: bruk teknikken og de utledede testcasene fra «Testcaser som skal lages» i testplanen. Manuelt, eller når testplanen ikke har raden: velg teknikk ut fra regelen. Lag testcasene teknikken gir.
   - **Grenseverdianalyse** for tall, datoer og lengder: min, maks, like under og like over, og tomt felt.
   - **Ekvivalensklasser** for valg og kategorier: én verdi fra hver klasse, også en ugyldig.
   - **Beslutningstabell** for en regel med flere betingelser: én testcase per rad i tabellen. Ta tabellen med i `# Teknikk:`-kommentaren.
   - **Tilstandsoverganger** for noe som skifter status: gyldige overganger, og en ugyldig overgang som skal avvises.
   - **Obligatoriske felt:** for hvert obligatorisk felt som regelen eller skjemaet har, tre testcaser: tomt, bare mellomrom og for lang verdi. Feilmeldingen kontrolleres (R9 i `testcase-regler.md`). Finn de obligatoriske feltene og lengdene i koden eller i `<feature>.design.md`, og sjekk om feltet har en standardverdi (R5).
   - **Negativ testing:** ugyldige verdier, feil format, handlinger i feil rekkefølge, og handlinger på data som ikke finnes eller er slettet.
   - Hver slik testcase er `@utledet`, med `# Teknikk:` over scenarioet. Er det ikke grunnlag for en teknikk (regelen har ingen verdier eller betingelser), lag ingen testcase, og ikke finn på tilfeller for å fylle opp.
   - Slå sammen testcaser som sjekker det samme, og begrens antallet: grenseverdiene og de ugyldige klassene regelen faktisk har.

## 3. Nøkler: roller og testdata

1. Fra scenarioene (`Gitt`-stegene og rollene i kravet) og de utledede testcasene: lag nøklene for testbrukere og testdata, i kebab-case uten æ, ø og å. Skriv dem i seksjonen «Krever» i `cdp-tester/<sti>/README.md`, med en beskrivelse (ikke et navn), utgangstilstanden og hvilke scenarioer som bruker dem.
2. **Testdataene forutsettes.** Hver testdata-nøkkel er data som finnes i testmiljøet før kjøringen, i utgangstilstanden i testplanen. Hvordan de lages, er utenfor teststrategien, og står ikke i testene.
3. **Kjørbar flere ganger.** Data scenarioet selv lager og som ikke kan slettes, får et unikt navn per kjøring (for eksempel med tidspunktet), og søk etter dem bruker det unike navnet. Data testen endrer, settes tilbake i et avsluttende steg. Kan ikke miljøet settes tilbake, står det i testplanen, og `@endrer-data` hoppes over i kjøringen.
4. Slå opp hver nøkkel i testplanen (kolonnen `Nøkkel`, `Utgangstilstand` og `Brukes av`), eller spør etter en konkret verdi manuelt med spørsmålene i `roller-og-testdata.md`. Mangler nøkkelen i testplanen eller svaret, står den som `[Fylles ut: <hva>]` i oppsummeringen, og scenarioet kjøres ikke.
5. Stopp hvis en verdi ser ut som et ekte fødselsnummer eller et ekte navn.

## 4. Skriv testene

For hvert krav, skriv `cdp-tester/<kravets sti under krav/>/<samme filnavn som kravet>`, etter malen:

- Header med kravfila, commit og blob-hash (`git rev-parse origin/main:<sti>`), og hva den er generert fra. Taggene: `@TST-…` og `@depends-on-<Feature-ID>` på `Egenskap:`. For en test som går over flere domener: `cdp-tester/_Løp/<NN Prosess>/<test>.feature`, med ett `@depends-on-` per krav.
- **En flyt** blir `cdp-tester/_Løp/<NN Prosess>/<samme filnavn som flyten>.feature`, med prosessmappa fra `krav/_Flyter`. Headeren har flytfila. `@TST-<prosess>-<flyt>-NNN @depends-on-FLY-<prosess>-<flyt>-NNN` står på `Egenskap:`, og hver `Regel:` har de samme `@depends-on-` som fasen i flyten. Titlene er flytens. Tilstanden i `Gitt` er en testdata-nøkkel med en `Utgangstilstand` som er laget gjennom løsningen i fasen før (for eksempel en søknad som har fått tilbudsgaranti i tidligopptaket), ikke lagt inn direkte. Ellers tester scenarioet ikke overleveringen. `Så` sjekkes der den neste aktøren jobber.
- `Regel:`- og `Scenario:`-titlene identiske med kravets. En `Scenariomal:` gir én rad i `Eksempler:` per eksempel i kravet.
- `Gitt` har testbruker som nøkkel, start (menyvei eller URL, med ordene fra skjermen), og testdata som nøkler, i utgangstilstanden i «Krever». Aldri «fra forrige scenario».
- **Utledede testcaser** (steg 2, punkt 6) står under regelen, med `@utledet` og `# Teknikk:`, og tittelen `<regelens tittel>: <hva som prøves>`. Én feilsituasjon prøver én ting: alle andre obligatoriske felt er fylt ut, så det er feltet testcasen handler om som stopper lagringen, og `Så` sier at det er det eneste som mangler. Et forhåndsutfylt felt tømmes, det «står» ikke tomt.
- `Når`: én handling per steg, skjermens ord i «», alle verdier med.
- `Så`: noe agenten ser. Gjør kravets generelle `Så` konkret (en tekst, et antall, noe synlig eller borte). Lagrer scenarioet noe, åpnes siden på nytt før `Så`.
- `@endrer-data` på scenarioet når det endrer data, med avsluttende steg som setter tilbake. Taggen sier at oppryddingen er med, og scenarioet kjøres som alle andre (*Før en kjøring*).
- Scenarioer som ikke kan kjøres, står ikke i fila, men i «Ikke kjørbart» i `README.md`, med grunn og når det kan kjøres.

Sjekkliste før du viser fram:

| # | Sjekk |
|---|---|
| 1 | Hvert scenario i gating-settet er generert eller står i «Ikke kjørbart» |
| 2 | Ingen filer i `krav/` er endret, og ingen test ligger der |
| 3 | Ingen testfil har navn, Feide-ID, `testbruker <nr>`, passord eller miljø-URL |
| 4 | Hvert scenario er uavhengig, og har en `Så` agenten kan se |
| 5 | Referansene er sjekket (se under) |
| 6 | Det som må fylles ut, er merket `[Fylles ut …]` eller `[Sjekk begrep]`, og står i oppsummeringen |
| 7 | Hver testdata-nøkkel har en utgangstilstand, og testen kan kjøres på nytt (unike navn eller opprydding) |
| 8 | Hver utledede testcase har `@utledet` og `# Teknikk:`, og hver feilsituasjon prøver én ting |
| 9 | Ingen utledet testcase tester roller, tilgangsstyring eller datakonsistens (fase 1), eller flyter på tvers (fase 3, bortsett fra testene i `_Løp/`) |
| 10 | Testcasene stemmer med «Testcaser som skal lages» i testplanen, og avvikene står i oppsummeringen |
| 11 | Hver «Kjent mangel» har en sak, og saken er sjekket (R16) |

**Referansesjekken** (ved hver generering og oppdatering):

1. Hver `@depends-on-` og `@ref-` peker på en Feature-ID (eller en flyt-ID) som finnes i nøyaktig én feature-fil under `krav/`.
2. Hver `Regel:` og hvert `Scenario:` finnes i den fila med samme tittel.
3. Hash i headeren er lik hash for kravfila nå. Er den ulik, er testen utdatert (se steg 5).
4. Hvert scenario i gating-settet er generert eller står i «Ikke kjørbart».

## 5. Oppdatere eksisterende tester

Finnes testfila fra før:

1. Sammenlign blob-hashen i headeren med kravfila nå. Er de like, og ingen nye `@implemented`-scenarioer er kommet til (heller ikke nye `@implemented`-deler i et krav som er delvis levert), er det ingenting å gjøre.
2. Ellers, list hva som er endret i kravet: nye, endrede og fjernede `Regel:` og `Scenario:`, med titlene (`git diff <commit-i-headeren>..origin/main -- <kravfila>`).
3. Vis forslaget som en diff mot testfila. Scenarioer som er rettet for hånd (andre steg enn skillen ville skrevet), nevnes, og skrives aldri over uten ja.
4. Skriv det brukeren godkjenner, og oppdater headeren (commit, hash, dato) og «Krever» og «Ikke kjørbart».
5. Fjernede krav: foreslå å slette testen, men slett aldri uten ja.

## 6. Vis fram

Vis en kort oppsummering: antall tester og scenarioer generert (og endret, ved oppdatering), antall `@utledet` og teknikkene som er brukt, antall `@endrer-data`, avvik fra omfanget i testplanen, kjente mangler og status på sakene (R16), antall scenarioer og regler med åpne spørsmål, «Ikke kjørbart» med grunner, nøklene som mangler og det som må fylles ut. Skriv aldri til Confluence uten ja.

Si hva som er neste steg: testplanen gjennomgås av teamet og testansvarlig før kjøringen (er det ikke gjort, si det). Så kjører agenten testene med `cdp`-skillen (se *Før en kjøring*, og *`cdp`-skillen* i `cdp-tester/README.md`), og følger stegene slik de står (R14). Lenk til testene i «Vedlegg» i testplanen. Testansvarlig har ansvaret for at agenten blir kjørt og tester riktig, men selve kjøringen kan gjøres av andre. Etterpå: `fs-testrapport` (agentisk). Rapporten er inngangskriteriet til intern akseptansetest (fase 3): alle testcasene er kjørt, ingen funn med alvorlighetsgraden «Stopper» står åpne, og testansvarlig har gått gjennom rapporten.

## Før en kjøring

`cdp`-skillen (`.claude/skills/cdp`) har ingen sikkerhetsregler. Reglene under gjelder for agenten som kjører testene, og står her fordi det er `fs-testcaser-cdp` som lager det som kjøres:

- **Miljø-guard.** Før første handling: sjekk at URL-en er testmiljøet fra testplanen (eller det brukeren oppga), og avbryt hvis den er produksjon eller et annet domene enn FS Admin og Feide.
- **Alt kjøres, mot et miljø som kan settes tilbake.** Testdataene er satt tilbake før kjøringen (forutsetning i testplanen), og testene rydder etter seg, så scenarioene med `@endrer-data` kjøres som alle andre. Er det avklart i testplanen at miljøet ikke kan settes tilbake, hoppes de over (og står i «Hoppet over» i resultatet) til brukeren ber om dem. Testbrukerne og andre data enn de testen selv har laget, endres aldri.
- **Forbudte kall.** Aldri `Fetch.*`, `Network.setCookie(s)`, `Storage.clear*` eller `clearBrowserCookies`, og aldri `handleJavaScriptDialog({accept:true})` uten at scenarioet sier hva dialogen er (eksemplene i `dialogs.md` aksepterer alt).
- **Tilkobling.** `cdp`-skillen kobler til brukerens kjørende Chrome (`chrome://inspect/#remote-debugging`, brukeren klikker Allow), og agenten ser alle cookies i profilen. Bruk en egen Chrome-profil per testbruker (`--user-data-dir`), og la brukeren logge inn med Feide testbruker selv. Bytte av testbruker er bytte av profil, ikke cookies.
- **Bevis.** Hver testcase lagrer steg, input, faktisk resultat og skjermbilde eller logg, så et menneske kan etterprøve resultatet. Tekst og DOM (`Runtime.evaluate`) er primærbevis, skjermbilder sekundære. Tell rader i skjermen, ikke via GraphQL: et direkte API-kall kan gi flere rader enn løsningen viser. Resultatet skrives til `akseptansetest/<slug>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md` (med testplan), eller `cdp-tester/<sti>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md` (uten), aldri til `/tmp` (se malen). Skjermbilder legges i samme mappe, men er ignorert av git (`.gitignore`): bare `resultat.md` committes, og den viser til bildene som «lokalt, ikke i git». Den som kjører agenten, legger skjermbildene som vedlegg på siden med den agentiske testrapporten (`fs-testrapport`, agentisk), før testansvarlig går gjennom funnene, så de kan etterprøves.
- **Følg stegene slik de står** (R14). Virker ikke et steg, eller finnes ikke en verdi, er det et funn, og testcasen blir «Ikke testet». Agenten prøver seg ikke fram en annen vei.
- **Funn.** Et funn har typen «Feil» eller «Kravet dekker ikke» (en utledet testcase der kravet ikke sier noe om tilfellet), «Fase funnet» 2, og alvorlighetsgrad fra testansvarlig (`alvorlighetsgrad.md`). «Kravet dekker ikke» avklares i kravet (`fs-krav`), ikke bare i testen.
- **Installasjon.** `cdp`-skillen er ikke en del av repoet: hver bruker installerer den (`.claude/skills/cdp` er ignorert av git, se *`cdp`-skillen* i `cdp-tester/README.md`). Mangler skillen, `bun` eller `browser-harness-js`, vis veiledningen i `cdp-tester/README.md` (*`cdp`-skillen*), og installer ikke noe uten at brukeren sier ja.
- **Foreslå, ikke fyll ut.** Agenten skriver foreslått status. En tester bekrefter den, og testansvarlig tar stikkprøver av de beståtte testcasene etter en risikovurdering (ikke et fast antall). Ingen «Status» på testcaser eller i testrapporten fylles ut av agenten, og agenten kan ikke godkjenne leveransen.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene, scope-fila eller `oppgave.md`.
- Kjører ikke testene. Den lager og oppdaterer dem, og sier hvordan de kjøres.
- Lager ikke testdata. Testdataene står i testplanen, og prosessen med å lage dem er utenfor teststrategien.
- Lager ikke testcasene for fase 3 og 4 (`fs-testcaser-intern`, `fs-testcaser-ekstern`), testplanen (`fs-testplan`) eller rapportene (`fs-testrapport`).
- Utleder ikke testcaser for roller, tilgangsstyring eller datakonsistens (fase 1, `fs-verify`), og ikke flyter på tvers (fase 3), bortsett fra overleveringene i `_Løp/`.
- Kjører aldri git add/commit/push, og kjører aldri `git pull` i kodeklonene.
