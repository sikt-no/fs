# Scope: Automatisk grunnlag og poeng

- **Slug**: automatisk-grunnlag-og-poeng
- **Domene**: opptak
- **Initiativ**: [#199](https://github.com/sikt-no/fs/issues/199)
- **Jira**: –
- **Eier**: –
- **Siste oppdatering**: 2026-11-02

## Mål

- Leveranse 3 av 6 i flyten `@FLY-OPT-AUT-001` [automatisk saksbehandling](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature): saken får grunnlag fra vitnemålet, poengene beregnes fra grunnlaget og rangeringsregelverket, og søknaden får tilleggspoeng.
- Fasene «Saken får grunnlag fra vitnemålet», «Poengene beregnes fra grunnlaget og rangeringsregelverket» og «Søknaden får tilleggspoeng når grunnlaget er satt» er levert.

## Ikke-mål

- De andre leveransene i flyten: `automatisk-import-og-start`, `automatisk-gsk-konklusjon`, `automatisk-kvalifisering-og-poengsum`, `automatisk-ferdigbehandling` og `beregne-automatisk-pa-nytt`.
- De to `@wont`-fasene i flyten: to identiske vitnemål som regnes som ett, og automatisk dobbeltrangering.
- Regelverket poengene bygger på (`@OPT-REG-RAN-001`, `@OPT-REG-RAN-002`), som er levert.

## Kilder

- `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) — flyten, med fasene og overleveringene
- [GitHub #199](https://github.com/sikt-no/fs/issues/199) — initiativet «Automatisk saksbehandling av søknader om opptak til grunnutdanning»
- [FOL-34](https://sikt.atlassian.net/browse/FOL-34) grunnlag, [FOL-36](https://sikt.atlassian.net/browse/FOL-36) poengberegning av elektronisk vitnemål og [FOL-39](https://sikt.atlassian.net/browse/FOL-39) tilleggspoeng — initiativene i milepælsplanen
- [STEK-514](https://sikt.atlassian.net/browse/STEK-514) og [STEK-507](https://sikt.atlassian.net/browse/STEK-507) — feil i automatisk grunnlag og tilleggspoeng
- [Oppdelingen av flyten](https://claude.ai/artifact/XSScgR8ixj1HJ8kFK5fyso) — alternativ 1, besluttet 2026-11-02

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-BEH-BEH-019` [automatisk_grunnlag.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_grunnlag.feature) | Must | – | – | |
| `@OPT-BEH-BEH-018` [automatisk_poengberegning.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_poengberegning.feature) | Must | – | – | |
| `@OPT-BEH-BEH-028` [automatiske_tilleggspoeng.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatiske_tilleggspoeng.feature) | Must | – | – | |

## Åpne spørsmål

- [ ] Scopet har ingen Jira-sak. Avklares senere.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-02 | Opprettet med fs-scope, som leveranse 3 av 6 i flyten automatisk saksbehandling | @JøranIndseth | – |
