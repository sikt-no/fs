# language: no
# GitHub: #514
@BRU-PER-GRU-014 @must @planned
Egenskap: Forvalte en person i brukeradministrasjonen
  Som brukeradministrator
  ønsker jeg å forvalte personer i den samme flaten som øvrige personbrukere
  slik at en person får, beholder og mister tilganger på samme måte uansett om hen logger inn med Feide eller ID-porten.

  Personbrukeren er personen, identifisert med fødselsnummer, D-nummer eller SNR. Feide og
  ID-porten er påloggingsmåter, ikke ulike typer personbrukere. En person er en fullverdig
  personbruker: hen kan ha roller, vises i oversikten, søkes opp, ses i detalj, og deaktiveres
  og reaktiveres. En person som logger inn med Feide, er koblet til Feide-brukeren sin og har
  hjemorganisasjonen fra Feide. Brukeradministratoren ser personen gjennom den hjemorganisasjonen
  eller gjennom en aktiv tildeling. En person som bare logger inn med ID-porten, har ingen
  hjemorganisasjon, og da er det tildelingene alene som knytter hen til organisasjoner. Den
  første tildelingen gis med fødselsnummer, D-nummer eller SNR (BRU-PER-GRU-013). Nummeret vises
  ikke i grensesnittet.

  Kravet ble skrevet for «personbrukere uten Feide-konto». Scenarioene som fortsatt sier det,
  gjelder nå personer. Scenarioer som bygger på at personen er knyttet til en påloggingsmåte, er
  merket med forslag til workshopen.

  Kravet utdyper BRU-PER-GRU-001 (listevisning og søk), BRU-PER-GRU-007 (detaljer),
  BRU-PER-GRU-003 (tildele roller), BRU-PER-GRU-012 (fjerne roller) og BRU-PER-GRU-004
  (aktivere og deaktivere) for personer. Der kravet ikke sier noe annet, gjelder reglene i de
  kravene uendret.

  Personbrukere-siden viser personer. Feide-brukerne som er koblet til en person, vises på
  personens detaljside. Det er ingen overgangsvisning der Feide-brukere og personer vises sammen.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har brukeradministrator-rollen for minst én organisasjon

  Regel: Personbrukere uten Feide-konto inngår i listevisning, søk og detaljvisning

    # FORSLAG TIL WORKSHOP: fjernes, fordi personen ikke er knyttet til en påloggingsmåte, og
    # fordi Feide-ID-kolonnen foreslås fjernet i BRU-PER-GRU-001. Erstattes av «Personen vises i
    # brukeroversikten» under.
    Scenario: Personbruker uten Feide-konto vises i brukeroversikten
      Gitt en personbruker uten Feide-konto har en aktiv tildeling for en organisasjon jeg administrerer
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen sammen med øvrige personbrukere
      Og jeg ser personbrukerens navn og status
      Og det fremgår at personbrukeren ikke har en Feide-ID

    Scenario: Søke opp en personbruker uten Feide-konto på navn
      Gitt jeg ser listen over personbrukere
      Og en personbruker uten Feide-konto har logget inn minst én gang
      Når jeg søker med fritekst på navnet
      Så ser jeg personbrukeren i listen

    # FORSLAG TIL WORKSHOP: fjernes, fordi søket på Feide-ID foreslås fjernet i BRU-PER-GRU-001.
    Scenario: Søk på Feide-ID finner ikke personbrukere uten Feide-konto
      Gitt jeg ser listen over personbrukere
      Når jeg søker med fritekst på Feide-ID
      Så ser jeg ikke personbrukere uten Feide-konto i resultatet

    # FORSLAG TIL WORKSHOP: fjernes, fordi personen ikke er knyttet til en påloggingsmåte. Erstattes
    # av «Se detaljer for en person» under.
    Scenario: Se detaljer for en personbruker uten Feide-konto
      Gitt jeg ser detaljsiden for en personbruker uten Feide-konto
      Så ser jeg personbrukerens navn
      Og jeg ser om personbrukeren er aktiv eller deaktivert
      Og det fremgår at personbrukeren logger inn med ID-porten og ikke har Feide-ID

  @draft @openquestion
  Regel: Personen vises med navn, ikke med nummer
    # ÅPNE SPØRSMÅL:
    # - Hva vises som hjemorganisasjon for en person som ikke er koblet til en Feide-bruker? Og
    #   hva vises for en person som er koblet til flere Feide-brukere med ulike hjemorganisasjoner?
    # - Hvordan merkes en testperson i listen og på detaljsiden: egen kolonne, en merkelapp ved
    #   navnet, eller et filter?
    # - Personen kan ikke deaktiveres i API-et ennå. Skal status vises for personer før
    #   deaktivering er på plass?

    Scenario: Personen vises i brukeroversikten
      Gitt en person har en aktiv tildeling for en organisasjon og et miljø brukeradministratoren administrerer
      Når brukeradministratoren åpner brukeroversikten
      Så ser brukeradministratoren personen i listen sammen med øvrige personbrukere
      Og brukeradministratoren ser personens navn
      Men personens fødselsnummer, D-nummer eller SNR vises ikke

    Scenario: Se detaljer for en person
      Når brukeradministratoren ser detaljsiden for en person
      Så ser brukeradministratoren personens navn
      Men personens fødselsnummer, D-nummer eller SNR vises ikke

    Scenario: En testperson er merket
      Gitt en person er en testperson
      Når brukeradministratoren ser personen i brukeroversikten
      Så fremgår det at personen er en testperson

    Scenario: Søk på fødselsnummer, D-nummer eller SNR er ikke mulig
      Gitt brukeradministratoren ser listen over personbrukere
      Når brukeradministratoren søker med en persons fødselsnummer
      Så finner ikke søket personen på fødselsnummeret

  @draft @openquestion
  Regel: Detaljsiden viser Feide-brukerne som er koblet til personen
    # ÅPNE SPØRSMÅL:
    # - Hvilke opplysninger vises for hver Feide-bruker? Feide-ID og hjemorganisasjon er antatt,
    #   men ikke bestemt.
    # - Skal listen også vise Feide-brukerne, for eksempel Feide-ID-en, eller bare detaljsiden?

    Scenario: Se Feide-brukerne til en person
      Gitt en person er koblet til en Feide-bruker
      Når brukeradministratoren ser detaljsiden for personen
      Så ser brukeradministratoren Feide-brukeren som er koblet til personen
      Og brukeradministratoren ser hjemorganisasjonen til Feide-brukeren

    Scenario: En person med flere Feide-brukere
      Gitt en person er koblet til to Feide-brukere med ulike hjemorganisasjoner
      Når brukeradministratoren ser detaljsiden for personen
      Så ser brukeradministratoren begge Feide-brukerne

    Scenario: En person uten Feide-bruker
      Gitt en person logger bare inn med ID-porten
      Når brukeradministratoren ser detaljsiden for personen
      Så fremgår det at personen ikke er koblet til noen Feide-bruker

  Regel: Synligheten følger av aktive tildelinger i organisasjoner jeg administrerer

    @draft
    Scenario: Hjemorganisasjonen til en koblet Feide-bruker gir synlighet
      Gitt jeg har brukeradministrator-rollen for en organisasjon
      Og en person er koblet til en Feide-bruker med hjemorganisasjon i organisasjonen
      Når jeg åpner brukeroversikten
      Så ser jeg personen i listen

    Scenario: En aktiv tildeling i mitt miljø gir synlighet
      Gitt jeg har brukeradministrator-rollen for en organisasjon i et miljø
      Og en personbruker uten Feide-konto har en aktiv tildeling for den organisasjonen i det miljøet
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen

    Scenario: Personbrukeren er synlig straks etter registrering
      Gitt jeg nettopp har registrert en personbruker uten Feide-konto med en tildeling for en organisasjon jeg administrerer
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og det fremgår at personbrukeren ikke har logget inn ennå

    Scenario: Datatilgang gir synlighet når tildelingen er aktiv og gjelder i mitt miljø
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker uten Feide-konto har tildelinger for organisasjoner jeg ikke administrerer
      Men personbrukeren har også en aktiv tildeling som gir tilgang til data fra en av mine
      Og den tildelingen gjelder i et miljø jeg har brukeradministrator-rollen i
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen

    Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker uten Feide-konto har tildelinger bare for organisasjoner jeg ikke administrerer
      Og personbrukeren har ingen aktive tildelinger som gir tilgang til data fra mine
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

    Scenario: Fjerning av den siste aktive tildelingen gjør personbrukeren usynlig
      Gitt jeg ser detaljsiden for en personbruker uten Feide-konto med én aktiv tildeling
      Når jeg fjerner tildelingen
      Så er tildelingen fjernet
      Og endringen er sporbar i historikk
      Og personbrukeren vises ikke lenger i brukeroversikten min
      Og personbrukeren dukker ikke opp når jeg søker
      Og personbrukeren blir synlig igjen når hen får en ny aktiv tildeling for en organisasjon jeg administrerer

  Regel: Roller tildeles og fjernes som for øvrige personbrukere

    Scenario: Tildele en rolle før personbrukeren har logget inn
      Gitt jeg ser detaljsiden for en personbruker uten Feide-konto som aldri har logget inn
      Når jeg tildeler personbrukeren en rolle for en organisasjon og et miljø
      Så legges rollen til i personbrukerens tildelinger
      Og endringen er sporbar i historikk

    Scenario: Tildelte roller gir tilgang ved pålogging
      Gitt en personbruker uten Feide-konto er tildelt en rolle
      Når personen logger inn
      Så har personbrukeren tilgangene rollen gir
      Og personbrukeren har ikke tilgang utover det tildelingene gir

    Scenario: Fjerne en rolle
      Gitt jeg ser detaljsiden for en personbruker uten Feide-konto med en tildelt rolle
      Når jeg fjerner rollen
      Så har ikke personbrukeren rollen lenger
      Og personbrukeren mister tilgangene rollen ga
      Og endringen er sporbar i historikk

  Regel: Deaktivering og reaktivering virker som for øvrige personbrukere

    Scenario: Deaktivere en personbruker uten Feide-konto
      Gitt jeg ser detaljsiden for en personbruker uten Feide-konto med aktive tildelinger
      Når jeg deaktiverer personbrukeren
      Så blir personbrukerens status «Deaktivert»
      Og alle personbrukerens tildelinger blir inaktive
      Og tildelingene beholdes — de fjernes ikke
      Og personbrukeren kan ikke nå FS-data ved neste innloggingsforsøk
      Og endringen er sporbar i historikk

    Scenario: Reaktivere en deaktivert personbruker uten Feide-konto
      Gitt en personbruker uten Feide-konto er deaktivert
      Når jeg reaktiverer personbrukeren
      Så blir personbrukerens status «Aktiv»
      Og de tidligere tildelte rollene blir aktive igjen
      Og endringen er sporbar i historikk

    Scenario: Filtrere på status
      Gitt jeg ser listen over personbrukere
      Og en personbruker uten Feide-konto er deaktivert
      Når jeg filtrerer på status «Deaktivert»
      Så ser jeg personbrukeren i listen

  Regel: En personbruker kan tilordnes som saksbehandler uansett innloggingsmåte

    Scenario: Personbruker uten Feide-konto kan velges som saksbehandler
      Gitt en personbruker uten Feide-konto er aktiv og har roller i opptak
      Når en administrator velger saksbehandler for en sak
      Så er personbrukeren valgbar som saksbehandler

    Scenario: Registrering alene gjør ikke personbrukeren til saksbehandler
      Gitt en ny personbruker uten Feide-konto er registrert uten roller i opptak
      Når en administrator åpner listen over mulige saksbehandlere
      Så er personbrukeren ikke i listen

  @draft @openquestion
  Regel: Tildelingene flyttes fra Feide-brukeren til personen
    # ÅPNE SPØRSMÅL:
    # - Personbrukere-siden viser bare personer. Må tildelingene være flyttet før siden tas i bruk,
    #   så Feide-brukere med roller ikke forsvinner fra oversikten?
    # - Følger «Tildelt av» og «Tildelt dato» med når tildelingen flyttes?

    Scenario: En Feide-bruker som er flyttet, har de samme tilgangene etterpå
      Gitt en Feide-bruker har aktive tildelinger
      Og Feide-brukeren er koblet til en person
      Når tildelingene flyttes til personen
      Så har personen de samme tildelingene som Feide-brukeren hadde
      Og personen har de samme tilgangene når hen logger inn med Feide

    @openquestion
    Scenario: En Feide-bruker som ikke er koblet til en person, beholder tildelingene
      # ÅPNE SPØRSMÅL:
      # - Koblingen opprettes når Feide-brukeren logger inn. Hva skjer med Feide-brukere som ikke
      #   har logget inn før tildelingene flyttes: skal flyttingen kjøres på nytt senere, eller må
      #   brukeradministratoren gi personen tilgang med fødselsnummer (BRU-PER-GRU-013)?
      Gitt en Feide-bruker har aktive tildelinger
      Og Feide-brukeren er ikke koblet til en person
      Når tildelingene flyttes til personene
      Så beholder Feide-brukeren tildelingene sine

