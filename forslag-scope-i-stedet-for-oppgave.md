# Forslag: oppgave og scope slås sammen til scope

Status: forslag til diskusjon, oktober 2026. Tallene er fra `main` 30. oktober 2026.

## Bakgrunn

I dag er det to begreper. Et **scope** er planen for et initiativ: mål, ikke-mål, kilder og hvilke krav som hører til. Det står i `tasks/<dom>/scope-<slug>.md`, og kravene har taggen `@scope-<slug>`. En **oppgave** er en mappe med `oppgave.md`, som svarer til én Jira-sak. Der ligger arbeidet: `spec/`, `utforing.md` og verify-rapportene.

Ordet «oppgave» får det til å høres ut som om arbeidet starter når scopet skrives, men det som skjer da, er at omfanget defineres. Slik er det i praksis i dag:

- 7 av 13 scopes har bare én oppgave, og 6 har to. Ingen har flere enn to.
- 3 oppgaver har ikke noe scope: `registrere-praksis`, `utdanningstilbud` og `studieprogram`. To til, `vedtaksformidling` og `tidlig-opptak`, står i en scope-tabell, men har ikke `Scope:` i `oppgave.md`.

**Forslaget:** Oppgave og scope blir ett begrep: **scope**. Et scope er én mappe, og kan ha én eller flere Jira-saker. Ordet «oppgave» som begrep forsvinner fra repoet.

## Ny modell

```
tasks/<domene>/<slug>/          # slug = scope-slugen = taggen @scope-<slug>
├── scope.md                    # erstatter scope-<slug>.md + oppgave.md
├── spec/  utforing.md  reviews/  design.md  memory.md  <lag>/   # som før
```

`scope.md` (ny mal i `tasks/mal/scope.md`, og `tasks/mal/oppgave.md` slettes):

- **Metadata:**
  - Slug, Domene, Initiativ og Eier
  - **Jira:** en liste med én eller flere saker
  - Siste oppdatering
- `## Mål`, `## Ikke-mål`, `## Kilder`
- `## Krav`: tabellen `| Krav | MoSCoW | Skisse | Jira | Kommentar |`. Kolonnen «Oppgave» forsvinner. «Jira» sier hvilken sak kravet hører til, når scopet har flere saker. Krav som er utsatt, får MoSCoW `Won't` eller en kommentar, i stedet for raden «(ikke tildelt)».
- `## Åpne spørsmål`
- `## Statuslogg` (append-only, som i dag)

Dette beholdes:
- **Taggen `@scope-<slug>`**, så ingen krav må retagges når scopet beholder slugen.
- **Mappestrukturen `tasks/<dom>/<slug>/`**, fordi BAT-pluginene (`artifact-coord`, `bat-*`) leser den.
- **Navnet på mappa `tasks/`.**
- **Regelen om at slugen er unik på tvers av domener.**

## Plan for endringen

Alt gjøres i én PR, på en egen branch. Appen og dataene må endres samtidig, ellers blir tavla tom.

### 1. Migrere dataene i `tasks/`

Alle flyttinger gjøres med `git mv`, så historikken følges.

- **Scope med én oppgave:** oppgavemappa får navnet til scope-slugen, for eksempel `opprette-og-vedlikeholde-opptak/` → `opprette-opptak-2027/`. `scope-<slug>.md` og `oppgave.md` slås sammen til `scope.md`. Statusloggen fra `oppgave.md` og Jira-saken blir med.
- **Scope med to oppgaver** (`restanser-etter-onboarding`, `synlighet-og-gjelder-for`, `utdanningstilbud-2027`, `utdanningstilbud-i-opptak-2027`, `tilbudsgaranti-2027` og `plasstildeling-2027`):
  - Begge mappene flyttes inn i scope-mappa.
  - `spec/` og `<lag>/` slås sammen. Har to filer samme navn, for eksempel `spec.log.md`, skrives de etter hverandre i dato-rekkefølge.
  - Begge Jira-sakene står i `Jira`, og hver krav-rad får saken sin.
