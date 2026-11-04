# language: no
@OPT-OVO-GRU-003 @could @draft
Egenskap: Opptakstyper med navn og forkortelse
  Som opptaksforvalter
  ønsker jeg at opptakstypene har et navn og en forkortelse som kan brukes på flere opptak
  slik at opptak av samme slag kan kjennes igjen i oversikten over opptak.

  # Lagt til 2026-10-27 etter akseptansetesten av opprette opptak 2027 (TAKE-456). Fagskoleopptaket hadde
  # forkortelsen FSU, men skal ha HYU. Nå rettes bare dataene. Innsikten er at forkortelsen fungerer som en
  # merkelapp som kan gjenbrukes, og ikke trenger å være unik på tvers av opptak.
  # Feature-ID-en er 003, fordi 002 ble brukt om et forslag om publisering av opptak
  # (krav/_kravanalyser/hk-dir-krav-dekning.md).
  #
  # ÅPNE SPØRSMÅL:
  # - Hvem forvalter opptakstypene og forkortelsene: Sikt, eller opptaksforvalterne?
  # - Skal forkortelsen kunne brukes på opptakstyper i flere organisasjoner, for eksempel HYU i både samordna og
  #   lokale opptak?
  # - Skal forkortelsen vises andre steder enn i oversikten over opptak, for eksempel for søkerne?

  @openquestion
  Regel: Flere opptak kan ha opptakstyper med samme forkortelse
    # ÅPNE SPØRSMÅL:
    # - Er det forkortelsen på opptakstypen eller på opptaket som gjenbrukes?

    Scenario: To opptak med samme forkortelse
      Gitt at opptakstypen "Fagskoleopptak" har forkortelsen "HYU"
      Og at opptakene "Samordna opptak høst 2027" og "Samordna opptak vår 2028" har opptakstypen "Fagskoleopptak"
      Når opptaksforvalter ser oversikten over opptak
      Så har begge opptakene forkortelsen "HYU"
