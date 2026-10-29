# language: no
@FLY-OPT-OPT-001 @must @draft @e2e
Egenskap: Opptaksløpet
  Hele opptaksløpet, fra opptaket klargjøres før søknadsåpning, til søkeren har fått studieplass
  og endringene etter søknadsåpningen er gjort. Hver fase peker på flyten som beskriver den.

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Flyten for fasen er ikke skrevet (forslaget: klargjøre_opptaket.feature).
  Regel: Opptaket klargjøres før søknadsåpning

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Flyten for fasen er ikke skrevet (forslaget: finne_og_søke_studier.feature).
  Regel: Søkeren finner studier og søker

  @depends-on-FLY-OPT-SAK-001
  Regel: Søknadsalternativene fordeles til saksbehandlende organisasjoner

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Flyten for fasen er ikke skrevet (forslaget: tidlig_opptak.feature).
  Regel: Søkeren får tilbudsgaranti i tidlig opptak

  @depends-on-FLY-OPT-AUT-001 @depends-on-FLY-OPT-VIT-001 @openquestion
  # ÅPNE SPØRSMÅL:
  # - Flyten for plasstildelingen er ikke skrevet (forslaget: fra_søknad_til_studieplass.feature).
  #   Den automatiske saksbehandlingen står i automatisk_saksbehandling.feature, og importen av
  #   nye og annullerte vitnemål fra KREG i importere_vgs_vitnemål_fra_kreg.feature.
  Regel: Søknadene behandles, og studieplassene tildeles

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Flyten for fasen er ikke skrevet (forslaget: endringer_etter_søknadsåpning.feature).
  Regel: Søknader og utdanningstilbud endres etter søknadsåpning