- **Oppgaver uten scope** (`registrere-praksis`, `utdanningstilbud`, `studieprogram`):
  - De blir egne scopes med samme slug. `oppgave.md` blir `scope.md`, og «Kort beskrivelse» blir `## Mål`.
  - Krav-tabellen bygges fra `## Krav` i spesifikasjonen, eller fra lenken under «Krav (Gherkin)».
  - Kravene får `@scope-<slug>`, men bare der de ikke har et annet scope fra før. Ellers spørres brukeren.
- **Lenker i filene:**
  - Linja `- **Oppgave:** \`tasks/…/\`` i `spec/spec-*.md` blir `- **Scope:**`, med den nye stien.
  - Lenker til gamle stier oppdateres i `utforing.md`, i testplanene i `akseptansetest/*/` og i `tasks/<dom>/README.md`.
  - Rapporter og logger som allerede er skrevet (`verify-*.md`, `spec.log.md` og `questions-*.md`), endres ikke. De er historikk.
- **Til slutt:** `grep` etter `oppgave.md` og etter de gamle mappenavnene i hele repoet.

### 2. FS Kravforvaltning (`fs-kravforvaltning/`)

Typenavnene i koden (`Task`, `TaskCard` og `buildTasks`) kan beholdes. Det er det brukeren ser, og det som leses fra disk, som endres.

- **`shared/tasks.ts`:**
  - `parseTask` leser `scope.md` i stedet for `oppgave.md`.
  - `Scope` og `Task` slås sammen. `Task` får mål, krav-radene og `jira: IssueRef[]`.
  - `parseScope` og `SCOPE_FILE` (`scope-*.md` på domenenivå) fjernes.
  - `newOppgaveText` blir `newScopeText`.
- **Sjekkene i `taskLint` og `scopeLint`** (`shared/tasks.ts`):
  - Sjekken `oppgave` blir «scope.md mangler».
  - Disse fjernes: «scope-X finnes ikke», «scope i annet domene», «står ikke i scope-X» og «Oppgaven X finnes ikke».
  - Disse beholdes: sjekkene av slug og domene, at slugen er unik på tvers av domener, og regel 1–4.
  - Tekstene «oppgave-rota» og «Oppgavemappe under mal/» endres til «scope-rota» og «Scope-mappe».
- **`src/scope.ts` (`kravFor` og `scopeLinks`):**
  - Rekkefølgen for hvor kravene leses fra, blir rader i `scope.md` → spesifikasjonen. Fallbacken `'lenke'` («Krav (Gherkin)») fjernes.
  - `scopeLinks` sjekker de samme radene mot taggen.
- **`src/specboard.ts`:**
  - `buildTaskCards` lager ett kort per scope-mappe.
  - Kolonnen `scope` med etiketten «I scope» får etiketten «Avgrenset», fordi alt nå er et scope.
  - Teksten i `kravPrompt`, `taskSpecifyPrompt` og `handoffPrompt` endres fra «oppgaven» til «scopet».
- **Teksten i grensesnittet:**
  - Filene: `src/Tavle.tsx`, `TopBar.tsx`, `TaskDetail.tsx`, `SpecDetail.tsx`, `TaskBackBar.tsx`, `main.tsx` (`MODE_LABEL`) og `ClaudePanel.tsx`.
  - Endringene: «Oppgaver» blir «Scopes», «+ Ny oppgave» blir «+ Nytt scope», «Tilbake til oppgaven» blir «Tilbake til scopet», og «Ingen oppgaver» blir «Ingen scopes».
  - Skjemaet for nytt scope ber om slug, tittel, mål og Jira-saker.
  - `TaskDetail.tsx:352` får en ny fs-scope-prompt.
- **Stiene i kode som skriver eller gir tilgang:**
  - `shared/paths.ts` (`isSpecPath`), `core/save.ts` (hvitelisten og feilteksten), `server/tasks.ts` (`withSource`) og `shared/spec.ts:359` («Oppgave:» blir «Scope:»).
  - Tilgangene og tekstene om «oppgavemappa» i `core/claude.ts` og `core/pty.ts`, og teksten i `src/prProposal.ts`.
  - «oppgavelista» i `pty.ts:69` er agent-teamets oppgaveliste, og beholdes.
