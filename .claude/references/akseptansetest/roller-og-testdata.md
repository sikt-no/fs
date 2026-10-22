# Roller og testdata

Felles for skillene som trenger testbrukere og testdata: `fs-testplan` (som skriver dem i testplanen) og `fs-testcaser-cdp` (som slår dem opp, og spør når de mangler). Spørsmålene står bare her, så de to ikke kommer ut av takt. `fs-testcaser-intern` og `fs-testcaser-ekstern` leser tabellene i testplanen, og stiller ikke spørsmålene selv.

## Hvor svarene står

Testplanen (`akseptansetest/<slug>/testplan.md`) har to tabeller (se `fs-testplan/references/mal-testplan.md`):

- **Testbrukere:** `Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til`
- **Testdata:** `Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av | Kan settes tilbake`

`Nr`, `Navn`, `Hva` og `Brukes til` er for menneskene og for testcasene. `Nøkkel`, `Innlogging`, `Start-URL`, `Søk/URL`, `Utgangstilstand` og `Brukes av` er for CDP-testene, og er påkrevde bare når teamet har svart ja på «Skal en CDP-agent kjøre testene?». Er svaret nei, tas kolonnene ikke med i testplanen.

**Nøkkelen** er et stabilt navn i kebab-case, uten æ, ø og å, som beskriver rollen eller tilstanden og ikke personen: `brukeradministrator-alle-miljoer`, `personbruker-flere-aktive-roller`. Testene i `cdp-tester/` bruker nøkler, aldri «testbruker 1» eller et navn, siden nummer og navn hører til én testplan. En nøkkel endres ikke når navnet på testbrukeren byttes.

**Aldri passord eller hemmeligheter** i testplanen. `Innlogging` er navnet på Chrome-profilen testbrukeren er logget inn i, eller Feide-ID-en brukeren logger inn med.

## Spørsmålene

Still dem samlet med `AskUserQuestion`, høyst fire om gangen. Har en tidligere testplan svaret for de samme kravene, vis svaret og spør om det fortsatt gjelder.

1. **Roller:** list rollene kravene nevner (`Som <rolle>`, `Gitt jeg er <rolle>`, rollene i *Synlighet*-regler). Når CDP er valgt, les i tillegg koden og vis hva den krever, med fil:linje, og hva som avviker fra kravene (se under).
2. **Testbrukere:** be om navn og organisasjon for hver rolle. Nummerer dem fra 1, og gi hver en nøkkel. Minst to organisasjoner. Når CDP er valgt: `Innlogging` (Chrome-profilnavn eller Feide-ID) og eventuelt `Start-URL`.
3. **Testdata:** de dataene scenarioene krever (`Gitt`-stegene: personbrukere, opptak, søkere, søknader, regelverkssamlinger osv.), hvor de ligger, og om de kan settes tilbake. Gi hver en nøkkel. Når CDP er valgt: `Søk/URL` (hvordan objektet åpnes), `Utgangstilstand` (hva testen forutsetter) og `Brukes av` (Feature-ID og scenario, eller testcase-Nr).
4. **Miljøet:** URL til testmiljøet, versjon og feature-flagg. Det er alltid et testmiljø, aldri produksjon.

Det brukeren hopper over, skrives som `[Fylles ut: <hva>]`. Gjett aldri det bare teamet vet.

## Lese koden når CDP er valgt

Kravene sier hvilken rolle brukeren har («brukeradministrator»), ikke hva løsningen krever. Når teamet har svart ja på CDP, les kodeklonene (som i *Kodeklonene* i `fs-verify`), og vis:

- **Frontend (fs-admin, min-kompetanse):** rollen eller rettigheten som gir tilgang til siden og menypunktet (`WithRole`, `Menu`), feature-flaggene (`FeatureFlag`, og om de alltid er på i testmiljøet), og skjermens ord.
- **Backend (fs-plattform):** hva som bestemmer hva brukeren får se (rettigheter og radnivåsikkerhet), og hvilke tilstander i dataene som må finnes for scenarioene.
- **Avvik** mellom kravet og koden (for eksempel at synligheten i koden har flere grener enn kravet) står i testplanens «Kjente begrensninger», og gjør de berørte scenarioene «Ikke kjørbart» eller svake. Endre aldri kravene: foreslå `fs-krav`.
- Les med `git show origin/main:<sti>`, og si fra om hvor gammel klonen er. Kjør aldri `git pull` eller andre endrende kommandoer i kodeklonene.

## Ekte personer

Testplanen og testene har bare Feide testbrukere og syntetiske personer. Ser en verdi ut som et ekte fødselsnummer eller et ekte navn, stopp og spør.
