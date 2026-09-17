# Opprette og vedlikeholde opptak

*Designfilen gir en teknisk-funksjonell beskrivelse av et konsept: hvordan det er ment å fungere, hvilke beslutninger som er tatt, hvor data kommer fra og hva som gjenstår. Den er skrevet for å skape forståelse på tvers av roller. Den svarer på hva og hvorfor — ikke på hvordan noe skal implementeres eller se ut.*

Opptaksforvalter skal kunne opprette og forvalte opptak med alle innstillinger som styrer hvem som kan søke, hvilke frister som gjelder, og hva søkeren ser. Mye av dette finnes allerede i fs-plattform/opptak, men innstillingene er i dag spredt mellom opptakstype og opptak. Dette dokumentet beskriver hva løsningen skal gjøre, hvilke valg som er tatt, og hvilke spørsmål som gjenstår.

Dokumentet er skrevet for alle som trenger å forstå hva det vil si å opprette et opptak, hvordan samordning fungerer, og hvilke innstillinger som må settes. Funksjonell løsning per oppgave og tekniske detaljer ligger i [oppgave.md](oppgave.md).

**Status:** oppdatert 2026-09-15 etter workshop med Shiitake og Shinkansen. Bygger på gjennomgang av databasen i fs-plattform/opptak (PostgreSQL), FS-SIS (Oracle, OPPTAK-tabellen), og domenedokumentasjon fra fs.sikt.no.

---

**Fire beslutninger bør leses før resten, fordi alt annet følger av dem. Tre er tatt. En er åpen.**

1. **Opptakstype som konfigurasjonsnivå utgår, men bevares som fast kodeverk for matching.** I gammel løsning arvet et opptak innstillinger fra en opptakstype (UHG, FSU, lokalt osv.). I ny løsning oppretter man bare et opptak — innstillinger som i dag ligger på opptakstype flyttes til opptaket selv, og brukere skal ikke kunne opprette egne opptakstyper. Men opptakstype bevares som et lite, sentralt forvaltet kodeverk (f.eks. UHG, HYU, master, emne/kurs) for å kategorisere opptak. 

2. **Samordning er en egenskap ved opptaket, ikke en type.** Et opptak blir samordnet ved at opptakseier inviterer andre læresteder til å delta med utdanningstilbud og saksbehandlere. Et opptak uten inviterte læresteder er lokalt. Det finnes ikke en separat «samordnet»-bryter — samordning fremgår av deltakerne. Dette er tatt.

3. **Enkelte utdanningstilbud trenger strengere søknadsfrist enn opptakets generelle frist.** Noen utdanninger (f.eks. Politihøyskolen) har tidlig søknadsfrist fordi de krever opptaksprøver eller annen tilleggsvurdering som tar tid. I ny løsning må det være mulig å sette en tidligere søknadsfrist per utdanningstilbud. Forslag: søknadsperiode (med tidligere til-dato) og ettersendingsfrist kan overstyres per utdanningstilbud; andre frister gjelder alltid for hele opptaket.

4. **Innstillinger for emneopptak, kurs og undervisningsopptak skal ikke dekkes nå.** Disse opptakstypene har spesielle behov (løpende opptak, tilgang kun for egne studenter, ingen rangering). De er ikke hovedfokus og bør utsettes til egne oppgaver. Design for disse legges i egne dokumenter når behovet oppstår.

---

## Del 1: mål og retning

### Hva dette er, og hva det ikke er

Med «opprette og vedlikeholde opptak» mener vi arbeidet opptaksforvalter gjør for å klargjøre et opptak før søkere kan søke på utdanningstilbud som er knyttet til opptaket: gi opptaket et navn, bestemme hvem som kan søke, sette frister, velge regelverk, skrive tekster søkeren ser, og knytte til utdanningstilbud. Det er noe annet enn søknadsbehandlingen og plasstildelingen, som skjer etter at opptaket er åpent.

| | Opprette opptak | Søknadsbehandling | Plasstildeling |
|---|---|---|---|
| **Spørsmålet** | hva er rammene for dette opptaket? | er søkeren kvalifisert? | hvem får plassene? |
| **Skjer** | før opptak åpner | løpende, per søknad | som en kjøring, per runde |
| **Eier** | opptaksforvalter | saksbehandler | opptaksleder |
| **Dekkes her** | ja | nei | nei — se [plasstildeling/design.md](../plasstildeling/design.md) |

### Mål