- **Hash-ruter** (`src/tavleHash.ts`):
  - De nye rutene er `#/scopes`, `#/scopes/<dom>/<slug>[/<spec>|/ny]` og `#/scopes/nytt-scope`.
  - `migrateHash` sender `#/oppgaver…` videre til de nye rutene, slik den gjør med de gamle rutene i dag.
  - Modusen `'oppgaver'` blir `'scopes'`, og `MENU_DEFAULT` og menyinnstillingene som er lagret, migreres.
- **Testene** (`shared/tasks.test.ts`, `src/specboard.test.ts`, `src/scope.test.ts`, `src/tavleHash.test.ts`, `core/*.test.ts`, `server/tasks.test.ts`, `src/prProposal.test.ts` og `shared/spec.test.ts`):
  - Fixturene og forventningene oppdateres til `scope.md`.
  - Nye tester: scope med flere Jira-saker, og videresending fra `#/oppgaver`.
- **Changeset og CHANGELOG** etter `fs-kravforvaltning/CLAUDE.md`, fordi brukerne merker endringen.

### 3. Konvensjonene (de autoritative dokumentene)

- **`tasks/README.md`:** struktur, *Scope*, *Fire regler* («oppgave-rota» blir «scope-rota»), *Utføring*, *Tavla*, *Forholdet til Jira og GitHub* («Ett scope har én eller flere Jira-saker») og *Maler*. Domenetabellen beholdes.
- **`tasks/mal/`:** ny `scope.md`, og `oppgave.md` slettes. I `plan.md`, `design.md` og `review.md` blir «oppgaven» til «scopet». Ordet «Arbeidsoppgaver» i `plan.md` beholdes.
- **`krav/README.md`:** *Scope*, *Kort fortalt*, og tabellen over livsløpet («hentet inn i en oppgave» blir «hentet inn i scopet»).
- **`CLAUDE.md`, `README.md` og `tasks/<dom>/README.md`.**
- **Reglene i `.claude/rules/`:** `tasks-conventions.md` og `krav-readme-parser-sync.md` (tavla «Scopes»).

### 4. Skillene og agentene

- **`fs-scope`** skrives om: «Opprette en oppgave» forsvinner, og modus A lager scope-mappa med `scope.md`.
  - Jira-sakene spørres om, og `jira-overlapp-sjekk` kjøres før en ny sak foreslås, som i dag.
  - I modus B blir «flytte krav mellom oppgaver» til «flytte krav mellom Jira-saker eller scopes», og «dele et scope» lager et nytt scope.
  - «Kontroll før du avslutter» oppdateres.
- **`fs-specify` og `fs-specify-delta`:**
  - «Hent inn i en oppgave» blir «hent inn i et scope», og spesifikasjonen skrives til `tasks/<dom>/<slug>/spec/`.
  - Uten scope foreslås `fs-scope`, eller det skrives en minimal `scope.md` i stedet for `oppgave.md`.
- **Inndata «oppgave» blir «scope»** i `fs-verify` (og `references/rapportmal.md`), `fs-verify-agent-teams` (globben `tasks/<dom>/*/oppgave.md` blir `*/scope.md`), `fs-testplan` (og `mal-testplan.md`), `fs-testcaser-cdp`, `fs-testrapport` (og `mal-rapport.md`), `fs-krav` og `.claude/references/akseptansetest/krav-fra-testplan.md`.
- **Generell bruk av ordet beholdes:**
  - «oppgave uten flyt» og «oppgaver i arbeidsprosessen» i `fs-testcaser-intern`, `fs-testcaser-ekstern` og `testcase-regler.md`. Det gjelder bare der ordet betyr en arbeidsoppgave i testen. «Oppgavene i scope-tabellen» (`fs-testcaser-intern:128` og `fs-testcaser-ekstern:62`) endres.
  - Agent-teamets oppgaveliste i `.claude/agents/fs-verify-krav.md` og `fs-verify-agent-teams`.
  - «Teamet lager oppgaver» i `alvorlighetsgrad.md`, og `jira-overlapp-sjekk`.
