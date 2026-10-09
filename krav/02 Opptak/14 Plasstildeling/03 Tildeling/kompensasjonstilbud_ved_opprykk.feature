# language: no
# GitHub: #584
@OPT-PLA-TIL-003 @must @draft
Egenskap: Kompensasjonstilbud ved opprykk i supplering
  Som opptaksforvalter
  ønsker jeg at plasser som frigjøres ved opprykk gis videre automatisk i suppleringsrunder
  slik at kapasiteten på utdanningstilbudet utnyttes best mulig uten manuell oppfølging.

  # Kilde: tasks/opptak/plasstildeling/design.md (rundetyper, informasjonsarv, avklaring 3 og 8) og
  # oppgave.md (oppgave 6).
  # Kompensasjonstilbud gjelder bare rundetype «Supplering». Antall tilbud som skal gis settes per
  # plasstildelingsrunde (se 02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature).
  # Det finnes bare én suppleringslogikk. Den historiske forskjellen mellom UHG og HYU (med og uten
  # kompensasjon) videreføres ikke.
  # Status i kode: gjenstår.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" har en publisert plasstildeling i "Hovedrunde"
    Og at opptaket har plasstildelingsrunden "Suppleringsrunde" med rundetype "Supplering"
    Og at antall tilbud som skal gis i "Sykepleie, høst 2027" i "Suppleringsrunde" er 10

  Regel: En plass som frigjøres ved opprykk gis til neste på ventelisten

    Scenario: Søker rykker opp til høyere prioritet
      Gitt at søkeren "Kari Nordmann" har tilbud på "Sykepleie, høst 2027" som prioritet 2
      Og at søkeren "Ola Nordmann" står som nummer 1 på ventelisten til "Sykepleie, høst 2027"
      Når plasstildelingen i "Suppleringsrunde" gir "Kari Nordmann" tilbud på prioritet 1
      Så får "Ola Nordmann" tilbud på "Sykepleie, høst 2027"

    Scenario: Nei-svar frigjør plass til kompensasjonstilbud
      Gitt at søkeren "Kari Nordmann" svarte nei på tilbudet på "Sykepleie, høst 2027" i "Hovedrunde"
      Og at svarfristen i "Hovedrunde" er ute
      Og at søkeren "Ola Nordmann" står som nummer 1 på ventelisten
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så får "Ola Nordmann" tilbud på "Sykepleie, høst 2027"

  Regel: Kompensasjonstilbud teller mot antall tilbud som skal gis i plasstildelingsrunden

    # AVKLART 2026-10-08: Kompensasjonstilbud kommer ikke i tillegg.
    Scenario: Antall tilbud som skal gis i plasstildelingsrunden er nådd
      Gitt at plasstildelingen i "Suppleringsrunde" har gitt 10 nye tilbud på "Sykepleie, høst 2027"
      Og at en søker med tilbud rykker opp til en høyere prioritet
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så gis det ikke kompensasjonstilbud på "Sykepleie, høst 2027"

  Regel: Kompensasjonstilbud gis bare i supplering

    Scenariomal: Ingen kompensasjonstilbud i andre rundetyper
      Gitt at plasstildelingsrunden har rundetype "<rundetype>"
      Og at en søker med tilbud rykker opp til en høyere prioritet
      Når plasstildelingen gjennomføres
      Så gis det ikke automatisk nytt tilbud på plassen som ble frigjort

      # AVKLART 2026-10-07, endret 2026-10-08: Ledige studieplasser er en egenskap ved plasstildelingsrunden,
      # ikke en egen rundetype.
      Eksempler:
        | rundetype        |
        | Hovedtildeling   |
        | Etterfylling     |

# ÅPNE SPØRSMÅL:
# - Skal en søker som har takket ja og senere trekker seg frigjøre plassen til kompensasjonstilbud? I dag frigjøres den aldri.
# - Skal det finnes en «topp opp til ønsket nivå»-funksjon de første ukene, i stedet for manuell overvåking?
#   Lærestedene har bedt om det (design.md avklaring 9).
# - Automatiske nye tilbud ved nei-svar utenfor plasstildelingsrundene er utenfor scope for 2027 (oppgave.md, oppgave 10).
# - Kompensasjonstilbud innenfor samme kjøring: hvis to søkere rykker opp i samme plasstildeling,
#   kan plassene deres gis videre i samme kjøring (flere ledd)?
# - I koden gis en plass som frigjøres ved opprykk, videre bare når antall tilbud ikke allerede er nådd.
#   Koden kan øke tallet ved opprykk, men det brukes aldri (A10 i «Plasstildelingsløpet i Opptak»).
