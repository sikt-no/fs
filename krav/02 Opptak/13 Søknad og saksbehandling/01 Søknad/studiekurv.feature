# language: no
@OPT-SØK-SØK-005 @must @implemented
Egenskap: Samle utdanningstilbud i studiekurven
  Som en søker
  ønsker jeg å samle utdanningstilbudene jeg vurderer i en studiekurv
  slik at jeg kan se hva jeg har valgt per opptak før jeg starter en søknad.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse

  Regel: Søkeren styrer innholdet i studiekurven

    Scenario: Søkeren legger et utdanningstilbud i studiekurven
      Gitt at søkeren ser et utdanningstilbud
      Når søkeren legger utdanningstilbudet i studiekurven
      Så ligger utdanningstilbudet i studiekurven under opptaket det tilhører

    Scenario: Søkeren fjerner et utdanningstilbud fra studiekurven
      Gitt at søkeren har et utdanningstilbud i studiekurven
      Når søkeren fjerner utdanningstilbudet fra studiekurven
      Så ligger ikke utdanningstilbudet lenger i studiekurven

    Scenario: Søkeren har tom studiekurv
      Gitt at søkeren ikke har utdanningstilbud i studiekurven
      Når søkeren åpner studiekurven
      Så får søkeren beskjed om at studiekurven er tom

    @openquestion
    Scenario: Søkeren legger til flere utdanningstilbud enn opptaket tillater
      # ÅPNE SPØRSMÅL:
      # - Hva er maksimalt antall prioriteringer, og settes det per opptak eller globalt?
      # - Skal grensen hindre at tilbudet legges i kurven, eller først slå ut når søknaden prioriteres?
      Gitt at søkeren har like mange utdanningstilbud i studiekurven som opptaket tillater
      Når søkeren legger til enda et utdanningstilbud i samme opptak
      Så får søkeren beskjed om at grensen for antall prioriteringer er nådd

  Regel: Studiekurven er gruppert per opptak

    Scenario: Søkeren ser utdanningstilbudene gruppert per opptak
      Gitt at søkeren har utdanningstilbud i studiekurven fra to ulike opptak
      Når søkeren åpner studiekurven
      Så vises utdanningstilbudene i en egen seksjon per opptak
      Og hver seksjon viser navnet på opptaket

    Scenario: Søkeren ser søknadsfristen for opptaket
      Gitt at søkeren har utdanningstilbud i studiekurven for et opptak med ordinær søknadsfrist
      Når søkeren åpner studiekurven
      Så vises søknadsfristen for opptaket i seksjonen

    Scenariomal: Seksjonen viser hva søkeren kan gjøre videre i opptaket
      Gitt at søkeren har utdanningstilbud i studiekurven for et opptak med åpen søknadsfrist
      Og søknadskladden for opptaket har tilstand <tilstand>
      Når søkeren åpner studiekurven
      Så tilbys søkeren å <handling> for opptaket

      Eksempler:
        | tilstand  | handling           |
        | OPPRETTET | starte søknaden    |
        | STARTET   | fortsette søknaden |
        | ENDRET    | endre søknaden     |

    Scenario: Leverte søknadskladder vises ikke i studiekurven
      Gitt at søknadskladden for et opptak har tilstand LEVERT
      Når søkeren åpner studiekurven
      Så vises ikke opptaket i studiekurven

    Scenario: Tomme søknadskladder vises ikke i studiekurven
      Gitt at søknadskladden for et opptak har tilstand OPPRETTET uten søknadsalternativer
      Når søkeren åpner studiekurven
      Så vises ikke opptaket i studiekurven

  Regel: Utdanningstilbud i utløpte opptak kan ikke søkes på

    Scenario: Søkeren ser utdanningstilbud i utløpte opptak for seg
      Gitt at søkeren har utdanningstilbud i studiekurven for et opptak der søknadsfristen har gått ut
      Når søkeren åpner studiekurven
      Så vises utdanningstilbudene i en egen seksjon for utløpte opptak
      Og søkeren tilbys ikke å starte søknad for opptaket

    @openquestion
    Scenario: Søkeren åpner et utdanningstilbud i et opptak med utløpt søknadsfrist
      # ÅPNE SPØRSMÅL:
      # - Meldt i #rt-opptak 2026-08-10: søkere kommer inn på utdanningstilbud via direktelenke
      #   etter at søknadsfristen har gått ut, og får tilbudt "legg til" selv om det ikke virker.
      #   Skal muligheten skjules når fristen har gått ut? Ikke besluttet.
      Gitt at søknadsfristen for opptaket har gått ut
      Når søkeren åpner utdanningstilbudet
      Så tilbys ikke søkeren å legge utdanningstilbudet i studiekurven

    Scenario: Søkeren rydder bort alle utløpte utdanningstilbud
      Gitt at søkeren har utdanningstilbud i studiekurven for flere opptak der søknadsfristen har gått ut
      Når søkeren velger å fjerne alle utløpte utdanningstilbud
      Så er alle utdanningstilbudene i utløpte opptak fjernet fra studiekurven
      Og utdanningstilbudene i opptak med åpen søknadsfrist ligger fortsatt i studiekurven

  Regel: Studiekurven viser hvilke utdanningstilbud som allerede er søkt på

    Scenario: Søkeren ser hvilke utdanningstilbud som ligger i en levert søknad
      Gitt at søkeren har levert en søknad i et opptak
      Og søkeren har lagt til et nytt utdanningstilbud i samme opptak
      Når søkeren åpner studiekurven
      Så er utdanningstilbudene i den leverte søknaden merket som søkt på
      Og det nye utdanningstilbudet er merket som ikke lagret
