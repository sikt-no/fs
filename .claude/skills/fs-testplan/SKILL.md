---
name: fs-testplan
description: Lager testplanen for en leveranse, etter teststrategien (forslag) «Teststrategi for FS – fra krav til akseptanse» i Confluence (STUDIEADM). Kommer etter verifiseringen (fase 1, fs-verify eller fs-verify-agent-teams), og bygger på resultatet: statusen kravene har fått, regler i koden uten scenario og hvilke krav som er klare for test. Testplanen planlegger: hvilke krav og flyter som testes, hvordan testautomatiseringen lager sine egne testdata (manuelt eller seedet via API, vurdert per krav), testbrukere ut fra tilgangsmatrisen, avhengighetskart, antall åpne spørsmål per krav (de stopper ikke testen), forutsetninger, kriterier for godkjent og sporbarhet. Den lager ikke testcasene: fs-testcaser-cdp lager testcasene for fase 2 (agentisk funksjonstest) og fs-testcaser-intern flyttestene for fase 3. Testplanen er hovedsiden i Confluence, og grunnlaget for resten av testflyten (fs-testcaser-cdp → fs-testrapport (agentisk) → fs-testcaser-intern → fs-testrapport (intern) → fs-testcaser-ekstern → fs-testrapport (ekstern)). Leveransen er et scope (`@scope-<slug>`), en oppgave (`tasks/<domene>/<slug>`), en mappe under `krav/` eller én eller flere feature-filer. Kravene står med Feature-ID i «Omfang», så alle fasene tester de samme kravene, og scope-id-ene kravene har, står i testplanen. Flytene i `krav/_Flyter` som går gjennom kravene, står i «Flyter», med om hele flyten eller deler av den testes. Det som testes, er det som er `@implemented`. Skriver `akseptansetest/<slug>/testplan.md`, og oppretter siden «Testplan – <leveranse>» i Confluence, med verifiseringen som underside, bare når brukeren sier ja. Endrer aldri kravene eller taggene. Trigges av "lag testplan", "testplan for scopet", "testplan for oppgaven", "testplan for mappa", "testplan for feature-fila", "start akseptansetesten", "testplan i Confluence", "fs-testplan".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion
---

# Testplan

## Task

$ARGUMENTS

## Din rolle

Du lager planen før testen: hva som testes, av hvem, hvor og når, hvordan testdata lages, og hva som skal til for å godkjenne leveransen. Testplanen kommer etter verifiseringen (fase 1) og før den agentiske funksjonstesten (fase 2), som i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326) (se [`akseptansetest/README.md`](../../../akseptansetest/README.md)): `fs-verify` først, så forutsetningene for testen. Testplanen er hovedsiden i Confluence som de andre sidene står under.

- **Du planlegger, du lager ikke testcaser.** Testplanen sier hvilke krav og flyter som testes, og grunnlaget for dem. `fs-testcaser-cdp` lager testcasene for fase 2, og `fs-testcaser-intern` flyttestene for fase 3. De leser testplanen.

- **Verifiseringen er grunnlaget.** `fs-verify` eller `fs-verify-agent-teams` har satt `@implemented` på kravene der koden er funnet (og på de leverte delene i krav som er delvis levert), og rapporten sier hva som mangler. Testplanen bygger på statusen i kravfilene og på rapporten, og finner ikke på egen hånd ut om noe er levert.
- **«Omfang» er fasit for resten av flyten.** Kravene står der med Feature-ID, og de andre skillene leser dem derfra. Kilden (scope, oppgave, mappe eller filer) og scope-id-ene kravene har, står i metadataene og i «Testbeskrivelse».
- **Det som testes, er det som er `@implemented`:** kravene, og de leverte delene i krav som er delvis levert (`@implemented` på `Regel:`/`Scenario:` under en `@in-progress` egenskap, se *Delvis levert* i `krav/README.md`). Krav med en annen status står i testplanen («Venter på verifisering» eller «Ikke med i denne testen»), men får ikke testcaser.
- **Overleveringene testes også.** Er et krav i leveransen med i en flyt i `krav/_Flyter/`, står flyten i «Flyter», og overleveringene i den testes i fase 3 (*Flyter* i `krav-fra-testplan.md`). «Flyten» i «Status i flyten» er testflyten, ikke en slik flyt.
- **Testautomatiseringen lager sine egne testdata.** Fase 2 forutsetter ikke at data finnes fra før. Per krav vurderer du hva som må opprettes, om det gjøres manuelt eller seedes via API, hvordan det ryddes eller settes tilbake, og om testen kan kjøres på nytt.
- **`@openquestion` stopper ikke testen.** Testplanen viser hvor mange regler og scenarioer som har åpne spørsmål per krav, men gater ikke på dem (*Åpne spørsmål* i `krav-fra-testplan.md`).
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

Strategien (forslaget, side 5145100326) er kilden til malen. Er den endret etter malen her, si fra, og følg strategien.

## 1. Finn leveransen

1. **Kilden.** Brukeren oppgir et scope (`scope-<slug>`, `@scope-<slug>` eller stien til scope-fila), en oppgave, en mappe under `krav/`, eller én eller flere `.feature`-filer (se *Leveransen* i `krav-fra-testplan.md`). Er det uklart, spør (`AskUserQuestion`). Har en oppgave et scope med flere oppgaver, spør: «Testplan for hele scopet «<tittel>», eller bare for oppgaven «<slug>»?»
2. **Flere domener.** Har initiativet scope i flere domener (samme `Initiativ` i flere `scope-*.md`), spør om de andre scopene skal med i samme testplan.
3. **Testplan-slugen.** Scope-slugen for et scope, `<domene>-<oppgave-slug>` for en oppgave, navnet på mappa for en mappe, og filnavnet for én fil, begge i kebab-case uten tallprefiks og med æ/ø/å som ae/o/a (`krav/02 Opptak/10 Regelverk/` → `regelverk`, `opprett_opptak.feature` → `opprett-opptak`). For flere filer: spør om navnet. Finnes slugen fra før for en annen kilde, legg domenet foran (`opptak-regelverk`). Finnes `akseptansetest/<slug>/testplan.md` fra før, er det en ny versjon av testplanen: les den, vis hva som endres, og spør før du skriver over. Det testansvarlig har fylt ut («Kriterier for godkjent», «Status i flyten»), beholdes.

## 2. Finn kravene

Følg `krav-fra-testplan.md` for kilden: kravene, gruppert (per oppgave for et scope, per kapabilitetsmappe for en mappe), scope-id-ene, statusen og gating-settet per krav. Les også, når de finnes:

- `oppgave.md` (issue, eier), `design.md` og `utforing.md` i hver oppgave (for en mappe eller fil: oppgavene som har kravene, funnet med `Grep` på Feature-ID i `tasks/*/*/spec/spec-*.md` og scope-filene): hva som er levert, PR-ene, overleveringen, «berører andre team»
- forrige testplan i `akseptansetest/` for samme domene: testbrukerne og testdataene kan gjenbrukes

Finn så flytene som går gjennom kravene, fasene i hver flyt, og om hele flyten eller deler av den kan testes, etter *Flyter* i `krav-fra-testplan.md`.

### Regler uten scenario

`fs-verify` rapporterer regler i koden som ikke har scenario i kravet (valideringer, tilgangssjekker). Les dem fra verify-rapporten. De er input til de agentiske testcasene, og står i «Regler uten scenario» i testplanen.

### Verifiseringen

Finn den nyeste verify-rapporten for leveransen (`- **Dato:**` i rapporten):

- **Scope:** `akseptansetest/<scope-slug>/verify-*.md`, og `spec/verify-*.md` i hver oppgave i scopet.
- **Oppgave:** `spec/verify-*.md` i oppgaven.
- **Mappe eller fil:** `verify-*.md` ved siden av kravet eller i mappa, og `spec/verify-*.md` i oppgavene som har kravene.

Finnes flere rapporter (for ulike oppgaver eller mapper), ta den nyeste for hver, og si hvilke du har brukt. Sjekk så:

1. **Finnes det en rapport?** Nei: si at verifiseringen er fase 1, og spør (`AskUserQuestion`): «Kjør `fs-verify` først» (anbefalt, eller `fs-verify-agent-teams` når det er mange feature-filer), «Lag testplanen likevel» eller «Avbryt». Ved «Kjør `fs-verify` først»: stopp, og si hvilken kilde verifiseringen skal kjøres på (den samme som testplanen).
2. **Er den nyere enn kravene?** Sammenlign datoen med siste commit på kravfilene (`git log -1 --format=%cs -- <filene>`). Er et krav endret etter rapporten, eller er det kommet krav i kilden som ikke er med i rapporten, si hvilke, og spør på samme måte. Uten Bash: sammenlign bare kravene i rapporten med kravene i kilden, og si at datoene ikke er sjekket.
3. **Har den flytene?** Gjelder bare flyter som ikke er `@implemented` (en `@implemented` flyt er verifisert fra før). Har en slik flyt med leverte faser ingen rader i `## Fremdrift for flyter` og `## Scenarioer` i rapporten, er overleveringene ikke verifisert. Spør på samme måte om `fs-verify` skal kjøres først (på den samme kilden, eller på flyten). Lages testplanen likevel, står overleveringene i flyten i «Ikke med i denne testen» med «overleveringen er ikke verifisert».
4. **Hva fant den?** Krav og deler der rapporten har `ikke funnet` eller `usikker`, står i «Venter på verifisering», med hva som mangler (fra `## Ikke levert` og `## Oppfølging`). Statusen i kravfila gjelder: er et krav `@implemented`, er det med i «Omfang», også om en eldre rapport sa noe annet. Er det delvis levert, står det i «Omfang» med de leverte delene, og delene som ikke er levert, i «Venter på verifisering».

