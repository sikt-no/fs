# language: no
# BEGREPER (2026-11-10): Bytt «saksbehandlende organisasjon» med «behandler» når fila likevel endres. Se krav/02 Opptak/begreper.md.
@FLY-OPT-OPT-001 @must @draft @e2e
Egenskap: Opptaksløpet
  Hele opptaksløpet, fra opptaket klargjøres før søknadsåpning, til søkeren har fått studieplass
  og endringene etter søknadsåpningen er gjort. Hver fase peker på flyten som beskriver den.

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Flyten for fasen er ikke skrevet (forslaget: klargjøre_opptaket.feature).
  Regel: Opptaket klargjøres før søknadsåpning

  @depends-on-FLY-OPT-SØK-001
  Regel: Søkeren finner studier og søker

  @depends-on-FLY-OPT-SAK-001
  Regel: Søknadsalternativene fordeles til saksbehandlende organisasjoner

  @depends-on-FLY-OPT-TID-001
  Regel: Søkeren får tilbudsgaranti i tidlig opptak

  @depends-on-FLY-OPT-AUT-001 @depends-on-FLY-OPT-VAL-001 @depends-on-FLY-OPT-SAM-001 @depends-on-FLY-OPT-VIT-001 @depends-on-FLY-OPT-DOK-001 @depends-on-FLY-OPT-FLE-001 @depends-on-FLY-OPT-MAN-001 @openquestion
  # ÅPNE SPØRSMÅL:
  # - Flyten for plasstildelingen er ikke skrevet (forslaget: fra_søknad_til_studieplass.feature).
  #   Den automatiske saksbehandlingen står i automatisk_saksbehandling.feature, og på vitnemålet
  #   saksbehandleren velger eller setter sammen i automatisk_saksbehandling_på_valgt_vitnemål.feature
  #   og automatisk_saksbehandling_på_sammensatt_vitnemål.feature. Saker med opplastet dokumentasjon
  #   står i automatisk_saksbehandling_med_opplastet_dokumentasjon.feature, og saker med flere vitnemål
  #   som saksbehandleren behandler i vitnemålsbehandleren, i behandle_søknad_med_flere_vitnemål.feature. Saker uten digitalt vitnemål, som
  #   saksbehandleren behandler manuelt, står i behandle_søknad_manuelt.feature. Importen av nye og annullerte
  #   vitnemål fra KREG står i importere_vgs_vitnemål_fra_kreg.feature.
  Regel: Søknadene behandles, og studieplassene tildeles

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Flyten for fasen er ikke skrevet (forslaget: endringer_etter_søknadsåpning.feature).
  Regel: Søknader og utdanningstilbud endres etter søknadsåpning
