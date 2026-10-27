# language: no
# Kilder: koden i fs-plattform (opptak-service: regelverk/poeng og saksbehandling), Jira STEK-68, STEK-76,
# STEK-467 og STEK-533. Poengene fra vitnemålet er et eget krav (@OPT-BEH-BEH-018), og det samme gjelder
# automatisk grunnlag (@OPT-BEH-BEH-019). Kravelementene står i automatisk_kvalifisering.feature (@OPT-BEH-BEH-020).
@OPT-BEH-BEH-028 @must @draft @depends-on-OPT-REG-RAN-002
Egenskap: Automatiske tilleggspoeng
  Som saksbehandler
  ønsker jeg at alderspoeng, kjønnspoeng og poeng for høyere utdanning settes av regelverket
  slik at søkerne rangeres likt, uansett om søknaden behandles av automatikken eller av meg.

  Tilleggspoeng er poeng som ikke kommer fra vitnemålet. Regelverket knytter en poengalgoritme til
  poengtypen, og algoritmen regner ut poengene ut fra opplysninger om søkeren, for eksempel alder og kjønn.
  Poengene regnes ut på samme måte når saksbehandleren velger grunnlaget selv som når automatikken gjør det.

  Regel: Alderspoeng regnes ut fra søkerens alder

    @depends-on-OPT-BEH-BEH-012
    # Regelen «Søkerens alder beregnes på opptakets dato for aldersberegning».
    Scenariomal: Alderspoeng for søkerens alder
      Gitt at poengtypen for alderspoeng er knyttet til algoritmen "<algoritme>"
      Og at søkeren er <alder> år på datoen for aldersberegning
      Når søknaden får grunnlaget "VOV"
      Så har søknaden <poeng> alderspoeng

      Eksempler:
        | algoritme | alder | poeng |
        | ALD_ALG1  | 19    | 0     |
        | ALD_ALG1  | 21    | 2     |
        | ALD_ALG1  | 23    | 4     |
        | ALD_ALG2  | 22    | 6     |
        | ALD_ALG2  | 25    | 8     |
        | ALD_ALG3  | 23    | 0     |
        | ALD_ALG3  | 25    | 4     |
        | ALD_ALG3  | 27    | 8     |

    Scenario: Alderspoengene viser hvilken alder de er regnet ut for
      Gitt at søkeren er 22 år på datoen for aldersberegning
      Og at poengtypen for alderspoeng er knyttet til algoritmen "ALD_ALG1"
      Når søknaden får grunnlaget "VOV"
      Så viser alderspoengene at de er regnet ut for alderen 22 år på datoen for aldersberegning

  Regel: Kjønnspoeng regnes ut fra søkerens kjønn

    Scenariomal: Kjønnspoeng for søkerens kjønn
      Gitt at poengtypen for kjønnspoeng er knyttet til algoritmen "<algoritme>"
      Og at søkeren er <kjønn>
      Når søknaden får grunnlaget "VOV"
      Så har søknaden <poeng> kjønnspoeng

      Eksempler:
        | algoritme  | kjønn  | poeng |
        | KJONN_ALG1 | kvinne | 1     |
        | KJONN_ALG1 | mann   | 0     |
        | KJONN_ALG2 | kvinne | 2     |
        | KJONN_ALG3 | kvinne | -0,1  |
        | KJONN_ALG4 | mann   | 1     |
        | KJONN_ALG5 | mann   | 2     |
        | KJONN_ALG5 | kvinne | 0     |

    Scenario: Kjønnspoengene viser hvilket kjønn de er regnet ut for
      Gitt at søkeren er kvinne
      Og at poengtypen for kjønnspoeng er knyttet til algoritmen "KJONN_ALG1"
      Når søknaden får grunnlaget "VOV"
      Så viser kjønnspoengene at de er regnet ut for kvinne

  # ÅPNE SPØRSMÅL:
  # - Hvilke studiepoeng teller med?
  @openquestion
  Regel: Poeng for høyere utdanning regnes ut fra søkerens studiepoeng

    # Studiepoengene kommer fra tjenesten for resultater fra høyere utdanning. Resultatene hentes og lagres på samme
    # måte som vitnemål fra videregående skole hentes og lagres via KREG.

    Scenariomal: Poeng for høyere utdanning
      Gitt at poengtypen for poeng for høyere utdanning er knyttet til algoritmen for høyere utdanning
      Og at tjenesten for resultater fra høyere utdanning gir søkeren <studiepoeng> studiepoeng
      Når søknaden får grunnlaget "VOV"
      Så har søknaden <poeng> poeng for høyere utdanning

      Eksempler:
        | studiepoeng | poeng |
        | 0           | 0     |
        | 29          | 0     |
        | 30          | 1     |
        | 59          | 1     |
        | 60          | 2     |
        | 120         | 2     |

  Regel: Tilleggspoengene settes uansett hvem som velger grunnlaget

    Scenario: Automatikken velger grunnlaget
      Gitt at søkeren er 23 år på datoen for aldersberegning
      Og at poengtypen for alderspoeng er knyttet til algoritmen "ALD_ALG1"
      Når automatikken velger grunnlaget "VOV" for søknaden
      Så har søknaden 4 alderspoeng

    Scenario: Saksbehandleren velger grunnlaget
      Gitt at søkeren er 23 år på datoen for aldersberegning
      Og at poengtypen for alderspoeng er knyttet til algoritmen "ALD_ALG1"
      Når saksbehandleren velger grunnlaget "VOV" for søknaden
      Så har søknaden 4 alderspoeng

    Scenario: Saksbehandleren får kjønnspoengene grunnlaget gir
      Gitt at søkeren er kvinne
      Og at poengtypen for kjønnspoeng er knyttet til algoritmen "KJONN_ALG2"
      Når saksbehandleren velger grunnlaget "VOV" for søknaden
      Så har søknaden 2 kjønnspoeng

    Scenario: Poengene for grunnlaget som er fjernet, vises ikke lenger
      Gitt at søknaden har grunnlaget "VOV"
      Og at poengtypen for alderspoeng bare gjelder grunnlaget "VOV"
      Når saksbehandleren fjerner grunnlaget "VOV" fra søknaden
      Så ser ikke saksbehandleren alderspoengene på søknaden

    Scenario: Poengene regnes ut på nytt når saksbehandleren endrer grunnlaget
      Gitt at søknaden har grunnlaget "VOV"
      Og at søkeren er 23 år på datoen for aldersberegning
      Og at poengtypen for alderspoeng er knyttet til algoritmen "ALD_ALG1"
      Og at poengtypen for alderspoeng gjelder grunnlagene "VOV" og "PRA"
      Når saksbehandleren endrer grunnlaget til "PRA"
      Så har søknaden 4 alderspoeng

    Scenario: Poengene regnes ikke ut på nytt av seg selv når datoen for aldersberegning endres
      Gitt at søknaden har grunnlaget "VOV"
      Og at søknaden har alderspoeng utregnet på datoen "2027-04-15"
      Når opptaksforvalteren endrer datoen for aldersberegning til "2027-12-31"
      Så har søknaden fortsatt alderspoeng utregnet på datoen "2027-04-15"

    @ref-OPT-BEH-BEH-004
    # Regelen «Poeng beregnes fra det valgte grunnlaget», scenarioet «Poengene er tomme til jeg beregner dem».
    Scenario: Tilleggspoengene regnes ut selv om poengene fra vitnemålet står tomme
      Gitt at søkeren er 23 år på datoen for aldersberegning
      Og at poengtypen for alderspoeng er knyttet til algoritmen "ALD_ALG1"
      Og at poengene fra vitnemålet står tomme til saksbehandleren velger å beregne dem
      Når saksbehandleren velger grunnlaget "VOV" for søknaden
      Så har søknaden 4 alderspoeng

  Regel: Opptaket må ha dato for aldersberegning når alder brukes

    @depends-on-OPT-OVO-FRI-001
    # Regelen «Opptaksforvalter setter dato for aldersberegning».
    Scenario: Grunnlaget kan ikke velges uten dato for aldersberegning
      Gitt at opptaket har en poengtype med alderspoeng
      Og at opptaket ikke har dato for aldersberegning eller dato for publisering av resultatet
      Når saksbehandleren velger grunnlaget "VOV" for søknaden
      Så får saksbehandleren beskjed om at opptaket mangler dato for aldersberegning
      Og grunnlaget er ikke lagt til

    Scenario: Standarddatoen brukes når datoen for aldersberegning ikke er satt
      Gitt at opptaket ikke har dato for aldersberegning
      Og at resultatet publiseres i 2027
      Og at søkeren er 23 år på datoen "2027-12-31"
      Og at poengtypen for alderspoeng er knyttet til algoritmen "ALD_ALG1"
      Når saksbehandleren velger grunnlaget "VOV" for søknaden
      Så har søknaden 4 alderspoeng

  Regel: Saksbehandleren kan overstyre poeng automatikken har satt

    Scenario: Poengene er satt av saksbehandleren og står
      Gitt at saksbehandleren har satt 3 alderspoeng og latt dem stå
      Når automatikken regner ut alderspoeng for søknaden
      Så har søknaden fortsatt 3 alderspoeng

    Scenario: Saksbehandleren overstyrer et alderspoeng som er regnet ut automatisk
      Gitt at søkeren er 23 år på datoen for aldersberegning
      Og at alderspoengene er regnet ut automatisk til 4
      Og at saksbehandleren har endret alderspoengene til 2
      Når automatikken regner ut alderspoeng for søknaden
      Så har søknaden fortsatt 2 alderspoeng

    Scenario: Poengene som er regnet ut automatisk, er merket som det
      Gitt at søkeren er 23 år på datoen for aldersberegning
      Når saksbehandleren velger grunnlaget "VOV" for søknaden
      Så er alderspoengene merket som regnet ut automatisk

    Scenario: Poengene er ikke merket som automatiske etter at saksbehandleren har endret dem
      Gitt at alderspoengene er regnet ut automatisk
      Når saksbehandleren endrer alderspoengene til 2
      Så er alderspoengene ikke merket som regnet ut automatisk

  Regel: Tilleggspoeng som ikke kan regnes ut, forklares

    Scenario: Poengtypen har en algoritme som ikke kan regnes ut
      Gitt at poengtypen for kjønnspoeng er knyttet til en algoritme som ikke kan regnes ut
      Når saksbehandleren velger grunnlaget "VOV" for søknaden
      Så er grunnlaget lagt til
      Og kjønnspoengene står tomme
      Og saksbehandleren ser en merknad om at algoritmen er ukjent

    Scenario: Automatikken fortsetter med de andre poengene når en algoritme ikke kan regnes ut
      Gitt at poengtypen for alderspoeng er knyttet til en algoritme som ikke kan regnes ut
      Og at søknaden har poeng fra vitnemålet som kan regnes ut
      Når automatikken behandler søknaden
      Så regnes poengene fra vitnemålet ut
      Og alderspoengene står tomme med en merknad om at algoritmen er ukjent
      Og søknaden behandles videre
