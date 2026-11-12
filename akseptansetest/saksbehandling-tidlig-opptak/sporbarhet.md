# Sporbarhet – Saksbehandling av tidlig opptak

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786
- **Confluence**: –
- **Laget**: 2026-11-04 av fs-testplan
- **Oppdatert**: 2026-11-04 av fs-testplan (fase 1)

---

Sporbarhet per krav for «Saksbehandling av tidlig opptak». Raden følger scenarioet fra kravet til koden og til testen. Kolonnen for fase 1 fylles ut av `fs-testplan` fra verify-rapporten, og resten av `fs-testrapport` etter hvert som fasene er ferdige. Testplanen: [Testplan – Saksbehandling av tidlig opptak](testplan.md).

For `@OPT-BEH-BEH-009` og `@OPT-BEH-BEH-013` står bevisene i verify-rapportene fra 2026-10-26, og resultatet fra den interne testen i [testrapport-intern-2026-10-30.md](testrapport-intern-2026-10-30.md). For `@OPT-BEH-BEH-007` er `P/svc` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`, og `A/TO` = `fs-admin/src/domains/plasstildeling/features/TidligOpptak` (som i [verify-rapporten](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/verify-gi_tilbudsgaranti_ved_tidlig_opptak-2026-11-04-1359.md)).

| Krav | Scenario | Kode (fase 1) | Testcase, teknikk og resultat (fase 2) | Flyt (fase 3) |
|---|---|---|---|---|
| `@OPT-BEH-BEH-009` | Filtrere på tidlig opptak | Se verify-rapporten 2026-10-26 | Ikke aktuell | Oppgave «Finne og vurdere søknader om tidlig opptak», testet 2026-10-30 |
| `@OPT-BEH-BEH-009` | Saker der søkeren ikke har søkt, mangler ikke konklusjon | Se verify-rapporten 2026-10-26 | Ikke aktuell | Som over |
| `@OPT-BEH-BEH-013` | Se søkerens begrunnelse for tidlig opptak | Se verify-rapporten 2026-10-26 | Ikke aktuell | Som over |
| `@OPT-BEH-BEH-013` | Se dokumentasjonskrav for begrunnelsen | Se verify-rapporten 2026-10-26 | Ikke aktuell | Som over |
| `@OPT-BEH-BEH-013` | Velge blant konklusjonene opptaket har | Se verify-rapporten 2026-10-26 | Ikke aktuell | Som over |
| `@OPT-BEH-BEH-013` | Konkludere om søkeren deltar i tidligopptaket | Se verify-rapporten 2026-10-26 | Ikke aktuell | Som over |
| `@OPT-BEH-BEH-013` | Søknad uten ønske om tidlig opptak viser ikke tidlig opptak | Se verify-rapporten 2026-10-26 | Ikke aktuell | Som over |
| `@OPT-BEH-BEH-013` | Konklusjon per organisasjon | Se verify-rapporten 2026-10-26 | Ikke aktuell | Som over |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti ut fra poenggrensen | `P/svc:765-775` | | Oppgave «Gjennomføre tidligopptaket» |
| `@OPT-BEH-BEH-007` | Søkere som ikke deltar får ikke tilbudsgaranti | `P/svc:667-675` | | Som over |
| `@OPT-BEH-BEH-007` | Søknader uten konklusjon er ikke med i tidligopptaket | `P/svc:657-665` | | Som over |
| `@OPT-BEH-BEH-007` | Søkere som ikke er kvalifisert får ikke tilbudsgaranti | `P/svc:707-715` | | Som over |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti på det høyest prioriterte søknadsalternativet | `P/svc:590-609` | | Som over |
| `@OPT-BEH-BEH-007` | Bare ferdig behandlede saker er med i tidligopptaket | `P/svc:644-652`; `A/TO/components/TidligOpptakResultModal/TidligOpptakResultModal.tsx:81-98` | | Som over |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten poenggrense | `P/svc:681-684` | | Som over |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten kvalifisering | `P/svc:681-684` | | Som over |
| `@OPT-BEH-BEH-007` | Den høyeste poengsummen til søknadsalternativet gjelder | `P/svc:888-918` | | Som over |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet | `P/svc:972-992, 1074-1079` | | Som over |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet | `P/svc:1014-1016, 1074-1079` | | Som over |
| `@OPT-BEH-BEH-007` | Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket | `P/svc:614-631` | | Som over |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder går foran poengsummen | `P/svc:627-631` | | Som over |
| `@OPT-BEH-BEH-007` | En ny gjennomføring fjerner ikke tilbudsgarantien | `P/svc:616-626` | | Som over |
| `@OPT-BEH-BEH-007` | Ny gjennomføring tar med en sak som er blitt ferdig behandlet | `P/svc:529-536, 821-873` | | Som over |
| `@OPT-BEH-BEH-007` | Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring | `P/svc:591-594, 1037-1067` | | Som over |
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/plasstildeling/algoritme/Opptakskjoringsalgoritme.java:208-211` | | Som over |
| `@OPT-BEH-BEH-007` | Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon | `P/svc:176-181, 219-222`; `A/TO/components/TidligOpptakResultModal/TidligOpptakResultModal.tsx:81-98` | | Som over |
| `@OPT-BEH-BEH-007` | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak | `P/svc:279-291`; `A/TO/components/KjorTidligopptakButton/KjorTidligopptakButton.tsx:90-94` | | Som over |
| `@OPT-BEH-BEH-007` | Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket | `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/SettTilbudsgarantitypeService.java:60-103` | | Som over |
