# language: no
#
# Kilder: Confluence PFS 4608491542 «Manuell behandling – GSK» (akseptansekravene 1–8),
# PFS 4456513553 «GSK avklaringer med HK-Dir 23. mars 2026» og PFS 4593713169
# «GSK-funksjonalitet – tilbakemeldinger fra sektor». Jira: SOPP-180, epic STEK-702.
# Skisse: Figma «FS-Admin – Seksjon Opptak», seksjonen «GSK» (node 18259:99465). Den er justert
# etter tilbakemeldingene om flyten. De eldre skissene gjelder ikke.
# Avklart i møte 10.11.2026 (Marit, Sofie, Erik), svar i PR #1003.
# Avklart 13.11.2026, svar fra fagperson etter verifiseringen: saksbehandleren setter ikke en
# negativ konklusjon, men annullerer, alle grunnlagskodene kan velges, og tidligere konklusjoner
# er konklusjonene fra tidligere opptak, ikke versjoner i samme opptak.
#
# Den automatiske GSK-konklusjonen står i OPT-BEH-BEH-015, som en del av den automatiske
# saksbehandlingen. Der står også at automatikken aldri overskriver en konklusjon som finnes
# (akseptansekrav 7). Avklart 11.11.2026 etter review av PR #1003: det manuelle står i dette
# kravet, og det automatiske i OPT-BEH-BEH-015. Konklusjonen gjelder søknaden i opptaket, som i
# OPT-BEH-BEH-015 og begreper.md, og ikke personen, som det ble sagt i møtet 10.11.2026.
#
# Kode i dag (fs-admin GSKCard, fs-plattform GskVedtakService): konklusjonen er én rad per søker
# og opptak, og en endring overskriver raden, så tidligere versjoner bevares ikke. Saksbehandleren
# kan sette «Ikke kvalifisert» med mangelkode over enhver positiv konklusjon. API-et kan annullere
# en konklusjon, med årsak fra kodeverket for annulleringsårsaker i opptak, men bare når vitnemålet
# konklusjonen bygger på, er annullert. Det finnes ikke i FS Admin, og annulleringen endrer raden,
# så det finnes ingen historikk. Grunnlagskodene er en fast liste i opptaksbasen
# (generell_studiekompetanse.grunnlagstype), lik for alle opptak, og ikke grunnlagene i
# regelverkssamlingen. Bare organisasjonen som endret sist, lagres. Tilgangen følger saken, ikke
# personen. Flagget som låser en konklusjon (laasGskVedtak), er ikke i bruk og skal fjernes. Låsen
# i dette kravet kommer fra statusen på opptaket.
@OPT-BEH-BEH-042 @must @planned @ref-OPT-BEH-BEH-015
Egenskap: Sette GSK-konklusjon manuelt
  Som saksbehandler
  ønsker jeg å vurdere, sette og rette GSK-konklusjonen når den ikke er satt automatisk, eller er feil
  slik at søknaden kan behandles videre på riktig grunnlag.

  GSK-konklusjonen er det første saksbehandleren tar stilling til i saken. Saksbehandleren
  vurderer om søkeren har generell studiekompetanse ut fra dokumentasjonen, og setter
  konklusjonen ved å velge grunnlagskoden søkeren har generell studiekompetanse på.

  Konklusjonen gjelder søknaden i opptaket, og er den samme for alle saksbehandlende
  organisasjoner i opptaket. En konklusjon fra et tidligere opptak gjenbrukes som en kopi
  (OPT-BEH-BEH-015). Konklusjonen kan endres fritt til opptaket er historisk, også når den er
  satt automatisk. Automatikken overskriver aldri en konklusjon saksbehandleren har satt. En
  positiv konklusjon kan annulleres av organisasjonen som satte eller sist endret den, og av
  HK-dir. En konklusjon som er satt automatisk, kan alle saksbehandlende organisasjoner annullere.
  Saksbehandleren ser søkerens konklusjoner fra tidligere opptak, også fra det gamle
  opptakssystemet.

  Saksbehandleren setter aldri en negativ GSK-konklusjon. Er en positiv konklusjon feil,
  annullerer saksbehandleren den. Manglende generell studiekompetanse registreres som en mangel,
  som andre mangler (OPT-BEH-BEH-008).

  Regel: Saksbehandleren setter GSK-konklusjonen med en grunnlagskode
    # Grunnlagskodene for GSK er en fast liste, lik for alle opptak og år, og ikke grunnlagene i
    # regelverkssamlingen (OPT-REG-GRU-001). Avklart 13.11.2026: saksbehandleren kan velge alle
    # kodene i lista, og utviklerne endrer lista ved behov.

    Scenario: Sette GSK-konklusjon
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen med grunnlagskoden KLS
      Så har søknaden en GSK-konklusjon med grunnlagskoden KLS

    Scenario: Grunnlagsdatoen er datoen konklusjonen ble satt
      # Akseptansekrav 2a. Automatikken bruker utstedelsesdatoen på vitnemålet (OPT-BEH-BEH-015).
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen 2027-05-03
      Så er grunnlagsdatoen 2027-05-03

    Scenario: Konklusjonen viser hvem som satte den
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen
      Så viser GSK-konklusjonen organisasjonen saksbehandleren er ved, og datoen den ble satt

  @ref-OPT-BEH-BEH-008
  Regel: Saksbehandleren setter ikke en negativ GSK-konklusjon
    # Avklart 13.11.2026: sier automatikken at søkeren har generell studiekompetanse, og det ikke
    # stemmer, annullerer saksbehandleren konklusjonen med en årsak. Manglende generell
    # studiekompetanse registreres som en mangel (OPT-BEH-BEH-008). Erstatter regelen fra
    # 11.11.2026 om at saksbehandleren kunne overstyre en automatisk konklusjon med en negativ
    # konklusjon.

    Scenario: Annullere en automatisk konklusjon når søkeren ikke har generell studiekompetanse
      Gitt at søknaden har fått en positiv GSK-konklusjon automatisk
      Og at søkeren ikke har generell studiekompetanse
      Når saksbehandleren annullerer konklusjonen med en årsak til annullering
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert

    Scenario: Ingen negativ konklusjon når søknaden ikke har noen konklusjon
      Gitt at søknaden ikke har noen GSK-konklusjon
      Når saksbehandleren setter GSK-konklusjonen
      Så kan saksbehandleren bare velge en grunnlagskode for generell studiekompetanse

    Scenario: Ingen negativ konklusjon når konklusjonen endres
      Gitt at søknaden har en positiv GSK-konklusjon
      Når saksbehandleren endrer GSK-konklusjonen
      Så kan saksbehandleren bare velge en grunnlagskode for generell studiekompetanse

  @ref-OPT-OVO-GRU-004
  Regel: Saksbehandleren kan endre GSK-konklusjonen til opptaket er historisk
    # Avklart 10.11.2026: konklusjonen låses omtrent når opptaket arkiveres. I kravene om status
    # på opptaket (OPT-OVO-GRU-004) er det når opptaket gjøres historisk. OPT-BEH-BEH-015 og
    # OPT-BEH-BEH-034 kaller det samme et avsluttet opptak.

    Scenario: Endre grunnlagskoden
      # Sektor ber om dette for blant annet feilsatte IMM-vedtak (PFS 4593713169).
      Gitt at søknaden har en GSK-konklusjon med grunnlagskoden RFA
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så har søknaden en GSK-konklusjon med grunnlagskoden KLS

    Scenario: Endre en konklusjon som er satt automatisk
      # Skissen, «Automatisk behandlet». Automatikken overskriver aldri en konklusjon
      # saksbehandleren har satt (OPT-BEH-BEH-015).
      Gitt at søknaden har fått GSK-konklusjonen automatisk med grunnlagskoden KLY
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så har søknaden en GSK-konklusjon med grunnlagskoden KLS
      Og GSK-konklusjonen viser organisasjonen saksbehandleren er ved, og datoen den ble endret

    Scenario: Grunnlagsdatoen følger den siste endringen
      Gitt at søknaden har en GSK-konklusjon med grunnlagsdatoen 2027-04-20
      Når saksbehandleren endrer GSK-konklusjonen 2027-05-03
      Så er grunnlagsdatoen 2027-05-03

    Scenario: Saksbehandleren angrer endringen
      Gitt at søknaden har en GSK-konklusjon
      Og at saksbehandleren endrer GSK-konklusjonen
      Når saksbehandleren avbryter endringen
      Så er GSK-konklusjonen uendret

    Scenario: Konklusjonen kan ikke endres i et historisk opptak
      Gitt at søknaden i opptaket "Samordna opptak 2027" har en GSK-konklusjon
      Og at opptaket "Samordna opptak 2027" er historisk
      Når saksbehandleren ser på GSK-konklusjonen i saken i "Samordna opptak 2027"
      Så ser ikke saksbehandleren muligheten til å endre GSK-konklusjonen

    Scenario: En konklusjon som er gjenbrukt fra et historisk opptak, endres bare i det nye opptaket
      # Akseptansekrav 6. Gjenbruken er en kopi (OPT-BEH-BEH-015).
      Gitt at søknaden har en GSK-konklusjon med grunnlagskoden RFA, gjenbrukt fra et historisk opptak
      Når saksbehandleren endrer grunnlagskoden til KLS
      Så har søknaden en GSK-konklusjon med grunnlagskoden KLS
      Og GSK-konklusjonen i det historiske opptaket har fortsatt grunnlagskoden RFA

  Regel: Saksbehandleren ser søkerens GSK-konklusjoner fra tidligere opptak
    # Avklart 13.11.2026: tidligere konklusjoner er konklusjonene fra historiske opptak og fra det
    # gamle opptakssystemet, også de annullerte. Konklusjoner i opptak som ikke er historiske, er
    # under arbeid og vises ikke. Endringer i samme opptak overskriver konklusjonen, og tidligere
    # versjoner vises ikke. Å hente inn en tidligere konklusjon når automatikken ikke har satt noen
    # (STEK-443), er et eget krav.

    Scenario: Se konklusjonene fra tidligere opptak
      # Akseptansekrav 6a.
      Gitt at søkeren har GSK-konklusjoner fra to historiske opptak
      Når saksbehandleren velger å se tidligere konklusjoner
      Så ser saksbehandleren konklusjonene fra de to historiske opptakene
      Og hver tidligere konklusjon viser grunnlagskoden, opptaket, organisasjonen som satte den og datoen

    Scenario: Se konklusjonene fra det gamle opptakssystemet
      Gitt at søkeren har en GSK-konklusjon fra det gamle opptakssystemet
      Når saksbehandleren velger å se tidligere konklusjoner
      Så ser saksbehandleren konklusjonen fra det gamle opptakssystemet

    Scenario: Annullerte konklusjoner fra tidligere opptak vises
      Gitt at søkeren har en annullert GSK-konklusjon fra et tidligere opptak
      Når saksbehandleren velger å se tidligere konklusjoner
      Så ser saksbehandleren den annullerte konklusjonen med årsaken til annulleringen

    Scenario: Konklusjoner i opptak som ikke er historiske, vises ikke
      Gitt at søkeren har en GSK-konklusjon i et annet opptak som ikke er historisk
      Når saksbehandleren velger å se tidligere konklusjoner
      Så ser ikke saksbehandleren konklusjonen fra det andre opptaket

  Regel: Alle saksbehandlende organisasjoner i opptaket ser den samme GSK-konklusjonen

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

    Scenario: Saksbehandleren som kan se saken, ser konklusjonen
      # Avklart 13.11.2026: tilgangen følger saken, ikke personen.
      Gitt at saksbehandleren har tilgang til å se saken, men ikke til å endre saken
      Når saksbehandleren ser på GSK-konklusjonen
      Så ser saksbehandleren GSK-konklusjonen og de tidligere konklusjonene
      Men saksbehandleren ser ikke muligheten til å endre GSK-konklusjonen

  Regel: Organisasjonen som satte eller sist endret konklusjonen, og HK-dir kan annullere den
    # Akseptansekrav 5: annulleringen skal kreve aktiv bekreftelse, men være enklere enn i dagens
    # løsning. Avklart 10.11.2026: årsaken velges fra en liste (kodeverket for annulleringsårsaker,
    # som finnes i opptak fra før), og er påkrevd. Begrunnelsen skrives i fritekst, som i
    # skissen, og er valgfri (bekreftet av Sofie 10.11.2026).
    # Avklart 11.11.2026: har en annen organisasjon endret konklusjonen, er det organisasjonen som
    # endret den sist, som kan annullere den.

    Scenario: Annullere konklusjonen
      Gitt at saksbehandleren ved organisasjonen som satte GSK-konklusjonen, ser på konklusjonen
      Når saksbehandleren annullerer konklusjonen med en årsak til annullering
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert

    Scenario: Organisasjonen som endret konklusjonen sist, kan annullere den
      Gitt at søknaden har saker ved to saksbehandlende organisasjoner
      Og at GSK-konklusjonen er satt av den ene organisasjonen og endret av den andre
      Når saksbehandleren ved organisasjonen som endret konklusjonen, annullerer konklusjonen med en årsak til annullering
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert

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

    Scenario: Alle saksbehandlende organisasjoner kan annullere en konklusjon som er satt automatisk
      # Skissen, «Automatisk behandlet». Avklart 10.11.2026 (Sofie): en automatisk konklusjon er
      # ikke satt av noen organisasjon, så alle kan annullere den.
      Gitt at søknaden har fått GSK-konklusjonen automatisk
      Når saksbehandleren ved en saksbehandlende organisasjon annullerer konklusjonen med en årsak til annullering
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

    Scenario: Annullere uten begrunnelse
      Gitt at saksbehandleren ved organisasjonen som satte GSK-konklusjonen, ser på konklusjonen
      Når saksbehandleren annullerer konklusjonen med en årsak til annullering, uten begrunnelse
      Og saksbehandleren bekrefter annulleringen
      Så er GSK-konklusjonen annullert

    Scenario: Begrunnelsen bevares med den annullerte konklusjonen
      Gitt at saksbehandleren ved organisasjonen som satte GSK-konklusjonen, ser på konklusjonen
      Når saksbehandleren annullerer konklusjonen med en årsak til annullering og en begrunnelse
      Og saksbehandleren bekrefter annulleringen
      Så er årsaken og begrunnelsen bevart med den annullerte konklusjonen

    Scenario: Ny konklusjon etter annulleringen
      # Avklart 10.11.2026: både saksbehandleren og automatikken kan sette en ny konklusjon. At
      # automatikken kan det, står i OPT-BEH-BEH-015.
      Gitt at GSK-konklusjonen på søknaden er annullert
      Når saksbehandleren setter GSK-konklusjonen med grunnlagskoden KLS
      Så har søknaden en GSK-konklusjon med grunnlagskoden KLS
