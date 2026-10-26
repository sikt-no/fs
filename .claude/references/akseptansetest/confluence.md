# Confluence i testflyten

Felles for `fs-testplan`, `fs-testcaser-cdp`, `fs-testcaser-intern`, `fs-testcaser-ekstern`, `fs-testrapport` og Confluence-steget i `fs-verify`. Testplanen er hovedsiden for en leveranse, og alle de andre sidene er undersider til den. Verifiseringen kommer før testplanen, så undersiden «Verifisering – …» lages av `fs-testplan` når testplanen opprettes, og av `fs-verify` når den kjøres på nytt med en testplan som finnes.

## Verktøy

Bruk Atlassian-MCP-en som finnes i økta. Navnet avhenger av oppsettet, f.eks. `mcp__claude_ai_Atlassian_Rovo__*` (claude.ai-koblingen, også i FS Kravforvaltning). Du trenger:

- `getConfluencePage`: les en side, med `contentFormat: "html"` når du skal endre den, og `"markdown"` når du bare leser
- `getConfluencePageDescendants`: finn undersidene
- `createConfluencePage` og `updateConfluencePage`
- `getContentFormatGuide` (`toolName: "createConfluencePage"` eller `"updateConfluencePage"`), før du skriver HTML

`cloudId` er `sikt.atlassian.net`, og rommet er `STUDIEADM`. Finnes ingen Atlassian-MCP, eller er den ikke logget inn, si det. Fila i repoet er da resultatet, og brukeren kan kopiere innholdet selv.

## Sidetreet

```
Testplaner (5126062121)
└── Testplan – <leveranse>                                  ← fs-testplan
    ├── Verifisering – <leveranse> – <YYYY-MM-DD HH:MM>     ← fs-testplan (første), fs-verify (på nytt)
    ├── Testrapport – verifisering – <leveranse>            ← fs-testrapport (fase 1)
    ├── Testrapport – agentisk funksjonstest – <leveranse>  ← fs-testrapport (fase 2)
    ├── Intern akseptansetest – <leveranse>                 ← fs-testcaser-intern (fase 3)
    ├── Testrapport – intern akseptansetest – <leveranse>   ← fs-testrapport (fase 3)
    ├── Ekstern akseptansetest – <leveranse>                ← fs-testcaser-ekstern (fase 4)
    ├── Flytbeskrivelser til partene – <leveranse>          ← fs-testcaser-ekstern (fase 4, valgfri)
    └── Testrapport – ekstern akseptansetest – <leveranse>  ← fs-testrapport (fase 4)
```

- **Testcasene i fase 2** ligger i repoet (`cdp-tester/`, Gherkin), og har ingen egen side. Resultatene fra kjøringen (`akseptansetest/<slug>/kjoring-<dato>/resultat.md`) står i «Testrapport – agentisk funksjonstest», med testcasene, teknikken, resultatet og funnene. Bildene ligger lokalt, ikke i git, og legges ikke i Confluence uten at brukeren ber om det.
- **Flytbeskrivelser til partene** er flytene fra den interne testen, uten tekniske ord, og rapportene fra fase 2 og 3, slik at partene ser hva som er testet. Siden lages bare når brukeren sier ja, og bare for leveranser som er godkjent internt.

- **Foreldresiden til testplanen** er alltid [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner) (`5126062121`, rommet `STUDIEADM`). Spør ikke om foreldresiden. Alle de andre sidene er undersider til testplanen.
- **Titlene** må være unike i rommet. Finnes tittelen fra før (et nytt testløp av samme leveranse), legg til datoen: `Intern akseptansetest – <leveranse> – <YYYY-MM-DD>`.
- **Finnes siden fra før?** Se etter samme tittel i `getConfluencePageDescendants` på testplanen. Finnes den, er det en oppdatering, ikke en ny side.

## Finn testplanen

Skillene etter `fs-testplan`, og `fs-verify` når den skal legge resultatet i Confluence, starter med testplanen:

1. Oppga brukeren en testplan (`akseptansetest/<slug>`, eller `testplan.md` i den), bruk den.
2. Oppga brukeren et scope, en oppgave, en mappe eller en feature-fil: `Grep` etter den (`@scope-<slug>`, `tasks/<domene>/<slug>`, `krav/<sti>`) i `- **Kilde**:` i `akseptansetest/*/testplan.md`. For en feature-fil: søk også etter Feature-ID-en i «Omfang». Ett treff er testplanen. Flere treff: spør hvilken.
3. Oppga brukeren en Confluence-URL, les siden. Lenken til fila står ikke på siden, så finn fila med samme `- **Confluence**:`.
4. Ellers: spør. Finnes ingen testplan, tilby å kjøre `fs-testplan` først.

Siden i Confluence står i `- **Confluence**:` i metadataene i `testplan.md`.

## Før du skriver

Spør alltid med `AskUserQuestion`, med tittelen og foreldresiden i spørsmålet:

