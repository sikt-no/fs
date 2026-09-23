# language: no
# GitHub: #514
@BRU-PER-GRU-014 @must @planned
Egenskap: Forvalte en personbruker uten Feide-konto
  Som brukeradministrator
  ønsker jeg å forvalte personbrukere uten Feide-konto i den samme flaten som øvrige personbrukere
  slik at ansatte som logger inn med ID-porten får, beholder og mister tilganger på samme måte som alle andre.

  En personbruker uten Feide-konto er en fullverdig personbruker: hen kan ha roller,
  vises i oversikten, søkes opp, ses i detalj, og deaktiveres og reaktiveres. Forskjellen
  fra en personbruker med Feide-ID er at hen ikke har en Feide-ID, og at
  hjemorganisasjonen er satt eksplisitt ved registrering (BRU-PER-GRU-013) framfor å følge
  av Feide-tilhørigheten.

  Kravet utdyper BRU-PER-GRU-001 (listevisning og søk), BRU-PER-GRU-007 (detaljer),
  BRU-PER-GRU-003 (tildele roller), BRU-PER-GRU-012 (fjerne roller) og BRU-PER-GRU-004
  (aktivere og deaktivere) for denne typen personbruker. Der kravet ikke sier noe annet,
  gjelder reglene i de kravene uendret.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg har brukeradministrator-rollen for minst én organisasjon

  Regel: Personbrukere uten Feide-konto inngår i listevisning, søk og detaljvisning

    Scenario: Personbruker uten Feide-konto vises i brukeroversikten
      Gitt en personbruker uten Feide-konto har hjemorganisasjon i en organisasjon jeg administrerer
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen sammen med øvrige personbrukere
      Og jeg ser personbrukerens navn, hjemorganisasjon og status
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

    Scenario: Filtrere på hjemorganisasjon
      Gitt jeg ser listen over personbrukere
      Når jeg velger hjemorganisasjonen til en personbruker uten Feide-konto som filter
      Så ser jeg personbrukeren i listen

    Scenario: Se detaljer for en personbruker uten Feide-konto
      Gitt jeg ser detaljsiden for en personbruker uten Feide-konto
      Så ser jeg personbrukerens navn
      Og jeg ser personbrukerens hjemorganisasjon
      Og jeg ser om personbrukeren er aktiv eller deaktivert
      Og det fremgår at personbrukeren logger inn med ID-porten og ikke har Feide-ID

  Regel: Synligheten følger de samme reglene som for øvrige personbrukere

    Scenario: Hjemorganisasjonen gir synlighet uavhengig av miljø
      Gitt jeg har brukeradministrator-rollen for en organisasjon
      Og en personbruker uten Feide-konto har den organisasjonen som hjemorganisasjon
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og jeg ser personbrukeren uavhengig av hvilket miljø administrasjonsrettigheten min gjelder for

    Scenario: Personbrukeren er synlig for hjemorganisasjonen straks etter registrering
      Gitt en personbruker uten Feide-konto nettopp er registrert i en organisasjon jeg administrerer
      Og personbrukeren har ingen tildelinger ennå
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen

    Scenario: Datatilgang gir synlighet når tildelingen er aktiv og gjelder i mitt miljø
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker uten Feide-konto har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Men personbrukeren har en aktiv tildeling som gir tilgang til data fra en av dem
      Og tildelingen gjelder i et miljø jeg har brukeradministrator-rollen i
      Når jeg åpner brukeroversikten
      Så ser jeg personbrukeren i listen
      Og hjemorganisasjonen som vises er personbrukerens egen, ikke organisasjonen tildelingen gjelder for

    Scenario: Personbrukere uten tilknytning til egne organisasjoner er ikke synlige
      Gitt jeg har brukeradministrator-rollen for én eller flere organisasjoner
      Og en personbruker uten Feide-konto har hjemorganisasjon utenfor de organisasjonene jeg administrerer
      Og personbrukeren har ingen aktive tildelinger som gir tilgang til data fra dem
      Når jeg åpner brukeroversikten
      Så ser jeg ikke personbrukeren i listen

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
# - Skal brukeroversikten vise begge typer personbrukere i én liste, eller i to seksjoner?
#   Kravet forutsetter én felles liste; avklares med design.
# - Skal listen kunne filtreres på påloggingsmåte (Feide / ID-porten)?
# - Gjelder nekt og inndragning av roller og tilganger (BRU-PER-GRU-011, BRU-PER-GRU-012)
#   uendret for denne typen personbruker? Antatt ja, men ikke bekreftet.
# - For en administrator i en annen organisasjon enn personbrukerens hjemorganisasjon er det en
#   aktiv tildeling som gir synlighet. Hva som skal skje med den administratorens bilde når den
#   siste slike tildelingen fjernes, er ikke avklart. For hjemorganisasjonen er personbrukeren
#   synlig uansett.
# - Forvaltningen skal ha eget GitHub-issue som sub-issue under initiativet #514.
