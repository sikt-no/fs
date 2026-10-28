# CDP-tester

Varige tester som en agent kjører i Chrome mot et testmiljø, i den agentiske funksjonstesten (fase 2 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326)). De er skrevet som Gherkin, og kan brukes av flere verktøy. Agenten i fase 2 kjører dem med `cdp`-skillen (`.claude/skills/cdp`). De er ikke krav: kravene i [`krav/`](../krav/README.md) sier *hva* som skal gjelde, og her står *hvordan* det sjekkes i skjermen, med skjermens ord og konkrete verdier. Testene lages og oppdateres med skillen `fs-testcaser-cdp`, fra kravene. De kjenner ikke til testplaner eller akseptansetester: en testplan kan velge hvilke tester som lages og kjøres, men testene og `README.md`-ene her viser aldri til den.

Testene dekker alle scenarioene som er `@implemented`, pluss testcaser agenten utleder fra reglene: negativ testing, obligatoriske felt og grenseverdier. Roller, tilgangsstyring og datakonsistens verifiseres i koden i fase 1 (`fs-verify`). Scenarioene i kravet testes som de står, også synlighet for en rolle, men det lages ikke egne testcaser for roller og tilgang.

Mappa ligger ved siden av `krav/` og ikke under den, fordi konvensjonene for krav forbyr UI-ord og data i steg, og kravstatusene (`@draft` … `@implemented`) ikke passer for en test. `bddgen` leser bare `../krav/**/*.feature`, så filene her kjøres ikke av Playwright.

## Struktur

```
cdp-tester/
├── README.md                                   # dette dokumentet
├── _Løp/<NN Prosess>/<test>.feature            # tester på tvers av domener
├── _Miljøer/<miljø>.md                         # personaene og nøklene for ett testmiljø (se Miljøfila)
└── <sti speilet fra krav/>/
    ├── <test>.feature
    └── README.md                               # «Krever»: nøklene testene i mappa bruker
```

- **Speilet sti:** en test av ett krav ligger under samme mappesti som kravfila har under `krav/`, så testen finnes fra kravet. Filnavnet er det samme som kravfila.
- **`_Løp`:** en test som går over flere domener, som en flyt. Prosessene er nummerert og navngitt som i `krav/_Flyter`. En test av en flyt har samme filnavn som flyten, og `@depends-on-FLY-…`. Den sjekker overleveringene: tilstanden i `Gitt` er laget gjennom løsningen i fasen før, ikke lagt inn direkte.
- **`_Miljøer`:** én fil per testmiljø, med personaene og verdiene til nøklene (se *Miljøfila*).
- **`README.md` i mappa** har tittelen, lenken til kravet og **Krever** (se under). Ikke noe mer: det som gjelder alle testene, står her.

## Gherkin-regler for testene

