# language: no
@demo @integration
Egenskap: GraphQL API integrasjon
  Som utvikler ønsker jeg å verifisere at GraphQL APIet fungerer korrekt.

  Scenario: Hente liste over organisasjoner
    Når jeg henter liste over organisasjoner fra GraphQL
    Så skal responsen inneholde organisasjoner
    Og hver organisasjon skal ha et navn

  Scenario: Introspection query fungerer
    Når jeg kjører en introspection query
    Så skal responsen inneholde schema-informasjon
