# Scope: Automatisk import og start

- **Slug**: automatisk-import-og-start
- **Domene**: opptak
- **Initiativ**: [#199](https://github.com/sikt-no/fs/issues/199)
- **Jira**: [STEK-330](https://sikt.atlassian.net/browse/STEK-330)
- **Eier**: –
- **Siste oppdatering**: 2026-11-02

## Mål

- Leveranse 1 av 6 i flyten `@FLY-OPT-AUT-001` [automatisk saksbehandling](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature): søkerens vitnemål importeres fra KREG når saken er opprettet, og den automatiske behandlingen starter av seg selv når resultatene er importert.
- Fasene «Søkerens resultater importeres fra KREG når saken er opprettet» og «Den automatiske behandlingen starter når søkerens resultater er importert» er levert.
- Det kjente bruddet i flyten lukkes: i dag starter bare saksbehandleren behandlingen, for én sak om gangen.

## Ikke-mål

- De andre leveransene i flyten: `automatisk-gsk-konklusjon`, `automatisk-grunnlag-og-poeng`, `automatisk-kvalifisering-og-poengsum`, `automatisk-ferdigbehandling` og `beregne-automatisk-pa-nytt`.
- De to `@wont`-fasene i flyten: to identiske vitnemål som regnes som ett, og automatisk dobbeltrangering.
- Saksbehandlertildelingen (`@FLY-OPT-SAK-001`, `@OPT-BEH-BEH-011`). Flyten starter når saken er opprettet.

## Kilder

- `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) — flyten, med fasene og de kjente bruddene
- [GitHub #199](https://github.com/sikt-no/fs/issues/199) — initiativet «Automatisk saksbehandling av søknader om opptak til grunnutdanning»
- [GitHub #61](https://github.com/sikt-no/fs/issues/61) — «Automatisk innhente resultater i søknadsflyten»
- [Oppdelingen av flyten](https://claude.ai/artifact/XSScgR8ixj1HJ8kFK5fyso) — alternativ 1, besluttet 2026-11-02

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-BEH-BEH-030` [importere_resultater_fra_kreg.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/importere_resultater_fra_kreg.feature) | Must | – | [STEK-330](https://sikt.atlassian.net/browse/STEK-330) | |
| `@OPT-BEH-BEH-032` [starte_automatisk_behandling.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/starte_automatisk_behandling.feature) | Must | – | – | |

## Åpne spørsmål

- [ ] `@OPT-BEH-BEH-032` har ingen Jira-sak. Avklares senere.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-02 | Opprettet med fs-scope, som leveranse 1 av 6 i flyten automatisk saksbehandling | @JøranIndseth | – |
