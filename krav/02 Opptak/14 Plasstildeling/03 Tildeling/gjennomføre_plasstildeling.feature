# language: no
# GitHub: #216
@OPT-PLA-TIL-002 @must @draft @scope-plasstildeling-2027
Egenskap: Gjennomføre plasstildeling
  Som opptaksforvalter
  ønsker jeg at plasstildelingen fordeler studieplassene etter rangering, kvoter og innstillingene for plasstildelingsrunden
  slik at hver søker får et riktig og forklarbart svar på hver søknad.

  # ÅPNE SPØRSMÅL:
  #
  # Poeng og rangering:
  # - Grunnlag uten poeng (HUP, REA): se Confluence «Hvordan løse HUP og andre grunnlag som ikke har poeng i plasstildeling».
  # - Loddtrekning blir regelen for UHG fra 2027, men loddnummer har ingen kilde i dag.
  #   Hvem eier trekningen, søknadsbehandlingen eller plasstildelingen? («Fra saksbehandling til plasstildeling», D7)
  # - Poenglikhetsregelen «Tidspunkt»: kodeverket sier «tidligste først, deretter alder», men koden har
  #   ikke alder som andre kriterium (A6). Hvilken er riktig?
  #   Bakgrunn (2026-10-14): Tidspunktet er levert_tidspunkt på søknaden, lagret med mikrosekunder.
  #   Likt tidspunkt er svært sjeldent, men mulig ved stor pågang eller når tidspunktet settes ved
  #   import eller migrering. Uten et andre kriterium blir rekkefølgen da tilfeldig og kan ikke forklares.
  #
  # Venteliste:
  # - Skal ventelistenumre stå urørt etter opprykk, eller nummereres på nytt? Hypotese: nummereres på nytt.

  # Kjente feil i koden, følges opp i Jira (TAKE-278, «Plasstildelingsløpet i Opptak», kap. 13).
  # Dette er ikke åpne spørsmål om kravet:
  #   TAKE-279: bortfall regnes mot feil tilbud når søkeren har flere tilbud.
  #   TAKE-280: ventelistenumre kan kollidere mellom videreførte og nye rader, også mellom plasstildelingsrunder.
  #   TAKE-282: tidligere kansellert resultat leses som «ikke gyldig» i neste plasstildelingsrunde.
  #   TAKE-283: ventelistenummer og rangering over 9 999, eller prioritet over 99, feller hele kjøringen.

  # AVKLART 08.10.2026: Tilbudsgaranti fra tidligopptaket hører med, og gir tilbud i hovedtildelingen,
  # se regelen «Søker med tilbudsgaranti får tilbud uavhengig av poengsum» under.
  #
  # Kilde: tasks/opptak/plasstildeling/design.md (prinsipp 1–3, rundetyper, del 2), oppgave.md (oppgave 5),
  # Confluence «2026-09-08 Raffinering plasstildeling», «Fra saksbehandling til plasstildeling»,
  # «Plasstildelingsløpet i Opptak» og «Samordnet plasstildeling» (akseptansekriterier for algoritme).
  # Plasstildelingen eier fordelingen, ikke poengberegningen. Rangering og kvalifisering kommer fra
  # søknadsbehandlingen (se 10 Regelverk/03 Rangering).
  # Hva innstillingene for plasstildelingsrunden innebærer, står i regelen «Innstillingene for plasstildelingsrunden
  # avgjør hva som skjer med lavere prioriteter og tidligere tilbud».
  # Status i kode: løst, men poenggrense lagres ikke og tapt kvalifisering gir stille bortfall (oppgave.md).

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" har plasstildelingsrunden "Hovedrunde" med rundetype "Hovedtildeling"
    Og at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Førstegangsvitnemål" og "Ordinær"

  Regel: Søkeren får tilbud på høyest mulige prioritet

    Scenario: Tilbud på første prioritet
      Gitt at søkeren "Kari Nordmann" har "Sykepleie, høst 2027" som prioritet 1 og "Vernepleie, høst 2027" som prioritet 2
      Og at søkeren er høyt nok rangert til tilbud på begge
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud på "Sykepleie, høst 2027"

    Scenario: Venteliste på høyere prioritet
      Gitt at søkeren "Kari Nordmann" har "Sykepleie, høst 2027" som prioritet 1 og "Vernepleie, høst 2027" som prioritet 2
      Og at søkeren ikke er høyt nok rangert til tilbud på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud på "Vernepleie, høst 2027"
      Og søkeren står på venteliste til "Sykepleie, høst 2027"

  @depends-on-OPT-REG-KVO-004
  Regel: Søkeren prøves i utdanningskvotene etter kvoteprioritet

    # AVKLART 2026-10-21 (produkteier): En kvotetype uten kvoteprioritet, eller som ikke er koblet til plassflyten
    # i regelverkssamlingen, kan ikke brukes i plasstildelingen. Se 10 Regelverk/04 Kvoter/sette_kvoteprioritet.feature
    # og sette_plassflyt.feature.
    Scenariomal: Kvotetype uten <mangler> brukes ikke i plasstildelingen
      Gitt at kvotetypen "Idrett (IDRETT)" i regelverkssamlingen for opptaket mangler <mangler>
      Når plasstildelingen gjennomføres
      Så tildeles det ingen plasser i utdanningskvoten "Idrett (IDRETT)"

      Eksempler:
        | mangler        |
        | kvoteprioritet |
        | plassflyt      |

    Scenario: Mest spesielle utdanningskvote først
      Gitt at søkeren "Kari Nordmann" er kvalifisert i både "Førstegangsvitnemål" og "Ordinær"
      Og at kvoteprioriteten er "Førstegangsvitnemål" før "Ordinær"
      Når plasstildelingen gjennomføres
      Så prøves søkeren først i utdanningskvoten "Førstegangsvitnemål"
      Og deretter i utdanningskvoten "Ordinær"

    # Flyttet hit 2026-10-19 fra 11 Opprette og vedlikeholde opptak/03 Innstillinger/sette_kvoteprioritet.feature.
    # Kvoteprioriteten settes i regelverkssamlingen (avklart 2026-10-21), og lavest tall er høyest prioritet.
    Scenario: Lavest tall gir høyest prioritet
      Gitt at kvoteprioriteten i regelverkssamlingen for opptaket er 2 for "Førstegangsvitnemål (ORDF)" og 3 for "Ordinær kvote (ORD)"
      Og at søkeren "Kari Nordmann" konkurrerer i begge kvotene og har nok poeng til tilbud i begge på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud i "Førstegangsvitnemål (ORDF)"

    Scenario: Tilbud i én utdanningskvote gir bortfall i de andre på samme utdanningstilbud
      Gitt at søkeren "Kari Nordmann" er kvalifisert i både "Førstegangsvitnemål" og "Ordinær" på "Sykepleie, høst 2027"
      Når plasstildelingen gir søkeren tilbud i utdanningskvoten "Førstegangsvitnemål"
      Så får kvotesøknaden i "Ordinær" på "Sykepleie, høst 2027" bortfall

    # AVKLART 2026-10-14: Kvoteprioritet trengs bare når utdanningstilbudet har flere utdanningskvoter.
    # Koden prøver i dag en utdanningskvote uten kvoteprioritet først (videreført fra admissio). Det avviker
    # fra kravet, der en kvotetype uten kvoteprioritet ikke brukes i plasstildelingen (scenariomalen over).
    # AVKLART 2026-10-30 (produkteier): Har utdanningstilbudet bare én utdanningskvote, har kvoteprioriteten
    # ingen betydning, fordi utdanningskvoten ikke rangeres mot en annen.
    Scenario: Kvoteprioriteten har ingen betydning når utdanningstilbudet har én utdanningskvote
      Gitt at utdanningstilbudet "Vernepleie, høst 2027" bare har utdanningskvoten "Ordinær"
      Og at søkeren "Kari Nordmann" er kvalifisert i "Ordinær" på "Vernepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så prøves søkeren i utdanningskvoten "Ordinær" på "Vernepleie, høst 2027"

  Regel: Ingen søker forsvinner stille

    # AVKLART 2026-10-09 (krav/02 Opptak/begreper.md, avklaring 20): Bortfall og avslag er to ulike resultater.
    # Avslag: søkeren er ikke kvalifisert, eller har ikke nådd opp og har ikke fått plass på venteliste.
    # Bortfall: søkeren mister tilbudet på en lavere prioritet fordi søkeren har fått tilbud på en høyere.
    # Gap mot koden: «kvalifisert uten tilbud» lagres i dag som bortfall, så de to kan ikke skilles i ettertid.

    Scenario: Én vurdering per kvotesøknad
      Når plasstildelingen gjennomføres
      Så har hver kvotesøknad i plasstildelingen nøyaktig ett av disse resultatene
        | Resultat              |
        | Tilbud                |
        | Venteliste med nummer |
        | Bortfall              |
        | Avslag                |

    Scenario: Søker som har mistet kvalifiseringen
      Gitt at søkeren "Ola Nordmann" var kvalifisert i "Hovedrunde"
      Og at søkeren ikke lenger er kvalifisert når plasstildelingen i "Suppleringsrunde" starter
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så får søkeren avslag på "Sykepleie, høst 2027"
      Og søkeren er fortsatt med i resultatet

  Regel: Ventelistenumre er sammenhengende og unike per utdanningskvote

    Scenario: Ventelistenumre uten hull
      Gitt at 5 kvalifiserte søkere i utdanningskvoten "Ordinær" ikke får tilbud
      Når plasstildelingen gjennomføres
      Så har søkerne ventelistenumrene 1, 2, 3, 4 og 5 i utdanningskvoten "Ordinær"

    # AVKLART 2026-10-14: Poenglikhetsregelen avgjør rekkefølgen på ventelisten, som for tilbud.
    # I dag får søkere med lik rangering vilkårlige unike numre.
    Scenario: Poenglikhetsregelen avgjør rekkefølgen på ventelisten
      Gitt at poenglikhetsregelen er "Alder, eldste først"
      Og at to søkere i utdanningskvoten "Ordinær" har samme poengsum og ikke får tilbud
      Når plasstildelingen gjennomføres
      Så får den eldste søkeren det laveste ventelistenummeret av de to

    Scenario: Bortfall har ikke ventelistenummer
      Gitt at søkeren "Kari Nordmann" har bortfall på "Vernepleie, høst 2027"
      Så har søkeren ikke ventelistenummer på "Vernepleie, høst 2027"

  Regel: Søkeren rangeres etter den høyeste poengsummen i utdanningskvoten

    # AVKLART 2026-10-14: Det som slår best ut for søkeren, gjelder (saksbehandlingsprinsippet).
    Scenario: Høyeste poengsum brukes
      Gitt at søkeren "Kari Nordmann" har poengsummene 48,5 og 52,3 fra ulike grunnlag i utdanningskvoten "Ordinær"
      Når plasstildelingen gjennomføres
      Så rangeres søkeren med 52,3 poeng i utdanningskvoten "Ordinær"

    Scenario: Lik poengsum fra to grunnlag
      Gitt at søkeren "Kari Nordmann" har poengsummen 52,3 fra to grunnlag i utdanningskvoten "Ordinær"
      Når plasstildelingen gjennomføres
      Så rangeres søkeren med 52,3 poeng fra grunnlaget med laveste grunnlagskode

  Regel: Poenglikhetsregelen avgjør rekkefølgen ved lik poengsum

    # Standard poenglikhetsregel settes på opptaket, se 11 Opprette og vedlikeholde opptak/03 Innstillinger/innstillinger.feature.
    # I samordna opptak 2027 skal lærestedet bare kunne velge «alle med samme sum får tilbud» som unntak.
    # AVKLART 2026-10-19 (produkteier): Det er behovet i samordna opptak nå. Kravet beskriver hva som skal være
    # mulig: opptaksforvalter bestemmer hvilke regler som er tilgjengelige som unntak, og har ansvaret for at
    # det registreres riktig.
    # AVKLART 2026-10-14: Bare «Alle med samme sum får tilbud» gir hele gruppen på grensen tilbud.
    # Gap mot koden (A4): i dag får hele gruppen alltid tilbud, uansett poenglikhetsregel.
    # AVKLART 2026-10-14: Underrepresentert kjønn skal støttes, også sammen med alder og loddtrekning.
    # Gap mot koden: kjønnsleddet hoppes over i dag (UttrekkRangeringsstrategi, med advarsel i loggen).
    Scenariomal: Lik poengsum på siste plass
      Gitt at det er én plass igjen i utdanningskvoten "Ordinær"
      Og at to søkere har samme poengsum på siste plass
      Og at poenglikhetsregelen er "<regel>"
      Når plasstildelingen gjennomføres
      Så får <resultat>

      Eksempler:
        | regel                                   | resultat                                                    |
        | Alder, eldste først                     | den eldste søkeren tilbud                                   |
        | Alle med samme sum får tilbud           | begge søkerne tilbud                                        |
        | Tidspunkt for levert søknad             | søkeren som søkte først tilbud                              |
        | Prioritet, deretter alder               | søkeren som har utdanningstilbudet høyest prioritert tilbud |
        | Underrepresentert kjønn, deretter alder | søkeren av underrepresentert kjønn tilbud                   |

    @openquestion
    Scenario: Loddtrekning ved lik poengsum
      # ÅPNE SPØRSMÅL: se spørsmålene øverst i fila (Poeng og rangering).
      Gitt at to søkere har samme poengsum på siste plass
      Og at poenglikhetsregelen er "Loddtrekning"
      Når plasstildelingen gjennomføres
      Så får søkeren som vinner loddtrekningen tilbud

  Regel: Søker med tilbudsgaranti får tilbud uavhengig av poengsum

    Scenario: Tilbudsgaranti tas fra markert utdanningskvote
      Gitt at tilbudsgarantier for "Sykepleie, høst 2027" tas fra utdanningskvoten "Ordinær"
      Og at søkeren "Ola Nordmann" har tilbudsgaranti på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud på "Sykepleie, høst 2027"
      Og tilbudet teller som ett av tilbudene i utdanningskvoten "Ordinær"

    # AVKLART 2026-10-28 (produkteier, etter brukertesten med HK-dir 2026-10-27, HK-11411): «Tilbudsgaranti
    # overkjører antall tilbud som skal gis.» Tilbudsgarantiene teller med i antall tilbud som skal gis, og gis
    # først. De andre søkerne får tilbud på plassene som er igjen. Er det flere søkere med tilbudsgaranti enn antall
    # tilbud som skal gis, får alle med tilbudsgaranti tilbud, og ingen andre. Koden gjør dette i dag for automatisk
    # tilbudsgaranti (verify-2026-10-28-1645, `StudyProgrammeSm.java`), men tilbudsgaranti fra saksbehandlingen
    # når ikke plasstildelingen.
    Scenario: Tilbudsgaranti teller med i antall tilbud som skal gis
      Gitt at det skal gis 30 tilbud i utdanningskvoten "Ordinær" på "Sykepleie, høst 2027"
      Og at 30 søkere uten tilbudsgaranti er rangert foran søkeren "Ola Nordmann" i utdanningskvoten "Ordinær"
      Og at søkeren "Ola Nordmann" har tilbudsgaranti på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så får søkeren "Ola Nordmann" tilbud på "Sykepleie, høst 2027"
      Og de 29 høyest rangerte søkerne uten tilbudsgaranti får tilbud
      Og det er gitt 30 tilbud i utdanningskvoten "Ordinær"

    Scenario: Flere søkere med tilbudsgaranti enn antall tilbud som skal gis
      Gitt at det skal gis 2 tilbud i utdanningskvoten "Ordinær" på "Sykepleie, høst 2027"
      Og at 3 søkere har tilbudsgaranti på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så får de 3 søkerne med tilbudsgaranti tilbud på "Sykepleie, høst 2027"
      Og ingen søkere uten tilbudsgaranti får tilbud i utdanningskvoten "Ordinær"

    Scenario: Bare søkere med tilbudsgaranti får tilbud når antall tilbud er 0
      Gitt at antall tilbud som skal gis i utdanningskvoten "Ordinær" på "Sykepleie, høst 2027" er 0
      Og at søkeren "Ola Nordmann" har tilbudsgaranti på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så får søkeren "Ola Nordmann" tilbud på "Sykepleie, høst 2027"
      Og ingen søkere uten tilbudsgaranti får tilbud i utdanningskvoten "Ordinær"

    # AVKLART 2026-10-08: Søkeren med tilbudsgaranti får tilbud etter reglene for plasstildelingsrunden,
    # og trenger ingen poengsum.
    # AVKLART 2026-10-14: Plasstildelingen bryr seg ikke om hvem som satte tilbudsgarantien, bare om den er
    # satt. Den tar bare hensyn til tilbudsgarantier som gir tilbud, altså der søkeren skal ha plass der
    # tilbudsgarantien er gitt. Hvem som kan sette tilbudsgaranti, og typene, står i
    # 13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti.feature.
    # Gap mot koden («Fra saksbehandling til plasstildeling», kap. 2–3 og D4): tilbudsgaranti fra
    # saksbehandlingen når ikke plasstildelingen, og en søknad uten poengsum kommer ikke med i grunnlaget.
    Scenario: Tilbudsgaranti uten poengsum
      Gitt at søknaden til "Ola Nordmann" på "Sykepleie, høst 2027" har en tilbudsgaranti som gir tilbud
      Og at søknaden ikke har poengsum
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud på "Sykepleie, høst 2027"

    # AVKLART 2026-10-21 (produkteier): En SPEV-kvote (kvotetype med rangeringsmetoden SPEV) er et venterom for
    # søkere som får tilbudsgaranti. Den har ingen egne plasser, og tilbudene i den tas fra hovedkvoten. I
    # plassflyten kan den bare ha hovedkvoten som mottaker, se 10 Regelverk/04 Kvoter/sette_plassflyt.feature.
    Scenario: Tilbud i SPEV-kvoten tas fra hovedkvoten
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvotene "Spesiell vurdering (SPEV)" og "Ordinær kvote (ORD)"
      Og at "Ordinær kvote (ORD)" er hovedkvoten, og det skal gis 100 tilbud i den
      Og at søknaden til "Ola Nordmann" på "Sykepleie, høst 2027" har en tilbudsgaranti som gir tilbud
      Og at søknaden venter i "Spesiell vurdering (SPEV)"
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud i "Spesiell vurdering (SPEV)"
      Og tilbudet teller som ett av de 100 tilbudene i "Ordinær kvote (ORD)"

    Scenario: SPEV-kvoten har ingen egne plasser
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" har utdanningskvoten "Spesiell vurdering (SPEV)"
      Og at ingen søkere med tilbudsgaranti venter i "Spesiell vurdering (SPEV)"
      Når plasstildelingen gjennomføres
      Så gis det ingen tilbud i "Spesiell vurdering (SPEV)"

    Scenario: Tilbudsgaranti som ikke gir tilbud
      Gitt at søknaden til "Ola Nordmann" på "Sykepleie, høst 2027" har en tilbudsgaranti som ikke gir tilbud
      Når plasstildelingen gjennomføres
      Så konkurrerer søkeren om plass på "Sykepleie, høst 2027" etter rangeringen, som andre søkere

  Regel: Poenggrensen beregnes per utdanningskvote

    Scenario: Poenggrense fra siste søker som fikk tilbud
      Gitt at den siste søkeren som fikk tilbud i utdanningskvoten "Ordinær" hadde 52,3 poeng
      Når plasstildelingen gjennomføres
      Så er poenggrensen for utdanningskvoten "Ordinær" 52,3

    Scenario: Alle kvalifiserte fikk tilbud
      Gitt at alle kvalifiserte søkere i utdanningskvoten "Ordinær" fikk tilbud
      Når plasstildelingen gjennomføres
      Så er poenggrensen for utdanningskvoten "Ordinær" «alle kvalifiserte har fått tilbud»

  @depends-on-OPT-REG-RUN-001
  Regel: Innstillingene for plasstildelingsrunden avgjør hva som skjer med lavere prioriteter og tidligere tilbud

    # Endret 2026-10-24: Plasstildelingen leser innstillingene plasstildelingsrunden har fra rundetypen,
    # og ser aldri på hvilken rundetype det er. Rundetypene i samordna opptak, med innstillingene, står i
    # regelverkssamlingen (10 Regelverk/06 Rundetyper/bruke_rundetyper.feature).
    # Tabellen over hva hver rundetype innebar, er flyttet dit.
    # AVKLART 2026-10-14: Tilbud, venteliste og avslag finnes alltid. Bortfall finnes bare når tilbud gir
    # bortfall på lavere prioriteter. Rangeringen er poeng og rangering i alle plasstildelingsrunder.
    # AVKLART 2026-10-08: Rundetypen avgjør ikke om et utdanningstilbud kan ekskluderes.
    # Et utdanningstilbud er ute av plasstildelingsrunden når det ikke er satt antall tilbud som skal gis,
    # se 02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature.
    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 2): ingen logikk skiller på rundetype eller
    # innstillinger i dag. Bortfall gis alltid, en søker får høyst ett ordinært tilbud, og om en
    # plasstildeling bygger på en tidligere plasstildelingsrunde, avgjøres av om opptaket har en publisert
    # plasstildelingsrunde fra før. Plasstildeling uten bortfall må bygges.

    Scenario: Plasstildelingen ser ikke på navnet på rundetypen
      Gitt at rundetypene "Supplering" og "Supplering lokalt" har de samme innstillingene
      Og at grunnlaget for plasstildelingen er det samme i to plasstildelingsrunder med hver sin av rundetypene
      Når plasstildelingen gjennomføres i begge plasstildelingsrundene
      Så gir plasstildelingene det samme resultatet

    Scenario: Tilbud gir bortfall på lavere prioriteter
      Gitt at plasstildelingsrunden har innstillingen "Tilbud gir bortfall på lavere prioriteter"
      Og at søkeren "Kari Nordmann" får tilbud på prioritet 1
      Når plasstildelingen gjennomføres
      Så får søkeren bortfall på alle lavere prioriteter

    # AVKLART 2026-10-14: Uten bortfall kan søkeren ha flere ordinære tilbud, og må velge ett.
    Scenario: Søkeren kan ha flere ordinære tilbud uten bortfall
      Gitt at plasstildelingsrunden ikke har innstillingen "Tilbud gir bortfall på lavere prioriteter"
      Og at søkeren "Kari Nordmann" har tilbud på prioritet 2 og står på venteliste til prioritet 1
      Når plasstildelingen gir søkeren tilbud på prioritet 1
      Så har søkeren tilbud på både prioritet 1 og prioritet 2
      Og søkeren må velge ett av tilbudene

    Scenario: Ingen bortfall uten innstillingen
      Gitt at plasstildelingsrunden ikke har innstillingen "Tilbud gir bortfall på lavere prioriteter"
      Når plasstildelingen gjennomføres
      Så har ingen kvotesøknader resultatet bortfall

    # AVKLART 2026-10-14 (domeneekspert): «Bygger på forrige publiserte plasstildelingsrunde» betyr at
    # aksepterte tilbud fra forrige runde garanteres med en automatisk tilbudsgaranti, og at søkeren bare
    # konkurrerer om plass i utdanningskvotene søkeren står på venteliste til. Unntaket er søknadsalternativer
    # der søkeren er blitt kvalifisert etter forrige runde, for eksempel etter en klage.
    Scenario: Akseptert tilbud garanteres når plasstildelingsrunden bygger på forrige
      Gitt at plasstildelingsrunden "Suppleringsrunde" har innstillingen "Bygger på forrige publiserte plasstildelingsrunde"
      Og at søkeren "Kari Nordmann" fikk tilbud på prioritet 2 i "Hovedrunde" og takket ja
      Og at søkeren fortsatt ikke er høyt nok rangert til prioritet 1
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så beholder søkeren tilbudet på prioritet 2 med automatisk tilbudsgaranti

    Scenario: Søkeren konkurrerer bare der søkeren står på venteliste
      Gitt at plasstildelingsrunden "Suppleringsrunde" har innstillingen "Bygger på forrige publiserte plasstildelingsrunde"
      Og at søkeren "Kari Nordmann" har takket ja til tilbudet på prioritet 2 fra "Hovedrunde"
      Og at søkeren står på venteliste til prioritet 1
      Og at søkeren fikk bortfall på prioritet 3 i "Hovedrunde"
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så konkurrerer søkeren om plass på prioritet 1
      Men søkeren konkurrerer ikke om plass på prioritet 3

    Scenario: Søkeren konkurrerer etter ny kvalifisering
      Gitt at plasstildelingsrunden "Suppleringsrunde" har innstillingen "Bygger på forrige publiserte plasstildelingsrunde"
      Og at søkeren "Kari Nordmann" ikke var kvalifisert på "Vernepleie, høst 2027" i "Hovedrunde"
      Og at søkeren er blitt kvalifisert på "Vernepleie, høst 2027" etter en klage
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så konkurrerer søkeren om plass på "Vernepleie, høst 2027"

    Scenario: Opprykk når plasstildelingsrunden bygger på forrige
      Gitt at plasstildelingsrunden "Suppleringsrunde" har innstillingene "Tilbud gir bortfall på lavere prioriteter" og "Bygger på forrige publiserte plasstildelingsrunde"
      Og at søkeren "Kari Nordmann" fikk tilbud på prioritet 2 i "Hovedrunde"
      Og at søkeren nå er høyt nok rangert til prioritet 1
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så får søkeren tilbud på prioritet 1
      Og tilbudet på prioritet 2 faller bort

    # AVKLART 2026-10-08: Ledige studieplasser er en egenskap opptaksforvalter kan sette på en plasstildelingsrunde,
    # når rundetypen kan åpnes for ledige studieplasser (endret 2026-10-24). Det er ikke en egen rundetype. Kvalifiserte søkere som
    # søkte innen ordinær søknadsfrist, rangeres etter poeng og får plass først. Deretter fylles de
    # ledige plassene med kvalifiserte søkere som har søkt på ledige studieplasser, i rekkefølgen de
    # leverte søknaden. Søknadene samles opp, og opptaksforvalter kjører plasstildeling og publiserer
    # resultatet som i andre plasstildelingsrunder. Tilbud gis ikke fortløpende.
    # Både plasstildelingsrunden og utdanningstilbudet må åpne for ledige studieplasser (avklart 2026-10-08).
    # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 9): i dag styres det bare av flagget
    # «tilbyr ledige studieplasser» på utdanningstilbudet, uavhengig av plasstildelingsrunde.
    Scenario: Ledige studieplasser i en plasstildelingsrunde
      Gitt at opptaksforvalter har åpnet plasstildelingsrunden "Etterfylling" for ledige studieplasser
      Og at "Sykepleie, høst 2027" tilbyr ledige studieplasser
      Og at det skal gis 30 tilbud på "Sykepleie, høst 2027" i plasstildelingsrunden "Etterfylling"
      Og at 13 kvalifiserte søkere søkte på "Sykepleie, høst 2027" innen ordinær søknadsfrist
      Og at 150 kvalifiserte søkere har søkt på "Sykepleie, høst 2027" på ledige studieplasser
      Når plasstildelingen i "Etterfylling" gjennomføres
      Så får de 13 søkerne som søkte innen ordinær søknadsfrist, tilbud etter poeng
      Og de 17 neste tilbudene går til søkerne som leverte søknad på ledige studieplasser først

    # AVKLART 2026-10-14: Et tilbud på en ledig studieplass gir ikke bortfall, heller ikke når tilbud ellers
    # gir bortfall på lavere prioriteter i plasstildelingsrunden.
    # Søkeren beholder tilbudene og ventelisteplassene fra tidligere plasstildelingsrunder, og må velge.
    # Tilbud på ledige studieplasser kommer i tillegg til ett ordinært tilbud (domeneekspert 2026-10-14).
    # Hvor mange tilbud søkeren kan takke ja til, settes på opptaket.
    Scenario: Tilbud på ledig studieplass gir ikke bortfall
      Gitt at plasstildelingsrunden "Suppleringsrunde" har innstillingen "Tilbud gir bortfall på lavere prioriteter"
      Og at plasstildelingsrunden "Suppleringsrunde" er åpnet for ledige studieplasser
      Og at søkeren "Kari Nordmann" fra en tidligere plasstildelingsrunde har tilbud på "Vernepleie, høst 2027" og står på venteliste til "Barnevern, høst 2027"
      Og at søkeren har søkt på en ledig studieplass på "Sykepleie, høst 2027"
      Når plasstildelingen i "Suppleringsrunde" gir søkeren tilbud på den ledige studieplassen på "Sykepleie, høst 2027"
      Så beholder søkeren tilbudet på "Vernepleie, høst 2027" og ventelisteplassen til "Barnevern, høst 2027"
      Og søkeren må velge ett av tilbudene

    # AVKLART 2026-10-14 (domeneekspert): Ledige studieplasser har sin egen logikk. Også når tilbud gir
    # bortfall på lavere prioriteter, kan søkeren få et tilbud på en ledig studieplass i tillegg til ett ordinært tilbud.
    @openquestion
    Scenario: Søkeren kan få et ordinært tilbud og et tilbud på en ledig studieplass i samme runde
      # ÅPNE SPØRSMÅL:
      # - Hvor mange tilbud på ledige studieplasser kan en søker få? I koden er det fast inntil 10,
      #   i tillegg til ett ordinært tilbud.
      Gitt at plasstildelingsrunden "Hovedrunde" er åpnet for ledige studieplasser
      Og at søkeren "Kari Nordmann" når et ordinært tilbud på "Vernepleie, høst 2027"
      Og at søkeren når en ledig studieplass på "Sykepleie, høst 2027"
      Når plasstildelingen i "Hovedrunde" gjennomføres
      Så får søkeren tilbud på både "Vernepleie, høst 2027" og den ledige studieplassen på "Sykepleie, høst 2027"
      Og søkeren må velge ett av tilbudene
