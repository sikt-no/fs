# language: no
# Jira: SHI-710
@OPT-OPT-UTD-026 @must @draft
Egenskap: Fjerne utdanningstilbud fra opptak
  Som opptaksforvalter
  ønsker jeg å fjerne utdanningstilbud som er lagt til i opptaket ved en feil, før opptaket er publisert
  slik at opptaket bare har utdanningstilbudene som skal ha opptak.

  # Etter at opptaket er publisert, kan utdanningstilbud bare trekkes,
  # se trekke_utdanningstilbud.feature.

  Bakgrunn:
    Gitt at opptaksforvalter er innlogget
    Og at opptaket "Samordna opptak 2027" har utdanningstilbud

  Regel: Utdanningstilbud kan fjernes før opptaket er publisert

    Scenario: Fjerne utdanningstilbud før publisering
      Gitt at opptaket ikke er publisert
      Når opptaksforvalter fjerner utdanningstilbudet "Sykepleie, høst 2027" fra opptaket
      Så er utdanningstilbudet ikke lenger med i opptaket

    Scenario: Fjerne flere utdanningstilbud av gangen før publisering
      Gitt at opptaket ikke er publisert
      Når opptaksforvalter fjerner utdanningstilbudene "Sykepleie, høst 2027" og "Vernepleie, høst 2027" fra opptaket
      Så er begge utdanningstilbudene ikke lenger med i opptaket

  Regel: Utdanningstilbud kan ikke fjernes etter at opptaket er publisert

    Scenario: Muligheten til å fjerne utdanningstilbud vises ikke etter publisering
      Gitt at opptaket er publisert
      Når opptaksforvalter ser listen over utdanningstilbud i opptaket
      Så ser ikke opptaksforvalter muligheten til å fjerne utdanningstilbud

    Scenario: Fjerning av utdanningstilbud etter publisering avvises
      Gitt at opptaket er publisert
      Når det sendes en forespørsel om å fjerne utdanningstilbudet "Sykepleie, høst 2027" fra opptaket
      Så avvises forespørselen
      Og utdanningstilbudet er fortsatt med i opptaket

# ÅPNE SPØRSMÅL:
# - Hva betyr at opptaket er «publisert»? Ingen krav i 11 Opprette og vedlikeholde opptak beskriver statusen Publisert. Er det det samme som søknadsåpning?
# - Hvem kan fjerne utdanningstilbud: opptaksforvalter ved deltakende organisasjon (bare utdanningstilbudene organisasjonen har lagt til), ved forvaltende organisasjon, eller begge?
# - Kan ett og ett utdanningstilbud fjernes, eller bare flere av gangen? Jira nevner bare handlingen for flere av gangen.
