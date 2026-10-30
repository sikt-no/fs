# language: no
# GitHub: #413
@OPT-SØK-SØK-018 @must @draft
Egenskap: Oppgi at generell studiekompetanse fullføres i vår
  Som søker
  ønsker jeg å oppgi i søknaden at jeg fullfører generell studiekompetanse i vår
  slik at saksbehandleren vet at vitnemålet kommer, og søknaden kan behandles når vitnemålet er klart.

  Mange søkere fullfører videregående opplæring samme vår som de søker, og har ikke vitnemålet
  når de sender inn søknaden. Søkeren oppgir da i søknaden at generell studiekompetanse fullføres
  i vår, det vil si at vitnemålet kommer senere. Alle sakene i søknaden får automatisk en mangel
  for generell studiekompetanse, og mangelen sjekkes ut når saken er behandlet helautomatisk
  (se @OPT-BEH-BEH-008).

  Regel: Søkeren oppgir i søknaden at generell studiekompetanse fullføres i vår

    Scenario: Søkeren oppgir at generell studiekompetanse fullføres i vår
      Gitt at søkeren fyller ut en søknad til "Samordna opptak 2027"
      Når søkeren oppgir at generell studiekompetanse fullføres i vår
      Og søkeren sender inn søknaden
      Så står det i søknaden at generell studiekompetanse fullføres i vår

  Regel: Søkeren kan endre at generell studiekompetanse fullføres i vår frem til søknadsfristen

    Scenario: Søkeren endrer før søknadsfristen at generell studiekompetanse fullføres i vår
      Gitt at søkeren har oppgitt i søknaden at generell studiekompetanse fullføres i vår
      Og at søknadsfristen i "Samordna opptak 2027" ikke har gått ut
      Når søkeren endrer søknaden til at generell studiekompetanse ikke fullføres i vår
      Så står det ikke lenger i søknaden at generell studiekompetanse fullføres i vår

    Scenario: Søkeren kan ikke endre etter søknadsfristen at generell studiekompetanse fullføres i vår
      Gitt at søkeren har oppgitt i søknaden at generell studiekompetanse fullføres i vår
      Og at søknadsfristen i "Samordna opptak 2027" har gått ut
      Når søkeren åpner søknaden
      Så ser ikke søkeren muligheten til å endre at generell studiekompetanse fullføres i vår
