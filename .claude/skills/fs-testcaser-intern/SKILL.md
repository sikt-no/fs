---
name: fs-testcaser-intern
description: Lager testcasene for den interne akseptansetesten (fase 3, domeneekspertene), etter teststrategien «Teststrategi for FS – fra krav til akseptanse» (forslag) i Confluence (STUDIEADM). Bygger på testplanen (`akseptansetest/<slug>`) og rapporten fra den agentiske funksjonstesten (fase 2), og leser kravene fra «Omfang» og flytene fra «Flyter» i testplanen. Den interne testen har fire deler: det den agentiske testen ikke klarte (testcasene fra fase 2 som ble «Ikke testet»), flyter og avhengigheter, opplevelse og helhet (forståelig og brukbar i arbeidsprosessen, tekster og fagspråk, universell utforming), og det med høyest risiko, valgt av testansvarlig. Feltvalidering, feilsituasjoner og grenseverdier fase 2 har bestått, testes ikke på nytt, og tilgang er sjekket i fase 1 (planen). Skillen vurderer per krav om det inngår i en flyt i `krav/_Flyter` og om flyten skal testes (ellers: ny flyt eller koble kravet til en eksisterende), og lager én testcase per flyt (eller per oppgave uten flyt, for krav som ikke hører til en flyt), i rekkefølgen arbeidsprosessen går, med hensikt, testdata, forventet resultat, avhengighetene som sjekkes underveis og eget resultat per scenario. Tar bare med scenarioene som inngår i flytene, og regresjon av tidligere leverte flyter når leveransen endrer noe andre bygger på (funnet med `@depends-on-`). Lager et avhengighetskart sammen med teamet når testleder vurderer at leveransen trenger det. Stegene har testbrukeren fra testplanen, ordene fra skjermen (fra koden i fs-admin og min-kompetanse, `<feature>.design.md` eller skissene), alle verdiene, og en sjekk av at det er lagret. Skriver `akseptansetest/<slug>/testcaser-intern.md`, og oppretter undersiden «Intern akseptansetest – <leveranse>» under testplanen bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testcaser for intern akseptansetest", "det CDP ikke klarte", "opplevelse og helhet", "risikobasert test", "intern akseptansetest", "flyttester for domeneekspertene", "testcaser fra testplanen", "avhengighetskart", "fs-testcaser-intern".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testcaser for intern akseptansetest

## Task

$ARGUMENTS

## Din rolle

Du lager testcasene testansvarlig og de interne testerne kan følge i løsningen uten å kjenne den fra før. Det er fase 3 i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326), og siden er en underside til testplanen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)).

Fra strategien:

- **Mål:** bekrefte at leveransen virker for brukeren, i arbeidsprosessen og sammen med resten av FS, faglig sett, og teste det en agent ikke kan teste eller vurdere.
- **Hva testes:** fire deler (se *Fase 3* i `akseptansetest/README.md`):
  1. **Det fase 2 ikke klarte:** testcasene fra den agentiske testen som ble «Ikke testet».
  2. **Flyter og avhengigheter:** oppgaver i arbeidsprosessen, i den rekkefølgen brukerne jobber, og avhengighetene til andre moduler og team. Regresjon av tidligere leverte flyter når leveransen endrer noe andre bygger på.
  3. **Opplevelse og helhet:** om løsningen er forståelig og brukbar i arbeidsprosessen, om tekstene og begrepene stemmer med fagspråket, og universell utforming.
  4. **Det med høyest risiko:** det testansvarlig velger etter en risikovurdering, også det fase 2 har bestått.
- **Hvor grundig:** feilsituasjoner, grenseverdier og obligatoriske felt fase 2 har bestått, testes ikke på nytt, utenom i del 1 og 4. Tilgang er sjekket i fase 1 (`fs-verify`, i planen).
- **Rekkefølge:** rekkefølgen i arbeidsprosessen, ikke rekkefølgen i feature-fila.
- **Testcasen inneholder:** i del 2 én flyt som går gjennom flere scenarioer, med hensikt, testdata og forventet resultat, og med avhengighetene som sjekkes underveis. Hvert scenario i flyten får eget resultat. I del 1, 3 og 4 én testcase per ting som prøves, med grunnen til at den er med.

