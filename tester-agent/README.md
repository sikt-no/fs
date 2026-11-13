# Agenttester

Varige tester som en agent kjører i Chrome mot et testmiljø, i den agentiske funksjonstesten (fase 2 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326)). De er skrevet som Gherkin, og kan brukes av flere verktøy. Agenten i fase 2 kjører dem med Vibium (se *Vibium*). De er ikke krav: kravene i [`krav/`](../krav/README.md) sier *hva* som skal gjelde, og her står *hvordan* det sjekkes i skjermen, med skjermens ord og konkrete verdier. Testene lages og oppdateres med skillen `fs-testcaser-agent`, fra kravene. De kjenner ikke til testplaner eller akseptansetester: en testplan kan velge hvilke tester som lages og kjøres, men testene og `README.md`-ene her viser aldri til den.

Testene dekker alle scenarioene som er `@implemented`, pluss testcaser agenten utleder fra reglene: negativ testing, obligatoriske felt og grenseverdier. Roller, tilgangsstyring og datakonsistens verifiseres i koden i fase 1 (`fs-verify`). Scenarioene i kravet testes som de står, også synlighet for en rolle, men det lages ikke egne testcaser for roller og tilgang.

Mappa ligger ved siden av `krav/` og ikke under den, fordi konvensjonene for krav forbyr UI-ord og data i steg, og kravstatusene (`@draft` … `@implemented`) ikke passer for en test. `bddgen` leser bare `../krav/**/*.feature`, så filene her kjøres ikke av Playwright.

## Struktur

```
tester-agent/
├── README.md                                   # dette dokumentet
├── package.json, package-lock.json, .mise.toml # Vibium og Node (se Vibium)
├── .env.example                                # Feide-testbrukeren (kopieres til .env, som er ignorert)
├── _Løp/<NN Prosess>/<test>.feature            # tester på tvers av domener
├── _Miljøer/<miljø>.md                         # personaene og grunndataene for ett testmiljø (se Miljøfila)
├── _Oppsett/<sti speilet fra krav/>/oppsett.feature  # lager testdataene i hver kjøring (se Oppsettet)
└── <sti speilet fra krav/>/
    ├── <test>.feature
    └── README.md                               # «Krever»: nøklene testene i mappa bruker
```

- **Speilet sti:** en test av ett krav ligger under samme mappesti som kravfila har under `krav/`, så testen finnes fra kravet. Filnavnet er det samme som kravfila.
- **`_Løp`:** en test som går over flere domener, som en flyt. Prosessene er nummerert og navngitt som i `krav/_Flyter`. En test av en flyt har samme filnavn som flyten, og `@depends-on-FLY-…`. Den sjekker overleveringene: tilstanden i `Gitt` er laget gjennom løsningen i fasen før, ikke lagt inn direkte.
- **`_Miljøer`:** én fil per testmiljø, med personaene, grunndataene og verdiene til nøklene testene ikke kan lage (se *Miljøfila*).
- **`_Oppsett`:** ett oppsett per mappe med tester, på den samme stien. Det lager testdataene testene i mappa bruker, i hver kjøring (se *Oppsettet*).
- **`README.md` i mappa** har tittelen, lenken til kravet og **Krever** (se under). Ikke noe mer: det som gjelder alle testene, står her.

## Gherkin-regler for testene

