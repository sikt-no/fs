# language: no
# GitHub: #481
@BRU-PER-GRU-003 @must @planned
Egenskap: Tildele og fjerne tilganger og roller hos en personbruker
  Som brukeradministrator
  ønsker jeg å tildele og fjerne tilganger og roller hos en personbruker
  slik at personbrukeren har det riktige settet av tilganger til enhver tid.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Tildele tilganger og roller

    Scenario: Tildele en rolle til en personbruker
      Når jeg tildeler en rolle til personbrukeren
      Så legges rollen til i personbrukerens tildelinger
      Og rollen er aktiv fra tildelingstidspunktet
      Og endringen er sporbar i historikk

    Scenario: Tildele en enkelt tilgang til en personbruker
      Når jeg tildeler en tilgang til personbrukeren
      Så legges tilgangen til i personbrukerens tildelinger
      Og tilgangen er aktiv fra tildelingstidspunktet
      Og endringen er sporbar i historikk

    Scenario: Tildele flere roller og tilganger samtidig
      Når jeg velger flere roller og tilganger og tildeler dem i én operasjon
      Så legges alle de valgte tildelingene til hos personbrukeren
      Og hver tildeling er sporbar individuelt i historikk

    Scenario: Delvis suksess ved samtidig tildeling
      Gitt jeg har valgt flere roller og tilganger å tildele
      Når noen av tildelingene ikke kan gjennomføres
      Så gjennomføres de tildelingene som er gyldige
      Og jeg ser tydelig hvilke tildelinger som ikke ble gjennomført, og hvorfor

  Regel: Fjerne tilganger og roller

    Scenario: Fjerne en aktiv rolle fra en personbruker
      Gitt personbrukeren har en aktiv rolle
      Når jeg fjerner rollen fra personbrukeren
      Så fjernes rollen fra personbrukerens tildelinger
      Og endringen er sporbar i historikk

    Scenario: Fjerne en aktiv tilgang fra en personbruker
      Gitt personbrukeren har en aktiv tilgang som ikke kommer via en rolle
      Når jeg fjerner tilgangen fra personbrukeren
      Så fjernes tilgangen fra personbrukerens tildelinger
      Og endringen er sporbar i historikk

    Scenario: Fjerne flere tildelinger samtidig
      Gitt personbrukeren har flere aktive tildelinger
      Når jeg velger flere tildelinger og fjerner dem i én operasjon
      Så fjernes alle de valgte tildelingene
      Og hver fjerning er sporbar individuelt i historikk

# ÅPNE SPØRSMÅL:
# - Autorisasjon: hvilken regel styrer hva en brukeradministrator kan tildele? Forslag: bare tilganger som (a) gjelder ved en organisasjon administratoren administrerer, og (b) administratoren selv har eller kan administrere. Henger sammen med rolledefinisjons-arbeidet i "4 - Opprette og administrere roller".
# - UX ved fjerning: skal det være bekreftelsesdialog ved hver fjerning, eller en angre-mulighet etterpå? Avklares i designfasen.
# - Hva skjer med data personbrukeren har opprettet, hvis tilgangen fjernes? (Eierskap, sletting, anonymisering — sannsynligvis utenfor scope for dette kravet og dekkes av separat krav om persondata.)
# - Skal varsel sendes til personbrukeren ved endringer i tilganger? Avklares sammen med BRU-PER-HIS-003.
# - Krever tildeling at brukeren har godkjent bruksvilkår / signert taushetserklæring først? Henger sammen med "1 - Bruksvilkår".