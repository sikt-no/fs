# language: no
# GitHub: #593
@OPT-OPT-UTD-005 @must @draft
Egenskap: Hente utdanninger fra utdanningsregisteret
  Som opptaksforvalter
  ønsker jeg at opptaket får tak i relevante utdanninger og utdanningsinstanser fra utdanningsregisteret
  slik at jeg kan lage utdanningstilbud uten å registrere grunndata om utdanningen på nytt.

  # Kilde: GitHub #398 (akseptansekriterier og tilleggskrav) og #593.
  # Utdanningsregisteret eier grunndata om utdanning, lærested, studiested og studiestartskull
  # (spesifikasjon, mulighet og instans). Opptak gjenbruker disse dataene og eier bare tilleggsdata
  # for opptaket (se 03 Opptaksinnstillinger).
  # En utdanningsinstans er en utdanning med startkull og campus.
  # Å legge et tilgjengelig utdanningstilbud til i opptaket er beskrevet i
  # 02 Utdanningstilbud i opptak/legge_til_utdanningstilbud.feature.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" har disse kriteriene for utdanningstilbud
      | Kriterium      | Verdi                                         |
      | Utdanningstype | Studieprogram                                 |
      | Nivå           | Grunnstudier UHG, fagskole                    |
      | Lærested       | Læresteder som deltar i "Samordna opptak 2027" |
      | Studiestart    | Høst 2027, vår 2028                           |
    Og at lærestedet "Universitetet i Oslo" deltar i opptaket

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Settes kriteriene på hvert opptak, eller er de faste for samordna opptak?
  # - Hvilke nivåer regnes som grunnstudier UHG (bachelor, årsstudium, integrert master, profesjonsstudium)?
  Regel: Utdanningsinstanser som møter opptakets kriterier blir tilgjengelige utdanningstilbud

    Scenario: Studieprogram fra deltakende lærested blir tilgjengelig
      Gitt at utdanningsregisteret har en instans av bachelorprogrammet "Sykepleie" ved "Universitetet i Oslo" med studiestart høst 2027 på campus "Blindern"
      Når opptaket henter utdanninger fra utdanningsregisteret
      Så er utdanningstilbudet "Sykepleie, høst 2027" tilgjengelig i opptaket

    Scenariomal: Studiestart som er med i opptaket
      Gitt at utdanningsregisteret har en instans av bachelorprogrammet "Sykepleie" ved "Universitetet i Oslo" med studiestart <studiestart>
      Når opptaket henter utdanninger fra utdanningsregisteret
      Så er utdanningstilbudet "Sykepleie, <studiestart>" tilgjengelig i opptaket

      Eksempler:
        | studiestart |
        | høst 2027   |
        | vår 2028    |

    Scenariomal: Utdanningsinstans som ikke møter kriteriene
      Gitt at utdanningsregisteret har en utdanningsinstans som <avvik>
      Når opptaket henter utdanninger fra utdanningsregisteret
      Så er utdanningsinstansen ikke tilgjengelig som utdanningstilbud i opptaket

      Eksempler:
        | avvik                                            |
        | er et emne, ikke et studieprogram                |
        | hører til et lærested som ikke deltar i opptaket |
        | har studiestart høst 2028                        |
        | er et studieprogram på masternivå                |

    @openquestion
    # ÅPNE SPØRSMÅL:
    # - Blir hver campus et eget utdanningstilbud når samme studieprogram har oppstart på flere campuser?
    Scenario: Samme studieprogram på to campuser
      Gitt at utdanningsregisteret har instanser av bachelorprogrammet "Sykepleie" med studiestart høst 2027 på campusene "Blindern" og "Kjeller"
      Når opptaket henter utdanninger fra utdanningsregisteret
      Så er det ett tilgjengelig utdanningstilbud for hver campus

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - #398 sier at opptaksforvalter kan «legge til, og ev. korrigere, merinformasjon». Skal noe av
  #   grunndataene kunne overstyres i opptak, eller rettes alt i utdanningsregisteret?
  Regel: Grunndata gjenbrukes fra utdanningsregisteret

    Scenario: Utdanningstilbudet bruker grunndata fra utdanningsregisteret
      Gitt at utdanningstilbudet "Sykepleie, høst 2027" er tilgjengelig i opptaket
      Så har utdanningstilbudet disse opplysningene fra utdanningsregisteret
        | Opplysning   |
        | Utdanning    |
        | Lærested     |
        | Studiested   |
        | Studiestart  |
      Og opptaksforvalter trenger ikke registrere disse opplysningene i opptaket

  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Hvor ofte hentes utdanninger fra utdanningsregisteret (fortløpende, daglig batch, ved behov)?
  # - Skal opptaksforvalter kunne be om ny henting selv?
  Regel: Nye utdanningsinstanser i utdanningsregisteret blir tilgjengelige

    Scenario: Ny utdanningsinstans etter første henting
      Gitt at opptaket har hentet utdanninger fra utdanningsregisteret
      Og at lærestedet "Universitetet i Oslo" registrerer en ny instans av bachelorprogrammet "Vernepleie" med studiestart høst 2027
      Når opptaket henter utdanninger fra utdanningsregisteret på nytt
      Så er utdanningstilbudet "Vernepleie, høst 2027" tilgjengelig i opptaket
