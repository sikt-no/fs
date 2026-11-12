# Kjøring 2026-11-12 14:15: Listevisning og søk i opptak (røyktest av Vibium)

- **Startet av**: Mats, som røyktest av Vibium i stedet for `cdp`-skillen (PR #1026). Testene er valgt som én fil
- **Miljøfil**: [test.md](../../../../_Miljøer/test.md), personaer sist sjekket 2026-11-04
- **Miljø**: https://test-fsadmin.sikt.no. Flagget `opptak-filter-organisasjon` er `[Fylles ut]` i miljøfila
- **Kravstatus**: Alle `@implemented`
- **Utdaterte tester**: Ingen (blob `e52dde99` er den samme som kravfila på `origin/main`)
- **Tester**: `tester-agent/02 Opptak/11 Opprette og vedlikeholde opptak/07 Oversikt over opptak/listevisning_og_sok_i_opptak.feature`
- **Slik er testen kjørt**: stegene er fulgt slik de står (R14). Virket ikke et steg, eller fantes ikke en verdi, er testcasen «Ikke testet», med det som ble sett i «Faktisk resultat». Når ordene i et steg ikke er de samme som i skjermen, men det bare finnes ett valg som passer, er det valget tatt, og det står i raden
- **Kjente mangler**: Ingen
- **Krav**: commit `4724ca41`
- **Kjørt av**: Claude (Opus 5.5) med Vibium 26.8.21 (CLI-en, Chrome for Testing 157), for Mats, i sesjonen `fs-poc`. Innlogget med Feide-testbrukeren fra `tester-agent/.env` (ikke i git)
- **Oppsett**: `_Oppsett/02 Opptak/11 Opprette og vedlikeholde opptak/oppsett.feature`, bare scenarioet `opptak-samordna-uten-utdanningstilbud`, kjørt 14:17–14:21. 1 av 1 nøkkel laget. `opptak-oversikt-flere-typer` er ikke kjørt: den bygger på `opptak-lokalt`, og `regelverkssamling-lokalt` er `[Fylles ut]`
- **Hoppet over**: Ingen (filen har ingen `@endrer-data`)
- **Endringer i miljøfila**: `opptak-forvalter-forvaltende` ser 5 opptak (4 før kjøringen), mot 47 rader 2026-10-29. Det tyder på at `opptak-filter-organisasjon` er på nå. Forslag: sett flagget i miljøfila etter at det er sjekket

## Kjøringens testdata

Fra oppsettet. Testene i kjøringen slår opp nøklene her.

| Nøkkel | Navn | URL | Laget av |
|---|---|---|---|
| `opptak-samordna-uten-utdanningstilbud` | «Samordna opptak 2027 (test 2026-11-12 1415)», engelsk «Coordinated admission 2027 (test 2026-11-12 1415)» | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjUx | `opptak-forvalter-forvaltende` |
| `opptak-oversikt-flere-typer` | – | – | Ikke laget (se «Oppsett») |

### Oppsettet

| Nøkkel | Foreslått status | Faktisk resultat | Bevis |
|---|---|---|---|
| `opptak-samordna-uten-utdanningstilbud` | Bestått | Utfylling O fylt ut og lagret: «Lagring vellykket». Søket på navnet gir «Én rad i listen». «Oppsummert»: «Kan søke på tidlig opptak» «Nei», «Tilbyr ledige studieplasser» «Nei», alle fristene som i Utfylling O. Redigeringssiden: «Samordnede organisasjoner» «Ingen organisasjoner er lagt til ennå». Avvik i stegene: opptakstypen heter «Samordna opptak til grunnstudier ved universiteter og høyskoler» i skjermen (Utfylling O: «… til universiteter og høgskoler»). Det er det eneste UHG-valget, og det er valgt. Fristene uten klokkeslett i Utfylling O fikk 00:00. «Publiseringsdato» sto i feltet, men «Fyll ut obligatoriske felt: Publiseringsdato» ble stående til datoen var skrevet på nytt og feltet forlatt, som i kjøringen 2026-10-29 | `oppsett-publiseringsdato.png`, `oppsett-lagret.png`, `oppsett-sok.png`, `oppsett-detaljside.png` (lokalt, ikke i git) |

---

| Test (`@TST-…`) | Regel | Scenario | Teknikk | Foreslått status | Input | Faktisk resultat | Steg tatt | Bevis |
|---|---|---|---|---|---|---|---|---|
| `@TST-OPT-OVO-OVE-001` | Liste over alle opptak | Se liste over opptak | – (fra kravet) | Ikke testet | – | `opptak-oversikt-flere-typer` har ingen verdi i «Kjøringens testdata» | – | – |
| `@TST-OPT-OVO-OVE-001` | Liste over alle opptak | Liste er sortert etter når opptaket ble opprettet som standard | – (fra kravet) | Ikke testet | – | `opptak-oversikt-flere-typer` har ingen verdi | – | – |
| `@TST-OPT-OVO-OVE-001` | Liste over alle opptak | Velge sorteringsretning for <felt> (8 eksempler) | – (fra kravet) | Ikke testet | – | `opptak-oversikt-flere-typer` har ingen verdi | – | – |
| `@TST-OPT-OVO-OVE-001` | Liste over alle opptak | Liste over alle opptak: rekkefølgen etter sortering på organisasjon | Ekvivalensklasser | Ikke testet | – | `opptak-oversikt-flere-typer` har ingen verdi | – | – |
| `@TST-OPT-OVO-OVE-001` | Liste over alle opptak | Liste viser de 50 første opptakene | – (fra kravet) | Ikke testet | – | `opptak-oversikt-over-50` er «Finnes ikke» i miljøfila | – | – |
| `@TST-OPT-OVO-OVE-001` | Liste over alle opptak | Laste inn 50 flere opptak | – (fra kravet) | Ikke testet | – | `opptak-oversikt-over-50` er «Finnes ikke» i miljøfila | – | – |
| `@TST-OPT-OVO-OVE-001` | Liste over alle opptak | Alle opptak er lastet inn | – (fra kravet) | Bestått | – | «4 rader i listen», fire rader, og «Last inn flere» vises ikke. Skjermen viser ikke «Viser N av M rader», men antallet én gang. Det er tatt som N = M, som i kjøringen 2026-10-29. Bør gås gjennom | «Opptak», lest antallet og radene | `alle-lastet.png` (lokalt, ikke i git) |
| `@TST-OPT-OVO-OVE-001` | Liste over alle opptak | Navigere til detaljside for opptak | – (fra kravet) | Bestått | «Samordna opptak 2027 (test 2026-11-12 1415)» | «Én rad i listen». Raden åpner https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjUx. Den synlige overskriften er «Samordna opptak 2027 (test 2026-11-12 1415)», og «Oppsummert» og «Oppgaver» vises | «Opptak», «Filter», skrev navnet i «Opptaksnavn», «Lukk», valgte raden | `fritekst-sok.png`, `detaljside.png` (lokalt, ikke i git) |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Fritekst-søk på navn | – (fra kravet) | Bestått | «Samordna opptak 2027 (test 2026-11-12 1415)» | «Én rad i listen», og raden er «Samordna opptak 2027 (test 2026-11-12 1415)» | «Opptak», «Filter», skrev navnet i «Opptaksnavn», «Lukk» | `fritekst-sok.png` (lokalt, ikke i git) |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Søk og filtrering av opptak: søk på små bokstaver | Ekvivalensklasser | Bestått | «samordna opptak 2027 (test 2026-11-12 1415)» | «Én rad i listen»: «Samordna opptak 2027 (test 2026-11-12 1415)» | Som over | Tekst fra siden |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Søk og filtrering av opptak: søk på store bokstaver | Ekvivalensklasser | Bestått | «SAMORDNA OPPTAK 2027 (TEST 2026-11-12 1415)» | «Én rad i listen»: «Samordna opptak 2027 (test 2026-11-12 1415)» | Som over | Tekst fra siden |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Søk og filtrering av opptak: søk på del av navnet | Ekvivalensklasser | Bestått | «Samordna opptak 2027» | «Én rad i listen»: «Samordna opptak 2027 (test 2026-11-12 1415)» | Som over | Tekst fra siden |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Søk og filtrering av opptak: søk på navnet på nynorsk | Ekvivalensklasser | Bestått | «Samordna opptak 2027 (test 2026-11-12 1415)» | Som søket på bokmål. Navnet på nynorsk er det samme som på bokmål i Utfylling O, så raden prøver ikke noe nytt (`[Sjekk testdata]` i testen) | Som over | Tekst fra siden |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Søk og filtrering av opptak: søk på navnet på engelsk | Ekvivalensklasser | Bestått | «Coordinated admission 2027 (test 2026-11-12 1415)» | «Én rad i listen»: «Samordna opptak 2027 (test 2026-11-12 1415)» | Som over | Tekst fra siden |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Søk og filtrering av opptak: søk på ingen treff | Ekvivalensklasser | Bestått | «Finnes ikke qzx» | «Ingen opptak funnet» og «Prøv å justere filtrene dine» | Som over | `ingen-treff.png` (lokalt, ikke i git) |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Tilgjengelige opptakstyper i filter | – (fra kravet) | Ikke bestått | – | «Type» har «HYU», «LOKAL», «TEST_IT», «UHG» og «UHM», i alfabetisk rekkefølge, og ingen er valgt. Testen venter tre valg. Det samme som 2026-10-29 (F10 der) | «Opptak», «Filter», «Type» | `type-filter.png`, `status-type-filter.png` (lokalt, ikke i git) |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Filtrere på opptakstype | – (fra kravet) | Ikke testet | – | `opptak-oversikt-flere-typer` har ingen verdi | – | – |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Tilgjengelige statuser i filter | – (fra kravet) | Bestått | – | «Status» har «Ikke publisert», «Publisert» og «Arkivert», og ingen er valgt | «Opptak», «Filter», «Status» | `status-type-filter.png` (lokalt, ikke i git) |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Filtrere på status | – (fra kravet) | Ikke testet | – | `opptak-oversikt-flere-typer` har ingen verdi | – | – |
| `@TST-OPT-OVO-OVE-001` | Søk og filtrering av opptak | Kombinere filtre | – (fra kravet) | Ikke testet | – | `opptak-oversikt-flere-typer` har ingen verdi | – | – |

Totalt 27 testcaser (scenariomalene telt per eksempel): 10 Bestått, 1 Ikke bestått, 16 Ikke testet.

## Funn

| Nr | Test | Type | Hva skjedde | Forventet | Steg for å gjenskape | Bevis |
|---|---|---|---|---|---|---|
| F1 | `@TST-OPT-OVO-OVE-001` «Tilgjengelige opptakstyper i filter» | Feil (i testen eller kravet, avklares) | «Type» har fem koder: «HYU», «LOKAL», «TEST_IT», «UHG», «UHM» | Kravet: «alle opptakstypene», alfabetisk, ingen valgt. Testen lister tre typer, og har ikke «HYU», «TEST_IT» og «UHM». Det samme funnet som F10 i kjøringen 2026-10-29, og ikke rettet i testen | «Opptak», «Filter», «Type» | `type-filter.png` |

## Verktøyet (Vibium 26.8.21)

Dette er ikke funn i løsningen, men det røyktesten skulle vise.

| Nr | Hva | Følge for kjøringen |
|---|---|---|
| V1 | `vibium fill` og `vibium type` feiler med «element not found» eller «timeout … waiting for element» på alle tekstfelt som er prøvd (Feide-innloggingen, «Opptaksnavn», navnene i skjemaet), selv om `count`, `click`, `focus` og `value` finner feltet | Tekst er skrevet tegn for tegn med `vibium press` (ekte tastetrykk, «Space» for mellomrom). Det virker, og tar ca. 1 sekund per 15 tegn. `vibium keys` godtar ikke tekst med mellomrom |
| V2 | `vibium map` viste den gamle personaen i «Overstyrt bruker» etter byttet, også etter `reload`, mens `text`, `eval` og skjermbildet viste den nye | `map` er brukt bare for referanser, aldri som bevis |
| V3 | `click` på en rad i lista feilet med «element is obscured» mens «Filter» var åpent. `Escape` lukket ikke vinduet | Lukket med «Lukk» før raden ble valgt |
| V4 | FS Admin har skjulte dialoger i siden («Advarsel» om økten, «Tilbakemelding»). Den første `h1` er «Advarsel» | Overskriften er lest som den synlige `h1` |
| V5 | Innloggingen: Feide-skjemaet ble fylt ut med `eval` (V1), siden innloggingen ikke er et teststeg | Bør erstattes med `press` når V1 er avklart, eller med en rettet versjon av Vibium |
| V6 | Dokumentasjonen på GitHub (`main`) beskriver kommandoer som ikke finnes i 26.8.21: `setup`, `ready`, `run`, `--user-data-dir`, `find --all`. I 26.8.21 er `check` å huke av en boks | README er skrevet etter 26.8.21 |

## Å bekrefte

Foreslått status er agentens forslag. En tester bekrefter den, og testansvarlig går gjennom alle funn og tar stikkprøver av de beståtte testcasene før `fs-testrapport` (agentisk) teller. Agenten har ikke fylt ut «Status» på testcasene eller i testrapporten, og kan ikke godkjenne leveransen.