Vis oversikten før du spør teamet: verify-rapporten (dato, resultat), kravene per gruppe, status, antall scenarioer som skal testes (de leverte i gating-settet), flytene (faser levert, faser i leveransen, scenarioer som kan testes), det som venter på verifisering, og det som ikke er med. Er ingen av kravene `@implemented` eller delvis levert, si det, og spør om testplanen skal lages likevel.

## 3. Spør teamet

Still spørsmålene samlet med `AskUserQuestion`, høyst fire om gangen (resten i en ny runde). Har forrige testplan svaret, vis det og spør om det fortsatt gjelder. Spørsmålene om roller, testbrukere, testdata og miljø står i [`.claude/references/akseptansetest/roller-og-testdata.md`](../../references/akseptansetest/roller-og-testdata.md), og er de samme som `fs-testcaser-cdp` bruker. Følg den.

1. **Leveransen:** navnet (tittelen på siden), versjonen, testmiljøet (URL, alltid et testmiljø) og feature-flagg.
2. **Testbrukerne:** som i referansen. Lag først tilgangsmatrisen per krav (rolle × organisasjon: egen, annen, ingen tilgang) fra kravene og verify-rapporten, og foreslå testbrukerne ut fra den. Spør om navn og organisasjon for hver, nummerert fra 1, med alle relevante roller ved organisasjonene kravet gjelder. Antallet er det matrisen krever, ikke et fast tall. CDP-kolonnene (`Nøkkel`, `Innlogging`, `Start-URL`) er alltid med.
3. **Testdataene:** *testautomatiseringen lager dem selv.* Foreslå per krav hva som må opprettes (fra `Gitt`-stegene), og spør: manuelt eller seedet via API (hvilken mutation eller hvilket endepunkt), hvordan det ryddes eller settes tilbake, og om testen kan kjøres på nytt. Data som finnes fra før, står som «Finnes fra før». Les koden som beskrevet i referansen (*Lese koden*) for å finne feltene som må fylles ut og API-et som kan seede dem.
4. **Roller og tid:** testansvarlig, hvem som kjører agenten, kontaktperson, andre testere, tidspunkt for kjøringen og den interne testen, Slack-kanal, og om leveransen også skal til ekstern akseptansetest (og hvem som tester der).
5. **Avhengighetskart:** «Trenger leveransen et avhengighetskart?» Foreslå avhengighetene du finner (andre moduler i FS, integrasjoner, batchjobber, rapporter, eksport, andre teams leveranser, fra `utforing.md`, `design.md` og `@depends-on-`), og spør teamet om resten. Testleder avgjør om kartet trengs.
6. **Flytene:** bare når *Hele eller deler av flyten* i `krav-fra-testplan.md` sier at du skal spørre (en `@implemented` flyt med flere enn fem faser, eller der leveransen bare berører én fase): «Skal hele flyten «<tittel>» testes, eller bare fasene <fasene>?», med «Hele flyten (anbefalt)» og «Bare fasene i leveransen». Gjør i tillegg *Vurdering per krav (fase 3)* i malen: for hvert krav, inngår det i en flyt som skal testes, skal det lages en ny flyt (`fs-krav`, modus E), eller kobles det til en eksisterende?

Det brukeren hopper over, skrives som `[Fylles ut: <hva>]`.

## 4. Skriv testplanen

Fyll ut malen, og skriv `akseptansetest/<testplan-slug>/testplan.md`:

