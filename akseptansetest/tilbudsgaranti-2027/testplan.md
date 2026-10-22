# Testplan – Tilbudsgaranti i saksbehandlingen 2027

- **Leveranse**: scope
- **Kilde**: `@scope-tilbudsgaranti-2027`
- **Scope**: @scope-tilbudsgaranti-2027
- **Scope-fil**: [scope-tilbudsgaranti-2027](../../tasks/opptak/scope-tilbudsgaranti-2027.md)
- **Oppgaver**: [opptak/tilbudsgaranti](../../tasks/opptak/tilbudsgaranti/oppgave.md)
- **Krav**: 4 feature-filer, 1 `@implemented`, commit `6478bee` (2026-10-22)
- **Verifisering**: [verify-2026-10-22-0850.md](../../tasks/opptak/tilbudsgaranti/spec/verify-2026-10-22-0850.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5130158105 (utkast), under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner)
- **Laget**: 2026-10-22 av fs-testplan

---

Testplan for «Tilbudsgaranti i saksbehandlingen 2027». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Testen gjelder hvordan saksbehandler, tilbyder og opptaksforvalter gir og forvalter tilbudsgaranti i saksbehandlingen i FS Admin. Hva tilbudsgarantien gir i plasstildelingen, og tilbudsgaranti fra tidligopptaket, testes ikke her. Saksbehandler, tilbyder og opptaksforvalter kan gi søkeren tilbudsgaranti på et søknadsalternativ i saksbehandlingen i FS Admin, hver i sitt felt og med tilbudsgarantitypene opptaket har for rollen. De kan endre og fjerne sin egen tilbudsgaranti, og ser tilbudsgarantiene fra de andre rollene uten å kunne endre dem. Endringsloggen på saken viser hvem som satte eller fjernet tilbudsgarantien, når, og på hvilket søknadsalternativ. Tilbudsgarantien følger søknadsalternativet når søkeren endrer prioriteten, og når søknadsalternativet flyttes til en annen saksbehandlende organisasjon. Den faller bort når søknadsalternativet fjernes eller søknaden trekkes, og gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen. |
| Versjon | [Fylles ut: versjon eller dato for deploy. Verifisert mot fs-plattform `0229f59fb3` og fs-admin `ba0ec3ef70`] |
| Testmiljø | [https://test-fsadmin.sikt.no/](https://test-fsadmin.sikt.no/) |
| Feature-flagg | Ingen |
| Kilde | Scopet [scope-tilbudsgaranti-2027](https://github.com/sikt-no/fs/blob/6478beea804db1a91ade2db494161ec86f4f2775/tasks/opptak/scope-tilbudsgaranti-2027.md), oppgaven [tilbudsgaranti](https://github.com/sikt-no/fs/tree/6478beea804db1a91ade2db494161ec86f4f2775/tasks/opptak/tilbudsgaranti) |
| Scope | `@scope-tilbudsgaranti-2027` · [scope-fila på GitHub](https://github.com/sikt-no/fs/blob/6478beea804db1a91ade2db494161ec86f4f2775/tasks/opptak/scope-tilbudsgaranti-2027.md) |
| Saker | [#512](https://github.com/sikt-no/fs/issues/512) · [STEK-241](https://sikt.atlassian.net/browse/STEK-241), [STEK-626](https://sikt.atlassian.net/browse/STEK-626), [STEK-627](https://sikt.atlassian.net/browse/STEK-627) |
| Berører andre team | [Fylles ut: står ikke i oppgaven] |
| Kjente begrensninger | <ul><li>Skissen fra designeren viser én tilbudsgaranti per søknadsalternativ. Løsningen viser alltid alle tre, «Tilbudsgaranti fra behandler», «… fra tilbyder» og «… fra forvalter», og bare feltet for rollen brukeren har, kan endres (STEK-270). Det er løsningen, ikke skissen, som er riktig.</li><li>Valglisten viser også tilbudsgarantityper som ikke er aktive, og løsningen godtar dem. Kravet sier ingenting om det.</li><li>Endringsloggen bruker ordene «Behandler», «Tilbyder» og «Forvalter», og skiller mellom «satte», «endret» og «fjernet».</li><li>Implementasjonsdetaljene (`gi_tilbudsgaranti.design.md`) er ikke skrevet ennå.</li><li>Det søkeren gjør (endre prioritet, fjerne og legge inn igjen søknadsalternativet, trekke søknaden), skjer i Min kompetanse, som ikke er sjekket i verifiseringen.</li></ul> |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | [Fylles ut: navn] | Saksbehandler ved den saksbehandlende organisasjonen | [Fylles ut: organisasjon A, for eksempel UiO] | Sette, endre og fjerne tilbudsgaranti, se tilbudsgarantiene fra de andre rollene, endringsloggen, og endre utdanningsbakgrunnen så søknadsalternativet flyttes (`@OPT-BEH-BEH-010`) |
| 2 | [Fylles ut: navn] | Tilbyder: saksbehandler ved lærestedet som tilbyr utdanningstilbudet | [Fylles ut: organisasjon B, for eksempel UiT] | Sette tilbudsgaranti fra tilbyder, også når søknaden ikke kan poengberegnes (`@OPT-BEH-BEH-010`) |
| 3 | [Fylles ut: navn] | Opptaksforvalter ved den forvaltende organisasjonen, med SE_SØKNADSBEHANDLING, MODIFISERE_OPPTAK og OPPTAK_TILBGARANTI_GI_VIA_OPPTAK | [Fylles ut: organisasjonen som forvalter opptaket, for eksempel HK-dir] | Sette tilbudsgaranti fra opptaksforvalter, og ikke kunne endre den fra saksbehandler (`@OPT-BEH-BEH-010`) |
| 4 | [Fylles ut: navn] | Søker | – | Endre prioritet, fjerne og legge inn igjen søknadsalternativet, og trekke søknaden, i Min kompetanse (`@OPT-BEH-BEH-010`) |

Testbrukerne finnes i minst to organisasjoner, så vi kan teste at ingen ser data de ikke skal se.

### Testdata

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| Et opptak med tilbudsgarantityper for alle tre rollene, for eksempel «Tilbudsgaranti innvilges etter klage» (saksbehandler), «Tilbudsgaranti, særskilt vurdering» (tilbyder) og «Tilbudsgaranti gitt etter telefonsamtale» (opptaksforvalter), og én type som bare kan brukes av tilbyder. Søknadsfristen i opptaket må ikke ha gått ut | [Fylles ut: opptak] | [Fylles ut] | [Fylles ut] |
| En tilbudsgarantitype som bare finnes i et annet opptak | [Fylles ut: opptak og type] | [Fylles ut] | [Fylles ut] |
| En søker med en søknad med minst tre søknadsalternativer, der ett tilbys av en annen organisasjon enn den som saksbehandler | [Fylles ut: søker] | [Fylles ut] | [Fylles ut] |
| En søknad som ikke kan poengberegnes | [Fylles ut: søker] | [Fylles ut] | [Fylles ut] |
| En søker der utdanningsbakgrunnen kan endres, så søknadsalternativet flyttes til en annen saksbehandlende organisasjon | [Fylles ut: søker] | [Fylles ut] | [Fylles ut] |
| En søker som kan trekke søknaden | [Fylles ut: søker] | [Fylles ut] | [Fylles ut] |

## Omfang

Det som testes, er kravene som er `@implemented`. Feature-ID-ene her er kravene resten av testflyten bruker.

### tilbudsgaranti

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Gi tilbudsgaranti](https://github.com/sikt-no/fs/blob/6478beea804db1a91ade2db494161ec86f4f2775/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti.feature) | `@OPT-BEH-BEH-010` | `@implemented` | 17 (25 testcaser med eksemplene i scenariomalene) |

Scenarioene i testen er de leverte scenarioene i gating-settet: alle scenarioene som ikke er utkast, avviklet eller demo, og som ikke er under endring. Et levert scenario med et åpent spørsmål testes som det står, og spørsmålet står under tabellen. Er kilden et scope, og kravet ble levert før, er det bare delene som er levert i scopet.

De automatiske testene av de samme kravene: `npx playwright test --grep @scope-tilbudsgaranti-2027`

## Flyter

Ingen av kravene er med i en flyt.

## Venter på verifisering

Ingen.

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| [Forvalte tilbudsgarantityper](https://github.com/sikt-no/fs/blob/6478beea804db1a91ade2db494161ec86f4f2775/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/forvalte_tilbudsgarantityper.feature) (`@OPT-OVO-INN-004`) | Kommer senere: utkast uten scenarioer. Tilbudsgarantitypene legges inn i databasen per opptak for 2027 |
| [Reservert studieplass](https://github.com/sikt-no/fs/blob/6478beea804db1a91ade2db494161ec86f4f2775/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/reservert_studieplass.feature) (`@OPT-SØK-SØK-016`) | Kommer senere: utkast uten scenarioer, satt på vent |
| Tilbudsgaranti fra tidligopptaket (`@OPT-BEH-BEH-007`) | Egen oppgave, [tidlig-opptak](https://github.com/sikt-no/fs/tree/6478beea804db1a91ade2db494161ec86f4f2775/tasks/opptak/tidlig-opptak), med egen testplan |
| At søkeren med tilbudsgaranti får tilbud i plasstildelingen (`@OPT-PLA-TIL-002`) | Hører til scope-plasstildeling-2027 |
| Hvilken utdanningskvote tilbudsgarantiene tas fra (`@OPT-OPT-UTD-004`) | Hører til scope-utdanningstilbud-2027 |
| [Velge utdanningskvote for tilbudsgaranti](https://github.com/sikt-no/fs/blob/6478beea804db1a91ade2db494161ec86f4f2775/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_utdanningskvote_for_tilbudsgaranti.feature) (`@OPT-BEH-BEH-017`) | Kommer senere: utkast uten scenarioer |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | Ingrid Grimstad Helset | Eier testen fra start til beslutning, og skriver beslutningen i testrapporten |
| Kontaktperson i teamet | Daniel Sachse | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | [Fylles ut] | [Fylles ut] |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | Avklares med de eksterne partene |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Tilbudsgaranti i saksbehandlingen 2027» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene er identifisert og tilgjengelige | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt | [Fylles ut av teamet] |
| 4 | Testbrukerne finnes i rollene leveransen gjelder, i minst to organisasjoner | [Fylles ut av teamet] |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | Oppfylt: 17 av 17 funnet 2026-10-22, kontrollert av `fs-verify-kontroll` |
| 6 | Testcasene er laget og gått gjennom av testansvarlig | Venter |
| 7 | Testansvarlig har logget inn som testbruker og ser testdataene | [Fylles ut av testansvarlig] |

## Kriterier for godkjent

Testansvarlig skriver hva som skal til for at testen blir godkjent, helst før utviklingen starter.

[Fylles ut av testansvarlig]

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

| Steg | Side | Status | Dato |
|---|---|---|---|
| 1. Verifisering (`fs-verify`) | [Verifisering – Tilbudsgaranti i saksbehandlingen 2027 – 2026-10-22 08:50](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/edit-v2/5130125348) (utkast), [verify-2026-10-22-0850.md](../../tasks/opptak/tilbudsgaranti/spec/verify-2026-10-22-0850.md) | Alt funnet | 2026-10-22 |
| 2. Testplan | (denne siden) | Laget | 2026-10-22 |
| 3. Testrapport – verifisering | – | Venter | |
| 4. Intern akseptansetest | – | Venter | |
| 4b. CDP-kjøring (valgfri) | – | Ikke aktuell | |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | – | Venter | |
| 7. Testrapport – ekstern | – | Venter | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