- `# language: no`. Én `Egenskap:` per krav. `Regel:`- og `Scenario:`-titlene er identiske med kravets, så tittelen er referansen til kravet.
- **Uavhengige scenarioer.** Hvert scenario starter fra en kjent tilstand, og bygger aldri på et annet scenario.
- **Testdataene står i miljøfila.** Testen forutsetter at testdataene finnes i utgangstilstanden «Krever» beskriver. Hvordan de lages og settes tilbake, er utenfor teststrategien. Data scenarioet selv lager og som ikke kan slettes, får et unikt navn per kjøring (for eksempel med tidspunktet), så en ny kjøring ikke finner data fra den forrige, og data testen endrer, settes tilbake.
- **Utledede testcaser.** Hver `Regel:` får i tillegg testcaser agenten utleder (negativ testing, obligatoriske felt, grenseverdier). De har tittelen `<tittel på regelen>: <hva som prøves>`, og tekniken som er brukt (grenseverdianalyse, ekvivalensklasser, beslutningstabell eller tilstandsoverganger) står i en `# Teknikk:`-kommentar over scenarioet. De hører til regelen, men finnes ikke i kravet, så de merkes `@utledet`. Viser en utledet testcase en oppførsel kravet ikke sier noe om, er det et funn av typen «Kravet dekker ikke».
- **Nøkler, ikke personer.** `Gitt` har testbruker og testdata som nøkler i «»: `Gitt jeg er logget inn som «brukeradministrator-alle-miljoer»`. Ingen navn, Feide-ID, `testbruker <nr>` eller passord i testfilene. Nøkkelen beskriver rollen og relasjonen scenarioet trenger (`opptak-forvalter-deltakende`), aldri organisasjonen, personen eller året (se *Nøkkelen* i `.claude/references/akseptansetest/roller-og-testdata.md`). Nøklene slås opp i miljøfila (se *Miljøfila*).
- **Skjermens ord og konkrete verdier.** Menyer, felt, knapper og tekster i «», én handling per steg. `Så` er noe agenten ser: en tekst, et antall, noe som er synlig eller ikke. Ikke «filtreres listen til …».
- **Endrer data:** `@endrer-data` på scenarioet, med avsluttende steg som setter tilbake. Taggen sier at scenarioet endrer data, så oppryddingen er med. Scenarioene kjøres som alle andre, mot et testmiljø der testdata kan settes tilbake. Uten et slikt miljø (miljøfila sier det) hoppes de over, og står i «Hoppet over» i resultatet.
- **Organisasjoner som nøkler.** Et steg som trenger organisasjonen til en testbruker eller et testdata, bruker `{ORG:<nøkkel>}` (forkortelsen), `{ORGNAVN:<nøkkel>}` (navnet på bokmål) eller `{ORGKODE:<nøkkel>}` (organisasjonskoden): `Og jeg velger «Fjern {ORG:opptak-forvalter-deltakende}»`. Agenten slår dem opp i miljøfila: forkortelsen, navnet og koden står på personaen nøkkelen er koblet til, eller på testdataene. `{KJØRING}` er tidspunktet for kjøringen. Ingen navn på organisasjoner i stegene, bortsett fra det skjermen alltid viser, uansett miljø.
- **Miljø står ikke i filene.** URL, versjon og feature-flagg står i miljøfila. Det er alltid et testmiljø, aldri produksjon.
- **Bare det som varer.** Testene og `README.md` i mappa skal kunne kjøres om et halvt år. De har ikke status for kravet eller leveransen, kjente mangler, saker med status, resultater fra verifiseringen eller en kjøring, henvisninger til en testplan eller testcaser i den, eller verdier som bare gjelder ett miljø. Verdiene står i miljøfila, og resten i resultatet av kjøringen eller utenfor `cdp-tester/`. Kommentarer om hvordan et steg tas, hva skjermen viser, og avklaringer og åpne spørsmål i kravet er greit: de følger kravet, og blob-hashen i headeren sier når de er utdaterte.
- **Ingen kravstatus.** Filene har ingen `@draft`, `@planned`, `@in-progress`, `@implemented` eller `@deprecated`, og ingen `@scope-`.

## Referanser til kravene

Hver test peker på kravet den sjekker, med taggene fra [`krav/README.md`](../krav/README.md) (*Referanser*), og en header med hva den er generert fra:

```gherkin
# language: no
# Generert av fs-testcaser-cdp <YYYY-MM-DD>
# Krav: krav/<sti>/<fil>.feature @ <commit> (blob <hash>)
@TST-<DOM>-<SUB>-<KAP>-NNN @depends-on-<Feature-ID>
Egenskap: <tittelen i kravet>
```

- `@depends-on-<Feature-ID>` på `Egenskap:` (gjelder hele fila), eller på `Regel:`/`Scenario:` når en del bygger på andre krav. Testen må sjekkes når kravet endres, og det er det taggen sier. `@ref-<Feature-ID>` for et krav testen bare bruker som forutsetning.
- `@TST-…` er testens egen ID: `@TST-<DOM>-<SUB>-<KAP>-NNN` for en speilet sti, `@TST-<prosess>-<test>-NNN` for `_Løp` (samme formater som Feature-ID og `@FLY-`).
- Headeren har kravfila, commiten og blob-hashen (`git rev-parse origin/main:<sti>`). Er hashen ikke lik kravfilas nå, er testen utdatert, og `fs-testcaser-cdp` viser forskjellen som en diff i stedet for å skrive over.