- Opptaksforvalter skal kunne opprette et opptak, samordnet eller lokalt.
- Et samordnet opptak skal støtte at opptakseier inviterer læresteder til å delta med utdanningstilbud og saksbehandlere.
- Alle nødvendige innstillinger, frister og tekster skal kunne settes på opptaket.
- Utdanningstilbud skal kunne knyttes til opptaket, med mulighet for å arve eller overstyre innstillinger. (løses som del av utdanningstilbud)
- Opptaket skal kunne publiseres og gjøres søkbart for søkere.
- Plasstildelingsrunder skal kunne registreres etter at opptaket er publisert. 

### Ikke-mål

- **Ikke søknadsbehandling.** Vurdering av søkere er dekket andre steder.
- **Ikke plasstildeling.** Fordeling av plasser er dekket i [plasstildeling/design.md](../plasstildeling/design.md).
- **Ikke regelverksforvaltning.** Oppretting og vedlikehold av regelverkssamlinger er dekket i [regelverk/design.md](../regelverk/design.md). Her kobles en eksisterende samling til opptaket.
- **Ikke emneopptak, kurs eller undervisningsopptak.** Disse har spesielle behov som utsettes (se beslutning 4).
- **Ikke søkerens opplevelse.** Hvordan søkeren ser utdanningstilbud og kan søke, er en del av søknad- og saksbehandling.

---

## Del 2: løsningen

### Opprette et opptak

Et opptak opprettes av en opptaksforvalter ved å velge om det skal være samordnet eller lokalt. Valget avgjør om andre læresteder kan inviteres til å delta.

**Samordnet opptak:** Opptakseier (typisk Samordna opptak / HK-dir) oppretter opptaket og inviterer læresteder til å delta. Hvert invitert lærested bidrar med utdanningstilbud og saksbehandlere. Opptakseier setter felles innstillinger, frister og regelverk.

**Lokalt opptak:** Et enkelt lærested oppretter opptaket for sine egne utdanningstilbud. Alle innstillinger settes av lærestedet selv.

I begge tilfeller er resultatet et opptak med de samme egenskapene — forskjellen er bare antall deltakende organisasjoner.

**Kopiering fra tidligere opptak:** Det skal være mulig å opprette et nytt opptak basert på et tidligere opptak, slik at innstillinger, frister og fellestekster kopieres som utgangspunkt. Kopiering av opptak er ikke viktig for 2027.

### Invitere læresteder til samordnet opptak

Når opptakseier velger samordning, skal hen kunne invitere læresteder til å delta. Invitasjonen innebærer at lærestedet kan:

- Knytte egne utdanningstilbud til opptaket.
- Tildele egne saksbehandlere til søknadsbehandling.
- Se og følge opp søknader til egne utdanningstilbud.

Inviterte læresteder kan ikke endre opptakets fellesinnstillinger (frister, regelverk, søkergrupper) — dette eies av opptakseier, men de skal kunne se denne informasjonen.

I fs-plattform/opptak-databasen er dette modellert i `opptak.opptak_samordna_organisasjon`.

### Navn og periode

| Egenskap | Beskrivelse | Påkrevd |
|----------|-------------|---------|
| **Navn** | Opptakets navn, vises for saksbehandlere og søkere. Flerspråklig (bokmål, nynorsk, engelsk, samisk). | Ja |
| **Opptaksperiode** | Fra-dato og til-dato som angir når opptaket er aktivt og tilgjengelig for arbeid. | Ja |

Opptaksperioden styrer når opptaket er synlig og tilgjengelig for arbeid — ikke når søkere kan sende inn søknader (det styres av søknadsfristen).

### Innstillinger

#### Regelverkssamling

Opptaket kobles til en regelverkssamling som bestemmer kompetansekrav, rangeringsregelverk og kvotetyper. Regelverkssamlingen forvaltes separat (se [regelverk/design.md](../regelverk/design.md)) og kobles til opptaket ved oppretting.

Utdanningstilbud i opptaket kan kun benytte seg av regelverk og kvotetyper som inngår i opptakets regelverkssamling.

#### Standard poenglikhetsregel

Opptaksforvalter setter standard poenglikhetsregel for opptaket. Denne gjelder for alle utdanningstilbud i opptaket som default. Poenglikhetsreglene som er tilgjengelige er koblet til regelverkssamlingen. Forskriften er ulik mellom opptakstyper:

