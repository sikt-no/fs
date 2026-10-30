# Testplan – Opprette og vedlikeholde opptak v2

- **Leveranse**: scope
- **Kilde**: `@scope-opprette-opptak-2027`
- **Scope**: @scope-opprette-opptak-2027
- **Scope-fil**: [scope-opprette-opptak-2027](../../tasks/opptak/scope-opprette-opptak-2027.md)
- **Oppgaver**: [opptak/opprette-og-vedlikeholde-opptak](../../tasks/opptak/opprette-og-vedlikeholde-opptak/oppgave.md)
- **Krav**: 8 feature-filer i scopet, 5 i testen (3 `@implemented`, 2 `@in-progress`), 1 flyt (ingen faser levert), commit `9a112c6` (2026-10-26)
- **Verifisering**: [verify-2026-10-26-0941.md](../../tasks/opptak/opprette-og-vedlikeholde-opptak/spec/verify-2026-10-26-0941.md) (`@OPT-OVO-INN-001`), [verify-saksbehandlertildeling-2026-10-22-1419.md](../../krav/_Flyter/10%20Opptaksl%C3%B8pet/verify-saksbehandlertildeling-2026-10-22-1419.md) (`@OPT-OVO-SAM-001`, `@OPT-OVO-FRI-001`), [verify-2026-10-21-2142.md](../../tasks/opptak/opprette-og-vedlikeholde-opptak/spec/verify-2026-10-21-2142.md) (`@OPT-OVO-OVE-001`), verify-2026-10-21-1442.md (`@OPT-OVO-GRU-001`, regelen som er `@in-progress`. Ligger bare på branchen `akseptansetest/opprette-opptak-2027-ekstern`)
- **Forrige testplan**: [Testplan – Opprette og vedlikeholde opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165) (21.10.2026, `akseptansetest/opprette-opptak-2027/testplan.md` på branchen `akseptansetest/opprette-opptak-2027-ekstern`)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148147753 (utkast), under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner)
- **Laget**: 2026-10-27 av fs-testplan. Omfanget er som i forrige testplan: hele scopet, også det som ikke er levert (avvik fra teststrategien, avgjort av produkteier 21.10.2026 og beholdt 27.10.2026)

---

Testplan for «Opprette og vedlikeholde opptak», versjon 2. Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

