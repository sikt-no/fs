# Testrapport – intern akseptansetest – Saksbehandling av tidlig opptak

- **Nivå**: intern
- **Fase**: 3
- **Testplan**: [testplan.md](testplan.md) · https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5147721786
- **Scope**: –
- **Grunnlag**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5149065264 (versjon 12), lest 2026-10-30 14:41
- **Confluence**: https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5158928698
- **Laget**: 2026-10-30 av fs-testrapport

---

Testrapport for «Saksbehandling av tidlig opptak». Rapporten bygger på den interne akseptansetesten 2026-10-30, med resultatene testeren har fylt ut på testsiden.

## Oppsummering

| Felt | Innhold |
|---|---|
| Testcaser | 10 bestått, 0 ikke bestått, 0 ikke testet, 0 ikke fylt ut, av 10 |
| Funn | 0 Stopper, 0 Må fikses før innføring, 0 Kan fikses senere. Av dem 0 «Kravet dekker ikke» |
| Testet av | Marit Rønning (fagperson) |
| Testperiode | 2026-10-30 |
| Forslag til utfall | Godkjent: alle testcasene er bestått, og det er ingen funn |

Testen hadde ingen agentisk funksjonstest (fase 2) før seg. Testcasene er laget per krav og regel, ikke per flyt, og ingen av kravene er med i en flyt.

## Resultat per krav

| Oppgave | Krav | Regel | Bestått | Ikke bestått | Ikke testet |
|---|---|---|---|---|---|
| – | Vurdere søknad om tidlig opptak (`@OPT-BEH-BEH-013`) | Saksbehandler ser søkerens grunnlag for tidlig opptak (1.1, 1.2) | 2 | 0 | 0 |
| – | Vurdere søknad om tidlig opptak (`@OPT-BEH-BEH-013`) | Saksbehandler konkluderer om søkeren deltar i tidligopptaket (1.3, 1.4a, 1.4b, 1.5, 1.6a, 1.6b) | 6 | 0 | 0 |
| – | Finne søknader om tidlig opptak (`@OPT-BEH-BEH-009`) | Søk og filtrering av saker på tidlig opptak (2.1, 2.2) | 2 | 0 | 0 |

Scenarioene som er scopet ut av testen, står i «Ikke med i denne testen» i testplanen. Det ene scenarioet som ikke kan testes nå (at konklusjonen per organisasjon gir riktig utfall i tidligopptaket), testes når gjennomføringen av tidligopptaket (`@OPT-BEH-BEH-007`) testes.

## Ikke bestått

Ingen.

## Bestått, men faktisk resultat avviker

Testcaser med status «Bestått» der «Faktisk resultat» beskriver noe annet enn forventet resultat. Testansvarlig ser på dem og avgjør status. Skillen endrer ikke statusen.

| Nr | Scenario | Forventet resultat | Faktisk resultat |
|---|---|---|---|
| 1.3 | Velge blant konklusjonene opptaket har | Da testen ble kjørt: «Listen inneholder «Ikke valgt», «Kan få tidligopptak, har godkjent grunn.» (KFF) og «Ikke dokumentert behov for tidligopptak» (AFH). «Ikke valgt» er valgt.» Etter testen er teksten endret til «Listen inneholder minst …» (versjon 12 av testsiden). | «Inneholder flere alternativer enn de som er nevnt. Inneholder ikke kodene.» |

Kravet sier at saksbehandleren velger blant konklusjonene opptaket har, så flere valg enn de to i testdataene er riktig. Kodene (KFF og AFH) står i testcasen for å skille konklusjonene, og vises ikke i løsningen. Begge deler er uklarheter i testcasen, ikke avvik i løsningen (se «Læring»).

## Ikke testet

Ingen.

## Funn

Ingen.

## Andre funn

Ingen. Tabellen «Andre funn» på testsiden er tom.

## Beslutning

Agenten kan ikke ta beslutningen.

| Felt | Innhold |
|---|---|
| Utfall | [Fylles ut av testansvarlig] |
| Begrunnelse | |
| Besluttet av og dato | |

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Hvem som beslutter etter den eksterne akseptansetesten, avklares med de eksterne partene.

## Neste steg

Godkjent → `fs-testcaser-ekstern`, eller innføring hvis leveransen ikke skal til ekstern akseptansetest. Det er ikke avklart ennå («Eksterne testere» i testplanen står som `[Fylles ut]`).

## Læring

Fylles ut etter det korte møtet mellom testerne og teamlederne.

- Hvilke feil burde vært fanget tidligere?
- Hva bør endres i testprosessen?
- Testcaser som var feil eller uklare: 1.3, 2.1 og 2.2 sa «Listen inneholder …», som kan leses som at listen bare skal inneholde det som er nevnt. Det er endret til «Listen inneholder minst …» etter testen. I 1.3 står kodene for konklusjonene (KFF, AFH) i parentes, men de vises ikke i nedtrekkslisten. Det er beholdt på testsiden, så kommentaren fra testeren fortsatt gir mening, og rettes neste gang testcasene lages.
- Funn i fase 3 og 4 som fase 2 burde fanget (feltvalidering, feilsituasjoner): ingen.
