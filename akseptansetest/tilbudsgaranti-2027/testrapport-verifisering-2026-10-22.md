# Testrapport – verifisering – Tilbudsgaranti i saksbehandlingen 2027

- **Nivå**: verifisering
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5130158105
- **Scope**: @scope-tilbudsgaranti-2027
- **Grunnlag**: [verify-2026-10-22-0850.md](../../tasks/opptak/tilbudsgaranti/spec/verify-2026-10-22-0850.md), lest 2026-10-22 10:48
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5131075597
- **Laget**: 2026-10-22 av fs-testrapport

---

Testrapport for «Tilbudsgaranti i saksbehandlingen 2027». Den bygger på verifiseringen fra 2026-10-22 08:50.

## Oppsummering

| Felt | Innhold |
|---|---|
| Scenarioer | 17 funnet, 0 ikke funnet, 0 usikker, av 17 |
| Krav levert (`@implemented`) | 1 av 1 |
| Åpne spørsmål som står igjen | Ingen |
| Overleveringer i flytene | Ingen flyter |
| Kontrollert av | [Fylles ut av teamet] (en annen enn den som kjørte `fs-verify`). Verifiseringen ble kontrollert av `fs-verify-kontroll`, som bekreftet alle 17 |
| Klar for intern akseptansetest | Ja |

## Resultat per krav

| Oppgave | Krav | Funnet | Ikke funnet | Usikker | Status |
|---|---|---|---|---|---|
| tilbudsgaranti | [Gi tilbudsgaranti](https://github.com/sikt-no/fs/blob/6478beea804db1a91ade2db494161ec86f4f2775/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/gi_tilbudsgaranti.feature) (`@OPT-BEH-BEH-010`) | 17 | 0 | 0 | `@implemented` |

## Flyter

Ingen av kravene er med i en flyt.

## Det som mangler

Ingen.

## Neste steg

Leveransen er klar for intern akseptansetest: `fs-testcaser-intern` lager testcasene fra «Omfang» i testplanen. Før testen må teamet fylle ut testbrukerne, testdataene og forutsetning 1–4 i testplanen.
