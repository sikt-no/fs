# language: no
# GitHub: #445, #451
@BRU-APP-API-008 @must @planned
Egenskap: Fjerne rolle fra applikasjon
  Som bruker med applikasjonsadministrator-rollen
  ønsker jeg å fjerne en rolle fra en applikasjon
  slik at applikasjonen mister tilgang til data den ikke lenger skal ha.

  # Krav fra Confluence: K7 Fjerne rolle fra API-bruker, K14 Fjerne rolle fra API-bruker (selvbetjening)

  Bakgrunn:
    Gitt jeg er på detaljsiden for en applikasjon
    Og jeg ser listen over roller applikasjonen har

  Regel: En fjerning krever en eksplisitt bekreftelse

    Scenario: Bekreftelsesdialog vises før enkeltrolle fjernes
      Gitt applikasjonen har en rolle jeg har rettighet til å fjerne
      Når jeg velger å fjerne rollen
      Så vises en bekreftelsesdialog som viser rolle og miljø som skal fjernes

    Scenario: Bekrefte fjerning av en enkeltrolle
      Gitt jeg har igangsatt fjerning av én rolle
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger den rollen i det miljøet

    Scenario: Avbryte fjerning
      Gitt jeg har igangsatt fjerning av én eller flere roller
      Når jeg avbryter
      Så er ingen endringer gjort på applikasjonens roller

  Regel: Flere roller i ett miljø kan fjernes samtidig

    Scenario: Bekreftelsesdialog for bulk-fjerning lister alle valgte roller
      Gitt applikasjonen har flere roller jeg har rettighet til å fjerne i et miljø
      Når jeg velger flere av disse rollene innenfor det samme miljøet og velger å fjerne dem
      Så vises en bekreftelsesdialog som lister alle valgte roller og miljøet

    Scenario: Bekrefte bulk-fjerning
      Gitt jeg har igangsatt bulk-fjerning av roller i ett miljø
      Når jeg bekrefter fjerningen
      Så har applikasjonen ikke lenger noen av de valgte rollene i det valgte miljøet

  Regel: Bruker kan kun fjerne roller de har rettighet til å fjerne

    Scenario: Fjerning er ikke tilgjengelig for roller uten rettighet
      Gitt applikasjonen har en rolle jeg ikke har rettighet til å fjerne
      Så er muligheten til å fjerne den rollen ikke tilgjengelig