- `# language: no`. Én `Egenskap:` per krav. `Regel:`- og `Scenario:`-titlene er identiske med kravets, så tittelen er referansen til kravet.
- **Uavhengige scenarioer.** Hvert scenario starter fra en kjent tilstand, og bygger aldri på et annet scenario.
- **Testene lager dataene sine.** Data i testmiljøet kan slettes eller nullstilles når som helst, så testene bygger aldri på data fra en tidligere kjøring. Oppsettet lager testdataene i hver kjøring, gjennom løsningen (se *Oppsettet*), og scenarioet lager selv det bare det trenger. Alt som lages, har et unikt navn per kjøring (`{KJØRING}`), og data som deles med andre scenarioer i kjøringen, settes tilbake når scenarioet endrer dem. Bare grunndata (personaer, kodeverk, organisasjoner, regelverkssamlinger) og data testene ikke kan lage gjennom løsningen, står i miljøfila.
- **Utledede testcaser.** Hver `Regel:` får i tillegg testcaser agenten utleder (negativ testing, obligatoriske felt, grenseverdier). De har tittelen `<tittel på regelen>: <hva som prøves>`, og tekniken som er brukt (grenseverdianalyse, ekvivalensklasser, beslutningstabell eller tilstandsoverganger) står i en `# Teknikk:`-kommentar over scenarioet. De hører til regelen, men finnes ikke i kravet, så de merkes `@utledet`. Viser en utledet testcase en oppførsel kravet ikke sier noe om, er det et funn av typen «Kravet dekker ikke».
- **Nøkler, ikke personer.** `Gitt` har testbruker og testdata som nøkler i «»: `Gitt jeg er logget inn som «brukeradministrator-alle-miljoer»`. Ingen navn, Feide-ID, `testbruker <nr>` eller passord i testfilene. Nøkkelen beskriver rollen og relasjonen scenarioet trenger (`opptak-forvalter-deltakende`), aldri organisasjonen, personen eller året (se *Nøkkelen* i `.claude/references/akseptansetest/roller-og-testdata.md`). Nøklene slås opp i miljøfila (se *Miljøfila*).
- **Skjermens ord og konkrete verdier.** Menyer, felt, knapper og tekster i «», én handling per steg. `Så` er noe agenten ser: en tekst, et antall, noe som er synlig eller ikke. Ikke «filtreres listen til …».
- **Endrer data:** `@endrer-data` på scenarioet, med avsluttende steg som setter tilbake. Taggen sier at scenarioet endrer data, så oppryddingen er med. Scenarioene kjøres som alle andre, mot et testmiljø der testdata kan settes tilbake. Uten et slikt miljø (miljøfila sier det) hoppes de over, og står i «Hoppet over» i resultatet.
- **Datoer i forhold til testdagen.** `{DATO:+N}` er datoen N dager etter dagen kjøringen starter, og `{DATO:-N}` N dager før. Fristene står slik, så tilstanden er den samme uansett når testen kjøres.
- **Organisasjoner som nøkler.** Et steg som trenger organisasjonen til en testbruker eller et testdata, bruker `{ORG:<nøkkel>}` (forkortelsen), `{ORGNAVN:<nøkkel>}` (navnet på bokmål) eller `{ORGKODE:<nøkkel>}` (organisasjonskoden): `Og jeg velger «Fjern {ORG:opptak-forvalter-deltakende}»`. Agenten slår dem opp i miljøfila: forkortelsen, navnet og koden står på personaen nøkkelen er koblet til, eller på testdataene. `{KJØRING}` er tidspunktet for kjøringen. Ingen navn på organisasjoner i stegene, bortsett fra det skjermen alltid viser, uansett miljø.
- **Miljø står ikke i filene.** URL, versjon og feature-flagg står i miljøfila. Det er alltid et testmiljø, aldri produksjon.
- **Bare det som varer.** Testene og `README.md` i mappa skal kunne kjøres om et halvt år. De har ikke status for kravet eller leveransen, kjente mangler, saker med status, resultater fra verifiseringen eller en kjøring, henvisninger til en testplan eller testcaser i den, eller verdier som bare gjelder ett miljø. Verdiene står i miljøfila, og resten i resultatet av kjøringen eller utenfor `tester-agent/`. Kommentarer om hvordan et steg tas, hva skjermen viser, og avklaringer og åpne spørsmål i kravet er greit: de følger kravet, og blob-hashen i headeren sier når de er utdaterte.
- **Ingen kravstatus.** Filene har ingen `@draft`, `@planned`, `@in-progress`, `@implemented` eller `@deprecated`, og ingen `@scope-`.

