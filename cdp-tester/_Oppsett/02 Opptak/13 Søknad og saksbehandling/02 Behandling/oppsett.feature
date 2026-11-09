# language: no
# Oppsett for testene i cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/ (samme sti under _Oppsett/)
#
# Kjøres først i hver kjøring. Lager testdataene gjennom løsningen. Agenten skriver det som er satt, i
# «Kjøringens testdata» i resultat.md. Feiler et scenario, får nøkkelen ingen verdi, og testene som bruker den,
# blir «Ikke testet».
#
# Søkerne testene bruker («sak-tidlig-opptak-…»), lages ikke her. De trenger kvalifisering og poengsum i en
# bestemt tilstand, som ikke kan lages gjennom løsningen i én kjøring, og en søker kan ikke brukes på nytt etter
# en gjennomføring. De står som lister i miljøfila. Opptaket, utdanningstilbudene og tilbudsgarantitypene er
# grunndata i miljøfila.
@OPPSETT-OPT-BEH @ref-OPT-BEH-BEH-007
Egenskap: Oppsett for tidligopptaket
  Setter poenggrensene for tidlig opptak på utdanningstilbudene testene bruker, i utgangstilstanden testene
  forutsetter. Testene som endrer en poenggrense, setter den tilbake til verdien her.

  Scenario: poenggrenser-tidlig-opptak
    Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
    Og jeg har åpnet fanen «Tidlig opptak» under «Plasstildeling» i «opptak-tidlig-opptak»
    Når jeg skriver 0 i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak>»
    Og jeg skriver 0 i «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-andre>»
    Og jeg tømmer «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-med-median>»
    Og jeg tømmer «Poenggrense tidlig opptak for <utdanningstilbud-tidlig-opptak-uten-median>»
    Og jeg velger «Lagre poenggrenser»
    Og «Poenggrensene er lagret.» vises
    Og jeg laster inn siden på nytt
    Så står 0 i poenggrensen for «utdanningstilbud-tidlig-opptak» og «utdanningstilbud-tidlig-opptak-andre»
    Og poenggrensen for «utdanningstilbud-tidlig-opptak-med-median» og «utdanningstilbud-tidlig-opptak-uten-median» er tom
    Og «Median i fjor» viser en median for «utdanningstilbud-tidlig-opptak-med-median», og «-» for «utdanningstilbud-tidlig-opptak-uten-median»
    Og jeg skriver poenggrensene i «Kjøringens testdata» for «poenggrenser-tidlig-opptak»
