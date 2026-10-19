# Confluence

Testdokumentene publiseres i Confluence, der testerne fyller dem ut. Fila i `tester/` er utkastet og kilden fram til testen starter. Etter det er siden kilden for resultatene.

## Verktøy

Bruk Atlassian-MCP-en som finnes i økta. Navnet på verktøyene avhenger av oppsettet, f.eks. `mcp__claude_ai_Atlassian_Rovo__*` (claude.ai-koblingen, også i FS Kravforvaltning) eller `mcp__Atlassian_Jira_og_Confluence__*`. Du trenger:

- `getConfluencePage` (les en side, `contentFormat: "html"` når du skal endre den, `"markdown"` når du bare leser)
- `getConfluencePageDescendants` (finn undersider)
- `createConfluencePage` og `updateConfluencePage`
- `getContentFormatGuide` (`toolName: "createConfluencePage"` eller `"updateConfluencePage"`), før du skriver HTML

`cloudId` er `sikt.atlassian.net`. Finnes ingen Atlassian-MCP, eller er den ikke logget inn, si det, og la brukeren kopiere innholdet selv.

## Hvor sidene står

Standard, med mindre brukeren sier noe annet:

| Side | Foreldreside | Tittel |
|---|---|---|
| Intern akseptansetest | [Kvalitetssikring og akseptansetesting](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5091196953) (`5091196953`, rommet `STUDIEADM`) | `Intern akseptansetest – <navn>` |
| Ekstern akseptansetest | Den interne testen for saken | `Ekstern akseptansetest – <navn>` |
| Kvalitetssikring i teamet | Publiseres ikke som standard. Vil teamet ha den i Confluence, under den interne testen | `Kvalitetssikring i teamet – <navn>` |

Finn ut om siden finnes fra før: `getConfluencePageDescendants` på foreldresiden, og se etter samme tittel eller samme sak. Finnes den, er det en oppdatering, ikke en ny side.

## Før du skriver

Spør med `AskUserQuestion`, med tittelen og foreldresiden i spørsmålet:

- «Opprett som utkast» (anbefalt: teamet ser over før testerne får lenken, `status: "draft"`)
- «Publiser»
- «Ikke publiser»

Ved oppdatering: vis hva som endres, og spør.

## Fra fila til siden

- Ta bare det som står under den første streken (`---`). Metadataene øverst er for repoet.
- Skriv HTML etter `getContentFormatGuide`. Stegene i en tabellcelle blir en nummerert liste (`<td><ol><li>Gå til …</li><li>…</li></ol></td>`), ikke `<br>`. Punkter (`- …`) i en celle blir en punktliste.
- Alle tabeller får full bredde (`<table data-layout="full-width">`). Testtabellene får faste kolonnebredder med `data-colwidth` på hver celle, så stegene får plass: «#» 60, «Testbruker» 170, «Scenario» / «Hva du tester» 200, «Testdata» 260, «Steg» 520, «Forventet resultat» 280, «Faktisk resultat» 240, «Bestått?» 80. To-kolonnetabeller (Felt / Innhold): 220 og 1590.
- Lenker til krav i repoet blir lenker til GitHub (`https://github.com/sikt-no/fs/blob/main/<sti>`, med mellomrom som `%20`).
- Felt som skal fylles ut av teamet (`[Fylles ut …]`, `[Sjekk begrep]`), markeres med gul bakgrunn i cella (`data-background="#FFF0B3"`), så de ikke blir glemt.
- Lag ikke `@`-omtaler av personer (`data-type="mention"`) uten en ekte konto-ID. Skriv navnet som tekst.

## Oppdatere en side som finnes

1. Les siden med `contentFormat: "html"`.
2. Finn det testerne har fylt ut: cellene i «Faktisk resultat» og «Bestått?», radene i «Funn» og «Andre funn og erfaringer», «Beslutning», «Konklusjon», «Svar» i åpne spørsmål og «Læring». Er noe av det fylt ut, skriv det aldri over. Endre bare de andre delene, og behold det som er fylt ut, ord for ord.
3. Behold `data-colwidth`, `data-local-id` og inline-kommentarer (`class="annotation"`) slik de er.
4. Er testen i gang (noe er fylt ut), og et testtilfelle må endres, si det til brukeren først. Stegene testeren allerede har fulgt, endres ikke. Legg heller til en merknad i raden.
5. Skriv en `versionMessage` som sier hva som er endret.

## Etter publisering

- Skriv lenken i metadataene i fila: `- **Confluence**: <url>` (utkast: `<url> (utkast)`).
- Foreslå teksten til Slack-tråden «Akseptansetesting <navn>» med lenken. Skillen poster ikke selv.
