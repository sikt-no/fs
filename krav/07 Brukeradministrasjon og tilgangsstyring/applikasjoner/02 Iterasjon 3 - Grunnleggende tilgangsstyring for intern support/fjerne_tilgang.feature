# language: no
# GitHub: #445, #451
@BRU-APP-API-008 @must @planned
Egenskap: Fjerne tilgang fra applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å fjerne en tilgang fra en applikasjon
  slik at applikasjonen mister tilgang til data den ikke lenger skal ha.

  # Krav fra Confluence: K7 Fjerne rolle fra API-bruker, K14 Fjerne rolle fra API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg ser tilgangslisten applikasjonen har

  Regel: En fjerning krever en eksplisitt bekreftelse

    Scenario: Bekreftelsesdialog vises før enkelt-tilgang fjernes
      Gitt applikasjonen har en tilgang jeg har rettighet til å fjerne
      Når jeg velger å fjerne tilgangen
      Så vises en bekreftelsesdialog som viser tilgang og miljø som skal fjernes

    Scenario: Bekrefte fjerning av en enkelt-tilgang
      Gitt jeg har igangsatt fjerning av én tilgang
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger den tilgangen i det miljøet

    Scenario: Avbryte fjerning
      Gitt jeg har igangsatt fjerning av én eller flere tilganger
      Når jeg avbryter
      Så er ingen endringer gjort på applikasjonens tilganger

  Regel: Flere tilganger i ett miljø kan fjernes samtidig

    Scenario: Bekreftelsesdialog for bulk-fjerning lister alle valgte tilganger
      Gitt applikasjonen har flere tilganger jeg har rettighet til å fjerne i et miljø
      Når jeg velger flere av disse tilgangene innenfor det samme miljøet og velger å fjerne dem
      Så vises en bekreftelsesdialog som lister alle valgte tilganger og miljøet

    Scenario: Bekrefte bulk-fjerning
      Gitt jeg har igangsatt bulk-fjerning av tilganger i ett miljø
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger noen av de valgte tilgangene i det valgte miljøet

  Regel: Bruker kan kun fjerne tilganger de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for tilganger uten rettighet
      Gitt applikasjonen har en tilgang jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den tilgangen ikke tilgjengelig
