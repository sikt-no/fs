# language: no
# Jira: SHI-692
@OPT-OPT-UTD-014 @must @draft
Egenskap: Registrere påkrevde attester på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å registrere hvilke attester som kreves for utdanningstilbudet
  slik at søkere vet hvilke attester de må skaffe.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Krav om politiattest kan registreres

    Scenario: Registrere krav om politiattest
      Når opptaksforvalter registrerer krav om politiattest fra kodeverket for politiattest
      Så lagres kravet om politiattest på utdanningstilbudet

  Regel: Krav om medisinsk attest kan registreres

    Scenario: Registrere krav om medisinsk attest
      Når opptaksforvalter registrerer krav om medisinsk attest
      Så lagres kravet om medisinsk attest på utdanningstilbudet

# ÅPNE SPØRSMÅL:
# - Kodeverk for politiattest finnes i FS-koder (tabellen POLITIATTEST). Kodeverk for medisinsk attest må raffineres.
# - Kan et utdanningstilbud kreve flere attesttyper samtidig?
# - Skal attestkravet vises til søkeren i Min kompetanse?
