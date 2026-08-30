# language: no
# GitHub: #481
@BRU-PER-GRU-003 @must @planned
Egenskap: Tildele roller til en personbruker
  Som brukeradministrator
  ønsker jeg å tildele roller til en personbruker
  slik at personbrukeren har det riktige settet av tilganger til enhver tid.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: En tildeling gjelder én rolle for en organisasjon og et miljø

    Scenario: Tildele en rolle for valgt organisasjon og miljø
      Når jeg velger en organisasjon, et miljø og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt personbrukeren for den valgte kombinasjonen av organisasjon og miljø
      Og det fremgår hvilken organisasjon og hvilket miljø tildelingen gjelder

  Regel: Tildelingen gjelder en organisasjon administratoren har rettighet for

    Scenario: Organisasjon er implisitt når administrator administrerer kun én organisasjon
      Gitt jeg administrerer kun én organisasjon
      Når jeg velger et miljø og en rolle jeg har rettighet til å tildele
      Så er rollen tildelt personbrukeren i det valgte miljøet for min organisasjon

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg administrerer flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har brukeradministrator-rollen for

  Regel: En eller flere roller kan tildeles i én operasjon

    Scenario: Tildele en rolle til en personbruker
      Når jeg tildeler en rolle til personbrukeren
      Så legges rollen til i personbrukerens tildelinger
      Og rollen er aktiv fra tildelingstidspunktet
      Og endringen er sporbar i historikk

    Scenario: Tildele flere roller samtidig
      Når jeg velger flere roller og tildeler dem i én operasjon
      Så legges alle de valgte rollene til hos personbrukeren
      Og hver tildeling er sporbar individuelt i historikk

    Scenario: Delvis suksess ved samtidig tildeling av roller
      Gitt jeg har valgt flere roller å tildele
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: Bruker kan kun tildele roller de selv har rettighet til å tildele

    Scenario: Valglisten for rolle avhenger av valgt organisasjon og miljø
      Gitt jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for roller
      Så vises kun roller jeg har rettighet til å tildele for den valgte kombinasjonen av organisasjon og miljø

  Regel: En rolle som allerede er tildelt for samme organisasjon og miljø kan ikke tildeles på nytt

    Scenario: Allerede tildelt rolle vises som ikke-valgbar
      Gitt personbrukeren har en rolle tildelt for en kombinasjon av organisasjon og miljø
      Når jeg velger roller å tildele for samme kombinasjon av organisasjon og miljø
      Så vises den allerede tildelte rollen som ikke valgbar
      Og det fremgår at rollen allerede er tildelt

# ÅPNE SPØRSMÅL:
# - Kan en brukeradministrator tildele roller til en deaktivert personbruker, og er rollen i så fall inaktiv inntil reaktivering? BRU-PER-GRU-004 sier at deaktivering fryser tildelingene uten å fjerne dem, men det er ikke avklart om nye tildelinger kan legges til mens personbrukeren er deaktivert.
# - Autorisasjon: regelen sier at brukeren kun kan tildele roller de har rettighet til å tildele, men ikke hva rettigheten består i. Forslag: bare roller som (a) gjelder ved en organisasjon administratoren administrerer, og (b) administratoren selv har eller kan administrere. Henger sammen med rolledefinisjons-arbeidet i "4 - Opprette og administrere roller".
# - Skal varsel sendes til personbrukeren ved endringer i roller? Avklares sammen med BRU-PER-HIS-003.
# - Krever tildeling at brukeren har godkjent bruksvilkår / signert taushetserklæring først? Henger sammen med "1 - Bruksvilkår".
# - Kan en sammensatt rolle gi personbrukeren en rolle hen ikke er tildelt direkte? BRU-PER-GRU-008 har et åpent spørsmål om utfolding av sammensatte roller; hvis roller kan arves, trenger dette kravet et opphavs-begrep slik tilgangssiden har.
