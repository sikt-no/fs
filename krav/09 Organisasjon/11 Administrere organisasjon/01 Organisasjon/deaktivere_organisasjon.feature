# language: no

@ORG-ADM-DEA-001 @must
Egenskap: Deaktivere organisasjon
  Som en systemadministrator
  ønsker jeg å deaktivere en organisasjon som ikke lenger er aktiv
  slik at systemet gjenspeiler den faktiske tilstanden til organisasjonen.

  Regel: En nedlagt organisasjon skal deaktiveres

    Scenario: Deaktivere en organisasjon som er nedlagt
      Gitt at en organisasjon er nedlagt
      Når jeg deaktiverer organisasjonen med sluttdato
      Så skal organisasjonen få status "Inaktiv"
      Og den skal ikke lenger vises i standard søkeresultater

    Scenario: Inaktiv organisasjon er fortsatt søkbar med historikkfilter
      Gitt at en organisasjon er deaktivert
      Når en bruker aktiverer "Vis historiske organisasjoner" i søket
      Så skal den inaktive organisasjonen vises i resultatlisten
      Og den skal tydelig markeres som "Historisk"

    Scenario: Deaktivere en organisasjon som har gått konkurs
      Gitt at en organisasjon har gått konkurs
      Når jeg deaktiverer organisasjonen
      Så skal jeg kunne angi årsak til deaktivering, f.eks. "Konkurs"
      Og deaktiveringstidspunkt og årsak skal lagres

  Regel: Deaktivering krever bekreftelse

    Scenario: Bekreftelse kreves før deaktivering
      Når jeg forsøker å deaktivere en organisasjon
      Så skal systemet be meg bekrefte handlingen
      Og vise hvilke konsekvenser deaktiveringen kan ha

# ÅPNE SPØRSMÅL:
# - Hva skjer med data knyttet til en deaktivert organisasjon (studenter, ansatte, studieprogram)?
# - Skal deaktivering varsle andre systemer som bruker organisasjonsdata?
# - Kan en deaktivert organisasjon reaktiveres, og hvem har tilgang til dette?