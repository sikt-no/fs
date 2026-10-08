# language: no
# GitHub: #591, #592
@OPT-OPT-UTD-006 @must @draft
Egenskap: Fange opp endringer fra utdanningsregisteret
  Som opptaksforvalter
  ønsker jeg at endringer på utdanninger i utdanningsregisteret kommer med over i opptaket
  slik at utdanningstilbudene i opptaket alltid stemmer med utdanningsregisteret.

  # Kilde: GitHub #591 og #592.
  # Overføringen fra SIS til utdanningsregisteret er på plass. Overføringen fra utdanningsregisteret
  # til opptak gjenstår. Opptak lagrer en kopi av navnet på studieprogrammet for søk, så kopien må
  # oppdateres når navnet endres.
  # Å trekke et utdanningstilbud er beskrevet i 02 Utdanningstilbud i opptak/trekke_utdanningstilbud.feature.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at utdanningstilbudet "Sykepleie, høst 2027" er lagt til i opptaket "Samordna opptak 2027"

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Skal søkere som allerede har søkt, se det nye navnet?
  # - Skal navneendringer etter søknadsåpning varsles til opptaksforvalter?
  Regel: Navneendringer i utdanningsregisteret kommer med over i opptaket (#591)

    Scenario: Studieprogrammet får nytt navn
      Når studieprogrammet "Sykepleie" får navnet "Bachelor i sykepleie" i utdanningsregisteret
      Så har utdanningstilbudet navnet "Bachelor i sykepleie, høst 2027" i opptaket

    Scenario: Søk finner utdanningstilbudet på det nye navnet
      Gitt at studieprogrammet "Sykepleie" har fått navnet "Bachelor i sykepleie" i utdanningsregisteret
      Når opptaksforvalter søker på "Bachelor i sykepleie"
      Så finner opptaksforvalter utdanningstilbudet "Bachelor i sykepleie, høst 2027"

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Trekkes utdanningstilbudet automatisk, eller må opptaksforvalter trekke det selv?
  # - Hvem får beskjed: opptaksforvalter ved lærestedet, ved forvaltende organisasjon, eller begge?
  # - Hva skjer hvis utdanningsinstansen deaktiveres etter trekkfristen?
  Regel: Deaktivering i utdanningsregisteret fanges opp i opptaket (#592)

    Scenario: Utdanningsinstansen deaktiveres
      Når utdanningsinstansen for "Sykepleie, høst 2027" blir deaktivert i utdanningsregisteret
      Så får opptaksforvalter beskjed om at utdanningstilbudet er deaktivert i utdanningsregisteret
      Og opptaksforvalter kan trekke utdanningstilbudet fra opptaket

    Scenario: Deaktivert utdanningsinstans er ikke tilgjengelig
      Gitt at utdanningsregisteret har en instans av bachelorprogrammet "Vernepleie" med studiestart høst 2027
      Og at utdanningstilbudet "Vernepleie, høst 2027" ikke er lagt til i opptaket
      Når utdanningsinstansen blir deaktivert i utdanningsregisteret
      Så er utdanningstilbudet "Vernepleie, høst 2027" ikke lenger tilgjengelig i opptaket

  Regel: Reaktivering i utdanningsregisteret fanges opp i opptaket (#592)

    Scenario: Reaktivert utdanningsinstans blir tilgjengelig igjen
      Gitt at utdanningsinstansen for "Vernepleie, høst 2027" er deaktivert i utdanningsregisteret
      Og at utdanningstilbudet ikke er lagt til i opptaket
      Når utdanningsinstansen blir reaktivert i utdanningsregisteret
      Så er utdanningstilbudet "Vernepleie, høst 2027" tilgjengelig i opptaket igjen

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Legges et trukket utdanningstilbud inn i opptaket igjen når utdanningsinstansen reaktiveres,
    #   eller må opptaksforvalter legge det til på nytt?
    Scenario: Utdanningsinstans for et trukket utdanningstilbud reaktiveres
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" er trukket fra opptaket etter deaktivering
      Når utdanningsinstansen blir reaktivert i utdanningsregisteret
      Så får opptaksforvalter beskjed om at utdanningsinstansen er reaktivert
