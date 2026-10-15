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
  # som har fått registrert utdanningskvoter. Det finnes nøyaktig én hovedkvote for hele opptaket (i UHG:
  # Ordinær), og en kjede av kvoter kan lede fram til den. Hvilke kvoter som finnes, varierer mellom
  # utdanningstilbudene, men rekkefølgen i kjeden og hovedkvoten er den samme. En kvote kan ha flere
  # mottakere i prioritert rekkefølge (HK-dir: Samisk til Nordland, Troms og Finnmark, deretter
  # Nordnorsk, deretter Ordinær).
  #
  # ÅPNE SPØRSMÅL:
  # - Kan standard plassflyt for opptaket overstyres per utdanningstilbud?
  #   Se også opptaksinnstillinger_utdanningstilbud.feature.
  # - Plassflyt finnes på tre nivåer i koden (kvotetype i regelverket, utdanningskvote i opptaket, og per
  #   plasstildeling). Skal opptaksforvalter kunne endre plassflyten per plasstildelingsrunde?
  # - Skissen «Kvoter» (Figma node 22410:106608) har en egen fane for kvoteprioritet på opptaket. I dag finnes
  #   kvoteprioriteten per utdanningskvote på utdanningstilbudet (og på kvotetypen i koden). Skal kvoteprioriteten
  #   settes på opptaket, som plassflyten?
  #
  # Vernet mot sirkulær plassflyt kommer fra GitHub #598.
  # Skisse: https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22410-106608

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Standard plassflyt settes på opptaket og gjelder alle utdanningstilbud

    Scenario: Sette standard plassflyt for opptaket
      Når opptaksforvalter setter standard plassflyt for opptaket "Samordna opptak 2027"
      Så gjelder plassflyten for alle utdanningstilbud i opptaket som har fått registrert utdanningskvoter

  Regel: Opptaket har nøyaktig én hovedkvote

    Scenario: Én hovedkvote for hele opptaket
      Når opptaksforvalter setter standard plassflyt for opptaket
      Så er det nøyaktig én hovedkvote, som ikke sender ledige plasser videre
      Og alle andre kvoter sender ledige plasser videre i en kjede som ender i hovedkvoten

    Scenariomal: Opptaket må ha nøyaktig én hovedkvote
      Når opptaksforvalter setter standard plassflyt slik at <tilfelle>
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at opptaket må ha nøyaktig én hovedkvote

      Eksempler:
        | tilfelle                                    |
        | alle kvotene sender plasser videre          |
        | to kvoter ikke sender plasser videre        |

    # AVKLART 2026-10-15 (skisse «Kvoter», Figma node 22410:106608): Opptaksforvalteren må ta aktivt stilling til
    # alle kvotetypene som gjelder for opptaket, og legge dem inn i plassflyten. «Ikke koblet» i skissen er
    # startverdien, ikke et gyldig valg.
    Scenario: Kvotetyper som ikke er koblet, hindrer lagring
      Gitt at kvotetypen "IDRETT" gjelder for opptaket "Samordna opptak 2027"
      Og at kvotetypen "IDRETT" ikke er koblet til plassflyten
      Når opptaksforvalter lagrer standard plassflyt for opptaket
      Så blir plassflyten ikke lagret
      Og opptaksforvalter ser at kvotetypen "IDRETT" må kobles til plassflyten

  Regel: Plassflyten kan ikke gå i ring

    # AVKLART 2026-10-15: Scenarioet blir stående, fordi det er mulig å lage en ring i dag. Kravet om én
    # hovedkvote, som alle kjeder ender i, skal utelukke at ringen oppstår.

    Scenario: Sirkulær plassflyt
      Gitt at ledige plasser i "Førstegangsvitnemål" flyter til "Ordinær" i standard plassflyt for opptaket
      Når opptaksforvalter setter at ledige plasser i "Ordinær" skal flyte til "Førstegangsvitnemål"
      Så blir plassflyten ikke lagret
      Og opptaksforvalter får beskjed om at plassflyten ikke kan gå i ring
