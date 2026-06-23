# language: no
# GitHub: #484
@BRU-PER-GRU-006 @must @planned
Egenskap: Sette start- og sluttidspunkt for tildelinger
  Som brukeradministrator
  ønsker jeg å sette valgfritt start- og/eller sluttidspunkt for én enkelt tildeling, eller for det totale settet av tildelinger hos en personbruker
  slik at tildelingene er tidsbegrenset uten manuell oppfølging.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker
    Og start- og sluttidspunkt angis med dato og tidspunkt (minutt-oppløsning) i tidssonen Europe/Oslo

  Regel: Sette tidsbegrensning på en enkelt tildeling

    Scenario: Sette sluttidspunkt på en tildeling
      Når jeg setter et sluttidspunkt fram i tid på en tildeling
      Så er tildelingen aktiv fram til sluttidspunktet
      Og tildelingen blir automatisk inaktiv etter sluttidspunktet
      Og endringen er sporbar i historikk

    Scenario: Sette starttidspunkt fram i tid på en tildeling
      Når jeg setter et starttidspunkt fram i tid på en tildeling
      Så er tildelingen inaktiv fram til starttidspunktet
      Og tildelingen blir automatisk aktiv på starttidspunktet
      Og endringen er sporbar i historikk

    Scenario: Sette både start- og sluttidspunkt
      Når jeg setter både et starttidspunkt og et sluttidspunkt fram i tid på en tildeling
      Så er tildelingen aktiv kun innenfor det angitte tidsrommet

    Scenario: Endre tidsbegrensning på en eksisterende tildeling
      Gitt en tildeling har et sluttidspunkt fram i tid
      Når jeg endrer sluttidspunktet
      Så gjelder det nye sluttidspunktet for tildelingen
      Og endringen er sporbar i historikk

    Scenario: Fjerne tidsbegrensning
      Gitt en tildeling har et start- eller sluttidspunkt
      Når jeg fjerner tidsbegrensningen
      Så gjelder tildelingen uten tidsbegrensning

  Regel: Sette felles sluttidspunkt for en personbrukers samlede tildelinger

    Scenario: Sette felles sluttidspunkt for alle tildelinger
      Gitt personbrukeren har flere aktive tildelinger
      Når jeg setter et felles sluttidspunkt fram i tid for hele personbrukerens tildelingssett
      Så får hver av personbrukerens tildelinger samme sluttidspunkt
      Og alle tildelingene blir automatisk inaktive på det tidspunktet
      Og endringen er sporbar i historikk per tildeling

  Regel: Validering av tidspunkt

    Scenario: Sluttidspunkt i fortiden avvises
      Når jeg forsøker å sette et sluttidspunkt som ligger i fortiden
      Så lagres ikke endringen
      Og jeg ser en feilmelding som sier at sluttidspunkt ikke kan ligge i fortiden

    Scenario: Sluttidspunkt før starttidspunkt avvises
      Gitt jeg setter både et starttidspunkt og et sluttidspunkt på en tildeling
      Når sluttidspunktet ligger før starttidspunktet
      Så lagres ikke endringen
      Og jeg ser en feilmelding som sier at sluttidspunkt må ligge etter starttidspunkt

# ÅPNE SPØRSMÅL:
# - Kan tidsbegrensning settes på rolle-nivå, eller bare på enkelttilgang og på det samlede tildelingssettet? Henger sammen med rolledefinisjonsarbeidet i "4 - Opprette og administrere roller".
# - Hvordan varsles personbrukeren før utløp? Avklares sammen med BRU-PER-HIS-003 (varsling).
# - Skal "tidsbegrensning utløpt" og "manuelt deaktivert" vises som ulike statuser i historikk og listevisning? Henger sammen med åpent spørsmål i BRU-PER-GRU-002.
# - Skal det være mulig å sette starttidspunkt i fortiden (for å registrere historisk gyldighet), eller skal også det avvises?