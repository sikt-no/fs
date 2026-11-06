# language: no
# Oppsett for testene i cdp-tester/02 Opptak/13 Søknad og saksbehandling/02 Behandling/ (samme sti under _Oppsett/)
#
# Kjøres først i hver kjøring, før testene i mappa. Lager testdataene testene bruker, gjennom FS Admin, med
# {KJØRING} i navnene. Agenten skriver navnet og URL-en til det som er laget, i «Kjøringens testdata» i resultat.md.
# Feiler et scenario, får nøkkelen ingen verdi, og testene som bruker den, blir «Ikke testet».
# {DATO:+N} er datoen N dager etter dagen kjøringen starter, og {DATO:-N} N dager før.
#
# Utfylling O er den samme som i _Oppsett/02 Opptak/11 Opprette og vedlikeholde opptak/oppsett.feature.
#
# Søkere med søknader og saker i bestemte tilstander (konklusjon, kvalifisering, poengsum, reservert studieplass)
# kan ikke lages i FS Admin. De, og opptaket de har søkt i, står i miljøfila: «opptak-tidlig-opptak-med-sokere» og
# nøklene «soker-tidlig-opptak-…». Det samme gjelder tilbudsgarantitypene og konklusjonene, som er kodeverk i opptaket.
@OPPSETT-OPT-BEH @ref-OPT-BEH-BEH-007 @ref-OPT-OPT-UTD-004
Egenskap: Oppsett for søknad og saksbehandling, behandling
  Lager opptaket testene for poenggrensene i fanen «Tidlig opptak» bruker, med ett utdanningstilbud som tilbyr tidlig
  opptak og ett som ikke gjør det.

  Scenario: opptak-samordna-tidlig-opptak
    Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
    Når jeg fyller ut som i Utfylling O, med navnet «Samordna opptak 2027 tidligopptak» og «Coordinated admission 2027 early admission run»
    Og jeg krysser av for «Kan søke på tidlig opptak» under «Valg for opptaket»
    Og jeg skriver «https://www.samordnaopptak.no/universitet-og-hogskole/slik-soker-du/tidlig-opptak.html» i «Informasjonsside tidlig opptak»
    Og jeg skriver «{DATO:+75} 23:59» i «Søknadsfrist», «Dokumentasjonsfrist» og «Frist for å sette poenggrenser» i kortet «Tidlig opptak»
    Og jeg velger «Lagre»
    Og jeg åpner opptaket igjen, velger «Endre innstillinger for opptaket», og «Inviter organisasjoner til samordningen» under «Samordning»
    Og jeg skriver «{ORGNAVN:opptak-forvalter-deltakende}» i «Søk etter navn», markerer organisasjonen, velger «Legg til 1 organisasjon», og velger «Lagre»
    Og jeg bytter testbruker til «opptak-forvalter-deltakende»
    Og jeg åpner opptaket «Samordna opptak 2027 tidligopptak (test {KJØRING})», velger «Gå til utdanningstilbud», «Handlinger» og «Legg til utdanningstilbud»
    Og jeg legger til utdanningstilbudene «utdanningstilbud-deltakende» og «utdanningstilbud-deltakende-uten-tidlig-opptak» [Sjekk begrep: stegene i dialogen]
    Og jeg åpner utdanningstilbudet «utdanningstilbud-deltakende», og velger «Rediger»
    Og jeg krysser av for «Tidlig opptak», og skriver «50» i «Poenggrense»
    Og jeg velger «Lagre» [Sjekk begrep]
    Og jeg bytter testbruker til «opptak-forvalter-forvaltende»
    Og jeg velger «Gå til plasstildeling» i opptaket, og fanen «Tidlig opptak»
    Så står «utdanningstilbud-deltakende» i lista med «50,0» i «Poenggrense tidlig opptak»
    Og «utdanningstilbud-deltakende-uten-tidlig-opptak» står i lista med «Ikke tidlig opptak her»
    Og jeg skriver navnet og URL-en i «Kjøringens testdata» for «opptak-samordna-tidlig-opptak»
