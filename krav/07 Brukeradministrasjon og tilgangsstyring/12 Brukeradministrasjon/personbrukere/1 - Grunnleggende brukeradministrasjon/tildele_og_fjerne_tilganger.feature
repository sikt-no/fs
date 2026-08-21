# language: no
# GitHub: #481
@BRU-PER-GRU-009 @must @planned
Egenskap: Tildele og fjerne tilganger hos en personbruker
  Som brukeradministrator
  ønsker jeg å tildele og fjerne enkelttilganger hos en personbruker
  slik at personbrukeren har det riktige settet av tilganger til enhver tid.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Tildele tilganger

    Scenario: Tildele en tilgang til en personbruker
      Når jeg tildeler en tilgang til personbrukeren
      Så legges tilgangen til i personbrukerens tilganger
      Og tilgangen er aktiv fra tildelingstidspunktet
      Og tilgangen vises uten tilknyttet rolle
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

  Regel: Fjerne tilganger

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

  Regel: Tilganger som følger av en rolle administreres gjennom rollen

    Scenario: Tilgang som følger av en rolle kan ikke fjernes enkeltvis
      Gitt personbrukeren har en tilgang som følger av en rolle
      Når jeg ser på personbrukerens tilganger
      Så ser jeg ingen mulighet til å fjerne tilgangen enkeltvis

# ÅPNE SPØRSMÅL:
# - Autorisasjon: hvilken regel styrer hva en brukeradministrator kan tildele? Forslag: bare tilganger som (a) gjelder ved en organisasjon administratoren administrerer, og (b) administratoren selv har eller kan administrere. Henger sammen med rolledefinisjons-arbeidet i "4 - Opprette og administrere roller".
# - Når bør en tilgang tildeles direkte fremfor gjennom en rolle? Skal direkte tildeling være et unntak som krever begrunnelse, eller en likestilt måte å tildele på?
# - UX ved fjerning: skal det være bekreftelsesdialog ved hver fjerning, eller en angre-mulighet etterpå? Avklares i designfasen.
# - Hva skjer med data personbrukeren har opprettet, hvis tilgangen fjernes? (Eierskap, sletting, anonymisering — sannsynligvis utenfor scope for dette kravet og dekkes av separat krav om persondata.)
# - Skal varsel sendes til personbrukeren ved endringer i tilganger? Avklares sammen med BRU-PER-HIS-003.
# - Krever tildeling at brukeren har godkjent bruksvilkår / signert taushetserklæring først? Henger sammen med "1 - Bruksvilkår".
