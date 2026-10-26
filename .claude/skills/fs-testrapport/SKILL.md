---
name: fs-testrapport
description: Lager testrapporten etter en fase i testflyten fra teststrategien (forslag) «Teststrategi for FS – fra krav til akseptanse» i Confluence (STUDIEADM). Fire nivåer. Verifisering (fase 1) bygger på rapporten fra fs-verify, også fremdriften og overleveringene i flytene i `krav/_Flyter` som står i testplanen, og sier om leveransen er klar for agentisk funksjonstest. Agentisk (fase 2) bygger på `resultat.md` fra kjøringen (`akseptansetest/<slug>/kjoring-<dato>/`) med testcaser, teknikk, resultat, bevis og funn (også «Kravet dekker ikke»), og sier om inngangskriteriet til intern akseptansetest er oppfylt: ingen åpne «Stopper»-funn, og testansvarlig har gått gjennom rapporten. Intern (fase 3) og ekstern (fase 4) bygger på testsiden i Confluence med resultatene testerne har fylt ut, og teller bestått, ikke bestått og ikke testet per krav og regel (flyt for intern), sorterer funnene etter alvorlighetsgrad og type (i fase 4: avvik fra krav og endringsforslag), og foreslår et utfall (godkjent, godkjent med forbehold eller ikke godkjent). Testansvarlig, eller deltakerne i den eksterne testen, skriver beslutningen. Skillen fyller den aldri ut, og agenten kan aldri ta beslutningen. Leser kravene fra «Omfang» i testplanen. Skriver `akseptansetest/<slug>/testrapport-<nivå>-<dato>.md`, oppretter undersiden «Testrapport – <nivå> – <leveranse>» under testplanen bare når brukeren sier ja, og oppdaterer «Status i flyten» og «Sporbarhet per krav» i testplanen. Retagger aldri. Trigges av "lag testrapport", "testrapport etter verifiseringen", "agentisk testrapport", "rapport fra agentisk funksjonstest", "oppsummer akseptansetesten", "testrapport intern", "testrapport ekstern", "sluttrapport", "er leveransen klar for agentisk test", "er leveransen klar for intern akseptansetest", "fs-testrapport".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testrapport

## Task

$ARGUMENTS

## Din rolle

Du oppsummerer et steg i testflyten, så testansvarlig kan beslutte, og så neste steg vet hva det bygger på. Rapporten lages etter hver fase i flyten i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326): verifisering (fase 1), agentisk funksjonstest (fase 2), intern akseptansetest (fase 3) og ekstern akseptansetest (fase 4). Den er en underside til testplanen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)).

- **Du foreslår, testansvarlig beslutter.** Forslaget til utfall følger `alvorlighetsgrad.md`. Feltene i «Beslutning», «Kontrollert av», «Gjennomgått av testansvarlig» og «Bekreftet av deltakerne» fylles aldri ut av deg. Agenten kan ikke godkjenne en leveranse, og den agentiske rapporten har ingen beslutning, bare om inngangskriteriet til intern test er oppfylt. Stikkprøvene av beståtte testcaser er testansvarliges, etter en risikovurdering. Du velger dem ikke, og setter ikke et fast antall.
- **`@openquestion` stopper ikke testen**, men står i rapporten (*Åpne spørsmål* i `krav-fra-testplan.md`).
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
2. **Nivået:** står det i prompten («verifisering», «agentisk», «intern», «ekstern»), bruk det. Ellers les «Status i flyten» i testplanen, og foreslå den første fasen som har en side eller en kjøring, men ikke en testrapport. Spør (`AskUserQuestion`) med forslaget først.

## 2. Les grunnlaget

**Verifisering:**

- Den nyeste verify-rapporten for leveransen: `akseptansetest/<slug>/verify-*.md` (testplan for et scope), eller `spec/verify-*.md` i oppgaven. Har undersiden «Verifisering – …» en nyere dato, les den med `getConfluencePage`. Finnes flere rapporter for ulike oppgaver i scopet, ta den nyeste for hver oppgave, og si hvilke du har brukt.
- Kravene i «Omfang» og «Venter på verifisering» i testplanen, for å se om alle er verifisert. Krav som ikke er med i noen rapport, står under «Det som mangler» med «ikke verifisert».
- `Grep` etter `@openquestion` i kravene i «Omfang», og tell bare dem på scenarioer og regler i testen (`@draft @openquestion`-deler er ikke med). De står i «Åpne spørsmål som står igjen» og i oppfølgingen, men stopper ikke testen: delen er klar til implementasjon, og testes som den står (*Åpne spørsmål* i `krav-fra-testplan.md`).
- Flytene i «Flyter» i testplanen: `## Fremdrift for flyter` og flytradene (`@FLY-…`) i `## Scenarioer` i verify-rapporten. En flyt som er `@implemented`, har ingen rader der, og overleveringene i den regnes som funnet. Har rapporten ingen rader for en annen flyt i testplanen, står overleveringene under «Det som mangler» med «ikke verifisert».

