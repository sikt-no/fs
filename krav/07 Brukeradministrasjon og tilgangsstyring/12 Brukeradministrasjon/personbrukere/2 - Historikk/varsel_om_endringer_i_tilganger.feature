# language: no
# GitHub: #490
# Kilde: Bullet fra #350-body — "Brukeradministrator får automatisk varsel om endringer i brukers tilganger"
@BRU-PER-HIS-003 @draft
Egenskap: Varsel om endringer i brukers tilganger
  Som brukeradministrator
  ønsker jeg å bli varslet automatisk når en brukers tilganger endres
  slik at jeg har oppdatert oversikt uten å måtte sjekke historikk manuelt.

  Scenario: Varsel sendes når en bruker mister tilgang automatisk
    Gitt at en bruker har en tilgang med tidsbegrensning som utløper
    Og at brukeradministrator er ansvarlig for brukeren
    Når tilgangen automatisk blir inaktiv
    Så skal brukeradministrator motta et varsel

  Scenario: Varsel sendes ved manuell endring fra en annen administrator
    Gitt at flere brukeradministratorer har ansvar for samme bruker
    Når en av dem endrer brukerens tilganger
    Så skal de andre ansvarlige brukeradministratorene motta et varsel

# ÅPNE SPØRSMÅL:
# - Hvilke endringer skal trigge varsel? (tildeling, fjerning, deaktivering, utløp, stillingsslutt-deaktivering, taushetserklæring-status?)
# - Varslingskanal — e-post, i-app-varsel, begge? Mulig å abonnere/avregistrere?
# - Hvem regnes som "ansvarlig brukeradministrator" — alle med administrasjonsrett, eller en spesifikk eier-rolle?
# - Skal varselet samles (digest daglig/ukentlig) eller sendes umiddelbart?
# - Skal bruker også varsles om endringer på egne tilganger?
# - Forholdet til endringer som administrator selv gjør — varsel om egne handlinger?
