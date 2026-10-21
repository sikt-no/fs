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
#   - Saksbehandler overstyrer hvilken utdanningskvote tilbudsgarantien tas fra (STEK-270).
#
# Regelen «Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt» og
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
#   - Saksbehandler (B-rolle i dagens løsning): den saksbehandlende organisasjonen,
#     eller saksbehandleren som handler for den.
#     Eksempler fra dagens løsning: etter klage, reservert plass.
#   - Tilbyder (T-rolle): lærestedet som tilbyr utdanningstilbudet, eller
#     saksbehandleren som setter tilbudsgaranti for det.
#     Eksempler: særskilt vurdering, tidligsvar (forhåndsopptak).
#   - Opptaksforvalter (F-rolle): organisasjonen som forvalter opptaket, eller
#     saksbehandleren som handler for den.
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
  Som saksbehandler
  ønsker jeg å gi søkeren tilbudsgaranti på et søknadsalternativ etter en individuell vurdering
  slik at søkeren får tilbud på søknadsalternativet uavhengig av den ordinære rangeringen.

  Regel: Saksbehandler, tilbyder og opptaksforvalter kan sette tilbudsgaranti manuelt

    Scenariomal: Sette tilbudsgaranti i feltet for rollen
      Gitt tilbudsgarantitypen "<type>" kan brukes av <rolle>
      Når <rolle> setter tilbudsgarantien "<type>" på "Sykepleie, høst 2027"
      Så har søkeren tilbudsgarantien "<type>" fra <rolle> på "Sykepleie, høst 2027"

      Eksempler:
        | rolle            | type                                     |
        | saksbehandler    | Tilbudsgaranti innvilges etter klage     |
        | tilbyder         | Tilbudsgaranti, særskilt vurdering       |
        | opptaksforvalter | Tilbudsgaranti gitt etter telefonsamtale |

    Scenario: Bare tilbudsgarantitypene for rollen kan velges
      Gitt tilbudsgarantitypen "Tilbudsgaranti, særskilt vurdering" kan bare brukes av tilbyder
      Når saksbehandleren skal sette tilbudsgaranti på "Sykepleie, høst 2027"
      Så kan ikke saksbehandleren velge "Tilbudsgaranti, særskilt vurdering"

    Scenario: Saksbehandler ser ikke muligheten til å sette tilbudsgaranti som tilbyder eller opptaksforvalter
      Gitt saksbehandleren er ikke tilbyder eller opptaksforvalter for "Sykepleie, høst 2027"
      Når saksbehandleren ser på "Sykepleie, høst 2027" i saken
      Så ser saksbehandleren muligheten til å sette tilbudsgaranti fra saksbehandler
      Men saksbehandleren ser ikke muligheten til å sette tilbudsgaranti fra tilbyder eller opptaksforvalter

    Scenario: Se tilbudsgarantiene fra alle rollene
      Gitt søkeren har følgende tilbudsgarantier på "Sykepleie, høst 2027":
        | rolle            | type                                     |
        | saksbehandler    | Tilbudsgaranti innvilges etter klage     |
        | opptaksforvalter | Tilbudsgaranti gitt etter telefonsamtale |
      Når saksbehandleren ser på "Sykepleie, høst 2027" i saken
      Så ser saksbehandleren begge tilbudsgarantiene og hvilken rolle som har satt dem

    Scenario: Sette tilbudsgaranti når søknaden ikke kan poengberegnes
      Gitt søknaden kan ikke poengberegnes
      Når tilbyder setter tilbudsgaranti på "Sykepleie, høst 2027"
      Så har søkeren tilbudsgaranti fra tilbyder på "Sykepleie, høst 2027"

  Regel: Tilbudsgarantien kan endres og fjernes av rollen som satte den

    Scenario: Endre tilbudsgaranti
      Gitt søkeren har tilbudsgarantien "Tilbudsgaranti innvilges etter klage" fra saksbehandler på "Sykepleie, høst 2027"
      Når saksbehandleren endrer tilbudsgarantien sin på "Sykepleie, høst 2027" til "Reservert studieplass"
      Så har søkeren tilbudsgarantien "Reservert studieplass" fra saksbehandler på "Sykepleie, høst 2027"

    Scenario: Fjerne tilbudsgaranti
      Gitt søkeren har tilbudsgarantien "Tilbudsgaranti innvilges etter klage" fra saksbehandler på "Sykepleie, høst 2027"
      Når saksbehandleren fjerner tilbudsgarantien sin på "Sykepleie, høst 2027"
      Så har søkeren ikke tilbudsgaranti fra saksbehandler på "Sykepleie, høst 2027"

    Scenario: Tilbudsgarantien fra en annen rolle blir stående
      Gitt søkeren har tilbudsgarantien "Tilbudsgaranti innvilges etter klage" fra saksbehandler på "Sykepleie, høst 2027"
      Og søkeren har tilbudsgarantien "Tilbudsgaranti gitt etter telefonsamtale" fra opptaksforvalter på "Sykepleie, høst 2027"
      Når saksbehandleren fjerner tilbudsgarantien sin på "Sykepleie, høst 2027"
      Så har søkeren fortsatt tilbudsgarantien "Tilbudsgaranti gitt etter telefonsamtale" fra opptaksforvalter på "Sykepleie, høst 2027"

    Scenario: Opptaksforvalter ser ikke muligheten til å endre tilbudsgarantien fra saksbehandler
      Gitt opptaksforvalteren er ikke saksbehandler for saken
      Og søkeren har tilbudsgarantien "Tilbudsgaranti innvilges etter klage" fra saksbehandler på "Sykepleie, høst 2027"
      Når opptaksforvalteren ser på "Sykepleie, høst 2027" i saken
      Så ser ikke opptaksforvalteren muligheten til å endre eller fjerne tilbudsgarantien fra saksbehandler

  Regel: Tilbudsgarantitypene hører til opptaket

    Scenario: Bare tilbudsgarantitypene i opptaket kan velges
      Gitt "Sykepleie, høst 2027" er med i opptaket "Samordna opptak 2027"
      Og tilbudsgarantitypen "Reservert studieplass" finnes bare i opptaket "Samordna opptak 2026"
      Når saksbehandleren skal sette tilbudsgaranti på "Sykepleie, høst 2027"
      Så kan ikke saksbehandleren velge "Reservert studieplass"

  # En endring vises som at tilbudsgarantien er satt på nytt, med den nye typen
  # (avklart med Daniel 21.10.2026, som i STEK-559). Endringsloggen viser i dag ikke
  # hvilket søknadsalternativ endringen gjelder, og må endres (STEK-627).
  Regel: Endringer i tilbudsgarantien kan spores

    Scenario: Se hvem som har satt tilbudsgarantien
      Gitt Kari Nordmann er saksbehandler for saken
      Når Kari Nordmann setter tilbudsgarantien som saksbehandler på "Sykepleie, høst 2027"
      Så ser saksbehandlerne av saken at Kari Nordmann har satt tilbudsgarantien som saksbehandler på "Sykepleie, høst 2027"
      Og saksbehandlerne av saken ser når tilbudsgarantien ble satt

    Scenario: Se hvem som har fjernet tilbudsgarantien
      Gitt Kari Nordmann er saksbehandler for saken
      Og søkeren har tilbudsgaranti fra saksbehandler på "Sykepleie, høst 2027"
      Når Kari Nordmann fjerner tilbudsgarantien sin på "Sykepleie, høst 2027"
      Så ser saksbehandlerne av saken at Kari Nordmann har fjernet tilbudsgarantien sin på "Sykepleie, høst 2027"
      Og saksbehandlerne av saken ser når tilbudsgarantien ble fjernet

    Scenario: Se hvilken tilbudsgarantitype som ble satt
      Gitt Kari Nordmann er saksbehandler for saken
      Når Kari Nordmann setter tilbudsgarantien "Garanti for test" som saksbehandler på "Sykepleie, høst 2027"
      Så ser saksbehandlerne av saken at tilbudsgarantien "Garanti for test" ble satt fra saksbehandler på "Sykepleie, høst 2027"

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

    # Avklart med domeneekspert 21.10.2026: også tilbudsgarantien fra saksbehandler følger
    # søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon, selv om
    # saksbehandlingen starter på nytt der (tildele_saksbehandlende_organisasjon.feature).
    # Koden kopierer i dag bare tilbudsgarantien fra tilbyder og opptaksforvalter, og må
    # endres (STEK-626).
    Scenariomal: Tilbudsgarantien følger søknadsalternativet når det flyttes til en annen saksbehandlende organisasjon
      Gitt søkeren har tilbudsgaranti fra <rolle> på "Informatikk, UiO"
      Når "Informatikk, UiO" flyttes fra "Universitetet i Oslo" til "HK-dir"
      Så har søkeren fortsatt tilbudsgaranti fra <rolle> på "Informatikk, UiO"

      Eksempler:
        | rolle            |
        | saksbehandler    |
        | tilbyder         |
        | opptaksforvalter |

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