- «Hva er levert» med vanlige ord, fra brukerhistoriene og `utforing.md`.
- «Testbrukere» med tilgangsmatrisen, og «Testdata» med vurderingen per krav (hva som opprettes, manuelt eller API, opprydding, om testen kan kjøres på nytt).
- «Omfang» per gruppe (oppgave, kapabilitetsmappe eller filene), med lenke til hvert krav på GitHub (på commiten), Feature-ID, status og antall scenarioer som testes. Bare krav som er `@implemented` eller delvis levert, står her. Et krav som er delvis levert, har status «`@in-progress` (delvis levert)», og antallet er scenarioene i de leverte delene. Har et scenario eller en regel i testen `@openquestion`, står spørsmålet under tabellen (*Åpne spørsmål* i `krav-fra-testplan.md`), og «Åpne spørsmål» viser antall regler og scenarioer med åpent spørsmål per krav.
- «Regler uten scenario» fra verify-rapporten, og for hver regel om den testes i fase 2 og om kravet bør få et scenario (`fs-krav`).
- «Flyter»: én underseksjon per flyt, med om hele flyten eller deler av den testes og hvorfor, og én rad per fase, med kravene fasen bygger på (status, og delen fasen bygger på når den har anker eller «…»), om fasen er levert og i leveransen, og antall scenarioer som testes. Uten flyter: «Ingen av kravene er med i en flyt.» Under flytene: «Vurdering per krav (fase 3)» og «Avhengighetskart».
- «Venter på verifisering»: krav og deler som er `@in-progress`, eller `@planned`-deler i leverte krav som endres, med det verify-rapporten sier mangler.
- «Ikke med i denne testen» med grunnen fra `krav-fra-testplan.md`, også fasene og overleveringene i flytene som ikke testes.
- «Forutsetninger»: et `# Kjent brudd:` i en flyt blir en egen rad.
- Forutsetning 5 fylles ut fra verify-rapporten. Forutsetning 8 (CDP-agenten og nøklene) er alltid med.
- «Kriterier for godkjent»: kriteriene per fase fra malen, og plass til leveransespesifikke kriterier som testansvarlig fyller ut.
- «Status i flyten»: 1. Verifisering er verify-rapporten (fila, og siden i Confluence når den finnes), «Alt funnet» eller «<N> ikke funnet, <N> usikker», og datoen i rapporten. Uten rapport: «Ikke kjørt». «Testplan» er «Laget». 2. Agentisk funksjonstest og 3. Intern akseptansetest er «Venter». Er leveransen ikke til ekstern test, er 4. Ekstern akseptansetest «Ikke aktuell», ellers «Venter».
- «Sporbarhet per krav» med én rad per scenario i testen. Kolonnen for kode (fase 1) fylles ut fra verify-rapporten, resten står tom: de andre skillene og rapportene fyller dem.
- «Funn og alvorlighetsgrad» og «Beslutning» ordrett fra `alvorlighetsgrad.md`.

## 5. Vis fram og publiser

1. Vis en kort oppsummering: antall krav og scenarioer som testes per gruppe, antall regler og scenarioer med åpne spørsmål, regler uten scenario, flytene (hele eller deler, og antall overleveringer), testdata (hva som opprettes manuelt og hva som seedes via API), det som venter på verifisering, det som ikke er med, og det som må fylles ut.
2. Spør om testplanen skal opprettes i Confluence (`confluence.md`, *Før du skriver*). Siden legges alltid under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner) (`5126062121`), og skillen spør ikke om foreldresiden.
3. Skriv lenken i metadataene (`- **Confluence**:`).
4. **Verifiseringen som underside.** Er testplanen opprettet, og har verify-rapporten ingen `- **Confluence:**`, spør om den skal legges som underside til testplanen, med de samme valgene. Lag undersiden som i *Confluence* i `fs-verify` (steg 3 og 5): tittelen «Verifisering – <leveranse> – <YYYY-MM-DD HH:MM>» med tidspunktet i rapporten, og lenken i metadataene i rapportfila. Oppdater lenken i raden «1. Verifisering» i «Status i flyten», på siden og i `testplan.md`. Er det flere rapporter, blir hver en underside.
5. Si hva som er neste steg: `fs-testrapport` (verifisering) med testplanen, og så `fs-testcaser-cdp` for de agentiske testcasene (fase 2). Venter noe på verifisering, kjøres `fs-verify` på nytt med testplanen (`akseptansetest/<slug>`) når teamet har levert det, og den oppdaterer raden «1. Verifisering».

## Hva skillen ikke gjør

- Endrer ikke kravene, taggene, scope-fila eller `oppgave.md`.
- Lager ikke testcasene (`fs-testcaser-cdp` for fase 2, `fs-testcaser-intern` for fase 3, `fs-testcaser-ekstern` for fase 4) eller rapportene (`fs-testrapport`).
- Seeder ikke testdata og kjører ikke API-kall. Den planlegger hva som må opprettes og hvordan.
- Oppretter ikke Jira-saker, Slack-tråder eller avtaler i testkalenderen. Den foreslår teksten.
- Kjører aldri git add/commit/push.
