# language: no
@OPT-OPT-TEK-002 @won´t @draft
  ## Denne blir liggene til etter T3 2027, innholdet skal verifiseres og veivalg for den funksjonelle arkitekturen må besluttes
Egenskap: Svarmeldingsmal for opptak
  Som opptaksforvalter
  ønsker jeg å aktivere svarmelding med juridisk kjerne
  slik at søkere automatisk varsles når det foreligger et vedtak.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at opptaket "Samordna opptak 2027" er opprettet

  Regel: Opptaksforvalter kan aktivere svarmelding for opptaket

    Scenario: Aktivere svarmelding
      Når jeg aktiverer svarmelding for opptaket
      Så får søkere automatisk varsel hver gang det foreligger et vedtak til dem i opptaket

  Regel: Svarmeldingen har en juridisk kjerne som ikke kan endres

    Scenario: Juridisk kjerne er låst
      Gitt at svarmelding er aktivert
      Så inneholder svarmeldingen formuleringer om enkeltvedtak, klageadgang og klagefrist
      Og den juridiske kjernen kan ikke endres av lærested eller opptakseier

  Regel: Svarmeldingen bruker innstillinger fra opptaket automatisk

    Scenario: Opptaksnavn og svarfrist settes automatisk i meldingen
      Gitt at svarmelding er aktivert
      Og at plasstildelingsrunden har svarfrist "2027-07-20"
      Når svarmeldingen sendes
      Så inneholder meldingen opptakets navn "Samordna opptak 2027"
      Og meldingen inneholder svarfristen "2027-07-20"

  Regel: Lærested eller opptakseier kan legge til tilleggsinformasjon

    Scenario: Legge til tilleggsinformasjon i svarmeldingen
      Gitt at svarmelding er aktivert
      Når jeg legger til tilleggsinformasjon i svarmeldingen
      Så vises tilleggsinformasjonen etter den juridiske kjernen
      Men tilleggsinformasjonen overskriver ikke kjerneteksten

  Regel: Tekst i svarmeldingen må kunne angis på flere språk

    Scenario: Svarmelding på flere språk
      Gitt at svarmelding er aktivert
      Når jeg angir tilleggsinformasjon på bokmål, nynorsk, engelsk og samisk
      Så er svarmeldingen tilgjengelig på alle fire språk