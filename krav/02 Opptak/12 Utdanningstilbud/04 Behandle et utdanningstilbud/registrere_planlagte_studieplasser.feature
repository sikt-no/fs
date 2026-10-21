# language: no
# Jira: SHI-690
@OPT-OPT-UTD-012 @must @implemented @scope-utdanningstilbud-2027 @ref-OPT-OPT-UTD-007
Egenskap: Registrere planlagt antall studieplasser
  Som opptaksforvalter
  ønsker jeg å registrere planlagt antall studieplasser på utdanningstilbudet
  slik at planlagt kapasitet er synlig for planlegging og for søkere.

  # AVKLART 2026-10-21: Planlagt antall studieplasser er det samme tallet som antall studieplasser
  # i 03 Opptaksinnstillinger. Hvem som kan endre tallet, og når, står der.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  @openquestion
  Regel: Planlagt antall studieplasser kan registreres
    # ÅPNE SPØRSMÅL:
    # - Løsningen godtar et heltall fra 0 til 9999. Dekker det alle utdanningstilbud, eller trengs andre grenser?

    Scenario: Registrere planlagt antall studieplasser
      Når opptaksforvalter registrerer planlagt antall studieplasser
      Så lagres planlagt antall studieplasser på utdanningstilbudet

    Scenario: Se planlagt antall studieplasser
      Gitt at det er registrert et planlagt antall studieplasser
      Så vises planlagt antall studieplasser
