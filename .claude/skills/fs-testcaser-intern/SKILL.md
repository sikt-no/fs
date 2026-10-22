---
name: fs-testcaser-intern
description: Lager testcasene for den interne akseptansetesten (domeneekspertene), etter teststrategien «Teststrategi for FS – fra krav til akseptanse» i Confluence (STUDIEADM). Bygger på testplanen (`akseptansetest/<slug>`), og leser kravene fra «Omfang» i den (et scope, en oppgave, en mappe eller feature-filer). Hvert scenario i gating-settet som er `@implemented`, blir én testcase, og en scenariomal én testcase per eksempel. Feilsituasjoner er med når de står i kravet. Overleveringene i flytene i `krav/_Flyter` som står i «Flyter» i testplanen, blir en egen del per flyt etter kravene, med én testcase per scenario. Rekkefølgen er den i feature-fila, med én overskrift per krav og én tabell per regel, og kolonnene Nr, Scenario, Steg, Forventet resultat, Faktisk resultat og Status. Stegene har testbrukeren fra testplanen, ordene fra skjermen (fra koden i fs-admin og min-kompetanse, `<feature>.design.md` eller skissene), alle verdiene, og en sjekk av at det er lagret. Skriver `akseptansetest/<slug>/testcaser-intern.md`, og oppretter undersiden «Intern akseptansetest – <leveranse>» under testplanen bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testcaser for intern akseptansetest", "intern akseptansetest", "testcaser for domeneekspertene", "testcaser fra testplanen", "fs-testcaser-intern".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testcaser for intern akseptansetest

## Task

$ARGUMENTS

## Din rolle

Du gjør kravene om til testcaser som testansvarlig kan følge i løsningen uten å kjenne den fra før. Det er steg 4 i flyten i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850), og siden er en underside til testplanen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)).

Fra strategien:

- **Mål:** bekrefte at kravene er løst riktig, faglig sett.
- **Hvilke scenarioer:** alle scenarioene i kravene som leveransen har gjort `@implemented`. Endres et levert krav, testes de nye og endrede scenarioene.
- **Hvor grundig:** hvert scenario blir én testcase og testes slik det står. En scenariomal gir én testcase per eksempel. Feilsituasjoner og grensetilfeller testes når de står som scenarioer i kravet.
- **Rekkefølge:** rekkefølgen i feature-fila.

I tillegg testes overleveringene i flytene i testplanen («Flyter»): at det ett krav lager, blir brukt av det neste. Testene for hvert krav setter opp tilstanden selv, så bare flyten fanger et brudd mellom kravene.

Og:

- **Kravene er fasit for hva som testes, testplanen for testdataene.** Eksemplene i Gherkin er eksempler. Testbrukerne og testdataene kommer fra testplanen.
- **Endre aldri kravene eller taggene.** Er et scenario ikke testbart som det står (uklart, mangler forventet resultat, motsier et annet krav), noter det, og foreslå `fs-krav`.
- **Akseptansetest er ikke fs-verify.** Verify-rapporten sier hva som finnes i koden. Den er et grunnlag for hva som kan testes, ikke et resultat.
- **Publiser aldri uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i kodeklonene.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`.claude/references/akseptansetest/testcase-regler.md`](../../references/akseptansetest/testcase-regler.md): reglene for testcasene (R1–R11) og sjekklista.
2. [`references/mal-intern.md`](references/mal-intern.md): malen og nummereringen.
3. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): kravene i testplanen, og gating-settet.
4. [`.claude/references/akseptansetest/alvorlighetsgrad.md`](../../references/akseptansetest/alvorlighetsgrad.md): tekstene om funn og alvorlighetsgrad.
5. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

## 1. Les testplanen

Finn testplanen etter *Finn testplanen* i `confluence.md`. Les `testplan.md`, og siden i Confluence når den finnes (den kan ha det teamet har fylt ut etter at fila ble laget: testbrukere, testdata, miljø). Fra testplanen trenger du:

- kravene i «Omfang» (med Feature-ID) og «Venter på verifisering», og kilden og scope-id-ene
- flytene i «Flyter»: om hele flyten eller deler av den testes, og fasene som er med
- de nummererte testbrukerne, med rolle og organisasjon
- testdataene, og testmiljøet (URL)
- «Ikke med i denne testen»

Er testbrukere eller testdata `[Fylles ut …]` i testplanen, si det før du begynner. Testcasene får da `[Fylles ut: …]` på de samme stedene.

## 2. Finn scenarioene

