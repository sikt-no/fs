# language: no
# GitHub: #481
@BRU-PER-GRU-012 @must @implemented
Egenskap: Fjerne roller fra en personbruker
  Som brukeradministrator
  ønsker jeg å fjerne roller fra en personbruker
  slik at personbrukeren har det riktige settet av tilganger til enhver tid.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker
    Og jeg ser rollelisten personbrukeren har

  Regel: En fjerning gjelder én rolle for en organisasjon og et miljø

    Scenario: Fjerne en rolle for valgt organisasjon og miljø
      Gitt personbrukeren har den samme rollen tildelt for flere kombinasjoner av organisasjon og miljø
      Når jeg fjerner rollen for én av kombinasjonene
      Så har personbrukeren ikke lenger rollen for den kombinasjonen
      Og rollen består for de øvrige kombinasjonene

  Regel: En eller flere roller kan fjernes i én operasjon

    Scenario: Fjerne en aktiv rolle fra en personbruker
      Gitt personbrukeren har en aktiv rolle
      Når jeg fjerner rollen fra personbrukeren
      Så fjernes rollen fra personbrukerens tildelinger

    Scenario: Fjerne flere roller samtidig
      Gitt personbrukeren har flere aktive roller
      Når jeg velger flere roller og fjerner dem i én operasjon
      Så fjernes alle de valgte rollene

  @draft @openquestion
  Regel: Fjerning av roller lagres i historikk
    # ÅPNE SPØRSMÅL:
    # - Hvem skal kunne se historikkdataene, og hvorfor? Visning av historikk løses i egne oppgaver senere.
    # - Hvor lenge skal historikkdataene lagres?
    # - Lagringen må antakelig sjekkes med juss.

    Scenario: Fjerning av en rolle lagres i historikk
      Gitt personbrukeren har en aktiv rolle
      Når jeg fjerner rollen fra personbrukeren
      Så er endringen sporbar i historikk

    Scenario: Hver fjerning lagres individuelt i historikk
      Gitt personbrukeren har flere aktive roller
      Når jeg velger flere roller og fjerner dem i én operasjon
      Så er hver fjerning sporbar individuelt i historikk

  Regel: Bruker kan kun fjerne roller de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for roller uten rettighet
      Gitt personbrukeren har en rolle jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den rollen ikke tilgjengelig

    Scenario: Fjerning er begrenset til organisasjoner jeg administrerer
      Gitt personbrukeren har roller i flere organisasjoner
      Når jeg ser på personbrukerens roller
      Så er muligheten til å fjerne tilgjengelig kun for roller i organisasjoner jeg har brukeradministrator-rollen for

  Regel: Fjerning av en rolle fjerner tilgangene rollen ga

    Scenario: Tilganger som kom fra rollen faller bort
      Gitt personbrukeren har en rolle som gir én eller flere tilganger
      Når jeg fjerner rollen fra personbrukeren
      Så har personbrukeren ikke lenger tilgangene som kom fra rollen

    Scenario: Tilgang som også er tildelt direkte består
      Gitt personbrukeren har en tilgang som både er tildelt direkte og følger av en rolle
      Når jeg fjerner rollen fra personbrukeren
      Så beholder personbrukeren tilgangen gjennom den direkte tildelingen
