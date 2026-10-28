# Mal: Testrapport

Fire varianter, én per nivå: `verifisering` (fase 1), `agentisk` (fase 2), `intern` (fase 3) og `ekstern` (fase 4) i flyten i [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326). Testrapporten er sluttrapporten strategien snakker om: resultatet, funnene og beslutningen. Den agentiske rapporten har ingen beslutning, bare om inngangskriteriet til intern akseptansetest er oppfylt.

- **Varianter** er merket med `[…]`. En linje eller seksjon med et merke er med bare på det nivået. Merket skrives ikke i rapporten.
- **Tall regnes ut** fra tabellene (verify-rapporten, `resultat.md` fra kjøringen, eller «Status» i testcasene), og skal stemme med dem.
- **Felt som testansvarlig eller deltakerne fyller ut** («Beslutning», «Kontrollert av», «Gjennomgått av testansvarlig», «Bekreftet av deltakerne»), står med `[Fylles ut av …]`. Skillen fyller dem aldri ut.

Fila skrives til `akseptansetest/<testplan-slug>/testrapport-<nivå>-<YYYY-MM-DD>.md` (`-2`, `-3` … hvis fila finnes). Alt over den første streken er metadata for repoet, og publiseres ikke.

````markdown
# Testrapport – <verifisering | agentisk funksjonstest | intern akseptansetest | ekstern akseptansetest> – <leveranse>

- **Nivå**: verifisering | agentisk | intern | ekstern
- **Fase**: 1 | 2 | 3 | 4
- **Testplan**: [testplan.md](testplan.md) · <Confluence-url>
- **Scope**: @scope-<slug>[, …] | –
- **Grunnlag**: <verify-fil, `kjoring-<YYYY-MM-DD-HHMM>/resultat.md`, eller URL til testsiden>, lest <YYYY-MM-DD HH:MM>
- **Confluence**: –
- **Laget**: <YYYY-MM-DD> av fs-testrapport

---

Testrapport for «<leveranse>». <Én setning: hva rapporten bygger på (verifiseringen fra <dato> / den agentiske kjøringen <dato> / den interne akseptansetesten <dato> / den eksterne akseptansetesten <dato>).>

## Oppsummering

<verifisering>
| Felt | Innhold |
|---|---|
| Scenarioer | <N> funnet, <N> ikke funnet, <N> usikker, av <N>   (bare kravene, ikke radene for flytene) |
| Krav levert (`@implemented`) | <N> av <N>, og <N> delvis levert |
| Åpne spørsmål som står igjen | <N> regler og <N> scenarioer i testen (stopper ikke testen), eller «Ingen» |
| Regler i koden uten scenario | <N> funnet, <N> skal testes i fase 2, <N> bør få scenario (`fs-krav`), eller «Ingen» |
| Tilgangsstyring og datakonsistens (kodenivå) | <N> sjekker funnet, av <N>, eller «Ikke sjekket» |
| Overleveringer i flytene | <N> funnet, av <N> i testplanen (en `@implemented` flyt teller som funnet), eller «Ingen flyter» |
| Kontrollert av | [Fylles ut av teamet] (en annen enn den som kjørte `fs-verify`) |
| Klar for agentisk funksjonstest | Ja / Ja, med forbehold: <overleveringene som ikke er funnet> / Nei: <grunn> |

<agentisk>
| Felt | Innhold |
|---|---|
| Kjøring | <kjoring-YYYY-MM-DD-HHMM>, kjørt av <hvem startet agenten>, mot <testmiljø og versjon> |
| Testcaser | <N> bestått, <N> ikke bestått, <N> ikke testet, <N> ikke fylt ut, av <N>   (foreslått av agenten) |
| Fra scenarioene i kravene | <N> testcaser |
| Utledet av agenten | <N> testcaser (regler uten scenario, negativ testing, obligatoriske felt) |
| Funn | <N> Stopper, <N> Må fikses før innføring, <N> Kan fikses senere. Av dem <N> «Kravet dekker ikke» |
| Testdata | <testdataene i testplanen fantes eller ble laget: ja / nei: <hvilke som manglet>> |
| Gjennomgått av testansvarlig | [Fylles ut av testansvarlig] |
| Stikkprøve av beståtte testcaser | [Fylles ut av testansvarlig]   (størrelsen avgjøres etter en risikovurdering, det er ikke noe fast antall) |
| Inngangskriterium til intern akseptansetest | Oppfylt / Ikke oppfylt (se «Inngangskriteriet til intern akseptansetest») |

<intern / ekstern>
| Felt | Innhold |
|---|---|
| Testcaser | <N> bestått, <N> ikke bestått, <N> ikke testet, <N> ikke fylt ut, av <N> |
| Funn | <N> Stopper, <N> Må fikses før innføring, <N> Kan fikses senere. Av dem <N> «Kravet dekker ikke» (intern) / <N> feil (avvik fra kravene våre) og <N> endringsforslag (krav vi ikke har) (ekstern) |
| Testet av | <fra testsiden> |
| Testperiode | <dato> |
| Forslag til utfall | Godkjent / Godkjent med forbehold / Ikke godkjent: <grunn> |

## Inngangskriteriet til intern akseptansetest                       [agentisk]

Sjekkes for seg, fordi det er inngangen til fase 3. Den agentiske rapporten har ingen beslutning, bare dette.

| Kriterium | Oppfylt |
|---|---|
| Alle testcasene er kjørt (ingen «ikke fylt ut», og «ikke testet» har begrunnelse) | Ja / Nei: <N> ikke kjørt, <N> «ikke testet» uten begrunnelse |
| Ingen funn med «Stopper» står åpne | Ja / Nei: <funnene> |
| Testansvarlig har gått gjennom rapporten, også funnene og stikkprøven av de beståtte | [Fylles ut av testansvarlig] |

