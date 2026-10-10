# language: no
# GitHub: #514
@BRU-PER-GRU-013 @must @in-progress
Egenskap: Gi en person tilgang med fødselsnummer, D-nummer eller SNR
  Som brukeradministrator
  ønsker jeg å gi en person den første tildelingen i en organisasjon jeg administrerer, og identifisere personen med fødselsnummer, D-nummer eller SNR,
  slik at personen får tilgang i FS uansett om hen har Feide-konto, har tilganger i andre organisasjoner eller ikke finnes i løsningen fra før.

  Personbrukeren er personen, identifisert med fødselsnummer, D-nummer eller SNR. Feide og
  ID-porten er påloggingsmåter: når personen logger inn, finnes hen ut fra nummeret, uansett
  hvilken påloggingsmåte hen bruker. En brukeradministrator ser en person gjennom en aktiv
  tildeling i en organisasjon og et miljø brukeradministratoren har rett i, eller gjennom
  hjemorganisasjonen til en Feide-bruker personen er koblet til. Andre personer er usynlige for
  brukeradministratoren. Brukeradministratoren gir derfor tildelingen og oppgir nummeret i samme
  operasjon, og personen blir synlig gjennom den nye tildelingen. Det gjøres fra rollesiden
  (BRU-PER-ROL-002), ikke fra brukeroversikten.

  De fleste fagskolene har Feide-domene på fylkeskommunenivå. Hjemorganisasjonen til en
  fagskoleansatt med Feide er da fylkeskommunen, ikke fagskolen, og gir ikke synlighet for
  fagskolens brukeradministrator. Fagskoleansatte får derfor tilgang slik dette kravet beskriver,
  uansett om de logger inn med Feide eller ID-porten.

  Svaret er det samme uansett om personen fantes fra før, og det avslører ikke hvilke
  tildelinger personen har i andre organisasjoner. Nummeret vises ikke i grensesnittet etterpå.
  Personen vises med navn. Navnet til en person som ikke fantes fra før, kommer fra personens
  første pålogging. Er navnet ikke kjent, vises «Navn ikke kjent».

  Kravet erstatter «Registrere en personbruker uten Feide-konto». Blokkene fra den modellen står
  nederst, merket med forslag til workshopen. Påloggingen med ID-porten er dekket av
  TIL-PÅL-PÅL-002.

  Bakgrunn:
    Gitt brukeradministratoren er innlogget i løsningen
    Og brukeradministratoren har brukeradministrator-rollen for minst én organisasjon

  @openquestion
  Regel: Den første tildelingen gis med fødselsnummer, D-nummer eller SNR
    # ÅPNE SPØRSMÅL:
    # - En Feide-bruker hvis tildelinger ennå ikke er flyttet til personen, har rollene sine på
    #   Feide-brukeren. Gir brukeradministratoren hen en rolle med fødselsnummeret, får personen
    #   rollen, mens de øvrige rollene ligger igjen på Feide-brukeren til de flyttes. Hvordan
    #   vises de rollene på personens detaljside? Se regelen om flytting i BRU-PER-GRU-014.

    Scenario: Personen finnes ikke i løsningen
      Gitt det finnes ingen person med fødselsnummeret i løsningen
      Når brukeradministratoren gir personen en rolle for en organisasjon og et miljø og oppgir fødselsnummeret
      Så har personen rollen for organisasjonen og miljøet
      Og brukeradministratoren ser personen i brukeroversikten

    Scenario: Personen har tildelinger bare i organisasjoner brukeradministratoren ikke administrerer
      Gitt personen har aktive tildelinger bare i organisasjoner brukeradministratoren ikke administrerer
      Og brukeradministratoren ser ikke personen i brukeroversikten
      Når brukeradministratoren gir personen en rolle for en organisasjon og et miljø og oppgir fødselsnummeret
      Så har personen rollen for organisasjonen og miljøet
      Og brukeradministratoren ser personen i brukeroversikten
      Og det opprettes ikke en ny person i databasen

    Scenario: Personen er allerede synlig for brukeradministratoren
      Gitt personen har en aktiv tildeling i en organisasjon og et miljø brukeradministratoren administrerer
      Når brukeradministratoren gir personen en ny rolle og oppgir fødselsnummeret
      Så har personen den nye rollen i tillegg til tildelingen personen hadde fra før
      Og det opprettes ikke en ny person i databasen

    Scenario: Personen har ingen aktive tildelinger lenger
      Gitt personen har hatt tildelinger, men har ingen aktive tildelinger nå
      Når brukeradministratoren gir personen en rolle for en organisasjon og et miljø og oppgir fødselsnummeret
      Så har personen rollen for organisasjonen og miljøet
      Og brukeradministratoren ser personen i brukeroversikten
      Og det opprettes ikke en ny person i databasen

    Scenario: Personen har logget inn med Feide tidligere
      Gitt personen har Feide-konto og har logget inn med Feide tidligere
      Når brukeradministratoren gir personen en rolle for en organisasjon og et miljø og oppgir fødselsnummeret
      Så har personen rollen for organisasjonen og miljøet
      Og brukeradministratoren ser personen i brukeroversikten

    Scenariomal: Personen identifiseres med fødselsnummer, D-nummer eller SNR
      Gitt det finnes ingen person med nummeret i løsningen
      Når brukeradministratoren gir personen en rolle for en organisasjon og et miljø og oppgir personens <nummertype>
      Så har personen rollen for organisasjonen og miljøet

      Eksempler:
        | nummertype     |
        | fødselsnummer  |
        | D-nummer       |
        | SNR            |

    Scenario: Flere tilganger legges til fra brukersiden etter den første rollen
      Gitt brukeradministratoren har gitt personen den første rollen og oppgitt fødselsnummeret
      Når brukeradministratoren åpner personen i brukeroversikten
      Så kan brukeradministratoren legge til flere tilganger for personen der

    Scenario: Personen kan ikke legges til uten en rolle
      Gitt brukeradministratoren har oppgitt personens fødselsnummer
      Og brukeradministratoren har ikke valgt rolle, organisasjon og miljø
      Når brukeradministratoren forsøker å fullføre
      Så får personen ingen tildeling
      Og det opprettes ingen person i databasen

  @draft @openquestion
  Regel: Personen kan søkes opp i FS-SIS i stedet for å oppgi nummeret
    For institusjoner som bruker FS-SIS, kan brukeradministratoren finne personen med et
    personsøk i SIS. Da må hen ikke alltid oppgi fødselsnummer, D-nummer eller SNR for en person
    som ikke har tilganger fra før.

    # ÅPNE SPØRSMÅL:
    # - Prioriteten er ikke satt.
    # - Hva kan brukeradministratoren søke på, og hvilke opplysninger vises i treffene? Nummeret
    #   vises ellers ikke i grensesnittet.
    # - Hvilke personer i SIS kan brukeradministratoren søke blant: bare personene ved egen
    #   institusjon?
    # - Kan et treff avsløre at personen har tildelinger i andre organisasjoner? Se regelen
    #   «Svaret avslører ikke om personen fantes fra før».

    Scenario: Finne personen med personsøk i SIS
      Gitt institusjonen bruker FS-SIS
      Og personen finnes i SIS
      Når brukeradministratoren finner personen med personsøk i SIS og gir hen en rolle for en organisasjon og et miljø
      Så har personen rollen for organisasjonen og miljøet
      Og brukeradministratoren har ikke oppgitt personens fødselsnummer, D-nummer eller SNR

  Regel: Svaret avslører ikke om personen fantes fra før
    Navnet er bare kjent for en person som har logget inn før. Beskjeden viser derfor ikke navnet,
    for da ville den avsløre at personen fantes fra før.

    Scenariomal: Svaret er det samme uansett hva som fantes fra før
      Gitt personen <utgangspunkt>
      Når brukeradministratoren gir personen en rolle for en organisasjon og et miljø og oppgir fødselsnummeret
      Så får brukeradministratoren beskjed om at personen har fått rollen
      Og beskjeden sier ikke om personen fantes i løsningen fra før

      Eksempler:
        | utgangspunkt                                                                         |
        | finnes ikke i løsningen                                                              |
        | har aktive tildelinger bare i organisasjoner brukeradministratoren ikke administrerer |
        | har en aktiv tildeling i en organisasjon brukeradministratoren administrerer          |
        | har Feide-konto og har logget inn med Feide tidligere                                |
        | har ingen aktive tildelinger lenger                                                  |

    Scenario: Tildelinger i andre organisasjoner vises ikke
      Gitt personen har en aktiv tildeling i en organisasjon brukeradministratoren ikke administrerer
      Når brukeradministratoren gir personen en rolle og oppgir fødselsnummeret
      Og brukeradministratoren ser detaljsiden for personen
      Så ser brukeradministratoren rollen brukeradministratoren ga
      Men brukeradministratoren ser ikke tildelingen i organisasjonen brukeradministratoren ikke administrerer

  Regel: Nummeret vises ikke etterpå

    Scenariomal: Nummeret vises ikke etter at tilgangen er gitt
      Gitt brukeradministratoren har gitt personen en rolle og oppgitt fødselsnummeret
      Når brukeradministratoren ser personen på <sted>
      Så vises ikke personens fødselsnummer

      Eksempler:
        | sted                       |
        | brukeroversikten           |
        | detaljsiden for personen   |
        | rollens oversiktsside      |

  @draft @openquestion
  Regel: Personen gjenkjennes ved pålogging, uansett påloggingsmåte
    # ÅPNE SPØRSMÅL:
    # - Gjenkjenning ved pålogging med Feide forutsetter at fødselsnummeret er kjent når personen
    #   logger inn med Feide. Gjelder det alle Feide-brukere?
    # - Kan en person med SNR logge inn med ID-porten eller Feide, og gjenkjennes hen da på SNR?

    Scenario: Personen logger inn med ID-porten
      Gitt brukeradministratoren har gitt personen en rolle og oppgitt fødselsnummeret
      Når personen logger inn med ID-porten
      Så har personen tilgangene rollen gir

    Scenario: Personen logger inn med Feide
      Gitt brukeradministratoren har gitt personen en rolle og oppgitt fødselsnummeret
      Og personen har Feide-konto
      Når personen logger inn med Feide
      Så har personen tilgangene rollen gir

    Scenario: Påloggingen oppretter ikke en ny person
      Gitt brukeradministratoren har gitt personen en rolle og oppgitt fødselsnummeret
      Når personen logger inn
      Så finnes det fortsatt bare én person med fødselsnummeret

  Regel: Nummeret må ha gyldige kontrollsifre
    SNR har en egen personnummerserie, atskilt fra de fiktive numrene FS' egen generator lager
    (måned +50 og personnummer fra 70000 og oppover). Løsningen kan derfor skille et SNR fra dem.
    Et FS-generert nummer avvises med en egen beskjed, også når kontrollsifrene er gyldige.

    Scenariomal: Nummer med ugyldige kontrollsifre avvises
      Gitt brukeradministratoren oppgir et <nummertype> med ugyldige kontrollsifre
      Når brukeradministratoren gir personen en rolle for en organisasjon og et miljø
      Så får personen ingen tildeling
      Og det opprettes ingen person i databasen
      Og brukeradministratoren får beskjed om at nummeret er ugyldig

      Eksempler:
        | nummertype     |
        | fødselsnummer  |
        | D-nummer       |
        | SNR            |

    Scenario: FS-generert nummer avvises
      Gitt brukeradministratoren oppgir et nummer fra FS' egen generator
      Når brukeradministratoren gir personen en rolle for en organisasjon og et miljø
      Så får personen ingen tildeling
      Og det opprettes ingen person i databasen
      Og brukeradministratoren får beskjed om at et FS-generert nummer ikke kan brukes

  Regel: En testperson kan ikke få tilgang i et ekte miljø, og en ekte person ikke i et testmiljø
    En testperson har nummer i Skatteetatens syntetiske serie. Et SNR tilhører en ekte person. Et
    fiktivt nummer fra FS' egen generator avvises, fordi det ikke kan identifisere en person (se
    regelen «Nummeret må ha gyldige kontrollsifre»).

    Scenario: Testperson får ikke tilgang i et ekte miljø
      Gitt fødselsnummeret tilhører en testperson
      Når brukeradministratoren gir personen en rolle i miljøet production og oppgir fødselsnummeret
      Så får personen ingen tildeling
      Og brukeradministratoren får beskjed om at en testperson ikke kan få tilgang i et ekte miljø

    Scenario: Testperson kan få tilgang i et testmiljø
      Gitt fødselsnummeret tilhører en testperson
      Når brukeradministratoren gir personen en rolle i et testmiljø og oppgir fødselsnummeret
      Så har personen rollen i testmiljøet

    Scenario: Ekte person får ikke tilgang i et testmiljø
      Gitt fødselsnummeret tilhører en ekte person
      Når brukeradministratoren gir personen en rolle i et testmiljø og oppgir fødselsnummeret
      Så får personen ingen tildeling
      Og brukeradministratoren får beskjed om at en ekte person ikke kan få tilgang i et testmiljø

  Regel: Brukeradministratoren kan bare gi roller hen har rett til å tildele
    Alle med brukeradministrator-rollen kan gi tilgang med fødselsnummer, D-nummer eller SNR. Det
    kreves ingen egen rettighet.

    Scenario: Brukeradministrator gir tilgang med nummer uten egen rettighet
      Gitt brukeradministratoren har brukeradministrator-rollen for en organisasjon i et miljø
      Og brukeradministratoren har ingen annen rettighet enn brukeradministrator-rollen
      Når brukeradministratoren gir personen en rolle for organisasjonen og miljøet og oppgir fødselsnummeret
      Så har personen rollen for organisasjonen og miljøet

    Scenario: Rolle brukeradministratoren ikke har rett til å tildele
      Gitt brukeradministratoren har ikke rett til å tildele rollen for organisasjonen og miljøet
      Når brukeradministratoren forsøker å gi personen rollen og oppgir fødselsnummeret
      Så får personen ingen tildeling
      Og det opprettes ingen person i databasen

  # FORSLAG TIL WORKSHOP: fjernes, fordi alle scenarioene i regelen er erstattet av reglene over.
  # Personen identifiseres med nummeret uansett påloggingsmåte, så «uten Feide-konto» er ikke
  # lenger et eget tilfelle.
  @draft @openquestion
  Regel: En personbruker kan registreres før hen har logget inn første gang
    # ÅPNE SPØRSMÅL:
    # - Regelen er foreslått fjernet (se forslaget over). Kan den slettes?

    # FORSLAG TIL WORKSHOP: fjernes, fordi det er erstattet av «Personen finnes ikke i løsningen».
    Scenario: Registrere en ansatt som ikke har Feide-konto
      Gitt personen ikke har en Feide-konto
      Og personen har aldri logget inn i løsningen
      Når jeg registrerer personen som personbruker med fødselsnummeret eller D-nummeret hens og minst én tildeling
      Så finnes personbrukeren i løsningen
      Og personbrukerens status er «Aktiv»
      Og det fremgår at personbrukeren ikke har logget inn ennå
      Og jeg kan tildele personbrukeren flere roller før hen logger inn første gang
      Og endringen er sporbar i historikk

    # FORSLAG TIL WORKSHOP: fjernes, fordi det er erstattet av regelen «Personen gjenkjennes ved
    # pålogging, uansett påloggingsmåte».
    Scenario: Personbrukeren gjenkjennes ved første pålogging
      Gitt jeg har registrert en personbruker som aldri har logget inn
      Og personbrukeren er tildelt en rolle
      Når personen logger inn for første gang
      Så er det den registrerte personbrukeren som er innlogget
      Og personbrukeren har tilgangene rollen gir
      Og det opprettes ikke en ny personbruker for samme person

  # FORSLAG TIL WORKSHOP: fjernes, fordi regelen er dekket av «Personen kan ikke legges til uten en
  # rolle» og «Personen finnes ikke i løsningen», og fordi tilgangen ved første pålogging er dekket
  # av regelen «Personen gjenkjennes ved pålogging, uansett påloggingsmåte».
  @draft @openquestion
  Regel: En registrering må gi personbrukeren minst én tildeling
    # ÅPNE SPØRSMÅL:
    # - Regelen er foreslått fjernet (se forslaget over). Kan den slettes?

    Scenario: Registrering uten tildeling er ikke mulig
      Gitt jeg holder på å registrere en personbruker
      Og jeg har oppgitt fødselsnummeret eller D-nummeret hens
      Og jeg har ikke gitt personbrukeren noen tildeling
      Når jeg forsøker å fullføre registreringen
      Så blir personbrukeren ikke registrert
      Og jeg får beskjed om at personbrukeren må ha minst én tildeling

    Scenario: Registrering og første tildeling hører sammen
      Gitt jeg registrerer en person som personbruker med fødselsnummeret eller D-nummeret hens
      Og jeg gir personbrukeren en tildeling i den samme operasjonen
      Når jeg fullfører registreringen
      Så finnes personbrukeren med tildelingen
      Og jeg finner personbrukeren igjen i brukeroversikten
      Og tildelingen gir tilgang fra personbrukeren logger inn første gang

  @openquestion
  Regel: Navnet hentes fra påloggingen
    Navnet til en person som ikke fantes fra før, kommer fra personens første pålogging.
    Brukeradministratoren oppgir ikke navnet, og det hentes ikke fra Folkeregisteret. Feide
    oppgir navnet ved pålogging. Er navnet ikke kjent, vises «Navn ikke kjent». Det gjelder også
    en person som har logget inn, men der påloggingen ikke oppga navnet.

    Teksten er nøytral og sier ikke om personen har logget inn. En person som har logget inn før,
    vises likevel med navn straks tildelingen er gitt. Et manglende navn kan derfor antyde at
    personen ikke har logget inn før.

    # ÅPNE SPØRSMÅL:
    # - Er det akseptabelt at et manglende navn kan antyde at personen ikke har logget inn før?

    Scenario: Navnet er ikke kjent før første pålogging
      Gitt brukeradministratoren har gitt en person som ikke fantes fra før, en rolle og oppgitt fødselsnummeret
      Og personen har ikke logget inn
      Når brukeradministratoren ser personen i brukeroversikten
      Så vises navnet som «Navn ikke kjent»

    Scenario: Navnet er ikke kjent når påloggingen ikke oppgir navnet
      Gitt brukeradministratoren har gitt en person som ikke fantes fra før, en rolle og oppgitt fødselsnummeret
      Og personen har logget inn med en påloggingsmåte som ikke oppga navnet
      Når brukeradministratoren ser personen i brukeroversikten
      Så vises navnet som «Navn ikke kjent»

    Scenario: Navnet vises etter første pålogging med Feide
      Gitt brukeradministratoren har gitt en person som ikke fantes fra før, en rolle og oppgitt fødselsnummeret
      Når personen har logget inn med Feide for første gang
      Og brukeradministratoren ser personen i brukeroversikten
      Så ser brukeradministratoren personens navn slik påloggingen oppga det
      Og personen kan søkes opp på navn

  @draft
  Regel: En person som ikke har logget inn, beholder tildelingene til de fjernes
    En person som har fått tilgang med fødselsnummer, D-nummer eller SNR, beholder tildelingene
    selv om hen aldri logger inn. Tildelingene utløper ikke av at personen ikke logger inn.

    Scenario: En person som ikke har logget inn, vises med tildelingene sine
      Gitt brukeradministratoren har gitt en person som ikke fantes fra før, en rolle og oppgitt fødselsnummeret
      Og personen har ikke logget inn
      Når brukeradministratoren ser detaljsiden for personen
      Så vises navnet som «Navn ikke kjent»
      Og brukeradministratoren ser tildelingene personen har fått
      Og personen vises med «Navn ikke kjent» i brukeroversikten

    Scenario: Feil identifikasjon viser seg som en person som aldri logger inn
      Gitt brukeradministratoren har gitt en person en rolle og oppgitt feil fødselsnummer
      Og ingen person med det oppgitte fødselsnummeret har logget inn
      Når den riktige personen logger inn
      Så har den riktige personen ikke tilgangene rollen gir
      Og personen som fikk rollen, vises fortsatt med «Navn ikke kjent»
      Og tilstanden består til brukeradministratoren fjerner tildelingen

  @draft
  Regel: En person som ikke lenger har tildelinger
    Fjernes den siste aktive tildelingen, blir personen usynlig for brukeradministratoren
    (BRU-PER-GRU-012, regelen «Fjerning av den siste aktive tildelingen gjør personen usynlig»).
    Personen finnes fortsatt i løsningen og kan logge inn. Hen kan få en ny tildeling med
    fødselsnummer, D-nummer eller SNR.

    @openquestion
    Scenario: Personen logger inn etter at den siste tildelingen er fjernet
      # ÅPNE SPØRSMÅL:
      # - Hva en innlogget person uten tilganger skal møte, er ikke bestemt. Risikoen er notert
      #   på Confluence 5022777363: påloggingen alene gir de ni fagskolene innlogging med tomt
      #   tilgangssett, og ordlyden i beskjeden er ikke avklart.
      Gitt brukeradministratoren har fjernet den siste aktive tildelingen personen hadde
      Når personen logger inn
      Så får personen beskjed om at hen ikke har tilganger i FS
      Og personen møter ikke en feilmelding

# ÅPNE SPØRSMÅL:
# - Oppdateres navnet ved senere pålogginger hvis personen bytter navn, eller står navnet slik
#   det var ved første pålogging? Juristen godkjente 21.09 at navnet hentes fra påloggingen,
#   men ikke hvor ofte det leses.
# - Skal en personbruker uten Feide-konto kunne slettes, eller er deaktivering (BRU-PER-GRU-014)
#   eneste utvei når hen ikke lenger skal ha tilgang?
# - Scenariet «Personen har logget inn med Feide tidligere» forutsetter at
#   fødselsnummeret eller D-nummeret til personbrukere med Feide-ID er kjent. Det lagres først
#   ved personens neste pålogging etter at løsningen begynner å hente det, så en Feide-bruker som
#   ikke har logget inn siden da, kan ikke oppdages. Om det gapet er akseptabelt, eller om det
#   trengs en engangs etterfylling, er ikke avklart.
# - Registreringen skal ha eget GitHub-issue som sub-issue under initiativet #514.
