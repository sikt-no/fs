# Sporbarhet – Se søkerens elektroniske vitnemål

- **Testplan**: [testplan.md](testplan.md)
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5174132758 (utkast)
- **Laget**: 2026-11-05 av fs-testplan
- **Oppdatert**: 2026-11-05 av fs-testplan (fase 1)

---

Sporbarhet per krav for «Se søkerens elektroniske vitnemål». Raden følger scenarioet fra kravet til koden og til testen. Kolonnen for fase 1 fylles ut av `fs-testplan` fra verify-rapporten, og resten av `fs-testrapport` etter hvert som fasene er ferdige. Testplanen: Testplan – Se søkerens elektroniske vitnemål.

| Krav | Scenario | Kode (fase 1) | Testcase, teknikk og resultat (fase 2) | Flyt (fase 3) |
|---|---|---|---|---|
| `@OPT-BEH-BEH-005` | Se at søkeren har elektroniske vitnemål | `fs-admin/src/domains/soknadsbehandling/features/VitnemalsbehandlingSection/VitnemalsbehandlingSection.tsx:97-107` | | Oppgave uten flyt |
| `@OPT-BEH-BEH-005` | Søker uten elektroniske vitnemål | `fs-admin/…/VitnemalsbehandlingSection.tsx:81-85` | | Oppgave uten flyt |
| `@OPT-BEH-BEH-005` | Poeng som ikke kan beregnes, vises tomme | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentPoengService.java:36,52-55`, `fs-admin/…/VitnemalsbehandlingSection.tsx:93-94` | | Oppgave uten flyt |
| `@OPT-BEH-BEH-005` | Åpne et vitnemål i ny fane | `fs-admin/…/VitnemalsbehandlingSection.tsx:157-168` | | Oppgave uten flyt |
| `@OPT-BEH-BEH-005` | Annullert vitnemål som er brukt i en beregning vises | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/vgs/VgsDokumentConditions.java:28,41-47`, `fs-admin/…/VitnemalsbehandlingSection.tsx:169-171` | | Oppgave uten flyt |
| `@OPT-BEH-BEH-005` | Annullert vitnemål som ikke er brukt i en beregning vises ikke | `fs-plattform/…/vgs/VgsDokumentConditions.java:28,41-64` | | Oppgave uten flyt |
| `@OPT-BEH-BEH-005` | Saksbehandler med leserettighet ser søkerens vitnemål | `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V501__tilbyderoppslag_per_sak.sql:37-40` | | Oppgave uten flyt |
| `@OPT-BEH-BEH-005` | Bruker uten lesetilgang ser ikke vitnemålsoversikten | Usikker: `fs-plattform/…/V501__tilbyderoppslag_per_sak.sql:37-52` (forvalter og tilbyder ser også) | | Oppgave uten flyt |
| `@OPT-BEH-BEH-005` | Saken er tilordnet en annen saksbehandler | `fs-plattform/…/V501__tilbyderoppslag_per_sak.sql:37-52` | | Oppgave uten flyt |
