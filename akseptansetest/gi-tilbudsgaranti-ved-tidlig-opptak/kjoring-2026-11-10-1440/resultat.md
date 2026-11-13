# Kjøring 2026-11-10 14:40: Gi tilbudsgaranti ved tidlig opptak

- **Startet av**: Jens Peter Thomassen, med oppsettet og de første scenarioene i testene for `@OPT-BEH-BEH-007`, som en prøve før hele kjøringen
- **Miljøfil**: [test.md](../../../cdp-tester/_Milj%C3%B8er/test.md), personaer sist sjekket 2026-11-04
- **Miljø**: https://test-fsadmin.sikt.no, opptak 34 (`opptak-tidlig-opptak`)
- **Kravstatus**: `@OPT-BEH-BEH-007`: `@in-progress` (delvis levert). Scenarioene i kjøringen er levert (`@implemented`)
- **Utdaterte tester**: Ingen. Blob-hashen på `origin/main` (`15552aa`) er ulik testen (`a409c3e`), men det er fordi main er bak branchen til PR #989 (bekreftelsen om reservert studieplass 2026-11-09, ikke merget). Scenarioene i kjøringen er like i begge versjonene
- **Tester**: `cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature`
- **Slik er testen kjørt**: stegene er fulgt slik de står (R14). Virket ikke et steg, eller fantes ikke en verdi, er testcasen «Ikke testet», med det som ble sett i «Faktisk resultat»
- **Kjente mangler**: Ingen liste gitt
- **Krav**: commit `9e267353` (branchen til PR #989)
- **Kjørt av**: Claude (cdp-skillen, Chrome-profilen `~/chrome-cdp-test`) for Jens Peter Thomassen
- **Oppsett**: `_Oppsett/02 Opptak/13 Søknad og saksbehandling/02 Behandling/oppsett.feature`, kjørt 2026-11-10 ca. 14.45. 1 av 1 nøkler laget
- **Hoppet over**: Ingen
- **Endringer i miljøfila**: Ingen. Se «Funn» og «Å rette i testene» for forutsetning 4 og stegene som ikke stemmer med skjermen

## Kjøringens testdata

| Nøkkel | Navn | URL | Laget av |
|---|---|---|---|
| `poenggrenser-tidlig-opptak` | 0,0 på «Datateknikk ingeniør» og «Elektronisk systemingeniør - bachelor i ingeniørfag», tom på «Paramedisin» (median i fjor 47,8) og «Medisin» ved UiT («Ingen median») | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/plasstildeling/tidlig-opptak | `opptak-forvalter-forvaltende` |

---

| Test (`@TST-…`) | Regel | Scenario | Teknikk | Foreslått status | Input | Faktisk resultat | Steg tatt | Bevis |
|---|---|---|---|---|---|---|---|---|
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tilbudsgaranti ut fra poenggrensen (grense P - 5) | grenseverdianalyse | Ikke testet | Søker Økologisk Badering (34-1004197), P = 50, poenggrensen 45 | Knappen «Kjør tidligopptak» finnes ikke på fanen «Tidlig opptak» for `opptak-forvalter-forvaltende` (ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)). Gjennomføring G kan ikke gjøres. Stegene før det virket: P lest (50), poenggrensen satt til 45 og lagret («Poenggrensene er lagret.»), saken gjort klar (Konklusjon «Kan få tidligopptak, har godkjent grunn.», Behandlingsstatus «Behandlet», sjekket etter ny innlasting). Poenggrensen er satt tilbake til 0,0 | Oppsett; P lest under «Oppsummering» som saksbehandler ved UiT; poenggrensen 45 som forvalter; Klargjøring K som saksbehandler ved UiT; Gjennomføring G steg 3 stoppet | Knappene på fanen: «Lagre poenggrenser», «Sortering: Navn» (DOM). Debug-panelet: personaen har 15 roller ved HK-DIR (20827), ikke `FS-ADMIN_SE_SØKNADSBEHANDLING`. Skjermbilder `s1-*.png`, `debug-roller.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tilbudsgaranti ut fra poenggrensen (grense P) | grenseverdianalyse | Ikke testet | – | Ikke startet: Gjennomføring G kan ikke gjøres (se over) | – | – |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tilbudsgaranti ut fra poenggrensen (grense P + 5) | grenseverdianalyse | Ikke testet | – | Ikke startet: Gjennomføring G kan ikke gjøres (se over) | – | – |

Økologisk Badering er brukt: saken er ferdig behandlet med en konklusjon der søkeren deltar, og får tilbudsgaranti ved neste gjennomføring av tidligopptaket i opptak 34.

## Funn

| Nr | Test | Type | Hva skjedde | Forventet | Steg for å gjenskape | Bevis |
|---|---|---|---|---|---|---|
| F1 | `@TST-OPT-BEH-BEH-001` (alle scenarioene med Gjennomføring G) | Feil | «Kjør tidligopptak» vises ikke for opptaksforvalteren ved HK-dir. Knappen krever fire roller ved organisasjonen som forvalter opptaket (`KJOR_TIDLIGOPPTAK_ROLLER` i fs-admin: `FS-ADMIN_OPPTAK_TILBGARANTI_GI_VIA_OPPTAK`, `FS-ADMIN_SE_SØKNADSBEHANDLING`, `FS-ADMIN_MODIFISERE_OPPTAK`, `FS-ADMIN_SE_OPPTAK`), og OPPTAK_FORVALTER gir ikke `FS-ADMIN_SE_SØKNADSBEHANDLING`. Gjennomføringen i API-et (`settTilbudsgarantiFraTidligopptak`) virker for den samme personaen (prøvekjøringen 2026-11-09 og 2026-11-10) | Opptaksforvalteren kan prøvekjøre og gjennomføre tidligopptaket (regelen «Opptaksforvalter gjennomfører tidligopptaket»). Testplanen, forutsetning 4: «bekreft at ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) har alle de fire tilgangene fs-admin krever» | Velg ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) i «Overstyrt bruker», gå til opptak 34, «Plasstildeling», fanen «Tidlig opptak». Slå på «Debug» og se rollene | `debug-roller.png` (lokalt, ikke i git) |

Rollekatalogen i TEST (lest med `tilgangsrollerGittRollekoder` og `alleImpliserteRoller` i tilgangsstyring, 2026-11-10):

- OPPTAK_FORVALTER gir privilegiet `SE_SØKNADSBEHANDLING` (subgraf), men ikke flaterollen `FS-ADMIN_SE_SØKNADSBEHANDLING` (fs-admin). Den gir de tre andre rollene knappen krever.
- OPPTAK_SAKSBEHANDLER gir `FS-ADMIN_SE_SØKNADSBEHANDLING`, men ikke `FS-ADMIN_OPPTAK_TILBGARANTI_GI_VIA_OPPTAK`.
- Ingen av de to rollene alene gir alle fire. Kravet til rollene i knappen kom med `f480d771d` i fs-admin (2026-11-04, STEK-489).

Det er to måter å rette det på, og teamet avgjør hvilken: OPPTAK_FORVALTER impliserer også `FS-ADMIN_SE_SØKNADSBEHANDLING` i rollekatalogen (navnerommet `fs-admin`, forvaltet av FS Admin-teamet), eller knappen i fs-admin krever ikke `FS-ADMIN_SE_SØKNADSBEHANDLING`. API-et krever bare `OPPTAK_TILBGARANTI_GI_VIA_OPPTAK`.

## Å rette i testene og miljøfila

Det kjøringen viste, som ikke er funn i løsningen:

- **P står ikke under «Poeng».** «5. Poeng» viser «Ingen poengberegning», fordi poengsummen er lagt inn per kvote (`sak_poengsum`), uten poengrader. Poengsummen står under «7. Oppsummering», i «Poengsum per kvote og grunnlag» (ORD, VES, 50). Steget «jeg leser søkerens poengsum P … i saken» bør si hvor.
- **«Merk som behandlet» finnes ikke.** Saken settes til behandlet i nedtrekkslista «Behandlingsstatus» («Behandlet»). Klargjøring K steg 5 bør rettes, og `[Sjekk begrep]` fjernes.
- **Stegene i saken heter annerledes:** «1. Tidlig opptak», «2. Generell studiekompetanse», «3. Grunnlag», «4. Spesielle opptakskrav», «5. Poeng», «6. Kvoter», «7. Oppsummering».
- **To saker:** «Elektronisk systemingeniør» (NTNU) har «B-rolle UIT»: UiT behandler også det søknadsalternativet. Søkerne i `sak-tidlig-opptak-to-saker` har da bare én sak (hos UiT), og testen om en søker med to saker trenger et søknadsalternativ som behandles av en annen organisasjon.
- **Opptak 34 endres av andre:** opptaket hadde 31 utdanningstilbud 2026-11-10 (24 dagen før), og «Plasser» var fylt ut for noen. De fem utdanningstilbudene testene bruker, er de samme.
- **Personaene lastet ikke én gang:** «Testpersonene kunne ikke lastes. Standardpersonen brukes.» etter en ny innlasting. Det gikk over etter en ny innlasting til.

## Å bekrefte

Foreslått status er agentens forslag. En tester bekrefter den, og testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene før `fs-testrapport` (agentisk) teller. Agenten har ikke fylt ut «Status» på testcasene eller i testrapporten, og kan ikke godkjenne leveransen.
