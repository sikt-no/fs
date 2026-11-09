# Testmiljø: TEST

Nøklene i testene i `cdp-tester/`, slått opp for TEST. Fila er det eneste stedet verdiene slås opp når testene kjøres, og den sier hvilke testpersoner og roller som finnes i FS Admin i TEST. Konvensjonene og vedlikeholdet står i [`cdp-tester/README.md`](../README.md) (*Miljøfila*).

- **FS Admin**: https://test-fsadmin.sikt.no
- **Innlogging**: testansvarlig logger inn selv, i en egen Chrome-profil til testingen. Testbrukeren byttes i «Overstyrt bruker» øverst til høyre i FS Admin
- **Kan settes tilbake**: nei, og data i TEST kan slettes eller nullstilles når som helst. Testene lager dataene sine selv, i oppsettet i [`../_Oppsett/`](../_Oppsett/), i hver kjøring. Opptak kan ikke slettes: opptakene testene og oppsettet oppretter, blir liggende, og har kjøringen i navnet (`{KJØRING}`)
- **Personaer sist sjekket**: 2026-11-04, mot `testpersoner` i TEST (personavelgeren i fs-admin `origin/main` `2f2ddf24e`)

## Feature-flagg

| Flagg | Står | Sjekket |
|---|---|---|
| `opptak-opprett-samordna` | på | 2026-10-27 |
| `opptak-filter-organisasjon` | [Fylles ut: på eller av] | – |

## Personaer

Alle radene i «Overstyrt bruker» i TEST. Siden BAT-369 (fs-admin `8e842f777`, 2026-10-30) henter velgeren personaene fra spørringen `testpersoner` i tilgangsstyringen, ikke fra `TEST_PERSONAS`, og lager én rad per tildeling (person, rolle og organisasjon). En person med flere roller har derfor flere rader, og hver rad gir bare den ene rollen (og rollene den gir i rollekatalogen). Raden er `<FORNAVN> <ETTERNAVN> • <rolle> (<forkortelse, ellers navnet på organisasjonen>)`, skrevet nøyaktig som i menyen. Organisasjonen og forkortelsen er de i organisasjonsregisteret, og det er dem testene bruker (`{ORG:<nøkkel>}`).

