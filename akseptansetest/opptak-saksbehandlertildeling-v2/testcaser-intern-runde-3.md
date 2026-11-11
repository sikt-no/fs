# Intern akseptansetest – Saksbehandlertildeling, runde 3

- **Nivå**: intern (fase 3), runde 3
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2
- **Krav**: `@OPT-BEH-BEH-011` og `@FLY-OPT-SAK-001`, branchen `krav/saksbehandlertildeling-v2` (PR #936), 2026-11-11
- **Verifisering**: [verify-2026-11-11-0945.md](../../tasks/opptak/saksbehandlertildeling/spec/verify-2026-11-11-0945.md)
- **Runde 2**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5173018630/Intern+akseptansetest+Saksbehandlertildeling+runde+2
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5187895334 (under «Testplaner», på linje med testplanen for runde 2)
- **Laget**: 2026-11-11 av fs-testcaser-intern. Testansvarlig ba om en kort runde: funnene fra runde 2 testes på nytt, og en grunnflyt. Resten er gått gjennom før.
- **Sporing**:

  | Del | Feature-ID | Scenario | Funn i runde 2 |
  |---|---|---|---|
  | 1 | `@OPT-BEH-BEH-011`, `@FLY-OPT-SAK-001` | Opprette behandlertildelingsregel; Søknaden blir én sak hos hver saksbehandlende organisasjon | – |
  | 2 | `@OPT-BEH-BEH-011` | Saksbehandleren ser alle søknadsalternativene på søknaden; Saksbehandleren ser dokumentene søkeren har lastet opp | 3 |
  | 3 | `@OPT-BEH-BEH-011` | Tilbyderen kan ikke endre saksbehandlingen; Tilbyderen ser alle søknadsalternativene på søknaden; Tilbyderen ser dokumentene søkeren har lastet opp | 1, 2, 3, 4, 5 |
  | 4 | `@OPT-BEH-BEH-011` | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner | 1 |
  | 5 | `@OPT-BEH-BEH-011` | Søkeren ser saksbehandlende organisasjon, men ikke sakene | – |

  Funn 6 (tilbudsgaranti) er tatt ut: det hører ikke til saksbehandlertildelingen, og var trolig testdata (testopptaket hadde ingen tilbudsgarantityper).

---

Kort runde, ca. 30 minutter. Den sjekker at funnene fra runde 2 er rettet, og at tildelingen virker fra søknad til sak. Alt skjer i testopptaket «HÅK1 er KUL» (testmiljøet ble nullstilt etter runde 2, og «HÅK1 er KUL 2» finnes ikke lenger). Testbrukeren velges i «Overstyrt bruker» øverst i FS Admin.

Fyll ut «Faktisk resultat» og «Status» (Bestått, Ikke bestått eller Ikke testet). Funn skrives nederst. Fordelingen tar opptil et minutt.

## Testdata

Satt opp 11.11.2026.

| Hva | Verdi |
| --- | --- |
| Søknad | 41-1004261, sendt fra Min kompetanse av en TestID-søker, med ett opplastet dokument (vitnemal-test-runde3.pdf). Studieønsker: 1 Ergoterapi (UiT), 2 Geologi (NTNU), 3 Filosofi (UiO) |
| Studieønske for tilbyderen (del 3) | Ergoterapi – bachelor (UiT). Regelen UITUIO («UiT saksbehandles av UiO (runde 3)») gjør at UiO saksbehandler det på vegne av UiT |

## Testcaser

| Del | Hva du gjør | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- |
| 1 | Som opptaksforvalter (ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)): lag en behandlertildelingsregel som ligner en ekte situasjon, og sett den på et utdanningstilbud i testopptaket. Som saksbehandler ved UiO (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIO)): opprett en søknad på vegne av en søker, med det utdanningstilbudet og ett ved et annet lærested. Skriv ned hvem du forventer saksbehandler hvert studieønske. Vent et minutt, og sjekk B-rollene i «Saker i opptak» som opptaksforvalter. | Hvert studieønske har den saksbehandlende organisasjonen du forventet, og søknaden har én sak per organisasjon |  |  |
| 2 | Som saksbehandler ved UiO (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIO)): åpne saken for søknad 41-1004261. | Du ser alle studieønskene på søknaden, med hvem som saksbehandler dem, men saksbehandlingen bare for dine egne. Dokumentet søkeren lastet opp, kan åpnes |  |  |
| 3 | Som saksbehandler ved UiT (KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT)), tilbyderen av Ergoterapi: åpne saken for søknad 41-1004261, og gå gjennom den. | Ingen knapper eller redigering du ikke kan bruke, heller ikke for mangler. Du ser alle studieønskene og dokumentet, men kan ikke endre noe |  |  |
| 4 | Som opptaksforvalter (ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR)): åpne sakene for søknad 41-1004261. | Du ser saken, men ingen knapper du ikke kan bruke |  |  |
| 5 | Logg inn i Min kompetanse (test) med ID-porten → TestID → «Hent tilfeldig person». Søk på Ergoterapi og Filosofi i «HÅK1 er KUL», og send søknaden. Vent et minutt, og åpne søknaden. | Du ser hvem som saksbehandler hvert studieønske, men ingen saker eller saksbehandlere. Teksten er forståelig |  |  |

## Funn

| # | Del | Hva skjedde | Hva var forventet | Alvorlighetsgrad | Sak |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |
