# language: no
@OPT-REG-KVO-005 @must @draft @scope-spesialvurdering-2027 @depends-on-OPT-REG-KVO-001 @depends-on-OPT-REG-GRU-001 @depends-on-OPT-REG-RAN-001 @depends-on-OPT-REG-RAN-002
Egenskap: Opprette ventekvote for søkere uten poeng
  Som opptaksforvalter
  ønsker jeg å sette opp en ventekvote for søkere uten poeng i regelverkssamlingen
  slik at søkere som ikke kan få vanlige rangeringspoeng, kan skjønnsvurderes og få tilbudsgaranti.

  # AVKLART 2026-11-06 (produkteier): Ventekvoten er en kvotetype uten plasser. Den er et venterom for søkere
  # som søker på grunnlag av realkompetanse, og søkere helt uten poeng. Kravet gir ikke kvotetypen eller
  # grunnlagene konkrete navn eller koder. De velges av den som oppretter regelverket. Kravet legger til rette
  # for at funksjonen SPEV-kvoten har hatt, også finnes i det nye opptaket.
  # AVKLART 2026-11-06 (produkteier): Ventekvoten har ingen egen rangeringsmetode. Poengene skjules per grunnlag,
  # og søkere på grunnlagene for realkompetanse og helt uten poeng skal ikke få vist poengene. De interne poengene
  # (intern stipulering) settes opp i rangeringsregelverket med egne poengklasser og poengtyper, og brukes bare
  # internt i saksbehandlingen, for å avgjøre om søkeren når opp i konkurransen uten vanlige konkurransepoeng.
  # AVKLART 2026-11-06 (produkteier): Opptaksforvalter setter opp ventekvoten og innstillingene på kvotetypen.

  Regel: Grunnlagene for søkere uten vanlige konkurransepoeng har skjulte poeng

  Regel: Interne poeng settes opp i rangeringsregelverket med egne poengklasser og poengtyper

  Regel: Ventekvoten er en kvotetype uten plasser og uten kvotespørsmål

  Regel: Ventekvoten er standard for alle utdanningstilbud og kan ikke fjernes av lærestedet
