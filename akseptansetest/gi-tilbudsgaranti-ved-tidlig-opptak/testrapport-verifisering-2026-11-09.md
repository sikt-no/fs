# Testrapport – verifisering – Gi tilbudsgaranti ved tidlig opptak

- **Nivå**: verifisering
- **Fase**: 1
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074
- **Scope**: @scope-tidlig-opptak
- **Grunnlag**: [verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-09-1136.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-09-1136.md) og undersiden [Verifisering – Gi tilbudsgaranti ved tidlig opptak – 2026-11-09 11:36](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5180653598) (versjon 2), lest 2026-11-09 13:00
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181767779
- **Laget**: 2026-11-09 av fs-testrapport

---

Testrapport for «Gi tilbudsgaranti ved tidlig opptak». Den bygger på verifiseringen fra 2026-11-09 11:36, og på kravene slik de står etter at det åpne spørsmålet om reservert studieplass ble lukket samme dag.

## Oppsummering

| Felt | Innhold |
|---|---|
| Scenarioer | 25 funnet, 2 ikke funnet, 0 usikker, av 27 |
| Krav levert (`@implemented`) | 0 av 1, og 1 delvis levert (`@OPT-BEH-BEH-007`: alle de 25 leverte scenarioene er funnet) |
| Åpne spørsmål som står igjen | Ingen i testen. Verify-rapporten har 1 scenario med åpent spørsmål («Reservert studieplass gir tilbudsgaranti uten kvalifisering»), men det ble lukket etter rapporten (09.11.2026: tilbudsgaranti er tilbudsgaranti, uansett kvalifisering). De 6 utsatte scenarioene (`@draft @openquestion`) er ikke med i testen |
| Regler i koden uten scenario | 12 funnet, 7 skal testes i fase 2, 1 bør få scenario (`fs-krav`), 2 er uklare om de er ønsket |
| Tilgangsstyring og datakonsistens (kodenivå) | 4 sjekker funnet, av 4 |
| Overleveringer i flytene | Ingen flyter |
| Kontrollert av | [Fylles ut av teamet] (en annen enn den som kjørte `fs-verify`) |
| Klar for agentisk funksjonstest | Ja, med forbehold: kravet er delvis levert. De 25 leverte scenarioene kan testes. De 2 som mangler i fs-admin, står under «Det som mangler», og testes ikke før koden er rettet |

I verify-rapporten og på verifiseringssiden har Daniel Sachse fylt ut «Menneskelig kontroll» (2026-11-09): rapporten ser OK ut, det åpne spørsmålet er lukket, og visningen av varsel ved feilkonfigurert utdanningstilbud er en reell forseelse som fikses snarest.

## Resultat per krav

