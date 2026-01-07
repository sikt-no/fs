# language: no
@demo @integration
Egenskap: GraphQL API integrasjon
  Som utvikler ønsker jeg å verifisere at GraphQL APIet fungerer korrekt.

  Scenario: Hente liste over utdanningsinstanser
    Når jeg henter liste over utdanningsinstanser fra GraphQL
    Så skal responsen ikke inneholde feil
    Og skal responsen inneholde utdanningsinstanser
    Og hver utdanningsinstans skal ha organisasjon, campus og terminer

  Scenario: Introspection query fungerer
    Når jeg kjører en introspection query
    Så skal responsen inneholde schema-informasjon
