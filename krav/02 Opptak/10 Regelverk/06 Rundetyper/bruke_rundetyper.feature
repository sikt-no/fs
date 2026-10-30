# language: no
# GitHub: #216
@OPT-REG-RUN-001 @must @draft @scope-plasstildeling-2027
Egenskap: Rundetyper i regelverkssamlingen
  Som opptaksforvalter
  ønsker jeg at regelverkssamlingen har rundetypene opptaket trenger, med innstillingene deres
  slik at plasstildelingsrundene i opptaket følger reglene for opptaket.

  # AVKLART 2026-10-24 (produkteier): En rundetype er et navn og et sett med innstillinger for
  # plasstildelingsrunder. Plasstildelingen leser innstillingene, og ser aldri på hvilken rundetype det er.
  # Rundetypene er en del av regelverket, som kvotetypene, og gjelder alle opptak som bruker
  # regelverkssamlingen.
  # AVKLART 2026-10-29 (produkteier): Å forvalte rundetypene (legge til, endre og slette) er ikke med nå, og står i
  # forvalte_rundetyper.feature (@could). Plasstildelingen bruker rundetypene som finnes, og hovedtildeling, supplering
  # og etterfylling, med innstillingene under, er de som trengs i første omgang.
  # Innstillingene kan ikke justeres på plasstildelingsrunden. Se 14 Plasstildeling/01 Runder/forvalte_runder.feature.
  # Hva plasstildelingen gjør med innstillingene, står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.

  Regel: Regelverkssamlingene for samordna opptak har rundetypene hovedtildeling, supplering og etterfylling

    # Regelverkssamlingene for UHG og HYU har de samme tre rundetypene.
    # Kodeverket har også TIDLIG, LEDIGE_STUDIEPLASSER og TEST, som ikke er rundetyper i kravet.
    Scenariomal: Rundetypene i samordna opptak
      Gitt at opptaket "Samordna opptak 2027" bruker regelverkssamlingen "UHG2027"
      Når opptaksforvalter legger til en plasstildelingsrunde med rundetypen "<rundetype>" i opptaket
      Så har plasstildelingsrunden disse innstillingene
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
