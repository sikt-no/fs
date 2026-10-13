# language: no

@FOR-ADM-UTD-001
Egenskap: Opprette utdanning
Som administrator ved lærested som tilbyr utdanning i Norge trenger jeg å opprette og tilgjengeliggjøre utdanning med informasjon som gjør at både vi og andre aktører i utdannings-Norge vet at vi tilbyr utdanning. 
Både vi og andre aktører i det offentlige og private, trenger å vite om utdanningen er akkreditert og aktiv, eller historisk. 
Søkere og studenter må vite at utdanning finnes og om den passer for dem der de er nå.

@versjon1
  Scenariomal: Administrator oppretter ny utdanning ved FS-lærested som er selvakkreditterende
    Gitt at lærested er selvakkrediterende
    Gitt at lærested har FS som studieadministrativt system
    Gitt at utdanningstype er studieprogram
    Når administrator registrerer "<studieprogram>" med "trigger"
    Så lagres "<studieprogram>" i utdanningsregisteret
    Så tildeles "<studieprogram>" én entydig ID fra utdanningsregisteret
    
    Eksempler:
    |studieprogram                         |trigger|
    |studieprogram HFB-ANT Antikkens kultur|NN-trigger|

@versjon1    
  Scenariomal: Utdanning med entydig ID tilgjengeliggjøres
    Gitt at lærested er selvakkrediterende
    Gitt at lærested har FS som studieadministrativt system
    Gitt at utdanningstype er studieprogram
    Når "<studieprogram>" er tildelt entydig ID og er lagret i utdanningsregisteret
    Så blir registrerte data om "<studieprogram>" åpent tilgjengelig for "<kjente tredjeparter>"

    Eksempler: 
    |studieprogram|kjente tredjeparter|
    |studieprogram HFB-ANT Antikkens kultur|Lånekassen|
    |studieprogram HFB-ANT Antikkens kultur|Opptak|

@versjon1
  Scenariomal: Administrator oppretter nytt utdanningstilbud ved FS-lærested
    Gitt at lærested er selvakkrediterende
    Gitt at lærested har FS som studieadministrativt system
    Gitt at studieprogram er opprettet og tildelt entydig ID
    Når administrator registrerer "<utdanningstilbud>" knyttet til "<studieprogram>"
    Så lagres "<utdanningstilbud>" i utdanningsregisteret
    Så tildeles "<utdanningstilbud>" én entydig ID fra utdanningsregisteret
    
    Eksempler:
    |studieprogram             |utdanningstilbud|
    |HFB-ANT Antikkens kultur  | HFB-ANT Antikkens kultur 2025 HØST|

@versjon1    
  Scenariomal: Utdanningstilbud med entydig ID tilgjengeliggjøres
    Gitt at lærested er selvakkrediterende
    Gitt at lærested har FS som studieadministrativt system
    Gitt at studieprogram er opprettet og tildelt entydig ID
    Når "<utdanningstilbud>" er tildelt entydig ID og er lagret i utdanningsregisteret
    Så blir registrerte data om "<utdanningstilbud>" åpent tilgjengelig for "<kjente tredjeparter>"

    Eksempler: 
    |utdanningstilbud|kjente tredjeparter|
    |studieprogram HFB-ANT Antikkens kultur HØST 2025|Lånekassen|
    |studieprogram HFB-ANT Antikkens kultur HØST 2025|Opptak|

    

@versjon1
  Scenariomal: Grunnscenario - Administrator oppretter ny utdanning ved FS-lærested som er selvakkrediterende 
    Gitt at lærested er selvakkreditterende
    Gitt at lærested har FS som studieadministrativt system
    Når administrator registrerer "<utdanning>"
    Så lagres "<utdanning>" i utdanningsregisteret
    Så tildeles "<utdanning>" én entydig ID fra utdanningsregisteret

    Eksempler:
    |utdanning|
    |studieprogram HFB-ANT Antikkens kultur|

@versjon1
  Scenario: Opprette utdanningstype: emne og kurs
    Gitt at administrator vil opprette emne eller kurs
    Når administrator registrerer ny utdanning av type emne eller kurs
    Så lagres utdanningen i utdanningsregisteret

  Scenariomal: Administrator oppretter ny utdanning ved FS-lærested som er områdeakkreditert
    Gitt at lærested er områdeakkreditert
    Gitt at lærested har FS som studieadministrativt system
    Når administrator registrerer "<utdanning>" innenfor "<fagområde>" de er akkredittert for
    Så lagres "<utdanning>" i utdanningsregisteret
    Så tildeles "<utdanning>" én entydig ID fra utdanningsregisteret
    
    Eksempler:
    |utdanning                             |fagområde|
    |studieprogram HFB-ANT Antikkens kultur|antikkene studier|

  Scenariomal: Administrator oppretter ny utdanning i annet SIS enn FS som kan integrere
    Gitt at lærested er områdeakkreditert
    Gitt at lærested IKKE har FS som studieadministrativt system
    Når administrator registrerer "<utdanning>" innenfor "<fagområde>" de er akkredittert for
    Så lagres "<utdanning>" i utdanningsregisteret
    Så tildeles "<utdanning>" én entydig ID fra utdanningsregisteret
    
    Eksempler:
    |utdanning                             |fagområde|
    |studieprogram HFB-ANT Antikkens kultur|antikkene studier|

  Scenariomal: Administrator oppretter ny utdanning i annet SIS enn FS som IKKE kan integrere (hente fra NOKUT???)
    Gitt at lærested IKKE har FS som studieadministrativt system
    Når administrator registrerer "<utdanning>" innenfor "<fagområde>" de er akkredittert for
    Så lagres "<utdanning>" i utdanningsregisteret
    Så tildeles "<utdanning>" én entydig ID fra utdanningsregisteret
    
    Eksempler:
    |utdanning                             |fagområde|
    |studieprogram HFB-ANT Antikkens kultur|antikkene studier|

# @skip - egen feature for akkreditteringsinfo? høyere utdanning og selvakkreditering først?
@versjon1
  Scenariomal: Administrator oppretter ny utdanning ved FS-lærested som er områdeakkreditert
    Gitt at lærested IKKE er områdeakkreditert
    Gitt at NOKUT sier ja
    Gitt at lærested har FS som studieadministrativt system
    Når administrator registrerer "<utdanning>" innenfor "<fagområde>" de er akkredittert for i FS
    Så tildeles "<utdanning>" én entydig ID 
    Så lagres "<utdanning>" i utdanningsregisteret 
    
    Eksempler:
    |utdanning                             |fagområde|
    |studieprogram HFB-ANT Antikkens kultur|antikkene studier|

@versjon1
  Scenariomal: Utdanning med entydig ID tilgjengeliggjøres
    Gitt at "<utdanning>" er lagret med entydig ID
    Gitt at "<utdanning>" er tilknyttet minst ett "<lærested>" 
    Når administrator setter utdanning til aktiv
    Så blir utdanning tilgjengelig

    Eksempler: 
    |utdanning|lærested|
    |studieprogram HFB-ANT Antikkens kultur|Høgskulen på Vestlandet|
