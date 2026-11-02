# Testcaser og testdata – Opprette og vedlikeholde opptak v4

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155553291
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5159026690
- **Laget**: 2026-10-30, delt ut av testplanen (versjon 4 ble laget 2026-10-29 av fs-testplan)

---

Testcasene som skal lages, testbrukerne og testdataene for «Opprette og vedlikeholde opptak», versjon 4. Testplanen: [Testplan – Opprette og vedlikeholde opptak v4](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5155553291).

## Testcaser som skal lages

Omfanget av testcasene, ikke testcasene selv. `fs-testcaser-cdp` lager testcasene for fase 2 ut fra tabellen, og `fs-testcaser-intern` testcasene for fase 3. Teamet og testansvarlig går gjennom omfanget før testcasene lages.

### Fase 2: agentisk funksjonstest

Testene finnes fra før i [`cdp-tester/02 Opptak/11 Opprette og vedlikeholde opptak/`](../../cdp-tester/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/), oppdatert med `fs-testcaser-cdp` 29.10.2026. Alle fem testene stemmer med kravene på `origin/main` (blob-hashen i headeren): Opprette et opptak og Samordna opptak fra commit `0f010d4`, Listevisning fra `bd5f00b`, Innstillinger fra `270d681` og Frister fra `0ec4b48`. Testdataene lages av [oppsettet](../../cdp-tester/_Oppsett/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/oppsett.feature), som kjøres først.