| Rad i «Overstyrt bruker» | Rolle | Organisasjon | Organisasjonskode | Forkortelse |
|---|---|---|---|---|
| SPED AGENT • OPPTAK_SAKSBEHANDLER (UIT) | `OPPTAK_SAKSBEHANDLER` | UiT Norges arktiske universitet | 186 | UIT |
| AKTIV BACON • SIS_SAKSBEHANDLER (SIKT_THS) | `SIS_SAKSBEHANDLER` | Sikt Testhøyskole | 7777 | SIKT_THS |
| SINDIG BOREPLATTFORM • OPPTAK_FORVALTER (FIR) | `OPPTAK_FORVALTER` | Fagskolen Rogaland | 20392 | FIR |
| TRYGG BRYGGE • OPPTAK_FORVALTER (FO) | `OPPTAK_FORVALTER` | Fagskolen Oslo | 1647 | FO |
| RU BRØDSKIVE • OPPTAK_FORVALTER (HVL) | `OPPTAK_FORVALTER` | Høgskulen på Vestlandet | 203 | HVL |
| RU BRØDSKIVE • OPPTAK_SAKSBEHANDLER (HVL) | `OPPTAK_SAKSBEHANDLER` | Høgskulen på Vestlandet | 203 | HVL |
| KORT DOMPAP • OPPTAK_FORVALTER (UIO) | `OPPTAK_FORVALTER` | Universitetet i Oslo | 185 | UIO |
| KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIO) | `OPPTAK_SAKSBEHANDLER` | Universitetet i Oslo | 185 | UIO |
| KORT DOMPAP • UTDANNINGSREGISTERET_ADMINISTRATOR (UIO) | `UTDANNINGSREGISTERET_ADMINISTRATOR` | Universitetet i Oslo | 185 | UIO |
| KORT DOMPAP • OPPTAK_FORVALTER (UIT) | `OPPTAK_FORVALTER` | UiT Norges arktiske universitet | 186 | UIT |
| KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT) | `OPPTAK_SAKSBEHANDLER` | UiT Norges arktiske universitet | 186 | UIT |
| KORT DOMPAP • UTDANNINGSREGISTERET_ADMINISTRATOR (UIT) | `UTDANNINGSREGISTERET_ADMINISTRATOR` | UiT Norges arktiske universitet | 186 | UIT |
| KORT DOMPAP • OPPTAK_FORVALTER (NTNU) | `OPPTAK_FORVALTER` | Norges teknisk-naturvitenskapelige universitet | 194 | NTNU |
| KORT DOMPAP • OPPTAK_SAKSBEHANDLER (NTNU) | `OPPTAK_SAKSBEHANDLER` | Norges teknisk-naturvitenskapelige universitet | 194 | NTNU |
| GLIMRENDE ELG • OPPTAK_SAKSBEHANDLER (FSGJØVIK) | `OPPTAK_SAKSBEHANDLER` | Fagskolen Innlandet | 1646 | FSGJØVIK |
| TALEFØR ELV • OPPTAK_FORVALTER (FVT) | `OPPTAK_FORVALTER` | Fagskolen i Vestfold og Telemark | 20418 | FVT |
| TALEFØR ELV • OPPTAK_SAKSBEHANDLER (FVT) | `OPPTAK_SAKSBEHANDLER` | Fagskolen i Vestfold og Telemark | 20418 | FVT |
| ROLIG FASTLANDSFORBINDELSE • OPPTAK_SAKSBEHANDLER (UIO) | `OPPTAK_SAKSBEHANDLER` | Universitetet i Oslo | 185 | UIO |
| STILLE FJELL • OPPTAK_SAKSBEHANDLER (PHS) | `OPPTAK_SAKSBEHANDLER` | Politihøgskolen | 233 | PHS |
| MILD FJORD • OPPTAK_SAKSBEHANDLER (TRØ) | `OPPTAK_SAKSBEHANDLER` | Trøndelag høyere yrkesfagskole | 21177 | TRØ |
| ANSVARSFULL FOTKREM • OPPTAK_FORVALTER (NTNU) | `OPPTAK_FORVALTER` | Norges teknisk-naturvitenskapelige universitet | 194 | NTNU |
| ANSVARSFULL FOTKREM • OPPTAK_SAKSBEHANDLER (NTNU) | `OPPTAK_SAKSBEHANDLER` | Norges teknisk-naturvitenskapelige universitet | 194 | NTNU |
| ANSVARSFULL FOTKREM • BRUKER_ADMINISTRATOR (SIKT_THS) | `BRUKER_ADMINISTRATOR` | Sikt Testhøyskole | 7777 | SIKT_THS |
| UNØYAKTIG GALLIUM • OPPTAK_SAKSBEHANDLER (UIT) | `OPPTAK_SAKSBEHANDLER` | UiT Norges arktiske universitet | 186 | UIT |
| ALFABETISK GLOBUS • OPPTAK_SAKSBEHANDLER (UIT) | `OPPTAK_SAKSBEHANDLER` | UiT Norges arktiske universitet | 186 | UIT |
| FRISK HAVBRIS • OPPTAK_SAKSBEHANDLER (FIR) | `OPPTAK_SAKSBEHANDLER` | Fagskolen Rogaland | 20392 | FIR |
| TRAVEL KAFFE • OPPTAK_SAKSBEHANDLER (HIØ) | `OPPTAK_SAKSBEHANDLER` | Høgskolen i Østfold | 224 | HIØ |
| SPRELSK KOMPASS • OPPTAK_SAKSBEHANDLER (FVT) | `OPPTAK_SAKSBEHANDLER` | Fagskolen i Vestfold og Telemark | 20418 | FVT |
| GLAD LAKS • OPPTAK_FORVALTER (NMBU) | `OPPTAK_FORVALTER` | Norges miljø- og biovitenskapelige universitet | 192 | NMBU |
| KJAPP LAKSEMERD • OPPTAK_FORVALTER (TRØ) | `OPPTAK_FORVALTER` | Trøndelag høyere yrkesfagskole | 21177 | TRØ |
| FUNKSJONELL MENY • OPPTAK_SAKSBEHANDLER (UIT) | `OPPTAK_SAKSBEHANDLER` | UiT Norges arktiske universitet | 186 | UIT |
| KLAR NORDLYS • OPPTAK_SAKSBEHANDLER (UIT) | `OPPTAK_SAKSBEHANDLER` | UiT Norges arktiske universitet | 186 | UIT |
| RASK PARAPLY • OPPTAK_FORVALTER (PHS) | `OPPTAK_FORVALTER` | Politihøgskolen | 233 | PHS |
| KREATIV PENSEL • OPPTAK_FORVALTER (EGK) | `OPPTAK_FORVALTER` | Einar Granum Kunstfagskole | 20402 | EGK |
| ROLIG PERRONG • OPPTAK_SAKSBEHANDLER (LOK) | `OPPTAK_SAKSBEHANDLER` | Norsk fagskole for lokomotivførere | 20389 | LOK |
| GRUNDIG PROTOKOLL • OPPTAK_SAKSBEHANDLER (HK-DIR) | `OPPTAK_SAKSBEHANDLER` | Direktoratet for høyere utdanning og kompetanse | 20827 | HK-DIR |
| VÅT REGNJAKKE • OPPTAK_SAKSBEHANDLER (HVL) | `OPPTAK_SAKSBEHANDLER` | Høgskulen på Vestlandet | 203 | HVL |
| ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) | `OPPTAK_FORVALTER` | Direktoratet for høyere utdanning og kompetanse | 20827 | HK-DIR |
| ORDENTLIG RUNDSKRIV • OPPTAK_SAKSBEHANDLER (HK-DIR) | `OPPTAK_SAKSBEHANDLER` | Direktoratet for høyere utdanning og kompetanse | 20827 | HK-DIR |
| PRESIS SKINNE • OPPTAK_FORVALTER (LOK) | `OPPTAK_FORVALTER` | Norsk fagskole for lokomotivførere | 20389 | LOK |
| VENNLIG SKOG • OPPTAK_FORVALTER (HIØ) | `OPPTAK_FORVALTER` | Høgskolen i Østfold | 224 | HIØ |
| IVRIG SNØFONN • OPPTAK_SAKSBEHANDLER (FSKNORD) | `OPPTAK_SAKSBEHANDLER` | Fagskolen i Nord | 20733 | FSKNORD |
| BLID SPORVOGN • OPPTAK_SAKSBEHANDLER (FO) | `OPPTAK_SAKSBEHANDLER` | Fagskolen Oslo | 1647 | FO |
| LYSTIG STAFFELI • OPPTAK_SAKSBEHANDLER (EGK) | `OPPTAK_SAKSBEHANDLER` | Einar Granum Kunstfagskole | 20402 | EGK |
| MODIG SYLTETØY • OPPTAK_SAKSBEHANDLER (NMBU) | `OPPTAK_SAKSBEHANDLER` | Norges miljø- og biovitenskapelige universitet | 192 | NMBU |
| NØYE TANNHJUL • OPPTAK_SAKSBEHANDLER (NTNU) | `OPPTAK_SAKSBEHANDLER` | Norges teknisk-naturvitenskapelige universitet | 194 | NTNU |
| MUNTER TRIKK • OPPTAK_SAKSBEHANDLER (UIO) | `OPPTAK_SAKSBEHANDLER` | Universitetet i Oslo | 185 | UIO |
| MUNTER TRIKK • APPLIKASJONSADMINISTRATOR (SIKT_THS) | `APPLIKASJONSADMINISTRATOR` | Sikt Testhøyskole | 7777 | SIKT_THS |
| RUNDT TØMMER • OPPTAK_FORVALTER (FSGJØVIK) | `OPPTAK_FORVALTER` | Fagskolen Innlandet | 1646 | FSGJØVIK |
| NORDLIG VINTER • OPPTAK_FORVALTER (FSKNORD) | `OPPTAK_FORVALTER` | Fagskolen i Nord | 20733 | FSKNORD |

