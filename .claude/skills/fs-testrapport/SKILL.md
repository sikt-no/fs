---
name: fs-testrapport
description: Lager testrapporten etter et steg i testflyten fra teststrategien «Teststrategi for FS – fra krav til akseptanse» i Confluence (STUDIEADM). Tre nivåer. Verifisering (steg 3) bygger på rapporten fra fs-verify, også fremdriften og overleveringene i flytene i `krav/_Flyter` som står i testplanen, og sier om leveransen er klar for intern akseptansetest. Intern (steg 5) og ekstern (steg 7) bygger på testsiden i Confluence med resultatene testerne har fylt ut, og teller bestått, ikke bestått og ikke testet per krav og regel, sorterer funnene etter alvorlighetsgrad, og foreslår et utfall (godkjent, godkjent med forbehold eller ikke godkjent). Testansvarlig, eller deltakerne i den eksterne testen, skriver beslutningen. Skillen fyller den aldri ut. Leser kravene fra «Omfang» i testplanen. Skriver `akseptansetest/<slug>/testrapport-<nivå>-<dato>.md`, oppretter undersiden «Testrapport – <nivå> – <leveranse>» under testplanen bare når brukeren sier ja, og oppdaterer «Status i flyten» i testplanen. Retagger aldri. Trigges av "lag testrapport", "testrapport etter verifiseringen", "oppsummer akseptansetesten", "testrapport intern", "testrapport ekstern", "sluttrapport", "er leveransen klar for akseptansetest", "fs-testrapport".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testrapport

## Task

$ARGUMENTS

## Din rolle

Du oppsummerer et steg i testflyten, så testansvarlig kan beslutte, og så neste steg vet hva det bygger på. Rapporten er steg 3, 5 og 7 i flyten i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850), og en underside til testplanen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)).

- **Du foreslår, testansvarlig beslutter.** Forslaget til utfall følger `alvorlighetsgrad.md`. Feltene i «Beslutning», «Kontrollert av» og «Bekreftet av deltakerne» fylles aldri ut av deg.
- **Tell, ikke tolk.** Tallene regnes ut fra verify-rapporten eller fra «Status» på testsiden. Er en celle tom eller uklar («ok?», «delvis»), er den «ikke fylt ut», og står for seg i rapporten. Gjett aldri hva testeren mente.
- **Skriv aldri over det testerne har fylt ut.** Testsiden leses, den endres ikke.
- **Retagg aldri.** `@implemented` eies av `fs-verify`. Er et krav uklart, foreslå `fs-krav`. Passer et krav ikke i scopet, foreslå `fs-scope`.
- **Publiser aldri uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: tell radene to ganger før du skriver tallene.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`references/mal-rapport.md`](references/mal-rapport.md): malen, med variantene per nivå.
2. [`.claude/references/akseptansetest/alvorlighetsgrad.md`](../../references/akseptansetest/alvorlighetsgrad.md): alvorlighetsgradene, beslutningen og forslaget til utfall.
3. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): kravene i testplanen.
4. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md): finn testplanen, les testsiden, og publiser.

## 1. Finn testplanen og nivået

1. **Testplanen:** etter *Finn testplanen* i `confluence.md`.
2. **Nivået:** står det i prompten («verifisering», «intern», «ekstern»), bruk det. Ellers les «Status i flyten» i testplanen, og foreslå det første steget som har en side, men ikke en testrapport. Spør (`AskUserQuestion`) med forslaget først.

## 2. Les grunnlaget

**Verifisering:**

- Den nyeste verify-rapporten for leveransen: `akseptansetest/<slug>/verify-*.md` (testplan for et scope), eller `spec/verify-*.md` i oppgaven. Har undersiden «Verifisering – …» en nyere dato, les den med `getConfluencePage`. Finnes flere rapporter for ulike oppgaver i scopet, ta den nyeste for hver oppgave, og si hvilke du har brukt.
- Kravene i «Omfang» og «Venter på verifisering» i testplanen, for å se om alle er verifisert. Krav som ikke er med i noen rapport, står under «Det som mangler» med «ikke verifisert».
- `Grep` etter `@openquestion` i kravene. Et åpent spørsmål som står igjen, gir «Ikke klar».
- Flytene i «Flyter» i testplanen: `## Fremdrift for flyter` og flytradene (`@FLY-…`) i `## Scenarioer` i verify-rapporten. En flyt som er `@implemented`, har ingen rader der, og overleveringene i den regnes som funnet. Har rapporten ingen rader for en annen flyt i testplanen, står overleveringene under «Det som mangler» med «ikke verifisert».

