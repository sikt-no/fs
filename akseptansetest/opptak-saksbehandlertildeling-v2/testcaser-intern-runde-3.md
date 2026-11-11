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
  | 1 | `@FLY-OPT-SAK-001` | Søknaden blir én sak hos hver saksbehandlende organisasjon | – |
  | 2 | `@OPT-BEH-BEH-011` | Saksbehandleren ser alle søknadsalternativene på søknaden; Saksbehandleren ser dokumentene søkeren har lastet opp | 3 |
  | 3 | `@OPT-BEH-BEH-011` | Tilbyderen kan ikke endre saksbehandlingen; Tilbyderen ser alle søknadsalternativene på søknaden; Tilbyderen ser dokumentene søkeren har lastet opp | 1, 2, 3, 4, 5 |
  | 4 | `@OPT-BEH-BEH-011` | Tilbyderen setter tilbudsgaranti | 6 |
  | 5 | `@OPT-BEH-BEH-011` | Opptaksforvalteren ved HK-dir ser sakene hos alle saksbehandlende organisasjoner | 1 |
  | 6 | `@OPT-BEH-BEH-011` | Søkeren ser saksbehandlende organisasjon, men ikke sakene | – |

---

Kort runde, ca. 30 minutter. Den sjekker at funnene fra runde 2 er rettet, og at tildelingen virker fra søknad til sak. Alt skjer i testopptaket «HÅK1 er KUL 2 - Saksbehandlertildeling». Testbrukerne står i [testplanen](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5170495530/Testplan+Saksbehandlertildeling+runde+2).

Fyll ut «Faktisk resultat» og «Status» (Bestått, Ikke bestått eller Ikke testet). Funn skrives nederst. Fordelingen tar opptil et minutt.

## Testdata

Teamet fyller ut før testen.

| Hva | Krav til dataene | Verdi |
| --- | --- | --- |
| Søknad | Søkeren har lastet opp et dokument, og studieønskene saksbehandles av minst to organisasjoner. Den lages i Min kompetanse med en TestID-søker, for søknader opprettet i FS Admin har ingen opplastede dokumenter. | [Fylles ut: søknadsnummer] |
| Studieønske for tilbyderen (del 3–4) | Tilbys av en organisasjon som ikke saksbehandler det. Utdanningstilbudet har kvote, så poengene vises. | [Fylles ut: utdanningstilbud] |

## Testcaser

| Del | Hva du gjør | Forventet resultat | Faktisk resultat | Status |
| --- | --- | --- | --- | --- |
| 1 | Som opptaksforvalter (testbruker 1): åpne søknaden i «Saker i opptak». Tenk først over hvem som skal saksbehandle hvert studieønske, og sjekk så. | Hvert studieønske har den saksbehandlende organisasjonen du forventet, og søknaden har én sak per organisasjon |  |  |
| 2 | Som saksbehandler ved en organisasjon som fikk en sak (testbruker 3 eller 5): åpne saken. | Du ser alle studieønskene på søknaden, med hvem som saksbehandler dem, men saksbehandlingen bare for dine egne. Dokumentet søkeren lastet opp, kan åpnes |  |  |
| 3 | Som saksbehandler ved tilbyderen: åpne saken med studieønsket fra testdataene, og gå gjennom den. | Ingen knapper eller redigering du ikke kan bruke, heller ikke for mangler. Du ser alle studieønskene, poengene og dokumentet, men kan ikke endre noe |  |  |
| 4 | Som tilbyderen: sett tilbudsgaranti på studieønsket, og last siden på nytt. | Tilbudsgarantien er lagret |  |  |
| 5 | Som opptaksforvalter: åpne en av sakene hos lærestedene. | Du ser saken, men ingen knapper du ikke kan bruke |  |  |
| 6 | Som søkeren: logg inn i Min kompetanse, og åpne søknaden. | Du ser hvem som saksbehandler hvert studieønske, men ingen saker eller saksbehandlere. Teksten er forståelig |  |  |

## Funn

| # | Del | Hva skjedde | Hva var forventet | Alvorlighetsgrad | Sak |
| --- | --- | --- | --- | --- | --- |
|  |  |  |  |  |  |
