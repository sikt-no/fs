# Kjøring 2026-11-11 10:57: Gi tilbudsgaranti ved tidlig opptak

- **Startet av**: Jens Peter Thomassen, etter at rollen til opptaksforvalteren var rettet (funn F1 i [kjøringen 2026-11-10](../kjoring-2026-11-10-1440/resultat.md)). Testene: scenariomalen «Tilbudsgaranti ut fra poenggrensen» (tre eksempler), og seks scenarioer med én felles gjennomføring
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
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Søkere som ikke deltar får ikke tilbudsgaranti | – (fra kravet) | Bestått | Søker Tru Kjetting (34-1004201), Konklusjon «Ikke dokumentert behov for tidligopptak» | «Tilbudsgaranti fra forvalter»: «Ikke valgt» på begge søknadsalternativene | Klargjøring K med konklusjonen der søkeren ikke deltar (sjekket etter ny innlasting); Gjennomføring G (felles, se under); S | `g-ikke-deltar-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Søknader uten konklusjon er ikke med i tidligopptaket | – (fra kravet) | Bestått | Søker Uromantisk Plasma (34-1004202), uten konklusjon, «Behandlet» | «Ikke valgt» på begge søknadsalternativene | Klargjøring K uten steg 4 («Konklusjon» står som «Ikke valgt», sjekket etter ny innlasting); G (felles); S | `g-uten-konklusjon-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Søkere som ikke er kvalifisert får ikke tilbudsgaranti | – (fra kravet) | Bestått | Søker Kranglete Artisjokk (34-1004226) | «Datateknikk ingeniør»: «Ikke valgt» | K; G (felles); S | `g-ikke-kvalifisert-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti | – (fra kravet) | Bestått | Søker Eksemplarisk Bevegelse (34-1004229) | «Datateknikk ingeniør»: «Ikke valgt» | K; G (felles); S | `g-ikke-vurdert-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Opptaksforvalter gjennomfører tidligopptaket: kvalifiseringen har flere grunnlag (kvalifisert og ikke kvalifisert) | beslutningstabell | Bestått | Søker Famøs Tunge (34-1004231) | «Datateknikk ingeniør»: «Tilbudsgaranti, forhåndsløfte» | K; G (felles); S | `g-grunnlag-ja-nei-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Opptaksforvalter gjennomfører tidligopptaket: kvalifiseringen har flere grunnlag (ikke vurdert og ikke kvalifisert) | beslutningstabell | Bestått | Søker Ravgul Katedral (34-1004233) | «Datateknikk ingeniør»: «Ikke valgt» | K; G (felles); S | `g-grunnlag-ikkevurdert-nei-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Opptaksforvalter gjennomfører tidligopptaket: poengsummen er 0,1 under poenggrensen | grenseverdianalyse | Bestått | Søker Ufornuftig Graf (34-1004203), P = 50, poenggrensen 50,1 (notert før: 0,0) | «Datateknikk ingeniør»: «Ikke valgt». «Elektronisk systemingeniør» (prioritet 2, poenggrense 0,0): «Tilbudsgaranti, forhåndsløfte». «Tidligopptaket er kjørt. 1 tilbudsgaranti er satt totalt.» | P; poenggrensen 50,1; K; G (dialogen: ikke behandlet 51, deltar 9, totale 1, første prioritet 5); S; poenggrensen tilbake til 0,0 | `u01-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tilbudsgaranti på det høyest prioriterte søknadsalternativet (grense P - 5) | – (fra kravet) | Bestått | Søker Misfornøyd Skrivemaskin (34-1004204), P = 50, poenggrensen 45 | «Datateknikk ingeniør»: «Tilbudsgaranti, forhåndsløfte». «Elektronisk systemingeniør»: «Ikke valgt». «Tidligopptaket er kjørt. 2 tilbudsgarantier er satt totalt.» | P; poenggrensen 45; K; G (ikke behandlet 50, deltar 10, totale 2, første prioritet 7); S; poenggrensen tilbake til 0,0 | `hp-5-*.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tilbudsgaranti på det høyest prioriterte søknadsalternativet (grense P + 5) | – (fra kravet) | Bestått | Søker Akustisk Elg (34-1004205), P = 50, poenggrensen 55 | «Elektronisk systemingeniør»: «Tilbudsgaranti, forhåndsløfte». «Datateknikk ingeniør»: «Ikke valgt». «Tidligopptaket er kjørt. 1 tilbudsgaranti er satt totalt.» | P; poenggrensen 55; K; G (ikke behandlet 49, deltar 11, totale 1, første prioritet 7); S; poenggrensen tilbake til 0,0 | `hp+5-*.png` (lokalt, ikke i git) |

De seks scenarioene fra «Søkere som ikke deltar …» til «… ikke vurdert og ikke kvalifisert» endrer ikke poenggrensen, og ble gjort klare hver for seg (hver sin søker) før én felles Gjennomføring G. Dialogen: søkt 61, ikke behandlet 52, deltar 8, totale tilbudsgarantier 2, første prioritet 5. «Tidligopptaket er kjørt. 2 tilbudsgarantier er satt totalt.» Den ene er Famøs Tunge. Den andre er ingen av de seks søkerne (trolig en søker andre har behandlet i opptak 34).

Gretten Pedal, Trist Rygg, Formbar Juice, Tru Kjetting, Uromantisk Plasma, Kranglete Artisjokk, Eksemplarisk Bevegelse, Famøs Tunge Ravgul Katedral, Ufornuftig Graf, Misfornøyd Skrivemaskin og Akustisk Elg er brukt.

Tilstanden til søkerne fra tidligere scenarioer kan endre seg i senere gjennomføringer: en søker med tilbudsgaranti på prioritet 2 flyttes til prioritet 1 når poenggrensen der blir lav nok (trolig den andre tilbudsgarantien i gjennomføringen med grensen 45 for «Tilbudsgaranti på det høyest prioriterte …»). Bevisene er tilstanden da garantien ble lest. Økologisk Badering fikk tilbudsgaranti på «Datateknikk ingeniør» i den første gjennomføringen (grensen 45, P = 50).

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
