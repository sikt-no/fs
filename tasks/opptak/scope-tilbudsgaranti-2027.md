# Scope: Tilbudsgaranti 2027

- **Slug**: tilbudsgaranti-2027
- **Initiativ**: [#512](https://github.com/sikt-no/fs/issues/512)
- **Eier**: –
- **Siste oppdatering**: 2026-10-21

## Mål

- Behandler (B-rolle), tilbyder (T-rolle) og opptaksforvalter (F-rolle) kan gi, endre og fjerne tilbudsgaranti på et søknadsalternativ, med tilbudsgarantitypene opptaket har for rollen.
- Behandlerne ser tilbudsgarantiene fra alle rollene, og hvem som har satt, endret og fjernet dem.
- Tilbudsgarantien følger søknadsalternativet, og plasstildelingen henter den fra saksbehandlingen (STEK-263).

## Ikke-mål

- Tidligopptaket (`@OPT-BEH-BEH-007`, STEK-188). Det er i oppgaven [tidlig-opptak](tidlig-opptak/).
- Hvordan plasstildelingen gir tilbud med tilbudsgaranti (`@OPT-PLA-TIL-002`, [scope-plasstildeling-2027](scope-plasstildeling-2027.md)).
- Hvilken utdanningskvote tilbudsgarantiene tas fra for et utdanningstilbud (`@OPT-OPT-UTD-004`, [scope-utdanningstilbud-2027](scope-utdanningstilbud-2027.md)).
- Utsatt, står som skjeletter i raden «(ikke tildelt)»: forvaltning av tilbudsgarantityper (STEK-349, typene legges inn i databasen per opptak for 2027), reservert studieplass for søkeren (STEK-553, on hold), og unntak fra utdanningskvoten for ett søknadsalternativ (STEK-270).

## Kilder

- [GitHub #512](https://github.com/sikt-no/fs/issues/512) — «Saksbehandler kan sette tilbudsgaranti på søknadalternativ»
- [STEK-241](https://sikt.atlassian.net/browse/STEK-241) — «Tilbudsgaranti», med STEK-262 (hvem som kan sette hvilken tilbudsgaranti), STEK-263 (plasstildelingen henter tilbudsgarantiene) og STEK-270 (tilbyder og opptaksforvalter)
- [STEK-349](https://sikt.atlassian.net/browse/STEK-349) — opptakseieren forvalter tilbudsgarantitypene i opptaket
- [STEK-553](https://sikt.atlassian.net/browse/STEK-553) — søkeren ser reservert studieplass (kategori S), on hold
- [Confluence PFS 3885400152](https://sikt.atlassian.net/wiki/spaces/PFS/pages/3885400152) — «Tilbudsgaranti», dagens løsning i UHG, HYU/FSU og lokale opptak
- [Confluence PFS 5086576688](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5086576688) — «2026-10-07 Status tilbudsgarantier og Tidlig opptak»
- [Confluence PFS 4431249457](https://sikt.atlassian.net/wiki/spaces/PFS/pages/4431249457) — «Ting vi må huske på før vi kan gå i produksjon», der overstyring av utdanningskvoten for én søker er parkert (STEK-270)
- [Figma, node 9840:220112](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=9840-220112) — saksbehandlingen, detaljene for et søknadsalternativ, med en nedtrekksmeny for tilbudsgaranti
- [Figma, node 16945:72343](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=16945-72343) — behandling av søknad om tidlig opptak, med nedtrekksmenyen for tilbudsgaranti i skuffen (STEK-270)

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [tilbudsgaranti](tilbudsgaranti/) | `@OPT-BEH-BEH-010` [gi_tilbudsgaranti.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti.feature) | Must | [Søknadsalternativ i saksbehandlingen](https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=9840-220112) | [STEK-241](https://sikt.atlassian.net/browse/STEK-241) | Reglene for manuell tilbudsgaranti er flyttet fra `@OPT-BEH-BEH-007` (PR #737). Hvilke av de tre feltene brukeren kan endre, regnes ut i frontend fra rollen og organisasjonen den gjelder ved (STEK-270, løsning 1b). Det hører til i `gi_tilbudsgaranti.design.md` |
| (ikke tildelt) | `@OPT-OVO-INN-004` [forvalte_tilbudsgarantityper.feature](../../krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/forvalte_tilbudsgarantityper.feature) | Could | – | [STEK-349](https://sikt.atlassian.net/browse/STEK-349) | Skjelett |
| (ikke tildelt) | `@OPT-SØK-SØK-016` [reservert_studieplass.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/reservert_studieplass.feature) | Could | – | [STEK-553](https://sikt.atlassian.net/browse/STEK-553) | Skjelett, on hold |
| (ikke tildelt) | `@OPT-BEH-BEH-017` [velge_utdanningskvote_for_tilbudsgaranti.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_utdanningskvote_for_tilbudsgaranti.feature) | Could | – | [STEK-270](https://sikt.atlassian.net/browse/STEK-270) | Skjelett |

## Åpne spørsmål

- [ ] Skissene viser én nedtrekksmeny for tilbudsgaranti, ikke tre felt. I STEK-270 er det avklart at feltene for B-, T- og F-rolle vises hver for seg, og at et felt for en rolle brukeren ikke har, bare viser verdien. Det står i `@OPT-BEH-BEH-010`. Skal skissene oppdateres, eller holder det at `fs-specify` noterer avviket?
- [ ] Sidefunn fra kodesjekken for tidlig opptak: tilbudsgarantien fra behandler kopieres ikke når søknadsalternativet flyttes til en annen behandler (`BehandlertildelingService.java:474-477`). Sjekkes i `fs-specify` for `@OPT-BEH-BEH-010`.
