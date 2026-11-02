# language: no
# GitHub: #216
@OPT-REG-RUN-002 @could @draft
Egenskap: Forvalte rundetyper i regelverkssamlingen
  Som regelverksforvalter ved organisasjonen som eier regelverkssamlingen
  ønsker jeg å legge til, endre og slette rundetypene og innstillingene deres i regelverkssamlingen
  slik at nye opptak kan få egne rundetyper uten kodeendring.

  # Skilt ut fra bruke_rundetyper.feature (@OPT-REG-RUN-001) 2026-10-29. Forvaltningen er ikke med i
  # scope-plasstildeling-2027, og plasstildelingen bruker rundetypene som finnes.
  # Rundetypene for samordna opptak og innstillingene deres står i bruke_rundetyper.feature.

  Bakgrunn:
    Gitt at regelverksforvalter ved organisasjonen som eier regelverkssamlingen er innlogget
    Og at regelverkssamlingen "UHG2027" er opprettet

  Regel: Regelverksforvalter legger til rundetyper med innstillinger

    Scenario: Legge til en rundetype
      Når regelverksforvalter legger til rundetypen "Supplering" i regelverkssamlingen "UHG2027" med disse innstillingene
        | Innstilling                                       | Verdi |
        | Tilbud gir bortfall på lavere prioriteter         | ja    |
        | Kompensasjonstilbud ved opprykk                   | ja    |
        | Bygger på forrige publiserte plasstildelingsrunde | ja    |
        | Bare én i opptaket                                | nei   |
        | Kan åpnes for ledige studieplasser                | ja    |
      Så har regelverkssamlingen "UHG2027" rundetypen "Supplering" med innstillingene

  Regel: Kompensasjonstilbud ved opprykk krever bortfall og at plasstildelingsrunden bygger på forrige

    # Opprykk frigjør en plass bare når tilbudet på den lavere prioriteten faller bort, og bare når det
    # finnes tilbud fra en tidligere plasstildelingsrunde.
    Scenariomal: Kompensasjonstilbud ved opprykk krever <innstilling>
      Når regelverksforvalter legger til en rundetype med kompensasjonstilbud ved opprykk
      Og innstillingen "<innstilling>" er "nei"
      Så blir rundetypen ikke lagt til
      Og regelverksforvalter får beskjed om at kompensasjonstilbud ved opprykk krever "<innstilling>"

      Eksempler:
        | innstilling                                       |
        | Tilbud gir bortfall på lavere prioriteter         |
        | Bygger på forrige publiserte plasstildelingsrunde |

  Regel: En rundetype kan ikke endres når en plasstildelingsrunde bruker den

    # AVKLART 2026-10-24: Da beskriver plasstildelingsrunden alltid innstillingene som faktisk ble brukt.
    Scenario: Rundetype som ikke er brukt, kan endres
      Gitt at ingen plasstildelingsrunder har rundetypen "Etterfylling" i regelverkssamlingen "UHG2027"
      Når regelverksforvalter endrer innstillingen "Kan åpnes for ledige studieplasser" til "nei" for rundetypen "Etterfylling"
      Så har rundetypen "Etterfylling" innstillingen "Kan åpnes for ledige studieplasser" satt til "nei"

    Scenario: Rundetype som er brukt, kan ikke endres
      Gitt at opptaket "Samordna opptak 2027" har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når regelverksforvalter ser rundetypen "Hovedtildeling" i regelverkssamlingen "UHG2027"
      Så ser regelverksforvalter ikke muligheten til å endre innstillingene

  Regel: En rundetype kan slettes når ingen plasstildelingsrunder bruker den

    # AVKLART 2026-10-29 (produkteier).
    Scenario: Slette en rundetype som ikke er brukt
      Gitt at ingen plasstildelingsrunder har rundetypen "Etterfylling" i regelverkssamlingen "UHG2027"
      Når regelverksforvalter sletter rundetypen "Etterfylling"
      Så har regelverkssamlingen "UHG2027" ikke rundetypen "Etterfylling"

    Scenario: Rundetype som er brukt, kan ikke slettes
      Gitt at opptaket "Samordna opptak 2027" har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
      Når regelverksforvalter ser rundetypen "Hovedtildeling" i regelverkssamlingen "UHG2027"
      Så ser regelverksforvalter ikke muligheten til å slette rundetypen

# ÅPNE SPØRSMÅL:
# - Skal rundetypene følge med, eller legges ved siden av, når regelverkssamlingen kopieres
#   (OPT-REG-SAM-001)? Trengs et skille mellom felleskoder for opptaket og regelverket? (brukertesten med HK-dir, oktober 2026)
