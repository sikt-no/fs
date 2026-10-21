# Funn, alvorlighetsgrad og beslutning

Fra [teststrategien](https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/5117902850) (*Funn og alvorlighetsgrad* og *Beslutning*). Tekstene står ordrett i testplanen, på testsidene og i testrapportene. Er strategien endret etter denne fila, si fra, og følg strategien.

## Alvorlighetsgrad

| Alvorlighetsgrad | Hva slags feil | Gir utfallet |
| --- | --- | --- |
| Stopper | Kritiske feil som stopper systemet eller har alvorlige konsekvenser | Ikke godkjent |
| Må fikses før innføring | Vesentlige feil som påvirker funksjonaliteten, men der det finnes midlertidige løsninger | Godkjent med forbehold |
| Kan fikses senere | Mindre feil, for eksempel skrivefeil eller visuelle avvik, og ønsker om ny funksjonalitet | Godkjent. Funnet legges i oppgavelista til teamet. |

Et funn med alvorlighetsgraden «Stopper» gir ikke godkjent, men resten av testcasene testes hvis det er mulig.

## Funn

Funn føres i tabellen «Funn» på testsiden:

| # | Testcase | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|

Teamet lager oppgaver for det som skal rettes, og lenker til dem i «Sak».

## Beslutning

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene. |

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Hvem som beslutter etter den eksterne akseptansetesten, avklares med de eksterne partene.

## Forslag til utfall

`fs-testrapport` foreslår et utfall, men bestemmer det aldri:

1. Minst ett funn med «Stopper», eller en testcase med «Ikke bestått» uten funn: **Ikke godkjent**.
2. Ellers minst ett funn med «Må fikses før innføring»: **Godkjent med forbehold**.
3. Ellers: **Godkjent**, med funnene som «Kan fikses senere» i oppgavelista til teamet.

«Ikke testet» gir ikke et utfall alene. Testansvarlig vurderer begrunnelsene før beslutningen, og rapporten lister dem.

En testcase med «Ikke bestått» uten et funn i tabellen er en mangel i utfyllingen. Rapporten sier fra om den.
