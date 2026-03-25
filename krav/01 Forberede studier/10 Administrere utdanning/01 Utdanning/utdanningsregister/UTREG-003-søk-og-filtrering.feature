# language: no
# ============================================================
# FEATURE 3 – SØK OG FILTRERING
# ============================================================

Egenskap: UTREG-003 Søk og filtrering i utdanningsregisteret
  Som en besøkende 
  ønsker jeg å kunne søke og filtrere i utdanninger og organisasjoner
  slik at jeg raskt finner relevant informasjon.

  Prioritet: Må ha

  Regel: Fritekst-søk skal hjelpe brukeren å finne det de leter etter

    Scenario: Bruker søker på navn og får treff
      Gitt at jeg er på utdanningsoversikten
      Når jeg skriver "sykepleie" i søkefeltet
      Så skal listen filtreres til å vise utdanninger der navn inneholder "sykepleie"

    Scenario: Bruker søker på lokal kode
      Gitt at jeg er på utdanningsoversikten
      Når jeg skriver "BSYP" i søkefeltet
      Så skal listen filtreres til å vise utdanninger med lokal kode som matcher "BSYP"

    Scenario: Bruker søker på organisasjonsnavn
      Gitt at jeg er på organisasjonsoversikten
      Når jeg skriver "OsloMet" i søkefeltet
      Så skal listen filtreres til å vise organisasjoner der navn inneholder "OsloMet"

    Scenario: Ingen søketreff gir tydelig melding
      Gitt at jeg søker på en verdi som ikke finnes i registeret
      Når søket utføres
      Så skal jeg se meldingen "Ingen treff"

  Regel: Filtrering på organisasjon skal avgrense utdanningsvisningen

    Scenario: Bruker filtrerer utdanninger på ett lærested
      Gitt at jeg er på utdanningsoversikten
      Når jeg velger "Universitetet i Oslo" som lærested-filter
      Så skal kun utdanninger tilbudt av Universitetet i Oslo vises

    Scenario: Bruker filtrerer på flere læresteder samtidig
      Gitt at jeg er på utdanningsoversikten
      Når jeg velger "NTNU" og "UiB" som lærested-filtre
      Så skal utdanninger tilbudt av NTNU eller UiB vises

    Scenario: Aktivt filter er synlig og kan fjernes
      Gitt at jeg har valgt "UiT" som lærested-filter
      Så skal filteret vises tydelig som aktivt
      Og jeg skal kunne fjerne filteret med ett klikk

  Regel: Filtrering på lærestedstype skal fungere som flervalg

    Scenario: Bruker filtrerer på én lærestedstype
      Gitt at jeg er på utdanningsoversikten
      Når jeg velger "Fagskole" som lærestedstype-filter
      Så skal kun utdanninger fra fagskoler vises

    Scenario: Tilgjengelige lærestedstyper hentes fra registeret
      Gitt at jeg åpner lærestedstype-filteret
      Så skal valgmulighetene reflektere de faktiske lærestedstypene som finnes i registeret

  Regel: Filtrering på sektor skal fungere som flervalg

    Scenario: Bruker filtrerer på statlig sektor
      Gitt at jeg er på organisasjonsoversikten
      Når jeg velger "Statlig" som sektor-filter
      Så skal kun statlige organisasjoner vises

    Scenario: Bruker kombinerer sektor-filter med lærestedstype-filter
      Gitt at jeg er på utdanningsoversikten
      Når jeg velger "Privat" som sektor og "Høyskole" som lærestedstype
      Så skal kun utdanninger fra private høyskoler vises

  Regel: Filtrering på akkrediteringsrett

    Scenario: Bruker filtrerer på organisasjoner med akkrediteringsrett
      Gitt at jeg er på organisasjonsoversikten
      Når jeg velger "Med akkrediteringsrett" i akkrediteringsrett-filteret
      Så skal kun organisasjoner med akkrediteringsrett vises

    Scenario: Bruker filtrerer på organisasjoner uten akkrediteringsrett
      Gitt at jeg er på organisasjonsoversikten
      Når jeg velger "Uten akkrediteringsrett" i akkrediteringsrett-filteret
      Så skal kun organisasjoner uten akkrediteringsrett vises

    Scenario: Standardvisning inkluderer alle organisasjoner uavhengig av akkrediteringsrett
      Gitt at ingen akkrediteringsrett-filter er valgt
      Så skal organisasjoner både med og uten akkrediteringsrett vises

  Regel: Filtrering på aktiv / historisk organisasjon

    Scenario: Standardvisning viser kun aktive organisasjoner
      Gitt at jeg navigerer til organisasjonsoversikten uten å ha satt noe filter
      Så skal kun aktive organisasjoner vises

    Scenario: Bruker velger å inkludere historiske organisasjoner
      Gitt at jeg er på organisasjonsoversikten
      Når jeg aktiverer "Vis historiske organisasjoner"
      Så skal også inaktive/historiske organisasjoner vises i listen

    Scenario: Historiske organisasjoner er visuelt markert
      Gitt at historiske organisasjoner vises i listen
      Så skal de være tydelig merket "Historisk" 
      Og er visuelt nedtonet