# language: no
# GitHub: #571
#
# STATUS: Dette kravet er et diskusjonsgrunnlag, ikke en spesifikasjon.
# Pliktene under er juridisk avklart og har hjemmel, men mekanikken — hvem som
# utfører, hva som står igjen, og hvordan avgrensningen per behandlingsansvarlig
# realiseres — er ikke besluttet. Hver Regel bærer derfor et åpent spørsmål.
# Skal ikke legges til grunn for implementasjon slik den står.
#
# Kilde: Juridisk vurdering 21.06.2026, Juridisk seksjon (arkiveres i P360).
#
@OPT-BEH-DOK-002 @must @draft
Egenskap: Slette dokumentasjon uten behandlingsgrunnlag
  Som søker
  ønsker jeg at dokumenter jeg har lastet opp uten at de var etterspurt blir slettet
  slik at opplysninger om meg ikke oppbevares uten rettslig grunnlag.

  Bakgrunn:
    Gitt jeg er innlogget i FS Admin

  Regel: Dokumentasjon uten behandlingsgrunnlag skal slettes

    @openquestion
    Scenario: Dokument uten behandlingsgrunnlag slettes
      Gitt søkeren har lastet opp et dokument som ikke var etterspurt
      Og det foreligger ikke behandlingsgrunnlag for dokumentet
      Når dokumentet slettes
      Så er dokumentet ikke lenger tilgjengelig i løsningen
      # ÅPNE SPØRSMÅL:
      # - Plikten er avklart: GDPR art. 5 nr. 1 bokstav c og e, og juristen
      #   slår fast at opptakets behandlingsgrunnlag ikke dekker uoppfordret
      #   opplastede dokumenter. Samtykke er vurdert som lite egnet, jf.
      #   fortalepunkt 43 om maktubalanse mot offentlig organ.
      # - Uavklart: hvordan avgjøres det at behandlingsgrunnlag mangler?
      #   Er det en menneskelig vurdering, eller kan dokumenttype og
      #   søknadskontekst avgjøre det maskinelt?

  Regel: Sletteansvaret følger behandlingsansvaret

    @openquestion
    Scenario: Behandlingsansvarlig sletter innenfor sitt eget område
      Gitt et dokument mangler behandlingsgrunnlag hos én behandlingsansvarlig
      Når dokumentet slettes for denne behandlingsansvarlige
      Så er dokumentet ikke lenger tilgjengelig for denne behandlingsansvarlige
      # ÅPNE SPØRSMÅL:
      # - Ansvarsfordelingen er avklart: HK-dir er behandlingsansvarlig i det
      #   samordnede opptaket, organisasjonene i egne opptak. Juristen skriver
      #   at systemet bør støtte at ulike behandlingsansvarlige kan slette
      #   "innenfor sitt eget område".
      # - Uavklart: hvilken rolle i FS utfører dette? Produkteier har antydet
      #   at behandlingsansvarlig og "opptaksforvalter" er overlappende, men
      #   ingen av begrepene finnes i gherkin-conventions.md i dag.
      # - Uavklart: lar avgrensningen seg realisere? Se
      #   behandle_søknad.feature:27 — er dokumentasjon knyttet til søknaden
      #   eller til personen? Henger den på personen, kan ikke én
      #   behandlingsansvarlig slette uten å røre de andres grunnlag.

  Regel: Sletting skal begrunnes

    @openquestion
    Scenario: Sletting registreres med begrunnelse
      Gitt et dokument skal slettes
      Når dokumentet slettes
      Så registreres begrunnelsen for slettingen
      # ÅPNE SPØRSMÅL:
      # - Uavklart: hva står igjen etter sletting? Sletteplikten tilsier at
      #   innholdet skal bort, sporbarhetskravet tilsier at handlingen må
      #   kunne etterprøves. En begrunnelse som ikke lagres har ingen verdi.
      #   Juristen viser til at DPIA-en skal gjennomgå sletteprosedyrer
      #   eksplisitt — DPIA v1 var ikke ferdigstilt per juni 2026.
      # - Uavklart: er begrunnelsen fritekst, eller valg fra en fast liste?

  Regel: Søker skal få vite at dokumentasjon er slettet

    @openquestion
    Scenario: Søkeren informeres om slettingen
      Gitt et dokument søkeren har lastet opp er slettet
      Når søkeren ser på søknaden sin
      Så får søkeren vite at dokumentet er slettet og hvorfor
      # ÅPNE SPØRSMÅL:
      # - Dagens praksis informerer søkeren, men juristens forespørsel
      #   konstaterer at det ikke endrer adferden: søkerne laster opp de samme
      #   dokumentene igjen fordi de selv mener det er greit.
      # - Uavklart: skal informasjonen gis, og i hvilken form? Se #572 om
      #   forebygging, som juristen mener er det virksomme tiltaket.

  Regel: Politiattest skal tilintetgjøres når formålet er bortfalt

    @openquestion
    Scenario: Politiattest tilintetgjøres
      Gitt søkeren har lastet opp et dokument av typen "Politiattest"
      Når formålet med politiattesten er bortfalt
      Så er politiattesten tilintetgjort
      # ÅPNE SPØRSMÅL:
      # - Kravet er avklart: politiregisterforskriften § 37-2 sier attesten
      #   ikke kan oppbevares "utover det tidspunkt vedkommende slutter i den
      #   stillingen som ga grunnlaget for vandelskontroll", og at den da
      #   "skal tilintetgjøres".
      # - Uavklart: bestemmelsen er skrevet for stillingsforhold. Hva er
      #   utløsende hendelse i opptak — avslag, avslått tilbud, fullført
      #   praksis, eller avsluttet studierett? Må avklares med jurist.

# ÅPNE SPØRSMÅL:
# - Skal søkeren selv kunne slette dokumentasjon? Ubehandlet to-do fra møtet
#   28.08.2026, tilordnet Steffen Andre Marstein. Merk at
#   søke_på_opptak.feature:121 alt sier at søker kan slette etter innsending —
#   det kravet er skrevet før beslutningen er tatt, og de to må samordnes.
# - Retensjon for dokumenter med behandlingsgrunnlag er ikke dekket her. Se
#   skjerme_dokumentasjon.feature.
