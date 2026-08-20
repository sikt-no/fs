# language: no
# GitHub: #481
@BRU-PER-GRU-003 @must @planned
Egenskap: Tildele og fjerne roller hos en personbruker
  Som brukeradministrator
  ønsker jeg å tildele og fjerne roller hos en personbruker
  slik at personbrukeren har det riktige settet av tilganger til enhver tid.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Tildele roller

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

  Regel: Fjerne roller

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

  Regel: Tilganger følger av roller og administreres ikke direkte

    Scenario: Tilganger kan verken tildeles eller fjernes
      Når jeg ser på personbrukerens tildelinger
      Så ser jeg ingen mulighet til å tildele en tilgang direkte
      Og jeg ser ingen mulighet til å fjerne en enkelt tilgang

# ÅPNE SPØRSMÅL:
# - Autorisasjon: hvilken regel styrer hva en brukeradministrator kan tildele? Forslag: bare roller som (a) gjelder ved en organisasjon administratoren administrerer, og (b) administratoren selv har eller kan administrere. Henger sammen med rolledefinisjons-arbeidet i "4 - Opprette og administrere roller".
# - UX ved fjerning: skal det være bekreftelsesdialog ved hver fjerning, eller en angre-mulighet etterpå? Avklares i designfasen.
# - Hva skjer med data personbrukeren har opprettet, hvis rollen fjernes? (Eierskap, sletting, anonymisering — sannsynligvis utenfor scope for dette kravet og dekkes av separat krav om persondata.)
# - Skal varsel sendes til personbrukeren ved endringer i roller? Avklares sammen med BRU-PER-HIS-003.
# - Krever tildeling at brukeren har godkjent bruksvilkår / signert taushetserklæring først? Henger sammen med "1 - Bruksvilkår".
