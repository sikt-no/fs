# language: no

Egenskap: 10 Felleskrav: Eksport
 Som bruker ønsker jeg å kunne laste ned eller dele informasjon jeg har søkt og filtrert meg frem til i en visning. 

Scenario: Last ned som CSV

Scenario: Del på epost

Scenario: Last ned som excel

Scenario: Del med en annen bruker i systemet i en tidsbegrenset periode
    Gitt at jeg er studieadministrator med ansvar for studieplaner
    Når jeg er inne på oversikt over utdanninger
    Og velger å dele oversikt med en annnen bruker
    Og velger å dele med skolens bibliotek
    Så skal biblioteket få varsel og kunne se informasjonen jeg har delt