# language: no
# Kilde: Jira STEK-270. Hvilken utdanningskvote tilbudsgarantiene tas fra for et
# utdanningstilbud, settes i opptaksinnstillingene («Sette hvor tilbudsgarantier tas fra» i
# 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature,
# OPT-OPT-UTD-004), og brukes i plasstildelingen («Tilbudsgaranti tas fra markert
# utdanningskvote» i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature).
# Dette kravet gjelder unntak fra det valget for ett søknadsalternativ.
@OPT-BEH-BEH-017 @could @draft @scope-tilbudsgaranti-2027
Egenskap: Velge utdanningskvote for tilbudsgaranti
  Som behandler
  ønsker jeg å velge hvilken utdanningskvote tilbudsgarantien tas fra for et søknadsalternativ
  slik at søkeren får plass i riktig utdanningskvote når valget for utdanningstilbudet ikke passer.

  # ÅPNE SPØRSMÅL:
  # - Er det behov for dette i 2027?
  # - Hvilke roller kan velge utdanningskvote: bare rollen som satte tilbudsgarantien?
  # - Fant ikke unntaket i fs-plattform 21.10.2026: tilbudsgaranti_kvote har bare opptak,
  #   utdanningstilbud og kvote. Er det bygget et annet sted, eller bare i skissene?

  Regel: Behandler kan velge en annen utdanningskvote for tilbudsgarantien
