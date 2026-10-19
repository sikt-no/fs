# language: no
# Jira: SHI-693
@OPT-OPT-UTD-015 @must @implemented @scope-utdanningstilbud-2027
Egenskap: Overstyre regler for poenglikhet på utdanningstilbudet
  Som opptaksforvalter
  ønsker jeg å se opptakets standardregel for poenglikhet og kunne overstyre den på utdanningstilbudet
  slik at utdanningstilbudet kan bruke en annen regel når det er behov for det.

  Bakgrunn:
    Gitt at opptaksforvalter har åpnet et utdanningstilbud

  Regel: Standardregel for poenglikhet vises på utdanningstilbudet

    Scenario: Se standardregel for poenglikhet
      Gitt at opptaket har en standardregel for poenglikhet
      Så vises standardregel for poenglikhet på utdanningstilbudet

  Regel: Regel for poenglikhet kan overstyres på utdanningstilbudet

    Scenario: Overstyre regel for poenglikhet
      Når opptaksforvalter overstyrer regelen for poenglikhet på utdanningstilbudet
      Så brukes den overstyrte regelen for utdanningstilbudet

    Scenario: Kun regler tilgjengelige for opptaket kan velges
      Når opptaksforvalter overstyrer regelen for poenglikhet
      Så kan kun regler som er angitt som tilgjengelige for opptaket velges

  @draft
  Regel: Utdanningstilbudet kan ikke overstyre poenglikhetsregelen når opptaket ikke åpner for unntak
    # Virkningen av standard poenglikhetsregel uten mulighet for unntak, som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.

    Scenario: Kan ikke overstyre regel for poenglikhet når opptaket ikke åpner for unntak
      Gitt at opptaket har standardregelen "rangering etter alder" for poenglikhet uten mulighet for unntak
      Når opptaksforvalter vil overstyre regelen for poenglikhet på utdanningstilbudet
      Så kan opptaksforvalter ikke overstyre regelen for poenglikhet
      Og utdanningstilbudet bruker "rangering etter alder" ved poenglikhet