| Opptakstype | Forskriftsfestet regel | Valgfrihet for lærested |
|-------------|----------------------|------------------------|
| UHG (universiteter og høgskoler) | Loddtrekning (fra 2027) | Kan velge «alle med lik sum får tilbud» per utdanningstilbud |
| Fagskole (HYU) | Rangering etter alder | Ingen (forskriftsfestet) |
| Ledige studieplasser | Tidspunkt for levert søknad | — |

Poenglikhetsregelen er flyttet fra rangeringsregelverket til opptaket fordi den gjelder per opptak, ikke per regelverk.

#### Tidlig behandling og tilbud

Opptaksforvalter velger om opptaket skal støtte tidlig behandling og tilbud. Når dette er aktivert, kan søkere som oppfyller visse kriterier få svar før hovedfristen. Tidlig tilbud krever en egen frist (se frister nedenfor). Merk at dette tidligere er kalt "tidlig opptak", 
men siden søker kun blir gitt tidlig tilbud, ikke tidlig opptak i betydningen at de faktisk blir tatt opp, får studierett og blir studenter, så er begrepet endret.

#### Søkergrupper

Opptaksforvalter bestemmer hvilke søkergrupper som kan søke på opptaket. Søkergruppene angir hvem som ser opptaket og kan sende inn søknad:

| Søkergruppe                            | Beskrivelse                                                         |
|----------------------------------------|---------------------------------------------------------------------|
| Alle (hele verden)                     | Ingen begrensning på hvem som kan søke                              |
| EU/EØS-borgere                         | Begrenset til borgere fra EU/EØS-land                               |
| Nordiske borgere                       | Begrenset til borgere fra nordiske land                             |
| Personer med norsk fødselsnummer       | Begrenset til personer registrert med norsk fødselsnummer           |
| Kun inviterte søkere                   | Opptaket krever invitasjon — søkere må være nominert eller invitert |
| Egne studenter                         | Kun studenter med studierett ved lærestedet                         |
| Realkompetansesøkere                   | Søkere som søker med realkompetanse                                 |
| Søkere med særskilt vurderingsgrunnlag | Søkere som trenger særskilt vurdering for opptak                    |

Flere søkergrupper kan kombineres. Valget styrer synlighet for søkere og tilgjengelige søknadsskjemafelt. ()
Siden de samordna opptakene er åpne for alle søkergrupper, så er det ikke prioritert å løse begrensninger av søkergrupper før 2027.

#### Dokumentasjonsopplasting

Opptaksforvalter velger om søkere skal kunne laste opp dokumentasjon som del av søknaden. Når dette er aktivert, defineres hvilke dokumenttyper som aksepteres (vitnemål, attester, legeerklæring osv.).

I fs-plattform/opptak er dokumenttyper knyttet til opptaket via `opptak.opptakstype_dokumenttype`. I ny løsning knyttes dette direkte til opptaket.

#### Søknadsnummerserie

Opptaksforvalter setter startnummer for søknadsnummerserien. Alle søknader i opptaket får et løpende nummer fra dette startpunktet.

| Egenskap | Beskrivelse |
|----------|-------------|
| **Startnummer** | Første søknadsnummer i serien |

I ny løsning er søknadsnummereringen unik per opptak for å hindre at det blir uklart hvilke søknader man snakker om, og det er ikke lenger nødvendig å passe på at man som opptaksforvalter bruker riktig søkernummerserie.

#### Maks antall søknadsalternativer

Opptaksforvalter setter hvor mange søknadsalternativer (studieønsker) en søker kan prioritere i søknaden sin. Default er 10, men dette kan justeres per opptak.

### Frister og tidsperioder

Frister styrer tidsrammene for opptaket. Alle frister angis som dato (og eventuelt klokkeslett). Noen frister gjelder hele opptaket, andre kan potensielt overstyres per utdanningstilbud (se beslutning 3).

