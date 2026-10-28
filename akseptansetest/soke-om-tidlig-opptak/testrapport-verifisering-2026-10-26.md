# Testrapport – verifisering – Søke om tidlig opptak

- **Nivå**: verifisering
- **Akseptansetesting**: [akseptansetesting.md](akseptansetesting.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5144772613
- **Scope**: –
- **Grunnlag**: [verify-søke_om_tidlig_opptak-2026-10-26-0950.md](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/verify-s%C3%B8ke_om_tidlig_opptak-2026-10-26-0950.md), lest 2026-10-26 15:49
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5146836993
- **Laget**: 2026-10-26 av fs-testrapport

---

Testrapport for «Søke om tidlig opptak». Den bygger på verifiseringen fra 2026-10-26 09:50.

## Oppsummering

| Felt | Innhold |
|---|---|
| Scenarioer | 9 funnet, 0 ikke funnet, 0 usikker, av 9 |
| Krav levert (`@implemented`) | 1 av 1 |
| Åpne spørsmål som står igjen | Ingen i scenarioene i testen. «Se når søkeren søkte om tidlig opptak» har et åpent spørsmål, men er et utkast og ikke med i testen |
| Overleveringer i flytene | Ingen flyter |
| Kontrollert av | [Fylles ut av teamet] (en annen enn den som kjørte `fs-verify`). Verifiseringen ble kontrollert av `fs-verify-kontroll`, som bekreftet 8 av 9. Det niende, «Se hvilke søknadsalternativer som tilbyr tidlig opptak», ble avgjort som funnet av Jens Thomassen |
| Klar for intern akseptansetest | Ja |

## Resultat per krav

| Oppgave | Krav | Funnet | Ikke funnet | Usikker | Status |
|---|---|---|---|---|---|
| tidlig-opptak | [Søke om tidlig opptak](https://github.com/sikt-no/fs/blob/709fc898357b5c8e2b0d62571983b02c296746a6/krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/s%C3%B8ke_om_tidlig_opptak.feature) (`@OPT-SØK-SØK-011`) | 9 | 0 | 0 | `@implemented` |

## Flyter

Ingen av kravene er med i en flyt.

## Det som mangler

Ingen.

## Neste steg

Leveransen er klar for intern akseptansetest: `fs-testcaser-intern` lager testcasene fra «Omfang» i testplanen. Før testen må teamet fylle ut testbrukerne (fire søkere), opptaket og de andre testdataene, og forutsetning 1–4 i testplanen.

Verify-rapporten har tre punkter til oppfølging, som ikke stopper testen:

- Løsningen godtar en søknad om tidlig opptak når opptaket har tidlig opptak, selv om ingen av søkerens søknadsalternativer tilbyr det (fs-plattform). Min kompetanse viser ikke muligheten i det tilfellet.
- Alt i Min kompetanse er bak feature-flagget `enable-tidlig-opptak`, som må være på i testmiljøet.
- Kravet bygger på `@OPT-OVO-INN-001` (`@in-progress`) og `@OPT-OPT-UTD-004` (`@draft`), som ikke er levert. Innstillingene for tidlig opptak må derfor være satt i testdataene.
