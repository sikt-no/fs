# CDP-tester

Varige tester som en agent kjører i Chrome mot et testmiljø, i den agentiske funksjonstesten (fase 2 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326)). De er skrevet som Gherkin, og kan brukes av flere verktøy. Agenten i fase 2 kjører dem med `cdp`-skillen (`.claude/skills/cdp`). De er ikke krav: kravene i [`krav/`](../krav/README.md) sier *hva* som skal gjelde, og her står *hvordan* det sjekkes i skjermen, med skjermens ord og konkrete verdier. Testene lages og oppdateres med skillen `fs-testcaser-cdp`, fra kravene, og de overlever testplaner og akseptansetester.

Testene dekker alle scenarioene som er `@implemented`, pluss testcaser agenten utleder fra reglene: negativ testing, obligatoriske felt og grenseverdier. Roller, tilgangsstyring og datakonsistens verifiseres i koden i fase 1 (`fs-verify`). Scenarioene i kravet testes som de står, også synlighet for en rolle, men det lages ikke egne testcaser for roller og tilgang.

Mappa ligger ved siden av `krav/` og ikke under den, fordi konvensjonene for krav forbyr UI-ord og data i steg, og kravstatusene (`@draft` … `@implemented`) ikke passer for en test. `bddgen` leser bare `../krav/**/*.feature`, så filene her kjøres ikke av Playwright.

## Struktur

```
cdp-tester/
├── README.md                                   # dette dokumentet
├── _Løp/<NN Prosess>/<test>.feature            # tester på tvers av domener
└── <sti speilet fra krav/>/
    ├── <test>.feature
    └── README.md                               # «Krever» og «Ikke kjørbart» for testene i mappa
```

- **Speilet sti:** en test av ett krav ligger under samme mappesti som kravfila har under `krav/`, så testen finnes fra kravet. Filnavnet er det samme som kravfila.
- **`_Løp`:** en test som går over flere domener, som en flyt. Prosessene er nummerert og navngitt som i `krav/_Flyter`. En test av en flyt har samme filnavn som flyten, og `@depends-on-FLY-…`. Den sjekker overleveringene: tilstanden i `Gitt` er laget gjennom løsningen i fasen før, ikke lagt inn direkte.
- **`README.md` i mappa** har to seksjoner: **Krever** (nøklene testene bruker, se under) og **Ikke kjørbart** (scenarioer som ikke er generert, med grunn).

## Gherkin-regler for testene

- `# language: no`. Én `Egenskap:` per krav. `Regel:`- og `Scenario:`-titlene er identiske med kravets, så tittelen er referansen til kravet.
- **Uavhengige scenarioer.** Hvert scenario starter fra en kjent tilstand, og bygger aldri på et annet scenario.
- **Testdataene står i testplanen.** Testen forutsetter at testdataene finnes i utgangstilstanden testplanen og «Krever» beskriver. Hvordan de lages og settes tilbake, er utenfor teststrategien. Data scenarioet selv lager og som ikke kan slettes, får et unikt navn per kjøring (for eksempel med tidspunktet), så en ny kjøring ikke finner data fra den forrige, og data testen endrer, settes tilbake.
- **Utledede testcaser.** Hver `Regel:` får i tillegg testcaser agenten utleder (negativ testing, obligatoriske felt, grenseverdier). De har tittelen `<tittel på regelen>: <hva som prøves>`, og tekniken som er brukt (grenseverdianalyse, ekvivalensklasser, beslutningstabell eller tilstandsoverganger) står i en `# Teknikk:`-kommentar over scenarioet. De hører til regelen, men finnes ikke i kravet, så de merkes `@utledet`. Viser en utledet testcase en oppførsel kravet ikke sier noe om, er det et funn av typen «Kravet dekker ikke».
- **Nøkler, ikke personer.** `Gitt` har testbruker og testdata som nøkler i «»: `Gitt jeg er logget inn som «brukeradministrator-alle-miljoer»`. Ingen navn, Feide-ID, `testbruker <nr>` eller passord i testfilene. Nøklene slås opp i testplanen (kolonnen `Nøkkel`) eller i svar fra brukeren ved kjøring.
- **Skjermens ord og konkrete verdier.** Menyer, felt, knapper og tekster i «», én handling per steg. `Så` er noe agenten ser: en tekst, et antall, noe som er synlig eller ikke. Ikke «filtreres listen til …».
- **Endrer data:** `@endrer-data` på scenarioet, med avsluttende steg som setter tilbake. Taggen sier at scenarioet endrer data, så oppryddingen er med. Scenarioene kjøres som alle andre, mot et testmiljø der testdata kan settes tilbake. Uten et slikt miljø (testplanen sier det) hoppes de over, og står i «Hoppet over» i resultatet.
- **Miljø står ikke i filene.** URL, versjon og feature-flagg står i testplanen, eller sies av brukeren. Det er alltid et testmiljø, aldri produksjon.
- **Ingen kravstatus.** Filene har ingen `@draft`, `@planned`, `@in-progress`, `@implemented` eller `@deprecated`, og ingen `@scope-`.

## Referanser til kravene

Hver test peker på kravet den sjekker, med taggene fra [`krav/README.md`](../krav/README.md) (*Referanser*), og en header med hva den er generert fra:

```gherkin
# language: no
# Generert av fs-testcaser-cdp <YYYY-MM-DD> fra akseptansetest/<slug>/testplan.md
# Krav: krav/<sti>/<fil>.feature @ <commit> (blob <hash>)
@TST-<DOM>-<SUB>-<KAP>-NNN @depends-on-<Feature-ID>
Egenskap: <tittelen i kravet>
```

