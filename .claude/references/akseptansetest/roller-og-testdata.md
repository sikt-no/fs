# Roller og testdata

Felles for skillene som trenger testbrukere og testdata: `fs-testplan` (som planlegger dem i testplanen) og `fs-testcaser-cdp` (som slår dem opp, og spør når de mangler). Spørsmålene står bare her, så de to ikke kommer ut av takt. `fs-testcaser-intern` og `fs-testcaser-ekstern` leser tabellene i testplanen, og stiller ikke spørsmålene selv.

## Hvor svarene står

Testplanen (`akseptansetest/<slug>/testplan.md`) har to tabeller (se `fs-testplan/references/mal-testplan.md`):

- **Testbrukere:** `Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til`
- **Testdata:** `Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av`

**Miljøfila** for testmiljøet (`cdp-tester/_Miljøer/<miljø>.md`, se *Miljøfila* i `cdp-tester/README.md`) er den autoritative oversikten over personaene og rollene i FS Admin, og over verdiene til nøklene. Testene i `cdp-tester/` slår bare opp der, og kjenner ikke testplanen. Har miljøfila svaret, vis det og spør om det fortsatt gjelder, i stedet for å spørre på nytt. Nye nøkler og verdier legges inn i miljøfila når brukeren sier ja.

`Nr`, `Navn`, `Hva` og `Brukes til` er for menneskene og for testcasene. `Nøkkel`, `Innlogging`, `Start-URL`, `Søk/URL`, `Utgangstilstand` og `Brukes av` er for den agentiske funksjonstesten (fase 2), og er alltid med: fase 2 er en del av flyten, ikke et valg.

**Nøkkelen** er et stabilt navn i kebab-case, uten æ, ø og å, som beskriver det scenarioet trenger, og ikke det miljøet eller testplanen velger. Testene i `cdp-tester/` bruker nøkler, aldri «testbruker 1» eller et navn, siden nummer og navn hører til én testplan. En nøkkel endres ikke når testbrukeren eller organisasjonen byttes.

- **Testbruker:** `<rolle>-<relasjon>`. Rollen er forretningsrollen i kebab-case (`opptak-forvalter`, `opptak-saksbehandler`, `brukeradministrator`). Relasjonen er det scenarioet sier om organisasjonen: `forvaltende`, `deltakende`, `ikke-deltakende`, `lokalt`, `annen-organisasjon`. Trenger bare ett scenario rollen, holder rollen alene. Eksempler: `opptak-forvalter-forvaltende`, `brukeradministrator-annen-organisasjon`.
- **Testdata:** tilstanden, ikke verdien: `opptak-samordna-uten-utdanningstilbud`, `regelverkssamling-samordna`, ikke `regelverkssamling-uhg-2027`.
- **Aldri** navnet på en organisasjon, en person, et år eller et nummer i nøkkelen (ikke `-hkdir`, `-ntnu`, `-2027`). Krever scenarioet noe av organisasjonen (for eksempel at den er en fagskole), står det som en egenskap i beskrivelsen i «Krever», ikke i nøkkelen.

**Aldri passord eller hemmeligheter** i testplanen eller miljøfila. `Innlogging` er raden testbrukeren har i «Overstyrt bruker» (nedtrekksmenyen øverst til høyre i FS Admin, normalen i TEST), skrevet nøyaktig som i menyen: `<NAVN> • <rolle> (<organisasjon>)`, for eksempel `ANSVARSFULL FOTKREM • OPPTAK_FORVALTER (NTNU)`. Navnet alene er ikke nok: samme person kan ha flere roller og organisasjoner. Logger testbrukeren inn for seg, er `Innlogging` navnet på Chrome-profilen eller Feide-ID-en.

## Finne rollene og foreslå testbrukere

Rollene og organisasjonene foreslås fra koden og miljøet, ikke fra en tidligere testplan. Teamet bekrefter forslaget. Gjør dette før spørsmålene under, og vis forslaget i spørsmålet om testbrukere.

