# Mal: Testrapport

Tre varianter, én per nivå: `verifisering` (steg 3), `intern` (steg 5) og `ekstern` (steg 7) i flyten i [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850). Testrapporten er sluttrapporten strategien snakker om: resultatet, funnene og beslutningen.

- **Varianter** er merket med `[…]`. En linje eller seksjon med et merke er med bare på det nivået. Merket skrives ikke i rapporten.
- **Tall regnes ut** fra tabellene (verify-rapporten, eller «Status» i testcasene), og skal stemme med dem.
- **Felt som testansvarlig eller deltakerne fyller ut** («Beslutning», «Kontrollert av», «Bekreftet av deltakerne»), står med `[Fylles ut av …]`. Skillen fyller dem aldri ut.

Fila skrives til `akseptansetest/<testplan-slug>/testrapport-<nivå>-<YYYY-MM-DD>.md` (`-2`, `-3` … hvis fila finnes). Alt over den første streken er metadata for repoet, og publiseres ikke.

````markdown
# Testrapport – <verifisering | intern akseptansetest | ekstern akseptansetest> – <leveranse>

- **Nivå**: verifisering | intern | ekstern
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Scope**: @scope-<slug>[, …] | –
- **Grunnlag**: <verify-fil, eller URL til testsiden>, lest <YYYY-MM-DD HH:MM>
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testrapport

---

Testrapport for «<leveranse>». <Én setning: hva rapporten bygger på (verifiseringen fra <dato> / den interne akseptansetesten <dato> / den eksterne akseptansetesten <dato>).>

## Oppsummering

<verifisering>
| Felt | Innhold |
|---|---|
| Scenarioer | <N> funnet, <N> ikke funnet, <N> usikker, av <N>   (bare kravene, ikke radene for flytene) |
| Krav levert (`@implemented`) | <N> av <N> |
| Åpne spørsmål som står igjen | <N> |
| Overleveringer i flytene | <N> funnet, av <N> i testplanen (en `@implemented` flyt teller som funnet), eller «Ingen flyter» |
| Kontrollert av | [Fylles ut av teamet] (en annen enn den som kjørte `fs-verify`) |
| Klar for intern akseptansetest | Ja / Ja, med forbehold: <overleveringene som ikke er funnet> / Nei: <grunn> |

<intern / ekstern>
| Felt | Innhold |
|---|---|
| Testcaser | <N> bestått, <N> ikke bestått, <N> ikke testet, <N> ikke fylt ut, av <N> |
| Funn | <N> Stopper, <N> Må fikses før innføring, <N> Kan fikses senere |
| Testet av | <fra testsiden> |
| Testperiode | <dato> |
| Forslag til utfall | Godkjent / Godkjent med forbehold / Ikke godkjent: <grunn> |

## Resultat per krav

<verifisering: fra «Oversikt per krav» eller «Scenarioer» i verify-rapporten>
| Oppgave | Krav | Funnet | Ikke funnet | Usikker | Status |
|---|---|---|---|---|---|
| <oppgave> | [<tittel>](<lenke>) | <n> | <n> | <n> | `@implemented` / `@in-progress` |

<intern: per oppgave, krav og regel, som testcasene. En flyt står etter kravene, med flyten i «Krav» og fasen i «Regel»>
| Oppgave | Krav | Regel | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|---|

<ekstern: per testcase (oppgave i arbeidsprosessen), og per scenario i den>
| Testcase | Scenario | Status |
|---|---|---|

## Flyter                                                             [verifisering]

Fra «Flyter» i testplanen, og fremdriften og overleveringene i verify-rapporten.

| Flyt | Testes | Faser levert | Overleveringer funnet | Kjent brudd |
|---|---|---|---|---|
| <tittel> (`@FLY-PRO-FLY-NNN`) | hele flyten / deler av flyten | <n> av <N> | <n> av <N> i testen | <bruddet, eller «–»> |

Ingen av kravene er med i en flyt.                                     [når det ikke er flyter]

## Det som mangler                                                     [verifisering]

| Krav | Scenario | Resultat | Hva som mangler | Repo |
|---|---|---|---|---|
| <krav> | <scenario> | ikke funnet / usikker | <fra Bevis> | <fs-plattform / fs-admin / min-kompetanse> |
| <flyt: fasen> | <scenario> | ikke funnet / ikke verifisert | <lages: … · brukes: ikke funnet> | <repo> |

Ingen.                                                                  [når tabellen er tom]

## Ikke bestått                                                        [intern, ekstern]

| Nr | Scenario | Faktisk resultat | Funn |
|---|---|---|---|

Ingen.                                                                  [når tabellen er tom]

## Ikke testet                                                         [intern, ekstern]

Testansvarlig vurderer begrunnelsene før beslutningen.

| Nr | Scenario | Begrunnelse |
|---|---|---|

Ingen.                                                                  [når tabellen er tom]

## Funn                                                                [intern, ekstern]

Sortert etter alvorlighetsgrad.

| # | Testcase | Hva skjedde | Alvorlighetsgrad | Sak | Oppfølging |
|---|---|---|---|---|---|
| | | | Stopper | | Feil i løsningen / Uklart krav: `fs-krav` / Testcasen var feil / Utenfor testen |

Ingen.                                                                  [når tabellen er tom]

## Andre funn                                                          [intern, ekstern]

<Det testerne skrev under «Andre funn», ordrett, med forslag til hvem som følger opp.>

## Kjente mangler                                                      [intern, ekstern]

Bare ved «Godkjent med forbehold».

| Mangel | Ansvarlig | Frist |
|---|---|---|
| <fra funnene med «Må fikses før innføring»> | [Fylles ut av teamet] | [Fylles ut av teamet] |
| <kjent brudd i en flyt (`# Kjent brudd:`), med saken> | [Fylles ut av teamet] | [Fylles ut av teamet] |

## Beslutning                                                          [intern, ekstern]

| Felt | Innhold |
|---|---|
| Utfall | [Fylles ut av testansvarlig] / [Fylles ut av deltakerne] |
| Begrunnelse | |
| Besluttet av og dato | |
| Bekreftet av deltakerne | [Fylles ut av deltakerne]                    [ekstern] |

<Tabellen «Beslutning» fra `alvorlighetsgrad.md`, ordrett, under feltene.>

## Neste steg

<verifisering: Klar → `fs-testcaser-intern`. Ikke klar → det som mangler, per repo, tilbake til teamet.>
<intern: Godkjent → `fs-testcaser-ekstern` (eller innføring, når ekstern test ikke er aktuell). Godkjent med forbehold → retting og ny test av funnene. Ikke godkjent → tilbake til teamet.>
<ekstern: grunnlaget for rapporten til styringsgruppen.>

## Læring                                                             [intern, ekstern]

Fylles ut etter det korte møtet mellom testerne og teamlederne.

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
- Testcaser som var feil eller uklare: <fra «Funn» med oppfølgingen «Testcasen var feil»>
````
