# language: no
# Oppsett for testene i cdp-tester/02 Opptak/11 Opprette og vedlikeholde opptak/ (samme sti under _Oppsett/)
#
# Kjøres først i hver kjøring, før testene i mappa. Lager testdataene testene bruker, gjennom FS Admin, med
# {KJØRING} i navnene. Testdataene i TEST kan slettes eller nullstilles når som helst, så testene bygger aldri
# på data fra en tidligere kjøring.
#
# Hvert scenario lager én testdata-nøkkel. Agenten skriver navnet og URL-en til det som er laget, i
# «Kjøringens testdata» øverst i resultat.md. Testene slår opp nøkkelen der.
# Feiler et scenario, får nøkkelen ingen verdi, og testene som bruker den, blir «Ikke testet».
#
# {DATO:+N} er datoen N dager etter dagen kjøringen starter (dd.mm.åååå), og {DATO:-N} N dager før.
# Opptak kan ikke slettes. Opptakene oppsettet lager, blir liggende.
#
# Utfylling O: samordna opptak i utgangstilstanden (som «opptak-forvalter-forvaltende»)
#   1. Gå til «Opptak». Under «SAMORDNA OPPTAK», velg «Opprett».
#   2. «Navn på opptaket (bokmål)» og «(nynorsk)»: «<navn> (test {KJØRING})». «(engelsk)»: «<navn på engelsk> (test {KJØRING})»
#   3. «Opptakstype»: «Samordna opptak til universiteter og høgskoler»
#   4. «Regelverksamling knyttet til opptaket»: regelverkssamlingen «regelverkssamling-samordna»
#   5. «Godkjente utdanningsbakgrunner»: «Realkompetanse», og eventuelt flere (står i scenarioet)
#   6. «Poenglikhetsregel»: «Loddnummer, laveste nummer først». «Antall søknadsalternativer»: 10 (forhåndsutfylt)
#   7. Fristene under «Generelle frister» (ikke «Fyll inn testdatoer», som setter alt til i dag):
#      | Felt                                           | Dato              |
#      | Redigering åpner                               | {DATO:-7}         |
#      | Redigering stenger                             | {DATO:+30}        |
#      | Frist for å trekke utdanningstilbud            | {DATO:+30} 23:59  |
#      | Åpner for søking (i kortet «Søkeperiode»)      | {DATO:+60}        |
#      | Ordinær søknadsfrist                           | {DATO:+90} 23:59  |
#      | Omprioriteringsfrist                           | {DATO:+100} 23:59 |
#      | Slette søknadsalternativer                     | {DATO:+100} 23:59 |
#      | Ordinær frist (i kortet «Dokumentasjon»)       | {DATO:+90} 23:59  |
#      | Ettersendingsfrist                             | {DATO:+120} 23:59 |
#      | Endre utdanningsbakgrunn                       | {DATO:+110} 23:59 |
#      | Publiseringsdato                               | {DATO:+150}       |
#   8. Velg «Lagre». «Lagring vellykket» vises.
#   Står noe under «Fyll ut obligatoriske felt:» etter steg 7, er det et funn: skriv det i «Faktisk resultat».
@OPPSETT-OPT-OVO @ref-OPT-OVO-GRU-001 @ref-OPT-OVO-SAM-001 @ref-OPT-OVO-INN-001 @ref-OPT-OVO-FRI-001
Egenskap: Oppsett for opprette og vedlikeholde opptak
  Lager opptakene testene for opprette og vedlikeholde opptak bruker, i utgangstilstanden testene forutsetter.

  Scenario: opptak-samordna-uten-utdanningstilbud
    Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
    Når jeg fyller ut som i Utfylling O, med navnet «Samordna opptak 2027» og «Coordinated admission 2027»
    Og jeg går til «Opptak», skriver «Samordna opptak 2027 (test {KJØRING})» i «Opptaksnavn», og velger opptaket
    Så står «Kan søke på tidlig opptak» «Nei» og «Tilbyr ledige studieplasser» «Nei» under «Oppsummert»
    Og det står ingen organisasjoner under «Samordnede organisasjoner»
    Og jeg skriver navnet og URL-en i «Kjøringens testdata» for «opptak-samordna-uten-utdanningstilbud»

  Scenario: opptak-en-utdanningsbakgrunn
    Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
    Når jeg fyller ut som i Utfylling O, med navnet «Samordna opptak 2027 én bakgrunn» og «Coordinated admission 2027 one background», og bare «Videregående steinerskole» i «Godkjente utdanningsbakgrunner» [Sjekk begrep: kravet sier «Steinerskole»]
    Og jeg går til «Opptak», skriver «Samordna opptak 2027 én bakgrunn (test {KJØRING})» i «Opptaksnavn», og velger opptaket
    Så står «1 utdanningsbakgrunn» under «Godkjente utdanningsbakgrunner» [Sjekk begrep]
    Og jeg skriver navnet og URL-en i «Kjøringens testdata» for «opptak-en-utdanningsbakgrunn»

  Scenario: opptak-lokalt
    Gitt jeg er logget inn som «opptak-forvalter-lokalt»
    Når jeg fyller ut som i Utfylling B i ../../../02 Opptak/11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opprett_opptak.feature, med navnet «Lokalt opptak høst 2027 (test {KJØRING})»
    Og jeg velger «Lagre»
    Så ser jeg «Lagring vellykket»
    Og jeg skriver navnet og URL-en i «Kjøringens testdata» for «opptak-lokalt»

  # Krever at organisasjonen til «opptak-forvalter-deltakende» kan legge til utdanningstilbud (MEDLEM_OPPTAK, se miljøfila).
  Scenario: opptak-samordna-med-utdanningstilbud
    Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
    Når jeg fyller ut som i Utfylling O, med navnet «Samordna opptak 2027 med tilbud» og «Coordinated admission 2027 with offers»
    Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
    Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
    Og jeg skriver «{ORGNAVN:opptak-forvalter-deltakende}» i «Søk etter navn», markerer organisasjonen, og velger «Legg til 1 organisasjon»
    Og jeg velger «Lagre»
    Og jeg bytter testbruker til «opptak-forvalter-deltakende»
    Og jeg åpner opptaket «Samordna opptak 2027 med tilbud (test {KJØRING})», og velger «Gå til utdanningstilbud»
    Og jeg velger «Handlinger», og «Legg til utdanningstilbud»
    Og jeg legger til utdanningstilbudet «utdanningstilbud-deltakende» [Sjekk begrep: stegene i dialogen]
    Så står utdanningstilbudet i lista, med «{ORG:opptak-forvalter-deltakende}» i «Organisasjon»
    Og jeg skriver navnet og URL-en i «Kjøringens testdata» for «opptak-samordna-med-utdanningstilbud»
    Og jeg bytter testbruker til «opptak-forvalter-forvaltende»

  Scenario: opptak-samordna-tilbud-med-tidlig-opptak
    Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
    Når jeg fyller ut som i Utfylling O, med navnet «Samordna opptak 2027 tidlig opptak» og «Coordinated admission 2027 early admission»
    Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
    Og jeg skriver «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
    Og jeg skriver «{DATO:+75} 23:59» i «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser» i kortet «Tidlig opptak»
    Og jeg velger «Lagre»
    Og jeg inviterer «{ORGNAVN:opptak-forvalter-deltakende}» og lagrer, som i scenarioet over
    Og jeg bytter testbruker til «opptak-forvalter-deltakende»
    Og jeg legger til utdanningstilbudet «utdanningstilbud-deltakende», som i scenarioet over
    Og jeg åpner utdanningstilbudet, og velger «Rediger»
    Og jeg krysser av for «Tidlig opptak», og skriver «50» i «Poenggrense»
    Og jeg velger «Lagre» [Sjekk begrep]
    Så står «Tidlig opptak» «Ja» på utdanningstilbudet
    Og utdanningstilbudet står i lista over utdanningstilbud med filteret «Tilbyr tidlig opptak»
    Og jeg skriver navnet og URL-en i «Kjøringens testdata» for «opptak-samordna-tilbud-med-tidlig-opptak»
    Og jeg bytter testbruker til «opptak-forvalter-forvaltende»

  # Teknikk: ingen. Over 50 opptak lages ikke av oppsettet (51 opptak per kjøring). «opptak-oversikt-over-50» blir stående
  # i miljøfila, og testene som bruker den, blir «Ikke testet» når det er færre enn 51 opptak.
  # «opptak-oversikt-flere-typer» er dekket av opptakene over: to typer (UHG og lokalt), to organisasjoner, laget i denne kjøringen.