Testplanen følger den nye teststrategien med fire faser: verifisering, agentisk funksjonstest, intern og ekstern akseptansetest. Den erstatter [forrige testplan](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165), som gjaldt den interne akseptansetesten 22.10.2026. Omfanget er det samme: alle de fem kravene i scopet, også de som ikke er levert. **Det er et avvik fra teststrategien**, som bare tester det som er `@implemented`. Produkteier har avgjort det. Det som ikke er levert, står i «Venter på verifisering» som kjente mangler, og vil trolig ikke bestå.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Opptaksforvalteren kan opprette et samordna eller lokalt opptak i FS Admin. Opptaket har navn på bokmål, nynorsk og engelsk (samisk er valgfritt), regelverkssamling og opptakstype. Opptaksforvalteren setter innstillingene: poenglikhetsregel, startnummer, maks antall søknadsalternativer, tidlig opptak, ledige studieplasser, utdanningsbakgrunner og dokumentasjonsopplasting. Opptaksforvalteren setter også fristene. I et samordna opptak inviterer opptaksforvalteren ved forvaltende organisasjon læresteder fra utdanningsregisteret. På «Opptak» ser opptaksforvalteren en liste over opptakene, 50 om gangen, kan søke på navn, filtrere på opptakstype, sortere og åpne et opptak. |
| Versjon | main per 27.10.2026: fs-admin `2b7d1f87a` (26.10), fs-plattform `ef201c1973` (27.10) |
| Testmiljø | TEST: [https://test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak) |
| Feature-flagg | `opptak-opprett-samordna`: på i TEST, holder samordna opptak ute av produksjon til akseptansetesten er bestått. `opptak-filter-organisasjon`: styrer om lista over opptak filtreres på organisasjonen (`useGetOpptak.tsx:16`). [Fylles ut: om flagget er på i TEST] |
| Kilde | Scopet [`@scope-opprette-opptak-2027`](https://github.com/sikt-no/fs/blob/9a112c6/tasks/opptak/scope-opprette-opptak-2027.md), med oppgaven [opprette-og-vedlikeholde-opptak](https://github.com/sikt-no/fs/tree/9a112c6/tasks/opptak/opprette-og-vedlikeholde-opptak) |
| Scope | `@scope-opprette-opptak-2027` · [scope-fila på GitHub](https://github.com/sikt-no/fs/blob/9a112c6/tasks/opptak/scope-opprette-opptak-2027.md) |
| Saker | [sikt-no/fs#211](https://github.com/sikt-no/fs/issues/211) ([#577](https://github.com/sikt-no/fs/issues/577), [#578](https://github.com/sikt-no/fs/issues/578), [#579](https://github.com/sikt-no/fs/issues/579)) · Jira-epic [TAKE-318](https://sikt.atlassian.net/browse/TAKE-318) ([TAKE-379](https://sikt.atlassian.net/browse/TAKE-379) opprette, [TAKE-380](https://sikt.atlassian.net/browse/TAKE-380) samordning, [TAKE-320](https://sikt.atlassian.net/browse/TAKE-320) innstillinger, [TAKE-321](https://sikt.atlassian.net/browse/TAKE-321) frister, [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381) utdanningsbakgrunner) |
| Berører andre team | Utdanningstilbud (Shinkansen): lærestedene knytter utdanningstilbud til opptaket. Saksbehandlertildeling (Puff): reglene for fordeling av søknader i samordna opptak. Plasstildeling: taket for antall tilbud flyttes til plasstildelingsrunden, og svarfristen settes på hovedrunden. Søknad og Min kompetanse, saksbehandling og plasstildeling bruker innstillingene og fristene, men virkningen er ikke med i denne leveransen (se «Uløst arbeid» i scope-fila) |
| Kjente begrensninger | Se under tabellen |
| Avhengighetskart | [Avhengighetskart](#avhengighetskart) |

**Kjente begrensninger:**

- **Taket for antall tilbud per tildelingsrunde** er tatt ut av kravet (`@deprecated`, flyttes til plasstildelingsrunden), men feltet er fortsatt påkrevd i FS Admin (`OpptakManagementPage.tsx:188-260`). Det må fylles ut for å lagre et opptak.
- **Fristen for å trekke utdanningstilbud** er ny i kravet 26.10, og er ikke verifisert. Koden krever den ikke før TAKE-436 (`OpptakDeadlinesSamordna/kodeUtils.ts:6-9`), og ingen kode sjekker rekkefølgen mellom fristene. Scenarioene «Opptaket kan ikke lagres uten fristen for å trekke utdanningstilbud» og «Fristen for å trekke utdanningstilbud kan ikke være før redigeringen stenger» vil trolig ikke bestå.
- **Tallfeltene** (startnummer, maks antall søknadsalternativer, tilbud per tildelingsrunde) godtar 0 i skjemaet (`min={0}`, `OpptakSettings.tsx:280,293,306`), men API-et avviser 0 med den generelle meldingen «En av de angitte verdiene er ugyldig» (`OpprettOpptakMutations.java:713`).
- **Regler som bare FS Admin sørger for:** API-et sperrer ikke endring av opptakstype når opptaket har utdanningstilbud, krever ikke lenken til tidlig opptak, godtar en tom liste med utdanningsbakgrunner og bruker «Alder» som poenglikhetsregel når den mangler (verify 26.10, `OpprettOpptakMutations.java:107-112`). Testen går gjennom FS Admin, så dette testes ikke.
- **Sortering på organisasjon** i oversikten sorterer på organisasjonskoden, ikke på forkortelsen som vises (godtatt av produkteier).
- **Over 50 opptak** finnes ikke i TEST, så «Liste viser de 50 første opptakene» og «Laste inn 50 flere opptak» kan ikke kjøres før testdataene finnes.
- **Status** vises i oversikten, og kan sorteres og filtreres på, selv om kravet ikke har det.
- **Navnene i scenarioene** i Samordna opptak («Universitetet i Oslo», «NTNU») er eksempler. Testen bruker testbrukerne og organisasjonene deres: NTNU er deltakende organisasjon, og Fagskolen Vestfold og Telemark deltar ikke.

### Testbrukere

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | `opptak-forvalter-forvaltende` | Ordentlig rundskriv | Opptaksforvalter og saksbehandler ved forvaltende organisasjon | HK-dir | «Overstyrt bruker»: Ordentlig rundskriv | https://test-fsadmin.sikt.no/opptak | Opprette samordna opptak, innstillinger, frister, samordning (forvaltende organisasjon), oversikten over opptak |
| 2 | `opptak-forvalter-deltakende` | Ansvarsfull Fotkrem | Opptaksforvalter ved deltakende organisasjon | NTNU | «Overstyrt bruker»: Ansvarsfull Fotkrem | https://test-fsadmin.sikt.no/opptak | Samordna opptak: deltaker som legger til utdanningstilbud, og som ser, men ikke endrer, innstillingene. Trenger rollen `MEDLEM_OPPTAK` når TAKE-423 er merget |
| 3 | `opptak-forvalter-ikke-deltakende` | Talefør Elv | Opptaksforvalter ved organisasjon som ikke deltar | Fagskolen Vestfold og Telemark | «Overstyrt bruker»: Talefør Elv | https://test-fsadmin.sikt.no/opptak | Samordna opptak: organisasjon som ikke deltar |
| 4 | `opptak-forvalter-lokalt` | Ru Brødskive | Opptaksforvalter ved lærested med lokalt opptak | HVL | «Overstyrt bruker»: Ru Brødskive | https://test-fsadmin.sikt.no/opptak | Opprette lokalt opptak, lokalt opptak i Samordna opptak |

Testbrukerne finnes i rollene scenarioene nevner, ved organisasjonene kravet gjelder. Det lages ikke egne testcaser for roller og tilgang i fase 2: `fs-verify` verifiserer i koden at de er laget slik kravet sier (fase 1). Scenarioene i kravet, også om synlighet, testes som de står.

#### Tilgangsmatrise

Verify-rapportene har ikke tilgangsrader (de er laget før `fs-verify` skrev dem), så matrisen er laget fra rollene i kravene.

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@OPT-OVO-GRU-001` | Opptaksforvalter (samordna) | oppretter | – | 1 |
| `@OPT-OVO-GRU-001` | Opptaksforvalter (lokalt) | oppretter | – | 4 |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon | endrer | – | 1 |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon | ser opptaket og innstillingene, legger til utdanningstilbud ved organisasjonen | ingen tilgang til å endre | 2 |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved organisasjon som ikke deltar | – | ser ikke opptaket | 3 |
| `@OPT-OVO-SAM-001` | Opptaksforvalter (lokalt opptak) | endrer | – | 4 |
| `@OPT-OVO-INN-001` | Opptaksforvalter ved forvaltende organisasjon | endrer | – | 1 |
| `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon | endrer | – | 1 |
| `@OPT-OVO-OVE-001` | Opptaksforvalter | ser | avhenger av flagget `opptak-filter-organisasjon` | 1 |

### Testdata

Testdataene testene trenger, med nøkkel. Testplanen sier hvilke data som trengs og hvilken tilstand de skal ha, ikke hvordan de lages: det løses separat, og ligger utenfor teststrategien. Testdata er syntetiske.

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| Regelverkssamling | `regelverkssamling-samordna` | «UHG 2027» (eller tilsvarende) | TEST, FS Admin | Velges i skjemaet for opptaket | Finnes, og kan velges i et samordna opptak | `@OPT-OVO-GRU-001`, `@OPT-OVO-INN-001` |
| Regelverkssamling | `regelverkssamling-samordna-annen` | «UHG 2027 v2» (eller tilsvarende) | TEST, FS Admin | Velges i skjemaet for opptaket | Finnes, og er en annen enn `regelverkssamling-samordna` | `@OPT-OVO-INN-001` «Endre regelverkssamling …» |
| Regelverkssamling | `regelverkssamling-lokalt` | «Lokalt regelverk» (eller tilsvarende) | TEST, FS Admin | Velges i skjemaet for opptaket | Finnes, og kan velges i et lokalt opptak ved HVL | `@OPT-OVO-GRU-001` «Opprette et lokalt opptak» |
| Utdanningsbakgrunner | `utdanningsbakgrunner-godkjente` | «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» | TEST | Velges i innstillingene | Står blant de godkjente utdanningsbakgrunnene | `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001` «Legge til utdanningsbakgrunn med avvikende frister» |
| Poenglikhetsregler | `poenglikhetsregler` | «Loddtrekning», «Alle søkere med samme poengsum får tilbud» og «Alder, eldre foran yngre» | TEST | Velges i innstillingene | Finnes som valg | `@OPT-OVO-INN-001` |
| Organisasjoner fra utdanningsregisteret | `organisasjoner-utdanningsregisteret` | NTNU (universitet), Fagskolen Vestfold og Telemark (fagskole), og minst én til av hver type | TEST, replikert fra utdanningsregisteret | Søk i «Inviter» | Aktive læresteder | `@OPT-OVO-SAM-001` |
| Samordna opptak uten utdanningstilbud | `opptak-samordna-uten-utdanningstilbud` | «Samordna opptak 2027 (test)» | TEST | Søk på navnet i [opptaksoversikten](https://test-fsadmin.sikt.no/opptak) | Forvaltes av HK-dir. Ingen deltakere og ingen utdanningstilbud. Alle obligatoriske felt og frister er satt. Redigering av utdanningstilbud åpner 7 dager før testen og stenger 30 dager etter testen. Søknaden åpner 60 dager etter testen | `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, `@OPT-OVO-SAM-001` (bakgrunnen) |
| Samordna opptak med utdanningstilbud | `opptak-samordna-med-utdanningstilbud` | [Fylles ut] | TEST | Søk på navnet i opptaksoversikten | Forvaltes av HK-dir. NTNU er deltaker, og har minst ett utdanningstilbud i opptaket. Utdanningstilbudene bruker regler fra regelverkssamlingen. Redigering av utdanningstilbud er åpen på testdagen | `@OPT-OVO-INN-001` «Kan ikke endre opptakstype …» og «Kan ikke endre regelverkssamling …», `@OPT-OVO-SAM-001` «Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket» |
| Samordna opptak der en søker har valgt en utdanningsbakgrunn | `opptak-utdanningsbakgrunn-valgt-av-soker` | [Fylles ut] | TEST | Søk på navnet i opptaksoversikten | Har «Steinerskole» og minst én utdanningsbakgrunn til. En syntetisk søker har en søknad med «Steinerskole». Søknaden er åpen på testdagen | `@OPT-OVO-INN-001` «Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes» |
| Samordna opptak med én utdanningsbakgrunn | `opptak-en-utdanningsbakgrunn` | [Fylles ut] | TEST | Søk på navnet i opptaksoversikten | Har bare «Steinerskole». Ingen søker har valgt den | `@OPT-OVO-INN-001` «Den siste utdanningsbakgrunnen kan ikke fjernes» |
| Lokalt opptak | `opptak-lokalt` | «Lokalt opptak høst 2027 (test)» | TEST | Søk på navnet i opptaksoversikten | Lokalt opptak ved HVL | `@OPT-OVO-SAM-001` «Lokalt opptak tillater ikke andre organisasjoner» og «Saksbehandlertildeling er ikke relevant for lokale opptak» |
| Opptak i oversikten | `opptak-oversikt-flere-typer` | – | TEST | [Opptaksoversikten](https://test-fsadmin.sikt.no/opptak) | Opptak av minst to opptakstyper, ved minst to organisasjoner, opprettet på ulike dager | `@OPT-OVO-OVE-001` |
| Over 50 opptak | `opptak-oversikt-over-50` | – | TEST | Opptaksoversikten | Minst 51 opptak synlige for testbruker 1. **Finnes ikke i TEST** | `@OPT-OVO-OVE-001` «Liste viser de 50 første opptakene», «Laste inn 50 flere opptak» |

Data scenarioet selv lager (for eksempel opptakene i «Opprette et samordna opptak»), står ikke her: de lages av stegene i testcasen, og får kjøringen i navnet, fordi opptak ikke kan slettes.

## Omfang

Alle scenarioene i gating-settet i de fem kravene testes, også i kravene som ikke er levert. Det er et avvik fra teststrategien, avgjort av produkteier. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | `@OPT-OVO-GRU-001` | `@implemented`, én regel `@in-progress` (endres) | 9 (13 med eksemplene). 8 er levert, 1 er under endring |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | `@OPT-OVO-SAM-001` | `@in-progress` (ikke levert) | 15 |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | `@OPT-OVO-INN-001` | `@implemented` | 21 |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | `@OPT-OVO-FRI-001` | `@in-progress` (ikke levert) | 28 (42 med eksemplene) |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | `@OPT-OVO-OVE-001` | `@implemented` | 11 (16 med eksemplene). To kan ikke kjøres før det finnes over 50 opptak i TEST |
| **Totalt** | | | **84 (107 med eksemplene)**. 40 er levert, 44 er ikke levert |

Åpne spørsmål (testes som det står):

- `@OPT-OVO-SAM-001` «Organisasjoner som ikke deltar, kan ikke se opptaket»: skal regelen ha `@ref-OPT-OPT-UTD-001`?
- `@OPT-OVO-SAM-001` «En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det»: skal regelen ha `@ref-OPT-OPT-UTD-026`?
- `@OPT-OVO-SAM-001` «Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket»: er «forvaltende organisasjon» utvetydig nok for tilgangsstyringen?
- `@OPT-OVO-SAM-001` «Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak»: skal regelen ha `@ref-OPT-BEH-BEH-011`?
- `@OPT-OVO-FRI-001`: elleve regler spør om de skal ha `@ref-` til kravet der fristen brukes («åpne og stenge for redigering», «åpne for søkning», «generell søknadsfrist», «omprioriteringsfrist», «sletting av søknadsalternativer», «dokumentasjonsfrister», «ledige studieplasser», «frister for tidlig opptak», «informasjonsdatoer for opptaksresultat», «frist for endring av utdanningsbakgrunn» og «utdanningsbakgrunner med avvikende frister»). Spørsmålene endrer ikke hva som testes.
- `@OPT-OVO-FRI-001` «Sette første svarfrist som informasjon til søkere» (Q19, TAKE-414): er første svarfrist svarfristen på hovedrunden, eller en egen dato på opptaket? Koden har fjernet datoen på opptaket. Scenarioet vil trolig ikke bestå som det står.

Scenarioene i testen er gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo. Et scenario med et åpent spørsmål testes som det står.

De automatiske testene av de samme kravene: `npx playwright test --grep @scope-opprette-opptak-2027`

### Åpne spørsmål

`@openquestion` stopper ikke testen: delen testes som den står. Oversikten viser hvor mye som står åpent. Tallene er regnet fra kravfilene.

| Krav | Feature-ID | Regler med åpent spørsmål | Scenarioer med åpent spørsmål | Scenarioer i testen | Utkast (`@draft @openquestion`, ikke med) |
|---|---|---|---|---|---|
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | `@OPT-OVO-GRU-001` | 0 av 4 | 0 av 9 | 9 | 2 regler (gjenbruke innstillinger, deaktivere) |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | `@OPT-OVO-SAM-001` | 4 av 9 | 8 av 15 | 15 | – |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | `@OPT-OVO-INN-001` | 0 av 9 | 0 av 21 | 21 | – |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | `@OPT-OVO-FRI-001` | 11 av 14 | 19 av 28 | 28 | 1 regel (rekkefølgen på fristene) |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | `@OPT-OVO-OVE-001` | 0 av 2 | 0 av 11 | 11 | – |
| **Totalt** | | **15 av 38** | **27 av 84** | **84** | **3 regler** |

## Flyter

Flytene viser hva som skjer fra ett krav til det neste, på tvers av domener. Her testes overleveringene: at det ett krav lager, blir brukt av det neste. Kravene i fasene testes hver for seg i «Omfang».

### Saksbehandlertildeling (`@FLY-OPT-SAK-001`, `@planned`)

- **Testes**: nei
- **Hvorfor**: 0 av 5 faser er levert. Kravene fasene bygger på, er `@in-progress`, `@planned` eller `@draft` (verify 22.10.2026). Flyten testes når fasene er levert.

| Fase | Bygger på | Fase levert | I leveransen | Scenarioer i testen |
|---|---|---|---|---|
| Tildelingsreglene settes for opptaket | `@OPT-OVO-SAM-001` (`@in-progress`), `@OPT-BEH-BEH-011` (`@planned`) | nei | ja | – |
| Utdanningstilbudet får saksbehandlertildelingsregel | `@OPT-OPT-UTD-004` (`@draft`) | nei | nei | – |
| Søknadsalternativene fordeles når søknaden sendes | `@OPT-BEH-BEH-011` (`@planned`) | nei | nei | – |
| Den saksbehandlende organisasjonen ser saken | `@OPT-BEH-BEH-011` (`@planned`), `@OPT-BEH-BEH-010` (`@implemented`) | nei | nei | – |
| Søknadsalternativene flyttes når utdanningsbakgrunnen endres | `@OPT-OVO-FRI-001` (`@in-progress`), `@OPT-BEH-BEH-011` (`@planned`) | nei | ja | – |

### Vurdering per krav (fase 3)

Den interne akseptansetesten tester flyter og avhengigheter. Per krav vurderes det hva som testes:

| Krav | Inngår i flyt | Vurdering |
|---|---|---|
| `@OPT-OVO-GRU-001` | Ingen | Testes som oppgave uten flyt. Ny flyt bør vurderes: «Opprette og klargjøre et opptak», fra opptaket opprettes til lærestedene har lagt til utdanningstilbud (`fs-krav`, modus E) |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling (fase 1) | Flyten testes ikke: ingen faser er levert. Testes som oppgave uten flyt, og kobles til den nye flyten «Opprette og klargjøre et opptak» om den lages |
| `@OPT-OVO-INN-001` | Ingen | Testes som oppgave uten flyt. Kobles til den nye flyten om den lages |
| `@OPT-OVO-FRI-001` | Saksbehandlertildeling (fase 5) | Flyten testes ikke: ingen faser er levert. Testes som oppgave uten flyt, og kobles til den nye flyten om den lages |
| `@OPT-OVO-OVE-001` | Ingen | Testes som oppgave uten flyt |

Scenarioene som tas med i fase 3, er de som inngår i flytene, ikke alle. Er en tidligere levert flyt avhengig av noe leveransen endrer, står den med som regresjon. Ingen flyter i `krav/_Flyter/` er `@implemented` og avhengige av kravene her.

### Avhengighetskart

Det leveransen bygger på eller påvirker utenfor opptaksforvalterens flyt. Det sjekkes underveis i den interne testen der det er mulig, ellers for seg.

| Avhengighet | Type | Hvordan sjekkes det |
|---|---|---|
| Utdanningsregisteret (replika av organisasjonene) | Integrasjon | I oppgaven: organisasjonene i «Inviter» kommer fra registeret, og bare aktive læresteder vises (`InviterOrganisasjonerModal.tsx:49-57`) |
| Utdanningstilbud i opptak (Shinkansen, `@OPT-OPT-UTD-002`, `@OPT-OPT-UTD-003`) | Annet teams leveranse | I oppgaven: en deltakende organisasjon legger til et utdanningstilbud, og da kan ikke opptakstype og regelverkssamling endres, og deltakeren kan ikke fjernes. Redigerings- og trekkfristen brukes av utdanningstilbudene (virkningen testes ikke her) |
| Saksbehandlertildeling (Puff, `@OPT-BEH-BEH-011`) | Annet teams leveranse | I oppgaven: lenken til saksbehandlertildelingen i samordna opptak. API-et sperrer også fjerning av en deltaker som er sektororganisasjon i en aktiv tildelingsregel (`OpprettOpptakMutations.java:649-675`) |
| Søknad (`@OPT-SØK-SØK-017`, velge utdanningsbakgrunn) | Annen modul i FS | Testes for seg: krever en søknad der søkeren har valgt en utdanningsbakgrunn (testdata `opptak-utdanningsbakgrunn-valgt-av-soker`) |
| Plasstildeling (`@OPT-PLA-TIL-002`) | Annen modul i FS | Ikke i denne testen: taket for antall tilbud og første svarfrist flyttes til plasstildelingsrunden |
| Unleash-flaggene `opptak-opprett-samordna` og `opptak-filter-organisasjon` | Konfigurasjon | Sjekkes før testen (forutsetning 1): hvordan flaggene står i TEST |

## Venter på verifisering

Kravene og delene under er ikke levert, men testes likevel (avvik fra strategien, se over). De er de kjente manglene fra verifiseringen, og vil trolig ikke bestå. De tas inn som levert når `fs-verify` har satt `@implemented`.

| Krav | Feature-ID | Status | Hva som venter |
|---|---|---|---|
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | `@OPT-OVO-GRU-001` | `@in-progress` (delen) | Regelen «Utdanningsbakgrunner, poenglikhetsregel og maks antall søknadsalternativer må være satt for å lagre et opptak». Ikke funnet 21.10 (maks antall søknadsalternativer var ikke påkrevd). Koden krever nå feltet (`OpptakManagementPage.tsx:188-260`), men det er ikke verifisert. Taket er tatt ut av regelen 26.10 |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | `@OPT-OVO-SAM-001` | `@in-progress` | Hele kravet (10 av 15 funnet 22.10). Ikke funnet: en organisasjon som ikke deltar, kan åpne opptaket (TAKE-434), og en deltakende organisasjon ser ikke alle innstillingene (TAKE-432). Ikke funnet 22.10, men API-et sperrer det nå (`OpprettOpptakMutations.java:618-639`, TAKE-433): en deltaker med utdanningstilbud kan fjernes. Usikker: om lista over opptak filtreres (flagget `opptak-filter-organisasjon`), og om lenken til saksbehandlertildelingen bare skal stå på redigeringssiden (TAKE-447) |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/9a112c6/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | `@OPT-OVO-FRI-001` | `@in-progress` | Hele kravet (23 av 25 funnet 22.10, rekkefølgen er siden blitt `@draft`). Usikker: første svarfrist (Q19). Ikke verifisert: regelen «… må kunne sette frist for å trekke utdanningstilbud» (4 scenarioer, ny 26.10). Fristen er ikke påkrevd før TAKE-436, og rekkefølgen sjekkes ikke |

## Regler uten scenario

Verify-rapportene for leveransen er laget før `fs-verify` rapporterte regler i koden uten scenario. Reglene under er fra kodelesingen for testplanen (origin/main 27.10), og bør bekreftes i neste `fs-verify`.

| Krav | Regel i koden | Funnet i | Testes i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@OPT-OVO-GRU-001` | Navnet kan ha høyst 100 tegn på hvert språk | `fs-admin/.../OpptakInformation/OpptakInformation.tsx:12,50,64,79,88`, `opptak.graphqls:97` (`@maksLengde(tegn: 100)`) | ja: grenseverdier 100 og 101 tegn | nei |
| `@OPT-OVO-GRU-001` | Navn med bare mellomrom godtas ikke | `OpptakManagementPage.tsx:188-260` (`.trim()`), `KreverSprak.java:61` | ja | nei |
| `@OPT-OVO-INN-001` | Startnummer, maks antall søknadsalternativer og tilbud per tildelingsrunde må være hele tall større enn 0 | `OpptakSettings.tsx:280,293,306` (`min={0}`), `V0__kodeverk.sql:35` (`> 0`) | ja: 0 og 1. Skjemaet godtar 0, og API-et avviser det med en generell melding (trolig feil) | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Lenken til tidlig opptak må være en http- eller https-adresse | `V0__kodeverk.sql:30`, `OpprettOpptakMutations.java:712` | ja | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Tidlig opptak kan ikke slås av når utdanningstilbud tilbyr det | `OpprettOpptakMutations.java:222-227` | nei: krever et utdanningstilbud med tidlig opptak | ja (`fs-krav`) |
| `@OPT-OVO-INN-001` | Unntakene fra poenglikhetsregelen må velges når «kan overstyres» er på | `OpptakManagementPage.tsx:188-260` | ja | nei |
| `@OPT-OVO-FRI-001` | En dato som er delvis fylt ut, gir «Ugyldig dato. Fyll inn hele datoen, eller la feltet stå tomt.» | `opptak.json:227` | ja | nei |
| `@OPT-OVO-SAM-001` | Et samordna opptak med deltakere kan ikke gjøres om til lokalt | `OpprettOpptakMutations.java:341-354` | nei: skjemaet tilbyr det ikke | nei |
| `@OPT-OVO-SAM-001` | En deltaker som er sektororganisasjon i en aktiv tildelingsregel, kan ikke fjernes | `OpprettOpptakMutations.java:649-675` | nei: krever saksbehandlertildeling (Puff) | ja (`fs-krav`) |
| `@OPT-OVO-SAM-001` | Organisasjoner som allerede er lagt til, vises ikke i «Inviter», og søket i «Inviter» treffer navn, forkortelse og kode | `InviterOrganisasjonerModal.tsx:65-80` | ja | nei |

## Testcaser som skal lages

Omfanget av testcasene, ikke testcasene selv. `fs-testcaser-cdp` lager testcasene for fase 2 ut fra tabellen, og `fs-testcaser-intern` testcasene for fase 3. Teamet og testansvarlig går gjennom omfanget før testcasene lages.

### Fase 2: agentisk funksjonstest

| Krav | Regel | Scenarioer | Utledede testcaser | Teknikk |
|---|---|---|---|---|
| `@OPT-OVO-GRU-001` | Opptaksforvalter kan opprette et opptak | 2 | Samordna og lokalt med hver sin testbruker (1 og 4). Opptakstypene som vises: samordna skjuler «Lokal», lokalt skjuler FSU og UHG | ekvivalensklasser |
| `@OPT-OVO-GRU-001` | Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak | 3 | Obligatoriske felt «Navn på opptaket (bokmål)», regelverkssamling og opptakstype (tomt, bare mellomrom i navnet), og at banneret «Fyll ut obligatoriske felt:» viser feltet | ekvivalensklasser |
| `@OPT-OVO-GRU-001` | Utdanningsbakgrunner, poenglikhetsregel og maks antall søknadsalternativer må være satt for å lagre et opptak (ikke levert) | 1 (scenariomal: 3 eksempler) | Feilmeldingen «Velg minst én utdanningsbakgrunn.» | ekvivalensklasser |
| `@OPT-OVO-GRU-001` | Opptaket må ha navn på bokmål, nynorsk og engelsk | 3 (scenariomal: 3 eksempler) | Navn med 100 og 101 tegn på hvert språk, bare mellomrom, samisk tomt (valgfritt) | grenseverdianalyse, ekvivalensklasser |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak | 1 | Søket i «Inviter» på navn, forkortelse og kode. Organisasjoner som er lagt til, vises ikke | ekvivalensklasser |
| `@OPT-OVO-SAM-001` | Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud | 1 | – | – |
| `@OPT-OVO-SAM-001` | Organisasjoner som ikke deltar, kan ikke se opptaket (ikke levert) | 2 | – | – |
| `@OPT-OVO-SAM-001` | En deltakende organisasjon kan ikke fjernes … så lenge den har utdanningstilbud (ikke levert) | 2 | Feilmeldingen «Utdanningstilbudene til <organisasjon> må fjernes først» | tilstandsoverganger |
| `@OPT-OVO-SAM-001` | Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger (ikke levert) | 2 | – (scenarioene testes som de står, ingen egne testcaser for tilgang) | – |
| `@OPT-OVO-SAM-001` | I et lokalt opptak kan ikke andre organisasjoner legges til | 1 | – | – |
| `@OPT-OVO-SAM-001` | Kun organisasjoner som finnes i utdanningsregisteret kan legges til | 2 | – | – |
| `@OPT-OVO-SAM-001` | Opptaksforvalter kan begrense hvilke lærestedstyper som får delta | 2 | Begge filtrene på, og ingen på | ekvivalensklasser |
| `@OPT-OVO-SAM-001` | … se og navigere til saksbehandlertildelingen i samordna opptak (ikke levert) | 2 | – | – |
| `@OPT-OVO-INN-001` | … endre opptakstype så lenge ingen utdanningstilbud er knyttet til opptaket | 2 | – | tilstandsoverganger |
| `@OPT-OVO-INN-001` | … endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket | 2 | – | tilstandsoverganger |
| `@OPT-OVO-INN-001` | … setter standard poenglikhetsregel for opptaket | 2 | «Kan overstyres» på uten valgte unntak (obligatorisk), og med én og med alle unntak | beslutningstabell |
| `@OPT-OVO-INN-001` | … kan sette startnummer for søknadene | 2 | Grenseverdier 0, 1 og et stort tall. Desimaltall og tegn godtas ikke. Tomt felt gir startnummer 1 | grenseverdianalyse |
| `@OPT-OVO-INN-001` | … setter tak for antall søknadsalternativer | 1 | Obligatorisk felt (tomt). Grenseverdier 0 og 1 | grenseverdianalyse |
| `@OPT-OVO-INN-001` | … kan åpne for tidlig opptak | 3 | Lenken: tomt, bare mellomrom, uten http/https, med https | ekvivalensklasser, beslutningstabell |
| `@OPT-OVO-INN-001` | … kan åpne for søknad på ledige studieplasser | 1 | Datoene vises bare når valget er på | beslutningstabell |
| `@OPT-OVO-INN-001` | … kan legge til utdanningsbakgrunner som gjelder for opptaket | 5 | Bare godkjente utdanningsbakgrunner i lista. Fjerne til én er igjen | grenseverdianalyse, tilstandsoverganger |
| `@OPT-OVO-INN-001` | … kan styre om søkere kan laste opp dokumentasjon | 3 | – | – |
| `@OPT-OVO-FRI-001` | Åpne og stenge for redigering av utdanningstilbud | 2 | Dato delvis fylt ut («Ugyldig dato …») | ekvivalensklasser |
| `@OPT-OVO-FRI-001` | Frist for å trekke utdanningstilbud (ikke levert) | 4 (scenariomal: 2 eksempler) | Samme dag som redigeringen stenger, dagen før og dagen etter | grenseverdianalyse |
| `@OPT-OVO-FRI-001` | Åpne for søkning, søknadsfrist, omprioriteringsfrist, sletting av søknadsalternativer | 4 | – (dekket av «De ordinære fristene må være satt») | – |
| `@OPT-OVO-FRI-001` | Dokumentasjonsfrister | 2 | – | – |
| `@OPT-OVO-FRI-001` | Informasjonsdatoer for ledige studieplasser | 3 | – | – |
| `@OPT-OVO-FRI-001` | Frister for tidlig opptak | 4 (scenariomal: 3 eksempler) | Fristene vises bare når tidlig opptak er på | beslutningstabell |
| `@OPT-OVO-FRI-001` | Informasjonsdatoer for opptaksresultat | 2 | – | – |
| `@OPT-OVO-FRI-001` | Dato for aldersberegning | 2 | Bare dato, ikke klokkeslett | – |
| `@OPT-OVO-FRI-001` | Frist for endring av utdanningsbakgrunn | 1 | – | – |
| `@OPT-OVO-FRI-001` | Utdanningsbakgrunner med avvikende frister | 1 | – | – |
| `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | 3 (scenariomaler: 10 og 3 eksempler) | Banneret viser navnet på fristen som mangler | ekvivalensklasser |
| `@OPT-OVO-OVE-001` | Liste over alle opptak | 7 (scenariomal: 6 eksempler) | Rekkefølgen etter sortering på organisasjon (koden, ikke forkortelsen) | – |
| `@OPT-OVO-OVE-001` | Søk og filtrering av opptak | 4 | Søk på navn med små og store bokstaver, på nynorsk og engelsk, og del av navnet. Søk uten treff | ekvivalensklasser |
| | Regler uten scenario som testes (se over) | – | 7 regler: navnelengde, bare mellomrom, tall større enn 0, URL, unntak fra poenglikhet, delvis dato, søket i «Inviter» | grenseverdianalyse, ekvivalensklasser |

Testcasene står i `cdp-tester/02 Opptak/11 Opprette og vedlikeholde opptak/` når de er laget. Utledede testcaser lages bare der regelen har verdier eller betingelser å teste.

### Fase 3: intern akseptansetest

| Flyt eller oppgave | Krav | Scenarioer i flyten | Avhengigheter som sjekkes | Regresjon |
|---|---|---|---|---|
| Oppgave uten flyt: opprette-og-vedlikeholde-opptak (opprette → innstillinger → frister → invitere læresteder → oversikten) | `@OPT-OVO-GRU-001`, `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, `@OPT-OVO-SAM-001`, `@OPT-OVO-OVE-001` | – (oppgave uten flyt: `fs-testcaser-intern` velger scenarioene) | Utdanningsregisteret, utdanningstilbud i opptak, saksbehandlertildeling (lenken), Unleash-flaggene | nei |

Krav som ikke er med i noen flyt som kan testes: 5. De testes som en oppgave uten flyt. Flyten Saksbehandlertildeling testes ikke, fordi ingen faser er levert.

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Gjenbruke innstillinger fra et tidligere opptak (Opprette et opptak) | Ikke avklart ennå: hva kopieres, og hva kopieres ikke? Utsatt til senere iterasjon |
| Deaktivere et opptak (Opprette et opptak) | Ikke avklart ennå. Utsatt til senere iterasjon |
| Tak for antall tilbud per tildelingsrunde (Innstillinger for opptak) | Skal fjernes: flyttes til plasstildelingsrunden. Feltet finnes fortsatt i FS Admin (`OpptakSettings.tsx:302-314`) |
| Krav om studierett for å søke (Innstillinger for opptak) | Ikke avklart ennå |
| Fristene må komme i riktig rekkefølge (Frister og hendelser for opptak) | Ikke avklart ennå: hvilke frister må ligge før andre, og skal det være en sperre eller en advarsel? |
| Hendelseslogg for opptak | Kommer senere: venter på en generell løsning |
| Fellestekster og svarmeldingsmal | Skal ikke lages nå. Utsatt til senere iterasjon (sikt-no/fs#214) |
| Virkningen av innstillingene og fristene hos søkeren, i saksbehandlingen og for utdanningstilbudene | Kommer senere: står i kravene der verdiene brukes, og har ingen oppgave ennå (se «Uløst arbeid» i scope-fila) |
| Status i oversikten over opptak | Ikke med i kravet: det er ennå ikke forskjell på aktive og deaktiverte opptak |
| Sortering på navn i oversikten over opptak | Ønsket av HK-dir, men ikke med i kravet nå |
| Flyten Saksbehandlertildeling, alle fem fasene | Fasen er ikke levert |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | Marit Bjørnerud Rønning | Eier testen fra start til beslutning. Har ansvaret for at agenten blir kjørt og tester riktig (kjøringen kan gjøres av andre), går gjennom testcasene før kjøringen og funnene etterpå, tar stikkprøver av beståtte testcaser etter en risikovurdering, og skriver beslutningen i testrapporten |
| Kjører av agenten | Mats Gimming Myhre | Starter den agentiske funksjonstesten (fase 2) |
| Kontaktperson i teamet | Karen Skadsheim Sikkeland | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | Maciek Adamczyk og Jøran Wigen Aasterud (teamet) | [Fylles ut: hvilke deler] |
| Eksterne testere | HK-dir og lærestedene | [Fylles ut: hvem som tester] |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Agentisk funksjonstest | [Fylles ut: dato for kjøringen]. Mats Gimming Myhre kjører agenten |
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | [Fylles ut: dato, eller «Avklares med de eksterne partene»] |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Opprette og vedlikeholde opptak» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der. Flaggene `opptak-opprett-samordna` og `opptak-filter-organisasjon` står slik teamet har bestemt | [Fylles ut av teamet] |
| 2 | Testdataene i «Testdata» finnes i testmiljøet, i utgangstilstanden der. Tilstander som bygger på datoer, er sjekket samme dag som testen | [Fylles ut av teamet]. Over 50 opptak finnes ikke i TEST |
| 3 | Testdataene kan settes tilbake før hver kjøring | Nei: opptak kan ikke slettes. Opptakene testene oppretter, blir liggende, og får kjøringen i navnet |
| 4 | Testbrukerne finnes i rollene ved organisasjonene kravene gjelder (tilgangsmatrisen) | [Fylles ut av teamet]. Testbruker 2 trenger `MEDLEM_OPPTAK` når TAKE-423 er merget |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten. Åpne spørsmål stopper ikke, og står i «Åpne spørsmål» | Nei (avvik, se over): 3 av 5 krav er `@implemented`. Samordna opptak 10 av 15 og Frister 23 av 25 (22.10), regelen i Opprette et opptak 0 av 1 (21.10), og regelen om trekkfrist er ikke verifisert. Kontrollert av `fs-verify-kontroll`. Venter på kontroll av en person |
| 6 | De agentiske testcasene (`fs-testcaser-cdp`) er laget, og testansvarlig og teamet har gått gjennom dem før kjøringen | Venter |
| 7 | Testcasene for den interne akseptansetesten (`fs-testcaser-intern`) er laget og gått gjennom av testansvarlig | Venter |
| 8 | Testansvarlig er logget inn i FS Admin i en egen Chrome-profil til testingen, CDP-agenten kan bytte til hver testbruker i «Overstyrt bruker», og nøklene i testbrukere og testdata er utfylt | Verdiene i «Overstyrt bruker» er utfylt for alle fire testbrukerne. [Fylles ut av teamet: nøklene i testdata] |
| 9 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |

## Kriterier for godkjent

Kravene i «Omfang» er kriteriene for godkjent: hvert scenario er et akseptansekriterium. Mangler et viktig tilfelle, legges det inn i kravet (`fs-krav`), ikke her. Fasene er ferdige når:

| Fase | Ferdig når |
|---|---|
| 1. Verifisering | Alle scenarioene er funnet, og en annen person har kontrollert rapporten. Åpne spørsmål står i testplanen, men stopper ikke |
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
| 1. Verifisering (`fs-verify`) | [Verifisering – … v2 – 2026-10-26 09:41](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148540945) (utkast), [Verifisering – … – 2026-10-21 14:42](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5127045158), [Verifisering – … – 2026-10-21 21:42](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128650825) · [verify-2026-10-26-0941.md](../../tasks/opptak/opprette-og-vedlikeholde-opptak/spec/verify-2026-10-26-0941.md) · [verify-saksbehandlertildeling-2026-10-22-1419.md](../../krav/_Flyter/10%20Opptaksl%C3%B8pet/verify-saksbehandlertildeling-2026-10-22-1419.md) (flytrapport, bare referanse) | 4 ikke funnet, 3 usikker (Opprette et opptak, delen: 1 ikke funnet. Samordna opptak: 3 ikke funnet, 2 usikker. Frister: 1 usikker. Innstillinger og oversikten: alt funnet). Regelen om trekkfrist er ikke verifisert | 2026-10-26 |
| Testplan | (denne siden) | Laget, versjon 2 | 2026-10-27 |
| 2. Agentisk funksjonstest | – | Venter | |
| 3. Intern akseptansetest | – | Venter | |
| 4. Ekstern akseptansetest | – | Venter | |

Testrapportene (verifisering, agentisk, intern og ekstern) står som undersider, og lenken står i raden for fasen.

## Vedlegg

| Vedlegg | Lenke |
|---|---|
| Verifiseringsrapporten (fase 1) | Se «Status i flyten» |
| Agentisk testrapport (fase 2) | – |
| Testcasene for fase 2 | – (`cdp-tester/02 Opptak/11 Opprette og vedlikeholde opptak/` når de er laget). CDP-kjøringene av de interne testcasene 26.10 (Opus og Sonnet) er forsøk, ikke fase 2: [sammenligning](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5144346655) |
| Testcasene for fase 3 | – |
| Forrige testløp (versjon 1) | [Testplan](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165), [intern akseptansetest 22.10](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5127209099), [ekstern akseptansetest](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137334279) |

## Sporbarhet per krav

Fylles ut av rapportene etter hvert som fasene er ferdige. Raden følger scenarioet fra kravet til koden og til testen. «Kode (fase 1)» er resultatet og de første referansene fra verify-rapporten (klokkeslettet står i parentes).

| Krav | Scenario | Kode (fase 1) | Testcase, teknikk og resultat (fase 2) | Flyt (fase 3) |
|---|---|---|---|---|
| `@OPT-OVO-GRU-001` | Opprette et samordna opptak | Levert før verify-rapportene i repoet. Ingen fil:linje (testet 19.10 og 22.10) | | |
| `@OPT-OVO-GRU-001` | Opprette et lokalt opptak | Levert før verify-rapportene i repoet. Ingen fil:linje (testet 19.10 og 22.10) | | |
| `@OPT-OVO-GRU-001` | Lagre opptak uten navn | Levert før verify-rapportene i repoet. Ingen fil:linje (testet 19.10 og 22.10) | | |
| `@OPT-OVO-GRU-001` | Lagre opptak uten regelverkssamling | Levert før verify-rapportene i repoet. Ingen fil:linje (testet 19.10 og 22.10) | | |
| `@OPT-OVO-GRU-001` | Lagre opptak uten opptakstype | Levert før verify-rapportene i repoet. Ingen fil:linje (testet 19.10 og 22.10) | | |
| `@OPT-OVO-GRU-001` | Lagre opptak uten <innstilling> | ikke funnet (1958/1442): `AMP:190-197`, `AMP:172-221` | | |
| `@OPT-OVO-GRU-001` | Angi opptaksnavn på flere språk | Levert før verify-rapportene i repoet. Ingen fil:linje (testet 19.10 og 22.10) | | |
| `@OPT-OVO-GRU-001` | Lagre opptak med navn på alle obligatoriske språk | Levert før verify-rapportene i repoet. Ingen fil:linje (testet 19.10 og 22.10) | | |
| `@OPT-OVO-GRU-001` | Navn mangler på et obligatorisk språk | Levert før verify-rapportene i repoet. Ingen fil:linje (testet 19.10 og 22.10) | | |
| `@OPT-OVO-SAM-001` | Legge til lærested i samordna opptak | funnet (1419): `OOM:572-616`, `V280:1160-1165` | | |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar kan ikke legge til utdanningstilbud | funnet (1419): `V280:1160-1165`, `SFT:217-230` | | |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar, ser ikke opptaket | usikker (1419): `OPS/opptak/OpptakService.java:46-65`, `V280:1054-1055` | | |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke deltar, kan ikke åpne opptaket | ikke funnet (1419): `fs-admin/src/app/opptak/[id]/layout.tsx:26-39`, `[id]/page.tsx:8-21` | | |
| `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket | ikke funnet (1419): `OOM:572-616`, `V280:312-324` | | |
| `@OPT-OVO-SAM-001` | Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket | funnet (1419): `OOM:588-594`, `V319:67-68` | | |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger | funnet (1419): `V319:32-34,74-92`, `SFT:232-254` | | |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger | ikke funnet (1419): `V319:32-34`, `SFT:256-278` | | |
| `@OPT-OVO-SAM-001` | Lokalt opptak tillater ikke andre organisasjoner | funnet (1419): `OOM:79-83,298-302`, `OOM:343-355` | | |
| `@OPT-OVO-SAM-001` | Legge til organisasjon som finnes i utdanningsregisteret | funnet (1419): `V280:320-321`, `SFT:286-296` | | |
| `@OPT-OVO-SAM-001` | Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til | funnet (1419): `V280:320-321`, `OOM:682-684` | | |
| `@OPT-OVO-SAM-001` | Filtrere på universiteter og høyskoler | funnet (1419): `InviterOrganisasjonerModal.tsx:43,55,152-159`, `InviterOrganisasjonerModal/components/OrganisasjonFilters/OrganisasjonFilters.tsx:49-51` | | |
| `@OPT-OVO-SAM-001` | Filtrere på fagskoler | funnet (1419): `InviterOrganisasjonerModal.tsx:43,55,152-159`, `SFT:323-327` | | |
| `@OPT-OVO-SAM-001` | Se og navigere til saksbehandlertildelingen for opptaket | usikker (1419): `ADO/OpptakManagement/Samordning/Samordning.tsx:50-60`, `AMP:430-441` | | |
| `@OPT-OVO-SAM-001` | Saksbehandlertildeling er ikke relevant for lokale opptak | funnet (1419): `MUT:213`, `OOM:404,453` | | |
| `@OPT-OVO-INN-001` | Endre opptakstype når ingen utdanningstilbud er knyttet til opptaket | funnet (0941): `AOS:195,229-240`, `ACI:196-198` | | |
| `@OPT-OVO-INN-001` | Kan ikke endre opptakstype når utdanningstilbud er knyttet til opptaket | funnet (0941): `AOS:195,239`, `OOM:237-239` | | |
| `@OPT-OVO-INN-001` | Endre regelverkssamling når ingen utdanningstilbud er knyttet til opptaket | funnet (0941): `AOS:241-252`, `ACI:199-200` | | |
| `@OPT-OVO-INN-001` | Kan ikke endre regelverkssamling når utdanningstilbud er knyttet til opptaket | funnet (0941): `AOS:195,251`, `OOM:241-243` | | |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel med mulighet for unntak per utdanningstilbud | funnet (0941): `AOS:316-347`, `ACI:104-110,182-183` | | |
| `@OPT-OVO-INN-001` | Standard poenglikhetsregel uten mulighet for unntak | funnet (0941): `ACI:105`, `OOM:115-119,517-528` | | |
| `@OPT-OVO-INN-001` | Sette startnummer for søknader i opptaket | funnet (0941): `AOS:277-288`, `OOM:94,203-204` | | |
| `@OPT-OVO-INN-001` | Startnummeret er 1 når opptaksforvalter ikke har satt det | funnet (0941): `AEO:30`, `AOS:277-288` | | |
| `@OPT-OVO-INN-001` | Sette maks antall søknadsalternativer | funnet (0941): `AOS:289-301`, `OOM:98-100,209-210` | | |
| `@OPT-OVO-INN-001` | Aktivere tidlig opptak | funnet (0941): `AOS:375-383`, `OOM:104,221-229` | | |
| `@OPT-OVO-INN-001` | Sette lenke til informasjon om tidlig opptak | funnet (0941): `AOS:348-361`, `ACI:150-151` | | |
| `@OPT-OVO-INN-001` | Lenken må være satt når tidlig opptak er aktivert | funnet (0941): `AMP:221-227,270-274`, `AMP:508` | | |
| `@OPT-OVO-INN-001` | Aktivere ledige studieplasser | funnet (0941): `AOS:367-374`, `OOM:101,212-213` | | |
| `@OPT-OVO-INN-001` | Legge til utdanningsbakgrunner fra godkjent liste | funnet (0941): `AOS:171-175`, `PU:22-48` | | |
| `@OPT-OVO-INN-001` | Legge til flere utdanningsbakgrunner | funnet (0941): `AOS:255-272`, `PU:76-82` | | |
| `@OPT-OVO-INN-001` | Fjerne en utdanningsbakgrunn fra opptaket | funnet (0941): `AOS:255-272`, `PU:72-74` | | |
| `@OPT-OVO-INN-001` | Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes | funnet (0941): `PMIG/V429__soknad_utdanningsbakgrunn_fra_opptak_v2.sql:30-40`, `OOM:704-706` | | |
| `@OPT-OVO-INN-001` | Den siste utdanningsbakgrunnen kan ikke fjernes | funnet (0941): `AOS:266-270`, `AMP:205-208,270-274` | | |
| `@OPT-OVO-INN-001` | Opplasting er åpen når opptaksforvalter ikke har endret innstillingen | funnet (0941): `AEO:26`, `ACI:132` | | |
| `@OPT-OVO-INN-001` | Åpne for dokumentasjonsopplasting | funnet (0941): `AOS:384-390`, `OOM:102,215-216` | | |
| `@OPT-OVO-INN-001` | Stenge for dokumentasjonsopplasting | funnet (0941): `AOS:384-390`, `OOM:102,215-216` | | |
| `@OPT-OVO-FRI-001` | Sette når redigering av utdanningstilbud åpner | funnet (1419): `V444:40`, `OOM:120-131,745-760` | | |
| `@OPT-OVO-FRI-001` | Sette når redigering av utdanningstilbud stenger | funnet (1419): `V444:41`, `FK:43` | | |
| `@OPT-OVO-FRI-001` | Sette frist for å trekke utdanningstilbud | Ikke verifisert (regelen er lagt til 26.10) | | |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten fristen for å trekke utdanningstilbud | Ikke verifisert (regelen er lagt til 26.10) | | |
| `@OPT-OVO-FRI-001` | Fristen for å trekke utdanningstilbud kan være samme dag som redigeringen stenger, eller senere | Ikke verifisert (regelen er lagt til 26.10) | | |
| `@OPT-OVO-FRI-001` | Fristen for å trekke utdanningstilbud kan ikke være før redigeringen stenger | Ikke verifisert (regelen er lagt til 26.10) | | |
| `@OPT-OVO-FRI-001` | Sette søknadsdato | funnet (1419): `V444:42`, `OFT:415-436` | | |
| `@OPT-OVO-FRI-001` | Sette ordinær søknadsfrist | funnet (1419): `V444:43`, `OFT:438-453` | | |
| `@OPT-OVO-FRI-001` | Sette omprioriteringsfrist | funnet (1419): `V444:44`, `OFT:455-479` | | |
| `@OPT-OVO-FRI-001` | Sette frist for sletting av søknadsalternativer | funnet (1419): `V444:45`, `FK:47` | | |
| `@OPT-OVO-FRI-001` | Sette ordinær dokumentasjonsfrist | funnet (1419): `V444:46`, `FK:48` | | |
| `@OPT-OVO-FRI-001` | Sette ettersendingsfrist | funnet (1419): `V444:47`, `OFT:481-504` | | |
| `@OPT-OVO-FRI-001` | Sette informasjonsfrist for ledige studieplasser | funnet (1419): `V444:51`, `OFT:506-515` | | |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser kan søkes | funnet (1419): `V444:52`, `OFT:517-529` | | |
| `@OPT-OVO-FRI-001` | Sette dato for når ledige studieplasser stenger for søkning | funnet (1419): `V444:53`, `OFT:531-546` | | |
| `@OPT-OVO-FRI-001` | Sette søknadsfrist for tidlig opptak | funnet (1419): `V444:48`, `OFT:548-571` | | |
| `@OPT-OVO-FRI-001` | Sette dokumentasjonsfrist for tidlig opptak | funnet (1419): `V444:49`, `V439:4-12` | | |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> når tidlig opptak er aktivert | funnet (1419): `AMP:240-262`, `AMP:270-274,497` | | |
| `@OPT-OVO-FRI-001` | Sette frist for poenggrenser for tidlig opptak | funnet (1419): `V444:21,50`, `SCH/opptak/opptakshendelse.graphqls:247` | | |
| `@OPT-OVO-FRI-001` | Sette dato for når hovedopptaket publiseres og søker kan forvente svar | funnet (1419): `V444:57`, `OFT:588-596` | | |
| `@OPT-OVO-FRI-001` | Sette første svarfrist som informasjon til søkere | usikker (1419): `V138__fjern_svarfrist.sql:5-13`, `OPS/opptak/HendelseInputValidering.java:28-39` | | |
| `@OPT-OVO-FRI-001` | Sette dato for aldersberegning | funnet (1419): `V444:55`, `SCH/opptak/opptakshendelse.graphqls:238` | | |
| `@OPT-OVO-FRI-001` | Standarddato når datoen ikke er satt | funnet (1419): `OPS/opptak/AldersberegningsdatoDefault.java:19-21,34-50`, `OOM:73,185-189` | | |
| `@OPT-OVO-FRI-001` | Sette frist for endring av utdanningsbakgrunn | funnet (1419): `V444:54`, `FK:56` | | |
| `@OPT-OVO-FRI-001` | Legge til utdanningsbakgrunn med avvikende frister | funnet (1419): `OPS/opptak/OpptakUtdanningsbakgrunner.java:83-112`, `ADO/OpptakManagement/utils/utdanningsbakgrunnUtils.ts:16-19,72-101` | | |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> | funnet (1419): `V444:40-47,54,57`, `ODS:160-161` | | |
| `@OPT-OVO-FRI-001` | Opptaket kan ikke lagres uten <frist> når ledige studieplasser er aktivert | funnet (1419): `V444:51-53`, `FK:38` | | |
| `@OPT-OVO-FRI-001` | Dato for aldersberegning og avvikende frister kan stå tomme | funnet (1419): `AldersberegningsdatoDefault.java:34-43`, `AMP:243-246` | | |
| `@OPT-OVO-OVE-001` | Se liste over opptak | funnet (2142): `fs-admin/src/app/opptak/page.tsx:1-4`, `AOV/components/OpptakResultList/OpptakResultList.tsx:60-77` | | |
| `@OPT-OVO-OVE-001` | Liste er sortert etter når opptaket ble opprettet som standard | funnet (2142): `AOV/hooks/useGetOpptakOverviewState.ts:11-14`, `PS:12` | | |
| `@OPT-OVO-OVE-001` | Velge sorteringsretning for <felt> | funnet (2142): `AOV/components/OpptakOrderBy/OpptakOrderBy.tsx:14-24`, `PS:85-88` | | |
| `@OPT-OVO-OVE-001` | Liste viser de 50 første opptakene | funnet (2142): `AOV/hooks/useGetOpptakOverviewState.ts:15`, `fs-admin/src/common/hooks/useDataListState/useDataListState.tsx:33,107-108` | | |
| `@OPT-OVO-OVE-001` | Laste inn 50 flere opptak | funnet (2142): `AOV/components/OpptakResultList/OpptakResultList.tsx:28-30`, `NL/components/ListBody/ListBody.tsx:89-97` | | |
| `@OPT-OVO-OVE-001` | Alle opptak er lastet inn | funnet (2142): `NL/components/ListBody/components/FetchMoreButton/FetchMoreButton.tsx:124,160`, `AOV/OpptakOverviewView.queries.ts:29-32` | | |
| `@OPT-OVO-OVE-001` | Navigere til detaljside for opptak | funnet (2142): `AOV/components/OpptakResultList/OpptakResultList.tsx:51-59` | | |
| `@OPT-OVO-OVE-001` | Fritekst-søk på navn | funnet (2142): `AOV/components/filter/OpptakSearchFilter/OpptakSearchFilter.tsx:16-23`, `AOV/components/OpptakFilter/OpptakFilter.tsx:34-39` | | |
| `@OPT-OVO-OVE-001` | Tilgjengelige opptakstyper i filter | funnet (2142): `AOV/components/filter/OpptakTypeFilter/OpptakTypeFilter.tsx:13-20,31-35,53`, `AOV/hooks/useGetOpptakOverviewState.ts:9` | | |
| `@OPT-OVO-OVE-001` | Filtrere på opptakstype | funnet (2142): `AOV/components/filter/OpptakTypeFilter/OpptakTypeFilter.tsx:37-40`, `AOV/components/OpptakFilter/OpptakFilter.tsx:49-54` | | |
| `@OPT-OVO-OVE-001` | Kombinere filtre | funnet (2142): `AOV/hooks/useGetOpptak.tsx:21-26`, `PS:47-74` | | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
