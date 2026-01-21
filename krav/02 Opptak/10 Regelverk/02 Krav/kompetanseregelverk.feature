        # language: no
        @OPT-REG-KRA-001 @opptakspilot @opptakspilotkritisk @fsadmin @ci
        Egenskap: Kompetanseregelverk
        Som administrator ønsker jeg å kunne opprette og vedlikeholde kompetanseregelverk som definerer kvalifiseringskrav for utdanningstilbud. Kompetanseregelverk er det grunnleggende regelverket for å avgjøre om en søker er kvalifisert for et studium basert på ulike grunnlag som vitnemål, forkurs, realkompetanse eller andre kvalifikasjoner. Regelverket inneholder kravelementer som kan være fagkrav fra videregående opplæring, opptaksprøver, praksis, arbeidserfaring, språkkrav eller andre typer kompetanse, med mulighet for å sette spesifikke poengkrav som resultatkrav, standpunktkrav og eksamenskrav. Systemet støtter både enkle og komplekse regler med OG/ELLER-logikk mellom krav, og alle beskrivelser og titler kan registreres på Bokmål, Nynorsk, Engelsk og Nordsamisk for å sikre tilgjengelighet for alle søkere.

        Scenario: Opprette nytt kompetanseregelverk med eksisterende kravelementer
                        Når administratoren velger å opprette et kompetanseregelverk
                        Og administratoren fyller inn følgende grunnleggende informasjon i kompetanseregelverket
                        | felt            | verdi                                   |
                        | navn            | Ingeniør elektronikk UiT                |
                        | kode            | ELUIT                                   |
                        | beskrivelse     | Krav for opptak til elektronikk ved UiT |
                        | gyldig fra dato | 01.01.2026                              |

                        Og administratoren velger grunnlag "VES, VOV"
                        Og administratoren legger til følgende eksisterende kravelementer for disse grunnlagene
                        | kravelement | beskrivelse               | minimumskrav |
                        | GENS        | Generell studiekompetanse | Ja           |
                        | FFMAT       | Matematikk R1             | Karakter 4   |
                        | FFYS1       | Fysikk 1                  | Karakter 3   |
                        Og administratoren velger grunnlag "FOR"
                        Og administratoren legger til følgende eksisterende kravelementer for dette grunnlaget
                        | kravelement | beskrivelse            | minimumskrav |
                        | FORFYS      | Fysikk fra forkurs     | Bestått      |
                        | FORMAT      | Matematikk fra forkurs | Karakter C   |
        Og administratoren lagrer kompetanseregelverket
        Så skal administratoren kunne se kompetanseregelverket med kode "ELUIT" i listen over regelverk

        Scenario: Opprette kompetanseregelverk med alternative krav innen ett grunnlag
                        Når administratoren velger å opprette et kompetanseregelverk
                        Og administratoren fyller inn følgende grunnleggende informasjon i kompetanseregelverket
                        | felt            | verdi                                         |
                        | navn            | Ingeniørutdanning generelle krav              |
                        | kode            | HING                                          |
                        | beskrivelse     | Generelle krav for opptak til ingeniørstudier |
                        | gyldig fra dato | 01.01.2026                                    |
                        Og administratoren velger grunnlag "VES"
                        Og administratoren legger til kravelementet "GENS" (Generell studiekompetanse)
                        Og administratoren legger til en kravgruppe "Alternativ 1" med følgende kravelementer
                        | kravelement | beskrivelse   | minimumskrav |
                        | FFMAT       | Matematikk R1 | Karakter 3   |
                        | FFYS1       | Fysikk 1      | Karakter 3   |
                        Og administratoren legger til en kravgruppe "Alternativ 2" med følgende kravelementer
                        | kravelement | beskrivelse   | minimumskrav |
                        | FFMAR       | Matematikk R2 | Karakter 4   |
                        Og administratoren legger til en kravgruppe "Alternativ 3" med følgende kravelementer
                        | kravelement | beskrivelse   | minimumskrav |
                        | FMAS1       | Matematikk S1 | Karakter 4   |
                        | FMAS2       | Matematikk S2 | Karakter 4   |
                        | FFYS1       | Fysikk 1      | Karakter 3   |
        Og administratoren definerer at søkeren må oppfylle ett av de tre alternativene (ELLER-logikk)
        Og administratoren lagrer kompetanseregelverket
        Så skal administratoren kunne se kompetanseregelverket med kode "HING" i listen over regelverk

        Scenario: Definere ulike karakterkrav for et kravelement i kompetanseregelverk
                        Gitt at administratoren er i ferd med å opprette et kompetanseregelverk
                        Og administratoren har valgt grunnlag "VES"
                        Når administratoren legger til kravelementet "FFMAT" (Matematikk R1)
                        Og administratoren definerer følgende karakterkrav for kravelementet
                        | kravtype       | verdi | beskrivelse                                  |
                        | Resultatkrav   | null  | Ingen separat krav til totalresultat i faget |
                        | Standpunktkrav | 3     | Krav til standpunktkarakter gitt av lærer    |
                        | Eksamenskrav   | 2     | Krav til eksamenskarakter                    |
                        Og administratoren lagrer kravelementet i kompetanseregelverket
                        Så skal kravelementet vises med de definerte karakterkravene i kompetanseregelverket

                        Gitt at administratoren er i ferd med å opprette et kompetanseregelverk
                        Og administratoren har valgt grunnlag "VES"
                        Når administratoren legger til kravelementet "NORSK" (Norsk hovedmål, sidemål og muntlig)
                        Og administratoren definerer følgende karakterkrav for kravelementet
                        | kravtype       | verdi | beskrivelse                                           |
                        | Resultatkrav   | 3     | Krav til gjennomsnitt av hovedmål, sidemål og muntlig |
                        | Standpunktkrav | null  | Ingen separat krav til standpunktkarakterer           |
                        | Eksamenskrav   | null  | Ingen separat krav til eksamenskarakterer             |
        Og administratoren lagrer kravelementet i kompetanseregelverket
        Så skal kravelementet vises med gjennomsnittskrav i kompetanseregelverket

        Scenario: Registrere tittel og beskrivelse på flere språk for kompetanseregelverk og kravelement
                        Når administratoren velger å opprette et kompetanseregelverk
                        Og administratoren fyller inn følgende flerspråklig informasjon for kompetanseregelverket
                        | felt            | språk      | verdi                                                     |
                        | navn            | Bokmål     | Ingeniørutdanning generelle krav                          |
                        | navn            | Nynorsk    | Ingeniørutdanning generelle krav                          |
                        | navn            | Engelsk    | Engineering Education General Requirements                |
                        | navn            | Nordsamisk | Inšenevrahkadeapmi oppalaš gáibádusat                     |
                        | beskrivelse     | Bokmål     | Generelle krav for opptak til ingeniørstudier             |
                        | beskrivelse     | Nynorsk    | Generelle krav for opptak til ingeniørstudium             |
                        | beskrivelse     | Engelsk    | General requirements for admission to engineering studies |
                        | beskrivelse     | Nordsamisk | Oppalaš gáibádusat beassat inšenevraohppui                |
                        | kode            | -          | HING                                                      |
                        | gyldig fra dato | -          | 01.01.2026                                                |
                        Og administratoren velger å opprette et nytt kravelement
                        Og administratoren fyller inn følgende flerspråklig informasjon for kravelementet
                        | felt        | språk      | verdi                                                      |
                        | kode        | -          | FFYS1                                                      |
                        | navn        | Bokmål     | Fysikk 1                                                   |
                        | navn        | Nynorsk    | Fysikk 1                                                   |
                        | navn        | Engelsk    | Physics 1                                                  |
                        | navn        | Nordsamisk | Fysihkka 1                                                 |
                        | beskrivelse | Bokmål     | Programfag Fysikk 1 fra videregående skole                 |
                        | beskrivelse | Nynorsk    | Programfag Fysikk 1 frå vidaregåande skule                 |
                        | beskrivelse | Engelsk    | Physics 1 programme subject from upper secondary education |
                        | beskrivelse | Nordsamisk | Fysihkka 1 prográmmafága joatkkaskuvllas                   |
Og administratoren lagrer både kompetanseregelverket og kravelementet
Så skal administratoren kunne se kompetanseregelverket med tekster på alle fire språk
Og administratoren skal kunne se kravelementet med tekster på alle fire språk
Og tekstene skal vises i riktig språk basert på brukerens språkvalg