# Testcaser og testdata – Saksbehandling av tidlig opptak

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786
- **Confluence**: –
- **Laget**: 2026-11-04 av fs-testplan

---

Testcasene som skal lages, testbrukerne og testdataene for «Saksbehandling av tidlig opptak». Siden synkes med testene i `cdp-tester/` og miljøfila (*Synk med testene og miljøfila* i `fs-testplan`). Testplanen: [Testplan – Saksbehandling av tidlig opptak](testplan.md).

## Testcaser som skal lages

Omfanget av testcasene, ikke testcasene selv. `fs-testcaser-cdp` lager testcasene for fase 2 ut fra tabellen, og `fs-testcaser-intern` testcasene for fase 3. Teamet og testansvarlig går gjennom omfanget før testcasene lages.

### Fase 2: agentisk funksjonstest

Bare `@OPT-BEH-BEH-007`. `@OPT-BEH-BEH-009` og `@OPT-BEH-BEH-013` ble testet internt 2026-10-30, før den agentiske testen ble en del av flyten.

I opptak 34 prøvekjøres tidligopptaket bare, og prøvekjøringen viser fem tall, ikke utfallet per søker. Scenarioene der utfallet for én søker skal sjekkes, lages som tester, men blir trolig «Ikke testet» i fase 2, og går videre til fase 3 (se under).

| Krav | Regel | Scenarioer | Utledede testcaser | Teknikk |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Opptaksforvalter gjennomfører tidligopptaket | 17 (scenariomaler: 3 + 2 eksempler, til sammen 20 testcaser) | Prøvekjøringen lagrer ingenting: tallene er like ved to prøvekjøringer på rad, og søkeren har ikke fått tilbudsgaranti etterpå. Poenggrense 0 og 999,9 (gyldige), 1000 og -1 (rettes til grensen) og 50,55 (én desimal) | grenseverdianalyse, ekvivalensklasser |
| `@OPT-BEH-BEH-007` | Opptaksforvalter ser utfallet av tidligopptaket | 2 | – («Må behandles» og «Alt behandlet» sjekkes i scenarioet «Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon») | – |
| `@OPT-BEH-BEH-007` | Manuell tilbudsgaranti krever ikke deltakelse i tidligopptaket | 1 | – | – |
| `@OPT-BEH-BEH-007` | Regel i koden uten scenario: poenggrenser som ikke er lagret | – | Endre en poenggrense uten å lagre, og velg «Kjør tidligopptak»: dialogen ber om å lagre, og «Kjør tidligopptak» i dialogen er ikke tilgjengelig. Lagre, og velg «Kjør tidligopptak» igjen: prøvekjøringen starter | tilstandsoverganger |
| `@OPT-BEH-BEH-007` | Regel i koden uten scenario: poenggrensen bare på tilbud som tilbyr tidlig opptak | – | Et tilbud uten tidlig opptak viser «Ikke tidlig opptak her» og har ikke noe felt | ekvivalensklasser |
| `@OPT-BEH-BEH-007` | Regel i koden uten scenario: fristen og kolonnene i lista | – | Fristen for poenggrensene vises over lista, og kolonnene «T.O. søkere totalt» og «T.O. søkere 1. pri.» vises | – |

Laget med `fs-testcaser-cdp` 2026-11-05: 20 scenarioer fra kravet og 5 `@utledet` (til sammen 29 testcaser med eksemplene i scenariomalene). Avvik fra planen 2026-11-04: blank poenggrense er ikke med (feltet tømmer poenggrensen, og det er ikke en feil), og «Må behandles»/«Alt behandlet» er en del av scenarioet fra kravet, ikke en egen testcase.

Testcasene står i [`cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`](../../cdp-tester/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/), og oppsettet i [`cdp-tester/_Oppsett/02 Opptak/13 Søknad og saksbehandling/02 Behandling/oppsett.feature`](../../cdp-tester/_Oppsett/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/oppsett.feature). Utledede testcaser lages bare der regelen har verdier eller betingelser å teste.

### Fase 3: intern akseptansetest

