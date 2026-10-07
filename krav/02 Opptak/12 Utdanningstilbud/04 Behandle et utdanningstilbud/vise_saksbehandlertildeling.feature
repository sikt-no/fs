# language: no
# Jira: SHI-696
@OPT-OPT-UTD-018 @must @draft
Egenskap: Vise saksbehandlertildeling for utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å se saksbehandlertildelingen for utdanningstilbudet
  slik at jeg vet hvem som behandler søknadene til tilbudet.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Saksbehandlertildeling kan ses på utdanningstilbudet

    Scenario: Se saksbehandlertildeling for utdanningstilbudet
      Gitt at utdanningstilbudet har en saksbehandlertildeling
      Så vises saksbehandlertildelingen for utdanningstilbudet

# ÅPNE SPØRSMÅL:
# - Skal det vises reglene for tildeling, eller den faktiske tildelingen (hvem som er tildelt)? Dette er ikke avklart i Jira.
# - Virkemåten må avklares med forretning før kravet kan konkretiseres.
