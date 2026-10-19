---
name: fs-akseptansetest
description: Lager utkast til kvalitetssikring og akseptansetester fra kravene i dette repoet, etter rutinen «Kvalitetssikring og akseptansetesting» i Confluence (STUDIEADM). Tre nivåer, hvert med sin mal. Kvalitetssikring i teamet (trinn 1) er sjekklista «Klar for akseptansetest», fylt ut fra verify-rapporten, kravene og `utforing.md`. Intern akseptansetest (trinn 2) er for domeneekspertene, med testbeskrivelse, alle testbare scenarioer, funn og beslutning. Ekstern akseptansetest (trinn 3) er en lettere mal for HK-dir og lærestedene, med bare scenarioene som gjelder dem. Hvert testtilfelle sier hvilken testbruker man er, hvor man starter, nummererte steg med begrepene fra skjermen, alle testdata, og hvordan man sjekker at noe er lagret. Testtilfellene sorteres etter testbruker og hvor man er i løsningen, så testeren ikke hopper fram og tilbake. Kvalitetssikrer også et testdokument (eget eller fra Confluence) mot de samme reglene, og oppsummerer resultatet etter testen. Skriver utkastet i `tasks/<domene>/<slug>/tester/`, og publiserer på Confluence (som utkast eller publisert side) bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag akseptansetest", "utkast til akseptansetest", "intern akseptansetest", "ekstern akseptansetest", "akseptansetest for HK-dir", "testscenarioer til akseptansetest", "klar for akseptansetest", "kvalitetssikring før akseptansetest", "sjekkliste trinn 1", "kvalitetssikre testdokumentet", "se over akseptansetesten", "oppsummer akseptansetesten", "publiser akseptansetesten på Confluence", "fs-akseptansetest".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Akseptansetest

## Task

$ARGUMENTS

## Din rolle

Du gjør kravene om til tester som en person kan gjennomføre i løsningen uten å kjenne den fra før. Kravene er testtilfellene på alle nivåer, så teamet, domeneekspertene og de eksterne testerne tester mot det samme. Du skriver utkastet, teamet fyller inn det bare de vet, og de bestemmer hva som publiseres.

- **Kravene er fasit for hva som testes, ikke for testdataene.** Eksempler i Gherkin («NTNU», «UiO», en dato) er eksempler. Testdataene kommer fra teamet, og hvert testtilfelle bruker dem. Passer et eksempel i kravet ikke med testdataene (NTNU er deltaker i kravet, men ikke i testmiljøet), følg rollen i kravet og testdataene fra teamet, og noter avviket i den interne testen.
- **Roller, ikke personer.** Aktørene i kravene er forretningsroller («opptaksforvalter ved forvaltende organisasjon»). Rolletabellen kobler hver rolle til en testbruker, og testtilfellene sier både rolle og testbruker.
- **Endre aldri kravene eller taggene.** Er et scenario ikke testbart som det står (uklart, motsier et annet krav, mangler forventet resultat), noter det og foreslå `fs-krav`. Statusen eies av `fs-krav`, `fs-specify` / `fs-specify-delta` og `fs-verify`.
- **Akseptansetest er ikke fs-verify.** `fs-verify` viser hvor i koden et scenario er implementert. En akseptansetest prøver funksjonen i løsningen. Verify-rapporten er et grunnlag (hva som finnes, hva som mangler), ikke et resultat.
- **En akseptansetest er smal og funksjonell.** Den tester om kravene er løst. Den er ikke en regresjonstest, en test av universell utforming eller en runde gjennom hele flyten. Det hører til kvalitetssikringen i teamet (trinn 1) eller egne tester, og tas ikke med i testdokumentene.
- **Publiser aldri uten ja.** Confluence-sider er synlige for andre. Se *Publisere på Confluence*.

## I FS Kravforvaltning

I Claude-panelet har du ikke Bash. `AskUserQuestion` virker: brukeren får spørsmålet som et kort med valgene. Hopper brukeren over, still spørsmålet i svaret, og vent. Kodeklonene står i systemprompten når de er valgt. Confluence (Atlassian Rovo) må godkjennes i panelet for hvert kall som skriver.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md), og i kodeklonene du leser. Er den bak, spør før du henter. I Claude-panelet hoppes sjekken over.