1. **Hva skjermene krever.** For hver skjerm scenarioene bruker: rollene i `WithRole`, `useWithRole` og `useOrganisasjonerWithRole` i fs-admin (`frontendrolle.*`, generert i `src/common/types/generated/tilgangsroller.ts`), eller i min-kompetanse for søkeren. Vis `fil:linje`.
2. **Hva API-et krever.** Tilgangene mutasjonene og spørringene sjekker i fs-plattform: `Handling.java` (for eksempel `MODIFISERE_OPPTAK`, `MEDLEM_OPPTAK`) og radnivåsikkerheten i migreringene (`har_tilgang`, `har_deltakertilgang`). Vis `fil:linje`.
3. **Forretningsrollen som gir dem.** Testbrukeren har forretningsroller (`forretningsrolle.*`, for eksempel `OPPTAK_FORVALTER`), som gir tilgangene over gjennom rollekatalogen. Katalogen hentes med spørringen `tilgangsroller` (som `GET_ROLLEHIERARKI` i fs-admin, `src/common/lib/persona/services/rollehierarki.ts`). Kan den ikke hentes, skriv hvilken tilgang som ikke er bekreftet, som `[Fylles ut: …]`.
4. **Relasjonene i scenarioene.** Hvilke organisasjoner scenarioene skiller mellom (forvaltende, deltakende, ikke deltakende, lokalt, annen organisasjon), og hva de krever av dem (type lærested, at organisasjonen ikke er deltaker). Én nøkkel per kombinasjon av rolle og relasjon.
5. **Personaene som finnes.** Personaene i «Overstyrt bruker» står i «Personaer» i miljøfila, med rollene og organisasjonen (fra `TEST_PERSONAS` i fs-admin). Foreslå én persona per nøkkel derfra, med en egen organisasjon per relasjon, og som oppfyller kravene i punkt 4. Er katalogen gammel, eller finnes ingen som passer, følg *Vedlikehold av miljøfila* i `cdp-tester/README.md` først. Finnes det fortsatt ingen, si det: personaen må legges til i fs-admin, og tildelingen i tilgangsstyring.
6. **Bekreft i miljøet.** Tildelingene bekreftes med spørringen `testpersoner`, etter *Vedlikehold av miljøfila* i `cdp-tester/README.md`, og står i «Tildelinger» og «Bekreftet» på personaen i miljøfila. Er personaen ikke bekreftet, si det. Testene kan lages likevel.

Skriv koblingen fra nøkkel til persona i «Testbrukere» i miljøfila når brukeren sier ja, og i testplanen når skillen er `fs-testplan`. Fødselsnummeret skrives ikke i miljøfila eller testplanen: personaen velges i menyen.

## Testdata

Data i testmiljøet kan slettes eller nullstilles når som helst. Derfor lager de automatiserte testene dataene sine selv, i hver kjøring, og bygger aldri på data fra en tidligere kjøring. I fase 2 gjør oppsettet det (`cdp-tester/_Oppsett/<sti>/oppsett.feature`, se *Oppsettet* i `cdp-tester/README.md`): ett scenario per testdata-nøkkel, gjennom løsningen. Testplanen sier hvilke testdata testene trenger, og at oppsettet lager dem.

Bare dette står i miljøfila, og må finnes i testmiljøet før kjøringen: personaene, grunndata (kodeverk, organisasjoner, regelverkssamlinger) og data testene ikke kan lage gjennom løsningen (for eksempel en søker med søknad, når testen går i FS Admin). Det siste får en nøkkel med `[Fylles ut]`, og en kommentar i oppsettet om hvorfor oppsettet ikke lager det.

For hvert krav:

- **Hva scenarioene trenger** (`Gitt`-stegene og de utledede testcasene): hvert objekt får en nøkkel og en utgangstilstand. Kan det lages gjennom løsningen, får det et scenario i oppsettet. Ellers får det en rad i miljøfila.
- **Overleveringer i en flyt** (`Brukes av` er en `@FLY-`-ID, fase 3): tilstanden skal være laget gjennom løsningen i fasen før, ikke lagt inn direkte. Si hvilken fase i `Utgangstilstand`.
- **Datoer i forhold til testdagen.** For hvert opptak eller annet objekt som må være i en bestemt tilstand, står fristene som bestemmer tilstanden, i forhold til dagen testen kjøres: `{DATO:-7}` for 7 dager før og `{DATO:+30}` for 30 dager etter. En snarvei som setter alle datoene til i dag (for eksempel «Fyll inn testdatoer»), brukes ikke når tilstanden forutsetter noe annet.
- **Data scenarioet selv lager** (for eksempel «Opprett opptak»), er ikke testdata: de lages av stegene i testcasen, og får `{KJØRING}` i navnet når de ikke kan slettes (R13 i `testcase-regler.md`).
- Oppsettet kjøres først i hver kjøring. Feiler et scenario i oppsettet, blir testene som bruker nøkkelen, «Ikke testet».

## Spørsmålene

Still dem samlet med `AskUserQuestion`, høyst fire om gangen. Har en tidligere testplan eller miljøfila svart for de samme kravene, vis svaret og spør om det fortsatt gjelder.

1. **Roller:** list rollene kravene nevner (`Som <rolle>`, `Gitt jeg er <rolle>`, rollene i *Synlighet*-regler), og les koden og vis hva den krever, med fil:linje, og hva som avviker fra kravene (se under).
2. **Testbrukere:** vis forslaget fra *Finne rollene og foreslå testbrukere* (nøkkel, persona, organisasjon, og om tildelingen er bekreftet), og spør om det stemmer. Nummerer dem fra 1. Testbrukerne skal finnes i rollene scenarioene nevner, ved de organisasjonene kravet gjelder. Har kravet scenarioer om synlighet (hva en rolle ser fra organisasjonene den administrerer), trengs data fra minst to organisasjoner. Antallet bestemmes per krav ut fra tilgangsmatrisen: tilgangsradene i verify-rapporten (roller × organisasjon). Scenarioene testes som de står, men det lages ikke egne testcaser for roller og tilgang (de er verifisert i koden i fase 1), så det trengs ikke testbrukere bare for å vise at en rolle mangler tilgang. Spør også etter `Innlogging` (verdien i «Overstyrt bruker», ellers Chrome-profilnavn eller Feide-ID) og eventuelt `Start-URL`.
3. **Testdata:** for hvert krav, etter *Testdata* over: de dataene scenarioene krever, med nøkkel, `Utgangstilstand` (med datoene i forhold til testdagen) og `Brukes av` (Feature-ID og scenario, eller testcase-Nr), og om oppsettet lager dem. Spør bare om grunndata og data oppsettet ikke kan lage: hvor de ligger, og `Søk/URL`. Gjelder en testcase en flyt: hvilken fase som lager tilstanden.
4. **Miljøet:** URL til testmiljøet, versjon og feature-flagg. Det er alltid et testmiljø, aldri produksjon. Kan testdataene settes tilbake før hver kjøring?

Det brukeren hopper over, skrives som `[Fylles ut: <hva>]`. Gjett aldri det bare teamet vet.

## Lese koden

Kravene sier hvilken rolle brukeren har («brukeradministrator»), ikke hva løsningen krever. Les kodeklonene (som i *Kodeklonene* i `fs-verify`), og vis:

- **Frontend (fs-admin, min-kompetanse):** rollen eller rettigheten som gir tilgang til siden og menypunktet (`WithRole`, `Menu`), feature-flaggene (`FeatureFlag`, og om de alltid er på i testmiljøet), skjermens ord, de obligatoriske feltene og standardverdiene.
- **Backend (fs-plattform):** hva som bestemmer hva brukeren får se (rettigheter og radnivåsikkerhet), og hvilke tilstander i dataene som må finnes for scenarioene.
- **Avvik** mellom kravet og koden (for eksempel at synligheten i koden har flere grener enn kravet) står i testplanens «Kjente begrensninger», og gjør de berørte scenarioene svake. Endre aldri kravene: foreslå `fs-krav`.
- Les med `git show origin/main:<sti>`, og si fra om hvor gammel klonen er. Kjør aldri `git pull` eller andre endrende kommandoer i kodeklonene.

## Ekte personer

Testplanen og testene har bare Feide testbrukere og syntetiske personer. Ser en verdi ut som et ekte fødselsnummer eller et ekte navn, stopp og spør.
