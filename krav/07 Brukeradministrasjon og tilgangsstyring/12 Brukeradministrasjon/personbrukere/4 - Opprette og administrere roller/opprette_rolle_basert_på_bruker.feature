# language: no
# GitHub: #496
# Kilde: Brukerhistorie BHOAR1 (temp/brukerhistorier.md)
@BRU-PER-OAR-004 @draft
Egenskap: Opprette rolle basert på en gitt brukers roller
  Som brukeradministrator
  ønsker jeg å opprette en ny rolle basert på roller som er tildelt én gitt bruker
  slik at jeg raskt kan replikere et sett av tilganger som har vist seg å være nyttige for en bruker.

  Scenario: Lage en sammensatt rolle ut fra en mal-bruker
    Gitt at en bruker har et nyttig sett med roller og tilganger
    Når brukeradministrator velger "Opprett rolle basert på denne brukeren"
    Så skal en ny rolle foreslås som inneholder samme sett av roller/tilganger
    Og brukeradministrator skal kunne justere settet før rollen lagres

  Scenario: Velge bort enkelte tilganger før den nye rollen opprettes
    Gitt at brukeradministrator har valgt en mal-bruker
    Når brukeradministrator velger bort enkelte tilganger fra forslaget
    Så skal den nye rollen kun inneholde det justerte settet
    Og rollen skal være tilgjengelig for tildeling etter lagring

# ÅPNE SPØRSMÅL:
# - Skal man kunne basere rollen på flere brukere samtidig (snitt eller union)?
# - Skal direkte-tildelte tilganger på mal-brukeren tas med, eller bare roller?
# - Hva med stedkoder og tidsbegrensning fra mal-brukerens tildelinger — skal de kopieres over som default på rollen?
# - Skal den nye rollen automatisk bli lokal for egen organisasjon, eller kan rolleadministrator velge?
# - Hva er forholdet til BRU-PER-OAR-001 — er dette en snarvei eller en helt egen flyt?