**Agentisk:**

- Den nyeste kjøringen: `akseptansetest/<slug>/kjoring-<YYYY-MM-DD-HHMM>/resultat.md` (flere kjøringer: spør hvilken, eller ta den nyeste og si det). Bevisene ligger i samme mappe (skjermbilder er ikke i git, og resultatet viser til dem som «lokalt, ikke i git»), og er primærbevis sammen med tekst og DOM i `resultat.md`.
- `testcaser-cdp` (testcasene fra `fs-testcaser-cdp`, i `cdp-tester/` og i testplanen), for å koble hver testcase til kravet, regelen og teknikken (grenseverdi, ekvivalensklasse, beslutningstabell, tilstandsovergang).
- «Regler uten scenario» i testplanen og verify-rapporten: er hver regel testet?
- `@openquestion` i kravene i «Omfang», som under verifisering.
- Resultatet fra agenten er et forslag. Testansvarlig har ikke nødvendigvis gått gjennom det ennå: «Gjennomgått av testansvarlig» står `[Fylles ut av testansvarlig]`, og er et vilkår for at inngangskriteriet er oppfylt.

**Intern og ekstern:**

- Testsiden («Intern akseptansetest – …» eller «Ekstern akseptansetest – …») med `getConfluencePage` (`contentFormat: "markdown"`). Den er kilden, ikke `testcaser-*.md` i repoet.
- `testcaser-intern.md` eller `testcaser-ekstern.md`, for å koble hvert testcasenummer til kravet og regelen (metadataene og sporingen i fila).
- For intern: den agentiske rapporten, for å se om funn derfra er rettet, og om funn i flytene burde vært fanget i fase 2.
- For ekstern: testrapporten fra den interne testen, for å se om funn er rettet eller kommer igjen. De eksterne partene eier testcasene sine, så koblingen til kravene kan mangle: da står resultatene per testcase.

## 3. Regn ut og sorter

**Verifisering:** tallene fra `## Scenarioer` i verify-rapporten. «Scenarioer» i oppsummeringen teller bare kravene. Radene for flytene (`@FLY-…`) telles i «Overleveringer i flytene», der bare overleveringene testplanen tar med, teller. «Klar for intern akseptansetest» er «Ja» når alle scenarioene i gating-settet er `funnet`, og alle kravene i «Omfang» i testplanen er `@implemented`, eller delvis levert med alle de leverte delene `funnet`. Ellers «Nei», med det som mangler. Et krav som er delvis levert, gir «Ja, med forbehold»: de leverte delene kan testes, og resten står under «Det som mangler». Flytene teller bare for overleveringene testplanen tar med (*Hele eller deler av flyten* i `krav-fra-testplan.md`), ikke for faser som ikke er levert. Er alt annet klart, men en av disse overleveringene ikke `funnet`, er svaret «Ja, med forbehold», med overleveringene: kravene kan testes, men overleveringen testes ikke før koden er rettet. At en annen person har kontrollert rapporten, er et kriterium i strategien, men står som `[Fylles ut av teamet]`.

**Agentisk:**

1. Tell testcasene i `resultat.md`: `Bestått`, `Ikke bestått` og `Ikke testet` (med begrunnelsen), og tomt eller uklart som «ikke fylt ut». Agentens status er et forslag, og står som «foreslått».
2. Grupper per krav og regel, og per teknikk. Skill testcaser som kommer fra scenarioene i kravet fra dem agenten har utledet (regler uten scenario, negativ testing, obligatoriske felt).
3. List funnene etter alvorlighetsgrad. Funntypen er **Feil** (løsningen virker ikke som kravet sier) eller **Kravet dekker ikke** (agenten utledet et tilfelle kravet ikke sier noe om, og løsningen oppfører seg uventet): da avklares det i kravet, så foreslå `fs-krav` med spørsmålet, ikke bare en rettelse. Hvert funn har «Fase funnet»: 2.
4. **Inngangskriteriet til intern akseptansetest** er oppfylt når: alle testcasene er kjørt (ingen «ikke fylt ut», og «ikke testet» har begrunnelse), ingen funn med «Stopper» står åpne, og testansvarlig har gått gjennom rapporten. Du kan si om de to første er oppfylt. Det siste fyller testansvarlig ut. Foreslå ikke utfall (godkjent, godkjent med forbehold, ikke godkjent): den agentiske rapporten har ingen beslutning.
5. Regn ut hvor mange regler uten scenario som er testet, og list de som ikke er det.

