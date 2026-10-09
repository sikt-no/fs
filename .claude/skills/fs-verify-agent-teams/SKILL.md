---
name: fs-verify-agent-teams
description: Kjører `fs-verify` med et agent team (Claude Code agent teams, `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), med to roller. Finnerne (agenttypen `fs-verify-krav`) leter i koden og gir bevis (`fil:linje`) per scenario, én per feature-fil (eller én per gruppe av filer), parallelt. Kontrollørene (agenttypen `fs-verify-kontroll`) sjekker hvert svar uavhengig: leser hvert `funnet`, og søker på nytt etter hvert `ikke funnet`. Tar det samme scopet som `fs-verify` (en spesifikasjon, en `krav/`-sti eller en oppgave `tasks/<domene>/<slug>`) og lokale kloner av kode-repoene. Lead-en avgjør der finner og kontrollør er uenige, spør brukeren, retagger `@in-progress` → `@implemented`, fjerner `@in-progress` fra deler, sletter `@deprecated`-krav når koden er borte, og skriver rapporten i samme format som `fs-verify`, eventuelt med hva som gjenstår i hvert repo (fs-plattform, fs-admin og min-kompetanse). Bare i en interaktiv økt (terminalen, også terminalen i FS Kravforvaltning), ikke i Claude-panelet. Kjører aldri git add/commit/push. Trigges av "verifiser kravene med agent team", "fs-verify med agent teams", "fs-verify parallelt", "verifiser mange krav samtidig", "fs-verify-agent-teams".
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, AskUserQuestion, Agent, SendMessage, TaskCreate, TaskList, TaskGet, TaskUpdate
---

# Verify med agent team

## Task

$ARGUMENTS

## Din rolle

Du er lead i et agent team, og gjør det samme som `fs-verify`, men lar teammates gjøre letingen og kontrollen, parallelt. Reglene står i [`fs-verify/SKILL.md`](../fs-verify/SKILL.md), og gjelder uendret, også *Negative søk* og *Kontroll*. Les den før du starter. Denne skillen sier bare hvordan arbeidet deles.

- **Finnerne** (agenttypen `fs-verify-krav`, `.claude/agents/fs-verify-krav.md`) leser feature-filene sine, leter i koden og gir bevis.
- **Kontrollørene** (agenttypen `fs-verify-kontroll`, `.claude/agents/fs-verify-kontroll.md`) får svaret fra en finner for én feature-fil, og sjekker det mot koden uten å vite hvordan finneren lette.
- **Du** klassifiserer, starter teamet, sender hvert svar til kontroll, avgjør der finner og kontrollør er uenige, spør brukeren, retagger, sletter, skriver rapport og logg, og rydder opp i teamet.
- Teammatene endrer ingen filer og spør ikke brukeren. De samme forbudene som i `fs-verify` gjelder alle: ikke skriv eller rett applikasjonskode, ikke endre kravinnhold, ingen `git add`/`commit`/`push`/`checkout`/`stash`.

Du leser ikke all koden selv. Med mange filer har du ikke plass til det, og det er grunnen til at kontrollen er en egen rolle. Du leser koden der finner og kontrollør er uenige, og det du viser brukeren som grunnlag for en retagging eller sletting.

## Forutsetninger (gjør dette FØRST)

1. **Agent teams må være på.** Sjekk at team-verktøyene (`SendMessage`, `TaskCreate`, `TaskList`, `TaskUpdate`) finnes i økten, og/eller `echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`. Er de ikke det, si at agent teams slås på med

   ```json
   { "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
   ```

   i `~/.claude/settings.json`, og at Claude Code må startes på nytt. Tilby å kjøre vanlig `fs-verify` i stedet, og stopp. Finnes `Agent` og `SendMessage`, men ikke `TaskCreate`, kan teamet startes uten oppgaveliste: se *Start teamet*.
2. **Ikke i Claude-panelet i FS Kravforvaltning.** Panelet kjører `claude -p` og avviser Agent, så teams virker ikke der. Henvis til `fs-verify` (der kontrollen er manuell), eller til «I terminal med agent team» ved «Verifiser» i FS Kravforvaltning, og stopp. Terminalen i FS Kravforvaltning er en interaktiv økt med agent teams slått på, og der virker skillen.

## Finn scope og kode

Som *Finn scope og kode* i `fs-verify`: kravene (spesifikasjon, `krav/`-sti eller oppgave, slått opp på feature-ID), kodeklonene (spør med `AskUserQuestion`, sjekk at stiene finnes), om det skal tas skjermbilder fra `https://test-fsadmin.sikt.no/` (spør med `AskUserQuestion` før teamet startes, når prompten ikke sier det) og hintene fra oppgaven (`design.md`, `<lag>/plan-*.md`, `<lag>/task-*-completion.md`). Ligger mappa i scope under et domene med en oppgave som handler om den (`tasks/<domene>/*/oppgave.md` som peker dit), les hintene derfra også.

Ber prompten om å verifisere en egenskap eller en regel *uansett status*, gjelder *Verifisere uansett status* i `fs-verify`: scope, gating-settet og hvilken ny status du kan tilby. Ber prompten om å verifisere en mappe *uansett status*, gjelder det samme for hver feature-fil i mappa.

**Per repo.** Ber brukeren om å få vite hva som gjenstår i hvert repo, eller er det mer enn én kodeklone og brukeren vil ha en oversikt over hva som gjenstår, skal finnerne vurdere hvert repo for seg (se *Start teamet*), og rapporten få `## Oversikt per krav` (variantene `[per repo]` i rapportmalen, se *Rapport*). Repoene og bokstavene står i *Kodeklonene* i `fs-verify`. Gi finnerne og kontrollørene tabellen over de repoene som er med.

Ta tidspunktet for kjøringen før teamet startes (*Tidspunkt* i `fs-verify`). Det gir navnet på rapporten (`verify-…-<YYYY-MM-DD>-<HHMM>.md`), `- **Dato:**` og mappa med skjermbilder, også om kjøringen tar lang tid.

Klonene ligger utenfor repoet, og teammatene arver permission mode fra deg. Kan ikke du lese klonene uten å bli spurt, kan ikke teammatene det heller. Foreslå da at brukeren starter med `--add-dir <klone>`, eller legger klonene i `permissions.additionalDirectories`.

## Logg kjøringen

Som *Logg kjøringen* i `fs-verify`, med skillnavnet `fs-verify-agent-teams`:

```
- 2026-10-07 — `fs-verify-agent-teams` started — 5 feature-filer, 4 @in-progress, 1 @deprecated, 5 finnere
- 2026-10-07 — `fs-verify-agent-teams` ended (success) — 3 retagget @implemented, 1 regel slettet, 1 fortsatt @in-progress, kontrollen endret 2 resultater
```

`AskUserQuestion`-kall logges til `<oppgave>/spec/questions-fs-verify-agent-teams-<YYYY-MM-DD>.md`.

## Klassifiser

Les hver feature-fil i scope selv, og klassifiser etter tabellen i *Klassifiser* i `fs-verify`. Vis oversikten før du starter teamet.

- Bare filer med noe å verifisere (`@in-progress` eller `@deprecated` på egenskapen eller på en del, eller alle filene i scope når det skal verifiseres *uansett status*) får en finner.
- Resten (allerede levert, `@draft`, `@planned`, to statustagger) rapporteres som i `fs-verify`, uten finner.
- **Én fil å verifisere:** ikke start et team. Følg `fs-verify` direkte (med kontrolløren som subagent).

## Start teamet

**Høyst 5 teammates samtidig**, finnere og kontrollører til sammen. Tell scenarioene i hver fil.

1. **Fordel filene.** Er det 5 filer eller færre, og finnes `TaskCreate`, får hver fil sin egen finner. Ellers grupperer du:
   - Gruppér etter kapabilitetsmappe, og del store mapper eller slå sammen små, så gruppene får omtrent like mange scenarioer.
   - Bruk 4 finnere, så det er plass til én kontrollør fra starten. Når finnerne er ferdige, går plassene til kontrollører.
   - Finnes ikke `TaskCreate`, gir du hver finner filene sine i spawn-prompten, i den rekkefølgen den skal ta dem.
2. **Én oppgave per feature-fil** med `TaskCreate` (når den finnes). Tittel: feature-ID og tittel. Beskrivelse: stien til fila, klassifiseringen, kodeklonene og hintene som gjelder fila (filstier, komponentnavn, GraphQL-felt, ruter).
3. **Start finnerne** med Agent-verktøyet og agenttypen `fs-verify-krav`. Navnet er feature-ID-en, eller et kort navn for gruppa (`utd-liste`). Teammates ser ikke samtalen din, så spawn-prompten har alt: filene (eller oppgavene på lista som er deres), modusen (f.eks. *uansett status* og gating-settet), kodeklonene, hintene, og om repoene skal vurderes hver for seg. Be dem sende svaret for hver fil så snart fila er ferdig, ikke alt til slutt.
4. **Start en kontrollør for hvert svar** fra en finner (én feature-fil), med agenttypen `fs-verify-kontroll` og navnet `kontroll-<feature-ID>`. Spawn-prompten har stien til feature-fila, kodeklonene og om repoene vurderes hver for seg, modusen, og resultattabellen fra finneren, med bevisene. Ikke send med resten av finnerens svar, og ikke hva du selv tror. Er det fullt (5 teammates), vent til en har stengt.

Vent på svarene. De kommer som meldinger; ikke poll oppgavelista i en løkke. Be teammates som er ferdige, om å stenge (`shutdown_request`), så plassen blir ledig.

## Samle og kontroller

**Svar fra en finner:**

1. **Sjekk formatet.** Mangler tabellen, scenarioer i gating-settet, bevis eller (når det er bedt om) repoene, be finneren rette det med `SendMessage`.
2. **Send det til kontroll** (*Start teamet*, steg 4).

**Svar fra en kontrollør:**

1. **`bekreftet`:** resultatet står.
2. **`avkreftet` eller `usikker`:** les det kontrolløren viser til, og det finneren viste til. Har kontrolløren rett, bruk det nye resultatet. Er det fortsatt uklart, blir resultatet `usikker`, med begge synene i beviset. Noter raden for `## Kontroll` i rapporten.
3. **Et `funnet` som kontrollen avkrefter, kan aldri brukes til retagging**, selv om du er enig med finneren. Da blir det `usikker`, og brukeren avgjør.

Før du viser et krav til brukeren for retagging eller sletting, les `fil:linje` for bevisene til det kravet selv. Du står ansvarlig for det du viser brukeren.

## Skjermbilder

Bare når brukeren har sagt ja (*Finn scope og kode*), og bare du tar dem, etter *Skjermbilder* i `fs-verify`. Det er én nettleser, så ikke la teammatene gjøre det. Ta dem etter at svarene er kontrollert, ett krav om gangen.

## Bekreft og endre

Ett krav om gangen, nøyaktig som i `fs-verify`, når det kontrollerte resultatet for kravet er klart:

- `@in-progress`: steg 4–6 i *Verifisere implementasjon* (vis resultatet og hva kontrollen endret, spør «Stemmer vurderingen …?», retagg bare når alt i gating-settet er `funnet` og brukeren svarte **Stemmer**).
- Deler i leverte krav: *Deler i leverte krav som endres* (fjern `@in-progress` fra delen).
- `@deprecated`: steg 3–5 i *Verifisere at koden er borte* (spør før sletting).
- *Uansett status*: spør bare om de kravene der hele gating-settet er `funnet`. For de andre blir statusen stående uansett, og resultatet står i rapporten.

Svarer brukeren **Avbryt**, stopp, skriv rapporten for det som er gjort, og rydd opp i teamet.

## Rapport

Som *Etter endringene* og *Rapport* i `fs-verify`, med samme filnavn, oppdatering av `utforing.md` og malen i [`fs-verify/references/rapportmal.md`](../fs-verify/references/rapportmal.md). Les malen før du skriver rapporten, og følg den nøyaktig. Med agent team gjelder alltid variantene merket `[agent team]` (linja `Team`), og når repoene er vurdert hver for seg (*Finn scope og kode*), også `[per repo]`: `## Oversikt per krav` og repoene først i `Bevis`. Tallene regnes ut fra `## Scenarioer` (se *Rapport* i `fs-verify`).

## Rydd opp

Når rapporten er skrevet (også etter **Avbryt** eller en feil): be hver teammate som ikke har stengt, om å stenge, og vent til de har stengt. Er alle stengt, rydd opp i teamet.

## Referanser

- **[`fs-verify`](../fs-verify/SKILL.md)** — alle reglene for verifisering, *Negative søk*, *Kontroll*, retagging, sletting og rapport.
- **[`fs-verify/references/rapportmal.md`](../fs-verify/references/rapportmal.md)** — malen for rapporten.
- **`.claude/agents/fs-verify-krav.md`** — finneren og svarformatet.
- **`.claude/agents/fs-verify-kontroll.md`** — kontrolløren og svarformatet.
- **`krav/README.md`** — statusaksen, *Delvis utkast*, *Avvikling* og *Endring av levert krav*.
- **[`tasks/README.md`](../../../tasks/README.md)** — oppgavestrukturen, `spec/` og *Utføring*.
