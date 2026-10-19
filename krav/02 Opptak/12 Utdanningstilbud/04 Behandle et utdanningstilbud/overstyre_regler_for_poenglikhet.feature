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
