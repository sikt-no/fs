# Kjøring 2026-11-13 17:04: Gi tilbudsgaranti ved tidlig opptak

- **Startet av**: Daniel Sachse, etter at testen ble oppdatert til kravet slik det er levert (`38429017`). Avgrenset til de fire scenarioene som er nye eller endret, og Gjennomføring G med den nye resultatdialogen
- **Miljøfil**: [test.md](../../../tester-agent/_Milj%C3%B8er/test.md), personaer sist sjekket 2026-11-04
- **Miljø**: https://test-fsadmin.sikt.no, opptak 34 (`opptak-tidlig-opptak`)
- **Kravstatus**: Alle `@implemented` (`@OPT-BEH-BEH-007`)
- **Utdaterte tester**: Ingen (blob `e6c37f57` i headeren er lik kravfila på branchen til PR #989)
- **Tester**: `tester-agent/02 Opptak/13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti_ved_tidlig_opptak.feature` (`38429017`)
- **Slik er testen kjørt**: stegene er fulgt slik de står (R14). Virket ikke et steg, eller fantes ikke en verdi, er testcasen «Ikke testet», med det som ble sett i «Faktisk resultat». Ett unntak, avtalt med den som startet kjøringen: dialogen om mangler i Klargjøring K (se «Å vite før neste kjøring»)
- **Kjente mangler**: Ingen liste gitt
- **Krav**: commit `d7bac074` (branchen til PR #989)
- **Kjørt av**: Claude (Vibium 26.8.21, Chrome for Testing 157, sesjonen `fs-test`) for Daniel Sachse
- **Oppsett**: ikke kjørt på nytt. Poenggrensene sto som etter oppsettet 2026-11-10 (0 på «Datateknikk ingeniør» og «Elektronisk systemingeniør», tom på «Paramedisin» og begge «Medisin»), og de er de samme etter kjøringen
- **Hoppet over**: Ingen
- **Endringer i miljøfila**: se «Å vite før neste kjøring»

## Kjøringens testdata

Som i kjøringen 2026-11-10 (`poenggrenser-tidlig-opptak`). Søkerne som er brukt: 34-1004223 og 34-1004224 (`sak-tidlig-opptak-kvalifisert`) og 34-1004247 (`sak-uten-soknad-om-tidlig-opptak`).

---

| Test (`@TST-…`) | Regel | Scenario | Teknikk | Foreslått status | Input | Faktisk resultat | Steg tatt | Bevis |
|---|---|---|---|---|---|---|---|---|
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Se antall utdanningstilbud med mangelfulle innstillinger | – (fra kravet) | Bestått | «Medisin» (Ingen median): noterte tom verdi, skrev 99, lagret («Poenggrensene er lagret.»), så tømt og lagret | «Feilkonfigurerte utdanningstilbud» 3 med 99, 4 uten poenggrense (1 mer). «Konfigurasjonsavvik» står ved tallet | Som `opptak-forvalter-forvaltende`: fanen «Tidlig opptak», to prøvekjøringer lukket med «Avbryt». Satt tilbake: verdien var tom, og feltet er tomt etter ny innlasting | `s1-mangelfulle-for.png`, `s1-mangelfulle-etter.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Utdanningstilbud med median fra forrige opptak mangler ikke poenggrense | – (fra kravet) | Bestått | «Paramedisin», median M = 47,8: noterte tom verdi, skrev 47,8 (står etter ny innlasting), så tømt og lagret | «Feilkonfigurerte utdanningstilbud» 4 i begge prøvekjøringene | Som over. Satt tilbake: verdien var tom, og feltet er tomt etter ny innlasting | `s2-median-for.png`, `s2-median-etter.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Prøvekjøre tidligopptaket | – (fra kravet) | Bestått | Søker 34-1004223, poenggrensen for «Datateknikk ingeniør» 0. Konklusjon «Kan få tidligopptak, har godkjent grunn.» | «Totale tilbudsgarantier» 3 før, 4 etter Klargjøring K (1 mer). Dialogen viser «Tallene viser hva som skjer hvis du kjører nå. Ingenting er lagret eller sendt ennå.» «Tilbudsgaranti fra forvalter»: «Ikke valgt» på begge søknadsalternativene etter prøvekjøringen | Prøvekjøring, K (sjekket etter ny innlasting), prøvekjøring lukket med «Avbryt», S | `s3-provekjoring.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Reservert studieplass fra opptaksforvalter blir erstattet | – (fra kravet) | Bestått | Søker 34-1004224. Som opptaksforvalter: «Tilbudsgaranti, har Møttkode=R fra ifjor» (RSO) i «Tilbudsgaranti fra forvalter» for «Datateknikk ingeniør», «Tilbudsgaranti lagret» | «Datateknikk ingeniør»: «Tilbudsgaranti fra forvalter» er «Tilbudsgaranti, forhåndsløfte», ikke RSO. «Elektronisk systemingeniør»: «Ikke valgt» | RSO satt; K, der «Behandlet» ga dialogen om mangler (valgt «Publiser og sett til Behandlet», avtalt), sjekket etter ny innlasting; G (felles); S | `s4-behandlet-valgt.png`, `g-resultat.png`, `s-224.png` (lokalt, ikke i git) |
| `@TST-OPT-BEH-BEH-001` | Opptaksforvalter gjennomfører tidligopptaket | Tidligopptakstilbud fra tilbyder gjelder også uten søknad om tidlig opptak | – (fra kravet) | Bestått | Søker 34-1004247. Som `opptak-tilbyder-behandlende`: «Tilbudsgaranti, tidligsvar (foropptak)» i «Tilbudsgaranti fra tilbyder» for «Datateknikk ingeniør», «Tilbudsgaranti lagret», står etter ny innlasting | «Datateknikk ingeniør»: «Tilbudsgaranti fra tilbyder» er fortsatt «Tilbudsgaranti, tidligsvar (foropptak)», og «Tilbudsgaranti fra forvalter» er «Tilbudsgaranti, forhåndsløfte» | Tilbudsgaranti fra tilbyder; G (felles); S | `g-resultat.png`, `s-247.png` (lokalt, ikke i git) |

**Gjennomføring G** (felles for de to siste): prøvekjøringen viste «Totale tilbudsgarantier» 6. Etter «Kjør tidligopptak» i dialogen heter den «Resultat for tidligopptak», og viser «Dette er resultatet etter kjøring av tidligopptaket.» og «Lukk» (steg 5). `g-provekjoring.png`, `g-resultat.png` (lokalt, ikke i git).

## Oppsummering

5 testcaser: 5 bestått (foreslått). Den nye resultatdialogen og prøvekjøringsteksten stemmer med testen.

## Funn

Ingen.

## Å vite før neste kjøring

- **Dialog om mangler i Klargjøring K:** når saken har mangler som søkeren ikke ser ennå, gir «Behandlet» i steg 5 dialogen «Søkeren ser ikke alle manglene ennå» («Når du setter saken til Behandlet, publiseres manglene nedenfor i Min kompetanse …», her «Mangeltekst for HING»), med «Avbryt» og «Publiser og sett til Behandlet». Lukkes den, blir saken stående som «Ikke behandlet». Steg 5 bør si at «Publiser og sett til Behandlet» velges når dialogen vises (`fs-testcaser-agent`). Gjaldt 34-1004224, ikke 34-1004223.
- **S kan leses av opptaksforvalteren:** opptaksforvalteren ser de samme tilbudsgarantiene i «Søknadsalternativer» som saksbehandleren (lest som begge for 34-1004224 og 34-1004247). S kan bruke opptaksforvalteren, som har gjennomført, og spare et personabytte.
- **Opptak 34 har nå 31 utdanningstilbud** i fanen «Tidlig opptak» (miljøfila sier 24), og «Medisin» finnes to ganger (med og uten median). Miljøfila bør oppdateres.
- **Søkerne går tom:** igjen i `sak-tidlig-opptak-kvalifisert` er 34-1004225 og 34-1004258, og ingen i `sak-uten-soknad-om-tidlig-opptak`. Det må lages flere før en full kjøring.
- **Personabyttet feilet én gang** rett etter at resultatdialogen var lukket («Overstyrt bruker» sto fortsatt som opptaksforvalteren). Det virket på nytt forsøk.

## Å bekrefte

Foreslått status er agentens forslag. En tester bekrefter den, og testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene før `fs-testrapport` (agentisk) teller. Agenten har ikke fylt ut «Status» på testcasene eller i testrapporten, og kan ikke godkjenne leveransen.
