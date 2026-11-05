# Scope: Beregne automatisk på nytt

- **Slug**: beregne-automatisk-pa-nytt
- **Domene**: opptak
- **Initiativ**: [#199](https://github.com/sikt-no/fs/issues/199)
- **Jira**: [STEK-651](https://sikt.atlassian.net/browse/STEK-651)
- **Eier**: –
- **Siste oppdatering**: 2026-11-05

## Mål

- Leveranse 6 av 6 i flyten `@FLY-OPT-AUT-001` [automatisk saksbehandling](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature): rettes en feil i regelverket, beregner opptaksforvalteren søknadsalternativene feilen gjaldt, på nytt.
- Fasen «Søknadsalternativene beregnes på nytt når regelverket er rettet» er levert.

## Ikke-mål

- De andre leveransene i flyten: `automatisk-import-og-start`, `automatisk-gsk-konklusjon`, `automatisk-grunnlag-og-poeng`, `automatisk-kvalifisering-og-poengsum` og `automatisk-ferdigbehandling`.
- De to `@wont`-fasene i flyten: to identiske vitnemål som regnes som ett, og automatisk dobbeltrangering.
- Testkjøring: en beregning på nytt som ikke oppdaterer databasen, men gir en rapport over hva som ville blitt endret. Notert i statusmøtet 2026-11-04 for en senere versjon.

## Kilder

- `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) — flyten
- [GitHub #199](https://github.com/sikt-no/fs/issues/199) — initiativet «Automatisk saksbehandling av søknader om opptak til grunnutdanning»
- [Oppdelingen av flyten](https://claude.ai/artifact/XSScgR8ixj1HJ8kFK5fyso) — alternativ 1, besluttet 2026-11-02
- [Status per 4. november 2026](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5169545237) — status for leveransene i flyten, med kommentarene fra statusmøtet

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-BEH-BEH-026` [beregne_automatisk_på_nytt.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_automatisk_p%C3%A5_nytt.feature) | Must | – | [STEK-651](https://sikt.atlassian.net/browse/STEK-651) | Bygger på `@OPT-PLA-TIL-001`, som er `@draft` |

## Åpne spørsmål

- [ ] Hvem kan beregne på nytt? I kravet er det opptaksforvalteren ved organisasjonen som eier opptaket (HK-dir i `Bakgrunn:`), og det er greit i første versjon. Forslag fra statusmøtet 2026-11-04: opptaksforvalteren ved organisasjonen som eier opptaket, beregner på nytt for hele opptaket, og opptaksforvalteren ved et lærested for sakene lærestedet har ansvar for. Avklares i `@OPT-BEH-BEH-026` med fs-krav.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-05 | De åpne spørsmålene i `@OPT-BEH-BEH-026` er lukket: bare én beregning eller plasstildeling i opptaket om gangen, ingen beregning etter at resultatet av siste runde er publisert, saksloggen viser den automatiske behandlingen og hvem som startet beregningen, og alle regelverkene velges når en kvotetype er rettet. Fra gjennomgangen av flyten automatisk saksbehandling | @JøranIndseth | – |
| 2026-11-04 | Hvem som kan beregne på nytt, er et åpent spørsmål, og testkjøring er notert som ikke-mål (statusmøtet, se Kilder) | @JøranIndseth | – |
| 2026-11-02 | Opprettet med fs-scope, som leveranse 6 av 6 i flyten automatisk saksbehandling | @JøranIndseth | – |
