# language: no
#
# Kilder: Confluence PFS 4608491542 «Manuell behandling – GSK» (akseptansekravene 1–8),
# PFS 4456513553 «GSK avklaringer med HK-Dir 23. mars 2026» og PFS 4593713169
# «GSK-funksjonalitet – tilbakemeldinger fra sektor». Jira: SOPP-180.
# Skisse: Figma «FS-Admin – Seksjon Opptak», seksjonen «GSK» (node 18259:99465). Den er justert
# etter tilbakemeldingene om flyten, og gjelder foran de eldre skissene (16592:71584 med
# «Godkjent» og «Avslag», og «Til annullering» i 18460:101575).
#
# Den automatiske GSK-konklusjonen står i OPT-BEH-BEH-015. Der står også at automatikken
# aldri overskriver en konklusjon som finnes (akseptansekrav 7), og to leverte scenarioer om at
# saksbehandleren setter og endrer konklusjonen. De står urørt til dette kravet er validert.
#
# Kode i dag (fs-admin GSKCard, fs-plattform GskVedtakService): konklusjonen er én rad per søker
# og opptak, og en endring overskriver raden, så tidligere versjoner bevares ikke. Saksbehandleren
# kan sette «Ikke kvalifisert» med mangelkode, men ikke som første konklusjon, og kan ikke
# annullere en konklusjon i FS Admin. Bare organisasjonen som endret sist, lagres. Hver lagring
# har den samme bekreftelsen («Er du helt sikker?»), uten eget varsel når en eksisterende
# konklusjon eller en konklusjon satt av en annen organisasjon endres. Uten tilgang vises
# konklusjonen skrivebeskyttet.
@OPT-BEH-BEH-042 @must @draft @ref-OPT-BEH-BEH-015
Egenskap: Sette GSK-konklusjon manuelt
  Som saksbehandler
  ønsker jeg å vurdere, sette og rette GSK-konklusjonen når den ikke er satt automatisk, eller er feil
  slik at søknaden kan behandles videre på riktig grunnlag.

  GSK-konklusjonen er det første saksbehandleren tar stilling til i saken. Saksbehandleren
  vurderer om søkeren har generell studiekompetanse ut fra dokumentasjonen, og setter
  konklusjonen ved å velge grunnlaget søkeren har generell studiekompetanse på. Konklusjonen
  lagres på søkeren, og gjenbrukes. Den kan endres fritt så lenge saksbehandlingen pågår, også
  når den er satt automatisk. Grunnlagsdatoen settes automatisk til datoen den siste
  konklusjonen ble satt.

  Er søknaden fordelt på flere saksbehandlende organisasjoner, deler de den samme konklusjonen.
  Alle kan se og endre den, og ser hvilken organisasjon som satte den sist. Det er den siste
  konklusjonen som gjelder. Tidligere konklusjoner bevares og kan ses. En positiv konklusjon kan
  annulleres med en årsak, og det krever en aktiv bekreftelse.

  # ÅPNE SPØRSMÅL:
  # - Skissen sier at konklusjonen lagres på søkeren og gjenbrukes (som Confluence, krav 1).
  #   begreper.md (avklart 2026-11-03) sier at GSK-konklusjonen er for søknaden i ett opptak, og
  #   koden lagrer én per søker og opptak. Skal begreper.md og OPT-BEH-BEH-015 endres?
  # - Skissen har bare valg av grunnlag, ikke en negativ konklusjon. Settes det ikke lenger en
  #   negativ konklusjon med mangelkode? Hvordan registreres det da at søkeren ikke har GSK: med
  #   en mangel, eller ved å annullere? Confluence (krav 2) sier at konklusjonen kan endres fra
  #   godkjent til ikke godkjent.
  # - Når regnes saksbehandlingen som ferdig, så konklusjonen ikke lenger kan endres fritt
  #   («låses»)? HK-dir spør det samme.
  # - Skal saksbehandleren kunne velge studentgrunnlagene (REA, FOR, DSP) som grunnlag
  #   (sektor, PFS 4593713169)?

  Regel: Saksbehandleren setter GSK-konklusjonen når søkeren ikke har noen

    Scenario: Sette GSK-konklusjon
      Gitt at søkeren ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen med grunnlagskoden KLS
      Så har søkeren en positiv GSK-konklusjon med grunnlagskoden KLS

    Scenario: Grunnlagsdatoen er datoen konklusjonen ble satt
      # Krav 2a. Automatikken bruker utstedelsesdatoen på vitnemålet (OPT-BEH-BEH-015).
      Gitt at søkeren ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen 2027-05-03
      Så er grunnlagsdatoen 2027-05-03

    Scenario: Konklusjonen viser hvem som satte den
      Gitt at søkeren ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen
      Så viser GSK-konklusjonen den saksbehandlende organisasjonen og datoen den ble satt

  Regel: Saksbehandleren kan endre GSK-konklusjonen så lenge saksbehandlingen pågår

    Scenario: Endre grunnlagskoden
      # Sektor ber om dette for blant annet feilsatte IMM-vedtak (PFS 4593713169).
      Gitt at søkeren har en positiv GSK-konklusjon med grunnlagskoden RFA
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så har søkeren en positiv GSK-konklusjon med grunnlagskoden KLS

    Scenario: Endre en konklusjon som er satt automatisk
      # Skissen, «Automatisk behandlet». Automatikken overskriver aldri en konklusjon
      # saksbehandleren har satt (OPT-BEH-BEH-015).
      Gitt at søkeren har fått GSK-konklusjonen automatisk med grunnlagskoden KLY
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så har søkeren en positiv GSK-konklusjon med grunnlagskoden KLS
      Og GSK-konklusjonen viser den saksbehandlende organisasjonen og datoen den ble endret

    Scenario: Grunnlagsdatoen følger den siste endringen
      Gitt at søkeren har en GSK-konklusjon med grunnlagsdatoen 2027-04-20
      Når saksbehandleren endrer GSK-konklusjonen 2027-05-03
      Så er grunnlagsdatoen 2027-05-03

    Scenario: Den forrige konklusjonen bevares når konklusjonen endres
      # Krav 6 og 6a, og HK-dir, alternativ 2.
      Gitt at søkeren har en positiv GSK-konklusjon med grunnlagskoden RFA
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så er konklusjonen med grunnlagskoden RFA bevart som en tidligere konklusjon

    Scenario: Saksbehandleren angrer endringen
      Gitt at søkeren har en GSK-konklusjon
      Og at saksbehandleren endrer GSK-konklusjonen
      Når saksbehandleren avbryter endringen
      Så er GSK-konklusjonen uendret

    @openquestion
    Scenario: Saksbehandleren får varsel før en eksisterende konklusjon endres
      # Krav 4a.
      # ÅPNE SPØRSMÅL:
      # - Varselet er ikke i skissen. Skal det være med, og gjelder det alle endringer, eller bare
      #   en konklusjon fra et tidligere opptak? Krav 4a står under søkere med tidligere
      #   konklusjoner, og krav 2 sier at konklusjonen kan endres uten begrensninger.
      Gitt at søkeren har en GSK-konklusjon fra et tidligere opptak
      Når saksbehandleren endrer GSK-konklusjonen
      Så ser saksbehandleren et varsel om at en eksisterende GSK-konklusjon endres
      Og konklusjonen endres først når saksbehandleren bekrefter

  Regel: De saksbehandlende organisasjonene deler GSK-konklusjonen

    Scenario: Konklusjonen satt av én organisasjon vises for en annen
      # Krav 3 og 3a.
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at saksbehandleren ved den ene organisasjonen har satt GSK-konklusjonen
      Når saksbehandleren ved den andre organisasjonen åpner saken
      Så ser saksbehandleren ved den andre organisasjonen GSK-konklusjonen
      Og saksbehandleren ved den andre organisasjonen kan endre GSK-konklusjonen

    @openquestion
    Scenario: Varsel før en konklusjon satt av en annen organisasjon endres
      # Krav 3b.
      # ÅPNE SPØRSMÅL:
      # - Varselet er ikke i skissen. Skal det være med?
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
    Scenario: Organisasjonen som satte konklusjonen, ser at den er endret
      # Krav 3c og 3d.
      # ÅPNE SPØRSMÅL:
      # - Hvilken status ser organisasjonen i søknadslisten og på søknaden, og når forsvinner den?
      #   Statusen er ikke beskrevet i Confluence eller skissen.
      # - Skal organisasjonen som satte konklusjonen, også få et varsel (HK-dir mener ja, Sikt
      #   har ikke avklart det)? Hvor får den det (se 04 Meldinger og oppgaver)?
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at GSK-konklusjonen er satt av den ene organisasjonen
      Når saksbehandleren ved den andre organisasjonen endrer GSK-konklusjonen
      Så ser saksbehandleren ved organisasjonen som satte konklusjonen, at den er endret, i søknadslisten og på søknaden

    @openquestion
    Scenario: Saksbehandleren uten tilgang til saken ser ikke muligheten til å endre konklusjonen
      # Står ikke i kildene. Følger mønsteret om at manglende tilgang skjuler elementet.
      # ÅPNE SPØRSMÅL:
      # - Skal saksbehandleren uten tilgang se konklusjonen (som i dag, skrivebeskyttet), og bare
      #   ikke muligheten til å endre den?
      Gitt at saksbehandleren ikke har tilgang til å behandle saken
      Når saksbehandleren ser på GSK-konklusjonen
      Så ser ikke saksbehandleren muligheten til å endre GSK-konklusjonen

  Regel: Den siste GSK-konklusjonen gjelder

    Scenario: Den siste konklusjonen er den gjeldende
      # Krav 4.
      Gitt at søkeren har en positiv GSK-konklusjon med grunnlagskoden RFA fra 2024
      Og at søkeren har en positiv GSK-konklusjon med grunnlagskoden KLS fra 2025
      Når saksbehandleren ser på GSK-konklusjonen
      Så er konklusjonen med grunnlagskoden KLS den gjeldende

  Regel: Tidligere GSK-konklusjoner bevares og kan ses

    Scenario: Se tidligere konklusjoner
      # Krav 6a.
      Gitt at søkeren har tre GSK-konklusjoner
      Når saksbehandleren velger å se tidligere konklusjoner
      Så ser saksbehandleren de to tidligere konklusjonene
      Og hver tidligere konklusjon viser grunnlagskoden, hvem som satte den og datoen

    @openquestion
    Scenario: Negative konklusjoner fra tidligere opptak vises
      # ÅPNE SPØRSMÅL:
      # - Krav 8 («Negative konklusjoner bevares») er strøket i Confluence uten forklaring. HK-dir
      #   ønsker at de bevares, og OPT-BEH-BEH-015 lagrer dem (avklart 2026-10-13), fordi en
      #   negativ konklusjon stopper gjenbruken av eldre positive. Skal negative konklusjoner fra
      #   det gamle systemet vises som tidligere konklusjoner?
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
      # - Hvilke årsaker til annullering kan saksbehandleren velge?
      # - Er begrunnelsen påkrevd?
      Gitt at søkeren har en positiv GSK-konklusjon
      Når saksbehandleren annullerer konklusjonen med en årsak til annullering og en begrunnelse
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert
      Og den annullerte konklusjonen er bevart som en tidligere konklusjon

    Scenario: Annullere en konklusjon som er satt automatisk
      # Skissen, «Automatisk behandlet».
      Gitt at søkeren har fått GSK-konklusjonen automatisk
      Når saksbehandleren annullerer konklusjonen med en årsak til annullering
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert

    Scenario: Annulleringen krever bekreftelse
      Gitt at søkeren har en positiv GSK-konklusjon
      Når saksbehandleren velger å annullere konklusjonen
      Så ser saksbehandleren den nåværende konklusjonen og må bekrefte annulleringen
      Men konklusjonen er ikke annullert før saksbehandleren bekrefter

    Scenario: Annulleringen krever en årsak
      # Fra skissen og koden, ikke fra Confluence.
      Gitt at søkeren har en positiv GSK-konklusjon
      Når saksbehandleren vil annullere konklusjonen uten å velge en årsak til annullering
      Så kan saksbehandleren ikke bekrefte annulleringen

    @openquestion
    Scenario: Søknaden etter annulleringen
      # ÅPNE SPØRSMÅL:
      # - Hva gjelder for søknaden når konklusjonen er annullert: har søkeren da ingen
      #   konklusjon, så saksbehandleren kan sette en ny? Kan automatikken sette en ny?
      Gitt at søkerens GSK-konklusjon er annullert
      Når saksbehandleren ser på GSK-konklusjonen
      Så har søkeren ingen gjeldende GSK-konklusjon
