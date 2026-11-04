# Scope: Automatisk ferdigbehandling

- **Slug**: automatisk-ferdigbehandling
- **Domene**: opptak
- **Initiativ**: [#199](https://github.com/sikt-no/fs/issues/199)
- **Jira**: [STEK-253](https://sikt.atlassian.net/browse/STEK-253)
- **Eier**: –
- **Siste oppdatering**: 2026-11-04

## Mål

- Leveranse 5 av 6 i flyten `@FLY-OPT-AUT-001` [automatisk saksbehandling](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature): saken får automatiske mangeltekster, mangelen for generell studiekompetanse som fullføres i vår sjekkes ut, og den automatiske behandlingen setter saken til ferdig behandlet, så den kan være med i plasstildelingen.
- Fasene «Saken får mangeltekster når kravelementene er vurdert», «Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet» og «Saken blir ferdig behandlet og er klar til å være med i plasstildelingen» er levert.
- Det kjente bruddet i flyten lukkes: den automatiske behandlingen setter i dag ikke saken til ferdig behandlet.

## Ikke-mål

- Resten av søknadsmangler (`@OPT-BEH-BEH-008`). Bare de tre reglene flyten bygger på, er med, og de skilles ut i `@OPT-BEH-BEH-036` (besluttet 2026-11-02).
- De andre leveransene i flyten: `automatisk-import-og-start`, `automatisk-gsk-konklusjon`, `automatisk-grunnlag-og-poeng`, `automatisk-kvalifisering-og-poengsum` og `beregne-automatisk-pa-nytt`.
- De to `@wont`-fasene i flyten: to identiske vitnemål som regnes som ett, og automatisk dobbeltrangering.
- Plasstildelingen (`@OPT-PLA-TIL-001`, scopet `plasstildeling-2027`).
- Søkere med flere vitnemål behandles manuelt, og tas ut av scopet (statusmøtet 2026-11-04). Regelen «Har søkeren flere vitnemål, behandles saken automatisk på vitnemålet saksbehandleren velger» er flyttet fra `@OPT-BEH-BEH-025`. Saken behandles automatisk på vitnemålet saksbehandleren velger. Det er skilt ut i `@OPT-BEH-BEH-039` [behandle_automatisk_på_valgt_vitnemål.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/behandle_automatisk_p%C3%A5_valgt_vitnem%C3%A5l.feature), som er `@must` og ikke har scope ennå. Valget av vitnemål som grunnlag for poengberegningen i vitnemålsbehandleren (`@OPT-BEH-BEH-004`) er et annet valg.

## Kilder

- `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) — flyten, med fasene og de kjente bruddene
- [GitHub #199](https://github.com/sikt-no/fs/issues/199) — initiativet «Automatisk saksbehandling av søknader om opptak til grunnutdanning»
- [GitHub #413](https://github.com/sikt-no/fs/issues/413) — issuet til søknadsmangler
- [FOL-40](https://sikt.atlassian.net/browse/FOL-40) — behandlingsstatus «Behandlet», initiativet i milepælsplanen
- [Oppdelingen av flyten](https://claude.ai/artifact/XSScgR8ixj1HJ8kFK5fyso) — alternativ 1, besluttet 2026-11-02
- [Status per 4. november 2026](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5169545237) — status for leveransene i flyten, med kommentarene fra statusmøtet

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-BEH-BEH-036` [automatiske_mangler.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatiske_mangler.feature) | Must | – | – | Skilt ut fra `@OPT-BEH-BEH-008`. Regelen om merking av mangelkoden er `@draft`. Scenarioene om saksloggen kan ikke leveres før den nye sporingsloggen finnes. Endringsloggen er stoppet (BAT-324, 29.10.2026) |
| `@OPT-BEH-BEH-029` [behandlingsstatus.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/behandlingsstatus.feature) | Must | – | [STEK-253](https://sikt.atlassian.net/browse/STEK-253) | Regelen «Saksloggen viser endringene i behandlingsstatusen» kan ikke leveres før den nye sporingsloggen finnes. Endringsloggen er stoppet (BAT-324, 29.10.2026) |
| `@OPT-BEH-BEH-025` [ferdigbehandle_sak.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/ferdigbehandle_sak.feature) | Must | – | [STEK-253](https://sikt.atlassian.net/browse/STEK-253) | |

## Åpne spørsmål

- [ ] `@OPT-BEH-BEH-036` har ingen Jira-sak. Avklares senere.
- [ ] Regelen «Opptaksforvalteren merker én mangelkode for generell studiekompetanse som fullføres i vår» i `@OPT-BEH-BEH-036` er `@draft`, og må valideres med fs-krav før fasen «Mangelen for GSK som fullføres i vår sjekkes ut før saken blir ferdig behandlet» kan leveres.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-04 | Regelen om flere vitnemål i `@OPT-BEH-BEH-025` er skilt ut i `@OPT-BEH-BEH-039` (Behandle automatisk på vitnemålet saksbehandleren velger), `@must` uten scope. Fra reviewen av PR #931 | @JøranIndseth | [#931](https://github.com/sikt-no/fs/pull/931) |
| 2026-11-04 | Søkere med flere vitnemål tatt ut av scopet (statusmøtet, se Kilder) | @JøranIndseth | – |
| 2026-11-03 | Scenarioene om endringsloggen og saksloggen i `@OPT-BEH-BEH-029` og `@OPT-BEH-BEH-036` er blokkert til den nye sporingsloggen finnes. Endringsloggen i opptak er stoppet (BAT-324, V480 i fs-plattform), så kravene blir ikke `@implemented` før da | @JøranIndseth | – |
| 2026-11-02 | `@OPT-BEH-BEH-036` fylt ut med fs-krav: tre regler skilt ut fra `@OPT-BEH-BEH-008`, og flyten bygger på 036 | @JøranIndseth | – |
| 2026-11-02 | Opprettet med fs-scope, som leveranse 5 av 6 i flyten automatisk saksbehandling | @JøranIndseth | – |
