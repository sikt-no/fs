# Testplan – Opprette og vedlikeholde opptak v4

- **Leveranse**: scope
- **Kilde**: `@scope-opprette-opptak-2027`
- **Scope**: @scope-opprette-opptak-2027
- **Scope-fil**: [scope-opprette-opptak-2027](../../tasks/opptak/scope-opprette-opptak-2027.md)
- **Oppgaver**: [opptak/opprette-og-vedlikeholde-opptak](../../tasks/opptak/opprette-og-vedlikeholde-opptak/oppgave.md)
- **Krav**: 8 feature-filer i scopet, 5 i testen (3 `@implemented`, 2 `@in-progress`), 1 flyt (ingen faser levert), commit `3d8fba3` (2026-10-29). Kravene i testen er uendret siden 28.10 (Innstillinger `270d681`, Frister `0ec4b48`)
- **Verifisering**: [verify-2026-10-28-1238.md](../opprette-opptak-2027/verify-2026-10-28-1238.md) (alle fem kravene, uansett status, med agent team)
- **Forrige testplan**: [Testplan – Opprette og vedlikeholde opptak v3](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5150965860) (28.10.2026, [testplan.md](../opprette-og-vedlikeholde-opptak-v3/testplan.md)). Versjon 1 (21.10.2026) står i Confluence, og versjon 2 (27.10.2026) er arkivert
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155553291, under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner). Verifiseringen fra 28.10 er flyttet hit fra versjon 3
- **Laget**: 2026-10-29 av fs-testplan, etter teststrategien med endringene 29.10.2026 ([PR #860](https://github.com/sikt-no/fs/pull/860)). Omfanget er hele scopet, også det som ikke er levert, som i versjon 2 og 3 (avvik fra teststrategien, avgjort av produkteier 21.10.2026, bekreftet 29.10.2026). Tidene er fiktive: testplanen er en POC
- **Undersider**: [omfang.md](omfang.md), [testcaser-og-testdata.md](testcaser-og-testdata.md), [sporbarhet.md](sporbarhet.md) (delt 2026-10-30)

---

Testplan for «Opprette og vedlikeholde opptak», versjon 4. Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

Versjon 4 har det samme omfanget og de samme kravene som [versjon 3](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5150965860), og verifiseringen fra 28.10.2026. Den er laget etter tre endringer i teststrategien 29.10.2026:

- **Fase 1 er planen:** verifiseringen og denne testplanen.
- **Testene lager testdataene sine selv.** Data i testmiljøet kan slettes eller nullstilles når som helst, så et oppsett lager opptakene i hver kjøring. Bare grunndata og det testene ikke kan lage, må finnes i TEST (se «Testdata»).
- **Den interne testen (fase 3) har fire deler:** det den agentiske testen ikke klarte, flytene og avhengighetene, opplevelsen og helheten, og det med høyest risiko (se «Testcaser som skal lages»).

Alle fem kravene testes, også det som ikke er levert. **Det er et avvik fra teststrategien**, som bare tester det som er `@implemented`. Det som ikke er levert, står i «Venter på verifisering» som kjente mangler, og vil trolig ikke bestå.

> **POC:** datoene i «Tid og kanal» er fiktive.

## Innhold

Testplanen er delt i hovedsiden og tre undersider, så hver del kan oppdateres for seg.

| Side | Innhold | Fil |
|---|---|---|
| Testplan (denne siden) | Testbeskrivelse, roller, tid og kanal, forutsetninger, kriterier for godkjent, funn, beslutning, status i flyten og vedlegg | `testplan.md` |
| [Omfang – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5159125001) | Kravene og flytene som testes, åpne spørsmål, avhengighetskart, det som venter på verifisering, regler uten scenario og det som ikke er med | `omfang.md` |
| [Testcaser og testdata – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5159026690) | Omfanget av testcasene som skal lages, testbrukerne, tilgangsmatrisen og testdataene | `testcaser-og-testdata.md` |
| [Sporbarhet – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5157978133) | Scenarioene fra kravet til koden og til testen | `sporbarhet.md` |

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Opptaksforvalteren kan opprette et samordna eller lokalt opptak i FS Admin, med navn på bokmål, nynorsk og engelsk (samisk er valgfritt), regelverkssamling og opptakstype. Opptaksforvalteren setter innstillingene (poenglikhetsregel, startnummer, maks antall søknadsalternativer, tidlig opptak, ledige studieplasser, utdanningsbakgrunner og dokumentasjonsopplasting) og fristene. I et samordna opptak inviterer opptaksforvalteren ved forvaltende organisasjon læresteder fra utdanningsregisteret. På «Opptak» ser opptaksforvalteren en liste over opptakene, 50 om gangen, kan søke på navn, filtrere på opptakstype, sortere og åpne et opptak. |
| Versjon | main per 28.10.2026: fs-admin `961eb3d3e` (verifisert; `98a8e16fd` rører ikke kravene), fs-plattform `2dbc79ec3f`. [Fylles ut: versjonen som er lagt ut i TEST] |
| Testmiljø | TEST: [https://test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak) |
| Feature-flagg | `opptak-opprett-samordna`: på i TEST (sjekket 27.10). Holder samordna opptak ute av produksjon til akseptansetesten er bestått. `opptak-filter-organisasjon`: styrer om lista over opptak filtreres på organisasjonen (`useGetOpptak.tsx:15-25`). [Fylles ut: om flagget er på i TEST] |
| Kilde | Scopet [`@scope-opprette-opptak-2027`](https://github.com/sikt-no/fs/blob/3d8fba3/tasks/opptak/scope-opprette-opptak-2027.md), med oppgaven [opprette-og-vedlikeholde-opptak](https://github.com/sikt-no/fs/tree/3d8fba3/tasks/opptak/opprette-og-vedlikeholde-opptak) |
| Scope | `@scope-opprette-opptak-2027` · [scope-fila på GitHub](https://github.com/sikt-no/fs/blob/3d8fba3/tasks/opptak/scope-opprette-opptak-2027.md) |
| Saker | [sikt-no/fs#211](https://github.com/sikt-no/fs/issues/211) ([#577](https://github.com/sikt-no/fs/issues/577), [#578](https://github.com/sikt-no/fs/issues/578), [#579](https://github.com/sikt-no/fs/issues/579)) · Jira-epic [TAKE-318](https://sikt.atlassian.net/browse/TAKE-318) ([TAKE-379](https://sikt.atlassian.net/browse/TAKE-379) opprette, [TAKE-380](https://sikt.atlassian.net/browse/TAKE-380) samordning, [TAKE-320](https://sikt.atlassian.net/browse/TAKE-320) innstillinger, [TAKE-321](https://sikt.atlassian.net/browse/TAKE-321) frister, [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381) utdanningsbakgrunner) |
| Berører andre team | Utdanningstilbud (Shinkansen): lærestedene knytter utdanningstilbud til opptaket, og bruker redigerings- og trekkfristen. Saksbehandlertildeling (Puff): reglene for fordeling av søknader i samordna opptak. Plasstildeling: taket for antall tilbud flyttes til plasstildelingsrunden, og svarfristen settes på runden. Tilgangsstyring: rollen som gir `MEDLEM_OPPTAK`. Søknad og Min kompetanse, saksbehandling og plasstildeling bruker innstillingene og fristene, men virkningen er ikke med i denne leveransen (se «Uløst arbeid» i scope-fila) |
| Kjente begrensninger | Se under tabellen |
| Avhengighetskart | Under «Flyter» på [Omfang – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5159125001) |

**Kjente begrensninger** (fra verifiseringen 28.10):

- **Bare FS Admin sperrer.** API-et godtar en tom liste med utdanningsbakgrunner, tidlig opptak uten lenke, endring av opptakstype når opptaket har utdanningstilbud, opptak uten frister, og gir maks 10 søknadsalternativer når feltet utelates. Testen går gjennom FS Admin, så dette testes ikke her.
- **Organisasjoner som ikke deltar.** En organisasjon som ikke deltar, kan åpne et samordna opptak direkte (lesingen er åpen i API-et, og siden sjekker ikke), og ser alle opptak i lista når flagget `opptak-filter-organisasjon` er av. «Organisasjon som ikke deltar, kan ikke åpne opptaket» vil trolig ikke bestå.
- **Deltakende organisasjon ser ikke alle innstillingene.** Oversikten henter ikke tidlig opptak, opplasting, studierett, ledige studieplasser og lenken, og viser tidlig opptak, dokumentopplasting og krever studierett som påslått uansett verdi (`OpptakDetails.tsx:177-204`).
- **Deltakeren og utdanningstilbud.** API-et krever handlingen `MEDLEM_OPPTAK` for at en deltaker kan legge til utdanningstilbud, mens FS Admin bare sjekker `FS-ADMIN_MODIFISERE_OPPTAK`. Hvilke roller som gir `MEDLEM_OPPTAK` i TEST, er ikke bekreftet (miljøfila).
- **Fristen for å trekke utdanningstilbud** er ikke påkrevd i FS Admin før TAKE-436 (`kodeUtils.ts:6-9`), og det vises ikke noe varsel når den er før redigeringen stenger. Fs-plattform-branchen `feature/take-436-fjern-trekkfrist` fjerner fristen, mot kravet. Avklares med teamet.
- **Første svarfrist** finnes ikke på opptaket, bare på plasstildelingsrunden (Q19, TAKE-414). Scenarioet vil ikke bestå som det står.
- **Taket for antall tilbud per tildelingsrunde** er tatt ut av kravet (`@deprecated`) og av FS Admin på main (TAKE-450, 27.10, ikke releaset), men finnes fortsatt i API-et og databasen (NOT NULL, DEFAULT 1). Om feltet fortsatt vises i TEST, avhenger av hva som er lagt ut.
- **Standardverdiene i API-et** for startnummer (1) og dokumentopplasting (åpen) finnes bare i MR !6415. FS Admin forhåndsutfyller dem, men et tømt startnummer lagres som tomt.
- **Tallfeltene** (startnummer, maks antall søknadsalternativer) godtar 0 i skjemaet, men API-et avviser 0 med «En av de angitte verdiene er ugyldig».
- **Ordene i FS Admin:** «informasjonsdato for dokumentasjon» heter «Ordinær frist (dokumentasjon)», og fristen for å trekke utdanningstilbud vises med backend-navnet.
- **Oversikten over opptak:** lista har status (kolonne, sortering og filter), selv om kravet sier at status ikke er med. Sortering på organisasjon bruker organisasjonskoden, ikke forkortelsen som vises (godtatt av produkteier). Over 50 opptak finnes ikke i TEST.
- **Navnene i scenarioene** i Samordna opptak («Universitetet i Oslo», «NTNU») er eksempler. Testen bruker testbrukerne og organisasjonene deres.

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | Marit Bjørnerud Rønning | Eier testen fra start til beslutning. Har ansvaret for at agenten blir kjørt og tester riktig (kjøringen kan gjøres av andre), går gjennom testcasene før kjøringen og funnene etterpå, tar stikkprøver av beståtte testcaser etter en risikovurdering, og skriver beslutningen i testrapporten |
| Kjører av agenten | Mats Gimming Myhre | Starter den agentiske funksjonstesten (fase 2) |
| Kontaktperson i teamet | Karen Skadsheim Sikkeland | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | Maciek Adamczyk og Jøran Wigen Aasterud (teamet) | [Fylles ut: hvilke deler] |
| Eksterne testere | HK-dir og lærestedene | [Fylles ut: hvem som tester] |

## Tid og kanal

Datoene er fiktive (POC).

| Felt | Innhold |
|---|---|
| Agentisk funksjonstest | 2026-11-03 (fiktiv). Mats Gimming Myhre kjører agenten |
| Intern akseptansetest | 2026-11-05 kl. 10:00–12:00 (fiktiv). Tidsramme: 1–2 timer |
| Ekstern akseptansetest | 2026-11-12 (fiktiv), avklares med de eksterne partene |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Opprette og vedlikeholde opptak» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der. Flaggene `opptak-opprett-samordna` og `opptak-filter-organisasjon` står slik teamet har bestemt | [Fylles ut av teamet]. `opptak-opprett-samordna` er på (27.10). `opptak-filter-organisasjon` er ikke sjekket |
| 2 | Grunndataene og det testene ikke kan lage («Testdata») finnes i testmiljøet. Opptakene lager oppsettet i kjøringen | [Fylles ut av teamet]. Fire nøkler mangler verdi i miljøfila (`regelverkssamling-samordna-annen`, `regelverkssamling-lokalt`, `utdanningstilbud-deltakende`, `opptak-utdanningsbakgrunn-valgt-av-soker`), og over 50 opptak finnes ikke i TEST |
| 3 | Oppsettet kjører uten feil i starten av kjøringen | Venter: ikke kjørt ennå. Opptak kan ikke slettes, så opptakene oppsettet og testene lager, blir liggende, med kjøringen i navnet |
| 4 | Testbrukerne finnes i rollene ved organisasjonene kravene gjelder (tilgangsmatrisen) | Personaene for testbruker 1–4 er bekreftet 28.10. [Fylles ut av teamet: at `OPPTAK_FORVALTER` ved NTNU gir `MEDLEM_OPPTAK`] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten. Åpne spørsmål stopper ikke, og står i «Åpne spørsmål» | Nei (avvik, se over): 76 av 84 funnet, 5 ikke funnet, 3 usikre (28.10.2026). Kontrollert av `fs-verify-kontroll`. Venter på kontroll av en person |
| 6 | De agentiske testcasene (`fs-testcaser-cdp`) og oppsettet er laget, og testansvarlig og teamet har gått gjennom dem før kjøringen | Laget og oppdatert 29.10.2026. Venter på gjennomgang |
| 7 | Testcasene for den interne akseptansetesten (`fs-testcaser-intern`) er laget og gått gjennom av testansvarlig | Venter |
| 8 | Testansvarlig er logget inn i FS Admin i en egen Chrome-profil til testingen, CDP-agenten kan bytte til hver testbruker i «Overstyrt bruker», og nøklene i testbrukere og testdata er utfylt | Radene i «Overstyrt bruker» er utfylt for alle fire testbrukerne. [Fylles ut av teamet: verdiene for grunndataene som mangler] |
| 9 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |

## Kriterier for godkjent

Kravene i «Omfang» er kriteriene for godkjent: hvert scenario er et akseptansekriterium. Mangler et viktig tilfelle, legges det inn i kravet (`fs-krav`), ikke her. Fasene er ferdige når:

| Fase | Ferdig når |
|---|---|
| 1. Plan | Alle scenarioene er funnet, en annen person har kontrollert verifiseringsrapporten, og testansvarlig har gått gjennom testplanen. Åpne spørsmål står i testplanen, men stopper ikke |
| 2. Agentisk funksjonstest | Alle testcasene er kjørt, ingen funn med «Stopper» står åpne, og testansvarlig har gått gjennom rapporten. Det er inngangskriteriet til intern akseptansetest |
| 3. Intern akseptansetest | Beslutningen er tatt: godkjent, godkjent med forbehold eller ikke godkjent |
| 4. Ekstern akseptansetest | De eksterne partene har akseptert mot sine egne krav |

Siden kravene som ikke er levert, også testes, er det ventet at noen testcaser ikke består. Testansvarlig vurderer dem mot «Venter på verifisering» før beslutningen.

## Funn og alvorlighetsgrad

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig.

## Beslutning

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Hvem som beslutter etter den eksterne akseptansetesten, avklares med de eksterne partene.

## Status i flyten

| Fase | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | [Verifisering – Opprette og vedlikeholde opptak v3 – 2026-10-28 12:38](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5153554433) · [verify-2026-10-28-1238.md](../opprette-opptak-2027/verify-2026-10-28-1238.md) | 5 ikke funnet, 3 usikker | 2026-10-28 |
| 1. Testplan | (denne siden) | Laget, versjon 4 | 2026-10-29 |
| 2. Agentisk funksjonstest | [Testrapport – agentisk funksjonstest – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5158567942) · [testrapport-agentisk-2026-10-30.md](testrapport-agentisk-2026-10-30.md) · kjøringen [kjoring-2026-10-29-1322/resultat.md](kjoring-2026-10-29-1322/resultat.md) | Venter på gjennomgang (96 bestått, 23 ikke bestått, 28 ikke testet, av 147) | 2026-10-30 |
| 3. Intern akseptansetest | – | Venter | |
| 4. Ekstern akseptansetest | – | Venter | |

Testrapportene (verifisering, agentisk, intern og ekstern) står som undersider, og lenken står i raden for fasen.

## Vedlegg

| Vedlegg | Lenke |
|---|---|
| Verifiseringsrapporten (fase 1) | [Verifisering – Opprette og vedlikeholde opptak v3 – 2026-10-28 12:38](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5153554433) · [verify-2026-10-28-1238.md](../opprette-opptak-2027/verify-2026-10-28-1238.md) |
| Agentisk testrapport (fase 2) | [Testrapport – agentisk funksjonstest – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5158567942) · [testrapport-agentisk-2026-10-30.md](testrapport-agentisk-2026-10-30.md) |
| Testcasene for fase 2 | [`cdp-tester/02 Opptak/11 Opprette og vedlikeholde opptak/`](../../cdp-tester/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/), og [oppsettet](../../cdp-tester/_Oppsett/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/oppsett.feature) |
| Testcasene for fase 3 | – |
| Forrige testløp | [Testplan versjon 3](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5150965860), [testplan versjon 1](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165), [intern akseptansetest 22.10](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5127209099), [ekstern akseptansetest](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137334279). Kjøringen av Opprette et opptak 27.10 (versjon 2, arkivert): `akseptansetest/opprette-og-vedlikeholde-opptak-v2/kjoring-2026-10-27-1200/` |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
