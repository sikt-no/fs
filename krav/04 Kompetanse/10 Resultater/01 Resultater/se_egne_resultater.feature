# language: no
# GitHub: #208
@KOM-RES-RES-001 @must @draft
Egenskap: Se egne resultater
  Som bruker av Min kompetanse
  ønsker jeg å se alle resultatene mine samlet på ett sted
  slik at jeg har oversikt over kompetansen jeg har oppnådd, og kan dokumentere den.

  Resultatene hentes fra Vitnemålsportalen. Den samler resultater fra flere kilder:
  læresteder i høyere utdanning, videregående opplæring (Nasjonal vitnemålsbase),
  fagskoler og andre. Vitnemålsportalen er fasiten for hva brukeren skal se.

  Resultatene deles i fullførte kvalifikasjoner (grad fra høyere utdanning,
  vitnemål fra videregående) og enkeltresultater som ikke inngår i en kvalifikasjon.

  # ÅPNE SPØRSMÅL:
  # - Vitnemål fra videregående er ikke tilgjengelig som standard, verken her eller i Vitnemålsportalen. Skal kravet beskrive det, og hva brukeren får vite om det?
  # - Fagskole og andre kilder finnes i dataene, men vises ikke. Skal de vises, og under hvilket nivå?
  # - Skal innpassede emner markeres i graden?
  # - Skal brukeren se summen av studiepoeng?
  # - I hvilken rekkefølge skal kvalifikasjoner og emner vises? I dag følger rekkefølgen leverandøren.

  Bakgrunn:
    Gitt brukeren er innlogget i Min kompetanse

  Regel: Oversikt over resultatene

    Scenario: Se studiestedene brukeren har resultater fra
      Gitt brukeren har resultater fra NTNU og Byåsen videregående skole
      Når brukeren åpner resultatsiden
      Så ser brukeren NTNU og Byåsen videregående skole i oversikten
      Og hvert studiested vises bare én gang

    Scenario: Resultatene grupperes etter utdanningsnivå
      Gitt brukeren har resultater fra høyere utdanning og videregående opplæring
      Når brukeren åpner resultatene
      Så vises resultatene fra høyere utdanning og resultatene fra videregående opplæring hver for seg
      Og resultatene fra høyere utdanning vises først

  Regel: Fullførte kvalifikasjoner

    Scenario: Se grad fra høyere utdanning
      Gitt brukeren har en bachelorgrad fra NTNU
      Når brukeren åpner resultatene
      Så ser brukeren graden med disse opplysningene:
        | felt          |
        | Studiested    |
        | Tittel        |
        | Studieprogram |
        | Termin        |
        | Studiepoeng   |

    Scenario: Se emnene som inngår i en grad
      Gitt brukeren har en bachelorgrad fra NTNU
      Når brukeren velger å se resultatene i graden
      Så ser brukeren hvert emne i graden med disse opplysningene:
        | felt        |
        | Emnenavn    |
        | Karakter    |
        | Termin      |
        | Emnekode    |
        | Studiepoeng |

    Scenario: Se emnene i en emnesamling
      Gitt brukeren har en grad med en emnesamling
      Når brukeren velger å se resultatene i graden
      Så ser brukeren emnene i emnesamlingen under emnesamlingen

    Scenario: Se beskrivelsen av et emne
      Gitt brukeren har et emne med beskrivelse fra lærestedet
      Når brukeren velger å se beskrivelsen av emnet
      Så ser brukeren beskrivelsen av emnet

    Scenario: Se vitnemål fra videregående
      Gitt brukeren har vitnemål fra Byåsen videregående skole
      Når brukeren åpner resultatene
      Så ser brukeren vitnemålet med disse opplysningene:
        | felt               |
        | Studiested         |
        | Tittel             |
        | Vitnemålsnummer    |
        | Programområder     |
        | Oppnådd kompetanse |
        | År bestått         |

    Scenario: Se fagene på et vitnemål fra videregående
      Gitt brukeren har vitnemål fra Byåsen videregående skole
      Når brukeren velger å se resultatene på vitnemålet
      Så ser brukeren hvert fag med disse opplysningene:
        | felt               |
        | Omfang             |
        | Fagkode            |
        | Fag                |
        | Standpunktkarakter |
        | Eksamenskarakter   |
        | Eksamensform       |
        | År                 |
        | Merknader          |

    Scenario: Se oppsummeringen av et vitnemål fra videregående
      Gitt brukeren har vitnemål fra Byåsen videregående skole
      Når brukeren velger å se resultatene på vitnemålet
      Så ser brukeren disse opplysningene om vitnemålet:
        | felt         |
        | Sum omfang   |
        | Orden        |
        | Atferd       |
        | Merknader    |
        | Utstedt dato |

  Regel: Enkeltresultater

    Scenario: Se enkeltemner som ikke inngår i en grad
      Gitt brukeren har to emner fra UiO som ikke inngår i en grad
      Når brukeren åpner resultatene
      Så ser brukeren emnene samlet som enkeltemner fra UiO
      Og hvert emne vises med emnenavn, karakter, termin, emnekode og studiepoeng

  Regel: Studiesteder resultatene ikke kunne hentes fra

    Scenario: Se studiested resultatene ikke kunne hentes fra
      Gitt Vitnemålsportalen ikke fikk hentet resultatene til brukeren fra UiB
      Når brukeren åpner resultatene
      Så ser brukeren at resultatene fra UiB ikke kunne hentes
      Og brukeren får beskjed om å prøve igjen senere

    Scenario: Resultater fra andre studiesteder vises selv om ett studiested feiler
      Gitt brukeren har resultater fra NTNU
      Og Vitnemålsportalen ikke fikk hentet resultatene til brukeren fra UiB
      Når brukeren åpner resultatene
      Så ser brukeren resultatene fra NTNU
      Og brukeren ser at resultatene fra UiB ikke kunne hentes

  Regel: Brukeren uten resultater

    Scenario: Brukeren har ingen resultater
      Gitt brukeren har ingen resultater i Vitnemålsportalen
      Når brukeren åpner resultatene
      Så får brukeren beskjed om at det ikke finnes resultater knyttet til brukeren
      Og brukeren ser mulige forklaringer på at resultatene mangler
      Og brukeren får beskjed om å kontakte utdanningsinstitusjonen for å dokumentere resultater som ikke vises

  Regel: Resultatene vises slik Vitnemålsportalen leverer dem

    Scenario: Brukeren ser bare resultatene sine
      Når brukeren åpner resultatene
      Så ser brukeren bare resultater som tilhører brukeren

    Scenario: Karakterer vises uendret
      Gitt brukeren har emnet INF1000 med karakteren "B" fra lærestedet
      Når brukeren åpner resultatene
      Så vises karakteren "B" for INF1000

    Scenario: Resultatene kan ikke endres
      Når brukeren åpner resultatene
      Så har brukeren ingen mulighet til å endre resultatene
