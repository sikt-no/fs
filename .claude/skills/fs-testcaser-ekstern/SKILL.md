---
name: fs-testcaser-ekstern
description: Lager underlaget for den eksterne akseptansetesten (fase 4, erfarne brukere fra lærestedene, HK-dir og andre eksterne parter), etter teststrategien «Teststrategi for FS – fra krav til akseptanse» (forslag) i Confluence (STUDIEADM) og «Informasjonsskriv til eksterne testere». Testerne sjekker at de kan gjøre jobben sin i flytene leveransen skal understøtte, ut fra kravene våre: at hvert steg virker, og at stegene henger sammen. Grunnlaget er kravene for flytene i `krav/_Flyter` som leveransen inngår i, og flyttestene i den interne testen. Sikt velger flytene sammen med partene, og skillen lager testcasene (én per flyt, i rekkefølgen i arbeidsprosessen, uten tekniske ord), testbeskrivelsen (hva som er levert, versjon, flyter, miljø og URL, feature-flagg, testbrukere og roller, testdata og tilstanden dataene skal være i, avhengigheter), den skriftlige gjennomgangen av kravene for flytene, og oversikten over hva Sikt har testet i fase 1–3, med rapportene fra fase 2 og 3. Testdataene lages på forhånd, og testmiljøet nullstilles ikke i testperioden. Partene kan legge til egne testcaser når de har egne krav. Testerne svarer Ja, Nei eller Delvis per steg. Funn er feil (flyten lar ikke testeren gjøre jobben, eller løsningen avviker fra kravene) eller endringsforslag (behov flyten ikke dekker, går til kravarbeidet). Bygger på testplanen (`akseptansetest/<slug>`) og testrapporten fra den interne testen (bare leveranser godkjent internt). Skriver `akseptansetest/<slug>/testcaser-ekstern.md` og `flytbeskrivelser-ekstern.md`, og oppretter undersiden «Ekstern akseptansetest – <leveranse>» under testplanen bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testcaser for ekstern akseptansetest", "ekstern akseptansetest", "testbeskrivelse til eksterne testere", "gjennomgang av kravene med partene", "flytbeskrivelser til HK-dir", "akseptansetest for HK-dir", "akseptansetest for lærestedene", "fs-testcaser-ekstern".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testcaser for ekstern akseptansetest

## Task

$ARGUMENTS

## Din rolle

Du lager det de eksterne testerne trenger for å teste at de kan gjøre jobben sin i flytene leveransen skal understøtte: testcasene for flytene, testbeskrivelsen, gjennomgangen av kravene for flytene, og oversikten over hva Sikt allerede har testet. Det er fase 4 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326), og siden er en underside til testplanen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)). Testerne får [Informasjonsskriv til eksterne testere](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155815432), som forklarer testen for dem. Det du lager, er Sikts side av den samme testen, og ordene på testsiden skal stemme med informasjonsskrivet.

- **Mål** (fra strategien): de eksterne partene bekrefter at de kan gjøre jobben sin i flytene leveransen skal understøtte: at hvert steg virker, og at stegene henger sammen.
- **Grunnlaget er kravene våre for flytene som testes.** Sikt går gjennom de relevante kravene med partene i et møte før testen, eller sender dem skriftlig informasjon. Testen vurderer ikke om kravene er riktige: behov kravene ikke dekker, er endringsforslag. Partene kan legge til egne testcaser når de har egne krav, for eksempel HK-dir.
- **Sikt velger flytene sammen med partene.** Flytene er flytene i `krav/_Flyter` som leveransen inngår i, laget ut fra flyttestene i fase 3.
- **Hvor grundig:** hvert steg i flyten skal virke, og stegene skal henge sammen: endringen er lagret, står der når saken åpnes igjen, og blir brukt i neste steg. Enkeltfunksjoner, feltvalidering og feilmeldinger testes ikke, utenom det som er en del av flyten. Roller og tilgang er verifisert i fase 1. Universell utforming og regresjon testes ikke her.
- **Bare leveranser som er godkjent internt.** Den eksterne testen bygger på fase 1–3.
- **Testerne kjenner fagfeltet, ikke løsningen.** Siden bruker ordene fra arbeidsprosessen og skjermen, ikke fra kravene og koden.
- **Én kontaktperson per test**, normalt testansvarlig. Kontaktpersonen svarer på spørsmål underveis, har ansvaret for at funnene blir fulgt opp, og fører resultatene.
- **Endre aldri kravene eller taggene.** Foreslå `fs-krav` når et krav er uklart, eller når partene har et behov kravene ikke dekker.
- **Publiser aldri uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i kodeklonene.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`.claude/references/akseptansetest/testcase-regler.md`](../../references/akseptansetest/testcase-regler.md): reglene for testcasene. Det som er annerledes i den eksterne testen, står i *Riktig nivå* og *R14*.
2. [`references/mal-ekstern.md`](references/mal-ekstern.md): malene for testsiden og flytbeskrivelsene, og nummereringen.
3. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): kravene i testplanen og flytene.
4. [`.claude/references/akseptansetest/alvorlighetsgrad.md`](../../references/akseptansetest/alvorlighetsgrad.md): tekstene om funn, funntyper, alvorlighetsgrad og beslutning.
5. [`.claude/references/akseptansetest/roller-og-testdata.md`](../../references/akseptansetest/roller-og-testdata.md): *Testdata i den eksterne testen*.
6. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