Og:

- **Kravene er fasit for hva som skjer, testplanen for hva som testes og for testdataene.** Eksemplene i Gherkin er eksempler. Testbrukerne og testdataene kommer fra testplanen.
- **Fase 2 er gjort.** Den agentiske funksjonstesten er ferdig, og rapporten er gjennomgått av testansvarlig, før denne testen starter. Les rapporten: den sier hva som er dekket, og funnene som ikke er rettet, kan påvirke flytene.
- **Endre aldri kravene eller taggene.** Er et scenario ikke testbart som det står (uklart, mangler forventet resultat, motsier et annet krav), noter det, og foreslå `fs-krav`. `@openquestion` stopper ikke testen (*Åpne spørsmål* i `krav-fra-testplan.md`).
- **Akseptansetest er ikke fs-verify og ikke funksjonstest.** Verify-rapporten sier hva som finnes i koden, og den agentiske rapporten hva som virker som kravet sier. Dette er testen av at det henger sammen og virker for brukeren, og av det agenten ikke klarte.
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

Les så den agentiske testrapporten (`testrapport-agentisk-*.md` i `akseptansetest/<slug>/`, eller siden i Confluence). Inngangskriteriet til fase 3 er at fase 2 er ferdig: rapporten finnes, testansvarlig har gått gjennom den, og ingen funn med «Stopper» står åpne (*Inngangskriteriet til intern akseptansetest* i rapporten). Den agentiske rapporten har ikke noe utfall. Er ett av punktene ikke oppfylt, si hvilket, og spør om du skal fortsette.

Er testbrukere eller testdata `[Fylles ut …]` i testplanen, si det før du begynner. Testcasene får da `[Fylles ut: …]` på de samme stedene.

Sjekk at testdataene finnes i testmiljøet før testcasene skrives (R15 i `testcase-regler.md`): verdiene i nedtrekkslistene (regelverkssamling, poenglikhetsregel, kodeverk) og objektene i testplanen, også tilstanden de skal ha. Finnes en verdi ikke, bruk verdien som finnes, og si det i oppsummeringen. Kan det ikke sjekkes, merk verdien `[Sjekk testdata]`.

**Kjent mangel.** Kjøres skillen på nytt, eller er det kort tid til testen, sjekk sakene i testcasene merket «Kjent mangel (<sak>)» (R16 i `testcase-regler.md`): Jira-status, eller endringsloggen i kodeklonen. Er saken levert, fjernes merket, og regelen foreslås til `fs-verify`.

## 2. Del 1, 3 og 4: det fase 2 ikke klarte, opplevelsen og risikoen

**Del 1: det fase 2 ikke klarte.** Les `resultat.md` fra den siste kjøringen av den agentiske testen i `akseptansetest/<slug>/kjoring-*/` (og «Kjøringens testdata»), og list testcasene med foreslått status «Ikke testet», med grunnen fra «Faktisk resultat». Hver av dem blir en testcase her, med de samme stegene som i testen i `cdp-tester/`, skrevet om etter malen (testbrukerne fra testplanen i stedet for nøklene). Er grunnen en feil i løsningen (ikke data eller et steg agenten ikke fikk til), står den som funn i den agentiske rapporten, og testcasen tas bare med når testansvarlig vil. Mangler data testene ikke kan lage, står det i «Testdata» som `[Fylles ut: …]`.

**Del 3: opplevelse og helhet.** Foreslå testcaser for det bare et menneske kan vurdere, per skjerm eller oppgave i leveransen:

- **Forståelig og brukbar:** finner testeren fram uten hjelp, er rekkefølgen i skjemaet den samme som i arbeidsprosessen, og er det klart hva som er lagret.
- **Tekster og begreper:** stemmer ordene i skjermen med fagspråket og med kravet (avvikene fra *Lese koden* og `[Sjekk begrep]` i testene i fase 2 er et godt utgangspunkt), og er hjelpetekstene og feilmeldingene forståelige.
- **Universell utforming:** tastaturnavigasjon, fokus, lesbarhet og kontrast, og at feltene har ledetekst.