| Flyt eller oppgave | Krav | Scenarioer i flyten | Avhengigheter som sjekkes | Regresjon |
|---|---|---|---|---|
| Oppgave uten flyt: Finne og vurdere søknader om tidlig opptak | `@OPT-BEH-BEH-009`, `@OPT-BEH-BEH-013` | 8 | – | nei. Testet 2026-10-30 ([testcaser-intern.md](testcaser-intern.md)) |
| Oppgave uten flyt: Gjennomføre tidligopptaket | `@OPT-BEH-BEH-007`, `@OPT-BEH-BEH-013` | 20 i 007, og «Endre konklusjonen etter at tidligopptaket er gjennomført» i 013 når et opptak kan gjennomføres | Konklusjonen (013), poengberegningen, kvalifiseringen, poenggrensen, kodeverket for tilbudsgarantityper, manuell tilbudsgaranti (010) | nei |

Krav som ikke er med i noen flyt: 3. De testes som oppgaver uten flyt. En flyt for tidlig opptak bør lages (se *Vurdering per krav*).

I tillegg til flytene har den interne testen tre deler (*Fase 3* i `akseptansetest/README.md`). Omfanget avgjøres når testcasene lages, etter kjøringen i fase 2:

| Del | Omfang | Hvem velger |
|---|---|---|
| Det den agentiske testen ikke klarte | Testcasene fra fase 2 som blir «Ikke testet». Kjent på forhånd: utfallet per søker (hvem som får tilbudsgaranti, og på hvilket søknadsalternativ) kan ikke ses i prøvekjøringen, og søkere med søknader i bestemte tilstander (poengsum, kvalifisering, reservert studieplass, tidligopptakstilbud fra tilbyder) kan ikke lages av testene. Det gjelder de fleste av de 17 scenarioene i regelen «Opptaksforvalter gjennomfører tidligopptaket». «Tidligopptaket stopper uten én tilbudsgarantitype» krever et opptak med feil i kodeverket | Kjøringen i fase 2 |
| Opplevelse og helhet | Fanen «Tidlig opptak» under «Plasstildeling»: hjelpeteksten (om median og blank poenggrense), dialogen «Kjøre tidligopptak?», tallene og ordene i den («Har søkt tidlig opptak», «Har saker som ikke er behandlet», «Totale tilbudsgarantier») | Testansvarlig |
| Høyest risiko | Usikre scenarioer i verifiseringen («Prøvekjøre tidligopptaket», «Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum»). En ekte gjennomføring publiserer svaret til søkerne. Hjelpeteksten om median. Kvotevarselet vises ikke | Testansvarlig, etter en risikovurdering |

## Testbrukere

Fra [test.md](../../cdp-tester/_Miljøer/test.md), personaene sjekket 2026-11-04 mot `testpersoner`. Velgeren har én rad per tildeling (person, rolle og organisasjon), og hver rad gir bare den ene rollen og rollene den gir i rollekatalogen. Testbrukerne 1 og 2 er fra versjonen 2026-10-27, og har ikke nøkkel i miljøfila ennå. Testbruker 3 er `opptak-forvalter-forvaltende` i miljøfila. Testbruker 4 er ny.

| Nr | Nøkkel | Navn | Rolle | Organisasjon | Innlogging | Start-URL | Brukes til |
|---|---|---|---|---|---|---|---|
| 1 | `opptak-saksbehandler` | RU BRØDSKIVE | Saksbehandler (`OPPTAK_SAKSBEHANDLER`) | HVL | RU BRØDSKIVE • OPPTAK_SAKSBEHANDLER (HVL) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0 | Alle scenarioene i `@OPT-BEH-BEH-009` og `@OPT-BEH-BEH-013` |
| 2 | `opptak-saksbehandler-annen-organisasjon` | KORT DOMPAP | Saksbehandler (`OPPTAK_SAKSBEHANDLER`) | UIT | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0 | `@OPT-BEH-BEH-013` «Konklusjon per organisasjon» |
| 3 | `opptak-forvalter-forvaltende` | ORDENTLIG RUNDSKRIV | Opptaksforvalter (`OPPTAK_FORVALTER`) | HK-DIR | ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0/plasstildeling/tidlig-opptak | `@OPT-BEH-BEH-007`, reglene «Opptaksforvalter gjennomfører tidligopptaket» og «Opptaksforvalter ser utfallet av tidligopptaket» |
| 4 | `opptak-tilbyder` | [Fylles ut: forslag RU BRØDSKIVE] | Tilbyder (`FS_ADMIN_OPPTAK_TILBGARANTI_GI_VIA_UTDTILBUD` ved organisasjonen som tilbyr utdanningstilbudet) | [Fylles ut: forslag HVL] | [Fylles ut: forslag RU BRØDSKIVE • OPPTAK_FORVALTER (HVL)] | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0 | `@OPT-BEH-BEH-007` «Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket» |

