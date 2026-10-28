---
name: fs-testcaser-ekstern
description: Lager underlaget for den eksterne akseptansetesten (fase 4, erfarne brukere fra lærestedene, HK-dir og andre eksterne parter), etter teststrategien «Teststrategi for FS – fra krav til akseptanse» (forslag) i Confluence (STUDIEADM). De eksterne partene har egne krav og akseptansekriterier, og lager eller eier testcasene sine: Sikts feature-filer er ikke grunnlaget. Skillen foreslår flyter som utgangspunkt, satt sammen til oppgaver i arbeidsprosessen fra flytene i testplanen og flyttestene i den interne testen, uten tekniske ord. Kan ta inn partenes egne krav og akseptansekriterier, og kartlegge hva Sikt allerede har testet i fase 1–3. Leverer også eksporten av flytbeskrivelsene fra den interne testen og rapportene fra fase 2 og 3 til partene, så de ser hva som er testet. Bygger på testplanen (`akseptansetest/<slug>`) og testrapporten fra den interne testen (bare leveranser godkjent internt). Bare hovedflyten: feilsituasjonene er testet i fase 2. Funn skilles i avvik fra Sikts krav (feil) og endringsforslag (krav vi ikke har, går til kravarbeidet). Skriver `akseptansetest/<slug>/testcaser-ekstern.md` og `flytbeskrivelser-ekstern.md`, og oppretter undersiden «Ekstern akseptansetest – <leveranse>» under testplanen bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testcaser for ekstern akseptansetest", "ekstern akseptansetest", "foreslå flyter til partene", "flytbeskrivelser til HK-dir", "akseptansetest for HK-dir", "akseptansetest for lærestedene", "fs-testcaser-ekstern".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testcaser for ekstern akseptansetest

## Task

$ARGUMENTS

## Din rolle

Du gir de eksterne partene det de trenger for å bekrefte at løsningen dekker deres egne krav: forslag til flyter å teste, flytbeskrivelsene fra den interne testen, og rapportene som viser hva Sikt allerede har testet. Det er fase 4 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326), og siden er en underside til testplanen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)).

- **Mål** (fra strategien): de eksterne partene bekrefter at løsningen dekker deres egne krav og behov.
- **Partene eier testcasene.** De har egne krav og akseptansekriterier, og lager eller eier testcasene sine. Feature-filene våre er ikke grunnlaget. Hvilke scenarioer som testes, hvor grundig og i hvilken rekkefølge bestemmer partene. Det du lager, er et forslag de kan bruke som utgangspunkt.
- **Bare leveranser som er godkjent internt.** Den eksterne testen bygger på fase 1–3.
- **Testerne kjenner fagfeltet, ikke løsningen og ikke kravene.** Siden bruker ordene fra arbeidsprosessen og skjermen, ikke fra kravene og koden.
- **Endre aldri kravene eller taggene.** Foreslå `fs-krav` når et krav er uklart, eller når partene har et krav vi ikke har.
- **Publiser aldri uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i kodeklonene.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`.claude/references/akseptansetest/testcase-regler.md`](../../references/akseptansetest/testcase-regler.md): reglene for testcasene. Det som er annerledes i den eksterne testen, står i *Riktig nivå*.
2. [`references/mal-ekstern.md`](references/mal-ekstern.md): malene for testcasene og flytbeskrivelsene, og nummereringen.
3. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): kravene i testplanen og flytene.
4. [`.claude/references/akseptansetest/alvorlighetsgrad.md`](../../references/akseptansetest/alvorlighetsgrad.md): tekstene om funn, funntyper og alvorlighetsgrad.
5. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

## 1. Les testplanen, den interne testen og rapportene

1. Finn testplanen etter *Finn testplanen* i `confluence.md`. Fra den trenger du kravene i «Omfang», flytene i «Flyter», kilden og scope-id-ene, oppgavene, testbrukerne, testdataene, testmiljøet og de eksterne testerne.
2. **Er leveransen godkjent internt?** Les den nyeste `testrapport-intern-*.md`, eller siden «Testrapport – intern akseptansetest – …». Er utfallet ikke fylt ut, eller er det «Ikke godkjent», si det, og spør om du skal fortsette. Ved «Godkjent med forbehold»: ta med de kjente manglene i «Dette kan du ikke gjøre i testen» når de berører testcasene.
3. Les også den agentiske testrapporten (`testrapport-agentisk-*.md`): partene skal få den, og den viser hva som er testet i fase 2.
4. Les `testcaser-intern.md`: flytene, stegene, ordene fra skjermen og testdataene kan gjenbrukes. Det er den beste kilden til stegene og til flytbeskrivelsene.
5. **Flere leveranser i samme runde.** Strategien foreslår å samle flere leveranser til én testrunde, for eksempel én runde før viktige tidspunkter som simulering av opptak. Har testplanen flere kilder (flere scope, mapper eller filer), er de alle med. Skal testen ta med leveranser fra andre testplaner, spør om hvilke.