Finn testene for et krav: `grep -rn "@depends-on-<Feature-ID>" cdp-tester/`.

## «Krever» i README.md

Hver mappe med tester sier hvilke nøkler testene bruker, og hvilke scenarioer som bruker dem. Det er denne seksjonen som stilles opp mot miljøfila før en kjøring.

```markdown
## Krever

| Nøkkel | Type | Brukes av |
|---|---|---|
| `brukeradministrator-alle-miljoer` | testbruker | alle scenarioer |
| `personbruker-over-50` | testdata | «Liste viser de 50 første personbrukerne» |
```

Hva nøkkelen krever, står ett sted: i miljøfila, i «Krever» for en testbruker og i «Utgangstilstand» for testdata. En testbruker beskrives med rollen og det scenarioet krever av organisasjonen («`OPPTAK_FORVALTER` ved en organisasjon som ikke er deltaker i testdata-opptakene»), ikke organisasjonen. Testdata beskrives med egenskapene, ikke verdien i ett miljø: «Regelverkssamling som kan velges i et samordna opptak», ikke «UHGTEST2026». Beskrivelsen er den samme i alle miljøfilene.

Alle scenarioene i gating-settet blir tester. Mangler testdataene i et miljø, eller kan et steg ikke tas, er det kjøringen som viser det: testcasen blir «Ikke bestått» eller «Ikke testet», med grunnen i resultatet.

## Miljøfila

`_Miljøer/<miljø>.md` (for eksempel [`_Miljøer/test.md`](_Miljøer/test.md)) er den autoritative oversikten over ett testmiljø: hvilke testpersoner og roller som finnes i FS Admin, og hva nøklene i testene er i miljøet. Det er det eneste stedet verdiene slås opp når testene kjøres. Den committes, deles av alle som kjører testene, og vedlikeholdes jevnlig (se *Vedlikehold av miljøfila*).

- **Øverst:** URL-en til FS Admin, hvordan testbrukeren byttes, om testdataene kan settes tilbake, og når personaene sist ble sjekket.
- **Feature-flagg:** `Flagg | Står | Sjekket`.
- **Personaer:** `Rad i «Overstyrt bruker» | Deklarerte roller | Organisasjon | Organisasjonskode | Forkortelse | Tildelinger i <miljø> | Bekreftet`. Alle personaene i menyen, ikke bare dem testene bruker. Raden skrives nøyaktig som i menyen, og forkortelsen og organisasjonen som i organisasjonsregisteret (`testpersoner`).
- **Testbrukere:** `Nøkkel | Krever | Persona (rad i «Overstyrt bruker»)`. Hva testen krever av testbrukeren, og koblingen til en persona. Organisasjonen til testbrukeren (`{ORG:<nøkkel>}`) er organisasjonen til personaen. Byttes personaen, endres bare denne raden.
- **Testdata:** `Nøkkel | Verdi i <miljø> | Søk/URL | Utgangstilstand | Sjekket`. Verdien er det testen skriver eller søker på i miljøet, og utgangstilstanden er det testen forutsetter.
- Ingen passord, hemmeligheter eller fødselsnumre, og bare Feide testbrukere og syntetiske personer.
- En nøkkel har samme betydning i alle miljøfilene. Mangler en verdi, står den som `[Fylles ut]`, og scenarioene som bruker den, blir «Ikke testet» i kjøringen.
- `fs-testcaser-cdp` legger nye nøkler inn i fila når brukeren sier ja. En kjøring som finner at en verdi ikke stemmer, sier det i resultatet, og foreslår endringen.

### Vedlikehold av miljøfila

Personaene og tildelingene endres i fs-admin og tilgangsstyring, uavhengig av testene. Sjekk fila jevnlig, og alltid før en kjøring når «Personaer sist sjekket» er mer enn en måned gammel:

