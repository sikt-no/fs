# Roller og testdata

Felles for skillene som trenger testbrukere og testdata: `fs-testplan` (som planlegger dem i testplanen) og `fs-testcaser-cdp` (som slår dem opp, og spør når de mangler). Spørsmålene står bare her, så de to ikke kommer ut av takt. `fs-testcaser-intern` og `fs-testcaser-ekstern` leser tabellene i testplanen, og stiller ikke spørsmålene selv.

## Hvor svarene står

Testplanen (`akseptansetest/<slug>/testplan.md`) har to tabeller (se `fs-testplan/references/mal-testplan.md`):

- **Testbrukere:** `Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til`
- **Testdata:** `Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Opprettes av | Brukes av | Rydding`

`Nr`, `Navn`, `Hva` og `Brukes til` er for menneskene og for testcasene. `Nøkkel`, `Innlogging`, `Start-URL`, `Søk/URL`, `Utgangstilstand`, `Opprettes av`, `Brukes av` og `Rydding` er for den agentiske funksjonstesten (fase 2), og er alltid med: fase 2 er en del av flyten, ikke et valg.

**Nøkkelen** er et stabilt navn i kebab-case, uten æ, ø og å, som beskriver rollen eller tilstanden og ikke personen: `brukeradministrator-alle-miljoer`, `personbruker-flere-aktive-roller`. Testene i `cdp-tester/` bruker nøkler, aldri «testbruker 1» eller et navn, siden nummer og navn hører til én testplan. En nøkkel endres ikke når navnet på testbrukeren byttes.

**Aldri passord eller hemmeligheter** i testplanen. `Innlogging` er navnet på Chrome-profilen testbrukeren er logget inn i, eller Feide-ID-en brukeren logger inn med.

## Testdata

Den agentiske funksjonstesten lager sine egne testdata, og forutsetter ikke at de finnes fra før. Testplanen vurderer det per krav: hvilke data scenarioene trenger (`Gitt`-stegene), hvordan de lages, og hvordan de ryddes eller tilbakestilles. Kolonnen **Opprettes av** sier hvordan:

| Verdi | Betyr |
|---|---|
| `Manuelt` | Testen oppretter dataene gjennom løsningen, med stegene i testcasen (for eksempel «Opprett opptak» med verdiene i `Utgangstilstand`) |
| `API` | Dataene seedes via API før testen (for eksempel en mutation i GraphQL-API-et, eller et skript). `Søk/URL` eller `Utgangstilstand` sier hvilket kall, og hva det trenger |
| `Finnes i testmiljøet` | Dataene finnes fra før og lages ikke av testen. Typisk for kodeverk, regelverkssamlinger og organisasjoner. Brukes også av den interne testen (fase 3) |

Vurder for hvert krav:

- Hva kan lages gjennom løsningen, og hva må seedes? Data som bare kan lages av en annen aktør eller et annet system (for eksempel en søknad fra min-kompetanse, når testen starter hos saksbehandleren), seedes.
- For en overlevering i en flyt (`Brukes av` er en `@FLY-`-ID, fase 3) skal tilstanden være laget gjennom løsningen i fasen før, ikke seedet: si hvordan i `Utgangstilstand`.
- **Rydding** sier hva som skjer etter testen: `Slettes`, `Settes tilbake` (med hva og hvordan) eller `Kan ikke ryddes`. Data som ikke kan ryddes, får `{KJØRING}` i navnet (R13 i `testcase-regler.md`), så en ny kjøring ikke treffer dataene fra forrige.
- **Datoer i forhold til testdagen.** For hvert opptak eller annet objekt som må være i en bestemt tilstand, står fristene som bestemmer tilstanden, i forhold til dagen testen kjøres: `Redigering åpner: 7 dager før testen. Redigering stenger: 30 dager etter testen. Åpner for søking: 14 dager etter testen.` Står det hvordan objektet lages, skal ikke en snarvei som setter alle datoene til i dag (for eksempel «Fyll inn testdatoer») brukes når tilstanden forutsetter noe annet. En tilstand som bygger på datoer, sjekkes samme dag som testen kjøres.
- Kan ikke testdataene settes opp eller tilbakestilles slik, står det som en forutsetning i testplanen. Selve testdataene (syntetiske data, tilbakestilling av miljøet) løses separat, og ligger utenfor teststrategien.

## Spørsmålene

Still dem samlet med `AskUserQuestion`, høyst fire om gangen. Har en tidligere testplan svart for de samme kravene, vis svaret og spør om det fortsatt gjelder.

1. **Roller:** list rollene kravene nevner (`Som <rolle>`, `Gitt jeg er <rolle>`, rollene i *Synlighet*-regler), og les koden og vis hva den krever, med fil:linje, og hva som avviker fra kravene (se under).
2. **Testbrukere:** be om navn og organisasjon for hver rolle. Nummerer dem fra 1, og gi hver en nøkkel. Testbrukerne skal finnes i alle relevante roller ved de organisasjonene kravet gjelder, minst to organisasjoner. Antallet bestemmes per krav ut fra tilgangsmatrisen (roller × organisasjon). Spør også etter `Innlogging` (Chrome-profilnavn eller Feide-ID) og eventuelt `Start-URL`.
3. **Testdata:** for hvert krav, etter *Testdata* over: de dataene scenarioene krever, hvor de ligger, og hvem som oppretter dem (`Manuelt`, `API` eller `Finnes i testmiljøet`). Gi hver en nøkkel, og fyll ut `Søk/URL` (hvordan objektet åpnes eller seedes), `Utgangstilstand` (hva testen forutsetter, med datoene i forhold til testdagen), `Brukes av` (Feature-ID og scenario, eller testcase-Nr) og `Rydding`. Gjelder en testcase en flyt: hvordan tilstanden lages gjennom løsningen.
4. **Miljøet:** URL til testmiljøet, versjon og feature-flagg. Det er alltid et testmiljø, aldri produksjon. Kan testdataene settes tilbake før hver kjøring?

Det brukeren hopper over, skrives som `[Fylles ut: <hva>]`. Gjett aldri det bare teamet vet.

## Lese koden

Kravene sier hvilken rolle brukeren har («brukeradministrator»), ikke hva løsningen krever. Les kodeklonene (som i *Kodeklonene* i `fs-verify`), og vis:

- **Frontend (fs-admin, min-kompetanse):** rollen eller rettigheten som gir tilgang til siden og menypunktet (`WithRole`, `Menu`), feature-flaggene (`FeatureFlag`, og om de alltid er på i testmiljøet), skjermens ord, de obligatoriske feltene og standardverdiene.
- **Backend (fs-plattform):** hva som bestemmer hva brukeren får se (rettigheter og radnivåsikkerhet), hvilke tilstander i dataene som må finnes for scenarioene, og operasjonene som kan brukes til å seede dataene.
- **Avvik** mellom kravet og koden (for eksempel at synligheten i koden har flere grener enn kravet) står i testplanens «Kjente begrensninger», og gjør de berørte scenarioene «Ikke kjørbart» eller svake. Endre aldri kravene: foreslå `fs-krav`.
- Les med `git show origin/main:<sti>`, og si fra om hvor gammel klonen er. Kjør aldri `git pull` eller andre endrende kommandoer i kodeklonene.

## Ekte personer

Testplanen og testene har bare Feide testbrukere og syntetiske personer. Ser en verdi ut som et ekte fødselsnummer eller et ekte navn, stopp og spør.
