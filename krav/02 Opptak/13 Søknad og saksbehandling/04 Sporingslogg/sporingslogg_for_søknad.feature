# language: no
@OPT-BEH-SPO-001 @must @draft
Egenskap: Sporingslogg for søknad
  Som saksbehandler
  ønsker jeg å se hva søkeren, saksbehandlerne og systemet har gjort i søknaden, og når
  slik at jeg kan etterprøve påstander fra søkeren og behandle klager på likt grunnlag.

  Sporingsloggen for søknaden består av hendelsesloggen, som viser hva som er gjort,
  og innsynsloggen, som viser hvem som har sett opplysningene.
  Hovedbehovet er å kunne avgjøre om en søker som hevder at en teknisk feil hindret
  hen i å rekke en frist, faktisk gjorde det hen sier. Endringer gjort av ansatte
  skal være sporbare og begrunnet.

  Bakgrunn:
    Gitt saksbehandleren er innlogget i løsningen
    Og saksbehandleren ser detaljsiden for en søknad

  Regel: Hver hendelse har et fast minimumsinnhold

    Scenario: Minimumsinnhold i en hendelse
      Når søkeren sender inn søknaden
      Så logges en hendelse i hendelsesloggen med disse opplysningene
        | Opplysning                                   |
        | Tidspunkt                                    |
        | Handling                                     |
        | Hvem som utførte handlingen                  |
        | Om det var søkeren, en ansatt eller systemet |
        | Søknaden                                     |
        | Opptaket                                     |
        | Verdien før handlingen                       |
        | Verdien etter handlingen                     |
        | Om handlingen lyktes eller feilet            |

  Regel: Søkerens handlinger i søknaden logges

    Scenario: Søkeren sender inn søknaden
      Når søkeren sender inn søknaden
      Så logges en hendelse i hendelsesloggen med søknadsalternativene i den rekkefølgen de ble sendt

    @openquestion
    Scenario: Søkeren endrer rekkefølgen på søknadsalternativene
      # ÅPNE SPØRSMÅL:
      # - Søkere kan endre rekkefølgen mange ganger. Skal hendelsesloggen slå endringene sammen når den vises?
      Når søkeren endrer rekkefølgen på søknadsalternativene
      Så logges en hendelse i hendelsesloggen med rekkefølgen før og etter

    Scenario: Søkeren legger til et søknadsalternativ
      Når søkeren legger til et søknadsalternativ
      Så logges en hendelse i hendelsesloggen med søknadsalternativet som ble lagt til

    Scenario: Søkeren fjerner et søknadsalternativ
      Når søkeren fjerner et søknadsalternativ
      Så logges en hendelse i hendelsesloggen med søknadsalternativet som ble fjernet

    Scenario: Søkeren endrer utdanningsbakgrunnen
      Når søkeren endrer utdanningsbakgrunnen
      Så logges en hendelse i hendelsesloggen med utdanningsbakgrunnen før og etter

    Scenario: Søkeren trekker søknaden
      Når søkeren trekker søknaden
      Så logges en hendelse i hendelsesloggen om at søknaden ble trukket

    Scenario: Søkeren gjenopptar søknaden
      Når søkeren gjenopptar søknaden
      Så logges en hendelse i hendelsesloggen om at søknaden ble gjenopptatt

  Regel: Søkerens dokumentasjon logges

    @openquestion
    Scenario: Søkeren laster opp et dokument
      # ÅPNE SPØRSMÅL:
      # - Skal filnavnet lagres, eller bare dokumentet og dokumenttypen? Filnavn kan avsløre sensitive forhold.
      Når søkeren laster opp et dokument
      Så logges en hendelse i hendelsesloggen med dokumentet og dokumenttypen

    Scenario: Søkeren sletter et dokument
      Når søkeren sletter et dokument
      Så logges en hendelse i hendelsesloggen med dokumentet som ble slettet

    Scenario: Søkeren melder at opplastingen er ferdig
      Når søkeren melder at hen er ferdig med å laste opp dokumenter
      Så logges en hendelse i hendelsesloggen med svaret søkeren ga

    Scenario: Søkeren endrer samtykket til lagring av dokumenter
      Når søkeren endrer samtykket til lagring av dokumenter
      Så logges en hendelse i hendelsesloggen med samtykket før og etter

  Regel: Saksbehandlerens vurderinger i søknaden logges med begrunnelse

    Scenario: Saksbehandleren vurderer generell studiekompetanse
      Når saksbehandleren vurderer generell studiekompetanse for søkeren
      Så logges en hendelse i hendelsesloggen med om generell studiekompetanse ble godkjent
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren registrerer grunnlaget
      Når saksbehandleren registrerer grunnlaget for søkeren
      Så logges en hendelse i hendelsesloggen med grunnlaget som ble registrert
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren justerer grunnlaget
      Når saksbehandleren justerer grunnlaget for søkeren
      Så logges en hendelse i hendelsesloggen med grunnlaget før og etter
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren godkjenner et vitnemål
      Når saksbehandleren godkjenner et vitnemål
      Så logges en hendelse i hendelsesloggen om at vitnemålet ble godkjent
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren underkjenner et vitnemål
      Når saksbehandleren underkjenner et vitnemål
      Så logges en hendelse i hendelsesloggen om at vitnemålet ble underkjent
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren registrerer karakterer fra et vitnemål
      Når saksbehandleren registrerer karakterer fra et vitnemål
      Så logges en hendelse i hendelsesloggen med karakterene før og etter
      Og hendelsen har begrunnelsen saksbehandleren oppga

    @openquestion
    Scenario: Saksbehandleren justerer poengene manuelt
      # ÅPNE SPØRSMÅL:
      # - Kjønnspoeng sier noe om kjønn. Gjør det denne delen av loggen til en behandling av særlige kategorier personopplysninger?
      Når saksbehandleren justerer poengene for søkeren manuelt
      Så logges en hendelse i hendelsesloggen med poengene før og etter
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren vurderer et spesielt opptakskrav
      Når saksbehandleren vurderer et spesielt opptakskrav for søkeren
      Så logges en hendelse i hendelsesloggen med om opptakskravet er dekket
      Og hendelsen har begrunnelsen saksbehandleren oppga

    @openquestion
    Scenario: Saksbehandleren vurderer en kvote
      # ÅPNE SPØRSMÅL:
      # - Noen kvoter, som samisk kvote, kan si noe om etnisk tilhørighet. Gjør det denne delen av loggen til en behandling av særlige kategorier personopplysninger?
      Når saksbehandleren vurderer om søkeren skal være med i en kvote
      Så logges en hendelse i hendelsesloggen med kvoten, og om søkeren er med i kvoten
      Og hendelsen har begrunnelsen saksbehandleren oppga

  Regel: Saksbehandlerens oppfølging av søknaden logges med begrunnelse

    Scenario: Saksbehandleren endrer statusen på søknaden
      Når saksbehandleren endrer statusen på søknaden
      Så logges en hendelse i hendelsesloggen med statusen før og etter
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren fordeler søknaden til en annen organisasjon
      Når saksbehandleren fordeler søknaden til en annen organisasjon
      Så logges en hendelse i hendelsesloggen med organisasjonen før og etter
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren registrerer en mangel
      Når saksbehandleren registrerer en mangel i søknaden
      Så logges en hendelse i hendelsesloggen med mangelen som ble registrert
      Og hendelsen har begrunnelsen saksbehandleren oppga

    Scenario: Saksbehandleren fjerner en mangel
      Når saksbehandleren fjerner en mangel i søknaden
      Så logges en hendelse i hendelsesloggen med mangelen som ble fjernet
      Og hendelsen har begrunnelsen saksbehandleren oppga

  @openquestion
  Regel: En endring på vegne av søkeren viser hvem som handlet
    # ÅPNE SPØRSMÅL:
    # - Skal søkeren få kvittering hver gang en saksbehandler endrer søknaden på søkerens vegne?

    Scenario: Saksbehandleren endrer søknaden på vegne av søkeren
      Når saksbehandleren endrer rekkefølgen på søknadsalternativene på vegne av søkeren
      Så logges en hendelse i hendelsesloggen med rekkefølgen før og etter
      Og hendelsen viser at saksbehandleren handlet på vegne av søkeren

  Regel: Systemets vurderinger i søknaden logges

    Scenario: Den automatiske behandlingen vurderer et opptakskrav
      Når den automatiske behandlingen vurderer at søkeren oppfyller et opptakskrav
      Så logges en hendelse i hendelsesloggen med vurderingen
      Og hendelsen viser at det var systemet som utførte handlingen

  @openquestion
  Regel: Hendelsene i søknaden henger sammen når søkeren får nytt fødselsnummer
    # ÅPNE SPØRSMÅL:
    # - Hvor lenge skal koblingen mellom gammelt og nytt fødselsnummer lagres?

    Scenario: Søkeren har fått nytt fødselsnummer
      Gitt at søkeren har fått nytt fødselsnummer etter at søknaden ble sendt inn
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hendelsene fra både før og etter at fødselsnummeret ble endret
      Og saksbehandleren ser at fødselsnummeret ble endret, og når

  Regel: Hvem som gjorde endringen, vises som rolle og organisasjon

    Scenario: Rolle og organisasjon vises i hendelsesloggen
      Gitt at en annen saksbehandler har endret statusen på søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren rollen og organisasjonen til den som endret statusen
      Men saksbehandleren ser ikke hvilken ansatt som endret statusen

  Regel: Saksbehandler kan se hendelsesloggen for søknaden

    Scenario: Se hendelsesloggen for søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren en kronologisk liste over hendelsene i søknaden
      Og hver hendelse viser handling, verdien før og etter, hvem som utførte handlingen og tidspunkt

  @openquestion
  Regel: Søk og filtrering av hendelser
    # ÅPNE SPØRSMÅL:
    # - Skal filteret vise hver handling, eller grupper av handlinger (som «Søknadsbehandling» i designet fra sommeren 2026)?
    # - Skal det også kunne filtreres på hvem som utførte handlingen: søkeren, en ansatt eller systemet?
    # - Skal handlingene sorteres alfabetisk, eller i en annen rekkefølge?

    Scenario: Filtrere på tidsrom
      Når saksbehandleren velger et tidsrom som filter
      Så vises kun hendelser i det valgte tidsrommet

    Scenario: Tilgjengelige handlinger i filter
      Når saksbehandleren åpner handlingsfilteret
      Så inneholder filteret alle handlinger som er representert i den ufiltrerte listen
      Og hver handling vises kun én gang
      Og handlingene er sortert alfabetisk
      Og "Alle handlinger" er valgt som standard

    Scenario: Filtrere på handling
      Når saksbehandleren velger en handling som filter
      Så vises kun hendelser med den valgte handlingen

    Scenario: Kombinere filtre
      Når saksbehandleren kombinerer flere filtre
      Så vises kun hendelser som matcher alle kriteriene

  @openquestion @ref-FEL-TAB-TAB-002
  Regel: Hendelsesloggen for søknaden kan hentes ut samlet
    # ÅPNE SPØRSMÅL:
    # - Hvilket format skal uttrekket ha?
    # - Hvem skal kunne hente ut hendelsesloggen?
    # - Gjelder filteret saksbehandleren har valgt, også for uttrekket?
    # - Hva må fjernes før uttrekket utleveres til søkeren, politiet eller en fagforening? Juristene vurderer det.

    Scenario: Hente ut hendelsesloggen for en klagesak
      Når saksbehandleren henter ut hendelsesloggen for søknaden
      Så får saksbehandleren hendelsene i søknaden samlet i ett uttrekk

  @openquestion
  Regel: Hendelsene i søknaden vises for organisasjonen som behandler søknaden og opptakets forvalter
    # ÅPNE SPØRSMÅL:
    # - Dette er forslaget fra innsiktsarbeidet, og det er ikke avklart. Ser lærestedet bare søknadene det behandler?
    # - Hva gjelder i lokale opptak, der lærestedet også er opptakets forvalter?

    Scenario: Saksbehandler ved organisasjonen som behandler søknaden ser hendelsene i søknaden
      Gitt at saksbehandleren er saksbehandler ved organisasjonen som behandler søknaden
      Når saksbehandleren åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hendelsene i søknaden

    Scenario: Opptakets forvalter ser hendelsene i søknaden
      Når en saksbehandler hos opptakets forvalter åpner hendelsesloggen for søknaden
      Så ser saksbehandleren hendelsene i søknaden

  @openquestion
  Regel: Søkerens innlogginger logges
    # ÅPNE SPØRSMÅL:
    # - Skal bare opptakets forvalter se disse hendelsene, eller også lærestedet i lokale opptak?
    # - Skal IP-adressen lagres? Juristene vurderer det.
    # - Er det FS eller innloggingsløsningen som skal fange innlogginger som mislyktes?

    Scenario: Søkeren logger inn
      Når søkeren logger inn
      Så logges en hendelse i hendelsesloggen med innloggingsmetoden

    Scenario: Søkeren får ikke logget inn
      Når innloggingen for søkeren mislykkes
      Så logges en hendelse i hendelsesloggen med innloggingsmetoden og hvilken feil som oppsto

  @openquestion
  Regel: Meldinger til søkeren logges
    # ÅPNE SPØRSMÅL:
    # - Hvor ligger meldingene og når de ble lest, når Baksiden er erstattet?
    # - Dekker den nye løsningen for utsendelser at meldingene logges?

    Scenario: En melding sendes til søkeren
      Når en melding om en frist sendes til søkeren
      Så logges en hendelse i hendelsesloggen med kanalen, tittelen og om sendingen lyktes

    Scenario: Søkeren åpner en melding
      Når søkeren åpner en melding om en frist
      Så logges en hendelse i hendelsesloggen med meldingen og tidspunktet den ble åpnet

  @openquestion
  Regel: Ansattes oppslag i søknaden logges i innsynsloggen
    # ÅPNE SPØRSMÅL:
    # - Innsynsloggen får ikke skjermbilde i første versjon, fordi den kan brukes til å overvåke ansatte.
    #   Hvem skal kunne se den, og når? Avgjøres i DPIA-arbeidet.
    # - Holder det å logge at saksbehandleren fikk lenke til dokumentet, eller må det logges at dokumentet ble lest?
    # - Hvilke opplysninger skal logges når saksbehandleren slår opp søknaden: hvilke felt som ble vist, og med hvilken tilgang?

    Scenario: Saksbehandleren slår opp søknaden
      Når saksbehandleren åpner søknaden
      Så logges det i innsynsloggen hvilken saksbehandler som åpnet søknaden, og når

    Scenario: Saksbehandleren åpner et dokument i søknaden
      Når saksbehandleren åpner et dokument i søknaden
      Så logges det i innsynsloggen hvilken saksbehandler som åpnet dokumentet, og når

# ÅPNE SPØRSMÅL:
# - Kan ansatte lagres med navn, eller bare med rolle og organisasjon? Opptaket har avklart (2026-10-09)
#   at navnet lagres, men bare vises for noen få. Juristene vurderer om det gjelder søknaden også.
# - Skal svar på tilbud og påbegynte endringer som ikke ble sendt inn, logges?
# - Skal saksbehandleren se handlinger som feilet, eller bare opptakets forvalter?
# - Hvor lenge skal hendelsene og innsynet lagres?
