# language: no
# GitHub: #514
@BRU-PER-GRU-013 @must @planned
Egenskap: Registrere en personbruker uten Feide-konto
  Som brukeradministrator
  ønsker jeg å registrere en ansatt som ikke har Feide-konto, før hen har logget inn første gang,
  slik at ansatte ved læresteder uten Feide — blant annet fagskolene — kan få tilganger i FS.

  En personbruker uten Feide-konto logger inn med ID-porten i stedet for Feide. Hen har
  ingen Feide-ID, og dermed heller ingen Feide-tilhørighet som identifiserer hen eller
  knytter hen til en organisasjon. Administratoren identifiserer derfor personen med
  fødselsnummer ved registrering, og gir hen minst én tildeling i den samme operasjonen.
  Personbrukeren har ingen hjemorganisasjon; det er tildelingene som knytter hen til
  organisasjoner, og hver tildeling gjelder for en organisasjon og et miljø på samme måte
  som for øvrige personbrukere (BRU-PER-GRU-003).

  Registrering er nødvendig fordi personbrukeren må kunne få roller før hen logger inn
  første gang. Selve påloggingen med ID-porten er dekket av TIL-PÅL-PÅL-002.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har brukeradministrator-rollen for minst én organisasjon

  Regel: En personbruker kan registreres før hen har logget inn første gang

    Scenario: Registrere en ansatt som ikke har Feide-konto
      Gitt personen ikke har en Feide-konto
      Og personen har aldri logget inn i løsningen
      Når jeg registrerer personen som personbruker med fødselsnummeret hens og minst én tildeling
      Så finnes personbrukeren i løsningen
      Og personbrukerens status er «Aktiv»
      Og det fremgår at personbrukeren ikke har logget inn ennå
      Og jeg kan tildele personbrukeren flere roller før hen logger inn første gang
      Og endringen er sporbar i historikk

    Scenario: Personbrukeren gjenkjennes ved første pålogging
      Gitt jeg har registrert en personbruker som aldri har logget inn
      Og personbrukeren er tildelt en rolle
      Når personen logger inn for første gang
      Så er det den registrerte personbrukeren som er innlogget
      Og personbrukeren har tilgangene rollen gir
      Og det opprettes ikke en ny personbruker for samme person

    Scenario: Personen er allerede registrert
      Gitt personen allerede er registrert som personbruker
      Når jeg registrerer den samme personen på nytt
      Så får jeg beskjed om at personen allerede er registrert
      Og det opprettes ikke en ny personbruker
      Og jeg får ikke vite hvilke organisasjoner den eksisterende personbrukeren har tildelinger for

    Scenario: Registrering av en person som allerede har Feide-konto
      Gitt personen allerede finnes som personbruker med Feide-ID
      Når jeg registrerer den samme personen som personbruker uten Feide-konto
      Så får jeg beskjed om at personen allerede er registrert
      Og det opprettes ikke en ny personbruker

  Regel: En registrering må gi personbrukeren minst én tildeling

    Scenario: Registrering uten tildeling er ikke mulig
      Gitt jeg holder på å registrere en personbruker
      Og jeg har oppgitt fødselsnummeret hens
      Og jeg har ikke gitt personbrukeren noen tildeling
      Når jeg forsøker å fullføre registreringen
      Så blir personbrukeren ikke registrert
      Og jeg får beskjed om at personbrukeren må ha minst én tildeling

    Scenario: Registrering og første tildeling hører sammen
      Gitt jeg registrerer en person som personbruker med fødselsnummeret hens
      Og jeg gir personbrukeren en tildeling i den samme operasjonen
      Når jeg fullfører registreringen
      Så finnes personbrukeren med tildelingen
      Og jeg finner personbrukeren igjen i brukeroversikten
      Og tildelingen gir tilgang fra personbrukeren logger inn første gang

  Regel: Navnet hentes fra påloggingen

    Scenario: Navnet er ikke kjent før første pålogging
      Gitt jeg har registrert en personbruker som aldri har logget inn
      Når jeg ser personbrukeren i brukeroversikten
      Så er navnet tomt
      Og det fremgår at personbrukeren ikke har logget inn ennå

    Scenario: Navnet vises etter første pålogging
      Gitt jeg har registrert en personbruker som aldri har logget inn
      Når personen har logget inn for første gang
      Og jeg ser personbrukeren i brukeroversikten
      Så ser jeg personbrukerens navn slik påloggingen oppga det
      Og personbrukeren kan søkes opp på navn

  Regel: Registrert, men ikke logget inn, er en varig tilstand

    Scenario: Tilstanden fremgår av detaljene og av brukeroversikten
      Gitt jeg har registrert en personbruker som aldri har logget inn
      Når jeg ser personbrukerens detaljside
      Så fremgår det at personbrukeren ikke har logget inn ennå
      Og jeg ser tildelingene personbrukeren har fått
      Og det fremgår at tildelingene gjelder fra første pålogging
      Og den samme tilstanden fremgår av brukeroversikten

    Scenario: Feil identifikasjon viser seg som en personbruker som aldri logger inn
      Gitt jeg har registrert en personbruker med feil opplysninger om hvem personen er
      Når personen logger inn
      Så gjenkjennes hen ikke som den registrerte personbrukeren
      Og det opprettes ingen personbruker for hen
      Og det fremgår fortsatt at personbrukeren jeg registrerte ikke har logget inn ennå
      Og tilstanden består så lenge opplysningene ikke rettes

  Regel: En registrert personbruker som ennå ikke har roller

    @openquestion
    Scenario: Personbrukeren logger inn før hen har fått roller
      Gitt jeg har registrert en personbruker som ikke er tildelt noen roller
      Når personen logger inn for første gang
      Så får personbrukeren beskjed om at hen ennå ikke har tilganger i FS
      Og personbrukeren møter ikke en feilmelding

    # ÅPNE SPØRSMÅL: Hva en innlogget personbruker uten tilganger skal møte, er ikke bestemt.
    # Risikoen er notert på Confluence 5022777363: påloggingen alene gir de ni fagskolene
    # innlogging med tomt tilgangssett, og ordlyden i beskjeden er ikke avklart.

# ÅPNE SPØRSMÅL:
# - Oppdateres navnet ved senere pålogginger hvis personen bytter navn, eller står navnet slik
#   det var ved første pålogging? Juristen godkjente 21.09 at navnet hentes fra påloggingen,
#   men ikke hvor ofte det leses.
# - Skal en personbruker uten Feide-konto kunne slettes, eller er deaktivering (BRU-PER-GRU-014)
#   eneste utvei når hen ikke lenger skal ha tilgang?
# - Registreringen skal ha eget GitHub-issue som sub-issue under initiativet #514.
