# Testmiljø: TEST

Nøklene i testene i `cdp-tester/`, slått opp for TEST. Fila er det eneste stedet verdiene slås opp når testene kjøres, og den sier hvilke testpersoner og roller som finnes i FS Admin i TEST. Konvensjonene og vedlikeholdet står i [`cdp-tester/README.md`](../README.md) (*Miljøfila*).

- **FS Admin**: https://test-fsadmin.sikt.no
- **Innlogging**: testansvarlig logger inn selv, i en egen Chrome-profil til testingen. Testbrukeren byttes i «Overstyrt bruker» øverst til høyre i FS Admin
- **Kan settes tilbake**: nei, og data i TEST kan slettes eller nullstilles når som helst. Testene lager dataene sine selv, i oppsettet i [`../_Oppsett/`](../_Oppsett/), i hver kjøring. Opptak kan ikke slettes: opptakene testene og oppsettet oppretter, blir liggende, og har kjøringen i navnet (`{KJØRING}`)
- **Personaer sist sjekket**: 2026-10-28, mot `TEST_PERSONAS` i fs-admin (`origin/main` `cc62931b7`). Tildelingene er bekreftet med `testpersoner` for personaene som har dato i «Bekreftet»

## Feature-flagg

| Flagg | Står | Sjekket |
|---|---|---|
| `opptak-opprett-samordna` | på | 2026-10-27 |
| `opptak-filter-organisasjon` | [Fylles ut: på eller av] | – |

## Personaer

Alle personaene i «Overstyrt bruker» i TEST: `TEST_PERSONAS` i fs-admin (`src/common/lib/persona/constants/testPersonas.ts`). Raden er skrevet nøyaktig som i menyen. «Deklarerte roller» er forretningsrollene personaen ber om. «Tildelinger i TEST» er det `testpersoner` gir, etter utvidelsen i rollekatalogen. Organisasjonen og forkortelsen er de i organisasjonsregisteret når personaen er bekreftet, og det er dem testene bruker (`{ORG:<nøkkel>}`). `–` er ikke bekreftet ennå.

