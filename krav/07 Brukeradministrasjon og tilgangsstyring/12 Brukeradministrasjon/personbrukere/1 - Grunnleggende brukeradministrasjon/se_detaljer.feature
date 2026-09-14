# language: no
# GitHub: TBD
@BRU-PER-GRU-007 @must @planned
Egenskap: Se detaljer for personbruker
  Som brukeradministrator
  ønsker jeg å se detaljer for en personbruker, organisert i logiske datagrupper,
  slik at jeg har oversikt over personbrukeren.

  Bakgrunn:
    Gitt jeg er på detaljsiden for en personbruker

  Regel: Detaljer organiseres i logiske datagrupper

    Scenario: Se navn
      Så ser jeg personbrukerens navn

    Scenario: Se Feide-ID
      Så ser jeg personbrukerens Feide-ID

    Scenario: Se organisasjon
      Så ser jeg hvilke organisasjoner personbrukerens tilganger gjelder for

    Scenario: Se status
      Så ser jeg om personbrukeren er aktiv eller deaktivert

  @draft
  Regel: Sist brukt (planlagt etter v1)

    Scenario: Se sist brukt
      Så ser jeg tidspunktet personbrukeren sist brukte løsningen

# ÅPNE SPØRSMÅL:
# - Hva skal "Organisasjon" bety på en personbruker? I dag betyr den de organisasjonene brukeren har tildelinger ved, avledet fra tilgangene — jf. scenarioet "Se organisasjon" over, og "har minst én tilgang ved" i BRU-PER-GRU-001. Forslag: la "Organisasjon" i stedet bety brukerens hjemorganisasjon — der hen hører hjemme, sannsynligvis hentet fra Feide — eventuelt med en ny label dersom "Organisasjon" blir for tvetydig.
# - Begrunnelsen for forslaget: tre krav forutsetter allerede en ansettelsesrelasjon uten at noe definerer den. BRU-PER-ETT-005 deaktiverer tilganger ved stillingsslutt uten å si ved hvilken organisasjon, BRU-PER-ETT-001 har som åpent spørsmål hvem som regnes som "mine ansatte", og Feide-ID-en bærer en vertsorganisasjon som ingen krav tar i bruk. Applikasjoner har allerede eierskapsmodellen ("organisasjonen applikasjonen tilhører"); personbrukere har ingen tilsvarende.
# - Konsekvens hvis forslaget vedtas: tildelingenes organisasjon består som i dag, per rad i BRU-PER-GRU-002 og BRU-PER-GRU-008. Det som endres er hva feltet på brukernivå viser, og da må filter og synlighet i BRU-PER-GRU-001 formuleres om, siden de bygger på "har minst én tilgang ved".
# - Henger sammen med at listen i BRU-PER-GRU-001 viser "Organisasjon" som én kolonne, mens dagens betydning gir flere verdier per bruker. Scenarioet som dekker brukere med tildelinger i flere organisasjoner er fortsatt @draft.