| Jira-sak | Krav | Funnet | Ikke funnet | Usikker | Status |
|---|---|---|---|---|---|
| [sikt-no/fs#456](https://github.com/sikt-no/fs/issues/456) | [Gi tilbudsgaranti ved tidlig opptak](https://github.com/sikt-no/fs/blob/072f40ee/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature) | 25 | 2 | 0 | `@in-progress` (delvis levert) |

## Flyter

Ingen av kravene er med i en flyt. Oversiktsflyten Opptaksløpet har fasen «Søkeren får tilbudsgaranti i tidlig opptak», men flyten for den er ikke skrevet (se «Vurdering per krav» i omfanget).

## Det som mangler

| Krav | Scenario | Resultat | Hva som mangler | Repo |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense | ikke funnet | Prøvekjøringen viser ikke avvikene, så antallet (0) vises ikke. fs-plattform gir riktig avvik (`TidligopptakTilbudsgarantiService.java:389-395`). Kommentert på STEK-489 | fs-admin |
| `@OPT-BEH-BEH-007` | Se antall utdanningstilbud med mangelfulle innstillinger | ikke funnet | Prøvekjøringen henter avvikene, men dialogen viser dem ikke (`TidligOpptakResultModal.tsx:28-38`). Meldingen etter gjennomføringen teller avvik, ikke utdanningstilbud. Kommentert på STEK-489 | fs-admin |

## Regler uten scenario

| Krav | Regel i koden | Funnet i | Testet i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten poengsum i garantikvoten gir ikke tilbudsgaranti | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:765-775` | ja | nei |
| `@OPT-BEH-BEH-007` | Utdanningstilbud uten rangeringsregelverk, kvoter eller kompetanseregelverk gir ikke tilbudsgaranti | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:699-708, 745-763` | nei: utgangstilstanden kan ikke lages i opptak 34 uten å endre utdanningstilbudene andre tester bruker | nei: visningen er utsatt i kravet |
| `@OPT-BEH-BEH-007` | Kansellerte utdanningstilbud er ikke med i tidligopptaket | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:362-363` | nei: utdanningstilbudene i opptak 34 brukes av andre tester | nei |
| `@OPT-BEH-BEH-007` | Poengsummen tas bare fra kvoter søkeren skal kvoteplasseres i og som tilbudet har, og fra grunnlag rangeringsregelverket åpner for | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:922-927, 937-960` | ja | nei |
| `@OPT-BEH-BEH-007` | Kvalifiseringen: ett kvalifisert grunnlag holder. Søkeren er ikke kvalifisert bare når alle grunnlagene er vurdert til nei, ellers er kvalifiseringen ikke vurdert | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:790-813` | ja | nei |
| `@OPT-BEH-BEH-007` | Trukne søknadsalternativer og saker som ikke er aktive, er ikke med | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:534, 544, 868-869` | ja | nei |
| `@OPT-BEH-BEH-007` | En søker som ikke har søkt om tidlig opptak, men har et tidligopptakstilbud på et søknadsalternativ, er med og får tilbudsgaranti fra tidligopptaket | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:520-545` | ja | uklart om ønsket: avklares med `fs-krav` |
| `@OPT-BEH-BEH-007` | Reservert studieplass i kolonnen til opptaksforvalter erstattes av tilbudsgarantien fra tidligopptaket | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:692-694, 1022-1024` | ja | ja (`fs-krav`) |
| `@OPT-BEH-BEH-007` | Treffer en skriving ingen rad, stoppes hele gjennomføringen og rulles tilbake | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:1005-1012` | nei: krever samtidige endringer | nei |
| `@OPT-BEH-BEH-007` | Gjennomføringen er sperret i fs-admin til prøvekjøringen har gitt en oppsummering, når poenggrenser ikke er lagret, og når prøvekjøringen gir feil | `fs-admin/…/TidligOpptakResultModal.tsx:150-154, 162-165` | ja | nei |
| `@OPT-BEH-BEH-007` | Antallet i meldingen etter gjennomføringen teller avvik (ett utdanningstilbud kan ha flere), tar med overskredet kvote, og vises bare når det er over 0 | `fs-admin/…/KjorTidligopptakButton.tsx:129-134` | nei: venter på at avvikene vises i prøvekjøringen | uklart om ønsket |
| `@OPT-BEH-BEH-007` | Kvotevarselet er 30 prosent når grensen ikke er angitt | `fs-plattform/…/TidligopptakTilbudsgarantiService.java:96-97` | nei: kvotevarselet er utsatt | nei: dekkes av det utsatte scenarioet |

## Neste steg

Klar, med forbehold → `fs-testcaser-cdp` (testcasene for fase 2, laget etter testplanen), for de 25 leverte scenarioene og de 7 reglene uten scenario som skal testes i fase 2. De 2 scenarioene som mangler, går tilbake til teamet (fs-admin, STEK-489), og verifiseres på nytt med `fs-verify` når de er rettet. Før testcasene kjøres, må testdataene og tilgangene som står som `[Fylles ut]` i testplanen, være på plass.
