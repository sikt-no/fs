# Implementasjonsdetaljer: Bli søker ved første «Legg til»

**Relatert feature:** [`bli_søker.feature`](./bli_søker.feature)

> Utkast (Kjetil/Claude 06.11.2026), ikke avklart med produkteier. Beskriver prototypen i min-kompetanse !993 (stablet på !987, ikke merget) og kontrakten i fs-plattform !6546 og !6554. Tekstene er utkast til designerne. Kjetils svar 06.11.2026 er innarbeidet.

## Leveranserekkefølge

fs-plattform !6554 venter ikke på min-kompetanse !993 (Kjetil 06.11.2026). !993 er foreløpig en prototype. Til den er ferdig, får den selvregistrerte søkeren en feil på «Legg til» i stedet for siden for personopplysninger, og det er akseptert. Søkere med fødselsnummer eller eIDAS merker ingenting.

## Overordnet UI-mønster

- Skjemaet for navn og fødselsdato er en **egen side**, ikke en modal (designprinsippene for Min kompetanse sier at modaler skal unngås). Siden har én oppgave, kan nås fra listen i Finn studier og fra siden for utdanningstilbudet, og bruker samme mekanisme som innloggingen for å huske studiet.
- Ruter: `/nb/finn-studier/personopplysninger`, `/nn/finn-studium/personopplysningar`, `/en/find-studies/personal-details`.
- Bare den selvregistrerte personen (innlogget med ID-porten uten fødselsnummer og uten eIDAS) ser siden og meldingen. Med fødselsnummer eller eIDAS er det ingen synlig endring: søkeren opprettes ved første «Legg til».

## Interaksjonsmønstre

### Primærhandling
«Legg til» på et utdanningstilbud → siden for personopplysninger med studiet husket → «Lagre og legg til studiet» → studiet legges i studiekurven, og personen er tilbake der hen kom fra (samme søk, filtre og side i Finn studier).

### Sekundære handlinger
- Melding øverst i Finn studier når opplysningene mangler, med knappen «Legg inn opplysninger». Den åpner siden uten studium, og knappen heter da «Lagre».
- Opplasting av dokument uten opplysninger sender også til siden, og «Tilbake»/«Lagre» fører tilbake.

### Navigasjon
- Tilbakelenke øverst. «Tilbake» lagrer ingenting.
- Siden sender bare tilbake til sider i Min kompetanse.
- Ikke innlogget: «Legg til» starter innloggingen, og siden kommer etter innloggingen, før studiet legges til.

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Ugyldig felt (i skjemaet) | Feiloppsummering over skjemaet (SDS `ErrorSummary`), med lenker som flytter fokus til feltet. Oppsummeringen får fokus |
| Opptak avviser opplysningene | Generell melding på skjemaet. Ingenting lagres |
| Personen er registrert fra før | Regnes som registrert. Studiet legges i studiekurven med de lagrede opplysningene. Personen får beskjed om at opplysningene som ble oppgitt nå, ikke er brukt (avklart 06.11.2026, mangler i !993) |
| «Legg til» krever fortsatt opplysninger etter lagring | Generell feil på siden. Skjemaet vises ikke igjen i samme fane |
| Innlogging ikke tillatt (fødselsnummer, eIDAS, annen person) | Generell melding på skjemaet |

## Universell utforming

- Fokus flyttes til overskriften når siden åpnes.
- Feiloppsummeringen får fokus etter et mislykket forsøk.

## Tekster

Utkast fra !993, på bokmål (nynorsk og engelsk finnes i prototypen). Designerne kommenterer.

| Hvor | Tekst |
|------|-------|
| Overskrift | «Legg inn opplysninger om deg» |
| Melding i Finn studier | «Før du kan legge studier i studiekurven, må du legge inn navnet ditt og fødselsdatoen din.» |
| Knapp i meldingen | «Legg inn opplysninger» |
| Knapp med studium | «Lagre og legg til studiet» |
| Knapp uten studium | «Lagre» |
| Feiloppsummering | «Rett opp dette før du går videre:» |
| Forklaring (hvorfor vi spør, HK-9433) | Utkast i !993. Skal si hvorfor opptaket trenger navn og fødselsdato, og hvordan opplysningene brukes. Endelig tekst mangler |
| Informasjon om riktige opplysninger | Skal si at opplysningene må være riktige, fordi fødselsdatoen brukes i behandlingen av søknaden og i plasstildelingen, og at feil opplysninger kan føre til at søkeren mister studieplassen. Endelig tekst mangler |
| Melding når opplysningene ikke er brukt | Skal si at personen er registrert fra før, og at opplysningene som ble oppgitt nå, ikke er brukt. Endelig tekst mangler |

### Feilmeldinger fra opptak (én per felt)

| Felt | Melding |
|------|---------|
| Fornavn | «Fornavnet må ha 1 til 100 tegn uten kontrolltegn.» |
| Etternavn | Tilsvarende for etternavnet |
| Fødselsdato | Fødselsdatoen må være en gyldig dato tilbake i tid |
| Registrert fra før | «Du er allerede registrert.» (vises ikke til personen i !993) |

## Tekniske begrensninger

- Navn kan ha høyst 100 tegn. Det er en teknisk grense (fra !6554), ikke en besluttet regel for produktet.
- Det er ingen aldersgrense (avklart 06.11.2026). Grensen på 12–120 år er fjernet i !6554 og skal fjernes i !993.

## Åpne designspørsmål

- Skal siden også nås fra Min oversikt eller profilen, og ikke bare fra Finn studier?
- Forklaringen om hvorfor vi spør og hvordan opplysningene brukes (HK-9433): hvilken tekst, og skal den lenke til personvernerklæringen?