1. Kravene i «Omfang» i testplanen, slått opp på Feature-ID under `krav/` (*Kravene i de andre skillene* i `krav-fra-testplan.md`), i rekkefølgen i testplanen.
2. Gating-settet per krav. Bare krav som er `@implemented` (eller deler som er levert i et endret krav) blir testcaser. Et krav som fortsatt er `@in-progress`, står i «Ikke med i denne testen» med «Venter på verifisering», og du foreslår `fs-verify`.
3. Les den nyeste verify-rapporten for leveransen (se *Verifisering* i `fs-testrapport`). Et scenario som er `ikke funnet` eller `usikker` der, spør du teamet om før du tar det med.
4. **Flytene.** For hver flyt i «Flyter»: scenarioene i fasene som er med i testen (*Hele eller deler av flyten* i `krav-fra-testplan.md`), i rekkefølgen i flyten. Har en flyt fått ny status siden testplanen ble laget, gjelder statusen i fila. Les også kravene fasene bygger på, også dem som ikke er i «Omfang»: hovedflyten i dem er stegene som lager tilstanden i `Gitt` (*Kravene i de andre fasene*).

## 3. Finn ordene fra skjermen

For hvert krav, les:

- `<feature>.design.md` ved siden av kravet: tekstene, feltene og feilmeldingene
- skissene i `spec/krav-input/**/sketches/` i oppgaven
- kodeklonene (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren): menyene, rutene, knappene, feltene, hvilke felt som er obligatoriske, og feilmeldingene. Spør om stien til klonene hvis de mangler (som i *Kodeklonene* i `fs-verify`).

Uten kode merkes stegene der ordene er usikre, `[Sjekk begrep]`.

## 4. Sjekk hva som kan testes i miljøet

| Klasse | Når | I testcasene |
|---|---|---|
| Testbar | Funksjonen finnes i miljøet, og resultatet kan ses | Testcase |
| Testbar delvis | Verdien kan settes og lagres, men virkningen finnes ikke i miljøet ennå | Testcase for det som kan testes, og en rad i «Ikke testbart nå» for resten |
| Ikke testbar nå | Funksjonen ligger bak et flagg som er av, testdataene finnes ikke, eller resultatet kan ikke ses i miljøet | «Ikke testbart nå», med grunn og når det kan testes |

Er du usikker, spør teamet (`AskUserQuestion`).

## 5. Skriv testcasene

Følg `testcase-regler.md` for hver testcase, og malen for formen:

- Én overskrift per krav, og én tabell per regel, i rekkefølgen i feature-fila. Med scope: oppgavene i rekkefølgen i scope-tabellen.
- «Scenario» er scenariotittelen fra kravet. Ved en scenariomal, med verdiene fra eksempelraden.
- Stegene bruker testbrukerne og testdataene fra testplanen, og ordene fra skjermen.
- «Faktisk resultat» og «Status» står tomme.
- Sporingen (Nr → Feature-ID, regel og scenario) står i metadataene.
- **Flytene** kommer etter kravene, med én del per flyt og én tabell per fase. Én testcase per scenario. Stegene lager først tilstanden i `Gitt` med hovedflyten i kravet som lager den. Er det en testcase for det i en tidligere del, henvis til den (R10: «Bruk søknaden fra 2.3»). Ellers skriv stegene, med ordene fra skjermen. «Forventet resultat» er det `Så` sier, sett der den neste aktøren jobber: at tilstanden er brukt, ikke bare lagret.

## 6. Kvalitetssikre og vis fram

1. Gå gjennom sjekklista i `testcase-regler.md`, og rett det du kan selv. Det som krever teamet, står igjen som `[Fylles ut …]` eller `[Sjekk begrep]`.
2. Vis oppsummeringen: antall testcaser per krav og per flyt, beregnet tid (2–4 minutter per testcase), det som er utelatt og hvorfor, det teamet må fylle ut, og scenarioer som bør tilbake til `fs-krav`. Er testen lengre enn 2 timer (tidsrammen i rutinen), foreslå å dele den i to økter.
3. Spør om siden skal opprettes i Confluence, som underside til testplanen (`confluence.md`, *Før du skriver*). Finnes siden fra før, og testerne har begynt, følg *Oppdatere en side som finnes*: det som er fylt ut, skrives aldri over.
4. Oppdater raden «4. Intern akseptansetest» i «Status i flyten» («Klar til test»), og forutsetning 6 i testplanen («Laget, venter på gjennomgang av testansvarlig»).
5. Skriv lenken i metadataene, og foreslå teksten til Slack-tråden.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene eller testplanen (utenom raden i «Status i flyten» og forutsetning 6).
- Lager ikke regresjonstester, helhetsrunder, tester av universell utforming eller automatiske tester (det er `lage-steps`). Scenarioene i flytene er ikke en helhetsrunde: de står i kravene, og tester én overlevering hver.
- Fyller ikke ut resultater, og oppsummerer ikke testen (det er `fs-testrapport`).
- Kjører aldri git add/commit/push.
