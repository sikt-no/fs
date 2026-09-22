# Opprette og vedlikeholde opptak

*Designfilen gir en teknisk-funksjonell beskrivelse av et konsept: hvordan det er ment å fungere, hvilke beslutninger som er tatt, hvor data kommer fra og hva som gjenstår. Den er skrevet for å skape forståelse på tvers av roller. Den svarer på hva og hvorfor — ikke på hvordan noe skal implementeres eller se ut.*

Opptaksforvalter skal kunne opprette og forvalte opptak med alle innstillinger som styrer hvem som kan søke, hvilke frister som gjelder, og hva søkeren ser. Mye av dette finnes allerede i fs-plattform/opptak, men innstillingene er i dag spredt mellom opptakstype og opptak. Dette dokumentet beskriver hva løsningen skal gjøre, hvilke valg som er tatt, og hvilke spørsmål som gjenstår.

Dokumentet er skrevet for alle som trenger å forstå hva det vil si å opprette et opptak, hvordan samordning fungerer, og hvilke innstillinger som må settes. Funksjonell løsning per oppgave og tekniske detaljer ligger i [oppgave.md](oppgave.md).

**Status:** oppdatert 2026-09-22. Bygger på gjennomgang av databasen i fs-plattform/opptak (PostgreSQL), FS-SIS (Oracle, OPPTAK-tabellen), domenedokumentasjon fra fs.sikt.no, arkitekturbeslutningen [«Referensiell integritet på tvers av subgrafer»](https://fs.sikt.no/utviklerhandbok/produsent/referensiell-integritet/), og veiledningen [«Replikering utdanningsregisteret til opptak»](https://fs.sikt.no/utviklerhandbok/produsent/veiledninger/kom-i-gang-med-logisk-replikering/replikering-utdanningsregisteret-til-opptak/).

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

Kun organisasjoner som finnes i utdanningsregisteret kan legges til som deltakere i et samordnet opptak. Når opptaksforvalter ved forvaltende organisasjon legger til et lærested, innebærer det at lærestedet kan:

- Knytte egne utdanningstilbud til opptaket.
- Få søknader som de har behandlerrolle for.
- Vedlikeholde informasjon på egne utdanningstilbud.
- Se informasjon om egne utdanningstilbud (saksbehandlere og opptaksforvaltere).

Det er kun organisasjonen som forvalter opptaket som kan endre innstillinger — deltakende organisasjoner kan se, men ikke endre frister, regelverk eller andre innstillinger.

**Organisasjoner fra utdanningsregisteret:** Organisasjonsdata eies av utdanningsregisteret (ureg). Opptak abonnerer på organisasjonstabellen via Postgres logisk replikering. Replikerte kolonner er `organisasjonskode` og `navn_original` fra `organisasjon.organisasjon`, samt campus- og termindata. `opptak.opptak_samordna_organisasjon` har fremmednøkkel mot den replikerte tabellen, noe som gir en databasegaranti for at opptak kun kan referere til organisasjoner som faktisk finnes i ureg. Se [«Referensiell integritet på tvers av subgrafer»](https://fs.sikt.no/utviklerhandbok/produsent/referensiell-integritet/) og [veiledning for replikering fra ureg til opptak](https://fs.sikt.no/utviklerhandbok/produsent/veiledninger/kom-i-gang-med-logisk-replikering/replikering-utdanningsregisteret-til-opptak/).

Samme mønster gjelder for utdanningstilbud — se [utdanningstilbud/design.md](../utdanningstilbud/design.md) beslutning 4.

### Obligatoriske felter ved oppretting

| Egenskap | Beskrivelse | Påkrevd |
|----------|-------------|---------|
| **Navn** | Opptakets navn, vises for saksbehandlere og søkere. Flerspråklig (bokmål, nynorsk, engelsk, samisk). | Ja |
| **Regelverkssamling** | Regelverket som styrer kompetansekrav, rangering og kvotetyper i opptaket. | Ja |
| **Opptakstype** | Kategoriserer opptaket (f.eks. UHG, HYU, master, emne/kurs). Fast kodeverk, ikke opprettet av bruker. | Ja |

### Innstillinger

#### Regelverkssamling

Opptaket kobles til en regelverkssamling som bestemmer kompetansekrav, rangeringsregelverk og kvotetyper. Regelverkssamlingen forvaltes separat (se [regelverk/design.md](../regelverk/design.md)) og kobles til opptaket ved oppretting.

Utdanningstilbud i opptaket kan kun benytte seg av regelverk og kvotetyper som inngår i opptakets regelverkssamling.

#### Standard poenglikhetsregel

Opptaksforvalter setter standard poenglikhetsregel for opptaket. Denne gjelder for alle utdanningstilbud i opptaket som default. Poenglikhetsreglene som er tilgjengelige er koblet til regelverkssamlingen. Forskriften er ulik mellom opptakstyper:

| Opptakstype                      | Forskriftsfestet regel | Valgfrihet for lærested |
|----------------------------------|----------------------|------------------------|
| UHG (universiteter og høgskoler) | Loddtrekning (fra 2027) | Kan velge «alle med lik sum får tilbud» per utdanningstilbud |
| Fagskole (HYU)                   | Rangering etter alder | Ingen (forskriftsfestet) |
| Ledige studieplasser (rundetype) | Tidspunkt for levert søknad | — |

Poenglikhetsregelen er flyttet fra rangeringsregelverket til opptaket fordi den gjelder per opptak, ikke per regelverk. Opptaksforvalter kan angi om utdanningstilbud kan velge en annen tilgjengelig regel (UHG) eller om standarden er låst (HYU).

#### Tidlig opptak

Opptaksforvalter velger om opptaket skal støtte tidlig opptak. Når dette er aktivert, kan søkere som oppfyller visse kriterier få svar før hovedfristen. Tidlig opptak krever en egen frist (se frister nedenfor).

#### Utdanningsbakgrunn

Opptaksforvalter kan opprette utdanningsbakgrunner med avvikende frister i opptaket. Utdanningsbakgrunner er ikke hardkodet — opptaksforvalter kan opprette nye etter behov. Eksempler: realkompetanse, utenlandsk utdanning, steinerskole.

Per utdanningsbakgrunn kan man sette avvikende søknads- og dokumentasjonsfrister. Søkere med en utdanningsbakgrunn som har avvikende frister vurderes etter bakgrunnens frister. Utdanningsbakgrunner uten avvikende frister (f.eks. norsk videregående skole) trenger ikke registreres — de følger opptakets generelle frister.

Opptaksforvalter må angi i innstillingene om det er lov å sette avvikende søknadsfrister per utdanningsbakgrunn. Se krav [OPT-OPT-UBG-001](https://github.com/sikt-no/fs/blob/main/krav/02%20Opptak/11%20Opptak/07%20Utdanningsbakgrunn/utdanningsbakgrunn.feature).

#### Ledige studieplasser

Opptaksforvalter kan angi om opptaket tilbyr søknad på ledige studieplasser. Når dette er aktivert, kan restplasser legges ut til søkere for ny søknad etter ordinær plasstildeling. Informasjonsdatoer for når restplasser legges ut og når ledige studieplasser kan søkes settes under frister.

#### Avvikende søknadsfrister

Opptaksforvalter kan angi om det er lov å sette avvikende søknadsfrister per utdanningstilbud og per utdanningsbakgrunn. Når dette er aktivert:
- Opptaksforvalter ved deltakende organisasjon kan sette egne søknadsfrister på sine utdanningstilbud.
- Opptaksforvalter kan opprette utdanningsbakgrunner med egne søknads- og dokumentasjonsfrister.

#### Studierettskrav

Opptaksforvalter kan angi om det kreves studierett for å søke. Ikke relevant for samordna opptak.

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

#### Tak for antall tilbud per tildelingsrunde

Opptaksforvalter kan sette et tak for hvor mange tilbud som kan gis i en enkelt tildelingsrunde.

### Frister og hendelser

Frister styrer tidsrammene for opptaket. Alle frister angis som dato (og eventuelt klokkeslett). Generelle frister gjelder for alle utdanningstilbud og alle søkere, med mindre det er satt avvikende frister på utdanningstilbud eller utdanningsbakgrunn.

| Kategori | Frist | Beskrivelse | Nivå |
|----------|-------|-------------|------|
| **Redigering** | Åpne for redigering av utdanningstilbud | Dato for når deltakende organisasjoner kan knytte, redigere og trekke utdanningstilbud | Opptak |
| **Redigering** | Stenge for redigering av utdanningstilbud | Etter denne datoen kan deltakende organisasjoner ikke lenger redigere, knytte eller trekke utdanningstilbud. Unntak: antall studieplasser kan redigeres fram til første plasstildelingsrunde. Kun forvalter kan trekke etter stengingsdato. | Opptak |
| **Søknad** | Søknadsdato åpner | Når utdanningstilbud blir tilgjengelige for søkere | Opptak |
| **Søknad** | Generell søknadsfrist | Gjelder for alle utdanningstilbud og søkere, med mindre unntaksfrist er satt per utdanningstilbud eller utdanningsbakgrunn | Opptak |
| **Søknad** | Omprioriteringsfrist | Siste tidspunkt søker kan endre prioritering av søknadsalternativer | Opptak |
| **Dokumentasjon** | Ordinær dokumentasjonsfrist | Frist for å laste opp dokumentasjon | Opptak |
| **Dokumentasjon** | Tidlig dokumentasjonsfrist | Gjelder for søkere med tidlig søknadsfrist | Opptak |
| **Dokumentasjon** | Ettersendingsfrist | Siste tidspunkt for ettersending. Dokumentasjon mottatt etter fristen er ikke garantert hensyntatt. | Opptak |
| **Ledige studieplasser** | Informasjonsfrist | Når søkere informeres om at restplasser legges ut | Opptak |
| **Ledige studieplasser** | Åpner for søkning | Når søkere kan søke på ledige studieplasser | Opptak |
| **Resultat** | Forventet svardato | Informasjonsdato — når søker kan forvente svar | Opptak |
| **Resultat** | Første svarfrist | Informasjonsdato — når søker senest må svare. Faktisk svarfrist settes per plasstildelingsrunde. | Opptak |
| **Trekkfrist** | Trekkfrist for utdanningstilbud | Etter denne datoen kan kun forvalter trekke utdanningstilbud. Åpent spørsmål: hard sperre eller informasjonsfrist? | Opptak |
| **Avslutte** | Avslutte opptak | Opptaket stenges for alle endringer og behandling | Opptak |

Avvikende frister per utdanningstilbud og utdanningsbakgrunn settes kun når innstillingen for avvikende søknadsfrister er aktivert.

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

Fellestekster er tekster som vises til søkere i forbindelse med opptaket. Alle tekster lagres på flere språk (bokmål, nynorsk, engelsk og samisk).

| Tekst | Beskrivelse |
|-------|-------------|
| **Prioritering av søknadsalternativer** | Informasjon om hvordan søker prioriterer og hva det betyr |
| **Utdanningsbakgrunn** | Informasjon om hva utdanningsbakgrunn innebærer |
| **Påkrevd dokumentasjon** | Informasjon om hva søker må laste opp |
| **Oppsummeringstekst** | Oppsummering av søknaden for søker |
| **Kvitteringstekst** | Vises etter at søker har sendt inn søknad |

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
| Logisk replikering av organisasjons-entitetstabell | Finnes                                                 | Opptak abonnerer på organisasjonstabellen fra ureg (kun primærnøkkel). Fremmednøkkel fra `opptak.opptak_samordna_organisasjon` sikrer referanseintegritet i databaselaget. |
| Flerspråklig navn                                 | Finnes                                                 | `opptak.opptak_sprak` |
| Plasstildelingsrunder med svarfrist               | Finnes, men må justeres mht rundetyper med ulik logikk | `opptak.opptaksrunde` |
| Utdanningstilbud                                  | Finnes (v1 + v2)                                       | `opptak.utdanningstilbud_v2` |
| Dokumenttyper                                     | Finnes, knyttet til opptakstype                        | `opptak.opptakstype_dokumenttype` |
| Tidlig opptak med begrunnelsestyper               | Finnes                                                 | `opptak.tidligopptak_begrunnelsetype` |
| Opptakshendelser                                  | Finnes                                                 | `opptak.opptakshendelse` |

### Hva gjenstår

| Gap | Beskrivelse |
|-----|-------------|
| **Innstillinger på opptaket selv** | I dag ligger mange innstillinger (regelverkssamling, tidlig opptak, særskilt vurdering, søkergrupper) på opptakstype. Disse må flyttes til eller dupliseres på opptaksnivå. |
| **Frister** | I fs-plattform/opptak finnes svarfrist og publiseringstidspunkt på opptaksrunde, men de generelle fristene (søknadsfrist, ettersendingsfrist, omprioriteringsfrist, frist tidlig opptak, frist realkompetanse, frist endring svar) er ikke modellert. I FS-SIS ligger disse direkte på OPPTAK-tabellen. |
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

1. **Validering ved publisering: hva skal kreves?** Forslag: et opptak må ha navn, minst ett utdanningstilbud og søknadsfrist for å kunne publiseres. Andre krav?

### Kan ligge til senere

2. **Hva skjer med løpende opptak?** Opptak uten fast sluttdato (søknader behandles fortløpende) er relevant for emneopptak og kurs, men er utsatt (se beslutning 4).

3. **Kopiering: hva kopieres og hva kopieres ikke?** Forslag: innstillinger, frister og fellestekster kopieres. Utdanningstilbud, inviterte læresteder og opptaksrunder kopieres ikke.

4. **Trekkfrist for utdanningstilbud: hard sperre eller informasjonsfrist?** I dag kan læresteder trekke egne utdanningstilbud fram til en satt dato. Etter denne datoen kan kun forvalter trekke. Skal vi videreføre denne begrensningen, eller bør det være en forvaltningsfrist uten faktisk stengeeffekt?

### Avklart

- ~~**Skal frister ha klokkeslett?**~~ Ja. Frister i fs-plattform/opptak lagres som full timestamp med tidssone. Klokkeslett er eksplisitt.
- ~~**Fellestekster: er fire teksttyper tilstrekkelig?**~~ Nei. Nye teksttyper: prioritering, utdanningsbakgrunn, dokumentasjon, oppsummering, kvittering.
- ~~**Søkergrupper**~~ Erstattet av utdanningsbakgrunn. Alle kan søke i samordna opptak — begrensning på søkergrupper er ikke nødvendig. Utdanningsbakgrunn styrer avvikende frister, ikke hvem som kan søke.
