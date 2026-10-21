---
name: fs-testcaser-ekstern
description: Lager testcasene for den eksterne akseptansetesten (erfarne brukere fra lærestedene, HK-dir og andre eksterne parter), etter teststrategien «Teststrategi for FS – fra krav til akseptanse» i Confluence (STUDIEADM). Bygger på testplanen (`akseptansetest/<slug>`) og testrapporten fra den interne testen, og leser kravene fra «Omfang» i testplanen (et scope, en oppgave, en mappe eller feature-filer). Bare hovedflyten: feilsituasjonene er testet internt. Hver testcase er en oppgave i arbeidsprosessen som går gjennom flere scenarioer i den rekkefølgen brukerne jobber, også på tvers av domener, med hensikt, testdata og forventet resultat, og hvert scenario får sin egen status. Ingen Feature-ID-er, scope-id-er, tagger eller tekniske ord på siden. Skriver `akseptansetest/<slug>/testcaser-ekstern.md`, og oppretter undersiden «Ekstern akseptansetest – <leveranse>» under testplanen bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testcaser for ekstern akseptansetest", "ekstern akseptansetest", "akseptansetest for HK-dir", "akseptansetest for lærestedene", "fs-testcaser-ekstern".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testcaser for ekstern akseptansetest

## Task

$ARGUMENTS

## Din rolle

Du setter scenarioene i kravene sammen til oppgaver i arbeidsprosessen, så eksterne brukere kan bekrefte at løsningen virker i praksis. Det er steg 6 i flyten i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850), og siden er en underside til testplanen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)).

- **Mål** (fra strategien): bekrefte at løsningen virker i praksis for dem som skal bruke den, så de kan si at den er akseptert.
- **Bare leveranser som er godkjent internt.** Den eksterne testen bygger på den interne.
- **Testerne kjenner fagfeltet, ikke løsningen og ikke kravene.** Siden bruker ordene fra arbeidsprosessen og skjermen, ikke fra kravene og koden.
- **Endre aldri kravene eller taggene.** Foreslå `fs-krav` når et krav er uklart.
- **Publiser aldri uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i kodeklonene.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`.claude/references/akseptansetest/testcase-regler.md`](../../references/akseptansetest/testcase-regler.md): reglene for testcasene. R11 sier hva som er annerledes i den eksterne testen.
2. [`references/mal-ekstern.md`](references/mal-ekstern.md): malen og nummereringen.
3. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): kravene i testplanen.
4. [`.claude/references/akseptansetest/alvorlighetsgrad.md`](../../references/akseptansetest/alvorlighetsgrad.md): tekstene om funn og alvorlighetsgrad.
5. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

## 1. Les testplanen og den interne testen

1. Finn testplanen etter *Finn testplanen* i `confluence.md`. Fra den trenger du kravene i «Omfang», kilden og scope-id-ene, oppgavene, testbrukerne, testdataene, testmiljøet og de eksterne testerne.
2. **Er leveransen godkjent internt?** Les den nyeste `testrapport-intern-*.md`, eller siden «Testrapport – intern akseptansetest – …». Er utfallet ikke fylt ut, eller er det «Ikke godkjent», si det, og spør om du skal fortsette. Ved «Godkjent med forbehold»: ta med de kjente manglene i «Dette kan du ikke gjøre i testen» når de berører testcasene.
3. Les `testcaser-intern.md`: stegene, ordene fra skjermen og testdataene kan gjenbrukes. Det er den beste kilden til stegene.
4. **Flere leveranser i samme runde.** Strategien foreslår å samle flere leveranser til én testrunde. Har testplanen flere kilder (flere scope, mapper eller filer), er de alle med. Skal testen ta med leveranser fra andre testplaner, spør om hvilke.

## 2. Velg scenarioene

1. Kravene i «Omfang» i testplanen, med gating-settet (`krav-fra-testplan.md`). Bare det som er godkjent i den interne testen.
2. **Hovedflyten:** scenarioene der brukeren får gjort det prosessen handler om. Ta ut feilsituasjoner, sperrer, feilmeldinger, obligatoriske felt og grenseverdier. De står i «Ikke med i denne testen» med «Testet i den interne akseptansetesten».
3. **Hvem testerne er:** spør (`AskUserQuestion`, `multiSelect`) hvilke deler som gjelder dem. Foreslå et utvalg ut fra rollene i kravene. Eksterne tester bare det de skal bruke: i et samordna opptak er det kravene for samordna opptak, ikke for lokale opptak.

## 3. Sett sammen oppgavene i arbeidsprosessen

1. **Finn rekkefølgen brukerne jobber i.** Bruk rekkefølgen oppgavene står i scope-tabellen, brukerhistoriene, og hvilke data et scenario lager som et annet bruker (opprette et opptak → registrere en søknad → behandle den). Går leveransen over flere domener, følger rekkefølgen arbeidsprosessen, ikke domenene.
2. **Del hovedflyten i oppgaver.** Én testcase er én oppgave med en hensikt testeren kjenner igjen fra jobben sin («Sett opp et opptak og åpne det for søknader»). Hver testcase går gjennom flere scenarioer, og hvert scenario er en del (`1a`, `1b`) med sin egen «Status».
3. **Vis forslaget før du skriver stegene:** oppgavene, delene, og hvilke scenarioer som er i hver. Spør om rekkefølgen og oppdelingen er riktig.

## 4. Skriv testcasene

- Følg `testcase-regler.md` og malen. Gjenbruk stegene fra `testcaser-intern.md`, men skriv dem som én sammenhengende oppgave: stegene løper gjennom hele testcasen.
- «Hva du gjør» med vanlige ord, ikke scenariotittelen fra kravet.
- **Hensikt** og **Testdata** over hver tabell.
- Ingen Feature-ID-er, scope-id-er, tagger, kodeverdier, GraphQL, Jira eller feature-flagg på siden. Sporingen står i metadataene.
- «Faktisk resultat» og «Status» står tomme.

## 5. Kvalitetssikre og vis fram

1. Gå gjennom sjekklista i `testcase-regler.md`, og sjekk at siden ikke har intern informasjon (`Grep` etter `@`, `scope-`, `feature`, `GraphQL`, `flagg` i delen under streken).
2. Vis oppsummeringen: antall testcaser og deler, beregnet tid, det som er utelatt og hvorfor, og det som må fylles ut. Er testen lengre enn én time, foreslå å dele den.
3. Spør om siden skal opprettes i Confluence, som underside til testplanen (`confluence.md`, *Før du skriver*).
4. Oppdater raden «6. Ekstern akseptansetest» i «Status i flyten» («Klar til test»).
5. Skriv lenken i metadataene. Foreslå teksten til invitasjonen til de eksterne testerne, med lenken og fristen. Skillen sender den ikke.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene eller testplanen (utenom raden i «Status i flyten»).
- Lager ikke testcaser for feilsituasjoner, med mindre brukeren ber om det.
- Fyller ikke ut resultater, og oppsummerer ikke testen (det er `fs-testrapport`).
- Kjører aldri git add/commit/push.