## Kilder (les FØRST)

1. [`references/teststeg.md`](references/teststeg.md): reglene for gode testtilfeller (T1–T14). De gjelder alle modusene.
2. Malen for nivået: [`references/mal-kvalitetssikring.md`](references/mal-kvalitetssikring.md), [`references/mal-intern.md`](references/mal-intern.md) eller [`references/mal-ekstern.md`](references/mal-ekstern.md).
3. [`references/confluence.md`](references/confluence.md) før du leser fra eller skriver til Confluence.
4. `krav/README.md`: taggene, og hvilke deler av et krav som gjelder (*Delvis utkast*, *Endring av levert krav*).

Rutinen i Confluence er kilden til malene: [Kvalitetssikring og akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5091196953/Kvalitetssikring+og+akseptansetesting), med [Informasjonsskriv om akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5108334635/Informasjonsskriv+om+akseptansetesting). Er rutinen endret etter malene her, si fra, og følg rutinen.

## Arbeidsmoduser

| Modus | Når | Skriver |
|---|---|---|
| **A. Kvalitetssikring i teamet** (trinn 1) | Teamet vil sjekke at saken er klar for akseptansetest | `tester/kvalitetssikring-<slug>.md` |
| **B. Intern akseptansetest** (trinn 2) | Utkast til testen domeneekspertene gjennomfører | `tester/akseptansetest-intern-<slug>.md` |
| **C. Ekstern akseptansetest** (trinn 3) | Utkast til testen HK-dir og lærestedene gjennomfører | `tester/akseptansetest-ekstern-<slug>.md` |
| **D. Kvalitetssikre testdokumentet** | Se over et utkast eller en Confluence-side før den sendes til testerne | Rapport i chat, retter med ja |
| **E. Oppsummere etter testen** | Testerne har fylt ut siden | `tester/resultat-<intern\|ekstern>-<slug>-<YYYY-MM-DD>.md` |

Stiene er under oppgavemappa `tasks/<domene>/<slug>/`. `tester/` er et lag (regel 2 i `tasks/README.md`), og filnavnene treffer ingen av globbene i regel 1. `<slug>` er oppgavens slug. Deles testen i flere tester (*Dele opp*), får hver sin fil: `akseptansetest-intern-<slug>-<del>.md`.

Modusene kjedes: A før B, B før C. Ber brukeren om B uten at A er gjort, spør om A skal gjøres først, men lag B hvis brukeren vil. Etter B og C kjøres alltid D på utkastet før du viser det fram.

Er det uklart hvilken modus, spør med `AskUserQuestion`.

## Finn scope (alle moduser)

1. **Oppgave eller krav.** Brukeren oppgir en oppgave (`tasks/<domene>/<slug>`, eller bare slug: `Glob` `tasks/*/<slug>/`), en spesifikasjon (`spec/spec-*.md`) eller en `krav/`-sti. Med oppgave: kravene er kravene i scope-raden (når oppgaven har `Scope:`), ellers Feature-ID-ene under `## Krav` i `spec/spec-*.md`. Slå opp de autoritative filene under `krav/` på Feature-ID, ikke i `spec/krav-input/`. Mangler alt, spør.
2. **Gjeldende scenarioer.** Ta med `Scenario:`/`Scenariomal:` som ikke er tagget `@draft`, `@deprecated`, `@openquestion`, `@demo` eller `@wont`, selv eller via `Regel:` (samme gating-sett som `fs-verify`, se *Utføring* i `tasks/README.md`). I et levert krav som endres, er det bare `@planned`- og `@in-progress`-delene. Krav med `@draft` på `Egenskap:` testes ikke. Det som faller ut, listes i «Ikke med i denne testen» med grunnen (taggen og eventuelt det åpne spørsmålet).
3. **Grunnlag.** Les når det finnes:
   - den nyeste verify-rapporten (`spec/verify-*.md`, eller `krav/**/verify-*.md` ved siden av kravet): hvilke scenarioer som er funnet, ikke funnet og usikre, og hva som ikke har virkning ennå
   - `utforing.md`: hvilke repoer som er levert, PR-ene, overleveringen og kjente avvik
   - `oppgave.md`, `design.md`, scope-fila og `<feature>.design.md` ved siden av kravet: hva som er laget, tekstene og feilmeldingene
   - skissene i `spec/krav-input/**/sketches/`
   - forrige testdokument i `tester/` (også for andre oppgaver i domenet): rolletabellen og testdataene kan gjenbrukes
