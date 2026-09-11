# Vedtaksformidling

Når plasstildelingen publiseres, skal søker varsles om at opptaksvedtaket foreligger i Min kompetanse. Denne oppgaven handler om *hvordan* meldingen sendes, ikke *hva* den inneholder — svarmeldingsmalen defineres på opptaket (se [opptak/design.md](../opptak/design.md)).

**Status:** første utkast, 2026-09-11. Bygger på notat «Vedtaksbrev og svar på opptaket» av Karen Skadsheim Sikkeland.

---

**Tre beslutninger bør leses før resten. Én er tatt. To er åpne.**

1. **SMS/e-post er påkrevd kanal for varsel som peker til Min kompetanse.** Søker får en melding om at vedtaket foreligger, ikke selve vedtaket i meldingen. Vedtaket leses i Min kompetanse. Dette er tatt.

2. **Skal DPI-PDF sendes til digital postkasse?** Digitaliseringsrundskrivet pålegger offentlige etater å bruke digital postkasse for viktig informasjon og vedtak. Samtidig er det mange store etater (Skatt, NAV, Lånekassen) som i praksis ikke gjør det for vedtak formidlet i egne digitale flater. DPI-PDF vil generere vesentlige kostnader og potensielt støy for søkere. Må avklares med jurist, men trenger ikke avklares for 2027.

3. **Hva med søkere uten digital postkasse?** Det er uklart om det er krav til å liste ut søkere som ikke har digital postkasse for å sende brev i posten. I så fall er dette samordna opptak / lærestedets ansvar, ikke Sikts ansvar som utvikler og leverandør av FS. Må avklares.

---

## Del 1: mål og retning

### Hva dette er, og hva det ikke er

Med vedtaksformidling mener vi prosessen fra plasstildelingen publiseres til søkeren har fått melding og tilgang til vedtaket i Min kompetanse. Det er noe annet enn selve svarmeldingsmalen (som settes på opptaket) og noe annet enn plasstildelingen (som beregner hvem som får plass).

| | Svarmeldingsmal | Vedtaksformidling | Plasstildeling |
|---|---|---|---|
| **Spørsmålet** | hva skal stå i meldingen? | hvordan når meldingen søkeren? | hvem får plassene? |
| **Skjer** | settes ved oppretting av opptak | trigges av publisering | som en kjøring, per runde |
| **Eier** | opptaksforvalter + jurist | systemet | opptaksleder |
| **Dekkes her** | nei — se [opptak/design.md](../opptak/design.md) | ja | nei — se [plasstildeling/design.md](../plasstildeling/design.md) |

### Mål

- Søker skal varsles om at vedtaket foreligger i Min kompetanse, slik at svarfrist og klagefrist kan begynne å løpe.
- Varsling skal oppfylle kravene i forvaltningsloven § 27 og eForvaltningsforskriften § 8.
- Søkere som ikke har åpnet vedtaket innen én uke skal få påminnelse (påkrevd etter eForvaltningsforskriften § 8).
- Hele varslingskjeden skal dokumenteres i en hendelseslogg som kan brukes ved klager.

### Ikke-mål

- **Ikke svarmeldingsmalens innhold.** Det er dekket i [opptak/design.md](../opptak/design.md).
- **Ikke digital postkasse i 2027.** Avklares separat (se beslutning 2).
- **Ikke informasjon per utdanningstilbud.** Meldingen gjelder hele søknaden, ikke enkeltutdanninger.

---

## Del 2: varsling

### Trigger

Vedtaksformidling trigges av at en plasstildeling publiseres til søker. Alle søkere som har fått et nytt resultat (tilbud, venteliste eller avslag) i denne publiseringen skal varsles.

### Kanaler

**Påkrevde kanaler:**

| Kanal | Innhold | Merknad |
|-------|---------|---------|
| **SMS** | Kort melding om at vedtak foreligger i Min kompetanse | Sendes til registrert mobilnummer |
| **E-post** | Samme budskap, med lenke til Min kompetanse | Sendes til registrert e-postadresse |

SMS og e-post sender *ikke* selve vedtaket — bare et varsel som peker til Min kompetanse.

**Mulig fremtidig kanal:**

| Kanal | Innhold | Merknad |
|-------|---------|---------|
| **DPI-PDF til digital postkasse** | Vedtaksbrev som PDF | Avklares med jurist. Potensielt vesentlige kostnader. Behov for å dele svarmelding med NAV eller arbeidsgiver finnes, men kan løses annerledes. |

Sikt kan ønske en policy om å *ikke* sende DPI-PDF fordi det koster mye penger. Må avklares, men ikke for 2027.

### Påminnelse

