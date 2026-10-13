# language: no
@OPT-REG-RAN-003 @must @draft
Egenskap: Poenglikhetsregel
  Som opptaksforvalter
  ønsker jeg å definere poenglikhetsregler i regelverkssamlingen
  slik at de kan brukes som standard poenglikhetsregel på opptak.

  # OBS: Poenglikhetsregelen registreres i regelverkssamlingen, men settes som
  # standard på opptaket — ikke på rangeringsregelverket. Det er uklart hvorfor
  # regelen registreres i regelverkssamlingen og ikke rett på opptaket.
  # Se opptak/design.md for hvordan den brukes.

  Bakgrunn:
    Gitt at jeg er innlogget som opptaksforvalter
    Og at regelverkssamlingen "UHG2027" er opprettet

  Regel: Opptaksforvalter kan opprette poenglikhetsregler i regelverkssamlingen

    Scenario: Opprette poenglikhetsregel med loddtrekning
      Når jeg oppretter en poenglikhetsregel med kode "LODD-UHG"
      Og jeg angir navn "Loddtrekning (UHG fra 2027)"
      Og jeg setter rekkefølge: loddtrekning først
      Så er poenglikhetsregelen opprettet i regelverkssamlingen

    Scenario: Opprette poenglikhetsregel med alder
      Når jeg oppretter en poenglikhetsregel med kode "ALDER-HYU"
      Og jeg angir navn "Rangering etter alder (HYU)"
      Og jeg setter rekkefølge: alder først
      Så er poenglikhetsregelen opprettet i regelverkssamlingen

    Scenario: Opprette poenglikhetsregel med søknadstidspunkt
      Når jeg oppretter en poenglikhetsregel med kode "TIDSPUNKT-LSP"
      Og jeg angir navn "Tidspunkt for levert søknad (ledige studieplasser)"
      Og jeg setter rekkefølge: tidspunkt først
      Så er poenglikhetsregelen opprettet i regelverkssamlingen

  Regel: En poenglikhetsregel har konfigurerbar rekkefølge mellom kriteriene

    Scenario: Sette rekkefølge med flere kriterier
      Når jeg oppretter en poenglikhetsregel
      Og jeg setter rekkefølge: loddtrekning som 1, underrepresentert kjønn som 2
      Så brukes loddtrekning først, deretter underrepresentert kjønn ved fortsatt likhet

  Regel: En poenglikhetsregel kan aktiveres og deaktiveres

    Scenario: Deaktivere poenglikhetsregel
      Gitt at poenglikhetsregelen "LODD-UHG" er aktiv
      Når jeg deaktiverer poenglikhetsregelen
      Så er den ikke lenger tilgjengelig for valg på opptak

  Regel: En poenglikhetsregel kan slettes

    Scenario: Slette poenglikhetsregel
      Gitt at poenglikhetsregelen "TestPoenglikhet" ikke er i bruk
      Når jeg sletter poenglikhetsregelen
      Så er den slettet