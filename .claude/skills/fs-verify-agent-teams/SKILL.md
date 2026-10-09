---
name: fs-verify-agent-teams
description: Kjører `fs-verify` med et agent team (Claude Code agent teams, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), med én teammate per feature-fil. Tar det samme scopet som `fs-verify` (en spesifikasjon, en `krav/`-sti eller en oppgave `tasks/<domene>/<slug>`) og lokale kloner av kode-repoene. Teammatene (agenttypen `fs-verify-krav`) leter i koden og gir bevis (`fil:linje`) per scenario, parallelt. Lead-en kontrollerer bevisene, spør brukeren, retagger `@in-progress` → `@implemented`, fjerner `@in-progress` fra deler, sletter `@deprecated`-krav når koden er borte, og skriver rapporten i samme format som `fs-verify`. Bare i en interaktiv økt (terminalen, også terminalen i FS Kravforvaltning), ikke i Claude-panelet. Kjører aldri git add/commit/push. Trigges av "verifiser kravene med agent team", "fs-verify med agent teams", "fs-verify parallelt", "verifiser mange krav samtidig", "fs-verify-agent-teams".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion, Agent, SendMessage, TaskCreate, TaskList, TaskGet, TaskUpdate
---

# Verify med agent team

## Task

$ARGUMENTS

## Din rolle

Du er lead i et agent team, og gjør det samme som `fs-verify`, men lar teammates lete i koden: én teammate per feature-fil, parallelt. Reglene står i [`fs-verify/SKILL.md`](../fs-verify/SKILL.md), og gjelder uendret. Les den før du starter. Denne skillen sier bare hvordan arbeidet deles.

- **Teammatene** (agenttypen `fs-verify-krav`, `.claude/agents/fs-verify-krav.md`) leser én feature-fil, leter i koden og gir bevis. De endrer ingen filer og spør ikke brukeren.
- **Du** klassifiserer, starter teamet, kontrollerer bevisene, spør brukeren, retagger, sletter, skriver rapport og logg, og rydder opp i teamet.
- De samme forbudene som i `fs-verify`: ikke skriv eller rett applikasjonskode, ikke endre kravinnhold, ingen `git add`/`commit`/`push`/`checkout`/`stash`.

## Forutsetninger (gjør dette FØRST)

1. **Agent teams må være på.** Sjekk at team-verktøyene (`SendMessage`, `TaskCreate`, `TaskList`, `TaskUpdate`) finnes i økten, og/eller `echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`. Er de ikke det, si at agent teams slås på med

   ```json
   { "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
   ```

   i `~/.claude/settings.json`, og at Claude Code må startes på nytt. Tilby å kjøre vanlig `fs-verify` i stedet, og stopp.
2. **Ikke i Claude-panelet i FS Kravforvaltning.** Panelet kjører `claude -p` og avviser Agent, så teams virker ikke der. Henvis til `fs-verify`, eller til «I terminal med agent team» ved «Verifiser» i FS Kravforvaltning, og stopp. Terminalen i FS Kravforvaltning er en interaktiv økt med agent teams slått på, og der virker skillen.

## Finn scope og kode

Som *Finn scope og kode* i `fs-verify`: kravene (spesifikasjon, `krav/`-sti eller oppgave, slått opp på feature-ID), kodeklonene (spør med `AskUserQuestion`, sjekk at stiene finnes), om det skal tas skjermbilder fra `https://test-fsadmin.sikt.no/` (spør med `AskUserQuestion` før teamet startes, når prompten ikke sier det) og hintene fra oppgaven (`design.md`, `<lag>/plan-*.md`, `<lag>/task-*-completion.md`).

Ber prompten om å verifisere en egenskap eller en regel *uansett status*, gjelder *Verifisere uansett status* i `fs-verify`: scope, gating-settet og hvilken ny status du kan tilby.

Klonene ligger utenfor repoet, og teammatene arver permission mode fra deg. Kan ikke du lese klonene uten å bli spurt, kan ikke teammatene det heller. Foreslå da at brukeren starter med `--add-dir <klone>`, eller legger klonene i `permissions.additionalDirectories`.

## Logg kjøringen

Som *Logg kjøringen* i `fs-verify`, med skillnavnet `fs-verify-agent-teams`:

