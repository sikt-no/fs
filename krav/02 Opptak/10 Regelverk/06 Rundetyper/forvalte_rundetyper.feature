# language: no
# GitHub: #216
@OPT-REG-RUN-001 @must @draft @scope-plasstildeling-2027
Egenskap: Forvalte rundetyper i regelverkssamlingen
  Som regelverksforvalter ved organisasjonen som eier regelverkssamlingen
  ønsker jeg å definere rundetypene og innstillingene deres i regelverkssamlingen
  slik at plasstildelingsrundene i opptakene som bruker regelverkssamlingen, følger reglene for opptaket.

  # AVKLART 2026-10-24 (produkteier): En rundetype er et navn og et sett med innstillinger for
  # plasstildelingsrunder. Plasstildelingen leser innstillingene, og ser aldri på hvilken rundetype det er.
  # Rundetypene er en del av regelverket, som kvotetypene, og gjelder alle opptak som bruker
  # regelverkssamlingen. Nye rundetyper, for eksempel for lokale opptak, lages uten kodeendring.
  # Løsningen dekker samordna opptak (UHG og HYU) først, men skal kunne brukes av alle opptak.
  # Innstillingene kan ikke justeres på plasstildelingsrunden. Trengs en annen kombinasjon, lages en ny
  # rundetype. Se 14 Plasstildeling/01 Runder/forvalte_runder.feature.
  # Hva plasstildelingen gjør med innstillingene, står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.

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

  Regel: Regelverkssamlingene for samordna opptak har rundetypene hovedtildeling, supplering og etterfylling

    # Regelverkssamlingene for UHG og HYU har de samme tre rundetypene.
    # Kodeverket har også TIDLIG, LEDIGE_STUDIEPLASSER og TEST, som ikke er rundetyper i kravet.
    Scenariomal: Rundetypene i samordna opptak
      Når regelverksforvalter ser rundetypen "<rundetype>" i regelverkssamlingen "UHG2027"
      Så har rundetypen disse innstillingene
        | Innstilling                                       | Verdi          |
        | Tilbud gir bortfall på lavere prioriteter         | <bortfall>     |
        | Kompensasjonstilbud ved opprykk                   | <kompensasjon> |
        | Bygger på forrige publiserte plasstildelingsrunde | <arv>          |
        | Bare én i opptaket                                | <én>           |
        | Kan åpnes for ledige studieplasser                | <ledige>       |

      Eksempler:
        | rundetype      | bortfall | kompensasjon | arv | én  | ledige |
        | Hovedtildeling | ja       | nei          | nei | ja  | ja     |
        | Supplering     | ja       | ja           | ja  | nei | ja     |
        | Etterfylling   | nei      | nei          | ja  | nei | ja     |

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

# ÅPNE SPØRSMÅL:
# - Kan en rundetype slettes når ingen plasstildelingsrunder bruker den?
