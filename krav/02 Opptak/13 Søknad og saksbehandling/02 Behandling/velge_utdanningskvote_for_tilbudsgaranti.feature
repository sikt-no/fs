# language: no
# Kilde: Jira STEK-270. I FS-klienten kan saksbehandleren overstyre hvilken utdanningskvote
# tilbudsgarantien for et søknadsalternativ tas fra. Det finnes ikke i nye opptak, og er
# parkert i Confluence PFS 4431249457 «Ting vi må huske på før vi kan gå i produksjon».
# Hvilken utdanningskvote tilbudsgarantiene tas fra for et
# utdanningstilbud, settes i opptaksinnstillingene («Sette hvor tilbudsgarantier tas fra» i
# 12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature,
# OPT-OPT-UTD-004), og brukes i plasstildelingen («Tilbudsgaranti tas fra markert
# utdanningskvote» i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature).
# Dette kravet gjelder unntak fra det valget for ett søknadsalternativ.
@OPT-BEH-BEH-017 @could @draft @scope-tilbudsgaranti-2027
Egenskap: Velge utdanningskvote for tilbudsgaranti
  Som saksbehandler
  ønsker jeg å velge hvilken utdanningskvote tilbudsgarantien tas fra for et søknadsalternativ
  slik at søkeren får plass i riktig utdanningskvote når valget for utdanningstilbudet ikke passer.

  # ÅPNE SPØRSMÅL:
  # - Er det behov for dette i 2027?
  # - Hvilke roller kan velge utdanningskvote: bare rollen som satte tilbudsgarantien?
  # - Hvordan virker det i FS-klienten i dag?

  Regel: Saksbehandler kan velge en annen utdanningskvote for tilbudsgarantien
