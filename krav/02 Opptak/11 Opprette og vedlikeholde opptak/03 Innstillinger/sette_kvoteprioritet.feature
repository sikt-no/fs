# language: no
# GitHub: #216
@OPT-OVO-INN-003 @must @draft @scope-plasstildeling-2027
Egenskap: Sette kvoteprioritet for opptaket
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å sette kvoteprioriteten for opptaket
  slik at det er klart hvilken kvote en plass tas fra når søkeren når opp i flere kvoter.

  # Kilde: skissen «Kvoter», fanen «Kvoteprioritet» (Figma node 22399:113465):
  # https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=22399-113465
  # Kvoteprioriteten settes sammen med plassflyten, se sette_plassflyt.feature. Hvordan plasstildelingen
  # bruker den, står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  # I dag finnes kvoteprioriteten per utdanningskvote på utdanningstilbudet, og på kvotetypen i koden.
  #
  # ÅPNE SPØRSMÅL:
  # - Hvilke kvoter vises: alle kvotetypene i opptaket, eller bare de som er med i plassflyten?
  # - Kan kvoteprioriteten overstyres per utdanningstilbud?

  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Kvoteprioriteten settes på opptaket og gjelder alle utdanningstilbud

    Scenario: Sette kvoteprioritet for opptaket
      Når opptaksforvalter setter kvoteprioritet 1 for "SAMF", 4 for "ORDF" og 12 for "ORD"
      Så gjelder kvoteprioriteten for alle utdanningstilbud i opptaket

  Regel: Plassen tas fra kvoten med høyest prioritet

    Scenario: Lavest tall gir høyest prioritet
      Gitt at kvoteprioriteten er 4 for "ORDF" og 12 for "ORD"
      Og at søkeren "Kari Nordmann" har nok poeng til begge kvotene på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så tar søkeren plassen fra "ORDF"

    Scenario: Lik kvoteprioritet avgjøres ved loddtrekning
      Gitt at kvoteprioriteten er 4 for både "ORDF" og "SAMF"
      Og at søkeren "Kari Nordmann" har nok poeng til begge kvotene på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så avgjøres det ved loddtrekning hvilken kvote plassen tas fra

  Regel: Kvoteprioriteten er et heltall fra 0 til 25

    Scenariomal: Ugyldig kvoteprioritet
      Når opptaksforvalter setter kvoteprioritet <verdi> for "ORD"
      Så blir kvoteprioriteten ikke lagret

      Eksempler:
        | verdi |
        | -1    |
        | 26    |
        | 2,5   |
