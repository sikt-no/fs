# Sporbarhet – Gi tilbudsgaranti ved tidlig opptak

- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5181997074
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5182062606 (utkast)
- **Laget**: 2026-11-09 av fs-testplan
- **Oppdatert**: 2026-11-09 av fs-testplan (fase 1)

---

Sporbarhet per krav for «Gi tilbudsgaranti ved tidlig opptak». Raden følger scenarioet fra kravet til koden og til testen. Kolonnen for fase 1 fylles ut av `fs-testplan` fra verify-rapporten, og resten av `fs-testrapport` etter hvert som fasene er ferdige. Testplanen: Testplan – Gi tilbudsgaranti ved tidlig opptak.

`TTS` = `fs-plattform/opptak/opptak-service/src/main/java/no/sikt/fs/opptak/saksbehandling/tidligopptak/TidligopptakTilbudsgarantiService.java`. De andre stiene står i verify-rapporten.

| Krav | Scenario | Kode (fase 1) | Testcase, teknikk og resultat (fase 2) | Flyt (fase 3) |
|---|---|---|---|---|
| `@OPT-BEH-BEH-007` | Tilbudsgaranti ut fra poenggrensen | `TTS:776-786`, `KjorTidligopptakButton.tsx:111-114` | | |
| `@OPT-BEH-BEH-007` | Søkere som ikke deltar får ikke tilbudsgaranti | `TTS:678-686` | | |
| `@OPT-BEH-BEH-007` | Søknader uten konklusjon er ikke med i tidligopptaket | `TTS:668-676` | | |
| `@OPT-BEH-BEH-007` | Søkere som ikke er kvalifisert får ikke tilbudsgaranti | `TTS:718-726` | | |
| `@OPT-BEH-BEH-007` | Kvalifisering som ikke er vurdert gir ikke tilbudsgaranti | `TTS:709-715`, `TTS:727-735` | | |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti på det høyest prioriterte søknadsalternativet | `TTS:870`, `TTS:599-619`, `TTS:776-786` | | |
| `@OPT-BEH-BEH-007` | Bare ferdig behandlede saker er med i tidligopptaket | `TTS:655-663` | | |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten poenggrense | `TTS:688-695` | | |
| `@OPT-BEH-BEH-007` | Reservert studieplass gir tilbudsgaranti uten kvalifisering | `TTS:692`, `TTS:699-735` | | |
| `@OPT-BEH-BEH-007` | Den høyeste poengsummen til søknadsalternativet gjelder | `TTS:899-928` | | |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som ikke gir tilbud blir erstattet | `TTS:1085-1090`, `TTS:1028-1030` | | |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti fra opptaksforvalter som gir tilbud blir erstattet | `TTS:1085-1090`, `TTS:1025-1027` | | |
| `@OPT-BEH-BEH-007` | Annen tilbudsgaranti på et høyere prioritert søknadsalternativ stopper ikke tidligopptaket | `TTS:625-653`, `TTS:1093-1098` | | |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder går foran poengsummen | `TTS:638-642`, `TTS:602-619` | | |
| `@OPT-BEH-BEH-007` | Tidligopptakstilbud fra tilbyder gjelder uansett konklusjon og poengsum | `TTS:520-545`, `TTS:638-642` | | |
| `@OPT-BEH-BEH-007` | Prøvekjøre tidligopptaket | `TTS:110-117`, `TTS:149-150`, `KjorTidligopptakButton.tsx:96-104`, `TidligOpptakResultModal.tsx:110-113` | | |
| `@OPT-BEH-BEH-007` | En ny gjennomføring fjerner ikke tilbudsgarantien | `TTS:627-636` | | |
| `@OPT-BEH-BEH-007` | Ny gjennomføring tar med en sak som er blitt ferdig behandlet | `TTS:540-547`, `TTS:655-663` | | |
| `@OPT-BEH-BEH-007` | Tilbudsgarantien flyttes til et høyere prioritert søknadsalternativ ved ny gjennomføring | `TTS:602-604`, `TTS:1048-1078` | | |
| `@OPT-BEH-BEH-007` | Søknadsalternativ uten tilbudsgaranti går videre til ordinært opptak | `Opptakskjoringsalgoritme.java:202-211` | | |
| `@OPT-BEH-BEH-007` | Tilbudsgaranti ut fra poenggrensen eller medianen fra forrige opptak | `TTS:323-326`, `UtdanningstilbudV2Service.java:80-96`, `TTS:776-786` | | |
| `@OPT-BEH-BEH-007` | Ingen tilbudsgaranti uten poenggrense og uten median fra forrige opptak | `TTS:736-744`, `UtdanningstilbudV2Service.java:93-96` | | |
| `@OPT-BEH-BEH-007` | Se antall søkere med saker som ikke er ferdig behandlet eller mangler konklusjon | `TTS:178-183`, `TTS:221-224`, `TidligOpptakResultModal.tsx:82-97` | | |
| `@OPT-BEH-BEH-007` | Tidligopptaket stopper uten én tilbudsgarantitype for tidlig opptak | `TTS:281-293`, `tidligopptak-tilbudsgaranti-automatikk.graphqls:365-394`, `TidligOpptakResultModal.tsx:150-154, 177-185` | | |
| `@OPT-BEH-BEH-007` | Sette tilbudsgaranti når søkeren ikke deltar i tidligopptaket | `SettTilbudsgarantitypeService.java:55-103`, `TilbudsgarantitypeSelect.tsx:99-116` | | |