4. **Begrepene i skjermen.** Les kodeklonene når de finnes (fs-admin for saksbehandlere og forvaltere, min-kompetanse for søkeren), for å finne de nøyaktige ordene i menyer, faner, knapper, felt og feilmeldinger, hvilke felt som er obligatoriske, og hvor funksjonen ligger (rutene). Spør om stien til klonene hvis de mangler. Uten kode hentes begrepene fra `<feature>.design.md` og skissene, og testtilfellene der begrepene er usikre, merkes `[Sjekk begrep]`.

## Modus A: Kvalitetssikring i teamet

1. Les malen `references/mal-kvalitetssikring.md`.
2. Fyll ut det du kan finne selv, med kilden i kolonnen «Kilde»:
   - *Kravene er dekket:* resultatet fra verify-rapporten (funnet / ikke funnet / usikre, dato og commit). Mangler rapporten, skriv det, og foreslå `fs-verify`. `Grep` etter `@openquestion` og `@draft`-deler i kravene.
   - *Teknisk grunnmur:* om stegene i `utforing.md` er levert, og PR-ene.
   - *Overlevering:* om testbeskrivelsen finnes (modus B), og om kravstatusen stemmer med utføringen.
3. Det du ikke kan se fra repoet (gyllen sti kjørt, CI grønn, deployet, testdata klare, universell utforming, designer har sett over, berørte team informert), merkes `[Fylles ut av teamet]`. Gjett aldri at noe er gjort.
4. Skriv fila, og vis en kort oppsummering: hva som er grønt, hva som mangler, hva teamet må fylle ut. Sjekklista publiseres ikke for testerne. Den lenkes fra den interne testen (feltet «Kvalitetssikring i teamet»).

## Modus B og C: Lage testdokumentet

### B1/C1. Spør teamet om det kravene ikke sier

Still spørsmålene samlet med `AskUserQuestion` (høyst fire om gangen). Hopp over det som står i forrige testdokument eller i oppgavemappa, men vis det og spør om det fortsatt gjelder.

- **Miljø og URL** der testen kjøres, og om funksjonen ligger bak et feature-flagg.
- **Testbrukere per rolle.** List rollene du fant i kravene (fra `Som <rolle>`, `Gitt jeg er <rolle>` og rollene i *Synlighet*-regler), og be om testbruker og organisasjon for hver. Testbrukere som ikke har en rolle i kravene, trengs ikke.
- **Testdata:** opptak, søknader, søkere, saksnummer, regelverkssamlinger osv. som må finnes før testen. Be om navn og hvor de ligger (lenke).
- **Hvem og når:** kontaktperson i teamet, testansvarlig, dato og tidsramme, Slack-tråd.
- **Bare C:** hvem testerne er (HK-dir, læresteder), og hvilke deler av funksjonaliteten som gjelder dem. Eksterne tester bare det de skal bruke: i et samordna opptak er det kravene for samordna opptak, ikke for lokale opptak. Som hovedregel tester de heller ikke negative scenarioer (det som ikke skal gå). De testes internt. Foreslå et utvalg ut fra rollene og reglene, og la brukeren velge (`multiSelect`).

Testbrukerne og testdataene skrives inn i hvert testtilfelle (kolonnene «Testbruker» og «Testdata»), ikke i egne tabeller. Mangler testdata, skriv `[Fylles ut: <hva som trengs>]` i cella, og list det i oppsummeringen. Testeren skal aldri måtte lete fram data selv.

