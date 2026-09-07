# language: no
# GitHub: #493
# Kilde: Brukerhistorie BH7 (temp/brukerhistorier.md)
@BRU-PER-OAR-001 @draft
Egenskap: Opprette lokal rolle
  Som rolleadministrator
  ønsker jeg å opprette nye lokale roller og populere dem med tilganger og andre roller
  slik at organisasjonen min har roller som matcher hvordan arbeid faktisk er organisert hos oss.

  Scenario: Opprette en lokal rolle med tilganger
    Gitt at rolleadministrator er på rolleoversikten for egen organisasjon
    Når rolleadministrator oppretter en ny rolle med navn og beskrivelse
    Og legger til ett eller flere tilganger på rollen
    Så skal rollen være tilgjengelig for tildeling i organisasjonen

  Scenario: Opprette en lokal rolle som arver andre roller
    Gitt at rolleadministrator skal opprette en ny rolle
    Når rolleadministrator legger en eksisterende rolle inn som komponent
    Så skal den nye rollen inkludere alle tilgangene fra den arvede rollen

# ÅPNE SPØRSMÅL:
# - Hvilke felt er obligatoriske ved opprettelse? (navn, beskrivelse, organisasjonseier, type?)
# - Skal det være validering mot navnekollisjon innen organisasjonen, eller globalt?
# - Hvilke tilganger og roller kan en rolleadministrator inkludere — kun fra egen organisasjon, eller også globale/delte roller?
# - Skal en rolle kunne markeres som "krever taushetserklæring" ved opprettelse?
# - Hvordan håndteres sirkulær arv (rolle A inkluderer B som inkluderer A) — avvist eller forhindret i UI?
# - Forholdet mellom begrepene "tilgang" (atom) og "rolle" (sammensetning) ved tilbygging — se begrepsbruk.md.