## 1. Les testplanen, den interne testen og rapportene

1. Finn testplanen etter *Finn testplanen* i `confluence.md`. Fra den trenger du kravene i «Omfang», flytene i «Flyter», kilden og scope-id-ene, oppgavene, testbrukerne, testdataene, testmiljøet, kontaktpersonen og de eksterne testerne.
2. **Er leveransen godkjent internt?** Les den nyeste `testrapport-intern-*.md`, eller siden «Testrapport – intern akseptansetest – …». Er utfallet ikke fylt ut, eller er det «Ikke godkjent», si det, og spør om du skal fortsette. Ved «Godkjent med forbehold»: ta med de kjente manglene i «Dette kan du ikke gjøre i testen» når de berører testcasene.
3. Les også den agentiske testrapporten (`testrapport-agentisk-*.md`): partene skal få den, og den viser hva som er testet i fase 2.
4. Les `testcaser-intern.md`: flyttestene, stegene, ordene fra skjermen og testdataene kan gjenbrukes. Det er den beste kilden til stegene og til flytbeskrivelsene.
5. **Flere leveranser i samme runde.** Strategien foreslår å samle flere leveranser til én testrunde, for eksempel én runde før viktige tidspunkter som simulering av opptak. Har testplanen flere kilder (flere scope, mapper eller filer), er de alle med. Skal testen ta med leveranser fra andre testplaner, spør om hvilke.

## 2. Velg flytene sammen med partene

1. **Flytene leveransen inngår i:** flytene i «Flyter» i testplanen, og flyttestene i `testcaser-intern.md` (også oppgavene uten flyt). Fasene i flyten er rekkefølgen. Mangler flyttestene, bruk rekkefølgen oppgavene står i scope-tabellen, brukerhistoriene, og hvilke data et scenario lager som et annet bruker (opprette et opptak → registrere en søknad → behandle den), og si det i oppsummeringen. Går leveransen over flere domener, følger rekkefølgen arbeidsprosessen, ikke domenene.
2. **Spør (`AskUserQuestion`, `multiSelect`) hvilke flyter som testes**, med forslaget ditt først. Er flytene allerede avtalt med partene, bruk dem. Eksterne tester bare det de skal bruke: i et samordna opptak er det flytene for samordna opptak, ikke for lokale opptak.
3. **Hvem testerne er, og hvem som beslutter:** les testplanen. Mangler kontaktpersonen, testerne eller hvem som beslutter, spør. Hvem som beslutter, skal være avtalt med partene før testen. Er det ikke avtalt, skriv `[Fylles ut: hvem beslutter, avtales med partene før testen]`.
4. **Partenes egne krav:** spør (`AskUserQuestion`) om partene har egne krav, for eksempel HK-dir. Har de det, kan de legge til egne testcaser i «Testcaser fra partene». Passer et av partenes krav ikke med kravene våre, er det ikke noe du retter: det er et mulig endringsforslag, og står i oppsummeringen med forslag om `fs-krav`.

## 3. Del flytene i testcaser

