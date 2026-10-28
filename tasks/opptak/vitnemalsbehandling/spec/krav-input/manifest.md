# Manifest — krav-input

- **Kildemappe:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/`
- **Hentet:** 2026-10-21
- **HEAD:** `ccafff0b5cc1705af39114091855491a19485982` (branch `vitnemalsbehandling-spec`)

## Filer med i scope

Kravene kopieres ikke. Kravet slik det var da spesifikasjonen ble laget, finnes i git på SHA-en over.

| Fil | Feature-ID | Status ved henting | Spec |
|---|---|---|---|
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/vise_elektroniske_vitnemål.feature` | `@OPT-BEH-BEH-005` | `@must @in-progress` | `spec-vise-elektroniske-vitnemal.md` |
| `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/velge_vitnemål_som_grunnlag.feature` | `@OPT-BEH-BEH-004` | `@must @in-progress` | `spec-velge-vitnemal-som-grunnlag.md` |

Begge ble satt til `@in-progress` for hånd 21.10.2026 (commit `ccafff0`), etter beslutning i teamet. Ingen av kravene har `@draft`- eller `@deprecated`-deler.

`local/` inneholder en råkopi av L1 fra 2026-09-30. Den er utdatert og brukes ikke lenger.

## Skisser

### Figma: Gjeldende skisser, steg 2 (brukes fra 2026-10-21)

- **URL:** https://www.figma.com/design/dlG13wATArPvG69oePHPeL/FS-Admin---Gjeldende-skisser?node-id=5163-45344
- **fileKey:** `dlG13wATArPvG69oePHPeL`
- **Node:** `5163:45344` (seksjon med fire rammer, 14697×7672)
- **Hentet:** 2026-10-21
- **Lagrede artefakter** (`sketches/figma/gjeldende-skisser/`):
  - `screenshot.png`: hele seksjonen (3000×1574)
  - `sub-frames/01-steg-2-grunnlag-vitnemalsbehandling.png`: steg 2 «Grunnlag» med vitnemålsbehandlingen
  - `sub-frames/02-vitnemal-i-ny-fane.png`: et vitnemål åpnet i ny fane
  - `sub-frames/03-sammenligne-vitnemal.png`: sammenligning av vitnemål (L5, utenfor scope)
  - `sub-frames/04-fs-klienten-i-dag.png`: skjermbilde av FS-klienten (referanse, utenfor scope)
- **Hoppet over:**
  - `get_metadata`: feilet fordi svaret var for stort. Rammene er klippet ut av et fullskala skjermbilde av seksjonen (14777×7752), ikke hentet per node, så node-ID-ene til rammene er ikke kjent.
  - `get_design_context`, `get_variable_defs` og `download_assets`: valideringen gjelder innhold, ikke kode eller designvariabler.

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
