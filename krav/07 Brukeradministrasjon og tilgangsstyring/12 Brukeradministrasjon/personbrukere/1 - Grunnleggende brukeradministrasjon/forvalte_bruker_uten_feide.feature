# language: no
# GitHub: #514
@BRU-PER-GRU-014 @must @planned
Egenskap: Forvalte en personbruker uten Feide-konto
  Som brukeradministrator
  ønsker jeg å forvalte personbrukere uten Feide-konto i den samme flaten som øvrige personbrukere
  slik at ansatte som logger inn med ID-porten får, beholder og mister tilganger på samme måte som alle andre.

  En personbruker uten Feide-konto er en fullverdig personbruker: hen kan ha roller,
  vises i oversikten, søkes opp, ses i detalj, og deaktiveres og reaktiveres. Forskjellen
  fra en personbruker med Feide-ID er at hen ikke har en Feide-ID og ingen hjemorganisasjon:
  hen er identifisert med fødselsnummer eller D-nummer ved registrering (BRU-PER-GRU-013), og
  det er tildelingene alene som knytter hen til organisasjoner.

  Kravet utdyper BRU-PER-GRU-001 (listevisning og søk), BRU-PER-GRU-007 (detaljer),
  BRU-PER-GRU-003 (tildele roller), BRU-PER-GRU-012 (fjerne roller) og BRU-PER-GRU-004
  (aktivere og deaktivere) for denne typen personbruker. Der kravet ikke sier noe annet,
  gjelder reglene i de kravene uendret.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har brukeradministrator-rollen for minst én organisasjon

  Regel: Personbrukere uten Feide-konto inngår i listevisning, søk og detaljvisning

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

    Scenario: Søk på Feide-ID finner ikke personbrukere uten Feide-konto
      Gitt jeg ser listen over personbrukere
      Når jeg søker med fritekst på Feide-ID
      Så ser jeg ikke personbrukere uten Feide-konto i resultatet

    Scenario: Se detaljer for en personbruker uten Feide-konto
      Gitt jeg ser detaljsiden for en personbruker uten Feide-konto
      Så ser jeg personbrukerens navn
      Og jeg ser om personbrukeren er aktiv eller deaktivert
      Og det fremgår at personbrukeren logger inn med ID-porten og ikke har Feide-ID

  Regel: Synligheten følger av aktive tildelinger i organisasjoner jeg administrerer

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

  Regel: En personbruker uten Feide-konto er ikke tilordnbar som saksbehandler

    Scenario: Personbruker uten Feide-konto kan ikke velges som saksbehandler
      Gitt en personbruker uten Feide-konto er aktiv og har roller i opptak
      Når en administrator velger saksbehandler for en sak
      Så er personbrukeren ikke valgbar som saksbehandler

    Scenario: Saksbehandlerlisten påvirkes ikke av registrering
      Gitt en ny personbruker uten Feide-konto er registrert
      Når en administrator åpner listen over mulige saksbehandlere
      Så inneholder listen de samme personbrukerne som før registreringen

# ÅPNE SPØRSMÅL:
# - Avgrensningen mot saksbehandler gjelder denne fasen, fordi saksbehandleridentiteten er
#   Feide-brukernavnet. Skal personbrukere uten Feide-konto senere kunne være saksbehandlere, og
#   hva skal saksbehandleridentiteten være da?
# - Hva vises i Feide-ID-kolonnen i listen for en personbruker uten Feide-konto - tom celle, en
#   strek, eller en egen markering? Henger sammen med kolonnespørsmålet i BRU-PER-GRU-001.
# - Personbrukeren har ingen egen organisasjon. Hva som eventuelt skal vises som personbrukerens
#   organisasjon i listen og på detaljsiden, der øvrige personbrukere har hjemorganisasjon, er
#   ikke avklart. Organisasjonene tildelingene gjelder for er den nærliggende kandidaten, men det
#   er ikke bestemt. Det samme gjelder hjemorganisasjonsfilteret i BRU-PER-GRU-001.
# - Skal brukeroversikten vise begge typer personbrukere i én liste, eller i to seksjoner?
#   Kravet forutsetter én felles liste; avklares med design.
# - Skal listen kunne filtreres på påloggingsmåte (Feide / ID-porten)?
# - Gjelder nekt og inndragning av roller og tilganger (BRU-PER-GRU-011, BRU-PER-GRU-012)
#   uendret for denne typen personbruker? Antatt ja, men ikke bekreftet.
# - Når den siste aktive tildelingen er fjernet, er personbrukeren ikke synlig i noen liste, og
#   det er bestemt at neste tildeling gjør hen synlig igjen. Hvordan administratoren gir den
#   tildelingen til en personbruker hen ikke kan finne, er ikke avklart. Å registrere det samme
#   fødselsnummeret eller D-nummeret på nytt er den nærliggende kandidaten, men det ville endre
#   scenariet «Personen er allerede registrert» i BRU-PER-GRU-013, som i dag avviser en gjentatt
#   registrering.
# - Deaktivering gjør alle tildelingene inaktive. Hvordan en deaktivert personbruker uten
#   Feide-konto da forblir synlig for administratoren som skal kunne reaktivere hen, er ikke
#   avklart; for øvrige personbrukere er det hjemorganisasjonen som gir den synligheten.
# - Forvaltningen skal ha eget GitHub-issue som sub-issue under initiativet #514.
