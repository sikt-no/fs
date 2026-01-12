# language: no
@demo @integration
Egenskap: GraphQL API integrasjon
  Som utvikler ønsker jeg å verifisere at GraphQL APIet fungerer korrekt.

  Scenario: Utdanningsinstanser inneholder forventet data
    Når jeg henter liste over utdanningsinstanser fra GraphQL
    Så skal responsen ikke inneholde feil
    Og skal hver utdanningsinstans inneholde følgende felt
      | felt         |
      | id           |
      | organisasjon |
      | terminFra    |
      | terminTil    |
