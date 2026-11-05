# Kjøring 2026-10-30 15:17: saksbehandlertildeling

- **Testplan:** [testplan.md](../testplan.md)
- **Confluence:** [Akseptansetesting saksbehandlertildeling](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130911779/Akseptansetesting+saksbehandlertildeling), versjon 11 har resultatene merket «Agent 30.10»
- **Kjørt av:** Claude (Opus 5.5) med chrome-devtools, i test-fsadmin, testbrukerne valgt i «Overstyrt bruker»
- **Opptak:** «HÅK1 er KUL 2 - Saksbehandlertildeling» (`T3BwdGFrOjkx`). Ingenting utenfor opptaket er endret
- **Status:** forslag. Testansvarlig bekrefter før `fs-testrapport` teller

Utdanningstilbudene i opptaket er ikke de samme som i stegene, men har tilsvarende behandlertildelingsregler: «SPE» på Biovitenskap (UiO) og Praktiske musikkaktiviteter (HVL), «JOU» på Automatisering med robotikk (HVL), og standardregelen «ORD» på resten.

## Resultater

| # | Resultat | Hva skjedde |
|---|---|---|
| 6.1 | Bestått | Unntakene «Utenlandsk» og «Videregående steinerskole» → HK-dir lagt på «PAP». Lista viser «2 unntak» |
| 7.2 | Bestått | Ingen søknad har to saker hos samme organisasjon, og hvert søknadsalternativ ligger i én sak (søknadene som fantes) |
| 8.4a | Bestått | 91-1004287 → realkompetanse: «Informatikk, datafag» flyttet fra UiO til UiT |
| 8.4b | Bestått | 91-1004291 → dispensasjon: søknadsalternativene flyttet til tilbyderne (UiT og NTNU) |
| 8.5b | Bestått | 91-1004290 → utenlandsk etter fristen, av saksbehandler ved UiO: saken ble hos UiO, med teksten om fristen. Funn 9 (STEK-654) skjedde ikke |
| 8.6 | Ikke bestått | «Manglende tilgang til å utføre denne operasjonen» for opptaksforvalteren ved HK-dir, både ved overstyring og «Flytt saken» (STEK-658) |
| 9.1 | Bestått | Saksbehandleren ved UiO ser bare de 10 sakene hos UiO |
| 9.2 | Bestått | Saksbehandleren ved HK-dir ser bare de 4 sakene hos HK-dir |
| 10.1 | Bestått | Opptaksforvalteren ser alle 36 sakene |
| 8.3b | Ikke testet | Brukere ved HK-dir får ikke overstyrt (STEK-658) |
| 8.5a | Ikke testet | Fristen kan ikke flyttes fram (STEK-659) |
| 8.7a–c | Ikke testet | «Ingen tilgjengelige tilbudsgarantier» i opptaket. Typene settes per opptak, og bare en utvikler kan legge dem inn |
| 6.2a, 6.2b, 6.5–6.8, F.1 | Ikke testet | Trenger en søker eller en søknad fra Min kompetanse |

## Endringer i opptaket

- «PAP» har fått to unntak for utdanningsbakgrunn.
- Utdanningsbakgrunnen er overstyrt på 91-1004287 (realkompetanse), 91-1004290 (utenlandsk, gjelder ikke i tildelingen) og 91-1004291 (dispensasjon).
- Forsøkene på 91-1004284 og 91-1004328, og på fristen i opptaket, ble ikke lagret.

## Nye funn

- [STEK-658](https://sikt.atlassian.net/browse/STEK-658): brukere ved HK-dir får «Manglende tilgang» når de overstyrer utdanningsbakgrunn eller flytter saken.
- [STEK-659](https://sikt.atlassian.net/browse/STEK-659): fristen for endring av utdanningsbakgrunn lagres ikke når opptaket redigeres.

Skjermbildene ligger i denne mappa lokalt, og er ikke i git.
