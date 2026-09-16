# Utdanningstilbud i opptak

*Designfilen gir en teknisk-funksjonell beskrivelse av et konsept: hvordan det er ment å fungere, hvilke beslutninger som er tatt, hvor data kommer fra og hva som gjenstår. Den er skrevet for å skape forståelse på tvers av roller. Den svarer på hva og hvorfor — ikke på hvordan noe skal implementeres eller se ut.*

Et utdanningstilbud er en utdanning som er gjort søkbar i et opptak. Utdanningstilbudet opprettes ikke fra bunnen av — det bygger på autoritative data fra utdanningsregisteret og berikes med opptaksspesifikke innstillinger. Dette dokumentet beskriver hele kjeden: hvordan utdanninger kommer inn i utdanningsregisteret, hvordan endringer flyter til opptak, og hvordan utdanningstilbud opprettes og konfigureres.

**Status:** oppdatert 2026-09-16. Bygger på gjennomgang av fs-plattform/opptak-databasen, domenedokumentasjon fra fs.sikt.no, og arkitekturbeslutningen [«Denormalisering av data fra Utdanningsregisteret»](https://sikt.atlassian.net/wiki/spaces/PFS/pages/4271898626).

---

**Tre beslutninger er tatt og skal leses før resten.**

1. **Utdanningstilbudet bygger på autoritativ kilde.** Grunnlagsdata (navn, studiepoeng, varighet, studienivå, campus, undervisningsspråk) hentes fra utdanningsregisteret og skal ikke registreres på nytt i opptaket. Opptaksforvalteren setter bare opptaksspesifikke egenskaper (kapasitet, tilbud som skal gis, tak for ja-svar og eventuelle lovlige unntak fra standardinnstillinger i opptaket).

2. **Opptak legger til utdanningstilbud.** Opptaksforvalter knytter utdanningstilbud til et opptak fra opptakssiden. På sikt kan det også bli mulig å melde inn utdanninger fra utdanningssiden, men i første omgang er det opptaket som styrer hvilke utdanningstilbud som er med.

3. **Federation er normalmodellen — denormalisering er kun for søk.** Opptak holder bare en referanse-ID til tilhørende entiteter i utdanningsregisteret (ureg). Når en bruker åpner en side som trenger data fra begge systemene (f.eks. rangeringsregelverk fra opptak og navn fra ureg), henter supergrafen automatisk riktig del fra riktig system og setter det sammen. Denormalisering — det vil si å ta en kopi av utvalgte felter fra ureg og lagre dem i opptaks-databasen — gjøres **kun** for felter som trengs i søk, filtrering og sortering. Grunnen er ytelse: uten en lokal kopi måtte opptaket spørre ureg for hvert eneste utdanningstilbud ved hvert søk. Alt som bare skal *vises* (ikke søkes i) hentes direkte fra ureg når brukeren trenger det. Se [arkitekturbeslutningen i Confluence](https://sikt.atlassian.net/wiki/spaces/PFS/pages/4271898626).

---

## Del 1: mål og retning

### Hva dette er, og hva det ikke er

Denne oppgaven dekker hele kjeden fra utdanning til utdanningstilbud i kontekst av samordna opptak 2027:

| | Lærested (SIS) | Utdanningsregisteret | Opptak |
|---|---|---|---|
| **Spørsmålet** | Hva tilbyr vi? | Hva tilbys, hvor og når? | Hva er opptaksbetingelsene? |
| **Hva skjer** | Registrerer studieprogram og studieprogramkull | Mottar og publiserer utdanningsdata | Kobler utdanning til opptak som utdanningstilbud med innstillinger |
| **Dekkes her** | Ja (som forutsetning) | Ja (som forutsetning) | Ja |

### Mål

- Utdanninger som skal med i samordna opptak 2027 finnes i utdanningsregisteret — registrert av UH via FS-SIS eller av fagskoler direkte.
- Utdanningstilbud opprettes med utgangspunkt i utdanninger som er aktive i utdanningsregisteret.
- Grunnlagsdata (navn, studiepoeng, varighet, nivå, campus...) hentes fra utdanningsregisteret og kan ikke overstyres i opptaket.
- Endringer på utdanninger (navneendringer, deaktivering/reaktivering) flyter fra SIS til utdanningsregisteret og videre til opptak.
- Opptaksspesifikke innstillinger (kapasitet, tilbud som skal gis, tak for ja-svar og eventuelle lovlige unntak fra standardinnstillinger i opptaket) settes av lærestedet per utdanningstilbud.
- Det skal være mulig å se alle utdanningstilbud i et opptak fra opptakssiden.

### Ikke-mål

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

### Dataflyt fra FS-SIS til utdanningsregisteret

Batchjobber i fs-batch overfører utdanningsdata fra FS-SIS (Oracle) til utdanningsregisteret (PostgreSQL) via GraphQL.

**Fulloverføring (kjører hvert 30. minutt):**

| Jobb | Hva den overfører |
|------|-------------------|
| `sisUregTransferStudieprogram` | Studieprogrammer (inkl. opptil 50 studieretninger per program) |
| `sisUregTransferStudieprogramkull` | Studieprogramkull (inkl. studieretninger) |
| `sisUregTransferEmne` | Emner |
| `sisUregTransferEmnekull` | Emnekull |

Jobbene leser fra SIS via GraphQL, prosesserer data per institusjon, og skriver til utdanningsregisteret via GraphQL-mutasjoner. Cursor-basert paginering (100 per chunk).

**Hendelsesjobber (per nå deaktivert i produksjon):**

| Jobb | Hendelsestyper |
|------|---------------|
| `sisUregTransferStudieprogramhendelser` | AKTIVERES, DEAKTIVERES, NAVN_ENDRET, SLETTET |
| `sisUregTransferStudieprogramkullhendelser` | NAVN_ENDRET, AKTIVERES, DEAKTIVERES |
| `sisUregTransferEmnehendelser` | NAVN_ENDRET, SISTE_TERMIN_ENDRET, SLETTET |

Hendelsene genereres av Oracle-triggers i SIS-databasen som fanger opp endringer og skriver til `DML_HENDELSE`-tabellen. `ApiHendelseOppretter` prosesserer disse hvert 60. sekund.

**Hvordan det fungerer for ansatte ved lærestedet:** Ansatte registrerer eller endrer studieprogram, studieprogramkull og emner i FS-klienten. Endringer fanges automatisk opp av databasetriggere — ansatte trenger ikke gjøre noe spesielt for å utløse overføring.

### Mapping: FS-SIS → utdanningsregisteret → opptak

| FS-SIS | Utdanningsregisteret | Opptak |
|--------|---------------------|--------|
| Studieprogram | Utdanningsspesifikasjon | — |
| Studieprogram + lærested | Utdanningsmulighet | — |
| Studieprogramkull + campus | Utdanningsinstans | Utdanningstilbud (referanse) |
| Studieretning | Utdanningsmulighet (med referanse til overordnet) | Utdanningstilbud (separat per studieretning) |

### Gap-analyse: SIS → ureg → opptak for samordna opptak 2027

| Behov | Status | Gap |
|-------|--------|-----|
| Studieprogram med studieprogramkull og campus overføres fra SIS til ureg | Fungerer | Ingen — fulloverføring hvert 30. minutt |
| Studieretninger overføres som del av studieprogram/kull | Fungerer | Studieretninger har ingen egne hendelsestyper. Endringer på studieretningen alene (f.eks. aktivering for opptak) genererer ikke en hendelse — de fanges opp først ved neste fulloverføring (maks 30 min forsinkelse). Akseptabelt for 2027, men bør vurderes om hendelsesdekning trengs. |
| Navneendringer flyter fra SIS til ureg | Fungerer via fulloverføring | Hendelsesjobber er deaktivert i prod. Med fulloverføring hvert 30. minutt fanges navneendringer opp, men med opptil 30 min forsinkelse. |
| Navneendringer flyter fra ureg til opptak | Under innføring | Opptak denormaliserer `studieprogram_navn` for søk. Synkronisering fra ureg til opptak via fs-batch-infrastruktur er under innføring. |
| Deaktivering/reaktivering flyter fra SIS til ureg | Fungerer via fulloverføring | Hendelsestyper finnes (AKTIVERES, DEAKTIVERES) men er deaktivert i prod. Fulloverføring fanger opp `erAktiv`-flagg. |
| Deaktivering/reaktivering flyter fra ureg til opptak | Gjenstår | Når en utdanningsinstans blir inaktiv i ureg, skal opptak få beskjed slik at utdanningstilbudet kan trekkes fra opptaket. |
| Fagskoler kan registrere studieprogram og studieprogramkull direkte i ureg | Snart i produksjon | Eget grensesnitt under utvikling. Fagskoler går ikke via SIS/batchjobber. |
| Studieretninger som skal ha opptak | Fungerer teknisk | Studieretninger overføres som nestede barn av studieprogram. Men det mangler veiledning til UH-læresteder om hvordan de skal registrere studieretninger som skal ha opptak. |

**Hovedfunn:** Den tekniske overføringen fra SIS til ureg fungerer for det vi trenger i 2027. Fulloverføring hvert 30. minutt dekker studieprogram, studieprogramkull med campus, og studieretninger. Det som gjenstår er:
1. Synkronisering fra ureg til opptak (navneendringer, deaktivering) — under innføring
2. Veiledning til UH om studieretninger som skal ha opptak
3. Opptak må få beskjed når en utdanningsinstans blir inaktiv, slik at utdanningstilbudet kan trekkes

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
| **Antall tilbud som skal gis** (totalt)                                  | Totalt antall tilbud som skal gis for dette utdanningstilbudet. Fordelingen mellom utdanningskvoter beregnes fra relativ fordeling — se utdanningskvoter nedenfor. |
| **Kompetanseregelverk**                                                  | Må velges blant regelverkene i opptakets regelverkssamling. Får default-verdi fra samlingen — gjelder for alle utdanningstilbud uten unntak. |
| **Rangeringsregelverk**                                                  | Må velges blant regelverkene i opptakets regelverkssamling. Får default-verdi fra samlingen — gjelder for alle utdanningstilbud uten unntak. |
| **Utdanningskvoter med relativ fordeling**                               | Standard (default) kvotetyper følger av regelverkssamlingen (f.eks. ORD 50 % + ORDF 50 %). Lærestedet kan legge til andre tilgjengelige kvoter fra samlingen og sette andre fordelinger. Alle kvoter — inkludert spesialkvoter som samisk og nordnorsk — settes som **relative tall** (prosent). Antall tilbud per utdanningskvote beregnes automatisk av plasstildelingen fra totalt antall tilbud og den relative fordelingen. Se [plasstildeling/design.md](../plasstildeling/design.md) |
| **Plassflyt mellom utdanningskvoter**                                    | Standard plassflyt er ORDF → ORD: ledige plasser i førstegangsvitnemålskvoten flyter til ordinær kvote. Utdanningstilbud med andre kvotetyper kan sette andre regler. Kun én utdanningskvote kan være siste mottaker. Se [plasstildeling/design.md](../plasstildeling/design.md) |
| **Tidlig søknadsfrist** (valgfritt)                                      | Tidligere søknadsfrist enn opptakets generelle frist. Aktuelt for utdanninger som krever opptaksprøver, f.eks. Politihøyskolen. |
| **Tidlig behandling og tilbud**                                          | Om dette tilbudet støtter tidlig behandling og tilbud. Styres av opptakets innstilling — gjelder for alle utdanningstilbud uten unntak. |
| **Kjønnspoeng**  (skal ikke dette være en kvotetype?)                    | Tilleggspoeng basert på kjønn (hvis aktuelt) |
| **Vis poenggrense for søker**  (Må ikke søker få det?)                   | Om søker skal se poenggrensen |
| **Vis ventelistenummer for søker**  (hvorfor skal dette være valgfritt?) | Om søker skal se sitt ventelistenummer |

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
| **Fullstendig hendelsesdekning fra ureg** | Det må foreligge hendelser fra ureg for alle denormaliserte felter, slik at opptak kan holde søkeindeksen oppdatert. |

---

## Del 5: åpne spørsmål

1. **Hva skjer med søkere som allerede har søkt på et utdanningstilbud som trekkes?** Når en utdanningsinstans blir inaktiv og utdanningstilbudet trekkes fra opptaket, må eksisterende søknader håndteres.

2. **Frekvens for utdanningstilbud.** Koblingen `utdanningsmulighet → opptakstype` uttrykker at en utdanning skal tilbys i en gitt opptakstype, men sier ikke noe om frekvens (hvert år, annethvert år). Vi klarer oss uten frekvens i 2026, men dette må løses i 2027 for å unngå at læresteder må registrere tilknytningen manuelt hvert år.

Se også [plasstildeling/design.md](../plasstildeling/design.md) og [regelverk/design.md](../regelverk/design.md).
