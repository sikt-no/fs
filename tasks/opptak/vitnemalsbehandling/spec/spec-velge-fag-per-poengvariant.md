# Spec: Velge fag per poengvariant

## Kilde

- **Scope:** `tasks/opptak/vitnemalsbehandling/`
- **Kilde-mappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **GitHub:** [#609](https://github.com/sikt-no/fs/issues/609) (leveranse L3 i initiativet [#607](https://github.com/sikt-no/fs/issues/607))
- **Hentet:** 2026-11-12 (HEAD `d98b4e3f`, branch `fs-spec-test-l3`, oppdatert mot `origin/main`). Første kjøring 2026-11-11 (`8aca38be`).

## Omfang

Saksbehandleren velger vitnemål og fag per poengvariant, så søkeren blir riktig poengberegnet i hver kvote og til hvert søknadsalternativ. Spesifikasjonen dekker visningen av fagene på det valgte vitnemålet (med eksamensform, opprinnelig og forbedret karakter og merknader), valg av vitnemål og fag per poengvariant, endringer som hører til ett vitnemål og huskes ved bytte, poeng saksbehandleren legger inn selv, tilleggsfag og varselet om forbedringer i kvoten for førstegangsvitnemål, og grensene for hvilke fag som kan velges bort. Reglene for å beregne og bruke poengene står i L2 (`velge_vitnemål_som_grunnlag.feature`), og gjelder også her. Spesifikasjonen dekker ikke endring og manuell inntasting av fag (L4a, L4b), sammenligning av vitnemål (L5) eller varsel om nytt vitnemål (L6).

## Krav

- **`velge_fag_per_poengvariant.feature`** (`@OPT-BEH-BEH-022`, `@must`) — fagene på det valgte vitnemålet, vitnemål og fagvalg per poengvariant, endringer per vitnemål, kravelementene kontrollert mot fagvalget, ingen poeng lagret når søkeren ikke er kvalifisert, bruk av vitnemål og fagvalg i andre poengvarianter, tilleggsfag og forbedringer i kvoten for førstegangsvitnemål, poeng lagt inn selv med validering, og hvilke fag som kan velges bort (23/6-regelen). 5 regler, 25 scenarioer og scenariomaler. ([krav/…/velge_fag_per_poengvariant.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_fag_per_poengvariant.feature))

Kravet er hentet inn (`@in-progress`) 2026-11-12, etter at de to skisseavvikene og referansen til L2 er rettet med `fs-krav`.

Kravet har ingen `@draft`- eller `@deprecated`-deler.

## Avhengigheter

Kravet har `@depends-on-OPT-BEH-BEH-004` på `Egenskap:` (hele kravet bygger på hele L2):

- **`@OPT-BEH-BEH-004`** `velge_vitnemål_som_grunnlag.feature` — `@in-progress`. Brukes av hele kravet (valg av vitnemål, «Poengene beregnes og lagres når saksbehandleren bruker dem», låsing av poeng). ([krav/…/velge_vitnemål_som_grunnlag.feature](../../../../krav/02%20Opptak/13%20S%C3%B8knad%20og%20saksbehandling/02%20Behandling/velge_vitnem%C3%A5l_som_grunnlag.feature))

`@ref-OPT-BEH-BEH-020`, `@ref-OPT-BEH-BEH-023` og `@ref-OPT-BEH-BEH-037` er henvisninger, og tas ikke med.

## Skisser

### Skisse: Steg 2 Grunnlag – Behandle e-vitnemål

- **Type:** `figma`
- **Referanse:** [FS-Admin – Gjeldende skisser, «Steg 2 Grunnlag - Behandle e-vitnemål»](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-50347), node `5163:50347`. Hentet 2026-11-11.
- **Lagrede artefakter:**
  - [screenshot.png](krav-input/sketches/figma/steg-2-grunnlag-behandle-e-vitnemal/screenshot.png)
  - [sub-frames/01-kvalifisering-og-poengberegning-per-poengvariant.png](krav-input/sketches/figma/steg-2-grunnlag-behandle-e-vitnemal/sub-frames/01-kvalifisering-og-poengberegning-per-poengvariant.png)
  - [sub-frames/02-poeng-for-vitnemalsutvalg.png](krav-input/sketches/figma/steg-2-grunnlag-behandle-e-vitnemal/sub-frames/02-poeng-for-vitnemalsutvalg.png)
  - [sub-frames/03-vitnemal-og-fag.png](krav-input/sketches/figma/steg-2-grunnlag-behandle-e-vitnemal/sub-frames/03-vitnemal-og-fag.png)
  - [sub-frames/04-tilleggsfag.png](krav-input/sketches/figma/steg-2-grunnlag-behandle-e-vitnemal/sub-frames/04-tilleggsfag.png)
- **Dekker krav:** `velge_fag_per_poengvariant.feature`, reglene «Fagene på det valgte vitnemålet vises», «Vitnemålet kan velges per poengvariant», «Fagvalget gjøres per poengvariant», «Saksbehandleren kan legge inn poeng selv på en poengvariant» og «Saksbehandleren kan bare endre fagvalget slik en regel tillater».
  - **Stemmer:** tabellen «Kvalifisering og poengberegning» har én rad per poengvariant med Kompetansekrav, Grunnlag og Kvalifisert, og en avkrysning per poengvariant («Søkeren kan få ulik poengsum …», «Bruke vitnemålet og fagvalget fra én poengvariant i andre poengvarianter»).
  - **Stemmer:** «Vitnemålsutvalg <nummer>» og radioknappen under «Vitnemål» viser hvilket vitnemål poengvarianten som er valgt, bygger på («Legge ulikt vitnemål til grunn for ulike poengvarianter»). Avklart med brukeren 2026-11-11.
  - **Stemmer:** «Beregn poeng» og «Bruk poeng» (reglene fra L2), og KAR, REA og SPR kan legges inn under «Poeng for vitnemålsutvalg» («Legge inn <poengtype> selv på en poengvariant»).
  - **Stemmer:** fagene har Eks.form (Eksamensform i kravet), kolonneparet Opprinnelig/Forbedret, År (f.eks. V13) og Merknad, med «Fordypning» som merknad («Se fagene på vitnemålet», «Se opprinnelig og forbedret karakter samtidig», rettet 2026-11-12).
  - **Stemmer:** fag som inngår i vitnemålsgrunnlaget, har en avkrysning som er valgt og ikke kan endres. De andre kan velges («Ikke alle fag kan velges bort»).
  - **Stemmer:** tilleggsfag står i en egen tabell, og er ikke valgt før saksbehandleren velger dem («Tilleggsfag teller ikke før det aktivt velges»).
  - **Ulikt scope:** «Grunnlag» (VOV, VPL, PRA …), «Legg til fag», tomme rader for nye fag, redigerbare forbedrede karakterer og «NVB-kontroll» (L4a), og «Spesielle opptakskrav» (`@OPT-BEH-BEH-020`).
  - **Feil i skissen:** radioknappen står på vitnemål 498463131357, mens overskriften er «Vitnemålsutvalg 498463131356».
- **Valideringsstatus:** `OK` (2026-11-12, mot de lagrede artefaktene fra 2026-11-11). De to avvikene fra 2026-11-11 er løst ved at kravet er endret med `fs-krav`:

| # | Avvik | Beslutning | Begrunnelse / konsekvens |
|---|---|---|---|
| 1 | Kravet («Se fagene på vitnemålet») hadde feltet Fagstatus, og ikke Eks.form. Fagtabellen i skissen har Eks.form, og ikke Fagstatus. | **Skissen er riktig. Kravet må endres.** Løst 2026-11-12. | Fagstatus er tatt ut og Eksamensform lagt til i kravet. Merk at fagstatus (elev eller privatist) fortsatt avgjør «Kravelementene vurderes per grunnlag» (privatist etter fylte 21 år), selv om den ikke vises i fagtabellen. |
| 2 | Kravet («Se opprinnelig og forbedret karakter samtidig») sa at det går fram hvilken karakter som inngår i beregningen. Skissen viser begge, men ikke hvilken som inngår. | **Skissen er riktig. Kravet må endres.** Løst 2026-11-12. | Hvilken karakter som inngår, vises først når saksbehandleren har valgt «Beregn poeng». Steget er tatt ut av scenarioet. |

- **Ikke skissert:** varselet om forbedringer i poengvarianten for kvoten for førstegangsvitnemål, beskjeden om ugyldig verdi for poeng lagt inn selv, valget av hvilke andre poengvarianter vitnemålet og fagvalget skal brukes på (avkrysningen per poengvariant kan være ment for det), og tilstanden der søkeren ikke er kvalifisert og poengene ikke lagres.

## Kodesjekk

- **Sjekket:** fs-plattform (`736597af28`) og fs-admin (`a8f623325`), begge oppdatert fra `origin/main` 2026-11-12. Første sjekk 2026-11-11 (`000e038ae2` og `69691a232`).
- **Stemmer:** Eksamensform, som kom inn i kravet 2026-11-12, finnes i KREG (`eksamensformkode` i `nvb2.vgdokfag`, `fs-plattform/kreg/kreg-migrations/src/main/resources/db/migration/V1_019__test_vitnemaal.sql:5`), og vises allerede i fagtabellen for vitnemål i fs-admin (`fs-admin/src/domains/soknadsbehandling/features/VgsDokumentView/components/VgsDokumentFagTabell/VgsDokumentFagTabell.tsx:116`).
- **Stemmer:** fagvalget er per vitnemål og poengvariant (`soknadsbehandling.vgs_dokument_fag_aktiv`, nøkkel med `vgdoknr`, `fagkode` og `poengvariant_kode`, `fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V291__saksbehandling_skjema.sql:925`), så endringer per vitnemål kan huskes. Poeng per poengvariant har vitnemålet de bygger på, og kan låses mot automatikken (`sak_poeng.vgdoknr` og `la_staa`, `V291__saksbehandling_skjema.sql:611`, `:646`, `:651`). Merknader kan knyttes til et fag (`kompetanse.vgs_dokument_merknad.fagkode`, `V176__kompetanse_vgs.sql:221`).
- `@OPT-BEH-BEH-022`: kravet sier at saksbehandleren ser opprinnelig og forbedret karakter for samme fag, at tilleggsfag ikke teller før de velges, og at bare fag merket som valgbare kan velges bort. Koden lagrer ikke grunnlaget for det: `kompetanse.vgs_dokument_fag` har nøkkelen `(vgdoknr, fagkode)`, så et fag kan bare stå én gang per vitnemål, og verken forbedring, tillegg eller valgbar lagres (`fs-plattform/opptak/opptak-migrations/src/main/resources/db/migration/V176__kompetanse_vgs.sql:144`, `V271__vgs_dokument_fag_linjenr_ikke_unik.sql`). KREG har opplysningene (`status_forbedring` og `status_tillegg` i `nvb2.vgdokfag`, `faginfokode` på `KregFag` i `fs-plattform/kreg/kreg-graphql/src/main/resources/schema/features/experimental/schema.graphql:553`). **Koden skal endres:** opptak må lagre forbedring og tillegg fra KREG.

## Retagging

| Fil | Før | Etter |
|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/velge_fag_per_poengvariant.feature` | `@OPT-BEH-BEH-022 @must @planned @depends-on-OPT-BEH-BEH-004` | `@OPT-BEH-BEH-022 @must @in-progress @depends-on-OPT-BEH-BEH-004` |

Holdt tilbake 2026-11-11 (to skisseavvik), retagget 2026-11-12 etter `fs-krav`. Kodeavviket hindrer ikke retaggingen: koden skal endres.

## Åpne spørsmål

- [x] **Skisseavvik 1 (krav mangler), fagfeltene:** I «Se fagene på vitnemålet» skal Fagstatus ut og Eks.form inn (`fs-krav`).
  - **Beslutning (2026-11-12, `fs-krav`):** Fagstatus er tatt ut, og Eksamensform (ordet i `vise_elektroniske_vitnemål.design.md`) er lagt til.
- [x] **Skisseavvik 2 (krav mangler), karakteren som inngår:** «Se opprinnelig og forbedret karakter samtidig» må si at det går fram hvilken karakter som inngår, først etter at saksbehandleren har valgt «Beregn poeng» (`fs-krav`).
  - **Beslutning (2026-11-12, `fs-krav`):** steget «Og det fremgår hvilken av dem som inngår i beregningen» er tatt ut. Scenarioet er ellers uendret, og det er ikke lagt til et eget scenario for visningen etter «Beregn poeng».
- [x] **Referansen til L2 mangler:** kravet bygger på `@OPT-BEH-BEH-004` ifølge kommentarene, men har ikke `@depends-on-OPT-BEH-BEH-004` (`fs-krav`).
  - **Beslutning (2026-11-12, `fs-krav`):** `@depends-on-OPT-BEH-BEH-004` er satt på `Egenskap:`, uten anker.
- [ ] **Scopet:** L3 står under «Ikke-mål» i `scope.md`, og kravet har ikke `@scope-vitnemalsbehandling`. Oppdater scopet med `fs-scope` (mål, krav-tabellen med Jira [#609](https://github.com/sikt-no/fs/issues/609) og skissen, og taggen).
- [ ] **Implementasjonsdetaljer mangler** for `velge_fag_per_poengvariant.feature`. `velge_fag_per_poengvariant.design.md` finnes ikke, og kravet viser til den for teksten i varselet om forbedringer i kvoten for førstegangsvitnemål. Kjør `fs-implementasjonsdetaljer` med skissen over (utsatt 2026-11-11 og 2026-11-12).
- [ ] **Ikke skissert:** varselet om forbedringer i kvoten for førstegangsvitnemål, beskjeden om ugyldig verdi, valget av hvilke poengvarianter vitnemålet og fagvalget skal brukes på, og tilstanden der søkeren ikke er kvalifisert.

## Rute

fs-plattform → fs-admin
