# language: no
# Jira: SHI-690
@OPT-OPT-UTD-012 @must @draft
Egenskap: Registrere planlagt antall studieplasser
  Som opptaksforvalter
  ønsker jeg å registrere planlagt antall studieplasser på utdanningstilbudet
  slik at planlagt kapasitet er synlig for planlegging og for søkere.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Planlagt antall studieplasser kan registreres

    Scenario: Registrere planlagt antall studieplasser
      Når opptaksforvalter registrerer planlagt antall studieplasser
      Så lagres planlagt antall studieplasser på utdanningstilbudet

    Scenario: Se planlagt antall studieplasser
      Gitt at det er registrert et planlagt antall studieplasser
      Så vises planlagt antall studieplasser

# ÅPNE SPØRSMÅL:
# - Hvordan forholder "planlagt antall studieplasser" seg til antall studieplasser i "03 Opptaksinnstillinger" (sette_studieplasser_og_antall_tilbud)? Er dette samme tall, eller et eget planleggingsfelt?
# - Finnes det valideringsregler (heltall, minimum/maksimum)?
