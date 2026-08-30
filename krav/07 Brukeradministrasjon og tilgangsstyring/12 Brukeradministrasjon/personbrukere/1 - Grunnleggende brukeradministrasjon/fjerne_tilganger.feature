# language: no
# GitHub: #481
@BRU-PER-GRU-011 @must @planned
Egenskap: Fjerne tilganger fra en personbruker
  Som brukeradministrator
  ønsker jeg å fjerne enkelttilganger fra en personbruker
  slik at personbrukeren har det riktige settet av tilganger til enhver tid.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker
    Og jeg ser tilgangslisten personbrukeren har

  Regel: En fjerning gjelder én tilgang for en organisasjon og et miljø

    Scenario: Fjerne en tilgang for valgt organisasjon og miljø
      Gitt personbrukeren har den samme tilgangen tildelt direkte for flere kombinasjoner av organisasjon og miljø
      Når jeg fjerner tilgangen for én av kombinasjonene
      Så har personbrukeren ikke lenger tilgangen for den kombinasjonen
      Og tilgangen består for de øvrige kombinasjonene

  Regel: En eller flere direkte tildelte tilganger kan fjernes i én operasjon

    Scenario: Fjerne en direkte tildelt tilgang fra en personbruker
      Gitt personbrukeren har en aktiv tilgang som er tildelt direkte
      Når jeg fjerner tilgangen fra personbrukeren
      Så fjernes tilgangen fra personbrukerens tilganger
      Og endringen er sporbar i historikk

    Scenario: Fjerne flere tilganger samtidig
      Gitt personbrukeren har flere aktive tilganger som er tildelt direkte
      Når jeg velger flere tilganger og fjerner dem i én operasjon
      Så fjernes alle de valgte tilgangene
      Og hver fjerning er sporbar individuelt i historikk

  Regel: Bruker kan kun fjerne tilganger de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for tilganger uten rettighet
      Gitt personbrukeren har en tilgang jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den tilgangen ikke tilgjengelig

    Scenario: Fjerning er begrenset til organisasjoner jeg administrerer
      Gitt personbrukeren har tilganger i flere organisasjoner
      Når jeg ser på personbrukerens tilganger
      Så er muligheten til å fjerne tilgjengelig kun for tilganger i organisasjoner jeg har brukeradministrator-rollen for

  Regel: Tilganger som følger av en rolle administreres gjennom rollen

    Scenario: Tilgang som følger av en rolle kan ikke fjernes enkeltvis
      Gitt personbrukeren har en tilgang som følger av en rolle
      Når jeg ser på personbrukerens tilganger
      Så ser jeg ingen mulighet til å fjerne tilgangen enkeltvis

    Scenario: Fjerne en tilgang som både er tildelt direkte og følger av en rolle
      Gitt personbrukeren har en tilgang som både er tildelt direkte og følger av en rolle
      Når jeg fjerner den direkte tildelingen
      Så beholder personbrukeren tilgangen gjennom rollen
      Og tilgangen vises ikke lenger med "Tildelt direkte" som rolle

# ÅPNE SPØRSMÅL:
# - Kan en brukeradministrator fjerne tilganger fra en deaktivert personbruker? BRU-APP-API-008 tillater det for deaktiverte applikasjoner, og BRU-PER-GRU-004 sier at deaktivering fryser tildelingene uten å fjerne dem — men det er ikke avklart om en tildeling kan fjernes permanent mens personbrukeren er deaktivert, eller hva som da skjer ved reaktivering.
# - Autorisasjon: regelen sier at brukeren kun kan fjerne tilganger de har rettighet til å fjerne, men ikke hva rettigheten består i. Forslag: bare tilganger som (a) gjelder ved en organisasjon administratoren administrerer, og (b) administratoren selv har eller kan administrere. Henger sammen med rolledefinisjons-arbeidet i "4 - Opprette og administrere roller".
# - UX ved fjerning: skal det være bekreftelsesdialog ved hver fjerning, eller en angre-mulighet etterpå? Avklares i designfasen. Merk at BRU-APP-API-008 allerede har besluttet bekreftelsesdialog for applikasjoner — de to bør samkjøres.
# - Hva skjer med data personbrukeren har opprettet, hvis tilgangen fjernes? (Eierskap, sletting, anonymisering — sannsynligvis utenfor scope for dette kravet og dekkes av separat krav om persondata.)
# - Skal varsel sendes til personbrukeren ved endringer i tilganger? Avklares sammen med BRU-PER-HIS-003.
