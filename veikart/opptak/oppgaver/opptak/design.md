# Opprette og vedlikeholde opptak

Opptaksforvalter skal kunne opprette og forvalte opptak med alle innstillinger som styrer hvem som kan søke, hvilke frister som gjelder, og hva søkeren ser. Mye av dette finnes allerede i fs-plattform/opptak, men innstillingene er i dag spredt mellom opptakstype og opptak. Dette dokumentet beskriver hva løsningen skal gjøre, hvilke valg som er tatt, og hvilke spørsmål som gjenstår.

Dokumentet er skrevet for alle som trenger å forstå hva det vil si å opprette et opptak, hvordan samordning fungerer, og hvilke innstillinger som må settes. Funksjonell løsning per oppgave og tekniske detaljer ligger i [oppgave.md](oppgave.md).

**Status:** første utkast, 2026-09-11. Bygger på gjennomgang av databasen i fs-plattform/opptak (PostgreSQL), FS-SIS (Oracle, OPPTAK-tabellen), og domenedokumentasjon fra fs.sikt.no.

---

**Fire beslutninger bør leses før resten, fordi alt annet følger av dem. To er tatt. To er åpne.**

1. **Opptakstype som eget konsept utgår.** I dag arver et opptak innstillinger fra en opptakstype (UHG, FSU, lokalt osv.). I ny løsning oppretter man bare et opptak. Om opptaket er samordnet eller lokalt fremgår av om flere læresteder deltar. Innstillinger som i dag ligger på opptakstype flyttes til opptaket selv. Dette er tatt: vi forenkler modellen og fjerner et mellomnivå som skaper forvirring.

2. **Samordning er en egenskap ved opptaket, ikke en type.** Et opptak blir samordnet ved at opptakseier inviterer andre læresteder til å delta med utdanningstilbud og saksbehandlere. Et opptak uten inviterte læresteder er lokalt. Det finnes ikke en separat «samordnet»-bryter — samordning fremgår av deltakerne. Dette er tatt.

3. **Enkelte utdanningstilbud trenger strengere søknadsfrist enn opptakets generelle frist.** Noen utdanninger (f.eks. Politihøyskolen) har tidlig søknadsfrist fordi de krever opptaksprøver eller annen tilleggsvurdering som tar tid. I ny løsning må det være mulig å sette en tidligere søknadsfrist per utdanningstilbud. Forslag: søknadsperiode (med tidligere til-dato) og ettersendingsfrist kan overstyres per utdanningstilbud; andre frister gjelder alltid for hele opptaket.

4. **Skal innstillinger for emneopptak, kurs og undervisningsopptak dekkes nå?** Disse opptakstypene har spesielle behov (løpende opptak, tilgang kun for egne studenter, ingen rangering). De er ikke hovedfokus og bør utsettes til egne oppgaver. Forslag: design for disse legges i egne dokumenter når behovet oppstår.

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
- Utdanningstilbud skal kunne knyttes til opptaket, med mulighet for å arve eller overstyre innstillinger.
- Opptaket skal kunne publiseres og gjøres søkbart for søkere.
- Plasstildelingsrunder skal kunne registreres etter at opptaket er publisert (løses som del av plasstildeling)

### Ikke-mål

- **Ikke søknadsbehandling.** Vurdering av søkere er dekket andre steder.
- **Ikke plasstildeling.** Fordeling av plasser er dekket i [plasstildeling/design.md](../plasstildeling/design.md).
- **Ikke regelverksforvaltning.** Oppretting og vedlikehold av regelverkssamlinger er dekket i [regelverk/design.md](../regelverk/design.md). Her kobles en eksisterende samling til opptaket.
- **Ikke emneopptak, kurs eller undervisningsopptak.** Disse har spesielle behov som utsettes (se beslutning 4).
- **Ikke søkerens opplevelse.** Hvordan søkeren ser opptaket og søker er et eget domene.

---

## Del 2: løsningen

### Opprette et opptak

Et opptak opprettes av en opptaksforvalter ved å velge om det skal være samordnet eller lokalt. Valget avgjør om andre læresteder kan inviteres til å delta.

**Samordnet opptak:** Opptakseier (typisk Samordna opptak / HK-dir) oppretter opptaket og inviterer læresteder til å delta. Hvert invitert lærested bidrar med utdanningstilbud og saksbehandlere. Opptakseier setter felles innstillinger, frister og regelverk.

**Lokalt opptak:** Et enkelt lærested oppretter opptaket for sine egne utdanningstilbud. Alle innstillinger settes av lærestedet selv.

I begge tilfeller er resultatet et opptak med de samme egenskapene — forskjellen er bare antall deltakende organisasjoner.

**Kopiering fra tidligere opptak:** Det skal være mulig å opprette et nytt opptak basert på et tidligere opptak, slik at innstillinger, frister og fellestekster kopieres som utgangspunkt.

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

Opptaksperioden styrer når opptaket er synlig og tilgjengelig — ikke når søkere kan sende inn søknader (det styres av søknadsfristen).

### Innstillinger

#### Regelverkssamling

Opptaket kobles til en regelverkssamling som bestemmer kompetansekrav, rangeringsregelverk, kvotetyper og poenglikhetsregel. Regelverkssamlingen forvaltes separat (se [regelverk/design.md](../regelverk/design.md)) og kobles til opptaket ved oppretting.

