# language: no
# GitHub: #481
@BRU-PER-GRU-012 @must @planned
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
      Og endringen er sporbar i historikk

    Scenario: Fjerne flere roller samtidig
      Gitt personbrukeren har flere aktive roller
      Når jeg velger flere roller og fjerner dem i én operasjon
      Så fjernes alle de valgte rollene
      Og hver fjerning er sporbar individuelt i historikk

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

# ÅPNE SPØRSMÅL:
# - Kan en brukeradministrator fjerne roller fra en deaktivert personbruker? BRU-PER-GRU-004 sier at deaktivering fryser tildelingene uten å fjerne dem, men det er ikke avklart om en tildeling kan fjernes permanent mens personbrukeren er deaktivert, eller hva som da skjer ved reaktivering.
# - Autorisasjon: regelen sier at brukeren kun kan fjerne roller de har rettighet til å fjerne, men ikke hva rettigheten består i. Forslag: bare roller som (a) gjelder ved en organisasjon administratoren administrerer, og (b) administratoren selv har eller kan administrere. Henger sammen med rolledefinisjons-arbeidet i "4 - Opprette og administrere roller".
# - UX ved fjerning: skal det være bekreftelsesdialog ved hver fjerning, eller en angre-mulighet etterpå? Avklares i designfasen. Merk at BRU-APP-API-008 allerede har besluttet bekreftelsesdialog for applikasjoner — de to bør samkjøres.
# - Hva skjer med data personbrukeren har opprettet, hvis rollen fjernes? (Eierskap, sletting, anonymisering — sannsynligvis utenfor scope for dette kravet og dekkes av separat krav om persondata.)
# - Skal varsel sendes til personbrukeren ved endringer i roller? Avklares sammen med BRU-PER-HIS-003.
# - Skal administrator få se konsekvensen før fjerning — hvilke tilganger personbrukeren mister? BRU-PER-OAR-003 (se_konsekvens_av_å_fjerne_rolle) dekker konsekvensen av å fjerne en rolledefinisjon; dette kravet gjelder å fjerne en rolle fra én personbruker.
