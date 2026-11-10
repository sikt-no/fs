# language: no
#
# Kilder: Confluence PFS 4608491542 «Manuell behandling – GSK» (akseptansekravene 1–8),
# PFS 4456513553 «GSK avklaringer med HK-Dir 23. mars 2026» og PFS 4593713169
# «GSK-funksjonalitet – tilbakemeldinger fra sektor». Jira: SOPP-180.
# Skisser: Figma «FS-Admin – Seksjon Opptak», GSK-steget i saken (node 16592:71584) og
# flyten for å endre, annullere og se tidligere konklusjoner (node 10119:38745).
#
# Den automatiske GSK-konklusjonen står i OPT-BEH-BEH-015. Der står også at automatikken
# aldri overskriver en konklusjon som finnes (akseptansekrav 7), og to leverte scenarioer om at
# saksbehandleren setter og endrer konklusjonen. De står urørt til dette kravet er validert.
#
# Kode i dag (fs-admin GSKCard, fs-plattform GskVedtakService): konklusjonen er én rad per søker
# og opptak, og en endring overskriver raden, så tidligere versjoner bevares ikke. Den første
# konklusjonen kan ikke være negativ. Saksbehandleren kan ikke annullere en konklusjon i FS Admin.
# Bare organisasjonen som endret sist, lagres, og det finnes ikke noe varsel ved endring.
@OPT-BEH-BEH-042 @must @draft @ref-OPT-BEH-BEH-015
Egenskap: Sette GSK-konklusjon manuelt
  Som saksbehandler
  ønsker jeg å vurdere og sette GSK-konklusjonen når søkeren ikke har fått den automatisk
  slik at søknaden kan behandles videre på riktig grunnlag.

  GSK-konklusjonen er det første saksbehandleren tar stilling til i saken. Saksbehandleren
  vurderer om søkeren har generell studiekompetanse ut fra dokumentasjonen, og setter en positiv
  konklusjon med grunnlagskode, eller en negativ konklusjon med mangelkode. Konklusjonen kan
  endres fritt så lenge saksbehandlingen pågår. Grunnlagsdatoen settes automatisk til datoen den
  siste konklusjonen ble satt.

  Er søknaden fordelt på flere saksbehandlende organisasjoner, deler de den samme konklusjonen.
  Alle kan se og endre den, og ser hvilken organisasjon som satte den sist. Har søkeren
  konklusjoner fra før, er det den siste som gjelder. Tidligere konklusjoner bevares og kan ses.
  En positiv konklusjon kan annulleres, men det krever en aktiv bekreftelse.

  # ÅPNE SPØRSMÅL:
  # - Lagres konklusjonen på søkeren og gjelder på tvers av opptak (Confluence, krav 1), eller
  #   for søknaden i ett opptak (begreper.md, avklart 2026-11-03, og koden i dag)?
  # - Når regnes saksbehandlingen som ferdig, så konklusjonen ikke lenger kan endres fritt
  #   («låses»)? HK-dir spør det samme.
  # - Hvem får se og endre konklusjonen når søkeren har søknader i flere opptak, med ulike
  #   organisasjoner?

  Regel: Saksbehandleren setter GSK-konklusjonen når søknaden ikke har noen

    Scenario: Sette positiv GSK-konklusjon
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren setter en positiv GSK-konklusjon med grunnlagskoden KLS
      Så har søknaden en positiv GSK-konklusjon med grunnlagskoden KLS

    Scenario: Grunnlagsdatoen er datoen konklusjonen ble satt
      # Krav 2a. Automatikken bruker utstedelsesdatoen på vitnemålet (OPT-BEH-BEH-015).
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren setter en positiv GSK-konklusjon 2027-05-03
      Så er grunnlagsdatoen 2027-05-03

    Scenario: Konklusjonen viser hvem som satte den
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren setter en GSK-konklusjon
      Så viser GSK-konklusjonen den saksbehandlende organisasjonen og datoen den ble satt

    @openquestion
    Scenario: Sette negativ GSK-konklusjon
      # ÅPNE SPØRSMÅL:
      # - Kan den første konklusjonen være negativ? Den nye skissen (16592:71584) har
      #   «Godkjent» og «Avslag» også når søkeren ikke har noen konklusjon. OPT-BEH-BEH-015
      #   («Bare positive konklusjoner kan legges til når ingen finnes») og koden sier nei, og
      #   koden ber saksbehandleren registrere en mangel i stedet.
      # - Skal saksbehandleren kunne velge D- og T-kodene (sektor, PFS 4593713169)?
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren setter en negativ GSK-konklusjon med mangelkoden MFB
      Så har søknaden en negativ GSK-konklusjon med mangelkoden MFB

  Regel: Saksbehandleren kan endre GSK-konklusjonen så lenge saksbehandlingen pågår

    Scenario: Endre positiv konklusjon til negativ
      Gitt at søknaden har en positiv GSK-konklusjon som saksbehandleren har satt i opptaket
      Når saksbehandleren endrer GSK-konklusjonen til negativ med mangelkoden FAG
      Så har søknaden en negativ GSK-konklusjon med mangelkoden FAG

    Scenario: Endre negativ konklusjon til positiv
      Gitt at søknaden har en negativ GSK-konklusjon
      Når saksbehandleren endrer GSK-konklusjonen til positiv med grunnlagskoden KLS
      Så har søknaden en positiv GSK-konklusjon med grunnlagskoden KLS

    Scenario: Endre grunnlagskoden
      # Sektor ber om dette for blant annet feilsatte IMM-vedtak (PFS 4593713169).
      Gitt at søknaden har en positiv GSK-konklusjon med grunnlagskoden RFA
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så har søknaden en positiv GSK-konklusjon med grunnlagskoden KLS

    Scenario: Grunnlagsdatoen følger den siste endringen
      Gitt at søknaden har en GSK-konklusjon med grunnlagsdatoen 2027-04-20
      Når saksbehandleren endrer GSK-konklusjonen 2027-05-03
      Så er grunnlagsdatoen 2027-05-03

    Scenario: Saksbehandleren får varsel før en eksisterende konklusjon endres
      # Krav 4a.
      Gitt at søknaden har en GSK-konklusjon
      Når saksbehandleren endrer GSK-konklusjonen
      Så ser saksbehandleren et varsel om at en eksisterende GSK-konklusjon endres
      Og konklusjonen endres først når saksbehandleren bekrefter

    Scenario: Saksbehandleren angrer endringen
      Gitt at søknaden har en GSK-konklusjon
      Og at saksbehandleren endrer GSK-konklusjonen
      Når saksbehandleren avbryter endringen
      Så er GSK-konklusjonen på søknaden uendret

  Regel: De saksbehandlende organisasjonene deler GSK-konklusjonen

    Scenario: Konklusjonen satt av én organisasjon vises for en annen
      # Krav 3 og 3a.
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at saksbehandleren ved den ene organisasjonen har satt en GSK-konklusjon
      Når saksbehandleren ved den andre organisasjonen åpner saken
      Så ser saksbehandleren ved den andre organisasjonen GSK-konklusjonen
      Og saksbehandleren ved den andre organisasjonen kan endre GSK-konklusjonen

    Scenario: Varsel før en konklusjon satt av en annen organisasjon endres
      # Krav 3b.
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at GSK-konklusjonen er satt av den andre saksbehandlende organisasjonen
      Når saksbehandleren endrer GSK-konklusjonen
      Så ser saksbehandleren et varsel om at konklusjonen er satt av en annen organisasjon
      Og konklusjonen endres først når saksbehandleren bekrefter

    Scenario: Se hvem som endret konklusjonen
      # Krav 3e.
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at saksbehandleren ved den ene organisasjonen har endret GSK-konklusjonen
      Når saksbehandleren ved den andre organisasjonen ser på GSK-konklusjonen
      Så ser saksbehandleren hvilken organisasjon som endret konklusjonen, og datoen for endringen

    @openquestion
    Scenario: Den andre organisasjonen ser at konklusjonen er endret
      # Krav 3c og 3d.
      # ÅPNE SPØRSMÅL:
      # - Hvilken status ser den andre organisasjonen i søknadslisten og på søknaden, og når
      #   forsvinner den? Statusen er ikke beskrevet i Confluence eller skissene.
      # - Skal organisasjonen som satte konklusjonen, også få et varsel (HK-dir mener ja, Sikt
      #   har ikke avklart det)? Hvor får den det (se 04 Meldinger og oppgaver)?
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at GSK-konklusjonen er satt av den ene organisasjonen
      Når saksbehandleren ved den andre organisasjonen endrer GSK-konklusjonen
      Så ser saksbehandleren ved den første organisasjonen at konklusjonen er endret, i søknadslisten og på søknaden

    Scenario: Saksbehandleren uten tilgang til saken ser ikke muligheten til å endre konklusjonen
      Gitt at saksbehandleren ikke har tilgang til å behandle saken
      Når saksbehandleren ser på GSK-konklusjonen
      Så ser ikke saksbehandleren muligheten til å endre GSK-konklusjonen

  Regel: Den siste GSK-konklusjonen gjelder

    Scenario: Den siste konklusjonen er den gjeldende
      # Krav 4.
      Gitt at søkeren har en positiv GSK-konklusjon fra 2024
      Og at søkeren har en negativ GSK-konklusjon fra 2025
      Når saksbehandleren ser på GSK-konklusjonen
      Så er den negative konklusjonen fra 2025 den gjeldende

    @openquestion
    Scenario: Endret grunnlagskode på en tidligere positiv konklusjon gir en ny konklusjon
      # Krav 6 og HK-dir, alternativ 2.
      # ÅPNE SPØRSMÅL:
      # - Gjelder dette alle endringer av en konklusjon fra et tidligere opptak, eller bare
      #   grunnlagskoden?
      Gitt at søkeren har en positiv GSK-konklusjon fra et tidligere opptak
      Når saksbehandleren endrer grunnlagskoden
      Så har søknaden en ny GSK-konklusjon med den nye grunnlagskoden
      Og konklusjonen fra det tidligere opptaket er bevart som en tidligere konklusjon

  Regel: Tidligere GSK-konklusjoner bevares og kan ses

    Scenario: Se tidligere konklusjoner
      # Krav 6a.
      Gitt at søkeren har tre GSK-konklusjoner
      Når saksbehandleren velger å se tidligere konklusjoner
      Så ser saksbehandleren de to tidligere konklusjonene
      Og hver tidligere konklusjon viser grunnlagskoden eller mangelkoden, hvem som satte den og datoen

    @openquestion
    Scenario: Negative konklusjoner bevares
      # ÅPNE SPØRSMÅL:
      # - Krav 8 («Negative konklusjoner bevares») er strøket i Confluence uten forklaring. HK-dir
      #   ønsker at de bevares, og OPT-BEH-BEH-015 lagrer dem (avklart 2026-10-13), fordi en
      #   negativ konklusjon stopper gjenbruken av eldre positive. Gjelder strykingen bare noe
      #   annet, eller skal negative konklusjoner ikke vises som tidligere konklusjoner?
      Gitt at søkeren har fått en negativ GSK-konklusjon i et tidligere opptak
      Når saksbehandleren velger å se tidligere konklusjoner
      Så ser saksbehandleren den negative konklusjonen med mangelkoden

  Regel: En positiv GSK-konklusjon kan annulleres med aktiv bekreftelse

    @openquestion
    Scenario: Annullere positiv konklusjon
      # Krav 5. Skal være enklere enn i dagens løsning, der det kan ta flere måneder.
      # ÅPNE SPØRSMÅL:
      # - Rutinene for å omgjøre en positiv konklusjon er ikke avklart internt i HK-dir og i
      #   sektor. Hvem kan annullere, og på hvilke vilkår?
      # - Er det forskjell på en konklusjon satt i dette opptaket (endres fritt) og en fra et
      #   tidligere opptak (må annulleres)? Den ene skissen sier at en positiv konklusjon ikke
      #   kan endres, bare annulleres.
      # - Er begrunnelsen påkrevd?
      Gitt at søknaden har en positiv GSK-konklusjon
      Når saksbehandleren annullerer konklusjonen med en årsak til annullering og en begrunnelse
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert
      Og den annullerte konklusjonen er bevart som en tidligere konklusjon

    Scenario: Annulleringen krever bekreftelse
      Gitt at søknaden har en positiv GSK-konklusjon
      Når saksbehandleren velger å annullere konklusjonen
      Så ser saksbehandleren den nåværende konklusjonen og må bekrefte annulleringen
      Men konklusjonen er ikke annullert før saksbehandleren bekrefter

    Scenario: Annulleringen krever en årsak
      Gitt at søknaden har en positiv GSK-konklusjon
      Når saksbehandleren vil annullere konklusjonen uten å velge en årsak til annullering
      Så kan saksbehandleren ikke bekrefte annulleringen
