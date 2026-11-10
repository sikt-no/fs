# language: no
#
# Kilder: Confluence PFS 4608491542 «Manuell behandling – GSK» (akseptansekravene 1–8),
# PFS 4456513553 «GSK avklaringer med HK-Dir 23. mars 2026» og PFS 4593713169
# «GSK-funksjonalitet – tilbakemeldinger fra sektor». Jira: SOPP-180.
# Skisse: Figma «FS-Admin – Seksjon Opptak», seksjonen «GSK» (node 18259:99465). Den er justert
# etter tilbakemeldingene om flyten. De eldre skissene gjelder ikke.
# Avklart i møte 10.11.2026 (Marit, Sofie, Erik), svar i PR #1003.
#
# Den automatiske GSK-konklusjonen står i OPT-BEH-BEH-015. Der står også at automatikken
# aldri overskriver en konklusjon som finnes (akseptansekrav 7).
#
# Kode i dag (fs-admin GSKCard, fs-plattform GskVedtakService): konklusjonen er én rad per søker
# og opptak, og en endring overskriver raden, så tidligere versjoner bevares ikke. Saksbehandleren
# kan sette «Ikke kvalifisert» med mangelkode, og kan ikke annullere en konklusjon i FS Admin.
# Bare organisasjonen som endret sist, lagres. Tilgangen følger saken, ikke personen.
@OPT-BEH-BEH-042 @must @draft @ref-OPT-BEH-BEH-015
Egenskap: Sette GSK-konklusjon manuelt
  Som saksbehandler
  ønsker jeg å vurdere, sette og rette GSK-konklusjonen når den ikke er satt automatisk, eller er feil
  slik at søknaden kan behandles videre på riktig grunnlag.

  GSK-konklusjonen er det første saksbehandleren tar stilling til i saken. Saksbehandleren
  vurderer om søkeren har generell studiekompetanse ut fra dokumentasjonen, og setter
  konklusjonen ved å velge grunnlagskoden søkeren har generell studiekompetanse på.

  Konklusjonen følger personen, og gjenbrukes i senere opptak. Den som har tilgang til å se
  personen, ser konklusjonene, og den som har tilgang til å endre personen, kan endre dem. Det
  er den siste konklusjonen som gjelder. Konklusjonen kan endres fritt til opptaket er historisk,
  også når den er satt automatisk, og tidligere konklusjoner bevares og kan ses. En positiv
  konklusjon kan annulleres av organisasjonen som satte den, og av HK-dir.

  Det finnes ingen negativ GSK-konklusjon. Har søkeren ikke dokumentert generell
  studiekompetanse, registrerer saksbehandleren en mangel, som andre mangler
  (OPT-BEH-BEH-008).

  # ÅPNE SPØRSMÅL:
  # - Grunnlagskodene for GSK settes i regelverkssamlingen (OPT-REG-GRU-001). Det blir feil når
  #   konklusjonen deles på tvers av opptak og år, og tidligere konklusjoner vises i dag selv om
  #   grunnlagskoden ikke er i regelverkssamlingen opptaket bruker. Hvor skal grunnlagskodene for
  #   GSK ligge, og hvilke kan saksbehandleren velge?

  @ref-OPT-REG-GRU-001
  Regel: Saksbehandleren setter GSK-konklusjonen med en grunnlagskode

    Scenario: Sette GSK-konklusjon
      Gitt at søkeren ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen med grunnlagskoden KLS
      Så har søkeren en GSK-konklusjon med grunnlagskoden KLS

    Scenario: Grunnlagsdatoen er datoen konklusjonen ble satt
      # Akseptansekrav 2a. Automatikken bruker utstedelsesdatoen på vitnemålet (OPT-BEH-BEH-015).
      Gitt at søkeren ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen 2027-05-03
      Så er grunnlagsdatoen 2027-05-03

    Scenario: Konklusjonen viser hvem som satte den
      Gitt at søkeren ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen
      Så viser GSK-konklusjonen organisasjonen saksbehandleren er ved, og datoen den ble satt

  @ref-OPT-BEH-BEH-008
  Regel: Manglende generell studiekompetanse registreres som en mangel

    Scenario: Ingen negativ GSK-konklusjon
      # Avklart 10.11.2026.
      Gitt at søkeren ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen
      Så kan saksbehandleren bare velge en grunnlagskode for generell studiekompetanse

  @ref-OPT-OVO-GRU-004
  Regel: Saksbehandleren kan endre GSK-konklusjonen til opptaket er historisk
    # Avklart 10.11.2026: konklusjonen låses omtrent når opptaket arkiveres. I kravene om status
    # på opptaket (OPT-OVO-GRU-004) er det når opptaket gjøres historisk.

    Scenario: Endre grunnlagskoden
      # Sektor ber om dette for blant annet feilsatte IMM-vedtak (PFS 4593713169).
      Gitt at søkeren har en GSK-konklusjon med grunnlagskoden RFA
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så har søkeren en GSK-konklusjon med grunnlagskoden KLS

    Scenario: Endre en konklusjon som er satt automatisk
      # Skissen, «Automatisk behandlet». Automatikken overskriver aldri en konklusjon
      # saksbehandleren har satt (OPT-BEH-BEH-015).
      Gitt at søkeren har fått GSK-konklusjonen automatisk med grunnlagskoden KLY
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så har søkeren en GSK-konklusjon med grunnlagskoden KLS
      Og GSK-konklusjonen viser organisasjonen saksbehandleren er ved, og datoen den ble endret

    Scenario: Grunnlagsdatoen følger den siste endringen
      Gitt at søkeren har en GSK-konklusjon med grunnlagsdatoen 2027-04-20
      Når saksbehandleren endrer GSK-konklusjonen 2027-05-03
      Så er grunnlagsdatoen 2027-05-03

    Scenario: Den forrige konklusjonen bevares når konklusjonen endres
      # Akseptansekrav 6 og 6a, og HK-dir, alternativ 2.
      Gitt at søkeren har en GSK-konklusjon med grunnlagskoden RFA
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så er konklusjonen med grunnlagskoden RFA bevart som en tidligere konklusjon

    Scenario: Saksbehandleren angrer endringen
      Gitt at søkeren har en GSK-konklusjon
      Og at saksbehandleren endrer GSK-konklusjonen
      Når saksbehandleren avbryter endringen
      Så er GSK-konklusjonen uendret

    Scenario: Konklusjonen kan ikke endres i et historisk opptak
      Gitt at søkeren har fått GSK-konklusjonen i opptaket "Samordna opptak 2027"
      Og at opptaket "Samordna opptak 2027" er historisk
      Når saksbehandleren ser på GSK-konklusjonen i saken i "Samordna opptak 2027"
      Så ser ikke saksbehandleren muligheten til å endre GSK-konklusjonen

    Scenario: En konklusjon fra et historisk opptak endres i et nytt opptak
      # Akseptansekrav 6. Konklusjonen fra det historiske opptaket står urørt.
      Gitt at søkeren har fått GSK-konklusjonen med grunnlagskoden RFA i et historisk opptak
      Når saksbehandleren endrer grunnlagskoden til KLS i en sak i et opptak som ikke er historisk
      Så har søkeren en ny GSK-konklusjon med grunnlagskoden KLS
      Og konklusjonen med grunnlagskoden RFA er bevart som en tidligere konklusjon

  Regel: GSK-konklusjonen følger personen

    Scenario: Konklusjonen satt av én organisasjon vises for en annen
      # Akseptansekrav 3 og 3a.
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at saksbehandleren ved den ene organisasjonen har satt GSK-konklusjonen
      Når saksbehandleren ved den andre organisasjonen åpner saken
      Så ser saksbehandleren ved den andre organisasjonen GSK-konklusjonen
      Og saksbehandleren ved den andre organisasjonen kan endre GSK-konklusjonen

    Scenario: Se hvem som endret konklusjonen
      # Akseptansekrav 3e. Varsel til organisasjonen som satte konklusjonen, er ikke aktuelt
      # (avklart 10.11.2026). Den finner sakene med et filter i sakslisten for saker der noen
      # andre har gjort noe, som gjelder mer enn GSK, og hører hjemme i kravet om sakslisten.
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at saksbehandleren ved den ene organisasjonen har endret GSK-konklusjonen
      Når saksbehandleren ved den andre organisasjonen ser på GSK-konklusjonen
      Så ser saksbehandleren hvilken organisasjon som endret konklusjonen, og datoen for endringen

    Scenario: Saksbehandleren med tilgang til å se personen ser konklusjonen
      Gitt at saksbehandleren har tilgang til å se personen, men ikke til å endre personen
      Når saksbehandleren ser på GSK-konklusjonen
      Så ser saksbehandleren GSK-konklusjonen og de tidligere konklusjonene
      Men saksbehandleren ser ikke muligheten til å endre GSK-konklusjonen

  Regel: Den siste GSK-konklusjonen gjelder

    Scenario: Den siste konklusjonen er den gjeldende
      # Akseptansekrav 4.
      Gitt at søkeren har en GSK-konklusjon med grunnlagskoden RFA fra 2024
      Og at søkeren har en GSK-konklusjon med grunnlagskoden KLS fra 2025
      Når saksbehandleren ser på GSK-konklusjonen
      Så er konklusjonen med grunnlagskoden KLS den gjeldende

    Scenario: Se tidligere konklusjoner
      # Akseptansekrav 6a.
      Gitt at søkeren har tre GSK-konklusjoner
      Når saksbehandleren velger å se tidligere konklusjoner
      Så ser saksbehandleren de to tidligere konklusjonene
      Og hver tidligere konklusjon viser grunnlagskoden, hvem som satte den og datoen

  Regel: Organisasjonen som satte konklusjonen, og HK-dir kan annullere den
    # Akseptansekrav 5: annulleringen skal kreve aktiv bekreftelse, men være enklere enn i dagens
    # løsning. Avklart 10.11.2026: årsaken velges fra en liste (kodeverket for annulleringsårsaker
    # i SODA, som kanskje må gjenskapes), og er påkrevd. Det er ingen begrunnelse i fritekst, så
    # fritekstfeltet «Begrunnelse» i skissen skal ikke være med.

    Scenario: Annullere konklusjonen
      Gitt at saksbehandleren ved organisasjonen som satte GSK-konklusjonen, ser på konklusjonen
      Når saksbehandleren annullerer konklusjonen med en årsak til annullering
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert
      Og den annullerte konklusjonen er bevart som en tidligere konklusjon

    Scenario: HK-dir kan annullere en konklusjon satt av en annen organisasjon
      Gitt at GSK-konklusjonen er satt av en annen organisasjon enn HK-dir
      Når saksbehandleren ved HK-dir annullerer konklusjonen med en årsak til annullering
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert

    Scenario: En annen organisasjon kan ikke annullere konklusjonen
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at GSK-konklusjonen er satt av den ene organisasjonen
      Når saksbehandleren ved den andre organisasjonen ser på GSK-konklusjonen
      Så ser ikke saksbehandleren muligheten til å annullere konklusjonen

    @openquestion
    Scenario: Annullere en konklusjon som er satt automatisk
      # Skissen, «Automatisk behandlet», har «Annuller konklusjon».
      # ÅPNE SPØRSMÅL:
      # - En automatisk konklusjon er ikke satt av noen organisasjon. Er det bare HK-dir som kan
      #   annullere den, eller også de saksbehandlende organisasjonene?
      Gitt at søkeren har fått GSK-konklusjonen automatisk
      Når saksbehandleren ved HK-dir annullerer konklusjonen med en årsak til annullering
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert

    Scenario: Annulleringen krever bekreftelse
      Gitt at saksbehandleren ved organisasjonen som satte GSK-konklusjonen, ser på konklusjonen
      Når saksbehandleren velger å annullere konklusjonen
      Så ser saksbehandleren den nåværende konklusjonen og må bekrefte annulleringen
      Men konklusjonen er ikke annullert før saksbehandleren bekrefter

    Scenario: Annulleringen krever en årsak
      Gitt at saksbehandleren ved organisasjonen som satte GSK-konklusjonen, ser på konklusjonen
      Når saksbehandleren vil annullere konklusjonen uten å velge en årsak til annullering
      Så kan saksbehandleren ikke bekrefte annulleringen

    Scenario: Ny konklusjon etter annulleringen
      # Avklart 10.11.2026: både saksbehandleren og automatikken kan sette en ny konklusjon.
      Gitt at søkerens GSK-konklusjon er annullert
      Når saksbehandleren setter GSK-konklusjonen med grunnlagskoden KLS
      Så har søkeren en GSK-konklusjon med grunnlagskoden KLS

    Scenario: Automatikken kan sette en ny konklusjon etter annulleringen
      Gitt at søkerens GSK-konklusjon er annullert
      Og at søkeren har et vitnemål som gir GSK
      Når den automatiske behandlingen kjører for opptaket
      Så får søkeren en GSK-konklusjon fra vitnemålet
