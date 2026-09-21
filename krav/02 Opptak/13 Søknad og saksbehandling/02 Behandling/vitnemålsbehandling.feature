# language: no
# GitHub: #607
#
# KILDER OG ETTERPRØVBARHET
#
# Kravet erstatter to funksjoner i FS-klienten: vitnemålsbehandling
# (FS143.001 Vg.dokument, w_vitnemalsbehandling.srw) og vitnemålskalkulatoren
# (w_vitnemalskalkulatur.srw), begge i fsb10c, gitlab.sikt.no/fs/fs-klient.
# Referanser til tabeller, kolonner og tjenesteklasser står her for at
# påstandene skal kunne etterprøves — aldri som føring for datamodell eller
# teknologi. Ny funksjonalitet bygges i FS Admin.
#
# Designgrunnlag: Confluence PFS 4582014995 «Vitnemål og kvalifikasjoner
# (Steg 2 - sekvensiell saksbehandling)», med designskisser i Figma
# (FS-Admin - Seksjon Opptak, node 10119-38734). Jira-initiativ SOPP-184.
#
# Ny stack: opptak-subgraph (experimental) har allerede beregnPoengAutomatisk,
# vurderKravelementerAutomatisk, settGskKonklusjonFraVitnemaal og
# lagreVitnemalUtregning. VGS-resultatene kommer fra KREG/NVB
# (kompetansebevisByNasjonalId).
#
# HVORFOR KRAVET TRENGS
#
# Den automatiske saksbehandlingen stopper når søkeren har flere vitnemål.
# vurderKravelementerAutomatisk hopper over hele saken «uten entydig
# vitnemål», og beregnPoengAutomatisk har samme forutsetning
# (FlereVitnemaalException). For generell studiekompetanse er dette allerede
# løst semi-automatisk med settGskKonklusjonFraVitnemaal, der saksbehandleren
# peker ut ett vgdoknr. For poengberegning og kravelementvurdering finnes
# ingen tilsvarende inngang. Det er hullet denne featuren fyller.
#
# AVKLARINGSRUNDE 21.09.2026
#
# Ti åpne spørsmål ble besluttet i gjennomgang med produkteier. Beslutningene
# står som AVKLART-kommentarer ved det scenarioet de gjelder, med begrunnelse.
# Ett nytt spørsmål ble oppdaget under omskrivingen og står som @openquestion
# (karaktertyper for privatistfag) — det blokkerer ikke hovedflyten.
#
# Kravet står fortsatt som @draft. Innholdet er avklart, men leveransekuttet
# er det ikke: featuren er for stor til én leveranse, og oppdelingen må være
# besluttet før kravet kan legges til grunn for planlegging. Se
# LEVERANSEFORSLAG nederst i filen.
#
@OPT-BEH-BEH-004 @must @draft
Egenskap: Vitnemålsbehandling
  Som saksbehandler i opptak
  ønsker jeg å velge hvilket vitnemål og hvilke fag som skal ligge til grunn
  slik at søkere med flere vitnemål, eller med fag som bare finnes i opplastet
  dokumentasjon, blir riktig poengberegnet.

  Vitnemålsbehandling er ikke nødvendig for alle søknader. Har søkeren ett
  elektronisk vitnemål uten forbedringer, klarer automatikken seg selv.
  Behovet oppstår når søkeren har flere vitnemål, har forbedret fag, eller har
  dokumentert fag som ikke finnes elektronisk. Seksjonen er derfor lukket som
  standard, med en teller som viser hvor mange elektroniske vitnemål søkeren
  har.

  Saksbehandlingen består av tre valg som henger sammen: hvilket vitnemål som
  legges til grunn, hvilke fag på det vitnemålet som skal telle, og hvilke fag
  som eventuelt må legges inn manuelt fordi de bare finnes i opplastet
  dokumentasjon. Til sammen utgjør de tre valgene beregningsgrunnlaget.

  Både valget av vitnemål og valget av fag gjøres per poengvariant. Det er
  ikke ett valg som gjelder overalt: samme fag kan telle i én poengvariant og
  ikke i en annen, og hele poenget med å behandle vitnemålet er å finne
  kombinasjonen søkeren kommer best ut med.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg kan se og endre søknadsbehandling for organisasjonen som behandler saken
    Og jeg er inne på søknaden til en søker

  Regel: Søkerens elektroniske vitnemål vises

    Scenario: Se at søkeren har elektroniske vitnemål
      Gitt søkeren har elektroniske vitnemål
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg hvor mange elektroniske vitnemål søkeren har
      Men vitnemålsbehandlingen er ikke åpnet

    Scenario: Åpne vitnemålsbehandlingen
      Gitt søkeren har to elektroniske vitnemål
      Når jeg åpner vitnemålsbehandlingen
      Så ser jeg hvert vitnemål med følgende opplysninger
        | felt                |
        | Utstedelsesdato     |
        | Dokumenttype        |
        | Status              |
        | Førstegangsvitnemål |
        | Reform              |
        | Dispensasjon        |
        | Påstand om GSK      |
      # AVKLART 21.09.2026: dispensasjon og påstand om GSK vises som del av
      # vitnemålets opplysninger, selv om selve GSK-vurderingen er avgrenset
      # ut av featuren. Begrunnelse: de er kontekst for hvilket vitnemål som
      # bør legges til grunn, og saksbehandleren skal slippe å bytte skjermbilde
      # for å se dem.
      #
      # Feltene er verifisert mot NVB_VGDOK og mot KREG-spørringen
      # hentKompetansebevis: datoUtstedt, vgdoktypekode, status, foerstegangsvm,
      # reformkode, dispensasjonskode og paastandOmGsk.

    Scenario: Søker uten elektroniske vitnemål
      Gitt søkeren ikke har elektroniske vitnemål
      Når jeg åpner grunnlaget på søknaden
      Så vises ikke oversikten over elektroniske vitnemål
      Og skjemaet for å legge inn fag manuelt er åpent
      # AVKLART: fra Confluence — «Dersom det ikke finnes tilgjengelige
      # elektroniske vitnemål skal ikke modul for vitnemål vises. MEN, da skal
      # også skjemaet for manuell utfylling alltid vises.»

    Scenario: Åpne et vitnemål i eget vindu
      Gitt søkeren har elektroniske vitnemål
      Når jeg velger å åpne et vitnemål i eget vindu
      Så vises vitnemålet i et eget vindu ved siden av saksbehandlingen
      # Formålet er å kunne lese vitnemålet mens saksbehandlingen står åpen,
      # eventuelt på en ekstern skjerm.

    Scenario: Annullert vitnemål som er brukt i en beregning vises
      Gitt søkeren har et annullert vitnemål
      Og det annullerte vitnemålet er brukt i en beregning på dette opptaket
      Når jeg åpner vitnemålsbehandlingen
      Så ser jeg det annullerte vitnemålet tydelig markert som annullert
      Men jeg kan ikke legge det til grunn for en ny beregning

    Scenario: Vitnemål uten relevans for opptaket vises ikke
      Gitt søkeren har et annullert vitnemål
      Og det annullerte vitnemålet er ikke brukt i en beregning på dette opptaket
      Når jeg åpner vitnemålsbehandlingen
      Så vises ikke det annullerte vitnemålet
      # AVKLART 21.09.2026: relevans avgjøres av om vitnemålet har vært brukt i
      # en beregning på opptaket saksbehandleren jobber på. Et annullert
      # vitnemål som ligger til grunn for et tall saksbehandleren ser, må
      # være synlig — ellers kan ikke tallet forstås eller etterprøves. Gamle
      # vitnemål som aldri har vært i bruk i dette opptaket er bare støy.
      #
      # Verifisert i FS-klienten: dm_person_v_vitnemaal2 beregner
      # «godkjentbehandling = decode(vgdokstatuskode,'A',0,1)». Status A er
      # ikke til behandling, men FS-klienten skjuler ikke raden. Regelen over
      # er strammere: den skjuler også raden når den ikke har vært i bruk.
      #
      # Merk at GskAnnulleringUtenAnnullertVitnemaalError i gsk.graphqls
      # forutsetter at saksbehandleren kan se at et vitnemål er annullert.
      # Regelen over holder det synlig i nettopp de tilfellene feilen kan
      # oppstå.

  Regel: Saksbehandleren velger hvilket vitnemål som legges til grunn

    Scenario: Velge vitnemålet som skal legges til grunn
      Gitt søkeren har flere elektroniske vitnemål
      Når jeg velger ett av vitnemålene
      Så vises fagene på det valgte vitnemålet
      Og det valgte vitnemålet er grunnlaget for poengberegningen

    Scenario: Automatikken har ikke beregnet poeng når søkeren har flere vitnemål
      Gitt søkeren har flere elektroniske vitnemål
      Og den automatiske poengberegningen ikke har konkludert
      Når jeg åpner grunnlaget på søknaden
      Så fremgår det at poengene ikke er beregnet automatisk
      Og det fremgår at årsaken er at søkeren har flere vitnemål
      # Verifisert i ny stack: vurderKravelementerAutomatisk hopper over saken
      # «uten entydig vitnemål», og behandleSakAutomatisk kan returnere
      # FlereVitnemaalException. I dag får saksbehandleren ingen forklaring på
      # hvorfor poengene mangler — det er nettopp den stillheten featuren
      # skal fjerne.

    Scenario: Bytte til et annet vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg velger et annet vitnemål
      Så beregnes poengene på nytt fra det nye vitnemålet
      Og det fremgår hvilket vitnemål poengene nå bygger på

    Scenario: Legge ulikt vitnemål til grunn for ulike poengvarianter
      Gitt søkeren har to elektroniske vitnemål
      Når jeg legger det ene vitnemålet til grunn for én poengvariant
      Og jeg legger det andre vitnemålet til grunn for en annen poengvariant
      Så beregnes hver poengvariant fra sitt eget vitnemål
      Og det fremgår hvilket vitnemål hver poengvariant bygger på
      # AVKLART 21.09.2026: ulikt vitnemål per poengvariant er tillatt. Det er
      # den logiske konsekvensen av at fagvalget er per poengvariant, og
      # formålet er det samme — å finne kombinasjonen søkeren kommer best ut
      # med.
      #
      # Verifisert i ny stack: Poeng er nøklet på blant annet poengklasse_kode
      # og poengvariant_kode, og har vitnemaalsnummer som eget felt.
      # Datamodellen støtter dette allerede; det måtte besluttes, ikke bygges.
      #
      # GSK-vedtaket har sitt eget vitnemaalsnummer for hele søkeren og
      # påvirkes ikke. GSK og poeng kan derfor peke på ulike vitnemål — det er
      # akseptert, fordi de svarer på ulike spørsmål: GSK om kvalifisering,
      # poeng om rangering.

    Scenario: Et vitnemål gjelder ikke alle poengvarianter
      Gitt søkeren har et vitnemål som ikke er gyldig for alle poengvarianter
      Når jeg velger vitnemålet
      Så kan jeg bare legge det til grunn for poengvariantene det gjelder for
      # Verifisert i FS-klienten: f_hentvitnemalpoengvariant slår opp
      # POENGVARIANTVITNEMAL på (vgdoknr, poengvariant) og returnerer 0 når
      # kombinasjonen ikke finnes. Et vitnemål er altså ikke universelt
      # gyldig.

  Regel: Vitnemål kan sammenlignes

    Scenario: Sammenligne vitnemål
      Gitt søkeren har flere vitnemål som er relevante for opptaket
      Når jeg velger å sammenligne vitnemålene
      Så vises vitnemålene ved siden av hverandre
      Og fagene er stilt opp slik at samme fag står på samme rad
      # AVKLART 21.09.2026: kravet setter ingen øvre grense for antall
      # vitnemål som kan sammenlignes — alle som er relevante for opptaket
      # skal kunne stilles opp. Antallet er allerede begrenset av
      # relevansregelen over.
      #
      # Confluence sier «Bredde på skjerm avgjør antall vitnemål det er mulig
      # å sammenlikne». Det er en UI-beskrivelse, ikke en forretningsregel, og
      # hører i vitnemålsbehandling.design.md.

    Scenario: Se kun fagene som skiller vitnemålene
      Gitt jeg sammenligner flere vitnemål
      Når jeg velger å se kun forskjellene
      Så vises bare fagene der vitnemålene er ulike
      # Verifisert i FS-klienten: avkryssingsboksen «Vis kun endringer i
      # forhold til valgt vitnemål» gjør nettopp dette. Videreføres fordi et
      # vitnemål typisk har rundt 20 fag, og forskjellen mellom to vitnemål
      # ofte er to–tre av dem.

  Regel: Fagene på det valgte vitnemålet vises

    Scenario: Se fagene på vitnemålet
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg ser fagene på vitnemålet
      Så ser jeg hvert fag med følgende opplysninger
        | felt               |
        | Fagkode            |
        | Fagnavn            |
        | Omfang             |
        | År                 |
        | Standpunktkarakter |
        | Eksamenskarakter   |
        | Fagstatus          |
      # Feltene er verifisert mot NVB_VGDOKFAG og mot KregFag i
      # hentKompetansebevis: fagkode, fagnavn, fagOmfang, aar, terminkode,
      # fagstatuskode og vurdering.

    Scenario: Se opprinnelig og forbedret karakter samtidig
      Gitt vitnemålet har et fag søkeren har forbedret
      Når jeg ser fagene på vitnemålet
      Så ser jeg både den opprinnelige og den forbedrede karakteren for faget
      Og det fremgår hvilken av dem som inngår i beregningen
      # Verifisert i FS-klienten: dm_vitnemalbehandl_vmfag selvjoiner
      # NVB_VGDOKFAG mot seg selv på samme fagkode med ulik status_forbedring,
      # og viser radene som kolonneparet «Opprinnelig / Forbedret».
      # Designskissen i Confluence har samme kolonnepar.

    Scenario: Se merknader på et fag
      Gitt et fag på vitnemålet har en merknad
      Når jeg ser fagene på vitnemålet
      Så ser jeg merknaden på faget
      # KregFag.merknader og NVB_VGDOKFAG.merknadkode med merknadparameter.
      # Merknader forklarer f.eks. fritak eller særskilt vurderingsform, og er
      # nødvendige for at saksbehandleren skal forstå hvorfor et fag ser ut
      # som det gjør.

  Regel: Fagvalget gjøres per poengvariant

    Scenario: Velge hvilke fag som skal telle
      Gitt jeg har lagt et vitnemål til grunn
      Og jeg behandler en bestemt poengvariant
      Når jeg velger hvilke fag som skal telle
      Så beregnes poengene for den poengvarianten fra de valgte fagene
      Og fagvalget er lagret på poengvarianten

    Scenario: Fagvalget i én poengvariant påvirker ikke en annen
      Gitt jeg har valgt et tilleggsfag i én poengvariant
      Når jeg åpner en annen poengvariant
      Så er tilleggsfaget ikke valgt der
      # AVKLART: fagvalget er per poengvariant. Begge datamodeller er entydige
      # på dette — FS-klientens TILLEGGVARIANT er nøklet på
      # (vgdoknr, fagkode, poengvariant), og VitnemalUtregning i ny stack er
      # nøklet på blant annet poengklasse_kode og poengvariant_kode.
      #
      # Merk at designskissen for tilleggsfag i Confluence viser én enkelt
      # avkryssingskolonne, uten å si hvilken poengvariant den gjelder. Den
      # kolonnen må forstås som valget for den poengvarianten saksbehandleren
      # har åpen.

    Scenario: Tilleggsfag teller ikke før det aktivt velges
      Gitt vitnemålet har et tilleggsfag
      Og jeg har ikke tatt stilling til tilleggsfaget
      Når poengene beregnes
      Så inngår ikke tilleggsfaget i beregningen
      # AVKLART 21.09.2026: et tilleggsfag er utenfor beregningen til
      # saksbehandleren aktivt velger det.
      #
      # Begrunnelse: det motsatte gjør at et førstegangsvitnemål blir
      # forbedret uten at noen har tatt et valg — se scenarioet under. Med
      # denne regelen er det alltid sporbart hvem som tok valget.
      #
      # Dette er en opprydding, ikke en videreføring. FS-klienten har to ulike
      # defaulter i samme bilde: dm_vitnemalbehandl_vmfag bruker
      # nvl(TVAR.status_valgt,'J') — altså med som standard — mens
      # dm_vitnemalbehandl_vmfag_tillegg bruker rå TVAR.status_valgt, altså
      # ikke med. Forskjellen ser ut som en tilfeldighet, og videreføres ikke.

    Scenario: Ikke alle fag kan velges bort
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg ser fagene på vitnemålet
      Så kan jeg bare velge bort fag som er merket som valgbare
      # Verifisert i FS-klienten: TILLEGGVARIANT.status_valgbar styrer dette,
      # og defaulter til 'N'. Fag som inngår i selve vitnemålsgrunnlaget kan
      # altså ikke hukes bort — det er tilleggsfagene valget gjelder.

    Scenario: Å velge et tilleggsfag kan gjøre vitnemålet forbedret
      Gitt søkeren har et førstegangsvitnemål
      Og vitnemålet har et tilleggsfag som ikke er valgt
      Når jeg velger tilleggsfaget for en poengvariant
      Så regnes vitnemålet som forbedret for den poengvarianten
      Og det fremgår for meg at valget har denne konsekvensen
      # Verifisert i FS-klienten: f_forbedretvitnemal(vgdoknr, poengvariant)
      # returnerer 1 hvis vitnemålet har fag med status_forbedring = 'J',
      # ELLER har et tilleggsfag der TILLEGGVARIANT.status_valgt = 'J' for
      # akkurat den poengvarianten.
      #
      # Konsekvensen er alvorlig og lett å overse: et førstegangsvitnemål gir
      # tilgang til førstegangsvitnemålskvoten. Saksbehandleren som huker av
      # et tilleggsfag for å gi søkeren noen tideler realfagspoeng, kan dermed
      # slå søkeren ut av kvoten. Dagens løsning sier ingenting om dette.
      #
      # At konsekvensen skal fremgå er besluttet 21.09.2026, som del av
      # beslutningen om at tilleggsfag ikke teller før de aktivt velges — de
      # to henger sammen: når valget er aktivt, skal følgen av det være synlig
      # i valgøyeblikket. Hvordan det utformes er en designavklaring og hører
      # i vitnemålsbehandling.design.md.

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

    @openquestion
    Scenario: AVKLAR hvilke karaktertyper et manuelt innlagt fag kan ha
      # ÅPENT SPØRSMÅL — NYTT, oppdaget da fagkodeverket ble gjennomgått:
      # - NVB_FAG har har_standpunkt_elev og har_standpunkt_privatist som
      #   separate felter, i tillegg til eksamenstypekode_elev og
      #   eksamenstypekode_privatist. Kodeverket vet altså at et fag kan ha
      #   standpunktkarakter som elev, men ikke som privatist.
      # - Skal skjemaet håndheve dette — altså hindre at det legges inn en
      #   standpunktkarakter på et fag søkeren har tatt som privatist?
      # - Konsekvensen hvis det ikke håndheves: en karakter som ikke kan
      #   finnes går inn i snittet, og karakterpoenget blir feil uten at noen
      #   oppdager det.
      # - Forutsetter at løsningen vet om faget er tatt som elev eller
      #   privatist. For elektroniske fag ligger det i NVB_VGDOKFAG; for
      #   manuelt innlagte må saksbehandleren oppgi det, eller så må
      #   håndhevingen droppes.
      # - Blokkerer ikke hovedflyten: uten håndheving virker registreringen,
      #   den er bare mindre robust.
      Gitt spørsmålet er åpent

  Regel: Poeng beregnes fra det valgte grunnlaget

    Scenario: Poeng beregnes når grunnlaget endres
      Gitt jeg har lagt et vitnemål til grunn
      Når jeg endrer fagvalget
      Så er poengene for poengvarianten beregnet på nytt

    Scenariomal: Poeng beregnes per poengklasse
      Gitt jeg har lagt et vitnemål til grunn
      Når poengene beregnes
      Så ser jeg beregnet <poengklasse> for poengvarianten

      Eksempler:
        | poengklasse   |
        | Karakterpoeng |
        | Realfagspoeng |
        | Språkpoeng    |
      # KAR, REA og SPR er vitnemålskravkodene kontrollmotoren beregner fra
      # vitnemålet, jf. beregnPoengAutomatisk i ny stack. Alderspoeng og
      # kjønnspoeng beregnes av poengalgoritmen og påvirkes ikke av
      # vitnemålsbehandlingen.

    Scenario: Karakterpoeng beregnes fra snittet og en faktor
      Gitt jeg har lagt et vitnemål til grunn
      Når karakterpoengene beregnes
      Så beregnes de som snittkarakteren ganget med faktoren for poengtypen
      # Faktoren er en parameter, ikke en konstant i dette kravet:
      # LagreVitnemalUtregningInput har feltet «faktor: Int!», beskrevet som
      # «Faktoren snittkarakteren multipliseres med for å gi poenget».

    Scenario: Se hvilket vitnemål et poeng bygger på
      Gitt poengene er beregnet fra et vitnemål
      Når jeg ser poengene
      Så ser jeg hvilket vitnemål hvert poeng er beregnet fra
      Og jeg ser om poenget er beregnet automatisk eller satt av en saksbehandler
      # Verifisert i ny stack: Poeng har vitnemaalsnummer,
      # statusAutomatiskUtregnet og merknadAutomatisk, der den siste sier
      # «hvilken automatisk beregning som satte verdien, og hvilket vitnemål
      # som lå til grunn». Sporbarheten finnes allerede — kravet er at den
      # skal vises.

    Scenario: Fagvalget låser poenget mot automatisk reberegning
      Gitt jeg har valgt vitnemål og fag for en poengvariant
      Når den automatiske poengberegningen kjøres
      Så beregnes ikke poenget for den poengvarianten på nytt
      Og poenget bygger fortsatt på mitt fagvalg
      # AVKLART 21.09.2026: å velge vitnemål og fag låser de berørte
      # poengradene, slik lagring i kalkulatoren allerede gjør.
      #
      # Verifisert i ny stack: LagreVitnemalUtregningService.skrivPoeng setter
      # LA_STAA = true og STATUS_AUTOMATISK_UTREGNET = false ved innsetting, og
      # bevarer la_staa ved oppdatering. Javadoc begrunner det slik: «en fersk
      # kalkulatorverdi er en manuell saksbehandler-handling og skal ikke
      # overskrives av automatisk poengberegning».
      #
      # Begge automatikk-tjenestene respekterer låsen med WHERE-guard:
      # AutomatiskPoengberegningService filtrerer på SAK_POENG.LA_STAA = false,
      # og AutomatiskKravelementVurderingService på
      # SAK_KVALIFISERING_KRAVELEMENT.LA_STAA = false. Schema-teksten
      # «Eksisterende poeng overskrives med nyberegnet verdi» er upresis på
      # dette punktet.

    Scenario: Låse opp et poeng
      Gitt et poeng er låst av mitt fagvalg
      Når jeg låser opp poenget
      Så beregnes poenget av den automatiske poengberegningen igjen
      # Opplåsing finnes allerede: settPoengV4(laStaa: false). Kalkulatoren
      # låser ikke raden igjen ved neste lagring — se javadoc-sitatet over.

    Scenario: Varsel når søkeren får et nytt vitnemål
      Gitt jeg har lagt et vitnemål til grunn
      Når søkeren får et nytt eller endret vitnemål fra Nasjonal vitnemålsdatabase
      Så blir jeg varslet om at grunnlaget jeg valgte er utdatert
      # AVKLART 21.09.2026: låsing kombineres med varsling. Låsing alene gjør
      # at et valgt grunnlag kan bli stille utdatert — søkeren forbedrer et
      # fag, NVB sender et nytt vitnemål, og poenget står fast på det gamle
      # uten at noen oppdager det.
      #
      # Samme hensyn er allerede tatt i ny stack: KregUtilgjengeligFeil stopper
      # behandlingen når KREG er nede, «for å unngå behandling på mulig
      # utdatert grunnlag». Varselet her er den andre siden av det hensynet.
      #
      # Utformingen av varselet hører i vitnemålsbehandling.design.md.

  Regel: Tilgang styres av rettighet, ikke av hvem som har tatt saken

    Scenario: Saksbehandler med endringsrettighet kan behandle vitnemål
      Gitt jeg kan endre søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så kan jeg velge vitnemål, velge fag og legge inn fag manuelt

    Scenario: Saksbehandler med kun leserettighet ser grunnlaget
      Gitt jeg kan se, men ikke endre, søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg søkerens vitnemål, det valgte grunnlaget og de beregnede poengene
      Men jeg ser ikke muligheten til å endre dem

    Scenario: Bruker uten lesetilgang ser ikke vitnemålsbehandlingen
      Gitt jeg ikke kan se søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg ikke vitnemålsbehandlingen

    Scenario: Saken er tilordnet en annen saksbehandler
      Gitt saken er tilordnet en annen saksbehandler
      Og jeg kan endre søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så kan jeg behandle vitnemålet
      # AVKLART 21.09.2026: tilgang styres av rettighet og organisasjon, ikke
      # av tilordning.
      #
      # Verifisert i ny stack: autorisasjon er SE_SØKNADSBEHANDLING og
      # MODIFISERE_SØKNADSBEHANDLING (Handling.java), håndhevet via
      # auth.har_tilgang og RLS. Tilordning er en egen mekanisme
      # (tilordneSaksbehandlerV3, fjernTilordnetSaksbehandler) for
      # arbeidsfordeling. Ingen tjeneste i opptak-service sjekker tilordnet
      # bruker før en endring — søk over hele tjenestelaget finner ingen slik
      # sjekk utenfor TilordningService selv.
      #
      # Kravet innfører derfor ikke tilordning som tilgangsgrense. Skulle det
      # bli ønsket senere, er det en utvidelse av autorisasjonsmodellen og
      # hører i et eget krav.
      #
      # At lesetilgang gir innsyn uten endringsmulighet er i tråd med
      # design-patterns-for-krav.md: det er *muligheten til å endre* som
      # skjules, ikke opplysningene. En saksbehandler som ser et poeng må
      # kunne se hva det bygger på.