| Rad i «Overstyrt bruker» | Deklarerte roller | Organisasjon | Organisasjonskode | Forkortelse | Tildelinger i TEST | Bekreftet |
|---|---|---|---|---|---|---|
| ANSVARSFULL FOTKREM • BRUKERADMINISTRATOR (Sikt testhøyskole) | `BRUKERADMINISTRATOR` | Sikt testhøyskole | 7777 | – | – | – |
| MUNTER TRIKK • APPLIKASJONSADMINISTRATOR (Sikt testhøyskole) | `APPLIKASJONSADMINISTRATOR` | Sikt testhøyskole | 7777 | – | – | – |
| ANSVARSFULL FOTKREM • OPPTAK_FORVALTER (NTNU) | `OPPTAK_FORVALTER` | Norges teknisk-naturvitenskapelige universitet | 194 | NTNU | `OPPTAK_FORVALTER`, `OPPTAKSFORVALTER`, `OPPTAK_SAKSBEHANDLER`, `OPPTAKSØKNADSBEHANDLER` | 2026-10-28 |
| ANSVARSFULL FOTKREM • OPPTAK_SAKSBEHANDLER (NTNU) | `OPPTAK_SAKSBEHANDLER` | Norges teknisk-naturvitenskapelige universitet | 194 | – | – | – |
| KORT DOMPAP • OPPTAK_FORVALTER (UiO) | `OPPTAK_FORVALTER` | Universitetet i Oslo | 185 | – | – | – |
| KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UiO) | `OPPTAK_SAKSBEHANDLER` | Universitetet i Oslo | 185 | – | – | – |
| KORT DOMPAP • OPPTAK_FORVALTER_OG_UTDANNINGSADMINISTRATOR (UiO) | `OPPTAK_FORVALTER`, `UTDANNINGSREGISTERET_ADMINISTRATOR` | Universitetet i Oslo | 185 | – | – | – |
| KORT DOMPAP • OPPTAK_FORVALTER (UiT) | `OPPTAK_FORVALTER` | Universitetet i Tromsø | 186 | – | – | – |
| KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UiT) | `OPPTAK_SAKSBEHANDLER` | Universitetet i Tromsø | 186 | – | – | – |
| KORT DOMPAP • OPPTAK_FORVALTER_OG_UTDANNINGSADMINISTRATOR (UiT) | `OPPTAK_FORVALTER`, `UTDANNINGSREGISTERET_ADMINISTRATOR` | Universitetet i Tromsø | 186 | – | – | – |
| KORT DOMPAP • OPPTAK_FORVALTER, flere organisasjoner (UiO) | `OPPTAK_FORVALTER` (185); `OPPTAK_FORVALTER` (194) | Universitetet i Oslo | 185 | – | – | – |
| KORT DOMPAP • OPPTAK_SAKSBEHANDLER, flere organisasjoner (UiO) | `OPPTAK_SAKSBEHANDLER` (185); `OPPTAK_SAKSBEHANDLER` (194) | Universitetet i Oslo | 185 | – | – | – |
| RU BRØDSKIVE • OPPTAK_FORVALTER (HVL) | `OPPTAK_FORVALTER` | Høgskulen på Vestlandet | 203 | HVL | `OPPTAK_FORVALTER`, `OPPTAKSFORVALTER`, `OPPTAK_SAKSBEHANDLER`, `OPPTAKSØKNADSBEHANDLER` | 2026-10-28 |
| RU BRØDSKIVE • OPPTAK_SAKSBEHANDLER (HVL) | `OPPTAK_SAKSBEHANDLER` | Høgskulen på Vestlandet | 203 | – | – | – |
| TALEFØR ELV • OPPTAK_FORVALTER (Fagskolen Vestfold og Telemark) | `OPPTAK_FORVALTER` | Fagskolen i Vestfold og Telemark | 20418 | FVT | `OPPTAK_FORVALTER`, `OPPTAKSFORVALTER`, `OPPTAK_SAKSBEHANDLER`, `OPPTAKSØKNADSBEHANDLER` | 2026-10-28 |
| TALEFØR ELV • OPPTAK_SAKSBEHANDLER (Fagskolen Vestfold og Telemark) | `OPPTAK_SAKSBEHANDLER` | Fagskolen Vestfold og Telemark | 20418 | – | – | – |
| GLAD LAKS • OPPTAK_FORVALTER (NMBU) | `OPPTAK_FORVALTER` | Norges miljø- og biovitenskapelige universitet | 192 | – | – | – |
| MODIG SYLTETØY • OPPTAK_SAKSBEHANDLER (NMBU) | `OPPTAK_SAKSBEHANDLER` | Norges miljø- og biovitenskapelige universitet | 192 | – | – | – |
| RASK PARAPLY • OPPTAK_FORVALTER (PHS) | `OPPTAK_FORVALTER` | Politihøgskolen | 233 | – | – | – |
| STILLE FJELL • OPPTAK_SAKSBEHANDLER (PHS) | `OPPTAK_SAKSBEHANDLER` | Politihøgskolen | 233 | – | – | – |
| VENNLIG SKOG • OPPTAK_FORVALTER (HiØ) | `OPPTAK_FORVALTER` | Høgskolen i Østfold | 224 | – | – | – |
| TRAVEL KAFFE • OPPTAK_SAKSBEHANDLER (HiØ) | `OPPTAK_SAKSBEHANDLER` | Høgskolen i Østfold | 224 | – | – | – |
| KREATIV PENSEL • OPPTAK_FORVALTER (Einar Granum Kunstfagskole) | `OPPTAK_FORVALTER` | Einar Granum Kunstfagskole | 20402 | – | – | – |
| LYSTIG STAFFELI • OPPTAK_SAKSBEHANDLER (Einar Granum Kunstfagskole) | `OPPTAK_SAKSBEHANDLER` | Einar Granum Kunstfagskole | 20402 | – | – | – |
| NORDLIG VINTER • OPPTAK_FORVALTER (Fagskolen i Nord) | `OPPTAK_FORVALTER` | Fagskolen i Nord | 20733 | – | – | – |
| IVRIG SNØFONN • OPPTAK_SAKSBEHANDLER (Fagskolen i Nord) | `OPPTAK_SAKSBEHANDLER` | Fagskolen i Nord | 20733 | – | – | – |
| TRYGG BRYGGE • OPPTAK_FORVALTER (Fagskolen Oslo) | `OPPTAK_FORVALTER` | Fagskolen Oslo | 1647 | – | – | – |
| BLID SPORVOGN • OPPTAK_SAKSBEHANDLER (Fagskolen Oslo) | `OPPTAK_SAKSBEHANDLER` | Fagskolen Oslo | 1647 | – | – | – |
| SINDIG BOREPLATTFORM • OPPTAK_FORVALTER (Fagskolen Rogaland) | `OPPTAK_FORVALTER` | Fagskolen Rogaland | 20392 | – | – | – |
| FRISK HAVBRIS • OPPTAK_SAKSBEHANDLER (Fagskolen Rogaland) | `OPPTAK_SAKSBEHANDLER` | Fagskolen Rogaland | 20392 | – | – | – |
| RUNDT TØMMER • OPPTAK_FORVALTER (Fagskolen Innlandet) | `OPPTAK_FORVALTER` | Fagskolen Innlandet | 1646 | – | – | – |
| GLIMRENDE ELG • OPPTAK_SAKSBEHANDLER (Fagskolen Innlandet) | `OPPTAK_SAKSBEHANDLER` | Fagskolen Innlandet | 1646 | – | – | – |
| PRESIS SKINNE • OPPTAK_FORVALTER (Norsk fagskole for lokomotivførere) | `OPPTAK_FORVALTER` | Norsk fagskole for lokomotivførere | 20389 | – | – | – |
| ROLIG PERRONG • OPPTAK_SAKSBEHANDLER (Norsk fagskole for lokomotivførere) | `OPPTAK_SAKSBEHANDLER` | Norsk fagskole for lokomotivførere | 20389 | – | – | – |
| KJAPP LAKSEMERD • OPPTAK_FORVALTER (Trøndelag høyere yrkesfagskole) | `OPPTAK_FORVALTER` | Trøndelag høyere yrkesfagskole | 21177 | – | – | – |
| MILD FJORD • OPPTAK_SAKSBEHANDLER (Trøndelag høyere yrkesfagskole) | `OPPTAK_SAKSBEHANDLER` | Trøndelag høyere yrkesfagskole | 21177 | – | – | – |
| ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER_OG_OPPTAK_SAKSBEHANDLER (HK-dir) | `OPPTAK_FORVALTER`, `OPPTAK_SAKSBEHANDLER` | Direktoratet for høyere utdanning og kompetanse | 20827 | HK-DIR | `OPPTAK_FORVALTER`, `OPPTAKSFORVALTER`, `OPPTAK_SAKSBEHANDLER`, `OPPTAKSØKNADSBEHANDLER` | 2026-10-28 |
| SPRELSK KOMPASS • OPPTAK_SAKSBEHANDLER (Fagskolen Vestfold og Telemark) | `OPPTAK_SAKSBEHANDLER` | Fagskolen Vestfold og Telemark | 20418 | – | – | – |
| MUNTER TRIKK • OPPTAK_SAKSBEHANDLER (UiO) | `OPPTAK_SAKSBEHANDLER` | Universitetet i Oslo | 185 | – | – | – |
| KLAR NORDLYS • OPPTAK_SAKSBEHANDLER (UiT) | `OPPTAK_SAKSBEHANDLER` | Universitetet i Tromsø | 186 | – | – | – |
| NØYE TANNHJUL • OPPTAK_SAKSBEHANDLER (NTNU) | `OPPTAK_SAKSBEHANDLER` | Norges teknisk-naturvitenskapelige universitet | 194 | – | – | – |
| VÅT REGNJAKKE • OPPTAK_SAKSBEHANDLER (HVL) | `OPPTAK_SAKSBEHANDLER` | Høgskulen på Vestlandet | 203 | – | – | – |
| GRUNDIG PROTOKOLL • OPPTAK_SAKSBEHANDLER (HK-dir) | `OPPTAK_SAKSBEHANDLER` | Direktoratet for høyere utdanning og kompetanse | 20827 | – | – | – |

