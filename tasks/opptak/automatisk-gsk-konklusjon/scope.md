# Scope: Automatisk GSK-konklusjon

- **Slug**: automatisk-gsk-konklusjon
- **Domene**: opptak (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: [#723](https://github.com/sikt-no/fs/issues/723)
- **Jira**: [STEK-249](https://sikt.atlassian.net/browse/STEK-249)
- **Eier**: –
- **Siste oppdatering**: 2026-11-06

## Mål

- Søknaden får GSK-konklusjonen automatisk når vitnemålet har «GSK OK» fra KREG og løpet finnes i listen over løp (`@OPT-BEH-BEH-015`, `@OPT-BEH-BEH-027`).
- Opptakssystemets påstand fra fs-opptaks kontrollmotor kontrollerer «GSK OK» fra KREG, og uenighet gir varsel uten å stoppe automatikken.

## Ikke-mål

- Leveranse 2 av 6 i flyten `@FLY-OPT-AUT-001` [automatisk saksbehandling](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature). De andre leveransene er `automatisk-import-og-start`, `automatisk-grunnlag-og-poeng`, `automatisk-kvalifisering-og-poengsum`, `automatisk-ferdigbehandling` og `beregne-automatisk-pa-nytt`.
- De to `@wont`-fasene i flyten: to identiske vitnemål som regnes som ett, og automatisk dobbeltrangering.

## Kilder

- `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) — flyten
- [GitHub #723](https://github.com/sikt-no/fs/issues/723) — «Automatisk GSK-konklusjon»
- [Oppdelingen av flyten](https://claude.ai/artifact/XSScgR8ixj1HJ8kFK5fyso) — alternativ 1, besluttet 2026-11-02

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-BEH-BEH-015` [automatisk_gsk_konklusjon.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_gsk_konklusjon.feature) | Must | – | [STEK-249](https://sikt.atlassian.net/browse/STEK-249) | Også STEK-440 |
| `@OPT-BEH-BEH-027` [beregne_gsk_fra_vitnemål.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_gsk_fra_vitnem%C3%A5l.feature) | Must | – | [STEK-249](https://sikt.atlassian.net/browse/STEK-249) | Kontrollmotoren beregner opptakssystemets påstand om GSK |
| `@OPT-BEH-BEH-034` [håndtere_annullert_vitnemål.feature](../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/h%C3%A5ndtere_annullert_vitnem%C3%A5l.feature) | Must | – | [STEK-249](https://sikt.atlassian.net/browse/STEK-249) | Saken merkes når et vitnemål som er i bruk, blir annullert. Den siste fasen i `@FLY-OPT-VIT-001` bygger på kravet. Hentet inn i [spec-automatisk-gsk-konklusjon.md](spec/spec-automatisk-gsk-konklusjon.md) 2026-11-02 |

## Åpne spørsmål

–

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-06 | `@OPT-BEH-BEH-015`: ny regel «Grunnlagskoden rettes når løpet er lagt inn i listen over løp». Konklusjoner automatikken satte med KLY eller RFA fordi løpet manglet, får grunnlagskoden fra listen når opptaksforvalteren starter rettingen. Sikt legger løpet inn i listen (PR #966) | @JøranIndseth | – |
| 2026-11-06 | `@OPT-BEH-BEH-015`: varselet om løp går til opptaksforvalteren ved organisasjonen som forvalter opptaket, ett varsel per løp (hvor i FS Admin er åpent). Annulleringen oppdages av importen (`@OPT-BEH-BEH-030`). `@OPT-BEH-BEH-027`: regelen om fagstatus er utenfor flyten. Fra økta med fagfolk 06.11.2026 (PR #966) | @JøranIndseth | – |
| 2026-11-05 | `@OPT-BEH-BEH-034` er tatt inn i scopet med `@scope-automatisk-gsk-konklusjon` og en rad i tabellen. Kravet var hentet inn i spesifikasjonen 2026-11-02, men sto ikke i `scope.md`. Fra gjennomgangen av flyten automatisk saksbehandling | @JøranIndseth | – |
| 2026-11-03 | Revidert med fs-scope: leveranse 2 av 6 i flyten automatisk saksbehandling, `@scope-automatisk-gsk-konklusjon` på 015 og 027, og krav-tabellen fylt ut | @JøranIndseth | – |
| 2026-11-02 | Opprettet med fs-specify | – | – |