1. **Én testcase per flyt**, eller per del av flyten som testes, når den holder seg innenfor tidsrammen. Hensikten er en oppgave testeren kjenner igjen fra jobben sin («Sett opp et opptak og åpne det for søknader»). Er flyten for lang, del den mellom to faser, og la den neste testcasen bruke dataene fra den første (R10).
2. **Hvert steg i flyten er en del** (`1a`, `1b`), med sin egen rad, som testeren svarer Ja, Nei eller Delvis på. Delene er delene i flyttesten fra den interne testen, i rekkefølgen i flyten, uten de delene partene ikke skal bruke. Scenarioet i flyten blir en egen del der den neste fasen starter: testeren sjekker at det som ble laget, er brukt («Søkeren har fått tilbud, uten at du har gjort noe mer»).
3. **At stegene henger sammen:** der et steg lagrer noe, sier forventet resultat at endringen står der når saken åpnes igjen, og den neste delen sier at det som ble registrert, er brukt.
4. **Bare det som er en del av flyten.** Feilsituasjoner, sperrer, feilmeldinger, obligatoriske felt og grenseverdier tas ikke med, utenom det som er en del av flyten. De står i «Ikke med i denne testen» med «Testet tidligere, i teamets egen testing og i Sikts interne akseptansetest».
5. Bruk ikke ordet «fase» på siden. Skriv hva brukeren gjør. «Flyt» kan brukes, som i informasjonsskrivet.
6. **Vis forslaget før du skriver stegene:** testcasene, delene, og hvilke scenarioer som er i hver. Spør om rekkefølgen og oppdelingen er riktig.

## 4. Skriv testsiden

- Følg `testcase-regler.md` og malen. Gjenbruk stegene fra `testcaser-intern.md`, men skriv dem som én sammenhengende flyt: stegene løper gjennom hele testcasen.
- «Hva du gjør» med vanlige ord, ikke scenariotittelen fra kravet.
- **Hensikt** og **Testdata** over hver tabell. Testdataene er laget på forhånd (steg 5), så testdata-linja sier hva som finnes og i hvilken tilstand, ikke hvordan det lages.
- **Testbeskrivelsen** øverst på siden, etter malen: hva som er levert, hvilken versjon, hvilke flyter som testes, miljø og URL, feature-flagg som er slått på, testbrukere og roller, testdata og tilstanden dataene skal være i, og avhengigheter som integrasjoner og batchjobber. Versjonen og feature-flaggene finner du i testplanen og verify-rapporten. Mangler de, skriv `[Fylles ut: …]`.
- Ingen Feature-ID-er, scope-id-er, tagger, kodeverdier, GraphQL eller Jira på siden. Feature-flagg står bare i testbeskrivelsen, med navnet testerne ser, eller som «slått på for testen». Sporingen står i metadataene.
- Svarkolonnene står tomme.
- En tom del «Testcaser fra partene», der partene kan legge inn egne testcaser.
- **Funn:** tabellen har funntypene «Feil» og «Endringsforslag» (*Funntype* i `alvorlighetsgrad.md`). «Andre funn» er for observasjoner utenfor testens omfang, for eksempel om brukervennlighet.
- **Spørsmål underveis:** siden sier hvem kontaktpersonen er, og hvordan spørsmål tas (e-post, telefon eller møte), som avtalt med testerne før testen. Er det ikke avtalt, skriv `[Fylles ut: hvordan spørsmål tas, avtales med testerne]`.

## 5. Testdataene og klar til test

Testdataene lages på forhånd, i tilstanden flytene forutsetter, så testerne ikke må lage eller lete fram testpersoner, opptak eller søknader selv (*Testdata i den eksterne testen* i `roller-og-testdata.md`).

1. List testdataene hver testcase trenger, med tilstanden: fra «Testdata» i testplanen og testdata-linjene i `testcaser-intern.md`. Data en testcase lager som den neste bruker, er ikke testdata.
2. Skriv dem i «Testdata som må lages før testen» i metadataene (over streken), med hvem som lager dem og når, og i testbeskrivelsen med vanlige ord.
3. Testmiljøet nullstilles ikke, og testdataene slettes ikke, i testperioden. Det avtales med dem som drifter testmiljøet: skriv avtalen i metadataene, eller `[Fylles ut: avtalt med drift]`.
4. Sjekklista «Klar til test» i metadataene: leveransen er godkjent internt og lagt ut i testmiljøet, kravene er gått gjennom med partene, testbeskrivelsen er klar, testdataene er laget, hvem som beslutter er avtalt, og kontaktpersonen har logget inn som hver testbruker og ser testdataene. Skillen krysser ikke av: det gjør kontaktpersonen.

## 6. Gjennomgangen av kravene og flytbeskrivelsene

Skriv `akseptansetest/<testplan-slug>/flytbeskrivelser-ekstern.md` etter malen, til partene. Den er den skriftlige gjennomgangen av kravene, og underlaget når gjennomgangen er et møte. Den har:

