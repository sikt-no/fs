# language: no
# GitHub: #587
@OPT-PLA-SVA-001 @must @draft @scope-plasstildeling-2027
Egenskap: Håndtere svar fra søker
  Som søker
  ønsker jeg å svare på tilbud og ventelisteplass innen svarfristen
  slik at jeg sikrer meg studieplassen jeg vil ha.

  # Kilde: tasks/opptak/plasstildeling/design.md (prinsipp 2, informasjonsarv, avklaring 4, 5 og 11),
  # oppgave.md (oppgave 9) og Confluence «2026-09-08 Raffinering plasstildeling» (oppgave 8).
  # Svarene behandles i neste plasstildeling i opptaket. Det gis ikke automatisk nye tilbud ved
  # nei-svar mellom plasstildelingsrundene (oppgave 10 i oppgave.md, utenfor scope 2027).
  # Status i kode: delvis. Ja/nei virker. Trukket ja-svar etter svarfristen og manuell overstyring mangler.
  # Svarflyten søkeren ser i Min kompetanse, står i 13 Søknad og saksbehandling/01 Søknad/svare_på_tilbud.feature
  # (levert): hva som kan besvares, svar etter fristen, svar på ventelisteplass, samlet svar og endring av svar
  # innen fristen. Denne fila beskriver hva svarene betyr for plasstildelingen.

  Bakgrunn:
    Gitt at søkeren "Kari Nordmann" er innlogget i Min kompetanse
    Og at søkeren har fått tilbud på "Sykepleie, høst 2027" i "Hovedrunde" med svarfrist "2027-07-20 23:59"

  Regel: Søkeren svarer ja eller nei på tilbudet innen svarfristen

    Scenario: Takke ja til tilbud
      Når søkeren takker ja til tilbudet innen "2027-07-20 23:59"
      Så beholder søkeren tilbudet ut opptaket

    # AVKLART 2026-10-08 (A1 i «Plasstildelingsløpet i Opptak»): et nei-svar gjør plassen ledig
    # først når svarfristen er ute. Fram til fristen kan søkeren ombestemme seg.
    Scenario: Takke nei til tilbud
      Når søkeren takker nei til tilbudet innen "2027-07-20 23:59"
      Og svarfristen "2027-07-20 23:59" er ute
      Så blir plassen ledig i neste plasstildeling i opptaket

    Scenario: Nei-svar før svarfristen er ute
      Gitt at søkeren har takket nei til tilbudet
      Og at svarfristen "2027-07-20 23:59" ikke er ute
      Når det gjennomføres en plasstildeling i opptaket
      Så beholder søkeren tilbudet på "Sykepleie, høst 2027"
      Og plassen blir ikke gitt til en annen søker

    Scenario: Søker svarer ikke innen svarfristen
      Gitt at søkeren ikke har svart på tilbudet
      Når svarfristen "2027-07-20 23:59" er ute
      Så mister søkeren tilbudet
      Og plassen blir ledig i neste plasstildeling i opptaket

    Scenario: Svar etter svarfristen
      Gitt at svarfristen "2027-07-20 23:59" er ute
      Når søkeren vil svare på tilbudet
      Så kan søkeren ikke lenger svare på tilbudet

  Regel: Søkeren kan svare ja til å stå på venteliste

    Scenario: Stå på venteliste
      Gitt at søkeren står på venteliste til "Vernepleie, høst 2027"
      Når søkeren svarer ja til å stå på venteliste innen svarfristen
      Så er søkeren med på ventelisten i neste plasstildeling

    Scenario: Ingen bortfall på ventelisteplass fra etterfylling
      Gitt at søkeren har svart ja til å stå på venteliste til "Vernepleie, høst 2027"
      Når plasstildelingen i "Etterfylling" gjennomføres
      Så får søkeren ikke bortfall på "Vernepleie, høst 2027"

  Regel: Søker med flere tilbud må velge ett

    Scenario: Velge mellom to tilbud i etterfylling
      Gitt at søkeren har tilbud på både "Sykepleie, høst 2027" og "Vernepleie, høst 2027" etter "Etterfylling"
      Når søkeren takker ja til tilbudet på "Sykepleie, høst 2027"
      Og svarfristen for "Etterfylling" er ute
      Så blir tilbudet på "Vernepleie, høst 2027" ledig i neste plasstildeling

    # AVKLART 2026-10-14 (domeneekspert): Uansett runde kan søkeren bare takke ja til ett tilbud i samordna opptak.
    # Antallet settes på opptaket, se 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature.
    # Svarflyten for søkeren står i 13 Søknad og saksbehandling/01 Søknad/svare_på_tilbud.feature.
    Scenariomal: Søkeren kan bare takke ja til ett tilbud
      Gitt at opptaket tillater at en søker takker ja til 1 tilbud
      Og at søkeren har tilbud på både "Sykepleie, høst 2027" og "Vernepleie, høst 2027" etter "<plasstildelingsrunde>"
      Og at søkeren har takket ja til tilbudet på "Sykepleie, høst 2027"
      Når søkeren vil takke ja til tilbudet på "Vernepleie, høst 2027"
      Så kan søkeren ikke ha takket ja til begge tilbudene

      Eksempler:
        | plasstildelingsrunde |
        | Hovedrunde           |
        | Suppleringsrunde     |
        | Etterfylling         |

# ÅPNE SPØRSMÅL:
# - Skal en søker som takker ja og trekker seg etter svarfristen (svaret blir GODTATT_MEN_ANNULLERT), frigjøre
#   plassen til ventelisten? I dag frigjøres den aldri. Hva hvis søkeren allerede er opprettet som student?
#   (Innen svarfristen kan søkeren endre ja til nei, se 13 Søknad og saksbehandling/01 Søknad/svare_på_tilbud.feature.)
# - Skal opptaksforvalter kunne overstyre et enkelt resultat manuelt, for eksempel gi ett tilbud uten ny plasstildeling?
#   I dag krever alt en ny plasstildeling. Tilbudsgaranti er foreløpig eneste utvei.
# - Må søkeren svare på ventelisteplass for å beholde den, eller står søkeren på ventelisten automatisk?
#   (Søkeren kan svare på ventelisteplass, se svare_på_tilbud.feature. Om søkeren må, er ikke avklart.)
# - Saksbehandler kan i koden svare på vegne av søkeren, og søkeren får da melding (levert, se
#   13 Søknad og saksbehandling/01 Søknad/mine_meldinger.feature). Skal det stå som eget scenario her, og hvem kan gjøre det?
# - Alle tilbud i søknaden besvares samlet (levert, se svare_på_tilbud.feature). Skal det være slik? (Avklart
#   2026-10-14: søkeren kan bare takke ja til så mange tilbud som opptaket tillater.)
# - Svarfristen er felles for plasstildelingsrunden. Trengs individuell svarfrist per søker eller per tilbud?
# - At søkeren ikke svarte innen fristen, blir aldri lagret. Koden regner det ut hver gang svaret leses,
#   og det finnes ingen «lukk plasstildelingsrunden». Skal svaret lagres når fristen er ute?

# Kjente feil i koden, følges opp i Jira. Dette er ikke åpne spørsmål om kravet:
#   TAKE-284: svar knyttes til plasstildelingsrunde på løpenummer uten rundetype. Med én plasstildelingsrunde
#   per rundetype må svaret knyttes til rundetypen.
#   TAKE-281: fristsjekken bruker applikasjonsklokke i stedet for databaseklokke.
