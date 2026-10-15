# Implementasjonsdetaljer: Se digitale resultater i søknaden

**Relatert feature:** [`se_digitale_resultater_i_søknad.feature`](./se_digitale_resultater_i_søknad.feature)

## Overordnet UI-mønster

Seksjon øverst i steget «Dokumentasjon» (steg 3 av 4) i søknadsflyten i Min kompetanse («Ny søknad»). Seksjonen står under stegindikatoren og over «Mine studieønsker og opptakskrav» og opplastingen («Last opp dokumentasjon»).

Seksjonen er bare visning. Søkeren kan ikke velge, endre eller fjerne resultater her.

## Komponenter og layout

- **Overskrift:** «Mine kvalifikasjoner og dokumenter», med en ingress under.
- **Ett kort per utdanningsnivå**, med nivået som tittel: «Videregående opplæring» først, så «Høyere utdanning». Et nivå uten resultater vises ikke.
- **Én rad per resultat** i kortet, med skillelinje mellom radene:
  - ikon (award)
  - linje 1: tittelen på vitnemålet eller graden (f.eks. «Vitnemål - videregående skole», «Bachelor Barnehagelærer»)
  - linje 2: utsteder og utstedelsesdato, `«<utsteder>, <dd.mm.åååå>»`
  - linje 3 (mindre tekst): tilleggsopplysningen, det vil si kompetansen vitnemålet gir for videregående (f.eks. «Generell studiekompetanse»), og graden for høyere utdanning (f.eks. «Barnehagelærer - Bachelor»)
  - merkelapp til høyre: «Hentet automatisk»
- **«Andre resultater»:** eget kort under nivåkortene, lukket som standard, med «Vis resultater» og et pil-ikon til høyre. Kortet vises bare når søkeren har andre resultater. Det vises aldri som en tom accordion.
- **Tom tilstand:** et informasjonspanel (GuidePanel med info-ikon) under overskriften, i stedet for ingressen og kortene.

## Interaksjonsmønstre

### Primærhandling
Ingen. Seksjonen er informasjon. Primærhandlingene i steget (opplasting og «Oppsummering») hører ikke til dette kravet.

### Sekundære handlinger
- «Vis resultater» åpner «Andre resultater». Se *Åpne designspørsmål* for åpnet tilstand.

### Navigasjon
Søkeren kommer hit fra steget «Utdanningsbakgrunn», og går videre til «Oppsummering». Søkeren navigerer ikke ut til resultatvisningen i Min kompetanse (avklart 25.09.2026).

## Tilstander

| Tilstand | UI-håndtering |
|----------|---------------|
| Har resultater | Ingress, nivåkort og eventuelt «Andre resultater» |
| Ingen andre resultater | Kortet «Andre resultater» vises ikke (scenario «Andre resultater vises ikke uten andre resultater») |
| Tom (ingen digitale resultater) | Informasjonspanelet med forklaringen. Ingen nivåkort |
| Feil (hentingen har feilet) | Samme informasjonspanel som tom tilstand. Ingen egen feilmelding (scenariomalen «Samme forklaring vises uansett årsak …») |
| Resultat der bare utstederen er kjent (`@draft`) | Raden viser bare utstederen og merkelappen, ingen tittel, dato eller tilleggsopplysning, og ingen beskjed om at noe mangler. Skisse: `4274:43654` |
| Laster | Ikke vist i skissene. Se *Åpne designspørsmål* |

## Tekster

Dette er fasiten for tekstene, også når en skisse viser noe annet.

