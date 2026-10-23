# Testplan – Opprette opptak 2027

- **Leveranse**: scope
- **Kilde**: `@scope-opprette-opptak-2027`
- **Scope**: @scope-opprette-opptak-2027
- **Scope-fil**: [scope-opprette-opptak-2027](../../tasks/opptak/scope-opprette-opptak-2027.md)
- **Oppgaver**: [opptak/opprette-og-vedlikeholde-opptak](../../tasks/opptak/opprette-og-vedlikeholde-opptak/oppgave.md)
- **Krav**: 8 feature-filer i scopet, 5 i testen (2 `@implemented`, 3 `@in-progress`), commit `a8d128e` (2026-10-21)
- **Verifisering**: [verify-2026-10-21-1442.md](../../tasks/opptak/opprette-og-vedlikeholde-opptak/spec/verify-2026-10-21-1442.md), [verify-2026-10-21-2142.md](../../tasks/opptak/opprette-og-vedlikeholde-opptak/spec/verify-2026-10-21-2142.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128028165, under [Testplaner](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5126062121/Testplaner)
- **Laget**: 2026-10-21 av fs-testplan. Ny versjon 2026-10-21 kl. 22: hele scopet, også det som ikke er levert (avvik fra teststrategien, avgjort av produkteier)

---

Testplan for «Opprette opptak 2027». Planen sier hva som testes, av hvem, hvor og når, og hva som skal til for at leveransen blir godkjent. Felt med gul bakgrunn fylles ut før testen.

Den første akseptansetesten ble gjennomført 19.10.2026 ([Akseptansetest – Opprette og vedlikeholde opptak 1](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5109022726)). Kravene er endret etter den testen. Denne testen gjelder hele scopet: opprette opptak, samordning, innstillinger, frister og oversikten over opptak. Alt testes, også det som ikke er ferdig. Det som mangler, står under «Kjente mangler».

## Testbeskrivelse

| Felt | Innhold |
|---|---|
| Hva er levert | Opptaksforvalteren kan opprette et samordna opptak i FS Admin, med navn på bokmål, nynorsk og engelsk (samisk er valgfritt), regelverkssamling og opptakstype. Opptaket kan ikke lagres uten navn, regelverkssamling og opptakstype, eller når navnet mangler på bokmål, nynorsk eller engelsk. Organisasjonen til opptaksforvalteren forvalter opptaket. På «Opptak» ser opptaksforvalteren en liste over opptakene, 50 om gangen, kan søke på navn, filtrere på opptakstype, sortere på opprettet, type og organisasjon, og åpne et opptak. |
| Versjon | main per 21.10.2026: fs-admin `d621cc969`, fs-plattform `bfd9345c0d`. Endringer på vei står under «Kjente begrensninger» |
| Testmiljø | TEST: [https://test-fsadmin.sikt.no/opptak](https://test-fsadmin.sikt.no/opptak) |
| Feature-flagg | `opptak-opprett-samordna`: på i TEST. Holder samordna opptak ute av produksjon til akseptansetesten er bestått |
| Kilde | Scopet `@scope-opprette-opptak-2027`, med oppgaven [opprette-og-vedlikeholde-opptak](https://github.com/sikt-no/fs/tree/a8d128e1b4077d6ea34bfc1b115f354089cd2fc7/tasks/opptak/opprette-og-vedlikeholde-opptak) |
| Scope | `@scope-opprette-opptak-2027` · [scope-fila på GitHub](https://github.com/sikt-no/fs/blob/a8d128e1b4077d6ea34bfc1b115f354089cd2fc7/tasks/opptak/scope-opprette-opptak-2027.md) |
| Saker | [sikt-no/fs#211](https://github.com/sikt-no/fs/issues/211) ([#577](https://github.com/sikt-no/fs/issues/577), [#578](https://github.com/sikt-no/fs/issues/578), [#579](https://github.com/sikt-no/fs/issues/579)) · Jira-epic [TAKE-318](https://sikt.atlassian.net/browse/TAKE-318) ([TAKE-379](https://sikt.atlassian.net/browse/TAKE-379) opprette, [TAKE-380](https://sikt.atlassian.net/browse/TAKE-380) samordning, [TAKE-320](https://sikt.atlassian.net/browse/TAKE-320) innstillinger, [TAKE-321](https://sikt.atlassian.net/browse/TAKE-321) frister, [TAKE-381](https://sikt.atlassian.net/browse/TAKE-381) utdanningsbakgrunner) |
| Berører andre team | Utdanningstilbud (Shinkansen): lærestedene knytter utdanningstilbud til opptaket. Saksbehandlertildeling (Puff): reglene for fordeling av søknader i samordna opptak. Søknad og Min kompetanse, saksbehandling og plasstildeling bruker innstillingene og fristene, men virkningen er ikke med i denne leveransen (se «Uløst arbeid» i scope-fila) |
| Kjente begrensninger | Samordning, innstillinger og frister er ikke ferdige. De testes likevel, og 11 scenarioer vil trolig ikke bestå (se «Kjente mangler»). Sortering på organisasjon i oversikten sorterer på organisasjonskoden, ikke på forkortelsen som vises (godtatt av produkteier). TEST har ikke over 50 opptak, så innlasting av flere opptak kan ikke testes nå. På vei i GitLab (ikke merget 21.10): lenken til tidlig opptak (TAKE-420), fristen for poenggrenser (TAKE-427), sperre mot å fjerne en deltaker med utdanningstilbud (TAKE-433), ny rolle `MEDLEM_OPPTAK` for deltakere (TAKE-423), og en migrering som sletter utdanningstilbud fra organisasjoner som ikke er med i opptaket (TAKE-433, TAKE-437). Se verifiseringssiden |

### Testbrukere

| Nr | Navn | Rolle | Organisasjon | Brukes til |
|---|---|---|---|---|
| 1 | Ordentlig rundskriv | Opptaksforvalter og saksbehandler ved forvaltende organisasjon | HK-dir | Opprette samordna opptak, innstillinger, frister, samordning, oversikten over opptak |
| 2 | Ansvarsfull Fotkrem | Opptaksforvalter ved deltakende organisasjon | NTNU | Samordna opptak: deltaker. Trenger rollen `MEDLEM_OPPTAK` når TAKE-423 er merget |
| 3 | Talefør Elv | Opptaksforvalter ved organisasjon som ikke deltar | Fagskolen Vestfold og Telemark | Samordna opptak: organisasjon som ikke deltar |

Testbrukerne finnes i minst to organisasjoner, så vi kan teste at ingen ser data de ikke skal se.

### Testdata

| Hva | Navn | Hvor | Kan settes tilbake |
|---|---|---|---|
| Regelverkssamlinger | «UHG 2027» og «UHG 2027 v2» (eller tilsvarende) | TEST, FS Admin | Nei |
| Organisasjoner fra utdanningsregisteret | Minst ett universitet eller én høyskole, og én fagskole | TEST, replikert fra utdanningsregisteret | Nei |
| Utdanningsbakgrunner | «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» blant de godkjente utdanningsbakgrunnene | TEST | Nei |
| Opptak med utdanningstilbud | Et opptak som allerede har utdanningstilbud knyttet til seg. Migreringen i TAKE-433/437 kan slette utdanningstilbud fra organisasjoner som ikke er med i opptaket | TEST | Nei |
| Opptak i oversikten | Opptak av minst to opptakstyper. Testerne lager opptak i 1.1 og 3.1. Over 50 opptak finnes ikke i TEST | TEST | Nei |
| Poenglikhetsregler | «Loddtrekning», «Alle søkere med samme poengsum får tilbud» og «Alder, eldre foran yngre» | TEST | Nei |
| Opptakene testerne oppretter | Legg «(test)» i navnet | TEST | Nei, opptakene blir liggende |

## Omfang

Alle scenarioene i kravene testes, også i kravene som ikke er levert. Det er et avvik fra teststrategien, avgjort av produkteier 21.10.2026. Feature-ID-ene her er kravene resten av testflyten bruker.

| Krav | Feature-ID | Status | Scenarioer i testen |
|---|---|---|---|
| [Opprette et opptak](https://github.com/sikt-no/fs/blob/a8d128e1b4077d6ea34bfc1b115f354089cd2fc7/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/01%20Grunnoppsett/opprett_opptak.feature) | `@OPT-OVO-GRU-001` | `@implemented`, én regel `@in-progress` | [TC-GRU] |
| [Samordna opptak](https://github.com/sikt-no/fs/blob/a8d128e1b4077d6ea34bfc1b115f354089cd2fc7/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/02%20Samordning/samordna_opptak.feature) | `@OPT-OVO-SAM-001` | `@in-progress` | [TC-SAM] |
| [Innstillinger for opptak](https://github.com/sikt-no/fs/blob/a8d128e1b4077d6ea34bfc1b115f354089cd2fc7/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/03%20Innstillinger/innstillinger.feature) | `@OPT-OVO-INN-001` | `@in-progress` | [TC-INN] |
| [Frister og hendelser for opptak](https://github.com/sikt-no/fs/blob/a8d128e1b4077d6ea34bfc1b115f354089cd2fc7/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/04%20Frister/frister_og_hendelser.feature) | `@OPT-OVO-FRI-001` | `@in-progress` | [TC-FRI] |
| [Listevisning og søk i opptak](https://github.com/sikt-no/fs/blob/a8d128e1b4077d6ea34bfc1b115f354089cd2fc7/krav/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/07%20Oversikt%20over%20opptak/listevisning_og_sok_i_opptak.feature) | `@OPT-OVO-OVE-001` | `@implemented` | [TC-OVE] |

De automatiske testene av de samme kravene: `npx playwright test --grep @scope-opprette-opptak-2027`

## Venter på verifisering

Kravene testes likevel. Dette er de kjente manglene fra verifiseringen 21.10. De vil trolig ikke bestå.

| Krav | Kjent mangel | Sak | På vei |
|---|---|---|---|
| Opprette et opptak | Opptaket kan lagres uten «Antall søknadsalternativer» og «Tilbud per tildelingsrunde» | TAKE-431 | Nei |
| Samordna opptak | En organisasjon som ikke deltar, kan åpne opptaket | TAKE-434 | Nei |
| Samordna opptak | En deltaker med utdanningstilbud kan fjernes | TAKE-433 | Ja, fs-plattform |
| Samordna opptak | En deltakende organisasjon ser ikke innstillingene | TAKE-432 | Nei |
| Samordna opptak | Lenken til saksbehandlertildelingen står bare på redigeringssiden | TAKE-447 | Nei |
| Samordna opptak | Uavklart: om en organisasjon som ikke deltar, ser opptaket i lista | TAKE-434 | – |
| Innstillinger for opptak | Startnummer, «Tilbud per tildelingsrunde» og «Søker kan laste opp dokumenter» har ikke riktig standardverdi | TAKE-431 | Nei |
| Innstillinger for opptak | Lenken til tidlig opptak kan ikke settes, og er ikke påkrevd | TAKE-420 | Ja, fs-admin |
| Frister og hendelser for opptak | Fristen for poenggrenser kan ikke settes, og er ikke påkrevd | TAKE-427 | Ja, fs-admin |

## Ikke med i denne testen

| Hva | Hvorfor |
|---|---|
| Gjenbruke innstillinger fra et tidligere opptak (Opprette et opptak) | Ikke avklart ennå: hva kopieres, og hva kopieres ikke? Utsatt til senere iterasjon |
| Deaktivere et opptak (Opprette et opptak) | Ikke avklart ennå. Utsatt til senere iterasjon |
| Krav om studierett for å søke (Innstillinger for opptak) | Ikke avklart ennå |
| Fristene må komme i riktig rekkefølge (Frister og hendelser for opptak) | Ikke avklart ennå |
| Første svarfrist som informasjon til søkere (Frister og hendelser for opptak) | Åpent spørsmål: fristen settes på plasstildelingsrunden |
| Hendelseslogg for opptak | Kommer senere: venter på en generell løsning |
| Fellestekster og svarmeldingsmal | Skal ikke lages nå. Utsatt til senere iterasjon (sikt-no/fs#214) |
| Virkningen av innstillingene og fristene hos søkeren, i saksbehandlingen og for utdanningstilbudene | Kommer senere: står i kravene der verdiene brukes, og har ingen oppgave ennå (se «Uløst arbeid» i scope-fila) |
| Status i oversikten over opptak | Ikke med i kravet: det er ennå ikke forskjell på aktive og deaktiverte opptak |
| Sortering på navn i oversikten over opptak | Ønsket av HK-dir, men ikke med i kravet nå |

## Roller

| Rolle | Hvem | Ansvar |
|---|---|---|
| Testansvarlig | Marit Bjørnerud Rønning | Eier testen fra start til beslutning, og skriver beslutningen i testrapporten |
| Kontaktperson i teamet | Karen Skadsheim Sikkeland | Svarer på spørsmål, og har ansvaret for at feil blir rettet |
| Andre testere | Maciek Adamczyk og Jøran Wigen Aasterud (teamet) | [Fylles ut: hvilke deler] |
| Eksterne testere | [Fylles ut: om leveransen skal til ekstern akseptansetest, og hvem som tester der] | |

## Tid og kanal

| Felt | Innhold |
|---|---|
| Intern akseptansetest | [Fylles ut: dato og klokkeslett]. Tidsramme: 1–2 timer |
| Ekstern akseptansetest | [Fylles ut] |
| Spørsmål underveis | Slack-tråden «Akseptansetesting Opprette og vedlikeholde opptak» i [Fylles ut: kanal] |

## Forutsetninger

Klart når testansvarlig har logget inn som testbruker og ser testdataene.

| # | Forutsetning | Status |
|---|---|---|
| 1 | Leveransen er lagt ut i testmiljøet, og den virker der | [Fylles ut av teamet] |
| 2 | Testdataene er identifisert og tilgjengelige | [Fylles ut av teamet] |
| 3 | Testdataene kan settes tilbake eller lages på nytt | Nei: opptakene testerne oppretter, blir liggende, og får «(test)» i navnet |
| 4 | Testbrukerne finnes i rollene leveransen gjelder, i minst to organisasjoner | [Fylles ut av teamet]. Testbruker 2 trenger `MEDLEM_OPPTAK` når TAKE-423 er merget |
| 5 | `fs-verify` har funnet alle scenarioene, og en annen person har kontrollert rapporten | Delvis: alle de 20 scenarioene i «Omfang» er funnet (21.10.2026, to verifiseringer). Fire krav eller deler venter på verifisering (50 funnet, 11 ikke funnet og 2 usikre av 63 kl. 14:42). Kontrollert av `fs-verify-kontroll`. Venter på kontroll av en person (steg 3) |
| 6 | Testcasene er laget og gått gjennom av testansvarlig | Laget for opprett opptak, venter på gjennomgang. Testcasene for oversikten over opptak lages |
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
| 1. Verifisering (`fs-verify`) | [Verifisering – Opprette og vedlikeholde opptak – 2026-10-21 14:42](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5127045158) · [verify-2026-10-21-1442.md](../../tasks/opptak/opprette-og-vedlikeholde-opptak/spec/verify-2026-10-21-1442.md) | 11 ikke funnet, 2 usikker (14:42). Oversikten over opptak: alt funnet (21:42, [Verifisering – … – 2026-10-21 21:42](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5128650825) · [verify-2026-10-21-2142.md](../../tasks/opptak/opprette-og-vedlikeholde-opptak/spec/verify-2026-10-21-2142.md)) | 2026-10-21 |
| 2. Testplan | (denne siden) | Laget, ny versjon med oversikten over opptak | 2026-10-21 |
| 3. Testrapport – verifisering | – | Venter | |
| 4. Intern akseptansetest | [Intern akseptansetest – Opprette og vedlikeholde opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5127209099) · [testcaser-intern.md](testcaser-intern.md) | Klar til test for opprett opptak. Testcasene for oversikten over opptak lages | 2026-10-21 |
| 5. Testrapport – intern | – | Venter | |
| 6. Ekstern akseptansetest | [Ekstern akseptansetest – Opprette opptak 2027](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5137334279) · [testcaser-ekstern.md](testcaser-ekstern.md) | Klar til test | 2026-10-23 |
| 7. Testrapport – ekstern | – | Venter | |

## Læring

Etter hver akseptansetest tar testerne og teamlederne et kort møte:

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
