# Testrapport – verifisering – Saksbehandling av tidlig opptak

- **Nivå**: verifisering
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786
- **Scope**: –
- **Grunnlag**: [verify-finne_søknader_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-finne_s%C3%B8knader_om_tidlig_opptak-2026-10-26-1441.md), [verify-vurdere_søknad_om_tidlig_opptak-2026-10-26-1441.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-vurdere_s%C3%B8knad_om_tidlig_opptak-2026-10-26-1441.md), lest 2026-10-27 10:50
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5148803102
- **Laget**: 2026-10-27 av fs-testrapport

---

Testrapport for «Saksbehandling av tidlig opptak». Rapporten bygger på verifiseringen fra 2026-10-26.

## Oppsummering

| Felt | Innhold |
|---|---|
| Scenarioer | 15 funnet, 0 ikke funnet, 0 usikker, av 15 |
| Krav levert (`@implemented`) | 2 av 2, og 0 delvis levert |
| Åpne spørsmål som står igjen | Ingen |
| Overleveringer i flytene | Ingen flyter |
| Kontrollert av | [Fylles ut av teamet] (en annen enn den som kjørte `fs-verify`) |
| Klar for intern akseptansetest | Ja |

## Resultat per krav

| Oppgave | Krav | Funnet | Ikke funnet | Usikker | Status |
|---|---|---|---|---|---|
| tidlig-opptak | [Finne søknader om tidlig opptak](https://github.com/sikt-no/fs/blob/5605e7e/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/finne_s%C3%B8knader_om_tidlig_opptak.feature) | 6 | 0 | 0 | `@implemented` |
| tidlig-opptak | [Vurdere søknad om tidlig opptak](https://github.com/sikt-no/fs/blob/5605e7e/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/vurdere_s%C3%B8knad_om_tidlig_opptak.feature) | 9 | 0 | 0 | `@implemented` |

## Flyter

Ingen av kravene er med i en flyt.

## Det som mangler

Ingen.

## Neste steg

Klar for intern akseptansetest: `fs-testcaser-intern` med testplanen. Før testen må teamet fylle ut testbrukerne, testdataene, rollene, tid og kanal, og kriteriene for godkjent i testplanen, og en annen enn den som kjørte `fs-verify` må kontrollere verify-rapportene.

Oppfølgingen fra verify-rapportene, som ikke stopper testen:

- Hvilke tekstfelt på begrunnelsen for tidlig opptak skal brukes til hva i saksbehandlingen? Kortet viser i dag søkerens behov under «Begrunnelse fra søker», og viser «-» når teksten mangler.
- «Har konklusjon» i filteret krever ikke at søkeren har søkt.