Forventet resultat er det testeren skal vurdere, og testeren skriver vurderingen i «Faktisk resultat».

**Del 4: høyest risiko.** Foreslå kandidater, og la testansvarlig velge (`AskUserQuestion`, flere valg): funn fra fase 2 som er rettet, scenarioer som er `usikker` i verify-rapporten, regler i koden uten scenario, krav med mange åpne spørsmål, kjente begrensninger i testplanen, og det som er mest kritisk for brukerne. For hver valgt: én testcase, med grunnen under. Velger testansvarlig ingen, står det i oppsummeringen.

## 3. Vurder hvert krav mot flytene

Teamet og testansvarlig avgjør hva som testes, og du forbereder vurderingen. For hvert krav i «Omfang» (bare krav som er `@implemented`, eller de leverte delene i et krav som er endret eller delvis levert):

1. **Inngår kravet i en flyt?** Finn flytene som går gjennom kravet etter *Finn flytene* i `krav-fra-testplan.md` (`grep -rln "@depends-on-<Feature-ID>" krav/_Flyter/`).
2. **Ja:** skal flyten testes, hele eller deler av den (*Hele eller deler av flyten* i `krav-fra-testplan.md`)? Testplanen har svaret når den har en «Flyter»-del. Er det uklart, spør (`AskUserQuestion`).
3. **Nei:** vurder om kravet hører til en flyt, etter *Hva er en flyt?* i `krav/README.md`: går løpet over minst to sub-domener eller domener, har det en overlevering (en tilstand én aktør lager og en annen bruker), og svarer det på et spørsmål noen stiller («hva skjer fra … til …?»)?
   - **Oppfyller kandidaten alle tre:** foreslå en ny flyt, eller å koble kravet til en eksisterende flyt. Ny flyt og ny `@depends-on-` skrives med `fs-krav` (flyter), ikke her. Spør (`AskUserQuestion`): «Test kravet som en oppgave uten flyt nå (anbefalt)» eller «Vent på flyten». Ved «Vent på flyten» står kravet i «Ikke med i denne testen» med «Venter på flyt».
   - **Ellers:** kravet testes som en **oppgave uten flyt** (se malen): én testcase for en oppgave i arbeidsprosessen innenfor kravet, med hensikt, testdata og forventet resultat, scenarioene i den rekkefølgen brukeren jobber, og eget resultat per scenario. Den har ingen overlevering. Feilsituasjoner, grenseverdier og obligatoriske felt tas heller ikke med her (fase 2).
4. **Regresjon.** Endrer leveransen noe andre krav bygger på? Finn kravene og flytene som bygger på det som er endret (`grep -rn "@depends-on-<Feature-ID>" krav/`, og ankrene, se *Anker* i `krav/README.md`). Er en slik flyt `@implemented` fra før, og går den gjennom delen som er endret, foreslå å teste den på nytt, med de samme scenarioene som sist. Spør teamet.

Vis oversikten (krav → flyt eller oppgave uten flyt → testes/ikke testes, og regresjonsflytene) før du skriver, med hvor mange krav som ikke er i noen flyt.

## 4. Finn scenarioene i flytene

1. For hver flyt som testes: fasene som er med, i rekkefølgen i flyten, og scenarioene i hver fase. For en oppgave uten flyt: hovedflyten i kravet, i den rekkefølgen brukeren jobber. Har en flyt fått ny status siden testplanen ble laget, gjelder statusen i fila.
2. **Bare det som inngår i flytene.** Fra kravene fasene bygger på: hovedflyten i dem, altså scenarioene som lager tilstanden i `Gitt` i flytens scenarioer, og scenarioene brukeren går gjennom i fasen. Feilsituasjoner, grenseverdier og obligatoriske felt tas ikke med (fase 2).
3. Gating-settet gjelder fortsatt (`krav-fra-testplan.md`): ingen `@draft`, `@deprecated` eller `@demo`. Et scenario med `@openquestion` (uten `@draft`) blir testcase som det står, med spørsmålet under tabellen.
4. Les den nyeste verify-rapporten og den agentiske rapporten. Et scenario som er `ikke funnet` eller `usikker` i verify, eller har et åpent funn i fase 2, spør du teamet om før du tar det med.
5. **Svakheter i kravet.** Sammenlign hvert scenario med lista over obligatoriske felt (steg 5). Et scenario som lagrer uten alle de obligatoriske feltene, eller en feilsituasjon som ikke sier at resten er fylt ut, står i oppsummeringen under «Til fs-krav», med `fil:linje`. Stegene i testcasen fylles ut riktig (R5, R9), men svakheten rettes i kravet, ikke bare i testen.

## 5. Finn ordene fra skjermen

For hvert krav som er med, les:

- `<feature>.design.md` ved siden av kravet: tekstene, feltene og feilmeldingene
- skissene i `spec/krav-input/**/sketches/` i oppgaven
- kodeklonene (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren): menyene, rutene, knappene, feltene, hvilke felt som er obligatoriske, og forhåndsutfylte verdier. Spør om stien til klonene hvis de mangler (som i *Kodeklonene* i `fs-verify`).
- **lista over obligatoriske felt**, laget eksplisitt per skjema, fra koden (for opptak: `missingFields` i `src/common/messages/nb/opptak.json` i fs-admin), med standardverdiene (R5). Den brukes i steg 4 (svakheter i kravet) og i sjekk 6 i `testcase-regler.md`.
- stegene og ordene i den agentiske testen (`cdp-tester/`, og `kjoring-*/resultat.md`) når den finnes: de er sjekket mot skjermen.

Uten kode merkes stegene der ordene er usikre, `[Sjekk begrep]`.

## 6. Sjekk hva som kan testes i miljøet

| Klasse | Når | I testcasene |
|---|---|---|
| Testbar | Funksjonen finnes i miljøet, og resultatet kan ses | Testcase |
| Testbar delvis | Verdien kan settes og lagres, men virkningen finnes ikke i miljøet ennå | Testcase for det som kan testes, og en rad i «Ikke testbart nå» for resten |
| Ikke testbar nå | Funksjonen ligger bak et flagg som er av, testdataene finnes ikke, eller resultatet kan ikke ses i miljøet | «Ikke testbart nå», med grunn og når det kan testes |

Er du usikker, spør teamet (`AskUserQuestion`).

## 7. Avhengighetskart

Testleder vurderer om leveransen trenger et avhengighetskart. Har testplanen et, bruk det. Ellers spør (`AskUserQuestion`): «Trenger leveransen et avhengighetskart?» Svarer teamet ja, hjelper du med å liste avhengighetene i «Avhengigheter» i testen, fra kravene (`@depends-on-`, `@ref-`), `utforing.md` (overleveringen) og teamet:

- andre moduler i FS
- integrasjoner
- batchjobber
- rapporter og eksport
- andre teams leveranser

Avhengigheter er det leveransen bygger på eller påvirker utenfor brukerens flyt. For hver: hva den er, hvordan den sjekkes, og om den sjekkes underveis i en flyt (da står den som et steg i flyten, og i kolonnen «Avhengighet» i tabellen) eller testes for seg (egen testcase, «Avhengigheter som testes for seg»). Gjett ikke: det teamet ikke vet, står som `[Fylles ut: …]`.

## 8. Skriv testcasene

Følg `testcase-regler.md` for hver testcase, og malen for formen:

- **Rekkefølgen på siden:** del 2 (flytene og oppgavene uten flyt, så regresjonen og avhengighetene som testes for seg), del 1 (det fase 2 ikke klarte), del 4 (høyest risiko) og del 3 (opplevelse og helhet), så testerne går gjennom arbeidsprosessen først, og vurderer helheten til slutt.
- **Én testcase per flyt** (eller per del av flyten som testes, når hele flyten blir for lang: da bruker den neste testcasen dataene fra den første), og én per oppgave uten flyt. Rekkefølgen er arbeidsprosessen, og med flere flyter den rekkefølgen brukerne møter dem. Med scope: oppgavene i rekkefølgen i scope-tabellen bare der det ikke strider mot arbeidsprosessen.
- «Hensikt» og «Testdata» over tabellen, og «Avhengigheter som sjekkes» når flyten har noen.
- **Hvert scenario i flyten er en rad** (en del), med scenariotittelen fra kravet eller flyten, og eget «Faktisk resultat» og «Status». Ved en scenariomal: én rad per eksempelrad som brukes i flyten.
- Stegene løper gjennom hele testcasen, bruker testbrukerne og testdataene fra testplanen, og ordene fra skjermen. Tilstanden fra en tidligere fase lages gjennom løsningen i fasen før, ikke settes direkte (R10: «Bruk søknaden fra 1.2»).
- «Forventet resultat» er det `Så` sier, sett der den neste aktøren jobber: at tilstanden er brukt, ikke bare lagret.
- **Regresjonsflyter** står i en egen del etter flytene i leveransen, med de samme scenarioene som sist og en kort «Hvorfor regresjon».
- «Faktisk resultat» og «Status» står tomme.
- Sporingen (testcase og del → Feature-ID, regel og scenario) står i metadataene.
- Ingen testcaser for feltvalidering eller feilmeldinger. Mangler et viktig tilfelle i kravet, legges det inn med `fs-krav`.

## 9. Kvalitetssikre og vis fram

1. Gå gjennom sjekklista i `testcase-regler.md`, og rett det du kan selv. Sjekk 6 gjøres med lista over obligatoriske felt fra steg 5 ved siden av. Det som krever teamet, står igjen som `[Fylles ut …]`, `[Sjekk begrep]` eller `[Sjekk testdata]`.
2. Vis oppsummeringen: antall testcaser per del (det fase 2 ikke klarte, flyter og oppgaver uten flyt, opplevelse og helhet, høyest risiko) og deler (scenarioer), regresjonsflytene, beregnet tid (2–4 minutter per del), hvor mange krav som ikke er i noen flyt, og hvordan de testes (oppgave uten flyt, eller venter på flyt, med forslaget om ny flyt), avhengighetene, det teamet må fylle ut, testdata som ikke fantes i miljøet, og «Til fs-krav»: svakhetene i kravene, med `fil:linje`. Er testen lengre enn 2 timer (tidsrammen i rutinen), foreslå å dele den i to økter.
3. Spør om siden skal opprettes i Confluence, som underside til testplanen (`confluence.md`, *Før du skriver*). Finnes siden fra før, og testerne har begynt, følg *Oppdatere en side som finnes*: det som er fylt ut, skrives aldri over.
4. Oppdater raden «3. Intern akseptansetest» i «Status i flyten» («Klar til test»), og forutsetningen om at testansvarlig har gått gjennom testcasene («Laget, venter på gjennomgang av testansvarlig») i testplanen.
5. Skriv lenken i metadataene, og foreslå teksten til Slack-tråden.

Gjennomføringen: testansvarlig følger testcasene, og fører resultat og funn (med funntype og «Fase funnet») i testsiden. Sluttrapporten lages med `fs-testrapport` (intern), og beslutningen tas av testansvarlig.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene eller testplanen (utenom raden i «Status i flyten» og forutsetningen om gjennomgang).
- Lager ikke testcaser for enkeltfunksjoner, feltvalidering, feilsituasjoner eller grenseverdier som fase 2 har bestått (`fs-testcaser-cdp`), utenom det testansvarlig velger i del 4, og ikke automatiske tester (det er `lage-steps`).
- Skriver ikke nye flyter (`fs-krav`), men foreslår dem når kravet oppfyller *Hva er en flyt?*.
- Fyller ikke ut resultater, og oppsummerer ikke testen (det er `fs-testrapport`).
- Kjører aldri git add/commit/push.
