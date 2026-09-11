# Utdanningstilbud i opptak

Et utdanningstilbud er en utdanning som er gjort søkbar i et opptak. Utdanningstilbudet opprettes ikke fra bunnen av — det bygger på autoritative data fra utdanningsregisteret og berikes med opptaksspesifikke innstillinger. Dette dokumentet beskriver hvordan utdanningstilbud hentes fra utdanningsregisteret, hva som arves og hva som settes av opptaksforvalter.

**Status:** første utkast, 2026-09-11. Bygger på gjennomgang av fs-plattform/opptak-databasen, logisk replikering fra utdanningsregisteret, og domenedokumentasjon fra fs.sikt.no.

---

**To beslutninger bør leses før resten. Begge er tatt.**

1. **Utdanningstilbudet bygger på autoritativ kilde.** Grunnlagsdata (navn, studiepoeng, varighet, studienivå, campus, undervisningsspråk) hentes fra utdanningsregisteret og skal ikke registreres på nytt i opptaket. Opptaksforvalteren setter bare opptaksspesifikke egenskaper (kapasitet, regelverk, kvoter).

2. **Det er utdanningstilbudet som melder seg inn i et opptak, ikke opptaket som henter inn utdanningstilbud.** Lærestedet knytter sine utdanningstilbud til et opptak fra utdanningstilbudsiden. Fra opptakssiden skal det være mulig å se hvilke utdanningstilbud som er med, og det bør også være mulig å legge til utdanningstilbud derfra som en snarvei.

---

## Del 1: mål og retning

### Hva dette er, og hva det ikke er

Med utdanningstilbud mener vi koblingen mellom en konkret utdanning (fra utdanningsregisteret) og et opptak, beriket med opptaksspesifikke innstillinger. Det er noe annet enn selve utdanningen (som eies av utdanningsregisteret) og noe annet enn opptaket (som er rammen rundt).

| | Utdanningsregisteret | Utdanningstilbud i opptak | Opptak |
|---|---|---|---|
| **Spørsmålet** | hva tilbys, hvor og når? | hva er opptaksbetingelsene for denne utdanningen? | hva er rammene for opptaket? |
| **Eier** | lærested (via SIS eller eget grensesnitt) | lærested (opptaksspesifikke innstillinger) | opptaksforvalter |
| **Dekkes her** | nei | ja | nei — se [opptak/design.md](../opptak/design.md) |

### Mål

- Utdanningstilbud skal opprettes med utgangspunkt i utdanninger som finnes og er aktive i utdanningsregisteret.
- Grunnlagsdata (navn, studiepoeng, varighet, nivå, campus) skal hentes fra utdanningsregisteret og ikke kunne overstyres i opptaket.
- Opptaksspesifikke innstillinger (kapasitet, regelverk, kvoter) settes av lærestedet per utdanningstilbud.
- Det skal være mulig å se alle utdanningstilbud i et opptak fra opptakssiden.

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

**Opptak kobler seg til utdanningsinstansnivået** — det mest konkrete nivået. En person søker seg opp til en utdanningsinstans.

### Dataflyt fra utdanningsregisteret til opptak

Data flyter via **logisk replikering** i PostgreSQL (publish/subscribe). Utdanningsregisteret publiserer, opptak abonnerer. Replikerte data er skrivebeskyttet i opptaksdatabasen.

Flyten for å opprette et utdanningstilbud:

1. Lærestedet registrerer utdanningen i utdanningsregisteret (via SIS-integrasjon eller eget grensesnitt).
2. Utdanningsregisteret publiserer utdanningsinstansen.
3. Opptak abonnerer og får referansedata.
4. Lærestedet knytter utdanningsinstansen til et opptak — et utdanningstilbud opprettes.
5. Lærestedet setter opptaksspesifikke innstillinger (kapasitet, regelverk, kvoter).

### Registrering av utdanninger — 2027

For samordna opptak 2027 er det to ulike situasjoner:

**Universiteter og høyskoler:** Alle UH-læresteder som er med i samordna opptak bruker FS-SIS, som har integrasjon mot utdanningsregisteret. Utdanninger registreres i FS-SIS og overføres automatisk til utdanningsregisteret.

**Fagskoler:** Fagskolenes SIS-er integrerer ikke mot utdanningsregisteret. For 2027-opptaket vil fagskolene registrere sine utdanninger i et **eget grensesnitt direkte mot utdanningsregisteret**. Se [studieprogram/design.md](../../../utdanning/oppgaver/studieprogram/design.md) for design av dette grensesnittet.

---

## Del 3: hva som arves og hva som settes

### Autoritative data fra utdanningsregisteret (arves, kan ikke overstyres)

Disse feltene hentes fra utdanningsregisteret via utdanningsinstans-referansen:

