# language: no
# ============================================================
# IKKE-FUNKSJONELLE KRAV (felleskrav for offentlige sider)
# ============================================================

Egenskap: IFK-001 Ikke-funksjonelle krav for offentlig visning
  Som produktleder for utdanningsregisteret 
  ønsker jeg at løsningen oppfyller kvalitetsstandarder
  slik at alle brukere får en god og sikker opplevelse.

  Prioritet: Må ha

  Regel: All informasjon skal være tilgjengelig uten innlogging

    Scenario: Uinnlogget bruker har tilgang til alle offentlige sider
      Gitt at jeg ikke er innlogget
      Når jeg besøker forside, utdanningsoversikt, organisasjonsoversikt eller søkesiden
      Så skal jeg få tilgang uten å bli bedt om å logge inn

  Regel: Grensesnittet skal oppfylle WCAG 2.1 nivå AA

    Scenario: Alle interaktive elementer er tilgjengelige via tastatur
      Gitt at jeg navigerer kun med tastatur
      Så skal jeg kunne nå og aktivere alle lenker, knapper og filtre
      Og fokusindikator skal være tydelig synlig

    Scenario: Kontrast mellom tekst og bakgrunn er tilstrekkelig
      Gitt at grensesnittet vises i normalvisning
      Så skal kontrasten mellom all tekst og bakgrunn være minst 4.5:1
      Og kontrasten for store tekster skal være minst 3:1

  Regel: Data skal alltid hentes direkte fra kilden

    Scenario: Visningen speiler alltid gjeldende data i utdanningsregisteret
      Gitt at en utdanning nettopp er oppdatert i registeret
      Når jeg laster utdanningsoversikten på nytt
      Så skal oppdatert informasjon vises uten manuell synkronisering

  Regel: Klarspråk i grensesnittet

    Scenario: Språket i grensesnittet skal bruke klarspråk og oppdaterte begreper fra fs.sikt.no
      Gitt at det er tekst i grensesnittet
      Når jeg leser tekst 
      Så følger den våre regler for klarspråk og begrepsbruk definert på fs.sikt.no

  Regel: Grensesnittet skal fungere på mobile enheter

    Scenario: Oversikter er lesbare på mobilskjerm
      Gitt at jeg bruker en skjerm med bredde 375px
      Når jeg åpner utdanningsoversikten
      Så skal innholdet vises uten horisontal scrolling
      Og all tekst skal være lesbar uten zooming

    Scenario: Touch-interaksjon fungerer på mobile enheter
      Gitt at jeg bruker en touch-enhet
      Når jeg navigerer grensesnittet
      Så skal alle klikkbare elementer ha minst 44x44px touch-område
      Og swipe-gester skal fungere for scrolling i lister