## 2. Partenes egne krav

Spør (`AskUserQuestion`): «Har partene egne krav eller akseptansekriterier for denne leveransen?»

- **Ja, og vi har dem** (en fil, en Confluence-side eller en tekst): les dem. Kartlegg for hvert av partenes krav hva Sikt allerede har testet i fase 1–3 (kravet, flyten og testcasen i fase 2 eller 3 det svarer til), og hva som ikke er testet. Skriv kartleggingen i «Partenes krav og hva Sikt har testet» i flytbeskrivelsene. Gjett ikke: det du ikke finner svar til, står som «Ikke kartlagt».
- **Ja, men vi har dem ikke ennå:** lag forslaget, og skriv `[Fylles ut: partenes krav]` i «Partenes krav og hva Sikt har testet».
- **Nei, eller vet ikke:** lag forslaget, og si at partene bestemmer selv hva de tester.

Passer et av partenes krav ikke med kravene våre, er det ikke noe du retter: det er et mulig endringsforslag, og står i oppsummeringen med forslag om `fs-krav`.

## 3. Foreslå flyter og oppgaver

Du setter sammen et utgangspunkt. Partene kan ta det, endre det eller bytte det ut.

1. **Grunnlaget er den interne testen, ikke feature-filene.** Forslaget bygger på flyttestene i `testcaser-intern.md` (fase 3, også oppgavene uten flyt) og flytene i «Flyter» i testplanen: fasene i flyten er rekkefølgen, og de er beskrevet på tvers av domener fra før. Har partene egne krav (steg 2), går de foran: velg og ordne flytene etter dem, og si hvilke av partenes krav som ikke er dekket av noen flyt. Mangler flyttestene, bruk rekkefølgen oppgavene står i scope-tabellen, brukerhistoriene, og hvilke data et scenario lager som et annet bruker (opprette et opptak → registrere en søknad → behandle den), og si det i oppsummeringen. Går leveransen over flere domener, følger rekkefølgen arbeidsprosessen, ikke domenene.
2. **Bare hovedflyten:** scenarioene der brukeren får gjort det prosessen handler om. Feilsituasjoner, sperrer, feilmeldinger, obligatoriske felt og grenseverdier tas ikke med. De står i «Ikke med i denne testen» med «Testet i den agentiske funksjonstesten».
3. **Hvem testerne er:** spør (`AskUserQuestion`, `multiSelect`) hvilke deler som gjelder dem. Foreslå et utvalg ut fra rollene i kravene og partenes krav. Eksterne tester bare det de skal bruke: i et samordna opptak er det kravene for samordna opptak, ikke for lokale opptak.
4. **Del hovedflyten i oppgaver.** Én testcase er én oppgave med en hensikt testeren kjenner igjen fra jobben sin («Sett opp et opptak og åpne det for søknader»). Hver testcase går gjennom flere scenarioer, og hvert scenario er en del (`1a`, `1b`) med sin egen «Status».
   - **Med flyt:** én testcase per flyt, eller per del av flyten som testes, når den holder seg innenfor tidsrammen. Er flyten for lang, del den mellom to faser, og la den neste testcasen bruke dataene fra den første (R10). Delene er delene i flyttesten fra den interne testen, i rekkefølgen i flyten, uten de delene partene ikke skal bruke. Scenarioet i flyten blir en egen del der den neste fasen starter: testeren sjekker at det som ble laget, er brukt («Søkeren har fått tilbud, uten at du har gjort noe mer»).
   - Bruk ikke ordene «flyt» og «fase» på siden. Skriv hva brukeren gjør.
5. **Vis forslaget før du skriver stegene:** oppgavene, delene, og hvilke scenarioer som er i hver. Spør om rekkefølgen og oppdelingen er riktig.

## 4. Skriv testcasene

