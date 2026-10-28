# Roller og testdata

Felles for skillene som trenger testbrukere og testdata: `fs-testplan` (som planlegger dem i testplanen) og `fs-testcaser-cdp` (som slår dem opp, og spør når de mangler). Spørsmålene står bare her, så de to ikke kommer ut av takt. `fs-testcaser-intern` og `fs-testcaser-ekstern` leser tabellene i testplanen, og stiller ikke spørsmålene selv.

## Hvor svarene står

Testplanen (`akseptansetest/<slug>/testplan.md`) har to tabeller (se `fs-testplan/references/mal-testplan.md`):

- **Testbrukere:** `Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til`
- **Testdata:** `Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av`

`Nr`, `Navn`, `Hva` og `Brukes til` er for menneskene og for testcasene. `Nøkkel`, `Innlogging`, `Start-URL`, `Søk/URL`, `Utgangstilstand` og `Brukes av` er for den agentiske funksjonstesten (fase 2), og er alltid med: fase 2 er en del av flyten, ikke et valg.

**Nøkkelen** er et stabilt navn i kebab-case, uten æ, ø og å, som beskriver rollen eller tilstanden og ikke personen: `brukeradministrator-alle-miljoer`, `personbruker-flere-aktive-roller`. Testene i `cdp-tester/` bruker nøkler, aldri «testbruker 1» eller et navn, siden nummer og navn hører til én testplan. En nøkkel endres ikke når navnet på testbrukeren byttes.

**Aldri passord eller hemmeligheter** i testplanen. `Innlogging` er verdien testbrukeren har i «Overstyrt bruker» (nedtrekksmenyen øverst til høyre i FS Admin, normalen i TEST), eller navnet på Chrome-profilen eller Feide-ID-en når testbrukeren logger inn for seg.

## Testdata

Testplanen sier hvilke testdata testene trenger, ikke hvordan de lages. Prosessen med å lage testdataene (syntetiske data, seeding, tilbakestilling av miljøet) løses separat, og ligger utenfor teststrategien. Testene forutsetter at dataene finnes i utgangstilstanden testplanen beskriver.

For hvert krav:

- **Hva scenarioene trenger** (`Gitt`-stegene og de utledede testcasene): hvert objekt får en rad, med en nøkkel og `Utgangstilstand`.
- **Overleveringer i en flyt** (`Brukes av` er en `@FLY-`-ID, fase 3): tilstanden skal være laget gjennom løsningen i fasen før, ikke lagt inn direkte. Si hvilken fase i `Utgangstilstand`.
- **Datoer i forhold til testdagen.** For hvert opptak eller annet objekt som må være i en bestemt tilstand, står fristene som bestemmer tilstanden, i forhold til dagen testen kjøres: `Redigering åpner: 7 dager før testen. Redigering stenger: 30 dager etter testen. Åpner for søking: 14 dager etter testen.` En snarvei som setter alle datoene til i dag (for eksempel «Fyll inn testdatoer»), brukes ikke når tilstanden forutsetter noe annet. En tilstand som bygger på datoer, sjekkes samme dag som testen kjøres.
- **Data scenarioet selv lager** (for eksempel «Opprett opptak»), er ikke testdata: de lages av stegene i testcasen, og får `{KJØRING}` i navnet når de ikke kan slettes (R13 i `testcase-regler.md`).
- At testdataene kan settes tilbake før hver kjøring, er en forutsetning i testplanen, ikke en kolonne.

## Spørsmålene

Still dem samlet med `AskUserQuestion`, høyst fire om gangen. Har en tidligere testplan svart for de samme kravene, vis svaret og spør om det fortsatt gjelder.

1. **Roller:** list rollene kravene nevner (`Som <rolle>`, `Gitt jeg er <rolle>`, rollene i *Synlighet*-regler), og les koden og vis hva den krever, med fil:linje, og hva som avviker fra kravene (se under).
2. **Testbrukere:** be om navn og organisasjon for hver rolle. Nummerer dem fra 1, og gi hver en nøkkel. Testbrukerne skal finnes i rollene scenarioene nevner, ved de organisasjonene kravet gjelder. Har kravet scenarioer om synlighet (hva en rolle ser fra organisasjonene den administrerer), trengs data fra minst to organisasjoner. Antallet bestemmes per krav ut fra tilgangsmatrisen: tilgangsradene i verify-rapporten (roller × organisasjon). Scenarioene testes som de står, men det lages ikke egne testcaser for roller og tilgang (de er verifisert i koden i fase 1), så det trengs ikke testbrukere bare for å vise at en rolle mangler tilgang. Spør også etter `Innlogging` (verdien i «Overstyrt bruker», ellers Chrome-profilnavn eller Feide-ID) og eventuelt `Start-URL`.
3. **Testdata:** for hvert krav, etter *Testdata* over: de dataene scenarioene krever, og hvor de ligger. Gi hver en nøkkel, og fyll ut `Søk/URL` (hvordan objektet åpnes), `Utgangstilstand` (hva testen forutsetter, med datoene i forhold til testdagen) og `Brukes av` (Feature-ID og scenario, eller testcase-Nr). Gjelder en testcase en flyt: hvilken fase som lager tilstanden. Spør ikke om hvordan dataene lages: det er utenfor strategien.
4. **Miljøet:** URL til testmiljøet, versjon og feature-flagg. Det er alltid et testmiljø, aldri produksjon. Kan testdataene settes tilbake før hver kjøring?

Det brukeren hopper over, skrives som `[Fylles ut: <hva>]`. Gjett aldri det bare teamet vet.

## Lese koden

Kravene sier hvilken rolle brukeren har («brukeradministrator»), ikke hva løsningen krever. Les kodeklonene (som i *Kodeklonene* i `fs-verify`), og vis:

- **Frontend (fs-admin, min-kompetanse):** rollen eller rettigheten som gir tilgang til siden og menypunktet (`WithRole`, `Menu`), feature-flaggene (`FeatureFlag`, og om de alltid er på i testmiljøet), skjermens ord, de obligatoriske feltene og standardverdiene.
- **Backend (fs-plattform):** hva som bestemmer hva brukeren får se (rettigheter og radnivåsikkerhet), og hvilke tilstander i dataene som må finnes for scenarioene.
- **Avvik** mellom kravet og koden (for eksempel at synligheten i koden har flere grener enn kravet) står i testplanens «Kjente begrensninger», og gjør de berørte scenarioene «Ikke kjørbart» eller svake. Endre aldri kravene: foreslå `fs-krav`.
- Les med `git show origin/main:<sti>`, og si fra om hvor gammel klonen er. Kjør aldri `git pull` eller andre endrende kommandoer i kodeklonene.

## Ekte personer

Testplanen og testene har bare Feide testbrukere og syntetiske personer. Ser en verdi ut som et ekte fødselsnummer eller et ekte navn, stopp og spør.
