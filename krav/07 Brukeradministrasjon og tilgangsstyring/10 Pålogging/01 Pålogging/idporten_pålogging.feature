# language: no
@TIL-PÅL-PÅL-002 @opptakspilot
Egenskap: ID-porten
Brukere skal kunne logge på med ID-porten i alle nye brukerflater

@opptakspilotkritisk
Scenario: Administrator logger på med ID-porten
Gitt administratoren er på hovedsiden til adminflaten
Når administratoren velger å logge inn
Og administratoren velger å logge inn med ID-porten
Så skal administratoren være innlogget med ID-porten

@opptakspilotkritisk
Scenario: Person logger på med ID-porten
Gitt personen er på hovedsiden til personflaten
Når personen velger å logge inn
Og personen velger å logge inn med ID-porten
Så skal personen være innlogget med ID-porten

# Min kompetanse (personflaten): beslutninger 22.09.2026 og 1.11.2026 (BAT-404, #262).

@draft
Regel: Personen logger inn i Min kompetanse direkte med ID-porten
  # Min kompetanse har sin egen klient hos Digdir. Innloggingen går ikke via Feide (beslutning 22.09.2026).

  Scenario: Personen logger inn i Min kompetanse med ID-porten uten Feide
    Gitt at personen er på innloggingssiden til Min kompetanse
    Når personen logger inn med ID-porten
    Så er personen innlogget i Min kompetanse med ID-porten
    Og personen har ikke logget inn med Feide

@draft
Regel: Søkeren innlogget med ID-porten får tilgangene til Min kompetanse
  # Tilgangene er gulvet snittet med taket til Min kompetanse, de samme som ved Feide-innlogging gjennom
  # Min kompetanse. Søkeren får ikke bare de åpne rollene.

  Scenario: Søkeren innlogget med ID-porten får de samme tilgangene som med Feide
    Gitt at søkeren er innlogget i Min kompetanse med ID-porten
    Når søkeren bruker Min kompetanse
    Så har søkeren de samme tilgangene som ved Feide-innlogging gjennom Min kompetanse

  Scenario: Tilgangsstyringen lagrer ikke fødselsnummeret til søkeren
    Gitt at søkeren har logget inn i Min kompetanse med ID-porten
    Når søkeren bruker Min kompetanse
    Så er fødselsnummeret til søkeren ikke lagret i tilgangsstyringen

@draft @ref-TIL-PÅL-PÅL-006
Regel: Søkere uten norsk eID logger inn gjennom den samme klienten
  # Innlogging med e-post som selvregistrert bruker og med eIDAS går gjennom Min kompetanses klient hos Digdir.
  # Sikt har ingen egen identitetsleverandør for dette. Kravet står i TIL-PÅL-PÅL-006.