## Referanser til kravene

Hver test peker på kravet den sjekker, med taggene fra [`krav/README.md`](../krav/README.md) (*Referanser*), og en header med hva den er generert fra:

```gherkin
# language: no
# Generert av fs-testcaser-agent <YYYY-MM-DD>
# Krav: krav/<sti>/<fil>.feature @ <commit> (blob <hash>)
@TST-<DOM>-<SUB>-<KAP>-NNN @depends-on-<Feature-ID>
Egenskap: <tittelen i kravet>
```

- `@depends-on-<Feature-ID>` på `Egenskap:` (gjelder hele fila), eller på `Regel:`/`Scenario:` når en del bygger på andre krav. Testen må sjekkes når kravet endres, og det er det taggen sier. `@ref-<Feature-ID>` for et krav testen bare bruker som forutsetning.
- `@TST-…` er testens egen ID: `@TST-<DOM>-<SUB>-<KAP>-NNN` for en speilet sti, `@TST-<prosess>-<test>-NNN` for `_Løp` (samme formater som Feature-ID og `@FLY-`).
- Headeren har kravfila, commiten og blob-hashen (`git rev-parse origin/main:<sti>`). Er hashen ikke lik kravfilas nå, er testen utdatert, og `fs-testcaser-agent` viser forskjellen som en diff i stedet for å skrive over.

Finn testene for et krav: `grep -rn "@depends-on-<Feature-ID>" tester-agent/`.

## «Krever» i README.md

Hver mappe med tester sier hvilke nøkler testene bruker, og hvilke scenarioer som bruker dem. Det er denne seksjonen som stilles opp mot miljøfila før en kjøring.

```markdown
## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `brukeradministrator-alle-miljoer` | testbruker | alle scenarioer |
| `personbruker-over-50` | testdata | «Liste viser de 50 første personbrukerne» |
| `opptak-samordna-uten-utdanningstilbud` | testdata (oppsett) | de fleste scenarioene |
```

Typen er `testbruker`, `testdata (oppsett)` (laget av oppsettet i kjøringen) eller `testdata` (grunndata, eller data testene ikke kan lage, i miljøfila). Hva nøkkelen krever, står ett sted: i miljøfila, i «Krever» for en testbruker og i «Utgangstilstand» for testdata der, og i scenarioet med nøkkelen i oppsettet for `testdata (oppsett)`. En testbruker beskrives med rollen og det scenarioet krever av organisasjonen («`OPPTAK_FORVALTER` ved en organisasjon som ikke er deltaker i testdata-opptakene»), ikke organisasjonen. Testdata beskrives med egenskapene, ikke verdien i ett miljø: «Regelverkssamling som kan velges i et samordna opptak», ikke «UHGTEST2026». Beskrivelsen er den samme i alle miljøfilene.

Alle scenarioene i gating-settet blir tester. Mangler testdataene i et miljø, eller kan et steg ikke tas, er det kjøringen som viser det: testcasen blir «Ikke bestått» eller «Ikke testet», med grunnen i resultatet.

## Oppsettet

`_Oppsett/<sti>/oppsett.feature` lager testdataene testene i `<sti>/` bruker. Det kjøres først i hver kjøring, før testene.

