# Sammenligning – manuell test og CDP-kjøringer (Opus og Sonnet) – Opprette og vedlikeholde opptak

- **Manuell test**: [testcaser-intern.md](testcaser-intern.md), fra Confluence (side 5126422620), kjørt 2026-10-22
- **Opus**: [testcaser-intern-opus.md](testcaser-intern-opus.md), kjørt 2026-10-26 10:26
- **Sonnet**: [kjoring-2026-10-26-1059-sonnet/resultat.md](kjoring-2026-10-26-1059-sonnet/resultat.md), kjørt 2026-10-26 10:59, fs-admin 0.62.0
- **Kode**: fs-admin og fs-plattform `origin/main`, 2026-10-26
- **Laget**: 2026-10-26, oppdatert med Sonnet samme dag
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5144346655

---

Sammenligning av økt 1 (Del 1–2, 27 testcaser) i den interne akseptansetesten, kjørt manuelt 22.10 og av en CDP-agent med Opus og med Sonnet 26.10. CDP-agentene kjørte en rettet kopi av testcasene: egne opptaksnavn per kjøring, og i 1.2–1.8 er alle de andre obligatoriske feltene fylt ut, så hver testcase tester ett felt.

| | Bestått | Ikke bestått | Ulik status fra manuelt |
|---|---|---|---|
| Manuelt (22.10) | 23 | 4 (1.1, 2.4, 2.5, 2.8) | – |
| Opus (26.10) | 23 | 4 (1.1, 2.4, 2.8, 2.13) | 2 (2.5, 2.13) |
| Sonnet (26.10) | 24 | 3 (2.4, 2.8, 2.13) | 3 (1.1, 2.5, 2.13) |

Opus og Sonnet har ulik status i én testcase (1.1). Tabellen viser testcasene der status er ulik, og der status er lik, men det de så, er forskjellig.

| Nr | Testcase | Manuelt (22.10) | Opus (26.10) | Sonnet (26.10) | Hvorfor |
|---|---|---|---|---|---|
| 1.1 | Opprette et samordna opptak | Ikke bestått: HK-dir står ikke som organisasjon | Ikke bestått: «Organisasjon» er tom i lista | Bestått: HK-dir står i «Organisasjon» | Uavklart. Skjermbildene bekrefter begge, med samme testbruker (Ordentlig Rundskriv, HK-dir): opptaket fra 10:29 har tom «Organisasjon», og opptaket fra 11:01 har HK-dir. Trolig en endring i TEST mellom kjøringene, eller at Opus-opptaket ble lagret uten eier. Sjekk om Opus-opptaket (`/opptak/T3BwdGFrOjky`) viser HK-dir nå. |
| 2.4 | Organisasjon som ikke deltar, kan ikke åpne opptaket | Ikke bestått (ingen kommentar) | Ikke bestått: siden kan åpnes | Ikke bestått: siden kan åpnes, og viser «Administreres av HK-dir» | Alle tre fant kjent mangel TAKE-434. «Administreres av» er tom hos Opus og fylt ut hos Sonnet, samme forskjell som i 1.1. |
| 2.5 | Fjerne en deltakende organisasjon som har utdanningstilbud | Ikke bestått (ingen kommentar) | Bestått: meldingen «Utdanningstilbudene til Norges teknisk-naturvitenskapelige universitet må fjernes først», og NTNU står fortsatt der | Bestått: samme melding, og NTNU står fortsatt der | Rettet i løsningen. TAKE-433 ble merget i fs-plattform 22.10, samme dag som den manuelle testen, trolig etter at den ble kjørt. |
| 2.13 | Se og navigere til saksbehandlertildelingen | Bestått | Ikke bestått: fant ikke lenken | Ikke bestått: fant lenken «Saksbehandlertildelingsregler» under «Samordning» i «Endre innstillinger for opptaket», og den åpner «Behandlertildelingsregler». Siden til opptaket viser ikke saksbehandlertildelingen. | Testcasen er tvetydig. Steget og kravet sier «siden til opptaket» / «åpner opptaket», men lenken står i redigeringen. Den manuelle testeren godtok lenken der, Opus lette bare på siden til opptaket, og Sonnet fant lenken, men holdt seg til ordlyden. |
| 2.8 | Deltakende organisasjon kan se, men ikke endre innstillinger | Ikke bestått: fristen er ikke oppdatert, og ikke alle innstillingene vises | Ikke bestått: fristen *er* oppdatert, men poenglikhetsregel, antall søknadsalternativer og tilbud per tildelingsrunde vises ikke. «Administreres av» er tom. | Ikke bestått: fristen er oppdatert, men poenglikhetsregelen vises ikke, heller ikke for testbruker 1. «Administreres av HK-dir» står der. | Fristene er trolig rettet i fs-admin 22.10 («frister og rekkefølge fra backend»). At poenglikhetsregelen ikke vises for testbruker 1 heller, tyder på at den ikke er en del av visningen. Forventet resultat eller kravet bør avklares. |
| 2.1 | Legge til lærested i samordna opptak | Bestått | Bestått, men måtte flytte «Redigering stenger» for å få fram «Handlinger» | Bestått, med avvik: samme som Opus | Endret i løsningen 22.10: utdanningstilbud følger nå redigeringsfristene til opptaket (SHI-743). «Fyll inn testdatoer» setter «Redigering stenger» til i dag kl. 00:00, så redigeringen er stengt før testen starter. En manuell tester vil få samme problem nå. |
| 1.2 | Lagre opptak uten navn | Bestått, men: «Det står mange flere obligatoriske felt enn navnefeltene» | Bestått: bare de tre navnefeltene står der | Bestått: bare de tre navnefeltene står der | Testcasen var feil. Den fylte ikke ut de andre obligatoriske feltene, og den manuelle statusen motsier det testeren så. Rettet i kopien agentene kjørte. |

## Hva det betyr

- **To av forskjellene fra den manuelle testen er endringer i løsningen** (2.5 og 2.1), merget samme dag som den manuelle testen. 1.1 kan også være det. Testplanen bør si hvilken versjon som er i testmiljøet, ellers kan to kjøringer ikke sammenlignes. Bare Sonnet noterte versjonen.
- **Opus og Sonnet gikk utenom stegene på nøyaktig samme måte:** samme erstatninger for testdata som ikke finnes i TEST («UHGTEST2026», «Loddnummer, laveste nummer først», «Alder, eldste først»), samme frist flyttet i 2.1, og samme organisasjonsnavn i 2.10. Det er testdataene og testcasene som må rettes, ikke modellene.
- **2.13 og 2.8 bør avklares:** hvor skal lenken til saksbehandlertildelingen stå, og skal poenglikhetsregelen vises på siden til opptaket? Svarene avgjør om testcasen, kravet eller løsningen skal endres.
- **Dokumentasjonen:** Begge agentene dokumenterte alle 27 testcaser med det de så og skjermbilder. Den manuelle testen har «Faktisk resultat» i 3. Opus fant flest andre funn (6). Sonnet fulgte konvensjonene i repoet (resultatet i `kjoring-…/resultat.md`, foreslått status), noterte miljø og innlogging, ryddet opp etter 2.7, og fant at datofeltene ikke kan fylles ut med tastaturet.
