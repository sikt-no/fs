# Scope: Beregne automatisk på nytt

- **Slug**: beregne-automatisk-pa-nytt
- **Domene**: opptak
- **Initiativ**: [#199](https://github.com/sikt-no/fs/issues/199)
- **Jira**: [STEK-651](https://sikt.atlassian.net/browse/STEK-651)
- **Eier**: –
- **Siste oppdatering**: 2026-11-02

## Mål

- Leveranse 6 av 6 i flyten `@FLY-OPT-AUT-001` [automatisk saksbehandling](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature): rettes en feil i regelverket, beregner opptaksforvalteren søknadsalternativene feilen gjaldt, på nytt.
- Fasen «Søknadsalternativene beregnes på nytt når regelverket er rettet» er levert.

## Ikke-mål

- De andre leveransene i flyten: `automatisk-import-og-start`, `automatisk-gsk-konklusjon`, `automatisk-grunnlag-og-poeng`, `automatisk-kvalifisering-og-poengsum` og `automatisk-ferdigbehandling`.
- De to `@wont`-fasene i flyten: to identiske vitnemål som regnes som ett, og automatisk dobbeltrangering.

## Kilder

- `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) — flyten
- [GitHub #199](https://github.com/sikt-no/fs/issues/199) — initiativet «Automatisk saksbehandling av søknader om opptak til grunnutdanning»
- [Oppdelingen av flyten](https://claude.ai/artifact/XSScgR8ixj1HJ8kFK5fyso) — alternativ 1, besluttet 2026-11-02

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-BEH-BEH-026` [beregne_automatisk_på_nytt.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_automatisk_p%C3%A5_nytt.feature) | Must | – | [STEK-651](https://sikt.atlassian.net/browse/STEK-651) | Bygger på `@OPT-PLA-TIL-001`, som er `@draft` |

## Åpne spørsmål

–

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-02 | Opprettet med fs-scope, som leveranse 6 av 6 i flyten automatisk saksbehandling | @JøranIndseth | – |