- **Ett scenario per nøkkel.** Tittelen er nøkkelen, og scenarioet lager dataene gjennom løsningen, med `{KJØRING}` i navnet og datoene som `{DATO:±N}`, og sjekker at tilstanden er riktig. Siste steg skriver navnet og URL-en i «Kjøringens testdata» i resultatet.
- **Testene slår opp nøkkelen** i «Kjøringens testdata» i resultatet for kjøringen. Testfilene bruker de samme nøklene som før (`«opptak-samordna-uten-utdanningstilbud»`), og vet ikke om dataene er laget av oppsettet.
- **Feiler et scenario i oppsettet**, får nøkkelen ingen verdi, og testene som bruker den, blir «Ikke testet», med grunnen i resultatet. Det er et funn.
- **Uavhengige scenarioer.** Testene bygger på oppsettet, ikke på hverandre. Et scenario som endrer data fra oppsettet, setter dem tilbake (`@endrer-data`), eller lager sine egne.
- Oppsettet har ingen `@TST-` og ingen `@depends-on-`, men `@OPPSETT-<DOM>-<SUB>` og `@ref-<Feature-ID>` til kravene det bruker. Det er ikke en test: et oppsett som feiler, er et funn, ikke et resultat for et krav.

## Miljøfila

`_Miljøer/<miljø>.md` (for eksempel [`_Miljøer/test.md`](_Miljøer/test.md)) er den autoritative oversikten over ett testmiljø: hvilke testpersoner og roller som finnes i FS Admin, og hva nøklene i testene er i miljøet. Det er det eneste stedet verdiene slås opp når testene kjøres. Den committes, deles av alle som kjører testene, og vedlikeholdes jevnlig (se *Vedlikehold av miljøfila*).

- **Øverst:** URL-en til FS Admin, hvordan testbrukeren byttes, om testdataene kan settes tilbake, og når personaene sist ble sjekket.
- **Feature-flagg:** `Flagg | Står | Sjekket`.
- **Personaer:** `Rad i «Overstyrt bruker» | Rolle | Organisasjon | Organisasjonskode | Forkortelse`. Alle radene i menyen, ikke bare dem testene bruker. Menyen har én rad per tildeling i `testpersoner` (person, rolle og organisasjon). Raden skrives nøyaktig som i menyen, og forkortelsen og organisasjonen som i organisasjonsregisteret.
- **Testbrukere:** `Nøkkel | Krever | Persona (rad i «Overstyrt bruker»)`. Hva testen krever av testbrukeren, og koblingen til en persona. Organisasjonen til testbrukeren (`{ORG:<nøkkel>}`) er organisasjonen til personaen. Byttes personaen, endres bare denne raden.
- **Testdata:** `Nøkkel | Verdi i <miljø> | Søk/URL | Utgangstilstand | Sjekket`. Bare grunndata (kodeverk, organisasjoner, regelverkssamlinger) og data testene ikke kan lage gjennom løsningen. Verdien er det testen skriver eller søker på i miljøet, og utgangstilstanden er det testen forutsetter. Testdataene oppsettet lager, står ikke her, men i oppsettet.
- Ingen passord, hemmeligheter eller fødselsnumre, og bare Feide testbrukere og syntetiske personer.
- En nøkkel har samme betydning i alle miljøfilene. Mangler en verdi, står den som `[Fylles ut]`, og scenarioene som bruker den, blir «Ikke testet» i kjøringen.
- `fs-testcaser-agent` legger nye nøkler inn i fila når brukeren sier ja. En kjøring som finner at en verdi ikke stemmer, sier det i resultatet, og foreslår endringen.

### Vedlikehold av miljøfila

Personaene og tildelingene endres i fs-admin og tilgangsstyring, uavhengig av testene. Sjekk fila jevnlig, og alltid før en kjøring når «Personaer sist sjekket» er mer enn en måned gammel:

1. **Personaene.** Kjør spørringen `testpersoner` i miljøet (for eksempel i GraphiQL i FS Admin), eller kopier svaret fra nettverksfanen når «Overstyrt bruker» åpnes. Personavelgeren i fs-admin lager én rad per tildeling (`useTestpersonaer.ts` og `personaOption.ts` under `src/features/EnvironmentIndicator/Personas/`): `<FORNAVN> <ETTERNAVN> • <tilgangskode> (<forkortelse, ellers navnet på organisasjonen>)`. Lag tabellen på nytt fra svaret: legg til nye rader, og fjern dem som er borte.

   ```graphql
   query GetTestpersoner {
     testpersoner(first: 100) {
       nodes {
         navn { fornavn etternavn }
         tildelinger {
           tilgangskode
           organisasjon { organisasjonskode forkortelse navnAlleSprak { nb } }
         }
       }
     }
   }
   ```

