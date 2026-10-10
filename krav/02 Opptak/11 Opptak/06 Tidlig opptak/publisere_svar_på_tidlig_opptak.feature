# language: no
# GitHub: #456
@OPT-OPT-TID-001 @must @in-progress
Egenskap: Publisere svar på tidlig opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg at svaret på tidlig opptak blir synlig for søkerne når jeg gjennomfører tidligopptaket, og å sende dem melding om utfallet
  slik at alle søkere får svar samtidig, og først etter at tilbudsgarantiene er kontrollert i prøvekjøringen.

  # AVKLART 09.10.2026 (review av PR #654): Det er ingen egen publiseringsdato for
  # tidlig opptak. Svaret blir synlig for søkerne når opptaksforvalter gjennomfører
  # tidligopptaket, ikke når tidligopptaket prøvekjøres. En ny gjennomføring endrer
  # det søkerne ser med en gang. Meldingen sendes i et eget steg etterpå. Erstatter
  # publiseringsdatoen fra 25.09.2026, som var en midlertidig løsning fordi svaret
  # ble utledet fra saksbehandlingen og ikke kunne vite om tidligopptaket var kjørt.

  # Kravet forutsetter at søkerne har søkt om tidlig opptak, at saksbehandlerne har konkludert,
  # og at tilbudsgarantier for tidlig opptak er tildelt. Konklusjonen og gjennomføringen av
  # tidligopptaket står i gi_tilbudsgaranti_ved_tidlig_opptak.feature (OPT-BEH-BEH-007, #654),
  # i regelen "Opptaksforvalter gjennomfører tidligopptaket".
  # Søkerens side av svaret er beskrevet i
  # krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/se_svar_på_tidlig_opptak.feature.
  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er åpnet for tidlig opptak

  Regel: Svaret publiseres når tidligopptaket gjennomføres

    Scenario: Svaret er ikke publisert før tidligopptaket er gjennomført
      Gitt at tidligopptaket ikke er gjennomført
      Så er ikke svaret på tidlig opptak publisert til søkerne

    Scenario: Prøvekjøring publiserer ikke svaret
      Gitt at tidligopptaket ikke er gjennomført
      Når opptaksforvalter prøvekjører tidligopptaket
      Så er ikke svaret på tidlig opptak publisert til søkerne

    Scenario: Svaret publiseres når tidligopptaket gjennomføres
      Når opptaksforvalter gjennomfører tidligopptaket
      Så er svaret på tidlig opptak publisert til søkerne

  # Hva søkeren faktisk ser før og etter at svaret er publisert, er beskrevet i
  # krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/se_svar_på_tidlig_opptak.feature.
  #
  # Meldingen gjelder kun tilbudsgarantiene for tidlig opptak som opptaksforvalter har delt
  # ut, og en søker er innvilget på høyst ett søknadsalternativ. Andre tilbudsgarantier —
  # særlig reservert studieplass — omtales ikke i denne meldingen.
  Regel: Opptaksforvalter utløser utsending av melding om svar på tidlig opptak

    Scenario: Sende melding om svar på tidlig opptak
      Gitt at svaret på tidlig opptak er publisert
      Når opptaksforvalter sender ut melding om svar på tidlig opptak
      Så mottar hver søker som har søkt om tidlig opptak i opptaket en melding om utfallet
      Men søkere uten søknad om tidlig opptak mottar ingen melding

    Scenariomal: Meldingen gjenspeiler søkerens utfall
      Gitt at svaret på tidlig opptak er publisert
      Og at søkerens samlede utfall i tidlig opptak er "<utfall>"
      Når opptaksforvalter sender ut melding om svar på tidlig opptak
      Så mottar søkeren en melding som sier "<budskap>"

      Eksempler:
        | utfall                                     | budskap                                                          |
        | innvilget på ett søknadsalternativ         | søkeren er innvilget tidlig opptak og bør kontrollere prioriteringen sin |
        | ikke innvilget på noen søknadsalternativer | søkeren er ikke innvilget tidlig opptak                          |

    Scenario: Meldingen sendes på søkerens språk
      Gitt at svaret på tidlig opptak er publisert
      Og at søkeren har valgt engelsk som språk
      Når opptaksforvalter sender ut melding om svar på tidlig opptak
      Så mottar søkeren meldingen på engelsk

    # Gjennomføringen og utsendingen er to separate steg (avklart 09.10.2026).
    Scenario: Gjennomføring sender ingen melding
      Når opptaksforvalter gjennomfører tidligopptaket
      Så mottar ingen søkere melding om svar på tidlig opptak

    Scenario: Meldingen om svar på tidlig opptak sendes bare én gang
      Gitt at opptaksforvalter har sendt ut melding om svar på tidlig opptak
      Når opptaksforvalter vil sende ut melding om svar på tidlig opptak igjen
      Så ser ikke opptaksforvalter muligheten til å sende ut meldingen på nytt

  # Regelen over beskriver den fullførte utsendingen. Regelen under legger et
  # bekreftelsessteg foran den, og endrer ikke utfallet — søkerne mottar de samme meldingene.
  #
  # AVKLART 08.10.2026: Opptaksforvalter kontrollerer meldingen med en forhåndsvisning,
  # og bekrefter før meldingene sendes. Det er ingen angrefrist etter utsendingen.
  # Hvem som får tilbudsgaranti, er kontrollert i prøvekjøringen av tidligopptaket,
  # se gi_tilbudsgaranti_ved_tidlig_opptak.feature.
  Regel: Opptaksforvalter kontrollerer meldingsinnholdet før utsending

    Scenario: Forhåndsvise meldingen før utsending
      Gitt at svaret på tidlig opptak er publisert
      Når opptaksforvalter starter utsending av melding om svar på tidlig opptak
      Så ser opptaksforvalter en forhåndsvisning av meldingen
      Og meldingene sendes først når opptaksforvalter bekrefter utsendingen

# AVKLART 08.10.2026: Søkerne får melding én gang, når svaret på tidlig opptak er
# publisert. Opptaksforvalter kan prøvekjøre og gjennomføre tidligopptaket så mange
# ganger som trengs før det, uten at søkerne får melding. (Endret 09.10.2026:
# gjennomføringen publiserer svaret, men sender ingen melding. Meldingen sendes når
# opptaksforvalter starter utsendingen.)