| Frist | Beskrivelse | Nivå |
|-------|-------------|------|
| **Søknadsperiode** | Perioden opptaket er åpent for søknader — fra-dato (når søkere kan begynne å søke) og til-dato (siste tidspunkt for å sende inn søknad). Enkelte utdanningstilbud kan ha en tidligere til-dato enn opptakets generelle frist, f.eks. utdanninger som krever opptaksprøver (Politihøyskolen). | Opptak (til-dato kan overstyres per utdanningstilbud) |
| **Ettersendingsfrist** | Siste tidspunkt søker kan ettersende dokumentasjon. Dokumentasjon mottatt etter fristen er ikke garantert hensyntatt. | Opptak (kan overstyres per utdanningstilbud) |
| **Omprioriteringsfrist** | Siste tidspunkt søker kan endre prioritering av søknadsalternativer. Hvis ikke satt, brukes søknadsfristen. | Opptak |
| **Frist for tidlig tilbud** | Siste tidspunkt søker kan søke om tidlig behandling og tilbud. Kun relevant når tidlig behandling og tilbud er aktivert. | Opptak |
| **Frist for realkompetansesøknad** | Siste tidspunkt for å søke med realkompetanse. Kan ha tidligere frist enn ordinær søknadsfrist fordi realkompetansevurdering krever mer saksbehandlingstid. | Opptak |
| **Svarfrist** | Frist for søker til å svare på tilbud om plass eller venteliste. Når svarfrist utløper uten svar, mister søker tilbudet. Settes per opptaksrunde. | Opptaksrunde |
| **Frist for endring av svar** | Siste tidspunkt søker kan endre et allerede avgitt svar. | Opptak |
| **Trekkfrist for utdanningstilbud** | Siste tidspunkt et lærested kan trekke et utdanningstilbud fra opptaket. Settes av opptakseier (f.eks. HK-dir). | Opptak |
| **Publiseringstidspunkt for tilbud** | Dato og klokkeslett når resultat fra plasstildeling gjøres synlig for søkere. Settes per opptaksrunde. | Opptaksrunde |

#### Interne saksbehandlingsfrister

I tillegg til søkerfrister kan opptaksforvalter sette interne frister som er synlige for saksbehandlere, men ikke for søkere:

| Intern frist | Beskrivelse |
|--------------|-------------|
| **Frist for opptakskomité** | Når opptakskomitéen må ha ferdigvurdert søkere de har ansvar for |
| **Frist for gjennomføring av opptaksprøver** | Når opptaksprøver må være avholdt og resultater registrert |
| **Frist for vurdering av utenlandsk utdanning** | Når vurdering av utenlandsk utdanning må være ferdig |
| **Generell saksbehandlingsfrist** | Påminnelse til saksbehandlere om at søknader må ferdigbehandles innen denne datoen |

I fs-plattform/opptak er dette modellert via opptakshendelser (`opptak.opptakshendelse` + `opptak.opptakshendelsestype`). Hver hendelsestype har en kategori (`opptakshendelsekategori`) som skiller søkerfrister fra interne frister. Hvilke hendelsestyper som er tilgjengelige for et gitt opptak styres via `opptakshendelsestype_opptakstype`.

### Fellestekster

Fellestekster er tekster som vises til søkere i forbindelse med opptaket. Alle tekster lagres på flere språk (bokmål, nynorsk, engelsk — og samisk der det er relevant).

| Tekst | Beskrivelse | Når vises den |
|-------|-------------|---------------|
| **Introtekst** | Innledende informasjon om opptaket som vises på opptakets søknadsside. Typisk: hva opptaket gjelder, viktige datoer, lenker til mer informasjon. | Når søker åpner opptaket for å søke |
| **Beskrivelse** | Utfyllende beskrivelse av opptaket. | I opptaksoversikten og søknadsskjema |
| **Kvitteringstekst** | Tekst som vises etter at søker har sendt inn søknad. Typisk: bekreftelse på mottak, informasjon om videre prosess, kontaktinformasjon. | Etter innsending av søknad |
| **Kvitteringstekst etter avsluttet søknadsperiode** | Tekst som vises hvis søker forsøker å nå opptaket etter at søknadsfristen er utløpt. | Etter søknadsfristens utløp |

I FS-SIS er disse modellert som `INTROTEKST`, `BESKRIVELSE`, `TEKST_KVITTERING` og `TEKST_KVITTERING_AVSL` med suffiks for språk (`_NYNORSK`, `_ENGELSK`).

### Svarmeldingsmal

Når plasstildelingen publiseres, får søkeren en melding om at opptaksvedtaket foreligger i Min kompetanse. Meldingsteksten er ikke en fritekst — den er en **mal med juridisk kjerne** som settes på opptaket.

#### Struktur: fast kjerne + innstillinger fra opptaket + valgfritt tillegg

Malen består av tre lag:

**1. Juridisk kjerne (låst — kan ikke redigeres av lærested eller SO):**

Formuleringer som oppfyller kravene i forvaltningsloven § 27 og eForvaltningsforskriften § 8:

| Krav | Formulering i malen |
|------|---------------------|
| Varsel om enkeltvedtak | «Svaret er et enkeltvedtak etter forvaltningsloven» |
| Begrunnelse tilgjengelig | «med begrunnelse ved å logge deg på Min kompetanse» |
| Klageadgang + hjemmel | «klagerett etter forvaltningslova § 28» |
| Klagefrist | «3 uker fra du fikk tilgang til vedtaket i Min kompetanse» |
| Klageinstans | «det stedet som har behandlet søknaden din» med henvisning til Min kompetanse |
| Fremgangsmåte for klage | Henvisning til nettsidene til saksbehandlingsstedet |

Endring i den juridiske kjernen krever versjonskontroll og godkjenning av jurist. Et lærested skal ikke kunne overskrive denne delen.

**2. Innstillinger fra opptaket (settes automatisk):**

| Parameter | Kilde |
|-----------|-------|
| Opptaksnavn | Opptakets navn (f.eks. «Samordna opptak 2027») |
| Svarfrist | Svarfrist fra opptaksrunden |

Disse er rene datafelt — ikke redigerbar tekst, bare verdier fra opptaket og opptaksrunden.

**3. Tilleggsinformasjon fra lærested/SO (valgfritt):**

Et avgrenset tilleggsfelt som legges etter den juridiske kjernen. Lærestedet eller SO kan legge til ekstra informasjon som gjelder alle søkere i opptaket. Feltet kan ikke overskrive kjerneteksten.

Det er uklart om det finnes et behov for tilleggsinformasjon i samordna opptak for 2027. Informasjon som gjelder enkelte utdanningstilbud må løses et annet sted. Brev til nye studenter kan feks sendes når studierett er tildelt.

#### Eksempel på komplett melding

> Du har fått svar på din søknad om studieplass i **[Samordna opptak 2027]**. Svaret er et enkeltvedtak etter forvaltningsloven. Du finner svaret på din søknad med begrunnelse ved å logge deg på Min kompetanse, og gå til din søknad.
>
> Frist for å svare på tilbud om studieplass eller ventelisteplass er **[DATO]**.
>
> Hvis du mener det er gjort feil i behandlingen av søknaden din, så har du klagerett etter forvaltningslova § 28. Klagefristen er 3 uker fra du fikk tilgang til vedtaket i Min kompetanse.
>
> Du må rette klagen til det stedet som har behandlet søknaden din. Se mer informasjon om hvem som har behandlet søknaden i Min kompetanse og hvordan du klager på nettsidene til Samordna opptak.

#### Forholdet til varsling og vedtaksformidling

Svarmeldingsmalen definerer *hva* som sendes. *Hvordan* meldingen sendes (kanaler, påminnelser, hendelseslogg) er en egen oppgave — se [vedtaksformidling/design.md](../vedtaksformidling/design.md).

### Utdanningstilbud i opptaket

Et opptak må ha minst ett utdanningstilbud for å gi søkere mulighet til å legge søknadsalternativer i søknaden sin. Oppretting, konfigurasjon og tilknytning av utdanningstilbud er en egen oppgave med eget designdokument — se [utdanningstilbud/design.md](../utdanningstilbud/design.md).

**Eierskap:** Opptaksforvalter knytter utdanningstilbud til et opptak fra opptakssiden. På sikt kan det også bli mulig å melde inn utdanninger fra utdanningssiden, men i første omgang er det opptaket som styrer hvilke utdanningstilbud som er med. Opptaksforvalter kan også trekke utdanningstilbud fra opptaket (trekkfrist settes av opptakseier — se frister).

Detaljert design for utdanningstilbud — inkludert konfigurasjon av kapasitet, antall tilbud, antall ja-svar, regelverk, kvoter og andre innstillinger — dekkes i [utdanningstilbud/design.md](../utdanningstilbud/design.md). Se også [plasstildeling/design.md](../plasstildeling/design.md) og [regelverk/design.md](../regelverk/design.md).

---

## Del 3: hva som finnes i dag og hva som gjenstår

### fs-plattform/opptak — hva som finnes

