# language: no
# BEGREPER (2026-11-10): Bytt «opptakets forvalter» med «forvalter» når fila likevel endres. Se krav/02 Opptak/begreper.md.
@OPT-PLA-INN-004 @could @draft @scope-plasstildeling-2027 @depends-on-OPT-PLA-INN-001
Egenskap: Følge opp lærestedenes gjennomgang av antall tilbud
  Som opptaksforvalter ved organisasjonen som forvalter opptaket
  ønsker jeg å varsle lærestedene og se hvem som har gått gjennom antall tilbud som skal gis
  slik at jeg vet hvem jeg må følge opp før plasstildelingen.

  # Kilde: prototypen v88 (2026-11-02). Produkteier 2026-11-02: ikke et må-krav, foreløpig Could.
  # Til dette er levert, styrer perioden på plasstildelingsrunden alene når lærestedet kan endre antall tilbud,
  # og opptakets forvalter følger opp på e-post.
  # Flyttet hit 2026-11-02 fra 05 Svar/varsler_og_meldinger_i_plasstildelingen.feature: regelen
  # «Lærestedene varsles når perioden for å endre antall tilbud åpner».

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
    Og at perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" er "2027-06-01 08:00" – "2027-07-10 16:00"

  @openquestion @depends-on-OPT-PLA-RUN-001
  Regel: Opptakets forvalter varsler lærestedene om at de kan gå gjennom antall tilbud
    # ÅPNE SPØRSMÅL:
    # - Hvem ved lærestedet får varselet? Brukertesten nevnte opptaksansvarlig eller stedfortreder, og HK-dir har lister
    #   over kontaktpersonene. Skal kontaktpunktene for opptak ligge i løsningen, eventuelt i 09 Organisasjon?
    #   Se også HK-9307 (dele informasjon med lærestedene i løsningen).
    # - Skal varselet gå automatisk når perioden åpner, eller sendes av opptakets forvalter, som i prototypen?
    # Lagt til 2026-10-28 etter brukertestene med HK-dir (oktober 2026): «Varsel om når periode åpner er gull»,
    # «Varsle lærested på nytt – melding mellom saksbehandlere» og «Varsler og oppgaver er mye enklere enn e-post».
    # AVKLART 2026-10-28 (produkteier): Varselet er en melding i FS Admin, ikke en e-post.
    Scenario: Opptakets forvalter varsler lærestedene
      Når opptakets forvalter varsler "Universitetet i Bergen" og "NTNU" om antall tilbud i "Hovedrunde"
      Så får "Universitetet i Bergen" og "NTNU" et varsel om at de kan gå gjennom antall tilbud som skal gis i "Hovedrunde"

    Scenario: Opptakets forvalter varsler et lærested på nytt
      Gitt at "Universitetet i Bergen" mangler antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde"
      Når opptakets forvalter varsler "Universitetet i Bergen" på nytt
      Så får "Universitetet i Bergen" et nytt varsel om å sette antall tilbud som skal gis i "Hovedrunde"

  Regel: Lærestedet markerer at antall tilbud er gått gjennom

    Scenario: Markere at antall tilbud er gått gjennom
      Når opptaksforvalter ved "Universitetet i Bergen" markerer at antall tilbud som skal gis i "Hovedrunde" er gått gjennom
      Så er antall tilbud for "Universitetet i Bergen" i "Hovedrunde" markert som gått gjennom

    Scenario: Lærestedet kan endre antall tilbud etter å ha markert gjennomgått
      Gitt at "Universitetet i Bergen" har markert at antall tilbud i "Hovedrunde" er gått gjennom
      Og at perioden for å endre antall tilbud som skal gis i plasstildelingsrunden "Hovedrunde" er åpen
      Så kan opptaksforvalter ved "Universitetet i Bergen" fortsatt endre antall tilbud som skal gis i "Hovedrunde"

  Regel: Opptakets forvalter ser status for gjennomgangen per lærested

    Scenario: Se status for gjennomgangen
      Gitt at "Universitetet i Bergen" er varslet, og har markert at antall tilbud i "Hovedrunde" er gått gjennom
      Og at "NTNU" er varslet, men ikke har markert at antall tilbud i "Hovedrunde" er gått gjennom
      Og at "Universitetet i Oslo" ikke er varslet om antall tilbud i "Hovedrunde"
      Når opptakets forvalter ser antall tilbud som skal gis i "Hovedrunde"
      Så ser opptakets forvalter denne statusen for lærestedene
        | Lærested               | Varslet | Gått gjennom |
        | Universitetet i Bergen | ja      | ja           |
        | NTNU                   | ja      | nei          |
        | Universitetet i Oslo   | nei     | nei          |
