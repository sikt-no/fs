# language: no
@demo @e2e
Egenskap: Todo-liste demo
  Som bruker ønsker jeg å kunne legge til og fjerne oppgaver i en todo-liste.

  Bakgrunn:
    Gitt at brukeren er på todo-liste siden

  Scenario: Legge til en ny oppgave
    Når brukeren skriver "Kjøpe melk" i input-feltet
    Og brukeren trykker på legg til-knappen
    Så skal "Kjøpe melk" vises i listen

  Scenario: Legge til flere oppgaver
    Når brukeren legger til følgende oppgaver
      | Oppgave        |
      | Vaske gulvet   |
      | Handle mat     |
      | Ringe mamma    |
    Så skal "Vaske gulvet" vises i listen
    Og skal "Handle mat" vises i listen
    Og skal "Ringe mamma" vises i listen