## Resultat per krav

<verifisering: fra «Oversikt per krav» eller «Scenarioer» i verify-rapporten>
| Oppgave | Krav | Funnet | Ikke funnet | Usikker | Status |
|---|---|---|---|---|---|
| <oppgave> | [<tittel>](<lenke>) | <n> | <n> | <n> | `@implemented` / `@in-progress` (delvis levert) / `@in-progress` |

<agentisk: per krav og regel, med teknikken agenten brukte>
| Krav | Regel | Teknikk | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|---|
| [<tittel>](<lenke>) | <regel, eller «Uten scenario: <regel i koden>»> | Positiv / Grenseverdi / Ekvivalensklasse / Beslutningstabell / Tilstandsovergang / Obligatorisk felt | <n> | <n> | <n> |

<intern: per flyt, med én rad per scenario i flyten (flyttestcasene). Testcaser for regresjon og avhengigheter står for seg, per oppgave, krav og regel>
| Flyt | Scenario i flyten | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|
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

## Regler uten scenario                                                [verifisering, agentisk]

<verifisering: fra verify-rapporten. agentisk: om hver regel er testet i fase 2>

| Krav | Regel i koden | Funnet i | Testet i fase 2 | Kravet bør få scenario |
|---|---|---|---|---|
| `@DOM-SUB-KAP-NNN` | <validering eller tilgangssjekk> | `<repo>/<fil>:<linje>` | ja / nei: <grunn> | ja (`fs-krav`) / nei |

Ingen.                                                                  [når tabellen er tom]

## Testdata og bevis                                                   [agentisk]

| Felt | Innhold |
|---|---|
| Testdata | <testdataene fra testplanen som ble brukt, og de som manglet eller var i feil tilstand> |
| Kan kjøres på nytt | Ja / Nei: <grunn> |
| Bevis | `akseptansetest/<slug>/kjoring-<YYYY-MM-DD-HHMM>/` (`resultat.md` er i git, skjermbilder er lokale og ikke i git) |

## Ikke bestått                                                        [agentisk, intern, ekstern]

| Nr | Scenario | Faktisk resultat | Funn |
|---|---|---|---|

Ingen.                                                                  [når tabellen er tom]

## Bestått, men faktisk resultat avviker                               [agentisk, intern, ekstern]

Testcaser med status «Bestått» der «Faktisk resultat» beskriver noe annet enn forventet resultat. Testansvarlig ser på dem og avgjør status. Skillen endrer ikke statusen.

| Nr | Scenario | Forventet resultat | Faktisk resultat |
|---|---|---|---|

Ingen.                                                                  [når tabellen er tom]

## Ikke testet                                                         [agentisk, intern, ekstern]

Testansvarlig vurderer begrunnelsene før beslutningen.

| Nr | Scenario | Begrunnelse |
|---|---|---|

Ingen.                                                                  [når tabellen er tom]

## Funn                                                                [agentisk, intern, ekstern]

Sortert etter alvorlighetsgrad. «Fase funnet» er 2 (agentisk), 3 (intern) eller 4 (ekstern). Typen er «Feil» eller «Kravet dekker ikke» (fase 2 og 3), og «Feil (avvik fra kravene våre)» eller «Endringsforslag (krav vi ikke har)» (fase 4). «Kravet dekker ikke» og «Endringsforslag» avklares i kravet, ikke bare i testen.

| # | Fase funnet | Testcase | Type | Hva skjedde | Alvorlighetsgrad | Sak | Oppfølging |
|---|---|---|---|---|---|---|---|
| | 2 / 3 / 4 | | Feil | | Stopper | | Feil i løsningen / Feil (avvik fra kravene våre): teamet lager oppgave · Kravet dekker ikke / Endringsforslag: `fs-krav`, med spørsmålet · Testcasen var feil · Utenfor testen |

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

Agenten kan ikke ta beslutningen, og den agentiske rapporten har ingen beslutning.

| Felt | Innhold |
|---|---|
| Utfall | [Fylles ut av testansvarlig] / [Fylles ut av deltakerne] |
| Begrunnelse | |
| Besluttet av og dato | |
| Bekreftet av deltakerne | [Fylles ut av deltakerne]                    [ekstern] |

<Tabellen «Beslutning» fra `alvorlighetsgrad.md`, ordrett, under feltene.>

## Neste steg

<verifisering: Klar → `fs-testcaser-cdp` (testcasene for fase 2, laget etter testplanen). Ikke klar → det som mangler, per repo, tilbake til teamet.>
<agentisk: Inngangskriteriet oppfylt → `fs-testcaser-intern` (flyttestene for fase 3). Ikke oppfylt → «Stopper»-funn tilbake til teamet og ny kjøring, og testansvarlig går gjennom rapporten. «Kravet dekker ikke»-funn → `fs-krav`, med spørsmålet.>
<intern: Godkjent → `fs-testcaser-ekstern` (eller innføring, når ekstern test ikke er aktuell). Godkjent med forbehold → retting og ny test av funnene. Ikke godkjent → tilbake til teamet.>
<ekstern: grunnlaget for rapporten til styringsgruppen.>

## Læring                                                             [agentisk, intern, ekstern]

Fylles ut etter det korte møtet mellom testerne og teamlederne.

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
- Testcaser som var feil eller uklare: <fra «Funn» med oppfølgingen «Testcasen var feil»>
- Funn i fase 3 og 4 som fase 2 burde fanget (feltvalidering, feilsituasjoner): <fra «Funn»>   [intern, ekstern]
- Regler uten scenario som burde vært i kravet: <fra «Regler uten scenario»>   [agentisk]
````
