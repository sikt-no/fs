# Spec: Grunnleggende brukeradministrasjon (personbrukere)

## Kilde

- **Type:** `lokal`
- **Lokal kilde:**
  - **Kilde-mappe (repo-relativ):** `krav/07 Brukeradministrasjon og tilgangsstyring/12 Brukeradministrasjon/personbrukere/1 - Grunnleggende brukeradministrasjon`
  - **Repo:** `sikt-no/fs` (lokal klon)
- **Relatert issue:** [sikt-no/fs#350](https://github.com/sikt-no/fs/issues/350)
- **Hentet:** 2026-07-07 11:59
- **Filter:** kun `@planned` på `Egenskap:`-nivå. 5 av 7 filer passerte; 2 ble filtrert bort (`@draft`, se nedenfor).

## Krav

Fem `@planned`-features utgjør scope for denne iterasjonen. Hver bullet peker på den lagrede kopien i `krav-input/local/` (autoritativ tekst).

- **`søke_opp_bruker.feature`** (BRU-PER-GRU-001, [#479](https://github.com/sikt-no/fs/issues/479)) — Listevisning og søk i personbrukere: liste med Navn, Feide-ID, Organisasjon, Status; sortering (navn stigende default + tie-break navn→Feide-ID); paginering «50 + last inn flere»; to fritekst-søk (navn / Feide-ID); filtre på **status, organisasjon, rolle og miljø**; synlighet via brukeradministrator-/super-brukeradministrator-rettigheter. ([krav-input/local/søke_opp_bruker.feature](krav-input/local/søke_opp_bruker.feature))
- **`se_brukers_tilganger.feature`** (BRU-PER-GRU-002, [#480](https://github.com/sikt-no/fs/issues/480)) — Se en personbrukers tildelte roller og tilganger på detaljsiden (Navn, Status, Organisasjon, Tildelt av, Tildelt dato), skille aktive/inaktive, og filtrering på navn/status/organisasjon. ([krav-input/local/se_brukers_tilganger.feature](krav-input/local/se_brukers_tilganger.feature))
- **`tildele_og_fjerne_tilganger.feature`** (BRU-PER-GRU-003, [#481](https://github.com/sikt-no/fs/issues/481)) — Tildele og fjerne roller og tilganger (enkeltvis, flere samtidig, delvis suksess), alt sporbart i historikk. ([krav-input/local/tildele_og_fjerne_tilganger.feature](krav-input/local/tildele_og_fjerne_tilganger.feature))
- **`aktivere_og_deaktivere_bruker.feature`** (BRU-PER-GRU-004, [#482](https://github.com/sikt-no/fs/issues/482)) — Deaktivere og senere reaktivere en personbrukers samlede tilganger; deaktivering fryser (fjerner ikke) tildelingene, og er sporbart. ([krav-input/local/aktivere_og_deaktivere_bruker.feature](krav-input/local/aktivere_og_deaktivere_bruker.feature))
- **`se_detaljer.feature`** (BRU-PER-GRU-007, GitHub TBD) — Se detaljer for en personbruker organisert i datagrupper (Navn, Feide-ID, Organisasjon, Status). ([krav-input/local/se_detaljer.feature](krav-input/local/se_detaljer.feature))

### Utenfor scope (filtrert bort, `@draft`)

- `sette_stedkoder_for_tilgang.feature` (BRU-PER-GRU-005, #483) og `sette_tidsbegrensning_for_tilgang.feature` (BRU-PER-GRU-006, #484) er `@draft` og utsatt til senere versjon (jf. commit «utsett stedkoder og tidsbegrensning til senere versjon»). `@draft`-scenarioer for tidsbegrensning/stedkoder inne i de fem planned-featurene er tilsvarende utenfor scope.

## Skisser

### Skisse: Brukeradministrasjon v 1.0 (Figma)

- **Type:** `figma`
- **Referanse:** [FS-Admin – Målbilde, node 4551:5331](https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---M%C3%A5lbilde?node-id=4551-5331)
- **Lagrede artefakter:** [screenshot.png](krav-input/sketches/figma/brukeradministrasjon-malbilde/screenshot.png), [design-context.md](krav-input/sketches/figma/brukeradministrasjon-malbilde/design-context.md), og 10 sub-frame-screenshots i [sub-frames/](krav-input/sketches/figma/brukeradministrasjon-malbilde/sub-frames) (liste, 3 detaljfaner, 6 modaler). Design-tokens/assets ikke hentet i spec-fasen.
- **Dekker krav (per sub-frame):**
  - `01-personbrukere-liste` → BRU-PER-GRU-001
  - `02-detaljside-detaljer` → BRU-PER-GRU-007
  - `03-detaljside-tilganger` + `04-detaljside-roller` → BRU-PER-GRU-002
  - `05-tildele-tilgang-modal`, `06-tildele-rolle-modal`, `07-fjerne-tilgang-modal`, `08-fjerne-rolle-modal` → BRU-PER-GRU-003
  - `09-deaktiver-bruker-modal`, `10-aktiver-bruker-modal` → BRU-PER-GRU-004
- **Valideringsstatus:**
  - BRU-PER-GRU-007 (detaljer): `OK` — Navn/Feide-ID/Status/Organisasjon; ingen «Sist brukt» (korrekt utsatt).
  - BRU-PER-GRU-002 (tilganger/roller): `OK` — alle planlagte felt + filtre (Navn/Organisasjon/Status); ingen tid/stedkode-kolonner (korrekt utsatt). Kolonnerekkefølge i skissen avviker fra tabellen i kravet, men alle felt finnes.
  - BRU-PER-GRU-004 (aktiver/deaktiver): `OK` — bekreftelsesmodaler for de-/reaktivering.
  - BRU-PER-GRU-001 (liste): `Avvik løst` — skissen har to separate søkefelt (Navn + Feide-ID) og et Miljø-filter. Begge er nå innarbeidet i kravet (se Åpne spørsmål #1/#2 for beslutningene).
  - BRU-PER-GRU-003 (tildele/fjerne): `Avvik løst / delvis uavklart` — modalene viser Organisasjon/Miljø/Navn-velgere. «Miljø» er bekreftet som reelt begrep. Selve valg-dialogen (og om fler-valg støttes) er ikke beskrevet i kravet — se Åpne spørsmål #3.

## Åpne spørsmål

Kravspørsmål som `bat-analyze`/`bat-krav`/design bør følge opp. (Tekniske spørsmål hører hjemme i `analysis-*.md`.)

- [x] **1 — Søk i listen:** Kravet hadde ett fritekst-søk (navn ELLER Feide-ID); skissen har to separate filterfelt. **Beslutning:** produkteier oppdaterte `søke_opp_bruker.feature` til to separate søkefelt (`Fritekst-søk på navn` + `Fritekst-søk på Feide-ID`) + `Kombinere søk og filtre`. Skisse og krav er i samsvar.
- [x] **2 — Miljø-filter i listen:** Skissens modaler viste et «Miljø»-felt som ikke sto i kravet. **Beslutning:** produkteier bestemte at listen skal ha et Miljø-filter på linje med Rolle-filteret; lagt til via `skrive-krav` (`Tilgjengelige miljøer i filter` + `Filtrere på miljø`).
- [x] **3 — Tildele/fjerne-dialog (BRU-PER-GRU-003):** Modalene viser velgere for Organisasjon, Miljø og Navn. **Beslutning:** «Navn»-velgeren er fler-valg — Organisasjon + Miljø avgrenser utvalget, og «Navn» lar administrator velge flere tilganger/roller å tildele/fjerne i én operasjon. Dette dekker «Tildele flere roller og tilganger samtidig» + «Delvis suksess». Detaljert dialog-UX utdypes i design/utdype-implementasjon.
- [x] **4 — «Miljø»-begrepet for personbruker-tilganger:** **Beslutning:** samme konsept som i applikasjoner-domenet (driftsmiljø, f.eks. demo/prod); lovlige miljø-verdier hentes fra samme kilde som i applikasjoner. Gjelder både liste-filteret og tildele/fjerne-dialogen — `bat-analyze`/subgraph bekrefter konkret felt/kilde mot faktisk schema.
- [x] **5 — Sidestørrelse:** **Beslutning:** kravets 50 per side gjelder; skissens «Viser 10 av 67» er illustrativt. Ingen krav-endring.
- [ ] **6 — Presentasjon av tilganger (BRU-PER-GRU-002):** Skal direkte tildelte tilganger skilles fra tilganger som kommer via en rolle (kilde-merking / utfolding)? **Beslutning:** bevisst utsatt til designfasen (produkteier). Forblir åpent for design/utdype-implementasjon.
- [x] **7 — Autorisasjonsregel for tildeling (BRU-PER-GRU-003):** **Beslutning:** avgrenses kun på (a) — en brukeradministrator kan tildele tilganger som gjelder ved en organisasjon de administrerer. (b)-betingelsen (at administrator selv har/kan administrere tilgangen) tas ikke med i v1. Endelig regel koordineres med rolledefinisjonsarbeidet i «4 - Opprette og administrere roller».
- [x] **8 — Rolle-navn:** **Beslutning:** «brukeradministrator» / «super-brukeradministrator» er bekreftet og står ved lag.
