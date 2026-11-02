# language: no
# Jira: SHI-692
@OPT-OPT-UTD-014 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Registrere påkrevde attester på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å registrere hvilke attester som kreves for utdanningstilbudet
  slik at søkere vet hvilke attester de må skaffe.

  # AVKLART 2026-10-21: Kodeverket for politiattest er FS-kodene for politiattest (tabellen POLITIATTEST),
  # og medisinsk attest er én kode. Et utdanningstilbud kan kreve flere attester samtidig.
  # Hva søkeren ser av attestkravet i Min kompetanse, står i
  # 13 Søknad og saksbehandling/01 Søknad/se_utdanningstilbud.feature.

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

  @planned
  Regel: Attestene vises med kode og navn
    # Tilbakemelding fra intern akseptansetest (SHI-791): lærestedene vil se kodene for å være sikre på
    # at attestkravet er helt riktig.

    Scenario: Se kode og navn når attestene velges
      Når opptaksforvalter velger attester for utdanningstilbudet
      Så ser opptaksforvalter koden og navnet på hver attest

    Scenario: Se kode og navn på attestene utdanningstilbudet krever
      Gitt at det er registrert krav om politiattest og medisinsk attest på utdanningstilbudet
      Når opptaksforvalter ser attestene utdanningstilbudet krever
      Så ser opptaksforvalter koden og navnet på hver attest