1. **Personaene.** Les `TEST_PERSONAS` i fs-admin (`git show origin/main:src/common/lib/persona/constants/testPersonas.ts`). Menyraden er `<FORNAVN> <ETTERNAVN> • <beskrivelse> (<organisasjonForkortelse, ellers organisasjonNavn>)`. Legg til nye personaer, og fjern dem som er borte.
2. **Tildelingene.** Kjør spørringen `testpersoner` i miljøet (for eksempel i GraphiQL i FS Admin), og fyll ut «Tildelinger», «Organisasjon», «Forkortelse» og «Bekreftet» for personaene. Tildelingene er rollene etter utvidelsen i rollekatalogen (`tilgangsroller`, som `GET_ROLLEHIERARKI` i fs-admin).

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

3. **Testbrukerne.** Hver nøkkel peker på en persona som finnes, og har tildelingene beskrivelsen i «Krever» sier. Er personaen borte, eller har den mistet en tildeling, foreslå en annen persona fra tabellen, eller si at en persona må legges til i fs-admin og tildelingen i tilgangsstyring.
4. **Testdataene og flaggene.** Sjekk at verdiene finnes, i utgangstilstanden. En tilstand som bygger på datoer, sjekkes samme dag som testen kjøres.
5. Oppdater «Personaer sist sjekket» med datoen og commiten i fs-admin, og «Sjekket» på radene som er sjekket.

Skriv aldri fødselsnummeret i fila: personaen velges i menyen.

## `cdp`-skillen

Testene kjøres med `cdp`-skillen (`.claude/skills/cdp`, CLI-en `browser-harness-js`). `fs-testcaser-cdp` trenger den ikke for å lage eller oppdatere testene, bare for å kjøre dem.

