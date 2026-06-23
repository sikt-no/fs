# language: no
# GitHub: #501
# Kilde: Bullet fra #350-body — "Brukers roller og tilganger deaktiveres automatisk når bruker slutter i en stilling"
@BRU-PER-ETT-005 @draft
Egenskap: Automatisk deaktivering av tilganger ved stillingsslutt
  Som brukeradministrator
  ønsker jeg at en brukers roller og tilganger automatisk deaktiveres når brukeren slutter i en stilling
  slik at tidligere ansatte ikke beholder tilgang til FS-data ved en feil.

  Scenario: Bruker slutter i en stilling og kildesystemet rapporterer det
    Gitt at en bruker har aktive tilganger knyttet til en stilling
    Og kildesystemet (HR/IAM) signaliserer at stillingen er avsluttet
    Når signalet behandles
    Så skal tilgangene knyttet til den stillingen automatisk deaktiveres
    Og brukeradministrator skal varsles (se BRU-PER-HIS-003)
    Og endringen skal være sporbar i historikk som "automatisk deaktivering ved stillingsslutt"

  Scenario: Bruker har tilganger fra flere stillinger
    Gitt at en bruker har tilganger fra flere stillinger i samme organisasjon
    Når én av stillingene avsluttes
    Så skal kun tilgangene knyttet til den avsluttede stillingen deaktiveres
    Og øvrige tilganger skal være uberørt

# ÅPNE SPØRSMÅL:
# - Hvilken kilde signaliserer stillingsslutt — HR-system, IAM, manuell registrering i FS?
# - Hvordan knyttes en tilgang til en stilling — gjennom tildelingen, eller indirekte via organisasjonstilknytning?
# - Skal det være en "karens"-periode mellom signal og deaktivering, eller umiddelbart?
# - Hva med tilganger som er nødvendige for å avslutte pågående arbeid — skal de overlappe noen dager?
# - Skal brukeren selv varsles før deaktivering inntrer?
# - Hva med roller og tilganger som ikke er knyttet til en stilling — beholdes de?
# - Forholdet til manuell deaktivering (BRU-PER-GRU-004) — skal de skille seg visuelt i historikk?