- `MEDLEM_OPPTAK`, som deltakeren trenger for å legge til utdanningstilbud (fs-plattform, V469), er ikke tildelt direkte. Den må komme fra rollekatalogen (`tilgangsroller`). [Fylles ut: bekreft at `OPPTAK_FORVALTER` gir `MEDLEM_OPPTAK`]
- Menyen viser forkortelsen fra `TEST_PERSONAS`, som kan skrives annerledes enn i organisasjonsregisteret (HK-dir og HK-DIR).

## Testbrukere

Nøkkelen i testene, hva testen krever av testbrukeren (uavhengig av miljøet), og personaen den er koblet til. Organisasjonen, forkortelsen og organisasjonskoden står på personaen. Byttes personaen, endres bare denne tabellen, ikke testene.

| Nøkkel | Krever | Persona (rad i «Overstyrt bruker») |
|---|---|---|
| `opptak-forvalter-forvaltende` | `OPPTAK_FORVALTER` og `OPPTAK_SAKSBEHANDLER` ved organisasjonen som forvalter samordna opptak | ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER_OG_OPPTAK_SAKSBEHANDLER (HK-dir) |
| `opptak-forvalter-deltakende` | `OPPTAK_FORVALTER` ved et universitet eller en høyskole som er deltaker i `opptak-samordna-med-utdanningstilbud`. Trenger `MEDLEM_OPPTAK` for å legge til utdanningstilbud (fs-plattform, V469). Den er ikke tildelt direkte, og må komme fra rollekatalogen (se under «Personaer») | ANSVARSFULL FOTKREM • OPPTAK_FORVALTER (NTNU) |
| `opptak-forvalter-ikke-deltakende` | `OPPTAK_FORVALTER` ved en organisasjon som ikke er deltaker i testdata-opptakene | TALEFØR ELV • OPPTAK_FORVALTER (Fagskolen Vestfold og Telemark) |
| `opptak-forvalter-lokalt` | `OPPTAK_FORVALTER` ved et lærested med lokalt opptak | RU BRØDSKIVE • OPPTAK_FORVALTER (HVL) |