- **Flytene:** én beskrivelse per flyt som testes, fra flyttestene i `testcaser-intern.md` og fasene i flytene i `krav/_Flyter/`: hva som skjer fra start til slutt, hvem som gjør hva, og overleveringene mellom dem, med vanlige ord og uten tagger, Feature-ID-er og tekniske ord. Kjente brudd i flyten (`# Kjent brudd:`) står under «Dette kan du ikke gjøre i testen», uten saksnummer.
- **Kravene for flyten:** det løsningen skal gjøre i hvert steg, fra reglene og scenarioene i kravene fasen bygger på (bare de delene av kravet flyten bygger på, se *Anker* i `krav/README.md`), med vanlige ord. Én linje per regel, ikke ett scenario per linje. Ikke ta med feltvalidering og feilmeldinger, utenom det som er en del av flyten. Har en regel et åpent spørsmål, står det med vanlige ord.
- **Hva Sikt har testet:** en kort tabell per fase (verifisering, agentisk funksjonstest, intern akseptansetest) med utfall, funn som er rettet, og funn som står igjen (uten Jira-saker). Tallene og utfallet kommer fra rapportene.
- **Vedlegg:** lenker til den agentiske testrapporten og den interne testrapporten, slik at partene ser hva som er testet. Rapportene ligger i `akseptansetest/<slug>/` og i Confluence. Er en rapport ikke publisert, si det, og spør om den skal legges som underside (`confluence.md`). Rapporter kan ha Feature-ID-er, saksnumre og interne ord: sjekk dem, og si fra til brukeren hvis noe må fjernes før de deles.

## 7. Kvalitetssikre og vis fram

1. Gå gjennom sjekklista i `testcase-regler.md`, og sjekk at testsiden og flytbeskrivelsene ikke har intern informasjon (`Grep` etter `@`, `scope-`, `feature`, `GraphQL`, `Jira`, `BAT-`, `STEK-` i delen under streken, og `flagg` utenfor testbeskrivelsen).
2. Sjekk at ordene på testsiden stemmer med informasjonsskrivet: Ja, Nei eller Delvis, feil og endringsforslag, kontaktperson, og de tre utfallene.
3. Vis oppsummeringen: antall testcaser og steg, beregnet tid, det som er utelatt og hvorfor, testdataene som må lages før testen, det som må fylles ut, og partenes krav som ser ut som endringsforslag. Er testen lengre enn én time, foreslå å dele den.
4. Spør om testsiden og flytbeskrivelsene skal opprettes i Confluence, som undersider til testplanen (`confluence.md`, *Før du skriver*). Flytbeskrivelsene kan også ligge som en del av testsiden, hvis brukeren vil.
5. Oppdater raden «4. Ekstern akseptansetest» i «Status i flyten» («Klar til test» når sjekklista er krysset av, ellers «Forberedes»).
6. Skriv lenkene i metadataene. Foreslå teksten til invitasjonen til de eksterne testerne, med lenkene (informasjonsskrivet, testsiden, flytbeskrivelsene og rapportene), tidspunktet for gjennomgangen av kravene, og fristen. Skillen sender den ikke.

Gjennomføringen: testerne følger flytene steg for steg, og svarer Ja, Nei eller Delvis per steg. Kontaktpersonen fører det som bestått (Ja) eller ikke bestått med funn (Nei og Delvis), og et steg testeren ikke kom fram til, som ikke testet, med begrunnelse. Samme maler og alvorlighetsgrader som i den interne testen. Sluttrapporten lages med `fs-testrapport` (ekstern), bekreftet av deltakerne, og kontaktpersonen går gjennom resultatet med partene. Beslutningen er godkjent, godkjent med forbehold eller ikke godkjent, vurdert mot flytene og kravene. Godkjent og godkjent med forbehold er «Akseptert» i flyten.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene eller testplanen (utenom raden i «Status i flyten»).
- Vurderer ikke om kravene er riktige. Behov kravene ikke dekker, er endringsforslag.
- Skriver ikke partenes egne testcaser.
- Lager ikke testcaser for feilsituasjoner, feltvalidering, roller og tilgang, universell utforming eller regresjon, med mindre brukeren ber om det.
- Lager ikke testdataene i testmiljøet, og krysser ikke av i «Klar til test».
- Fyller ikke ut resultater, og oppsummerer ikke testen (det er `fs-testrapport`).
- Sender ikke invitasjoner, og deler ikke rapporter uten at brukeren har sagt ja.
- Kjører aldri git add/commit/push.
