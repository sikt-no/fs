# Scope: Plasstildeling 2027

- **Slug**: plasstildeling-2027 (= navnet på mappa og taggen `@scope-plasstildeling-2027`)
- **Domene**: opptak (se [`../../README.md`](../../README.md#domener))
- **Initiativ**: [#216](https://github.com/sikt-no/fs/issues/216)
- **Jira**: [sikt-no/fs#216](https://github.com/sikt-no/fs/issues/216)
- **Eier**: –
- **Siste oppdatering**: 2026-11-05

## Mål

- Opptaksforvalter kan opprette plasstildelingsrunder, sette antall tilbud, starte og gjennomføre plasstildelinger, kontrollere og publisere resultatet.
- Plasstildelingen bruker rundetypene hovedtildeling, supplering og etterfylling, som er felles for alle opptak (avklart 2026-11-04, ikke en del av regelverkssamlingen), med innstillingene plasstildelingen leser. Plasstildelingen ser aldri på hvilken rundetype det er (avklart 2026-10-24). Samordna opptak (UHG og HYU) får de tre rundetypene med samme oppførsel som før.
- Saksbehandler og søker ser det publiserte resultatet, og søkeren kan svare på tilbud og ventelisteplass.
- Klar for de samordna opptakene 2027. Produksjonsfrist januar 2027 (endret 2026-11-04, var 8. desember 2026).
- Leveres i tre oppgaver, i denne rekkefølgen (delt 2026-10-28): rundetyper og runder, gjennomføre plasstildelingen, og publisere og svare på tilbud. Kravene med `@should` og `@could` står som «(ikke tildelt)» til de prioriteres.

## Ikke-mål

- Automatiske nye tilbud ved nei-svar mellom plasstildelingsrundene (oppgave 10, Won't 2027).
- Vedtaksformidling (svarmelding, påminnelse, åpnet vedtak, digital postkasse og hendelseslogg). Det blir en egen oppgave og et eget scope senere, se [vedtaksformidling](../vedtaksformidling/).
- Å sette standard plassflyt og kvoteprioritet (`@OPT-REG-KVO-003` og `@OPT-REG-KVO-004`, før `@OPT-OVO-INN-002` og `@OPT-OVO-INN-003`). De settes i regelverkssamlingen (avklart 2026-10-21). De er flyttet til [scope-kvoter-i-opptaket-2027](../kvoter-i-opptaket-2027/scope.md) 2026-10-15, så de kan leveres før plasstildelingen. Hva plasstildelingen gjør med dem, er fortsatt her.
- At lærestedene melder feil i resultatet til opptakets forvalter i løsningen (Could, senere). E-post er godt nok nå, så lenge opptakets forvalter kan endre antall tilbud etter lærestedenes periode (avklart med domeneekspert 2026-10-15, og på nytt etter brukertesten med HK-dir 2026-10-28).
- Varsler og meldinger fra løsningen i plasstildelingen. De sendes på e-post utenfor løsningen i dag (avklart 2026-10-28). Kravet står som `@should` under «(ikke tildelt)».
- Regelverk, rangering og kvalifisering. De kommer fra søknadsbehandlingen og regelverket, ikke fra plasstildelingen. Unntaket er rundetypene (`@OPT-REG-RUN-001`), som plasstildelingen trenger nå.
- Å forvalte rundetypene: legge til, endre og slette rundetyper i regelverkssamlingen (`@OPT-REG-RUN-002`, Could). Plasstildelingen bruker rundetypene som finnes (avklart 2026-10-29). Kravet står under «(ikke tildelt)».

## Kilder

- [GitHub #216](https://github.com/sikt-no/fs/issues/216) — initiativet «Ferdigstilling av plasstildeling i opptak».
- [scope.md](scope.md) — workshop 2026-09-14 (utsatt til 8. desember) og funksjonell løsning per oppgave. Mappa var oppgaven for hele scopet til 2026-10-28, og står igjen som kilde.
- [plasstildeling/design.md](design.md) — mål, prinsipper, rundetyper, gap-analyse mot koden og avklaringer.
- [Jira TAKE-3](https://sikt.atlassian.net/browse/TAKE-3) — epic.
- [Confluence: T3 2026 Forberede opptak og etterbehandling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4981817377) — bakgrunn.
- [Confluence: 2026-10-14 Åpne spørsmål: plasstildeling i FS-Admin (designarbeid)](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5105025045) — spørsmål og beslutninger fra designarbeidet, med svarene fra kravarbeidet.
- [Confluence: 2026-10-27 Plasstildeling med HK-dir](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147492374) — notatene fra brukertestene med HK-dir (oktober 2026).
- [Mockup: Plasstildeling 2027](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) — rundetyper i regelverkssamlingen, runder, antall tilbud og resultat, oppdatert etter brukertestene 2026-10-28. Privat til den deles.
- [Prototype: Plasstildeling – følger STA-92 (v88)](https://claude.ai/artifact/PtEVDPyFrsWodTZPu9mfA9) — runder, antall tilbud og lærestedets oppgaver. Gått gjennom mot kravene 2026-11-02 ([PR #907](https://github.com/sikt-no/fs/pull/907)).
- [krav/_kravanalyser/hk-dir-krav-dekning.md](../../../krav/_kravanalyser/hk-dir-krav-dekning.md) — HK-dirs krav mot kravene for opptak.
- [verify-2026-10-28-1645.md](../../../akseptansetest/plasstildeling-2027/verify-2026-10-28-1645.md) — verifisering av alle kravene mot koden, uansett status: hva som finnes og mangler per krav og repo. 51 av 170 scenarioer funnet.

## Krav

| Krav | MoSCoW | Skisse | Jira | Kommentar |
|---|---|---|---|---|
| `@OPT-REG-RUN-001` [bruke_rundetyper.feature](../../../krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/bruke_rundetyper.feature) | Must | [Mockup: Rundetyper](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | [#216](https://github.com/sikt-no/fs/issues/216) | Hovedtildeling, supplering og etterfylling med innstillingene plasstildelingen leser. Forvaltningen er skilt ut i `@OPT-REG-RUN-002` (2026-10-29). Verify 2026-10-28: rundetypene er et fast kodeverk uten innstillinger |
| `@OPT-PLA-RUN-001` [forvalte_runder.feature](../../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/forvalte_runder.feature) | Must | [Prototype v88: Runder](https://claude.ai/artifact/PtEVDPyFrsWodTZPu9mfA9) | [#216](https://github.com/sikt-no/fs/issues/216) | Legge til runder, med innstillingene fra rundetypen. Verify: 6/23 — bare hovedrunde kan velges i fs-admin, og redigering nullstiller publiseringen |
| `@OPT-PLA-RUN-002` [listevisning_og_søk_i_plasstildelingsrunder.feature](../../../krav/02%20Opptak/14%20Plasstildeling/01%20Runder/listevisning_og_s%C3%B8k_i_plasstildelingsrunder.feature) | Must | [Prototype v88: Runder](https://claude.ai/artifact/PtEVDPyFrsWodTZPu9mfA9) | [#216](https://github.com/sikt-no/fs/issues/216) | Oversikten over plasstildelingsrundene med søk og filter på rundetype, status og periode. Ny 2026-11-04 |
| `@OPT-PLA-INN-001` [antall_tilbud_som_skal_gis.feature](../../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature) | Must | [Prototype v88: Antall tilbud](https://claude.ai/artifact/PtEVDPyFrsWodTZPu9mfA9) | [#583](https://github.com/sikt-no/fs/issues/583) | Antall tilbud som skal gis per utdanningskvote i runden. Jira [TAKE-327](https://sikt.atlassian.net/browse/TAKE-327). Verify: 2/21 — settes for hele opptaket, og perioden håndheves ikke |
| `@OPT-PLA-INN-002` [plassflyt.feature](../../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/plassflyt.feature) | Must | – | [#216](https://github.com/sikt-no/fs/issues/216) | Plassflyt ved ledige plasser per utdanningskvote. Verify: 7/8 — en mottaker som mangler, stopper kjøringen |
| `@OPT-PLA-TIL-001` [starte_plasstildeling.feature](../../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/starte_plasstildeling.feature) | Must | [Mockup: Plasstildeling](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | [#216](https://github.com/sikt-no/fs/issues/216) | Starte en plasstildeling. Verify: 3/12 — ikke styrt av rundetypen, og ingen filter på ferdig behandlet |
| `@OPT-PLA-TIL-002` [gjennomføre_plasstildeling.feature](../../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/gjennomf%C3%B8re_plasstildeling.feature) | Must | – | [#216](https://github.com/sikt-no/fs/issues/216) | Gjennomføre plasstildeling. Verify: 11/36 — kjernen finnes; innstillingene fra rundetypen, tilbudsgaranti fra saksbehandlingen, SPEV og poenggrense mangler |
| `@OPT-PLA-TIL-003` [kompensasjonstilbud_ved_opprykk.feature](../../../krav/02%20Opptak/14%20Plasstildeling/03%20Tildeling/kompensasjonstilbud_ved_opprykk.feature) | Must | – | [#584](https://github.com/sikt-no/fs/issues/584) | Kompensasjonstilbud ved opprykk. Jira [TAKE-328](https://sikt.atlassian.net/browse/TAKE-328). Verify: 0/4 — skjer i alle runder, ikke styrt av rundetypen |
| `@OPT-PLA-RES-001` [vise_resultat.feature](../../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/vise_resultat.feature) | Must | [Mockup: Resultat](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | [#585](https://github.com/sikt-no/fs/issues/585) | Resultatet før publisering, så plasstildelingen kan kontrolleres og testes. Jira [TAKE-329](https://sikt.atlassian.net/browse/TAKE-329). Verify: 7/16 — tilgangen gjelder hele opptaket, og sammenligning og poenggrense mangler |
| `@OPT-PLA-RES-002` [publisere_resultat.feature](../../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/publisere_resultat.feature) | Must | – | [#586](https://github.com/sikt-no/fs/issues/586) | Publisere resultatet til søkerne. Jira [TAKE-330](https://sikt.atlassian.net/browse/TAKE-330). Verify: 4/8 — ventelistenummeret når ikke fram til søkeren |
| `@OPT-PLA-RES-003` [se_publisert_resultat.feature](../../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_publisert_resultat.feature) | Must | – | [#585](https://github.com/sikt-no/fs/issues/585) | Det publiserte resultatet, for saksbehandler. Jira [TAKE-329](https://sikt.atlassian.net/browse/TAKE-329). Verify: 4/9 — avgrensning per organisasjon og poenggrense mangler |
| `@OPT-PLA-SVA-001` [håndtere_svar_fra_søker.feature](../../../krav/02%20Opptak/14%20Plasstildeling/05%20Svar/h%C3%A5ndtere_svar_fra_s%C3%B8ker.feature) | Must | – | [#587](https://github.com/sikt-no/fs/issues/587) | Håndtere svar fra søker. Jira [TAKE-331](https://sikt.atlassian.net/browse/TAKE-331). Verify: 6/9 — det som gjelder etterfylling, mangler |
| `@OPT-PLA-INN-003` [kontrollere_antall_tilbud.feature](../../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/kontrollere_antall_tilbud.feature) | Should | [Prototype v88: Antall tilbud](https://claude.ai/artifact/PtEVDPyFrsWodTZPu9mfA9) | – | Ikke tildelt en sak. Søk, filter og sortering, varsel ved overskridelse og HK-dirs kontroll. Skilt ut fra `@OPT-PLA-INN-001` 2026-10-28. Verify: 1/10 |
| `@OPT-PLA-INN-004` [følge_opp_lærestedenes_gjennomgang.feature](../../../krav/02%20Opptak/14%20Plasstildeling/02%20Tildelingsinnstillinger/f%C3%B8lge_opp_l%C3%A6restedenes_gjennomgang.feature) | Could | [Prototype v88: Antall tilbud](https://claude.ai/artifact/PtEVDPyFrsWodTZPu9mfA9) | – | Ikke tildelt en sak. Varsle lærestedene, markere at antall tilbud er gått gjennom, og status per lærested. Ny 2026-11-02 (prototypen v88). Varslingen av lærestedene er flyttet hit fra `@OPT-PLA-SVA-002` |
| `@OPT-PLA-SVA-002` [varsler_og_meldinger_i_plasstildelingen.feature](../../../krav/02%20Opptak/14%20Plasstildeling/05%20Svar/varsler_og_meldinger_i_plasstildelingen.feature) | Should | – | – | Ikke tildelt en sak. Meldinger til søkerne. Varslingen av lærestedene er flyttet til `@OPT-PLA-INN-004` (2026-11-02). Skilt ut 2026-10-28, sendes på e-post i dag. Verify: 0/5 |
| `@OPT-PLA-RES-004` [se_resultatet_som_søker.feature](../../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/se_resultatet_som_s%C3%B8ker.feature) | Could | – | – | Ikke tildelt en sak. Se resultatet slik søkeren ser det, før og etter publisering. Skilt ut 2026-10-28. Verify: 0/3 |
| `@OPT-PLA-RES-005` [planlegge_publisering.feature](../../../krav/02%20Opptak/14%20Plasstildeling/04%20Resultat/planlegge_publisering.feature) | Could | – | – | Ikke tildelt en sak. Planlagt publisering. Skilt ut 2026-10-28. Verify: 0/1 |
| `@OPT-REG-RUN-002` [forvalte_rundetyper.feature](../../../krav/02%20Opptak/10%20Regelverk/06%20Rundetyper/forvalte_rundetyper.feature) | Could | [Mockup: Rundetyper](https://claude.ai/artifact/5VkngKFsP2xtmqmCyKxcDU) | – | Ikke tildelt en sak. Legge til, endre og slette rundetyper i regelverkssamlingen. Skilt ut fra `@OPT-REG-RUN-001` 2026-10-29 |

## Åpne spørsmål

- [ ] Regresjonstest av plasstildelingen sto som gjenstående på workshopen 2026-09-14, men har ikke krav. Hvor hører den hjemme?
- [ ] De tre oppgavene mangler Jira-saker. Kjør `jira-overlapp-sjekk` før nye saker lages (sakene som finnes for kravene, er TAKE-327 til TAKE-331).
- [ ] Feil i koden fra verifiseringen 2026-10-28, som bør meldes uavhengig av oppgavene: redigering av en publisert runde nullstiller publiseringen, og tilgangen til resultatet og opptakssvarene gjelder hele opptaket (se `## Oppfølging` i verify-rapporten).

## Rundetyper og plasstildelingsrunder (fra oppgaven plasstildeling-rundetyper-og-runder)


Rundetypene med innstillinger i regelverkssamlingen, plasstildelingsrundene i opptaket med innstillingene fra rundetypen, og antall tilbud som skal gis per utdanningskvote i runden. Første leveranse i plasstildelingen: det plasstildelingen leser.

### Åpne punkter

- Jira-sak mangler. Kjør `jira-overlapp-sjekk` før en ny sak lages (sakene for kravene er TAKE-327 for antall tilbud).

## Gjennomføre plasstildelingen (fra oppgaven gjennomfore-plasstildeling)


Starte og gjennomføre plasstildelingen etter innstillingene i runden, med plassflyt, kompensasjonstilbud og tilbudsgaranti, og se resultatet før det publiseres. Bygger på rundetyper og runder.

### Åpne punkter

- Jira-sak mangler. Kjør `jira-overlapp-sjekk` før en ny sak lages (sakene for kravene er TAKE-328 for kompensasjonstilbud og TAKE-329 for resultatet).

## Publisere resultatet og svare på tilbud (fra oppgaven publisere-og-svare-pa-tilbud)


Publisere resultatet til søkerne, la saksbehandlerne se det publiserte resultatet, og la søkerne svare på tilbud og ventelisteplass, så svarene brukes i neste runde. Bygger på at plasstildelingen er gjennomført.

### Åpne punkter

- Jira-sak mangler. Kjør `jira-overlapp-sjekk` før en ny sak lages (sakene for kravene er TAKE-329 for det publiserte resultatet, TAKE-330 for publisering og TAKE-331 for svar).

## Plasstildeling (fra oppgaven plasstildeling)

Jira: [sikt-no/fs#216](https://github.com/sikt-no/fs/issues/216)


Ferdigstille plasstildeling i opptak slik at opptaksforvalter kan opprette runder, kjøre plasstildelinger, publisere resultat til søker, og håndtere svar — klar for første samordna opptak 2027.

### Oppgaver

Oppgavetabellen er flyttet til [scope-plasstildeling-2027](scope.md) 2026-10-14. Scope-tabellen er kilden til kravene. 2026-10-28 ble scopet delt i tre oppgaver: [plasstildeling-rundetyper-og-runder](./), [gjennomfore-plasstildeling](./) og [publisere-og-svare-pa-tilbud](./). Denne mappa står igjen som kilde (design.md og workshopen).

### Workshop 2026-09-14: oppgavedeling og status

**Produksjonsfrist:** 8. des 2026 (utsatt, godkjent av Tina)

Plasstildeling utsettes fordi opptak, regelverk og utdanningstilbud har prioritet til 1. november.

**Løst:**
- Beregne plassflyt ved ledige plasser per utdanningskvote
- Starte plasstildeling
- Gjennomføre plasstildeling

**Gjenstår:**
- Innføre kompensasjonstilbud ved opprykk (suppleringsrunder)
- Regresjonstest av plasstildelingen
- Vise resultat til saksbehandler
- Publisere svar til søker / sende svarmelding
- Motta og behandle svar fra søker (svar behandles i neste plasstildelingsrunde)

**Avhengigheter:**
- Endringer i søknadsbehandling kan påvirke plasstildelingen — tett dialog nødvendig

### Funksjonell løsning per oppgave

#### Oppgave 1 — legge til runder for plasstildeling i ett opptak

Opptaksrunder opprettes sammen med opptaket og knyttes til ett opptak. Grunnlagsdata er navn, rundetype og svarfrist.

**Figma-prototype:** https://twins-gave-22504012.figma.site/

**Issue:** [#107](https://github.com/sikt-no/fs/issues/107) (lukket)

#### Oppgave 2 — beregne antall tilbud per utdanningskvote fra relativ fordeling

**Dagens kode:** Antall tilbud settes absolutt per utdanningskvote (`overbook_antall_plasser`). Saksbehandler setter tallet manuelt for hver utdanningskvote.

**Besluttet ny løsning:** Lærestedet setter totalt antall tilbud og relativ fordeling (prosent) per utdanningskvote på utdanningstilbudet. Plasstildelingen beregner absolutte tall fra den relative fordelingen. Se [utdanningstilbud/design.md](../utdanningstilbud-2027/design.md).

I tillegg kan lærestedet ved hver plasstildelingsrunde sette antall ønskede tilbud for runden, samt antall ønskede ja-svar (overbooking) for suppleringsrunder. Disse settes per plasstildelingsrunde, ikke på utdanningstilbudet.

**Begrepsendring:** feltnavnet «overbooking» skal endres til «antall ønskede ja-svar».

**Figma-prototype:** https://undo-aloft-06472321.figma.site/

#### Oppgave 3 — sette plassflyt mellom utdanningskvoter

Plassflyt mellom utdanningskvoter på samme utdanningstilbud virker, inkludert flere ledd etter hverandre.

Det som ikke er mulig: en utdanningskvote kan bare sende ledige plasser videre til én mottakende utdanningskvote, plasser kan ikke flyte mellom ulike utdanningstilbud, og de kan ikke flyte fra én plasstildeling til en senere.

#### Oppgave 4 — starte en ny plasstildeling

Man bestiller en plasstildeling, og den kjøres automatisk i bakgrunnen. Den bygger riktig videre på forrige publiserte runde.

**Åpent:** i hvilken grad utledes starten på en runde fra datoene som er satt i opptaket? Setter man dato for rundene og lar systemet starte tildelingen, eller er det en startknapp noen må trykke på? Svaret avgjør om «start» er en handling eller en tilstand.

**Svakhet:** feiler en plasstildeling, er eneste mulighet å starte en helt ny. Det finnes ingen måte å rette opp eller kjøre den samme på nytt.

**Issue:** [#108](https://github.com/sikt-no/fs/issues/108) (lukket)

#### Oppgave 5 — gjennomføre plasstildeling

Tildelingen avgjør hvor mange søkere som får plass i hver utdanningskvote, og hva poenggrensen for å komme inn ble. Den må ta hensyn til plassflyt mellom utdanningskvoter, og til at noen utdanningskvoter kan gi tilbud til alle kvalifiserte uten poenggrense. Tilbudsgarantier tas fra den utdanningskvoten lærestedet eller HK-dir har markert.

Søkeren prøves i utdanningskvotene etter kvoteprioritet — normalt den mest spesielle utdanningskvoten først, den minst spesielle sist.

Rangeringen hentes fra søknadsbehandlingen. Hver søker som er kvalifisert til en utdanningskvote får beregnet poengsum og rangering der, slik at det er tydelig hvem som står først i køen. Selve rangeringen og poengberegningen virker, men systemet fanger ikke opp at en søker har endret søknaden sin mellom runder, og en søker som mister kvalifiseringen forsvinner stille fra resultatet i stedet for å få et tydelig avslag (bryter prinsipp 1).

Selve tildelingen virker, inkludert utdanningskvoter uten poenggrense.

**Poenggrensen per utdanningskvote beregnes og lagres aldri**, selv om det finnes en plass å vise den. Fjorårets medianverdi, som er viktig for hvem som får tidlig tilbud, settes i forbindelse med søknadsbehandlingen og er en annen kilde.

**Åpne spørsmål:** se [design.md](design.md), del 2, punkt 10 (flere poengsummer i samme kvotetype) og punkt 7 (delte ventelistenumre).

**Issue:** [#71](https://github.com/sikt-no/fs/issues/71) (lukket), [#92](https://github.com/sikt-no/fs/issues/92) (lukket)

#### Oppgave 6 — vise resultatet til saksbehandler

Hver søker skal ha ett tydelig svar per søknad: tilbud, venteliste med nummer, eller avslag. Fikk søkeren plass gjennom plassflyt fra en annen utdanningskvote, skal det kunne spores i etterkant, for eksempel ved klage.

Begge deler virker. **Ventelistenummeret når aldri fram til søkeren**, selv om innstillingen for å vise det finnes.

**Issue:** [#109](https://github.com/sikt-no/fs/issues/109) (lukket)

#### Oppgave 7 — publisere resultatet til søkerne

Søkerne skal se resultatet sitt i Min kompetanse på et bestemt, kontrollert tidspunkt. Det må være mulig å beregne tildelingen før den gjøres synlig, og å velge å ikke publisere den i det hele tatt (prøvetildeling).

Publisering virker og gir kontroll over når søkeren ser resultatet. Ubegrensede prøveopptak på alle rundetyper er dermed godt løst, fordi beregning og publisering er separate steg — nettopp slik lærestedene har bedt om.

Søkeren skal se tilbud, avslag eller venteliste, og vedtaket med begrunnelse: kvalifisering, rangering, poenggrense. Hullet er ventelistenummeret fra oppgave 6.

**Issue:** [#111](https://github.com/sikt-no/fs/issues/111), [#72](https://github.com/sikt-no/fs/issues/72), [#221](https://github.com/sikt-no/fs/issues/221)

#### Oppgave 8 — håndtere svar fra søker

Søkeren skal kunne akseptere eller avslå tilbudet, eller stå på venteliste, innenfor en svarfrist. Svarene skal kunne utløse en etterfylling som bygger videre på forrige plasstildeling.

Grunnfunksjonen virker: søkeren kan takke ja eller nei, og forrige rundes tilbud beholdes automatisk til neste runde.

Fire sider er verdt en faglig diskusjon, og alle fire står som avklaringspunkter i [design.md](design.md), del 2:

- Et nei-svar frigjør ikke plassen før svarfristen er ute. Blir plassen stående reservert for lenge?
- En søker som godtar og senere trekker seg, frigjør aldri plassen igjen.
- Når en søker har både et tilbud og et kansellert resultat på samme utdanningstilbud — hva skal vises?
- Det finnes ingen mulighet for saksbehandler å overstyre et enkelt resultat manuelt. Alt krever full omkjøring.

**Issue:** [#170](https://github.com/sikt-no/fs/issues/170), [#264](https://github.com/sikt-no/fs/issues/264), [#512](https://github.com/sikt-no/fs/issues/512)

#### Oppgave 9 — systemet gir automatisk nye tilbud ved nei-svar på tilbud (utenfor scope)

Utenfor scope for 2027-opptaket. Systemet skulle automatisk gi nye tilbud fra venteliste når noen faller fra, og fylle på opp mot grensen for antall tilbud som skal gis, uten manuell overvåking.

Behovet står igjen som sannsynlig mangel mot HK-dirs meldte behov: lærestedene har bedt om en mekanisme som raskt kompenserer for søkere som takker nei fordi de fikk tilbud høyere opp, uten å vente på neste runde. Se avklaringspunkt 3 i [design.md](design.md).

---

### Mistenkte feil

Seks mistenkte feil er identifisert, og de er ikke bevisste valg:

| Feil | Konsekvens | Issue |
|------|------------|-------|
| Bortfall beregnes mot feil tilbud når en søker har flere tilbud samtidig | Søkeren kan miste et studieønske hun skulle beholdt | |
| Ventelistenumre kan kollidere mellom runder | To søkere kan ha samme nummer, eller samme søker ulike | |
| Fristsjekk bruker applikasjonsklokke i stedet for databaseklokke | Fristsjekken kan være upålitelig ved klokkedrift | |
| Historiske resultater leses tilbake med feil resultattype (kollaps til IKKE_GYLDIG) | Søker som mistet kvalifisering forsvinner stille — bryter prinsipp 1 | |
| Harde tallgrenser (9999/99) feller hele kjøringen | En plasstildeling med for mange søkere krasjer | |
| Søkers svar knyttes til runde på løpenummer alene, uten rundetype | Svar kan havne på feil runde når det finnes flere rundetyper | |

Disse bør registreres som issues, ikke behandles som åpne spørsmål.

---

### Gap-analyse per oppgave

Evidensnivå: **M** = verifisert i datamodellen, **V** = verifisert i koden

#### Oppgave 1 — Legge til runder

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Navn på runde | `opptak.opptaksrunde.navn` NOT NULL | Ingen | M |
| Svarfrist for søker | `opptaksrunde.svarfrist` NOT NULL | Ingen | M |
| Dato for når plasstildelingen skal publiseres til søkere | **Ingen kolonne** | Feltet finnes ikke i modellen | M |
| Rundetype (hoved/tillegg/supplerende) | `opptaksrundetype_kode` | Se strukturfunn under | M |
| Publiseringstidspunkt | `opptaksrunde.publiseringstidspunkt` (nullable) | Automatisk publisering avgrenset bort | M |
| Periode for å endre parametere | `opptaksrunde.periode_endre_opptaksparametere` (tstzrange) | Finnes i modellen, ikke i krav | M |

**Strukturfunn:** `opptaksrundetype_kode` er del av **primærnøkkelen** til `opptak.opptaksrunde` og følger med i hver fremmednøkkel ut derfra. En runde kan ikke bytte type etter oppretting, og løpenummer er unikt per rundetype, ikke per opptak.

#### Oppgave 2 — Antall tilbud som skal gis

Fire tall i fire tabeller:

| Tabell | Kolonne | Nivå | Brukes av algoritmen | Ev. |
|--------|---------|------|---------------------|-----|
| `opptak.utdanningstilbud` | `antall_studieplasser` | Per utdanningstilbud (kapasitet) | Nei — kun visning | M+V |
| `opptak.kvote` | `onsket_antall_deltakere` | Per kvotetype, per opptak | **Fallback** når overbook mangler | M+V |
| `opptak.opptaksparametere` | `overbook_antall_plasser` | Per utdanningskvote **per runde** | **Ja — dette er antall tilbud som skal gis** | M+V |
| `plasstildeling.studiekvote` | `onsket_antall_tilbud` NOT NULL | Per utdanningskvote **per plasstildeling** | Nei — kun visning/snapshot | M+V |

**Verifisert i koden:** `KvoterService:98-104` er eksplisitt: `overbook_antall_plasser` er antall tilbud som skal gis, med fallback til `onsket_antall_deltakere`. Begrepet «overbook» er misvisende — kolonnen er det faktiske antallet tilbud som skal gis, ikke et tillegg.

#### Oppgave 3 — Plassflyt

| Krav | Funn | Ev. |
|------|------|-----|
| Flyt til én mottakende utdanningskvote | `studiekvote` har **ett** sett flyt-kolonner — bekreftet, én mottaker | M |
| Kan ikke krysse utdanningstilbud | Flyt-FK-en gjenbruker kildens org/utdanning/periode — strukturelt umulig | M |
| Flyt fra en tidligere plasstildeling | Modellen kan peke på en annen runde/tildeling, men **koden bruker det ikke** | M+V |
| Plassflyt opererer innenfor én tildeling | `Opptakskjoringsalgoritme` bygger flytkart og omfordeler innenfor én kjøring | V |
| Mellom runder: `basert_pa`-kjeden | Resultater videreføres via `basert_pa`, ikke plassflyt | V |
| Plassflyt kan endres per tildeling | Tre nivåer: `regelverk.kvotetype` → `opptak.kvote` → `studiekvote` | M |
| Siste utdanningskvote (stopper flyten) | NULL i flyt-kolonnene | M |
| Sirkularitetsvern i koden | `findPaafyllingsStudiekvoter` og `finnKvoterSomFlyterTil` bruker visited-sett, logger `warnf("Cycle detected...")` | V |
| Sirkularitetsvern i skjemaet | **Ingen CHECK-constraint eller trigger** | V |
| Test for sirkularitet | `testCircularPlassflytDoesNotHang` bekrefter at algoritmen håndterer sykler | V |

Plassflyt opererer kun innenfor én plasstildeling. Kryss-tildeling-kolonnene i modellen brukes ikke av koden. Sirkularitetsvernet finnes i koden men ikke i databasen.

#### Oppgave 4 — Starte en ny plasstildeling

| Krav | Funn | Ev. |
|------|------|-----|
| Bygge på forrige publiserte tildeling | `plasstildeling.*_basert_pa` — `OpprettPlasstildelingService` finner grunnlaget automatisk | M+V |
| Kjører automatisk i bakgrunnen | `plasstildelingsstatus` med default `'KLAR'`, egen kodetabell | M |
| Beregning skilt fra publisering | `plasstildeling.publiseres` (boolean) | M |
| Kjøre om / avbryte en feilet tildeling | Aktivt avvist som beslutning | S |
| Se at en tildeling feilet | Ikke eksponert i GraphQL | S |

#### Oppgave 5 — Gjennomføre plasstildeling

| Krav | Funn | Gap | Ev. |
|------|------|-----|-----|
| Poenggrense per utdanningskvote lagres | `plasstildeling.poenggrense` tabell finnes | **Tabellen populeres ikke av koden.** Tre skriveoperasjoner (studiekvoter, kvotesøknader, resultater) — ingen for poenggrense | M+V |
| Poenggrense vist til søker er riktig | Kjent feil, men tabellen er tom uansett | S+V |
| Rangering hentes fra søknadsbehandlingen | `kvotesoknad` med `rangering`, `poengsum`, `prioritet`, `har_tilbudsgaranti`, `svartype_kode` | Ingen | M |
| Endret søknad fanges opp mellom runder | Åpen avklaring | S |
| Søker som mister kvalifisering får avslag | Les/skriv-asymmetri i resultattype | S |
| Tilbudsgaranti fra markert utdanningskvote | `opptak.tilbudsgaranti_kvote` | Ingen | M |
| Kvoteprioritet | Tre nivåer: `kvotetype` → `kvote` → `studiekvote` | Ingen | M |
| Poenglikhetsregel koblet til opptaket | **Dagens kode:** regelen henger på kvotetype. **Besluttet ny løsning:** settes på opptaket. Feltet på rangeringsregelverk skal fjernes. Se [opptak/design.md](../opprette-opptak-2027/design.md) | M |
| Fire poenglikhetsregler | To av fire ser ut til å være dekket i dagens kode | S |

Poenggrense-beregning er designet i skjemaet men **ikke implementert**. Hele tabellen er tom. Dette er en ny feature, ikke en feilretting.

#### Oppgave 6 — Vise resultatet til saksbehandler

| Krav | Funn | Ev. |
|------|------|-----|
| Tilbud / venteliste med nummer / avslag | `plasstildelingsresultat` med `svartype_kode`, `ventelistenummer`, `plasstildelingsresultat_type_kode` | M |
| Spore plass via plassflyt | `plasstildelingsresultat.plass_fra_kvotetype_kode` med FK | M |
| Ventelistenummer er entydig | **Ingen unikhetsskranke** | M |
| Vis ventelistenummer til søker | `utdanningstilbud.vis_ventelistenummer_for_soker` (default false) | M |
| Vis poenggrense til søker | `utdanningstilbud.vis_poenggrense_for_soker` (default false) | M |

Resultatet finnes **to steder**: per tildeling i `plasstildeling.plasstildelingsresultat` og denormalisert på `soknad.soknadsalternativ`. Mulig kilde til inkonsistens.

#### Oppgave 7 — Publisere resultatet

| Krav | Funn | Ev. |
|------|------|-----|
| Kontroll over publiseringstidspunkt | `plasstildeling.publiseres` + `opptaksrunde.publiseringstidspunkt` | M |
| Vedtak med begrunnelse | Henger på poenggrense-gapet — tabellen er tom | M+V |
| Melding om vedtak til søker | `soknad.sokermelding` med FK til `kommunikasjon.melding` og `opptaksrunde` — røret finnes | M |
| Arv av svartype ved publisering | Åpen avklaring | S |

#### Oppgave 8 — Håndtere svar fra søker

| Krav | Funn | Ev. |
|------|------|-----|
| Søker svarer ja/nei innen frist | `soknad.opptakssvar` per søker, alternativ og runde | M |
| Svar knyttes til riktig runde | PK uten `opptaksrundetype_kode` — rettet i skjema, ikke i kode | M+S |
| Fristsjekk | Bruker applikasjonsklokke i stedet for databaseklokke | S |
| Trukket ja frigjør plassen | **Ingen kolonne** for trekk/frigjøring i `opptakssvar` | M |
| Manuell overstyring | `soknadsalternativ` har skrivbare resultattype-kolonner + `skal_spesialbehandles` | M |

---

### Kjernetjenester i koden

Verifisert i `fs-plattform/opptak`:

| Tjeneste | Ansvar |
|----------|--------|
| `KvoterService` | Leser utdanningskvotekonfigurasjon (kapasitet, prioritet, plassflytmål). Antall tilbud som skal gis: `overbook_antall_plasser` med fallback til `onsket_antall_deltakere` |
| `KvotesumService` | Beregner beste poengscore per søker per kvotetype — input-forberedelse |
| `OpprettPlasstildelingService` | Oppretter ny plasstildeling-rad med status KLAR, finner `basert_pa`-grunnlaget automatisk |
| `Opptakskjoringsalgoritme` | Selve tildelingsalgoritmen. Bygger flytkart, omfordeler plasser innenfor én kjøring |
| `PlasstildelingSkriveService` | Tre skriveoperasjoner: studiekvoter, kvotesøknader, resultater. **Ikke** poenggrense |

---

### Arbeid som må gjøres

1. Prosessbeskrivelse for plasstildeling på fs.sikt.no. Plasstildeling har ingen egen side i dag; den vises kun som enkeltoppgaven «tildel plass» i opptaksprosessen.
2. Eksempler per oppgave. Én Gherkin-feature per oppgave, slik at hver oppgave har konkrete eksempler på hva som skal kunne utføres. `krav/02 Opptak/14 Plasstildeling/` er ledig.
3. Oppdatere begrepene på fs.sikt.no etter begrepsendringene i [design.md](design.md).
4. Registrere de seks mistenkte feilene som issues.
5. Verifisere negative plasstildelingsinnstillinger mot dagens løsning.

## Statuslogg

Append-only. Ny linje på toppen ved hver hendelse.

| Dato       | Hendelse | Av | Lenke til review |
|------------|----------|----|------------------|
| 2026-11-05 | `@OPT-PLA-TIL-001`: plasstildelingen starter ikke mens en beregning på nytt kjører (`@OPT-BEH-BEH-026`). Fra gjennomgangen av flyten automatisk saksbehandling | @JøranIndseth | [#960](https://github.com/sikt-no/fs/pull/960) |
| 2026-11-04 | Produksjonsfristen er flyttet til januar 2027. Beskrivelsen av TAKE-3 er oppdatert i Jira | – | – |
| 2026-11-04 | Nytt krav `@OPT-PLA-RUN-002` (oversikten over plasstildelingsrunder, søk og filter), Must i første leveranse | – | [PR #907](https://github.com/sikt-no/fs/pull/907) |
| 2026-11-02 | Kravene gått gjennom mot prototypen v88 ([PR #907](https://github.com/sikt-no/fs/pull/907)): `@OPT-PLA-INN-004` lagt til (Could), varslingen av lærestedene flyttet fra `@OPT-PLA-SVA-002`, skisselenkene byttet til prototypen v88 | @karensikt | – |
| 2026-11-02 | Oppgave og scope slått sammen til scope.md (fra plasstildeling-rundetyper-og-runder, gjennomfore-plasstildeling, publisere-og-svare-pa-tilbud, plasstildeling) | – | – |
| 2026-10-28 | [plasstildeling-rundetyper-og-runder] Opprettet i scope-plasstildeling-2027 | @karensikt | – |
| 2026-10-28 | [gjennomfore-plasstildeling] Opprettet i scope-plasstildeling-2027 | @karensikt | – |
| 2026-10-28 | [publisere-og-svare-pa-tilbud] Opprettet i scope-plasstildeling-2027 | @karensikt | – |
| 2026-10-28 | [plasstildeling] Tatt ut av scope-plasstildeling-2027: kravene er fordelt på tre oppgaver, og mappa står igjen som kilde | @karensikt | – |
| 2026-10-14 | [plasstildeling] Migrert til scope-plasstildeling-2027 | @karensikt | – |
| 2026-09-15 | [plasstildeling] Workshop: utsatt til 8. des | @karensikt | – |
| 2026-09-09 | [plasstildeling] Tatt inn i veikart (design) | @karensikt | – |
| 2026-09-09 | [plasstildeling] Gap-analyse verifisert mot kode | – | design.md |
| 2026-09-09 | [plasstildeling] Del 1 og 2 renskrevet | @karensikt | design.md |
