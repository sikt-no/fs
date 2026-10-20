# Eksempler: referanser og flyter i praksis

Vedlegg til [forslag-flyter-og-referanser.md](forslag-flyter-og-referanser.md). Tre koblinger fra `02 Opptak`, og hvordan de blir løst med `@depends-on-<Feature-ID>`, `@ref-<Feature-ID>` og flyter i `krav/_Flyter`.

Testen for typen: **Må denne delen sjekkes hvis kravet det pekes på, endres?** Svarer du ja, er det `@depends-on-`. Ellers er det `@ref-`.

Mappene i `02 Opptak` som nevnes:

| Mappe | Innhold |
|---|---|
| 11 | Opprette og vedlikeholde opptak |
| 12 | Utdanningstilbud |
| 13 | Søknad og saksbehandling |
| 14 | Plasstildeling |

## Eksempel 1: Innstillinger for opptak viser til 12, 13 og 14

### Situasjonen i dag

Innstillinger for opptak (`@OPT-OVO-INN-001`, mappe 11) viser til de tre andre mappene. Alle henvisningene er fritekst:

- **Tidlig opptak** (linje 84–89): tidlig opptak må være slått på både på opptaket og på utdanningstilbudet (`opptaksinnstillinger_utdanningstilbud.feature` i 12) før søkeren kan søke (`søke_om_tidlig_opptak.feature` i 13). Henvisningen er en sti i en `# AVKLART`-kommentar.
- **Taket** (linje 98–102): taket for antall tilbud per tildelingsrunde settes på opptaket, og virkningen i plasstildelingen står i `gjennomføre_plasstildeling.feature` (14). Kommentaren blander historikk («Det erstatter regelen fra 2026-10-14 …») og en henvisning.
- **Poenglikhet** (linje 31–32): henvisningen er til hele mappa `14 Plasstildeling/`, ikke til et krav.

Henvisningene er av to slag. Tidlig opptak er en avhengighet: søknaden virker ikke uten innstillingene. Taket og poenglikheten er grenser: «virkningen står der».

### Med forslaget

**Avhengighetene** står der kravet bygger på et annet. Søknaden bygger på innstillingene for opptak og på utdanningstilbudet, så taggene står i søknadskravet, ikke i innstillingene.

`13 …/01 Søknad/søke_om_tidlig_opptak.feature`:

```gherkin
  @depends-on-OPT-OVO-INN-001 @depends-on-OPT-OPT-UTD-004
  Regel: Søkeren kan søke om tidlig opptak når opptaket tilbyr det
    # Tidlig opptak må være slått på både på opptaket og på utdanningstilbudet.
```

`12 …/opptaksinnstillinger_utdanningstilbud.feature` (et utdanningstilbud kan bare tilby tidlig opptak når opptaket åpner for det):

```gherkin
  @depends-on-OPT-OVO-INN-001
  Regel: Opptaksforvalter kan markere at et utdanningstilbud tilbyr tidlig opptak
```

**Grensene** er henvisninger for den som leser innstillingene. Endres plasstildelingen, må ikke innstillingene på opptaket sjekkes, så det er `@ref-`.

`11 …/innstillinger.feature`:

```gherkin
  # Taket er obligatorisk, er forhåndsutfylt med 1, og kan endres etter at opptaket er opprettet.
  # Virkningen i plasstildelingen står i 14 Plasstildeling/03 Tildeling/gjennomføre_plasstildeling.feature.
  @ref-OPT-PLA-TIL-002
  Regel: Opptaksforvalter setter tak for antall tilbud per tildelingsrunde

  @ref-OPT-PLA-TIL-002
  Regel: Opptaksforvalter setter standard poenglikhetsregel for opptaket
    # Poenglikhetsregel for ledige studieplasser styres av rundetypen.
```

Historikken («Det erstatter regelen fra 2026-10-14 om hvor mange utdanningstilbud en søker kan få opptak til») er ikke en referanse. Den blir en kommentar, eller står bare i git-historikken.

### Slik finner du koblingene