### B2/C2. Sjekk hva som kan testes i miljøet

For hvert scenario, bestem én av:

| Klasse | Når | I testdokumentet |
|---|---|---|
| **Testbar** | Funksjonen finnes i miljøet, og resultatet kan ses | Testtilfelle |
| **Testbar delvis** | Verdien kan settes og lagres, men virkningen (hos søkeren, i saksbehandlingen) finnes ikke ennå eller ikke i miljøet | Intern: testtilfelle for det som kan testes, og raden i «Ikke testbart nå» for resten. Ekstern: ta bare med hvis det som kan testes, gir mening for testerne |
| **Ikke testbar nå** | Koden mangler (verify: ikke funnet), ligger bak et flagg som er av, eller testdataene finnes ikke | Intern: «Ikke testbart nå», med grunn og når det kan testes. Ekstern: «Ikke med i denne testen», med en kort grunn uten tekniske ord |

Bland aldri «(ikke testbart: …)» inn i forventet resultat. Forventet resultat er det testeren skal se nå.

Er et scenario usikkert i verify-rapporten, spør teamet før du tar det med.

### B3/C3. Gjør scenarioene om til testtilfeller

Følg `references/teststeg.md`. Kort fortalt: hvert testtilfelle har testbrukeren, hvor man starter, nummererte steg med begrepene fra skjermen og alle verdiene, og et forventet resultat som kan ses, med sjekk av at det er lagret. Et `Scenariomal:` blir ett testtilfelle per eksempelrad (`2.1a`, `2.1b`). To scenarioer som tester det samme i løsningen, slås sammen til ett testtilfelle som viser til begge.

### B4/C4. Sorter og del opp

Rekkefølgen er rekkefølgen testeren gjør ting i, ikke rekkefølgen i feature-fila:

1. **Grupper etter testbruker.** Alt én testbruker gjør, står samlet i en del (`Del 1: Som opptaksforvalter ved forvaltende organisasjon`). Bytte av testbruker er en ny del, eller et eget steg når det bare skjer én gang.
2. **Innenfor en del: etter hvor i løsningen.** Testtilfellene på samme side står etter hverandre. Det som lager data (opprette opptak), står før det som bruker dataene.
3. **Positive før negative** på samme side, og opprydding («Gjør klar til neste test: slett periodene») som egen rad.
4. **Avhengigheter står i testtilfellet** («Bruker opptaket fra 1.1»), og delen sier hva den forutsetter.

**Dele opp.** Regn 2–4 minutter per testtilfelle. Blir testen lengre enn tidsrammen (1–2 timer internt, og kortere eksternt), eller dekker den flere varianter av prosessen (samordna og lokalt opptak), foreslå å dele den i flere tester, eller i del 1 og del 2 med hver sin tidsramme. Spør før du deler.

Nummerer testtilfellene `<del>.<n>`. Den eksterne testen nummereres for seg, fra 1.

### B5/C5. Skriv dokumentet

Fyll ut malen. Intern: `references/mal-intern.md`. Ekstern: `references/mal-ekstern.md`. Testsidene er for testerne, og har bare det de trenger: hva som er laget, brukerhistorien, hvor de tester, lenke til kvalitetssikringen (intern), hva de ikke kan gjøre i testen (en kort punktliste), hvem de spør, og testtilfellene med testbruker og testdata i hver rad. Feature-ID-er, tagger, commits, saker i GitHub og Jira, feature-flagg, kodeverdier, verify-resultater, «berører andre team», åpne spørsmål og sporingen fra testtilfelle til krav står på kvalitetssikringssiden (modus A), ikke på testsidene. Lag kvalitetssikringssiden også når brukeren bare ber om en test.

Øverst i fila står metadata for repoet (oppgave, krav med commit, nivå, Confluence-lenke). Det publiseres ikke.

### B6/C6. Kvalitetssikre og vis fram

