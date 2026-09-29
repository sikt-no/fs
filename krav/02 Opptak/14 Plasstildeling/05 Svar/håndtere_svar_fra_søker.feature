# language: no
# GitHub: #587
@OPT-PLA-SVA-001 @must @draft
Egenskap: Håndtere svar fra søker
  Som søker
  ønsker jeg å svare på tilbud og ventelisteplass innen svarfristen
  slik at jeg sikrer meg studieplassen jeg vil ha.

  # Kilde: tasks/opptak/plasstildeling/design.md (prinsipp 2, informasjonsarv, avklaring 4, 5 og 11),
  # oppgave.md (oppgave 9) og Confluence «2026-09-08 Raffinering plasstildeling» (oppgave 8).
  # Svarene behandles i neste plasstildeling i opptaket. Det gis ikke automatisk nye tilbud ved
  # nei-svar mellom rundene (oppgave 10 i oppgave.md, utenfor scope 2027).
  # Status i kode: delvis. Ja/nei virker. Trukket ja-svar og manuell overstyring mangler.

  Bakgrunn:
    Gitt at søkeren "Kari Nordmann" er innlogget i Min kompetanse
    Og at søkeren har fått tilbud på "Sykepleie, høst 2027" i "Hovedrunde" med svarfrist "2027-07-20 23:59"

  Regel: Søkeren svarer ja eller nei på tilbudet innen svarfristen

    Scenario: Takke ja til tilbud
      Når søkeren takker ja til tilbudet innen "2027-07-20 23:59"
      Så beholder søkeren tilbudet ut opptaket

    Scenario: Takke nei til tilbud
      Når søkeren takker nei til tilbudet
      Så blir plassen ledig i neste plasstildeling i opptaket

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
      Når plasstildelingen i runden "Etterfylling" gjennomføres
      Så får søkeren ikke bortfall på "Vernepleie, høst 2027"

  Regel: Søker med flere tilbud må velge ett

    Scenario: Velge mellom to tilbud i etterfylling
      Gitt at søkeren har tilbud på både "Sykepleie, høst 2027" og "Vernepleie, høst 2027" etter "Etterfylling"
      Når søkeren takker ja til tilbudet på "Sykepleie, høst 2027"
      Så blir tilbudet på "Vernepleie, høst 2027" ledig i neste plasstildeling

# ÅPNE SPØRSMÅL:
# - Skal et nei-svar frigjøre plassen før svarfristen er ute? I dag står plassen reservert til fristen.
# - Skal en søker som takker ja og senere trekker seg frigjøre plassen til ventelisten? I dag frigjøres den aldri.
#   Hva hvis søkeren allerede er opprettet som student?
# - Når en søker har både et tilbud og et kansellert resultat på samme utdanningstilbud, hva skal søkeren se?
# - Skal opptaksforvalter kunne overstyre et enkelt resultat manuelt, for eksempel gi ett tilbud uten ny plasstildeling?
#   I dag krever alt en ny plasstildeling. Tilbudsgaranti er foreløpig eneste utvei.
# - Må søkeren svare på ventelisteplass for å beholde den, eller står søkeren på ventelisten automatisk?
# - Svar knyttes i dag til runde på løpenummer uten rundetype (mistenkt feil i oppgave.md).
#   Med én runde per rundetype må svaret knyttes til rundetypen.
# - Fristsjekken bruker applikasjonsklokke i stedet for databaseklokke (mistenkt feil i oppgave.md).
# - Hører selve svarflyten i Min kompetanse hjemme her, eller under 13 Søknad og saksbehandling?