| Spørsmål | Svar |
|---|---|
| Hvilke krav må sjekkes når innstillingene for opptak endres? | `grep -rn "@depends-on-OPT-OVO-INN-001" krav/` gir søknaden (13) og utdanningstilbudet (12) |
| Hvor er grensen mot plasstildelingen? | `@ref-` og kommentaren på regelen i 11 |
| Hva må testes når innstillingene endres? | `npx playwright test --grep @depends-on-OPT-OVO-INN-001` |

### Vurdering

**Løst med forslag 1. Det trengs ingen flyt.** Eksempelet viser hvorfor det trengs to typer: avhengighetene og grensene står i samme fil i dag, men betyr forskjellige ting. Med `@ref-` på grensene kommer ikke plasstildelingen med når noen sjekker hva som påvirkes av innstillingene.

`@depends-on-` og `@ref-` peker på hele kravet. Gjelder referansen én regel, står regeltittelen i kommentaren under.

## Eksempel 2: Standard plassflyt og kvoteprioritet brukes av 12 og 14

### Situasjonen i dag

Standard plassflyt og kvoteprioritet (`@OPT-OVO-INN-002` og `@OPT-OVO-INN-003`, mappe 11) settes på opptaket. De brukes to steder:

- `plassflyt.feature` (`@OPT-PLA-INN-002`, 14) beskriver hva plasstildelingen gjør med plassflyten. Kvoteprioriteten brukes i `gjennomføre_plasstildeling.feature` (`@OPT-PLA-TIL-002`, 14).
- `opptaksinnstillinger_utdanningstilbud.feature` (`@OPT-OPT-UTD-004`, 12) viser plassflyten og kvoteprioriteten på utdanningstilbudet.

Henvisningene er stier i kommentarer, i begge retninger (`sette_plassflyt.feature` linje 9–10, `plassflyt.feature` linje 9–11, `opptaksinnstillinger_utdanningstilbud.feature` linje 55–63). Endrer vi hvordan plassflyten settes i opptaket, påvirker det plasstildelingen direkte. I dag finnes det ikke noe sted som sier hvilke krav som må sjekkes når det skjer.

### Med forslaget

Kravene som bruker plassflyten og kvoteprioriteten, bygger på kravene der de settes.

`14 …/02 Tildelingsinnstillinger/plassflyt.feature`:

```gherkin
@OPT-PLA-INN-002 @must @draft @scope-plasstildeling-2027 @depends-on-OPT-OVO-INN-002
Egenskap: Plassflyt mellom utdanningskvoter
```

`14 …/03 Tildeling/gjennomføre_plasstildeling.feature`:

```gherkin
  @depends-on-OPT-OVO-INN-003
  Regel: Søkeren prøves i utdanningskvotene etter kvoteprioritet
```

`12 …/opptaksinnstillinger_utdanningstilbud.feature`:

```gherkin
  @depends-on-OPT-OVO-INN-002 @depends-on-OPT-OVO-INN-003
  Regel: Lærestedene ser plassflyten og kvoteprioriteten for utdanningstilbudene sine
```

Hele kravet om plassflyt bygger på standard plassflyt, så taggen står på `Egenskap:`. I de to andre kravene gjelder den én regel, og står der.

Kravet der plassflyten settes, har i dag kommentaren «Hva plasstildelingen gjør med plassflyten, står der». Den blir en `@ref-` for den som leser. Endres plasstildelingen, må ikke innstillingen sjekkes.

`11 …/03 Innstillinger/sette_plassflyt.feature`:

```gherkin
@OPT-OVO-INN-002 @must @draft @scope-kvoter-i-opptaket-2027 @ref-OPT-PLA-INN-002
Egenskap: Sette standard plassflyt for opptaket
```

### Slik finner du hva som påvirkes

Før standard plassflyt endres:

```bash
grep -rn "@depends-on-OPT-OVO-INN-002" krav/
# 14 …/plassflyt.feature                             (Egenskap)
# 12 …/opptaksinnstillinger_utdanningstilbud.feature (Regel: Lærestedene ser plassflyten …)

npx playwright test --grep @depends-on-OPT-OVO-INN-002
```

`fs-krav` gjør det samme når et krav endres. Når et levert krav endres, eller et krav fjernes, lister skillen kravene med `@depends-on-` til det, og spør om de også må endres.

### Vurdering

