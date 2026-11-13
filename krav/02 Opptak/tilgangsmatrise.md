# Tilgangsmatrise for opptak

Hvem som får se og endre hva i opptak, slik kravene sier det i dag. Matrisen er en oversikt, ikke en kilde: reglene står i kravene, og det er kravet som gjelder når de er uenige.

Tilgangsreglene er ikke et eget scope. De tas inn når et team jobber med funksjonaliteten som bruker dem. Endres en tilgangsregel i et krav, oppdateres matrisen i samme PR.

Sist oppdatert: 2026-11-13, fra `main`.

## Slik leses matrisen

**Kolonnene** er brukerrollen ved organisasjonens rolle i opptaket (se `begreper.md`):

| Kolonne | Betyr |
|---|---|
| **OF‑F** | opptaksforvalter hos forvalteren |
| **OF‑T** | opptaksforvalter hos tilbyderen (deltakende organisasjon) |
| **SB‑B** | saksbehandler hos behandleren |
| **SB‑T** | saksbehandler hos tilbyderen, når en annen organisasjon behandler |
| **OI** | opptaksinformatør hos forvalteren, tilbyderen eller behandleren |
| **DF‑F** | dokumentforvalter hos forvalteren |
| **Søker** | søkeren selv, i Min kompetanse |
| **Uten** | en ansatt ved en organisasjon uten rolle i opptaket, eller en bruker eller integrasjon uten roller |

**Cellene:**

