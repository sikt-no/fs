# language: no
# Kilde: Jira STEK-349 «Opptakseier må kunne forvalte tilbudsgarantitypene knyttet til et opptak».
# Hvordan tilbudsgarantitypene brukes, står i
# 13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti.feature (OPT-BEH-BEH-010).
@OPT-OVO-INN-004 @could @draft @scope-tilbudsgaranti-2027
Egenskap: Forvalte tilbudsgarantityper
  Som opptaksforvalter
  ønsker jeg å forvalte tilbudsgarantitypene i opptaket
  slik at saksbehandlere, tilbydere og opptaksforvaltere kan gi tilbudsgarantiene opptaket trenger.

  # ÅPNE SPØRSMÅL:
  # - For 2027 legges typene inn i databasen per opptak. Når skal opptakseieren forvalte dem selv?
  # - Kan typene hentes fra et tidligere opptak?
  # - Hva skjer med en type som er brukt på et søknadsalternativ, når typen endres eller fjernes?

  Regel: Opptaksforvalteren legger inn tilbudsgarantitypene i opptaket

  Regel: Tilbudsgarantitypen sier hvilken rolle som kan bruke den

  Regel: Tilbudsgarantitypen sier om den gir tilbud
