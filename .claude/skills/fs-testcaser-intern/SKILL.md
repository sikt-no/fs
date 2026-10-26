---
name: fs-testcaser-intern
description: Lager testcasene for den interne akseptansetesten (fase 3, domeneekspertene), etter teststrategien «Teststrategi for FS – fra krav til akseptanse» (forslag) i Confluence (STUDIEADM). Bygger på testplanen (`akseptansetest/<slug>`) og rapporten fra den agentiske funksjonstesten (fase 2), og leser kravene fra «Omfang» og flytene fra «Flyter» i testplanen. Den interne testen tester flyter og avhengigheter, ikke enkeltfunksjoner: feltvalidering, feilsituasjoner og grenseverdier er testet i fase 2, og tilgang er sjekket i fase 1. Skillen vurderer per krav om det inngår i en flyt i `krav/_Flyter` og om flyten skal testes (ellers: ny flyt eller koble kravet til en eksisterende), og lager én testcase per flyt, i rekkefølgen arbeidsprosessen går, med hensikt, testdata, forventet resultat, avhengighetene som sjekkes underveis og eget resultat per scenario. Tar bare med scenarioene som inngår i flytene, og regresjon av tidligere leverte flyter når leveransen endrer noe andre bygger på (funnet med `@depends-on-`). Lager et avhengighetskart sammen med teamet når testleder vurderer at leveransen trenger det. Stegene har testbrukeren fra testplanen, ordene fra skjermen (fra koden i fs-admin og min-kompetanse, `<feature>.design.md` eller skissene), alle verdiene, og en sjekk av at det er lagret. Skriver `akseptansetest/<slug>/testcaser-intern.md`, og oppretter undersiden «Intern akseptansetest – <leveranse>» under testplanen bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testcaser for intern akseptansetest", "intern akseptansetest", "flyttester for domeneekspertene", "testcaser fra testplanen", "avhengighetskart", "fs-testcaser-intern".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testcaser for intern akseptansetest

## Task

$ARGUMENTS

## Din rolle

Du lager flyttestene testansvarlig kan følge i løsningen uten å kjenne den fra før. Det er fase 3 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326), og siden er en underside til testplanen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)).

Fra strategien:

- **Mål:** bekrefte at leveransen virker i arbeidsprosessen og sammen med resten av FS, faglig sett.
- **Hva testes:** flyter (oppgaver i arbeidsprosessen, i den rekkefølgen brukerne jobber) og avhengigheter. Ikke enkeltfunksjoner.
- **Hvilke scenarioer:** scenarioene som inngår i flytene, ikke alle scenarioene i kravene. Dessuten regresjon av tidligere leverte flyter når leveransen endrer noe andre bygger på.
- **Hvor grundig:** feilsituasjoner, grenseverdier og obligatoriske felt er testet i fase 2 (den agentiske funksjonstesten), og tilgang er sjekket i fase 1 (`fs-verify`). De testes ikke på nytt. Testansvarlig kan ta stikkprøver.
- **Rekkefølge:** rekkefølgen i arbeidsprosessen, ikke rekkefølgen i feature-fila.
- **Testcasen inneholder:** én flyt som går gjennom flere scenarioer, med hensikt, testdata og forventet resultat, og med avhengighetene som sjekkes underveis. Hvert scenario i flyten får eget resultat.

Og:

- **Kravene er fasit for hva som skjer, testplanen for hva som testes og for testdataene.** Eksemplene i Gherkin er eksempler. Testbrukerne og testdataene kommer fra testplanen.
- **Fase 2 er gjort.** Den agentiske funksjonstesten er ferdig, og rapporten er gjennomgått av testansvarlig, før denne testen starter. Les rapporten: den sier hva som er dekket, og funnene som ikke er rettet, kan påvirke flytene.
- **Endre aldri kravene eller taggene.** Er et scenario ikke testbart som det står (uklart, mangler forventet resultat, motsier et annet krav), noter det, og foreslå `fs-krav`. `@openquestion` stopper ikke testen (*Åpne spørsmål* i `krav-fra-testplan.md`).
- **Akseptansetest er ikke fs-verify og ikke funksjonstest.** Verify-rapporten sier hva som finnes i koden, og den agentiske rapporten hva som virker som kravet sier. Dette er testen av at det henger sammen.
- **Publiser aldri uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i kodeklonene.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`.claude/references/akseptansetest/testcase-regler.md`](../../references/akseptansetest/testcase-regler.md): reglene for testcasene og sjekklista.
2. [`references/mal-intern.md`](references/mal-intern.md): malen og nummereringen.
3. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): kravene i testplanen, gating-settet og flytene.
4. [`.claude/references/akseptansetest/alvorlighetsgrad.md`](../../references/akseptansetest/alvorlighetsgrad.md): tekstene om funn, funntyper og alvorlighetsgrad.
5. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

## 1. Les testplanen og rapporten fra fase 2

