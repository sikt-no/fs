---
"krav-viewer": minor
---

Tavla «Oppgaver» heter nå «Scopes», og et scope er én mappe, `tasks/<domene>/<slug>/scope.md`, i stedet for `scope-<slug>.md` og en eller flere mapper med `oppgave.md`. Kortene, kravene og avvikene leses fra `scope.md`, og et scope kan ha flere Jira-saker. Kolonnen «I scope» heter «Avgrenset». «+ Ny oppgave» heter «+ Nytt scope», og ber om tittel, domene, mål, Jira-saker og eier. Lenker til `#/oppgaver/…` sendes videre til `#/scopes/…`, også til scopet en oppgave ble slått inn i, og valget i menyen er beholdt.
