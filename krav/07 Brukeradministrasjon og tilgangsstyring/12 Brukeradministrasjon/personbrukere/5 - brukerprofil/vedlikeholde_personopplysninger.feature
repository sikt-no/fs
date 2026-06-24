# language: no
# GitHub: #487
@BRU-PER-BRP-002 @must @draft
Egenskap: Vedlikeholde personopplysninger for personbruker
  Som brukeradministrator
  ønsker jeg å kunne oppdatere de personopplysningene FS Admin selv eier om en personbruker
  slik at brukerregisteret er korrekt og brukbart for kommunikasjon og tilgangsstyring.

  Bakgrunn:
    Gitt jeg er innlogget i løsningen
    Og jeg ser detaljsiden for en personbruker

  Regel: Endring av redigerbare felt sporbar i historikk

    Scenario: Oppdatere et redigerbart felt
      Gitt et felt på personbrukeren er redigerbart i FS Admin
      Når jeg endrer feltets verdi
      Så lagres den nye verdien
      Og endringen er sporbar i historikk

# ÅPNE SPØRSMÅL:
# - Hvilke felt eier FS Admin (redigerbare), og hvilke kommer fra Feide / autoritativt kildesystem (read-only)? Avklares sammen med IAM-integrasjonsbeslutningene.
# - Hva kan personbrukeren selv vedlikeholde (på egen profil — BRU-PER-BRP-001) vs. hva er forbeholdt brukeradministrator?
# - Hvordan håndteres synkronisering hvis et felt endres både i FS Admin og i kildesystemet? Hvilken kilde vinner ved konflikt?
# - Hvilke valideringer skal gjelde på redigerbare felt (f.eks. e-postformat, telefonformat)?
# - Hva er forholdet til eksisterende personopplysningsfeatures i `05 Opplysninger om person/` — er noen av feltene allerede dekket der?
# - Hvis FS Admin ikke eier noen redigerbare felt utover lokale notater, er det reelle scope for dette kravet veldig smalt og bør kanskje avvikles eller slås sammen med BRU-PER-GRU-002 (visning).