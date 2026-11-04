# jira-overlapp-sjekk

Claude Code-skill som sjekker om en Jira-sak overlapper med åpne saker i Tind, Puff (Overdrevent overkomplisert, STEK), Shiitake, Shinkansen og BAT, før saken opprettes eller arbeidet starter. Den leser fra Jira via Atlassian-MCP-en, og trenger ingen API-nøkler.

## Krav

* Atlassian-MCP-en koblet til Claude Code (`mcp__claude_ai_Atlassian_Rovo__*`, eller plugin-varianten `atlassian@claude-plugins-official`), innlogget med Sikt-brukeren din.

## Bruk

Claude bruker skillen på egen hånd:

* før en ny Jira-sak opprettes, også fra `fs-scope` og `fs-specify`/`fs-specify-delta`
* før arbeid på en sak starter
* når du ber om det: «sjekk om det finnes noe tilsvarende som <sak>»

Du kan også be om å sjekke duplikater i et helt team: «hent alle sakene i teamet <navn> og sjekk etter duplikater». Det skjer bare når du ber om det.

Skillen er veiledning til Claude, ikke en teknisk sperre. Claude kan i prinsippet opprette en sak uten å ha kjørt den.

## Hva den gjør

Søker med JQL (de siste 90 dagene, med søkeord utledet fra saken) og sammenligner etter hva sakene leverer. Meldingen om en kollisjon har begge lenkene og én linje om hva begge leverer, uten råd, og saken opprettes ikke før du har svart. Den oppretter, endrer eller kommenterer aldri saker selv.