- **Beskrivelsene (description) i skillene**, og skill-oversikten i `CLAUDE.md`.

### 5. `kom-i-gang.html`

Regelen i `.claude/rules/kom-i-gang-sync.md` gjelder:
- I *Oversikt* og steg 1–6 blir begrepet «oppgave» til «scope».
- Det gjelder også eksempelstiene og tavla.
- Id-ene til stegene beholdes, så lenkene virker.
- Brukeren får vite hvilke steg som er endret.

### 6. Artefaktene (siste steg, etter at PR-en er ferdig)

Presentasjonene oppdateres med Artifact-verktøyet. Hvert lysbilde leses på nytt før det endres, fordi lysbildene også redigeres fra siden. Begrepet «oppgave» blir «scope», og stiene, skjermnavnene og skill-tekstene blir de samme som i PR-en.

- **[Slik jobber vi med krav](https://claude.ai/artifact/FLUQtvcNBjdeP6i7JG9CqF):**
  - **Side 2, «Prosessen»:** boksen *Scope* («Scope-fila og skjeletter») og *Spesifikasjon*.
  - **Livsløpet:** «Under arbeid: hentet inn i en oppgave» blir «hentet inn i scopet».
  - **Akseptansetesten og «Kom i gang»:** gå gjennom tekst og talenotat for «oppgave», og fjern ordet der det betyr begrepet.
- **[Krav – detaljert presentasjon](https://claude.ai/artifact/Sx4D8zmmWp8kz86Mqq88WY):**
  - **Side 2, «Prosessen»:** boksen *Scope*.
  - **Side 3, Scope:** h2 og «Gjør» og «Lager» skrives om. Scopet er mappa `tasks/<dom>/<slug>/` med `scope.md`, og har én eller flere Jira-saker. Talenotatet sier at ingen begynner å jobbe her.
  - **Side 5, Spesifikasjon:** «hentes inn i oppgaven» blir «hentes inn i scopet».
  - **Side 6, Utvikling:** teksten om tavla («Til verifisering»).
  - **Lysbildet «Scope og oppgaver · tasks/»:** mappetreet skrives om til `tasks/opptak/opprette-opptak-2027/scope.md` med `spec/`, og «Tavla utledes» oppdateres.
  - **Taggene og «Spesifikasjonen»:** `@scope-` kobler kravet til scopet.
  - **Lysbildet «Repoet»:** linja om `tasks/` endres til «én mappe per scope».
- **Til slutt:** les begge presentasjonene og søk etter «oppgave» i alle lysbilder og talenotater. Generell bruk av ordet, som i fase 3 og 4, beholdes.

### 7. Utenfor repoet

- **BAT-pluginene:** sjekk om `artifact-coord` eller `bat-*` leser `oppgave.md`. Strukturen `tasks/<dom>/<slug>/spec/` er den samme.

## Verifisering

- `cd fs-kravforvaltning && npm test && npm run build` skal gå grønt.
- `npm run dev`:
  - Tavla «Scopes» viser alle de migrerte scopene i riktig kolonne, med de samme kravene som før.
  - Avvikene for `tasks/` er tomme.
  - `#/oppgaver/opptak/opprette-og-vedlikeholde-opptak` sendes videre til `#/scopes/opptak/opprette-opptak-2027`.
  - «+ Nytt scope» lager `scope.md`.
- `grep -rni "oppgave" --include="*.md" --include="*.ts" --include="*.tsx" --include="*.html" .` skal bare finne bruken som er listet som generell. Ingen `oppgave.md` og ingen `scope-*.md` på domenenivå skal være igjen.
- `grep -rn "@scope-" krav/`: hver tag peker på en `tasks/*/<slug>/scope.md`, og hver krav-rad har taggen.
- Kjør `/fs-scope` modus C (status) på ett scope med én Jira-sak og ett med to, og se at oversikten stemmer.
- Se over `kom-i-gang.html` i nettleseren, i lys og mørk modus og på mobilbredde.
