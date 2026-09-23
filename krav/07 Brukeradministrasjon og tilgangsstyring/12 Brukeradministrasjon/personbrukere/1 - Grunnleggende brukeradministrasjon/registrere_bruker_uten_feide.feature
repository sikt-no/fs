# language: no
# GitHub: #514
@BRU-PER-GRU-013 @must @planned
Egenskap: Registrere en personbruker uten Feide-konto
  Som brukeradministrator
  ønsker jeg å registrere en ansatt som ikke har Feide-konto, før hen har logget inn første gang,
  slik at ansatte ved læresteder uten Feide — blant annet fagskolene — kan få tilganger i FS.

  En personbruker uten Feide-konto logger inn med ID-porten i stedet for Feide. Hen har
  ingen Feide-ID, og dermed heller ingen Feide-tilhørighet å utlede hjemorganisasjon fra.
  Hjemorganisasjonen settes derfor eksplisitt av administratoren som registrerer
  personbrukeren, og er organisasjonen som forvalter hen. Den er noe annet enn
  organisasjonen en tildeling gjelder for, på samme måte som for øvrige personbrukere
  (BRU-PER-GRU-007).

  Registrering er nødvendig fordi personbrukeren må kunne få roller før hen logger inn
  første gang. Selve påloggingen med ID-porten er dekket av TIL-PÅL-PÅL-002.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har brukeradministrator-rollen for minst én organisasjon

  Regel: En personbruker kan registreres før hen har logget inn første gang

    Scenario: Registrere en ansatt som ikke har Feide-konto
      Gitt personen ikke har en Feide-konto
      Og personen har aldri logget inn i løsningen
      Når jeg registrerer personen som personbruker med opplysningene som identifiserer hen entydig
      Så finnes personbrukeren i løsningen
      Og personbrukerens status er «Aktiv»
      Og det fremgår at personbrukeren ikke har logget inn ennå
      Og jeg kan tildele personbrukeren roller før hen logger inn første gang
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
      Og jeg får ikke vite hvilken organisasjon den eksisterende personbrukeren hører til

    Scenario: Registrering av en person som allerede har Feide-konto
      Gitt personen allerede finnes som personbruker med Feide-ID
      Når jeg registrerer den samme personen som personbruker uten Feide-konto
      Så får jeg beskjed om at personen allerede er registrert
      Og det opprettes ikke en ny personbruker

  Regel: Hjemorganisasjonen er organisasjonen som registrerer personbrukeren

    Scenario: Hjemorganisasjon settes ved registrering
      Gitt jeg administrerer kun én organisasjon
      Når jeg registrerer en personbruker
      Så er personbrukerens hjemorganisasjon organisasjonen jeg administrerer
      Og hjemorganisasjonen vises på personbrukerens detaljside

    Scenario: Administrator for flere organisasjoner velger hjemorganisasjon
      Gitt jeg administrerer flere organisasjoner
      Når jeg åpner registreringen av en personbruker
      Så må jeg velge hvilken organisasjon som skal være hjemorganisasjon
      Og valglisten inneholder kun organisasjoner jeg har brukeradministrator-rollen for

    Scenario: Hjemorganisasjonen utledes ikke fra påloggingen
      Gitt jeg har registrert en personbruker med en valgt hjemorganisasjon
      Når personen logger inn
      Så har personbrukeren fortsatt hjemorganisasjonen jeg satte ved registrering
      Og hjemorganisasjonen påvirkes ikke av e-postadresse eller andre opplysninger fra påloggingen

    Scenario: Registrering krever brukeradministrator-rollen i hjemorganisasjonen
      Gitt jeg ikke har brukeradministrator-rollen for en bestemt organisasjon
      Når jeg forsøker å registrere en personbruker med den organisasjonen som hjemorganisasjon
      Så blir personbrukeren ikke registrert
      Og jeg får beskjed om at jeg mangler rettighet til å registrere personbrukere for organisasjonen

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

  Regel: En registrering må gi personbrukeren minst én tildeling

    Scenario: Registrering uten tildeling er ikke mulig
      Gitt jeg holder på å registrere en personbruker
      Og jeg har ikke gitt personbrukeren noen tildeling
      Når jeg forsøker å fullføre registreringen
      Så blir personbrukeren ikke registrert
      Og jeg får beskjed om at personbrukeren må ha minst én tildeling

    Scenario: Registrering og første tildeling hører sammen
      Gitt jeg registrerer en person som personbruker
      Og jeg gir personbrukeren en tildeling i den samme operasjonen
      Når jeg fullfører registreringen
      Så finnes personbrukeren med tildelingen
      Og jeg finner personbrukeren igjen i brukeroversikten
      Og tildelingen gir tilgang fra personbrukeren logger inn første gang

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
# - Hvilken opplysning administratoren taster for å identifisere personen entydig ved
#   registrering, er ikke avklart. Kravet sier bare at identifiseringen må være entydig og at
#   den samme personen må gjenkjennes ved første pålogging. Valget er ikke tatt, og det er et personvernspørsmål like mye som et teknisk et.
# - Oppdateres navnet ved senere pålogginger hvis personen bytter navn, eller står navnet slik
#   det var ved første pålogging? Juristen godkjente 21.09 at navnet hentes fra påloggingen,
#   men ikke hvor ofte det leses.
# - Kan hjemorganisasjonen endres senere? For personbrukere med Feide-ID løses arbeidsstedsbytte
#   ved at personbrukeren slettes og opprettes på nytt med ny Feide-ID (BRU-PER-GRU-007). En
#   personbruker uten Feide-konto beholder den samme identiteten på tvers av arbeidssted, så den
#   utveien finnes ikke her.
# - Skal en personbruker uten Feide-konto kunne slettes, eller er deaktivering (BRU-PER-GRU-014)
#   eneste utvei når hen ikke lenger skal ha tilgang?
# - Registreringen skal ha eget GitHub-issue som sub-issue under initiativet #514.
