# Manifest — krav-input

- **Kildefil:** `krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature`
- **Hentet:** 2026-09-29
- **Kilde-branch:** `main` (etter at #648 ble slått sammen), arbeidsbranch `registrere-praksis-skissevalidering`

## Filer med i scope

| Fil | Feature-ID | Status ved henting |
|---|---|---|
| [local/krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/registrere_praksis.feature](local/krav/02%20Opptak/13%20Søknad%20og%20saksbehandling/02%20Behandling/registrere_praksis.feature) | `@OPT-BEH-BEH-003` | `@must @in-progress` |

Kravet var allerede `@in-progress`. Det har ingen `@draft`- eller `@deprecated`-deler.

## Skisser

### Figma: Skisse til claude

- **URL (oppgitt):** https://www.figma.com/design/LmoNQlmAuE2FlE0fUo5GoO/FS-Admin---Seksjon-Opptak?node-id=20747-108803
- **fileKey:** `LmoNQlmAuE2FlE0fUo5GoO`
- **Node:** `20747:108803`, seksjonen «Skisse til claude» på siden «Praksiskalkulator»
- **Lagrede artefakter** (`sketches/figma/skisse-til-claude/`):
  - `screenshot.png`: hele seksjonen (3000×2084, skalert fra 3687×2536)
  - `sub-frames/01-sidelayout-i-fs-admin-pattern.png`: oversiktssiden «Praksiskalkulator» (node `20610:102740`)
  - `sub-frames/02-modal-on-background.png`: dialogen «Legg til praksisperiode» (node `21126:115199`)
  - `design-context.md`: nodehierarkiet for seksjonen, hentet med `get_metadata`
- **Hoppet over:**
  - `get_variable_defs`: valideringen gjelder innhold, ikke designvariabler.
  - `get_design_context`: spec-en trenger struktur, ikke kode, og hierarkiet fra `get_metadata` dekker det.
  - `download_assets`: skissen har bare ikoner og logo fra designsystemet, som ikke er kravrelevante.
