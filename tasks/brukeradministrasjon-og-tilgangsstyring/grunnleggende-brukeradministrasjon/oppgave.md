# Grunnleggende brukeradministrasjon i FS Admin

## Metadata

- **Issue**: [sikt-no/fs#143](https://github.com/sikt-no/fs/issues/143)
- **Initiativ**: [#350 Brukeradministrasjon av FS Admin-brukere](https://github.com/sikt-no/fs/issues/350)
- **Domene**: brukeradministrasjon-og-tilgangsstyring
- **Slug**: grunnleggende-brukeradministrasjon
- **Fase**: utvikling
- **Prioritet**: Should
- **Type**: feature
- **Eier**: –
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lag/roller i bruk**: spec, frontend (subgraph planlagt)
- **Lenker**:
  - design: –
  - krav: [spec/spec-grunnleggende-brukeradministrasjon.md](spec/spec-grunnleggende-brukeradministrasjon.md)
  - analyse: [frontend/analysis-grunnleggende-brukeradministrasjon.md](frontend/analysis-grunnleggende-brukeradministrasjon.md)
  - plan: [frontend/plan-grunnleggende-brukeradministrasjon.md](frontend/plan-grunnleggende-brukeradministrasjon.md)
  - flyt: [flow.md](flow.md)
  - review: –
  - PRs: –
- **Krav (Gherkin)**: [`krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon`](../../../krav/07%20Brukeradministrasjon%20og%20tilgangsstyring/12%20Brukeradministrasjon/personbrukere/1%20-%20Grunnleggende%20brukeradministrasjon)

## Kort beskrivelse

Som systemeier har jeg behov for å tildele personer tilgang til FS Admin, slik at de som brukere kan utføre studieadministrative oppgaver for et lærested eller en opptaksinstans, eller utføre brukerstøtte og support til andre, på bakgrunn av tjenstelig behov.

Oppgaven dekker grunnleggende administrasjon av personbrukere: liste, detaljvisning, oppretting, redigering og tildeling av roller på organisasjons-scope.

## Statuslogg

| Dato       | Hendelse                                                        | Av          | Lenke til review |
|------------|-----------------------------------------------------------------|-------------|------------------|
| 2026-09-22 | Slått sammen med BAT-mappa `tasks/grunnleggende-brukeradministrasjon` ved overgang til felles oppgavestruktur | –           | –                |
| 2026-07-08 | 10 av 10 planlagte tasks implementert (`frontend/task-*-completion.md`) | –  | –                |
| 2026-07-08 | Analyse og plan ferdig (fs-admin)                               | –           | –                |
| 2026-07-07 | Krav hentet og spec skrevet (5 av 7 `.feature`-filer i scope)    | –           | –                |
| 2026-04-21 | Tatt inn i veikart (prioritert)                                 | –           | –                |

## Merknader

- Issuet #143 hadde tidligere labelen `Trenger innhold`. Kravene er siden skrevet som Gherkin under `krav_path` over, og spec-en peker på dem.
- Denne mappa het tidligere to steder: `veikart/tilgangsstyring/oppgaver/brukeradministrasjon-fs-admin/` (menneskesiden, #143) og `tasks/grunnleggende-brukeradministrasjon/` (BAT-artefaktene, som pekte på initiativet #350). Etter sammenslåingen er #143 oppgavens issue og #350 initiativet — i tråd med regelen «én oppgave ≙ én issue».
- Subgraph-arbeidet i fs-plattform (`flow.md`, halespor) er ikke startet. Frontend er bygget mot mock-API.
