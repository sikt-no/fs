# CDP-tester

Varige tester som en agent kjører i Chrome med `cdp`-skillen (`.claude/skills/cdp`), mot et testmiljø. De er skrevet som Gherkin, men er ikke krav: kravene i [`krav/`](../krav/README.md) sier *hva* som skal gjelde, og her står *hvordan* det sjekkes i skjermen, med skjermens ord og konkrete verdier. Testene lages og oppdateres med skillen `fs-testcaser-cdp`, fra kravene, og de overlever testplaner og akseptansetester.

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
- **`_Løp`:** en test som går over flere domener, som en flyt. Prosessene er nummerert og navngitt som i `krav/_Flyter`.
- **`README.md` i mappa** har to seksjoner: **Krever** (nøklene testene bruker, se under) og **Ikke kjørbart** (scenarioer som ikke er generert, med grunn).

## Gherkin-regler for testene

- `# language: no`. Én `Egenskap:` per krav. `Regel:`- og `Scenario:`-titlene er identiske med kravets, så tittelen er referansen til kravet.
- **Uavhengige scenarioer.** Hvert scenario starter fra en kjent tilstand, og bygger aldri på et annet scenario.
- **Nøkler, ikke personer.** `Gitt` har testbruker og testdata som nøkler i «»: `Gitt jeg er logget inn som «brukeradministrator-alle-miljoer»`. Ingen navn, Feide-ID, `testbruker <nr>` eller passord i testfilene. Nøklene slås opp i testplanen (kolonnen `Nøkkel`) eller i svar fra brukeren ved kjøring.
- **Skjermens ord og konkrete verdier.** Menyer, felt, knapper og tekster i «», én handling per steg. `Så` er noe agenten ser: en tekst, et antall, noe som er synlig eller ikke. Ikke «filtreres listen til …».
- **Endrer data:** `@endrer-data` på scenarioet, med avsluttende steg som setter tilbake. En kjøring hopper over dem til brukeren ber om dem.
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

## Kjøring og resultat

Testene kjøres av en agent med `cdp`-skillen. Resultatet lages per leveranse i `akseptansetest/<slug>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md`, og uten leveranse i `kjoring-…/` i mappa ved testene. Skjermbilder legges i samme mappe, men er ignorert av git: bare `resultat.md` committes. Resultatet lagres i Confluence når brukeren sier ja (skjermbilder kan legges ved siden for hånd). En tester bekrefter foreslått status, og agenten fyller aldri ut «Status» på testcasene eller i testrapporten.

Før agenten gjør noe, sjekker den at URL-en er testmiljøet fra testplanen, og avbryter hvis den er produksjon eller et annet domene enn FS Admin og Feide. Sikkerhetsreglene for `cdp`-skillen står i `fs-testcaser-cdp` (*Før en kjøring*).