- `@depends-on-<Feature-ID>` på `Egenskap:` (gjelder hele fila), eller på `Regel:`/`Scenario:` når en del bygger på andre krav. Testen må sjekkes når kravet endres, og det er det taggen sier. `@ref-<Feature-ID>` for et krav testen bare bruker som forutsetning.
- `@TST-…` er testens egen ID: `@TST-<DOM>-<SUB>-<KAP>-NNN` for en speilet sti, `@TST-<prosess>-<test>-NNN` for `_Løp` (samme formater som Feature-ID og `@FLY-`).
- Headeren har kravfila, commiten og blob-hashen (`git rev-parse origin/main:<sti>`). Er hashen ikke lik kravfilas nå, er testen utdatert, og `fs-testcaser-cdp` viser forskjellen som en diff i stedet for å skrive over.
- `# Testcase: <Nr>` over scenarioet når det bygger på en testcase i `akseptansetest/<slug>/testcaser-intern.md`.

Finn testene for et krav: `grep -rn "@depends-on-<Feature-ID>" cdp-tester/`.

## «Krever» i README.md

Hver mappe med tester har en seksjon som sier hva testene krever, med nøkkelen, en beskrivelse (ikke et navn), og hvilke scenarioer som bruker den. Det er denne seksjonen som stilles opp mot testplanen eller svarene fra brukeren før en kjøring.

```markdown
## Krever

| Nøkkel | Type | Beskrivelse | Brukes av |
|---|---|---|---|
| `brukeradministrator-alle-miljoer` | testbruker | Brukeradministrator i alle miljøer, ved organisasjon A | alle scenarioer |
| `personbruker-over-50` | testdata | Minst 51 personbrukere synlige for brukeradministratoren | «Liste viser de 50 første personbrukerne» |
```

Beskrivelsen av testdata er utgangstilstanden testen forutsetter, den samme som `Utgangstilstand` i testplanen.

## `cdp`-skillen

Testene kjøres med `cdp`-skillen (`.claude/skills/cdp`, CLI-en `browser-harness-js`). `fs-testcaser-cdp` trenger den ikke for å lage eller oppdatere testene, bare for å kjøre dem.

Skillen er ikke en del av repoet. Hver bruker installerer den fra GitHub-repoet [`browser-use/browser-harness-js`](https://github.com/browser-use/browser-harness-js). Den legges i `.agents/skills/cdp`, med `.claude/skills/cdp` som symlenke dit, og `skills-lock.json` sier hvilken versjon som er installert. Alle tre er ignorert av git (`.gitignore`).

1. Første kall med `browser-harness-js` installerer `bun` automatisk (laster ned og kjører et installasjonsskript fra bun.sh, og legger `~/.bun/bin` til i `~/.zshrc`). Vil du ikke det, sett `BROWSER_HARNESS_SKIP_BUN_INSTALL=1` og installer `bun` selv. CLI-en ligger ikke på PATH: kall den med full sti (`.claude/skills/cdp/sdk/browser-harness-js`), eller lag en symlenke som `cdp`-skillen beskriver.
2. Åpne `chrome://inspect/#remote-debugging` i Chrome, huk av «Discover network targets», og klikk **Allow** når Chrome spør.
3. Bruk en egen Chrome-profil til testingen (`--user-data-dir`), ikke den du bruker ellers. `cdp`-skillen kobler til Chrome-en som kjører, og agenten kan da lese alle cookies i profilen, også for andre tjenester. Logg inn selv. Testbrukeren byttes i «Overstyrt bruker» øverst til høyre i FS Admin, som er normalen i TEST, med verdien i `Innlogging` i testplanen.
4. Avslutt med `browser-harness-js --stop` når kjøringen er ferdig. Serveren lytter uautentisert på `127.0.0.1:9876`.

`cdp`-skillen har ingen egne sikkerhetsregler. Reglene for kjøringen (miljø-guard, forbudte kall, bevis) står i `fs-testcaser-cdp` under «Før en kjøring».

## Kjøring og resultat

Testene kjøres av en agent, i den agentiske funksjonstesten. Testansvarlig har ansvaret for at agenten blir kjørt og tester riktig, men selve kjøringen kan gjøres av andre. Resultatet lages per leveranse i `akseptansetest/<slug>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md`, og uten leveranse i `kjoring-…/` i mappa ved testene. Bevisene er steg, input, faktisk resultat og skjermbilde eller logg for hver testcase. Skjermbildene legges i samme mappe, men er ignorert av git (`.gitignore`): bare `resultat.md` committes. Resultatet lagres i Confluence når brukeren sier ja. Den som kjører agenten, legger skjermbildene ved siden med den agentiske testrapporten før testansvarlig går gjennom funnene.

Agenten følger stegene slik de står (R14 i [`testcase-regler.md`](../.claude/references/akseptansetest/testcase-regler.md)). Virker ikke et steg, eller finnes ikke en verdi, er det et funn, og testcasen blir «Ikke testet».

Agenten foreslår status, og kan aldri godkjenne en leveranse. En tester bekrefter foreslått status, og testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene, etter en risikovurdering. Agenten fyller aldri ut «Status» på testcasene eller i testrapporten.

Før agenten gjør noe, sjekker den at URL-en er testmiljøet fra testplanen, og avbryter hvis den er produksjon eller et annet domene enn FS Admin og Feide. Reglene for kjøringen står i `fs-testcaser-cdp` (*Før en kjøring*).
