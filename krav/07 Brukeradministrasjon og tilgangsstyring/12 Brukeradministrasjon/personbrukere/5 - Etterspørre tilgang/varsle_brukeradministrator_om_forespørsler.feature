# language: no
# GitHub: #500
# Kilde: Brukerhistorie BH14 (temp/brukerhistorier.md)
@BRU-PER-ETT-004 @draft
Egenskap: Varsle brukeradministrator om tilgangsforespørsler
  Som brukeradministrator
  ønsker jeg å varsles når det etterspørres en tilgang eller rolle, og jeg vil kunne se alle ubesvarte forespørsler
  slik at jeg ikke overser nye forespørsler og kan jobbe gjennom dem systematisk.

  Scenario: Brukeradministrator varsles ved ny forespørsel
    Gitt at brukeradministrator er ansvarlig for tilgangsstyring for en organisasjon
    Når en ny tilgangsforespørsel kommer inn for den organisasjonen
    Så skal brukeradministrator motta et varsel

  Scenario: Brukeradministrator ser oversikt over ubesvarte forespørsler
    Gitt at det finnes flere ubesvarte tilgangsforespørsler
    Når brukeradministrator åpner forespørsels-oversikten
    Så skal alle ubesvarte forespørsler vises
    Og det skal være tydelig hvor lenge hver forespørsel har ventet

# ÅPNE SPØRSMÅL:
# - Varslingskanal — e-post, i-app-varsel, begge? Og samme valg som BRU-PER-HIS-003?
# - Hvis flere brukeradministratorer kan håndtere forespørselen — varsel til alle, eller round-robin/eier?
# - Skal det være eskalering hvis en forespørsel blir ubesvart for lenge?
# - Filtrering i oversikten — per organisasjon, type tilgang, alder, søker?
# - Skal oversikten inkludere besvarte forespørsler med filter (avslag/godkjent siste 30 dager)?
# - Hvordan synkroniseres "ubesvart" på tvers av administratorer — claim/lock når en starter behandlingen?
