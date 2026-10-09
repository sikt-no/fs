# language: no
# GitHub: #412
@OPT-SØK-SØK-010 @must @implemented
Egenskap: Se meldinger om egne søknader
  Som en søker
  ønsker jeg å se meldingene jeg har fått om søknadene mine
  slik at jeg får med meg kvitteringer, mangler og annen beskjed fra lærestedet.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse

  Regel: Meldingslisten viser søkerens egne meldinger

    Scenario: Søkeren ser meldingene sine
      Gitt at søkeren har mottatt meldinger
      Når søkeren åpner meldingsoversikten
      Så vises søkerens meldinger i en liste

    Scenario: Meldingene er sortert med nyeste øverst
      Gitt at søkeren har mottatt meldinger på ulike tidspunkter
      Når søkeren åpner meldingsoversikten
      Så vises meldingene sortert etter når de ble sendt, med nyeste øverst

    Scenario: Hver melding viser tittel, dato og avsender
      Gitt at søkeren har mottatt meldinger
      Når søkeren åpner meldingsoversikten
      Så vises tittel, dato og avsender for hver melding i listen

    Scenario: Melding uten avsender
      Gitt at søkeren har mottatt en melding uten avsender
      Når søkeren åpner meldingsoversikten
      Så vises "Min kompetanse" som avsender for meldingen

    @planned
    Scenario: Kvitteringer i et samordna opptak har Min kompetanse som avsender
      Gitt at søkeren har mottatt meldinger av typen KVITTERING for en søknad i et samordna opptak
      Når søkeren åpner meldingsoversikten
      Så vises "Min kompetanse" som avsender for kvitteringene

    Scenario: Uleste meldinger er merket
      Gitt at søkeren har både leste og uleste meldinger
      Når søkeren åpner meldingsoversikten
      Så er de uleste meldingene merket som ulest

    Scenario: Mangelbrev er merket som viktig
      Gitt at søkeren har mottatt en melding av typen MANGEL
      Når søkeren åpner meldingsoversikten
      Så er meldingen av typen MANGEL merket som viktig

    Scenario: Ny melding vises uten at siden lastes på nytt
      Gitt at søkeren ser meldingsoversikten
      Når søkeren mottar en ny melding
      Så vises den nye meldingen i listen uten at søkeren laster siden på nytt

    Scenario: Søkeren har ingen meldinger
      Gitt at søkeren ikke har mottatt meldinger
      Når søkeren åpner meldingsoversikten
      Så får søkeren beskjed om at det ikke finnes meldinger

  Regel: Søkeren kan filtrere meldingene

    @deprecated
    Scenario: Tilgjengelige meldingstyper i filter (avvikles)
      Når søkeren åpner meldingstypefilteret
      Så inneholder filteret meldingstypene søkeren har mottatt meldinger av
      Og "Alle" er valgt som standard

    @planned
    Scenario: Tilgjengelige meldingstyper i filter
      Når søkeren åpner meldingstypefilteret
      Så inneholder filteret meldingstypene søkeren har mottatt meldinger av, unntatt GENERELL
      Og "Alle" er valgt som standard

    @deprecated
    Scenariomal: Filtrere på meldingstype <type> (avvikles)
      Gitt at søkeren har meldinger av flere meldingstyper
      Når søkeren velger <type> som filter
      Så vises kun meldinger av typen <type>

      Eksempler:
        | type          |
        | KVITTERING    |
        | MANGEL        |
        | GENERELL      |
        | TIDLIG_OPPTAK |

    @planned
    Scenariomal: Filtrere på meldingstype <type>
      Gitt at søkeren har meldinger av flere meldingstyper
      Når søkeren velger <type> som filter
      Så vises kun meldinger av typen <type>

      Eksempler:
        | type          |
        | KVITTERING    |
        | MANGEL        |
        | TIDLIG_OPPTAK |

    Scenario: Tilgjengelige år i filter
      Når søkeren åpner årsfilteret
      Så inneholder filteret årene søkeren har mottatt meldinger i
      Og "Alle" er valgt som standard

    Scenario: Filtrere på år
      Gitt at søkeren har meldinger fra flere år
      Når søkeren velger et år som filter
      Så vises kun meldinger mottatt det året

    Scenario: Vise kun uleste meldinger
      Gitt at søkeren har både leste og uleste meldinger
      Når søkeren velger å vise kun uleste meldinger
      Så vises kun de uleste meldingene

    Scenario: Kombinere filtre
      Når søkeren kombinerer meldingstype, år og uleste
      Så vises kun meldinger som matcher alle kriteriene

    Scenario: Ingen meldinger matcher filteret
      Gitt at søkeren har meldinger
      Når søkeren velger et filter ingen av meldingene matcher
      Så får søkeren beskjed om at ingen meldinger samsvarer med valgt filter
      Og beskjeden skiller seg fra beskjeden om at søkeren ikke har meldinger

  Regel: Søkeren ser hele meldingen

    Scenario: Søkeren åpner en melding
      Gitt at søkeren har mottatt en melding
      Når søkeren åpner meldingen
      Så vises dato og klokkeslett for når meldingen ble mottatt
      Og tittelen og innholdet i meldingen vises
      Og signaturen til avsenderen vises når avsenderen har en signatur

  Regel: Meldinger merkes som lest når de åpnes

    Scenario: Søkeren åpner en ulest melding
      Gitt at søkeren har en ulest melding
      Når søkeren åpner meldingen
      Så vises innholdet i meldingen
      Og meldingen er merket som lest

  Regel: Søkeren ser antall uleste meldinger

    Scenario: Antall uleste meldinger vises i toppmenyen
      Gitt at søkeren har uleste meldinger
      Når søkeren er på en side i Min kompetanse
      Så vises antall uleste meldinger i toppmenyen

    Scenario: Toppmenyen viser ikke antall når alle meldinger er lest
      Gitt at søkeren ikke har uleste meldinger
      Når søkeren er på en side i Min kompetanse
      Så vises ikke antall uleste meldinger i toppmenyen

    Scenario: Antallet går ned når søkeren leser en melding
      Gitt at søkeren har uleste meldinger
      Når søkeren åpner en ulest melding
      Så går antall uleste meldinger i toppmenyen ned med én

    Scenario: Antallet går opp når søkeren mottar en ny melding
      Gitt at søkeren er på en side i Min kompetanse
      Når søkeren mottar en ny melding
      Så går antall uleste meldinger i toppmenyen opp uten at søkeren laster siden på nytt

    Scenario: Min oversikt viser antall uleste meldinger
      Gitt at søkeren har uleste meldinger
      Når søkeren åpner Min oversikt
      Så vises antall uleste meldinger
      Og søkeren kan gå videre til meldingsoversikten

    Scenario: Min oversikt når alle meldinger er lest
      Gitt at søkeren ikke har uleste meldinger
      Når søkeren åpner Min oversikt
      Så får søkeren beskjed om at det ikke finnes uleste meldinger
      Og søkeren kan gå videre til meldingsoversikten

  Regel: Kvitteringsmeldinger viser hvilken søknad de gjelder

    Scenario: Søkeren åpner en kvittering for en levert søknad
      Gitt at søkeren har mottatt en melding av typen KVITTERING for en levert søknad
      Når søkeren åpner meldingen
      Så vises hvilket opptak kvitteringen gjelder
      Og utdanningstilbudene i søknaden vises i prioritert rekkefølge

    Scenario: Kvittering fra et lokalt opptak
      Gitt at søkeren har levert en søknad i et lokalt opptak
      Når søkeren åpner kvitteringen for søknaden
      Så står det at lærestedet som har opptaket, har mottatt søknaden

    Scenario: Kvitteringen viser fristene som gjaldt da den ble sendt
      Gitt at søkeren har mottatt en melding av typen KVITTERING
      Og en frist i opptaket har gått ut etter at kvitteringen ble sendt
      Når søkeren åpner meldingen
      Så viser kvitteringen den samme teksten som da den ble sendt

  Regel: Mangelbrev viser hva søkeren må gjøre

    Scenario: Søkeren åpner et mangelbrev
      Gitt at søkeren har mottatt en melding av typen MANGEL
      Når søkeren åpner meldingen
      Så vises fristen for å laste opp dokumentasjon
      Og utdanningstilbudene i søknaden vises i prioritert rekkefølge
      Og søkeren kan gå videre til dokumentasjonssiden for søknaden

  Regel: Søkeren får kvittering for endringer på søknaden

    Scenario: Søkeren får kvittering for egne endringer
      Gitt at søkeren har en søknad i et opptak
      Når søkeren gjør en av disse endringene
        | hendelse                            |
        | leverer søknaden                    |
        | trekker søknaden                    |
        | endrer søknaden                     |
        | endrer rekkefølgen på studieønskene |
        | endrer studieønskene                |
        | laster opp nye dokumenter           |
        | søker om tidlig opptak              |
      Så mottar søkeren en melding av typen KVITTERING om endringen

    @draft @openquestion
    Scenario: Søkeren får kvittering for svar på tilbud
      # ÅPNE SPØRSMÅL:
      # - Skal kvitteringen vise hvilke tilbud og ventelisteplasser søkeren har svart ja og nei til, slik skissen i Figma gjør?
      # - Skal kvitteringen vise svarfristen, med at svaret kan endres fram til fristen?
      Gitt at søkeren har fått tilbud om studieplass
      Når søkeren svarer på tilbudet
      Så mottar søkeren en melding av typen KVITTERING om svaret

    Scenario: Søkeren får kvittering for saksbehandlerens endringer
      Gitt at søkeren har en søknad i et opptak
      Når saksbehandleren gjør en av disse endringene på søkerens vegne
        | hendelse                            |
        | leverer søknaden                    |
        | trekker søknaden                    |
        | endrer søknaden                     |
        | endrer rekkefølgen på studieønskene |
        | endrer studieønskene                |
        | laster opp dokumentasjon            |
        | gjenoppretter søknaden              |
      Så mottar søkeren en melding av typen KVITTERING som opplyser at saksbehandleren gjorde endringen

    Scenario: Søkeren får melding når saksbehandleren svarer på tilbudet
      Gitt at søkeren har fått tilbud om studieplass
      Når saksbehandleren svarer på tilbudet på søkerens vegne
      Så mottar søkeren en melding av typen GENERELL om at saksbehandleren har svart på tilbudet

  @draft @openquestion
  Regel: Søkeren får melding om svar på søknaden
    # ÅPNE SPØRSMÅL:
    # - Designet mangler (TOT-2518). Hva skal meldingen inneholde?
    # - Hvilken meldingstype skal meldingen ha i filteret?

    Scenario: Søkeren får melding om at svaret på søknaden er klart
      Gitt at søkeren har en søknad i et opptak
      Når søkeren er med i en runde eller plasstildeling i opptaket
      Så mottar søkeren en melding om at svaret på søknaden er klart
