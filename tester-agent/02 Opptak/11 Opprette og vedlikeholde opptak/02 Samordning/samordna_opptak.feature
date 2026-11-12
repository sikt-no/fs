# language: no
# Generert av fs-testcaser-cdp 2026-10-27
# Krav: krav/02 Opptak/11 Opprette og vedlikeholde opptak/02 Samordning/samordna_opptak.feature @ 0f010d4 (blob 9968d5973c3b7be7ad719edefccd45e29f22a969)
#
# «Åpne opptaket «<nøkkel>»» betyr: gå til «Opptak», skriv navnet på opptaket (fra miljøfila) i «Opptaksnavn», og velg opptaket i lista.
# «Adressen til opptaket «<nøkkel>»» er URL-en til siden til opptaket. «opptak-forvalter-forvaltende» kan finne den ved å åpne opptaket.
#
# «{ORG:<nøkkel>}», «{ORGNAVN:<nøkkel>}» og «{ORGKODE:<nøkkel>}» er forkortelsen, navnet og organisasjonskoden til organisasjonen
# testbrukeren eller testdataene <nøkkel> har, slått opp i miljøfila.
# Den deltakende organisasjonen er organisasjonen til «opptak-forvalter-deltakende», og organisasjonen som ikke deltar, er organisasjonen
# til «opptak-forvalter-ikke-deltakende», i stedet for eksemplene «Universitetet i Oslo» og «NTNU» i kravet.
@TST-OPT-OVO-SAM-001 @depends-on-OPT-OVO-SAM-001
Egenskap: Samordna opptak
  Opptaksforvalteren ved forvaltende organisasjon inviterer læresteder til et samordna opptak, og bare de som
  deltar, kan legge til utdanningstilbud og se opptaket.

  Regel: Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak

    @endrer-data
    Scenario: Legge til lærested i samordna opptak
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-uten-utdanningstilbud» har ingen deltakere, og redigering av utdanningstilbud er åpen i dag
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg skriver «{ORGNAVN:opptak-forvalter-deltakende}» i «Søk etter navn»
      Og jeg markerer «{ORGNAVN:opptak-forvalter-deltakende}»
      Og jeg velger «Legg til 1 organisasjon»
      Og jeg velger «Lagre»
      Og jeg bytter testbruker til «opptak-forvalter-deltakende»
      Og jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Gå til utdanningstilbud»
      Og jeg velger «Handlinger»
      Så ser jeg «Legg til utdanningstilbud»
      # Setter tilbake:
      Og jeg bytter testbruker til «opptak-forvalter-forvaltende»
      Og jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud», og velger «Endre innstillinger for opptaket»
      Og jeg velger «Fjern {ORG:opptak-forvalter-deltakende}» under «Samordnede organisasjoner», og velger «Lagre»
      Og jeg åpner opptaket igjen, og under «Samordnede organisasjoner» står ingen organisasjoner

    # Teknikk: ekvivalensklasser (søket i «Inviter» treffer navn, forkortelse og kode, InviterOrganisasjonerModal.tsx:65-80)
    @utledet
    Scenariomal: Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak: søk på <søkes på>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg skriver «<søketekst>» i «Søk etter navn»
      Så står «{ORGNAVN:opptak-forvalter-deltakende}» i lista
      Og jeg velger «Lukk», og så «Avbryt»

      Eksempler:
        | søkes på     | søketekst                                    |
        | navn         | {ORGNAVN:opptak-forvalter-deltakende}            |
        | forkortelse  | {ORG:opptak-forvalter-deltakende}                |
        | kode         | {ORGKODE:opptak-forvalter-deltakende}            |

    # Teknikk: ekvivalensklasser (en organisasjon som allerede er lagt til, vises ikke i «Inviter»)
    @utledet
    Scenario: Opptaksforvalter ved forvaltende organisasjon kan legge til organisasjoner i et samordna opptak: organisasjon som allerede er lagt til
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og {ORG:opptak-forvalter-deltakende} er deltaker i opptaket «opptak-samordna-med-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-med-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg skriver «{ORG:opptak-forvalter-deltakende}» i «Søk etter navn»
      Så står «{ORGNAVN:opptak-forvalter-deltakende}» ikke i lista
      Og jeg ser «1 organisasjon er allerede lagt til» [Sjekk begrep: tallet er antallet deltakere i opptaket]
      Og jeg velger «Lukk», og så «Avbryt»

  Regel: Kun organisasjoner som deltar i opptaket kan legge til utdanningstilbud

    Scenario: Organisasjon som ikke deltar kan ikke legge til utdanningstilbud
      Gitt jeg er logget inn som «opptak-forvalter-ikke-deltakende»
      Og {ORG:opptak-forvalter-ikke-deltakende} er ikke deltaker i opptaket «opptak-samordna-med-utdanningstilbud»
      Når jeg går til adressen til opptaket «opptak-samordna-med-utdanningstilbud», med «/utdanningstilbud» bak
      Så ser jeg ikke «Handlinger»
      Og jeg ser ikke «Legg til utdanningstilbud»

  # Åpent spørsmål: skal regelen ha @ref-OPT-OPT-UTD-001? Testes som den står.
  Regel: Organisasjoner som ikke deltar, kan ikke se opptaket

    # Avhenger av flagget «opptak-filter-organisasjon» (se miljøfila).
    Scenario: Organisasjon som ikke deltar, ser ikke opptaket
      Gitt jeg er logget inn som «opptak-forvalter-ikke-deltakende»
      Og {ORG:opptak-forvalter-ikke-deltakende} er ikke deltaker i opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg har åpnet «Opptak»
      Når jeg skriver navnet på opptaket «opptak-samordna-uten-utdanningstilbud» i «Opptaksnavn»
      Så ser jeg «Ingen opptak funnet»

    Scenario: Organisasjon som ikke deltar, kan ikke åpne opptaket
      Gitt jeg er logget inn som «opptak-forvalter-ikke-deltakende»
      Og {ORG:opptak-forvalter-ikke-deltakende} er ikke deltaker i opptaket «opptak-samordna-uten-utdanningstilbud»
      Når jeg går til adressen til opptaket «opptak-samordna-uten-utdanningstilbud»
      Så ser jeg ikke navnet på opptaket, «Oppsummert» eller fristene til opptaket [Sjekk begrep: hva siden viser i stedet, for eksempel «Siden finnes ikke»]

  # Åpent spørsmål: skal regelen ha @ref-OPT-OPT-UTD-026? Testes som den står.
  Regel: En deltakende organisasjon kan ikke fjernes fra opptaket så lenge den har utdanningstilbud i det

    @endrer-data
    Scenario: Fjerne en deltakende organisasjon som har utdanningstilbud i opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og {ORG:opptak-forvalter-deltakende} er deltaker i opptaket «opptak-samordna-med-utdanningstilbud», med minst ett utdanningstilbud
      Når jeg åpner opptaket «opptak-samordna-med-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Fjern {ORG:opptak-forvalter-deltakende}» under «Samordnede organisasjoner»
      Og jeg velger «Lagre»
      Så ser jeg «Utdanningstilbudene til {ORGNAVN:opptak-forvalter-deltakende} må fjernes først»
      Når jeg åpner opptaket igjen
      Så står «{ORGNAVN:opptak-forvalter-deltakende}» under «Samordnede organisasjoner»
      # Setter tilbake (bare hvis organisasjonen likevel ble fjernet):
      Og står {ORG:opptak-forvalter-deltakende} ikke der, velger jeg «Endre innstillinger for opptaket», legger til {ORG:opptak-forvalter-deltakende} med «Inviter organisasjoner til samordningen», og velger «Lagre»

    @endrer-data
    Scenario: Fjerne en deltakende organisasjon uten utdanningstilbud i opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-uten-utdanningstilbud» har ingen deltakere
      Og jeg har åpnet opptaket «opptak-samordna-uten-utdanningstilbud», valgt «Endre innstillinger for opptaket», lagt til «{ORGNAVN:opptak-forvalter-deltakende}» med «Inviter organisasjoner til samordningen», og valgt «Lagre»
      Når jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Og jeg velger «Fjern {ORG:opptak-forvalter-deltakende}» under «Samordnede organisasjoner»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen
      Så står «{ORGNAVN:opptak-forvalter-deltakende}» ikke under «Samordnede organisasjoner»

  # Åpent spørsmål: er «forvaltende organisasjon» utvetydig nok for tilgangsstyringen? Testes som den står.
  Regel: Det er kun opptaksforvalter ved forvaltende organisasjon som kan endre innstillinger i opptaket

    @endrer-data
    Scenario: Opptaksforvalter ved forvaltende organisasjon kan endre innstillinger
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg noterer verdiene i «Poenglikhetsregel», «Regelverksamling knyttet til opptaket» og «Ordinær søknadsfrist»
      Og jeg velger «Alder, eldste først» i «Poenglikhetsregel»
      Og jeg velger regelverkssamlingen «regelverkssamling-samordna-annen» i «Regelverksamling knyttet til opptaket»
      Og jeg endrer «Ordinær søknadsfrist» til én dag senere enn verdien jeg noterte
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen, og velger «Endre innstillinger for opptaket»
      Så står «Alder, eldste først» i «Poenglikhetsregel»
      Og regelverkssamlingen «regelverkssamling-samordna-annen» står i «Regelverksamling knyttet til opptaket»
      Og «Ordinær søknadsfrist» er én dag senere enn verdien jeg noterte
      # Setter tilbake:
      Og jeg setter «Poenglikhetsregel», «Regelverksamling knyttet til opptaket» og «Ordinær søknadsfrist» tilbake til verdiene jeg noterte, og velger «Lagre»

    Scenario: Opptaksforvalter ved deltakende organisasjon kan se, men ikke endre innstillinger
      Gitt jeg er logget inn som «opptak-forvalter-deltakende»
      Og {ORG:opptak-forvalter-deltakende} er deltaker i opptaket «opptak-samordna-med-utdanningstilbud»
      Når jeg åpner opptaket «opptak-samordna-med-utdanningstilbud»
      Og jeg velger «Vis alle frister»
      Så ser jeg alle fristene som er satt på opptaket
      Og jeg ser opptakstypen, regelverksamlingen, poenglikhetsregelen, antall søknadsalternativer, godkjente utdanningsbakgrunner og valgene for opptaket [Sjekk begrep: hvor innstillingene står på siden]
      Men jeg ser ikke «Endre innstillinger for opptaket»

  # AVKLART 2026-10-12 i kravet: det er nok at brukergrensesnittet ikke gjør det mulig.
  Regel: I et lokalt opptak kan ikke andre organisasjoner legges til

    Scenario: Lokalt opptak tillater ikke andre organisasjoner
      Gitt jeg er logget inn som «opptak-forvalter-lokalt»
      Når jeg åpner opptaket «opptak-lokalt»
      Og jeg velger «Endre innstillinger for opptaket»
      Så ser jeg ikke «Samordning»
      Og jeg ser ikke «Inviter organisasjoner til samordningen»
      Og jeg velger «Avbryt»

  Regel: Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere

    @endrer-data
    Scenario: Legge til organisasjon som finnes i utdanningsregisteret
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og opptaket «opptak-samordna-uten-utdanningstilbud» har ingen deltakere
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg skriver «{ORGNAVN:organisasjon-som-inviteres}» i «Søk etter navn»
      Og jeg markerer «{ORGNAVN:organisasjon-som-inviteres}»
      Og jeg velger «Legg til 1 organisasjon»
      Og jeg velger «Lagre»
      Og jeg åpner opptaket igjen
      Så står «{ORGNAVN:organisasjon-som-inviteres}» under «Samordnede organisasjoner»
      # Setter tilbake:
      Og jeg velger «Endre innstillinger for opptaket», velger «Fjern {ORG:organisasjon-som-inviteres}» under «Samordnede organisasjoner», og velger «Lagre»

    Scenario: Organisasjon som ikke finnes i utdanningsregisteret kan ikke legges til
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Og organisasjonen «Høgskolen i Atlantis» finnes ikke i utdanningsregisteret
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg skriver «Høgskolen i Atlantis» i «Søk etter navn»
      Så ser jeg «Ingen treff»
      Og knappen heter «Legg til 0 organisasjoner»
      Og jeg velger «Lukk», og så «Avbryt»

  Regel: Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket

    # «Type lærested» har valgene «Fagskole», «Høyskole», «Universitet» og «Vitenskapelig høgskole».
    # Kravet sier «universitet og høyskole», og vitenskapelige høgskoler er tatt med som høyskoler (se oppsummeringen).
    Scenario: Filtrere på universiteter og høyskoler
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg velger «Universitet», «Høyskole» og «Vitenskapelig høgskole» i «Type lærested»
      Så har hver rad i lista «Universitet», «Høyskole» eller «Vitenskapelig høgskole» i «Type»
      Og ingen rad har «Fagskole» i «Type»
      Og jeg velger «Lukk», og så «Avbryt»

    Scenario: Filtrere på fagskoler
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg velger «Fagskole» i «Type lærested»
      Så har hver rad i lista «Fagskole» i «Type»
      Og tallene i «Viser N av M organisasjoner» er like
      Og jeg velger «Lukk», og så «Avbryt»

    # Teknikk: ekvivalensklasser (ingen type valgt, og alle typer valgt)
    @utledet
    Scenariomal: Opptaksforvalter kan begrense hvilke lærestedstyper som får delta i opptaket: <valg>
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Og jeg velger «Inviter organisasjoner til samordningen» under «Samordning»
      Og jeg noterer tallene i «Viser N av M organisasjoner» uten noe valgt i «Type lærested»
      Og jeg velger <typer> i «Type lærested»
      Så viser «Viser N av M organisasjoner» de samme tallene som jeg noterte
      Og lista har både rader med «Fagskole» og rader med «Universitet» i «Type»
      Og jeg velger «Lukk», og så «Avbryt»

      Eksempler:
        | valg                 | typer                                                                |
        | ingen type valgt     | ingenting                                                            |
        | alle typene valgt    | «Fagskole», «Høyskole», «Universitet» og «Vitenskapelig høgskole»    |

  # Åpent spørsmål: skal regelen ha @ref-OPT-BEH-BEH-011? Testes som den står.
  Regel: Opptaksforvalter ved forvaltende organisasjon kan se og navigere til saksbehandlertildelingen i samordna opptak

    # Lenken står under «Samordning» i «Endre innstillinger for opptaket» (Samordning.tsx:50-60 i fs-admin), ikke på siden til opptaket.
    Scenario: Se og navigere til saksbehandlertildelingen for opptaket
      Gitt jeg er logget inn som «opptak-forvalter-forvaltende»
      Når jeg åpner opptaket «opptak-samordna-uten-utdanningstilbud»
      Og jeg velger «Endre innstillinger for opptaket»
      Så ser jeg «Saksbehandlertildelingsregler» under «Samordning»
      Når jeg velger «Saksbehandlertildelingsregler»
      Så åpnes siden «Behandlertildelingsregler»

    Scenario: Saksbehandlertildeling er ikke relevant for lokale opptak
      Gitt jeg er logget inn som «opptak-forvalter-lokalt»
      Når jeg åpner opptaket «opptak-lokalt»
      Så ser jeg ikke «Saksbehandlertildelingsregler»
      Når jeg velger «Endre innstillinger for opptaket»
      Så ser jeg ikke «Saksbehandlertildelingsregler»
      Og jeg velger «Avbryt»
