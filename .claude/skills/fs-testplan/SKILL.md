---
name: fs-testplan
description: Lager testplanen for en leveranse, etter teststrategien «Teststrategi for FS – fra krav til akseptanse» i Confluence (STUDIEADM). Testplanen er hovedsiden i Confluence, og grunnlaget for resten av testflyten (fs-verify → fs-testrapport → fs-testcaser-intern → fs-testrapport → fs-testcaser-ekstern → fs-testrapport). Leveransen er et scope (`@scope-<slug>`), en oppgave (`tasks/<domene>/<slug>`), en mappe under `krav/` eller én eller flere feature-filer. Kravene står med Feature-ID i «Omfang», så alle trinnene tester de samme kravene, og scope-id-ene kravene har, står i testplanen. Det som testes, er det som er `@implemented`. Finner kravene og scenarioene i gating-settet, spør teamet om testmiljø, versjon, feature-flagg, nummererte testbrukere, testdata, roller og tid, og skriver testbeskrivelse, omfang, «Ikke med i denne testen», forutsetninger, kriterier for godkjent, alvorlighetsgrader, beslutning og «Status i flyten». Skriver `akseptansetest/<slug>/testplan.md`, og oppretter siden «Testplan – <leveranse>» i Confluence bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testplan", "testplan for scopet", "testplan for oppgaven", "testplan for mappa", "testplan for feature-fila", "start akseptansetesten", "testplan i Confluence", "fs-testplan".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testplan

## Task

$ARGUMENTS

## Din rolle

Du lager planen før testen: hva som testes, av hvem, hvor og når, og hva som skal til for å godkjenne leveransen. Testplanen er steg 1 i flyten i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850), og hovedsiden i Confluence som de andre sidene står under (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)).

- **«Omfang» er fasit for resten av flyten.** Kravene står der med Feature-ID, og de andre skillene leser dem derfra. Kilden (scope, oppgave, mappe eller filer) og scope-id-ene kravene har, står i metadataene og i «Testbeskrivelse».
- **Det som testes, er det som er `@implemented`.** Krav med en annen status står i testplanen («Venter på verifisering» eller «Ikke med i denne testen»), men får ikke testcaser.
- **Endre aldri kravene, taggene, scope-fila eller `oppgave.md`.** Er et krav ikke klart, står det i «Ikke med i denne testen», og du foreslår `fs-krav`, `fs-specify` eller `fs-verify`.
- **Gjett aldri det bare teamet vet.** Testbrukere, testdata, miljø, versjon og forutsetninger kommer fra teamet. Det du ikke får svar på, står som `[Fylles ut …]`.
- **Publiser aldri uten ja.** Se [`confluence.md`](../../references/akseptansetest/confluence.md).

## I FS Kravforvaltning

Skillen står ikke i lista over skills i Claude-panelet ennå, så den brukes fra Claude Code i terminalen. Uten Bash: bruk `Grep` og `Glob` i stedet for `grep` og `git`, og skriv `commit ikke sjekket (Claude-panelet)` i metadataene.

## Sjekk branchen (gjør dette aller først)

Sjekk at branchen i dette repoet er oppdatert mot origin og main, som beskrevet i [`.claude/references/oppdatert-branch.md`](../../references/oppdatert-branch.md). Er den bak, spør før du henter.

## Kilder (les FØRST)

1. [`.claude/references/akseptansetest/krav-fra-testplan.md`](../../references/akseptansetest/krav-fra-testplan.md): leveransen, scope-id-en, kravene og gating-settet.
2. [`references/mal-testplan.md`](references/mal-testplan.md): malen.
3. [`.claude/references/akseptansetest/alvorlighetsgrad.md`](../../references/akseptansetest/alvorlighetsgrad.md): tekstene om funn, alvorlighetsgrad og beslutning.
4. [`.claude/references/akseptansetest/confluence.md`](../../references/akseptansetest/confluence.md) før du leser fra eller skriver til Confluence.

Strategien i Confluence er kilden til malen. Er den endret etter malen her, si fra, og følg strategien.

## 1. Finn leveransen

1. **Kilden.** Brukeren oppgir et scope (`scope-<slug>`, `@scope-<slug>` eller stien til scope-fila), en oppgave, en mappe under `krav/`, eller én eller flere `.feature`-filer (se *Leveransen* i `krav-fra-testplan.md`). Er det uklart, spør (`AskUserQuestion`). Har en oppgave et scope med flere oppgaver, spør: «Testplan for hele scopet «<tittel>», eller bare for oppgaven «<slug>»?»
2. **Flere domener.** Har initiativet scope i flere domener (samme `Initiativ` i flere `scope-*.md`), spør om de andre scopene skal med i samme testplan.
3. **Testplan-slugen.** Scope-slugen for et scope, `<domene>-<oppgave-slug>` for en oppgave, navnet på mappa for en mappe, og filnavnet for én fil, begge i kebab-case uten tallprefiks og med æ/ø/å som ae/o/a (`krav/02 Opptak/10 Regelverk/` → `regelverk`, `opprett_opptak.feature` → `opprett-opptak`). For flere filer: spør om navnet. Finnes slugen fra før for en annen kilde, legg domenet foran (`opptak-regelverk`). Finnes `akseptansetest/<slug>/testplan.md` fra før, er det en ny versjon av testplanen: les den, vis hva som endres, og spør før du skriver over. Det testansvarlig har fylt ut («Kriterier for godkjent», «Status i flyten»), beholdes.

