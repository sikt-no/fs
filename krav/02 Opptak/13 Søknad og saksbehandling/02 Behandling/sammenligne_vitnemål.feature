# language: no
# GitHub: #611
#
# Leveranse L5 av seks i initiativet #607 Vitnemålsbehandling. Skilt ut fra
# vitnemålsbehandling.feature 08.10.2026. Kilder, bakgrunn, avgrensninger og
# oversikten over leveransene står i vitnemålsbehandling.md i samme mappe.
#
# Bygger på L1. Selvstendig — ingen annen leveranse er avhengig av den, og
# designet er det minst modne i initiativet (Confluence har «1. versjon av
# design»).
#
@OPT-BEH-BEH-009 @must @draft
Egenskap: Sammenligne vitnemål
  Som saksbehandler i opptak
  ønsker jeg å sammenligne søkerens vitnemål med hverandre
  slik at jeg raskt ser hva som skiller dem før jeg velger grunnlag.

  Et vitnemål har typisk rundt 20 fag, og forskjellen mellom to vitnemål er
  ofte to–tre av dem. Sammenligningen stiller vitnemålene opp ved siden av
  hverandre, så saksbehandleren slipper å lete etter forskjellene selv.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg kan se og endre søknadsbehandling for organisasjonen som behandler saken
    Og jeg er inne på søknaden til en søker

  Regel: Vitnemål kan sammenlignes

    Scenario: Sammenligne vitnemål
      Gitt søkeren har flere vitnemål som er relevante for opptaket
      Når jeg velger å sammenligne vitnemålene
      Så vises vitnemålene ved siden av hverandre
      Og fagene er stilt opp slik at samme fag står på samme rad
      # AVKLART 21.09.2026: kravet setter ingen øvre grense for antall
      # vitnemål som kan sammenlignes — alle som er relevante for opptaket
      # skal kunne stilles opp. Antallet er allerede begrenset av
      # relevansregelen i vise_elektroniske_vitnemål.feature.
      #
      # Confluence sier «Bredde på skjerm avgjør antall vitnemål det er mulig
      # å sammenlikne». Det er en UI-beskrivelse, ikke en forretningsregel, og
      # hører i sammenligne_vitnemål.design.md.

    Scenario: Se kun fagene som skiller vitnemålene
      Gitt jeg sammenligner flere vitnemål
      Når jeg velger å se kun forskjellene
      Så vises bare fagene der vitnemålene er ulike
      # Verifisert i FS-klienten: avkryssingsboksen «Vis kun endringer i
      # forhold til valgt vitnemål» gjør nettopp dette. Videreføres fordi et
      # vitnemål typisk har rundt 20 fag, og forskjellen mellom to vitnemål
      # ofte er to–tre av dem.
