# Teamvisningene

En teamvisning er én HTML-side som viser en fil fra kravarbeidet eller akseptansetesten, laget for at et team kan gå gjennom den sammen. Siden publiseres som artefakt i Claude, og legges ved siden av fila i repoet.

| Side | Fila den viser | Byggeskript |
| --- | --- | --- |
| Verifisering | `verify-*.md` fra `fs-verify` og `fs-verify-agent-teams` | `.claude/skills/fs-verify/references/teamvisning/bygg.mjs` |
| Testcasene i den interne testen | `testcaser-intern.md` fra `fs-testcaser-intern` | `.claude/skills/fs-testcaser-intern/references/teamvisning/bygg.mjs` |
| Testrapporten for den interne testen | `testrapport-intern-*.md` fra `fs-testrapport` | `.claude/skills/fs-testrapport/references/teamvisning/bygg.mjs` |

## Samme design hver gang

- **Designet** står bare i `stil.css` i denne mappa, og er felles for alle sidene: farger (lyst og mørkt tema), skrift, kort, tabeller, merkene ✓ ✗ ~ – og gruppene med farget hode.
- **Hver side** har sin `mal.html` ved siden av byggeskriptet, med oppsettet og skriptet for siden. Malene bruker stilarket, og `felles.js` (hjelpefunksjonene i nettleseren) for testsidene.
- **Byggeskriptet** leser markdown-fila (med `felles.mjs` for testsidene), og skriver `<fil>.html` ved siden av den. Skillene skriver aldri HTML-en selv, og endrer ikke en generert fil: den skrives over neste gang.

Kjør fra rota av repoet:

```bash
node <byggeskript> <fil.md>
```

## Publisere

Skillen publiserer HTML-fila med Artifact-verktøyet (`file_path` er HTML-fila, `icon` er `checklist`, og `description` er én setning om hva siden viser). Bygges siden på nytt i samme kjøring, publiseres den samme fila igjen, så lenken er den samme. Artefaktet er privat til brukeren deler det.

Uten Bash (Claude-panelet) kan siden ikke bygges: skillen sier fra, med kommandoen. Uten Artifact-verktøyet gir skillen stien til HTML-fila, som kan åpnes i nettleseren.

## Endre designet

Endres designet, gjøres det i `stil.css` (alle sidene) eller i `mal.html` for én side, aldri i en generert fil. Bygg alle sidene på nytt fra filene i `akseptansetest/` og sjekk dem i nettleseren, i lyst og mørkt tema og på mobilbredde. Endres formatet på en markdown-fil (malen i skillen), sjekkes byggeskriptet for den siden i samme endring.
