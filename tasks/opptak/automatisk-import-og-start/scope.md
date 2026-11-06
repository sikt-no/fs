# Scope: Automatisk import og start

- **Slug**: automatisk-import-og-start
- **Domene**: opptak
- **Initiativ**: [#199](https://github.com/sikt-no/fs/issues/199)
- **Jira**: [STEK-330](https://sikt.atlassian.net/browse/STEK-330)
- **Eier**: –
- **Siste oppdatering**: 2026-11-06

## Mål

- Leveranse 1 av 6 i flyten `@FLY-OPT-AUT-001` [automatisk saksbehandling](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature): søkerens vitnemål importeres fra KREG når saken er opprettet, og den automatiske behandlingen starter av seg selv når resultatene er importert.
- Fasene «Søkerens resultater importeres fra KREG når saken er opprettet» og «Den automatiske behandlingen starter når søkerens resultater er importert» er levert.
- Det kjente bruddet i flyten lukkes: i dag starter bare saksbehandleren behandlingen, for én sak om gangen.

## Ikke-mål

- De andre leveransene i flyten: `automatisk-gsk-konklusjon`, `automatisk-grunnlag-og-poeng`, `automatisk-kvalifisering-og-poengsum`, `automatisk-ferdigbehandling` og `beregne-automatisk-pa-nytt`.
- De to `@wont`-fasene i flyten: to identiske vitnemål som regnes som ett, og automatisk dobbeltrangering.
- Saksbehandlertildelingen (`@FLY-OPT-SAK-001`, `@OPT-BEH-BEH-011`). Flyten starter når saken er opprettet.
- Søkere med flere vitnemål behandles manuelt, og tas ut av scopet (statusmøtet 2026-11-04). Scenarioet «Saken som er under behandling, behandles automatisk på vitnemålet saksbehandleren velger» er flyttet fra `@OPT-BEH-BEH-032`. Saken behandles automatisk på vitnemålet saksbehandleren velger. Det er skilt ut i `@OPT-BEH-BEH-039` [behandle_automatisk_på_valgt_vitnemål.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/behandle_automatisk_p%C3%A5_valgt_vitnem%C3%A5l.feature), som er `@must` og ikke har scope ennå. Valget av vitnemål som grunnlag for poengberegningen i vitnemålsbehandleren (`@OPT-BEH-BEH-004`) er et annet valg.

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
| `@OPT-BEH-BEH-033` [kjøre_jobbene_i_opptak.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/kj%C3%B8re_jobbene_i_opptak.feature) | Must | – | – | Jobbplanleggeren og importjobben for nye vitnemål, som `@OPT-BEH-BEH-032` og fase 1 i `@FLY-OPT-VIT-001` bygger på. Kravet har også saksbehandlertildelingen og importen av resultater fra høyere utdanning (`@OPT-BEH-BEH-038`, i scopet `automatisk-grunnlag-og-poeng`), som `@OPT-BEH-BEH-028` i `automatisk-grunnlag-og-poeng` trenger. Kravet er `@planned`. «Det fremgår at jobbene kjører» venter (`@draft @openquestion`) |

## Åpne spørsmål

- [ ] `@OPT-BEH-BEH-032` har ingen Jira-sak. Avklares senere.
- [ ] `@OPT-BEH-BEH-033` har ingen Jira-sak.
- [x] `@OPT-BEH-BEH-033` må valideres med `fs-krav` før scopet kan spesifiseres. Validert 2026-11-05: `@planned`, med to regler som `@draft @openquestion`.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-06 | `@OPT-BEH-BEH-032`: et nytt vitnemål etter at saken er behandlet, gir saken nye resultater (`@OPT-BEH-BEH-035`, henvisning, ikke avhengighet). `@OPT-BEH-BEH-033`: importen én gang i døgnet holder også for annulleringer. Fra økta med fagfolk 06.11.2026 (PR #966) | @JøranIndseth | – |
| 2026-11-05 | `@OPT-BEH-BEH-033`: Sikt får ett samlet varsel per kjøring når importen feiler, og regelen om at opptaksforvalteren starter en jobb selv er slettet (importen kjører neste natt). Fra gjennomgangen av flyten automatisk saksbehandling | @JøranIndseth | – |
| 2026-11-05 | `@OPT-BEH-BEH-033` er validert og `@planned`. «Det fremgår at jobbene kjører» og «Opptaksforvalteren starter en jobb uten å vente på neste kjøring» venter (`@draft @openquestion`). `@FLY-OPT-VIT-001` har fått fasen om at behandlingen starter når importen har hentet vitnemålene til en søker uten vitnemål (avklart med Geir i #951). Fra gjennomgangen av flyten automatisk saksbehandling | @JøranIndseth | – |
| 2026-11-05 | Raden for `@OPT-BEH-BEH-033` viser til scopet for `@OPT-BEH-BEH-038` i stedet for PR #937. Fra reviewen av PR #948 | @JøranIndseth | [#948](https://github.com/sikt-no/fs/pull/948) |
| 2026-11-04 | Scenarioet om å starte på valgt vitnemål i `@OPT-BEH-BEH-032` er skilt ut i `@OPT-BEH-BEH-039` (Behandle automatisk på vitnemålet saksbehandleren velger), `@must` uten scope. Fra reviewen av PR #931 | @JøranIndseth | [#931](https://github.com/sikt-no/fs/pull/931) |
| 2026-11-04 | `@OPT-BEH-BEH-033` er tatt inn i scopet. `@OPT-BEH-BEH-032` og fase 1 i `@FLY-OPT-VIT-001` bygger på jobbene, og kravet hørte ikke til noe scope. Fra reviewen av PR #925 | @JøranIndseth | [#925](https://github.com/sikt-no/fs/pull/925) |
| 2026-11-02 | Opprettet med fs-scope, som leveranse 1 av 6 i flyten automatisk saksbehandling | @JøranIndseth | – |