| Hvor | Når vises den | Tekst | Variasjoner | Scenario |
|------|---------------|-------|-------------|----------|
| Seksjonsoverskrift | Alltid | «Mine kvalifikasjoner og dokumenter» | – | Se at dokumentasjonen er hentet automatisk |
| Ingress | Søkeren har digitale resultater | «Vi har hentet disse digitale resultatene automatisk for deg. Du trenger derfor ikke laste dem opp selv. Saksbehandleren kan se dem når søknaden din behandles.» | – | Se at dokumentasjonen er hentet automatisk |
| Korttittel | Søkeren har resultater på nivået | «Videregående opplæring» / «Høyere utdanning» | Én per nivå | Resultatene vises gruppert på nivå |
| Merkelapp på hver rad | Alltid på et digitalt resultat | «Hentet automatisk» | – | Se at et resultat er hentet automatisk |
| Kort for andre resultater | Søkeren har resultater som verken er vitnemål eller grad | «Andre resultater» | – | Andre resultater er lukket som standard |
| Lenke i «Andre resultater» | Lukket | «Vis resultater» | Åpnet: se *Åpne designspørsmål* | Andre resultater er lukket som standard / Se andre resultater |
| Informasjonspanel, tittel | Ingen digitale resultater, eller hentingen har feilet | «Vi fant ingen resultater knyttet til deg» | – | Samme forklaring vises uansett årsak til manglende resultater |
| Informasjonspanel, tekst | Som over | «Mulig forklaring:» med punktene «Du har ikke oppnådd noen resultater ved institusjonene som leverer data til denne tjenesten.», «Utdanningsinstitusjonen du har studert ved, har ikke resultatene dine i sin database.» og «Vi har ikke fått lastet inn oppdatert informasjon enda. Prøv igjen senere.», og så «Hvis du behov for å dokumentere resultater som ikke vises her, kan du laste opp de opp selv eller ta kontakt med aktuell utdanningsinstitusjon.» | – | Samme forklaring vises uansett årsak til manglende resultater |

Teksten i informasjonspanelet er skissens ordlyd, valgt 14.10.2026. Den ligner tom tilstand på «Mine resultater» i min-kompetanse (`messages/files/nb.json`, `visninger-empty`), men siste setning er ny: der står «ber vi deg ta kontakt med aktuell utdanningsinstitusjon».

**Skisser:** Figma «Min Kompetanse 2026», persistert under `tasks/opptak/digitale-resultater-i-soknad/spec/krav-input/sketches/figma/`:
- `konsept-dokumentopplastning/` (node `3920:14210`), med resultater
- `konsept-dokumentopplastning-ingen-resultater/` (node `4401:18141`), uten resultater
- `resultat-der-bare-utstederen-er-kjent/` (node `4274:43654`), resultat der bare utstederen er kjent

## Per-scenario detaljer

### Scenario: Se at dokumentasjonen er hentet automatisk
Ingressen er det som forteller søkeren at dokumentasjonen er hentet automatisk, og at saksbehandleren ser den. Seksjonen står over opplastingen.

### Scenario: Resultatene vises gruppert på nivå
Ett kort per nivå, videregående først. Merk: «Mine resultater» i min-kompetanse viser høyere utdanning først i dag. Her skal rekkefølgen være motsatt.

### Scenario: Se opplysninger om et resultat
Tittel på linje 1, utsteder og utstedelsesdato på linje 2.

### Scenariomal: Se tilleggsopplysning for et resultat fra <nivå>
Linje 3 i raden. For videregående er det kompetansen vitnemålet gir (generell studiekompetanse, yrkeskompetanse eller fagopplæring).

### Scenario: Se et resultat der bare utstederen er kjent (`@draft`)
Bare utstederen og merkelappen. Ingen tom plass for tittel eller dato, og ingen beskjed om at noe mangler.

### Scenario: Andre resultater er lukket som standard / Se andre resultater
Lukket kort med «Vis resultater». Åpnet tilstand er ikke tegnet.

### Scenario: Andre resultater vises ikke uten andre resultater
Har søkeren bare vitnemål og grader, rendres ikke kortet «Andre resultater» i det hele tatt. Ingen tom accordion, og ingen tekst om at det ikke finnes andre resultater.

### Scenariomal: Samme forklaring vises uansett årsak til manglende resultater
Samme informasjonspanel for ingen resultater og for feil.

## Åpne designspørsmål

- [ ] Hvordan ser «Andre resultater» ut når seksjonen er åpnet: hvilke opplysninger vises for enkeltemner og øvrig dokumentasjon, og hva heter lenken da (f.eks. «Skjul resultater», som «Skjul opptakskrav» i samme steg)?
- [ ] Teksten i informasjonspanelet bruker «institusjonene» og «utdanningsinstitusjon». Terminologien i `krav/README.md` sier «lærested» om universitet, høyskole og fagskole. Skal teksten endres?
- [ ] Teksten i informasjonspanelet har språkfeil: «Hvis du behov» mangler «har», og «laste opp de opp» har ett «opp» for mye (skal trolig være «laste dem opp»).
- [ ] Hva vises mens resultatene lastes?