2. **Rollene.** Hver rad gir bare den ene rollen, og rollene den gir i rollekatalogen (`tilgangsroller`, som `GET_ROLLEHIERARKI` i fs-admin). En testbruker som trenger to roller, må ha en rolle som gir den andre.
3. **Testbrukerne.** Hver nøkkel peker på en persona som finnes, og har tildelingene beskrivelsen i «Krever» sier. Er raden borte, eller gir den ikke rollene, foreslå en annen persona fra tabellen, eller si at en persona må legges til i fs-admin og tildelingen i tilgangsstyring.
4. **Grunndataene og flaggene.** Sjekk at verdiene finnes, i utgangstilstanden.
5. Oppdater «Personaer sist sjekket» med datoen, og «Sjekket» på testdataene og flaggene som er sjekket.

Skriv aldri fødselsnummeret i fila: personaen velges i menyen.

## Vibium

Testene kjøres med [Vibium](https://github.com/VibiumDev/vibium), CLI-en `vibium`. Vibium styrer nettleseren med WebDriver BiDi, og starter sin egen nettleser (Chrome for Testing, med en midlertidig profil) i stedet for å koble til den du bruker ellers. CLI-en snakker med nettleseren gjennom en lokal socket, ikke en åpen port. `fs-testcaser-agent` trenger ikke Vibium for å lage eller oppdatere testene, bare for å kjøre dem.

Vibium installeres i denne mappa, med versjonen i `package.json` og `package-lock.json`, så alle kjører den samme. Ingenting installeres globalt. Kommandoene kjøres fra `tester-agent/`, med `npx vibium …` (eller `npm run …`). De gjelder versjonen her: dokumentasjonen på GitHub (`main`) beskriver også kommandoer som ikke er sluppet ennå (`setup`, `ready`, `run`, `--user-data-dir`).

1. Installer: `cd tester-agent && ~/.local/bin/mise exec -- npm install` (Node fra `.mise.toml`). npm kjører ikke installasjonsskriptet til Vibium uten at du sier ja, så last ned Chrome for Testing med `npm run vibium:install`. `npx vibium paths` viser hvor den ligger (`~/Library/Caches/vibium` på macOS, delt mellom klonene).
2. Kopier `.env.example` til `.env`, som er ignorert av git.
3. Skillen er valgfri: `npx vibium add-skill` legger den i `~/.claude/skills/vibe-check/`, utenfor repoet. Agenten kan også bruke CLI-en direkte (`npx vibium --help`).
4. Start nettleseren i en egen sesjon til testingen: `npm run vibium:start` (`vibium --session fs-test daemon start --idle-timeout 0`, og åpner FS Admin i TEST). Profilen er midlertidig, så innloggingen varer så lenge nettleseren kjører. Uten `--idle-timeout 0` stopper den etter 30 minutter uten kommandoer, og da må du logge inn på nytt. Sett `VIBIUM_SESSION=fs-test` i skallet for alle kommandoene i kjøringen, ikke `--session`: i 26.8.21 ignorerer `fill`, `type`, `geolocation` og `sleep` flagget, og går til en annen nettleser ([#482](https://github.com/VibiumDev/vibium/issues/482), rettet på `main`, ikke sluppet). `daemon start` og `daemon stop` i scriptene tar flagget riktig.
5. Logg inn med Feide-testbrukeren, i vinduet Vibium åpner (det er synlig): «Logg inn med Feide», «Feide test users», brukernavn og passord. Brukernavnet og passordet står i `.env` (`FS_ADMIN_USERNAME` og `FS_ADMIN_PASSWORD`, de samme som i `tester/.env.example`). Agenten kan logge inn, eller du kan gjøre det selv. FS Admin logger ut etter en stund, og varsler 10 minutter før. Testbrukeren byttes i «Overstyrt bruker» øverst til høyre i FS Admin, som er normalen i TEST, med personaen i miljøfila.
6. Avslutt med `npm run vibium:stop` når kjøringen er ferdig. Profilen og innloggingen slettes.

Vibium har ingen egne sikkerhetsregler for testmiljøet. Reglene for kjøringen står under, i *Regler for kjøringen*.

## Kjøring og resultat

Testene kjøres av en agent, mot miljøfila for testmiljøet. Oppsettet for mappa kjøres først, og agenten skriver det som er laget, i «Kjøringens testdata» i resultatet. Kjører flere agenter samme kjøring, bruker de det samme oppsettet. Den som starter kjøringen, sier hvilke tester som kjøres (en mappe, en fil eller en liste) og hvor resultatet legges. Sier den ikke noe, legges resultatet ved testene: `tester-agent/<mappa med testene>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md`, eller i den nærmeste felles mappa når kjøringen går over flere. Hører kjøringen til en akseptansetest, sier [`akseptansetest/README.md`](../akseptansetest/README.md) hvor resultatet legges.

Resultatet følger malen i [`mal-agent.md`](../.claude/skills/fs-testcaser-agent/references/mal-agent.md) (*Resultat av en kjøring*). Bevisene er steg, input, faktisk resultat og skjermbilde eller logg for hver testcase. Skjermbildene legges i samme mappe, men er ignorert av git (`.gitignore`): bare `resultat.md` committes. Resultatet lagres i Confluence når brukeren sier ja.

Agenten foreslår status, og kan aldri godkjenne en leveranse. En tester bekrefter foreslått status, og testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene, etter en risikovurdering. Agenten fyller aldri ut «Status» på testcasene eller i en testrapport.

### Regler for kjøringen

Disse gjelder for agenten som kjører testene:

- **Miljø-guard.** Før første handling: sjekk at URL-en er FS Admin eller Min kompetanse i miljøfila, og avbryt hvis den er produksjon eller et annet domene enn de to, Feide og ID-porten test (TestID).
- **Kravene er de samme.** Sammenlign blob-hashen i headeren med kravfila nå (`git rev-parse origin/main:<sti>`). Er den ulik, si det, og foreslå å oppdatere testene først (`fs-testcaser-agent`). Er et krav ikke `@implemented` (les taggen), står det i resultatet: scenarioer som ikke er levert, vil trolig ikke bestå.
- **Miljøfila er oppdatert.** Er «Personaer sist sjekket» mer enn en måned gammel, eller mangler en nøkkel testene bruker, si det før kjøringen (se *Vedlikehold av miljøfila*).
- **Data som endres.** Testene endrer bare data som er laget i kjøringen (av oppsettet eller scenarioet selv). Scenarioene med `@endrer-data` setter dataene fra oppsettet tilbake, så de andre scenarioene finner dem i utgangstilstanden. Testbrukerne, grunndataene og data fra andre kjøringer endres aldri.
- **Forbudte kommandoer.** Aldri `vibium cookies <navn> <verdi>`, `vibium cookies clear`, `vibium storage restore` eller `vibium content`, og aldri `vibium dialog accept` uten at scenarioet sier hva dialogen er. Aldri `vibium serve` eller `vibium mcp`: kjøringen bruker bare CLI-en. Får en senere versjon kommandoer som sender skjerminnholdet til en AI-leverandør (`vibium run`, `VIBIUM_AI_*` på `main`), brukes de ikke: de finner sin egen vei, som bryter med R14.
- **Tilkobling og innlogging.** Bruk nettleseren Vibium starter i sesjonen til testingen (se *Vibium*), aldri `vibium start <url>`, `--connect` eller `VIBIUM_CONNECT_URL` mot en annen nettleser. Logg inn med Feide-testbrukeren i `tester-agent/.env`, aldri med en personlig Feide-bruker. En søker i Min kompetanse logges inn med TestID i ID-porten test, slik miljøfila beskriver, og får en ny syntetisk person hver gang. Skriv aldri ut passordet (ikke i resultatet, loggen eller et skjermbilde), og lagre aldri innloggingen i en fil (`vibium storage -o`).
- **Bytte testbruker.** Agenten bytter i «Overstyrt bruker» til personaen nøkkelen er koblet til i miljøfila, før hvert scenario der testbrukeren er en annen, og sjekker at riktig persona er valgt før første steg, også når forrige scenario sluttet som en annen. Med Feide-innlogging per testbruker har hver testbruker sin egen sesjon (`VIBIUM_SESSION`), og bytte av testbruker er bytte av sesjon. Bytt aldri testbruker ved å endre cookies.
- **Følg stegene slik de står** (R14 i [`testcase-regler.md`](../.claude/references/akseptansetest/testcase-regler.md)). Virker ikke et steg, eller finnes ikke en verdi, er det et funn, og testcasen blir «Ikke testet». Agenten prøver seg ikke fram en annen vei.
- **Handlinger i skjermen.** Ta stegene med `click`, `fill`, `type`, `select`, `press` og `keys`, som er ekte klikk og tastetrykk, med sesjonen i `VIBIUM_SESSION` (se *Vibium*). Bruk aldri `--help` på `fill` eller `type` i 26.8.21: kommandoen kjøres i stedet ([#423](https://github.com/VibiumDev/vibium/issues/423)). `vibium eval` er bare til å lese bevis, aldri til å fylle ut eller klikke, for da tas ikke steget slik det står. Unntaket er innloggingen, som ikke er et teststeg.
- **`map` er ikke bevis.** `vibium map` gir referansene (`@e1`), men kan vise gammel tekst etter en endring i siden. Bevis med `text`, `eval` eller et skjermbilde. FS Admin har skjulte dialoger i siden, så les den synlige overskriften, ikke den første `h1`.
- **Verdier som ikke stemmer.** Finnes ikke en verdi fra miljøfila i miljøet, er testcasen «Ikke testet», og resultatet foreslår endringen i miljøfila. Agenten endrer ikke miljøfila under kjøringen.
- **Bevis.** Tekst og DOM (`vibium text`, `vibium eval`, `vibium a11y-tree`) er primærbevis, skjermbilder (`vibium screenshot -o <kjøringsmappa>/<fil>.png`) sekundære. Et opptak (`vibium record start` og `vibium record stop`, lagret i kjøringsmappa) kan legges ved, og er ignorert av git som skjermbildene. Tell rader i skjermen, ikke via GraphQL: et direkte API-kall kan gi flere rader enn løsningen viser. Skriv aldri til `/tmp`.
- **Kjente mangler** er ikke en del av testene. Gir den som starter kjøringen en liste over kjente mangler, sjekkes sakene før kjøringen, og de står i resultatet. Ellers er et scenario som ikke består, et funn.
- **Funn.** Et funn har typen «Feil» eller «Kravet dekker ikke» (en `@utledet` testcase der kravet ikke sier noe om tilfellet), og alvorlighetsgrad fra testansvarlig ([`alvorlighetsgrad.md`](../.claude/references/akseptansetest/alvorlighetsgrad.md)). «Kravet dekker ikke» avklares i kravet (`fs-krav`), ikke bare i testen.
- **Installasjon.** Mangler `node_modules` i `tester-agent/` eller Chrome for Testing (`npx vibium is-installed`), eller er versjonen (`npx vibium version`) en annen enn i `package.json`, vis veiledningen der, og installer ikke noe uten at brukeren sier ja.