| Felt | Kilde i utdanningsregisteret |
|------|------------------------------|
| Navn | Utdanningsspesifikasjon |
| Studiepoeng / omfang | Utdanningsspesifikasjon |
| Varighet | Utdanningsmulighet |
| Studienivå (NKR) | Utdanningsspesifikasjon |
| Fagområde (NUS) | Utdanningsspesifikasjon |
| Undervisningsspråk | Utdanningsmulighet |
| Prosent av fulltid | Utdanningsmulighet |
| Campus / studiested | Utdanningsinstans |
| Oppstartstermin | Utdanningsinstans |
| Lærested (organisasjon) | Utdanningsmulighet |

### Opptaksspesifikke innstillinger (settes av lærestedet)

| Egenskap | Beskrivelse |
|----------|-------------|
| **Antall studieplasser** (kapasitet) | Faktisk antall plasser |
| **Antall tilbud som skal gis** | Det absolutte antallet tilbud som skal gis for dette utdanningstilbudet |
| **Antall ja-svar** | Nødvendig for utdanningstilbud som skal være med i plasstildelingsrunder etter hovedrunden |
| **Regelverkssamling** (valgfritt) | Overstyrer opptakets regelverkssamling for dette tilbudet |
| **Kompetanseregelverk** | Arves fra regelverkssamling eller settes eksplisitt |
| **Rangeringsregelverk** | Arves fra regelverkssamling eller settes eksplisitt |
| **Utdanningskvoter** | Standard (default) kvotetyper arves fra regelverkssamling. Lærestedet kan legge til andre tilgjengelige kvoter. Se [plasstildeling/design.md](../plasstildeling/design.md) |
| **Tidlig søknadsfrist** (valgfritt) | Tidligere søknadsfrist enn opptakets generelle frist. Aktuelt for utdanninger som krever opptaksprøver, f.eks. Politihøyskolen. |
| **Tidlig behandling og tilbud** | Om dette tilbudet støtter tidlig behandling og tilbud (arves fra opptak) |
| **Kjønnspoeng** | Tilleggspoeng basert på kjønn (hvis aktuelt) |
| **Vis poenggrense for søker** | Om søker skal se poenggrensen |
| **Vis ventelistenummer for søker** | Om søker skal se sitt ventelistenummer |

**Merk:** det foreligger et forslag om å endre kvotefordelingen fra absolutt per utdanningskvote til relativ fordeling på kvotetypenivå i regelverkssamlingen. Med denne endringen setter lærestedet bare totaltall og eventuelle absolutte spesialkvoter per utdanningstilbud — den relative fordelingen mellom ordinære kvoter beregnes automatisk. Se [regelverk/design.md, «Forslag: relativ fordeling på kvotetypenivå»](../regelverk/design.md#forslag-relativ-fordeling-på-kvotetypenivå).

---

## Del 4: hva som finnes i dag og hva som gjenstår

### fs-plattform/opptak — hva som finnes

| Konsept | Status | Merknad |
|---------|--------|---------|
| Utdanningstilbud med referanse til utdanningsinstans | Finnes (v1 + v2) | v1: fremmednøkkel til `utdanning.utdanningsinstans`. v2: ekstern ID uten fremmednøkkel. |
| Logisk replikering fra utdanningsregisteret | Under innføring | Kun primærnøkler og navn replikeres foreløpig |
| Kobling utdanningsmulighet → opptakstype | Finnes | `opptak.utdanningsmulighet_opptakstype` |
| Opptaksspesifikke innstillinger per tilbud | Finnes | Kapasitet, regelverk, kvoter, kjønnspoeng, visningsvalg |
| Denormaliserte utdanningsdata (v2) | Finnes | NKR, fagområde, undervisningstyper, campus — kopiert inn i v2-tabellen |

### Hva gjenstår

| Gap | Beskrivelse |
|-----|-------------|
| **Replikering av fullstendig metadata** | Foreløpig replikeres kun primærnøkler og navn. Studiepoeng, varighet, nivå og andre grunnlagsdata er ikke med. v2 løser dette ved denormalisering, men det er en duplikering som kan gå ut av synk. |
| **v1/v2-sameksistens** | Begge tabellene finnes. v2 mangler fremmednøkler til utdanningsregisteret — et steg tilbake fra v1-prinsippet om referanseintegritet. Må avklares hvilken modell som gjelder fremover. |
| **Grensesnitt for fagskoler** | Fagskolene trenger et eget grensesnitt for å registrere utdanninger direkte i utdanningsregisteret. Under utvikling. |
| **Antall ja-svar** | Feltet er ikke på utdanningstilbud-tabellen i dag. Må legges til. |

---

## Del 5: åpne spørsmål

1. **v1 eller v2 — hvilken modell gjelder?** v1 har referanseintegritet, v2 har denormalisering og fleksibilitet. Må avklares.

2. **Skal denormaliserte data i v2 oppdateres automatisk ved endringer i utdanningsregisteret?** Hvis ikke, kan data gå ut av synk.

3. **Hva skjer med et utdanningstilbud hvis utdanningsinstansen endres eller deaktiveres i utdanningsregisteret etter at opptaket er åpent?** Søkere som allerede har søkt på tilbudet må håndteres.

Se også [plasstildeling/design.md](../plasstildeling/design.md) og [regelverk/design.md](../regelverk/design.md).
