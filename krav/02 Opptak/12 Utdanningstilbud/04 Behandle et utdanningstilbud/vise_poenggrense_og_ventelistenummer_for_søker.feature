# language: no
@OPT-OPT-UTD-029 @should @draft @scope-utdanningstilbud-2027
Egenskap: Vise poenggrense og ventelistenummer for søker
  Som opptaksforvalter
  ønsker jeg å bestemme om søkere skal se poenggrensen og ventelistenummeret sitt for utdanningstilbudet
  slik at søkerne får informasjonen som passer for utdanningstilbudet.

  # Kilde: Figma, FS Admin - Seksjon Opptak, node 18797:108875 (Opptaksinnstillinger, Søknadsprosess).

  # ÅPNE SPØRSMÅL:
  # - Hvor ser søkeren poenggrensen og ventelistenummeret, i Min kompetanse?
  # - Hvilken poenggrense gjelder det: poenggrensen for tidligopptak (registrere_poengopplysninger.feature) eller poenggrensen fra plasstildelingen?

  Regel: Opptaksforvalter bestemmer om poenggrensen vises for søker

  Regel: Opptaksforvalter bestemmer om ventelistenummeret vises for søker

  # Avklart 2026-11-10 (R11 og svar 18): poenggrensen er skjult for søkere og brukere uten roller til
  # plasstildelingen er publisert. I dag kan alle innloggede se alle poenggrenser hele tiden.
  Regel: Søkere og brukere uten roller ser poenggrensen først når plasstildelingen er publisert

    Scenariomal: Poenggrensen før og etter publisering
      Gitt at opptaksforvalter har valgt å vise poenggrensen for søker på "Sykepleie, høst 2027"
      Og plasstildelingen er <status>
      Når <hvem> ser utdanningstilbudet "Sykepleie, høst 2027"
      Så <ser> <hvem> poenggrensen

      Eksempler:
        | status         | hvem                          | ser      |
        | ikke publisert | søkeren                       | ser ikke |
        | ikke publisert | en integrasjon uten roller    | ser ikke |
        | publisert      | søkeren                       | ser      |
        | publisert      | en integrasjon uten roller    | ser      |
