# language: no
# GitHub: #514
@BRU-PER-GRU-015 @must @draft
Egenskap: Se Feide-brukere og personer i samme oversikt i overgangsperioden
  Som brukeradministrator
  ønsker jeg å se og forvalte både Feide-brukere og personer i den samme oversikten mens tildelingene flyttes fra Feide-brukerne til personene,
  slik at jeg kan gi og fjerne tilganger for alle personbrukerne jeg administrerer i én flate, også før flyttingen er ferdig.

  Personbrukeren er personen, identifisert med fødselsnummer, D-nummer eller SNR (BRU-PER-GRU-013
  og BRU-PER-GRU-014). Tildelingene ligger i dag på Feide-brukerne. De flyttes til personene når
  grensesnittet for personer er klart, og en personbruker som er flyttet, har de samme tilgangene
  etterpå. Til da, og så lenge det finnes Feide-brukere med tildelinger, vises Feide-brukere og
  personer i den samme listen. Tildeling til Feide-brukere skal fjernes etter hvert.

  Kravet gjelder bare overgangsperioden, og avvikles når tildelingene er flyttet og tildeling til
  Feide-brukere er fjernet.

  Bakgrunn:
    Gitt brukeradministratoren er innlogget i løsningen
    Og brukeradministratoren har brukeradministrator-rollen for minst én organisasjon

  Regel: Feide-brukere og personer vises i den samme listen

    Scenario: Begge typer vises i brukeroversikten
      Gitt en Feide-bruker har en aktiv tildeling i en organisasjon og et miljø brukeradministratoren administrerer
      Og en person har en aktiv tildeling i den samme organisasjonen og det samme miljøet
      Når brukeradministratoren åpner brukeroversikten
      Så ser brukeradministratoren både Feide-brukeren og personen i den samme listen
      Og listen er sortert etter navn i stigende rekkefølge

    @openquestion
    Scenario: Det fremgår om personbrukeren er en Feide-bruker eller en person
      # ÅPNE SPØRSMÅL:
      # - Skal listen vise om personbrukeren er en Feide-bruker eller en person, og i så fall
      #   hvordan? Det er ikke bestemt.
      Når brukeradministratoren åpner brukeroversikten
      Så fremgår det for hver personbruker om det er en Feide-bruker eller en person

    @openquestion
    Scenario: Feide-ID og hjemorganisasjon vises bare for Feide-brukere
      # ÅPNE SPØRSMÅL:
      # - Hva står i kolonnene «Feide-ID» og «Hjemorganisasjon» for en person: «-» som for en
      #   Feide-bruker uten kjent hjemorganisasjon i dag, eller noe annet?
      Når brukeradministratoren åpner brukeroversikten
      Så vises Feide-ID og hjemorganisasjon for Feide-brukerne
      Men en person har verken Feide-ID eller hjemorganisasjon i listen

    Scenario: Søk på navn finner begge typer
      Gitt brukeradministratoren ser listen over personbrukere
      Når brukeradministratoren søker med fritekst på navn
      Så filtreres listen til Feide-brukere og personer der navnet inneholder søketeksten

  Regel: Detaljsiden og tildelingene fungerer for begge typer

    Scenario: Se detaljsiden for en person fra listen
      Gitt brukeradministratoren ser listen over personbrukere
      Når brukeradministratoren velger en person
      Så ser brukeradministratoren detaljsiden for personen

    Scenario: Tildele en rolle til en person
      Gitt brukeradministratoren ser detaljsiden for en person
      Når brukeradministratoren tildeler personen en rolle for en organisasjon og et miljø
      Så legges rollen til i personens tildelinger

    Scenario: Fjerne en rolle fra en person
      Gitt brukeradministratoren ser detaljsiden for en person med en tildelt rolle
      Når brukeradministratoren fjerner rollen
      Så har personen ikke rollen lenger

    @openquestion
    Scenario: Tildeling til Feide-brukere
      # ÅPNE SPØRSMÅL:
      # - Når slutter det å være mulig å tildele roller til Feide-brukere: når skriptet er kjørt,
      #   eller ved en senere beslutning?
      Gitt brukeradministratoren ser detaljsiden for en Feide-bruker
      Når brukeradministratoren tildeler Feide-brukeren en rolle for en organisasjon og et miljø
      Så legges rollen til i Feide-brukerens tildelinger

  Regel: Tildelingene flyttes fra Feide-brukeren til personen

    @openquestion
    Scenario: En Feide-bruker som er flyttet, har de samme tilgangene etterpå
      # ÅPNE SPØRSMÅL:
      # - Vises Feide-brukeren fortsatt i listen etter flyttingen? Feide-brukeren beholdes, og
      #   synligheten gjennom hjemorganisasjonen gjelder fortsatt, så den samme personen kan stå
      #   to ganger.
      # - Følger «Tildelt av» og «Tildelt dato» med når tildelingen flyttes?
      Gitt en Feide-bruker har aktive tildelinger
      Og fødselsnummeret til Feide-brukeren er kjent
      Når tildelingene flyttes til personen
      Så har personen de samme tildelingene som Feide-brukeren hadde
      Og personen har de samme tilgangene når hen logger inn med Feide

    @openquestion
    Scenario: En Feide-bruker uten kjent fødselsnummer beholder tildelingene
      # ÅPNE SPØRSMÅL:
      # - Fødselsnummeret blir kjent når Feide-brukeren logger inn. Hva skjer med Feide-brukere som
      #   ikke har logget inn før tildelingene flyttes: skal skriptet kjøres på nytt senere, eller
      #   må brukeradministratoren gi personen tilgang med fødselsnummer (BRU-PER-GRU-013)?
      Gitt en Feide-bruker har aktive tildelinger
      Og fødselsnummeret til Feide-brukeren er ikke kjent
      Når tildelingene flyttes til personene
      Så beholder Feide-brukeren tildelingene sine

# ÅPNE SPØRSMÅL:
# - Gir brukeradministratoren en Feide-bruker som ennå ikke er flyttet, en rolle med fødselsnummer
#   (BRU-PER-GRU-013), finnes hen både som Feide-bruker og som person. Hvordan skal det vises?
# - Gjelder statusfilteret og rollefilteret i brukeroversikten for begge typer? Personer kan ikke
#   deaktiveres i API-et ennå.
