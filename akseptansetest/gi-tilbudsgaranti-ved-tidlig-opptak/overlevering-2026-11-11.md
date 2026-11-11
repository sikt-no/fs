# Overlevering – Gi tilbudsgaranti ved tidlig opptak (`@OPT-BEH-BEH-007`)

Fra Jens Peter Thomassen til Daniel Sachse, 2026-11-11, mens Jens Peter er på ferie. Alt ligger på branchen `testplan/beh-007-tidligopptak` (PR #989) og i Confluence under [Testplan – Gi tilbudsgaranti ved tidlig opptak](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074).

## Hvor vi er

| Fase | Status | Hvor |
|---|---|---|
| 1. Verifisering | 25 av 27 scenarioer funnet. Kravet er delvis levert (`@in-progress`). Kontrollert av Daniel 2026-11-09 | [testrapport-verifisering-2026-11-09.md](testrapport-verifisering-2026-11-09.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181767779) |
| 1. Testplan | Laget og publisert | [testplan.md](testplan.md) · [Confluence](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074) |
| 2. Agentisk funksjonstest | Kjørt 2026-11-11 i TEST: 40 bestått, 5 ikke testet, av 45. Ingen nye funn | [kjoring-2026-11-11-1057/resultat.md](kjoring-2026-11-11-1057/resultat.md) |
| 2. Testrapport – agentisk | **Venter på gjennomgang av testansvarlig** | [testrapport-agentisk-2026-11-11.md](testrapport-agentisk-2026-11-11.md) · Confluence (lenken står i metadataene i fila) |
| 3. Intern akseptansetest | Ikke startet | – |
| 4. Ekstern akseptansetest | Ikke avgjort om den er aktuell | – |

Prøven 2026-11-10 ([kjoring-2026-11-10-1440](kjoring-2026-11-10-1440/resultat.md)) stoppet på F1: opptaksforvalteren så ikke «Kjør tidligopptak». Det er rettet i rollekatalogen, og bekreftet i kjøringen 2026-11-11.

## Det som gjenstår, i rekkefølge

1. **Testansvarlig.** «Testansvarlig» står som `[Fylles ut: navn]` i testplanen. Avtal hvem det er.
2. **Gjennomgang av den agentiske testrapporten** (testansvarlig): les rapporten, se særlig på «Bestått, men faktisk resultat avviker» (3 testcaser) og «Ikke testet» (5), ta en stikkprøve av de beståtte etter en risikovurdering, og fyll ut «Gjennomgått av testansvarlig» og «Stikkprøve av beståtte testcaser» i Confluence og i fila. Da er inngangskriteriet til intern akseptansetest oppfylt. Kjør så `fs-testrapport` (agentisk) på nytt, eller endre raden «2. Testrapport – agentisk funksjonstest» i «Status i flyten» til «Klar for intern akseptansetest» (i `testplan.md` og i Confluence).
3. **Fase 3:** `fs-testcaser-intern` med testplanen `akseptansetest/gi-tilbudsgaranti-ved-tidlig-opptak`. Kandidatene til «Det den agentiske testen ikke klarte» er de 5 som er ikke testet. Testplanen sier at to ting fra testplanen for saksbehandling av tidlig opptak testes her: at konklusjonen per organisasjon gir riktig utfall i tidligopptaket, og at konklusjonen kan endres etter gjennomføringen (`@OPT-BEH-BEH-013`).
4. **Rett testdataene og testene** (kan gjøres når som helst, med `fs-testcaser-cdp`):
   - `sak-tidlig-opptak-prioritet-1-uten-tidlig-opptak` og `sak-tidlig-opptak-to-saker` i [miljøfila](../../cdp-tester/_Milj%C3%B8er/test.md) stemmer ikke. En søknad får én sak, hos organisasjonen som behandler søknadsalternativet med prioritet 1. Søkerne med «Bachelorstudium i arbeids- og velferdsfag» først har saken hos organisasjon 224, og søkerne med to studieønsker har bare én sak, hos UiT (UiT behandler også «Elektronisk systemingeniør»). Testene «Annen tilbudsgaranti på et høyere prioritert søknadsalternativ …» og «… en søker med to saker …» må bygges på noe annet.
   - Stegene for prøvetildelingen i «Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak» er `[Sjekk begrep]`. «Plasstildeling» har bare «Runder» og «Opprett runde». Avklar med teamet om testen skal opprette en runde i opptak 34, eller om den heller testes i fase 3.
5. **Kravet** (`fs-krav`, når teamet har svart): to regler i koden uten scenario. Reservert studieplass i kolonnen til opptaksforvalter erstattes av tilbudsgarantien fra tidligopptaket (bør få scenario), og en søker uten søknad om tidlig opptak, men med tidligopptakstilbud, er med (uklart om det er ønsket).
6. **Før BEH-007 kan bli `@implemented`:** fs-admin må vise antallet utdanningstilbud med mangelfulle innstillinger i prøvekjøringen (de 2 scenarioene som ikke er funnet i fase 1). Jens Peter har kommentert det på STEK-489. `@OPT-OPT-UTD-004` (`@draft`) må valideres. Så `fs-verify` på nytt, og en ny kjøring av de scenarioene som er levert da.

## Testdataene i TEST

- **Opptak 34** «Samordna UHG-simulering høsten 2026». Andre tester også i opptaket, og endrer det (frist, medianer, antall utdanningstilbud). Gjennomføringen av tidligopptaket kan ikke settes tilbake, og går gjennom alle søkerne i opptaket som har søkt om tidlig opptak.
- **Søkerne** står i lister i [miljøfila](../../cdp-tester/_Milj%C3%B8er/test.md) (`sak-tidlig-opptak-…`), med navn og søknadsnummer. Hver testcase bruker sin egen søker. Brukt: se lista nederst i [resultat.md](kjoring-2026-11-11-1057/resultat.md). Igjen i `sak-tidlig-opptak-kvalifisert`: Klok Netthinne, Robust Skatoll, Idiotsikker Matte og Misfornøyd Ambassade. Viktig Ringdue, Konkret Fobi og Mye Behandling er ferdig behandlet og deltar, og får tilbudsgaranti ved neste gjennomføring.
- **Flere søkere:** fordelingen og søkerne til overs står i [oppsett/fordeling-sokere.md](oppsett/fordeling-sokere.md). Søknadene lages som søkeren gjennom API-et Min kompetanse bruker (header `Sudo-Fodselsnr`), eller i Min kompetanse («Meny» → «Velg testsøker»). Kvalifiseringen og poengsummen kan ikke settes i FS Admin: de settes med [oppsett/for-kjoringen-kvalifisering-og-poengsum.sql](oppsett/for-kjoringen-kvalifisering-og-poengsum.sql), som Daniel kjører (avtalt 2026-11-10). Finn ubrukte søkere med spørring 5 i [oppsett/finn-testdata.sql](oppsett/finn-testdata.sql).
- **Poenggrensene** på fanen «Tidlig opptak» skal stå som i oppsettet når ingen test kjører: 0,0 på «Datateknikk ingeniør» og «Elektronisk systemingeniør», tom på «Paramedisin» og «Medisin» ved UiT.

## Slik kjøres den agentiske testen

- Testene: [`cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`](../../cdp-tester/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature). Oppsettet av cdp-skillen og Chrome står i [`cdp-tester/README.md`](../../cdp-tester/README.md).
- Chrome-profilen: `open -na "Google Chrome" --args --user-data-dir="$HOME/chrome-cdp-test" --remote-debugging-port=9222`. Logg inn med Feide i FS Admin og Min kompetanse selv. Agenten logger aldri inn.
- Hjelpefunksjonene fra kjøringen (bytte persona, lese P, sette poenggrensen, Klargjøring K, Gjennomføring G, lese tilbudsgarantien, lese dialogen) står i [oppsett/cdp-hjelpere.js](oppsett/cdp-hjelpere.js), med bruken øverst. Be Claude bruke dem.
- Personaene: forvalter `ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)`, saksbehandler `KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)`, tilbyder `KORT DOMPAP • OPPTAK_FORVALTER (UIT)`.

Det kjøringen lærte:

- Fanen med FS Admin må ligge foran (`Page.bringToFront`), ellers kommer ikke klikkene fram.
- «Testpersonene kunne ikke lastes. Standardpersonen brukes.»: last inn siden på nytt. Bytter ikke personaen etter flere forsøk, eller sover maskinen, koble til CDP på nytt og last inn siden.
- «Kjør tidligopptak» åpner ikke alltid dialogen ved første klikk rett etter at siden er lastet. Prøv en gang til.
- Sjekk alltid klargjøringen etter ny innlasting: én gang ble den ikke lagret.
- Tilbudsgarantien leses i skuffen «Søknadsalternativer» i saken, og poengsummen P under «7. Oppsummering» («Poengsum per kvote og grunnlag»).
- «Velg testsøker» i Min kompetanse lot seg ikke velge med CDP. Søknaden ble endret gjennom API-et som søkeren i stedet.

## Regler

- Ingenting postes i Jira, GitHub eller GitLab uten at det er avtalt. STEK-489 kommenteres bare hvis endringen skal gjøres i fs-admin.
- Repoet og Confluence holdes i synk. Det andre har fylt ut i Confluence, skrives ikke over.
- Agenten foreslår status. Testansvarlig bekrefter, og bare testansvarlig skriver beslutningen.