| Krav | Regel | Scenarioer | Utledede testcaser | Teknikk |
|---|---|---|---|---|
| `@OPT-OVO-GRU-001` | Opptaksforvalter kan opprette et opptak | 2 | Opptakstypene som vises i samordna og lokalt opptak (2) | ekvivalensklasser |
| `@OPT-OVO-GRU-001` | Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak | 3 | – | – |
| `@OPT-OVO-GRU-001` | Utdanningsbakgrunner, poenglikhetsregel og maks antall søknadsalternativer må være satt (`@in-progress`) | 1 (scenariomal: 3 eksempler) | Feilmeldingen ved tom liste med utdanningsbakgrunner (1) | ekvivalensklasser |
| `@OPT-OVO-GRU-001` | Opptaket må ha navn på bokmål, nynorsk og engelsk | 3 (scenariomal: 3 eksempler) | Bare mellomrom på hvert språk, 100 tegn, og 101 tegn på hvert språk (3) | ekvivalensklasser, grenseverdianalyse |
| `@OPT-OVO-SAM-001` | … kan legge til organisasjoner i et samordna opptak | 1 | Søket i «Inviter» på navn, forkortelse og kode; en organisasjon som er lagt til, vises ikke (2) | ekvivalensklasser |
| `@OPT-OVO-SAM-001` | Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud | 1 | – | – |
| `@OPT-OVO-SAM-001` | Organisasjoner som ikke deltar, kan ikke se opptaket (ikke levert) | 2 | – | – |
| `@OPT-OVO-SAM-001` | En deltakende organisasjon kan ikke fjernes … så lenge den har utdanningstilbud | 2 | – | tilstandsoverganger |
| `@OPT-OVO-SAM-001` | Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger (delvis levert) | 2 | – (scenarioene testes som de står, ingen egne testcaser for tilgang) | – |
| `@OPT-OVO-SAM-001` | I et lokalt opptak kan ikke andre organisasjoner legges til | 1 | – | – |
| `@OPT-OVO-SAM-001` | Kun organisasjoner som finnes i utdanningsregisteret kan legges til | 2 | – | – |
| `@OPT-OVO-SAM-001` | Opptaksforvalter kan begrense hvilke lærestedstyper som får delta | 2 | Ingen type valgt, og alle typer valgt (1) | ekvivalensklasser |
| `@OPT-OVO-SAM-001` | … se og navigere til saksbehandlertildelingen i samordna opptak (delvis levert) | 2 | – | – |
| `@OPT-OVO-INN-001` | … endre opptakstype så lenge ingen utdanningstilbud er knyttet til opptaket | 2 | – | tilstandsoverganger |
| `@OPT-OVO-INN-001` | … endre regelverkssamling så lenge ingen utdanningstilbud er knyttet til opptaket | 2 | – | tilstandsoverganger |
| `@OPT-OVO-INN-001` | … setter standard poenglikhetsregel for opptaket | 2 | «Kan overstyres» uten valgte unntak, med én og med alle (2) | beslutningstabell |
| `@OPT-OVO-INN-001` | … kan sette startnummer for søknadene | 2 | Grenseverdier 1, 0 og største heltall; desimaltall og tekst (3) | grenseverdianalyse, ekvivalensklasser |
| `@OPT-OVO-INN-001` | … setter tak for antall søknadsalternativer | 1 | Grenseverdier 0 og 1 (1) | grenseverdianalyse |
| `@OPT-OVO-INN-001` | … kan åpne for tidlig opptak | 3 | Lenken: bare mellomrom, uten http eller https (2) | ekvivalensklasser |
| `@OPT-OVO-INN-001` | … kan åpne for søknad på ledige studieplasser | 1 | Datoene vises bare når valget er på (1) | beslutningstabell |
| `@OPT-OVO-INN-001` | … kan legge til utdanningsbakgrunner som gjelder for opptaket | 5 | – | – |
| `@OPT-OVO-INN-001` | … kan styre om søkere kan laste opp dokumentasjon | 3 | – | – |
| `@OPT-OVO-INN-001` | Regler uten scenario (se over) | – | Tidlig opptak kan ikke slås av når et utdanningstilbud tilbyr det; «Slå av valget?» med «Avbryt» og «Slå av valget» (2, under «… kan åpne for tidlig opptak»). Minst én regel ved overstyring var allerede med («kan overstyres uten valgte unntak») | tilstandsoverganger, beslutningstabell |
| `@OPT-OVO-FRI-001` | Åpne og stenge for redigering av utdanningstilbud | 2 | Delvis utfylt dato (1) | ekvivalensklasser |
| `@OPT-OVO-FRI-001` | Frist for å trekke utdanningstilbud (delvis levert) | 4 (scenariomal: 2 eksempler) | – (samme dag, dagen etter og dagen før med varsel er scenarioer i kravet) | grenseverdianalyse (i scenarioene) |
| `@OPT-OVO-FRI-001` | Åpne for søkning, søknadsfrist, omprioriteringsfrist, sletting av søknadsalternativer | 4 | – (dekket av «De ordinære fristene må være satt») | – |
| `@OPT-OVO-FRI-001` | Informasjonsdato for dokumentasjon og ettersendingsfrist | 2 | – | – |
| `@OPT-OVO-FRI-001` | Informasjonsdatoer for ledige studieplasser | 3 | – | – |
| `@OPT-OVO-FRI-001` | Frister for tidlig opptak | 4 (scenariomal: 3 eksempler) | Kortet vises bare når tidlig opptak er på (1) | beslutningstabell |
| `@OPT-OVO-FRI-001` | Informasjonsdatoer for opptaksresultat (delvis levert) | 2 | – | – |
| `@OPT-OVO-FRI-001` | Dato for aldersberegning | 2 | – (standarddatoen uten publiseringsdato er ikke laget: publiseringsdatoen er obligatorisk i skjemaet) | – |
| `@OPT-OVO-FRI-001` | Frist for endring av utdanningsbakgrunn | 1 | – | – |
| `@OPT-OVO-FRI-001` | Utdanningsbakgrunner med avvikende frister | 1 | – | – |
| `@OPT-OVO-FRI-001` | De ordinære fristene må være satt for å lagre opptaket | 3 (scenariomaler: 10 og 3 eksempler) | En obligatorisk frist kan ikke tømmes (1). FS Admin setter en tømt frist tilbake til forrige verdi (`OpptakDeadlineInput.tsx:133-136`), så scenariomalen «Opptaket kan ikke lagres uten <frist>» vil trolig ikke bestå på et lagret opptak (`fs-krav`) | ekvivalensklasser |
| `@OPT-OVO-OVE-001` | Liste over alle opptak | 7 (scenariomal: 6 eksempler) | Rekkefølgen etter sortering på organisasjon (koden, ikke forkortelsen) (1) | ekvivalensklasser |
| `@OPT-OVO-OVE-001` | Søk og filtrering av opptak | 4 | Store og små bokstaver, del av navnet, nynorsk og engelsk, ingen treff (1) | ekvivalensklasser |

