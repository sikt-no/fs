# language: no
Egenskap: 10 Felleskrav: Språkvalg påvirker søk og resultat
 Som bruker ønsker jeg å få returnert de mest aktuelle resultatene av mine søk, når jeg har
    valgt arbedidsspråk i brukerflaten, så forventer jeg at søkeresultater kommer på det språket jeg har valgt,
    men dersom det ikke finnes resultater i det språket jeg har valg, så vil jeg heller ha et resultat enn å ikke få noe resultat.

Scenario: Språkvalg påvirker søk og resultat av søk etter utdanninger
    Gitt at studieadministor er på søke etter utdanninger siden
    Gitt at studieadministrator har valgt bokmål som språk
    Når studieadministrator søker på "HIS1100"
    Så får studieadministrator "HIS1100 Norgeshistorie" som resultat

    Scenario: Språkvalg påvirker søk og resultat av søk etter utdanninger
        Gitt at studieadministor er på søke etter utdanninger siden
        Gitt at studieadministrator har valgt nynorsk som språk
        Når studieadministrator søker på "HIS1100"
        Så får studieadministrator "HIS1100 Noregs historie" som resultat

    Scenario: Språkvalg påvirker søk og resultat av søk etter utdanninger
        Gitt at studieadministor er på søke etter utdanninger siden
        Gitt at studieadministrator har valgt engelsk som språk
        Når studieadministrator søker på "HIS1100"
        Så får studieadministrator "HIS1100 History of Norway" som resultat

    Scenario: Bokmål er verdien vi faller tilbake på, hvis andre ikke finnes
        Gitt at studieadministor er på søke etter utdanninger siden
        Gitt at studieadministrator har valgt engelsk som språk
        Gitt at utdanning ikke har engelsk tittel
        Når studieadministrator søker på "HIS1100"
        Så får studieadministrator "HIS1100 Norgeshistorie" som resultat