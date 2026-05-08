# Systemkrav: Iterasjon 2 — Support: Oversikt og passordbytte

## Oversikt

**Domene:** 07 Brukeradministrasjon og tilgangsstyring / Applikasjoner / applikasjoner

**Aktører:**
- Sikt support (super-applikasjonsadministrator eller applikasjonsadministrator for relevante organisasjoner)
- Lokal administrator (kunde-side bruker med applikasjonsadministrator-rollen for egen organisasjon)

**Formål:** Gi support og lokale administratorer en lesbar oversikt over applikasjoner, innsyn i detaljer og tilganger, og mulighet til å hjelpe med passordbytte. Iterasjonen dekker typiske support-oppgaver uten å åpne for opprettelse, deaktivering eller endring av tilganger — det kommer i Iterasjon 3.

## Brukerreise

1. En kunde melder en sak: «integrasjonen vår fungerer ikke» eller «vi trenger nytt passord».
2. Support **finner riktig applikasjon** via listevisning og søk/filtrering — enten innen egen organisasjon (lokal admin) eller på tvers (Sikt support).
3. På detaljsiden ser support **grunnleggende informasjon og tilganger** for å forstå hva applikasjonen kan.
4. Ved behov **byttes passordet** (kun de med rettighet) og det nye passordet leveres til ansvarlig.
5. Hvis informasjonen er utdatert: **ansvarlig oppdateres** og/eller **beskrivelsen redigeres**.

Iterasjonen leverer altså en *lese- og lett-redigerings-løsning*. Endringer som påvirker selve tilgangen (tildeling/fjerning av tilganger, deaktivering) ligger i Iterasjon 3.

## Kapabiliteter

### K1, K2, K11, K12 — Listevisning og søk i applikasjoner

**Feature-ID:** [`BRU-APP-API-001`](listevisning_og_sok.feature) | **GitHub:** [#438](https://github.com/sikt-no/fs/issues/438), [#448](https://github.com/sikt-no/fs/issues/448), [#449](https://github.com/sikt-no/fs/issues/449)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg en oversikt over applikasjoner jeg har tilgang til, med søk og filtrering, slik at jeg raskt finner riktig applikasjon.

**Kort beskrivelse:** Liste med navn, beskrivelse, miljøer, ansvarlig og organisasjon. Paginering 50 om gangen. Fritekst-søk på navn og filter på organisasjon. Synligheten styres av administrasjonsrettigheter — superadministrator ser alle, lokale administratorer ser sine egne organisasjoner og applikasjoner som har tilganger i deres organisasjoner.

### K3 — Se detaljer for applikasjon

**Feature-ID:** [`BRU-APP-API-002`](se_detaljer.feature) | **GitHub:** [#439](https://github.com/sikt-no/fs/issues/439)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å se detaljer for en applikasjon, organisert i logiske datagrupper, slik at jeg har oversikt.

**Kort beskrivelse:** Detaljside med grunnleggende info (navn, beskrivelse), sporingsinfo (opprettet/endret), miljøer og ansvarlig.

### K4 — Vise tilganger for applikasjon

**Feature-ID:** [`BRU-APP-API-003`](vise_tilganger.feature) | **GitHub:** [#440](https://github.com/sikt-no/fs/issues/440)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å se hvilke tilganger en applikasjon har, slik at jeg forstår hvilke rettigheter og miljøtilgang den er tildelt.

**Kort beskrivelse:** Egen tab med liste over alle tilganger, viser tilgangskode + miljø. Filtrering på miljø og tilgang, sortering, paginering.

### K5 — Passordbytte for applikasjon

**Feature-ID:** [`BRU-APP-API-004`](passordbytte.feature) | **GitHub:** [#441](https://github.com/sikt-no/fs/issues/441)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å sette nytt passord på en applikasjon jeg administrerer, slik at jeg kan hjelpe med passordbytte.

**Kort beskrivelse:** Systemet genererer passordet (basic auth, ett aktivt passord om gangen). Vises skjult med mulighet for å vise og kopiere; kan ikke hentes opp igjen etter at dialogen lukkes. Nytt passord erstatter det gamle umiddelbart.

### K18 — Administrere ansvarlig for applikasjon

**Feature-ID:** [`BRU-APP-API-005`](administrere_ansvarlig.feature) | **GitHub:** [#442](https://github.com/sikt-no/fs/issues/442)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å sette og endre ansvarlig for en applikasjon, slik at det er klart hvem som har kontakten med tredjeparten.

**Kort beskrivelse:** Ansvarlig er en feide-bruker (eller feide-gruppe som «kan ha») fra applikasjonens organisasjon. Ansvarlig arver passordbytte-rett. Søket etter ansvarlig er begrenset til applikasjonens organisasjon.

### K19 — Redigere beskrivelse for applikasjon

**Feature-ID:** [`BRU-APP-API-006`](rediger_beskrivelse.feature) | **GitHub:** [#443](https://github.com/sikt-no/fs/issues/443)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å redigere beskrivelsen for en applikasjon, slik at informasjonen er oppdatert.

**Kort beskrivelse:** Krever administrasjonsrettighet for applikasjonens organisasjon. Superadministrator kan redigere alle.

## Åpne spørsmål

Ingen åpne spørsmål på iterasjons-nivå. Detaljerte spørsmål (om noen) ligger i de enkelte `.feature`-filene.

## Notater

- K10 (permanent sletting av applikasjon) er bevisst utelatt — deaktivering i Iterasjon 3 er sluttilstanden.
- Generell søke- og filter-funksjonalitet kan med tiden flyttes til `10 Felleskrav` (jf. konvensjon om "hva vs hvordan").
