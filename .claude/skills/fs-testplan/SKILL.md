---
name: fs-testplan
description: Lager testplanen for en leveranse, etter teststrategien «Teststrategi for FS – fra krav til akseptanse» i Confluence (STUDIEADM). Kommer etter verifiseringen (fs-verify eller fs-verify-agent-teams), og bygger på resultatet: statusen kravene har fått, og hvilke krav som er klare for test. Testplanen er hovedsiden i Confluence, og grunnlaget for resten av testflyten (fs-testrapport → fs-testcaser-intern → fs-testrapport → fs-testcaser-ekstern → fs-testrapport). Leveransen er et scope (`@scope-<slug>`), en oppgave (`tasks/<domene>/<slug>`), en mappe under `krav/` eller én eller flere feature-filer. Kravene står med Feature-ID i «Omfang», så alle trinnene tester de samme kravene, og scope-id-ene kravene har, står i testplanen. Flytene i `krav/_Flyter` som går gjennom kravene, står i «Flyter», med om hele flyten eller deler av den testes. Det som testes, er det som er `@implemented`. Finner kravene, scenarioene i gating-settet og den nyeste verify-rapporten (og foreslår fs-verify først når den mangler eller er eldre enn kravene), spør teamet om testmiljø, versjon, feature-flagg, nummererte testbrukere, testdata, roller og tid, og skriver testbeskrivelse, omfang, flyter, «Ikke med i denne testen», forutsetninger, kriterier for godkjent, alvorlighetsgrader, beslutning og «Status i flyten». Skriver `akseptansetest/<slug>/testplan.md`, og oppretter siden «Testplan – <leveranse>» i Confluence, med verifiseringen som underside, bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testplan", "testplan for scopet", "testplan for oppgaven", "testplan for mappa", "testplan for feature-fila", "start akseptansetesten", "testplan i Confluence", "fs-testplan".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testplan

## Task

$ARGUMENTS

## Din rolle

Du lager planen før testen: hva som testes, av hvem, hvor og når, og hva som skal til for å godkjenne leveransen. Testplanen er steg 2 i flyten, etter verifiseringen (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)), som i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850): `fs-verify` først, så forutsetningene for testen. Testplanen er hovedsiden i Confluence som de andre sidene står under.

- **Verifiseringen er grunnlaget.** `fs-verify` eller `fs-verify-agent-teams` har satt `@implemented` på kravene der koden er funnet, og rapporten sier hva som mangler. Testplanen bygger på statusen i kravfilene og på rapporten, og finner ikke på egen hånd ut om noe er levert.
- **«Omfang» er fasit for resten av flyten.** Kravene står der med Feature-ID, og de andre skillene leser dem derfra. Kilden (scope, oppgave, mappe eller filer) og scope-id-ene kravene har, står i metadataene og i «Testbeskrivelse».
- **Det som testes, er det som er `@implemented`.** Krav med en annen status står i testplanen («Venter på verifisering» eller «Ikke med i denne testen»), men får ikke testcaser.
- **Overleveringene testes også.** Er et krav i leveransen med i en flyt i `krav/_Flyter/`, står flyten i «Flyter», og overleveringene i den testes (*Flyter* i `krav-fra-testplan.md`). «Flyten» i «Status i flyten» er testflyten, ikke en slik flyt.
- **Endre aldri kravene, taggene, scope-fila eller `oppgave.md`.** Er et krav ikke klart, står det i «Venter på verifisering» eller «Ikke med i denne testen», og du foreslår `fs-krav`, `fs-specify` eller `fs-verify`.
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
- forrige testplan i `akseptansetest/` for samme domene: testbrukerne og testdataene kan gjenbrukes

Finn så flytene som går gjennom kravene, fasene i hver flyt, og om hele flyten eller deler av den kan testes, etter *Flyter* i `krav-fra-testplan.md`.

### Verifiseringen

Finn den nyeste verify-rapporten for leveransen (`- **Dato:**` i rapporten):

- **Scope:** `akseptansetest/<scope-slug>/verify-*.md`, og `spec/verify-*.md` i hver oppgave i scopet.
- **Oppgave:** `spec/verify-*.md` i oppgaven.
- **Mappe eller fil:** `verify-*.md` ved siden av kravet eller i mappa, og `spec/verify-*.md` i oppgavene som har kravene.

Finnes flere rapporter (for ulike oppgaver eller mapper), ta den nyeste for hver, og si hvilke du har brukt. Sjekk så:

1. **Finnes det en rapport?** Nei: si at verifiseringen er steg 1, og spør (`AskUserQuestion`): «Kjør `fs-verify` først» (anbefalt, eller `fs-verify-agent-teams` når det er mange feature-filer), «Lag testplanen likevel» eller «Avbryt». Ved «Kjør `fs-verify` først»: stopp, og si hvilken kilde verifiseringen skal kjøres på (den samme som testplanen).
2. **Er den nyere enn kravene?** Sammenlign datoen med siste commit på kravfilene (`git log -1 --format=%cs -- <filene>`). Er et krav endret etter rapporten, eller er det kommet krav i kilden som ikke er med i rapporten, si hvilke, og spør på samme måte. Uten Bash: sammenlign bare kravene i rapporten med kravene i kilden, og si at datoene ikke er sjekket.
3. **Har den flytene?** Gjelder bare flyter som ikke er `@implemented` (en `@implemented` flyt er verifisert fra før). Har en slik flyt med leverte faser ingen rader i `## Fremdrift for flyter` og `## Scenarioer` i rapporten, er overleveringene ikke verifisert. Spør på samme måte om `fs-verify` skal kjøres først (på den samme kilden, eller på flyten). Lages testplanen likevel, står overleveringene i flyten i «Ikke med i denne testen» med «overleveringen er ikke verifisert».
4. **Hva fant den?** Krav og deler der rapporten har `ikke funnet` eller `usikker`, står i «Venter på verifisering», med hva som mangler (fra `## Ikke levert` og `## Oppfølging`). Statusen i kravfila gjelder: er et krav `@implemented`, er det med i «Omfang», også om en eldre rapport sa noe annet.

Vis oversikten før du spør teamet: verify-rapporten (dato, resultat), kravene per gruppe, status, antall scenarioer som skal testes (de leverte i gating-settet), flytene (faser levert, faser i leveransen, scenarioer som kan testes), det som venter på verifisering, og det som ikke er med. Er ingen av kravene `@implemented`, si det, og spør om testplanen skal lages likevel.

## 3. Spør teamet

Still spørsmålene samlet med `AskUserQuestion`, høyst fire om gangen (resten i en ny runde). Har forrige testplan svaret, vis det og spør om det fortsatt gjelder. Spørsmålene om roller, testbrukere, testdata og miljø står i [`.claude/references/akseptansetest/roller-og-testdata.md`](../../references/akseptansetest/roller-og-testdata.md), og er de samme som `fs-testcaser-cdp` bruker. Følg den.

1. **Leveransen:** navnet (tittelen på siden), versjonen, testmiljøet (URL, alltid et testmiljø) og feature-flagg.
2. **Testbrukerne:** som i referansen: rollene du fant i kravene, navn og organisasjon for hver, nummerert fra 1, minst to organisasjoner.
3. **Testdataene:** som i referansen: opptak, søkere, søknader, regelverkssamlinger osv. som må finnes, hvor de ligger, og om de kan settes tilbake.
4. **Roller og tid:** testansvarlig, kontaktperson, andre testere, tidspunkt, Slack-kanal, og om leveransen også skal til ekstern akseptansetest (og hvem som tester der).
5. **CDP (valgfritt):** «Skal en CDP-agent kjøre testene (steg 4b)?» Svaret er ja eller nei, og nei er standard. Ved ja: bruk tabellene med CDP-kolonnene fra malen (`Nøkkel`, `Innlogging`, `Start-URL`, `Søk/URL`, `Utgangstilstand` og `Brukes av`), fyll dem ut, og les koden som beskrevet i referansen (*Lese koden når CDP er valgt*). Legg forutsetning 8 inn i testplanen, og sett steg 4b i «Status i flyten» til «Venter». Ved nei: bruk tabellene uten CDP-kolonnene, ta ikke med forutsetning 8, og skriv «Ikke aktuell» i steg 4b.
6. **Flytene:** bare når *Hele eller deler av flyten* i `krav-fra-testplan.md` sier at du skal spørre (en `@implemented` flyt med flere enn fem faser, eller der leveransen bare berører én fase): «Skal hele flyten «<tittel>» testes, eller bare fasene <fasene>?», med «Hele flyten (anbefalt)» og «Bare fasene i leveransen».

