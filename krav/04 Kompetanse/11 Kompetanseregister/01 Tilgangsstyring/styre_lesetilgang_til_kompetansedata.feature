# language: no
# GitHub: #532
@KOM-KREG-TIL-001 @must @draft
Egenskap: Styre lesetilgang til kompetansedata
  Som forvalter av kompetanseregisteret hos Sikt
  ønsker jeg at tilgangen til kompetansedata styres på organisasjon, tilgangsrolle og utdanningsnivå
  slik at rett aktør får rett tilgang, og ingen får andres data.

  # Kompetanseregisteret (KREG) overtar som nasjonal vitnemålsbase for videregående
  # opplæring. Sikt er behandlingsansvarlig (forskrift 2024-06-03-900 § 20-6), og
  # registeret skal legge til rette for opptak (lov 2023-06-09-30 § 25-3).
  # Første leveranse dekker opptakssystemets behov for opptak 2027: lesetilgang til
  # VGS-vitnemål uavhengig av utsteder. Reglene er skrevet slik at tilganger for
  # fylkeskommuner, skoler og andre utdanningsnivåer kan legges til uten å endre dem.
  # Kilde: Confluence «Behovene ved tilgangsstyring av KREG» (KK, side 5086904327).
  #
  # Hvordan en applikasjon får tildelt en tilgangsrolle, er dekket av
  # @BRU-APP-API-007 (Tildele tilganger til en applikasjon). Dette kravet sier
  # hvilke tilganger som finnes for kompetansedata, og hva de gir tilgang til.

  Regel: Tilgang til kompetansedata krever både tilgangsrolle og organisasjon

    Scenario: Opptakssystemet leser VGS-vitnemål uavhengig av utsteder
      Gitt opptakssystemet har en tilgangsrolle som gir lesetilgang til VGS-vitnemål
      Og tilgangsrollen gjelder for Sikt
      Når opptakssystemet henter VGS-vitnemålene til en søker
      Så får opptakssystemet vitnemålene uavhengig av hvilken organisasjon som har utstedt dem

    Scenario: Applikasjon uten tilgangsrolle får ingen kompetansedata
      Gitt en applikasjon ikke har noen tilgangsrolle for kompetanseregisteret
      Når applikasjonen henter VGS-vitnemålene til en person
      Så får applikasjonen ingen kompetansedata

    @openquestion
    Scenario: Applikasjon med tilgangsrolle for en skole får bare vitnemål skolen har utstedt
      # ÅPNE SPØRSMÅL:
      # - Trengs dette for opptak 2027, eller er det et fremtidig behov som skal stå her til skolene flyttes fra NVB?
      Gitt en applikasjon har en tilgangsrolle som gir lesetilgang til VGS-vitnemål
      Og tilgangsrollen gjelder for én skole
      Når applikasjonen henter VGS-vitnemålene til en person
      Så får applikasjonen bare vitnemålene skolen har utstedt

  Regel: Tilgang til en organisasjon omfatter organisasjonene under den i hierarkiet

    Scenario: Sikt står øverst i organisasjonshierarkiet for VGS-data
      Gitt en tilgangsrolle gjelder for Sikt
      Så omfatter tilgangen alle organisasjoner som utsteder VGS-vitnemål

    @openquestion
    Scenario: Fylkeskommune omfatter de offentlige skolene i fylket
      # ÅPNE SPØRSMÅL:
      # - Hvor kommer organisasjonshierarkiet fra før Utdanningsregisteret har det? KREG har enhetsregisteret fra NVB i dag.
      Gitt en tilgangsrolle gjelder for en fylkeskommune
      Så omfatter tilgangen fylkeskommunen og de offentlige skolene fylkeskommunen er overordnet for

    Scenario: Skole uten overordnet organisasjon omfatter bare seg selv
      Gitt en tilgangsrolle gjelder for en privat skole uten overordnet organisasjon
      Så omfatter tilgangen bare den private skolen

  Regel: En tilgangsrolle gjelder ett utdanningsnivå

    Scenario: Lesetilgang til VGS-vitnemål gir ikke fagskolevitnemål
      Gitt opptakssystemet har en tilgangsrolle som gir lesetilgang til VGS-vitnemål
      Og kompetanseregisteret inneholder fagskolevitnemål
      Når opptakssystemet henter vitnemålene til en søker
      Så får opptakssystemet bare VGS-vitnemålene

    Scenario: Samme utsteder på flere utdanningsnivåer
      Gitt en organisasjon har utstedt både VGS-vitnemål og fagskolevitnemål
      Og en applikasjon har lesetilgang til VGS-vitnemål for organisasjonen
      Når applikasjonen henter vitnemålene til en person
      Så får applikasjonen bare VGS-vitnemålene

  Regel: Lesetilgang gir ikke skrivetilgang

    Scenario: Opptakssystemet kan ikke endre kompetansedata
      Gitt opptakssystemet har en tilgangsrolle som gir lesetilgang til VGS-vitnemål
      Når opptakssystemet forsøker å registrere eller endre et vitnemål
      Så avvises endringen

# ÅPNE SPØRSMÅL:
# - Hvilke tilgangsroller skal finnes i navnerommet for kompetanseregisteret i første leveranse, og hva skal de hete? Bare én leserolle for VGS-vitnemål?
# - Hvilke data omfatter lesetilgangen til VGS-vitnemål: kompetanseoppnåelser, merknader og fravær, personopplysninger om vitnemålshaveren (nasjonal id, navn, fødselsdato), og navn på rektor/underskriver? Er kodeverk og enhetsregisteret åpne data uten krav om tilgangsrolle?
# - Hva skal applikasjonen få når tilgangsrollen mangler: tomt resultat, eller en feil som sier at tilgangen mangler?
# - Skal tilgangsrollene skille på dokumenttype (vitnemål og kompetansebevis), eller dekker «VGS-vitnemål» begge?
# - Confluence-siden sier at man skal kunne tildele tilgangsroller for sin egen organisasjon og organisasjonene under. Det er en generell regel for tilgangsstyring (07), ikke for kompetansedata. Skal den likevel nevnes her?
