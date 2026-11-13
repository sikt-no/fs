# language: no
@OPT-SØK-MEL-003 @should @draft @scope-meldinger-varslinger-og-oppgaver
Egenskap: Se oppgaver
  Som søker
  ønsker jeg å se hva jeg må gjøre i søknadene mine når jeg logger inn i Min kompetanse
  slik at jeg ikke går glipp av en frist.

  En oppgave er noe søkeren må gjøre i søknaden. I motsetning til en melding forsvinner
  oppgaven når det oppgaven gjelder, er gjort.

  # Kilde: workshop om meldinger 2026-11-09 (Miro), K1-1 og K5.

  Regel: Søkeren ser en oppgave når søknaden er påbegynt og ikke levert

    Scenario: Søkeren ser oppgaven om en påbegynt søknad
      Gitt at søkeren har en påbegynt søknad som ikke er levert
      Når søkeren logger inn i Min kompetanse
      Så ser søkeren en oppgave om å levere søknaden

    Scenario: Søkeren med levert søknad har ingen oppgave om å levere
      Gitt at søkeren har levert søknaden
      Når søkeren logger inn i Min kompetanse
      Så ser ikke søkeren en oppgave om å levere søknaden

  Regel: Søkeren ser en oppgave når søknaden har mangler

    Scenariomal: Søkeren ser hva mangelen om <gjelder> krever
      Gitt at søkerens søknad har en mangel som gjelder <gjelder>
      Når søkeren åpner oppgaven om mangelen
      Så ser søkeren <hva søkeren ser>

      Eksempler:
        | gjelder                                | hva søkeren ser                                                           |
        | kvalifisering til et søknadsalternativ | hva søkeren må dokumentere, og hvilket søknadsalternativ mangelen gjelder |
        | konkurransegrunnlaget                  | hva søkeren kan dokumentere for å styrke konkurransegrunnlaget            |

  @openquestion
  Regel: Søkeren ser en oppgave når et tilbud ikke er besvart
    # ÅPNE SPØRSMÅL:
    # - Dette ble ikke diskutert i workshopen. Skal et tilbud som ikke er besvart, være en oppgave?

  Regel: Oppgaven forsvinner når det oppgaven gjelder, er gjort

    Scenario: Oppgaven om en påbegynt søknad forsvinner når søknaden er levert
      Gitt at søkeren har en oppgave om å levere søknaden
      Når søkeren leverer søknaden
      Så ser ikke søkeren lenger oppgaven om å levere søknaden

    Scenario: Oppgaven om en mangel venter på behandling etter opplasting
      Gitt at søkeren har en oppgave om en mangel
      Når søkeren laster opp dokumentasjon for mangelen
      Så viser oppgaven at mangelen venter på behandling hos saksbehandleren

    Scenario: Oppgaven om en mangel forsvinner når mangelen er sjekket ut
      Gitt at søkeren har lastet opp dokumentasjon for en mangel
      Når saksbehandleren sjekker ut mangelen
      Så ser ikke søkeren lenger oppgaven om mangelen

    Scenario: Oppgaven om en mangel blir stående når mangelen ikke er sjekket ut
      Gitt at søkeren har lastet opp dokumentasjon for en mangel
      Når saksbehandleren publiserer manglene på nytt uten å sjekke ut mangelen
      Så ser søkeren oppgaven om mangelen igjen som noe søkeren må gjøre
      # Søkeren får ny melding når saksbehandleren publiserer manglene på nytt.
      # Det står i søknadsmangler.feature (@OPT-BEH-BEH-008).