**Intern og ekstern:**

1. Tell «Status» per testcase: `Bestått`, `Ikke bestått`, `Ikke testet`, og tomt eller uklart som «ikke fylt ut». En ekstern testcase har én «Status» per scenario. Tell scenarioene.
2. Grupper per flyt (intern: flyttestcasene, med én rad per scenario i flyten) eller per testcase (ekstern). Er det også testcaser per krav (regresjon, avhengigheter), grupper dem per oppgave, krav og regel.
3. List funnene etter alvorlighetsgrad. Et funn uten alvorlighetsgrad står øverst med «Mangler alvorlighetsgrad». En testcase med «Ikke bestått» uten et funn, står i oppsummeringen til brukeren.
4. Sorter oppfølgingen av hvert funn. Funnet har typen **Feil** eller **Kravet dekker ikke**, og «Fase funnet» (3 eller 4). I fase 4 er typene i stedet **Avvik fra krav** (feil, teamet lager oppgave) og **Endringsforslag** (et krav vi ikke har, går til kravarbeidet med `fs-krav`). Oppfølgingen er:
   - **Feil i løsningen / avvik fra krav:** teamet lager oppgave (`Sak`).
   - **Kravet dekker ikke / endringsforslag:** kravet mangler noe eller sier noe annet enn testeren forventet. Foreslå `fs-krav`, med spørsmålet.
   - **Testcasen var feil:** manglende steg, feil begrep eller feil testbruker. Går til «Læring». Er feilen noe fase 2 burde fanget (feltvalidering, feilsituasjon), står det også under «Læring».
   - **Utenfor testen:** står under «Andre funn».
5. Foreslå utfall etter *Forslag til utfall* i `alvorlighetsgrad.md`. Er mer enn en tidel av testcasene «ikke fylt ut», foreslå ikke utfall: si at testen ikke ser ferdig ut.

## 4. Skriv rapporten

Fyll ut malen for nivået (`verifisering`, `agentisk`, `intern` eller `ekstern`), og skriv `akseptansetest/<slug>/testrapport-<nivå>-<YYYY-MM-DD>.md`. Skriv aldri over en tidligere testrapport: den er det du sammenligner med etter en ny runde.

## 5. Vis fram og publiser

1. Vis oppsummeringen i chat: tallene, forslaget til utfall med grunnen, funnene etter alvorlighetsgrad, og det som må fylles ut.
2. Spør om rapporten skal opprettes i Confluence, som underside til testplanen (`confluence.md`, *Før du skriver*). Finnes en testrapport for samme nivå fra før, er det en oppdatering, med ny dato i tittelen hvis testen er kjørt på nytt.
3. Oppdater raden for fasen i «Status i flyten» i testplanen og i `testplan.md`: «Klar» / «Ikke klar for agentisk funksjonstest» (verifisering), «Venter på gjennomgang» / «Klar for intern akseptansetest» (agentisk: den siste når inngangskriteriet er oppfylt, også at testansvarlig har gått gjennom), «Venter på beslutning» (intern), «Venter på bekreftelse» (ekstern). Når testansvarlig har skrevet beslutningen, og skillen kjøres på nytt, blir statusen utfallet. Fyll også ut «Sporbarhet per krav» i testplanen: kolonnen for fase 2 (testcase og resultat) fra den agentiske rapporten, og kolonnen for fase 3 (flyt) fra den interne.
4. Skriv lenken i metadataene (`- **Confluence**:`).
5. Si hva som er neste steg (seksjonen «Neste steg» i malen).

## Hva skillen ikke gjør

- Skriver ikke beslutningen, godkjenner ikke på vegne av agenten, og endrer ikke det testerne har fylt ut.
- Kjører ikke testene og velger ikke stikkprøvene (det er `fs-testcaser-cdp` og testansvarlig).
- Retagger ikke kravene, og endrer ikke kravene eller scope-fila.
- Oppretter ikke Jira-saker eller oppgaver for funnene. Den foreslår teksten.
- Kjører aldri git add/commit/push.