1. Kjør modus D på utkastet, og rett det som er bare ordlyd eller rekkefølge. Det som krever teamet, står igjen som `[Fylles ut …]` eller `[Sjekk begrep]`.
2. Vis oppsummeringen: antall testtilfeller per del, beregnet tid, hva som er utelatt og hvorfor, hva teamet må fylle ut, og scenarioer som bør tilbake til `fs-krav` (uklare, ikke testbare som de står, motsier andre krav).
3. Spør om utkastet skal publiseres på Confluence (se *Publisere på Confluence*).

## Modus D: Kvalitetssikre testdokumentet

Brukeren oppgir en fil i `tester/` eller en Confluence-side (les den med Atlassian-MCP, se `references/confluence.md`).

1. Finn kravene testen bygger på (fra metadata, fra «Krav» i testbeskrivelsen, eller spør).
2. Sjekk hvert testtilfelle mot T1–T14 i `references/teststeg.md`, og dokumentet som helhet mot malen for nivået (riktig nivå: ingen helhetsrunde, ingen trinn 1-seksjon hos testerne, ingen tekniske ord i den eksterne).
3. Sjekk dekningen: scenarioer i gating-settet som mangler i testen, testtilfeller som ikke svarer til noe scenario, og duplikater.
4. Rapporter i chat:

```
| # | Regel | Nå | Forslag | Klasse |
|---|---|---|---|---|
| 3.16 | T6 Hele veien til resultatet | «Angi at søkere ikke kan laste opp dokumentasjon» | Legg til: «6. Logg inn i Min kompetanse som søker <testbruker 5>. 7. Åpne søknaden i «Samordna opptak 2027 (test)» og prøv å laste opp et dokument.» | Trenger teamet |
```

   Klassene er **Bare ordlyd** (kan rettes fra dokumentet og kravene alene), **Rekkefølge** (flytte eller slå sammen) og **Trenger teamet** (testdata, begreper fra skjermen, hva som er testbart).
5. Rett bare når brukeren sier ja. I en fil: med `Edit`. På Confluence: se `references/confluence.md`, og rør aldri kolonnene testerne fyller ut.

## Modus E: Oppsummere etter testen

1. Les siden fra Confluence (`references/confluence.md`).
2. Tell resultatene per del: Ja / Nei / Delvis / tomt. List funnene etter alvorlighetsgrad (Stopper, Må fikses før innføring, Kan fikses senere), og «Andre funn og erfaringer» for seg.
3. Sorter hvert funn som ikke er en ren feil i løsningen:
   - **Testdokumentet var feil eller uklart** (manglende steg, feil begrep, feil testbruker): forslag til retting av malen eller stegene, til læringsmøtet.
   - **Kravet er uklart eller mangler noe:** foreslå `fs-krav` (modus B, eller D for leverte krav), med spørsmålet.
   - **Utenfor testens omfang:** list for kontaktpersonen.
4. Foreslå et utfall (Godkjent / Godkjent med forbehold / Ikke godkjent) med begrunnelse. Testansvarlig (internt) eller testerne (eksternt) bestemmer. Skriv ikke beslutningen på siden.
5. Skriv oppsummeringen til `tester/resultat-<nivå>-<slug>-<YYYY-MM-DD>.md`, med lenke til siden. Kravene retagges ikke her: det er `fs-verify` som setter `@implemented`.

## Publisere på Confluence

Følg `references/confluence.md`. Det viktigste:

- Spør alltid før du oppretter eller endrer en side: tittel, foreldreside, og om den skal være utkast eller publisert.
- Les siden før du endrer den. Har testerne fylt ut «Faktisk resultat», «Bestått?», funn eller beslutning, skrives det aldri over.
- Skriv lenken til siden i metadataene i fila (`- **Confluence**:`).

## Hva skillen ikke gjør

- Endrer ikke kravene eller taggene, og retagger ikke etter testen.
- Lager ikke regresjonstester, tester av universell utforming eller automatiske tester (det er `lage-steps`).
- Oppretter ikke Jira-saker eller Slack-tråder. Den foreslår teksten, og teamet oppretter dem.
- Kjører aldri git add/commit/push.
