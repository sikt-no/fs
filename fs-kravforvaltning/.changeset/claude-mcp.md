---
"krav-viewer": minor
---

Claude-panelet kan bruke Figma- og chrome-devtools-MCP-ene du har satt opp i Claude Code, også når de er lagt til i en annen mappe, og Atlassian-koblingen (Rovo) på claude.ai-kontoen din. Før Claude bruker et MCP-verktøy eller henter fra nettet, spør panelet om lov med «Tillat», «Tillat alltid i denne samtalen» og «Avvis». Verktøy som bare leser (som `get_metadata` og `get_screenshot` i Figma), spørres ikke om. Er en server ikke logget inn, sier panelet at du må kjøre `/mcp` i terminalen. Skjermbilder fra Figma kan lagres som PNG under `spec/krav-input/sketches/`, og fs-verify kan ta skjermbilder av appen med chrome-devtools og lagre dem under `spec/verify-<dato>/`. Bildene kan sendes med «Lag PR». PR-forslaget fra Claude tar også med filene fs-specify og fs-verify skriver i oppgavemappa (`tasks/<domene>/<slug>/spec/` og `utforing.md`), ikke bare kravene.
