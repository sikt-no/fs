# language: no
# GitHub: #486
@BRU-PER-GRU-008 @must @planned
Egenskap: Se egen brukerprofil og tilganger
  Som personbruker av FS Admin
  ønsker jeg å se min egen brukerprofil og hvilke tilganger og roller jeg har
  slik at jeg vet hva jeg har lov å gjøre i FS.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Visning av egen profil

    Scenario: Åpne egen profil
      Når jeg åpner min egen profil
      Så ser jeg personopplysninger som er registrert om meg
      Og jeg ser mine tildelte tilganger og roller

    Scenario: Se status på egne tildelinger
      Når jeg åpner min egen profil
      Så ser jeg tydelig hvilke tildelinger som er aktive og hvilke som er inaktive

    Scenario: Se tidsbegrensning på egne tildelinger
      Gitt jeg har en tildeling med start- eller sluttidspunkt
      Når jeg åpner min egen profil
      Så ser jeg gyldighetstidsrommet for tildelingen

    Scenario: Se stedkoder på egne tildelinger
      Gitt jeg har en tildeling som er begrenset til bestemte stedkoder
      Når jeg åpner min egen profil
      Så ser jeg hvilke stedkoder tildelingen gjelder for

    Scenario: Se tildelingsdato per tildeling
      Når jeg åpner min egen profil
      Så ser jeg datoen hver tildeling ble gitt
      Men jeg ser ikke hvem som tildelte den

# ÅPNE SPØRSMÅL:
# - Skal direkte tildelte tilganger skilles fra tilganger som kommer via en rolle, eller presenteres samlet? (Samme åpne spørsmål som i BRU-PER-GRU-002 — bør besvares likt for de to visningene.)
# - Hvordan skal "inaktiv på grunn av tidsbegrensning" vises vs. "deaktivert av administrator"? (Samme åpne spørsmål som i BRU-PER-GRU-002.)
# - Skal historikk på egne tildelinger være synlig for personbrukeren selv? (Henger sammen med "2 - Historikk".)
# - Skiller "egen profil" seg fra brukeradministrators visning (BRU-PER-GRU-002) i layout eller felt-utvalg utover skjuling av tildeler-identitet?
# - Senere iterasjon: ventende egne tilgangsforespørsler og "be om endring"-funksjon dekkes av BRU-PER-ETT-002 og er ikke en del av dette kravet.