# language: no
# GitHub: #512
#
# KILDER
#
# - GitHub #512 «Saksbehandler kan sette tilbudsgaranti på søknadalternativ».
# - Jira STEK-241 «Tilbudsgaranti» med STEK-262 (hvem som kan sette hvilken
#   tilbudsgaranti), STEK-263 (plasstildelingen henter tilbudsgarantiene fra
#   saksbehandlingen) og STEK-270 (tilbyder og opptaksforvalter kan gi tilbudsgaranti).
# - Confluence PFS 3885400152 «Tilbudsgaranti» (dagens løsning i UHG, HYU/FSU og
#   lokale opptak) og PFS 5086576688 «2026-10-07 Status tilbudsgarantier og Tidlig
#   opptak».
#
# AVGRENSNING
#
# - Tidlig opptak er én type tilbudsgaranti. Gjennomføringen av tidligopptaket står i
#   gi_tilbudsgaranti_ved_tidlig_opptak.feature (OPT-BEH-BEH-007, STEK-188).
# - Hvordan plasstildelingen gir tilbud, og hvilken utdanningskvote tilbudsgarantien
#   tas fra, står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature
#   og opptaksinnstillinger_utdanningstilbud.feature.
# - Ikke med nå (kan bli egne krav senere):
#   - Opptaksforvalter forvalter tilbudsgarantitypene i opptaket (STEK-349). Typene
#     legges inn i databasen per opptak for 2027.
#   - Søkeren ser reservert studieplass (STEK-553, on hold).
#   - Behandler overstyrer hvilken utdanningskvote tilbudsgarantien tas fra (STEK-270).
#
# Regelen «Behandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt» og
# scenarioene om at tilbudsgarantien følger søknadsalternativet, er flyttet hit fra
# OPT-BEH-BEH-007 14.10.2026. Der var de avklart og hentet inn i oppgaven tidlig-opptak.
# Scenarioene i 007 om at tilbudsgarantien gir tilbud i hovedopptaket, er ikke flyttet,
# fordi regelen «Søker med tilbudsgaranti får tilbud uavhengig av poengsum» i
# gjennomføre_plasstildeling.feature dekker dem.
#
# AVKLART
#
# - Tilbudsgaranti settes alltid manuelt, etter en individuell vurdering (#512).
#   Unntaket er tidligopptaket (OPT-BEH-BEH-007).
# - Tre roller kan sette tilbudsgaranti manuelt, hver for seg og med sitt eget sett
#   med tilbudsgarantityper (domeneekspert 08.10.2026, STEK-262, STEK-270):
#   - B-rolle: saksbehandler ved organisasjonen som behandler saken.
#     Eksempler fra dagens løsning: etter klage, reservert plass.
#   - T-rolle: tilbyder, organisasjonen som tilbyr utdanningstilbudet.
#     Eksempler: særskilt vurdering, tidligsvar (forhåndsopptak).
#   - F-rolle: opptaksforvalter ved organisasjonen som eier opptaket.
#     Eksempler: etter telefonsamtale, forhåndsløfte.
#   Hvilke typer en rolle kan bruke, står på tilbudsgarantitypen i opptakets kodeverk.
# - Kodeverket for tilbudsgarantityper hører til ett opptak. Opptakene har hver sine
#   typer, og de påvirker ikke hverandre, verken samtidig eller over tid (14.10.2026).
#   En type fra et tidligere opptak vises derfor i sakene i det opptaket.
# - Plasstildelingen henter tilbudsgarantiene fra saksbehandlingen (STEK-263, 08.10.2026).
# - Tilbudsgarantien følger søknadsalternativet, uansett prioritet. Den faller ikke bort
#   når søkeren flytter søknadsalternativet ned, eller når et nytt søknadsalternativ legges
#   over. Prioriteten avgjør hvilket tilbud søkeren får, ikke om tilbudsgarantien gjelder.
#   Den faller bort når søkeren fjerner søknadsalternativet eller trekker søknaden, og
#   gjelder igjen, uansett prioritet, når søknadsalternativet legges inn igjen før
#   søknadsfristen (avklart for tidlig opptak 08.10.2026, i OPT-BEH-BEH-007, og stemmer
#   med koden).
#
@OPT-BEH-BEH-010 @must @planned
Egenskap: Gi tilbudsgaranti
  Som behandler
  ønsker jeg å gi søkeren tilbudsgaranti på et søknadsalternativ etter en individuell vurdering
  slik at søkeren får tilbud på søknadsalternativet uavhengig av den ordinære rangeringen.

  Regel: Behandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt

    Scenariomal: Sette tilbudsgaranti i feltet for rollen
      Gitt behandleren har <rolle>
      Og tilbudsgarantitypen "<type>" kan brukes av <rolle>
      Når behandleren setter tilbudsgarantien "<type>" på "Sykepleie, høst 2027"
      Så har søkeren tilbudsgarantien "<type>" fra <rolle> på "Sykepleie, høst 2027"

      Eksempler:
        | rolle   | type                                     |
        | B-rolle | Tilbudsgaranti innvilges etter klage     |
        | T-rolle | Tilbudsgaranti, særskilt vurdering       |
        | F-rolle | Tilbudsgaranti gitt etter telefonsamtale |

    Scenario: Bare tilbudsgarantitypene for rollen kan velges
      Gitt behandleren har B-rolle
      Og tilbudsgarantitypen "Tilbudsgaranti, særskilt vurdering" kan bare brukes av T-rolle
      Når behandleren skal sette tilbudsgaranti på "Sykepleie, høst 2027"
      Så kan ikke behandleren velge "Tilbudsgaranti, særskilt vurdering"

    Scenario: Behandler ser ikke muligheten til å sette tilbudsgaranti for en rolle behandleren ikke har
      Gitt behandleren har B-rolle
      Og behandleren har ikke T-rolle eller F-rolle
      Når behandleren ser på "Sykepleie, høst 2027" i saken
      Så ser behandleren muligheten til å sette tilbudsgaranti fra B-rolle
      Men behandleren ser ikke muligheten til å sette tilbudsgaranti fra T-rolle eller F-rolle

    Scenario: Se tilbudsgarantiene fra alle rollene
      Gitt søkeren har følgende tilbudsgarantier på "Sykepleie, høst 2027":
        | rolle   | type                                     |
        | B-rolle | Tilbudsgaranti innvilges etter klage     |
        | F-rolle | Tilbudsgaranti gitt etter telefonsamtale |
      Når behandleren ser på "Sykepleie, høst 2027" i saken
      Så ser behandleren begge tilbudsgarantiene og hvilken rolle som har satt dem

    Scenario: Sette tilbudsgaranti når søknaden ikke kan poengberegnes
      Gitt behandleren har T-rolle
      Og søknaden kan ikke poengberegnes
      Når behandleren setter tilbudsgaranti på "Sykepleie, høst 2027"
      Så har søkeren tilbudsgaranti på "Sykepleie, høst 2027"

  Regel: Tilbudsgarantien kan endres og fjernes av rollen som satte den

    Scenario: Endre tilbudsgaranti
      Gitt behandleren har B-rolle
      Og søkeren har tilbudsgarantien "Tilbudsgaranti innvilges etter klage" fra B-rolle på "Sykepleie, høst 2027"
      Når behandleren endrer tilbudsgarantien fra B-rolle på "Sykepleie, høst 2027" til "Reservert studieplass"
      Så har søkeren tilbudsgarantien "Reservert studieplass" fra B-rolle på "Sykepleie, høst 2027"

    Scenario: Fjerne tilbudsgaranti
      Gitt behandleren har B-rolle
      Og søkeren har tilbudsgarantien "Tilbudsgaranti innvilges etter klage" fra B-rolle på "Sykepleie, høst 2027"
      Når behandleren fjerner tilbudsgarantien fra B-rolle på "Sykepleie, høst 2027"
      Så har søkeren ikke tilbudsgaranti fra B-rolle på "Sykepleie, høst 2027"

    Scenario: Tilbudsgarantien fra en annen rolle blir stående
      Gitt behandleren har B-rolle
      Og søkeren har tilbudsgarantien "Tilbudsgaranti innvilges etter klage" fra B-rolle på "Sykepleie, høst 2027"
      Og søkeren har tilbudsgarantien "Tilbudsgaranti gitt etter telefonsamtale" fra F-rolle på "Sykepleie, høst 2027"
      Når behandleren fjerner tilbudsgarantien fra B-rolle på "Sykepleie, høst 2027"
      Så har søkeren fortsatt tilbudsgarantien "Tilbudsgaranti gitt etter telefonsamtale" fra F-rolle på "Sykepleie, høst 2027"

    Scenario: Behandler ser ikke muligheten til å endre tilbudsgarantien fra en annen rolle
      Gitt behandleren har F-rolle
      Og behandleren har ikke B-rolle
      Og søkeren har tilbudsgarantien "Tilbudsgaranti innvilges etter klage" fra B-rolle på "Sykepleie, høst 2027"
      Når behandleren ser på "Sykepleie, høst 2027" i saken
      Så ser ikke behandleren muligheten til å endre eller fjerne tilbudsgarantien fra B-rolle

  Regel: Tilbudsgarantitypene hører til opptaket

    Scenario: Bare tilbudsgarantitypene i opptaket kan velges
      Gitt "Sykepleie, høst 2027" er med i opptaket "Samordna opptak 2027"
      Og tilbudsgarantitypen "Reservert studieplass" finnes bare i opptaket "Samordna opptak 2026"
      Når behandleren skal sette tilbudsgaranti på "Sykepleie, høst 2027"
      Så kan ikke behandleren velge "Reservert studieplass"

  # En endring vises som at tilbudsgarantien er satt på nytt, med den nye typen
  # (avklart med Daniel 21.10.2026, som i STEK-559).
  Regel: Endringer i tilbudsgarantien kan spores

    Scenario: Se hvem som har satt tilbudsgarantien
      Gitt behandleren Kari Nordmann har B-rolle
      Når Kari Nordmann setter tilbudsgarantien fra B-rolle på "Sykepleie, høst 2027"
      Så ser behandlerne av saken at Kari Nordmann har satt tilbudsgarantien fra B-rolle på "Sykepleie, høst 2027"
      Og behandlerne av saken ser når tilbudsgarantien ble satt

    Scenario: Se hvem som har fjernet tilbudsgarantien
      Gitt behandleren Kari Nordmann har B-rolle
      Og søkeren har tilbudsgaranti fra B-rolle på "Sykepleie, høst 2027"
      Når Kari Nordmann fjerner tilbudsgarantien fra B-rolle på "Sykepleie, høst 2027"
      Så ser behandlerne av saken at Kari Nordmann har fjernet tilbudsgarantien fra B-rolle på "Sykepleie, høst 2027"
      Og behandlerne av saken ser når tilbudsgarantien ble fjernet

    Scenario: Se hvilken tilbudsgarantitype som ble satt
      Gitt behandleren Kari Nordmann har B-rolle
      Når Kari Nordmann setter tilbudsgarantien "Garanti for test" fra B-rolle på "Sykepleie, høst 2027"
      Så ser behandlerne av saken at tilbudsgarantien "Garanti for test" ble satt fra B-rolle på "Sykepleie, høst 2027"

  # Hva plasstildelingen gjør med tilbudsgarantien, i alle plasstildelingsrunder, står i
  # regelen «Søker med tilbudsgaranti får tilbud uavhengig av poengsum» i
  # 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  Regel: Tilbudsgarantien følger søknadsalternativet

    Scenariomal: Tilbudsgarantien følger søknadsalternativet når prioriteten endres
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 2
      Når søkeren <endring>
      Så har søkeren fortsatt tilbudsgaranti på "Sykepleie, høst 2027"

      Eksempler:
        | endring                                          |
        | flytter "Sykepleie, høst 2027" til prioritet 1   |
        | flytter "Sykepleie, høst 2027" til prioritet 3   |
        | legger til "Historie, høst 2027" som prioritet 1 |

    Scenariomal: Tilbudsgarantien faller bort når søknadsalternativet fjernes
      Gitt søkeren har tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 1
      Når søkeren <handling>
      Så har søkeren ikke lenger tilbudsgaranti på "Sykepleie, høst 2027"

      Eksempler:
        | handling                                    |
        | fjerner "Sykepleie, høst 2027" fra søknaden |
        | trekker søknaden                            |

    # Dette er ett tilfelle av en generell oppførsel: å fjerne et søknadsalternativ
    # eller trekke søknaden er en deaktivering, ikke en sletting (soknadsalternativ.slettet
    # i koden), og saksbehandlingen gjelder igjen når søknadsalternativet legges inn
    # igjen. Det finnes ikke noe generelt krav for den oppførselen ennå, f.eks. i
    # 01 Søknad/trekke_søknad.feature eller prioritere_søknadsalternativer.feature
    # (påpekt i review av PR #654, 09.10.2026).
    Scenariomal: Tilbudsgarantien gjelder igjen når søknadsalternativet legges inn igjen før søknadsfristen
      Gitt søknadsfristen for opptaket er "2027-04-15 23:59"
      Og søkeren hadde tilbudsgaranti på "Sykepleie, høst 2027" som prioritet 1
      Og søkeren fjernet "Sykepleie, høst 2027" fra søknaden "2027-04-01"
      Når søkeren legger inn "Sykepleie, høst 2027" igjen som prioritet <prioritet> "2027-04-08"
      Så har søkeren tilbudsgaranti på "Sykepleie, høst 2027" igjen

      Eksempler:
        | prioritet |
        | 1         |
        | 2         |