**Intern og ekstern:**

- Testsiden («Intern akseptansetest – …» eller «Ekstern akseptansetest – …») med `getConfluencePage` (`contentFormat: "markdown"`). Den er kilden, ikke `testcaser-*.md` i repoet.
- `testcaser-intern.md` eller `testcaser-ekstern.md`, for å koble hvert testcasenummer til kravet og regelen (metadataene og sporingen i fila).
- For ekstern: testrapporten fra den interne testen, for å se om funn er rettet eller kommer igjen.

## 3. Regn ut og sorter

**Verifisering:** tallene fra `## Scenarioer` i verify-rapporten. «Scenarioer» i oppsummeringen teller bare kravene. Radene for flytene (`@FLY-…`) telles i «Overleveringer i flytene», der bare overleveringene testplanen tar med, teller. «Klar for intern akseptansetest» er «Ja» når alle scenarioene i gating-settet er `funnet`, alle kravene i testplanen er `@implemented`, og ingen `@openquestion` står igjen. Ellers «Nei», med det som mangler. Flytene teller bare for overleveringene testplanen tar med (*Hele eller deler av flyten* i `krav-fra-testplan.md`), ikke for faser som ikke er levert. Er alt annet klart, men en av disse overleveringene ikke `funnet`, er svaret «Ja, med forbehold», med overleveringene: kravene kan testes, men overleveringen testes ikke før koden er rettet. At en annen person har kontrollert rapporten, er et kriterium i strategien, men står som `[Fylles ut av teamet]`.

**Intern og ekstern:**

1. Tell «Status» per testcase: `Bestått`, `Ikke bestått`, `Ikke testet`, og tomt eller uklart som «ikke fylt ut». En ekstern testcase har én «Status» per scenario. Tell scenarioene.
2. Grupper per oppgave, krav og regel (intern) eller per testcase (ekstern). En flyt er en egen rad i den interne testen, med én rad per fase, etter kravene.
3. List funnene etter alvorlighetsgrad. Et funn uten alvorlighetsgrad står øverst med «Mangler alvorlighetsgrad». En testcase med «Ikke bestått» uten et funn, står i oppsummeringen til brukeren.
4. Sorter oppfølgingen av hvert funn:
   - **Feil i løsningen:** teamet lager oppgave (`Sak`).
   - **Uklart krav:** kravet mangler noe eller sier noe annet enn testeren forventet. Foreslå `fs-krav`, med spørsmålet.
   - **Testcasen var feil:** manglende steg, feil begrep eller feil testbruker. Går til «Læring».
   - **Utenfor testen:** står under «Andre funn».
5. Foreslå utfall etter *Forslag til utfall* i `alvorlighetsgrad.md`. Er mer enn en tidel av testcasene «ikke fylt ut», foreslå ikke utfall: si at testen ikke ser ferdig ut.

## 4. Skriv rapporten

Fyll ut malen for nivået, og skriv `akseptansetest/<slug>/testrapport-<nivå>-<YYYY-MM-DD>.md`. Skriv aldri over en tidligere testrapport: den er det du sammenligner med etter en ny runde.

## 5. Vis fram og publiser

1. Vis oppsummeringen i chat: tallene, forslaget til utfall med grunnen, funnene etter alvorlighetsgrad, og det som må fylles ut.
2. Spør om rapporten skal opprettes i Confluence, som underside til testplanen (`confluence.md`, *Før du skriver*). Finnes en testrapport for samme nivå fra før, er det en oppdatering, med ny dato i tittelen hvis testen er kjørt på nytt.
3. Oppdater raden for steget i «Status i flyten» i testplanen og i `testplan.md`: «Klar» / «Ikke klar for intern akseptansetest» (verifisering), «Venter på beslutning» (intern), «Venter på bekreftelse» (ekstern). Når testansvarlig har skrevet beslutningen, og skillen kjøres på nytt, blir statusen utfallet.
4. Skriv lenken i metadataene (`- **Confluence**:`).
5. Si hva som er neste steg (seksjonen «Neste steg» i malen).

## Hva skillen ikke gjør

- Skriver ikke beslutningen, og endrer ikke det testerne har fylt ut.
- Retagger ikke kravene, og endrer ikke kravene eller scope-fila.
- Oppretter ikke Jira-saker eller oppgaver for funnene. Den foreslår teksten.
- Kjører aldri git add/commit/push.
