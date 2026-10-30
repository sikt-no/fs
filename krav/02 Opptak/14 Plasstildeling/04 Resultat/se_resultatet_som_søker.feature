# language: no
@OPT-PLA-RES-004 @could @draft @scope-plasstildeling-2027 @depends-on-OPT-PLA-RES-002
Egenskap: Se resultatet slik søkeren ser det
  Som opptaksforvalter eller saksbehandler
  ønsker jeg å se resultatet av plasstildelingen slik søkeren ser det i Min kompetanse
  slik at jeg kan ta stikkprøver og forklare resultatet for søkeren.

  # Skilt ut 2026-10-28 (produkteier) fra vise_resultat.feature og se_publisert_resultat.feature, så det kan
  # leveres etter det som er @must. Hvem som ser resultatet før og etter publisering, står der.

  @openquestion
  Regel: Opptaksforvalter ser resultatet slik søkeren vil se det i Min kompetanse
    # ÅPNE SPØRSMÅL:
    # - Ser også saksbehandler ved lærestedet resultatet slik søkeren vil se det?
    # - HK-dir ønsker en liste med «sære» søkere å ta stikkprøver av. Hva gjør en søker sær?
    # Lagt til 2026-10-28 etter brukertestene med HK-dir (oktober 2026): HK-dir vil se det søkeren ser før publisering,
    # for å ta stikkprøver. Det søkeren ser etter publisering, står i publisere_resultat.feature.
    # Svarbrevet (svarmeldingen) er ikke med. Det utforskes for seg, se Confluence «Vedtaksbrev og svar på opptaket»
    # (https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4972347396) og HK-13784.

    Scenario: Se resultatet slik søkeren vil se det
      Gitt at plasstildelingen i "Hovedrunde" ikke er publisert
      Når opptaksforvalter ser resultatet for søknaden til "Kari Nordmann" slik søkeren vil se det
      Så ser opptaksforvalter resultatet slik det vil vises for søkeren i Min kompetanse når plasstildelingen er publisert

  Regel: Saksbehandler ser resultatet slik søkeren ser det i Min kompetanse
    # Lagt til 2026-10-28 etter brukertestene med HK-dir (oktober 2026): saksbehandlerne tar stikkprøver av resultatet,
    # og sjekker at søkerne har fått riktig vedtak, endringer i ventelisten og justeringer etter nye publiserte
    # plasstildelingsrunder. Hva søkeren ser, står i publisere_resultat.feature. Før publisering: vise_resultat.feature.
    # Svarbrevet (svarmeldingen) er ikke med. Det utforskes for seg, se Confluence «Vedtaksbrev og svar på opptaket»
    # (https://sikt.atlassian.net/wiki/spaces/STUDIEADM/pages/4972347396) og HK-13784.

    Scenario: Se resultatet slik søkeren ser det
      Gitt at plasstildelingen i "Hovedrunde" er publisert
      Når saksbehandler ser resultatet for søknaden til "Kari Nordmann" slik søkeren ser det
      Så ser saksbehandler resultatet slik det vises for søkeren i Min kompetanse

    Scenario: Se resultatet slik søkeren så det etter hver publiserte plasstildelingsrunde
      Gitt at plasstildelingene i "Hovedrunde" og "Suppleringsrunde" er publisert
      Når saksbehandler ser resultatet for søknaden til "Kari Nordmann" slik søkeren ser det
      Så ser saksbehandler resultatet søkeren fikk etter hver av plasstildelingsrundene
