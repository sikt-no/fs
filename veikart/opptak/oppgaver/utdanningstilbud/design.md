# Utdanningstilbud i opptak

*Designfilen gir en teknisk-funksjonell beskrivelse av et konsept: hvordan det er ment å fungere, hvilke beslutninger som er tatt, hvor data kommer fra og hva som gjenstår. Den er skrevet for å skape forståelse på tvers av roller. Den svarer på hva og hvorfor — ikke på hvordan noe skal implementeres eller se ut.*

Et utdanningstilbud er en utdanning som er gjort søkbar i et opptak. Utdanningstilbudet opprettes ikke fra bunnen av — det bygger på autoritative data fra utdanningsregisteret og berikes med opptaksspesifikke innstillinger. Dette dokumentet beskriver hvordan utdanningstilbud hentes fra utdanningsregisteret, hva som arves og hva som settes av opptaksforvalter.

**Status:** oppdatert 2026-09-14. Bygger på gjennomgang av fs-plattform/opptak-databasen, domenedokumentasjon fra fs.sikt.no, og arkitekturbeslutningen [«Denormalisering av data fra Utdanningsregisteret»](https://sikt.atlassian.net/wiki/spaces/PFS/pages/4271898626).

---

**Tre beslutninger er tatt og skal leses før resten.**

1. **Utdanningstilbudet bygger på autoritativ kilde.** Grunnlagsdata (navn, studiepoeng, varighet, studienivå, campus, undervisningsspråk) hentes fra utdanningsregisteret og skal ikke registreres på nytt i opptaket. Opptaksforvalteren setter bare opptaksspesifikke egenskaper (kapasitet, tilbud som skal gis, tak for ja-svar og eventuelle lovlige unntak fra standardinnstillinger i opptaket).

2. **Opptak legger til utdanningstilbud.** Opptaksforvalter knytter utdanningstilbud til et opptak fra opptakssiden. På sikt kan det også bli mulig å melde inn utdanninger fra utdanningssiden, men i første omgang er det opptaket som styrer hvilke utdanningstilbud som er med.

3. **Federation er normalmodellen — denormalisering er kun for søk.** Opptak holder bare en referanse-ID til tilhørende entiteter i utdanningsregisteret (ureg). Når en bruker åpner en side som trenger data fra begge systemene (f.eks. rangeringsregelverk fra opptak og navn fra ureg), henter supergrafen automatisk riktig del fra riktig system og setter det sammen. Denormalisering — det vil si å ta en kopi av utvalgte felter fra ureg og lagre dem i opptaks-databasen — gjøres **kun** for felter som trengs i søk, filtrering og sortering. Grunnen er ytelse: uten en lokal kopi måtte opptaket spørre ureg for hvert eneste utdanningstilbud ved hvert søk. Alt som bare skal *vises* (ikke søkes i) hentes direkte fra ureg når brukeren trenger det. Se [arkitekturbeslutningen i Confluence](https://sikt.atlassian.net/wiki/spaces/PFS/pages/4271898626).

---

## Del 1: mål og retning

### Hva dette er, og hva det ikke er

Med utdanningstilbud mener vi koblingen mellom en konkret utdanning (fra utdanningsregisteret) og et opptak, beriket med opptaksspesifikke innstillinger. Det er noe annet enn selve utdanningen (som eies av utdanningsregisteret) og noe annet enn opptaket (som er rammen rundt).

| | Utdanningsregisteret                         | Utdanningstilbud i opptak | Opptak |
|---|----------------------------------------------|---|---|
| **Spørsmålet** | hva tilbys, hvor og når?                     | hva er opptaksbetingelsene for denne utdanningen? | hva er rammene for opptaket? |
| **Eier** | lærested (via FS-SIS eller eget grensesnitt) | lærested (opptaksspesifikke innstillinger) | opptaksforvalter |
| **Dekkes her** | nei                                          | ja | nei — se [opptak/design.md](../opptak/design.md) |

### Mål

- Utdanningstilbud skal opprettes med utgangspunkt i utdanninger som finnes og er aktive i utdanningsregisteret.
- Grunnlagsdata (navn, studiepoeng, varighet, nivå, campus...) skal hentes fra utdanningsregisteret og ikke kunne overstyres i opptaket.
- Opptaksspesifikke innstillinger (kapasitet, tilbud som skal gis, tak for ja-svar og eventuelle lovlige unntak fra standardinnstillinger i opptaket) settes av lærestedet per utdanningstilbud.
- Det skal være mulig å se alle utdanningstilbud i et opptak fra opptakssiden.
- Opptak må få med seg nødvendige endringer som skjer på utdanningene. 

### Ikke-mål

- **Ikke forvaltning av selve utdanningen.** Endringer i navn, studiepoeng, varighet osv. gjøres i utdanningsregisteret, ikke i opptaket.
- **Ikke oppretting av opptak.** Dekket i [opptak/design.md](../opptak/design.md).
- **Ikke plasstildeling.** Dekket i [plasstildeling/design.md](../plasstildeling/design.md).

---

## Del 2: utdanningsregisteret og tre-nivå-modellen

### Tre nivåer av utdanningsdata

Utdanningsregisteret organiserer utdanningsdata i tre hierarkiske nivåer:

```
Utdanningsspesifikasjon          «Hva tilbys?»
  └── Utdanningsmulighet         «Hvor og hvordan?»
        └── Utdanningsinstans    «Når og ved hvilket campus?»
```

| Nivå | Beskrivelse | Eksempel |
|------|-------------|---------|
| **Utdanningsspesifikasjon** | Grunnlagsdata og beskrivelse av en utdanning: innhold, omfang, nivå. Tre typer: studieprogram, emne, etterutdanning. | «Master i informatikk, 120 studiepoeng» |
| **Utdanningsmulighet** | Utdanningen knyttet til lærestedet som tilbyr den, med informasjon om organisering (heltid/deltid, norsk/engelsk). | «Master i informatikk ved UiO, heltid» |
| **Utdanningsinstans** | Når og hvor en gitt utdanning tilbys av et gitt lærested. Ny instans for hvert semester. | «Master i informatikk ved UiO, fra høst 2027, Oslo campus» |

**Opptak kobler seg til utdanningsinstansnivået** — det mest konkrete nivået. En person søker seg opp til en utdanning som tilbys av et lærested ett gitt sted til en gitt studiestart.

### Dataflyt og federation

Opptak og utdanningsregisteret (ureg) er to separate subgrafer i en GraphQL federation. Supergrafen (routeren) sitter mellom klienten og subgrafene og ruter spørringer til riktig subgraf:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Klient    │────▶│   Router    │────▶│   Opptak    │
└─────────────┘     └──────┬──────┘     └─────────────┘
                           │
                           ▼
                    ┌─────────────┐
                    │    Ureg     │
                    └─────────────┘
```

Opptak eier `Utdanningstilbud`-typen og holder en referanse (graf-ID) til `Utdanningsinstans` i ureg. Når en klient spør etter felter fra begge subgrafene, splitter routeren spørringen automatisk. Opptak trenger ikke kjenne til ureg-feltene — kun nøkkelen.

**Denormalisering for søk:** Unntaket er søk og filtrering. For å kunne tilby et effektivt søk i utdanningstilbud uten å sende en ekstra spørring til ureg for hvert tilbud, kopierer opptak et begrenset sett felter fra ureg inn i sin søkeindeks. Disse denormaliserte feltene brukes **kun** til søk, filtrering og sortering — de returneres ikke til klienten. Søket returnerer IDer, og klienten henter visningsdata via federation.

Denormaliserte data holdes i synk via hendelser fra ureg og fs-batch-infrastrukturen.

**Flyten for å opprette et utdanningstilbud:**

1. Lærestedet registrerer utdanningen i utdanningsregisteret (via SIS-integrasjon eller eget grensesnitt i FS Admin).
2. Opptak mottar graf-IDen til utdanningsinstansen (via synkronisering/hendelser).
3. Lærestedet knytter utdanningsinstansen til et opptak — et utdanningstilbud opprettes.
4. Lærestedet setter opptaksspesifikke innstillinger (kapasitet, tilbud som skal gis, tak for ja-svar og eventuelle lovlige unntak fra standardinnstillinger i opptaket).

### Registrering av utdanninger — 2027

For samordna opptak 2027 er det to ulike situasjoner:

**Universiteter og høyskoler:** Alle UH-læresteder som er med i samordna opptak bruker FS-SIS, som har integrasjon mot utdanningsregisteret. Utdanninger opprettes i FS-SIS og overføres automatisk til utdanningsregisteret.

**Fagskoler:** Fagskolenes SIS-er integrerer ikke mot utdanningsregisteret. For 2027-opptaket vil fagskolene registrere sine utdanninger i et **eget grensesnitt direkte mot utdanningsregisteret**. Se [studieprogram/design.md](../../../utdanning/oppgaver/studieprogram/design.md) for design av dette grensesnittet.

---

## Del 3: hva som arves og hva som settes

### Autoritative data fra utdanningsregisteret (arves, kan ikke overstyres)

Alle disse feltene eies av utdanningsregisteret. Opptak lagrer dem **ikke** — de hentes via federation når klienten ber om dem. Unntaket er felter som trengs i søkeindeksen (merket med «denormalisert»), som kopieres inn i opptaks-databasen utelukkende for søk/filtrering/sortering.

| Felt                      | Kilde i utdanningsregisteret | Denormalisert for søk |
|---------------------------|------------------------------|----------------------|
| Navn                      | Utdanningsspesifikasjon | ja (`studieprogram_navn`) |
| Studiepoeng / omfang      | Utdanningsspesifikasjon | nei |
| Varighet                  | Utdanningsmulighet | nei |
| Studienivå (NKR)          | Utdanningsspesifikasjon | ja (`utdanningsmulighet_niva_koder`) |
| Fagområde (NUS)           | Utdanningsspesifikasjon | ja (`fagomrade_koder`) |
| Undervisningsspråk        | Utdanningsmulighet | nei |
| Prosent av fulltid        | Utdanningsmulighet | ja (`prosentandel_av_fulltid`) |
| Undervisningstype         | Utdanningsmulighet | ja (`undervisningstyper`) |
| Campus / studiested       | Utdanningsinstans | ja (`campus_ekstern_id`) |
| Oppstartstermin/tidspunkt | Utdanningsinstans | ja (`terminkode_fra`) |
| Lærested (organisasjon)   | Utdanningsmulighet | ja (`organisasjon_ekstern_id`) |

**Tommelfingerregel:** denormaliser kun felter som brukes til søk, filtrering eller sortering. Alt annet hentes via federation. Søket returnerer kun IDer — visningsdata løses av routeren.

### Opptaksspesifikke innstillinger (settes av lærestedet)

| Egenskap                                                                 | Beskrivelse |
|--------------------------------------------------------------------------|-------------|
| **Antall studieplasser** (kapasitet)                                     | Faktisk antall plasser |
| **Antall tilbud som skal gis**                                           | Det absolutte antallet tilbud som skal gis for dette utdanningstilbudet |
| **Antall ja-svar**                                                       | Nødvendig for utdanningstilbud som skal være med i plasstildelingsrunder etter hovedrunden |
| **Kompetanseregelverk**                                                  | Må velges blant regelverkene i opptakets regelverkssamling. Får default-verdi fra samlingen — gjelder for alle utdanningstilbud uten unntak. |
| **Rangeringsregelverk**                                                  | Må velges blant regelverkene i opptakets regelverkssamling. Får default-verdi fra samlingen — gjelder for alle utdanningstilbud uten unntak. |
| **Utdanningskvoter**                                                     | Standard (default) kvotetyper følger av regelverkssamlingen. Lærestedet kan legge til andre tilgjengelige kvoter fra samlingen. Se [plasstildeling/design.md](../plasstildeling/design.md) |
| **Tidlig søknadsfrist** (valgfritt)                                      | Tidligere søknadsfrist enn opptakets generelle frist. Aktuelt for utdanninger som krever opptaksprøver, f.eks. Politihøyskolen. |
| **Tidlig behandling og tilbud**                                          | Om dette tilbudet støtter tidlig behandling og tilbud. Styres av opptakets innstilling — gjelder for alle utdanningstilbud uten unntak. |
| **Kjønnspoeng**  (skal ikke dette være en kvotetype?)                    | Tilleggspoeng basert på kjønn (hvis aktuelt) |
| **Vis poenggrense for søker**  (Må ikke søker få det?)                   | Om søker skal se poenggrensen |
| **Vis ventelistenummer for søker**  (hvorfor skal dette være valgfritt?) | Om søker skal se sitt ventelistenummer |

**Merk:** det foreligger et forslag om å endre kvotefordelingen fra absolutt per utdanningskvote til relativ fordeling på kvotetypenivå i regelverkssamlingen. Med denne endringen setter lærestedet bare totaltall og eventuelle absolutte spesialkvoter per utdanningstilbud — den relative fordelingen mellom ordinære kvoter beregnes automatisk. Se [regelverk/design.md, «Forslag: relativ fordeling på kvotetypenivå»](../regelverk/design.md#forslag-relativ-fordeling-på-kvotetypenivå).

---

## Del 4: hva som finnes i dag og hva som gjenstår

### fs-plattform/opptak — hva som finnes

| Konsept | Status | Merknad |
|---------|--------|---------|
| Utdanningstilbud med denormalisert søkeindeks | Finnes | Ekstern ID til utdanningsinstans + denormaliserte felter for søk/filter (NKR, fagområde, undervisningstyper, campus m.fl.) |
| Kobling utdanningsmulighet → opptakstype | Finnes | `opptak.utdanningsmulighet_opptakstype`. Brukes for å uttrykke varig intensjon: «denne utdanningen skal tilbys gjennom denne opptakstypen». Se beslutning 1 i [opptak/design.md](../opptak/design.md) — opptakstype bevares som fast kodeverk for matching, selv om konfigurasjonsnivået utgår. |
| Opptaksspesifikke innstillinger per tilbud | Finnes | Kapasitet, regelverk, kvoter, kjønnspoeng, visningsvalg |
| Federation-oppsett med ureg | Finnes | `Utdanningsinstans` er en entity stub i opptak-subgrafen (`@key(fields: "id", resolvable: false)`). Routeren løser visningsdata fra ureg. |
| Synkronisering via hendelser | Under innføring | fs-batch-infrastrukturen brukes for å holde denormaliserte felter i synk med ureg |

### Hva gjenstår

| Gap | Beskrivelse |
|-----|-------------|
| **Grensesnitt for fagskoler** | Fagskolene trenger et eget grensesnitt for å registrere utdanninger direkte i utdanningsregisteret. Under utvikling. |
| **Antall ja-svar** | Feltet er ikke på utdanningstilbud-tabellen i dag. Må legges til. |
| **Fullstendig hendelsesdekning fra ureg** | Det må foreligge hendelser fra ureg for alle denormaliserte felter, slik at opptak kan holde søkeindeksen oppdatert. |

---

## Del 5: åpne spørsmål

1. **Hva skjer med et utdanningstilbud hvis utdanningsinstansen endres eller deaktiveres i utdanningsregisteret etter at opptaket er åpent?** Søkere som allerede har søkt på tilbudet må håndteres.

2. **Frekvens for utdanningstilbud.** Koblingen `utdanningsmulighet → opptakstype` uttrykker at en utdanning skal tilbys i en gitt opptakstype, men sier ikke noe om frekvens (hvert år, annethvert år). Vi klarer oss uten frekvens i 2026, men dette må løses i 2027 for å unngå at læresteder må registrere tilknytningen manuelt hvert år.

Se også [plasstildeling/design.md](../plasstildeling/design.md) og [regelverk/design.md](../regelverk/design.md).
