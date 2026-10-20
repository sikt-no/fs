<!--
Mal for oppgave.md. Kopier til tasks/<domene>/<slug>/oppgave.md og fyll ut.
Se ../README.md for domeneliste og reglene for hva som kan ligge i oppgave-rota.
Oppgaver i et scope opprettes med fs-scope. Uten scope skriver fs-specify og «+ Ny oppgave» i FS Kravforvaltning en minimal versjon.
`Fase` er valgfri, og leses ikke av FS Kravforvaltning.
-->

# <Oppgavetittel>

## Metadata

- **Issue**: [BAT-NNNN](https://sikt.atlassian.net/browse/BAT-NNNN) (Jira-saken, se [`../README.md`](../README.md#forholdet-til-jira-og-github))
- **Initiativ**: #NNN (hvis aktuelt)
- **Domene**: <domene> (se [`../../README.md`](../../README.md#domener))
- **Slug**: <slug> (= navnet på denne mappa)
- **Scope**: [scope-<scope-slug>](../scope-<scope-slug>.md) | – (har oppgaven scope, er scope-raden kilden til kravene)
- **Fase**: prioritert | utforskning | utvikling | innføring | levert (valgfri, brukes av fs-oppgave utenfor repoet)
- **Prioritet**: Must | Should | Could | Won't
- **Type**: feature
- **Eier**: @brukernavn
- **Reviewers som har sett oppgaven**: (ingen enda)
- **Lag/roller i bruk**: – (f.eks. spec, frontend, subgraph)
- **Lenker**:
  - design: [design.md](design.md)
  - krav: [spec/](spec/)
  - plan: `<lag>/plan-<slug>.md`
  - review: [reviews/](reviews/)
  - PRs: –
- **Krav (Gherkin)**: `../../../krav/07 Brukeradministrasjon og tilgangsstyring/...` (hvis aktuelt, og bare uten scope)

## Kort beskrivelse

<Én-to setninger som beskriver hva denne oppgaven leverer og hvorfor. For detaljer, se issuet.>

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse                          | Av            | Lenke til review        |
|------------|-----------------------------------|---------------|-------------------------|
| ÅÅÅÅ-MM-DD | Tatt inn i veikart (prioritert)   | @brukernavn   | –                       |
