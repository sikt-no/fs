# language: no
# Generert av fs-testcaser-cdp 2026-10-27
# Krav: krav/02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opprett_opptak.feature @ 0f010d4 (blob cea644ab96a853c83fcd15a86d4a7be42f35b858)
#
# {KJØRING} byttes ut med dato og klokkeslett når kjøringen starter, for eksempel «2026-10-28 0930».
# «{ORG:<nøkkel>}», «{ORGNAVN:<nøkkel>}» og «{ORGKODE:<nøkkel>}» er forkortelsen, navnet og organisasjonskoden til organisasjonen
# testbrukeren eller testdataene <nøkkel> har, slått opp i miljøfila.
# Opptak kan ikke slettes. Opptakene testene oppretter, har {KJØRING} i navnet, og blir liggende.
#
# Utfylling A: gyldig samordna opptak (som «opptak-forvalter-forvaltende»)
#   1. Gå til «Opptak». Under «SAMORDNA OPPTAK», velg «Opprett». Siden «Opprett samordna opptak» åpnes.
#   2. «Navn på opptaket (bokmål)»: «Samordna opptak 2027 (test {KJØRING})»
#   3. «Navn på opptaket (nynorsk)»: «Samordna opptak 2027 (test {KJØRING})»
#   4. «Navn på opptaket (engelsk)»: «Coordinated admission 2027 (test {KJØRING})»
#   5. «Opptakstype»: «Samordna opptak til universiteter og høgskoler»
#   6. «Regelverksamling knyttet til opptaket»: regelverkssamlingen «regelverkssamling-samordna»
#   7. «Godkjente utdanningsbakgrunner»: «Realkompetanse»
#   8. «Poenglikhetsregel»: «Loddnummer, laveste nummer først»
#   9. «Antall søknadsalternativer»: 10 (forhåndsutfylt). «Tilbud per tildelingsrunde»: 1 (forhåndsutfylt, påkrevd i skjemaet selv om kravet er avviklet)
#  10. Under «Generelle frister», velg «Fyll inn testdatoer». Det setter alle de ordinære fristene. «Redigering åpner» og «Redigering stenger» blir i dag kl. 00:00.
#  Står noe under «Fyll ut obligatoriske felt:» etter steg 10 (for eksempel «Frist for å trekke utdanningstilbud»), er det et funn: skriv det i «Faktisk resultat».
#
# Utfylling B: gyldig lokalt opptak (som «opptak-forvalter-lokalt»)
#   1. Gå til «Opptak». Under «LOKALT OPPTAK» [Sjekk begrep], velg «Opprett». Siden «Opprett lokalt opptak» åpnes.
#   2. Navnene på bokmål og nynorsk: «Lokalt opptak høst 2027 (test {KJØRING})». Engelsk: «Local admission autumn 2027 (test {KJØRING})»
#   3. «Opptakstype»: «Lokalt opptak»
#   4. «Regelverksamling knyttet til opptaket»: regelverkssamlingen «regelverkssamling-lokalt»
#   5. Steg 7–10 som i Utfylling A.
@TST-OPT-OVO-GRU-001 @depends-on-OPT-OVO-GRU-001
Egenskap: Opprette et opptak
  Opptaksforvalteren oppretter et samordna eller lokalt opptak i FS Admin, og opptaket kan ikke lagres uten
  de obligatoriske feltene.

  Regel: Opptaksforvalter kan opprette et opptak

    Scenario: Opprette et samordna opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og organisasjonen «organisasjon-som-inviteres» finnes i utdanningsregisteret
      Når jeg fyller ut som i Utfylling A
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg skriver «{ORGNAVN:organisasjon-som-inviteres}» i «Søk etter navn»
      Og jeg markerer «{ORGNAVN:organisasjon-som-inviteres}»
      Og jeg velger «Legg til 1 organisasjon»
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      Når jeg går til «Opptak»
      Og jeg skriver «Samordna opptak 2027 (test {KJØRING})» i «Opptaksnavn»
      Så står «Samordna opptak 2027 (test {KJØRING})» i lista, med «{ORG:opptak-forvalter-forvaltende}» i «Organisasjon»
      Når jeg velger opptaket i lista
      Så ser jeg «Endre innstillinger for opptaket»
      Og «Administreres av» viser «{ORG:opptak-forvalter-forvaltende}» [Sjekk begrep: forkortelsen eller hele navnet]
      Og under «Samordnede organisasjoner» står «{ORGNAVN:organisasjon-som-inviteres}»

    Scenario: Opprette et lokalt opptak
      Gitt jeg er logget inn som «opptak-forvalter-lokalt»
      Når jeg fyller ut som i Utfylling B
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      Når jeg går til «Opptak»
      Og jeg skriver «Lokalt opptak høst 2027 (test {KJØRING})» i «Opptaksnavn»
      Så står «Lokalt opptak høst 2027 (test {KJØRING})» i lista, med «{ORG:opptak-forvalter-lokalt}» i «Organisasjon»
      Når jeg velger opptaket i lista
      Så ser jeg «Endre innstillinger for opptaket»
      Og «Administreres av» viser «{ORG:opptak-forvalter-lokalt}» [Sjekk begrep: forkortelsen eller hele navnet]

    # Teknikk: ekvivalensklasser (samordna og lokalt opptak har hver sine opptakstyper)
    @utledet
    Scenario: Opptaksforvalter kan opprette et opptak: opptakstypene i et samordna opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Opptak»
      Når jeg velger «Opprett» under «SAMORDNA OPPTAK»
      Og jeg åpner «Opptakstype»
      Så er valgene «Samordna opptak til fagskoler» og «Samordna opptak til universiteter og høgskoler»
      Og «Lokalt opptak» er ikke et valg
      Og jeg velger «Avbryt»

    # Teknikk: ekvivalensklasser (samordna og lokalt opptak har hver sine opptakstyper)
    @utledet
    Scenario: Opptaksforvalter kan opprette et opptak: opptakstypene i et lokalt opptak
      Gitt jeg er logget inn som «opptak-forvalter-lokalt»
      Og jeg har åpnet «Opptak»
      Når jeg velger «Opprett» under «LOKALT OPPTAK» [Sjekk begrep]
      Og jeg åpner «Opptakstype»
      Så er «Lokalt opptak» et valg
      Og «Samordna opptak til fagskoler» og «Samordna opptak til universiteter og høgskoler» er ikke valg
      Og jeg velger «Avbryt»

  Regel: Navn, regelverkssamling og opptakstype er obligatorisk for å lagre et opptak

    Scenario: Lagre opptak uten navn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men hopper over steg 2–4
      Så kan «Lagre» ikke velges
      Og under «Fyll ut obligatoriske felt:» står «Navn på opptaket (bokmål)», «Navn på opptaket (nynorsk)» og «Navn på opptaket (engelsk)», og ingen andre felt
      Og jeg velger «Avbryt»

    Scenario: Lagre opptak uten regelverkssamling
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men hopper over steg 6
      Så kan «Lagre» ikke velges
      Og «Regelverksamling tilknyttet opptaket» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

    Scenario: Lagre opptak uten opptakstype
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men hopper over steg 5
      Så kan «Lagre» ikke velges
      Og «Opptakstype» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»
      # Uten opptakstype viser «Generelle frister» «Du må velge opptakstype før du kan sette frister», så steg 10 kan ikke tas.
      # Fristene står da ikke under «Fyll ut obligatoriske felt:». Står de der, skriv det i «Faktisk resultat».

  Regel: Utdanningsbakgrunner, poenglikhetsregel og maks antall søknadsalternativer må være satt for å lagre et opptak

    Scenariomal: Lagre opptak uten <innstilling>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men <avvik>
      Så kan «Lagre» ikke velges
      Og «<felt>» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

      Eksempler:
        | innstilling                     | avvik                                                                   | felt                           |
        | utdanningsbakgrunner            | hopper over steg 7                                                      | Godkjente utdanningsbakgrunner |
        | standard poenglikhetsregel      | hopper over steg 8                                                      | Poenglikhetsregel              |
        | maks antall søknadsalternativer | fjerner tallet i «Antall søknadsalternativer» (forhåndsutfylt med 10)   | Antall søknadsalternativer     |

    # Teknikk: ekvivalensklasser (feltet tomt, med feilmeldingen ved feltet)
    @utledet
    Scenario: Utdanningsbakgrunner, poenglikhetsregel og maks antall søknadsalternativer må være satt for å lagre et opptak: feilmeldingen ved «Godkjente utdanningsbakgrunner»
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A
      Og jeg fjerner «Realkompetanse» fra «Godkjente utdanningsbakgrunner»
      Så ser jeg «Velg minst én utdanningsbakgrunn.» ved «Godkjente utdanningsbakgrunner»
      Og kan «Lagre» ikke velges
      Og jeg velger «Avbryt»

  Regel: Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne

    Scenario: Angi opptaksnavn på flere språk
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har fylt ut som i Utfylling A, men med «Samordna opptak 2027 samisk (test {KJØRING})» i alle tre navnefeltene, og lagret
      Når jeg går til «Opptak», og åpner «Samordna opptak 2027 samisk (test {KJØRING})»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg skriver «Samordna opptak 2027 samisk (test {KJØRING})» i «Navn på opptaket (samisk)»
      Og jeg velger «Lagre»
      Og jeg går til «Opptak», åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «Samordna opptak 2027 samisk (test {KJØRING})» i «Navn på opptaket (bokmål)», «Navn på opptaket (nynorsk)», «Navn på opptaket (engelsk)» og «Navn på opptaket (samisk)»
      Og jeg velger «Avbryt»

    Scenario: Lagre opptak med navn på alle obligatoriske språk
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men med disse navnene
        | felt                        | navn                                               |
        | Navn på opptaket (bokmål)   | Samordna opptak 2027 navn (test {KJØRING})         |
        | Navn på opptaket (nynorsk)  | Samordna opptak 2027 navn (test {KJØRING})         |
        | Navn på opptaket (engelsk)  | Coordinated admission 2027 name (test {KJØRING})   |
      Og jeg lar «Navn på opptaket (samisk)» stå tomt
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      Når jeg går til «Opptak», åpner «Samordna opptak 2027 navn (test {KJØRING})», og velger «Endre innstillinger for opptaket»
      Så står navnene i tabellen i feltene sine
      Og «Navn på opptaket (samisk)» er tomt
      Og jeg velger «Avbryt»

    Scenariomal: Navn mangler på et obligatorisk språk
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men lar «Navn på opptaket (<språk>)» stå tomt
      Så kan «Lagre» ikke velges
      Og «Navn på opptaket (<språk>)» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

      Eksempler:
        | språk   |
        | bokmål  |
        | nynorsk |
        | engelsk |

    # Teknikk: ekvivalensklasser (navn med bare mellomrom er ugyldig, OpptakManagementPage.tsx:188-260 bruker .trim())
    @utledet
    Scenariomal: Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne: bare mellomrom i navnet på <språk>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A
      Og jeg fjerner teksten i «Navn på opptaket (<språk>)», og skriver tre mellomrom der
      Så kan «Lagre» ikke velges
      Og «Navn på opptaket (<språk>)» er det eneste feltet under «Fyll ut obligatoriske felt:»
      Og jeg velger «Avbryt»

      Eksempler:
        | språk   |
        | bokmål  |
        | nynorsk |
        | engelsk |

    # Teknikk: grenseverdianalyse (maks lengde 100 tegn, OpptakInformation.tsx:12 i fs-admin og @maksLengde(tegn: 100) i opptak.graphqls)
    @utledet
    Scenario: Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne: navn med 100 tegn
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg fyller ut som i Utfylling A, men skriver dette navnet på 100 tegn i alle tre navnefeltene: «Samordna opptak 100 tegn (test {KJØRING}) » fylt ut med «x» til navnet er nøyaktig 100 tegn
      Og jeg velger «Lagre»
      Så ser jeg «Lagring vellykket»
      Når jeg går til «Opptak», skriver «Samordna opptak 100 tegn (test {KJØRING})» i «Opptaksnavn», åpner opptaket, og velger «Endre innstillinger for opptaket»
      Så har «Navn på opptaket (bokmål)», «Navn på opptaket (nynorsk)» og «Navn på opptaket (engelsk)» hele navnet på 100 tegn
      Og jeg velger «Avbryt»

    # Teknikk: grenseverdianalyse (maks + 1: feltet har maxLength 100, så tegn nummer 101 tas ikke imot)
    @utledet
    Scenariomal: Opptaket må ha navn på bokmål, nynorsk og engelsk, fordi navnet vises for søkerne: 101 tegn i navnet på <språk>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og jeg har åpnet «Opptak»
      Når jeg velger «Opprett» under «SAMORDNA OPPTAK»
      Og jeg skriver 101 tegn («x» 101 ganger) i «Navn på opptaket (<språk>)»
      Så har «Navn på opptaket (<språk>)» 100 tegn
      Og jeg velger «Avbryt»

      Eksempler:
        | språk   |
        | bokmål  |
        | nynorsk |
        | engelsk |
