# language: no
@OPT-SØK-SØK-007 @must @implemented
Egenskap: Svare på tilbud om studieplass
  Som en søker
  ønsker jeg å svare på tilbudene jeg har fått i en søknad
  slik at lærestedet vet hvilke studieplasser jeg vil ha.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse
    Og søkeren har en levert søknad i et opptak der plasstildelingen er publisert

  Regel: Bare tilbud og ventelisteplasser innenfor svarfristen kan besvares

    Scenariomal: Søkeren kan svare på resultatet <resultat>
      Gitt at søknadsalternativet har plasstildelingsresultat <resultat>
      Og svarfristen for opptaksrunden ikke har gått ut
      Når søkeren åpner svarsiden for søknaden
      Så kan søkeren svare på søknadsalternativet

      Eksempler:
        | resultat   |
        | TILBUD     |
        | VENTELISTE |

    Scenario: Svarfristen har gått ut
      Gitt at søknadsalternativet har plasstildelingsresultat TILBUD
      Og svarfristen for opptaksrunden har gått ut
      Når søkeren åpner søknaden
      Så tilbys ikke søkeren å svare på søknadsalternativet

    Scenario: Søknaden har ingen resultater som kan besvares
      Gitt at ingen av søknadsalternativene har plasstildelingsresultat TILBUD eller VENTELISTE
      Når søkeren forsøker å åpne svarsiden for søknaden
      Så får søkeren beskjed om at siden ikke finnes

  Regel: Alle tilbud i søknaden besvares samlet

    Scenario: Søkeren besvarer alle tilbudene i søknaden
      Gitt at søkeren har tilbud på to søknadsalternativer
      Når søkeren takker ja til det ene og nei til det andre
      Og søkeren lagrer svaret
      Så er svaret registrert på begge søknadsalternativene

    Scenario: Søkeren lar ett tilbud stå ubesvart
      Gitt at søkeren har tilbud på to søknadsalternativer
      Når søkeren svarer på bare det ene søknadsalternativet
      Og søkeren lagrer svaret
      Så avvises svaret fordi ikke alle tilbud er besvart
      Og ingen av svarene er registrert

  Regel: Søkeren kan endre svaret sitt innenfor svarfristen

    Scenario: Søkeren endrer svar fra ja til nei
      Gitt at søkeren har takket ja til et tilbud
      Og svarfristen for opptaksrunden ikke har gått ut
      Når søkeren endrer svaret til nei
      Og søkeren lagrer svaret
      Så er det nye svaret registrert på søknadsalternativet

    Scenario: Søkeren ser svarfristen på søknaden
      Gitt at søkeren har et tilbud som kan besvares
      Når søkeren åpner søknaden
      Så vises svarfristen for opptaksrunden

  Regel: Svaret vises på søknaden

    Scenariomal: Søknadsalternativet viser svaret <svartype>
      Gitt at søknadsalternativet har svaret <svartype>
      Når søkeren åpner søknaden
      Så vises svaret <svartype> på søknadsalternativet

      Eksempler:
        | svartype              |
        | GODTATT               |
        | AVSLÅTT               |
        | AVSLÅTT_INTET_SVAR    |
        | GODTATT_MEN_ANNULLERT |
        | INTET_SVAR            |
