# language: no
# GitHub: #216
@OPT-REG-RUN-001 @must @in-progress @scope-plasstildeling-2027
Egenskap: Rundetyper for plasstildelingsrunder
  Som opptaksforvalter
  ønsker jeg at løsningen har rundetypene opptaket trenger, med innstillingene deres
  slik at plasstildelingsrundene i opptaket følger reglene for opptaket.

  # AVKLART 2026-10-24 (produkteier): En rundetype er et navn og et sett med innstillinger for
  # plasstildelingsrunder. Plasstildelingen leser innstillingene, og ser aldri på hvilken rundetype det er.
  # Rundetypene var en del av regelverket, som kvotetypene, og gjaldt alle opptak som bruker
  # regelverkssamlingen. Erstattet av avklaringen fra 2026-11-04 under.
  # AVKLART 2026-11-04 (produkteier, kodesjekken i fs-specify): Rundetypene er felles for alle opptak i første
  # leveranse, og er ikke en del av regelverkssamlingen. Koden har dem som et felles kodeverk. Om de skal høre til
  # regelverkssamlingen, avgjøres når rundetypene skal kunne forvaltes (forvalte_rundetyper.feature).
  # AVKLART 2026-10-29 (produkteier): Å forvalte rundetypene (legge til, endre og slette) er ikke med nå, og står i
  # forvalte_rundetyper.feature (@could). Plasstildelingen bruker rundetypene som finnes, og hovedtildeling, supplering
  # og etterfylling, med innstillingene under, er de som trengs i første omgang.
  # AVKLART 2026-11-04: Standardverdien for taket for antall tilbud per søker er en innstilling på rundetypen.
  # AVKLART 2026-11-05: Standardverdien for taket for antall tilbud på ledige studieplasser per søker er også en
  # innstilling på rundetypen.
  # Plasstildelingsrunden får taket for antall tilbud per søker når den legges til, og taket for antall tilbud på ledige
  # studieplasser per søker når den åpnes for ledige studieplasser, med standardverdiene fra rundetypen. Opptaksforvalter
  # kan endre takene på runden. De andre innstillingene kan ikke justeres på plasstildelingsrunden.
  # Se 14 Plasstildeling/01 Runder/forvalte_runder.feature.
  # Hva plasstildelingen gjør med innstillingene, står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.

  Regel: Opptakene har rundetypene hovedtildeling, supplering og etterfylling

    # Kodeverket har også TIDLIG, LEDIGE_STUDIEPLASSER og TEST, som ikke er rundetyper i kravet.
    Scenariomal: Rundetypene i samordna opptak
      Gitt at opptaket "Samordna opptak 2027" er opprettet
      Når opptaksforvalter legger til en plasstildelingsrunde med rundetypen "<rundetype>" i opptaket
      Så har plasstildelingsrunden disse innstillingene
        | Innstilling                                                                 | Verdi          |
        | Tilbud gir bortfall på lavere prioriteter                                   | <bortfall>     |
        | Kompensasjonstilbud ved opprykk                                             | <kompensasjon> |
        | Bygger på forrige publiserte plasstildelingsrunde                           | <arv>          |
        | Bare én i opptaket                                                          | <én>           |
        | Kan åpnes for ledige studieplasser                                          | <ledige>       |
        | Standardverdi for taket for antall tilbud per søker                         | <tak>          |
        | Standardverdi for taket for antall tilbud på ledige studieplasser per søker | <tak_ledige>   |

      Eksempler:
        | rundetype      | bortfall | kompensasjon | arv | én  | ledige | tak | tak_ledige |
        | Hovedtildeling | ja       | nei          | nei | ja  | ja     | 1   | 10         |
        | Supplering     | ja       | ja           | ja  | nei | ja     | 1   | 10         |
        | Etterfylling   | nei      | nei          | ja  | nei | ja     | 10  | 10         |
