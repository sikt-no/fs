# Kjøring 2026-11-11 10:57: Gi tilbudsgaranti ved tidlig opptak

- **Startet av**: Jens Peter Thomassen, etter at rollen til opptaksforvalteren var rettet (funn F1 i [kjøringen 2026-11-10](../kjoring-2026-11-10-1440/resultat.md)). Testene: scenariomalen «Tilbudsgaranti ut fra poenggrensen» (tre eksempler)
- **Miljøfil**: [test.md](../../../cdp-tester/_Milj%C3%B8er/test.md), personaer sist sjekket 2026-11-04
- **Miljø**: https://test-fsadmin.sikt.no, opptak 34 (`opptak-tidlig-opptak`)
- **Kravstatus**: `@OPT-BEH-BEH-007`: `@in-progress` (delvis levert). Scenarioene i kjøringen er levert (`@implemented`)
- **Utdaterte tester**: Ingen (som i kjøringen 2026-11-10: main er bak branchen til PR #989)
- **Tester**: `cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature` (rettet 2026-11-10, `b429d4d7`)
- **Slik er testen kjørt**: stegene er fulgt slik de står (R14). Virket ikke et steg, eller fantes ikke en verdi, er testcasen «Ikke testet», med det som ble sett i «Faktisk resultat»
- **Kjente mangler**: Ingen liste gitt
- **Krav**: commit `9e267353` (branchen til PR #989)
- **Kjørt av**: Claude (cdp-skillen, Chrome-profilen `~/chrome-cdp-test`) for Jens Peter Thomassen
- **Oppsett**: ikke kjørt på nytt. Poenggrensene fra oppsettet 2026-11-10 sto fortsatt (0,0 på «Datateknikk ingeniør» og «Elektronisk systemingeniør», tom på «Paramedisin» og «Medisin» ved UiT), og hvert eksempel satte grensen tilbake til 0,0
- **Hoppet over**: Ingen
- **Endringer i miljøfila**: Ingen

## Kjøringens testdata

Som i kjøringen 2026-11-10 (`poenggrenser-tidlig-opptak`).

---

| Test (`@TST-…`) | Regel | Scenario | Teknikk | Foreslått status | Input | Faktisk resultat | Steg tatt | Bevis |
|---|---|---|---|---|---|---|---|---|
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tilbudsgaranti ut fra poenggrensen (grense P - 5) | grenseverdianalyse | Bestått | Søker Gretten Pedal (34-1004198), P = 50, poenggrensen 45 (notert før: 0,0) | «Tilbudsgaranti fra forvalter» for «Datateknikk ingeniør»: «Tilbudsgaranti, forhåndsløfte» (`tilbudsgarantitype-tidlig-opptak`, FOR). «Elektronisk systemingeniør»: «Ikke valgt». Gjennomføringen: «Tidligopptaket er kjørt. 2 tilbudsgarantier er satt totalt.» (den andre er Økologisk Badering, klargjort i kjøringen 2026-11-10) | P under «7. Oppsummering»; poenggrensen 45 og lagret; Klargjøring K (sjekket etter ny innlasting); Gjennomføring G (dialogen: søkt 61, ikke behandlet 59, deltar 2, totale tilbudsgarantier 2, første prioritet 2); S i skuffen «Søknadsalternativer»; poenggrensen tilbake til 0,0 | Tekst fra siden (over). `s1-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tilbudsgaranti ut fra poenggrensen (grense P) | grenseverdianalyse | Bestått | Søker Trist Rygg (34-1004199), P = 50, poenggrensen 50 (notert før: 0,0) | «Datateknikk ingeniør»: «Tilbudsgaranti, forhåndsløfte». «Elektronisk systemingeniør»: «Ikke valgt». «Tidligopptaket er kjørt. 1 tilbudsgaranti er satt totalt.» | Som over. Dialogen: ikke behandlet 58, deltar 3, totale tilbudsgarantier 1, første prioritet 3. Poenggrensen tilbake til 0,0 | `s2-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tilbudsgaranti ut fra poenggrensen (grense P + 5) | grenseverdianalyse | Bestått | Søker Formbar Juice (34-1004200), P = 50, poenggrensen 55 (notert før: 0,0) | «Datateknikk ingeniør»: «Ikke valgt» (står ikke «tilbudsgarantitype-tidlig-opptak»). «Elektronisk systemingeniør» (prioritet 2): «Tilbudsgaranti, forhåndsløfte», fordi poenggrensen der er 0,0 fra oppsettet og søkeren er kvalifisert. «Tidligopptaket er kjørt. 1 tilbudsgaranti er satt totalt.» | Som over. Dialogen: ikke behandlet 57, deltar 4, totale tilbudsgarantier 1, første prioritet 3. Poenggrensen tilbake til 0,0 | `s3-*.png` (lokalt, ikke i git) |

Gretten Pedal, Trist Rygg og Formbar Juice er brukt. Økologisk Badering fikk tilbudsgaranti på «Datateknikk ingeniør» i den første gjennomføringen (grensen 45, P = 50).

## Funn

Ingen nye. F1 fra kjøringen 2026-11-10 er rettet: rollekatalogen gir nå opptaksforvalteren `FS-ADMIN_SE_SØKNADSBEHANDLING`, og «Kjør tidligopptak» vises.

## Å vite før neste kjøring

- **«Merk som behandlet» finnes** på steget «7. Oppsummering». Kjøringen 2026-11-10 fant den ikke på steget «1. Tidlig opptak», og testene ble rettet til «Behandlingsstatus». Begge virker.
- **Tilbudsgarantien leses i skuffen «Søknadsalternativer»** (åpnes fra «Vis» til høyre i saken): hvert søknadsalternativ har «Tilbudsgaranti fra behandler», «… fra tilbyder» og «… fra forvalter» når det er åpnet.
- **Dialogen «Kjøre tidligopptak?»** viser «Totale tilbudsgarantier» for denne gjennomføringen, men «Tilbudsgarantier med første prioritet» for alle søkerne som har det, også fra før.
- **Gjennomføringen varslet** «2 utdanningstilbud er feilkonfigurert for tidlig opptak.»
- **P + 5 gir garanti på prioritet 2** når «utdanningstilbud-tidlig-opptak-andre» har poenggrense 0. Testen sjekker bare prioritet 1, så den består, men den som leser resultatet, bør vite det.

## Å bekrefte

Foreslått status er agentens forslag. En tester bekrefter den, og testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene før `fs-testrapport` (agentisk) teller. Agenten har ikke fylt ut «Status» på testcasene eller i testrapporten, og kan ikke godkjenne leveransen.
