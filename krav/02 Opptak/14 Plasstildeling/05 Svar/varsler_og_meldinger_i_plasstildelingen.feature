# language: no
# BEGREPER (2026-11-10): Bytt «opptakets forvalter» med «forvalter» når fila likevel endres. Se krav/02 Opptak/begreper.md.
@OPT-PLA-SVA-002 @should @draft @scope-plasstildeling-2027
Egenskap: Varsler og meldinger i plasstildelingen
  Som opptaksforvalter
  ønsker jeg at lærestedene og søkerne får varsler og meldinger fra løsningen gjennom plasstildelingen
  slik at de vet når de må gjøre noe, uten at opptakets forvalter sender e-post utenfor løsningen.

  # Skilt ut 2026-10-28 (produkteier) fra antall_tilbud_som_skal_gis.feature, forvalte_runder.feature,
  # håndtere_svar_fra_søker.feature og publisere_resultat.feature, så varslene og meldingene kan leveres
  # etter det som er @must. I dag sender HK-dir dem på e-post utenfor løsningen.

  # Regelen «Lærestedene varsles når perioden for å endre antall tilbud åpner» er flyttet 2026-11-02 til
  # 02 Tildelingsinnstillinger/følge_opp_lærestedenes_gjennomgang.feature (Could, produkteier).

  @depends-on-OPT-PLA-RUN-001
  Regel: Søkere med ubesvart tilbud får påminnelse om svarfristen
    # Gap mot koden (verifisert 2026-10-09): påminnelse om svarfrist finnes ikke i fs-admin eller fs-plattform.
    # Endret 2026-10-28 etter brukertesten med HK-dir 2026-10-27: påminnelsen settes med dato og klokkeslett.
    # AVKLART 2026-10-28 (produkteier, etter brukertesten med HK-dir): Én påminnelse per plasstildelingsrunde holder.
    Scenario: Sette påminnelse om svarfrist
      Gitt at plasstildelingsrunden "Hovedrunde" har svarfrist "2027-07-20 23:59"
      Når opptaksforvalter setter påminnelse om svarfrist til "2027-07-18 09:00"
      Så får søkere med ubesvart tilbud i plasstildelingsrunden en påminnelse "2027-07-18 09:00"

    # AVKLART 2026-11-02 (produkteier, prototypen v88): Påminnelsen må komme før svarfristen.
    Scenario: Påminnelsen kommer etter svarfristen
      Gitt at plasstildelingsrunden "Hovedrunde" har svarfrist "2027-07-20 23:59"
      Når opptaksforvalter setter påminnelse om svarfrist til "2027-07-21 09:00"
      Så blir påminnelsen ikke lagret
      Og opptaksforvalter får beskjed om at påminnelsen må komme før svarfristen

  @depends-on-OPT-PLA-RUN-001 @depends-on-OPT-PLA-SVA-001
  Regel: Søkeren får melding når svarfristen flyttes
    # Brukertesten med HK-dir 2026-10-27: svarfristen kan flyttes, men det må være tydelig for søkeren.
    # At søkeren ser den nye svarfristen på tilbudet, står i håndtere_svar_fra_søker.feature.

    Scenario: Søkeren får melding om ny svarfrist
      Gitt at søkeren "Kari Nordmann" har fått tilbud på "Sykepleie, høst 2027" i "Hovedrunde" med svarfrist "2027-07-20 23:59"
      Og at søkeren ikke har svart på tilbudet
      Når opptaksforvalter endrer svarfristen for "Hovedrunde" til "2027-07-25 23:59"
      Så får søkeren en melding om at svarfristen er "2027-07-25 23:59"

  @depends-on-OPT-PLA-RES-002 @ref-OPT-SØK-SØK-010
  Regel: Søkere med tilbud får melding når resultatet publiseres
    # Meldingene søkeren ser i Min kompetanse, står i 13 Søknad og saksbehandling/01 Søknad/mine_meldinger.feature.
    # Svarbrevet (vedtaksbrevet) er ikke med. Det utforskes for seg, se Confluence «Vedtaksbrev og svar på opptaket».

    Scenario: Søkeren får melding når plasstildelingen publiseres
      Gitt at søkeren "Kari Nordmann" har fått tilbud på "Sykepleie, høst 2027" i plasstildelingen i "Hovedrunde"
      Når opptaksforvalter publiserer plasstildelingen
      Så får søkeren melding om at svar foreligger med svarfristen for plasstildelingsrunden