Testbrukerne finnes i rollene scenarioene nevner, ved organisasjonene kravet gjelder. Antallet bestemmes per krav ut fra tilgangsmatrisen. Det lages ikke egne testcaser for roller og tilgang i fase 2: `fs-verify` har verifisert i koden at de er laget slik kravet sier (fase 1). Scenarioene i kravet, også om synlighet, testes som de står.

Nøkkelen er rollen og relasjonen scenarioet trenger, aldri organisasjonen eller personen, og endres ikke om testbrukeren eller organisasjonen byttes. Er testplanen og miljøfila uenige, gjelder miljøfila. Aldri passord i testplanen. Se [`roller-og-testdata.md`](../../.claude/references/akseptansetest/roller-og-testdata.md).

Ikke bekreftet: at `OPPTAK_FORVALTER` gir testbruker 3 `OPPTAK_TILBGARANTI_GI_VIA_OPPTAK`, `SE_SØKNADSBEHANDLING`, `MODIFISERE_OPPTAK` og `SE_OPPTAK` ved HK-DIR gjennom rollekatalogen (fs-admin skjuler «Kjør tidligopptak» uten alle fire, `KjorTidligopptakButton.tsx:49-54`, og backend krever `SE_SØKNADSBEHANDLING` og `MODIFISERE_OPPTAK`). Raden gir ikke lenger `OPPTAK_SAKSBEHANDLER` i tillegg. Ikke bekreftet heller: at HK-DIR forvalter opptak 34. Testbruker 4: [Fylles ut: bekreft at personaen har `OPPTAK_TILBGARANTI_GI_VIA_UTDTILBUD` ved organisasjonen som tilbyr utdanningstilbudet].

### Tilgangsmatrise

Fra tilgangsradene i verify-rapportene. Rapportene for 009 og 013 fra 2026-10-26 har ikke tilgangsrader. Radene for dem er fra testplanen 2026-10-27.

| Krav | Rolle | Egen organisasjon | Annen organisasjon | Testbruker (Nr) |
|---|---|---|---|---|
| `@OPT-BEH-BEH-009` | Saksbehandler | ser sakene organisasjonen behandler | ingen tilgang | 1 |
| `@OPT-BEH-BEH-013` | Saksbehandler | endrer konklusjonen i sakene organisasjonen behandler | ingen tilgang (konklusjon per organisasjon) | 1, 2 |
| `@OPT-BEH-BEH-007` | Opptaksforvalter | prøvekjører og gjennomfører tidligopptaket i opptaket organisasjonen forvalter | ingen tilgang (knappen skjules, og backend avviser) | 3 |
| `@OPT-BEH-BEH-007` | Opptakseier eller tilbyder i samordna opptak | endrer poenggrensen (opptakseier alltid, tilbyder når redigeringsfasen er åpen) | ingen tilgang | 3 |
| `@OPT-BEH-BEH-007` | Tilbyder | endrer manuell tilbudsgaranti på søknadsalternativet | ingen tilgang | 4 |

## Testdata

Testdataene testene trenger, med nøkkel. Data i testmiljøet kan slettes eller nullstilles når som helst, så testene lager dataene sine selv: oppsettet lager dem gjennom løsningen i hver kjøring, med kjøringen i navnet. Bare grunndata og data testene ikke kan lage, må finnes i miljøet før testen, og navnet og `Søk/URL` for dem kopieres fra miljøfila. Testdata er syntetiske.

