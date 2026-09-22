# language: no
# ============================================================
# FEATURE 4 – VISNING AV ORGANISASJONER MED TILHØRENDE UTDANNINGER
# ============================================================

Egenskap: UTREG-004 Oversikt og detaljer for organisasjoner
  Som en besøkende 
  ønsker jeg å se informasjon om hvilke læresteder eller andre utdanningstilbydere som har utdanninger i registeret 
  slik at jeg kan finne hvilke læresteder som tilbyr ulike utdanninger.

  Prioritet: Bør ha

  Regel: Oversikten skal vise nøkkelinformasjon om alle organisasjoner

    Scenario: Bruker ser organisasjonsoversikt med nødvendige felt
      Gitt at jeg navigerer til organisasjonsoversikten
      Når oversikten lastes
      Så skal jeg se følgende informasjon per organisasjon:
        | Felt                           |
        | Navn                           |
        | Lærestedstype                  |
        | Sektor                         |
        | Antall registrerte utdanninger |
        | Lokalisering (by, land)        |

    Scenario: Antall utdanninger er alltid oppdatert
      Gitt at en organisasjon har 42 registrerte utdanninger i registeret
      Når jeg ser organisasjonen i oversikten
      Så skal feltet "Antall registrerte utdanninger" vise "42"

  Regel: Navigering til en organisasjon skal inkludere dens utdanninger

    Scenario: Detaljsiden viser organisasjonsinformasjon og liste over utdanninger
      Gitt at jeg åpner detaljsiden for en organisasjon
      Så skal jeg se alle feltene fra oversikten
      Og jeg skal se en liste over organisasjonens utdanninger med navn, status og utdanningsnivå, utdanningstype, studiepoeng, når utdanningen ble først og ev. sist tilbudt, samt lokal kode 
      Og jeg skal kunne navigere til utdanningens detaljside