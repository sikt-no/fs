# language: no
# GitHub: #610
#
# Leveranse L4b i initiativet #607 Vitnemålsbehandling. Skilt ut fra
# legge_inn_og_endre_fag.feature (nå endre_fag_i_grunnlaget.feature, L4a)
# 03.11.2026, i gjennomgangen av L3 og L4 med teamet. Kilder, bakgrunn,
# avgrensninger og oversikten over leveransene står i vitnemålsbehandling.md
# i samme mappe.
#
# Bygger på L2 og L3, og leveres etter L4a. Ny datamodell: fagkode på
# karakterraden. Reserveløsningen i drift i dag, lagreVitnemalUtregning med
# karakterrader uten fag, er en kalkulator uten fagkode: den gir
# karakterpoeng, men ikke realfagspoeng, språkpoeng eller kravelementer.
#
# Reglene for beregning og lagring i L2 («Poengene
# beregnes og lagres når saksbehandleren bruker dem») gjelder også her
# (avklart 03.11.2026, endret 11.11.2026): saksbehandleren beregner poengene
# uten å lagre, og grunnlaget kontrolleres, poengene beregnes og alt lagres
# når saksbehandleren velger å bruke poengene. Endringer hører til
# vitnemålet de er gjort for. Regelen for leserettighet står i
# vitnemålsbehandling.md.
#
@OPT-BEH-BEH-037 @must @planned
Egenskap: Legge inn vitnemål manuelt
  Som saksbehandler i opptak
  ønsker jeg å legge inn fag og karakterer fra et vitnemål som ikke finnes elektronisk
  slik at søkere uten elektronisk vitnemål også blir poengberegnet.

  Saksbehandleren legger inn fagene i en kalkulator. Kalkulatoren er ikke et
  komplett vitnemål: den har bare fagene og karakterene som trengs for å
  beregne poengene, og ingen av opplysningene er påkrevd. Når vitnemålet er
  lagt inn, ligger det under vitnemålene og behandles som et elektronisk
  vitnemål. Kravelementene vurderes under spesielle opptakskrav.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg er inne på søknaden til en søker

  Regel: Saksbehandleren legger inn fagene i en kalkulator

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenario: Legge inn vitnemålet manuelt
      Gitt søkeren har dokumentasjon på et vitnemål som ikke finnes elektronisk
      Når jeg velger å legge inn vitnemålet manuelt
      Så kan jeg legge inn ett fag per rad med disse opplysningene
        | felt                         |
        | Omfang                       |
        | Fag                          |
        | Fagnavn                      |
        | Standpunktkarakter           |
        | Eksamenskarakter             |
        | Forbedret standpunktkarakter |
        | Forbedret eksamenskarakter   |
      Og ingen av opplysningene er påkrevd
      # AVKLART 03.11.2026: kalkulatoren er ikke et komplett vitnemål.
      # Saksbehandleren registrerer ingen opplysninger om selve vitnemålet
      # (utstedt dato, førstegangsvitnemål, GSK), og ingen av feltene er
      # påkrevd. Feltene er de samme som i skissen «Steg 2 Grunnlag – Legg inn
      # vitnemål manuelt». Kravelementer er ikke en del av kalkulatoren, men
      # vurderes under spesielle opptakskrav, som for et elektronisk
      # vitnemål.

    Scenario: Legge inn vitnemålet uten at søkeren har elektronisk vitnemål
      Gitt søkeren ikke har elektroniske vitnemål
      Når jeg åpner grunnlaget på søknaden
      Så kan jeg legge inn vitnemålet manuelt uten å velge et vitnemål først
      # Dette er andre halvdel av Confluence-kravet som L1 delvis dekker i
      # «Søker uten elektroniske vitnemål» (vise_elektroniske_vitnemål.feature):
      # uten elektroniske vitnemål skal skjemaet for manuell utfylling alltid
      # vises.

    Scenario: Legge inn et fag fra fagkodeverket
      Gitt søkeren har dokumentasjon på et fag som ikke finnes elektronisk
      Når jeg velger faget fra fagkodeverket og oppgir karakterer
      Så er fagnavnet fylt ut fra fagkodeverket
      Og faget inngår i beregningsgrunnlaget på linje med de elektroniske fagene
      Og faget kan inngå i realfagspoeng, språkpoeng og kravelementvurdering
      # AVKLART 21.09.2026: manuelt innlagte fag skal ha fagkode, valgt fra
      # det felles fagkodeverket (NVB_FAG), når faget finnes der.
      #
      # Dette er det største avviket fra dagens løsning, og det er bevisst.
      # Verken FS-klientens SKOLEPOENGOPPLELEMENT (linjenr, karaktertall,
      # vekt) eller den allerede migrerte VitnemalKarakterrad i poeng.graphqls
      # (radnummer, karakterer, vekting) har fagkode. Begge taster inn
      # karakterer uten å vite hvilke fag de tilhører.
      #
      # Begrunnelse for endringen: kontrollmotoren trenger fagkode. Uten den
      # kan et manuelt innlagt resultat bare påvirke snittet, altså
      # karakterpoeng — realfagspoeng, språkpoeng og kravelementvurdering er
      # utilgjengelige.
      #
      # AVKLART 03.11.2026: fagnavnet fylles ut fra fagkodeverket når
      # fagkoden er valgt.

    Scenario: Velge et utgått fag
      Gitt søkeren har dokumentasjon på et fag fra en tidligere reform
      Når jeg velger faget fra fagkodeverket
      Så kan jeg velge faget selv om det ikke lenger er i bruk
      Og det fremgår at faget er utgått
      # AVKLART 21.09.2026: hele kodeverket er valgbart, også inaktive fag og
      # fag fra tidligere reformer. Manuell inntasting brukes nettopp på
      # gammel dokumentasjon — å begrense til aktive fag ville tvunget
      # saksbehandleren til å gjøre fagkonverteringen i hodet.
      #
      # Verifisert i FS-klienten: NVB_FAG har inaktiv, reformkode,
      # aarstall_fra, aarstall_til_undervist og aarstall_til_eksamen. Utgåtte
      # fag ligger i kodeverket og er markert der — de må ikke gjenskapes.
      # Klienten har også en egen fagkonverterer (w_fagkonverterer,
      # fagkode_fra[] → fagkode_til[]) for å mappe gamle reformfag mot nye.
      #
      # AVKLART 04.11.2026: saksbehandleren kan både velge det utgåtte faget
      # som det er, og konvertere det til faget i en nyere reform («Konvertere
      # et utgått fag til faget i en nyere reform»). Velges det utgåtte faget,
      # kan saksbehandleren markere at det gir realfagspoeng eller
      # språkpoeng, eller dekker et kravelement, når kontrollmotoren ikke
      # kjenner det igjen (L4a, «Saksbehandleren kan overstyre kontrollmotoren
      # for et fag»).

    @draft @could @openquestion
    # ÅPNE SPØRSMÅL:
    # - Hvordan konverteres et fag som svarer til flere fag i den nyere
    #   reformen, eller flere fag som svarer til ett? FS-klienten konverterer
    #   fra en liste med fagkoder til en annen (fagkode_fra[] →
    #   fagkode_til[]).
    # - Hvem vedlikeholder hvilke fag som svarer til hverandre, og hvor?
    #   Begge spørsmålene sjekkes med Geir Magne Vangen, som skrev den
    #   tekniske beskrivelsen av FS-klienten, eller i FS-klientens kode
    #   (w_fagkonverterer). Avtalt 04.11.2026.
    #   Innspill på siden med åpne spørsmål 04.–05.11.2026, ikke avklart:
    #   Geir Magne Vangen skriver at tabellen nvb_fagekv (fagkode, faggruppe)
    #   lar saksbehandleren legge inn fag fra én reform som tillegg på et
    #   dokument fra en annen, at dataene kommer med NVB-importen fra SODA,
    #   og at den neppe er vedlikeholdt på lenge. Ingrid Grimstad Helset
    #   skriver at kontrollmotoren i NVB (som Team Puff bygger på nytt) har
    #   lister over fagkoder som dekker fagkrav og studiekompetansekrav, at
    #   Sikt vedlikeholder listene og HK-dir bestemmer innholdet, og at det
    #   ikke er det samme som hvilke fag som tilsvarer hverandre på tvers av
    #   reformer. Det har Utdanningsdirektoratet oversikter over. Ellers
    #   vurderer saksbehandleren selv hvilke fag som tilsvarer hverandre.
    Scenario: Konvertere et utgått fag til faget i en nyere reform
      Gitt jeg har lagt inn et fag fra en tidligere reform manuelt
      Og faget har et tilsvarende fag i en nyere reform
      Når jeg velger å konvertere faget
      Så er faget erstattet av det tilsvarende faget i den nyere reformen
      Og karakterene på faget er beholdt
      # AVKLART 04.11.2026: fagkonvertereren fra FS-klienten videreføres, i
      # tillegg til at saksbehandleren kan velge det utgåtte faget som det
      # er. Også åpent i den tekniske beskrivelsen av vitnemålsbehandling
      # (G. M. Vangen).
      #
      # AVKLART 04.11.2026: karakterene beholdes. Konverteringen gjør bare om
      # fagkoden.
      #
      # AVKLART 04.11.2026: alt som hører til fagkonvertereren, har
      # prioritet could. Det er ikke nødvendig for å levere L4b, fordi
      # saksbehandleren kan velge det utgåtte faget og overstyre
      # kontrollmotoren for faget (L4a).

    Scenario: Omfanget hentes fra fagkodeverket
      Gitt jeg legger inn et fag manuelt
      Når jeg har valgt faget fra fagkodeverket
      Så er omfanget fylt ut fra fagkodeverket
      Og jeg kan bare endre omfanget når kodeverket tillater det
      # NVB_FAG har både omfang og omfang_overstyrbart. Kodeverket sier altså
      # selv om saksbehandleren har lov til å avvike fra standardomfanget.

    Scenario: Legge inn et fag som ikke finnes i fagkodeverket
      Gitt søkeren har dokumentasjon på et fag som ikke finnes i fagkodeverket
      Når jeg legger inn fagnavn og karakter uten fagkode
      Så inngår faget i snittet
      Men faget inngår ikke i realfagspoeng, språkpoeng eller kravelementvurdering
      Og det fremgår for meg at faget har denne begrensningen
      # AVKLART 21.09.2026: fritekst er en nødløsning, ikke en likestilt
      # inngang. Uten fagkode vet ikke kontrollmotoren hva faget er, og kan
      # bare legge karakteren i snittet. Begrensningen skal være synlig i
      # øyeblikket saksbehandleren velger fritekst, ikke oppdages senere når
      # et poeng mangler.

    Scenario: Legge inn en fagkode som ikke finnes i fagkodeverket
      Gitt søkeren har dokumentasjon på et fag med en fagkode som ikke finnes i fagkodeverket
      Når jeg legger inn fagkoden, fagnavnet og karakteren
      Så er faget lagt inn med fagkoden
      Og faget inngår i snittet
      Men faget inngår ikke i realfagspoeng, språkpoeng eller kravelementvurdering
      Og det fremgår for meg at fagkoden ikke finnes i fagkodeverket
      # AVKLART 05.11.2026: saksbehandleren kan legge inn ukjente fagkoder.
      # Innspill fra Ingrid Grimstad Helset på siden med åpne spørsmål
      # 05.11.2026. Kontrollmotoren kjenner ikke fagkoden, så faget har den
      # samme begrensningen som et fag uten fagkode. Saksbehandleren kan
      # markere at faget gir realfagspoeng eller språkpoeng, eller dekker et
      # kravelement (L4a, «Saksbehandleren kan overstyre kontrollmotoren for
      # et fag»).

    Scenario: Manuelt innlagte fag skilles fra elektroniske
      Gitt jeg har lagt inn et fag manuelt
      Når jeg ser fagene i beregningsgrunnlaget
      Så ser jeg hvilke fag som kommer fra det elektroniske vitnemålet
      Og jeg ser hvilke fag jeg har lagt inn selv
      # Dette er et krav om sporbarhet, ikke om utforming. Et manuelt innlagt
      # fag bygger på saksbehandlerens vurdering av et opplastet dokument, og
      # må kunne etterprøves som noe annet enn data fra NVB.

    Scenario: Endre et manuelt innlagt fag
      Gitt jeg har lagt inn et fag manuelt
      Når jeg endrer fagkode, omfang eller karakter på faget
      Og jeg velger å bruke poengene
      Så er endringen lagret
      Og poengene er beregnet på nytt
      # Endret 11.11.2026: endringen lagres, og poengene beregnes, når
      # saksbehandleren velger å bruke poengene, som i L2.

    Scenario: Fjerne et manuelt innlagt fag
      Gitt jeg har lagt inn et fag manuelt
      Når jeg fjerner faget
      Og jeg velger å bruke poengene
      Så inngår faget ikke lenger i beregningsgrunnlaget
      Og poengene er beregnet på nytt
      # Endret 11.11.2026: endringen lagres, og poengene beregnes, når
      # saksbehandleren velger å bruke poengene, som i L2.

    # AVKLART 08.10.2026: skjemaet for manuelt innlagte fag håndhever ikke
    # hvilke karaktertyper faget kan ha. Saksbehandleren har ansvaret for at
    # det ikke legges inn standpunktkarakter på et fag søkeren har tatt som
    # privatist (privatister får bare eksamenskarakter, jf. Samordna opptaks
    # wiki, «Poengberegning norske søkere»). Fagkodeverket (NVB_FAG) har
    # opplysningene som skulle til (har_standpunkt_elev og
    # har_standpunkt_privatist), men håndheving ville krevd at
    # saksbehandleren oppgir om faget er tatt som elev eller privatist.
    # Registreringen er dermed mindre robust: en karakter som ikke kan finnes,
    # kan gå inn i snittet uten at løsningen oppdager det.
    #
    # Dette gjelder hvilke karaktertyper et fag kan ha. Hvilke verdier en
    # karakter kan ha, står i regelen «Karakterer legges inn som heltall fra 1
    # til 6».

  Regel: Karakterer legges inn som heltall fra 1 til 6

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    Scenariomal: Karakter som ikke er et heltall fra 1 til 6, kan ikke legges inn
      Gitt jeg legger inn et fag i kalkulatoren
      Når jeg legger inn <karakter> som <karaktertype>
      Så ser jeg at karakteren må være et heltall fra 1 til 6
      Og jeg kan ikke bruke poengene før karakteren er rettet

      Eksempler:
        | karakter | karaktertype                 |
        | 0        | standpunktkarakter           |
        | 7        | eksamenskarakter             |
        | 4,5      | forbedret standpunktkarakter |
        | B        | forbedret eksamenskarakter   |
      # AVKLART 03.11.2026: bare heltall fra 1 til 6 kan legges inn, i alle
      # karakterfeltene. Det er viktig for utenlandske vitnemål:
      # saksbehandleren regner om karakterene selv før de legges inn, og
      # løsningen regner ikke om. Teksten på beskjeden hører i
      # legge_inn_vitnemål_manuelt.design.md.

    Scenario: Legge inn et fag som er bestått uten tallkarakter
      Gitt søkeren har dokumentasjon på et fag som er bestått uten tallkarakter
      Når jeg legger inn faget som bestått
      Så inngår faget ikke i snittet
      Men faget teller i omfanget
      Og faget kan inngå i vurderingen av kravelementene
      # AVKLART 04.11.2026: fag med bestått/ikke bestått uten tallkarakter,
      # for eksempel enkelte fag fra utlandet, kan legges inn som bestått.
      # Faget gir ikke karakterpoeng, men teller i omfanget og kan dekke et
      # kravelement. Spørsmålet ble stilt i gjennomgangen 03.11.2026.

  Regel: Kalkulatoren legges til grunn per poengvariant

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    # AVKLART 03.11.2026: kalkulatoren legges til grunn per poengvariant, på
    # samme måte som et elektronisk vitnemål i L3
    # (velge_fag_per_poengvariant.feature).

    Scenario: Legge kalkulatoren til grunn for en poengvariant
      Gitt jeg har lagt inn fag i kalkulatoren
      Når jeg legger kalkulatoren til grunn for en poengvariant
      Så er poengene for poengvarianten beregnet fra fagene i kalkulatoren

    Scenario: Legge kalkulatoren til grunn i kvoten for førstegangsvitnemål
      Gitt jeg har lagt inn fag i kalkulatoren
      Og jeg har vurdert at dokumentasjonen er et førstegangsvitnemål
      Når jeg behandler poengvarianten for kvoten for førstegangsvitnemål
      Så kan jeg legge kalkulatoren til grunn for poengvarianten
      # AVKLART 03.11.2026: kalkulatoren har ingen opplysning om
      # førstegangsvitnemål. Om dokumentasjonen gir kvoten for
      # førstegangsvitnemål, er saksbehandlerens vurdering.

    Scenario: Fagene i kalkulatoren huskes når jeg bytter vitnemål
      Gitt jeg har lagt inn fag i kalkulatoren
      Og jeg har byttet til et elektronisk vitnemål
      Når jeg velger å legge inn vitnemålet manuelt igjen
      Så er fagene jeg la inn, der igjen
      # AVKLART 03.11.2026: kalkulatoren regnes som et eget vitnemål, og
      # endringene huskes på samme måte som i L3 («Endringer på et vitnemål
      # huskes når jeg bytter tilbake»).
