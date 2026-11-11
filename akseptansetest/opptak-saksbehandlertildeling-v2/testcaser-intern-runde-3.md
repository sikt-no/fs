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
  | 6 | `@OPT-BEH-BEH-011` | Saksbehandlerens endring til utenlandsk utdanningsbakgrunn når fristen ikke har gått ut; Organisasjonen søknadsalternativet flyttes til, får en ubehandlet sak; Organisasjonen søknadsalternativet flyttes til, ser dokumentene søkeren har lastet opp | – (ikke testet av fagperson før) |

  Funn 6 (tilbudsgaranti) er tatt ut: det hører ikke til saksbehandlertildelingen, og var trolig testdata (testopptaket hadde ingen tilbudsgarantityper).

---

Ca. 40 minutter. Sjekker at funnene fra runde 2 er rettet, og at tildelingen virker fra søknad til sak. Alt skjer i opptaket «HÅK1 er KUL». Fyll ut «Faktisk resultat» og «Status» (Bestått, Ikke bestått, Ikke testet). Fordelingen tar opptil et minutt.

## Testbrukere

Velges i «Overstyrt bruker» øverst i FS Admin.

| Kortnavn | Testbruker |
| --- | --- |
| Forvalter | ORDENTLIG RUNDSKRIV • OPPTAK_FORVALTER (HK-DIR) |
| UiO | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIO) |
| UiT | KORT DOMPAP • OPPTAK_SAKSBEHANDLER (UIT) |
| HK-dir | ORDENTLIG RUNDSKRIV • OPPTAK_SAKSBEHANDLER (HK-DIR) |

## Testdata

| Hva | Verdi |
| --- | --- |
| Søknad | 41-1004261, med et opplastet dokument. Studieønsker: 1 Ergoterapi (UiT), 2 Geologi (NTNU), 3 Filosofi (UiO) |
| Ergoterapi | Regelen UITUIO: UiO saksbehandler på vegne av UiT |
| Filosofi | Regelen UTLHK: utenlandsk utdanningsbakgrunn går til HK-dir |

## Testcaser

| Del | Hva du gjør | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- |
| 1 | 1) Forvalter: lag en behandlertildelingsregel, og sett den på et utdanningstilbud. 2) UiO: opprett en søknad med det tilbudet og ett ved et annet lærested. 3) Skriv ned hvem du tror får hvert studieønske. 4) Forvalter: sjekk B-rollene i «Saker i opptak». | Hvert studieønske er hos organisasjonen du forventet, med én sak per organisasjon |  |  |
| 2 | 1) UiO: åpne saken for 41-1004261. 2) Se på søknadsalternativene og dokumentene. | Alle studieønskene vises, med hvem som saksbehandler dem. Saksbehandlingen vises bare for UiOs egne. Dokumentet kan åpnes |  |  |
| 3 | 1) UiT: åpne saken for 41-1004261. 2) Gå gjennom saken. | Ingen knapper eller redigering du ikke kan bruke. Alle studieønskene og dokumentet vises |  |  |
| 4 | 1) Forvalter: åpne sakene for 41-1004261. | Sakene vises, uten knapper du ikke kan bruke |  |  |
| 5 | 1) Logg inn i Min kompetanse (test): ID-porten → TestID → «Hent tilfeldig person». 2) Søk på Ergoterapi og Filosofi i «HÅK1 er KUL», og send. 3) Vent et minutt, og åpne søknaden. | Du ser hvem som saksbehandler hvert studieønske, men ingen saker. Teksten er forståelig |  |  |
| 6 | Gjør denne til slutt. 1) UiO: åpne saken for 41-1004261, og endre utdanningsbakgrunn til «Utenlandsk videregående skole». Bekreft i dialogen. 2) Vent et minutt. 3) Forvalter: se på sakene. 4) HK-dir: åpne den nye saken. | Filosofi er i en ny sak hos HK-dir, «Ikke behandlet», og HK-dir ser dokumentet. Ergoterapi er fortsatt hos UiO |  |  |

## Funn

| # | Del | Hva skjedde | Hva var forventet | Alvorlighetsgrad | Sak |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |
