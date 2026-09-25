# language: no
# GitHub: #613
#
# BAKGRUNN
#
# Skilt ut fra vitnemålsbehandling.feature (@OPT-BEH-BEH-004) 23.09.2026 som
# leveranse L1 av seks i initiativet #607 Vitnemålsbehandling. Parent-featuren
# beholder L2–L6 og står fortsatt som @draft, fordi leveransekuttet for dem
# ikke er besluttet.
#
# Kravet dekker visning av de elektroniske resultatene saksbehandleren møter i
# FS Admin, steg 2 «Grunnlag». Det erstatter oversiktsdelen av
# vitnemålsbehandlingen i FS-klienten (bilde FS143.001 Vg.dokument).
#
# Designgrunnlag: Confluence PFS 4582014995 «Vitnemål og kvalifikasjoner
# (Steg 2 - sekvensiell saksbehandling)», med designskisser i Figma
# (FS-Admin - Seksjon Opptak, node 10119-38734). Jira-initiativ SOPP-184.
#
# KILDEUAVHENGIGHET
#
# Kravet sier hva saksbehandleren skal se, ikke hvor opplysningene hentes fra.
# Det er et bevisst valg: resultatene kan hentes fra flere kilder, og valget er
# ikke tatt. Feltlistene uttrykker derfor behov, ikke hva som tilfeldigvis er
# tilgjengelig i én kilde i dag.
#
# Kartleggingen av hvilke kilder som kan levere hvilke felter, og hva som er
# verifisert tilgjengelig, står i vise_elektroniske_resultater.kilder.md. Den
# skal oppdateres når kildevalget tas — kravet skal ikke.
#
# AVHENGIGHET — INNGANGSPUNKTET FINNES IKKE ENNÅ
#
# Kravet forutsetter at løsningen kan hente de elektroniske resultatene for en
# oppgitt søker. Ingen slik inngang finnes i dag: de eksisterende er scopet til
# den innloggede personen selv. Autorisasjonsregelen er på plass — innsyn
# krever rettighet til å se søknadsbehandling for organisasjonen som behandler
# saken — men inngangen må bygges. Det er en forutsetning for leveransen, ikke
# et scenario, og hører i planen.
#
# AVGRENSNING MOT SENERE LEVERANSER
#
# Ingen valg og ingen beregning. Saksbehandleren ser hva søkeren har, og
# slipper å slå opp i FS-klienten. Å legge et vitnemål til grunn hører i L2
# (#608), fagvalg per poengvariant i L3 (#609), manuell inntasting av fag i L4
# (#610), sammenligning av vitnemål i L5 (#611) og varsel ved nytt vitnemål
# fra NVB i L6 (#612).
#
# Karakterfordeling vises ikke. Besluttet 25.09.2026: hvor mange kandidater som
# fikk hver karakter er relevant ved rangering, ikke når saksbehandleren skal
# se hva søkeren har. Skal ikke tas opp på nytt i denne leveransen.
#
# MERK: fagene på vitnemålet er flyttet inn i L1 (besluttet 24.09.2026). De sto
# som «Regel: Fagene på det valgte vitnemålet vises» i vitnemålsbehandling.
# feature, gated på at et vitnemål var lagt til grunn. Gatingen var en
# formuleringsarv, ikke en beslutning: å vise fagene på et vitnemål forutsetter
# ikke at man har valgt det. L3 er fagvalget, ikke fagvisningen. Regelen bør
# fjernes fra vitnemålsbehandling.feature — bortsett fra at det skal fremgå
# hvilken karakter som inngår i beregningen, som krever L2.
#
# MERK: vitnemålsbehandling.feature har fortsatt en avgrensning som sier at
# høyere utdanning er utenfor. Den gjelder beregning, ikke visning, og bør
# presiseres når L2 planlegges — ellers står de to filene og motsier hverandre.
#
# BEGREPSBRUK
#
# «Enkeltemne» er et emne uten et vitnemål over seg. Kravet sa
# «enkeltresultat» før 24.09.2026.
#
# «Øvrig dokumentasjon» er det søkeren har registrert elektronisk som verken er
# et vitnemål eller et emneresultat.
#
# Seksjonen som viser vitnemål og enkeltemner heter «resultatoversikten», fordi
# den i L1 bare viser. Fra L2 får samme seksjon valg, og
# vitnemålsbehandling.feature kaller den da «vitnemålsbehandlingen». Bør
# samordnes når L2 planlegges.
#
# «Grad» er ikke en egen radtype. Tittelen på vitnemålet bærer både hva
# dokumentet er og hvilken grad det gir.
#
# UI-detaljer. Plassering, accordion-oppførsel, kolonnebredder og
# vindushåndtering hører i vise_elektroniske_resultater.design.md, jf.
# utdype-implementasjon-skillen.
#
@OPT-BEH-BEH-005 @must @draft
Egenskap: Se søkerens elektroniske resultater
  Som saksbehandler i opptak
  ønsker jeg å se hvilke elektroniske resultater søkeren har
  slik at jeg kan vurdere grunnlaget uten å slå opp i FS-klienten.

  De fleste søknader trenger ingen nærmere vurdering: har søkeren ett vitnemål
  uten forbedringer, klarer automatikken seg selv. Oversiktene er derfor
  lukket som standard, med en teller som viser hvor mange innslag hver av dem
  inneholder. Telleren er det saksbehandleren trenger for å se om saken er en
  av dem som krever et nærmere blikk.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg er inne på søknaden til en søker

  Regel: Søkerens resultater vises gruppert på nivå og studiested

    Scenario: Se at søkeren har resultater
      Gitt søkeren har elektroniske resultater
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg hvor mange resultater oversikten inneholder
      Men resultatoversikten er ikke åpnet

    Scenario: Nivåene vises i fast rekkefølge
      Gitt søkeren har resultater fra flere nivåer
      Når jeg åpner resultatoversikten
      Så vises nivåene i rekkefølgen videregående, fagskole, høyere utdanning
      # AVKLART 24.09.2026: videregående øverst, fordi det er der
      # opptaksvurderingen ligger — generell studiekompetanse,
      # førstegangsvitnemål og karakterpoeng. Saksbehandleren skal ikke måtte
      # forbi høyere utdanning for å komme til det som avgjør saken.

    Scenario: Resultater fra samme studiested vises sammen
      Gitt søkeren har resultater fra to studiesteder på samme nivå
      Når jeg åpner resultatoversikten
      Så ser jeg én gruppe per studiested innenfor nivået
      Og jeg ser hvilket studiested hver gruppe gjelder
      # AVKLART 24.09.2026, lukker et åpent spørsmål fra 23.09: resultatene
      # grupperes på studiested innenfor hvert nivå.
      #
      # Begrunnelse: et resultat betyr ikke det samme uavhengig av hvor det er
      # avlagt. Saksbehandleren vurderer omfang og karakterer i lys av
      # studiestedet, og trenger å se hva søkeren har tatt hvor — ikke en
      # sammenblandet liste.

    Scenario: Vitnemål vises før enkeltemner
      Gitt søkeren har både et vitnemål og enkeltemner fra samme studiested
      Når jeg åpner resultatoversikten
      Så vises vitnemålet før enkeltemnene i gruppen
      Og resultatene sorteres etter tidspunkt med eldste først
      # Et vitnemål er et samlet grunnlag, et enkeltemne et supplement.
      # Tidspunktet er utstedelsesdatoen for et vitnemål og terminen for et
      # enkeltemne.

    Scenario: Se opplysninger om et vitnemål
      Gitt søkeren har et vitnemål
      Når jeg åpner resultatoversikten
      Så ser jeg vitnemålet med følgende opplysninger
        | felt            |
        | Tittel          |
        | Omfang          |
        | Utstedelsesdato |
        | Status          |
      # AVKLART 24.09.2026: tittelen bærer både hva dokumentet er og hvilken
      # grad det gir — «Vitnemål videregående opplæring», «Bachelor i
      # informatikk». Kravet hadde tidligere dokumenttype og grad som to
      # separate felter.
      #
      # Utstedelsesdato og status gjelder alle vitnemål uansett nivå.
      # Saksbehandleren må vite når et vitnemål ble utstedt for å vurdere
      # rekkefølgen på søkerens løp, og må se status for å vite om vitnemålet
      # fortsatt gjelder.

    Scenariomal: Se tilleggsopplysninger for et vitnemål fra <nivå>
      Gitt søkeren har et vitnemål fra <nivå>
      Når jeg åpner resultatoversikten
      Så ser jeg i tillegg studieprogrammet vitnemålet er tatt innenfor

      Eksempler:
        | nivå             |
        | fagskole         |
        | høyere utdanning |

    Scenario: Se tilleggsopplysninger for et vitnemål fra videregående skole
      Gitt søkeren har et vitnemål fra videregående skole
      Når jeg åpner resultatoversikten
      Så ser jeg i tillegg til opplysningene om vitnemålet
        | felt                    |
        | Vitnemålsnummer         |
        | Førstegangsvitnemål     |
        | Påstand om GSK          |
        | Reform                  |
        | Dispensasjon            |
        | Orden                   |
        | Atferd                  |
        | Merknader på vitnemålet |
      # AVKLART 21.09.2026: påstand om GSK vises som del av vitnemålets
      # opplysninger, selv om selve GSK-vurderingen er avgrenset ut av
      # initiativet. Begrunnelse: den er kontekst for hvilket vitnemål som bør
      # legges til grunn, og saksbehandleren skal slippe å bytte skjermbilde.
      #
      # Merknader på vitnemålet forklarer f.eks. fritak eller særskilt
      # vurderingsform, og er nødvendige for å forstå hvorfor vitnemålet ser ut
      # som det gjør.

    Scenario: Se opplysninger om et enkeltemne
      Gitt søkeren har et enkeltemne
      Når jeg åpner resultatoversikten
      Så ser jeg enkeltemnet med følgende opplysninger
        | felt          |
        | Emnekode      |
        | Tittel        |
        | Omfang        |
        | Termin        |
        | Karakter      |
        | Karakterskala |
        | Beskrivelse   |
      # AVKLART 25.09.2026: karakterskalaen vises ved siden av karakteren. En
      # karakter alene kan mistolkes — B på en bokstavskala og «bestått» på en
      # tostegsskala er ulike opplysninger, og saksbehandleren må kunne skille
      # dem uten å åpne emnet.

    Scenario: Søker uten elektroniske resultater
      Gitt søkeren ikke har elektroniske resultater
      Når jeg åpner grunnlaget på søknaden
      Så vises ikke resultatoversikten
      # PRESISERT 25.09.2026: dette scenarioet gjelder når det er bekreftet at
      # søkeren ikke har elektroniske resultater. Når opplysningene ikke kunne
      # hentes, eller det er ukjent om søkeren har noe, gjelder regelen «Det
      # fremgår når grunnlaget er ufullstendig» — de tilstandene skal aldri se
      # ut som denne.
      #
      # AVKLART: fra Confluence — «Dersom det ikke finnes tilgjengelige
      # elektroniske vitnemål skal ikke modul for vitnemål vises. MEN, da skal
      # også skjemaet for manuell utfylling alltid vises.»
      #
      # Andre halvdel av kravet er holdt utenfor denne leveransen: skjemaet for
      # å legge inn fag manuelt bygges i L4 (#610). Kravet om at skjemaet da
      # alltid skal være åpent står i vitnemålsbehandling.feature, og må
      # innfris sammen med skjemaet.

    @openquestion
    Scenario: Åpne et vitnemål i eget vindu
      Gitt søkeren har et vitnemål
      Når jeg velger å åpne vitnemålet i eget vindu
      Så kan jeg lese vitnemålet mens saksbehandlingen står åpen
      # ÅPNE SPØRSMÅL:
      # - Et resultat kan ha flere underliggende dokumenter — en oppnådd grad
      #   og en godkjenning av utenlandsk utdanning kommer ofte med to hver.
      #   Skal saksbehandleren kunne åpne disse dokumentene i første leveranse?
      #   Reist 24.09.2026.
      #
      # Scenarioet gjelder visning av opplysningene i grensesnittet, ikke
      # åpning av et dokument. Typisk bruk er å legge vitnemålet på en ekstern
      # skjerm mens saksbehandlingen står i hovedvinduet.

    Scenario: Se alle enkeltemner samlet
      Gitt søkeren har enkeltemner
      Når jeg velger å se enkeltemnene samlet
      Så kan jeg lese alle enkeltemnene mens saksbehandlingen står åpen
      # AVKLART 24.09.2026: et enkeltemne åpnes ikke for seg. De vises samlet
      # på én side, slik at saksbehandleren leser dem under ett.

  Regel: Saksbehandleren ser hvor ferske opplysningene er

    Scenario: Se når opplysningene sist ble hentet
      Gitt søkeren har resultater fra flere studiesteder
      Når jeg åpner resultatoversikten
      Så ser jeg for hver gruppe når opplysningene sist ble hentet
      # AVKLART 25.09.2026: tidspunktet vises per gruppe, ikke per rad og ikke
      # som én verdi for hele oversikten. Variasjonen i ferskhet oppstår mellom
      # grupper, ikke mellom rader i samme gruppe — og én samlet verdi ville
      # vært misvisende så snart gruppene oppdateres i ulik takt.
      #
      # Kravet sier tidspunkt, ikke hvor opplysningene ble hentet fra. Hvem som
      # står bak resultatet dekkes allerede av feltet Utsteder.

    Scenario: Be om ny innhenting
      Gitt jeg ser resultatoversikten
      Når jeg ber om at resultatene hentes på nytt
      Så hentes resultatene på nytt
      Og jeg ser det oppdaterte tidspunktet for når opplysningene ble hentet
      # AVKLART 25.09.2026: saksbehandleren skal kunne be om ny innhenting når
      # som helst, ikke bare etter en feilet henting. Uten det står
      # saksbehandleren maktesløs foran et tidsstempel hen ikke kan gjøre noe
      # med, og et grunnlag som er blitt utdatert kan ikke friskes opp.
      #
      # Kravet forutsetter at en ny innhenting faktisk oppdaterer et resultat
      # som er endret hos utstederen. Se vise_elektroniske_resultater.kilder.md
      # for hvorfor det ikke er gitt med dagens lagring.

  Regel: Det fremgår når grunnlaget er ufullstendig

    Scenario: Resultater fra en utsteder kunne ikke hentes
      Gitt søkeren har resultater fra flere utstedere
      Og resultatene fra én av utstederne kunne ikke hentes
      Når jeg åpner resultatoversikten
      Så ser jeg resultatene som ble hentet
      Og jeg ser hvilken utsteder det finnes resultater fra som ikke kunne hentes
      # AVKLART 25.09.2026: utstederen navngis. Et anonymt «noe mangler» kan
      # saksbehandleren ikke handle på; med utstederen navngitt kan hen be
      # søkeren dokumentere akkurat det, eller forsøke igjen senere.
      #
      # Å navngi utstederen er domenespråk, ikke en kildebinding — det er samme
      # opplysning som feltet Utsteder bærer på resultatene som ble hentet.

    Scenario: Ingen av søkerens resultater kunne hentes
      Gitt søkeren har elektroniske resultater
      Og ingen av dem kunne hentes
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg at søkeren har resultater som ikke kunne hentes
      Men jeg ser ingen resultater
      # AVKLART 25.09.2026: dette må skille seg tydelig fra en søker uten
      # resultater. En tom oversikt som egentlig betyr at hentingen feilet er
      # en direkte vei til feilvedtak.

    Scenario: Det er ukjent om søkeren har resultater
      Gitt det ikke lar seg avgjøre om søkeren har elektroniske resultater
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg at det ikke er avklart om søkeren har elektroniske resultater
      # AVKLART 25.09.2026: dette er en egen tilstand, ikke det samme som at
      # hentingen feilet. Vet løsningen at søkeren har resultater den ikke fikk
      # tak i, kan saksbehandleren handle på det. Vet den ikke engang om det
      # finnes noe, kan hen ikke — og det er den farligste tilstanden å
      # forveksle med en tom oversikt.
      #
      # Skillet forutsetter at kilden skiller mellom å vite hvor resultatene
      # finnes og å hente dem. Er det ikke tilfellet for en gitt kilde, faller
      # tilstanden sammen med scenarioet over.

  Regel: Fagene på vitnemålet vises

    Scenario: Se fagene på vitnemålet
      Gitt søkeren har et vitnemål fra videregående skole
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
      # Flyttet fra vitnemålsbehandling.feature 24.09.2026. Sto der som
      # «Fagene på det valgte vitnemålet vises», med et Gitt-ledd om at et
      # vitnemål var lagt til grunn. Gatingen er fjernet: å se fagene
      # forutsetter ikke at vitnemålet er valgt.
      #
      # Eksamenskarakteren vises med eksamensformen oppgitt ved siden av, slik
      # at en muntlig og en skriftlig eksamen kan skilles.

    Scenario: Se opprinnelig og forbedret karakter samtidig
      Gitt vitnemålet har et fag søkeren har forbedret
      Når jeg ser fagene på vitnemålet
      Så ser jeg både den opprinnelige og den forbedrede karakteren for faget
      # Verifisert i FS-klienten: de to radene vises som kolonneparet
      # «Opprinnelig / Forbedret». Designskissen i Confluence har samme
      # kolonnepar.
      #
      # At det skal fremgå hvilken av karakterene som inngår i beregningen
      # krever en beregning, og står fortsatt i vitnemålsbehandling.feature
      # som del av L2.

    Scenario: Se merknader på et fag
      Gitt et fag på vitnemålet har en merknad
      Når jeg ser fagene på vitnemålet
      Så ser jeg merknaden på faget
      # Merknader forklarer f.eks. fritak eller særskilt vurderingsform, og er
      # nødvendige for at saksbehandleren skal forstå hvorfor et fag ser ut
      # som det gjør.

  Regel: Annullerte resultater vises bare når de er brukt

    Scenario: Gyldig resultat vises selv om det ikke er brukt
      Gitt søkeren har et gyldig resultat
      Og det gyldige resultatet er ikke brukt i en beregning på dette opptaket
      Når jeg åpner resultatoversikten
      Så ser jeg det gyldige resultatet
      # AVKLART 23.09.2026: filtreringen gjelder kun annullerte resultater. Et
      # gyldig resultat kan når som helst bli grunnlaget saksbehandleren
      # velger (L2), og skjules derfor aldri.

    Scenario: Annullert resultat som er brukt i en beregning vises
      Gitt søkeren har et annullert resultat
      Og det annullerte resultatet er brukt i en beregning på dette opptaket
      Når jeg åpner resultatoversikten
      Så ser jeg det annullerte resultatet tydelig markert som annullert
      # At et annullert vitnemål ikke kan legges til grunn for en ny beregning
      # er en konsekvens av valget, og hører derfor i L2 (#608). Den
      # begrensningen står fortsatt i vitnemålsbehandling.feature.

    Scenario: Annullert resultat uten bruk i opptaket vises ikke
      Gitt søkeren har et annullert resultat
      Og det annullerte resultatet er ikke brukt i en beregning på dette opptaket
      Når jeg åpner resultatoversikten
      Så vises ikke det annullerte resultatet
      # AVKLART 21.09.2026, presisert 23.09.2026: et annullert resultat som
      # ligger til grunn for et tall saksbehandleren ser, må være synlig —
      # ellers kan ikke tallet forstås eller etterprøves. Annullerte resultater
      # som aldri har vært i bruk i dette opptaket er bare støy.
      #
      # AVKLART 24.09.2026: regelen gjelder alle nivåer og radtyper. Et
      # resultat som ikke har noen status regnes som gyldig og faller inn under
      # scenarioet over.
      #
      # Verifisert i FS-klienten: annullerte vitnemål vises der i lista uten å
      # skjules. Regelen over er strammere — den skjuler raden når resultatet
      # ikke har vært i bruk i dette opptaket.

    Scenario: Søkeren har bare annullerte resultater uten bruk
      Gitt søkeren har annullerte resultater
      Og ingen av dem er brukt i en beregning på dette opptaket
      Når jeg åpner grunnlaget på søknaden
      Så vises ikke resultatoversikten
      # AVKLART 23.09.2026: telleren følger lista. Når filtreringen tømmer
      # lista, er situasjonen for saksbehandleren den samme som om søkeren
      # ikke hadde elektroniske resultater i det hele tatt.

  Regel: Øvrig dokumentasjon vises for seg

    Scenario: Se at søkeren har øvrig dokumentasjon
      Gitt søkeren har øvrig elektronisk dokumentasjon
      Når jeg åpner grunnlaget på søknaden
      Så ser jeg hvor mange innslag øvrig dokumentasjon inneholder
      Men øvrig dokumentasjon er ikke åpnet

    Scenario: Åpne øvrig dokumentasjon
      Gitt søkeren har øvrig elektronisk dokumentasjon
      Når jeg åpner øvrig dokumentasjon
      Så ser jeg hvert innslag med følgende opplysninger
        | felt      |
        | Type      |
        | Tittel    |
        | Utsteder  |
        | Tidspunkt |
      # Øvrig dokumentasjon er det søkeren har registrert elektronisk som
      # verken er et vitnemål eller et emneresultat. Den er holdt som egen
      # seksjon fordi saksbehandleren vurderer den mot andre kravelementer enn
      # resultatene, og fordi den ikke har et utdanningsnivå å grupperes på.

    Scenariomal: Se <dokumentasjonstype> i øvrig dokumentasjon
      Gitt søkeren har <dokumentasjonstype> registrert elektronisk
      Når jeg åpner øvrig dokumentasjon
      Så ser jeg <dokumentasjonstype> i oversikten

      Eksempler:
        | dokumentasjonstype                  |
        | norskkurs                           |
        | godkjenning av utenlandsk utdanning |

    Scenario: Søker uten øvrig dokumentasjon
      Gitt søkeren ikke har øvrig elektronisk dokumentasjon
      Når jeg åpner grunnlaget på søknaden
      Så vises ikke øvrig dokumentasjon

  Regel: Innsyn styres av rettighet, ikke av hvem som har tatt saken

    Scenario: Saksbehandler med leserettighet ser søkerens resultater
      Gitt jeg kan se søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg søkerens elektroniske resultater

    Scenario: Bruker uten lesetilgang ser ikke resultatene
      Gitt jeg ikke kan se søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg ikke resultatoversikten
      Og jeg ser ikke øvrig dokumentasjon

    Scenario: Saken er tilordnet en annen saksbehandler
      Gitt saken er tilordnet en annen saksbehandler
      Og jeg kan se søknadsbehandling for organisasjonen som behandler saken
      Når jeg åpner søknaden til en søker
      Så ser jeg søkerens elektroniske resultater
      # AVKLART 21.09.2026: tilgang styres av rettighet og organisasjon, ikke
      # av tilordning. Tilordning er en mekanisme for arbeidsfordeling, ikke en
      # tilgangsgrense — verifisert i tjenestelaget, der ingen tjeneste sjekker
      # tilordnet bruker før en endring.
      #
      # Kravet innfører derfor ikke tilordning som tilgangsgrense. Skulle det
      # bli ønsket senere, er det en utvidelse av autorisasjonsmodellen og
      # hører i et eget krav.
      #
      # At lesetilgang gir innsyn er i tråd med design-patterns-for-krav.md:
      # det er *muligheten til å endre* som skjules, ikke opplysningene. En
      # saksbehandler som ser et poeng må kunne se hva det bygger på.
