# Funn, alvorlighetsgrad og beslutning

Fra [teststrategien (forslag)](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5145100326) (*Funn og alvorlighetsgrad* og *Beslutning*). Tekstene står ordrett i testplanen, på testsidene og i testrapportene. Er strategien endret etter denne fila, si fra, og følg strategien.

## Alvorlighetsgrad

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig.

## Funn

Funn føres i tabellen «Funn» på testsiden og i testplanen, med fasen funnet ble gjort i og typen:

| # | Fase | Testcase | Type | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|---|---|

Et funn beskriver hva som skjedde, hva som var forventet, steg for å gjenskape, skjermbilde og lenke til sak. Teamet lager oppgaver for det som skal rettes, og lenker til dem i «Sak».

**Fase** er fasen funnet ble gjort i: `1` (verifisering), `2` (agentisk funksjonstest), `3` (intern akseptansetest) eller `4` (ekstern akseptansetest).

**Type:**

| Type | Fase | Betyr | Hvor følges det opp |
|---|---|---|---|
| Feil | 1–3 | Løsningen gjør noe annet enn kravet sier | Teamet lager oppgave (`Sak`) |
| Kravet dekker ikke | 2 og 3 | Et tilfelle som kravet ikke sier noe om, og løsningen oppfører seg uventet (for eksempel utledet av agenten fra en regel) | Avklares i kravet med `fs-krav`, ikke bare i testen |
| Avvik fra krav | 4 | Løsningen avviker fra kravene våre (en feil) | Teamet lager oppgave (`Sak`) |
| Endringsforslag | 4 | Et krav vi ikke har | Går til kravarbeidet (`fs-krav`) |

Er typen uklar, står funnet som «Feil» (fase 1–3) eller «Avvik fra krav» (fase 4) til testansvarlig har vurdert det.

## Beslutning

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Hvem som beslutter etter den eksterne akseptansetesten, avklares med de eksterne partene.

## Forslag til utfall

`fs-testrapport` foreslår et utfall, men bestemmer det aldri. Agenten i den agentiske funksjonstesten (fase 2) kan heller ikke godkjenne en leveranse: rapporten fra fase 2 sier bare om leveransen er klar for intern akseptansetest, ut fra inngangskriteriet i strategien (alle testcasene kjørt, ingen funn med «Stopper» åpne, og testansvarlig har gått gjennom rapporten). Reglene under gjelder rapportene fra fase 3 og 4:

1. Minst ett funn med «Stopper», eller en testcase med «Ikke bestått» uten funn: **Ikke godkjent**.
2. Ellers minst ett funn med «Må fikses før innføring»: **Godkjent med forbehold**.
3. Ellers: **Godkjent**, med funnene som «Kan fikses senere» i oppgavelista til teamet.

Endringsforslag (fase 4) gir ikke utfall alene: de går til kravarbeidet, og får «Kan fikses senere» med mindre testansvarlig vurderer noe annet.

«Ikke testet» gir ikke et utfall alene. Testansvarlig vurderer begrunnelsene før beslutningen, og rapporten lister dem.

En testcase med «Ikke bestått» uten et funn i tabellen er en mangel i utfyllingen. Rapporten sier fra om den.
