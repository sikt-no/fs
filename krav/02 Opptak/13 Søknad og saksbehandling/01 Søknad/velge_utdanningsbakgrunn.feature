# language: no
# GitHub: #632, #215
#
# Kilder: Confluence PFS 4408344578 «Utdanningsbakgrunn» og
# PFS 3940188262 «2025-08-15: Utdanningsbakgrunn - Møte med HK-dir».
# Figma: Min kompetanse, node 20670-24098. Team Tind-epic TOT-1738.
@OPT-SØK-SØK-017 @must @draft @ref-OPT-SØK-SØK-001 @ref-OPT-BEH-BEH-011
Egenskap: Velge utdanningsbakgrunn i søknad
  Som søker
  ønsker jeg å oppgi hvilken utdanningsbakgrunn jeg har
  slik at søknaden min behandles av riktig instans og etter riktige regler.
  # Fristene som følger utdanningsbakgrunnen, står i @OPT-SØK-SØK-001, og fordelingen
  # av søknader etter utdanningsbakgrunn står i @OPT-BEH-BEH-011.
  # ÅPNE SPØRSMÅL:
  # - Skal søkeren få en forklaring på hvorfor en utdanningsbakgrunn er preutfylt,
  #   eller hvorfor realkompetanse ikke kan velges? HK-dir-møtet peker på at god
  #   informasjon om hvorfor er viktig.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse
    Og at søkeren har startet en søknad i opptaket "Samordna opptak 2027"

  @depends-on-OPT-OVO-INN-001
  Regel: Søkeren velger utdanningsbakgrunn blant utdanningsbakgrunnene i opptaket
    # Utdanningsbakgrunnene i opptaket legges til av opptaksforvalter.
    # Flyttet hit fra søke_på_opptak.feature 2026-10-26.

    Scenario: Søkeren velger blant utdanningsbakgrunnene i opptaket
      Gitt at opptaket har utdanningsbakgrunnene "Realkompetanse", "Utenlandsk utdanning" og "Steinerskole"
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så kan søkeren velge mellom "Realkompetanse", "Utenlandsk utdanning" og "Steinerskole"

    Scenario: En utdanningsbakgrunn som er fjernet fra opptaket, kan ikke velges
      Gitt at opptaksforvalter har fjernet utdanningsbakgrunnen "Steinerskole" fra opptaket
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så kan søkeren ikke velge "Steinerskole"

    Scenario: Utdanningsbakgrunnen velges per søknad
      Gitt at søkeren har valgt "Steinerskole" i søknaden til "Samordna opptak 2027"
      Når søkeren starter en søknad i opptaket "Lokalt opptak høst 2027"
      Så er ingen utdanningsbakgrunn valgt i søknaden til "Lokalt opptak høst 2027"

    # AVKLART 2026-10-19 (S4): Det skal ikke være mulig å registrere en søknad uten utdanningsbakgrunn.
    Scenario: Søknaden kan ikke sendes inn uten utdanningsbakgrunn
      Gitt at søkeren ikke har valgt utdanningsbakgrunn i søknaden
      Når søkeren vil sende inn søknaden
      Så kan søkeren ikke sende inn søknaden
      Og søkeren får beskjed om å velge utdanningsbakgrunn

  @openquestion
  Regel: Søkeren oppgir utdanningsland når utdanningsbakgrunnen krever det
    # ÅPNE SPØRSMÅL:
    # - Hvor er det bestemt om en utdanningsbakgrunn krever utdanningsland: på
    #   utdanningsbakgrunnen i den godkjente lista, eller per opptak av opptaksforvalter
    #   (da trengs en regel i @OPT-OVO-INN-001)?

    Scenario: Søkeren oppgir utdanningsland
      Gitt at utdanningsbakgrunnen "Utenlandsk utdanning" krever utdanningsland
      Når søkeren velger utdanningsbakgrunnen "Utenlandsk utdanning"
      Og søkeren velger utdanningslandet "Tyskland"
      Så er "Tyskland" registrert som utdanningsland i søknaden

    # Etter HK-dir-møtet 2025-08-15: de nordiske landene er med i samme liste som de andre landene.
    Scenario: Nordiske land kan velges som utdanningsland
      Gitt at utdanningsbakgrunnen "Utenlandsk utdanning" krever utdanningsland
      Når søkeren velger utdanningsbakgrunnen "Utenlandsk utdanning"
      Så kan søkeren velge "Sverige" som utdanningsland

    Scenario: Søknaden kan ikke sendes inn uten påkrevd utdanningsland
      Gitt at utdanningsbakgrunnen "Utenlandsk utdanning" krever utdanningsland
      Og at søkeren har valgt "Utenlandsk utdanning" uten å oppgi utdanningsland
      Når søkeren vil sende inn søknaden
      Så kan søkeren ikke sende inn søknaden
      Og søkeren får beskjed om å oppgi utdanningsland

  @openquestion
  Regel: Utdanningsbakgrunn og utdanningsland preutfylles fra søkerens GSK-konklusjon eller vitnemål
    # ÅPNE SPØRSMÅL:
    # - Hva skal gjelde for en søker med GSK-konklusjon: preutfylt og kan endres, steget
    #   hoppes over (som HK-dir-møtet foreslår for UHG), eller bestemt per opptak?
    # - Hvor er det bestemt hvilke GSK-konklusjoner og vitnemålstyper som er koblet til
    #   en utdanningsbakgrunn: i den godkjente lista, eller per opptak (@OPT-OVO-INN-001)?

    Scenario: Utdanningsbakgrunn preutfylles fra GSK-konklusjon
      Gitt at GSK-konklusjonen "BAC" er koblet til utdanningsbakgrunnen "Utenlandsk utdanning"
      Og at søkeren har GSK-konklusjonen "BAC" fra et tidligere opptak
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så er "Utenlandsk utdanning" preutfylt som utdanningsbakgrunn i søknaden

    Scenario: Utdanningsland preutfylles fra GSK-konklusjon
      Gitt at GSK-konklusjonen "BAC" har utdanningslandet "Frankrike"
      Og at søkeren har GSK-konklusjonen "BAC" fra et tidligere opptak
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så er "Frankrike" preutfylt som utdanningsland i søknaden

    Scenario: Siste GSK-konklusjon styrer utdanningslandet
      Gitt at søkeren fikk en GSK-konklusjon med utdanningslandet "Tyskland" i "Samordna opptak 2025"
      Og at søkeren fikk GSK-konklusjonen "BAC" med utdanningslandet "Frankrike" i "Samordna opptak 2026"
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så er "Frankrike" preutfylt som utdanningsland i søknaden

    Scenario: Utdanningsbakgrunn preutfylles fra vitnemål
      Gitt at vitnemålstypen "Studieforberedende" er koblet til utdanningsbakgrunnen "Norsk videregående"
      Og at søkeren har et studieforberedende vitnemål i kompetanseregisteret
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så er "Norsk videregående" preutfylt som utdanningsbakgrunn i søknaden

    Scenario: Søkeren kan endre preutfylt utdanningsbakgrunn
      Gitt at "Utenlandsk utdanning" er preutfylt som utdanningsbakgrunn i søknaden
      Når søkeren velger utdanningsbakgrunnen "Steinerskole"
      Så er "Steinerskole" registrert som utdanningsbakgrunn i søknaden

  @openquestion
  Regel: En søker med GSK-konklusjon kan ikke velge en utdanningsbakgrunn som er sperret for søkere med GSK-konklusjon
    # ÅPNE SPØRSMÅL:
    # - Gjelder sperren hvis steget hoppes over for søkere med GSK-konklusjon? Se spørsmålet
    #   om GSK-konklusjon under regelen om preutfylling.

    Scenario: Søker med GSK-konklusjon kan ikke velge realkompetanse
      Gitt at utdanningsbakgrunnen "Realkompetanse" ikke kan velges av søkere med GSK-konklusjon
      Og at søkeren har en GSK-konklusjon fra et tidligere opptak
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så kan søkeren ikke velge "Realkompetanse"

    Scenario: Søker uten GSK-konklusjon kan velge realkompetanse
      Gitt at utdanningsbakgrunnen "Realkompetanse" ikke kan velges av søkere med GSK-konklusjon
      Og at søkeren ikke har en GSK-konklusjon
      Når søkeren velger utdanningsbakgrunnen "Realkompetanse"
      Så er "Realkompetanse" registrert som utdanningsbakgrunn i søknaden

  @could
  Regel: Utdanningsland fra en tidligere søknad foreslås

    Scenario: Utdanningsland fra en tidligere søknad preutfylles
      Gitt at søkeren oppga utdanningslandet "Tyskland" i en søknad til "Samordna opptak 2026"
      Og at søkeren ikke har en GSK-konklusjon som gir utdanningsland
      Når søkeren velger utdanningsbakgrunnen "Utenlandsk utdanning"
      Så er "Tyskland" preutfylt som utdanningsland i søknaden

    Scenario: GSK-konklusjon går foran en tidligere søknad
      Gitt at søkeren oppga utdanningslandet "Tyskland" i en søknad til "Samordna opptak 2026"
      Og at søkeren har GSK-konklusjonen "BAC" med utdanningslandet "Frankrike" fra et tidligere opptak
      Når søkeren skal velge utdanningsbakgrunn i søknaden
      Så er "Frankrike" preutfylt som utdanningsland i søknaden
