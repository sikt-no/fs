# Scope: Automatisk kvalifisering og poengsum per kvote

- **Slug**: automatisk-kvalifisering-og-poengsum
- **Domene**: opptak
- **Initiativ**: [#199](https://github.com/sikt-no/fs/issues/199)
- **Jira**: –
- **Eier**: –
- **Siste oppdatering**: 2026-11-03

## Mål

- Leveranse 4 av 6 i flyten `@FLY-OPT-AUT-001` [automatisk saksbehandling](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature): kravelementene vurderes mot vitnemålet, kvalifiseringen oppdateres, og søkeren får poengsum per kvote.
- Fasene «Kravelementene vurderes mot vitnemålet når poengene er beregnet», «Kvalifiseringen oppdateres når kravelementene er vurdert» og «Søkeren får poengsum per kvote når søkeren er fordelt på kvoter» er levert.

## Ikke-mål

- De andre leveransene i flyten: `automatisk-import-og-start`, `automatisk-gsk-konklusjon`, `automatisk-grunnlag-og-poeng`, `automatisk-ferdigbehandling` og `beregne-automatisk-pa-nytt`.
- De to `@wont`-fasene i flyten: to identiske vitnemål som regnes som ett, og automatisk dobbeltrangering.
- Kvotespørsmålene med algoritme og fordelingen på kvoter (`@OPT-BEH-BEH-012`), som er levert.

## Kilder

- `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) — flyten, med fasene og overleveringene
- [GitHub #199](https://github.com/sikt-no/fs/issues/199) — initiativet, også issuet til `@OPT-BEH-BEH-020`
- [FOL-35](https://sikt.atlassian.net/browse/FOL-35) kvalifisering på kravelementer og [FOL-38](https://sikt.atlassian.net/browse/FOL-38) plassering i kvote — initiativene i milepælsplanen
- [STEK-640](https://sikt.atlassian.net/browse/STEK-640) utfall per kravlisteelement og [STEK-650](https://sikt.atlassian.net/browse/STEK-650) hvorfor poengsummen ikke kan regnes ut — dekker deler av kravene
- [Oppdelingen av flyten](https://claude.ai/artifact/XSScgR8ixj1HJ8kFK5fyso) — alternativ 1, besluttet 2026-11-02

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-BEH-BEH-020` [automatisk_kvalifisering.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_kvalifisering.feature) | Must | – | – | Scenarioet om endringsloggen kan ikke leveres før den nye sporingsloggen finnes. Endringsloggen er stoppet (BAT-324, 29.10.2026) |
| `@OPT-BEH-BEH-031` [beregne_poengsum_per_kvote.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_poengsum_per_kvote.feature) | Must | – | – | Scenarioet om endringsloggen stemmer bare fordi endringsloggen er stoppet (BAT-324, 29.10.2026), og kan ikke verifiseres før den nye sporingsloggen finnes |

## Åpne spørsmål

- [ ] Scopet har ingen Jira-sak. Avklares senere.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-03 | Scenarioene om endringsloggen og saksloggen i `@OPT-BEH-BEH-020` og `@OPT-BEH-BEH-031` er blokkert til den nye sporingsloggen finnes. Endringsloggen i opptak er stoppet (BAT-324, V480 i fs-plattform), så kravene blir ikke `@implemented` før da | @JøranIndseth | – |
| 2026-11-02 | Opprettet med fs-scope, som leveranse 4 av 6 i flyten automatisk saksbehandling | @JøranIndseth | – |
