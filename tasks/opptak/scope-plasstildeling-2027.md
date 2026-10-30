# Scope: Plasstildeling 2027

- **Slug**: plasstildeling-2027
- **Initiativ**: [#216](https://github.com/sikt-no/fs/issues/216)
- **Eier**: –
- **Siste oppdatering**: 2026-10-29

## Mål

- Opptaksforvalter kan opprette plasstildelingsrunder, sette antall tilbud, starte og gjennomføre plasstildelinger, kontrollere og publisere resultatet.
- Plasstildelingen bruker rundetypene som finnes i regelverkssamlingen: hovedtildeling, supplering og etterfylling, med innstillingene plasstildelingen leser. Plasstildelingen ser aldri på hvilken rundetype det er (avklart 2026-10-24). Samordna opptak (UHG og HYU) får de tre rundetypene med samme oppførsel som før.
- Saksbehandler og søker ser det publiserte resultatet, og søkeren kan svare på tilbud og ventelisteplass.
- Klar for første samordna opptak 2027. Produksjonsfrist 8. desember 2026.
- Leveres i tre oppgaver, i denne rekkefølgen (delt 2026-10-28): rundetyper og runder, gjennomføre plasstildelingen, og publisere og svare på tilbud. Kravene med `@should` og `@could` står som «(ikke tildelt)» til de prioriteres.

## Ikke-mål

- Automatiske nye tilbud ved nei-svar mellom plasstildelingsrundene (oppgave 10, Won't 2027).
- Vedtaksformidling (svarmelding, påminnelse, åpnet vedtak, digital postkasse og hendelseslogg). Det blir en egen oppgave og et eget scope senere, se [vedtaksformidling](vedtaksformidling/).
- Å sette standard plassflyt og kvoteprioritet (`@OPT-REG-KVO-003` og `@OPT-REG-KVO-004`, før `@OPT-OVO-INN-002` og `@OPT-OVO-INN-003`). De settes i regelverkssamlingen (avklart 2026-10-21). De er flyttet til [scope-kvoter-i-opptaket-2027](scope-kvoter-i-opptaket-2027.md) 2026-10-15, så de kan leveres før plasstildelingen. Hva plasstildelingen gjør med dem, er fortsatt her.
- At lærestedene melder feil i resultatet til opptakets forvalter i løsningen (Could, senere). E-post er godt nok nå, så lenge opptakets forvalter kan endre antall tilbud etter lærestedenes periode (avklart med domeneekspert 2026-10-15, og på nytt etter brukertesten med HK-dir 2026-10-28).
- Varsler og meldinger fra løsningen i plasstildelingen. De sendes på e-post utenfor løsningen i dag (avklart 2026-10-28). Kravet står som `@should` under «(ikke tildelt)».
- Regelverk, rangering og kvalifisering. De kommer fra søknadsbehandlingen og regelverket, ikke fra plasstildelingen. Unntaket er rundetypene (`@OPT-REG-RUN-001`), som plasstildelingen trenger nå.
- Å forvalte rundetypene: legge til, endre og slette rundetyper i regelverkssamlingen (`@OPT-REG-RUN-002`, Could). Plasstildelingen bruker rundetypene som finnes (avklart 2026-10-29). Kravet står under «(ikke tildelt)».

## Kilder

- [GitHub #216](https://github.com/sikt-no/fs/issues/216) — initiativet «Ferdigstilling av plasstildeling i opptak».
- [plasstildeling/oppgave.md](plasstildeling/oppgave.md) — workshop 2026-09-14 (utsatt til 8. desember) og funksjonell løsning per oppgave. Mappa var oppgaven for hele scopet til 2026-10-28, og står igjen som kilde.
- [plasstildeling/design.md](plasstildeling/design.md) — mål, prinsipper, rundetyper, gap-analyse mot koden og avklaringer.
- [Jira TAKE-3](https://sikt.atlassian.net/browse/TAKE-3) — epic.
- [Confluence: T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377) — bakgrunn.
- [Confluence: 2026-10-14 Åpne spørsmål: plasstildeling i FS-Admin (designarbeid)](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5105025045) — spørsmål og beslutninger fra designarbeidet, med svarene fra kravarbeidet.
- [Confluence: 2026-10-27 Plasstildeling med HK-dir](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147492374) — notatene fra brukertestene med HK-dir (oktober 2026).
- [Mockup: Plasstildeling 2027](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) — rundetyper i regelverkssamlingen, runder, antall tilbud og resultat, oppdatert etter brukertestene 2026-10-28. Privat til den deles.
- [krav/_kravanalyser/hk-dir-krav-dekning.md](../../krav/_kravanalyser/hk-dir-krav-dekning.md) — HK-dirs krav mot kravene for opptak.
- [verify-2026-10-28-1645.md](../../akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md) — verifisering av alle kravene mot koden, uansett status: hva som finnes og mangler per krav og repo. 51 av 170 scenarioer funnet.

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [plasstildeling-rundetyper-og-runder](plasstildeling-rundetyper-og-runder/) | `@OPT-REG-RUN-001` [bruke_rundetyper.feature](../../krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/bruke_rundetyper.feature) | Must | [Mockup: Rundetyper](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | [#216](https://github.com/sikt-no/fs/issues/216) | Hovedtildeling, supplering og etterfylling med innstillingene plasstildelingen leser. Forvaltningen er skilt ut i `@OPT-REG-RUN-002` (2026-10-29). Verify 2026-10-28: rundetypene er et fast kodeverk uten innstillinger |
| [plasstildeling-rundetyper-og-runder](plasstildeling-rundetyper-og-runder/) | `@OPT-PLA-RUN-001` [forvalte_runder.feature](../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) | Must | [Mockup: Runder](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | [#216](https://github.com/sikt-no/fs/issues/216) | Legge til runder, med innstillingene fra rundetypen. Verify: 6/23 — bare hovedrunde kan velges i fs-admin, og redigering nullstiller publiseringen |
| [plasstildeling-rundetyper-og-runder](plasstildeling-rundetyper-og-runder/) | `@OPT-PLA-INN-001` [antall_tilbud_som_skal_gis.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature) | Must | [Mockup: Antall tilbud](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | [#583](https://github.com/sikt-no/fs/issues/583) | Antall tilbud som skal gis per utdanningskvote i runden. Jira [TAKE-327](https://sikt.atlassian.net/browse/TAKE-327). Verify: 2/21 — settes for hele opptaket, og perioden håndheves ikke |
| [gjennomfore-plasstildeling](gjennomfore-plasstildeling/) | `@OPT-PLA-INN-002` [plassflyt.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/plassflyt.feature) | Must | – | [#216](https://github.com/sikt-no/fs/issues/216) | Plassflyt ved ledige plasser per utdanningskvote. Verify: 7/8 — en mottaker som mangler, stopper kjøringen |
| [gjennomfore-plasstildeling](gjennomfore-plasstildeling/) | `@OPT-PLA-TIL-001` [starte_plasstildeling.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/starte_plasstildeling.feature) | Must | [Mockup: Plasstildeling](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | [#216](https://github.com/sikt-no/fs/issues/216) | Starte en plasstildeling. Verify: 3/12 — ikke styrt av rundetypen, og ingen filter på ferdig behandlet |
| [gjennomfore-plasstildeling](gjennomfore-plasstildeling/) | `@OPT-PLA-TIL-002` [gjennomføre_plasstildeling.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature) | Must | – | [#216](https://github.com/sikt-no/fs/issues/216) | Gjennomføre plasstildeling. Verify: 11/36 — kjernen finnes; innstillingene fra rundetypen, tilbudsgaranti fra saksbehandlingen, SPEV og poenggrense mangler |
| [gjennomfore-plasstildeling](gjennomfore-plasstildeling/) | `@OPT-PLA-TIL-003` [kompensasjonstilbud_ved_opprykk.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/kompensasjonstilbud_ved_opprykk.feature) | Must | – | [#584](https://github.com/sikt-no/fs/issues/584) | Kompensasjonstilbud ved opprykk. Jira [TAKE-328](https://sikt.atlassian.net/browse/TAKE-328). Verify: 0/4 — skjer i alle runder, ikke styrt av rundetypen |
| [gjennomfore-plasstildeling](gjennomfore-plasstildeling/) | `@OPT-PLA-RES-001` [vise_resultat.feature](../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/vise_resultat.feature) | Must | [Mockup: Resultat](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | [#585](https://github.com/sikt-no/fs/issues/585) | Resultatet før publisering, så plasstildelingen kan kontrolleres og testes. Jira [TAKE-329](https://sikt.atlassian.net/browse/TAKE-329). Verify: 7/16 — tilgangen gjelder hele opptaket, og sammenligning og poenggrense mangler |
| [publisere-og-svare-pa-tilbud](publisere-og-svare-pa-tilbud/) | `@OPT-PLA-RES-002` [publisere_resultat.feature](../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/publisere_resultat.feature) | Must | – | [#586](https://github.com/sikt-no/fs/issues/586) | Publisere resultatet til søkerne. Jira [TAKE-330](https://sikt.atlassian.net/browse/TAKE-330). Verify: 4/8 — ventelistenummeret når ikke fram til søkeren |
| [publisere-og-svare-pa-tilbud](publisere-og-svare-pa-tilbud/) | `@OPT-PLA-RES-003` [se_publisert_resultat.feature](../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_publisert_resultat.feature) | Must | – | [#585](https://github.com/sikt-no/fs/issues/585) | Det publiserte resultatet, for saksbehandler. Jira [TAKE-329](https://sikt.atlassian.net/browse/TAKE-329). Verify: 4/9 — avgrensning per organisasjon og poenggrense mangler |
| [publisere-og-svare-pa-tilbud](publisere-og-svare-pa-tilbud/) | `@OPT-PLA-SVA-001` [håndtere_svar_fra_søker.feature](../../krav/02%20Opptak/14%20Plasstildeling/05%20Svar/h%C3%A5ndtere_svar_fra_s%C3%B8ker.feature) | Must | – | [#587](https://github.com/sikt-no/fs/issues/587) | Håndtere svar fra søker. Jira [TAKE-331](https://sikt.atlassian.net/browse/TAKE-331). Verify: 6/9 — det som gjelder etterfylling, mangler |
| (ikke tildelt) | `@OPT-PLA-INN-003` [kontrollere_antall_tilbud.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/kontrollere_antall_tilbud.feature) | Should | [Mockup: Antall tilbud](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | – | Søk, filter og sortering, varsel ved overskridelse og HK-dirs kontroll. Skilt ut fra `@OPT-PLA-INN-001` 2026-10-28. Verify: 1/10 |
| (ikke tildelt) | `@OPT-PLA-SVA-002` [varsler_og_meldinger_i_plasstildelingen.feature](../../krav/02%20Opptak/14%20Plasstildeling/05%20Svar/varsler_og_meldinger_i_plasstildelingen.feature) | Should | – | – | Varsler til lærestedene og meldinger til søkerne. Skilt ut 2026-10-28, sendes på e-post i dag. Verify: 0/5 |
| (ikke tildelt) | `@OPT-PLA-RES-004` [se_resultatet_som_søker.feature](../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_resultatet_som_s%C3%B8ker.feature) | Could | – | – | Se resultatet slik søkeren ser det, før og etter publisering. Skilt ut 2026-10-28. Verify: 0/3 |
| (ikke tildelt) | `@OPT-PLA-RES-005` [planlegge_publisering.feature](../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/planlegge_publisering.feature) | Could | – | – | Planlagt publisering. Skilt ut 2026-10-28. Verify: 0/1 |
| (ikke tildelt) | `@OPT-REG-RUN-002` [forvalte_rundetyper.feature](../../krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/forvalte_rundetyper.feature) | Could | [Mockup: Rundetyper](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | – | Legge til, endre og slette rundetyper i regelverkssamlingen. Skilt ut fra `@OPT-REG-RUN-001` 2026-10-29 |

## Åpne spørsmål

- [ ] Regresjonstest av plasstildelingen sto som gjenstående på workshopen 2026-09-14, men har ikke krav. Hvor hører den hjemme?
- [ ] De tre oppgavene mangler Jira-saker. Kjør `jira-overlapp-sjekk` før nye saker lages (sakene som finnes for kravene, er TAKE-327 til TAKE-331).
- [ ] Feil i koden fra verifiseringen 2026-10-28, som bør meldes uavhengig av oppgavene: redigering av en publisert runde nullstiller publiseringen, og tilgangen til resultatet og opptakssvarene gjelder hele opptaket (se `## Oppfølging` i verify-rapporten).
