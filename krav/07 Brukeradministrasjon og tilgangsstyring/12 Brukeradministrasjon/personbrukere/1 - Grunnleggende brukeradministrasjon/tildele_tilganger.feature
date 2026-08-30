# language: no
# GitHub: #481
@BRU-PER-GRU-009 @must @planned
Egenskap: Tildele tilganger til en personbruker
  Som brukeradministrator
  ønsker jeg å tildele enkelttilganger til en personbruker
  slik at personbrukeren har det riktige settet av tilganger til enhver tid.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: En tildeling gjelder én tilgang for en organisasjon og et miljø

    Scenario: Tildele en tilgang for valgt organisasjon og miljø
      Når jeg velger en organisasjon, et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt personbrukeren for den valgte kombinasjonen av organisasjon og miljø
      Og det fremgår hvilken organisasjon og hvilket miljø tildelingen gjelder

  Regel: Tildelingen gjelder en organisasjon administratoren har rettighet for

    Scenario: Organisasjon er implisitt når administrator administrerer kun én organisasjon
      Gitt jeg administrerer kun én organisasjon
      Når jeg velger et miljø og en tilgang jeg har rettighet til å tildele
      Så er tilgangen tildelt personbrukeren i det valgte miljøet for min organisasjon

    Scenario: Valglisten for organisasjon er begrenset til organisasjoner jeg administrerer
      Gitt jeg administrerer flere organisasjoner
      Når jeg åpner valglisten for organisasjon
      Så ser jeg kun organisasjoner jeg har brukeradministrator-rollen for

  Regel: En eller flere tilganger kan tildeles i én operasjon

    Scenario: Tildele en tilgang til en personbruker
      Når jeg tildeler en tilgang til personbrukeren
      Så legges tilgangen til i personbrukerens tilganger
      Og tilgangen er aktiv fra tildelingstidspunktet
      Og tilgangen vises med "Tildelt direkte" som rolle
      Og endringen er sporbar i historikk

    Scenario: Tildele flere tilganger samtidig
      Når jeg velger flere tilganger og tildeler dem i én operasjon
      Så legges alle de valgte tilgangene til hos personbrukeren
      Og hver tildeling er sporbar individuelt i historikk

    Scenario: Delvis suksess ved samtidig tildeling av tilganger
      Gitt jeg har valgt flere tilganger å tildele
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: Bruker kan kun tildele tilganger de selv har rettighet til å tildele

    Scenario: Valglisten for tilgang avhenger av valgt organisasjon og miljø
      Gitt jeg har valgt organisasjon og miljø
      Når jeg åpner valglisten for tilganger
      Så vises kun tilganger jeg har rettighet til å tildele for den valgte kombinasjonen av organisasjon og miljø

  Regel: En tilgang som allerede er tildelt direkte for samme organisasjon og miljø kan ikke tildeles på nytt

    Scenario: Allerede direkte tildelt tilgang vises som ikke-valgbar
      Gitt personbrukeren har en tilgang tildelt direkte for en kombinasjon av organisasjon og miljø
      Når jeg velger tilganger å tildele for samme kombinasjon av organisasjon og miljø
      Så vises den allerede tildelte tilgangen som ikke valgbar
      Og det fremgår at tilgangen allerede er tildelt

    Scenario: Tilgang som følger av en rolle kan likevel tildeles direkte
      Gitt personbrukeren har en tilgang som følger av en rolle
      Når jeg velger tilganger å tildele
      Så er tilgangen valgbar for direkte tildeling
      Og tilgangen vises deretter med rollene den kommer fra, etterfulgt av "Tildelt direkte"

# ÅPNE SPØRSMÅL:
# - Kan en brukeradministrator tildele tilganger til en deaktivert personbruker, og er tilgangen i så fall inaktiv inntil reaktivering? BRU-APP-API-007 tillater tildeling til deaktiverte applikasjoner, og BRU-PER-GRU-004 sier at deaktivering fryser tildelingene uten å fjerne dem — men det er ikke avklart om nye tildelinger kan legges til mens personbrukeren er deaktivert.
# - Autorisasjon: regelen sier at brukeren kun kan tildele tilganger de har rettighet til å tildele, men ikke hva rettigheten består i. Forslag: bare tilganger som (a) gjelder ved en organisasjon administratoren administrerer, og (b) administratoren selv har eller kan administrere. Henger sammen med rolledefinisjons-arbeidet i "4 - Opprette og administrere roller".
# - Når bør en tilgang tildeles direkte fremfor gjennom en rolle? Skal direkte tildeling være et unntak som krever begrunnelse, eller en likestilt måte å tildele på?
# - Skal varsel sendes til personbrukeren ved endringer i tilganger? Avklares sammen med BRU-PER-HIS-003.
# - Krever tildeling at brukeren har godkjent bruksvilkår / signert taushetserklæring først? Henger sammen med "1 - Bruksvilkår".
# - Har en personbruker også arvede tilganger via implikasjon i tilgangskatalogen, slik en applikasjon har (BRU-APP-API-008)? Kravene her kjenner bare opphavet "følger av en rolle". BRU-TIL-KAT-001 beskriver implikasjon som en egenskap ved katalogen, altså uavhengig av om subjektet er en applikasjon eller en person.
