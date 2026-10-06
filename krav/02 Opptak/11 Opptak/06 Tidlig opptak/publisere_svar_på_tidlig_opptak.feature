# language: no
# GitHub: #456
@OPT-OPT-TID-001 @must @draft
Egenskap: Publisere svar på tidlig opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å styre når svaret på tidlig opptak blir synlig for søkerne, og sende dem melding om utfallet
  slik at alle søkere får svar samtidig og først etter at tilbudsgarantiene er kvalitetssikret.

  # Kravet forutsetter at søkerne har søkt om tidlig opptak, at saksbehandlerne har konkludert,
  # og at tilbudsgarantier for tidlig opptak er tildelt. Konklusjonen og gjennomføringen av
  # tidligopptaket står i gi_tilbudsgaranti_ved_tidlig_opptak.feature (OPT-BEH-BEH-007, #654),
  # i regelen "Opptaksforvalter gjennomfører tidligopptaket".
  # Søkerens side av svaret er beskrevet i
  # krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/se_svar_på_tidlig_opptak.feature.
  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er åpnet for tidlig opptak

  # Publiseringsdatoen (T-day) ligger på opptaket, jf. prosesshypotesen i notatet
  # "2026-09-23 tidligopptaks-svar til søker".
  # Merk avvik som må ryddes: krav/02 Opptak/12 Utdanningstilbud/opptaksinnstillinger_utdanningstilbud.feature
  # legger i dag "dato for når svar sendes til søkere" på det enkelte utdanningstilbudet.
  # Den datoen må fjernes eller omdefineres der, slik at det finnes én publiseringsdato per opptak.
  Regel: Opptaksforvalter setter publiseringsdato for svar på tidlig opptak

    Scenario: Sette publiseringsdato
      Når opptaksforvalter setter publiseringsdato for svar på tidlig opptak til 20. april 2027
      Så blir svaret på tidlig opptak tidligst publisert til søkerne 20. april 2027

    Scenario: Endre publiseringsdato før den er passert
      Gitt at publiseringsdatoen for svar på tidlig opptak ikke er passert
      Når opptaksforvalter endrer publiseringsdatoen for svar på tidlig opptak
      Så er det den nye datoen som gjelder for publisering av svaret

  # Publisering henger på gjennomføringen, ikke bare på datoen: søkerne skal aldri møte et
  # tomt svar fordi datoen passerte uten at tidligopptaket var gjennomført.
  Regel: Svaret publiseres først når tidligopptaket er gjennomført

    Scenario: Svaret publiseres ikke når tidligopptaket ikke er gjennomført
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Men tidligopptaket er ikke gjennomført
      Så er ikke svaret på tidlig opptak publisert til søkerne

    Scenario: Svaret publiseres når tidligopptaket gjennomføres etter publiseringsdatoen
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at tidligopptaket ikke er gjennomført
      Når opptaksforvalter gjennomfører tidligopptaket
      Så er svaret på tidlig opptak publisert til søkerne

  # Hva søkeren faktisk ser før og etter publiseringsdatoen, er beskrevet i
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

  # Regelen over beskriver den fullførte utsendingen. Regelen under legger et
  # bekreftelsessteg foran den, og endrer ikke utfallet — søkerne mottar de samme meldingene.
  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Skal opptaksforvalter kunne kontrollere meldingsinnholdet før det når søkerne?
  #   I dagens SO-løsning holdes brevene tilbake for en siste sjekk. Aktuelle varianter er
  #   forhåndsvisning ved utløsning, en angrefrist der meldingene kan trekkes tilbake,
  #   eller begge deler. Scenarioet under beskriver forhåndsvisning, og er et forslag.
  #   Merk at prosesshypotesen i notatet "2026-09-23 tidligopptaks-svar til søker" skiller
  #   kjøringen av automatikken (før publiseringsdatoen) fra meldingen (etter), slik at
  #   embargoen fra SO-løsningen ikke lenger er den samme mekanismen. Se også det åpne
  #   spørsmålet nederst om dry-run er tilstrekkelig kvalitetssikring.
  Regel: Opptaksforvalter kontrollerer meldingsinnholdet før utsending

    Scenario: Forhåndsvise meldingen før utsending
      Gitt at svaret på tidlig opptak er publisert
      Når opptaksforvalter starter utsending av melding om svar på tidlig opptak
      Så ser opptaksforvalter en forhåndsvisning av meldingen
      Og meldingene sendes først når opptaksforvalter bekrefter utsendingen

# ÅPNE SPØRSMÅL:
# - Kravet forutsetter at gjennomføringen gir hver søker tilbudsgaranti på høyst ett
#   søknadsalternativ, jf. STEK-269. OPT-BEH-BEH-007 i #654 har ingen regel om det ennå.
#   Må samkjøres med #654.
# - Kan opptaksforvalter utløse utsendingen flere ganger, for eksempel etter en omkjøring
#   av tildelingsrutinen? I så fall: får søkere som allerede har fått melding en ny melding?
# - Skal opptaksforvalter se utfallet av tidlig opptak før publiseringsdatoen, eller er
#   dry-run av tildelingsrutinen den eneste kvalitetssikringen før publisering?
