# language: no
# GitHub: #453
@BRU-APP-API-016 @could @draft
Egenskap: Endringslogg for API-bruker
  Som bruker
  ønsker jeg å se endringslogg over hvem som har endret hva
  slik at jeg kan spore historikken til en API-bruker.

  # Krav fra Confluence: K16 Se endringslogg (Kan ha)

  Scenario: Se endringslogg
    Gitt jeg er på detaljsiden for en API-bruker
    Når jeg åpner endringsloggen
    Så ser jeg en liste over endringer med hvem som endret og hva som ble endret
