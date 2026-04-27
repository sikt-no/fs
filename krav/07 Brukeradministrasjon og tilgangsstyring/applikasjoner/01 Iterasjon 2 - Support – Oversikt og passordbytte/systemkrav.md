# Systemkrav: Iterasjon 2 — Support: Oversikt og passordbytte

## Oversikt

**Domene:** 07 Brukeradministrasjon og tilgangsstyring / Applikasjoner / API-brukere

**Aktører:**
- Sikt support (api-superbrukeradministrator eller api-brukeradministrator for relevante organisasjoner)
- Lokal administrator (kunde-side bruker med api-brukeradministrator-rollen for egen organisasjon)

**Formål:** Gi support og lokale administratorer en lesbar oversikt over API-brukere, innsyn i detaljer og roller, og mulighet til å hjelpe med passordbytte. Iterasjonen dekker typiske support-oppgaver uten å åpne for opprettelse, deaktivering eller rolle-endringer — det kommer i Iterasjon 3.

## Brukerreise

1. En kunde melder en sak: «integrasjonen vår fungerer ikke» eller «vi trenger nytt passord».
2. Support **finner riktig API-bruker** via listevisning og søk/filtrering — enten innen egen organisasjon (lokal admin) eller på tvers (Sikt support).
3. På detaljsiden ser support **grunnleggende informasjon og roller** for å forstå tilgangen.
4. Ved behov **byttes passordet** (kun de med rettighet) og det nye passordet leveres til ansvarlig.
5. Hvis informasjonen er utdatert: **ansvarlig oppdateres** og/eller **beskrivelsen redigeres**.

Iterasjonen leverer altså en *lese- og lett-redigerings-løsning*. Endringer som påvirker selve tilgangen (roller, deaktivering) ligger i Iterasjon 3.

## Kapabiliteter

### K1, K2, K11, K12 — Listevisning og søk i API-brukere

**Feature-ID:** [`BRU-APP-API-001`](listevisning_og_sok.feature) | **GitHub:** [#438](https://github.com/sikt-no/fs/issues/438), [#448](https://github.com/sikt-no/fs/issues/448), [#449](https://github.com/sikt-no/fs/issues/449)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg en oversikt over API-brukere jeg har tilgang til, med søk og filtrering, slik at jeg raskt finner riktig API-bruker.

**Kort beskrivelse:** Liste med navn, beskrivelse, miljøer, ansvarlig, organisasjon, type og oppfølgingsstatus. Paginering 50 om gangen. Fritekst-søk på navn og filter på organisasjon. Synligheten styres av administrasjonsrettigheter — superadministrator ser alle, lokale administratorer ser sine egne organisasjoner og API-brukere som har roller i deres organisasjoner.

### K3 — Se detaljer for API-bruker

**Feature-ID:** [`BRU-APP-API-002`](se_detaljer.feature) | **GitHub:** [#439](https://github.com/sikt-no/fs/issues/439)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å se detaljer for en API-bruker, organisert i logiske datagrupper, slik at jeg har oversikt.

**Kort beskrivelse:** Detaljside med grunnleggende info (navn, beskrivelse), sporingsinfo (opprettet/endret), miljøer og ansvarlig.

### K4 — Vise roller for API-bruker

**Feature-ID:** [`BRU-APP-API-003`](vise_roller.feature) | **GitHub:** [#440](https://github.com/sikt-no/fs/issues/440)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å se hvilke roller en API-bruker har, slik at jeg forstår hvilke rettigheter og miljøtilgang den er tildelt.

**Kort beskrivelse:** Egen tab med liste over alle roller, viser rollekode + miljø. Filtrering på miljø og rolle, sortering, paginering.

### K5 — Passordbytte for API-bruker

**Feature-ID:** [`BRU-APP-API-004`](passordbytte.feature) | **GitHub:** [#441](https://github.com/sikt-no/fs/issues/441)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å sette nytt passord på en API-bruker jeg administrerer, slik at jeg kan hjelpe med passordbytte.

**Kort beskrivelse:** Systemet genererer passordet (basic auth, ett aktivt passord om gangen). Vises skjult med mulighet for å vise og kopiere; kan ikke hentes opp igjen etter at dialogen lukkes. Nytt passord erstatter det gamle umiddelbart.

### K18 — Administrere ansvarlig for API-bruker

**Feature-ID:** [`BRU-APP-API-005`](administrere_ansvarlig.feature) | **GitHub:** [#442](https://github.com/sikt-no/fs/issues/442)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å sette og endre ansvarlig for en API-bruker, slik at det er klart hvem som har kontakten med tredjeparten.

**Kort beskrivelse:** Ansvarlig er en feide-bruker (eller feide-gruppe som «kan ha») fra API-brukerens organisasjon. Ansvarlig arver passordbytte-rett. Søket etter ansvarlig er begrenset til API-brukerens organisasjon.

### K19 — Redigere beskrivelse for API-bruker

**Feature-ID:** [`BRU-APP-API-006`](rediger_beskrivelse.feature) | **GitHub:** [#443](https://github.com/sikt-no/fs/issues/443)

**Prioritet:** Må ha · **Status:** Planlagt

**Brukerhistorie:** Som bruker ønsker jeg å redigere beskrivelsen for en API-bruker, slik at informasjonen er oppdatert.

**Kort beskrivelse:** Krever administrasjonsrettighet for API-brukerens organisasjon. Superadministrator kan redigere alle.

## Åpne spørsmål

Ingen åpne spørsmål på iterasjons-nivå. Detaljerte spørsmål (om noen) ligger i de enkelte `.feature`-filene.

## Notater

- K10 (permanent sletting av API-bruker) er bevisst utelatt — deaktivering i Iterasjon 3 er sluttilstanden.
- Iterasjon 2 har avhengighet til Iterasjon 3 for at "oppfølgingsstatus"-kolonnen skal kunne vise meningsfulle verdier (deaktivert/aktiv).
- Generell søke- og filter-funksjonalitet kan med tiden flyttes til `10 Felleskrav` (jf. konvensjon om "hva vs hvordan").
