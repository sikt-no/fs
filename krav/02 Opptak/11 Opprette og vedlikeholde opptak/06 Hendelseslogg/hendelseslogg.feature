# language: no
@OPT-OVO-LOG-001 @should @draft
Egenskap: Hendelseslogg for opptak
  Som opptaksforvalter ved forvaltende organisasjon
  ønsker jeg en logg over hvem som har gjort hvilke endringer på opptaket og når
  slik at jeg kan følge opp og etterprøve endringer.

  # Bygger på en generell revisjonsmekanisme som gjelder på tvers av FS.
  # Opptaket definerer hva som skal logges, mekanismen definerer hvordan.
  # AVKLART 2026-10-09: Hvem som har gjort en endring, vises først og fremst som rolle og organisasjon.
  # Hvilken ansatt som gjorde endringen, lagres, men vises bare for noen få.

  Bakgrunn:
    Gitt at opptaket "Samordna opptak 2027" er opprettet
    Og at opptaksforvalter ved forvaltende organisasjon er innlogget

  Regel: Hver hendelse har et fast minimumsinnhold

    Scenario: Minimumsinnhold i en hendelse
      Når opptaksforvalter endrer ordinær søknadsfrist for opptaket
      Så logges en hendelse med disse opplysningene
        | Opplysning                                         |
        | Rollen til den som gjorde endringen                |
        | Organisasjonen den som gjorde endringen, tilhører  |
        | Ansatt som gjorde endringen                        |
        | Tidspunkt                                          |
        | Handling                                           |
        | Opptakskode                                        |
        | Entiteten endringen gjelder, med ID                |
        | Feltet som ble endret                              |
        | Verdien før endringen                              |
        | Verdien etter endringen                            |

    Scenario: Hendelse som legger til en entitet
      Når opptaksforvalter legger til runden "Suppleringsrunde" i opptaket
      Så logges en hendelse uten verdi før endringen
      Og hendelsen har verdiene runden ble lagt til med

    Scenario: Hendelse som fjerner en entitet
      Når opptaksforvalter sletter runden "Suppleringsrunde"
      Så logges en hendelse uten verdi etter endringen
      Og hendelsen har verdiene runden hadde før den ble slettet

  Regel: Endringer på opptaket og det som hører til opptaket logges

    # Hendelsene om runder, antall tilbud som skal gis, plassflyt og plasstildeling er lagt til 2026-10-09.
    # Antall tilbud som skal gis kan endres av både lærestedet og forvaltende organisasjon,
    # og siste lagrede tall gjelder (14 Plasstildeling/01 Runder/legge_til_runde.feature).
    Scenariomal: Hendelser som logges
      Når opptaksforvalter <handling>
      Så logges en hendelse for <entitet>
      Og hendelsen har minimumsinnholdet for en hendelse

      Eksempler: Innstillinger på opptaket
        | handling                                              | entitet                   |
        | endrer opptakstype                                    | opptaket                  |
        | endrer regelverkssamlingen                            | opptaket                  |
        | endrer standard poenglikhetsregel                     | opptaket                  |
        | endrer tak for antall tilbud per tildelingsrunde      | opptaket                  |
        | endrer maks antall søknadsalternativer                | opptaket                  |
        | endrer innstillingen for tidlig opptak                | opptaket                  |
        | endrer innstillingen for ledige studieplasser         | opptaket                  |

      Eksempler: Frister
        | handling                                              | entitet                   |
        | endrer ordinær søknadsfrist                           | opptaket                  |
        | endrer en dokumentasjonsfrist                         | dokumentasjonsfristen     |
        | endrer omprioriteringsfrist                           | opptaket                  |
        | endrer dato for når søker kan forvente svar           | opptaket                  |

      Eksempler: Samordning og utdanningsbakgrunn
        | handling                                              | entitet                   |
        | legger til en organisasjon som deltaker               | den deltakende organisasjonen |
        | fjerner en organisasjon som deltaker                  | den deltakende organisasjonen |
        | legger til en utdanningsbakgrunn                      | utdanningsbakgrunnen      |
        | endrer frister for en utdanningsbakgrunn              | utdanningsbakgrunnen      |

      Eksempler: Livssyklus for opptaket
        | handling                                              | entitet                   |
        | oppretter opptaket                                    | opptaket                  |
        | deaktiverer opptaket                                  | opptaket                  |

      Eksempler: Runder
        | handling                                              | entitet                   |
        | legger til en runde                                   | runden                    |
        | endrer navnet på en runde                             | runden                    |
        | endrer svarfristen på en runde                        | runden                    |
        | sletter en runde                                      | runden                    |
        | åpner en runde for ledige studieplasser               | runden                    |
        | setter perioden for å endre antall tilbud som skal gis | runden                   |

      Eksempler: Antall tilbud og plassflyt
        | handling                                              | entitet                   |
        | endrer antall tilbud som skal gis i en utdanningskvote | utdanningskvoten i runden |
        | endrer plassflyt for en utdanningskvote               | utdanningskvoten          |

      Eksempler: Plasstildeling
        | handling                                              | entitet                   |
        | starter en plasstildeling                             | plasstildelingen          |
        | publiserer en plasstildeling                          | plasstildelingen          |

  Regel: Hvem som gjorde endringen, vises som rolle og organisasjon

    Scenario: Rolle og organisasjon vises i hendelsesloggen
      Gitt at en opptaksforvalter ved "Universitetet i Bergen" har endret antall tilbud som skal gis i utdanningskvoten "Ordinær"
      Og at opptaksforvalter ved forvaltende organisasjon ikke har tilgang til å se hvilken ansatt som har gjort endringer
      Når opptaksforvalter ved forvaltende organisasjon åpner hendelsesloggen for opptaket
      Så ser opptaksforvalter at endringen ble gjort av rollen "Opptaksforvalter" ved "Universitetet i Bergen"
      Men opptaksforvalter ser ikke hvilken ansatt som gjorde endringen

    @openquestion
    Scenario: Innsyn i hvilken ansatt som gjorde endringen
      # ÅPNE SPØRSMÅL:
      # - Hvem skal ha innsyn i hvilken ansatt som har gjort hva? Hvilken rolle eller tilgang gir det?
      Gitt at brukeren har tilgang til å se hvilken ansatt som har gjort endringer i opptaket
      Når brukeren åpner hendelsesloggen for opptaket
      Så ser brukeren hvilken ansatt som gjorde hver endring

  Regel: Opptaksforvalter kan se hendelsesloggen for opptaket

    Scenario: Se hendelseslogg
      Når opptaksforvalter åpner hendelsesloggen for opptaket
      Så ser opptaksforvalter en kronologisk liste over alle hendelser i opptaket
      Og hver hendelse viser handling, entitet, felt, verdien før og etter, rolle, organisasjon og tidspunkt

# ÅPNE SPØRSMÅL:
# - Hvem andre har behov for å se hendelsesloggen: opptaksforvalter ved deltakende organisasjon
#   (for egne utdanningstilbud), saksbehandler, support og drift, revisjon eller klagebehandling?
# - Skal loggen være uforanderlig, slik at ingen kan endre eller slette en hendelse?
# - Hvor lenge skal hendelsene oppbevares?
# - Hva står som rolle og organisasjon når systemet eller en jobb gjør endringen?
# - Skal loggen kunne filtreres (for eksempel på entitet, rolle eller organisasjon) og eksporteres?