I testene nå (29.10): Opprette et opptak 15 testcaser (6 utledet), Samordna opptak 18 (3), Innstillinger 32 (11), Frister 31 (3), Listevisning 13 (2), til sammen 109 (25 utledet). Utledede testcaser lages bare der regelen har verdier eller betingelser å teste.

### Fase 3: intern akseptansetest

| Flyt eller oppgave | Krav | Scenarioer i flyten | Avhengigheter som sjekkes | Regresjon |
|---|---|---|---|---|
| Oppgave uten flyt: opprette-og-vedlikeholde-opptak (opprette → innstillinger → frister → invitere læresteder → deltakeren legger til utdanningstilbud → oversikten) | `@OPT-OVO-GRU-001`, `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, `@OPT-OVO-SAM-001`, `@OPT-OVO-OVE-001` | – (oppgave uten flyt: `fs-testcaser-intern` velger scenarioene) | Utdanningsregisteret, utdanningstilbud i opptak, `MEDLEM_OPPTAK`, saksbehandlertildeling (lenken), Unleash-flaggene | nei |

Krav som ikke er med i noen flyt som kan testes: 5. De testes som en oppgave uten flyt. Flyten Saksbehandlertildeling testes ikke, fordi ingen faser er levert.

I tillegg til flytene og oppgavene har den interne testen tre deler. Testansvarlig (Marit Bjørnerud Rønning) og teamet (Maciek Adamczyk og Jøran Wigen Aasterud) tester dem. Omfanget avgjøres når testcasene lages, etter kjøringen i fase 2.

| Del | Omfang | Hvem velger |
|---|---|---|
| Det den agentiske testen ikke klarte | Testcasene fra fase 2 som blir «Ikke testet». Kjent på forhånd: «Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes» (krever en søker med søknad), «Liste viser de 50 første opptakene» og «Laste inn 50 flere opptak» (over 50 opptak finnes ikke i TEST), og oppsettet for opptakene med deltaker hvis NTNU ikke har `MEDLEM_OPPTAK` | Kjøringen i fase 2 |
| Opplevelse og helhet | Opprette et samordna og et lokalt opptak, innstillingene og fristene i «Endre innstillinger for opptaket», «Inviter organisasjoner til samordningen», og oversikten over opptak: forståelig og brukbar, tekster og begreper (for eksempel «Ordinær frist» der kravet sier «informasjonsdato for dokumentasjon», og backend-navnet på fristen for å trekke utdanningstilbud), og universell utforming | Testansvarlig |
| Høyest risiko | Kandidater: de 8 scenarioene som ikke er funnet eller er usikre i verifiseringen, reglene som bare FS Admin sperrer (tom liste med utdanningsbakgrunner, tidlig opptak uten lenke, opptakstype med utdanningstilbud), at en organisasjon som ikke deltar, kan åpne et samordna opptak, og at oversikten viser tidlig opptak, opplasting og studierett som påslått uansett verdi | Testansvarlig, etter en risikovurdering |


## Testbrukere

Fra [test.md](../../cdp-tester/_Miljøer/test.md), personaer sist sjekket 2026-10-28.

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | `opptak-forvalter-forvaltende` | Ordentlig rundskriv | `OPPTAK_FORVALTER` og `OPPTAK_SAKSBEHANDLER` ved organisasjonen som forvalter samordna opptak | Direktoratet for høyere utdanning og kompetanse (HK-DIR, 20827) | «Overstyrt bruker»: ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER_OG_OPPTAK_SAKSBEHANDLER (HK-dir) | https://test-fsadmin.sikt.no/opptak | Opprette samordna opptak, innstillinger, frister, samordning (forvaltende organisasjon), oversikten over opptak |
| 2 | `opptak-forvalter-deltakende` | Ansvarsfull Fotkrem | `OPPTAK_FORVALTER` ved et universitet som deltar i opptaket | Norges teknisk-naturvitenskapelige universitet (NTNU, 194) | «Overstyrt bruker»: ANSVARSFULL FOTKREM • OPPTAK_FORVALTER (NTNU) | https://test-fsadmin.sikt.no/opptak | Samordna opptak: deltaker som legger til utdanningstilbud, og som ser, men ikke endrer, innstillingene. Trenger `MEDLEM_OPPTAK` (ikke bekreftet) |
| 3 | `opptak-forvalter-ikke-deltakende` | Talefør Elv | `OPPTAK_FORVALTER` ved en organisasjon som ikke deltar | Fagskolen i Vestfold og Telemark (FVT, 20418) | «Overstyrt bruker»: TALEFØR ELV • OPPTAK_FORVALTER (Fagskolen Vestfold og Telemark) | https://test-fsadmin.sikt.no/opptak | Samordna opptak: organisasjon som ikke deltar |
| 4 | `opptak-forvalter-lokalt` | Ru Brødskive | `OPPTAK_FORVALTER` ved et lærested med lokalt opptak | Høgskulen på Vestlandet (HVL, 203) | «Overstyrt bruker»: RU BRØDSKIVE • OPPTAK_FORVALTER (HVL) | https://test-fsadmin.sikt.no/opptak | Opprette lokalt opptak, lokalt opptak i Samordna opptak |

Testbrukerne finnes i rollene scenarioene nevner, ved organisasjonene kravet gjelder. Det lages ikke egne testcaser for roller og tilgang i fase 2: `fs-verify` har verifisert i koden at de er laget slik kravet sier (fase 1). Scenarioene i kravet, også om synlighet, testes som de står.

### Tilgangsmatrise

Fra tilgangsradene i [verify-2026-10-28-1238.md](../opprette-opptak-2027/verify-2026-10-28-1238.md).

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@OPT-OVO-GRU-001` | Opptaksforvalter (samordna) | oppretter (stemmer) | – | 1 |
| `@OPT-OVO-GRU-001` | Opptaksforvalter (lokalt) | oppretter (stemmer) | – | 4 |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved forvaltende organisasjon | endrer innstillinger, frister og deltakere (stemmer) | – | 1 |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved deltakende organisasjon | ser opptaket (avviker: ser ikke alle innstillingene), legger til utdanningstilbud ved organisasjonen (usikker: `MEDLEM_OPPTAK`) | endrer ikke innstillinger eller deltakere (stemmer) | 2 |
| `@OPT-OVO-SAM-001` | Opptaksforvalter ved organisasjon som ikke deltar | – | legger ikke til utdanningstilbud (stemmer); skal ikke se opptaket (avviker: lesingen er åpen) | 3 |
| `@OPT-OVO-SAM-001` | Opptaksforvalter (lokalt opptak) | endrer | – | 4 |
| `@OPT-OVO-INN-001` | Opptaksforvalter ved forvaltende organisasjon | endrer (stemmer) | deltaker endrer ikke (stemmer) | 1 |
| `@OPT-OVO-FRI-001` | Opptaksforvalter ved forvaltende organisasjon | endrer (stemmer) | deltaker endrer ikke (stemmer) | 1 |
| `@OPT-OVO-OVE-001` | Opptaksforvalter | ser lista (stemmer) | ser alle opptak når flagget er av (avviker) | 1 |

