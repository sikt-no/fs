# language: no
@OPT-PLA-RES-005 @could @draft @scope-plasstildeling-2027 @depends-on-OPT-PLA-RES-002
Egenskap: Planlegge publiseringen av resultatet
  Som opptaksforvalter
  ønsker jeg å bestemme på forhånd når resultatet av en plasstildeling publiseres
  slik at søkerne får svar på tidspunktet som er annonsert.

  # Skilt ut 2026-10-28 (produkteier) fra publisere_resultat.feature. Til dette er levert, publiseres resultatet
  # når opptaksforvalter velger å publisere.

  Bakgrunn:
    Gitt at opptakets forvalter er innlogget
    Og at plasstildelingsrunden "Hovedrunde" i opptaket "Samordna opptak 2027" har en plasstildeling som ikke er publisert

  @openquestion
  Regel: Opptaksforvalter velger tidspunkt for publisering

    # ÅPNE SPØRSMÅL:
    # - Automatisk publisering på tidspunkt er avgrenset bort for 2027 (oppgave.md). Confluence
    #   «Opprette og konfigurere opptakskjøringsrunde» beskriver publisering straks eller planlagt.
    #   Skal planlagt publisering være med?
    Scenario: Planlagt publisering
      Når opptaksforvalter planlegger publisering av plasstildelingen til "2027-07-15 08:00"
      Så ser søkerne resultatet sitt fra "2027-07-15 08:00"