# AVGRENSNINGER — BEVISST UTENFOR DETTE KRAVET
#
# Resultater fra høyere utdanning. Kravet dekker kun VGS-resultater fra
# KREG/NVB. Resultater fra høyere utdanning finnes i dag bare som en
# umodellert JSON-streng fra Vitnemålsportalen (Soker.vitnemal: String, i
# ELMO-format, se VitnemalService i opptak-service). Å vise fag derfra, og la
# dem telle, forutsetter at ELMO modelleres i GraphQL først. Initiativ #319
# slår fast at «høyere utdanning er ikke viktig for 2026».
#
# Kobling mellom manuelt innlagt fag og opplastet dokumentasjon. Besluttet
# 21.09.2026 å holdes utenfor første leveranse. Behovet er reelt — et manuelt
# innlagt fag bygger på saksbehandlerens vurdering av et dokument, og med
# fagkode teller det nå også i realfagspoeng og kravelementer — men koblingen
# belaster ikke 2026-leveransen. Samme spørsmål står åpent for praksisperioder
# i registrere_praksis.feature (Jira ADMI-45); de to bør løses sammen når de
# tas.
#
# Grunnlagsvalg (GSK). Valg av kvalifikasjonsgrunnlag er en egen kapabilitet
# med eget API (gsk.graphqls: opprettGskVedtakV3, endreGskVedtakV3,
# settGskKonklusjonFraVitnemaal). Denne featuren forutsetter grunnlaget som
# gitt.
#
# Fagprofil og kravelementvurdering. Om søkeren oppfyller de spesielle
# opptakskravene vurderes mot kompetanseregelverket, og styres av
# vurderKravelementerAutomatisk. Vitnemålsbehandlingen leverer grunnlaget den
# vurderingen bygger på, men vurderingen selv hører i et eget krav.
#
# Tverrgående moduler i steg 2. Progress-bar, dokumentseksjonen, høyreskuffen
# med søknadsalternativer og merknader er beskrevet i Confluence PFS
# 4582014995, men gjelder hele sekvensen — ikke vitnemålsbehandlingen.
#
# Automatisk valg av beste kombinasjon. #562 «Automatisk velge det vitnemålet
# eller den fagkombinasjonen som er til gunst for søker» er komplementært:
# denne featuren er det saksbehandleren gjør når automatikken ikke kan eller
# ikke bør avgjøre. Merk at når #562 bygges, må forholdet til låsingen over
# avklares — en automatikk som velger fagkombinasjon vil møte poengrader
# saksbehandleren har låst.
#
# Fagkonvertering mellom reformer. FS-klienten har w_fagkonverterer for å
# mappe fagkoder fra en tidligere reform til gjeldende. Om den funksjonen skal
# videreføres er ikke vurdert her.
#
# UI-detaljer. Plassering, accordion-oppførsel, antall rader i skjemaet,
# kolonnebredder, utforming av varsler og vindushåndtering hører i
# vitnemålsbehandling.design.md, jf. utdype-implementasjon-skillen.
#
# OPPFØLGING UTENFOR DENNE FEATUREN
#
# Aktørbetegnelse. Denne featuren beskriver tilgang med rettighetene
# SE_SØKNADSBEHANDLING og MODIFISERE_SØKNADSBEHANDLING, fordi det er slik
# autorisasjonen faktisk virker. registrere_praksis.feature (@OPT-BEH-BEH-003)
# bruker rollenavnet «opptakssaksbehandler», og behandle_søknad.feature
# (@OPT-BEH-BEH-001) bruker «saksbehandler for opptak». Aktørlisten i
# .claude/rules/gherkin-conventions.md lister bare «saksbehandler». Tre ulike
# måter å beskrive det samme. Bør samordnes i en egen endring — og
# spørsmålet er prinsipielt: skal krav beskrive tilgang med rollenavn eller
# med rettigheter?
#
# behandle_søknad.feature har to skisselinjer som denne featuren overtar:
# «Så skal administrator se resultater fra videregående skole» og «Så skal
# administrator se resultater fra høyere utdanning». Den første er dekket her;
# den andre er avgrenset ut. Linjene bør fjernes fra behandle_søknad.feature.
#
# registrere_praksis.feature har to åpne spørsmål som er besvart her og bør
# lukkes likt: koblingen til opplastet dokumentasjon (utenfor første
# leveranse) og synlighet uten registreringsrettighet (lesetilgang gir innsyn,
# endringsmulighet skjules).
#
# LEVERANSEFORSLAG
#
# Opprettet som sub-issues under #607: L1 #613, L2 #608, L3 #609,
# L4 #610, L5 #611, L6 #612.
#
# Featuren er for stor til én leveranse. Forslaget under deler den i seks,
# kuttet etter avhengighet og risiko — ikke etter hvilke skjermbilder som
# ligner hverandre. Hver leveranse gir noe brukbart alene.
#
# Det som styrer kuttet: hullet featuren skal fylle er lite. Automatikken
# stopper på FlereVitnemaalException, og det å peke ut ett vitnemål løser
# det. Resten av featuren er forbedringer rundt den kjernen.
#
#   L1  Vise vitnemålene                 #613     —        liten
#       Regel «Søkerens elektroniske vitnemål vises» og hele tilgangsregelen.
#       Ingen valg, ingen beregning. Saksbehandleren ser hva søkeren har, og
#       slipper å slå opp i FS-klienten. KREG-integrasjonen finnes allerede
#       (hentKompetansebevis), så dette er i hovedsak presentasjon.
#
#   L2  Velge ett vitnemål for hele saken #608    L1       middels
#       Regel «Saksbehandleren velger hvilket vitnemål som legges til grunn»,
#       men begrenset til ett vitnemål for hele saken — ikke per poengvariant.
#       Pluss låsing og sporbarhet fra regelen om poengberegning.
#       Dette er leveransen som fjerner blokkeringen: etter L2 kan
#       beregnPoengAutomatisk og vurderKravelementerAutomatisk kjøre på
#       søkere med flere vitnemål. Mønsteret finnes å kopiere —
#       settGskKonklusjonFraVitnemaal gjør nøyaktig dette for GSK.
#
#   L3  Fagvalg per poengvariant          #609    L2       middels
#       Regel «Fagene på det valgte vitnemålet vises» og «Fagvalget gjøres
#       per poengvariant», pluss utvidelsen fra L2 til ulikt vitnemål per
#       poengvariant. Her ligger førstegangsvitnemål-konsekvensen, som er den
#       vanskeligste enkeltbiten i hele featuren.
#
#   L4  Manuell inntasting med fagkode    #610    L2, L3   stor
#       Regel «Fag som bare finnes i opplastet dokumentasjon legges inn
#       manuelt». Ny datamodell — fagkode på karakterraden — og dermed den
#       største og mest usikre leveransen.
#       Må komme etter L3: bygges manuell inntasting før det finnes en
#       mekanisme for fagvalg per poengvariant, må den aksen ettermonteres
#       på manuelt innlagte fag.
#
#   L5  Sammenligning av vitnemål         #611    L1       liten
#       Regel «Vitnemål kan sammenlignes». Selvstendig — ingen annen
#       leveranse er avhengig av den.
#
#   L6  Varsel ved nytt vitnemål fra NVB  #612    L2       liten
#       Scenarioet «Varsel når søkeren får et nytt vitnemål». Selvstendig,
#       men gir bare mening etter L2, siden det er det låste grunnlaget som
#       kan bli utdatert.
#
# MVP: L1 + L2. Det er alt som trengs for at automatikken slutter å stoppe.
#
# HVIS TIDEN BLIR KNAPP, KUTT L4 OG L5 — I DEN REKKEFØLGEN
#
# L4 har en fungerende reserveløsning allerede i drift: lagreVitnemalUtregning
# med fagløse karakterrader. Den dekker karakterpoeng, men ikke realfagspoeng,
# språkpoeng eller kravelementer. Saksbehandleren må da sette de tre siste for
# hånd — tungvint, men mulig, og det er slik det gjøres i dag.
#
# L5 er ren gevinst. Ingenting er avhengig av den, og designet er det minst
# modne i initiativet — Confluence har «1. versjon av design».
#
# L1, L2, L3 og L6 bør ikke kuttes. L1 og L2 er selve hullet. Uten L3 er
# fagvalget borte, og da er det lite igjen av «vitnemålsbehandling». L6 er
# liten, og uten den kan et låst grunnlag bli stille utdatert — en feil som
# rammer søkeren og ingen oppdager.
#
# KONSEKVENS FOR KRAVDOKUMENTET
#
# Forslaget deler leveransen, ikke kravet. Filen holdes samlet til en
# leveranse faktisk planlegges; da kan den regelen som inngår skilles ut i en
# egen fil med egen Feature-ID hvis det er nyttig. Å splitte nå ville låst et
# kutt som ikke er besluttet.