Finn testplanen etter *Finn testplanen* i `confluence.md`. Les `testplan.md`, og siden i Confluence når den finnes (den kan ha det teamet har fylt ut etter at fila ble laget: testbrukere, testdata, miljø). Fra testplanen trenger du:

- kravene i «Omfang» (med Feature-ID), «Venter på verifisering» og de åpne spørsmålene, og kilden og scope-id-ene
- flytene i «Flyter»: om hele flyten eller deler av den testes, og fasene som er med
- avhengighetskartet, når testplanen har et
- de nummererte testbrukerne, med rolle og organisasjon
- testdataene, og testmiljøet (URL)
- «Ikke med i denne testen»

Les så den agentiske testrapporten (`testrapport-agentisk-*.md` i `akseptansetest/<slug>/`, eller siden i Confluence). Er den ikke laget, eller er utfallet ikke fylt ut av testansvarlig, eller står det åpne funn med «Stopper», si det, og spør om du skal fortsette. Inngangskriteriet til fase 3 er at fase 2 er ferdig og gjennomgått.

Er testbrukere eller testdata `[Fylles ut …]` i testplanen, si det før du begynner. Testcasene får da `[Fylles ut: …]` på de samme stedene.

## 2. Vurder hvert krav mot flytene

Teamet og testansvarlig avgjør hva som testes, og du forbereder vurderingen. For hvert krav i «Omfang» (bare krav som er `@implemented`, eller de leverte delene i et krav som er endret eller delvis levert):

1. **Inngår kravet i en flyt?** Finn flytene som går gjennom kravet etter *Finn flytene* i `krav-fra-testplan.md` (`grep -rln "@depends-on-<Feature-ID>" krav/_Flyter/`).
2. **Ja:** skal flyten testes, hele eller deler av den (*Hele eller deler av flyten* i `krav-fra-testplan.md`)? Testplanen har svaret når den har en «Flyter»-del. Er det uklart, spør (`AskUserQuestion`).
3. **Nei:** skal det lages en ny flyt, eller kobles kravet til en eksisterende flyt? Vis forslaget, og spør. Ny flyt og ny `@depends-on-` skrives med `fs-krav` (flyter), ikke her: kravet står i «Ikke med i denne testen» med «Venter på flyt» til det er gjort, med mindre brukeren sier at kravet skal testes som en enkel oppgave uten flyt.
4. **Regresjon.** Endrer leveransen noe andre krav bygger på? Finn kravene og flytene som bygger på det som er endret (`grep -rn "@depends-on-<Feature-ID>" krav/`, og ankrene, se *Anker* i `krav/README.md`). Er en slik flyt `@implemented` fra før, og går den gjennom delen som er endret, foreslå å teste den på nytt, med de samme scenarioene som sist. Spør teamet.

Vis oversikten (krav → flyt → testes/ikke testes, og regresjonsflytene) før du skriver.

## 3. Finn scenarioene i flytene

1. For hver flyt som testes: fasene som er med, i rekkefølgen i flyten, og scenarioene i hver fase. Har en flyt fått ny status siden testplanen ble laget, gjelder statusen i fila.
2. **Bare det som inngår i flytene.** Fra kravene fasene bygger på: hovedflyten i dem, altså scenarioene som lager tilstanden i `Gitt` i flytens scenarioer, og scenarioene brukeren går gjennom i fasen. Feilsituasjoner, grenseverdier og obligatoriske felt tas ikke med (fase 2).
3. Gating-settet gjelder fortsatt (`krav-fra-testplan.md`): ingen `@draft`, `@deprecated` eller `@demo`. Et scenario med `@openquestion` (uten `@draft`) blir testcase som det står, med spørsmålet under tabellen.
4. Les den nyeste verify-rapporten og den agentiske rapporten. Et scenario som er `ikke funnet` eller `usikker` i verify, eller har et åpent funn i fase 2, spør du teamet om før du tar det med.

## 4. Finn ordene fra skjermen

For hvert krav som er med, les:

- `<feature>.design.md` ved siden av kravet: tekstene, feltene og feilmeldingene
- skissene i `spec/krav-input/**/sketches/` i oppgaven
- kodeklonene (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren): menyene, rutene, knappene, feltene, hvilke felt som er obligatoriske, og forhåndsutfylte verdier. Spør om stien til klonene hvis de mangler (som i *Kodeklonene* i `fs-verify`).
- stegene og ordene i den agentiske testen (`cdp-tester/`, og `kjoring-*/resultat.md`) når den finnes: de er sjekket mot skjermen.

Uten kode merkes stegene der ordene er usikre, `[Sjekk begrep]`.

## 5. Sjekk hva som kan testes i miljøet

| Klasse | Når | I testcasene |
|---|---|---|
| Testbar | Funksjonen finnes i miljøet, og resultatet kan ses | Testcase |
| Testbar delvis | Verdien kan settes og lagres, men virkningen finnes ikke i miljøet ennå | Testcase for det som kan testes, og en rad i «Ikke testbart nå» for resten |
| Ikke testbar nå | Funksjonen ligger bak et flagg som er av, testdataene finnes ikke, eller resultatet kan ikke ses i miljøet | «Ikke testbart nå», med grunn og når det kan testes |

