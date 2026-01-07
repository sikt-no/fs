# language: no
@tilgangsstyring @organisasjonsinstansvalg
Egenskap: Organisasjonsinstansvalg for brukere med flere tilganger
  Som bruker med tilgang til flere organisasjoner trenger jeg å kunne velge hvilken organisasjon jeg utfører oppgaver ved slik at systemet kan hente riktige data fra FS basert på valgt eierorganisasjon.

  Bakgrunn:
    Gitt at FS krever organisasjonstilknytning for tilgang til data
    Og at brukerflaten sender institusjonsnummer for å få tilgang

  Scenario: Skjule organisasjonsvalg for brukere med kun én tilgang
    Gitt at jeg har tilgang til kun én organisasjon
    Når jeg logger inn i FS Admin
    Så skal jeg ikke se funksjonalitet for organisasjonsvalg
    Og systemet skal automatisk bruke min ene tilgjengelige organisasjon

  Scenario: Vise organisasjonsvalg kun for brukere med flere tilganger
    Gitt at systemet sjekker mine organisasjonstilganger
    Når jeg har tilgang til "<antall_organisasjoner>" organisasjoner
    Så skal organisasjons-funksjonalitet være "<synlighet>"
    Eksempler:
      | antall_organisasjoner | synlighet |
      | 1                    | skjult    |
      | 2                    | synlig    |
      | 3                    | synlig    |

  Scenario: Vise brukervennlig oversikt over tilgjengelige organisasjoner
    Gitt at jeg har tilgang til flere organsisasjoner
    Gitt at jeg har logget inn i FS Admin
    Når jeg ønsker å se hvilke organisasjoner jeg kan velge mellom
    Så skal jeg se en brukervennlig oversikt over alle organisasjoner jeg har tilgang til
    Og oversikten skal vise organisasjonskortnavn og navn

  Scenario: Vise tydelig hvilken organisasjonsinstans som er valgt
    Gitt at jeg har logget inn i FS Admin
    Og at jeg har tilgang til flere organisasjoner
    Når jeg ser hovedgrensesnittet
    Så skal det fremkomme tydelig hvilken organisasjon jeg utfører oppgaver ved
    Og organisasjonens kortnavn og navn skal være synlig på alle relevante sider

  Scenario: Enkelt bytte mellom organisasjoner
    Gitt at jeg ser oversikten over tilgjengelige organisasjoner
    Når jeg ønsker å bytte til en annen organisasjon
    Så skal det være en brukervennlig måte å velge organisasjon på
    Og byttet skal skje raskt uten unødig mange klikk
    Og jeg skal få bekreftelse på at byttet er gjennomført

    ## lurer på om vi bør gå på orgnr, for å legge til rette for at dette kan brukes på tvers av subgrafer?
  Scenario: Sende riktig institusjonsnummer til FS-SIS
    Gitt at jeg har valgt en spesifikk institusjon
    Når FS Admin henter data fra FS-SIS
    Så skal systemet sende institusjonsnummeret for den valgte organisasjonenen
    Og ikke automatisk velge den første i listen
    Og jeg skal få tilgang til data for riktig organisasjon

  Scenario: Håndtere standard organisasjon ved første gangs bruk
    Gitt at jeg logger inn for første gang med tilgang til flere organisasjoner
    Og at jeg ikke tidligere har valgt en standard organsisasjon
    Når systemet må velge en organisasjon
    Så kan systemet velge den første i listen som standard
    Men jeg skal få mulighet til å endre valget
    Og mitt valg skal huskes til neste innlogging

  Scenario: Huske brukerens organisasjonsvalg
    Gitt at jeg har valgt en spesifikk organisasjon
    Når jeg logger ut og inn igjen senere
    Så skal systemet huske min sist valgte organisasjon
    Og automatisk velge denne ved innlogging
    Men jeg skal fortsatt kunne endre valget hvis ønskelig

  Scenario: Gi tydelig tilbakemelding ved nytt organisasjonsvalg
    Gitt at jeg velger en ny organisasjon
    Når valget behandles av systemet
    Så skal jeg få umiddelbar visuell bekreftelse på valget
    Og systemet skal indikere hvis det tar tid å laste data
    Og eventuelt vise feilmeldinger hvis noe går galt med byttet

  # =========================================================================
  # FREMTIDIGE ØNSKEDE UTVIDELSER - IKKE I FØRSTE VERSJON
  # =========================================================================

 @fremtidig
  Scenario: Håndtere organisasjon som ikke lenger er tilgjengelig for bruker
    Gitt at jeg tidligere har valgt en organisasjon
    Og at denne organisasjonen ikke lenger er tilgjengelig for meg
    Når jeg logger inn
    Så skal systemet varsle meg om at forrige valg ikke er tilgjengelig
    Og tilby meg alternative institusjoner å velge mellom
    Og la meg velge en ny standard institusjon

  @fremtidig
  Scenario: Bevare arbeidskonkekst ved organsisasjonbytte
    Gitt at jeg jobber med oppgaver i FS Admin
    Når jeg bytter organisasjon
    Så skal systemet advare meg hvis pågående arbeid kan påvirkes
    Og gi meg mulighet til å fullføre eller lagre arbeid før bytte
    Og navigere meg til en hensiktsmessig startside for ny organisasjon