# language: no
# GitHub: #483
@BRU-PER-GRU-005 @must @planned
Egenskap: Sette stedkoder for en tildeling
  Som brukeradministrator
  ønsker jeg å sette hvilke stedkoder en gitt tildeling skal gjelde for
  slik at tildelingen begrenses til de delene av organisasjonen personbrukeren har ansvar for.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Tildele med stedkoder

    Scenario: Tildele en tilgang med spesifikke stedkoder
      Gitt jeg skal tildele en tilgang som støtter stedkode-begrensning
      Når jeg velger én eller flere stedkoder for tildelingen
      Så lagres tildelingen med de valgte stedkodene
      Og tildelingen gjelder kun innenfor de valgte stedkodene
      Og endringen er sporbar i historikk

    Scenario: Tildele en tilgang uten stedkode-begrensning
      Gitt jeg skal tildele en tilgang som støtter stedkode-begrensning
      Når jeg ikke velger noen stedkoder for tildelingen
      Så lagres tildelingen uten stedkode-begrensning
      Og tildelingen gjelder for personbrukerens fulle scope ved den aktuelle organisasjonen

  Regel: Endre stedkoder på eksisterende tildeling

    Scenario: Legge til stedkoder på en eksisterende tildeling
      Gitt personbrukeren har en tildeling med stedkoder
      Når jeg legger til én eller flere stedkoder i utvalget
      Så oppdateres tildelingens scope tilsvarende
      Og endringen er sporbar i historikk

    Scenario: Fjerne stedkoder fra en eksisterende tildeling
      Gitt personbrukeren har en tildeling med stedkoder
      Når jeg fjerner én eller flere stedkoder fra utvalget
      Så oppdateres tildelingens scope tilsvarende
      Og endringen er sporbar i historikk

    Scenario: Fjerne alle stedkoder fra en tildeling
      Gitt personbrukeren har en tildeling med stedkoder
      Når jeg fjerner alle stedkodene
      Så lagres tildelingen uten stedkode-begrensning
      Og tildelingen gjelder for personbrukerens fulle scope ved den aktuelle organisasjonen

  Regel: Kilde til lovlige stedkode-verdier

    Scenario: Stedkodene er begrenset til organisasjonen tildelingen gjelder
      Gitt en tildeling gjelder ved en gitt organisasjon
      Når jeg velger stedkoder for tildelingen
      Så vises kun stedkoder som er definert ved den organisasjonen

# ÅPNE SPØRSMÅL:
# - Kan stedkoder settes på rolle-nivå, eller bare på enkelttilganger? Henger sammen med rolledefinisjonsarbeidet i "4 - Opprette og administrere roller".
# - Gjelder stedkode-begrensning alle tilgangstyper, eller markeres støtte per tilgangsdefinisjon?
# - Skal hierarkiske stedkoder (overordnet kode dekker underliggende) støttes? Hvordan presenteres dette i visning og valg?
# - Skal det være mulig for super-personadministrator å sette stedkoder utenfor egen organisasjon?