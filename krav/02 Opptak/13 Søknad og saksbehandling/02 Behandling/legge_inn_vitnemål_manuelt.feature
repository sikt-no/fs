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
# Reglene for beregning og lagring fra L2 gjelder også her (avklart
# 03.11.2026): poengene beregnes når saksbehandleren velger det, en endring
# lagres først når poengene er beregnet uten feil, og endringer hører til
# vitnemålet de er gjort for. Regelen for leserettighet står i
# vitnemålsbehandling.md.
#
@OPT-BEH-BEH-037 @must @draft
Egenskap: Legge inn vitnemål manuelt
  Som saksbehandler i opptak
  ønsker jeg å legge inn fag og karakterer fra et vitnemål som ikke finnes elektronisk
  slik at søkere uten elektronisk vitnemål også blir poengberegnet.

  Saksbehandleren legger inn fagene i en kalkulator. Kalkulatoren er ikke et
  komplett vitnemål: den har bare fagene og karakterene som trengs for å
  beregne poengene, og ingen av opplysningene er påkrevd. Kravelementene
  vurderes under spesielle opptakskrav, ikke i kalkulatoren.

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
      # vurderes under spesielle opptakskrav.

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

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Skal fagkonvertereren fra FS-klienten videreføres, så et fag fra en
    #   tidligere reform kan konverteres til et fag i en nyere reform? Også
    #   åpent i den tekniske beskrivelsen av vitnemålsbehandling
    #   (G. M. Vangen, lest 03.11.2026). Samme spørsmål står i L4a («Et
    #   tilleggsfag må være fra samme reform som vitnemålet»).
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
      # Om den skal videreføres er ikke avklart her.

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
      Og jeg velger å beregne poengene
      Så er endringen lagret
      Og poengene er beregnet på nytt
      # Endret 03.11.2026: endringen lagres først når poengene er beregnet
      # uten feil, som i L2.

    Scenario: Fjerne et manuelt innlagt fag
      Gitt jeg har lagt inn et fag manuelt
      Når jeg fjerner faget
      Og jeg velger å beregne poengene
      Så inngår faget ikke lenger i beregningsgrunnlaget
      Og poengene er beregnet på nytt
      # Endret 03.11.2026: endringen lagres først når poengene er beregnet
      # uten feil, som i L2.

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

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Hvordan legges fag med bestått/ikke bestått uten tallkarakter inn,
    #   for eksempel enkelte fag fra utlandet? Skal de kunne legges inn uten
    #   karakter, og telle i omfanget, eller ikke legges inn i det hele tatt?
    Scenariomal: Karakter som ikke er et heltall fra 1 til 6, kan ikke legges inn
      Gitt jeg legger inn et fag i kalkulatoren
      Når jeg legger inn <karakter> som <karaktertype>
      Så ser jeg at karakteren må være et heltall fra 1 til 6
      Og jeg kan ikke beregne poengene før karakteren er rettet

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

  Regel: Kalkulatoren legges til grunn per poengvariant

    Bakgrunn:
      Gitt jeg har rettighet til å se og endre søknadsbehandling ved organisasjonen som behandler saken

    # AVKLART 03.11.2026: kalkulatoren legges til grunn per poengvariant, på
    # samme måte som et elektronisk vitnemål i L3
    # (velge_fag_per_poengvariant.feature).

    Scenario: Legge kalkulatoren til grunn for en poengvariant
      Gitt jeg har lagt inn fag i kalkulatoren
      Når jeg legger kalkulatoren til grunn for en poengvariant
      Og jeg velger å beregne poengene
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
      # endringene huskes på samme måte som i L2 («Endringer på et vitnemål
      # huskes når jeg bytter tilbake»).
