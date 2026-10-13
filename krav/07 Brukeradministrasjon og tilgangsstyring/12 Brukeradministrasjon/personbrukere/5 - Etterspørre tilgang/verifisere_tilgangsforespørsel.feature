# language: no
# GitHub: #499
# Kilde: Brukerhistorie BH13 (temp/brukerhistorier.md)
@BRU-PER-ETT-003 @draft
Egenskap: Verifisere tilgangsforespørsel
  Som brukeradministrator
  ønsker jeg å kunne verifisere at en forespørsel om tilgang er legitim før jeg godkjenner den
  slik at jeg er trygg på at det er riktig å tildele tilgangen.

  Scenario: Vurdere en innkommet forespørsel
    Gitt at det finnes en ventende tilgangsforespørsel
    Når brukeradministrator åpner forespørselen
    Så skal kontekst om forespørselen vises — hvem som har bedt om hva, begrunnelse, hvilke tilganger søker allerede har
    Og det skal være mulig å godkjenne, avslå (med begrunnelse), eller be om mer informasjon

  Scenario: Godkjenne en verifisert forespørsel
    Gitt at brukeradministrator har vurdert en forespørsel og funnet den legitim
    Når brukeradministrator godkjenner forespørselen
    Så skal den etterspurte tilgangen tildeles søker (med tilhørende flyter for taushetserklæring etc.)
    Og søker skal varsles om godkjenningen

  Scenario: Avslå en forespørsel med begrunnelse
    Gitt at brukeradministrator vurderer en forespørsel som ikke legitim
    Når brukeradministrator avslår forespørselen med en begrunnelse
    Så skal søker varsles om avslaget og begrunnelsen
    Og avslaget skal være sporbart i historikk

# ÅPNE SPØRSMÅL:
# - Hvilken kontekst er "nok" for verifisering — stillingstittel, leder, organisasjonsenhet, eksisterende tilganger?
# - Skal det støttes flertrinns-godkjenning (f.eks. leder + brukeradministrator) for visse tilgangstyper?
# - Skal forespørsler ha en utløpstid (auto-avslag etter N dager)?
# - Skal saksbehandling være mulig for flere administratorer parallelt (claim-mekanikk)?
# - Hvordan håndteres "be om mer informasjon" — tråd med søker, e-postutveksling, separat felt?
# - Skal det føres logg over begrunnelser (godkjenninger og avslag) for revisjon?