```
- 2026-10-07 — `fs-verify-agent-teams` started — 5 feature-filer, 4 @in-progress, 1 @deprecated, 5 teammates
- 2026-10-07 — `fs-verify-agent-teams` ended (success) — 3 retagget @implemented, 1 regel slettet, 1 fortsatt @in-progress
```

`AskUserQuestion`-kall logges til `<oppgave>/spec/questions-fs-verify-agent-teams-<YYYY-MM-DD>.md`.

## Klassifiser

Les hver feature-fil i scope selv, og klassifiser etter tabellen i *Klassifiser* i `fs-verify`. Vis oversikten før du starter teamet.

- Bare filer med noe å verifisere (`@in-progress` eller `@deprecated` på egenskapen eller på en del) får en teammate.
- Resten (allerede levert, `@draft`, `@planned`, to statustagger) rapporteres som i `fs-verify`, uten teammate.
- **Én fil å verifisere:** ikke start et team. Følg `fs-verify` direkte.

## Start teamet

1. **Én oppgave per feature-fil** med `TaskCreate`. Tittel: feature-ID og tittel. Beskrivelse: stien til fila, klassifiseringen, kodeklonene og hintene som gjelder fila (filstier, komponentnavn, GraphQL-felt, ruter).
2. **Én teammate per fil** med Agent-verktøyet og agenttypen `fs-verify-krav`. Gi teammaten feature-ID-en som navn, og det samme som står i oppgaven i spawn-prompten (teammates ser ikke samtalen din), pluss hvilken oppgave på lista som er deres.
3. **Høyst 5 teammates samtidig.** Er det flere filer, be teammates som er ferdige, om å ta neste ledige oppgave på lista (`SendMessage`), eller start en ny når en er stengt.

Vent på svarene. De kommer som meldinger; ikke poll oppgavelista i en løkke.

## Samle og kontroller

Teammatene svarer i formatet i `fs-verify-krav.md`. For hvert svar:

1. **Sjekk formatet.** Mangler tabellen, scenarioer i gating-settet eller bevis, be teammaten rette det med `SendMessage`.
2. **Kontroller hvert `funnet`.** Les `fil:linje` selv. Gjør ikke koden det scenarioet beskriver, blir resultatet `usikker`, med hvorfor. Du står ansvarlig for det du viser brukeren.
3. **Kontroller `ingen spor funnet`** for `@deprecated`: se at søkeordene dekker feature-ID, scenariotitler, tekster fra `Så`-stegene og navn fra `design.md`/planer. Søk selv etter det som mangler.

## Skjermbilder

Bare når brukeren har sagt ja (*Finn scope og kode*), og bare du tar dem, etter *Skjermbilder* i `fs-verify`. Det er én nettleser, så ikke la teammatene gjøre det. Ta dem etter at svarene er samlet, ett krav om gangen.

## Bekreft og endre

Ett krav om gangen, nøyaktig som i `fs-verify`:

- `@in-progress`: steg 3–5 i *Verifisere implementasjon* (vis resultatet, spør «Stemmer vurderingen …?», retagg bare når alt i gating-settet er `funnet` og brukeren svarte **Stemmer**).
- Deler i leverte krav: *Deler i leverte krav som endres* (fjern `@in-progress` fra delen).
- `@deprecated`: steg 3–4 i *Verifisere at koden er borte* (spør før sletting).

Svarer brukeren **Avbryt**, stopp, skriv rapporten for det som er gjort, og rydd opp i teamet.

## Rapport

Som *Etter endringene* og *Rapport* i `fs-verify`, med samme filnavn, format og oppdatering av `utforing.md`, så Spesifikasjoner-visningen i FS Kravforvaltning leser resultatet. Legg til én linje i metadata-lista, etter `- **Kode:**`:

```markdown
- **Team:** 5 teammates (`fs-verify-krav`)
```

## Rydd opp

Når rapporten er skrevet (også etter **Avbryt** eller en feil): be hver teammate om å stenge, og vent til de har stengt. Er alle stengt, rydd opp i teamet.

## Referanser

- **[`fs-verify`](../fs-verify/SKILL.md)** — alle reglene for verifisering, retagging, sletting og rapport.
- **`.claude/agents/fs-verify-krav.md`** — teammate-rollen og svarformatet.
- **`krav/README.md`** — statusaksen, *Delvis utkast*, *Avvikling* og *Endring av levert krav*.
- **[`tasks/README.md`](../../../tasks/README.md)** — oppgavestrukturen, `spec/` og *Utføring*.