## Testdata

Bare grunndata og data testene ikke kan lage gjennom løsningen. Testdataene oppsettet lager i hver kjøring, står i oppsettet, ikke her: for opptak [`_Oppsett/02 Opptak/11 Opprette og vedlikeholde opptak/oppsett.feature`](../_Oppsett/02%20Opptak/11%20Opprette%20og%20vedlikeholde%20opptak/oppsett.feature) (`opptak-samordna-uten-utdanningstilbud`, `opptak-samordna-med-utdanningstilbud`, `opptak-samordna-tilbud-med-tidlig-opptak`, `opptak-en-utdanningsbakgrunn` og `opptak-lokalt`, og `opptak-oversikt-flere-typer`, som er de to opptakene `opptak-samordna-uten-utdanningstilbud` og `opptak-lokalt`).

| Nøkkel | Verdi i TEST | Søk/URL | Utgangstilstand | Sjekket |
|---|---|---|---|---|
| `regelverkssamling-samordna` | «UHGTEST2026» | Velges i skjemaet for opptaket | Regelverkssamling som kan velges i et samordna opptak | 2026-10-26 |
| `regelverkssamling-samordna-annen` | [Fylles ut] | Velges i skjemaet for opptaket | En annen regelverkssamling enn `regelverkssamling-samordna`, som kan velges i et samordna opptak | – |
| `regelverkssamling-lokalt` | [Fylles ut] | Velges i skjemaet for opptaket | Regelverkssamling som kan velges i et lokalt opptak ved organisasjonen til `opptak-forvalter-lokalt` | – |
| `utdanningsbakgrunner-godkjente` | «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» | Velges i innstillingene | «Realkompetanse», «Utenlandsk utdanning» og «Steinerskole» står blant de godkjente utdanningsbakgrunnene | 2026-10-27 |
| `poenglikhetsregler` | «Loddnummer, laveste nummer først» (kravet: «Loddtrekning»), «Alder, eldste først» (kravet: «Alder, eldre foran yngre»). «Alle søkere med samme poengsum får tilbud» er ikke sett | Velges i innstillingene | Poenglikhetsreglene i kravet finnes som valg | 2026-10-26 |
| `organisasjoner-utdanningsregisteret` | Læresteder fra utdanningsregisteret, blant dem NTNU (universitet) og Fagskolen i Vestfold og Telemark (fagskole) | Søk i «Inviter» | Aktive læresteder i utdanningsregisteret: minst to av hver type (universitet, høyskole, fagskole), blant dem organisasjonene til `opptak-forvalter-deltakende` og `opptak-forvalter-ikke-deltakende` | 2026-10-27 |
| `utdanningstilbud-deltakende` | [Fylles ut] | Velges i «Legg til utdanningstilbud» | Et utdanningstilbud i utdanningsregisteret ved organisasjonen til `opptak-forvalter-deltakende`, som kan legges til i et samordna opptak. Brukes av oppsettet | – |
| `organisasjon-som-inviteres` | Universitetet i Oslo (UIO, 185) | Søk i «Inviter» | Et aktivt universitet eller en høyskole i utdanningsregisteret, som ikke er deltaker i testdata-opptakene og ikke er organisasjonen til en av testbrukerne | 2026-10-27 |
| `opptak-utdanningsbakgrunn-valgt-av-soker` | [Fylles ut] | Søk på navnet i «Opptak» | Samordna opptak med «Steinerskole» og minst én utdanningsbakgrunn til. En syntetisk søker har en søknad med «Steinerskole». Søknaden er åpen på testdagen | – |
| `opptak-oversikt-over-50` | **Finnes ikke** | «Opptak» | Minst 51 opptak synlige for `opptak-forvalter-forvaltende` | 2026-10-27 |
