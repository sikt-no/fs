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

Funn føres i tabellen «Funn» på testsiden for fasen (undersiden til testplanen, eller `resultat.md` for den agentiske testen), med fasen funnet ble gjort i og typen. Testrapporten for fasen samler dem:

| # | Fase | Testcase | Type | Hva skjedde | Hva var forventet | Steg for å gjenskape | Skjermbilde | Alvorlighetsgrad | Sak |
|---|---|---|---|---|---|---|---|---|---|

Et funn beskriver hva som skjedde, hva som var forventet, steg for å gjenskape, skjermbilde og lenke til sak. Teamet lager oppgaver for det som skal rettes, og lenker til dem i «Sak».

**Fase** er fasen funnet ble gjort i: `1` (verifisering), `2` (agentisk funksjonstest), `3` (intern akseptansetest) eller `4` (ekstern akseptansetest).

**Type:**

| Type | Fase | Betyr | Hvor følges det opp |
|---|---|---|---|
| Feil | 1–3 | Løsningen gjør noe annet enn kravet sier | Teamet lager oppgave (`Sak`) |
| Kravet dekker ikke | 2 og 3 | Et tilfelle som kravet ikke sier noe om, og løsningen oppfører seg uventet (for eksempel utledet av agenten fra en regel) | Avklares i kravet med `fs-krav`, ikke bare i testen |
| Feil | 4 | Flyten lar ikke testeren gjøre jobben, eller løsningen avviker fra kravene Sikt har gått gjennom | Teamet lager oppgave (`Sak`) |
| Endringsforslag | 4 | Et behov flyten ikke dekker | Går til kravarbeidet (`fs-krav`), der Sikt vurderer om det skal følges opp raskt eller vente |

I fase 4 heter «Kravet dekker ikke» endringsforslag. Testerne trenger ikke finne årsaken: er de usikre på om noe er feil, vurderer kontaktpersonen det. Observasjoner utenfor testens omfang, for eksempel om brukervennlighet, merkes slik, og kontaktpersonen vurderer hvor de følges opp.

Er typen uklar, står funnet som «Feil» til testansvarlig (i fase 4 kontaktpersonen) har vurdert det.

## Beslutning

Fase 3 og 4 bruker de samme tre utfallene. I fase 4 kalles godkjent og godkjent med forbehold «Akseptert» i flyten.

| Utfall | Hva skjer videre |
| --- | --- |
| Godkjent | Leveransen går videre til ekstern akseptansetest eller til innføring. |
| Godkjent med forbehold | Kjente mangler listes i sluttrapporten, med ansvarlig og frist. Rettingen testes før innføring. |
| Ikke godkjent | Leveransen går tilbake til teamet med funnene (i fase 3 og 4). |

Testansvarlig skriver beslutningen og begrunnelsen i sluttrapporten. Rettede funn testes på nytt i versjonen som skal godkjennes. Etter den eksterne akseptansetesten er beslutningen vurdert mot flytene og kravene, og hvem som beslutter, er avtalt med partene før testen. Kontaktpersonen går gjennom resultatet med partene.

## Forslag til utfall

`fs-testrapport` foreslår et utfall, men bestemmer det aldri. Agenten i den agentiske funksjonstesten (fase 2) kan heller ikke godkjenne en leveranse: rapporten fra fase 2 sier bare om leveransen er klar for intern akseptansetest, ut fra inngangskriteriet i strategien (alle testcasene kjørt, ingen funn med «Stopper» åpne, og testansvarlig har gått gjennom rapporten). Reglene under gjelder rapportene fra fase 3 og 4:

1. Minst ett funn med «Stopper», eller en testcase med «Ikke bestått» uten funn: **Ikke godkjent**.
2. Ellers minst ett funn med «Må fikses før innføring»: **Godkjent med forbehold**.
3. Ellers: **Godkjent**, med funnene som «Kan fikses senere» i oppgavelista til teamet.

Endringsforslag (fase 4) gir ikke utfall alene: de går til kravarbeidet, og får «Kan fikses senere» med mindre testansvarlig vurderer noe annet.

«Ikke testet» gir ikke et utfall alene. Testansvarlig vurderer begrunnelsene før beslutningen, og rapporten lister dem.

En testcase med «Ikke bestått» uten et funn i tabellen er en mangel i utfyllingen. Rapporten sier fra om den.