Et utdanningstilbud i opptaket arver regelverkssamlingen fra opptaket, men kan overstyre med en annen samling dersom det har avvikende regler.

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

#### Dokumentasjonsopplasting

Opptaksforvalter velger om søkere skal kunne laste opp dokumentasjon som del av søknaden. Når dette er aktivert, defineres hvilke dokumenttyper som aksepteres (vitnemål, attester, legeerklæring osv.).

I fs-plattform/opptak er dokumenttyper knyttet til opptaket via `opptak.opptakstype_dokumenttype`. I ny løsning knyttes dette direkte til opptaket.

#### Søknadsnummerserie

Opptaksforvalter setter startnummer for søknadsnummerserien. Alle søknader i opptaket får et løpende nummer fra dette startpunktet.

| Egenskap | Beskrivelse |
|----------|-------------|
| **Startnummer** | Første søknadsnummer i serien |
| **Sluttnummer** (valgfritt) | Tak for serien — hindrer at nummerserier fra ulike opptak overlapper |

I ny løsning er søknadsnummereringen trolig unik per opptak for å hindre at det blir uklart hvilke søknader man snakker om — må verifiseres.

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

### Utdanningstilbud i opptaket

Et opptak må ha minst ett utdanningstilbud for å gi søkere mulighet til å legge søknadsalternativer i søknaden sin. Oppretting, konfigurasjon og tilknytning av utdanningstilbud er en egen oppgave med eget designdokument — se [utdanningstilbud/design.md](../utdanningstilbud/design.md).

**Hypotese om eierskap:** Det er utdanningstilbudet som forteller at det skal være med i et opptak, ikke opptaket som «henter inn» utdanningstilbud. Lærestedet knytter sine utdanningstilbud til et opptak fra utdanningstilbudsiden. Fra opptakssiden skal det være mulig å se hvilke utdanningstilbud som er med, og det bør også være mulig å legge til utdanningstilbud derfra som en snarvei.

Detaljert design for utdanningstilbud — inkludert konfigurasjon av kapasitet, antall tilbud, antall ja-svar, regelverk, kvoter og andre innstillinger — dekkes i [utdanningstilbud/design.md](../utdanningstilbud/design.md). Se også [plasstildeling/design.md](../plasstildeling/design.md) og [regelverk/design.md](../regelverk/design.md).

---

## Del 3: hva som finnes i dag og hva som gjenstår

### fs-plattform/opptak — hva som finnes

| Konsept | Status | Merknad |
|---------|--------|---------|
| Opptak med navn og status | Finnes | `opptak.opptak` |
| Opptakstype som mal | Finnes, skal utgå | `opptak.opptakstype` — innstillinger flyttes til opptak |
| Samordnet opptak (inviterte organisasjoner) | Finnes | `opptak.opptak_samordna_organisasjon` |
| Flerspråklig navn | Finnes | `opptak.opptak_sprak` |
| Opptaksrunder med svarfrist | Finnes | `opptak.opptaksrunde` |
| Utdanningstilbud | Finnes (v1 + v2) | `opptak.utdanningstilbud_v2` |
| Dokumenttyper | Finnes, knyttet til opptakstype | `opptak.opptakstype_dokumenttype` |
| Tidlig behandling og tilbud med begrunnelsestyper | Finnes | `opptak.tidligopptak_begrunnelsetype` |
| Opptakshendelser | Finnes | `opptak.opptakshendelse` |

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

---

## Del 4: åpne spørsmål

1. **Skal søkergrupper modelleres som flervalg eller som én forhåndsdefinert profil?** I FS-dokumentasjonen beskrives søkergrupper som diskrete grupper (nordisk, EU/EØS, hele verden). I ny løsning kan det være enklere med en kombinasjon av egenskaper (geografi + studentstatus + invitasjon). Må avklares - ikke nødvendig nå, fordi alle skal kunne søke i samordna opptak.

2. **Skal frister ha klokkeslett?** I FS-SIS er frister datoer uten klokkeslett (implisitt 23:59). I ny løsning kan det være behov for eksplisitt klokkeslett, f.eks. for å publisere tilbud klokken 09:00.

3. **Hva skjer med løpende opptak?** Opptak uten fast sluttdato (søknader behandles fortløpende) er relevant for emneopptak og kurs, men er utsatt (se beslutning 4). Skal opptaksperioden likevel støtte «ingen til-dato»?

4. **Kopiering: hva kopieres og hva kopieres ikke?** Forslag: innstillinger, frister og fellestekster kopieres. Utdanningstilbud, inviterte læresteder og opptaksrunder kopieres ikke. Må avklares.

5. **Validering ved publisering: hva skal kreves?** Forslag: et opptak må ha navn, opptaksperiode, minst ett utdanningstilbud og søknadsfrist for å kunne publiseres. Andre krav?

6. **Fellestekster: er fire teksttyper tilstrekkelig?** FS-SIS har fire (intro, beskrivelse, kvittering, kvittering-avsluttet). Er det behov for flere i ny løsning, f.eks. tekst for venteliste, tekst for avslag, eller tekst for tidlig tilbud?