For tidlig opptak kan oppsettet ikke lage søkere med søknader og saker i FS Admin. Testdataene for 009 og 013 er søkerne i opptak 34 fra 2026-10-27. Testdataene for 007 er det samme opptaket, og må stå i miljøfila (legges inn av `fs-testcaser-cdp` når brukeren sier ja).

| Hva | Nøkkel | Navn | Hvor | Søk/URL | Utgangstilstand | Brukes av |
|---|---|---|---|---|---|---|
| Opptak med tidlig opptak, med begrunnelser (med dokumentasjonskrav) og konklusjoner for tidlig opptak («Kan få tidligopptak, har godkjent grunn.» (KFF) og «Ikke dokumentert behov for tidligopptak» (AFH)) | `opptak-tidlig-opptak-med-sokere` | Opptak 34, «Samordna UHG-simulering høsten 2026» | TEST | https://test-fsadmin.sikt.no/opptak/T3BwdGFrOjM0 | Tidlig opptak er slått på. Opptaket endres ikke av 009/013. For 007: [Fylles ut: nøyaktig én aktiv tilbudsgarantitype i kategorien for tidlig opptak som gir tilbud og kan brukes av forvalter]. Bare prøvekjøring: tidligopptaket gjennomføres ikke i opptaket, fordi det publiserer svaret til søkerne | `@OPT-BEH-BEH-009`, `@OPT-BEH-BEH-013`, `@OPT-BEH-BEH-007` |
| Samordna opptak med tidlig opptak, med ett utdanningstilbud som tilbyr tidlig opptak (poenggrense 50) og ett som ikke gjør det | `opptak-samordna-tidlig-opptak` | Lages av oppsettet | – | – | Frist for å sette poenggrenser {DATO:+75} 23:59 | `@OPT-BEH-BEH-007`, de utledede testcasene om poenggrensen, fristen og utdanningstilbud uten tidlig opptak |
| Utdanningstilbud ved organisasjonen til `opptak-forvalter-deltakende`, som kan legges til i et samordna opptak | `utdanningstilbud-deltakende` | [Fylles ut] (står i miljøfila) | Utdanningsregisteret | Velges i «Legg til utdanningstilbud» | Brukes av oppsettet, og får tidlig opptak der | Oppsettet |
| Et annet utdanningstilbud ved samme organisasjon | `utdanningstilbud-deltakende-uten-tidlig-opptak` | [Fylles ut] | Utdanningsregisteret | Velges i «Legg til utdanningstilbud» | Brukes av oppsettet, uten tidlig opptak | Oppsettet |
| Søker A: har søkt om tidlig opptak, uten konklusjon | `soker-tidlig-opptak-uten-konklusjon` | Utgått Breiflabb, søknad 1000902 | [Søknaden i Min kompetanse](https://test.minkompetanse.no/nb/soknader/c29rbmFkOjdlZDAwMjljLTQ5YzctNDgwZS1hNjJhLWZlNDRjYjg2ZWVkNCwzNA) | Søk på søknadsnummeret i sakslisten | Har søkt, uten konklusjon. Telles i «Har saker som ikke er behandlet» | `@OPT-BEH-BEH-013`, `@OPT-BEH-BEH-007` «Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon» |
| Søker B: har søkt om tidlig opptak, uten konklusjon | `soker-tidlig-opptak-uten-konklusjon-2` | Optimistisk Hest, søknad 1001008 | [Søknaden i Min kompetanse](https://test.minkompetanse.no/nb/soknader/c29rbmFkOmFmMmQ0YmMwLWNlMTktNDY4Ni1hMDA3LWU1ZWUwZDA2ODQzNCwzNA) | Som over | Endres ikke | `@OPT-BEH-BEH-009` |
| Søker C: har ikke søkt om tidlig opptak | `soker-uten-tidlig-opptak` | Dedikert Jerv, søknad 1001012 | [Søknaden i Min kompetanse](https://test.minkompetanse.no/nb/soknader/c29rbmFkOmIwYzA4YWJlLTVkZjktNGFjNS1iY2EzLTRmMDM3YmVlZTA0ZCwzNA) | Som over | Endres ikke | `@OPT-BEH-BEH-009`, `@OPT-BEH-BEH-013` |
| Søker D: har søkt om tidlig opptak, med én sak hos HVL og én hos UiT | `soker-tidlig-opptak-to-saker` | Smart klippfisk, søknad 1000748 | [Søknaden i Min kompetanse](https://test.minkompetanse.no/nb/soknader/c29rbmFkOjI5NTNlZGEyLTU4MTUtNDEwNy1hN2ZhLWUwNjY1MGEwOTliMSwzNA) | Som over | Uten konklusjon i begge sakene | `@OPT-BEH-BEH-013` «Konklusjon per organisasjon» |
| Søker som deltar og når poenggrensen | `soker-tidlig-opptak-oppfyller-kravene` | [Fylles ut] | Opptak 34 | Søk på søknadsnummeret | Har søkt, saken er behandlet med konklusjon der søkeren deltar, kvalifisert, poengsum over grensen på det høyest prioriterte søknadsalternativet. Telles i «Totale tilbudsgarantier» i prøvekjøringen | `@OPT-BEH-BEH-007` «Tilbudsgaranti ut fra poenggrensen», «En ny gjennomføring fjerner ikke tilbudsgarantien», og de to om tilbudsgaranti fra opptaksforvalter som blir erstattet |
| Søkere i de andre tilstandene scenarioene trenger | `soker-tidlig-opptak-deltar-ikke`, `soker-tidlig-opptak-ikke-kvalifisert`, `soker-tidlig-opptak-to-alternativer`, `soker-tidlig-opptak-sak-ikke-behandlet`, `soker-tidlig-opptak-reservert-under-grensen`, `soker-tidlig-opptak-reservert-ikke-kvalifisert`, `soker-tidlig-opptak-poeng-flere-kvoter`, `soker-tidlig-opptak-annen-garanti-hoyere-prioritet`, `soker-tidlig-opptak-behandlet-etter-gjennomforing` | [Fylles ut] | Opptak 34 | Søk på søknadsnummeret | Se «Krever» i `cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/README.md` og stegene i testene. Kan ikke lages av testene. Uten dem blir scenarioene «Ikke testet» | `@OPT-BEH-BEH-007` |
| Kodeverk i opptaket: tilbudsgarantitypene og konklusjonen der søkeren deltar | `tilbudsgarantitype-tidlig-opptak`, `tilbudsgarantitype-gir-ikke-tilbud`, `tilbudsgarantitype-gir-tilbud-ikke-tidlig-opptak`, `tilbudsgarantitype-tidligopptakstilbud-tilbyder`, `konklusjon-deltar` | [Fylles ut]. `konklusjon-deltar`: «Kan få tidligopptak, har godkjent grunn.» (KFF) | Opptak 34 | Velges i saken | Typen i kategorien for tidlig opptak som gjennomføringen setter, en som ikke gir tilbud, en som gir tilbud utenfor tidlig opptak, og tidligopptakstilbudet tilbyder setter | `@OPT-BEH-BEH-007` |
| Opptak der tilbudsgarantitypen for tidlig opptak mangler eller er tvetydig | `opptak-tidlig-opptak-uten-tilbudsgarantitype` | [Fylles ut] | – | – | Ikke nøyaktig én aktiv type i kategorien for tidlig opptak som gir tilbud | `@OPT-BEH-BEH-007` «Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak» |

#### Slik lager du en søker med to saker

Hvordan en søknad deles i saker, avhenger av reglene for saksbehandlertildeling i opptaket. Det enkleste og mest forutsigbare er å bruke en søker med utdanningsbakgrunn «Realkompetanse» (REA). Da blir søknadsalternativene alltid fordelt til den tilbydende organisasjonen. Søkeren må ha minst ett studieønske hos hver av de to organisasjonene. I opptak 34 kan det for eksempel være Byggingeniør (HVL, Bergen) og Paramedisin (UiT, Tromsø).
