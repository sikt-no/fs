# language: no
# GitHub: #633
#
# Del av initiativ #215 Utdanningsbakgrunn i søknad om opptak.
# Kilder: Confluence PFS 4408344578 «Utdanningsbakgrunn» og
# PFS 3940188262 «2025-08-15: Utdanningsbakgrunn - Møte med HK-dir».
#
# AVGRENSNING
#
# Featuren beskriver bare at utdanningsbakgrunn og utdanningsland kan brukes
# som kriterier når systemet tildeler søknaden en saksbehandlende
# organisasjon. Hvordan tildelingsregler settes opp og virker generelt,
# jobbes med av et annet team. Se regelen om saksbehandlertildeling i
# samordnet_opptak.feature (@OPT-OPT-SAM-001).
#
# Systemet tildeler ikke søknader til enkeltsaksbehandlere. Fordeling innad i
# en organisasjon gjøres manuelt, for eksempel ved å filtrere på
# utdanningsbakgrunn i søknadsoversikten.
#
# Fagskoleopptak bruker ikke utdanningsbakgrunn til tildeling. Fagskolene
# behandler sine egne søkere (HK-dir-møtet 2025-08-15).
#
@OPT-BEH-BEH-006 @must @draft
Egenskap: Tildele saksbehandlende organisasjon etter utdanningsbakgrunn
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å styre hvilken organisasjon som behandler søknaden ut fra søkerens utdanningsbakgrunn
  slik at søknader behandles av organisasjonen med riktig kompetanse.

  Regel: Utdanningsbakgrunn kan styre hvilken organisasjon som behandler søknaden i samordnet opptak

    Scenario: Søknad med utenlandsk utdanning tildeles HK-dir
      Gitt at opptaket "Samordna opptak 2027" er samordnet med saksbehandling for hverandre
      Og at utdanningsbakgrunnen "Utenlandsk videregående" er knyttet til den saksbehandlende organisasjonen "HK-dir"
      Når en søker sender inn en søknad med utdanningsbakgrunnen "Utenlandsk videregående"
      Så får søknaden "HK-dir" som saksbehandlende organisasjon

    Scenario: Tildeling etter utdanningsbakgrunn er ikke tilgjengelig i lokale opptak
      Gitt at opptaket "Lokalt opptak høst 2027" er opprettet som lokalt
      Så kan ikke utdanningsbakgrunn knyttes til en saksbehandlende organisasjon

  Regel: Utdanningsland kan unnta søknader fra tildeling etter utdanningsbakgrunn i samordnet opptak

    # Eksempel fra HK-dir: HK-dir behandler alle søknader med utenlandsk
    # utdanning, unntatt søknader fra en gitt gruppe land, for eksempel de
    # nordiske. Søknader fra de unntatte landene følger standard tildeling.

    Scenario: Søknad fra land som ikke er unntatt tildeles etter utdanningsbakgrunn
      Gitt at opptaket "Samordna opptak 2027" er samordnet med saksbehandling for hverandre
      Og at utdanningsbakgrunnen "Utenlandsk videregående" er knyttet til den saksbehandlende organisasjonen "HK-dir"
      Og at de nordiske landene er unntatt fra denne koblingen
      Når en søker sender inn en søknad med utdanningsbakgrunnen "Utenlandsk videregående" og utdanningslandet "Tyskland"
      Så får søknaden "HK-dir" som saksbehandlende organisasjon

    Scenario: Søknad fra unntatt land følger standard tildeling
      Gitt at opptaket "Samordna opptak 2027" er samordnet med saksbehandling for hverandre
      Og at utdanningsbakgrunnen "Utenlandsk videregående" er knyttet til den saksbehandlende organisasjonen "HK-dir"
      Og at de nordiske landene er unntatt fra denne koblingen
      Når en søker sender inn en søknad med utdanningsbakgrunnen "Utenlandsk videregående" og utdanningslandet "Sverige"
      Så tildeles søknaden en saksbehandlende organisasjon etter standard tildeling

  @implemented
  Regel: Saksbehandler kan filtrere søknader på utdanningsbakgrunn

    Scenario: Filtrere på utdanningsbakgrunn
      Gitt at saksbehandleren ser søknadsoversikten for "Samordna opptak 2027"
      Når saksbehandleren velger utdanningsbakgrunnen "Steinerskole" som filter
      Så vises kun søknader med utdanningsbakgrunnen "Steinerskole"

# ÅPNE SPØRSMÅL:
# - Får søknaden ny saksbehandlende organisasjon hvis søker endrer
#   utdanningsbakgrunn eller utdanningsland før fristen for endring?
# - HK-dir bruker i dag valget til varslinger og en egen kode i
#   saksbehandlingen, og venter med å behandle enkelte grupper fordi
#   dokumentasjon kommer senere. Skal det dekkes her, eller i et eget krav?