Søkere som ikke har åpnet vedtaket i Min kompetanse innen **én uke** etter første varsel, skal få en ny melding (påkrevd etter eForvaltningsforskriften § 8). Påminnelsen sendes via samme kanaler som det opprinnelige varselet.

### Registrering av åpningstidspunkt

FS må registrere når søkeren faktisk åpner vedtaket i Min kompetanse. Dette tidspunktet er juridisk viktig fordi:

- **Klagefristen** (3 uker) begynner å løpe fra dette tidspunktet.
- **Svarfristen** kan også knyttes til dette tidspunktet.

Åpning av vedtaket skal skilles fra bare «logget inn i Min kompetanse» — det er den konkrete handlingen å åpne vedtaket som teller.

Hvis søkeren aldri åpner vedtaket, må vi dokumentere at søker likevel fikk to varsler. Etter en gitt periode legges det normalt til grunn at vedkommende har fått varselet, selv uten bekreftet åpning.

---

## Del 3: hendelseslogg

Hendelsesloggen skal dekke informasjonsbehovet til læresteder og SO hvis det oppstår en klagesak der en søker hevder å ikke ha blitt korrekt varslet.

### Krav til hendelsesloggen

Loggen må kunne svare på følgende spørsmål:

#### Vedtaket og tilgjengeliggjøring

| Hendelse | Hva registreres |
|----------|-----------------|
| Vedtak fattet | Tidspunkt (generert av systemet eller registrert av saksbehandler) |
| Vedtak tilgjengeliggjort i Min kompetanse | Tidspunkt — dette er starten på «kommet frem»-vurderingen |
| Versjon av svartekst | Hvilken versjon/mal av svarteksten som ble brukt, slik at vi kan vise hva som faktisk stod i vedtaket |
| Saksbehandlerinstans/klageinstans | Hvilken instans som var registrert på søknaden da varselet ble sendt |

#### Varsling

| Hendelse | Hva registreres |
|----------|-----------------|
| SMS sendt | Tidspunkt og mobilnummer |
| E-post sendt | Tidspunkt og e-postadresse |
| Leveringsstatus | Om varselet ble levert eller feilet (f.eks. ugyldig nummer) |
| DPI-PDF sendt (hvis aktuelt) | Tidspunkt og bekreftelse fra DPI |
| Påminnelse sendt | Tidspunkt, etter at søker ikke har åpnet vedtaket innen én uke |

#### Søkerens tilgang

| Hendelse | Hva registreres |
|----------|-----------------|
| Søker åpnet vedtaket | Tidspunkt — utløser klagefrist |
| Søker har aldri åpnet vedtaket | Dokumentasjon på at to varsler er sendt |

#### Endringer etter varsling

| Hendelse | Hva registreres |
|----------|-----------------|
| Klageinstans endret etter varsling | Gammel og ny verdi, slik at vi kan vise hva søkeren så |
| Aktør bak hendelsen | System eller bruker — nyttig for feilsøking |

### Scope og avgrensning for 2027

Det er uklart om kravet til DPI-PDF og hendelseslogg for digital postkasse gjelder alle opptak eller bare samordna opptak. Opptak til emner og undervisning har hatt unntak siden 2013.

For 2027 er minimumskravet:
- SMS/e-post-varsling ved publisering
- Påminnelse etter én uke
- Registrering av åpningstidspunkt i Min kompetanse
- Hendelseslogg for de tre punktene over

DPI-PDF, fysisk brev, og utvidet hendelseslogg kan vente.

---

## Del 4: åpne spørsmål

1. **DPI-PDF: skal det sendes, og hvem betaler?** Digitaliseringsrundskrivet er klart, men praksis blant store etater avviker. Må avklares med jurist. Sikt kan ønske en policy. Kan vente til 2027.

2. **Fysisk brev til søkere uten digital postkasse:** Er dette lærestedets/SOs ansvar, eller skal FS støtte utsending? Trolig er SMS/e-post god nok dekning i juridisk forstand.

3. **Gjelder kravet alle opptak?** Opptak til emner og undervisning har hatt unntak. Må avklares.

4. **Saksbehandlerinstansens klageinformasjon:** Bør det legges inn URL til klageinformasjonssidene per organisasjon, slik at søker i Min kompetanse kan navigere direkte? Nyttig, men ikke strengt nødvendig for 2027.

5. **Tilleggsinformasjon per utdanningstilbud i meldingen:** Hvis et lærested vil gi informasjon til søkere om et spesifikt utdanningstilbud (f.eks. velkomstinformasjon ved tilbud), må det løses et annet sted enn svarmeldingsmalen som gjelder hele opptaket.