| Konsept                                           | Status                                                 | Merknad |
|---------------------------------------------------|--------------------------------------------------------|---------|
| Opptak med navn og status                         | Finnes                                                 | `opptak.opptak` |
| Opptakstype som mal                               | Finnes, skal utgå                                      | `opptak.opptakstype` — innstillinger flyttes til opptak |
| Samordnet opptak (inviterte organisasjoner)       | Finnes                                                 | `opptak.opptak_samordna_organisasjon` |
| Flerspråklig navn                                 | Finnes                                                 | `opptak.opptak_sprak` |
| Plasstildelingsrunder med svarfrist               | Finnes, men må justeres mht rundetyper med ulik logikk | `opptak.opptaksrunde` |
| Utdanningstilbud                                  | Finnes (v1 + v2)                                       | `opptak.utdanningstilbud_v2` |
| Dokumenttyper                                     | Finnes, knyttet til opptakstype                        | `opptak.opptakstype_dokumenttype` |
| Tidlig behandling og tilbud med begrunnelsestyper | Finnes                                                 | `opptak.tidligopptak_begrunnelsetype` |
| Opptakshendelser                                  | Finnes                                                 | `opptak.opptakshendelse` |

### Hva gjenstår

| Gap | Beskrivelse |
|-----|-------------|
| **Innstillinger på opptaket selv** | I dag ligger mange innstillinger (regelverkssamling, tidlig behandling og tilbud, særskilt vurdering, søkergrupper) på opptakstype. Disse må flyttes til eller dupliseres på opptaksnivå. |
| **Frister** | I fs-plattform/opptak finnes svarfrist og publiseringstidspunkt på opptaksrunde, men de generelle fristene (søknadsfrist, ettersendingsfrist, omprioriteringsfrist, frist tidlig tilbud, frist realkompetanse, frist endring svar) er ikke modellert. I FS-SIS ligger disse direkte på OPPTAK-tabellen. |
| **Fellestekster** | Ikke modellert i fs-plattform/opptak. I FS-SIS er det fire teksttyper med trespråklig støtte på OPPTAK-tabellen. |
| **Søknadsnummerserie** | Ikke modellert i fs-plattform/opptak. |
| **Maks søknadsalternativer** | Ikke modellert i fs-plattform/opptak |
| **Opptaksperiode (fra/til)** | Ikke eksplisitt modellert i fs-plattform/opptak. I FS-SIS er dette `DATO_FRA` / `DATO_TIL`. |
| **Kopiering fra tidligere opptak** | Ikke implementert. |
| **Dokumenttyper på opptaksnivå** | I dag knyttet til opptakstype, må flyttes til opptak. |
| **Standard poenglikhetsregel på opptak** | Poenglikhetsregel finnes i dag på rangeringsregelverk. Skal flyttes til opptaket. |
| **Trekkfrist for utdanningstilbud** | Ikke modellert i fs-plattform/opptak. Ny frist. |

---

## Del 4: åpne spørsmål

### Må avklares før publisering

1. **Validering ved publisering: hva skal kreves?** Forslag: et opptak må ha navn, opptaksperiode, minst ett utdanningstilbud og søknadsfrist for å kunne publiseres. Andre krav?

2. **Fellestekster: er fire teksttyper tilstrekkelig?** FS-SIS har fire (intro, beskrivelse, kvittering, kvittering-avsluttet). Er det behov for flere i ny løsning, f.eks. tekst for venteliste, tekst for avslag, eller tekst for tidlig tilbud?

### Kan ligge til senere

3. **Skal søkergrupper modelleres som flervalg eller som én forhåndsdefinert profil?** I FS-dokumentasjonen beskrives søkergrupper som diskrete grupper (nordisk, EU/EØS, hele verden). I ny løsning kan det være enklere med en kombinasjon av egenskaper (geografi + studentstatus + invitasjon). Ikke nødvendig nå, fordi alle skal kunne søke i samordna opptak.

4. **Hva skjer med løpende opptak?** Opptak uten fast sluttdato (søknader behandles fortløpende) er relevant for emneopptak og kurs, men er utsatt (se beslutning 4). Skal opptaksperioden likevel støtte «ingen til-dato»?

5. **Kopiering: hva kopieres og hva kopieres ikke?** Forslag: innstillinger, frister og fellestekster kopieres. Utdanningstilbud, inviterte læresteder og opptaksrunder kopieres ikke.

### Avklart

- ~~**Skal frister ha klokkeslett?**~~ Ja. Frister i fs-plattform/opptak lagres som full timestamp med tidssone (f.eks. `SØKNADSFRIST_ORDINÆR`, `SØKNADSFRIST_TIDLIG_OPPTAK`). Klokkeslett er eksplisitt.
