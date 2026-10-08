# language: no
# GitHub: #610
#
# Leveranse L4 av seks i initiativet #607 Vitnemålsbehandling. Skilt ut fra
# vitnemålsbehandling.feature 08.10.2026. Kilder, bakgrunn, avgrensninger og
# oversikten over leveransene står i vitnemålsbehandling.md i samme mappe.
#
# Bygger på L2 og L3. Ny datamodell — fagkode på karakterraden — og dermed
# den største og mest usikre leveransen. Må komme etter L3: bygges manuell
# inntasting før det finnes en mekanisme for fagvalg per poengvariant, må den
# aksen ettermonteres på manuelt innlagte fag.
#
@OPT-BEH-BEH-008 @must @draft
Egenskap: Legge inn og endre fag i grunnlaget
  Som saksbehandler i opptak
  ønsker jeg å legge inn fag som bare finnes i opplastet dokumentasjon, og endre fag slik reglene tillater
  slik at søkere med papirdokumentasjon, kompetansebevis eller forbedringer blir riktig poengberegnet.

  Ikke alt grunnlaget finnes på det elektroniske vitnemålet. Noen fag finnes
  bare i opplastet dokumentasjon og må legges inn manuelt. Andre fag står på
  et kompetansebevis, er forbedret, er ført som fritatt, eller overlapper med
  fag på et annet dokument. Saksbehandleren kan legge til og endre slike fag,
  men bare slik en regel tillater. Saksbehandleren kan ikke sette sammen et
  vitnemål søkeren ikke har.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg kan se og endre søknadsbehandling for organisasjonen som behandler saken
    Og jeg er inne på søknaden til en søker

  Regel: Fag som bare finnes i opplastet dokumentasjon legges inn manuelt

    Scenario: Legge inn et fag manuelt
      Gitt søkeren har lastet opp dokumentasjon på et fag som ikke finnes elektronisk
      Når jeg velger faget fra fagkodeverket og oppgir karakterer
      Så inngår faget i beregningsgrunnlaget på linje med de elektroniske fagene
      Og faget kan inngå i realfagspoeng, språkpoeng og kravelementvurdering
      Og det fremgår at faget er lagt inn manuelt
      # AVKLART 21.09.2026: manuelt innlagte fag skal ha fagkode, valgt fra
      # det felles fagkodeverket (NVB_FAG).
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
      # utilgjengelige. For søkeren som bare har papirdokumentasjon, altså
      # nettopp den saksbehandleren trenger verktøyet til, ville verktøyet da
      # løst én av fire oppgaver.
      #
      # Konsekvens: dette er ny datamodell, ikke en justering av kalkulatoren.

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
      Når jeg har valgt faget
      Så er omfanget fylt ut fra fagkodeverket
      Og jeg kan bare endre omfanget når kodeverket tillater det
      # NVB_FAG har både omfang og omfang_overstyrbart. Kodeverket sier altså
      # selv om saksbehandleren har lov til å avvike fra standardomfanget.

    Scenario: Legge inn et fag som ikke finnes i fagkodeverket
      Gitt søkeren har dokumentasjon på et fag som ikke finnes i fagkodeverket
      Når jeg legger inn faget som fritekst med karakter
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

    Scenario: Legge inn fag uten at søkeren har elektronisk vitnemål
      Gitt søkeren ikke har elektroniske vitnemål
      Når jeg åpner grunnlaget på søknaden
      Så kan jeg legge inn fag manuelt uten å velge et vitnemål først
      # Dette er andre halvdel av Confluence-kravet som L1 delvis dekker i
      # «Søker uten elektroniske vitnemål» (vise_elektroniske_vitnemål.feature):
      # uten elektroniske vitnemål skal skjemaet for manuell utfylling alltid
      # vises.

    Scenario: Endre et manuelt innlagt fag
      Gitt jeg har lagt inn et fag manuelt
      Når jeg endrer fagkode, omfang eller karakter på faget
      Så er endringen lagret
      Og poengene er beregnet på nytt

    Scenario: Fjerne et manuelt innlagt fag
      Gitt jeg har lagt inn et fag manuelt
      Når jeg fjerner faget
      Så inngår faget ikke lenger i beregningsgrunnlaget
      Og poengene er beregnet på nytt

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

  Regel: Saksbehandleren kan bare legge til og endre fag slik en regel tillater

    # AVKLART 07.10.2026: vitnemålsbehandleren håndhever at grunnlaget bare
    # endres etter faste regler. Det er de videregående skolene som utsteder
    # vitnemål og avgjør hva som oppfyller vitnemålskravene. Saksbehandleren
    # kan ikke sette sammen et grunnlag søkeren kunne hatt. Vil søkeren ha en
    # annen fagsammensetning, må søkeren kontakte skolen.
    #
    # Der regelen krever en vurdering av dokumentasjonen, er det
    # saksbehandleren som vurderer, og løsningen som håndhever utfallet.
    #
    # Regelen er delt mellom L3 og L4 (besluttet 08.10.2026): her står
    # tillegg og endringer i karakterer. Grensene for fagvalget står i
    # velge_fag_per_poengvariant.feature.

    Scenario: Stryke et fag som overlapper med påbygging på kompetansebevis
      Gitt søkeren har et yrkesfaglig vitnemål
      Og søkeren har påbygging til generell studiekompetanse på et kompetansebevis
      Og jeg har vurdert at et fag på vitnemålet overlapper med et fag på kompetansebeviset
      Når jeg legger vitnemålet og kompetansebeviset til grunn
      Så kan jeg stryke faget fra vitnemålet
      # AVKLART 07.10.2026: hvilke fag som overlapper, er saksbehandlerens
      # vurdering, fordi reglene har mange unntak. Hovedreglene: norsk
      # strykes på vitnemålet og hentes fra kompetansebeviset. Matematikk og
      # naturfag strykes fra vitnemålet bare når faget er ført med henholdsvis
      # 224 og 140 timer samlet på kompetansebeviset.

    Scenario: Legge til en forbedring fra et kompetansebevis
      Gitt jeg har lagt et vitnemål til grunn
      Og søkeren har forbedret et fag på et kompetansebevis
      Når jeg legger forbedringen til grunnlaget
      Så erstatter forbedringen den tidligere karakteren i faget

    Scenario: Legge til et nytt fag fra et kompetansebevis
      Gitt jeg har lagt et vitnemål til grunn
      Og søkeren har et nytt fag på et kompetansebevis
      Og faget dekker spesielle opptakskrav eller gir språk- eller realfagspoeng
      Når jeg legger faget til grunnlaget
      Så inngår faget i grunnlaget

    Scenario: Nytt fag på kompetansebevis som ikke kan legges til
      Gitt søkeren har et nytt fag på et kompetansebevis
      Og faget verken dekker spesielle opptakskrav eller gir språk- eller realfagspoeng
      Når jeg ser fagene på kompetansebeviset
      Så ser jeg ikke muligheten til å legge faget til grunnlaget

    Scenario: Privatisteksamen erstatter både standpunkt- og eksamenskarakter
      Gitt søkeren har tatt et fag på nytt som privatist
      Og jeg har vurdert at den nye karakteren lønner seg for søkeren
      Når jeg legger den nye eksamenskarakteren til grunnlaget
      Så erstatter den både den gamle standpunktkarakteren og den gamle eksamenskarakteren
      # AVKLART 07.10.2026: om erstatningen lønner seg for søkeren, avgjør
      # saksbehandleren. Bare ny, utsatt og særskilt prøve kan kombineres med
      # den gamle standpunktkarakteren.

    Scenario: Legge inn opprinnelig karakter på et fag fritatt etter tidligere reform
      Gitt et fag på vitnemålet er ført som fritatt
      Og jeg har vurdert at faget er tatt med karakter i norsk videregående skole i en tidligere reform
      Når jeg legger inn den opprinnelige karakteren på faget
      Så inngår faget med den opprinnelige karakteren i grunnlaget
      # AVKLART 07.10.2026: saksbehandleren legger den opprinnelige
      # karakteren inn på fritaksfaget, og vurderer selv hva fritaket bygger
      # på. Den opprinnelige karakteren må være dokumentert (Samordna opptaks
      # wiki, «Poengberegning norske søkere»).

    Scenario: Fag fritatt på grunnlag av fag tatt i utlandet får ikke karakter
      Gitt et fag på vitnemålet er ført som fritatt
      Og jeg har vurdert at fritaket bygger på et fag tatt i utlandet
      Når jeg ser faget i grunnlaget
      Så ser jeg ikke muligheten til å legge inn karakter på faget
      # Utenlandske karakterer konverteres ikke i disse tilfellene, og faget
      # skal ikke være med i beregningen (samme kilde).

    Scenario: Markere at et fag med forsøkskode gir realfagspoeng
      Gitt vitnemålet har et R94-fag med fagkode som begynner på «FS»
      Og jeg har vurdert at faget gir realfagspoeng
      Når jeg markerer at faget gir realfagspoeng
      Så sendes markeringen med grunnlaget til beregningen
      # AVKLART 07.10.2026: kontrollmotoren gir ikke realfagspoeng for
      # forsøkskoder i R94 automatisk (Samordna opptaks wiki,
      # «Realfagspoeng»). Saksbehandleren retter det i vitnemålsbehandleren.
