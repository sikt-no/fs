# Manifest — krav-input

- **Kildemappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **Hentet:** 2026-10-28 (L1 og L2), 2026-11-11 og 2026-11-12 (L3)
- **HEAD:** `ef68c3a` (branch `main`, L1 og L2), `d98b4e3f` (branch `fs-spec-test-l3`, L3, 2026-11-12; første kjøring `8aca38be`)

## Filer med i scope

Kravene kopieres ikke. Kravet slik det var da spesifikasjonen ble laget, finnes i git på SHA-en over.

| Fil | Feature-ID | Status ved henting | Spec |
|---|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature` | `@OPT-BEH-BEH-005` | `@must @in-progress` | `spec-vise-elektroniske-vitnemal.md` |
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/velge_vitnemål_som_grunnlag.feature` | `@OPT-BEH-BEH-004` | `@must @in-progress` | `spec-velge-vitnemal-som-grunnlag.md` |
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/velge_fag_per_poengvariant.feature` | `@OPT-BEH-BEH-022` | `@must @planned` → `@in-progress` 2026-11-12 | `spec-velge-fag-per-poengvariant.md` |

Begge ble satt til `@in-progress` for hånd 21.10.2026 (commit `ccafff0`), etter beslutning i teamet. L3 ble holdt tilbake som `@planned` 2026-11-11, fordi to skisseavvik krevde endringer i kravteksten, og ble retagget `@in-progress` 2026-11-12 etter `fs-krav`. Ingen av kravene har `@draft`- eller `@deprecated`-deler.

`local/` inneholder en råkopi av L1 fra 2026-09-30. Den er utdatert og brukes ikke lenger.

## Skisser

### Figma: Steg 2 Grunnlag – Behandle e-vitnemål (L3, fra 2026-11-11)

- **URL:** https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-50347
- **fileKey:** `dlG13wATArPvG69oePHPeL`
- **Node:** `5163:50347`, rammen «Steg 2 Grunnlag - Behandle e-vitnemål» (1933×5147). Samme ramme som `gjeldende-skisser/sub-frames/01-…`, hentet på nytt med detaljutsnitt.
- **Hentet:** 2026-11-11 (validert på nytt mot de lagrede artefaktene 2026-11-12, uten ny henting)
- **Lagrede artefakter** (`sketches/figma/steg-2-grunnlag-behandle-e-vitnemal/`):
  - `screenshot.png`: hele rammen (902×2400)
  - `sub-frames/01-kvalifisering-og-poengberegning-per-poengvariant.png` (node `5163:50500`)
  - `sub-frames/02-poeng-for-vitnemalsutvalg.png` (node `5163:50498`): «Beregn poeng», «Bruk poeng» og poengfeltene
  - `sub-frames/03-vitnemal-og-fag.png` (node `5163:50584`): vitnemålsutvalget med fagene, Opprinnelig/Forbedret og Merknad
  - `sub-frames/04-tilleggsfag.png` (node `5163:50842`)
- **Hoppet over:**
  - `get_metadata`: hentet, men for stort til å lagres som `design-context.md` (155 000 tegn). Brukt til å finne rammene og tekstene.
  - `get_design_context`, `get_variable_defs` og `download_assets`: valideringen gjelder innhold, ikke kode eller designvariabler.
  - «Grunnlag» (`5163:50430`), «Melding om mangel» (`5163:50440`) og «Fagprofil»/«Spesielle opptakskrav» (`5163:51041`): utenfor L3.

### Figma: Gjeldende skisser, «Nyeste skisser» (brukes fra 2026-10-21)

- **URL:** https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344
- **fileKey:** `dlG13wATArPvG69oePHPeL`
- **Node:** `5163:45344`, seksjonen «Nyeste skisser» på siden «Vitnemålsbehandler» (14697×7672)
- **Hentet:** 2026-10-28 (første gang 2026-10-21; rammene er hentet på nytt per node, og de gamle utklippene er erstattet)
- **Lagrede artefakter** (`sketches/figma/gjeldende-skisser/`):
  - `screenshot.png`: hele seksjonen (3000×1574)
  - `sub-frames/01-steg-2-grunnlag-behandle-e-vitnemal.png` (node `5163:50347`)
  - `sub-frames/02-visning-av-vitnemal.png` (node `5179:22607`): et vitnemål åpnet i ny fane
  - `sub-frames/03-annullert-vitnemal.png` (node `5836:22668`)
  - `sub-frames/04-annullert-vitnemal-lagt-til-grunn-fra-for.png` (node `5836:23318`)
  - `sub-frames/05-annullert-vitnemal-lagt-til-grunn-fra-for-kun-leserettighet.png` (node `5836:23547`)
  - `sub-frames/06-outer-frame-sammenligne-vitnemal.png` (node `5163:49881`): sammenligning av vitnemål (L5, utenfor scope)
- **Hoppet over:**
  - «bilde 1» (`5163:50346`): et bilde av FS-klienten, ikke en ramme.
  - `get_metadata` og `get_design_context`: svaret er for stort. Rammene er listet med et lesende Plugin API-kall.
  - `get_variable_defs` og `download_assets`: valideringen gjelder innhold, ikke designvariabler.

### Figma: Målbilde vitnemålsbehandleren, steg 2 (erstattet)

- **URL:** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20402-102594
- **fileKey:** `LmoNQlmAuE2FlE0fUo5GoO`
- **Node:** `20402:102594`, siden «Vitnemålsbehandleren», seksjonen «MÅLBILDE» (`21388:111761`)
- **Scope:** de fem steg 2-rammene. Hentet 2026-09-30 og gjenbrukt 2026-10-21 uten ny henting.
- **Lagrede artefakter** (`sketches/figma/malbilde-steg-2/`):
  - `screenshot.png`: hele seksjonen MÅLBILDE
  - `sub-frames/01-steg-2-grunnlag-ingen-e-vitnemal.png` (node `21388:113858`)
  - `sub-frames/02-steg-2-grunnlag-vitnemal-apen-auto-tabellrad.png` (node `21388:114364`)
  - `sub-frames/03-steg-2-grunnlag-legg-inn-vitnemal-manuelt.png` (node `21388:112060`)
  - `sub-frames/04-steg-2-grunnlag-behandle-e-vitnemal.png` (node `21388:112861`)
  - `sub-frames/05-steg-2-1240px.png` (node `21388:116625`)
  - `design-context.md`
- **Hoppet over:** `get_variable_defs` og `download_assets` (ikke kravrelevante, se 2026-09-30).
