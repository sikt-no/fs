# Scope: Se digitale resultater i søknaden

- **Slug**: digitale-resultater-i-soknad
- **Initiativ**: [#559](https://github.com/sikt-no/fs/issues/559)
- **Eier**: @SunnivaLindgren
- **Siste oppdatering**: 2026-10-13

## Mål

- Søkeren ser i dokumentasjonssteget i søknaden hvilke digitale resultater systemet allerede har om hen, så hen slipper å laste opp dokumentasjonen på nytt.
- Søkeren får vite at saksbehandleren ser den samme dokumentasjonen når søknaden behandles.

## Ikke-mål

- Veiledning om hvilken dokumentasjon søkeren *må* laste opp. Det er `@OPT-SØK-SØK-003` ([#572](https://github.com/sikt-no/fs/issues/572)).
- Resultatvisningen i Min kompetanse (`@KOM-RES-RES-001`). Søkeren ser resultatene inne i søknaden, så avhengigheten falt bort 25.09.2026.
- Saksbehandlerens visning av vitnemål. Det er `@OPT-BEH-BEH-005` ([#613](https://github.com/sikt-no/fs/issues/613)).
- Personopplysninger fra folkeregisteret. De hører til #572.

## Kilder

- [GitHub #604](https://github.com/sikt-no/fs/issues/604) — «Vise søker hvilke digitale resultater systemet allerede har», under #559 og initiativet #208.
- [Jira TOT-2452](https://sikt.atlassian.net/browse/TOT-2452) — teamets epic for implementasjonen.
- [Confluence PFS 5040504880](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5040504880/Vise+s+ker+hvilke+digitale+resultater+systemet+allerede+har) — sida for notater og møtereferater (bare malen per 2026-10-13).
- [Figma: Min Kompetanse 2026, node 3920:14210](https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=3920-14210) — designskissene fra #604.

## Oppgaver

| Oppgave | Krav | MoSCoW | Skisse | Issue | Kommentar |
|---|---|---|---|---|---|
| [digitale-resultater-i-soknad](digitale-resultater-i-soknad/) | `@OPT-SØK-SØK-004` [se_digitale_resultater_i_søknad.feature](../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/01%20S%C3%B8knad/se_digitale_resultater_i_s%C3%B8knad.feature) | Must | [Min Kompetanse 2026](https://www.figma.com/design/zYzcXLwDsgoqAhvZ8X1ron/Min-Kompetanse-2026?node-id=3920-14210) | [#604](https://github.com/sikt-no/fs/issues/604) | |

## Åpne spørsmål

- [ ] Kravet viser til `se_digitale_resultater_i_søknad.design.md`, men fila finnes ikke. Den lages med `fs-implementasjonsdetaljer` (eller av `fs-specify`).
- [ ] #604 sier fortsatt at `@KOM-RES-RES-001` er en avhengighet. Det falt bort 25.09.2026, så issuet bør oppdateres.
