# Scope: Plasstildeling 2027

- **Slug**: plasstildeling-2027
- **Initiativ**: [#216](https://github.com/sikt-no/fs/issues/216)
- **Eier**: –
- **Siste oppdatering**: 2026-10-15

## Mål

- Opptaksforvalter kan opprette plasstildelingsrunder, sette antall tilbud, starte og gjennomføre plasstildelinger, kontrollere og publisere resultatet.
- Saksbehandler og søker ser det publiserte resultatet, og søkeren kan svare på tilbud og ventelisteplass.
- Klar for første samordna opptak 2027. Produksjonsfrist 8. desember 2026.

## Ikke-mål

- Automatiske nye tilbud ved nei-svar mellom plasstildelingsrundene (oppgave 10, Won't 2027).
- Vedtaksformidling (svarmelding, påminnelse, åpnet vedtak, digital postkasse og hendelseslogg). Det blir en egen oppgave og et eget scope senere, se [vedtaksformidling](vedtaksformidling/).
- Å sette standard plassflyt og kvoteprioritet for opptaket (`@OPT-OVO-INN-002` og `@OPT-OVO-INN-003`). De er flyttet til [scope-kvoter-i-opptaket-2027](scope-kvoter-i-opptaket-2027.md) 2026-10-15, så de kan leveres før plasstildelingen. Hva plasstildelingen gjør med dem, er fortsatt her.
- Regelverk, rangering og kvalifisering. De kommer fra søknadsbehandlingen og regelverket, ikke fra plasstildelingen.

## Kilder

- [GitHub #216](https://github.com/sikt-no/fs/issues/216) — initiativet «Ferdigstilling av plasstildeling i opptak».
- [oppgave.md](plasstildeling/oppgave.md) — workshop 2026-09-14 (utsatt til 8. desember) og funksjonell løsning per oppgave. Oppgavetabellen er flyttet hit.
- [design.md](plasstildeling/design.md) — mål, prinsipper, rundetyper, gap-analyse mot koden og avklaringer.
- [Jira TAKE-3](https://sikt.atlassian.net/browse/TAKE-3) — epic.
- [Confluence: T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377) — bakgrunn.
- [Confluence: 2026-10-14 Åpne spørsmål: plasstildeling i FS-Admin (designarbeid)](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5105025045) — spørsmål og beslutninger fra designarbeidet, med svarene fra kravarbeidet.

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [plasstildeling](plasstildeling/) | `@OPT-PLA-RUN-001` [forvalte_runder.feature](../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) | Must | – | [#216](https://github.com/sikt-no/fs/issues/216) | Oppgave 1: legge til runder for plasstildeling. Kode etter workshop 2026-09-14: løst |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-INN-001` [antall_tilbud_som_skal_gis.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature) | Must | – | [#583](https://github.com/sikt-no/fs/issues/583) | Oppgave 2: antall tilbud som skal gis per utdanningskvote. Jira [TAKE-327](https://sikt.atlassian.net/browse/TAKE-327). Kode: gjenstår |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-INN-002` [plassflyt.feature](../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/plassflyt.feature) | Must | – | [#216](https://github.com/sikt-no/fs/issues/216) | Oppgave 3: plassflyt ved ledige plasser per utdanningskvote. Kode: løst |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-TIL-001` [starte_plasstildeling.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/starte_plasstildeling.feature) | Must | – | [#216](https://github.com/sikt-no/fs/issues/216) | Oppgave 4: starte en plasstildeling. Kode: løst |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-TIL-002` [gjennomføre_plasstildeling.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature) | Must | – | [#216](https://github.com/sikt-no/fs/issues/216) | Oppgave 5: gjennomføre plasstildeling. Kode: løst |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-TIL-003` [kompensasjonstilbud_ved_opprykk.feature](../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/kompensasjonstilbud_ved_opprykk.feature) | Must | – | [#584](https://github.com/sikt-no/fs/issues/584) | Oppgave 6: kompensasjonstilbud ved opprykk i supplering. Jira [TAKE-328](https://sikt.atlassian.net/browse/TAKE-328). Kode: gjenstår |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-RES-001` [vise_resultat.feature](../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/vise_resultat.feature) | Must | – | [#585](https://github.com/sikt-no/fs/issues/585) | Oppgave 7: resultatet før publisering, for opptaksforvalter. Jira [TAKE-329](https://sikt.atlassian.net/browse/TAKE-329). Kode: gjenstår |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-RES-003` [se_publisert_resultat.feature](../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_publisert_resultat.feature) | Must | – | [#585](https://github.com/sikt-no/fs/issues/585) | Oppgave 7: det publiserte resultatet, for saksbehandler. Jira [TAKE-329](https://sikt.atlassian.net/browse/TAKE-329). Kode: gjenstår |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-RES-002` [publisere_resultat.feature](../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/publisere_resultat.feature) | Must | – | [#586](https://github.com/sikt-no/fs/issues/586) | Oppgave 8: publisere resultatet til søkerne. Jira [TAKE-330](https://sikt.atlassian.net/browse/TAKE-330). Kode: delvis |
| [plasstildeling](plasstildeling/) | `@OPT-PLA-SVA-001` [håndtere_svar_fra_søker.feature](../../krav/02%20Opptak/14%20Plasstildeling/05%20Svar/h%C3%A5ndtere_svar_fra_s%C3%B8ker.feature) | Must | – | [#587](https://github.com/sikt-no/fs/issues/587) | Oppgave 9: håndtere svar fra søker. Jira [TAKE-331](https://sikt.atlassian.net/browse/TAKE-331). Kode: delvis |

## Åpne spørsmål

- [ ] Regresjonstest av plasstildelingen sto som gjenstående på workshopen 2026-09-14, men har ikke krav. Hvor hører den hjemme?