**Løst med forslag 1.** Dette er eksempelet der referansene gir mest: en konsekvensanalyse som i dag ikke finnes. Med to typer gir den bare kravene som må sjekkes. Henvisningen tilbake fra `sette_plassflyt.feature` kommer ikke med.

Plassflyten er ikke en flyt i forslagets betydning, bare noe opptaket setter og andre bruker. Den inngår i flyten `klargjøre_opptaket` (plassflyten settes) og i `fra_søknad_til_studieplass` (plassflyten brukes), men sammenhengen står i referansene.

## Eksempel 3: Tidlig opptak går gjennom alle mappene

### Situasjonen i dag

Tidlig opptak går gjennom alle de fire mappene:

| Mappe | Krav |
|---|---|
| 11 | Innstillinger (`@OPT-OVO-INN-001`) og frister (`@OPT-OVO-FRI-001`) |
| 12 | Utdanningstilbudet (`@OPT-OPT-UTD-004`) |
| 13 | Søknad (`@OPT-SØK-SØK-011`), vurdering (`@OPT-BEH-BEH-009`, `@OPT-BEH-BEH-013`), tilbudsgaranti (`@OPT-BEH-BEH-007`), svar (`@OPT-BEH-BEH-014`, `@OPT-SØK-SØK-012`) |
| 14 | Plasstildelingen (`@OPT-PLA-TIL-002`) |

Plasstildelingen skal lese tilbudsgarantien fra tidligopptaket i hovedopptaket (STEK-263), og det er ikke på plass ennå. Begge sidene av overleveringen er beskrevet som krav:

- `gi_tilbudsgaranti_ved_tidlig_opptak.feature`, `Regel: Tilbudsgarantien gjelder i hovedopptaket` (13)
- `gjennomføre_plasstildeling.feature`, `Regel: Søker med tilbudsgaranti får tilbud uavhengig av poengsum` (14). Regelen sier selv at tilbudsgarantien fra saksbehandlingen ikke når plasstildelingen i koden.

Det finnes ikke noe sted som viser hele løpet, eller at det brytes mellom 13 og 14.

### Med forslaget

En flyt i `krav/_Flyter/10 Opptaksløpet/tidlig_opptak.feature`. Hver fase bygger på kravene sine med `@depends-on-`:

```gherkin
# language: no
@FLY-OPT-TID-001 @should @draft @e2e
Egenskap: Tidlig opptak
  Søkeren søker tidlig opptak, får søknaden vurdert, får tilbudsgaranti,
  og får tilbud i hovedopptaket.
  # Kjent brudd: STEK-263, tilbudsgarantien fra tidligopptaket leses ikke i hovedopptaket.

  @depends-on-OPT-OVO-INN-001 @depends-on-OPT-OVO-FRI-001 @depends-on-OPT-OPT-UTD-004
  Regel: Opptaket og utdanningstilbudet åpner for tidlig opptak
    Scenario: Søkeren kan søke tidlig opptak
      Gitt opptaket åpner for tidlig opptak
      Og utdanningstilbudet tilbyr tidlig opptak
      Når søknadsfristen for tidlig opptak er åpen
      Så kan søkeren søke tidlig opptak på utdanningstilbudet

  @depends-on-OPT-SØK-SØK-011 @depends-on-OPT-BEH-BEH-009 @depends-on-OPT-BEH-BEH-013
  Regel: Søknaden om tidlig opptak vurderes
    Scenario: Søkeren deltar i tidligopptaket
      Gitt søkeren har søkt tidlig opptak
      Når saksbehandleren konkluderer at søkeren deltar i tidligopptaket
      Så er søkeren med når tidligopptaket gjennomføres

  @depends-on-OPT-BEH-BEH-007
  Regel: Søkeren får tilbudsgaranti
    Scenario: Søkeren får tilbudsgaranti fra tidligopptaket
      Gitt søkeren er med i tidligopptaket og har nok poeng
      Når opptaksforvalteren gjennomfører tidligopptaket
      Så har søkeren tilbudsgaranti på søknadsalternativet

  @depends-on-OPT-BEH-BEH-014 @depends-on-OPT-SØK-SØK-012
  Regel: Søkeren får svar på tidlig opptak
    Scenario: Søkeren ser tilbudsgarantien
      Gitt søkeren har tilbudsgaranti fra tidligopptaket
      Når svaret på tidlig opptak publiseres
      Så ser søkeren tilbudsgarantien

  @depends-on-OPT-BEH-BEH-007 @depends-on-OPT-PLA-TIL-002
  Regel: Tilbudsgarantien gir tilbud i hovedopptaket
    # BEH-BEH-007: Regel: Tilbudsgarantien gjelder i hovedopptaket
    # PLA-TIL-002: Regel: Søker med tilbudsgaranti får tilbud uavhengig av poengsum
    Scenario: Søkeren med tilbudsgaranti får tilbud i hovedopptaket
      Gitt søkeren har tilbudsgaranti fra tidligopptaket
      Når plasstildelingen i hovedopptaket gjennomføres
      Så får søkeren tilbud på søknadsalternativet
```