# ÅPNE SPØRSMÅL:
# - Avgrensningen mot saksbehandler gjelder denne fasen, fordi saksbehandleridentiteten er
#   Feide-brukernavnet. Skal personer senere kunne være saksbehandlere, og hva skal
#   saksbehandleridentiteten være da? Når rollene er flyttet fra Feide-brukerne til personene,
#   gjelder avgrensningen også ansatte som i dag er saksbehandlere.
# - Gjelder nekt og inndragning av roller og tilganger (BRU-PER-GRU-011, BRU-PER-GRU-012)
#   uendret for personer? Antatt ja, men ikke bekreftet.
# - Deaktivering gjør alle tildelingene inaktive. Hvordan en deaktivert person da forblir synlig
#   for administratoren som skal kunne reaktivere hen, er ikke avklart for personer uten
#   hjemorganisasjon. For Feide-brukere, og for personer koblet til en Feide-bruker, er det
#   hjemorganisasjonen som gir den synligheten. API-et viser i dag en person som har en
#   tildeling, aktiv eller ikke, i en organisasjon og et miljø administratoren har lesetilgang i.
#   Kravene sier aktiv tildeling. Hva skal gjelde?
# - Skal listen kunne filtreres på testperson?
# - Bør kravet gå opp i BRU-PER-GRU-001, -003, -004, -007 og -012 når Feide-brukerne er borte,
#   siden det da ikke lenger finnes andre personbrukere å skille personen fra?
# - Forvaltningen skal ha eget GitHub-issue som sub-issue under initiativet #514.

# BESVART av beslutningene 25.09–07.10 (tidligere åpne spørsmål i kravet):
# - Én liste eller to seksjoner: personbrukere-siden viser bare personer. Feide-brukerne som er
#   koblet til personen, vises på detaljsiden. Det er ingen overgangsvisning (07.10).
# - Filter på påloggingsmåte: personen er ikke knyttet til en påloggingsmåte, så filteret
#   bortfaller.
# - Hvordan en person uten aktive tildelinger får en ny tildeling: med fødselsnummer, D-nummer
#   eller SNR (BRU-PER-GRU-013). En gjentatt tildeling avvises ikke lenger.
# - Hva som vises som personens organisasjon, står fortsatt åpent, se regelen «Personen vises med
#   navn, ikke med nummer».
