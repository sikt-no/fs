# language: no
# Utkast (Kjetil/Claude 06.11.2026), ikke avklart med produkteier.
@OPT-SØK-SØK-020 @must @draft @depends-on-OPT-SØK-SØK-005
Egenskap: Bli søker ved første «Legg til»
  Som en person som er innlogget i Min kompetanse
  ønsker jeg å bli søker i opptak først når jeg legger et utdanningstilbud i studiekurven
  slik at opptak bare har søkere som faktisk vil søke, med navnet og fødselsdatoen søknaden trenger.

  # Utkast skrevet etter fs-plattform !6546 og !6554 og min-kompetanse !993 (BAT-405, del 2), etter Håkon Wolds
  # review 06.11.2026: atferden der hadde ikke krav. Kravet beskriver det MR-ene gjør, og skal gjennomgås med
  # produkteier (Jøran, Karen) før noe av det kan bli @planned.
  #
  # Kilder:
  # - Jira: BAT-405, «Ny strategi for provisjonering av søkere» (beslutning 04.11.2026)
  # - fs-plattform !6546: søkeren opprettes ved første skriving, felles for fødselsnummer og eIDAS
  # - fs-plattform !6554: egenregistrert søker oppgir navn og fødselsdato
  # - fs-plattform opptak/docs/tokenkrav-subgraf.md (på branchen til !6546/!6554), «Søkeren opprettes ved første skriving»
  # - min-kompetanse !993: siden for personopplysninger ved første «Legg til» (prototype, klikkeguide for designerne)
  #
  # HK-dir (krav/_kravanalyser/hk-dir-krav-dekning.md, 07 Brukeradministrasjon og tilgangsstyring):
  # - HK-9282 Elektronisk identifikasjon (Delvis): eIDAS-innlogging gir en søker (regelen om eIDAS under).
  # - HK-9392 Sikker og brukervennlig innlogging (Delvis): utenlandsk og egenregistrert innlogging gir en søker.
  # - HK-9432 Alternativ innlogging som søker (Ikke dekket): søkeren uten norsk eID registrerer navn og fødselsdato.
  #   HK-9432 lister også kjønn, telefonnummer, e-postadresse og postadresse. Det kravet dekker ikke.
  # - HK-9433 Innhenting og informasjon om personopplysninger for ID-porten-søker (Delvis, OPP-INT-FOL-001 og
  #   OPP-PRO-PRO-002): den selvregistrerte søkeren oppgir navn og fødselsdato selv, og siden sier hvorfor vi spør og
  #   hvordan opplysningene brukes. Søkeren med eIDAS får dem fra innloggingen. Henting fra KRR ved innlogging, og
  #   lenkene om hvordan søkeren endrer opplysningene i Folkeregisteret og KRR, dekker kravet ikke (åpent spørsmål).
  #
  # Forholdet til andre krav:
  # - Innloggingen står i TIL-PÅL-PÅL-002 (ID-porten) og DEM-INN-FEI-001 (Feide). Innlogging uten fødselsnummer
  #   (egenregistrert med e-post og eIDAS) er TIL-PÅL-PÅL-006 i den åpne PR-en sikt-no/fs#894, som ikke er på main.
  # - KONFLIKT: TIL-PÅL-PÅL-006 (#894, @planned) har regelen «Første innlogging oppretter søkeren», og sier at
  #   søkeren registrerer personopplysningene ved første innlogging. Det samme sier BAT-405. Beslutningen 04.11.2026,
  #   og MR-ene, oppretter søkeren ved første «Legg til». Ett av kravene må rettes, før eller etter at #894 merges.
  # - Studiekurven står i OPT-SØK-SØK-005, og «Legg til» i Finn studier i OPT-SØK-SØK-013 (finne_studier.feature).
  # - Opplasting av dokumenter (håndtere_dokumentasjon_i_søknad.feature) oppretter også søkeren, som et
  #   sikkerhetsnett. I Min kompetanse kommer søkeren dit først etter at studiekurven har et utdanningstilbud,
  #   så det har ingen egne scenarioer her.
  # - To personer for samme menneske, når personen først blir søker uten fødselsnummer og senere logger inn med
  #   fødselsnummer, er ikke løst. Sammenslåing er sikt-no/fs#565.
  #
  # ÅPNE SPØRSMÅL:
  # - Kommer skjemaet for navn og fødselsdato ved første innlogging (BAT-405, TIL-PÅL-PÅL-006) eller ved første
  #   «Legg til» (beslutningen 04.11.2026, !993)? Kravet er skrevet for første «Legg til».
  # - Skal plasstildelingen og det automatiske grunnlaget bruke en fødselsdato søkeren har tastet inn selv? Eller
  #   skal den merkes som oppgitt av søkeren, så saksbehandleren kan kontrollere den?
  # - HK-9433: Skal kontaktopplysningene hentes fra KRR når søkeren logger inn, eller når søkeren blir søker ved
  #   første «Legg til»? Gjelder det bare søkeren med fødselsnummer, siden KRR slår opp på fødselsnummer?
  #   Kravet beskriver ingen henting fra KRR.

  Regel: Personen blir søker første gang personen legger et utdanningstilbud i studiekurven

    Scenariomal: Innlogging med <innloggingsmåte> gjør ikke personen til søker
      Gitt at personen ikke har vært søker i opptak før
      Når personen logger inn i Min kompetanse med <innloggingsmåte>
      Og personen åpner Finn studier og studiekurven
      Så er personen ikke opprettet som søker i opptak

      Eksempler:
        | innloggingsmåte                  |
        | ID-porten med fødselsnummer      |
        | Feide med fødselsnummer          |
        | eIDAS                            |
        | e-post som selvregistrert bruker |

    Scenariomal: Personen innlogget med <innloggingsmåte> blir søker ved første «Legg til»
      Gitt at personen er innlogget i Min kompetanse med <innloggingsmåte>
      Og at personen ikke er søker i opptak
      Når personen legger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Så er personen opprettet som søker i opptak
      Og ligger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Og personen har ikke blitt bedt om å oppgi noe mer

      Eksempler:
        | innloggingsmåte             |
        | ID-porten med fødselsnummer |
        | Feide med fødselsnummer     |
        | eIDAS                       |

    Scenario: Personen blir én søker når to «Legg til» skjer samtidig
      Gitt at personen er innlogget i Min kompetanse med ID-porten med fødselsnummer i to faner
      Og at personen ikke er søker i opptak
      Når personen legger ett utdanningstilbud i studiekurven i hver fane samtidig
      Så er personen opprettet som én søker i opptak
      Og ligger begge utdanningstilbudene i studiekurven

    @openquestion
    Scenario: Personen innlogget med Feide uten fødselsnummer blir ikke søker
      # ÅPNE SPØRSMÅL:
      # - Feide-brukere uten fødselsnummer (gjestebrukere, utenlandske studenter, organisasjoner som ikke deler
      #   fødselsnummeret) får ikke søker i dag (kjent mangel i tokenkrav-subgraf.md). Skal de få det, for eksempel
      #   med det samme skjemaet som den egenregistrerte søkeren, eller skal de bes logge inn med ID-porten?
      # - Hva skal personen få se? I dag gir «Legg til» en feil uten forklaring.
      Gitt at personen er innlogget i Min kompetanse med Feide uten fødselsnummer
      Når personen legger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Så er personen ikke opprettet som søker i opptak
      Og ligger ikke utdanningstilbudet "Sykepleie, høst 2027" i studiekurven

  @ref-TIL-PÅL-PÅL-002
  Regel: Navnet og fødselsdatoen til søkeren kommer fra innloggingen når innloggingen har dem
    # Med fødselsnummer kommer navnet fra innloggingen og fødselsdatoen fra fødselsnummeret.
    # Med eIDAS kommer navnet og fødselsdatoen fra eIDAS, og søkeren kjennes igjen på eIDAS-identifikatoren.
    # Har innloggingen både fødselsnummer og eIDAS-identifikator, er det fødselsnummeret som gjelder.

    Scenario: Søkeren med fødselsnummer får navnet fra innloggingen og fødselsdatoen fra fødselsnummeret
      Gitt at personen er innlogget med ID-porten med fødselsnummeret til en person født 15.03.2005
      Og at innloggingen gir navnet "Kari Nordmann"
      Når personen blir søker ved første «Legg til»
      Så er søkeren registrert med fornavn "Kari", etternavn "Nordmann" og fødselsdato 15.03.2005

    Scenario: Søkeren med eIDAS får navnet og fødselsdatoen fra eIDAS
      Gitt at personen er innlogget med eIDAS
      Og at eIDAS gir fornavn "Anna", etternavn "Schmidt" og fødselsdato 02.07.2004
      Når personen blir søker ved første «Legg til»
      Så er søkeren registrert med fornavn "Anna", etternavn "Schmidt" og fødselsdato 02.07.2004
      Og søkeren er ikke registrert med fødselsnummer

    Scenario: Søkeren med eIDAS er den samme søkeren ved neste innlogging
      Gitt at personen har blitt søker med eIDAS
      Og at personen har et utdanningstilbud i studiekurven
      Når personen logger inn med eIDAS igjen
      Så er personen den samme søkeren som før
      Og ligger utdanningstilbudet fortsatt i studiekurven

    @openquestion
    Scenario: Innloggingen har både fødselsnummer og eIDAS-identifikator
      # ÅPNE SPØRSMÅL:
      # - Ifølge Digdir kan ID-porten gi fødselsnummer ved eIDAS-innlogging når personen finnes i Folkeregisteret
      #   (åpent spørsmål i TIL-PÅL-PÅL-006, #894). !6546 lar fødselsnummeret gjelde. Er det riktig?
      Gitt at personen er innlogget med eIDAS
      Og at innloggingen også har fødselsnummer
      Når personen blir søker ved første «Legg til»
      Så er søkeren registrert med fødselsnummeret

    @openquestion
    Scenario: eIDAS-identifikatoren er en annen enn den som er lagret på søkeren
      # ÅPNE SPØRSMÅL:
      # - Landet kan gi personen en ny eIDAS-identifikator, for eksempel ved ny eID. !6546 finner personen igjen
      #   på ID-porten-innloggingen, men endrer ikke den lagrede identifikatoren, og avviket telles bare. Skal den
      #   lagrede identifikatoren oppdateres, skal saksbehandleren få beskjed, eller skal det bare følges med på?
      # - Logger personen inn fra en annen tjeneste enn Min kompetanse, kjennes hen ikke igjen, og blir en ny person.
      #   Er det greit?
      # - Skal navn og fødselsdato fra eIDAS oppdatere det som er lagret når de er ulike? I dag brukes det lagrede.
      Gitt at personen har blitt søker med eIDAS
      Og at landet har gitt personen en ny eIDAS-identifikator
      Når personen logger inn med eIDAS igjen og legger et utdanningstilbud i studiekurven
      Så er personen den samme søkeren som før
      Og navnet og fødselsdatoen på søkeren er ikke endret

    @openquestion
    Scenario: Innloggingen er knyttet til en annen person enn identifikatoren
      # ÅPNE SPØRSMÅL:
      # - Hva skal personen få se? I dag gir «Legg til» en feil om manglende tilgang, og ingenting lagres.
      Gitt at eIDAS-identifikatoren i innloggingen er registrert på en annen person
      Når personen legger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Så ligger ikke utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Og ingen opplysninger om personene er endret

  Regel: Søkeren uten fødselsnummer og eIDAS oppgir navn og fødselsdato før første «Legg til»
    # Gjelder personen som har logget inn med e-post som selvregistrert bruker i ID-porten. Innloggingen gir
    # verken fødselsnummer, navn eller fødselsdato. Skjemaet er en egen side, ikke en modal (designprinsippene for
    # Min kompetanse, !993). Siden og tekstene står i bli_søker.design.md.

    Scenario: Den selvregistrerte personen blir bedt om navn og fødselsdato ved første «Legg til»
      Gitt at personen er innlogget med e-post som selvregistrert bruker
      Og at personen ikke har oppgitt navn og fødselsdato
      Når personen legger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Så kommer personen til siden for å legge inn opplysninger om seg selv
      Og utdanningstilbudet "Sykepleie, høst 2027" ligger ikke i studiekurven ennå

    Scenario: Utdanningstilbudet legges i studiekurven når opplysningene er lagret
      Gitt at personen er på siden for å legge inn opplysninger etter å ha valgt «Legg til» på "Sykepleie, høst 2027"
      Når personen legger inn fornavn, etternavn og fødselsdato og lagrer
      Så er personen opprettet som søker i opptak med de oppgitte opplysningene
      Og ligger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Og personen er tilbake på siden personen kom fra

    Scenario: Den selvregistrerte personen som ikke var innlogget, oppgir opplysningene etter innloggingen
      Gitt at personen ikke er innlogget
      Og at personen har valgt å legge utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Når personen logger inn med e-post som selvregistrert bruker for første gang
      Så kommer personen til siden for å legge inn opplysninger om seg selv
      Og utdanningstilbudet "Sykepleie, høst 2027" legges i studiekurven når opplysningene er lagret

    Scenario: Den selvregistrerte personen ser at opplysningene mangler før «Legg til»
      Gitt at personen er innlogget med e-post som selvregistrert bruker
      Og at personen ikke har oppgitt navn og fødselsdato
      Når personen åpner Finn studier
      Så ser personen en melding om at navn og fødselsdato må legges inn før studier kan legges i studiekurven
      Og personen kan gå til siden for å legge inn opplysningene uten å velge et utdanningstilbud

    Scenario: Siden forklarer hvorfor vi spør og hvordan opplysningene brukes
      # HK-9433. Teksten står i bli_søker.design.md.
      Gitt at personen er innlogget med e-post som selvregistrert bruker
      Når personen kommer til siden for å legge inn opplysninger om seg selv
      Så ser personen hvorfor navn og fødselsdato trengs for å søke opptak
      Og personen ser hvordan opplysningene brukes i opptaket

    Scenario: Personen går tilbake uten å lagre
      Gitt at personen er på siden for å legge inn opplysninger etter å ha valgt «Legg til» på "Sykepleie, høst 2027"
      Når personen går tilbake uten å lagre
      Så er personen ikke opprettet som søker i opptak
      Og utdanningstilbudet "Sykepleie, høst 2027" ligger ikke i studiekurven

    Scenario: Den selvregistrerte personen blir bedt om opplysningene når et dokument lastes opp
      Gitt at personen er innlogget med e-post som selvregistrert bruker
      Og at personen ikke har oppgitt navn og fødselsdato
      Når personen laster opp et dokument
      Så kommer personen til siden for å legge inn opplysninger om seg selv
      Og etter lagring er personen tilbake på siden personen kom fra

    Scenariomal: Personen innlogget med <innloggingsmåte> blir ikke bedt om opplysningene
      Gitt at personen er innlogget i Min kompetanse med <innloggingsmåte>
      Når personen åpner Finn studier og legger et utdanningstilbud i studiekurven
      Så ser personen ingen melding om manglende opplysninger
      Og personen kommer ikke til siden for å legge inn opplysninger

      Eksempler:
        | innloggingsmåte             |
        | ID-porten med fødselsnummer |
        | Feide med fødselsnummer     |
        | eIDAS                       |

  @openquestion
  Regel: Navnet og fødselsdatoen søkeren oppgir, må være gyldige
    # ÅPNE SPØRSMÅL:
    # - Er grensene besluttet, eller er de bare slik koden er: navn 1–100 tegn, fødselsdato tilbake i tid og alder
    #   12–120 år? Hvorfor 12 år?
    # - Skal søkeren kunne rette navnet og fødselsdatoen etterpå (HK-9432)? Skal saksbehandleren kunne det (HK-10841)?
    #
    # Reglene er de samme i skjemaet og i opptak. Opptak avgjør, og skjemaet viser feilene før innsending.
    # Mellomrom før og etter navnet fjernes før det lagres, også harde mellomrom.
    # Feilmeldingene står i bli_søker.design.md.

    Scenariomal: Fornavnet "<fornavn>" er <resultat>
      Gitt at personen er på siden for å legge inn opplysninger
      Når personen lagrer med fornavnet "<fornavn>", etternavn "Nordmann" og en gyldig fødselsdato
      Så er fornavnet <resultat>

      Eksempler:
        | fornavn                        | resultat                             |
        | Kari                           | gyldig                               |
        | K                              | gyldig                               |
        | 100 tegn                       | gyldig                               |
        | 101 tegn                       | ugyldig                              |
        | tomt                           | ugyldig                              |
        | bare mellomrom                 | ugyldig                              |
        | bare harde mellomrom           | ugyldig                              |
        | med et kontrolltegn            | ugyldig                              |
        | " Kari " med harde mellomrom   | gyldig, og lagres som "Kari"         |

    Scenario: Etternavnet følger de samme reglene som fornavnet
      Gitt at personen er på siden for å legge inn opplysninger
      Når personen lagrer med etternavn av 101 tegn
      Så er etternavnet ugyldig

    Scenariomal: Fødselsdatoen til en person som <alder>, er <resultat>
      Gitt at personen er på siden for å legge inn opplysninger
      Når personen lagrer med fødselsdatoen til en person som <alder>
      Så er fødselsdatoen <resultat>

      Eksempler:
        | alder                    | resultat |
        | er født i morgen         | ugyldig  |
        | er født i dag            | ugyldig  |
        | fyller 12 år i morgen    | ugyldig  |
        | fylte 12 år i dag        | gyldig   |
        | fylte 120 år i dag       | gyldig   |
        | fylte 121 år i dag       | ugyldig  |

    Scenario: Ingenting lagres når en opplysning er ugyldig
      Gitt at personen er på siden for å legge inn opplysninger etter å ha valgt «Legg til» på "Sykepleie, høst 2027"
      Når personen lagrer med et ugyldig fornavn
      Så får personen beskjed om hvilket felt som må rettes
      Og personen er ikke opprettet som søker i opptak
      Og utdanningstilbudet "Sykepleie, høst 2027" ligger ikke i studiekurven

  @openquestion
  Regel: Personen som allerede er registrert, registreres ikke på nytt
    # ÅPNE SPØRSMÅL:
    # - Skal personen få vite at opplysningene som ble oppgitt nå, ikke er brukt fordi personen var registrert fra
    #   før? I !993 merker personen ingenting, og utdanningstilbudet legges i studiekurven.
    #
    # Opplysningene registreres én gang. Er personen registrert fra før (en tidligere innlogging, en annen fane eller
    # et dobbeltklikk), brukes de lagrede opplysningene, og det som er oppgitt nå, legges ikke over dem.

    Scenario: Personen som er registrert fra en tidligere innlogging, får utdanningstilbudet i studiekurven
      Gitt at personen har oppgitt fornavn "Kari", etternavn "Nordmann" og fødselsdato 15.03.2005 før
      Og at personen ikke har et utdanningstilbud i studiekurven
      Og at personen er på siden for å legge inn opplysninger etter å ha valgt «Legg til» på "Sykepleie, høst 2027"
      Når personen lagrer med fornavn "Karianne", etternavn "Nordmann" og fødselsdato 15.03.2005
      Så ligger utdanningstilbudet "Sykepleie, høst 2027" i studiekurven
      Og søkeren er registrert med fornavn "Kari"

    Scenario: Personen sender inn skjemaet to ganger samtidig
      Gitt at personen er på siden for å legge inn opplysninger
      Når personen lagrer skjemaet to ganger samtidig
      Så er personen opprettet som én søker i opptak

    Scenario: Skjemaet vises ikke igjen etter at opplysningene er oppgitt
      Gitt at personen har oppgitt navn og fødselsdato
      Når personen legger et nytt utdanningstilbud i studiekurven
      Så legges utdanningstilbudet i studiekurven
      Og personen kommer ikke til siden for å legge inn opplysninger
