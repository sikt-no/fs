# language: no
# GitHub: #413
@OPT-SØK-SØK-013 @must @draft
Egenskap: Oppgi at vitnemålet kommer i år
  Som søker
  ønsker jeg å oppgi i søknaden at vitnemålet mitt kommer i år
  slik at saksbehandleren vet at dokumentasjonen kommer, og søknaden kan behandles når vitnemålet er klart.

  Mange søkere fullfører videregående opplæring samme år som de søker, og har ikke vitnemålet
  når de sender inn søknaden. Søkeren oppgir da i søknaden at vitnemålet kommer i år. Saken får
  automatisk en mangel for vitnemålet, og mangelen sjekkes ut når vitnemålet behandles
  automatisk (se @OPT-BEH-BEH-008).

  # ÅPNE SPØRSMÅL:
  # - Hvordan oppgir søkeren at vitnemålet kommer i år: med et eget spørsmål i søknaden, med en
  #   utdanningsbakgrunn, eller ved å oppgi fagene eller utdanningen som fullføres i år?
  # - Kan søkeren endre opplysningen etter at søknaden er sendt inn?

  Regel: Søkeren oppgir i søknaden at vitnemålet kommer i år

    Scenario: Søkeren oppgir at vitnemålet kommer i år
      Gitt at søkeren fyller ut en søknad til "Samordna opptak 2027"
      Når søkeren oppgir at vitnemålet kommer i år
      Og søkeren sender inn søknaden
      Så står det i søknaden at vitnemålet kommer i år

  Regel: Saksbehandleren ser at søkeren har oppgitt at vitnemålet kommer i år

    Scenario: Saksbehandleren ser at vitnemålet kommer i år
      Gitt at søkeren har oppgitt i søknaden at vitnemålet kommer i år
      Når saksbehandleren ved Universitetet i Oslo åpner søknaden
      Så ser saksbehandleren at søkeren har oppgitt at vitnemålet kommer i år