- **Ja** / **Nei**: kravet sier det.
- **Ja: …**: kravet sier ja, med en grense.
- **Se**: kravet sier at rollen ser, men ikke endrer.
- **–**: kravet sier ingenting. Etter grunnregelen ([`@FEL-TIL-GRU-001`](#kravene)) har rollen da ikke tilgang. En «–» der man venter tilgang, er et hull i kravene.

**Status** er taggen på regelen, ellers på egenskapen. Det meste er `@draft`, altså ikke validert. Et åpent spørsmål står som ❓ og er listet under *Åpne spørsmål*.

**Integrasjoner** får det samme som en ansatt med de samme rollene ved samme organisasjon, aldri mer. API-et gir aldri mer enn FS Admin ([`@FEL-TIL-GRU-001`](#kravene)).

## Prioritet

Tilgangsreglene som ble skrevet i PR 1009, er Must, også dem som var Should, og regelen om at et historisk opptak avviser endringer, også i API-et (`@OPT-OVO-GRU-004`). Avklart av produkteier 2026-11-13.

To er Could:

- `@OPT-SØK-MEL-001`, regelen «Hvem som endrer tekstene til søkerne, følger organisasjonens rolle i opptaket»
- `@OPT-BEH-BEH-045`, uttrekk av sakslista

Kravene med disse reglene er `@must`, unntatt `@OPT-BEH-BEH-045`. `@OPT-OPT-UTD-029` var Should, og er endret til Must.

## Søknaden og personopplysningene

| Objekt og handling | OF‑F | OF‑T | SB‑B | SB‑T | OI | DF‑F | Søker | Uten | Krav | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| Se søknaden | Ja | – | Ja | Ja: alle alternativer og prioriteringen | Ja | – | Ja: egne | Nei | `@OPT-BEH-BEH-043` | `@draft` |
| Opprette og endre søknad på søkerens vegne | Ja | Nei | Nei | – | Nei | – | – | Nei | `@OPT-SØK-SØK-002` | `@draft` |
| Trekke søknad på søkerens vegne | Ja | Nei | Nei | – | Nei | – | – | Nei | `@OPT-SØK-SØK-002` | `@draft` |
| Trekke egen søknad | – | – | – | – | – | – | Ja: til den er ferdigbehandlet | – | `@OPT-SØK-SØK-008` | `@implemented` |
| Endre resultatet eller hvem som behandler | – | – | – | – | – | – | Nei | – | `@OPT-SØK-SØK-007` | `@draft` |
| Søke opp person som ikke har søknad | Ja | Nei | Nei | – | Nei | – | – | Nei | `@OPT-SØK-SØK-002` | `@draft` |
| Se personopplysningene | Følger søknaden | – | Følger søknaden | Følger søknaden | Følger søknaden | – | Ja | Nei | `@OPT-BEH-BEH-043` | `@draft` |
| Se fortrolig adresse | Nei | – | Nei | – | Nei | – | Ja | Nei | `@OPT-BEH-BEH-043` | `@draft` |
| Endre kontaktinformasjon | Ja: bare e-post når søkeren ikke er i Folkeregisteret | – | – | – | Nei | – | – | Nei | `@OPT-BEH-BEH-043` | `@draft` |

## Saken

| Objekt og handling | OF‑F | OF‑T | SB‑B | SB‑T | OI | DF‑F | Søker | Uten | Krav | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| Se saken (vurdering, poeng, kvalifisering, praksis) | Ja: alle sakene i opptaket | – | Ja: egen sak, og se de andre behandlernes saker på samme søknad | Se | Se | – | Nei: ser hvem som behandler | Nei | `@OPT-BEH-BEH-011`, `@OPT-BEH-BEH-043` | `@implemented` / `@draft` |
| Se saken etter at den er flyttet | – | – | Nei, med mindre organisasjonen er tilbyder | – | – | – | – | – | `@OPT-BEH-BEH-011` | `@draft` |
| Endre saken (grunnlag, poeng, status) | – | – | Ja: egen sak, med endringsrett | Nei | Nei | – | – | Nei | `@OPT-BEH-BEH-004`, `@OPT-BEH-BEH-011` | `@in-progress` |
| Registrere praksis | – | – | Ja | Se | Se | – | – | Nei | `@OPT-BEH-BEH-003` | `@draft` |
| Sette tilbudsgaranti manuelt | Nei: settes bare maskinelt | – | Ja: i saksbehandlerfeltet | Ja: i tilbyderfeltet | Nei | – | – | Nei | `@OPT-BEH-BEH-010` | `@draft` |
| Endre eller fjerne tilbudsgaranti | – | – | Ja: den saksbehandleren satte | Ja: den tilbyderen satte | Nei | – | – | – | `@OPT-BEH-BEH-010` | `@implemented` |
| Se og endre GSK-konklusjonen | – | – | Ja: til opptaket er historisk | – | – | – | – | – | `@OPT-BEH-BEH-042` | `@planned` |
| Annullere GSK-konklusjonen | – | – | Ja: organisasjonen som satte eller sist endret den, og HK-dir | – | – | – | – | – | `@OPT-BEH-BEH-042` | `@planned` |
| Se interne poeng | – | – | – | – | – | – | Nei | – | `@OPT-BEH-BEH-040` | `@draft` |

## Dokumentasjon

| Objekt og handling | OF‑F | OF‑T | SB‑B | SB‑T | OI | DF‑F | Søker | Uten | Krav | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| Se dokumentasjonen | Ja | – | Ja | Ja | Ja: innsynet logges | – | Ja: det som er knyttet til søknaden | Nei | `@OPT-BEH-DOK-001`, `@OPT-SØK-SØK-019` | `@draft` |
| Laste opp og slette på søkerens vegne | Nei | – | Nei | – | Nei | Ja | – | Nei | `@OPT-BEH-DOK-001` | `@draft` |
| Markere dokumentasjon som sensitiv | – | – | Ja | – | Nei | – | – | – | `@OPT-BEH-DOK-001` | `@draft` ❓ |
| Se innholdet i politiattesten | Nei: ser at den er levert | – | Ja | Ja: etter at søkeren har svart ja | Nei: ser at den er levert | – | – | Nei | `@OPT-BEH-DOK-001` | `@draft` |

## Merknader, mangler og meldinger

En merknad, mangel eller melding er **delt** med forvalteren, tilbyderen og behandlerne på søknaden, med mindre den er merket som **intern**. En intern ses bare av organisasjonen som registrerte den.

| Objekt og handling | OF‑F | OF‑T | SB‑B | SB‑T | OI | DF‑F | Søker | Uten | Krav | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| Se delte merknader | Ja | – | Ja | Ja | Ja | – | Nei | Nei | `@OPT-BEH-BEH-044` | `@draft` |
| Se interne merknader | Nei | – | Ja: fra egen organisasjon | Nei | Ja: fra egen organisasjon | – | Nei | Nei | `@OPT-BEH-BEH-044` | `@draft` |
| Skrive merknader | – | – | Ja | Nei | Nei | – | – | Nei | `@OPT-BEH-BEH-044` | `@draft` |
| Forvalte mangelkodene | Ja | – | – | – | – | – | – | – | `@OPT-BEH-BEH-008` | `@implemented` |
| Registrere og endre mangler | – | – | Ja: i egen sak | Nei | Nei | – | – | Nei | `@OPT-BEH-BEH-008` | `@implemented` |
| Se mangler | Ja: alle | – | Ja: alle sakene på søknaden, interne bare fra egen organisasjon | Se: delte | Se: delte | – | Ja: bare publiserte | Nei | `@OPT-BEH-BEH-008`, `@OPT-BEH-BEH-043` | `@draft` ❓ |
| Sende melding til søkeren | Ja | – | Ja | Ja: «de ansatte ved tilbyderen» | Nei | – | – | Nei | `@OPT-SØK-MEL-001` | `@draft` ❓ |
| Se meldinger til søkeren | Ja: delte | – | Ja: delte, interne fra egen organisasjon | Ja: delte | Ja: delte | – | Ja: egne, kan bare markere som lest | Nei | `@OPT-SØK-MEL-004`, `@OPT-SØK-SØK-010` | `@draft` |
| Se mottakere og utsendinger som feilet | Ja | – | – | – | – | – | – | – | `@OPT-SØK-MEL-004` | `@draft` |
| Endre tekstene til søkerne | Ja: alle | Ja: for tilbudene organisasjonen tilbyr | – | – | – | – | – | – | `@OPT-SØK-MEL-001` | `@draft` ❓ |

## Endringslogg og hendelseslogg

Ingen kan endre eller slette loggene, heller ikke gjennom API-et.

| Objekt og handling | OF‑F | OF‑T | SB‑B | SB‑T | OI | DF‑F | Søker | Uten | Krav | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| Se endringsloggen for saken | Ja | – | Ja | Ja: uten interne merknader | Ja | – | Ja: ser organisasjonen, ikke saksbehandleren | Nei | `@OPT-BEH-BEH-016` | `@draft` ❓ |
| Se hendelsesloggen for opptaket | Ja: rolle og organisasjon, ikke den ansatte | Ja: hendelsene på tilbudene organisasjonen tilbyr | – | – | – | – | – | Nei | `@OPT-OVO-LOG-001` | `@draft` ❓ |

## Resultatet

| Objekt og handling | OF‑F | OF‑T | SB‑B | SB‑T | OI | DF‑F | Søker | Uten | Krav | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| Se resultatet før publisering | Ja: alle | Ja: tilbudene organisasjonen tilbyr | Ja: søknadene organisasjonen behandler | – | Nei | – | Nei | Nei | `@OPT-PLA-RES-001` | `@draft` |
| Se publisert resultat og søkertall | – | – | Ja | Ja | Ja | – | Ja: eget | Nei | `@OPT-PLA-RES-003`, `@OPT-BEH-BEH-043` | `@draft` |
| Ta ut sakslista | Ja | – | Ja | – | Nei | – | – | Nei | `@OPT-BEH-BEH-045` | `@draft` ❓ |

Sakslista har bare saker der organisasjonen er forvalter, tilbyder eller behandler. Brukeren oppgir formålet og bekrefter før uttrekket, og fødselsnummeret er bare med når det velges.

## Opptaket og utdanningstilbudene

| Objekt og handling | OF‑F | OF‑T | SB‑B | SB‑T | OI | DF‑F | Søker | Uten | Krav | Status |
|---|---|---|---|---|---|---|---|---|---|---|
| Opprette opptak | Ja: organisasjonen blir forvalter | – | – | – | – | – | – | – | `@OPT-OVO-GRU-001` | `@implemented` |
| Se opptaket før det er publisert | Ja | Ja | Ja | Ja | – | – | Nei | Nei | `@OPT-OVO-SAM-001`, `@OPT-OVO-GRU-004` | `@draft` ❓ |
| Endre innstillinger og frister, legge til deltakere | Ja | Se | – | – | – | – | – | Nei | `@OPT-OVO-SAM-001`, `@OPT-OVO-FRI-001` | `@in-progress` ❓ |
| Publisere, avpublisere og gjøre historisk | Ja | Nei | – | – | – | – | – | Nei | `@OPT-OVO-GRU-004` | `@implemented` / `@draft` ❓ |
| Endre forvalteren av opptaket | Nei | Nei | Nei | Nei | Nei | Nei | – | Nei | `@OPT-OVO-GRU-001` | `@draft` |
| Endre noe i et historisk opptak | Nei | Nei | Nei: ser saken | Nei | Nei | Nei | – | Nei | `@OPT-OVO-GRU-004` | `@draft` ❓ |
| Se utdanningstilbudene | Ja: alle | Ja: tilbudene organisasjonen tilbyr | Se: krav, poeng og kvoter på tilbudene organisasjonen behandler | – | – | – | Ja: bare publiserte, før fristen | Ja: bare publiserte | `@OPT-OPT-UTD-001`, `@OPT-SØK-SØK-013` | `@draft` |
| Legge til, redigere, fjerne og trekke utdanningstilbud | Ja: alle, også etter fristene | Ja: egne, innen fristene | Nei | – | – | – | – | Nei | `@OPT-OPT-UTD-002`, `-003`, `-026`, `-033` | `@in-progress` ❓ |
| Endre antall studieplasser og antall tilbud | Ja | Ja: til første plasstildelingsrunde er publisert | – | – | – | – | – | – | `@OPT-OPT-UTD-007`, `@OPT-PLA-INN-001` | `@draft` |
| Se plassflyt og kvoteprioritet på tilbudet | – | Se | – | – | – | – | – | – | `@OPT-OPT-UTD-004` | `@draft` ❓ |
| Endre poenggrensen for tidlig opptak | Ja | Ja: egne, før fristen | – | – | – | – | – | – | `@OPT-OPT-UTD-004` | `@draft` ❓ |
| Se andre tilbyderes poenggrense for tidlig opptak | Ja | Nei | – | – | – | – | – | – | `@OPT-OPT-UTD-004` | `@draft` ❓ |
| Se poenggrensen | – | – | – | – | – | – | Ja: når plasstildelingen er publisert | Ja: når plasstildelingen er publisert | `@OPT-OPT-UTD-029` | `@draft` |
| Starte plasstildeling | – | Nei | – | – | – | – | – | – | `@OPT-PLA-TIL-001` | `@draft` |

## Regelverket

Regelverket hører til organisasjonen som eier regelverkssamlingen, ikke til opptaket. Kolonnene for forvalter og tilbyder gjelder ikke her.

| Objekt og handling | Opptaksforvalter | Saksbehandler | Opptaksinformatør | Krav | Status |
|---|---|---|---|---|---|
| Se regelverkssamlingene ved alle organisasjoner | Ja | Ja | Ja | `@OPT-REG-SAM-001` | `@planned` |
| Opprette, endre, kopiere og slette regelverkssamlinger | Ja: ved organisasjonen som eier samlingen | Nei | Nei | `@OPT-REG-SAM-001` | `@planned` |
| Opprette eller kopiere til en annen organisasjon | Nei | Nei | Nei | `@OPT-REG-SAM-001` | `@implemented` |
| Forvalte kvoter, kvoteprioritet, plassflyt, krav, rangering og grunnlag | Ja (står bare i `Som`-linja) | – | – | `@OPT-REG-KVO-*`, `@OPT-REG-KRA-*`, `@OPT-REG-RAN-*`, `@OPT-REG-GRU-001` | ulik |

## Motsetninger og hull

- **Praksis:** `@OPT-BEH-BEH-003` har en eldre regel om at bare saksbehandlere ser praksisen, og en ny regel (`@draft`) om at alle som ser saken, ser den.
- **Andre behandleres saker:** `@OPT-BEH-BEH-011` har en levert regel om at behandleren bare ser saken hos egen organisasjon, og en ny regel (`@draft`) om at behandlerne ser vurderingen og poengene i hverandres saker. Den gamle regelen skal få `@deprecated` når den nye er validert.
- **Opplasting på søkerens vegne:** `@OPT-SØK-SØK-019` sier at søkeren ser det saksbehandleren har lastet opp, mens `@OPT-BEH-DOK-001` sier at bare dokumentforvalteren laster opp.
- **Tilbudsgaranti:** `@OPT-BEH-BEH-010` sier at opptaksforvalteren kan sette tilbudsgaranti manuelt (`@implemented`), og at forvalterens tilbudsgaranti bare settes maskinelt (`@draft`).
- **Står bare som kommentar:** at opptaksforvalter hos tilbyderen setter innstillinger på egne utdanningstilbud og forvalteren på alle (`@OPT-OPT-UTD-004`, `@OPT-OPT-UTD-007`), og at bare organisasjonen som har opprettet regelverket, kan endre det.
- **Opptaksforvalter hos forvalteren og det publiserte resultatet:** `@OPT-PLA-RES-003` nevner bare saksbehandlere.
- **Uten statustag:** `@OPT-SØK-SØK-002` og `@OPT-BEH-BEH-001` har ingen status på `Egenskap:`. `@OPT-BEH-BEH-001` har også `@focus`, som ikke skal sjekkes inn.
- **Samme ID to ganger:** `@OPT-BEH-BEH-042` brukes av både `sette_gsk_konklusjon_manuelt.feature` og `gjenbruke_tilleggspoeng.feature`.

## Åpne spørsmål

- Hvilke handlingskoder gir rollene i tilgangsstyring? Bare MODIFISERE_REGELVERK (opptaksforvalter) og SE_SØKNAD (opptaksinformatør, foreløpig) er kjent. OPPTAK_INNSYN (TAKE-469) og OPPTAK_DOKUMENTASJON (TAKE-470) finnes ikke ennå.
- Skal rollebruken kunne leses maskinelt med `@rolle-<slug>`? Se *Tags → Roller* i `krav/README.md`.
- Dokumentasjon (`@OPT-BEH-DOK-001`): hvem kan fjerne markeringen som sensitiv? Hvem eier innsynsloggen? Hører dokumentasjonen til søknaden eller personen?
- Dokumentasjon (`@OPT-SØK-SØK-019`): ser søkeren hvem som lastet opp, og kan søkeren slette det andre har lastet opp?
- Meldinger (`@OPT-SØK-MEL-001`): hvilken rolle har «de ansatte ved tilbyderen» som sender meldinger? Hvem ser og endrer generiske tekster?
- Logger (`@OPT-OVO-LOG-001`, `@OPT-BEH-BEH-016`): hvem ser hvilken ansatt som gjorde en endring, og hvem andre skal se loggen (støtte, revisjon, klagebehandling)?
- Sakslista (`@OPT-BEH-BEH-045`): hvem ser loggen over formål og fødselsnummer?
- Mangler (`@OPT-BEH-BEH-008`): hvordan publiseres manglene til søkeren?
- Opptaket (`@OPT-OVO-SAM-001`, `@OPT-OVO-GRU-004`): ser en organisasjon som ikke deltar, et opptak den finner i fritekst? Kan saksbehandler søke i, og behandle klager i, et historisk opptak?
- Utdanningstilbud (`@OPT-OPT-UTD-004`): skal bare forvalteren kunne opprette nye regelverk fra opptaket? Kan visningen av poenggrensen overstyres i samordna opptak?
- Resultat (`@OPT-PLA-RES-001`): skal totaltallene kunne åpnes til søknadene bak?
- Sikt-brukerstøtte: innsyn på tvers av organisasjoner, med logging. Kravet er ikke skrevet, og hører til `07 Brukeradministrasjon og tilgangsstyring`.

## Kravene

| Krav | Fil |
|---|---|
| `@FEL-TIL-GRU-001` | `krav/10 Felleskrav/12 Tilgang/01 Grunnregler/ingen_tilgang_uten_regel.feature` |
| `@OPT-REG-SAM-001` | `10 Regelverk/01 Regelverkssamling/regelverkssamling.feature` |
| `@OPT-OVO-GRU-001` | `11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opprett_opptak.feature` |
| `@OPT-OVO-GRU-004` | `11 Opprette og vedlikeholde opptak/01 Grunnoppsett/opptaksstatus.feature` |
| `@OPT-OVO-SAM-001` | `11 Opprette og vedlikeholde opptak/02 Samordning/samordna_opptak.feature` |
| `@OPT-OVO-FRI-001` | `11 Opprette og vedlikeholde opptak/04 Frister/frister_og_hendelser.feature` |
| `@OPT-OVO-LOG-001` | `11 Opprette og vedlikeholde opptak/06 Hendelseslogg/hendelseslogg.feature` |
| `@OPT-OPT-UTD-001` | `12 Utdanningstilbud/02 Utdanningstilbud i opptak/listevisning_utdanningstilbud.feature` |
| `@OPT-OPT-UTD-002` | `12 Utdanningstilbud/02 Utdanningstilbud i opptak/legge_til_utdanningstilbud.feature` |
| `@OPT-OPT-UTD-003` | `12 Utdanningstilbud/02 Utdanningstilbud i opptak/trekke_utdanningstilbud.feature` |
| `@OPT-OPT-UTD-026` | `12 Utdanningstilbud/02 Utdanningstilbud i opptak/fjerne_utdanningstilbud.feature` |
| `@OPT-OPT-UTD-004` | `12 Utdanningstilbud/03 Opptaksinnstillinger/opptaksinnstillinger_utdanningstilbud.feature` |
| `@OPT-OPT-UTD-007` | `12 Utdanningstilbud/03 Opptaksinnstillinger/sette_studieplasser_og_antall_tilbud.feature` |
| `@OPT-OPT-UTD-029` | `12 Utdanningstilbud/04 Behandle et utdanningstilbud/vise_poenggrense_og_ventelistenummer_for_søker.feature` |
| `@OPT-OPT-UTD-033` | `12 Utdanningstilbud/04 Behandle et utdanningstilbud/angi_alternativt_visningsnavn.feature` |
| `@OPT-SØK-SØK-002` | `13 Søknad og saksbehandling/01 Søknad/opprette_søknad_for_person.feature` |
| `@OPT-SØK-SØK-007` | `13 Søknad og saksbehandling/01 Søknad/svare_på_tilbud.feature` |
| `@OPT-SØK-SØK-008` | `13 Søknad og saksbehandling/01 Søknad/trekke_søknad.feature` |
| `@OPT-SØK-SØK-010` | `13 Søknad og saksbehandling/01 Søknad/mine_meldinger.feature` |
| `@OPT-SØK-SØK-013` | `13 Søknad og saksbehandling/01 Søknad/finne_studier.feature` |
| `@OPT-SØK-SØK-019` | `13 Søknad og saksbehandling/01 Søknad/håndtere_dokumentasjon_i_søknad.feature` |
| `@OPT-BEH-BEH-003` | `13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature` |
| `@OPT-BEH-BEH-004` | `13 Søknad og saksbehandling/02 Behandling/velge_vitnemål_som_grunnlag.feature` |
| `@OPT-BEH-BEH-008` | `13 Søknad og saksbehandling/02 Behandling/søknadsmangler.feature` |
| `@OPT-BEH-BEH-010` | `13 Søknad og saksbehandling/02 Behandling/gi_tilbudsgaranti.feature` |
| `@OPT-BEH-BEH-011` | `13 Søknad og saksbehandling/02 Behandling/tildele_saksbehandlende_organisasjon.feature` |
| `@OPT-BEH-BEH-016` | `13 Søknad og saksbehandling/02 Behandling/hendelseslogg_for_saksbehandling.feature` |
| `@OPT-BEH-BEH-040` | `13 Søknad og saksbehandling/02 Behandling/sette_interne_poeng.feature` |
| `@OPT-BEH-BEH-042` | `13 Søknad og saksbehandling/02 Behandling/sette_gsk_konklusjon_manuelt.feature` |
| `@OPT-BEH-BEH-043` | `13 Søknad og saksbehandling/02 Behandling/se_søknaden_til_en_søker.feature` |
| `@OPT-BEH-BEH-044` | `13 Søknad og saksbehandling/02 Behandling/skrive_merknad_i_saken.feature` |
| `@OPT-BEH-BEH-045` | `13 Søknad og saksbehandling/02 Behandling/ta_ut_sakslista.feature` |
| `@OPT-BEH-DOK-001` | `13 Søknad og saksbehandling/03 Dokumentasjon/skjerme_dokumentasjon.feature` |
| `@OPT-SØK-MEL-001` | `13 Søknad og saksbehandling/04 Meldinger og oppgaver/sende_melding_til_søker.feature` |
| `@OPT-SØK-MEL-004` | `13 Søknad og saksbehandling/04 Meldinger og oppgaver/se_kommunikasjon_med_søker.feature` |
| `@OPT-PLA-INN-001` | `14 Plasstildeling/02 Tildelingsinnstillinger/antall_tilbud_som_skal_gis.feature` |
| `@OPT-PLA-TIL-001` | `14 Plasstildeling/03 Tildeling/starte_plasstildeling.feature` |
| `@OPT-PLA-RES-001` | `14 Plasstildeling/04 Resultat/vise_resultat.feature` |
| `@OPT-PLA-RES-003` | `14 Plasstildeling/04 Resultat/se_publisert_resultat.feature` |

Stiene er under `krav/02 Opptak/`, unntatt felleskravet.

## Bakgrunn

Kartleggingen av kravene mot RLS i databasen, med reglene R1–R16, står i artefaktet [Tilgangskrav mot RLS i opptak](https://claude.ai/artifact/DZKCewPChYJRYA29tVaxiX). Svarene reglene bygger på, står i [Avklaringsmøte tilgangsregler opptak 2026-11-10](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5185372200). Scopet `tilgang-i-opptak-2027`, med anbefalingen til prosjektleder og manglene i RLS, ble fjernet 2026-11-12 og finnes i git-historikken.

En kopi av matrisen står i Confluence: [Tilgangsmatrise for opptak](https://sikt.atlassian.net/wiki/spaces/PFS/pages/5190713374), under *Roller til tilgangsstyring*. Det er denne fila som gjelder. Endres matrisen, kopieres den dit.