## 2. Finn kravene

Følg `krav-fra-testplan.md` for kilden: kravene, gruppert (per oppgave for et scope, per kapabilitetsmappe for en mappe), scope-id-ene, statusen og gating-settet per krav. Les også, når de finnes:

- `oppgave.md` (issue, eier), `design.md` og `utforing.md` i hver oppgave (for en mappe eller fil: oppgavene som har kravene, funnet med `Grep` på Feature-ID i `tasks/*/*/spec/spec-*.md` og scope-filene): hva som er levert, PR-ene, overleveringen, «berører andre team»
- den nyeste verify-rapporten: `spec/verify-*.md` i hver oppgave, eller `verify-*.md` ved siden av kravet eller i mappa
- forrige testplan i `akseptansetest/` for samme domene: testbrukerne og testdataene kan gjenbrukes

Vis oversikten før du spør teamet: kravene per gruppe, status, antall scenarioer som skal testes (de leverte i gating-settet), det som venter på verifisering, og det som ikke er med. Er ingen av kravene `@implemented`, si det, og spør om testplanen skal lages likevel.

## 3. Spør teamet

Still spørsmålene samlet med `AskUserQuestion`, høyst fire om gangen. Har forrige testplan svaret, vis det og spør om det fortsatt gjelder.

1. **Leveransen:** navnet (tittelen på siden), versjonen, testmiljøet (URL) og feature-flagg.
2. **Testbrukerne:** list rollene du fant i kravene (`Som <rolle>`, `Gitt jeg er <rolle>`, rollene i *Synlighet*-regler), og be om navn og organisasjon for hver. Nummerer dem fra 1. Minst to organisasjoner.
3. **Testdataene:** opptak, søkere, søknader, regelverkssamlinger osv. som må finnes, hvor de ligger, og om de kan settes tilbake.
4. **Roller og tid:** testansvarlig, kontaktperson, andre testere, tidspunkt, Slack-kanal, og om leveransen også skal til ekstern akseptansetest (og hvem som tester der).

Det brukeren hopper over, skrives som `[Fylles ut: <hva>]`.

## 4. Skriv testplanen

Fyll ut malen, og skriv `akseptansetest/<testplan-slug>/testplan.md`:

- «Hva er levert» med vanlige ord, fra brukerhistoriene og `utforing.md`.
- «Omfang» per gruppe (oppgave, kapabilitetsmappe eller filene), med lenke til hvert krav på GitHub (på commiten), Feature-ID, status og antall scenarioer som testes. Bare krav som er `@implemented`, står her.
- «Venter på verifisering»: krav og deler som er `@in-progress`, eller `@planned`-deler i leverte krav som endres.
- «Ikke med i denne testen» med grunnen fra `krav-fra-testplan.md`.
- Forutsetning 5 fylles ut fra verify-rapporten når den finnes.
- «Status i flyten»: steg 1 er «Laget». Er leveransen ikke til ekstern test, er steg 6 og 7 «Ikke aktuell».
- «Funn og alvorlighetsgrad» og «Beslutning» ordrett fra `alvorlighetsgrad.md`.

## 5. Vis fram og publiser

1. Vis en kort oppsummering: antall krav og scenarioer som testes per gruppe, det som venter på verifisering, det som ikke er med, og det som må fylles ut.
2. Spør om testplanen skal opprettes i Confluence (`confluence.md`, *Før du skriver*). Siden legges alltid under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner) (`5126062121`), og skillen spør ikke om foreldresiden.
3. Skriv lenken i metadataene (`- **Confluence**:`).
4. Si hva som er neste steg: `fs-verify` med testplanen (`akseptansetest/<slug>`) når noe venter på verifisering, og at den kan legge resultatet som en underside her. Er alt i «Omfang» `@implemented`, og det finnes en verify-rapport, kan flyten gå rett til `fs-testrapport` (verifisering) med den rapporten.

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene, scope-fila eller `oppgave.md`.
- Lager ikke testcasene (`fs-testcaser-intern`, `fs-testcaser-ekstern`) eller rapportene (`fs-testrapport`).
- Oppretter ikke Jira-saker, Slack-tråder eller avtaler i testkalenderen. Den foreslår teksten.
- Kjører aldri git add/commit/push.
