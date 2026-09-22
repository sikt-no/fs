# language: no
# ============================================================
# FEATURE 2 – VISNING AV UTDANNINGER
# ============================================================

Egenskap: UTREG-002 Oversikt og detaljer for utdanninger
  Som en besøkende 
  ønsker jeg å se detaljert informasjon om utdanninger 
  slik at jeg kan finne relevant informasjon om utdanninger som tilbys i Norge.

  Prioritet: Må ha

  Regel: Oversikten skal vise nøkkelinformasjon om alle utdanninger

    Scenario: Bruker ser utdanningsoversikt med nødvendige felt
      Gitt at jeg navigerer til utdanningsoversikten
      Når oversikten lastes
      Så skal jeg se følgende informasjon per utdanning:
        | Felt                 |
        | Navn                 |
        | Lokal kode           |
        | Utdanningsnivå (NKR) |
        | Utdanningsområde     |
        | Omfang               |
        | Varighet             |
        | Utdanningstype       |
        | Heltid / deltid      |
        | Tilbys fra           |
        | ID i registeret      |

    Scenario: Tilbys til vises kun når siste termin eller sluttdato er registrert
      Gitt at jeg ser på en utdanning uten registrert slutt 
      Så skal feltet "Tilbys til" ikke vises

    Scenario: Tilbys til vises når registrert
      Gitt at jeg ser på en utdanning med registrert sluttermin "VÅR 2029" 
      Så skal feltet "Tilbys til" vises med verdien "VÅR 2029"

  Regel: Aktiv/inaktiv-status skal være tydelig for utdanning

    Scenario: Aktiv utdanning vises som aktiv
      Gitt at en utdanning ikke har registrert sluttdato, eller sluttdato er frem i tid
      Når jeg ser utdanningen i oversikten
      Så skal statusen vises som "Aktiv"

    Scenario: Utgått utdanning vises som inaktiv
      Gitt at en utdanning har sluttdato som er passert
      Når jeg ser utdanningen i oversikten
      Så skal statusen vises som "Utgått"
      Og utdanningen skal skilles visuelt fra aktive utdanninger

  Regel: Beskrivelse av utdanningen vises kun når den finnes

    Scenario: Beskrivelse av utdanning vises på detaljside når den er registrert
      Gitt at en utdanning har en registrert beskrivelse
      Når jeg åpner detaljsiden for utdanningen
      Så skal beskrivelsen vises som ren tekst uten HTML-koding

    Scenario: Ingen beskrivelse-felt vises når beskrivelse mangler
      Gitt at en utdanning ikke har registrert beskrivelse
      Når jeg åpner detaljsiden for utdanningen
      Så skal beskrivelsesfeltet vises med teksten "Ingen beskrivelse registrert"

  Regel: Tilbydende organisasjon og sted skal vises

    Scenario: Organisasjonsnavn vises 
      Gitt at jeg ser på detaljsiden for en utdanning
      Så skal navnet på tilbydende organisasjon vises

    Scenario: Studieprogramkull vises med sted og periode
      Gitt at en utdanning har registrerte studieprogramkull
      Når jeg åpner detaljsiden for utdanningen
      Så skal hvert studieprogramkull vises med sted (stedsnavn) og starttermin (eller startdato)

    Scenario: Ingen kull registrert
      Gitt at en utdanning ikke har registrerte studieprogramkull
      Når jeg åpner detaljsiden for utdanningen
      Så skal det vises en melding om at ingen kull er registrert