# language: no

@ORG-ADM-VED-001 @must
Egenskap: Vedlikeholde organisasjon
  Som en systemadministrator
  ønsker jeg å endre informasjon om en eksisterende organisasjon
  slik at dataene holdes oppdatert og korrekte.

  Regel: Navneendring registreres i historikk

    Scenario: Bruker spørres om navneendring skal inn i historikk
      Gitt at jeg endrer navn på en organisasjon
      Når jeg lagrer det nye navnet
      Så skal systemet spørre om det gamle navnet skal registreres i navnehistorikken

    Scenario: Gammelt navn lagres i historikk ved bekreftelse
      Gitt at jeg endrer navn på en organisasjon
      Når jeg bekrefter at det gamle navnet skal registreres i historikken
      Så skal det gamle navnet lagres med dato for når det var gyldig
      Og søk på det gamle navnet skal fortsatt gi treff

    Scenario: Gammelt navn kastes ved avslag
      Gitt at jeg endrer navn på en organisasjon
      Når jeg velger at det gamle navnet ikke skal registreres i historikken
      Så skal kun det nye navnet lagres

  Regel: PIC-nummer valideres mot Europakommisjonens API

    Scenario: Nytt PIC-nummer slås opp mot Europakommisjonens API
      Når jeg legger til eller endrer PIC-nummer på en organisasjon
      Så skal systemet gjøre oppslag mot Europakommisjonens API
      Og vise informasjonen som returneres fra API-et

    Scenario: Ugyldig PIC-nummer gir advarsel
      Når jeg oppgir et PIC-nummer som ikke finnes i Europakommisjonens API
      Så skal jeg se en advarsel om at PIC-nummeret ikke ble funnet
      Og kunne velge å lagre det likevel

  Regel: Erasmuskode har begrenset gyldighetsperiode

    @could
    Scenario: Erasmuskode registreres med gyldighetsperiode
      Når jeg registrerer eller endrer en Erasmuskode
      Så skal jeg kunne angi fra- og til-dato for koden
      Og koden er gyldig i inntil 4 år

    @could
    Scenario: Utløpt Erasmuskode markeres som historisk
      Gitt at en Erasmuskodes gyldighetsperiode er utløpt
      Så skal koden markeres som historisk
      Og en advarsel vises hvis koden fortsatt er satt som aktiv

    @could
    Scenario: Historikk over Erasmuskodeendringer er tilgjengelig
      Gitt at en organisasjon har hatt flere Erasmuskoder over tid
      Så skal endringshistorikken for Erasmuskoder være tilgjengelig
      Og vise hvilken kode som var aktiv i hvilken periode

  Regel: Land som forlater Erasmus-avtalen håndteres korrekt

    @could
    Scenario: Erasmuskode deaktiveres for land utenfor avtalen
      Gitt at et land har forlatt Erasmus-avtalen
      Når Erasmuskoden settes til inaktiv med sluttdato
      Så skal koden ikke lenger fremstå som aktiv
      Og koden skal vises med status "historisk" med dato for deaktivering

    # ÅPENT SPØRSMÅL: Har Europakommisjonen et API vi kan lytte på for å
    # automatisk oppdage når land forlater eller gjenopptar Erasmus-avtalen?
    # Eksempel: USA var en periode utenfor Erasmus, men koden lå som aktiv i systemet
    # — dette ga et feilaktig bilde. Skal dette løses manuelt eller automatisk?

  Regel: URL-en til organisasjonen bør være tilgjengelig

    @could @planned
    Scenario: Ugyldig URL markeres med advarsel
      Gitt at en organisasjon har en registrert URL
      Og URL-en ikke svarer
      Så skal URL-feltet vises med en advarsel om at adressen ikke er tilgjengelig

    @could @planned
    Scenario: Gyldig URL vises uten advarsel
      Gitt at en organisasjon har en registrert URL
      Og URL-en svarer
      Så skal URL-feltet vises uten advarsel

# ÅPNE SPØRSMÅL:
# - Har Europakommisjonen et API for å lytte på endringer i PIC-nummer og Erasmuskoder?
# - Skal dato fra-til for Erasmuskode-gyldighet settes manuelt eller hentes fra HEI-registeret?
# - Hvem varsles når en Erasmuskode nærmer seg utløp?
# - URL-validering (nice to have): Skal sjekk skje ved lagring, periodisk, eller begge deler?