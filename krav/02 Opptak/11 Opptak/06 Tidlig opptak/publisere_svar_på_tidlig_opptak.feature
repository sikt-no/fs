# language: no
# GitHub: #456
@OPT-OPT-TID-001 @must @draft
Egenskap: Publisere svar på tidlig opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg å styre når svaret på tidlig opptak blir synlig for søkerne, og sende dem melding om utfallet
  slik at alle søkere får svar samtidig og først etter at tilbudsgarantiene er kvalitetssikret.

  # Kravet forutsetter at søkerne har søkt om tidlig opptak, at saksbehandlerne har konkludert,
  # og at tilbudsgarantier for tidlig opptak er tildelt.
  # Søkerens side av svaret er beskrevet i
  # krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/se_svar_på_tidlig_opptak.feature.
  Bakgrunn:
    Gitt at opptaksforvalter ved forvaltende organisasjon er innlogget
    Og at opptaket "Samordna opptak 2027" er åpnet for tidlig opptak

  # Publiseringsdatoen (T-day) ligger på opptaket, jf. prosesshypotesen i notatet
  # "2026-09-23 tidligopptaks-svar til søker".
  # Merk avvik som må ryddes: krav/02 Opptak/12 Utdanningstilbud/opptaksinnstillinger_utdanningstilbud.feature
  # legger i dag "dato for når svar sendes til søkere" på det enkelte utdanningstilbudet.
  # Den datoen må fjernes eller omdefineres der, slik at det finnes én publiseringsdato per opptak.
  Regel: Opptaksforvalter setter publiseringsdato for svar på tidlig opptak

    Scenario: Sette publiseringsdato
      Når opptaksforvalter setter publiseringsdato for svar på tidlig opptak til 20. april 2027
      Så blir svaret på tidlig opptak synlig for søkerne fra 20. april 2027

    Scenario: Endre publiseringsdato før den er passert
      Gitt at publiseringsdatoen for svar på tidlig opptak ikke er passert
      Når opptaksforvalter endrer publiseringsdatoen for svar på tidlig opptak
      Så er det den nye datoen som avgjør når svaret blir synlig for søkerne

  # Hva søkeren faktisk ser før og etter publiseringsdatoen, er beskrevet i
  # krav/02 Opptak/13 Søknad og saksbehandling/01 Søknad/se_svar_på_tidlig_opptak.feature.
  Regel: Opptaksforvalter utløser utsending av melding om svar på tidlig opptak

    Scenario: Sende melding om svar på tidlig opptak
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Når opptaksforvalter sender ut melding om svar på tidlig opptak
      Så mottar hver søker som har søkt om tidlig opptak i opptaket en melding om utfallet

    Scenario: Søkere som ikke har søkt om tidlig opptak får ikke melding
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Når opptaksforvalter sender ut melding om svar på tidlig opptak
      Så mottar ikke søkere uten søknad om tidlig opptak melding om tidlig opptak

    Scenariomal: Meldingen gjenspeiler søkerens utfall
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkerens samlede utfall i tidlig opptak er "<utfall>"
      Når opptaksforvalter sender ut melding om svar på tidlig opptak
      Så mottar søkeren en melding som sier "<budskap>"

      Eksempler:
        | utfall                                     | budskap                                                          |
        | innvilget på minst ett søknadsalternativ   | søkeren er innvilget tidlig opptak og bør kontrollere prioriteringen sin |
        | ikke innvilget på noen søknadsalternativer | søkeren er ikke innvilget tidlig opptak                          |

    Scenario: Meldingen sendes på søkerens språk
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Og at søkeren har valgt engelsk som språk
      Når opptaksforvalter sender ut melding om svar på tidlig opptak
      Så mottar søkeren meldingen på engelsk

  # Regelen over beskriver den fullførte utsendingen. Regelen under legger et
  # bekreftelsessteg foran den, og endrer ikke utfallet — søkerne mottar de samme meldingene.
  @openquestion
  # ÅPNE SPØRSMÅL:
  # - Skal opptaksforvalter kunne kontrollere meldingsinnholdet før det når søkerne?
  #   I dagens SO-løsning holdes brevene tilbake for en siste sjekk. Aktuelle varianter er
  #   forhåndsvisning ved utløsning, en angrefrist der meldingene kan trekkes tilbake,
  #   eller begge deler. Scenarioet under beskriver forhåndsvisning, og er et forslag.
  #   Merk at prosesshypotesen i notatet "2026-09-23 tidligopptaks-svar til søker" skiller
  #   kjøringen av automatikken (før publiseringsdatoen) fra meldingen (etter), slik at
  #   embargoen fra SO-løsningen ikke lenger er den samme mekanismen. Se også det åpne
  #   spørsmålet nederst om dry-run er tilstrekkelig kvalitetssikring.
  Regel: Opptaksforvalter kontrollerer meldingsinnholdet før utsending

    Scenario: Forhåndsvise meldingen før utsending
      Gitt at publiseringsdatoen for svar på tidlig opptak er passert
      Når opptaksforvalter starter utsending av melding om svar på tidlig opptak
      Så ser opptaksforvalter en forhåndsvisning av meldingen
      Og meldingene sendes først når opptaksforvalter bekrefter utsendingen

# ÅPNE SPØRSMÅL:
# - Automatikken for tildeling av tilbudsgaranti må være kjørt før publiseringsdatoen
#   (prosesshypotesen i notatet "2026-09-23 tidligopptaks-svar til søker" punkt 2).
#   Kilden beskriver dette som en prosessrekkefølge, ikke som en systemregel. Hva skal
#   løsningen gjøre hvis automatikken ikke er kjørt når publiseringsdatoen passeres?
#   Aktuelle varianter: (a) ingenting — svaret blir tomt og alle søkere ser "ikke innvilget",
#   (b) opptaksforvalter varsles om at automatikken må kjøres, (c) meldingsutsending sperres
#   til automatikken er kjørt. Variant (c) kan låse forvalter ute i tilfeller vi ikke har
#   kartlagt ennå, for eksempel omkjøringer.
# - Hvor hører regelen over hjemme? Den binder publiseringsdatoen, men handler om
#   tildelingsrutinen, som er utenfor scope for denne fila. Kan like gjerne legges i kravet
#   for tildeling av tilbudsgaranti for tidlig opptak når det skrives.
# - Kan opptaksforvalter utløse utsendingen flere ganger, for eksempel etter en omkjøring
#   av tildelingsrutinen? I så fall: får søkere som allerede har fått melding en ny melding?
# - Skal opptaksforvalter se utfallet av tidlig opptak før publiseringsdatoen, eller er
#   dry-run av tildelingsrutinen den eneste kvalitetssikringen før publisering?