## Testdata

Data i testmiljøet kan slettes eller nullstilles når som helst, så testene lager testdataene sine selv. Oppsettet ([`_Oppsett/02 Opptak/11 Opprette og vedlikeholde opptak/oppsett.feature`](../../cdp-tester/_Oppsett/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/oppsett.feature)) kjøres først i hver kjøring, og lager opptakene gjennom FS Admin, med kjøringen i navnet og fristene i forhold til testdagen. Navnene står i «Kjøringens testdata» i resultatet. Bare grunndataene og det testene ikke kan lage, må finnes i TEST. Verdiene for dem er fra [test.md](../../cdp-tester/_Miljøer/test.md), 2026-10-29. Testdata er syntetiske.

**Lages av oppsettet**

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| Samordna opptak uten utdanningstilbud | `opptak-samordna-uten-utdanningstilbud` | Lages av oppsettet («Samordna opptak 2027 (test <kjøring>)») | TEST | «Kjøringens testdata» | Forvaltes av HK-dir. Ingen deltakere og ingen utdanningstilbud. Alle obligatoriske felt og frister er satt. Tidlig opptak og ledige studieplasser er av. «Realkompetanse» uten avvikende frister. Redigering av utdanningstilbud åpner 7 dager før testen og stenger 30 dager etter. Søknaden åpner 60 dager etter testen | `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001`, `@OPT-OVO-SAM-001`, `@OPT-OVO-OVE-001` |
| Samordna opptak med utdanningstilbud | `opptak-samordna-med-utdanningstilbud` | Lages av oppsettet | TEST | «Kjøringens testdata» | Som over, men NTNU (testbruker 2) er invitert og har lagt til ett utdanningstilbud (`utdanningstilbud-deltakende`). Fagskolen i Vestfold og Telemark er ikke deltaker | `@OPT-OVO-INN-001` «Kan ikke endre opptakstype …» og «Kan ikke endre regelverkssamling …», `@OPT-OVO-SAM-001` (deltaker, ikke-deltaker, fjerne deltaker med utdanningstilbud) |
| Samordna opptak der et utdanningstilbud tilbyr tidlig opptak | `opptak-samordna-tilbud-med-tidlig-opptak` | Lages av oppsettet | TEST | «Kjøringens testdata» | Som over, med tidlig opptak på opptaket, og «Tidlig opptak» og poenggrense 50 på utdanningstilbudet | `@OPT-OVO-INN-001` «… kan ikke slås av når et utdanningstilbud tilbyr tidlig opptak» (utledet) |
| Samordna opptak med én utdanningsbakgrunn | `opptak-en-utdanningsbakgrunn` | Lages av oppsettet | TEST | «Kjøringens testdata» | Har bare «Videregående steinerskole» (kravet: «Steinerskole»). Ingen søker har valgt den | `@OPT-OVO-INN-001` «Den siste utdanningsbakgrunnen kan ikke fjernes» |
| Lokalt opptak | `opptak-lokalt` | Lages av oppsettet | TEST | «Kjøringens testdata» | Lokalt opptak ved HVL (testbruker 4) | `@OPT-OVO-SAM-001` «Lokalt opptak tillater ikke andre organisasjoner» og «Saksbehandlertildeling er ikke relevant for lokale opptak» |
| Opptak i oversikten | `opptak-oversikt-flere-typer` | Opptakene oppsettet lager | TEST | «Opptak» | Opptak av to typer (UHG og lokalt), ved to organisasjoner (HK-dir og HVL). Testbruker 1 ser HVLs lokale opptak bare når flagget `opptak-filter-organisasjon` er av | `@OPT-OVO-OVE-001` |

