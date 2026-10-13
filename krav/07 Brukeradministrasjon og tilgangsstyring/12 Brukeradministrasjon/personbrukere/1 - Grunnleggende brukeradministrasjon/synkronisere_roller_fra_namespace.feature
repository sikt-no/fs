# language: no
# GitHub: #552
@BRU-PER-GRU-010 @must @planned
Egenskap: Automatisk synkronisering av roller fra namespacet "frontend/fs-admin"
  Som brukeradministrator
  ønsker jeg at roller som legges i namespacet "frontend/fs-admin" automatisk knyttes til fs-admin-applikasjonen i rolletabellen
  slik at rolletabellen alltid speiler hvilke roller fs-admin faktisk bruker, uten at noen må registrere dem manuelt.

  Regel: Roller i namespacet knyttes automatisk til fs-admin-applikasjonen

    Scenario: Ny rolle i namespacet knyttes til fs-admin
      Når en ny rolle legges i namespacet "frontend/fs-admin"
      Så knyttes rollen til fs-admin-applikasjonen i rolletabellen
      Og rollen kan tildeles personbrukere uten at noen har registrert den manuelt

    Scenario: Rolle i et annet namespace knyttes ikke til fs-admin
      Når en ny rolle legges i et annet namespace enn "frontend/fs-admin"
      Så knyttes rollen ikke til fs-admin-applikasjonen i rolletabellen

    Scenario: Endret rolle i namespacet oppdateres i rolletabellen
      Gitt en rolle finnes i namespacet "frontend/fs-admin"
      Når opplysningene om rollen endres i namespacet
      Så viser rolletabellen de oppdaterte opplysningene for rollen
      Og eksisterende tildelinger av rollen består

  Regel: Synkroniseringen utløses av endringen i namespacet, uten manuelle steg

    Scenario: Synkronisering skjer uten at en administrator gjør noe
      Når en ny rolle legges i namespacet "frontend/fs-admin"
      Så knyttes rollen til fs-admin-applikasjonen i rolletabellen
      Og ingen administrator har måttet gjøre noe i brukeradministrasjonen

    Scenario: Synkronisering forutsetter ikke en ny utrulling av fs-admin
      Gitt fs-admin ikke er rullet ut på nytt
      Når en ny rolle legges i namespacet "frontend/fs-admin"
      Så knyttes rollen til fs-admin-applikasjonen i rolletabellen

  Regel: Roller som forsvinner fra namespacet markeres som utgått, ikke slettet

    Scenario: Rolle fjernet fra namespacet markeres som utgått
      Gitt en rolle er knyttet til fs-admin-applikasjonen i rolletabellen
      Når rollen ikke lenger finnes i namespacet "frontend/fs-admin"
      Så markeres rollen som utgått i rolletabellen
      Men rollen slettes ikke fra rolletabellen

    Scenario: Utgått rolle kan ikke tildeles på nytt
      Gitt en rolle er markert som utgått
      Når en brukeradministrator skal tildele roller til en personbruker
      Så er den utgåtte rollen ikke tilgjengelig for tildeling

    Scenario: Eksisterende tildelinger av en utgått rolle består
      Gitt personbrukere har fått tildelt en rolle
      Når rollen markeres som utgått
      Så beholder personbrukerne tildelingen av rollen
      Og personbrukerne beholder tilgangene rollen gir

    @openquestion
    Scenario: Rolle som kommer tilbake i namespacet er ikke lenger utgått
      Gitt en rolle er markert som utgått
      Når rollen igjen finnes i namespacet "frontend/fs-admin"
      Så er rollen ikke lenger markert som utgått
      Og rollen kan tildeles personbrukere på nytt
      # ÅPNE SPØRSMÅL: Skal en utgått rolle gjenoppstå automatisk hvis den kommer tilbake i
      # namespacet, eller skal gjenoppretting kreve en bevisst handling fra en administrator?

  Regel: Synkroniseringen er sporbar

    Scenario: Synkroniserte endringer er sporbare i historikk
      Når synkroniseringen legger til, oppdaterer eller markerer en rolle som utgått
      Så viser historikken for rollen hva som ble endret og når
      Og historikken viser at endringen kom fra synkroniseringen, ikke fra en administrator

    @openquestion
    Scenario: Synkronisering som ikke lykkes endrer ikke rolletabellen
      Gitt synkroniseringen ikke kan gjennomføres
      Når feilen oppstår
      Så beholder rolletabellen forrige kjente tilstand
      # ÅPNE SPØRSMÅL: Er dette riktig oppførsel ved feil, og hvem skal varsles — kun drift,
      # eller også brukeradministrator som ser rolletabellen?

# ÅPNE SPØRSMÅL:
# - Miljø: gjelder rolletabellen per miljø, slik at synkroniseringen kjører uavhengig i hvert miljø?
#   Spørsmålet ble ikke besvart da trigger ble avklart til "kontinuerlig ved endring". Naboflater
#   (vise_roller, vise_tilganger) behandler miljø som et eget felt per tildeling, så det er sannsynlig
#   at rolletabellen også er miljøspesifikk — men det må bekreftes.
# - Hva betyr "utgått" konkret i rolletabellen — et eget statusfelt, eller fravær av kobling til
#   applikasjonen? Henger sammen med hvordan utgåtte roller skal vises i BRU-PER-GRU-008 (vise_roller).
# - Akseptabel forsinkelse: hvor lang tid kan det gå fra namespacet endres til rolletabellen er
#   oppdatert, før det regnes som en feil?
# - Er historikken for synkroniserte endringer synlig for brukeradministrator, eller kun for drift?
#   Henger sammen med BRU-PER-HIS-001/002/003.
# - Gjelder det samme mønsteret for andre namespaces og applikasjoner (f.eks. andre frontender), eller
#   er dette kravet spesifikt for fs-admin? Hvis mønsteret er generelt, hører det kanskje i 08 Teknisk.
