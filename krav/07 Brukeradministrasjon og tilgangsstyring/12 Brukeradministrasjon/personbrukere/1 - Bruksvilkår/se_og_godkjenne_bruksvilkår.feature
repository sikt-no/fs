# language: no
# GitHub: #477
# Kilde: Brukerhistorie BHB (temp/brukerhistorier.md)
@BRU-PER-BRV-001 @draft
Egenskap: Se og godkjenne bruksvilkår
  Som bruker av FS Admin
  ønsker jeg å se og godkjenne gjeldende bruksvilkår
  slik at jeg vet hvilke betingelser som gjelder for min bruk av systemet.

  Scenario: Bruker logger inn for første gang og må godkjenne bruksvilkår
    Gitt at brukeren er Feide-autentisert
    Og brukeren ikke har godkjent gjeldende versjon av bruksvilkårene
    Når brukeren logger inn i FS Admin
    Så skal gjeldende bruksvilkår vises
    Og brukeren skal kunne godkjenne dem før videre tilgang gis

  Scenario: Bruker har allerede godkjent gjeldende bruksvilkår
    Gitt at brukeren har godkjent gjeldende versjon av bruksvilkårene
    Når brukeren logger inn i FS Admin
    Så skal brukeren slippe forbi visning av bruksvilkår

# ÅPNE SPØRSMÅL:
# - Hvor lagres godkjenningen, og hva er gjeldende versjon-mekanismen (datostempel, versjonsnummer, hash)?
# - Hva skjer hvis brukeren ikke godkjenner? Avbrutt innlogging? Bare lese-tilgang?
# - Skal historikk over godkjenninger være synlig for brukeren selv eller for brukeradministrator?
# - Når en ny versjon publiseres, må alle godkjenne på nytt — hva er trigger og varslingsmekanisme?
# - Hvor vises bruksvilkårene (modal ved innlogging, egen side, lenke i menyen)?