**Grunndata og det testene ikke kan lage** (finnes i TEST før testen)

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| Regelverkssamling | `regelverkssamling-samordna` | «UHGTEST2026» | TEST, FS Admin | Velges i skjemaet for opptaket | Kan velges i et samordna opptak | Oppsettet, `@OPT-OVO-GRU-001`, `@OPT-OVO-INN-001` |
| Regelverkssamling | `regelverkssamling-samordna-annen` | [Fylles ut] | TEST, FS Admin | Velges i skjemaet for opptaket | En annen enn `regelverkssamling-samordna`, som kan velges i et samordna opptak | `@OPT-OVO-INN-001` «Endre regelverkssamling …» |
| Regelverkssamling | `regelverkssamling-lokalt` | [Fylles ut] | TEST, FS Admin | Velges i skjemaet for opptaket | Kan velges i et lokalt opptak ved organisasjonen til `opptak-forvalter-lokalt` | Oppsettet, `@OPT-OVO-GRU-001` «Opprette et lokalt opptak» |
| Utdanningsbakgrunner | `utdanningsbakgrunner-godkjente` | «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» | TEST | Velges i innstillingene | Står blant de godkjente utdanningsbakgrunnene | Oppsettet, `@OPT-OVO-INN-001`, `@OPT-OVO-FRI-001` |
| Poenglikhetsregler | `poenglikhetsregler` | «Loddnummer, laveste nummer først» (kravet: «Loddtrekning»), «Alder, eldste først» (kravet: «Alder, eldre foran yngre»). «Alle søkere med samme poengsum får tilbud» er ikke sett | TEST | Velges i innstillingene | Poenglikhetsreglene i kravet finnes som valg | Oppsettet, `@OPT-OVO-INN-001` |
| Organisasjoner fra utdanningsregisteret | `organisasjoner-utdanningsregisteret` | Læresteder fra utdanningsregisteret, blant dem NTNU (universitet) og Fagskolen i Vestfold og Telemark (fagskole) | TEST, replikert fra utdanningsregisteret | Søk i «Inviter» | Aktive læresteder: minst to av hver type, blant dem organisasjonene til testbruker 2 og 3 | `@OPT-OVO-SAM-001` |
| Organisasjon som inviteres | `organisasjon-som-inviteres` | Universitetet i Oslo (UIO, 185) | TEST | Søk i «Inviter» | Aktivt universitet som ikke deltar i opptakene oppsettet lager, og ikke er organisasjonen til en testbruker | `@OPT-OVO-GRU-001`, `@OPT-OVO-SAM-001` «Legge til lærested i samordna opptak» |
| Utdanningstilbud ved deltakeren | `utdanningstilbud-deltakende` | [Fylles ut] | TEST, utdanningsregisteret | Velges i «Legg til utdanningstilbud» | Et utdanningstilbud ved NTNU som kan legges til i et samordna opptak | Oppsettet |
| Samordna opptak der en søker har valgt en utdanningsbakgrunn | `opptak-utdanningsbakgrunn-valgt-av-soker` | [Fylles ut] | TEST | Søk på navnet i «Opptak» | Har «Steinerskole» og minst én utdanningsbakgrunn til. En syntetisk søker har en søknad med «Steinerskole». Søknaden er åpen på testdagen. Kan ikke lages i FS Admin (krever en søknad i Min kompetanse) | `@OPT-OVO-INN-001` «Utdanningsbakgrunn som søkere har valgt, kan ikke fjernes» |
| Over 50 opptak | `opptak-oversikt-over-50` | **Finnes ikke** | TEST | «Opptak» | Minst 51 opptak synlige for testbruker 1. Lages ikke av oppsettet (51 opptak per kjøring) | `@OPT-OVO-OVE-001` «Liste viser de 50 første opptakene», «Laste inn 50 flere opptak» |

Endret siden versjon 3: opptakene er ikke lenger testdata som finnes fra før, men lages av oppsettet i hver kjøring. «Samordna opptak 2027 (test)», som var `opptak-samordna-uten-utdanningstilbud`, hadde fått et utdanningstilbud 29.10, og brukes ikke lenger. `utdanningstilbud-deltakende` er ny. Oppsettet krever at NTNU-personaen har `MEDLEM_OPPTAK` (forutsetning 4).

Data scenarioene selv lager (for eksempel opptakene i «Opprette et samordna opptak»), står ikke her: de lages av stegene i testcasen, og får kjøringen i navnet, fordi opptak ikke kan slettes.