Skillen er ikke en del av repoet. Hver bruker installerer den fra GitHub-repoet [`browser-use/browser-harness-js`](https://github.com/browser-use/browser-harness-js). Den legges i `.agents/skills/cdp`, med `.claude/skills/cdp` som symlenke dit, og `skills-lock.json` sier hvilken versjon som er installert. Alle tre er ignorert av git (`.gitignore`).

1. Første kall med `browser-harness-js` installerer `bun` automatisk (laster ned og kjører et installasjonsskript fra bun.sh, og legger `~/.bun/bin` til i `~/.zshrc`). Vil du ikke det, sett `BROWSER_HARNESS_SKIP_BUN_INSTALL=1` og installer `bun` selv. CLI-en ligger ikke på PATH: kall den med full sti (`.claude/skills/cdp/sdk/browser-harness-js`), eller lag en symlenke som `cdp`-skillen beskriver.
2. Åpne `chrome://inspect/#remote-debugging` i Chrome, huk av «Discover network targets», og klikk **Allow** når Chrome spør.
3. Bruk en egen Chrome-profil til testingen (`--user-data-dir`), ikke den du bruker ellers. `cdp`-skillen kobler til Chrome-en som kjører, og agenten kan da lese alle cookies i profilen, også for andre tjenester. Logg inn selv. Testbrukeren byttes i «Overstyrt bruker» øverst til høyre i FS Admin, som er normalen i TEST, med personaen i miljøfila.
4. Avslutt med `browser-harness-js --stop` når kjøringen er ferdig. Serveren lytter uautentisert på `127.0.0.1:9876`.

`cdp`-skillen har ingen egne sikkerhetsregler. Reglene for kjøringen står under, i *Regler for kjøringen*.

## Kjøring og resultat

Testene kjøres av en agent, mot miljøfila for testmiljøet. Den som starter kjøringen, sier hvilke tester som kjøres (en mappe, en fil eller en liste) og hvor resultatet legges. Sier den ikke noe, legges resultatet ved testene: `cdp-tester/<mappa med testene>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md`, eller i den nærmeste felles mappa når kjøringen går over flere. Hører kjøringen til en akseptansetest, sier [`akseptansetest/README.md`](../akseptansetest/README.md) hvor resultatet legges.

Resultatet følger malen i [`mal-cdp.md`](../.claude/skills/fs-testcaser-cdp/references/mal-cdp.md) (*Resultat av en kjøring*). Bevisene er steg, input, faktisk resultat og skjermbilde eller logg for hver testcase. Skjermbildene legges i samme mappe, men er ignorert av git (`.gitignore`): bare `resultat.md` committes. Resultatet lagres i Confluence når brukeren sier ja.

Agenten foreslår status, og kan aldri godkjenne en leveranse. En tester bekrefter foreslått status, og testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene, etter en risikovurdering. Agenten fyller aldri ut «Status» på testcasene eller i en testrapport.

### Regler for kjøringen

`cdp`-skillen har ingen sikkerhetsregler. Disse gjelder for agenten som kjører testene:

- **Miljø-guard.** Før første handling: sjekk at URL-en er FS Admin i miljøfila, og avbryt hvis den er produksjon eller et annet domene enn FS Admin og Feide.
- **Kravene er de samme.** Sammenlign blob-hashen i headeren med kravfila nå (`git rev-parse origin/main:<sti>`). Er den ulik, si det, og foreslå å oppdatere testene først (`fs-testcaser-cdp`). Er et krav ikke `@implemented` (les taggen), står det i resultatet: scenarioer som ikke er levert, vil trolig ikke bestå.
- **Miljøfila er oppdatert.** Er «Personaer sist sjekket» mer enn en måned gammel, eller mangler en nøkkel testene bruker, si det før kjøringen (se *Vedlikehold av miljøfila*).
- **Data som endres.** Scenarioene med `@endrer-data` rydder etter seg, og kjøres som alle andre når miljøfila sier at testdataene kan settes tilbake. Ellers hoppes de over (og står i «Hoppet over» i resultatet) til brukeren ber om dem. Testbrukerne og andre data enn dem testen selv har laget, endres aldri.
- **Forbudte kall.** Aldri `Fetch.*`, `Network.setCookie(s)`, `Storage.clear*` eller `clearBrowserCookies`, og aldri `handleJavaScriptDialog({accept:true})` uten at scenarioet sier hva dialogen er (eksemplene i `dialogs.md` aksepterer alt).
- **Tilkobling.** `cdp`-skillen kobler til brukerens kjørende Chrome, og agenten ser alle cookies i profilen. Bruk en egen Chrome-profil til testingen, og la brukeren logge inn selv.
- **Bytte testbruker.** Agenten bytter i «Overstyrt bruker» til personaen nøkkelen er koblet til i miljøfila, før hvert scenario der testbrukeren er en annen, og sjekker at riktig persona er valgt før første steg, også når forrige scenario sluttet som en annen. Med Feide-innlogging per testbruker er bytte av testbruker bytte av profil. Bytt aldri testbruker ved å endre cookies.
- **Følg stegene slik de står** (R14 i [`testcase-regler.md`](../.claude/references/akseptansetest/testcase-regler.md)). Virker ikke et steg, eller finnes ikke en verdi, er det et funn, og testcasen blir «Ikke testet». Agenten prøver seg ikke fram en annen vei.
- **Verdier som ikke stemmer.** Finnes ikke en verdi fra miljøfila i miljøet, er testcasen «Ikke testet», og resultatet foreslår endringen i miljøfila. Agenten endrer ikke miljøfila under kjøringen.
- **Bevis.** Tekst og DOM (`Runtime.evaluate`) er primærbevis, skjermbilder sekundære. Tell rader i skjermen, ikke via GraphQL: et direkte API-kall kan gi flere rader enn løsningen viser. Skriv aldri til `/tmp`.
- **Kjente mangler** er ikke en del av testene. Gir den som starter kjøringen en liste over kjente mangler, sjekkes sakene før kjøringen, og de står i resultatet. Ellers er et scenario som ikke består, et funn.
- **Funn.** Et funn har typen «Feil» eller «Kravet dekker ikke» (en `@utledet` testcase der kravet ikke sier noe om tilfellet), og alvorlighetsgrad fra testansvarlig ([`alvorlighetsgrad.md`](../.claude/references/akseptansetest/alvorlighetsgrad.md)). «Kravet dekker ikke» avklares i kravet (`fs-krav`), ikke bare i testen.
- **Installasjon.** Mangler `cdp`-skillen, `bun` eller `browser-harness-js`, vis veiledningen i *`cdp`-skillen*, og installer ikke noe uten at brukeren sier ja.
