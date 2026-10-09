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
  # Status 2026-10-09: skrevet av én person, og skal diskuteres med teamet før
  # kravet valideres og får @planned.
  #
  # Hvordan en applikasjon får tildelt en tilgangsrolle, er dekket av
  # @BRU-APP-API-007 (Tildele tilganger til en applikasjon). Dette kravet sier
  # hvilke tilganger som finnes for kompetansedata, og hva de gir tilgang til.

  Regel: Lesetilgang til kompetansedata gis per datatype og utdanningsnivå

    # Rollene er hentet fra Confluence «Tilgangsstyring - Forslag til roller»
    # (KK, side 5058297879), som er under arbeid. En konsument får det settet av
    # roller som til sammen dekker behovet, ikke én rolle per konsument. Rollene
    # er generelle: det lages ingen roller skreddersydd for opptak, og
    # opptakssystemet får det settet av generelle roller det trenger. Rollene
    # for vitnemålsdata gjelder ett utdanningsnivå; rollene for personidentitet og
    # kodeverk er uavhengige av utdanningsnivå.
    #
    # Som ellers i fs-plattform håndheves lesetilgangen i databasen ved radfiltrering:
    # det applikasjonen ikke har leserolle for, er utelatt fra svaret, uten feil.
    # Skriving uten tilgang avvises med feil.

    @openquestion
    Scenariomal: Hver datatype krever sin egen leserolle
      # ÅPNE SPØRSMÅL:
      # - Skal kodeverk og grunndata være åpne data uten krav om leserolle? Rolleforslaget har «kan ev. være åpen(?)» på KREG_KODEVERK_LES. Rollen finnes uansett; spørsmålet er om Sikt registrerer den som åpen rolle.
      Gitt en applikasjon har leserollen <rolle> for Sikt
      Når applikasjonen henter VGS-vitnemålene til en person
      Så får applikasjonen <data>
      Men data som krever en annen leserolle, er utelatt fra svaret

      Eksempler:
        | rolle                            | data                                                                                                  |
        | KREG_DOKUMENT_VGS_LES            | dokumentopplysningene for VGS-vitnemål: status, dato, utstedende organisasjon, dokumenttype og målform |
        | KREG_KOMPETANSEOPPNAELSE_VGS_LES | innholdet i VGS-vitnemål: utdanningsprogram, avgangsår, påstand om GSK, programområde, fravær, fag og vekting |
        | KREG_VURDERING_VGS_LES           | karakterene i VGS-vitnemål: vurderingsuttrykk, vurderingsform, hvem som vurderte og når               |
        | KREG_MERKNAD_VGS_LES             | merknadene på VGS-vitnemål                                                                            |
        | KREG_PERSON_LES                  | fornavn, etternavn og fødselsnummer eller D-nummer, og navnet slik det står på vitnemålet             |
        | KREG_KODEVERK_LES                | kodeverk og grunndata: fagkoder, programkoder, karakterskalaer, vurderingsformer og vektingstyper     |

    Scenario: Opptakssystemet leser VGS-vitnemål uavhengig av utsteder
      Gitt opptakssystemet har leserollene for VGS-dokument, VGS-oppnåelse, VGS-vurdering, VGS-merknad og kodeverk for Sikt
      Når opptakssystemet henter VGS-vitnemålene til en søker
      Så får opptakssystemet VGS-vitnemålene med innhold, karakterer og merknader uavhengig av hvilken organisasjon som har utstedt dem

    Scenario: Oppslag på fødselsnummer uten leserolle for personidentitet
      Gitt opptakssystemet har leserollene for VGS-vitnemål, men ikke leserollen for personidentitet
      Når opptakssystemet henter VGS-vitnemålene til en søker ut fra fødselsnummer
      Så får opptakssystemet VGS-vitnemålene
      Men opptakssystemet får ikke navn eller fødselsnummer fra kompetanseregisteret

    Scenario: Applikasjon uten leserolle får tomt svar
      Gitt en applikasjon ikke har noen leserolle for kompetanseregisteret
      Når applikasjonen henter VGS-vitnemålene til en person
      Så får applikasjonen et tomt svar uten feil om manglende tilgang

  @openquestion
  Regel: Leserollene for VGS-data gjelder for Sikt og gir alle VGS-vitnemål i registeret
    # ÅPNE SPØRSMÅL:
    # - Kan leserollene for VGS-data gis for andre organisasjoner enn Sikt? Rolleforslaget sier at bare Sikt tildeler dem, men andre organisasjoner, som FS, SSB og Lånekassen, kan senere trenge data fra flere organisasjoner. Ikke et krav for opptak 2027.

    # Tilgangsstyringen i fs-plattform har ingen organisasjon over organisasjonene, og
    # ingen hierarki mellom dem: all tilgang er (organisasjon, rolle, miljø). Sikt er
    # behandlingsansvarlig for hele den nasjonale vitnemålsbasen, så en leserolle for
    # VGS-data som gjelder for Sikt, gir VGS-vitnemål uavhengig av hvem som har
    # utstedt dem. Den gir ingenting fra andre utdanningsnivåer.

    Scenario: Leserolle for VGS-data for Sikt gir VGS-vitnemål fra alle utstedere
      Gitt en applikasjon har leserollen for VGS-oppnåelse for Sikt
      Når applikasjonen henter VGS-vitnemålene til en person
      Så får applikasjonen VGS-vitnemålene uavhengig av hvilken organisasjon som har utstedt dem
      Men applikasjonen får ikke vitnemål fra andre utdanningsnivåer

  @openquestion
  Regel: Leserolle for egen organisasjon omfatter organisasjonene under den
    # ÅPNE SPØRSMÅL:
    # - Rollen KREG_KOMPETANSEOPPNAELSE_VGS_EGEN_ORG_LES trengs ikke for opptak 2027. Regelen står her for at leserollene for Sikt og leserollene for egen organisasjon skal følge samme modell, så ingenting må skrives om når skole- og fylkeskommunebrukere kommer.
    # - Tilgangsstyringen kjenner bare organisasjonene fra Utdanningsregisteret (organisasjonskode), uten hierarki. KREG har enhetsregisteret fra NVB (organisasjonsnummer, med overordnet enhet), uten kobling til organisasjonskode. Hvor skal koblingen og hierarkiet ligge?
    # - Tildeling nedover (Sikt til fylkeskommunene, fylkeskommunen til skolene) krever tildelingsrettighet for organisasjonen rollen gjelder for, og avhenger av den samme koblingen mellom organisasjonskode og enhet.
    # - Confluence-siden har bare EGEN_ORG-variant for oppnåelse. Skal dokument, vurdering og merknad ha det samme?

    Scenario: Fylkeskommune leser VGS-vitnemål fra skolene i fylket
      Gitt en bruker i en fylkeskommune har leserollen for VGS-oppnåelse for organisasjonen brukeren tilhører
      Når brukeren henter VGS-vitnemålene til en person
      Så får brukeren bare VGS-vitnemål utstedt av fylkeskommunen og organisasjonene under fylkeskommunen

    Scenario: Skole leser bare VGS-vitnemål skolen selv har utstedt
      Gitt en bruker ved en skole uten organisasjoner under seg har leserollen for VGS-oppnåelse for organisasjonen brukeren tilhører
      Når brukeren henter VGS-vitnemålene til en person
      Så får brukeren bare VGS-vitnemålene skolen har utstedt

  Regel: En leserolle for vitnemålsdata gjelder ett utdanningsnivå

    Scenario: Leserollene for VGS gir ikke fagskolevitnemål
      Gitt opptakssystemet har leserollene for VGS-dokument, VGS-oppnåelse, VGS-vurdering og VGS-merknad for Sikt
      Og kompetanseregisteret inneholder fagskolevitnemål
      Når opptakssystemet henter vitnemålene til en søker
      Så får opptakssystemet bare VGS-vitnemålene

    Scenario: Samme utsteder på flere utdanningsnivåer
      Gitt en organisasjon har utstedt både VGS-vitnemål og fagskolevitnemål
      Og en applikasjon har leserollene for VGS-vitnemål for Sikt
      Når applikasjonen henter vitnemålene til en person
      Så får applikasjonen bare VGS-vitnemålene

  Regel: Lesetilgang gir ikke skrivetilgang

    Scenario: Opptakssystemet kan ikke endre kompetansedata
      Gitt opptakssystemet har leserollene for VGS-vitnemål for Sikt
      Når opptakssystemet forsøker å registrere eller endre et vitnemål
      Så avvises endringen