- Følg `testcase-regler.md` og malen. Gjenbruk stegene fra `testcaser-intern.md`, men skriv dem som én sammenhengende oppgave: stegene løper gjennom hele testcasen.
- «Hva du gjør» med vanlige ord, ikke scenariotittelen fra kravet.
- **Hensikt** og **Testdata** over hver tabell.
- Ingen Feature-ID-er, scope-id-er, tagger, kodeverdier, GraphQL, Jira eller feature-flagg på siden. Sporingen står i metadataene.
- «Faktisk resultat» og «Status» står tomme.
- Siden sier at dette er et forslag, og at partene kan legge til egne testcaser etter sine egne krav (en tom del «Testcaser fra partene»).
- **Funn:** tabellen har funntypene «Feil (avvik fra kravene våre)» og «Endringsforslag (krav vi ikke har)» (*Funntype* i `alvorlighetsgrad.md`), og siden sier hvor tilbakemeldingene sendes: den faste kanalen (spør kontaktpersonen, og skriv `[Fylles ut: kanal]` hvis den ikke finnes).

## 5. Flytbeskrivelser og rapporter til partene

Skriv `akseptansetest/<testplan-slug>/flytbeskrivelser-ekstern.md` etter malen, til partene. Den har:

- **Flytene:** én beskrivelse per flyt som testes, fra flyttestene i `testcaser-intern.md` og fasene i flytene i `krav/_Flyter/`: hva som skjer fra start til slutt, hvem som gjør hva, og overleveringene mellom dem, med vanlige ord og uten tagger, Feature-ID-er og tekniske ord. Beskriv hva brukeren gjør og ser, ikke hva som står i kravene. Kjente brudd i flyten (`# Kjent brudd:`) står under «Dette kan du ikke gjøre i testen», uten saksnummer.
- **Hva Sikt har testet:** en kort tabell per fase (verifisering, agentisk funksjonstest, intern akseptansetest) med utfall, funn som er rettet, og funn som står igjen (uten Jira-saker). Tallene og utfallet kommer fra rapportene.
- **Partenes krav og hva Sikt har testet** (steg 2), når partene har sendt dem.
- **Vedlegg:** lenker til den agentiske testrapporten og den interne testrapporten, slik at partene ser hva som er testet. Rapportene ligger i `akseptansetest/<slug>/` og i Confluence. Er en rapport ikke publisert, si det, og spør om den skal legges som underside (`confluence.md`). Rapporter kan ha Feature-ID-er, saksnumre og interne ord: sjekk dem, og si fra til brukeren hvis noe må fjernes før de deles.

## 6. Kvalitetssikre og vis fram

1. Gå gjennom sjekklista i `testcase-regler.md`, og sjekk at testsiden og flytbeskrivelsene ikke har intern informasjon (`Grep` etter `@`, `scope-`, `feature`, `GraphQL`, `flagg`, `Jira`, `BAT-`, `STEK-` i delen under streken).
2. Vis oppsummeringen: antall testcaser og deler, beregnet tid, det som er utelatt og hvorfor, det som må fylles ut, partenes krav som ikke er kartlagt eller ser ut som endringsforslag. Er testen lengre enn én time, foreslå å dele den.
3. Spør om testsiden og flytbeskrivelsene skal opprettes i Confluence, som undersider til testplanen (`confluence.md`, *Før du skriver*). Flytbeskrivelsene kan også ligge som en del av testsiden, hvis brukeren vil.
4. Oppdater raden «4. Ekstern akseptansetest» i «Status i flyten» («Klar til test»).
5. Skriv lenkene i metadataene. Foreslå teksten til invitasjonen til de eksterne testerne, med lenkene (testsiden, flytbeskrivelsene og rapportene) og fristen. Skillen sender den ikke.

Gjennomføringen: partene bestemmer hva de tester, og Sikt legger til rette og leder. Samme maler og alvorlighetsgrader som i den interne testen, og en fast kanal for tilbakemeldinger. Sluttrapporten lages med `fs-testrapport` (ekstern), bekreftet av deltakerne. Hvem som beslutter, avklares med partene.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene eller testplanen (utenom raden i «Status i flyten»).
- Bestemmer ikke hva partene tester, og skriver ikke testcasene deres. Den foreslår.
- Lager ikke testcaser for feilsituasjoner, med mindre brukeren ber om det.
- Fyller ikke ut resultater, og oppsummerer ikke testen (det er `fs-testrapport`).
- Sender ikke invitasjoner, og deler ikke rapporter uten at brukeren har sagt ja.
- Kjører aldri git add/commit/push.