Er du usikker, spør teamet (`AskUserQuestion`).

## 6. Avhengighetskart

Testleder vurderer om leveransen trenger et avhengighetskart. Har testplanen et, bruk det. Ellers spør (`AskUserQuestion`): «Trenger leveransen et avhengighetskart?» Svarer teamet ja, hjelper du med å liste avhengighetene i «Avhengigheter» i testen, fra kravene (`@depends-on-`, `@ref-`), `utforing.md` (overleveringen) og teamet:

- andre moduler i FS
- integrasjoner
- batchjobber
- rapporter og eksport
- andre teams leveranser

Avhengigheter er det leveransen bygger på eller påvirker utenfor brukerens flyt. For hver: hva den er, hvordan den sjekkes, og om den sjekkes underveis i en flyt (da står den som et steg i flyten, og i kolonnen «Avhengighet» i tabellen) eller testes for seg (egen testcase, «Avhengigheter som testes for seg»). Gjett ikke: det teamet ikke vet, står som `[Fylles ut: …]`.

## 7. Skriv testcasene

Følg `testcase-regler.md` for hver testcase, og malen for formen:

- **Én testcase per flyt** (eller per del av flyten som testes, når hele flyten blir for lang: da bruker den neste testcasen dataene fra den første). Rekkefølgen er arbeidsprosessen, og med flere flyter den rekkefølgen brukerne møter dem. Med scope: oppgavene i rekkefølgen i scope-tabellen bare der det ikke strider mot arbeidsprosessen.
- «Hensikt» og «Testdata» over tabellen, og «Avhengigheter som sjekkes» når flyten har noen.
- **Hvert scenario i flyten er en rad** (en del), med scenariotittelen fra kravet eller flyten, og eget «Faktisk resultat» og «Status». Ved en scenariomal: én rad per eksempelrad som brukes i flyten.
- Stegene løper gjennom hele testcasen, bruker testbrukerne og testdataene fra testplanen, og ordene fra skjermen. Tilstanden fra en tidligere fase lages gjennom løsningen i fasen før, ikke settes direkte (R10: «Bruk søknaden fra 1.2»).
- «Forventet resultat» er det `Så` sier, sett der den neste aktøren jobber: at tilstanden er brukt, ikke bare lagret.
- **Regresjonsflyter** står i en egen del etter flytene i leveransen, med de samme scenarioene som sist og en kort «Hvorfor regresjon».
- «Faktisk resultat» og «Status» står tomme.
- Sporingen (testcase og del → Feature-ID, regel og scenario) står i metadataene.
- Ingen testcaser for feltvalidering eller feilmeldinger. Mangler et viktig tilfelle i kravet, legges det inn med `fs-krav`.

## 8. Kvalitetssikre og vis fram

1. Gå gjennom sjekklista i `testcase-regler.md`, og rett det du kan selv. Det som krever teamet, står igjen som `[Fylles ut …]` eller `[Sjekk begrep]`.
2. Vis oppsummeringen: antall testcaser (flyter) og deler (scenarioer), regresjonsflytene, beregnet tid (2–4 minutter per del), kravene som ikke er med i en flyt og hvorfor (og forslaget om ny flyt), avhengighetene, det teamet må fylle ut, og scenarioer som bør tilbake til `fs-krav`. Er testen lengre enn 2 timer (tidsrammen i rutinen), foreslå å dele den i to økter.
3. Spør om siden skal opprettes i Confluence, som underside til testplanen (`confluence.md`, *Før du skriver*). Finnes siden fra før, og testerne har begynt, følg *Oppdatere en side som finnes*: det som er fylt ut, skrives aldri over.
4. Oppdater raden «3. Intern akseptansetest» i «Status i flyten» («Klar til test»), og forutsetningen om at testansvarlig har gått gjennom flyttestene («Laget, venter på gjennomgang av testansvarlig») i testplanen.
5. Skriv lenken i metadataene, og foreslå teksten til Slack-tråden.

Gjennomføringen: testansvarlig følger testcasene, og fører resultat og funn (med funntype og «Fase funnet») i testsiden. Sluttrapporten lages med `fs-testrapport` (intern), og beslutningen tas av testansvarlig.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene eller testplanen (utenom raden i «Status i flyten» og forutsetningen om gjennomgang).
- Lager ikke testcaser for enkeltfunksjoner, feltvalidering, feilsituasjoner eller grenseverdier (`fs-testcaser-cdp`, fase 2), og ikke tester av universell utforming eller automatiske tester (det er `lage-steps`). Scenarioene i flytene er ikke en helhetsrunde: de står i kravene, og tester én overlevering hver.
- Skriver ikke nye flyter (`fs-krav`), men foreslår dem.
- Fyller ikke ut resultater, og oppsummerer ikke testen (det er `fs-testrapport`).
- Kjører aldri git add/commit/push.