- «Opprett som utkast» (anbefalt: teamet ser over før lenken deles, `status: "draft"`)
- «Publiser»
- «Ikke publiser»

Ved oppdatering: vis hva som endres, og spør.

## Fra fila til siden

- Ta bare det som står under den første streken (`---`). Metadataene øverst er for repoet.
- Skriv HTML etter `getContentFormatGuide`. Steg i en tabellcelle blir en nummerert liste (`<td><ol><li>…</li></ol></td>`), ikke `<br>`. Punkter (`- …`) i en celle blir en punktliste.
- Alle tabeller får full bredde (`<table data-layout="full-width">`). Testcasetabellene får faste kolonnebredder med `data-colwidth` på hver celle, så stegene får plass: «Nr» 60, «Scenario» 220, «Steg» 520, «Forventet resultat» 300, «Faktisk resultat» 260, «Status» 120. To-kolonnetabeller (Felt / Innhold): 220 og 1590.
- Lenker til krav i repoet blir lenker til GitHub: `https://github.com/sikt-no/fs/blob/<commit>/<sti>`, med mellomrom som `%20`.
- Felt som skal fylles ut (`[Fylles ut …]`, `[Sjekk begrep]`), får gul bakgrunn i cella (`data-background="#FFF0B3"`), så de ikke blir glemt.
- Lag ikke `@`-omtaler av personer (`data-type="mention"`) uten en ekte konto-ID. Skriv navnet som tekst.

## Strategien

Strategien står i Confluence: [Teststrategi for FS – fra krav til akseptanse (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326) (`5145100326`). Forslaget skal skrives over den gamle siden (`5117902850`). Inntil det er gjort er `5145100326` ID-en skillene bruker, og etterpå er det `5117902850` igjen. Skal ID-en byttes, søk etter den i hele repoet (`grep -rn 5145100326 .`).

## Oppdatere en side som finnes

1. Les siden med `contentFormat: "html"`.
2. Finn det testerne og testansvarlig har fylt ut: cellene i «Faktisk resultat» og «Status», radene i «Funn» (med «Fase» og «Type») og «Andre funn», «Beslutning», «Kriterier for godkjent», «Kontrollert av» og «Bekreftet av deltakerne». Er noe av det fylt ut, skriv det aldri over. Endre bare de andre delene, og behold det som er fylt ut, ord for ord.
3. Behold `data-colwidth`, `data-local-id` og inline-kommentarer (`class="annotation"`) slik de er.
4. Er testen i gang (noe er fylt ut), og en testcase må endres, si det til brukeren først. Steg testeren allerede har fulgt, endres ikke. Legg heller til en merknad i raden.
5. Skriv en `versionMessage` som sier hva som er endret.

## «Status i flyten» på testplanen

Testplanen har en tabell med fasene. `fs-testplan` fyller ut raden for verifiseringen og raden «Testplan» når testplanen lages. Den eneste delen av testplanen de andre skillene endrer, er sin egen rad i den tabellen (og «Sporbarhet per krav» og funnene, som `fs-testrapport` og testerne fyller ut):

| Fase | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | <lenke> | Alt funnet / <N> ikke funnet, <N> usikker / Ikke kjørt | <dato> |
| 1. Testrapport – verifisering | <lenke> | Klar / Ikke klar for agentisk funksjonstest | <dato> |
| Testplan | (denne siden) | Laget | <dato> |
| 2. Agentisk funksjonstest – testcaser (`fs-testcaser-cdp`) | `cdp-tester/<sti>` | Ikke laget / Laget / Oppdatert | <dato> |
| 2. Agentisk funksjonstest – kjøring | `kjoring-<dato>/resultat.md` | Venter / Kjørt / Kjørt med funn | <dato> |
| 2. Testrapport – agentisk funksjonstest | <lenke> | Klar / Ikke klar for intern akseptansetest / Venter på gjennomgang | <dato> |
| 3. Intern akseptansetest | <lenke> | Klar til test / Pågår / Ferdig | <dato> |
| 3. Testrapport – intern | <lenke> | Godkjent / Godkjent med forbehold / Ikke godkjent / Venter på beslutning | <dato> |
| 4. Ekstern akseptansetest | <lenke> | Klar til test / Pågår / Ferdig / Ikke aktuell | <dato> |
| 4. Testrapport – ekstern | <lenke> | Akseptert / Ikke akseptert / Venter på bekreftelse | <dato> |

Les testplanen med `contentFormat: "html"`, bytt bare cellene i raden, og oppdater siden med en `versionMessage` («Status i flyten: <steg>»). Oppdater også raden i `testplan.md`. Spør ikke en gang til om raden, når brukeren allerede har sagt ja til å publisere undersiden.

## Etter publisering

- Skriv lenken i metadataene i fila: `- **Confluence**: <url>`, og `<url> (utkast)` for et utkast.
- Foreslå teksten til Slack-tråden «Akseptansetesting <leveranse>» med lenken, når siden er en testside (fase 3 eller 4). Skillen poster ikke selv.
