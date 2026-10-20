# language: no
@OPT-SØK-SØK-006 @must @implemented
Egenskap: Prioritere søknadsalternativer
  Som en søker
  ønsker jeg å bestemme rekkefølgen på utdanningstilbudene jeg søker på
  slik at jeg får tilbud om den studieplassen jeg helst vil ha.

  Bakgrunn:
    Gitt at søkeren er innlogget i Min kompetanse
    Og søkeren har utdanningstilbud i studiekurven for et opptak

  Regel: Søkeren bestemmer rekkefølgen på søknadsalternativene

    Scenario: Søkeren endrer rekkefølgen på søknadsalternativene
      Gitt at søkeren er i prioriteringssteget i søknaden
      Når søkeren flytter et søknadsalternativ til en annen plassering
      Så vises søknadsalternativene i den nye rekkefølgen

    Scenario: Rekkefølgen lagres på søknadskladden
      Gitt at søkeren har endret rekkefølgen på søknadsalternativene
      Når søkeren lagrer prioriteringen
      Så har søknadskladden den nye rekkefølgen

    Scenario: Søkeren fjerner et søknadsalternativ i prioriteringssteget
      Gitt at søkeren har flere søknadsalternativer i søknaden
      Når søkeren fjerner et søknadsalternativ
      Så inngår ikke utdanningstilbudet lenger i søknaden
      Og de gjenværende søknadsalternativene beholder innbyrdes rekkefølge

    Scenario: Søkeren har ingen søknadsalternativer igjen
      Gitt at søkeren er i prioriteringssteget i søknaden
      Når søkeren fjerner det siste søknadsalternativet
      Så får søkeren beskjed om at søknaden er tom
      Og søkeren tilbys å legge til utdanningstilbud

  Regel: Prioriteringen kan endres på en levert søknad

    # AVKLART 2026-10-19 (produkteier): Det er to frister på opptaket, omprioriteringsfristen og fristen for
    # sletting av søknadsalternativer (11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature).
    # Fristen for sletting kan være senere enn omprioriteringsfristen (Q6), ikke omvendt slik kvitteringstekstene
    # i Confluence sier.
    Scenario: Søkeren endrer prioritering på en levert søknad
      Gitt at søkeren har levert en søknad i et opptak
      Og fristen for å endre prioritering ikke har gått ut
      Når søkeren endrer prioriteringen og lagrer den
      Så har søknaden den nye prioriteringen

    Scenario: Søkeren forkaster endringer i en levert søknad
      Gitt at søkeren har endret prioriteringen på en levert søknad uten å levere på nytt
      Når søkeren velger å forkaste endringene
      Så har søknaden prioriteringen fra sist levering

  @draft
  Regel: Rekkefølgen på søknadsalternativene er låst etter omprioriteringsfristen
    # Virkningen av omprioriteringsfristen som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.

    Scenario: Søkeren kan endre rekkefølgen på søknadsalternativene fram til omprioriteringsfristen
      Gitt at omprioriteringsfristen i opptaket er "2027-04-15 23:59"
      Og at søkeren har levert en søknad i opptaket
      Når søkeren endrer rekkefølgen på søknadsalternativene "2027-04-15 12:00"
      Så har søknaden den nye rekkefølgen

    Scenario: Søkeren kan ikke endre rekkefølgen på søknadsalternativene etter omprioriteringsfristen
      Gitt at omprioriteringsfristen i opptaket er "2027-04-15 23:59"
      Og at søkeren har levert en søknad i opptaket
      Når søkeren vil endre rekkefølgen på søknadsalternativene "2027-04-16"
      Så kan søkeren ikke endre rekkefølgen på søknadsalternativene

  @draft
  Regel: Søkeren kan slette søknadsalternativer fram til fristen for sletting
    # Virkningen av fristen for sletting av søknadsalternativer som opptaksforvalter setter i
    # 11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature.
    # Lagt til 2026-10-19 etter akseptansetesten av opprette og vedlikeholde opptak.
    # AVKLART 2026-10-15 (Q6, TAKE-411): Fristen for sletting kan være senere enn omprioriteringsfristen,
    # så søkeren kan slette søknadsalternativer etter at rekkefølgen er låst.

    Scenario: Søkeren kan slette et søknadsalternativ fram til fristen for sletting
      Gitt at fristen for sletting av søknadsalternativer i opptaket er "2027-04-15 23:59"
      Og at søkeren har levert en søknad med flere søknadsalternativer
      Når søkeren sletter et søknadsalternativ fra søknaden "2027-04-15 12:00"
      Så er søknadsalternativet slettet

    Scenario: Søkeren kan ikke slette et søknadsalternativ etter fristen for sletting
      Gitt at fristen for sletting av søknadsalternativer i opptaket er "2027-04-15 23:59"
      Og at søkeren har levert en søknad med flere søknadsalternativer
      Når søkeren vil slette et søknadsalternativ fra søknaden "2027-04-16"
      Så kan søkeren ikke slette søknadsalternativet

    # Flyttet fra frister_og_hendelser.feature. AVKLART 2026-10-15 (Q3, TAKE-410 og TAKE-411): En frist for når
    # noe stenger, som ikke er satt, begrenser ikke handlingen.
    Scenario: Søkeren kan slette et søknadsalternativ når fristen for sletting ikke er satt
      Gitt at det ikke er satt frist for sletting av søknadsalternativer i opptaket
      Og at søkeren har levert en søknad med flere søknadsalternativer
      Når søkeren sletter et søknadsalternativ fra søknaden
      Så er søknadsalternativet slettet