- Raden har én rolle. En testbruker som trenger to roller (for eksempel `OPPTAK_FORVALTER` og `OPPTAK_SAKSBEHANDLER`), får bare begge når rollekatalogen gir den ene fra den andre. Det er ikke sjekket.
- `MEDLEM_OPPTAK`, som deltakeren trenger for å legge til utdanningstilbud (fs-plattform, V469), er ikke tildelt direkte. Den må komme fra rollekatalogen (`tilgangsroller`). [Fylles ut: bekreft at `OPPTAK_FORVALTER` gir `MEDLEM_OPPTAK`]
- Menyen viser forkortelsen fra organisasjonsregisteret, «HK-DIR» (sett 2026-11-03). Resten av skjermen viser «HK-dir» i lista over opptak og som «Administrator: HK-dir» og «Administreres av HK-dir» (sett 2026-10-29).

## Testbrukere

Nøkkelen i testene, hva testen krever av testbrukeren (uavhengig av miljøet), og personaen den er koblet til. Organisasjonen, forkortelsen og organisasjonskoden står på personaen. Byttes personaen, endres bare denne tabellen, ikke testene.

| Nøkkel | Krever | Persona (rad i «Overstyrt bruker») |
|---|---|---|
| `opptak-forvalter-forvaltende` | `OPPTAK_FORVALTER` ved organisasjonen som forvalter samordna opptak | ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) |
| `opptak-forvalter-deltakende` | `OPPTAK_FORVALTER` ved et universitet eller en høyskole som er deltaker i `opptak-samordna-med-utdanningstilbud`. Trenger `MEDLEM_OPPTAK` for å legge til utdanningstilbud (fs-plattform, V469). Den er ikke tildelt direkte, og må komme fra rollekatalogen (se under «Personaer») | ANSVARSFULL FOTKREM • OPPTAK_FORVALTER (NTNU) |
| `opptak-forvalter-ikke-deltakende` | `OPPTAK_FORVALTER` ved en organisasjon som ikke er deltaker i testdata-opptakene | TALEFØR ELV • OPPTAK_FORVALTER (FVT) |
| `opptak-forvalter-lokalt` | `OPPTAK_FORVALTER` ved et lærested med lokalt opptak | RU BRØDSKIVE • OPPTAK_FORVALTER (HVL) |
| `opptak-saksbehandler-behandlende` | `OPPTAK_SAKSBEHANDLER` med SE- eller MODIFISERE_SØKNADSBEHANDLING ved organisasjonen som behandler sakene i `opptak-vitnemalsbehandling`. [Fylles ut: bekreft at sakene behandles av NTNU, og at `OPPTAK_SAKSBEHANDLER` gir SE_SØKNADSBEHANDLING i rollekatalogen] | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (NTNU) |
| `opptak-saksbehandler-behandlende-annen` | En annen `OPPTAK_SAKSBEHANDLER` ved samme organisasjon som `opptak-saksbehandler-behandlende`, som saken kan tilordnes | NØYE TANNHJUL • OPPTAK_SAKSBEHANDLER (NTNU) |
| `opptak-saksbehandler-behandlende-tidlig-opptak` | `OPPTAK_SAKSBEHANDLER` ved organisasjonen som behandler sakene i `opptak-tidlig-opptak`. Saken havner hos UiT når «Automasjon, ingeniør …» er førsteprioritet (den eksterne testen av tidlig opptak, 2026-11-05) | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT) |
| `opptak-tilbyder-behandlende` | Tilbyder (`OPPTAK_TILBGARANTI_GI_VIA_UTDTILBUD`) ved lærestedet som tilbyr utdanningstilbudet og behandler saken i `opptak-tidlig-opptak`. Tilbyderen ser bare saken når den er ved lærestedet som behandler den (STEK-576). [Fylles ut: bekreft at `OPPTAK_FORVALTER` gir tilbyderrollen i rollekatalogen] | KORT DOMPAP • OPPTAK_FORVALTER (UIT) |
| `soker-tidlig-opptak` | En syntetisk søker i «Velg testsøker» i Min kompetanse, uten søknad i `opptak-tidlig-opptak`. Én søker per tilstand testen trenger, og en søker kan ikke brukes på nytt etter at den har søkt om tidlig opptak | Søkerne i «Søkere til testerne» i den eksterne testen av tidlig opptak (`akseptansetest/tidlig-opptak-ekstern/testcaser-ekstern.md`, PR #927) som ikke er brukt |
| `opptak-saksbehandler-annen-organisasjon` | `OPPTAK_SAKSBEHANDLER` ved en organisasjon som ikke behandler sakene i `opptak-vitnemalsbehandling`, og som verken er opptaksforvalter for opptaket eller tilbyder av et søknadsalternativ | GLIMRENDE ELG • OPPTAK_SAKSBEHANDLER (FSGJØVIK) |

## Testdata

Bare grunndata og data testene ikke kan lage gjennom løsningen. Testdataene oppsettet lager i hver kjøring, står i oppsettet, ikke her: for opptak [`_Oppsett/02 Opptak/11 Opprette og vedlikeholde opptak/oppsett.feature`](../_Oppsett/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/oppsett.feature) (`opptak-samordna-uten-utdanningstilbud`, `opptak-samordna-med-utdanningstilbud`, `opptak-samordna-tilbud-med-tidlig-opptak`, `opptak-en-utdanningsbakgrunn` og `opptak-lokalt`, og `opptak-oversikt-flere-typer`, som er de to opptakene `opptak-samordna-uten-utdanningstilbud` og `opptak-lokalt`).

| Nøkkel | Verdi i TEST | Søk/URL | Utgangstilstand | Sjekket |
|---|---|---|---|---|
| `regelverkssamling-samordna` | «UHGTEST2026» | Velges i skjemaet for opptaket | Regelverkssamling som kan velges i et samordna opptak | 2026-10-26 |
| `regelverkssamling-samordna-annen` | [Fylles ut] | Velges i skjemaet for opptaket | En annen regelverkssamling enn `regelverkssamling-samordna`, som kan velges i et samordna opptak | – |
| `regelverkssamling-lokalt` | [Fylles ut] | Velges i skjemaet for opptaket | Regelverkssamling som kan velges i et lokalt opptak ved organisasjonen til `opptak-forvalter-lokalt` | – |
| `utdanningsbakgrunner-godkjente` | «Realkompetanse», «Utenlandsk videregående skole» og «Videregående steinerskole» (kravet: «Utenlandsk utdanning» og «Steinerskole») | Velges i innstillingene | «Realkompetanse», «Utenlandsk videregående skole» og «Videregående steinerskole» står blant de godkjente utdanningsbakgrunnene | 2026-10-29 |
| `poenglikhetsregler` | «Loddnummer, laveste nummer først» (kravet: «Loddtrekning»), «Alder, eldste først» (kravet: «Alder, eldre foran yngre») og «Alle søkere med samme poengsum får tilbud» | Velges i innstillingene | Poenglikhetsreglene i kravet finnes som valg | 2026-10-29 |
| `organisasjoner-utdanningsregisteret` | Læresteder fra utdanningsregisteret, blant dem NTNU (universitet) og Fagskolen i Vestfold og Telemark (fagskole) | Søk i «Inviter» | Aktive læresteder i utdanningsregisteret: minst to av hver type (universitet, høyskole, fagskole), blant dem organisasjonene til `opptak-forvalter-deltakende` og `opptak-forvalter-ikke-deltakende` | 2026-10-27 |
| `utdanningstilbud-deltakende` | [Fylles ut] | Velges i «Legg til utdanningstilbud» | Et utdanningstilbud i utdanningsregisteret ved organisasjonen til `opptak-forvalter-deltakende`, som kan legges til i et samordna opptak. Brukes av oppsettet | – |
| `organisasjon-som-inviteres` | Universitetet i Oslo (UIO, 185) | Søk i «Inviter» | Et aktivt universitet eller en høyskole i utdanningsregisteret, som ikke er deltaker i testdata-opptakene og ikke er organisasjonen til en av testbrukerne | 2026-10-27 |
| `opptak-utdanningsbakgrunn-valgt-av-soker` | [Fylles ut] | Søk på navnet i «Opptak» | Samordna opptak med «Steinerskole» og minst én utdanningsbakgrunn til. En syntetisk søker har en søknad med «Steinerskole». Søknaden er åpen på testdagen | – |
| `opptak-oversikt-over-50` | **Finnes ikke** | «Opptak» | Minst 51 opptak synlige for `opptak-forvalter-forvaltende` | 2026-10-27 |
| `opptak-tidlig-opptak` | Opptak 34, «Samordna UHG-simulering høsten 2026» (`T3BwdGFrOjM0`) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0 | Samordna opptak med tidlig opptak slått på. «Automasjon, ingeniør - bachelor (ordinær, y-vei)» (UiT) og «Elektronisk systemingeniør - bachelor i ingeniørfag» (NTNU) tilbyr tidlig opptak. Gjennomføringen av tidligopptaket kan ikke settes tilbake | 2026-11-05 |
| `tilbudsgarantitype-tidlig-opptak` | [Fylles ut] | Tilbudsgarantitypene i `opptak-tidlig-opptak` | Nøyaktig én aktiv tilbudsgarantitype for tidlig opptak som gir tilbud og kan brukes av opptaksforvalteren | – |
| `utdanningstilbud-tidlig-opptak-med-median` | [Fylles ut] | Søk på navnet i fanen «Tidlig opptak» | Utdanningstilbud i `opptak-tidlig-opptak` som tilbyr tidlig opptak, uten poenggrense, med median fra forrige opptak | – |
| `utdanningstilbud-tidlig-opptak-uten-median` | [Fylles ut] | Søk på navnet i fanen «Tidlig opptak» | Utdanningstilbud i `opptak-tidlig-opptak` som tilbyr tidlig opptak, uten poenggrense og uten median fra forrige opptak | – |
| `utdanningstilbud-tidlig-opptak` | «Automasjon, ingeniør - bachelor (ordinær, y-vei)» (UiT) | Søk på navnet i fanen «Tidlig opptak» | Utdanningstilbud i `opptak-tidlig-opptak` som tilbyr tidlig opptak, ved organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak` og `opptak-tilbyder-behandlende` | 2026-11-05 |
| `utdanningstilbud-tidlig-opptak-andre` | «Elektronisk systemingeniør - bachelor i ingeniørfag» (NTNU) | Søk på navnet i fanen «Tidlig opptak» | Et annet utdanningstilbud i `opptak-tidlig-opptak` som tilbyr tidlig opptak. Søkerne har det som prioritet 2, etter `utdanningstilbud-tidlig-opptak` | 2026-11-05 |
| `utdanningstilbud-uten-tidlig-opptak` | [Fylles ut: det tredje studiet i opptaket fra den eksterne testen av tidlig opptak] | Søk på navnet i fanen «Tidlig opptak» | Utdanningstilbud i `opptak-tidlig-opptak` som ikke tilbyr tidlig opptak («Ikke tidlig opptak her») | – |
| `tilbudsgarantitype-tilbyder-tidligopptakstilbud` | [Fylles ut: trolig «Tilbudsgaranti, forhåndsløfte»] | Velges i «Tilbudsgaranti fra tilbyder» | Tilbudsgarantitype for tidlig opptak som gir tilbud, og kan brukes av tilbyder (tidligopptakstilbud) | – |
| `tilbudsgarantitype-forvalter-gir-tilbud` | [Fylles ut] | Velges i «Tilbudsgaranti fra forvalter» | Tilbudsgarantitype som gir tilbud, kan brukes av opptaksforvalter, og ikke er for tidlig opptak eller reservert studieplass | – |
| `tilbudsgarantitype-forvalter-gir-ikke-tilbud` | [Fylles ut] | Velges i «Tilbudsgaranti fra forvalter» | Tilbudsgarantitype som ikke gir tilbud, og kan brukes av opptaksforvalter | – |
| `tilbudsgarantitype-reservert-studieplass` | [Fylles ut: RSO eller RES] | Velges i «Tilbudsgaranti fra behandler» og «Tilbudsgaranti fra forvalter» | Tilbudsgarantitype for reservert studieplass, som kan brukes av behandler og opptaksforvalter | – |
| `opptak-tidlig-opptak-uten-tilbudsgarantitype` | [Fylles ut] | Søk på navnet i «Opptak» | Opptak med tidlig opptak slått på, minst ett utdanningstilbud som tilbyr tidlig opptak, og ingen aktiv tilbudsgarantitype for tidlig opptak som gir tilbud og kan brukes av opptaksforvalteren. Forvaltes av organisasjonen til `opptak-forvalter-forvaltende` | – |
| `opptak-tidlig-opptak-to-tilbudsgarantityper` | [Fylles ut] | Søk på navnet i «Opptak» | Som `opptak-tidlig-opptak-uten-tilbudsgarantitype`, men med to aktive tilbudsgarantityper for tidlig opptak som gir tilbud og kan brukes av opptaksforvalteren | – |
| `sak-tidlig-opptak-kvalifisert` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. `utdanningstilbud-tidlig-opptak` er prioritet 1 og `utdanningstilbud-tidlig-opptak-andre` prioritet 2. Søkeren er kvalifisert, og har en poengsum over 5 til begge. Trenger mange søkere per kjøring (de fleste scenarioene) | – |
| `sak-tidlig-opptak-ikke-kvalifisert` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Søkeren er ikke kvalifisert til `utdanningstilbud-tidlig-opptak` (alle grunnlagene vurdert til nei), og har en poengsum | – |
| `sak-tidlig-opptak-kvalifisering-ikke-vurdert` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Kvalifiseringen til `utdanningstilbud-tidlig-opptak` er ikke vurdert, og søkeren har en poengsum | – |
| `sak-tidlig-opptak-grunnlag-kvalifisert-og-ikke-kvalifisert` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. To grunnlag til `utdanningstilbud-tidlig-opptak`: ett kvalifisert og ett ikke kvalifisert, og en poengsum | – |
| `sak-tidlig-opptak-grunnlag-ikke-vurdert-og-ikke-kvalifisert` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. To grunnlag til `utdanningstilbud-tidlig-opptak`: ett ikke vurdert og ett ikke kvalifisert, og en poengsum | – |
| `sak-tidlig-opptak-to-kvoter` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Kvalifisert til `utdanningstilbud-tidlig-opptak`, med ulik poengsum i to kvoter søkeren skal kvoteplasseres i | – |
| `sak-tidlig-opptak-poeng-i-kvote-uten-kvoteplassering` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Kvalifisert til `utdanningstilbud-tidlig-opptak`, med en høyere poengsum i en kvote søkeren ikke skal kvoteplasseres i enn i kvotene søkeren skal kvoteplasseres i | – |
| `sak-tidlig-opptak-uten-poengsum` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Kvalifisert til `utdanningstilbud-tidlig-opptak`, men uten poengsum i garantikvoten (søknaden kan ikke poengberegnes) | – |
| `sak-tidlig-opptak-prioritet-1-uten-tidlig-opptak` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. `utdanningstilbud-uten-tidlig-opptak` er prioritet 1 og `utdanningstilbud-tidlig-opptak` prioritet 2. Kvalifisert til `utdanningstilbud-tidlig-opptak`, med en poengsum | – |
| `sak-uten-soknad-om-tidlig-opptak` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: som `sak-tidlig-opptak-kvalifisert`, men søkeren har ikke søkt om tidlig opptak | – |
| `sak-tidlig-opptak-median-over` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Kvalifisert til `utdanningstilbud-tidlig-opptak-med-median`, med en poengsum minst 2 over medianen fra forrige opptak | – |
| `sak-tidlig-opptak-median-lik` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Kvalifisert til `utdanningstilbud-tidlig-opptak-med-median`, med en poengsum lik medianen fra forrige opptak | – |
| `sak-tidlig-opptak-median-under` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Kvalifisert til `utdanningstilbud-tidlig-opptak-med-median`, med en poengsum minst 2 under medianen fra forrige opptak | – |
| `sak-tidlig-opptak-uten-median` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: hvert scenario tar en søker som ikke er brukt i en tidligere kjøring, og skriver den i resultatet. Søknad om tidlig opptak i `opptak-tidlig-opptak`, saken behandles av organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak`, er ikke ferdig behandlet og har ingen konklusjon. Kvalifisert til `utdanningstilbud-tidlig-opptak-uten-median`, med en poengsum | – |
| `sak-tidlig-opptak-to-saker` | [Fylles ut: søkerne] | Søk på søkerens navn i «Søknadsbehandling» i `opptak-tidlig-opptak` | Lista med søkere: søknad om tidlig opptak i `opptak-tidlig-opptak`, med to saker hos organisasjonen til `opptak-saksbehandler-behandlende-tidlig-opptak` (ett utdanningstilbud i hver), begge ikke ferdig behandlet og uten konklusjon | – |
| `opptak-vitnemalsbehandling` | Opptaket `T3BwdGFrOjYy` (opptak 62) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjYy | Opptak med saker der søkerne har elektroniske vitnemål fra KREG. [Fylles ut: navnet på opptaket og organisasjonen som behandler sakene] | 2026-11-05 |
| `sak-to-elektroniske-vitnemal` | Sak 1004255-1 i `opptak-vitnemalsbehandling` | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har to elektroniske vitnemål (ett førstegangsvitnemål) | 2026-11-05 |
| `sak-uten-elektroniske-vitnemal` | Sak 1004221-1 i `opptak-vitnemalsbehandling` | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har ingen elektroniske vitnemål | 2026-11-05 |
| `sak-vitnemal-uten-poeng` | [Fylles ut] | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har et elektronisk vitnemål som poengberegningen ikke kan gi karakter-, realfags- eller språkpoeng for (f.eks. et kompetansebevis eller et vitnemål med ugyldige karakterer) | – |
| `sak-annullert-vitnemal-brukt` | **Finnes ikke** | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har et annullert vitnemål som er grunnlaget for et poeng på saken i opptaket | 2026-11-05 |
| `sak-annullert-vitnemal-ikke-brukt` | Sak 1004220-1 i `opptak-vitnemalsbehandling` (ikke bekreftet at vitnemålet er annullert) | Søk på søknadskoden i «Søknadsbehandling» | Søkeren har et annullert vitnemål som ikke er brukt i en beregning på opptaket | – |
