# language: no
# GitHub: #216, #598
@OPT-OVO-INN-002 @must @draft @scope-plasstildeling-2027
Egenskap: Sette standard plassflyt for opptaket
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å sette én standard plassflyt for opptaket
  slik at ledige plasser går videre til riktig utdanningskvote på alle utdanningstilbud i opptaket.

  # Flyttet hit 2026-10-13 fra 14 Plasstildeling/02 Tildelingsinnstillinger/plassflyt.feature.
  # Hva plasstildelingen gjør med plassflyten, står der.
  # AVKLART 2026-10-13: Standard plassflyt settes på opptaket, og gjelder alle utdanningstilbud i opptaket
  # som har fått registrert utdanningskvoter. Det finnes nøyaktig én sistekvote for hele opptaket (i UHG:
  # Ordinær), og en kjede av kvoter kan lede fram til den. Hvilke kvoter som finnes, varierer mellom
  # utdanningstilbudene, men rekkefølgen i kjeden og sistekvoten er den samme. En kvote kan ha flere
  # mottakere i prioritert rekkefølge (HK-dir: Samisk til Nordland, Troms og Finnmark, deretter
  # Nordnorsk, deretter Ordinær).
  #
  # ÅPNE SPØRSMÅL:
  # - Kan standard plassflyt for opptaket overstyres per utdanningstilbud?
  #   Se også opptaksinnstillinger_utdanningstilbud.feature.
  # - Sirkulær plassflyt håndteres i koden, men ikke i databasen. Skal den avvises når den settes
  #   (slik scenarioet under sier), eller bare håndteres i plasstildelingen?
  # - Plassflyt finnes på tre nivåer i koden (kvotetype i regelverket, utdanningskvote i opptaket, og per
  #   plasstildeling). Skal opptaksforvalter kunne endre plassflyten per plasstildelingsrunde?
  #
  # Vernet mot sirkulær plassflyt kommer fra GitHub #598.

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Standard plassflyt settes på opptaket og gjelder alle utdanningstilbud

    Scenario: Sette standard plassflyt for opptaket
      Når opptaksforvalter setter standard plassflyt for opptaket "Samordna opptak 2027"
      Så gjelder plassflyten for alle utdanningstilbud i opptaket som har fått registrert utdanningskvoter

  Regel: Opptaket har nøyaktig én sistekvote

    Scenario: Én sistekvote for hele opptaket
      Når opptaksforvalter setter standard plassflyt for opptaket
      Så er det nøyaktig én sistekvote, som ikke sender ledige plasser videre
      Og alle andre kvoter sender ledige plasser videre i en kjede som ender i sistekvoten

    Scenariomal: Opptaket må ha nøyaktig én sistekvote
      Når opptaksforvalter setter standard plassflyt slik at <tilfelle>
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at opptaket må ha nøyaktig én sistekvote

      Eksempler:
        | tilfelle                                    |
        | alle kvotene sender plasser videre          |
        | to kvoter ikke sender plasser videre        |

  Regel: Plassflyten kan ikke gå i ring

    Scenario: Sirkulær plassflyt
      Gitt at ledige plasser i "Førstegangsvitnemål" flyter til "Ordinær" i standard plassflyt for opptaket
      Når opptaksforvalter setter at ledige plasser i "Ordinær" skal flyte til "Førstegangsvitnemål"
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at plassflyten ikke kan gå i ring
