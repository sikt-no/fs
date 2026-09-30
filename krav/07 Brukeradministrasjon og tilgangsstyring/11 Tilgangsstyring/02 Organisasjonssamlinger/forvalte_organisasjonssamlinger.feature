# language: no
@BRU-TIL-SAM-001 @could @draft
Egenskap: Forvalte organisasjonssamlinger
  Som forvalter av tilgangsstyring i Sikt
  ønsker jeg å opprette organisasjonssamlinger og bestemme hvilke organisasjoner de består av
  slik at en tilgang kan gjelde en navngitt mengde organisasjoner i stedet for én organisasjon.

  En organisasjonssamling er en navngitt, forvaltet mengde organisasjoner. Den finnes for at
  «alle læresteder» skal være en eksplisitt mengde som kan listes og etterprøves, i stedet for
  en regel ingen kan se. Samlingen har ingen eierorganisasjon, og medlemskapet gjelder per
  miljø: samme samling kan ha ulike medlemmer i test og i produksjon.

  Datamodellen for samlinger, medlemskap og tildeling mot samling er på plass (fs-plattform
  MR 5262), og autorisasjonen utvider allerede en tildeling mot en samling til samlingens
  aktive medlemmer. Det som mangler, og som denne egenskapen beskriver, er forvaltningsflaten:
  i dag kan bare databaseforvaltningen opprette samlinger og skrive medlemskap.

  # ÅPNE SPØRSMÅL:
  # - Hva skal den globale forvaltningsrettigheten hete, og hvilken rolle bærer den? Rollen
  #   hører hjemme i forretningsrollesettet som er under arbeid, og finnes ikke i dag.
  # - Skal forvaltningen ligge i FS Admin sammen med den øvrige tilgangsstyringen, eller i en
  #   egen flate for Sikt-interne forvaltningsoppgaver?
  # - Skal en samling kunne avvikles, eller er en samling uten medlemmer den eneste
  #   avslutningen?

  Bakgrunn:
    Gitt jeg er innlogget i løsningen

  Regel: Katalogen over organisasjonssamlinger kan listes og åpnes

    Scenario: Se liste over organisasjonssamlinger
      Når jeg åpner oversikten over organisasjonssamlinger
      Så ser jeg en liste over alle samlinger
      Og listen er sortert etter navn i stigende rekkefølge
      Og hvert innslag viser følgende informasjon:
        | felt             |
        | Navn             |
        | Beskrivelse      |
        | Antall medlemmer |

    Scenario: Antall medlemmer gjelder ett miljø
      Gitt jeg ser listen over organisasjonssamlinger
      Når jeg velger et miljø
      Så viser antall medlemmer de organisasjonene som er medlem i det valgte miljøet

    Scenario: Åpne detaljsiden for en organisasjonssamling
      Gitt jeg ser listen over organisasjonssamlinger
      Når jeg velger en samling
      Så ser jeg samlingens navn og beskrivelse
      Og jeg ser medlemsorganisasjonene i det valgte miljøet
      Og det fremgår at samlingen ikke tilhører noen organisasjon

    Scenario: Samlingen er synlig uten forvaltningsrettighet
      Gitt jeg ikke har forvaltningsrettighet for organisasjonssamlinger
      Når jeg åpner detaljsiden for en organisasjonssamling
      Så ser jeg samlingens navn, beskrivelse og medlemsorganisasjoner
      Men jeg ser ingen handlinger for å endre samlingen eller medlemskapene

  Regel: Forvaltning av samlinger krever en global forvaltningsrettighet

    # En samling går på tvers av organisasjoner og har ingen eierorganisasjon. Rettigheten kan
    # derfor ikke skopes til en organisasjon slik resten av tilgangsstyringen er skopet, og må
    # være global — på Sikt-nivå.

    Scenario: Forvalter med global forvaltningsrettighet oppretter en samling
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Når jeg oppretter en organisasjonssamling med navn og beskrivelse
      Så er samlingen opprettet
      Og samlingen har ingen medlemmer

    Scenario: Rettigheten gjelder alle samlinger
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Når jeg åpner oversikten over organisasjonssamlinger
      Så kan jeg forvalte hver samling i oversikten

    Scenario: Administrator med rettighet i egne organisasjoner kan ikke forvalte samlinger
      Gitt jeg administrerer én eller flere organisasjoner
      Og jeg ikke har global forvaltningsrettighet for organisasjonssamlinger
      Når jeg åpner oversikten over organisasjonssamlinger
      Så ser jeg ingen handling for å opprette en samling
      Og jeg ser ingen handling for å endre medlemskapene i en samling

    Scenario: Å administrere en organisasjon gir ikke rett til å melde den inn i en samling
      Gitt jeg administrerer en organisasjon
      Og jeg ikke har global forvaltningsrettighet for organisasjonssamlinger
      Når jeg åpner detaljsiden for en organisasjonssamling
      Så ser jeg ingen handling for å melde min organisasjon inn i samlingen

  Regel: Navnet identifiserer samlingen

    Scenario: Navn må fylles inn for å opprette en samling
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Når jeg forsøker å opprette en samling uten å fylle inn navn
      Så avvises opprettelsen
      Og det fremgår at navn er obligatorisk

    Scenario: Opprettelse avvises når navnet allerede er i bruk
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og det finnes en samling med et gitt navn
      Når jeg forsøker å opprette en ny samling med det samme navnet
      Så avvises opprettelsen
      Og det fremgår at navnet allerede er i bruk

    Scenario: Beskrivelse er valgfri
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Når jeg oppretter en samling uten beskrivelse
      Så er samlingen opprettet

    Scenario: Endre navnet på en samling flytter ingen tilganger
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og en samling har medlemmer og tildelte tilganger
      Når jeg endrer navnet på samlingen
      Så beholder samlingen sine medlemmer og tildelte tilganger

  Regel: Medlemskap forvaltes per miljø

    Scenario: Legge til en organisasjon som medlem i et miljø
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Når jeg legger til en organisasjon som medlem av en samling i et valgt miljø
      Så er organisasjonen medlem av samlingen i det miljøet
      Og organisasjonen er ikke medlem av samlingen i de øvrige miljøene

    Scenario: Mengden kan variere mellom miljøer
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og en organisasjon er medlem av en samling i testmiljøet
      Når jeg åpner samlingen i produksjonsmiljøet
      Så er organisasjonen ikke listet som medlem

    Scenario: En organisasjon kan være medlem av flere samlinger
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og en organisasjon er medlem av en samling i et miljø
      Når jeg legger til organisasjonen som medlem av en annen samling i samme miljø
      Så er organisasjonen medlem av begge samlingene

    Scenario: Organisasjon som allerede er medlem vises som ikke valgbar
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og en organisasjon er medlem av en samling i et miljø
      Når jeg åpner valglisten for å legge til medlemmer i samlingen for det samme miljøet
      Så vises organisasjonen som ikke valgbar
      Og det fremgår at organisasjonen allerede er medlem

    Scenario: Fjerne en organisasjon fra en samling
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og en organisasjon er medlem av en samling i et miljø
      Når jeg fjerner organisasjonen fra samlingen i det miljøet
      Så er organisasjonen ikke lenger medlem av samlingen i det miljøet
      Og tilganger som fulgte av medlemskapet gjelder ikke lenger for organisasjonen

    Scenario: Fjerning berører ikke tilganger som er tildelt direkte på organisasjonen
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og en organisasjon er medlem av en samling i et miljø
      Og en bruker har den samme tilgangen tildelt direkte på organisasjonen
      Når jeg fjerner organisasjonen fra samlingen i det miljøet
      Så beholder brukeren tilgangen på organisasjonen

  Regel: Medlemskapshistorikken er sporbar

    Scenario: Se når en organisasjon ble medlem
      Gitt en organisasjon er medlem av en samling i et miljø
      Når jeg åpner detaljsiden for samlingen
      Så ser jeg når organisasjonen ble medlem
      Og jeg ser hvem som meldte organisasjonen inn

    Scenario: Se avsluttede medlemskap
      Gitt en organisasjon har vært medlem av en samling og er fjernet
      Når jeg åpner medlemskapshistorikken for samlingen
      Så ser jeg det avsluttede medlemskapet med tidspunktet det startet og tidspunktet det ble avsluttet
      Og jeg ser hvem som meldte organisasjonen inn og hvem som fjernet den

    Scenario: Gjeninnmelding gir et nytt medlemskap
      Gitt en organisasjon har vært medlem av en samling og er fjernet
      Når jeg legger organisasjonen til som medlem av samlingen igjen
      Så er organisasjonen medlem fra og med tidspunktet den ble meldt inn på nytt
      Og det tidligere medlemskapet står fortsatt i historikken

    Scenario: Historikken viser hvilke organisasjoner samlingen besto av på et gitt tidspunkt
      Gitt en samling har hatt medlemmer som er kommet til og fjernet over tid
      Når jeg ser samlingen slik den var på et gitt tidspunkt
      Så ser jeg de organisasjonene som var medlem på det tidspunktet

  Regel: Samlinger med over 500 medlemmer krever ytelsesmåling før de tas i bruk

    # Ikke-funksjonelt krav. Teamet målte 2026-08-17 at autorisasjonsoppslag holder seg innenfor
    # rammene for en samling med 500 medlemmer, og at knekkpunktet ligger et sted mellom 500 og
    # 5 000 medlemmer. Grensen er derfor satt der målingen rekker, ikke der modellen slutter å
    # virke. Den største samlingen i dag har 37 medlemmer.

    Scenario: Forvaltning av en samling med inntil 500 medlemmer
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og en samling har inntil 500 medlemmer i et miljø
      Når jeg legger til eller fjerner et medlem
      Så utføres endringen innenfor de vanlige svartidskravene
      Og pålogging og autorisasjon for brukere i medlemsorganisasjonene er upåvirket

    @openquestion
    Scenario: Forsøk på å utvide en samling forbi 500 medlemmer
      # ÅPNE SPØRSMÅL: Skal 500 være en hard grense i flaten, eller et varsel forvalteren kan
      # gå videre fra? Grensen bør flyttes når ytelsen er målt over 500 medlemmer, og valget
      # avhenger av hvem som eier den målingen.
      Gitt jeg har global forvaltningsrettighet for organisasjonssamlinger
      Og en samling har 500 medlemmer i et miljø
      Når jeg forsøker å legge til et nytt medlem i det miljøet
      Så får jeg beskjed om at ytelsen må måles før samlingen utvides