Det brukeren hopper over, skrives som `[Fylles ut: <hva>]`.

## 4. Skriv testplanen

Fyll ut malen, og skriv `akseptansetest/<testplan-slug>/testplan.md`:

- «Hva er levert» med vanlige ord, fra brukerhistoriene og `utforing.md`.
- «Omfang» per gruppe (oppgave, kapabilitetsmappe eller filene), med lenke til hvert krav på GitHub (på commiten), Feature-ID, status og antall scenarioer som testes. Bare krav som er `@implemented`, står her.
- «Flyter»: én underseksjon per flyt, med om hele flyten eller deler av den testes og hvorfor, og én rad per fase, med kravene fasen bygger på (status), om fasen er levert og i leveransen, og antall scenarioer som testes. Uten flyter: «Ingen av kravene er med i en flyt.»
- «Venter på verifisering»: krav og deler som er `@in-progress`, eller `@planned`-deler i leverte krav som endres, med det verify-rapporten sier mangler.
- «Ikke med i denne testen» med grunnen fra `krav-fra-testplan.md`, også fasene og overleveringene i flytene som ikke testes.
- «Forutsetninger»: et `# Kjent brudd:` i en flyt blir en egen rad.
- Forutsetning 5 fylles ut fra verify-rapporten.
- «Status i flyten»: steg 1 er verifiseringen, med rapporten (fila, og siden i Confluence når den finnes), «Alt funnet» eller «<N> ikke funnet, <N> usikker», og datoen i rapporten. Uten rapport: «Ikke kjørt». Steg 2 er «Laget». Steg 4b (CDP) er «Venter» når teamet har valgt det, ellers «Ikke aktuell». Er leveransen ikke til ekstern test, er steg 6 og 7 «Ikke aktuell».
- «Funn og alvorlighetsgrad» og «Beslutning» ordrett fra `alvorlighetsgrad.md`.

## 5. Vis fram og publiser

1. Vis en kort oppsummering: antall krav og scenarioer som testes per gruppe, flytene (hele eller deler, og antall overleveringer), det som venter på verifisering, det som ikke er med, og det som må fylles ut.
2. Spør om testplanen skal opprettes i Confluence (`confluence.md`, *Før du skriver*). Siden legges alltid under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner) (`5126062121`), og skillen spør ikke om foreldresiden.
3. Skriv lenken i metadataene (`- **Confluence**:`).
4. **Verifiseringen som underside.** Er testplanen opprettet, og har verify-rapporten ingen `- **Confluence:**`, spør om den skal legges som underside til testplanen, med de samme valgene. Lag undersiden som i *Confluence* i `fs-verify` (steg 3 og 5): tittelen «Verifisering – <leveranse> – <YYYY-MM-DD HH:MM>» med tidspunktet i rapporten, og lenken i metadataene i rapportfila. Oppdater lenken i raden «1. Verifisering» i «Status i flyten», på siden og i `testplan.md`. Er det flere rapporter, blir hver en underside.
5. Si hva som er neste steg: `fs-testrapport` (verifisering) med testplanen. Venter noe på verifisering, kjøres `fs-verify` på nytt med testplanen (`akseptansetest/<slug>`) når teamet har levert det, og den oppdaterer raden «1. Verifisering».

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene, scope-fila eller `oppgave.md`.
- Lager ikke testcasene (`fs-testcaser-intern`, `fs-testcaser-ekstern`) eller rapportene (`fs-testrapport`).
- Oppretter ikke Jira-saker, Slack-tråder eller avtaler i testkalenderen. Den foreslår teksten.
- Kjører aldri git add/commit/push.
