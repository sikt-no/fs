# language: no
# GitHub: #501
# Kilde: Bullet fra #350-body — "Brukers roller og tilganger deaktiveres automatisk når bruker slutter i en stilling"
@BRU-PER-ETT-005 @planned
Egenskap: Fjerne alle roller ved stillingsslutt
  Som brukeradministrator
  ønsker jeg at en person automatisk mister alle roller når personen slutter i en stilling
  slik at tidligere ansatte ikke beholder tilgang til FS-data ved en feil.

  Scenario: Personen slutter i en stilling og kildesystemet rapporterer det
    Gitt at en person har roller knyttet til en stilling
    Og kildesystemet (HR/IAM) signaliserer at stillingen er avsluttet
    Når signalet behandles
    Så fjernes alle personens roller
    Og brukeradministrator skal varsles (se BRU-PER-HIS-003)
    Og endringen skal være sporbar i historikk som "fjerning av alle roller ved stillingsslutt"

# ÅPNE SPØRSMÅL:
# - Hvilken kilde signaliserer stillingsslutt — HR-system, IAM, manuell registrering i FS?
# - Gjelder «fjern alle roller» alle personens roller, eller bare de som er knyttet til den avsluttede stillingen når personen har flere stillinger?
# - Skal det være en "karens"-periode mellom signal og fjerning, eller umiddelbart?
# - Skal personen selv varsles før rollene fjernes?
