# language: no
# GitHub: #216
@OPT-PLA-TIL-002 @must @draft
Egenskap: Gjennomføre plasstildeling
  Som opptaksforvalter
  ønsker jeg at plasstildelingen fordeler studieplassene etter rangering, kvoter og rundetype
  slik at hver søker får et riktig og forklarbart svar på hver søknad.

  # ÅPNE SPØRSMÅL:
  #
  # Rundetype og utfall:
  # - Hva betyr «bygger på forrige publiserte runde» i praksis? Er det at resultatet fra forrige
  #   runde er utgangspunktet, og at bare endringer (opprykk, nye tilbud, bortfall) beregnes?
  #   Eller kjøres hele fordelingen på nytt med oppdaterte tall?
  # - Hvilke utfall (tilbud, venteliste, bortfall, avslag) er mulige i hvilken rundetype?
  #   I etterfylling og ledige studieplasser finnes ikke bortfall — men det er ikke sagt eksplisitt.
  # - Bortfall i supplering: fungerer det likt som i hovedtildeling (lavere prioriteter faller bort
  #   ved tilbud), bortsett fra at opprykk gir kompensasjonstilbud?
  # - Ledige studieplasser: søker kan ha tilbud fra før og må velge — gjelder det likt som i etterfylling?
  # - Hvor mange tilbud på ledige studieplasser kan en søker ha samtidig? I koden inntil 10 i tillegg
  #   til ett ordinært, begge fast i koden. Skal det være fast, eller en innstilling på opptaket?
  #
  # Poeng og rangering:
  # - Når en søker har flere poengsummer i samme kvotetype: er det riktig at høyeste poengsum vinner,
  #   og at laveste grunnlagskode avgjør ved likhet? Saksbehandlingsprinsippet tilsier det som slår best ut for søkeren.
  # - Grunnlag uten poeng (HUP, REA): se Confluence «Hvordan løse HUP og andre grunnlag som ikke har poeng i plasstildeling».
  # - Loddtrekning blir regelen for UHG fra 2027, men loddnummer har ingen kilde i dag.
  #   Hvem eier trekningen, søknadsbehandlingen eller plasstildelingen? («Fra saksbehandling til plasstildeling», D7)
  # - Lik poengsum på grensen gir i koden alltid tilbud til hele gruppen, også ut over antall tilbud som
  #   skal gis, og uten øvre grense (A4). Skal det gjelde for alle poenglikhetsregler, eller bare for
  #   «Alle med samme sum får tilbud»?
  # - Poenglikhetsregelen «Tidspunkt»: kodeverket sier «tidligste først, deretter alder», men koden har
  #   ikke alder som andre kriterium (A6). Hvilken er riktig?
  # - Poenglikhetsregelen «Prioritet» (søkerens prioritet, deretter alder) finnes i koden, men ikke i
  #   eksemplene under. Skal den være med?
  # - Underrepresentert kjønn som poenglikhetsregel finnes i kodeverket, men har ingen effekt i koden.
  #   Skal den støttes?
  #
  # Utdanningskvoter:
  # - En utdanningskvote uten kvoteprioritet prøves først i koden (videreført fra admissio). Er det riktig?
  # - Får søkeren tilbud i én utdanningskvote, får de andre kvotesøknadene på samme utdanningstilbud
  #   bortfall. Skal det stå som et eget scenario?
  #
  # Venteliste:
  # - Skal søkere med lik rangering på venteliste dele ventelistenummer, eller få vilkårlige unike numre?
  #   I dag: vilkårlige unike. Hypotese: avhenger av poenglikhetsregelen.
  # - Skal ventelistenumre stå urørt etter opprykk, eller nummereres på nytt? Hypotese: nummereres på nytt.
  # - Ventelistenumre kan i dag kollidere mellom runder (mistenkt feil, TAKE-280).
  #
  # Bortfall og avslag:
  # - Er «bortfall» og «avslag» to ulike resultater i resultatlisten, eller er bortfall en type avslag?
  #   I koden lagres «kvalifisert uten tilbud» som bortfall, så de to kan ikke skilles i ettertid.
  #
  # Mistenkte feil fra kodegjennomgangen (TAKE-278, «Plasstildelingsløpet i Opptak», kap. 13):
  # - TAKE-279: bortfall regnes mot feil tilbud når søkeren har flere tilbud.
  # - TAKE-280: ventelistenumre kan kollidere mellom videreførte og nye rader.
  # - TAKE-282: tidligere kansellert resultat leses som «ikke gyldig» i neste runde.
  # - TAKE-283: ventelistenummer og rangering over 9 999, eller prioritet over 99, feller hele kjøringen.
  #
  # Innstillinger og grensetilfeller:
  # - Innstillingen «maks antall tilbud per søker per runde» (innstillinger.feature) mot etterfylling,
  #   der søkeren kan ha flere tilbud. Hvordan henger de sammen? Unntak for deltid under 60 stp?
  # - Tidligopptak: tilsagn som gir tilbudsgaranti i hovedtildelingen (Confluence «Samordnet plasstildeling»). Hører det med?
  #
  # Kilde: tasks/opptak/plasstildeling/design.md (prinsipp 1–3, rundetyper, del 2), oppgave.md (oppgave 5),
  # Confluence «2026-09-08 Raffinering plasstildeling», «Fra saksbehandling til plasstildeling»,
  # «Plasstildelingsløpet i Opptak» og «Samordnet plasstildeling» (akseptansekriterier for algoritme).
  # Plasstildelingen eier fordelingen, ikke poengberegningen. Rangering og kvalifisering kommer fra
  # søknadsbehandlingen (se 10 Regelverk/03 Rangering).
  # Hva rundetypen innebærer er oppsummert i 01 Runder/legge_til_runde.feature.
  # Status i kode: løst, men poenggrense lagres ikke og tapt kvalifisering gir stille bortfall (oppgave.md).

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" har runden "Hovedrunde" med rundetype "Hovedtildeling"
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

  Regel: Søkeren prøves i utdanningskvotene etter kvoteprioritet

    Scenario: Mest spesielle utdanningskvote først
      Gitt at søkeren "Kari Nordmann" er kvalifisert i både "Førstegangsvitnemål" og "Ordinær"
      Og at kvoteprioriteten er "Førstegangsvitnemål" før "Ordinær"
      Når plasstildelingen gjennomføres
      Så prøves søkeren først i utdanningskvoten "Førstegangsvitnemål"
      Og deretter i utdanningskvoten "Ordinær"

  Regel: Ingen søker forsvinner stille

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

    Scenario: Bortfall har ikke ventelistenummer
      Gitt at søkeren "Kari Nordmann" har bortfall på "Vernepleie, høst 2027"
      Så har søkeren ikke ventelistenummer på "Vernepleie, høst 2027"

  Regel: Poenglikhetsregelen avgjør rekkefølgen ved lik poengsum

    # Standard poenglikhetsregel settes på opptaket, se 11 Opptak/03 Innstillinger/innstillinger.feature.
    # Lærestedet kan bare velge «alle med samme sum får tilbud» som unntak. Strengere regler er ikke lov.
    Scenariomal: Lik poengsum på siste plass
      Gitt at det er én plass igjen i utdanningskvoten "Ordinær"
      Og at to søkere har samme poengsum på siste plass
      Og at poenglikhetsregelen er "<regel>"
      Når plasstildelingen gjennomføres
      Så får <resultat>

      Eksempler:
        | regel                               | resultat                                 |
        | Alder, eldste først                 | den eldste søkeren tilbud                |
        | Alle med samme sum får tilbud       | begge søkerne tilbud                     |
        | Tidspunkt for levert søknad         | søkeren som søkte først tilbud           |

    @openquestion
    Scenario: Loddtrekning ved lik poengsum
      # ÅPNE SPØRSMÅL: se spørsmålene øverst i fila (Poeng og rangering).
      Gitt at to søkere har samme poengsum på siste plass
      Og at poenglikhetsregelen er "Loddtrekning"
      Når plasstildelingen gjennomføres
      Så får søkeren som vinner loddtrekningen tilbud

  Regel: Søker med tilbudsgaranti får tilbud uavhengig av poengsum

    @openquestion
    Scenario: Tilbudsgaranti tas fra markert utdanningskvote
      # ÅPNE SPØRSMÅL:
      # - Hva skjer når utdanningskvoten er full? I koden gir tilbudsgaranti alltid tilbud, også ut over
      #   antall tilbud som skal gis («Plasstildelingsløpet i Opptak», kap. 3). Skal det gis flere tilbud
      #   enn tallet, skal garantien fortrenge den lavest rangerte, eller skal garantien komme i tillegg?
      Gitt at tilbudsgarantier for "Sykepleie, høst 2027" tas fra utdanningskvoten "Ordinær"
      Og at søkeren "Ola Nordmann" har tilbudsgaranti på "Sykepleie, høst 2027"
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud på "Sykepleie, høst 2027"
      Og tilbudet teller som ett av tilbudene i utdanningskvoten "Ordinær"

    # AVKLART 2026-10-08: Saksbehandler setter tilbudsgaranti på søknaden. Søkeren får tilbud etter
    # reglene for runden, og trenger ingen poengsum.
    # Gap mot koden («Fra saksbehandling til plasstildeling», kap. 2–3 og D4): tilbudsgaranti fra
    # saksbehandlingen når ikke plasstildelingen, og en søknad uten poengsum kommer ikke med i grunnlaget.
    Scenario: Tilbudsgaranti uten poengsum
      Gitt at saksbehandler har satt tilbudsgaranti på søknaden til "Ola Nordmann" på "Sykepleie, høst 2027"
      Og at søknaden ikke har poengsum
      Når plasstildelingen gjennomføres
      Så får søkeren tilbud på "Sykepleie, høst 2027"

  Regel: Poenggrensen beregnes per utdanningskvote

    Scenario: Poenggrense fra siste søker som fikk tilbud
      Gitt at den siste søkeren som fikk tilbud i utdanningskvoten "Ordinær" hadde 52,3 poeng
      Når plasstildelingen gjennomføres
      Så er poenggrensen for utdanningskvoten "Ordinær" 52,3

    Scenario: Alle kvalifiserte fikk tilbud
      Gitt at alle kvalifiserte søkere i utdanningskvoten "Ordinær" fikk tilbud
      Når plasstildelingen gjennomføres
      Så er poenggrensen for utdanningskvoten "Ordinær" «alle kvalifiserte har fått tilbud»

  Regel: Rundetypen avgjør hva som skjer med lavere prioriteter og tidligere tilbud

    Scenario: Søker som får tilbud mister lavere prioriteter i hovedtildeling
      Gitt at søkeren "Kari Nordmann" får tilbud på prioritet 1
      Når plasstildelingen i "Hovedrunde" gjennomføres
      Så får søkeren bortfall på alle lavere prioriteter

    Scenario: Tidligere tilbud beholdes i supplering
      Gitt at søkeren "Kari Nordmann" fikk tilbud på prioritet 2 i "Hovedrunde"
      Og at søkeren fortsatt ikke er høyt nok rangert til prioritet 1
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så beholder søkeren tilbudet på prioritet 2

    Scenario: Opprykk i supplering
      Gitt at søkeren "Kari Nordmann" fikk tilbud på prioritet 2 i "Hovedrunde"
      Og at søkeren nå er høyt nok rangert til prioritet 1
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så får søkeren tilbud på prioritet 1
      Og tilbudet på prioritet 2 faller bort

    Scenario: Ingen nye bortfall i etterfylling
      Gitt at søkeren "Kari Nordmann" har tilbud på prioritet 2 og står på venteliste til prioritet 1
      Når plasstildelingen i runden "Etterfylling" gir søkeren tilbud på prioritet 1
      Så har søkeren tilbud på både prioritet 1 og prioritet 2
      Og søkeren må velge ett av tilbudene

    Scenario: Utdanningstilbud som ikke deltar i runden
      Gitt at "Sykepleie, høst 2027" ikke deltar i suppleringsrunder
      Når plasstildelingen i "Suppleringsrunde" gjennomføres
      Så får ingen søkere nye tilbud på "Sykepleie, høst 2027"
      Og søkere på venteliste får beskjed om at opptaksvedtaket er endelig

    Scenario: Ledige studieplasser i en etterfyllingsrunde
      # AVKLART 2026-10-07: Ledige studieplasser er en egenskap ved etterfylling,
      # ikke en egen rundetype. En etterfyllingsrunde kan åpne for nye søknader
      # på ledige plasser, rangert etter søknadstidspunkt.
      # Søknader samles opp, og opptaksforvalter kjører plasstildeling og publiserer
      # resultatet — som i andre runder. Tilbud gis ikke fortløpende.
      # AVKLART 2026-10-08: Både runden og utdanningstilbudet må åpne for ledige studieplasser.
      # Gap mot koden («Plasstildelingsløpet i Opptak», kap. 9): i dag styres det bare av flagget
      # «tilbyr ledige studieplasser» på utdanningstilbudet, uavhengig av runde.
      Gitt at opptaket har runden "Etterfylling med ledige plasser" med rundetype "Etterfylling"
      Og at runden åpner for søknad på ledige studieplasser
      Og at "Sykepleie, høst 2027" tilbyr ledige studieplasser
      Og at "Sykepleie, høst 2027" har 3 ledige plasser
      Og at 2 søkere står på venteliste til "Sykepleie, høst 2027"
      Når plasstildelingen i runden gjennomføres
      Så får de 2 søkerne på ventelisten tilbud først
      Og den siste plassen går til den kvalifiserte søkeren som søkte først på ledige studieplasser