### Slik ser du hvor løpet brytes

- **Uten app:** fremdriften for hver fase slås opp fra kravene fasen bygger på. Fase 2–4 er `@in-progress`. Fase 1 bygger på `@OPT-OPT-UTD-004`, og fase 5 på `@OPT-PLA-TIL-002`, og begge er `@draft`. Fremdriften er «3 av 5 faser», og løpet brytes ved utdanningstilbudet og i hovedopptaket.
- **Hvilke flyter går gjennom plasstildelingen?** `grep -rln "@depends-on-OPT-PLA-TIL-002" krav/_Flyter/`.
- **Planlegging:** når `fs-specify` henter flyten inn i en oppgave, sier den fra at fase 1 og 5 bygger på krav som er `@draft`.
- **Som test:** scenarioet i fase 5 kjøres som `@e2e`, og feiler til STEK-263 er løst.

### Vurdering

**Løst med forslag 2.** Eksempelet viser at et brudd i overleveringen kan skjules av kravene.

Når `@OPT-BEH-BEH-007` og `@OPT-PLA-TIL-002` begge er `@implemented`, ser fase 5 levert ut. Likevel kan løpet være brutt:

- Testen for tilbudsgarantien sjekker at garantien blir satt.
- Testen for plasstildelingen setter opp en tilbudsgaranti selv, og sjekker at den gir tilbud.

Begge testene går grønt, men ingen av dem sjekker at garantien fra tidligopptaket faktisk når plasstildelingen. Det er akkurat det STEK-263 handler om. Bare flyten tester overleveringen.

Derfor har en flyt **to statuser**:

| Status | Kommer fra | Sier |
|---|---|---|
| Fremdrift | Statusen på kravene flyten bygger på | «3 av 5 faser levert» |
| Flytens egen status | Taggen på flyten (`@draft` → … → `@implemented`), satt av `fs-verify` når scenarioene i flyten er verifisert | at overleveringene virker |

Først når begge er ferdige, er løpet levert.

## Hva eksemplene lærer oss

| Funn | Eksempel | I forslaget |
|---|---|---|
| Referansene er av to slag: avhengigheter og henvisninger. Blandes de, blir konsekvensanalysen upresis | 1, 2 | To typer: `@depends-on-` og `@ref-` |
| Retningen gir seg selv av hvor taggen står. Den motsatte retningen finnes med `grep` | 1, 2 | `@depends-on-` settes bare der delen bygger på kravet |
| Historikk («flyttet», «ID endret») er ikke en referanse | 1 | *Det som ikke er en referanse* |
| Referansene peker på hele kravet. Regelen står i en kommentar, og det blir grovt for store krav som `gi_tilbudsgaranti_ved_tidlig_opptak.feature` (over 400 linjer) | 1, 3 | Kjent begrensning |
| `@depends-on-` gir en konsekvensanalyse som ikke finnes i dag, også uten app | 2 | `fs-krav` lister kravene med `@depends-on-` når et krav endres eller fjernes |
| Et brudd i overleveringen kan skjules av kravene, og bare flyten tester den | 3 | Flyten har egen status, verifisert av `fs-verify`, i tillegg til fremdriften |
| Kjente brudd (som STEK-263) står i en kommentar på flyten | 3 | Under forslag 2 |
| Eksempel 1 og 2 trenger ingen flyt. Referanser er nok når ett krav bruker et annet | 1, 2 | Bekrefter terskelen |
