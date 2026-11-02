# Scope: Automatisk saksbehandling

- **Slug**: automatisk-saksbehandling
- **Initiativ**: [#199](https://github.com/sikt-no/fs/issues/199)
- **Eier**: –
- **Siste oppdatering**: 2026-11-02

## Mål

- Hele flyten `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) leveres: fra søknaden er blitt en sak hos den saksbehandlende organisasjonen, til saken er ferdig behandlet og klar til å være med i plasstildelingen, uten at en saksbehandler har gjort noe.
- Oppgavene følger fasene i flyten: import og start, GSK-konklusjon, grunnlag og poeng, kvalifisering og poengsum per kvote, mangler og ferdig behandlet, og beregning på nytt når regelverket er rettet.
- De kjente bruddene i flyten lukkes: den automatiske behandlingen starter av seg selv når resultatene er importert (`@OPT-BEH-BEH-032`), GSK beregnes når vitnemålet importeres og bruker skolens påstand (`@OPT-BEH-BEH-015`), og saken settes til ferdig behandlet (`@OPT-BEH-BEH-025`).

## Ikke-mål

- To faser i flyten er `@wont` i første fase: to identiske vitnemål som regnes som ett vitnemål, og automatisk dobbeltrangering etter 23/5-regelen (FOL-37, STEK-251). De står i flyten så de blir med i neste fase.
- Variantene av flyten: automatisk saksbehandling på vitnemålet saksbehandleren velger (`@FLY-OPT-VAL-001`) og på sammensatt vitnemål (`@FLY-OPT-SAM-001`). Begge er `@draft`, og bygger på denne flyten.
- Plasstildelingen (`@OPT-PLA-TIL-001`, [scope-plasstildeling-2027](scope-plasstildeling-2027.md)).
- Forutsetninger som ikke endres i scopet:
  - Saksbehandlertildelingen (`@FLY-OPT-SAK-001`, `@OPT-BEH-BEH-011`): flyten starter når saken er opprettet.
  - Regelverket flyten bygger på: `@OPT-REG-RAN-001`, `@OPT-REG-RAN-002`, `@OPT-REG-KVO-001` og `@OPT-REG-KVO-002`, alle `@implemented` i [scope-regelverk-2027](scope-regelverk-2027.md).

## Levert fra før

Faser i flyten som er levert, og som ikke har oppgaver i scopet. Kravene har ikke scope-taggen, fordi ingenting i dem endres.

- `@OPT-BEH-BEH-012` [automatisk_kvoteplassering.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_kvoteplassering.feature) (`@implemented`, 16 av 16 scenarioer funnet i `verify-automatisk_kvoteplassering-2026-10-22-1233.md`) dekker fasene «Kvotespørsmålene med algoritme besvares automatisk» og «Søkeren fordeles på kvoter når kvalifiseringen og kvotesvarene er satt». Begge fasene er levert i verify-rapporten for flyten fra 2026-10-30. Initiativ [FOL-38](https://sikt.atlassian.net/browse/FOL-38) «Automatisk plassering i kvote».

## Kilder

- `@FLY-OPT-AUT-001` [automatisk_saksbehandling.feature](../../krav/_Flyter/10%20Opptaksl%C3%B8pet/automatisk_saksbehandling.feature) — flyten, med fasene, overleveringene og de kjente bruddene
- [GitHub #199](https://github.com/sikt-no/fs/issues/199) — «Automatisk saksbehandling av søknader om opptak til grunnutdanning», initiativet, med suksesskriteriene. Også issuet til `@OPT-BEH-BEH-020`. Sub-issues: [#376](https://github.com/sikt-no/fs/issues/376) «Automatisering av kvoter» og [#386](https://github.com/sikt-no/fs/issues/386) «Automatisk poengberegning av ikke-vitnemålsrelaterte (HØY, FAG)», og POC-ene for poengberegning (#373, #374, #375, lukket)
- [GitHub #723](https://github.com/sikt-no/fs/issues/723) «Automatisk GSK-konklusjon» og [#413](https://github.com/sikt-no/fs/issues/413) — issuene til `@OPT-BEH-BEH-015` og `@OPT-BEH-BEH-008`
- [GitHub #61](https://github.com/sikt-no/fs/issues/61) — «Automatisk innhente resultater i søknadsflyten», som passer med import og start
- [GitHub #562](https://github.com/sikt-no/fs/issues/562) — «Automatisk velge det vitnemålet eller den fagkombinasjonen som er til gunst for søker». Utenfor scope: flyten gjelder søkere med ett vitnemål
- Initiativene i «Produktet FS» (milepælsplanen, team Puff, akseptansetest 2026-11-30 på dem som er sjekket): [FOL-33](https://sikt.atlassian.net/browse/FOL-33) GSK-konklusjon, [FOL-34](https://sikt.atlassian.net/browse/FOL-34) grunnlag, [FOL-35](https://sikt.atlassian.net/browse/FOL-35) kvalifisering på kravelementer, [FOL-36](https://sikt.atlassian.net/browse/FOL-36) poengberegning av elektronisk vitnemål, [FOL-38](https://sikt.atlassian.net/browse/FOL-38) plassering i kvote, [FOL-39](https://sikt.atlassian.net/browse/FOL-39) tilleggspoeng, [FOL-40](https://sikt.atlassian.net/browse/FOL-40) behandlingsstatus «Behandlet»
- [STEK-529](https://sikt.atlassian.net/browse/STEK-529), [STEK-527](https://sikt.atlassian.net/browse/STEK-527) og [STEK-528](https://sikt.atlassian.net/browse/STEK-528) — logging, audit og endringslogg for den automatiske saksbehandlingen. Gjelder hele løpet
- [STEK-218](https://sikt.atlassian.net/browse/STEK-218) — kontrollmotoren brukes til poeng og kravelementer i opptak (Done)

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [automatisk-import-og-start](automatisk-import-og-start/) | `@OPT-BEH-BEH-030` [importere_resultater_fra_kreg.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/importere_resultater_fra_kreg.feature) | Must | – | [STEK-330](https://sikt.atlassian.net/browse/STEK-330) | |
| [automatisk-import-og-start](automatisk-import-og-start/) | `@OPT-BEH-BEH-032` [starte_automatisk_behandling.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/starte_automatisk_behandling.feature) | Must | – | – | Ingen Jira-sak dekker at den automatiske behandlingen starter av seg selv |
| [automatisk-gsk-konklusjon](automatisk-gsk-konklusjon/) | `@OPT-BEH-BEH-015` [automatisk_gsk_konklusjon.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_gsk_konklusjon.feature) | Must | – | [STEK-249](https://sikt.atlassian.net/browse/STEK-249) | Også STEK-440, STEK-443 og STEK-526. Initiativ FOL-33 |
| [automatisk-gsk-konklusjon](automatisk-gsk-konklusjon/) | `@OPT-BEH-BEH-027` [beregne_gsk_fra_vitnemål.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_gsk_fra_vitnem%C3%A5l.feature) | Must | – | [STEK-249](https://sikt.atlassian.net/browse/STEK-249) | Kontrollmotoren beregner opptakssystemets påstand om GSK |
| [automatisk-grunnlag-og-poeng](automatisk-grunnlag-og-poeng/) | `@OPT-BEH-BEH-019` [automatisk_grunnlag.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_grunnlag.feature) | Must | – | – | Feil: STEK-514. Initiativ FOL-34 |
| [automatisk-grunnlag-og-poeng](automatisk-grunnlag-og-poeng/) | `@OPT-BEH-BEH-018` [automatisk_poengberegning.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_poengberegning.feature) | Must | – | – | Initiativ FOL-36 |
| [automatisk-grunnlag-og-poeng](automatisk-grunnlag-og-poeng/) | `@OPT-BEH-BEH-028` [automatiske_tilleggspoeng.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatiske_tilleggspoeng.feature) | Must | – | – | Feil: STEK-507. Gjenbruk: STEK-250. Initiativ FOL-39 |
| [automatisk-kvalifisering-og-poengsum](automatisk-kvalifisering-og-poengsum/) | `@OPT-BEH-BEH-020` [automatisk_kvalifisering.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/automatisk_kvalifisering.feature) | Must | – | – | Også STEK-640. Initiativ FOL-35 |
| [automatisk-kvalifisering-og-poengsum](automatisk-kvalifisering-og-poengsum/) | `@OPT-BEH-BEH-031` [beregne_poengsum_per_kvote.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_poengsum_per_kvote.feature) | Must | – | – | STEK-650 dekker bare at det vises hvorfor poengsummen ikke kan regnes ut. Kvoteplasseringen er levert (se *Levert fra før*) |
| [automatisk-ferdigbehandling](automatisk-ferdigbehandling/) | `@OPT-BEH-BEH-008` [søknadsmangler.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/s%C3%B8knadsmangler.feature) | Must | – | – | Bare de automatiske mangeltekstene og mangelen for GSK som fullføres i vår er med i flyten |
| [automatisk-ferdigbehandling](automatisk-ferdigbehandling/) | `@OPT-BEH-BEH-029` [behandlingsstatus.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/behandlingsstatus.feature) | Must | – | [STEK-253](https://sikt.atlassian.net/browse/STEK-253) | Initiativ FOL-40 |
| [automatisk-ferdigbehandling](automatisk-ferdigbehandling/) | `@OPT-BEH-BEH-025` [ferdigbehandle_sak.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/ferdigbehandle_sak.feature) | Must | – | [STEK-253](https://sikt.atlassian.net/browse/STEK-253) | Initiativ FOL-40 |
| [beregne-automatisk-pa-nytt](beregne-automatisk-pa-nytt/) | `@OPT-BEH-BEH-026` [beregne_automatisk_på_nytt.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/beregne_automatisk_p%C3%A5_nytt.feature) | Must | – | [STEK-651](https://sikt.atlassian.net/browse/STEK-651) | |

## Åpne spørsmål

- [ ] `@OPT-BEH-BEH-008` (søknadsmangler) er et stort krav, og bare to regler er med i flyten. Skal hele kravet være i scopet, eller bare delene flyten bygger på?
- [ ] Oppgavene `automatisk-grunnlag-og-poeng` og `automatisk-kvalifisering-og-poengsum` har ingen Jira-sak, og `@OPT-BEH-BEH-032` har ingen sak. Skal Puff lage saker, eller skal oppgavene kobles til de eksisterende? Jira endres ikke før det er avtalt.
- [ ] [STEK-540](https://sikt.atlassian.net/browse/STEK-540) «avvis manuell lagring av svar på kvotespørsmål med koblet algoritme» er åpen (Backlog), mens STEK-538 om det samme er Done, og verify fant regelen i `@OPT-BEH-BEH-012` i koden. Er STEK-540 en rest som kan lukkes, eller mangler sperren i backend? Ikke sjekket i koden.
- [ ] FOL-38 «Automatisk plassering i kvote» står i milepælsplanen med akseptansetest, men kravet er levert. Skal initiativet lukkes, eller bare testes sammen med flyten?
- [ ] FOL-33 lenker til `@OPT-REG-KRA-001`, og FOL-40 lenker til `@OPT-BEH-BEH-001`, ikke til kravene i dette scopet. Skal lenkene i Jira rettes?
