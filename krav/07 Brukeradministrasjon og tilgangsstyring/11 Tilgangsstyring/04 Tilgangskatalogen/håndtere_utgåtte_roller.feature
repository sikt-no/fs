# language: no
# GitHub: #563
# Implementert i fs-plattform !6135 (utkast, ikke merget), bortsett fra hvordan en rolle blir utgått.
@BRU-TIL-KAT-008 @must @draft
Egenskap: Håndtere utgåtte roller i rollekatalogen
  Som forvalter av rollekatalogen
  ønsker jeg at en utgått rolle ikke kan få nye implikasjoner
  slik at en rolle som er på vei ut av katalogen, verken får ny rekkevidde eller blir noe andre roller innebærer.

  En utgått rolle finnes fortsatt i katalogen. Den slettes ikke, fordi tildelinger, delegeringstak
  og nekt kan nevne den. Det som er bestemt, er at den ikke kan inngå i nye implikasjoner, verken
  som rollen implikasjonen går ut fra eller som rollen den innebærer. Implikasjoner og tildelinger
  rollen har fra før, berøres ikke av denne regelen, og implikasjoner til og fra rollen kan
  fortsatt fjernes. Når rollen ble utgått, er synlig.

  BRU-TIL-KAT-001 beskriver at en tilgang kan tas ut av bruk, og BRU-PER-GRU-010 at synkroniseringen
  fra navnerommet "frontend/fs-admin" markerer en rolle som utgått. Om det er samme tilstand som i
  denne egenskapen, er ikke avklart.

  # ÅPNE SPØRSMÅL:
  # - Hvordan blir en rolle utgått? Er det en egen operasjon, og hvilken rett kreves i så fall?
  # - Kan det angres at en rolle er utgått?
  # - Er utgått i denne egenskapen det samme som «tatt ut av bruk» i BRU-TIL-KAT-001 og «markert
  #   som utgått» i BRU-PER-GRU-010?

  Bakgrunn:
    Gitt forvalteren er innlogget i løsningen
    Og forvalteren har full forvaltningsrett for rollekatalogen i eierorganisasjonene til navnerommene rollene ligger i

  Regel: En utgått rolle får ingen nye implikasjoner

    Scenario: En utgått rolle kan ikke innebære en ny rolle
      Gitt rollen "OPPTAKSLEDER" er utgått
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så avvises forespørselen
      Og det fremgår at rollen "OPPTAKSLEDER" er utgått

    Scenario: En rolle kan ikke få en ny implikasjon til en utgått rolle
      Gitt rollen "OPPTAK_SKRIV" er utgått
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så avvises forespørselen
      Og det fremgår at rollen "OPPTAK_SKRIV" er utgått

    Scenario: En implikasjon til en utgått rolle stopper hele forespørselen
      Gitt rollen "OPPTAK_SKRIV" er utgått
      Når forvalteren i én forespørsel legger til at "OPPTAKSLEDER" innebærer "OPPTAK_LES" og at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så avvises forespørselen
      Og "OPPTAKSLEDER" innebærer ikke "OPPTAK_LES"

  Regel: Det rollen har fra før, berøres ikke av at den er utgått

    Scenario: Implikasjoner fra før gjelder videre
      Gitt "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Når rollen "OPPTAKSLEDER" blir utgått
      Så innebærer "OPPTAKSLEDER" fortsatt "OPPTAK_SKRIV"

    Scenario: En implikasjon fra en utgått rolle kan fjernes
      Gitt "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Og rollen "OPPTAKSLEDER" er utgått
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så innebærer "OPPTAKSLEDER" ikke lenger "OPPTAK_SKRIV"

    Scenario: En implikasjon til en utgått rolle kan fjernes
      Gitt "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Og rollen "OPPTAK_SKRIV" er utgått
      Når forvalteren fjerner implikasjonen fra "OPPTAKSLEDER" til "OPPTAK_SKRIV"
      Så innebærer "OPPTAKSLEDER" ikke lenger "OPPTAK_SKRIV"

    @openquestion
    Scenario: En avvist implikasjon endrer ikke tildelingene av den utgåtte rollen
      # ÅPNE SPØRSMÅL:
      # - Hva skal ellers skje med tildelinger av en rolle som er utgått? Forslaget i #563 er at
      #   ingenting skjer med dem («frys framover»), men det er ikke bestemt.
      Gitt en personbruker har fått tildelt rollen "OPPTAKSLEDER"
      Og rollen "OPPTAKSLEDER" er utgått
      Når forvalteren legger til at "OPPTAKSLEDER" innebærer "OPPTAK_SKRIV"
      Så avvises forespørselen
      Og tildelingen av "OPPTAKSLEDER" til personbrukeren er uendret

  Regel: Det er synlig når en rolle ble utgått

    Scenario: Se når en rolle ble utgått
      Gitt rollen "OPPTAKSLEDER" ble utgått 1. oktober 2026
      Når forvalteren ser rollen "OPPTAKSLEDER" i rollekatalogen
      Så ser forvalteren at rollen ble utgått 1. oktober 2026

    Scenario: En rolle i bruk har ikke noe utgått-tidspunkt
      Gitt rollen "OPPTAK_SKRIV" er ikke utgått
      Når forvalteren ser rollen "OPPTAK_SKRIV" i rollekatalogen
      Så har rollen ikke noe utgått-tidspunkt
